Title   load/save screen image, colour palette functions

;***************************************************************************
; Bildschrim laden/speichern
;***************************************************************************
; -> ax
a_proc                          liefere_zeilenzahl
                                push ds
                                  push bios0040
                                  pop ds
                                  movzx ax,byte ptr ds:[number_of_lines_less1] ; Bildschirmzeilen-1
                                  inc ax
                                pop ds
                                ret
a_endp                          liefere_zeilenzahl
;***************************************************************************
; es:=b000/b800
a_proc                          segb800_es
                                push ax
                                  push bios0040
                                  pop es
                                  mov al,Byte Ptr es:[current_video_mode]
                                  and al,07fh
                                  cmp al,007h
                                  setne al
                                  shl ax,11             ; 0000/0800
                                  add ax,biosb000       ; b000/b800
                                  mov es,ax
                                pop ax
                                ret
a_endp                          segb800_es
;***************************************************************************
a_proc                          segb800_ds
                                push es
                                  call segb800_es
                                  push es
                                  pop ds
                                pop es
                                ret
a_endp                          segb800_ds
;***************************************************************************
; -> DS:DI Sicherungstabelle
a_proc                          bildschirm_sichern
                                pusha

                                  ; Cursorposition/Gr”áe sichern
                                  mov ah,003h
                                  mov bh,000h
                                  int 010h
                                  mov [di].cursor    ,cx
                                  mov [di].cursor_pos,dx

                                  ; geraten
                                  mov [di].blinken,1

                                  call liefere_zeilenzahl
                                  mov ah,al

                                  mov al,50
                                  cmp ah,al
                                  jae bilschirm_sichern_zeilenzahl_bekannt
                                  mov al,28
                                  cmp ah,al
                                  jae bilschirm_sichern_zeilenzahl_bekannt
                                  mov al,25
  bilschirm_sichern_zeilenzahl_bekannt:
                                  mov [di].bildschirm_zeilen_belegt,al

                                  mov ah,80 ; *2/2
                                  mul ah
                                  mov cx,ax

                                  push2 ds,es
                                    les di,[di].bildschirm_puffer_zeiger
                                    call segb800_ds
                                    null si
                                    cld
                                    rep movsw
                                  pop2 es,ds

                                popa
                                ret
a_endp                          bildschirm_sichern

;***************************************************************************
; DS:SI->Quelle
; CX Seite (1...)
a_proc                          bildschirm_laden
                                pusha

                                  dec cx
                                  push cx

                                    call liefere_zeilenzahl
                                    mov ah,[si].bildschirm_zeilen_belegt

                                    cmp ah,al
                                    je bildschirm_laden_schrift_richtig

                                    mov al,014h           ; 25,8x16
                                    cmp ah,28
                                    if_ae <mov al,011h>   ; 28,8x14
                                    cmp ah,50
                                    if_ae <mov al,012h>   ; 50,8x8

                                    mov ah,011h
                                    mov bl,0
                                    int 010h
                                    mov boolean_font_redefined,0 ; reset to BIOS font

bildschirm_laden_schrift_richtig:
                                  pop cx

                                  mov al,[si].bildschirm_zeilen_belegt
                                  mov ah,80*2
                                  mul ah        ; Seitengr”áe

                                  xchg ax,cx

                                  mul cx
                                  push2 ds,si

                                    lds si,[si].bildschirm_puffer_zeiger
                                    add si,ax
                                    push es
                                      call segb800_es
                                      null di
                                      shr cx,1
                                      cld
                                      rep movsw
                                    pop es

                                  pop2 si,ds

                                  call berechene_halb_cursor

                                  mov cs:[editor_cursor],ax


                                  ; Cursorgr”áe setzen
                                  mov ah,001h
                                  mov cx,[si].cursor
                                  cmp cx,-1
                                  if_e <mov cx,cs:[editor_cursor]>
                                  int 010h

                                  ; Cursorposition setzen
                                  mov ah,002h
                                  null bx
                                  mov dx,[si].cursor_pos
                                  int 010h

                                  ; Blinken / helle Hintergrundfarben
                                  mov ax,01003h
                                  mov bl,[si].blinken
                                  int 010h

                                popa
                                ret
a_endp                          bildschirm_laden

;***************************************************************************

a_proc                          bildschirm_laden_durchsichtig
                                pusha
                                push es
                                  call segb800_es
                                  null di

                                  mov ah,80
                                  mov al,[si].bildschirm_zeilen_belegt
                                  mul ah
                                  mov cx,ax

                                  push2 ds,si
                                    lds si,[si].bildschirm_puffer_zeiger
                                    mov bx,word ptr ds:[si]
                                    cld
  loop_bildschirm_laden_durchsichtig:
                                    lodsw
                                    cmp ah,bh ; durchsichtig-Attribut ?
                                    if_ne <mov es:[di],ax>
                                    inc di
                                    inc di
                                    dec cx
                                    jnz loop_bildschirm_laden_durchsichtig

                                  pop2 si,ds

                                  ; Cursorgr”áe setzen
                                  mov ah,001h
                                  mov cx,[si].cursor
                                  int 010h

                                  ; Cursorposition setzen
                                  mov ah,002h
                                  null bx
                                  mov dx,[si].cursor_pos
                                  int 010h

                                pop es
                                popa
                                ret
a_endp                          bildschirm_laden_durchsichtig

;***************************************************************************
editor_cursor                   dw ? ; Empfehlung fr den n„chsten Cursor
;***************************************************************************
p8str name_OS2CSM_INSERTMODE    'OS2CSM_INSERT_MODE'

a_proc                          setze_einfuege_oder_ueberschreibmodus
                                pusha
                                  mov si,Offset name_OS2CSM_INSERTMODE
                                  call suche_variable_p8
                                  test di,di
                                  jz setze_einfuege_oder_ueberschreibmodus_ende

                                  mov ax,[di].aktuelle_einstellung
                                  shl al,7 ; $80/$00 keyboard_status0_insert
                                  push ds
                                    push bios0040
                                    pop ds
                                    mov si,keyboard_flag_byte0
                                    and byte ptr ds:[si],not keyboard_status0_insert
                                    or  byte ptr ds:[si],al
                                  pop ds
setze_einfuege_oder_ueberschreibmodus_ende:
                                popa
                                ret
a_endp                          setze_einfuege_oder_ueberschreibmodus

;***************************************************************************
; ->ES:DX (64*3 byte)

a_proc                          sichere_palette
                                push ax
                                  mov ax,01017h ; read block of DAC color registers
                                  call palette_funktion
                                pop ax
                                ret
a_endp                          sichere_palette

;***************************************************************************
; ->ES:DX (64*3 byte)

a_proc                          setze_palette
                                cmp [menu_palette_benutzen],0
                                je exit_setze_palette

                                pusha
                                  mov ax,01012h ; set block of DAC color registers
                                  call palette_funktion

                                  mov ax,01002h
                                  mov dx,Offset ega_palette
                                  mov bh,0
                                  int 010h

                                popa
  exit_setze_palette:
                                ret
a_endp                          setze_palette

;***************************************************************************
ega_palette:                    db  0, 1, 2, 3, 4, 5,20, 7      ; dunkel
                                db 56,57,58,59,60,61,62,63      ; hell
                                db  0                           ; Rand
;***************************************************************************

a_proc                          palette_funktion

                                ; Jeden Zugriff einsparen weil wirkungslos
                                cmp [menu_palette_benutzen],0
                                je exit_palette_funktion

                                pusha
                                  ; 0..5 (0..5)
                                  null bx
                                  mov cx,6
                                  int 010h
                                  add dx,3*6

                                  ; 6 (20)
                                  mov bl,20
                                  mov cl,1
                                  int 010h
                                  add dx,3

                                  ; 7 (7)
                                  mov bl,7
                                  int 010h
                                  add dx,3

                                  ; 8..15 (56..63)
                                  mov bl,56
                                  mov cl,8
                                  int 010h
                                popa
  exit_palette_funktion:
                                ret
a_endp                          palette_funktion

;***************************************************************************
