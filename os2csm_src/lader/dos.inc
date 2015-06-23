Title   Adjust for running as a DOS .COM program

;***************************************************************************
; Anpassungen zum Lauf als DOS-Programm
;***************************************************************************
platz_fuer_ax:          dw ?

a_proc                  pruefe_ob_DOS_Programm
                        push ax
                          call pop_ax
  pop_ax:
                          pop ax
                          sub ax,Offset pop_ax
                        pop ax
                        jz DOS_laeuft_nicht

                        mov ax,cs
                        add ax,00010h
                        push ax
                        push Offset weiter_dos_ip_richtig
                        retf
  weiter_dos_ip_richtig:

                        ; Stack auf Ende des Segmentes setzen setzen
                        mov ax,cs
                        cli
                        mov ss,ax
                        mov sp,0fffeh
                        sti

                        mov cs:[dos_modus],1

                        mov ax,06601h ; get code page bx/dx
                        int 021h
                        mov cs:[org_codepage],bx
                        mov ax,06602h ; set code page bx/dx
                        mov bx,437
                        int 021h

                        mov ax,04010h
                        int 02fh
                        cmp ax,04010h
                        je os2_laeuftnicht

                        mov cs:[os2_laeuft],1
  os2_laeuftnicht:
  DOS_laeuft_nicht:
                        jmp weiter_nach_dos_test
a_endp                  pruefe_ob_DOS_Programm

;***************************************************************************
org_codepage            dw ?

a_proc                  dos_config_sys_laden

                        mov ax,06601h ; get code page bx/dx
                        int 021h
                        mov bx,[org_codepage]
                        mov ax,06602h ; set code page bx/dx
                        mov bx,437
                        int 021h

                        cmp [abbruch],1
                        je dos_ende

ifndef memdisk
                        ; Deinstallation unschÑdlich machen (ret)
                        mov byte ptr [int10und13_entfernen],0c3h
endif ; -memdisk

                        ; Quelle ôffnen
                        mov ax,03d00h
                        mov dx,Offset dateiname_config_sys
                        int 021h
                        jc dos_ende
                        mov [handhabe_sys],ax

                        ; Quellgrî·e bestimmen
                        mov ax,04202h ; Dateiende
                        mov bx,[handhabe_sys]
                        null cx
                        null dx
                        int 021h

                        push dx
                        push ax
                        pop eax

                        test eax,eax            ; zu klein ?
                        jz dos_ende
                        cmp ax,0f000h           ; sinnvolle Grenze bei etwa 60KB ?
                        ja dos_ende

                        mov config_sys_groesse,ax

                       ;mov eax,eax
                        mov si,Offset config_sys_speicher1
                        call getmem
                       ;mov eax,eax
                        mov si,Offset config_sys_speicher2
                        call getmem


                        ; zurÅck zum Dateianfang
                        mov ax,04200h
                        mov bx,[handhabe_sys]
                        null cx
                        null dx
                        int 021h

                        ; Datei lesen
                        push ds
                          mov ah,03fh
                          mov bx,[handhabe_sys]
                          mov cx,[config_sys_groesse]
                          lds dx,config_sys_speicher1
                          int 021h
                        pop ds
                        jc dos_ende

                        ; Quelle Schlie·en
                        mov ah,03eh
                        mov bx,[handhabe_sys]
                        int 021h


                        ; config.sys bearbeiten
                        mov eax,[config_sys_speicher1]
                        mov [mod_quellsektor_ptr],eax
                        add ax,[config_sys_groesse]
                        mov [mod_quellsektor_ende],ax
                        mov eax,[config_sys_speicher2]
                        mov [mod_zielsektor_ptr],eax
                        call bearbeite_speicher_sektor


                        ; Ziel erzeugen
                        mov ah,03ch
                        null cx
                        mov dx,Offset dateiname_config____
                        int 021h
                        jc dos_ende
                        mov [handhabe____],ax

                        ; Ergebnis schreiben
                        push ds
                          mov ah,040h
                          mov bx,[handhabe____]
ifdef memdisk
                          mov cx,mod_zielsektor_ende
                          sub cx,mod_zielsektor_ptr._OFF
else
                          mov cx,[config_sys_groesse]
endif
                          lds dx,[config_sys_speicher2]
                          int 021h
                        pop ds
                        jc dos_ende

                        ; Ziel Schlie·en
                        mov ah,03eh
                        mov bx,[handhabe____]
                        int 021h

                        ; kein Fehler
                        mov al,000
  dos_ende:
                        ; Speicher freigeben
                        mov si,Offset config_sys_speicher1
                        cmp [si]._SEG,0
                        if_ne <call freemem>

                        mov si,Offset config_sys_speicher2
                        cmp [si]._SEG,0
                        if_ne <call freemem>

                        mov ah,04ch
                        int 021h
a_endp                  dos_config_sys_laden

;***************************************************************************

dateiname_config_sys:   db 'CONFIG.SYS',0
dateiname_config____:   db 'CONFIG.___',0

handhabe_sys            dw -1
handhabe____            dw -1

config_sys_speicher1    ptr1616 <0,0>
config_sys_speicher2    ptr1616 <0,0>

config_sys_groesse      dw ?

os2_laeuft              db 0
;***************************************************************************
; bestimme ob OS/2 VMB lÑuft
;***************************************************************************

a_proc                  pruefe_os2_vmb
                        push2 ds,si
                          push 0
                          pop ds
                          lds si,ds:[4*6]               ; Int 6
                          cmp byte ptr [si],063h        ; ARPL...
                        pop2 si,ds
                        jne nicht_os2_vmb
                        mov [os2_laeuft],1
  nicht_os2_vmb:
                        ret
a_endp                  pruefe_os2_vmb

;***************************************************************************

