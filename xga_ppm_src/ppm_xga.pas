{Use32+}
program ppm_xga;

Uses
  Dos,
  Objects,
  VpUtils,
  XGA,
  ppm_xgas;

const
  readbuffersize        =512*1024;
type
  readbuffertype        =array[0..readbuffersize-1] of byte;

var
  d1                    :text;
  d2                    :file;
  p                     :pByteArray;
  x,y,i,l,zx,zy         :Longint;
  z                     :string;
  r,g,b                 :smallword;
  hoechster_grauwert    :word;
  extra_daten_im_kommentar:boolean;
  readbuffer            :^readbuffertype;
  tab31                 :pByteArray;
  tab63                 :pByteArray;

function encode_color:word;
  begin
    (* Integer: *)
    //Result:=((r*$1f) div hoechster_grauwert) (* 5 Bit *) shl 11
    //       +((g*$3f) div hoechster_grauwert) (* 6 Bit *) shl  5
    //       +((b*$1f) div hoechster_grauwert) (* 5 Bit *) shl  0;
    (* fpu: *)
    //Result:=Round(r*$1f/hoechster_grauwert) (* 5 Bit *) shl 11
    //       +Round(g*$3f/hoechster_grauwert) (* 6 Bit *) shl  5
    //       +Round(b*$1f/hoechster_grauwert) (* 5 Bit *) shl  0;
    (* Tabelle *)
    Result:=tab31^[r] (* 5 Bit *) shl 11
           +tab63^[g] (* 6 Bit *) shl  5
           +tab31^[b] (* 5 Bit *) shl  0;
  end;

procedure Fehler(const fehlermeldung:string);
  begin
    WriteLn(fehlermeldung);
    RunError(99);
  end;

function lies_zeichen:char;
  var
    c                   :char;
    kommentar           :boolean;
  begin
    kommentar:=false;
    repeat
      if Eof(d1) then
        begin
          lies_zeichen:=' ';
          Exit;
        end;
      Read(d1,c);
      if c='#' then kommentar:=true;
      if c in [^M,^J] then kommentar:=false;
    until not kommentar;
    lies_zeichen:=c;
  end;

procedure werte_kommentar(const s:string);
  var
    i                   :word;
    c                   :char;
  begin
    extra_daten_im_kommentar:=false;
    i:=1;
    while i<=Length(s) do
      if Eof(d1) then
        Exit
      else
      if EoLn(d1) then
        ReadLn(d1)
      else
        begin
          repeat
            Read(d1,c);
          until (i>1) or (not (c in leerzeichen));
          if c<>s[i] then Exit;
          Inc(i);
        end;
    extra_daten_im_kommentar:=true;
  end;

function lies_zahl:word;
  var
    z                   :word;
    c                   :char;
  begin
    repeat
      c:=lies_zeichen;
      if Eof(d1) then Fehler(textz_unerwartetes_Dateiende^);
    until not (c in leerzeichen);

    z:=0;
    repeat
      if c in ['0'..'9'] then
        z:=z*10+Ord(c)-Ord('0')
      else
        Fehler(textz_Keine_gueltige_Zahl^);

      c:=lies_zeichen;
    until c in leerzeichen;

    lies_zahl:=z;
  end;

procedure lies_oder_frage(const frage:string;const minval,maxval:word;var w:smallword);
  var
    tmp                 :word;

  begin

    if extra_daten_im_kommentar then
      begin
        tmp:=lies_zahl;
        if (minval<=tmp) and (tmp<=maxval) then
          begin
            WriteLn(frage,'(',minval,'..',maxval,') ',tmp);
            w:=tmp;
            Exit;
          end;
      end;

    repeat
      Write(frage,'(',minval,'..',maxval,') ');
      Read(tmp);
      if not IsFileHandleConsole(TextRec(Input).Handle) then Write(tmp);
      If Eoln then ReadLn;
      if not IsFileHandleConsole(TextRec(Input).Handle) then WriteLn;
    until (minval<=tmp) and (tmp<=maxval);
    w:=tmp;
  end;

begin

  if (ParamCount<>2) or (ParamStr(1)='/?') or (ParamStr(1)='-?') then
    begin
      WriteLn(textz_benutzung1^);
      WriteLn(textz_benutzung2^);
      Halt(1);
    end;

  Assign(d1,ParamStr(1));
  Reset(d1);
  New(readbuffer);
  SetTextBuf(d1,readbuffer^);
  if lies_zeichen<>'P' then Fehler(textz_Kein_PPM_P3^);
  if lies_zeichen<>'3' then Fehler(textz_Kein_PPM_P3^);
  x:=lies_zahl;
  y:=lies_zahl;
  if not (   ((x= 640) and (y=480))
          or ((x= 800) and (y=600))
          or ((x=1024) and (y=768))) then
    begin
      WriteLn(textz_Warning__recommended_sizes_are_800_600__maybe_640_480_and_1024_768__^);
    end;
  hoechster_grauwert:=lies_zahl;
  l:=$200+x*y*2;
  GetMem(p,l);
  FillChar(p^,l,0);

  GetMem(tab31,hoechster_grauwert+1);
  GetMem(tab63,hoechster_grauwert+1);
  for i:=0 to hoechster_grauwert do tab31^[i]:=Round(i*31/hoechster_grauwert);
  for i:=0 to hoechster_grauwert do tab63^[i]:=Round(i*63/hoechster_grauwert);

  for zy:=0 to y-1 do
    for zx:=0 to x-1 do
      begin
        r:=lies_zahl;
        g:=lies_zahl;
        b:=lies_zahl;
        pSmallWord(@p^[$200+((y-1-zy)*x+zx)*2])^:=encode_color;
      end;


  with t_xga_header(p^[0]) do
    begin
      signature:=xga_signature;
      kopflaenge:=$200;
      datenlaenge:=x*y*2;
      bild_x:=x;
      bild_y:=y;
      werte_kommentar('# SAVE2DSK.XGA extra informations:');
      werte_kommentar('#*BAR_POS_X');
      lies_oder_frage(textz_BAR_position_X^,0,x-10,balken_start_x);
      werte_kommentar('#*BAR_POS_Y');
      lies_oder_frage(textz_BAR_position_Y^,0,y- 1,balken_start_y);
      werte_kommentar('#*BAR_SIZE_X');
      lies_oder_frage(textz_BAR_size_X^,10,x-balken_start_x{-1},balken_groesse_x);
      werte_kommentar('#*BAR_SIZE_Y');
      lies_oder_frage(textz_BAR_size_Y^, 1,y-balken_start_y{-1},balken_groesse_y);
      werte_kommentar('#*BAR_COLOR');
      lies_oder_frage(textz_BAR_progress_color_RED__^,0,hoechster_grauwert,r);
      lies_oder_frage(textz_BAR_progress_color_GREEN^,0,hoechster_grauwert,g);
      lies_oder_frage(textz_BAR_progress_color_BLUE_^,0,hoechster_grauwert,b);
      balkenfarbe:=encode_color;
    end;

  Assign(d2,ParamStr(2));
  Rewrite(d2,1);
  BlockWrite(d2,p^,l);
  Close(d1);
  Close(d2);
  Dispose(p);
  Dispose(tab31);
  Dispose(tab63);
  Dispose(readbuffer);
end.

