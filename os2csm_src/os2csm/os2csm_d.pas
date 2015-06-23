program os2csm_d;

uses spr2_ein;

begin
  sprachtabellenkopf(
                    +'EN'
                    +'DE'
                    +''
                    +'');

  (* os2csm *)
  sprach_eintrag04('I_nstallation___',
                   'I)nstall:       ',
                   'I)nstallation:  ',
                   '',
                   '');

  sprach_eintrag04('_aus_',
                   ' from ',
                   ' aus ',
                   '',
                   '');

  sprach_eintrag04('A_ussetzen______Entfernen_aus_',
                   'S)uspend:       remove from ',
                   'A)ussetzen:     Entfernen aus ',
                   '',
                   '');

  sprach_eintrag04('________________aber_Sicherung_als_',
                   '                but make backup to ',
                   '                aber Sicherung als ',
                   '',
                   '');

  sprach_eintrag04('F_ortsetzen_____Schreiben_von_',
                   'C)ontinue:      Write ',
                   'F)ortsetzen:    Schreiben von ',
                   '',
                   '');

  sprach_eintrag04('________________aus_der_Sicherung_',
                   '                from backup ',
                   '                aus der Sicherung ',
                   '',
                   '');

  sprach_eintrag04('M_emdisk________',
                   'M)emDisk:       Only create os2csm.bin module for MemDisk.',
                   'M)emDisk:       Nur das os2csm.bin-Modul fÅr MemDisk erzeugen.',
                   '',
                   '');


  sprach_eintrag04('Verzeichnis_von_',
                   'Direectory of ',
                   'Verzeichnis von ',
                   '',
                   '');

  (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)

  (* conf512 *)

  sprach_eintrag04('Zeile_zu_lang_',
                   'line to long: ',
                   'Zeile zu lang: ',
                   '',
                   '');

  sprach_eintrag04('sektoren',
                   ' sectors',
                   ' Sektoren',
                   '',
                   '');

  sprach_eintrag04('Syntaxfehler_in_Spalte_',
                   'Syntaxerror in column ',
                   'Syntaxfehler in Spalte ',
                   '',
                   '');

  sprach_eintrag04('_anf_erwartet_',
                   ' ''"'' expected.',
                   ' ''"'' erwartet.',
                   '',
                   '');

  sprach_eintrag04('_doppelpunkt_erwartet_',
                   ' '':'' expected.',
                   ' '':'' erwartet.',
                   '',
                   '');

  sprach_eintrag04('_doppelpunkt_oder_komma_erwartet_',
                   ' '':'' or '','' expected.',
                   ' '':'' oder '','' erwartet.',
                   '',
                   '');

  sprach_eintrag04('_dach_erwartet_',
                   ' ''^'' expected.',
                   ' ''^'' erwartet.',
                   '',
                   '');

  sprach_eintrag04('_schliessende_Anfuehrungszeichen_erwartet_',
                   ' Closing quotation marks excpected.',
                   ' Schlie·ende AnfÅhrungszeichen erwartet.',
                   '',
                   '');

  sprach_eintrag04('_j_n_',
                   ' y/n ',
                   ' j/n ',
                   '',
                   '');

  sprach_eintrag04('plus_Lade_',
                   '+ reading ',
                   '+ Lade ',
                   '',
                   '');

  sprach_eintrag04('gleich_Schreibe_',
                   '= writing ',
                   '= Schreibe ',
                   '',
                   '');

  sprach_eintrag04('gleich_Loesche_',
                   '= deleting ',
                   '= Lîsche ',
                   '',
                   '');


  sprach_eintrag04('zeilen',
                   ' lines, ',
                   ' Zeilen, ',
                   '',
                   '');

  sprach_eintrag04('maximale_zeilenlaenge',
                   ' maximum line length.',
                   ' Zeichen in der lÑngsten.',
                   '',
                   '');

  sprach_eintrag04('Ungradzahlige_Anzahl_von_dachzeichen',
                   'Odd number of "^" chars!',
                   'Ungradzahlige Anzahl von "^"!',
                   '',
                   '');

  (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)

  (* menucomp *)

  sprach_eintrag04('error_evaluting',
                   'error evaluting "',
                   'Fehler beim Auswerten von "',
                   '',
                   '');

  sprach_eintrag04('syntax_schnelltaste',
                   'Usage: "QUICKKEY 1 HPFS=2 CDFS=1"',
                   'Benutzung: "SCHNELLTASTE 1 HPFS=2 CDFS=1"',
                   '',
                   '');

  sprach_eintrag04('untere_grenze',
                   'Lower limit : ',
                   'Untere Grenze : ',
                   '',
                   '');

  sprach_eintrag04('obere_grenze',
                   'Upper limit : ',
                   'Obere Grenze : ',
                   '',
                   '');

  sprach_eintrag04('unbekannte_variable',
                   'Unknown identifier : ',
                   'Unbekannte Variable : ',
                   '',
                   '');


  sprach_eintrag04('zu_viele_variablen_255',
                   'Too many variables (255)',
                   'Zu viele Variablen (255)',
                   '',
                   '');

  sprach_eintrag04('unbekannte_verknuepfung',
                   'Unknown operator: ',
                   'Unbekannte VerknÅpfung: ',
                   '',
                   '');

  sprach_eintrag04('erwartet',
                   'expected!',
                   'erwartet!',
                   '',
                   '');

  sprach_eintrag04('nicht252850',
                   'Only 25,28 or 50 rows supported.',
                   'Zur Zeit sind nur 25,28 oder 50 Zeilen zulÑssig.',
                   '',
                   '');

  sprach_eintrag04('zu_viele_grosse_variablen',
                   'Too many or to long variable names, statements or screens!',
                   'Zu viele zu lange Variablennamen, Anweisungen oder Bildschirme!',
                   '',
                   '');

  sprach_eintrag04('keine_variablen_definiert',
                   'No menu-variables defined!',
                   'Keine MenÅvariablen definiert!',
                   '',
                   '');

  sprach_eintrag04('zulaessige_zeichenkettenlaengen',
                   'valid string length is 1..79',
                   'zulÑssige ZeichenkettenlÑnge ist 1..79',
                   '',
                   '');

  sprach_eintrag04('zeichenkettenvariablen_sind_hier_nicht_erlaubt',
                   'String variables are not allowed heere!',
                   'Zeichenkettenvariablen sind hier nicht erlaubt!',
                   '',
                   '');

  sprach_eintrag04('variable_ist_keine_zahlenvariable',
                   'variable is not a integer variable!',
                   'Variable ist keine Zahlenvariable!',
                   '',
                   '');

  sprach_eintrag04('variable_ist_keine_zeichenkettenvariable',
                   'variable is not a string variable!',
                   'Variable ist keine Zeichenkettenvariable!',
                   '',
                   '');

  sprach_eintrag04('doppelte_benutzung_der_sprungtaste',
                   'Multiple use of jump key ',
                   'Mehrfache Benutzung der Sprungtaste ',
                   '',
                   '');

  sprach_eintrag04('sprungtaste_ist_reserviert',
                   'Jump key ist reserved for other menu functions: ',
                   'Die Sprungtaste ist fÅr andere Zwecke reserviert: ',
                   '',
                   '');

  sprach_eintrag04('Fehler__',
                   'Error: ',
                   'Fehler: ',
                   '',
                   '');

  sprach_eintrag04('fehlerhafte_Datei__Kennung_nicht_gefunden___',
                   'damaged file (can not find signature)!',
                   'fehlerhafte Datei (Kennung nicht gefunden)!',
                   '',
                   '');

  sprach_eintrag04('Kann_Datei_x_nicht_finden_1',
                   'Cannot fin file ',
                   'Kann Datei ',
                   '',
                   '');

  sprach_eintrag04('Kann_Datei_x_nicht_finden_2',
                   '!',
                   ' nicht finden!',
                   '',
                   '');

  sprach_eintrag04('Keine_sichtbaren_Variablen_definiert__',
                   'No visible variables defined!',
                   'Keine sichtbaren Variablen definiert!',
                   '',
                   '');

  sprach_eintrag04('nicht_gefunden__',
                   'not found!',
                   'nicht gefunden!',
                   '',
                   '');

  sprach_eintrag04('Datei_zu_lang__',
                   'File to large (',
                   'Datei zu lang (',
                   '',
                   '');

  sprach_eintrag04('minus_versuche',
                   '- trying',
                   '- versuche',
                   '',
                   '');

  sprach_eintrag04('__kann_dieses_OS2LDR_nicht_zurueckgewinnen__',
                   '- can not recover this OS2LDR!',
                   '- kann dieses OS2LDR nicht zurÅckgewinnen!',
                   '',
                   '');

  sprach_eintrag04('Bitte_stellen_Sie_OS2LDR_aus_einer_Kopie_wieder_her_',
                   'Please restore OS2LDR from original.',
                   'Bitte stellen Sie OS2LDR aus einer Kopie wieder her.',
                   '',
                   '');

  sprach_eintrag04('__Standardwerte_aendern',
                   '* modify default values',
                   '* Standardwerte Ñndern',
                   '',
                   '');

  sprach_eintrag04('unbekannte_Variable__',
                   'unknown variable "',
                   'unbekannte Variable "',
                   '',
                   '');

  sprach_eintrag04('__Wert_',
                   '" value=',
                   '" Wert=',
                   '',
                   '');

  sprach_eintrag04('uebergangen_unveraendert',
                   '- skipped (unchanged).',
                   '- Åbergangen (unverÑndert).',
                   '',
                   '');

  sprach_eintrag04('AB_CONFIG_SYS_veraltet1',
                   #7'A_CONFIG_SYS/B_CONFIG_SYS are changed to boolean variables:',
                   #7'A_CONFIG_SYS/B_CONFIG_SYS sind jetzt als boolen-Variablen zu verwenden:',
                   '',
                   '');

  sprach_eintrag04('AB_CONFIG_SYS_veraltet2',
                   'Use "VAR B_CONFIG_SYS 30 24 boolean true"',
                   'Benutzen Sie "VAR B_CONFIG_SYS 30 24 boolean true"',
                   '',
                   '');

  sprach_eintrag04('Arbeitsposition_',
                   'work position:',
                   'Arbeitsposition:',
                   '',
                   '');

  sprach_eintrag04('Restzeile_',
                   'remaining line:',
                   'Restzeile:',
                   '',
                   '');

  sprach_eintrag04('Zeile_',
                   'line:',
                   'Zeile:',
                   '',
                   '');

  sprach_eintrag04('erwartet_doppelpunkt',
                   'Expected: ',
                   'Erwartet: ',
                   '',
                   '');

  sprach_eintrag04('Zahlenvariable_erwartet_',
                   'Integer variable expected!',
                   'Zahlenvariable expected!',
                   '',
                   '');

  sprach_eintrag04('Drehfeldvariable_erwartet_',
                   'Spinbutton variable expected!',
                   'Drehfeldvariable expected!',
                   '',
                   '');

  sprach_eintrag04('Die_Variable_wurde_noch_nicht_definiert1',
                   'Variable ',
                   'Die Variable ',
                   '',
                   '');

  sprach_eintrag04('Die_Variable_wurde_noch_nicht_definiert2',
                   ' is not defined yet!',
                   ' wurde noch nicht definiert!',
                   '',
                   '');

  sprach_eintrag04('Zahlenvariable_oder_Zahlenkonstante_erwartet_',
                   'Integer variable or number expected!',
                   'Zahlenvariable oder Zahlenkonstante erwartet!',
                   '',
                   '');

  sprach_eintrag04('Variablenname_ist_zu_lang',
                   'variable name is too long (',
                   'Variablenname ist zu lang (',
                   '',
                   '');

  sprach_eintrag04('Unzulaessiges_Zeichen_im_Variablennamen_',
                   'Nonpermitted char in variable name (',
                   'UnzulÑssiges Zeichen im Variablennamen (',
                   '',
                   '');

  sprach_eintrag04('Die_Variable_wurde_schon_definiert_1',
                   'The variable ',
                   'Die Variable ',
                   '',
                   '');


  sprach_eintrag04('Die_Variable_wurde_schon_definiert_2',
                   ' is already defined!',
                   ' wurde schon definiert!',
                   '',
                   '');

  sprach_eintrag04('Zeichenkettenvariable_erwartet_',
                   'String variable expected (',
                   'Zeichenkettenvariable erwartet (',
                   '',
                   '');

  sprach_eintrag04('Zeichenkettenvariable__wurde_noch_nicht_definiert_1',
                   'String variable (',
                   'Zeichenkettenvariable (',
                   '',
                   '');


  sprach_eintrag04('Zeichenkettenvariable__wurde_noch_nicht_definiert_2',
                   ') is still undefined yet.',
                   ') wurde noch nicht definiert.',
                   '',
                   '');

  sprach_eintrag04('Zeichenkette_oder_Drehfeld_Variable_erwartet_',
                   'String or spinbutton variable expected!',
                   'Zeichenkette oder Drehfeld-Variable erwartet!',
                   '',
                   '');


  sprach_eintrag04('Zeichenketten_Variable_erwartet_',
                   'String variable expected!',
                   'Zeichenketten-Variable erwartet!',
                   '',
                   '');

  sprach_eintrag04('Variable_erwartet_',
                   'Variable expected (',
                   'Variable erwartet (',
                   '',
                   '');

  sprach_eintrag04('Variable__wurde_noch_nicht_definiert1',
                   'Variable (',
                   'Variable (',
                   '',
                   '');


  sprach_eintrag04('Variable__wurde_noch_nicht_definiert2',
                   ') is not defined yet.',
                   ') wurde noch nicht definiert.',
                   '',
                   '');

  sprach_eintrag04('Syntaxfehler___erwartet_1',
                   'Syntax error: ',
                   'Syntaxfehler: ',
                   '',
                   '');

  sprach_eintrag04('Syntaxfehler___erwartet_2',
                   ' expected!',
                   ' erwartet!',
                   '',
                   '');

  sprach_eintrag04('Zahl_fuer_den_Ausdruck',
                   'number for expression',
                   'Zahl fÅr den Ausdruck',
                   '',
                   '');

  sprach_eintrag04('Zahlenvariable_erwartet__',
                   'Integer variable expected (',
                   'Zahlenvariable erwartet (',
                   '',
                   '');


  sprach_eintrag04('Nur_gleich_und_ungleich_sind_fuer_Zeichenkettenvergleiche_zulaessig_',
                   'Only "=" and "<>" are permitted for string compare!',
                   'Nur "=" und "<>" sind fÅr Zeichenkettenvergleiche zulÑssig!',
                   '',
                   '');

  sprach_eintrag04('Anzahl_zu_loeschender_Zeichen',
                   'delete count',
                   'Anzahl-zu-lîschender-Zeichen',
                   '',
                   '');

  sprach_eintrag04('Anfangsposition',
                   'Starting position',
                   'Anfangsposition',
                   '',
                   '');

  sprach_eintrag04('Einfuegestelle',
                   'Insert position',
                   'EinfÅgestelle',
                   '',
                   '');


  sprach_eintrag04('Laenge',
                   'Length',
                   'LÑnge',
                   '',
                   '');

  sprach_eintrag04('Zuweisungsausdruck',
                   'operand expression',
                   'Zuweisungsausdruck',
                   '',
                   '');

  sprach_eintrag04('Die_Zuweisung_von__',
                   'The assignment of "',
                   'Die Zuweisung von "',
                   '',
                   '');

  sprach_eintrag04('__passt_nicht_zu_der_Definition_von_',
                   '" does not match to definition of ',
                   '" pa·t nicht zu der Definition von ',
                   '',
                   '');

  sprach_eintrag04('Elementnummer_oder_Zeichenkettenkonstante',
                   'Elementnumber or string constant',
                   'Elementnummer oder Zeichenkettenkonstante',
                   '',
                   '');

  sprach_eintrag04('Spaltenposition',
                   'Column position',
                   'Spaltenposition',
                   '',
                   '');

  sprach_eintrag04('Zeilennummer',
                   'Row position',
                   'Zeilennummer',
                   '',
                   '');

  sprach_eintrag04('Zuerst_mit_MENU_BIN_eine_Seite_definieren',
                   'Please use MENU_BIN command to create a screen first!',
                   'Zuerst mit MENU_BIN eine Seite definieren!',
                   '',
                   '');

  sprach_eintrag04('Seitennummer',
                   'Screen number',
                   'Seitennummer',
                   '',
                   '');

  sprach_eintrag04('Anzahl_der_Zustaende',
                   'Number of states',
                   'Anzahl der ZustÑnde',
                   '',
                   '');

  sprach_eintrag04('Platzbedarf_fuer_die_Zeichenkette',
                   'Space reserved for string',
                   'Platzbedarf fÅr die Zeichenkette',
                   '',
                   '');

  sprach_eintrag04('Standardwert_boolean_oder_0_1_',
                   'Default value (boolean or 0/1)',
                   'Standardwert (boolean oder 0/1)',
                   '',
                   '');

  sprach_eintrag04('wert_boolean_oder_0_1_',
                   'Value (boolean or 0/1)',
                   'Wert (boolean oder 0/1)',
                   '',
                   '');

  sprach_eintrag04('Standardwert',
                   'Default value',
                   'Standardwert',
                   '',
                   '');

  sprach_eintrag04('Wert',
                   'Value',
                   'Wert',
                   '',
                   '');

  sprach_eintrag04('Ergebnis',
                   'Result',
                   'Ergebnis',
                   '',
                   '');



  sprach_eintrag04('Standardwert__Elementnummer_oder_Elementkonstante',
                   'Default value: Elmement number or element constant',
                   'Standardwert: Elementnummer oder Elementkonstante',
                   '',
                   '');

  sprach_eintrag04('geht_ueber_eine_Bildschirmzeile_hinaus',
                   'exceeds line limit',
                   'geht Åber eine Bildschirmzeile hinaus',
                   '',
                   '');

  sprach_eintrag04('_sollte_25_28_oder_50_Zeilen_gross_sein__',
                   ' should be set to 25, 28 or 50 lines!',
                   ' sollte 25,28 oder 50 Zeilen gro· sein!',
                   '',
                   '');

  sprach_eintrag04('Zeilenzahl',
                   'Number of lines',
                   'Zeilenzahl',
                   '',
                   '');

  sprach_eintrag04('Zeitgrenze',
                   'Timelimit',
                   'Zeitgrenze',
                   '',
                   '');

  sprach_eintrag04('EingabetasteSC',
                   'Ascii+Scancode for Enter key',
                   'Tastenkode fÅr die Eingabetaste',
                   '',
                   '');

  sprach_eintrag04('AbbruchSC',
                   'Ascii+Scancode for Cancel key',
                   'Tastenkode zum Abbruch von OS2CSM',
                   '',
                   '');

  sprach_eintrag04('ResetSC',
                   'Ascii+Scancode to reset to default values',
                   'Tastenkode zum ZurÅcksetzen auf die Standardwerte',
                   '',
                   '');

  sprach_eintrag04('AltF5SC',
                   'Ascii+Scancode to view BIOS screen',
                   'Tastenkode zum Ansehen des BIOS-Bildschirmes',
                   '',
                   '');

  sprach_eintrag04('HelpSC',
                   'Ascii+Scancode to view contex help',
                   'Tastenkode zur Anzeige des Hilfefensters',
                   '',
                   '');

  sprach_eintrag04('MENU_CONFIRM_YES_sc',
                   'Ascii+Scancode to confirm continue',
                   'Tastenkode zum BestÑtigen des Systemstarts',
                   '',
                   '');

  sprach_eintrag04('MENU_CONFIRM_NO_sc',
                   'Ascii+Scancode to cancel continue',
                   'Tastenkode zum Abbrechen des Systemstarts',
                   '',
                   '');

  sprach_eintrag04('MENU_CANCEL_YES_sc',
                   'Ascii+Scancode to confirm cancel',
                   'Tastenkode zum BestÑtigen des Abbruchs',
                   '',
                   '');

  sprach_eintrag04('MENU_CANCEL_NO_sc',
                   'Ascii+Scancode to cancel cancel',
                   'Tastenkode zum Abbrechen des Abbruchs',
                   '',
                   '');

  sprach_eintrag04('MENU_RESET_YES_sc',
                   'Ascii+Scancode to confirm reset to default values',
                   'Tastenkode zum BestÑtigen des Ladens der Standardwerte',
                   '',
                   '');

  sprach_eintrag04('MENU_RESET_NO_sc',
                   'Ascii+Scancode to cancel reset to default values',
                   'Tastenkode zum Abbrechen des Ladens der Standardwerte',
                   '',
                   '');

  sprach_eintrag04('zu_viele_Seiten_',
                   'Too many screens!',
                   'zu viele Seiten!',
                   '',
                   '');

  sprach_eintrag04('Schnelltaste_1_bis_10',
                   'Quickkey 1 to 10',
                   'Schnelltaste 1 bis 10',
                   '',
                   '');

  sprach_eintrag04('runerror991',
                   'The program reached a situaltion that should not be possible.',
                   'Es ist ein Fehler aufgetreten, der nicht vorkommen sollte.',
                   '',
                   '');

  sprach_eintrag04('runerror992',
                   'Please send a message to the author and append all',
                   'Bitte schicken Sie mir eine Nachricht und fÅgen Sie alle',
                   '',
                   '');

  sprach_eintrag04('runerror993',
                   'used files.',
                   'betreffenden Dateien bei.',
                   '',
                   '');

  sprach_eintrag04('_weiter_mit_der_Eingabetaste_',
                   '[Press Return to Quit]',
                   '[DrÅcken Sie <ƒŸ um das Programm zu beenden]',
                   '',
                   '');

  sprach_eintrag04('Mehrfache_wiederspruechliche_Variablenzuweisung',
                   'Multiple/conflicting variable assignment! (',
                   'Mehrfache wiedersprÅchliche Variablenzuweisung! (',
                   '',
                   '');

  sprach_eintrag04('ausserhalb_des_gueltigen_bereiches',
                   'Out of allowed range : ',
                   'Aus·erhalb des zulÑssigen Bereiches : ',
                   '',
                   '');

  sprach_eintrag04('kein_schluesselwort',
                   'not a known keyword',
                   'kein SchlÅsselwort',
                   '',
                   '');

  sprach_eintrag04('zu_viele_grosse_dauerhafte_variablen',
                   'To many large permanent Variables!',
                   'Es sind zu viele dauerhafte Variablen definiert worden!',
                   '',
                   '');

  sprach_eintrag04('benutze_loesch_schluesselwoerter1',
                   'Use keywords COMPRESS_TO_STRING,COMPRESS_TO_INTEGER (spinbutton)',
                   'Benutzen Sie die SchlÅsselworte PACKE_ZU_ZEICHENKETTE und PACKE_ZU_ZAHL fÅr',
                   '',
                   '');

  sprach_eintrag04('benutze_loesch_schluesselwoerter2',
                   'or keyword DELETE_AT_MENU_EXIT (all types) to save memory.',
                   'Drehfelder oder LôSCHEN_NACH_DEM_MENö (alle Typen) um mehr Platz zu machen.',
                   '',
                   '');

  sprach_eintrag04('Hersteller_Kennung',
                   'Vendor-ID',
                   'Hersteller-Kennung',
                   '',
                   '');

  sprach_eintrag04('Geraetenummer',
                   'Device-ID',
                   'GerÑte-Kennung',
                   '',
                   '');

  sprach_eintrag04('Geraeteklasse',
                   'Device Class',
                   'GerÑteklasse',
                   '',
                   '');

  sprach_eintrag04('Zugriffsart',
                   'Access Interface',
                   'Zugriffsart',
                   '',
                   '');

  sprach_eintrag04('Speicherbedarf',
                   'memory usage',
                   'Speicherbedarf',
                   '',
                   '');

  sprach_eintrag04('ROT',
                   'red value',
                   'Rotwert',
                   '',
                   '');

  sprach_eintrag04('GRUEN',
                   'green value',
                   'GrÅnwert',
                   '',
                   '');

  sprach_eintrag04('BLAU',
                   'blue value',
                   'Blauwert',
                   '',
                   '');

  sprach_eintrag04('Use__MENU_BIN__first',
                   'Use "MENU_BIN" first!',
                   'Benutzen Sie zuerst "MENU_BIN"!',
                   '',
                   '');

  sprach_eintrag04('Zeichenkette_erwartet',
                   'String expected!',
                   'Zeichenkette erwartet!',
                   '',
                   '');

  sprach_eintrag04('Brane_tabelle_voll',
                   'The BRANE-table is full.',
                   'Die Brane-Tabelle ist voll.',
                   '',
                   '');

  sprach_eintrag04('char_code_number',
                   'char code number',
                   'Zeichnnummer',
                   '',
                   '');

  sprach_eintrag04('zeile_mit_steuerzeichen_ignoriert_',
                   'Ignored brane line with control chars:',
                   'Zeile mit Steuerzeichen ignoriert:',
                   '',
                   '');

  sprach_eintrag04('ungueltige_Umgebungsvariable_',
                   'Invalid environment variiable:',
                   'UngÅltige Umgebungsvariable:',
                   '',
                   '');

  sprach_eintrag04('include_Tiefe_zu_hoch',
                   'include-nesting to deep!',
                   'Include-Tiefe zu hoch!',
                   '',
                   '');

  sprach_eintrag04('duplicate_help_item_',
                   'Duplicate help item!',
                   'Doppelter Hilfeeintrag!',
                   '',
                   '');

  sprach_eintrag04('helpfile_is_becoming_too_large_',
                   'Helpfile is becoming too large!',
                   'Hilfedatei wird zu gro·!',
                   '',
                   '');

  sprach_eintrag04('Foreground_color',
                   'Foreground color',
                   'Vordergrundfarbe',
                   '',
                   '');

  sprach_eintrag04('Background_color',
                   'Background color',
                   'Hintergrundfarbe',
                   '',
                   '');

  sprach_eintrag04('page_number',
                   'Page number',
                   'Seitennummer',
                   '',
                   '');

  sprach_eintrag04('variable_x_not_found1',
                   'variable ',
                   'Variable ',
                   '',
                   '');

  sprach_eintrag04('variable_x_not_found2',
                   ' not found!',
                   ' wurde nicht gefunden!',
                   '',
                   '');

  sprach_eintrag04('variable_x_invisible1',
                   'variable ',
                   'Variable ',
                   '',
                   '');

  sprach_eintrag04('variable_x_invisible2',
                   ' is not visble!',
                   ' ist unsichtbar!',
                   '',
                   '');

  sprach_eintrag04('Not_available_',
                   'Not available!',
                   'Nicht vorhanden!',
                   '',
                   '');

{
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
}
  schreibe_sprach_datei('OS2CSM1$.001','OS2CSM1$.002','sprach_modul1','sprach_start1','^string');

  (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)


  sprachtabellenkopf(
                    +'EN'
                    +'DE'
                    +'ES'
                    +'FR'
                    +'IT'
                    +'JP'
                    +'NL'
                    +'RU');

  sprach_eintrag12('OS2CSM_ERW',
                   'en\os2csmr.bin',
                   'de\os2csmr.bin',
                   'sp\os2csmr.bin',
                   'fr\os2csmr.bin',
                   'it\os2csmr.bin',
                   'jp\os2csmr.bin',
                   'nl\os2csmr.bin',
                   'ru\os2csmr.bin',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag12('OS2CSM_ERW_MEMDISK',
                   'en\os2csmm.bin',
                   'de\os2csmm.bin',
                   'sp\os2csmm.bin',
                   'fr\os2csmm.bin',
                   'it\os2csmm.bin',
                   'jp\os2csmm.bin',
                   'nl\os2csmm.bin',
                   'ru\os2csmm.bin',
                   '',
                   '',
                   '',
                   '');

  schreibe_sprach_datei('OS2CSM2$.001','OS2CSM2$.002','sprach_modul2','sprach_start2','^string');

end.

