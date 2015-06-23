Title   Russian language dependant strings for OS2CSM

; datum.inc

msg_title                       equ "Меню конфигурации OS/2"

; install.inc

msg_install_aborted             equ <"Установка прервана.",13,10>
msg_Using_reserved_memory       equ <"Используется зарезервированная память.",13,10>
msg_Using_video_memory          equ <"Используется видеопамять.",13,10>

; lader.inc
msg_Loading_OS2LDR__            equ "Загружается OS2LDR... "
err_os2boot1                    equ "Неизвестная версия OS2BOOT <1>"
err_os2boot2                    equ "Неизвестная версия OS2BOOT <2>"
err_os2boot3                    equ "Неизвестная версия OS2BOOT <3>"
err_cannot_open_os2ldr_bin      equ "Ошибка открытия файла OS2LDR.BIN!"
err_read_error_                 equ "Ошибка чтения!"

; mod.inc

msg_yes_no                      equ " [Да(1)/Нет(2)] ? "
key_yes                         equ "1"
key_no                          equ "2"

                                ;   "*******************************************************************************"
msg_key_to_continue             equ " ═══════════════════[Нажмите любую клавишу для продолжения]════════════════════"
