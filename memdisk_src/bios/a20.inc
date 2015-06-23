Title           A20 address switch/extended memory copy

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; INT 15/87 extended memory copy service modifies (enables later
; disables) A20 gate. OS/2 Kernel will not expect that the boot disk
; service does this and fail. There is a optional BIOS service for
; A20 status. If this does not work we prefer to use port 92
; before falling back to keyboard controller mode.

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a20_access      db ?

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; -> dl=0:disabled
                ;    dl=1:enabled
a_proc          query_a20
                pushf
                push ax
                push cx
                push si
                push ds
                push es

                  sub si,si

                  mov ds,si             ; 0:0

                  push 0ffffh           ; ffff:10
                  pop es

                  mov ax,Word Ptr ds:[si+00000h]
                  mov cx,Word Ptr es:[si+00010h]
                  cmp ax,cx
                  jne @@a20_compare_not_equal

                  not Word Ptr ds:[si+00000h]  ; this is divide by zero, uncritical
                  not cx
                  cmp cx,Word Ptr es:[si+00010h]
                  mov Word Ptr ds:[si+00000h],ax
  @@a20_compare_not_equal:
                  setne dl

                pop es
                pop ds
                pop si
                pop cx
                pop ax
                popf
                ret
a_endp          query_a20

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          disable_a20
                push dx
                  mov dl,0
                  call set_a20
                pop dx
                ret
a_endp          disable_a20

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          enable_a20
                push dx
                  mov dl,1
                  call set_a20
                pop dx
                ret
a_endp          enable_a20

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; dl=0/1 (disable/enable)
a_proc          set_a20
                pushf
                pusha
                push ds

                  push cs
                  pop ds

                  mov dh,dl                     ; dh=requested value

                  call query_a20
                  cmp dh,dl
                  je @@exit__set_a20

                  jmp [ds:a20_access_code]

  @@a20_access_code_setup:

                  ; when 'private' access is selected, then
                  ; disable the BIOS access method for A20 control

                  cmp ds:[a20_access],a20_access_private
                  je @@int_15_240x_not_supported

                  ; skip that check next time
                  mov [ds:a20_access_code],Offset @@a20_access_code_try_int15_24

  @@a20_access_code_try_int15_24:

                  mov ah,024h
                  mov al,dh                     ; 0/1
                  push dx
                  stc
                  int 015h
                  pop dx
                  jc  @@int_15_240x_not_supported
                  test ah,ah
                  jnz @@int_15_240x_not_supported

                  call query_a20
                  cmp dh,dl
                  je  @@exit__set_a20

  @@int_15_240x_not_supported:
                  mov [ds:a20_access_code],Offset @@int_15_240x_not_supported1

  @@int_15_240x_not_supported1:
                  ; PS/2 A20 control
                  in  al,092h
                  cmp al,0ffh
                  je  @@set_a20_port92_not_supported

                  mov ah,al
                  ; get bit 1 from org_a20 bit 0
                  ror al,1
                  and al,(not 1)
                  or  al,dh             ; dh=org_a20
                  rol al,1

                  ; would we program something different?
                  cmp al,ah
                  je  @@set_a20_port92_not_supported1
                  out 092h,al
                  mov cx,50000
  @@set_a20_loop_92:
                  call query_a20
                  cmp dh,dl             ; restored?
                  je  @@exit__set_a20
                  call small_delay
                  loop @@set_a20_loop_92

                  ; A20 code was to slow. give up port 92
  @@set_a20_port92_not_supported:
                  mov [ds:a20_access_code],Offset @@set_a20_port92_not_supported1

                  ; port 92 did not work this time.
  @@set_a20_port92_not_supported1:

                  ; Keyboard controller
                  ; off(00) $DD=$DD+0*2
                  ; on (01) $DF=$DD+1*2
                  mov ah,dh
                  shl ah,1
                  add ah,0ddh                   ; DD/DF
                  call wait_64
                  jnz @@fail__set_a20

                  mov al,0D1h                   ; send command to the 804x
                  out 64h,al
                  call wait_64
                  jnz @@fail__set_a20

                  mov al,ah
                  out 60h,al
                  call wait_64

                  mov al,0FFh
                  out 64h,al
                  call wait_64
                  jmp @@exit__set_a20

  @@fail__set_a20:
                  trap msg_Failed_to_restore_A20_gate

  @@exit__set_a20:
                  ;call query_a20
                  ;cmp dh,dl
                  ;if_ne <trap msg_Returned_successfully_but_A20_rf>

                pop ds
                popa
                popf
                ret

a20_access_code dw Offset @@a20_access_code_setup

a_endp          set_a20

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          wait_64
                pusha
                  call small_delay
                  sub cx,cx

  @@loop_wait_ready:
                  ;schritt '*'
                  in al,064h
                  call small_delay
                  and al,002h                   ; input buffer full ?
                  loopne @@loop_wait_ready

                popa
                ret
a_endp          wait_64

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          small_delay
                push dx
                  mov dx,50
  @@loop_delay:
                  out 0edh,al
                  dec dx
                  jnz @@loop_delay
                pop dx
                ret
a_endp          small_delay

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; ds:di=@descriptor
                ; eax=base
                ; bx=limit
                ; dl=access
                ; -> di=di+8
a_proc          set_descriptor_add_di_desc

                mov [di].SegmentLimit,bx
                mov [di].BaseAddr1500,ax
                ror eax,16
                mov es:[di].BaseAddr2316,al
                mov es:[di].Access,dl
                mov es:[di].Access386,0
                mov es:[di].BaseAddr3124,ah
                rol eax,16

                add di,Size GDTDesc
                ret
a_endp          set_descriptor_add_di_desc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; registers setup like for Int 15/ah=87:
                ; es:si=descriptor array
                ; cx=word count
                ; -> ah/CF (0/1)
                ; does protect other registers (for example fs,gs)
                ; restores A20 state

a_proc          int_15_87
                pushad
                push ds
                push es
                push fs                         ; ?
                push gs                         ; f걊 Armin

                  call query_a20
                  push dx

                  cmp cs:[a20_access],a20_access_private
                  je @@do_a20_access_private

  @@do_a20_access_BIOS:

                  ; must enable A20: SVISTA (tinyBIOS) will expect it (ERROR!)

                  call enable_a20

                  ; "COPY EXTENDED MEMORY"
                  mov ah,087h
                  stc
                  int 015h
                  jmp @@exit

  @@do_a20_access_private:

                  ; running in protected mode?
                  mov eax,cr0
                  test al,1
                  jnz @@do_a20_access_BIOS      ; try to be compatible with memory manager

                  sgdt cs:org_gdt
                  sidt cs:org_idt

                  call enable_a20

                  push es
                  pop ds


                  ; cx=number of words
                  ; ds:si=gdt


                  mov di,si

                  ; GDT entry 0 is reserved
                  sub eax,eax                 ; base=0
                  sub bx,bx                   ; limit=0
                  mov dl,0                    ; access=0
                  call set_descriptor_add_di_desc

                  ; GDT entry 1 is used for GDT/ES:SI
                  mov eax,es                  ; base=es*16+si
                  shl eax,4
                  and esi,0ffffh
                  add eax,esi
                  dec bx                      ; limit=ffff
                 ;mov dl,dl                   ; access=0
                  call set_descriptor_add_di_desc

                  ; GDT entry 2 is used for the source
                  add di,Size GDTDesc

                  ; GDT entry 3 is used for the target
                  add di,Size GDTDesc

                  ; GDT entry 4 is used for the code
                  mov eax,cs                  ; base=cs*16+0
                  shl eax,4
                 ;mov bx,bx                   ; limit=ffff
                  mov dl,09bh                 ; access=9b
                  call set_descriptor_add_di_desc

                  ; GDT entry 5 is used for the stack
                  mov eax,ss                  ; base=ss*16+0
                  shl eax,4
                 ;mov bx,bx                   ; limit=ffff
                  mov dl,093h                 ; access=93
                  call set_descriptor_add_di_desc

                  pushf
                  cli

                  lidt fword Ptr cs:prot_idt
                  lgdt fword Ptr ds:[si+1*8]

                  ; + protect
                  mov eax,cr0
                  or al,1
                  mov cr0,eax

                  jmp @@flush_go_prot
    @@flush_go_prot:

                  mov ax,2*8
                  mov ds,ax
                  sub si,si

                  mov ax,3*8
                  mov es,ax
                  sub di,di

                  cld

                 ;mov cx,cx
                  shr cx,1
                  rep movsd
                  rcl cx,1
                  rep movsw

                  mov ax,5*8
                  mov ds,ax
                  mov es,ax

                  ; - protect
                  mov eax,cr0
                  and al,(not 1)
                  mov cr0,eax

                  jmp @@flush_go_real
    @@flush_go_real:
                  lgdt fword Ptr cs:org_gdt
                  lidt fword Ptr cs:org_idt

                  popf                          ; sti

                  clc                           ; successfuly copied

  @@exit:

                  pop dx
                  call set_a20

                pop gs
                pop fs
                pop es
                pop ds
                popad
                setc ah                         ; no error (00 when clc)
                ret
a_endp          int_15_87

                ;ALIGN 4

prot_idt        dw 0            ; can not handle
                dd 0
                dw 0

org_idt         dq 0
                dw 0

org_gdt         dq 0
                dw 0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

