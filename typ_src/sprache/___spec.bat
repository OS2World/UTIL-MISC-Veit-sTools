@ECHO OFF
IF NOT EXIST SPRACHE\SPR_%1.PAS GOTO FEHLT

CALL TPC -ISPRACHE\ -E%TMP%\ -DDOS SPRACHE\SPR_%1.PAS
IF NOT EXIST %TMP%\SPR_%1.EXE GOTO FEHLER2
CD INC_DOS
%TMP%\SPR_%1.EXE
CD ..

CALL TPC -ISPRACHE\ -E%TMP%\ -DDOS SPRACHE\SPR_%1.PAS -DSPRDE
IF NOT EXIST %TMP%\SPR_%1.EXE GOTO FEHLER2
CD INC_DOSD
%TMP%\SPR_%1.EXE
CD ..

CALL TPC -ISPRACHE\ -E%TMP%\ -DOS2 SPRACHE\SPR_%1.PAS
CD INC_OS2
%TMP%\SPR_%1.EXE
COPY $$$_%1*.00? ..\INC_OLF
CD ..

CALL TPC -ISPRACHE\ -E%TMP%\ -DDPMI32 SPRACHE\SPR_%1.PAS
CD INC_D32
%TMP%\SPR_%1.EXE
CD ..

CALL TPC -ISPRACHE\ -E%TMP%\ -DWin32 SPRACHE\SPR_%1.PAS
CD INC_W32
%TMP%\SPR_%1.EXE
COPY $$$_%1*.00? ..\INC_WLF
CD ..

CALL TPC -ISPRACHE\ -E%TMP%\ -DLinux SPRACHE\SPR_%1.PAS
CD INC_LNX
%TMP%\SPR_%1.EXE
COPY $$$_%1*.00? ..\INC_LLF
CD ..

DEL %TMP%\SPR_%1.EXE
GOTO ENDE

:FEHLT
ECHO [SPRACHE\SPR_%1.PAS FEHLT]
:FEHLER2
PAUSE
:ENDE

