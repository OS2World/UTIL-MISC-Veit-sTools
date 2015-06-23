Title   convert and pack variable table to save memory

;***************************************************************************
; Entfernen nicht benîtigter Variablen, Konvertierung von Drehfeldern in
; einfache Zeichenketten oder Zahlenvariablen
;***************************************************************************

a_proc                  packe_variablen
                        pusha

                          ; erster Druchlauf: Behandlung von Drehfeldern mit Fremddefinition
                          mov si,[variablen_bereich]
                          mov dx,[anzahl_variablen]
  packvar_schritt1_schleife:
                          movzx ax,[di].namen_laenge
                          ; Drehfeld?
                          cmp [si].variablentyp,variablentyp_drehfeld
                          jne packvar_schritt1_nicht_drehfeld ; nein

                          ; mit Fremddefinition? (Abstand negativ)
                          test [si].zeichenketteninhalt,08000h
                          jz packvar_schritt1_nicht_drehfeld ; nein

                          ; unverÑndert ist nicht zulÑssig.
                          ;cmp [si].loeschtyp,variable_bleibt_unveraendert
                          ;je packvar_schritt1_nicht_drehfeld

                          ; lîschen? dann mu· hier nichts getan werden.
                          cmp [si].loeschtyp,variable_loeschen
                          je packvar_schritt1_nicht_drehfeld

                          cmp [si].loeschtyp,variable_packen_zu_zahl
                          jne packvar_schritt1_nicht_drehfeld_packe_zu_zahl

                          ; Fremddefinition vergessen und Typ umwandeln
                          mov [si].zeichenketteninhalt,0
                          mov [si].variablentyp,variablentyp_zahl
                          mov [si].loeschtyp,variable_bleibt_unveraendert
                          jmp packvar_schritt1_nicht_drehfeld

  packvar_schritt1_nicht_drehfeld_packe_zu_zahl:

                          cmp [si].loeschtyp,variable_packen_zu_zeichenkette
                          jne packvar_schritt1_nicht_drehfeld_packe_zu_zeichenkette

                          ; Aktuelle Einstellung als Zeichenkette erfragen und kopieren
                          push si
                            mov di,si
                            ; di->si,cx(max)
                            call liefere_aktuellezeichenkette_der_variable

                            movzx cx,[si]
                            mov [di].anzahl_einstellungen,cx

                            movzx ax,[di].namen_laenge  ;  Length(name)
                            add ax,Offset namen_zeichen ; +Ofs(name[1])
                            mov [di].zeichenketteninhalt,ax
                            add di,ax

                            cld
                            movsb
                            rep movsb

                          pop si

                          mov [si].variablentyp,variablentyp_zeichenkette
                          mov [si].loeschtyp,variable_bleibt_unveraendert
                          mov [si].aktuelle_einstellung,0
                          jmp packvar_schritt1_nicht_drehfeld

  packvar_schritt1_nicht_drehfeld_packe_zu_zeichenkette:

  packvar_schritt1_nicht_drehfeld:
                          ; zur nÑchsten Variable
                          add si,[si].blocklaenge
                          dec dx
                          jnz packvar_schritt1_schleife



                          ; zweiter Druchlauf: keine Fremddefinition mehr vorhanden
                          ; ich kann also den Speicherinhalt verschieben oder lîschen.
                          mov si,[variablen_bereich]
ifdef memdisk
                          ; no extra memory
                          mov di,si
else
                          ; extra memory, limited space
                          mov di,Offset variablen_bereich_soll
endif
                          mov [variablen_bereich],di
                          mov dx,[anzahl_variablen]

  packe_variablen_schleife:
                          test dx,dx
                          jz packe_variablen_ende

                          dec dx

                          cmp [si].loeschtyp,variable_loeschen
                          jne packe_variablen_schleife_nicht_loeschen

                          ; Lîschen=öberspringen des Kopierens
                          add si,[si].blocklaenge
                          dec [anzahl_variablen]
                          jmp packe_variablen_schleife

  packe_variablen_schleife_nicht_loeschen:
                          ; nur Drehfelder werden gepackt
                          cmp [si].variablentyp,variablentyp_drehfeld
                          jne packe_variablen_kopieren

                          ; und nur wenn gewÅnscht
                          cmp [si].loeschtyp,variable_bleibt_unveraendert
                          jne packe_variablen_nicht_unveraendert
  packe_variablen_kopieren:
                          mov cx,[si].blocklaenge
                          rep movsb
                          jmp packe_variablen_schleife

  packe_variablen_nicht_unveraendert:
                          cmp [si].loeschtyp,variable_packen_zu_zahl
                          jne packe_variablen_nicht_zu_zahl

                          ; Drehfeld->Zahl
                          mov [si].variablentyp,variablentyp_zahl
                          mov bx,si
                          add bx,[si].blocklaenge       ; begin next variable
                          mov cx,[si].zeichenketteninhalt
                          mov [si].blocklaenge,cx       ; keep up to string part
                          rep movsb
                          mov si,bx
                          jmp packe_variablen_schleife

  packe_variablen_nicht_zu_zahl:

                          ;cmp [si].loeschtyp,variable_packen_zu_zeichenkette

                          mov bx,si
                          add bx,[si].blocklaenge       ; nÑchste Quelle

                          push bx

                            push di
                              xchg si,di
                              call liefere_aktuellezeichenkette_der_variable
                              xchg si,di
                              mov bx,di
                            pop di

                            ; bx=@[0]

                            mov [si].variablentyp,variablentyp_zeichenkette

                            movzx ax,Byte Ptr ds:[bx]  ; Zk-LÑnge
                            mov [si].anzahl_einstellungen,ax
                            inc ax              ; +1 Stelle fÅr die LÑnge

                                                ; KopflÑnge
                            add ax,[si].zeichenketteninhalt
                            mov [si].blocklaenge,ax

                            ; Kopf kopieren
                            mov cx,[si].zeichenketteninhalt
                            rep movsb

                            mov si,bx           ; Zeichenkette
                            movzx cx,Byte Ptr [si]
                            inc cx
                            rep movsb

                          pop si
                          jmp packe_variablen_schleife
  packe_variablen_ende:
                        popa
                        ret
a_endp                  packe_variablen

;***************************************************************************

