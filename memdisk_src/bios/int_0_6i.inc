Title   Install handlers for divide by zero and invalid opcode

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; es:xx=code
a_proc          install_exception_handler
                push si
                push dx
                  mov dx,Offset int_00_handler
                  mov si,Offset orgint_00
                  call uninstall_int
                  mov dx,Offset int_06_handler
                  mov si,Offset orgint_06
                  call uninstall_int
                pop dx
                pop si
                ret
a_endp          install_exception_handler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
