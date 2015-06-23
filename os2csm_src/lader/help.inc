Title   display help in memdisk mode

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

os2csm_help_signature  db 'OS2CSM Helpfile',('Z'-'@');
os2csm_help_signature_size equ $-Offset os2csm_help_signature

os2csm_hlp_kopf         Struc
  oh_signatur           db (os2csm_help_signature_size) dup (?)
  oh_vgaattribute       db ?
  oh_anzahl             dw ?
os2csm_hlp_kopf         EndS

os2csm_hlp_eintrag_kopf Struc
  oh_laenge             dw ?
  oh_seite              db ?
  oh_variable           dw ?
  oh_zeilen             db ?
  oh_spalten            db ?
os2csm_hlp_eintrag_kopf EndS


hilfe_allgemein         dw -1
hilfe_seite             dw -1
hilfe_variable          dw -1

ifdef language_jp
  frame_chars1            db 010h,01eh,011h
  frame_chars2            db 01dh,' ' ,01dh
  frame_chars3            db 018h,01eh,019h
else
  frame_chars1            db 'ÚÄ¿'
  frame_chars2            db '³ ³'
  frame_chars3            db 'ÀÄÙ'
endif

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; muá nichts sichern, es wird alles neu gezeichnet

a_proc          hilfe_anzeigen
                push ds
                push es
                pusha

                  mov ax,-1
                  mov hilfe_allgemein,ax
                  mov hilfe_seite,ax
                  mov hilfe_variable,ax


                  call bestimme_menu_zeiger_si
                  mov bp,si

IFDEF memdisk
                  cmp icmd.os2csm_hlp_memory,0
                  je hilfe_anzeigen_exit
                  cmp icmd.os2csm_hlp_size,Size os2csm_hlp_kopf
                  jbe hilfe_anzeigen_exit

                  lds si,icmd.os2csm_hlp_memory
ELSE ; memdisk
                  mov si,ofs_internal_helpfile
                  cmp si,-1
                  je hilfe_anzeigen_exit
ENDIF ; memdisk
                  push cs
                  pop es
                  mov di,Offset os2csm_help_signature
                  mov cx,os2csm_help_signature_size
                  push si
                  repe cmpsb
                  pop si
                  jne hilfe_anzeigen_exit

                  mov bl,ds:[si].oh_vgaattribute
                  mov cx,ds:[si].oh_anzahl
                  add si,Size os2csm_hlp_kopf

                  mov di,bp                     ; aktuelle variable

                  test cx,cx
                  jz hilfe_suchen_fertig
  hilfe_suchen_schleife:
                  mov al,ds:[si].oh_seite
                  mov dx,ds:[si].oh_variable

                  test al,al ; Seite=0 -> fr alle Seiten
                  if_z <mov es:hilfe_allgemein,si>

                  cmp al,es:[di].seitennummer
                  jne hilfe_suchen_falsche_seite

                  test dx,dx ; Variable=0 -> fr ganze Seite
                  if_z <mov es:hilfe_seite,si>

                  cmp dx,es:[menu_position] ; richtige Variable
                  if_e <mov es:hilfe_variable,si>

  hilfe_suchen_falsche_seite:
                  add si,ds:[si].oh_laenge
                  add si,Size os2csm_hlp_eintrag_kopf
                  loop hilfe_suchen_schleife

  hilfe_suchen_fertig:

                  mov si,es:hilfe_allgemein
                  mov ax,es:hilfe_seite
                  cmp ax,-1
                  if_ne <mov si,ax>
                  mov ax,es:hilfe_variable
                  cmp ax,-1
                  if_ne <mov si,ax>
                  cmp si,-1
                  je hilfe_anzeigen_exit

                  ; ds:si=Hilfe
                  ; es:di=Variable

                  ; Positionierung: mittig auf dem Bildschirm
                  ; verbesserbar: so das die Variable sichtbar bleibt..


                 ;mov dl,es:[di].x_position
                 ;mov dh,es:[di].y_position


                  push bios0040
                  pop es
                  mov dx,es:[number_of_columns]
                  mov dh,es:[number_of_lines_less1]
                  inc dh

                  mov ch,ds:[si].oh_zeilen
                  mov cl,ds:[si].oh_spalten
                                                ; 123   456
                                                ; +-------+1
                                                ; |       |2
                  add cx,00406h                 ; |  XXX  |
                                                ; |       |3
                                                ; +-------+4
                  sub dx,cx
                  shr dl,1
                  shr dh,1

                  mov ah,bl                     ; text attribute
                  call segb800_es

                  ; Rechteck zeichnen

                  push ds
                  pusha

                    push cs
                    pop ds
                    mov si,Offset frame_chars1

  loop_zeichne_hilfe_rechteck:
                    cmp ch,1
                    if_e <mov si,Offset frame_chars3>
                    push cx
                    push dx
                      call berechne_di_aus_dx
                      cld
                      lodsb     ; ''
                      stosw
                      lodsb     ;
                      mov ch,0
                      dec cx
                      dec cx
                      rep stosw
                      lodsb
                      stosw
                    pop dx
                    pop cx
                    mov si,Offset frame_chars2
                    ; +1 line
                    add dh,1
                    sub ch,1
                    jnz loop_zeichne_hilfe_rechteck


                  popa
                  pop ds

                  ;  Inhalt zeichnen

                  add dx,00203h

                  mov cx,ds:[si].oh_laenge
                  add si,Size os2csm_hlp_eintrag_kopf

  zeichen_hilfeinhalt_schleife_neue_zeile:
                  call berechne_di_aus_dx
  zeichen_hilfeinhalt_schleife:
                  test cx,cx
                  jz zeichen_hilfeinhalt_fertig

                  dec cx

                  lodsb

                  cmp al,13 ; ignorieren
                  je zeichen_hilfeinhalt_schleife

                  cmp al,10
                  je zeichen_hilfeinhalt_zeilenumbruch

                  stosw
                  jmp zeichen_hilfeinhalt_schleife

  zeichen_hilfeinhalt_zeilenumbruch:
                  add dh,1
                  jmp zeichen_hilfeinhalt_schleife_neue_zeile


  zeichen_hilfeinhalt_fertig:

                  ; Cursor verstecken
                  mov ah,001h
                  mov cx,02000h
                  int 010h

                  ; auf Tastendruch warten
                  call taste

  hilfe_anzeigen_exit:

                popa
                pop es
                pop ds
                ret
a_endp          hilfe_anzeigen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          berechne_di_aus_dx
                push ds
                push ax
                  push bios0040
                  pop ds
                  mov ax,ds:[number_of_columns]
                  mov ah,dh ; Y*Zeilenl„nge
                  mul ah
                  add al,dl ; Y*Zeilenl„nge+X
                  adc ah,0
                  add ax,ax ; 2*(Y*Zeilenl„nge+X)
                  mov di,ax
                pop ax
                pop ds
                ret
a_endp          berechne_di_aus_dx

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
