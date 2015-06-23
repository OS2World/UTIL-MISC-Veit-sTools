@echo off
cls
if exist rxunlock.zip del rxunlock.zip
call stampdef rxunlock.def
call pasvpo64 rxunlock rxunlock.vk\ /U\unit\md5
copy %tmp%\rxunlock.dll rxunlock.vk

call lxf rxunlock.vk\rxunlock.dll
call noea rxunlock.vk\*

rem cd rxunlock.vk
rem zip.exe -9 ..\rxunlock.zip *
rem cd ..

call ..\genvk RxUnlock

cd rxunlock.vk
call genpgp
cd ..

