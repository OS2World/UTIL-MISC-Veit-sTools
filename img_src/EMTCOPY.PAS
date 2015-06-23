procedure emtcopy;
  var
    anzahl_spuren:byte;
    entschluesselungs_puffer:array[0..36*512+1000] of byte;
    lese_position,schreib_position:longint;
    spur_groesse,vortabelle_groesse:word;
    spur:word;
    zeichen,anzahl_zeichen:byte;

    zaehler:word;
    kommentar:string;

  procedure lies_emtcopy(var z:byte);
    begin
      if (lese_position mod 512)=0 then
        begin
          write(textz_Lese_____Spur_^,spur div 2:2,textz__Kopf_^,spur mod 2:2,zeitanzeige,^m);
          lies(hand[1],puffer,512);
        end;
      z:=puffer[lese_position mod 512];
      inc(lese_position);
    end;

  procedure schreibe_emtcopy(z:byte);
    begin
      entschluesselungs_puffer[schreib_position mod (spur_groesse+vortabelle_groesse)]:=z;
      inc(schreib_position);
      if (schreib_position mod (spur_groesse+vortabelle_groesse))=0 then
        begin
          write(textz_Schreibe_Spur_^,spur div 2:2,textz__Kopf_^,spur mod 2:2,zeitanzeige,^m);
          schreibe(hand[2],entschluesselungs_puffer[vortabelle_groesse],spur_groesse);
          inc(spur);
        end;
    end;


  begin

    writeln_clreol('EMTCOPY / IBM');
    springe_physikalisch(hand[1],hand[1].groesse-$10);
    lies(hand[1],puffer,$10);
    if  (puffer[$8]=$01)
    and (puffer[$9]=$00)
     then
       anzahl_spuren:=puffer[$7]
     else
       begin
         springe_physikalisch(hand[1],hand[1].groesse-521);
         lies(hand[1],anzahl_spuren,sizeof(anzahl_spuren));

         springe_physikalisch(hand[1],hand[1].groesse-521+9);

         for zaehler:=1 to 10 do
           begin
             lies(hand[1],kommentar[1],36);
             kommentar[0]:=#36;
             writeln('"',kommentar,'"');
           end;
       end;

    (* Annahme 2 Seiten *)
    anzahl_spuren:=2*(anzahl_spuren+1)-1;

    (* wie viele Sektoren je Spur ? ... *)
    springe_physikalisch(hand[1],logischer_anfang+$50);
    lies(hand[1],puffer,3*16);
    lese_position:=0;
    schreib_position:=0;
    repeat
      if puffer[lese_position]=$f1 then
        begin
          for zaehler:=1 to puffer[lese_position+2] do
            begin
              entschluesselungs_puffer[schreib_position]:=puffer[lese_position+1];
              inc(schreib_position);
            end;
          inc(lese_position,3);
        end
      else
        begin
          entschluesselungs_puffer[schreib_position]:=puffer[lese_position];
          inc(lese_position);
          inc(schreib_position);
        end;
    until schreib_position>16;

    spur_groesse:=word_ptr(addr(entschluesselungs_puffer[4]))^;
    vortabelle_groesse:=word_ptr(addr(entschluesselungs_puffer[6]))^;


    test_groessenproblem(longint(spur_groesse)
                        *longint(anzahl_spuren));


    (* eigentliches Entpacken *)
    springe_physikalisch(hand[1],logischer_anfang+$50);
    lese_position:=0;
    schreib_position:=0;
    spur:=0;
    repeat
      lies_emtcopy(zeichen);
      if zeichen=$f1 then
        begin
          lies_emtcopy(zeichen);
          lies_emtcopy(anzahl_zeichen);
          for zaehler:=1 to anzahl_zeichen do
            schreibe_emtcopy(zeichen);
        end
      else
        schreibe_emtcopy(zeichen);
    until spur>anzahl_spuren;

    writeln;
  end;



