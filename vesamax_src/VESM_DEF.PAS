program vesm_def;

uses spra_ein;

begin

  sprachtabellenkopf(true,true,false,false);

  sprach_eintrag('Grafik_',
                 '   graphics   ',
                 '    Grafik    ',
                 '',
                 '');

  sprach_eintrag('Bit_strich',
                 ' bit ≥ ',
                 ' Bit ≥ ',
                 '',
                 '');

  sprach_eintrag('Text_',
                 'text ',
                 'Text ',
                 '',
                 '');

  sprach_eintrag('entfernt_strich',
                 ' removed  ≥',
                 ' entfernt ≥',
                 '',
                 '');

  sprach_eintrag('bleibt_strich',
                 ' unchangd ≥',
                 '  bleibt  ≥',
                 '',
                 '');

  sprach_eintrag('beschreibung_1',
                 '         This Program removes VESA-modes that have',
                 '         Dieses Programm entfernt VESA-Grafikmodi',
                 '',
                 '');

  sprach_eintrag('beschreibung_2',
                 '           to much colors or to high resolution.',
                 '        die zu hohe Auflîsung oder Farbtiefe haben.',
                 '',
                 '');

  sprach_eintrag('Benutzung_',
                 '  usage:',
                 'Benutzung : ',
                 '',
                 '');

  sprach_eintrag('groesste_Zeilenzahl__groesste_Farbtiefe',
                 '(maximal line count) (maximal color deept)',
                 '(grî·te Zeilenzahl) (grî·te Farbtiefe)',
                 '',
                 '');

  sprach_eintrag('kein_VESA_Treiber_installiert',
                 'no VESA-driver installed !'#7,
                 'kein VESA-Treiber installiert !'#7,
                 '',
                 '');

  sprach_eintrag('fuer_meine_Zwecke_benoetige_ich_einen_VESA_Treiber_Version_1_02',
                 'for my purpose i need VESA driver version Ú 1.02 !'#7,
                 'fÅr meine Zwecke benîtige ich einen VESA-Treiber Version Ú 1.02 !'#7,
                 '',
                 '');

  sprach_eintrag('Schreiben_sie_an_den_Autor',
                 'contact the author !',
                 'Schreiben sie an den Autor !',
                 '',
                 '');

  sprach_eintrag('tabellenkopf',
                 ' ≥  mode   ≥  text/graphics ≥  resolution ≥ colors ≥ remove    ≥',
                 ' ≥  Modus  ≥   Text/Grafik  ≥  Auflîsung  ≥ Farben ≥ Sperrung  ≥',
                 '',
                 '');

  sprach_eintrag('Problem_ROM',
                 'problem: VESA-table is located in ROM - can not modify'#7,
                 'Problem: Die VESA-Tabelle liegt im ROM - nicht Ñnderbar'#7,
                 '',
                 '');

  sprach_eintrag('tip_rom_problem',
                 'hint: use VESA-TSR',
                 'Tip: Benutzen sie ein VESA-TSR',
                 '',
                 '');

  sprach_eintrag('Farben',
                 'colors',
                 'Farben',
                 '',
                 '');

{
  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');
}
  schreibe_sprach_datei('vesm$$$.001','vesm$$$.002','sprach_modul','sprach_start','^string');
end.
