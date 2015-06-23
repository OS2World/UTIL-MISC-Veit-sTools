@echo off
cls

CD DOS
CALL _
CD ..


CD OS2
CALL _
CD ..

call lxlite /c:newstub ice.vk\icd.exe /T:ice.vk\icd.dos
call lxlite /c:newstub ice.vk\ice.exe /T:ice.vk\ice.dos
del ice.vk\icd.dos
del ice.vk\ice.dos

call ..\genvk ICE
cd ice.vk
call genpgp
cd ..

