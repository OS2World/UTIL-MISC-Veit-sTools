@echo off
call dos.bat
call afdr
cls
SPCIIRQ Link $60 11
SPCIIRQ Link $61 11
SPCIIRQ Link $62 5
SPCIIRQ Link $63 11
