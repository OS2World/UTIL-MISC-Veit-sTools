program xgga_ppmd;

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

  sprach_eintrag08('benutzung1',
                   'Convert save2dsk.xga (phoenix PHDISK) to portable pixmap',
                   'Wandelt save2dsk.xga (phoenix PHDISK) in portable pixmap-Format um',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('benutzung2',
                   'Usage: XGA_PPM <save2dsk.xga> <save2dsk.ppm>',
                   'Benutzung: XGA_PPM <save2dsk.xga> <save2dsk.ppm>',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag08('SAVE2DSK_XGA_Signature_not_present_',
                   'SAVE2DSK.XGA Signature not present.',
                   'SAVE2DSK.XGA-Dateikennum am Anfang fehlt.',
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

  schreibe_sprach_datei('XGA_PPM$.001','XGA_PPM$.002','sprach_modul','sprach_start','^string');

end.
