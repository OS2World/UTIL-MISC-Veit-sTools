program patchvpt_def;

uses spra_ein;

begin
  sprachtabellenkopf(true,true,false,false);

  sprach_eintrag('Parameterfehler_',
                 'parameter error'^g,
                 'Parameterfehler !'^g,
                 '',
                 '');

  sprach_eintrag('Benutzung_PATCHVPT_EXE',
                 ' usage:        PATCHVPT.EXE [ /B:# ≥ /C:# ≥ /I:# ] ... ',
                 ' Benutzung:    PATCHVPT.EXE [ /B:# ≥ /C:# ≥ /I:# ] ... ',
                 '',
                 '');

  sprach_eintrag('Blinken_oder_Intenstitaet',
                 'blink or bright background colors',
                 'Blinken oder IntenstitÑt',
                 '',
                 '');

  sprach_eintrag('Intensive_Hintergrundfarben',
                 'bright background colors',
                 'Intensive Hintergrundfarben',
                 '',
                 '');

  sprach_eintrag('Blinken',
                 'blink',
                 'Blinken',
                 '',
                 '');

  sprach_eintrag('Frequenz_des_Bildschirmsignals',
                 'video clock',
                 'Frequenz des Bildschirmsignals',
                 '',
                 '');

  sprach_eintrag('Tabellenindex',
                 'index in table',
                 'Tabellenindex',
                 '',
                 '');

  sprach_eintrag('nur_fuer_VGA_Textmodus_80_25',
                 'only for VGA-textmode 80*25',
                 'nur fÅr VGA-Textmodus 80*25',
                 '',
                 '');

  sprach_eintrag('nur_fuer_VGA_320_200_256',
                 'only for VGA 320*200 (256)',
                 'nur fÅr VGA 320*200 (256)',
                 '',
                 '');

  sprach_eintrag('gemessene_Ergebnisse_im_Textmodus',
                 ' measured results in textmode',
                 ' gemessene Ergebnisse im Textmodus',
                 '',
                 '');

  sprach_eintrag('ist_nicht_beschreibbar_',
                 'is write protected.',
                 'ist nicht beschreibbar.',
                 '',
                 '');

  sprach_eintrag('Damit_AEnderungen_wirksam_werden_sollte_VPT_RAM_COM_geladen_werden_',
                 'To save changes you should load VPT_RAM.COM befor.',
                 'Damit énderungen wirksam werden, sollte VPT_RAM.COM geladen werden.',
                 '',
                 '');


{
  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');
}

  schreibe_sprach_datei('patch$$$.001','patch$$$.002','sprach_modul','sprach_start','^string');
end.
