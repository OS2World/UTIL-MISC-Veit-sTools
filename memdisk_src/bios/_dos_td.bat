@echo off
cls
set include=
rem set dpmi32=maxmem 4000
if [%OS%]==[OS2] set %rem_32rtm%=rem
%rem_32rtm% 32rtm > nul

if exist %tmp%\memdisk.obj del %tmp%\memdisk.obj
if exist %tmp%\memdisk.com del %tmp%\memdisk.com
if exist %tmp%\memdisk.tds del %tmp%\memdisk.tds
if exist %tmp%\memdisk.exe del %tmp%\memdisk.exe
if exist       memdisk.exe del       memdisk.exe
if exist       memdisk.com del       memdisk.com
if exist       memdisk.tds del       memdisk.tds

rem /Dserial_debug
rem \bp\bin\
rem \extra\tasm4\
\extra\tasm4\tasmx memdisk.tas %tmp%\memdisk.obj  /oi /ml /zi /m /Ddos /t /Dlanguage_de > err.pas
type err.pas
if not exist %tmp%\memdisk.obj goto fehler

rem \bp\bin\
rem \extra\tasm4\
\bp\bin\tlink /3 /v %tmp%\memdisk.obj,%tmp%\memdisk.exe,nul
if not exist %tmp%\memdisk.exe goto fehler
unp o -o+ %tmp%\memdisk.exe %tmp%\memdisk.tds > nul
rem \extra\tasm4\tlink /3 /t %tmp%\memdisk.obj,%tmp%\memdisk.com,nul
\bp\bin\tlink /3 /t %tmp%\memdisk.obj,%tmp%\memdisk.com,nul
del %tmp%\memdisk.obj
del %tmp%\memdisk.exe

rem ..\memdisk.vk\exe\memcfg.exe %tmp%\memboot.com < ..\memdisk.vk\exe\memcfg.rsp > nul
rem ..\memdisk.vk\exe\memcfg.exe %tmp%\memdisk.com < ..\memdisk.vk\exe\memcfg.rsp
if not exist M:\memcfg.rsp copy ..\memdisk.vk\exe\memcfg.rsp M:\memcfg.rsp
rem if not exist M:\memcfg.rsp sed -e"s/$LoadFont$=false/$LoadFont$=true/g" ** ..\memdisk.vk\exe\memcfg.rsp ** M:\memcfg.rsp
..\memdisk.vk\exe\memcfg.exe %tmp%\memdisk.com < M:\memcfg.rsp > nul

if not [%1]==[] exit

%rem_32rtm% 32rtm /u > nul

rem \extra\tasm4\td %tmp%\memdisk.com
rem
rem \bp\bin\td %tmp%\memdisk.com
rem if     [%os%]==[OS2] call C:\bp\bin\td %tmp%\memdisk.com
rem
if     [%os%]==[OS2] call afd %tmp%\memdisk.com
if not [%os%]==[OS2] call 3dt %tmp%\memdisk.com

rem del %tmp%\memdisk.com
rem del %tmp%\memdisk.tds
goto ende

:fehler
pause

:ende
%rem_32rtm% 32rtm /u > nul
