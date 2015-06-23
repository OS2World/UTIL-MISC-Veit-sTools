@echo off
cls
if exist %tmp%\pmvdmcc.obj del %tmp%\pmvdmcc.obj
if exist %tmp%\pmvdmcc.map del %tmp%\pmvdmcc.map
if exist %tmp%\pmvdmcc.sys del %tmp%\pmvdmcc.sys
c:\bp\bin\tasm /dOS2 /t /oi /m /ml pmvdmcc.tas %tmp%\pmvdmcc.obj > err.pas
type err.pas
if not exist %tmp%\pmvdmcc.obj goto fehler
link /NoLogo /Map %tmp%\pmvdmcc.obj,%tmp%\pmvdmcc.sys,%tmp%\pmvdmcc.map,,pmvdmcc.def
if not exist %tmp%\pmvdmcc.sys goto fehler
call nelite %tmp%\pmvdmcc.sys pmvdmcc.vk\boot\pmvdmcc.sys /s > nul
del %tmp%\pmvdmcc.obj
call mapsym %tmp%\pmvdmcc.map pmvdmcc.vk\boot\pmvdmcc.sym > nul 2>&1
if exist %tmp%\pmvdmcc.sym copy %tmp%\pmvdmcc.sym pmvdmcc.vk\boot\pmvdmcc.sym
if exist %tmp%\pmvdmcc.sym del  %tmp%\pmvdmcc.sym
if exist     .\pmvdmcc.sym copy     .\pmvdmcc.sym pmvdmcc.vk\boot\pmvdmcc.sym
if exist     .\pmvdmcc.sym del      .\pmvdmcc.sym

if exist e:\os2\boot\pmvdmcc.sys copy pmvdmcc.vk\boot\pmvdmcc.sys e:\os2\boot\pmvdmcc.sys
if exist e:\os2\boot\pmvdmcc.sym copy pmvdmcc.vk\boot\pmvdmcc.sym e:\os2\boot\pmvdmcc.sym
goto ende

:fehler
echo Fehler (%0)
pause

:ende