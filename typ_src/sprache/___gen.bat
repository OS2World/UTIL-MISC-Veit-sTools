@ECHO OFF
IF NOT EXIST SPRACHE\SPR_%1.PAS GOTO FEHLT
CALL TPC -ISPRACHE\ -E%TMP%\ -DGEN SPRACHE\SPR_%1.PAS
IF NOT EXIST %TMP%\SPR_%1.EXE GOTO FEHLER2
CD INC_GEN
%TMP%\SPR_%1.EXE
CD ..
DEL %TMP%\SPR_%1.EXE
GOTO ENDE

:FEHLT
ECHO [SPRACHE\SPR_%1.PAS FEHLT]
:FEHLER2
PAUSE
:ENDE
