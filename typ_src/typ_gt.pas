(*$I TYP_COMP.PAS*)
unit typ_gt;

(* Import von GTDATA.DLL (1999.11.27) *)
(* 1999.12.13 Veit Kannegieser *)
interface

uses
  typ_type;

type
  gt_bereichs_typ=(gt_c2e,
                   gt_exe_0j,
                   gt_exe_1j,
                   gt_exe_1lj,
                   gt_exe_2j,
                   gt_ext_exe,
                   gt_ext_pe,
                   gt_ne_0j,
                   gt_pe_0j);



procedure lade_gtdata;
procedure suche_gtdata(const bereich:gt_bereichs_typ;const p);
procedure suche_gtdata_c2e(const bereich:gt_bereichs_typ);

procedure einrichten_typ_gt(const anfang:boolean);

implementation

uses
  typ_var,
  typ_varx,
  typ_ausg,
  Strings,
  Dos,
  dll;

type
  (*$Cdecl+*)
  gt_ermittle_anzahl_typ=function:longint;
  gt_ermittle_zeiger_typ=function(const nummer:longint):pointer;
  (*$Cdecl-*)


const
  gt_ausschrift_attr_tabelle:array[0..9] of aus_attribute=
    (normal,
     packer_exe,        (* Packer       *)
     packer_exe,        (* crypter      *)
     compiler,
     compiler,          (* Linker       *)
     signatur,          (* Konverter    *)
     packer_exe,        (* Protector    *)
     packer_exe,        (* sticker      *)
     dos_win_extender,  (* Extender     *)
     packer_exe);       (* Kennwort     *)

  gtdata_modul          :hand_dll_module=0;

  prozedur_tabelle      :array[gt_bereichs_typ] of
    record
      anzahl            :longint;
      erm_zeiger        :gt_ermittle_zeiger_typ;
    end=
  ((anzahl:0;erm_zeiger:nil),
   (anzahl:0;erm_zeiger:nil),
   (anzahl:0;erm_zeiger:nil),
   (anzahl:0;erm_zeiger:nil),
   (anzahl:0;erm_zeiger:nil),
   (anzahl:0;erm_zeiger:nil),
   (anzahl:0;erm_zeiger:nil),
   (anzahl:0;erm_zeiger:nil),
   (anzahl:0;erm_zeiger:nil));

type
  bf0                   =array[0..512] of byte;
  gt_signatur_einheit   =
    packed record
      sig_laenge        :(*byte*)longint; (* 2001.01.17 *)
      sig               :^bf0;
      u1                :longint; (* Dateimaske? *)
      attr              :longint; (* mit gt_ausschrift_attr_tabelle umsetzen *)
      name_             :PChar;
    end;
  gt_signatur_einheit_z =^gt_signatur_einheit;

  gt_signatur_c2e       =
    packed record
      name_             :PChar;
      exekopf           :array[0..23] of byte;
    end;
  gt_signatur_c2e_z     =^gt_signatur_c2e;

procedure lade_gtdata;

  procedure ermittle(const prozedurpaar:string;const bereich:gt_bereichs_typ);
    var
      anzahl:gt_ermittle_anzahl_typ;
    begin
      if QueryProcAddr(
        gtdata_modul,
        0,
        prozedurpaar+'_Index',
        @prozedur_tabelle[bereich].erm_zeiger)<>0 then exit;

      if QueryProcAddr(
        gtdata_modul,
        0,
        prozedurpaar+'_Count',
        @anzahl)<>0 then exit;

      prozedur_tabelle[bereich].anzahl:=anzahl;
    end;

  var
    gtdata_dll_name,
    fehler              :string;
    e                   :longint;
    gt_get_version      :function:PChar;

  begin
    gtdata_dll_name:=GetEnv('GTDATA_DLL');
    if gtdata_dll_name='' then
      begin
        (*$IfDef ENDVERSION*)
        gtdata_dll_name:=GetEnv('GTDATA.DLL');
        if gtdata_dll_name='' then
          begin
            gtdata_dll_name:=ParamStr(0);
            while (gtdata_dll_name<>'') and (not (gtdata_dll_name[Length(gtdata_dll_name)] in ['\','/'])) do
              Dec(gtdata_dll_name[0]);
            gtdata_dll_name:=gtdata_dll_name+'GTDATA.DLL';
          end;
        (*$Else*)
        gtdata_dll_name:='C:\EXTRA\UNP\GTDATA.DLL'
        (*$EndIf*)
      end;

    if LoadModule(fehler,gtdata_dll_name,gtdata_modul)<>0 then
      Exit;

    if QueryProcAddr(
        gtdata_modul,
        0,
        'GT_GetVersion',
        @gt_get_version)<>0 then exit;

    if signaturen then
      ausschrift('GTDATA.DLL "'+puffer_zu_zk_e(gt_get_version^,#0,80)+'"',normal);


    ermittle('GT_C2E'    ,gt_c2e    );
    ermittle('GT_EXE_0J' ,gt_exe_0j );
    ermittle('GT_EXE_1J' ,gt_exe_1j );
    ermittle('GT_EXE_1LJ',gt_exe_1lj);
    ermittle('GT_EXE_2J' ,gt_exe_2j );
    ermittle('GT_EXT_EXE',gt_ext_exe);
    ermittle('GT_EXT_PE' ,gt_ext_pe );
    ermittle('GT_NE_0J'  ,gt_ne_0j  );
    ermittle('GT_PE_0J'  ,gt_pe_0j  );

  end;

function attr_umsetzen(const a:longint):aus_attribute;
  begin
    if a>High(gt_ausschrift_attr_tabelle) then
      attr_umsetzen:=signatur
    else
      attr_umsetzen:=gt_ausschrift_attr_tabelle[a];
  end;

procedure suche_gtdata(const bereich:gt_bereichs_typ;const p);
  var
    z,z2                :longint;
    gleich              :boolean;
    pb                  :array[0..512] of byte absolute p;

  begin
    with prozedur_tabelle[bereich] do

        for z:=0 to anzahl-1 do
          with gt_signatur_einheit_z(erm_zeiger(z))^ do
            begin

              gleich:=true;
              for z2:=0 to Pred(sig_laenge) do
                if (pb[z2]<>sig^[z2]) and (sig^[z2]<>0) then
                  begin
                    gleich:=false;
                    Break;
                  end;

              if gleich then
                ausschrift('GTDATA: '+puffer_zu_zk_e(name_^,#0,80),attr_umsetzen(attr));

            end;
  end;

procedure suche_gtdata_c2e(const bereich:gt_bereichs_typ);
  var
    z,z2        :longint;
    gleich      :boolean;
  begin
    with prozedur_tabelle[bereich] do

        for z:=0 to anzahl-1 do
          with gt_signatur_c2e_z(erm_zeiger(z))^,analysepuffer do
            begin

              gleich:=true;
              for z2:=Low(exekopf) to High(exekopf) do
                if (d[8+z2]<>exekopf[z2]) and (exekopf[z2]<>0) then
                  begin
                    gleich:=false;
                    Break;
                  end;

              if gleich then
                ausschrift('GTDATA: '+puffer_zu_zk_e(name_^,#0,80),packer_exe);

            end;
  end;

procedure entladen_gtdata;
  begin
    if gtdata_modul<>0 then
      FreeModule(gtdata_modul);
  end;

procedure einrichten_typ_gt(const anfang:boolean);
  begin
    (*$IfDef SPEICHER_FREIGEBEN*)
    if not anfang then
      entladen_gtdata;
    (*$EndIf SPEICHER_FREIGEBEN*)
  end;


(*$IfDef SPEICHER_FREIGEBEN*)
initialization
  einrichten_typ_gt(true);
finalization
  einrichten_typ_gt(false);
(*$EndIf SPEICHER_FREIGEBEN*)

end.

