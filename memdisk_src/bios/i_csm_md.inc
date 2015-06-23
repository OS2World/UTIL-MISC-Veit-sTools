Title   Interface MemDisk<->OS2CSM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

xxa equ Type table_memdisk_os2csm_interface_Struc

table_memdisk_os2csm_interface_Struc    Struc
  i_csm_md_sign                 dd 'ICMD'       ; signature
  memorymanager_anchor          dw ?            ; first heap segment
  config_sys_memory             ptr1616 <>      ; config.sys
  config_sys_size               dw ?
  config_x___memory             ptr1616 <>      ; config.x
  config_x___size               dw ?
  os2csm_set_memory             ptr1616 <>      ; os2csm.set
  os2csm_set_size               dw ?
  os2csm_hlp_memory             ptr1616 <>      ; os2csm.hlp
  os2csm_hlp_size               dw ?
  memdisk_drive_letter          db ?            ; 'Z'
  rename_os2ldr_deb             db ?            ; 0
  rename_os2krnl_deb            db ?            ; 0
  os2csm_mode                   db 1            ; 0=hidden 1=normal
  altf2on_change                db 0            ; 0=unchanged 1=erase 2=create
  config_sys_edit               db true         ; edit config.sys (after os2csm.bin)
  memdisk_disksize              dw 0            ; readonly: memory disk size (MiB)
  memdisk_diskfree              dw 0            ; readonly: memory disk free (MiB)
  rename_fileset_a              db '0'          ; rename *.snX to *.snp etc for X = 1,2,..9
  rename_fileset_b              db '0'          ; rename *.snX to *.snp etc for X = 1,2,..9
  rename_fileset_c              db '0'          ; rename *.snX to *.snp etc for X = 1,2,..9
  rename_fileset_d              db '0'          ; rename *.snX to *.snp etc for X = 1,2,..9
  delete_os2logo_s3             db false        ; for incompatible vga chips, and ACPI debug
  put_key                       dw -1           ; Place Alt+F2 into keyboard buffer

  ICMD_lastbyte                 db ICMD_lastbyte
table_memdisk_os2csm_interface_Struc EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
