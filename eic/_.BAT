@ECHO OFF
CALL BAT2EXEC TEST.B
REM COPY SNP.COM TMP.COM
COPY TEST.COM TMP.COM
REM COPY COM_1.COM TMP.COM
ECHO [EIC]>>TMP.COM
BINOBJ TMP.COM TEST.OBJ TEST_COM
DEL TMP.COM
CALL PASBP GUI .\
