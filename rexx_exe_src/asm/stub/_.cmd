@echo off
nasm -O9 -fbin -o rexx_vio.com rexx_vio.nas
nasm -O9 -fbin -o rexx_pm.com rexx_pm.nas
exit

del rexx_vio.exe rexx_pm.exe
unp.exe x rexx_vio.com rexx_vio.exe
unp.exe x rexx_pm.com rexx_pm.exe
rem del rexx_vio.com rexx_pm.com
