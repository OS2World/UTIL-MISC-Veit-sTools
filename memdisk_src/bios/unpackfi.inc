Title           process/unpack archive

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

check_header    db true

                ; fs:si=disk info
                ; fs:bp=archive directory entry
a_proc          unpack_archive
                push es
                push fs
                push gs
                pushad

                  ; clear disk label for next disk
                  mov byte ptr request_disklabel,0

                  call open_file
                  lfs si,[disk_a]
                  mov di,fs:[si].current_file
                  mov eax,fs:[di].fat_direntry.filesize
                  or eax,eax
                  if_z <trap msg_Zero_length_file>

                  mov archive_remain_length,eax
                  mov archive_buffer_position,0
                  mov archive_byte_available,0

                  mov check_header,true

  archive_file_loop:
                  call reload_buffer

                  les di,kopierpuffer_ptr
                  mov al,es:[di].btype
                  cmp check_header,false
                  je not_first_block

                  mov check_header,false
                  cmp al,bt_header
                  if_ne <trap msg_Unknown_format_damaged_archive>

  not_first_block:
                  movzx si,al
                  add si,si
                  cmp al,bt_file
                  if_ne <call newline_block_indicator>
                  cmp al,high_bt
                  if_be <jmp word ptr cs:[bt_command_table+si]>

                  trap <msg_packfile_unkn_command>

  bt_command_table:
                  dw Offset command_bt_header
                  dw Offset command_bt_nextpack
                  dw Offset command_bt_file
                  dw Offset command_bt_output
                  dw Offset command_bt_sector
                  dw Offset command_bt_volume
                  dw Offset command_bt_delete
                  dw Offset command_bt_requestdisk

  command_bt_header:
                  push ds
                  pusha
                    les di,kopierpuffer_ptr
                    add di,Offset header_block.pfversion
                    mov si,Offset soll_version
                    movzx cx,byte ptr ds:[si]
                    rep cmpsb
                    if_ne <trap msg_incorrect_archive_version>
                  popa
                  pop ds
                  jmp archive_goto_next_header


  command_bt_file:
                  pushad
                    push es

                      ; create new file
                      lfs si,[disk_m]
                      les di,kopierpuffer_ptr
                      add di,Offset file_block.filename
                      call create_file

                      ; copy attribute and timestamp
                      les di,kopierpuffer_ptr
                      mov bp,fs:[si].current_file
                      mov al,es:[di].file_block.attrib
                      mov fs:[bp].fat_direntry.attr,al
                      mov eax,es:[di].file_block.date_time
                      mov fs:[bp].fat_direntry.datetime,eax

                      ; skip header
                      mov edx,es:[di].file_block.sizeunpacked
                      mov eax,es:[di].file_block.blen
                      sub eax,es:[di].file_block.sizepacked
                      add archive_buffer_position,ax
                      sub archive_byte_available,ax

                    pop es

  unpack_file_blocks_loop:
                    test edx,edx
                    jz unpack_file_blocks_done

                    call reload_buffer
                    call unpack_buffer

                    cmp eax,0
                    if_e <trap msg_unpack_error_no_data>
                    sub edx,eax

                    ; set packed read buffer position to next block
                    add archive_buffer_position,bx
                    sub archive_byte_available,bx

                   ;lfs si,[disk_m]
                    push es
                      les bx,unpack_buffer_ptr
                      mov cx,ax
                      call write_file
                    pop es

                    jmp unpack_file_blocks_loop
  unpack_file_blocks_done:

                    lfs si,[disk_m]
                    call close_file

                  popad
                  ; position already moved to next header
                  jmp archive_file_loop


  command_bt_output:
                  push ds
                  pusha
                    lds si,kopierpuffer_ptr
                    add si,Offset output_block.messagetext
                    call ausschrift_ds_si
                  popa
                  pop ds
                  jmp archive_goto_next_header


  command_bt_sector:
                  push es
                  pushad

                    ; read sector
                    lfs si,[disk_m]
                    push cs
                    pop es
                    mov bx,Offset temp_sector
                    mov eax,fs:[si].sector0
                    mov di,1
                    call read_sector

                    ; copy code
                    push ds
                      lds si,kopierpuffer_ptr
                      push si
                        add si,Offset sector.jmp0
                        mov di,Offset temp_sector.jmp0
                        mov cx,(Offset Bootsector.bytes_per_sector)-(Offset Bootsector.jmp0)
                        cld
                        rep movsb
                      pop si
                      add si,Offset sector.bs_code
                      mov di,Offset temp_sector.bs_code
                      mov cx,(Offset Bootsector.ibm_sig)-(Offset Bootsector.bs_code)
                      rep movsb
                    pop ds

                    ; store sector
                    lfs si,[disk_m]
                   ;mov es,cs
                    mov bx,Offset temp_sector
                    mov eax,fs:[si].sector0
                    mov di,1
                    call write_sector

                  popad
                  pop es
                  jmp archive_goto_next_header


  command_bt_volume:
                  push es
                  push gs
                  pushad

                    lfs si,[disk_m]
                    call erase_volumelabel
                    call search_free_direntry

                    lgs di,kopierpuffer_ptr
                    mov eax,DWord Ptr gs:[di+0  ].volume_block.volumelabel
                    mov ebx,DWord Ptr gs:[di+4  ].volume_block.volumelabel
                    mov ecx,DWord Ptr gs:[di+8-1].volume_block.volumelabel

                    mov dword ptr fs:[bp].filenameext +0  ,eax
                    mov dword ptr fs:[bp].filenameext +4  ,ebx
                    mov dword ptr fs:[bp].filenameext +8-1,ecx
                    mov DWord Ptr fs:[si].label_volume+0  ,eax
                    mov DWord Ptr fs:[si].label_volume+4  ,ebx
                    mov DWord Ptr fs:[si].label_volume+8-1,ecx
                    mov fs:[bp].fat_direntry.attr,faVolumeID
                    mov fs:[bp].fat_direntry.datetime,((jahr-1980)*512+monat*32+tag)*010000h

                    push ecx
                    push ebx
                    push eax

                    ; read sector
                    lfs si,[disk_m]
                    push cs
                    pop es
                    mov bx,Offset temp_sector
                    mov eax,fs:[si].sector0
                    mov di,1
                    call read_sector

                    mov di,Offset temp_sector.volume_label
                    pop dword ptr es:[di+0  ]
                    pop dword ptr es:[di+4  ]
                    pop dword ptr es:[di+8-1]


                    ; store sector
                    lfs si,[disk_m]
                   ;mov es,cs
                    mov bx,Offset temp_sector
                    mov eax,fs:[si].sector0
                    mov di,1
                    call write_sector

                  popad
                  pop gs
                  pop es
                  jmp archive_goto_next_header


  command_bt_delete:
                  pushad
                  push es

                    lfs si,[disk_m]

                    ; search the wanted file on memory disk
                    les di,kopierpuffer_ptr
                    add di,Offset delete_block.delete_filename
                    call search_file

                    ; erase if found
                    cmp bp,-1
                    if_ne <call delete_file>

                  pop es
                  popad
                  jmp archive_goto_next_header

  command_bt_requestdisk:
                  push ds
                  push es
                  pushad

                    ; copy disk label
                    lds si,kopierpuffer_ptr
                    add si,Offset requestdisk_block.disklabel
                    push cs
                    pop es
                    mov di,Offset request_disklabel
                    mov cx,Size file83
                    cld
                    rep movsb

                  popad
                  pop es
                  pop ds
                 ;jmp archive_goto_next_header

  archive_goto_next_header:
                  les di,kopierpuffer_ptr
                  mov eax,es:[di].blen
                  add archive_buffer_position,ax
                  sub archive_byte_available,ax
                  jmp archive_file_loop


  command_bt_nextpack:
                  push ds
                  push es
                  pusha
                    lds si,kopierpuffer_ptr
                    add si,Offset nextpack_block.next_file
                    mov di,Offset next_archive
                    push cs
                    pop es
                    mov cx,Size file83
                    cld
                    rep movsb
                  popa
                  pop es
                  pop ds

                  les di,kopierpuffer_ptr
                  mov eax,es:[di].blen
                  add archive_buffer_position,ax
                  sub archive_byte_available,ax

                  cmp archive_byte_available,0
                  if_ne <trap msg_useless_data_in_archive>

                  lfs si,[disk_a]
                  call close_file
                  mov floppy_accepted,true

                popad
                pop gs
                pop fs
                pop es
                ret
a_endp          unpack_archive

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
