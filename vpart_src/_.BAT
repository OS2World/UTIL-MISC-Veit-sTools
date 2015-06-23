@ECHO OFF
CLS
IF [%TMP%]==[] GOTO FEHLER

..\TTMMJJ\TTMMJJ /A86JJJJMMTT DATUM.A86
..\TTMMJJ\TTMMJJ /PASJJJJMMTT DATUM.PAS

SET FEHLER=0

ECHO ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ECHO ю BIN - BIN
CD SYS1
CALL _1_2.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ECHO ю BIN - A86
CD SYS2
CALL _2_3.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ECHO ю ASM
CD ASM
CALL _.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ECHO ю PAS
CD PAS
CALL _.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
ECHO ю BOOTCD
CD BOOTCD
CALL _.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
GOTO ENDE

:FEHLER
ECHO *FEHLER*
:ENDE
