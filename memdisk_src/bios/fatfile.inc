Title           FAT filesystem functions

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; PLAN:
; findfirst (dateiname,attr0/1
; findnext
; -> kopiert von dateisystemabh꼗gigem Tabellen
;   -name
;   -datum+zeit
;   -gr붳e
;   -attribut
;   -Zeiger/verwaltungsnummer auf dateisystemspezifische informationen (serster cluster/btree/..)
;     im verzeichnis-puffer
; ge봣fnete dateien vermerken (Verzeichnisindex)
; getsize directory
; getmem
; read..
;
; sonderbehandlung FAT: memdisk als FAT beschreibbar, beschleunigt
;
; allgemein verwendbarer cache (16 sektoren statt FAT-tabellen? f걊 HPFS,FAT32,..)
; prozedurzeiger in load_diskinfo
; loaddiskinfo=
;   Dateisystembestimmung
;   call verzeichnis \ lesen
; findfirst
; findnext
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF os2boot_ac_code
  fatfile_readonly      equ 1
ENDIF ; os2boot_ac_code

disk_info       Struc
  disknum       db ?    ; 00/80/81
  heads         dw ?
  sector_size_s db ?    ; 9:512..12:4096
  sector_size_b dw ?    ; 512..4096
  sectors_track dw ?
  sector0       dd ?    ; absolute sector
  cluster_size  dw ?    ; in sectors
  cluster_high  dw ?    ; highest valid cluster number
  cluster_next  dw ?    ; hint for next free cluster
  fat_bit       db ?    ; 12/16
  fat_start     dd ?    ; absolute sector
  fat_size      dw ?    ; in sectors
  fat_count     db ?    ; usually 2
  rootdir_start dd ?    ; absolute sector
  curr_dir_size dw ?    ; in bytes
  data_start    dd ?    ; absolute sector
  label_volume  file83 <>
  curr_dir      db max_rootdir_entries*(Size fat_direntry) dup (?)
  fat_buffer    dw 1000h dup (?) ; more than enough space for 2^12*12 bit, page for FAT16
  fat_sector    dw 0    ; 0,8,16,.. (n*1000h/512,)
  fat_change    db 0    ; false/true

  current_file  dw ?    ; pointer(ofs) to root directory entry
  lastcluster   dw ?    ; to speed up chain update

  file_position dd ?    ; multiple of sector size
  file_size     dd ?    ; for eof function

  sourcetype    db ?    ; 0=primary 1=update 2=harddisk MBR
  read_may_fail db ?    ; boolean
  bios_i13x_sup db ?    ; 0=int 13/ah=02  1=int 13/ah=42
  directory_crc dd ?    ; to find equal sources

  fsmode        db ?    ;

  firstfilesector dd ?  ; first file sector for cdrom file

disk_info       EndS

sourcetype_primary      equ 0   ; not allowed to fail
sourcetype_update       equ 1   ; may fail
sourcetype_harddisk_MBR equ 2   ; may fail

fsmode_fat              equ 0
fsmode_no_emulation_cd  equ 1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

stack_continue_from_int13_div0  ptr1616 <?,?>

IFNDEF os2boot_ac_code
cdrom_puffer_ptr        ptr1616 <?,?>
cdrom_puffer_size       equ 8*2048
subdir_tmp_ptr          ptr1616 <?,?>
ENDIF

query_geom_1            db msg_query_geom_1,0
query_geom_3            db msg_query_geom_3,13,10,0

Asking_for_drive_parameters_failed1 db msg_Asking_for_drive_parameters_failed1,0
Asking_for_drive_parameters_failed2 db msg_Asking_for_drive_parameters_failed2,13,10,0

Disk_has_invalid_format db msg_Disk_has_invalid_format,0

                ; fs:si=disk_info
                ; dl=physical drive number
                ; dh=source type
                ; cs=ds=es
                ; eax=first sector number
                ; -> carry=1 -> not present
a_proc          load_disk_info
                pushad
                push es

                  mov fs:[si].disknum,dl
                  mov fs:[si].sourcetype,dh
                  cmp dh,sourcetype_primary
                  setne fs:[si].read_may_fail
                  mov fs:[si].sector0,eax
                  mov fs:[si].fsmode,fsmode_fat

IFNDEF os2boot_ac_code

                  cmp dl,boot_drive
                  jne @@not_noemulation_source

                  cmp source_is_noemulation_mode_cd,true
                  jne @@not_noemulation_source


                  ;*** no emulation CD mode = ISO 9660 filesystem ****

                  ; clear "FAT" directory

                  pusha
                  push es
                    sub eax,eax
                    mov cx,(Size curr_dir)/4
                    push fs
                    pop es
                    lea di,[si].curr_dir
                    cld
                    rep stosd
                  pop di
                  popa

                  mov fs:[si].curr_dir_size,0

                  mov fs:[si].fsmode,fsmode_no_emulation_cd
                  push si
                    mov eax,cdrom_puffer_size
                    mov si,Offset cdrom_puffer_ptr
                    call getmem
                  pop si
                  les bx,[cdrom_puffer_ptr]
                  call determine_cd_sector_size

                  ; load VTOC
                  mov eax,010h                  ; VTOC
                  les bx,[cdrom_puffer_ptr]
                  mov cx,1
                  mov es:[bx].VTOC.cdType,-1    ; clear signature area
                  call read_cd_sector
                  ; ignore CF value, must be CF=0
;                 cmp es:[bx].VTOC.cdType,0
;                 je  @@invalid_VTOC
                  cmp DWord Ptr es:[bx].VTOC.ID+0,'00DC' ; CD001
                  jne @@invalid_VTOC
                  cmp Byte Ptr es:[bx].VTOC.ID+4,'1' ; CD001
                  jne @@invalid_VTOC
                  cmp es:[bx].VTOC.Version,1
                  je  @@valid_VTOC

  @@invalid_VTOC:
                  trap <msg_invalid_VTOC>

  @@valid_VTOC:

                  ; copy volume label now
                  mov eax,DWord Ptr es:[bx].VTOC.VolID+0
                  mov DWord Ptr fs:[si].label_volume+0,eax
                  mov eax,DWord Ptr es:[bx].VTOC.VolID+4
                  mov DWord Ptr fs:[si].label_volume+4,eax
                  mov eax,DWord Ptr es:[bx].VTOC.VolID+7
                  mov DWord Ptr fs:[si].label_volume+7,eax

                  ; get boot directory and read it, one directory level each loop
                  mov bp,Offset p_cd_boot_directory
                  mov eax,es:[bx].VTOC.DirRec.DataLenLSB        ; size req directory
                  mov edi,es:[bx].VTOC.DirRec.ExtLocLSB         ; position

  @@go_to_bootimgs_directory_loop:
                  ; ds:bp=@directory in form of l_string lstring .. #0
                  ; eax=size of current directory (bytes)
                  ; edi=postition of current directory (first sector)

                  ; set minimum size of director/file size and our buffer space
                  mov ecx,0ffffh                                ; size avail buffer max
                  call round_down_to_sectorsize                 ; next lower sector size for buffer
                  cmp ecx,eax                                   ; size dir/file
                  if_a <mov ecx,eax>                            ; select min

                  mov eax,edi                                   ; eax=position
                                                                ; ecx=size bytes

                 ;es:bx..
                  les bx,[cdrom_puffer_ptr]
                  push cx
                    call byte_to_sectornum                      ; round up,divide
                    call read_cd_sector                         ; load them
                    ; ignore CF value, must be CF=0
                  pop cx

                  ; do not look past directory name string buffer
                  cmp bp,(Offset p_cd_boot_directory)+cd_boot_directory_max_len
                  jae @@have_bootimgs_directory
                  ; no more directory names?
                  cmp Byte Ptr ds:[bp],0
                  je @@have_bootimgs_directory

                  ; search subdirectory for boot file(s) or fill
                  xchg si,bp
                 ;mov si,si                                       ; ds:si=directory item to search
                  call search_in_iso9660_directory
                  xchg si,bp

                  ; carry means usually not found
                  if_c <trap msg_can_not_find_boot_directory>
                  ; we can only 'cd directory' to directories, not files
                  test es:[bx].isoDirRec.dirFlags,cdrom_DIR
                  if_z <trap msg_boot_directory_is_not_a_directory>

                  ; update string pointer: add directory just searched
                  movzx ax,Byte Ptr ds:[bp]
                  inc ax
                  add bp,ax

                  ; get first sector number and size of file or next directory level
                  mov edi,es:[bx].isoDirRec.ExtLocLSB
                  mov eax,es:[bx].isoDirRec.DataLenLSB
                  ; have dir, read next level
                  jmp @@go_to_bootimgs_directory_loop

    @@have_bootimgs_directory:

                  ; ecx=directory size (bytes)
                  ; es:bx=ISO-9660 directory


                  ; convert all files (not directories) to fat format.
                  mov dx,cx                     ; dx=length of directory
                  call search_free_direntry     ; bp=fat directory table

  @@loop_convert_to_fatformat:
                  cmp es:[bx].RecLen,0          ; end of dir ?
                  jne @@nicht_cdrom_verzeichnisende_kennung

                  mov ax,bx
                  sub ax,[cdrom_puffer_ptr]._OFF
                  add ax,2048-1
                  and ax,not (2048-1)
                  add ax,[cdrom_puffer_ptr]._OFF
                  sub ax,bx
                  jmp @@verrechne_cdrom_verzeichnisende_kennung

  @@nicht_cdrom_verzeichnisende_kennung:
                  ; file ?
                  test es:[bx].dirFlags,cdrom_DIR
                  jnz @@next_convert_to_fatformat

                  ; try to copy name
                  lea di,[bx].FileID
                  movzx cx,es:[di]
                  inc di
                 ;mov fs,fs
                 ;mov bp,bp
                  call normalize_filename83
                  jc @@convert_failed

                  ; fill in attr, length and starting sector
                  sub eax,eax
                  mov fs:[bp].fat_direntry.attr,al
                  mov fs:[bp].fat_direntry.file_used,al
                  ; convert date (6 byte to 4 byte bit-packed)
                  movzx ax,es:[bx].Date_Time.Yr ; 00000000 00000000 00000000 YYYYYYYY
                  sub al,1980-1900              ; 00000000 00000000 00000000 0YYYYYYY
                  shl ax,4                      ; 00000000 00000000 00000YYY YYYY0000
                  or al,es:[bx].Date_Time.Mth   ; 00000000 00000000 00000YYY YYYYMMMM
                  shl ax,5                      ; 00000000 00000000 YYYYYYYM MMM00000
                  or al,es:[bx].Date_Time.Day   ; 00000000 00000000 YYYYYYYM MMMDDDDD
                  shl eax,16                    ; YYYYYYYM MMMDDDDD 00000000 00000000
                  mov al,es:[bx].Date_Time.Sec  ; YYYYYYYM MMMDDDDD 00000000 00ssssss
                  shr al,1                      ; YYYYYYYM MMMDDDDD 00000000 000sssss
                  ror ax,5                      ; YYYYYYYM MMMDDDDD sssss000 00000000
                  or al,es:[bx].Date_Time.Min   ; YYYYYYYM MMMDDDDD sssss000 00mmmmmm
                  ror ax,6                      ; YYYYYYYM MMMDDDDD mmmmmmss sss00000
                  or al,es:[bx].Date_Time.Hr    ; YYYYYYYM MMMDDDDD mmmmmmss ssshhhhh
                  ror ax,5                      ; YYYYYYYM MMMDDDDD hhhhhmmm mmmsssss
                  mov fs:[bp].fat_direntry.datetime,eax
                  mov eax,es:[bx].isoDirRec.DataLenLSB
                  mov fs:[bp].fat_direntry.filesize,eax
                  mov eax,es:[bx].isoDirRec.ExtLocLSB
                  mov fs:[bp].fat_direntry.cdromsector,eax

                  ; next entry to fill
                  add bp,Size fat_direntry

                  mov ax,bp
                  sub ax,si
                  sub ax,Offset curr_dir
                  cmp fs:[si].curr_dir_size,ax
                  if_b <mov fs:[si].curr_dir_size,ax>

                  cmp fs:[si].curr_dir_size,Size curr_dir
                  if_ae <trap msg_to_many_files_in_cdrom_directory>

                  jmp @@next_convert_to_fatformat

  @@convert_failed:
                  ; mark as deleted
                  mov byte ptr fs:[bp].fat_direntry.filenameext,erased_file

  @@next_convert_to_fatformat:

                  ; go to next entry
                  movzx ax,es:[bx].RecLen
  @@verrechne_cdrom_verzeichnisende_kennung:
                  add bx,ax
                  sub dx,ax
                  jnbe @@loop_convert_to_fatformat

  @@exit_convert_to_fatformat:

                  push si
                    mov si,Offset cdrom_puffer_ptr
                    call freemem
                  pop si

                  clc                           ; no error
                  jmp @@exit_load_disk_info

                  ;*****************************

ENDIF ; -os2boot_ac_code

  @@not_noemulation_source:

                  ; *** FAT(12/16) filesystem ***
                  ; *** Partition table *********

                  ; default values for read_sector
                  mov fs:[si].sector_size_s,9
                  mov fs:[si].sector_size_b,512

  @@loop_load_disk_info:
                  ; drive hardware characteristics
                  push es
                  pusha

                    ; protection against room 310 award BIOS, takes minutes
                    ; on ah=00(Reset) or ah=02(Read)


                    sub bp,bp                   ; error_counter:=0
  @@loop_query_geometry:
                    test bp,bp                  ; do only reset second+ time
                    jz @@no_reset_before_error

                    mov ah,0                    ; reset if floppy
                    mov dl,fs:[si].disknum
                    push si
                      test dl,dl
                      if_ns <call int_13>
                    pop si
  @@no_reset_before_error:

                    sub di,di                   ; query geometry
                    mov es,di
                    sub cx,cx

                    mov ah,8
                    mov dl,fs:[si].disknum
                    mov dh,0
                    push si
                    call int_13
                    pop si
                    mov [i13_errorcode],ah
                    test ah,ah
                    jnz @@drive_not_present

                    or cx,cx
                    jnz @@drive_present

  @@drive_not_present:
                    inc bp                              ; Inc(error_counter)
                    cmp bp,3                            ; up to 3 tries
                    jb @@loop_query_geometry            ; reset & again

                    ; may fail for update or partition table,
                    ; but not for primary source
                    cmp fs:[si].read_may_fail,true
                    je @@query_gemetry_failed_for_update_or_partitiontable

                    mov bl,error_TextAttr
                    xchg [TextAttr],bl
                    mov al,fs:[si].disknum              ; drive letter
                    mov si,Offset Asking_for_drive_parameters_failed1
                    call ausschrift
                   ;mov al,al
                    call ausschrift_al_hex
                    call ausschrift_errorcode
                    mov [TextAttr],bl
                    push Offset Asking_for_drive_parameters_failed2
                    jmp trap_proc

  @@query_gemetry_failed_for_update_or_partitiontable:
                    ; non-existing harddisk error is most times 7..
                    cmp fs:[si].sourcetype,sourcetype_harddisk_MBR
                    je @@drive_not_present_continue

                    ; invalid=no drive (B:...)
                    test ah,ah                          ; 00 success - but invalid values (Award BIOS)
                    jz @@drive_not_present_continue
                    cmp ah,1                            ; 01 bad command
                    je @@drive_not_present_continue
                    cmp ah,7                            ; 07 drive parameter activity failed (hard disk)
                    je @@drive_not_present_continue     ; seen for ThinkPad T42(no internal floppy+1 USB A: floppy when querying B:)
                    cmp ah,080h                         ; 80 timeout/not ready
                    je @@drive_not_present_continue


                    mov al,fs:[si].disknum
                    mov si,Offset query_geom_1
                    call ausschrift
                   ;mov al,al                           ; drive(fs:[si].disknum)
                    call ausschrift_al_hex
                    call ausschrift_errorcode
                    mov si,Offset query_geom_3
                    call ausschrift

  @@drive_not_present_continue:

                  popa
                  pop es
                  stc
                  jmp @@exit_load_disk_info

  @@drive_present:

COMMENT $ -- debug code for divide by zero for B: read access..
cmp fs:[si].disknum,001h
jne @@drive_present_notB
                    mov al,'B'
                    call ausschrift_zeichen
                    mov al,'X'
                    call ausschrift_zeichen
                    mov al,'='
                    call ausschrift_zeichen
                    mov ax,bx
                    call ausschrift_ax_hex
                    mov al,' '
                    call ausschrift_zeichen

                    mov al,'C'
                    call ausschrift_zeichen
                    mov al,'X'
                    call ausschrift_zeichen
                    mov al,'='
                    call ausschrift_zeichen
                    mov ax,cx
                    call ausschrift_ax_hex
                    mov al,' '
                    call ausschrift_zeichen

                    mov al,'D'
                    call ausschrift_zeichen
                    mov al,'X'
                    call ausschrift_zeichen
                    mov al,'='
                    call ausschrift_zeichen
                    mov ax,dx
                    call ausschrift_ax_hex
                    call ausschrift_zeichen_CRLF

  @@drive_present_notB:
END COMMENT $


                    movzx ax,dh
                    inc ax
                    mov fs:[si].heads,ax
                    and cl,03fh
                    movzx ax,cl
                    mov fs:[si].sectors_track,ax
                  popa
                  pop es

                  ; read boot sector with media characteristics

                  mov fs:[si].bios_i13x_sup,0

                  mov ah,041h
                  mov bx,055aah
                  mov dl,fs:[si].disknum
                  test dl,dl
                  jns @@no_i13x_support_present

                  push es
                    push 0f000h ; \ddk\DASD\IBM\IBM1S506\s506i13.c "phoenix bios bug"
                    pop es
                    call int_13
                  pop es
                  jc @@no_i13x_support_present
                  cmp bx,0aa55h ; installed?
                  jne @@no_i13x_support_present
                  cmp ah,021h ; 2.1 / EDD-1.1
                  jb @@no_i13x_support_present
                  test cl,1 ;extended disk access functions (AH=42h-44h,47h,48h) supported
                  jz @@no_i13x_support_present

                  ; could store 2.1+(32 bit sector number)/3.0(64 bit sector number) here
                  mov fs:[si].bios_i13x_sup,1

  @@no_i13x_support_present:
                  mov bx,Offset temp_sector
                  mov es:[bx].ibm_sig,0ffffh    ; mark invalid
                  mov eax,fs:[si].sector0


                  ; AMI-BIOS (Jan Loef) divides by zero for floppy B:
                  ; reported geometry is (ATAPI) 63 sectors per track, 512 cylinders, 255 heads

                  pushfd
                  pushad
                  push ds
                  push es
                  push fs
                  push gs

                    push 0
                    pop gs

                    push DWord Ptr gs:[000h*4]
                    mov Word Ptr gs:[000h*4+0],Offset @@continue_from_int13_div0
                    mov Word Ptr gs:[000h*4+2],cs

                    mov stack_continue_from_int13_div0._OFF,sp
                    mov stack_continue_from_int13_div0._SEG,ss

                    call read_1_sector_eax

  @@continue_from_int13_div0:

                    lss sp,cs:stack_continue_from_int13_div0

                    push 0
                    pop ds
                    pop DWord Ptr gs:[000h*4]


                  pop gs
                  pop fs
                  pop es
                  pop ds
                  popad
                  popfd

                  cmp es:[bx].ibm_sig,0aa55h
                  jne @@bootsector_invalid

                  ; when having valid signature, work is done
                  ; if we are looking at an partition table
                  cmp fs:[si].sourcetype,sourcetype_harddisk_MBR
                  clc
                  je @@exit_load_disk_info


                  mov ax,es:[bx].bytes_per_sector
                  cmp ax, 512
                  je  @@bytes_per_sector_valid
                  cmp ax,1024
                  je  @@bytes_per_sector_valid
                  cmp ax,2048
                  je  @@bytes_per_sector_valid
                  cmp ax,4096
                  jne @@bootsector_invalid

  @@bytes_per_sector_valid:
                  bsf cx,ax
                  mov fs:[si].sector_size_s,cl
                  mov fs:[si].sector_size_b,ax


                  cmp es:[bx].signature_byte,029h
                  jne @@not_load_filesystem_FAT
                  cmp Word Ptr es:[bx].fsname,'AF'
                  jne @@not_load_filesystem_FAT
                  cmp byte ptr es:[bx].fsname+2,'T'
                  jne @@not_load_filesystem_FAT

                  ; FAT, check more
                  movzx eax,es:[bx].sectors_per_cluster
                  cmp al,1 ; 512
                  jb  @@bootsector_invalid
                  cmp al,64 ; 32K
                  ja  @@bootsector_invalid
                  ; sector size*sectors per cluster <= 32K ?
                  shl eax,cl
                  shr eax,16 ; lower 16 bit can only set!
                  jnz @@bootsector_invalid

                  ; 1 or 2 FAT copies ?
                  mov al,es:[bx].number_of_FATs
                  cmp al,1
                  jb  @@bootsector_invalid
                  cmp al,2
                  ja  @@bootsector_invalid

                  cmp es:[bx].root_directory_size,max_rootdir_entries
                  ja  @@bootsector_invalid

                  call load_disk_info_FAT
                  jmp @@continue_load_disk_info

  @@not_load_filesystem_FAT:

IFDEF SUPPORT_READ_HPFS
                  cmp es:[bx].signature_byte,028h
                  jne @@not_load_filesystem_HPFS
                  cmp DWord Ptr es:[bx].fsname,'SFPH'
                  jne @@not_load_filesystem_HPFS

                  call load_disk_info_HPFS
                  jmp @@continue_load_disk_info

  @@not_load_filesystem_HPFS:
ENDIF ; SUPPORT_READ_HPFS

IFDEF SUPPORT_READ_FAT32
                  cmp ...
                  Problem: andere Startsektordefinition
                  call load_disk_info_FAT32
                  jmp @@continue_load_disk_info

ENDIF ; SUPPORT_READ_FAT32

  @@bootsector_invalid:
                  ; update floppy or harddisk mbr?
                  cmp fs:[si].sourcetype,sourcetype_primary
                  stc                           ; return 'failed'
                  jne @@exit_load_disk_info

                  pusha
                    mov si,Offset Disk_has_invalid_format

IFDEF os2boot_ac_code
                    call fehler_ausschrift
                    call tastendruck
                    call ausschrift_zeichen_CRLF
ELSE ; -os2boot_ac_code
                    call key_box_simple_prompt
ENDIF ; -os2boot_ac_code

                  popa
                  jmp @@loop_load_disk_info


  @@continue_load_disk_info:
;<< anpassen f걊 FAT und HPFS<<
                  mov cx,fs:[si].curr_dir_size
                  push si
                    mov si,bx   ; root_dir
                    ; es:si->eax
                    call calculate_crc32
                  pop si

;<<< auch bei ISO9660?
                  mov DWord Ptr fs:[si].directory_crc,eax

IFNDEF os2boot_ac_code

                  cmp fs:[si].sourcetype,sourcetype_primary
                  je  @@can_not_be_double_source
                  cmp primary_source_crc,eax
                  jne @@can_not_be_double_source

                  stc
                  jmp @@exit_load_disk_info

  @@can_not_be_double_source:

ENDIF ; -os2boot_ac_code

                  mov cx,fs:[si].curr_dir_size
                  lea bp,[si].curr_dir
  @@load_root_mark_unused_loop:
                  mov fs:[bp].file_used,0
                  add bp,(1 shl shift_byte_per_direntry)
                  sub cx,(1 shl shift_byte_per_direntry)
                  jnz @@load_root_mark_unused_loop

                  clc

  @@exit_load_disk_info:

                  ; convert 0 to ' ' in volume label
                  pushf
                  pusha
                    add si,Offset label_volume
                    mov cx,8+3
                    mov al,' '
  @@convert_zeroes_in_label_volume_loop:
                    cmp fs:[si],al
                    if_b <mov fs:[si],al>
                    inc si
                    loop @@convert_zeroes_in_label_volume_loop
                  popa
                  popf

                  ; data sectors may not have read errors
                  ; once we have accepted the media/volume
                  mov fs:[si].read_may_fail,false
                  ; when walking harddisk partition tables,
                  ; the caller has to set this to true after calling
                  ; this procedure.

                pop es
                popad
                ret
a_endp          load_disk_info

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=@disk_info
                ; es:bx=@boosector (FAT/HPFS)
a_proc          copy_volumelabel_from_bootsector
                push eax

                  ; 0..3
                  mov eax,DWord Ptr es:[bx+0].volume_label
                  mov DWord Ptr fs:[si+0].label_volume,eax
                  ; 4..7
                  mov eax,DWord Ptr es:[bx+4].volume_label
                  mov DWord Ptr fs:[si+4].label_volume,eax
                  ; 7..10
                  mov eax,DWord Ptr es:[bx+7].volume_label
                  mov DWord Ptr fs:[si+7].label_volume,eax

                pop eax
                ret
a_endp          copy_volumelabel_from_bootsector

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          load_disk_info_FAT

                  call copy_volumelabel_from_bootsector

                  mov ax,es:[bx].number_of_heads
                  mov fs:[si].heads,ax
                  mov ax,es:[bx].sectors_per_track
                  mov fs:[si].sectors_track,ax
                  movzx ax,es:[bx].sectors_per_cluster
                  mov fs:[si].cluster_size,ax
                  movzx eax,es:[bx].reserved_sectors
                  add eax,fs:[si].sector0
                  mov fs:[si].fat_start,eax
                  movzx ax,es:[bx].number_of_FATs
                  mov fs:[si].fat_count,al
                  mov dx,es:[bx].sectors_per_FAT
                  mov fs:[si].fat_size,dx
                  mul dx
                  movzx eax,ax
                  add eax,fs:[si].fat_start
                  mov fs:[si].rootdir_start,eax
                  movzx eax,es:[bx].root_directory_size
                  shl eax,shift_byte_per_direntry
                  mov fs:[si].curr_dir_size,ax
                  mov cl,fs:[si].sector_size_s
                  shr eax,cl
                  add eax,fs:[si].rootdir_start
                  mov fs:[si].data_start,eax

                  movzx eax,es:[bx].total_sectors_16
                  or ax,ax
                  if_z <mov eax,es:[bx].number_of_sectors_32>
                  sub eax,fs:[si].data_start
                  add eax,fs:[si].sector0
                  ;?? +1 ?
                  push eax
                  pop ax
                  pop dx
                  mov cx,fs:[si].cluster_size
                  div cx
                  inc ax
                 ;inc ax
                 ;dec ax
                 ; 1 cluster -> first cluster=2, last cluster=2
                  mov fs:[si].cluster_high,ax
                  cmp ax,0ff1h
                  mov al,12
                  if_ae <mov al,16>
                  mov fs:[si].fat_bit,al

                  mov fs:[si].cluster_next,-1

                  sub di,di
                  call read_fat_page

                  ; read root directory
                  mov eax,fs:[si].rootdir_start
                  push fs
                  pop es
                  lea bx,[si].curr_dir
                  mov di,fs:[si].curr_dir_size
                  mov cl,fs:[si].sector_size_s
                  shr di,cl
                  call read_sector

                  ; copy volume label - it is only found in root directory
                  call get_volume_label
                  jc @@no_FAT_directory_entry_volume_label
                  mov DWord Ptr fs:[si].label_volume+0,eax
                  mov DWord Ptr fs:[si].label_volume+4,ecx
                  mov DWord Ptr fs:[si].label_volume+7,edx
  @@no_FAT_directory_entry_volume_label:

IFNDEF os2boot_ac_code

                  ; try to walk to \BOOTIMGS\ subdirectory

                  mov di,Offset p_cd_boot_directory
  walk_fat_subdir_loop:
                  movzx cx,Byte ptr ds:[di]
                  inc di
                  test cx,cx
                  jz walk_fat_subdir_done

                  ; ds:[di],cx
                  call normalize_filename83_tmp

                  add di,cx
                  pushad

                    ; find that subdirectory
                    push cs
                    pop es
                    mov di,Offset filename83_tmp
                    call search_directory
                    cmp bp,-1
                    stc
                    jz walk_fat_subdir_error

                    ; read subdirectory

                    call open_file

                    mov eax,fs:[si].file_size
                    test eax,eax                ; size zero would be an unexpeced error
                    jz walk_fat_subdir_error

                    mov ecx,Size curr_dir
                    cmp ecx,eax                 ; cut directories with too many files
                    if_a <mov ecx,eax>          ; could otherwise place an error message here

                    ; temporary buffer
                    push si
                      mov eax,ecx
                      mov si,Offset subdir_tmp_ptr
                      call getmem
                    pop si

                    les bx,subdir_tmp_ptr
                    call read_file

                    ; copy subdirectory
                    pushad
                    push ds
                      push fs
                      pop es
                      lea di,[si].curr_dir
                     ;mov cx,cx
                      lds si,subdir_tmp_ptr
                      push fs
                      pop es
                      shr cx,2
                      cld
                      rep movsd
                    pop ds
                    popad

                    mov fs:[si].curr_dir_size,cx

                    ; free temporary buffer
                    push si
                      mov si,Offset subdir_tmp_ptr
                      call freemem
                    pop si

  walk_fat_subdir_error:

                  popad
                  jnc walk_fat_subdir_loop

  walk_fat_subdir_done:
                  push fs
                  pop es

ENDIF ; not os2boot_ac_code

                ret
a_endp          load_disk_info_FAT

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
IFDEF SUPPORT_READ_HPFS

a_proc          load_disk_info_HPFS

                  call copy_volumelabel_from_bootsector

                ret
a_endp          load_disk_info_HPFS

ENDIF ; SUPPORT_READ_HPFS
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; source: ds:di,cx chars
                ; -> filename83_tmp
                ; -> CF=1 if non 8+3 name
a_proc          normalize_filename83_tmp
                push es
                push fs
                pusha
                 ;mov cx,cx
                 ;mov di,di
                  push cs
                  pop es
                  push cs
                  pop fs
                  mov bp,Offset filename83_tmp+0
                  call normalize_filename83
                popa
                pop fs
                pop es
                ret
a_endp          normalize_filename83_tmp

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; es:di,cx -> fs:bp
a_proc          normalize_filename83
                pusha

                  cld
                  mov dl,0 ; set error=false

                  ; Name(8)
                  mov bx,8
                  call normalize_filename83_part

                  ; eat exactly one dot, if present
                  test cx,cx
                  jz can_not_eat_dot
                  cmp Byte Ptr es:[di],'.'
                  jne can_not_eat_dot
                  inc di
                  dec cx
  can_not_eat_dot:
                  ; Extension(3)
                  mov bx,3
                  call normalize_filename83_part

                  shr dl,1 ; copy error value to CF

                popa
                ret
a_endp          normalize_filename83

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          normalize_filename83_part
                ; alters registers..
  process_part_normalize_filename83:
                ; all chars done?
                test cx,cx
                jz finish_part_normalize_filename83

                ; load next char, done if #0, '.' '\', '/' or ';'
                mov al,es:[di]
                call upcase
                cmp al,' '
                jb finish_part_normalize_filename83
                cmp al,'.'
                je finish_part_normalize_filename83
                cmp al,'\'
                je finish_part_normalize_filename83
                cmp al,'/'
                je finish_part_normalize_filename83
                cmp al,';'
                je finish_part_normalize_filename83
                ; accept char, less work left to do
                inc di
                dec cx
                ; if no space left, then skip copy
                test bx,bx
                jz noroom_part_normalize_filename83
                ; copy char, less space left
                mov fs:[bp],al
                inc bp
                dec bx
                jmp process_part_normalize_filename83

  noroom_part_normalize_filename83:
                ; accept only blanks, if no room left, else it is an error
                cmp al,' '
                setne al
                or dl,al ; set error bit
                jmp process_part_normalize_filename83

  finish_part_normalize_filename83:
                ; fill remaining space with blanks
                test bx,bx
                jz done_finish_part_normalize_filename83

  loop_finish_part_normalize_filename83:
                mov Byte Ptr fs:[bp],' '
                inc bp
                dec bx
                jnz loop_finish_part_normalize_filename83

  done_finish_part_normalize_filename83:

                ret
a_endp          normalize_filename83_part

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
a_proc          flush_fat_cache
                push es
                pushad

IFNDEF fatfile_readonly

                  cmp fs:[si].fsmode,fsmode_fat
                  jne flush_fat_cache_exit

                  cmp fs:[si].fat_change,0
                  je flush_fat_cache_exit

                  ; store into FAT, from 1. copy..
                  movzx cx,fs:[si].fat_count
                  mov eax,fs:[si].fat_start
                  movzx edx,fs:[si].fat_sector
                  add eax,edx
  update_all_FAT:
                  push fs
                  pop es
                  lea bx,[si].fat_buffer
                  mov bp,fs:[si].fat_size
                  sub bp,fs:[si].fat_sector
                  mov di,Size fat_buffer
                  push cx
                    mov cl,fs:[si].sector_size_s
                    shr di,cl ; /512
                  pop cx
                  cmp di,bp
                  if_a <mov di,bp>
                  call write_sector
                  movzx edx,fs:[si].fat_size
                  add eax,edx
                  loop update_all_FAT

  flush_fat_cache_exit:


ENDIF ; fatfile_readonly

                  mov fs:[si].fat_change,0

                popad
                pop es
                ret
a_endp          flush_fat_cache

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
                ; di=first FAT sector
a_proc          read_fat_page
                push es
                pushad

                  mov fs:[si].fat_sector,di
                  mov fs:[si].fat_change,0

                  ; read from FAT(1)
                  mov eax,fs:[si].fat_start
                  movzx edi,di
                  add eax,edi
                  push fs
                  pop es
                  lea bx,[si].fat_buffer
                  mov cx,fs:[si].fat_size
                  sub cx,di
                  mov di,Size fat_buffer
                  push cx
                    mov cl,fs:[si].sector_size_s
                    shr di,cl
                  pop cx
                  cmp di,cx
                  if_a <mov di,cx>

                  call read_sector

                popad
                pop es
                ret
a_endp          read_fat_page

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF fatfile_readonly

                ; fs:si=disk_info
a_proc          flush_dir_cache
                push es
                pushad

                  cmp fs:[si].fsmode,fsmode_fat
                  jne flush_dir_cache_exit

                  ; store root directory
                  mov eax,fs:[si].rootdir_start
                  push fs
                  pop es
                  lea bx,[si].curr_dir
                  mov di,fs:[si].curr_dir_size
                  mov cl,fs:[si].sector_size_s
                  shr di,cl
                  call write_sector

  flush_dir_cache_exit:

                popad
                pop es
                ret
a_endp          flush_dir_cache

ENDIF ; fatfile_readonly

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

check_fsmode_fat macro
                local continue
                cmp fs:[si].fsmode,fsmode_fat
                je continue
                call trap_invalid_cdfunction
  continue:
                EndM

a_proc          trap_invalid_cdfunction
                trap msg_invalid_cd_function
                ret
a_endp          trap_invalid_cdfunction

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; fs:si=disk_info,file
                ; fs:bp=dir entry
a_proc          open_file
                pushad

                  cmp fs:[si].disknum,'M'
                  if_ne <mov fs:[bp].fat_direntry.file_used,1>

                  mov ax,fs:[bp].fat_direntry.first_cluster
                  mov fs:[si].lastcluster,ax

                  mov fs:[si].current_file,bp
                  and fs:[si].file_position,0

                  mov eax,fs:[bp].cdromsector
                  mov fs:[si].firstfilesector,eax

                  mov eax,fs:[bp].fat_direntry.filesize
                  mov fs:[si].file_size,eax

                  test fs:[bp].attr,faDirectory
                  jz size_correct_for_plain_file

                  mov fs:[si].file_size,0
                  mov ax,fs:[bp].first_cluster
  determine_size_directory_loop:
                  call lookup_fat
                  movzx eax,fs:[si].cluster_size
                  mov cl,fs:[si].sector_size_s
                  shl eax,cl
                  add fs:[si].file_size,eax
                  mov ax,dx
                  cmp ax,0ffffh
                  jne determine_size_directory_loop

  size_correct_for_plain_file:

                popad
                ret
a_endp          open_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

begin_read_sector dd ?
begin_read_count  dw ?

                ; fs:si=disk_info,file
                ; es:bx=buffer
                ; cx=number of bytes, buffer must be multiple of sector size
a_proc          read_file
                pushad

                  ; size to sector
                  movzx eax,cx
                  movzx ecx,fs:[si].sector_size_b
                  dec cx
                  add eax,ecx ; 512-1
                  mov cl,fs:[si].sector_size_s
                  shr eax,cl                            ; / 512
                  mov ecx,eax

                  test cx,cx                            ; nothing to read ?
                  jz read_file_exit                     ; yes, exit

IFNDEF os2boot_ac_code

                  cmp fs:[si].fsmode,fsmode_fat
                  je read_file_fat

                  ;*****************************
                  ; CD ROM read
                  push ecx
                    mov ecx,fs:[si].file_position
                    call byte_to_sectornum
                    mov eax,ecx
                  pop ecx
                  add eax,fs:[si].firstfilesector
                  call read_cd_sector
                  ; ignore CF value, must be CF=0
                  mov eax,ecx
                  mov cl,fs:[si].sector_size_s
                  shl eax,cl
                  add fs:[si].file_position,eax
                  jmp read_file_exit
                  ;*****************************
  read_file_fat:

ENDIF ; -os2boot_ac_code

  read_file_loop:
                  cmp cx,0
                  je read_file_exit

                  ; first sector of current cluster
                  mov ax,fs:[si].lastcluster
                  call cluster_to_sector
                  mov [begin_read_sector],eax

                  ; position in cluster to sector
                  mov eax,fs:[si].file_position
                  push cx
                    mov cl,fs:[si].sector_size_s
                    shr eax,cl                  ; / 512
                  pop cx
                  mov di,fs:[si].cluster_size
                  dec di
                  and ax,di                     ; sector in this cluster 0..n-1
                  add [begin_read_sector],eax
                  inc di
                  sub di,ax                     ; sectors left in this cluster 1..n

                  mov [begin_read_count],0

  try_adjacent_clusters:
                  mov ax,di                     ; read:=available
                  cmp cx,di                     ; desired<available

                  if_b <mov ax,cx>
                  add [begin_read_count],ax
                  sub di,ax
                  sub cx,ax                     ; remove queued number of sectors

                  test di,di                    ; at a cluster wrap ?
                  jne read_file_do_read         ; no, process queue

                  mov di,fs:[si].cluster_size   ; begin new cluster

                  mov ax,fs:[si].lastcluster    ; direct successor ?
                  call lookup_fat
                  mov fs:[si].lastcluster,dx
                  inc ax
                  cmp ax,dx
                  jne read_file_do_read         ; no, process queue

                  test cx,cx                    ; all queued ?
                  jnz try_adjacent_clusters     ; no, process queue


  read_file_do_read:
                  mov eax,[begin_read_sector]
                  movzx edi,[begin_read_count]
                  call read_sector

                  push cx
                    mov cl,fs:[si].sector_size_s
                    shl edi,cl                  ; adjust buffer pointer
                  pop cx
                  add bx,di
                  add fs:[si].file_position,edi

                  jmp read_file_loop            ; next blocks

  read_file_exit:
                popad
                ret
a_endp          read_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;                ; works for files and directories
;                ; fs:si=disk_info,file
;                ; ZF=1 for EOF
;a_proc          is_end_of_file
;                push eax
;
;                  ; position>=filesize?
;                  mov eax,fs:[si].file_position
;                  cmp eax,fs:[si].file_size
;                  setae al
;                  cmp al,true
;
;                pop eax
;                ret
;a_endp          is_end_of_file
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; al->al
a_proc          convert_bcd_binary
                push dx
                  mov dx,ax
                  shr al,4
                  mov ah,10
                  mul ah
                  and dl,00fh
                  add dl,al
                  mov ax,dx
                pop dx
                ret
a_endp          convert_bcd_binary

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
a_proc          touch_filedatetime
                pushad

                  null ebx
                  mov bp,Offset convert_bcd_binary

                  mov ah,004h ; read rtc date
                  int 01ah

                  ; year: 7 bit
                  mov al,cl   ; year __xx
                  call bp
                  mov bl,al
                  mov al,ch   ; century
                  call bp
                  mov ah,al
                  mov ah,100
                  mul ah
                  sub ax,1980
                  add bx,ax

                  ; moth: 4 bit
                  shl bx,4
                  mov al,dh
                  call bp
                  or bl,al

                  ; day: 5 bit
                  shl bx,5
                  mov al,dl
                  call bp
                  or bl,al

                  mov ah,002h ; read rtc time
                  int 01ah

                  ; hours: 5 bit
                  shl ebx,5
                  mov al,ch
                  call bp
                  or bl,al

                  ; minutes: 6 bit
                  shl ebx,6
                  mov al,cl
                  call bp
                  or bl,al

                  ; seconds/2: 5 bit
                  shl ebx,5
                  mov al,dh
                  call bp
                  shr al,1
                  or bl,al

                  mov bp,fs:[si].current_file
                  mov fs:[bp].fat_direntry.datetime,ebx

                popad
                ret
a_endp          touch_filedatetime

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
a_proc          close_file
                push bp

IFNDEF os2boot_ac_code
                  cmp cfg_record.cfg_progress_indicator,progress_indicator_display_files
                  jne no_create_file_display2
                  cmp fs:[si].disknum,'M'
                  jne no_create_file_display2

                  call ausschrift_zeichen_CRLF

  no_create_file_display2:

ENDIF ; -os2boot_ac_code

                  ; 0 byte files have cluster set to 0
                  mov bp,fs:[si].current_file
                  cmp fs:[bp].first_cluster,0ffffh
                  if_e <inc fs:[bp].first_cluster>

                  mov fs:[si].lastcluster,-1
                  mov fs:[si].current_file,-1
                  and fs:[si].file_position,0
                  mov fs:[si].firstfilesector,-1


                pop bp
                ret
a_endp          close_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF fatfile_readonly

                ; fs:si=disk_info
                ; es:di=file name (8/3 format)
                ; -> updates fs:si blocks
a_proc          create_file
                check_fsmode_fat
                pushad

                  cmp cfg_record.cfg_progress_indicator,progress_indicator_display_files
                  jne no_create_file_display1

                  push si
                  push ds
                  push cx

                    push es
                    pop ds
                    mov si,di
                    mov cx,8
                    call ausschrift_laenge

                    mov al,'.'
                    call ausschrift_zeichen

                    mov cl,3
                    add si,8
                    call ausschrift_laenge

                    mov al,' '
                    call ausschrift_zeichen

                  pop cx
                  pop ds
                  pop si

  no_create_file_display1:

                  ; es:di=filename 8+3
                  call search_file
                  cmp bp,-1
                  if_ne <call delete_file>

                  call search_free_direntry

                  mov fs:[si].current_file,bp
                  mov fs:[si].lastcluster,0

                  mov eax,es:[di+0]
                  mov ebx,es:[di+4]
                  mov ecx,es:[di+8-1]

                  mov dword ptr fs:[bp].filenameext+0  ,eax
                  mov dword ptr fs:[bp].filenameext+4  ,ebx
                  mov dword ptr fs:[bp].filenameext+8-1,ecx
                  mov fs:[bp].first_cluster,-1
                  and fs:[si].file_position,0

                popad
                ret
a_endp          create_file
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info,file
                ; es:bx=buffer
                ; cx=number of bytes, cluster size or last part of file
a_proc          write_file
                check_fsmode_fat
                pushad

                  mov bp,fs:[si].current_file

  write_file_loop:

                  test cx,cx
                  jz exit_write_file

                  push cx

                    call allocate_cluster
                    cmp ax,-1
                    if_e <trap msg_Write_error_disk_full>

                    mov cx,1
                    call write_cluster

                    mov di,fs:[si].current_file

                    mov dx,fs:[si].lastcluster
                    cmp fs:[bp].fat_direntry.filesize,0
                    je firstblock

                    ; add to FAT chain
                    xchg dx,ax
                    call change_fat
                    xchg dx,ax
                    jmp continue_write_file
  firstblock:
                    ; set first cluster in directory entry
                    mov fs:[bp].fat_direntry.first_cluster,ax

  continue_write_file:
                    ; set EOF
                    mov dx,0ffffh
                    call change_fat
                    mov fs:[si].lastcluster,ax
                  pop cx

                  mov ax,fs:[si].cluster_size
                  push cx
                    mov cl,fs:[si].sector_size_s
                    shl ax,cl
                  pop cx
                  cmp ax,cx
                  if_a <mov ax,cx>
                  add bx,ax                     ; buffer pos
                  sub cx,ax                     ; remaining bytes
                  movzx eax,ax                  ; update directory entry
                  add fs:[bp].fat_direntry.filesize,eax
                  add fs:[si].file_position,eax
                  jmp write_file_loop
exit_write_file:
                popad
                ret
a_endp          write_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
a_proc          erase_volumelabel
                pushad

                  call first_directory_entry
                  jc @@exit_erase_volumelabel
  @@erase_volumelabel_loop:
                  test byte ptr fs:[bp].fat_direntry.attr,faVolumeID
                  jz @@skip_not_volumelabel

                  ; delete
                  mov byte ptr fs:[bp].fat_direntry.filenameext,erased_file

  @@skip_not_volumelabel:
                  call next_directory_entry
                  jnc @@erase_volumelabel_loop

  @@exit_erase_volumelabel:

                popad
                ret
a_endp          erase_volumelabel
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
                ; fs:bp=direcory entry
a_proc          delete_file
                check_fsmode_fat
                push ax

                  mov al,erased_file
                  xchg byte ptr fs:[bp].fat_direntry.filenameext,al
                  mov byte ptr fs:[bp].fat_direntry.drdos_first_letter,al

                  mov ax,fs:[bp].fat_direntry.first_cluster
                  call free_cluster_chain

                pop ax
                ret
a_endp          delete_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
                ; -> fs:bp=direcory entry
a_proc          search_free_direntry
                push cx

                  mov cx,fs:[si].curr_dir_size
                  shr cx,shift_byte_per_direntry
                  lea bp,[si].curr_dir

  search_free_direntry_loop:
                  ; empty
                  cmp byte ptr fs:[bp].fat_direntry.filenameext,end_of_fat_directory
                  je exit_search_free_direntry
                  ; deleted
                  cmp byte ptr fs:[bp].fat_direntry.filenameext,erased_file
                  je exit_search_free_direntry

                  add bp,size fat_direntry
                  loop search_free_direntry_loop

                 ;mov bp,-1
                  trap msg_directory_full

  exit_search_free_direntry:
                  push ax
                  push di
                  push es
                    push fs
                    pop es
                    cld
                    mov di,bp
                    mov cx,(Size fat_direntry)/2
                    sub ax,ax
                    rep stosw
                  pop es
                  pop di
                  pop ax

                pop cx
                ret
a_endp          search_free_direntry

ENDIF ; fatfile_readonly

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; fs:si=disk_info
                ; es:di=filename 8+3
                ; -> fs:bp=direcory entry or bp=-1 for not found
a_proc          search_file
                push dx
                  mov dh,0                              ; any
                  mov dl,(faVolumeID+faDirectory)       ; exclude
                  call search_directory_entry
                pop dx
                ret
a_endp          search_file

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; fs:si=disk_info
                ; es:di=filename 8+3
                ; -> fs:bp=direcory entry or bp=-1 for not found
a_proc          search_directory
                push dx
                  mov dh,faDirectory                    ; must be directories
                  mov dl,faVolumeID                     ; Volume bit invalid
                  call search_directory_entry
                pop dx
                ret
a_endp          search_directory

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; fs:si=disk_info
                ; es:di=filename 8+3
                ; -> ZF
a_proc          compare_volumelabel
                push eax
                  mov eax,DWord Ptr es:[di+0]
                  cmp eax,DWord Ptr fs:[si+0].label_volume
                  jnz exit_compare_volumelabel
                  mov eax,DWord Ptr es:[di+4]
                  cmp eax,DWord Ptr fs:[si+4].label_volume
                  jnz exit_compare_volumelabel
                  mov eax,DWord Ptr es:[di+7]
                  cmp eax,DWord Ptr fs:[si+7].label_volume
  exit_compare_volumelabel:
                pop eax
                ret
a_endp          compare_volumelabel
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; fs:si=disk_info
                ; es:di=filename 8+3
                ; dh=must have attribute bits
                ; dl=must not have attribute bits
                ; -> fs:bp=direcory entry or bp=-1 for not found
a_proc          search_directory_entry
                push eax
                push ebx
                push edi
                push cx

                  mov eax,dword ptr es:[di+0]
                  mov ebx,dword ptr es:[di+4]
                  mov edi,dword ptr es:[di+7]

                  call first_directory_entry
                  jc @@search_directory_entry_failed
  @@search_directory_entry_loop:
                  cmp DWord Ptr fs:[bp].fat_direntry.filenameext+0,eax
                  jne @@search_directory_entry_next
                  cmp DWord Ptr fs:[bp].fat_direntry.filenameext+4,ebx
                  jne @@search_directory_entry_next
                  cmp DWord Ptr fs:[bp].fat_direntry.filenameext+7,edi
                  jnz @@search_directory_entry_next
                  test Byte Ptr fs:[bp].fat_direntry.attr,dl ; must-not-have bits
                  jnz @@search_directory_entry_next
                  push ax
                    mov al,Byte Ptr fs:[bp].fat_direntry.attr
                    and al,dh ; must-have bits
                    cmp al,dh ; all set?
                  pop ax
                  je @@search_directory_entry_exit

  @@search_directory_entry_next:
                  call next_directory_entry
                  jnc @@search_directory_entry_loop

  @@search_directory_entry_failed:
                  mov bp,-1

  @@search_directory_entry_exit:

                pop cx
                pop edi
                pop ebx
                pop eax
                ret
a_endp          search_directory_entry

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; only called from load_disk_info_FAT
                ; fs:si=disk_info (FAT,root directory only)
                ; -> eax,ecx,edx=volume label
a_proc          get_volume_label
                push bp

                  call first_directory_entry
                  jc  @@get_volume_label_exit
  @@get_volume_label_loop:
                  test byte ptr fs:[bp].fat_direntry.attr,faVolumeID
                  jz  @@get_volume_label_next
                  test byte ptr fs:[bp].fat_direntry.attr,not (faVolumeID+faArchive)
                  jnz @@get_volume_label_next

                  mov eax,DWord Ptr fs:[bp].fat_direntry.filenameext+0
                  mov ecx,DWord Ptr fs:[bp].fat_direntry.filenameext+4
                  mov edx,DWord Ptr fs:[bp].fat_direntry.filenameext+7
                  clc
                  jmp @@get_volume_label_exit_success

  @@get_volume_label_next:
                  call next_directory_entry
                  jnc @@get_volume_label_loop

  @@get_volume_label_exit:
                  ; could set 'NO N' 'AME ' ' FAT' here,
                  ; but the value is already there from the bootsector.
                  stc

  @@get_volume_label_exit_success:

                pop bp
                ret
a_endp          get_volume_label

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF fatfile_readonly

                ; fs:si=disk_info
                ; ->ax=cluster or -1 for disk full
a_proc          allocate_cluster
                check_fsmode_fat
                push cx
                push dx

                  mov cx,fs:[si].cluster_high ; is larger than number of clusters
                  mov ax,fs:[si].cluster_next
search_free_cluster_loop:
                  cmp ax,2
                  jb allocate_cluster_from2
                  cmp ax,fs:[si].cluster_high
                  jbe have_valid_cluster
allocate_cluster_from2:
                  mov ax,2
have_valid_cluster:
                  call lookup_fat
                  test dx,dx
                  jnz cluster_is_already_allocated

                  ; remember for next search
                  mov fs:[si].cluster_next,ax
                  inc fs:[si].cluster_next

                  ; allocate by setting end of file
                  mov dx,-1
                  call change_fat
                  jmp exit_allocate_cluster

cluster_is_already_allocated:

                  inc ax
                  loop search_free_cluster_loop

                  mov ax,-1

exit_allocate_cluster:

                pop dx
                pop cx
                ret
a_endp          allocate_cluster

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
                ; ax=cluster
a_proc          free_cluster_chain
                check_fsmode_fat
                pusha

free_cluster_chain_next:
                  cmp ax,2
                  jb free_cluster_chain_exit
                  cmp ax,fs:[si].cluster_high
                  ja free_cluster_chain_exit

                  call lookup_fat               ; look for next
                  push dx                       ;   and remember it
                  sub dx,dx                     ; free
                  call change_fat               ;   current
                  pop ax                        ; continue with next
                  jmp free_cluster_chain_next

free_cluster_chain_exit:
                popa
                ret
a_endp          free_cluster_chain

ENDIF ; -fatfile_readonly

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
                ; ax=cluster
                ; -> dx=0 (free) 1..fff0 (data chain) fff1 (bad) ffff (eof)
a_proc          lookup_fat
                check_fsmode_fat
                push di

                  cmp fs:[si].fat_bit,12
                  je lookup_fat_12

                  ; FAT16 FAT can be more pages
                  mov di,ax
                  shr di,12             ; div (Size fat_buffer)/2
                  push cx
                    ;shl di,4              ; *(Size fat_buffer)/512
                    mov cl,4+9
                    sub cl,fs:[si].sector_size_s
                    shl di,cl
                  pop cx

                  cmp di,fs:[si].fat_sector
                  je lookup_fat_16_correct_page

                  call flush_fat_cache
                  call read_fat_page

  lookup_fat_16_correct_page:
                  push ax
                    and ax,(Size fat_buffer/2)-1
                    lea di,[si].fat_buffer
                    add di,ax
                    add di,ax
                  pop ax
                  mov dx,word ptr fs:[di]
                  jmp simplify_lookup_fat
  lookup_fat_12:
                  ; FAT12 FAT fits completely into buffer
                  mov di,ax                     ; *3
                  add di,ax
                  add di,ax
                  shr di,1                      ; /2
                  add di,si
                  add di,fat_buffer
                  mov dx,word ptr fs:[di]
                  test al,1
                  jz lookup_fat_12_even
                  shr dx,4
  lookup_fat_12_even:
                  and dx,00fffh
                  cmp dx,00ff1h
                  jb simplify_lookup_fat
                  or dh,0f0h
  simplify_lookup_fat:
                  cmp dx,0fff0h
                  jbe exit_lookup_fat

                  cmp dx,0fff8h                 ; eof
                  mov dl,0ffh
                  jae exit_lookup_fat
                  mov dl,0f1h                   ; bad
  exit_lookup_fat:
                pop di
                ret
a_endp          lookup_fat

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF fatfile_readonly

                ; fs:si=disk_info
                ; ax=cluster
                ; dx=0 (free) 1..fff0 (data chain) fff1 (bad) ffff (eof)
a_proc          change_fat
                check_fsmode_fat
                push di
                push dx

                  cmp fs:[si].fat_bit,12
                  je store_fat_12

                  ; FAT16 FAT can be more pages
                  mov di,ax
                  shr di,12             ; div (Size fat_buffer)/2
                  push cx
                    ;shl di,4              ; *(Size fat_buffer)/512
                    mov cl,4+9
                    sub cl,fs:[si].sector_size_s
                    shl di,cl
                  pop cx

                  cmp di,fs:[si].fat_sector
                  je change_fat_16_correct_page

                  call flush_fat_cache
                  call read_fat_page

  change_fat_16_correct_page:
                  push ax
                    and ax,(Size fat_buffer/2)-1
                    lea di,[si].fat_buffer
                    add di,ax
                    add di,ax
                  pop ax
                  mov word ptr fs:[di],dx
                  jmp exit_change_fat
  store_fat_12:
                  and dx,00fffh
                  mov di,ax                     ; *3
                  add di,ax
                  add di,ax
                  shr di,1                      ; /2
                  add di,si
                  add di,fat_buffer
                  test al,1
                  jz store_fat_12_even

                  shl dx,4
                  and word ptr fs:[di],0000fh
                  or word ptr fs:[di],dx
                  jmp exit_change_fat
  store_fat_12_even:
                  and word ptr fs:[di],0f000h
                  or word ptr fs:[di],dx
  exit_change_fat:
                  mov fs:[si].fat_change,1

                pop dx
                pop di
                ret
a_endp          change_fat

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=disk_info
                ; -> eax
a_proc          GetDiskFree
                check_fsmode_fat
                push ecx
                push edx

                  sub ecx,ecx
                  ; sum cluster 2..high
                  mov ax,2

  loop_GetDiskFree_fat:
                  call lookup_fat
                  test dx,dx            ; 0=free
                  cmp dx,1              ; 0->CF=1
                  adc ecx,0
                  inc ax
                  cmp ax,fs:[si].cluster_high
                  jbe loop_GetDiskFree_fat

                  ; cluster -> sectors
                  movzx eax,fs:[si].cluster_size
                  mul ecx

                  ; sectors -> bytes
                  mov cl,fs:[si].sector_size_s
                  shl eax,cl

                pop edx
                pop ecx
                ret
a_endp          GetDiskFree

ENDIF ; -fatfile_readonly

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; fs:si=source
                ; ax=cluster
                ; es:bx=data
                ; cx=number
a_proc          read_cluster
                check_fsmode_fat
                pushad
                  call cluster_to_sector
                  call read_sector
                popad
                ret
a_endp          read_cluster

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF fatfile_readonly

                ; fs:si=target
                ; ax=cluster
                ; es:bx=data
                ; cx=number
a_proc          write_cluster
                check_fsmode_fat
                pushad
                  call cluster_to_sector
                  call write_sector
                popad
                ret
a_endp          write_cluster

ENDIF ; -fatfile_readonly

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; fs:si=target
                ; ax=cluster
                ; cx=cluster count
                ; ->eax sector number
                ; ->di=sector count
a_proc          cluster_to_sector
                push cx

                  cmp ax,2
                  if_b <trap msg_invalid_cluster_number_2>
                  cmp ax,fs:[si].cluster_high
                  if_a <trap msg_invalid_cluster_number_max>

                  mov di,cx

                  mov cx,fs:[si].cluster_size
                  bsf cx,cx

                  shl di,cl ; di:=cx*cluster_size

                  ; ax->eax
                  dec ax
                  dec ax
                  movzx eax,ax
                  shl eax,cl
                  add eax,fs:[si].data_start

                pop cx
                ret
a_endp          cluster_to_sector

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          read_1_sector_eax
                push di
                  mov di,1
                  call read_sector
                pop di
                ret
a_endp          read_1_sector_eax

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

sector_read_error0      db msg_sector_read_error_0,0
sector_read_error1      db msg_sector_read_error_1,0
sector_read_error2      db msg_sector_read_error_2,0
sector_read_error3      db msg_sector_read_error_3,0
sector_read_error4      db msg_sector_read_error_4,13,10,0

                ; fs:si=source
                ; eax=sector (absolute)
                ; es:bx=data
                ; di=number
a_proc          read_sector
                check_fsmode_fat
                pushad

IFNDEF os2boot_ac_code
                  cmp fs:[si].disknum,'M'
                  jne not_read_sector_memdisk

                  mov ecx,eax                   ; sector number
                  mov ax,di                     ; count
                 ;mov es:bx,es:bx               ; buffer
                  call read_memdisk_sectors     ; format.inc
                  clc
                  jmp exit_read_sector

  not_read_sector_memdisk:

ENDIF ; -os2boot_ac_code

                  cmp fs:[si].bios_i13x_sup,1
                  jne read_use_i13_02

                  ; eax=sector (absolute)
                  ; es:bx=data
                  mov cx,di ; count
                  ; fs:si=source
                  call read_cd_sector
                  ; can return CF=1 only when fs:[si].read_may_fail=true
                  jmp exit_read_sector

  read_use_i13_02:
                  call convert_lba_to_chs

  loop_read_sector_multitrack:

                  mov ax,cx
                  and ax,03fh
                  add ax,di
                  cmp ax,fs:[si].sectors_track  ; not in this track ?
                  mov ax,di
                  jbe read_ends_in_same_track

                  mov ax,cx
                  and ax,03fh
                  neg ax
                  add ax,fs:[si].sectors_track
                  inc ax

  read_ends_in_same_track:
                  mov ah,002h

                  sub bp,bp                     ; number of retries
  loop_read_sector_small:

                  cmp bp,3
                  jne not_try3

                  cmp fs:[si].read_may_fail,true
                  stc
                  je exit_read_sector
  not_try3:
                  cmp bp,10
                  jne try_read_sector

                  mov al,error_TextAttr
                  xchg [TextAttr],al
                  mov al,fs:[si].disknum
                  mov si,Offset sector_read_error0      ; read error
                  call ausschrift
                 ;mov al,al                             ; drive(fs:[si].disknum)
                  call ausschrift_al_hex
                  mov si,Offset sector_read_error1      ; cylinder=
                  call ausschrift
                  movzx eax,cx                          ; cylinder
                  ror ax,8
                  shr ah,6
                  call ausschrift_eax
                  mov si,Offset sector_read_error2      ; head=
                  call ausschrift
                  movzx eax,dh                          ; head
                  call ausschrift_eax
                  mov si,Offset sector_read_error3      ; sector=
                  call ausschrift
                  movzx eax,cl                          ; sector
                  and al,03fh
                  call ausschrift_eax
                  call ausschrift_errorcode
                  mov [TextAttr],al
                  push Offset sector_read_error4        ; end of sentence
                  jmp trap_proc

  try_read_sector:
                  pusha
                    call int_13
                    mov [i13_errorcode],ah
                  popa
                  jnc done_read_sector_small            ; carry must used for function ah=02h

                  inc bp

                  pusha                                 ; reset floppy
                    mov ah,0
                    call int_13                         ; ignore errors
                  popa


                  shr al,1                              ; half amount of sectors
                  cmp al,0
                  if_e <mov al,1>
                  jmp loop_read_sector_small

  done_read_sector_small:
                  mov ah,0
                  push bx

                    ; unpack cylinder/sector byte
                    mov bl,ch
                    mov bh,cl
                    shr bh,6
                    and cx,03fh

                    ; add current number of sectors
                    add cx,ax
                    cmp cx,fs:[si].sectors_track
                    jbe read_sector_valid
                    sub cx,fs:[si].sectors_track        ; sector 1,
                    inc dh                              ; next head
                    cmp dh,byte ptr fs:[si].heads
                    jb read_head_valid
                    sub dh,byte ptr fs:[si].heads       ; head 0,
                    inc bx                              ; next cylinder
  read_head_valid:
  read_sector_valid:

                    ; pack into cx again
                    mov ch,bl
                    shl bh,6
                    or cl,bh

                  pop bx


                  ; adjust target buffer
                  push cx
                    mov cl,fs:[si].sector_size_s
                    shl ax,cl                             ; *512
                    add bx,ax
                    shr ax,cl
                  pop cx

                  sub di,ax
                  jnz loop_read_sector_multitrack

  exit_read_sector:
                popad
                ret
a_endp          read_sector

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF os2boot_ac_code

                ; fs:si=target
                ; eax=sector (absolute)
                ; es:bx=data
                ; di=number
a_proc          write_sector
                check_fsmode_fat
                pushad

                  cmp fs:[si].disknum,'M'
                  jne not_write_sector_memdisk

                  mov ecx,eax                   ; sector number
                  mov ax,di                     ; count
                 ;mov es:bx,es:bx               ; buffer
                  call write_memdisk_sectors    ; format.inc
                  jmp exit_write_sector

  not_write_sector_memdisk:
                  call convert_lba_to_chs
                  mov ax,di
                  mov ah,003
                  call int_13

  exit_write_sector:

                popad
                ret
a_endp          write_sector

ENDIF ; os2boot_ac_code

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; eax=sector (absolute)
                ; -> cx/dx
a_proc          convert_lba_to_chs
                check_fsmode_fat
                push ebx
                push eax
                push edx

                  sub edx,edx
                  movzx ebx,fs:[si].sectors_track
                  div ebx

                  mov cx,dx
                  inc cx                  ; sector (cl) ; cylinder (ch)=0
                  sub edx,edx
                  movzx ebx,fs:[si].heads
                  div ebx

                  mov bh,dl               ; head
                pop edx
                mov dh,bh

                shl ah,6                ; cylinder
                rol ax,8
                or cx,ax

                mov dl,fs:[si].disknum

                pop eax
                pop ebx
                ret
a_endp          convert_lba_to_chs

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;               fs:si=@disk_info
;               -> fs:bp=@directory entry
;               CF=Error/End of directory
a_proc          first_directory_entry
                lea bp,[si].curr_dir

  @@first_directory_entry_again:
                call check_valid_directory_entry
                jc @@first_directory_entry_exit

                ; have an valid slot. is it erased?
                cmp Byte Ptr fs:[bp].filenameext,erased_file
                ; set 'no error' and break if not
                clc
                jne @@first_directory_entry_exit

                ; try next slot
                add bp,(1 shl shift_byte_per_direntry)
                jmp @@first_directory_entry_again

  @@first_directory_entry_exit:
                ret
a_endp          first_directory_entry
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;               fs:si=@disk_info
;               <-> fs:bp=@directory entry
;               CF=Error/End of directory
a_proc          next_directory_entry
                call check_valid_directory_entry
                jc @@next_directory_entry_exit

  @@next_directory_entry_again:
                add bp,(1 shl shift_byte_per_direntry)
                call check_valid_directory_entry
                jc @@next_directory_entry_exit

                cmp Byte Ptr fs:[bp].filenameext,erased_file
                je @@next_directory_entry_again

                clc

  @@next_directory_entry_exit:

                ret
a_endp          next_directory_entry
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
a_proc          check_valid_directory_entry
                push ax

                  mov ax,bp
                  sub ax,si
                  if_c <trap 'cv1'>

                  sub ax,Offset curr_dir
                  if_c <trap 'cv2'>

                  test ax,(1 shl shift_byte_per_direntry)-1
                  if_nz <trap 'cv3'>
                  cmp ax,fs:[si].curr_dir_size
                  jae @@check_valid_directory_entry_fail

                  cmp Byte Ptr fs:[bp].filenameext,end_of_fat_directory
                  je @@check_valid_directory_entry_fail

                  clc
                  jmp @@check_valid_directory_entry_ret

  @@check_valid_directory_entry_fail:
                  stc

  @@check_valid_directory_entry_ret:

                pop ax
                ret
a_endp          check_valid_directory_entry
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
