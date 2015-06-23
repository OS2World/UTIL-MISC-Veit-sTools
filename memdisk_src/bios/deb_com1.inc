Title           output chars over nullmodem link - init part

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF serial_debug

a_proc          init_com2
                pusha
                push ds

                  cmp [cfg_record.cfg_use_serial_debug],1
                  jne no_serial_port

                  push bios0040
                  pop ds

                  ; default is com2
                  mov dx,1
                  mov si,1*2
                  cmp word ptr ds:[si],0
                  jne com2_exist

                  ; try com1
                  dec dx
                  dec si
                  dec si
                  cmp word ptr ds:[si],0
                  je no_serial_port

  com2_exist:
                  ; initialize to 9600,n,8,1
                  mov ah,0
                  mov al,11100011B
                 ;mov dx,dx
                  int 014h

                  mov ax,ds:[si]
                  mov cs:[com2_baseport],ax

  no_serial_port:

                pop ds
                popa
                ret
a_endp          init_com2


ENDIF           ; serial_debug

