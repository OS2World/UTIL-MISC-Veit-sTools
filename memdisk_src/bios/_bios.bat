@echo off

rem %1=language_?? define
rem %2=language subdir
rem %3=assembler directive (debug)

%rem_32rtm% cls
%rem_32rtm% 32rtm > nul

set blaster=
set include=

set p1=%1
if [%p1%]==[] set p1=language_en
set p2=%2
if [%p2%]==[] set p2=en
rem set p1=%p1% /Dserial_debug

if exist ..\memdisk.vk\bin\%p2%\memboot.bin del ..\memdisk.vk\bin\%p2%\memboot.bin
rem /Dserial_debug
\extra\tasm4\tasmx memdisk.tas %tmp%\memboot.obj /oi /ml /zi /m /Dbios /t /D%p1% %3 %4 %5> err.pas
type err.pas
if not exist %tmp%\memboot.obj goto fehler

\extra\tasm4\tlink /3 /t %tmp%\memboot.obj,%tmp%\memboot.bin,nul.map
if not exist %tmp%\memboot.bin goto fehler
alig2048 %tmp%\memboot.bin
copy %tmp%\memboot.bin ..\memdisk.vk\bin\%p2%\memboot.bin > nul
del %tmp%\memboot.*

goto ende

:fehler
echo Fehler: %0,%1,%2,%3
pause
exit

:ende
%rem_32rtm% 32rtm /u > nul
