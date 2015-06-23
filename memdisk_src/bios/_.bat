@echo off
cls
echo.
if NOT [%OS%]==[OS2] 32rtm > nul
set rem_32rtm=rem

echo ş OS2BOOT.AC
call _os2boot.bat language_de de /Dnodebug
call _os2boot.bat language_en en /Dnodebug
call _os2boot.bat language_es es /Dnodebug
call _os2boot.bat language_fr fr /Dnodebug
call _os2boot.bat language_it it /Dnodebug
call _os2boot.bat language_jp jp /Dnodebug
call _os2boot.bat language_nl nl /Dnodebug
call _os2boot.bat language_ru ru /Dnodebug

echo ş MEMBOOT.BIN
call _bios.bat    language_en db /DScrewDrv
call _bios.bat    language_de de /Dnodebug
call _bios.bat    language_en en /Dnodebug
call _bios.bat    language_es es /Dnodebug
call _bios.bat    language_fr fr /Dnodebug
call _bios.bat    language_it it /Dnodebug
call _bios.bat    language_jp jp /Dnodebug
call _bios.bat    language_nl nl /Dnodebug
call _bios.bat    language_ru ru /Dnodebug

echo ş CDLOADER.BIN
call _cdloade.bat language_it db /DScrewDrv
call _cdloade.bat language_de de /Dnodebug
call _cdloade.bat language_en en /Dnodebug
call _cdloade.bat language_es es /Dnodebug
call _cdloade.bat language_fr fr /Dnodebug
call _cdloade.bat language_it it /Dnodebug
call _cdloade.bat language_jp jp /Dnodebug
call _cdloade.bat language_nl nl /Dnodebug
call _cdloade.bat language_ru ru /Dnodebug

echo ş DUMMYCSM.BIN
call _dummycsm.bat

if NOT [%OS%]==[OS2] 32rtm /u > nul
set rem_32rtm=
