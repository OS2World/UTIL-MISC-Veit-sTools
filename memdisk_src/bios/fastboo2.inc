Title                   fastboot install code

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF fastboot_function

                        ; es=640KiB-X
a_proc                  install_fastboot
                        pushad
                        push ds
                        push es

                          sub si,si
                          mov ds,si

                          ; reserve 1 KiB for interrupt table copy
                          dec Word Ptr ds:[00413h]
                          mov ax,Word Ptr ds:[00413h]
                          mov Word Ptr es:w0040013,ax
                          shl ax,6 ; 1 shl 6=64=1024/16
                          mov es:int_tab_kopie._SEG,ax
                          mov es:int_tab_kopie._OFF,si ; 0

                          les di,es:int_tab_kopie
                          mov cx,256
                          cld
                          rep movsd

                        pop es
                        pop ds
                        popad
                        ret
a_endp                  install_fastboot

ENDIF ; fastboot_function

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴