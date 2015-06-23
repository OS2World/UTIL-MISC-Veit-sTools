Title   CD ROM read function, shared by cdloader and memdisk

; also used to read hard disk sectors for cylinder >1024

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF os2boot_ac_code

cd_boot_directory_max_len       equ 32

l_string p_cd_boot_directory   cd_boot_directory
         db (Offset p_cd_boot_directory)+(1+cd_boot_directory_max_len)-$ dup (0)
l_string p_cd_boot_memboot_bin cd_boot_memboot_bin

ENDIF ; -os2boot_ac_code


IFNDEF cdloader
hd_sector_read_error0   db msg_hd_sector_read_error0,0
ENDIF
cd_sector_read_error0   db msg_cd_sector_read_error0,0
cd_sector_read_error1   db msg_cd_sector_read_error1,0
cd_sector_read_error3   db msg_cd_sector_read_error3,13,10,0

IFDEF ScrewDrv

note_sector_area_was_changed db 'Note: the read buffer was altered.',13,10,0

ENDIF ; ScrewDrv

                ; eax=first cd sector number
                ; es:bx=target buffer
                ; cx=count
                ; fs:si=source (memboot.bin, not cdloader.bin)

                ; -> CF=1:read error (when allowed to return -- read_may_fail=true)
                ; -> CF=0:success

a_proc          read_cd_sector
                push ds
                pushad

                push cs
                pop ds

  loop_read_cd_sector:
                ; retry count for this sector(s)
                mov di,10
  loop_read_cd_sector_retry:

                test cx,cx
                clc
                jz read_cd_sector_exit

                pushad

IFDEF ScrewDrv
                  mov DWord Ptr es:[bx+0],'%%%%'
                  mov DWord Ptr es:[bx+4],eax
ENDIF ; ScrewDrv

IFDEF cdloader
                  mov dl,cs:[boot_drive]
ELSE
                  mov dl,fs:[si].disknum
ENDIF

                  mov si,Offset read_sector_packet
                  mov ds:[si].disk_address_packet_size,Size disk_address_packet
                  mov ds:[si].reserved_0,0
                  mov ds:[si].number_of_blocks_to_transfer,cx
                  ; from second try on, read single sector
                  cmp di,10
                  if_ne <mov ds:[si].number_of_blocks_to_transfer,1>
                  mov ds:[si].transfer_buffer._OFF,bx
                  mov ds:[si].transfer_buffer._SEG,es
                  mov DWord Ptr ds:[si].starting_block_number+0,eax
                  sub eax,eax
                  mov DWord Ptr ds:[si].starting_block_number+4,eax
                  mov ah,042h
                  call int_13                   ; protect fs register

                  ; remember error code for trap message
                  mov ds:i13_errorcode,ah

                popad
                mov dh,ds:i13_errorcode         ; ignore carry and check for
                test dh,dh                      ; and AH=0 - success
                jz read_cd_sector_success

                cmp dh,1                        ; invalid function -> imediate stop
                je read_cd_sector_error_stop

                ; assume no sector is read, since it seem to be unreliable
                ; to believe the specification (VPC: error 80 returned, but
                ; transfer packet says 9 sectors transferred...

                ; reset disk
                pushad
                  mov ah,0
IFDEF cdloader
                  mov dl,cs:[boot_drive]
ELSE
                  mov dl,fs:[si].disknum
ENDIF
                  call int_13
                popad

                ; try again, with limit
                dec di
                jnz loop_read_cd_sector_retry

  read_cd_sector_error_stop:

IFNDEF cdloader
                ; reading from harddisk 'should' not fail, but
                ; aparently it does, for example when the BIOS does not support
                ; disk geometries above 32 GiB. We want silently ignore
                ; read errors for 'LVML' scans
                cmp fs:[si].read_may_fail,true
                stc
                je read_cd_sector_exit          ; exit with CF=1
ENDIF

                ; error message
                mov cl,error_TextAttr
                xchg cs:[TextAttr],cl

IFDEF ScrewDrv
                ; did the BIOS alter the target buffer?
                push si
                  mov si,Offset note_sector_area_was_changed
                  cmp DWord Ptr es:[bx+0],'%%%%'
                  if_e <cmp DWord Ptr es:[bx+4],eax>
                  if_ne <call ausschrift>
                pop si
ENDIF ; ScrewDrv

IFNDEF cdloader
                cmp fs:[si].fsmode,fsmode_no_emulation_cd
ENDIF
                mov si,Offset cd_sector_read_error0     ; Read Error
IFNDEF cdloader
                if_ne <mov si,Offset hd_sector_read_error0>
ENDIF
                call ausschrift
                xchg dx,ax                              ; drive number(dl)
                call ausschrift_al_hex
                xchg dx,ax
                mov si,Offset cd_sector_read_error1     ; sector=
                call ausschrift
               ;mov eax,eax                             ; sector
                call ausschrift_eax
                call ausschrift_errorcode
                mov cs:[TextAttr],cl
                push   Offset cd_sector_read_error3     ; end of sentence
                jmp trap_proc

  read_cd_sector_success:

                ; successful read. update sector numbers and buffer pointer

                ; update transfer position for successfully read sectors
                movzx ebp,read_sector_packet.number_of_blocks_to_transfer
                ; +staring sector number
                add eax,ebp
                ; -number left
                sub cx,bp
                ; +buffer pointer
                push cx
IFDEF cdloader
                  mov cl,cs:cd_sector_size_s
ELSE
                  mov cl,fs:[si].sector_size_s    ; *2048
ENDIF
                  shl bp,cl
                pop cx
                add bx,bp

                jmp loop_read_cd_sector

  read_cd_sector_exit:

                popad
                pop ds
                ret
a_endp          read_cd_sector

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF os2boot_ac_code

                ; ds:si,es:di
                ; -> ZF
                ; special handling for ";1" in CD file names
a_proc          pstring_compare_i
                pusha
                  mov bx,di
                  movzx cx,byte ptr ds:[si]
                  cld
                  cmpsb                         ; length equal ?
                  je compare_string             ; yes
                                                ; no.
                  add di,cx
                  mov al,'-'
                  cmp cl,es:[bx]                ; could be substring ?
                  if_b <mov al,es:[di]>         ; yes,look at start of trailer
                  sub di,cx

                  cmp al,';'
                  jne compare_exit

    compare_string:
                  lodsb
                  mov ah,al
                  mov al,es:[di]
                  inc di
                  call upcase
                  cmp al,ah
                  loope compare_string

    compare_exit:
                popa
                ret
a_endp          pstring_compare_i

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; es:bx=directory
                ; cx=directory size
                ; ds:si=directory/filename
                ; -> es:bx / CF
a_proc          search_in_iso9660_directory
                push ax
                push di
                push cx
                push dx

                  mov dx,bx ; Verzeichnisanfang

  again_search_in_iso9660_directory:

                  cmp es:[bx].isoDirRec.RecLen,0
                  jne nicht_sektor_ende__search_in_iso9660_directory

                  ; zum Anfang des n꼊hsten Sektors springen
                  mov ax,bx
                  sub ax,dx
                  add ax,2048-1
                  and ax,not (2048-1)
                  add ax,dx
                  sub ax,bx
                  jmp verreche_cdrom_verzeichnisblocklaenge

  nicht_sektor_ende__search_in_iso9660_directory:
                  lea di,[bx].FileID
                  call pstring_compare_i
                  clc
                  je exit_search_in_iso9660_directory   ; found !

                  ; go to next entry
                  movzx ax,es:[bx].isoDirRec.RecLen
  verreche_cdrom_verzeichnisblocklaenge:
                  add bx,ax
                  sub cx,ax
                  jnbe again_search_in_iso9660_directory

  error_exit_search_in_iso9660_directory:
                  stc
  exit_search_in_iso9660_directory:

                pop dx
                pop cx
                pop di
                pop ax
                ret
a_endp          search_in_iso9660_directory

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; es:bx=buffer>=2048 byte
                ; fs:si=diskinfo (memdisk.tas)
a_proc          determine_cd_sector_size
                pushad
                  mov edi,123456789
                  mov es:[bx+512],edi

                  mov cl,11                     ; 2048
                  call set_sectorsize

                  ; read first valid sector
                  mov eax,010h                  ; VTOC
                  mov cx,1
                  call read_cd_sector
                  ; ignore CF value, must be CF=0

                  cmp es:[bx+512],edi
                  jne cd_sectorsize_is_2048

                  mov cl,9                      ; 512
                  call set_sectorsize

cd_sectorsize_is_2048:

                popad
                ret
a_endp          determine_cd_sector_size

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          set_sectorsize
                mov ax,1
                shl ax,cl
IFDEF cdloader
                mov cd_sector_size_s,cl
                mov cd_sector_size_b,ax
ELSE
                mov fs:[si].sector_size_s,cl
                mov fs:[si].sector_size_b,ax
ENDIF
                ret
a_endp          set_sectorsize

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

ENDIF ; -os2boot_ac_code

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴


