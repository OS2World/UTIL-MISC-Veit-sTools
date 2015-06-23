@echo off
cls
set DOSSETTING.DPMI_MEMORY_LIMIT=40
set DOSSETTING.DPMI_DOS_API=ENABLED
call _os2boot.bat language_de de /DScrewDrv
if not exist a:\os2boot exit
if exist a:\os2boot del a:\os2boot
copy 1\os2boot a:
ac a:os2boot ..\MEMDISK.VK\BIN\DE\os2boot_.ac
chkdsk /F A:\os2boot
pause
