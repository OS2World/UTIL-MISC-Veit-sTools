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


if_e                    macro st
                        local continue
                        jne continue
                        &st
  continue:
                        EndM


if_nz                   macro st
                        local continue
                        jz continue
                        &st
  continue:
                        EndM


if_ne                   macro st
                        local continue
                        je continue
                        &st
  continue:
                        EndM


if_a                    macro st
                        local continue
                        jna continue
                        &st
  continue:
                        EndM


if_c                    macro st
                        local continue
                        jnc continue
                        &st
  continue:
                        EndM

if_b                    macro st
                        local continue
                        jnb continue
                        &st
  continue:
                        EndM

