Title   VIA580/AMD 640/..: PCI
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Dokumentation: 21090c.pdf [AMD] Seite 110,118
;
; 52.7 C000-C7FF write protect+L2 cache
;   .6 D000-DFFF write protect+L2 cache
;   .5 E000-EFFF write protect+L2 cache
;   .4 F000-FFFF write protect+L2 cache
;   .3
;   .2
;   .1
;   .0
;
; 61.7 \ R CC00
;   .6 / W
;   .5 \ R C800
;   .4 / W
;   .3 \ R C400
;   .2 / W
;   .1 \ R C000
;   .0 / W
;
; 62.7 \ R DC00
;   .6 / W
;   .5 \ R D800
;   .4 / W
;   .3 \ R D400
;   .2 / W
;   .1 \ R D000
;   .0 / W
;
; 63.7 \ R E000
;   .6 / W
;   .5 \ R F000
;   .4 / W
;   .3 \ memory hole
;   .2 /
;   .1 - SMI 3000/4000->A000/B000
;   .0 - MAP A000..BFFF VGA/MEM
;
;  -> A000 nicht benutzbar weil B800 weg w„re - mies
;
;
; Dokumentation: 21095b.pdf [AMD] Seite 150
;
; 4E.11 - DMA E000/F000
;    7  - DMA DC00
;    6  - DMA D800
;    5  - DMA D400
;    4  - DMA D000
;    3  - DMA CC00
;    2  - DMA C800
;    1  - DMA C400
;    0  - DMA C000
;
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Public chips_via5x0
Public variante_via580_awdflash
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                                .586p
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
tabelle_vt580                   Macro Segm,WertLesenSchreiben,WertCache,WertDMA
                                  dw &Segm
                                  db &WertLesenSchreiben
                                  db &WertCache
                                  db &WertDMA
                                EndM
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
via_pci_0050                            and_or_record <>
via_pci_0060                            and_or_record <>
via_peripheral_bus_controller_004c      and_or_record <>

adresse_peripheral_controller_VIA_586   dw -1

anfang_vt580_tabelle:
                                ;             SEG, Index(60), Cache(52), DMA(ISA 4E)
                                tabelle_vt580 'C0',  8,       Bit7,            0
                                tabelle_vt580 'C4', 10,       Bit7,            1
                                tabelle_vt580 'C8', 12,       0   ,            2   ; DOKU!
                                tabelle_vt580 'CC', 14,       0   ,            3   ; DOKU!

                                tabelle_vt580 'D0', 16,       Bit6,            4
                                tabelle_vt580 'D4', 18,       Bit6,            5
                                tabelle_vt580 'D8', 20,       Bit6,            6
                                tabelle_vt580 'DC', 22,       Bit6,            7

                                tabelle_vt580 'E0', 30,       Bit5,            11

                                tabelle_vt580 'F0', 28,       Bit4,            11
ende_vt580_tabelle:
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
variante_via580_awdflash:
                                ausschrift_xxxx_aehnliches_bios text_variante_via580_awdflash
chips_via5x0:

                                call suche_periphal_controller
                                if_c <call suche_periphal_controller_fehlermeldung>

                                mov si,Offset anfang_vt580_tabelle
  schleife_vt580_tabelle:
                                mov di,Word Ptr [si+0]
                                call berechne_wert_ax

                                cmp al,unveraendert
                                jz setze_vt580_prozedur_fertig


                                ; Bit Lesen/Schreiben [60..63]
                                movsx ecx,Byte Ptr [si+2]

                                ; l”schen (and)

                                btr DWord Ptr cs:[Offset via_pci_0060.and_wert],ecx
                                inc cx
                                btr DWord Ptr cs:[Offset via_pci_0060.and_wert],ecx
                                dec cx

                                ; Lesen ?
                                test ah,001h
                                jz via580_nicht_lesen

                                inc cx
                                bts DWord Ptr cs:[Offset via_pci_0060.or_wert],ecx
                                dec cx

  via580_nicht_lesen:
                                ; Schreiben ?
                                test ah,2
                                jz via580_nicht_schreiben

                                bts DWord Ptr cs:[Offset via_pci_0060.or_wert],ecx

  via580_nicht_schreiben:

                                ; dumme Situation:
                                ;            Eeee
                                ; 1. URAM R= 77..
                                ; 2. ndeung am BIOS (Exxx)
                                ; 3. URAM R= 55..
                                ; bei 1. muá ich L2 cache fr Exxx abschalten.
                                ; bei 3. máte ich ihn weider einschalten, aber was ist wenn
                                ; der Rest als ..77 in Benutzung ist?
                                ; L”sung: L2-Schreibschutz wird nur gesetzt,
                                ; wenn /W angegeben ist


                                ; 52: Index L2-Schreibschutz

                                ; Schreiben /W          AND     OR
                                ;  nein      nein       =       =
                                ;  ja        nein       -WERT   =
                                ;  nein      ja         =       WERT
                                ;  ja        ja         -WERT   =

                                mov cl,Byte Ptr [si+2+1]

                                ; AND:=-WERT wenn schreiben=ja
                                mov ch,cl
                                not ch
                                test ah,002h ; schreiben ?
                                if_nz <and Byte Ptr [Offset via_pci_0050.and_wert+052h-050h],ch>

                                ; OR:=WERT wenn (schreiben=nein) und (Parameter /W)
                                cmp [globaler_schreibschutz],'1'
                                jne nicht_via580_l2_schreibschutz_or
                                test ah,002h ; schreiben ?
                                jnz nicht_via580_l2_schreibschutz_or
                                or Byte Ptr [Offset via_pci_0050.or_wert+052h-050h],cl
  nicht_via580_l2_schreibschutz_or:

                                ; DMA Zugriff
                                movzx cx,Byte Ptr [si+2+1+1]
                                test ah,002h ; schreiben ?
                                if_nz <bts Word Ptr [via_peripheral_bus_controller_004c.or_wert+04eh-04ch],cx>

  setze_vt580_prozedur_fertig:
                                add si,2+1+1+1
                                cmp si,Offset ende_vt580_tabelle
                                jne schleife_vt580_tabelle


                                call cache_sichern_und_abschalten

                                installiere_tracer

                                null bx
                                mov si,Offset via_pci_0050
                                mov di,050h
                                call pci_maske_dword

                                mov si,Offset via_pci_0060
                                mov di,060h
                                call pci_maske_dword

                                mov bx,[adresse_peripheral_controller_VIA_586]
                                mov si,Offset via_peripheral_bus_controller_004c
                                mov di,04ch
                                cmp bx,-1
                                if_ne <call pci_maske_dword>

                                entferne_tracer

                                call cache_wiederherstellen

                                jmp initialisieren

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
a_proc                          peripheral_controller_VIA_586
                                mov [adresse_peripheral_controller_VIA_586],bx
                                ret
a_endp                          peripheral_controller_VIA_586
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

