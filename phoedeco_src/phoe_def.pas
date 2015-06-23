program phoedeco_def;

uses
  spr2_ein;

begin
  sprachtabellenkopf(
                    +'EN'
                    +'DE'
                    +''
                    +'');

  sprach_eintrag04('hilfe',
                   'usage: PHOEDECO <flash rom file> [ <target directory> [/Y|/N] ]',
                   'Benutzung: PHOEDECO <BIOS-Abbilddatei> [ <Zielverzeichnis> [/J|/N] ]',
                   '',
                   '');

  sprach_eintrag04('datei_ist_zu_gross',
                   'The file ist to big!',
                   'Die Datei ist zu groá!',
                   '',
                   '');

  sprach_eintrag04('kopfzeile',
                   'Position packed   C  unpacked type         target      filename',
                   'Position gepackt  K. entpackt Typ          Ziel        Dateiname',
                   '',
                   '');

  sprach_eintrag04('Anker_nicht_gefunden',
                   'Anchor not found!',
                   'Anker nicht gefunden!',
                   '',
                   '');

  sprach_eintrag04('unbekanntes_verfahren',
                   'Please contact author!',
                   'Bitte mir zuschicken!',
                   '',
                   '');

  sprach_eintrag04('kettenfehler',
                   'Found an error in modules chain list!',
                   'Es ist ein Fehler in der Modulkette aufgetreten!',
                   '',
                   '');

  sprach_eintrag04('entpackfehler',
                   'Error during decompression!',
                   'Fehler beim Entpacken!',
                   '',
                   '');

  sprach_eintrag04('versuchen',
                   'Try (y/n)? ',
                   'Versuchen (j/n)? ',
                   '',
                   '');

  sprach_eintrag04('no_header',
                   'no header',
                   'kein Kopf',
                   '',
                   '');

  sprach_eintrag04('remaining_unprocessed',
                   'remaining unprocessed',
                   'Rest unbearbeitet    ',
                   '',
                   '');

  sprach_eintrag04('ist_vermutlich_kein_komprimiertes_phoenix_bios',
                   'Source is likely not an compressed Phoenix BIOS.',
                   'Die Quelle ist vermutlich kein gepacktes Phoenix-BIOS.',
                   '',
                   '');
{
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');}

  schreibe_sprach_datei('PHOEDEC$.001','PHOEDEC$.002','sprach_modul','sprach_start','^string');
end.

