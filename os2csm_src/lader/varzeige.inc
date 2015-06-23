Title   Create/use variable pointer table [not resident]

;***************************************************************************
; Erzeugt eine Tabelle von Zeiger auf die Variablen um den Zugiff
; zu beschleunigen
;***************************************************************************
a_proc                  erzeuge_variablen_zeiger_tabelle
                        pusha
                          mov si,[variablen_bereich]
                          mov di,[variablen_zeiger_tabelle]
                          mov cx,[anzahl_variablen]

  erzeuge_variablen_zeiger_tabelle_schleife:
                          mov ax,si
                          stosw
                          cmp [si].variablentyp,variablentyp_drehfeld
                          jne nicht_variablentyp_drehfeld_fremddefinition
                          test [si].zeichenketteninhalt,08000h
                          jz nicht_variablentyp_drehfeld_fremddefinition

                          ; Verweis auf andere Variable verwenden
                          push cx
                          push si
                            mov cx,[si].zeichenketteninhalt
                            and cx,07fffh
                            call liefere_variablen_adresse
                            ; @si
                            call mov_ax_si_zeichenketteninhalt
                          pop si
                          pop cx
                          ; relativen Abstand (negativ) speichern
                          sub ax,si
                          mov [si].zeichenketteninhalt,ax

  nicht_variablentyp_drehfeld_fremddefinition:
                          add si,[si].blocklaenge
                          loop erzeuge_variablen_zeiger_tabelle_schleife
                        popa
                        ret
a_endp                  erzeuge_variablen_zeiger_tabelle
;***************************************************************************
; Eingabe:
;   cx=variablennummer
; Ausgabe:
;   si=variabe
a_proc                  liefere_variablen_adresse
                        mov si,[variablen_zeiger_tabelle]
                        add si,cx
                        add si,cx
                        mov si,[si-2]
                        ret
a_endp                  liefere_variablen_adresse
;***************************************************************************

