Title           Communication with Resource Manager - init data

NameResmgrDD    db 'RESMGR$ ',0                 ; the space char is needed

IDC_ResmgrDD    dw 0                            ; Reserved
                dw 0                            ; Reserved
ResmgrIDC_CS_R3 dw 0                            ; R3 IDC CS "Reserved"
ResmgrIDC_CS_R0 dw 0                            ; R0 IDC IP
ResmgrIDC_IP_R0 dw 0                            ; R0 IDC CS
                dw 0                            ; R0 IDC DS

                public DrvrFileName
DrvrFileName    db 128 dup (0)                  ; driver filename

DrvrDescript    db 'Set PCI IRQ',0

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
                dw DRT_SERVICE                  ; DrvrType
                dw DRS_CONFIG                   ; DrvrSubType
                dd 0                            ; DrvrCallback
