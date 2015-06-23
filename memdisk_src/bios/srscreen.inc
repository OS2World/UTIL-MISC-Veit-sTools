Title   Save and Restore screen image+cursor

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

screen_save     Struc
  org_attr      db ?
  org_cursor_xy dw ?
  org_cursor_f  dw ?
  org_cells     ptr1616 <?,?>
screen_save     EndS

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

                ; ds:di
a_proc          save_screen
                push es
                pushad

                  ; save attribute,cursor

                  mov al,TextAttr
                  mov [si].org_attr,al
                  call WhereXY
                  mov [si].org_cursor_xy,ax
                  call GetCursorShape
                  mov [si].org_cursor_f,cx

                  ; save cells

                  call WindMax
                  add ax,00101h
                  mul ah
                  shl ax,1
                  movzx eax,ax
                  push si
                    add si,Offset screen_save.org_cells
                    call getmem
                  pop si

IFDEF graph
                  les di,[si].screen_save.org_cells
                  null dx
                  call WindMax
                  mov bx,ax
  read_screen_loop:
                  call GotoXY_crt
                  call ReadCharAttr
                  cld
                  stosw
                  inc dl
                  cmp dl,bl ; max x
                  jbe read_screen_loop
                  mov dl,0
                  inc dh
                  cmp dh,bl ; max y
                  jbe read_screen_loop
ELSE ; -graph
                  mov cx,ax     ; size in byte
                  shr cx,2      ; size in dword
                  les di,DWord Ptr [si].screen_save.org_cells
                  push si
                  push ds
                    ; text mode memory at b800:0
                    push bios0040
                    pop ds
                    mov al,Byte Ptr ds:[current_video_mode]
                    and al,07fh
                    cmp al,007h
                    setne al
                    shl ax,11           ; 0000/0800
                    add ax,biosb000     ; b000/b800
                    mov ds,ax
                    null si
                    cld
                    rep movsd
                  pop ds
                  pop si
ENDIF ; graph

                popad
                pop es
                ret
a_endp          save_screen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          restore_screen
                push es
                pusha

                  ; restore window

                  les bp,DWord Ptr [si].org_cells
                  call WindMax
                  mov bx,ax
                  movzx cx,al
                  inc cx
                  null dx
  restore_screen_loop_goto:
                  call WriteColourString
                  add bp,cx
                  add bp,cx
                  inc dh
                  cmp dh,bh ; max y
                  jbe restore_screen_loop_goto


                  ; restore cursor and attribute

                  mov al,[si].org_attr
                  mov TextAttr,al
                  mov dx,[si].org_cursor_xy
                  call GotoXY
                  mov cx,[si].org_cursor_f
                  call SetCursorShape


                  ; free used memory

                  push si
                    add si,Offset screen_save.org_cells
                    call freemem
                  pop si

                popa
                pop es
                ret
a_endp          restore_screen

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
