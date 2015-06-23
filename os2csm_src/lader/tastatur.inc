Title   remap keyboard input

;***************************************************************************

; keypad ',' instead of '.': de,nl (not en,fr,it,sp,ru)
IFDEF language_de
SUPPORT_NUM_KOMMA       equ 1
ENDIF
IFDEF language_nl
SUPPORT_NUM_KOMMA       equ 1
ENDIF
IFNDEF DOS_KBD_DRIVER

;***************************************************************************

tastatur_installationszaehler   db 0

;***************************************************************************

a_proc                  tastatur_umbelegung_einhaengen
                        inc cs:[tastatur_installationszaehler]
                        cmp cs:[tastatur_installationszaehler],1
                        jne exit_tastatur_umbelegung_einhaengen

                        push2 ds,si

                          push 0
                          pop ds

                          mov si,015h*4
                          push dword ptr [si]
                          pop dword ptr cs:[org_int_15]

                          mov word ptr [si+0],Offset int_15_behandlung
                          mov word ptr [si+2],cs

                        pop2 si,ds
  exit_tastatur_umbelegung_einhaengen:
                        ret
a_endp                  tastatur_umbelegung_einhaengen

;***************************************************************************

a_proc                  tastatur_umbelegung_entfernen
                        dec cs:[tastatur_installationszaehler]
                        cmp cs:[tastatur_installationszaehler],0
                        jne exit_tastatur_umbelegung_entfernen

                        push ds
                          push 0
                          pop ds

                          push dword ptr cs:[org_int_15]
                          pop dword ptr ds:[015h*4+0]
                        pop ds
  exit_tastatur_umbelegung_entfernen:
                        ret
a_endp                  tastatur_umbelegung_entfernen

ENDIF ; -DOS_KBD_DRIVER

;***************************************************************************

tastaturtreiber_abgeschaltet    db false

;***************************************************************************

int_15_behandlung:
                        pushf
                          cmp ah,04fh
                          je int_15_4f

                          ; nicht zustÑndig..
                        popf
                        db 0eah ; jmp DWord Ptr cs:[org_int_15]..
org_int_15              dd ?

  int_15_4f:
                       ;popf
                       ;pushf
                          call DWord Ptr cs:[org_int_15]
                          jc int_15_4f_not_ignore

                        ; have to ignore key (CF=0)
                        retf 2                  ; pass carry
  int_15_4f_not_ignore:
                        pushf

IFDEF KBD_DIAG
                          push ax
                          push ds
                            push ax
                              mov al,' '
                              call kbd_ausschrift_zeichen

                            pop ax
                            call kbd_ausschrift_byte

                            mov al,' '
                            call kbd_ausschrift_zeichen

                            push bios0040
                            pop ds
                            mov al,ds:[keyboard_flag_byte0]
                            mov ah,ds:[keyboard_flag_byte2]
                            call kbd_ausschrift_word

                            mov al,13
                            call kbd_ausschrift_zeichen
                            mov al,10
                            call kbd_ausschrift_zeichen
                          pop ds
                          pop ax
ENDIF ; KBD_DIAG


                          ; 80+xx=release, and e0/e1 prefixes
                          test al,080h
                          jnz int_15_4f_nicht_ignorieren_aber_hier_unbehandelt

                          pusha
                            push ds

                              mov dl,al

                              push bios0040
                              pop ds
                              mov al,ds:[keyboard_flag_byte0]
                              mov ah,ds:[keyboard_flag_byte2]

                              push cs
                              pop ds

                              ; Treiber ein/ausschalten mit Strg+Alt+Leertaste(39)
                              mov si,Offset tastaturtreiber_abgeschaltet
                              mov dh,al
                              and dh,keyboard_status0_ctrl+keyboard_status0_alt
                              cmp dx,(keyboard_status0_ctrl+keyboard_status0_alt) shl 8 + 039h
                              jne nicht_tastatur_umschalten

                              xor byte ptr [si],true
  nicht_tastatur_umschalten:
                              cmp byte ptr [si],true
                              je tastennummer_nicht_gefunden

                              ; scancode 35 is mapped differntly on main area (-) and keypad(/)
                              ; soultion: do not remap any extended (E0-XX) key
                              ;
                              ; prefix E0 also indicates
                              ;   Insert/Home/Pageup
                              ;   Del   /End /Pagedown block
                              test ah,keyboard_status2_lastcode_e0
                              jnz tastennummer_nicht_gefunden

                              mov si,Offset keytable_remapscan
                              cld
                              push ax
  loop_exchange_scancode:
                                lodsw
                                test al,al
                                jz done_exchange_scancode
                                cmp dl,al
                                jne loop_exchange_scancode

                                mov dl,ah
  done_exchange_scancode:
                              pop ax

                              ; 5 Belegungen werden unterstÅtzt:
                              ;  * normal       (Kleinbuchstaben)
                              ;  * Umschalt     (Gro·buchstaben)
                              ;  * AltGR        (Sonderzeichen)
                              ;  * Alt          (nur fÅr Alt+A..Z)
                              ;  * Strg         (fÅr Strg+Y)

                              mov si,Offset keytable_Ctrl
                              test al,keyboard_status0_ctrl
                              jnz benutzte_tastatur_belegung

                              mov si,Offset keytable_AltGr
                              test ah,keyboard_status2_right_alt
                              jnz benutzte_tastatur_belegung

                              mov si,Offset keytable_Alt
                              test al,keyboard_status0_alt
                              jnz benutzte_tastatur_belegung

                              mov si,Offset keytable_Lower
                              test al,keyboard_status0_left_shift+keyboard_status0_right_shift+keyboard_status0_capslock
                              if_np <mov si,Offset keytable_Upper>

IFDEF SUPPORT_NUM_KOMMA
                              ; need extended keyboard for numeric pad
                              test ah,keyboard_status2_101_102_kbd
                              jz not_numeric_pad_komma

                              ; Numlock or shift needed
                              test al,keyboard_status0_left_shift+keyboard_status0_right_shift+keyboard_status0_capslock+keyboard_status0_numlock
                              jp not_numeric_pad_komma

                              ; Numeric Del/,/.
                              cmp dl,053h
                              jne not_numeric_pad_komma

                             ;mov si,Offset keytable_Num_komma
                              mov ax,(053h shl 8)+','
                              jmp insert_scancode_ascii_into_buffer
  not_numeric_pad_komma:

ENDIF ; SUPPORT_NUM_KOMMA

                              ;--------------------------------------

IFDEF BLOCK_KEY_TABLE ; uses more complicated tables, but fails to save data and code
  benutzte_tastatur_belegung:
                              sub bx,bx
  suche_tastennummer_schleife:
                              add si,bx

                              ; keyboard table:
                              ; byte 0: first scan code
                              ; byte 1: number of keys
                              ; byte 2..(number of keys+2-1): ascii code(s)
                              mov ah,Byte Ptr [si]
                              inc si
                              test ah,ah ; Ende der Tabelle?
                              jz tastennummer_nicht_gefunden

                              ; bx:=number of keys
                              mov bl,Byte Ptr [si]
                              inc si

                              ; key(dl)-first_key(ah)<0 -> skip block
                              mov al,dl
                              sub al,ah
                              js suche_tastennummer_schleife
                              ; key-first_key<size of of block?
                              cmp al,bl
                              jnb suche_tastennummer_schleife

                              ; found correct block, load char code from index al
                              mov ah,0
                              add si,ax
                              mov al,[si]       ; ascii
                              mov ah,dl         ; scan code
ELSE ; BLOCK_KEY_TABLE
  benutzte_tastatur_belegung:
                             ;cld
  suche_tastennummer_schleife:
                              lodsw
                              test al,al        ; Ende der Tabelle?
                              jz tastennummer_nicht_gefunden
                              cmp al,dl
                              jne suche_tastennummer_schleife
IFDEF KBD_DIAG
                              push ax
                                mov al,'<'
                                call kbd_ausschrift_zeichen
                                mov al,'P'
                                call kbd_ausschrift_zeichen
                                mov al,':'
                                call kbd_ausschrift_zeichen
                              pop ax
                              call kbd_ausschrift_word
                              push ax
                                mov al,'/'
                                call kbd_ausschrift_zeichen
                                mov al,'S'
                                call kbd_ausschrift_zeichen
                                mov al,'I'
                                call kbd_ausschrift_zeichen
                                mov al,'='
                                call kbd_ausschrift_zeichen
                                mov ax,si
                                call kbd_ausschrift_word
                                mov al,'>'
                                call kbd_ausschrift_zeichen
                              pop ax
ENDIF ; KBD_DIAG

                              mov al,ah         ; ascii
                              mov ah,dl         ; scan code
ENDIF ; -BLOCK_KEY_TABLE


  insert_scancode_ascii_into_buffer:
                              push bios0040
                              pop ds

                              mov si,word ptr ds:[keyboardbuffer_tail]  ; Schreibposition
                              lea bx,[si+2]
                              cmp bx,word ptr ds:[keyboardbuffer_end]   ; Ende erreicht ?
                              if_ae <mov bx,word ptr ds:[keyboardbuffer_start]> ; vom Anfang
                              cmp bx,word ptr ds:[keyboardbuffer_head]         ; öberlauf ?
                              je no_room_in_keyboard_buffer

                              mov [si],ax                               ; Taste ablegen
                              mov word ptr ds:[keyboardbuffer_tail],bx  ; Schreibposition merken
  no_room_in_keyboard_buffer:

                            pop ds
                          popa
                        popf
                        clc     ; CF=0 - Taste soll vom BIOS ignoriert werden
                        retf 2

  tastennummer_nicht_gefunden:
                            pop ds
                          popa

  int_15_4f_nicht_ignorieren_aber_hier_unbehandelt:
                        popf    ; CF=1 - soll weiterbehandelt werden
                        retf 2

;***************************************************************************

;***************************************************************************

IFDEF KBD_DIAG

a_proc                  kbd_ausschrift_word
                        rol ax,8
                        call kbd_ausschrift_byte
                        rol ax,8
                       ;jmp  kbd_ausschrift_byte
a_endp                  kbd_ausschrift_word

;***************************************************************************

a_proc                  kbd_ausschrift_byte
                        rol al,4
                        call kbd_ausschrift_halbbyte
                        rol al,4
                       ;jmp  kbd_ausschrift_halbbyte
a_endp                  kbd_ausschrift_byte

;***************************************************************************

a_proc                  kbd_ausschrift_halbbyte
                        push ax
                          and al,00fh
                          cmp al,10
                          sbb al,69h
                          das
                          call kbd_ausschrift_zeichen
                        pop ax
                        ret
a_endp                  kbd_ausschrift_halbbyte

;***************************************************************************

a_proc                  kbd_ausschrift_zeichen
                        pusha
                          mov ah,00eh
                          mov bx,00007h
                          int 010h
                        popa
                        ret
a_endp                  kbd_ausschrift_zeichen

ENDIF ; KBD_DIAG

;***************************************************************************

;keytable_Alt            db 0

                        ifdef language_de
                        include ..\..\os2csm\lader\tast_de.inc
                        endif

                        ifdef language_en
                        include ..\..\os2csm\lader\tast_en.inc
                        endif

                        ifdef language_es
                        include ..\..\os2csm\lader\tast_es.inc
                        endif

                        ifdef language_fr
                        include ..\..\os2csm\lader\tast_fr.inc
                        endif

                        ifdef language_it
                        include ..\..\os2csm\lader\tast_it.inc
                        endif

                        ifdef language_jp
                        include ..\..\os2csm\lader\tast_jp.inc
                        endif

                        ifdef language_nl
                        include ..\..\os2csm\lader\tast_nl.inc
                        endif

                        ifdef language_ru
                        include ..\..\os2csm\lader\tast_ru.inc
                        endif

;IFDEF SUPPORT_NUM_KOMMA
;keytable_Num_komma:
;                        db 0    ; keep scan code
;
;                        db 053h ; scan code
;                        db 1    ; one key
;                        db ','  ; the komma..
;
;                        db 0    ; end of table
;
;ENDIF ; SUPPORT_NUM_KOMMA

;***************************************************************************
