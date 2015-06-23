{&Use32+}{$I+}
program dcp_extractor;
(* 1999.02.05 Veit Kannegieser *)
(* 2004.04.21 IBM VIOTBL-Definition *)


uses
  HilfsFun,
  dcp_form,
  Dos;

var
  v                     :DirStr;
  n                     :NameStr;
  e                     :ExtStr;

  d1                    :file;
  log                   :Text;

  zielverzeichnis       :string;

  kopf                  :fontfilehdr;

  letzter_font          :array[1..32] of array[0..32*256-1] of byte;

  last_codepage         :integer=-1;

const
  codepage_name         :array[1..62] of
    record
      cp                :integer;
      name              :PChar;
   end=
  ((cp: 437;name:'United States'),
   (cp: 813;name:'Greece ISO'),
   (cp: 850;name:'Latin 1 - Multilingual'),
   (cp: 851;name:'Greek (old?)'),
   (cp: 852;name:'Latin 2 - Eastern Europe'),
   (cp: 855;name:'Cyrillic'),
   (cp: 857;name:'Latin 5'),(* Turkish *)
   (cp: 859;name:'Latin 9'),
   (cp: 860;name:'Portugal'),
   (cp: 861;name:'Iceland'),
   (cp: 862;name:'Hebrew'),
   (cp: 863;name:'Canadian French'),
   (cp: 864;name:'Arabic'),
   (cp: 865;name:'Nordic'),
   (cp: 866;name:'Russia'),
   (cp: 869;name:'Greek PC'),
   (cp: 874;name:'Thai'),
   (cp: 915;name:'Cyrillic ISO'),
   (cp: 921;name:'Baltic'),
   (cp: 922;name:'Estonia'),
   (cp: 942;name:'Japan JIS-78'),
   (cp: 943;name:'Japan JIS-90'),
   (cp: 949;name:'Korea KS-code'),
   (cp: 950;name:'Taiwan Big-5'),
   (cp:1004;name:'Windows Latin 1'),
   (cp:1131;name:'Belarus'),
   (cp:1125;name:'Ukraine'),
   (cp:1381;name:'China (PRC) GB'),
   (cp:1381;name:'China (PRC) GBK'),
   (cp:1200;name:'Unicode'),     (* ab hier sind einige nicht sinnvol fÅr 256 Zeichen.., aus showcp.rc *)
   // Windows Codepage
   (cp:1250;name:'Windows Latin 2'),
   (cp:1251;name:'Windows Cyrillic'),
   (cp:1252;name:'Windows Latin 1'),
   (cp:1253;name:'Windows Greek'),
   (cp:1254;name:'Windows Turkish'),
   (cp:1255;name:'Windows Hebrew'),
   (cp:1256;name:'Windows Arabic'),
   (cp:1257;name:'Windows Baltic'),
   // Other Codepages
   (cp: 813;name:'ISO Greek'),
   (cp: 819;name:'ISO Latin 1'),
   (cp: 860;name:'Portuguese'),
   (cp: 861;name:'Icelandic'),
   (cp: 863;name:'Canadian French'),
   (cp: 865;name:'Nordic'),
   (cp: 878;name:'Russian Internet'),
   (cp: 912;name:'ISO Latin 2'),
   (cp: 915;name:'ISO Cyrillic'),
   (cp: 923;name:'ISO Latin 9'),
   (cp:1275;name:'Apple Latin 1'),
   // EBCDIC Codepages
   (cp:  37;name:'EBCDIC US'),
   (cp: 420;name:'EBCDIC Arabic'),
   (cp: 424;name:'EBCDIC Hebrew'),
   (cp: 924;name:'EBCDIC Latin 9'),
   (cp:1140;name:'EBCDIC United States'),
   (cp:1141;name:'EBCDIC Germany'),
   (cp:1142;name:'EBCDIC Denmark, Norway'),
   (cp:1143;name:'EBCDIC Finland, Sweden'),
   (cp:1144;name:'EBCDIC Italy'),
   (cp:1145;name:'EBCDIC Spain'),
   (cp:1146;name:'EBCDIC UK, Ireland'),
   (cp:1147;name:'EBCDIC France'),
   (cp:1148;name:'EBCDIC Latin 1'));


function str_feste_laenge(const i,l:longint):string;
  var
    tmp:string;
  begin
    str(i,tmp);
    str_feste_laenge:=Copy('00000000',1,l-Length(tmp))+tmp;
  end;

procedure bearbeite(const anfang:longint);
  var
    schriftkopf                 :fonthdr;
    zaehler                     :longint;
    d2                          :file;
    ausgabe_dateiname           :string;
    zeichen                     :byte;
    rc                          :word;
    cpname                      :PChar;

  begin
    {$I-}
    Seek(d1,anfang);
    {$I+}
    rc:=IOResult;
    if rc<>0 then
      Abbruch('Can not seek to font header, rc='+Int2Str(rc),rc);

    BlockRead(d1,schriftkopf,SizeOf(schriftkopf));

    with schriftkopf do
      begin
        if last_codepage<>fh_cpid then
          begin
            last_codepage:=fh_cpid;
            WriteLn(log);
            cpname:='(unknown)';
            for zaehler:=Low(codepage_name) to High(codepage_name) do
              with codepage_name[zaehler] do
                if cp=last_codepage then
                  begin
                    cpname:=name;
                    Break;
                  end;
            WriteLn(log,'# codepage ',last_codepage,' -- ',cpname);
            WriteLn(log);
          end;
        ausgabe_dateiname:=zielverzeichnis+'\'
                          +str_feste_laenge(fh_cpid,5)+'_'
                          +str_feste_laenge(fh_cellrows,2)+'.FN'
                          +str_feste_laenge(fh_cellcols,1);

        Seek(d1,anfang+fh_dataoffset);

        if fh_flags=FULL then
          begin
            if (fh_basecols<>0)
            or (fh_baserows<>0) then
              Abbruch('bascols,baserows<>0!',1);
            (* laden und merken *)
            FillChar(letzter_font[fh_cellrows],SizeOf(letzter_font[fh_cellrows]),0);
            BlockRead(d1,letzter_font[fh_cellrows],fh_datalen);
          end
        else
         begin
            (* aus 8 Punkte breiter Schrift zusammenrechnen *)
            if (fh_basecols<>8)
            or (fh_cellcols<>9)
            or (fh_baserows<>fh_cellrows) then
              Abbruch('invalid basecols,baserows!',1);
            for zaehler:=1 to fh_numpoints do
              begin
                BlockRead(d1,zeichen,1);
                (* WriteLn('Chr(',zeichen,')="',Chr(zeichen),'"'); *)
                BlockRead(d1,letzter_font[fh_cellrows][zeichen*fh_cellrows],fh_cellrows);
              end;
          end;

        (* in VIOTBL.DIR schreiben *)
        WriteLn(log,'F ',ausgabe_dateiname,' ',fh_cpid,' ',fh_cellcols);

        (* Schriftdatei schreiben *)
        Assign(d2,ausgabe_dateiname);
        FileMode:=$41;
        Rewrite(d2,1);
        BlockWrite(d2,letzter_font[fh_cellrows],fh_cellrows*256);
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
  if (dateiname='/?') or (dateiname='-?') or (ParamCount>2) then
    begin
      WriteLn('usage: DCP_X [Y:\OS2\BOOT\VIOTBL.DCP [target_directory]]');
      WriteLn('  default target directory is .\, resulting in directory .\VIOTBL.EXT\');
      WriteLn('  with many font files and script file .\VIOTBL.DIR.');
      Halt(1);
    end;

  if dateiname='' then
    dateiname:='VIOTBL.DCP';
  FSplit(dateiname,v,n,e);

  if ParamCount=2 then
    v:=ParamStr(2);

  Assign(d1,dateiname);
  FileMode:=$40;
  {$I-}
  Reset(d1,1);
  {$I+}
  Fehlerbehandlung('Can not open input file '+dateiname,IOResult);
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

  Seek(d1,kopf.ffh_ptroffset+kopf.ffh_numfonts*4);
  copy_text[0]:=Chr(kopf.ffh_length-kopf.ffh_numfonts*4-kopf.ffh_ptroffset);
  BlockRead(d1,copy_text[1],Ord(copy_text[0]));

  WriteLn(log,'T ',copy_text);

  for zaehler:=1 to kopf.ffh_numfonts do
    begin
      Seek(d1,kopf.ffh_ptroffset+(zaehler-1)*4);
      BlockRead(d1,font_start,SizeOf(font_start));
      bearbeite(font_start);
    end;

  Close(d1);
  Close(log);

end.

