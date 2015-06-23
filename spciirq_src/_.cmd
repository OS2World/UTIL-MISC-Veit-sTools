@echo off

echo * BaseDev
cd basedev
call _.bat
cd ..

echo * PAS
cd pas
call _.cmd
cd ..

echo * 4D0
cd 4d0
call _.cmd
cd ..

call ..\genvk.cmd SPciIrq
cd SPciIrq.vk
call noea *
call genpgp
cd ..
