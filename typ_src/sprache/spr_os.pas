program typsprache_def_os;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  (* aus TYP_OS.PAS *)
  sprach_eintrag04('bei',
                   'at',
                   'bei',
                   '',
                   '');

  sprach_eintrag04('hat_mir_im_Speicher_geantwortet',
                   'has responded in memory!',
                   'hat mir im Speicher geantwortet!',
                   '',
                   '');

  sprach_eintrag04('Systemuntersuchung',
                   '[system analysis]',
                   '[Systemuntersuchung]',
                   '',
                   '');

  sprach_eintrag04('ungueltiges_Systemdatum',
                   'invalid system date',
                   'ungltiges Systemdatum',
                   '',
                   '');

  sprach_eintrag04('Erweiterter_Bios_Datenbereich_bei',
                   'extended BIOS data area at ',
                   'Erweiterter Bios Datenbereich bei ',
                   '',
                   '');

  sprach_eintrag04('Grundspeicher_bis',
                   'main memory : up to ',
                   'Grundspeicher : bis ',
                   '',
                   '');


  sprach_eintrag04('Dem_BIOS_wurden',
                   'BIOS lacks ',
                   'Dem BIOS wurden ',
                   '',
                   '');

  sprach_eintrag04('KB_gestohlen',
                   ' KB!',
                   ' KB gestohlen!',
                   '',
                   '');

  sprach_eintrag04('Speicherauszug_bei',
                   '[memory dump ',
                   '[Speicherauszug bei ',
                   '',
                   '');


  sprach_eintrag04('Dem_DOS_wurden',
                   'DOS lack',
                   'Dem DOS wurden ',
                   '',
                   '');

  sprach_eintrag04('Speichereinheiten_klammer',
                   ' memory blocks = ',
                   ' Speichereinheiten = ',
                   '',
                   '');

  sprach_eintrag04('unbekannt',
                   'unknown',
                   'unbekannt',
                   '',
                   '');

  sprach_eintrag04('Speicher_Untersuchung',
                   'memory analysis',
                   'Speicher-Untersuchung',
                   '',
                   '');

  sprach_eintrag04('Partitionstabelle_von_Festplatte',
                   '[partition table of harddisk ',
                   '[Partitionstabelle von Festplatte ',
                   '',
                   '');

  sprach_eintrag04('Partitionstabelle_der',
                   '[partition table of ',
                   '[Partitionstabelle der ',
                   '',
                   '');

  sprach_eintrag04('partitionierbaren_Platte',
                   '. partitionable disk]',
                   '. partitionierbaren Platte]',
                   '',
                   '');

  sprach_eintrag04('nicht_vorhanden',
                   'does not exist',
                   'nicht vorhanden',
                   '',
                   '');

  (*$IFDEF DOS*)
  sprach_eintrag04('OS2_oder_TaskMrg_nicht_installiert',
                   ' OS/2 or TaskMgr not installed',
                   ' OS/2 oder TaskMrg nicht installiert',
                   '',
                   '');

  sprach_eintrag04('kein_Platz_fuehr_Prozess_mehr',
                   ' no more space for processes',
                   ' kein Platz fr Prozess mehr',
                   '',
                   '');
  (*$ENDIF*)

  sprach_eintrag04('Programm_laeuft',
                   ' program runs ...',
                   ' Programm l„uft ...',
                   '',
                   '');

  (*$IFDEF OS2*)
  sprach_eintrag04('Fehler_beim_Anlegen_des_Hintergrundprozesses',
                   ' error creating background process',
                   ' Fehler beim Anlegen des Hintergrundprozesses',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DPMI32*)
  sprach_eintrag04('OS2_oder_TaskMrg_nicht_installiert',
                   ' OS/2 or TaskMgr not installed',
                   ' OS/2 oder TaskMrg nicht installiert',
                   '',
                   '');
  (*$ENDIF*)

  sprach_eintrag04('Hintergundsuche',
                   'background search',
                   'Hintergundsuche',
                   '',
                   '');

  sprach_eintrag04('Selbsttest',
                   '[self check]',
                   '[Selbsstest]',
                   '',
                   '');

  sprach_eintrag04('Fehler_anfuerungszeichen',
                   'error "',
                   'Fehler "',
                   '',
                   '');

  sprach_eintrag04('TYP_EXE_ist_veraendert_Selbsttest',
                   'şúşúşúşúşúşúşúş TYP.EXE is modified! şúşúşúşúşúşúşúşúş',
                   'şúşúşúşúşúşúşúş TYP.EXE ist ver„ndert! şúşúşúşúşúşúşúşúş',
                   '',
                   '');

  sprach_eintrag04('os__zyl_koepfe_sekt',
                   ' cyl/heads/sect]',
                   ' Zyl/K”pfe/Sekt]',
                   '',
                   '');

  sprach_eintrag04('funktion_nicht_implementiert',
                   'function not implemented for this target.',
                   'Funktion ist fr diese Plattform nicht implementiert.',
                   '',
                   '');


  schreibe_sprach_datei('$$$_os.001','$$$_os.002','sprach_modul_typ_os','sprach_start_typ_os','^string');
end.

