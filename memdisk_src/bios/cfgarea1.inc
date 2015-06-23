Title   configuration record, altered by memcfg.exe - record defintion

;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

my_cfg_version          equ 11

cfg_record_type         Struc
  cfg_version               db my_cfg_version

  ; minimum byte assigned to memory disk
  cfg_disksize_min          dd 100*32*4*512

  ; size of memory required for OS
  cfg_os2_min_memory        dd 16*1024*1024 ; must be > 16 MiB !

  ; if available, additionally assign in bytes
  cfg_disk_additional_const dd 0

  ; if still available, assign ratio (x/100) of memory
  cfg_disk_additional_percent db 30

  ; note: will not assign more than 1024*255*63*512 bytes

                            ;   1234567890123456789* (max 19 chars + #0 recommended)
  cfg_part_name             db 'Startup Partition',0,0,0
  cfg_vol_name              db 'Startup Volume',0,0,0,0,0,0
  cfg_lvm_letter            db 'Z'
  cfg_primaer_oder_logisch  db 1            ; 0=logisch 1=primÑr
  cfg_el_torito_abschalten  db 1
  cfg_start_disk            db '*'          ; '*'=MenÅ, 'M'emdisk, 'H'arddisk, 'F'loppy
  cfg_update_floppy_A       db true
  cfg_update_floppy_B       db true
  IFDEF dos
 ;cfg_use_serial_debug      db true
  cfg_use_serial_debug      db false
  ELSE
 ;cfg_use_serial_debug      db true
  cfg_use_serial_debug      db false
  ENDIF
  cfg_progress_indicator    db 1    ; 0,1,2 : none,block,filename
  IFDEF dos
  cfg_show_ecs_cd_menu      db 1  +8  ; 0/1/2=off/eCS/only first level +4 default CD boot +8 show license note
  ELSE
  cfg_show_ecs_cd_menu      db 1  +8  ; 0/1/2=off/eCS/only first level +4 default CD boot +8 show license note
  ENDIF
  cfg_debugoption           db true*debugoption_STEP+false*debugoption_memtest
  cfg_load_font             db true
  cfg_modify_rgb_palette    db true
  cfg_call_os2csm_bin       db true
  cfg_update_primary_plain  db true
  cfg_progress_block_char   db '€'
  cfg_edit_config_sys       db true
  cfg_a20_access            db 2            ; 0=BIOS 1=private 2=auto
  cfg_scan_lvm_letter_hd    db true
cfg_record_type         EndS
