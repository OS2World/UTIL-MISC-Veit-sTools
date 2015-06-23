Title                   OS/2 Device Helper + some macros

Init_Arguments          Struc
                        dw ?
  Disk_Config_Table     dw ?
                        dw ?
  Cmd_Line_Args         dw ?
  Machine_Config_Table  dw ?
Init_Arguments          EndS

; from \ddk\DASD\IBM\IBM1FLPX\flp1misc.h
ROMCFG                  Struc
  ROMlink               dw ? ; link to next table entry
  ROMcyls               dw ? ; maximum number of cylinders
  ROMsecptrk            dw ? ; maximum sectors per track
  ROMdevnbr             db ? ; device number
  ROMheads              dw ? ; number of heads
  ROMwpf                dw ? ; write precompensation factor
  ROMflags              dw ? ; flag byte
ROMCFG                  EndS

ROMfixed                equ 00001h
ROMchgline              equ 00002h


WORD1616 Struc
  Lo                    dw ?
  Hi                    dw ?
WORD1616 EndS

NULL                    equ     0