@echo off

REM BASEDEV

if exist wpcicfg.obj del wpcicfg.obj
if exist wpcicfg.sys del wpcicfg.sys
C:\bp\bin\tasm /oi /m /zi /ml /t  wpcicfg.tas > err.pas
type err.pas
if not exist wpcicfg.obj goto fehler

link /Alignment:1 /NoLogo /Map:Full wpcicfg.obj,wpcicfg.sys,wpcicfg.map,,wpcicfg.def
call nelite wpcicfg.sys wpcicfg.sys /s /e+ /p:255 > nul
if not exist wpcicfg.obj goto fehler

mapsym wpcicfg
del wpcicfg.map
del wpcicfg.obj

REM SNOOPER

if exist wpcicfgs.obj del wpcicfgs.obj
if exist wpcicfgs.snp del wpcicfgs.snp
rem C:\bp\bin\tasm /oi /m /zi /ml /t /DSNOOPER_INTERNAL_COMMANDLINE wpcicfgs.tas > err.pas
C:\bp\bin\tasm /oi /m /zi /ml /t wpcicfgs.tas > err.pas
type err.pas
if not exist wpcicfgs.obj goto fehler

link /Alignment:1 /NoLogo /Map:Full wpcicfgs.obj,wpcicfgs.snp,wpcicfgs.map,,wpcicfgs.def
call nelite wpcicfgs.snp wpcicfgs.snp /s /e+ /p:255 > nul
if not exist wpcicfgs.obj goto fehler

mapsym wpcicfgs
del wpcicfgs.map
del wpcicfgs.obj

goto ende

:fehler
pause

:ende
