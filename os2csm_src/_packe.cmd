@echo off

cd ..\quelle
call quelle os2csm

cd ..\prog
call prog os2csm

cd ..\os2csm

arj a -_ c:\fertig.q\os2c_nls.arj !os2c_nls.lst