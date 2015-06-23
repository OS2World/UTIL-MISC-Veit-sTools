@echo off
call stampdef e_msgf.def

if not [%1]==[] goto os2

call pasvpdsp e_msgf e_msgf.vk\
if exist e_msgf.vk\e_msgf.com del e_msgf.vk\e_msgf.com
ren e_msgf.vk\e_msgf.exe *.com
call copywdx e_msgf.vk\

:os2
call pasvp e_msgf e_msgf.vk\
call ..\genvk e_msgf

cd e_msgf.vk
call genpgp
cd ..

if not [%user%]==[Veit] goto ende
if exist c:\extra\e_msgf.exe copy e_msgf.vk\e_msgf.com c:\extra\e_msgf.exe
if exist d:\extra\e_msgf.exe copy e_msgf.vk\e_msgf.exe d:\extra\e_msgf.exe
:ende
