Title   resident portion of a:\config.sys swapper

ifndef memdisk

;***************************************************************************
; bleibender Teil passend zu BconfigI.inc
;***************************************************************************
; ax=sektornummer
; ->es:bx
; ds=cs
a_proc                  lies_sektor_b
                        pusha
                          mov si,3                      ; 3 Versuche

                          div byte ptr [sektoren_je_spur]
                          mov cl,ah                     ; Sektor
                          inc cx                        ; Sektoren sind 1..
                          mov ah,0
                          div byte ptr [anzahl_koepfe]
                          mov dh,ah                     ; Kopf
                          mov ch,al                     ; Spur

                          mov ax,00201h                 ; 1 Sektor lesen
                          mov dl,[ab_config_laufwerk]
lies_sektor_b_schleife:
                          pusha
                            ;int 013h
                            pushf
                            call dword ptr [int13_org]
                          popa
                          jnc lies_sektor_b_ende

                          pusha
                            sub ax,ax                   ; zurÅcksetzten
                            mov dl,[ab_config_laufwerk]
                            ;int 013h
                            pushf
                            call dword ptr [int13_org]
                          popa

                          dec si
                          jnz lies_sektor_b_schleife
                          stc
lies_sektor_b_ende:
                        popa
                        ret
a_endp                  lies_sektor_b

;***************************************************************************
sektoren_je_spur        db 18
anzahl_koepfe           db  2

ab_config_laufwerk      db 0

sektor_tabelle:
                        dw 128 dup (0) ; 64 KB config.sys
sektor_tabelle_ende:

;***************************************************************************

endif ; -memdisk
