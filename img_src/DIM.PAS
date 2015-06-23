procedure dim;
  var
    spur_groesse:byte;
    sektor:longint;
    muell:array[1..50] of byte;
  begin
    writeln_clreol('DIM / Ray Arachelian');
    spur_groesse:=puffer[$52];
    sektor:=1;
    springe_physikalisch(hand[1],logischer_anfang+$54);

    test_groessenproblem(((hand[1].groesse-logischer_anfang-$54) div (512+1))*512);

    repeat
      write(textz_Lese_____Sektor_^,sektor:4,textz__bis_^,sektor+spur_groesse-1:4,zeitanzeige,^m);
      lies(hand[1],puffer,512*longint(spur_groesse));
      lies(hand[1],muell,spur_groesse);

      write(textz_Schreibe_Sektor_^,sektor:4,textz__bis_^,sektor+spur_groesse-1:4,zeitanzeige,^m);
      schreibe(hand[2],puffer,512*longint(spur_groesse));
      inc(sektor,spur_groesse);
    until hand[1].groesse-hand[1].position<512*longint(spur_groesse);

    writeln;
  end;

