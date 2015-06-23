program typsprache_def_ein;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('ein__aus',
                   'off',
                   'aus',
                   '',
                   '');

  sprach_eintrag04('ein__ein',
                   'on ',
                   'ein',
                   '',
                   '');

  sprach_eintrag04('ein__Pfadauswahl_fuer',
                   'choice of path for ',
                   'Pfadauswahl fÅr ',
                   '',
                   '');

  sprach_eintrag04('ein__Bitte_dieses',
                   '<-recommend!',
                   'Bitte dieses!',
                   '',
                   '');

  sprach_eintrag04('ein__In_welchem_Pfad',
                   'in with path',
                   'In welchem Pfad',
                   '',
                   '');

  sprach_eintrag04('ein__darf_ich',
                   'may i ',
                   'darf ich ',
                   '',
                   '');

  sprach_eintrag04('ein__anlegen',
                   ' create? ',
                   ' anlegen? ',
                   '',
                   '');

  sprach_eintrag04('ein__Auslesen_von',
                   'reading ',
                   'Auslesen von ',
                   '',
                   '');

  sprach_eintrag04('ein__Schreiben_von',
                   'writing ',
                   'Schreiben von ',
                   '',
                   '');

  sprach_eintrag04('ein__REXX_reserviert_Zeile_nicht_entfernen',
                   '/* reserved line * please do not remove */',
                   '/* reserviert Zeile * nicht entfernen */',
                   '',
                   '');

  sprach_eintrag04('ein__REM_reserviert_Zeile_nicht_entfernen',
                   'REM * reserved line * please do not remove *',
                   'REM * reserviert Zeile * nicht entfernen *',
                   '',
                   '');

  sprach_eintrag04('ein__Einrichtungsprogramm_zu_Typ',
                   'config program for Typ',
                   'Einrichtungsprogramm zu Typ',
                   '',
                   '');

  sprach_eintrag04('ein__Abbruch_doppelpunkt',
                   'abort : ',
                   'Abbruch : ',
                   '',
                   '');

  sprach_eintrag04('ein__nicht_im_aktuellen_Verzeichnis',
                   ' not in current directory!',
                   ' nicht im aktuellen Verzeichnis!',
                   '',
                   '');

  sprach_eintrag04('ein__Dies_ist_kein_Kopierprogramm_Wollen_Sie_TYP_immer_von_Laufwerk',
                   ' This is not not a copy-program! Do You allways want start TYP of drive ',
                   ' Dies ist kein Kopierprogramm! Wollen Sie TYP immer von Laufwerk ',
                   '',
                   '');

  sprach_eintrag04('ein__doppelpunkt_starten_frage',
                   ': ?',
                   ': starten?',
                   '',
                   '');

  sprach_eintrag04('ein__JN',
                   ' Y/N : ',
                   ' J/N : ',
                   '',
                   '');

  sprach_eintrag04('ein__Dann_kopiern_Sie_mich_auf_die_Festplatte',
                   'then copy me to harddisk!',
                   'Dann kopiern Sie mich auf die Festplatte!',
                   '',
                   '');

  sprach_eintrag04('ein__Unterverzeichnisse_fuell',
                   'subdirectorys         ',
                   'Unterverzeichnisse    ',
                   '',
                   '');

  sprach_eintrag04('ein__Partitionstabelle_fuell',
                   'partition table       ',
                   'Partitionstabelle     ',
                   '',
                   '');

  sprach_eintrag04('ein__Startsektoren_fuell',
                   'boot sectors          ',
                   'Startsektoren         ',
                   '',
                   '');

  sprach_eintrag04('ein__Langformat_fuell',
                   'verbose format        ',
                   'Langformat            ',
                   '',
                   '');

  sprach_eintrag04('ein__Bildschirm_fuell',
                   'screen                ',
                   'Bildschirm            ',
                   '',
                   '');

  sprach_eintrag04('ein__hexadezimal_fuell',
                   'hexadecimal numbers   ',
                   'hexadezimale Zahlen   ',
                   '',
                   '');

  sprach_eintrag04('ein__Mausbenutzung_fuell',
                   'mouse usage           ',
                   'Mausbenutzung         ',
                   '',
                   '');

    (*$IFDEF DOS*)
  sprach_eintrag04('ein__Spielhebelbenutzung_fuell',
                   'joystick usage        ',
                   'Spielhebelbenutzung   ',
                   '',
                   '');

  sprach_eintrag04('ein__direkter_IDE_Zugriff_fuell',
                   'direct IDE access     ',
                   'direkter IDE-Zugriff  ',
                   '',
                   '');
    (*$ENDIF*)

  sprach_eintrag04('ein__Farbtabelle_benutzen_fuell',
                   'use color table       ',
                   'Farbtabelle benutzen  ',
                   '',
                   '');

    (*$IFDEF DOS*)
  sprach_eintrag04('ein__EMS_Obergrenze_fuell',
                   'upper limit EMS-usage ',
                   'EMS-Obergrenze        ',
                   '',
                   '');

  sprach_eintrag04('ein__XMS_Obergrenze_fuell',
                   'upper limit XMS-usage ',
                   'XMS-Obergrenze        ',
                   '',
                   '');
    (*$ENDIF*)

    (*$IFDEF OS2*)
  sprach_eintrag04('ein__RAM_Obergrenze_fuell',
                   'upper memory limit    ',
                   'RAM-Obergrenze        ',
                   '',
                   '');


  sprach_eintrag04('ein__EAS_anzeigen_fuell',
                   'display EA'#39's          ',
                   'EA anzeigen           ',
                   '',
                   '');
    (*$ENDIF*)

    (*$IFDEF DPMI32*)
  sprach_eintrag04('ein__RAM_Obergrenze_fuell',
                   'upper memory limit    ',
                   'RAM-Obergrenze        ',
                   '',
                   '');
    (*$ENDIF*)

    (*$IFDEF Win32*)
  sprach_eintrag04('ein__RAM_Obergrenze_fuell',
                   'upper memory limit    ',
                   'RAM-Obergrenze        ',
                   '',
                   '');
    (*$ENDIF*)

    (*$IFDEF Linux*)
  sprach_eintrag04('ein__RAM_Obergrenze_fuell',
                   'upper memory limit    ',
                   'RAM-Obergrenze        ',
                   '',
                   '');
    (*$ENDIF*)

  sprach_eintrag04('ein__cpu_emulator',
                   'CPU-emulator          ',
                   'CPU-Emulator          ',
                   '',
                   '');

  sprach_eintrag04('ein__resource_anzeigen',
                   'list resource table   ',
                   'Resourcen anzeigen    ',
                   '',
                   '');

  sprach_eintrag04('ein__ico_anzeigen',
                   'display icons         ',
                   'Symbole anzeigen      ',
                   '',
                   '');



  sprach_eintrag04('ein__Zeilenzahl_fuell',
                   'lines                 ',
                   'Zeilenzahl            ',
                   '',
                   '');

  sprach_eintrag04('ein__Farbtabelle_erstellen',
                   'create color table',
                   'Farbtabelle erstellen',
                   '',
                   '');

  sprach_eintrag04('ein__Programmabbruch',
                   'exit without save',
                   'Programmabbruch',
                   '',
                   '');

  sprach_eintrag04('ein__Speichern',
                   'save and exit',
                   'Speichern',
                   '',
                   '');

  sprach_eintrag04('ein__Farbtabellenname_alt',
                   '   color table? (old:',
                   '   Farbtabellenname? (alt:',
                   '',
                   '');

  sprach_eintrag04('ein__Obergrenze_Nutzung_EMS_KB_alt',
                   '   upper limit EMS usage (KB)? (old:',
                   '   Obergrenze Nutzung EMS (KB)? (alt:',
                   '',
                   '');

    (*$IFDEF DOS*)
  sprach_eintrag04('ein__Obergrenze_Nutzung_XMS_KB_alt',
                   '   upper limit XMS usage (KB)? (old:',
                   '   Obergrenze Nutzung XMS (KB)? (alt:',
                   '',
                   '');
    (*$ENDIF*)
    (*$IFDEF OS2*)
  sprach_eintrag04('ein__Obergrenze_Nutzung_RAM_KB_alt',
                   '   upper limit memory usage (KB)? (old:',
                   '   Obergrenze Nutzung RAM (KB)? (alt:',
                   '',
                   '');
    (*$ENDIF*)
    (*$IFDEF DPMI32*)
  sprach_eintrag04('ein__Obergrenze_Nutzung_RAM_KB_alt',
                   '   upper limit memory usage (KB)? (old:',
                   '   Obergrenze Nutzung RAM (KB)? (alt:',
                   '',
                   '');
    (*$ENDIF*)
    (*$IFDEF Linux*)
  sprach_eintrag04('ein__Obergrenze_Nutzung_RAM_KB_alt',
                   '   upper limit memory usage (KB)? (old:',
                   '   Obergrenze Nutzung RAM (KB)? (alt:',
                   '',
                   '');
    (*$ENDIF*)
    (*$IFDEF Win32*)
  sprach_eintrag04('ein__Obergrenze_Nutzung_RAM_KB_alt',
                   '   upper limit memory usage (KB)? (old:',
                   '   Obergrenze Nutzung RAM (KB)? (alt:',
                   '',
                   '');
    (*$ENDIF*)

  sprach_eintrag04('ein__gewuenschte_Bildschirmdarstellung_80_Spalten_2528435060_Zeilen',
                   '   desired screen display? 80 columns, 25,28,43,50,60 lines?'^m^j
                  +'   (00=do not change row count)',
                   '   gewÅnschte Bildschirmdarstellung? 80 Spalten, 25,28,43,50,60 Zeilen?'^m^j
                  +'   (00=benutze vorhandene Bildschirmeinstellung)',
                   '',
                   '');

  sprach_eintrag04('ein__Abbruch',
                   'abort ...',
                   'Abbruch ...',
                   '',
                   '');

  sprach_eintrag04('ein__erfolgreicher_Abschluss',
                   'successful exit',
                   'erfolgreicher Abschlu·.',
                   '',
                   '');

  sprach_eintrag04('ein__Hilfe_doppelpunkt_anf',
                   'help          : "',
                   'Hilfe         : "',
                   '',
                   '');

  sprach_eintrag04('ein__Programmstart_doppelpunkt_anf',
                   'program start : "',
                   'Programmstart : "',
                   '',
                   '');



  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  }
  schreibe_sprach_datei('$$$_ein.001','$$$_ein.002','sprach_modul_typ_ein','sprach_start_typ_ein','^string');
end.

