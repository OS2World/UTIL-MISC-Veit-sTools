program norm_def;

uses spra_ein;

begin
  sprachtabellenkopf(true,true,false,false);

  sprach_eintrag('hilfe_text',
                 ^m^j
                   +'usage: NORM_FAT <direcory> [ .. ] [/Y|/J|/N]'^m^j
                   +' example.:  NORM_FAT C:\ D:\ E:\ /N',
                 ^m^j
                   +'Benutzung NORM_FAT <Verzeichnis> [ .. ] [/Y|/J|/N]'^m^j
                   +' z.B.:  NORM_FAT C:\ D:\ E:\ /N',
                 '',
                 '');

  sprach_eintrag('Schreibfehler_INT_26',
                 'write error (INT 26)',
                 'Schreibfehler (INT 26)',
                 '',
                 '');

  sprach_eintrag('Lesefehler_INT_25',
                 'read error (INT 25)',
                 'Lesefehler (INT 25)',
                 '',
                 '');

  sprach_eintrag('nicht_12_16_BIT_FAT_mit_128_512_1024_2048_Byte_je_Sektor',
                 'not 12/16 BIT FAT with 128/512/1024/2048 byte per sector',
                 'nicht 12/16 BIT FAT mit 128/512/1024/2048 Byte je Sektor',
                 '',
                 '');

  sprach_eintrag('AEnderung_schreiben_',
                 '  write changes ?',
                 '  énderung schreiben ?',
                 '',
                 '');

  sprach_eintrag('_J_a',
                 '     [Y]es',
                 '    [J]a',
                 '',
                 '');

  sprach_eintrag('_N_ein',
                 '    [N]o',
                 '    [N]ein',
                 '',
                 '');

  sprach_eintrag('_I_mmer',
                 '    A[l]ways',
                 '    [I]mmer',
                 '',
                 '');

  sprach_eintrag('ni_e_',
                 '    n[e]ver',
                 '    ni[e]',
                 '',
                 '');

  sprach_eintrag('_A_bbruch',
                 '    [A]bort',
                 '    [A]bbruch',
                 '',
                 '');

  sprach_eintrag('geloescht',
                 ' deleted',
                 ' gelîscht',
                 '',
                 '');

  sprach_eintrag('auf_Datentraegerbezeichnung_zurueckgesetzt',
                 ' reset to volumelabel',
                 ' auf DatentrÑgerbezeichnung zurÅckgesetzt',
                 '',
                 '');

  sprach_eintrag('auf_normales_Verzeichnis_zurueckgesetzt',
                 ' reset to normal directory',
                 ' auf normales Verzeichnis zurÅckgesetzt',
                 '',
                 '');

  sprach_eintrag('Zeitkorrektur_',
                 ' correct timestamp (',
                 ' Zeitkorrektur (',
                 '',
                 '');


  sprach_eintrag('Monat',
                 'month',
                 'Monat',
                 '',
                 '');

  sprach_eintrag('Tag',
                 'day',
                 'Tag',
                 '',
                 '');

  sprach_eintrag('Stunden',
                 'hours',
                 'Stunden',
                 '',
                 '');

  sprach_eintrag('Minuten',
                 'minutes',
                 'Minuten',
                 '',
                 '');

  sprach_eintrag('Sekunden',
                 'seconds',
                 'Sekunden',
                 '',
                 '');

  sprach_eintrag('ungueltiger_Bootsktor',
                 'invalid bootsector',
                 'ungÅltiger Bootsktor',
                 '',
                 '');

{
  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');
}

  schreibe_sprach_datei('norm$$$.001','norm$$$.002','sprach_modul','sprach_start','^string');
end.
