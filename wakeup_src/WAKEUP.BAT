@echo off
cls

call stampdef wakeup.def

if exist %tmp%\wakeup.obj  del %tmp%\wakeup.obj
if exist %tmp%\wakeupd.obj del %tmp%\wakeupd.obj
if exist %tmp%\wakeup.snp  del %tmp%\wakeup.snp

C:\bp\bin\tasm /oi /m /zi /ml /t /dOS2 wakeup.tas %tmp%\wakeup.obj > err.pas
type err.pas
if not exist %tmp%\wakeup.obj goto fehler

C:\bp\bin\tasm /oi /m /zi /ml /t /dDOS wakeup.tas %tmp%\wakeupd.obj > err.pas
type err.pas
if not exist %tmp%\wakeupd.obj goto fehler

link /NoLogo /Map:Full %tmp%\wakeupd.obj,%tmp%\wakeupd.exe,%tmp%\wakeupd.map,,nul.def

link /Alignment:1 /NoLogo /Map:Full %tmp%\wakeup.obj,%tmp%\wakeup.snp,wakeup.map,,wakeup.def
if not exist %tmp%\wakeup.snp goto fehler
call nelite %tmp%\wakeup.snp wakeup.vk\wakeup.snp /e+ /p:255 /s:%tmp%\wakeupd.exe> nul

mapsym wakeup > nul
copy wakeup.sym wakeup.vk\wakeup.sym
del wakeup.sym
del wakeup.map
del %tmp%\wakeupd.map
del %tmp%\wakeup.obj
del %tmp%\wakeupd.obj
del %tmp%\wakeup.snp
del %tmp%\wakeupd.exe

copy wakeup.vk\wakeup.snp E:\os2\boot\wakeup.snp
copy wakeup.vk\wakeup.sym E:\os2\boot\wakeup.sym

goto ende

:fehler
pause

:ende
