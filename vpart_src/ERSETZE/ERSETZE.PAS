program ersetze;

(*&USE32+*)
(*$D ERSETZE ["Replace"] * Veit Kannegieser *)

(* V.K. 08.05.1997 *)
(*      06.03.1998 ohne uses crt *)
(*      11.03.1998 spra_aus      *)
(*      1999.03.19 OS/2          *)

uses
  dos,
  ersetzes;

var
  datei:file;
  puffer:array[0..511] of char;
  findetabelle:array[1..100] of longint;
  anzahl_gefunden:word;
  dateiname:string;
  suchzeichenkette:string;
  ersetzzeichenkette:string;
  oa:word;
  z1,z2:longint;
  fehler:word;
  lesepos:longint;
  gelesen:word;
  gleich:boolean;

procedure gross(var z:char);
  begin
    case z of
      'a'..'z':inc(z,ord('A')-ord('a'));
      '„':z:='Ž';
      '”':z:='™';
      '':z:='š';
    end;
  end;


begin
  writeln('Ersetze * Veit Kannegieser * 1997.05.08úú1999.03.19');
  writeln(textz_titelzeil2^);
  writeln;

  if (paramstr(1)='?')
  or (paramstr(1)='/?')
  or (paramstr(1)='-?') then
    begin
      writeln(textz_hilfezeile1^);
      writeln(textz_hilfezeile2^);
      halt(1);
    end;

  dateiname:=paramstr(1);
  if dateiname='' then
    begin
      writeln(textz_welcher_dateiname^,' ( C:\IBMBIO.COM, C:\COMMAND.COM, ...)');
      write('>');
      readln(dateiname);

      if dateiname='' then halt(1);
    end;
  for z1:=1 to length(dateiname) do gross(dateiname[z1]);

  filemode:=$40;
  assign(datei,dateiname);
  (*$I-*)
  reset(datei,1);
  (*$I+*)
  fehler:=ioresult;

  if fehler<>0 then
    begin
      writeln(textz_Fehler_beim_oeffnen_der_Datei^,dateiname,' ( ',fehler,' )');
      halt(1);
    end;

  suchzeichenkette:=paramstr(2);
  if suchzeichenkette='' then
    begin
      writeln(textz_zu_ersetzende_Zeichenkette^);
      if pos('IO',dateiname)>0 then
        writeln(textz_z_punk_b_punk_doppelpunkt^,' CONFIG.SYS');
      if pos('COMM',dateiname)>0 then
        writeln(textz_z_punk_b_punk_doppelpunkt^,' AUTOEXEC.BAT');

      write('>');
      readln(suchzeichenkette);

      if suchzeichenkette='' then halt(1);

    end;
  for z1:=1 to length(suchzeichenkette) do gross(suchzeichenkette[z1]);


  lesepos:=0;
  anzahl_gefunden:=0;
  repeat
    seek(datei,lesepos);
    if lesepos+length(suchzeichenkette)=filesize(datei) then break;

    blockread(datei,puffer,sizeof(puffer),gelesen);
    for z1:=1 to gelesen do gross(puffer[z1-1]);

    for z1:=1 to gelesen-length(suchzeichenkette) do
      begin
        gleich:=true;
        for z2:=1 to length(suchzeichenkette) do
          begin
            if suchzeichenkette[z2]<>puffer[z1-1+z2-1] then
              begin
                gleich:=false;
                break;
              end;
          end;
        if gleich then
          begin
            inc(anzahl_gefunden);
            findetabelle[anzahl_gefunden]:=lesepos+z1-1;
          end;
      end;

    inc(lesepos,gelesen-length(suchzeichenkette));

  until false;

  close(datei);

  if anzahl_gefunden=0 then
    begin
      writeln(textz_Zeichenkette_nicht_gefunden^);
      halt(1);
    end;

  writeln(textz_Zeichekette_mal_gefunden_a^,anzahl_gefunden,textz_Zeichekette_mal_gefunden_b^);


  ersetzzeichenkette:=paramstr(3);
  if (ersetzzeichenkette='')
  or (length(ersetzzeichenkette)<>length(suchzeichenkette))
   then
    repeat
      writeln(textz_Ersetzen_durch^);
      write('>');
      readln(ersetzzeichenkette);
      if ersetzzeichenkette='' then halt(1);

      if length(ersetzzeichenkette)<>length(suchzeichenkette) then
        writeln(textz_die_zeichenketten_muessen_gleiche_laenge_haben^);

    until length(ersetzzeichenkette)=length(suchzeichenkette);

  getfattr(datei,oa);
  setfattr(datei,0);
  filemode:=2;
  reset(datei,1);
  for z1:=1 to anzahl_gefunden do
    begin
      seek(datei,findetabelle[z1]);
      blockwrite(datei,ersetzzeichenkette[1],length(ersetzzeichenkette));
    end;
  close(datei);
  setfattr(datei,oa);

end.
