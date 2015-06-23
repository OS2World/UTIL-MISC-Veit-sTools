program test_ein;
(*$D TEST_EIN * Test Sprachmodul * V.K. *)

uses spra_ein(*$IFDEF VIRTUALPASCAL*),vpsyslow(*$ENDIF*);

begin
  sprachtabellenkopf(true,   (* eng *)
                     true,   (* ger *)
                     false,  (* fra *)
                     false); (* rus *)

  sprach_eintrag('programm',
                 'program',
                 'Programm',
                 '',
                 '');

  sprach_eintrag('buch',
                 'book',
                 'Buch',
                 '',
                 '');

  sprach_eintrag('rechner',
                 'calculator',
                 'Rechner',
                 '',
                 '');

  schreibe_sprach_datei('TEST$$$.001','TEST$$$.002','sprach_modul','sprach_start','str_z');
end.
