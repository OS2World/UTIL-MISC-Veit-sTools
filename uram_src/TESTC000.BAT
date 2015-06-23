@ECHO OFF
TESTC000.COM
PAUSE
REM remove Write Protection from VIDEO ROM
REM    AaaaBbbbCcccDdddEeeeFfff
URAM R=........77..............
PAUSE
TESTC000.COM
PAUSE
