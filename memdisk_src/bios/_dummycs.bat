@echo off
%rem_32rtm% cls
%rem_32rtm% 32rtm > nul

set blaster=
set include=

if exist ..\memdisk.vk\bin\dummycsm.bin del ..\memdisk.vk\bin\dummycsm.bin
\extra\tasm4\tasmx dummycsm.tas %tmp%\dummycsm.obj /oi /ml /zi /m /t > err.pas
type err.pas
if not exist %tmp%\dummycsm.obj goto fehler

\extra\tasm4\tlink /3 /t %tmp%\dummycsm.obj,%tmp%\dummycsm.bin,nul.map
if not exist %tmp%\dummycsm.bin goto fehler
copy %tmp%\dummycsm.bin ..\memdisk.vk\bin\dummycsm.bin > nul
del %tmp%\dummycsm.*

goto ende

:fehler
echo Fehler: %0,%1,%2,%3
pause
exit

:ende
%rem_32rtm% 32rtm /u > nul
