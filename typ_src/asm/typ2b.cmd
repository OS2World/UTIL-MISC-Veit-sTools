/* REXX */

IF RxFuncQuery('SysLoadFuncs')=1 THEN DO
   CALL RxFuncAdd 'SysLoadFuncs', 'REXXUTIL', 'SysLoadFuncs'
   CALL SysLoadFuncs
   Say 'REXXUTIL geladen'
END

rc=RxFuncQuery('REXX_TYP2')
Say "R: schon geladen (0=ja 1=nein):" rc
rc=RxFuncQuery('EXE_TYP2')
Say "E: schon geladen (0=ja 1=nein):" rc

rc=RxFuncDrop('REXX_TYP2')
Say "R:entladen (0=ja 1=nein):" rc
rc=RxFuncDrop('EXE_TYP2')
Say "E:entladen (0=ja 1=nein):" rc

rc=RxFuncAdd('REXX_TYP2', 'TYP2DLL', 'REXX_TYP2')
Say "R:geladen (0=ja 1=nein):" rc
rc=RxFuncAdd('EXE_TYP2' , 'TYP2DLL', 'EXE_TYP2')
Say "E:geladen (0=ja 1=nein):" rc

rc=RxFuncQuery('EXE_TYP2')
Say rc
rc=RxFuncQuery('REXX_TYP2')
Say rc

PARSE ARG PARA
rc=REXX_TYP2(PARA)
Say "R: '"rc"'"
pull taste

rc=RxFuncDrop('REXX_TYP2')
Say "R:entladen (0=ja 1=nein):" rc
rc=RxFuncDrop('EXE_TYP2')
Say "E:entladen (0=ja 1=nein):" rc
