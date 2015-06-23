@echo off
call pasvpo via_bios %tmp%\
%tmp%\via_bios.exe > ..\basedev\via_bios.inc
del %tmp%\via_bios.exe
