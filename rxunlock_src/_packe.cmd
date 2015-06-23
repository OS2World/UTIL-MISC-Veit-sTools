@echo off
cd ..\quelle
call quelle rxunlock
cd ..\prog
call prog rxunlock
cd ..\rxunlock
if [%user%]==[Veit] copy rxunlock.vk\*.dll D:\extra\dll