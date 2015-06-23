program typsprache_def_var;
(* V.K. 19.11.1996 *)

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  (* aus TYP_VAR.PAS *)
  sprach_eintrag04('dos_fehler_001',
                   'invalid function number',
                   'ungÅltige DOS-Funktion',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_002',
                   'file not found',
                   'Datei nicht gefunden',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_003',
                   'path not found',
                   'Pfad nicht gefunden',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_004',
                   'to many open files',
                   'zu viele offne Dateien',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_005',
                   'file access denied',
                   'Zugriff verweigert',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_006',
                   'invalid file handle',
                   'ungÅltiger DateizugriffschlÅssel',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_007',
                   'memory controlblock destroied',
                   'Speicherverwaltungblock zerstîrt',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_008',
                   'not enough memory',
                   'nicht genug Speicher',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_009',
                   'invalid memory address',
                   'ungÅltige Speicherblockadresse',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_010',
                   'corrupted environment block',
                   'ungÅltiger Umgebungsblock',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_011',
                   'invalid format',
                   'ungÅltiges Format',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_012',
                   'invalid file access code',
                   'ungÅltiger Zugriffsmodus',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_013',
                   'invalid data',
                   'ungÅltige Daten',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_015',
                   'invalid drive number',
                   'ungÅltiges Laufwerk',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_016',
                   'cannot remove current directory',
                   'aktuelles Verzeichnis kann nicht entfernt werden',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_018',
                   'no more files',
                   'keine weitere Dateien',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_021',
                   'drive not ready',
                   'Laufwerk nicht bereit',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_027',
                   'sector not found',
                   'Sektor nicht gefunden',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_032',
                   'file already in use',
                   'Datei wird bereits genutzt',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_086',
                   'password requied for access',
                   'Kennwort zum Zugriff nîtig',  (* Novell Dos 7 *)
                   '',
                   '');

  sprach_eintrag04('dos_fehler_087',
                   'invalid switch',
                   'UngÅltiger Parameter',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_100',
                   'read error',
                   'Lesefehler',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_102',
                   'file not assigned',
                   'Dateivariable nicht zugeordnet',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_103',
                   'file not open',
                   'Datei nicht offen',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_150',
                   'disk is write-protected',
                   'Schreibschutz!',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_152',
                   'drive not ready',
                   'Laufwerk nicht bereit',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_154',
                   'CRC read error ',
                   'PrÅfsummenfehler beim Lesen',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_156',
                   'seek error',
                   'Positionierungsfehler',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_157',
                   'unknown media type',
                   'unbekannntes Format',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_158',
                   'sector not found',
                   'Sektor nicht gefunden',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_161',
                   'device read error',
                   'GerÑtelesefehler',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_162',
                   'hardware failure',
                   'Hardwarezugriffsfehler',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_216',
                   'protection error',
                   'Schutzfehler',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_15616',
                   'DIET: expand error',
                   'DIET: Fehler beim Auspacken',
                   '',
                   '');

  sprach_eintrag04('var__unbekannter_Fehler_Nr_doppelpunkt',
                   'unknown error nr.',
                   'unbekannter Fehler Nr: ',
                   '',
                   '');
  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  }

  schreibe_sprach_datei('$$$_var.001','$$$_var.002','sprach_modul_typ_var','sprach_start_typ_var','^string');
end.
