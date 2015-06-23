program unxl_def;

uses spra_ein;

begin

  sprachtabellenkopf(true,true,false,false);

  sprach_eintrag('Benutzung_',
                 'usage: ',
                 'Benutzung: ',
                 '',
                 '');

  sprach_eintrag('systax2',
                 ' <EXE_NAME.EXE> [<target directory>]',
                 ' <EXE_NAME.EXE> [<Zielverzeichnis>]',
                 '',
                 '');

  sprach_eintrag('kein_XLINK_gefunden',
                 'no XLINK found'#7,
                 'kein XLINK gefunden'#7,
                 '',
                 '');

{
  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');
}
  schreibe_sprach_datei('unxl$$$.001','unxl$$$.002','sprach_modul','sprach_start','^string');
end.
