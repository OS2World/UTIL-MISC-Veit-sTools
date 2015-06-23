Title   Intel 810: PCI
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; keine Dokumentation
; UMBPCI:
;
; 50.15 \ Fxxx 11=RAM
;   .14 /
;   .13 \ Exxx 11=RAM
;   .12 /
;   .11 \ Dxxx 11=RAM
;   .10 /
;   . 9 \ Cxxx 11=RAM
;   . 8 /
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

intel_810_0050          and_or_record <>

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

intel_810_eintrag       Macro SegM,ShlWert
                          dw &SegM
                          db &ShlWert
                        EndM

tabelle_intel_810_anfang:

intel_810_eintrag 'C0', 8
intel_810_eintrag 'C4', 8
intel_810_eintrag 'C8', 8
intel_810_eintrag 'CC', 8
intel_810_eintrag 'D0',10
intel_810_eintrag 'D4',10
intel_810_eintrag 'D8',10
intel_810_eintrag 'DC',10
intel_810_eintrag 'E0',12
intel_810_eintrag 'E4',12
intel_810_eintrag 'E8',12
intel_810_eintrag 'EC',12
intel_810_eintrag 'F0',14

tabelle_intel_810_ende:

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  chip_intel810
                        mov si,Offset tabelle_intel_810_anfang
  tabelle_intel_810_schleife:
                        mov di,Word Ptr [si]
                        call berechne_wert_ax
                        cmp al,unveraendert
                        je unveraendert_intel810_weiter

                        mov cl,Byte Ptr [si+2]
                        mov ebx,3
                        shl ebx,cl
                        not ebx
                        and [intel_810_0050].and_wert,ebx
                        not ebx

                        ; kann nur auf R+W setzten...
                        test ah,3
                        if_nz <or [intel_810_0050].or_wert,ebx>

  unveraendert_intel810_weiter:
                        add si,2+1
                        cmp si,Offset tabelle_intel_810_ende
                        jne tabelle_intel_810_schleife

                        call cache_sichern_und_abschalten

                        installiere_tracer

                        null bx ;?
                        mov si,Offset intel_810_0050
                        mov di,050h
                        call pci_maske_dword

                        entferne_tracer

                        call cache_wiederherstellen

                        jmp initialisieren

a_endp                  chip_intel810

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

