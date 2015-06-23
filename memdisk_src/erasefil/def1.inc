PTR1616                 Struc
  _OFF                  dw ?
  _SEG                  dw ?
PTR1616                 EndS

BusDeviceFunction88     Struc
  DeviceFunction        db ?
  Bus                   db ?
BusDeviceFunction88     EndS

RequestBlock            Struc
 Length_of_Packet       db ?
 Block_Device_Unit_Code db ?
 Command_Code           db ?
 Request_Packet_Status  dw ?
 Reserved_RB            dd ?
 Queue_Linkage          dd ?

 ; Command_Code=0
 Data_1                 db ?
 Pointer_1              dd ?
 Pointer_2              dd ?
 Data_2                 db ?
RequestBlock            EndS

RequestBlock_10         Struc ; generic ioctl
                        db 13 dup (?)           ; Request Header
  RGI_Function_Category db ?
  RGI_Function_Code     db ?
  RGI_Parameter_Buffer  dd ?
  RGI_Data_Buffer       dd ?
  RGI_System_File_Num   dw ?
RequestBlock_10         EndS


AttachTable             Struc
  reserved00            dw ?
  reserved02            dw ?
  reserved04            dw ?
  IDC_IP_ring0          dw ?
  IDC_CS_ring0          dw ?
  IDC_DS_ring0          dw ?
AttachTable             EndS

datetime                Struc
  date                  dw ?
  time                  dw ?
datetime                EndS

CCHMAXPATHCOMP          EQU     256

FileFindBuf                     Struc
  findbuf_fdateCreation         datetime <>     ; creation
  findbuf_fdateLastAccess       datetime <>     ; last access
  findbuf_fdateLastWrite        datetime <>     ; last write
  findbuf_cbFile                dd ?            ; file end of data
  findbuf_cbFileAlloc           dd ?            ; file allocation
  findbuf_attrFile              dw ?            ; file attribute
  findbuf_cchName               db ?            ; length of ASCIIZ name string
  findbuf_achName               db CCHMAXPATHCOMP dup (?) ; ASCIIZ name string
FileFindBuf                     Ends

Tib2                    Struc           ; System specific portion
  Tib2_ulTid            dd 0            ; Thread I.D.
  Tib2_ulPri            dd 0            ; Thread priority
  Tib2_Version          dd 0            ; Version number for this structure
  Tib2_usMCCount        dw 0            ; Must Complete count
  Tib2_fMCForceFlag     dw 0            ; Must Complete force flag
Tib2                    EndS

Tib                     Struc           ; TIB Thread Information Block
  Tib_PExchain          dd 0            ; Head of exception handler chain
  Tib_PStack            dd 0            ; Pointer to base of stack
  Tib_PStackLimit       dd 0            ; Pointer to end of stack
  Tib_PTib2             dd 0            ; Pointer to system specific TIB
  Tib_Version           dd 0            ; Version number for this TIB structure
  Tib_Ordinal           dd 0            ; Thread ordinal number
Tib                     EndS

TIB_SELECTOR            equ 0150bh
