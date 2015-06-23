Title   SiS 600/620/630/635/640/645/646/650: PCI
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Quelle: S446RA08.BIN und UMBPCI
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

eintrag_sis_645         Macro SegM,Bit70IndRead,Bit70IndWrite,DMABit48
                          dw &SegM
                          db Bit70IndRead
                          db Bit70IndWrite
                          db DMABit48
                        EndM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

tabelle_sis_645_anfang:
  eintrag_sis_645 'C0', 0,16, 8
  eintrag_sis_645 'C4', 1,17, 9
  eintrag_sis_645 'C8', 2,18,10
  eintrag_sis_645 'CC', 3,19,11
  eintrag_sis_645 'D0', 4,20,12
  eintrag_sis_645 'D4', 5,21,13
  eintrag_sis_645 'D8', 6,22,14
  eintrag_sis_645 'DC', 7,23,15
  eintrag_sis_645 'E0', 8,24,12
  eintrag_sis_645 'E4', 9,25,13
  eintrag_sis_645 'E8',10,26,14
  eintrag_sis_645 'EC',11,27,15
  eintrag_sis_645 'F0',12,28,-1
tabelle_sis_645_ende:

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

sis_645_0070            and_or_record <>
sis_645ISA_0048         and_or_record <>

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  variante_sis650_awardflash
int 3
                        ausschrift_xxxx_aehnliches_bios text_variante_sis650_awardflash
                       ;jmp chip_sis_645
a_endp                  variante_sis650_awardflash


a_proc                  chip_sis_645
                        pushad

                        call suche_periphal_controller
                        if_c <call suche_periphal_controller_fehlermeldung>

                        mov si,Offset tabelle_sis_645_anfang
  tabelle_sis_645_schleife:
                        mov di,Word Ptr [si+0]
                        call berechne_wert_ax

                        cmp al,unveraendert
                        je sis_645_unveraendert

                        ; read bit
                        movzx ecx,Byte Ptr [si+2]
                        btr [sis_645_0070].and_wert,ecx
                        test ah,1
                        if_nz <bts [sis_645_0070].or_wert,ecx>

                        ; write bit
                        movzx ecx,Byte Ptr [si+2+1]
                        btr [sis_645_0070].and_wert,ecx
                        test ah,2
                        if_nz <bts [sis_645_0070].or_wert,ecx>

                        ; dma bit
                        movzx ecx,Byte Ptr [si+2+1+1]
                        cmp cl,-1
                        je sis_645_unveraendert
                        test ah,2
                        if_nz <bts [sis_645ISA_0048].or_wert,ecx>
  sis_645_unveraendert:
                        add si,2+1+1+1
                        cmp si,Offset tabelle_sis_645_ende
                        jne tabelle_sis_645_schleife


                        call cache_sichern_und_abschalten

                        installiere_tracer

                        null bx
                        mov si,Offset sis_645_0070
                        mov di,070h
                        call pci_maske_dword

                        mov bx,[adresse_peripheral_sis_isa]
                        mov si,Offset sis_645ISA_0048
                        mov di,048h
                        cmp bx,-1
                        if_ne <call pci_maske_dword>

                        entferne_tracer

                        call cache_wiederherstellen

                        jmp initialisieren

a_endp                  chip_sis_645

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

adresse_peripheral_sis_isa dw -1

a_proc                  peripheral_sis_isa
                        mov [adresse_peripheral_sis_isa],bx
                        ret
a_endp                  peripheral_sis_isa

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

