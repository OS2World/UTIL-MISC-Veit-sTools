program ppm_xgad;

uses spr2_ein;

begin
  sprachtabellenkopf(
                    +'EN'
                    +'DE'
                    +''
                    +''
                    +''
                    +''
                    +''
                    +''
                    +'');

  sprach_eintrag08('unerwartetes_Dateiende',
                   'premature end of file!',
                   'unerwartetes Dateiende!',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('Keine_gueltige_Zahl',
                   'Invalid number!',
                   'Keine gÅltige Zahl!',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('benutzung1',
                   'Convert portable pixmap to save2dsk.xga (phoenix PHDISK)',
                   'Wandelt portable pixmap in save2dsk.xga-Format (phoenix PHDISK) um',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('benutzung2',
                   'Usage: PPM_XGA <save2dsk.ppm> <save2dsk.xga>',
                   'Benutzung: PPM_XGA <save2dsk.ppm> <save2dsk.xga>',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('Kein_PPM_P3',
                   'Source is not PPM (P3)!',
                   'Quelldatei ist kein PPM(P3)!',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('Warning__recommended_sizes_are_800_600__maybe_640_480_and_1024_768__',
                   'Warning: recommended sizes are 800*600 (maybe 640*480 and 1024*768)!',
                   'Warnung: Empfohlen sind Bildgrî·en von 800*600 (oder 640*480 und 1024*768)!',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('BAR_position_X',
                   'BAR position X',
                   'Fortschrittsbalken erste Spalte',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('BAR_position_Y',
                   'BAR position Y',
                   'Fortschrittsbalken erste Zeile',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('BAR_size_X',
                   'BAR size X',
                   'Fortschrittsbalken Breite',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('BAR_size_Y',
                   'BAR size Y',
                   'Fortschrittsbalken Hîhe  ',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('BAR_progress_color_RED__',
                   'BAR progress color RED  ',
                   'Fortschrittsbalken Farbanteil Blau',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('BAR_progress_color_GREEN',
                   'BAR progress color GREEN',
                   'Fortschrittsbalken Farbanteil GrÅn',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('BAR_progress_color_BLUE_',
                   'BAR progress color BLUE ',
                   'Fortschrittsbalken Farbanteil ROT ',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

{
  sprach_eintrag08('',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');}

  schreibe_sprach_datei('PPM_XGA$.001','PPM_XGA$.002','sprach_modul','sprach_start','^string');

end.
