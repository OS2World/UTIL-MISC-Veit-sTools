@echo off
call rc -r rexx_pm.rc 
call rc -r rexx_vio.rc 
call pasvpo rexx_pm .\
call pasvpo rexx_vio .\
