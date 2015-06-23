Title   resident code and data (at 639KB or video memory)

                        include trapproc.inc
                        exe_markierung 'Fehler-Ausschrift'
ifndef memdisk ; memdisk does already include this
ifndef language_en
                        include tastatur.inc
                        exe_markierung 'Tastaturtreiber'
endif ; -language_en
endif ; -memdisk
                        include luxus.inc
                        exe_markierung 'Luxus'
                        include suchevar.inc
                        exe_markierung 'SucheVariable'
                        include echo.inc
                        exe_markierung 'Echo'
                        include modzeich.inc
                        exe_markierung 'ModZeichnen'
ifndef memdisk
                        include bconfigr.inc
                        exe_markierung 'A/B-Config.sys'
                        include hand13r.inc
                        exe_markierung 'Behandlung INT 13'
endif ; -memdisk
                        include mod.inc
                        exe_markierung 'Modifikation'
                        ;--------------------------------------------

                        ;--------------------------------------------
                        ; dauerhaft ben”tigter Variablenanteil
dauervariablen:

anzahl_variablen        dw 0

ifdef memdisk
variablen_bereich       dw 0 ; buffer is calculated by os2csm.exe
else
variablen_bereich       dw variablen_bereich_soll
variablen_bereich_soll: db  5000 dup ('*')
endif

