program setb_def;

uses spr2_ein;

begin
  sprachtabellenkopf_erweitert(
                     +'EN'
                     +'DE'
                     +''
                     +'',
                     false);

  sprach_eintrag04('bios_unbekannt',
                   'BIOS-type unknown. Please ask author.',
                   'BIOS-Typ ist unbekannt. Fragen Sie den Autor!',
                   '',
                   '');

  sprach_eintrag04('pruefsummenfehler_10_2d',
                   'CMOS-checksum over index $10..$2d do not equal stored value.',
                   'CMOS-PrÅfsumme $10..$2d pa·t nicht.',
                   '',
                   '');

  sprach_eintrag04('pruefsummenfehler_40_5d',
                   'CMOS-checksum over index $40..$5d do not equal stored value.',
                   'CMOS-PrÅfsumme $40..$5d pa·t nicht.',
                   '',
                   '');

  sprach_eintrag04('_nicht_gefunden_',
                   ' not found.',
                   ' nicht gefunden.',
                   '',
                   '');

  sprach_eintrag04('titel1c',
                   'SETBOOTC * change default entry of VPart in CMOS-mode',
                   'SETBOOTC * éndern des Standardeintrages in VPart im CMOS-Modus',
                   '',
                   '');

  sprach_eintrag04('titel1f',
                   'SETBOOTF * change default entry of VPart in \VPART.CFG-mode',
                   'SETBOOTF * éndern des Standardeintrages in VPart im VPART.CFG-Modus',
                   '',
                   '');

  sprach_eintrag04('hilfe1',
                   '  /Q            -> query menu info.',
                   '  /Q            -> Abfragen der Startinformationen.',
                   '',
                   '');

  sprach_eintrag04('hilfe2',
                   '  /B            -> shutdown + reboot.',
                   '  /B            -> Systemabschlu· durchfÅhren und System neu starten.',
                   '',
                   '');

  sprach_eintrag04('hilfe3',
                   '  /N:Name       -> select enty Name.',
                   '  /N:Name       -> Name als zu startendes Betriebssystem festlegen.',
                   '',
                   '');

  sprach_eintrag04('hilfe_vpart_cfg',
                   '  /VPART_CFG:L  -> select drive letter L for VPART.CFG.',
                   '  /VPART_CFG:L  -> Laufwerksbuchstabe L fÅr VPART.CFG festlegen.',
                   '',
                   '');

  sprach_eintrag04('Standardwert__',
                   'standard entry= ',
                   'Standardwert= ',
                   '',
                   '');

  sprach_eintrag04('__ungueltig',
                   ', (invalid)',
                   ', (ungÅltig)',
                   '',
                   '');

  sprach_eintrag04('__ist_mehrdeutig_',
                   '" is ambiguos.',
                   '" ist mehrdeutig.',
                   '',
                   '');

  sprach_eintrag04('__ist_unbekannt',
                   '" is unknown',
                   '" ist unbekannt',
                   '',
                   '');

  sprach_eintrag04('kann_DOS_SYS_nicht_oeffnen',
                   'can not open DOS.SYS !',
                   'kann DOS.SYS nicht îffnen !',
                   '',
                   '');


  sprach_eintrag04('kann_VPART_CFG_nicht_oeffnen',
                   'Can not open VPART.CFG: ',
                   'kann VPART.CFG nicht îffnen: ',
                   '',
                   '');

  sprach_eintrag04('kann_VPART_CFG_nicht_finden__welcher_laufwerksbuchstabe',
                   ^m'Could not find VPART.CFG.'^m^m
                  +'Please give drive letter to create it: ',
                   ^m'VPART.CFG konnte nicht gefunden werden.'^m^j
                  +'Bitte geben Sie den Laufwerksbuchstaben an, auf dem'^m^j
                  +'die Datei angelegt werden soll: ',
                   '',
                   '');

  sprach_eintrag04('Suche_VPART_CFG_',
                   'Searching VPART.CFG: ',
                   'Suche VPART.CFG: ',
                   '',
                   '');

{ sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');

  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');


  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }

  schreibe_sprach_datei('SETBO$$$.001','SETBO$$$.002','sprach_modul','sprach_start','^string');
end.
