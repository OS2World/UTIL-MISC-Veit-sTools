program typsprache_def_xexe;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('Linker_doppelpunkt',
                   ' [linker:',
                   ' [Linker:',
                   '',
                   '');

  sprach_eintrag04('Erweiterte',
                   'extended',
                   'Erweiterte',
                   '',
                   '');

  sprach_eintrag04('Zielsystem_unbekannt',
                   'target system unknown',
                   'Zielsystem unbekannt',
                   '',
                   '');

  sprach_eintrag04('Zielsystem_OS2',
                   'target system OS/2',
                   'Zielsystem OS/2',
                   '',
                   '');

  sprach_eintrag04('Zielsystem_Windows',
                   'target system windows',
                   'Zielsystem Windows',
                   '',
                   '');

  sprach_eintrag04('Zielsystem_MS_DOS_4x',
                   'target system MS-DOS 4.x',
                   'Zielsystem MS-DOS 4.x',
                   '',
                   '');

  sprach_eintrag04('Zielsystem_Windows_386',
                   'target system windows 386',
                   'Zielsystem Windows 386',
                   '',
                   '');

  sprach_eintrag04('Zielsystem_Borland_Operating_System_Services',
                   'target system borland operating system services',
                   'Zielsystem Borland Operating System Services',
                   '',
                   '');

  sprach_eintrag04('Zielsystem_Phar_Lap_DOS_Extender_286_OS2',
                   'target system phar lap DOS-extender 286; OS/2',
                   'Zielsystem Phar Lap DOS-Extender 286; OS/2',
                   '',
                   '');

  sprach_eintrag04('Zielsystem_Phar_Lap_DOS_Extender_286_Windows',
                   'target system phar lap DOS-extender 286; windows',
                   'Zielsystem Phar Lap DOS-Extender 286; Windows',
                   '',
                   '');

  sprach_eintrag04('Zielbetriebssystem_Nr',
                   'target system nr.',
                   'Zielbetriebssystem Nr.',
                   '',
                   '');

  sprach_eintrag04('klammer_Vollbild_klammer',
                   ' [fullscreen]',
                   ' [Vollbild]',
                   '',
                   '');

  sprach_eintrag04('klammer_PM_kompatibel_klammer',
                   ' [p.m.-compatible]',
                   ' [P.M.-kompatibel]',
                   '',
                   '');

  sprach_eintrag04('klammer_pm_klammer',
                   ' [m.m.]',
                   ' [P.M.]',
                   '',
                   '');

  sprach_eintrag04('klammer_Bibliothek_Treiber_klammer',
                   ' [library/driver]',
                   ' [Bibliothek / Treiber]',
                   '',
                   '');

  sprach_eintrag04('klammer_Fehler_klammer',
                   ' [errors]',
                   ' [fehlerhaft]',
                   '',
                   '');

  sprach_eintrag04('klammer_Bibliothek_klammer',
                   ' [library]',
                   ' [Bibliothek]',
                   '',
                   '');

  sprach_eintrag04('klammer_Treiber_klammer',
                   ' [driver]',
                   ' [Treiber]',
                   '',
                   '');

  sprach_eintrag04('klammer_PHYS_DEV_klammer',
                   ' [physical driver]',
                   ' [GerÑtetreiber]',
                   '',
                   '');

  sprach_eintrag04('klammer_VIRT_DEV_klammer',
                   ' [virtual driver]',
                   ' [Treiber fÅr DOS-Emulation]',
                   '',
                   '');

  sprach_eintrag04('xexe__komprimiert',
                   'compressed',
                   'komprimiert',
                   '',
                   '');

  sprach_eintrag04('xexe__byte_debuginfo',
                   ' byte debug info :',
                   ' Byte Debug Informationen :',
                   '',
                   '');

  sprach_eintrag04('xexe__byte_resource',
                   ' byte resource',
                   ' Byte Resourcen',
                   '',
                   '');

  sprach_eintrag04('xexe__byte_resource1',
                   ' bytes in ',
                   ' Byte in ',
                   '',
                   '');

  sprach_eintrag04('xexe__byte_resource2',
                   ' resource',
                   ' Resourcen',
                   '',
                   '');

  sprach_eintrag04('xexe__selfload',
                   'self load (decompressor)',
                   'Selbstlader (Entpacker)',
                   '',
                   '');

  sprach_eintrag04('xexe__ab',
                   '" starting at ',
                   '" ab ',
                   '',
                   '');

  sprach_eintrag04('xexe__Vendor',
                   'Vendor       : ',
                   'Hersteller   : ',
                   '',
                   '');

  sprach_eintrag04('xexe__Version',
                   'Version      : ',
                   'Version      : ',
                   '',
                   '');

  sprach_eintrag04('xexe__erstellt',
                   'build        : ',
                   'erstellt am  : ',
                   '',
                   '');


  sprach_eintrag04('xexe__auf',
                   'on           : ',
                   'auf          : ',
                   '',
                   '');

  sprach_eintrag04('xexe__lang',
                   'Language     : ',
                   'Sprache      : ',
                   '',
                   '');

  sprach_eintrag04('xexe__country',
                   'country      : ',
                   'Land         : ',
                   '',
                   '');

  sprach_eintrag04('xexe__fileversion',
                   'file version : ',
                   'Dateiversion : ',
                   '',
                   '');

  sprach_eintrag04('xexe__fixpak',
                   'fixpak       : ',
                   'FixPack      : ',
                   '',
                   '');

  sprach_eintrag04('fehler_im_resource_baum',
                   ' errors in resource tree!',
                   ' Fehler im Resourcebaum!',
                   '',
                   '');

  sprach_eintrag04('byte_resource_nicht_erreichbar',
                   ' bytes in resource section not explained!',
                   ' Byte in der Resourcesektion nicht erreichbar!',
                   '',
                   '');

  sprach_eintrag04('xexe__res_TYP',
                   'RES: type=',
                   'RES:  Typ=',
                   '',
                   '');

  sprach_eintrag04('xexe__res_Name',
                   ' name=',
                   ' Name=',
                   '',
                   '');

  sprach_eintrag04('xexe__res_posi',
                   ' pos.=',
                   ' Pos.=',
                   '',
                   '');

  sprach_eintrag04('xexe__res_laenge',
                   ' length=',
                   '  LÑnge=',
                   '',
                   '');

  sprach_eintrag04('xexe__sprache',
                   'E',
                   'D',
                   '',
                   '');

  sprach_eintrag04('vermutlich_gepackt_geschuetzt',
                   'likely compressed or protected',
                   'vermutlich gepackt oder mit SchutzhÅlle',
                   '',
                   '');

{
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
  schreibe_sprach_datei('$$$_xexe.001','$$$_xexe.002','sprach_modul_typ_xexe','sprach_start_typ_xexe','^string');
end.

