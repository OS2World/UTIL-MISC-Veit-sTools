Title                   configuration header and entry point (cdloader)

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

anfang_org:             jmp einrichten ; memalloc.inc

                        org anfang_org+3

                        db 13,'CDLOADER ',datum,13,10,26,0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

