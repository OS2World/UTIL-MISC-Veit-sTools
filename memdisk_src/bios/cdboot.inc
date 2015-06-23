; ISO9660 (cdrom.h aus shsucd14.zip)

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; CD Directory Entry Flags
cdrom_HIDDEN                        equ 001h
cdrom_DIR                           equ 002h
cdrom_ASSOCFILE                     equ 004h
cdrom_HSEARFMT                      equ 004h ; file has HS ext attrib rcd fmt
cdrom_RECORD                        equ 008h
cdrom_PROTECTION                    equ 010h
cdrom_MULTIEXTENT                   equ 080h ; file has at least one more extent

Date_Time_Rec                       Struc
  Yr                                db ?        ; base 1900
  Mth                               db ?        ; 1-12
  Day                               db ?        ; 1-31
  Hr                                db ?        ; 0-23
  Min                               db ?        ; 0-59
  Sec                               db ?        ; 0-59
Date_Time_Rec                       EndS


isoDirRec                           Struc
  RecLen                            db ?
  ExAttrRecLen                      db ?
  ExtLocLSB                         dd ?
  ExtLocMSB                         dd ?
  DataLenLSB                        dd ?
  DataLenMSB                        dd ?
  Date_Time                         Date_Time_Rec <>
  GMTOffset                         db ?
  dirFlags                          db ?
  FileUnitSize                      db ?
  InterLeave                        db ?
  VolSeqNoLSB                       dw ?
  VolSeqNoMSB                       dw ?
  FileID                            db ? ; pascal string
isoDirRec                           EndS


VTOC                            Struc
  cdType                        db 1
  ID                            db 'CD001'
  Version                       db 1
                                db ? ; Unused1;
  SysID                         db 32 dup (?)
  VolID                         db 32 dup (?)
                                db  8 dup (?)
  VolSizeLSB                    dd ?
  VolSizeMSB                    dd ?
                                db 32 dup (?)
  SetSizeLSB                    dw ?
  SetSizeMSB                    dw ?
  SetSeqLSB                     dw ?
  SetSeqMSB                     dw ?
  BlkSizeLSB                    dw ?
  BlkSizeMSB                    dw ?
  PathTabSizeLSB                dd ?
  PathTabSizeMSB                dd ?
  PathTabLocLSB                 dd ?
  PathTabAltLocLSB              dd ?
  PathTabLocMSB                 dd ?
  PathTabAltLocMSB              dd ?
  DirRec                        isoDirRec <>
  VolSetID                      db 128 dup (?)
  PubID                         db 128 dup (?)
  PrepID                        db 128 dup (?)
  AppID                         db 128 dup (?)
  CopyRightID                   db  37 dup (?)
  AbstractID                    db  37 dup (?)
  BiblioID                      db  37 dup (?)
  CreateDate                    db 'YYYYMMDDHHMMSSssZ'
  ModDate                       db 'YYYYMMDDHHMMSSssZ'
  ExpDate                       db 'YYYYMMDDHHMMSSssZ'
  EffDate                       db 'YYYYMMDDHHMMSSssZ'
  StdVer                        db 1
                                db 0 ; Reserved
VTOC                            EndS


; EL TORITO

Boot_Record_Volume_Descriptor   Struc
  Boot_Record_Indicator         db 0
  ISO_9660_Identifier           db 'CD001'
  Version_of_this_descriptor    db 1
  Boot_System_Identifier        db 'EL TORITO SPECIFICATION',8 dup (0)
                                db 32 dup (0) ; Unused
  abs_pointer_to_Boot_Catalog   dd 0 ; absolute sector number
                                db 1974 dup (0) ; Unused
Boot_Record_Volume_Descriptor   EndS


Boot_Catalogue_Section_Entry    Struc
  Boot_Indicator_88             db 088h ; 88 = Bootable, 00 = Not Bootable
  Boot_media_type               db ?
  Load_Segment                  dw 0 ; =0:7c00
  System_Type_partition_table   db ?
                                db 0 ; Unused
  Sector_Count                  dw ? ; This is the number of virtual/emulated sectors the system will
                                     ; store at Load Segment during the initial boot procedure.
  Load_RBA                      dd ? ; This is the start address of the virtual disk.  CD's use
                                     ; Relative/Logical block addressing.
  Selection_criteria_type       db ? ; This defines a vendor unique format for bytes 0D-1F.
                                db 19 dup (?) ; Vendor unique selection criteria.
Boot_Catalogue_Section_Entry    EndS


