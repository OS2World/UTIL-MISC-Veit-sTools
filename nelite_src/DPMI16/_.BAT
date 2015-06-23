@echo off
md 1
cd 1
copy ..\minmax.dll
copy ..\testdll.exe 
..\..\nelite.vk\nelite_d.com minmax.dll  minmax.dll  /s /p:0 /o:-
..\..\nelite.vk\nelite_d.com testdll.exe testdll.exe    /p:0 /h:-
pause
testdll.exe
pause