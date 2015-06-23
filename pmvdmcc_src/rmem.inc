Title   Access real mode memory addresses

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; dx:si,cx(1,2,4) -> al/ax/eax

a_proc                  read_real_mode_memory_address
                        push ds
IFDEF OS2
                        push si
ENDIF

IFDEF OS2
                        push eax
                        push ebx
                        push edx

                          movzx eax,dx
                          movzx ebx,si
                          shl eax,4
                          add eax,ebx
                          mov ebx,eax
                          shr eax,16
                         ;mov ax,ax             ; ax:bx
                         ;mov bx,bx
                         ;mov cx,cx             ; length
                          mov dh,0              ; -> ds:si
                          mov dl,DevHlp_PhysToVirt
                          call DeviceHelp
                          ; no error check here, should not fail..
                        pop edx
                        pop ebx
                        pop eax
ELSE ; DOS
                        mov ds,dx
ENDIF ; DOS
                        cmp cx,2
                        je @@read_word
                        ja @@read_dword
                        mov al,Byte Ptr ds:[si]
                        jmp @@continue
  @@read_word:
                        mov ax,Word Ptr ds:[si]
                        jmp @@continue
  @@read_dword:
                        mov eax,DWord Ptr ds:[si]
                       ;jmp @@continue
  @@continue:
IFDEF OS2
                        pop si
ENDIF ; OS2
                        pop ds
                        ret
a_endp                  read_real_mode_memory_address

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

