Title   AMD K7 MTRR und AMD-756
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; 22007.PDF Seite 198
;
; MSR Gr붳e Anfang
; 0250 64K 0000,1000,2000,3000,4000,5000,6000,7000
; 0258 16K 8000,8400,8800,8C00,9000,9400,9800,9C00
; 0259 16K A000,A400,A800,AC00,B000,B400,B800,BC00
; 0268  4K C000,C100,C200,C300,C400,C500,C600,C700
; 0269  4K C800,C900,CA00,CB00,CC00,CD00,CE00,CF00
; 026A  4K D000,D100,D200,D300,D400,D500,D600,D700
; 026B  4K D800,D900,DA00,DB00,DC00,DD00,DE00,DF00
; 026C  4K E000,E100,E200,E300,E400,E500,E600,E700
; 026D  4K E800,E900,EA00,EB00,EC00,ED00,EE00,EF00
; 026E  4K F000,F100,F200,F300,F400,F500,F600,F700
; 026F  4K F800,F900,FA00,FB00,FC00,FD00,FE00,FF00
;
; 64 Bit MTRR=8*xx
;
; xx.7 -
; xx.6 -
; xx.5 -
; xx.4 -  MT_RDMEM
; xx.3 -  MT_WRMEM
; xx.2 \   0 Uncachable region
; xx.1  |  1 Write Combining
; xx.0 /   4 Write Thru
;          5 Write Protect
;          6 Write Back
; nichts          = 00
; lesen           = 10+05    = 15
; lesen+schreiben = 10+08+06 = 1e

umrechnungstabelle_amd_k7:
  db 000h               ; 0 -R -W -C
  db 010h               ; 1 +R -W -C
  db 008h               ; 2 -R +W -C
  db 018h               ; 3 +R +W -C
  db 000h               ; 4 -R -W +C ??
  db 015h               ; 5 +R -W +C
  db 008h               ; 6 -R +W +C ??
  db 01eh               ; 7 +R +W +C

;
;
; 22548.PDF (AMD-756 Periperall Bus Controller Data Sheet)
; Seite 222 "202": PCI ID
; Seite 231 "211": ISA DMA/Master Access
;
;  4E.15 \
;     ..  | Top of Memory for ISA DMA/Master
;     12 /
;     11 E000-EFFF
;     10 A000-BFFF
;      9 8000-9FFF
;      8 0000-7FFF
;      7 DC00-DFFF
;      6 D800-DBFF
;      5 D400-D7FF
;      4 D000-D3FF
;      3 CC00-CFFF
;      2 C800-CBFF
;      1 C400-C7FF
;      0 C000-C3FF
;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                                .586p
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

setze_amdk7                     Macro Segm,Index,Wert,DMABit
                                  mov di,&Segm          ; 'C8'
                                  mov cx,&Index         ; 0269
                                  mov bh,&Wert          ; Bit0+Bit1+Bit2+Bit3
                                  mov bl,&DMABit
                                  call setze_amdk7_prozedur
                                EndM

tabelle_amdk7                   Macro Segm,Index,Wert,DMABit
                                  dw &Segm              ; 'C8'
                                  dw &Index             ; 0269
                                  db &Wert              ; Bit0+Bit1+Bit2+Bit3
                                  db &DMABit
                                EndM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

mtrr_fixed_amdk7                dq ?

a_proc                          setze_amdk7_prozedur
                                pushad

                                  call berechne_wert_ax

                                  cmp al,unveraendert
                                  je setze_amdk7_prozedur_fertig

                                  ; DMA-Bit (AMD-756)
                                  cmp bl,-1
                                  je kein_amd_756_bit
                                  test ah,002h ; schreiben
                                  jz kein_amd_756_bit

                                  movzx dx,bl
                                  bts Word Ptr [(Offset reg_AMD_756_4c_or)+04eh-04ch],dx

  kein_amd_756_bit:

                                  call cache_sichern_und_abschalten

                                  ; Register lesen
                                  movzx ecx,cx
                                  rdmsr
                                  call diag_rdmsr

                                  mov DWord Ptr [mtrr_fixed_amdk7+0],eax
                                  mov DWord Ptr [mtrr_fixed_amdk7+4],edx

;edx:eax=32109876 54321098 76543210 98765432 10987654 32109876 54321098 76543210
;        66665555 55555544 44444444 33333333 33222222 22221111 11111100 00000000
; bh     Bit 7    Bit 6    Bit 5    Bit 4    Bit 3    Bit 2    Bit 1    Bit 0

                                  push cx

                                    movzx di,ah
                                    mov cl,Byte Ptr umrechnungstabelle_amd_k7[di]
                                    mov ch,(not 01fh) ; vorher war es (not 018h)
                                    cmp cpu_amd,1
                                    je mtrr_maske_richtig_fuer_amd_k7

                                    ; intel
                                    and cl,007h
                                    mov ch,(not 007h)
  mtrr_maske_richtig_fuer_amd_k7:

                                    mov di,Offset mtrr_fixed_amdk7
  bearbeite_mtrr_amdk7_schleife:
                                    test bh,Bit0
                                    jz nicht_dieses_msr_byte

                                    and Byte Ptr [di],ch
                                    or  Byte Ptr [di],cl
  nicht_dieses_msr_byte:
                                    shr bh,1
                                    inc di
                                    cmp di,Offset mtrr_fixed_amdk7+8
                                    jne bearbeite_mtrr_amdk7_schleife

                                  pop cx

                                  ; 럑derunge schreiben
                                  mov eax,DWord Ptr [mtrr_fixed_amdk7+0]
                                  mov edx,DWord Ptr [mtrr_fixed_amdk7+4]
                                  call diag_wrmsr
                                  wrmsr

                                  call cache_wiederherstellen

  setze_amdk7_prozedur_fertig:
                                popad
                                ret
a_endp                          setze_amdk7_prozedur

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴


anfang_amdk7_tabelle:
                                ; A000-BFFF funktioniert nicht ?
                                tabelle_amdk7 'A0', 0259h, Bit0               , 10
                                tabelle_amdk7 'A4', 0259h, Bit1               , 10
                                tabelle_amdk7 'A8', 0259h, Bit2               , 10
                                tabelle_amdk7 'AC', 0259h, Bit3               , 10
                                tabelle_amdk7 'B0', 0259h, Bit4               , 10
                                tabelle_amdk7 'B4', 0259h, Bit5               , 10
                                tabelle_amdk7 'B8', 0259h, Bit6               , 10
                                tabelle_amdk7 'BC', 0259h, Bit7               , 10

                                tabelle_amdk7 'C0', 0268h, Bit0+Bit1+Bit2+Bit3,  0
                                tabelle_amdk7 'C4', 0268h, Bit4+Bit5+Bit6+Bit7,  1
                                tabelle_amdk7 'C8', 0269h, Bit0+Bit1+Bit2+Bit3,  2
                                tabelle_amdk7 'CC', 0269h, Bit4+Bit5+Bit6+Bit7,  3
                                tabelle_amdk7 'D0', 026Ah, Bit0+Bit1+Bit2+Bit3,  4
                                tabelle_amdk7 'D4', 026Ah, Bit4+Bit5+Bit6+Bit7,  5
                                tabelle_amdk7 'D8', 026Bh, Bit0+Bit1+Bit2+Bit3,  6
                                tabelle_amdk7 'DC', 026Bh, Bit4+Bit5+Bit6+Bit7,  7
                                tabelle_amdk7 'E0', 026Ch, Bit0+Bit1+Bit2+Bit3, 11
                                tabelle_amdk7 'E4', 026Ch, Bit4+Bit5+Bit6+Bit7, 11
                                tabelle_amdk7 'E8', 026Dh, Bit0+Bit1+Bit2+Bit3, 11
                                tabelle_amdk7 'EC', 026Dh, Bit4+Bit5+Bit6+Bit7, 11
                                tabelle_amdk7 'F0', 026Eh, Bit0+Bit1+Bit2+Bit3, -1
                                tabelle_amdk7 'F4', 026Eh, Bit4+Bit5+Bit6+Bit7, -1
                                tabelle_amdk7 'F8', 026Fh, Bit0+Bit1+Bit2+Bit3, -1
                                tabelle_amdk7 'FC', 026Fh, Bit4+Bit5+Bit6+Bit7, -1
ende_amdk7_tabelle:

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                          variante_amdk7
                                ; nur Ausschrift f걊 urami.com
                                ausschrift_xxxx_aehnliches_bios text_variante_amdk7
                                jmp doch_nicht_richtig
a_endp                          variante_amdk7

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                          chip_amdk7
                                call programmiere_amd_k7

                                ; ISA DMA - wenn unterst걎zter Controller vorhanden
                                call suche_periphal_controller
                                ;if_c <call suche_periphal_controller_fehlermeldung>
    no_peripheral_amd:
                                jmp initialisieren
a_endp                          chip_amdk7

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                          programmiere_amd_k7
                                pushad

                                  cmp [v86_mode],1
                                  jne programmiere_amd_k7_realmode

                                  ausschrift text_mtrr_v86
                                  jmp programmiere_amd_k7_ende


  programmiere_amd_k7_realmode:
                                  ; Zugriffstest
                                  mov ecx,0268h
                                  sub di,di
                                  trap_protect <rdmsr>,<inc di>
                                  test di,di
                                  jz programmiere_amd_k7_ende

                                  ; 럑derungen
                                  mov si,Offset anfang_amdk7_tabelle
  schleife_amdk7_tabelle:
                                  setze_amdk7 <Word Ptr [si]>,<Word Ptr [si+2]>,<Byte Ptr [si+2+2]>,<Byte Ptr [si+2+2+1]>
                                  add si,2+2+1+1
                                  cmp si,Offset ende_amdk7_tabelle
                                  jne schleife_amdk7_tabelle
  programmiere_amd_k7_ende:

                                popad
                                ret
a_endp                          programmiere_amd_k7

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

reg_AMD_756_4c_and              dd 0
reg_AMD_756_4c_or               dd 0

a_proc                          peripheral_controller_AMD_756

                                mov si,Offset reg_AMD_756_4c_and
                                mov di,04ch
                                call pci_maske_dword

                                ret
a_endp                          peripheral_controller_AMD_756

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

text_rdmsr1:                    db 'RdMsr[$'
text_rdmsr2:                    db ']=$'
text_wrmsr1:                    db 'WrMsr[$'
text_wrmsr2:                    db ']:=$'
text_umbruch:                   db 13,10,'$'

a_proc                          diag_rdmsr
                                pushad
                                  mov dx,Offset text_rdmsr1
                                  call ausschrift_prozedur
                                  mov eax,ecx
                                  call ausschrift_dword
                                  mov dx,Offset text_rdmsr2
                                  call ausschrift_prozedur
                                popad

                                call ausschrift_prozedur

                                ;pushad
                                ;  mov dx,Offset text_umbruch
                                ;  call ausschrift_prozedur
                                ;popad
                                ret
a_endp                          diag_rdmsr

a_proc                          diag_wrmsr
                                pushad
                                  mov dx,Offset text_wrmsr1
                                  call ausschrift_prozedur
                                  mov eax,ecx
                                  call ausschrift_dword
                                  mov dx,Offset text_wrmsr2
                                  call ausschrift_prozedur
                                popad

                                call ausschrift_prozedur

                                pushad
                                  mov dx,Offset text_umbruch
                                  call ausschrift_prozedur
                                popad
                                ret
a_endp                          diag_wrmsr

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

