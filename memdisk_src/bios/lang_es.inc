Title           language dependant strings: spanish

; thanks to Alfredo Fern ndez D¡az

; module a20.inc
msg_Failed_to_restore_A20_gate          equ "Error restaurando la puerta A20"
;obsoleted
;msg_Returned_successfully_but_A20_rf    equ "De vuelta con ‚xito, error restaurando la puerta A20."

; module ausschri.inc
thousand_separator                      equ ","

; module boot.inc
msg_frage_harddisk_or_memdisk           equ <"¨Continuar en disco [",setkeycolour,"d",setdefaultcolour,"]uro, disco [",setkeycolour,"r",setdefaultcolour,"]am o [",setkeycolour,"f",setdefaultcolour,"]loppy ? ">
key_boot_harddisk                       equ "d"
key_boot_memdisk                        equ "r"
key_boot_floppy                         equ "f"
key_uninstall                           equ "u"
msg_meldung_Lesefehler                  equ "Error de lectura"
msg_meldung_no_bootable_partition       equ "No hay particiones arrancables."
msg_meldung_bootsector_invalid          equ "Sector de arranque sin firma."

; module call_csm.inc
msg_os2csm_not_found                    equ "No se pudo hallar el programa OS2CSM.BIN."
msg_Invalid_OS2CSM_BIN                  equ "OS2CSM.BIN no v lido."
msg_file_is_to_big_to_load              equ "Archivo demasiado grande para cargar."
msg_Can_not_rename_OS_debug_file_missing equ "Error al renombrar: falta el archivo de debug del SO."

; module cdloader.tas
msg_loading_part2                       equ "Cargando el segundo segmento de c¢digo ... "

; module cd_menu.inc
msg_function_not_implemented            equ <"Funci¢n no disponible a£n.",13,10,"Pulse una tecla para continuar",keypress,13,10,0>
msg_bootsector_read_error               equ <"Error leyendo sector de arranque.",13,10,"Pulse una tecla para continuar",keypress,13,10,0>
msg_bootsector_invalid_format           equ <"Sector de arranque no v lido.",13,10,"Pulse una tecla para continuar",keypress,13,10,0>

; module dep16s.inc
msg_invalid_packed_data_header          equ "Cabecera de compresi¢n no v lida."
msg_packed_data_CRC_failed              equ "Error de CRC en datos comprimidos."
msg_unpacking_data_failed               equ "Error al descomprimir."
msg_unpacked_data_CRC_failed            equ "Error de CRC tras descomprimir."

; module driveacc.inc
msg_swap_drive_insert                   equ " Inserte "
msg_swap_drive_additional_floppy        equ "disco de actualizaci¢n del arranque (si lo hay)"
msg_swap_drive_main_bootdisk            equ "disco de arranque principal"
msg_swap_drive_harddisk                 equ "disco duro"
msg_swap_drive_press_key                equ <", ",13,10,"y pulse una tecla ">

; module format.inc
msg_Memory_disk_memory_is_corrupted     equ "Memoria del disco RAM corrupta."
msg_MemDisk_sector_read_error0          equ "Error al leer sector de MemDisk"
msg_MemDisk_sector_read_error1          equ "."
msg_MemDisk_sector_write_error0         equ "Error al escribir sector de MemDisk"
msg_MemDisk_sector_write_error1         equ "."

; module inithd.inc

; module int_0_6.inc
msg_divide_by_zero                      equ "Divisi¢n por cero"
msg_invalid_opcode                      equ "OpCode no v lido"

; module int13.inc
msg_int13_problem_protected_mode        equ <seterrorcolour,"Modo protegido ya activo: no se puede acceder al disco RAM.",setdefaultcolour>

; module int15a.inc
msg_int15a_e820                         equ "usando INT 15 EAX=E820 'SMAP'"
msg_int15a_e881                         equ "usando INT 15 AX=e881 'Phoenix 4.0 32-bit'"
msg_int15a_c7                           equ "usando INT 15 AH=C7 'PS/2'"
msg_int15a_e801                         equ "usando INT 15 AX=e801 'Phoenix 4.0 16-bit'"
msg_int15a_8a                           equ "usando INT 15 AH=8A 'Phoenix 4.0 big'"
msg_int15a_da88                         equ "usando INT 15 AX=DA88 'AMI PCI'"
msg_int15a_88                           equ "usando INT 15 AH=88 '286'"
msg_Detecting_extended_memory_size      equ "Detectando tama¤o de memoria extendida .. "
msg_MB_starting_at_1_MB                 equ " MB empezando en 1 MB"
msg_MB_starting_at_16_MB                equ " MB empezando en 16 MB"
msg_Using_KB_at_Address_1               equ "Usando "
msg_Using_KB_at_Address_2               equ " bytes en la direcci¢n "
msg_Using_KB_at_Address_3               equ "."
msg_failed                              equ "Error."
msg_Not_enough_memory                   equ "Memoria insuficiente."

; module memalloc.inc
msg_DOS_memory_allocation_failed        equ "Error al asignar memoria DOS"
msg_No_free_harddisk_drive_number       equ "No hay n£mero libre para el disco duro"
msg_CD_ROM_emulation_terminated         equ "Emulaci¢n de CD-ROM terminada."
msg_CD_ROM_emulation_did_not_terminate  equ "Error al terminar la emulaci¢n de CD-ROM."
msg_title_dos                           equ <cls,"MemDisk [DOS] ">
msg_title_bios                          equ <cls,"MemDisk "> ; [BIOS]
msg_title_dos_cdloader                  equ <cls,"CDLoader [DOS] ">
msg_title_bios_cdloader                 equ <cls,"CDLoader "> ; [BIOS]
msg_bootdrive_floppyharddisk            equ "Unidad de inicio: disquetera/disco duro ("
msg_bootdrive_cdnoemu                   equ "Unidad de inicio: CD-ROM en modo 'No emulaci¢n' ("
msg_bootdrive2                          equ <").">
msg_Disk_0x_installed_1                 equ "Disquetera "
msg_Disk_0x_installed_3                 equ ": instalado."
msg_Disk_8x_installed_1                 equ "Disco "
msg_Disk_8x_installed_3                 equ ": instalado."
msg_MEMBOOT_BIN_corrupted_fragmented    equ <cd_boot_memboot_bin," corrupto/fragmentado.">
msg_already_present_SCAD                equ "MemDisk ya activo en memoria. Pulse May+Ctrl+Alt+Supr para reiniciar."

; module memload.inc
msg_Disk_has_invalid_format             equ <"Formato no v lido.",13,10,"Introduzca otro disco y pulse una tecla para reintentar.">
msg_Insert_floppy_with_label_press_key_1 equ "Inserte un disco con la etiqueta '"
msg_Insert_floppy_with_label_press_key_2 equ "' y pulse una tecla."
msg_Insert_floppy_with_file_press_key_1 equ "Inserte un disco con el archivo '"
msg_Insert_floppy_with_file_press_key_2 equ "' y pulse una tecla."
msg_invalid_partition_table_on_memdisk  equ "Tabla de partici¢n no v lida en disco RAM."
msg_No_active_primary_or_extended_part  equ "No hay particiones primarias o extendidas activas."
msg_Partition_on_memory_disk_is_not_FAT equ "La partici¢n del disco RAM no es FAT."
msg_Asking_for_drive_parameters_failed1 equ "Error al solicitar par metros de la unidad (disco="
msg_Asking_for_drive_parameters_failed2 equ <").">
msg_Write_error_disk_full               equ "Error de escritura: disco lleno."
msg_directory_full                      equ "Directorio lleno."
msg_invalid_cluster_number_2            equ "N£mero de cl£ster no v lido (<2)"
msg_invalid_cluster_number_max          equ "N£mero de cl£ster no v lido (>max)"
msg_sector_read_error_0                 equ <"Error leyendo sector (disco=">
msg_sector_read_error_1                 equ <", cilindro=">
msg_sector_read_error_2                 equ <", cabeza=">
msg_sector_read_error_3                 equ <", sector=">
msg_sector_read_error_4                 equ <").">
msg_hd_sector_read_error0               equ "Error leyendo disco duro (disco="
msg_cd_sector_read_error0               equ "Error leyendo CD-ROM (disco="
msg_cd_sector_read_error1               equ ", sector="
msg_cd_sector_read_error3               equ <").">
msg_invalid_VTOC                        equ "Sector de la tabla de contenido del CD-ROM no v lida."
msg_can_not_find_boot_directory         equ <"No se encuentran los archivos de arranque en el CD-ROM (",cd_boot_memboot_bin,").">
msg_boot_directory_is_not_a_directory   equ "El directorio del CD-ROM con los archivos de arranque no es un directorio."
msg_can_not_find_memboot_bin            equ <"No se encuentra el segundo segmento del c¢digo de arranque (",cd_boot_memboot_bin,").">
msg_memboot_bin_is_not_a_file           equ <"El segundo segmento del c¢digo de arranque (",cd_boot_memboot_bin,") no es un archivo.">
msg_to_many_files_in_cdrom_directory    equ "Demasiados archivos en el directorio del CD-ROM con los archivos comprimidos."
msg_invalid_cd_function                 equ "Llamada a funci¢n interna no permitida para el CD-ROM."
msg_update_permissed_by_updatefile      equ "Actualizaci¢n de archivos: encontrado archivo 'BOOT_UPD.TXT'."
msg_update_permissed_by_volumelabel     equ "Actualizaci¢n de archivos: encontrada etiqueta 'BOOT_UPDATE'."
msg_update_not_permissed                equ "Actualizaci¢n de archivos: no se encontrado etiqueta ni archivo indicador v lidos."
msg_query_geom_1                        equ "Error leyendo geometr¡a del disco "
msg_query_geom_3                        equ "."
mgs_k_errorcode_eq                      equ ", c¢digo de error="


; module readme.inc
msg_readme_not_found                    equ "Archivo de texto no encontrado."
msg_readme_file_is_to_large             equ "Archivo de texto demasiado largo."
msg_readme_statusline1                  equ <" L¡nea #">
msg_readme_statusline2                  equ <"  ",019h,018h,"=Ver, F7=Buscar, Esc=Salir ">
msg_Search_for                          equ "Buscar > "
msg_edit_statusline                     equ "F7=Buscar, Esc=Salir"

msg_edithelp_tab                        equ <"    ">
msg_edithelp_01                         equ "Moverse con el cursor, AvP g/ReP g"
msg_edithelp_02                         equ "Ctrl+ReP g/AvP g=Inicio/Fin del archivo"
msg_edithelp_03                         equ "Inicio/Fin=Principio/Fin de l¡nea"
msg_edithelp_04                         equ "Ctrl+Dcha./Izqda.=Ir al comienzo de la palabra siguiente/anterior"
msg_edithelp_05                         equ "Ctrl+Retroceso/T/Y=Borrar palabra hacia la dcha./izqda./Borrar l¡nea"
msg_edithelp_06                         equ "F7=Buscar, May+F7=Otra vez"
msg_edithelp_07                         equ "Ctrl+Ins=Copiar l¡,nea al portapapeles"
msg_edithelp_08                         equ "May+Ins=Insertar l¡,nea desde el portapapeles"
msg_edithelp_09                         equ "Ins=Cambiar modo sobresescribir/insertar"
msg_edithelp_10                         equ "Esc=Salir, preguntando si guardar los cambios"
msg_edithelp_key                        equ "pulse una tecla"

msg_edit_save_changes                   equ "Guardar los cambios (S/N/Esc)"
key_edit_save_changes_yes               equ "s"
key_edit_save_changes_no                equ "n"


; module speicher.inc
msg_memory_block_corrupted              equ "Bloque de control de memoria corrupto."
msg_Error_allocating_heap_memory        equ "No queda memoria."

; module unpackfi.inc
msg_Zero_length_file                    equ "Archivo de tama¤o cero."
msg_Unknown_format_damaged_archive      equ "Formato desconocido/archivo comprimido da¤ado."
msg_packfile_unkn_command               equ "Mandato desconocido/no disponible en el archivo comprimido"
msg_incorrect_archive_version           equ "Versi¢n incorrecta en el archivo comprimido."
msg_unpack_error_no_data                equ "Error al descomprimir: no hay datos."
msg_useless_data_in_archive             equ "datos in£tiles en el archivo."

; module xms.inc
msg_No_XMS_2_driver                     equ "No se encuentra controlador XMS 2+."
msg_Error_allocating_XMS_memory         equ "Error asignando memoria XMS."
msg_Error_determining_physical_address  equ "Error determinando direcci¢n f¡sica."
