@echo off
cls

rem for turbo assember/linker
set dossetting.DPMI_DOS_API=ENABLED
set dossetting.XMS_MEMORY_LIMIT=9164
set dossetting.DPMI_MEMORY_LIMIT=101

cd os2boot
call _.bat
cd ..\lader
call _.bat
cd ..\nic
call _.cmd
cd ..\os2csm
call _.cmd %1
cd ..
if exist ..\ac\ac.vk\ac.exe copy ..\ac\ac.vk\ac.exe os2csm.vk\exe\
call ..\genvk OS2CSM
cd os2csm.vk
call _set_ea
call genpgp
cd ..
