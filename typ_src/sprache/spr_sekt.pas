program typsprache_def_sekt;

uses spr2_ein;

(*$I SPRKOPF.INC*)

begin
  sprkopf;

  sprach_eintrag04('mit_Absicherung',
                   ' with security',
                   ' mit Absicherung',
                   '',
                   '');

  sprach_eintrag04('sekt__versteckt',
                   'hidden ',
                   'versteckt ',
                   '',
                   '');

  sprach_eintrag04('unbekanntes_System_Nr',
                   'unknown system nr. ',
                   'unbekanntes System Nr. ',
                   '',
                   '');

  sprach_eintrag04('Lesefehler',
                   'read error',
                   'Lesefehler',
                   '',
                   '');

  sprach_eintrag04('nicht_weiterverfolgt',
                   'not further followed',
                   'nicht weiterverfolgt',
                   '',
                   '');

  sprach_eintrag04('unbekannte_Version_mir_schicken',
                   'unknown version -> send to me',
                   'unbekannte Version -> mir schicken',
                   '',
                   '');

  sprach_eintrag04('Startsektor',
                   'bootsector ',
                   'Startsektor ',
                   '',
                   '');

  sprach_eintrag04('klammer_Abzugsdatei_klammer',
                   ' [image file]',
                   ' [Abzugsdatei]',
                   '',
                   '');

  sprach_eintrag04('Partitionstabelle',
                   'partition table',
                   'Partitionstabelle',
                   '',
                   '');

  sprach_eintrag04('Partitionstabelle_oder_Startsektor',
                   'partition tabel or boot sector',
                   'Partitionstabelle oder Startsektor?',
                   '',
                   '');

  sprach_eintrag04('kein_gueltiger_Startsektor',
                   'not a valid boot sector',
                   'kein gltiger Startsektor',
                   '',
                   '');

  sprach_eintrag04('Sektorgroesse',
                   'sector size ',
                   'Sektorgr”sse ',
                   '',
                   '');

  sprach_eintrag04('Byte',
                   ' byte',
                   ' Byte',
                   '',
                   '');

  sprach_eintrag04('Startsektorkode_fehlt',
                   'boot code absent',
                   'Startsektorprogrammkode fehlt',
                   '',
                   '');

  sprach_eintrag04('kein_FAT_Format',
                   'not FAT-format',
                   'kein FAT-Format',
                   '',
                   '');

  sprach_eintrag04('Hersteller_unbekannt',
                   'manufacturer unknown',
                   'Hersteller unbekannt',
                   '',
                   '');

  sprach_eintrag04('Partitionstabelle_ohne_Boot_Code',
                   'partition table without boot code',
                   'Partitionstabelle ohne Boot-Code',
                   '',
                   '');

  sprach_eintrag04('Lader',
                   'loader ',
                   'Lader ',
                   '',
                   '');

  sprach_eintrag04('Teil',
                   'part',
                   'Teil',
                   '',
                   '');

  sprach_eintrag04('Archivdatentraeger',
                   'archive media',
                   'Archivdatentr„ger',
                   '',
                   '');

  sprach_eintrag04('Lader_des_Linux_Kerneldekompressors',
                   'loader of linux kerneldecompressor',
                   'Lader des Linux Kerneldekompressors',
                   '',
                   '');

  sprach_eintrag04('Systemabsicherung',
                   'system security',
                   'Systemabsicherung',
                   '',
                   '');

  sprach_eintrag04('ungueltig',
                   'invalid',
                   'ungltig',
                   '',
                   '');

  sprach_eintrag04('restaurierte_Partitionstabelle',
                   'restored partition table',
                   'restaurierte Partitionstabelle',
                   '',
                   '');

  sprach_eintrag04('veraenderter_Text',
                   'modified text',
                   'ver„nderter Text',
                   '',
                   '');

  sprach_eintrag04('sekt__unbekannt',
                   'unknown',
                   'unbekannt',
                   '',
                   '');

  sprach_eintrag04('FEHLER_welches_Programm_erzeugt_solche_MSDOS_Sektoren',
                   'ERROR!! with program produces such MSDOS-sectors? ø',
                   'FEHLER!! welches Programm erzeugt solche MSDOS-Sektoren? ø',
                   '',
                   '');

  sprach_eintrag04('unbekannte_Version',
                   'unknown version',
                   'unbekannte Version',
                   '',
                   '');

  sprach_eintrag04('startbar',
                   'bootable',
                   'startbar',
                   '',
                   '');

  sprach_eintrag04('Diskette',
                   'floppy',
                   'Diskette',
                   '',
                   '');

  sprach_eintrag04('Ermittlung_der_BIOS_Einsprungpunkte',
                   'determine of BIO-entry points',
                   'Ermittlung der BIOS-Einsprungpunkte',
                   '',
                   '');

  sprach_eintrag04('Ausschrift',
                   'text',
                   'Ausschrift',
                   '',
                   '');

  sprach_eintrag04('Lesezugriff_auf_BIOS_Speichervariable',
                   'read access to BIOS memory size',
                   'Lesezugriff auf BIOS-Speichervariable',
                   '',
                   '');

  sprach_eintrag04('Schreibzugriff_auf_BIOS_Speichervariable',
                   'write access to BIOS memory size',
                   'Schreibzugriff auf BIOS-Speichervariable',
                   '',
                   '');

  sprach_eintrag04('sekt__leicht_fehlerhaft',
                   'minor errors ...',
                   'leicht fehlerhaft ...',
                   '',
                   '');

  sprach_eintrag04('sekt__erweitert',
                   'extended...',
                   'erweitert...',
                   '',
                   '');

  sprach_eintrag04('sekt__Auslagerung',
                   'swap',
                   'Auslagerung',
                   '',
                   '');

  sprach_eintrag04('sekt__sekundaer',
                   'secondary',
                   'sekund„r',
                   '',
                   '');

  sprach_eintrag04('sekt__frei',
                   'unused',
                   'frei',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_in_der_partitionstabelle__sektor1',
                   'Error in partition table data: begining sector number should be 1! ',
                   'Fehler: Nummer des ersten Sektors sollte 1 sein! ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_in_der_partitionstabelle__erweiter_kopf0',
                   'Error in partition table data: should start at head 0! ',
                   'Fehler: soltte mit Kopf 0 anfangen! ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_in_der_partitionstabelle__kopf0_oder_1',
                   'Error in partition table data: should start at head 0 or 1! ',
                   'Fehler: soltte mit Kopf 0 oder 1 anfangen! ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_in_der_partitionstabelle__sektor_unvollstaendig',
                   'Error in partition table data: should end at last sector! ',
                   'Fehler: soltte mit dem letzen Sektor aufh”ren! ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_in_der_partitionstabelle__erweiter_kopf_unvollstaendig',
                   'Error in partition table data: should end at last head! ',
                   'Fehler: soltte mit dem letzen Kopf aufh”ren! ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_in_der_partitionstabelle1',
                   'Error in partition table data: stored start: ',
                   'Fehler: gespeicherter Anfang: ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_in_der_partitionstabelle2',
                   ' calculated: ',
                   ' berechnet: ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_in_der_partitionstabelle_a1',
                   'Error in partition table data: stored length (sectors):',
                   'Fehler: gespeicherte Gr”áe (Sektoren): ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_in_der_partitionstabelle_a2',
                   ' calculated: ',
                   ' berechnet: ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_spur_zu_gross',
                   'Error in partition table data: end cylinder to large! ',
                   'Fehler: Endzylinder ist zu groá! ',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_lin_min',
                   'Error in partition table data: start before lower limit!',
                   'Fehler: Partition f„ngt vor zul„ssiger Grenze an!',
                   '',
                   '');

  sprach_eintrag04('sekt__fehler_lin_max',
                   'Error in partition table data: end beyond upper limit!',
                   'Fehler: Ende der Partition geht ber die zul„ssige Grenze hinaus!',
                   '',
                   '');

  sprach_eintrag04('sekt__LVM_Platte',
                   'LVM: Disk      "',
                   'LVM: Platte    "',
                   '',
                   '');

  sprach_eintrag04('sekt__LVM_Partition',
                   '     partition "',
                   '     Partition "',
                   '',
                   '');

  sprach_eintrag04('sekt__LVM_Laufwerk',
                   '     volume    "',
                   '     Laufwerk  "',
                   '',
                   '');

  sprach_eintrag04('sekt__Buchstabe',
                   '     letter     ',
                   '     Buchstabe  ',
                   '',
                   '');

  sprach_eintrag04('sekt__mit_int13x',
                   'with support for cylinder>=1024',
                   'mit Untersttzung fr Zylinder>=1024',
                   '',
                   '');

  sprach_eintrag04('sekt__ohne_int13x',
                   'without support for cylinder>=1024!',
                   'ohne Untersttzung fr Zylinder>=1024!',
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
                   '');}

  schreibe_sprach_datei('$$$_sekt.001','$$$_sekt.002','sprach_modul_typ_sekt','sprach_start_typ_sekt','^string');
end.

