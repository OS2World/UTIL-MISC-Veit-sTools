Title                   Type definitions: bootsector, partition

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

partition_entry         Struc
  boot_indicator        db ?
  begin_DH              db ?
  begin_CX              dw ?
  system_indicator      db ?
  end_DH                db ?
  end_CX                dw ?
  sectors_preceding     dd ?
  number_of_sectors     dd ?
partition_entry         EndS

partition       Struc
  boot_indicator     db ?
  begin_head         db ?
  begin_sector       db ?
  begin_cylinder     db ?
  system_indicator   db ?
  end_head           db ?
  end_sector         db ?
  end_cylinder       db ?
  rel_sectors        dd ?
  num_sectors        dd ?
partition       EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

Bootsector              Struc           ; bootsector or MBR
  jmp0                  db 3 dup (?)
  oemname               db 8 dup (?)
  bytes_per_sector      dw ?
  sectors_per_cluster   db ?
  reserved_sectors      dw ?
  number_of_FATs        db ?
  root_directory_size   dw ?
  total_sectors_16      dw ?
  media_descriptor_byte db ?
  sectors_per_FAT       dw ?
  sectors_per_track     dw ?
  number_of_heads       dw ?
  hidden_sectors        dd ?
  number_of_sectors_32  dd ?
  physical_drive_number db ?
  driveletter           db ?            ; chkdsk 0=clean 1=dirty
  signature_byte        db ?
  volume_serial_number  dd ?
  volume_label          db (8+3) dup (?)
  fsname                db 8 dup (?)
  bs_code               db (01beh-03eh) dup (?) ; 03e
  partition1            partition_entry <>      ; 1be
  partition2            partition_entry <>      ; 1ce
  partition3            partition_entry <>      ; 1de
  partition4            partition_entry <>      ; 1ee
  ibm_sig               dw ?                    ; 1fe
Bootsector              EndS                    ; 200

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
