procedure hd_copy;
  var
    logische_groesse:longint;
    hc_kopf:
      record
        x_ff:byte;
        x_typ:byte;
        datentraegername:string[8+3];
        groesste_spur:byte;
        groesster_sektor:byte;
        spur_tablelle:array[0..84*2-1] of (fehlerhaft,normal,eingespart);
      end;

    puffer_gefuellt:word;
    spur_zaehler:word;
    kompimiert_blockgroesse:word;
    widerholzeichen:byte;
    lese_index:word;
    schreib_index:word;
    wdh_zaehler:word;
    entschluesselungs_puffer:array[0..512*24*2] of byte;
  begin
    writeln_clreol('HD-Copy / Oliver Fromme');
    if puffer[2]<>0 then writeln('"',string_ptr(addr(puffer[2]))^,'"');

    springe_physikalisch(hand[1],logischer_anfang);
    lies(hand[1],hc_kopf,sizeof(hc_kopf));

    logische_groesse:=longint(2)*hc_kopf.groesste_spur*hc_kopf.groesster_sektor*512;

    test_groessenproblem(logische_groesse);


    inc(logischer_anfang,sizeof(hc_kopf));
    springe_physikalisch(hand[1],logischer_anfang);

    puffer_gefuellt:=0;
    for spur_zaehler:=0 to word(2)*(hc_kopf.groesste_spur+1)-1 do
      begin
        esc_test;
        if hc_kopf.spur_tablelle[spur_zaehler]=normal then
          begin
            write(textz_Lese_____Spur_^,spur_zaehler div 2:2,textz__Kopf_^,spur_zaehler mod 2:2,zeitanzeige,^m);
            lies(hand[1],kompimiert_blockgroesse,sizeof(kompimiert_blockgroesse));

            lies(hand[1],puffer,kompimiert_blockgroesse);

            widerholzeichen:=puffer[0];
            lese_index:=1;
            schreib_index:=0;

            repeat
              if puffer[lese_index]=widerholzeichen then
                begin
                  inc(lese_index);
                  wdh_zaehler:=puffer[lese_index+1];
                  while wdh_zaehler>0 do
                    begin
                      entschluesselungs_puffer[schreib_index]:=puffer[lese_index];
                      inc(schreib_index);
                      dec(wdh_zaehler);
                    end;
                  inc(lese_index,2);
                end
              else
                begin
                  entschluesselungs_puffer[schreib_index]:=puffer[lese_index];
                  inc(schreib_index);
                  inc(lese_index);
                end;
            until lese_index=kompimiert_blockgroesse;


          end
        else
          begin
            write(textz_Fuelle___Spur_^,spur_zaehler div 2:2,textz__Kopf_^,spur_zaehler mod 2:2,zeitanzeige,^m);
            fillchar(entschluesselungs_puffer,sizeof(entschluesselungs_puffer),#246);
          end;

        write(    textz_Schreibe_Spur_^,spur_zaehler div 2:2,textz__Kopf_^,spur_zaehler mod 2:2,zeitanzeige,^m);
        schreibe(hand[2],entschluesselungs_puffer,word(512)*hc_kopf.groesster_sektor);
      end;

    writeln;
  end;
