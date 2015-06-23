program typsprache_def_varx;
(* V.K. 01.12.1996 *)

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf2;

  (* aus TYP_VARX.PAS *)
  sprach_eintrag04('aus_attr_namen',
                   'normal',
                   'normal',
                   '',
                   '');

  sprach_eintrag04('',
                   'compiler',
                   'Compiler',
                   '',
                   '');

  sprach_eintrag04('',
                   'archiver',
                   'Archivprogramme',
                   '',
                   '');

  sprach_eintrag04('',
                   'exe-compressor',
                   'Laufzeitkomprimierer',
                   '',
                   '');

  sprach_eintrag04('',
                   'sound ang graphic',
                   'Ton und Grafik',
                   '',
                   '');

  sprach_eintrag04('',
                   'overlays and fragments',
                   'Overlay und BruchstÅcke',
                   '',
                   '');

  sprach_eintrag04('',
                   'file errors',
                   'Dateifehler',
                   '',
                   '');

  sprach_eintrag04('',
                   'viruses',
                   'Viren',
                   '',
                   '');

  sprach_eintrag04('',
                   'DOS, Windows, OS/2, DOS-extender',
                   'DOS, Windows, OS/2, DOS-Extender',
                   '',
                   '');

  sprach_eintrag04('',
                   'descriptions',
                   'Beschreibungen',
                   '',
                   '');

  sprach_eintrag04('',
                   'sign',
                   'Signatur',
                   '',
                   '');

  sprach_eintrag04('',
                   'librarys',
                   'Bibliotheken',
                   '',
                   '');

  sprach_eintrag04('',
                   'savegames',
                   'SpielstÑnde',
                   '',
                   '');

  sprach_eintrag04('',
                   'colourless',
                   'farblos',
                   '',
                   '');

  sprach_eintrag04('',
                   'status line',
                   'Statuszeile',
                   '',
                   '');

  schreibe_sprach_datei('$$$_var1.001','$$$_var1.002','sprach_modul_typ_var1','sprach_start_typ_var1','aus_attr_namen_typ');

  (*----------------------------------------------------------------------*)

  sprkopf;

  sprach_eintrag04('varx__16_16_Farben_EGA_VGA_mit_punktweisem_Rollen',
                   '16*16 colors EGA/VGA (smooth scroll)',
                   '16*16 Farben EGA/VGA (mit punktweisem Rollen)',
                   '',
                   '');

  sprach_eintrag04('varx__16_16_Farben_CGA_schnell',
                   '16*16 colors CGA+    (fast)',
                   '16*16 Farben CGA+    (schnell)',
                   '',
                   '');

  sprach_eintrag04('varx__16_16_Farben_Ansi_lahm',
                   '16*16 colors Ansi    (slow)',
                   '16*16 Farben Ansi    (lahm)',
                   '',
                   '');

  sprach_eintrag04('varx__2_2_Farbe_Ascii_maessig',
                   ' no   colors Ascii   (medium)',
                   ' farblos     Ascii   (mÑ·ig)',
                   '',
                   '');

  sprach_eintrag04('varx__2_2_Farben_Ascii_gefiltert',
                   ' no   colors Ascii   (filtered)',
                   ' farblos     Ascii   (gefiltert)',
                   '',
                   '');

  sprach_eintrag04('varx__html_mono',
                   ' no   colors HTML    (file output)',
                   ' farblos     HTML    (fÅr Dateiausgabe)',
                   '',
                   '');
    {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
    }
  schreibe_sprach_datei('$$$_var2.001','$$$_var2.002','sprach_modul_typ_var2','sprach_start_typ_var2','^string');


end.
