Title   language dependant boot menu definitions (italian)

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; Menu 1: CD or hard disk

menu1:
                        db 44   ; columns
                        db  5   ; first menu column
                        db 39   ; last menu column

                        db  5   ; rows
                        db  1   ; first menu row
                        db  2   ; last menu row

                        db MenuAttrFrame
                        db MenuAttrSelection

                        dw Offset menu1_image
                        dw Offset menu1_licensenote
                        dw Offset menu1a_time20_msg1 ; \
                        dw Offset menu1a_time20_msg2 ; / 20 seconds
                        dw Offset menu1a_time1_msg1 ; \
                        dw Offset menu1a_time1_msg2 ; / 1 second
                        dw Offset menu1a_stop_msg1
                        dw Offset menu1a_stop_msg2

                        db 1    ; default value
                        dw 20   ; time to wait for a user input
                        db true ; stop timer with Esc only

                        ;            11111111112222222222333333333344444
                        ;   12345678901234567890123456789012345678901234
menu1_image             db "    > Avvio dal disco rigido          <     " ; 1
                        db "      Avvio dal CD-ROM di eComStation       " ; 2
                        db "                                            " ; 3
                        db " Premere 'Esc' per annullare l'avvio        " ; 4
                        db " automatico dal disco rigido in xx secondi. " ; 5
                       ;db "                                            " ;
                       ;db "   Avviando il sistema da CD-ROM si         " ;
                       ;db "   accettano le condizioni di licenza       " ;
                       ;db "   riportate nel file license.txt           " ;

eComStation             equ Offset menu1_image+(2-1)*44+(27-1)*1

menu1a_time20_msg1      db 2,4,"Premere 'Esc' per annullare l'avvio",0
menu1a_time20_msg2      db 2,5,"automatico dal disco rigido in ",string_numlongint
                        dw Offset menu_seconds_left
                        db " secondi.",0
menu1a_time1_msg1       equ menu1a_time20_msg1
menu1a_time1_msg2       db 2,5,"Avvio dal disco rigido in 1 secondo.",0
menu1a_stop_msg1        db 2,4,"Conto alla rovescia disattivato.",0
menu1a_stop_msg2        db 2,5,"",0

menu1b_time20_msg1      db 2,4,"Premere 'Esc' per annullare l'avvio",0
menu1b_time20_msg2      db 2,5,"automatico dal ",string_string
                        dw Offset ecs_cdtitel
                        db " in ",string_numlongint
                        dw Offset menu_seconds_left
                        db " secondi.",0
menu1b_time1_msg1       equ menu1b_time20_msg1
menu1b_time1_msg2       db 2,5,"Avvio dal ",string_string
                        dw Offset ecs_cdtitel
                        db " in 1 secondo.",0
menu1b_stop_msg1        equ menu1a_stop_msg1
menu1b_stop_msg2        equ menu1a_stop_msg2

menu1_licensenote       db "Scegliendo di avviare il sistema da CD-ROM si accettano le     ",13,10
                        db "condizioni di licenza riportate nel file license.txt.          ",0


exe_menu1:
                        dw boot_harddisk    ; 1
                        dw show_menu2       ; 2


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

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
menu2_image             db "   Avvio con impostazioni predefinite     " ; 1
                        db "   Avvio con menu modifica impostazioni   " ; 2
                        db "   Aiuto in linea                         " ; 3

exe_menu2:
                        dw continue_boot_default        ; 1
                        dw continue_boot_advanced       ; 2
                        dw load_readme_txt              ; 3

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

