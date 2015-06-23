program typsprache_def_poly;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  (* aus TYP_POLY.PAS, TYP_POEM.PAS und TYP_EXE.PAS *)
  sprach_eintrag04('unbekannte_Relokations_Kompression',
                   'unknown relocation-compression',
                   'unbekannte Relokations-Kompression',
                   '',
                   '');

  sprach_eintrag04('Verschluesselung',
                   'decryption',
                   'VerschlÅsselung',
                   '',
                   '');

  sprach_eintrag04('Abfrage_der_DOS_Version',
                   'query of DOS-version',
                   'Abfrage der DOS-Version',
                   '',
                   '');

  sprach_eintrag04('OS2_Installationstest',
                   'OS/2 install check',
                   'OS/2 Installationstest',
                   '',
                   '');

  sprach_eintrag04('OS2_Virtuelle_Maschine_beenden',
                   'OS/2 terminate virtual machine',
                   'OS/2 Virtuelle Maschine beenden',
                   '',
                   '');

  sprach_eintrag04('Maustreiber',
                   'mouse driver',
                   'Maustreiber',
                   '',
                   '');

  sprach_eintrag04('modifiziertes',
                   'modified',
                   'modifiziertes',
                   '',
                   '');

  sprach_eintrag04('Vermutung',
                   'suppostion',
                   'Vermutung',
                   '',
                   '');

  sprach_eintrag04('poly__unbekannte_Kompression',
                   'unknown exe-compressor',
                   'unbekannte Kompression',
                   '',
                   '');

  sprach_eintrag04('poly__TSR_Mechanismus',
                   'TSR-mechanism',
                   'TSR-Mechanismus',
                   '',
                   '');

  sprach_eintrag04('poly__wahrscheinlich',
                   'likely',
                   'wahrscheinlich',
                   '',
                   '');

  sprach_eintrag04('poly__moeglicherweise',
                   'possibly',
                   'mîglicherweise',
                   '',
                   '');

  sprach_eintrag04('poly__leer_komprimiert',
                   ' compressed',
                   ' komprimiert',
                   '',
                   '');

  sprach_eintrag04('fuer',
                   'for',
                   'fÅr',
                   '',
                   '');

  sprach_eintrag04('schritt_',
                   'step ',
                   'Schritt ',
                   '',
                   '');

  sprach_eintrag04('speichermangel',
                   'out of memory - use 386 DOS or OS/2 version of Typ!',
                   'Speichermangel - Benutzen Sie die 386 DOS oder OS/2 Version von Typ!',
                   '',
                   '');

  sprach_eintrag04('ausfueren__',
                   'Exec "',
                   'AusfÅhren von "',
                   '',
                   '');

  sprach_eintrag04('poem_datei_oeffnen',
                   'open file : "',
                   'ôffnen der Datei "',
                   '',
                   '');

  sprach_eintrag04('poem__create_file',
                   'create file "',
                   'Erzeugen der Datei "',
                   '',
                   '');

  sprach_eintrag04('poem__create_new_file',
                   'create new file "',
                   'Erzeugen der neuen datei "',
                   '',
                   '');
  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }
  schreibe_sprach_datei('$$$_poly.001','$$$_poly.002','sprach_modul_typ_poly','sprach_start_typ_poly','^string');
end.
