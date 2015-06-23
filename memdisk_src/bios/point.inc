Title   use BIOS service for "PS/2" pointing device

mouse_slower             equ 80 ; 40
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

ps2_mousehandler_used   db false

a_proc                  install_ps2_mousehandler
                        push es
                        pushad

                          mov ah,012h
                          int 016h
                          test al,010h          ; scroll lock active?
                          jnz exit_install_ps2_mousehandler ; yes, no mousing

                          mov ax,0c205h
                          mov bh,3              ; configuration parameter ?
                          int 015h

                          mov ax,0c207h
                          mov bx,Offset ps2_mouse_handler
                          push cs
                          pop es
                          int 015h

                          mov ax,0c200h
                          mov bh,001h
                          int 015h

                          mov [ps2_mousehandler_used],true

  exit_install_ps2_mousehandler:

                        popad
                        pop es
                        ret
a_endp                  install_ps2_mousehandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  remove_ps2_mousehandler
                        push es
                        pushad

                          cmp [ps2_mousehandler_used],false
                          je exit_remove_ps2_mousehandler

                          mov [ps2_mousehandler_used],false

                          mov ax,0c200h
                          mov bh,000
                          int 015h

                          mov ax,0c207h
                          sub bx,bx
                          mov es,bx
                          int 015h

  exit_remove_ps2_mousehandler:

                        popad
                        pop es
                        ret
a_endp                  remove_ps2_mousehandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

alte_knoepfe            db 0

maus_zeile              dw 0

maus_benutzt            db 0

a_proc                  ps2_mouse_handler
                        push bp
                        mov bp,sp
                          pusha
                            push ds
                              push cs
                              pop ds

                              mov maus_benutzt,1

                              mov cx,maus_zeile
                              mov dx,word ptr [bp+2+4+2*1]
                              mov al,byte ptr [bp+2+4+2*3]
                              test al,020h ; Bit 5=y negativ
                              if_nz <mov dh,0ffh>
                              add cx,dx

                              cmp cx,mouse_slower
                              jng maus_nicht_nach_oben

                              mov ah,005h
                              mov cx,04800h
                              int 016h
                              sub cx,cx
  maus_nicht_nach_oben:
                              cmp cx,-mouse_slower
                              jge maus_nicht_nach_unten

                              mov ah,005h
                              mov cx,05000h
                              int 016h
                              sub cx,cx
  maus_nicht_nach_unten:
                              mov maus_zeile,cx

                              and al,001h+002h
                              jnz noch_nicht_losgelassen

                              cmp alte_knoepfe,0
                              je waren_garnicht_gedrueckt

                              mov ah,005h
                              mov cx,01c0dh                     ; Enter
                              cmp alte_knoepfe,2
                              if_e <mov cx,0011bh>              ; Esc
                              int 016h
  waren_garnicht_gedrueckt:
  noch_nicht_losgelassen:

                              mov alte_knoepfe,al

                            pop ds
                          popa
                        pop bp
                        retf
a_endp                  ps2_mouse_handler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

COMMENT $
maustasten_loeschen:
                        cmp maus_benutzt],1
                        jne ret

  maustasten_loeschen_weiter:
                        mov ah,011h
                        int 016h
                        jz ret

                        mov ah,010h
                        int 016h
                        jmp maustasten_loeschen_weiter
$

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
