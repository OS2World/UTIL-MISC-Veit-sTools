Title   Copy values to select bebug OS2LDR/OS2KRNL

;***************************************************************************
p8str name_os2rld               'OS2KRND'
p8str name_os2ldr_deb           'OS2LDR_DEB'

ifdef memdisk
p8str name_memdisk_driveletter  'MEMDISK_DRIVELETTER'
endif

a_proc                          aendere_os2krnl_zu_os2rld
                                pusha

                                  ;----------------------------------

                                  mov si,Offset name_os2rld
                                  call suche_variable_p8

                                  ; vorhanden ?
                                  null ax
                                  test di,di
                                  if_nz <mov ax,[di].aktuelle_einstellung>

ifdef memdisk
                                  mov icmd.rename_os2krnl_deb,al
else
                                  mov [aenderung_os2krnd],al
endif

                                  ;----------------------------------

                                  mov si,Offset name_os2ldr_deb
                                  call suche_variable_p8

                                  ; vorhanden ?
                                  test di,di
                                  jz os2ldr_bin_keine_aenderung
                                  cmp [di].aktuelle_einstellung,1
                                  jne os2ldr_bin_keine_aenderung

ifdef memdisk
                                  mov icmd.rename_os2ldr_deb,1
else
                                  mov dword ptr [lader_name_os2ldr_bin_stelle_erweiterung],'BED.' ; '.DEB'
endif

  os2ldr_bin_keine_aenderung:
                                  ;----------------------------------
ifdef memdisk
                                  mov si,Offset name_memdisk_driveletter
                                  call suche_variable_p8

                                  ; vorhanden ?
                                  test di,di
                                  jz no_memdisk_driveletter

                                  call liefere_aktuellezeichenkette_der_variable
                                  mov al,ds:[si+1] ; first char
                                  mov [icmd].memdisk_drive_letter,al
  no_memdisk_driveletter:

endif
                                  ;----------------------------------

                                popa
                                ret
a_endp                          aendere_os2krnl_zu_os2rld

;***************************************************************************

