Title  Display Divide/0 and Invalid Opcode traps

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

message_divide_by_zero1  db msg_divide_by_zero,string_string
                         dw Offset message_divide_by_zero2
                         db 0
message_invalid_opcode1  db msg_invalid_opcode
message_divide_by_zero2  db ". CS:IP="
message_leerzeichen_eckigeklammerauf db " [",0
message_divide_by_zero3  db "].",13,10,0

invalid_opcode_counter   dw 0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int_00_handler
                push ds
                pushad
int_00_handler_stack equ 2+8*4
                  call test_arpl
                  jz jmp_orgint_00
                  mov dx,Offset message_divide_by_zero1

continue_int_00_06_handler:
                  mov bp,sp
                  add bp,int_00_handler_stack

                  call ausschrift_zeichen_CRLF

                  mov bl,error_TextAttr
                  xchg cs:[TextAttr],bl
                  mov si,dx
                  call ausschrift

                  ; cs
                  mov ax,ss:[bp]._SEG
                  call ausschrift_ax_hex
                  mov al,':'
                  call ausschrift_zeichen
                  ; ip
                  mov ax,ss:[bp]._OFF
                  call ausschrift_ax_hex


                 ;mov al,' '
                 ;call ausschrift_zeichen
                 ;mov al,'['
                 ;call ausschrift_zeichen
                  mov si,Offset message_leerzeichen_eckigeklammerauf
                  call ausschrift

                  lds si,ss:[bp]
                  mov cx,10
                  jmp show_trap_code_entry

  show_trap_code_loop:
                  mov al,' '
                  call ausschrift_zeichen
  show_trap_code_entry:
                  mov al,[si]
                  inc si
                  call ausschrift_al_hex
                  loop show_trap_code_loop

                  mov cs:[TextAttr],bl

                  IFNDEF nodebug
                  db 0cch ; i n t 3
                  ENDIF

                  push Offset message_divide_by_zero3
                  sti
                  jmp trap_proc

  jmp_orgint_00:
                popad
                pop ds

                db 0eah
orgint_00:      dd ?
                db 000h

a_endp          int_00_handler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int_06_handler
                push ds
                pushad
                  call test_arpl
                  jz jmp_orgint_06

                  push cs
                  pop ds
                  mov dx,Offset message_invalid_opcode1

                  mov si,Offset invalid_opcode_counter
                  inc Word Ptr [si]
                  cmp Word Ptr [si],1000
                  jb try_code_again

                  and Word Ptr [si],0           ; reboot allowed again..
                  jmp continue_int_00_06_handler

  try_code_again:
                  ; SystemSoft Reboot problem F000:FFF0=Jmp F000:E05B <- Int 6
                  ; cause ?

  jmp_orgint_06:
                popad
                pop ds

                db 0eah
orgint_06:      dd ?
                db 006h

a_endp          int_06_handler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; -> ZF=0/1 for no/yes
a_proc          test_arpl
                push ds
                pusha

                  mov al,0

                  lds si,ss:[bp]

                  ; E163:FFC2 (GPF,Zucker)   =F15F2
                  ; E1FB:FFC4 (DIV0,VPC)     =F1F74

                  ; ??
                  ; in VPC eCS 1.1 DOS session, INT 6=E24C:FAB4 (arpl) PV.EXE
                  ;                                   E24D:FAA4=F1F74 (arpl) MFT.EXE

                  cmp si,0f000h                 ; IP=Fxxx
                  jb exit_test_arpl
                  cmp si,0fffeh
                  jae exit_test_arpl

                  mov bx,ds
                  cmp bh,0e0h                   ; CS=Exxx=E000..EFFF
                  jb exit_test_arpl
                  cmp bh,0efh
                  ja exit_test_arpl

                 ;mov al,Byte Ptr ds:[si]
                  lodsb
  exit_test_arpl:
                  cmp al,063h

                popa
                pop ds
                ret
a_endp          test_arpl

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
