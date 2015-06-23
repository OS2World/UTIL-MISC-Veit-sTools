Title   Screen output, keyboard input, timing, upcase, string compare

;***************************************************************************
; CS:SI Zeichenkette, CX Zeichen
;
ausschrift_l_cx:
                                push4 ds,ax,cx,si
                                  push cs
                                  pop ds
                                  cld
                                  jmp short ausschrift_l_cx_weiter
; FS:SI Zeichenkette, CX Zeichen
;
ausschrift_l_cx_FS_SI:
                                push4 ds,ax,cx,si
                                  push fs
                                  pop ds
                                  cld
                                  jmp short ausschrift_l_cx_weiter
; CS:SI p8-Zeichenkette
;
ausschrift_p8:
                                push4 ds,ax,cx,si
                                  push cs
                                  pop ds
                                  cld
                                  null ax
                                  lodsb
;                                  jmp short ausschrift_8_16_gemeinsam
;; CS:SI p16-Zeichenkette
;ausschrift_p16:
;                                push4 ds,ax,cx,si
;                                  push cs
;                                  pop ds
;                                  cld
;                                  lodsw
;ausschrift_8_16_gemeinsam:
                                  mov cx,ax
  ausschrift_l_cx_weiter:
                                  jcxz ausschrift_ende
  ausschrift_schleife:
                                  lodsb
                                  call ausschrift_zeichen
                                  loop ausschrift_schleife
  ausschrift_ende:
                                pop4 si,cx,ax,ds
                                ret
;***************************************************************************
COMMENT $
#if mit
pause:
                                push ax
                                  mov al,'?'
                                  call ausschrift_zeichen
                                  call taste
                                  mov al,8
                                  call ausschrift_zeichen
                                  mov al,' '
                                  call ausschrift_zeichen
                                  mov al,8
                                  call ausschrift_zeichen
                                pop ax
                                ret
#endif ; mit
$
;***************************************************************************

a_proc                          taste

                                ; APPLE machines have 'compatibility problems' with USB keyboards
                                ; can only call the function to wait and get a key when a key is
                                ; available

; 000FE000:  3C 3C 4F 52-47 53 3E 3E-00 00 50 43-49 20 49 42  <<ORGS>>  PCI IB
; 000FE010:  4D 20 00 00-00 00 00 00-00 00 00 00-00 00 00 00  M
; 000FE020:  52 53 44 20-50 54 52 20-83 41 50 50-4C 45 20 02  RSD PTR .APPLE .


                                push ds
                                  push 0f000h
                                  pop ds
                                  cmp DWord Ptr ds:[0e029h],04c505041h
                                pop ds
                                jne @@not_apple_keyboard_problem

  @@repeat_until_keypressed:
                                mov ah,011h
                                int 016h
                                jz @@repeat_until_keypressed

  @@not_apple_keyboard_problem:
                                mov ah,010h
                                int 016h

                                ; Zeitgrenze ausschalten
                                push eax
                                  ; 12 Stunden=12*60*60*18.2=786240=$000BFF40
                                  mov eax,786240
                                  call setze_zeitgrenze
                                pop eax
                                mov cs:zeitgrenze_abgeschaltet,true

                                cmp ax,0e00dh
                                if_e <mov ax,01c0dh>

                                cmp ah,0e0h ; graue Tasten
                                if_e <mov ah,0>

                                cmp al,0e0h ; graue Tasten
                                if_e <mov al,0>

                                ret
a_endp                          taste
;***************************************************************************

a_proc                          taste_mit_zeitgrenze

                                cmp cs:zeitgrenze_abgeschaltet,true
                                je taste

                                cmp cs:zeitgrenze_ueberschritten,true
                                je sondertaste_zeitgrenze

                                mov ah,011h
                                int 016h
                                jnz taste

                                push eax

                                  ; EAX:=aktuelle Zeit
                                  call lade_eax_mit_18tel_sekundenzaehler

                                  ; EAX:= -verbleibende Zeit bis zur Grenze
                                  sub eax,cs:[zeitgrenze]

                                  ; nur hîhere Bit werden verglichen (ZF)
                                  shr eax,16

                                pop eax
                                jne taste_mit_zeitgrenze

  sondertaste_zeitgrenze:

                                ; Sondertaste "Zeitgrenze"
                                mov ax,0ffffh
                                mov cs:zeitgrenze_ueberschritten,true
                                ret
a_endp                          taste_mit_zeitgrenze

;***************************************************************************
; eax
a_proc                          setze_zeitgrenze
                                pushad

                                  mov ebx,eax
                                  call lade_eax_mit_18tel_sekundenzaehler
                                  add eax,ebx

                                  ; 24 Stunden=24*60*60*18.2=1572480=$0017FE80
                                  mov ebx,1572480
                                  cmp eax,ebx
                                  jnae unter_24
  ueber_24:
                                  sub eax,ebx
  unter_24:
                                  mov cs:[zeitgrenze],eax

                                popad
                                ret
a_endp                          setze_zeitgrenze

;***************************************************************************
zeitgrenze                      dd ?
zeitgrenze_abgeschaltet         db false
zeitgrenze_ueberschritten       db false
;***************************************************************************

a_proc                          lade_eax_mit_18tel_sekundenzaehler
                                push ds

                                  push bios0040
                                  pop ds

                                  mov eax,ds:[daily_timer_counter]

                                pop ds
                                ret
a_endp                          lade_eax_mit_18tel_sekundenzaehler

;***************************************************************************

; Ausgabe
;   ZF=0 EinfÅgemodus
;   ZF=1 öberschreibmodus
a_proc                          frage_ob_ueberschreibmodus
                                push ds
                                  push bios0040
                                  pop ds
                                  test byte ptr ds:[keyboard_flag_byte0],keyboard_status0_insert
                                pop ds
                                ret
a_endp                          frage_ob_ueberschreibmodus

;***************************************************************************
; ax
a_proc                          setze_cursor_form
                                pusha
                                  mov cx,ax
                                  mov ah,01h
                                  int 010h
                                popa
                                ret
a_endp                          setze_cursor_form

;***************************************************************************

a_proc                          setze_einfuege_ueberschreibcursor
                                push ax
                                  call berechene_halb_cursor
                                  call frage_ob_ueberschreibmodus
                                  if_z <mov ah,0> ; Block
                                  call setze_cursor_form
                                pop ax
                                ret
a_endp                          setze_einfuege_ueberschreibcursor

;***************************************************************************

a_proc                          liefere_cursorform
                                push4 bx,cx,dx,bp
                                  mov ah,003h
                                  null bx
                                  int 010h
                                  mov ax,cx
                                pop4 bp,dx,cx,bx
                                ret
a_endp                          liefere_cursorform

;***************************************************************************

a_proc                          ausschrift_zeilenumbruch
                                push ax
                                  mov al,13
                                  call ausschrift_zeichen
                                  mov al,10
                                  call ausschrift_zeichen
                                pop ax
                                ret
a_endp                          ausschrift_zeilenumbruch

;***************************************************************************
farbe                           db 007h

a_proc                          ausschrift_zeichen
                                pusha
                                  cmp al,7
                                  je farblos
                                  cmp al,8
                                  je farblos
                                  cmp al,10
                                  je farblos
                                  cmp al,13
                                  je farblos

                                  mov ah,009h
                                  mov bh,0
                                  mov bl,cs:[farbe]
                                  mov cx,1
                                  int 010h
farblos:
                                  mov ah,00eh
                                  mov bh,0
                                  mov bl,cs:[farbe]
                                  int 010h
                                popa
                                ret
a_endp                          ausschrift_zeichen

;***************************************************************************
ifdef debug
a_proc                          ausschrift_dxax
                                xchg ax,dx
                                call ausschrift_word
                                xchg ax,dx
                                call ausschrift_word
                                ret
a_endp                          ausschrift_dxax
;***************************************************************************
a_proc                          ausschrift_word
                                rol ax,8
                                call ausschrift_byte
                                rol ax,8
                                call ausschrift_byte
                                ret
a_endp                          ausschrift_word
;***************************************************************************
a_proc                          ausschrift_byte
                                rol al,4
                                call ausschrift_halbbyte
                                rol al,4
                                call ausschrift_halbbyte
                                ret
a_endp                          ausschrift_byte
;***************************************************************************
a_proc                          ausschrift_halbbyte
                                push ax
                                  and al,00fh
                                  add al,'0'
                                  cmp al,'9'
                                  if_a <add al,('A'-'0'-10)>
                                  call ausschrift_zeichen
                                pop ax
                                ret
a_endp                          ausschrift_halbbyte
endif                           ; debug
;***************************************************************************
; AX
a_proc                          ausschrift_zahl
                                push2 si,cx
                                  mov si,Offset ausschrift_zahl_puffer
                                  call Int2Str
                                  call ausschrift_p8
                                pop2 cx,si
                                ret
a_endp                          ausschrift_zahl

p8str ausschrift_zahl_puffer    '00000'

;***************************************************************************
ifdef debug

                                ; es:bx
a_proc                          dump_anfang
                                pusha
                                  mov cx,50
  dump_anfang_schleife:
                                  mov al,es:[bx]
                                  cmp al,020h
                                  if_be <mov al,'.'>
                                  call ausschrift_zeichen
                                  inc bx
                                  loop dump_anfang_schleife

                                  mov al,' '
                                  call ausschrift_zeichen

                                popa
                                ret
a_endp                          dump_anfang

endif                           ; debug

;***************************************************************************
a_proc                          warte_1_sekunde
;                                push2 ds,ax
;                                  push bios0040
;                                  pop ds
;                                  mov ax,ds:[daily_timer_counter]
;                                  add ax,18 ; 18*1/18
;  warte_1_sekunde_schleife:
;                                  cmp ax,ds:[daily_timer_counter]
;                                  jne warte_1_sekunde_schleife
;                                pop2 ax,ds
;                                ret

; 1000000 Ês
sekunde_h                       equ 15
sekunde_l                       equ 16960

                                pusha
                                  mov ah,086h
                                  mov cx,sekunde_h
                                  mov dx,sekunde_l
                                  int 015h
                                popa
                                ret
a_endp                          warte_1_sekunde
;***************************************************************************
;    ZF ROLLEN aus
; notZF ROLLEN an
a_proc                          ermittle_rollen_status
                                pusha
                                  mov ah,002h
                                  int 016h
                                  test al,010h ; scroll lock
                                popa
                                ret
a_endp                          ermittle_rollen_status
;***************************************************************************
; ds:si 1..5 Ziffern (4-stellige Sektornummer oder 16-Bit Zahl
; -> ax
; si weitergerÅckt

a_proc                          lies_dezimalzahl
                                push4 bx,cx,di,es

                                  ; fÅr es:di-Vergleiche
                                  push cs
                                  pop es

                                  null bx

                                  ;mov bx,0 ; falsch
                                  mov di,Offset p8str_false
                                  call vergleiche_zeichenfolge_p8_grossklein
                                  je lies_dezimalzahl_boolean

                                  ;mov bx,0 ; falsch
                                  mov di,Offset p8str_falsch
                                  call vergleiche_zeichenfolge_p8_grossklein
                                  je lies_dezimalzahl_boolean

                                  inc bx
                                  ;mov bx,1 ; wahr
                                  mov di,Offset p8str_true
                                  call vergleiche_zeichenfolge_p8_grossklein
                                  je lies_dezimalzahl_boolean

                                  ;mov bx,1 ; wahr
                                  mov di,Offset p8str_wahr
                                  call vergleiche_zeichenfolge_p8_grossklein
                                  jne nicht_lies_dezimalzahl_boolean

  lies_dezimalzahl_boolean:
                                  movzx cx,byte ptr es:[di]
                                  add si,cx
                                  jmp lies_dezimalzahl_ende_boolean

                                  ;***************
  nicht_lies_dezimalzahl_boolean:
                                  dec bx
                                  ; mov bx,0

  lies_dezimalzahl_schleife:
                                  null ax
                                  lodsb
                                  cmp al,'0'
                                  jb lies_dezimalzahl_ende
                                  cmp al,'9'
                                  ja lies_dezimalzahl_ende

                                  ; alte Zahl*10
                                  ; 10=2*5=2*(1+4)
                                  shl bx,1
                                  mov cx,bx
                                  shl cx,2
                                  add bx,cx

                                  sub al,'0'
                                  add bx,ax
                                  jmp lies_dezimalzahl_schleife

  lies_dezimalzahl_ende:
                                  dec si
  lies_dezimalzahl_ende_boolean:
                                  mov ax,bx
                                pop4 es,di,cx,bx
                                ret
a_endp                          lies_dezimalzahl

;***************************************************************************
p8str p8str_false               'false'
p8str p8str_falsch              'falsch'
p8str p8str_true                'true'
p8str p8str_wahr                'wahr'
;***************************************************************************
; AL->AL
a_proc                          grossbuchstabe
                                cmp al,'Ñ'
                                if_e <mov al,'é'>
                                cmp al,'î'
                                if_e <mov al,'ô'>
                                cmp al,'Å'
                                if_e <mov al,'ö'>
                                cmp al,'a'
                                jb exit_grossbuchstabe
                                cmp al,'z'
                                ja exit_grossbuchstabe
                                and al,0dfh ; 'a'->'A'
  exit_grossbuchstabe:
                                ret
a_endp                          grossbuchstabe
;***************************************************************************
; -> AH=von
;    AH=bis
a_proc                          berechene_halb_cursor
                                push ds
                                  push bios0040
                                  pop ds
                                  mov al,ds:[char_matrix_height] ; Zeichensatzhîhe
                                  mov ah,al
                                  shr ah,1
                                  dec al
                                pop ds
                                ret
a_endp                          berechene_halb_cursor
;***************************************************************************
; ds:si <-> es:di(p8)
; Ausgabe
;   zf=1 Gleichheit
a_proc                          vergleiche_zeichenfolge_p8_grossklein
                                pusha
                                  movzx cx,Byte Ptr es:[di]
                                  inc di
                                  jcxz vergleiche_zeichenfolge_p8_grossklein_ende
                                  cld
  vergleiche_zeichenfolge_p8_grossklein_schleife:
                                  lodsb
                                  call grossbuchstabe
                                  mov ah,al
                                  mov al,es:[di]
                                  inc di
                                  call grossbuchstabe
                                  cmp al,ah
                                  jne vergleiche_zeichenfolge_p8_grossklein_ende
                                  loop vergleiche_zeichenfolge_p8_grossklein_schleife
  vergleiche_zeichenfolge_p8_grossklein_ende:
                                popa
                                ret
a_endp                          vergleiche_zeichenfolge_p8_grossklein
;***************************************************************************

