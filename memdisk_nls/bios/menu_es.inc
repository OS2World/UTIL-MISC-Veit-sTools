Title   language dependant boot menu definitions (spanish)

; thanks to Alfredo Fern쟮dez D죂z

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; Menu 1: CD or hard disk

menu1:
                        db 45   ; columns
                        db  2   ; first menu column
                        db 44   ; last menu column

                        db  5   ; rows
                        db  1   ; first menu row
                        db  2   ; last menu row

                        db MenuAttrFrame
                        db MenuAttrSelection

                        dw Offset menu1_image
                        dw Offset menu1_licensenote
                        dw Offset menu1a_time20_msg1 ; \
                        dw Offset menu1a_time20_msg2 ; / 20 segundos
                        dw Offset menu1a_time1_msg1 ; \
                        dw Offset menu1a_time1_msg2 ; / 1 segundo
                        dw Offset menu1a_stop_msg1
                        dw Offset menu1a_stop_msg2

                        db 1    ; default value
                        dw 20   ; time to wait for a user input
                        db true ; stop timer with Esc only

                        ;            111111111122222222223333333333444444
                        ;   123456789012345678901234567890123456789012345
menu1_image             db " > Arrancar desde disco duro               < " ; 1 Boot from hard disk
                        db "   Arrancar desde el CD-Rom de eComStation   " ; 2 Boot from eComStation CD-ROM
                        db "                                             " ; 3
                        db "   Pulse 'Esc' para cancelar el arranque     " ; 4 Press 'Esc' to cancel automatic
                        db "   autom쟴ico de disco duro en XX segundos.  " ; 5 hard disk boot in xx seconds.

eComStation             equ Offset menu1_image+(2-1)*45+(32-1)*1

menu1a_time20_msg1      db 4,4,"Pulse 'Esc' para cancelar el arranque",0
menu1a_time20_msg2      db 4,5,"autom쟴ico de disco duro en ",string_numlongint
                        dw Offset menu_seconds_left
                        db " segundos.",0
menu1a_time1_msg1       equ menu1a_time20_msg1
menu1a_time1_msg2       db 4,5,"autom쟴ico de disco duro en 1 segundo.",0

menu1a_stop_msg1        db 4,4,"Cuenta atr쟳 detenida.",0
menu1a_stop_msg2        db 4,5,"",0

menu1b_time20_msg1      equ menu1a_time20_msg1
menu1b_time20_msg2      db 4,5,"autom쟴ico de ",string_string
                        dw Offset ecs_cdtitel
                        db " en ",string_numlongint
                        dw Offset menu_seconds_left
                        db " segundos.",0
menu1b_time1_msg1       equ menu1a_time20_msg1
menu1b_time1_msg2       db 4,5,"autom쟴ico de ",string_string
                        dw Offset ecs_cdtitel
                        db " en 1 segundo.",0

menu1b_stop_msg1        equ menu1a_stop_msg1
menu1b_stop_msg2        equ menu1a_stop_msg2


menu1_licensenote       db "Al elegir 'Arrancar desde el CD-ROM',",13,10
                        db "acepta vd. los t굍minos de licencia expuestos en license.txt.",0

exe_menu1:
                        dw boot_harddisk    ; 1
                        dw show_menu2       ; 2


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; Menu 2: default/advanced/readme


menu2:
                        db 43   ; columns
                        db  2   ; first menu column
                        db 42   ; last menu column

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

                        ;            1111111111222222222233333333334444
                        ;   1234567890123456789012345678901234567890123
menu2_image             db "   Arrancar con valores por omisi줻        " ; 1 Boot with default values
                        db " > Arrancar men� para introducir valores < " ; 2 Boot with menu for own values
                        db "   Mostrar documentaci줻 en l죒ea          " ; 3 Display online documentation

exe_menu2:
                        dw continue_boot_default        ; 1
                        dw continue_boot_advanced       ; 2
                        dw load_readme_txt              ; 3

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
