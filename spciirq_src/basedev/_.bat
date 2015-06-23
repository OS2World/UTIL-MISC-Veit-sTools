@echo off
cls

if exist spciirq.com del spciirq.com

call stampdef spciirq.def

echo * DOS

call tasm /t /oi /m /ml /dDOS /iTOOLKIT spciirq.tas %tmp%\spciirq.obj
if not exist %tmp%\spciirq.obj goto fehler
rem call link /NoLogo %tmp%\spciirq.obj,%tmp%\spciirq.exe,nul.map,,nul.def
32rtm > nul
\bp\bin\tlink /n %tmp%\spciirq.obj,%tmp%\spciirq.exe,nul.map,,nul.def
32rtm -u > nul
if not exist %tmp%\spciirq.exe goto fehler
rem siegel %tmp%\spciirq.exe
del %tmp%\spciirq.obj


echo * OS/2
call tasm /t /oi /m /ml /dOS2 /iTOOLKIT spciirq.tas %tmp%\spciirq.obj
if not exist %tmp%\spciirq.obj goto fehler

rem link386 /NoIgnoreCase /NoLogo /MAP %tmp%\spciirq.obj,..\spciirq.vk\boot\spciirq.sys,%tmp%\spciirq.map,,spciirq.def
call link.exe /NoIgnoreCase /NoLogo /MAP %tmp%\spciirq.obj,%tmp%\spciirq.sys,%tmp%\spciirq.map,,spciirq.def
if not exist %tmp%\spciirq.sys goto fehler
cd ..\spciirq.vk\boot
call mapsym %tmp%\spciirq.map > nul
cd ..\..\basedev

eautil %tmp%\spciirq.sys nul /s /r
rem call LxLite /D+ /T:%tmp%\spciirq.exe /ZS0 spciirq.sys
call nelite %tmp%\spciirq.sys %tmp%\spciirq.sys /s:%tmp%\spciirq.exe /p:255 > nul
copy %tmp%\spciirq.sys ..\spciirq.vk\boot\spciirq.sys 
copy %tmp%\spciirq.sys ..\spciirq.vk\boot\spciirq.snp
del %tmp%\spciirq.obj 
del %tmp%\spciirq.map
del %tmp%\spciirq.sys
del %tmp%\spciirq.exe


if [%USER%]==[Veit] copy ..\spciirq.vk\boot\spciirq.s?? E:\OS2\BOOT
goto ende

:fehler
echo %0: Fehler
pause

:ende
