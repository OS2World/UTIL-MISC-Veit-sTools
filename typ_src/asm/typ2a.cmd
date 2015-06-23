/* REXX */

IF RxFuncQuery('SysLoadFuncs')=1 THEN DO
   CALL RxFuncAdd 'SysLoadFuncs', 'REXXUTIL', 'SysLoadFuncs'
   CALL SysLoadFuncs
   Say 'REXXUTIL geladen'
END

rc=RxFuncQuery('EXE_HAUPTPROGRAMMAUFRUF')
Say "schon geladen (0=ja 1=nein):" rc

call RxFuncAdd 'EXE_HAUPTPROGRAMMAUFRUF', 'TYP2DLL', 'EXE_HAUPTPROGRAMMAUFRUF'
Say "1" rc
Say "geladen"

Say "VPTest returns '"EXE_HAUPTPROGRAMMAUFRUF()"'"
Say

