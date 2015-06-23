procedure copyqm;
  var
    beschreibung:string;
    anzahl_spuren:word;
    anzahl_sektoren:byte;
    spur:word;
    block_anfang:integer;
    schreib_position:word;
    fuell:byte;
    spurgroesse:longint;
    copyqm_modus:(modus_normal,modus_fuell,modus_block);
    uebrig:word;
  begin
    writeln_clreol('CopyQM');
    springe_physikalisch(hand[1],logischer_anfang);
    lies(hand[1],puffer,$85);

    anzahl_spuren:=word_ptr(addr(puffer[$0b]))^;
    anzahl_sektoren:=puffer[$10];
    anzahl_spuren:=anzahl_spuren div (anzahl_sektoren*2);

    lies(hand[1],beschreibung[1],word_ptr(addr(puffer[$6f]))^);

    beschreibung[0]:=chr(puffer[$6f]);
    writeln('"',beschreibung,'"');

    spurgroesse:=512*anzahl_sektoren;
    copyqm_modus:=modus_normal;

    test_groessenproblem(longint(anzahl_spuren)
                        *longint(spurgroesse));


    for spur:=0 to anzahl_spuren*2-1 do
      begin
        schreib_position:=0;
        write(textz_Lese_____Spur_^,spur div 2:2,textz__Kopf_^,spur mod 2:2,zeitanzeige,^m);

        repeat

          if hand[1].position=hand[1].groesse then
            begin
              fuell:=$f6;
              copyqm_modus:=modus_fuell;
              uebrig:=spurgroesse;
            end;

          case copyqm_modus of
            modus_normal:
              begin
                lies(hand[1],block_anfang,sizeof(block_anfang));
                if block_anfang<0 then
                  begin
                    copyqm_modus:=modus_fuell;
                    lies(hand[1],fuell,sizeof(fuell));
                    uebrig:=-block_anfang
                  end
                else
                  begin
                    copyqm_modus:=modus_block;
                    uebrig:=block_anfang
                  end;
              end;

            modus_fuell:
              begin
                if uebrig>spurgroesse-schreib_position then
                  begin
                    fillchar(puffer[schreib_position],spurgroesse-schreib_position,fuell);
                    dec(uebrig,spurgroesse-schreib_position);
                    schreib_position:=spurgroesse;
                  end
                else
                  begin
                    fillchar(puffer[schreib_position],uebrig,fuell);
                    inc(schreib_position,uebrig);
                    copyqm_modus:=modus_normal;
                  end;
              end;

            modus_block:
              begin
                if uebrig>spurgroesse-schreib_position then
                  begin
                    lies(hand[1],puffer[schreib_position],spurgroesse-schreib_position);
                    dec(uebrig,spurgroesse-schreib_position);
                    schreib_position:=spurgroesse;
                  end
                else
                  begin
                    lies(hand[1],puffer[schreib_position],uebrig);
                    inc(schreib_position,uebrig);
                    copyqm_modus:=modus_normal;
                  end;
              end;

          end;
        until schreib_position=spurgroesse;

        write(textz_Schreibe_Spur_^,spur div 2:2,textz__Kopf_^,spur mod 2:2,zeitanzeige,^m);
        schreibe(hand[2],puffer,schreib_position);
      end;

    writeln;
  end;
