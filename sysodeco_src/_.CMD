@echo off
call stampdef sysodeco.def

rem DPMI32
rem call pasvpdsp sysodeco sysodeco.vk\
rem copy sysodeco.vk\sysodeco.exe sysodeco.vk\sysodeco.com
rem call copywdx sysodeco.vk\

rem OS/2
rem call pasvp  sysodeco sysodeco.vk\

call dual sysodeco sysodeco.vk\ /U\unit\tputils
call ..\genvk SysoDeco
cd sysodeco.vk
call genpgp
cd ..

if exist c:\extra\SysoDeco.exe copy SysoDeco.vk\SysoDeco.exe c:\extra\SysoDeco.exe