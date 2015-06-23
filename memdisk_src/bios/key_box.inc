Title   message+press a key box, timeout

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

key_box_menu    menu_struc <>

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

keybox_hardwrap equ 70
keybox_linesmax equ 5

a_proc          key_box
                push es
                pusha

                  ; complete last line
                  cmp key_box_message_x,0
                  setne al
                  add key_box_message_y,al
                  mov key_box_message_x,0

                  ; prepare correct line length

                  mov si,Offset key_box_messagebuffer
                  mov di,si
                  push ds
                  pop es
                  cld
                  movzx dx,key_box_message_y

  loop_key_box_prepare:
                  test dx,dx
                  jz break_key_box_prepare

                  movzx cx,key_box_message_xmax
                  rep movsb
                  mov cl,keybox_hardwrap
                  sub cl,key_box_message_xmax
                  add si,cx
                  dec dx
                  jmp loop_key_box_prepare

  break_key_box_prepare:

                  mov si,Offset key_box_menu
                  mov al,key_box_message_xmax
                  mov [si].mn_columns,al
                  mov [si].mn_first_menu_column,1
                  mov [si].mn_last_menu_column,al
                  mov al,key_box_message_y
                  mov [si].mn_rows,al
                  mov [si].mn_menu_image,Offset key_box_messagebuffer

                  call show_menu

                popa
                pop es
                ret
a_endp          key_box

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          key_box_init
                push es
                pusha
                  sub ax,ax
                  mov key_box_message_x,al
                  mov key_box_message_xmax,al
                  mov key_box_message_y,al
                  mov di,Offset key_box_messagebuffer
                  mov cx,(Size key_box_messagebuffer)/2
                  cld
                  push ds
                  pop es
                  mov ax,'  '
                  rep stosw
                popa
                pop es
                ret
a_endp          key_box_init

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; ds:si
a_proc          StrCat_messagestring
                push es
                pusha

                  cld
                  push ds
                  pop es

  loop_StrCat_messagestring_new_address:

                  mov di,Offset key_box_messagebuffer
                  mov al,key_box_message_y
                  mov ah,keybox_hardwrap
                  mul ah
                  add di,ax
                  movzx ax,key_box_message_x
                  add di,ax

  loop_StrCat_messagestring:
                  ; buffer full?
                  cmp key_box_message_y,keybox_linesmax
                  jae done_StrCat_messagestring
                  lodsb

                  test al,al
                  jz done_StrCat_messagestring

                  cmp al,10
                  jne not_key_box_lf
                  inc key_box_message_y
                  jmp loop_StrCat_messagestring_new_address
  not_key_box_lf:

                  cmp al,13
                  ; ignore keypress,beep
                  jb loop_StrCat_messagestring
                  jne not_key_box_cr
                  mov key_box_message_x,0
                  jmp loop_StrCat_messagestring_new_address
  not_key_box_cr:

                  cmp key_box_message_x,keybox_hardwrap
                  jne not_key_box_wrap

                  mov key_box_message_x,0
                  inc key_box_message_y
                  dec si
                  jmp loop_StrCat_messagestring_new_address

  not_key_box_wrap:
                  stosb
                  mov al,key_box_message_x
                  inc ax
                  mov key_box_message_x,al
                  cmp key_box_message_xmax,al
                  if_b <mov key_box_message_xmax,al>
                  jmp loop_StrCat_messagestring

  done_StrCat_messagestring:

                popa
                pop es
                ret
a_endp          StrCat_messagestring

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; ds:si=prompt message
a_proc          key_box_simple_prompt
                pusha
                  call key_box_init
                 ;mov si,si
                  call StrCat_messagestring
                  mov key_box_menu.mn_waittime,0
                  call key_box
                popa
                ret
a_endp          key_box_simple_prompt

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
