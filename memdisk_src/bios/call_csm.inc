Title   Call OS2CSM.BIN module

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

file_OS2CSM_BIN         file83 <'OS2CSM  ','BIN'>
file_CONFIG_SYS         file83 <'CONFIG  ','SYS'>
file_CONFIG_X           file83 <'CONFIG  ','X  '>
file_OS2CSM_SET         file83 <'OS2CSM  ','SET'>
file_OS2CSM_HLP         file83 <'OS2CSM  ','HLP'>
file_OS2LDR             file83 <'OS2LDR  ','   '>
file_OS2LDR_DEB         file83 <'OS2LDR  ','DEB'>
file_OS2KRNL            file83 <'OS2KRNL ','   '>
file_OS2KRNL_DEB        file83 <'OS2KRNLD','   '>
file_ALTF2ON____        file83 <'ALTF2ON ','$$$'>
file_OS2LOGO            file83 <'OS2LOGO ','   '>

eof_char                db 26

OS2CSM_BIN_memory       ptr1616 <>


temp_memptr             dd ?

putkey_after_configsys_edit dw -1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          call_os2csm
                push gs
                push fs
                push es
                pushad

                  STEP 'CSM1'

                  mov al,'M'
                  call notify_drive_access

                  ; allocate memory and load

                  mov eax,Size disk_info
                  mov si,Offset disk_m
                  call getmem

                  call init_crc32

                  mov dl,boot_drive             ; CD ROM source
                  mov dh,sourcetype_primary
                  mov eax,boot_sector_rel       ; partition boot sector
                  lfs si,disk_m
                  call search_memdisk
                  call load_disk_info

                  ; OS2CSM.BIN

                  mov di,Offset file_OS2CSM_BIN
                  call search_file
                  cmp bp,-1
                  jnz @@os2csm_found

                  ; prevously this was <trap msg_os2csm_not_found>
                  ; but warning and keypress are good enough
                  fehler_meldung msg_os2csm_not_found
                  jmp @@exit_os2csm_not_found

  @@os2csm_found:
                  call open_file

                  push si
                    mov eax,64*1024+15
                    mov si,Offset OS2CSM_BIN_memory
                    call getmem
                    mov ax,[si]._OFF
                    add ax,15
                    shr ax,4
                    add ax,[si]._SEG
                  pop si

                  mov es,ax
                  null bx
                  mov ecx,fs:[bp].fat_direntry.filesize
                  call round_up_to_sectorsize
                  call read_file

                  call close_file

                  push es
                  pop gs
                  mov di,bx
                  ; when having a file that is 1 byte larger than the
                  ; searched; record, then there are actualy TWO
                  ; positions that the record could be (+0 and +1)
                  mov cx,Word Ptr fs:[bp].fat_direntry.filesize
                  sub cx,(Type table_memdisk_os2csm_interface_Struc)-1
                  jbe @@os2csm_too_small
  @@search_icmd_loop:
                  cmp gs:[di].i_csm_md_sign,'ICMD'
                  jne @@icmd_next
                  cmp gs:[di].ICMD_lastbyte,Offset ICMD_lastbyte
                  je @@icmd_found
  @@icmd_next:
                  inc di
                  loop @@search_icmd_loop
  @@os2csm_too_small:
                  trap msg_Invalid_OS2CSM_BIN

  @@icmd_found:
                  mov ax,[erster_speicher_block]
                  mov gs:[di].memorymanager_anchor,ax

                  mov ax,Offset file_CONFIG_SYS
                  lea bx,[di].config_sys_memory
                  call search_getmem_open_load_close_file

                  mov ax,Offset file_CONFIG_X
                  lea bx,[di].config_x___memory
                  call search_getmem_open_load_close_file

                  mov ax,Offset file_OS2CSM_SET
                  lea bx,[di].os2csm_set_memory
                  call search_getmem_open_load_close_file

                  mov ax,Offset file_OS2CSM_HLP
                  lea bx,[di].os2csm_hlp_memory
                  call search_getmem_open_load_close_file

                  mov al,MemDiskBIOS_Info._lvm_letter
                  mov gs:[di].memdisk_drive_letter,al
                  mov gs:[di].rename_os2ldr_deb,0
                  mov gs:[di].rename_os2krnl_deb,0
                  mov al,[os2csm_mode_]
                  mov gs:[di].os2csm_mode,al
                  mov al,[cfg_record.cfg_edit_config_sys]
                  mov gs:[di].config_sys_edit,al
                  mov eax,MemDiskBIOS_Info._anzahl_sektoren
                  shr eax,11 ; sector-> MiB
                  mov gs:[di].memdisk_disksize,ax
                  call GetDiskFree
                  shr eax,20            ; MiB
                  mov gs:[di].memdisk_diskfree,ax

                  STEP 'CSM4'

                  ; execute
                  push cs
                  push Offset @@weiter_call_csm
                  push gs
                  push 0
                  retf


  @@weiter_call_csm:
                  ; save files and modified variables
                  STEP 'CSM5'

                  mov ax,Offset file_CONFIG_SYS
                  lea bx,[di].config_sys_memory
                  call save_file_freemem

                  mov ax,Offset file_CONFIG_X
                  lea bx,[di].config_x___memory
                  call save_file_freemem

                  mov ax,Offset file_OS2CSM_SET
                  lea bx,[di].os2csm_set_memory
                  call save_file_freemem

                  mov ax,Offset file_OS2CSM_HLP
                  lea bx,[di].os2csm_hlp_memory
                  call done_file_freemem

                  mov al,gs:[di].memdisk_drive_letter
                  mov MemDiskBIOS_Info._lvm_letter,al
                  call change_memdisk_drive_letter

                  mov al,gs:[di].rename_os2ldr_deb
                  call move_os2ldr_deb
                  mov al,gs:[di].rename_os2krnl_deb
                  call move_os2krnl_deb

                  mov al,gs:[di].altf2on_change
                  call apply_altf2on_change

                  mov al,gs:[di].config_sys_edit
                  ; do not use invalid data (older os2csm.bin)
                  cmp al,1
                  if_be <mov [cfg_record.cfg_edit_config_sys],al>

                  mov al,gs:[di].rename_fileset_a
                  call rename_fileset
                  mov al,gs:[di].rename_fileset_b
                  call rename_fileset
                  mov al,gs:[di].rename_fileset_c
                  call rename_fileset
                  mov al,gs:[di].rename_fileset_d
                  call rename_fileset

                  mov al,gs:[di].delete_os2logo_s3
                  push di
                    mov di,Offset file_OS2LOGO
                    test al,1 ; accept 1=true and '1'
                    if_nz <call delete_if_file_exist_CS_DI>
                  pop di

                  mov ax,gs:[di].put_key
                  mov putkey_after_configsys_edit,ax


                  ; release memory

                  mov si,Offset OS2CSM_BIN_memory
                  call freemem

  @@exit_os2csm_not_found:
                  call free_crc32

                  lfs si,[disk_m]
                  call flush_fat_cache
                  call flush_dir_cache

                  mov si,Offset disk_m
                  call freemem

                  STEP 'CSM9'

                popad
                pop es
                pop fs
                pop gs
                ret
a_endp          call_os2csm

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; cs:ax=file83 file to load
                ; gs:bx=buffer pointer and size
                ; fs:si=@disk_m
a_proc          search_getmem_open_load_close_file
                push es
                pushad

                  mov di,ax

                  ; nothing loaded
                  null eax
                  mov DWord Ptr gs:[bx+0],eax
                  mov  Word Ptr gs:[bx+4], ax

                  ; file exist ?
                  push cs
                  pop es
                  call search_file ; es:di
                  cmp bp,-1
                  je @@exit

                  mov eax,fs:[bp].filesize
                  cmp eax,0f000h
                  if_a <trap msg_file_is_to_big_to_load>
                  mov Word Ptr gs:[bx+4],ax

                  ; allocate memory
                  pushad
                    mov ecx,eax
                    call round_up_to_sectorsize
                    mov eax,ecx
                    mov si,Offset temp_memptr
                    call getmem
                    mov eax,DWord Ptr cs:[si]
                    mov DWord Ptr gs:[bx+0],eax
                  popad

                  ; open file (fs:bp/fs:si)
                  call open_file

                  ; read file
                  les bx,gs:[bx]
                  mov ecx,eax
                  call read_file

                  ; close file (fs:si)
                  call close_file

  @@exit:

                popad
                pop es
                ret
a_endp          search_getmem_open_load_close_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; gs:bx
a_proc          done_file_freemem
                pushad

                  cmp dword ptr gs:[bx+0],0 ; nil ?
                  je @@exit

                  mov eax,gs:[bx+0]
                  mov cs:[temp_memptr],eax
                  mov si,Offset temp_memptr
                  call freemem

                  null eax
                  mov dword ptr gs:[bx+0],eax
                  mov  word ptr gs:[bx+4],ax
  @@exit:
                popad
                ret
a_endp          done_file_freemem

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; cs:ax=file83 file to save
                ; gs:bx=buffer pointer and size
                ; fs:si=@disk_m
a_proc          save_file_freemem
                push es
                push gs
                pushad

                  cmp dword ptr gs:[bx+0],0 ; nil ?
                  je @@exit

                  ; es:di=filename
                  push cs
                  pop es
                  mov di,ax
                  call search_file
                  cmp bp,-1
                  if_ne <call delete_file>

                  call create_file
                  movzx ecx,Word Ptr gs:[bx+4]
                  push bx
                    les bx,gs:[bx+0]
                    call write_file
                  pop bx
                  call touch_filedatetime
                  call close_file

                  call done_file_freemem

  @@exit:

                popad
                pop gs
                pop es
                ret
a_endp          save_file_freemem

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; al=true/false
a_proc          move_os2ldr_deb
                pusha

                  cmp al,1
                  je @@deb

                  ; remove debug loader
                  mov di,Offset file_OS2LDR_DEB
                  call delete_if_file_exist_CS_DI
                  jmp @@exit

  @@deb:
                  ; remove retail loader
                  mov di,Offset file_OS2LDR
                  call delete_if_file_exist_CS_DI

                  ; and rename debug loader
                  mov di,Offset file_OS2LDR_DEB
                  mov bx,Offset file_OS2LDR
                  call rename_file

  @@exit:

                popa
                ret
a_endp          move_os2ldr_deb

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; al=true/false
a_proc          move_os2krnl_deb
                pusha

                  cmp al,1
                  je @@deb

                  ; remove debug kernel
                  mov di,Offset file_OS2KRNL_DEB
                  call delete_if_file_exist_CS_DI
                  jmp @@exit

  @@deb:
                  ; remove retail kernel
                  mov di,Offset file_OS2KRNL
                  call delete_if_file_exist_CS_DI

                  ; and rename debug kernel
                  mov di,Offset file_OS2KRNL_DEB
                  mov bx,Offset file_OS2KRNL
                  call rename_file

  @@exit:

                popa
                ret
a_endp          move_os2krnl_deb

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; es:di=file83
                ; fs:si=disk_m
a_proc          delete_if_file_exist
                pusha

                 ;mov di,di
                  call search_file

                  cmp bp,-1
                  if_ne <call delete_file>

                popa
                ret
a_endp          delete_if_file_exist

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; cs:di=file83
                ; fs:si=disk_m

a_proc          delete_if_file_exist_CS_DI
                push es
                  push cs
                  pop es
                  call delete_if_file_exist
                pop es
                ret
a_endp          delete_if_file_exist_CS_DI

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; cs:di->cs:bx=file83
                ; fs:si=disk_m
a_proc          rename_file
                push es
                pushad

                  push cs
                  pop es
                 ;mov di,di
                  call search_file
                  cmp bp,-1
                  if_e <trap msg_Can_not_rename_OS_debug_file_missing>

                  mov eax,DWord Ptr cs:[bx+0]
                  mov DWord Ptr fs:[bp+0].filenameext,eax
                  mov eax,DWord Ptr cs:[bx+4]
                  mov DWord Ptr fs:[bp+4].filenameext,eax
                  mov eax,DWord Ptr cs:[bx+7]
                  mov DWord Ptr fs:[bp+7].filenameext,eax

                popad
                pop es
                ret
a_endp          rename_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          apply_altf2on_change
                push es
                pusha

                  cmp al,1
                  jne @@not_erase_altf2on

                  mov di,Offset file_ALTF2ON____
                  call delete_if_file_exist_CS_DI
                  jmp @@exit

  @@not_erase_altf2on:
                  cmp al,2
                  jne @@not_create_altf2on

                  mov di,Offset file_ALTF2ON____
                  push cs
                  pop es
                  call delete_if_file_exist
                  call create_file
                  mov ecx,1 ; 1 byte file
                  mov bx,offset eof_char
                  call write_file
                  call touch_filedatetime
                  call close_file

  @@not_create_altf2on:

  @@exit:

                popa
                pop es
                ret
a_endp          apply_altf2on_change

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; extensions are in upper case because file names in FAT are upper case

known_file_extensions_for_rename        db 'SNP',0 ; snoopers/drivers
                                        db 'SYS',0
                                        db 'SYM',0
                                        db 'ADD',0
                                        db 'FLT',0
                                        db 'DMD',0
                                        db 'NIF',0
                                        db 'OS2',0
                                        db 'LST',0 ; snoop.lst
                                        db 'IFS',0
                                        db 'EXE',0
                                        db 'DLL',0
                                        db '   ',0 ; <'OS2KRNL ','   '>
                                        dd 0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; al='0' (no change) or '1'..'9' (rename *.(al)?? to *.(?)??
; fs:si=@disk_m

p_proc          rename_fileset
                Local @@SearchDigit:Byte
                Local @@ReplaceChar:Byte
                Local @@SourceFileName:file83
                Local @@TargetFileName:file83

                pushad

                or  al,'0'
                cmp al,'0'
                jbe @@exit
                cmp al,'9'
                ja  @@exit

                mov @@SearchDigit,al

                ; for all files...
  @@look_at_all_files:
                call FirstFile
  @@fileloop:
                ; check if it is a file
                test fs:fat_direntry[bx].attr, (faVolumeID or faDirectory)
                jnz @@NextDirectoryEntry

                ; check if file is in copy file set..

                mov di,Offset known_file_extensions_for_rename
  @@checknameloop:
                mov edx,cs:[di]
                add di,4
                test edx,edx
                je @@NextDirectoryEntry         ; all extensions tested

                mov @@ReplaceChar,dl
                mov dl,@@SearchDigit
                mov eax,DWord Ptr fs:[bx].ext
                call upcase                     ; 'X'
                ror eax,8
                call upcase                     ; 'XX'
                ror eax,8
                call upcase                     ; 'XXX'
                ror eax,8
                mov al,0                        ; 'XXX',0
                ror eax,8

                cmp eax,edx
                jne @@checknameloop             ; extension not as searched

                ; extension match
                ; create target filename

                mov eax,DWord Ptr fs:[bx.fname+0]
                mov DWord Ptr [@@SourceFileName.fname+0],eax
                mov DWord Ptr [@@TargetFileName.fname+0],eax
                mov eax,DWord Ptr fs:[bx.fname+4]
                mov DWord Ptr [@@SourceFileName.fname+4],eax
                mov DWord Ptr [@@TargetFileName.fname+4],eax
                mov al,Byte Ptr fs:[bx.ext+0]
                mov dl,@@ReplaceChar
                mov Byte  Ptr [@@SourceFileName.ext  +0],al
                mov Byte  Ptr [@@TargetFileName.ext  +0],dl
                mov ax,Word Ptr fs:[bx.ext+1]
                mov Word  Ptr [@@SourceFileName.ext  +1],ax
                mov Word  Ptr [@@TargetFileName.ext  +1],ax

                push es

                  push ss
                  pop es

                  ; deletete file with original name - only if it exist

                  lea di,@@TargetFileName
                  call delete_if_file_exist

                  ; rename file to original name

                  lea di,@@SourceFileName
                  push bp
                    call search_file
                    mov bx,bp
                  pop bp

                  cmp bx,-1
                  mov al,@@ReplaceChar
                  if_ne <mov Byte Ptr fs:[bx.ext+0],al>

                pop es

                ; directory now likely changed, restart search
                jmp @@look_at_all_files


  @@NextDirectoryEntry:

                call NextFile
                jnc @@fileloop


  @@exit:

                popad
                ret
p_endp          rename_fileset

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; file in this context means any direcory entry (file, directory, label...)

;               fs:si=@disk_m
;               -> fs:bx=directory entry
;               -> cf=error

a_proc          FirstFile
                push bp
                  call first_directory_entry
                  mov bx,bp
                pop bp
                ret
a_endp          FirstFile

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

;               fs:si=@disk_m
;               fs:bx=directory entry
;               -> fs:bx=directory entry
;               -> cf=error

a_proc          NextFile
                push bp
                  mov bp,bx
                  call next_directory_entry
                  mov bx,bp
                pop bp
                ret
a_endp          NextFile

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
