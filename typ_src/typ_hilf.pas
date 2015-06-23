(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_hilf;

interface

procedure hilfe;

implementation

(*$IfDef HILFE_EINSPAREN*)
procedure hilfe;
  begin
  end;

(*$Else*)

uses
  typ_type,
  typ_var,
  typ_eiau,
  typ_ausg,
  typ_varx,
  typ_os,
  typ_spra;


procedure hilfe;


  (*-$I ..\AUTOR\AUTOR_I.PAS *) (* Adresse,elm,Telefon,Modem *)
  (*$I AUTOR_I.QQQ *) (* Adresse,elm,Telefon,Modem *)
{ contains
const
  adresse_2='Lbben,  Hartmannsdorfer Straáe 30,     15907';

  elm      ='Veit.Kannegieser@gmx.de';
  www      ='http://www-user.TU-Cottbus.DE/~kannegv';

  telefon_2='0-49-3546-4650';}

  var
    so          :aus_attribute;
    term_zaehler:term_typ;

  begin
    (*$IfNDef PROFILER*)

    hilfe_aktiv:=wahr;
    sofortanzeige:=falsch;

    (*
    if not (country_code in [49,41,99,61,88,44,1,45,32,2,33,42,31,36,39,81,82,47,86,48,3,34,46,90,38,7])
    and (country_code<>358)
    and (country_code<>354)
    and (country_code<>351)

     then
      ausschrift_x(' In what country do you live? send me a hint!',beschreibung,vorne);

    z.B.: Brasilien
    *)
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    ausschrift_tab('  ²±²±²±²±²±'                     );
    ausschrift_tab('      ²±'                         );
    ausschrift_tab('      ²±'                         );
    ausschrift_tab('      ²±      ²±     ±²    ²±²±'  );
    ausschrift_tab('      ²±       ±²   ²±     ²±  ²±');
    ausschrift_tab('      ²±        ²± ±²      ²±  ²±');
    ausschrift_tab('      ²±         ±²±       ²±²±'  );
    ausschrift_tab('                  ²±       ²±'    );
    ausschrift_tab('                   ±²      ²±'    );
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    ausschrift_v(' ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿');
    ausschrift_v(' ³                                                                            ³');
    ausschrift_v(' ³  Typ ş '+textz_Version_vom^+str_(typ_tag,2)+'.'+str_(typ_mon,2)+'.'+str_(typ_jahr,4)
                                                +'                                              ³');
    ausschrift_v(' ³  '+textz_hilfe_0_1^+'  ³');
    ausschrift_v(' ³  '+textz_hilfe_0_2^+'  ³');
    ausschrift_v(' ³  '+textz_hilfe_0_3^+'  ³');
    ausschrift_v(' ³                                                                            ³');
    ausschrift_v(' ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ');
    ausschrift_tab('                  Veit Kannegieser');
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    ausschrift_ueberschrift_wechsleblock(textz_Parameter^);
    ausschrift_tab(typ_exe_name+' '+textz_Dateien_Schalter_punktpunkt^);
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_1_1^);
    ausschrift_tab(textz_hilfe_1_2^);
    ausschrift_tab(textz_hilfe_1_3^);
    ausschrift_tab(textz_hilfe_1_4^);
    ausschrift_tab(textz_hilfe_1_5^);
    ausschrift_leerzeile;
    ausschrift_tab(textz_Schalter_doppelpunkt^);
    ausschrift_tab(textz_hilfe_schalter_u^);
    ausschrift_tab(textz_hilfe_schalter_p^);
    ausschrift_tab(textz_hilfe_schalter_s^);
    ausschrift_tab(textz_hilfe_schalter_l^);
    ausschrift_tab(textz_hilfe_schalter_m^);
    ausschrift_tab(textz_hilfe_schalter_n^);
    ausschrift_tab(textz_hilfe_schalter_c^);
    ausschrift_tab(textz_hilfe_schalter_r^);
    (*$IfNDef DOS_ODER_DPMI*)
    ausschrift_tab(textz_hilfe_schalter_g^);
    (*$EndIf*)
    (*$IfDef DOS*)
    ausschrift_tab(textz_hilfe_schalter_j_dos^);
    ausschrift_tab(textz_hilfe_schalter_d_dos^);
    (*$EndIf*)
    ausschrift_tab(textz_hilfe_schalter_i^);
    ausschrift_tab(textz_hilfe_schalter_ausrufezeichen^);
    ausschrift_tab(textz_hilfe_schalter_a^);
    ausschrift_tab(textz_hilfe_schalter_f_1^+' ('+typein_exe_name+')');
    (*$IfDef DOS*)
    ausschrift_tab(textz_hilfe_schalter_e_dos^);
    ausschrift_tab(textz_hilfe_schalter_x_dos^);
    (*$EndIf*)
    (*$IfDef OS2*)
    ausschrift_tab(textz_hilfe_schalter_e_os2^);
    ausschrift_tab(textz_hilfe_schalter_x_os2^);
    (*$EndIf*)
    (*$IfDef DPMI32*)
    ausschrift_tab(textz_hilfe_schalter_x_dpmi32^);
    (*$EndIf*)

    ausschrift_tab(textz_hilfe_schalter_z_1^);
    ausschrift_tab(textz_hilfe_schalter_z_2^);
    ausschrift_tab(textz_hilfe_schalter_b_1^);
    for term_zaehler:=low(term_typ) to high(term_typ) do
      begin
        ausschrift_tab('         x='+terminal_para[term_zaehler]+': '+terminal_namen[term_zaehler]);
      end;
    ausschrift_tab(textz_hilfe_schalter_b_2^);
    ausschrift_tab(textz_hilfe_schalter_b_3^);
    ausschrift_tab(textz_hilfe_schalter_b_4^);
    ausschrift_tab(textz_hilfe_schalter_b_5^);
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_schalter_allgemein_1^);
    ausschrift_tab(textz_hilfe_schalter_allgemein_2^);
    ausschrift_tab(textz_hilfe_schalter_allgemein_3^);
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_schalter_beispiel^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_dateitrenner1^);
    ausschrift_tab(textz_hilfe_dateitrenner2^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;


    ausschrift_ueberschrift_wechsleblock(typein_exe_name);
    ausschrift_tab(textz_hilfe_typeinexe_1^);
    ausschrift_tab(textz_hilfe_typeinexe_2^);
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_typeinexe_3^);
    ausschrift_tab(textz_hilfe_typeinexe_4a^+ty_bat_name+textz_hilfe_typeinexe_4b^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;

    ausschrift_ueberschrift_wechsleblock(textz_Farblegende^);
    for so:=compiler to spielstand do
      ausschrift_x('         ş '+aus_attr_namen[so]^,so,vorne);
    ausschrift_leerzeile;
    ausschrift_leerzeile;

    ausschrift_ueberschrift_wechsleblock(textz_verwendete_Symbolik^);
    ausschrift_tab(textz_hilfe_symbolik_1^);
    ausschrift_tab(textz_hilfe_symbolik_2^);
    ausschrift_tab(textz_hilfe_symbolik_3^);
    ausschrift_tab(textz_hilfe_symbolik_4^);
    ausschrift_tab(textz_hilfe_symbolik_5^);
    ausschrift_tab(textz_hilfe_symbolik_6^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;

    ausschrift_ueberschrift_wechsleblock(textz_hilfe_Tastaturbelegung^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_1^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_2a^+str0(bzeilen-2)+textz_hilfe_Tastaturbelegung_2b^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_3^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_4^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_5^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_6^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_7^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_8^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_9^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_10^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_11^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_12^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_13^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_14^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_15^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_Tastaturbelegung_16^);
    ausschrift_tab(textz_hilfe_Tastaturbelegung_17^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;

    ausschrift_ueberschrift_wechsleblock(textz_Mausbelegung^);
    ausschrift_tab(textz_hilfe_Mausbelegung_1^);
    ausschrift_tab(textz_hilfe_Mausbelegung_2a^+str0(bzeilen-2)+textz_hilfe_Mausbelegung_2b^);
    ausschrift_tab(textz_hilfe_Mausbelegung_3a^+str0(bzeilen-2)+textz_hilfe_Mausbelegung_3b^);
    ausschrift_tab(textz_hilfe_Mausbelegung_4^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;

    (*$IfDef DOS*)
    ausschrift_ueberschrift_wechsleblock(textz_Spielhebelbelegung^);
    ausschrift_tab(textz_hilfe_spielhebelbelegung_1^);
    ausschrift_tab(textz_hilfe_spielhebelbelegung_2a^+str0(bzeilen-2)+textz_hilfe_spielhebelbelegung_2b^);
    ausschrift_tab(textz_hilfe_spielhebelbelegung_3^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    (*$EndIf*)

    (*$IfDef DOS*)
    ausschrift_ueberschrift_wechsleblock(textz_Der_Parameter_D_plus^);
    ausschrift_tab(textz_hilfe_Der_Parameter_D_plus_1_1^);
    ausschrift_tab(textz_hilfe_Der_Parameter_D_plus_1_2^);
    ausschrift_tab(textz_hilfe_Der_Parameter_D_plus_1_3^);
    ausschrift_tab(textz_hilfe_Der_Parameter_D_plus_1_4^);
    ausschrift_tab(textz_hilfe_Der_Parameter_D_plus_1_5^);
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_Der_Parameter_D_plus_2_1^);
    ausschrift_leerzeile;
    ausschrift_tab('ş HyperDisk / Roger Cross');
    ausschrift_tab('ş QUICKCACHE II / P.R. Glassel '+textz_hilfe_Der_Parameter_D_plus_3_1^);
    ausschrift_tab('ş Super PC-Kwik 3.20+, PC-Cache 5.x, Qualitas Qcache 4.00');
    ausschrift_tab('ş SMARTDRV 4.00+, PC-Cache 8.0, NWCache');
    ausschrift_tab('ş FAST! 4.02+');
    ausschrift_tab('ş PC-Cache 6+');
    ausschrift_tab('ş NCACHE 5+');
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_Der_Parameter_D_plus_4_1^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;
    (*$EndIf*)

    ausschrift_ueberschrift_wechsleblock(textz_geschwindigkeit^);
    (*$IfDef DOS*)
    ausschrift_tab(textz_hilfe_geschwindigkeit_dos_1^);
    ausschrift_tab(textz_hilfe_geschwindigkeit_dos_2^);
    ausschrift_tab(textz_hilfe_geschwindigkeit_dos_3^);
    ausschrift_tab(textz_hilfe_geschwindigkeit_dos_4^);
    (*$EndIf*)
    (*$IfDef OS2*)
    ausschrift_tab(textz_hilfe_geschwindigkeit_os2_1^);
    ausschrift_tab(textz_hilfe_geschwindigkeit_os2_2^);
    (*$EndIf*)
    (*$IfDef DPMI32*)
    ausschrift_tab(textz_hilfe_geschwindigkeit_dpmi32_1^);
    //ausschrift_tab(textz_hilfe_geschwindigkeit_dpmi32_2^);
    (*$EndIf*)
    ausschrift_leerzeile;
    ausschrift_leerzeile;


    ausschrift_ueberschrift_wechsleblock(textz_Was_kann_das_Programm_nicht^);
    ausschrift_tab(textz_hilfe_Was_kann_das_Programm_nicht_1_1^);
    ausschrift_tab(textz_hilfe_Was_kann_das_Programm_nicht_1_2^);
    ausschrift_tab(textz_hilfe_Was_kann_das_Programm_nicht_1_3^);
    ausschrift_tab(textz_hilfe_Was_kann_das_Programm_nicht_1_4^);
    ausschrift_tab(textz_hilfe_Was_kann_das_Programm_nicht_1_5^);
    ausschrift_tab(textz_hilfe_Was_kann_das_Programm_nicht_1_6^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;

    ausschrift_ueberschrift_wechsleblock(textz_Das_Programm_liefert_Rueckkehrwerte^);
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_Das_Programm_liefert_Rueckkehrwerte_1^);
    ausschrift_tab(textz_hilfe_Das_Programm_liefert_Rueckkehrwerte_2^);
    ausschrift_tab(textz_hilfe_Das_Programm_liefert_Rueckkehrwerte_3^);
    ausschrift_tab(textz_hilfe_Das_Programm_liefert_Rueckkehrwerte_4^);
    ausschrift_tab(textz_hilfe_Das_Programm_liefert_Rueckkehrwerte_5^);
    ausschrift_tab(textz_hilfe_Das_Programm_liefert_Rueckkehrwerte_6^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;

    (* Schrott
    ausschrift_ueberschrift_wechsleblock(textz_Urheberrecht_Garantie_Haftung_Warenzeichen^);
    ausschrift_tab(textz_hilfe_Urheberrecht_Garantie_Haftung_Warenzeichen_1^);
    ausschrift_tab(textz_hilfe_Urheberrecht_Garantie_Haftung_Warenzeichen_2^);
    ausschrift_tab(textz_hilfe_Urheberrecht_Garantie_Haftung_Warenzeichen_3^);
    ausschrift_tab(textz_hilfe_Urheberrecht_Garantie_Haftung_Warenzeichen_4^);
    ausschrift_tab(textz_hilfe_Urheberrecht_Garantie_Haftung_Warenzeichen_5^);
    ausschrift_leerzeile;
    ausschrift_leerzeile; *)

    ausschrift_ueberschrift_wechsleblock(textz_Die_Programmdateien^);
    (*$IfDef DOS*)
    ausschrift_tab(textz_hilfe_Die_Programmdateien_bp7diet_1^);
    ausschrift_tab(textz_hilfe_Die_Programmdateien_bp7diet_2^);
    ausschrift_tab(textz_hilfe_Die_Programmdateien_bp7diet_3^);
    ausschrift_tab(textz_hilfe_Die_Programmdateien_bp7diet_4^);
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_Die_Programmdateien_bp7diet_5^);
    (*$EndIf*)

    (*$IfDef OS2*)
    ausschrift_tab(textz_hilfe_Die_Programmdateien_vp11lxlite118_1^);
    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_Die_Programmdateien_vp11lxlite118_2^);
    (*$EndIf*)

    (*$IfDef DPMI32*)
    ausschrift_tab(textz_hilfe_Die_Programmdateien_vp20_dpmi32_1^);
    //ausschrift_leerzeile; upx? xe?
    //ausschrift_tab(textz_hilfe_Die_Programmdateien_vp20_dpmi32_2^);
    (*$EndIf*)

    ausschrift_leerzeile;
    ausschrift_tab(textz_hilfe_Die_Programmdateien_veraenderungen_1^);
    ausschrift_tab(textz_hilfe_Die_Programmdateien_veraenderungen_2^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;

    {
    ausschrift_ueberschrift_wechsleblock(textz_Vorhaben^);
    ausschrift_tab(textz_hilfe_Vorhaben_1^);
    ausschrift_tab(textz_hilfe_Vorhaben_2^);
    ausschrift_tab('ş Instalit Multilingual');
    ausschrift_tab('ş RTPatch');
    ausschrift_leerzeile;
    ausschrift_leerzeile;}

    ausschrift_ueberschrift_wechsleblock(textz_Programmaktualisierung^);
    ausschrift_tab(textz_hilfe_Programmaktualisierung_1^);
    ausschrift_tab(textz_hilfe_Programmaktualisierung_2^);
    ausschrift_tab(textz_hilfe_Programmaktualisierung_3^);
    ausschrift_tab(textz_hilfe_Programmaktualisierung_4^);
    ausschrift_tab(textz_hilfe_Programmaktualisierung_5^);
    ausschrift_tab(textz_hilfe_Programmaktualisierung_6^);
    ausschrift_tab(textz_hilfe_Programmaktualisierung_7^);
    ausschrift_leerzeile;
    ausschrift_leerzeile;

    ausschrift_ueberschrift_wechsleblock(textz_Erreichbarkeit^);
    ausschrift_tab(textz__254_persoenlich^);
    (*ausschrift_tab('ú '+adresse_1);*)
    ausschrift_tab('ú '+adresse_2);
    ausschrift_leerzeile;
    ausschrift_tab(textz__254_ueber_Internet^);
    ausschrift_tab('ú '+elm);
    ausschrift_tab('ú '+www);
    ausschrift_leerzeile;
    ausschrift_tab(textz__254_Telefon^);
    (*ausschrift_tab('ú '+telefon_1);*)
    ausschrift_tab('ú '+telefon_2);
    ausschrift_leerzeile;
    if zeilenspeicherung then
      begin
        ausschrift_leerzeile;
        ausschrift_v('²±²±²±²±²±²±²±²±²±²±²±²±²±²±²±²'+textz_Ende_der_Hilfe^+'±²±²±²±²±²±²±²±²±²±²±²±²±²±²±²±');
        speicher_bericht;
      end;
    nachholen;
    hilfe_aktiv:=falsch;
    (*$EndIf*)
  end;
(*$EndIf*)

end.

