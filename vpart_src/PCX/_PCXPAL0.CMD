@echo off
if [%1]==[] exit
alchos2 -p -f ..\vpart.vk\alchemy.pal -d0 %1 %tmp%\%1
copy %tmp%\%1 %1
del %tmp%\%1
