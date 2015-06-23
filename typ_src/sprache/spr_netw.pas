program typsprache_def_netw;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('netw__Laufwerk',
                   '[drive ',
                   '[Laufwerk ',
                   '',
                   '');

  sprach_eintrag04('netw__lw00',
                   'not mapped',
                   'nicht abgebildet',
                   '',
                   '');

  sprach_eintrag04('netw__lw01',
                   'permanent network drive',
                   'permanentes Netzlaufwerk',
                   '',
                   '');

  sprach_eintrag04('netw__lw02',
                   'temporary network drive',
                   'tempor„res  Netzlaufwerk',
                   '',
                   '');

  sprach_eintrag04('netw__lw80',
                   'mapped to local drive',
                   'auf lokales Laufwerk abgebildet',
                   '',
                   '');

  sprach_eintrag04('netw__lw81',
                   'local drive used as permanent network drive',
                   'lokales Laufwerk als permanentes Netzlaufwerk benutzt',
                   '',
                   '');

  sprach_eintrag04('netw__lw82',
                   'local drive used as temporary network drive',
                   'lokales Laufwerk als tempor„res  Netzlaufwerk benutzt',
                   '',
                   '');

  sprach_eintrag04('netw__lwxx',
                   'unknow status!',
                   'unbekannter Status!',
                   '',
                   '');

  sprach_eintrag04('netw__Servernummer',
                   'server number=',
                   'Servernummer=',
                   '',
                   '');

  sprach_eintrag04('netw__Server',
                   'server=',
                   'Server=',
                   '',
                   '');

  sprach_eintrag04('netw__Verweis_auf',
                   'subst to ',
                   'Verweis auf ',
                   '',
                   '');

  schreibe_sprach_datei('$$$_netw.001','$$$_netw.002','sprach_modul_typ_netw','sprach_start_typ_netw','^string');
end.

