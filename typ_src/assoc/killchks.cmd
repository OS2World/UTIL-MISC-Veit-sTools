/*REXX*/
call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysloadFuncs'
call SysLoadFuncs
Parse Arg filename
call SysPutEA filename, '.CHECKSUM', ''
