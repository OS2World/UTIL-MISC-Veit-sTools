program img_sprachdefinition;

uses spra_ein;

begin
  sprachtabellenkopf(true,   (* eng *)
                     true,   (* ger *)
                     false,  (* fra *)
                     false); (* rus *)

  sprach_eintrag('Benutzung_IMG_Quelle_Ziel_',
                 'usage: IMG {source} {target}         ',
                 'Benutzung IMG {Quelle} {Ziel}        ',
                 '',
                 '');

  sprach_eintrag('hilfe_img_1',
                 'DiskCopy ...                   ',
                 'DiskCopy ...                   ',
                 '',
                 '');

  sprach_eintrag('hilfe_img_2',
                 'create image file              ',
                 'Erzeugen einer Abzugsdatei     ',
                 '',
                 '');

  sprach_eintrag('hilfe_img_3',
                 'copy back to floppy            ',
                 'ZurÅckspielen auf Diskette     ',
                 '',
                 '');

  sprach_eintrag('hilfe_img_4',
                 'copy image file ...            ',
                 'Abzugsdatei kopieren ...       ',
                 '',
                 '');

  sprach_eintrag('Kopieren_von_Laufwerken_Dateien',
                 'copy drives <-> image files',
                 'Kopieren von Laufwerken <-> Dateien',
                 '',
                 '');

  sprach_eintrag('Bestimme_Quellformat_',
                 'determine source format ...'^m,
                 'Bestimme Quellformat ...'^m,
                 '',
                 '');

  sprach_eintrag('Kopf',
                 'header',
                 'Kopf',
                 '',
                 '');

  sprach_eintrag('Komprimiert__Version_',
                 'Compressed ! ( version ',
                 'Komprimiert ! ( Version ',
                 '',
                 '');

  sprach_eintrag('Die_Quelldatei_ist_komprimiert_IMG_kann_sie_nicht_bearbeiten',
                 'imgage file is compressed. IMG can not process it.',
                 'Die Quelldatei ist komprimiert. IMG kann sie nicht bearbeiten.',
                 '',
                 '');

  sprach_eintrag('kopiergeschuetzte_Sektoren_werden_uebergangen_',
                 ' copyprotected sectors skipped',
                 ' kopiergeschÅtzte Sektoren werden Åbergangen'^g,
                 '',
                 '');

  sprach_eintrag('Bootsektor_fehlerhaft',
                 'bootsector corrupt !',
                 'Bootsektor fehlerhaft !',
                 '',
                 '');

  sprach_eintrag('Fuelle___Spur_',
                 'filling track ',
                 'FÅlle    Spur ',
                 '',
                 '');

  sprach_eintrag('Lese_____Spur_',
                 'reading track ',
                 'Lese     Spur ',
                 '',
                 '');

  sprach_eintrag('Schreibe_Spur_',
                 'writing track ',
                 'Schreibe Spur ',
                 '',
                 '');

  sprach_eintrag('_Kopf_',
                 ' head ',
                 ' Kopf ',
                 '',
                 '');

  sprach_eintrag('Lese_____Sektor_',
                 'reading  sector ',
                 'Lese     Sektor ',
                 '',
                 '');

  sprach_eintrag('Schreibe_Sektor_',
                 'writing  sector ',
                 'Schreibe Sektor ',
                 '',
                 '');

  sprach_eintrag('_bis_',
                 ' to ',
                 ' bis ',
                 '',
                 '');

  sprach_eintrag('Anhang',
                 'suffix',
                 'Anhang',
                 '',
                 '');

  sprach_eintrag('Rohformat',
                 'plain format',
                 'Rohformat',
                 '',
                 '');

  sprach_eintrag('_ab_',
                 ' ( from ',
                 ' ( ab ',
                 '',
                 '');

  sprach_eintrag('Lesen______',
                 'reading   <',
                 'Lesen     <',
                 '',
                 '');

  sprach_eintrag('Fuelle_____',
                 'filling   <',
                 'FÅlle     <',
                 '',
                 '');

  sprach_eintrag('Schreiben__',
                 'writing   <',
                 'Schreiben <',
                 '',
                 '');

  sprach_eintrag('_Sektor_',
                 ' sektor ',
                 ' Sektor ',
                 '',
                 '');

  sprach_eintrag('Abbruch_durch_den_Benutzer',
                 'Abort by user',
                 'Abbruch durch den Benutzer',
                 '',
                 '');

  sprach_eintrag('OEffne_Laufwerk_',
                 'open drive ',
                 'ôffne Laufwerk ',
                 '',
                 '');

  sprach_eintrag('Laufwerk_nicht_bereit_',
                 'drive not ready !',
                 'Laufwerk nicht bereit !',
                 '',
                 '');

  sprach_eintrag('Kann_Laufwerk_nicht_OEffnen_',
                 'can not open drive !',
                 'Kann Laufwerk nicht ôffnen !',
                 '',
                 '');

  sprach_eintrag('Lock_fehlgeschlagen_offene_Datein_',
                 'lock failed (open files ...) !',
                 'Lock fehlgeschlagen (offene Datein...) !',
                 '',
                 '');

  sprach_eintrag('kann_Laufwerksgroesse_nicht_bestimmen_',
                 'can not determine disk size !',
                 'kann Laufwerksgroesse nicht bestimmen.',
                 '',
                 '');

  sprach_eintrag('kann_Dateisystem_nicht_entfernen_',
                 'can not close filesystem !',
                 'kann Dateisystem nicht entfernen.',
                 '',
                 '');

  sprach_eintrag('Sektorgroesse_ist_nicht_512_Byte_',
                 'sector size is not 512 byte !',
                 'Sektorgrî·e ist nicht 512 Byte !',
                 '',
                 '');

  sprach_eintrag('kann_Bootsektor_nicht_auswerten_',
                 'can not interpret bootsector !',
                 'kann Bootsektor nicht auswerten !',
                 '',
                 '');

  sprach_eintrag('OEffne_Datei_',
                 'open file ',
                 'ôffne Datei ',
                 '',
                 '');

  sprach_eintrag('Fehler_',
                 'error ',
                 'Fehler ',
                 '',
                 '');

  sprach_eintrag('_beim_OEffnen',
                 ' on open',
                 ' beim ôffnen',
                 '',
                 '');

  sprach_eintrag('Beschaedigte_Datei_',
                 'damaged file !',
                 'BeschÑdigte Datei !',
                 '',
                 '');

  sprach_eintrag('_Lesefehler_',
                 ' read error ! ',
                 ' Lesefehler ! ',
                 '',
                 '');

  sprach_eintrag('_Schreibfehler_',
                 ' write error ! ',
                 ' Schreibfehler ! ',
                 '',
                 '');

  sprach_eintrag('_a_bbrechen',
                 '[a]bort',
                 '[a]bbrechen',
                 '',
                 '');

  sprach_eintrag('_w_iederholen',
                 '[r]etry',
                 '[w]iederholen',
                 '',
                 '');

  sprach_eintrag('_i_gnorieren',
                 '[i]gnore',
                 '[i]gnorieren',
                 '',
                 '');

  sprach_eintrag('_e_wig_probieren',
                 '[e]ndless try',
                 '[e]wig probieren',
                 '',
                 '');

  sprach_eintrag('i_m_mer_ignorieren___',
                 'a[l]way ignore ? ',
                 'i[m]mer ignorieren ? ',
                 '',
                 '');

  sprach_eintrag('Schliesse_Laufwerk_Neubestimmumg_Dateisystem',
                 'close drive / redetermine media ',
                 'Schlie·e Laufwerk / Neubestimmumg Dateisystem ',
                 '',
                 '');

  sprach_eintrag('Das_Ziellaufwerk_ist_zu_klein_um_alle_Daten_zu_schreiben',
                 'The target drive is to small to write all data.',
                 'Das Ziellaufwerk ist zu klein um alle Datein zu schreiben.',
                 '',
                 '');

  sprach_eintrag('mindestens_notwendig_sind',
                 'minimum size is ',
                 'mindestens notwendig sind ',
                 '',
                 '');

  sprach_eintrag('WARNUNG_Ziel_ist_groesser_als_die_Quelle',
                 'WARNING: target is bigger than source !'^g,
                 'WARNUNG: Ziel ist grî·er als die Quelle !'^g,
                 '',
                 '');
  sprach_eintrag('fortfahren',
                 'proceed (y/n) ? ',
                 'weiter (j/n) ? ',
                 '',
                 '');

  sprach_eintrag('warnung_festplattenlaufwerk',
                 'WARNING: you have specified an drive as target !'^g,
                 'WARNUNG: Sie haben als Ziel ein Laufwerk angegeben !'^g,
                 '',
                 '');
{
  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');

  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');


  sprach_eintrag('',
                 '',
                 '',
                 '',
                 '');
}
  schreibe_sprach_datei('IMG$$$.001','IMG$$$.002','sprach_modul','sprach_start','str_z');
end.
