@ECHO OFF
REM %TYP%=Verzeichnis fÅr TemporÑre Dateien
SET TYP=%TMP%\1
IF [%TYP%]==[] GOTO ENDE
MD %TYP%

ECHO Lîschen alter Dateien ...
FOR %%D IN (%TYP%\*.*) DO DEL %%D
IF EXIST TYP.VK\TYP5 DEL TYP.VK\TYP5

ECHO Datumsdatei ...
CALL ..\TTMMJJ\TTMMJJ.EXE /PAS TYPDATUM.PAS

ECHO Compiler + Linker ...
CALL PASVPLLF TYP  %TYP%\ -I.\INC_LLF -I%TYP% -O%TYP% @TYP.CFG

ECHO Kopieren
COPY %TYP%\TYP TYP.VK\TYP5

FOR %%D IN (%TYP%\*.*) DO DEL %%D
RD %TYP%

:ENDE
