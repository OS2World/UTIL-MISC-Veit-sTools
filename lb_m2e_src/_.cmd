@echo off
cls
call doku.cmd
call stamp_def cdrom.def
call pasvpo.cmd cdrom lb_m2e.vk\
lb_m2e.vk\m2e.exe /q>nul
call pasvpo.cmd m2e_def %tmp%\ @m2e.cfg
%tmp%\m2e_def.exe
del %tmp%\m2e_def.exe
call stampdef m2e.def
call dual.cmd m2e lb_m2e.vk\ /U\unit\sprache2 /I\unit\sprache2 /U\unit\tpsyslow /U\unit\tputils
call noea lb_m2e.vk
call noea lb_m2e.vk\*
call ..\genvk LB_M2E
cd lb_m2e.vk
call genpgp
cd ..
call wpi_.cmd
