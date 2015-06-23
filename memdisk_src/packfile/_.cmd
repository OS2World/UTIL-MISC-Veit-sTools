@echo off
stampdef packfile.def
call pasvpdsp  packfile ..\memdisk.vk\exe\
copy ..\memdisk.vk\exe\packfile.exe ..\memdisk.vk\exe\packfile.com
call copywdx ..\memdisk.vk\exe\
call pasvpo  packfile ..\memdisk.vk\exe\
rem call pasvpl  packfile ..\memdisk.vk\exe\
rem call pasvpw  packfile ..\memdisk.vk\exe\

stampdef e_pf.def
call pasvpdsp e_pf ..\memdisk.vk\exe\
copy ..\memdisk.vk\exe\e_pf.exe ..\memdisk.vk\exe\e_pf.com
call pasvpo e_pf ..\memdisk.vk\exe\
