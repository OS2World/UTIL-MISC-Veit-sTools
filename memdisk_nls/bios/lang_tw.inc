Title           language dependant strings: Traditional Chinese (TW)

; module a20.inc
msg_Failed_to_restore_A20_gate          equ "無法回復 A20 通道。"
;obsoleted
;msg_Returned_successfully_but_A20_rf    equ "成功返回，不過無法回復 A20。"

; module ausschri.inc
thousand_separator                      equ ","

; module boot.inc
msg_frage_harddisk_or_memdisk           equ <"繼續用 [",setkeycolour,"硬",setdefaultcolour,"]碟(h), [",setkeycolour,"虛",setdefaultcolour,"]擬磁碟(m)或 [",setkeycolour,"磁",setdefaultcolour,"]片(f)？">
key_boot_harddisk                       equ "h"
key_boot_memdisk                        equ "m"
key_boot_floppy                         equ "f"
key_uninstall                           equ "u"
msg_meldung_Lesefehler                  equ "讀取錯誤"
msg_meldung_no_bootable_partition       equ "找不到可啟動的分割區。"
msg_meldung_bootsector_invalid          equ "開機磁區簽章遺失。"

; module call_csm.inc
msg_os2csm_not_found                    equ "找不到程式模組 OS2CSM.BIN。"
msg_Invalid_OS2CSM_BIN                  equ "無效的 OS2CSM.BIN。"
msg_file_is_to_big_to_load              equ "檔案太大以致無法讀取。"
msg_Can_not_rename_OS_debug_file_missing equ "無法改名：OS 除錯檔案遺失。"

; module cdloader.tas
msg_loading_part2                       equ "讀取第二組代碼的部份 ... "

; module cd_menu.inc
msg_function_not_implemented            equ <"尚無法使用此功能。",13,10,"按任意鍵繼續",keypress,13,10,0>
msg_bootsector_read_error               equ <"開機磁區讀取錯誤。",13,10,"按任意鍵繼續",keypress,13,10,0>
msg_bootsector_invalid_format           equ <"無效的開機磁區。",13,10,"按任意鍵繼續",keypress,13,10,0>

; module dep16s.inc
msg_invalid_packed_data_header          equ "找到無效的壓縮標頭。"
msg_packed_data_CRC_failed              equ "包裝資料 CRC 錯誤。"
msg_unpacking_data_failed               equ "開封資料錯誤。"
msg_unpacked_data_CRC_failed            equ "開封資料 CRC 錯誤。"

; module driveacc.inc
msg_swap_drive_insert                   equ " 插入"
msg_swap_drive_additional_floppy        equ "開機更新媒介（若有的話）"
msg_swap_drive_main_bootdisk            equ "主要開機媒介"
msg_swap_drive_harddisk                 equ "硬碟"
msg_swap_drive_press_key                equ <", ",13,10," 及按任意鍵 ">

; module format.inc
msg_Memory_disk_memory_is_corrupted     equ "虛擬磁碟的記憶體出問題。"
msg_MemDisk_sector_read_error0          equ "MemDisk 磁區讀取錯誤"
msg_MemDisk_sector_read_error1          equ "."
msg_MemDisk_sector_write_error0         equ "MemDisk 磁區寫入錯誤"
msg_MemDisk_sector_write_error1         equ "."

; module inithd.inc

; module int_0_6.inc
msg_divide_by_zero                      equ "被 0 分開"
msg_invalid_opcode                      equ "無效的操作碼"

; module int13.inc
msg_int13_problem_protected_mode        equ <seterrorcolour,"存取磁碟記憶體錯誤：已切換成保護模式。",setdefaultcolour>

; module int15a.inc
msg_int15a_e820                         equ "使用 INT 15 EAX=E820 'SMAP'"
msg_int15a_e881                         equ "使用 INT 15 AX=e881 'Phoenix 4.0 32-bit'"
msg_int15a_c7                           equ "使用 INT 15 AH=C7 'PS/2'"
msg_int15a_e801                         equ "使用 INT 15 AX=e801 'Phoenix 4.0 16-bit'"
msg_int15a_8a                           equ "使用 INT 15 AH=8A 'Phoenix 4.0 big'"
msg_int15a_da88                         equ "使用 INT 15 AX=DA88 'AMI PCI'"
msg_int15a_88                           equ "使用 INT 15 AH=88 '286'"
msg_Detecting_extended_memory_size      equ "正在偵測延伸記憶體的大小 ... "
msg_MB_starting_at_1_MB                 equ " MB 由 1 MB 開始"
msg_MB_starting_at_16_MB                equ " MB 由 16 MB "
msg_Using_KB_at_Address_1               equ "使用 "
msg_Using_KB_at_Address_2               equ " bytes 在位址"
msg_Using_KB_at_Address_3               equ "."
msg_failed                              equ "無效。"
msg_Not_enough_memory                   equ "沒有足夠的記憶體"

; module memalloc.inc
msg_DOS_memory_allocation_failed        equ "DOS 記憶體分配錯誤"
msg_No_free_harddisk_drive_number       equ "無可用之磁碟機代號"
msg_CD_ROM_emulation_terminated         equ "成功完成光碟機的開機模擬。"
msg_CD_ROM_emulation_did_not_terminate  equ "光碟機的開機模擬失敗。"
msg_title_dos                           equ <cls,"MemDisk [DOS] ">
msg_title_bios                          equ <cls,"MemDisk "> ; [BIOS]
msg_title_dos_cdloader                  equ <cls,"CDLoader [DOS] ">
msg_title_bios_cdloader                 equ <cls,"CDLoader "> ; [BIOS]
msg_bootdrive_floppyharddisk            equ "啟動磁碟是軟碟或是硬碟（"
msg_bootdrive_cdnoemu                   equ "啟動磁碟是'非模擬'模式的光碟機（"
msg_bootdrive2                          equ <").">
msg_Disk_0x_installed_1                 equ "軟碟機"
msg_Disk_0x_installed_3                 equ "：已安裝。"
msg_Disk_8x_installed_1                 equ "磁碟"
msg_Disk_8x_installed_3                 equ "：已安裝。"
msg_MEMBOOT_BIN_corrupted_fragmented    equ <cd_boot_memboot_bin," 錯誤／片段化。">
msg_already_present_SCAD                equ "MemDisk 已在記憶體中作用。按 Shift+Ctrl+Alt+Del 重新開機。"

; module memload.inc
msg_Disk_has_invalid_format             equ <"磁碟已格式化失敗。",13,10,"請插入其他的媒體並按任意鍵重試。">
msg_Insert_floppy_with_label_press_key_1 equ "插入標示為 '"
msg_Insert_floppy_with_label_press_key_2 equ "' 的磁碟，並按任意鍵。"
msg_Insert_floppy_with_file_press_key_1 equ "插入具有 '"
msg_Insert_floppy_with_file_press_key_2 equ "' 檔案的磁碟，並按任意鍵。"
msg_invalid_partition_table_on_memdisk  equ "在虛擬磁碟上的分割區表格無效。"
msg_No_active_primary_or_extended_part  equ "找不到作用的主要或是延伸分割區。"
msg_Partition_on_memory_disk_is_not_FAT equ "在虛擬磁碟上的分割區不是 FAT。"
msg_Asking_for_drive_parameters_failed1 equ "要求磁碟參數錯誤（磁碟="
msg_Asking_for_drive_parameters_failed2 equ <"）。">

msg_Write_error_disk_full               equ "寫入錯誤：磁碟已滿"
msg_directory_full                      equ "目錄已滿。"
msg_invalid_cluster_number_2            equ "無效的叢集數目（<2）"
msg_invalid_cluster_number_max          equ "無效的叢集數目（>最大值）"
msg_sector_read_error_0                 equ <"磁碟讀取錯誤（磁碟=">
msg_sector_read_error_1                 equ <", cylinder=">
msg_sector_read_error_2                 equ <", head=">
msg_sector_read_error_3                 equ <", sector=">
msg_sector_read_error_4                 equ <"）。">
msg_hd_sector_read_error0               equ "硬碟磁碟讀取錯誤（磁碟="
msg_cd_sector_read_error0               equ "光碟磁區讀取錯誤（磁碟="
msg_cd_sector_read_error1               equ ", sector="
msg_cd_sector_read_error3               equ <"）。">
msg_invalid_VTOC                        equ "光碟的內容磁碟表錯誤。"
msg_can_not_find_boot_directory         equ <"無法在光碟上找到可開機檔案的目錄（",cd_boot_memboot_bin,"）。">
msg_boot_directory_is_not_a_directory   equ "在光碟上開來放開機檔案的目錄並不是目錄。"
msg_can_not_find_memboot_bin            equ <"無法找到開機碼的第二部份（",cd_boot_memboot_bin,"）。">
msg_memboot_bin_is_not_a_file           equ <"開機碼的第二部份（",cd_boot_memboot_bin,"）不是一個檔案。">
msg_to_many_files_in_cdrom_directory    equ "在光碟上的開機檔案封包有太多的檔案。"
msg_invalid_cd_function                 equ "內部功能的呼叫無法用於光碟。"
msg_update_permissed_by_updatefile      equ "更新的檔案准許：找到檔案 'BOOT_UPD.TXT'."
msg_update_permissed_by_volumelabel     equ "更新的檔案准許：正在比於容體標籤 'BOOT_UPDATE'."
msg_update_not_permissed                equ "沒有更新檔案：找不到指標性檔案或是比對到的標籤 。"
msg_query_geom_1                        equ "磁碟的幾何查詢錯誤"
msg_query_geom_3                        equ "."
mgs_k_errorcode_eq                      equ ", Code="

; module readme.inc
msg_readme_not_found                    equ "找不到文字檔案。"
msg_readme_file_is_to_large             equ "文字檔案太大。"
msg_readme_statusline1                  equ <" 行 #">
msg_readme_statusline2                  equ <"  ",019h,018h,"=檢視檔案，F7=搜尋，Esc=離開">
msg_Search_for                          equ "搜尋 > "
msg_edit_statusline                     equ "F7=搜尋，Esc=離開"

msg_edithelp_tab                        equ 9
msg_edithelp_01                         equ "利用按鍵 PageUp/PageDown 移動"
msg_edithelp_02                         equ "Ctrl+PageUp/PageDown= 檔案的開頁／結尾"
msg_edithelp_03                         equ "Home/End= 行的第一字／最後字"
msg_edithelp_04                         equ "Ctrl+Left/Right= 到前一個／下一個字的起頭"
msg_edithelp_05                         equ "Ctrl+Backspace/T/Y= 刪除左邊／右邊／刪除行的字"
msg_edithelp_06                         equ "F7=搜尋，Shift+F7=再一次"
msg_edithelp_07                         equ "Ctrl+Ins=將行複製到剪貼簿"
msg_edithelp_08                         equ "Shift+Ins=從剪貼簿插入行"
msg_edithelp_09                         equ "Ins=切換 插入／覆寫模式"
msg_edithelp_10                         equ "Esc=離開並詢問儲存所做的修改"
msg_edithelp_key                        equ "按任意鍵"

msg_edit_save_changes                   equ "儲存變更（y/n/Esc）？"
key_edit_save_changes_yes               equ "y"
key_edit_save_changes_no                equ "n"



; module speicher.inc
msg_memory_block_corrupted              equ "記憶體控制區塊錯誤。"
msg_Error_allocating_heap_memory        equ "記憶體溢位。"

; module unpackfi.inc
msg_Zero_length_file                    equ "長度為零的檔案。"
msg_Unknown_format_damaged_archive      equ "危險的壓縮檔或是不相關的檔案。"
msg_packfile_unkn_command               equ "未知的封裝檔案指令／無法操作。"
msg_incorrect_archive_version           equ "錯誤的壓縮檔版本。"
msg_unpack_error_no_data                equ "封裝錯誤：無資料。"
msg_useless_data_in_archive             equ "壓縮檔中有無用的資料。"

; module xms.inc
msg_No_XMS_2_driver                     equ "無 XMS 2+ 磁碟存在。"
msg_Error_allocating_XMS_memory         equ "配置 XMS 記憶體錯誤。"
msg_Error_determining_physical_address  equ "偵測實體位址錯誤。"
