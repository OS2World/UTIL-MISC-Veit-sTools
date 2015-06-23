@ECHO OFF
REM
REM Make an OS/2 Exe from Pascal Source
REM %1.PAS=main program file
REM %2    =target directory
REM

SET VPBASE=D:\VP20
SET OUT=%VPBASE%\OUT.OS2

REM þ check parameters
IF [%1]==[] GOTO FEHLER
IF [%2]==[] GOTO FEHLER

REM þ check if source rely exist
IF NOT EXIST %1.PAS GOTO DATEI_FEHLT

REM þ del old exe,..
IF EXIST %OUT%\UNITS\%1.LNK DEL %OUT%\UNITS\%1.LNK
IF EXIST %OUT%\UNITS\%1.VPI DEL %OUT%\UNITS\%1.VPI
IF EXIST %OUT%\UNITS\%1.OBJ DEL %OUT%\UNITS\%1.OBJ
IF EXIST %OUT%\%1.EXE       DEL %OUT%\%1.EXE

REM þ exist an complier config file in current directory ?
IF EXIST VPC.CFG SET CFG1=@VPC.CFG

REM þ compile
%VPBASE%\BIN.OS2\VPC.EXE -CO @D:\VP20\BIN.OS2\VPC_.CFG %1.PAS %CFG1% %3 %4 %5 %6 %7 %8 %9

REM þ erase temp files
IF EXIST %OUT%\UNITS\%1.LNK DEL %OUT%\UNITS\%1.LNK
IF EXIST %OUT%\UNITS\%1.VPI DEL %OUT%\UNITS\%1.VPI
IF EXIST %OUT%\UNITS\%1.OBJ DEL %OUT%\UNITS\%1.OBJ

REM þ compile successful ?
IF NOT EXIST %OUT%\%1.EXE GOTO ENDE

REM þ compress/bind stub
D:\EXTRA\LXLITE\LXLITE.EXE /T:STUB_VDM.BIN %OUT%\%1.EXE
SIEGEL %OUT%\%1.EXE

REM þ delete existing target executable in current dir
IF EXIST %2%1.EXE DEL %2%1.EXE

REM þ move result if needed
IF NOT [%OUT%\]==[%2] COPY %OUT%\%1.EXE %2%1.EXE
IF NOT [%OUT%\]==[%2] DEL  %OUT%\%1.EXE
GOTO ENDE

:FEHLER
ECHO %1,%2
ECHO PASVP (Quelltext) ohne .PAS
GOTO ENDE

:DATEI_FEHLT
ECHO %1.PAS fehlt
GOTO ENDE

:ENDE
