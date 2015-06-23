procedure roh_kopierer;
  var
    logische_groesse:longint;
    dateilaenge_sagt_bootsektor:longint;
  begin
    logische_groesse:=hand[1].groesse-logischer_anfang;

    if hand[1].datei_oder_laufwerk='D' then
      begin
        springe_physikalisch(hand[1],logischer_anfang);
        lies(hand[1],puffer,512);

        if  (puffer[$0] in [$e9,$eb])               (* Sprung *)
        and (puffer[$b]=0) and (puffer[$c]=2)       (* 512 Byte/Sektor *)
         then
          begin
            dateilaenge_sagt_bootsektor:=longint(word_ptr(addr(puffer[$13]))^)*512;
            if dateilaenge_sagt_bootsektor=0 then
              dateilaenge_sagt_bootsektor:=longint_ptr(addr(puffer[$20]))^*512;
            if dateilaenge_sagt_bootsektor>0 then
              begin
                if logische_groesse=dateilaenge_sagt_bootsektor+419 then
                  (* DiskCopy DR/NW/OD *)
                  writeln('Diskcopy-'+textz_Anhang^+' (DR/NW/OD-DOS)');
                logische_groesse:=dateilaenge_sagt_bootsektor;
              end;

          end
        else
          abbruch(textz_Bootsektor_fehlerhaft^);
      end;


    write(textz_Rohformat^);
    if logischer_anfang<>0 then
      write(textz__ab_^,tausenderpunkt(logischer_anfang),' )');
    clreol;
    writeln;

    springe_physikalisch(hand[1],logischer_anfang);

    test_groessenproblem(logische_groesse);


    (*$IFDEF OS2*)
    blockgroesse:=logische_groesse div 8;
    if blockgroesse>sizeof(puffer) then blockgroesse:=sizeof(puffer);
    (*$ELSE*)
    blockgroesse:=logische_groesse div 8{0};
    if blockgroesse>sizeof(puffer) then blockgroesse:=sizeof(puffer);
    (*$ENDIF*)

    while logische_groesse>hand[2].position do
      begin
        esc_test;
        if blockgroesse>(logische_groesse-hand[2].position) then
          blockgroesse:=(logische_groesse-hand[2].position);

        if blockgroesse+hand[1].position>hand[1].groesse then
          blockgroesse:=hand[1].groesse-hand[1].position;

        if blockgroesse>0 then
          begin
            write(textz_Lesen______^,tausenderpunkt(hand[1].position),'/',tausenderpunkt(hand[2].position),'/',
              tausenderpunkt(logische_groesse),'>',zeitanzeige,^m);
            lies(hand[1],puffer,blockgroesse);
          end
        else
          begin
            write(textz_Fuelle_____^,tausenderpunkt(hand[1].position),'/',tausenderpunkt(hand[2].position),'/',
              tausenderpunkt(logische_groesse),'>',zeitanzeige,^m);
            blockgroesse:=512;
            fillchar(puffer,blockgroesse,$f6); (* 'ö' *)
          end;

        esc_test;
        write(    textz_Schreiben__^,tausenderpunkt(hand[1].position),'/',tausenderpunkt(hand[2].position),'/',
              tausenderpunkt(logische_groesse),'>',zeitanzeige,^m);
        schreibe(hand[2],puffer,blockgroesse);
      end;

    writeln(      '          <'     ,tausenderpunkt(hand[1].position),'/',tausenderpunkt(hand[2].position),'/',
              tausenderpunkt(logische_groesse),'>',zeitanzeige);
  end;
