@echo off
call dos.bat
call afdr
cls
rem SPCIIRQ 0 7 2 4 11
rem SPCIIRQ 0 7 0 4 11
rem SPCIIRQ Link $63 12

rem 
SPCIIRQ Link $60 10
rem 
SPCIIRQ Link $61 10
rem 
SPCIIRQ Link $62 5
rem 
SPCIIRQ Link $63 10
pause