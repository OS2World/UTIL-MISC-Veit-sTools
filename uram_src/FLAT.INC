Title   FLAT REAL / REAL BIG / UNREAL MODE (v1.2) von Herman Dullink

        .586p

a_proc  FLAT_install                    ; Installs FLAT_tsr
        pushf                           ; Save flags & DS register
        push    ds
        cli
        xor     eax,eax                 ; Get IRQ5 vector & Set FLAT_tsr
        mov     ds,ax
        mov     ebx,ds:[34h]
        mov     cs:old_IRQ5,ebx
        mov     word ptr ds:[34h],offset FLAT_tsr
        mov     ax,cs
        mov     ds:[36h],ax
        shl     eax,4                   ; Build Global Descriptor Table
        add     dword ptr cs:GDT[2],eax
        pop     ds                      ; Restore DS register & flags
        popf
        ret
a_endp  FLAT_install

a_proc  FLAT_destall                    ; Destalls FLAT_tsr
        push    ds                      ; Save DS register
        push    0                       ; Restore old IRQ5 vector
        pop     ds
        mov     eax,cs:old_IRQ5
        test    eax,eax
        jz      flat_not_installed
        mov     ds:[34h],eax
  flat_not_installed:
        pop     ds                      ; Restore DS register
        ret
a_endp  FLAT_destall

        align   8
GDT             dw      15              ; Limit (16 bytes)
                dw      offset GDT,0    ; Offset within current segment...
                dw      ?               ; Unused

FLAT_desc       dw      0ffffh          ; Limit (bit 0..15)
                db      ?,?,?           ; Base (bit 0..23)
                db      92h             ; Access rights
                db      0cfh            ; Page granularity + Limit(16..19)
                db      ?               ; Base (bit 24..31)

FLAT_sel        equ     FLAT_desc - GDT


old_IRQ5        dd      0
last_Exc_13     dd      0
IRQ5_flag       db      0

a_proc  FLAT_tsr
        test    cs:IRQ5_flag,1          ; Exception within IRQ5 handler?
        jnz     short Exc_13
        push    ax                      ; Ask PIC if IRQ5 is 'IN-SERVICE'
        mov     al,0Bh
        out     20h,al
        jmp     $+2
        in      al,20h
        test    al,20h
        pop     ax
        jz      short Exc_13

IRQ5:   mov     cs:IRQ5_flag,1          ; Call old IRQ5 handler
        pushf
        call    dword ptr cs:old_IRQ5
        mov     cs:IRQ5_flag,0
        iret

Exc_13: push    eax                     ; Save accumulator

        mov     eax,ss:esp[4]           ; Get address of SOE
        cmp     eax,cs:last_Exc_13      ; Same as last time?
        je      short SOE
        mov     cs:last_Exc_13,eax
.386p
        lgdt    qword ptr cs:GDT        ; Load GDT Register

        push    gs fs es ds bx          ; Save registers

        mov     eax,CR0
        or      al,1                    ; Enter Protected mode
        mov     CR0,eax

        jmp     $+2                     ; Flush instruction decode queue

        mov     bx,FLAT_sel             ; Load 4Gb limits
        mov     ds,bx
        mov     es,bx
        mov     fs,bx
        mov     gs,bx

        and     al,not 1                ; Back to Real mode
        mov     CR0,eax
.386
        pop     bx ds es fs gs          ; Restore registers
        pop     eax                     ; Restore accumulator
        iret                            ; Done

SOE:    call    FLAT_destall            ; Remove FLAT_tsr
        ausschrift_a SOE_msg
        halt    00dh

SOE_msg         db      'Segment Overrun Exception!',13,10,'$'

a_endp  FLAT_tsr

