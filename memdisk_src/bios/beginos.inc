Title                   configuration header and entry point (os2boot.ac)

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

code                    segment 'code' use16
                        assume cs:code
                        assume ds:code
IFDEF dos
                        org 00100h
ELSE
                        org 07c00h
ENDIF

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

anfang_org:             xchg al,al              ; Signature (AC)
                        jmp short nach_kopf

                        db 13,'OS2LDR.AC',datum,13,10,26,0

                        jmp einrichten          ; os2ldr_.tas

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

