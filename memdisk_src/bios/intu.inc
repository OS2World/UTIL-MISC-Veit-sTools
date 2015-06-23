Title   Uninstall interrupt handlers

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        ; cs:si=orgint
a_proc  uninstall_int
        push ds
        pusha

          movzx di,Byte Ptr cs:[si+4]           ; int number
          shl di,2                              ; *4
          push 0                                ; 0:4*int number
          pop ds
          mov ax,cs
          cmp ds:[di]._SEG,ax                   ; check segment if installed
          jne skip_uninstall_int

          push DWord Ptr cs:[si]                ; org interrupt pointer
          pop DWord Ptr ds:[di]                 ; restore it

  skip_uninstall_int:

        popa
        pop ds
        ret
a_endp  uninstall_int
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
