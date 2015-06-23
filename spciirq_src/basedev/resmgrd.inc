Title           Communication with Resource Manager - data

RM_Help0                dd 0
RM_Help3                dd 0

hDriver                 dd -1                   ; handle to resource maneger
                        Public RM_Help0,RM_Help3,hDriver

;****************************************************************************

; definitions from rmbase.h

; ResourceStruct.ResourceType
RS_TYPE_IO              equ 1
RS_TYPE_IRQ             equ 2
RS_TYPE_MEM             equ 3
RS_TYPE_DMA             equ 4
RS_TYPE_TIMER           equ 5
RS_TYPE_NEW             equ 0ffffh

HResource__             Struc
  NumResource           dd ?
  hResource___          dd ?            ; First Entry in Array of HRESOURCE
HResource__             EndS

DateStamp               Struc
  Year                  dw ?
  Month                 db ?
  Day                   db ?
DateStamp               EndS

DriverStruct            Struc
  DrvrName              dd ?
  DrvrDescript_DS       dd ?
  VendorName_DS         dd ?
  MajorVer              db ?
  MinorVer              db ?
  Date                  DateStamp <year,month,day>
  DrvrFlags             dw ?
  DrvrType              dw ?
  DrvrSubType           dw ?
  DrvrCallback          dd ?            ; Event notification
DriverStruct            EndS

; DriverStruct.DrvrFlags

DRF_STATIC              equ 0
DRF_DYNAMIC             equ 1
DRF_PREVIOUS            equ 2


DRT_UNDEFINED           equ 0
  DRS_UNDEFINED         equ 0

DRT_PCMCIA              equ 1
  DRS_SOCKETSERV        equ 1
  DRS_CARDSERV          equ 2
  DRS_CLIENT            equ 3

DRT_ADDDM               equ 2
  DRS_DM                equ 1
  DRS_FILTER            equ 2
  DRS_ADD               equ 3
  DRS_DM_TRANSPORT      equ 4

DRT_OS2                 equ 3
  DRS_CHAR              equ 1
  DRS_BLOCK             equ 2
  DRS_APP_HELPER        equ 3

DRT_NETWORK             equ 4
DRT_VIDEO               equ 5
DRT_AUDIO               equ 6
DRT_SERVICE             equ 7
  DRS_SNOOPER           equ 1
  DRS_CONFIG            equ 2

ADD_UNIT                Struc
  ADDHandle             dw ?
  UnitHandle            dw ?
ADD_UNIT                EndS

DASD_VOL                Struc
  VolFlags              dw ?
  VolIFSType            dw ?
  VolSize               dd ?
  VolID                 dd ?
DASD_VOL                EndS

DriverInfo              Struc
  Priority              dw ?
  DriverType            dw ?
  DriverName            db 12 dup (?)
  DriverParmLine        db  1 dup (?)   ; Embedded asciiz
DriverInfo              EndS

DriverBase              equ 0
DriverLoadable          equ 1

; ADJUNCT - record of variyng structure
AdjHeader               Struc
  pNextAdj              dd ?
  AdjLenht              dw ?
  AdjType               dw ?
AdjHeader               EndS



ADJ_SCSI_TARGET_LUN     equ 1
ADJ_ADAPTER_NUMBER      equ 2
ADJ_DEVICE_NUMBER       equ 3
ADJ_PCI_DEVFUNC         equ 4
ADJ_MODEL_INFO          equ 5
ADJ_ADD_UNIT            equ 6
ADJ_DASD_VOL            equ 7
ADJ_DRIVER_DATA         equ 8

AdapterStruct           Struc
  AdaptDescriptName     dd ?
  AdaptFlags            dw ?
  BaseType              dw ?
  SubType               dw ?
  InterfaceType         dw ?
  HostBusType           dw ?
  HostBusWidth          dw ?
  pAdjunctList_AS       dd ?
  Reserved_AS           dd ? ; Logical Name addition?
AdapterStruct           EndS

AS_BASE_RESERVED        equ 0
 AS_SUB_OTHER           equ 080h        ; Can Be used by any BASE type
  AS_INTF_GENERIC       equ 001h        ; Can Be used by any SUB type

AS_BASE_MSD             equ 1           ; Mass Storage Device
 AS_SUB_SCSI            equ 1
 AS_SUB_IDE             equ 2
 AS_SUB_FLPY            equ 3
 AS_SUB_IPI             equ 4

AS_BASE_NETWORK         equ 2           ; Network Interface Controller
 AS_SUB_ETHERNET        equ 1
 AS_SUB_TOKENRING       equ 2
 AS_SUB_FDDI            equ 3

AS_BASE_DISPLAY         equ 3           ; Display Controller
 AS_SUB_VGA             equ 1
  AS_INTF_VGA_GEN       equ 1
  AS_INTF_VESA_SVGA     equ 2
 AS_SUB_XGA             equ 2


AS_BASE_MMEDIA          equ 4           ; Multi-media Controller
 AS_SUB_MM_VIDEO        equ 1
 AS_SUB_MM_AUDIO        equ 2

AS_BASE_MEMORY          equ 5           ; Memory
 AS_SUB_BIOS_ROM        equ 1

AS_BASE_BRIDGE          equ 6           ; Bridge Controller

AS_BASE_COMM            equ 7           ; Communications Device
 AS_SUB_SERIAL          equ 1
  AS_INTF_16450         equ 1
  AS_INTF_16550         equ 2
 AS_SUB_PARALLEL        equ 2
  AS_INTF_BIDI          equ 1
  AS_INTF_ECP           equ 2
 AS_SUB_ISDN            equ 3           ; ISDN Device */
  AS_INTF_UNKNOWN       equ 1           ; Any I/F not yet defined
  AS_INTF_A2000FIFO     equ 2           ; Active 2000 Fifo based
  AS_INTF_A2000SLC      equ 3           ; Active 2000 Serial Link

AS_BASE_PERIPH          equ 8           ; System Peripherals
 AS_SUB_PIC             equ 1
  AS_INTF_ISAPIC        equ 1
  AS_INTF_EISAPIC       equ 2
 AS_SUB_DMA             equ 2
 AS_SUB_TIMER           equ 3
 AS_SUB_RTC             equ 4

AS_BASE_INPUT           equ 9           ; Input Device
 AS_SUB_KBD             equ 1
 AS_SUB_DIGIT           equ 2
 AS_SUB_MOUSE           equ 3

AS_BASE_DOCK            equ 10          ; Docking Station

AS_BASE_CPU             equ 11          ; CPU

AS_BASE_PCMCIA          equ 12          ; PCMCIA
 AS_SUB_SOCKET_CONTROLLER equ 1         ; Socket Controller

AS_BASE_BIOS_ROM        equ 13


AS_HOSTBUS_OTHER        equ 0
AS_HOSTBUS_ISA          equ 1
AS_HOSTBUS_EISA         equ 2
AS_HOSTBUS_uCHNL        equ 3
AS_HOSTBUS_PCI          equ 4
AS_HOSTBUS_SCSI         equ 5
AS_HOSTBUS_PCMCIA       equ 6
AS_HOSTBUS_PARALLEL     equ 7
AS_HOSTBUS_PLANAR       equ 8
AS_HOSTBUS_UNKNOWN      equ 0ffh

AS_BUSWIDTH_8BIT        equ 010h
AS_BUSWIDTH_16BIT       equ 020h
AS_BUSWIDTH_32BIT       equ 030h
AS_BUSWIDTH_64BIT       equ 040h
AS_BUSWIDTH_UNKNOWN     equ 0f0h

AS_16MB_ADDRESS_LIMIT   equ 1
AS_NO16MB_ADDRESS_LIMIT equ 0


DeviceStruct            Struc
  DevDescriptName       dd ?
  DevFlags              dw ?
  DevType               dw ?
  pAdjunctList_DS       dd ?
DeviceStruct            EndS

; DeviceStruct.DevType

DS_TYPE_DISK            equ 00000h      ; All Direct Access Devices
DS_TYPE_TAPE            equ 00001h      ; Sequencial Access Devices
DS_TYPE_PRINTER         equ 00002h      ; Printer Device
DS_TYPE_PROCESSOR       equ 00003h      ; Processor type device
DS_TYPE_WORM            equ 00004h      ; Write Once Read Many Device
DS_TYPE_CDROM           equ 00005h      ; CD ROM Device
DS_TYPE_SCANNER         equ 00006h      ; Scanner Device
DS_TYPE_OPT_MEM         equ 00007h      ; some Optical disk
DS_TYPE_CHANGER         equ 00008h      ; Changer device e.g. juke box
DS_TYPE_COMM            equ 00009h      ; Communication devices
DS_TYPE_ATAPI           equ 0000Ah      ; Unspecific ATAPI protocol device
DS_TYPE_SCSI_ATT        equ 0000Bh      ; SCSI Attach
DS_TYPE_SOCKET          equ 0000Ch      ; PCMCIA Socket
DS_TYPE_SLOT            equ 0000Dh      ; Bus Slot
DS_TYPE_PLANAR_CHIPSET  equ 0000Eh      ; DMA/IRQ/TIMER Controllers
DS_TYPE_IO              equ 0000Fh      ; Input/Output
DS_TYPE_AUDIO           equ 00010h      ; Audio Device
DS_TYPE_UNKNOWN         equ 0FFFFh

; DeviceStruct.DevFlags

DS_REMOVEABLE_MEDIA     equ 1
DS_FIXED_LOGICALNAME    equ 2


AHDEVICES               Struc
  NumDevices            dd ?
  hDevices              dd ?            ; First Entry in array of HRESOURCE
AHDEVICES               EndS

; Resource Structure

IOResource              Struc
  BaseIOPort            dw ?
  NumIOPorts            dw ?
  IOFlags               dw ?
  IOAddressLines        dw ?
IOResource              EndS

; IOResource.IOFlags
RS_IO_EXCLUSIVE         equ 00001h
RS_IO_MULTIPLEXED       equ 00002h
RS_IO_SHARED            equ 00004h
RS_IO_RECONFIGURE       equ 00008h
RS_IO_GRANT_YIELD       equ 00010h
RS_IO_FORCE_ALIAS       equ 00020h
RS_SEARCH               equ 04000h
RS_NONOWNER_ALLOWED     equ 08000h

; IRQ Resource Structure

; Interrupt handler for Grant/Yield with RM routing interrupts
; FNRMINTHANDLER

IRQResource             Struc
  IRQLevel              dw ?            ; < 16
  PCIIrqPin             dw ?            ; < 5
  IRQFlags              dw ?
  Reserved_IRQRES       dw ?            ; Alignment for 32 bit code
  pfnIntHandler         dd ?
IRQResource             EndS

; IRQResource.PCIIrqPin
RS_PCI_INT_NONE         equ 0           ; For completeness, on non-PCI box
RS_PCI_INT_A            equ 1
RS_PCI_INT_B            equ 2
RS_PCI_INT_C            equ 3
RS_PCI_INT_D            equ 4

; IRQResource.IRQFlags
RS_IRQ_EXCLUSIVE        equ 001h
RS_IRQ_MULTIPLEXED      equ 002h
RS_IRQ_SHARED           equ 004h
RS_IRQ_RECONFIGURE      equ 008h
RS_IRQ_GRANT_YIELD      equ 010h
RS_IRQ_ROUTER           equ 020h

; MEM Resource Structure
MemResource             Struc
  MemBase               dd ?
  MemSize               dd ?
  MemFlags              dw ?
  ReservedAlign         dw ?            ; Alignment for 32-bit code
MemResource             EndS

; MemResource.MemFlags
RS_MEM_EXCLUSIVE        equ 001h
RS_MEM_MULTIPLEXED      equ 002h
RS_MEM_SHARED           equ 004h
RS_MEM_RECONFIGURE      equ 008h
RS_MEM_GRANT_YIELD      equ 010h

; DMA Resource Structure
DMAResource             Struc
  DMAChannel            dw ?
  DMAFlags              dw ?
DMAResource             EndS

; DMAResource.DMAFlags
RS_DMA_EXCLUSIVE        equ 001h
RS_DMA_MULTIPLEXED      equ 002h
RS_DMA_SHARED           equ 004h
RS_DMA_RECONFIGURE      equ 008h
RS_DMA_GRANT_YIELD      equ 010h

; Timer Resource Structure
TMRResource             Struc
  TMRChannel            dw ?
  TMRFlags              dw ?
TMRResource             EndS

; TmrResource.TMRFlags
RS_TMR_EXCLUSIVE        equ 001h
RS_TMR_MULTIPLEXED      equ 002h
RS_TMR_SHARED           equ 004h

ResourceStruct          Struc
  ResourceType          dd ?
  resource_record       db 12 dup (?) ; IOResource/IRQResource/MEMResource/DMAResource/TMRResource
  Reserved_RESSTR       dd ?
ResourceStruct          EndS

; RMModifyResource Command
RM_MODIFY_ADD           equ 0
RM_MODIFY_DELETE        equ 1

; LDEV - Logical Device Structure

LDevStruct              Struc
  LDevDescriptName      dd ?
  LDevFlags             dw ?
  LDevClass             dw ?
  LDevHDevice           dd ?
  pAdjunctList_LD       dd ?
LDevStruct              EndS

; LDevStruct.LDevFlags
LDEV_CLASS_BASE         equ 0
LDEV_CLASS_ROOT         equ (LDEV_CLASS_BASE+1)
LDEV_CLASS_DASD         equ (LDEV_CLASS_BASE+2)
LDEV_CLASS_CDROM        equ (LDEV_CLASS_BASE+3)
LDEV_CLASS_SERIAL       equ (LDEV_CLASS_BASE+4)
LDEV_CLASS_PARALLEL     equ (LDEV_CLASS_BASE+5)
LDEV_CLASS_TAPE         equ (LDEV_CLASS_BASE+6)

NUM_LDEV_CLASSES        equ 6
MAX_LDEV_CLASSES        equ 10
NUM_DDCFG_TYPES         equ 2

; SYSNAME - System Name

SysNameStruct           Struc
  SysDescriptName       dd ?
  pAdjunctList_SNS      dd ?
  SysFlags              dw ?
  Reserved_SNS          dw ?
SysNameStruct           EndS

; DETECTED - Detected HW Function
RM_IDTYPE_RM            equ 0           ; Resource Manager Internal
RM_IDTYPE_EISA          equ 1           ; EISA (Also ISA PNP)
RM_IDTYPE_PCI           equ 2           ; PCI
RM_IDTYPE_LEGACY        equ 3           ; LEGACY

DetectedStruct          Struc
  DetectDescriptName    dd ?            ; Ascii name
  DetectFlags           dw ?            ; ???
  IDType                dd ?            ; EISA, PCI, etc..
  DeviceID              dd ?            ; EISA, PCI, etc.. ID
  FunctionID            dd ?            ; For multi-function hw
  CompatibleID          dd ?            ; Compatible Device
  pAdjunctList_DTS      dd ?
  VendorID              dd ?
  SerialNumber          dd ?
DetectedStruct          EndS

; DetectdStruct.DetectFlags
DS_PREVIOUS_BOOT        equ 1           ; Note: not settable externally

; Handle List Structure

HandleList              Struc
  cMaxHandles           dw ?
  cHandles              dw ?
  Handles_array         dd ? ; hAdapter
HandleList              EndS

ADJINFO                 Struc
  hAdapter_ADJI         dd ?
  AdjIndex_ADJI         dw ?
ADJINFO                 EndS

ADJHANDLELIST           Struc
  cMaxHandles           dw ?
  cHandles              dw ?
  Adj                   db (Size ADJINFO) dup (?) ; array of ADJINFO
ADJHANDLELIST           EndS

; PreAssigned Node Handles
HANDLE_PHYS_TREE         equ <DWord Ptr 0ffff8000h>
HANDLE_SYS_TREE          equ <DWord Ptr 0ffff8001h>
HANDLE_DEFAULT_SYSBUS    equ <DWord Ptr 0ffff8002h>
HANDLE_X_BUS             equ <DWord Ptr 0ffff8003h>
HANDLE_PCI_BUS           equ <DWord Ptr 0ffff8004h>
HANDLE_PREVIOUS_DETECTED equ <DWord Ptr 0ffff8005h>
HANDLE_CURRENT_DETECTED  equ <DWord Ptr 0ffff8006h>

; Handle Types
HANDLE_TYPE_INVALID     equ 0
HANDLE_TYPE_DRIVER      equ 1
HANDLE_TYPE_ADAPTER     equ 2
HANDLE_TYPE_DEVICE      equ 3
HANDLE_TYPE_RESOURCE    equ 4
HANDLE_TYPE_LOGDEV      equ 5
HANDLE_TYPE_SYSDEV      equ 6
HANDLE_TYPE_DETECTED    equ 7

; Search ID Flags
SEARCH_ID_DEVICEID      equ <DWord Ptr  1>
SEARCH_ID_FUNCTIONID    equ <DWord Ptr  2>
SEARCH_ID_COMPATIBLEID  equ <DWord Ptr  4>
SEARCH_ID_VENDOR        equ <DWord Ptr  8>
SEARCH_ID_SERIAL        equ <DWord Ptr 16>

; Convert ID
RM_CONVERT_TO_TEXT      equ 1
RM_CONVERT_TO_ID        equ 2

; SNOOPLEVEL definitions
SNP_NO_RISK             equ 0 ; "Vorige Hardware"
SNP_LOW_RISK            equ 1 ; "Entfernte Hardware"
SNP_MEDIUM_RISK         equ 2 ; "HinzugefÅgte Hardware"
SNP_HIGH_RISK           equ 3 ; "Gesamte Hardware"
SNP_WARP_RISK           equ 4 ; "Keine Hardwareerkennung"

SNP_FLG_NEXTBOOT        equ 1
SNP_FLG_DEFAULT         equ 2

; RMINFO Flag definitions
RM_SAVE_DEFAULT         equ 0
RM_DELETE_DEFAULT       equ 0

; Comon Keys
KEY_FIXDISK             equ "DISK_#      "
KEY_TAPE                equ "TAPE_#      "
KEY_PRINTER             equ "PRINTER_#      "
KEY_CPU                 equ "CPU_#      "
KEY_WORM                equ "WORM_#      "
KEY_CDROM               equ "CDROM_#      "
KEY_SCANNER             equ "SCANNER_#      "
KEY_OPTICAL_MEM         equ "OPTICAL_MEM_#      "
KEY_CHANGER             equ "CHANGER_#      "
KEY_COMM                equ "COMM_#      "
KEY_SCSI_UNKNOWN        equ "UNKNOWN_#      "

; DDtype for RMGetCommandLine
RM_CMD_BASE             equ 0
RM_CMD_DEVICE           equ 1


;****************************************************************************

; definitions from rmcalls.h

RMRC_SUCCESS                    equ 00000h
RMRC_NOTINITIALIZED             equ 00001h
RMRC_BAD_DRIVERHANDLE           equ 00002h
RMRC_BAD_ADAPTERHANDLE          equ 00003h
RMRC_BAD_DEVICEHANDLE           equ 00004h
RMRC_BAD_RESOURCEHANDLE         equ 00005h
RMRC_BAD_LDEVHANDLE             equ 00006h
RMRC_BAD_SYSNAMEHANDLE          equ 00007h
RMRC_BAD_DEVHELP                equ 00008h
RMRC_NULL_POINTER               equ 00009h
RMRC_NULL_STRINGS               equ 0000ah
RMRC_BAD_VERSION                equ 0000bh
RMRC_RES_ALREADY_CLAIMED        equ 0000ch
RMRC_DEV_ALREADY_CLAIMED        equ 0000dh
RMRC_INVALID_PARM_VALUE         equ 0000eh
RMRC_OUT_OF_MEMORY              equ 0000fh
RMRC_SEARCH_FAILED              equ 00010h
RMRC_BUFFER_TOO_SMALL           equ 00011h
RMRC_GENERAL_FAILURE            equ 00012h
RMRC_IRQ_ENTRY_ILLEGAL          equ 00013h
RMRC_NOT_IMPLEMENTED            equ 00014h
RMRC_NOT_INSTALLED              equ 00015h
RMRC_BAD_DETECTHANDLE           equ 00016h
RMRC_BAD_RMHANDLE               equ 00017h
RMRC_BAD_FLAGS                  equ 00018h
RMRC_NO_DETECTED_DATA           equ 00019h

;****************************************************************************

; some definitions from rmioctl.h

ResourceList                    Struc
  Count_RS                      dd ?
  Resource_Array                ResourceStruct <>       ; multiple..
ResourceList                    EndS

RM_Node_Struc                   Struc
  VersionInfo                   dd ?
  NodeType                      dd ?
  DriverHandle                  dd ?
  pNodeData                     dd ? ; pAdapterNode/pDeviceNode/pLDevNode/pSysNameNode/pDriver/pDetectStruct/pResource
  pResourceList                 dd ?
RM_Node_Struc                   EndS

RMTYPE_ADAPTER                  equ 0
RMTYPE_DEVICE                   equ 1
RMTYPE_LDEV                     equ 2
RMTYPE_SYSNAME                  equ 3
RMTYPE_DRIVER                   equ 4
RMTYPE_DETECTED                 equ 5
RMTYPE_RESOURCE                 equ 6

; RMGetNodeInfo

RM_GETNODE_DATA                 Struc
  RMNodeSize                    dd ?
  RMNode                        RM_Node_Struc <>
RM_GETNODE_DATA                 EndS


MAX_RESOURCES                   equ 10
MAX_TEXT_DATA                   equ 128

MAX_RM_NODE_SIZE                equ (Size RM_Node_Struc) + (Size AdapterStruct) + MAX_TEXT_DATA + (Size DriverStruct) + MAX_TEXT_DATA + (Size ResourceStruct) * MAX_RESOURCES


; EnumNodes function is not available via IDC..


