program prsys_def;

uses
  spr2_ein;

begin
  sprachtabellenkopf(
                    +'EN'
                    +'DE'
                    +''
                    +'');

  sprach_eintrag04('hilfe',
                   'PRSYS <input file> <output file>',
                   'PRSYS <Quelldatei> <Zieldatei>',
                   '',
                   '');

  sprach_eintrag04('fehler_keine_exe',
                   'Source file is not an EXE.',
                   'Quelldatei liegt nicht im EXE-Format vor.',
                   '',
                   '');

  sprach_eintrag04('fehler_zu_gross',
                   'Source file is to big.',
                   'Die Quelldatei ist zu gro·.',
                   '',
                   '');

  sprach_eintrag04('fehler_exe2bin',
                   'Source file has no relocations. Use EXE2BIN.',
                   'Die Quelldatei hat keine Segmentkorrekturen. Benutzen Sie EXE2BIN.',
                   '',
                   '');

  sprach_eintrag04('fehler_zu_viele_relo',
                   'The source file has too many relocations.',
                   'Die Quelldatei hat zu viele Segmentkorrekturen.',
                   '',
                   '');

  sprach_eintrag04('fehler_ergebnis_zu_gross',
                   'The target file would be to big.',
                   'Die Zieldatei wÅrde zu gro· werden.',
                   '',
                   '');

  sprach_eintrag04('fehler_relo_ausserhalb_programmbereich',
                   'An relocation is out of program area.',
                   'Eine Segmentkorrektur liegt au·erhalb des Programmbereiches.',
                   '',
                   '');
{
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');}

  schreibe_sprach_datei('PRSYS$$$.001','PRSYS$$$.002','sprach_modul','sprach_start','^string');
end.

