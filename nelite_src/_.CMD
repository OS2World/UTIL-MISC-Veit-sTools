@echo off
cls
if [%1]==[o] goto l1

if exist out.exe del out.exe

stampdef nelite.def

echo þ DPMI32
if exist nelite.vk\nelite_d.com del nelite.vk\nelite_d.com
call D:\CMD\PASVPDSP nelite nelite.vk\
call CopyWDX nelite.vk\
ren nelite.vk\nelite.exe nelite_d.com

echo þ Linux
if exist nelite.vk\nelite_l del nelite.vk\nelite_l
call D:\CMD\PASVPL nelite nelite.vk\
ren nelite.vk\nelite nelite_l

echo þ Win32
if exist nelite.vk\nelite_w.exe del nelite.vk\nelite_w.exe
call D:\CMD\PASVPW nelite nelite.vk\
ren nelite.vk\nelite.exe nelite_w.exe

:l1
echo þ OS/2
call D:\CMD\PASVPO nelite nelite.vk\

call ..\genvk NeLite

cd NeLite.vk
call genpgp
cd ..

if [%user%]==[Veit] copy nelite.vk\nelite_d.com c:\extra\nelite.exe
if [%user%]==[Veit] copy nelite.vk\nelite.exe d:\extra\nelite.exe
