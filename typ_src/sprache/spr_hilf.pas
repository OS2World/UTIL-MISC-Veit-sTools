program typsprache_def_hilf;
(* V.K. 17.12.1996 *)

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  (* aus TYP_HILF.PAS *)
  sprach_eintrag04('Version_vom',
                   'version of  ',
                   'Version vom ',
                   '',
                   '');

  sprach_eintrag04('hilfe_0_1',
                   'recognition of filetypes: compilers, execompressors, viruses, drivers,  ',
                   'Ermittlung von Dateitypen: Compiler, Komprimierer, Viren, Treiber, Musik',
                   '',
                   '');

  sprach_eintrag04('hilfe_0_2',
                   'musik, graphic, archive lister, file descriptions, system files,        ',
                   'Bilder, Archive, Dateibeschreibungen, Systemdateien, Dos-Extender, ...  ',
                   '',
                   '');

  sprach_eintrag04('hilfe_0_3',
                   'DOS-extenders, ICO, enhanced attributes ...                             ',
                   'ICO, Erweiterte Attribute ...                                           ',
                   '',
                   '');


  sprach_eintrag04('Parameter',
                   'parameter',
                   'Parameter',
                   '',
                   '');

  sprach_eintrag04('Dateien_Schalter_punktpunkt',
                   '[files|switches [..]]',
                   '[Dateien|Schalter [..]]',
                   '',
                   '');

  sprach_eintrag04('hilfe_1_1',
                   'files: ',
                   'Dateien: ',
                   '',
                   '');

  sprach_eintrag04('hilfe_1_2',
                   '  filenames :  F:HALLO.COM',
                   '  Dateinamen:  F:HALLO.COM',
                   '',
                   '');

  sprach_eintrag04('hilfe_1_3',
                   '       or   :  "EA DATA. SF"',
                   '       oder :  "EA DATA. SF"',
                   '',
                   '');

  sprach_eintrag04('hilfe_1_4',
                   '  masks:       C:\NWDOS\*.EXE',
                   '  Masken:      C:\NWDOS\*.EXE',
                   '',
                   '');

  sprach_eintrag04('hilfe_1_5',
                   '  listfiles:   @V:\TMP\DIR.LST',
                   '  Listdateien: @V:\TMP\DIR.LST',
                   '',
                   '');

  sprach_eintrag04('Schalter_doppelpunkt',
                   'switches',
                   'Schalter',
                   '',
                   '');


  sprach_eintrag04('hilfe_schalter_u',
                   '-U[+|-] search als in Subdirectories',
                   '-U[+|-] auch in Unterverzeichnissen suchen',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_p',
                   '-P[+|-] analyze partition table and memory',
                   '-P[+|-] Untersuchung von Partitionstabelle und Speicher',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_s',
                   '-S[+|-] analyse bootsectors',
                   '-S[+|-] Startsektoren untersuchen',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_l',
                   '-L[+|-] longformat/verbose: archive viewer',
                   '-L[+|-] Langformat: Archivlister',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_m',
                   '-M[+|-] use mouse',
                   '-M[+|-] 3-Tasten-Maus verwenden',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_n',
                   '-N:xxxx Produce file extraction command file',
                   '-N:xxxx Erzeuge Stapelverarbeitungsdatei zum Entpacken von Dateien',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_c',
                   '-C[+|-] CPU-emulator on/off',
                   '-C[+|-] CPU-Emulator',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_r',
                   '-R[+|-] list resource tables',
                   '-R[+|-] Resourcen anzeigen',
                   '',
                   '');

  (*$IFNDEF DOS_ODER_DPMI*)
  sprach_eintrag04('hilfe_schalter_g',
                   '-G[+|-] use GTDATA.DLL',
                   '-G[+|-] GTDATA.DLL laden',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DOS*)

  sprach_eintrag04('hilfe_schalter_j_dos',
                   '-J[+|-] use joystick',
                   '-J[+|-] Spielhebel verwenden',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_d_dos',
                   '-D[+|-] direct access to harddisk ports [IDE]',
                   '-D[+|-] Direkter Zugriff auf Fesplattenports [IDE]',
                   '',
                   '');
  (*$ENDIF*)

  sprach_eintrag04('hilfe_schalter_c_dos',
                   '-C[+|-] use CPU-emulator (timeconsuming)',
                   '-C[+|-] benutze CPU-Emulator (benîtig viel Rechenleistung)',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_i',
                   '-I[+|-] show icons (OS/2,Windows,Award BIOS)',
                   '-I[+|-] Anzeige von Symbolen (OS/2,Windows,Award BIOS)',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_ausrufezeichen',
                   '-![+|-] OS/2 or TASKMGR-backgroundprocess',
                   '-![+|-] OS/2 oder TASKMGR-Hintergrundprogramm',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_a',
                   '-A[+|-] determine BIOS chipset and password',
                   '-A[+|-] BIOS-Kennwort/Chipsatz ermitteln',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_f_1',
                   '-F:xxxx load color table file',
                   '-F:xxxx Farbtabellendatei laden',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_f_2',
                   '        xxxx = filename ; create it with ',
                   '        xxxx = Dateiname ; Erzeugung mit ',
                   '',
                   '');

  (*$IFDEF DOS*)
  sprach_eintrag04('hilfe_schalter_e_dos',
                   '-E:xxxx upper bound usage EMS-memory [KB]',
                   '-E:xxxx Obergrenze Nutzung EMS-Speicher [KB]',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_x_dos',
                   '-X:xxxx upper bound usage XMS-memory [KB]',
                   '-X:xxxx Obergrenze Nutzung XMS-Speicher [KB]',
                   '',
                   '');

  (*$ENDIF*)

  (*$IFDEF OS2*)
  sprach_eintrag04('hilfe_schalter_x_os2',
                   '-X:xxxxx upper bound usage main-memory [KB]',
                   '-X:xxxxx Obergrenze Nutzung RAM-Speicher [KB]',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_e_os2',
                   '-E[+|-] display extended attributes',
                   '-E[+|-] Erweiterte Attribute anzeigen',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DPMI32*)
  sprach_eintrag04('hilfe_schalter_x_dpmi32',
                   '-X:xxxx upper bound usage main-memory [KB]',
                   '-X:xxxx Obergrenze Nutzung RAM-Speicher [KB]',
                   '',
                   '');
  (*$ENDIF*)

  sprach_eintrag04('hilfe_schalter_z_1',
                   '-Z:xx   Switch Screen to xx lines',
                   '-Z:xx   Umschalten auf xx Zeilen',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_z_2',
                   '        xx Ó '+#123+' (0),25,28,43,50,60 '+#125,
                   '        xx Ó '+#123+' (0),25,28,43,50,60 '+#125,
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_b_1',
                   '-Bxyyyy choice of screen access method',
                   '-Bxyyyy Auswahl der Bildschirmbenutzung:',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_b_2',
                   '        yyyy for x=A,E,F redirection to file yyyy',
                   '        yyyy fÅr x=A,E,F Umleitung in Datei yyyy',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_b_3',
                   '        the varaints x=A,E,F are very limited:',
                   '        Die Varianten x=A,E,F sind sehr eingeschrÑnkt:',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_b_4',
                   '          ˛ uses no additional memory',
                   '          ˛ keine Benutzung von zusÑtzlichem Speicher',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_b_5',
                   '          ˛ mousecontrol and cursormovement are disabled',
                   '          ˛ Maussteuerung und Cursortasten haben keine Wirkung',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_allgemein_1',
                   '˛ if you give no parameter this help is displayed',
                   '˛ wenn kein Parameter angegeben ist wird diese Hilfe angezeigt',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_allgemein_2',
                   '˛ if you only give switches *.* is assumed',
                   '˛ wenn nur Schalter angegeben sind, wird Maske *.* angenommen',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_allgemein_3',
                   '˛ There is no test of duplicate filenames!',
                   '˛ Es wird nicht auf doppelte Dateinamen geachtet!',
                   '',
                   '');

  sprach_eintrag04('hilfe_schalter_beispiel',
                   'example:           TY C:\ -U+ -P+ -S+ -A+ -BaLog.txt',
                   'Beispiel:          TY C:\ -U+ -P+ -S+ -A+ -BaLog.txt',
                   '',
                   '');

  sprach_eintrag04('hilfe_dateitrenner1',
		   'You can insert separator lines in the output between each file by using',
		   'Sie kînnen in die Ausgabe Trennzeilen zwischen den Dateien einfÅgen:',
                   '',
                   '');
		   
  sprach_eintrag04('hilfe_dateitrenner2',
		   'SET FILE_SEPARATOR=+++next++file+++',
		   'SET FILE_SEPARATOR=+++nÑchste++Datei+++',
                   '',
                   '');

  sprach_eintrag04('hilfe_typeinexe_1',
                   'with help of this programm you can configure default values',
                   'Mit Hilfe dieses Programmes kînnen Sie Standardeinstellungen',
                   '',
                   '');

  sprach_eintrag04('hilfe_typeinexe_2',
                   'for Typ',
                   'fÅr Typ vornehmen.',
                   '',
                   '');

  sprach_eintrag04('hilfe_typeinexe_3',
                   ' ˛ it can create/modify a color table',
                   ' ˛ es kann die Farbpalette verÑndern',
                   '',
                   '');

  sprach_eintrag04('hilfe_typeinexe_4a',
                   ' ˛ it can create ',
                   ' ˛ es kann ',
                   '',
                   '');

  sprach_eintrag04('hilfe_typeinexe_4b',
                   ' in an diretory of the searchpath',
                   ' in einem Verzeichnis des Suchpfades anlegen',
                   '',
                   '');

  sprach_eintrag04('Farblegende',
                   'color legend',
                   'Farblegende',
                   '',
                   '');

  sprach_eintrag04('verwendete_Symbolik',
                   'used symbolism',
                   'verwendete Symbolik',
                   '',
                   '');

  sprach_eintrag04('hilfe_symbolik_1',
                   '[4] supposed version',
                   '[4] vermutete Version',
                   '',
                   '');

  sprach_eintrag04('hilfe_symbolik_2',
                   '<2> variant (my definition)',
                   '<2> Variante (selbst festgelegt)',
                   '',
                   '');

  sprach_eintrag04('hilfe_symbolik_3',
                   '  found by not very reliable algorithm',
                   '  gefunden bei Suche nach polymorphem Kode -> unsicherer',
                   '',
                   '');

  sprach_eintrag04('hilfe_symbolik_4',
                   '??? i do not now too',
                   '??? ich wei· es auch nicht',
                   '',
                   '');

  sprach_eintrag04('hilfe_symbolik_5',
                   '   i searching for mor infos or the program',
                   '¯  ich benîtige Programm oder mehr Informationen',
                   '',
                   '');

  sprach_eintrag04('hilfe_symbolik_6',
                   '≥  two names or publishers',
                   '≥  zwei Bezeichnungen oder Herausgeber',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung',
                   'keyboard usage',
                   'Tastaturbelegung',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_1',
                   '['#25'] ['#24'] ................. 1 line + / -',
                   '['#25'] ['#24'] ................. je 1 Zeile + / -',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_2a',
                   '[page'#25'] [page'#24'] ......... ',
                   '[Bild'#25'] [Bild'#24'] ......... je ',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_2b',
                   ' lines + / -',
                   ' Zeilen + / -',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_3',
                   '[home] .................. jump to line 1',
                   '[Pos1] .................. Sprung zu Zeile 1',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_4',
                   '[End] ................... jump to last line',
                   '[Ende] .................. Sprung zur aktuellen letzten Zeile',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_5',
                   '[Esc] ................... program end',
                   '[Esc] ................... Programmende',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_6',
                   '[A] ..................... program end with ASCII-protokol',
                   '[A] ..................... Programmende und ASCII-Protokoll',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_7',
                   '[E] ..................... program end with ANSI-ESC-protokol',
                   '[E] ..................... Programmende und ANSI-ESC-Protokoll',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_8',
                   '[F] ..................... program end with filterd ASCII-protokol',
                   '[F] ..................... Programmende und gefiltertes ASCII-Protokoll',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_9',
                   '[ƒƒ] ................... stop rolling (speed improvement)',
                   '[ƒƒ] ................... Rollen stoppen (schneller fertig)',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_10',
                   '[+] [-] ................. change roll speed',
                   '[+] [-] ................. Rollgeschwindigkeit verÑndern',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_11',
                   '[Leertaste] ............. reverse rolling',
                   '[Leertaste] ............. Rollen umkehren',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_12',
                   '[F7] .................... search text',
                   '[F7] .................... Textsuche',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_13',
                   '[Shift-F7] .............. search again',
                   '[Umschalt-F7] ........... weiter suchen',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_14',
                   '[F11] ................... skip CPU emulation',
                   '[F11] ................... Prozessoremulation abbrechen',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_15',
                   '[F12] ................... call TaskMgr',
                   '[F12] ................... Aufruf TaskMgr',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_16',
                   'in screenmodus -BA,-BE,-BF the only usable keys',
                   'im Bilschirmmodus -BA,-BE,-BF haben nur die Tasten',
                   '',
                   '');

  sprach_eintrag04('hilfe_Tastaturbelegung_17',
                   'are [Esc] [page'#25']',
                   '[Esc] [Bild'#25'] Wirkung',
                   '',
                   '');

  sprach_eintrag04('Mausbelegung',
                   'mouse layout',
                   'Mausbelegung',
                   '',
                   '');

  sprach_eintrag04('hilfe_Mausbelegung_1',
                   '['#25'] ['#24'] ................. lines + / -',
                   '['#25'] ['#24'] ................. Zeilen + / -',
                   '',
                   '');

  sprach_eintrag04('hilfe_Mausbelegung_2a',
                   '[left button] ........... ',
                   '[Linke Taste] ........... je ',
                   '',
                   '');

  sprach_eintrag04('hilfe_Mausbelegung_2b',
                   ' lines +',
                   ' Zeilen +',
                   '',
                   '');

  sprach_eintrag04('hilfe_Mausbelegung_3a',
                   '[middle button] ......... ',
                   '[Mittlere Taste] ........ je ',
                   '',
                   '');

  sprach_eintrag04('hilfe_Mausbelegung_3b',
                   ' lines -',
                   ' Zeilen -',
                   '',
                   '');

  sprach_eintrag04('hilfe_Mausbelegung_4',
                   '[right button] .......... program end',
                   '[Rechte Taste] .......... Programmende',
                   '',
                   '');

    (*$IFDEF DOS*)
  sprach_eintrag04('Spielhebelbelegung',
                   'Joystick layout',
                   'Spielhebelbelegung',
                   '',
                   '');

  sprach_eintrag04('hilfe_spielhebelbelegung_1',
                   '['#25'] ['#24'] ................. lines + / -',
                   '['#25'] ['#24'] ................. Zeilen + / -',
                   '',
                   '');

  sprach_eintrag04('hilfe_spielhebelbelegung_2a',
                   '[buuton 1] .............. ',
                   '[Knopf 1] ............... je ',
                   '',
                   '');

  sprach_eintrag04('hilfe_spielhebelbelegung_2b',
                   ' lines +',
                   ' Zeilen +',
                   '',
                   '');

  sprach_eintrag04('hilfe_spielhebelbelegung_3',
                   '[Button 2] .............. program end',
                   '[Knopf 2] ............... Programmende',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DOS*)
  sprach_eintrag04('Der_Parameter_D_plus',
                   'The switch -D+',
                   'Der Parameter -D+',
                   '',
                   '');

  sprach_eintrag04('hilfe_Der_Parameter_D_plus_1_1',
                   'The program the accesses direct the first for IDE-hard-disks',
                   'Das Programm greift dann direkt auf die ersten 4 IDE-Fesplatten zu.',
                   '',
                   '');

  sprach_eintrag04('hilfe_Der_Parameter_D_plus_1_2',
                   'purpose : bypass installed viruses',
                   'Zweck : Umgehung installierter Viren',
                   '',
                   '');

  sprach_eintrag04('hilfe_Der_Parameter_D_plus_1_3',
                   'that can raise conflicts with other programs',
                   'Das Programm kînnte deshalb mit anderen Interessenten in Konflikt',
                   '',
                   '');

  sprach_eintrag04('hilfe_Der_Parameter_D_plus_1_4',
                   'if the access at the same time the hard disk.',
                   'kommen, die gleichzeitig zugreifen.',
                   '',
                   '');

  sprach_eintrag04('hilfe_Der_Parameter_D_plus_1_5',
                   'data loss would be very likely',
                   'DatenschÑden wÑren warscheinlich.',
                   '',
                   '');

  sprach_eintrag04('hilfe_Der_Parameter_D_plus_2_1',
                   'typ recognize and temporarly disables delayed write:',
                   'Typ erkennt und schaltet zeitweise Schreibverzîgerung aus:',
                   '',
                   '');

  sprach_eintrag04('hilfe_Der_Parameter_D_plus_3_1',
                   '[complete off]',
                   '[vollstÑndig aus]',
                   '',
                   '');

  sprach_eintrag04('hilfe_Der_Parameter_D_plus_4_1',
                   'do not use the parameter with other programs!',
                   'Bei anderen Programmen dÅrfen Sie den Parameter nicht benutzen!',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '˛ SMARTDRV 4.00+, PC-Cache 8.0, NWCache',
                   '',
                   '');

  (*$ENDIF*)



  sprach_eintrag04('geschwindigkeit',
                   'speed',
                   'Geschwindigkeit',
                   '',
                   '');

  (*$IFDEF DOS*)
  sprach_eintrag04('hilfe_geschwindigkeit_dos_1',
                   'i recommend an disk cache program like hyperdisk.',
                   'Ich empfehle ein Plattenpufferungsprogramm wie Hyperdisk.',
                   '',
                   '');

  sprach_eintrag04('hilfe_geschwindigkeit_dos_2',
                   'typ does not uses the EMS-pageframe.',
                   'Das Programm benîtigt fÅr die EMS-Benutzung keinen Seitenrahmen.',
                   '',
                   '');

  sprach_eintrag04('hilfe_geschwindigkeit_dos_3',
                   'if the screen is ugly or there is not status line .. ',
                   'Wenn die Bildschirmausgabe gestîrt aussieht oder die Statuszeile fehlt',
                   '',
                   '');

  sprach_eintrag04('hilfe_geschwindigkeit_dos_4',
                   'use full screen DOS-session.',
                   'sollten Sie eine Vollbildsitzung versuchen.',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF OS2*)
  sprach_eintrag04('hilfe_geschwindigkeit_os2_1',
                   'fullscreen is faster than windowed',
                   'Vollbild ist schneller als Fenster',
                   '',
                   '');

  sprach_eintrag04('hilfe_geschwindigkeit_os2_2',
                   'optimize "IFS=HPFS.IFS /CACHE:" and "DISKCACHE=" (CONFIG.SYS)',
                   'optimieren Sie "IFS=HPFS.IFS /CACHE:" und "DISKCACHE=" (CONFIG.SYS)',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DPMI32*)
  sprach_eintrag04('hilfe_geschwindigkeit_dpmi32_1',
                   'fullscreen is faster than windowed',
                   'Vollbild ist schneller als Fenster',
                   '',
                   '');
  (*$ENDIF*)


  sprach_eintrag04('Was_kann_das_Programm_nicht',
                   'what can this program do / not do?',
                   'Was kann das Programm (nicht)?',
                   '',
                   '');

  sprach_eintrag04('hilfe_Was_kann_das_Programm_nicht_1_1',
                   'The program can only know of compilers,.. with are build in',
                   'Das Programm kann nur Compiler,... kennen, die der Autor',
                   '',
                   '');

  sprach_eintrag04('hilfe_Was_kann_das_Programm_nicht_1_2',
                   'by the autor. It can point out compression/encryption',
                   'eingebaut hat. Es kann Hinweise auf Kompression geben',
                   '',
                   '');

  sprach_eintrag04('hilfe_Was_kann_das_Programm_nicht_1_3',
                   'or show textheader of files',
                   'oder Dateien mit Textkopf zeigen.',
                   '',
                   '');

  sprach_eintrag04('hilfe_Was_kann_das_Programm_nicht_1_4',
                   'with switch /p+ it can show memory allocation by',
                   'Mit Schalter /P+ wird auch Hinweis auf im Speicher',
                   '',
                   '');

  sprach_eintrag04('hilfe_Was_kann_das_Programm_nicht_1_5',
                   'bootviruses (DOS and OS/2)',
                   'vorhandene sektororientierte Viren gegeben. (DOS und OS/2)',
                   '',
                   '');

  sprach_eintrag04('hilfe_Was_kann_das_Programm_nicht_1_6',
                   'typ supports up to 32 drives (A: to `:)',
                   'Typ unterstÅtzt bis zu 32 Laufwerke (A: bis `:)',
                   '',
                   '');

  sprach_eintrag04('Das_Programm_liefert_Rueckkehrwerte',
                   'return codes of the program',
                   'Das Programm liefert RÅckkehrwerte.',
                   '',
                   '');

  sprach_eintrag04('hilfe_Das_Programm_liefert_Rueckkehrwerte_1',
                   '  0 ..... no problem',
                   '  0 ..... kein Problem',
                   '',
                   '');

  sprach_eintrag04('hilfe_Das_Programm_liefert_Rueckkehrwerte_2',
                   '  1 ..... 216 runtime errors',
                   '  1 ..... 216 Laufzeitfehler',
                   '',
                   '');

  sprach_eintrag04('hilfe_Das_Programm_liefert_Rueckkehrwerte_3',
                   '  240 ... equipment does not match',
                   '  240 ... RechnerausrÅstung pa·t nicht',
                   '',
                   '');

  sprach_eintrag04('hilfe_Das_Programm_liefert_Rueckkehrwerte_4',
                   '  241 ... error evaluting parameters',
                   '  241 ... Problem beim Auswerten der Parameter',
                   '',
                   '');

  sprach_eintrag04('hilfe_Das_Programm_liefert_Rueckkehrwerte_5',
                   '  242 ... unexpected problem',
                   '  242 ... Unerwartetes Problem ',
                   '',
                   '');

  sprach_eintrag04('hilfe_Das_Programm_liefert_Rueckkehrwerte_6',
                   '  243 ... virus found',
                   '  243 ... Virus gefunden',
                   '',
                   '');

  sprach_eintrag04('Die_Programmdateien',
                   'the executables',
                   'Die Programmdateien',
                   '',
                   '');

  (*$IFDEF DOS*)
  sprach_eintrag04('hilfe_Die_Programmdateien_bp7diet_1',
                   '˛ are compiled with Borland Pascal 7.01 with option $G+ and',
                   '˛ sind mit Borland Pascal 7.01 mit Schalter $G+ compiliert und',
                   '',
                   '');

  sprach_eintrag04('hilfe_Die_Programmdateien_bp7diet_2',
                   '  therfor run only on 80286+',
                   '  sind deshalb nur auf 80286+ lauffÑhig',
                   '',
                   '');

  sprach_eintrag04('hilfe_Die_Programmdateien_bp7diet_3',
                   '˛ use the improved System.tpu from BPLN16',
                   '˛ Verwenden die Laufzeitbibliothek aus BPLN16',
                   '',
                   '');

  sprach_eintrag04('hilfe_Die_Programmdateien_bp7diet_4',
                   '  by Norbert Juffa',
                   '  von Norbert Juffa',
                   '',
                   '');

  sprach_eintrag04('hilfe_Die_Programmdateien_bp7diet_5',
                   '˛ are compressed with diet 1.45f / Teddy Matsumoto',
                   '˛ sind mit Diet 1.45f / Teddy Matsumoto komprimiert',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF OS2*)
  sprach_eintrag04('hilfe_Die_Programmdateien_vp11lxlite118_1',
                   '˛ compiled with Virtual Pascal 2.10  / vpascal.com ',
                   '˛ sind mit Virtual Pascal 2.10 / vpascal.com compiliert',
                   '',
                   '');

  sprach_eintrag04('hilfe_Die_Programmdateien_vp11lxlite118_2',
                   '˛ compressed with LxLite 1.2.1 / Andrew Zabolotny',
                   '˛ sind mit LxLite 1.2.1 / Andrew Zabolotny komprimiert',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DPMI32*)
  sprach_eintrag04('hilfe_Die_Programmdateien_vp20_dpmi32_1',
                   '˛ compiled with Virtual Pascal 2.10 / vpascal.com [DPMI32:VK]',
                   '˛ sind mit Virtual Pascal 2.10 / vpascal.com compiliert [DPMI32:VK]',
                   '',
                   '');

  sprach_eintrag04('hilfe_Die_Programmdateien_vp20_dpmi32_2',
                   '˛ you may compress the file and/or bind an other extender',
                   '˛ Sie kînnen Typ3 Komprimieren oder/und den DOS-Extender wechseln',
                   '',
                   '');
  (*$ENDIF*)

  sprach_eintrag04('hilfe_Die_Programmdateien_veraenderungen_1',
                   '  you may decompress and modify',
                   '  Entpacken und VerÑndern ist erlaubt',
                   '',
                   '');

  sprach_eintrag04('hilfe_Die_Programmdateien_veraenderungen_2',
                   '  transfer only unmodified',
                   '  Weitergabe nur im unveraenderten Zustand',
                   '',
                   '');


  sprach_eintrag04('Vorhaben',
                   'plans',
                   'Vorhaben',
                   '',
                   '');

  sprach_eintrag04('hilfe_Vorhaben_1',
                   'at moment nothing special',
                   'zur Zeit nichts besonderes',
                   '',
                   '');

  sprach_eintrag04('hilfe_Vorhaben_2',
                   'i am looking for filedescriptions of',
                   'Ich suche Beschreibungen der Dateiformate von',
                   '',
                   '');

  sprach_eintrag04('Programmaktualisierung',
                   '',
                   'Programmaktualisierung',
                   '',
                   '');

  sprach_eintrag04('hilfe_Programmaktualisierung_1',
                   'Please send error errors/problems with files new bios versions',
                   'Bitte sende Berichte Åber aufgetretene Fehler, Probleme mit Dateien,',
                   '',
                   '');

  sprach_eintrag04('hilfe_Programmaktualisierung_2',
                   'or other improvment suggestions to me',
                   'neue BIOS-Versionen und andere VerbesserungsvorschlÑge an mich!',
                   '',
                   '');

  sprach_eintrag04('hilfe_Programmaktualisierung_3',
                   'i will try to improve this programm',
                   'Ich werde weiter versuchen mein Programm zu verbessern.',
                   '',
                   '');

  sprach_eintrag04('hilfe_Programmaktualisierung_4',
                   'it has cost me >1000 hours',
                   'Es hat mich bereits Åber 1000 Stunden gekostet',
                   '',
                   '');

  sprach_eintrag04('hilfe_Programmaktualisierung_5',
                   'so 100 hours does not matter ...',
                   'da kommt es auf 100 auch nicht mehr an ...',
                   '',
                   '');

  sprach_eintrag04('hilfe_Programmaktualisierung_6',
                   'to receive updates mail me!',
                   'schicken Sie mir Post um immer aktuelle Versionen zu haben!',
                   '',
                   '');

  sprach_eintrag04('hilfe_Programmaktualisierung_7',
                   'if you wish translate the program .. very easy',
                   'Wer mîchte Programmteile in eine dritte Sprache Åbersetzen?',
                   '',
                   '');

  sprach_eintrag04('Erreichbarkeit',
                   'reachability',
                   'Erreichbarkeit',
                   '',
                   '');

  sprach_eintrag04('_254_persoenlich',
                   '˛ personal',
                   '˛ persînlich',
                   '',
                   '');

  sprach_eintrag04('_254_ueber_Internet',
                   '˛ internet',
                   '˛ Åber Internet',
                   '',
                   '');

  sprach_eintrag04('_254_Telefon',
                   '˛ telephone',
                   '˛ Telefon',
                   '',
                   '');

  sprach_eintrag04('Ende_der_Hilfe',
                   '±≤ end of help ≤±≤',
                   '± Ende der Hilfe ≤',
                   '',
                   '');

  schreibe_sprach_datei('$$$_hilf.001','$$$_hilf.002','sprach_modul_typ_hilf','sprach_start_typ_hilf','^string');
end.
