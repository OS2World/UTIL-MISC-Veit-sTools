type
  viotbl_anfang_typ=
    packed record
     anfang_daten:longint;                      (*  0 *)
     viotbl_anfang_laenge:word;                 (*  4 *)
     viotbl_anzahl_eintraege:word;              (*  6 *)
    end;                                        (*  8 *)

  schrift_kopf_typ=
    packed record
      schrift_gesamt_laenge:word;               (*  0 *)
      kopflaenge:word;                          (*  2 *)
      codeseite:longint;                        (*  4 *)
      null_oder_drei:word;                      (*  8 *)
      breite:byte;                              (* 10 *)
      hoehe:byte;                               (* 11 *)
      erforderliche_breite:byte;                (* 12 *)
      erforderliche_hoehe:byte;                 (* 13 *)
      kopflaenge2:word;                         (* 14 *)
      schriftdaten_laenge:word;                 (* 16 *)
      anzahl_zeichen:word;                      (* 18 *)
      erstes_zeichen:word;                      (* 20 *)
      letztes_zeichen:word;                     (* 22 *)
    end;                                        (* 24 *)


