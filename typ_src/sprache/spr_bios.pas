program typsprache_def_bios;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('konnte_nicht_in_angemessener_Zeit_ermittelt_werden',
                   'cold not detemnine in reasonable time',
                   'konnte nicht in angemessener Zeit ermittelt werden',
                   '',
                   '');

  sprach_eintrag04('Taste_mit_Scancode',
                   '[key with scancode ',
                   '[Taste mit Scancode ',
                   '',
                   '');

  sprach_eintrag04('gefunden_fuer',
                   'found for ',
                   'gefunden fÅr ',
                   '',
                   '');

  sprach_eintrag04('z_punkt_b_punkt_doppelpunkt_',
                   'for example: ',
                   'z.B.: ',
                   '',
                   '');

  sprach_eintrag04('universell',
                   'universal',
                   'allgemein',
                   '',
                   '');

  sprach_eintrag04('Fehler_bei_Bestimmung_des_Kennwortes',
                   'error determing pasword',
                   'Fehler bei Bestimmung des Kennwortes',
                   '',
                   '');

  sprach_eintrag04('noch_keins_mit_Kennwort_gefunden',
                   'still yet nothing with pasword found',
                   'noch keins mit Kennwort gefunden',
                   '',
                   '');

  sprach_eintrag04('noch_nicht_entschluesselt',
                   'not yet decrypted',
                   'noch nicht entschlÅsselt',
                   '',
                   '');

  sprach_eintrag04('bios__unbekannter_Hersteller',
                   'unknown manufacturer',
                   'unbekannter Hersteller ',
                   '',
                   '');

  sprach_eintrag04('Bitte_schicken_Sie_mir_diese_Datei',
                   '*** Please send this file to me!',
                   '*** Bitte schicken Sie mir diese Datei!',
                   '',
                   '');

  sprach_eintrag04('Bitte_starten_Sie',
                   '*** Please run ',
                   '*** Bitte starten Sie ',
                   '',
                   '');

  sprach_eintrag04('und_leerzeichen',
                   'and ',
                   'und ',
                   '',
                   '');

  sprach_eintrag04('schicken_Sie_mir_die_erzeuget_Datei_BIOSCMOS_DAT',
                   '*** send the created BIOSCMOS.DAT to me!',
                   '*** schicken Sie mir die erzeuget Datei BIOSCMOS.DAT!',
                   '',
                   '');

  sprach_eintrag04('ungueltig_durch_Speicherverwaltung_verdeckt',
                   'invalid! ( hided by memory manger? )',
                   'ungÅltig! ( durch Speicherverwaltung verdeckt? )',
                   '',
                   '');

  sprach_eintrag04('Chipsatz',
                   'chipset ',
                   'Chipsatz ',
                   '',
                   '');

  sprach_eintrag04('Markierung',
                   'mark ',
                   'Markierung ',
                   '',
                   '');

  sprach_eintrag04('bios__bei',
                   'at',
                   'bei',
                   '',
                   '');

  sprach_eintrag04('verdeckt_durch',
                   'hided by ',
                   'verdeckt durch ',
                   '',
                   '');

  sprach_eintrag04('Kennwortbestimmung_nicht_moeglich',
                   'pasword determination not possible!',
                   'Kennwortbestimmung nicht mîglich!',
                   '',
                   '');

  sprach_eintrag04('Suche_noch_Rechner_fuer_Chipsatz_und_Kennwort',
                   'still looking for real computer for chipset and pasword',
                   'Suche noch Rechner fÅr Chipsatz und Kennwort',
                   '',
                   '');

  sprach_eintrag04('bios__BENUTZER',
                   'USER:',
                   'BENUTZER:',
                   '',
                   '');

  sprach_eintrag04('bios__eckauf_BIOS_Hersteller_Chipsatz_und_Kennwort_eckzu',
                   '[BIOS manufacturer, chipset and password]',
                   '[BIOS Hersteller, Chipsatz und Kennwort]',
                   '',
                   '');

  sprach_eintrag04('bios__Fuell_byte2',
                   'fill-byte',
                   'FÅll-Byte',
                   '',
                   '');

  (*sprach_eintrag04('bios__Fassung',
                   'version',
                   'Fassung',
                   '',
                   '');*)

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }
  schreibe_sprach_datei('$$$_bios.001','$$$_bios.002','sprach_modul_typ_bios','sprach_start_typ_bios','^string');
end.

