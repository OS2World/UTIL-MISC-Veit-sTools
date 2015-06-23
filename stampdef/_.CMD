@echo off
call dual StampDef .\
copy stampdef.de0 stampdef.def
stampdef.exe stampdef.def
call dual StampDef .\
copy stampdef.exe %vpbase%\bin.os2
