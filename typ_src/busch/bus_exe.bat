@ECHO OFF
CALL BPC /B /CP /U.. /I.. BUS_EXE0.PAS
IF NOT EXIST BUS_EXE0.EXE GOTO FEHLER
CALL TBS BUS_EXE0.EXE
DEL *.TPP
IF EXIST ..\TYP_TYPE.TPP DEL ..\TYP_TYPE.TPP
BUS_EXE0.EXE
DEL BUS_EXE0.EXE
DEL ANTI-VIR.DAT
BINOBJ32         EXE.DAT EXE___32.OBJ EXE_BUSCH
C:\BP\BIN\BINOBJ EXE.DAT EXE___16.OBJ EXE_BUSCH
DEL EXE.DAT
GOTO ENDE

:FEHLER
PAUSE
:ENDE