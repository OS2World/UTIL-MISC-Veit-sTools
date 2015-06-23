RequestBlock            Struc
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
RequestBlock            EndS

RequestBlock_10         Struc ; generic ioctl
                        db 13 dup (?)           ; Request Header
  RGI_Function_Category db ?
  RGI_Function_Code     db ?
  RGI_Parameter_Buffer  dd ?
  RGI_Data_Buffer       dd ?
  RGI_System_File_Num   dw ?
RequestBlock_10         EndS
