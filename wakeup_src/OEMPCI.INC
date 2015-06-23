; from \pccard\src\csos2\cs2mendm.asm:

;sCallOEMHelpPkt db      12              ; packet length                     ; 1.40
;                db      0               ; packet unit                       ; 1.40
;                db      16              ; cmd                               ; 1.40
;                dw      0               ; status                            ; 1.40
;                db      0               ; flag                              ; 1.40
;                db      3 dup (0)                                           ; 1.40
;                dd      0               ; packet dev link                   ; 1.40
;                db      80h             ; category                          ; 1.40
;                db      5h              ; function                          ; 1.40
;                dd      0               ; pointer to parameter packet       ; 1.40
;                dw      OFFSET sROMBios ; offset of data packet             ; 1.40
;                dw      0               ; segment of data packet            ; 1.40
;                dw      0                                                   ; 1.40
;                db      6 dup (0)                                           ; 1.40

OEMHLP_IDC_Packet       Struc
  idc_packet_length     db 12
  idc_packet_unit       db 0
  idc_command           db 16
  idc_status            dw 0
  idc_flag              db 0
                        db 3 dup (0)
  idc_packet_dev_link   dd 0
  idc_category          db 0
  idc_function          db 0
  idc_para_ptr          dd 0
  idc_data_ptr          dd 0

                        db ?    ; make stack usage word align
OEMHLP_IDC_Packet       EndS

para_packet_80_0b_00    Struc
  Subfunction_Number_00 db 0
                        db ? ; word align
para_packet_80_0b_00    EndS

data_packet_80_0b_00    Struc
  Return_Code_00        db ?
  Hardware_Mechanism    db ?
  Major_Version         db ?
  Minor_Version         db ?
  Last_Bus              db ?
                        db ? ; word align
data_packet_80_0b_00    EndS

para_packet_80_0b_01    Struc
  Subfunction_Number_01 db 01h
  Device_ID             dw ?
  Vendor_ID             dw ?
  Index_01              db ?
para_packet_80_0b_01    EndS

para_packet_80_0b_02    Struc
  Subfunction_Number_02 db 02h
  Class_Code            dd ?
  Index_02              db ?
para_packet_80_0b_02    EndS

data_packet_80_0b_0102  Struc
  Return_Code           db ?
  Bus_Number            db ?
  DevFunc_Number        db ?
                        db ? ; word align
data_packet_80_0b_0102  EndS

para_packet_80_0b_03    Struc
  Subfunction_Number_03 db 03h
  Bus_Number_03         db ?
  DevFuncNum_03         db ?
  ConfigurationReg_03   db ?
  Size_03               db ?
                        db ? ; word align
para_packet_80_0b_03    EndS

data_packet_80_0b_03    Struc
  Return_Code_03        db ?
  Data_03               dd ?
                        db ? ; word align
data_packet_80_0b_03    EndS

para_packet_80_0b_04    Struc
  Subfunction_Number_04 db 04h
  Bus_Number_04         db ?
  DevFuncNum_04         db ?
  ConfigurationReg_04   db ?
  Size_04               db ?
  Data_04               dd ?
                        db ? ; word align
para_packet_80_0b_04    EndS


data_packet_80_0b_04    Struc
  Return_Code_04        db ?
                        db ? ; word align
data_packet_80_0b_04    EndS

ptr1616                 Struc
  offs                  dw ?
  sel                   dw ?
ptr1616                 EndS

