@ECHO OFF
DEL *.BAK
DEL *.PSM
DEL SPRACHE\*.BAK
DEL BUSCH\*.BAK
DEL BUSCH\*___16.OBJ
DEL BUSCH\*___32.OBJ
DEL BUSCH\*.DAT

IF NOT [%1]==[] GOTO ENDE

DEL INC_D32\$$$*.00?
DEL INC_DOS\$$$*.00?
DEL INC_DOSD\$$$*.00?
DEL INC_GEN\$$$*.00?
DEL INC_LLF\$$$*.00?
DEL INC_LNX\$$$*.00?
DEL INC_OLF\$$$*.00?
DEL INC_OS2\$$$*.00?
DEL INC_W32\$$$*.00?
DEL INC_WLF\$$$*.00?
