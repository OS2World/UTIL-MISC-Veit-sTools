procedure ciscopy;
  const
    ciscopy_spuren_tabelle  :array[1..7] of byte=(40,40,40,40,80,80,80);
    ciscopy_sektoren_tabelle:array[1..7] of byte=( 8, 9, 8, 9, 9,15,18);
    ciscopy_koepfe_tabelle  :array[1..7] of byte=( 1, 1, 2, 2, 2, 2, 2);
  var
    ciscopy_groesse:byte;
    ciscopy_spureinsparung:array[0..80*2-1] of char;
    ciscopy_kompression:byte;
    spur,kopf:word;
  begin
    writeln_clreol('CISCOPY / Klaus Holtorf');
    springe_physikalisch(hand[1],logischer_anfang);
    lies(hand[1],ciscopy_groesse,sizeof(ciscopy_groesse));
    lies(hand[1],ciscopy_spureinsparung,ciscopy_spuren_tabelle[ciscopy_groesse]*ciscopy_koepfe_tabelle[ciscopy_groesse]);
    lies(hand[1],ciscopy_kompression,sizeof(ciscopy_kompression));

    if ciscopy_kompression<>0 then
      abbruch(textz_Die_Quelldatei_ist_komprimiert_IMG_kann_sie_nicht_bearbeiten^);

    test_groessenproblem(longint(ciscopy_spuren_tabelle  [ciscopy_groesse])
                        *longint(ciscopy_sektoren_tabelle[ciscopy_groesse])
                        *longint(ciscopy_koepfe_tabelle  [ciscopy_groesse])
                        *longint(512));

    blockgroesse:=longint(ciscopy_sektoren_tabelle[ciscopy_groesse])*512;

    for spur:=0 to ciscopy_spuren_tabelle[ciscopy_groesse]-1 do
      for kopf:=0 to ciscopy_koepfe_tabelle[ciscopy_groesse]-1 do
        begin
          if ciscopy_spureinsparung[kopf+spur*ciscopy_koepfe_tabelle[ciscopy_groesse]]='L' then
            begin
              write(textz_Lese_____Spur_^,spur:2,textz__Kopf_^,kopf:2,zeitanzeige,^m);
              lies(hand[1],puffer,blockgroesse);
            end
          else
            begin
              write(textz_Fuelle___Spur_^,spur:2,textz__Kopf_^,kopf:2,zeitanzeige,^m);
              fillchar(puffer,blockgroesse,#246);
            end;
          write(    textz_Schreibe_Spur_^,spur:2,textz__Kopf_^,kopf:2,zeitanzeige,^m);
          schreibe(hand[2],puffer,blockgroesse);
        end;
      writeln;

  end;

