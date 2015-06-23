@echo off

cd ..\quelle
call quelle hdd_vhd

cd ..\prog
call prog hdd_vhd

cd ..\hdd_vhd

arj a -_ c:\fertig.q\hdd_nls.arj !hdd_nls.lst
