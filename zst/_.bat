@ECHO OFF
CALL ..\TPU ztab
CALL ..\TPU ntab
CALL ..\TPU zst
CALL ..\TPU zst_obj

call PASBP  t1 .\
t1.exe < t1.txt