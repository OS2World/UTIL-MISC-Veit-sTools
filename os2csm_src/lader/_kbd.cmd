@echo off
call PASVPo txt2inc .\
rem generate keyboard remap include files from *.txt files
txt2inc.exe de "german: gr 129"
txt2inc.exe en "english: us 103"
txt2inc.exe es "spanish: sp 172"
txt2inc.exe fr "french: fr 189"
txt2inc.exe nl "dutch: nl 143"
txt2inc.exe ru "russian: ru 441 or 443"
txt2inc.exe it "italy it 142"
