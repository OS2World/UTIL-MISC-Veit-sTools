(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_boot;

interface

procedure initialisiere_laufwerkstabelle(const wert:boolean);
procedure bearbeite_startsektor(const laufwerk:char);

implementation

uses
  typ_sekt,
  typ_var,
  typ_type,
  typ_netw,
  typ_cd,
  typ_eiau,
  typ_ausg,
  typ_spra;

procedure initialisiere_laufwerkstabelle(const wert:boolean);
  var
    laufwerk:char;
  begin
    for laufwerk:='A' to '`' do
      begin
        lw_tabelle      [laufwerk]:=not wert;
        datentraegername[laufwerk]:=not wert;
      end;
  end;

procedure bearbeite_startsektor(const laufwerk:char);
  var
    boot_puffer1,boot_puffer2:puffertyp;
  begin
    if (laufwerk<'A') or (laufwerk>'`') then exit; (* 32 Laufwerke *)

    if not lw_tabelle[laufwerk] then
      begin
        lw_tabelle[laufwerk]:=wahr;

        (*$IfDef DOS_ODER_DPMI*) (* DPMI32? *)
        physikalisch:=(laufwerk in ['A','B']);
        (*$Else*)
        physikalisch:=false;
        (*$EndIf*)

        if (not netz_test(laufwerk)) and (not cd_untersuchung(laufwerk)) and (not subst_test(laufwerk)) then
          begin
            sekt_dos_fehler:=dos_sektor_lesen(0,ord(laufwerk)-65,boot_puffer1);

            if physikalisch then
              begin
                (* Diskettenlaufwerk -> 82/2/36 annehmen *)
                sekt_bios_fehler:=bios_sektor_lesen(Ord(laufwerk)-Ord('A'), 0,0,1, 36,2 ,boot_puffer2);
                if (sekt_bios_fehler=0) and (sekt_dos_fehler=0) then
                  begin
                    kontrolle:=0;
                    while (kontrolle<=511) and (boot_puffer2.d[kontrolle]=boot_puffer1.d[kontrolle]) do
                      inc(kontrolle);
                    if kontrolle=512 then physikalisch:=falsch;
                  end;
              end;

            (*$IfNDef OS2*)
            if physikalisch then
              begin
                ausschrift_v(textz_Startsektor_Laufwerk^+laufwerk+textz_physikalisch^);

                if sekt_bios_fehler=0 then
                  begin
                    hersteller_gefunden:=falsch;
                    herstellersuche:=1;
                    analyseoff:=0;
                    einzel_laenge:=512;
                    codeoff_seg:=0;
                    codeoff_off:=0;
                    start_sekt(boot_puffer2,falsch,255,wahr,0,0,0);
                    if not hersteller_gefunden then ausschrift_nichts_gefunden(signatur);
                  end
                else
                  ausschrift(textz_nicht_lesbar^,signatur);
              end;
              (*$EndIf*)

              if physikalisch then
                ausschrift_v(textz_Startsektor_Laufwerk^+laufwerk+textz_logisch^)
              else
                (*$IfDef OS2*)
                ausschrift_v(textz_Startsektor_Laufwerk^+laufwerk+':] [IFS='+ifs_name(laufwerk)+']');
                (*$Else*)
                ausschrift_v(textz_Startsektor_Laufwerk^+laufwerk+':]');
                (*$EndIf*)

              if sekt_dos_fehler=0 then
                begin
                  hersteller_gefunden:=falsch;
                  herstellersuche:=1;
                  analyseoff:=0;
                  einzel_laenge:=512;
                  codeoff_seg:=0;
                  codeoff_off:=0;
                  start_sekt(boot_puffer1,falsch,255,wahr,0,0,0);
                  if not hersteller_gefunden then ausschrift_nichts_gefunden(signatur);
                end
              else
                ausschrift(textz_nicht_lesbar^,signatur);
          end;
      end;

  end;

end.

