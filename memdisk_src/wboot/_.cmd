@echo off
call stampdef rboot.def
call dual rboot ..\memdisk.vk\exe\
call stampdef wboot.def
call dual wboot ..\memdisk.vk\exe\
