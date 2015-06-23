                .486p
code            Segment 'CODE' Use16
                Assume cs:code
                Assume ds:code
                Org 0100h
  Entry:

                push    0
                pop     es
                mov     di,6h*4h        ; Int 6: Invalid opcode

                mov     ecx, DWord Ptr es:[di]

                mov     Word Ptr es:[di+0], Offset int6
                mov     Word Ptr es:[di+2], cs

                mov     ah, 9
                mov     dx, Offset logo
                int     21h

                mov     eax, cr0
ifdef ice
                and     eax, not 60000000h
else
                or      eax, 60000000h
endif
                mov     cr0, eax

                wbinvd

exit:
                mov     DWord Ptr es:[di], ecx

                int     20h

int6:
                mov     ah, 9
                mov     dx, Offset message_trap
                int     21h

                mov     ah, 7
                int     21h
                jmp     exit

ifdef ice
logo            db 'Enabling Internal Cache',13,10,'$'
else
logo            db 'Disabling Internal Cache',13,10,'$'
endif

message_trap    db 'Can not run in virtual mode (invalid opcode), press a key ..',13,10,'$'

code            EndS

                End Entry
