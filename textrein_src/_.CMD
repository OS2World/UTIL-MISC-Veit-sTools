@ECHO OFF
CALL PASVP TEXTRDEF .\
TEXTRDEF.EXE
DEL TEXTRDEF.EXE
CALL DUAL TEXTREIN TEXTREIN.VK\
CALL ..\GENVK Textrein
