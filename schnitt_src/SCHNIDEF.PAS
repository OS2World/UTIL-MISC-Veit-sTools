program schnidef;
(* V.K. 23.10.1996 *)

uses spr2_ein;

begin
  sprachtabellenkopf('EN'+'DE'+''+'');

  sprach_eintrag04('gleiche_Dateinamen',
                   'same filenames !',
                   'gleiche Dateinamen !',
                   '',
                   '');


  sprach_eintrag04('Benutzung_SCHNITT_Quelldatei',
                   'USAGE: SCHNITT <source file> <start position> [ <length> ] <target file>',
                   'Benutzung : SCHNITT <Quelldatei> <Startposition> [ <L„nge> ] <Zieldatei>',
                   '',
                   '');

  sprach_eintrag04('Der_Parameter',
                   'The parameter ¯',
                   'Der Parameter ¯',
                   '',
                   '');

  sprach_eintrag04('ist_unsinnig',
                   '® makes no sense !',
                   '® ist unsinnig !',
                   '',
                   '');

  sprach_eintrag04('Die_Startpostion_in_der_Quelldatei_liegt_ausserhalb_der_Dateigrenzen',
                   'The start position is situated outside of file borders',
                   'Die Startpostion in der Quelldatei liegt auáerhalb der Dateigrenzen.',
                   '',
                   '');

  sprach_eintrag04('Der_Parameter_Laenge_ist_groesser_als_der_Rest_der_Quelldatei',
                   'The length parameter is greater than the rest of the source file !',
                   'Der Parameter L„nge ist gr”áer als der Rest der Quelldatei !',
                   '',
                   '');

  (*
  sprach_eintrag04('Lesen',
                   ' read',
                   'Lesen',
                   '',
                   '');

  sprach_eintrag04('von',
                   ' of',
                   'von',
                   '',
                   '');

  sprach_eintrag04('Schreiben',
                   '    write',
                   'Schreiben',
                   '',
                   '');*)

  sprach_eintrag04('Fehler',
                   'error ',
                   'Fehler ',
                   '',
                   '');

  sprach_eintrag04('tabelle_z1',
                   '        Read                Write',
                   '        Lesen               Schreiben',
                   '',
                   '');

  sprach_eintrag04('tabelle_z2',
                   '        position  sum       position',
                   '        Position  Summe     Position',
                   '',
                   '');

  sprach_eintrag04('tabelle_z3',
                   'from    ',
                   'von     ',
                   '',
                   '');

  sprach_eintrag04('tabelle_z4',
                   'now     -         -         -',
                   'jetzt   -         -         -',
                 (* 1234567890123456789012345678901234567890 *)
                 (*          1         2         3         4 *)
                   '',
                   '');

  sprach_eintrag04('tabelle_z5',
                   'to      ',
                   'bis     ',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');}

  schreibe_sprach_datei('SCHNI$$$.001','SCHNI$$$.002','sprach_modul','sprach_start','^string');
end.
