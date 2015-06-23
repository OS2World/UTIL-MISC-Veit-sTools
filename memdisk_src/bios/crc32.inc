Title           CRC32 code

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

crc32table      dd 0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          init_crc32
                push es
                pushad

                  cmp crc32table,0
                  jne init_crc32_exit

                  mov eax,256*4
                  mov si,Offset crc32table
                  call getmem

                  les di,crc32table

                  cld
                  sub edx,edx

  create_crc32_table_sl2: ; every byte
                  mov eax,edx
                  mov cx,8

  create_crc32_table_sl1: ; every 8 Bit
                  shr eax,1
                  if_c <xor eax,0EDB88320h>
                  loop create_crc32_table_sl1

                  stosd
                  inc dx
                  cmp dx,0100h
                  jne create_crc32_table_sl2

  init_crc32_exit:

                popad
                pop es
                ret
a_endp          init_crc32


;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

a_proc          free_crc32
                push si

                  mov si,Offset crc32table
                  call freemem

                pop si
                ret
a_endp          free_crc32

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                ; es:si,cx
                ; -> eax
a_proc          calculate_crc32
                push fs
                push ebx
                push edi
                push si
                push cx

                  cld
                  sub ebx,ebx
                  or eax,-1
IFDEF ScrewDrv
                  cmp cs:crc32table,0
                  if_e <trap 'crc32table=nil'>
ENDIF ; ScrewDrv
                  lfs di,cs:crc32table
                  movzx edi,di
                  jcxz calculate_crc32_done
  calculate_crc32_loop:
                  mov bl,al
                  lods byte ptr es:[si]
                  xor bl,al
                  shr eax,8
                  xor eax,fs:[edi+ebx*4]
                  loop calculate_crc32_loop

  calculate_crc32_done:
                  not eax

                pop cx
                pop si
                pop edi
                pop ebx
                pop fs
                ret
a_endp          calculate_crc32

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
