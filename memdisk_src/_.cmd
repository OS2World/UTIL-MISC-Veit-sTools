@echo off
cls

rem for turbo assember/linker
set dossetting.DPMI_DOS_API=ENABLED
set dossetting.XMS_MEMORY_LIMIT=9164
set dossetting.DPMI_MEMORY_LIMIT=101

cd bios
call _.bat

cd ..\cfg
call _.cmd

cd ..\erasefil
call _.bat

cd ..\os2
call _.cmd

cd ..\packfile
call _.cmd

cd ..\sekt
call _.bat

cd ..\wboot
call _.cmd

cd ..\MemDisk.vk\exe
if exist demo.iso del demo.iso
if exist unicode.tar del unicode.tar
for %%d in (OS_FILES\*) do del %%d                      >nul 2>&1
for %%d in (RESULT\*) do del %%d                        >nul 2>&1
for %%d in (RESULT\BOOTIMGS\*) do del %%d               >nul 2>&1
for %%d in (DRDOSTMP\*) do del %%d                      >nul 2>&1
for %%d in (DRDOSTMP\BOOTIMGS\*) do del %%d             >nul 2>&1
rmdir OS_FILES                                          >nul 2>&1
rmdir RESULT\BOOTIMGS                                   >nul 2>&1
rmdir RESULT                                            >nul 2>&1
rmdir DRDOSTMP\BOOTIMGS                                 >nul 2>&1
rmdir DRDOSTMP                                          >nul 2>&1
cd ..\..

echo on
call ..\genvk MemDisk
cd MemDisk.VK

call genpgp
cd ..
