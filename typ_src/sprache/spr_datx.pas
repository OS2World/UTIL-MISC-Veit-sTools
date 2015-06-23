program typsprache_def_datx;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('datx__Symboltabelle',
                   'symbol table',
                   'Symboltabelle',
                   '',
                   '');

  sprach_eintrag04('datx__Kopie_Textmodus_Bildschirmspeicher',
                   'copy of text mode screen memory',
                   'Kopie Textmodus-Bildschirmspeicher',
                   '',
                   '');

  sprach_eintrag04('datx__Textvorspann_punktpunktpunkt',
                   'text prefix ...',
                   'Textvorspann ...',
                   '',
                   '');

  sprach_eintrag04('datx__Mission',
                   ' mission ',
                   ' Mission ',
                   '',
                   '');

  sprach_eintrag04('datx__Kopf',
                   'header',
                   'Kopf',
                   '',
                   '');

  sprach_eintrag04('datx__Erweiterte_Attribut',
                   'extended attributes',
                   'Erweiterte Attribute',
                   '',
                   '');

  sprach_eintrag04('datx__Kopf_plus_Bild',
                   'header + image',
                   'Kopf + Bild',
                   '',
                   '');

  sprach_eintrag04('datx__Reperaturdaten_zu_ARJ',
                   'repair dat for ARJ',
                   'Reperaturdaten zu ARJ',
                   '',
                   '');

  sprach_eintrag04('datx__Zusatzdaten',
                   'extra data ',
                   'Zusatzdaten ',
                   '',
                   '');

  sprach_eintrag04('datx__Hoehe_doppelpunkt',
                   ' height :',
                   ' H”he :',
                   '',
                   '');

  sprach_eintrag04('datx__unkomprimiert',
                   'not compressed',
                   'unkomprimiert',
                   '',
                   '');

  sprach_eintrag04('datx__kompimiert',
                   'compressed',
                   'kompimiert',
                   '',
                   '');

  sprach_eintrag04('datx__Zeilen',
                   ' lines',
                   ' Zeilen',
                   '',
                   '');

  sprach_eintrag04('datx__Konfigurationsdatei',
                   'config file ',
                   'Konfigurationsdatei ',
                   '',
                   '');

  sprach_eintrag04('datx__Textdatei',
                   'text file',
                   'Texdatei',
                   '',
                   '');

  sprach_eintrag04('datx__Datenbank',
                   'database ',
                   'Datenbank ',
                   '',
                   '');

  sprach_eintrag04('datx__Felder',
                   ' columns ',
                   ' Felder ',
                   '',
                   '');

  sprach_eintrag04('datx__Saetze',
                   ' records',
                   ' S„tze',
                   '',
                   '');

  sprach_eintrag04('datx__Daten',
                   'data',
                   'Daten',
                   '',
                   '');

  sprach_eintrag04('datx__Grafik',
                   'graphic',
                   'Grafik',
                   '',
                   '');

  sprach_eintrag04('datx__eckauf_Hochsicherheit_eckzu',
                   ' [high security]',
                   ' [Hochsicherheit]',
                   '',
                   '');

  sprach_eintrag04('datx__Treiber',
                   'driver',
                   'Treiber',
                   '',
                   '');

  sprach_eintrag04('datx__Programm',
                   'program',
                   'Programm',
                   '',
                   '');

  sprach_eintrag04('datx__Schnittstelle',
                   'interface',
                   'Schnittstelle',
                   '',
                   '');

  sprach_eintrag04('datx__Implementierung',
                   'implementation',
                   'Implementierung',
                   '',
                   '');

  sprach_eintrag04('datx__Quelltext',
                   'source text',
                   'Quelltext',
                   '',
                   '');

  sprach_eintrag04('datx__Tabelle',
                   'table',
                   'Tabelle',
                   '',
                   '');

  sprach_eintrag04('datx__Lernprogramm',
                   'learn program',
                   'Lernprogramm',
                   '',
                   '');

  sprach_eintrag04('datx__Programminformationen_zu_anf',
                   'program info for "',
                   'Programminformationen zu "',
                   '',
                   '');

  sprach_eintrag04('datx__oder',
                   'or',
                   'oder',
                   '',
                   '');

  sprach_eintrag04('datx__Hilfe',
                   'help ',
                   'Hilfe ',
                   '',
                   '');

  sprach_eintrag04('datx__Farben',
                   ' colors',
                   ' Farben',
                   '',
                   '');

  sprach_eintrag04('datx__leer_Bilder_leer',
                   ' images ',
                   ' Bilder ',
                   '',
                   '');

  sprach_eintrag04('datx__in_oder_mit',
                   ' with ',
                   ' in ',
                   '',
                   '');

  sprach_eintrag04('datx__Vorspann',
                   'prefix',
                   'Vorspann',
                   '',
                   '');

  sprach_eintrag04('datx__Erzeuger_doppelpunkt',
                   'creator:',
                   'Erzeuger:',
                   '',
                   '');

  sprach_eintrag04('datx__Titel_doppelpunkt',
                   'Title  :',
                   'Titel   :',
                   '',
                   '');

  sprach_eintrag04('datx__erstellt_doppelpunkt',
                   'created:',
                   'erstellt:',
                   '',
                   '');

  sprach_eintrag04('datx__ohne_Palette',
                   'without palette',
                   'ohne Palette',
                   '',
                   '');

  sprach_eintrag04('datx__Textdatei_ohne_chr_klammer_13_klammer',
                   'textfile without chr(13)',
                   'Textdatei ohne chr(13)',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }
  schreibe_sprach_datei('$$$_datx.001','$$$_datx.002','sprach_modul_typ_datx','sprach_start_typ_datx','^string');
end.

