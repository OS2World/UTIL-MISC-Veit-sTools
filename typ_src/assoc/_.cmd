@echo off
call noea *
call PASVPO assoc .\
rem E:\os2tk45\bin\rc.exe -n -i D:\extra\os2_h assoc.rc assoc.exe
rc16.exe -n -i D:\extra\os2_h assoc.rc assoc.exe
call killchks assoc.exe
EAUtil ASSOC.EXE ASSOC.EA /P /S
EAUtil D:\CMD\TY.CMD ASSOC.EA /J /O
