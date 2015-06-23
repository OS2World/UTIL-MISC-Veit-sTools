unit vpe_objd;
(* Veit Kannegieser 27.06.1996 *)

interface

(*&ORGNAME+*)
procedure vpart1_spur0_bin_d            ;
procedure vpart1_spur0_awardswap_bin_d  ;
procedure vpart1_fat_bin_d              ;
procedure vpart2_bin_d                  ;
procedure fatboot_bin_d                 ;
(*&ORGNAME-*)

implementation

(*$IFDEF VIRTUALPASCAL*)
(*&ORGNAME+*)
procedure vpart1_spur0_bin_d            ;external;(*$L ..\OBJ32\VP_S0_D.OBJ *)
procedure vpart1_spur0_awardswap_bin_d  ;external;(*$L ..\OBJ32\VP_SA_D.OBJ *)
procedure vpart1_fat_bin_d              ;external;(*$L ..\OBJ32\VP_F_D.OBJ  *)
procedure vpart2_bin_d                  ;external;(*$L ..\OBJ32\VPART2D.OBJ *)
procedure fatboot_bin_d                 ;external;(*$L ..\OBJ32\FATBOOTD.OBJ*)
(*$ORGNAME-*)
(*$ELSE*)
procedure vpart1_spur0_bin_d            ;external;(*$L ..\OBJ16\VP_S0_D.OBJ *)
procedure vpart1_spur0_awardswap_bin_d  ;external;(*$L ..\OBJ16\VP_SA_D.OBJ *)
procedure vpart1_fat_bin_d              ;external;(*$L ..\OBJ16\VP_F_D.OBJ  *)
procedure vpart2_bin_d                  ;external;(*$L ..\OBJ16\VPART2D.OBJ *)
procedure fatboot_bin_d                 ;external;(*$L ..\OBJ16\FATBOOTD.OBJ*)
(*$ENDIF*)

end.

