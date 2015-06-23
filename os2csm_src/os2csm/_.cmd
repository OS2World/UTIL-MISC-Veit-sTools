@ECHO OFF

call stampdef os2csm.def
call stampdef align512.def
call stampdef checkcsm.def

call pasvpo os2csm_d %tmp%\ @sprache2.cfg
if not exist %tmp%\os2csm_d.exe goto fehler
%tmp%\os2csm_d.exe
del %tmp%\os2csm_d.exe

if not [%1]==[] goto nicht_dos
call pasvpdsp os2csm ..\os2csm.vk\exe\ @sprache2.cfg
if exist ..\os2csm.vk\exe\os2csm.com del ..\os2csm.vk\exe\os2csm.com
ren ..\os2csm.vk\exe\os2csm.exe *.com
call CopyWDX ..\os2csm.vk\exe\

:nicht_dos

call pasvpo os2csm   ..\os2csm.vk\exe\ @sprache2.cfg
call pasvpo align512 ..\os2csm.vk\exe\ @sprache2.cfg
call pasvpo checkcsm ..\os2csm.vk\exe\ @sprache2.cfg
goto ende

:fehler
echo %0: Fehler
pause

:ende
