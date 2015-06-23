unit vpe_obje;
(* Veit Kannegieser 27.06.1996 *)

interface

(*&ORGNAME+*)
procedure vpart1_spur0_bin_e            ;
procedure vpart1_spur0_awardswap_bin_e  ;
procedure vpart1_fat_bin_e              ;
procedure vpart2_bin_e                  ;
procedure fatboot_bin_e                 ;
(*&ORGNAME-*)

implementation

(*$IFDEF VIRTUALPASCAL*)
(*&ORGNAME+*)
procedure vpart1_spur0_bin_e            ;external;(*$L ..\OBJ32\VP_S0_E.OBJ *)
procedure vpart1_spur0_awardswap_bin_e  ;external;(*$L ..\OBJ32\VP_SA_E.OBJ *)
procedure vpart1_fat_bin_e              ;external;(*$L ..\OBJ32\VP_F_E.OBJ  *)
procedure vpart2_bin_e                  ;external;(*$L ..\OBJ32\VPART2E.OBJ *)
procedure fatboot_bin_e                 ;external;(*$L ..\OBJ32\FATBOOTE.OBJ*)
(*$ORGNAME-*)
(*$ELSE*)
procedure vpart1_spur0_bin_e            ;external;(*$L ..\OBJ16\VP_S0_E.OBJ *)
procedure vpart1_spur0_awardswap_bin_e  ;external;(*$L ..\OBJ16\VP_SA_E.OBJ *)
procedure vpart1_fat_bin_e              ;external;(*$L ..\OBJ16\VP_F_E.OBJ  *)
procedure vpart2_bin_e                  ;external;(*$L ..\OBJ16\VPART2E.OBJ *)
procedure fatboot_bin_e                 ;external;(*$L ..\OBJ16\FATBOOTE.OBJ*)
(*$ENDIF*)

end.

