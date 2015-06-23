program protmenu_def;

uses spra_ein;

begin
  sprachtabellenkopf(true,true,false,false);

  sprach_eintrag('beim_Ausfuehren_von_',
                 ': on executing "',
                 ': beim AusfÅhren von "',
                 '',
                 '');

  sprach_eintrag('CMD_nicht_im_Verzeichnis_',
                 '.CMD not found in directory ',
                 '.CMD nicht im Verzeichnis ',
                 '',
                 '');

  sprach_eintrag('gefunden_',
                 ' !',
                 ' gefunden !',
                 '',
                 '');

  sprach_eintrag('SET_COMSPEC_fehlt_in_der_CONFIG_SYS',
                 '"SET COMSPEC=....." missing in CONFIG.SYS !',
                 '"SET COMSPEC=....." fehlt in der CONFIG.SYS !',
                 '',
                 '');

  sprach_eintrag('fehlt',
                 ' missing',
                 ' fehlt',
                 '',
                 '');
{
  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');
}
  schreibe_sprach_datei('prot$$$.001','prot$$$.002','sprach_modul','sprach_start','^string');
end.
