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

if exist ..\memdisk.vk\bin\%p2%\os2boot_.ac del ..\memdisk.vk\bin\%p2%\os2boot_.ac
\extra\tasm4\tasmx os2boot_.tas %tmp%\os2boot_.obj /oi /ml /zi /m /Dbios /t /D%p1% %3 %4 %5> err.pas
type err.pas
if not exist %tmp%\os2boot_.obj goto fehler

\extra\tasm4\tlink /3 /t %tmp%\os2boot_.obj,%tmp%\os2boot_.ac,nul.map
if not exist %tmp%\os2boot_.ac goto fehler
copy %tmp%\os2boot_.ac ..\memdisk.vk\bin\%p2%\os2boot_.ac > nul
del %tmp%\os2boot_.*

goto ende

:fehler
echo Fehler: %0,%1,%2,%3
pause
exit

:ende
%rem_32rtm% 32rtm /u > nul
