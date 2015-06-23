{&Use32+}
program dcp_a;
(*$I+*)(*$X+*)(*$USE32-*)
(*$D VIOTBL.DCP assembler *)

(* 1999.03.26 Veit Kannegieser *)

uses
  Objects,
  VpUtils,
  VpSysLow,
  HilfsFun,
  dcp_form;

var
  quelle                        :Text;
  dateiname                     :string;
  zeile                         :string;
  zieldatei,schrift_datei       :file;

  datei_ende_position           :longint;

  kontrolle                     :longint;
  schrift_puffer,komprimiert    :array[0..32*256-1] of byte;
  letzter_font                  :array[1..32] of array[0..32*256-1] of byte;
  kopf0                         :fontfilehdr;
  schrift_kopf                  :fonthdr;
  schriftdatei_laenge           :longint;
  z1,z2                         :longint;
  gleich                        :boolean;
  benutzte_codeseite            :array[0..$ffff] of word;
  aktuelle_codeseite            :word;
  schriften_fuer_diese_codeseite:array[1..32*2] of record x,y:byte end;
  schriften_fuer_diese_codeseite_zaehler:word;
  schriften_fuer_diese_codeseite_test:word;
  basefont_vorhanden            :boolean;
  result_file_buffer            :pByteArray=nil;

const
  copyr_text                    :string='DCP_A / V.K.';
  zieldateiname                 :string='VIOTBL.DCP';
  schriften                     :longint=0;

function val_(var z:string;const standardwert:longint;const kommentar:string):longint;
  var
    kontrolle                   :longint;
    anfang                      :string;
    temp                        :longint;
  begin
    while (z<>'') and (z[Length(z)]=' ') do Dec(z[0]);
    while (z<>'') and (z[1        ]=' ') do Delete(z,1,1);

    if pos(' ',z)=0 then
      begin
        anfang:=z;
        z:='';
      end
    else
      begin
        anfang:=Copy(z,1,Pos(' ',z)-1);
        Delete(z,1,Length(anfang)+1);
      end;

    Val(anfang,temp,kontrolle);
    if kontrolle=0 then
      val_:=temp
    else
      begin
        WriteLn(kommentar);
        val_:=standardwert;
      end;
  end;

procedure pruefe_64k_grenze(cp_jetzt:word);
  var
    i,cp_max,cp_max_wert:word;
  begin
    cp_max:=Low(benutzte_codeseite);
    cp_max_wert:=benutzte_codeseite[cp_max];
    for i:=Low(benutzte_codeseite) to High(benutzte_codeseite) do
      if i<>cp_jetzt then
        if cp_max_wert<benutzte_codeseite[i] then
           begin
             cp_max:=i;
             cp_max_wert:=benutzte_codeseite[cp_max];
           end;
    if cp_max_wert+benutzte_codeseite[cp_jetzt]>$ff00 then
      Abbruch('Too many font data (>64KB). Sum of Codepage '
        +Int2Str(cp_max)+'+'+Int2Str(cp_jetzt)+': '+Int2Str(cp_max_wert+benutzte_codeseite[cp_jetzt]),1);
  end;


begin
  Fillchar(benutzte_codeseite,SizeOf(benutzte_codeseite),0);
  aktuelle_codeseite:=0;

  dateiname:=ParamStr(1);
  if dateiname='' then
    dateiname:='VIOTBL.DIR';

  if (dateiname='/?') or (dateiname='-?') or (ParamCount>1) then
    begin
      WriteLn('usage: DCP_A [scriptfile]');
      WriteLn('  default scriptfile is VIOTBL.DIR.');
      Halt(1);
    end;

  Assign(quelle,dateiname);
  Reset(quelle);

  (* 1. Durchlauf: Ausgabdateiname,Text,Anzahl der Einzeldateien *)
  while not Eof(quelle) do
    begin
      ReadLn(quelle,zeile);
      if zeile='' then Continue;

      case zeile[1] of
        'O':zieldateiname:=Copy(zeile,3,255);
        'T':copyr_text   :=Copy(zeile,3,255);
        'F':Inc(schriften);
        '#':
      else
        WriteLn('unknown command: ',zeile);
      end;

    end;

  Reset(quelle);

  with kopf0 do
    begin
      ffh_flags:=0;
      ffh_ptroffset:=SizeOf(fontfilehdr);
      ffh_numfonts:=schriften;
      ffh_length:=ffh_ptroffset+ffh_numfonts*4+Length(copyr_text);
    end;

  (* font file header *)
  datei_ende_position:=0;
  GetMem(result_file_buffer,datei_ende_position+SizeOf(kopf0));
  Move(kopf0,result_file_buffer^[datei_ende_position],SizeOf(kopf0));

  (* font header pointer table *)
  ReallocMem(result_file_buffer,kopf0.ffh_ptroffset+kopf0.ffh_numfonts*4);
  FillChar(result_file_buffer^[kopf0.ffh_ptroffset],kopf0.ffh_numfonts*4,0);
  datei_ende_position:=kopf0.ffh_ptroffset+kopf0.ffh_numfonts*4;

  (* Kommentartext *)
  ReallocMem(result_file_buffer,datei_ende_position+Length(copyr_text));
  Move(copyr_text[1],result_file_buffer^[datei_ende_position],Length(copyr_text));
  datei_ende_position:=kopf0.ffh_length;
  schriften:=0;

  (* 2.Durchlauf: Schriften Kopieren *)
  while not Eof(quelle) do
    begin
      ReadLn(quelle,zeile);
      if zeile='' then Continue;

      while Pos(#9,zeile)<>0 do
        zeile[Pos(#9,zeile)]:=' ';

      case zeile[1] of
        'F':
          begin
            Inc(schriften);

            (* update pointer to font header *)
            Move(datei_ende_position,result_file_buffer^[SizeOf(kopf0)+(schriften-1)*4],4);

            Delete(zeile,1,Length('F '));
            while (zeile<>'') and (zeile[1]=' ') do Delete(zeile,1,1);

            zeile:=zeile+' ';
            dateiname:=Copy(zeile,1,pos(' ',zeile)-1);
            Delete(zeile,1,Length(dateiname)+1);

            Write('+ ',dateiname,' ');
            Assign(schrift_datei,dateiname);
            FileMode:=$40;
            Reset(schrift_datei,1);
            schriftdatei_laenge:=FileSize(schrift_datei);
            if ((schriftdatei_laenge and $ff)<>0)
            or ((schriftdatei_laenge shr 8)< 6)
            or ((schriftdatei_laenge shr 8)>32) then
              Abbruch('Bad filesize, can not be a font.',1);
            BlockRead(schrift_datei,schrift_puffer,schriftdatei_laenge);
            Close(schrift_datei);

            with schrift_kopf do
              begin
                fh_hdrlen:=SizeOf(schrift_kopf);
                fh_type:=0;
                fh_flags:=FULL;
                fh_basecols:=0;
                fh_baserows:=0;
                fh_dataoffset:=fh_hdrlen;
                fh_numpoints:=256;
                fh_lowpoint:=0;
                fh_highpoint:=255;

                fh_cpid:=val_(zeile,437,'CODEPAGE=???'#7);

                fh_cellcols:=val_(zeile,8,'B=???'#7);
                if (fh_cellcols<8) or (fh_cellcols>9) then
                  Abbruch('Zeichenreite 8 oder 9/Chars 8 or 9 wide!',1);

                fh_cellrows:=schriftdatei_laenge div fh_numpoints;

                if aktuelle_codeseite<>fh_cpid then
                  begin
                    if benutzte_codeseite[fh_cpid]<>0 then
                      Abbruch('Codepage was already used; group codepage usage!',1);
                    aktuelle_codeseite:=fh_cpid;
                    FillChar(schriften_fuer_diese_codeseite,SizeOf(schriften_fuer_diese_codeseite),0);
                    schriften_fuer_diese_codeseite_zaehler:=0;
                  end;

                if schriften_fuer_diese_codeseite_zaehler>High(schriften_fuer_diese_codeseite) then
                  Abbruch('Too many fonts.',1);

                case schriften_fuer_diese_codeseite_zaehler+1 of
                  1:if (fh_cellcols<>8) or (fh_cellrows<>8) then
                      begin Writeln('Warning: Font #1 should be 8x8'^G) ;SysCtrlSleep(5000);end;
                  2:if (fh_cellcols<>8) or (fh_cellrows<>14) then
                      begin WriteLn('Warning: Font #2 should be 8x14'^G);SysCtrlSleep(5000);end;
                  3:if (fh_cellcols<>8) or (fh_cellrows<>16) then
                      begin WriteLn('Warning: Font #3 should be 8x14'^G);SysCtrlSleep(5000);end;
                  4:if (fh_cellcols<>9) or (fh_cellrows<>14) then
                      begin WriteLn('Warning: Font #4 should be 9x14'^G);SysCtrlSleep(5000);end;
                  5:if (fh_cellcols<>9) or (fh_cellrows<>16) then
                      begin WriteLn('Warning: Font #5 should be 9x14'^G);SysCtrlSleep(5000);end;
                end;

                basefont_vorhanden:=false;
                for schriften_fuer_diese_codeseite_test:=Low(schriften_fuer_diese_codeseite) to schriften_fuer_diese_codeseite_zaehler do
                  with schriften_fuer_diese_codeseite[schriften_fuer_diese_codeseite_test] do
                    begin
                      if (fh_cellcols=x) and (fh_cellrows=y) then
                        Abbruch('Can not define font size multiple times!',1);
                      if (fh_cellcols=x+1) and (fh_cellrows=y) then
                        basefont_vorhanden:=true;
                    end;
                Inc(schriften_fuer_diese_codeseite_zaehler);
                with schriften_fuer_diese_codeseite[schriften_fuer_diese_codeseite_zaehler] do
                  begin
                    x:=fh_cellcols;
                    y:=fh_cellrows;
                  end;

                if fh_cellcols=8 then
                  begin
                    fh_datalen:=schriftdatei_laenge;
                    Move(schrift_puffer,letzter_font[fh_cellrows],fh_datalen);
                    (* nicht gepackte Daten belegen Header(12)+Daten+1 Byte in BVHSVGA.DLL.. *)
                    Inc(benutzte_codeseite[fh_cpid],12+fh_datalen+1);
                    pruefe_64k_grenze(fh_cpid);
                  end
                else
                  begin
                    if not basefont_vorhanden then
                      Abbruch('Can not use cells wide 9, if not already defined width 8 in that codepage group!',1);

                    fh_flags:=PARTIAL+CODEPTS;
                    fh_basecols:=8;             // 9->8
                    fh_baserows:=fh_cellrows;   // h->h
                    fh_datalen:=0;
                    fh_numpoints:=0;
                    fh_lowpoint:=255;

                    for z1:=0 to 255 do
                      begin
                        gleich:=true;
                        for z2:=0 to fh_cellrows-1 do
                          gleich:=gleich and (schrift_puffer[z1*fh_cellrows+z2]=letzter_font[fh_cellrows,z1*fh_cellrows+z2]);
                        if (z1=255) and (fh_numpoints=0) then
                          gleich:=false;
                        if not gleich then
                          begin
                            if fh_lowpoint>z1 then
                              fh_lowpoint:=z1;
                            fh_highpoint:=z1;

                            (* Nummer des Zeichens *)
                            komprimiert[fh_datalen]:=z1;
                            Inc(fh_datalen);
                            (* Grafikdaten *)
                            Move(schrift_puffer[z1*fh_cellrows],komprimiert[fh_datalen],fh_cellrows);
                            Inc(fh_datalen,fh_cellrows);
                            inc(fh_numpoints);
                          end;
                      end; (* 0..255 *)

                    (* gepackte Daten belegen zweimal Speicherplatz in BVHSVGA.DLL.. *)
                    Inc(benutzte_codeseite[fh_cpid],12+fh_datalen+1+12+256*fh_cellrows+1);
                    pruefe_64k_grenze(fh_cpid);
                  end; (* 9 *)

                fh_length:=fh_hdrlen+fh_datalen;
              end;

            (* font header *)
            ReallocMem(result_file_buffer,datei_ende_position+SizeOf(schrift_kopf)+schrift_kopf.fh_datalen);
            Move(schrift_kopf,result_file_buffer^[datei_ende_position],SizeOf(schrift_kopf));
            Inc(datei_ende_position,SizeOf(schrift_kopf));
            (* font data *)
            if schrift_kopf.fh_flags=FULL then
              Move(schrift_puffer,result_file_buffer^[datei_ende_position],schrift_kopf.fh_datalen)
            else
              Move(komprimiert   ,result_file_buffer^[datei_ende_position],schrift_kopf.fh_datalen);
            Inc(datei_ende_position,schrift_kopf.fh_datalen);
            WriteLn;
          end;
      end;
    end;


  Assign(zieldatei,zieldateiname);
  {$I-}
  ReWrite(zieldatei,1);
  {$I+}
  Fehlerbehandlung('Can not create '+zieldateiname,IOResult);
  BlockWrite(zieldatei,result_file_buffer^[0],datei_ende_position);
  Dispose(result_file_buffer);
  Close(quelle);
  Close(zieldatei);
  WriteLn;
end.

