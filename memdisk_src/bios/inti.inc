Title   Install interrupt handlers

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        ; es:dx=newint
        ; es:si=orgint/int num
a_proc  install_int
        push ds
        push di

          movzx di,es:[si+4]
          shl di,2                              ; *4
          push 0
          pop ds
          push DWord Ptr ds:[di]
          pop DWord Ptr es:[si]
          mov ds:[di]._OFF,dx
          mov ds:[di]._SEG,es

        pop di
        pop ds
        ret
a_endp  install_int
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
