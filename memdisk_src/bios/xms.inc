Title           Allocate Memory using DOS XMS 2.x interface

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          allocate_xms_memory
                pushad

                  mov ax,04300h
                  int 02fh
                  cmp al,080h
                  je xms_vorhanden

                  fehler_halt msg_No_XMS_2_driver

  xms_vorhanden:
                  push es
                    mov ax,04310h
                    int 02fh
                    mov cs:[xmm]._OFF,bx
                    mov cs:[xmm]._SEG,es
                  pop es

                  ; assume 12 MB memory available

                  ; "Query free extended memory"
                  mov ah,088h                   ; 3.0
                  call [xmm]
                  cmp bl,0
                  je frage_xms30_erfolg

                  mov ah,008h
                  mov bl,0
                  call [xmm]
                  cmp bl,0
                  jne xms_anforderung_fehlgeschlagen

                  movzx eax,ax
  frage_xms30_erfolg:
                  shl eax,10

                  add eax,cfg_record.cfg_os2_min_memory
                  call create_memdisk_geometry

                  ; "Allocate extended memory block"
                  mov ah,089h                   ; 3.0
                  mov edx,cs:MemDiskBIOS_Info._anzahl_sektoren
                  shr edx,1 ; sector->KiB
                  adc edx,0
                  call [xmm]
                  cmp ax,1
                  je xms_erfolgreich_angefordert

                  mov ah,009h
                  mov edx,cs:MemDiskBIOS_Info._anzahl_sektoren
                  shr edx,1 ; sector->KiB
                  adc edx,0
                  call [xmm]
                  cmp ax,1
                  je xms_erfolgreich_angefordert

  xms_anforderung_fehlgeschlagen:
                  fehler_halt msg_Error_allocating_XMS_memory

  xms_erfolgreich_angefordert:
                  ; dx=handhabe
                  mov xms_handle,dx

                  ; "Lock extended memory block"
                  mov ah,00ch
                  ;mov dx,dx
                  call [xmm]
                  cmp ax,1
                  je xms_physikalische_adresse_bestimmt

                  fehler_halt msg_Error_determining_physical_address

  xms_physikalische_adresse_bestimmt:
                  ; dx:bx
                  push dx
                  push bx
                  pop dword ptr MemDiskBIOS_Info._phys_addr

                  call display_used_memory

                popad
                ret
a_endp          allocate_xms_memory

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
