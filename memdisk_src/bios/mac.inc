Title           assembler macros

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

IFDEF nodebug
PROGRESS        Macro S
                EndM
ELSE
PROGRESS        Macro S
                local continue
                pushf
                pusha
                call continue
                db S,13,10,0
  continue:
                pop si
                call ausschrift
                popa
                popf
                EndM
ENDIF ; -nodebug

STEP            Macro S
IFNDEF nodebugstep
                push DWord Ptr &S
                call ausschrift_STEP
ENDIF
                EndM

trap            Macro N
                IFNDEF nodebug
                db 0cch ; i n t 3
                ENDIF
                call trap_proc
                db &N,13,10,0
                EndM

fehler_halt     equ trap

fehler_meldung  Macro N
                local continue
                IFNDEF nodebug
                db 0cch ; i n t 3
                ENDIF
                push si
                call continue
                db &N,13,10,keypress,0
  continue:
                pop si
                call fehler_ausschrift
                pop si
                EndM

a_proc          macro FN
                &FN Proc
                public &FN
                EndM


a_endp          macro FN
                &FN EndP
                EndM

p_proc          macro FN
                &FN Proc Pascal
                public &FN
                EndM

p_endp          macro FN
                &FN EndP
                EndM


schritt         macro ZEICHEN
                pushf
                push ax
                  mov al,&ZEICHEN
                  call ausschrift_zeichen
                pop ax
                popf
                EndM


if_ae           macro st
                local continue
                jnae continue
                &st
  continue:
                EndM


if_b            macro st
                local continue
                jnb continue
                &st
  continue:
                EndM

if_a            macro st
                local continue
                jna continue
                &st
  continue:
                EndM

if_e            macro st
                local continue
                jne continue
                &st
  continue:
                EndM

if_z            macro st
                local continue
                jnz continue
                &st
  continue:
                EndM

if_c            macro st
                local continue
                jnc continue
                &st
  continue:
                EndM

if_nc           macro st
                local continue
                jc continue
                &st
  continue:
                EndM

if_be           macro st
                local continue
                jnbe continue
                &st
  continue:
                EndM

if_ne           macro st
                local continue
                je continue
                &st
  continue:
                EndM

if_nz           macro st
                local continue
                jz continue
                &st
  continue:
                EndM

if_nb           macro st
                local continue
                jb continue
                &st
  continue:
                EndM

if_ng           macro st
                local continue
                jg continue
                &st
  continue:
                EndM

if_p            macro st
                local continue
                jnp continue
                &st
  continue:
                EndM

if_np           macro st
                local continue
                jp continue
                &st
  continue:
                EndM

if_s            macro st
                local continue
                jns continue
                &st
  continue:
                EndM

if_ns           macro st
                local continue
                js continue
                &st
  continue:
                EndM

l_string        macro i,s
                local l1
                local l2
&i:
                db (Offset l2)-(Offset l1)
  l1:
                db &s
  l2:
                EndM

null            Macro r
                sub &r,&r
                EndM

push2           Macro r1,r2
                push &r1
                push &r2
                EndM

pop2            Macro r1,r2
                pop &r1
                pop &r2
                EndM

push3           Macro r1,r2,r3
                push &r1
                push &r2
                push &r3
                EndM

pop3            Macro r1,r2,r3
                pop &r1
                pop &r2
                pop &r3
                EndM

push4           Macro r1,r2,r3,r4
                push &r1
                push &r2
                push &r3
                push &r4
                EndM

pop4            Macro r1,r2,r3,r4
                pop &r1
                pop &r2
                pop &r3
                pop &r4
                EndM


exe_markierung  Macro MO
                IFDEF debug
                db 13,10
                db '<- ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ '
                db &MO
                db ' ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ'
                db 13,10
                ENDIF ; debug
                EndM


fs_lodsb_bis    Macro Z1
                local sl
  sl:
                lods byte ptr fs:[si]
                cmp al,Z1
                jne sl
                EndM


fs_lodsb_bis2   Macro Z1,Z2
                local sl,br
  sl:
                lods byte ptr fs:[si]
                cmp al,Z1
                je br
                cmp al,Z2
                jne sl
  br:
                EndM


p8str           Macro ID,ZK
                local a1,a2
  &ID:
                db (Offset a2-Offset a1)
  a1:
                db &ZK
  a2:
                EndM


far_jmp         Macro s,o
                db 0eah
                dw o
                dw s
                EndM

