Title           language dependant strings: russian

; thanks to Yuri Proniakin

; module a20.inc
msg_Failed_to_restore_A20_gate          equ "Не удалось восстановить шлюз A20."
;obsoleted
;msg_Returned_successfully_but_A20_rf    equ "Возврат успешный, но A20 восстановить не удалось."

; module ausschri.inc
thousand_separator                      equ " "

; module boot.inc
msg_frage_harddisk_or_memdisk           equ <"Продолжить с [",setkeycolour,"ж",setdefaultcolour,"]ёсткого диска, [",setkeycolour,"в",setdefaultcolour,"]иртуального диска или [",setkeycolour,"д",setdefaultcolour,"]искеты? ">
key_boot_harddisk                       equ "ж"
key_boot_memdisk                        equ "в"
key_boot_floppy                         equ "д"
key_uninstall                           equ "у"
msg_meldung_Lesefehler                  equ "Ошибка чтения"
msg_meldung_no_bootable_partition       equ "Стартуемый раздел не найден."
msg_meldung_bootsector_invalid          equ "Отсутствует признак загрузочного сектора."

; module call_csm.inc
msg_os2csm_not_found                    equ "Модуль OS2CSM.BIN не найден."
msg_Invalid_OS2CSM_BIN                  equ "Неверный OS2CSM.BIN."
msg_file_is_to_big_to_load              equ "Файл слишком велик для загрузки."
msg_Can_not_rename_OS_debug_file_missing equ "Невозможно переименовать: отладочный файл ОС отсутствует."

; module cdloader.tas
msg_loading_part2                       equ "Загружается вторая часть кода... "

; module cd_menu.inc
msg_function_not_implemented            equ <"Функция ещё не реализована.",13,10,"Нажмите клавишу для продолжения",keypress,13,10,0>
msg_bootsector_read_error               equ <"Ошибка чтения загрузочного сектора.",13,10,"Нажмите клавишу для продолжения",keypress,13,10,0>
msg_bootsector_invalid_format           equ <"Неверный загрузочный сектор.",13,10,"Нажмите клавишу для продолжения",keypress,13,10,0>

; module dep16s.inc
msg_invalid_packed_data_header          equ "Обнаружен неверный заголовок сжатого файла."
msg_packed_data_CRC_failed              equ "Неверный CRC сжатых данных."
msg_unpacking_data_failed               equ "Сбой при распаковке данных."
msg_unpacked_data_CRC_failed            equ "Неверный CRC распакованных данных."

; module driveacc.inc
msg_swap_drive_insert                   equ " Вставьте "
msg_swap_drive_additional_floppy        equ "диск обновления загрузки (если есть)"
msg_swap_drive_main_bootdisk            equ "основной загрузочный диск"
msg_swap_drive_harddisk                 equ "жёсткий диск"
msg_swap_drive_press_key                equ " и нажмите любую клавишу"

; module format.inc
msg_Memory_disk_memory_is_corrupted     equ "Виртуальный диск повреждён."
msg_MemDisk_sector_read_error0          equ "Ошибка чтения сектора виртуального диска"
msg_MemDisk_sector_read_error1          equ "."
msg_MemDisk_sector_write_error0         equ "Ошибка записи сектора виртуального диска"
msg_MemDisk_sector_write_error1         equ "."

; module inithd.inc
;warning_9e00box1 equ "Внимание: используется память ниже 9e00:0.                "
;warning_9e00box2 equ "Это может вызвать проблемы при создании *S506.ADD miniVDM."
;warning_9e00box3 equ "Выход: используйте параметр DaniS506 /!Bios               "
;warning_9e00box4 equ "и/или инициализируйте все жёсткие диски                   "
;
;                                        ; following messages are printed as:
;                                        ;   "Initialize unpartitioned harddisk 80 and"
;                                        ;   "a placeholder extended partition [Да(1)/Нет(2)]? "
;msg_question_init_hd1                   equ <"Инициализировать чистый жёсткий диск ">
;msg_question_init_hd2                   equ <" и",13,10,"создать заготовку расширенного раздела? 1(да)/2(нет) ">
;key_question_init_hd_yes                equ "1"
;key_question_init_hd_no                 equ "2"

; module int_0_6.inc
msg_divide_by_zero                      equ "Деление на 0"
msg_invalid_opcode                      equ "Неверный код команды"

; module int13.inc
msg_int13_problem_protected_mode        equ <seterrorcolour,"Проблема доступа к памяти диска: процессор уже в защищённом режиме.",setdefaultcolour>

; module int15a.inc
msg_int15a_e820                         equ "Используется INT 15 EAX=E820 'SMAP'"
msg_int15a_e881                         equ "Используется INT 15 AX=e881 'Phoenix 4.0 32-бит'"
msg_int15a_c7                           equ "Используется INT 15 AH=C7 'PS/2'"
msg_int15a_e801                         equ "Используется INT 15 AX=e801 'Phoenix 4.0 16-бит'"
msg_int15a_8a                           equ "Используется INT 15 AH=8A 'Phoenix 4.0 big'"
msg_int15a_da88                         equ "Используется INT 15 AX=DA88 'AMI PCI'"
msg_int15a_88                           equ "Используется INT 15 AH=88 '286'"
msg_Detecting_extended_memory_size      equ "Определяется размер расширенной памяти..."
msg_MB_starting_at_1_MB                 equ " МБ, начиная с 1 МБ"
msg_MB_starting_at_16_MB                equ " МБ, начиная с 16 МБ"
msg_Using_KB_at_Address_1               equ "Используется "
msg_Using_KB_at_Address_2               equ " байтов по адресу "
msg_Using_KB_at_Address_3               equ "."
msg_failed                              equ "Не вышло."
msg_Not_enough_memory                   equ "Недостаточно памяти."

; module memalloc.inc
msg_DOS_memory_allocation_failed        equ "Сбой выделения памяти DOS."
msg_No_free_harddisk_drive_number       equ "Нет свободного номера жёсткого диска."
msg_CD_ROM_emulation_terminated         equ "Эмуляция загрузки завершена."
msg_CD_ROM_emulation_did_not_terminate  equ "Не удалось завершить эмуляцию загрузки."
msg_title_dos                           equ <cls,"Вирт. диск [DOS] ">
msg_title_bios                          equ <cls,"Вирт. диск "> ; [BIOS]
msg_title_dos_cdloader                  equ <cls,"Загрузчик CD [DOS] ">
msg_title_bios_cdloader                 equ <cls,"Загрузчик CD "> ; [BIOS]
msg_bootdrive_floppyharddisk            equ "Стартовый диск - дискета или жёсткий диск ("
msg_bootdrive_cdnoemu                   equ "Стартовый диск -  CD-ROM в режиме 'Без эмуляции' ("
msg_bootdrive2                          equ <").">
msg_Disk_0x_installed_1                 equ "Дисковод "
msg_Disk_0x_installed_3                 equ ": установлен."
msg_Disk_8x_installed_1                 equ "Диск "
msg_Disk_8x_installed_3                 equ ": установлен."
msg_MEMBOOT_BIN_corrupted_fragmented    equ <cd_boot_memboot_bin," повреждён/фрагментирован.">
msg_already_present_SCAD                equ "Вирт. диск уже есть в памяти. Нажмите Shift+Ctrl+Alt+Del для перезагрузки."

; module memload.inc
msg_Disk_has_invalid_format             equ <"Неверный формат диска.",13,10,"Вставьте другой диск и нажмите любую клавишу.">
msg_Insert_floppy_with_label_press_key_1 equ "Вставьте диск с меткой '"
msg_Insert_floppy_with_label_press_key_2 equ "' and press a key."
msg_Insert_floppy_with_file_press_key_1 equ "Insert floppy with file '"
msg_Insert_floppy_with_file_press_key_2 equ "' и нажмите любую клавишу."
msg_invalid_partition_table_on_memdisk  equ "Неверная таблица разделов на виртуальном диске."
msg_No_active_primary_or_extended_part  equ "Не найден загрузочный раздел."
msg_Partition_on_memory_disk_is_not_FAT equ "Раздел на виртуальном диске не FAT."
msg_Asking_for_drive_parameters_failed1 equ "Сбой запроса параметров диска (диск="
msg_Asking_for_drive_parameters_failed2 equ <").">

msg_Write_error_disk_full               equ "Ошибка записи: диск переполнен."
msg_directory_full                      equ "Каталог переполнен."
msg_invalid_cluster_number_2            equ "Неверный номер кластера (<2)"
msg_invalid_cluster_number_max          equ "Неверный номер кластера (>max)"
msg_sector_read_error_0                 equ <"ошибка чтения сектора (диск=">
msg_sector_read_error_1                 equ <", цилиндр=">
msg_sector_read_error_2                 equ <", головка=">
msg_sector_read_error_3                 equ <", сектор=">
msg_sector_read_error_4                 equ <").">
msg_hd_sector_read_error0               equ "Ошибка чтения сектора жёсткого диска (диск="
msg_cd_sector_read_error0               equ "Ошибка чтения сектора CD-ROM (диск="
msg_cd_sector_read_error1               equ ", сектор="
msg_cd_sector_read_error3               equ <").">
msg_invalid_VTOC                        equ "Неверный сектор оглавления CD-ROM."
msg_can_not_find_boot_directory         equ <"Невозможно найти каталог с загрузочными файлами на CD-ROM (",cd_boot_memboot_bin,").">
msg_boot_directory_is_not_a_directory   equ "Каталог с загрузочными файлами на CD-ROM не является каталогом."
msg_can_not_find_memboot_bin            equ <"Невозможно найти вторую часть загрузчика (",cd_boot_memboot_bin,").">
msg_memboot_bin_is_not_a_file           equ <"Вторая часть загрузчика (",cd_boot_memboot_bin,") не является файлом.">
msg_to_many_files_in_cdrom_directory    equ "Слишком много файлов в каталоге CD-ROM с упакованными загрузочными файлами."
msg_invalid_cd_function                 equ "Вызвана внутренняя функция, не разрешённая для CD-ROM."
msg_update_permissed_by_updatefile      equ "Разрешено обновление файлов: найден файл 'BOOT_UPD.TXT'."
msg_update_permissed_by_volumelabel     equ "Разрешено обновление файлов: найдена метка диска 'BOOT_UPDATE'."
msg_update_not_permissed                equ "Без обновления файлов: не найдены ни файл-индикатор, ни метка диска."
msg_query_geom_1                        equ "Ошибка запроса геометрии диска "
msg_query_geom_3                        equ "."
mgs_k_errorcode_eq                      equ ", код="

; module readme.inc
msg_readme_not_found                    equ "Текстовый файл не найден."
msg_readme_file_is_to_large             equ "Текстовый файл слишком большой."
msg_readme_statusline1                  equ <" Строка №">
msg_readme_statusline2                  equ <"  ",019h,018h,"=Просмотр файла, F7=Поиск, Esc=Выход ">
msg_Search_for                          equ "Искать > "
msg_edit_statusline                     equ "F7=Поиск, Esc=Выход"

msg_edithelp_tab                        equ 9
msg_edithelp_01                         equ "Перемещение с помощью стрелок, PageUp/PageDown"
msg_edithelp_02                         equ "Ctrl+PageUp/PageDown=Начало/Конец файла"
msg_edithelp_03                         equ "Home/End=Начало/Конец строки"
msg_edithelp_04                         equ "Ctrl+Left/Right=Начало предыдущего/следующего слова"
msg_edithelp_05                         equ "Ctrl+Backspace/T/Y=Удалить слово слева/справа/строку"
msg_edithelp_06                         equ "F7=Поиск, Shift+F7=Искать дальше"
msg_edithelp_07                         equ "Ctrl+Ins=Копировать строку в буфер"
msg_edithelp_08                         equ "Shift+Ins=Вставить строку из буфера"
msg_edithelp_09                         equ "Ins=Переключение режима Вставка/Замена"
msg_edithelp_10                         equ "Esc=Выход с запросом на сохранение изменений"
msg_edithelp_key                        equ "нажмите любую кнопку"

msg_edit_save_changes                   equ "Сохранить изменения (1/2/Esc)? "
key_edit_save_changes_yes               equ "1"
key_edit_save_changes_no                equ "2"



; module speicher.inc
msg_memory_block_corrupted              equ "Блок управления памятью повреждён."
msg_Error_allocating_heap_memory        equ "Нехватка памяти."

; module unpackfi.inc
msg_Zero_length_file                    equ "Файл нулевой длины."
msg_Unknown_format_damaged_archive      equ "Повреждённый архив или посторонний файл."
msg_packfile_unkn_command               equ "Неизвестная или не реализованная команда Packfile."
msg_incorrect_archive_version           equ "Неверная версия архива."
msg_unpack_error_no_data                equ "Ошибка распаковки: нет данных."
msg_useless_data_in_archive             equ "Бесполезные данные в архиве."

; module xms.inc
msg_No_XMS_2_driver                     equ "Отсутствует драйвер XMS 2+."
msg_Error_allocating_XMS_memory         equ "Ошибка выделения памяти XMS."
msg_Error_determining_physical_address  equ "Ошибка определения физического адреса."
