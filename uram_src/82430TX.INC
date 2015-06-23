Title   Intel 824xx: PCI
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
intel_pci_0058                  and_or_record <>
intel_pci_005C                  and_or_record <>

intel_SIO_0048                  and_or_record <>
intel_SIO_004c                  and_or_record <>
intel_SIO_0054                  and_or_record <>

intel_PIIX_004c                 equ intel_SIO_004c
intel_PIIX_0068                 and_or_record <>

adresse_peripheral_Intel_SIO    dw -1
adresse_peripheral_Intel_PIIX   dw -1

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;
intel_82430tx_eintrag           Macro Segm,IndOff,ShlWert,SIO54,SIO48,SIO4C,PIIX68
                                  dw &Segm
                                  dw &IndOff
                                  db &ShlWert
                                  db &SIO54
                                  db &SIO48
                                  db &SIO4C
                                  db &PIIX68
                                EndM

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

tabelle_intel_82430tx_anfang:

; A000 - ignorieren
; A400 - ignorieren
; A800 - ignorieren
; AC00 - ignorieren

; B000 - ignorieren
; B400 - ignorieren
; B800 - ignorieren
; BC00 - ignorieren

;                                                               SIO          PIIX
;                                                               54  48  4C   68
intel_82430tx_eintrag 'C0',<Offset intel_pci_0058+05ah-058h>,0,  0,  8, -1,  -1
intel_82430tx_eintrag 'C4',<Offset intel_pci_0058+05ah-058h>,4,  2,  9, -1,  -1
intel_82430tx_eintrag 'C8',<Offset intel_pci_0058+05bh-058h>,0,  4, 10, -1,  -1
intel_82430tx_eintrag 'CC',<Offset intel_pci_0058+05bh-058h>,4,  6, 11, -1,  -1

intel_82430tx_eintrag 'D0',<Offset intel_pci_005C+05ch-05ch>,0,  8, 12, -1,  -1
intel_82430tx_eintrag 'D4',<Offset intel_pci_005C+05ch-05ch>,4, 10, 13, -1,  -1
intel_82430tx_eintrag 'D8',<Offset intel_pci_005C+05dh-05ch>,0, 12, 14, -1,  -1
intel_82430tx_eintrag 'DC',<Offset intel_pci_005C+05dh-05ch>,4, 14, 15, -1,  -1

intel_82430tx_eintrag 'E0',<Offset intel_pci_005C+05eh-05ch>,0, 16,  3, 22,  11
intel_82430tx_eintrag 'E4',<Offset intel_pci_005C+05eh-05ch>,4, 18,  3, 22,  11
intel_82430tx_eintrag 'E8',<Offset intel_pci_005C+05fh-05ch>,0, 20,  3, 22,  11
intel_82430tx_eintrag 'EC',<Offset intel_pci_005C+05fh-05ch>,4, 22,  3, 22,  11

intel_82430tx_eintrag 'F0',<Offset intel_pci_0058+059h-058h>,4, -1, -1, -1,  -1
; F400 - ignorieren
; F800 - ignorieren
; FC00 - ignorieren

tabelle_intel_82430tx_ende:

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ

a_proc                          intel_824x0_gemeinsam

                                call suche_periphal_controller
                                ;if_c <call suche_periphal_controller_fehlermeldung>

                                mov si,Offset tabelle_intel_82430tx_anfang
  tabelle_intel_82430tx_schleife:
                                mov di,Word Ptr cs:[si+0]
                                call berechne_wert_ax

                                cmp al,unveraendert
                                je unveraendert_82430tx_weiter

                                mov bh,ah               ; or
                                mov bl,(not 7)          ; and
                                mov di,Word Ptr cs:[si+2]
                                mov cl,Byte Ptr cs:[si+2+2]
                                rol bh,cl
                                rol bl,cl
                                and Byte Ptr cs:[di+0],bl
                                or  Byte Ptr cs:[di+4],bh

                                ; aus UMBPCI: ISA DMA (SIOlist/PIIXlist)
                                test ah,2
                                jz nicht_intel_isa_dma

                                ; SIO54
                                movsx ecx,Byte Ptr cs:[si+2+2+1]
                                cmp cl,-1
                                je kein_intel_SIO_0054
                                bts [intel_SIO_0054].or_wert,ecx
                                inc cx
                                bts [intel_SIO_0054].or_wert,ecx
                              kein_intel_SIO_0054:

                                ; SIO48
                                movsx ecx,Byte Ptr cs:[si+2+2+1+1]
                                cmp cl,-1
                                if_ne <bts [intel_SIO_0048].or_wert,ecx>

                                ; SIO4C
                                movsx ecx,Byte Ptr cs:[si+2+2+1+1+1]
                                cmp cl,-1
                                if_ne <btr [intel_SIO_004c].and_wert,ecx>

                                ; PIIX68
                                movsx ecx,Byte Ptr cs:[si+2+2+1+1+1+1]
                                cmp cl,-1
                                if_ne <bts [intel_PIIX_0068].or_wert,ecx>
  nicht_intel_isa_dma:

  unveraendert_82430tx_weiter:
                                add si,2+2+1+1+1+1+1
                                cmp si,Offset tabelle_intel_82430tx_ende
                                jne tabelle_intel_82430tx_schleife


                                call cache_sichern_und_abschalten

                                installiere_tracer

                                null bx
                                mov si,Offset intel_pci_0058
                                mov di,058h
                                call pci_maske_dword

                                mov si,Offset intel_pci_005C
                                mov di,05Ch
                                call pci_maske_dword


                                ; Saturn, Mercury, Neptun
                                mov bx,[adresse_peripheral_Intel_SIO]
                                cmp bx,-1
                                je keine_adresse_peripheral_Intel_SIO_programmierung

                                mov si,Offset intel_SIO_0048
                                mov di,048h
                                call pci_maske_dword

                                mov si,Offset intel_SIO_004c
                                mov di,04ch
                                call pci_maske_dword

                                mov si,Offset intel_SIO_0054
                                mov di,054h
                                call pci_maske_dword

  keine_adresse_peripheral_Intel_SIO_programmierung:

                                ; Triton
                                mov bx,[adresse_peripheral_Intel_PIIX]
                                cmp bx,-1
                                je keine_adresse_peripheral_Intel_PIIX_programmierung

                                mov si,Offset intel_PIIX_004c
                                mov di,04ch
                                call pci_maske_dword

                                mov si,Offset intel_PIIX_0068
                                mov di,068h
                                call pci_maske_dword

  keine_adresse_peripheral_Intel_PIIX_programmierung:

                                entferne_tracer

                                call cache_wiederherstellen

                                jmp initialisieren
a_endp                          intel_824x0_gemeinsam

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
a_proc                          peripheral_Intel_SIO
                                mov [adresse_peripheral_Intel_SIO],bx
                                ret
a_endp                          peripheral_Intel_SIO
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
a_proc                          peripheral_Intel_PIIX
                                mov [adresse_peripheral_Intel_PIIX],bx
                                ret
a_endp                          peripheral_Intel_PIIX
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

