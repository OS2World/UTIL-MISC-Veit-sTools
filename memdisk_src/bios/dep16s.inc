Title           aPack safe header handling

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

aPack_tag_expected      equ '23PA'

aPack_header    Struc
  aPack_tag     dd ?    ; 'AP32'
  header_size   dd ?
  packed_size   dd ?
  packed_crc    dd ?
  orig_size     dd ?
  orig_crc      dd ?
aPack_header    EndS

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; DS:SI=pack header
                ; ES:DI=target
                ; -> eax unpacked len
                ; -> ebx packed len
a_proc          aPsafe_depack_16
                push ecx

                  cmp [si].aPack_header.aPack_tag,aPack_tag_expected
                  if_ne <trap msg_invalid_packed_data_header>

                  mov ebx,[si].aPack_header.header_size
                  mov ecx,[si].aPack_header.packed_size
                  add si,bx
                  push es
                    push ds
                    pop es
                    call calculate_crc32
                  pop es
                  sub si,bx

                  cmp eax,[si].aPack_header.packed_crc
                  if_ne <trap msg_packed_data_CRC_failed>

                  add si,bx
                  call aP_depack16_asm
                  sub si,bx
                  movzx eax,ax
                  cmp eax,[si].aPack_header.orig_size
                  if_ne <trap msg_unpacking_data_failed>

                  add ebx,ecx                   ; sub of header and packed data

                  mov cx,ax
                  push eax
                    push si
                      mov si,di
                     ;mov es,es
                      call calculate_crc32
                    pop si
                    cmp eax,[si].aPack_header.orig_crc
                    if_ne <trap msg_unpacked_data_CRC_failed>
                  pop eax

                pop ecx
                ret
a_endp          aPsafe_depack_16

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
