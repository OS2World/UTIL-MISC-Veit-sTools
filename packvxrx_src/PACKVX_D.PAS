program packvxrx_d;

uses spr2_ein;

begin
  sprachtabellenkopf(
                    +'EN'
                    +'DE'
                    +''
                    +'');

  sprach_eintrag04('Fehler_',
                   'Error ',
                   'Fehler ',
                   '',
                   '');

  sprach_eintrag04('zu_klein_',
                   'to small.',
                   'zu klein.',
                   '',
                   '');

  sprach_eintrag04('Nicht_mit_VX_Rexx_erzeugt_',
                   'Not created with VX-REXX.',
                   'Nicht mit VX-Rexx erzeugt.',
                   '',
                   '');

  sprach_eintrag04('VX_Rexx_Format_',
                   'VX-Rexx format ',
                   'VX-Rexx Format ',
                   '',
                   '');


  sprach_eintrag04('__nicht_unterstuetzt_',
                   '- not supported.',
                   '- nicht unterstÅtzt.',
                   '',
                   '');

  sprach_eintrag04('Positionsaenderung__LxLite___um_',
                   'Position changed (LxLite) by ',
                   'PositionsÑnderung (LxLite?) um ',
                   '',
                   '');

  sprach_eintrag04('__Einsparung__',
                   '  gain: ',
                   '  Einsparung: ',
                   '',
                   '');

  sprach_eintrag04('hilfe1',
                   'Usage: PACKVXRX <files> | /[T|D|S][|+|-]   [...]',
                   'Benutzung: PACKVXRX <Dateien> | /[T|D|S][|+|-]   [...]',
                   '',
                   '');

  sprach_eintrag04('hilfe2',
                   '  /T+ Delete .tok blocks',
                   '  /T+ Lîschen von .tok Blîcken',
                   '',
                   '');

  sprach_eintrag04('hilfe3',
                   '  /D+ Delete .deb blocks',
                   '  /D+ Lîschen von .deb Blîcken',
                   '',
                   '');

  sprach_eintrag04('hilfe4',
                   '  /S+ scan subdirectories',
                   '  /S+ Dateien in Unterverzeichnissen suchen',
                   '',
                   '');

  sprach_eintrag04('hilfe5',
                   'example: PACKVXRX.EXE WIZILLA.EXE /T+ /D+',
                   'Beispiel: PACKVXRX.EXE WIZILLA.EXE /T+ /D+',
                   '',
                   '');

  sprach_eintrag04('zweck',
                   'packs+fixes VX-REXX programs',
                   'verkeinert VX-REXX - Programm',
                   '',
                   '');

  sprach_eintrag04('nicht_gefunden_',
                   'not found.',
                   'nicht gefunden.',
                   '',
                   '');




  schreibe_sprach_datei('PACKVXR$.001','PACKVXR$.002','sprach_modul','sprach_start','^string');

end.

