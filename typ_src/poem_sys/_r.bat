@ECHO OFF
CALL PASBP BIN_PAS .\
CLS
CALL A86 POEM_ROM.A86 TO POEM_ROM.BIN,NUL
PAUSE
BIN_PAS.EXE POEM_ROM.BIN POEM_ROM.PAS
DEL ANTI-VIR.DAT
DEL BIN_PAS.EXE
REM DEL POEM_ROM.BIN