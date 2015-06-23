@echo off
if [%warpin%]==[] set warpin=D:\extra\warpin

set beginlibpath=%warpin%;%beginlibpath%

if exist lb_m2e.wpi del lb_m2e.wpi

%warpin%\wic lb_m2e.wpi -a 1 -clb_m2e.vk m2e.exe m2e.ico m2e.deu m2e.eng m2e.inf m2e.loa pipe_m2e.* cdrom.exe -s lb_m2e.wis

rem wpi_besc.exe lb_m2e.wpi "Maestro 2E pipe mixer driver for LBMIX" "Veit Kannegieser"

echo version in lb_m2e.wis „ndern...
find "packageid" < lb_m2e.wis 
pause