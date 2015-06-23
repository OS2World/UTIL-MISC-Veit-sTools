program typsprache_def_eiau;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  (*$IFDEF DOS*)
  sprach_eintrag04('eiau__Pause_weiter_mit_Tastendruck',
                   'pause... continue with keypress >>>',
                   'Pause... weiter mit Tastendruck >>>',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DPMI32*)
  sprach_eintrag04('eiau__Pause_weiter_mit_Tastendruck',
                   'pause... continue with keypress >>>',
                   'Pause... weiter mit Tastendruck >>>',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF OS2*)
  sprach_eintrag04('eiau__Pause_Aufruf_der_Fensterliste_mit_Strg_Esc_Weiter_mit',
                   'Pause .... call task list with [Strg]-[Esc], continue with [ÄÙ]',
                   'Pause .... Aufruf der Fensterliste mit [Strg]-[Esc], Weiter mit [ÄÙ]',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DOS*)
  sprach_eintrag04('eiau__Beim_direkten_Lesen_der_Festplatte_hat_jemand_gemogelt',
                   'during direct read of hard disk someone has cheatet!',
                   'Beim direkten Lesen der Festplatte hat jemand gemogelt!',
                   '',
                   '');

  sprach_eintrag04('eiau__Platte_PORT',
                   'disk-direct-port-access',
                   'Platte-PORT',
                   '',
                   '');

  sprach_eintrag04('eiau__Platte_INT_13',
                   'disk INT $13',
                   'Platte-INT $13',
                   '',
                   '');

  sprach_eintrag04('eiau__Platte_INT_13_EXT',
                   'disk INT $13 (extended)',
                   'Platte-INT $13 (erweitert)',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DPMI32*)
  sprach_eintrag04('eiau__Platte_INT_13',
                   'disk INT $13',
                   'Platte-INT $13',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF OS2*)
  sprach_eintrag04('eiau__Partitionierbare_Platten_IOCTL',
                   'disk(partition)-IOCTL',
                   'Partitionierbare Platten-IOCTL',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DOS*)
  sprach_eintrag04('eiau__Platte_DOS',
                   'disk-DOS',
                   'Platte-DOS',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF DPMI32*)
  sprach_eintrag04('eiau__Platte_DOS',
                   'disk-DOS',
                   'Platte-DOS',
                   '',
                   '');
  (*$ENDIF*)

  (*$IFDEF OS2*)
  sprach_eintrag04('eiau__Platte_OS2',
                   'disk-OS/2',
                   'Platte-OS/2',
                   '',
                   '');
  (*$ENDIF*)

  sprach_eintrag04('eiau__Fehler_leer_anf',
                   'error "',
                   'Fehler "',
                   '',
                   '');

  sprach_eintrag04('eiau__anf_leer_beim_oeffnen',
                   '" on open!',
                   '" beim ™ffnen!',
                   '',
                   '');

  sprach_eintrag04('eiau__anf_leer_beim_Bestimmen_der_Groesse',
                   '" on determine filesize!',
                   '" beim Bestimmen der Gr”áe!',
                   '',
                   '');

  sprach_eintrag04('eiau__Positionierungsfehler_leer_anf',
                   'seek error "',
                   'Positionierungsfehler "',
                   '',
                   '');

  sprach_eintrag04('eiau__anf_leer_auf',
                   '" to ',
                   '" auf ',
                   '',
                   '');

  sprach_eintrag04('eiau__Lesefehler_leer_anf',
                   'read error "',
                   'Lesefehler "',
                   '',
                   '');

  sprach_eintrag04('eiau__anf_leer_bei_Position',
                   '" at position ',
                   '" bei Position ',
                   '',
                   '');

  sprach_eintrag04('eiau__Datei_leer_klammer',
                   'file (',
                   'Datei (',
                   '',
                   '');

  sprach_eintrag04('eiau__anf_leer_beim_Schliessen',
                   '" on close!',
                   '" beim Schlieáen!',
                   '',
                   '');

  sprach_eintrag04('eiau__Speicher_leer_klammer',
                   'memory (',
                   'Speicher (',
                   '',
                   '');

  sprach_eintrag04('eiau__anf_leer_beim_Laden_der_EA',
                   '" on load of EA',
                   '" beim Laden der EA',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
   }
  schreibe_sprach_datei('$$$_eiau.001','$$$_eiau.002','sprach_modul_typ_eiau','sprach_start_typ_eiau','^string');
end.

