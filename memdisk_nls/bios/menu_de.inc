Title   language dependant boot menu definitions (german)

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; Menu 1: CD or hard disk

menu1:
                        db 42   ; columns
                        db  2   ; first menu column
                        db 41   ; last menu column

                        db  5   ; rows
                        db  1   ; first menu row
                        db  2   ; last menu row

                        db MenuAttrFrame
                        db MenuAttrSelection

                        dw Offset menu1_image
                        dw Offset menu1_licensenote
                        dw Offset menu1a_time20_msg1 ; \
                        dw Offset menu1a_time20_msg2 ; / 20 Sekunden
                        dw Offset menu1a_time1_msg1 ; \
                        dw Offset menu1a_time1_msg2 ; / 1 Sekunde
                        dw Offset menu1a_stop_msg1
                        dw Offset menu1a_stop_msg2

                        db 1    ; default value
                        dw 20   ; time to wait for a user input
                        db true ; stop timer with Esc only

                        ;            111111111122222222223333333333444
                        ;   123456789012345678901234567890123456789012
menu1_image             db " > Starten von Festplatte               < " ; 1
                        db "   Starten von eComStation CD-ROM         " ; 2
                        db "                                          " ; 3
                        db "  Drcken Sie 'Esc', um das Starten von   " ; 4
                        db "  Festplatte in xx Sekunden anzuhalten.   " ; 5

eComStation             equ Offset menu1_image+(2-1)*42+(16-1)*1

menu1a_time20_msg1      db 3,4,"Drcken Sie 'Esc', um das Starten von",0
menu1a_time20_msg2      db 3,5,"Festplatte in ",string_numlongint
                        dw Offset menu_seconds_left
                        db " Sekunden anzuhalten.",0
menu1a_time1_msg1       equ menu1a_time20_msg1
menu1a_time1_msg2       db 3,5,"Festplatte in 1 Sekunde anzuhalten.",0
menu1a_stop_msg1        db 3,4,"Automatischer Festplattenstart",0
menu1a_stop_msg2        db 3,5,"ist abgeschaltet.",0

menu1b_time20_msg1      equ menu1a_time20_msg1
menu1b_time20_msg2      db 3,5,string_string
                        dw Offset ecs_cdtitel
                        db " in ",string_numlongint
                        dw Offset menu_seconds_left
                        db " Sekunden anzuhalten.",0
menu1b_time1_msg1       equ menu1b_time20_msg1
menu1b_time1_msg2       db 3,5,string_string
                        dw Offset ecs_cdtitel
                        db " in 1 Sekunde anzuhalten.",0
menu1b_stop_msg1        db 3,4,"Automatischer Start von ",string_string
                        dw Offset ecs_cdtitel
                        db 0
menu1b_stop_msg2        equ menu1a_stop_msg2

menu1_licensenote       db "Durch Auswahl des Startens von CD-ROM akzeptieren Sie, das Sie an ",13,10
                        db "die Lizenzbestimmungen in license.txt gebunden sind.               ",0

exe_menu1:
                        dw boot_harddisk    ; 1
                        dw show_menu2       ; 2

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

; Menu 2: default/advanced/readme


menu2:
                        db 42   ; columns
                        db  2   ; first menu column
                        db 41   ; last menu column

                        db  3   ; rows
                        db  1   ; first menu row
                        db  3   ; last menu row

                        db MenuAttrFrame
                        db MenuAttrSelection

                        dw Offset menu2_image
                        dw -1   ; no license note
                        dw -1   ; 20 seconds
                        dw -1   ; 20 seconds
                        dw -1   ; 1 second
                        dw -1   ; 1 second
                        dw -1   ; timer off
                        dw -1   ; timer off

                        db 1    ; default value
                        dw 0    ; time to wait for a user input
                        db true ; stop timer with Esc only

                        ;            111111111122222222223333333333444
                        ;   123456789012345678901234567890123456789012
menu2_image             db "   Starten mit Standardwerten             " ; 1
                        db "   Starten mit Men fr eigene Werte      " ; 2
                        db "   Online-Dokumentation anzeigen          " ; 3
exe_menu2:
                        dw continue_boot_default        ; 1
                        dw continue_boot_advanced       ; 2
                        dw load_readme_txt              ; 3

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
