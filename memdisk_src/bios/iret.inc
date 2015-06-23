Title           iret, but pass carry flag

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

  iret_pass_carry:
                push bp
                  mov bp,sp
                  push ax
                    setc al
                    and byte ptr ss:[bp+2+2+2],(not 1)
                    or  byte ptr ss:[bp+2+2+2],al
                  pop ax
                pop bp
                iret

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
