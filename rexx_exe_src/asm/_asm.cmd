@echo off
if [%1]==[] exit
cls
stampdef %1.def
for %%d in (%1.obj %1.exe) do if exist %%d del %%d
c:\bp\bin\tasm /m9 /t /ml /oi %1.tas
if not exist %1.obj goto fehler
link386 /noLogo /NoIgnoreCase /Alignment:1 %1.obj,%1.exe,nul.map,,%1.def
if not exist %1.exe goto fehler
del %1.obj
call rc -n -x2 %1.rc
del %1.res
call lx %1.exe /t:stub\%1.com /zs /f+
goto ende

:fehler
echo %0,%1
pause

:ende