Title   Setup variables: detect network adapter

;--------------------------------------------------------------------

networkadaptertable_begin:

;* nic_drivernames (OS2) (NIF) (Description) (shipped on eCS DEMO cd)
;*   dw VendorID,DeviceID,SubvendorID,SubdeviceID
;*   dw 0

;อ[..Generic]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "genm32" "genm32" "MyWis General Mac Driver" false
; dw 01039h,00900h,-1,-1 ; SIS 900 Ethernet -> SIS90A
  dw 010deh,00066h,-1,-1 ; nForce2 Ethernet
  dw 010deh,000d6h,-1,-1 ; nForce3 Ethernet
  dw 010deh,001c3h,-1,-1 ; nForce Ethernet
; dw 0100bh,00022h,-1,-1 ; NS-DP83820 Gigabit -> "DP83820"/"DP820A"
  dw 010b7h,09200h,-1,-1 ; 3C905C-TX Fast Etherlink for PC Management NIC
  dw 010b7h,09201h,-1,-1 ; 3C920B-EMB Integrated Fast Ethernet Controller
  dw 010b7h,05055h,-1,-1 ; 3c555 Laptop Hurricane
  dw 010b7h,06055h,-1,-1 ; 3C556 10/100 Mini PCI Fast Ethernet Adapter
  dw 010b7h,06056h,-1,-1 ; 3C556 10/100 Mini PCI Fast Ethernet Adapter
  dw 010b7h,01700h,-1,-1 ; 3Com 3C2000 GIGA
; dw 010ech,08169h,-1,-1 ; Realtek 8169s/8110s -> rtgnda
  dw 0

;อ[3Com]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

;*!! ELNK3 is ISA:  3Com OS/2 EtherLink 10 ISA (3C509b) Network Driver v3.1
;*nic_drivernames "ELNK3" "EL3IBMO2" "3Com - 3Com EtherLink III Family OS/2"
;*  dw 010B7h,05900h,-1,-1
;*  dw 0
;* EISA ID: TCM5090 TCM5091 TCM5092 TCM5093 TCM5094 TCM5095 TCM5098

; driver checks for VendorID 10b7 and (DeviceID and ff00)=5900
; orginaly known was 5950
; EISAID TCM5920 TCM5970
nic_drivernames "EL59X" "EL59XIO2" "3Com - 3Com Fast EtherLink & EtherLink III Bus Master Family OS/2 (3C59X)" true
  dw 010B7h,05900h,-1,-1 ; ? 3C590 PCI Ethernet Adapter 10bT
  dw 010B7h,05920h,-1,-1 ; ? 3c592 PCI/EISA 10Mb Demon/Vortex
  dw 010B7h,05950h,-1,-1 ;   3C595 PCI Ethernet Adapter 100bTX
  dw 010B7h,05951h,-1,-1 ; ? 3C595 PCI Ethernet Adapter 100bT4
  dw 010B7h,05952h,-1,-1 ; ? 3C595 PCI Ethernet Adapter 100b-MII
  dw 010B7h,05970h,-1,-1 ; ? 3C597 PCI/EISA 10/100 Demon/Vortex
  dw 0

; driver checks for VendorID 10b7 and (DeviceID and ff00)=9000
; orginaly known was 9050
; driver from 2001-06-29 checks for complete numbers and includes 9200,9800,9805
nic_drivernames "EL90X" "EL90XIO2" "3Com - 3Com Fast EtherLink/EtherLink XL Family OS/2 (3C90x)" true
  dw 010B7h,09000h,-1,-1 ; ? 3C900-TPO Fast Ethernet
  dw 010B7h,09001h,-1,-1 ; ? 3C900-Combo Fast Etherlink
  dw 010B7h,09004h,-1,-1 ; ? 3C900B-TPO Etherlink XL TPO 10Mb
  dw 010B7h,09005h,-1,-1 ; ? 3C900B-Combo Etherlink XL Combo
  dw 010B7h,09006h,-1,-1 ; ? 3C900B-TPC Etherlink XL TPC
  dw 010B7h,0900Ah,-1,-1 ; ? 3C900B-FL Etherlink XL FL
  dw 010B7h,09050h,-1,-1 ;   3C905-TX Fast Etherlink 10/100
  dw 010B7h,09051h,-1,-1 ; ? 3C905-T4 Fast Etherlink XL 10/100
  dw 010B7h,09055h,-1,-1 ; ? 3C905B Fast Etherlink XL 10/100
  dw 010B7h,09056h,-1,-1 ; ? 3c905B-T4 Fast Etherlink XL 10/100
  dw 010B7h,09058h,-1,-1 ; ? 3C905B-Combo Deluxe Etherlink XL 10/100
  dw 010B7h,0905Ah,-1,-1 ; ? 3C905B-FX Fast Etherlink XL FX 10/100
  dw 010B7h,09200h,-1,-1 ; ! 3C905C-TX Fast Etherlink for PC Management NIC
  dw 010B7h,09800h,-1,-1 ; ! 3C980-TX Fast Etherlink XL Server Adapter
  dw 010B7h,09805h,-1,-1 ; ! 3C980-TX 10/100baseTX NIC [Python-T]
  dw 0

nic_drivernames "TL3C3X9" "TL3C3X9" "3Com 3C3X9 PCI Token-Ring Adapter" true
  dw 010b7h,03390h,-1,-1 ; 3C339 Token Link Velocity
  dw 00e11h,03390h,-1,-1 ; something from Compaq Computer Corp
  dw 0

; 3c359b2x.exe
nic_drivernames "TLPN2" "TLPN2" "3Com TokenLink Velocity PCI XL Adapter" false
  dw 010b7h,03590h,-1,-1 ;
  dw 0

;อ[ACCTON]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

;??nic_drivernames "EN5251" "EN5251" "ACCTON EN5251 Based Fast Ethernet Adapter" false
nic_drivernames "SMC1255" "SMC1255" "ACCTON EN5251 Based Fast Ethernet Adapter" false
  dw 01113h,01216h,-1,-1 ; type 0
; dw 01011h,00009h,-1,-1 ; type 1 - DEC 21140
; dw 01011h,00019h,-1,-1 ; type 2 - DEC 21143/2
  dw 0

;อ[Admtek]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "COMETA" "COMETA" "ADMtek Comet/Centaur" true
  ; cometa01.zip: ADMtek Comet/Centaur Another MAC driver
  ; V   1317    ADMtek
  ; V   1259    Allied Telesyn International
  dw 01317h,00985h,-1,-1 ; AN983 centaur
  dw 01317h,00981h,-1,-1 ; AL981 comet
  dw 01259h,0a120h,-1,-1 ; corega
  dw 0

nic_drivernames "FASTNIC" "FASTNIC" "ADMtek - PCI 10/100 Fast Ethernet Adapter" false
  ; +Bridgecom - Linksys LNE100TX Fast Ethernet Adapter(V4.1+)
  dw 01317h,00981h,-1,-1 ; type 0 - AN981
  dw 01317h,00985h,-1,-1 ; type 3 - AN983
  dw 01317h,01985h,-1,-1 ; type 3 - AM985 Comet Ethernet Adapter
  dw 01317h,09511h,-1,-1 ; type 3 - AM9511 Ethernet Adapter
  dw 01317h,09513h,-1,-1 ; type 3 - AM9513 Ethernet Adapter
; dw 01011h,00009h,-1,-1 ; type 1 - DecChip 21140 Fast Ethernet Adapter
  dw 0

;อ[AMD]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

; older: ibmeandi.os2
nic_drivernames "PCNTND" "PCNTND" "AMD - AMD PCnet Ethernet Family Adapter" true
  dw 01022h,02000h,-1,-1
  dw 0

;อ[ASIX]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

; Longshine 8038rtx4.exe\MSLANMAN.OS2\AX814X.NIF
nic_drivernames "AX814X" "AX814X" "ASIX AX8814X Based PCI Fast Ethernet Adapter" false
  dw 0125bh,01400h,-1,-1
  dw 0

;อ[Broadcom]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

; broadcom_netxtreme_gigabit.zip
; http://www.broadcom.com/docs/driver_download/570x/ndis2_os2-7.65.zip
; updated for 7.72
; updated for 8.19
nic_drivernames "B57" "B57" "Broadcom Corporation 10/100/1000 NetXtreme Ethernet" false
  dw 014e4h,0166Ah,-1,-1 ; 8.28
  dw 014e4h,0166Bh,-1,-1 ; 8.28
  dw 014e4h,01600h,-1,-1 ; 8.19
  dw 014e4h,01601h,-1,-1 ; 8.19
  dw 014e4h,01678h,-1,-1 ; 8.28
  dw 014e4h,01668h,-1,-1 ; 8.28
  dw 014e4h,016F7h,-1,-1 ; 7.72
  dw 014e4h,016FDh,-1,-1 ; 7.72
  dw 014e4h,016FEh,-1,-1 ; 7.72
  dw 014e4h,016DDh,-1,-1 ; 7.72
  dw 014e4h,0169Dh,-1,-1
  dw 014e4h,0167Eh,-1,-1
  dw 014e4h,0167Dh,-1,-1
  dw 014e4h,0167Ch,-1,-1
  dw 014e4h,01677h,-1,-1
  dw 014e4h,01676h,-1,-1
  dw 014e4h,01659h,-1,-1
  dw 014e4h,01658h,-1,-1
  dw 014e4h,0166Eh,-1,-1
  dw 014e4h,0169Ch,-1,-1
  dw 014e4h,016C7h,-1,-1
  dw 014e4h,016C6h,-1,-1
  dw 014e4h,01696h,-1,-1
  dw 014e4h,0166Dh,-1,-1
  dw 014e4h,016A8h,-1,-1
  dw 014e4h,0170Eh,-1,-1
  dw 014e4h,0170Dh,-1,-1
  dw 014e4h,0165Eh,-1,-1
  dw 014e4h,0165Dh,-1,-1
  dw 014e4h,01654h,-1,-1
  dw 014e4h,01653h,-1,-1
  dw 014e4h,016A7h,-1,-1
  dw 014e4h,016A6h,-1,-1
  dw 014e4h,0164Dh,-1,-1
  dw 014e4h,01648h,-1,-1
  dw 014e4h,01647h,-1,-1
  dw 014e4h,01646h,-1,-1
  dw 014e4h,01645h,-1,-1
  dw 014e4h,01644h,-1,-1
  dw 0

; b44a02.zip: Broadcom BCM4401 OS/2 NDIS 2.0.1 MAC driver 1.02
; http://www.os2warp.be/gigabit/gomi/b44a02.zip
nic_drivernames "b44a" "b44a" "Broadcom BCM4401 MAC driver" true
  ; taken from DrvInit.asm
  dw 014e4h,04401h,-1,-1        ; BCM4401
  dw 014e4h,04402h,-1,-1        ; BCM4401B0
  dw 014e4h,0170ch,-1,-1        ; BCM4401B0
  dw 0

;อ[Compex]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

; ri990326.zip\ri990326.exe\NDIS2\RL2000.OS2
nic_drivernames "RL2000" "RL2000" "Compex RL2000 PCI Ethernet Adapter" true
  dw 011f6h,01401h,-1,-1
  dw 0

;อ[Compaq]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "NETFLX3" "NETFLX3" "Compaq" false
  dw 00e11h,0AE32h,-1,-1 ; 10/100 TX PCI UTP Controller
  dw 00e11h,0AE34h,-1,-1 ; 10 T PCI UTP Controller
  dw 00e11h,0AE35h,-1,-1 ; Integrated 10/100 TX UTP Controller
  dw 00e11h,0AE40h,-1,-1 ; Dual 10/100 TX PCI UTP Controller
  dw 00e11h,0AE43h,-1,-1 ; Integrated 10/100 TX UTP Controller
  dw 00e11h,0B011h,-1,-1 ; Netelligent 10/100 TX Embedded UTP Controller
  dw 00e11h,0B012h,-1,-1 ; Netelligent 10 T/2 PCI UTP/Coax Controller
  dw 00e11h,0B030h,-1,-1 ; + Netelligent 10/100 TX Embedded UTP/Coax Controller (5100)
  dw 00e11h,0f120h,-1,-1 ; + unknown
  dw 0110eh,020f1h,-1,-1 ; + unknown(error?)
  dw 00e11h,0F130h,-1,-1 ; + NetFlex-3/P Controller
  dw 00e11h,0f140h,-1,-1 ; + unknown
  dw 0110eh,040f1h,-1,-1 ; + unknown(error?)
  dw 00e11h,0F150h,-1,-1 ; NetFlex-3/P Controller version 2
  dw 0

;อ[Davicom]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "DM9PCI" "DM9PCI" "DAVICOM DM9 PCI Series Fast Ethernet Adapter" false
  dw 01282h,09100h,-1,-1 ; type 0 - DM9100 Ethernet Controller
  dw 01282h,09009h,-1,-1 ; type 1 - DM9009 Ethernet Adapter
  dw 01282h,09102h,-1,-1 ; type 2 - DM9102/A/AF,DM9801 Fast Ethernet Adapter
  dw 0

;อ[Digital Equipment Corp]อออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "DC21X4" "DC21X4" "Digital Semiconductor 21040/21140/21041/21143/2" true
  dw 01011h,00002h,-1,-1 ; 21040
  dw 01011h,00009h,-1,-1 ; 21140
  dw 01011h,00014h,-1,-1 ; 21041
  dw 01011h,00019h,-1,-1 ; 21143/2
  dw 0

;อ[IBM]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "IBMMPC" "IBMMPC" "IBM Auto LANStreamer PCI Adapter" true
  dw 01014h,00018h,-1,-1
  dw 0

nic_drivernames "IBMTRP" "IBMTRP" "IBM PCI and CardBus Token-Ring Adapter" true
  dw 01014h,0003eh,-1,-1
  dw 0

;อ[Intel]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "E10P" "E10PEOS2" "Intel EtherExpress PRO/10 PCI LAN Adapter" false
  dw 08086h,01226h,-1,-1 ; no other check
  dw 0

; probably superseded driver (e100b?)
; this is an exact copy of nicdrv.lst:
nic_drivernames "N100" "N100EO2" "Intel - Compaq Ethernet or Fast Ethernet NIC" false
  dw 08086h,01229h,00e11h,0B01Eh ; Intel - Compaq NC3120 Fast Ethernet NIC
  dw 08086h,01229h,00e11h,0B01Fh ; Intel - Compaq NC3122 Fast Ethernet NIC
  dw 08086h,01229h,00e11h,0B02Fh ; Intel - Compaq NC1120 Ethernet NIC
  dw 08086h,01229h,00e11h,0B04Ah ; Intel - Compaq 10/100 TX PCI Intel WOL UTP Controller
  dw 08086h,01229h,00e11h,0B0C6h ; Intel - Compaq NC3161 Fast Ethernet NIC
  dw 08086h,01229h,00e11h,0B0C7h ; Intel - Compaq NC3160 Fast Ethernet NIC
  dw 08086h,01229h,00e11h,0B0D7h ; Intel - Compaq NC3121 Fast Ethernet NIC
  dw 08086h,01229h,00e11h,0B0DDh ; Intel - Compaq NC3131 Fast Ethernet NIC
  dw 08086h,01229h,00e11h,0B0DEh ; Intel - Compaq NC3132 Fast Ethernet NIC
  dw 08086h,01229h,00e11h,0B0E1h ; Intel - Compaq NC3133 Fast Ethernet Module
  dw 08086h,01229h,00e11h,0B134h ; Intel - Compaq NC3163 Fast Ethernet NIC
  dw 08086h,01229h,00e11h,0B13Ch ; Intel - Compaq NC3162 Fast Ethernet NIC
  dw 08086h,01229h,00e11h,0B144h ; Intel - Compaq NC3123 Fast Ethernet NIC
  dw 0

;* ignore IBMFEEO2.NIF for now

nic_drivernames "E100B" "E100BEO2" "Intel PRO PCI Adapter" true
  ; -=present in 4.24, removed in 4.33
  ; +=newly added in 4.48, was not in 4.35
  ; 1=added in or before 4.56
  ; 2=added in 4.57
  dw 08086h,01029h,-1,-1 ; 82559 PRO/100 PCI Ethernet Adapter
  dw 08086h,01030h,-1,-1 ;-82559 InBusiness 10/100
  dw 08086h,01031h,-1,-1 ; Intel PRO/100 VE Network Connection
  dw 08086h,01032h,-1,-1 ; Intel PRO/100 VE Network Connection
  dw 08086h,01033h,-1,-1 ; Intel PRO/100 VM Network Connection
  dw 08086h,01034h,-1,-1 ; Intel PRO/100 VM Network Connection
  dw 08086h,01035h,-1,-1 ; 82562EH based Phoneline Network Connection
  dw 08086h,01036h,-1,-1 ; 82562EH based Phoneline Network Connection
  dw 08086h,01037h,-1,-1 ; Intel PRO/100 ICH3 Device = 1037
  dw 08086h,01038h,-1,-1 ; Intel PRO/100 VM Network Connection
  dw 08086h,01039h,-1,-1 ; Intel PRO/100 VE Network Connection
  dw 08086h,0103Ah,-1,-1 ; Intel PRO/100 VE Network Connection
  dw 08086h,0103Bh,-1,-1 ; Intel PRO/100 VM Network Connection
  dw 08086h,0103Ch,-1,-1 ; Intel PRO/100 VM Network Connection
  dw 08086h,0103Dh,-1,-1 ; Intel PRO/100 VE Network Connection
  dw 08086h,0103Eh,-1,-1 ; Intel PRO/100 VM Network Connection
  dw 08086h,01050h,-1,-1 ;+Intel PRO/100 VE Network Connection
  dw 08086h,01051h,-1,-1 ;+Intel PRO/100 VE Network Connection
  dw 08086h,01052h,-1,-1 ;+Intel PRO/100 VM Network Connection
  dw 08086h,01053h,-1,-1 ;+Intel PRO/100 VM Network Connection
  dw 08086h,01054h,-1,-1 ;+Intel PRO/100 VE Network Connection
  dw 08086h,01055h,-1,-1 ;+Intel PRO/100 VM Network Connection
  dw 08086h,01056h,-1,-1 ;+Intel PRO/100 ICH5 Device = 1056
  dw 08086h,01057h,-1,-1 ;+Intel PRO/100 ICH5 Device = 1057
  dw 08086h,01059h,-1,-1 ; Intel PRO/100 M Mobile Connection
  dw 08086h,01064h,-1,-1 ;1
  dw 08086h,01065h,-1,-1 ;1
  dw 08086h,01066h,-1,-1 ;1
  dw 08086h,01067h,-1,-1 ;1
  dw 08086h,01068h,-1,-1 ;1
  dw 08086h,01069h,-1,-1 ;1
  dw 08086h,0106Ah,-1,-1 ;1
  dw 08086h,0106Bh,-1,-1 ;1
  dw 08086h,01091h,-1,-1 ;2
  dw 08086h,01092h,-1,-1 ;2
  dw 08086h,01093h,-1,-1 ;2
  dw 08086h,01094h,-1,-1 ;2
  dw 08086h,01095h,-1,-1 ;2
  dw 08086h,01209h,-1,-1 ; Intel 8255x Fast Ethernet Controller
  dw 08086h,01229h,-1,-1 ; Intel PRO/100 PCI Adapter also: Intel - IBM 10/100 EtherJet PCI Adapter
  dw 08086h,02449h,-1,-1 ; Intel PRO/100 Network Connection
  dw 08086h,02459h,-1,-1 ; 82562 based Fast Ethernet Connection
  dw 08086h,0245Dh,-1,-1 ; 82562 based Fast Ethernet Connection
  dw 08086h,027DCh,-1,-1 ;2
  dw 0

;*; e100b_inb.zip
;*;; Intel InBussines NIC drivers for OS/2
;*;; patched by Sergey I. Yevtushenko
;*;nic_drivernames "E100BINB" "E100BINB" "Intel InBussines (e100b+patch)" false
;*;  dw 08086h,01039h,-1,-1
;*;  dw 0

; ibm_gigabit_and_10-100_ethernet_device.zip\e1000\e1000.os2
; intelpro.zip
; prodos.exe
nic_drivernames "E1000" "E1000" "Intel PRO/1000 Network Connection" true ; "Intel 8254X Based Network Connection"
  ; !=no longer in 3.46
  dw 08086h,01000h,-1,-1 ;!Intel PRO/1000 Gigabit
  dw 08086h,01001h,-1,-1 ;!Intel PRO/1000 F
  dw 08086h,01004h,-1,-1 ;!Intel PRO/1000 T
  dw 08086h,01008h,-1,-1 ; Intel PRO/1000 XT
  dw 08086h,01009h,-1,-1 ; Intel PRO/1000 XF
  dw 08086h,0100Ch,-1,-1 ; Intel PRO/1000 T
  dw 08086h,0100Dh,-1,-1 ; Intel PRO/1000 XT
  dw 08086h,0100Eh,-1,-1 ; Intel PRO/1000 MT
  dw 08086h,0100Fh,-1,-1 ; Intel PRO/1000 MT
  dw 08086h,01010h,-1,-1 ; Intel PRO/1000 MT Dual Port
  dw 08086h,01011h,-1,-1 ; Intel PRO/1000 MF
  dw 08086h,01012h,-1,-1 ; Intel PRO/1000 MF Dual Port
  dw 08086h,01013h,-1,-1 ; Intel PRO/1000 MT
  dw 08086h,01015h,-1,-1 ; Intel PRO/1000 MT Mobile
  dw 08086h,01016h,-1,-1 ; Intel PRO/1000 MT Mobile
  dw 08086h,01017h,-1,-1 ; Intel PRO/1000 MT Desktop
  dw 08086h,01018h,-1,-1 ; Intel PRO/1000 MT Mobile
  dw 08086h,01019h,-1,-1 ; Intel PRO/1000 CT
  dw 08086h,0101Dh,-1,-1 ; Intel PRO/1000 MT Quad Port
  dw 08086h,01099h,-1,-1 ; added between 3.62..4.17
  dw 08086h,0101Eh,-1,-1 ; Intel PRO/1000 MT Mobile
  dw 08086h,01026h,-1,-1 ; Intel PRO/1000 MT
  dw 08086h,01027h,-1,-1 ; Intel PRO/1000 MF
  dw 08086h,01028h,-1,-1 ; Intel PRO/1000 MB
  dw 08086h,01075h,-1,-1 ; Intel PRO/1000 CT
  dw 08086h,01076h,-1,-1 ; Intel PRO/1000 MT
  dw 08086h,01077h,-1,-1 ; Intel PRO/1000 MT
  dw 08086h,01078h,-1,-1 ; Intel PRO/1000 MT
  dw 08086h,01079h,-1,-1 ; Intel PRO/1000 MT Dual Port
  dw 08086h,0107ah,-1,-1 ; Intel PRO/1000 MF Dual Port
  dw 08086h,0107bh,-1,-1 ; Intel PRO/1000 MB Dual Port
  dw 08086h,0107Ch,-1,-1 ; Intel PRO/1000 ??
  dw 08086h,0108Ah,-1,-1 ; new in 3.62
  dw 0

; ibmge2.exe "IBM 1000BaseSX Gigabit Ethernet Adapter (OS/2)"
;   IBMGE.OS2/NIF: 8086:{1000/1001/1009}
; subset of E1000,IBMGU

; ibmgc.exe "IBM 1000BaseT Gigabit Ethernet Adapter" (copper)
;   ibmgc.OS2/NIF_ 8086:{1008/100C/100D/100E/100F/1010}
; subset of E1000,IBMGU

; opverlapping wih E1000
nic_drivernames "IBMGU" "IBMGU" "IBM Gigabit Ethernet Adapter" true
  dw 08086h,01000h,-1,-1 ; 82542 PRO/1000 Gigabit Server Adapter
  dw 08086h,01001h,-1,-1 ; 82543GC PRO/1000 F Gigabit Ethernet Adapter (Fiber)
  dw 08086h,01004h,-1,-1 ; 82543 PRO/1000 T Gigabit Server Adapter (Copper)
  dw 08086h,01008h,-1,-1 ; 82544 PRO/1000 XT Gigabit Ethernet Controller (Copper)
  dw 08086h,01009h,-1,-1 ; 82544 PRO/1000 XF Gigabit Ethernet Controller (Fiber)
  dw 08086h,0100Ch,-1,-1 ; 82544 T Gigabit Ethernet Controller (Copper)
  dw 08086h,0100Dh,-1,-1 ; 82544GC Gigabit Ethernet Controller (LOM)
  dw 08086h,0100Eh,-1,-1 ; 82544XT PRO/1000 MT Gigabit Ethernet Controller
  dw 08086h,01015h,-1,-1 ; 82540EM PRO/1000 MT Mobile Connection (LOM)
  dw 08086h,01016h,-1,-1 ; 82540EP Gigabit Ethernet Controller (LOM)
  dw 08086h,01017h,-1,-1 ; 82540EP Gigabit Ethernet Controller (LOM)
  dw 08086h,0101Eh,-1,-1 ; 82540EP Gigabit Ethernet Controller (Mobile)
  dw 08086h,0100Fh,-1,-1 ; 82545EM Gigabit Ethernet Controller (Copper)
  dw 08086h,01011h,-1,-1 ; 82545EM Gigabit Ethernet Controller (Fiber)
  dw 08086h,01010h,-1,-1 ; 82546EB Gigabit Ethernet Controller (Copper)
  dw 08086h,01012h,-1,-1 ; 82546EB Gigabit Ethernet Controller (Fiber)
  dw 08086h,0101Dh,-1,-1 ; ???
  dw 08086h,01013h,-1,-1 ; 82541EI Gigabit Ethernet Controller (Copper)
  dw 08086h,01018h,-1,-1 ; ???
  dw 08086h,01076h,-1,-1 ; 82541EI Gigabit Ethernet Controller
  dw 08086h,01019h,-1,-1 ; 82547EI Gigabit Ethernet Controller (LOM)
  dw 0

;อ[Intersil]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออ
;
; IBM miniPCI PRISM 2.5 Wireless Card (ibmprism.exe)
nic_drivernames "ibmprism" "ibmprism" "Intersil ISL3874 PRISM 2.5 Chipset" true
  dw 01260h,03873h,-1,-1 ; driver checks for revision 1!
  dw 0

; nonpublic/beta (JG)
nic_drivernames "pr25plx" "pr25plx" "Prism 2.5 PLX PCI Card" false
  dw 016abh,01101h,-1,-1 ; 2, AmbiCom WL1100B-PCI Adapter
  dw 01385h,04100h,-1,-1 ; 2, NetGear MA-301 PCI Adapter
  dw 01638h,01100h,-1,-1 ; 2, Belkin F5D6000n PCI Adapter
  dw 016abh,01102h,-1,-1 ; 2, LinkSys WDT-11 PCI Adapter
  dw 010B7h,07770h,-1,-1 ; 0, 3COM Airconnect PCI Adapter 3CRWE777A (PLX) board
  dw 0111Ah,01023h,-1,-1 ; 0, Siemens SpeedStream SS1023 PCI Adapter
  dw 0


;อ[Lite-On/Kingston/PNIC]ออออออออออออออออออออออออออออออออออออออออออออ

; linksys:
;   VendorID = 4525       ;; 11ad (PNIC)
;   LNE100TXCFID = 135597 ;; 0x000211ad
; use kingston driver release (because of newest,largest?)

nic_drivernames "KTC111" "KTC111" "Lite-On - Kingston EtherRX KNE110TX/KNE111TX" false
  dw 011adh,00001h,-1,-1 ; type 01h - LC82C168 Fast Ethernet Adapter (??)
  dw 011adh,00002h,-1,-1 ; type 01h - LC82C168 Fast Ethernet Adapter
; dw 01011h,00009h,-1,-1 ; type 11h - historic support for DEC
  dw 011adh,0c115h,-1,-1 ; type 21h - LC82C115 PNIC-II PCI MAC/PHY
  dw 0

; better use the DC21X4 driver..
;nic_drivernames "KTC40" "KTC40" "Kingston EtheRx PCI Ethernet Network Adapter" true
;  dw 01011h,00002h,-1,-1 ; type 00h -
;  dw 01011h,00009h,-1,-1 ; type 01h -
;  dw 01011h,00014h,-1,-1 ; type 02h -
;  dw 0

;อ[Macronix]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "MXNICF" "MXNICF" "Macronix MX987xx Family Fast Ethernet Adapters" false
  dw 010d9h,00512h,-1,-1 ; MX98713 Fast Ethernet Adapter (PN102TX)
  dw 010d9h,00531h,-1,-1 ; MX98715/25 Fast Ethernet Adapter
  dw 010d9h,00532h,-1,-1 ; MX98732/737 PCi/CardBus Fast Ethernet Controller
; dw 01011h,00019h,-1,-1 ; historic support for DEC
; dw 01011h,00009h,-1,-1 ; historic support for DEC
  dw 0

;อ[Madge]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "SMARTND" "SMARTND" "Madge Smart Ringnodes" true
  dw 010b6h,00001h,-1,-1 ; Smart 16/4 Ringnode (PCI1b)
  dw 010b6h,00004h,-1,-1 ; Smart 16/4 Ringnode Mk1 (PCIBM1)
  dw 010b6h,00002h,-1,-1 ; Smart 16/4 Ringnode (PCIBM2/CardBus)
  dw 0

nic_drivernames "MDGND" "MDGND" "Madge;Olicom Token-Ring Adapter" true
; Madge Smart 16/4 PCMCIA Ringnode
; Madge Smart 16/4 PCMCIA Ringnode Mk2
; Madge Smart 16/4 PCI Ringnode
; Madge Smart 16/4 PCI Ringnode Mk1
; Madge Smart 16/4 PCI Ringnode Mk2
; Madge Presto PCI Adapter
; Madge Smart 16/4 PCI Ringnode Mk3
; Compaq NC4621 PCI, 4/16, WOL
; Madge Presto PCI Plus Adapter
; Madge Presto PCI 2000 Adapter
; Madge 16/4 CardBus Adapter Mk2
; Madge Smart 100/16/4 PCI-HS Ringnode
; Madge Smart 100/16/4 PCI Ringnode
; Madge 16/4 CardBus Adapter
  dw 010b6h,00001h,-1,-1
  dw 010b6h,00002h,-1,-1
  dw 010b6h,00003h,-1,-1
  dw 010b6h,00004h,-1,-1
  dw 010b6h,00006h,-1,-1
  dw 010b6h,00007h,-1,-1
  dw 010b6h,00009h,-1,-1
  dw 010b6h,0000ah,-1,-1
  dw 010b6h,0000bh,-1,-1
  dw 010b6h,0000ch,-1,-1

; Olicom Token-Ring PCI 16/4 Adapter (OC-3136)
; Olicom Token-Ring PCI/II 16/4 Adapter (OC-3137)
  dw 0108dh,00001h,-1,-1
; Olicom GoCard Token-Ring PC Card (OC-3221)
; Olicom GoCard 3250 Token-Ring 16/4 CardBus PC Card
; Olicom RapidFire 3139 Token-Ring 16/4 PCI Adapter
  dw 0108dh,00002h,-1,-1
; Olicom RapidFire 3140 Token-Ring 16/4 PCI Adapter
  dw 0108dh,00004h,-1,-1
; Olicom RapidFire 3141 Token-Ring 16/4 PCI Fiber Adapter
  dw 0108dh,00007h,-1,-1
; Olicom RapidFire 3540 HSTR 100/16/4 PCI Adapter
  dw 0108dh,00008h,-1,-1
; Olicom RapidFire 3140 V2 16/4 PCI Adapter

  dw 0

;อ[Myson]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

; surecom: ep320xs.exe: EP-320X-S 100/10M Ethernet PCI Adapter
nic_drivernames "FEAND" "FEAND" "Myson MTD80X Based Fast Ethernet Card" false
  dw 01516h,00800h,-1,-1
  dw 01516h,00803h,-1,-1
  dw 01516h,00891h,-1,-1
  dw 0

;อ[Prism]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

;longshine: 8031c1.exe Wireless PC Card
;01317h,08201h,

;อ[National Semiconductor]อออออออออออออออออออออออออออออออออออออออออออ

; tigris07.zip: "DP83815" "DP83815" "National Semiconductor DP83815 10/100 MacPhyter3v PCI Adapter" false
; dp815a00.zip:
nic_drivernames "dp815a" "dp815a" "National Semiconductor DP83815" true
  dw 0100Bh,00020h,-1,-1
  dw 0

; dp82x06.zip: nic_drivernames "DP83820" "DP83820" "National Semiconductor DP83820 10/100/1000 Mac PCI Adapter" false
; dp820a01.zip:
nic_drivernames "DP820A" "DP820A" "National Semiconductor DP83820 10/100/1000 Mac PCI Adapter" true
  dw 0100bh,00022h,-1,-1
  dw 0

;อ[Olicom]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

; V 108D Olicom
; D 0001 OC-3136/3137 16/4 PCI Adapter
nic_drivernames "OLITOK16" "OLITOK" "Olicom Token-Ring 16/4 PCI Adapter" true
  dw 0108dh,00001h,-1,-1
  dw 0

;อ[Racore]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

; V 2348 Racore
; D 2010 8142 100VG/AnyLAN

; V 10EF Racore Computer Products
; D 8154 M815x Token Ring Adapter


; D:\neu\d9331f1.exe\IBMCOM.OS2\RVGNDIS.OS2
nic_drivernames "RVGNDIS" "RVGNDIS" "Racore 10/100 AnyLAN Card" false
  dw 02348h,02010h,-1,-1 ; 8142 100VG/AnyLAN
  dw 010EFh,08156h,-1,-1 ; unknown
  dw 0

nic_drivernames "RCPTRNDS" "RCPTRNDS" "Racore M815x Token Ring Adapter" false
  dw 010efh,08154h,-1,-1
  dw 0

;อ[Realtek]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "PCIND" "RTL8029" "Realtek - RTL8029AS PCI Ethernet Adapter" true
  dw 010ECh,08029h,-1,-1
  dw 0

nic_drivernames "RTFND" "RTL8129" "Realtek - RTL8129 Fast Ethernet Adapter" true
  dw 010ECh,08129h,-1,-1
  dw 0

nic_drivernames "RTSND" "RTL8139" "Realtek - 8139/8130/810x and compatibles" true
  dw 010ech,08139h,-1,-1 ; org
  dw 010ech,08138h,-1,-1 ; CardBus?-old
  dw 010ech,08100h,-1,-1 ; bogus?
  dw 0018ah,00106h,-1,-1 ; LevelOne FPC-0106Tx
  dw 0021bh,08139h,-1,-1 ; Compaq HNE-300
  dw 002ach,01012h,-1,-1 ; Siemens 1012v2 CardBus
  dw 01113h,01211h,-1,-1 ; Accton EN1207D/EN2242A
  dw 01186h,01300h,-1,-1 ; D-Link DFE-530TX+
  dw 01186h,01340h,-1,-1 ; D-Link DFE-690TXD CardBus
  dw 01259h,0a117h,-1,-1 ; Allied Telesyn 8139 CardBus
  dw 0126ch,01211h,-1,-1 ; Nortel Networks 10/100BaseTX
  dw 013d1h,0ab06h,-1,-1 ; Edimax EP-4103DL CardBus
  dw 01432h,09130h,-1,-1 ; Siemens 1020 PCI NIC
  dw 014eah,0ab06h,-1,-1 ; Planex FNW-3603-TX 10/100 CardBus
  dw 014eah,0ab07h,-1,-1 ; Planex FNW-3800-TX 10/100 CardBus
  dw 01500h,01360h,-1,-1 ; Delta Electronics (Lantech Computer Company?)
  dw 01688h,01300h,-1,-1 ; D-Link DFE-538TX 10/100 Adapter (DLKRTS) (Castlenet Technology?)
  dw 01743h,08139h,-1,-1 ; Peppercon ROL/F-100 Fast Ethernet Adapter with ROL
  dw 04033h,01360h,-1,-1 ; Addtron (Delta Networks Inc?)
  dw -1,-1,010ech,08139h ; hope to get some more
  dw 0

; rtgnda02.zip
nic_drivernames "rtgnda" "rtgnda" "Realtek - RTL8169" true
  dw 010ech,08168h,-1,-1 ; RTL8168 (rtgnda11.zip)
  dw 010ech,08169h,-1,-1 ; RTL8169 Gigabit Ethernet Adapter
  dw 01186h,04300h,-1,-1 ; D-Link's card has this ID? (1.07.01 Test Version)
  dw 0

;อ[Silicon Integrated Systems]อออออออออออออออออออออออออออออออออออออออ

;; original SiS drivers, have bad reputation (IRQ sharing...)
;nic_drivernames "SIS900" "SIS900" "SiS 900/7016 SIS900 10/100 PCI Adapters" false
;  dw 01039h,00900h,-1,-1 ; SiS900 10/100 Ethernet Adapter
;  dw 01039h,07016h,-1,-1 ; SiS7016 10/100 Ethernet Adapter
;  dw 0

; this is the driver to use (instead of genmac and SIS900)
; http://www.os2warp.be/gigabit/gomi/sis90a03.zip
nic_drivernames "sis90a" "sis90a" "SiS900 Another MAC driver" true
  dw 01039h,00900h,-1,-1 ; SiS900 10/100 Ethernet Adapter
  dw 01039h,07016h,-1,-1 ; sis7016
  dw 0

;อ[Standard Microsystems Corp]อออออออออออออออออออออออออออออออออออออออ

nic_drivernames "SMCPWR2" "SMCPWR2" "SMC EtherPower II 10/100 (9432TX) Ethernet Adapter" false
  dw 010b8h,00005h,-1,-1 ; 83C170QF/171 EPIC,EPIC/XF Fast Ethernet Adapter
  dw 010b8h,00006h,-1,-1 ; LAN83C175 EPIC/C Cardbus Fast Ethernet Adapter
  dw 0

;อ[SysKonnect/Schneider & Koch]ออออออออออออออออออออออออออออออออออออออ

nic_drivernames "SKFPNO" "SKFPNO" "SK-NET FDDI PCI Adapter" false
  dw 01148h,04000h,-1,-1
  dw 0

nic_drivernames "SKTOK" "SKTOKNPCI" "SK-NET Token Ring PCI Adapter" false
  dw 01148h,04200h,-1,-1
  dw 0

nic_drivernames  "sk98nd" "sk98nd" "SysKonnect SK-9E21D and SK-9521 v2.0 Adapter" false
  ; original driver list:
                                        ; V     1148    Syskonnect (Schneider & Koch)
  dw 01148h,04320h,01148h,   -1         ; D     4320    SK-98xx V2.0 Gigabit Ethernet Adapter
  dw 01148h,09E00h,01148h,21D0h         ; D     9E00    SK-9Exx 10/100/1000Base-T Adapter
  ; +patches for Marvel Yukon chips (driver on hobbes)
                                        ; V     11AB    Marvell Semiconductor (Was: Galileo Technology Ltd)
  dw 011ABh,04320h,    -1,   -1         ; D     4320    Yukon 88E8001/8003/8010 PCI Gigabit Ethernet controller (Copper)
  ; could add more... 11ABh/4320h,4360h,4361h,4362h,4350h,4351h,4340h,4341h
  dw 0

;อ[Tamarack]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

nic_drivernames "TC902X" "TC902X" "Tamarack tmi TC9021 MAC Adapter" true
  ; see driver source {tc902x03.zip\source.zip\DrvInit.asm, line 324}
  dw 0143dh,09021h,-1,-1 ; V 143D Tamarack Microelectronics Inc
  dw 013f0h,01021h,-1,-1 ; V 13F0 Sundance Technology Inc
  dw 0

;อ[VIA Technologies]อออออออออออออออออออออออออออออออออออออออออออออออออ

; placed GOMI driver before older vendor driver because they should
; be selected..

; http://www.os2warp.be/gigabit/gomi/vfet1a00.zip
nic_drivernames "vfet1a" "vfet1a" "VIA VT86C100A Rhine Another MAC driver" true
  dw 01106h,03043h,-1,-1 ; VT86C100A
  dw 0

; http://www.os2warp.be/gigabit/gomi/vfet2a03.zip
nic_drivernames "vfet2a" "vfet2a" "VIA VT6102 Rhine2 Another MAC driver" true
  dw 01106h,03065h,-1,-1 ; VT6102
  dw 0

; http://www.os2warp.be/gigabit/gomi/vfet3a01.zip
nic_drivernames "vfet3a" "vfet3a" "VIA VT6105 Rhine3 Another MAC driver" true
  dw 01106h,03106h,-1,-1 ; VT6105
  dw 0


; http://www.os2warp.be/gigabit/gomi/vgend03.zip
nic_drivernames "vgend2" "vgend2" "VIA VT612x Velocity MAC driver" true
  dw 01106h,03119h,-1,-1 ; VT6122
  dw 0

;!! renamed driver/nif because of conflict with realtek
nic_drivernames "PCINDVIA" "PCINDVIA" "VIA 926 PCI 32-bit Ethernet Adapter" false
  dw 01106h,00926h,-1,-1 ; VIA - PCI 32-bit Ethernet Adapter
  dw 0

nic_drivernames "FETND" "FETND" "VIA PCI 10/100Mb Fast Ethernet Adapter" false
  dw 01106h,03043h,-1,-1 ; VIA - PCI Fast Ethernet 10M/100M Adapter (VT86C100A)
  dw 01106h,03065h,-1,-1 ; VIA - D-Link DFE-530TX PCI Fast Ethernet Adapter(A3/B) (VT6102)
  dw 01106h,03106h,-1,-1 ; VIA - VT6105 Rhine III Fast Ethernet Controller
  dw 0

;อ[Winbond]ออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

;linksys_etherpci_lan_cardii.zip

nic_drivernames "W840ND" "W840ND" "Winbond W89C840 PCI Ethernet Adapter" false

nic_drivernames "W840ND" "W840ND" "Winbond W89C840 PCI Ethernet Adapter" false
  dw 01050h,00840h,-1,-1 ; driver checks for subvendor 129a/9a12 or 139b/9b13
  dw 0

; this driver is dated 1996-07-19
nic_drivernames "W940ND" "W940ND" "Winbond W89C940 PCI Ethernet Adapter" false
  dw 01050h,00940h,-1,-1 ; driver checks for subvendor 8800/0088
  dw 0

; this driver is dated 1996-09-27, it is equal to the W940ND, except
; that the Winbond strings are patched/blanked with linksys strings
;nic_drivernames "LNEPCI2" "LNEPCI2I" "Linksys LNEPCI2 PCI Ethernet Adapter" false
;  dw 01050h,00940h,-1,-1 ; driver checks for subvendor 8800/0088
;  dw 0

;อ[Xircom]อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ

; The CDBENDIS driver checks CardBus tuples in reality
; instead of PCI registers for vendor (105=Xircom,89=Intel,A4=IBM).
; maybe there exist some Toshiba version somewhere

nic_drivernames "CBENDIS" "CBEOS2" "Xircom CardBus Ethernet 10/100" false
  dw 0115dh, 00003h, 115dh,-1
  dw 0115dh, 00005h, 115dh,-1
  dw 0115dh, 00007h, 115dh,-1
  dw 0115dh, 0000bh, 115dh,-1
  dw 0115dh, 0000fh, 115dh,-1
  dw 0115dh, 00103h, 115dh,-1 ; + modem
  dw 0

nic_drivernames "IBMCNDIS" "IBMCOS2" "IBM 10/100 EtherJet CardBus Adapter" true
  dw 0115dh, 00003h, 1014h,-1
  dw 0115dh, 00005h, 1014h,-1
  dw 0115dh, 00007h, 1014h,-1
  dw 0115dh, 0000bh, 1014h,-1
  dw 0115dh, 0000fh, 1014h,-1
  dw 0115dh, 00103h, 1014h,-1 ; + modem
  dw 0

nic_drivernames "M32ANDIS" "M32AOS2" "Intel EtherExpress PRO/100 Mobile CardBus 32 Adapter" false
  dw 0115dh, 00003h, 08086,-1
  dw 0115dh, 00005h, 08086,-1
  dw 0115dh, 00007h, 08086,-1
  dw 0115dh, 0000bh, 08086,-1
  dw 0115dh, 0000fh, 08086,-1
  dw 0115dh, 00103h, 08086,-1 ; + modem
  dw 0

networkadaptertable_end:

;***************************************************************************

; ISA-like detection for SVISTA
name_goseth_Virtual_Ethernet_Adapter:
nic_drivernames "goseth" "goseth" "Virtual Ethernet Adapter" false
  dw 0

;***************************************************************************

