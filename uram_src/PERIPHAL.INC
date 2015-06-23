Title   Suche Baustein fr ISA/DMA: PCI
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

anfang_tabelle_perpherie_controller:

                ;--[AMDK7.INC]---------------------------------------
                ; AMD-756 Periphal Bus Controller
                dw 01022h,07408h,Offset peripheral_controller_AMD_756
                ;----------------------------------------------------

                ;--[VIA580.INC]--------------------------------------
                ; VIA VT82C586/A/B PCI to ISA Bridge
                dw 01106h,00586h,Offset peripheral_controller_VIA_586 ; 21095b.pdf Seite 141
                dw 01106h,00596h,Offset peripheral_controller_VIA_586
                dw 01106h,00686h,Offset peripheral_controller_VIA_586
                ;----------------------------------------------------

                ;--[82430TX.INC]-------------------------------------
                ;
                ; "82378ZB/IB,82379AB PCI to ISA Bridge, System I/O"
                dw 08086h,00484h,Offset peripheral_Intel_SIO
                ;
                ; "82371FB PIIX PCI to ISA Bridge"
                dw 08086h,0122eh,Offset peripheral_Intel_PIIX
                ;
                ; "82371SB PIIX3 ISA Bridge"
                dw 08086h,07000h,Offset peripheral_Intel_PIIX
                ;
                ; "82371AB/EB/MB PIIX4/E/M ISA Bridge"
                dw 08086h,07110h,Offset peripheral_Intel_PIIX
                ;
                ;----------------------------------------------------


                ;--[sis645.inc]--------------------------------------
                ;
                ; "SiS PCI to ISA Bridge (LPC Bridge)"
                dw 01039h,00008h,Offset peripheral_sis_isa
                ;
                ; was ist mit 0006    SiS85C501 CPU to PCI Bridge
                ;             0018    SiS950 PCI to ISA Bridge (LPC Bridge)
                ;             0963    SiS963 PCI to ISA Bridge (LPC Bridge)
                ;             5582    SiS5582 PCI to ISA Bridge
                ;
                ;----------------------------------------------------

ende_tabelle_perpherie_controller:

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

periphal_controller_reg00 dd ?

                ; cf=0 gefunden
                ; cf=1 unbekannt
a_proc          suche_periphal_controller
                pushad

                  ; bridge; pci to isa
                  mov ecx,060100h
                  call search_pci_class_code
                  cmp bx,-1
                  jne periphal_controller_present

                  ; bridge; pci to eisa
                  mov ecx,060200h
                  call search_pci_class_code
                  cmp bx,-1
                  jne periphal_controller_present

                  ; bridge: pci to other
                  mov ecx,068000h
                  call search_pci_class_code
                  cmp bx,-1
                  jne periphal_controller_present


                  ; raten: Ger„t=0, Funktion=1
                  mov bx,1
                  mov si,Offset periphal_controller_reg00
                  sub di,di
                  call pci_read_dword
                  cmp DWord Ptr [si],-1
                  jne periphal_controller_present

                  ; raten: Ger„t=1, Funktion=0
                  mov bx,8
                  mov si,Offset periphal_controller_reg00
                  sub di,di
                  call pci_read_dword
                  cmp DWord Ptr [si],-1
                  jne periphal_controller_present

                  ; weiá nicht -> Fehlermeldung
                  jmp periphal_controller_nicht_gefunden

  periphal_controller_present:
                  mov si,Offset periphal_controller_reg00
                  sub di,di
                  call pci_read_dword

                  mov eax,[si]

                  mov si,Offset anfang_tabelle_perpherie_controller
  suche_periphal_controller_eintrag_schleife:
                  cmp DWord Ptr [si],eax
                  jne suche_periphal_controller_falscher_eintrag

                  call Word Ptr [si+4]
                  clc
                  jmp suche_periphal_controller_ende

  suche_periphal_controller_falscher_eintrag:
                  add si,2+2+2
                  cmp si,Offset ende_tabelle_perpherie_controller
                  jne suche_periphal_controller_eintrag_schleife

  periphal_controller_nicht_gefunden:
                  stc

  suche_periphal_controller_ende:
                popad
                ret
a_endp          suche_periphal_controller

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          suche_periphal_controller_fehlermeldung
                pushad
                  ausschrift text_peripheral_controller_unbekannt
                  mov eax,[periphal_controller_reg00]
                  call ausschrift_word
                  mov al,'/'
                  call ausschrift_zeichen
                  rol eax,16
                  call ausschrift_word
                  mov al,'"'
                  call ausschrift_zeichen
                  ausschrift_a zeilenumbruch
                popad
                ret
a_endp          suche_periphal_controller_fehlermeldung

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
