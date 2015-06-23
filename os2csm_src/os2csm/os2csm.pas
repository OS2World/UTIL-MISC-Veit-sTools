{$M 327680}
program os2csm;

uses
  os2csm_s,
  conf512,
  Dos,
  menucomp,
  VpSysLow;


var
  verzeichnis_emfehlung,
  verzeichnis           :string;

  auftrag_z             :string;
  auftrag               :(installation,aussetzen,fortsetzen,os2csm_memdisk_erzeugen,unbekannt)=unbekannt;


begin
  {$IfDef Debug}
  Chdir('M:\M');
  {$EndIf}
  verzeichnis_emfehlung:=SysGetBootDrive+':\';

  verzeichnis:=ParamStr(1);
  if verzeichnis='' then
    begin
      WriteLn(textz_Verzeichnis_von_^,'config.sys / os2ldr ? [',verzeichnis_emfehlung,']');
      ReadLn(verzeichnis);
      if verzeichnis='' then
        verzeichnis:=verzeichnis_emfehlung;
    end
  else
    verzeichnis:=FExpand(verzeichnis);

  if not (verzeichnis[Length(verzeichnis)] in ['\','/']) then
    verzeichnis:=verzeichnis+'\';


  (*lade_os2csm_bin(verzeichnis);
    lade_menu_txt(verzeichnis);
    lade_menuhlp_txt(verzeichnis);
    lade_os2ldr(verzeichnis);*)

  auftrag_z:=ParamStr(2);
  if auftrag_z<>'' then
    if auftrag_z[1] in ['/','-'] then
      Delete(auftrag_z,1,1);
  auftrag:=unbekannt;

  while auftrag=unbekannt do
    begin

      if auftrag_z='' then
        auftrag_z:=' ';

      case UpCase(auftrag_z[1]) of
        'I'    :
          auftrag:=installation;
        'A','S' , 'U':
          auftrag:=aussetzen;
        'F','C':
          auftrag:=fortsetzen;
        'M':
          auftrag:=os2csm_memdisk_erzeugen;
      else
        WriteLn;
        WriteLn(textz_I_nstallation___^,verzeichnis,'config.sys',textz__aus_^,verzeichnis,'config.sys');
        WriteLn(textz_A_ussetzen______Entfernen_aus_^,verzeichnis,'config.sys');
        WriteLn(textz_________________aber_Sicherung_als_^,verzeichnis,'config.csm');
        WriteLn(textz_F_ortsetzen_____Schreiben_von_^,verzeichnis,'config.sys');
        WriteLn(textz_________________aus_der_Sicherung_^,verzeichnis,'config.csm');
        WriteLn(textz_M_emdisk________^);
        Write  ('> ');
        auftrag_z:=SysReadKey;
        WriteLn(auftrag_z);
      end;
    end;


  case auftrag of
    installation:
      begin

        lade_os2csm_bin(verzeichnis);
        lade_menu_txt(verzeichnis);
        lade_menuhlp_txt(verzeichnis);
        lade_os2ldr(verzeichnis);

        //zum Testen://menu_ausfueren;
        config_sys_anpassen(verzeichnis,'config.sys','config.sys',true,false);
        schreibe_os2ldr_neu(verzeichnis,true);
      end;

    aussetzen:
      begin

        lade_os2csm_bin(verzeichnis);
        lade_menu_txt(verzeichnis);
        lade_menuhlp_txt(verzeichnis);
        lade_os2ldr(verzeichnis);

        config_sys_anpassen(verzeichnis,'config.sys','config.csm',false,false);
        menu_ausfueren;
        config_sys_anpassen(verzeichnis,'config.sys','config.sys',false,true);
        schreibe_os2ldr_neu(verzeichnis,false);
      end;

    fortsetzen:
      begin
        lade_os2csm_bin(verzeichnis);
        lade_menu_txt(verzeichnis);
        lade_menuhlp_txt(verzeichnis);
        lade_os2ldr(verzeichnis);

        config_sys_anpassen(verzeichnis,'config.csm','config.sys',true,false);
        schreibe_os2ldr_neu(verzeichnis,true);
      end;

    os2csm_memdisk_erzeugen:
      begin
        os2csm_memdisk:=true;

        lade_os2csm_bin(verzeichnis);
        lade_menu_txt(verzeichnis);
        lade_menuhlp_txt(verzeichnis);

        config_sys_anpassen(verzeichnis,'config.sys','config.sys',false,false);
        schreibe_os2ldr_neu(verzeichnis,true);
      end;

  else
    RunError_99;
  end;

end.

