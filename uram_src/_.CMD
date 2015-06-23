@echo off
call _.bat
call ..\genvk URAM
cd uram.vk
call genpgp
cd ..
