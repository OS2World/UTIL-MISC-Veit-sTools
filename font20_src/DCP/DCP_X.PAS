(*$I+*)
(*$D+*)
(*&Use32-*)
program dcp_extractor;
(*$D VIOTBL.DCP decompiler *)
(* 1999.02.05 Veit Kannegieser *)


uses
  Dos;

(*$I VIOTBL.PAS*)

var
  v:dirstr;
  n:namestr;
  e:extstr;

  d1:file;
  log:text;

  zielverzeichnis:string;

  kopf:
    packed record
      kopf_laenge:longint;
      u1:word;
      anzahl_zeichensaetze:word;
    end;



  letzter_font:array[1..32] of array[0..32*256-1] of byte;

function str_feste_laenge(const i,l:longint):string;
  var
    tmp:string;
  begin
    str(i,tmp);
    str_feste_laenge:=copy('00000000',1,l-length(tmp))+tmp;
  end;

{
procedure zeichen_anzeige(nummer,dateiposition,hoehe:longint);
  var
    z1,z2:longint;
    b:byte;
  begin
    seek(d1,dateiposition);
    writeln('  chr(',nummer,')');
    for z1:=1 to hoehe do
      begin
        blockread(d1,b,sizeof(b));
        write('      ',z1:2,' ');
        for z2:=7 downto 0 do
          if (b and (1 shl z2))=0 then
            write(' ')
          else
            write('Û');
        writeln;
      end;

  end;
}

procedure bearbeite(const anfang:longint);
  var
    schriftkopf                 :schrift_kopf_typ;
    zaehler                     :longint;
    d2                          :file;
    ausgabe_dateiname           :string;
    zeichen                     :byte;

  begin
    Seek(d1,anfang);
    BlockRead(d1,schriftkopf,SizeOf(schriftkopf));
    with schriftkopf do
      begin
        ausgabe_dateiname:=zielverzeichnis+'\'
                          +str_feste_laenge(codeseite,5)+'_'
                          +str_feste_laenge(hoehe,2)+'.FN'
                          +str_feste_laenge(breite,1);
        Seek(d1,anfang+kopflaenge);

        if breite=8 then
          begin
            (* laden und merken *)
            BlockRead(d1,letzter_font[hoehe],schriftdaten_laenge);
          end
        else
         begin
            (* aus 8 Punkte breiter Schrift zusammenrechnen *)
            for zaehler:=1 to anzahl_zeichen do
              begin
                BlockRead(d1,zeichen,1);
                (* WriteLn('Chr(',zeichen,')="',Chr(zeichen),'"'); *)
                BlockRead(d1,letzter_font[hoehe][zeichen*hoehe],hoehe);
              end;
          end;

        (* in VIOTBL.DIR schreiben *)
        WriteLn(log,'F ',ausgabe_dateiname,' ',codeseite,' ',breite);

        (* Schriftdatei schreiben *)
        Assign(d2,ausgabe_dateiname);
        FileMode:=$41;
        Rewrite(d2,1);
        BlockWrite(d2,letzter_font[hoehe],hoehe*256);
        Close(d2);
      end; (* while *)
  end;

var
  zaehler       :longint;
  dateiname     :string;
  copy_text     :string;
  font_start    :longint;

begin
  dateiname:=ParamStr(1);
  if dateiname='' then
    dateiname:='VIOTBL.DCP';
  FSplit(dateiname,v,n,e);

  if ParamCount=2 then
    v:=ParamStr(2);

  Assign(d1,dateiname);
  FileMode:=$40;
  Reset(d1,1);
  BlockRead(d1,kopf,SizeOf(kopf));

  zielverzeichnis:=v+n+'.EXT';
  (*$I-*)
  MkDir(zielverzeichnis);
  (*$I+*)
  if IOResult<>0 then (* Verzeichnis existiert schon *);

  Assign(log,v+n+'.DIR');
  FileMode:=$41;
  Rewrite(log);

  WriteLn(log,'# DCP_X * V.K.');
  WriteLn(log,'O ',dateiname);

  Seek(d1,kopf.anzahl_zeichensaetze*4+8);
  BlockRead(d1,copy_text[1],kopf.kopf_laenge-(kopf.anzahl_zeichensaetze*4+8));
  copy_text[0]:=Chr(kopf.kopf_laenge-(kopf.anzahl_zeichensaetze*4+8));

  WriteLn(log,'T ',copy_text);

  for zaehler:=1 to kopf.anzahl_zeichensaetze do
    begin
      Seek(d1,(zaehler-1)*4+8);
      BlockRead(d1,font_start,sizeof(font_start));
      bearbeite(font_start);
    end;

  Close(d1);
  Close(log);

end.

