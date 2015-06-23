program typsprache_def_cd;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('cd__eckauf_Laufwerk',
                   '[drive ',
                   '[Laufwerk ',
                   '',
                   '');


  sprach_eintrag04('CD_Anfangsblock',
                   'CD-VTOC',
                   'CD-Anfangsblock ',
                   '',
                   '');

  sprach_eintrag04('cd__Bezeichnung',
                   'name:         "',
                   'Bezeichnung:  "',
                   '',
                   '');


  sprach_eintrag04('cd__Herausgeber',
                   'publisher:    "',
                   'Herausgeber:  "',
                   '',
                   '');

  sprach_eintrag04('cd__Aufzeichnung',
                   'recording:    "',
                   'Aufzeichnung: "',
                   '',
                   '');

  sprach_eintrag04('cd__datumzeit',
                   'date/time:    "',
                   'Datum/Zeit:   "',
                   '',
                   '');

  schreibe_sprach_datei('$$$_cd.001','$$$_cd.002','sprach_modul_typ_cd','sprach_start_typ_cd','^string');
end.

