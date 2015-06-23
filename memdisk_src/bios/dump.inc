Title           show CPU registers

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;IFDEF usesdump

reg_ax          db 13,10,' EAX=',0
reg_bx          db ' EBX=',0
reg_cx          db ' ECX=',0
reg_dx          db ' EDX=',0
reg_si          db 13,10,' ESI=',0
reg_di          db ' EDI=',0
reg_bp          db ' EBP=',0
reg_sp          db ' ESP=',0
reg_cs          db 13,10,' CS=',0
reg_ds          db ' DS=',0
reg_es          db ' ES=',0
reg_fs          db ' FS=',0
reg_gs          db ' GS=',0
reg_ss          db ' SS=',0
reg_            db 13,10,0

a_proc          dump
                push eax
                  push si
                    push ds

                      push cs
                      pop ds

                      mov si,Offset reg_ax
                      call ausschrift
                      call ausschrift_eax_hex

                      mov si,Offset reg_bx
                      call ausschrift
                      mov eax,ebx
                      call ausschrift_eax_hex

                      mov si,Offset reg_cx
                      call ausschrift
                      mov eax,ecx
                      call ausschrift_eax_hex

                      mov si,Offset reg_dx
                      call ausschrift
                      mov eax,edx
                      call ausschrift_eax_hex

                      mov si,Offset reg_si
                      call ausschrift
                    pop ds
                  pop si
                  push si
                    push ds
                      push cs
                      pop ds
                      mov eax,esi
                      call ausschrift_eax_hex

                      mov si,Offset reg_di
                      call ausschrift
                      mov eax,edi
                      call ausschrift_eax_hex

                      mov si,Offset reg_bp
                      call ausschrift
                      mov eax,ebp
                      call ausschrift_eax_hex

                      mov si,Offset reg_sp
                      call ausschrift
                      mov eax,esp
                      call ausschrift_eax_hex

                      mov si,Offset reg_cs
                      call ausschrift
                      mov ax,cs
                      call ausschrift_ax_hex

                      mov si,Offset reg_ds
                      call ausschrift
                    pop ax
                    push ax
                      call ausschrift_ax_hex

                      mov si,Offset reg_es
                      call ausschrift
                      mov ax,es
                      call ausschrift_ax_hex

                      mov si,Offset reg_fs
                      call ausschrift
                      mov ax,fs
                      call ausschrift_ax_hex

                      mov si,Offset reg_gs
                      call ausschrift
                      mov ax,gs
                      call ausschrift_ax_hex

                      mov si,Offset reg_ss
                      call ausschrift
                      mov ax,ss
                      call ausschrift_ax_hex

                      mov si,Offset reg_
                      call ausschrift

                    pop ds
                  pop si

                pop eax
                ret
a_endp          dump

;ENDIF
