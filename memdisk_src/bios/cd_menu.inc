Title   show eCS CD Menu

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

os2csm_mode_                            db 1 ; for icmd: ; 0=hidden 1=normal

;message_function_not_implemented       db msg_function_not_implemented
control_ClrScr07                        db colour,0007h,cls,0
message_bootsector_read_error           db msg_bootsector_read_error
message_bootsector_invalid_format       db msg_bootsector_invalid_format

filename_readme_txt                     file83 <'README  ','TXT'>

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          flush_keyboard
                pusha
  clear_next_key_in_queue:
                  mov ah,011h
                  int 016h
                  jz no_key_left_in_queue
                  call tastendruck
                  jmp clear_next_key_in_queue
  no_key_left_in_queue:
                popa
                ret
a_endp          flush_keyboard

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

mbr_ptr         ptr1616 <0,0>

                ; CF=0:harddisk is bootable
a_proc          harddisk_bootable_test
                push es
                pushad

                  mov eax,02048
                  mov si,Offset mbr_ptr
                  call getmem

                  mov ah,012h
                  int 016h
                  test al,010h          ; scroll lock active?
                  clc
                  jnz exit_harddisk_bootable_test ; yes, force assume bootable


                  ; in cd-boot, does CD-ROM drive uses harddisk drive number (error)
                  cmp [source_is_noemulation_mode_cd],true
                  jne no_drive_80_conflict
                  cmp [boot_drive],080h         ; can not use harddisk in this problematic situation
                  stc
                  je exit_harddisk_bootable_test_fail ; unbootable

  no_drive_80_conflict:

                  ; read MBR of first HD 080h
                  mov ax,00201h
                  mov cx,00001h
                  mov dx,00080h
                  les bx,[mbr_ptr]
                  call int_13
                  jc exit_harddisk_bootable_test ; not even readable?

                  ; bad boot code?
                  mov eax,DWord Ptr es:[bx]
                  test eax,eax
                  jz exit_harddisk_bootable_test_fail
                  cmp eax,-1
                  je exit_harddisk_bootable_test_fail
                  cmp eax,0f6f6f6f6h
                  je exit_harddisk_bootable_test_fail

                  call MBR_has_startable_partition
                  jnc exit_harddisk_bootable_test ; have found bootable entry

                  ; IBM MBR boot code starts Bootmanager from second HD if available

                  ; read MBR of second HD 081h
                  mov ax,00201h
                  mov cx,00001h
                  mov dx,00081h
                  les bx,[mbr_ptr]
                  call int_13
                  jc exit_harddisk_bootable_test ; not even readable?

                  call MBR_has_startable_partition
                  jmp exit_harddisk_bootable_test ; pass CF

  exit_harddisk_bootable_test_fail:
                  stc

  exit_harddisk_bootable_test:

                  pushf
                    mov si,Offset mbr_ptr
                    call freemem
                  popf

                popad
                pop es
                ret
a_endp          harddisk_bootable_test

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          MBR_has_startable_partition
                pusha

                  ; partition table invalid?
                  cmp es:[bx].ibm_sig,0aa55h
                  stc
                  jne exit_MBR_has_startable_partition

                  ; valid. check all 4 entries
                  mov cx,4
                  lea si,[bx].partition1

  loop_MBR_has_startable_partition:

                  ; indicated partition to boot from?
                  test es:[si].boot_indicator,080h
                  clc
                  jnz exit_MBR_has_startable_partition

                  ; bootmanager? - assume smart(newer) boot code
                  cmp es:[si].system_indicator,00ah
                  clc
                  je exit_MBR_has_startable_partition

                  ; next entry..
                  add si,Size partition_entry
                  loop loop_MBR_has_startable_partition

                  ; nothing - unbootable
                  stc

  exit_MBR_has_startable_partition:

                popa
                ret
a_endp          MBR_has_startable_partition

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ;            11
                ;   12345678901
ecs_cdtitel     db "eComstation",0

a_proc          do_ecs_cd_menu
                push es
                pushad

                  ; check for unformated/unbootable HD
                  ; can skip first level menu in that case
                  call harddisk_bootable_test
                  ; display second level menu (if enabled)
                  jc show_menu2

                  ; set default to CD-ROM, if configured ('5'/'6')
IFDEF os2boot_ac_code
                  test                show_ecs_cd_menu,4
ELSE
                  test cfg_record.cfg_show_ecs_cd_menu,4
ENDIF
                  jz not_menu1_default2

                  mov si,Offset menu1

                  ; set messages to 'boot from CD in 20 seconds'
                  mov [si].mn_menu_time_20_msg1,Offset menu1b_time20_msg1
                  mov [si].mn_menu_time_20_msg2,Offset menu1b_time20_msg2
                  mov [si].mn_menu_time_1_msg1 ,Offset menu1b_time1_msg1
                  mov [si].mn_menu_time_1_msg2 ,Offset menu1b_time1_msg2
                  mov [si].mn_menu_stop_msg1   ,Offset menu1b_stop_msg1
                  mov [si].mn_menu_stop_msg2   ,Offset menu1b_stop_msg2

                  ; set menu default to boot from CD
                  mov [si].mn_default,2

  not_menu1_default2:

                  ; alter OS name in menu, but keep if default eComstation
                  ; or if begins with 'eCS '

IFDEF os2boot_ac_code
                  mov si,Offset ecs_cdtitel
ELSE
                  mov si,Offset cfg_record.cfg_vol_name
ENDIF
                  sub di,di

                  ; default value in begin.inc:
                  ;   db 'Startup Volume',0,0,0,0,0,0
                  cmp DWord Ptr [si],'ratS'
                  jne not_vol_name_startup_volume
                  cmp DWord Ptr [si+4],' put'
                  jne not_vol_name_startup_volume
                  cmp DWord Ptr [si+8],'uloV'
                  je skip_menu_label_change
  not_vol_name_startup_volume:
                  ; eCS value: $VolName_$=eCS Memory Boot-Disk
                  mov eax,DWord Ptr [si]
                  and eax,0dfdfdfdfh            ; upcase
                  cmp eax, 'SCE'                ; 'ECS '
                  je skip_menu_label_change

                  mov cx,11                     ; L꼗ge von 'eComStation'
                  cld
  menu_label_change_loop:
                  lodsb
                  cmp al,' '
                  if_b <mov al,' '>
                  mov Byte Ptr eComStation[di],al
                  mov Byte Ptr ecs_cdtitel[di],al

                  inc di
                  loop menu_label_change_loop

                  ; remove blanks from messages, example: 'DRDOS      '
  loop_ecs_cdtitel:
                  test di,di
                  jz done_ecs_cdtitel
                  dec di
                  cmp ecs_cdtitel[di],' '
                  jne done_ecs_cdtitel
                  mov ecs_cdtitel[di],0
                  jmp loop_ecs_cdtitel
  done_ecs_cdtitel:

  skip_menu_label_change:


  show_menu1_loop:
                  mov si,Offset menu1
                  call show_menu
                  dec ax
                  mov si,Offset exe_menu1
                  add si,ax
                  add si,ax
                  jmp Word Ptr [si]

  boot_harddisk:

                  mov dx,00080h
  IFDEF dos

IFNDEF os2boot_ac_code
                  call uninstall_irq_filters
                  STEP 'RPAL'
                  call restore_palette
ENDIF ; os2boot_ac_code

IFNDEF language_en
                  call tastatur_umbelegung_entfernen
ENDIF ; -language_en

                  mov ax,04cffh
                  int 021h
  ENDIF ; dos

                  ; Oliver hat ein BIOS das bei NO-Emulation
                  ; die Laufwerksnummer 80 hat.
                  ; Der Leseversuch von Festplatte 80 scheitert dann nat걊lich
                  cmp [boot_drive],dl
                  jne not_bugfix_CDROM80

IFDEF os2boot_ac_code
                  cmp el_torito_abschalten,true
ELSE
                  cmp cfg_record.cfg_el_torito_abschalten,true
ENDIF
                  ; throw away bios handler for CD ROM
                  if_e <call terminate_cdrom_emulation>

  not_bugfix_CDROM80:
                  mov ax,00201h
                  mov bx,07c00h
                  mov cx,00001h
                 ;mov dx,dx
                  push 0
                  pop es
                  stc
                  push fs
                  int 013h
                  pop fs
                  jc menu_boot_read_error

                  cmp Word Ptr es:[bx+01feh],0aa55h
                  jne not_valid_bootrecord

                  mov si,Offset control_ClrScr07
                  call ausschrift

                  ; "I13X" l봲chen (OS/2 LVM Start)
                  pusha
                  push es
                    push 03000h
                    pop es
                    sub eax,eax
                    sub di,di
                    mov cx,20
                    cld
                    rep stosd
                  pop es
                  popa

                  ; -- hier mehr Speicher l봲chen?

IFDEF os2boot_ac_code
                  cmp el_torito_abschalten,true
ELSE
                  cmp cfg_record.cfg_el_torito_abschalten,true
ENDIF
                  ; throw away bios handler for CD ROM
                  if_e <call terminate_cdrom_emulation>

IFNDEF os2boot_ac_code
                  call uninstall_irq_filters
                  call remove_exception_handler
ENDIF ; os2boot_ac_code

IFNDEF language_en
                  call tastatur_umbelegung_entfernen
ENDIF ; -language_en

IFNDEF os2boot_ac_code
                  STEP 'RPAL'
                  call restore_palette
ENDIF ; os2boot_ac_code

                  pusha
                    mov ax,0003h
                    call int_10h
                  popa

                  push es
                  pop ds

                  push es
                  push bx
                  retf

  menu_boot_read_error:
                 ;mov ax,ax
                  call ausschrift_ax_hex
                  mov al,':'
                  call ausschrift_zeichen
                  mov al,' '
                  call ausschrift_zeichen
                  mov si,Offset message_bootsector_read_error
                  call ausschrift
                  jmp show_menu1_loop

  not_valid_bootrecord:
                  mov si,Offset message_bootsector_invalid_format
                  call ausschrift
                  jmp show_menu1_loop



  show_menu2:

                  ; skip level 2 menu, if configured ('2'/'6')
IFDEF os2boot_ac_code
                  mov al,               show_ecs_cd_menu
ELSE
                  mov al,cfg_record.cfg_show_ecs_cd_menu
ENDIF
                  and al,3
                  cmp al,2
                  je continue_boot_advanced

                  ;**************************************************
                  ; menu level 2
  show_menu2_loop:
                  STEP 'MENU'
                  mov si,Offset menu2
                  call show_menu
                  dec ax
                  mov si,Offset exe_menu2
                  add si,ax
                  add si,ax
                  jmp Word Ptr [si]

  continue_boot_default:
                  mov os2csm_mode_,0
                  jmp exit_do_ecs_cd_menu

  continue_boot_advanced:
                  mov os2csm_mode_,1
                  jmp exit_do_ecs_cd_menu

  load_readme_txt:
                  push di
                    mov di,Offset filename_readme_txt
                    call show_readme
                  pop di
                  jmp show_menu2_loop

  exit_do_ecs_cd_menu:

                popad
                pop es
                ret
a_endp          do_ecs_cd_menu

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

