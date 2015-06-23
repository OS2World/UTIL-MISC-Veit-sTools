(*$I TYP_COMP.PAS*)

(* 19.11.1996*)
unit typ_spra;

interface

uses
  typ_type;

procedure einrichten_typ_spra(const anfang:boolean);

(*$IfDef TYP_EXE*)
(*$I $$$_AUSG.002 *)
(*$I $$$_BIOS.002 *)
(*$I $$$_CD.002   *)
(*$I $$$_DAT.002  *)
(*$I $$$_DATX.002 *)
(*$I $$$_DIEN.002 *)
(*$I $$$_EAS.002  *)
(*$I $$$_EIAU.002 *)
(*$I $$$_ENDE.002 *)
(*$I $$$_EXE.002  *)
(*$I $$$_FORM.002 *)
(*$I $$$_KOPF.002 *)
(*$I $$$_NETW.002 *)
(*$IfNDef HILFE_EINSPAREN*)
(*$I $$$_HILF.002 *)
(*$EndIf*)
(*$I $$$_OS.002   *)
(*$I $$$_PARA.002 *)
(*$I $$$_POLY.002 *)
(*$I $$$_SEKT.002 *)
(*$I $$$_SPRU.002 *)
(*$I $$$_TYP.002  *)
(*$I $$$_VAR.002  *)
(*$I $$$_VAR1.002 *)
(*$I $$$_VAR2.002 *)
(*$I $$$_XEXE.002 *)
(*$Else*) (* TYPEIN *)
(*$I $$$_EIN.002  *)
(*$I $$$_EINF.002 *)
(*$I $$$_VAR1.002 *)
(*$I $$$_VAR2.002 *)
(*$EndIf*)

implementation

uses
  spr2_aus;

(*$IfDef TYP_EXE*)
(*$I $$$_AUSG.001 *)
(*$I $$$_BIOS.001 *)
(*$I $$$_CD.001   *)
(*$I $$$_DAT.001  *)
(*$I $$$_DATX.001 *)
(*$I $$$_DIEN.001 *)
(*$I $$$_EAS.001  *)
(*$I $$$_EIAU.001 *)
(*$I $$$_ENDE.001 *)
(*$I $$$_EXE.001  *)
(*$I $$$_FORM.001 *)
(*$IfNDef HILFE_EINSPAREN*)
(*$I $$$_HILF.001 *)
(*$EndIf*)
(*$I $$$_KOPF.001 *)
(*$I $$$_NETW.001 *)
(*$I $$$_OS.001   *)
(*$I $$$_PARA.001 *)
(*$I $$$_POLY.001 *)
(*$I $$$_SEKT.001 *)
(*$I $$$_SPRU.001 *)
(*$I $$$_TYP.001  *)
(*$I $$$_VAR.001  *)
(*$I $$$_VAR1.001 *)
(*$I $$$_VAR2.001 *)
(*$I $$$_XEXE.001 *)
(*$Else*) (* TYPEIN *)
(*$I $$$_EIN.001  *)
(*$I $$$_EINF.001 *)
(*$I $$$_VAR1.001 *)
(*$I $$$_VAR2.001 *)
(*$EndIf*)

procedure einrichten_typ_spra(const anfang:boolean);
  begin
    if anfang then
      begin
        (*$IfDef TYP_EXE*)
        setze_sprachzeiger(@sprach_modul_typ_ausg,@sprach_start_typ_ausg);
        setze_sprachzeiger(@sprach_modul_typ_bios,@sprach_start_typ_bios);
        setze_sprachzeiger(@sprach_modul_typ_cd  ,@sprach_start_typ_cd  );
        setze_sprachzeiger(@sprach_modul_typ_dat ,@sprach_start_typ_dat );
        setze_sprachzeiger(@sprach_modul_typ_datx,@sprach_start_typ_datx);
        setze_sprachzeiger(@sprach_modul_typ_dien,@sprach_start_typ_dien);
        setze_sprachzeiger(@sprach_modul_typ_eas ,@sprach_start_typ_eas );
        setze_sprachzeiger(@sprach_modul_typ_eiau,@sprach_start_typ_eiau);
        setze_sprachzeiger(@sprach_modul_typ_ende,@sprach_start_typ_ende);
        setze_sprachzeiger(@sprach_modul_typ_exe ,@sprach_start_typ_exe );
        setze_sprachzeiger(@sprach_modul_typ_form,@sprach_start_typ_form);
        (*$IfNDef HILFE_EINSPAREN*)
        setze_sprachzeiger(@sprach_modul_typ_hilf,@sprach_start_typ_hilf);
        (*$EndIf*)
        setze_sprachzeiger(@sprach_modul_typ_kopf,@sprach_start_typ_kopf);
        setze_sprachzeiger(@sprach_modul_typ_netw,@sprach_start_typ_netw);
        setze_sprachzeiger(@sprach_modul_typ_os  ,@sprach_start_typ_os  );
        setze_sprachzeiger(@sprach_modul_typ_para,@sprach_start_typ_para);
        setze_sprachzeiger(@sprach_modul_typ_poly,@sprach_start_typ_poly);
        setze_sprachzeiger(@sprach_modul_typ_sekt,@sprach_start_typ_sekt);
        setze_sprachzeiger(@sprach_modul_typ_spru,@sprach_start_typ_spru);
        setze_sprachzeiger(@sprach_modul_typ     ,@sprach_start_typ     );
        setze_sprachzeiger(@sprach_modul_typ_var ,@sprach_start_typ_var );
        setze_sprachzeiger(@sprach_modul_typ_var1,@sprach_start_typ_var1);
        setze_sprachzeiger(@sprach_modul_typ_var2,@sprach_start_typ_var2);
        setze_sprachzeiger(@sprach_modul_typ_xexe,@sprach_start_typ_xexe);
        (*$Else*)
        setze_sprachzeiger(@sprach_modul_typ_ein ,@sprach_start_typ_ein );
        setze_sprachzeiger(@sprach_modul_typ_einf,@sprach_start_typ_einf);
        setze_sprachzeiger(@sprach_modul_typ_var1,@sprach_start_typ_var1);
        setze_sprachzeiger(@sprach_modul_typ_var2,@sprach_start_typ_var2);
        (*$EndIf*)
      end;
  end;

begin
  einrichten_typ_spra(true);
end.

