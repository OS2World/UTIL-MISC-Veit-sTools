Title                   fastboot restore code

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF fastboot_function

int_tab_kopie           ptr1616 <?,?>
w0040013                dw ?

cfg_cls                 db setdefaultcolour,cls,13,10,0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  do_fastboot
                        cli
IFNDEF dos
                        mov cs:[fastboot_request],false
ENDIF ; - dos
                        sub di,di
                        mov ss,di
                       ;mov sp,0fffeh
                        mov sp,di ; 0fffeh+2
                        mov es,di
                        lds si,cs:int_tab_kopie
                        mov cx,256
                        cld
                        rep movsd

                        mov ax,cs:w0040013
                        mov Word Ptr es:[bios0040r0000+number_of_KB],ax

                        and Byte Ptr es:[bios0040r0000+keyboard_flag_byte0],not (keyboard_status0_right_shift or keyboard_status0_left_shift or keyboard_status0_ctrl or keyboard_status0_alt)
                        and Byte Ptr es:[bios0040r0000+keyboard_flag_byte1],not (keyboard_status1_left_ctrl or keyboard_status1_left_alt)
                        and Byte Ptr es:[bios0040r0000+keyboard_flag_byte2],not (keyboard_status2_lastcode_e0 or keyboard_status2_right_ctrl or keyboard_status2_right_alt)
                       ;and Byte Ptr es:[bios0040r0000+keyboard_flag_byte3],not (0)

                        ; set textmode 80*25*16
IFDEF graph
                        mov ax,00012h
ELSE
                        mov ax,00003h
ENDIF
                        call int_10h

                        mov si,Offset cfg_cls
                        call ausschrift


                        sti

                        call disable_a20

                        ; "BE /REBOOT" (Norton) setzt [Strg]-[Alt]
                      ;*push bios0040
                      ;*pop fs
                      ;*mov byte ptr fs:[keyboard_flag_byte0],0
                      ;*and byte ptr fs:[keyboard_flag_byte2],0fch ; Keyboard Mode/Type

                      ;*mov ah,012h
                      ;*int 016h
  clear_next_key:
                        mov ah,011h
                        int 016h
                        jz no_key_left
                        call tastendruck
                        jmp clear_next_key
  no_key_left:

                      ;*; APM default values
                      ;*mov ax,05309h
                      ;*mov bx,00001h
                      ;*stc
                      ;*int 015h

                        jmp disk_boot
a_endp                  do_fastboot

ENDIF ; fastboot_function

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
