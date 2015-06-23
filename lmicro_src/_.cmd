@echo off
call stampdef lmicro.def
call stampdef cpumextr.def
call dual lmicro lmicro.vk\
call dual cpumextr lmicro.vk\
call ..\genvk LMicro
cd LMicro.vk
call genpgp
cd ..
