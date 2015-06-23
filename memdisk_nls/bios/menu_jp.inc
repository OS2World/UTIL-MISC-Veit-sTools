Title   language dependant boot menu definitions (english)

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

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
                        dw Offset menu1a_time20_msg2 ; / 20 seconds
                        dw Offset menu1a_time1_msg1 ; \
                        dw Offset menu1a_time1_msg2 ; / 1 second
                        dw Offset menu1a_stop_msg1
                        dw Offset menu1a_stop_msg2

                        db 1    ; default value
                        dw 20   ; time to wait for a user input
                        db true ; stop timer with Esc only

                        ;            111111111122222222223333333333444
                        ;   123456789012345678901234567890123456789012
        menu1_image     db " > Boot from hard disk                  < " ; 1
                        db "   Boot from eComStation CD-ROM           " ; 2
                        db "                                          " ; 3
                        db "   Press 'Esc' to cancel automatic        " ; 4
                        db "   hard disk boot in xx seconds.          " ; 5
                       ;db "                                          " ;
                       ;db "   By choosing boot from CD-ROM,          " ;
                       ;db "   You accept the lincense conditions     " ;
                       ;db "   mentioned in license.txt               " ;

eComStation             equ Offset menu1_image+(2-1)*42+(14-1)*1

menu1a_time20_msg1      db 4,4,"Press 'Esc' to cancel automatic",0
menu1a_time20_msg2      db 4,5,"hard disk boot in ",string_numlongint
                        dw Offset menu_seconds_left
                        db " seconds.",0
menu1a_time1_msg1       equ menu1a_time20_msg1
menu1a_time1_msg2       db 4,5,"hard disk boot in 1 second.",0
menu1a_stop_msg1        db 4,4,"Timeout stopped.",0
menu1a_stop_msg2        db 4,5,"",0

menu1b_time20_msg1      equ menu1a_time20_msg1
menu1b_time20_msg2      db 4,5,string_string
                        dw Offset ecs_cdtitel
                        db " boot in ",string_numlongint
                        dw Offset menu_seconds_left
                        db " seconds.",0
menu1b_time1_msg1       equ menu1a_time20_msg1
menu1b_time1_msg2       db 4,5,string_string
                        dw Offset ecs_cdtitel
                        db " boot in 1 second.",0
menu1b_stop_msg1        equ menu1a_stop_msg1
menu1b_stop_msg2        equ menu1a_stop_msg2

menu1_licensenote       db "By choosing boot from CD-ROM,                                     ",13,10
                        db "You accept the lincense conditions mentioned in license.txt.      ",0


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
menu2_image             db "   Boot with default values               " ; 1
                        db "   Boot with menu for own values          " ; 2
                        db "   Display online documentation           " ; 3

exe_menu2:
                        dw continue_boot_default        ; 1
                        dw continue_boot_advanced       ; 2
                        dw load_readme_txt              ; 3

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
