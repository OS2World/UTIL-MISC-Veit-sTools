Title           output strings and numbers

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; try to save&restore registers around int $10
a_proc          int_10h
                push fs
                push ebp
                  int 010h
                pop ebp
                pop fs
                ret
a_endp          int_10h

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;graph equ 1

a_proc          ausschrift_eax
                pushad
                  mov di,Offset str_puffer
                  mov ebx,10
  @@div10_schleife_cl3:
                  mov cx,3
  @@div10_schleife:
                  sub edx,edx
                  div ebx
                  add dl,'0'
                  mov cs:[di],dl
                  inc di
                  test eax,eax
                  jz @@div10_ende

                  loop @@div10_schleife

                  mov byte ptr cs:[di],thousand_separator
                  inc di
                  jmp @@div10_schleife_cl3

  @@div10_ende:


  @@ausgabe_schleife:
                  dec di
                  mov al,cs:[di]
                  call ausschrift_zeichen
                  cmp di,Offset str_puffer
                  jne @@ausgabe_schleife

                popad
                ret
a_endp          ausschrift_eax

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IFNDEF cdloader

a_proc          ausschrift_eax_hex
                rol eax,16
                call ausschrift_ax_hex
                rol eax,16
               ;call ausschrift_ax_hex
               ;ret
a_endp          ausschrift_eax_hex

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          ausschrift_ax_hex
                xchg al,ah                      ; rol ax,8
                call ausschrift_al_hex
                xchg al,ah                      ; rol ax,8
               ;call ausschrift_al_hex
               ;ret
a_endp          ausschrift_ax_hex
ENDIF ; -cdloader
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                ; al
a_proc          ausschrift_al_hex
                pushf
                  rol al,4
                  call ausschrift_halbbyte
                  rol al,4
                  call ausschrift_halbbyte
                popf
                ret
a_endp          ausschrift_al_hex

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          ausschrift_halbbyte
                pushf
                push ax
                  call al_hex
                  call ausschrift_zeichen
                pop ax
                popf
                ret
a_endp          ausschrift_halbbyte

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                ; Int2Hex(al and $0f,1)
a_proc          al_hex
                and al,00fh
                                    ; Norbert Juffa:
                cmp al,10           ; if x < 10, set CF = 1
                sbb al,69h          ; 0-9: 96h .. 9Fh,  A-F: A1h..A6h
                das                 ; 0-9: subtr. 66h -> 30h..39h,
                                    ; A-F: subtr. 60h -> 41h..46h
                ret
a_endp          al_hex

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

TextAttr        db default_TextAttr

                ; AL
a_proc          ausschrift_zeichen

IFDEF serial_debug
                call output_com2
ENDIF


  ausschrift_zeichen_ohne_com2:

                push ds
                pusha

IFNDEF nodebugstep
                  test cs:[debugoption],debugoption_STEP
                  jz @@skip_push_b800_762
                  call setup_debugstep_ds_si
                  push dword ptr ds:[si+0]
                  push dword ptr ds:[si+4]
  @@skip_push_b800_762:
ENDIF

                  push bios0040
                  pop ds


                  cmp al,7
                  jne @@nicht_ausschrift_zeichen_7

                  ; use "teletype" function
                  mov ah,00eh
                  mov bx,0                      ; page 0,dummy colour
                  call int_10h
                  jmp @@exit_ausschrift_zeichen

  @@nicht_ausschrift_zeichen_7:
                  cmp al,8
                  jne @@nicht_ausschrift_zeichen_8

                  ; set cursor position
                  mov dx,word ptr ds:[current_cursor]
                  dec dx ; dec dl               ; go one position left
                 ;cmp dl,0
                  if_ae <call GotoXY>           ; but no effect for start of line
                  jmp @@exit_ausschrift_zeichen

  @@nicht_ausschrift_zeichen_8:
                  cmp al,9
                  jne @@nicht_ausschrift_zeichen_9

                  ; convert tabs to multiple ' ' (up to 8)
    @@loop_tab8:
                  mov al,' '
                  call ausschrift_zeichen_ohne_com2
                  test byte ptr ds:[current_column],7
                  jnz @@loop_tab8
                  jmp @@exit_ausschrift_zeichen

  @@nicht_ausschrift_zeichen_9:

                  cmp al,10
                  jne @@nicht_ausschrift_zeichen_10

  @@ist_ausschrift_zeichen_10:

                  mov dx,word ptr ds:[current_cursor]
                  inc dh
                  cmp dh,byte ptr ds:[number_of_lines_less1]
                  ja @@must_scroll

                  ; set cursor to same culumn,next line
                 ;mov dx,dx
                  call GotoXY
                  jmp @@exit_ausschrift_zeichen


  @@must_scroll:
                  mov ax,00601h                 ; scroll up one line
                  mov bh,byte ptr cs:[TextAttr] ; fill colour
IFDEF graph
                  shr bh,4                      ; background only
ENDIF
                  sub cx,cx                     ; upper left=(1,1)
                  mov dl,byte ptr ds:[number_of_columns]
                  dec dx                        ; lower right(25,80)
                  mov dh,byte ptr ds:[number_of_lines_less1]
                  call int_10h
                  ; cursor is already correct
                  jmp @@exit_ausschrift_zeichen

  @@nicht_ausschrift_zeichen_10:
                  cmp al,13
                  jne @@nicht_ausschrift_zeichen_13

                  ; set cursor to start of line
                  mov dh,byte ptr ds:[current_row]
                  mov dl,0                      ; column 0
                  call GotoXY
                  jmp @@exit_ausschrift_zeichen

  @@nicht_ausschrift_zeichen_13:

                  ; assume printable for all other chars
                  call write_colour_char


                  ; move cursor....
                  mov dx,word ptr ds:[current_cursor]
                  inc dx                        ; inc dl (column)
                  mov al,byte ptr ds:[number_of_columns]
                  dec ax
                  cmp dl,al
                  jbe @@nolinewrap

                  ; linewrap: set next line, first column
                  inc dh
                  mov dl,0

  @@nolinewrap:
                  ; beyond last line ?
                  cmp dh,byte ptr ds:[number_of_lines_less1]
                  ja @@must_do_linemove

                  ; no, set cursor
                 ;mov dx,dx
                  call GotoXY
                  jmp @@exit_ausschrift_zeichen

  @@must_do_linemove:
                  ; set cursor to begin of last line ...
                  mov dh,byte ptr ds:[number_of_lines_less1]
                  mov dl,0
                  call GotoXY

                  ; ... and cause a newline command
                  mov al,10
                  jmp @@ist_ausschrift_zeichen_10


  @@exit_ausschrift_zeichen:

IFNDEF nodebugstep
                  test cs:[debugoption],debugoption_STEP
                  jz @@skip_pop_b800_762
                  call setup_debugstep_ds_si
                  pop dword ptr ds:[si+4]
                  pop dword ptr ds:[si+0]
  @@skip_pop_b800_762:
ENDIF


                popa
                pop ds
                ret
a_endp          ausschrift_zeichen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; al
a_proc          write_colour_char
                pusha
                  mov ah,009h                   ; color output without cursor move
                  mov bl,byte ptr cs:[TextAttr] ; attr/foreground colour
                  mov bh,0                      ; display page 0
                  mov cx,1                      ; only one char
IFDEF graph
                  ; clear char matrix with background
                  pusha
                    shr bl,4                    ; bl:=background
                    mov al,'Û'
                    call int_10h
                  popa

                  ; xor-paint char
                  mov bh,bl
                  and bl,000fh                  ; foreground only
                  shr bh,4                      ; background
                  xor bl,bh                     ; xor colour value
                  or bl,080h                    ; set xor bit
                  mov bh,0                      ; display page 0
ENDIF

                  call int_10h

                popa
                ret
a_endp          write_colour_char

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IFNDEF nodebugstep

a_proc          setup_debugstep_ds_si
                push ax
                ;-push 0b800h ; vga text memory
                ;-pop ds
                  push bios0040
                  pop ds
                  mov al,Byte Ptr ds:[current_video_mode]
                  and al,07fh
                  cmp al,007h
                  setne al
                  shl ax,11                     ; 0000/0800
                  add ax,biosb000               ; b000/b800
                  mov ds,ax
                  mov si,76*2
                pop ax
                ret
a_endp          setup_debugstep_ds_si

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          ausschrift_STEP
                pushf
                pusha
                push ds

                  test cs:[debugoption],debugoption_STEP
                  jz @@exit

                  call setup_debugstep_ds_si

                  mov ah,step_TextAttr
                  mov bp,sp
                  mov cx,4
  @@loop_4:
                  dec bp
                  mov al,[bp+2+2*8+2+2+4] ; ds+pusha+flags+return+DWORD
                  mov [si],ax
                  inc si
                  inc si
                  loop @@loop_4

  @@exit:

                pop ds
                popa
                popf
                ret 4
a_endp          ausschrift_STEP

ENDIF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; CS:SI
a_proc          ausschrift
                push ds
                  push cs
                  pop ds
                  call ausschrift_ds_si
                pop ds
                ret
a_endp          ausschrift

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; ds:si
a_proc          ausschrift_ds_si
                pusha

  @@ausschrift_schleife:
                  cld
                  lodsb
                  cmp al,string_end
                  je @@ausschrift_ende

                  cmp al,muliple
                  jne @@not_muliple

                  ausschrift_mehrfach:
                  lodsb
                  movzx cx,al
                  lodsb
    @@ausschrift_mehrfach_sl:
                  call ausschrift_zeichen
                  loop @@ausschrift_mehrfach_sl
                  jmp @@ausschrift_schleife

                  ;*****************************
  @@not_muliple:
                  cmp al,colour
                  jne @@not_colour

                  lodsb
                  mov byte ptr cs:[TextAttr],al
                  jmp @@ausschrift_schleife

                  ;*****************************
  @@not_colour:
                  cmp al,cls
                  jne @@not_cls

                  pusha

IFDEF graph
                    mov ax,00012h
                    call int_10h
ENDIF

                    mov ax,00600h         ; blank entire window
                    mov bh,byte ptr cs:[TextAttr]
IFDEF graph
                    shr bh,4
ENDIF
                    sub cx,cx             ; links oben
                   ;mov dx,79+24*0100h    ; rechts unten (80*25)
                    push ds
                      push bios0040
                      pop ds
                      mov dl,byte ptr ds:[number_of_columns]
                      dec dx
                      mov dh,byte ptr ds:[number_of_lines_less1]
                    pop ds
                    call int_10h

IFDEF serial_debug
                    mov bp,Offset output_com2
                    mov al,27
                    call bp
                    mov al,'['
                    call bp
                    mov al,'2'
                    call bp
                    mov al,'J'
                    call bp
ENDIF ; serial_debug

                    sub dx,dx                   ; GotoXY(1,1)
                    call GotoXY

                    ; high intensity
                    mov ax,01003h
                    mov bl,0                    ; blink off
                    call int_10h

                  popa
                  jmp @@ausschrift_schleife
                  ;*****************************
  @@not_cls:
                  cmp al,goto_xy
                  jne @@not_gotoxy

                  lodsw ; x/y
                  mov dx,ax
                  sub dx,00101h
                  call GotoXY
                  jmp @@ausschrift_schleife
                  ;*****************************
  @@not_gotoxy:
                  cmp al,keypress
                  jne @@not_keypress

                  call tastendruck
                  jmp @@ausschrift_schleife
                  ;*****************************
  @@not_keypress:
                  cmp al,string_ClrEol
                  jne @@not_string_ClrEol

                  call ClrEol
                  jmp @@ausschrift_schleife
                  ;*****************************

  @@not_string_ClrEol:
IFNDEF cdloader
                  cmp al,string_numlongint
                  jne @@not_string_numlongint

                  lodsw
                  pushad
                    mov si,ax
                    mov eax,ds:[si]
                    call ausschrift_eax
                  popad
                  jmp @@ausschrift_schleife
                  ;*****************************

  @@not_string_numlongint:
                  cmp al,string_string
                  jne @@not_string_string

                  lodsw
                  push si
                    mov si,ax
                    call ausschrift_ds_si
                  pop si
                  jmp @@ausschrift_schleife
                  ;*****************************

  @@not_string_string:
ENDIF ; -cdloader
                  call ausschrift_zeichen
                  jmp @@ausschrift_schleife

  @@ausschrift_ende:

                popa
                ret
a_endp          ausschrift_ds_si

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          fehler_ausschrift
                push ax
                  mov al,error_TextAttr
                  xchg cs:[TextAttr],al
                  call ausschrift
                  mov cs:[TextAttr],al
                pop ax
                ret
a_endp          fehler_ausschrift

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          trap_proc
                pop si
                call fehler_ausschrift
  @@endlos:
                IFNDEF nodebug
                db 0cch ; i n t 3
                ENDIF
                call tastendruck
                jmp @@endlos
a_endp          trap_proc


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          ausschrift_zeichen_CRLF
                push ax
                  mov al,13
                  call ausschrift_zeichen
                  mov al,10
                  call ausschrift_zeichen
                pop ax
                ret
a_endp          ausschrift_zeichen_CRLF

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          ClrEol
                push ds
                pusha

IFDEF serial_debug
                  call ClrEol_com2
ENDIF ; serial_debug

                  ; do it on the VGA using multi-char output
                 ;mov ah,009h                   ; color output without cursor move
                 ;mov al,' '
                  mov ax,00920h
                  mov bl,byte ptr cs:[TextAttr] ; attr/foreground colour
                  mov bh,0                      ; display page 0
                  push bios0040
                  pop ds
                  mov cx,Word Ptr ds:[number_of_columns]
                  sub cl,Byte Ptr ds:[current_column]
IFDEF graph
                  ; clear char matrix with background
                  pusha
                    shr bl,4                    ; bl:=background
                    mov al,'Û'
                    call int_10h
                  popa

                  ; xor-paint char
                  mov bh,bl
                  and bl,000fh                  ; foreground only
                  shr bh,4                      ; background
                  xor bl,bh                     ; xor colour value
                  or bl,080h                    ; set xor bit
                  mov bh,0                      ; display page 0
ENDIF

                  call int_10h


                popa
                pop ds
                ret
a_endp          ClrEol

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
IFNDEF cdloader
                ; cx=count
                ; dx=y/x
                ; es:bp=string
a_proc          WriteColourString
                pusha
                  jcxz @@exit

IFDEF serial_debug
                  call WriteColourString_com2
ENDIF ; serial_debug

                  ; this functions wraps at line end (even without cursor..)
                  ; -> extra processing of last char
                  mov ax,01302h         ; chars+attributes, cursor not moved
                  mov bh,0              ; page 0
                  dec cx
                  if_nz <call int_10h>

                  add dx,cx
                  add bp,cx
                  add bp,cx
                  call GotoXY_crt

                  mov ax,es:[bp]
                  xchg TextAttr,ah
                  call write_colour_char
                  xchg TextAttr,ah

  @@exit:

                popa
                ret
a_endp          WriteColourString

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; -> ah/al=24/79
a_proc          WindMax
                push ds
                  push bios0040
                  pop ds
                  mov al,Byte Ptr ds:[number_of_columns]
                  mov ah,Byte Ptr ds:[number_of_lines_less1]
                  dec al
                pop ds
                ret
a_endp          WindMax

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                ; -> ah/al=0/0 .. 24/79
a_proc          WhereXY
                push ds
                  push bios0040
                  pop ds
                  mov ax,Word Ptr ds:[current_cursor]
                pop ds
                ret
a_endp          WhereXY
ENDIF ; -cdloader
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; dx
a_proc          GotoXY
IFDEF serial_debug
                call GotoXY_com2
ENDIF ; serial_debug
            ;-- call GotoXY_crt
            ;-- ret
            ;   fall thrugh to GotoXY_crt >
a_endp          GotoXY


a_proc          GotoXY_crt
                pusha

                  mov ah,002h
                  mov bh,0
                 ;mov dx,dx
                  call int_10h

                popa
                ret
a_endp          GotoXY_crt

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                ; „ndert ax
a_proc          tastendruck

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

                cmp al,0e0h
                if_e <mov al,0>
                ret
a_endp          tastendruck
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
IFNDEF cdloader
                ; „ndert ax
a_proc          keyboard_status
                mov ah,012h
                int 016h
                ret
a_endp          keyboard_status
ENDIF ; -cdloader
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;                ; „ndert ax
;a_proc          tastendruck_upcase
;                call tastendruck
;               ;jmp upcase
;a_endp          tastendruck_upcase
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                ; al->al
a_proc          upcase
                cmp al,'a'
                jb @@exit
                cmp al,'z'
                ja @@exit
                add al,'A'-'a'
  @@exit:
                ret
a_endp          upcase
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; „ndert ax
a_proc          tastendruck_lowercase
                call tastendruck
               ;jmp lowercase
a_endp          tastendruck_lowercase
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                ; al->al
a_proc          lowercase
                cmp al,'A'
                jb @@exit
                cmp al,'Z'
                ja @@exit
                add al,'a'-'A'
  @@exit:
                ret
a_endp          lowercase

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

