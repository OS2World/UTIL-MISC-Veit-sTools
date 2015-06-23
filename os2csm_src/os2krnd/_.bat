@echo off
cls
c:\bp\bin\tasm /t /oi /m os2krnd.tas %tmp%\os2krnd.obj
c:\bp\bin\tlink /t %tmp%\os2krnd.obj,..\os2csm.vk\bin\os2krnd.ac,nul.map
del %tmp%\os2krnd.obj
