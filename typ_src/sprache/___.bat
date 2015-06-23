@echo off
if [%1]==[EIAU] sprache\___spec.bat %1
if [%1]==[EIN]  sprache\___spec.bat %1
if [%1]==[HILF] sprache\___spec.bat %1
if [%1]==[OS]   sprache\___spec.bat %1
sprache\___gen.bat %1
