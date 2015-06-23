Title           language dependant strings: italian

; thanks to Gabriele Gamba

; module a20.inc
msg_Failed_to_restore_A20_gate          equ "Ripristino della porta A20 non riuscito."
;obsoleted
;msg_Returned_successfully_but_A20_rf    equ "Rientro riuscito, ma Š fallito il ripristino della porta A20."

; module ausschri.inc
thousand_separator                      equ ","

; module boot.inc
msg_frage_harddisk_or_memdisk           equ <"Proseguire da disco [",setkeycolour,"r",setdefaultcolour,"]igido, disco virtuale in [",setkeycolour,"m",setdefaultcolour,"]emoria o [",setkeycolour,"f",setdefaultcolour,"]loppy ? ">
key_boot_harddisk                       equ "r"
key_boot_memdisk                        equ "m"
key_boot_floppy                         equ "f"
key_uninstall                           equ "u"
msg_meldung_Lesefehler                  equ "Errore in lettura"
msg_meldung_no_bootable_partition       equ "Impossibile trovare una partizione avviabile."
msg_meldung_bootsector_invalid          equ "Indicazione settore di avvio mancante."

; module call_csm.inc
msg_os2csm_not_found                    equ "Impossibile trovare il modulo programma OS2CSM.BIN."
msg_Invalid_OS2CSM_BIN                  equ "OS2CSM.BIN non valido."
msg_file_is_to_big_to_load              equ "Uno dei file Š troppo grande per essere caricato."
msg_Can_not_rename_OS_debug_file_missing equ "Impossibile rinominare: manca il file debug del S. O."

; module cdloader.tas
msg_loading_part2                       equ "Caricamento in corso della seconda parte del codice ... "

; module cd_menu.inc
msg_function_not_implemented            equ <"Funzione non ancora implementata.",13,10,"Premere un tasto per continuare",keypress,13,10,0>
msg_bootsector_read_error               equ <"Errore in lettura settore di avvio.",13,10,"Premere un tasto per continuare",keypress,13,10,0>
msg_bootsector_invalid_format           equ <"Settore di avvio non valido.",13,10,"Premere un tasto per continuare",keypress,13,10,0>

; module dep16s.inc
msg_invalid_packed_data_header          equ "L'intestazione compressione non Š valida."
msg_packed_data_CRC_failed              equ "Errore di CRC nei dati compressi."
msg_unpacking_data_failed               equ "Scompattamento dati fallito."
msg_unpacked_data_CRC_failed            equ "Errore di CRC nei file scompattati."

; module driveacc.inc
msg_swap_drive_insert                   equ " Inserire "
msg_swap_drive_additional_floppy        equ "il supporto di avvio aggiornato (se disponibile)"
msg_swap_drive_main_bootdisk            equ "il supporto di avvio principale"
msg_swap_drive_harddisk                 equ "il disco rigido"
msg_swap_drive_press_key                equ " e premere un tasto "

; module format.inc
msg_Memory_disk_memory_is_corrupted     equ "Memoria disco RAM corrotta."
msg_MemDisk_sector_read_error0          equ "Errore in lettura settore MemDisk"
msg_MemDisk_sector_read_error1          equ "."
msg_MemDisk_sector_write_error0         equ "Errore in scrittura settore MemDisk"
msg_MemDisk_sector_write_error1         equ "."

; module inithd.inc

; module int_0_6.inc
msg_divide_by_zero                      equ "Divisione per zero"
msg_invalid_opcode                      equ "Opcode non valido"

; module int13.inc
msg_int13_problem_protected_mode        equ <seterrorcolour,"Si Š verificato un problema accedendo al disco ram: si Š gi… in modalit… protetta.",setdefaultcolour>

; module int15a.inc
msg_int15a_e820                         equ "uso INT 15 EAX=E820 'SMAP'"
msg_int15a_e881                         equ "uso INT 15 AX=e881 'Phoenix 4.0 32-bit'"
msg_int15a_c7                           equ "uso INT 15 AH=C7 'PS/2'"
msg_int15a_e801                         equ "uso INT 15 AX=e801 'Phoenix 4.0 16-bit'"
msg_int15a_8a                           equ "uso INT 15 AH=8A 'Phoenix 4.0 big'"
msg_int15a_da88                         equ "uso INT 15 AX=DA88 'AMI PCI'"
msg_int15a_88                           equ "uso INT 15 AH=88 '286'"
msg_Detecting_extended_memory_size      equ "Rilevamento dimensione memoria estesa in corso ... "
msg_MB_starting_at_1_MB                 equ " La MB inizia ad 1 MB"
msg_MB_starting_at_16_MB                equ " La MB inizia a 16 MB"
msg_Using_KB_at_Address_1               equ "In uso "
msg_Using_KB_at_Address_2               equ " byte all'indirizzo "
msg_Using_KB_at_Address_3               equ "."
msg_failed                              equ "fallito."
msg_Not_enough_memory                   equ "Memoria insufficiente"

; module memalloc.inc
msg_DOS_memory_allocation_failed        equ "Allocazione memoria DOS fallita"
msg_No_free_harddisk_drive_number       equ "Nessun numero libero per l'unit… disco rigido"
msg_CD_ROM_emulation_terminated         equ "Emulazione avvio CD-ROM completata con successo."
msg_CD_ROM_emulation_did_not_terminate  equ "L'emulazione avvio CD-ROM non Š stata completata con successo."
msg_title_dos                           equ <cls,"MemDisk [DOS] ">
msg_title_bios                          equ <cls,"MemDisk "> ; [BIOS]
msg_title_dos_cdloader                  equ <cls,"CDLoader [DOS] ">
msg_title_bios_cdloader                 equ <cls,"CDLoader "> ; [BIOS]
msg_bootdrive_floppyharddisk            equ "L'unit… di avvio Š il floppy disk o il disco rigido ("
msg_bootdrive_cdnoemu                   equ "L'unit… di avvio Š il CD-ROM in modalit… 'Non Emulazione' ("
msg_bootdrive2                          equ <").">
msg_Disk_0x_installed_1                 equ "Unit… floppy "
msg_Disk_0x_installed_3                 equ ": installata."
msg_Disk_8x_installed_1                 equ "Disco "
msg_Disk_8x_installed_3                 equ ": installato."
msg_MEMBOOT_BIN_corrupted_fragmented    equ <cd_boot_memboot_bin," corrotto o frammentato.">
msg_already_present_SCAD                equ "MemDisk gi… attivo in memoria. Premere Maiusc+Ctrl+Alt+Del per riavviare."

; module memload.inc
msg_Disk_has_invalid_format             equ <"Il disco non ha un formato valido.",13,10,"Inserire un altro supporto e premere un tasto per riprovare.">
msg_Insert_floppy_with_label_press_key_1 equ "Inserire il floppy con etichetta '"
msg_Insert_floppy_with_label_press_key_2 equ "' e premere un tasto."
msg_Insert_floppy_with_file_press_key_1 equ "Inserire il floppy con il file '"
msg_Insert_floppy_with_file_press_key_2 equ "' e premere un tasto."
msg_invalid_partition_table_on_memdisk  equ "Tabella partizioni nel disco memoria non valida."
msg_No_active_primary_or_extended_part  equ "Non si Š trovata una partizione attiva, n‚ primaria n‚ estesa."
msg_Partition_on_memory_disk_is_not_FAT equ "La partizione nel disco memoria non Š FAT."
msg_Asking_for_drive_parameters_failed1 equ "Richiesta parametri unit… fallita (unit…="
msg_Asking_for_drive_parameters_failed2 equ <").">

msg_Write_error_disk_full               equ "Errore in scrittura: disco pieno"
msg_directory_full                      equ "Directory piena."
msg_invalid_cluster_number_2            equ "Numero cluster non valido (<2)"
msg_invalid_cluster_number_max          equ "Numero cluster non valido (>max)"
msg_sector_read_error_0                 equ <"errore lettura settore (unit…=">
msg_sector_read_error_1                 equ <", cilindro=">
msg_sector_read_error_2                 equ <", testina=">
msg_sector_read_error_3                 equ <", settore=">
msg_sector_read_error_4                 equ <").">
msg_hd_sector_read_error0               equ "Errore in lettura settore disco rigido (unit…="
msg_cd_sector_read_error0               equ "Errore in lettura settore CD-ROM (unit…="
msg_cd_sector_read_error1               equ ", settore="
msg_cd_sector_read_error3               equ <").">
msg_invalid_VTOC                        equ "La tabella del settore contenuti del CD-ROM non Š valida."
msg_can_not_find_boot_directory         equ <"Impossibile trovare sul CD-ROM la cartella con i file di avvio (",cd_boot_memboot_bin,").">
msg_boot_directory_is_not_a_directory   equ "La cartella con i file di avvio sul CD-ROM non Š una cartella."
msg_can_not_find_memboot_bin            equ <"Impossibile trovare la seconda parte del codice di avvio (",cd_boot_memboot_bin,").">
msg_memboot_bin_is_not_a_file           equ <"La seconda parte del codice di avvio (",cd_boot_memboot_bin,") non Š un file.">
msg_to_many_files_in_cdrom_directory    equ "Troppi file nella cartella con i file di avvio compressi sul CD-ROM."
msg_invalid_cd_function                 equ "Chiamata di funzione interna non permessa per il CD-ROM."
msg_update_permissed_by_updatefile      equ "Aggiornamento file autorizzato: il file 'BOOT_UPD.TXT' Š presente."
msg_update_permissed_by_volumelabel     equ "Aggiornamento file autorizzato: l'etichetta di volume Š 'BOOT_UPDATE'."
msg_update_not_permissed                equ "Nessun aggiornamento file: impossibile trovare il file indicatore o l'etichetta di volume corretta."
msg_query_geom_1                        equ "Errore nel determinare la geometria dell'unit… "
msg_query_geom_3                        equ "."
mgs_k_errorcode_eq                      equ ", Codice="

; module readme.inc
msg_readme_not_found                    equ "Il file di testo non Š stato trovato."
msg_readme_file_is_to_large             equ "Il file di testo Š troppo grande."
msg_readme_statusline1                  equ <" Linee #">
msg_readme_statusline2                  equ <"  ",019h,018h,"=vedi file, F7=Cerca, Esc=Esci ">
msg_Search_for                          equ "Ricerca > "
msg_edit_statusline                     equ "F7=Cerca, Esc=Esci"

msg_edithelp_tab                        equ <"    ">
msg_edithelp_01                         equ "ci si pu• spostare con i tasti cursore, PgSu/PgGi—"
msg_edithelp_02                         equ "Ctrl+PgSu/PgGi—=Inizio/fine del file"
msg_edithelp_03                         equ "Home/Fine=Inizio/fine della riga"
msg_edithelp_04                         equ "Ctrl+Sinistra/Destra=Va all'inizio della parola precedente/successiva"
msg_edithelp_05                         equ "Ctrl+Backspace/T/Y=Cancella la parola a sinistra/destra/cancella la riga"
msg_edithelp_06                         equ "F7=Cerca, Maiusc+F7=Cerca ancora"
msg_edithelp_07                         equ "Ctrl+Ins=Copia una riga negli Appunti"
msg_edithelp_08                         equ "Maiusc+Ins=Inserisce una riga dagli Appunti"
msg_edithelp_09                         equ "Ins=Passa dalla modalit… Inserisci a quella Sovrascrivi"
msg_edithelp_10                         equ "Esc=Esce e e chiede conferma per salvare le modifiche effettuate"
msg_edithelp_key                        equ "premere un tasto"

msg_edit_save_changes                   equ "Salvare le modifiche (s/n/Esc)? "
key_edit_save_changes_yes               equ "s"
key_edit_save_changes_no                equ "n"



; module speicher.inc
msg_memory_block_corrupted              equ "Blocco di controllo memoria corrotto."
msg_Error_allocating_heap_memory        equ "Memoria esaurita."

; module unpackfi.inc
msg_Zero_length_file                    equ "File di lunghezza zero."
msg_Unknown_format_damaged_archive      equ "Archivio danneggiato o formato file errato."
msg_packfile_unkn_command               equ "Il comando nell'archivio Š sconosciuto o non implementato."
msg_incorrect_archive_version           equ "Versione archivio non corretta."
msg_unpack_error_no_data                equ "Errore nello scompattamento: nessun dato."
msg_useless_data_in_archive             equ "Dati nell'archivio inutilizzabili."

; module xms.inc
msg_No_XMS_2_driver                     equ "Driver XMS 2+ non presente."
msg_Error_allocating_XMS_memory         equ "Errore nell'allocazione della memoria XMS."
msg_Error_determining_physical_address  equ "Errore nella determinazione dell'indirizzo fisico."

