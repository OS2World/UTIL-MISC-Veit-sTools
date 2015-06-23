Title   language dependant boot menu definitions (dutch JB/Mensys)

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; Menu 1: CD or hard disk

menu1:
                        db 40   ; columns
                        db  2   ; first menu column
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

                        ;            1111111111222222222233333333334
                        ;   1234567890123456789012345678901234567890
menu1_image             db " >   Start vanaf harde schijf         < " ; 1
                        db "     Start vanaf eComStation Cd-rom     " ; 2
                        db "                                        " ; 3
                        db " 'Esc' annuleert automatisch starten    " ; 4
                        db " vanaf harde schijf in xx seconden.     " ; 5

eComStation             equ Offset menu1_image+(2-1)*40+(18-1)*1

menu1a_time20_msg1      db 2,4,"'Esc' annuleert automatisch starten",0
menu1a_time20_msg2      db 2,5,"vanaf harde schijf in ",string_numlongint
                        dw Offset menu_seconds_left
                        db " seconden.",0
menu1a_time1_msg1       equ menu1a_time20_msg1
menu1a_time1_msg2       db 2,5,"vanaf harde schijf over 1 seconde.",0
menu1a_stop_msg1        db 2,4,"Aftellen gestopt.",0
menu1a_stop_msg2        db 2,5,"",0

menu1b_time20_msg1      equ menu1a_time20_msg1
menu1b_time20_msg2      db 2,5,"vanaf ",string_string
                        dw Offset ecs_cdtitel
                        db " in ",string_numlongint
                        dw Offset menu_seconds_left
                        db " seconden.",0
menu1b_time1_msg1       equ menu1a_time20_msg1
menu1b_time1_msg2       db 2,5,"vanaf ",string_string
                        dw Offset ecs_cdtitel
                        db " over 1 seconde.",0
menu1b_stop_msg1        equ menu1a_stop_msg1
menu1b_stop_msg2        equ menu1a_stop_msg2


menu1_licensenote       db "Met de keuze 'Start vanaf Cd-rom',                                  ",13,10
                        db "gaat u akkoord met de licentie-voorwaarden genoemd in 'license.txt'.",0



exe_menu1:
                        dw boot_harddisk    ; 1
                        dw show_menu2       ; 2


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; Menu 2: default/advanced/readme


menu2:
                        db 44   ; columns
                        db  2   ; first menu column
                        db 43   ; last menu column

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

                        ;            11111111112222222222333333333344444
                        ;   12345678901234567890123456789012345678901234
menu2_image             db "   Start met standaard instellingen         " ; 1
                        db "   Start met menu voor eigen instellingen   " ; 2
                        db "   Laat online documentatie zien            " ; 3

exe_menu2:
                        dw continue_boot_default        ; 1
                        dw continue_boot_advanced       ; 2
                        dw load_readme_txt              ; 3

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

