@echo off
cls
cd basedev
call _
cd ..\pas
call _
cd ..
call ..\GENVK IOMZUNPR
cd IOMZUNPR.VK
call GENPGP
cd ..
