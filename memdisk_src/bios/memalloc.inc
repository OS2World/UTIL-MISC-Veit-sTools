Title           Memdisk main install caller

; reserve memory disk
; using 1 KB memory (640-1)
; Veit Kannegieser 2001.12.30

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                db (16-(($-anfang_org) and 0000fh)) dup (0cch)
code_ende:

speicherbedarf  = (Offset code_ende-Offset anfang_org)
num_kb          equ (speicherbedarf+1023)/1024

;栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢栢


IFDEF dos
meldung_titel           db msg_title_dos,datum,13,10,0
ELSE
meldung_titel           db msg_title_bios,datum,13,10,0
ENDIF

message_bootdrive_floppyharddisk db msg_bootdrive_floppyharddisk,0
message_bootdrive_cdnoemu        db msg_bootdrive_cdnoemu,0
message_bootdrive2               db msg_bootdrive2,13,10,0

meldung_0x_installiert1         db msg_Disk_0x_installed_1,0
meldung_8x_installiert1         db msg_Disk_8x_installed_1,0
meldung_xx_installiert2         db ' / ',0
meldung_0x_installiert3         db msg_Disk_0x_installed_3,13,10,0
meldung_8x_installiert3         db msg_Disk_8x_installed_3,13,10,0


boot_drive                      db ?
source_is_noemulation_mode_cd   db false
boot_sector_rel                 dd ?

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          einrichten
                db 10 dup (090h)                ; patch area

IFDEF bios
                ; save drive letter and partition start
               ;mov dl,dl    ; value passed by cdloader
                sub eax,eax  ; relative sector (ignored for CD ROM)
               ;mov bx,bx    ; @p_cd_boot_directory passed by cdloader

                cmp si,-1    ; CDLOADER can not present a valid BPB
                je bpb_invalid
                cmp byte ptr ds:[si-bytes_per_sector].signature_byte,028h ; hpfs
                jb bpb_invalid
                cmp byte ptr ds:[si-bytes_per_sector].signature_byte,029h ; fat
                ja bpb_invalid

                mov dl,byte ptr ds:[si-bytes_per_sector].physical_drive_number
                mov eax,dword ptr ds:[si-bytes_per_sector].hidden_sectors
                sub bx,bx                       ; set @p_cd_boot_directory invalid
bpb_invalid:
                push eax                        ; eax=relative sector
                push bx                         ; bx=@p_cd_boot_directory, if callded by cdloader
                push dx                         ; dl=drive letter

                ; avoid DMA wrap around
                mov ax,cs
                mov ds,ax
                add ax,00fffh
                and ax,0f000h
                mov es,ax
                call pop_si
pop_si:
                pop si
                sub si,(Offset pop_si)-(Offset anfang_org)
                mov di,Offset anfang_org
                mov cx,((Offset initialized_data_end)-(Offset anfang_org)+3)/4
                cld
                rep movsd
                push es
                push Offset continue_dma_align
                retf

  continue_dma_align:

                pop dx
                pop bx
                pop eax

ELSE            ; dos

                mov dl,0                ; A:
                sub eax,eax             ; no partition
                sub bx,bx               ; no @p_cd_boot_directory

; my DOS partition
; db 0cch
 mov dl,080h
 mov eax,01844e2h

; my test partition
; mov dl,080h
; mov eax,29366820+63


; test track...
; mov dl,090h    ; SystemSoft
; mov dl,09fh    ; Award

  mov cfg_record.cfg_el_torito_abschalten,0

ENDIF           ; bios

                mov cs:[boot_drive],dl
                mov cs:[boot_sector_rel],eax

                mov ax,cs
                cli
                mov ss,ax
                mov sp,Offset stack+Size stack
                sti

                call flush_keyboard

IFDEF ScrewDrv
                call load_ScrewDrv
ENDIF

                push cs
                pop ds
                push cs
                pop es

                ; cloader is at 0000:7c00..0000..8400
                push ds
                  push 0
                  pop ds

                  mov si,bx
                  mov di,Offset p_cd_boot_directory
                  cmp si,07c00h
                  jbe no_p_cd_boot_directory_passed
                  cmp si,07c00h+2048
                  jae no_p_cd_boot_directory_passed

                  ; minimum length=0 in the root directory
                  ; maxmimum length=full buffer
                  cmp Byte Ptr [si],cd_boot_directory_max_len
                  ja no_p_cd_boot_directory_passed

                  cld      ; copy to our location of p_cd_boot_directory
                  mov cx,cd_boot_directory_max_len+1
                  rep movsb

  no_p_cd_boot_directory_passed:

                pop ds

                call install_exception_handler
                ; test:  db 00fh,00bh

                call install_irq_filters

                STEP 'TRHK'

                ; translate config entry

                mov eax,16*1024*1024
                cmp cfg_record.cfg_os2_min_memory,eax
                if_b <mov cfg_record.cfg_os2_min_memory,eax>

                mov al,cfg_record.cfg_lvm_letter
                mov MemDiskBIOS_Info._lvm_letter,al

                mov al,cfg_record.cfg_debugoption
                mov debugoption,al

                mov al,cfg_record.cfg_a20_access
                mov a20_access,al

                mov al,cs:[cfg_record.cfg_start_disk]
                mov ah,key_boot_harddisk
                cmp al,'H'
                je found_menu_selection
                mov ah,key_boot_memdisk
                cmp al,'M'
                je found_menu_selection
                mov ah,key_boot_floppy
                cmp al,'F'
                je found_menu_selection
                mov ah,'*'
  found_menu_selection:
                mov cs:[start_disk],ah

IFDEF serial_debug
                call init_com2
ENDIF           ; serial_debug

                mov si,Offset meldung_titel
                call ausschrift

                STEP 'CPAL'
                call modify_palette

IFNDEF language_en
                STEP 'KBDH'
                call tastatur_umbelegung_einhaengen
ENDIF ; -language_en

                STEP 'SCHK'

                cmp cfg_record.cfg_version,my_cfg_version
                if_e <cmp selbsttest,datum_bcd>
                if_ne <trap msg_MEMBOOT_BIN_corrupted_fragmented>

                STEP 'MEMI'

                call init_memorymanager


IFNDEF dos
                STEP 'PRES'
                push ds

                mov ax,0ff00h
                mov ebx,'MEM_'
                mov ecx,'DISK'
                stc
                int 015h
                jc memdisk_not_present
                cmp ax,0ff00h
                je memdisk_not_present
                mov ds,ax
                cmp word ptr [anfang_org],0aa55h
                jne memdisk_not_present
                cmp byte ptr [anfang_org+3],0cbh        ; retf
                jne memdisk_not_present
                trap msg_already_present_SCAD
  memdisk_not_present:

                pop ds
ENDIF


                STEP 'EMU1'

                ; no emulation boot type ?
                mov si,Offset message_bootdrive_floppyharddisk
                call query_cd_emulation_type
                jnz not_no_emulation_type        ; no answer->no

                mov al,specification_packet.cdrom_boot_media_type
                and al,00fh
                cmp al,cdrom_mediatype_no_emu
                jne not_no_emulation_type

                mov source_is_noemulation_mode_cd,true
                mov si,Offset message_bootdrive_cdnoemu

  not_no_emulation_type:

                STEP 'EMU2'

                call ausschrift
                mov al,boot_drive
                call ausschrift_al_hex
                mov si,Offset message_bootdrive2
                call ausschrift

                ; shift+F10 => try to update memdisk
                STEP 'CKUP'
                mov ah,011h
                int 016h
                jz not_update_hotkey_before_menu ; no keypress
                cmp ax,05d00h
                jne not_update_hotkey_before_menu ; wrong keypress
                call tastendruck                ; eat keypress
                call update_memdisk
  not_update_hotkey_before_menu:

                cmp cfg_record.cfg_load_font,false
                je not_load_font
                STEP 'FONT'
                call generate_font_filename
                call load_vga_font_file
  not_load_font:

                ; present menu ?
                cmp cfg_record.cfg_show_ecs_cd_menu,0
                je no_ecs_cd_menu

                STEP 'MENU'
                call do_ecs_cd_menu

  no_ecs_cd_menu:

                STEP 'LVML'
                call avoid_drive_letter_conflicts

                STEP 'MSIZ'

                ; redundant information in table..
                ; re-calculate number of sectors
                mov eax,MemDiskBIOS_Info._anzahl_zylinder
                mul MemDiskBIOS_Info._anzahl_koepfe
                mul MemDiskBIOS_Info._anzahl_sektoren_je_spur
                mov MemDiskBIOS_Info._anzahl_sektoren,eax


IFDEF dos
                call allocate_xms_memory
ELSE
                ; previously placed ROM header at begin, but now
                ; there is 1 KiB interrupt table copy.
                ; configuration header moved, so check is not useable anyway
               ;; wird vom OS/2 MEMDISK.ADD gesucht
               ;mov word ptr [anfang_org],0aa55h
               ;mov byte ptr [anfang_org+2],2*num_kb    ; in 512 Byte pages
               ;mov byte ptr [anfang_org+3],0cbh        ; retf
                call detect_memory_size
                call detect_abios
                call setup_a20_access
ENDIF
                ; temporary number
                mov drive_number,'M'

IFDEF verify_memory

                test cs:[debugoption],debugoption_memtest
                jz no_verify_memory
                STEP 'VERY'
                call verify_disk_memory
  no_verify_memory:

ENDIF ; verify_memory
                STEP 'FORM'
                call format_disk
                STEP 'CREA'
                call create_partition
                STEP 'LOAD'
                call load_and_unpack_files

                STEP 'CDR0'

                cmp cfg_record.cfg_el_torito_abschalten,true
                ; throw away bios handler for CD ROM
                if_e <call terminate_cdrom_emulation>

                STEP 'UPDT'

                call process_updates


                cmp cfg_record.cfg_call_os2csm_bin,true
                jne no_os2csm_bin_call
                STEP 'CSMC'
                call call_os2csm
  no_os2csm_bin_call:

                cmp [cfg_record.cfg_edit_config_sys],true
                jne no_edit_config_sys_call
                STEP 'EDIT'
                push di
                  mov di,Offset file_CONFIG_SYS
                  call edit_textfile
                pop di
  no_edit_config_sys_call:

                STEP 'SFLO'
                call convert_to_superfloppy_if_needed


                STEP 'DRVN'

                ; real number (previously 'M')
                call detect_drivenumber

                STEP 'M639'
                call move_639
IFDEF dos

                ; es=$9fc0
                call install_int_13
ELSE
                ; es=$9fc0
                STEP 'XCPT'
                ; install exception handlers high
                call remove_exception_handler
                call install_exception_handler
                STEP 'I$13'
                call install_int_13
                STEP 'I$15'
IFNDEF language_en
                call tastatur_umbelegung_entfernen
ENDIF ; -language_en
                call install_int_15
                STEP 'I_FB'
                call uninstall_irq_filters
IFDEF fastboot_function
                call install_fastboot
ENDIF ; fastboot_function
                call install_irq_filters
IFNDEF language_en
                call tastatur_umbelegung_einhaengen
ENDIF ; -language_en
ENDIF ; - dos

                mov al,[drive_number]
                mov si,Offset meldung_0x_installiert1
                test al,080h
                if_nz <mov si,Offset meldung_8x_installiert1>
                call ausschrift
                call ausschrift_al_hex
                mov si,Offset meldung_xx_installiert2
                call ausschrift
                mov al,MemDiskBIOS_Info._lvm_letter
                call ausschrift_zeichen
                mov si,Offset meldung_0x_installiert3
                test al,080h
                if_nz <mov si,Offset meldung_8x_installiert3>
                call ausschrift

                STEP 'RPAL'
                call restore_palette

                ; place Alt+F2 or other keys as returned by OS2CSM into the keyboard buffer
                mov ah,005h
                mov cx,putkey_after_configsys_edit
                cmp cx,0ffffh
                if_ne <int 016h>

                STEP 'UIRQ'
                call uninstall_irq_filters

IFNDEF language_en
                STEP 'UKBD'
                call tastatur_umbelegung_entfernen
ENDIF ; -language_en
IFDEF dos
                STEP 'EXIT'
                mov ax,04c00h
                int 021h
ELSE
  IFDEF fastboot_function
                push es
                push Offset disk_boot
                retf
  ELSE
                jmp disk_boot
  ENDIF
ENDIF ; - dos

a_endp          einrichten

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF dos
                include xms.inc
ELSE
                include int15a.inc
ENDIF ; -dos
                include int15d.inc
                include creageom.inc

IFNDEF fastboot_function
                include boot.inc
                include uninstal.inc
ENDIF ; - fastboot_function


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴



IFNDEF dos
                include fastboo2.inc
ENDIF

a_proc          move_639
                pusha

IFDEF dos
                  mov ax,05800h ; Speichersuche sichern
                  int 021h
                  push ax

                    mov ax,05802h ; UMB-Verkettung sichern
                    int 021h
                    mov ah,0
                    push ax

                      mov ax,05801h ; Speichersuche auf letzten UMB setzen
                      mov bx,00082h
                      int 021h
                      mov ax,05803h ; UMB verf갾bar
                      mov al,1
                      int 021h

                      mov ah,048h
                      mov bx,(speicherbedarf+15)/16
                      int 021h
                      jnc speicher_angefordert

                      fehler_halt msg_DOS_memory_allocation_failed

  speicher_angefordert:
                      push ax
                        dec ax      ; zum MCB
                        mov es,ax
                        mov ax,'DR'
                        int 021h
                        mov ax,6 ; DR DOS XMS UMB
                        jnc drdos_umb
                        mov ax,8 ; System
  drdos_umb:
                        mov es:[0].mcb.mcb_eigentuemer_mcb,ax
                        ; 'MEMDISK',0
                        mov dword ptr es:[0+0].mcb.mcb_name,'DMEM'
                        mov dword ptr es:[0+4].mcb.mcb_name,'KSI'
                      pop ax

                      sub ax,010h ; kein PSP
                      mov es,ax

                    pop bx
                    mov ax,05803h ; UMB-Verkettung restaurieren
                    int 021h


                  pop bx
                  mov ax,05801h ; Speichersuche restaurieren
                  int 021h

ELSE
                  push bios0040
                  pop es
                  mov si,number_of_KB
                  sub Word Ptr es:[si],num_kb
                  mov ax,es:[si]
                  shl ax,6 ; 1024/16=1 shl 6

                  mov es,ax
ENDIF

                  mov si,Offset anfang_org
                  mov di,si
                  mov cx,(speicherbedarf+1)/2
                  cld
                  rep movsw

IFNDEF dos
                  mov ax,0cccch
                  mov cx,((num_kb*1024)/2)-((speicherbedarf+1)/2)
                  rep stosw
ENDIF

                popa
                ret
a_endp          move_639

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF dos

                ; es=640KiB-X
a_proc          install_int_15
                push si
                push dx

                  mov dx,Offset int15handler
                  mov si,Offset orgint15
                  call install_int

                pop dx
                pop si
                ret
a_endp          install_int_15

ENDIF           ; nicht dos

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          install_int_13
                pusha
                push ds

                  mov dx,Offset int13handler
                  mov si,Offset orgint13
                  call install_int

                  push bios0040
                  pop ds

                  mov al,es:[my_harddisk_count_inc]
                  add byte ptr ds:[harddisk_count],al

                  cmp es:[drive_number],0
                  if_e <call unhide_our_floppy>

                pop ds
                popa
                ret
a_endp          install_int_13

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          detect_drivenumber
                push dx
                  cmp MemDiskBIOS_Info._lvm_letter,'C'
                  jae detect_drivenumber_harddisk_c_z

                  ; take over 'A:' drive letter , move original A: to B: etc...
                  mov [drive_number],0
                  mov [my_harddisk_count_inc],0
                  call bestimme_anzahl_diskettenlaufwerke_dl
                  cmp dl,4
                  jae keine_freie_laufwerksnummer_gefunden
                  jmp freie_laufwerksnummer_gefunden

  detect_drivenumber_harddisk_c_z:
                  call bestimme_anzahl_festplatten_dl
                  add dl,080h ; 2 Platte -> 3.=082
                  mov [drive_number],dl
                  mov [my_harddisk_count_inc],1

                  cmp dl,0ffh
                  jb freie_laufwerksnummer_gefunden

  keine_freie_laufwerksnummer_gefunden:
                  fehler_halt msg_No_free_harddisk_drive_number

  freie_laufwerksnummer_gefunden:
                pop dx
                ret
a_endp          detect_drivenumber

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

