Title   MemDisk file loader+unpacker+writer

; Veit Kannegieser 2002.01.31

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; procesed files:
;
; Q=CDROM source
; A=first floppy
; B=second floppy
;
; 1. Q:\MEMDISK.PF, multivolume copy all *.* without *.pf if disk has used .pf
; 2. A:\*.*: unpack *.pf and copy other. no multivolume
; 3. same as 2.
;
; Q can be a floppy or a FAT12/16 partition
; A/B must be floppy

; restriction: multivolume does not work to continue Q:\disk2 on A:\disk3


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                        ; 32 KB Blockgr”áe,32 KB Bl”cke in packfile
kopierpuffer_ptr        dd 0
kopierpuffer_size       equ (min_buffer_fill+2048)
unpack_buffer_ptr       dd 0
unpack_buffer_size      equ kopierpuffer_size


request_disklabel       file83 < 0        , 0   >
next_archive            file83 <'MEMDISK ','PF '>

filename_boot_upd_txt   file83 <'BOOT_UPD','TXT'>
vol_label_boot_update   file83 <'BOOT_UPD','ATE'>
vol_label_boot_update2  file83 <'BOOT_UPD','   '>

disk_a                  dd ?
disk_m                  dd ?
disk_hd                 dd ?

primary_source_crc      dd -1

archive_remain_length   dd ?
archive_buffer_position dw ?    ; 0=@kopierpuffer
archive_byte_available  dw ?

                        soll_version_mac soll_version


message_insert_disk_with_label1 db msg_Insert_floppy_with_label_press_key_1,0
message_insert_disk_with_label2 db msg_Insert_floppy_with_label_press_key_2,0
message_insert_disk_with_file1  db msg_Insert_floppy_with_file_press_key_1,0
message_insert_disk_with_file2  db msg_Insert_floppy_with_file_press_key_2,0

floppy_accepted                 db false
block_indicator                 db 0 ; or 80 if ş output ; mod 4 = divide

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          load_and_unpack_files
                pushad

                  mov eax,Size disk_info
                  mov si,Offset disk_a
                  call getmem

                  mov eax,Size disk_info
                  mov si,Offset disk_m
                  call getmem

                  mov eax,unpack_buffer_size
                  mov si,Offset unpack_buffer_ptr
                  call getmem

                  mov eax,kopierpuffer_size
                  mov si,Offset kopierpuffer_ptr
                  call getmem

                  call init_crc32

                  mov dl,boot_drive                     ; CD ROM source
                  mov dh,sourcetype_primary
                  mov eax,boot_sector_rel               ; partition boot sector
                  call process_archive

                  push fs
                    lfs si,cs:[disk_a]
                    mov eax,fs:[si].directory_crc
                    mov primary_source_crc,eax
                  pop fs

                popad

                ret
a_endp          load_and_unpack_files

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          process_updates
                pushad

; Compaq Armada M700 causes "Memory Control Block Corrupted" on UPDB
; check for F000:FFE8 '03COMPAQ' and disable B: in this case.
                  push ds
                    push 0f000h
                    pop ds
                    cmp DWord Ptr ds:[0ffe8h+0],'OC30'
                    setne al
                    cmp DWord Ptr ds:[0ffe8h+4],'QAPM'
                    setne ah
                  pop ds
                  or al,ah
                  and [cfg_record.cfg_update_floppy_B],al

; int 11 does not help
; faulty machine claims to have 1+1 drives..

                  call pruefe_speicherkette

                  mov dl,0                              ; first floppy
                  mov dh,sourcetype_update
                  sub eax,eax                           ; boot sector

                  STEP 'UPDA'
                  cmp [cfg_record.cfg_update_floppy_A],true
                  if_e <call process_archive>

                  call pruefe_speicherkette

                  STEP 'UPDB'
                  inc dl                                ; second floppy
                  cmp [cfg_record.cfg_update_floppy_B],true
                  if_e <call process_archive>


                  STEP 'UPDR'
                  ; free memory no longer needed - in reverse allocation order

                  call free_crc32

                  mov si,Offset kopierpuffer_ptr
                  call freemem

                  mov si,Offset unpack_buffer_ptr
                  call freemem

                  mov si,Offset disk_m
                  call freemem

                  mov si,Offset disk_a
                  call freemem

                popad
                ret
a_endp          process_updates

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

begin_extended  dd ?

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          search_memdisk
                pushad
                push es

                  mov fs:[si].disknum,'M'

                  mov ax,word ptr cs:MemDiskBIOS_Info._anzahl_sektoren_je_spur
                  mov fs:[si].sectors_track,ax
                  mov ax,word ptr cs:MemDiskBIOS_Info._anzahl_koepfe
                  mov fs:[si].heads,ax

                  sub eax,eax
                  mov fs:[si].sector0,eax
                  mov begin_extended,eax

  search_EMBR:
                  ; read (E)MBR
                  push cs
                  pop es
                  mov bx,Offset temp_sector
                  mov eax,fs:[si].sector0
                  call read_1_sector_eax

                  cmp es:[bx].ibm_sig,0aa55h
                  if_ne <trap msg_invalid_partition_table_on_memdisk>

                  add bx,partition1

                  ; look for active primary partition
                  mov cx,4
  search_primary_partition:
                  test es:[bx].partition_entry.boot_indicator,080h
                  jnz partition_found
                  add bx,Size partition_entry
                  loop search_primary_partition

                  ; look for extended partition chain
                  sub bx,4*(Size partition_entry)
                  mov cx,4
  search_extended_partition:
                  cmp es:[bx].partition_entry.system_indicator,005h ; normal extended partition
                  je found_extended
                  ; since we created the partition table structure,
                  ; we only need to check for type 05 extended partition (not 0f,15,85,..)
                 ;cmp es:[bx].partition_entry.system_indicator,00fh ; stupidly reinvented by MS
                 ;je found_extended
                 ;cmp es:[bx].partition_entry.system_indicator,015h ; ?
                 ;je found_extended
                 ;cmp es:[bx].partition_entry.system_indicator,085h ; stupid Linux
                 ;je found_extended

                  add bx,Size partition_entry
                  loop search_extended_partition

                  trap msg_No_active_primary_or_extended_part

  found_extended:
                  mov eax,es:[bx].partition_entry.sectors_preceding
                  mov edx,begin_extended
                  test edx,edx
                  if_z <mov begin_extended,eax>
                  add eax,edx
                  mov fs:[si].sector0,eax
                  jmp search_EMBR

  partition_found:
                  mov al,es:[bx].system_indicator
                  cmp al,001h                   ; FAT 12
                  je partition_found_FAT
                  cmp al,011h                   ; FAT 12
                  je partition_found_FAT
                  cmp al,004h                   ; FAT 16
                  je partition_found_FAT
                  cmp al,014h                   ; FAT 16
                  je partition_found_FAT
                  cmp al,006h                   ; FAT 16 >32M
                  je partition_found_FAT
                  cmp al,016h                   ; FAT 16 >32M
                  je partition_found_FAT

                  trap msg_Partition_on_memory_disk_is_not_FAT

  partition_found_FAT:
                  mov eax,es:[bx].partition_entry.sectors_preceding
                  add eax,begin_extended
                  mov fs:[si].sector0,eax

                pop es
                popad

                mov dl,fs:[si].disknum
                mov dh,sourcetype_primary ; is ignored for target
                mov eax,fs:[si].sector0
                ret
a_endp          search_memdisk

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          copy_all_unused_files
                pushad
                push fs

                  lfs si,cs:[disk_a]
                  call first_directory_entry
                  xchg bp,di
                  jc @@exit_copy_all_unused_files

  @@loop_copy_all_unused_files:

                  ; volume label or directory ?
                  test fs:[di].attr,(faVolumeID+faDirectory)
                  jnz @@search_next_unused_file

                  ; already unpacked ?
                  cmp fs:[di].file_used,0
                  jne @@search_next_unused_file

                  ; never copy a not used archive
                  mov eax,Dword Ptr fs:[di].filename+8
                  and eax,000ffffffh
                  cmp eax,' FP'
                  je @@search_next_unused_file


                  pushad
                  push fs
                    ; "open" source file
                    mov bp,di
                    call open_file

                    ; create file: use source filename
                    push es
                      push fs
                      pop es
                     ;mov di,di
                      mov edx,fs:[di].fat_direntry.filesize

                      lfs si,[disk_m]
                      call create_file
                    pop es

  copy_file_next_block:
                    test edx,edx
                    jz copy_file_done
                    ; copy now Min(32K,bytes left in file)
                    mov ecx,edx
                    mov eax,32*1024
                    cmp ecx,eax
                    if_a <mov ecx,eax>

                    cmp cfg_record.cfg_progress_indicator,progress_indicator_block
                    if_e <call output_block_indicator>

                    push es
                      lfs si,[disk_a]
                      les bx,kopierpuffer_ptr
                      call read_file

                      lfs si,[disk_m]
                      call write_file
                    pop es

                    sub edx,ecx
                    jmp copy_file_next_block
  copy_file_done:

                    ; copy datetime and attr; "close" files
                    lfs si,[disk_a]
                    mov di,fs:[si].current_file
                    mov bl,fs:[di].fat_direntry.attr
                    mov ecx,fs:[di].fat_direntry.datetime
                    call close_file

                    lfs si,[disk_m]
                    mov di,fs:[si].current_file
                    mov fs:[di].fat_direntry.attr,bl
                    mov fs:[di].fat_direntry.datetime,ecx
                    call close_file

                  pop fs
                  popad

  @@search_next_unused_file:
                  xchg bp,di
                  call next_directory_entry
                  xchg bp,di
                  jnc @@loop_copy_all_unused_files

  @@exit_copy_all_unused_files:

                  call newline_block_indicator

                pop fs
                popad
                ret
a_endp          copy_all_unused_files

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          unpack_all_pf_files
                pushad
                push fs
                  lfs si,cs:[disk_a]
                  call first_directory_entry
                  jc @@exit_unpack_all_pf_files

  @@loop_unpack_all_pf_files:
                  mov eax,dword ptr fs:[bp].filename+8
                  and eax,000ffffffh
                  cmp eax,' FP'
                  jne @@search_next_pf_file

                  ; volume label or directory ?
                  test fs:[bp].attr,(faVolumeID+faDirectory)
                  jnz @@search_next_pf_file

                  ; fs:bp
                  call unpack_archive

  @@search_next_pf_file:
                  call next_directory_entry
                  jnc @@loop_unpack_all_pf_files

  @@exit_unpack_all_pf_files:

                pop fs
                popad
                ret
a_endp          unpack_all_pf_files

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          newline_block_indicator
                cmp cfg_record.cfg_progress_indicator,progress_indicator_block
                jne exit_newline_block_indicator
                test block_indicator,080h
                jz exit_newline_block_indicator

                call ausschrift_zeichen_CRLF
                mov block_indicator,0

  exit_newline_block_indicator:
                ret
a_endp          newline_block_indicator

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          output_block_indicator
                push ds
                push ax

                  test cs:[block_indicator],3
                  jnz not_divide_indicator_by_4

                  ; auto wrap at -2
                  push bios0040
                  pop ds
                  movzx ax,byte ptr ds:[current_row]
                  inc ax
                  inc ax
                  cmp ax,word ptr ds:[number_of_columns]
                  if_ae <call ausschrift_zeichen_CRLF>

                  mov al,cs:cfg_record.cfg_progress_block_char
                  call ausschrift_zeichen
  not_divide_indicator_by_4:
                  inc cs:[block_indicator]      ; next 1/4
                  or  cs:[block_indicator],080h ; output happened

                pop ax
                pop ds
                ret
a_endp          output_block_indicator

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; ds:si,cx
a_proc          ausschrift_laenge
                pusha
                  jcxz exit_ausschrift_laenge

  loop_exit_ausschrift_laenge:
                  cld
                  lodsb
                  call ausschrift_zeichen
                  loop loop_exit_ausschrift_laenge

  exit_ausschrift_laenge:
                popa
                ret
a_endp          ausschrift_laenge

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; ds:si,cx
a_proc          output_trim_spaces
                pusha

                  add si,cx
  search_stringend_output_trim_spaces:
                  jcxz stringend_output_trim_spaces

                  cmp byte ptr ds:[si-1],' '
                  jne stringend_output_trim_spaces

                  dec si
                  loop search_stringend_output_trim_spaces

  stringend_output_trim_spaces:

                  sub si,cx
                 ;call ausschrift_laenge

                  mov di,Offset str_puffer
                  cld
                  push di
                    rep movsb
                    mov Byte Ptr [di],0
                  pop si
                  call StrCat_messagestring

                popa
                ret
a_endp          output_trim_spaces

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; ds:si
a_proc          output_filename83
                pusha
                  mov cx,8
                  call output_trim_spaces
                  add si,cx
                  cmp Word Ptr ds:[si+0],'  '
                  jne has_extension
                  cmp Byte Ptr ds:[si+2],' '
                  je without_extension
  has_extension:
                 ;mov al,'.'
                 ;call ausschrift_zeichen
                  push si
                    mov si,Offset str_puffer
                    mov Word Ptr [si],'.'
                    call StrCat_messagestring
                  pop si
                  mov cx,3
                  call output_trim_spaces

  without_extension:

                popa
                ret
a_endp          output_filename83

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          output_label83
                pusha
                  mov cx,8+3
                  call output_trim_spaces
                popa
                ret
a_endp          output_label83

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

message_update_permissed_by_updatefile    db msg_update_permissed_by_updatefile,13,10,0
message_update_permissed_by_volumelabel   db msg_update_permissed_by_volumelabel,13,10,0
message_update_not_permissed              db msg_update_not_permissed,13,10,0

                ; dl=source drive
                ; dh=sourcetype_primary or sourcetype_update
                ; eax starting sector number
a_proc          process_archive
                pushad
                push es

                  push cs
                  pop es

                  pushad
                    lfs si,[disk_m]
                    call search_memdisk
                    call load_disk_info
                  popad

  next_floppy:
                  push ax
                    mov al,'A'
                    add al,dl
                    cmp dh,0
                    if_e <mov al,'S'>
                    call notify_drive_access
                  pop ax

                 ;mov dl,dl
                 ;mov dh,dh
                 ;mov eax,eax
                  lfs si,cs:[disk_a]

                  call load_disk_info
                  jc was_not_readable

                  mov floppy_accepted,false
                  cmp fs:[si].sourcetype,sourcetype_update
                  jne unpack_first_archive

                  ; check for presence signature label "BOOT_UPDATE" or "BOOT_UPD.TXT"
                  mov di,offset filename_boot_upd_txt
                  call search_file
                  mov bx,Offset message_update_permissed_by_updatefile
                  cmp bp,-1
                  jne update_permissed

                  mov di,offset vol_label_boot_update
                  call compare_volumelabel
                  mov bx,Offset message_update_permissed_by_volumelabel
                  jz update_permissed

                  mov di,offset vol_label_boot_update2
                  call compare_volumelabel
                  mov bx,Offset message_update_permissed_by_volumelabel
                  jnz update_not_permissed

  update_permissed:
                  push si
                    mov si,bx
                    call ausschrift
                  pop si
                  ; 1. unpack *.pf
                  call unpack_all_pf_files

                  ; 2. copy all other files
                  call copy_all_unused_files
                  jmp was_last_archive

  update_not_permissed:
                  push si
                    mov si,offset message_update_not_permissed
                    call ausschrift
                  pop si
                  jmp was_last_archive


  unpack_first_archive:

                  ; mark memdisk.bin as used
                  mov di,offset nocopyfiles_start
  @@mark_no_copy_files_loop:
                  call search_file
                  cmp bp,-1
                  if_ne <mov fs:[bp].fat_direntry.file_used,1>
                  add di,Size file83
                  cmp di,offset nocopyfiles_end
                  jb @@mark_no_copy_files_loop

                  ; exclude all disk images (for floppy boot emulation)
                  call first_directory_entry
                  jc @@mark_disk_image_files_done
  @@mark_disk_image_files_loop:
                  mov eax,DWord Ptr fs:[bp+8].filenameext
                  and eax,000ffffffh
                  cmp eax,extension_img
                  jne @@mark_disk_image_files_next
                  mov eax,fs:[bp].filesize
                  cmp eax,size_1440
                  je  @@mark_disk_image_files_is_imagefile
                  cmp eax,size_2880
                  je  @@mark_disk_image_files_is_imagefile
                  cmp eax,size_4320
                  jne @@mark_disk_image_files_next

  @@mark_disk_image_files_is_imagefile:
                  mov fs:[bp].fat_direntry.file_used,1

  @@mark_disk_image_files_next:
                  call next_directory_entry
                  jnc @@mark_disk_image_files_loop

  @@mark_disk_image_files_done:


  unpack_next_archive:
                  lfs si,cs:[disk_a]
                  ; does the floppy contain the archive ?
                  mov di,offset next_archive
                  call search_file
                  cmp bp,-1
                  jne archive_found

                  ; no. copy all unknown files if it was our disk.
                  cmp floppy_accepted,true
                  jne can_not_copy_all_unused_files
                  cmp cfg_record.cfg_update_primary_plain,true
                  jne can_not_copy_all_unused_files
                  call copy_all_unused_files
  can_not_copy_all_unused_files:

                  ; blank filename=no more archives follow
                  cmp dword ptr es:[di+0],'    '
                  jne not_blank_next_archive
                  cmp dword ptr es:[di+4],'    '
                  je was_last_archive

  not_blank_next_archive:
                  ; prompt user
                  call key_box_init
                  cmp byte ptr request_disklabel,0      ; disk lable known ?
                  je insert_request_by_filename         ; no, ask for file

  insert_request_by_disklabel:
                  mov si,Offset message_insert_disk_with_label1
                  call StrCat_messagestring
                  mov si,Offset request_disklabel
                  call output_label83
                  mov si,Offset message_insert_disk_with_label2
                  call StrCat_messagestring
                  jmp insert_request_continue

  insert_request_by_filename:
                  mov si,Offset message_insert_disk_with_file1
                  call StrCat_messagestring
                  mov si,Offset next_archive
                  call output_filename83
                  mov si,Offset message_insert_disk_with_file2
                  call StrCat_messagestring
  insert_request_continue:
                 ;call tastendruck
                 ;call ausschrift_zeichen_CRLF
                  mov key_box_menu.mn_waittime,0
                  call key_box

                  lfs si,cs:[disk_a]
                  mov dl,fs:[si].disknum
                  mov eax,fs:[si].sector0
                  jmp next_floppy

  archive_found:
                  ; fs:si/fs:bp
                  call unpack_archive
                  jmp unpack_next_archive

  was_last_archive:

                  ; write buffered FAT and Root directory (MemDisk partition)
                  lfs si,[disk_m]
                  call flush_fat_cache
                  call flush_dir_cache

  was_not_readable:

                pop es
                popad
                ret
a_endp          process_archive

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          reload_buffer
                push es
                pushad

                  ; move contend to begin of buffer
                  cmp archive_buffer_position,0
                  je archive_buffer_moved

                  les di,kopierpuffer_ptr
                  mov si,di
                  add si,archive_buffer_position
                  movzx ecx,archive_byte_available
                  ror ecx,2
                  push ds
                    push es
                    pop ds
                    cld
                    rep movsd
                    rol ecx,2
                    and cx,3
                    rep movsb
                  pop ds
                  mov archive_buffer_position,0

  archive_buffer_moved:
                  ; make sure enough bytes are loaded to unpack one block
                  cmp archive_byte_available,min_buffer_fill
                  jae archive_buffer_filled
                  cmp archive_remain_length,0
                  je archive_buffer_filled

                  push fs
                    lfs si,[disk_a]
                    les bx,kopierpuffer_ptr
                    add bx,archive_byte_available
                    mov ecx,kopierpuffer_size
                    sub cx,archive_byte_available
                    sub ax,ax
                    sub ax,fs:[si].sector_size_b
                    and cx,ax ; -512 ; full sector space available
                    cmp ecx,archive_remain_length
                    if_a <mov ecx,archive_remain_length>
                    call read_file
                    add archive_byte_available,cx
                    sub archive_remain_length,ecx
                  pop fs

  archive_buffer_filled:

                popad
                pop es
                ret
a_endp          reload_buffer

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                ; -> eax unpacked len
                ; -> ebx packed len
a_proc          unpack_buffer
                push si
                push di
                push ds
                push es


                  cmp cfg_record.cfg_progress_indicator,progress_indicator_block
                  if_e <call output_block_indicator>

                  les di,unpack_buffer_ptr
                  lds si,kopierpuffer_ptr
                  call aPsafe_depack_16

                pop es
                pop ds
                pop di
                pop si
                ret
a_endp          unpack_buffer

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

selbsttest      dd datum_bcd

