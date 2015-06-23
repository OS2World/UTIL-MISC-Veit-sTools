Title   reload updated memboot.bin from floppy

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
IFDEF dos
memboot_bin_filename    file83 <'MEMDISK ','COM'>
ELSE
memboot_bin_filename    file83 <'MEMBOOT ','BIN'>
ENDIF

ptr_memdisk_bin         ptr1616 <>
size_memdisk_bin        dw ?

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; dl=0/1 (A:/B:)
a_proc          try_floppy_update

               ; previously excluded, now possible and will cause media change prompt
               ;cmp dl,boot_drive
               ;je exit_try_floppy_update

                mov al,'A'
                add al,dl
                call notify_drive_access

               ;mov dl,dl                       ; floppy source
                mov dh,sourcetype_update
                sub eax,eax                     ; floppy boot sector
                lfs si,disk_a
                call load_disk_info
                jc exit_try_floppy_update

                ; search file

                push cs
                pop es
                mov di,Offset memboot_bin_filename
                call search_file
                cmp bp,-1
                je exit_try_floppy_update

                ; check for reasonable size

                mov ecx,fs:[bp].fat_direntry.filesize
                cmp ecx,50*1024
                ja exit_try_floppy_update
                cmp  cx, 4*1024
                jb exit_try_floppy_update

                mov [size_memdisk_bin],cx

                ; allocate some memory for it

                push si
                push ecx
                  call round_up_to_sectorsize
                  mov si,Offset ptr_memdisk_bin
                  mov eax,ecx
                  call getmem
                pop ecx
                pop si

                ; fs:bp
                call open_file

                les bx,ptr_memdisk_bin
               ;mov ecx,ecx
                call read_file

                call close_file


                ; all ok, self uninstall
                call uninstall_irq_filters

                call remove_exception_handler

IFNDEF language_en
                call tastatur_umbelegung_entfernen
ENDIF ; -language_en

                STEP 'RPAL'
                call restore_palette

                mov ax,0003h
                call int_10h

                ; copy copy procedure

                mov cx,((Offset copy_procedure_end)-(Offset copy_procedure)+1) and (not 1)
                sub sp,cx
                push ss                         ; destination
                pop es
                mov di,sp

                push es                         ; push continue address
                push di

                push ds                         ; remember ds

                push cs                         ; source address
                pop ds
                mov si,Offset copy_procedure
                cld                             ; move copy procedure
                rep movsb

                pop ds                          ; restore ds

                mov dl,[boot_drive]             ; pass boot drive
                mov eax,[boot_sector_rel]       ; and parttition information

                mov cx,[size_memdisk_bin]       ; size   of new memboot.bin
                add cx,3                        ; byte->dword
                shr cx,2
                lds si,[ptr_memdisk_bin]        ; source of new memboot.bin
                push cs                         ; target of new memboot.bin
                pop es
                mov di,Offset anfang_org
                cld
                retf                            ; jmp to copy_procedure on stack

  copy_procedure:
                push di                         ; entrypoint
                rep movsd                       ; copy
                pop di                          ; entrypoint

                ; build fake bootsector and point to it (see memalloc.inc)

                sub sp,512
                mov si,sp
                mov byte ptr ds:[si].signature_byte,029h ; fat
                mov byte ptr ds:[si].physical_drive_number,dl
                mov dword ptr ds:[si].hidden_sectors,eax

                add si,Offset bytes_per_sector  ; @BPB

                push es
                push di
                retf                            ; use new memdisk
  copy_procedure_end:


  exit_try_floppy_update:
                ret
a_endp          try_floppy_update

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          update_memdisk
                push es
                push fs
                pushad

                  mov eax,Size disk_info
                  mov si,Offset disk_a
                  call getmem

                  call init_crc32

                  mov dl,0
                  call try_floppy_update
                  mov dl,1
                  call try_floppy_update

                  ; failed, free memory

                  call free_crc32

                  mov si,Offset disk_a
                  call freemem

                popad
                pop fs
                pop es
                ret
a_endp          update_memdisk

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

