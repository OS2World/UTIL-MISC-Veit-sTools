Title           Communication with Resource Manager - init data

NameResmgrDD    db 'RESMGR$ ',0                 ; the space char is needed

IDC_ResmgrDD    dw 0                            ; Reserved
                dw 0                            ; Reserved
ResmgrIDC_CS_R3 dw 0                            ; R3 IDC CS "Reserved"
ResmgrIDC_CS_R0 dw 0                            ; R0 IDC IP
ResmgrIDC_IP_R0 dw 0                            ; R0 IDC CS
                dw 0                            ; R0 IDC DS

                ; driver

                public DrvrFileName
DrvrFileName    db 128 dup (0)                  ; driver filename

DrvrDescript    db 'Memory Disk Driver ',datum,0

VendorName      db 'Veit Kannegieser',0

DriverStructure dd FAR PTR DrvrFileName
                dd FAR PTR DrvrDescript
                dd FAR PTR VendorName
                db 1                            ; MajorVer API
                db 1                            ; MinorVer API
                dw year                         ; Year
                db month                        ; Month
                db day                          ; Day
                dw DRF_STATIC                   ; DrvrFlags
                dw DRT_ADDDM                    ; DrvrType
                dw DRS_ADD                      ; DrvrSubType
                dd 0                            ; DrvrCallback

                ; adapter

hAdapter        dd -1                           ; handle for following adapter

AdaptDescName   db 'MEM_0 Virtual Disk Controller',0

AdapterStructure dd FAR PTR AdaptDescName
                dw AS_NO16MB_ADDRESS_LIMIT      ; AdaptFlags
                dw AS_BASE_MSD                  ; BaseType
                dw AS_SUB_OTHER                 ; SubType
                dw AS_INTF_GENERIC              ; InterfaceType
                dw AS_HOSTBUS_UNKNOWN           ; HostBusType
                                                ; AS_HOSTBUS_PCMCIA ?
                dw AS_BUSWIDTH_UNKNOWN          ; HostBusWidth AS_BUSWIDTH_32BIT ?
                dd 0                            ; pAdjunctList: use board number for #
                dd 0                            ; Reserved


                ; device

hDevice         dd -1

DevDescName     db 'BOOT Memory emulated Harddisk',0
DevDescNameA    db 'BOOT Memory emulated a: drive',0

DeviceStructure dd Far Ptr DevDescName
                dw 0 ; DS_REMOVABLE_MEDIA not set
                dw 0 ; DS_TYPE_DISK
                dd FAR PTR AdjunctList

AdjunctList     dd 0                            ; pNextAdj
                dw Offset AdjunctListEnd-Offset AdjunctList       ; AdjLength
                dw ADJ_DEVICE_NUMBER            ; AdjType
ResDeviceNumber dw 0                            ; Device_Number
AdjunctListEnd  label byte


                ; resource

MemResourceList dd 1                            ; NumResource
hMem_Resource1  dd -1

Mem_Resource1   dd RS_TYPE_MEM                  ; Type: Memory Resource
MemBase1        dd ?                            ; Base
MemSize1        dd ?                            ; Size
                dw RS_MEM_EXCLUSIVE             ; Flags
                dw 0                            ; Reserved
                dd ?                            ; resource.sys: 0a byte ?

