Title           Clean disk memory and create empty partition

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF nodebug
a_proc          a20_transfer_test1
                pushad
                push es
                push fs

                  push bios0040
                  pop fs

                  les bx,formatpuffer_ptr

                  mov edx,fs:[daily_timer_counter]
  l1:
                  cmp edx,fs:[daily_timer_counter]
                  je l1

                  mov ecx,10000000
  l2:
                  push ecx
                    mov ecx,1
                    mov ax,1
                    call read_memdisk_sectors
                  pop ecx
                  loop l2

                  mov al,'A'
                  call ausschrift_zeichen
                  mov al,'2'
                  call ausschrift_zeichen
                  mov al,'0'
                  call ausschrift_zeichen
                  mov al,':'
                  call ausschrift_zeichen

                  call query_a20
                  mov al,dl
                  or al,'0'
                  call ausschrift_zeichen
                  mov al,' '
                  call ausschrift_zeichen
                  mov al,':'
                  call ausschrift_zeichen

                  mov eax,fs:[daily_timer_counter]
                  sub eax,edx

                  call ausschrift_eax
                  call ausschrift_zeichen_CRLF

                pop fs
                pop es
                popad
                ret
a_endp          a20_transfer_test1

a_proc          a20_transfer_test
                pushad

                call query_a20                  ; ->dl
                push dx

                call disable_a20
                call a20_transfer_test1

                call enable_a20
                call a20_transfer_test1

                call disable_a20
                call a20_transfer_test1

                call enable_a20
                call a20_transfer_test1

                pop dx
                call set_a20                    ; <- dl

                mov al,'O'
                call ausschrift_zeichen
                mov al,'f'
                call ausschrift_zeichen
                mov al,'s'
                call ausschrift_zeichen
                mov al,'='
                call ausschrift_zeichen

                mov ax,[a20_access_code]
                call ausschrift_ax_hex
                call ausschrift_zeichen_CRLF

                mov al,'E'
                call ausschrift_zeichen
                mov al,'X'
                call ausschrift_zeichen
                mov al,'T'
                call ausschrift_zeichen
                mov al,'='
                call ausschrift_zeichen

                mov al,[a20_access]
                call ausschrift_al_hex
                call ausschrift_zeichen_CRLF


                popad
                ret
a_endp          a20_transfer_test
ENDIF ; -nodebug


formatpuffer_size       equ 32*1024
formatpuffer_ptr        ptr1616 <0,0>

format_value            dd 0

a_proc          format_disk
                push es
                pushad

                  mov eax,formatpuffer_size
                  mov si,Offset formatpuffer_ptr
                  call getmem

IFNDEF nodebug
;                  call a20_transfer_test
ENDIF ; -nodebug


                  les di,[si]                   ; formatpuffer_ptr
                  mov cx,formatpuffer_size/4
                  mov eax,[format_value]
                  cld
                  rep stosd

                  mov ecx,0                     ; Zylinder 0,Kopf 0,Sektor 1
                  mov edx,cs:MemDiskBIOS_Info._anzahl_sektoren
                  mov eax,formatpuffer_size/512
                  les bx,formatpuffer_ptr
  formatierschleife:
                  cmp eax,edx
                  if_a <mov eax,edx>
                  call write_memdisk_sectors
                  add ecx,eax
                  sub edx,eax
                  jnz formatierschleife

                  mov si,Offset formatpuffer_ptr
                  call freemem

                popad
                pop es
                ret
a_endp          format_disk

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF verify_memory

verify_sc       screen_save <>

a_proc          verify_disk_memory
                push es
                pushad

                  mov [format_value],0f6f6f6f6h
                  call format_disk

                  ; garble video memory

                  mov si,Offset verify_sc
                  call save_screen

                  STEP 'GVM1'

                  mov ax,00012h ; 640*480*16
                  call int_10h

                  mov ax,04f02h
                  mov bx,00105h ; 1024*768*256
                  call int_10h

                  mov ax,00003h ; 80*25*16
                  call int_10h

                  call modify_palette

                  STEP 'GVM2'

                  mov si,Offset verify_sc
                  call restore_screen

                  ; check disk memory

                  mov eax,formatpuffer_size
                  mov si,Offset formatpuffer_ptr
                  call getmem

                  mov ecx,0                     ; Zylinder 0,Kopf 0,Sektor 1
                  mov edx,cs:MemDiskBIOS_Info._anzahl_sektoren
                  mov eax,formatpuffer_size/512
                  les bx,formatpuffer_ptr
  verify_schleife:
                  cmp eax,edx
                  if_a <mov eax,edx>
                  call read_memdisk_sectors


                  push eax
                    mov eax,ecx
                    call ausschrift_eax_hex
                    mov al,'/'
                    call ausschrift_zeichen
                    mov eax,ecx
                    shl eax,9 ; *512
                    add eax,MemDiskBIOS_Info._phys_addr
                    call ausschrift_eax_hex
                    mov al,' '
                    call ausschrift_zeichen
                  pop eax

                  pushad

                    mov di,bx
                    mov ecx,eax
                    shl ecx,7 ; *512/4 =2^(9-2)
                    mov eax,[format_value]
                    cld
                    repe scasd

                    if_ne <trap msg_Memory_disk_memory_is_corrupted>

                  popad

                  push ax
                    mov al,13
                    call ausschrift_zeichen
                  pop ax

                  add ecx,eax
                  sub edx,eax
                  jnz verify_schleife

                  call ClrEol

                  mov si,Offset formatpuffer_ptr
                  call freemem

                  and [format_value],0

                popad
                pop es
                ret
a_endp          verify_disk_memory

ENDIF ; verify_memory

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; es:di
a_proc          speichere_partition_ZKS_1
                sub edx,edx
                div MemDiskBIOS_Info._anzahl_sektoren_je_spur
                inc dl
                mov es:[di].partition.begin_sector,dl
                sub edx,edx
                div MemDiskBIOS_Info._anzahl_koepfe
                mov es:[di].partition.begin_head,dl
                mov es:[di].partition.begin_cylinder,al
                shl ah,6
                or es:[di].partition.begin_sector,ah
                ret
a_endp          speichere_partition_ZKS_1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; ebx/edx-> es:[di]...
a_proc          speichere_partition_ZKS
                pushad
                  mov eax,edx
                  call speichere_partition_ZKS_1
                  add di,end_sector-begin_sector
                  mov eax,ebx
                  dec eax
                  call speichere_partition_ZKS_1
                popad
                ret
a_endp          speichere_partition_ZKS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; -> es:si
a_proc          finish_LVM_infosector
                pushad

                  ; db 002,'RMBPMFD'
                  mov dword ptr es:[si].lvm_beschreibungstabelle_typ.DLA_Signature+0,DLA_Signature_lo
                  mov dword ptr es:[si].lvm_beschreibungstabelle_typ.DLA_Signature+4,DLA_Signature_hi

                  mov es:[si].lvm_beschreibungstabelle_typ.Disk_Serial_Number,'DSer'
                  mov es:[si].lvm_beschreibungstabelle_typ.Boot_Disk_Serial_Number,'BSer'
                  mov eax,MemDiskBIOS_Info._anzahl_zylinder
                  mov es:[si].lvm_beschreibungstabelle_typ.Cylinders,eax
                  mov eax,MemDiskBIOS_Info._anzahl_koepfe
                  mov es:[si].lvm_beschreibungstabelle_typ.Heads_Per_Cylinder,eax
                  mov eax,MemDiskBIOS_Info._anzahl_sektoren_je_spur
                  mov es:[si].lvm_beschreibungstabelle_typ.Sectors_Per_Track,eax
                  ; '[ Me''mDis''k ]'
                  mov dword ptr es:[si].lvm_beschreibungstabelle_typ.Disk_Name+0,'eM ['
                  mov dword ptr es:[si].lvm_beschreibungstabelle_typ.Disk_Name+4,'siDm'
                  mov dword ptr es:[si].lvm_beschreibungstabelle_typ.Disk_Name+8, '] k'


                  and es:[si].lvm_beschreibungstabelle_typ.DLA_CRC,0

                  ; es:si,cx
                  mov cx,512
                  call calculate_crc32
                  not eax
                  mov es:[si].lvm_beschreibungstabelle_typ.DLA_CRC,eax

                popad
                ret
a_endp          finish_LVM_infosector

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
create_partition_puffer_ptr ptr1616 <0,0>

sekt_part       equ 0*512       ; MBR/EMBR having FAT12 partition
sekt_partlvm    equ 1*512       ; LVM info sector for sekt_part
sekt_boot       equ 2*512       ; boot sector
sekt_fat        equ 3*512       ; first FAT 1/2 sector
sekt_root       equ 4*512       ; first root directory sector
sekt_extpart    equ 5*512       ; MBR/EMBR having extended partition
sekt_extpartlvm equ 6*512       ; LVM info sector for sekt_extpart

cylinder_size   dd ?

lvm_driveletter_change_sector   dd ?
boot_sector_number              dd ?

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          dummy_bootsector_code


  begin_dummy_bootsector_code:
                mov ax,3        ; clear
                int 010h

                mov ax,01301h   ; print string+move cursor
                mov bx,00040h   ; page/attribute
                mov cx,(Offset string_no_sys_end)-(Offset string_no_sys_begin)
                sub dx,dx       ; GotoXY(1,1)
                push cs
                pop es
                call pop_bp_string

  string_no_sys_begin:
                db 'Add a bootsector!'
  string_no_sys_end:

  pop_bp_string:
                pop bp
                int 010h

 please_reboot_loop:
                sub ax,ax       ; wait
                int 016h
                jmp please_reboot_loop

end_dummy_bootsector_code:

a_endp          dummy_bootsector_code


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; es:si
a_proc          insert_dummy_bootsector_code
                pusha
                push ds
                  ; insert jump
                  mov Word Ptr es:[si].jmp0,050ebh ; jmp $50+$02

                  ; insert OEM name
                  mov DWord ptr es:[si].Bootsector.oemname+0,'DmeM'     ; MemDisk_
                  mov DWord ptr es:[si].Bootsector.oemname+4,'_ksi'

                  ; insert error message display code
                  lea di,[si+050h+002h]
                  push cs
                  pop ds
                  mov si,Offset begin_dummy_bootsector_code
                  mov cx,Offset end_dummy_bootsector_code
                  sub cx,si
                  cld
                  rep movsb

                pop ds
                popa
                ret
a_endp          insert_dummy_bootsector_code

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          create_partition
                push es
                pushad

                  ; do not waste space for not visible extended partition
                  ; sttructures in superfloppy mode
                  cmp MemDiskBIOS_Info._lvm_letter,'C'
                  if_b <mov cfg_record.cfg_primaer_oder_logisch,1>

                  mov eax,7*512
                  mov si,Offset create_partition_puffer_ptr
                  call getmem

                  ; use es:bp for sector array addressing
                  les bp,[si] ; create_partition_puffer_ptr

                  ; * clear buffer
                  mov di,bp
                  mov cx,7*512/4
                  sub eax,eax
                  cld
                  rep stosd

                  call init_crc32

                  mov eax,MemDiskBIOS_Info._anzahl_sektoren_je_spur
                  mul MemDiskBIOS_Info._anzahl_koepfe
                  mov cylinder_size,eax


                  ; max 2 GiB partition size
                  mov eax,07fffffffh
                  cdq
                  div MemDiskBIOS_Info._anzahl_sektoren_je_spur
                  cdq
                  div MemDiskBIOS_Info._anzahl_koepfe
                  mul MemDiskBIOS_Info._anzahl_koepfe
                  mul MemDiskBIOS_Info._anzahl_sektoren_je_spur

                  mov ebx,MemDiskBIOS_Info._anzahl_sektoren
                  cmp ebx,eax
                  if_a <mov ebx,eax>

                  ; begin partition at a new cylinder (1)
                  mov edx,cylinder_size
                  ; LVM likes starting cylinder 4 ?
first_memdisk_used_cylinder equ 4
first_memdisk_used_cylinder_log equ 2
                  shl edx,first_memdisk_used_cylinder_log

  have_partition_size:

                  ; edx=begin sector
                  ; ebx=end sector+1

                  cmp cfg_record.cfg_primaer_oder_logisch,1
                  je primary_only1

                  ; * MBR and partition table
                  lea si,[bp+Offset sekt_extpart]
                  call insert_dummy_bootsector_code
                  lea di,[si].Bootsector.partition1
                  mov es:[di].partition.boot_indicator,000h
                  call speichere_partition_ZKS
                  mov es:[di].partition.system_indicator,5      ; erweiterte partition
                  mov es:[di].partition.rel_sectors,edx
                  mov eax,ebx
                  sub eax,edx
                  mov es:[di].partition.num_sectors,eax
                  mov es:[si].Bootsector.ibm_sig,0aa55h         ; 55 aa

                  lea si,[bp+Offset sekt_extpartlvm]
                  call finish_LVM_infosector

                  ; a logical volume in an extended partition is one head later
                  add edx,MemDiskBIOS_Info._anzahl_sektoren_je_spur

  primary_only1:
                  ; * (E)MBR and (extended) partition table
                  lea si,[bp+Offset sekt_part]
                  call insert_dummy_bootsector_code
                  lea di,[si].Bootsector.partition1
                  mov es:[di].partition.boot_indicator,080h
                  call speichere_partition_ZKS
                  ;                                  ,1         ; FAT12,<32 MB allowed
                  mov es:[di].partition.system_indicator,6      ; FAT16 , > 32 M
                  ; old bootmanager inforamtion '--> LVM '
                  mov byte  ptr es:[si+018ah  ],1
                  mov dword ptr es:[si+018ah+1],' >--'
                  mov dword ptr es:[si+018ah+5],' MVL'

                  mov eax,edx                                   ; prim꼛: 4 Zylinder
                  cmp cfg_record.cfg_primaer_oder_logisch,1
                  if_ne <mov eax,MemDiskBIOS_Info._anzahl_sektoren_je_spur>       ; logisch: 1 Spur
                  mov es:[di].partition.rel_sectors,eax
                  mov eax,ebx
                  sub eax,edx
                  mov es:[di].partition.num_sectors,eax
                  mov es:[si].Bootsector.ibm_sig,0aa55h         ; 55 aa


                  ; * LVM sector
                  lea si,[bp+Offset sekt_partlvm]
                  lea di,[si].lvm_beschreibungstabelle_typ.tabelle
                  mov es:[di].lvm_partitionsbeschreibung_typ.Volume_Serial_Number,'VolS' ;0633b7788h
                  mov es:[di].lvm_partitionsbeschreibung_typ.Partition_Serial_Number,'ParS' ;099508cb1h
                  mov eax,dword ptr es:[bp+Offset sekt_part].Bootsector.partition1.partition.num_sectors
                  mov es:[di].lvm_partitionsbeschreibung_typ.Partition_Size,eax
                  mov es:[di].lvm_partitionsbeschreibung_typ.Partition_Start,edx
                  mov es:[di].lvm_partitionsbeschreibung_typ.On_Boot_Manager_Menu,1
                  mov es:[di].lvm_partitionsbeschreibung_typ.Installable,0
                  mov al,MemDiskBIOS_Info._lvm_letter
                  mov es:[di].lvm_partitionsbeschreibung_typ.Drive_Letter,al
                  push si
                  push di
                    mov si,Offset cfg_record.cfg_vol_name
                    lea di,[di].lvm_partitionsbeschreibung_typ.Volume_Name
                    mov cx,20
                    cld
                    rep movsb
                  pop di
                  pop si
                  push si
                  push di
                    mov si,Offset cfg_record.cfg_part_name
                    lea di,[di].lvm_partitionsbeschreibung_typ.Partition_Name
                    mov cx,20
                    cld
                    rep movsb
                  pop di
                  pop si

                  call finish_LVM_infosector

                  ; * boot sector
                  lea si,[bp+Offset sekt_boot]
                  call insert_dummy_bootsector_code
                  mov es:[si].Bootsector.bytes_per_sector,512
                  mov es:[si].Bootsector.reserved_sectors,1
                  mov es:[si].Bootsector.number_of_FATs,2
                  mov es:[si].Bootsector.root_directory_size,512
                  mov es:[si].Bootsector.media_descriptor_byte,0f8h     ; f8=hard disk fa=some ramdisk?
                  mov ax,word ptr MemDiskBIOS_Info._anzahl_sektoren_je_spur
                  mov es:[si].Bootsector.sectors_per_track,ax
                  mov ax,word ptr MemDiskBIOS_Info._anzahl_koepfe
                  mov es:[si].Bootsector.number_of_heads,ax
                  mov eax,edx                                   ; prim꼛: 4 Zylinder
                  cmp cfg_record.cfg_primaer_oder_logisch,1
                  if_ne <mov eax,MemDiskBIOS_Info._anzahl_sektoren_je_spur>       ; logisch: 1 Spur
                  mov es:[si].Bootsector.hidden_sectors,eax

                  mov es:[si].Bootsector.physical_drive_number,080h ;?
                  mov es:[si].Bootsector.driveletter,0                     ; used by OS/2 Chkdsk /Autocheck 1=dirty
                  mov es:[si].Bootsector.signature_byte,029h
                  mov es:[si].Bootsector.volume_serial_number,datum_bcd
                  mov dword ptr es:[si].Bootsector.volume_label+0,'DMEM'   ; MEMDISK(4+4+3)
                  mov dword ptr es:[si].Bootsector.volume_label+4,' KSI'
                  mov dword ptr es:[si].Bootsector.volume_label+7,'    '
                  mov dword ptr es:[si].Bootsector.fsname+0,' TAF'         ; FAT12
                  mov dword ptr es:[si].Bootsector.fsname+4,'    '
                  mov es:[si].Bootsector.ibm_sig,0aa55h                    ; 55 aa

                  mov eax,dword ptr es:[bp+Offset sekt_part].Bootsector.partition1.partition.num_sectors
                  mov es:[si].Bootsector.total_sectors_16,0

                  cmp eax,0ffffh
                  if_b <mov es:[si].Bootsector.total_sectors_16,ax>
                  mov es:[si].Bootsector.number_of_sectors_32,eax
                  dec eax ; boot sector
                  movzx edx,es:[si].Bootsector.root_directory_size
                  shr edx,4
                  sub eax,edx   ; ~~useable sectors (+FAT sectors)
                  mov cx,1      ; sectors per cluster

  check_number_of_cluster:
                  cmp eax,0fff0h
                  jbe found_cluster_size
                  shr eax,1     ; less clusters
                  shl cx,1      ; larger clusters
                  jmp check_number_of_cluster

  found_cluster_size:
                  mov es:[si].Bootsector.sectors_per_cluster,cl

                  cmp eax,00ff0h
                  ja create_FAT16

                  ; FAT12-> 3/2 byte
                  ; cx*(3/2)/512=cx*3/1024
                  mov cx,ax
                  add ax,cx
                  add ax,cx
                  add ax,3+1024-1 ; 3=2 cluster entry; round up
                  shr ax,10
                  mov es:[si].Bootsector.sectors_per_FAT,ax

                  ; * FAT 1/2
                  lea si,[bp+Offset sekt_fat]
                  mov byte ptr es:[si],0f8h ; media byte
                  mov word ptr es:[si+1],0ffffh
                  jmp continue_create_FAT
  create_FAT16:
                  ; FAT16-> 2 byte
                  ; eax*2/512
                  mov ecx,eax
                  add eax,ecx
                  add eax,4+512-1 ; 4=2 cluster entry; round up
                  shr eax,9
                  mov es:[si].Bootsector.sectors_per_FAT,ax

                  ; * FAT 1/2
                  lea si,[bp+Offset sekt_fat]
                  mov dword ptr es:[si],0fffffff8h ; media byte
                  jmp continue_create_FAT


  continue_create_FAT:

                  ; * root directory
                  lea si,[bp+Offset sekt_root]
                  mov dword ptr es:[si].fat_direntry.filenameext+0,'DMEM'       ; MEMDISK
                  mov dword ptr es:[si].fat_direntry.filenameext+4,' KSI'
                  mov dword ptr es:[si].fat_direntry.filenameext+7,'    '
                  mov es:[si].fat_direntry.attr,faVolumeID
                  mov es:[si].fat_direntry.datetime,((jahr-1980)*512+monat*32+tag)*010000h


                  ; write sectors...
                  mov ecx,0
                  cmp cfg_record.cfg_primaer_oder_logisch,1
                  je primary_only2

                  ; * MBR and partition table
                  lea bx,[bp+Offset sekt_extpart]               ; MBR
                  call write_memdisk_sector
                  push ecx

                    lea bx,[bp+Offset sekt_extpartlvm]          ; LVM
                    add ecx,MemDiskBIOS_Info._anzahl_sektoren_je_spur
                    dec ecx
                    call write_memdisk_sector

                  pop ecx
                  add ecx,dword ptr es:[bp+Offset sekt_extpart].Bootsector.partition1.partition.rel_sectors

  primary_only2:

                  lea bx,[bp+Offset sekt_part]                  ; MBR/EMBR
                  call write_memdisk_sector
                  push ecx

                    lea bx,[bp+Offset sekt_partlvm]             ; LVM
                    add ecx,MemDiskBIOS_Info._anzahl_sektoren_je_spur
                    dec ecx
                    mov [lvm_driveletter_change_sector],ecx
                    call write_memdisk_sector

                  pop ecx
                  add ecx,dword ptr es:[bp+Offset sekt_part].Bootsector.partition1.partition.rel_sectors

                  lea bx,[bp+Offset sekt_boot]                  ; boot
                  call write_memdisk_sector
                  mov [boot_sector_number],ecx

                  lea bx,[bp+Offset sekt_fat]                   ; FAT
                  inc ecx
                  call write_memdisk_sector                     ; FAT #1
                  movzx eax,byte ptr es:[bp+Offset sekt_boot].Bootsector.sectors_per_FAT
                  add ecx,eax
                  call write_memdisk_sector                     ; FAT #2
                  add ecx,eax

                  lea bx,[bp+Offset sekt_root]                  ; root
                  call write_memdisk_sector

                  call free_crc32

                  mov si,Offset create_partition_puffer_ptr
                  call freemem

                popad
                pop es
                ret
a_endp          create_partition

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

change_memdisk_drive_letter_puffer_ptr ptr1616 <>

a_proc          change_memdisk_drive_letter
                push es
                pushad

                  mov si,Offset change_memdisk_drive_letter_puffer_ptr
                  mov eax,512
                  call getmem
                  les bx,[si]

                  ; reload info sector
                  mov ecx,[lvm_driveletter_change_sector]
                  call read_memdisk_sector


                  ; change value and update crc32
                  mov al,MemDiskBIOS_Info._lvm_letter
                  mov es:[bx].lvm_beschreibungstabelle_typ.tabelle.lvm_partitionsbeschreibung_typ.Drive_Letter,al
                  mov si,bx
                  call finish_LVM_infosector ; es:si

                  ; store sector
                  mov ecx,[lvm_driveletter_change_sector]
                  call write_memdisk_sector

                  mov si,Offset change_memdisk_drive_letter_puffer_ptr
                  call freemem

                popad
                pop es
                ret
a_endp          change_memdisk_drive_letter

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

super_load_boot_begin:
                ; code for sector that looks like a FAT boot sector
                ; and has partition table at the same time
                ; because of that, usual FAT boot sector can not be used
                ; this code loads the bootsector from
                ; the 'partition' where the real bootsector code is placed.
                ; we can assume that no read error happends.
                ; we can assume that the only partition is our primary.
                ; we can assume that that partition is the first slot.

                sub ax,ax       ; setup stack, likely already set..
                mov ss,ax
                mov sp,07c00h

                mov ds,ax       ; source=we
                mov si,sp
                mov es,ax
                mov di,07e00h   ; target=+512
                mov cx,512/2
                rep movsw

                ; jump +512 bytes
                db 0e9h
                dw 512

                ; this will run at 7e00+xxx
                mov si,07e00h+Offset partition1

                mov ax,00201h
                mov bx,sp       ; 7c00
               ;mov es,es       ; 0000
                mov cx,[si].begin_CX
                mov dh,[si].begin_DH
               ;mov dl,dl       ; dl=physical drive
                int 013h


                ; enhanced DR DOS copies the hidden sector values from the boot sector,
                ; but it will search for the superfloppy. So it will fail loading DRDOS.SYS
                ; using an "Can't load DOS file." error halt message.

                cmp DWord Ptr es:[bx].oemname,'ODRD' ; 'DRDOS7.0'
                jne @@not_superfloppy_a_drdos

                ; trade hidden sectors for reserved sectors
                push ax
                  sub ax,ax
                  xchg word ptr es:[bx].hidden_sectors  ,ax
                  add  word ptr es:[bx].reserved_sectors,ax
                pop ax

  @@not_superfloppy_a_drdos:

                jmp bx          ; 7c00

super_load_boot_end:


a_proc          convert_to_superfloppy_if_needed
                push es
                pushad

                  cmp MemDiskBIOS_Info._lvm_letter,'C'    ; superfloppy mode?
                  jae exit_convert_to_superfloppy_if_needed     ; no, exit


                  ; read bootsector, setup some 'reserved' sectors and overwrite the MBR
                  mov si,Offset change_memdisk_drive_letter_puffer_ptr
                  mov eax,2*512
                  call getmem
                  les bx,[si]

                  ; read mbr
                  sub ecx,ecx
                  call read_memdisk_sector

                  ; read boot sector
                  push bx

                  add bx,512
                  mov ecx,[boot_sector_number]
                  call read_memdisk_sector
                  ; hide sectors before partition
                  add es:[bx].reserved_sectors,cx
                  add es:[bx].number_of_sectors_32,ecx
                  sub es:[bx].hidden_sectors,ecx

                  pop bx

                  ; produce new JMP code: jmp 7c3e
                  mov Word Ptr es:[bx].jmp0, 03eebh-00200h
                  mov Byte Ptr es:[bx+2].jmp0, 090h

                  ; copy oemname+BPB
                  lea di,[bx].oemname
                  mov cx,03eh-3
  copy_superfloppy_bpb:
                  mov al,es:[di+512]
                  mov es:[di],al
                  inc di
                  loop copy_superfloppy_bpb

                  ; paste our code
                  mov si,Offset super_load_boot_begin
                 ;mov di,di
                  mov cx,Offset super_load_boot_end-Offset super_load_boot_begin
                  cld
                  rep movsb

                  ; store sector in place of MBR
                  sub ecx,ecx
                  call write_memdisk_sector

                  mov si,Offset change_memdisk_drive_letter_puffer_ptr
                  call freemem

  exit_convert_to_superfloppy_if_needed:

                popad
                pop es
                ret
a_endp          convert_to_superfloppy_if_needed

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

disk_ap         disk_address_packet <010h,0,1,0,0>

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

MemDisk_sector_read_error0 db msg_MemDisk_sector_read_error0,0
MemDisk_sector_read_error1 db msg_MemDisk_sector_read_error1,13,10,0


                ; es:bx=@sector
                ; ecx=sector number
                ; ax=number of sectors
a_proc          read_memdisk_sectors
                pushad

                  mov si,Offset disk_ap
                  mov [si].number_of_blocks_to_transfer,ax
                  mov word ptr [si].transfer_buffer+0,bx
                  mov word ptr [si].transfer_buffer+2,es
                  mov dword ptr [si].starting_block_number+0,ecx
                  mov dword ptr [si].starting_block_number+4,0

                  mov ax,04200h
                 ;mov si,si
                  mov dl,[drive_number]
                  pushf
                  push cs
                  call short_entrypoint_memorydisk_int13
                  jnc exit_read_memdisk_sectors

                  mov [i13_errorcode],ah

                  mov al,error_TextAttr
                  xchg [TextAttr],al
                  mov si,Offset MemDisk_sector_read_error0
                  call ausschrift
                  call ausschrift_errorcode
                  mov [TextAttr],al
                  push Offset MemDisk_sector_read_error1        ; end of sentence
                  jmp trap_proc

  exit_read_memdisk_sectors:

                popad
                ret
a_endp          read_memdisk_sectors

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

MemDisk_sector_write_error0 db msg_MemDisk_sector_write_error0,0
MemDisk_sector_write_error1 db msg_MemDisk_sector_write_error1,13,10,0


                ; es:bx=@sector
                ; ecx=sector number
                ; ax=number of sectors
a_proc          write_memdisk_sectors
                pushad

                  mov si,Offset disk_ap
                  mov [si].number_of_blocks_to_transfer,ax
                  mov word ptr [si].transfer_buffer+0,bx
                  mov word ptr [si].transfer_buffer+2,es
                  mov dword ptr [si].starting_block_number+0,ecx
                  mov dword ptr [si].starting_block_number+4,0

                  mov ax,04300h
                 ;mov si,si
                  mov dl,[drive_number]
                  pushf
                  push cs
                  call short_entrypoint_memorydisk_int13
                  jnc exit_write_memdisk_sectors

                  mov [i13_errorcode],ah

                  mov al,error_TextAttr
                  xchg [TextAttr],al
                  mov si,Offset MemDisk_sector_write_error0
                  call ausschrift
                  call ausschrift_errorcode
                  mov [TextAttr],al
                  push Offset MemDisk_sector_write_error1       ; end of sentence
                  jmp trap_proc

  exit_write_memdisk_sectors:

                popad
                ret
a_endp          write_memdisk_sectors

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          read_memdisk_sector
                push ax
                  mov ax,1
                  call read_memdisk_sectors
                pop ax
                ret
a_endp          read_memdisk_sector

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; es:bx,cx,1
a_proc          write_memdisk_sector
                push ax
                  mov ax,1
                  call write_memdisk_sectors
                pop ax
                ret
a_endp          write_memdisk_sector

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
