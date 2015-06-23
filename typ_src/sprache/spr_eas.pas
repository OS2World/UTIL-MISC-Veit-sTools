program typsprache_def_eas;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('eas__Text',
                   'text',
                   'Text',
                   '',
                   '');

  sprach_eintrag04('eas__binear',
                   'binary',
                   'binÑr',
                   '',
                   '');

  sprach_eintrag04('eas__mvmt',
                   'multi-valued/multi-typed',
                   'mehrwertig/mehrtypig',
                   '',
                   '');

  sprach_eintrag04('eas__mvst',
                   'multi-valued/single-typed',
                   'mehrwertig/eintypig',
                   '',
                   '');

  sprach_eintrag04('eas__Protected_Mode_Library',
                   'Protected Mode Library',
                   'Bibliother fÅr geschÅtzten Modus',
                   '',
                   '');

  sprach_eintrag04('eas__Virtual_Device_Driver',
                   'Virtual Device Driver',
                   'GerÑtetreiber fÅr DOS-Emulation',
                   '',
                   '');

  sprach_eintrag04('eas__Physical_Device_Driver',
                   'Physical Device Driver',
                   'GerÑtetreiber',
                   '',
                   '');

  sprach_eintrag04('eas__Dynamic_Link_Library',
                   'Dynamic Link Library',
                   'dynamisch geladene Bibliothek',
                   '',
                   '');

  sprach_eintrag04('eas__Not_Window_Compatible',
                   'Not Window Compatible',
                   'Gesamtbildschirm',
                   '',
                   '');

  sprach_eintrag04('eas__Window_Compatible',
                   'Window Compatible',
                   'fensterkompatibel',
                   '',
                   '');

  sprach_eintrag04('eas__Window_API',
                   'Window API',
                   'Fensterprogramm',
                   '',
                   '');

  sprach_eintrag04('eas__DEFEKT_LAENGE',
                   'corrupt - length broken!!',
                   'DEFEKT - LÑnge stimmt nicht!!',
                   '',
                   '');

  sprach_eintrag04('eas__DEFEKT_TYP_LEANGE',
                   'corrupt - type/length field missing!!',
                   'DEFEKT - Typ/LÑngenangaben fehlen!!',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }
  schreibe_sprach_datei('$$$_eas.001','$$$_eas.002','sprach_modul_typ_eas','sprach_start_typ_eas','^string');
end.

