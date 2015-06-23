@echo off

cd ..\quelle
call quelle memdisk

cd ..\prog
call prog memdisk

cd ..\memdisk

arj a -_ c:\fertig.q\memd_nls.arj !memd_nls.lst
