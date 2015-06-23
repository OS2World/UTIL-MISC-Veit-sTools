procedure diskdupe_4;
  const
    anzahl_spuren:array[1..4] of word=(40,80,80,80); (* 360,1200,720,1440 *)
    anzahl_sektoren_je_spur:array[1..4] of byte=(9,15,9,18);
  var
    diskdupe_tabelle:array[0..2*80+2-1] of
      record
        vorhanden:byte; (* 0=nicht 1=normal 2=mehrfachzeichen *)
        mehrfachzeichen_oder_spur_nummer:byte; (* $f6... *)
        db2:byte;
        db3:byte;
        db4:byte;
        db5:byte;
      end;
    spur:word;
    diskdupe_typ:byte;
  begin
    writeln_clreol('Diskdupe(4)');
    diskdupe_typ:=puffer[10];
    springe_physikalisch(hand[1],logischer_anfang+$64);
    lies(hand[1],diskdupe_tabelle,sizeof(diskdupe_tabelle));
    (* 2 Seiten *)

    test_groessenproblem(longint(anzahl_spuren          [diskdupe_typ])
                        *longint(anzahl_sektoren_je_spur[diskdupe_typ])
                        *longint(2)
                        *longint(512));


    for spur:=0 to anzahl_spuren[diskdupe_typ]*2-1 do
      begin
        write(textz_Lese_____Spur_^,spur div 2:2,textz__Kopf_^,spur mod 2:2,zeitanzeige,^m);
        with diskdupe_tabelle[spur] do
          case vorhanden of
            0:(* *);
            1:
              begin
                springe_physikalisch(hand[1],
                logischer_anfang+mehrfachzeichen_oder_spur_nummer*longint(512)*anzahl_sektoren_je_spur[diskdupe_typ]);
                lies(hand[1],puffer,longint(512)*anzahl_sektoren_je_spur[diskdupe_typ]);
              end;
            2:fillchar(puffer,longint(512)*anzahl_sektoren_je_spur[diskdupe_typ],
              mehrfachzeichen_oder_spur_nummer);
          end;

        write(textz_Schreibe_Spur_^,spur div 2:2,textz__Kopf_^,spur mod 2:2,zeitanzeige,^m);
        schreibe(hand[2],puffer,longint(512)*anzahl_sektoren_je_spur[diskdupe_typ]);
      end;

    writeln;
  end;

procedure diskdupe_5;
  const
    anzahl_sektoren_je_spur:array[1..10] of byte=( 8, (*  320 *)
                                                   9, (*  360 *)
                                                  10, (*  400 *)
                                                   9, (*  720 *)
                                                  10, (*  800 *)
                                                  15, (* 1200 *)
                                                  17, (* 1360 *)
                                                  18, (* 1400 *)
                                                  21, (* 1680 *)
                                                  36);(* 2800 *)
  var
    diskdupe_tabelle:array[0..86*2-1] of
      record
        vorhanden:byte; (* 0=nicht 1=normal 2=mehrfachzeichen *)
        case integer of
          1:(mehrfachzeichen,b2,b3,b4:byte);
          2:(position:longint);
      end;
    diskdupe_typ:byte;
    anzahl_spuren:word;
    spur:word;
    daten_off:word;
  begin


    writeln_clreol('Diskdupe(5)');
    daten_off:=word_ptr(addr(puffer[$16]))^;
    diskdupe_typ:=puffer[$42];
    anzahl_spuren:=puffer[$43];
    springe_physikalisch(hand[1],logischer_anfang+$46);
    lies(hand[1],diskdupe_tabelle,sizeof(diskdupe_tabelle));


    test_groessenproblem(longint(anzahl_spuren)
                        *longint(anzahl_sektoren_je_spur[diskdupe_typ])
                        *longint(512));


    for spur:=0 to anzahl_spuren-1 do
      begin
        write(textz_Lese_____Spur_^,spur div 2:2,textz__Kopf_^,spur mod 2:2,zeitanzeige,^m);
        with diskdupe_tabelle[spur] do
          case vorhanden of
            0:(* ??? *);
            1:
              begin
                springe_physikalisch(hand[1],logischer_anfang+daten_off+position);
                lies(hand[1],puffer,longint(512)*anzahl_sektoren_je_spur[diskdupe_typ]);
              end;
            2:fillchar(puffer,longint(512)*anzahl_sektoren_je_spur[diskdupe_typ],mehrfachzeichen);
          else
            runerror(0);
          end;

        write(textz_Schreibe_Spur_^,spur div 2:2,textz__Kopf_^,spur mod 2:2,zeitanzeige,^m);
        schreibe(hand[2],puffer,longint(512)*anzahl_sektoren_je_spur[diskdupe_typ]);
      end;

    writeln;
  end;

