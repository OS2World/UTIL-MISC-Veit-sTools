Title   APM and ACPI presence checker

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

p8str           name_os2csm_apm  'OS2CSM_APM'
p8str           name_os2csm_acpi 'OS2CSM_ACPI'

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          detect_apm
                pushad

                  ; connect real mode (allowd to fail if already connected)
                  mov ax,05301h
                  sub bx,bx
                  int 015h

                  ; disconnect - important to disconnect in fastboot situations so
                  ; the protected mode connect will give an entry point and not
                  ; an error 'already connected'
                  mov ax,05304h
                  sub bx,bx
                  int 015h

                  ; ask for version, look for >=1.0
                  ; could also for <=1.2..
                  mov ax,05300h
                  sub bx,bx
                  int 015h
                  if_c <sub ax,ax>
                  cmp ax,00100h
                  setae al
                  mov ah,0

                  mov si,Offset zeichenketten_zwischenspeicher
                  call Int2Str

                  ; si=string
                  ; bx=variable name
                  mov bx,Offset name_os2csm_apm
                  call store_string_to_anything_varname

                popad
                ret
a_endp          detect_apm

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          detect_acpi
                push gs
                pushad

                  ; search last KB of <640 KiB
                  push bios0040
                  pop gs
                  movzx eax,Word Ptr gs:[number_of_KB] ; 40:13
                  shl eax,10
                  mov ecx,640*1024
                  sub ecx,eax
                  jbe @@not_below_640

                  call search_apci
                  jnc @@found
  @@not_below_640:

                  movzx eax,Word Ptr gs:[Extended_BIOS_Data_Area] ; 40:0e
                  shl eax,4
                  mov ecx,1*1024
                  test eax,eax
                  jz @@no_ebda

                  call search_apci
                  jnc @@found
  @@no_ebda:
                  mov eax,0e0000h
                  mov ecx,01ffe0h
                  call search_apci
  @@found:
                  ; CF=1:not found
                  mov ax,1
                  sbb ax,0
                  mov si,Offset zeichenketten_zwischenspeicher
                  call Int2Str

                  ; si=string
                  ; bx=variable name
                  mov bx,Offset name_os2csm_acpi
                  call store_string_to_anything_varname

                popad
                pop gs
                ret
a_endp          detect_acpi

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

ACPI_Root_System_Description_Pointer_structure  Struc
  signature_RSD_PTR     db 8 dup (?)
  checksum              db ?
  OEM_identifier        db 6 dup (?)
  reserved              db ?
  physical_address_of_Root_System_Description_Table dd ?
ACPI_Root_System_Description_Pointer_structure  EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; eax=physical address
; ecx=length
; -> CF=1:not found
a_proc          search_apci
                push ds
                pushad

                  mov bl,false

                  mov edx,ecx
                  mov si,ax
                  and si,0fh
                  shr eax,4
                  mov ds,ax

  @@search_loop:
                  mov ecx,edx
                  cmp ecx,08000h
                  if_a <mov ecx,08000h>

                  push ecx

                    shr ecx,4
  @@search_loop_2:
                    ; 'RSD PTR ' signature
                    cmp DWord Ptr ds:[si+0].signature_RSD_PTR,' DSR'
                    jne @@not_found
                    cmp DWord Ptr ds:[si+4].signature_RSD_PTR,' RTP'
                    jne @@not_found
                    ; non-nil pointer
                    cmp [si].physical_address_of_Root_System_Description_Table,0
                    je  @@not_found

                    ; checksum ok
                    pusha
                      mov cx,Size ACPI_Root_System_Description_Pointer_structure
                      cld
                      mov ah,0
  @@checksum:
                      lodsb
                      add ah,al
                      loop @@checksum

                      cmp ah,0
                    popa
                    jne @@not_found

                    mov bl,true
  @@not_found:
                    add si,010h
                    loop @@search_loop_2

                  pop ecx
                  ; + 32K address
                  mov ax,ds
                  add ax,00800h
                  mov ds,ax
                  sub si,cx
                  sub edx,ecx
                  jnz @@search_loop

                  cmp bl,true ; -> CF=1 for false

                popad
                pop ds
                ret
a_endp          search_apci

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

