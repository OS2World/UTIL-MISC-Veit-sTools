@echo off
if exist              %tmp%\memdisk.obj del              %tmp%\memdisk.obj
if exist ..\memdisk.vk\boot\memdisk.add del ..\memdisk.vk\boot\memdisk.add
if exist ..\memdisk.vk\boot\memdisk.sym del ..\memdisk.vk\boot\memdisk.sym
cls
C:\bp\bin\tasm /oi /m /zi /ml /t /iTOOLKIT memdisk.tas,%tmp%\memdisk.obj > err.pas
type err.pas
if not exist %tmp%\memdisk.obj goto fehler
link /Alignment:1 /NoLogo /Map:Full %tmp%\memdisk.obj,%tmp%\memdisk.add,%tmp%\memdisk.map,,memdisk.def
if not exist %tmp%\memdisk.add goto fehler
cd ..\memdisk.vk\boot
nelite %tmp%\memdisk.add memdisk.add /s /p255 /a:1 > nul
mapsym %tmp%\memdisk >nul
del %tmp%\memdisk.map
del %tmp%\memdisk.obj
cd ..\..\os2
goto ende

:fehler
pause
:ende

