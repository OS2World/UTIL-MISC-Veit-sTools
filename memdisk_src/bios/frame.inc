Title   paint frame around menu boxes

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; codepage 437/850/.. has frame chars
; for others, add ifdefs for ' +---+ ' like frames

frame_line_o    db " �",muliple
  frame_line_op db 70
                db "�","� ",0

frame_line_m    db " �",muliple
  frame_line_mp db 70
                db " ","� ",0

frame_line_u    db " �",muliple
  frame_line_up db 70
                db "�","� ",0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; dx=y0/x0 cx=ysize/xsize (inside)
a_proc          zeichne_rahmen_attr
                pusha

                  mov frame_line_op,cl
                  mov frame_line_mp,cl
                  mov frame_line_up,cl
                  sub dx,00102h
                  shr cx,8

                  call GotoXY
                  mov si,Offset frame_line_o
                  call ausschrift

                  mov si,Offset frame_line_m
  zeichne_rahmen_mitte:
                  inc dh
                  call GotoXY
                  call ausschrift
                  loop zeichne_rahmen_mitte

                  inc dh
                  call GotoXY
                  mov si,Offset frame_line_u
                  call ausschrift

                popa
                ret
a_endp          zeichne_rahmen_attr

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          zeichne_rahmen
                push bx
                  mov bl,MenuAttrFrame
                  xchg TextAttr,bl
                  call zeichne_rahmen_attr
                  mov TextAttr,bl
                pop bx
                ret
a_endp          zeichne_rahmen

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
