@ECHO OFF
CLS
IF [%TMP%]==[] GOTO FEHLER

..\TTMMJJ\TTMMJJ /A86JJJJMMTT DATUM.A86
..\TTMMJJ\TTMMJJ /PASJJJJMMTT DATUM.PAS

SET FEHLER=0

ECHO 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
ECHO � BIN - BIN
CD SYS1
CALL _1_2.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
ECHO � BIN - A86
CD SYS2
CALL _2_3.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
ECHO � ASM
CD ASM
CALL _.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
ECHO � PAS
CD PAS
CALL _.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
ECHO � BOOTCD
CD BOOTCD
CALL _.BAT
CD ..
IF [%FEHLER%]==[1] GOTO ENDE
ECHO 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
GOTO ENDE

:FEHLER
ECHO *FEHLER*
:ENDE
