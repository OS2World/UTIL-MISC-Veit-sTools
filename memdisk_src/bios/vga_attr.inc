Title   colour constants

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; escape numbers
string_end              =  0
muliple                 =  1
colour                  =  2
cls                     =  3
goto_xy                 =  4
keypress                =  5
string_ClrEol           =  6
string_beep             =  7
string_back             =  8
                        ;  9
                        ; 10
                        IFNDEF cdloader
string_numlongint       = 11
string_string           = 12
                        ENDIF ; - cdloader
                        ; 13


; color shift factors
foreground=001h
background=010h

; colour names
Black         = 0
Blue          = 1
Green         = 2
Cyan          = 3
Red           = 4
Magenta       = 5
Brown         = 6
Lightgray     = 7
Darkgray      = 8
Lightblue     = 9
Lightgreen    =10
Lightcyan     =11
Lightred      =12
Lightmagenta  =13
Yellow        =14
White         =15

COMMENT $ "Borland like...
default_TextAttr        = Lightgray  * foreground + Blue    * background
key_TextAttr            = Yellow     * foreground + Blue    * background
error_TextAttr          = Lightred   * foreground + Blue    * background
step_TextAttr           = Lightcyan  * foreground + Green   * background
MenuAttrFrame           = Lightgray  * foreground + White   * background
MenuAttrSelection       = Darkgray   * foreground + Yellow  * background
 $

COMMENT $ "Compromise .." $
default_TextAttr        = Lightgray  * foreground + Black   * background
key_TextAttr            = Yellow     * foreground + Black   * background
error_TextAttr          = Lightred   * foreground + Black   * background
step_TextAttr           = Lightcyan  * foreground + Green   * background
;MenuAttrFrame           = Lightgray  * foreground + Black   * background
;MenuAttrSelection       = Darkgray   * foreground + White   * background
MenuAttrFrame           = Darkgray   * foreground + White   * background
MenuAttrSelection       = Lightgray  * foreground + Black   * background


setdefaultcolour        equ <colour,default_TextAttr>
seterrorcolour          equ <colour,error_TextAttr>
setkeycolour            equ <colour,key_TextAttr>

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
