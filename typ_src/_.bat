@ECHO OFF
IF [%TMP%]==[] GOTO FEHLER
SET TYP=%TMP%\1
IF [%TYP%]==[] GOTO FEHLER
MD %TYP%
FOR %%D IN (*.EXE *.TPU *.TPP *.OBJ *.VPI *.OVR                        ) DO DEL %%D
FOR %%D IN (%TYP%\*.EXE %TYP%\*.TPU %TYP%\*.TPP %TYP%\*.OBJ %TYP%\*.VPI %TYP%\*.OVR ) DO DEL %%D
FOR %%D IN (TYP.VK\TYP.EXE TYP.VK\TYP.OVR TYP.VK\TYPEIN.EXE ) DO DEL %%D
CLS
ECHO ���������������������������������������������������������������������������
ECHO Datumsdatei ...
CALL ..\TTMMJJ\TTMMJJ.EXE /PAS TYPDATUM.PAS
ECHO ���������������������������������������������������������������������������
TPC -B -DENDVERSION;VARIANTE_DOS;TYP_EXE;TYP_DOS TYP.PAS -E%TYP% -IINC_DOS -IINC_GEN -UBUSCH
IF ERRORLEVEL 1 GOTO FEHLER
ECHO ���������������������������������������������������������������������������
TPC -B -DENDVERSION;VARIANTE_DOS;TYPEIN_EXE;TYP_DOS TYPEIN.PAS -E%TYP% -IINC_DOS -IINC_GEN
IF ERRORLEVEL 1 GOTO FEHLER
ECHO ���������������������������������������������������������������������������
SIEGEL %TYP%\TYP.EXE
SIEGEL %TYP%\TYPEIN.EXE
IF EXIST %TYP%\TYP.OVR COPY /B %TYP%\TYP.EXE + %TYP%\TYP.OVR TYP.VK\TYP.EXE
IF NOT EXIST %TYP%\TYP.OVR COPY COPY %TYP%\TYP.EXE TYP.VK\TYP.EXE
COPY %TYP%\TYPEIN.EXE  TYP.VK\TYPEIN.EXE
COPY TYP.VK\TYP.EXE    C:\SONST\TYP.EXE
rem CALL ..\GENVK Typ

FOR %%D IN (%TYP%\*.*) DO DEL %%D
RD %TYP%
GOTO ENDE

:FEHLER
ECHO 
ECHO ******** Fehler ********
PAUSE

:ENDE
