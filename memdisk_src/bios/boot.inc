Title           Ask+execute where to continue (fast-)booting

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

frage_harddisk_or_memdisk       db msg_frage_harddisk_or_memdisk,0
meldung_Lesefehler              db msg_meldung_Lesefehler,13,10,0
meldung_no_bootable_partition   db msg_meldung_no_bootable_partition,13,10,0
meldung_bootsector_invalid      db msg_meldung_bootsector_invalid,13,10,0

start_disk      db ?


a_proc          disk_boot

                STEP 'CLEM'
IFDEF fastboot_function
                ; clean memory 70:0..9e80:0
                int 012h
                mov bx,ax                       ; 634
                shl bx,6                        ; $9E80
ELSE
                ; clean memory 70:0..1000:0
                mov bx,cs
ENDIF
                mov dx,0070h
                sub ax,ax
                cld
  @@loesche_speicher_schleife:
                mov es,dx
                sub di,di
                mov cx,16/2
                rep stosw
                inc dx
                cmp dx,bx
                jne @@loesche_speicher_schleife

                push cs
                pop es

IFNDEF dos

                STEP 'HMAC'                      ; clear begin of HMA

                ; disable A20 for compatibility
                STEP 'A20D'
                call disable_a20

                ; could disable all speed tricks here
                ;-mov cs:[a20_access],a20_access_BIOS

                ; assume that memory at 9000:0 is zeroed
                mov eax,000090000h
                mov si,Offset Source_Desc
                call set_descriptor_base

                ; hma
                mov eax,000100000h
                mov si,Offset Target_Desc
                call set_descriptor_base

                push cs
                pop es
                mov si,Offset EXT_GDT
                mov cx,32/2
                call int_15_87
ENDIF   ; -DOS

                STEP 'LBOO'

                push cs
                pop ds
                push 0
                pop es
                mov al,start_disk
                jmp @@try_boot_selection

  @@fehlermeldung_ask_bootdisk:
                call ausschrift
  @@ask_bootdisk:
                mov si,Offset frage_harddisk_or_memdisk
                call ausschrift

                call tastendruck_lowercase
                call ausschrift_zeichen
                call ausschrift_zeichen_CRLF

  @@try_boot_selection:
                call lowercase
                mov cx,1                                ; MBR (cylinder 0,sector 1)

                sub si,si                               ; use boot sector
                sub dx,dx                               ; head 0, floppy 0
                cmp al,key_boot_floppy
                je @@boot_disk

                mov dl,080h                             ; head 0, HD 0
                cmp al,key_boot_harddisk
                je @@boot_disk

                mov dl,ds:[drive_number]
               ;test dl,080h
               ;if_nz <inc si>                          ; bypass MBR, but not in superfloppy mode
                test dl,dl
                if_s <inc si>                           ; bypass MBR, but not in superfloppy mode
                cmp al,key_boot_memdisk
                je @@boot_disk

                cmp al,key_uninstall
                if_e <call uninstall>
                jmp @@ask_bootdisk

  @@boot_disk:

                ; si=0: expect boot sector
                ; si=1: expect partition table sector

                mov ax,0201h                            ; 1 sector
                mov bx,07c00h
               ;mov ch,ch                               ; cylinder
               ;mov cl,cl                               ; sector
               ;mov dl,dl                               ; drive
               ;mov dh,dh                               ; head
               ;mov es,es                               ; 0:

                STEP 'BOOR'
                mov bp,10
                jmp @@schleife_startsektor_laden_eintritt

  @@schleife_startsektor_laden:
                dec bp
                jnz @@schleife_startsektor_laden_reset

                mov si,Offset meldung_Lesefehler
                jmp @@fehlermeldung_ask_bootdisk

  @@schleife_startsektor_laden_reset:
                pusha
                  mov ah,0
                  int 013h
                popa

  @@schleife_startsektor_laden_eintritt:
                pusha
                  int 013h
                  test ah,ah
                popa
                jnz @@schleife_startsektor_laden


                ; erfolgreich geladen
                test si,si
                jz @@use_bootsector

                add bx,Offset Bootsector.partition1
                mov cx,4
                sub ax,ax                       ; no extended partition

  @@search_boot_partition:

                cmp es:[bx].partition.boot_indicator,080h
                je @@found_boot_partition
                ; since we created the partition table structure only for memdisk
                ; but we also read harddisk, we need to check full range of extended
                ; partition table types here.
                cmp es:[bx].partition.system_indicator,005h ; Extended partition
                je @@have_seen_extended_partition
                cmp es:[bx].partition.system_indicator,00fh ; reinvented by MS
                je @@have_seen_extended_partition
                cmp es:[bx].partition.system_indicator,015h ; hidden??
                je @@have_seen_extended_partition
                cmp es:[bx].partition.system_indicator,085h ; stupid linux
               ;je @@have_seen_extended_partition
                jne @@is_not_an_extended_partition
  @@have_seen_extended_partition:
                ; remember in ax
                mov ax,bx
  @@is_not_an_extended_partition:
                add bx,Size partition
                loop @@search_boot_partition

                ; seen extended partition?
                test ax,ax
                mov si,Offset meldung_no_bootable_partition
                jz @@fehlermeldung_ask_bootdisk

                ; load extended partition and process it like an MBR
                mov bx,ax
                mov dh,es:[bx].partition_entry.begin_DH ; .begin_head
                mov cx,es:[bx].partition_entry.begin_CX ; .begin_sector/.begin_cylinder
                mov si,1                                ; handle as MBR
                jmp @@boot_disk

  @@found_boot_partition:
                mov dh,es:[bx].partition_entry.begin_DH ; .begin_head
                mov cx,es:[bx].partition_entry.begin_CX ; .begin_sector/.begin_cylinder
                sub si,si                       ; we now load the boot sector
                jmp @@boot_disk

  @@use_bootsector:
                cmp word ptr es:[bx].ibm_sig,0aa55h
                mov si,Offset meldung_bootsector_invalid
                jne @@fehlermeldung_ask_bootdisk

                ; bootsector valid, check more..
                mov al,byte ptr es:[bx].signature_byte
                cmp al,028h ; HPFS
                je @@extended_bpb
                cmp al,029h ; FAT
                jne @@no_extended_bpb
  @@extended_bpb:
                ; store number of hidden sectors
                call ZKS_zu_Sektornummer
                mov dword ptr es:[bx].hidden_sectors,ebp

                ; if it is the MemDisk media, then store drive letter
                mov al,ds:MemDiskBIOS_Info._lvm_letter
                sub al,'C'
                jae @@set_drive_letter_c_z
                add al,2                        ; 00=A 01=B
                jmp @@set_drive_letter_continue
  @@set_drive_letter_c_z:
                or al,080h                      ; 80=C 81=D ...
  @@set_drive_letter_continue:
                cmp dl,ds:[drive_number]
                jne @@not_memdisk_drive_letter

                mov byte ptr es:[bx].driveletter,al

  @@not_memdisk_drive_letter:

                ; physical drive
                mov byte ptr es:[bx].physical_drive_number,dl

  @@no_extended_bpb:

                ; no I13X
                push 03000h
                pop fs
                sub di,di
                mov cx,8+Size disk_address_packet
    @@clear_i13x:
                mov byte ptr fs:[di],0
                inc di
                loop @@clear_i13x
                mov fs:[8].disk_address_packet.disk_address_packet_size,Size disk_address_packet

                ; check if really no I13X
                pusha

                  cmp dword ptr es:[bx+3],'RAPV'; VPart has limited (20020316) support for "I13X"
                  je @@no_i13x_for_this_drive   ; but bootmanager needs full support

                  mov ah,041h
                  mov bx,055aah
                  push fs
                  push es
                  push 0f000h ; \ddk\DASD\IBM\IBM1S506\s506i13.c "phoexnis bios bug"
                  pop es
                  stc
                  int 013h                      ; no error ?
                  pop es
                  pop fs
                  jc @@no_i13x_for_this_drive

                  cmp bx,0aa55h                 ; supported ?
                  jne @@no_i13x_for_this_drive

                  cmp ah,021h                   ; version 2.1+
                  jb @@no_i13x_for_this_drive

                  test cl,1                     ; functions present ?
                  jz @@no_i13x_for_this_drive

                  ; 3000:0
                  mov fs:[di],'X31I'

  @@no_i13x_for_this_drive:

                popa

                STEP '7C00'

                push es                         ; 0
                pop ds
                push ds
                pop fs
                push ds
                pop gs
                mov eax,00201h
                movzx ebx,bx                    ; 07c00h
                sub si,si
                cli
                mov ss,si
                mov esp,ebx
                sti
                mov ebp,esp
                mov esi,ebx
                mov edi,ebx
                push es
                push bx
                retf                            ; 0:7c00
a_endp          disk_boot

