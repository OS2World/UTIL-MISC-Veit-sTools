@echo off
for %%d in (icd.com ice.com) do if exist ..\vk\%%d del ..\vk\%%d
tasm /t /oi /m icd.tas
tlink /t icd.obj
tasm /t /oi /m ice.tas
tlink /t ice.obj
for %%d in (*.map *.obj) do del %%d

copy icd.com ..\uram.vk\icd.com
copy ice.com ..\uram.vk\ice.com
del icd.com
del ice.com
