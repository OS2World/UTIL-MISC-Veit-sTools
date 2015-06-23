/*REXX*/
Call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
Call SysLoadFuncs

RC = SysSetIcon('M2E.EXE', 'M2E.ICO')

/* ParamStr(0) */
PARSE SOURCE OS CMD P0

/* Sprache */
IF SysIni('USER', 'Shield', 'Schrif~tartgrî·e...') = 'ERROR:' THEN
  SPRACHE = 'E'
ELSE
  SPRACHE = 'D'
  
VERZ=Directory()
IF Left(VERZ,1,1)<>'\' then
  VERZ = VERZ||'\'
  
IF SPRACHE='D' THEN
  Dokumentation='Dokumentation'
ELSE
  Dokumentation='Documentation'
  
IF SPRACHE='D' THEN  
  Symboluebersicht='SymbolÅbersicht'
ELSE
  Symboluebersicht='Icon gallery' 
  
IF SPRACHE='D' THEN 
  ERW='DEU'
ELSE
  ERW='ENG'
  
/* ArbeitsoberflÑche */
Call SysCreateObject 'WPFolder', 'VPart', '<WP_DESKTOP>', 'OBJECTID=<VPART_ORDNER>', 'r' 
Call SysCreateObject 'WPProgram', 'Installation', '<VPART_ORDNER>', 'OBJECTID=<VPART_INST>;EXENAME='||VERZ||'_INST.CMD', 'r' 
Call SysCreateObject 'WPShadow', Dokumentation, '<VPART_ORDNER>', 'SHADOWID='||VERZ||'VPART.'||ERW||';OBJECTID=<VPART_DOKUMENTATION>', 'r'
/*Call SysCreateObject 'WPShadow', Symboluebersicht, '<VPART_ORDNER>', 'SHADOWID='||VERZ||'ICON_GAL.PNG;OBJECTID=<VPART_ICON_GAL>', 'r' */
Call SysCreateObject 'WPDataFile', 'ICON_GAL.PNG', '<VPART_ORDNER>', 'FILENAME='||VERZ||'ICON_GAL.PNG;OBJECTID=<VPART_ICON_GAL>', 'r'

EXIT 0

