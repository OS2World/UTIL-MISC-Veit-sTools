@echo off
for %%d in (*.ppm) do del %%d
for %%d in (*.pg) do ..\pg_ppm.vk\pg_ppm.exe %%d
call pmview *.ppm
for %%d in (*.ppm) do del %%d
