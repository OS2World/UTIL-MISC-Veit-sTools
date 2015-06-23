program typsprache_def_ausg;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('Speicher_voll_keine_weitere_Bearbeitung',
                   'ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ[ memory full -- no further processing ]ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ',
                   'ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ[ Speicher voll -- keine weitere Bearbeitung ]ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ',
                   '',
                   '');

  sprach_eintrag04('Fehler_waehrend_Kopieren_konventioneller_Speicher_XMS',
                   'error during copy main memory -> XMS',
                   'Fehler wÑhrend Kopieren konventioneller Speicher -> XMS',
                   '',
                   '');

  sprach_eintrag04('Fehler_waehrend_Kopieren_konventioneller_EMS_Speicher_int_67_AH57',
                   'error during copy main memory -> EMS',
                   'Fehler wÑhrend Kopieren konventioneller -> EMS Speicher [int $67 AH=$57]',
                   '',
                   '');

  sprach_eintrag04('Fehler_waehrend_Kopieren_XMS_konventioneller_Speicher',
                   'error during copy XMS -> main memory',
                   'Fehler wÑhrend Kopieren XMS -> konventioneller Speicher',
                   '',
                   '');

  sprach_eintrag04('Fehler_waehrend_Kopieren_EMS_konventioneller_Speicher_int_67_AH57',
                   'error during copy EMS -> main memory',
                   'Fehler wÑhrend Kopieren EMS -> konventioneller Speicher [int $67 AH=$57]',
                   '',
                   '');


  sprach_eintrag04('konventionellen_Speicher_nicht_bekommen_obwohl_genug_frei_gewesen_sein_sollte',
                   'can not get memory but there should enough free',
                   'konventionellen Speicher nicht bekommen obwohl genug frei gewesen sein sollte',
                   '',
                   '');

  sprach_eintrag04('klammer_Speichernutzung_klammer',
                   '[memory usage]',
                   '[Speichernutzung]',
                   '',
                   '');

  sprach_eintrag04('speicher__sorte',
                   ' kind ',
                   ' Sorte',
                   '',
                   '');

  sprach_eintrag04('speicher__bei_Handhabe',
                   ' at/handle  ',
                   'bei/Handhabe',
                   '',
                   '');

  sprach_eintrag04('speicher__Blockgroesse',
                   'blocksize ',
                   'Blockgrî·e',
                   '',
                   '');

  sprach_eintrag04('speicher__Zeilen',
                   'lines ',
                   'Zeilen',
                   '',
                   '');


  sprach_eintrag04('konventionell',
                   'conventional ',
                   'konventionell',
                   '',
                   '');

  sprach_eintrag04('Paragraphen',
                   'paragraphs   ',
                   'Paragraphen  ',
                   '',
                   '');

  sprach_eintrag04('Kilo',
                   'kilo',
                   'Kilo',
                   '',
                   '');

  sprach_eintrag04('Seiten',
                   'pages        ',
                   'Seiten       ',
                   '',
                   '');

  sprach_eintrag04('Pascal_Heap',
                   'Pascal/heap',
                   'Pascal/Heap',
                   '',
                   '');

  sprach_eintrag04('ausg__Byte',
                   'byte      ',
                   'Byte      ',
                   '',
                   '');

  sprach_eintrag04('Fehler_beim_OEffnen_der_Bildschirmdatei',
                   'error opening screen file',
                   'Fehler beim ôffnen der Bildschirmdatei!',
                   '',
                   '');

  sprach_eintrag04('Wie_soll_ich_ohne_VESA_60_Zeilen_auf',
                   'how can i display 60 lines without VESA?'#13#10'(requied: VESA mode $108)',
                   'Wie soll ich ohne VESA 60 Zeilen auf den Bildschirm bekommen?'#13#10'(Erforderlich : VESA-Modus $108)',
                   '',
                   '');

  sprach_eintrag04('VESA_meldet_Fehler_zurueck',
                   'VESA reports error',
                   'VESA meldet Fehler zurÅck',
                   '',
                   '');

  sprach_eintrag04('Zeilen_Hilfe_TYP1',
                   ' lines :       ˙      ˙            ',
                   ' Zeilen:       ˙      ˙            ',
                   '',
                   '');

  sprach_eintrag04('Zeilen_Hilfe_TYP2',
                   ' help :  TYP /?',
                   ' Hilfe:  TYP /?',
                   '',
                   '');

  sprach_eintrag04('verdeckte_zeile_1',
                   '           screen display: this line should not appear!',
                   '           Bildschirmdarstellung: dies Zeile darf nicht zu sehen sein!',
                   '',
                   '');

(*sprach_eintrag04('verdeckte_zeile_2',
                   '           it did : search error in graphic card or software!',
                   '           Wenn doch: Suchen Sie Fehler in Grafikkarte oder Software!',
                   '',
                   '');*)

  sprach_eintrag04('verdeckte_zeile_2',
                   '           it did : press [F8] to restore special textmode ..',
                   '           Wenn doch: Mit [F8] sollte es wieder vernÅnftig aussehen..',
                   '',
                   '');

  sprach_eintrag04('statuszeile__Dateiname_doppelpunkt',
                   ' filename  : ',
                   ' Dateiname : ',
                   '',
                   '');

  sprach_eintrag04('statuszeile__OEffne',
                   ' open ',
                   ' ôffne ',
                   '',
                   '');

  sprach_eintrag04('statuszeile__Anhaengen_an',
                   ' append to ',
                   ' AnhÑngen an ',
                   '',
                   '');

  sprach_eintrag04('Positionierungsfehler_Protokolldatei',
                   'seek error record file',
                   'Positionierungsfehler Protokolldatei',
                   '',
                   '');

  sprach_eintrag04('statuszeile__Schreiben_von',
                   ' write to ',
                   ' Schreiben von ',
                   '',
                   '');

  sprach_eintrag04('Datei_kann_nicht_angelegt_werden',
                   'can not create file ',
                   'Datei kann nicht angelegt werden!',
                   '',
                   '');

  sprach_eintrag04('ausg__Fehler_beim_Schreiben_der_Datei',
                   'error writing file! (',
                   'Fehler beim Schreiben der Datei! (',
                   '',
                   '');

  sprach_eintrag04('ausg__nichts_gefunden',
                   'unknown',
                   'unbekannt',
                   '',
                   '');

  sprach_eintrag04('ausg__suchfolgeeingabe',
                   ' search for : ',
                   ' Suche nach : ',
                   '',
                   '');

  sprach_eintrag04('ausg__suche_punktpunktpunkt',
                   ' searching...',
                   ' suche...',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }
  schreibe_sprach_datei('$$$_ausg.001','$$$_ausg.002','sprach_modul_typ_ausg','sprach_start_typ_ausg','^string');
end.

