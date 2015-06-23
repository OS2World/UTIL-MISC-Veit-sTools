Title           Communication with Resource Manager - data

RM_Help0        dd 0
RM_Help3        dd 0
                
hDriver         dd -1                           ; handle to resource maneger                

;****************************************************************************

; definitions from rmbase.h

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


RS_TYPE_IO              equ 1
RS_TYPE_IRQ             equ 2
RS_TYPE_MEM             equ 3
RS_TYPE_DMA             equ 4
RS_TYPE_TIMER           equ 5

RS_IO_EXCLUSIVE         equ 00001h
RS_IO_MULTIPLEXED       equ 00002h
RS_IO_SHARED            equ 00004h
RS_IO_RECONFIGURE       equ 00008h
RS_IO_GRANT_YIELD       equ 00010h
RS_IO_FORCE_ALIAS       equ 00020h
RS_SEARCH               equ 04000h
RS_NONOWNER_ALLOWED     equ 08000h

RS_PCI_INT_NONE         equ 0
RS_PCI_INT_A            equ 1
RS_PCI_INT_B            equ 2
RS_PCI_INT_C            equ 3
RS_PCI_INT_D            equ 4

RS_IRQ_EXCLUSIVE        equ 001h
RS_IRQ_MULTIPLEXED      equ 002h
RS_IRQ_SHARED           equ 004h
RS_IRQ_RECONFIGURE      equ 008h
RS_IRQ_GRANT_YIELD      equ 010h
RS_IRQ_ROUTER           equ 020h

ADJ_SCSI_TARGET_LUN     equ 1
ADJ_ADAPTER_NUMBER      equ 2
ADJ_DEVICE_NUMBER       equ 3
ADJ_PCI_DEVFUNC         equ 4
ADJ_MODEL_INFO          equ 5
ADJ_ADD_UNIT            equ 6
ADJ_DASD_VOL            equ 7
ADJ_DRIVER_DATA         equ 8


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


RS_MEM_EXCLUSIVE        equ 1
RS_MEM_MULTIPLEXED      equ 2
RS_MEM_SHARED           equ 4
RS_MEM_RECONFIGURE      equ 8
RS_MEM_GRANT_YIELD      equ 16

HANDLE_PHYS_TREE         equ <DWord Ptr 0ffff8000h>
HANDLE_SYS_TREE          equ <DWord Ptr 0ffff8001h>
HANDLE_DEFAULT_SYSBUS    equ <DWord Ptr 0ffff8002h>
HANDLE_X_BUS             equ <DWord Ptr 0ffff8003h>
HANDLE_PCI_BUS           equ <DWord Ptr 0ffff8004h>
HANDLE_PREVIOUS_DETECTED equ <DWord Ptr 0ffff8005h>
HANDLE_CURRENT_DETECTED  equ <DWord Ptr 0ffff8006h>

;****************************************************************************


