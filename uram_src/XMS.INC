Title   XMS-Funktionen (A20)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                        .286p

Public detect_xms

xmm                     dd 0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  detect_xms
                        pusha
                        push es

                        mov ax,04300h
                        int 02fh
                        cmp al,080h
                        jne no_xms2

                        mov ax,04310h
                        sub bx,bx
                        mov es,bx
                        int 02fh

                        mov [xmm]._OFF,bx
                        mov [xmm]._SEG,es
  no_xms2:
                        pop es
                        popa
                        ret
a_endp                  detect_xms

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                        ; dl=0: disable A20
                        ; dl=1: enable A20
a_proc                  set_a20_xms
                        pusha
                          cmp [xmm]._SEG,0
                          je exit_set_a20_xms

                         ;mov ah,5 ; local enable a20
                         ;mov ah,6 ; local disable a20
                          mov ah,6
                          sub ah,dl
                          call Far Ptr [xmm]
  exit_set_a20_xms:
                        popa
                        ret
a_endp                  set_a20_xms

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

