program typsprache_def_ende;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  {sprach_eintrag04('ende__Zip_Archiv_Version',
                   'zip-archive version ',
                   'Zip-Archiv Version ',
                   '',
                   '');}

  sprach_eintrag04('ende__Bios_Abzugsdatei_klammer',
                   'BIOS image file ( ',
                   'Bios-Abzugsdatei ( ',
                   '',
                   '');

  sprach_eintrag04('ende__fehlerhaftes_Zip_Archiv',
                   'damaget zip-archive',
                   'fehlerhaftes Zip-Archiv',
                   '',
                   '');

  sprach_eintrag04('ende__vermutlich_Klangdaten',
                   'probably sound data',
                   'vermutlich Klangdaten',
                   '',
                   '');

  sprach_eintrag04('ende__VCL_Verschluesselung_Entschluesselungcode',
                   'VCL-encryption-decryption code [',
                   'VCL-VerschlÅsselung-EntschlÅsselungcode [',
                   '',
                   '');

  schreibe_sprach_datei('$$$_ende.001','$$$_ende.002','sprach_modul_typ_ende','sprach_start_typ_ende','^string');
end.

