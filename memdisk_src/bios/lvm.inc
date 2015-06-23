Title                           LVM data definitions

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

;lvm_beschreibungstabelle_sig:   db 002,'RMBPMFD'
;lvm_beschreibungstabelle_laenge equ $-lvm_beschreibungstabelle_sig

DLA_Signature_lo                equ ('BMR' shl 8)+2
DLA_Signature_hi                equ 'DFMP'

lvm_partitionsbeschreibung_typ  Struc
  Volume_Serial_Number          dd ?
  Partition_Serial_Number       dd ?
  Partition_Size                dd ?
  Partition_Start               dd ?
  On_Boot_Manager_Menu          db ?
  Installable                   db ?
  Drive_Letter                  db ?
  Reserved_part                 db ?
  Volume_Name                   db 20 dup (?)
  Partition_Name                db 20 dup (?)
lvm_partitionsbeschreibung_typ  EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

lvm_beschreibungstabelle_typ    Struc
  DLA_Signature                 db 8 dup (?)
  DLA_CRC                       dd ?
  Disk_Serial_Number            dd ?
  Boot_Disk_Serial_Number       dd ?
  Install_Flags                 dd ?
  Cylinders                     dd ?
  Heads_Per_Cylinder            dd ?
  Sectors_Per_Track             dd ?
  Disk_Name                     db 20 dup (?)
  Reboot                        db ?
  Reserved_DLA                  db 3 dup (?)
  tabelle                       db 4*type lvm_partitionsbeschreibung_typ dup (?)
  rest512                       db 512-DLA_Signature-$ dup (?)
lvm_beschreibungstabelle_typ    EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
