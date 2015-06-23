Title           palette (RGB) functions

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; eax=CcRrGgBb
a_proc          set_rgb_palette_colour
                cmp cs:[cfg_record.cfg_modify_rgb_palette],true
                jne exit_set_rgb_palette_colour
                mov cx,ax ; G/B
                shr eax,16
                mov dh,al ; R
                movzx bx,ah ; I
                mov ax,01010h
                call int_10h
  exit_set_rgb_palette_colour:
                ret
a_endp          set_rgb_palette_colour

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; 00..ff 3f
;     33 0c
;     aa 2a
;     ff 3f

a_proc          modify_palette
                pushad

                  ;         0/R/G/B
                  mov eax,00000000cH ;   0/  0/ 51
                  call set_rgb_palette_colour
                  ;         7/R/G/B
                  mov eax,0073f3f2aH ; 255/255/170
                  call set_rgb_palette_colour

                popad
                ret
a_endp          modify_palette

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          restore_palette
                pushad

                  ;         0/R/G/B
                  mov eax,000000000H
                  call set_rgb_palette_colour
                  ;         7/R/G/B
                  mov eax,0072a2a2aH
                  call set_rgb_palette_colour

                popad
                ret
a_endp          restore_palette

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

