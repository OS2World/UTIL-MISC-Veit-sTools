@echo off
cls
cd viocalls
call viocalls.cmd
cd ..\pas
call _.cmd
cd ..
call noea font19.vk\*
call ..\genvk Font19
cd Font19.vk
call genpgp
cd ..
