program dcp_a;
(*$I+*)(*$X+*)(*$USE32-*)
(*$D VIOTBL.DCP assembler *)

(* 1999.03.26 Veit Kannegieser *)

(*$I VIOTBL.PAS*)

var
  quelle                        :text;
  dateiname                     :string;
  zeile                         :string;
  zieldatei,schrift_datei       :file;

  datei_ende_position           :longint;

  kontrolle                     :longint;
  schrift_puffer,komprimiert    :array[0..32*256-1] of byte;
  letzter_font                  :array[1..32] of array[0..32*256-1] of byte;
  kopf0                         :viotbl_anfang_typ;
  schrift_kopf                  :schrift_kopf_typ;
  schriftdatei_laenge           :longint;
  z1,z2                         :longint;
  gleich                        :boolean;

const
  copyr_text:string='DCP_A / V.K.';
  zieldateiname:string='VIOTBL.DCP';
  schriften:longint=0;

function val_(var z:string;const standardwert:longint;const kommentar:string):longint;
  var
    kontrolle:longint;
    anfang:string;
    temp:longint;
  begin
    while (z<>'') and (z[Length(z)]=' ') do dec(z[0]);
    while (z<>'') and (z[1]=' ') do Delete(z,1,1);

    if pos(' ',z)=0 then
      begin
        anfang:=z;
        z:='';
      end
    else
      begin
        anfang:=Copy(z,1,pos(' ',z)-1);
        Delete(z,1,Length(anfang)+1);
      end;

    Val(anfang,temp,kontrolle);
    if kontrolle=0 then
      val_:=temp
    else
      begin
        writeln(kommentar);
        val_:=standardwert;
      end;
  end;


begin
  dateiname:=ParamStr(1);
  if dateiname='' then
    dateiname:='VIOTBL.DIR';

  Assign(quelle,dateiname);
  Reset(quelle);

  (* 1. Durchlauf: Ausgabdateiname,Text,Anzahl der Einzeldateien *)
  while not Eof(quelle) do
    begin
      readln(quelle,zeile);
      if zeile='' then continue;

      case zeile[1] of
        'O':zieldateiname:=copy(zeile,3,255);
        'T':copyr_text   :=copy(zeile,3,255);
        'F':inc(schriften);
      end;

    end;

  Reset(quelle);
  Assign(zieldatei,zieldateiname);
  ReWrite(zieldatei,1);

  with kopf0 do
    begin
      anfang_daten:=SizeOf(kopf0)+schriften*4+length(copyr_text);
      viotbl_anfang_laenge:=SizeOf(kopf0);
      viotbl_anzahl_eintraege:=schriften;
    end;
  BlockWrite(zieldatei,kopf0,SizeOf(kopf0));
  Seek(zieldatei,SizeOf(kopf0)+schriften*4);
  BlockWrite(zieldatei,copyr_text[1],Length(copyr_text));
  datei_ende_position:=kopf0.anfang_daten;
  schriften:=0;

  (* 2.Durchlauf: Schriften Kopieren *)
  while not Eof(quelle) do
    begin
      ReadLn(quelle,zeile);
      if zeile='' then continue;

      while Pos(#9,zeile)<>0 do
        zeile[Pos(#9,zeile)]:=' ';

      case zeile[1] of
        'F':
          begin
            Inc(schriften);
            Seek(zieldatei,SizeOf(kopf0)+(schriften-1)*4);
            BlockWrite(zieldatei,datei_ende_position,4);
            Seek(zieldatei,datei_ende_position);

            repeat
              Delete(zeile,1,2);
            until (zeile='') or (zeile[1]<>' ');

            zeile:=zeile+' ';
            dateiname:=Copy(zeile,1,pos(' ',zeile)-1);
            Delete(zeile,1,Length(dateiname)+1);

            Write('+ ',dateiname,' ');
            Assign(schrift_datei,dateiname);
            Reset(schrift_datei,1);
            schriftdatei_laenge:=FileSize(schrift_datei);
            BlockRead(schrift_datei,schrift_puffer,schriftdatei_laenge);
            Close(schrift_datei);

            with schrift_kopf do
              begin
                kopflaenge:=SizeOf(schrift_kopf);
                null_oder_drei:=0;
                erforderliche_breite:=0;
                erforderliche_hoehe:=0;
                kopflaenge2:=SizeOf(schrift_kopf);
                anzahl_zeichen:=256;
                erstes_zeichen:=0;
                letztes_zeichen:=255;

                codeseite:=val_(zeile,437,'CODEPAGE=???'#7);

                breite:=val_(zeile,8,'B=???'#7);
                if (breite<8) or (breite>9) then
                  begin
                    WriteLn('Zeichenreite 8 oder 9/Chars 8 or 9 wide !');
                    runerror(1);
                  end;

                hoehe:=schriftdatei_laenge div 256;

                if breite=8 then
                  begin
                    schriftdaten_laenge:=schriftdatei_laenge;
                    Move(schrift_puffer,letzter_font[hoehe],schriftdaten_laenge);
                  end
                else
                  begin
                    null_oder_drei:=3;
                    erforderliche_breite:=8;
                    erforderliche_hoehe:=hoehe;
                    schriftdaten_laenge:=0;
                    anzahl_zeichen:=0;
                    erstes_zeichen:=255;

                    for z1:=0 to 255 do
                      begin
                        gleich:=true;
                        for z2:=0 to hoehe-1 do
                          gleich:=gleich and (schrift_puffer[z1*hoehe+z2]=letzter_font[hoehe,z1*hoehe+z2]);
                        if (z1=255) and (anzahl_zeichen=0) then
                          gleich:=false;
                        if not gleich then
                          begin
                            if erstes_zeichen>z1 then
                              erstes_zeichen:=z1;
                            letztes_zeichen:=z1;

                            (* Nummer des Zeichens *)
                            komprimiert[schriftdaten_laenge]:=z1;
                            Inc(schriftdaten_laenge);
                            (* Grafikdaten *)
                            Move(schrift_puffer[z1*hoehe],komprimiert[schriftdaten_laenge],hoehe);
                            Inc(schriftdaten_laenge,hoehe);
                            inc(anzahl_zeichen);
                          end;
                      end; (* 0..255 *)
                  end; (* 9 *)

                schrift_gesamt_laenge:=kopflaenge+schriftdaten_laenge;
              end;



            BlockWrite(zieldatei,schrift_kopf,SizeOf(schrift_kopf));
            if schrift_kopf.breite=8 then
              BlockWrite(zieldatei,schrift_puffer,schrift_kopf.schriftdaten_laenge)
            else
              BlockWrite(zieldatei,komprimiert,schrift_kopf.schriftdaten_laenge);
            datei_ende_position:=FilePos(zieldatei);
            writeln;
          end;
      end;
    end;


  WriteLn;
  Close(quelle);
  Close(zieldatei);
end.

