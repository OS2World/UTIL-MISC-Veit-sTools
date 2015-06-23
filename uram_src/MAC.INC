Title   Macro und Konstanten f걊 Tasm

unveraendert                    equ 0
veraendert                      equ 1


Bit0                            equ 01h
Bit1                            equ 02h
Bit2                            equ 04h
Bit3                            equ 08h
Bit4                            equ 010h
Bit5                            equ 020h
Bit6                            equ 040h
Bit7                            equ 080h
Bit8                            equ 0100h
Bit9                            equ 0200h
Bit00                           equ 01h
Bit01                           equ 02h
Bit02                           equ 04h
Bit03                           equ 08h
Bit04                           equ 010h
Bit05                           equ 020h
Bit06                           equ 040h
Bit07                           equ 080h
Bit08                           equ 0100h
Bit09                           equ 0200h
Bit10                           equ 0400h
Bit11                           equ 0800h
Bit12                           equ 01000h
Bit13                           equ 02000h
Bit14                           equ 04000h
Bit15                           equ 08000h
Bit16                           equ 010000h
Bit17                           equ 020000h
Bit18                           equ 040000h
Bit19                           equ 080000h
Bit20                           equ 0100000h
Bit21                           equ 0200000h
Bit22                           equ 0400000h
Bit23                           equ 0800000h
Bit24                           equ 01000000h
Bit25                           equ 02000000h
Bit26                           equ 04000000h
Bit27                           equ 08000000h
Bit28                           equ 010000000h
Bit29                           equ 020000000h
Bit30                           equ 040000000h
Bit31                           equ 080000000h

trap_protect                    Macro I1,I2
                                local p0,p1
                                cmp sp,(Offset p1-Offset p0)
  p0:
                                &I1
                                &I2
  p1:
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

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
ausschrift_xxxx_aehnliches_bios Macro Text
                                  mov dx,Offset &Text
                                  call ausschrift_xxxx_aehnliches_bios_prozedur
                                EndM

ausschrift                      Macro Text
                                  mov dx,Offset &Text
                                  call ausschrift_prozedur_ind
                                EndM

ausschrift_a                    Macro Text
                                  mov dx,Offset &Text
                                  call ausschrift_prozedur
                                EndM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
installiere_tracer              Macro
                                  call installiere_tracer_prozedur
                                EndM
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
entferne_tracer                 Macro
                                  call entferne_tracer_prozedur
                                EndM
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
null                            Macro R1
                                  sub &R1,&R1
                                EndM

a_proc          macro FN
                &FN Proc Near
                public &FN
                EndM


a_endp          macro FN
                &FN EndP
                EndM

halt                            Macro EC
                                  mov al,&EC
                                  jmp halt_code
                                EndM

ptr1616                         Struc
  _OFF                          dw ?
  _SEG                          dw ?
ptr1616                         EndS

and_or_record                   Struc
  and_wert                      dd 0ffffffffh
  or_wert                       dd 000000000h
and_or_record                   EndS


ifdef                           debug386

.586p                           Macro
                                  .386p
                                EndM

cpuid                           Macro
                                  db 00fh,0a2h
                                EndM

wbinvd                          Macro
                                  db 00fh,009h
                                EndM

rdmsr                           Macro
                                  db 00fh,032h
                                EndM

wrmsr                           Macro
                                  db 00fh,030h
                                EndM


endif                           ; debug386


