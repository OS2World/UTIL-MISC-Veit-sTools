Title   Ali Aladdin V
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; 542cD06.BIN (0-ALADDIN5-2A5KKJ1EC-00), UMBPCI
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;
; 54.(57-54)*8+7 \
;    (57-54)*8+6 | Fxxx Lesen
;    (57-54)*8+5 |
;    (57-54)*8+4 /
;    (57-54)*8+3 \
;    (57-54)*8+2 | Exxx Lesen
;    (57-54)*8+1 |
;    (57-54)*8+0 /
;    (56-54)*8+7 \
;    (56-54)*8+6 | Dxxx Lesen
;    (56-54)*8+5
;    (56-54)*8+4
;    (56-54)*8+3 - CC00 Lesen
;    (56-54)*8+2 - C800 Lesen
;    (56-54)*8+1 - C400 Lesen
;    (56-54)*8+0 - C000 Lesen


; 58.(5b-58)*8+X Exxx(-Fxxx) ?? (UMBPCI - DMA?)
;    (5a-58)*8+X Cxxx-Dxxx ?? (UMBPCI - DMA?)
;    (59-58)*8+7 Fxxx Schreiben
;    (59-58)*8+6
;    (59-58)*8+5
;    (59-58)*8+4
;    (59-58)*8+3 \
;    (59-58)*8+2 | Exxx Schreiben
;    (59-58)*8+1 |
;    (59-58)*8+0 /
;    (58-58)*8+x Dxxx/Cxxx Schreiben

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

ali_aladdin_v_eintrag   Macro SegM,BitIndex
                          dw &SegM
                          db &BitIndex
                        EndM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; vielleicht brauche ich daf걊 auch keine Tabelle...

tabelle_ali_aladdin_v_anfang:
  ali_aladdin_v_eintrag 'C0', 0
  ali_aladdin_v_eintrag 'C4', 1
  ali_aladdin_v_eintrag 'C8', 2
  ali_aladdin_v_eintrag 'CC', 3
  ali_aladdin_v_eintrag 'D0', 4
  ali_aladdin_v_eintrag 'D4', 5
  ali_aladdin_v_eintrag 'D8', 6
  ali_aladdin_v_eintrag 'DC', 7
  ali_aladdin_v_eintrag 'E0', 8
  ali_aladdin_v_eintrag 'E4', 9
  ali_aladdin_v_eintrag 'E8',10
  ali_aladdin_v_eintrag 'EC',11
  ali_aladdin_v_eintrag 'F0',12
  ali_aladdin_v_eintrag 'F4',13
  ali_aladdin_v_eintrag 'F8',14
  ali_aladdin_v_eintrag 'FC',15
tabelle_ali_aladdin_v_ende:

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
a_proc                  chip_amd_k7__ALiMAGiK_1
                        ; Das BIOS hat beides - ist das ein generisches BIOS
                        ; oder werden auch nicht-AMD K7-Prozessoren unterst걎zt?
                        call programmiere_amd_k7
                        jmp chip_ali_aladdin_v
a_endp                  chip_amd_k7__ALiMAGiK_1
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

ali_aladdin_v_0054      and_or_record <>
ali_aladdin_v_0058      and_or_record <>

a_proc                  chip_ali_aladdin_v
                        mov si,Offset tabelle_ali_aladdin_v_anfang
  tabelle_ali_aladdin_v_schleife:
                        mov di,Word Ptr [si+0]
                        call berechne_wert_ax
                        cmp al,unveraendert
                        je tabelle_ali_aladdin_v_weiter

                        ; 56/57: Lesen
                        movzx ecx,Byte Ptr [si+2]
                        add cx,(056h-054h)*8
                        btr [ali_aladdin_v_0054].and_wert,ecx
                        test ah,1
                        if_nz <bts [ali_aladdin_v_0054].or_wert,ecx>

                        ; 58/59: Schreiben
                        movzx ecx,Byte Ptr [si+2]
                        btr [ali_aladdin_v_0058].and_wert,ecx
                        test ah,2
                        if_nz <bts [ali_aladdin_v_0058].or_wert,ecx>

                        ; 5a/5b: Unbekannt (ISA DMA abschalten? Cache-Schreibschutz?)
                        movzx ecx,Byte Ptr [si+2]
                        add cx,(05ah-058h)*8
                        btr [ali_aladdin_v_0058].and_wert,ecx
                        test ah,2
                        if_z <bts [ali_aladdin_v_0058].or_wert,ecx>

  tabelle_ali_aladdin_v_weiter:
                        add si,2+1
                        cmp si,Offset tabelle_ali_aladdin_v_ende
                        jne tabelle_ali_aladdin_v_schleife


                        call cache_sichern_und_abschalten

                        installiere_tracer

                        null bx
                        mov si,Offset ali_aladdin_v_0054
                        mov di,054h
                        call pci_maske_dword

                        mov si,Offset ali_aladdin_v_0058
                        mov di,058h
                        call pci_maske_dword

                        entferne_tracer

                        call cache_wiederherstellen

                        jmp initialisieren

a_endp                  chip_ali_aladdin_v



