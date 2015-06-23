program patchvpt_def;

uses spra_ein;

begin
  sprachtabellenkopf(true,true,false,false);


  sprach_eintrag('Fehler_beim_OEffnen_der_Datei',
                 'error opening file ',
                 'Fehler beim ôffnen der Datei ',
                 '',
                 '');

  sprach_eintrag('XMS_2_erforderlich',
                 'XMS 2+ requied !',
                 'XMS 2+ erforderlich !',
                 '',
                 '');

  sprach_eintrag('REB_MENU_bereits_installiert',
                 'REB_MENU allready installed',
                 'REB_MENU bereits installiert.',
                 '',
                 '');

  sprach_eintrag('installierte_Version_unbekannt',
                 'installed version unknown !',
                 'installierte Version unbekannt !',
                 '',
                 '');

  sprach_eintrag('Speicherbereich_ist_noch_schreibgeschuetzt',
                 'memory area still write protected !',
                 'Speicherbereich ist noch schreibgeschÅtzt !',
                 '',
                 '');

  sprach_eintrag('Entferne_FB_MENU',
                 'remove FB_MENU from memory.',
                 'Entferne FB_MENU.',
                 '',
                 '');

  sprach_eintrag('Speicherbereich_ist_schon_benutzt_inkompatibles_BIOS',
                 'memory area already used -> incompatible BIOS !',
                 'Speicherbereich ist schon benutzt->inkompatibles BIOS !',
                 '',
                 '');

  sprach_eintrag('unbekannter_Parameter',
                 'unknown parameter "',
                 'unbekannter Parameter "',
                 '',
                 '');

  sprach_eintrag('Dokumentation_lesen',
                 '"-> read documentation !',
                 '"-> Dokumentation lesen !',
                 '',
                 '');

  sprach_eintrag('Kopie_der_Itab',
                 'copy of interrupt table',
                 'Kopie der Itab',
                 '',
                 '');

  sprach_eintrag('Kopie_des_System_BIOS',
                 'copy of system-BIOS-area',
                 'Kopie des System-BIOS',
                 '',
                 '');

  sprach_eintrag('URAM_Kode_zur_Restauration_des_oberen_Speicherbereiches',
                 'URAM-code to restore upper memory status',
                 'URAM-Kode zur Restauration des oberen Speicherbereiches',
                 '',
                 '');

  sprach_eintrag('OBJ_SPRACHE',
                 'E',
                 'D',
                 '',
                 '');

  sprach_eintrag('Fehler_bei_Anforderung_von_68K_Speicher_ueber_XMS_2',
                 'error requesting 68K XMS memory',
                 'Fehler bei Anforderung von 68K Speicher Åber XMS 2+',
                 '',
                 '');

  sprach_eintrag('installiert',
                 'installed',
                 'installiert',
                 '',
                 '');

{
  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');
 }
  schreibe_sprach_datei('fb_m_$$$.001','fb_m_$$$.002','sprach_modul','sprach_start','^string');
end.
