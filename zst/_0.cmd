@echo off
call PASVPO  er_ntab %tmp%\
%tmp%\er_ntab.exe < er_ntab.txt
del %tmp%\er_ntab.exe
binobj32 cp_ntab ntab32.obj ntab_obj
C:\BP\BIN\binobj cp_ntab. ntab16.obj ntab_obj
del cp_ntab

call PASVPO er_ztab %tmp%\ @uniapi.cfg
%tmp%\er_ztab.exe
del %tmp%\er_ztab.exe
binobj32 ztab ztab32.obj ztab_obj
C:\BP\BIN\binobj ztab. ztab16.obj ztab_obj
del ztab
