a_proc                  Macro ID
                        &ID proc
                        EndM


a_endp                  Macro ID
                        &ID endp
                        public &ID
                        EndM


PTR1616                 Struc
  _OFF                  dw ?
  _SEG                  dw ?
PTR1616                 EndS


RequestBlock Struc
 Length_of_Packet       db ?
 Block_Device_Unit_Code db ?
 Command_Code           db ?
 Request_Packet_Status  dw ?
 Reserved               dd ?
 Queue_Linkage          dd ?

 ; Command_Code=0
 Data_1                 db ?
 Pointer_1              dd ?
 Pointer_2              dd ?
 Data_2                 db ?
RequestBlock EndS

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

false                   equ 0
true                    equ 1
