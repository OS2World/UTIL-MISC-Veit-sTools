Title   Search memory reserved by os2boot_.ac

;***************************************************************************
; Suchen des von OS2BOOT reservierten Speichers
;***************************************************************************
; Eingabe
; Ausgabe
;   AX=Segement oder 0
;
a_proc                          suche_reservierten_speicher
                                push3 ds,si,bx

                                  mov bx,Offset ende_tsr
                                 ;sub bx,0
                                  add bx,15
                                  shr bx,4

                                  int 012h
                                  shl ax,6
                                  ; Grafikspeicherbereich (640K)
                                  cmp ax,0a000h
                                  je kein_reservierter_speicher
suchschleife:
                                  mov ds,ax
                                  null si
                                  ; Speicherblocksignatur ?
                                  cmp [si].mcb_kennung,'Z'
                                  if_ne <cmp [si].mcb_kennung,'M'>
                                  jne kein_reservierter_speicher

                                  ; L„nge ausreichend ?
                                  ;**cmp w [si+mcb_anzahl_para],(ende_tsr-0+15)/16
                                  cmp [si].mcb_anzahl_para,bx
                                  jb weitersuchen

                                  ; "OS2CSM" ?
                                  cmp dword ptr [si+0].mcb_name,'C2SO'
                                  jne weitersuchen
                                  cmp word ptr [si+4].mcb_name,'MS'
                                  je reservierter_speicher_gefunden

  weitersuchen:
                                  add ax,[si].mcb_anzahl_para   ; Blockl„nge
                                  inc ax                        ; Kopfl„nge
                                  jmp suchschleife

kein_reservierter_speicher:
                                  null ax
reservierter_speicher_gefunden:
                                pop3 bx,si,ds
                                ret
a_endp                          suche_reservierten_speicher

;***************************************************************************

