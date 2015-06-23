@echo off
cls
for %%d in (rexx_vio.obj rexx_vio.exe) do if exist %%d del %%d
c:\bp\bin\tasm /m9 /t /ml /oi rexx_vio.tas
C:\EXTRA\link386.exe /noLogo /NoIgnoreCase /Alignment:1 rexx_vio.obj,rexx_vio.exe,nul.map,,rexx_vio.def
