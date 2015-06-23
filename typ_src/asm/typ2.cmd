/* REXX */
IF RxFuncQuery('REXX_TYP2')=1 THEN 
  DO
    /* <<<suche in path/dpath/%0/.. */
    IF RxFuncAdd('REXX_TYP2', 'TYP2DLL.DLL', 'REXX_TYP2')=1 THEN 
      DO
        /*                     ^^^^^^^^^^^       */
        Say "Can not find TYP2DLL, please patch me..."
        Exit 1
      END
  END

PARSE ARG PARA
RC=REXX_TYP2(PARA)
IF RC<>0 THEN DO
  Say "Error " rc " executing REXX_TYP2 from TYP2DLL.DLL"
  Exit
END

/*??call RxFuncDrop 'REXX_TYP2'*/
