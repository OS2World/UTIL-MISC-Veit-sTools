title   strategy request and other record definitions

ptr1616                 Struc
  offs                  dw ?
  sel                   dw ?
ptr1616                 EndS

PTR1616_real            Struc
  _OFF                  dw ?
  _SEG                  dw ?
PTR1616_real            EndS

BusDeviceFunction88     Struc
  DeviceFunction        db ?
  Bus                   db ?
BusDeviceFunction88     EndS

RequestBlock            Struc
 Length_of_Packet       db ? ; / request packet header
 Block_Device_Unit_Code db ?
 Command_Code           db ?
 Request_Packet_Status  dw ?
 Reserved               dd ? ; 1 byte flags + 3 byte ?
 Queue_Linkage          dd ? ; \ end request packet header

 ; Command_Code=0
 Data_1                 db ?
 Pointer_1              dd ?
 Pointer_2              dd ?
 Data_2                 db ?
RequestBlock            EndS

RequestBlock_04         Struc ; input/read..
                        db 13 dup (?)           ; Request Header
 Media_Descriptor       db ?
 Transfer_Address       dd ?
 Byte_Sector_Count      dw ?
 Starting_Sector_Number_for_Block_Device dd ?
 System_File_Number     dw ?
RequestBlock_04         EndS


RequestBlock_10         Struc ; generic ioctl
                        db 13 dup (?)           ; Request Header
  RGI_Function_Category db ?
  RGI_Function_Code     db ?
  RGI_Parameter_Buffer  dd ?
  RGI_Data_Buffer       dd ?
  RGI_System_File_Num   dw ?
  RGI_Parameter_Len     dw ?                    ; DevIOCtl2 caller+device header
  RGI_Data_Len          dw ?                    ; DevIOCtl2 caller+device header
RequestBlock_10         EndS


AttachTable             Struc
  reserved00            dw ?
  reserved02            dw ?
  reserved04            dw ?
  IDC_IP_ring0          dw ?
  IDC_CS_ring0          dw ?
  IDC_DS_ring0          dw ?
AttachTable             EndS

drivername              Struc
                        db 8 dup (?)
drivername              EndS


; The OS/2 Debugging Handbook
;  OS/2 System Control Block Reference
;   Memory Management Control Block Reference
;    Physical Arena Information Structures

pagerange_s             Struc
  pri_lastframe         dd ?    ; last valid page in range
  pri_firstframe        dd ?    ; first valid page in range
pagerange_s             EndS

pb_phys                 Struc
  pb_frame              dd ?    ; last frame before boundary
  pb_ppf                dd ?    ; last pf before boundary
  pb_ppr                dd ?    ; page range containing boundary
pb_phys                 EndS

Physical_Arena_Information      Struc
  pai_pprt              dd ?            ; pointer to page range table
  pai_nranges           dd ?            ; number of ranges in range table
  pai_1M                pb_phys <>      ; 1M boundary structure
  pai_16M               pb_phys <>      ; 16M boundary structure
  pai_end               pb_phys <>      ; end of memory boundary structure
Physical_Arena_Information      EndS

false                   equ 0
true                    equ 1

