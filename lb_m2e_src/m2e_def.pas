program m2e_def;

uses spr2_ein;

begin
  sprachtabellenkopf_erweitert(
                     +'EN'
                     +'DE'
                     +''
                     +'',
                     false);

  sprach_eintrag04('titel',
                   'PipeMixer driver for ESS AC97 [Maestro 2E] cards.'^m^j'Veit Kannegieser'^m^j,
                   'Mischertreiber fr ESS AC97 Karten [Maestro2E]'^m^j'Veit Kannegieser'^m^j,
                   '',
                   '');

  sprach_eintrag04('CD_Laufwerk_wird_noch_benutzt',
                   'CD-ROM drive is unaccessible (data CD).',
                   'CD-Laufwerk wird nocht benutzt (Daten-CD).',
                   '',
                   '');

  sprach_eintrag04('CD_Laufwerk_ist_nicht_bereit',
                   'CD-ROM drive is not ready.',
                   'CD-Laufwerk ist nicht bereit.',
                   '',
                   '');

  sprach_eintrag04('kein_zugriff_auf_cd_Laufwerk',
                   'Can not access CD ROM driver.',
                   'Zugriff auf CD-Laufwerk nicht m”glich.',
                   '',
                   '');

  sprach_eintrag04('Laufwerk_',
                   'Drive ',
                   'Laufwerk ',
                   '',
                   '');

  sprach_eintrag04('_ist_bereit',
                   ' is ready.',
                   ' ist bereit.',
                   '',
                   '');

  sprach_eintrag04('Das_Laufwerk_versteht_die_CD_ROM_Funktionen_nicht',
                   'Drive does not support CD ROM IOCTL.',
                   'Das Laufwerk versteht die CD ROM-Funktionen nicht.',
                   '',
                   '');

  sprach_eintrag04('hilfe1',
                   'M2E.EXE [/P:1] [/V] [/Q] [/CD:H] [/N:\PIPE\MIXER]',
                   'M2E.EXE [/P:1] [/V] [/Q] [/CD:H] [/N:\PIPE\MIXER]',
                   '',
                   '');

  sprach_eintrag04('hilfe2',
                   '/P  ESS PCI device to use, default=first',
                   '/P  Nummer des zu w„hlenden ESS-Ger„tes (Voreinstellung: das Erste)',
                   '',
                   '');

  sprach_eintrag04('hilfe4',
                   '/V  verbose, debug messages',
                   '/V  Diagnosemeldungen',
                   '',
                   '');

  sprach_eintrag04('hilfe5',
                   '/Q  Quit running M2E',
                   '/Q  Beenden des laufenden M2E',
                   '',
                   '');

  sprach_eintrag04('hilfe6',
                   '/CD use CD ROM (drive H:) digital volume instead of sound chip volume',
                   '/CD Angabe des CD-Laufwerkes zum Einstellen der Lautst„rke (digital)',
                   '',
                   '');

  sprach_eintrag04('hilfe7',
                   '/N  use differen pipe name',
                   '/N  benutzt einen anderen Leitungsnamen zu LbMix',
                   '',
                   '');

  sprach_eintrag04('hilfe9',
                   'To detach M2E use "DETACH M2E.EXE > NUL".',
                   'Fr den Hintergrundbetrieb benutzen Sie "DETACH M2E.EXE > NUL".',
                   '',
                   '');

  sprach_eintrag04('Kann_Leitung__1',
                   'can not access mixer pipe "',
                   'Kann Leitung "',
                   '',
                   '');

  sprach_eintrag04('Kann_Leitung__2',
                   '"!',
                   '" nicht ”ffnen!',
                   '',
                   '');

  sprach_eintrag04('Syntaxfehler',
                   'Syntax error: "',
                   'Syntaxfehler: "',
                   '',
                   '');

  sprach_eintrag04('Der_AC97_Baustein_wurde_nicht_verfuegbar',
                   'Codec did not come ready.',
                   'Der AC97-Baustein wurde nicht verfgbar.',
                   '',
                   '');

  sprach_eintrag04('3D_stereo_technique___',
                   '3D stereo technique : ',
                   '3D-Stereo-Verfahren : ',
                   '',
                   '');

  sprach_eintrag04('Fehler_beim_Erzeugen_von_1',
                   'Error ',
                   'Fehler ',
                   '',
                   '');

  sprach_eintrag04('Fehler_beim_Erzeugen_von_2',
                   ' creating pipe "',
                   ' beim Erzeugen von "',
                   '',
                   '');

  sprach_eintrag04('Fehler_beim_Verbindungsaufbau_',
                   'Error connecing to LbMix (',
                   'Fehler beim Verbindungsaufbau (',
                   '',
                   '');

  sprach_eintrag04('Lesefehler_',
                   'Read error (',
                   'Lesefehler (',
                   '',
                   '');

  sprach_eintrag04('PCI_nicht_vorhanden',
                   'PCI not present.',
                   'PCI ist nicht vorhanden.',
                   '',
                   '');

  sprach_eintrag04('No_valid_IOBase_is_set',
                   'No valid IOBase is set.',
                   'Es ist keine gltige Basisadresse eingetragen.',
                   '',
                   '');

  sprach_eintrag04('ignoring__not_ESS_',
                   '- ignoring (not ESS).',
                   '- wird ignoriert (nicht ESS).',
                   '',
                   '');

  sprach_eintrag04('Klangchip_gefunden__Bus_',
                   'found PCI audio chip: bus=',
                   'Klangchip gefunden: Bus=',
                   '',
                   '');

  sprach_eintrag04('_Geraet_',
                   ',device=',
                   ',Ger„t=',
                   '',
                   '');

  sprach_eintrag04('_Funktion_',
                   ',function=',
                   ',Funktion=',
                   '',
                   '');

  sprach_eintrag04('_Hersteller_',
                   ' vendor=',
                   ' Hersteller=',
                   '',
                   '');

  sprach_eintrag04('_Produkt_',
                   ',product=',
                   ',Produkt=',
                   '',
                   '');

  sprach_eintrag04('Produktname_ist_unbekannt_',
                   'device name not known.',
                   'Produktname ist unbekannt.',
                   '',
                   '');

  sprach_eintrag04('___benutze_diese_Geraet',
                   '-> using this device',
                   '-> benutze diese Ger„t',
                   '',
                   '');

  sprach_eintrag04('Basisadresse_des_Geraetes___',
                   'Device uses IO port $',
                   'Basisadresse des Ger„tes: $',
                   '',
                   '');

  sprach_eintrag04('Ignoriere_ungueltigen_ESS_Nummer_Parameter_',
                   'Ignoring invalid ESS device search index parameter.',
                   'Ignoriere ungltigen ESS-Nummer-Parameter.',
                   '',
                   '');

  sprach_eintrag04('ESS_Geraet__',
                   'ESS device #',
                   'ESS-Ger„t #',
                   '',
                   '');

  sprach_eintrag04('_wurde_nicht_gefunden_',
                   ' was not found.',
                   ' wurde nicht gefunden.',
                   '',
                   '');

  sprach_eintrag04('press_key_to_exit',
                   '<press a key to quit>',
                   '<Tastendruck zum Programmende>',
                   '',
                   '');

  {
  sprach_eintrag04('',
                   '',
                   '',
                   '',
                   '');
  }

  schreibe_sprach_datei('M2E$$$$.001','M2E$$$$.002','sprach_modul','sprach_start','^string');
end.

