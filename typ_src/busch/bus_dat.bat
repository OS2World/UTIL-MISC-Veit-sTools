@ECHO OFF
CALL BPC /B /CP /U.. /I.. BUS_DAT.PAS
IF NOT EXIST BUS_DAT.EXE GOTO FEHLER
CALL TBS BUS_DAT.EXE
DEL *.TPP
IF EXIST ..\TYP_TYPE.TPP DEL ..\TYP_TYPE.TPP
BUS_DAT.EXE
DEL BUS_DAT.EXE
DEL ANTI-VIR.DAT
call BINOBJ32         DAT.DAT EXE___32.OBJ DAT_BUSCH
C:\BP\BIN\BINOBJ DAT.DAT EXE___16.OBJ DAT_BUSCH
DEL DAT.DAT
GOTO ENDE

:FEHLER
PAUSE
:ENDE