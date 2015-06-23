@echo off
32rtm

if exist %tmp%\uram.obj del %tmp%\uram.obj
a86 +c +O +G16 uram.a86 to %tmp%\uram.obj
if not exist %tmp%\uram.obj goto fehler

if exist %tmp%\uram386.obj del %tmp%\uram386.obj
rem 
c:\bp\bin\tasm /oi /m /ml /Ddebug386 uram386.tas, %tmp%\uram386.obj, %tmp%\uram386.lst > err.pas
rem c:\extra\tasm32\tasm32 /oi /m /ml uram386.tas, %tmp%\uram386.obj, %tmp%\uram386.lst > err.pas
type err.pas
if not exist %tmp%\uram386.obj goto fehler

if exist %tmp%\uram.com del %tmp%\uram.com
link.exe /Tiny /NoLogo %tmp%\uram.obj+%tmp%\uram386.obj,%tmp%\uram.com,%tmp%\uram.map,,nul.def
if not exist %tmp%\uram.com goto fehler
copy %tmp%\uram.com uram.vk\uram.com
siegel uram.vk\uram.com
if exist C:\extra\uram\uram.com copy uram.vk\uram.com C:\extra\uram\uram.com
goto ende

:fehler
pause

:ende

