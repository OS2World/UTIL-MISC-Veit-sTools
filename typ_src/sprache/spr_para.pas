program typsprache_def_para;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('para__ungueltiger_Schalter_doppelpunkt_minus',
                   'invald switch: -',
                   'ungÅltiger Schalter: -',
                   '',
                   '');

  sprach_eintrag04('para__ungueltiger_Parameter',
                   'invalid switch',
                   'ungÅltiger Parameter',
                   '',
                   '');

  sprach_eintrag04('para__Fehler_beim_OEffenen_der_Farbtabelle',
                   'error on opening color table',
                   'Fehler beim ôffenen der Farbtabelle',
                   '',
                   '');

  sprach_eintrag04('para__Fehler_beim_Lesen_der_Farbtabelle',
                   'error on reading color table',
                   'Fehler beim Lesen der Farbtabelle',
                   '',
                   '');

  sprach_eintrag04('para__Es_ist_unlogisch_dass_ein_Parameter_der_Form_Zxx_nicht_4_Zeichen_lang_ist',
                   'parameter -Zxx should be 4 chars long!',
                   'Es ist unlogisch da· ein Parameter der Form -Zxx nicht 4 Zeichen lang ist!',
                   '',
                   '');

  sprach_eintrag04('para__scheint_kein_gueltiger_Zahlenwert_zu_sein',
                   ' is not a valid numeric value',
                   ' scheint kein gÅltiger Zahlenwert zu sein.',
                   '',
                   '');

  sprach_eintrag04('para__Unbekannter_Parameter',
                   'unknown parameter',
                   'Unbekannter Parameter',
                   '',
                   '');

  schreibe_sprach_datei('$$$_para.001','$$$_para.002','sprach_modul_typ_para','sprach_start_typ_para','^string');
end.

