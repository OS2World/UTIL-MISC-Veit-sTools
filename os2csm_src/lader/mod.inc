Title   modify/interpret config.sys markup

;***************************************************************************

a_proc                          ausschrift_zeichen_page
                                call ausschrift_zeichen
                                cmp al,00dh
                                je exit_ausschrift_zeichen_page
                                push fs
                                pushad
                                  mov ah,003h
                                  mov bh,000h
                                  int 010h
                                  cmp dl,0
                                  if_e <inc zeilenzaehler>
                                popad
                                pop fs
  exit_ausschrift_zeichen_page:
                                ret
a_endp                          ausschrift_zeichen_page

;***************************************************************************

a_proc                          stosb_
                                cld
                                stosb
                                call ermittle_rollen_status
                                if_nz <call ausschrift_zeichen_page>
                                ret
a_endp                          stosb_

;***************************************************************************

mod_quellsektor_ptr             ptr1616 <?,?>
mod_quellsektor_ende            dw ?
mod_zielsektor_ptr              ptr1616 <?,?>
mod_zielsektor_ende             dw ?

ifndef memdisk
mod_quellsektor                 db 512 dup ('Q'),13,10,13,10
endif

schreibzeiger_zeilenanfang      dw ?
variablen_abfrage               db ?
OS2CSM_MENU                     db 3
zeilenzaehler                   db 4


;***************************************************************************
ifndef memdisk
                                ; es:bx
a_proc                          bearbeite_speicher
                                push ds
                                pushad

                                  push cs
                                  pop ds

                                  mov mod_quellsektor_ptr._OFF,Offset mod_quellsektor
                                  mov mod_quellsektor_ptr._SEG,cs
                                  mov mod_quellsektor_ende,Offset mod_quellsektor+512
                                  mov mod_zielsektor_ptr._OFF,bx
                                  mov mod_zielsektor_ptr._SEG,es

IFNDEF language_en
                                  call tastatur_umbelegung_einhaengen
ENDIF ; -language_en

                                  mov cx,cs:[anzahl_sektoren]
  bearbeite_speicher_schleife:

                                  mov bx,[mod_zielsektor_ptr]._OFF
                                  call teste_config_sys
                                  jnz nicht_diesen_sektor

                                  push3 ds,es,cx

                                    les di,mod_quellsektor_ptr
                                    lds si,mod_zielsektor_ptr
                                    mov cx,512/4
                                    cld
                                    rep movsd

                                  pop3 cx,es,ds

                                  call bearbeite_speicher_sektor
nicht_diesen_sektor:

                                  ifdef debug
                                  call ermittle_rollen_status
                                  jz kein_teste_config_sys_zeilenumbruch
                                  call taste
                                  call ausschrift_zeilenumbruch
  kein_teste_config_sys_zeilenumbruch:
                                  endif ; debug

                                  add mod_zielsektor_ptr._OFF,512
                                  loop bearbeite_speicher_schleife

IFNDEF language_en
                                  call tastatur_umbelegung_entfernen
ENDIF ; -language_en

                                popad
                                pop ds
                                ret
a_endp                          bearbeite_speicher

;***************************************************************************

pruefzk:                        db 'REM V.K. * OS2CFG * '
pruefzk_ende:

; assuming 64 KiB config.sys limit, makes 128 sectors
config_sys_sectors_seen         db (128/8) dup (0)      ; 128 bits
config_sys_sectors_last         dw 0                    ; zero based last sector number

;***************************************************************************

; -> CF=1 if not seen all sectors at least once
a_proc                          have_seen_all_config_sys_sectors
                                pusha
                                  mov cx,config_sys_sectors_last
                                  inc cx
                                  mov al,1
                                  sub di,di
  @@loop:
                                  test config_sys_sectors_seen[di],al
                                  stc
                                  jz @@exit
                                  rol al,1
                                  if_c <inc di>
                                  loop @@loop

                                  clc
  @@exit:
                                popa
                                ret
a_endp                          have_seen_all_config_sys_sectors

;***************************************************************************
                                ; es:bx
                                ; ds=cs
a_proc                          teste_config_sys
                                pusha

                                  ifdef debug

                                  mov ax,es
                                  call ausschrift_word
                                  mov al,':'
                                  call ausschrift_zeichen_page
                                  mov ax,bx
                                  call ausschrift_word
                                  mov al,' '
                                  call ausschrift_zeichen_page
                                  call dump_anfang

                                  endif ; debug

                                  mov si,Offset pruefzk
                                  mov di,bx
                                  mov cx,(Offset pruefzk_ende)-(Offset pruefzk)
                                  cld
                                  repz cmpsb
                                  jne teste_config_sys_ende

                                  push ds
                                    push es
                                    pop ds
                                    mov si,di
                                    call lies_dezimalzahl
                                  pop ds

                                  ; have config.sys sector ax (zero based)
                                  ; set this information in bitmap
                                  pusha
                                    mov di,ax
                                    mov cl,al
                                    and cl,7
                                    shr di,3
                                    mov al,1
                                    rol al,cl
                                    or config_sys_sectors_seen[di],al
                                  popa

                                  ; increase config_sys_sectors_last if needed.
                                  ; the last sector has different ending markup
                                  ; so i can tell that at least one more sectors is needed
                                  ; when this is not the last sector

                                  push ax
                                    cmp word ptr es:[bx+512-2],00a0dh
                                    jne @@dont_excpect_more_sectors
                                    cmp byte ptr es:[bx+512-3],'+'
                                    jne @@dont_excpect_more_sectors
                                    inc ax
  @@dont_excpect_more_sectors:
                                    cmp cs:config_sys_sectors_last,ax
                                    if_b <mov cs:config_sys_sectors_last,ax>
                                  pop ax

                                  ifdef debug ;----------------------
                                  push ax
                                    push ax
                                      mov al,'('
                                      call ausschrift_zeichen_page
                                    pop ax
                                    call ausschrift_word
                                    mov al,'/'
                                    call ausschrift_zeichen_page
                                    mov ax,cs:[config_sys_sectors_last]
                                    call ausschrift_word
                                    mov al,')'
                                    call ausschrift_zeichen_page
                                    call ermittle_rollen_status
                                    if_nz <call taste>
                                  pop ax

                                  endif ; debug ------------------

                                  mov si,ax
                                  add si,ax
                                  mov ax,word ptr sektor_tabelle[si]
                                  test ax,ax
                                  jz nicht_von_ab_laden



                                  ;mov es,es
                                  ;mov bx,bx
                                  call lies_sektor_b
  nicht_von_ab_laden:

                                  cmp ax,ax ; ZF=1
  teste_config_sys_ende:

                                popa
                                ret
a_endp                          teste_config_sys
endif ; -memdisk
;***************************************************************************

a_proc                          bearbeite_speicher_sektor
                                push es
                                push fs
                                pusha

                                  lfs si,[mod_quellsektor_ptr]
                                  mov bp,[mod_quellsektor_ende]
                                  les di,[mod_zielsektor_ptr]


                                  ; Zeilenanfang nein=0 ja=1
                                  mov ah,1

  bearbeite_speicher_sektor_schleife:
                                  cmp si,bp
                                  jae bearbeite_speicher_sektor_ende

                                  ; Zeiger auf Zeilenanfang merken
                                  cmp ah,000h
                                  if_ne <mov [schreibzeiger_zeilenanfang],di>


                                  ; nÑchstes Zeichen laden
                                  cld
                                  lods byte ptr fs:[si]
                                  ; Fragezeichen am Zeilenanfang (ah=001h)
                                  cmp ax,'?'+00100h
                                  jne nicht_frage

                                  ; Frage stellen und bei Verneinung
                                  ; Auskommentieren des
                                  ; Zeilenrestes mit 'REM '
                                  call frage
                                  jmp bearbeite_speicher_sektor_schleife

  nicht_frage:
                                  ; Startmarkierung einer Variable ?
                                  cmp al,'^'
                                  jne nicht_variable

                                  call ersetze_variable
                                  jmp bearbeite_speicher_sektor_schleife

  nicht_variable:
                                  ; Zeichen kopieren
                                  call stosb_
                                  ; Erkennung des Zeilenendes
                                  mov ah,0
                                  cmp al,10
                                  jne bearbeite_speicher_sektor_schleife

                                  ; Zeilenende ----------------------
                                  call bearbeite_echo_befehl
                                  push ds
                                    push bios0040
                                    pop ds
                                    mov al,Byte Ptr ds:[number_of_lines_less1]
                                  pop ds

                                ;-inc zeilenzaehler-wird schon in stosb_ erhîht
                                  cmp zeilenzaehler,al
                                  if_nb <call more_prompt>
                                  mov ah,1
                                  jmp bearbeite_speicher_sektor_schleife

  bearbeite_speicher_sektor_ende:
                                  ; Quellpuffer und Zielpuffer sind gleich lang.
                                  mov cx,bp
                                  sub cx,mod_quellsektor_ptr._OFF
                                  add cx,mod_zielsektor_ptr._OFF
                                  sub cx,di ; cx ist nun Anzahl der verbleibende Zeichen Platz

ifdef memdisk
                                  ; FÅllen mit ^Z
                                  mov mod_zielsektor_ende,di
                                  mov al,26
                                  cld
                                  rep stosb
else
                                  ; Zeilenumbruch lîschen
                                  dec di
                                  dec di
                                  ; Leerzeichen an 'REM ... ' Zeile anhÑngen
                                  mov al,' '
                                  cld
                                  rep stosb

                                  ; Byte 511/512: Zeilenumbruch
                                  mov al,13
                                  stosb
                                  mov al,10
                                  stosb
endif
                                  call more_prompt

IFNDEF memdisk
                                  ; uninstall filter, if all sectors have been processed.
                                  call have_seen_all_config_sys_sectors
                                  if_nc <call int10und13_entfernen>
ENDIF ; not memdisk

                                popa
                                pop fs
                                pop es
                                ret
a_endp                          bearbeite_speicher_sektor

;***************************************************************************

a_proc                          more_prompt
                                pusha

                                  call ermittle_rollen_status
                                  jz keine_pause

                                  mov si,Offset text_pause_weiter
                                  call ausschrift_p8
                                  call taste
                                  call ausschrift_zeilenumbruch
                                  mov zeilenzaehler,4
  keine_pause:
                                popa
                                ret
a_endp                          more_prompt

;***************************************************************************

                                ; fs:si=@('?"Frage"...)+1
a_proc                          frage
                                push bx
                                  call spalte1_in_leerer_zeile
                                  cld
                                  lods byte ptr fs:[si] ; '"'
  frage_anzeige_schleife:
                                  cld
                                  lods byte ptr fs:[si]
                                  cmp al,'"'
                                  je frage_stellen
                                  call ausschrift_zeichen_page
                                  jmp frage_anzeige_schleife
  frage_stellen:
                                  call frage_benutzer_ja_nein
                                  cmp al,'j'
                                  ; der Rest der Zeile wird als normale Zeile
                                  ; bei ja abgearbeitet (und angezeigt)
                                  je exit_frage


                                  call ermittle_rollen_status
                                  jnz zeile_auskommnetieren_mit_anzeige


                                  ; stumm bis zum Zeilenende lesen
  frage_suche_zeilenende_stumm:
                                  lods byte ptr fs:[si]
                                  cmp al,13
                                  jne frage_suche_zeilenende_stumm
                                  dec si
                                  jmp exit_frage

  zeile_auskommnetieren_mit_anzeige:
                                  ; "REM " in hellblau
                                  mov bl,009h
                                  xchg [farbe],bl

                                  push si
                                    mov si,Offset text_REM_
                                    call ausschrift_p8
                                  pop si

                                  ; der Rest in dunkelgrau
                                  mov [farbe],008h
  frage_suche_zeilenende_laut:
                                  lods byte ptr fs:[si]
                                  cmp al,13
                                  je frage_suche_zeilenende_laut_ende
                                  call ausschrift_zeichen_page
                                  jmp frage_suche_zeilenende_laut
  frage_suche_zeilenende_laut_ende:

                                  dec si ; Zeilenzahl erhalten

                                  mov [farbe],bl
  exit_frage:
                                pop bx
                                ret
a_endp                          frage

;***************************************************************************

p8str text_REM_                 'REM '

;***************************************************************************

; DEVICE=TEST.SYS ^AI:1:/1^^AI:2:/2^
; SET USER=^USER:***********^
; fÅr Drehfeldvariablen kînnen beide Varianten auftreten

                                ; fs:si/es:di
a_proc                          ersetze_variable
                                push4 ax,bx,cx,dx

                                  lea bx,fs:[si-1] ; zur Berechnung des zur
                                                ; VerfÅgung stehenden Platzes

                                  mov dx,di     ; di (Schreibposition) merken

                                  mov [variablen_abfrage],0

                                  ; Soll Variableninhalt hier nochmal Ñnderbar sein ?
                                  cmp byte ptr fs:[si],'?'
                                  jne ersetze_variable_ohne_fragezeichen

                                  inc si

                                  call pruefe_ob_rem_am_zeilenanfang
                                  jz keine_eingabe_weil_kommentar_am_zeilenanfang

                                  cmp [OS2CSM_MENU],3
                                  if_e <mov [variablen_abfrage],1>

  keine_eingabe_weil_kommentar_am_zeilenanfang:

  ersetze_variable_ohne_fragezeichen:

                                  ; Suche Variable ...
                                  ; 1. LÑnge bestimmen und Gro·buchstaben
                                  call bestimme_variablen_laenge
                                  ; 2. Variable suchen
                                  call suche_variable_fs_si
                                  test di,di
                                  jnz ersetze_variable__bekannt

                                  ;----------------------------------
                                  ; Anzeige des Namens der nicht gefundenen
                                  ; Variable (rot)
                                  call ermittle_rollen_status
                                  jz keine_unbekannte_variablenname_anzeige

                                  push2 si,bx
                                    mov bl,00ch
                                    xchg [farbe],bl

                                    mov al,'['
                                    call ausschrift_zeichen_page

                                    call ausschrift_l_cx_FS_SI

                                    mov al,'?'
                                    call ausschrift_zeichen_page
                                    mov al,']'
                                    call ausschrift_zeichen_page

                                    mov [farbe],bl
                                  pop2 bx,si
  keine_unbekannte_variablenname_anzeige:
                                  jmp ersetze_variable__unbekannt_weiter
                                  ;----------------------------------

  ersetze_variable__bekannt:
                                  ; Gefunden ...

                                  ; Variablennamen Åberlesen
                                  fs_lodsb_bis2 '=',':'

                                  ; entwerder ^HPFS:1:1024^
                                  ; oder      ^HPFS:****^
                                  cmp byte ptr fs:[si],'*'
                                  jne nicht_ersetze_variable_mit_dem_inhalt

                                  ;----------------------------------
                                  ; Anzeige des Variablennamens
                                  pusha
                                    call ermittle_rollen_status
                                    jz keine_variablen_bildschirm_anzeige_name

                                    mov bl,00eh
                                    xchg [farbe],bl

                                    mov al,'['
                                    call ausschrift_zeichen_page

                                    call ausschrift_variablenname

                                    mov al,':'
                                    call ausschrift_zeichen_page
                                    mov al,']'
                                    call ausschrift_zeichen_page

                                    mov [farbe],bl

  keine_variablen_bildschirm_anzeige_name:
                                  popa
                                  ;----------------------------------


                                  ;----------------------------------
                                  ; énderungsmîglichkeit ?
                                  cmp [variablen_abfrage],1
                                  jne ersetze_variable_mit_dem_inhalt_keine_Aendrungsmoeglichkeit
                                  cmp [di].variablentyp,variablentyp_zeichenkette
                                  jne ersetze_variable_mit_dem_inhalt_keine_Aendrungsmoeglichkeit
                                  call zeichenketteneingabe
  ersetze_variable_mit_dem_inhalt_keine_Aendrungsmoeglichkeit:

                                  ; Bestimmung des zur VerfÅgung stehenden Platzes
                                  fs_lodsb_bis '^'
                                  mov cx,si
                                  sub cx,bx             ; cx:=Zeichen Platz

                                  push2 si,bx
                                    mov bl,00ah
                                    xchg [farbe],bl

                                    push cx
                                      call liefere_aktuellezeichenkette_der_variable
                                    pop cx

                                    ; Min(Platz,LÑnge)
                                    null ax
                                    lodsb
                                    cmp cx,ax
                                    if_a <mov cx,ax>

                                    mov di,dx

                                    jcxz ersetze_variable_mit_dem_inhalt__ende
  ersetze_variable_mit_dem_inhalt__schleife:
                                    lodsb
                                    call stosb_
                                    loop ersetze_variable_mit_dem_inhalt__schleife
  ersetze_variable_mit_dem_inhalt__ende:

                                    mov [farbe],bl
                                  pop2 bx,si
                                  jmp ersetze_variable__ende
                                  ;----------------------------------

                                  ;**********************************

  nicht_ersetze_variable_mit_dem_inhalt:

                                  ;----------------------------------
                                  ; Folge von "Wert" oder Zahl
                                  ; getrennt durch Komma, Ende mit Doppelpunkt
  versuche_naechsten_Teil_der_Aufzaehlung:

                                  cmp byte ptr fs:[si],'"'
                                  je ersetze_variable_aufzaehlungsfall_zeichenkette
                                  cmp byte ptr fs:[si],"'"
                                  je ersetze_variable_aufzaehlungsfall_zeichenkette

                                  ; es sollte eine gÅltige Zahl folgen
                                  ; Variable=Zahl oder Drehfeld

                                  ; eine Zahl und ein Zeichenkette sind nicht
                                  ; miteinander zu vergleichen -> Abbruch
                                  cmp [di].variablentyp,variablentyp_zeichenkette
                                  je ersetze_variable__falscher_wert

                                  ; lies die in der Config.sys angegebene Zahl (fs:si)
                                  push ds
                                    push fs
                                    pop ds
                                    call lies_dezimalzahl
                                  pop ds

                                  ; ':' oder ',' Åbergehen
                                  inc si

                                  ;----------------------------------
                                  pusha
                                    call ermittle_rollen_status
                                    jz keine_variablen_bildschirm_anzeige_zahl

                                    mov bl,00eh
                                    xchg [farbe],bl

                                    push ax

                                      mov al,'['
                                      call ausschrift_zeichen_page

                                      call ausschrift_variablenname

                                      mov al,'='
                                      call ausschrift_zeichen_page

                                      mov ax,[di].aktuelle_einstellung
                                      call ausschrift_zahl

                                      mov si,Offset text_leer_fragezeichen_leer
                                      call ausschrift_p8

                                    pop ax ; gelesene Dezimalzahl
                                    call ausschrift_zahl

                                    mov al,']'
                                    call ausschrift_zeichen_page

                                    mov [farbe],bl

                                    ifdef debug
                                    call ermittle_rollen_status
                                    if_nz <call taste>
                                    endif

  keine_variablen_bildschirm_anzeige_zahl:
                                  popa
                                  ;----------------------------------

                                  ; pa·t Variable ?
                                  cmp ax,[di].aktuelle_einstellung
                                  je ersetze_variable__richtiger_wert

  ersetze_variable_aufzaehlungsfall_vielleicht_naechstes_element:
                                  ; noch 2 und 3 bei "^HPFS:1,2,3:IFS=.." probieren
                                  cmp byte ptr fs:[si-1],','
                                  je versuche_naechsten_Teil_der_Aufzaehlung

                                  ; keine zum gewÑhlten MenÅ passende Zahl gefunden
                                  jmp ersetze_variable__falscher_wert
                                  ;----------------------------------

                                  ;----------------------------------
  ersetze_variable_aufzaehlungsfall_zeichenkette:
                                  ; eine Zahl und ein Zeichenkette sind nicht
                                  ; miteinander zu vergleichen -> Abbruch
                                  cmp [di].variablentyp,variablentyp_zahl
                                  je ersetze_variable__falscher_wert

                                  ; CX<-LÑnge
                                  call zeichenketten_anfz_laenge_fs_si
                                  cmp cx,80 ; Fehler ?
                                  ja ersetze_variable__falscher_wert

                                  ; Anzeige des Variablennamens
                                  ; und wirklichen Inhaltes
                                  pusha
                                    call ermittle_rollen_status
                                    jz keine_variablen_bildschirm_anzeige_zeichenkette1

                                    mov bl,00eh
                                    xchg [farbe],bl

                                    push2 cx,si

                                      mov al,'['
                                      call ausschrift_zeichen_page

                                      call ausschrift_variablenname

                                      mov al,'='
                                      call ausschrift_zeichen_page

                                      mov al,'"'
                                      call ausschrift_zeichen_page

                                      call liefere_aktuellezeichenkette_der_variable
                                      call ausschrift_p8

                                      mov al,'"'
                                      call ausschrift_zeichen_page

                                      mov si,Offset text_leer_fragezeichen_leer
                                      call ausschrift_p8

                                      mov al,'"'
                                      call ausschrift_zeichen_page

                                    pop2 si,cx

                                    inc si
                                    call ausschrift_l_cx_FS_SI

                                    mov al,'"'
                                    call ausschrift_zeichen_page
                                    mov al,']'
                                    call ausschrift_zeichen_page

                                    mov [farbe],bl

                                    ifdef debug
                                    call ermittle_rollen_status
                                    if_nz <call taste>
                                    endif

  keine_variablen_bildschirm_anzeige_zeichenkette1:
                                  popa

                                  ; Vergleichen ...
                                  ; "config.sys_wert"=FS:SI,CX
                                  inc si ; '"' Åbergehen
                                  push ds
                                  push es
                                  pusha

                                    push2 si,cx
                                      call liefere_aktuellezeichenkette_der_variable
                                      push cs
                                      pop ds
                                      ; ->ds:SI
                                    pop2 cx,di

                                    push fs
                                    pop es

                                    ; p8 bei DS:SI mit ES:DI,CX vergleichen

                                    ; LÑnge ...
                                    null ax
                                    cld
                                    lodsb
                                    cmp ax,cx
                                    jne ersetze_variable_aufzaehlungsfall_zeichenkette_vergleich_ende

                                    ; Inhalt ...
                                    rep cmpsb

  ersetze_variable_aufzaehlungsfall_zeichenkette_vergleich_ende:
                                  popa
                                  pop es
                                  pop ds
                                  jz ersetze_variable__richtiger_wert

                                  ; Inhalt + '"' + ',' Åbergehen
                                  add si,cx
                                  inc si
                                  inc si
                                  jmp ersetze_variable_aufzaehlungsfall_vielleicht_naechstes_element
                                  ;----------------------------------

  ersetze_variable__richtiger_wert:
                                  ; Wenn ^HPFS:1,2,3:IFS=.. angeben ist
                                  ; und HPFS=1 dann ",2,3:" Åbergehen
                                  dec si
  schleife_suche_ersatzzeichenfolge:
                                  cld
                                  lods byte ptr fs:[si]
                                  cmp al,':'
                                  je ersatzzeichenfolge_erreicht

                                  cmp al,'"'
                                  je schleife_suche_ersatzzeichenfolge_findstringend
                                  cmp al,"'"
                                  jne schleife_suche_ersatzzeichenfolge
  schleife_suche_ersatzzeichenfolge_findstringend:
                                  ; search ending " or '
                                  mov ah,al
                                  fs_lodsb_bis ah
                                  ; now search again for :
                                  jmp schleife_suche_ersatzzeichenfolge

  ersatzzeichenfolge_erreicht:
                                  ; "IFS=.." erreicht

                                  mov di,dx
                                  push bx
                                    mov bl,00ah
                                    xchg [farbe],bl
  ersetze_variable__kopiere_zeichenkette:

                                    lods byte ptr fs:[si]
                                    ; alles bis zum "^" kopieren
                                    cmp al,'^'
                                    je ersetze_variable__ende_pop_farbe
                                    call stosb_
                                    jmp ersetze_variable__kopiere_zeichenkette

  ersetze_variable__ende_pop_farbe:
                                    mov [farbe],bl
                                  pop bx

  ersetze_variable__ende:
                                pop4 dx,cx,bx,ax
                                ret

  ersetze_variable__falscher_wert:
  ersetze_variable__unbekannt_weiter:
                                  mov di,dx

                                  call ermittle_rollen_status
                                  jnz ersetze_variable__fehler_anzeige

                                  ; alles bis zum "^" Åbergehen
                                  fs_lodsb_bis '^'
                                  jmp ersetze_variable__ende

  ersetze_variable__fehler_anzeige:
                                  push bx
                                    mov bl,008h
                                    xchg [farbe],bl
  ersetze_variable__fehler_anzeige1:
                                    lods byte ptr fs:[si]
                                    cmp al,'^'
                                    je ersetze_variable__fehler_anzeigee

                                    call ausschrift_zeichen_page
                                    jmp ersetze_variable__fehler_anzeige1

  ersetze_variable__fehler_anzeigee:
                                    mov [farbe],bl
                                  pop bx
                                  jmp ersetze_variable__ende

a_endp                          ersetze_variable

;***************************************************************************
; Ausgabe
;   ah=undefiniert
;   al='j' oder 'n'
;

a_proc                          frage_benutzer_ja_nein
                                push si
                                  mov si,Offset text_ja_nein
                                  call ausschrift_p8
  frage_benutzer_ja_nein_schleife:
                                  call taste
                                  or al,020h    ; 'N' -> 'n' ..

                                  cmp al,key_yes ; Ja/Yes/S°/Oui
                                  jne not_key_yes
                                  mov al,'j'
                                  jmp frage_benutzer_ja_nein_fertig
  not_key_yes:
                                  cmp al,key_no  ; Nein/No/No/Non
                                  jne frage_benutzer_ja_nein_schleife
                                  mov al,'n'
  frage_benutzer_ja_nein_fertig:
                                  call ausschrift_zeilenumbruch

                                  mov ah,0

                                pop si
                                ret
a_endp                          frage_benutzer_ja_nein

;***************************************************************************
; Eingabe
;   es:di=Schreibposition
;   schreibzeiger_zeilenanfang=Zeilenanfang
; Ausgabe
;   ZF=1 wenn 'REM ' am Zeilenanfang geschrieben wurde
;   ZF=0 sonst
;


a_proc                          pruefe_ob_rem_am_zeilenanfang
                                pusha
                                push ds
                                push es

                                  ; kann kein REM finden was noch nicht
                                  ; geschrieben wurde (alter Pufferinhalt)
                                  mov ax,di

                                  ; zu prÅfende Stelle
                                  mov si,[schreibzeiger_zeilenanfang]
                                  sub ax,si
                                  push es
                                  pop ds

                                  ; Vergleichsfolge
                                  mov di,Offset text_REM_
                                  push cs
                                  pop es
                                  movzx cx,byte ptr es:[di]
                                  cmp ax,cx
                                  setae al
                                  cmp al,1 ; lang genug ?
                                           ; nein, Ende mit ZF=0
                                  if_z <call vergleiche_zeichenfolge_p8_grossklein>

                                pop es
                                pop ds
                                popa
                                ret
a_endp                          pruefe_ob_rem_am_zeilenanfang

;***************************************************************************

p8str text_ja_nein              msg_yes_no
p8str text_pause_weiter         msg_key_to_continue

p8str text_leer_fragezeichen_leer ' ? '

;***************************************************************************

