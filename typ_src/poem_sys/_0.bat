@ECHO OFF
CALL PASBP BIN_PAS .\
CLS
CALL A86 POEM_BIO.A86 TO POEM_BIO.BIN,NUL
PAUSE
BIN_PAS.EXE POEM_BIO.BIN POEM_BIO.PAS
DEL ANTI-VIR.DAT
DEL BIN_PAS.EXE
REM DEL POEM_BIO.BIN