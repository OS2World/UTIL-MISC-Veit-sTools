@echo off
set log=0
cls
call stampdef lgoproc.def 
call stampdef lgofunc.def 

if [%log%]==[0] call pasvpo lgoproc %tmp%\
if [%log%]==[1] call pasvpo lgoproc %tmp%\ /dLOG_TO_FILE

rem copy %tmp%\lgoproc.dll .\lgoproc.vk\
del %tmp%\lgoproc.dll

if [%log%]==[0] link386 /NoLogo /Map:Detailed /NoIgnoreCase %vpbase%\out.os2\units\lgoFUNC.lib,.\lgoproc.vk\lgoPROC.DLL,%tmp%\lgoproc.map,%vpbase%\lib.os2\os2.lib+%vpbase%\out.os2\units\vputils.lib+%vpbase%\units.os2\system.lib+%vpbase%\out.os2\units\lgo.lib                               ,lgofunc.def
if [%log%]==[1] link386 /NoLogo /Map:Detailed /NoIgnoreCase %vpbase%\out.os2\units\lgoFUNC.lib,.\lgoproc.vk\lgoPROC.DLL,%tmp%\lgoproc.map,%vpbase%\lib.os2\os2.lib+%vpbase%\out.os2\units\vputils.lib+%vpbase%\units.os2\system.lib+%vpbase%\out.os2\units\lgo.lib+%vpbase%\out.os2\units\log.lib,lgofunc.def

call mapsym %tmp%\lgoproc.map .\lgoproc.vk\lgoproc.sym > nul 2>&1
del %tmp%\lgoproc.map
if exist lgoproc.sym copy lgoproc.sym .\lgoproc.vk\lgoproc.sym
if exist lgoproc.sym del lgoproc.sym

call lxlite .\lgoproc.vk\lgoproc.dll
if exist E:\MMOS2\DLL\lgoproc.sym copy .\lgoproc.vk\lgoproc.dll E:\MMOS2\DLL\lgoproc.dll
if exist E:\MMOS2\DLL\lgoproc.sym copy .\lgoproc.vk\lgoproc.sym E:\MMOS2\DLL\lgoproc.sym

call ..\genvk LGOProc

cd lgoproc.vk
call genpgp
cd ..
