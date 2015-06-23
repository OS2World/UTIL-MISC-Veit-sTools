Title           convert/round sector size

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; ecx=number of bytes
                ; fs:si=diskinfo
                ; ->ecx=number of sectors
a_proc          byte_to_sectornum
                push eax
IFDEF cdloader
                  movzx eax,cs:cd_sector_size_b
ELSE
                  movzx eax,fs:[si].sector_size_b
ENDIF
                 ;add eax,ecx
                 ;dec eax
                  lea eax,[ecx+eax-1]
IFDEF cdloader
                  mov cl,cs:cd_sector_size_s
ELSE
                  mov cl,fs:[si].sector_size_s
ENDIF
                  shr eax,cl
                  mov ecx,eax
                pop eax
                ret
a_endp          byte_to_sectornum

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; ecx=number of bytes
                ; fs:si=diskinfo
                ; ->ecx=round down to nearest lower muliple of sector size
a_proc          round_down_to_sectorsize
                push eax
IFDEF cdloader
                  movzx eax,cs:cd_sector_size_b
ELSE
                  movzx eax,fs:[si].sector_size_b
ENDIF
                  dec eax
                  not eax
                  and ecx,eax
                pop eax
                ret
a_endp          round_down_to_sectorsize

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF cdloader

                ; ecx=number of bytes
                ; fs:si=diskinfo
                ; ->ecx=round up to nearest higher muliple of sector size
a_proc          round_up_to_sectorsize
                push eax
IFDEF cdloader
                  movzx eax,cs:cd_sector_size_b
ELSE
                  movzx eax,fs:[si].sector_size_b
ENDIF
                  dec eax
                  add ecx,eax
                  not eax
                  and ecx,eax
                pop eax
                ret
a_endp          round_up_to_sectorsize

ENDIF ; -cdloader

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

k_errorcode_eq  db mgs_k_errorcode_eq,0

i13_errorcode   db 0

a_proc          ausschrift_errorcode
                pusha

                  mov si,Offset k_errorcode_eq
                  call ausschrift

                  mov al,cs:[i13_errorcode]
                  call ausschrift_al_hex

                popa
                ret
a_endp          ausschrift_errorcode


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int_13

                push gs
                push fs ; Systemsoft changes it ?

IFNDEF os2boot_ac_code
IFNDEF cdloader
                cmp dl,'M'
                jne not_memorydisk_int13

                pushf
                push cs
                call short_entrypoint_memorydisk_int13
                jmp exit_int_13

  not_memorydisk_int13:

ENDIF
ENDIF

                stc
                int 013h

exit_int_13:

                pop fs
                pop gs

                ret
a_endp          int_13

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
