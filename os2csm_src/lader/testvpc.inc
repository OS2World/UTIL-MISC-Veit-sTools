Title   Check for Virtual PC, 5.1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

p8str name_os2csm_vpc           'OS2CSM_VPC'
p8str searchstring_vpc          'Virtual PC'

; ES:8D11  69 78 20 43 6F 72 70 6F 72 61 74 69 6F 6E 00 56  ix Corporation.V
; ES:8D21  69 72 74 75 61 6C 20 50 43 00 35 2E 30 00 56 50  irtual PC.5.0.VP
; ES:8D31  57 35 00 00 02 08 02 00 01 02 03 04 43 6F 6E 6E  W5..........Conn
; ES:8D41  65 63 74 69 78 20 43 6F 72 70 6F 72 61 74 69 6F  ectix Corporatio

a_proc          check_virtual_pc
                pusha
                push es

                  push 0f000h
                  pop es
                  cld

                  mov si,Offset searchstring_vpc
                  call search_bios_ic

                  setz dl
                  mov dh,0

                pop es
                mov si,Offset name_os2csm_vpc
                call suche_variable_p8
                test di,di
                if_nz <mov [di].aktuelle_einstellung,dx>
                popa
                ret
a_endp          check_virtual_pc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
