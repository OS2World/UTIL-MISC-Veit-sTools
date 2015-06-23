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

PTR1616                 Struc
  _OFF                  dw ?
  _SEG                  dw ?
PTR1616                 EndS

TRAP                    Macro
                        local a1
  a1:
                        db 0cch                 ; <- I N T 3
                        jmp a1
                        EndM

