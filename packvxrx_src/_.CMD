@echo off
call pasvpo packvx_d %tmp%\ @sprache2.cfg
%tmp%\packvx_d.exe
del %tmp%\packvx_d.exe
call pasvpdsp packvxrx packvxrx.vk\ @sprache2.cfg
copy packvxrx.vk\packvxrx.exe packvxrx.vk\packvxrx.com
call copywdx packvxrx.vk\
call pasvpo packvxrx packvxrx.vk\ @sprache2.cfg
call ..\genvk packvxrx
