Title           output chars over nullmodem link - resident part

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF serial_debug

com2_baseport   dw 0 ; 0=disabled

                ; al
a_proc          output_com2
                pushf
                pusha

                  mov dx,cs:[com2_baseport]
                  test dx,dx
                  jz no_serial_debug
                  push dx
                  push ax
                    add dx,5
  wait_transmit_holding_register_empty:
                    in al,dx
                    test al,020h
                    jz wait_transmit_holding_register_empty

                  pop ax
                  pop dx

                  out dx,al

  no_serial_debug:
                popa
                popf
                ret
a_endp          output_com2

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; bp=output_com2
                ; al=integer
a_proc          send_decimal_com2
                push ax
                push bx
                  mov ah,0
                  mov bl,100
                  div bl
                  add al,'0'
                  call bp
                  shr ax,8
                  mov bl,10
                  div bl
                  add ax,'00'
                  call bp
                  mov al,ah
                  call bp
                pop bx
                pop ax
                ret
a_endp          send_decimal_com2

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          GotoXY_com2
                cmp cs:[com2_baseport],0
                je exit_GotoXY_com2

                push ax
                push bp
                  mov bp,Offset output_com2
                  mov al,27                     ; Esc[y;xH
                  call bp
                  mov al,'['
                  call bp
                  mov al,dh                     ; y
                  inc ax
                  call send_decimal_com2
                  mov al,';'
                  call bp
                  mov al,dl                     ; x
                  inc ax
                  call send_decimal_com2
                  mov al,'H'
                  call bp

                pop bp
                pop ax
  exit_GotoXY_com2:
                ret
a_endp          GotoXY_com2

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; writes only chars for now.
a_proc          WriteColourString_com2
                cmp cs:[com2_baseport],0
                je exit_WriteColourString_com2
                jcxz exit_WriteColourString_com2
                pusha

                  call GotoXY_com2

                  call WindMax
                  mov bx,ax

  loop_WriteColourString_com2:

                  mov al,es:[bp]
                  inc bp
                  inc dl
                  cmp dx,bx                     ; do noting in lower right corner
                  if_ne <call output_com2>
                  inc bp                        ; ignore colour
                  loop loop_WriteColourString_com2

                popa
  exit_WriteColourString_com2:
                ret
a_endp          WriteColourString_com2

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          ClrEol_com2
                push ax

                  ; send ANSI clear to end of line command
                  mov al,27
                  call output_com2
                  mov al,'['
                  call output_com2
                  mov al,'K'
                  call output_com2

                pop ax
                ret
a_endp          ClrEol_com2

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

com2            Macro Z
                push ax
                  mov al,&Z
                  call output_com2
                pop ax
                EndM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
ELSE            ; serial_debug

com2            Macro Z
                EndM

ENDIF           ; serial_debug

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

