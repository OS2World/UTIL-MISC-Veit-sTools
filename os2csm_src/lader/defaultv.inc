Title   Menu: reset to default values

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

defaul_value_buffer_ptr ptr1616 <>

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          save_default_values
                push es
                pushad

                  ; 1. Durchlauf: Speichergr”áe bestimmen
                  null dx
                  mov si,[variablen_bereich]
                  mov cx,[anzahl_variablen]

  save_default_values_berechne_speicherlaenge:
                  cmp [si].seitennummer,0
                  je save_default_values_berechne_speicherlaenge_nicht_aenderbar

                  cmp [si].namen_laenge,0
                  je save_default_values_berechne_speicherlaenge_nicht_aenderbar

                  mov ax,2 ; Zahlenwert
                  cmp [si].variablentyp,variablentyp_zeichenkette
                  jne save_default_values_berechne_speicherlaenge_weiter
                  mov ax,[si].anzahl_einstellungen ; maximale Zeichenkettenl„nge
                  inc ax ; L„ngenbyte
  save_default_values_berechne_speicherlaenge_weiter:
                  add dx,ax

  save_default_values_berechne_speicherlaenge_nicht_aenderbar:
                  add si,[si].blocklaenge
                  loop save_default_values_berechne_speicherlaenge

                  movzx eax,dx
                  mov si,Offset defaul_value_buffer_ptr
                  call getmem
                  les di,[si]

                  ; 2. Durchlauf: Speicher fllen
                  mov si,[variablen_bereich]
                  mov cx,[anzahl_variablen]
  save_default_values_kopiere_werte:
                  cmp [si].seitennummer,0
                  je save_default_values_kopiere_werte_nicht_aenderbar

                  cmp [si].namen_laenge,0
                  je save_default_values_kopiere_werte_nicht_aenderbar

                  cmp [si].variablentyp,variablentyp_zeichenkette
                  je save_default_values_kopiere_zeichenkette

                  mov ax,[si].aktuelle_einstellung
                  cld
                  stosw
                  jmp save_default_values_kopiere_werte_nicht_aenderbar

  save_default_values_kopiere_zeichenkette:
                  push si
                  push cx
                    call mov_ax_si_zeichenketteninhalt
                    mov cx,[si].anzahl_einstellungen
                    mov si,ax
                    cld
                    movsb
                    rep movsb
                  pop cx
                  pop si

  save_default_values_kopiere_werte_nicht_aenderbar:
                  add si,[si].blocklaenge
                  loop save_default_values_kopiere_werte

                popad
                pop es
                ret
a_endp          save_default_values

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
a_proc          load_default_values
                push ds
                push es
                pushad

                  push cs
                  pop es
                  mov di,[variablen_bereich]
                  mov cx,[anzahl_variablen]
                  lds si,[defaul_value_buffer_ptr]

  load_default_values_schleife:
                  cmp es:[di].seitennummer,0
                  je load_default_values_nicht_aenderbar

                  cmp es:[di].namen_laenge,0
                  je load_default_values_nicht_aenderbar

                  cmp es:[di].variablentyp,variablentyp_zeichenkette
                  je load_default_values_zeichenkette
                  cld
                  lodsw
                  mov es:[di].aktuelle_einstellung,ax
                  jmp load_default_values_nicht_aenderbar

  load_default_values_zeichenkette:
                  push di
                  push cx
                    call mov_ax_di_zeichenketteninhalt
                    mov cx,es:[di].anzahl_einstellungen
                    mov di,ax
                    cld
                    movsb
                    rep movsb
                  pop cx
                  pop di

  load_default_values_nicht_aenderbar:
                  add di,es:[di].blocklaenge
                  loop load_default_values_schleife

                popad
                pop es
                pop ds
                ret
a_endp          load_default_values

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          free_default_values
                push si
                  mov si,Offset defaul_value_buffer_ptr
                  call freemem
                pop si
                ret
a_endp          free_default_values

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
