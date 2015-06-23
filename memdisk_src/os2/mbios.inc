Title   interface memboot.bin -> memdisk.add

; this data structure is somewhere at ~639 KB in the memboot.bin
; memory area. used by memdisk.add to present equal geometry,
; know the physical memory address and do special case handling
; for A: drive letter.

_MDBIB_sign0_val                equ 08325c91ch
_MDBIB_sign1_val                equ 0591e742bh

MemDiskBIOS_Info_Block          Struc
  _MDBIB_sign0                  dd _MDBIB_sign0_val
  _phys_addr                    dd -1 ; -1 means not setup - for readme.inc
  _anzahl_zylinder              dd 0
  _anzahl_koepfe                dd 0
  _anzahl_sektoren_je_spur      dd 0
  _anzahl_sektoren              dd 0
  _lvm_letter                   db 0
  _MDBIB_sign1                  dd _MDBIB_sign1_val
MemDiskBIOS_Info_Block          EndS

