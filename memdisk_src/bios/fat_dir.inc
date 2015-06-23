Title           FAT directory entry definition

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴


fat_direntry    Struc
  filenameext   db (8+3) dup (?)                ; 00
  attr          db ?                            ; 0b
  file_used     db ?                            ; 0c private definition
  drdos_first_letter db ?                       ; 0d
  cdromsector   dd ?                            ; 0e private definition
  reserved      db (10-1-1-4) dup (?)           ; 12
  datetime      dd ?                            ; 16
  first_cluster dw ?                            ; 1a
  filesize      dd ?                            ; 1c
fat_direntry    EndS                            ; 20

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

shift_direntry_per_sector equ 4         ; 512/size fat_direntry=16
shift_byte_per_direntry   equ 5         ; 32*1 shl 5
max_rootdir_entries       equ 512       ; should be good enough

end_of_fat_directory      equ 000h
erased_file               equ 0e5h

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

faReadOnly              equ 001h
faHidden                equ 002h
faSysFile               equ 004h
faVolumeID              equ 008h
faDirectory             equ 010h
faArchive               equ 020h

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
