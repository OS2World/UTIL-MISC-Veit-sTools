program typsprache_def_kopf;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('kopf__Kopf',
                   'header',
                   'Kopf',
                   '',
                   '');

  sprach_eintrag04('kopf__Geraetetreiber',
                   'device driver',
                   'Ger„tetreiber',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }
  schreibe_sprach_datei('$$$_kopf.001','$$$_kopf.002','sprach_modul_typ_kopf','sprach_start_typ_kopf','^string');
end.

