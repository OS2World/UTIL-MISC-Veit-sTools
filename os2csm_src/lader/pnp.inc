Title   PNP+DMI dection functions

;***************************************************************************
pnp_id                  dd ?
pnp_class               dw ?
pnp_acc                 db ?
pnp_bios                dd 0
pnp_bios_ds             dw ?
anzahl_pnp_geraete      dw 0
knoten                  db 0
                        db 0
pufferbedarf            dw ?

anzahl_pnp_richtig      dw ?
grenze_pnp_richtig      dw ?

;***************************************************************************

a_proc                  pnp_suchen

                        call pruefe_os2_vmb

                        pushad
                          push ds

                            push 0f000h
                            pop ds

                            mov si,0e010h
                            cmp dword ptr [si],'tsyS'
                            jne pnp_suchen_nicht_SystemSoft
                            cmp word ptr [si+6],'oS'
                            jne pnp_suchen_nicht_SystemSoft

                            ; SYS3175 abfangen
                            cmp cs:[os2_laeuft],1
                            je suche_pnp_ende

  pnp_suchen_nicht_SystemSoft:
                            null si
  suche_pnp_schleife:
                            cmp dword ptr [si],'PnP$'             ; $PnP
                            jne nicht_pnp_sig

                            movzx cx,byte ptr ds:[si+5]
                            cmp cl,0
                            je nicht_pnp_sig

                            push si
                              null ax
                              cld
  pnp_pruefsumme:
                              lodsb
                              add ah,al
                              loop pnp_pruefsumme
                            pop si
                            cmp ah,0
                            je pnp_sig_gueltig
  nicht_pnp_sig:
                            add si,010h
                            jz suche_pnp_ende           ; >64K
                            jmp suche_pnp_schleife
  pnp_sig_gueltig:
                            mov eax,ds:[si+0dh]
                            mov cs:[pnp_bios],eax
                            mov ax,ds:[si+01bh]
                            mov cs:[pnp_bios_ds],ax

                            ; Åberschriebenes BIOS (durch DOS) prÅfen ?

                            push cs
                            pop ds

                            ; Platzbedarf herausfinden

                            push [pnp_bios_ds]
                            push ds
                            push Offset pufferbedarf
                            push ds
                            push Offset anzahl_pnp_geraete
                            push 0                          ; Get Number of System Device Nodes
                            call [pnp_bios]
                            add sp,6*2
                            test ax,ax
                            jne suche_pnp_fehler

                            mov ax,[pnp_puffer_laenge]
                            cmp ax,[pufferbedarf]
                            jae suche_pnp_ende
  suche_pnp_fehler:
                            and [pnp_bios],0
  suche_pnp_ende:
                          pop ds
                        popad
                        mov byte ptr [pnp_suchen],0c3h  ; nur einmal
                        ret
a_endp                  pnp_suchen

;***************************************************************************
; Eingabe DS:DI='PNP0C00'...
; Ausgabe DX Anzahl
Count_PNP_DeviceID:
                        mov [grenze_pnp_richtig],0ffffh
                        jmp short Search_Count_PNP_DeviceID_gemeinsam

; Eingabe DS:DI='PNP0C00'...
; Ausgabe DX boolean
Search_PNP_DeviceID:
                        mov [grenze_pnp_richtig],1

Search_Count_PNP_DeviceID_gemeinsam:
                        mov [anzahl_pnp_richtig],0

                        pushad

                        call pnp_suchen
                        cmp [pnp_bios],0
                        je Search_PNP_DeviceID_nicht_gefunden

                        ; EISA-ID umwandeln
                        cmp byte ptr [di],3+4
                        jne Search_PNP_DeviceID_nicht_gefunden
                        inc di
                        sub dx,dx
                        mov al,[di]
                        inc di
                        and al,01fh                     ; al =--543210
                        shl al,2                        ; al =543210--
                        or dl,al                        ; dl =AAAAAA--
                        mov al,[di]
                        inc di
                        and ax,01fh                     ; ax =-----------43210
                        ror ax,3                        ; ax =210-----------43
                       ;or dl,al                        ; dl =AAAAAABB
                       ;or dh,ah                        : dh =BBB-----
                        or dx,ax
                        mov al,[di]
                        inc di
                        and al,01fh                     ; al =---43210
                        or dh,al                        ; dh =BBBCCCCC
                        mov word ptr [pnp_id+0],dx

                        dec di
                        mov bl,4
                        xchg bl,[di]
                        call Val_Hex4
                        mov [di],bl
                        xchg al,ah
                        mov word ptr [pnp_id+2],ax

                        mov [knoten],0

Search_PNP_DeviceID_nochmal:
                        push [pnp_bios_ds]
                        push 1                          ; get current (dynamic) configuration
                        push ds
                        push [pnp_puffer_zeiger]
                        push ds
                        push Offset knoten
                        push 1                          ; Get System Device Node
                        call [pnp_bios]
                        add sp,7*2
                        test ax,ax
                        jne ohne_pnp_bios

                        mov si,[pnp_puffer_zeiger]
                        mov eax,[si+EISA_product_identifier]
                        cmp eax,[pnp_id]
                        jne Search_PNP_DeviceID_ungleich

                        inc [anzahl_pnp_richtig]
                        mov ax,[anzahl_pnp_richtig]
                        cmp ax,[grenze_pnp_richtig]
                        je short Search_PNP_DeviceID_Ende

Search_PNP_DeviceID_ungleich:
                        cmp [knoten],0ffh
                        jne Search_PNP_DeviceID_nochmal

ohne_pnp_bios:
Search_PNP_DeviceID_nicht_gefunden:
Search_PNP_DeviceID_Ende:
                        popad
                        mov dx,[anzahl_pnp_richtig]
                        ret
;***************************************************************************
; Eingabe DX=0701 AL=FF PNP GerÑteklasse/Zugriff
; Ausgabe DX Anzahl
Count_PNP_DeviceClass:
                        mov [grenze_pnp_richtig],0ffffh
                        jmp short Search_Count_PNP_DeviceClass_gemeinsam

; Eingabe DX=0701 AL=FF PNP GerÑteklasse/Zugriff
; Ausgabe DX boolean
Search_PNP_DeviceClass:
                        mov [grenze_pnp_richtig],1

Search_Count_PNP_DeviceClass_gemeinsam:
                        mov [anzahl_pnp_richtig],0

                        pushad

                        xchg dl,dh
                        mov [pnp_class],dx
                        mov [pnp_acc],al

                        call pnp_suchen
                        cmp [pnp_bios],0
                        je Search_PNP_DeviceClass_nicht_gefunden

                        mov [knoten],0

Search_PNP_DeviceClass_nochmal:
                        push [pnp_bios_ds]
                        push 1                          ; get current (dynamic) configuration
                        push ds
                        push [pnp_puffer_zeiger]
                        push ds
                        push Offset knoten
                        push 1                          ; Get System Device Node
                        call [pnp_bios]
                        add sp,7*2
                        test ax,ax
                        jne ohne_pnp_bios

                        mov si,[pnp_puffer_zeiger]
                        mov ax,[pnp_class]
                        cmp ax,word ptr [si+device_type_code+0]
                        jne Search_PNP_DeviceClass_ungleich
                        mov al,[pnp_acc]
                        cmp al,0ffh
                        je Search_PNP_DeviceClass_gleich
                        cmp al,[si+device_type_code+2]
                        jne Search_PNP_DeviceClass_ungleich

Search_PNP_DeviceClass_gleich:
                        inc [anzahl_pnp_richtig]
                        mov ax,[anzahl_pnp_richtig]
                        cmp ax,[grenze_pnp_richtig]
                        je short Search_PNP_DeviceClass_Ende

Search_PNP_DeviceClass_ungleich:
                        cmp [knoten],0ffh
                        jne Search_PNP_DeviceClass_nochmal

Search_PNP_DeviceClass_nicht_gefunden:
Search_PNP_DeviceClass_Ende:
                        popad
                        mov dx,[anzahl_pnp_richtig]
                        ret
;***************************************************************************
DMI_BIOS_revision_string                db '    '
DMI_number_of_structures                dw 0
DMI_size_of_largest_structure           dw 0
DMI_storage_base_address                dd 0
DMI_storage_size                        dw 0

DMI_current_handle                      dw 0

varnames_OS2CSM_SysInfo_begin:
p8str varname_OS2CSM_SysInfo_MANF       'OS2CSM_SYSINFO_MANF'
p8str varname_OS2CSM_SysInfo_PROD       'OS2CSM_SYSINFO_PROD'
p8str varname_OS2CSM_SysInfo_VERS       'OS2CSM_SYSINFO_VERS'
p8str varname_OS2CSM_SysInfo_SERN       'OS2CSM_SYSINFO_SERN'
p8str varname_OS2CSM_SysInfo_UUID       'OS2CSM_SYSINFO_UUID'
varnames_OS2CSM_SysInfo_end:

smbios_data_structure_type1             Struc
  SMBIOS_structure_type                 db ?
  SMBIOS_length_of_formatted_data       db ?
  SMBIOS_structure_handle               dw ?
  string_number_of_manufacturer_name    db ?
  string_number_of_product_name         db ?
  string_number_of_version_number       db ?
  string_number_of_serial_number        db ?
  universal_unique_ID_number            db 16 dup (?)
  type_of_last_wake_up_event            db ?
smbios_data_structure_type1             EndS

;***************************************************************************
a_proc                  examine_dmi
                        pushad

                          cmp [pnp_puffer_laenge],0
                          je exit_examine_dmi

                          ; avoid calling P&P BIOS if not needed,
                          ; check if variables are present

                          mov si,Offset varnames_OS2CSM_SysInfo_begin
  check_useful_examine_dmi:
                          call suche_variable_p8
                          test di,di
                          jnz useful_examine_dmi

                          ; next p8str
                          movzx ax,Byte Ptr [si]
                          inc ax
                          add si,ax
                          cmp si,Offset varnames_OS2CSM_SysInfo_end
                          jne check_useful_examine_dmi

                          ; not used, skip
                          jmp exit_examine_dmi

  useful_examine_dmi:

                          ; DSP0134_2.6.0 says that the PNP method is deprecated,
                          ; so we do this direct table access..

                          call dmi_search_copy_system_information
                          ; jump into the middle of a loop
                          ; this is ok, since dmi_search_copy_system_information
                          ; already verifies for block #1 (system information)
                          jnc @@have_dmi_from_table

                          call pnp_suchen
                          cmp [pnp_bios],0
                          je exit_examine_dmi

                          ; DMI available? get information...
                          push [pnp_bios_ds]
                          push ds
                          push Offset DMI_storage_size
                          push ds
                          push Offset DMI_storage_base_address
                          push ds
                          push Offset DMI_size_of_largest_structure
                          push ds
                          push Offset DMI_number_of_structures
                          push ds
                          push Offset DMI_BIOS_revision_string
                          push 0050h ; "Get DMI Information"
                          call [pnp_bios]
                          add sp,12*2
                          test ax,ax
                          jnz exit_examine_dmi

                          ; is our buffer large enough?
                          mov ax,[pnp_puffer_laenge]
                          cmp ax,[DMI_size_of_largest_structure]
                          jb exit_examine_dmi

                          ; loop through all DMI structures,
                          ; until found 'System' or an error occurs

                          mov DMI_current_handle,0
  loop_search_system_structure:
                          push es
                            push ds
                            pop es
                            mov di,[pnp_puffer_zeiger]
                            mov cx,[DMI_size_of_largest_structure]
                            mov al,0
                            cld
                            rep stosb
                          pop es

                          push [pnp_bios_ds]
                          ; "DMI read/write data selector" - unknown, guess address shr 4..
                          mov eax,DMI_storage_base_address
                          shr eax,4
                          push ax
                          push ds
                          push [pnp_puffer_zeiger]
                          push ds
                          push Offset DMI_current_handle
                          push 0051h ; "Get DMI Structure"
                          call [pnp_bios]
                          add sp,7*2
                          test ax,ax
                          jnz exit_examine_dmi

  @@have_dmi_from_table:
                          mov si,[pnp_puffer_zeiger]
                          cmp [si].SMBIOS_structure_type,1
                          jne loop_search_system_structure

                          mov bx,Offset varname_OS2CSM_SysInfo_MANF
                          mov al,[si].string_number_of_manufacturer_name
                          call DMI_find_copy_string
                          mov bx,Offset varname_OS2CSM_SysInfo_PROD
                          mov al,[si].string_number_of_product_name
                          call DMI_find_copy_string
                          mov bx,Offset varname_OS2CSM_SysInfo_VERS
                          mov al,[si].string_number_of_version_number
                          call DMI_find_copy_string
                          mov bx,Offset varname_OS2CSM_SysInfo_SERN
                          mov al,[si].string_number_of_serial_number
                          call DMI_find_copy_string

                          add si,universal_unique_ID_number
                          mov di,Offset zeichenketten_zwischenspeicher
                          mov Byte Ptr [di],2*16
                          inc di
                          mov cx,16
  hex_UUID_loop:
                          mov al,[si]
                          shr al,4
                          cmp al,10
                          sbb al,69h
                          das
                          mov [di],al
                          inc di

                          mov al,[si]
                          and al,00fh
                          cmp al,10
                          sbb al,69h
                          das
                          mov [di],al
                          inc di

                          inc si
                          loop hex_UUID_loop

                          mov bx,Offset varname_OS2CSM_SysInfo_UUID
                          mov si,Offset zeichenketten_zwischenspeicher
                          call store_string_to_anything_varname

                          ; no further tries to search structure

  exit_examine_dmi:

                        popad
                        ret
a_endp                  examine_dmi

;***************************************************************************
; si=structure
; al=string index
; bx=variable name
a_proc                  DMI_find_copy_string
                        cld
                        push si

                          push ax
                          push bx
                          push di

                            mov di,Offset zeichenketten_zwischenspeicher
                            mov Byte Ptr [di],0
                            inc di

                            movzx bx,[si].SMBIOS_length_of_formatted_data
                            add si,bx
                            movzx bx,al
                            test bx,bx  ; no string?
                            jz DMI_find_string_dup_done
                            jmp DMI_find_string_loop_entry

  DMI_find_string_loop:     ; search string start
                            lodsb
                            cmp al,0
                            jnz DMI_find_string_loop
  DMI_find_string_loop_entry:
                            dec bx
                            jnz DMI_find_string_loop

  DMI_find_string_dup_loop:
                            lodsb
                            mov [di],al
                            inc di
                            cmp al,0
                            jne DMI_find_string_dup_loop
                            dec di

  DMI_find_string_dup_done:
                            mov ax,di
                            mov si,Offset zeichenketten_zwischenspeicher
                            sub ax,si
                            dec ax
                            mov [si],al
                          pop di
                          pop bx
                          pop ax

                          ; si=string
                          ; bx=variable name
                          call store_string_to_anything_varname

                        pop si
                        ret
a_endp                  DMI_find_copy_string

;***************************************************************************

a_proc                  dmi_search_copy_system_information
                        pushad
                        push es
                          ; signature f000:0000..f000:fff0, every 16 bytes
                          mov ax,0f000h
                          mov es,ax
                          sub di,di
  @@dmi_search_loop:
                          cmp DWord Ptr es:[di+0],'IMD_'
                          jne @@dmi_search_next
                          cmp Byte Ptr es:[di+4],'_'
                          jne @@dmi_search_next

                          ; checksum..
                          push di
                            mov al,0
                            mov cx,15
  @@checksum_dmi:
                            add al,Byte Ptr es:[di]
                            inc di
                            loop @@checksum_dmi
                          pop di
                          cmp al,0
                          jne @@dmi_search_next

                          ; restriction: we only allow addresses below 1 MiB
                          mov eax,es:[di+8] ; 32 bit address of SMBIOS structure table

                          ; number of structures
                          mov cx,Word Ptr es:[di+0ch]

  @@dmi_search_copy_system_information_loop:
                          test cx,cx
                          jz @@dmi_search_copy_system_information_fail

                          call copy_eax_to_pnp_puffer
                          mov si,[pnp_puffer_zeiger]
                          cmp [si].SMBIOS_structure_type, 1
                          clc
                          je @@dmi_search_copy_system_information_exit

                          movzx bx,[si].SMBIOS_length_of_formatted_data
                          inc bx
  @@search_end_of_structure_string_set:
                          inc bx
                          ; if the block is too large for our buffer, we simply exit the search here
                          cmp bx,[pnp_puffer_laenge]
                          ja @@dmi_search_copy_system_information_fail

                          cmp Word Ptr ds:[si+bx-2],0
                          jne @@search_end_of_structure_string_set

                          ; update start address to next block
                          movzx ebx,bx
                          add eax,ebx
                          dec cx
                          jmp @@dmi_search_copy_system_information_loop

  @@dmi_search_next:
                          add di,00010h
                          test di,di
                          jne @@dmi_search_loop

  @@dmi_search_copy_system_information_fail:
                          stc
  @@dmi_search_copy_system_information_exit:

                        pop es
                        popad
                        ret
a_endp                  dmi_search_copy_system_information

;***************************************************************************
GDT_for_DMI_copy        GDTDesc <0,0,0,0,0,0>
                        GDTDesc <0,0,0,0,0,0>
Source_Desc             GDTDesc <0ffffh,?,?,093h,0,?>
Target_Desc             GDTDesc <0ffffh,?,?,093h,0,?>
                        GDTDesc <0,0,0,0,0,0>
                        GDTDesc <0,0,0,0,0,0>
;***************************************************************************

                        ; eax=source address
a_proc                  copy_eax_to_pnp_puffer
                        pushad
                        push ds
                        push es
                        push fs
                        push gs

                          mov di,[pnp_puffer_zeiger]
                          mov cx,[pnp_puffer_laenge] ; copy in 16 bit words
                          shr cx,1
                          push ds
                          pop es
                          cld
                          pusha
                            null ax
                            rep stosw
                          popa

                          ; need to use BIOS service to copy?
                          test eax, 0fff00000h
                          jnz @@copy_using_bios

                          mov si,ax
                          and si,0000fh
                          shr eax,4
                          mov ds,ax
                          rep movsw
                          jmp @@exit

  @@copy_using_bios:
                          mov si,Offset Source_Desc
                          mov [si].BaseAddr1500,ax
                          shr eax,16
                          mov [si].BaseAddr2316,al
                          mov [si].BaseAddr3124,ah
                          mov ax,cx
                          shl ax,1
                          dec ax
                          mov [si].SegmentLimit,ax

                          mov si,Offset Target_Desc
                          mov [si].SegmentLimit,ax
                          mov ax,ds
                          movzx eax,ax
                          shl eax,4
                          movzx ebx,di
                          add eax,ebx
                          mov [si].BaseAddr1500, ax
                          shr eax,16
                          mov [si].BaseAddr2316, al
                          mov [si].BaseAddr3124, ah ; should be 0

                          mov ah,087h
                          mov si,Offset GDT_for_DMI_copy
                          int 015h

  @@exit:
                        pop gs
                        pop fs
                        pop es
                        pop ds
                        popad
                        ret
a_endp                  copy_eax_to_pnp_puffer

