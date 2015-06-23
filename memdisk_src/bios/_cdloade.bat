@echo off

rem %1=language_?? define
rem %2=language subdir
rem %3=assembler directive (debug)

%rem_32rtm% cls
%rem_32rtm% 32rtm > nul

set blaster=
set include=

rem %1=language_en language_de
rem %2=bin ben bde bdb
set p1=%1
if [%p1%]==[] set p1=language_en
set p2=%2
if [%p2%]==[] set p2=en

if exist ..\memdisk.vk\bin\%p2%\cdloader.bin del ..\memdisk.vk\bin\%p2%\cdloader.bin
rem /Dserial_debug
\extra\tasm4\tasmx cdloader.tas %tmp%\cdloader.obj /oi /ml /zi /m /Dbios /t /D%p1% %3 %4 %5> err.pas
type err.pas
if not exist %tmp%\cdloader.obj goto fehler

\extra\tasm4\tlink /3 /t %tmp%\cdloader.obj,%tmp%\cdloader.bin,nul.map
if not exist %tmp%\cdloader.bin goto fehler
alig2048 %tmp%\cdloader.bin
copy %tmp%\cdloader.bin ..\memdisk.vk\bin\%p2%\cdloader.bin > nul
del %tmp%\cdloader.*

goto ende

:fehler
echo Fehler: %0,%1,%2,%3
pause
exit

:ende
%rem_32rtm% 32rtm /u > nul
