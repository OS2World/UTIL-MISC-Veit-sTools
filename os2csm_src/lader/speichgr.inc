Title   Detect memory size

;***************************************************************************
; Erkennung der Speichergr”áe
;***************************************************************************
;   0..  4
;   5..  8
;   9.. 16
;  17.. 24
;  25.. 32
;  33.. 48
;  49.. 64
;  65.. 96
;  97..128
; 129..256
; 257..512
; >=513 MB
;***************************************************************************
p8str name_OS2CSM_MEMORY 'OS2CSM_MEMORY'

ergebnis_summe:         dq 0

a_proc                  bestimme_speichergroesse
                        pushad

                          mov si,Offset name_OS2CSM_MEMORY
                          call suche_variable_p8

                          ; gefunden ?
                          test di,di
                          jz bestimme_speichergroesse_ende


                          call bestimme_speichergroesse_i15_e820
                          jnc bestimme_speichergroesse_bestimmt

                          call bestimme_speichergroesse_i15_e881
                          jnc bestimme_speichergroesse_bestimmt

                          call bestimme_speichergroesse_i15_e801
                          jnc bestimme_speichergroesse_bestimmt

                          call bestimme_speichergroesse_i15_c7
                          jnc bestimme_speichergroesse_bestimmt

                          call bestimme_speichergroesse_i15_88
                          ;jnc bestimme_speichergroesse_bestimmt

  bestimme_speichergroesse_bestimmt:
                          cld
                          mov si,Offset ergebnis_summe
                          lodsd
                          mov ebx,eax
                          lodsd
                          or eax,eax
                          if_nz <or ebx,-1>
                          mov eax,ebx
                          shr eax,20 ; in MB

                          null cx

                          cmp ax,512
                          if_a <inc cx>
                          cmp ax,256
                          if_a <inc cx>
                          cmp ax,128
                          if_a <inc cx>
                          cmp ax,96
                          if_a <inc cx>
                          cmp ax,64
                          if_a <inc cx>
                          cmp ax,48
                          if_a <inc cx>
                          cmp ax,32
                          if_a <inc cx>
                          cmp ax,24
                          if_a <inc cx>
                          cmp ax,16
                          if_a <inc cx>
                          cmp ax,8
                          if_a <inc cx>
                          cmp ax,4
                          if_a <inc cx>

                          inc cx

                          mov [di].aktuelle_einstellung,cx

  bestimme_speichergroesse_ende:
                        popad
                        ret
a_endp                  bestimme_speichergroesse

;***************************************************************************

a_proc                  loesche_speichersumme
                        push2 ax,di
                          mov di,Offset ergebnis_summe
                          sub ax,ax
                          cld
                          stosw
                          stosw
                          stosw
                          stosw
                        pop2 di,ax
                        ret
a_endp                  loesche_speichersumme

;***************************************************************************

ergebnis_e820:          db ergebnis_e820_laenge dup (?)

a_proc                  bestimme_speichergroesse_i15_e820
                        pushad

                          call loesche_speichersumme

                          null ebx
                          mov esi,0534d4150h ; 'SMAP'

  bestimme_speichergroesse_i15_e820_schleife:
                          mov eax,00000e820h
                          mov edx,esi
                          mov ecx,ergebnis_e820_laenge
                          mov di,Offset ergebnis_e820
                          int 015h
                          jc bestimme_speichergroesse_i15_e820_fehler

                          cmp eax,esi
                          jne bestimme_speichergroesse_i15_e820_fehler

                          cmp dword ptr [di+0].ergebnis_e820_t,1
                          jne bestimme_speichergroesse_i15_e820_unbenutzbar

                          mov eax,dword ptr [di+0].ergebnis_e820_l
                          add dword ptr [Offset ergebnis_summe+0],eax
                          mov eax,dword ptr [di+4].ergebnis_e820_l
                          adc dword ptr [Offset ergebnis_summe+4],eax

  bestimme_speichergroesse_i15_e820_unbenutzbar:
                          test ebx,ebx
                          jnz bestimme_speichergroesse_i15_e820_schleife

  bestimme_speichergroesse_i15_e820_ende:
                          ; +640KB (a0000)
                          null eax
                          add  word ptr [Offset ergebnis_summe+2],0000ah
                          adc dword ptr [Offset ergebnis_summe+4],eax
                          clc
                          jmp bestimme_speichergroesse_i15_e820_rueckkehr

  bestimme_speichergroesse_i15_e820_fehler:
                          call loesche_speichersumme
                          stc

  bestimme_speichergroesse_i15_e820_rueckkehr:
                        popad
                        ret
a_endp                  bestimme_speichergroesse_i15_e820

;***************************************************************************

a_proc                  bestimme_speichergroesse_i15_e801
                        pushad

                          call loesche_speichersumme

                          mov ax,0e801h
                          int 015h
                          jc bestimme_speichergroesse_i15_e801_rueckkehr

                          test ax,bx
                          jnz bestimme_speichergroesse_i15_e801_wert_in_ax_bx

                          mov ax,cx
                          mov bx,dx
  bestimme_speichergroesse_i15_e801_wert_in_ax_bx:

                          movzx eax,ax
                          movzx ebx,bx

  i15_e881_i15_e801_gemeinsam:
                          mov di,Offset ergebnis_summe
                          ; ebx*$10000
                          mov dword ptr [di+2],ebx

                          ; eax*$04000
                          shl eax,10
                          ; +640KB
                          add eax,0a0000h
                          add dword ptr [di+0],eax
                          adc dword ptr [di+4],0

                          clc

  bestimme_speichergroesse_i15_e801_rueckkehr:

                        popad
                        ret
a_endp                  bestimme_speichergroesse_i15_e801

;***************************************************************************
a_proc                  bestimme_speichergroesse_i15_e881
                        pushad

                          call loesche_speichersumme

                          mov ax,0e881h
                          int 015h
                          jnc i15_e881_i15_e801_gemeinsam

                        popad
                        ret
a_endp                  bestimme_speichergroesse_i15_e881

;***************************************************************************
tabelle_i15_c7:         db tabelle_i15_c7_laenge dup (0)

a_proc                  bestimme_speichergroesse_i15_c7
                        pushad

                          call loesche_speichersumme

                          mov ah,0c7h
                          mov si,Offset tabelle_i15_c7
                          mov [si].i15c7_tabellenlaenge,tabelle_i15_c7_laenge-2
                          int 015h
                          jc bestimme_speichergroesse_i15_c7_abbruch
                          cld
                          lea si,[si].i15c7_1M_16M
                          lodsd
                          mov ebx,eax
                          lodsd
                          add eax,ebx
                          test eax,eax
                          jz bestimme_speichergroesse_i15_c7_abbruch

                          shl eax,10
                          add eax,0a0000h
                          mov dword ptr [Offset ergebnis_summe+0],eax
                          clc
                          jmp bestimme_speichergroesse_i15_c7_rueckkehr

  bestimme_speichergroesse_i15_c7_abbruch:
                          stc
  bestimme_speichergroesse_i15_c7_rueckkehr:

                        popad
                        ret
a_endp                  bestimme_speichergroesse_i15_c7

;***************************************************************************

a_proc                  bestimme_speichergroesse_i15_88
                        pusha
                          call loesche_speichersumme

                          mov ah,088h
                          int 015h
                          jc bestimme_speichergroesse_i15_88_rueckkehr

                          movzx eax,ax
                          shl eax,10
                          add eax,0a0000h
                          mov dword ptr [Offset ergebnis_summe+0],eax
                          clc
  bestimme_speichergroesse_i15_88_rueckkehr:
                        popa
                        ret
a_endp                  bestimme_speichergroesse_i15_88

;***************************************************************************

