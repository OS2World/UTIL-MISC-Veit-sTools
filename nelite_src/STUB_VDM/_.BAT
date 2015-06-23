@echo off
if exist stub_vmd.com del stub_vmd.com
32rtm > nul
\bp\bin\tasm /t /oi /m stub_vmd.tas > err.pas
\bp\bin\tlink /t stub_vmd.obj,stub_vmd.com
32rtm -r > nul
del stub_vmd.obj
del stub_vmd.map
copy stub_vmd.com ..\nelite.vk\stub_vmd.com
del stub_vmd.com
