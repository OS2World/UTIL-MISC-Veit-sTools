/* REXX */

Call rxfuncadd sysloadfuncs, rexxutil, sysloadfuncs
Call sysloadfuncs

/*******************************************************************/

'@call NOEA.cmd VPART.VK\*'

Call SETZEICON '*.ARJ',       'ARJ.ICO',       'Arj'

Call SETZEICON '*.BAT',       'VPARTEXE.ICO',  'Executable'
Call SETZEICON '*.CMD',       'VPARTEXE.ICO',  'Executable'
Call SETZEICON '*.COM',       'VPARTEXE.ICO',  'Executable'
Call SETZEICON '*.EXE',       'VPARTEXE.ICO',  'Executable'

Call SETZEICON '*.DAT',       'BINAER.ICO',    'Binary Data'
Call SETZEICON 'ICONEDIT.PAL','BINAER.ICO',    'Binary Data'
Call SETZEICON 'BOOT_ROM.VPA','BINAER.ICO',    'Binary Data'

Call SETZEICON '*.DEU',       'TEXT.ICO',      'Plain Text'
Call SETZEICON '*.ENG',       'TEXT.ICO',      'Plain Text'
Call SETZEICON '*.ION',       'TEXT.ICO',      'Plain Text'
Call SETZEICON '*.TXT',       'TEXT.ICO',      'Plain Text'
Call SETZEICON 'ALCHEMY.PAL', 'TEXT.ICO',      'Plain Text'
Call SETZEICON 'PMVIEW.PAL',  'TEXT.ICO',      'Plain Text'

Call SETZEICON 'ICON_GAL.PNG','ICON_GAL.ICO',  'Symbol'
Call SETZEICON 'VPART.PNG',   'VPARTPNG.ICO',  'Symbol'

EXIT 0

/*******************************************************************/
SETZEICON:

PARSE ARG MASKE, SYMBOL, DATEITYP
Call SysFileTree 'VPART.VK\'||MASKE, 'datei', 'FO'

DO i=1 TO datei.0
  Say datei.i SYMBOL DATEITYP '... '
  /*Call SysSetIcon datei.i, SYMBOL*/

  /* ASCII */
  t1 = "FDFF"x || d2c(length(DATEITYP)) || '00'x || DATEITYP
  /* mehrtypig/mehrwertig, 1 Element */
  t2 = "DFFF0000"x || "0100"x || t1

  Call SysPutEA datei.i, '.TYPE', t2
END
RETURN 0

/*******************************************************************/
