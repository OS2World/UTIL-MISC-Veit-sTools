Title                   configuration header and entry point

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

code                    segment 'code' use16
                        assume cs:code
                        assume ds:code
IFDEF dos
                        org 00100h
ELSE
                        org 00000h
ENDIF

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; this data will be looked for by the OS/2 .add
                        ; to find the physical address
anfang_org:             jmp einrichten ; memalloc.inc

                        org anfang_org+3
                        db 13,'MemDisk ',datum,13,10,26,0

                        dw Offset cfg_record - Offset anfang_org

debugoption             db ?

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

