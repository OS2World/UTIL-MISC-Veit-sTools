@echo off
cls
call pasvp test_ein .\
test_ein
call pasvp test_aus .\
rem del test$$$.001
rem del test$$$.002
echo ------------------------------------------------------------------
echo on
set lang=en
test_aus
set lang=de
test_aus
@echo off
