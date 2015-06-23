Title           language dependant strings: dutch

; module a20.inc
msg_Failed_to_restore_A20_gate          equ "Fout bij herstellen A20 gate."
;obsoleted
;msg_Returned_successfully_but_A20_rf    equ "Succesvol afgerond, maar A20 herstellen mislukt."

; module ausschri.inc
thousand_separator                      equ ","

; module boot.inc
msg_frage_harddisk_or_memdisk           equ <"Doorgaan met [",setkeycolour,"h",setdefaultcolour,"]arde schijf, [",setkeycolour,"g",setdefaultcolour,"]eheugen schijf of [",setkeycolour,"d",setdefaultcolour,"]iskette ? ">
key_boot_harddisk                       equ "h"
key_boot_memdisk                        equ "g"
key_boot_floppy                         equ "d"
key_uninstall                           equ "u"
msg_meldung_Lesefehler                  equ "Leesfout"
msg_meldung_no_bootable_partition       equ "Geen startbare partitie gevonden."
msg_meldung_bootsector_invalid          equ "Opstart sector aanduiding ontbreekt."

; module call_csm.inc
msg_os2csm_not_found                    equ "Het programma onderdeel OS2CSM.BIN is niet gevonden."
msg_Invalid_OS2CSM_BIN                  equ "Ongeldige OS2CSM.BIN."
msg_file_is_to_big_to_load              equ "Een bestand is te groot om in te laden."
msg_Can_not_rename_OS_debug_file_missing equ "Kan niet hernoemen: OS debug bestand ontbreekt."

; module cdloader.tas
msg_loading_part2                       equ "Laden van tweede code gedeelte ... "

; module cd_menu.inc
msg_function_not_implemented            equ <"Functie nog niet ge‹mplementeerd.",13,10,"Druk een toets om verder te gaan",keypress,13,10,0>
msg_bootsector_read_error               equ <"Opstart sector leesfout.",13,10,"Druk een toets om verder te gaan",keypress,13,10,0>
msg_bootsector_invalid_format           equ <"Opstart sector is ongeldig.",13,10,"Druk een toets om verder te gaan",keypress,13,10,0>

; module dep16s.inc
msg_invalid_packed_data_header          equ "Ongeldige compressie header gevonden."
msg_packed_data_CRC_failed              equ "Ingepakte gegevens CRC mislukt."
msg_unpacking_data_failed               equ "Uitpakken van gegevens mislukt."
msg_unpacked_data_CRC_failed            equ "Uitpakken van gegevens CRC mislukt."

; module driveacc.inc
msg_swap_drive_insert                   equ " Voeg "
msg_swap_drive_additional_floppy        equ "opstart bijwerkmedium (indien beschikbaar)"
msg_swap_drive_main_bootdisk            equ "hoofd opstartmedium"
msg_swap_drive_harddisk                 equ "harde schijf"
msg_swap_drive_press_key                equ <", ",13,10," in en druk een toets ">

; module format.inc
msg_Memory_disk_memory_is_corrupted     equ "Geheugen schijfgeheugen is corrupt."
msg_MemDisk_sector_read_error0          equ "MemDisk sector leesfout"
msg_MemDisk_sector_read_error1          equ "."
msg_MemDisk_sector_write_error0         equ "MemDisk sector schrijffout"
msg_MemDisk_sector_write_error1         equ "."

; module inithd.inc

; module int_0_6.inc
msg_divide_by_zero                      equ "Deling door nul"
msg_invalid_opcode                      equ "Ongeldige opcode"

; module int13.inc
msg_int13_problem_protected_mode        equ <seterrorcolour,"Problemen met het benaderen van schijfgeheugen: al in beschermde modus.",setdefaultcolour>

; module int15a.inc
msg_int15a_e820                         equ "gebruikt INT 15 EAX=E820 'SMAP'"
msg_int15a_e881                         equ "gebruikt INT 15 AX=e881 'Phoenix 4.0 32-bit'"
msg_int15a_c7                           equ "gebruikt INT 15 AH=C7 'PS/2'"
msg_int15a_e801                         equ "gebruikt INT 15 AX=e801 'Phoenix 4.0 16-bit'"
msg_int15a_8a                           equ "gebruikt INT 15 AH=8A 'Phoenix 4.0 big'"
msg_int15a_da88                         equ "gebruikt INT 15 AX=DA88 'AMI PCI'"
msg_int15a_88                           equ "gebruikt INT 15 AH=88 '286'"
msg_Detecting_extended_memory_size      equ "Detecteren grootte uitgebreid geheugen ... "
msg_MB_starting_at_1_MB                 equ " MB begint op 1 MB"
msg_MB_starting_at_16_MB                equ " MB begint op 16 MB"
msg_Using_KB_at_Address_1               equ "Gebruik "
msg_Using_KB_at_Address_2               equ " bytes op adres "
msg_Using_KB_at_Address_3               equ "."
msg_failed                              equ "mislukt."
msg_Not_enough_memory                   equ "Niet genoeg geheugen"

; module memalloc.inc
msg_DOS_memory_allocation_failed        equ "DOS geheugen allocatie mislukt"
msg_No_free_harddisk_drive_number       equ "Geen harde schijf nummer beschikbaar"
msg_CD_ROM_emulation_terminated         equ "Cd-rom emulatie afgesloten."
msg_CD_ROM_emulation_did_not_terminate  equ "Cd-rom emulatie niet succesvol afgesloten."
msg_title_dos                           equ <cls,"MemDisk [DOS] ">
msg_title_bios                          equ <cls,"MemDisk "> ; [BIOS]
msg_title_dos_cdloader                  equ <cls,"CDLoader [DOS] ">
msg_title_bios_cdloader                 equ <cls,"CDLoader "> ; [BIOS]
msg_bootdrive_floppyharddisk            equ "Opstarten vanaf diskette of harde schijf ("
msg_bootdrive_cdnoemu                   equ "Opstarten vanaf Cd-rom in 'Niet Emulatie' modus ("
msg_bootdrive2                          equ <").">
msg_Disk_0x_installed_1                 equ "Diskette station "
msg_Disk_0x_installed_3                 equ ": ge‹nstalleerd."
msg_Disk_8x_installed_1                 equ "Schijf "
msg_Disk_8x_installed_3                 equ ": ge‹nstalleerd."
msg_MEMBOOT_BIN_corrupted_fragmented    equ <cd_boot_memboot_bin," corrupt/gefragmenteerd.">
msg_already_present_SCAD                equ "MemDisk al actief in het geheugen. Druk op Shift+Ctrl+Alt+Del om te herstarten."

; module memload.inc
msg_Disk_has_invalid_format             equ <"Schijf heeft ongeldig formaat.",13,10,"Voer a.u.b. andere media in en druk een toets om opnieuw te proberen.">
msg_Insert_floppy_with_label_press_key_1 equ "Voer diskette in met label '"
msg_Insert_floppy_with_label_press_key_2 equ "' en druk op een toets."
msg_Insert_floppy_with_file_press_key_1 equ "Voer diskette in met bestand '"
msg_Insert_floppy_with_file_press_key_2 equ "' en druk op een toets."
msg_invalid_partition_table_on_memdisk  equ "ongeldige partitietabel op de MemDisk."
msg_No_active_primary_or_extended_part  equ "Geen actieve primaire of uitgebreide partitie gevonden."
msg_Partition_on_memory_disk_is_not_FAT equ "Partitie op MemDisk is niet FAT geformatteerd."
msg_Asking_for_drive_parameters_failed1 equ "Opvragen van schijf parameters mislukt (schijf="
msg_Asking_for_drive_parameters_failed2 equ <").">

msg_Write_error_disk_full               equ "Schrijffout: schijf vol"
msg_directory_full                      equ "Directory vol."
msg_invalid_cluster_number_2            equ "Ongeldig cluster nummer (<2)"
msg_invalid_cluster_number_max          equ "Ongeldig cluster nummer (>max)"
msg_sector_read_error_0                 equ <"sector leesfout (schijf=">
msg_sector_read_error_1                 equ <", cylinder=">
msg_sector_read_error_2                 equ <", kop=">
msg_sector_read_error_3                 equ <", sector=">
msg_sector_read_error_4                 equ <").">
msg_hd_sector_read_error0               equ "Harde schijf sector leesfout (schijf="
msg_cd_sector_read_error0               equ "Cd-rom sector leesfout (schijf="
msg_cd_sector_read_error1               equ ", sector="
msg_cd_sector_read_error3               equ <").">
msg_invalid_VTOC                        equ "De inhoudstabel sector van de Cd-rom is ongeldig."
msg_can_not_find_boot_directory         equ <"Kan de directory met opstart bestanden op de Cd-rom (",cd_boot_memboot_bin,") niet vinden.">
msg_boot_directory_is_not_a_directory   equ "Directory met opstart bestanden op de Cd-rom is niet geldig."
msg_can_not_find_memboot_bin            equ <"Kan tweede deel van opstart code (",cd_boot_memboot_bin,") niet vinden.">
msg_memboot_bin_is_not_a_file           equ <"Tweede deel van opstart code (",cd_boot_memboot_bin,") is geen bestand.">
msg_to_many_files_in_cdrom_directory    equ "Te veel bestanden in de Cd-rom directory van de gecomprimeerde opstart bestanden."
msg_invalid_cd_function                 equ "Aanroep van interne functie is niet toegestaan voor Cd-rom."
msg_update_permissed_by_updatefile      equ "Bestandswijziging toegestaan: bestand gevonden 'BOOT_UPD.TXT'."
msg_update_permissed_by_volumelabel     equ "Bestandswijziging toegestaan: correct volume label 'BOOT_UPDATE'."
msg_update_not_permissed                equ "Geen bestandswijzigingen: geen indicatie bestand of passend label gevonden."
msg_query_geom_1                        equ "Fout bij opvragen geometrie van schijf "
msg_query_geom_3                        equ "."
mgs_k_errorcode_eq                      equ ", Code="

; module readme.inc
msg_readme_not_found                    equ "Het tekstbestand is niet gevonden."
msg_readme_file_is_to_large             equ "Het tekstbestand is te lang."
msg_readme_statusline1                  equ <" Regel #">
msg_readme_statusline2                  equ <"  ",019h,018h,"=bekijk bestand, F7=Zoek, Esc=stop ">
msg_Search_for                          equ "Zoek naar > "
msg_edit_statusline                     equ "F7=Zoek, Esc=stop"

msg_edithelp_tab                        equ 9
msg_edithelp_01                         equ "verplaatsen met cursor toetsen, PageUp/PageDown"
msg_edithelp_02                         equ "Ctrl+PageUp/PageDown=Begin/Einde van bestand"
msg_edithelp_03                         equ "Pos1/Einde=Begin/Einde van de regel"
msg_edithelp_04                         equ "Ctrl+Left/Right=ga naar begin van vorige/volgende woord"
msg_edithelp_05                         equ "Ctrl+Backspace/T/Y=Verwijder woord links/rechts/Verwijder regel"
msg_edithelp_06                         equ "F7=Zoek, Shift+F7=Verder zoeken"
msg_edithelp_07                         equ "Ctrl+Ins=Kopieer regel naar klembord"
msg_edithelp_08                         equ "Shift+Ins=Voeg regel vanuit klembord in"
msg_edithelp_09                         equ "Ins=schakel tussen Invoegen/Overschrijven modus"
msg_edithelp_10                         equ "Esc=stop en vraag om wijzigingen op te slaan"
msg_edithelp_key                        equ "Druk op een toets"

msg_edit_save_changes                   equ "Wijzigingen opslaan (j/n/Esc)? "
key_edit_save_changes_yes               equ "j"
key_edit_save_changes_no                equ "n"


; module speicher.inc
msg_memory_block_corrupted              equ "Geheugen control block beschadigd."
msg_Error_allocating_heap_memory        equ "Geen vrij geheugen."

; module unpackfi.inc
msg_Zero_length_file                    equ "Bestand heeft lengte van 0."
msg_Unknown_format_damaged_archive      equ "Beschadigd archief of ongekoppeld bestand."
msg_packfile_unkn_command               equ "Packfile opdracht is onbekend/niet ge‹mplementeerd."
msg_incorrect_archive_version           equ "Onjuiste archief versie."
msg_unpack_error_no_data                equ "Uitpak fout: geen gegevens."
msg_useless_data_in_archive             equ "Onbruikbare gegevens in archief."

; module xms.inc
msg_No_XMS_2_driver                     equ "Geen XMS 2+ stuurprogramma aanwezig."
msg_Error_allocating_XMS_memory         equ "Fout bij toewijzen XMS geheugen."
msg_Error_determining_physical_address  equ "Fout bij het vaststellen van fysiek adres."
