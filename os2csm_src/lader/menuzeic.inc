Title   paint menu, current markers

;***************************************************************************
; Zeichnen des MenÅbilschirmes und der Inhalte
;***************************************************************************
; ah=0 oder 80

a_proc                  inc_di_aktives_feld_blinkt
                        mov al,es:[di]
                        and al,07fh                   ; ohne blinken/hell
                        cmp cx,[menu_position]
                        if_e <or al,ah>               ; blinkend oder hell
                        stosb
                        ret
a_endp                  inc_di_aktives_feld_blinkt

;***************************************************************************

a_proc                  menu_zeichnen
                        pusha

                          cmp [vollstaendigneuzeichnen],1
                          jne nicht_vollstaendig_neuzeichnen

                          ; in den puffer Zeichnen und dann laden

                          mov si,Offset menu_bildschirm_beschreibung
                          movzx cx,byte ptr [aktuelle_menue_seite]
                          dec cx
                          mov al,byte ptr [si].bildschirm_zeilen_belegt
                          mov ah,80*2
                          mul ah        ; Seitengrî·e
                          mul cx        ; ax=+Anfang der Seite

                          push es
                            les bp,[si].bildschirm_puffer_zeiger
                            add bp,ax
                            call menu_zeichnen_kern
                          pop es

                          movzx cx,[aktuelle_menue_seite]
                          mov si,Offset menu_bildschirm_beschreibung
                          call bildschirm_laden
                          call enable_checkbox_boolean
                          mov [vollstaendigneuzeichnen],0
                          jmp menu_zeichnen_ende

  nicht_vollstaendig_neuzeichnen:

                          ; direkt in den Bildschirmspeicher

                          push es
                            call segb800_es
                            null bp
                            call menu_zeichnen_kern
                          pop es
  menu_zeichnen_ende:
                        popa
                        ret
a_endp                  menu_zeichnen

;***************************************************************************
; Eingabe: Ziel=ES:BP
;          nur Variablen fÅr [aktuelle_menue_seite]

a_proc                  menu_zeichnen_kern
                          null cx
                          mov si,[variablen_bereich]

  menu_zeichnen_schleife:
                          inc cx

                          ; auf der darzustellenden Seite, sichtbar ?
                          mov al,[aktuelle_menue_seite]
                          cmp [si].seitennummer,al
                          jne variable_nicht_anzeigen

                          mov al,[si].y_position
                          mov ah,80
                          mul ah
                          mov di,ax
                          sub ax,ax
                          mov al,[si].x_position
                          add di,ax
                          sub di,1+1*80
                          add di,di                     ; ((x-1)+(y-1+p-1)*80)*2
                          add di,bp

                          cmp [si].variablentyp,variablentyp_zahl
                          je menu_zeichnen_zahl_oder_boolean

                          cmp [si].variablentyp,variablentyp_drehfeld
                          je menu_zeichnen_drehfeld

                          ;------------------------------------------
                          ; Zeichenkette anzeigen
                          push2 si,cx
                            mov cx,[si].anzahl_einstellungen
                            call mov_ax_si_zeichenketteninhalt
                            mov si,ax
                            inc si
                            cld
                            jcxz zeichenkette_schreiben_schleife_ende
  zeichenkette_schreiben_schleife:
                            lodsb
                            stosb
                            inc di ; Attribut unverÑndert
                            loop zeichenkette_schreiben_schleife
  zeichenkette_schreiben_schleife_ende:
                          pop2 cx,si
                          jmp variable_nicht_anzeigen
                          ;------------------------------------------

                          ;------------------------------------------
                          ; Zahl oder boolean
  menu_zeichnen_zahl_oder_boolean:
                          cmp [si].anzahl_einstellungen,1
                          jne menu_zeichnen_zahl

                          ; boolean
                         ;mov al,'˘'                    ; #$f9(437) falsch
                          mov al,' '                    ; #$20      falsch

                          cmp cx,[menu_position]
                         ;if_e <mov al,007h>            ; grî·erer Punkt
                          if_e <mov al,'_'>             ; Cursor

                          cmp [allow_boolean_redefinition],1
                          if_e <mov al,0f9h>

                          cmp [si].aktuelle_einstellung,1
                          if_e <mov al,'˚'>             ; wahr (850:1,437:v)
                          mov ah,080h                   ; blinken (immer)
                          stosb
                          call inc_di_aktives_feld_blinkt
                          jmp variable_nicht_anzeigen
                          ;------------------------------------------

                          ;------------------------------------------
                          ; alle Zeilen der Zahlenvariable durchlaufen
  menu_zeichnen_zahl:
                          push dx
                            null dx

  menu_zeichnen_zahl_schleife:
                            inc dx
                            mov ax,' '+0 ; Leerzeichen, kein Blinken

                            cmp dx,[si].aktuelle_einstellung
                            if_e <mov ax,010h+08000h> ; '|>' gewÑhltes Element,Blinken

                            stosb
                            call inc_di_aktives_feld_blinkt

                            add di,(80-1)*2

                            cmp dx,[si].anzahl_einstellungen
                            jne menu_zeichnen_zahl_schleife

                          pop dx
                          jmp short variable_nicht_anzeigen
                          ;------------------------------------------

                          ;------------------------------------------
                          ; Drehfeld
  menu_zeichnen_drehfeld:
                          push3 si,cx,dx
                            mov cx,[si].aktuelle_einstellung
                            jcxz menu_zeichnen_drehfeld_ungueltig

                            mov ax,[si].anzahl_einstellungen
                            cmp cx,ax
                            jbe menu_zeichnen_drehfeld_gueltig

  menu_zeichnen_drehfeld_ungueltig:
                            call mov_ax_si_zeichenketteninhalt
                            mov si,ax
                            movzx dx,byte ptr [si]
                            mov si,Offset leere_zeichenkette
                            jmp short menu_zeichen_drehfeld_gefunden

  menu_zeichnen_drehfeld_gueltig:
                            call mov_ax_si_zeichenketteninhalt
                            mov si,ax
                            cld
                            lodsb
                            movzx dx,al ; grî·te LÑnge
                            dec cx      ; aktuelle Einstallung abzÑhlen
                            jcxz menu_zeichen_drehfeld_gefunden
  menu_zeichen_drehfeld_suche:
                            null ax
                            lodsb       ; LÑngenfeld
                            add si,ax   ; +Inhalt
                            loop menu_zeichen_drehfeld_suche
  menu_zeichen_drehfeld_gefunden:

                            null ax
                            lodsb
                            push ax
                              test dl,080h
                              jz menu_zeichen_drehfeld_rechtsbuendig

                              neg dl
                              sub dx,ax
                              jmp menuzeichnen_drehfeld_linker_rand_ende

  menu_zeichen_drehfeld_rechtsbuendig:
                              mov cx,dx
                              sub cx,ax         ; rechtsbÅndig
                              null dx
                              jcxz menuzeichnen_drehfeld_linker_rand_ende
  menuzeichnen_drehfeld_linker_rand_schleife:
                              mov al,' '
                              stosb
                              inc di
                              loop menuzeichnen_drehfeld_linker_rand_schleife
  menuzeichnen_drehfeld_linker_rand_ende:
                            pop cx

                            ; Inhalt des Drehfeldes
                            jcxz menuzeichnen_drehfeld_inhalt_ende
  menuzeichnen_drehfeld_inhalt_schleife:
                            lodsb
                            stosb
                            inc di ; Attribut unverÑndert
                            loop menuzeichnen_drehfeld_inhalt_schleife
  menuzeichnen_drehfeld_inhalt_ende:

                            mov al,' '
  menuzeichnen_drehfeld_rechter_rand_schleife:
                            test dx,dx
                            jz menuzeichnen_drehfeld_rechter_rand_ende

                            stosb
                            inc di
                            dec dx
                            jmp menuzeichnen_drehfeld_rechter_rand_schleife

  menuzeichnen_drehfeld_rechter_rand_ende:
                          pop3 dx,cx,si

                          ;*Wunsch Oliver: nicht Åberschreiben
                          ;*mov al,' '
                          ;*stosb
                          ;*Wunsch A.F.D.: ganz wegschaltbar
                          ;*inc di
                          add di,[os2csm_spinbutton_distance]

                          mov ax,08012h ; Auf/Ab-Pfeil,Blinken
                          stosb
                          call inc_di_aktives_feld_blinkt
                          ;jmp short variable_nicht_anzeigen
                          ;------------------------------------------
  variable_nicht_anzeigen:

                          add si,[si].blocklaenge
                          cmp cx,[anzahl_variablen] ; alle abgearbeitet ?
                          jne menu_zeichnen_schleife

                          ; ATI austricksen:
                          ; sonst flackert das zuletzt geÑnderte Zeichen
                          ; beim stÑndigen Aufruf dieser Funktion
                          ; vielleicht ist das letzte Zeichen gepuffert=verzîgert ?
                          xor word ptr es:[bp+79*2],0
                          ret
a_endp                  menu_zeichnen_kern

;***************************************************************************

a_proc                  zeichne_editor_cursor
                        pusha

                          call bestimme_menu_zeiger_si

                          cmp [si].variablentyp,variablentyp_zeichenkette
                          jne keine_cursor_bestimmung_zeichenkette

                          ; LÑnge
                          call mov_ax_si_zeichenketteninhalt
                          mov di,ax
                          movzx ax,byte ptr [di]
                          inc ax ; LÑnge=0 -> Position:=1

                          ; Position
                          movzx bx,[editor_position]
                          cmp bx,ax

                          ; Position<=LÑnge
                          if_a <mov [editor_position],al>


                          ; neu ?
                          cmp bx,0
                          jne keine_cursor_bestimmung_zeichenkette

                          ; 1 Zeichen lang -> Pos:=1
                          cmp ax,1+1
                          if_e <dec ax>

                          call frage_ob_ueberschreibmodus
                          if_z <mov al,1>
                          mov [editor_position],al

  keine_cursor_bestimmung_zeichenkette:

                          mov ax,02000h ; unsichtbar
                          null bx       ; bx=0 Seite 0
                          null dx       ; oben links

                          cmp [si].variablentyp,variablentyp_zeichenkette
                          jne editor_cursor_setzen

                          mov dh,[si].y_position
                          mov dl,[si].x_position
                          add dl,[editor_position]
                          sub dx,00102h
                          mov ax,[editor_cursor]
                          call frage_ob_ueberschreibmodus
                          if_z <mov ah,0> ; Blockcursor
  editor_cursor_setzen:
                          ; Cursorgrî·e setzen
                          call setze_cursor_form ; ax

                          ; Cursorposition setzen
                          mov ah,002h
                          ; bx..
                          ; dx..
                          int 010h

                        popa
                        ret
a_endp                  zeichne_editor_cursor

;***************************************************************************

menu_position           dw 1

editor_position         db 0 ; 0=neu bestimmen

vollstaendigneuzeichnen db 1

aktuelle_menue_seite    db 1

os2csm_spinbutton_distance dw 1*2
