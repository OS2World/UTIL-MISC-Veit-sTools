@echo off
if exist menu_nic.txt del menu_nic.txt 
if exist gennmenu.exe del gennmenu.exe
call stampdef gennmenu.def
call pasvpo  gennmenu ..\os2csm.vk\exe\
copy nic.lst ..\os2csm.vk\example\nic.lst
..\os2csm.vk\exe\gennmenu.exe nic.lst 4 ..\os2csm.vk\example\menu_nic.txt 
..\os2csm.vk\exe\gennmenu.exe nic.lst 4 ..\os2csm.vk\example\menu_nid.txt democd.lst
