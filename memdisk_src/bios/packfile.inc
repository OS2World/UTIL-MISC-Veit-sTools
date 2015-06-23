Title   archive format produced by pascal code packfile

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

min_buffer_fill         equ (32*1024*9)/8+64+Size file_block
                        ;   32KB cluster, worst case "compression", packfile header

bt_header               equ 0
bt_nextpack             equ 1
bt_file                 equ 2
bt_output               equ 3
bt_sector               equ 4
bt_volume               equ 5
bt_delete               equ 6
bt_requestdisk          equ 7
high_bt                 equ 7

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

soll_version_mac        Macro VN
                        local l1
                        local l2
  l1                    equ $
                        &VN db (Offset l2)-(Offset l1)-1,'archivefile/2002-02-02/aPLib036',26,0
  l2                    equ $
                        EndM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

file83                  Struc
  fname                 db 8 dup (?)
  ext                   db 3 dup (?)
file83                  EndS

header_block            Struc
  blen                  dd ?
  btype                 db ?
                        soll_version_mac pfversion
header_block            EndS

nextpack_block          Struc
  blen                  dd ?
  btype                 db ?
  next_file             file83 <>
nextpack_block          EndS

file_block              Struc
  blen                  dd ?
  btype                 db ?
  filename              file83 <>
  sizepacked            dd ?
  sizeunpacked          dd ?
  date_time             dd ?
  attrib                db ?
file_block              EndS

output_block            Struc
  blen                  dd ?
  btype                 db ?
  messagetext           db 256+1 dup (?)
output_block            EndS

sector_block            Struc
  blen                  dd ?
  btype                 db ?
  sector                db 512 dup (?)
sector_block            EndS

volume_block            Struc
  blen                  dd ?
  btype                 db ?
  volumelabel           file83 <>
volume_block            EndS

delete_block            Struc
  blen                  dd ?
  btype                 db ?
  delete_filename       file83 <>
delete_block            EndS

requestdisk_block       Struc
  blen                  dd ?
  btype                 db ?
  disklabel             file83 <>
requestdisk_block       EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
