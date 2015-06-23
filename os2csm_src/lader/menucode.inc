Title   code to let menu screens work

;***************************************************************************
; Behandlung von Tastatureingaben fÅr das MenÅ
;***************************************************************************
a_proc                  bestimme_menu_zeiger_si
                        push cx
                          mov cx,[menu_position]
                          call liefere_variablen_adresse
                        pop cx
                        ret
a_endp                  bestimme_menu_zeiger_si
;***************************************************************************

; dx=richtung(-1,0,+1)

a_proc                  suche_naechste_sichtbare_variable
                        pusha

  suche_naechste_sichtbare_variable_schleife:

                          cmp dx,+1
                          je suche_naechste_sichtbare_variable_01
                          cmp dx,-1
                          je suche_naechste_sichtbare_variable_ff

                          ;------------------------------------------

  suche_naechste_sichtbare_variable_00:
                          inc dx
                          jmp suche_naechste_sichtbare_variable_weiter

                          ;------------------------------------------

  suche_naechste_sichtbare_variable_01:
                          mov [editor_position],0

                          mov ax,[menu_position]
                          ; letzter Block ?
                          cmp [anzahl_variablen],ax
                          if_e <null ax>
                          inc ax
                          mov [menu_position],ax
                          jmp suche_naechste_sichtbare_variable_weiter

                          ;------------------------------------------

  suche_naechste_sichtbare_variable_ff:

                          mov [editor_position],0

                          mov ax,[menu_position]
                          dec ax
                          ; 0->letzter Block
                          if_z <mov ax,[anzahl_variablen]>
                          mov [menu_position],ax
                          ;jmp short suche_naechste_sichtbare_variable_weiter

                          ;------------------------------------------

  suche_naechste_sichtbare_variable_weiter:
                          call bestimme_menu_zeiger_si
                          cmp [si].seitennummer,0
                          je suche_naechste_sichtbare_variable_schleife

                          ; Wenn sich die Seite geÑndert hat, mu·
                          ; der Bildschirm vollstÑndig neu gezeichnet werden
                          mov al,[si].seitennummer
                          cmp al,[aktuelle_menue_seite]
                          je suche_naechste_sichtbare_variable_keine_seitenaenderung

                          mov [vollstaendigneuzeichnen],1
                          mov [aktuelle_menue_seite],al

  suche_naechste_sichtbare_variable_keine_seitenaenderung:

                        popa
                        ret
a_endp                  suche_naechste_sichtbare_variable

;***************************************************************************

menu_position_sicherung dw ?

; dx=Richtung(-1,+1)

a_proc                  passe_variable_an_seite_an
                        pusha

                          mov ax,[menu_position]
                          mov [menu_position_sicherung],ax

                          ; ZÑhler
                          mov cx,[anzahl_variablen]

                          ; alte Seitennummer
                          mov bl,[aktuelle_menue_seite]

  passe_variable_an_seite_an_schleife:
                          call bestimme_menu_zeiger_si
                          cmp [si].seitennummer,bl
                          jne passe_variable_an_seite_an_ende

                          ;mov dx,dx
                          call suche_naechste_sichtbare_variable

                          loop passe_variable_an_seite_an_schleife

                          ; immernoch auf der selben Seite
                          ; -> zurÅck zur ursprÅnglichen Variable
                          mov ax,[menu_position_sicherung]
                          mov [menu_position],ax

  passe_variable_an_seite_an_ende:
                        popa
                        ret
a_endp                  passe_variable_an_seite_an

;***************************************************************************
; Eingabe
;   ax=Taste
; Ausgabe
;   ax=0 wenn Tastendruck Wirkung hatte

a_proc                  vergleiche_drehfeld_sprungtaste

                        push4 bx,cx,dx,di

                          call bestimme_menu_zeiger_si

                          ; hier werden nur Drehfelder behandelt
                          cmp [si].variablentyp,variablentyp_drehfeld
                          jne vergleiche_drehfeld_sprungtaste_ende

                          ; FÅr jede mîgliche Einstellung den Anfangsbuchstaben ermitteln
                          mov bx,[si].anzahl_einstellungen
                          push2 ax,si

                            ; si:=Anfang zeichenketteninhalt
                            call mov_ax_si_zeichenketteninhalt
                            mov si,ax

                            inc si                      ; Feld fÅr maximale LÑnge Åbergehen

                            ; Ziel: Feld aller Anfangsbuchstaben
                            mov di,Offset zeichenketten_zwischenspeicher

  vergleiche_drehfeld_sprungtaste_suche_ersten_buchstaben_elementanfang:
                            cmp bx,0                    ; kein weiteres Element
                            je vergleiche_drehfeld_sprungtaste_suche_ersten_buchstaben_ende

                            lodsb                       ; LÑngenfeld
                            movzx cx,al

                            dec bx                      ; 1 Element weniger vorhanden
                            inc di                      ; neuer Platz fÅr den Anfangsbuchstaben
                            mov byte ptr [di],0         ; "keine" Taste

  vergleiche_drehfeld_sprungtaste_suche_ersten_buchstaben_schleife:
                            ; Ende des Feldelementes ?
                            jcxz vergleiche_drehfeld_sprungtaste_suche_ersten_buchstaben_elementanfang

                            lodsb                       ; 1 Zeichen laden
                            dec cx                      ; 1 Zeichen im Element abgearbeitet
                            cmp al,' '                  ; fÅhrende Leerzeichen Åbergehen
                            je vergleiche_drehfeld_sprungtaste_suche_ersten_buchstaben_schleife

                            call grossbuchstabe
                            mov [di],al                 ; Zeichen merken

                            add si,cx                   ; restliche Zeichen Åbergehen
                            null cx                     ; keine Zeichen mehr Åbrig
                            jmp vergleiche_drehfeld_sprungtaste_suche_ersten_buchstaben_schleife


  vergleiche_drehfeld_sprungtaste_suche_ersten_buchstaben_ende:

                          pop2 si,ax


                          mov cx,[si].anzahl_einstellungen
                          mov di,Offset zeichenketten_zwischenspeicher
                          mov bx,[si].aktuelle_einstellung

                          ; Gro·buchstabe der Taste bilden (dl)
                          push ax
                            call grossbuchstabe
                            mov dl,al
                          pop ax

  vergleiche_drehfeld_sprungtaste_vergeleichschleife:
                          inc bx                        ; zum Naechstes Element
                          cmp bx,[si].anzahl_einstellungen
                          if_a <mov bx,1>               ; endlose Kette

                          jcxz vergleiche_drehfeld_sprungtaste_nicht_gefunden

                          dec cx                        ; 1 Versuch weniger

                          cmp dl,byte ptr ds:[di+bx]
                          jne vergleiche_drehfeld_sprungtaste_vergeleichschleife

                          ; gefunden -> Wert Ñndern
                          mov [si].aktuelle_einstellung,bx

                          ; die Taste wurde behandelt
                          null ax

  vergleiche_drehfeld_sprungtaste_nicht_gefunden:

  vergleiche_drehfeld_sprungtaste_ende:
                        pop4 di,dx,cx,bx
                        ret
a_endp                  vergleiche_drehfeld_sprungtaste

;***************************************************************************

p8str name_menu_beenden_zulaessig 'OS2CSM_ACCEPT_MENU'
p8str name_esc_abgeschaltet       'OS2CSM_ESC_DISABLED'
p8str name_os2csm_spinbutton_distance 'OS2CSM_SPINBUTTON_DISTANCE'
p8str name_os2csm_font_redefinition   'OS2CSM_FONT_REDEFINITION'

;***************************************************************************

a_proc                  menu_bearbeiten
                        pusha

                            mov [vollstaendigneuzeichnen],1

                            ; ZeichsatzÑnderung erlaubt?
                            mov si,Offset name_os2csm_font_redefinition
                            call suche_variable_p8
                            test di,di
                            jz no_os2csm_font_redefinition_change
                            mov ax,[di].aktuelle_einstellung
                            mov allow_boolean_redefinition,al
  no_os2csm_font_redefinition_change:

                            ; gewÅnschten Abstand zum Pfeil merken
                            mov si,Offset name_os2csm_spinbutton_distance
                            call suche_variable_p8
                            test di,di
                            jz no_os2csm_spinbutton_distance_change
                            mov ax,[di].aktuelle_einstellung
                            shl ax,1 ; *2 Byte je Bildschirmfeld
                            mov os2csm_spinbutton_distance,ax
  no_os2csm_spinbutton_distance_change:

                            null dx
                            call suche_naechste_sichtbare_variable

  menu_bearbeiten_hauptschleife:
                            mov [abbruch],false
                            mov putkey,0ffffh
                            call berechne_abhaengigkeiten
                            call menu_zeichnen
                            call zeichne_editor_cursor

                            call taste_mit_zeitgrenze
  taste_verarbeiten:
                            cmp ax,0ffffh
                            je jmp_menu_bearbeiten_hauptschleife_ende1

                            cmp ax,[eingabetaste_sc]    ; 13
                            je jmp_menu_bearbeiten_hauptschleife_ende1


                            ;----------------------------------------
                            ; Standardwerte ?
                            cmp ax,[reset_sc]
                            jne nicht_standardwerte_einstellen

                            ; Nachfrage
                            mov [vollstaendigneuzeichnen],1
                            mov si,Offset menu_reset_beschreibung
                            cmp [si].bildschirm_zeilen_belegt,0
                            je standardwerte_einstellen_bestaetigt
                            mov cx,1 ; es gibt nur eine Seite
                           ;mov si,si
                            call bildschirm_laden_durchsichtig
  standardwerte_einstellen_taste:
                            call taste_mit_zeitgrenze
                            cmp ax,menu_reset_no_sc
                            je standardwerte_einstellen_abgelehnt
                            cmp ax,menu_reset_yes_sc
                            jne standardwerte_einstellen_taste
  standardwerte_einstellen_bestaetigt:
                            call load_default_values
  standardwerte_einstellen_abgelehnt:
                            jmp menu_bearbeiten_hauptschleife
  nicht_standardwerte_einstellen:
                            ;
                            ;----------------------------------------

                            ;----------------------------------------
                            ; andere Verwendung der Eingabetaste
                            cmp al,13
                            jne nicht_eingabetaste

                            ; nÑchstes Feld
                            mov ax,00f09h ; Tab
                            ; oder nÑchste Seite (mehrseitig)
                            cmp [anzahl_bildschirmseiten],1
                            if_a <mov ax,05100h> ; Bild ab

                            ;----------------------------------------

  nicht_eingabetaste:
                            ;----------------------------------------
                            ;cmp al,27
                            cmp ax,[escape_sc]
                            jne nicht_escape

                            ; [Esc] ist abschaltbar
                            mov si,Offset name_esc_abgeschaltet
                            call suche_variable_p8
                            null ax ; abgeschaltet=falsch wenn nicht vorhanden
                            test di,di
                            if_nz <mov ax,[di].aktuelle_einstellung>
                            cmp al,1 ; abgeschaltet -> ignorieren
                            je menu_bearbeiten_hauptschleife
                            mov [abbruch],true
  jmp_menu_bearbeiten_hauptschleife_ende1:
                            jmp menu_bearbeiten_hauptschleife_ende
  nicht_escape:
                            ;----------------------------------------

                            ;----------------------------------------
                            ; F11->Standardwerte
                            cmp ax,[reset_sc]
                            jne nicht_reset_default
                            ; Nachfragen ?
                            mov si,Offset menu_reset_beschreibung
                            cmp [si].bildschirm_zeilen_belegt,0
                            je reset_default_ja

                            mov cx,1 ; es gibt nur eine Seite
                           ;mov si,si
                            call bildschirm_laden_durchsichtig
  reset_default_frage:
                            call taste_mit_zeitgrenze
                            cmp ax,menu_reset_no_sc
                            je reset_default_nein
                            cmp ax,menu_reset_yes_sc
                            jne reset_default_frage
  reset_default_ja:
                            call load_default_values
  reset_default_nein:
                            mov [vollstaendigneuzeichnen],1
                            jmp menu_bearbeiten_hauptschleife
  nicht_reset_default:
                            ;----------------------------------------

                            ;----------------------------------------
                            ; F1 - Hilfe (MemDisk)
                            cmp ax,[help_sc]
                            jne nicht_f1

                            mov [vollstaendigneuzeichnen],1
                            call hilfe_anzeigen
                            jmp menu_bearbeiten_hauptschleife
  nicht_f1:
                            ;----------------------------------------

                            ;----------------------------------------
                            ; ALT-F1/F2/../F10 Ñhnlich wie Enter
                            ;
                            cmp al,0
                            jne nicht_alt_f1_f2_f10
                            cmp ah,068h         ; ALT-F1
                            jb nicht_alt_f1_f2_f10
                            cmp ah,071h         ; ALT-F10
                            ja nicht_alt_f1_f2_f10

                            ;in den Tastaturpuffer fÅr OS/2 einfÅgen
                            mov putkey,ax
                            jmp menu_bearbeiten_hauptschleife_ende
                            ;----------------------------------------

                          nicht_alt_f1_f2_f10:
                            ;----------------------------------------
                            ; Strg-F5  - BIOS Bildschirm "Alt+F5" betrachten
                            ;
                            cmp ax,[alt_f5_sc]
                            jne nicht_alt_f5

                            mov dx,Offset altf5_palette
                            call setze_palette

                            mov cx,1 ; es gibt nur eine Seite
                            mov si,Offset altf5_bildschirm_beschreibung
                            cmp [os2boot_sicherung].bildschirm_zeilen_belegt,0
                            if_ne <mov si,Offset os2boot_sicherung>
                            call bildschirm_laden

                            call taste

                            mov dx,Offset menu_palette
                            call setze_palette

                            mov [vollstaendigneuzeichnen],1
                            jmp menu_bearbeiten_hauptschleife
                            ;----------------------------------------

                          nicht_alt_f5:
                            ;----------------------------------------
                            ; Bild auf
                            cmp ax,04900h
                            jne nicht_bild_auf

                            mov dx,-1
                            call passe_variable_an_seite_an
                            jmp menu_bearbeiten_hauptschleife
                          nicht_bild_auf:
                            ;----------------------------------------


                            ;----------------------------------------
                            ; Bild ab
                            cmp ax,05100h
                            jne nicht_bild_ab

                            mov dx,+1
                            call passe_variable_an_seite_an
                            jmp menu_bearbeiten_hauptschleife
                          nicht_bild_ab:
                            ;----------------------------------------

                            ;----------------------------------------
                            ; Ein Feld nach unten
                            cmp ax,00f09h ; Tab
                            je tab_oder_nach_unten
                            ;----------------------------------------
                            ;----------------------------------------
                            ; Ein Feld nach oben
                            cmp ax,00f00h ; Umschalt-Tab
                            je umschalt_tab_oder_nach_oben
                            ;----------------------------------------

                            ;----------------------------------------
                            ; Die Wirkung der anderen Tasten ist
                            ; vom Typ der aktuellen Variablen abhÑngig
                            call bestimme_menu_zeiger_si
                            cmp [si].variablentyp,variablentyp_zeichenkette
                            je taste_fuer_zeichenkette
                            ;----------------------------------------

                            ;----------------------------------------
                            ; Pos1/Ende Ñndert auf ersten/letzten(1/n)
                            ; Wert bei Drehfeldern und Zahen,
                            ; nicht fÅr boolean (0/1).
                            cmp [si].anzahl_einstellungen,1
                            je nicht_pos1_ende_fuer_boolean

                            cmp ax,04700h ; Pos1
                            jne nicht_pos1_zahl

                            mov [si].aktuelle_einstellung,1
                            jmp menu_bearbeiten_hauptschleife

                          nicht_pos1_zahl:
                            cmp ax,04f00h ; Ende
                            jne nicht_ende_zahl

                            mov ax,[si].anzahl_einstellungen
                            mov [si].aktuelle_einstellung,ax
                            jmp menu_bearbeiten_hauptschleife

                          nicht_ende_zahl:
                          nicht_pos1_ende_fuer_boolean:
                            ;----------------------------------------

                            ;----------------------------------------
                            ; Ein Feld nach unten
                            ;
                            cmp ax,04d00h ; nach unten
                            jne nicht_tab_oder_nach_unten

                          tab_oder_nach_unten:
                            mov dx,+1
                            call suche_naechste_sichtbare_variable
                            jmp menu_bearbeiten_hauptschleife
                            ;----------------------------------------

                          nicht_tab_oder_nach_unten:
                            ;----------------------------------------
                            ; Ein Feld nach oben
                            ;
                            cmp ax,04b00h ; nach oben
                            jne nicht_umschalt_tab_oder_nach_oben

                          umschalt_tab_oder_nach_oben:
                            mov dx,-1
                            call suche_naechste_sichtbare_variable
                            jmp menu_bearbeiten_hauptschleife
                            ;----------------------------------------

                          nicht_umschalt_tab_oder_nach_oben:
                            ;----------------------------------------
                            ; Wert verkleinern: '-',nach oben
                            ;
                            cmp ax,04800h
                            jne nicht_nach_oben
                            ; // Richtungstausch beim Drehfeld
                            cmp [si].variablentyp,variablentyp_drehfeld
                            je wert_groesser
                            jmp wert_kleiner
                          nicht_nach_oben:
                            cmp al,'-'
                            jne nicht_wert_kleiner
                          wert_kleiner:
                            mov dx,[si].anzahl_einstellungen
                            cmp [si].variablentyp,variablentyp_drehfeld
                            je wert_kleiner_nicht_boolean
                            cmp dx,1
                            je nicht_wert_kleiner ; Keine Wirkung auf Boolean-Felder

  wert_kleiner_nicht_boolean:
                            dec [si].aktuelle_einstellung
                            if_z <mov [si].aktuelle_einstellung,dx>
                            jmp menu_bearbeiten_hauptschleife
                            ;----------------------------------------

                          nicht_wert_kleiner:
                            ;----------------------------------------
                            ; Wert vergrî·ern: '+',nach unten
                            ;
                            cmp ax,05000h
                            jne nicht_nach_unten
                            ; // Richtungstausch beim Drehfeld
                            cmp [si].variablentyp,variablentyp_drehfeld
                            je wert_kleiner
                            jmp wert_groesser
                          nicht_nach_unten:
                            cmp al,'+'
                            jne nicht_wert_groesser
                          wert_groesser:
                            mov dx,[si].anzahl_einstellungen
                            cmp [si].variablentyp,variablentyp_drehfeld
                            je wert_groesser_nicht_boolean
                            cmp dx,1
                            je nicht_wert_groesser ; Keine Wirkung auf Boolean-Felder

  wert_groesser_nicht_boolean:
                            mov ax,[si].aktuelle_einstellung
                            inc ax
                            cmp ax,dx
                            if_a <mov ax,1>
                            mov [si].aktuelle_einstellung,ax
                            jmp menu_bearbeiten_hauptschleife
                            ;----------------------------------------

  nicht_wert_groesser:
                            ;----------------------------------------
                            ; Leertaste fÅr Boolean
                            cmp al,' '
                            jne nicht_leertaste
                            cmp [si].variablentyp,variablentyp_zahl
                            jne nicht_leertaste
                            cmp [si].anzahl_einstellungen,1
                            jne nicht_leertaste
                            xor [si].aktuelle_einstellung,1
                            jmp menu_bearbeiten_hauptschleife
                            ;----------------------------------------

  nicht_leertaste:
                            ;----------------------------------------
                            ; '1234567890' Schnelltasten
                            ;
                            cmp al,'0'
                            jb nicht_0123456789
                            cmp al,'9'
                            ja nicht_0123456789

                            movzx dx,al
                            cmp al,'0'
                            if_e <mov dl,'9'+1>

                            sub dl,'1'       ; 1..10
                            add dx,dx        ; *2
                            mov si,dx
                            mov si,[schnelltastenzeiger+si]

                            ; Nicht vorhanden ?
                            test si,si
                            jz nicht_0123456789 ; fÅr Drehfelder nutzbar


  schnelltaste_schleife:
                            lodsw
                            ; Variable 0 -> Ende
                            test ax,ax
                            jz menu_bearbeiten_hauptschleife

                            ; "Wert" laden
                            mov cx,ax
                            lodsw

                            push si
                              ; mov cx,cx
                              call liefere_variablen_adresse
                              cmp [si].variablentyp,variablentyp_zeichenkette
                              je schnelltaste_strcopy

                              ; Zahl/Drehfeld
                              mov [si].aktuelle_einstellung,ax
                              jmp schnelltaste_weiter

  schnelltaste_strcopy:

                             ;push cx
                               ;mov ax,ax ; source string const variable number
                                call hole_zeichenkettenvariable ; ->di/cx
                             ;pop cx
                              xchg si,di
                              ; ds:si=source string const
                              ; ds:di=target string variable
                              call store_string_to_anything

  schnelltaste_weiter:
                            pop si
                            jmp schnelltaste_schleife
                            ;----------------------------------------

                          nicht_0123456789:
                            ;----------------------------------------
                            cmp al,0    ; Funktionstaste oder Alt+x,...
                            je jmp_menu_bearbeiten_hauptschleife2


                            mov si,[variablen_bereich]
                            mov cx,1

                          sprungtaste_schleife:

                            cmp al,[si].sprungtaste
                            jne sprungtaste_noch_nicht_gefunden

                            ; gefunden
                            mov [editor_position],0
                            mov [menu_position],cx
                            ; SeitenÑnderung bemerken
                            mov dx,0
                            call suche_naechste_sichtbare_variable
                            ; Wert Ñndern


                            call bestimme_menu_zeiger_si
                            cmp [si].variablentyp,variablentyp_zeichenkette
                            je menu_bearbeiten_hauptschleife

                            mov al,' ' ; fÅr boolean
                            cmp [si].variablentyp,variablentyp_zahl
                            if_ne <mov al,'+'> ; keine Zahl
                            cmp [si].anzahl_einstellungen,1
                            if_ne <mov al,'+'> ; oder mehrzeilig
                            jmp taste_verarbeiten

                          sprungtaste_noch_nicht_gefunden:
                            ; nicht gefunden -> weiterrÅcken
                            add si,[si].blocklaenge
                            inc cx

                            ; alle Variablen probiert ?
                            cmp cx,[anzahl_variablen]
                            jna sprungtaste_schleife

                            ;----------------------------------------
                            ; Anfangsbuchstaben fÅr Drehfelder vergleichen
                            call vergleiche_drehfeld_sprungtaste
                            ;----------------------------------------

  jmp_menu_bearbeiten_hauptschleife2:
                            jmp menu_bearbeiten_hauptschleife
                            ;----------------------------------------

  taste_fuer_zeichenkette:
                            call bestimme_menu_zeiger_si

                            ; maximale LÑnge der Zeichenkette
                            mov bx,[si].anzahl_einstellungen

                            ; die Zeichenkette selbst
                            push ax
                            call mov_ax_si_zeichenketteninhalt
                            mov di,ax
                            pop ax

                            ;----------------------------------------
                            cmp ax,04b00h
                            jne editor_nicht_nach_links

                            cmp [editor_position],1
                            if_ne <dec [editor_position]>
                            jmp menu_bearbeiten_hauptschleife
  editor_nicht_nach_links:
                            ;----------------------------------------

                            ;----------------------------------------
                            cmp ax,04d00h
                            jne editor_nicht_nach_rechts

                            mov al,byte ptr [di]        ; jetzige LÑnge
                            cmp [editor_position],al
                            if_be <inc [editor_position]>
                            jmp menu_bearbeiten_hauptschleife
  editor_nicht_nach_rechts:
                            ;----------------------------------------

                            ;----------------------------------------
                            cmp ax,04700h ; Pos1
                            jne editor_nicht_pos1
                            mov [editor_position],1
                            jmp menu_bearbeiten_hauptschleife
  editor_nicht_pos1:
                            ;----------------------------------------

                            ;----------------------------------------
                            cmp ax,04f00h ; Ende
                            jne editor_nicht_ende
                            mov al,[di]
                            inc ax
                            mov [editor_position],al
                            jmp menu_bearbeiten_hauptschleife
  editor_nicht_ende:
                            ;----------------------------------------

                            ;----------------------------------------
                            cmp ax,05300h ; Entf
                            jne editor_nicht_entf

                            ; Entf=[>]+[<--]
                            mov al,[di]                 ; jetzige LÑnge
                            cmp [editor_position],al
                            ja editor_entf_unzulaessig
                            inc [editor_position]
                            jmp editor_rueckloeschen_weiter
  editor_entf_unzulaessig:
                            jmp menu_bearbeiten_hauptschleife
  editor_nicht_entf:
                            ;----------------------------------------

                            ;----------------------------------------
                            cmp al,008h
                            jne editor_nicht_rueckloschen

                            cmp [editor_position],1
                            je editor_rueckloschen_unzulaessig

  editor_rueckloeschen_weiter:
                            ; Beipiel:  'Tes''t' +6 Zeichen Platz (4+6=10)
                            ;                ^- Cursor
                            dec byte ptr [di] ; LÑnge verkleinern (4->3)
                            pusha
                              mov si,di
                            ; inc si                            ; @'T'
                              movzx ax,byte ptr [editor_position] ; (4)
                              dec ax                            ; (3)
                              add si,ax
                            ; dec si                            ; @'s'
                              sub bx,ax                         ; 10-3=7
                              test bx,bx
                              jz editor_rueckloschen_ende
  editor_rueckloschen_schleife:
                              mov al,byte ptr [si+1]
                              mov byte ptr [si],al
                              inc si
                              dec bx
                              jnz editor_rueckloschen_schleife
  editor_rueckloschen_ende:
                              mov byte ptr [si],' '
                              dec [editor_position]
                            popa

  editor_rueckloschen_unzulaessig:
                            jmp menu_bearbeiten_hauptschleife
  editor_nicht_rueckloschen:
                            ;----------------------------------------


                            ;----------------------------------------
                            ; ein Zeichen einfÅgen
                            cmp al,020h                         ; Funktionstaste,..
                            jb zeichen_einfuegen_unzulaessig

                            cmp [si].anzahl_einstellungen,0
                            je zeichen_einfuegen_unzulaessig

                            ; Cursor=nach letztem Zeichen ?
                            push ax
                              movzx ax,byte ptr [editor_position]
                              dec ax
                              cmp ax,[si].anzahl_einstellungen
                            pop ax
                            jae zeichen_einfuegen_unzulaessig

                            call frage_ob_ueberschreibmodus
                            je zeicheneingabe_im_ueberschreibmodus

                            cmp [di],bl                           ; zu lang ?
                            ; ein Zeichen Platz machen, wird gleich gefÅllt
                            if_e <dec byte ptr [di]>

                            ; Beipiel:  'Tes''t' +6 Zeichen Platz (4+6=10)
                            ;                ^- Cursor
                            inc byte ptr [di] ; LÑnge vergrî·ern (4->5)
                            pusha
                              mov si,di
                            ; inc si                            ; @'T'
                              movzx dx,byte ptr [editor_position] ; (4)
                              add si,dx
                            ; dec si                            ; @'t'
                              sub bx,dx                         ; 10-4=6 (4->5) (5->6) (6->7) (7->8) (8->9) (9->10)
                            ; mov al,al                         ; '.'
                              test bx,bx
                              jz editor_zeichen_einfuegen_ende
  editor_zeichen_einfuegen_schleife:
                              xchg al,[si]
                              inc si
                              dec bx
                              jnz editor_zeichen_einfuegen_schleife
  editor_zeichen_einfuegen_ende:
                              mov [si],al
                            popa
                            inc [editor_position]

  zeichen_einfuegen_unzulaessig:
                            jmp menu_bearbeiten_hauptschleife
                            ;----------------------------------------

                            ;----------------------------------------
  zeicheneingabe_im_ueberschreibmodus:
                            ; LÑnge bleibt gleich
                            push bx
                              movzx bx,byte ptr [editor_position]
                              mov ds:[di+bx],al         ; zk[Cursor]:=c
                            pop bx
                            inc [editor_position]       ; Inc(Cursor)
                            mov al,[editor_position]
                            dec al
                            cmp al,byte ptr [di]
                            if_ae <mov [di],al>
                            jmp menu_bearbeiten_hauptschleife
                            ;----------------------------------------

  menu_bearbeiten_hauptschleife_ende:
                            mov si,Offset name_menu_beenden_zulaessig
                            call suche_variable_p8
                            test di,di
                            jz menu_bearbeiten_hauptschleife_ende_erlaubt

                            cmp [di].aktuelle_einstellung,0
                            je menu_bearbeiten_hauptschleife

  menu_bearbeiten_hauptschleife_ende_erlaubt:

                            ; Nachfrage
                            mov si,Offset menu_continue_beschreibung
                            cmp [abbruch],true
                            if_e <mov si,Offset menu_cancel_beschreibung>

                            cmp [si].bildschirm_zeilen_belegt,0
                            je menu_bearbeiten_hauptschleife_ende_erlaubt_bestaetigt

                            mov [vollstaendigneuzeichnen],1

                            mov cx,1 ; es gibt nur eine Seite
                           ;mov si,si
                            call bildschirm_laden_durchsichtig

                            call taste_mit_zeitgrenze
                            cmp ax,0ffffh
                            je menu_bearbeiten_hauptschleife_ende_erlaubt_bestaetigt

                            mov bx,menu_continue_no_sc
                            mov cx,menu_continue_yes_sc
                            cmp [abbruch],true
                            jne nicht_tastenvergleich_abbruch
                            mov bx,menu_cancel_no_sc
                            mov cx,menu_cancel_yes_sc
  nicht_tastenvergleich_abbruch:

                            cmp ax,bx ; menu_continue_no_sc
                            je menu_bearbeiten_hauptschleife
                            cmp ax,cx ; menu_continue_yes_sc
                            jne menu_bearbeiten_hauptschleife_ende_erlaubt

  menu_bearbeiten_hauptschleife_ende_erlaubt_bestaetigt:

ifdef memdisk
                            mov ax,putkey
                            mov icmd.put_key,ax
else
                            mov ah,005h
                            mov cx,putkey
                            cmp cx,0ffffh
                            if_ne <int 016h>
endif

                        popa
                        ret
a_endp                  menu_bearbeiten

putkey                  dw 0ffffh

;***************************************************************************

