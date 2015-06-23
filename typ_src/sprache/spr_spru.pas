program typsprache_def_spru;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('spru__Sprungverschachtelung_zu_gross_oder_Endlosschleife',
                   'jump recursion to big or endless loop!',
                   'Sprungverschachtelung zu groá oder Endlosschleife!',
                   '',
                   '');

  sprach_eintrag04('spru__rel_kurzer_Sprung',
                   'relative short jump',
                   'rel. kurzer Sprung',
                   '',
                   '');

  sprach_eintrag04('spru__rel_Sprung',
                   'relative jump',
                   'rel. Sprung',
                   '',
                   '');

  sprach_eintrag04('spru__rel_Ruf',
                   'relative call',
                   'rel. Ruf',
                   '',
                   '');

  sprach_eintrag04('spru__weiter_Ruf',
                   'far call',
                   'weiter Ruf',
                   '',
                   '');

  sprach_eintrag04('spru__weiter_Sprung',
                   'far jump',
                   'weiter Sprung',
                   '',
                   '');

  sprach_eintrag04('spru__absoluter_Sprung_nach',
                   'absolute jump to ',
                   'absoluter Sprung nach ',
                   '',
                   '');

  sprach_eintrag04('spru__absoluter_Ruf_von',
                   'absolute call of ',
                   'absoluter Ruf von ',
                   '',
                   '');

  schreibe_sprach_datei('$$$_spru.001','$$$_spru.002','sprach_modul_typ_spru','sprach_start_typ_spru','^string');
end.

