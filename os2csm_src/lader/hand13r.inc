Title   Handlers for INT 13 to modify config.sys on load

;***************************************************************************

a_proc                          int10und13_entfernen
                                ; Int10 und Int13 entfernen
                                pushad
                                  push ds
                                    push 0
                                    pop ds

                                    mov ax,cs
                                    cmp ax,textspeicher_unbenutzt_segment
                                    jne int10_unberuehrt2

                                    mov eax,cs:[int10_org]
                                    mov ds:[4*010h],eax
                                    mov ds:[004f0h+1],eax

  int10_unberuehrt2:
                                    mov eax,cs:[int13_org]
                                    mov ds:[4*013h],eax
                                    mov ds:[004f8h+1],eax

                                    int 012h
                                    shl ax,6
                                    mov dx,cs
                                    dec dx       ; MCB=CS-1
                                    cmp ax,dx
                                    jne kann_speicher_nicht_zurueckgeben

                                    ; "MCB"
                                    mov ds,ax
                                    null si
                                    ; EigentÅmer: "frei"
                                    mov ds:[si].mcb.mcb_eigentuemer_mcb,0
                                    ; Anzahl 16 Byte Blîcke
                                    mov ax,ds:[si].mcb.mcb_anzahl_para
                                    ; +16 Byte Kopf
                                    inc ax
                                    ; 1024/16=64=2^6
                                    shr ax,6

                                    ; BIOS Datenbereich
                                    push bios0040
                                    pop ds
                                    ; Speicher zurÅckgeben
                                    add ds:[number_of_KB],ax
kann_speicher_nicht_zurueckgeben:
                                  pop ds
                                popad
                                ret
a_endp                          int10und13_entfernen

;***************************************************************************

a_proc                          int10_behandlung
                                cmp ah,00eh
                                je jmp_int10_org

                                cmp ah,000h
                                je int10_00xx

                                nop ; i n t 3

jmp_int10_org:
                                db 0eah
int10_org                       dd ?

int10_00xx:
                                ; Lîschen des Bildschirmspeichers umgehen: bit 7
                                ; immer Text Modus 80*25
                                nop ; i n t 3
                                mov al,083h
                                pushf
                                call dword ptr cs:[int10_org]

                                ; Lîschen des sichtbaren Bereiches
                                push ds
                                pusha

                                  push bios0040
                                  pop ds

                                  mov ax,00600h
                                  mov bh,007h       ; mov bh,01eh=gelb auf blau
                                  mov cx,00000h
                                 ;mov dx,0184fh
                                  mov dh,Byte Ptr ds:[number_of_lines_less1]
                                  mov dl,Byte Ptr ds:[number_of_columns]
                                  dec dx

                                  pushf
                                  call DWord Ptr cs:[int10_org]

                                  ; reset bit 7
                                  and Byte Ptr ds:[current_video_mode],07fh
                                  ; reset bit 7
                                  and Byte Ptr ds:[video_mode_options],07fh

                                popa
                                pop ds

                                iret
a_endp                          int10_behandlung

;***************************************************************************

a_proc                          int13_behandlung

                                cmp ah,002h
                                je int13_02xx

                                cmp ah,042h
                                je int13_42xx

                                db 0eah
int13_org                       dd ?

int13_42xx:                     ; Warp4,Fixpack 14 ...

                                ; Anzahl Sektoren merken
                                push word ptr ds:[si+2]
                                pop cs:[anzahl_sektoren]

                                ; Lesen
                                pushf
                                call dword ptr cs:[int13_org]
                                jc iret_pass_carry

                                push2 es,bx
                                  les bx,[si+4]
                                  call bearbeite_speicher
                                pop2 bx,es
                                jmp iret_clc

                                ;------------------------------------
int13_02xx:
                                ; Anzahl Sektoren merken
                                push ax
                                  mov ah,0
                                  mov cs:[anzahl_sektoren],ax
                                pop ax

                                pushf
                                call dword ptr cs:[int13_org]
                                jc iret_pass_carry

                                call bearbeite_speicher
                               ;jmp iret_clc
  iret_clc:
                                clc
  iret_pass_carry:
                                push bp
                                mov bp,sp
                                  push ax
                                    setc al
                                    and byte ptr ss:[bp+2+2+2],(not 1)
                                    or  byte ptr ss:[bp+2+2+2],al
                                  pop ax
                                pop bp
                                iret
a_endp                          int13_behandlung

;***************************************************************************
anzahl_sektoren                 dw 0
;***************************************************************************

