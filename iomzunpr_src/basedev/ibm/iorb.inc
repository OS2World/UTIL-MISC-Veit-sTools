;**************************************************************************
;*
;* SOURCE FILE NAME =  IORB.H
;*
;* DESCRIPTIVE NAME =  IORB defines the interface between Device Managers
;*                     and Adapter Device Drivers (ADDs).
;*
;* Copyright : COPYRIGHT IBM CORPORATION, 1991, 1992
;*             LICENSED MATERIAL - PROGRAM PROPERTY OF IBM
;*             REFER TO COPYRIGHT INSTRUCTION FORM#G120-2083
;*             RESTRICTED MATERIALS OF IBM
;*             IBM CONFIDENTIAL
;*
;* VERSION = V2.0
;*
;* DATE
;*
;* DESCRIPTION :
;*
;* Purpose:
;*
;*
;*
;*
;* FUNCTIONS  :
;*
;*
;*
;* NOTES      : See ..\OEMSPEC\OEMSPEC.ASC for further details.
;*
;*
;* STRUCTURES
;*
;* EXTERNAL REFERENCES
;*
;*
;*
;* EXTERNAL FUNCTIONS
;*
;* CHANGE ACTIVITY =
;*   DATE      FLAG        APAR   CHANGE DESCRIPTION
;*   --------  ----------  -----  --------------------------------------
;*
;*   08/04/92  @V51531     51531  Removable media control
;*   03/15/94  @V80754     80754  Add Format GAP length to IOCC_FORMAT
;*   05/05/94  @V82940     82940  Add Format BlockSize to IOCC_FORMAT
;*
;***************************************************************************

;
;* I/O Request Block (IORB) Structures
;
;       Resolve H2INC references for .INC version of file
;
;        include  iorbtype.inc

;  Typedefs to resolve forward references
;
;* Interface for calling ADD entry point
;  VOID FAR *(ADDEP) (PIORBH);
;
;* IORB Header
DM_WORKSPACE_SIZE       EQU     20
ADD_WORKSPACE_SIZE      EQU     16

IORBH   STRUC
IOH_Length      DW      ?                 ;  IORB Length
IOH_UnitHandle  DW      ?             ;  Unit Identifier
IOH_CommandCode DW      ?            ;  Command Code
IOH_CommandModifier     DW      ?        ;  Command Modifier
IOH_RequestControl      DW      ?         ;  Request Control Flags
IOH_Status      DW      ?                 ;  Status
IOH_ErrorCode   DW      ?              ;  Error Code
IOH_Timeout     DD      ?                ;  Cmd completion timeout (s)
IOH_StatusBlockLen      DW      ?         ;  Status block length
IOH_pStatusBlock        dw      ?       ;  Status block
IOH_Reserved_1  DW      ?             ;  Reserved, MBZ
IOH_pNxtIORB    DD      ?               ;  Pointer to next IORB
IOH_NotifyAddress       DD      ? ;  Notification Address
IOH_DMWorkSpace DB      DM_WORKSPACE_SIZE DUP (?)   ;  For use by DM
IOH_ADDWorkSpace        DB      ADD_WORKSPACE_SIZE DUP (?) ;  For use by ADD
IORBH   ENDS
;
;* IORB CommandCode and CommandModifier Codes.
;*      CommandCode prefixed by IOCC and CommandModifier by IOCM.
                                          ; ---------------------------
                                          ;  +----M=Manditory Support
                                          ;  |    O=Optional Support
                                          ;  |
                                          ;  V     Notes
                                          ; ---------------------------
IOCC_CONFIGURATION      EQU     0001H   ;
IOCM_GET_DEVICE_TABLE   EQU     0001H   ;  M
IOCM_COMPLETE_INIT      EQU     0002H   ;  O
                                          ; ---------------------------
IOCC_UNIT_CONTROL       EQU     0002H   ;
IOCM_ALLOCATE_UNIT      EQU     0001H   ;  M
IOCM_DEALLOCATE_UNIT    EQU     0002H   ;  M
IOCM_CHANGE_UNITINFO    EQU     0003H   ;  M
                                          ; ---------------------------
IOCC_GEOMETRY   EQU     0003H   ;
IOCM_GET_MEDIA_GEOMETRY EQU     0001H   ;  M
IOCM_SET_MEDIA_GEOMETRY EQU     0002H   ;  O (M) >1 Media type
IOCM_GET_DEVICE_GEOMETRY        EQU     0003H   ;  M
IOCM_SET_LOGICAL_GEOMETRY       EQU     0004H   ;  O (M) CHS Addressable
                                          ; ---------------------------
IOCC_EXECUTE_IO EQU     0004H   ;
IOCM_READ       EQU     0001H   ;  M
IOCM_READ_VERIFY        EQU     0002H   ;  M
IOCM_READ_PREFETCH      EQU     0003H   ;  O
IOCM_WRITE      EQU     0004H   ;  M
IOCM_WRITE_VERIFY       EQU     0005H   ;  M
                                          ; ---------------------------
IOCC_FORMAT     EQU     0005H   ;
IOCM_FORMAT_MEDIA       EQU     0001H   ;  O (M) If HW requires
IOCM_FORMAT_TRACK       EQU     0002H   ;  O (M) If HW requires
IOCM_FORMAT_PROGRESS    EQU     0003H   ;  O
                                          ; ---------------------------
IOCC_UNIT_STATUS        EQU     0006H   ;
IOCM_GET_UNIT_STATUS    EQU     0001H   ;  M
IOCM_GET_CHANGELINE_STATE       EQU     0002H   ;  M (O) Fixed Media Only
IOCM_GET_MEDIA_SENSE    EQU     0003H   ;  M
IOCM_GET_LOCK_STATUS    EQU     0004H   ;  O
                                          ; ---------------------------
IOCC_DEVICE_CONTROL     EQU     0007H   ;
IOCM_ABORT      EQU     0001H   ;  O (M) SCSI
IOCM_RESET      EQU     0002H   ;  O (M) SCSI
IOCM_SUSPEND    EQU     0003H   ;  O (M) Floppy Driver
IOCM_RESUME     EQU     0004H   ;  O (M) Floppy Driver
IOCM_LOCK_MEDIA EQU     0005H   ;  M (O) Fixed Media Only
IOCM_UNLOCK_MEDIA       EQU     0006H   ;  M (O) Fixed Media Only
IOCM_EJECT_MEDIA        EQU     0007H   ;  O (M) SCSI & Floppy driver
IOCM_GET_QUEUE_STATUS   EQU     0008H   ;  O (M) ATA/ATAPI Devices
                                          ;  @V51531
                                          ; ---------------------------
IOCC_ADAPTER_PASSTHRU   EQU     0008H   ;
IOCM_EXECUTE_SCB        EQU     0001H   ;  O
IOCM_EXECUTE_CDB        EQU     0002H   ;  O (M) SCSI Adapters
                                          ; ---------------------------
IOCC_RESOURCE   EQU     0009H   ;
IOCM_REPORT_RESOURCES   EQU     0001H   ;  O (M) ATA/ATAPI Devices
                                          ; ---------------------------
MAX_IOCC_COMMAND        EQU     IOCC_ADAPTER_PASSTHRU
;
;* Status flags returned in IORBH->Status
IORB_DONE       EQU     0001H   ;  1=Done,  0=In progress
IORB_ERROR      EQU     0002H   ;  1=Error, 0=No error
IORB_RECOV_ERROR        EQU     0004H   ;  Recovered error
IORB_STATUSBLOCK_AVAIL  EQU     0008H   ;  Status Block available
;
;* Error Codes returned in IORBH->ErrorCode
IOERR_RETRY     EQU     8000H
IOERR_CMD       EQU     0100H
IOERR_CMD_NOT_SUPPORTED EQU     IOERR_CMD+1
IOERR_CMD_SYNTAX        EQU     IOERR_CMD+2
IOERR_CMD_SGLIST_BAD    EQU     IOERR_CMD+3
IOERR_CMD_SW_RESOURCE   EQU     IOERR_CMD+IOERR_RETRY+4
IOERR_CMD_ABORTED       EQU     IOERR_CMD+5
IOERR_CMD_ADD_SOFTWARE_FAILURE  EQU     IOERR_CMD+6
IOERR_CMD_OS_SOFTWARE_FAILURE   EQU     IOERR_CMD+7
IOERR_UNIT      EQU     0200H
IOERR_UNIT_NOT_ALLOCATED        EQU     IOERR_UNIT+1
IOERR_UNIT_ALLOCATED    EQU     IOERR_UNIT+2
IOERR_UNIT_NOT_READY    EQU     IOERR_UNIT+3
IOERR_UNIT_PWR_OFF      EQU     IOERR_UNIT+4
IOERR_RBA       EQU     0300H
IOERR_RBA_ADDRESSING_ERROR      EQU     IOERR_RBA+IOERR_RETRY+1
IOERR_RBA_LIMIT EQU     IOERR_RBA+2
IOERR_RBA_CRC_ERROR     EQU     IOERR_RBA+IOERR_RETRY+3
IOERR_MEDIA     EQU     0400H
IOERR_MEDIA_NOT_FORMATTED       EQU     IOERR_MEDIA+1
IOERR_MEDIA_NOT_SUPPORTED       EQU     IOERR_MEDIA+2
IOERR_MEDIA_WRITE_PROTECT       EQU     IOERR_MEDIA+3
IOERR_MEDIA_CHANGED     EQU     IOERR_MEDIA+4
IOERR_MEDIA_NOT_PRESENT EQU     IOERR_MEDIA+5
IOERR_ADAPTER   EQU     0500H
IOERR_ADAPTER_HOSTBUSCHECK      EQU     IOERR_ADAPTER+1
IOERR_ADAPTER_DEVICEBUSCHECK    EQU     IOERR_ADAPTER+IOERR_RETRY+2
IOERR_ADAPTER_OVERRUN   EQU     IOERR_ADAPTER+IOERR_RETRY+3
IOERR_ADAPTER_UNDERRUN  EQU     IOERR_ADAPTER+IOERR_RETRY+4
IOERR_ADAPTER_DIAGFAIL  EQU     IOERR_ADAPTER+5
IOERR_ADAPTER_TIMEOUT   EQU     IOERR_ADAPTER+IOERR_RETRY+6
IOERR_ADAPTER_DEVICE_TIMEOUT    EQU     IOERR_ADAPTER+IOERR_RETRY+7
IOERR_ADAPTER_REQ_NOT_SUPPORTED EQU     IOERR_ADAPTER+8
IOERR_ADAPTER_REFER_TO_STATUS   EQU     IOERR_ADAPTER+9
IOERR_ADAPTER_NONSPECIFIC       EQU     IOERR_ADAPTER+10
IOERR_DEVICE    EQU     0600H
IOERR_DEVICE_DEVICEBUSCHECK     EQU     IOERR_DEVICE+IOERR_RETRY+1
IOERR_DEVICE_REQ_NOT_SUPPORTED  EQU     IOERR_DEVICE+2
IOERR_DEVICE_DIAGFAIL   EQU     IOERR_DEVICE+3
IOERR_DEVICE_BUSY       EQU     IOERR_DEVICE+IOERR_RETRY+4
IOERR_DEVICE_OVERRUN    EQU     IOERR_DEVICE+IOERR_RETRY+5
IOERR_DEVICE_UNDERRUN   EQU     IOERR_DEVICE+IOERR_RETRY+6
IOERR_DEVICE_RESET      EQU     IOERR_DEVICE+7
IOERR_DEVICE_NONSPECIFIC        EQU     IOERR_DEVICE+8
;
;* Request Control flags in IORBH->RequestControl
IORB_ASYNC_POST EQU     0001H    ;  Asynchronous post enabled
IORB_CHAIN      EQU     0002H    ;  IORB Chain Link enabled
IORB_CHS_ADDRESSING     EQU     0004H    ;  CHS fmt addr in RBA Field
IORB_REQ_STATUSBLOCK    EQU     0008H    ;  Obtain Status Block Data
IORB_DISABLE_RETRY      EQU     0010H    ;  Disable retries in ADD
;
;* ADAPTER CONFIGURNATION IORB         (for IOCC_CONFIGURATION)

IORB_CONFIGURATION      STRUC
IOCFG_iorbh     DB      SIZE IORBH DUP (?)               ;  IORB Header
IOCFG_pDeviceTable      DD      ?        ;  far ptr to adapter dev table
IOCFG_DeviceTableLen    DW      ?      ;  Length of adapter dev table
IORB_CONFIGURATION      ENDS
;  Adapter device table returned by GET_DEVICE_TABLE

DEVICETABLE     STRUC
IODT_ADDLevelMajor      DB      ?            ;  ADD Major Support Level
IODT_ADDLevelMinor      DB      ?            ;  ADD Minor Support Level
IODT_ADDHandle  DW      ?                ;  ADD Handle
IODT_TotalAdapters      DW      ?            ;  Number of adapters supported
IODT_pAdapter   DW      1 DUP (?)              ;  Array of adapter info pointers
DEVICETABLE     ENDS
;
;* Current ADD Level for DEVICETABLE->AddLevelMajor, AddLevelMinor
ADD_LEVEL_MAJOR EQU     01H
ADD_LEVEL_MINOR EQU     00H

UNITINFO        STRUC
IOUI_AdapterIndex       DW      ?              ;  nth Adapter this driver
IOUI_UnitIndex  DW      ?                 ;  nth Unit on this card
IOUI_UnitFlags  DW      ?                 ;  Unit Flags
IOUI_Reserved   DW      ?                  ;  Reserved
IOUI_UnitHandle DW      ?                ;  Assigned by ADD or Filter
IOUI_FilterADDHandle    DW      ?           ;  Handle of Filter ADD  0=None
IOUI_UnitType   DW      ?                  ;  Unit type
IOUI_QueuingCount       DW      ?              ;  Recommended number to queue
IOUI_UnitSCSITargetID   DB      ?          ;  SCSI Target ID  (SCSI Only)
IOUI_UnitSCSILUN        DB      ?               ;  SCSI Log.  Unit (SCSI Only)
UNITINFO        ENDS
;
;* Unit Flags for UNITINFO->UnitFlags
UF_REMOVABLE    EQU     0001H          ;  Media can be removed
UF_CHANGELINE   EQU     0002H          ;  ChangeLine Supported
UF_PREFETCH     EQU     0004H          ;  Supports prefetch reads
UF_A_DRIVE      EQU     0008H          ;  Manages A:
UF_B_DRIVE      EQU     0010H          ;  Manages B:
UF_NODASD_SUPT  EQU     0020H          ;  Suppress DASD Mgr support
UF_NOSCSI_SUPT  EQU     0040H          ;  Suppress SCSI Mgr support
UF_DEFECTIVE    EQU     0080H          ;  Device is defective
;
;* Unit Types for UNITINFO->UnitType
UIB_TYPE_DISK   EQU     0000H      ;  All Direct Access Devices
UIB_TYPE_TAPE   EQU     0001H      ;  Sequencial Access Devices
UIB_TYPE_PRINTER        EQU     0002H      ;  Printer Device
UIB_TYPE_PROCESSOR      EQU     0003H      ;  Processor type device
UIB_TYPE_WORM   EQU     0004H      ;  Write Once Read Many Device
UIB_TYPE_CDROM  EQU     0005H      ;  CD ROM Device
UIB_TYPE_SCANNER        EQU     0006H      ;  Scanner Device
UIB_TYPE_OPTICAL_MEMORY EQU     0007H  ;  some Optical disk
UIB_TYPE_CHANGER        EQU     0008H      ;  Changer device e.g. juke box
UIB_TYPE_COMM   EQU     0009H      ;  Communication devices
UIB_TYPE_ATAPI  EQU     000AH      ;  Unspecific ATAPI protocol device

ADAPTERINFO     STRUC
IOAI_AdapterName        DB      17 DUP (?)       ;  Adapter Name ASCIIZ string
IOAI_Reserved   DB      ?              ;
IOAI_AdapterUnits       DW      ?          ;  Number of units this adapter
IOAI_AdapterDevBus      DW      ?         ;  Bus Type - Adapter to Device
IOAI_AdapterIOAccess    DB      ?       ;  I/O Type - Adapter to Host
IOAI_AdapterHostBus     DB      ?        ;  Bus Type - Adapter to Host
IOAI_AdapterSCSITargetID        DB      ?   ;  Adapter SCSI Target ID
IOAI_AdapterSCSILUN     DB      ?        ;  Adapter SCSI LUN
IOAI_AdapterFlags       DW      ?
IOAI_MaxHWSGList        DW      ?           ;  Max HW S/G List Entries
IOAI_MaxCDBTransferLength       DD      ?  ;  Max data length for CDBs
IOAI_UnitInfo   DB      SIZE UNITINFO * 1 DUP (?)           ;  Unit info for each unit
ADAPTERINFO     ENDS
;
;* Adapter Flags for ADAPTERINFO->AdapterFlags
AF_16M  EQU     0001H   ;  Supports >16M addresses
AF_IBM_SCB      EQU     0002H   ;  Supports IBM SCB commands
AF_HW_SCATGAT   EQU     0004H   ;  Supports scatter/gather in HW
AF_CHS_ADDRESSING       EQU     0008H   ;  Supports CHS addressing in HW
AF_ASSOCIATED_DEVBUS    EQU     0010H   ;  Supports >1 Device Bus
;
;* Adapter-to-Device protocol for ADAPTERINFO->AdapterDevBus
AI_DEVBUS_OTHER EQU     0000H
AI_DEVBUS_ST506 EQU     0001H  ;  ST-506 CAM-I
AI_DEVBUS_ST506_II      EQU     0002H  ;  ST-506 CAM-II
AI_DEVBUS_ESDI  EQU     0003H  ;  ESDI
AI_DEVBUS_FLOPPY        EQU     0004H  ;  Diskette
AI_DEVBUS_SCSI_1        EQU     0005H
AI_DEVBUS_SCSI_2        EQU     0006H
AI_DEVBUS_SCSI_3        EQU     0007H
AI_DEVBUS_NONSCSI_CDROM EQU     0008H  ;  Non-scsi CD-ROM interface bus
;
;* Note: A one of the following BUS WIDTH indicators should be
;*       or'd with the above field.
AI_DEVBUS_FAST_SCSI     EQU     0100H
AI_DEVBUS_8BIT  EQU     0200H
AI_DEVBUS_16BIT EQU     0400H
AI_DEVBUS_32BIT EQU     0800H
;
;* Adapter-to-Device protocol for ADAPTERINFO->AdapterIOAccess
AI_IOACCESS_OTHER       EQU     00H
AI_IOACCESS_BUS_MASTER  EQU     01H
AI_IOACCESS_PIO EQU     02H
AI_IOACCESS_DMA_SLAVE   EQU     04H
AI_IOACCESS_MEMORY_MAP  EQU     08H
;
;* Adapter-to-Host bus type for ADAPTERINFO->AdapterHostBus
AI_HOSTBUS_OTHER        EQU     00H
AI_HOSTBUS_ISA  EQU     01H
AI_HOSTBUS_EISA EQU     02H
AI_HOSTBUS_uCHNL        EQU     03H
AI_HOSTBUS_UNKNOWN      EQU     0fH
;
;* Note: A one of the following BUS WIDTH indicators should be
;*       or'd with the above field.
AI_BUSWIDTH_8BIT        EQU     10H
AI_BUSWIDTH_16BIT       EQU     20H
AI_BUSWIDTH_32BIT       EQU     30H
AI_BUSWIDTH_64BIT       EQU     40H
AI_BUSWIDTH_UNKNOWN     EQU     0f0H
;
;* UNIT CONTROL IORB                  (for IOCC_UNIT_CONTROL)

IORB_UNIT_CONTROL       STRUC
IOUC_iorbh      DB      SIZE IORBH DUP (?)                ;  IORB Header
IOUC_Flags      DW      ?                ;
IOUC_pUnitInfo  DD      ?            ;  For: IOCM_CHANGE_UNITINFO
IOUC_UnitInfoLen        DW      ?          ;  Length of UnitInfo structure
IORB_UNIT_CONTROL       ENDS
;
;* DASD GEOMETRY IORB                      (for IOCC_GEOMETRY)

IORB_GEOMETRY   STRUC
IOGG_iorbh      DB      SIZE IORBH DUP (?)                ;  IORB Header
IOGG_pGeometry  DD      ?            ;  far ptr to GEOMETRY block
IOGG_GeometryLen        DW      ?          ;  Length of GEOMETRY block
IORB_GEOMETRY   ENDS

GEOMETRY        STRUC
IOG_TotalSectors        DD      ?
IOG_BytesPerSector      DW      ?
IOG_Reserved    DW      ?
IOG_NumHeads    DW      ?
IOG_TotalCylinders      DD      ?
IOG_SectorsPerTrack     DW      ?
GEOMETRY        ENDS
;
;* Scatter/Gather List Entry

SCATGATENTRY    STRUC
IOSG_ppXferBuf  DD      ?           ;  Physical pointer to transfer buffer
IOSG_XferBufLen DD      ?          ;  Length of transfer buffer
SCATGATENTRY    ENDS
MAXSGLISTSIZE   EQU     (SIZE   SCATGATENTRY ) * 16
;
;* EXECUTE_IO IORB                    (for IOCC_EXECUTE_IO)

IORB_EXECUTEIO  STRUC
IOXIO_iorbh     DB      SIZE IORBH DUP (?)                       ;  IORB Header
IOXIO_cSGList   DW      ?                     ;  Count of S/G list elements
IOXIO_pSGList   DD      ?                     ;  far ptr to S/G List
IOXIO_ppSGList  DD      ?                    ;  physical addr of  S/G List
IOXIO_RBA       DD      ?                         ;  RBA Starting Address
IOXIO_BlockCount        DW      ?                  ;  Block Count
IOXIO_BlocksXferred     DW      ?               ;  Block Done Count
IOXIO_BlockSize DW      ?                   ;  Size of a block in bytes
IOXIO_Flags     DW      ?
IORB_EXECUTEIO  ENDS
;
;* CHS Direct Addressing (Overlays RBA field)

CHS_ADDR        STRUC
IOCHS_Cylinder  DW      ?
IOCHS_Head      DB      ?
IOCHS_Sector    DB      ?
CHS_ADDR        ENDS
;
;* IORB specific flags for IORB_EXECUTE_IO->Flags
XIO_DISABLE_HW_WRITE_CACHE      EQU     0001H
XIO_DISABLE_HW_READ_CACHE       EQU     0002H
;
;* FORMAT IORB                        (for IOCC_FORMAT)

IORB_FORMAT     STRUC
IOFMT_iorbh     DB      SIZE IORBH DUP (?)                       ;  IORB Header
IOFMT_cSGList   DW      ?                     ;  Count of S/G list elements
IOFMT_pSGList   DD      ?                     ;  far ptr to S/G List
IOFMT_ppSGList  DD      ?                    ;  physical addr of  S/G List
IOFMT_FormatCmdLen      DW      ?                ;
IOFMT_pFormatCmd        dd      ?                  ;  SCSI CDB or Track Fmt Cmd
IOFMT_Reserved_1        DB      8 DUP (?)               ;  Reserved, must not be modified
IORB_FORMAT     ENDS

FORMAT_CMD_TRACK        STRUC
FMCT_Flags      DW      ?
FMCT_RBA        DD      ?
FMCT_cTrackEntries      DW      ?
FMCT_FmtGapLength       DW      ?                                        ; @V80754
FMCT_BlockSize  DW      ?                                           ; @V82940
FORMAT_CMD_TRACK        ENDS
;
;* Flags for FORMAT_CMD_TRACK->Flags
FF_VERIFY       EQU     0001H           ;  Verify sectors after formatting
FF_FMTGAPLEN    EQU     0002H           ;  InterSector GAP (bits)             /*V80754*/
;
;* ADAPTER PASS THROUGH IORB           (for IOCC_ADAPTER_PASSTHRU)

IORB_ADAPTER_PASSTHRU   STRUC
IOPT_iorbh      DB      SIZE IORBH DUP (?)                       ;  IORB Header
IOPT_cSGList    DW      ?                     ;  Count of S/G list elements
IOPT_pSGList    DD      ?                     ;  far ptr to S/G List
IOPT_ppSGLIST   DD      ?                    ;  physical addr of  S/G List
IOPT_ControllerCmdLen   DW      ?
IOPT_pControllerCmd     dd      ?
IOPT_ppSCB      DD      ?              ;  phys ptr to SCB for SCB_PASSTHRU
IOPT_Flags      DW      ?
IORB_ADAPTER_PASSTHRU   ENDS
;
;* IORB specific flags for IORB_ADAPTER_PASSTHRU->Flags
;*
;* Note: These flags apply to IOCM_EXECUTE_CDB
PT_DIRECTION_IN EQU     0001H            ;  Data xfer to host adapter
;
;* UNIT STATUS IORB                   (for IOCC_UNIT_STATUS)

IORB_UNIT_STATUS        STRUC
IOUS_iorbh      DB      SIZE IORBH DUP (?)
IOUS_UnitStatus DW      ?
IORB_UNIT_STATUS        ENDS
;
;* Unit Status for IORB_UNIT_STATUS->UnitStatus
;*
;* Note: These flags apply to IOCM_GET_UNIT_STATUS
US_READY        EQU     0001H           ;  Unit ready
US_POWER        EQU     0002H           ;  Unit powered on
US_DEFECTIVE    EQU     0004H           ;  Unit operational
;
;* Unit Status for IORB_UNIT_STATUS->UnitStatus
;*
;* Note: These flags apply to IOCM_GET_CHANGELINE_STATE
US_CHANGELINE_ACTIVE    EQU     0001H           ;  ChangeLine State
;
;* Unit Status for IORB_UNIT_STATUS->UnitStatus
;*
;* Note: These flags apply to IOCM_GET_MEDIA_SENSE
US_MEDIA_UNKNOWN        EQU     0000H           ;  Unable to determine media
US_MEDIA_720KB  EQU     0001H           ;  720KB in 3.5" drive
US_MEDIA_144MB  EQU     0002H           ;  1.44MB in 3.5" drive
US_MEDIA_288MB  EQU     0003H           ;  2.88MB in 3.5" drive
;
;* Unit Status for IORB_UNIT_STATUS->UnitStatus
;*
;* Note: These flags apply to IOCM_GET_LOCK_STATE
US_LOCKED       EQU     0001H           ;  Unit locked - @V51531
;
;* DEVICE CONTROL IORB                (for IOCC_DEVICE_CONTROL

IORB_DEVICE_CONTROL     STRUC
IODC_iorbh      DB      SIZE IORBH DUP (?)                       ;  IORB Header
IODC_Flags      DW      ?
IODC_Reserved   DW      ?
IODC_QueueStatus        DD      ?
IORB_DEVICE_CONTROL     ENDS
;
;* IORB specific flags for IORB_DEVICE_CONTROL->Flags
;*
;* Note: These flags apply to IOCM_SUSPEND
DC_SUSPEND_DEFERRED     EQU     0000H           ;  Suspend after device idle
DC_SUSPEND_IMMEDIATE    EQU     0001H           ;  Suspend after current req
MAX_IORB_SIZE   EQU     128
;
;* RESOURCE IORB                   (for IOCC_RESOURCE)

IORB_RESOURCE   STRUC
IORS_iorbh      DB      SIZE IORBH DUP (?)
IORS_Flags      DW      ?
IORS_ResourceEntryLen   DW      ?
IORS_pResourceEntry     DD      ?
IORB_RESOURCE   ENDS

RESOURCE_ENTRY  STRUC
RE_Max_Resource_Entry   DW      ?
RE_cDMA_Entries DW      ?   ;  Number of DMA entries
RE_npDMA_Entry  DW      ?    ;  Near pointer to DMA resource entry
                                   ;  array
RE_cIRQ_Entries DW      ?   ;  Number of IRQ entries
RE_npIRQ_Entry  DW      ?    ;  Near pointer to IRQ resource entry
                                   ;  array
RE_cPort_Entries        DW      ?  ;  Number of Port entries
RE_npPort_Entry DW      ?   ;  Near pointer to Port Range resource
                                   ;  entry array
RE_cMemory_Entries      DW      ?;  Number of Memory entries
RE_npMemory_Entry       DW      ? ;  Near pointer to Memory map resource
                                   ;  entry array
RE_cPCI_IRQ_Entries     DW      ?;  Number of PCI IRQ entries
RE_npPCI_IRQ_Entry      DW      ?;  Near pointer to PCI IRQ resource entry
RE_Reserved     DD      4 DUP (?)    ;  Reserved (Must be zero)
RESOURCE_ENTRY  ENDS
;  Max_Resource_Entry will have one of these values.
RE_DMA  EQU     1
RE_IRQ  EQU     2
RE_PORT EQU     3
RE_MEMORY       EQU     4
RE_PCI_IRQ      EQU     5
;  Global Resource Entry Flags
RE_ADAPTER_RESOURCE     EQU     1000H   ;  Resource is shared by units on an
                                     ;  adapter
RE_SYSTEM_RESOURCE      EQU     2000H   ;  Resource is shared by multiple
                                     ;  adapters
RE_RESOURCE_CONFLICT    EQU     4000H   ;  Indicates resource is in conflict
                                     ;  with another unit's resources

DMA_ENTRY       STRUC
DE_DMA_Flags    DW      ?              ;  DMA Flags
DE_DMA_Width    DW      ?              ;  DMA Width
DE_DMA_Type     DW      ?               ;  DMA Type
DE_DMA_Channel  DW      ?            ;  DMA Channel
DE_DMA_Arbitration_Level        DW      ?  ;  uChannel only
DMA_ENTRY       ENDS
;  Resource entry DMA flags
RE_DMA_BUS_MASTER       EQU     0001H  ;  set for Bus Master
;  Resource entry DMA width values
RE_DMA_WIDTH_8_BIT      EQU     1  ;  set if 8 bit
RE_DMA_WIDTH_16_BIT     EQU     2  ;  set if 16 bit
;  Resource entry DMA types
RE_DMA_TYPE_A   EQU     1  ;  Type A DMA
RE_DMA_TYPE_B   EQU     2  ;  Type B DMA
RE_DMA_TYPE_F   EQU     3  ;  Type F DMA

IRQ_ENTRY       STRUC
IE_IRQ_Flags    DW      ?       ;  IRQ Flags
IE_IRQ_Value    DW      ?       ;  IRQ Line
IRQ_ENTRY       ENDS
;  Resource entry IRQ flags
IRQ_RISING_EDGE_TRIGGERED       EQU     0001H  ;  ISA Standard
IRQ_FALLING_EDGE_TRIGGERED      EQU     0002H
IRQ_LOW_LEVEL_TRIGGERED EQU     0004H
IRQ_HIGH_LEVEL_TRIGGERED        EQU     0008H

PORT_ENTRY      STRUC
PE_Port_Flags   DW      ?      ;  Port Flags
PE_StartPort    DW      ?       ;  Start port of port range
PE_cPorts       DW      ?          ;  Number of Byte size ports in range
PORT_ENTRY      ENDS

MEMORY_ENTRY    STRUC
ME_Memory_Flags DW      ?    ;  Memory Flags
ME_Memory_Width DW      ?    ;  Memory Width
ME_StartMemory  DD      ?     ;  Start address of memory range
ME_cMemory      DW      ?         ;  Number of bytes in Memory range
MEMORY_ENTRY    ENDS
;  Resource entry Memory flags
MEMORY_WRITEABLE        EQU     0001H   ;  memory is writable
MEMORY_CACHEABLE        EQU     0002H   ;  read cacheable, write-through
MEMORY_SHADOWABLE       EQU     0004H   ;  memory is shadowable
MEMORY_ROM      EQU     0008H   ;  memory is an expansion ROM
;  Resource entry Memory width values
MEMORY_8_BIT    EQU     1   ;  8 bit memory
MEMORY_16_BIT   EQU     2   ;  16 bit memory

PCI_IRQ_ENTRY   STRUC
PCI_PCI_IRQ_Flags       DW      ?   ;  PCI IRQ Flags
PCI_PCI_IRQ_Value       DW      ?   ;  PCI IRQ Line
PCI_IRQ_ENTRY   ENDS
