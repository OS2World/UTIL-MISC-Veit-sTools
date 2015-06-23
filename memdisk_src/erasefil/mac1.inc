;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
a_proc                  Macro ID
                        &ID proc
                        EndM


a_endp                  Macro ID
                        &ID endp
                        public &ID
                        EndM

p_proc                  Macro ID
                        &ID proc PASCAL
                        EndM


p_endp                  Macro ID
                        &ID endp
                        public &ID
                        EndM


if_e                    Macro st
                        local continue
                        jne continue
                        &st
  continue:
                        EndM

if_z                    Macro st
                        local continue
                        jnz continue
                        &st
  continue:
                        EndM


if_nz                   Macro st
                        local continue
                        jz continue
                        &st
  continue:
                        EndM


if_ne                   Macro st
                        local continue
                        je continue
                        &st
  continue:
                        EndM


if_a                    Macro st
                        local continue
                        jna continue
                        &st
  continue:
                        EndM


if_c                    Macro st
                        local continue
                        jnc continue
                        &st
  continue:
                        EndM

if_b                    Macro st
                        local continue
                        jnb continue
                        &st
  continue:
                        EndM

if_ae                   Macro st
                        local continue
                        jnae continue
                        &st
  continue:
                        EndM

if_nc                   Macro st
                        local continue
                        jc continue
                        &st
  continue:
                        EndM

if_be                   Macro st
                        local continue
                        jnbe continue
                        &st
  continue:
                        EndM


false                   equ 0
true                    equ 1

p8str                   Macro ID,ZK
                        local a1,a2
  &ID:
                        db (Offset a2-Offset a1)
  a1:
                        db &ZK
  a2:
                        EndM

;mov_es_dx               Macro W
;                        push Seg &W
;                        pop es
;                        mov dx,Offset &W
;                        EndM

;mov_es_di               Macro W
;                        push Segi &W
;                        pop es
;                        mov di,Offset &W
;                        EndM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                        ; value: bit15--8=bus number
                        ;        bit07--3=device number
                        ;        bit02--0=function number
Set_PCI_DevFunc         Macro PDF,value
                        ; found no example of PCI_DevFunc usage, so this may be not accordingg to
                        ; the IBM intended usage. Please change this macro to change it.
                        mov &PDF,&value
                        EndM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

sub_ecx_eax_not_below_zero Macro
                        sub ecx,eax
                        if_c <sub ecx,ecx>
                        EndM

add_edx_eax_with_type_limit Macro
                        add edx,eax
                        ; if CF=1 a wraparound has happened, limit to highest value
                        if_c <mov edx,type_limit>
                        ; even if no wraparound has happened, it may be larger
                        ; than the largest allowed addres, in cas of I/O.
                        cmp edx,type_limit
                        if_a <mov edx,type_limit>
                        EndM

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

