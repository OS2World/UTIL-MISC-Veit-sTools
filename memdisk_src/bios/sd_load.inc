Title   Load screwdrever module to <640 KB

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF language_de
msg_screwdrv db 'ScrewDrv 8086 Debugger installieren (j/n) ? ',0
ELSE
msg_screwdrv db 'Install ScrewDrv 8086 Debugger (y/n) ? ',0
ENDIF

a_proc  load_ScrewDrv
        push ds
        push es
        pushad
          push cs
          pop ds

  ask_load_ScrewDrv:
          mov si,Offset msg_screwdrv
          call ausschrift
          call tastendruck_lowercase
          call ausschrift_zeichen_CRLF
          cmp al,'y'
          je do_load_ScrewDrv
          cmp al,'z'
          je do_load_ScrewDrv
          cmp al,'j'
          je do_load_ScrewDrv

          cmp al,'n'
          je exit_load_ScrewDrv

          jmp ask_load_ScrewDrv

  do_load_ScrewDrv:
          mov si,Offset screwdrv_rom
          mov ah,0
          mov al,byte ptr ds:[si+2]
          ; 512->4 (dword)
          mov cx,ax
          shl cx,7
          ; 512->1024 (KB)
          inc ax
          shr ax,1
          push bios0040
          pop es
          sub word ptr es:[number_of_KB],ax
          mov ax,es:[number_of_KB]
          shl ax,6 ; KB-> xxxx:0
          mov es,ax
          sub di,di
          cld
          rep movsd

          push es
          pop ds

          push cs
          push offset continue_sd_load
          push es
          push 3
          retf

  continue_sd_load:

  exit_load_ScrewDrv:

        popad
        pop es
        pop ds
        ret
a_endp  load_ScrewDrv

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
