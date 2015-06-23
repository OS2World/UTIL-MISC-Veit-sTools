@echo off
cls
call stampdef memdisk.def
call _.bat
if exist d:\os2\boot\kbdbase.sys copy ..\memdisk.vk\boot\memdisk.add d:\os2\boot\memdisk.add
if exist d:\os2\boot\kbdbase.sys copy ..\memdisk.vk\boot\memdisk.sym d:\os2\boot\memdisk.sym
if exist e:\os2\boot\kbdbase.sys copy ..\memdisk.vk\boot\memdisk.add e:\os2\boot\memdisk.add
if exist e:\os2\boot\kbdbase.sys copy ..\memdisk.vk\boot\memdisk.sym e:\os2\boot\memdisk.sym
