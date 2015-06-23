@echo off
call stampdef ppm_xga.def
call stampdef xga_ppm.def

call pasvpo ppm_xgad %tmp%\ 
call pasvpo xga_ppmd %tmp%\
%tmp%\ppm_xgad.exe
%tmp%\xga_ppmd.exe
del %tmp%\ppm_xgad.exe
del %tmp%\xga_ppmd.exe

call pasvpdsp ppm_xga xga_ppm.vk\
copy xga_ppm.vk\ppm_xga.exe xga_ppm.vk\ppm_xga.com
call pasvpdsp xga_ppm xga_ppm.vk\
copy xga_ppm.vk\xga_ppm.exe xga_ppm.vk\xga_ppm.com
call copywdx xga_ppm.vk\

call pasvpw ppm_xga xga_ppm.vk\
copy xga_ppm.vk\ppm_xga.exe xga_ppm.vk\ppm_xgaw.exe
call pasvpw xga_ppm xga_ppm.vk\
copy xga_ppm.vk\xga_ppm.exe xga_ppm.vk\xga_ppmw.exe

call pasvpl ppm_xga xga_ppm.vk\
call pasvpl xga_ppm xga_ppm.vk\

call pasvpo ppm_xga xga_ppm.vk\
call pasvpo xga_ppm xga_ppm.vk\

call ..\genvk XGA_PPM
cd XGA_PPM.VK
call genpgp
cd ..
