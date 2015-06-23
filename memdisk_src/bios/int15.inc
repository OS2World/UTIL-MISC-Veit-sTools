Title           change result of Int $15 memory functions

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
wert_15_88              dw ?
wert_15_8a              dd ?
wert_15_c7              dd ?
wert_15_e801_ax         dw ?
wert_15_e801_bx         dw ?
wert_15_e881_ebx        dd ?

fastboot_request        db false

no_abios                db true
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
int15handler:

COMMENT $

cmp ah,04fh
je int15handler_sk1

push ax
  mov al,'I'
  call ausschrift_zeichen
  mov al,015h
  call ausschrift_al_hex
  mov al,' '
  call ausschrift_zeichen
  mov al,'A'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
pop ax
call ausschrift_ax_hex
push ax
  mov al,' '
  call ausschrift_zeichen
  mov al,'D'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
  mov ax,dx
  call ausschrift_ax_hex

  mov al,' '
  call ausschrift_zeichen
  mov al,'E'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
  mov ax,es
  call ausschrift_ax_hex

  mov al,' '
  call ausschrift_zeichen
  mov al,'B'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
  mov ax,bx
  call ausschrift_ax_hex

  mov al,' '
  call ausschrift_zeichen
  mov al,'S'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
  mov ax,ss
  call ausschrift_ax_hex

  call ausschrift_zeichen_CRLF
pop ax
int15handler_sk1:

END COMMENT $


                ;-------------------------------
                ; install test: Int 15,AH=FF ebx='MEM_' ecx='DISK'
                cmp ah,0ffh
                jne nicht_memdisk_test
                cmp ebx,'MEM_'
                jne nicht_memdisk_test
                cmp ecx,'DISK'
                jne nicht_memdisk_test

                cmp al,0
                jne nicht_memdisk_test0

                mov ax,cs
                jmp int15_iret_clc
  nicht_memdisk_test0:
                ; cmp al,1
                ; jne nicht_memdisk_test1
                ;
                ; call uninstall
  nicht_memdisk_test1:
                ; ...
  nicht_memdisk_test:
                ;-------------------------------

                ;-------------------------------
                ; SVISTA does not enable A20 during extended memory copy,
                ; causing garbage/zeroes to be copied...
                cmp ah,087h
                jne nicht_87_copy_extened_memory

                ; force A20 on
                call enable_a20

                ; and continue. On return the A20 should be disabled, but this
                ; not a big problem here.

  nicht_87_copy_extened_memory:
                ;-------------------------------

                ;-------------------------------
                ; some 'cheap' machine bios answer wrong for ABIOS
                cmp ah,004h
                jne nicht_abios_test

                cmp cs:no_abios,true
                je int15_iret_stc               ; ah=86, cf=1

  nicht_abios_test:
                ;-------------------------------

                ;-------------------------------
                ; A20 support
                cmp ah,024h                     ; ax=2400..2403
                jne nicht_a20_functionen

                cmp cs:[a20_access],a20_access_private ; do we know better?
                jne nicht_a20_functionen

                ; 2400=disable, 2401=enable
                cmp al,1
                ja nicht_int15_2400_2401

                push dx
                  mov dl,al
                  call set_a20
                pop dx
                mov ah,0
                jmp int15_iret_clc

  nicht_int15_2400_2401:

                ; 2402=get status
                cmp al,2
                jne nicht_int15_2402

                push dx
                call query_a20
                mov ah,0
                mov al,dl
                sub cx,cx
                pop dx
                jmp int15_iret_clc

  nicht_int15_2402:
                cmp al,3
                jne nicht_int15_2403

                ; 2403=query support
                mov ah,0
                in al,092h
                cmp al,0ffh
                setne bl
                ; bit 1: port 92 supported (0/1)
                shl bl,1
                ; bit 0: keyboard controller supported (assume always)
                or  bl,1
                mov bh,0
                jmp int15_iret_clc

  nicht_int15_2403:
  nicht_a20_functionen:
                ;-------------------------------


IFDEF fastboot_function
                ;-------------------------------
                ; 4F=Keyboard Hook 53=Del
                cmp ah,04fh
                jne nicht_StrgAltEntf

                cmp al,053h
                je vielleicht_StrgAltEntf
                cmp al,053h+080h
                jne nicht_StrgAltEntf
  vielleicht_StrgAltEntf:
                push ax
                push ds
                  push bios0040
                  pop ds
                  mov al,byte ptr ds:[keyboard_flag_byte0]
                  and al,00fh ; Ctrl+Alt+Left+Right shift
                  cmp al,00ch ; Ctrl+Alt only ?
                pop ds
                pop ax
                jne nicht_StrgAltEntf

                test al,al
                js cad_release

                mov al,1 ; ESC
                mov cs:[fastboot_request],true
                clc                                     ; ignore key
                jmp iret_pass_carry
  cad_release:
                ; TinyBIOS (SVISTA) does not call INT 15/AX=9102 "OS hook: keyboard complete"
                ; so we do a bit dirty work: end keyboard interrupt, jump to fastboot code

                cli

                mov al,020h ; eoi
                out 020h,al ; for IRQ 0 -> PIC0

                ; enable keyboard
                sub cx,cx
  wait_kbd_ctrl:
                in al,064h
                test al,2
                loopne wait_kbd_ctrl

                mov al,0aeh     ; enable
                out 064h,al

               ;sti

                jmp do_fastboot

  nicht_StrgAltEntf:
                ;-------------------------------
                ; OS hook: keyboard complete
                cmp ax,09102h
                jne nicht_9102

                cmp cs:[fastboot_request],true
                je do_fastboot

  nicht_9102:

ENDIF ; fastboot_function

                ;-------------------------------
                ; 286
                cmp ah,088h
                jne nicht_int15_88

                ; AX in KB
                mov ax,cs:[wert_15_88]
                jmp int15_iret_clc
                ;-------------------------------
  nicht_int15_88:

                ; AMI-BIOS
                cmp ah,08ah
                jne nicht_int15_158a

                ; DX:AX in KB
                mov dx,word ptr cs:[wert_15_8a+2]
                mov ax,word ptr cs:[wert_15_8a+0]
                jmp int15_iret_clc
                ;-------------------------------
  nicht_int15_158a:

                ; PS/2
                cmp ah,0c7h
                jne nicht_int15_c7

                ; -> DS:SI...
                pushf
                call dword ptr cs:[orgint15]
                jc int15_iret

                push cs:[wert_15_c7]
                pop dword ptr ds:[si].ps2_local_16M
                push cs:[wert_15_c7]
                pop dword ptr ds:[si].ps2_system_16M

                jmp int15_iret_clc
                ;-------------------------------
  nicht_int15_c7:

                ; AMI PCI CL:BX in KB
                cmp ax,0da88h
                jne nicht_int15_da88

                push eax
                  mov eax,cs:[wert_15_8a]
                  mov bx,ax
                  shr eax,16
                  mov cl,al
                pop eax
                null ax
                jmp int15_iret_clc
                ;-------------------------------
  nicht_int15_da88:

                ; Phoenix 4.0
                cmp ax,0e801h
                jne nicht_int15_e801

                ; ax/cx
                ; bx/dx
                mov ax,cs:[wert_15_e801_ax]
                mov bx,cs:[wert_15_e801_bx]
                null cx
                null dx
                jmp int15_iret_clc
                ;-------------------------------
  nicht_int15_e801:

                ; Phoenix 4.0,....
                cmp eax,0000E820h
                jne nicht_int15_e820

                cmp edx,'SMAP'
                jne int15_iret_stc
                cmp ecx,20
                jne int15_iret_stc

                ; -> ES:DI
                pushf
                call dword ptr cs:[orgint15]
                jc int15_iret

                push edx
                push eax

                  cmp es:[di].smap.memtype,smap_memtype_memory
                  jne keine_aenderung_e820

                  mov eax,es:[di].smap.base_lo
                  mov edx,es:[di].smap.base_hi

                  cmp edx,0
                  jne keine_aenderung_e820

                  ; 0..640 KB ?
                  cmp eax,0
                  jne vielleicht_patch_SMAP_ext

                  ; 640 KB -> 639 KB
                  int 012h
                  movzx eax,ax
                  shl eax,10                    ; KB->Byte
                  mov es:[di].smap.length_lo,eax
                  mov es:[di].smap.length_hi,0
                  jmp keine_aenderung_e820

  vielleicht_patch_SMAP_ext:
                  ; extended memory ?
                  cmp eax,cs:MemDiskBIOS_Info._phys_addr        ; Anfang<=Memdisk ?
                  ja keine_aenderung_e820       ; nein.

                  add eax,es:[di].smap.length_lo ; Ende>Memdisk ?
                  adc edx,es:[di].smap.length_hi
                  test edx,edx
                  jnz patch_SMAP_ext            ; ja.
                  cmp eax,cs:MemDiskBIOS_Info._phys_addr
                  jb keine_aenderung_e820       ; nein.

  patch_SMAP_ext:
                  ; 128 MB -> 121 MB
                  null edx
                  mov eax,cs:MemDiskBIOS_Info._phys_addr
                  sub eax,es:[di].smap.base_lo
                  sbb edx,es:[di].smap.base_hi

                  mov es:[di].smap.length_lo,eax
                  mov es:[di].smap.length_hi,edx

  keine_aenderung_e820:
                pop eax
                pop edx
                jmp int15_iret_clc
                ;-------------------------------
  nicht_int15_e820:

                ; Phoenix 4.0, 32-bit
                cmp ax,0e881h
                jne nicht_int15_e881

                ; eax/ecx
                ; ebx/edx
                movzx eax,cs:[wert_15_e801_ax]
                mov ebx,cs:[wert_15_e881_ebx]
                null ecx
                null edx
                jmp int15_iret_clc
                ;-------------------------------
  nicht_int15_e881:

                ; alles andere ..
                db 0eah ; jmp d cs:[orgint15]
orgint15:       dd 0
                db 015h

  int15_iret_stc:
                mov ah,086h
                stc
                jmp iret_pass_carry

  int15_iret_clc:
                clc
  int15_iret:
                jmp iret_pass_carry

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

