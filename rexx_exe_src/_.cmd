@echo off
cd asm
call _.cmd
cd ..

copy asm\rexx_*.exe rexx_exe.vk\exe
call rexx_exe.vk\exe\rexx2vio.cmd rexx_exe.vk\exe\rexx2vio.cmd
     rexx_exe.vk\exe\rexx2vio.exe rexx_exe.vk\exe\rexx2pm.cmd
call noea rexx_exe.vk\exe\*.cmd


rexxc.exe rexx_exe.vk\test\test_src.cmd rexx_exe.vk\test\test_tok.cmd
rexx_exe.vk\exe\rexx2vio.exe rexx_exe.vk\test\test_src.cmd
rexx_exe.vk\exe\rexx2vio.exe rexx_exe.vk\test\test_tok.cmd

call ..\genvk REXX_EXE

cd rexx_exe.vk
call genpgp
cd ..
