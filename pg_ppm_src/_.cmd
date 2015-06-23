@echo off
call stampdef pg_ppm.def
call pasvpdsp pg_ppm pg_ppm.vk\
copy pg_ppm.vk\pg_ppm.exe pg_ppm.vk\pg_ppm.com
call copywdx pg_ppm.vk\
call pasvpo pg_ppm pg_ppm.vk\

call ..\genvk pg_ppm

cd pg_ppm.vk
call genpgp
cd ..
