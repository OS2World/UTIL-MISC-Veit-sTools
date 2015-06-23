Title   Uninstall handlers for divide by zero and invalid opcode

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          remove_exception_handler
                push si
                  mov si,Offset orgint_00
                  call uninstall_int
                  mov si,Offset orgint_06
                  call uninstall_int
                pop si
                ret
a_endp          remove_exception_handler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
