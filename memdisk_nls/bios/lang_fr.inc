Title           language dependant strings: french

; merci, guillaume.gay@bigfoot.com

; module a20.inc
msg_Failed_to_restore_A20_gate          equ "�chec � la restauration du port A20."
;obsoleted
;msg_Returned_successfully_but_A20_rf   equ "Retour r�ussi mais �chec de la restauration A20."

; module ausschri.inc
thousand_separator                      equ " "

; module boot.inc
msg_frage_harddisk_or_memdisk           equ <"Poursuite sur [",setkeycolour,"d",setdefaultcolour,"]isque dur, disque [",setkeycolour,"m",setdefaultcolour,"]�moire ou [",setkeycolour,"l",setdefaultcolour,"] de disquette ? ">
key_boot_harddisk                       equ "d"
key_boot_memdisk                        equ "m"
key_boot_floppy                         equ "l"
key_uninstall                           equ "u"
msg_meldung_Lesefehler                  equ "Erreur de lecture"
msg_meldung_no_bootable_partition       equ "Partition amor�able non trouv�e."
msg_meldung_bootsector_invalid          equ "Signature de secteur d'amor�age manquante."

; module call_csm.inc
msg_os2csm_not_found                    equ "Module de programme OS2CSM.BIN non trouv�."
msg_Invalid_OS2CSM_BIN                  equ "OS2CSM.BIN non valide."
msg_file_is_to_big_to_load              equ "Fichier trop gros pour �tre charg�."
msg_Can_not_rename_OS_debug_file_missing equ "Renommage impossible : fichier de debugage manquant."

; module cdloader.tas
msg_loading_part2                       equ "Chargement de la deuxi�me portion de code ... "

; module cd_menu.inc
msg_function_not_implemented            equ <"Fonction non impl�ment�e.",13,10,"Appuyer sur une touche pour continuer",keypress,13,10,0>
msg_bootsector_read_error               equ <"Erreur de lecture du secteur d'amor�age.",13,10,"Appuyer sur une touche pour continuer",keypress,13,10,0>
msg_bootsector_invalid_format           equ <"Secteur d'amor�age non valide.",13,10,"Appuyer sur une touche pour continuer",keypress,13,10,0>

; module dep16s.inc
msg_invalid_packed_data_header          equ "Ent�te de compression non valide trouv�."
msg_packed_data_CRC_failed              equ "�chec du calcul CRC sur les donn�es compact�es."
msg_unpacking_data_failed               equ "�chec � la d�compression des donn�es."
msg_unpacked_data_CRC_failed            equ "�chec du calcul CRC sur les donn�es d�compact�es."

; module driveacc.inc
msg_swap_drive_insert                   equ " Ins�rer"
msg_swap_drive_additional_floppy        equ "media de m. � j. amor�able (si disponible)"
msg_swap_drive_main_bootdisk            equ "media d'amor�age principal"
msg_swap_drive_harddisk                 equ "disque dur"
msg_swap_drive_press_key                equ <", ",13,10," et appuyer sur une touche ">

; module format.inc
msg_Memory_disk_memory_is_corrupted     equ "m�moire du disque m�moire corrompue."
msg_MemDisk_sector_read_error0          equ "Erreur de lecture du secteur du disque m�moire "
msg_MemDisk_sector_read_error1          equ "."
msg_MemDisk_sector_write_error0         equ "Erreur d'�criture sur secteur du disque m�moire "
msg_MemDisk_sector_write_error1         equ "."

; module inithd.inc
;warning_9e00box1 equ "Avertissement : utilisation de la m�moire sous 9e00:0.  "
;warning_9e00box2 equ "Peut causer des probl�mes de cr�ation miniVDM *S506.ADD."
;warning_9e00box3 equ "Solution: utiliser l'option DaniS506 /!Bios             "
;warning_9e00box4 equ "et/ou initialiser tous les diques durs                  "
;
;                                        ; following messages are printed as:
;                                        ;   "Initialize unpartitioned harddisk 80 and"
;                                        ;   "a placeholder extended partition (o/n)? "
;msg_question_init_hd1                   equ <"Initialiser les disques non partionn�s ">
;msg_question_init_hd2                   equ <" et",13,10,"cr�er une partiton �tendue (o/n) ? ">
;key_question_init_hd_yes                equ "o"
;key_question_init_hd_no                 equ "n"

; module int_0_6.inc
msg_divide_by_zero                      equ "Division par z�ro"
msg_invalid_opcode                      equ "Opcode non valide"

; module int13.inc
msg_int13_problem_protected_mode        equ <seterrorcolour,"Probl�me d'acc�s au disque m�moire : d�j� en mode prot�g�.",setdefaultcolour>

; module int15a.inc
msg_int15a_e820                         equ "utilisation de l'INT 15 EAX=E820 'SMAP'"
msg_int15a_e881                         equ "utilisation de l'INT 15 AX=e881 'Phoenix 4.0 32-bit'"
msg_int15a_c7                           equ "utilisation de l'INT 15 AH=C7 'PS/2'"
msg_int15a_e801                         equ "utilisation de l'INT 15 AX=e801 'Phoenix 4.0 16-bit'"
msg_int15a_8a                           equ "utilisation de l'INT 15 AH=8A 'Phoenix 4.0 big'"
msg_int15a_da88                         equ "utilisation de l'INT 15 AX=DA88 'AMI PCI'"
msg_int15a_88                           equ "utilisation de l'INT 15 AH=88 '286'"
msg_Detecting_extended_memory_size      equ "D�tection de la taille de la m�moire �tendue ... "
msg_MB_starting_at_1_MB                 equ " Mo � partir de 1 Mo"
msg_MB_starting_at_16_MB                equ " Mo � partir de 16 Mo"
msg_Using_KB_at_Address_1               equ "Utilisation de "
msg_Using_KB_at_Address_2               equ " octets � l'adresse "
msg_Using_KB_at_Address_3               equ "."
msg_failed                              equ "�chec."
msg_Not_enough_memory                   equ "M�moire insuffisante"

; module memalloc.inc
msg_DOS_memory_allocation_failed        equ "�chec � l'allocation la m�moire DOS"
msg_No_free_harddisk_drive_number       equ "Pas de num�ro de disque dur libre"
msg_CD_ROM_emulation_terminated         equ "Fin de l'�mulation du CD-ROM."
msg_CD_ROM_emulation_did_not_terminate  equ "�chec � la fin de l'�mulation du CD-ROM."
msg_title_dos                           equ <cls,"DisqueM�moire [DOS] ">
msg_title_bios                          equ <cls,"DisqueM�moire "> ; [BIOS]
msg_title_dos_cdloader                  equ <cls,"ChargeurCD [DOS] ">
msg_title_bios_cdloader                 equ <cls,"ChargeurCD "> ; [BIOS]
msg_bootdrive_floppyharddisk            equ "Amor�age sur disquette ou disque dur ("
msg_bootdrive_cdnoemu                   equ "Amor�age sur le CD-ROM en mode 'Sans �mulation' ("
msg_bootdrive2                          equ <").">
msg_Disk_0x_installed_1                 equ "Lecteur de disquette "
msg_Disk_0x_installed_3                 equ ": install�."
msg_Disk_8x_installed_1                 equ "Disque "
msg_Disk_8x_installed_3                 equ ": install�."
msg_MEMBOOT_BIN_corrupted_fragmented    equ <cd_boot_memboot_bin," corrompu/fragment�.">
msg_already_present_SCAD                equ "MemDisk d�j� actif en m�moire. Appuyer sur Maj+Ctrl+Alt+Suppr pour relancer le syst�me."

; module memload.inc
msg_Disk_has_invalid_format             equ <"Disque au format non valide.",13,10,"Veuillez ins�rer un autre media et appuyer sur une touche pour r�essayer.">
msg_Insert_floppy_with_label_press_key_1 equ "Ins�rer la disquette �tiquet�e '"
msg_Insert_floppy_with_label_press_key_2 equ "' et appuyer sur une touche."
msg_Insert_floppy_with_file_press_key_1 equ "Ins�rer la disquette contenant le fichier '"
msg_Insert_floppy_with_file_press_key_2 equ "' et appuyer sur une touche."
msg_invalid_partition_table_on_memdisk  equ "table de partiton du disque m�moire non valide."
msg_No_active_primary_or_extended_part  equ "Aucune partition active principale ou �tendue trouv�e."
msg_Partition_on_memory_disk_is_not_FAT equ "La partition du disque m�moire n'est pas format�e FAT."
msg_Asking_for_drive_parameters_failed1 equ "�chec de la requ�te des param�tres de l'unit� (unit�="
msg_Asking_for_drive_parameters_failed2 equ <").">

msg_Write_error_disk_full               equ "Erreur d'�criture : disque plein"
msg_directory_full                      equ "R�pertoire plein."
msg_invalid_cluster_number_2            equ "Nombre de clusters non valide (<2)"
msg_invalid_cluster_number_max          equ "Nombre de clusters non valide (>max)"
msg_sector_read_error_0                 equ <"erreur � la lecture des secteurs (unit�=">
msg_sector_read_error_1                 equ <", cylindre(s)=">
msg_sector_read_error_2                 equ <", t�te(s)=">
msg_sector_read_error_3                 equ <", secteur(s)=">
msg_sector_read_error_4                 equ <").">
msg_hd_sector_read_error0               equ "Erreur � la lecture de secteurs du disque dur (unit�="
msg_cd_sector_read_error0               equ "Erreur � la lecture de secteurs du CD-ROM (unit�="
msg_cd_sector_read_error1               equ ", secteur="
msg_cd_sector_read_error3               equ <").">
msg_invalid_VTOC                        equ "Secteur de table des mati�res du CD-ROM non valide."
msg_can_not_find_boot_directory         equ <"R�pertoire des fichiers d'amor�age du CD-ROM introuvable (",cd_boot_memboot_bin,").">
msg_boot_directory_is_not_a_directory   equ "Le r�pertoire des fichiers d'amor�age du CD-ROM n'est pas un r�pertoire."
msg_can_not_find_memboot_bin            equ <"Seconde partie du code d'amor�age introuvable (",cd_boot_memboot_bin,").">
msg_memboot_bin_is_not_a_file           equ <"La seconde partie du code d'amor�age (",cd_boot_memboot_bin,") n'est pas un fichier.">
msg_to_many_files_in_cdrom_directory    equ "Trop de fichiers dans le r�pertoire des fichiers d'amor�age compact�s du CD-ROM."
msg_invalid_cd_function                 equ "Appel de fonction interne non autoris�e sur un CD-ROM."
msg_update_permissed_by_updatefile      equ "Mise � jour de fichiers autoris�e : fichier 'BOOT_UPD.TXT' trouv�."
msg_update_permissed_by_volumelabel     equ "Mise � jour de fichiers autoris�e : label de volume 'BOOT_UPDATE' correspondant."
msg_update_not_permissed                equ "Pas de mise � jour de fichiers : aucun fichier indicateur ni label correspondant trouv�."
msg_query_geom_1                        equ "Erreur � la requ�te de g�om�trie du disque "
msg_query_geom_3                        equ "."
mgs_k_errorcode_eq                      equ ", Code="

; module readme.inc
msg_readme_not_found                    equ "Fichier texte non trouv�."
msg_readme_file_is_to_large             equ "Fichier texte trop grand."
msg_readme_statusline1                  equ <" Ligne n�">
msg_readme_statusline2                  equ <"  ",019h,018h,"=voir fichier, F7=Recherche, �chap=Quitter ">
msg_Search_for                          equ "Rechercher > "
msg_edit_statusline                     equ "F7=Recherche, �chap=Quitter"

msg_edithelp_tab                        equ 9
msg_edithelp_01                         equ "d�placez-vous en utilisant les touches curseur, PageHaut/PageBas"
msg_edithelp_02                         equ "Ctrl+PageHaut/PageBas=D�but/Fin de fichier"
msg_edithelp_03                         equ "D�but/Fin=D�but/Fin de ligne"
msg_edithelp_04                         equ "Ctrl+Gauche/Droite=d�but du mot pr�c�dent/suivant"
msg_edithelp_05                         equ "Ctrl+RetArri�re/T/Y=Suppression de mot de gauche/mot de droite/ligne"
msg_edithelp_06                         equ "F7=Recherche, Maj+F7=Poursuivre"
msg_edithelp_07                         equ "Ctrl+Inser=Copier la ligne dans le presse-papiers"
msg_edithelp_08                         equ "Maj+Inser=Coller la ligne depuis le presse-papiers"
msg_edithelp_09                         equ "Inser=Basculer en mode Insertion/Refrappe"
msg_edithelp_10                         equ "�chap=Quitter et proposer de sauvegarder"
msg_edithelp_key                        equ "Appuyer sur une touche pour continuer"

msg_edit_save_changes                   equ "Sauvegarder les modifications (Oui/Non/�chap) ? "
key_edit_save_changes_yes               equ "o"
key_edit_save_changes_no                equ "n"

; module speicher.inc
msg_memory_block_corrupted              equ "Bloc de contr�le de m�moire corrompu."
msg_Error_allocating_heap_memory        equ "Hors limite m�moire."

; module unpackfi.inc
msg_Zero_length_file                    equ "Fichier de longueur nulle."
msg_Unknown_format_damaged_archive      equ "Archive ou fichier endommag�."
msg_packfile_unkn_command               equ "Commande d'archive inconnue ou non implement�e."
msg_incorrect_archive_version           equ "Version d'archive incorrecte."
msg_unpack_error_no_data                equ "Erreur de d�compression : pas de donn�es."
msg_useless_data_in_archive             equ "Donn�es inutiles dans l'archive."

; module xms.inc
msg_No_XMS_2_driver                     equ "Pilote XMS 2+ inexistant."
msg_Error_allocating_XMS_memory         equ "Erreur d'allocation de m�moire XMS."
msg_Error_determining_physical_address  equ "Erreur de d�termination de l'adresse physique."

