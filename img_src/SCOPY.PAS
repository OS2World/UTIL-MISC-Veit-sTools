procedure scopy_1;
  var
    sektor_tabelle:array[1..36*3 div 2] of byte;

    sektor_zaehler,sektor_anzahl,
    spur_zaehler  ,spur_anzahl  ,
    kopf_zaehler  ,kopf_anzahl  :word;

    fuell:byte;

  begin
    springe_physikalisch(hand[1],logischer_anfang);
    lies(hand[1],puffer,512);
    sektor_anzahl:=word_ptr(@puffer[10])^;
    spur_anzahl  :=word_ptr(@puffer[12])^ div 2;
    kopf_anzahl  :=word_ptr(@puffer[14])^;

    test_groessenproblem(longint(sektor_anzahl)
                        *longint(spur_anzahl  )
                        *longint(kopf_anzahl  )
                        *longint(512          ));


    springe_physikalisch(hand[1],logischer_anfang+$20+puffer[$13]);

    for spur_zaehler:=1 to spur_anzahl do
      for kopf_zaehler:=1 to kopf_anzahl do
        begin
          lies(hand[1],sektor_tabelle,sektor_anzahl);
          for sektor_zaehler:=1 to sektor_anzahl do
            begin
              if sektor_tabelle[sektor_zaehler]=0 then
                begin
                  write(textz_Lese_____Spur_^,spur_zaehler:2,textz__Kopf_^,kopf_zaehler:2,
                    textz__Sektor_^,sektor_zaehler:2,zeitanzeige,^m);
                  lies(hand[1],puffer,512);
                end
              else
                begin
                  write(textz_Fuelle___Spur_^,spur_zaehler:2,textz__Kopf_^,kopf_zaehler:2,
                    textz__Sektor_^,sektor_zaehler:2,zeitanzeige,^m);
                  lies(hand[1],fuell,1);
                  fillchar(puffer,512,fuell);
                end;

            write(      textz_Schreibe_Spur_^,spur_zaehler:2,textz__Kopf_^,kopf_zaehler:2,
                    textz__Sektor_^,sektor_zaehler:2,zeitanzeige,^m);
            schreibe(hand[2],puffer,512);
          end;
        end;
    writeln;
  end;
