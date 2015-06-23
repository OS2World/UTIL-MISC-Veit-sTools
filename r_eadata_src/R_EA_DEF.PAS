program img_sprachdefinition;

uses spra_ein;

begin
  sprachtabellenkopf(true,   (* eng *)
                     true,   (* ger *)
                     false,  (* fra *)
                     false); (* rus *)

  sprach_eintrag('hilfe',
                 ^m^j'usage: R_EADATA drive:'^m^j'example: R_EADATA A:',
                 ^m^j'Benutzung R_EADATA Laufwerk:'^m^j'Beispiel: R_EADATA A:',
                 '',
                 '');

  sprach_eintrag('kein_fat',
                 'filesystem is not FAT.',
                 'Das Dateisystem ist nicht FAT',
                 '',
                 '');

  sprach_eintrag('kann_nicht_oeffnen',
                 'can not open drive !',
                 'Kann Laufwerk nicht ™ffnen !',
                 '',
                 '');


  sprach_eintrag('kann_nicht_sperren',
                 'cannot lock drive',
                 'Kann Laufwerk nicht Sperren !',
                 '',
                 '');

  sprach_eintrag('kann_dateisystem_nicht_abmelden',
                 'cannot unmount filesystem !',
                 'Kann Dateisystem nicht abmelden !',
                 '',
                 '');


  sprach_eintrag('Byte_je_Sektor_',
                 ' byte per sector ???',
                 ' Byte je Sektor ???',
                 '',
                 '');

  sprach_eintrag('Lesefehler',
                 'read error',
                 'Lesefehler',
                 '',
                 '');


  sprach_eintrag('zweck',
                 'Util to delete "EA DATA. SF" on FAT drives',
                 'Werkzeug zum L”schen von "EA DATA. SF" auf FAT-Laufwerken',
                 '',
                 '');

  schreibe_sprach_datei('R_EA_$$$.001','R_EA_$$$.002','sprach_modul','sprach_start','^string');
end.
