title   detect primary video chip pci identification

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

pci_video_1     dw -1   ; any "Display", even inactive
pci_video_2     dw -1   ; any "Display", active
pci_video_3     dw -1   ; VGA,8514,XGA "Display", active

p8str name_OS2CSM_VIDEO_VENDOR   'OS2CSM_VIDEO_VENDOR'
p8str name_OS2CSM_VIDEO_DEVICEID 'OS2CSM_VIDEO_DEVICEID'

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; called by hab/nic detection for each device
                ;
                ; ecx=device    shl 16+vendor
                ; edx=subdevice shl 16+subvendor
                ; bx=pci address
a_proc          detect_video
                pushad

                  ; check 1: classcode 3 (Display)
                  ; class_:$03;subclass:$00;progif:$00;cname:'VGA'
                  ; class_:$03;subclass:$00;progif:$01;cname:'VGA+8514'
                  ; class_:$03;subclass:$01;progif:$00;cname:'XGA'
                  ; class_:$03;subclass:$02;progif:$00;cname:'3D'
                  ; class_:$03;subclass:$80;progif:$00;cname:'Other'

                  mov di,00bh ; class code
                  call read_pci_byte
                  cmp cl,3
                  jne detect_video_exit

                  mov di,Offset pci_video_1
                  call assign_first_video

                  ; active=address and/or memory enabled?
                  ; could also check other command bits
                  mov di,004h ; command register
                  ;! 0      I/O access enabled
                  ;! 1      memory access enabled
                  ;? 5      VGA palette snoop enabled
                  call read_pci_byte
                  and cl,1+2
                  jz detect_video_exit

                  mov di,Offset pci_video_2
                  call assign_first_video

                  ; VGA/8514/XGA?
                  mov di,00ah ; subclass
                  call read_pci_byte
                  cmp cl,1
                  jnbe detect_video_exit

                  mov di,Offset pci_video_3
                  call assign_first_video

  detect_video_exit:

                popad
                ret
a_endp          detect_video

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; ds:di
a_proc          assign_first_video
                cmp Word Ptr [di],-1
                if_e <mov Word Ptr [di],bx>
                ret
a_endp          assign_first_video

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          summary_detect_video
                pushad

                  or ecx,-1

                  mov bx,pci_video_3
                  cmp bx,cx
                  jne before_read_summary_detect_video

                  mov bx,pci_video_2
                  cmp bx,cx
                  jne before_read_summary_detect_video

                  mov bx,pci_video_1
                  cmp bx,cx
                  je after_read_summary_detect_video

  before_read_summary_detect_video:

                  ; read vendor/device
                  sub di,di ; vendor/device register
                  call read_pci_dword

  after_read_summary_detect_video:

                  ; si=string
                  mov si,Offset zeichenketten_zwischenspeicher
                  call Int2Hex_cx
                  ; bx=variable name
                  mov bx,Offset name_OS2CSM_VIDEO_VENDOR
                  call store_string_to_anything_varname

                  shr ecx,16

                  ; si=string
                  mov si,Offset zeichenketten_zwischenspeicher
                  call Int2Hex_cx
                  ; bx=variable name
                  mov bx,Offset name_OS2CSM_VIDEO_DEVICEID
                  call store_string_to_anything_varname

                popad
                ret
a_endp          summary_detect_video

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; cx=value
                ; si=target buffer
a_proc          Int2Hex_cx
                pusha

                  mov dx,4                      ; 16/4=4
                  mov Byte Ptr [si],dl

  loop_Int2Hex_cx:
                  inc si
                  rol cx,4
                  mov al,cl
                  and al,00fh
                  cmp al,10
                  sbb al,69h
                  das
                  mov [si],al
                  dec dx
                  jnz loop_Int2Hex_cx

                popa
                ret
a_endp          Int2Hex_cx

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
