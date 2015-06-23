(*$I TYP_COMP.PAS*)
unit typein_f;

interface

uses
  typ_type;

procedure loeschen;
procedure farb_edit(var fname:string);

implementation

uses
  crt,
  dos,
  typ_varx,
  typ_spra;

var
  fdname                        :string;
  so                            :aus_attribute;
  fr                            :char;

const
  standardfarbe                 =$1E;

procedure x_inc(var b1:byte;const b2:byte);
  begin
    if b2=1 then
      if (b1 and $0f)=$0f then
         b1:=b1 and $f0
      else
        Inc(b1,b2)
    else
      if (b1 shr 4)=$0f then
        b1:=b1 and $0f
      else
        Inc(b1,b2);
  end;

procedure loeschen;
  begin
    TextAttr:=standardfarbe;
    ClrScr;
    blinken_aus;
  end;

procedure farb_edit(var fname:string);
  var
    fa          :byte;
    datei       :file;

  begin
    loeschen;
    GotoXY(20,10);
    if fname='' then
      fname:='TEST';

    Write(textz_einf__Name_der_Farbdatei^+'? [ '+fname+' ] ');

    ReadLn(fdname);
    if fdname='' then
      begin
        if fname='' then fname:=FExpand('TEST');
        fdname:=fname;
      end
    else
      begin
        fdname:=FExpand(fdname);
        fname:=fdname;
      end;

    (*$I-*)
    Assign(datei,fdname);
    Reset(datei,1);
    (*$I+*)
    if IOResult=0 then
      begin
        BlockRead(datei,ftab,SizeOf(farbtabelle));
        Close(datei);
      end
    else
      begin
        GotoXY(20,12);
        Write(textz_einf__Kommentar^);
        ftab.h:='                              ';
        ReadLn(ftab.h);
      end;
    loeschen;
    repeat
      for so:=normal to rand do
        begin
          GotoXY(22,Ord(so)+3);
          TextAttr:=ftab.f[so,vf]+ftab.f[so,hf];
          WriteLn(' '+Chr(Ord(so)+Ord('A')),'   ',Copy(aus_attr_namen[so]^+'                                       ',1,36));
        end;

      for fa:=0 to 15 do
        begin
          GotoXY(1+5*fa,25);
          TextAttr:=fa;
          Write('лллл');
          if fa<15 then Write(' ');
        end;

      TextAttr:=standardfarbe;
      GotoXY(1,19);
      WriteLn('                  [s] '+textz_einf__speichern^);
      WriteLn('                  [v] '+textz_einf__verwerfen^);
      WriteLn('                  [a]..[',Chr(Ord(rand)+Ord('a')),'] '+textz_einf__Veraendern_der_Vordergrundfarbe^);
      WriteLn('                  [A]..[',Chr(Ord(rand)+Ord('A')),'] '+textz_einf__Veraendern_der_Hintergrundfarbe^);
      Write  ('                   ');
      fr:=ReadKey;
      while fr=#0 do
        begin
          fr:=ReadKey;
          fr:=#1;
        end;

      case fr of
      #27,'V','v':Exit;
      'a'..Chr(Ord(rand)+Ord('a')):
        begin
          x_inc(ftab.f[aus_attribute(Ord(fr)-Ord('a')),vf],1);
        end;
      'A'..Chr(Ord(rand)+Ord('A')):
        begin
          x_inc(ftab.f[aus_attribute(Ord(fr)-Ord('A')),hf],16);
        end;
      end;
    until (UpCase(fr)='S') or (fr=#13);

    Assign(datei,fdname);
    Rewrite(datei,1);
    BlockWrite(datei,ftab,SizeOf(farbtabelle));
    Close(datei);

  end;

end.

