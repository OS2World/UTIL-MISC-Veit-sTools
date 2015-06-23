procedure ez_disklone_plus;
  const
    ez_disklone_plus_spuren_tabelle  :array[0..6] of byte=(40,40,40,40,80,80,80);
    ez_disklone_plus_sektoren_tabelle:array[0..6] of byte=( 8, 9, 8, 9, 9,15,18);
    ez_disklone_plus_koepfe_tabelle  :array[0..6] of byte=( 1, 1, 2, 2, 2, 2, 2);

  var
    ez_disklone_plus_typ:byte;
    blockgroesse:word;
    spur_zaehler,kopf_zaehler:word;

    kopf1:array[1..5] of byte;
    anzahl,fuell:byte;
    entschluesselung_position:word;

  begin
    writeln(str0(puffer[6]));

    ez_disklone_plus_typ:=puffer[5];

    test_groessenproblem(longint(ez_disklone_plus_spuren_tabelle  [ez_disklone_plus_typ])
                        *longint(ez_disklone_plus_sektoren_tabelle[ez_disklone_plus_typ])
                        *longint(ez_disklone_plus_koepfe_tabelle  [ez_disklone_plus_typ])
                        *longint(512));

    blockgroesse:=ez_disklone_plus_sektoren_tabelle[ez_disklone_plus_typ]*512;


    springe_physikalisch(hand[1],logischer_anfang+$80);

    for spur_zaehler:=1 to ez_disklone_plus_spuren_tabelle  [ez_disklone_plus_typ] do
      for kopf_zaehler:=1 to ez_disklone_plus_koepfe_tabelle  [ez_disklone_plus_typ] do
        begin
          if hand[1].position>=hand[1].groesse then
            begin
              write(textz_Fuelle___Spur_^,spur_zaehler:2,textz__Kopf_^,kopf_zaehler:2,zeitanzeige,^m);
              fillchar(puffer,blockgroesse,246);
            end
          else
            begin
              write(textz_Lese_____Spur_^,spur_zaehler:2,textz__Kopf_^,kopf_zaehler:2,zeitanzeige,^m);

              lies(hand[1],kopf1,sizeof(kopf1));
              if kopf1[1]=0 then
                lies(hand[1],puffer,blockgroesse)
              else
                begin
                  entschluesselung_position:=0;
                  repeat
                    lies(hand[1],anzahl,sizeof(anzahl));
                    if anzahl>$7f then
                      begin
                        dec(anzahl,$80);
                        lies(hand[1],fuell,sizeof(fuell));
                        fillchar(puffer[entschluesselung_position],anzahl,fuell);
                        inc(entschluesselung_position,anzahl);
                      end
                    else
                      begin
                        lies(hand[1],puffer[entschluesselung_position],anzahl);
                        inc(entschluesselung_position,anzahl);
                      end;
                  until entschluesselung_position=blockgroesse;
                end;
            end;

          write(    textz_Schreibe_Spur_^,spur_zaehler:2,textz__Kopf_^,kopf_zaehler:2,zeitanzeige,^m);
          schreibe(hand[2],puffer,blockgroesse);
        end;
    writeln;
  end;
