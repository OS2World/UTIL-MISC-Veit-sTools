Title   Notify/prompt drive access

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

swap_bay_prompt                 db false
last_accessed_drive             db 'S' ; A=A: B=B: H=hard disk M=memdisk S=source

message_swap_drive_insert               db msg_swap_drive_insert,0
message_swap_drive_additional_floppy    db msg_swap_drive_additional_floppy,0
message_swap_drive_main_bootdisk        db msg_swap_drive_main_bootdisk,0
message_swap_drive_harddisk             db msg_swap_drive_harddisk,0
message_swap_drive_press_key            db msg_swap_drive_press_key,0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; al
a_proc          notify_drive_access
                pusha

                  ; can not (physically) remove memdisk, no need to prompt/complicate
                  cmp al,'M'
                  je exit_notify_drive_access

                  ; no change?
                  cmp al,cs:[last_accessed_drive]
                  je exit_notify_drive_access

                  ; get current/next physical drive
                  push ax
                    mov al,cs:[last_accessed_drive]
                    call logical_to_physical_drive_number
                    mov dh,dl
                  pop ax
                  call logical_to_physical_drive_number

                  mov cs:[last_accessed_drive],al

                  ; switch to same physical drive?
                  cmp dh,dl
                  je force_prompt_swap_media

                  cmp cs:[swap_bay_prompt],true
                  jne exit_notify_drive_access

  force_prompt_swap_media:
                  call key_box_init
                  mov si,Offset message_swap_drive_insert
                  call StrCat_messagestring

                  ; al='A'/'B'
                  mov si,Offset message_swap_drive_additional_floppy
                  cmp al,'H'
                  if_e <mov si,Offset message_swap_drive_harddisk>
                  cmp al,'S'
                  if_e <mov si,Offset message_swap_drive_main_bootdisk>
                  call StrCat_messagestring

                  mov si,Offset message_swap_drive_press_key
                  call StrCat_messagestring

                  mov key_box_menu.mn_waittime,5*60 ; 5 minutes
                  call key_box

  exit_notify_drive_access:
                popa
                ret
a_endp          notify_drive_access

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ;   al='A'/'B'/'S'/'H'(/'M')
                ;-> dl=00 /01 /?? /80 (/'M')
a_proc          logical_to_physical_drive_number
                mov dl,al                       ; M
               ;cmp al,'M'
               ;je exit_logical_to_physical_drive_number
                sub dl,'A'                      ; A/B
                cmp al,'B'
                jbe exit_logical_to_physical_drive_number
                mov dl,cs:boot_drive            ; S
                cmp al,'S'
                je exit_logical_to_physical_drive_number
                mov dl,080h                     ; H
  exit_logical_to_physical_drive_number:
                ret
a_endp          logical_to_physical_drive_number
