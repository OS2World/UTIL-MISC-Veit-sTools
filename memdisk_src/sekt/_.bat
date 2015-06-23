@echo off
cls
if exist ..\memdisk.vk\bin\memboot.sek del ..\memdisk.vk\bin\memboot.sek
if exist ..\memdisk.vk\bin\os2ldr.sek  del ..\memdisk.vk\bin\os2ldr.sek
if exist ..\memdisk.vk\bin\drdos.sek   del ..\memdisk.vk\bin\drdos.sek
if exist ..\memdisk.vk\bin\edrdos.sek  del ..\memdisk.vk\bin\edrdos.sek

c:\bp\bin\tasm /oi /m /ml /t /dlang_english /dload_memboot     memboots.tas,memboots.obj >err.pas
if not exist memboots.obj exit
c:\bp\bin\tasm /oi /m /ml /t /dlang_english /dload_os2ldr      memboots.tas,os2ldr.obj   >err.pas
if not exist os2ldr.obj exit
c:\bp\bin\tasm /oi /m /ml /t /dlang_english /dload_ibmbio_com  memboots.tas,drdos.obj    >err.pas
if not exist drdos.obj exit
c:\bp\bin\tasm /oi /m /ml /t /dlang_english /dload_drbio_sys   memboots.tas,edrdos.obj   >err.pas
if not exist edrdos.obj exit

tlink /x /n /c memboots.obj
if not exist memboots.exe exit
tlink /x /n /c os2ldr.obj
if not exist os2ldr.exe exit
tlink /x /n /c drdos.obj
if not exist drdos.exe exit
tlink /x /n /c edrdos.obj
if not exist edrdos.exe exit

del memboots.obj
del os2ldr.obj
del drdos.obj
del edrdos.obj
schnitt memboots.exe -$200 $200 ..\memdisk.vk\bin\memboot.sek
schnitt os2ldr.exe   -$200 $200 ..\memdisk.vk\bin\os2ldr.sek
schnitt drdos.exe    -$200 $200 ..\memdisk.vk\bin\drdos.sek
schnitt edrdos.exe   -$200 $200 ..\memdisk.vk\bin\edrdos.sek
del memboots.exe
del os2ldr.exe
del drdos.exe
del edrdos.exe
