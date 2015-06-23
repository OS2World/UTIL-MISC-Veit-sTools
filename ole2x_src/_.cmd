@echo off
cls
call stampdef ole2x.def
for %%d in ( ole2x_d.com ole2x_l ole2x_o.exe ole2x_w.exe ) do if exist ole2x.vk\%%d del ole2x.vk\%%d

call pasvpo ole2x ole2x.vk\ @ole2x.cfg
ren ole2x.vk\ole2x.exe ole2x_o.exe

call pasvpw ole2x ole2x.vk\ @ole2x.cfg
ren ole2x.vk\ole2x.exe ole2x_w.exe

call pasvpdsp ole2x ole2x.vk\ @ole2x.cfg
ren ole2x.vk\ole2x.exe ole2x_d.com

call copywdx ole2x.vk\
call pasvpl ole2x ole2x.vk\ @ole2x.cfg
ren ole2x.vk\ole2x     ole2x_l

call ..\genvk ole2x

cd ole2x.vk
call genpgp
cd ..

if [%User%]==[Veit] copy ole2x.vk\ole2x_o.exe D:\extra\ole2x.exe
