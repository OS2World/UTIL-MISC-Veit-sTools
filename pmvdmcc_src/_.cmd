@echo off
cls
call stampdef pmvdmcc.def
SET DOSSETTING.DPMI_DOS_API=ENABLED
call _.bat
call noea pmvdmcc.vk\* /r
call ..\genvk pmvdmcc
cd pmvdmcc.vk
call genpgp
cd ..