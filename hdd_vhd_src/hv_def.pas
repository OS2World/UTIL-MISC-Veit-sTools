program hdd_vhd_string_definition;

uses
  spr2_ein;

begin
  sprachtabellenkopf(
                    +'EN'
                    +'DE'
                    +''
                    +'');

  sprach_eintrag04('quellformat_svista_gepackt',
                   'Source is an SVISTA hard disk, but it is in compressed format, can not handle that.',
                   'Quelldatei ist im gepacktem SVISTA-Format, kann nicht verarbeitet werden.',
                   '',
                   '');

  sprach_eintrag04('quellformat_vpc_aber_nicht_raw2',
                   'Source is an VPC hard disk, but it is not raw format, can not handle that.',
                   'Quelldatei ist im gepackten VPC-Format, kann nicht verarbeitet werden.',
                   '',
                   '');

  sprach_eintrag04('Dateilaenge_ist_nicht_Vielfaches_von_512',
                   'Filesize is not multiple of 512 bytes',
                   'DateilÑnge ist nicht Vielfaches von 512.',
                   '',
                   '');

  sprach_eintrag04('Die_Partitionstabelle_ist_ungueltig_55_AA_fehlt',
                   'MBR table is not valid (55 AA missing).',
                   'Die Partitionstabelle ist ungÅltig -- 55 AA fehlt.',
                   '',
                   '');

  sprach_eintrag04('Entnehme_Groessenangaben_aus_dem_VPC_Block',
                   'Using geometry data from VPC block.',
                   'Entnehme Grî·enangaben aus dem VPC-Block.',
                   '',
                   '');

  sprach_eintrag04('Suche_Groessenangaben_aus_svs',
                   'Trying to get geometry data from *.svs/*.txt ... ',
                   'Versuche Grî·enangaben aus *.svs/*.txt zu ermitteln ... ',
                   '',
                   '');

  sprach_eintrag04('fehlgeschlagen',
                   'failed.',
                   'fehlgeschlagen.',
                   '',
                   '');

  sprach_eintrag04('erfolgreich',
                   'successful.',
                   'erfolgreich.',
                   '',
                   '');

  sprach_eintrag04('Zylinder',
                   'cylinders',
                   'Zylinder',
                   '',
                   '');

  sprach_eintrag04('Koepfe',
                   'heads',
                   'Kîpfe',
                   '',
                   '');

  sprach_eintrag04('Sektoren_je_Spur',
                   'sectors per track',
                   'Sektoren je Spur',
                   '',
                   '');

  sprach_eintrag04('Geometrie_stimmt_nicht',
                   'geomretry does not match.',
                   'Geometrie stimmt nicht.',
                   '',
                   '');

  sprach_eintrag04('__Dateilaenge__',
                   '  filesize   : ',
                   '  Dateilaenge: ',
                   '',
                   '');

  sprach_eintrag04('__Geometrie____',
                   '  geometry   : ',
                   '  Geometrie  : ',
                   '',
                   '');

  sprach_eintrag04('_Sektoren',
                   ' sectors',
                   ' Sektoren',
                   '',
                   '');

  sprach_eintrag04('dateigroesse_und_umbennen',
                   'setting file size and renaming to: ',
                   'Setze neue DateilÑnge und benenne um: ',
                   '',
                   '');

  sprach_eintrag04('Fehler_beim_Umbenennen',
                   'Error on rename, code=',
                   'Fehler beim Umbenennen, Fehlerwert=',
                   '',
                   '');

  sprach_eintrag04('Fehler_beim_Oeffnen',
                   'Error opening harddisk image file, code=',
                   'Fehler beim ôffnen der Abbilddatei, Fehlerwert=',
                   '',
                   '');

  sprach_eintrag04('erzeuge_txt_svista',
                   'Creating text file with geometry data,'#13#10'please paste them yourself into the *.svs file.',
                   'Erzeuge Textdatei mit Geometriedaten,'#13#10'bitte fÅgen Sie diese selbst in die *.svs-Datei ein.',
                   '',
                   '');

  sprach_eintrag04('usage1',
                   'Usage: HDD_VHD <source file name>',
                   'Benutzung HDD_VHD <Dateiname>',
                   '',
                   '');

  sprach_eintrag04('usage2',
                   ' will convert VPC->SVISTA (*.VHD source, *.HDD/TXT target)',
                   ' wandelt VPC in SVISTA-Festplattenabbilder um (*.VHD nach *.HDD/TXT)',
                   '',
                   '');

  sprach_eintrag04('usage3',
                   ' will convert SVISTA->VPC (*.HDD source, *.VHD target)',
                   ' wandelt SVISTA in VPC-Festplattenabbilder um (*.HDD nach *.VHD)',
                   '',
                   '');

  sprach_eintrag04('usage4',
                   'note: the program alters and renames the *source file*!',
                   'Hinweis: diese Programm erstell keine Kopien, es benennt die Quelldatei um!',
                   '',
                   '');

  sprach_eintrag04('VPC_alignment_geometry_mismatch',
                   'Either there is more than 1 MiB alignment or an geometry error in the source.',
                   'Entweder mehr als 1 MiB AuffÅllnullen, oder die VPC-Geometrie stimmt nicht.',
                   '',
                   '');

{
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');}

  schreibe_sprach_datei('HDD_VHD$.001','HDD_VHD$.002','sprach_modul','sprach_start','^string');
end.
