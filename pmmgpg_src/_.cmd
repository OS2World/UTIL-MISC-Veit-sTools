@echo off
cls
call pmmgpg.cmd
if errorlevel 100 goto error
if errorlevel  99 goto compile
if errorlevel  98 goto error
:compile
call rexx2vio.cmd pmmgpg.cmd pmmgpg.vk\exe\pgp.exe
if exist E:\BSW-Inc\PMMail\pgp.exe copy pmmgpg.vk\exe\pgp.exe E:\BSW-Inc\PMMail\pgp.exe
:error
call ..\genvk PMMGPG
cd pmmgpg.vk
call genpgp
cd ..
