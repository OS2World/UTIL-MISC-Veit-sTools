Title   Unpack screen images

;***************************************************************************
; Entpacken der Bildschirmseiten
;***************************************************************************

a_proc                  entpacke_bildschirme
                        pusha
                          push2 ds,es
                            mov si,Offset menu_bildschirm_beschreibung
                            mov al,[si].bildschirm_zeilen_belegt
                            mov ah,80*2
                            mul ah
                            movzx dx,[anzahl_bildschirmseiten]
                            mov cx,dx
                            mul dx

                            push [si].bildschirm_puffer_zeiger ; packed data source
                              ; allocate memory for unpacked data
                              movzx eax,ax
                              lea si,[si].bildschirm_puffer_zeiger
                              call getmem
                              les di,[si]
                            pop si
                            pop ds


                            ; ds:si->es:di, cx=Anzahl Seiten
  alle_seiten_schleife:
                            ; Zeichen
                            push di
                              call entpacke_bildschirm_1
                            pop di

                            ; Farben
                            inc di
                            call entpacke_bildschirm_1
                            dec di

                            loop alle_seiten_schleife


                            push cs
                            pop ds

                            mov bp,Offset entpacke_nachfrage_bildschirm

                            mov si,Offset menu_continue_beschreibung
                            call bp

                            mov si,Offset menu_cancel_beschreibung
                            call bp

                            mov si,Offset menu_reset_beschreibung
                            call bp

                          pop2 es,ds
                        popa
                        ret
a_endp                  entpacke_bildschirme

;***************************************************************************

                        ; ds:si=@quelle/ziel
a_proc                  entpacke_nachfrage_bildschirm
                        push ds
                        push es
                        pushad

                          cmp [si].bildschirm_zeilen_belegt,0
                          je leere_menu_x_beschreibung


                          push [si].bildschirm_puffer_zeiger ; packed data source

                            mov al,[si].bildschirm_zeilen_belegt
                            mov ah,80*2
                            mul ah
                            movzx eax,ax
                            lea si,[si].bildschirm_puffer_zeiger
                            call getmem
                            les di,[si]

                          pop si
                          pop ds

                          ; Zeichen
                          push di
                            call entpacke_bildschirm_1
                          pop di

                          ; Farben
                          inc di
                          call entpacke_bildschirm_1
                          dec di


  leere_menu_x_beschreibung:

                        popad
                        pop es
                        pop ds
                        ret
a_endp                  entpacke_nachfrage_bildschirm

;***************************************************************************
; si=Quelle,di=Ziel,weitergerÅckt

a_proc                  entpacke_bildschirm_1
                        push2 ax,cx
                          cld

  schleife_entpacke_bildschirm_1:
                          lodsb
                          movzx cx,al
                          jcxz ende_entpacke_bildschirm_1

                          test al,080h
                          jnz mehrfach_entpacke_bildschirm_1

  roh_entpacke_bildschirm_1:
                          lodsb
                          stosb
                          inc di
                          loop roh_entpacke_bildschirm_1
                          jmp schleife_entpacke_bildschirm_1

  mehrfach_entpacke_bildschirm_1:
                          and cl,07fh
                          lodsb
  mehrfach_entpacke_bildschirm_1_sl:
                          stosb
                          inc di
                          loop mehrfach_entpacke_bildschirm_1_sl
                          jmp schleife_entpacke_bildschirm_1

  ende_entpacke_bildschirm_1:
                        pop2 cx,ax
                        ret
a_endp                  entpacke_bildschirm_1

;***************************************************************************

                        ; :si
a_proc                  free_decompressed_screens_1
                        push si
                          cmp [si].bildschirm_zeilen_belegt,0
                          je nichts_entpackt

                          add si,bildschirm_puffer_zeiger
                          call freemem
  nichts_entpackt:
                        pop si
                        ret
a_endp                  free_decompressed_screens_1

;***************************************************************************

a_proc                  free_decompressed_screens
                        pusha

                          mov bp,Offset free_decompressed_screens_1

                          mov si,Offset menu_bildschirm_beschreibung
                          call bp

                          mov si,Offset menu_continue_beschreibung
                          call bp

                          mov si,Offset menu_cancel_beschreibung
                          call bp

                          mov si,Offset menu_reset_beschreibung
                          call bp

                        popa
                        ret
a_endp                  free_decompressed_screens

;***************************************************************************

