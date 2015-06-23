Title           language dependant strings: english

; module a20.inc
msg_Failed_to_restore_A20_gate          equ "Failed to restore A20 gate."
;obsoleted
;msg_Returned_successfully_but_A20_rf    equ "Returned successfully, but A20 restore failed."

; module ausschri.inc
thousand_separator                      equ ","

; module boot.inc
msg_frage_harddisk_or_memdisk           equ <"Continue on [",setkeycolour,"h",setdefaultcolour,"]ard disk, [",setkeycolour,"m",setdefaultcolour,"]emory disk or [",setkeycolour,"f",setdefaultcolour,"]loppy ? ">
key_boot_harddisk                       equ "h"
key_boot_memdisk                        equ "m"
key_boot_floppy                         equ "f"
key_uninstall                           equ "u"
msg_meldung_Lesefehler                  equ "Read error"
msg_meldung_no_bootable_partition       equ "No startable partition found."
msg_meldung_bootsector_invalid          equ "Boot sector signature missing."

; module call_csm.inc
msg_os2csm_not_found                    equ "The program module OS2CSM.BIN was not found."
msg_Invalid_OS2CSM_BIN                  equ "Invalid OS2CSM.BIN."
msg_file_is_to_big_to_load              equ "A file is too big to load."
msg_Can_not_rename_OS_debug_file_missing equ "Cannot rename: OS debug file is missing."

; module cdloader.tas
msg_loading_part2                       equ "Loading second code portion ... "

; module cd_menu.inc
msg_function_not_implemented            equ <"Function not implemented yet.",13,10,"Press a key to continue",keypress,13,10,0>
msg_bootsector_read_error               equ <"Boot sector read error.",13,10,"Press a key to continue",keypress,13,10,0>
msg_bootsector_invalid_format           equ <"Boot sector is not valid.",13,10,"Press a key to continue",keypress,13,10,0>

; module dep16s.inc
msg_invalid_packed_data_header          equ "Found invalid compression header."
msg_packed_data_CRC_failed              equ "Packed data CRC failed.."
msg_unpacking_data_failed               equ "Unpacking data failed."
msg_unpacked_data_CRC_failed            equ "Unpacked data CRC failed."

; module driveacc.inc
msg_swap_drive_insert                   equ " Insert "
msg_swap_drive_additional_floppy        equ "boot update media (if available)"
msg_swap_drive_main_bootdisk            equ "main boot media"
msg_swap_drive_harddisk                 equ "harddisk"
msg_swap_drive_press_key                equ <", ",13,10," and press a key ">

; module format.inc
msg_Memory_disk_memory_is_corrupted     equ "memory disk memory is corrupted."
msg_MemDisk_sector_read_error0          equ "MemDisk sector read error"
msg_MemDisk_sector_read_error1          equ "."
msg_MemDisk_sector_write_error0         equ "MemDisk sector write error"
msg_MemDisk_sector_write_error1         equ "."

; module inithd.inc

; module int_0_6.inc
msg_divide_by_zero                      equ "Divide by zero"
msg_invalid_opcode                      equ "Invalid opcode"

; module int13.inc
msg_int13_problem_protected_mode        equ <seterrorcolour,"Problem accessing disk memory: already protected mode.",setdefaultcolour>

; module int15a.inc
msg_int15a_e820                         equ "using INT 15 EAX=E820 'SMAP'"
msg_int15a_e881                         equ "using INT 15 AX=e881 'Phoenix 4.0 32-bit'"
msg_int15a_c7                           equ "using INT 15 AH=C7 'PS/2'"
msg_int15a_e801                         equ "using INT 15 AX=e801 'Phoenix 4.0 16-bit'"
msg_int15a_8a                           equ "using INT 15 AH=8A 'Phoenix 4.0 big'"
msg_int15a_da88                         equ "using INT 15 AX=DA88 'AMI PCI'"
msg_int15a_88                           equ "using INT 15 AH=88 '286'"
msg_Detecting_extended_memory_size      equ "Detecting extended memory size ... "
msg_MB_starting_at_1_MB                 equ " MB starting at 1 MB"
msg_MB_starting_at_16_MB                equ " MB starting at 16 MB"
msg_Using_KB_at_Address_1               equ "Using "
msg_Using_KB_at_Address_2               equ " bytes at address "
msg_Using_KB_at_Address_3               equ "."
msg_failed                              equ "failed."
msg_Not_enough_memory                   equ "Not enough memory"

; module memalloc.inc
msg_DOS_memory_allocation_failed        equ "DOS memory allocation failed"
msg_No_free_harddisk_drive_number       equ "No free hard disk drive number"
msg_CD_ROM_emulation_terminated         equ "CD-ROM boot emulation completed successfully."
msg_CD_ROM_emulation_did_not_terminate  equ "CD-ROM boot emulation did not complete successfully."
msg_title_dos                           equ <cls,"MemDisk [DOS] ">
msg_title_bios                          equ <cls,"MemDisk "> ; [BIOS]
msg_title_dos_cdloader                  equ <cls,"CDLoader [DOS] ">
msg_title_bios_cdloader                 equ <cls,"CDLoader "> ; [BIOS]
msg_bootdrive_floppyharddisk            equ "Startup drive is floppy or hard disk ("
msg_bootdrive_cdnoemu                   equ "Startup drive is CD-ROM in 'No Emulation' mode ("
msg_bootdrive2                          equ <").">
msg_Disk_0x_installed_1                 equ "Floppy drive "
msg_Disk_0x_installed_3                 equ ": installed."
msg_Disk_8x_installed_1                 equ "Disk "
msg_Disk_8x_installed_3                 equ ": installed."
msg_MEMBOOT_BIN_corrupted_fragmented    equ <cd_boot_memboot_bin," corrupted/fragmented.">
msg_already_present_SCAD                equ "MemDisk already active in memory. Press Shift+Ctrl+Alt+Del to reboot."

; module memload.inc
msg_Disk_has_invalid_format             equ <"Disk has invalid format.",13,10,"Please insert other media and press a key to retry.">
msg_Insert_floppy_with_label_press_key_1 equ "Insert floppy labelled '"
msg_Insert_floppy_with_label_press_key_2 equ "' and press a key."
msg_Insert_floppy_with_file_press_key_1 equ "Insert floppy with file '"
msg_Insert_floppy_with_file_press_key_2 equ "' and press a key."
msg_invalid_partition_table_on_memdisk  equ "invalid partition table on memory disk."
msg_No_active_primary_or_extended_part  equ "No active primary or extended partition found."
msg_Partition_on_memory_disk_is_not_FAT equ "Partition on memory disk is not FAT."
msg_Asking_for_drive_parameters_failed1 equ "Asking for drive parameters failed (drive="
msg_Asking_for_drive_parameters_failed2 equ <").">

msg_Write_error_disk_full               equ "Write error: disk full"
msg_directory_full                      equ "Directory full."
msg_invalid_cluster_number_2            equ "Invalid cluster number (<2)"
msg_invalid_cluster_number_max          equ "Invalid cluster number (>max)"
msg_sector_read_error_0                 equ <"sector read error (drive=">
msg_sector_read_error_1                 equ <", cylinder=">
msg_sector_read_error_2                 equ <", head=">
msg_sector_read_error_3                 equ <", sector=">
msg_sector_read_error_4                 equ <").">
msg_hd_sector_read_error0               equ "Hard disk sector read error (drive="
msg_cd_sector_read_error0               equ "CD-ROM sector read error (drive="
msg_cd_sector_read_error1               equ ", sector="
msg_cd_sector_read_error3               equ <").">
msg_invalid_VTOC                        equ "The table of contents sector of the CD-ROM is invalid."
msg_can_not_find_boot_directory         equ <"Cannot find directory for boot files on the CD-ROM (",cd_boot_memboot_bin,").">
msg_boot_directory_is_not_a_directory   equ "Directory for boot files on CD-ROM is not a directory."
msg_can_not_find_memboot_bin            equ <"Cannot find second part of boot code (",cd_boot_memboot_bin,").">
msg_memboot_bin_is_not_a_file           equ <"Second part of boot code (",cd_boot_memboot_bin,") is not a file.">
msg_to_many_files_in_cdrom_directory    equ "Too many files in the CD-ROM directory of the packed boot files."
msg_invalid_cd_function                 equ "Call of internal function that is not permitted for CD-ROM."
msg_update_permissed_by_updatefile      equ "Updating files allowed: found file 'BOOT_UPD.TXT'."
msg_update_permissed_by_volumelabel     equ "Updating files allowed: matching volume label 'BOOT_UPDATE'."
msg_update_not_permissed                equ "No file updates: no indicator file or matching label found."
msg_query_geom_1                        equ "Error Query Geometry for drive "
msg_query_geom_3                        equ "."
mgs_k_errorcode_eq                      equ ", Code="

; module readme.inc
msg_readme_not_found                    equ "The text file was not found."
msg_readme_file_is_to_large             equ "The text file is too large."
msg_readme_statusline1                  equ <" Line #">
msg_readme_statusline2                  equ <"  ",019h,018h,"=view file, F7=Search, Esc=Exit ">
msg_Search_for                          equ "Search for > "
msg_edit_statusline                     equ "F7=Search, Esc=Exit"

msg_edithelp_tab                        equ 9
msg_edithelp_01                         equ "move using cursor keys, PageUp/PageDown"
msg_edithelp_02                         equ "Ctrl+PageUp/PageDown=Begin/End of file"
msg_edithelp_03                         equ "Home/End=Start/End of line"
msg_edithelp_04                         equ "Ctrl+Left/Right=go to start of previous/next word"
msg_edithelp_05                         equ "Ctrl+Backspace/T/Y=Delete word left/right/Delete line"
msg_edithelp_06                         equ "F7=Search, Shift+F7=Again"
msg_edithelp_07                         equ "Ctrl+Ins=Copy line to clipboard"
msg_edithelp_08                         equ "Shift+Ins=Insert line from clipboard"
msg_edithelp_09                         equ "Ins=toggle Insert/Overwrite mode"
msg_edithelp_10                         equ "Esc=Exit and ask for save changes made"
msg_edithelp_key                        equ "press a key"

msg_edit_save_changes                   equ "Save changes (y/n/Esc)? "
key_edit_save_changes_yes               equ "y"
key_edit_save_changes_no                equ "n"



; module speicher.inc
msg_memory_block_corrupted              equ "Memory control block corrupted."
msg_Error_allocating_heap_memory        equ "Out of memory."

; module unpackfi.inc
msg_Zero_length_file                    equ "Zero length file."
msg_Unknown_format_damaged_archive      equ "Damaged archive or unrelated file."
msg_packfile_unkn_command               equ "Packfile command is unknown/not implemented."
msg_incorrect_archive_version           equ "Incorrect archive version."
msg_unpack_error_no_data                equ "Unpack error: no data."
msg_useless_data_in_archive             equ "Useless data in archive."

; module xms.inc
msg_No_XMS_2_driver                     equ "No XMS 2+ driver present."
msg_Error_allocating_XMS_memory         equ "Error allocating XMS memory."
msg_Error_determining_physical_address  equ "Error determining physical address."
