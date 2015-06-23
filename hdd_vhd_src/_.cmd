@echo off
cls

echo * Datum
stampdef hdd_vhd.def

echo * Sprache
call pasvpo hv_def %tmp%\ /U\unit\sprache2 /I\unit\sprache2
if not exist %tmp%\hv_def.exe goto fehler
%tmp%\hv_def.exe
del %tmp%\hv_def.exe

echo * Win32
if exist hdd_vhd.vk\hdd_vhdw.exe del hdd_vhd.vk\hdd_vhdw.exe
call pasvpwlf hdd_vhd hdd_vhd.vk\ /U\unit\sprache2 /I\unit\sprache2
ren hdd_vhd.vk\hdd_vhd.exe hdd_vhdw.exe

echo * Linux
if exist hdd_vhd.vk\hdd_vhdl del hdd_vhd.vk\hdd_vhdl
call pasvpllf hdd_vhd hdd_vhd.vk\ /U\unit\sprache2 /I\unit\sprache2
ren hdd_vhd.vk\hdd_vhd     hdd_vhdl

echo * OS/2 + DOS
rem call dual hdd_vhd  hdd_vhd.vk\ /U\unit\sprache2 /I\unit\sprache2
call dualolf  hdd_vhd  hdd_vhd.vk\ /U\unit\sprache2 /I\unit\sprache2
if not exist hdd_vhd.vk\hdd_vhd.exe goto fehler


call seticon hdd_vhd.vk\hdd_vhd.exe hdd_vhd.ico

echo * Rest
call ..\genvk hdd_vhd

cd hdd_vhd.vk
call genpgp
cd ..

goto ende

:fehler
echo %0
pause

:ende