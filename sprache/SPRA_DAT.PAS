(* V.K. 04.10.1996 *)
(* 23.10.1996 Kennung *)
(* spra_??? Typen *)

const
  spra_kennung='<SPRA>';

type
  str_z=^string;
  sprachen_vorhanden_menge=(name_bezeichner,sprache_englisch,sprache_deutsch,sprache_franzoesisch,sprache_russisch);
  sprachen_vorhanden_typ=array[sprachen_vorhanden_menge] of boolean;
  eintragsfeld_typ=array[sprachen_vorhanden_menge] of string;
  eintrags_z_feld_typ=array[sprachen_vorhanden_menge] of str_z;
  zeichenketten_tabelle_typ=array[1..1000] of eintrags_z_feld_typ;

