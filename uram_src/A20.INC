Title           A20 address switch

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
org_a20         db ?
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                .286p

                ; dl=0:disabled dl=1:enabled
a_proc          query_a20
                pushf
                push ax
                push cx
                push si
                push ds
                push es

                  mov dl,1              ; enabled

                  sub si,si
                  push si               ; 0:0
                  pop ds
                  push 0ffffh           ; ffff:10
                  pop es

                  mov ax,Word Ptr ds:[si+00000h]
                  mov cx,Word Ptr es:[si+00010h]
                  cmp ax,cx
                  jne a20_compare_exit

                  not Word Ptr ds:[si+00000h]
                  not cx
                  cmp cx,Word Ptr es:[si+00010h]
                  mov Word Ptr ds:[si+00000h],ax
                  jne a20_compare_exit

                  mov dl,0              ; disabled
  a20_compare_exit:

                pop es
                pop ds
                pop si
                pop cx
                pop ax
                popf
                ret
a_endp          query_a20

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          save_and_enable_a20
                push dx
                  call query_a20
                  push dx
                    mov cs:org_a20,1
                    call restore_A20
                  pop dx
                  mov cs:org_a20,dl
                pop dx
                ret
a_endp          save_and_enable_a20

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          restore_A20
                pushf
                pusha
                  call query_a20
                  cmp cs:[org_a20],dl
                  je exit__restore_A20

                  mov dl,cs:[org_a20]
                  call set_a20_xms
                  call query_a20
                  cmp cs:[org_a20],dl
                  je exit__restore_A20


                  mov ah,024h
                  mov al,cs:[org_a20]
                  stc
                  int 015h
                  jc int_15_240x_not_supported
                  cmp ah,0
                  jne int_15_240x_not_supported

                  call query_a20
                  cmp cs:[org_a20],dl
                  je exit__restore_A20

  int_15_240x_not_supported:

                  ; PS/2 A20 control
                  in al,092h
                  call small_delay
                  and al,(not 2)
                  cmp cs:[org_a20],1
                  if_e <or al,2>
                  out 092h,al
                  call small_delay

                  call query_a20
                  cmp cs:[org_a20],dl
                  je exit__restore_A20

                  ; Keyboard controller
                  mov ah,0ddh                   ; off
                  cmp cs:[org_a20],1
                  if_e <or ah,0dfh>             ; on
                  call wait_64
                  jnz fail__restore_A20

                  mov al,0D1h                   ; send command to the 804x
                  out 64h,al
                  call wait_64
                  jnz fail__restore_A20

                  mov al,ah
                  out 60h,al
                  call wait_64

                  mov al,0FFh
                  out 64h,al
                  call wait_64
                  jmp exit__restore_A20

  fail__restore_A20:
                  ausschrift <text_failed_to_restore_a20>

  exit__restore_A20:

                popa
                popf
                ret
a_endp          restore_A20

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          wait_64
                pusha
                  call small_delay
                  sub cx,cx

  loop_wait_ready:
                  ;schritt '*'
                  in al,064h
                  call small_delay
                  and al,002h                   ; input buffer full ?
                  loopne loop_wait_ready

                popa
                ret
a_endp          wait_64

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          small_delay
                push dx
                  mov dx,50
  loop_delay:
                  out 0edh,al
                  dec dx
                  jnz loop_delay
                pop dx
                ret
a_endp          small_delay

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

