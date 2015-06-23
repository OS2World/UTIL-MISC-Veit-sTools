Title   char redefinition for boolean checkbox

;--------------------------------------------------------------------

; painted with krfont.exe

checkbox_boolean_8:
 ;      12345678
;db     00000000B       ; 1 unchecked
;db     01111110B       ; 2
;db     01000010B       ; 3
;db     01000010B       ; 4
;db     01000010B       ; 5
;db     01000010B       ; 6
;db     01111110B       ; 7
;db     00000000B       ; 8

 db     00000000B       ; 1 unchecked
 db     00000000B       ; 2
 db     00000000B       ; 3
 db     00111100B       ; 4
 db     00111100B       ; 5
 db     00000000B       ; 6
 db     00000000B       ; 7
 db     00000000B       ; 8


 db     00000000B       ; 1 checked
 db     00000000B       ; 2
 db     00000010B       ; 3
 db     01000110B       ; 4
 db     01101100B       ; 5
 db     00111000B       ; 6
 db     00010000B       ; 7
 db     00000000B       ; 8

 db     00000000B       ; 1 spinbutton
 db     00100010B       ; 2
 db     01110100B       ; 3
 db     00001000B       ; 4
 db     00010000B       ; 5
 db     00101110B       ; 6
 db     01000100B       ; 7
 db     00000000B       ; 8

checkbox_boolean_14:
;db     000h,000h,000h,000h,07Eh,042h,042h,042h,042h,042h,07Eh,000h,000h,000h
 db     000h,000h,000h,000h,000h,03Ch,03Ch,000h,000h,000h,000h,000h,000h,000h
 db     000h,000h,000h,000h,002h,006h,08Ch,0D8h,070h,020h,000h,000h,000h,000h
 db     000h,000h,020h,070h,0FAh,004h,008h,010h,020h,040h,0BEh,01Ch,008h,000h

checkbox_boolean_16:
;db     000h,000h,000h,000h,07Eh,042h,042h,042h,042h,042h,042h,042h,07Eh,000h,000h,000h
 db     000h,000h,000h,000h,000h,000h,03Ch,03Ch,000h,000h,000h,000h,000h,000h,000h,000h
 db     000h,000h,000h,000h,002h,086h,0CEh,07Ch,038h,010h,000h,000h,000h,000h,000h,000h
 db     000h,000h,020h,070h,0FAh,004h,008h,010h,020h,040h,0BEh,01Ch,008h,000h,000h,000h

;--------------------------------------------------------------------

;allow_boolean_redefinition     db 1 ; default: allow
allow_boolean_redefinition      db 0 ; default: disabled
boolean_font_redefined          db 0 ; default: BIOS chars

a_proc          enable_checkbox_boolean
                cmp boolean_font_redefined,1
                je enable_checkbox_boolean_exit
                cmp allow_boolean_redefinition,1
                jne enable_checkbox_boolean_exit
                mov boolean_font_redefined,1
                call update_boolean_checkbox
  enable_checkbox_boolean_exit:
                ret
a_endp          enable_checkbox_boolean

;--------------------------------------------------------------------

a_proc          disable_checkbox_boolean
                cmp boolean_font_redefined,0
                je disable_checkbox_boolean_exit
                mov boolean_font_redefined,0
                call update_boolean_checkbox
  disable_checkbox_boolean_exit:
                ret
a_endp          disable_checkbox_boolean

;--------------------------------------------------------------------

a_proc          update_boolean_checkbox
                pusha

                  push es
                    push bios0040
                    pop es
                    mov cx,es:[char_matrix_height]
                  pop es

                  mov bp,Offset checkbox_boolean_8
                 ;mov bh,3      ; ROM 8x8 double dot font pointer
                  mov al,012h   ; load 8x8
                  cmp cl,8
                  je update_boolean_checkbox_getfont
                  mov bp,Offset checkbox_boolean_14
                 ;mov bh,2      ; ROM 8x14 character font pointer
                  mov al,011h   ; load 8x14
                  cmp cl,14
                  je update_boolean_checkbox_getfont
                  mov bp,Offset checkbox_boolean_16
                 ;mov bh,6      ; ROM 8x16 font (MCGA, VGA)
                  mov al,014h   ; load 8x16
                  cmp cl,16
                  jne exit_update_boolean_checkbox

  update_boolean_checkbox_getfont:
                  mov ah,011h
                  mov bl,0
                  cmp boolean_font_redefined,1
                  je load_3char

                  int 010h
                  jmp exit_update_boolean_checkbox
  load_3char:
                  mov dl,0f9h ; unchecked 'ù'
                  call load_char
                  mov dl,0fbh ; checked 'û'
                  call load_char
                  mov dl,012h ; spinbutton 'A/V'
                  call load_char

  exit_update_boolean_checkbox:

                popa
                ret
a_endp          update_boolean_checkbox

;--------------------------------------------------------------------

a_proc          load_char
                pusha
                  mov ax,01100h                 ; user character load
                  mov bh,cl                     ; number of bytes per character
                  mov bl,0                      ; table in character generator RAM
                  mov cx,1                      ; count of characters in table
                  movzx dx,dl                   ; ASCII code of first character defined
                 ;mov es,es                     ; ES:BP = pointer to user table
                 ;mov bp,bp
                  int 010h
                popa
                add bp,cx                       ; next char definition
                ret
a_endp          load_char

;--------------------------------------------------------------------
