Title   IRQ filters to prevent register corrupion in BIOS IRQ handlers

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          install_irq_filters
                pushad
                push es

                  push 0
                  pop es

                  mov ax,cs
                  shl eax,16

                  ; prevously not installed, but now count becomes 1?
                  cmp irq_filtered,0
                  jne exit_install_irq_filters

                  mov si,Offset begin_irq_filters
  loop_install_irq_filters:
                  mov ax,si                     ; cs:ip
                  movzx di,Byte Ptr [si+3]      ; irq
                  shl di,2                      ; *4
                  mov edx,es:[di]               ; get BIOS IRQ handler
                  mov [si+4],edx                ; save BIOS IIRQ handler
                  mov es:[di],eax               ; install filter

                  add si,3+1+4                  ; next filter
                  cmp si,Offset end_irq_filters
                  jne loop_install_irq_filters

  exit_install_irq_filters:

                  inc irq_filtered

                pop es
                popad
                ret
a_endp          install_irq_filters

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          uninstall_irq_filters
                pushad
                push es

                  push 0
                  pop es

                  ; prevously installed, but now count becomes 0?
                  dec irq_filtered
                  jnz exit_uninstall_irq_filters

                  mov si,Offset begin_irq_filters
  loop_uninstall_irq_filters:
                  movzx di,Byte Ptr [si+3]      ; irq
                  shl di,2                      ; *4
                  mov eax,DWord Ptr [si+4]      ; old BIOS IRQ handler
                  mov es:[di],eax               ; restore

                  add si,3+1+4                  ; next filter
                  cmp si,Offset end_irq_filters
                  jne loop_uninstall_irq_filters

  exit_uninstall_irq_filters:

                pop es
                popad
                ret
a_endp          uninstall_irq_filters

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

irq_filtered    dw 0

filter_irq      Macro INT                       ; +0
                call irq_filter_proc            ; +3
                db &INT                         ; +4
                dd ?                            ; +8
                EndM

begin_irq_filters:
                filter_irq 008h                 ; IRQ  0
                filter_irq 009h                 ; IRQ  1
                filter_irq 00ah                 ; IRQ  2
                filter_irq 00bh                 ; IRQ  3
                filter_irq 00ch                 ; IRQ  4
                filter_irq 00dh                 ; IRQ  5
                filter_irq 00eh                 ; IRQ  6
                filter_irq 00fh                 ; IRQ  7

                filter_irq 070h                 ; IRQ  8
                filter_irq 071h                 ; IRQ  9
                filter_irq 072h                 ; IRQ 10
                filter_irq 073h                 ; IRQ 11
                filter_irq 074h                 ; IRQ 12
                filter_irq 075h                 ; IRQ 13
                filter_irq 076h                 ; IRQ 14
                filter_irq 077h                 ; IRQ 15
end_irq_filters:

a_proc          irq_filter_proc                 ; Word Ptr ss:[bp+4]
                push ax         ; dummy 16 bit  ; Word Ptr ss:[bp+2]
                push bp                         ; Word Ptr ss:[bp+0]
                mov bp,sp
                pushfd
                push eax
                push si

                  mov si,Word Ptr ss:[bp+4]     ; @&INT
                  mov eax,cs:[si-3+3+1]         ; get org BIOS IRQ handler
                  mov DWord Ptr ss:[bp+2],eax   ; set retf/call target

                  mov ax,cs                     ; still running on our stack?
                  mov si,ss
                  cmp ax,si
                pop si
                pop eax
                jne irq_filter_proc_not_my_stack

                ; save 'all' registers
                pushad
                push ds
                push es
                push fs
                push gs

                ; call org BIOS handler
                pushf
                call DWord Ptr ss:[bp+2]

                ; restore 'all' registers
                pop gs
                pop fs
                pop es
                pop ds
                popad

                ; restore stack and return from IRQ
                popfd
                pop bp
                add sp,2*2
                iret                            ; restores cs,ip,flags

  irq_filter_proc_not_my_stack:

                popfd
                pop bp
                retf                            ; 'return' to original handler
a_endp          irq_filter_proc



;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
