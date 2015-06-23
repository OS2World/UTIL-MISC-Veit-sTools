(*$I TYP_COMP.PAS*)

unit typ_dat;

interface

uses
  typ_type;

procedure dat_signaturen(var dat_puffer:puffertyp);

var
  dat_puffer_zeiger00   :puffer_zeiger_typ;
  datx_aufgerufen       :boolean;

const
  ea_data_sf_clustersize:word_norm=1;


implementation

uses
  typ_ausg,
  typ_dat1,
  typ_dat2,
  typ_datx,
  (*$IfDef ERWEITERUNGSDATEI*)
  typ_erw,
  (*$EndIf*)
  buschsuc,
  typ_exe1;

type
  prozedur_dat_typ=procedure;

procedure dat_nichts;far;assembler;
  {&Frame-}{&Uses None}
  asm
  end;

const
  dat_verteiler:array[byte] of prozedur_dat_typ=
   (dat_00,
    dat_01,
    dat_02,
    dat_03,
    dat_04,
    dat_05,
    dat_06,
    dat_07,
    dat_08,
    dat_09,
    dat_0a,
    dat_0b,
    dat_0c,
    dat_0d,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_13,
    dat_nichts,
    dat_15,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_1a,
    dat_1b,
    dat_nichts,
    dat_1d,
    dat_nichts,
    dat_1f,
    dat_20,
    dat_21,
    dat_22,
    dat_23,
    dat_nichts,
    dat_25,
    dat_nichts,
    dat_nichts,
    dat_28,
    dat_29,
    dat_2a,
    dat_nichts,
    dat_nichts,
    dat_2d,
    dat_2e,
    dat_2f,
    dat_30,
    dat_31,
    dat_32,
    dat_33,
    dat_34,
    dat_nichts,
    dat_36,
    dat_37,
    dat_38,
    dat_39,
    dat_3a,
    dat_3b,
    dat_3c,
    dat_nichts,
    dat_3e,
    dat_3f,
    dat_40,
    dat_41,
    dat_42,
    dat_43,
    dat_44,
    dat_45,
    dat_46,
    dat_47,
    dat_48,
    dat_49,
    dat_4a,
    dat_4b,
    dat_4c,
    dat_4d,
    dat_4e,
    dat_4f,
    dat_50,
    dat_51,
    dat_52,
    dat_53,
    dat_54,
    dat_55,
    dat_56,
    dat_57,
    dat_58,
    dat_59,
    dat_5a,
    dat_5b,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_60,
    dat_61,
    dat_62,
    dat_63,
    dat_64,
    dat_65,
    dat_66,
    dat_67,
    dat_68,
    dat_69,
    dat_6a,
    dat_6b,
    dat_6c,
    dat_6d,
    dat_6e,
    dat_nichts,
    dat_70,
    dat_nichts,
    dat_72,
    dat_73,
    dat_nichts,
    dat_75,
    dat_76,
    dat_77,
    dat_78,
    dat_79,
    dat_7a,
    dat_7b,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_7f,
    dat_80,
    dat_81,
    dat_nichts,
    dat_83,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_88,
    dat_89,
    dat_8a,
    dat_8b,
    dat_nichts,
    dat_8d,
    dat_8e,
    dat_8f,
    dat_90,
    dat_91,
    dat_nichts,
    dat_93,
    dat_nichts,
    dat_95,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_9d,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_a4,
    dat_a5,
    dat_nichts,
    dat_nichts,
    dat_a8,
    dat_nichts,
    dat_aa,
    dat_nichts,
    dat_ac,
    dat_ad,
    dat_nichts,
    dat_nichts,
    dat_b0,
    dat_b1,
    dat_b2,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_b8,
    dat_nichts,
    dat_ba,
    dat_nichts,
    dat_bc,
    dat_bd,
    dat_nichts,
    dat_nichts,
    dat_c0,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_c4,
    dat_c5,
    dat_c6,
    dat_c7,
    dat_c8,
    dat_c9,
    dat_ca,
    dat_nichts,
    dat_cc,
    dat_cd,
    dat_ce,
    dat_nichts,
    dat_d0,
    dat_d1,
    dat_nichts,
    dat_nichts,
    dat_d4,
    dat_d5,
    dat_nichts,
    dat_d7,
    dat_d8,
    dat_nichts,
    dat_da,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_de,
    dat_df,
    dat_e0,
    dat_e1,
    dat_nichts,
    dat_e3,
    dat_nichts,
    dat_e5,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_e9,
    dat_nichts,
    dat_eb,
    dat_nichts,
    dat_ed,
    dat_ee,
    dat_ef,
    dat_f0,
    dat_nichts,
    dat_nichts,
    dat_nichts,
    dat_f4,
    dat_nichts,
    dat_f6,
    dat_f7,
    dat_nichts,
    dat_f9,
    dat_nichts,
    dat_fb,
    dat_fc,
    dat_fd,
    dat_fe,
    dat_ff);


(* ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл *)


procedure dat_signaturen(var dat_puffer:puffertyp);
  var
    org_dat_puffer      :puffer_zeiger_typ;
  begin
    org_dat_puffer:=dat_puffer_zeiger00;
    dat_puffer_zeiger00:=addr(dat_puffer);
    datx_aufgerufen:=false;

    (*$IfDef ERWEITERUNGSDATEI*)
    if not hersteller_gefunden then
      suche_erweiterungen(dat_puffer);
    (*$EndIf*)

    (*$IfDef VirtualPascal*)
    busch_suche(Ptr(Ofs(dat_busch))^,dat_puffer.d[0]);
    (*$Else*)
    busch_suche(Ptr(Seg(dat_busch),Ofs(dat_busch))^,dat_puffer.d[0]);
    (*$EndIf*)

    dat_verteiler[dat_puffer_zeiger00^.d[0]];

    if (not hersteller_gefunden) and (not datx_aufgerufen) then
      dat_sigx(dat_puffer);

    dat_puffer_zeiger00:=org_dat_puffer;

  end;

end.

