program typsprache_def_typ;
(* V.K. 19.11.1996 *)

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  (* aus TYP.PAS *)
  sprach_eintrag04('Laufzeitfehler_Alles_notieren',
                   ' ≥ runtime error! please note all!      ≥',
                   ' ≥ Laufzeitfehler! Alles notieren!      ≥',
                   '',
                   '');

  sprach_eintrag04('Weiter_mit_enter',
                   ' ≥ press [<ƒŸ]!                         ≥',
                   ' ≥ Weiter mit [<ƒŸ]!                    ≥',
                   '',
                   '');

  sprach_eintrag04('typ__Dateiname',
                   ' filename="',
                   ' Dateiname="',
                   '',
                   '');

  sprach_eintrag04('Archivbetrug_von',
                   'archiver deceit from',
                   'Archivbetrug von ',
                   '',
                   '');

  sprach_eintrag04('Fehler',
                   'error',
                   'Fehler',
                   '',
                   '');

  sprach_eintrag04('beim_Bestimmen_von_Datum_und_Zeit',
                   'determinging date and time!',
                   'beim Bestimmen von Datum und Zeit!',
                   '',
                   '');

  sprach_eintrag04('Bereichsueberschreitung',
                   'range error',
                   'BereichsÅberschreitung',
                   '',
                   '');

  sprach_eintrag04('Jahr4',
                   'year',
                   'Jahr',
                   '',
                   '');

  sprach_eintrag04('Monat5',
                   'month',
                   'Monat',
                   '',
                   '');

  sprach_eintrag04('Tag3',
                   'day',
                   'Tag',
                   '',
                   '');

  sprach_eintrag04('Stunde5',
                   'hour ',
                   'Stunde',
                   '',
                   '');

  sprach_eintrag04('Minute6',
                   'minute',
                   'Minute',
                   '',
                   '');

  sprach_eintrag04('Sekunde7',
                   'second',
                   'Sekunde',
                   '',
                   '');

  sprach_eintrag04('Dateidatum_aktuelles_Datum',
                   'filedate > actual date',
                   'Dateidatum > aktuelles Datum',
                   '',
                   '');

  sprach_eintrag04('verdrehter_EXE_Kopf',
                   'swaped exe-header ("ZM")!!',
                   'verdrehter EXE - Kopf  ("ZM")!!',
                   '',
                   '');

  sprach_eintrag04('kein_gueltiges_Programm',
                   'not valid program',
                   'kein gÅltiges Programm',
                   '',
                   '');

  sprach_eintrag04('Sprung_ins_PSP',
                   'jump to psp!!',
                   'Sprung ins PSP!!',
                   '',
                   '');

  sprach_eintrag04('umgewandelte_COM_Datei',
                   'transformed .COM-file',
                   'umgewandelte .COM-Datei',
                   '',
                   '');

  sprach_eintrag04('unbekannter_Konverter',
                   ', unknown converter',
                   ', unbekannter Konverter ¯',
                   '',
                   '');

  sprach_eintrag04('Kopftext',
                   'Head Text:',
                   'Kopftext:',
                   '',
                   '');

  sprach_eintrag04('0_relozierbare_Adressen',
                   '0 relocation items',
                   '0 relozierbare Adressen',
                   '',
                   '');

  sprach_eintrag04('1_relozierbare_Adresse',
                   '1 relocation item',
                   '1 relozierbare Adresse',
                   '',
                   '');

  sprach_eintrag04('UEberhang_ab',
                   'hang over at ',
                   'öberhang ab ',
                   '',
                   '');

  sprach_eintrag04('um',
                   ' length: ',
                   ' um ',
                   '',
                   '');

  sprach_eintrag04('Bruchstueck_um',
                   'fragment by',
                   'BruchstÅck um ',
                   '',
                   '');

  sprach_eintrag04('Fehler_in_der_Kopfstruktur',
                   'error in header structure',
                   'Fehler in der Kopfstruktur!',
                   '',
                   '');

  sprach_eintrag04('Fehler_bei_Berechnung_der_Dateilaenge',
                   'error calulating filelength',
                   'Fehler bei Berechnung der DateilÑnge!',
                   '',
                   '');

  sprach_eintrag04('Verzeichnisverschachtelung_zu_tief_uebergangen',
                   'directory recursion to deep .. ignored',
                   'Verzeichnisverschachtelung zu tief ... Åbergangen',
                   '',
                   '');

  sprach_eintrag04('Datentraegername',
                   'volume label',
                   'DatentrÑgername',
                   '',
                   '');

  sprach_eintrag04('typ__erzeugt_am',
                   ' created on ',
                   ' erzeugt ',
                   '',
                   '');

  sprach_eintrag04('Programm_erfordert_XX_DOS_3',
                   'program requires XX-DOS >= 3!',
                   'Programm erfordert XX-DOS >= 3!',
                   '',
                   '');

  sprach_eintrag04('kein_EGA_gefunden_Schalte_zu_CGA',
                   'EGA not found - switch to CGA',
                   'kein EGA+ gefunden - Schalte zu CGA',
                   '',
                   '');

  sprach_eintrag04('Wie_soll_ich_bei_VGA',
                   'How should this program with VGA have ',
                   'Wie soll ich bei VGA ',
                   '',
                   '');

  sprach_eintrag04('Zeilen_auf_den_Bildschirm_bekommen',
                   ' lines on the screen?',
                   ' Zeilen auf den Bildschirm bekommen?',
                   '',
                   '');

  sprach_eintrag04('Wie_soll_ich_bei_EGA',
                   'How should this program with EGA have ',
                   'Wie soll ich bei EGA ',
                   '',
                   '');

  sprach_eintrag04('VMODE_EGA',
                   ' ( VMODE EGA! )',
                   ' ( VMODE EGA! )',
                   '',
                   '');

  sprach_eintrag04('Zu_wenig_Hauptspeicher_verfuegbar',
                   'to few main memory available!'#13#10
                  +'Use /ba,/be or /bf to disable line saving'#13#10
                  +'or use XMS/EMS with "/x:2000 /e:2000"!',
                   'Zu wenig Hauptspeicher verfÅgbar!'#13#10
                  +'Schalten Sie die Zeilenspeicherung mit /ba,/be oder /bf ab '#13#10
                  +'oder benutzen Sie XMS/EMS-Speicher mit "/x:2000 /e:2000"!',
                   '',
                   '');

  sprach_eintrag04('Fehler_beim_OEffnen_der_Listdatei',
                   'error opening list-file: ',
                   'Fehler beim ôffnen der Listdatei: ',
                   '',
                   '');

  sprach_eintrag04('Lesefehler_Listdatei',
                   'error reading list-file: ',
                   'Lesefehler Listdatei: ',
                   '',
                   '');

  sprach_eintrag04('Startsektor_Laufwerk',
                   '[boot sector drive ',
                   '[Startsektor Laufwerk ',
                   '',
                   '');

  sprach_eintrag04('physikalisch',
                   ': physical]',
                   ': physikalisch]',
                   '',
                   '');

  sprach_eintrag04('logisch',
                   ': logical]',
                   ': logisch]',
                   '',
                   '');

  sprach_eintrag04('nicht_lesbar',
                   'not readable',
                   'nicht lesbar',
                   '',
                   '');

  sprach_eintrag04('Dateien_doppelpunkt',
                   '[files:',
                   '[Dateien:',
                   '',
                   '');

  sprach_eintrag04('Alles_geschafft',
                   '±≤±≤  all done  ±≤±≤±',
                   '±  Alles geschafft  ±',
                   '',
                   '');

  sprach_eintrag04('typ__negative_Pruefsumme',
                   'negative checksum=',
                   'negative PrÅfsumme=',
                   '',
                   '');

  sprach_eintrag04('typ__leeres_programm',
                   'empty program',
                   'leeres Programm',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }
  schreibe_sprach_datei('$$$_typ.001','$$$_typ.002','sprach_modul_typ','sprach_start_typ','^string');
end.
