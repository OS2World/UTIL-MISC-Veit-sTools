Title           language dependant strings: french

; merci, guillaume.gay@bigfoot.com

; module a20.inc
msg_Failed_to_restore_A20_gate          equ "êchec Ö la restauration du port A20."
;obsoleted
;msg_Returned_successfully_but_A20_rf   equ "Retour rÇussi mais Çchec de la restauration A20."

; module ausschri.inc
thousand_separator                      equ " "

; module boot.inc
msg_frage_harddisk_or_memdisk           equ <"Poursuite sur [",setkeycolour,"d",setdefaultcolour,"]isque dur, disque [",setkeycolour,"m",setdefaultcolour,"]Çmoire ou [",setkeycolour,"l",setdefaultcolour,"] de disquette ? ">
key_boot_harddisk                       equ "d"
key_boot_memdisk                        equ "m"
key_boot_floppy                         equ "l"
key_uninstall                           equ "u"
msg_meldung_Lesefehler                  equ "Erreur de lecture"
msg_meldung_no_bootable_partition       equ "Partition amoráable non trouvÇe."
msg_meldung_bootsector_invalid          equ "Signature de secteur d'amoráage manquante."

; module call_csm.inc
msg_os2csm_not_found                    equ "Module de programme OS2CSM.BIN non trouvÇ."
msg_Invalid_OS2CSM_BIN                  equ "OS2CSM.BIN non valide."
msg_file_is_to_big_to_load              equ "Fichier trop gros pour àtre chargÇ."
msg_Can_not_rename_OS_debug_file_missing equ "Renommage impossible : fichier de debugage manquant."

; module cdloader.tas
msg_loading_part2                       equ "Chargement de la deuxiäme portion de code ... "

; module cd_menu.inc
msg_function_not_implemented            equ <"Fonction non implÇmentÇe.",13,10,"Appuyer sur une touche pour continuer",keypress,13,10,0>
msg_bootsector_read_error               equ <"Erreur de lecture du secteur d'amoráage.",13,10,"Appuyer sur une touche pour continuer",keypress,13,10,0>
msg_bootsector_invalid_format           equ <"Secteur d'amoráage non valide.",13,10,"Appuyer sur une touche pour continuer",keypress,13,10,0>

; module dep16s.inc
msg_invalid_packed_data_header          equ "Entàte de compression non valide trouvÇ."
msg_packed_data_CRC_failed              equ "êchec du calcul CRC sur les donnÇes compactÇes."
msg_unpacking_data_failed               equ "êchec Ö la dÇcompression des donnÇes."
msg_unpacked_data_CRC_failed            equ "êchec du calcul CRC sur les donnÇes dÇcompactÇes."

; module driveacc.inc
msg_swap_drive_insert                   equ " InsÇrer"
msg_swap_drive_additional_floppy        equ "media de m. Ö j. amoráable (si disponible)"
msg_swap_drive_main_bootdisk            equ "media d'amoráage principal"
msg_swap_drive_harddisk                 equ "disque dur"
msg_swap_drive_press_key                equ <", ",13,10," et appuyer sur une touche ">

; module format.inc
msg_Memory_disk_memory_is_corrupted     equ "mÇmoire du disque mÇmoire corrompue."
msg_MemDisk_sector_read_error0          equ "Erreur de lecture du secteur du disque mÇmoire "
msg_MemDisk_sector_read_error1          equ "."
msg_MemDisk_sector_write_error0         equ "Erreur d'Çcriture sur secteur du disque mÇmoire "
msg_MemDisk_sector_write_error1         equ "."

; module inithd.inc
;warning_9e00box1 equ "Avertissement : utilisation de la mÇmoire sous 9e00:0.  "
;warning_9e00box2 equ "Peut causer des problämes de crÇation miniVDM *S506.ADD."
;warning_9e00box3 equ "Solution: utiliser l'option DaniS506 /!Bios             "
;warning_9e00box4 equ "et/ou initialiser tous les diques durs                  "
;
;                                        ; following messages are printed as:
;                                        ;   "Initialize unpartitioned harddisk 80 and"
;                                        ;   "a placeholder extended partition (o/n)? "
;msg_question_init_hd1                   equ <"Initialiser les disques non partionnÇs ">
;msg_question_init_hd2                   equ <" et",13,10,"crÇer une partiton Çtendue (o/n) ? ">
;key_question_init_hd_yes                equ "o"
;key_question_init_hd_no                 equ "n"

; module int_0_6.inc
msg_divide_by_zero                      equ "Division par zÇro"
msg_invalid_opcode                      equ "Opcode non valide"

; module int13.inc
msg_int13_problem_protected_mode        equ <seterrorcolour,"Probläme d'accäs au disque mÇmoire : dÇjÖ en mode protÇgÇ.",setdefaultcolour>

; module int15a.inc
msg_int15a_e820                         equ "utilisation de l'INT 15 EAX=E820 'SMAP'"
msg_int15a_e881                         equ "utilisation de l'INT 15 AX=e881 'Phoenix 4.0 32-bit'"
msg_int15a_c7                           equ "utilisation de l'INT 15 AH=C7 'PS/2'"
msg_int15a_e801                         equ "utilisation de l'INT 15 AX=e801 'Phoenix 4.0 16-bit'"
msg_int15a_8a                           equ "utilisation de l'INT 15 AH=8A 'Phoenix 4.0 big'"
msg_int15a_da88                         equ "utilisation de l'INT 15 AX=DA88 'AMI PCI'"
msg_int15a_88                           equ "utilisation de l'INT 15 AH=88 '286'"
msg_Detecting_extended_memory_size      equ "DÇtection de la taille de la mÇmoire Çtendue ... "
msg_MB_starting_at_1_MB                 equ " Mo Ö partir de 1 Mo"
msg_MB_starting_at_16_MB                equ " Mo Ö partir de 16 Mo"
msg_Using_KB_at_Address_1               equ "Utilisation de "
msg_Using_KB_at_Address_2               equ " octets Ö l'adresse "
msg_Using_KB_at_Address_3               equ "."
msg_failed                              equ "Çchec."
msg_Not_enough_memory                   equ "MÇmoire insuffisante"

; module memalloc.inc
msg_DOS_memory_allocation_failed        equ "êchec Ö l'allocation la mÇmoire DOS"
msg_No_free_harddisk_drive_number       equ "Pas de numÇro de disque dur libre"
msg_CD_ROM_emulation_terminated         equ "Fin de l'Çmulation du CD-ROM."
msg_CD_ROM_emulation_did_not_terminate  equ "êchec Ö la fin de l'Çmulation du CD-ROM."
msg_title_dos                           equ <cls,"DisqueMÇmoire [DOS] ">
msg_title_bios                          equ <cls,"DisqueMÇmoire "> ; [BIOS]
msg_title_dos_cdloader                  equ <cls,"ChargeurCD [DOS] ">
msg_title_bios_cdloader                 equ <cls,"ChargeurCD "> ; [BIOS]
msg_bootdrive_floppyharddisk            equ "Amoráage sur disquette ou disque dur ("
msg_bootdrive_cdnoemu                   equ "Amoráage sur le CD-ROM en mode 'Sans Çmulation' ("
msg_bootdrive2                          equ <").">
msg_Disk_0x_installed_1                 equ "Lecteur de disquette "
msg_Disk_0x_installed_3                 equ ": installÇ."
msg_Disk_8x_installed_1                 equ "Disque "
msg_Disk_8x_installed_3                 equ ": installÇ."
msg_MEMBOOT_BIN_corrupted_fragmented    equ <cd_boot_memboot_bin," corrompu/fragmentÇ.">
msg_already_present_SCAD                equ "MemDisk dÇjÖ actif en mÇmoire. Appuyer sur Maj+Ctrl+Alt+Suppr pour relancer le systäme."

; module memload.inc
msg_Disk_has_invalid_format             equ <"Disque au format non valide.",13,10,"Veuillez insÇrer un autre media et appuyer sur une touche pour rÇessayer.">
msg_Insert_floppy_with_label_press_key_1 equ "InsÇrer la disquette ÇtiquetÇe '"
msg_Insert_floppy_with_label_press_key_2 equ "' et appuyer sur une touche."
msg_Insert_floppy_with_file_press_key_1 equ "InsÇrer la disquette contenant le fichier '"
msg_Insert_floppy_with_file_press_key_2 equ "' et appuyer sur une touche."
msg_invalid_partition_table_on_memdisk  equ "table de partiton du disque mÇmoire non valide."
msg_No_active_primary_or_extended_part  equ "Aucune partition active principale ou Çtendue trouvÇe."
msg_Partition_on_memory_disk_is_not_FAT equ "La partition du disque mÇmoire n'est pas formatÇe FAT."
msg_Asking_for_drive_parameters_failed1 equ "êchec de la requàte des paramätres de l'unitÇ (unitÇ="
msg_Asking_for_drive_parameters_failed2 equ <").">

msg_Write_error_disk_full               equ "Erreur d'Çcriture : disque plein"
msg_directory_full                      equ "RÇpertoire plein."
msg_invalid_cluster_number_2            equ "Nombre de clusters non valide (<2)"
msg_invalid_cluster_number_max          equ "Nombre de clusters non valide (>max)"
msg_sector_read_error_0                 equ <"erreur Ö la lecture des secteurs (unitÇ=">
msg_sector_read_error_1                 equ <", cylindre(s)=">
msg_sector_read_error_2                 equ <", tàte(s)=">
msg_sector_read_error_3                 equ <", secteur(s)=">
msg_sector_read_error_4                 equ <").">
msg_hd_sector_read_error0               equ "Erreur Ö la lecture de secteurs du disque dur (unitÇ="
msg_cd_sector_read_error0               equ "Erreur Ö la lecture de secteurs du CD-ROM (unitÇ="
msg_cd_sector_read_error1               equ ", secteur="
msg_cd_sector_read_error3               equ <").">
msg_invalid_VTOC                        equ "Secteur de table des matiäres du CD-ROM non valide."
msg_can_not_find_boot_directory         equ <"RÇpertoire des fichiers d'amoráage du CD-ROM introuvable (",cd_boot_memboot_bin,").">
msg_boot_directory_is_not_a_directory   equ "Le rÇpertoire des fichiers d'amoráage du CD-ROM n'est pas un rÇpertoire."
msg_can_not_find_memboot_bin            equ <"Seconde partie du code d'amoráage introuvable (",cd_boot_memboot_bin,").">
msg_memboot_bin_is_not_a_file           equ <"La seconde partie du code d'amoráage (",cd_boot_memboot_bin,") n'est pas un fichier.">
msg_to_many_files_in_cdrom_directory    equ "Trop de fichiers dans le rÇpertoire des fichiers d'amoráage compactÇs du CD-ROM."
msg_invalid_cd_function                 equ "Appel de fonction interne non autorisÇe sur un CD-ROM."
msg_update_permissed_by_updatefile      equ "Mise Ö jour de fichiers autorisÇe : fichier 'BOOT_UPD.TXT' trouvÇ."
msg_update_permissed_by_volumelabel     equ "Mise Ö jour de fichiers autorisÇe : label de volume 'BOOT_UPDATE' correspondant."
msg_update_not_permissed                equ "Pas de mise Ö jour de fichiers : aucun fichier indicateur ni label correspondant trouvÇ."
msg_query_geom_1                        equ "Erreur Ö la requàte de gÇomÇtrie du disque "
msg_query_geom_3                        equ "."
mgs_k_errorcode_eq                      equ ", Code="

; module readme.inc
msg_readme_not_found                    equ "Fichier texte non trouvÇ."
msg_readme_file_is_to_large             equ "Fichier texte trop grand."
msg_readme_statusline1                  equ <" Ligne n¯">
msg_readme_statusline2                  equ <"  ",019h,018h,"=voir fichier, F7=Recherche, êchap=Quitter ">
msg_Search_for                          equ "Rechercher > "
msg_edit_statusline                     equ "F7=Recherche, êchap=Quitter"

msg_edithelp_tab                        equ 9
msg_edithelp_01                         equ "dÇplacez-vous en utilisant les touches curseur, PageHaut/PageBas"
msg_edithelp_02                         equ "Ctrl+PageHaut/PageBas=DÇbut/Fin de fichier"
msg_edithelp_03                         equ "DÇbut/Fin=DÇbut/Fin de ligne"
msg_edithelp_04                         equ "Ctrl+Gauche/Droite=dÇbut du mot prÇcÇdent/suivant"
msg_edithelp_05                         equ "Ctrl+RetArriäre/T/Y=Suppression de mot de gauche/mot de droite/ligne"
msg_edithelp_06                         equ "F7=Recherche, Maj+F7=Poursuivre"
msg_edithelp_07                         equ "Ctrl+Inser=Copier la ligne dans le presse-papiers"
msg_edithelp_08                         equ "Maj+Inser=Coller la ligne depuis le presse-papiers"
msg_edithelp_09                         equ "Inser=Basculer en mode Insertion/Refrappe"
msg_edithelp_10                         equ "êchap=Quitter et proposer de sauvegarder"
msg_edithelp_key                        equ "Appuyer sur une touche pour continuer"

msg_edit_save_changes                   equ "Sauvegarder les modifications (Oui/Non/êchap) ? "
key_edit_save_changes_yes               equ "o"
key_edit_save_changes_no                equ "n"

; module speicher.inc
msg_memory_block_corrupted              equ "Bloc de contrìle de mÇmoire corrompu."
msg_Error_allocating_heap_memory        equ "Hors limite mÇmoire."

; module unpackfi.inc
msg_Zero_length_file                    equ "Fichier de longueur nulle."
msg_Unknown_format_damaged_archive      equ "Archive ou fichier endommagÇ."
msg_packfile_unkn_command               equ "Commande d'archive inconnue ou non implementÇe."
msg_incorrect_archive_version           equ "Version d'archive incorrecte."
msg_unpack_error_no_data                equ "Erreur de dÇcompression : pas de donnÇes."
msg_useless_data_in_archive             equ "DonnÇes inutiles dans l'archive."

; module xms.inc
msg_No_XMS_2_driver                     equ "Pilote XMS 2+ inexistant."
msg_Error_allocating_XMS_memory         equ "Erreur d'allocation de mÇmoire XMS."
msg_Error_determining_physical_address  equ "Erreur de dÇtermination de l'adresse physique."

