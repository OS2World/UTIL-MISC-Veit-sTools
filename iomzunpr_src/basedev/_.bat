@echo off
cls
if exist %tmp%\iomzunpr.obj del %tmp%\iomzunpr.obj
\bp\bin\tasm /t /oi /m /ml /zi iomzunpr.tas %tmp%\iomzunpr.obj > err.pas
type err.pas
if not exist %tmp%\iomzunpr.obj goto fehler

if exist %tmp%\iomzunpr.flt del %tmp%\iomzunpr.flt
call stampdef iomzunpr.def
rem /Linenumbers
link /Map /NoLogo %tmp%\iomzunpr.obj,%tmp%\iomzunpr.flt,%tmp%\iomzunpr.map,,iomzunpr.def
if not exist %tmp%\iomzunpr.flt goto fehler

cd ..\iomzunpr.vk
call nelite %tmp%\iomzunpr.flt iomzunpr.flt > nul
call mapsym %tmp%\iomzunpr.map iomzunpr.sym > nul 2>&1
cd ..\basedev
copy ..\iomzunpr.vk\iomzunpr.flt E:\os2\boot
copy ..\iomzunpr.vk\iomzunpr.sym E:\os2\boot
goto ende

:fehler
pause
:ende
