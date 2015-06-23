(* 12.10.1996 *)
program vpartdef;

uses spr2_ein;

begin
  sprachtabellenkopf_erweitert(
                     +'EN'
                     +'DE'
                     +''
                     +'',
                     false);

  sprach_eintrag04('sprachwahl',
                   'english',
                   'deutsch',
                   '',
                   '');

  sprach_eintrag04('Gefunden',
                   'found',
                   'Gefunden',
                   '',
                   '');

  sprach_eintrag04('Bootsektor',
                   'boot sector',
                   'Bootsektor',
                   '',
                   '');

  sprach_eintrag04('Bootmanager',
                   'bootman',
                   'Bootmanager',
                   '',
                   '');

  sprach_eintrag04('Auslagerung',
                   'swap',
                   'Auslagerung',
                   '',
                   '');

  sprach_eintrag04('mit_Absicherung',
                   'secured',
                   'mit Absicherung',
                   '',
                   '');

  sprach_eintrag04('unbekanntes_System',
                   'unknown system',
                   'unbekanntes System',
                   '',
                   '');

  sprach_eintrag04('Laufwerk',
                   'drive',
                   'Laufwerk',
                   '',
                   '');

  sprach_eintrag04('Groesse_der_Partition',
                   'partition size',
                   'Grî·e der Partition',
                   '',
                   '');

(*
  sprach_eintrag04('uebergangen_Taste',
                   'ignored ... press a key',
                   'öbergangen ... Taste DrÅcken',
                   '',
                   '');

  sprach_eintrag04('Dies_ist_primaere_FAT_Partition1',
                   'this is the primary FAT partition of your harddisk ( drive C: )',
                   'Dies ist primÑre FAT-Partition der Festplatte ( Laufwerk C: ).',
                   '',
                   '');

  sprach_eintrag04('Dies_ist_primaere_FAT_Partition2',
                   'VPART can run more then one OS from this partition',
                   'VPART kann von dieser Partition mehere System laden:',
                   '',
                   '');

  sprach_eintrag04('Erweitertes_Menue',
                   'extended menu',
                   'Erweitertes MenÅ',
                   '',
                   '');*)

  sprach_eintrag04('den_zur_BOOTZEIT_vorhanden_Bootsektor',
                   'the available bootsektor at BOOTTIME',
                   'den zur STARTZEIT vorhanden Startsektor',
                   '',
                   '');

  (*
  sprach_eintrag04('gar_keins_aufnehmenden',
                   'nothing at all',
                   'gar keins aufnehmenden',
                   '',
                   '');*)

  sprach_eintrag04('j_zeichen',
                   'y',
                   'j',
                   '',
                   '');

  (*
  sprach_eintrag04('Sie_koennen_mehrere_nacheinander_auswaehlen',
                   'You can combine more than one choice',
                   'Sie kînnen mehrere nacheinander auswÑhlen ( z.B.',
                   '',
                   '');

  sprach_eintrag04('Welche_wollen_Sie',
                   'which possibility do you like ?',
                   'Welche wollen Sie ?',
                   '',
                   '');

  sprach_eintrag04('es_sind_noch',
                   ' ( there are still',
                   ' ( Es sind noch',
                   '',
                   '');


  sprach_eintrag04('Plaetze_frei',
                   'slots available',
                   'PlÑtze frei',
                   '',
                   '');

  sprach_eintrag04('Aufnehmen',
                   'pick up ?',
                   'Aufnehmen ?',
                   '',
                   '');*)

  sprach_eintrag04('mit_normalem_Bootsektor',
                   'for "normal" bootsector',
                   'mit "normalem" Bootsektor',
                   '',
                   '');

  sprach_eintrag04('Variante',
                   'variant',
                   'Variante',
                   '',
                   '');

  sprach_eintrag04('Fehleingabe',
                   'incorrect choice ?',
                   'Fehleingabe ?',
                   '',
                   '');

  sprach_eintrag04('Wie_soll_der_Eintrag_lauten',
                   'how should be the name for that entry ?',
                   'Wie soll der Eintrag lauten ?',
                   '',
                   '');

  sprach_eintrag04('Es_sind_Symbole_vorhanden',
                   'these icons are available',
                   'Es sind Symbole vorhanden',
                   '',
                   '');

  sprach_eintrag04('Suchen_Sie_ein_Symbol_aus1',
                   'please, choose one icon :',
                   'Suchen Sie ein Symbol aus :',
                   '',
                   '');

  sprach_eintrag04('Suchen_Sie_ein_Symbol_aus2',
                   'select icon or enter pcx-file (32*32*16) filename',
                   'WÑhlen Sie ein Symbol oder geben Sie eine .PCX-Datei (32*32*16) an',
                   '',
                   '');

  sprach_eintrag04('Bootsektor_muss_beim_Laden_angepasst_werden',
                   'bootsector must adjusted after loading',
                   'Bootsektor mu· beim Laden angepa·t werden.',
                   '',
                   '');

  sprach_eintrag04('Logischer_Laufwerksbuchstabe',
                   'logical drive letter',
                   'Logischer Laufwerksbuchstabe',
                   '',
                   '');

  sprach_eintrag04('Untersuchung',
                   'examine',
                   'Untersuchung',
                   '',
                   '');

  sprach_eintrag04('Erweitert',
                   'extended',
                   'Erweitert',
                   '',
                   '');

  sprach_eintrag04('ist_ungueltig_55aa',
                   'is invalid [55 AA not found] !',
                   'ist ungÅltig [55 AA fehlt] !',
                   '',
                   '');

  sprach_eintrag04('Kann_nicht_gelesen_werden',
                   'can not read',
                   'Kann nicht gelesen werden !',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_002',
                   'file not found',
                   'Datei nicht gefunden.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_003',
                   'path not found',
                   'Pfad nicht gefunden.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_004',
                   'too many open files',
                   'Zu viele Dateien geîffnet.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_005',
                   'file access denied',
                   'Zugriff auf Datei verweigert.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_015',
                   'invalid drive number',
                   'UngÅltiges Laufwerk.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_100',
                   'disk read error',
                   'Lesefehler von Diskette/Platte.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_101',
                   'disk write error',
                   'Schreibfehler auf Diskette/Platte.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_102',
                   'file not assigned',
                   'Dateivariable ist keiner Datei zugeordnet.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_103',
                   'file not open',
                   'Datei nicht geîffnet.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_104',
                   'file not open for input',
                   'Datei nicht fÅr Eingabe geîffnet.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_105',
                   'file not open for output',
                   'Datei nicht fÅr Ausgabe geîffnet.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_106',
                   'invalid numeric format',
                   'UngÅltiges numerisches Format.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_150',
                   'disk is write-protected',
                   'Diskette ist schreibgeschÅtzt.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_151',
                   'bad drive request struct length',
                   'PeripheriegerÑt nicht bekannt/nicht angeschlossen.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_152',
                   'drive not ready',
                   'Laufwerk nicht bereit.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_154',
                   'CRC error in data',
                   'CRC-Fehler in Daten.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_156',
                   'disk seek error',
                   'Seek-Fehler auf Diskette/Platte.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_157',
                   'unknown media type',
                   'Unbekanntes Sektorformat.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_158',
                   'sector not found',
                   'Sektor nicht gefunden.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_159',
                   'printer out of paper',
                   'Drucker hat kein Papier.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_160',
                   'device write fault',
                   'Fehler beim Schreiben auf PeripheriegerÑt.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_161',
                   'device read fault',
                   'Fehler beim Lesen von einem PeripheriegerÑt.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_162',
                   'hardware failure',
                   'Hardware-Fehler.',
                   '',
                   '');

  sprach_eintrag04('dos_fehler_200',
                   'Division by zero',
                   'Division durch Null.',
                   '',
                   '');

  sprach_eintrag04('Fehler',
                   'error',
                   'Fehler',
                   '',
                   '');

  sprach_eintrag04('Einrichtungsprogramm_fuer_Betriebssystemauswahl',
                   'install program for bootmanager',
                   'Einrichtungsprogramm fÅr Betriebssystemauswahl',
                   '',
                   '');

  sprach_eintrag04('Befehl',
                   'command',
                   'Befehl',
                   '',
                   '');

  sprach_eintrag04('Befehle',
                   'commands',
                   'Befehle',
                   '',
                   '');

  sprach_eintrag04('Eingabedatei',
                   'input',
                   'Eingabedatei',
                   '',
                   '');

  sprach_eintrag04('Protokolldatei',
                   'log file',
                   'Protokolldatei',
                   '',
                   '');

  sprach_eintrag04('Installation_Betriebssystemsuche',
                   'installation = search for operating systems',
                   'Installation = Betriebssystemsuche',
                   '',
                   '');

  sprach_eintrag04('Passworteingabe',
                   'password',
                   'Pa·worteingabe',
                   '',
                   '');

  sprach_eintrag04('Standard_System_Hauptspeicher_und_Wartezeit',
                   'select standard system, memory size, wait time, text/graphic mode',
                   'Standard-System, Hauptspeicher, Wartezeit, Text/Grafikmodus',
                   '',
                   '');

  sprach_eintrag04('Programm_entfernen',
                   'unistall program',
                   'Programm entfernen',
                   '',
                   '');

  sprach_eintrag04('TEST_COM_erzeugen_sonst_wie_I',
                   'create TEST.COM ( else like I )',
                   'TEST.COM erzeugen ( sonst wie I )',
                   '',
                   '');

  sprach_eintrag04('Beispiel_',
                   'example: ',
                   'Beispiel: ',
                   '',
                   '');

  sprach_eintrag04('Ist_dieses_System_virenfrei',
                   'is this PC virus-free',
                   'Ist dieses System virenfrei',
                   '',
                   '');

  sprach_eintrag04('Abbruch_auf_Wunsch_des_Benutzers',
                   'abort on user request.',
                   'Abbruch auf Wunsch des Benutzers.',
                   '',
                   '');

  sprach_eintrag04('keine_Fesplatte_vorhanden',
                   'no hard disk available !',
                   'keine Fesplatte vorhanden !',
                   '',
                   '');

  sprach_eintrag04('Lesefehler_Spur_0',
                   'read error: track 0',
                   'Lesefehler Spur 0',
                   '',
                   '');


  sprach_eintrag04('Installation_in_Spur_0_deshalb_nicht_moeglich',
                   'installation in track 0 not possible',
                   'Installation in Spur 0 deshalb nicht mîglich.',
                   '',
                   '');

  sprach_eintrag04('keine_gueltige_Partitionstabelle_erst_Fdisk',
                   'partition table invalid - use fdisk first !',
                   'keine gÅltige Partitionstabelle - erst Fdisk anwenden !',
                   '',
                   '');

  sprach_eintrag04('Absicherung_von_Novell_Dos_7_installiert',
                   'security of Novell Dos 7 installed !',
                   'Absicherung von Novell Dos 7 installiert !',
                   '',
                   '');

  sprach_eintrag04('IDE_Enhancer_ist_aktiv',
                   'IDE-enhancer is active !',
                   'IDE-Enhancer ist aktiv !',
                   '',
                   '');

  sprach_eintrag04('Festplatte',
                   'harddisk',
                   'Festplatte',
                   '',
                   '');

  sprach_eintrag04('mit',
                   'with',
                   'mit',
                   '',
                   '');

  sprach_eintrag04('Sektoren_je_Spur_gefunden',
                   'sectors per track found',
                   'Sektoren je Spur gefunden.',
                   '',
                   '');

  sprach_eintrag04('fuer_Installation_in_Spur_0_sind_mindestens_noetig',
                   'for installation in track 0 minimal needed',
                   'fÅr Installation in Spur 0 sind mindestens nîtig',
                   '',
                   '');

  sprach_eintrag04('Ziel_der_endgueltigen_Installation_von_VPART',
                   'target of final installation of VPART ?',
                   'Ziel der endgÅltigen Installation von VPART ?',
                   '',
                   '');

  sprach_eintrag04('Auswahl_des_Installationsziels',
                   'choice of install target ...',
                   'Auswahl des Installationsziels ...',
                   '',
                   '');

  sprach_eintrag04('Auswahl_des_Konfigurationsziels',
                   'choice of configuration target ...',
                   'Auswahl des Konfigurationsziels ...',
                   '',
                   '');

  sprach_eintrag04('Wo_soll_VPART_deinstalliert_werden',
                   'where should VPART deinstalled ?',
                   'Wo soll VPART deinstalliert werden ?',
                   '',
                   '');

  sprach_eintrag04('in_Spur_0_der_1_Festplatte_und_im_Code_der_Partitionstabelle',
                   'in track 0 of 1. harddisk and in code of the partition table',
                   'in Spur 0 der 1.Festplatte und im Code der Partionstabelle',
                   '',
                   '');

  sprach_eintrag04('schnell',
                   'fast',
                   'schnell',
                   '',
                   '');

  sprach_eintrag04('keine_FAT_Partion_erforderlich',
                   'no FAT-partition needed',
                   'keine FAT-Partion erforderlich',
                   '',
                   '');

  sprach_eintrag04('nicht_auf_Diskette',
                   'not on floppy',
                   'nicht auf Diskette',
                   '',
                   '');

  sprach_eintrag04('Konflikte_mit_IDE_Enhancer_moeglich',
                   'conflicts whith IDE-enhancers possible',
                   'Konflikte mit IDE-Enhancer mîglich',
                   '',
                   '');

  sprach_eintrag04('in_einem_Bootsektor_einer_FAT_Partition_Diskette_oder_Festplatte',
                   'in an bootsector of an FAT-partition or floppy',
                   'in einem Bootsektor einer FAT-Partition ( Diskette oder Festplatte )',
                   '',
                   '');

  sprach_eintrag04('kompatibel_mit_IDE_Enhancern',
                   'compatible with IDE-enhancers',
                   'kompatibel mit IDE-Enhancern',
                   '',
                   '');

  sprach_eintrag04('auch_von_Diskette',
                   'also from floppy',
                   'auch von Diskette',
                   '',
                   '');

  sprach_eintrag04('braucht_ein_paar_Hunderstelsekunden_mehr',
                   'need some little more time',
                   'braucht ein paar Hunderstelsekunden mehr',
                   '',
                   '');

  sprach_eintrag04('FAT_formatierte_Diskette_oder_Fesplatte_erforderlich',
                   'FAT-formated partition or floppy needed',
                   'FAT-formatierte Diskette oder Fesplatte erforderlich',
                   '',
                   '');

  sprach_eintrag04('Die_1_ist_in_der_derzeitigen_Rechnerkonfiguration_nicht_zulaessig',
                   'choiche 1),3) is in your present configuration not available',
                   'Die Auswahl 1),3) ist in der derzeitigen Rechnerkonfiguration nicht zulÑssig.',
                   '',
                   '');

  sprach_eintrag04('Auswahl',
                   'choice',
                   'Auswahl',
                   '',
                   '');

  sprach_eintrag04('Welches_Laufwerk_wuenschen_Sie',
                   'which drive would you like ?',
                   'Welches Laufwerk wÅnschen Sie ?',
                   '',
                   '');

  sprach_eintrag04('erforderlich_FAT_formatiert_nicht_komprimiert',
                   'requied: FAT formated, not compressed',
                   'erforderlich: FAT formatiert, nicht komprimiert',
                   '',
                   '');

  sprach_eintrag04('Startsektor_nicht_lesbar_nicht_formatiert',
                   'can not read bootsector ! ( not formated ? )',
                   'Startsektor nicht lesbar ! ( nicht formatiert ? )',
                   '',
                   '');

  sprach_eintrag04('Unbekannte_Beschaedigte_Datei',
                   'unknown or damaged file',
                   'Unbekannte / BeschÑdigte Datei',
                   '',
                   '');

  sprach_eintrag04('Datei',
                   'file',
                   'Datei',
                   '',
                   '');

  sprach_eintrag04('_nicht_vorhanden',
                   ' does not exist !',
                   ' nicht vorhanden !',
                   '',
                   '');

  sprach_eintrag04('__nicht_vorhanden',
                   ' .. does not exist.',
                   ' .. nicht vorhanden.',
                   '',
                   '');

  sprach_eintrag04('VPART_ist_noch_nicht_nicht_mehr_installiert',
                   'VPART is not/no more installed.',
                   'VPART ist noch nicht / nicht mehr installiert.',
                   '',
                   '');

  sprach_eintrag04('geloescht_',
                   'deleted .',
                   'gelîscht .',
                   '',
                   '');
  sprach_eintrag04('nicht_geloescht_',
                   'not deleted .',
                   'nicht gelîscht .',
                   '',
                   '');

  sprach_eintrag04('Dateiname_des_gesicherten_Bootsektors',
                   'filename for saved bootsector ?',
                   'Dateiname des gesicherten Bootsektors ?',
                   '',
                   '');

  sprach_eintrag04('Dateiname_der_gesicherten_Partitionstabelle',
                   'filename for saved partition table ?',
                   'Dateiname der gesicherten Partitionstabelle ',
                   '',
                   '');

  sprach_eintrag04('Sie_haben_neu_partitionert',
                   'You have changed your partition sizes',
                   'Sie haben neu partitionert',
                   '',
                   '');

  sprach_eintrag04('Sollen_auch_die_alten_Partionsdaten_zurueckgespielt_werden',
                   'Should the partition data also be restored',
                   'Sollen auch die alten Partionsdaten zurÅckgespielt werden',
                   '',
                   '');

  sprach_eintrag04('VPART_wurde_schon_installiert',
                   'VPART alredy installed.',
                   'VPART wurde schon installiert.',
                   '',
                   '');

  sprach_eintrag04('Keine_neue_Sicherung_von_Partitionstabelle_Bootsektor_notwendig',
                   'no additional backup of Partition table / bootsector necessary.',
                   'Keine neue Sicherung von Partitionstabelle/Bootsektor notwendig.',
                   '',
                   '');

  sprach_eintrag04('Bestaetigung_mit',
                   'confirm with ['#17'ƒŸ] ',
                   'BestÑtigung mit ['#17'ƒŸ] ',
                   '',
                   '');

  sprach_eintrag04('VPART_wurde_noch_nicht_installiert',
                   'VPART is not yet installed.',
                   'VPART wurde noch nicht installiert.',
                   '',
                   '');

  (*
  sprach_eintrag04('Die_Sicherung_von_Partitionstabelle_Spur0_ist_empfehlenswert',
                   'Backup of Partition table recommed.',
                   'Die Sicherung von Partitionstabelle/Spur0 ist empfehlenswert.',
                   '',
                   '');

  sprach_eintrag04('Die_Sicherung_des_Bootsektors_ist_empfehlenswert',
                   'Backup of bootsector recommed.',
                   'Die Sicherung des Bootsektors ist empfehlenswert.',
                   '',
                   '');

  sprach_eintrag04('Bitte_waehlen_Sie_einen_Namen',
                   'Please choose an name',
                   'Bitte wÑhlen Sie einen Namen',
                   '',
                   '');*)

  sprach_eintrag04('Name_fuer_die_Sicherung_von_Partitionstabelle_Spur0',
                   'Backup filename of Partition table/track 0 ?',
                   'Dateiname fÅr die Sicherung von Partitionstabelle/Spur0 ?',
                   '',
                   '');

  sprach_eintrag04('Name_fuer_die_Sicherung_des_Startsektors',
                   'Backup filename of bootsector ?',
                   'Dateiname fÅr die Sicherung des Startsektors ?',
                   '',
                   '');

  sprach_eintrag04('nicht_notwendig',
                   'not needed',
                   'nicht notwendig',
                   '',
                   '');

  sprach_eintrag04('_gesichert',
                   ' saved.',
                   ' gesichert.',
                   '',
                   '');

  sprach_eintrag04('Um_eine_Endlosschleife_zu_vermeiden_sollten_Sie_fuer',
                   'To avoid enless loop you should request for',
                   'Um eine Endlosschleife zu vermeiden, sollten Sie fÅr',
                   '',
                   '');

  sprach_eintrag04('das_Laufwerk',
                   'the drive',
                   'das Laufwerk',
                   '',
                   '');

  sprach_eintrag04('das_erweiterte_Menue_mit_der_Taste_anfordern',
                   'the extended menu with key "?" .',
                   'das erweiterte MenÅ mit der Taste "?" anfordern.',
                   '',
                   '');

  sprach_eintrag04('Untersuchung_LW',
                   'examination drive ',
                   'Untersuchung LW',
                   '',
                   '');

  (*
  sprach_eintrag04('Nichts_ausgewaehlt',
                   'nothing selected',
                   'Nichts ausgewÑhlt',
                   '',
                   '');*)

  sprach_eintrag04('Schlafzeit_fuer_Festplatte',
                   'sleep time for harddisk',
                   'Schlafzeit fÅr Festplatte',
                   '',
                   '');

  sprach_eintrag04('in_Minuten',
                   'in minutes',
                   'in Minuten',
                   '',
                   '');

  {sprach_eintrag04('fuer_inaktiv',
                   'for inactive',
                   'fÅr inaktiv',
                   '',
                   '');}
  sprach_eintrag04('fuer_inaktiv',
                   'for no change',
                   'um nichts zu Ñndern',
                   '',
                   '');

  sprach_eintrag04('Schlafzeit',
                   'sleep time',
                   'Schlafzeit',
                   '',
                   '');

  sprach_eintrag04('text_oder_grafikmodus',
                   'Use text or graphic mode',
                   'Text oder Grafikmodus benutzen',
                   '',
                   '');

  sprach_eintrag04('textmodus',
                   'T) Use text mode',
                   'T) Textmodus benutzen',
                   '',
                   '');

  sprach_eintrag04('grafikmodus',
                   'G) Use graphic mode',
                   'G) Grafikmodus benutzen',
                   '',
                   '');

  sprach_eintrag04('Wie_soll_das_Passwort_sein',
                   'How should be the password ?',
                   'Wie soll das Pa·wort sein ?',
                   '',
                   '');

  sprach_eintrag04('fuer_keins_Vorsicht_mit_Umlauten',
                   'just hit ['#17'ƒŸ] for nothing'^m^j'be careful with other keyboard layouts at boot time !',
                   '['#17'ƒŸ] fÅr keins'^m^j'Vorsicht mit Umlauten !',
                   '',
                   '');

  sprach_eintrag04('Passwort',
                   'password',
                   'Pa·wort',
                   '',
                   '');

  sprach_eintrag04('Auswahl_des_Standardsystems',
                   'Choice of default operating system',
                   'Auswahl des Standardsystems',
                   '',
                   '');

  sprach_eintrag04('Wie_viele_Sekunden_soll_VPart_auf_die_Systemauswahl_warten',
                   'How many seconds should VPART wait before the standard take place',
                   'Wie viele Sekunden soll VPart auf die Systemauswahl warten',
                   '',
                   '');

  sprach_eintrag04('Groesse_des_Hauptspeichers',
                   'Size of system memory [KByte] ?',
                   'Grî·e des Hauptspeichers [KByte] ?',
                   '',
                   '');

  sprach_eintrag04('Darf_ich_jetzt',
                   'May i now create ',
                   'Darf ich jetzt ',
                   '',
                   '');

  sprach_eintrag04('erzeugen',
                   ' ?',
                   ' erzeugen ?',
                   '',
                   '');

  sprach_eintrag04('Darf_ich_jetzt_1_Sektor_in_Sektor_1_und',
                   'May i now write 1 sector in sector 1'^m^j'and ',
                   'Darf ich jetzt 1 Sektor in Sektor 1'^m^j'und ',
                   '',
                   '');

  sprach_eintrag04('Darf_ich_jetzt_1_Sektor_in_Sektor_1_und_fp2_und',
                   'May i now write 1 sector in sector 1 (disk 80 and 81)'^m^j'and ',
                   'Darf ich jetzt 1 Sektor in Sektor 1 (Fesplatte 80 und 81)'^m^j'und ',
                   '',
                   '');


  sprach_eintrag04('in_Sektoren',
                   'in sectors ',
                   'in Sektoren ',
                   '',
                   '');

  sprach_eintrag04('bis',
                   'to ',
                   'bis ',
                   '',
                   '');

  sprach_eintrag04('_eintragen',
                   ' ?',  (* bessere Grammatik *)
                   ' eintragen ?',
                   '',
                   '');

  sprach_eintrag04('Darf_ich_jetzt_den_Bootsektor_von_Laufwerk',
                   'May i now write changes to the bootsector of drive ',
                   'Darf ich jetzt den Bootsektor von Laufwerk ',
                   '',
                   '');

  sprach_eintrag04('veraendern',
                   '', (* richtige grammatik *)
                   ' verÑndern',
                   '',
                   '');

  sprach_eintrag04('und_die_Datei',
                   'and write the file ',
                   'und die Datei ',
                   '',
                   '');

  sprach_eintrag04('Darf_ich_jetz_die_Datei',
                   'May i now write changes to file ',
                   'Darf ich jetz die Datei ',
                   '',
                   '');

  sprach_eintrag04('schreiben',
                   ' ?', (* bessere Grammatik *)
                   ' schreiben ?',
                   '',
                   '');

  sprach_eintrag04('Fehler_beim_Schreiben_von',
                   'Error writing ',
                   'Fehler beim Schreiben von ',
                   '',
                   '');

  sprach_eintrag04('Programm_beendet',
                   'Program finished.',
                   'Programm beendet.',
                   '',
                   '');

  sprach_eintrag04('ausprobieren',
                   'can now tested',
                   'ausprobieren',
                   '',
                   '');

  sprach_eintrag04('Partitionstabelle_nicht_beschreibbar',
                   'can not write to partition table',
                   'Partitionstabelle nicht beschreibbar',
                   '',
                   '');

  sprach_eintrag04('Schutzprogramm',
                   'protect program',
                   'Schutzprogramm',
                   '',
                   '');

  sprach_eintrag04('Spur_0_nicht_beschreibbar',
                   'can not write to track 0',
                   'Spur 0 nicht beschreibbar',
                   '',
                   '');

  sprach_eintrag04('entfernt',
                   'removed',
                   'entfernt',
                   '',
                   '');

  sprach_eintrag04('Programm_erfolgreich_beendet',
                   'Program successful finished .. please press [Ctrl]-[Alt]-[Del] now !',
                   'Programm erfolgreich beendet .. bitte [Strg]-[Alt]-[Entf] drÅcken !',
                   '',
                   '');

  sprach_eintrag04('Programm_erfolgreich_beendet_bios_swap',
                   'Program successful finished .. please press [Ctrl]-[Alt]-[Del] now,'#13#10
                  +'then change "Boot Sequence"to "D,A" in "BIOS FEATURES SETUP" !',
                   'Programm erfolgreich beendet .. bitte [Strg]-[Alt]-[Entf] drÅcken,'#13#10
                  +'und dann im "BIOS FEATURES SETUP" "Boot Sequence" auf "D,A" stellen !',
                   '',
                   '');

  sprach_eintrag04('_nicht_lesbar_',
                   '<read error>',
                   '<nicht lesbar>',
                   '',
                   '');

  sprach_eintrag04('Hinweis',
                   'advice :',
                   'Hinweis :',
                   '',
                   '');
{
  sprach_eintrag04('konnte_nicht_lock_dos_taskmgr_1',
                   'found TaskMgr with more then 1 Process !',
                   'TaskMgr mit einem Prozess gefunden !',
                   '',
                   '');

  sprach_eintrag04('konnte_nicht_lock_dos_taskmgr_2',
                   'to let me write to the disk close all other !',
                   'um mir den Schreibzugriff zu ermîglichen bitte alle anderen Prozesse beenden !',
                   '',
                   '');

  sprach_eintrag04('konnte_nicht_lock_dos_os2_1',
                   'for writing i need exclusive access to the drive ! ( NO open files ...)',
                   'Zum Schreiben benîtige ich alleinigen Zugriff ! ( KEINE offene Dateien ... )',
                   '',
                   '');

  sprach_eintrag04('konnte_nicht_lock_dos_os2_2',
                   'please close all other tasks ... ( and no logfile )',
                   'Bitte alle anderen Prozesse abschliessen ... ( und keine Logdatei )',
                   '',
                   '');}

  sprach_eintrag04('weiter_mit_enter',
                   'continue with ['#17'ƒŸ] ',
                   'mit ['#17'ƒŸ] nochmal versuchen ',
                   '',
                   '');

  sprach_eintrag04('sie_muessen_2_waehlen_os2',
                   'under OS/2 only 2) is possible ! ( boot DOS from floppy )',
                   'unter OS/2 ist nur 2) mîglich ! ( DOS von Diskette starten )',
                   '',
                   '');

  sprach_eintrag04('Vertauschen_von_Eintraegen',
                   'swap entries ? (e.g.: "1,3") : ',
                   'Vertauschen von EintrÑgen (z.B.:"1,3") : ',
                   '',
                   '');

  sprach_eintrag04('Bootsektor_nicht_beschreibbar',
                   #7'bootsector write-protected !',
                   #7'Bootsektor nicht beschreibbar !',
                   '',
                   '');

  sprach_eintrag04('versteckt',
                   'Hide VPart ?',
                   'VPart verstecken ?',
                   '',
                   '');

  sprach_eintrag04('versteckt_hilfe',
                   'Should the VPart menu only displayed if you press the [Ctrl]-key during boot ?',
                   'Soll VPart nur erscheinen wenn Sie die [Strg]-Taste gedrÅckt halten ?',
                   '',
                   '');

  sprach_eintrag04('name_der_palette_frage1',
                   'choose colour palette',
                   'Auswahl der Farbpalette',
                   '',
                   '');

  sprach_eintrag04('name_der_palette1',
                   'standard',
                   'Standard',
                   '',
                   '');
  sprach_eintrag04('name_der_palette1_hilfe',
                   'blue..',
                   'Blau..',
                   '',
                   '');

  sprach_eintrag04('name_der_palette2_hilfe',
                   'mixed green',
                   'GrÅne Mischung ( augenschonend ? herzschonend ? )',
                   '',
                   '');

  sprach_eintrag04('selbsdefiniertepalette',
                   'custom palette',
                   'selbstdefiniert',
                   '',
                   '');

  sprach_eintrag04('name_der_palette_frage2',
                   'choose palette colors (read manual)',
                   'Palette (siehe Dokumentation)',
                   '',
                   '');

  sprach_eintrag04('name_der_palette_frage2_hilfe',
                   '13 hexchars (0123456789abcdef) or an filename',
                   '13 Hexadezimalziffern (0123456789abcdef) oder ein Dateiname',
                   '',
                   '');

  sprach_eintrag04('frage_apm',
                   'Use APM 1.2',
                   'APM 1.2 benutzen',
                   '',
                   '');

  sprach_eintrag04('hilfe_apm',
                   'requires APM 1.2 BIOS'^m^j
                  +'Display battery bar and enable CPU-sleep.',
                   'Erfordert APM 1.2 BIOS'^m^j
                  +'Anzeige eines Batteriebalkens und Bremsen der CPU',
                   '',
                   '');

  (*
  sprach_eintrag04('Titel_ist_zu_lang1',
                   'entry to long (',
                   'Der Eintrag ist zu lang (',
                   '',
                   '');

  sprach_eintrag04('Titel_ist_zu_lang2',
                   ' chars maximum).',
                   ' Zeichen maximal).',
                   '',
                   '');*)

  sprach_eintrag04('sekt__frei',
                   'unused',
                   'frei',
                   '',
                   '');

  sprach_eintrag04('sekt__erweitert',
                   'extended...',
                   'erweitert...',
                   '',
                   '');

  sprach_eintrag04('sekt__versteckt',
                   'hidden ',
                   'versteckt ',
                   '',
                   '');

  sprach_eintrag04('sekt__Auslagerung',
                   'swap',
                   'Auslagerung',
                   '',
                   '');

  sprach_eintrag04('sekt__sekundaer',
                   'secondary',
                   'sekundÑr',
                   '',
                   '');

  sprach_eintrag04('unbekanntes_System_Nr',
                   'unknown system nr. ',
                   'unbekanntes System Nr. ',
                   '',
                   '');

  sprach_eintrag04('award_swap',
                   'like 1) but also on second hard disk (AWARD D/A drive swap)',
                   'wie 1) aber auch auf der 2. Festplatte (AWARD D/A Laufwerkstausch)',
                   '',
                   '');

  sprach_eintrag04('award_swap_hilfe_lesen',
                   '    + survives many os installs'
                    +^m^j'      do not select before reading the documentation !',
                   '    + öberlebt viele Betriebssysteminstallationen'
                   +^m^j'      vor Benutzung unbedingt die Dokumentation lesen !',
                   '',
                   '');

  sprach_eintrag04('award_tauscher_variable',
                   'Where is the BIOS drive order stored ?',
                   'Wo speichert das BIOS die Laufwerksreihenfolge ?',
                   '',
                   '');
  sprach_eintrag04('award_tauscher_variable_hilfe',
                   '* ASUS:     $04e5'^m^j'* Gigabyte: $04b5',
                   '* ASUS:     $04e5'^m^j'* Gigabyte: $04b5',
                   '',
                   '');

  sprach_eintrag04('warnung_offene_dateien',
                   'there may not be files open on the drive !',
                   'es dÅrfen jetzt keine Dateien auf dem Laufwerk offen sein !',
                   '',
                   '');

  sprach_eintrag04('ungueltiger_bootsektor_auf_laufwerk_',
                   'invalid bootsector on drive ',
                   'ungueltiger Bootsektor auf Laufwerk ',
                   '',
                   '');
  sprach_eintrag04('ja_normal',
                   'yes',
                   'ja',
                   '',
                   '');
  sprach_eintrag04('ja_aktiv',
                   'Y^e^s^',
                   'J^a^',
                   '',
                   '');
  sprach_eintrag04('nein_normal',
                   'no',
                   'nein',
                   '',
                   '');
  sprach_eintrag04('nein_aktiv',
                   'N^o^',
                   'N^e^i^n^',
                   '',
                   '');

  sprach_eintrag04('keine_partitionen_gefunden',
                   #7'No partitions or floppys found.',
                   #7'Keine Partitionen oder Diskettenlaufwerke gefunden.',
                   '',
                   '');

  sprach_eintrag04('hinweis_versteckte_partitionen_frage',
                   'You should make all hidden partitions visible'^m^j
                   +'before installing VPart',
                   'Sie sollten die versteckten Partitionen vor der'^m^j
                  +'Installation von VPart wieder sichtbar machen !',
                   '',
                   '');

  sprach_eintrag04('hinweis_versteckte_partitionen_hilfe',
                   'In contrast with other programs,'#13#10'VPart never changes partition type.',
                   'Im Gegensatz zu anderen Programmen'#13#10'Ñndert VPart niemals den Partitionstyp.',
                   '',
                   '');

  sprach_eintrag04('kein_weiterer_Eintrag',
                   'nothing else',
                   'kein weiterer Eintrag',
                   '',
                   '');

  sprach_eintrag04('Diskette_',
                   'floppy   ',
                   'Diskette ',
                   '',
                   '');

  sprach_eintrag04('CDROM_',
                   'CD-ROM   ',
                   'CD-ROM   ',
                   '',
                   '');

  sprach_eintrag04('Primaer_',
                   'primary  ',
                   'PrimÑr   ',
                   '',
                   '');

  sprach_eintrag04('logisch_',
                   'logical  ',
                   'logisch  ',
                   '',
                   '');

  sprach_eintrag04('Partitionstyp',
                   'partition type',
                   'Partitionstyp',
                   '',
                   '');


  sprach_eintrag04('Festplatte__',
                   'hard disk $',
                   'Festplatte $',
                   '',
                   '');

  sprach_eintrag04('Zylinder_',
                   'cylinder ',
                   'Zylinder ',
                   '',
                   '');

  sprach_eintrag04('_bis_',
                   ' to ',
                   ' bis ',
                   '',
                   '');

  sprach_eintrag04('vermutete_Laufwerksbuchstaben',
                   'supposed drive letters',
                   'vermutete Laufwerksbuchstaben',
                   '',
                   '');

  sprach_eintrag04('IBM_Bootmanager_Name',
                   'IBM Bootmanager name',
                   'IBM Bootmanager Name',
                   '',
                   '');

  sprach_eintrag04('_Datentraegername__',
                   ' volume label: ',
                   ' DatentrÑgername: ',
                   '',
                   '');

  sprach_eintrag04('bitte_waehlen_sie_Eintrag_',
                   'Please choose entry ',
                   'Bitte wÑhlen sie Eintrag ',
                   '',
                   '');

  sprach_eintrag04('_von_',
                   ' of ',
                   ' von ',
                   '',
                   '');

  sprach_eintrag04('der_im_menue_erscheinen_soll',
                   ^m^j'that should placed into VPart menu',
                   ^m^j'der im VPart-MenÅ erscheinen soll',
                   '',
                   '');

  sprach_eintrag04('Eintrag_',
                   'Entry ',
                   'Eintrag ',
                   '',
                   '');

  sprach_eintrag04('__Startsektor________________',
                   '  bootsector               : ',
                   '  Startsektor              : ',
                   '',
                   '');

  sprach_eintrag04('anderen_Startsektor_frage',
                   'Select bootsector code to execute',
                   'WÑhlen Sie den auszufÅhrenden Startsektor',
                   '',
                   '');

  sprach_eintrag04('__Name_______________________',
                   '  name                     : ',
                   '  Name                     : ',
                   '',
                   '');

  sprach_eintrag04('__Logo_______________________',
                   '  icon                     : ',
                   '  Logo                     : ',
                   '',
                   '');

  sprach_eintrag04('mitgeliefertes_Logo__Bitte_sehen_sie_sich_icon_gal_png_an',
                   'Build-in icon. Please look at icon_gal.png.',
                   'mitgeliefertes Logo, Bitte sehen sie sich icon_gal.png an.',
                   '',
                   '');

  sprach_eintrag04('PCX_Logo_importieren',
                   'import icon from PCX file',
                   'PCX-Logo importieren',
                   '',
                   '');

  sprach_eintrag04('PCX_Logo_importieren_hilfe',
                   'file should be 32*32 16 colour PCX',
                   'Importieren eines 32*32*16 Logos im PCX-Format',
                   '',
                   '');


  sprach_eintrag04('PCX_Logo_dateiname_frage',
                   'Please enter filename of icon ...',
                   'Dateiname des PCX-Logos ?',
                   '',
                   '');

  sprach_eintrag04('__Laufwerksbuchstabe_________',
                   '  drive letter             : ',
                   '  Laufwerksbuchstabe       : ',
                   '',
                   '');

  sprach_eintrag04('frage_maustreiber',
                   'Use BIOS mouse driver ?',
                   'BIOS-Maustreiber benutzen ?',
                   '',
                   '');

  sprach_eintrag04('hilfe_maustreiber',
                   'useful for Notebook with build in mouse/touchpad',
                   'nÅtzlich fÅr tragbaren Rechner mit eingebauter Maus/Tastfeld',
                   '',
                   '');

  sprach_eintrag04('frage_a20_abschalten',
                   'Disable adress line A20 ?',
                   'Adressleitung A20 abschalten ?',
                   '',
                   '');

  sprach_eintrag04('hilfe_a20_abschalten',
                   'Some defect BIOS do no disable A20 address bus line'^m^j
                  +'This gives error messages like from DR DOS himem.sys.',
                   'Es gibt Rechner mit fehlerhaftem BIOS die die A20-Adressleitung nicht'^m^j
                  +'abschalten. Dies fÅhrt zum Beispiel zu Fehlfunktionen von DR DOS himem.sys.',
                   '',
                   '');



  sprach_eintrag04('vermutete_Laufwerksbuchstaben_',
                   'suppoesed drive letter:',
                   'vermutete Laufwerksbuchstaben:',
                   '',
                   '');

  sprach_eintrag04('Waehlen_Sie_den_zu_verwendenden_Laufwerksbuchstaben',
                   'Choose drive letter to be used',
                   'WÑhlen Sie den zu verwendenden Laufwerksbuchstaben',
                   '',
                   '');

  sprach_eintrag04('_Tastedruecke________________',
                   '  key presses              : ',
                   '  TastedrÅcke              : ',
                   '',
                   '');

  sprach_eintrag04('frage_tastendruecke1',
                   'should keypresses inserted into keyboard buffer ?',
                   'Sollen Tastenfolgen in den Tastaturpuffer'^m^j'geschreiben werden ?',
                   '',
                   '');

  sprach_eintrag04('hilfe_tastendruecke1',
                   'you can record keys to automaticly choose from menus',
                   'Es kînnen Tastenfolgen aufgezeichnet werden, um bestimmte MenÅs'^m^j'automatisch auszuwÑhlen',
                   '',
                   '');

  sprach_eintrag04('Tastenaufzeichnung',
                   'key recording',
                   'Tastenaufzeichnung',
                   '',
                   '');

  sprach_eintrag04('bis_zu_8_Tasten_zum_Ende_Alt_NUM_1',
                   'up to 8 keys, use [Alt][NUM-1] to continue',
                   'bis zu 8 Tasten, zum Ende [Alt][NUM-1]',
                   '',
                   '');

  sprach_eintrag04('Schreibfehler',
                   'write error',
                   'Schreibfehler',
                   '',
                   '');

  sprach_eintrag04('Antivirenprogramm_entfernen_Schreibschutzschieber_bewegen',
                   '* unload virus monitors'^m^j'* move write protection tab',
                   '* Antivirenprogramm entfernen'^m^j'* Schreibschutzschieber bewegen',
                   '',
                   '');

  sprach_eintrag04('im_Taskmgr_sind_noch_mehrere_Prozesse_geladen',
                   'there are more than one process loaded under Taskmgr.',
                   'im Taskmgr sind noch mehrere Prozesse geladen.',
                   '',
                   '');

  sprach_eintrag04('alle_anderen_Prozesse_beenden',
                   'exit all other processes',
                   'alle anderen Prozesse beenden',
                   '',
                   '');

  sprach_eintrag04('kein_ausschliesslicher_Zugriff_auf_das_Laufwerk_moeglich',
                   'no exclusive access to drive allowed',
                   'kein ausschlie·licher Zugriff auf das Laufwerk mîglich',
                   '',
                   '');

  sprach_eintrag04('alle_offenen_Dateien_schliessen',
                   'close all open files',
                   'alle offenen Dateien schlie·en',
                   '',
                   '');


  sprach_eintrag04('Wiederholen',
                   'Retry',
                   'Wiederholen',
                   '',
                   '');

  sprach_eintrag04('Abbruch',
                   'Abort',
                   'Abbruch',
                   '',
                   '');

  sprach_eintrag04('komandozeile',
                   'command line',
                   'Befehlsebene',
                   '',
                   '');

  sprach_eintrag04('Wiederholen_taste',
                   'R',
                   'W',
                   '',
                   '');

  sprach_eintrag04('Abbruch_taste',
                   'A',
                   'A',
                   '',
                   '');

  sprach_eintrag04('komandozeile_taste',
                   'C',
                   'B',
                   '',
                   '');

  sprach_eintrag04('I_Installation',
                   'I Install',
                   'I Installation',
                   '',
                   '');

  sprach_eintrag04('I_Installation_hilfe',
                   'begin with install',
                   'mit der Installation von VPart anfangen',
                   '',
                   '');

  sprach_eintrag04('T_Testprogramm',
                   'T testprogram',
                   'T Testprogramm',
                   '',
                   '');

  sprach_eintrag04('T_Testprogramm_hilfe',
                   'create testprogram',
                   'Testprogramm erzeugen',
                   '',
                   '');

  sprach_eintrag04('U_VPart_entfernen',
                   'U remove VPart',
                   'U VPart entfernen',
                   '',
                   '');


  sprach_eintrag04('U_VPart_entfernen_hilfe',
                   'restore mbr/boot sector',
                   'alten Zustand wiederherstellen',
                   '',
                   '');

  sprach_eintrag04('P_Passwort',
                   'P password',
                   'P Pa·wort',
                   '',
                   '');

  sprach_eintrag04('P_Passwort_hilfe',
                   'changes password',
                   'schnelle Pa·wortÑnderung',
                   '',
                   '');

  sprach_eintrag04('A_Schnellkonfiguration',
                   'A fast reconfigure',
                   'A Schnellkonfiguration',
                   '',
                   '');

  sprach_eintrag04('A_Schnellkonfiguration_hilfe',
                   'quick changes of installed vpart',
                   'Standardbetriebssystem.. schnell Ñndern',
                   '',
                   '');

  sprach_eintrag04('f_Komandozeilenhilfe',
                   '? command line help',
                   '? Komandozeilenhilfe',
                   '',
                   '');

  sprach_eintrag04('f_Komandozeilenhilfe_hilfe',
                   'show command line usage',
                   'Aufrufsyntax anzeigen',
                   '',
                   '');

  sprach_eintrag04('Was_wuenschen_Sie',
                   'What is your desire ?',
                   'Was wÅnschen Sie ?',
                   '',
                   '');


  sprach_eintrag04('weiter_mit_Tastendruck',
                   'press a key to continue',
                   'weiter mit Tastendruck',
                   '',
                   '');

  sprach_eintrag04('Abspeichern_der_Auswahl___',
                   'Save choice ? ',
                   'Abspeichern der Auswahl ? ',
                   '',
                   '');

  sprach_eintrag04('gewaehltes_Betriebssystem_nicht_merken',
                   'do not remember last select OS',
                   'gewÑhltes Betriebssystem nicht merken',
                   '',
                   '');

  sprach_eintrag04('im_CMOS_speichern',
                   'save selected OS in CMOS',
                   'im CMOS speichern',
                   '',
                   '');

  sprach_eintrag04('im_CMOS_speichern_frage',
                   'May i "misuse" the CMOS to store selected OS'^m^j'for next boot default ?',
                   'Soll das jeweils gewÑhlte Betriebssystem'^m^j'als Standardwert gespeichert werden ?',
                   '',
                   '');

  sprach_eintrag04('nicht_programmieren',
                   'do not program',
                   'nicht programmieren',
                   '',
                   '');

  sprach_eintrag04('Tastenverzoegerung__',
                   'Keyboard delay ?',
                   'Tastenverzîgerung ?',
                   '',
                   '');

  sprach_eintrag04('_Zeichen_je_Sekunde',
                   ' chars/second',
                   ' Zeichen je Sekunde',
                   '',
                   '');

  sprach_eintrag04('Tastenwiederholrate__',
                   'Keyboard repeat',
                   'Tastenwiederholrate ?',
                   '',
                   '');

  sprach_eintrag04('jetztiger_Wert',
                   'current value',
                   'jetztiger Wert',
                   '',
                   '');

  sprach_eintrag04('Speicherhilfe_639',
                   '1 KB used (viruses,PS/2-mouse,..)',
                   '1 KB fehlt (Viren,PS/2-Maus,..)',
                   '',
                   '');

  sprach_eintrag04('Speicherhilfe_640',
                   'default case',
                   'Normalfall',
                   '',
                   '');

  sprach_eintrag04('Speicherhilfe_999',
                   'no memory check for viruses',
                   'keine PrÅfung auf Speicherbelegung durch Viren',
                   '',
                   '');

  sprach_eintrag04('Speicherhilfe_AAA',
                   'enter other value',
                   'anderen Wert eingeben',
                   '',
                   '');

  sprach_eintrag04('ignorieren',
                   'ignore',
                   'ignorieren',
                   '',
                   '');

  sprach_eintrag04('anderer_Wert',
                   'other value',
                   'anderer Wert',
                   '',
                   '');

  sprach_eintrag04('Schreibe_SETBOOTC_CFG____',
                   'Writing SETBOOTC.CFG .. ',
                   'Schreibe SETBOOTC.CFG .. ',
                   '',
                   '');

  sprach_eintrag04('Schreibe_SETBOOTF_CFG____',
                   'Writing SETBOOTF.CFG .. ',
                   'Schreibe SETBOOTF.CFG .. ',
                   '',
                   '');

  sprach_eintrag04('gelungen_',
                   'successful.',
                   'gelungen.',
                   '',
                   '');


  sprach_eintrag04('fehlgeschlagen_',
                   'failed.',
                   'fehlgeschlagen.',
                   '',
                   '');

  sprach_eintrag04('Tastaturprogrammierung',
                   'keyboard delay/repeat : ',
                   'Tastaturprogrammierung : ',
                   '',
                   '');

  sprach_eintrag04('Weiter',
                   'Continue',
                   'Weiter',
                   '',
                   '');

  sprach_eintrag04('Verwende_Quelle__',
                   'Using source "',
                   'Verwende Quelle "',
                   '',
                   '');

  sprach_eintrag04('Verwende_Logdatei__',
                   'Using logfile "',
                   'Verwende Logdatei "',
                   '',
                   '');

  sprach_eintrag04('datei_auf_diskettenlaufwerk',
                   'In a file on floppy ',
                   'In einer Datei auf Diskette ',
                   '',
                   '');

  sprach_eintrag04('gespeichert_in_datei',
                   'Saved to file ',
                   'Gespeichert als Datei ',
                   '',
                   '');

  sprach_eintrag04('datei_auf_FAT_partition',
                   'In a file on a FAT partition',
                   'In einer Datei auf einer FAT-Partition',
                   '',
                   '');

  sprach_eintrag04('frage_blenden',
                   'Speed of palette dim during screen switch ?',
                   'Geschwindigkeit des Ein- und Ausblendens'^m^j'beim Umschalten des Bildschirmes ?',
                   '',
                   '');

  sprach_eintrag04('frage_blenden_kurz',
                   'Speed of palette dim during screen switch ?',
                   'Geschwindigkeit des Ein- und Ausblendens ?',
                   '',
                   '');

  sprach_eintrag04('blenden1',
                   'fast',
                   'schnell',
                   '',
                   '');

  sprach_eintrag04('hilfe_blenden1',
                   'no delay',
                   'keine Verzîgerung',
                   '',
                   '');

  sprach_eintrag04('blenden2',
                   'normal',
                   'normal',
                   '',
                   '');

  sprach_eintrag04('hilfe_blenden2',
                   'for fast screens',
                   'fÅr schnelle Bildschirme',
                   '',
                   '');

  sprach_eintrag04('blenden3',
                   'slow',
                   'langsam',
                   '',
                   '');

  sprach_eintrag04('hilfe_blenden3',
                   'for awkward monitors',
                   'fÅr schwerfÑllige Bildschirme',
                   '',
                   '');

  sprach_eintrag04('zum_erzugen_von_vpart_cfg_setbootf_benutzen',
                   'To create the config file VPART.CFG you shold use the SETBOOTF program.',
                   'Zum Erzeugen der Konfigurationsdatei VPART.CFG kînnen Sie SETBOOTF benutzen.',
                   '',
                   '');


  sprach_eintrag04('Verstecken_von_Partitionen',
                   'Support hiding of partitions ?',
                   'Verstecken von Partitionen ermîglichen ?',
                   '',
                   '');

  sprach_eintrag04('Soll_sich_VPart_am_Verstecken_von_Partitionen_beteiligen__',
                   'Would you like to configure hiding of partitions ?',
                   'Soll sich VPart am Verstecken von Partitionen beteiligen ?',
                   '',
                   '');

  sprach_eintrag04('verstecken_hilfe',
                   'Please choose only if your have read the documentation and need it',
                   'Benutzen Sie diese Funktion nur, wenn Sie die Dokumentation gelesen haben'^m^j
                  +'und diese Funktion wirklich benîtigen',
                   '',
                   '');

  sprach_eintrag04('Die_Auswahl_stimmt_so',
                   'The selection is complete',
                   'Die Auswahl stimmt so',
                   '',
                   '');

  sprach_eintrag04('Waehlen_Sie_bis_zu_8_versteckbare_Partitionen',
                   'Select up to 8 partition that are candidates for hiding',
                   'WÑhlen Sie bis zu 8 versteckbare Partitionen',
                   '',
                   '');

  sprach_eintrag04('frage_Verstecken_Typ1',
                   '  Hide/',
                   '  Verstecken/',
                   '',
                   '');

  sprach_eintrag04('frage_Verstecken_Typ2',
                   '/ID                :',
                   '/Typ         :',
                   '',
                   '');

  sprach_eintrag04('frage_Verstecken_LVM2',
                   '/LVM               :',
                   '/LVM         :',
                   '',
                   '');


  sprach_eintrag04('menue__verstecken',
                   ' = hide',
                   ' = verstecken',
                   '',
                   '');

  sprach_eintrag04('menue__unveraendert_lassen',
                   '     no change',
                   '     unverÑndert lassen',
                   '',
                   '');

  sprach_eintrag04('menue__sichtbar_machen',
                   ' = make visible',
                   ' = sichtbar machen',
                   '',
                   '');

  sprach_eintrag04('menue_Verstecken_der_Partition_der_Partition_beim_Start_',
                   'Hide partition by changing filesystem type number',
                   'Verstecken der Partition der Partition beim Start'^m^j
                  +'durch éndern des Partitionstypes',
                   '',
                   '');


  sprach_eintrag04('versteckt_01',
                   'hidden',
                   'versteckt',
                   '',
                   '');

  sprach_eintrag04('unveraendert',
                   'unchanged',
                   'unverÑndert',
                   '',
                   '');

  sprach_eintrag04('sichtbar',
                   'visible',
                   'sichtbar',
                   '',
                   '');

  sprach_eintrag04('keine_AEnderung_des_LVM_Buchstabens',
                   'no change of LVM volume letter',
                   'keine énderung des LVM-Buchstabens',
                   '',
                   '');

  sprach_eintrag04('Laufwerk_nicht_sichtbar',
                   'volume not visible',
                   'Laufwerk nicht sichtbar',
                   '',
                   '');

  sprach_eintrag04('Buchstabe_zz_festlegen1',
                   'select volume letter ',
                   'Buchstabe ',
                   '',
                   '');

  sprach_eintrag04('Buchstabe_zz_festlegen2',
                   '',
                   ' festlegen',
                   '',
                   '');

  sprach_eintrag04('frage_verstekcen_lvm',
                   'Hide volume or change drive letter'^m^j
                  +'by changing LVM volume letter entry',
                   'Verstecken der Partition der Partition beim Start'^m^j
                  +'durch éndern des LVM-Laufwerksbuchstabens',
                   '',
                   '');

  sprach_eintrag04('kein_Buchstabe',
                   'no drive letter',
                   'kein Buchstabe',
                   '',
                   '');

{ sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');}

  (*schreibe_sprach_datei({ParamStr(1)+}'VPARTEIN.SPR','VPART$$$.002','sprach_modul','sprach_start','^string');*)
  schreibe_sprach_datei('VPART$$$.001','VPART$$$.002','sprach_modul','sprach_start','^string');
end.

