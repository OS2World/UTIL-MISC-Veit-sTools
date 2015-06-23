program e0x_edef;
(* V.K. 10.10.1996 *)

uses spra_ein;

begin
  sprachtabellenkopf(true,true,false,false);

  sprach_eintrag('fehler_dos_003',
                 'path not found',
                 'Pfad nicht gefunden',
                 '',
                 '');

  sprach_eintrag('fehler_dos_005',
                 'file access denied',
                 'Zugriff auf Datei nicht erlaubt',
                 '',
                 '');

  sprach_eintrag('fehler_dos_015',
                 'invalid drive number',
                 'ungltiges Laufwerk',
                 '',
                 '');

  sprach_eintrag('fehler_dos_101',
                 'write error',
                 'Schreibfehler',
                 '',
                 '');

  sprach_eintrag('fehler_dos_150',
                 'disk is write-protected',
                 'Platte schreibgeschtzt',
                 '',
                 '');

  sprach_eintrag('fehler_dos_152',
                 'drive not ready',
                 'Laufwerk nicht bereit',
                 '',
                 '');

  sprach_eintrag('fehler_dos_158',
                 'sector not found',
                 'Sektor nicht gefunden',
                 '',
                 '');

  sprach_eintrag('fehler_dos_162',
                 'Hardware failure',
                 '"Hardwarefehler" Datei schon offen ?',
                 '',
                 '');

  sprach_eintrag('unbekannter_Fehler',
                 'unknown error',
                 'unbekannter Fehler:',
                 '',
                 '');

  sprach_eintrag('Dieses_Programm_erzeugt_Hilfsdateien1',
                 ' This Program creates batchfiles',
                 ' Dieses Programm erzeugt Hilfsdateien',
                 '',
                 '');

  sprach_eintrag('Dieses_Programm_erzeugt_Hilfsdateien2',
                 ' E0A.BAT, E0B.BAT, NC!.BAT, OPT.BAT and OPT!.BAT for this PC.',
                 ' E0A.BAT, E0B.BAT, NC!.BAT, OPT.BAT und OPT!.BAT fr diesen Rechner.',
                 '',
                 '');

  sprach_eintrag('Suche_von',
                 'search file',
                 'Suche von',
                 '',
                 '');

  sprach_eintrag('nicht_gefunden',
                 ' not found !',
                 ' nicht gefunden !',
                 '',
                 '');

  sprach_eintrag('gefunden_als',
                 'found as',
                 'gefunden als',
                 '',
                 '');

  sprach_eintrag('waehle_deshalb_COMSPEC',
                 ' .. chose instead contents of %COMSPEC%',
                 ' .. w„hle deshalb den Wert von %COMSPEC%',
                 '',
                 '');

  sprach_eintrag('Zielfadauswahl_fuer_die_BAT_Dateien',
                 'selection of destination for .BAT files',
                 'Zielfadauswahl fr die .BAT Dateien',
                 '',
                 '');

  sprach_eintrag('Ihre_Entscheidung',
                 '  your choice ? : ',
                 '  Ihre Entscheidung ? : ',
                 '',
                 '');

  sprach_eintrag('Schreiben_der_Hilfsdateien',
                 'generate batchfiles',
                 'Schreiben der Hilfsdateien',
                 '',
                 '');

  sprach_eintrag('fehler',
                 'error! ',
                 'Fehler! ',
                 '',
                 '');

  sprach_eintrag('e0a_hilfe1',
                 'usage   E0',
                 'Benutzung   E0',
                 '',
                 '');

  sprach_eintrag('e0a_hilfe2',
                 ' image_file [ write_protect ]                           ',
                 ' Abzugsdatei [ Schreiben ]                          ',
                 '',
                 '');

  sprach_eintrag('e0a_hilfe3',
                 'write_protect: 0=write protect 1=write able 2=write changes back  ',
                 'Schreiben: 0=schreibgeschtzt 1=beschreibbar 2=mit Zurckschreiben',
                 '',
                 '');

  sprach_eintrag('e0a_hilfe4',
                 'more help in the dokumatation or help screen of ',
                 'mehr Hilfe in der Dokumenation oder durch Aufruf von ',
                 '',
                 '');

  sprach_eintrag('e0a_hilfe5',
                 '           ',
                 '      ',
                 '',
                 '');

  sprach_eintrag('Bitte_benutzen_sie_E0A_oder_E0B',
                 'please use E0A or E0B'#7,
                 'Bitte benutzen sie E0A oder E0B'#7,
                 '',
                 '');

  sprach_eintrag('Bitte_benutzen_sie_OPT',
                 'please use OPT'#7,
                 'Bitte benutzen sie OPT'#7,
                 '',
                 '');

  sprach_eintrag('Fehler_aufgetreten_Abbruch',
                 '°°°°°°°°°°° error occured Ä abort °°°°°°°°°°°',
                 '°°°°°°°°°°° Fehler aufgetreten Ä Abbruch °°°°°°°°°°°',
                 '',
                 '');

  sprach_eintrag('avp_deutsch_parameter',
                 '',
                 '/LG ',
                 '',
                 '');

  sprach_eintrag('opt_hilfe1',
                 'call chkdsk / disk optimizer / virus scan              ',
                 'Aufruf von Plattentest / Defragmentierer / Virenscanner',
                 '',
                 '');

  sprach_eintrag('opt_hilfe2',
                 'usage OPT image_file     ',
                 'Benutzung OPT Abzugsdatei',
                 '',
                 '');

  sprach_eintrag('REM_Bei_Bedarf_selbst_anpassen',
                 'REM please adapt if needed',
                 'REM Bei Bedarf selbst anpassen !',
                 '',
                 '');

  sprach_eintrag('opt_hilfe3',
                 'ECHO some errors are occured.',
                 'ECHO es sind Fehler aufgetreten.',
                 '',
                 '');

  sprach_eintrag('opt_hilfe4',
                 'ECHO to not destroy the original file %2',
                 'ECHO um die ursprngliche Datei %2 zu retten',
                 '',
                 '');

  sprach_eintrag('opt_hilfe5',
                 'ECHO you should copy it NOW !',
                 'ECHO sollten sie JETZT eine Kopie davon anferigen !',
                 '',
                 '');

  schreibe_sprach_datei('E0X_E$$$.001','E0X_E$$$.002','sprach_modul','sprach_start','^string');
end.