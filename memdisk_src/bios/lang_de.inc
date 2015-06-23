Title           language dependant strings: german

; module a20.inc
msg_Failed_to_restore_A20_gate          equ "Zustand der A20-Leitung kann nicht wiederhergestellt werden."
;obsoleted
;msg_Returned_successfully_but_A20_rf    equ "Fehlerfreier Funktionsaufruf, aber A20-Leitung wurde nicht wiederhergestellt."

; module ausschri.inc
thousand_separator                      equ "."

; module boot.inc
msg_frage_harddisk_or_memdisk           equ <"Laden des Betriebssystems von [",setkeycolour,"F",setdefaultcolour,"]estplatte, [",setkeycolour,"M",setdefaultcolour,"]emDisk oder [",setkeycolour,"D",setdefaultcolour,"]iskette? ">
key_boot_harddisk                       equ "f"
key_boot_memdisk                        equ "m"
key_boot_floppy                         equ "d"
key_uninstall                           equ "u"
msg_meldung_Lesefehler                  equ "Lesefehler"
msg_meldung_no_bootable_partition       equ "Keine startbare Partition gefunden."
msg_meldung_bootsector_invalid          equ "Die Startsektorkennung fehlt."

; module call_csm.inc
msg_os2csm_not_found                    equ "Das Programmodul OS2CSM.BIN wurde nicht gefunden."
msg_Invalid_OS2CSM_BIN                  equ "OS2CSM.BIN ist beschÑdigt."
msg_file_is_to_big_to_load              equ "Eine Datei ist zu gro·, um geladen zu werden."
msg_Can_not_rename_OS_debug_file_missing equ "Kann Datei nicht umbenennen: Debug-Kernel oder Lader fehlt."

; module cdloader.tas
msg_loading_part2                       equ "Lade zweiten Programmteil ... "

; module cd_menu.inc
msg_function_not_implemented            equ <"Funktion ist noch nicht eingebaut.",13,10,"Weiter mit Tastendruck",keypress,13,10,0>
msg_bootsector_read_error               equ <"Der Startsektor konnte nicht geladen werden.",13,10,"Weiter mit Tastendruck",keypress,13,10,0>
msg_bootsector_invalid_format           equ <"Der Startsektor ist ungÅltig.",13,10,"Weiter mit Tastendruck",keypress,13,10,0>


; module dep16s.inc
msg_invalid_packed_data_header          equ "UngÅltigen Kopf eines Kompressionsblockes gefunden."
msg_packed_data_CRC_failed              equ "PrÅfsummenfehler vor dem Entpacken der Daten."
msg_unpacking_data_failed               equ "Entpacken der Daten fehlgeschlagen."
msg_unpacked_data_CRC_failed            equ "PrÅfsummenfehler beim Entpacken der Daten."

; module driveacc.inc
msg_swap_drive_insert                   equ " Bitte legen Sie "
msg_swap_drive_additional_floppy        equ "das Aktualisierungsmedien (wenn vorhanden)"
msg_swap_drive_main_bootdisk            equ "das Startmedium"
msg_swap_drive_harddisk                 equ "die Festplatte"
msg_swap_drive_press_key                equ <" ein, ",13,10," und drÅcken Sie eine Taste ">

; module format.inc
msg_Memory_disk_memory_is_corrupted     equ "MemDisk-Speicher wurde Åberschrieben."
msg_MemDisk_sector_read_error0          equ "MemDisk Sektor-Lesefehler"
msg_MemDisk_sector_read_error1          equ "."
msg_MemDisk_sector_write_error0         equ "MemDisk Sektor-Schreibfehler"
msg_MemDisk_sector_write_error1         equ "."

; module inithd.inc
;warning_9e00box1 equ "Warnung: Speicherbenutzung unter 9e00:0.                       "
;warning_9e00box2 equ "Das kann Probleme in *S506.ADD erzeugen.                       "
;warning_9e00box3 equ "Lîsung: benutzen Sie DaniS506 /!Bios                           "
;warning_9e00box4 equ "und/oder richten Sie auf allen Platten gÅltige partitionen ein."
;
;                                        ; following messages are printed as:
;                                        ;   "Initialize unpartitioned harddisk 80 and"
;                                        ;   "a placeholder extended partition (y/n)? "
;msg_question_init_hd1                   equ <"Unpartitionierte Festplatte ">
;msg_question_init_hd2                   equ <" initialisieren und",13,10,"Platzhalterpartition erstellen (j/n)? ">
;key_question_init_hd_yes                equ "j"
;key_question_init_hd_no                 equ "n"

; module int_0_6.inc
msg_divide_by_zero                      equ "Division durch Null"
msg_invalid_opcode                      equ "UngÅltiger Befehlskode"


; module int13.inc
msg_int13_problem_protected_mode        equ <seterrorcolour,"Kann nicht auf Speicher zugreifen: CPU schon im geschÅtzten Modus.",setdefaultcolour>

; module int15a.inc
msg_int15a_e820                         equ "mit INT 15 EAX=E820 'SMAP'"
msg_int15a_e881                         equ "mit INT 15 AX=e881 'Phoenix 4.0 32-bit'"
msg_int15a_c7                           equ "mit INT 15 AH=C7 'PS/2'"
msg_int15a_e801                         equ "mit INT 15 AX=e801 'Phoenix 4.0 16-bit'"
msg_int15a_8a                           equ "mit INT 15 AH=8A 'Phoenix 4.0 big'"
msg_int15a_da88                         equ "mit INT 15 AX=DA88 'AMI PCI'"
msg_int15a_88                           equ "mit INT 15 AH=88 '286'"
;msg_Detecting_extended_memory_size     equ "Ermittle Grî·e des erweiterten Speichers ... "
msg_Detecting_extended_memory_size      equ "Ermittle Speichergrî·e ... "
msg_MB_starting_at_1_MB                 equ " MB ab 1 MB"
msg_MB_starting_at_16_MB                equ " MB ab 16 MB"
msg_Using_KB_at_Address_1               equ "Benutze "
msg_Using_KB_at_Address_2               equ " Byte ab Adresse "
msg_Using_KB_at_Address_3               equ "."
msg_failed                              equ "- fehlgeschlagen."
msg_Not_enough_memory                   equ "Nicht genug Speicher."

; module memalloc.inc
msg_DOS_memory_allocation_failed        equ "DOS-Speicheranforderung fehlgeschlagen."
msg_No_free_harddisk_drive_number       equ "Keine freie Festplattennummer verfÅgbar."
msg_CD_ROM_emulation_terminated         equ "CD-ROM-Startemulation beendet."
msg_CD_ROM_emulation_did_not_terminate  equ "CD-ROM-Startemulation konnte nicht beendet werden."
msg_title_dos                           equ <cls,"MemDisk [DOS] ">
msg_title_bios                          equ <cls,"MemDisk "> ; [BIOS]
msg_title_dos_cdloader                  equ <cls,"CDLoader [DOS] ">
msg_title_bios_cdloader                 equ <cls,"CDLoader "> ; [BIOS]
msg_bootdrive_floppyharddisk            equ "Startlaufwerk ist Diskette/Festplatte ("
msg_bootdrive_cdnoemu                   equ "Startlaufwerk ist CD im 'No Emulation'-Modus ("
msg_bootdrive2                          equ <").">
msg_Disk_0x_installed_1                 equ "Diskettenlaufwerk "
msg_Disk_0x_installed_3                 equ ": installiert."
msg_Disk_8x_installed_1                 equ "Festplatte "
msg_Disk_8x_installed_3                 equ ": installiert."
msg_MEMBOOT_BIN_corrupted_fragmented    equ <cd_boot_memboot_bin," ist beschÑdigt/fragmentiert.">
msg_already_present_SCAD                equ <"MemDisk ist bereits im Speicher.",13,10,"DrÅcken Sie Umschalt+Strg+Alt+Entf zum Neustart.">

; module memload.inc
msg_Disk_has_invalid_format             equ <"Diskette hat ungÅltiges Format.",13,10,"Bitte auswechseln und eine Taste drÅcken.">
msg_Insert_floppy_with_label_press_key_1 equ "Bitte legen Sie die Diskette '"
msg_Insert_floppy_with_label_press_key_2 equ "' ein und drÅcken Sie eine Taste."
msg_Insert_floppy_with_file_press_key_1 equ "Bitte legen Sie die Diskette mit der Datei '"
msg_Insert_floppy_with_file_press_key_2 equ <"' ein",13,10,"und drÅcken Sie eine Taste.">
msg_invalid_partition_table_on_memdisk  equ "UngÅltige Partitionstabelle auf dem Speicherlaufwerk."
msg_No_active_primary_or_extended_part  equ "Es wurde keine startbare primÑre oder erweiterte Partition gefunden."
msg_Partition_on_memory_disk_is_not_FAT equ "Dateisystem auf dem Speicherlaufwerk ist nicht FAT."
msg_Asking_for_drive_parameters_failed1 equ "Abfrage der Laufwerksgeometrie fehlgeschlagen (Laufwerk="
msg_Asking_for_drive_parameters_failed2 equ <").">
msg_Write_error_disk_full               equ "Schreibfehler: Platte voll."
msg_directory_full                      equ "Verzeichnis voll."
msg_invalid_cluster_number_2            equ "UngÅltige Blocknummer (<2)"
msg_invalid_cluster_number_max          equ "UngÅltige Blocknummer (>max)"
msg_sector_read_error_0                 equ "Sektor-Lesefehler (Laufwerk="
msg_sector_read_error_1                 equ ", Zylinder="
msg_sector_read_error_2                 equ ", Kopf="
msg_sector_read_error_3                 equ ", Sektor="
msg_sector_read_error_4                 equ <").">
msg_hd_sector_read_error0               equ "Festplatten-Lesefehler (Laufwerk="
msg_cd_sector_read_error0               equ "CD-Sektor-Lesefehler (Laufwerk="
msg_cd_sector_read_error1               equ ", Sektor="
msg_cd_sector_read_error3               equ <").">
msg_invalid_VTOC                        equ "Der Inhaltsverzeichnissektor der CD-ROM ist ungÅltig."
msg_can_not_find_boot_directory         equ "Das Verzeichnis mit den Startdateien konnte auf der CD-ROM nicht gefunden werden."
msg_boot_directory_is_not_a_directory   equ "Das Verzeichnis mit den Startdateien ist kein Verzeichnis auf der CD-ROM."
msg_can_not_find_memboot_bin            equ <"Kann zweiten Teil des Startprogrammes (",cd_boot_memboot_bin,") nicht finden.">
msg_memboot_bin_is_not_a_file           equ "Der zweite Teil des Startprogrammes auf der CD-ROM ist keine Datei."
msg_to_many_files_in_cdrom_directory    equ <"Es sind zu viele Dateien im Startverzeichnis (",cd_boot_directory,") auf der CD-ROM.">
msg_invalid_cd_function                 equ "Es wurde eine interne Funkion aufgerufen, deren Verwendung fÅr CD-ROM nicht zulÑssig ist."
msg_update_permissed_by_updatefile      equ "öberschreiben von Dateien erlaubt: Kenndatei 'BOOT_UPD.TXT' wurde gefunden."
msg_update_permissed_by_volumelabel     equ "öberschreiben von Dateien erlaubt: DatentrÑgername ist 'BOOT_UPDATE'."
msg_update_not_permissed                equ "Kein öberschreiben von Dateien: Kenndatei oder DatentrÑgername fehlt."
msg_query_geom_1                        equ "Fehler beim Ermittling der Geometrie-Daten fÅr Laufwerk "
msg_query_geom_3                        equ "."
mgs_k_errorcode_eq                      equ ", Fehlernummer="


; module readme.inc
msg_readme_not_found                    equ "Die Textdatei wurde nicht gefunden."
msg_readme_file_is_to_large             equ "Die Textdatei ist zu gro·."
msg_readme_statusline1                  equ <" Zeile #">
msg_readme_statusline2                  equ <"  ",019h,018h,"=Betrachten, F7=Suche, Esc=Ende ">
msg_Search_for                          equ "Suche nach > "
msg_edit_statusline                     equ "F7=Suche, Esc=Ende"

msg_edithelp_tab                        equ 9
msg_edithelp_01                         equ "Bewegen mit Richungstatsen, Bildauf, Bildab"
msg_edithelp_02                         equ "Strg+Bildauf/Bildab=Anfang/Ende der Datei"
msg_edithelp_03                         equ "Pos1/Ende=Sprung zum Zeilenanfang/Zeilenende"
msg_edithelp_04                         equ "Strg+Links/Rechts=Sprung zum Anfang des vorhergehenden/nÑchsten Wortes"
msg_edithelp_05                         equ "Strg+RÅck/T/Y=Wort links/rechts/ganze Zeile lîschen"
msg_edithelp_06                         equ "F7=Suchen, Umschalt+F7=Weitersuchen"
msg_edithelp_07                         equ "Strg+Einfg=Zeile in die Zwischenablage kopieren"
msg_edithelp_08                         equ "Umschalt+Einfg=Zeile aus der Zwischenablage einfÅgen"
msg_edithelp_09                         equ "Einfg=Umschalten zwischen EinfÅge- und öberschreibmodus"
msg_edithelp_10                         equ "Esc=Beenden und Abfrage ob die énderungen gesichert werden sollen"
msg_edithelp_key                        equ "Weiter mit Tastendruck"

msg_edit_save_changes                   equ "énderungen Speichern (j/n/Esc)? "
key_edit_save_changes_yes               equ "j"
key_edit_save_changes_no                equ "n"

; module speicher.inc
msg_memory_block_corrupted              equ "Speicherblock beschÑdigt."
msg_Error_allocating_heap_memory        equ "Speichermangel."

; module unpackfi.inc
msg_Zero_length_file                    equ "Datei mit LÑnge 0."
msg_Unknown_format_damaged_archive      equ "BeschÑdigte Archivdatei oder Fremdformat."
msg_packfile_unkn_command               equ "Archivkommando ist unbekannt oder nicht implementiert."
msg_incorrect_archive_version           equ "Falsche Archivversion."
msg_unpack_error_no_data                equ "Fehler beim Entpacken: keine Daten vorhanden."
msg_useless_data_in_archive             equ "DatenmÅll am Ende des Archives."

; module xms.inc
msg_No_XMS_2_driver                     equ "Kein XMS 2+ Treiber im Speicher."
msg_Error_allocating_XMS_memory         equ "Fehler bei Anforderung von XMS-Speicher."
msg_Error_determining_physical_address  equ "Fehler bei Bestimmung der physikalischen Speicheradresse."
