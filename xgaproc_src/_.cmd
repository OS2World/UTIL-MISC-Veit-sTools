@echo off
set log=0
cls
call stampdef xgaproc.def 
call stampdef xgafunc.def 

if [%log%]==[0] call pasvpo xgaproc %tmp%\
if [%log%]==[1] call pasvpo xgaproc %tmp%\ /dLOG_TO_FILE

rem copy %tmp%\xgaproc.dll .\xgaproc.vk\
del %tmp%\xgaproc.dll

if [%log%]==[0] link386 /NoLogo /Map:Detailed /NoIgnoreCase %vpbase%\out.os2\units\XGAFUNC.lib,.\xgaproc.vk\XGAPROC.DLL,%tmp%\xgaproc.map,%vpbase%\lib.os2\os2.lib+%vpbase%\out.os2\units\vputils.lib+%vpbase%\units.os2\system.lib                               ,xgafunc.def
if [%log%]==[1] link386 /NoLogo /Map:Detailed /NoIgnoreCase %vpbase%\out.os2\units\XGAFUNC.lib,.\xgaproc.vk\XGAPROC.DLL,%tmp%\xgaproc.map,%vpbase%\lib.os2\os2.lib+%vpbase%\out.os2\units\vputils.lib+%vpbase%\units.os2\system.lib+%vpbase%\out.os2\units\log.lib,xgafunc.def
call mapsym %tmp%\xgaproc.map .\xgaproc.vk\xgaproc.sym > nul 2>&1
del %tmp%\xgaproc.map
if exist xgaproc.sym copy xgaproc.sym .\xgaproc.vk\xgaproc.sym
if exist xgaproc.sym del xgaproc.sym

call lxlite .\xgaproc.vk\xgaproc.dll
if exist E:\MMOS2\DLL\xgaproc.dll copy .\xgaproc.vk\xgaproc.dll E:\MMOS2\DLL\xgaproc.dll

call ..\genvk XGAProc

cd xgaproc.vk
call genpgp
cd ..
