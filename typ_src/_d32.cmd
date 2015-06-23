@ECHO OFF
IF [%VPBASE%]==[] SET VPBASE=Y:\vp21
SET VPOUT=%VPBASE%\OUT.D32
IF [%VPOUT%]==[] GOTO ENDE

ECHO � L�schen alter Dateien ...
FOR %%D IN (%VPOUT%\*.* %VPOUT%\UNITS\*.*) DO DEL %%D

ECHO � L�schen der alten EXE
IF EXIST TYP.VK\TYP3.EXE    DEL TYP.VK\TYP3.EXE
IF EXIST TYP.VK\TYPEIN3.EXE DEL TYP.VK\TYPEIN3.EXE

ECHO Datumsdatei ...
CALL ..\TTMMJJ\TTMMJJ.EXE /PAS TYPDATUM.PAS

ECHO Compiler + Linker ...
CALL PASVPDSp TYP    .\ -I.\INC_D32 @TYP.CFG    /T /GD
CALL PASVPDSp TYPEIN .\ -I.\INC_D32 @TYPEIN.CFG /T /GD

ECHO Umbenennen+[Siegel]
COPY .\TYP.EXE    .\TYP.VK\TYP3.EXE
COPY .\TYPEIN.EXE .\TYP.VK\TYPEIN3.EXE
DEL .\TYP.EXE
DEL .\TYPEIN.EXE
SIEGEL .\TYP.VK\TYP3.EXE
SIEGEL .\TYP.VK\TYPEIN3.EXE

call CopyWDX .\TYP.VK\

:ENDE