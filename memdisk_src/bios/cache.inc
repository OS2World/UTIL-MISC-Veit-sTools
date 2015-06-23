Title   disable/enable CPU cache - slowdown

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; used code from ice/uram package


a_proc          toggle_cache
                pushad
                push    ds

                push    0
                pop     ds
                mov     di,6h*4h        ; Int 6: Invalid opcode

                mov     ecx, DWord Ptr ds:[di]

                mov     Word Ptr ds:[di+0], Offset int6_ignore
                mov     Word Ptr ds:[di+2], cs
.486p
                wbinvd
                mov     eax, cr0
                xor     eax, 60000000h
                mov     cr0, eax
                wbinvd
.386p
                jmp disable_cache_exit

  int6_ignore:
                add     sp,2+2          ; pop cs/ip/flags of error
                popf

  disable_cache_exit:
                mov     DWord Ptr ds:[di], ecx

                pop ds
                popad
                ret
a_endp          toggle_cache

