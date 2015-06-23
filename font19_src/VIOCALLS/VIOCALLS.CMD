@echo off
cls
call stampdef viocalls.def
if exist viocalls.sym del viocalls.sym
if exist viocalls.dll del viocalls.dll
if exist viocalls.obj del viocalls.obj
\bp\bin\tasm /oi /m /t /ml viocalls.tas > viocalls.err
if errorlevel 1 exit
c:\extra\link386 /map viocalls.obj,viocalls.dll,viocalls.map,,viocalls.def > viocalls.err
if errorlevel 1 exit
if not exist viocalls.dll exit
del viocalls.err
del viocalls.obj
call noea viocalls.dll
call lxlite viocalls.dll
mapsym viocalls.map > nul
del viocalls.map
copy viocalls.dll ..\font19.vk
copy viocalls.sym ..\font19.vk
