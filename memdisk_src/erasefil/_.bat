@echo off
cls
stampdef.exe erasefil.def
C:\bp\bin\tasm /oi /s /m /ml /t erasefil.tas,%tmp%\erasefil.obj > err.pas
type err.pas
if not exist %tmp%\erasefil.obj goto fehler
link /NoLogo /Map /Align:1 %tmp%\erasefil.obj,%tmp%\erasefil.sys,%tmp%\erasefil.map,,erasefil.def
if not exist %tmp%\erasefil.sys goto fehler
call nelite %tmp%\erasefil.sys ..\memdisk.vk\boot\erasefil.sys /s /p:255 > nul
call mapsym %tmp%\erasefil >nul
if exist erasefil.sym copy erasefil.sym ..\memdisk.vk\boot\erasefil.sym
if exist erasefil.sym del  erasefil.sym
goto ende

:fehler
echo Fehler (%0)
pause
:ende


