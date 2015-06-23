procedure blitzcopy;
  var
    blitzcopy_spur_tabelle:array[1..85] of byte;
    logische_groesse:longint;
    anzahl_spuren,spur_zaehler:word;
    blockgroesse:word;
    laenge_komprimiert:word;

  procedure entschluesselung;
    var
      leseposition,schreibposition:word;
      anzahl,zeichen:byte;
      blizcopy_puffer:array[0..((36+3)*3 div 2*2)*512] of byte;

    begin
      leseposition   :=0;
      schreibposition:=0;
      lies(hand[1],laenge_komprimiert,sizeof(laenge_komprimiert));
      lies(hand[1],blizcopy_puffer,laenge_komprimiert);

      repeat
        if blizcopy_puffer[leseposition]<>$90 then
          begin
            zeichen:=blizcopy_puffer[leseposition];
            puffer[schreibposition]:=zeichen;
            inc(leseposition   );
            inc(schreibposition);
          end
        else
          begin
            anzahl:=blizcopy_puffer[leseposition+1];
            if anzahl=0 then
              begin
                puffer[schreibposition]:=blizcopy_puffer[leseposition];
                inc(schreibposition);
              end
            else
              begin
                fillchar(puffer[schreibposition],anzahl-1,zeichen);
                inc(schreibposition,anzahl-1);
              end;

            inc(leseposition   ,2);
            
          end;
      until schreibposition>=blockgroesse;

    end;

  begin
    springe_physikalisch(hand[1],logischer_anfang);
    lies(hand[1],blitzcopy_spur_tabelle,sizeof(blitzcopy_spur_tabelle));

    springe_physikalisch(hand[1],logischer_anfang+$56);
    blockgroesse:=512;
    entschluesselung;

    if  (puffer[$0] in [$e9,$eb])
    and (puffer[$b]=0)
    and (puffer[$c]=2)
     then
      begin
        logische_groesse:=longint(word_ptr(addr(puffer[$13]))^)*512;
        if logische_groesse=0 then
          logische_groesse:=longint_ptr(addr(puffer[$20]))^*512;
      end
    else
      abbruch(textz_Bootsektor_fehlerhaft^);

    test_groessenproblem(logische_groesse);

    (* Koepfe*Sekt/Spur*512 *)
    blockgroesse:=word_ptr(@puffer[$18])^*word_ptr(@puffer[$1a])^*512;

    (* 40 oder 80 *)
    anzahl_spuren:=logische_groesse div blockgroesse;



    springe_physikalisch(hand[1],logischer_anfang+$56);

    for spur_zaehler:=1 to anzahl_spuren do
      begin
        case blitzcopy_spur_tabelle[spur_zaehler] of
          0:
            begin
              write(textz_Fuelle___Spur_^,spur_zaehler:2,zeitanzeige,^m);
              fillchar(puffer,blockgroesse,#246);
            end;
          1:
            begin
              write(textz_Lese_____Spur_^,spur_zaehler:2,zeitanzeige,^m);
              lies(hand[1],laenge_komprimiert,sizeof(laenge_komprimiert));
              lies(hand[1],puffer,blockgroesse);
            end;
          2:
            begin
              write(textz_Lese_____Spur_^,spur_zaehler:2,zeitanzeige,^m);
              entschluesselung;
            end;
        end;

        write(      textz_Schreibe_Spur_^,spur_zaehler:2,zeitanzeige,^m);
        schreibe(hand[2],puffer,blockgroesse);
      end;

    writeln;
  end;
