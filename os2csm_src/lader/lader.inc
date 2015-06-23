Title   binary module that acts as an OS2LDR file

                        locals @@

; OS2BOOT-OS2LDR-ZwischenstÅck
; Veit Kannegieser 2001.02.22
;********************************************************************

code                    segment 'code' use16
                        assume cs:code
                        assume ds:code
.386p

                        org 0
                        jmp anfang

                        include ..\..\memdisk\bios\mac.inc
                        include ifs.inc
                        include ..\..\memdisk\bios\typedef.inc
                        include typdef.inc

                        ifdef language_de
                        include csm_de.inc
                        include ..\..\memdisk\bios\lang_de.inc
                        endif
                        ifdef language_en
                        include csm_en.inc
                        include ..\..\memdisk\bios\lang_en.inc
                        endif
                        ifdef language_es
                        include csm_sp.inc
                        include ..\..\memdisk\bios\lang_es.inc
                        endif
                        ifdef language_fr
                        include csm_fr.inc
                        include ..\..\memdisk\bios\lang_fr.inc
                        endif
                        ifdef language_it
                        include csm_it.inc
                        include ..\..\memdisk\bios\lang_it.inc
                        endif
                        ifdef language_jp
                        include csm_jp.inc
                        include ..\..\memdisk\bios\lang_jp.inc
                        endif
                        ifdef language_nl
                        include csm_nl.inc
                        include ..\..\memdisk\bios\lang_nl.inc
                        endif
                        ifdef language_ru
                        include csm_ru.inc
                        include ..\..\memdisk\bios\lang_ru.inc
                        endif

                        db '[OS2CSM]'
                        include datum.inc
                        db 0,26

                        dw 4 ; Versionskennung
                        dw dauervariablen
                        dw anfangsvariablen
ifdef memdisk
                        include ..\..\memdisk\bios\i_csm_md.inc
                        include cfg_logo.inc
                        include cfg_fise.inc
                        include cfg_edit.inc
                          exe_markierung 'Memdisk CONFIG.SYS Editor Konfiguration'
icmd                    table_memdisk_os2csm_interface_Struc <>

endif
                        ; db 8000 dup ('A')

                        ;--------------------------------------------
                        ; dauerhaft benîtigter Programmanteil

                        include resident.inc
                        exe_markierung 'Dauerhafter Programmanteil'
                        ;--------------------------------------------

ende_tsr:

                        ;--------------------------------------------
                        ; nur am Anfang benutzter Programmanteil
;********************************************************************
; Aufruf des MenÅanteils, Laden von OS2LDR
;********************************************************************
lader_ausschrift_abgeschaltet db 0

anfang:
                        ; Platz fÅr ein I N T 3
                        nop
                        jmp pruefe_ob_DOS_Programm
  weiter_nach_dos_test:

                        ; MenÅ darstellen und Filter einhÑngen
                        call os2csm_menue

ifdef memdisk
                        retf
else ; -memdisk

                        push ax
                          call ermittle_ausschrift_abgeschaltet
                          mov cs:[lader_ausschrift_abgeschaltet],al
                        pop ax

                        ; Speicher auf den Stapel fÅr die Kopie des
                        ; kritischen Programmteiles
                        sub sp,ifs_os2ldr_lader_laenge

                        ; RÅcksprung zu OS2LDR vorbereiten
                        push cs ; push word ptr es:[di+ft_ldrseg]
                        push 0

                        ; micro-HPFS verÑndert den Laufwerksbuchstaben
                        push word ptr [si+024h-(3+8)]

                        ; Registerinhalt fÅr OS2LDR merken
                        pusha
                          mov bp,sp
                          add bp,4+2+8*2 ; RÅckkehr+pop_laufwerk+popa

                          mov si,Offset lader_text_lade_os2ldr
                          call lader_ausschrift_p8_abschaltbar

                          ; FAT oder HPFS,... ?
                          test dh,010h ; Bit 4
                          jnz micro_ifs_vorhanden


                          ;**************************************
                          ;--------------------------------------
                          ; FAT:
                          ; OS2LDR.BIN soll geladen werden
                          ; 1. Suchen von "OS2LDR  ""   "
                          push es
                            push ds
                            pop es
                            sub di,di
                            mov cx,2000
                            mov al,'O'
                            cld
  sl1:
                            repne scasb
                            or cx,cx
                            jnz pruefe_sl1

                            mov si,Offset lader_text_os2boot1
                            jmp lader_fehler_halt
  pruefe_sl1:
                            cmp dword ptr es:[di],'DL2S'
                            jne sl1
                            cmp word ptr es:[di+4],' R'
                            jne sl1

                            ; gefunden, ".BIN" eintragen
                            push eax
                              mov eax,dword ptr cs:[lader_name_os2ldr_bin_stelle_erweiterung]
                              ; FAT speichert den Punkt nicht:
                              ; Name: 'OS2LDR'+ '.BIN'
                              ; FAT : 'OS2LDR  '+'   '
                              mov al,' '
                              mov dword ptr es:[di-1+7],eax
                            pop eax
                            lea bx,[di-1]

                            ; 2. Suchen von
                            ;  mov cx,8+3
                            ;  mov si,Offset text_os2ldr
                            mov cx,2000
                            sub di,di
                            mov al,0b9h
                            cld
  sl2:
                            repne scasb

                            test cx,cx
                            jnz pruefe_sl2

                            mov si,Offset lader_text_os2boot2
                            jmp lader_fehler_halt
  pruefe_sl2:
                            cmp word ptr es:[di  ],8+3
                            jne sl2
                            cmp byte ptr es:[di+2],0beh
                            jne sl2
                            cmp word ptr es:[di+3],bx
                            jne sl2

                            ; Es soll bei
                            ;   xor bx,bx
                            ;   mov cx,[hauptverzeichniseintraege]
                            ;   mov di,bx
                            ;   mov cx,8+3
                            ; weiter gehen:
                            sub di,1+(00252h-00249h)
                            mov word ptr cs:[weiter_os2boot_fat+0],di
                            mov word ptr cs:[weiter_os2boot_fat+2],es

                            ; 3. Suchen von
                            ;   mov ax,02000    b8 00 20
                            ;   push ax         50
                            ;   xor ax,ax       33 c0
                            ;   push ax         50
                            ;   retf            cb
                            mov cx,2000
                            sub di,di
                            mov al,0b8h
                            cld
  sl3:
                            repne scasb

                            test cx,cx
                            jnz pruefe_sl3

                            mov si,Offset lader_text_os2boot3
                            jmp lader_fehler_halt
  pruefe_sl3:
                            mov si,cs
                            cmp word ptr es:[di  ],si
                            jne sl3
                            cmp dword ptr es:[di+2],050c03350h
                            jne sl3
                            cmp byte ptr es:[di+6],0cbh
                            jne sl3

                            ; gefunden, umwandlen
                            ;   jmp aaaa:bbbb
                            mov byte ptr es:[di-1],0eah
                            ;**lea ax,[bp+weiter_gemeinsam_fat_hpfs-ifs_os2ldr_lader]
                            lea ax,[bp+Offset weiter_gemeinsam_fat_hpfs]
                            sub ax,Offset ifs_os2ldr_lader
                            mov word ptr es:[di  ],ax
                            mov word ptr es:[di+2],ss

                            ; vom kopierten Programmanteil wird
                            ; hauptsÑchlich nur die Anpassung von
                            ; OS2KRNL->OS2KRND benutzt
                            push ds
                              mov si,Offset ifs_os2ldr_lader
                              push cs
                              pop ds
                              mov di,bp
                              push ss
                              pop es
                              mov cx,ifs_os2ldr_lader_laenge
                              cld
                              rep movsb
                            pop ds

                          pop es


                          ; OS2BOOT[FAT] soll jetzt OS2LDR.BIN laden
                          jmp dword ptr cs:[weiter_os2boot_fat]

weiter_os2boot_fat:     dd ?

;********************************************************************
;********************************************************************

ifs_os2ldr_lader_laenge equ (Offset ifs_os2ldr_lader_ende)-(Offset ifs_os2ldr_lader)

micro_ifs_vorhanden:

                          push3 ds,es,di
                            mov si,Offset ifs_os2ldr_lader
                            push cs
                            pop ds
                            mov di,bp
                            push ss
                            pop es
                            mov cx,ifs_os2ldr_lader_laenge
                            cld
                            rep movsb
                          pop3 di,es,ds

                          ; zur Kopie springen
                          push ss
                          push bp
                          retf

ifs_os2ldr_lader:
                          ; ifs_os2ldr_lader ist nicht org 0
                          call lade_berechne_bp_neu

                          ;------------------------------------------
                          ; OS2LDR.BIN îffnen
                          pusha
                            push2 ds,es

                              push es
                              lea ax,[di].ft_ldrlen
                              push ax

                              push cs
                              lea ax,[bp+Offset lader_name_os2ldr_bin]
                              push ax

                              call es:[di].ft_muOpen
                              add sp,4+4

                              lea si,[bp+Offset lader_text_fehler_beim_oeffnen_von_os2ldr_bin]
                              test ax,ax
                              jnz lader_fehler_halt

                            pop2 es,ds
                          popa
                          ;
                          ;------------------------------------------

                          ;------------------------------------------
                          ; OS2LDR.BIN einlesen
                          pusha
                            push2 ds,es

                              push2 es,di

                                push es:[di].ft_ldrlen          ; LÑnge{32}

                                push es:[di].ft_ldrseg          ; Ziel{16:16}
                                push 0



                                push dword ptr 0                  ; Position 0 {32}

                                call es:[di].ft_muRead
                                add sp,4+4+4

                              pop2 di,es

                              ; alles gelesen ?
                              lea si,[bp+Offset lader_text_lesefehler]
                              cmp dx,word ptr es:[di+2].ft_ldrlen
                              jne lader_fehler_halt
                              cmp ax,word ptr es:[di+0].ft_ldrlen
                              jne lader_fehler_halt

                            pop2 es,ds
                          popa
                          ;
                          ;------------------------------------------


                          ;------------------------------------------
                          ; OS2LDR.BIN schlie·en
                          pusha
                            push2 ds,es
                              call es:[di].ft_muClose
                              ;add sp,0
                            pop2 es,ds
                          popa
                          ;
                          ;------------------------------------------


weiter_gemeinsam_fat_hpfs:
                          call lade_berechne_bp_neu
                          lea si,[bp+Offset lader_text_umbruch]
                          call lader_ausschrift_p8_abschaltbar

                        popa

                        ; Laufwerksbuchstabe
                        pop word ptr [si+024h-(3+8)]


                        ;--------------------------------------------
                        ; OS2KRNL->OS2KRND
                        pusha
                          push es

                            call lade_berechne_bp_neu

                            cmp byte ptr cs:[bp+aenderung_os2krnd],0
                            je aendere_zu_os2krnd_ende

                            mov cx,word ptr es:[di].ft_ldrlen
                            mov es,es:[di].ft_ldrseg
                            sub di,di

                            mov al,'O'
  aendere_zu_os2krnd_schleife:
                            repne scasb

                            ; nicht gefunden ?
                            jcxz aendere_zu_os2krnd_ende

                            ; 'OS2KRNL'#0 ?
                            cmp dword ptr es:[di  -1],'K2SO'
                            jne aendere_zu_os2krnd_schleife
                            cmp dword ptr es:[di+4-1], 'LNR'
                            jne aendere_zu_os2krnd_schleife

                            ; gefunden ..
                            mov byte ptr es:[di+5],'D' ; 'L' -> 'D'

  aendere_zu_os2krnd_ende:
                          pop es
                        popa
                        ;
                        ;--------------------------------------------

                        ;--------------------------------------------
                        ; Weiter mit OS2LDR.BIN
                        ;retf ifs_os2ldr_lader_laenge (Fehler mit A86!)
                        db 0cah
                        dw ifs_os2ldr_lader_laenge
                        ;
                        ;---------------------------------------------


;********************************************************************
lade_berechne_bp_neu:
                        call lade_berechne_bp_neu_pop_bp
  lade_berechne_bp_neu_pop_bp:
                        pop bp
                        sub bp,Offset lade_berechne_bp_neu_pop_bp
                        ret
;********************************************************************

lader_fehler_halt:
                        mov byte ptr cs:[lader_ausschrift_abgeschaltet],0
                        call lader_ausschrift_p8_abschaltbar
                        jmp endlos

;********************************************************************

lader_ausschrift_p8_abschaltbar:
                        push3 ds,bx,ax
                          push cs
                          pop ds

                          cmp byte ptr [lader_ausschrift_abgeschaltet],1
                          je lader_ausschrift_ende

                          cld
  lader_ausschrift_schleife:
                          lodsb
                          test al,al
                          jz lader_ausschrift_ende

                          mov ah,00eh
                          mov bx,00007h
                          int 010h
                          jmp lader_ausschrift_schleife

  lader_ausschrift_ende:
                        pop3 ax,bx,ds
                        ret
;********************************************************************

aenderung_os2krnd       db 0 ; aus

lader_text_lade_os2ldr  db msg_Loading_OS2LDR__,0

lader_text_os2boot1     db err_os2boot1,13,10,0
lader_text_os2boot2     db err_os2boot2,13,10,0
lader_text_os2boot3     db err_os2boot3,13,10,0

lader_text_fehler_beim_oeffnen_von_os2ldr_bin db err_cannot_open_os2ldr_bin,13,10,0
lader_text_lesefehler   db err_read_error_,13,10,0
lader_text_umbruch      db 13,10,0

lader_name_os2ldr_bin   db 'OS2LDR.BIN',0
lader_name_os2ldr_bin_stelle_erweiterung equ $-1-4

ifs_os2ldr_lader_ende:
;********************************************************************
;********************************************************************

endif ; -memdisk

                        exe_markierung 'Lader-Ende'

                        ; wird nur zur Darstellung des MenÅs und der
                        ; Installation benîtigt

                        include install.inc
                          exe_markierung 'Installation'
ifndef memdisk
                        include hand13i.inc
                          exe_markierung 'EinhÑngen Int 10 und 13'
                        include bconfigi.inc
                          exe_markierung 'A/B-Config.sys Installation'
endif ; -memdisk
                        include det_mdsk.inc
                          exe_markierung 'MEMDISK oder OS2LDR-Variante'
                        include cpu.inc
                          exe_markierung 'Prozessor-Erkennung'
                        include det_apm.inc
                          exe_markierung 'APM und ACPI-Erkennung'
                        include det_vid.inc
                          exe_markierung 'Grafikkarten-Erkennung'
                        include hab_detc.inc
                          exe_markierung 'SCSI-Erkennung'
                        include hab_dete.inc
                          exe_markierung 'SCSI-Tabellen'
                        include nic_detc.inc
                          exe_markierung 'NETZ-Erkennung'
                        include nic_dete.inc
                          exe_markierung 'NETZ-Tabellen'
                        include testvpc.inc
                          exe_markierung 'VPC-Erkennung'
                        include test2os2.inc
                          exe_markierung '2OS2-Erkennung'
                        include ser_dete.inc
                          exe_markierung 'COM.SYS-Erkennung'
                        include pci.inc
                          exe_markierung 'Anweisungen/PCI'
                        include pnp.inc
                          exe_markierung 'Anweisungen/PNP'
                        include os2krnd.inc
                          exe_markierung 'OS2KRNL->OS2KRND-énderung'
ifndef memdisk
                        include suchemcb.inc
                          exe_markierung 'Speicherblocksuche'
endif ; -memdisk
                        include bildtaus.inc
                          exe_markierung 'Bildschirmmodus umschalten'
                        include bool_chr.inc
                          exe_markierung 'ZeichensatzÑnderungen'
                        include menucode.inc
                          exe_markierung 'MenÅfunktionen'
                        include menuzeic.inc
                          exe_markierung 'Zeichenen der MenÅmarkierungen'
                        include anweisun.inc
                          exe_markierung 'AusfÅhrung von Anweiungen'
                        include speichgr.inc
                          exe_markierung 'Bestimmung der Speichergrî·e'
                        include dos.inc
                          exe_markierung 'DOS-Funktionen'
                        include packevar.inc
                          exe_markierung 'Komprimierung des Dauervariablenbereiches'
                        include varzeige.inc
                          exe_markierung 'Schneller Variablenzugriff'
                        include entpacke.inc
                          exe_markierung 'Bildschirmseiten entpacken'
                        include defaultv.inc
                          exe_markierung 'Standardwerte merken'

ifdef memdisk
                        include var_cfg.inc
                          exe_markierung 'OS2CSM.SET laden/speichern'
endif
                        include help.inc
                          exe_markierung 'OS2CSM.HLP anzeigen'

                        include ..\..\memdisk\bios\speicher.inc
                          exe_markierung 'Speicherverwaltung'
                        ;--------------------------------------------


;********************************************************************

                        ; wird auf +64K gesetzt
altf5_bildschirm_beschreibung bildschirm_sicherung <>
altf5_palette:          db 16*3 dup (?)

                        ; wird nur bei OS2BOOT_/ecs_cd benutzt

os2boot_sicherung       bildschirm_sicherung <>

anfangsvariablen:
                        ;--------------------------------------------
                        ; ab hier kommen die nur zum
                        ; Anfang benutzten Variablen

variablen_zeiger_tabelle        dw 0

schnelltastenzeiger             dw 10 dup (0) ; 10*nil
                                ; Verweise auf die eigenlichen Schnelltastendaten
                                ; oder 0

formel_zeiger                   dw 0

zeitgrenze_org                  dd 0

eingabetaste_sc                 dw 01c0dh ; Enter
escape_sc                       dw 0011bh ; Esc
reset_sc                        dw 08500h ; F11
alt_f5_sc                       dw 06200h ; Ctrl+F5
help_sc                         dw 03b00h ; F1

ofs_internal_helpfile           dw -1

anzahl_bildschirmseiten         db ?
menu_bildschirm_beschreibung    bildschirm_sicherung <>

menu_continue_beschreibung      bildschirm_sicherung <>
menu_continue_yes_sc            dw 04400h ; F10
menu_continue_no_sc             dw 0011bh ; Esc

menu_cancel_beschreibung        bildschirm_sicherung <>
menu_cancel_yes_sc              dw 04400h ; F10
menu_cancel_no_sc               dw 0011bh ; Esc

menu_reset_beschreibung         bildschirm_sicherung <>
menu_reset_yes_sc               dw 04400h ; F10
menu_reset_no_sc                dw 0011bh ; Esc


pnp_puffer_laenge               dw ?
pnp_puffer_zeiger               dw ?

menu_palette_benutzen           db 0 ; false
menu_palette                    db 16*3 dup (?)


                        ; Ende der Rohdatei
                        ;--------------------------------------------

                        ; Schnelltasten ...
                        ; Formeldaten ...
                        ; vorbereitete Seiten

                        ; Ende der erzeugten Datei
                        ;--------------------------------------------

                        ; 80*50*2 Speicherplatz

                        ; Ende des Speicherbedarfes
                        ;--------------------------------------------

;ende
;***************************************************************************

code                    EndS

end
