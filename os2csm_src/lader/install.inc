Title   Call menu subroutines and install

;***************************************************************************
; DUMP CONFIG.SYS
; 1999.01.19
;***************************************************************************
p8str name_os2csm_quiet         'OS2CSM_QUIET'

a_proc                          ermittle_ausschrift_abgeschaltet
                                push3 si,di,ds
                                  push cs
                                  pop ds
                                  mov si,Offset name_os2csm_quiet
                                  call suche_variable_p8
                                  null ax ; stumm=falsch wenn nicht vorhanden
                                  test di,di
                                  if_nz <mov ax,[di].aktuelle_einstellung>
                                pop3 ds,di,si
                                ret
a_endp                          ermittle_ausschrift_abgeschaltet
;***************************************************************************
a_proc                          ausschrift_p8_abschaltbar
                                pusha
                                  call ermittle_ausschrift_abgeschaltet
                                  cmp al,1
                                  if_ne <call ausschrift_p8>
                                popa
                                ret
a_endp                          ausschrift_p8_abschaltbar
;***************************************************************************

dos_modus                       db 0

a_proc                          os2csm_menue
                                pushad
                                  push2 ds,es

                                    push cs
                                    pop ds
                                    push cs
                                    pop es

                                    call erzeuge_variablen_zeiger_tabelle

                                    mov si,Offset text_zeilenumbruch
                                    call ausschrift_p8_abschaltbar

                                    mov si,Offset titel
                                    call ausschrift_p8_abschaltbar


ifdef memdisk
                                    ; make memory manager compatible to memdisk
                                    mov ax,[icmd].memorymanager_anchor
                                    mov [erster_speicher_block],ax

                                    ; process loaded os2csm.set
                                    call load_var_cfg

                                    ; MEMDISK_CONFIG_SYS_EDIT von MemDisk Åbernehmen
                                    call set_MEMDISK_CONFIG_SYS_EDIT
                                    call set_MEMDISK_RENAME_FILESET
                                    call set_MEMDISK_OS2LOGO_DELETE
else
                                    ; use own memory manager
                                    call init_memorymanager
endif ; -memdisk


                                    call bestimme_speichergroesse

IFNDEF memdisk
IFNDEF language_en
                                    call tastatur_umbelegung_einhaengen
ENDIF ; -language_en
ENDIF ; -memdisk

                                    mov [menu_bildschirm_beschreibung].bildschirm_puffer_zeiger._SEG,cs
                                    mov [menu_continue_beschreibung].bildschirm_puffer_zeiger._SEG,cs
                                    mov [menu_cancel_beschreibung].bildschirm_puffer_zeiger._SEG,cs
                                    mov [menu_reset_beschreibung].bildschirm_puffer_zeiger._SEG,cs
                                    call entpacke_bildschirme

                                    mov eax,80*50*2
                                    mov si,Offset altf5_bildschirm_beschreibung.bildschirm_puffer_zeiger
                                    call getmem

                                    call detect_memdisk_or_os2ldr_variant
                                    call detect_memdisk_disk_size
                                    call check_virtual_pc
                                    call check_2os2_svista
                                    call detect_serial_port
                                    call detect_cpu
                                    call detect_apm
                                    call detect_acpi
                                    call detect_pci
                                    call detect_hostadapters ; +nic
                                    ;-obsolete by nic_det*.inc
                                    ;-call suche_pci_netzwerkkarten
                                    call examine_dmi
                                    call summary_detect_video

                                    call setze_einfuege_oder_ueberschreibmodus

                                    ; Zeitgrenze ausrechnen
                                    mov eax,[zeitgrenze_org]
                                    call setze_zeitgrenze

                                    ; Anfangswert ...
                                    call ermittle_wert_von_OS2CSM_MENU
                                    mov bx,ax

ifdef memdisk
                                    movzx ax,[icmd].os2csm_mode
                                    inc ax ; 0/1->1/2
                                    ; no need for memory block reserved by os2boot_.ac
else ; -memdisk
                                    ; Aufrufparameter prÅfen
                                    call suche_reservierten_speicher
                                    test ax,ax
                                    ; ax=0
                                    jz kein_parameter_von_os2boot

                                    ; Speicherblock auswerten
                                    push ds
                                      mov ds,ax

                                      ; PrÅfen ob der Bildschirminhalt gesichert wurde
                                      mov si,type mcb
                                      mov cx,type bildschirm_sicherung
                                      mov di,Offset os2boot_sicherung
                                      cld

                                      cmp word ptr [si],0cccch
                                      if_ne <rep movsb>

                                      ; Benutzerstufe Åbernehmen
                                      movzx ax,Byte Ptr ds:[mcb_reserviert_05]

                                    pop ds
  kein_parameter_von_os2boot:

endif ; -memdisk
                                    cmp ax,0
                                    if_e <mov ax,bx>

                                    ; Benutzerstufe merken
                                    mov si,Offset name_OS2CSM_MENU
                                    call suche_variable_p8
                                    test di,di
                                    if_nz <mov [di].aktuelle_einstellung,ax>
                                    mov [OS2CSM_MENU],al

                                    ; In jedem Fall die Anweisungen einmal durchlaufen
                                    ; auch wenn das MenÅ nicht angezeigt wird
                                    mov [aktueller_zustand],anweisung_anfang
                                    call berechne_abhaengigkeiten
                                    mov [aktueller_zustand],anweisung_normal

                                    cmp al,1
                                    je menu_nicht_anzeigen

                                    call save_default_values

                                    ; MenÅ aufrufen
                                    mov di,Offset altf5_bildschirm_beschreibung
                                    call bildschirm_sichern
                                    mov dx,Offset altf5_palette
                                    call sichere_palette

                                    mov dx,Offset menu_palette
                                    call setze_palette

                                    call menu_bearbeiten

                                    mov dx,Offset altf5_palette
                                    call setze_palette

                                    mov si,Offset altf5_bildschirm_beschreibung
                                    mov cx,1
                                    call bildschirm_laden
                                    call disable_checkbox_boolean

                                    call free_default_values

  menu_nicht_anzeigen:

                                    mov si,Offset altf5_bildschirm_beschreibung.bildschirm_puffer_zeiger
                                    call freemem

                                    ; 'final' changes to variables
                                    mov [aktueller_zustand],anweisung_ende
                                    call berechne_abhaengigkeiten

ifdef memdisk
                                    ; copy back special values back to MemDisk
                                    call copy_MEMDISK_CONFIG_SYS_EDIT
                                    call copy_MEMDISK_RENAME_FILESET
                                    call copy_MEMDISK_OS2LOGO_DELETE

                                    ; save settings to 'os2csm.set'
                                    call save_var_cfg
endif

                                    ; geÑnderte Benutzerstufe laden (echo)
                                    call ermittle_wert_von_OS2CSM_MENU

                                    ; Variable os2krnd prÅfen
                                    ; Variable os2ldr_deb prÅfen
                                    call aendere_os2krnl_zu_os2rld

IFNDEF memdisk
IFNDEF language_en
                                    call tastatur_umbelegung_entfernen
ENDIF ; -language_en
ENDIF ; -memdisk

                                    call packe_variablen

                                    call free_decompressed_screens
ifdef memdisk
                                    ; deallocate help screens
                                    mov si,Offset [icmd].os2csm_hlp_memory
                                    cmp [si]._SEG,0
                                    if_ne <call freemem>
                                    mov [icmd].os2csm_hlp_size,0
endif ; memdisk


                                    cmp [dos_modus],1
                                    je dos_config_sys_laden


                                    cmp [abbruch],1
                                    je installationsabbruch

ifdef memdisk
                                    ; config.sys bearbeiten
                                    mov eax,[icmd].config_sys_memory
                                    test eax,eax
                                    jz no_config_sys
                                    mov [mod_quellsektor_ptr],eax
                                    add ax,[icmd].config_sys_size
                                    mov [mod_quellsektor_ende],ax
                                    movzx eax,[icmd].config_sys_size
                                    mov si,Offset mod_zielsektor_ptr
                                    call getmem
                                    call bearbeite_speicher_sektor
                                    mov si,Offset mod_quellsektor_ptr
                                    call freemem
                                    mov eax,[mod_zielsektor_ptr]
                                    mov [icmd].config_sys_memory,eax
                                    mov ax,[mod_zielsektor_ende]
                                    sub ax,[mod_zielsektor_ptr]._OFF
                                    mov [icmd].config_sys_size,ax
  no_config_sys:

                                    ; config.x bearbeiten
                                    mov eax,[icmd].config_x___memory
                                    test eax,eax
                                    jz no_config_x
                                    mov [mod_quellsektor_ptr],eax
                                    add ax,[icmd].config_x___size
                                    mov [mod_quellsektor_ende],ax
                                    movzx eax,[icmd].config_x___size
                                    mov si,Offset mod_zielsektor_ptr
                                    call getmem
                                    call bearbeite_speicher_sektor
                                    mov si,Offset mod_quellsektor_ptr
                                    call freemem
                                    mov eax,[mod_zielsektor_ptr]
                                    mov [icmd].config_x___memory,eax
                                    mov ax,[mod_zielsektor_ende]
                                    sub ax,[mod_zielsektor_ptr]._OFF
                                    mov [icmd].config_x___size,ax
  no_config_x:

else ; -memdisk

                                    call versuche_ab_config_sys


                                    ; Bestimmen des zu verwendenden Speicherbereiches
                                    call suche_reservierten_speicher
                                    test ax,ax
                                    jz benutze_grafikspeicher

                                    mov si,Offset text_benutze_reservierten_speicher
                                    call ausschrift_p8_abschaltbar
                                    inc ax ; PSP/16
                                    jmp benutze_speicher_weiter
  benutze_grafikspeicher:
                                    mov si,Offset text_benutze_bildschirmspeicher
                                    call ausschrift_p8_abschaltbar
                                    mov ax,textspeicher_unbenutzt_segment
  benutze_speicher_weiter:
                                    ; Kopieren nach AX:0
                                    null si
                                    push cs
                                    pop ds
                                    null di
                                    mov es,ax
                                    ;**mov cx,(ende_tsr-0+1)/2
                                    mov cx,Offset ende_tsr
                                    ;sub cx,0
                                    inc cx
                                    shr cx,1
                                    cld
                                    rep movsw

                                    ; einhÑngen
                                    call hand10und13_install
endif ; -memdisk
                                    jmp short weiter_nach_int1013_installiert
                                    ;--------------------------------

  installationsabbruch:
                                    mov si,Offset text_abbruch
                                    call ausschrift_p8_abschaltbar
                                    call warte_1_sekunde

  weiter_nach_int1013_installiert:



                                  pop2 es,ds
                                popad
                                ret
a_endp                          os2csm_menue

;***************************************************************************

abbruch                         db 0

p8str text_abbruch              msg_install_aborted

ifndef memdisk

p8str text_benutze_reservierten_speicher msg_Using_reserved_memory

p8str text_benutze_bildschirmspeicher    msg_Using_video_memory

endif ; -memdisk

p8str text_zeilenumbruch        13,10

;***************************************************************************


