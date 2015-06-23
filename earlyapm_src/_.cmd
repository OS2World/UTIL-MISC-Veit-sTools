@echo off
cls
cd earlyapm.vk

if exist earlyapm.obj del earlyapm.obj
if exist earlyapm.sys del earlyapm.sys
C:\bp\bin\tasm /t /oi /m /zi /ml /i.. ..\earlyapm.tas > ..\err.pas
type ..\err.pas
if not exist earlyapm.obj goto fehler

stampdef ..\earlyapm.def
link /Alignment:1 /NoLogo /Map:Full earlyapm.obj,earlyapm.sys,earlyapm.map,,..\earlyapm.def
call nelite earlyapm.sys earlyapm.sys /s /e+ /p:255 /A:1> nul
if not exist earlyapm.obj goto fehler

patch /a ..\earlyapm.pat

mapsym earlyapm > nul
del earlyapm.map
del earlyapm.obj
copy earlyapm.sy? E:\os2\boot

cd ..
call ..\genvk EarlyAPM

cd earlyapm.vk
call GenPGP

goto ende


:fehler
pause

:ende
cd ..
