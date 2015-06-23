@echo off
call wakeup.bat
call ..\genvk wakeup
cd wakeup.vk
call genpgp
cd ..
