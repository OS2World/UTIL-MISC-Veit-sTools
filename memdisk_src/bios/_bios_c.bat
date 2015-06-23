@echo off
echo.

if NOT [%OS%]==[OS2] 32rtm > nul
set rem_32rtm=rem
call _bios.bat language_de bde /Dnodebug
if NOT [%OS%]==[OS2] 32rtm /u > nul
set rem_32rtm=

overwrit.exe ..\memdisk.vk\bin\de\memboot.bin c:\memboot.bin
..\memdisk.vk\exe\memcfg c:\memboot.bin < ..\memdisk.vk\exe\memcfg.rsp > nul
echo.
pause
