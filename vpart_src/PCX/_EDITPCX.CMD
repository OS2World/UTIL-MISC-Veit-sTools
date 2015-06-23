@echo off
if [%1]==[] exit
alchos2 -O %1 tmp.bmp
iconedit tmp.bmp
alchos2 -p -o tmp.bmp %1
del tmp.bmp