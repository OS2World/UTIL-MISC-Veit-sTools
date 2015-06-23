@echo off
cls
echo.
if NOT [%OS%]==[OS2] 32rtm > nul
set rem_32rtm=rem

    call _bios.bat    language_de db /DScrewDrv
rem call _bios.bat    language_de de /Dnodebug

rem call _cdloade.bat language_it db /DScrewDrv
rem call _cdloade.bat language_de de /Dnodebug

if NOT [%OS%]==[OS2] 32rtm /u > nul
set rem_32rtm=
