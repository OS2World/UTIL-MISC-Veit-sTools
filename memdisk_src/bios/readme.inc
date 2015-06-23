Title   readme.txt viewer/config.sys editor

; file size limitations <60k
; editor limitations
;  no autoindent
;  no sophisticated copy/delete/search/replace
;  no undo
; enhancements wish list
;  maybe support ^KB/^KK or shift-cursor block mark operation?

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

edit_max_numer_of_lines = 4000
edit_max_filesize       = 60000
edit_buffersize         = 65000

edit_puffer_ptr         ptr1616 <?,?>
edit_filesize           dw ?
zeilenzeiger_ptr        ptr1616 <?,?>
anzahl_zeilen           dw ?
                        dw 0
edit_crc                dd 0

readme_screen           screen_save <>

readme_attr_text        equ 01fh
readme_attr_status      equ 070h

readme_mode             db false        ; 0=edit 1=readme

jetzige_readme_puffer_ofs dw ?
jetzige_zeilenzeiger_ptr  dw ?
jetzige_zeilennummer      dw ?


left_invisible_columns  dw 0
edit_cursor_x           dw 1
                        dw 0
edit_cursor_y           dw 1
                        dw 0
edit_cursor_x_user      dw 1

edit_puffer_ofs         dw ?
edit_zeilenzeiger_ptr   dw ?

clipboard_size          dw 0
clipboard_ptr           ptr1616 <0,0>

insertmode              db 080h


; readme display

message_readme_sl       db msg_readme_statusline1
                        db string_numlongint
                        dw Offset jetzige_zeilennummer_anzeige
                        db '/'
                        db string_numlongint
                        dw Offset anzahl_zeilen
                        db msg_readme_statusline2,string_ClrEol,0
jetzige_zeilennummer_anzeige dd ?

                        IFDEF memdisk

message_edit_cursor     db ' '
                        db string_numlongint
                        dw Offset edit_cursor_y
                        db ':'
                        db string_numlongint
                        dw Offset edit_cursor_x
                        db '  ',msg_edit_statusline,string_ClrEol,0


db_edithelpline         Macro EHLN
                        IFDEF msg_edithelp_&EHLN
                        db msg_edithelp_tab
                        db msg_edithelp_&EHLN
                        db 13,10
                        ENDIF
                        EndM

message_edithelp        db colour,readme_attr_text,cls,goto_xy,1,7
                        db_edithelpline 01
                        db_edithelpline 02
                        db_edithelpline 03
                        db_edithelpline 04
                        db_edithelpline 05
                        db_edithelpline 06
                        db_edithelpline 07
                        db_edithelpline 08
                        db_edithelpline 09
                        db_edithelpline 10
                        db_edithelpline 11
                        db_edithelpline 12
;                       db_edithelpline 13
;                       db_edithelpline 14
;                       db_edithelpline 15
;                       db_edithelpline 16
;                       db_edithelpline 17
;                       db_edithelpline 18
;                       db_edithelpline 19
                        db 0

message_edithelp_key    db colour,readme_attr_status,' ',msg_edithelp_key,' ',string_ClrEol,keypress,0

message_edit_save_changes db ' ',msg_edit_save_changes,string_ClrEol,0

                        ENDIF ; memdisk

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        ; cs:di=file83 filename
a_proc  show_readme
        mov readme_mode,true
  readme_edit_common:
        pusha
        call load_file
        call parse_file
        call install_ps2_mousehandler
        call view_edit_file
        call remove_ps2_mousehandler
        call make_textfile
        call done_file
        popa
        ret
a_endp  show_readme

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        ; cs:di=file83 filename
a_proc  edit_textfile
        mov readme_mode,false
        jmp readme_edit_common
a_endp  edit_textfile

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        ; cs:di=filename
a_proc  load_file
        push es
        push fs
        pushad

          mov eax,Size disk_info
          mov si,Offset disk_a
          call getmem

          call init_crc32

          lfs si,disk_a
          mov dl,boot_drive                             ; CD ROM source
          mov dh,sourcetype_primary
          mov eax,boot_sector_rel                       ; partition boot sector

  IFDEF memdisk
          cmp MemDiskBIOS_Info._phys_addr,-1
          ; load readme from cdrom/ edit config.sys on memdisk
          if_ne <call search_memdisk>

          push ax
            mov al,'S'
            cmp MemDiskBIOS_Info._phys_addr,-1
            if_ne <mov al,'M'>
            call notify_drive_access
          pop ax
  ENDIF ; memdisk

          call load_disk_info

          push cs
          pop es
         ;mov di,di
          call search_file
          cmp bp,-1
          if_e <trap msg_readme_not_found>

          mov eax,fs:[bp].fat_direntry.filesize
          cmp eax,edit_max_filesize
          if_a <trap msg_readme_file_is_to_large>

          mov edit_filesize,ax

          mov ecx,eax
          call round_up_to_sectorsize
          mov eax,ecx
          push si
          push eax
            mov eax,edit_buffersize
            mov si,Offset edit_puffer_ptr
            call getmem
          pop eax
          pop si

          ; fs:bp
          call open_file

          les bx,edit_puffer_ptr
          movzx ecx,edit_filesize
          call read_file

          call close_file

          cmp readme_mode,true
          if_e <call readme_dispose_filesystem>

          call calculate_cursors

          mov si,Offset readme_screen
          call save_screen

        popad
        pop fs
        pop es
        ret
a_endp  load_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  readme_dispose_filesystem
        pushad

          call free_crc32

          mov si,Offset disk_a
          call freemem

        popad
        ret
a_endp  readme_dispose_filesystem

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  parse_file
        push es
        push fs
        push gs
        pushad

          ; allocate line length array
          mov eax,edit_max_numer_of_lines*2
          mov si,Offset zeilenzeiger_ptr
          call getmem

          ; make free space at begin of buffer
          lfs si,edit_puffer_ptr
          les di,edit_puffer_ptr
          mov cx,edit_filesize
          add di,edit_buffersize
          sub di,cx

          call move_edit_buffer

          xchg si,di

          ; fs:si=file start(source)
          ; es:di=buffer start(target)

          lgs bx,zeilenzeiger_ptr
          mov anzahl_zeilen,0                   ; line
          mov word ptr gs:[bx],0                ; column
          mov cx,edit_filesize

  parse_file_loop:
          test cx,cx
          jz exit_parse_file

          mov al,fs:[si]
          inc si
          dec cx

          ; Backspace?
          cmp al,8                              ; backspace
          jne not_parsefile_chr8

          cmp word ptr gs:[bx],0                ; first column ?
          je parse_file_loop                    ; yes, ignore

          dec di                                ; go back one char
          dec word ptr gs:[bx]                  ; decrement column
          jmp parse_file_loop

  not_parsefile_chr8:

          ; TAB?
          cmp al,9
          jne not_parsetfile_chr9

  parsefile_convert_tab:
          mov Byte Ptr es:[di],' '              ; store blank
          inc di
          inc word ptr gs:[bx]                  ; +one column
          test word ptr gs:[bx],7               ; until multiple of 8
          jnz parsefile_convert_tab
          jmp parse_file_loop

  not_parsetfile_chr9:
          cmp al,10
          jne not_parsefile_chr10

          ; soft fail when haveing more lines than reserved.
          cmp anzahl_zeilen,edit_max_numer_of_lines-1
          je exit_parse_file
          inc anzahl_zeilen                     ; one line more
          inc bx                                ; cont columns in a new line
          inc bx
          mov word ptr gs:[bx],0                ; starting from column 0
          jmp parse_file_loop

  not_parsefile_chr10:

          cmp al,26                             ; ^Z - EOF
          je exit_parse_file

          ; ignore other control chars
          cmp al,' '                            ; ^L, ^M, ..
          jb parse_file_loop

          ; it is a "printable" char.
          mov dl,al

          ; automatic line wrap only in readme mode
          cmp readme_mode,true
          jne parsefile_no_warp_80

          call WindMax
          mov ah,0
          cmp word ptr gs:[bx],ax               ; more than right border ?
          jbe parsefile_no_warp_80

          inc anzahl_zeilen                     ; one line more
          inc bx                                ; cont columns in a new line
          inc bx
          mov word ptr gs:[bx],0                ; starting from column 0

  parsefile_no_warp_80:
          mov es:[di],dl                        ; store char
          inc di
          inc word ptr gs:[bx]                  ; +one column
          jmp parse_file_loop

  exit_parse_file:
          ; if last line has chars, we have one more line.
          cmp word ptr gs:[bx],0
          je no_chars_in_last_line

          inc anzahl_zeilen                     ; one line more
          inc bx                                ; count columns in a new line
          inc bx
          mov word ptr gs:[bx],0                ; starting from column 0

  no_chars_in_last_line:
          sub di,edit_puffer_ptr._OFF
          mov edit_filesize,di


        popad
        pop gs
        pop fs
        pop es
        ret
a_endp  parse_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  make_textfile

        IFDEF memdisk

        push es
        push fs
        push gs
        pushad

          cmp readme_mode,true
          je exit_make_textfile

          ; make free space at begin of buffer
          lfs si,edit_puffer_ptr
          les di,edit_puffer_ptr
          mov cx,edit_filesize
          add di,edit_buffersize
          sub di,cx

          call move_edit_buffer

          xchg si,di

          lgs bx,zeilenzeiger_ptr

          mov dx,anzahl_zeilen
  make_textfile_loop:
          test dx,dx
          jz make_textfile_exit

          ; copy chars of line
          mov cx,gs:[bx]
          inc bx
          inc bx
          mov bp,di
          jcxz make_textfile_copyline_break
  make_textfile_copyline_loop:
          mov al,fs:[si]
          inc si
          stosb
          loop make_textfile_copyline_loop
  make_textfile_copyline_break:
          ; eat blanks at end of line
  make_textfile_copyline_break_eat_blanks:
          cmp bp,di
          je make_textfile_copyline_break_no_blanks
          cmp Byte Ptr es:[di-1],' '
          jne make_textfile_copyline_break_no_blanks
          dec di
          jmp make_textfile_copyline_break_eat_blanks
  make_textfile_copyline_break_no_blanks:
          ; append line break
          mov ax,00a0dh
          stosw
          ; less lines left
          dec dx
          jmp make_textfile_loop

  make_textfile_exit:
          sub di,edit_puffer_ptr._OFF
          mov edit_filesize,di

  exit_make_textfile:

        popad
        pop gs
        pop fs
        pop es

        ENDIF ; memdisk

        ret
a_endp  make_textfile
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  dec_line
        pusha
          mov cx,ax
          jcxz exit_dec_line
  loop_dec_line:
          cmp jetzige_zeilennummer,0
          je exit_dec_line
          dec jetzige_zeilennummer
          sub jetzige_zeilenzeiger_ptr,2
          mov bx,jetzige_zeilenzeiger_ptr
          mov ax,gs:[bx]
          sub jetzige_readme_puffer_ofs,ax
          loop loop_dec_line
  exit_dec_line:
        popa
        ret
a_endp  dec_line

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  inc_line
        pusha
          mov cx,ax
          jcxz exit_inc_line
  loop_inc_line:
          mov ax,anzahl_zeilen
          dec ax
          cmp jetzige_zeilennummer,ax
          jae exit_inc_line
          inc jetzige_zeilennummer
          mov bx,jetzige_zeilenzeiger_ptr
          add jetzige_zeilenzeiger_ptr,2
          mov ax,gs:[bx]
          add jetzige_readme_puffer_ofs,ax
          loop loop_inc_line

  exit_inc_line:
        popa
        ret
a_endp  inc_line

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  dec_line_or_dec_cursor_line
        cmp readme_mode,true
        je dec_line

        push ax
        push bx
          test ax,ax
          jz dec_line_or_dec_cursor_line_done
  dec_line_or_dec_cursor_line_loop:
          test ax,ax
          jz dec_line_or_dec_cursor_line_done
          cmp edit_cursor_y,1
          jbe dec_line_or_dec_cursor_line_done

          dec edit_cursor_y
          mov bx,edit_zeilenzeiger_ptr
          sub bx,2
          mov edit_zeilenzeiger_ptr,bx
          mov bx,gs:[bx]
          sub edit_puffer_ofs,bx
          dec ax
          jnz dec_line_or_dec_cursor_line_loop

  dec_line_or_dec_cursor_line_done:

          mov ax,edit_cursor_x_user
          mov bx,edit_zeilenzeiger_ptr
          mov bx,gs:[bx]
          inc bx
          cmp ax,bx
          if_a <mov ax,bx>
          mov edit_cursor_x,ax

        pop bx
        pop ax
        ret
a_endp  dec_line_or_dec_cursor_line

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  inc_line_or_inc_cursor_line
        cmp readme_mode,true
        je inc_line

        push ax
        push bx
        push dx
          test ax,ax
          jz inc_line_or_inc_cursor_line_done
  inc_line_or_inc_cursor_line_loop:
          mov dx,anzahl_zeilen
          cmp dx,edit_cursor_y
          jbe inc_line_or_inc_cursor_line_done
          inc edit_cursor_y
          mov bx,edit_zeilenzeiger_ptr
          mov dx,gs:[bx]
          add edit_puffer_ofs,dx
          add bx,2
          mov edit_zeilenzeiger_ptr,bx
          dec ax
          jnz inc_line_or_inc_cursor_line_loop
  inc_line_or_inc_cursor_line_done:

          mov ax,edit_cursor_x_user
          mov bx,edit_zeilenzeiger_ptr
          mov bx,gs:[bx]
          inc bx
          cmp ax,bx
          if_a <mov ax,bx>
          mov edit_cursor_x,ax

        pop dx
        pop bx
        pop ax
        ret
a_endp  inc_line_or_inc_cursor_line

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        ; edit: move visible text area to include cursor
a_proc  make_cursor_visible
        push ax

          ; 1. less invisible left border
  make_cursor_visible_left_loop:
          mov ax,left_invisible_columns
          test ax,ax
          jz make_cursor_visible_left_done
          add ax,3
          cmp ax,edit_cursor_x
          jb make_cursor_visible_left_done
          dec left_invisible_columns
          jmp make_cursor_visible_left_loop
  make_cursor_visible_left_done:

          ; 2. more invisible left border if beyond right margin
  make_cursor_visible_right_loop:
          call WindMax
          mov ah,0
          sub ax,3
          add ax,left_invisible_columns
          cmp ax,edit_cursor_x
          ja make_cursor_visible_right_done
          inc left_invisible_columns
          jmp make_cursor_visible_right_loop
  make_cursor_visible_right_done:

          ; 3. cursor before first visible line?
  make_cursor_visible_upper_loop:
          mov ax,edit_cursor_y
          cmp ax,jetzige_zeilennummer
          ja make_cursor_visible_upper_done
          mov ax,1
          call dec_line
          jmp make_cursor_visible_upper_loop
  make_cursor_visible_upper_done:

          ; 4. cursor after last visible line?
  make_cursor_visible_lower_loop:
          call WindMax
          shr ax,8
          add ax,jetzige_zeilennummer
          cmp ax,edit_cursor_y
          jae make_cursor_visible_lower_done
          mov ax,1
          call inc_line
          jmp make_cursor_visible_lower_loop
  make_cursor_visible_lower_done:

        pop ax
        ret
a_endp  make_cursor_visible

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  left_cursor_cx
        cmp readme_mode,true
        je exit_left_cursor_cx
        push ax
          mov ax,edit_cursor_x
          sub ax,cx
          if_be <mov ax,1>
          mov edit_cursor_x,ax
          mov edit_cursor_x_user,ax
        pop ax
  exit_left_cursor_cx:
        ret
a_endp  left_cursor_cx

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  right_cursor_cx
        cmp readme_mode,true
        je exit_right_cursor_cx
        push ax
        push bx
          mov ax,edit_cursor_x
          add ax,cx
          mov bx,edit_zeilenzeiger_ptr
          mov bx,gs:[bx]
          inc bx
          cmp ax,bx
          if_a <mov ax,bx>
          mov edit_cursor_x,ax
          cmp ax,bx
          if_e <mov ax,07fffh>
          mov edit_cursor_x_user,ax
        pop bx
        pop ax
  exit_right_cursor_cx:
        ret
a_endp  right_cursor_cx

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        ; -> ZF
a_proc  is_overwrite_mode
        test [insertmode],080h
        ret
a_endp  is_overwrite_mode

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        ; cursor:=cx
a_proc  setcursor
        pusha
          mov ah,1
          call int_10h
        popa
        ret
a_endp  setcursor

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        ; ds:[si]:=cursor
a_proc  getcursor
        pusha
          mov ah,3
          call int_10h
          mov [si],cx
        popa
        ret
a_endp  getcursor
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

cursor_org              dw ?
cursor_invisible        dw 02000h
cursor_insert           dw ?
cursor_overwrite        dw ?

a_proc  calculate_cursors
        pusha
          mov si,Offset cursor_org
          call getcursor
          push ds
            ; get cell height
            push bios0040
            pop ds
            mov ax,word ptr ds:[char_matrix_height]
          pop ds

          mov cx,ax
          add ax,ax
          add ax,cx
          dec cx
          shr ax,2 ; 3/4
          dec ax
          mov ch,al
          mov [cursor_insert],cx
          mov ch,0
          mov [cursor_overwrite],cx

          ; set default mode to insert
          mov [insertmode],080h
        popa
        ret
a_endp  calculate_cursors

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        IFDEF memdisk

        ; al=char (>' '); cursor one right
a_proc  OverwriteCharAtCursor
        push bx
        push cx
        push di

          mov di,edit_cursor_x
          dec di
          mov bx,edit_zeilenzeiger_ptr
          cmp di,gs:[bx]
          jne OverwriteCharAtCursor_not_EOL

          call insert_char_at_cursor
          jmp OverwriteCharAtCursor_exit
  OverwriteCharAtCursor_not_EOL:

          add di,edit_puffer_ofs
          mov es:[di],al

          mov cx,1
          call right_cursor_cx

  OverwriteCharAtCursor_exit:
        pop di
        pop cx
        pop bx
        ret
a_endp  OverwriteCharAtCursor

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        ; al=char (>' '); cursor one right
a_proc  insert_char_at_cursor
        pusha

          ; check file size limit
          mov dx,anzahl_zeilen
          add dx,dx
          add dx,edit_filesize
          cmp dx,edit_max_filesize
          jae exit_insert_char_at_cursor

          ; increase size
          inc edit_filesize

          ; make line longer
          mov bx,edit_zeilenzeiger_ptr
          inc Word Ptr gs:[bx]

          ; make room for char

          mov si,edit_puffer_ofs
          add si,edit_cursor_x
          dec si

          mov cx,edit_filesize
          sub cx,si
          add cx,edit_puffer_ptr._OFF

          push si

            mov di,si
            inc di
            call move_edit_buffer

          pop si


          ; place char
          mov es:[si],al

          ; advance cursor
          mov cx,1
          call right_cursor_cx

  exit_insert_char_at_cursor:
        popa
        ret
a_endp  insert_char_at_cursor

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  delete_char_after_cursor
        pusha
          ; at end of line?
          mov ax,edit_cursor_x
          dec ax
          mov bx,edit_zeilenzeiger_ptr
          cmp ax,gs:[bx]
          je exit_delete_char_after_cursor

          ; move chars in text behind cursor
          mov di,edit_puffer_ofs
          add di,ax
          lea si,[di+1]
          mov cx,edit_filesize
          sub cx,si
          add cx,edit_puffer_ptr._OFF

          call move_edit_buffer

          ; make line smaller
          dec Word Ptr gs:[bx]

          ; make text smaller
          dec edit_filesize

  exit_delete_char_after_cursor:
        popa
        ret
a_endp  delete_char_after_cursor

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴


a_proc  insert_linebreak_at_cursor
        pusha

          ; check file size limit
          mov ax,anzahl_zeilen
          cmp ax,edit_max_numer_of_lines
          jae exit_insert_linebreak_at_cursor
          inc ax
          add ax,ax
          add ax,edit_filesize
          cmp ax,edit_max_filesize
          jae exit_insert_linebreak_at_cursor

          ; make table longer
          inc anzahl_zeilen

          ; make room for split
          mov cx,anzahl_zeilen
          sub cx,edit_cursor_y
          dec cx
          mov si,edit_zeilenzeiger_ptr
          add si,cx
          add si,cx
          lea di,[si+2]
          std
          push ds
          push es
            push gs
            pop ds
            push gs
            pop es
            rep movsw
          pop es
          pop ds
          cld

          ; split chars of old line - before/after cursor
          mov bx,edit_zeilenzeiger_ptr
          mov ax,edit_cursor_x
          dec ax
          mov dx,gs:[bx]
          mov gs:[bx],ax
          sub dx,ax
          mov gs:[bx+2],dx

          ; go to next line
          mov ax,1
          call inc_line_or_inc_cursor_line

          ; go to start of this next line
          mov cx,edit_cursor_x
          dec cx
          call left_cursor_cx

  exit_insert_linebreak_at_cursor:

        popa
        ret
a_endp  insert_linebreak_at_cursor

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  delete_linebreak_after_cursor
        pusha

          mov ax,edit_cursor_y
          cmp ax,anzahl_zeilen
          jae exit_delete_linebreak_after_cursor

          ; make table shorter
          dec anzahl_zeilen

          ; concat 2 lines
          mov di,edit_zeilenzeiger_ptr
          mov ax,gs:[di+2]
          add gs:[di+0],ax

          ; move entries in line table
          add di,2
          lea si,[di+2]
          mov cx,anzahl_zeilen
          sub cx,edit_cursor_y
          push ds
          push es
            push gs
            pop ds
            push gs
            pop es
            cld
            rep movsw
          pop es
          pop ds


  exit_delete_linebreak_after_cursor:
        popa
        ret
a_endp  delete_linebreak_after_cursor

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        ; al in ['0'..'9','a'..'z','A'..'Z','_']->CF=1
a_proc  IsWordChar
        cmp al,'0'
        jb IsWordChar_not_digit
        cmp al,'9'+1
        jb IsWordChar_exit              ; CF=1
  IsWordChar_not_digit:
        cmp al,'A'
        jb IsWordChar_not_upper
        cmp al,'Z'+1
        jb IsWordChar_exit              ; CF=1
  IsWordChar_not_upper:
        cmp al,'a'
        jb IsWordChar_not_lower
        cmp al,'z'+1
        jb IsWordChar_exit              ; CF=1
  IsWordChar_not_lower:
        cmp al,'_'
        jb IsWordChar_nor_underline
        cmp al,'_'+1
        jb IsWordChar_exit              ; CF=1
  IsWordChar_nor_underline:
        clc
  IsWordChar_exit:
        ret
a_endp  IsWordChar

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        ; ax=-1:before =0:at =+1:after cursor -> al
a_proc  retrieve_cursorchar
        push bx
        push di

          mov bx,edit_zeilenzeiger_ptr
          mov di,edit_cursor_x
          dec di
          add di,ax
          mov al,' '
          test di,08000h
          jnz exit_retrieve_cursorchar

          cmp di,gs:[bx]
          jae exit_retrieve_cursorchar

          add di,edit_puffer_ofs
          mov al,es:[di]

  exit_retrieve_cursorchar:

        pop di
        pop bx
        ret
a_endp  retrieve_cursorchar

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        ; ->ZF
a_proc  IsBeginOfLine
        cmp edit_cursor_x,1
        ret
a_endp  IsBeginOfLine

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  GoToBeginOfLine
        push cx
          mov cx,edit_cursor_x
          dec cx
          call left_cursor_cx
        pop cx
        ret
a_endp  GoToBeginOfLine

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        ; ->ZF
a_proc  IsEndOfLine
        push bx
          mov bx,edit_zeilenzeiger_ptr
          mov bx,gs:[bx]
          inc bx
          cmp edit_cursor_x,bx
        pop bx
        ret
a_endp  IsEndOfLine

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  GoToEndOfLine
        pusha
          mov bx,edit_zeilenzeiger_ptr
          mov cx,gs:[bx]
          add cx,2
          sub cx,edit_cursor_x
          call right_cursor_cx
        popa
        ret
a_endp  GoToEndOfLine

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  FreeClipBoard
        pushad
          mov si,Offset clipboard_ptr
          cmp DWord Ptr cs:[si],0
          if_ne <call freemem>
          mov [clipboard_size],0
        popad
        ret
a_endp  FreeClipBoard

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  calculate_edit_crc
        pushad
        push es

          les si,[edit_puffer_ptr]              ; es:si,cx->eax
          mov cx,[edit_filesize]
          call calculate_crc32
          xor edit_crc,eax

          les si,[zeilenzeiger_ptr]
          mov cx,[anzahl_zeilen]
          call calculate_crc32
          xor edit_crc,eax

        pop es
        popad
        ret
a_endp  calculate_edit_crc

        ENDIF ; memdisk

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  view_edit_file
        push es
        push fs
        pushad


          mov left_invisible_columns,0

          les bp,edit_puffer_ptr
          lgs bx,zeilenzeiger_ptr

          mov jetzige_readme_puffer_ofs,bp
          mov jetzige_zeilenzeiger_ptr,bx
          mov jetzige_zeilennummer,0
          mov left_invisible_columns,0
          mov edit_cursor_x,1
          mov edit_cursor_y,1
          mov edit_cursor_x_user,1
          mov edit_puffer_ofs,bp
          mov edit_zeilenzeiger_ptr,bx
          and edit_crc,0

  loop_view_file:

          IFDEF memdisk

          cmp readme_mode,true
          if_ne <call calculate_edit_crc>

          ENDIF ; memdisk

          ; switch off STEP display in upper rigth corner
          mov al,[debugoption]
          push ax
          and [debugoption], not debugoption_STEP

  refresh_display_view_file:

          ; hide cursor during paint
          mov cx,[cursor_invisible]
          call setcursor

          cmp readme_mode,true
          if_ne <call make_cursor_visible>


          ; try to keep last line of readme below or equal lowest line (24)
          ; this may only work if the readme has at least 24 lines..
          call WindMax
          shr ax,8
          add ax,cs:[jetzige_zeilennummer]
          sub ax,cs:[anzahl_zeilen]
          if_a <call dec_line>

          ; display text

          mov bp,jetzige_readme_puffer_ofs
          mov bx,jetzige_zeilenzeiger_ptr
          mov si,cs:[jetzige_zeilennummer]

          mov dx,0
          mov TextAttr,readme_attr_text

  display_file_lines_loop:
          call GotoXY
          call WindMax
          cmp ah,dh
          je display_file_lines_exit

          cmp si,cs:[anzahl_zeilen]
          jae display_file_lines_empty

          mov cx,gs:[bx]
          add bx,2
          mov ax,bp                             ; next line start
          add ax,cx
          push ax
            mov ax,left_invisible_columns
            add bp,ax
            sub cx,ax
            jb display_file_lines_no_chars_visible

            ; larger than right border? then cut display count
            call WindMax
            sub al,dl
            mov ah,0
            cmp cx,ax
            if_a <mov cx,ax>

            push ds
              push es
              pop ds
              call PutStringBPCX
              add dl,cl
            pop ds

  display_file_lines_no_chars_visible:
          pop bp

  display_file_lines_empty:

          ; column "80" bugfix
          call WindMax
          cmp dl,al
          ja no_clear_at_line_end_needed

          call GotoXY
          call ClrEol
  no_clear_at_line_end_needed:

          inc si
          inc dh
          mov dl,0
          jmp display_file_lines_loop
  display_file_lines_exit:

          ; display status line

          mov TextAttr,readme_attr_status

          call WindMax
          shr ax,8
          add ax,cs:[jetzige_zeilennummer]
          movzx eax,ax
          mov cs:[jetzige_zeilennummer_anzeige],eax
          mov si,Offset message_readme_sl
IFDEF memdisk
          cmp readme_mode,true
          if_ne <mov si,Offset message_edit_cursor>
ENDIF ; memdisk
          call ausschrift

          cmp readme_mode,true
          ; in readme mode place a small cursor on the status line
          mov cx,[cursor_insert]
          je readme_edit_nocursor

          mov dx,edit_cursor_x
          dec dx
          sub dx,left_invisible_columns
          mov ax,edit_cursor_y
          dec ax
          sub ax,jetzige_zeilennummer
          mov dh,al
          call GotoXY

          mov cx,[cursor_insert]
          call is_overwrite_mode
          if_z <mov cx,[cursor_overwrite]>

  readme_edit_nocursor:
          call setcursor

          call tastendruck

          cmp al,27                             ; ESC
          je done_view_file
          cmp ax,04400h                         ; F10
          je done_view_file


          cmp ax,04800h                         ; up
          jne not_view_file_up
          mov ax,1
          call dec_line_or_dec_cursor_line

          jmp refresh_display_view_file

  not_view_file_up:
          cmp ax,05000h                         ; down
          jne not_view_file_down
          mov ax,1
          call inc_line_or_inc_cursor_line
          jmp refresh_display_view_file

  not_view_file_down:

          cmp ax,04b00h                         ; left
          jne not_edit_left

          mov cx,1
          call left_cursor_cx
          jmp refresh_display_view_file

  not_edit_left:

          cmp ax,04d00h                         ; right
          jne not_edit_right

          mov cx,1
          call right_cursor_cx
          jmp refresh_display_view_file

  not_edit_right:

          cmp ax,04900h                         ; page up
          jne not_file_pageup
          call WindMax
          shr ax,8
          dec ax
          call dec_line_or_dec_cursor_line
          jmp refresh_display_view_file

  not_file_pageup:

          cmp readme_mode,true
          jne not_readme_additional_pagedown_keys
          cmp al,' '                            ; space
          je view_file_pagedown
          cmp al,13                             ; enter
          je view_file_pagedown
  not_readme_additional_pagedown_keys:
          cmp ax,05100h                         ; page down
          jne not_view_file_pagedown
  view_file_pagedown:
          call WindMax
          shr ax,8
          dec ax
          call inc_line_or_inc_cursor_line
          jmp refresh_display_view_file

  not_view_file_pagedown:

          cmp ax,08400h                         ; Ctrl+PageUp
          je view_file_first_page
          cmp ax,04700h                         ; Home
          jne not_view_file_home

IFDEF memdisk
          cmp readme_mode,true
          jne edit_file_home
ENDIF ; memdisk

  view_file_first_page:
          cmp readme_mode,true
          jne view_file_first_page_editor
          mov ax,jetzige_zeilennummer
          call dec_line_or_dec_cursor_line
          jmp refresh_display_view_file
  view_file_first_page_editor:
          mov ax,edit_cursor_y
          dec ax
          call dec_line_or_dec_cursor_line
IFDEF memdisk
         ;jmp edit_file_home
  edit_file_home:
          call GoToBeginOfLine
ENDIF ; memdisk
          jmp refresh_display_view_file

  not_view_file_home:

          cmp ax,07600h                         ; Ctrl+PageDown
          je view_file_last_page
          cmp ax,04f00h                         ; End
          jne not_view_file_end

IFDEF memdisk
          cmp readme_mode,true
          jne edit_file_end
ENDIF ; memdisk

  view_file_last_page:
          cmp readme_mode,true
          jne view_file_last_page_editor
          mov ax,anzahl_zeilen
          call inc_line_or_inc_cursor_line
          call WindMax
          shr ax,8                              ; 24*$100+79->24
          dec ax                                ; 24->23
          call dec_line_or_dec_cursor_line
          jmp refresh_display_view_file
  view_file_last_page_editor:
          mov cx,anzahl_zeilen
          sub cx,edit_cursor_y
          call inc_line_or_inc_cursor_line

IFDEF memdisk
         ;jmp edit_file_end
  edit_file_end:
          call GoToEndOfLine
ENDIF ; memdisk

          jmp refresh_display_view_file

  not_view_file_end:

          cmp ax,04100h                         ; F7
          jne not_view_file_F7

  view_file_search_input:
          call input_searchstring
  view_file_search:
          call readme_search
          jmp refresh_display_view_file

  not_view_file_F7:
          cmp ax,05a00h                         ; Shift+F7
          jne not_view_file_shift_F7

          cmp Byte Ptr [readme_search_string+0],0
          je view_file_search_input
          jmp view_file_search

  not_view_file_shift_F7:

          IFDEF memdisk

          ; now Edtor-only actions...

          cmp readme_mode,true
          je refresh_display_view_file

          ; <- add edit key handling here

          ;----------------------------------------------------------
          cmp ax,09200h                         ; Ctrl+Insert
          jne not_edit_ctrl_insert
          push ax
          call keyboard_status
          test ax,keyboard_status0_ctrl
          pop ax
          jz not_edit_ctrl_insert

          call FreeClipBoard
          mov bx,edit_zeilenzeiger_ptr
          movzx eax,Word Ptr gs:[bx]
          mov [clipboard_size],ax
          test ax,ax
          jz done_edit_ctrl_insert
          mov si,Offset clipboard_ptr
          call getmem
          mov cx,ax
          pusha
          push ds
          push es
            cld
            push es
            pop ds
            les di,cs:[si]
            mov si,cs:[edit_puffer_ofs]
            rep movsb
          pop es
          pop ds
          popa
  done_edit_ctrl_insert:
          jmp refresh_display_view_file

  not_edit_ctrl_insert:
          ;----------------------------------------------------------
          cmp ax,05200h                         ; (Shift+)Insert
          jne not_edit_shift_insert

          push ax
          call keyboard_status
          test ax,keyboard_status0_right_shift+keyboard_status0_left_shift
          pop ax
          jz not_edit_shift_insert

          mov cx,[clipboard_size]
          jcxz done_edit_shift_insert

          push edit_cursor_x
          push fs
            lfs si,[clipboard_ptr]
  loop_edit_shift_insert:
            mov al,fs:[si]
            inc si
            call insert_char_at_cursor
            loop loop_edit_shift_insert
          pop fs
          pop edit_cursor_x

  done_edit_shift_insert:
          jmp refresh_display_view_file

  not_edit_shift_insert:
          ;----------------------------------------------------------
          cmp ax,07300h                         ; Ctrl+Left
          jne not_edit_ctrl_left
          push ax
          call keyboard_status
          test ax,keyboard_status0_ctrl
          pop ax
          jz not_edit_ctrl_left

          jmp ctrl_left_find_word_loop

  edit_ctrl_left_previous_line:
          cmp edit_cursor_y,1
          je edit_ctrl_left_done
          mov ax,1
          call dec_line_or_dec_cursor_line
          call GoToEndOfLine
  ctrl_left_find_word_loop:
          call IsBeginOfLine
          jz edit_ctrl_left_previous_line
          mov cx,1
          call left_cursor_cx
          mov ax,0
          call retrieve_cursorchar
          call IsWordChar
          jnc ctrl_left_find_word_loop

          ; cursor is in word. search ' ' before word (or begin of line)
  ctrl_left_find_wordbegin_loop:
          mov ax,-1
          call retrieve_cursorchar
          call IsWordChar
          jnc edit_ctrl_left_done
          mov cx,1
          call left_cursor_cx
          jmp ctrl_left_find_wordbegin_loop
  edit_ctrl_left_done:
          jmp refresh_display_view_file

  not_edit_ctrl_left:

          ;----------------------------------------------------------
          cmp ax,07400h                         ; Ctrl+Right
          jne not_edit_ctrl_right
          push ax
          call keyboard_status
          test ax,keyboard_status0_ctrl
          pop ax
          jz not_edit_ctrl_right

  ctrl_right_find_word_loop:
          ; skip space or word chars
          call IsEndOfLine
          jz edit_ctrl_right_next_line          ; left words done

          mov cx,1
          call right_cursor_cx
          mov ax,0
          call retrieve_cursorchar
          call IsWordChar
          jnc ctrl_right_find_wordbegin_loop    ; left words done
          jmp ctrl_right_find_word_loop         ; still left word

  edit_ctrl_right_next_line:
          mov ax,anzahl_zeilen
          cmp edit_cursor_y,ax
          je edit_ctrl_right_done
          mov ax,1
          call inc_line_or_inc_cursor_line
          call GoToBeginOfLine
  ctrl_right_find_wordbegin_loop:
          call IsEndOfLine
          jz edit_ctrl_right_next_line
          ; search right until word begin char
          mov ax,0
          call retrieve_cursorchar
          call IsWordChar
          jc edit_ctrl_right_done
          mov cx,1
          call right_cursor_cx
          jmp ctrl_right_find_wordbegin_loop
  edit_ctrl_right_done:
          jmp refresh_display_view_file

  not_edit_ctrl_right:

          ;----------------------------------------------------------
          cmp ax,03b00h                         ; F1
          jne not_edit_f1_help

          mov cx,[cursor_invisible]
          call setcursor
          mov si,Offset message_edithelp
          call ausschrift
          call WindMax
          mov dx,ax
          mov dl,0
          call GotoXY
          mov cx,[cursor_insert]
          call setcursor
          mov si,Offset message_edithelp_key
          call ausschrift
          jmp refresh_display_view_file

  not_edit_f1_help:
          ;----------------------------------------------------------
          cmp al,00dh                           ; Enter
          jne not_edit_enter

          call insert_linebreak_at_cursor
          jmp refresh_display_view_file

  not_edit_enter:
          ;----------------------------------------------------------
          cmp al,008h                           ; Backspace
          jne not_edit_backspace

          cmp edit_cursor_x,1
          je backspace_begin_of_line

          mov cx,1
          call left_cursor_cx
          jmp continue_edit_del

  backspace_begin_of_line:

          ; any linebreak before cursor?
          cmp edit_cursor_y,1
          jbe refresh_display_view_file

          ; go to end of previous line
          mov ax,1
          call dec_line_or_dec_cursor_line
          call GoToEndOfLine
          jmp continue_edit_del

  not_edit_backspace:
          ;----------------------------------------------------------
          cmp ax,00e7fh                         ; Ctrl+Backspace
          jne not_edit_ctrl_backspace
          push ax
          call keyboard_status
          test ax,keyboard_status0_ctrl
          pop ax
          jz not_edit_ctrl_backspace

          ; delete word left
          call IsBeginOfLine                    ; no word?
          jz backspace_begin_of_line

          mov ax,-1
          call retrieve_cursorchar
          call IsWordChar
          setc dh                               ; remember delete word/space
  loop_edit_ctrl_backspace:
          mov cx,1                              ; clear one char
          call left_cursor_cx
          call delete_char_after_cursor
          call IsBeginOfLine                    ; until start of line
          jz done_edit_ctrl_backspace

          mov ax,-1
          call retrieve_cursorchar
          call IsWordChar                       ; or until before begin of word
          setc dl
          cmp dl,dh
          je loop_edit_ctrl_backspace

  done_edit_ctrl_backspace:
          jmp refresh_display_view_file

  not_edit_ctrl_backspace:
          ;----------------------------------------------------------
          cmp al,'T'-'@'                        ; Ctrl+T
          jne not_edit_ctrl_t
          push ax
          call keyboard_status
          test ax,keyboard_status0_ctrl
          pop ax
          jz not_edit_ctrl_t
          call IsEndOfLine
          jz edit_delete_at_lineend
          mov ax,0
          call retrieve_cursorchar
          call IsWordChar
          setc dh                               ; remember delete word/space
  loop_edit_ctrl_t:
          call IsEndOfLine
          jz edit_ctrl_t_done
          call delete_char_after_cursor
          mov ax,0
          call retrieve_cursorchar
          call IsWordChar                       ; until end of word or EOL
          setc dl
          cmp dh,dl
          je loop_edit_ctrl_t
  edit_ctrl_t_done:
          jmp refresh_display_view_file
  not_edit_ctrl_t:
          ;----------------------------------------------------------
          cmp ax,05300h                         ; Del
          jne not_edit_del

  continue_edit_del:
          ; delete linebreak?
          call IsEndOfLine
          jz edit_delete_at_lineend

          ; delete singe char
          call delete_char_after_cursor
          jmp refresh_display_view_file

  edit_delete_at_lineend:
          ; delete at end of last line?
          mov ax,edit_cursor_y
          cmp ax,anzahl_zeilen
          if_b <call delete_linebreak_after_cursor>
          jmp refresh_display_view_file

  not_edit_del:
          cmp ax,05200h                         ; Insert
          jne not_edit_insert

          xor [insertmode],080h
          jmp refresh_display_view_file

  not_edit_insert:
          cmp al,'Y'-'@'                        ; Ctrl+Y
          jne not_edit_ctrlY
          push ax
          call keyboard_status
          test ax,keyboard_status0_ctrl
          pop ax
          jz not_edit_ctrlY

          ; go to start of line
          call GoToBeginOfLine
          ; delete all chars while not eol, then remove linebreak
    loop_edit_ctrl_y:
          call IsEndOfLine
          jz edit_delete_at_lineend
          call delete_char_after_cursor
          jmp loop_edit_ctrl_y

  not_edit_ctrlY:
          cmp al,' '                            ; printable char
          jb not_insertable_char

          call is_overwrite_mode
          jnz edit_insert_char

          call OverwriteCharAtCursor
          jmp refresh_display_view_file

  edit_insert_char:
          call insert_char_at_cursor
          jmp refresh_display_view_file

  not_insertable_char:

          ENDIF ; memdisk

          jmp refresh_display_view_file


  done_view_file:

          ; restore STEP display
          pop ax
          mov [debugoption],al

          IFDEF memdisk

          cmp readme_mode,true
          je exit_view_file

          call calculate_edit_crc
          cmp [edit_crc],0
          je exit_view_file

          call WindMax
          mov dx,ax
          mov dl,0
          call GotoXY
          mov si,Offset message_edit_save_changes
          call ausschrift
          call tastendruck_lowercase
          cmp al,key_edit_save_changes_yes
          je exit_view_file
          cmp al,key_edit_save_changes_no
          jne loop_view_file

          and [edit_crc],0

          ENDIF ; memdisk

  exit_view_file:

        popad
        pop fs
        pop es
        ret
a_endp  view_edit_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

maxlength_searchstring  equ 40

; length, chars, terminator char
readme_search_string:   db 0,maxlength_searchstring dup (' '),0
; 0=insert before first char..20=after last char
readme_search_cursor    db 0
screenpos_searchstring  dw ?

message_input_searchstring      db msg_Search_for,string_ClrEol,0

a_proc  input_searchstring
        push es
        pushad
          push ds
          pop es
          call WindMax
          mov dx,ax
          mov dl,0
          call GotoXY
          mov si,Offset message_input_searchstring
          call ausschrift
          call WhereXY
          mov [screenpos_searchstring],ax
  loop_input_search_string:
          mov dx,[screenpos_searchstring]
          call GotoXY
          mov si,Offset readme_search_string+1
          call ausschrift
          mov dx,[screenpos_searchstring]
          add dl,[readme_search_cursor]
          call GotoXY
          mov cx,[cursor_insert]
          call is_overwrite_mode
          if_z <mov cx,[cursor_overwrite]>
          call setcursor

          call tastendruck

          ; enter key -> do search
          cmp al,13
          je exit_input_search_string

          ; esc key -> cancel search
          cmp al,27
          jne not_readme_search_input_esc

          mov di,Offset readme_search_string
          cmp Byte Ptr [di],0                   ; if searchstring='' then
          je exit_input_search_string           ;   Exit
          cld                                   ; else searchstring:=''...
          mov al,0
          stosb
          mov cx,maxlength_searchstring
          mov al,' '
          rep stosb
          mov [readme_search_cursor],0
          jmp loop_input_search_string
  not_readme_search_input_esc:

          ; home key -> set cursur to 0
          cmp ax,04700h                         ; pos1
          jne not_readme_search_input_home
          mov [readme_search_cursor],0
          jmp loop_input_search_string
  not_readme_search_input_home:

          ; end key -> set cursor to end of string
          cmp ax,04f00h                         ; end
          jne not_readme_search_input_end
          mov al,Byte Ptr [readme_search_string]
          mov [readme_search_cursor],al
          jmp loop_input_search_string
  not_readme_search_input_end:

          ; left key -> set cursor one char left, if possible
          cmp ax,04b00h
          jne not_readme_search_input_left
          cmp [readme_search_cursor],0
          if_ne <dec [readme_search_cursor]>
          jmp loop_input_search_string
  not_readme_search_input_left:

          ; right key -> set cursor one char right, if possible
          cmp ax,04d00h
          jne not_readme_search_input_right
          mov al,Byte Ptr [readme_search_string+0]
          cmp al,[readme_search_cursor]
          if_a <inc [readme_search_cursor]>
          jmp loop_input_search_string
  not_readme_search_input_right:

          ; del -> if not last position erase char, add ' ' to buffer
          cmp ax,05300h
          jne not_readme_search_input_del
  readme_search_input_del:
          mov al,[readme_search_cursor]
          cmp al,Byte Ptr [readme_search_string+0]
          jae loop_input_search_string                  ; exit if not before end
          dec Byte Ptr [readme_search_string+0]
          movzx si,al
          mov cx,maxlength_searchstring-1
          sub cx,si
          add si,Offset readme_search_string+1
  readme_searchstring_char_del_loop:
          test cx,cx
          jz loop_input_search_string
          mov al,' '
          xchg al,[si+1]
          mov [si],al
          dec cx
          inc si
          jmp readme_searchstring_char_del_loop
  not_readme_search_input_del:

          ; backspace -> if not first position, go one back and do del
          cmp al,8
          jne not_readme_search_input_backspace
          cmp [readme_search_cursor],0
          je loop_input_search_string
          dec [readme_search_cursor]
          jmp readme_search_input_del
  not_readme_search_input_backspace:

          ; other control char -> ignore
          cmp al,' '
          jb loop_input_search_string

          ; other printable chars -> place into string, if possible
          mov si,Offset readme_search_string
          movzx bx,[readme_search_cursor]
          mov cx,maxlength_searchstring-1
          sub cx,bx
          jb loop_input_search_string
          cmp Byte Ptr [si],bl
          je readme_searchstring_insert
          call is_overwrite_mode
          jnz readme_searchstring_insert

          mov Byte Ptr [si+bx+1],al
          inc [readme_search_cursor]
          jmp loop_input_search_string

  readme_searchstring_insert:
          cmp Byte Ptr [si],maxlength_searchstring
          if_b <inc Byte Ptr [si]>
          lea si,[si+bx+1]
          inc [readme_search_cursor]
  readme_searchstring_char_insert_loop:
          xchg Byte Ptr [si],al
          inc si
          test cx,cx
          jz loop_input_search_string
          dec cx
          jmp readme_searchstring_char_insert_loop

  exit_input_search_string:

          mov cx,[cursor_org]
          call setcursor

        popad
        pop es
        ret
a_endp  input_searchstring

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

readme_search_string_UC db 0,maxlength_searchstring dup (' ')

a_proc  readme_search
        push es
        push fs
        push gs
        pushad

          push ds
          pop es

          ; no string?
          cmp Byte Ptr [readme_search_string+0],0
          je exit_readme_search

          ; transform to upcase
          mov si,Offset readme_search_string
          mov di,Offset readme_search_string_UC
          mov cx,maxlength_searchstring
          cld
          movsb
  transform_searchstring_upcase_loop:
          lodsb
          call upcase
          stosb
          loop transform_searchstring_upcase_loop

          lfs bp,edit_puffer_ptr
          lgs bx,zeilenzeiger_ptr

          mov bp,jetzige_readme_puffer_ofs
          mov bx,jetzige_zeilenzeiger_ptr
          mov dx,jetzige_zeilennummer

          ; skip upper 2 lines (do not find again)
          mov ax,gs:[bx]
          add bp,ax
          inc bx
          inc bx
          inc dx
          cmp readme_mode,true
          je readme_search_not_found_in_this_line

          ; setup search position for edit mode
          mov bp,edit_puffer_ofs
          mov bx,edit_zeilenzeiger_ptr
          mov dx,edit_cursor_y
          jmp readme_search_not_found_in_this_line_edit

  readme_search_not_found_in_this_line:
          ; set position to start of next line
          ; special case to find first line after cursor line
          cmp readme_mode,true
          je not_find_nextline_editline
          cmp dx,edit_cursor_y
          jne not_find_nextline_editline
          mov bp,edit_puffer_ofs
  not_find_nextline_editline:
          add bp,gs:[bx]
          inc bx
          inc bx
          inc dx
  readme_search_not_found_in_this_line_edit:

          ; beyond end of file?
          cmp dx,anzahl_zeilen
          ja exit_readme_search

          ; length of chars in this line
          ; special case if line=cursor line (remaining chars-1)
          mov cx,gs:[bx]
          cmp readme_mode,true
          je not_edit_length_of_remaining_line
          cmp dx,edit_cursor_y
          jne not_edit_length_of_remaining_line
          mov ax,edit_cursor_x
          dec ax
          cmp ax,cx
          je readme_search_not_found_in_this_line
          inc ax
          sub cx,ax
          add bp,ax

  not_edit_length_of_remaining_line:
          ; line<>''?
        ;-test cx,cx
        ;-jz readme_search_not_found_in_this_line
          ; Length(searchstring)<=Length(line)?
          movzx ax,Byte Ptr [readme_search_string_UC+0]
          cmp cx,ax
          jb readme_search_not_found_in_this_line

          mov di,Offset linebuffer_UC
          pusha
            cld
  upcase_linebuffer_loop:
            mov al,fs:[bp]
            inc bp
            call upcase
            stosb
            loop upcase_linebuffer_loop
          popa
          sub cx,ax
          inc cx

          ; cx=number of tries for this line
          ; al:=first char of search string
          mov si,Offset readme_search_string_UC+1
          mov di,Offset linebuffer_UC
          mov al,Byte Ptr [si]
          cld
  search_first_char_loop:
          repne scasb
          jnz readme_search_not_found_in_this_line

          ; compare full string
          pusha
            dec di
            movzx cx,Byte Ptr [si-1]
            repe cmpsb
          popa
          jnz search_first_char_loop

          ; found a match. set current line and exit search
          cmp readme_mode,true
          jne search_found_edit

          mov jetzige_readme_puffer_ofs,bp
          mov jetzige_zeilenzeiger_ptr,bx
          mov jetzige_zeilennummer,dx
          jmp exit_readme_search

  search_found_edit:

          cmp dx,edit_cursor_y
          jne not_edit_find_sameline
          mov ax,edit_cursor_x
          sub bp,ax
  not_edit_find_sameline:
          mov edit_puffer_ofs,bp
          mov edit_zeilenzeiger_ptr,bx
          mov ax,gs:[bx]                ; length of this line
          sub ax,cx                     ; not searched chars
          movzx cx,Byte Ptr [si-1]      ; length of search string
          sub ax,cx
          inc ax
          mov edit_cursor_x,ax
          mov edit_cursor_y,dx
          call make_cursor_visible

  exit_readme_search:

        popad
        pop gs
        pop fs
        pop es
        ret
a_endp  readme_search

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc  done_file
        pushad

          ; update insert/overwrite for BIOS
          mov al,[insertmode]
          push ds
            push bios0040
            pop ds
            and byte ptr ds:[keyboard_flag_byte0],07fh
            or  byte ptr ds:[keyboard_flag_byte0],al
          pop ds

IFDEF memdisk
          call FreeClipBoard
ENDIF ; memdisk

          mov si,Offset readme_screen
          call restore_screen

          mov cx,[cursor_org]
          call setcursor

          mov si,Offset zeilenzeiger_ptr
          call freemem

IFDEF memdisk

          cmp readme_mode,true
          je no_edit_save_file_readme

          cmp [edit_crc],0
          je no_edit_save_file_edit

          lfs si,[disk_a]                       ; delete file CS:DI
          call delete_if_file_exist_CS_DI       ; it always exist..

          call create_file
          les bx,edit_puffer_ptr
          mov cx,edit_filesize
          call write_file
          call touch_filedatetime
          call close_file

          call flush_fat_cache
          call flush_dir_cache

  no_edit_save_file_edit:

          call readme_dispose_filesystem

  no_edit_save_file_readme:

ENDIF ; memdisk


          mov si,Offset edit_puffer_ptr
          call freemem

        popad
        ret
a_endp  done_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; es:si -> es:di, cx bytes
; takes care of overlapping areas

a_proc  move_edit_buffer
        pushad
        push ds

          push es
          pop ds

          cmp si,di
          cld                                   ; prepare for forware move
          ja @@continue


          add si,cx                             ; prepare for backward move
          dec si
          add di,cx
          dec di
          std

  @@continue:
          rep movsb

          cld

        pop ds
        popad
        ret
a_endp  move_edit_buffer

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
