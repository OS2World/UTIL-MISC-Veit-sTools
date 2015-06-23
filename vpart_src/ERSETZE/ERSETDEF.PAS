program ersetzedef;

uses spr2_ein;

begin
  sprachtabellenkopf_erweitert(
                     +'EN'
                     +'DE'
                     +''
                     +'',
                     false);

  sprach_eintrag04('titelzeil2',
                   'replace filenames in systemfiles',
                   'Ersetzen von Dateinamen in Systemdateien',
                   '',
                   '');

  sprach_eintrag04('hilfezeile1',
                   'usage: ERSETZE.EXE <filename> <serch string> <replace string>',
                   'Benutzung: ERSETZE.EXE <Dateiname> <Suchen nach> <Ersetzen durch>',
                   '',
                   '');

  sprach_eintrag04('hilfezeile2',
                   'example:   ERSETZE.EXE C:\COMMAND.COM AUTOEXEC.BAT AUTO_600.BAT',
                   'Beispiel:  ERSETZE.EXE C:\COMMAND.COM AUTOEXEC.BAT AUTO_600.BAT',
                   '',
                   '');

  sprach_eintrag04('welcher_dateiname',
                   'filename ?',
                   'Dateiname ?',
                   '',
                   '');

  sprach_eintrag04('Fehler_beim_oeffnen_der_Datei',
                   'error opening file ',
                   'Fehler beim ôffnen der Datei ',
                   '',
                   '');

  sprach_eintrag04('zu_ersetzende_Zeichenkette',
                   'search for wich string ?',
                   'suche nach Zeichenkette ?',
                   '',
                   '');

  sprach_eintrag04('z_punk_b_punk_doppelpunkt',
                   'e.g.:',
                   'z.B.:',
                   '',
                   '');

  sprach_eintrag04('Zeichenkette_nicht_gefunden',
                   'search string not found !',
                   'Zeichenkette nicht gefunden !',
                   '',
                   '');

  sprach_eintrag04('Zeichekette_mal_gefunden_a',
                   'serch string ',
                   'Zeichekette ',
                   '',
                   '');

  sprach_eintrag04('Zeichekette_mal_gefunden_b',
                   ' times found.',
                   ' mal gefunden.',
                   '',
                   '');


  sprach_eintrag04('Ersetzen_durch',
                   'replace string ?',
                   'Ersetzen durch ?',
                   '',
                   '');

  sprach_eintrag04('die_zeichenketten_muessen_gleiche_laenge_haben',
                   '',
                   'Die Zeichenketten mÅssen gleiche LÑnge haben !',
                   '',
                   '');

  schreibe_sprach_datei('ERSET$$$.001','ERSET$$$.002','sprach_modul','sprach_start','^string');
end.

