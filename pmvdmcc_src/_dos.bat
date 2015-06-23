@echo off
cls
c:\bp\bin\tasm /dDOS /t /oi /m /ml pmvdmcc.tas %tmp%\pmvdmcc.obj > err.pas
type err.pas
if not exist %tmp%\pmvdmcc.obj goto fehler
link /NoLogo %tmp%\pmvdmcc.obj,%tmp%\pmvdmcc.exe,nul.map,,nul.def
goto ende

:fehler
echo Fehler (%0)
pause

:ende