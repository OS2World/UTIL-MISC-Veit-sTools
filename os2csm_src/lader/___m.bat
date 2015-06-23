@echo off
if [%1]==[] goto alle_sprachen

32rtm > nul
if exist %tmp%\lader_%2.obj del %tmp%\lader_%2.obj
if exist %tmp%\lader_%2.lst del %tmp%\lader_%2.lst
if exist %tmp%\lader_%2.map del %tmp%\lader_%2.map
c:\bp\bin\tasm /n /t /oi /m /ml /Dmemdisk /Dnodebug lader_%2.tas, %tmp%\lader_%2.obj > err.pas
type err.pas
if not exist %tmp%\lader_%2.obj goto fehler
c:\bp\bin\tlink /3 /x %tmp%\lader_%2.obj,%tmp%\lader_%2.exe,,
del %tmp%\lader_%2.obj
if not exist %tmp%\lader_%2.exe goto fehler
if exist ..\os2csm.vk\bin\%2\os2csmm.bin del ..\os2csm.vk\bin\%2\os2csmm.bin
exe2bin %tmp%\lader_%2.exe ..\os2csm.vk\bin\%2\os2csmm.bin
if not exist ..\os2csm.vk\bin\%2\os2csmm.bin goto fehler
del %tmp%\lader_%2.exe
goto ende

:alle_sprachen
cls
call %0 d de
call %0 e en
call %0 s sp
call %0 f fr
call %0 n nl
call %0 r ru
call %0 i it
call %0 j jp
goto ende

:fehler
pause

:ende
32rtm -u > nul
