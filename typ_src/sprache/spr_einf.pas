program typsprache_def_einf;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('einf__Name_der_Farbdatei',
                   'name of color table file',
                   'Name der Farbdatei',
                   '',
                   '');

  sprach_eintrag04('einf__Kommentar',
                   'comment? ',
                   'Kommentar? ',
                   '',
                   '');

  sprach_eintrag04('einf__speichern',
                   'save',
                   'Speichern',
                   '',
                   '');

  sprach_eintrag04('einf__verwerfen',
                   'drop',
                   'Verwerfen',
                   '',
                   '');

  sprach_eintrag04('einf__Veraendern_der_Vordergrundfarbe',
                   'modify textcolor',
                   'Ver„ndern der Vordergrundfarbe',
                   '',
                   '');

  sprach_eintrag04('einf__Veraendern_der_Hintergrundfarbe',
                   'modify background color',
                   'Ver„ndern der Hintergrundfarbe',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }
  schreibe_sprach_datei('$$$_einf.001','$$$_einf.002','sprach_modul_typ_einf','sprach_start_typ_einf','^string');
end.

