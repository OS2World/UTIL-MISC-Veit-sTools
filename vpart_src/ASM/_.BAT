@ECHO OFF

FOR %%D IN (..\BIN\VP_S?_?.BIN ..\BIN\VP_F_?.BIN) DO IF EXIST %%D DEL %%D

CALL A86 ^SPUR0 ^deutsch  VPART1.A86 TO ..\BIN\VP_S0_D.BIN,NUL
IF NOT EXIST ..\BIN\VP_S0_D.BIN GOTO FEHLER
CALL A86 ^SPUR0 ^englisch VPART1.A86 TO ..\BIN\VP_S0_E.BIN,NUL
IF NOT EXIST ..\BIN\VP_S0_E.BIN GOTO FEHLER

CALL A86 ^SPUR0 ^deutsch  ^award_swap VPART1.A86 TO ..\BIN\VP_SA_D.BIN,NUL
IF NOT EXIST ..\BIN\VP_SA_D.BIN GOTO FEHLER
CALL A86 ^SPUR0 ^englisch ^award_swap VPART1.A86 TO ..\BIN\VP_SA_E.BIN,NUL
IF NOT EXIST ..\BIN\VP_SA_E.BIN GOTO FEHLER

CALL A86 ^FAT   ^deutsch  VPART1.A86 TO ..\BIN\VP_F_D.BIN,NUL
IF NOT EXIST ..\BIN\VP_F_D.BIN GOTO FEHLER
CALL A86 ^FAT   ^englisch VPART1.A86 TO ..\BIN\VP_F_E.BIN,NUL
IF NOT EXIST ..\BIN\VP_F_E.BIN GOTO FEHLER

CALL A86        ^deutsch  VPART2.A86 TO ..\BIN\VPART2D.COM,NUL
IF NOT EXIST ..\BIN\VPART2D.COM GOTO FEHLER
CALL A86        ^englisch VPART2.A86 TO ..\BIN\VPART2E.COM,NUL
IF NOT EXIST ..\BIN\VPART2E.COM GOTO FEHLER

ECHO 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
REM 20-2800 24-3000 28-3800 30-3C00 32-4000 33-4200 34-4400 35-4600
REM 36-4800 37-4A00 39-4E00
SCHNITT ..\BIN\VPART2D.COM 0 $4E00 ..\BIN\VPART2D.BIN
SCHNITT ..\BIN\VPART2E.COM 0 $4E00 ..\BIN\VPART2E.BIN
DEL ..\BIN\VPART2D.COM
DEL ..\BIN\VPART2E.COM

BINOBJ ..\BIN\VP_S0_D.BIN   ..\OBJ16\VP_S0_D.OBJ  VPART1_SPUR0_BIN_D
BINOBJ ..\BIN\VP_S0_E.BIN   ..\OBJ16\VP_S0_E.OBJ  VPART1_SPUR0_BIN_E
BINOBJ ..\BIN\VP_SA_D.BIN   ..\OBJ16\VP_SA_D.OBJ  VPART1_SPUR0_AWARDSWAP_BIN_D
BINOBJ ..\BIN\VP_SA_E.BIN   ..\OBJ16\VP_SA_E.OBJ  VPART1_SPUR0_AWARDSWAP_BIN_E
BINOBJ ..\BIN\VP_F_D.BIN    ..\OBJ16\VP_F_D.OBJ   VPART1_FAT_BIN_D
BINOBJ ..\BIN\VP_F_E.BIN    ..\OBJ16\VP_F_E.OBJ   VPART1_FAT_BIN_E
BINOBJ ..\BIN\VPART2D.BIN   ..\OBJ16\VPART2D.OBJ  VPART2_BIN_D
BINOBJ ..\BIN\VPART2E.BIN   ..\OBJ16\VPART2E.OBJ  VPART2_BIN_E
BINOBJ ..\BIN\FATBOOT.DEU   ..\OBJ16\FATBOOTD.OBJ FATBOOT_BIN_D
BINOBJ ..\BIN\FATBOOT.ENG   ..\OBJ16\FATBOOTE.OBJ FATBOOT_BIN_E
BINOBJ ..\BIN\512.BIN       ..\OBJ16\ICO512.OBJ   ICO512_BIN

BINOBJ32 ..\BIN\VP_S0_D.BIN ..\OBJ32\VP_S0_D.OBJ  VPART1_SPUR0_BIN_D
BINOBJ32 ..\BIN\VP_S0_E.BIN ..\OBJ32\VP_S0_E.OBJ  VPART1_SPUR0_BIN_E
BINOBJ32 ..\BIN\VP_SA_D.BIN ..\OBJ32\VP_SA_D.OBJ  VPART1_SPUR0_AWARDSWAP_BIN_D
BINOBJ32 ..\BIN\VP_SA_E.BIN ..\OBJ32\VP_SA_E.OBJ  VPART1_SPUR0_AWARDSWAP_BIN_E
BINOBJ32 ..\BIN\VP_F_D.BIN  ..\OBJ32\VP_F_D.OBJ   VPART1_FAT_BIN_D
BINOBJ32 ..\BIN\VP_F_E.BIN  ..\OBJ32\VP_F_E.OBJ   VPART1_FAT_BIN_E
BINOBJ32 ..\BIN\VPART2D.BIN ..\OBJ32\VPART2D.OBJ  VPART2_BIN_D
BINOBJ32 ..\BIN\VPART2E.BIN ..\OBJ32\VPART2E.OBJ  VPART2_BIN_E
BINOBJ32 ..\BIN\FATBOOT.DEU ..\OBJ32\FATBOOTD.OBJ FATBOOT_BIN_D
BINOBJ32 ..\BIN\FATBOOT.ENG ..\OBJ32\FATBOOTE.OBJ FATBOOT_BIN_E
BINOBJ32 ..\BIN\512.BIN     ..\OBJ32\ICO512.OBJ   ICO512_BIN

GOTO ENDE
:FEHLER
PAUSE
SET FEHLER=1
:ENDE
