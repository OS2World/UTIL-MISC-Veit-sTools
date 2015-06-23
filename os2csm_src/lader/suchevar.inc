Title   Functions to access variable array

;***************************************************************************
; Eingabe:
;   FS:SI Variablenname, beendet mit einem ':' oder '='
; Ausgabe
;   Zeichenkette umgeformt in Gro·buchstaben
;   CX=LÑnge

a_proc                          bestimme_variablen_laenge
                                push2 si,ax

                                  null cx
                                  cld

  bestimme_variablen_laenge_schleife:
                                  lods byte ptr fs:[si]
                                  cmp al,':'
                                  je bestimme_variablen_laenge_ende
                                  cmp al,'='
                                  je bestimme_variablen_laenge_ende

                                  inc cx
                                  call grossbuchstabe
                                  mov fs:[si-1],al
                                  jmp bestimme_variablen_laenge_schleife

  bestimme_variablen_laenge_ende:

                                pop2 ax,si
                                ret
a_endp                          bestimme_variablen_laenge

;***************************************************************************
a_proc                          suche_variable_fs_si
                                push ds
                                  push fs
                                  pop ds
                                  call suche_variable
                                pop ds
                                ret
a_endp                          suche_variable_fs_si
;***************************************************************************

; Eingabe:
;   DS:SI Variablenname
;   CX LÑnge(Variablenname)
; Ausgabe
;   DI Zeiger auf Variable
;      0 wenn nicht vorhanden
a_proc                          suche_variable
                                push3 es,dx,ax

                                  push cs
                                  pop es
                                  mov dx,es:[anzahl_variablen] ; Anzahl Variablen
                                  mov di,es:[variablen_bereich]
                                  cld
  suche_variable_schleife:
                                  push3 cx,di,si
                                    cmp cl,es:[di].namen_laenge
                                    jne suche_variable_falsch

                                    lea di,[di].namen_zeichen
                                    rep cmpsb
  suche_variable_falsch:
                                  pop3 si,di,cx
                                  ; mov di,di
                                  ; gefunden ?
                                  je short suche_variable_ende

                                  ; nÑchste Variable
                                  add di,es:[di].blocklaenge
                                  dec dx
                                  jnz suche_variable_schleife

                                  ; keine mehr Åbrig
                                  null di
suche_variable_ende:
                                pop3 ax,dx,es
                                ret
a_endp                          suche_variable

;***************************************************************************

a_proc                          suche_variable_p8
                                push2 cx,si
                                  movzx cx,Byte Ptr [si]
                                  inc si
                                  call suche_variable
                                pop2 si,cx
                                ret
a_endp                          suche_variable_p8

;***************************************************************************
p8str name_OS2CSM_MENU          'OS2CSM_MENU'
;***************************************************************************
; Eingabe
;   DS=CS
; Ausgabe
;   al=Wert OS2CSM_MENU oder 1 wenn diese Variable nicht vorhanden ist
;
a_proc                          ermittle_wert_von_OS2CSM_MENU
                                push3 cx,si,di

                                  ; Suche Variable
                                  mov si,Offset name_OS2CSM_MENU
                                  call suche_variable_p8

                                  ; Wert, wenn nicht vorhanden
                                  mov al,[OS2CSM_MENU]

                                  ; Wert auslesen wenn vorhanden
                                  test di,di
                                  if_nz <mov ax,[di].aktuelle_einstellung>

                                  ; Wert merken (ist schneller)
                                  mov [OS2CSM_MENU],al

                                pop3 di,si,cx
                                ret
a_endp                          ermittle_wert_von_OS2CSM_MENU

;***************************************************************************
leere_zeichenkette:             db 0
p8str Int2Str_puffer            '00000'
;***************************************************************************
; AX -> DS:SI
a_proc                          Int2Str
                                pusha

                                  mov bx,5
                                  cmp ax,9999
                                  if_be <dec bx>
                                  cmp ax, 999
                                  if_be <dec bx>
                                  cmp ax,  99
                                  if_be <dec bx>
                                  cmp ax,   9
                                  if_be <dec bx>

                                  mov [si],bl         ; LÑnge
  Int2Str_schleife:
                                  mov cx,10
                                  null dx
                                  div cx

                                  add dl,'0'
                                  mov [si+bx],dl
                                  dec bx
                                  jnz Int2Str_schleife

                                popa
                                ret
a_endp                          Int2Str
;***************************************************************************
; Eingabe
;   DS:DI Variable
; Ausgabe
;   DS:SI Zeichenkette @[0]
;   CX=Maximaler vorhandener Platz >= aktuelle LÑnge
;
a_proc                          liefere_aktuellezeichenkette_der_variable
                                push2 ax,bx
                                  mov al,[di].variablentyp
                                  cmp al,variablentyp_zahl
                                  jne liefere_aktuellezeichenkette_der_variable_nicht_zahl

                                  ;;;----------------------------------
                                  ;;; boolean ?
                                  ;;cmp [di].anzahl_einstellungen,1
                                  ;;jne liefere_aktuellezeichenkette_der_variable_nicht_boolean
                                  ;;
                                  ;;mov si,(false)
                                  ;;cmp [di].aktuelle_einstellung,1
                                  ;;if_e <mov si,(true)>
                                  ;;null cx
                                  ;;mov cl,[si]
                                  ;;jmp short liefere_aktuellezeichenkette_der_variable_ende
                                  ;;;----------------------------------

                                  ;----------------------------------
  liefere_aktuellezeichenkette_der_variable_nicht_boolean:
                                  ; Zahl
                                  mov ax,[di].aktuelle_einstellung
                                  mov si,Offset Int2Str_puffer
                                  call Int2Str

                                  movzx cx,Byte Ptr [si]
                                  jmp liefere_aktuellezeichenkette_der_variable_ende
                                  ;----------------------------------


liefere_aktuellezeichenkette_der_variable_nicht_zahl:
                                  ;----------------------------------
                                  cmp al,variablentyp_zeichenkette
                                  je liefere_aktuellezeichenkette_der_variable_ZEICHENKETTE

                                  ;cmp al,variablentyp_drehfeld
                                  ;je liefere_aktuellezeichenkette_der_variable_DREHEFELD
                                  ;----------------------------------

                                  ;----------------------------------
  liefere_aktuellezeichenkette_der_variable_DREHEFELD:
                                  push ax
                                  call mov_ax_di_zeichenketteninhalt
                                  mov si,ax           ; si:=@Inhalt der Variable
                                  pop ax

                                  lodsb               ; Platz im MenÅ Åbergehen

                                  ; die zu benutzende Zeichenkette suchen
                                  mov cx,[di].aktuelle_einstellung
                                  jcxz liefere_aktuellezeichenkette_der_variable_DREHEFELD_ueberlauf

                                  mov ax,[di].anzahl_einstellungen
                                  cmp cx,ax
                                  ja liefere_aktuellezeichenkette_der_variable_DREHEFELD_ueberlauf

                                  dec cx ; 1..n
                                  jcxz liefere_aktuellezeichenkette_der_variable_DREHEFELD_ende

  liefere_aktuellezeichenkette_der_variable_DREHEFELD_schleife:
                                  null ax
                                  lodsb
                                  add si,ax
                                  loop liefere_aktuellezeichenkette_der_variable_DREHEFELD_schleife
                                  jmp short liefere_aktuellezeichenkette_der_variable_DREHEFELD_ende

  liefere_aktuellezeichenkette_der_variable_DREHEFELD_ueberlauf:
                                  mov si,Offset leere_zeichenkette

  liefere_aktuellezeichenkette_der_variable_DREHEFELD_ende:
                                  movzx cx,Byte Ptr [si]
                                  jmp short liefere_aktuellezeichenkette_der_variable_ende
                                  ;----------------------------------

                                  ;----------------------------------
  liefere_aktuellezeichenkette_der_variable_ZEICHENKETTE:
                                  push ax
                                  call mov_ax_di_zeichenketteninhalt
                                  mov si,ax           ; si:=@Inhalt der Variable
                                  pop ax
                                  mov cx,[di].anzahl_einstellungen
                                  ;----------------------------------

  liefere_aktuellezeichenkette_der_variable_ende:
                                pop2 bx,ax
                                ret
a_endp                          liefere_aktuellezeichenkette_der_variable
;***************************************************************************
a_proc                          zeichenketten_anfz_laenge_fs_si
                                push ds
                                  push fs
                                  pop ds
                                  call zeichenketten_anfz_laenge
                                pop ds
                                ret
a_endp                          zeichenketten_anfz_laenge_fs_si
;***************************************************************************
; Eingabe
;   DS:SI="Zeichenkette" oder 'Zeichenkette'
; Ausgabe
;   CX=LÑnge ohne ' oder "
;
a_proc                          zeichenketten_anfz_laenge
                                push2 si,ax
                                  lodsb
                                  mov ah,al
  zeichenketten_anfz_laenge_schleife:
                                  lodsb
                                  cmp ah,al
                                  jne zeichenketten_anfz_laenge_schleife
                                  mov cx,si
                                pop2 ax,si
                                sub cx,si
                                dec cx
                                dec cx
                                ret
a_endp                          zeichenketten_anfz_laenge
;***************************************************************************
                                ; can not assume ds=data (load_default_values)
a_proc                          mov_ax_di_zeichenketteninhalt
                                mov ax,cs:[di].zeichenketteninhalt
                                add ax,di
                                ret
a_endp                          mov_ax_di_zeichenketteninhalt
;***************************************************************************
a_proc                          mov_ax_si_zeichenketteninhalt
                                xchg si,di
                                call mov_ax_di_zeichenketteninhalt
                                xchg si,di
                                ret
a_endp                          mov_ax_si_zeichenketteninhalt
;***************************************************************************
