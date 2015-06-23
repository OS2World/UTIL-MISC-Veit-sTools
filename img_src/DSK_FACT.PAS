procedure disk_factory;
  var
    dfy_kopf:
      record
        sig:longint;
        u_004:byte; (* ? *)
        dateiname:string[8];
        kommentar:string[25];
        spuren:byte;
        sekt_spur:byte;
        datentraegername:string[11];
      end;

    spuren_tabelle:
      array[0..80*2-1] of
        record
          datei_ofs:longint;
          laenge:word;
          ur_007:byte; (* ? *)
        end;

    spur,kopf:word;
    blockgroesse:longint;
  begin
    springe_physikalisch(hand[1],logischer_anfang);
    lies(hand[1],dfy_kopf,sizeof(dfy_kopf));
    lies(hand[1],spuren_tabelle,dfy_kopf.spuren*2*7);

    blockgroesse:=longint(dfy_kopf.sekt_spur)*512;

    test_groessenproblem(longint(dfy_kopf.spuren)
                        *longint(blockgroesse)
                        *longint(2));


    for spur:=0 to dfy_kopf.spuren-1 do
      for kopf:=0 to 2-1 do
        begin
          if spuren_tabelle[spur*2+kopf].laenge=0 then
            begin
              write(textz_Fuelle___Spur_^,spur:2,textz__Kopf_^,kopf:2,zeitanzeige,^m);
              fillchar(puffer,blockgroesse,#246);
            end
          else
            begin
              write(textz_Lese_____Spur_^,spur:2,textz__Kopf_^,kopf:2,zeitanzeige,^m);
              springe_physikalisch(hand[1],logischer_anfang+spuren_tabelle[spur*2+kopf].datei_ofs);
              lies(hand[1],puffer,blockgroesse);
            end;


          write(    textz_Schreibe_Spur_^,spur:2,textz__Kopf_^,kopf:2,zeitanzeige,^m);
          schreibe(hand[2],puffer,blockgroesse);
        end;

    writeln;
  end;

