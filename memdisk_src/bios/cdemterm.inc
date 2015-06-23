Title           Terminate CD boot emulation

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;IFDEF bios

IFNDEF cdloader

meldung_cdrom_emu_succ  db msg_CD_ROM_emulation_terminated,13,10,0
meldung_cdrom_emu_err   db msg_CD_ROM_emulation_did_not_terminate,' (',0

ENDIF ; -cdloader


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          clear_specification_packet
                push es
                pusha
                  push cs
                  pop es
                  mov di,Offset specification_packet
                  mov cx,Size cdrom_specification_packet
                  mov al,cl
                  cld
                  stosb
                  dec cx
                  mov al,0
                  rep stosb
                popa
                pop es
                ret
a_endp          clear_specification_packet

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; ZF<>0,"Fehler" bei SystemSoft/2.88 /$00
                ; "Typ 0"  bei SystemSoft/Noemu/$90
a_proc          query_cd_emulation_type
                push fs
                pusha

                  mov dl,[boot_drive]

                  mov ah,0                      ; reset - clear error code
                 ;mov dl,dl
                  push dx
                    int 013h
                  pop dx

                  call clear_specification_packet
                  mov ax,04b01h                 ; get status
                 ;mov dl,dl
                  mov si,Offset specification_packet
                  int 013h
                  test ah,ah

                popa
                pop fs
                ret
a_endp          query_cd_emulation_type

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFNDEF cdloader

a_proc          terminate_cdrom_emulation
                push ds
                push fs
                pusha

IFNDEF os2boot_ac_code
                  call uninstall_irq_filters
ENDIF ; os2boot_ac_code

                  call clear_specification_packet
                  mov ax,04b00H     ; CD-ROM: terminate disk emulation
                  mov dl,[boot_drive]
                  mov si,Offset specification_packet
                  push cs           ; DS:SI=specification packet
                  pop ds
                  push dx
                  int 013h
                  pop dx
                  test ah,ah
                  jz success_terminate_cdrom_emulation

                  call clear_specification_packet
                  mov ax,04b00H     ; CD-ROM: terminate disk emulation
                  mov dl,07fH       ; alle Laufwerke
                  mov si,Offset specification_packet
                  push cs           ; DS:SI=specification packet
                  pop ds
                  int 013h
                  test ah,ah
                  jz success_terminate_cdrom_emulation

                  cmp source_is_noemulation_mode_cd,true
                  je exit_terminate_cdrom_emulation

                  ; floppy boot ?
                  call query_cd_emulation_type
                  jnz exit_terminate_cdrom_emulation     ; yes-no emu. no error messages

                  test specification_packet.cdrom_boot_media_type,00fh
                  jz exit_terminate_cdrom_emulation

                  ; else print error message

                  mov bl,error_TextAttr
                  xchg cs:[TextAttr],bl

                  mov si,Offset meldung_cdrom_emu_err
                  call ausschrift
                  call ausschrift_ax_hex
                  mov al,')'
                  call ausschrift_zeichen
                  mov cs:[TextAttr],bl

                  call ausschrift_zeichen_CRLF

                  jmp exit_terminate_cdrom_emulation

  success_terminate_cdrom_emulation:
                  mov si,Offset meldung_cdrom_emu_succ
                  call ausschrift

  exit_terminate_cdrom_emulation:

IFDEF os2boot_ac_code
                  mov el_torito_abschalten,false
ELSE
                  mov cfg_record.cfg_el_torito_abschalten,false
ENDIF


IFNDEF os2boot_ac_code
                  call install_irq_filters
ENDIF ; os2boot_ac_code


                popa
                pop fs
                pop ds
                ret
a_endp          terminate_cdrom_emulation

ENDIF ; -cdloader

;ENDIF           ; bios

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

