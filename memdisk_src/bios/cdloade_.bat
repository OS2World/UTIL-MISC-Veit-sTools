@echo off
cls

set blaster=
set include=

rem %1=language_en language_de
rem %2=bin ben bde dbd
set p1=%1
if [%p1%]==[] set p1=language_en
set p2=%2
if [%p2%]==[] set p2=en

if exist %tmp%\cdloader.com del %tmp%\cdloader.com
rem /Dserial_debug
\bp\bin\tasm cdloader.tas %tmp%\cdloader.obj /oi /ml /zi /m /Ddos /t /D%p1% %3 %4 %5> err.pas
type err.pas
if not exist %tmp%\cdloader.obj goto fehler

%rem_32rtm% 32rtm > nul
\bp\bin\tlink /3 /v %tmp%\cdloader.obj,%tmp%\cdloader.com,nul.map
\bp\bin\tdstrip -s -c %tmp%\cdloader.com
%rem_32rtm% 32rtm /u > nul
if not exist %tmp%\cdloader.com goto fehler


rem \bp\bin\td %tmp%\cdloader.com
call %comspec% /c 3dt.bat %tmp%\cdloader.com

del %tmp%\cdloader.obj
del %tmp%\cdloader.com
del %tmp%\cdloader.tds

goto ende

:fehler
echo Fehler: %0,%1,%2,%3
pause
exit

:ende
