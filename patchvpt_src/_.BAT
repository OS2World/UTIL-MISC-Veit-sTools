@ECHO OFF
CALL A86COM 40MHZ PATCHVPT.VK\
CALL A86COMDE VPT_RAM PATCHVPT.VK\
CALL PASBP VPT_LIST PATCHVPT.VK\
CALL PASBP PATCHDEF .\
IF NOT EXIST PATCHDEF.EXE GOTO FEHLER
PATCHDEF.EXE
DEL PATCHDEF.EXE
CALL PASBP PATCHVPT PATCHVPT.VK\
CALL ..\GENVK PATCHVPT
GOTO ENDE

:FEHLER
PAUSE

:ENDE
