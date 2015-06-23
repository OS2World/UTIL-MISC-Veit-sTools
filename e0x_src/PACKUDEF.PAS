program packudef;
(* V.K. 11.10.1996 *)

uses spra_ein;

begin
  sprachtabellenkopf(true,true,false,false);

  sprach_eintrag('fuer',
                 'for',
                 'fÅr',
                 '',
                 '');

  sprach_eintrag('Zieldatei',
                 'destination file',
                 'Zieldatei',
                 '',
                 '');

  sprach_eintrag('Haupt_Quelldatei',
                 'main source file',
                 'Haupt-Quelldatei',
                 '',
                 '');

  sprach_eintrag('Spuren',
                 'tracks',
                 'Spuren',
                 '',
                 '');

  sprach_eintrag('Sektoren_je_Spur',
                 'tracks',
                 'Sektoren je Spur',
                 '',
                 '');


  sprach_eintrag('Seiten',
                 'heads',
                 'Seiten',
                 '',
                 '');

  sprach_eintrag('Kopieren',
                 'copying',
                 'Kopieren',
                 '',
                 '');

  sprach_eintrag('Anzahl_zusaetzlicher_Sektoren',
                 'number of additional sectors ',
                 'Anzahl zusÑtzlicher Sektoren ',
                 '',
                 '');

  sprach_eintrag('Quelldatei',
                 'source file',
                 'Quelldatei',
                 '',
                 '');

  sprach_eintrag('Spur_1_CH',
                 'track-1  (CH)',
                 'Spur-1   (CH)',
                 '',
                 '');

  sprach_eintrag('Seite_1_DH',
                 'head-1   (DH)',
                 'Seite-1  (DH)',
                 '',
                 '');

  sprach_eintrag('Sektor_CL',
                 'sector   (CL)',
                 'Sektor   (CL)',
                 '',
                 '');

  schreibe_sprach_datei('PACKU$$$.001','PACKU$$$.002','sprach_modul','sprach_start','^string');
end.