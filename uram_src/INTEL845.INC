Title   Intel 82845/860/865/875/855
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; 25252501.pdf Seite 59..
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

intel_845_0090          and_or_record <>
intel_845_0094          and_or_record <>

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

intel_845_eintrag       Macro SegM,RegIndex,ShlWert
                          dw &SegM
                          dw &RegIndex
                          db &ShlWert
                        EndM

tabelle_intel_845_anfang:

; Axxx/Bxxx ist wieder durch SMM blockiert
intel_845_eintrag 'C0',<Offset intel_845_0090+091h-090h>,0
intel_845_eintrag 'C4',<Offset intel_845_0090+091h-090h>,4
intel_845_eintrag 'C8',<Offset intel_845_0090+092h-090h>,0
intel_845_eintrag 'CC',<Offset intel_845_0090+092h-090h>,4
intel_845_eintrag 'D0',<Offset intel_845_0090+093h-090h>,0
intel_845_eintrag 'D4',<Offset intel_845_0090+093h-090h>,4
intel_845_eintrag 'D8',<Offset intel_845_0094+094h-094h>,0
intel_845_eintrag 'DC',<Offset intel_845_0094+094h-094h>,4
intel_845_eintrag 'E0',<Offset intel_845_0094+095h-094h>,0
intel_845_eintrag 'E4',<Offset intel_845_0094+095h-094h>,4
intel_845_eintrag 'E8',<Offset intel_845_0094+096h-094h>,0
intel_845_eintrag 'EC',<Offset intel_845_0094+096h-094h>,4
intel_845_eintrag 'F0',<Offset intel_845_0090+090h-090h>,4

tabelle_intel_845_ende:

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  variante_intel845_awardflash
                        ausschrift_xxxx_aehnliches_bios text_variante_intel845_awardflash
                       ;jmp chip_intel845
a_endp                  variante_intel845_awardflash


a_proc                  chip_intel845
                        mov si,Offset tabelle_intel_845_anfang
  tabelle_intel_845_schleife:
                        mov di,Word Ptr [si]
                        call berechne_wert_ax
                        cmp al,unveraendert
                        je unveraendert_intel845_weiter

                        mov bh,ah               ; or
                        and bh,3
                        mov bl,(not 3)          ; and
                        mov di,Word Ptr [si+2]
                        mov cl,Byte Ptr [si+2+2]
                        rol bh,cl
                        rol bl,cl
                        and Byte Ptr [di+0],bl
                        or  Byte Ptr [di+4],bh

  unveraendert_intel845_weiter:
                        add si,2+2+1
                        cmp si,Offset tabelle_intel_845_ende
                        jne tabelle_intel_845_schleife

                        call cache_sichern_und_abschalten

                        installiere_tracer

                        null bx ;?
                        mov si,Offset intel_845_0090
                        mov di,090h
                        call pci_maske_dword

                        mov si,Offset intel_845_0094
                        mov di,094h
                        call pci_maske_dword

                        entferne_tracer

                        call cache_wiederherstellen

                        jmp initialisieren

a_endp                  chip_intel845

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

