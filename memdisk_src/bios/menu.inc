Title           code to display menu

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

menu_struc                      Struc
  mn_columns                    db 1
  mn_first_menu_column          db 1
  mn_last_menu_column           db 1
  mn_rows                       db 1
  mn_first_menu_row             db 1
  mn_last_menu_row              db 1
  mn_attribute_for_frame        db MenuAttrFrame
  mn_attribute_for_selection    db MenuAttrSelection
  mn_menu_image                 dw -1
  mn_menu_license_note          dw -1
  mn_menu_time_20_msg1          dw -1
  mn_menu_time_20_msg2          dw -1
  mn_menu_time_1_msg1           dw -1
  mn_menu_time_1_msg2           dw -1
  mn_menu_stop_msg1             dw -1
  mn_menu_stop_msg2             dw -1
  mn_default                    db 1
  mn_waittime                   dw 20
  mn_stoptimer_esc_only         db true
menu_struc                      EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

menu_current_source             dw ?
menu_save_TextAttr              db ?
menu_save_WhereXY               dw ?
menu_save_cursorshape           dw ?
menu_x0                         db ?
menu_y0                         db ?
menu_xe                         db ?
menu_ye                         db ?
menu_selected                   dw ?
menu_choices                    dw ?
menu_seconds_left               dw ?
                                dw ?
sec_parts                       db ?
menu_screen_save                screen_save <>

IFNDEF os2boot_ac_code

hotkey_update_memdisk           db false

ENDIF ; os2boot_ac_code

do_load_memtestp                db false

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; -> cx
a_proc          GetCursorShape
                push si
                push di
                push bp
                push dx
                  mov ah,3
                  mov bh,0
                  call int_10h
                pop dx
                pop bp
                pop di
                pop si
                ret
a_endp          GetCursorShape

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; cx
a_proc          SetCursorShape
                pusha
                  mov ah,1
                  call int_10h
                popa
                ret
a_endp          SetCursorShape

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; -> ax
a_proc          ReadCharAttr
                push bp
                push si
                push di
                  mov ah,008h
                  mov bh,0
                  call int_10h
                pop di
                pop si
                pop bp
                ret
a_endp          ReadCharAttr

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; load CX chars from DS:BP
a_proc          PutStringBPCX
                pusha
                  test cx,cx
                  jz PutStringBPCX_exit
  PutStringBPCX_loop:
                  mov al,ds:[bp]
                  inc bp
                  call ausschrift_zeichen
                  loop PutStringBPCX_loop
  PutStringBPCX_exit:
                popa
                ret
a_endp          PutStringBPCX

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; ds:si=menu structure
a_proc          paint_menu_lines
                pusha

                  cmp menu_choices,1
                  jbe paint_menu_lines_exit

                  ; calculate pointer to first char to paint
                  mov ah,[si].mn_columns
                  mov al,[si].mn_first_menu_row
                  dec ax ; 1-based
                  mul ah
                  add al,[si].mn_first_menu_column   ; -1+1
                  adc ah,0
                  add ax,[si].mn_menu_image
                  mov bp,ax

                  mov di,1                      ; counter

                  mov ch,0                      ; length of string to paint
                  mov cl,[si].mn_last_menu_column
                  sub cl,[si].mn_first_menu_column
                 ;inc cx ; must count last char
                 ;dec cx ; exclude first '>'
                  dec cx ; exclude last  '<'

                  mov al,menu_x0                ; first cursor
                  add al,[si].mn_first_menu_column
                  mov ah,menu_y0
                  add ah,[si].mn_first_menu_row
                  sub ax,00101h                 ; 1-based
                  mov dx,ax

  paint_menu_lines_loop:

                  cmp di,menu_choices
                  ja paint_menu_lines_exit

                  mov al,[si].mn_attribute_for_frame
                  cmp di,menu_selected
                  if_e <mov al,[si].mn_attribute_for_selection>
                  mov TextAttr,al

                 ;mov dx,dx
                  call GotoXY

                  mov al,' '
                  cmp di,menu_selected
                 ;if_e <mov al,'>'>
                  if_e <mov al,16>
                  call ausschrift_zeichen

                  call PutStringBPCX
                  movzx ax,[si].mn_columns
                  add bp,ax

                  mov al,' '
                  cmp di,menu_selected
                 ;if_e <mov al,'<'>
                  if_e <mov al,17>
                  call ausschrift_zeichen

                  inc dh                        ; next line
                  inc di
                  jmp paint_menu_lines_loop

  paint_menu_lines_exit:
                popa
                ret
a_endp          paint_menu_lines

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; ds=cs
                ; si=menu info
a_proc          paint_menu_status_line
                pusha

                  mov al,[si].mn_attribute_for_frame
                  xchg TextAttr,al
                  push ax

                    call WhereXY
                    push ax

                      call WindMax
                      mov dh,ah                 ; max line
                      mov dl,0                  ; first column
                      call GotoXY

                      ;** call ClrEol

                      ;** cmp menu_seconds_left,0
                      ;** jz menu_no_timeout_reminder

                      mov di,si
                      mov si,[di].mn_menu_time_20_msg1       ; 20-2
                      cmp menu_seconds_left,1
                      if_e <mov si,[di].mn_menu_time_1_msg1> ; 1
                      if_b <mov si,[di].mn_menu_stop_msg1>   ; 0
                      call display_menu_time_string

                      ;** movzx eax,menu_seconds_left
                      ;** call ausschrift_eax

                      mov si,[di].mn_menu_time_20_msg2
                      cmp menu_seconds_left,1
                      if_e <mov si,[di].mn_menu_time_1_msg2>
                      if_b <mov si,[di].mn_menu_stop_msg2>
                      call display_menu_time_string

  menu_no_timeout_reminder:

                    pop dx
                    call GotoXY

                  pop ax
                  mov TextAttr,al
                popa
                ret
a_endp          paint_menu_status_line

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; ds:di=menu
a_proc          display_menu_time_string
                pusha
                  cmp si,-1
                  je skip_display_menu_time

                  ; menu time messages begin with x,y
                  mov dx,Word Ptr [si]
                  inc si
                  inc si
                  add dh,menu_y0
                  add dl,menu_x0
                  sub dx,0101h
                  call GotoXY
                  call ausschrift

                  mov dl,menu_x0
                  add dl,[di].mn_columns
  loop_pad_display_menu_time:
                  call WhereXY
                  cmp al,dl
                  jae done_pad_display_menu_time

                  mov al,' '
                  call ausschrift_zeichen
                  jmp loop_pad_display_menu_time
  done_pad_display_menu_time:

  skip_display_menu_time:

                popa
                ret
a_endp          display_menu_time_string

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; ds=cs
a_proc          remove_int1Chandler
                push si

                  cmp menu_seconds_left,0
                  je int1Chandler_is_already_removed

                  mov menu_seconds_left,0
                  mov sec_parts,0
                  call paint_menu_status_line

  int1Chandler_is_already_removed:

                  mov si,Offset orgint1c
                  call uninstall_int

                pop si
                ret
a_endp          remove_int1Chandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int1Chandler

                cmp cs:menu_seconds_left,0
                je exit_int1Chandler            ; no timeout

                push ds
                pushad

                  ; do not 'tick' when user pressed the pause key..
                  push bios0040
                  pop ds
                  test Byte Ptr ds:[keyboard_flag_byte1],keyboard_status1_suspend_key
                  jnz exit_int1Chandler_pop
                  test Byte Ptr ds:[keyboard_flag_byte2],keyboard_status2_lastcode_e1
                  jnz exit_int1Chandler_pop

                  ; count down until it is time to update the display
                  dec cs:sec_parts
                  jnz exit_int1Chandler_pop

                  push cs
                  pop ds
                  mov si,menu_current_source

                  mov sec_parts,18              ; 18.206 ~ 18

                  dec menu_seconds_left
                  jnz no_menu_timeout

                  mov ah,005h                   ; put key into keyboard buffer
                  mov cx,01c0dh                 ; enter key for default entry
                  int 016h

  no_menu_timeout:

                  call paint_menu_status_line

  exit_int1Chandler_pop:

                popad
                pop ds

  exit_int1Chandler:
                db 0eah
orgint1c        dd ?
                db 01ch

a_endp          int1Chandler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; menu=ds:si
a_proc          show_menu
                push es
                pushad

                  mov menu_current_source,si

                  ; look at menu and decide coordinates (centering)

                  call WindMax
                  add ax,00101h
                  mov dx,ax
                  sub al,[si].mn_columns
                  if_c <mov al,0>
                  sub ah,[si].mn_rows
                  if_c <mov ah,0>
                  shr al,1
                  shr ah,1
                  mov menu_x0,al
                  mov menu_y0,ah
                  add al,[si].mn_columns
                  if_c <mov al,0ffh>
                  add ah,[si].mn_rows
                  if_c <mov ah,0ffh>
                  sub ax,00101h
                  cmp al,dl
                  if_a <mov al,dl>
                  cmp ah,dh
                  if_a <mov ah,dh>
                  mov menu_xe,al
                  mov menu_ye,ah

                  push si
                    mov si,Offset menu_screen_save
                    call save_screen
                  pop si

                  mov cx,02000h ; invisible
                  call SetCursorShape


IFDEF os2boot_ac_code
                  test [show_ecs_cd_menu],8
ELSE
                  test [cfg_record.cfg_show_ecs_cd_menu],8
ENDIF
                  jz no_show_license_note

                  push si

                    call WindMax
                    mov dh,ah                 ; max line
                    sub dh,1                  ; max line-1
                    mov dl,0                  ; first column
                    call GotoXY

                    mov si,[si].mn_menu_license_note
                    cmp si,-1
                    if_ne <call ausschrift>
                  pop si

  no_show_license_note:

                  ; paint menu
                  mov al,[si].mn_attribute_for_frame
                  mov TextAttr,al
                  mov dl,menu_x0
                  mov dh,menu_y0
                  ; paint frame (around dx/cx)
                  push dx
                    mov cl,[si].mn_columns
                    mov ch,[si].mn_rows
                    sub dx,0101h ; border 1
                    add cx,0202h
                    call zeichne_rahmen_attr
                  pop dx

                  mov bp,[si].mn_menu_image
                  movzx cx,[si].mn_columns

  paintmenuframe_loop:
                  call GotoXY
                  call PutStringBPCX
                  add bp,cx
                  inc dh
                  cmp dh,menu_ye
                  jbe paintmenuframe_loop


                  ; copy default value
                  movzx ax,[si].mn_default
                  mov menu_selected,ax
                  mov al,[si].mn_last_menu_row
                  sub al,[si].mn_first_menu_row
                  inc ax
                  mov menu_choices,ax

                  ; set timeout and install timerout hook

                  mov ax,[si].mn_waittime
                  mov menu_seconds_left,ax
                  mov sec_parts,18 ; ~1/18,2
                  call paint_menu_status_line

                  push si
                    mov dx,Offset int1Chandler
                    mov si,Offset orgint1c
                    push cs
                    pop es
                    call install_int
                  pop si

                  ; paint before mouse enabler (takes 1 second)
                  call paint_menu_lines

                  ; enable BIOS mouse driver, only if keyboard buffer is empty
                  mov ah,011h
                  int 016h
                  if_z <call install_ps2_mousehandler>

                  jmp entry_menu_process_user_input ; already painted

                  ; process user input
  loop_menu_process_user_input:
                  call paint_menu_lines

  entry_menu_process_user_input:
                  call tastendruck_lowercase

                  ; any key -> enter key for key box
                  cmp menu_choices,1
                  if_be <mov al,13>

                  cmp [si].mn_stoptimer_esc_only,true
                  jne stoptimer_anykey
                  cmp al,27
                  jne stoptimer_not_esc
  stoptimer_anykey:
                  ; stop timer
                  call remove_int1Chandler
  stoptimer_not_esc:

                  ; space bar to stop time
                  ; cmp al

                  ; Enter ?
                  cmp al,13
                  je menu_done
                  ; space bar
                  cmp al,' '
                  je menu_done

IFNDEF os2boot_ac_code

                  ; shift+F10 => try to update memdisk
                  cmp ax,05d00h
                  jne not_update_hotkey

                  mov [hotkey_update_memdisk],true
                  jmp menu_done

  not_update_hotkey:

                  cmp al,'s'
                  jne not_toggle_swap_bay
                  xor swap_bay_prompt,true
                  mov al,7
                  call ausschrift_zeichen
                  jmp loop_menu_process_user_input
  not_toggle_swap_bay:


ENDIF ; os2boot_ac_code

                  cmp al,'m'
                  jne not_load_memtestp

                  mov do_load_memtestp,true
                  jmp menu_done
  not_load_memtestp:

                  cmp al,'c'
                  jne not_toggle_cache

                  call toggle_cache
                  mov al,7
                  call ausschrift_zeichen
                  jmp loop_menu_process_user_input

  not_toggle_cache:

                  ; numbers  '1'..'9','0'
                  cmp al,'9'
                  ja menu_not_numeric
                  cmp al,'0'
                  jb menu_not_numeric
                  if_e <mov al,'0'+10>
                  mov ah,0
                  sub al,'0'
  menu_validate:
                  cmp ax,menu_choices
                  ja loop_menu_process_user_input
                  mov menu_selected,ax
                  jmp menu_done

  menu_not_numeric:
                  ; cursor/functions/extended keys
                  cmp al,0e0h
                  je cursor_function
                  cmp al,000h
                  jne loop_menu_process_user_input

  cursor_function:
                  shr ax,8      ; ah=0 al=scan code

                  ; check F1..F10
                  cmp al,03bh
                  jb menu_not_f1_f10
                  cmp al,044h
                  ja menu_not_f1_f10

                  sub al,(03bh-1)
                  jmp menu_validate

  menu_not_f1_f10:
                  ; check F11/F12
                  cmp al,085h
                  jb menu_not_f11_f12
                  cmp al,086h
                  ja menu_not_f11_f12

                  sub al,(085h-11)
                  jmp menu_validate

  menu_not_f11_f12:
                  ; check Home
                  cmp al,047h
                  jne menu_not_home

                  mov menu_selected,1
                  jmp loop_menu_process_user_input

  menu_not_home:
                  ; check End
                  cmp al,04fh
                  jne menu_not_end

                  mov ax,menu_choices
                  mov menu_selected,ax
                  jmp loop_menu_process_user_input

  menu_not_end:
                  ; check up
                  cmp al,048h
                  jne menu_not_up

                  mov ax,menu_choices
                  dec menu_selected
                  if_z <mov menu_selected,ax>
                  jmp loop_menu_process_user_input

  menu_not_up:
                  ; check down
                  cmp al,050h
                  jne menu_not_down

                  mov ax,menu_choices
                  inc menu_selected
                  cmp menu_selected,ax
                  if_a <mov menu_selected,1>
                  jmp loop_menu_process_user_input
  menu_not_down:
                  ; add more keys..
                  jmp loop_menu_process_user_input

  menu_done:

                  ; disable BIOS mouse driver
                  call remove_ps2_mousehandler


                  ; removed timout handler in all cases
                  call remove_int1Chandler

                  push si
                    mov si,Offset menu_screen_save
                    call restore_screen
                  pop si

                popad
                pop es

                cmp do_load_memtestp,true
                je load_memtestp

                ; return choice
                mov ax,menu_selected
                ; save selection (good ?)
                mov [si].mn_default,al

IFNDEF os2boot_ac_code

                cmp [hotkey_update_memdisk],false
                je no_memdisk_update

                mov [hotkey_update_memdisk],false
                call update_memdisk
                jmp show_menu

  no_memdisk_update:

ENDIF ; os2boot_ac_code

                ret
a_endp          show_menu

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
