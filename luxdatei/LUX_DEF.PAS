program luxdatei_sprachdefinition;

uses spr2_ein;

begin
  sprachtabellenkopf('EN'+'DE'+''+'');

  sprach_eintrag04('Abbruch_durch_den_Benutzer',
                   'Abort by user',
                   'Abbruch durch den Benutzer',
                   '',
                   '');

  sprach_eintrag04('_Lesefehler_',
                   ' read error ! ',
                   ' Lesefehler ! ',
                   '',
                   '');

  sprach_eintrag04('_Schreibfehler_',
                   ' write error ! ',
                   ' Schreibfehler ! ',
                   '',
                   '');

  sprach_eintrag04('_a_bbrechen',
                   '[a]bort',
                   '[a]bbrechen',
                   '',
                   '');

  sprach_eintrag04('_w_iederholen',
                   '[r]etry',
                   '[w]iederholen',
                   '',
                   '');

  sprach_eintrag04('_i_gnorieren',
                   '[i]gnore',
                   '[i]gnorieren',
                   '',
                   '');

  sprach_eintrag04('_e_wig_probieren',
                   '[e]ndless try',
                   '[e]wig probieren',
                   '',
                   '');

  sprach_eintrag04('i_m_mer_ignorieren___',
                   'a[l]way ignore ? ',
                   'i[m]mer ignorieren ? ',
                   '',
                   '');

  sprach_eintrag04('kann_datei_nicht_oeffen1',
                   'can not open file ',
                   'Kann Datei ',
                   '',
                   '');

  sprach_eintrag04('kann_datei_nicht_oeffen2',
                   ' !',
                   ' nicht ”ffnen !',
                   '',
                   '');

  sprach_eintrag04('kann_datei_nicht_erzeugen1',
                   'can not create file ',
                   'Kann Datei ',
                   '',
                   '');

  sprach_eintrag04('kann_datei_nicht_erzeugen2',
                   ' !',
                   ' nicht erzeugen !',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }
  schreibe_sprach_datei('LUXDAT$$.001','LUXDAT$$.002','sprach_modul','sprach_start','^string');
end.

