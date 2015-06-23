Title   load character set to vga memory

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF cdloader
l_string font_file_fxx 'MEMBOOT.Fxx'
ELSE
font_file_fxx   file83 <'MEMBOOT ','Fxx'>
ENDIF
loc_fontsize_in_filename equ $-2

IFDEF cdloader
ptr_vgafont     ptr1616 <0,fontsegment>
ELSE
ptr_vgafont     ptr1616 <?,?>
ENDIF
size_vgafont    dd ?

; setting 9 point wide fonts is nice, assume that the BIOS does this
; by default.
; clearing the 9th point would make the graphics chars ugly,
; but could make alpha chars better readable instead.
; for cyrillic, this seem to be no problem, better keep the block graphic
; automatic that completes it to 9 points.

IFDEF uglu_empty_point9

video_port_base_add             dw 0
org_line_graphics_enable        db 0
org_dot_clocks_per_character    db 0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          port_delay
                pusha
                  mov cx,100
  port_delay_loop:
                  out 0ebh,al
                  loop port_delay_loop
                popa
                ret
a_endp          port_delay

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          reset_atc_index_mov_dx_3c0
                pusha
                  mov dx,03dah
                  add dx,video_port_base_add
                  in al,dx
                  call port_delay
                popa
                mov dx,03c0h
                add dx,video_port_base_add
                ret
a_endp          reset_atc_index_mov_dx_3c0

ENDIF   ; uglu_empty_point9

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          generate_font_filename
                push ax
                push es

                  push bios0040
                  pop es
                  mov ax,Word Ptr es:[char_matrix_height]

                  and size_vgafont,0
                  mov Byte Ptr ds:[size_vgafont+1],al ; file size for 8x16=8*256

                  aam                           ; .Fxx 0008
                  add ax,'00'                   ;      '08'
                  xchg al,ah                    ;      '80'
                  mov Word Ptr ds:[Offset loc_fontsize_in_filename],ax

                pop es
                pop ax
                ret
a_endp          generate_font_filename

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF cdloader

a_proc          load_vga_font_file
                push es
                push fs
                pushad

IFDEF memdisk
                  mov al,'S'
                  call notify_drive_access
ENDIF ; memdisk

                  mov eax,Size disk_info
                  mov si,Offset disk_a
                  call getmem

                  call init_crc32

                  mov dl,boot_drive             ; CD ROM source
                  mov dh,sourcetype_primary
                  mov eax,boot_sector_rel       ; partition boot sector
                  lfs si,disk_a
                  call load_disk_info

                  push cs
                  pop es
                  mov di,Offset font_file_fxx
                  call search_file
                  cmp bp,-1
                  je no_fontfile_found

                  mov ecx,size_vgafont
                  cmp fs:[bp].fat_direntry.filesize,ecx
                  jne no_fontfile_found

                  push si
                  push ecx
                    call round_up_to_sectorsize
                    mov si,Offset ptr_vgafont
                    mov eax,ecx
                    call getmem
                  pop ecx
                  pop si

                  ; fs:bp
                  call open_file

                  les bx,ptr_vgafont
                 ;mov ecx,ecx
                  call read_file

                  call close_file


                  call load_vga_font


                  mov si,Offset ptr_vgafont
                  call freemem

  no_fontfile_found:

                  call free_crc32

                  mov si,Offset disk_a
                  call freemem


                popad
                pop fs
                pop es
                ret
a_endp          load_vga_font_file

ENDIF ; -cdloader

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          load_vga_font
                push es
                pusha

IFDEF uglu_empty_point9
                  mov dx,03cch          ; misc output register(R)
                  in al,dx
                  and ax,1              ; 0->3B4=3D4-020 1->3D4=3D4+0
                  shl ax,5
                  sub ax,020h
                  mov video_port_base_add,ax

                  ; read 3c0 index 10
                  call reset_atc_index_mov_dx_3c0

                  mov al,10h                    ; -video,index 10
                  out dx,al
                  call port_delay

                  inc dx
                  in al,dx
                  call port_delay
                  mov org_line_graphics_enable,al

                  call reset_atc_index_mov_dx_3c0
                  mov al,20h                    ; +video
                  out dx,al
                  call port_delay


                  ; read 3c4 index 1

                  mov dx,video_port_base_add
                  add dx,03c4h
                  mov al,1
                  out dx,al
                  call port_delay
                  inc dx
                  in al,dx
                  call port_delay
                  mov org_dot_clocks_per_character,al

ENDIF   ; uglu_empty_point9


                  mov ax,01110h                 ; TEXT-MODE CHARGEN - LOAD USER-SPECIFIED PATTERNS
                  mov bx,Word Ptr [size_vgafont]; byte per char (bh)
                  mov bl,0                      ; block 0
                  mov cx,256
                  mov dx,0
                  les bp,ptr_vgafont
                  call int_10h

IFDEF uglu_empty_point9

                  test org_dot_clocks_per_character,1
;i n t  3
                  jnz skip_change_9xfont

                  ; update 3c4 index 1 (enable 9*Y font display)

                  mov dx,video_port_base_add
                  add dx,03c4h
                  mov al,1
                  out dx,al
                  call port_delay
                  inc dx
                  in al,dx
                  call port_delay
                  mov ah,0ffh-1
                  and ah,al
                  mov al,1
                  dec dx
                  out dx,al
                  call port_delay
                  inc dx
                  mov al,ah
                  out dx,al
                  dec dx
                  call port_delay

                  ; disable 9.point for all chars (
                  ; update 3c0 index 10
                  call reset_atc_index_mov_dx_3c0

                  mov al,10h+20h                ; -video,index 10
                  out dx,al
                  call port_delay

                  inc dx
                  in al,dx
                  call port_delay

                  mov ah,0ffh-4                 ; line graphics disable
                  and ah,al

                  call reset_atc_index_mov_dx_3c0

                  mov al,10h                    ; -video,index 10
                  out dx,al
                  call port_delay

                  mov al,ah
                  out dx,al
                  call port_delay

                  call reset_atc_index
                  mov al,20h                    ; +video
                  out dx,al
                  call port_delay


  skip_change_9xfont:

ENDIF   ; uglu_empty_point9

                popa
                pop es
                ret
a_endp          load_vga_font

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

