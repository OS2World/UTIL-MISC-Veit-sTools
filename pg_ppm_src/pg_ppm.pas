{$B-,D+,H-,I-,J+,P-,Q+,R+,S+,T-,V+,W+,X+,Z-}
{&AlignCode+,AlignData+,AlignRec-,Asm-,Cdecl-,Comments-,Delphi+,Frame+,G3+}
{&G5-,LocInfo+,Open32-,Optimise-,OrgName-,SmartLink+,Speed+,Use32-,ZD-}
{$M 32768}
program pg_ppm;

// Veit Kannegieser 2004.02.02..08.25

uses
  Dos,
  Objects,
  Strings,
  VpUtils;

type
  pWord=^smallword;

var
  p                     :pByteArray;
  d                     :file;
  a                     :text;
  l,i                   :longint;
  f,x,y,x2,y2,xi,yi,xb  :word;
  pal                   :array[0..15] of array[0..3] of byte;
  palette               :boolean;
  z                     :string;
  b                     :pByteArray;
  fb,fw                 :byte;
  Dir                   :DirStr;
  Name                  :NameStr;
  Ext                   :ExtStr;
  rc                    :integer;


function fa(b:byte):string;
  begin
    fa:=Int2Str(pal[b,1])+' '
       +Int2Str(pal[b,2])+' '
       +Int2Str(pal[b,3])+' ';
  end;

const (* BP example *)
  EGAColors: array[0..15] of record RedVal,GreenVal,BlueVal:byte end =
    (                                     {NAME       COLOR}
    (RedVal:$00;GreenVal:$00;BlueVal:$00),{Black      EGA  0}
    (RedVal:$00;GreenVal:$00;BlueVal:$FC),{Blue       EGA  1}
    (RedVal:$24;GreenVal:$FC;BlueVal:$24),{Green      EGA  2}
    (RedVal:$00;GreenVal:$FC;BlueVal:$FC),{Cyan       EGA  3}
    (RedVal:$FC;GreenVal:$14;BlueVal:$14),{Red        EGA  4}
    (RedVal:$B0;GreenVal:$00;BlueVal:$FC),{Magenta    EGA  5}
    (RedVal:$70;GreenVal:$48;BlueVal:$00),{Brown      EGA 20}
    (RedVal:$C4;GreenVal:$C4;BlueVal:$C4),{White      EGA  7}
    (RedVal:$34;GreenVal:$34;BlueVal:$34),{Gray       EGA 56}
    (RedVal:$00;GreenVal:$00;BlueVal:$70),{Lt Blue    EGA 57}
    (RedVal:$00;GreenVal:$70;BlueVal:$00),{Lt Green   EGA 58}
    (RedVal:$00;GreenVal:$70;BlueVal:$70),{Lt Cyan    EGA 59}
    (RedVal:$70;GreenVal:$00;BlueVal:$00),{Lt Red     EGA 60}
    (RedVal:$70;GreenVal:$00;BlueVal:$70),{Lt Magenta EGA 61}
    (RedVal:$FC;GreenVal:$FC;BlueVal:$24),{Yellow     EGA 62}
    (RedVal:$FC;GreenVal:$FC;BlueVal:$FC) {Br. White  EGA 63}
    );


begin

  if (ParamCount<1) or (ParamCount>2) or (ParamStr(1)='/?') or (ParamStr(2)='-?') then
    begin
      WriteLn('Usage: PG_PPM <Phoenix Graphic source file> [ <target.ppm> ]');
      Halt(1);
    end;

  for i:=Low(EGAColors) to High(EGAColors) do
    with EGAColors[i] do
      begin
        pal[i,0]:=0;
        pal[i,1]:=RedVal   shr 2;
        pal[i,2]:=GreenVal shr 2;
        pal[i,3]:=BlueVal  shr 2;
      end;

  Assign(d,ParamStr(1));
  FileMode:=$40;
  {$I-}
  Reset(d,1);
  {$I+}
  rc:=IOResult;
  if rc<>0 then
    begin
      WriteLn('Can not open source file.');
      RunError(rc);
    end;
  l:=FileSize(d);
  GetMem(p,l);
  BlockRead(d,p^,l);
  Close(d);


  i:=0;
  if StrLComp(PChar(@p^[i]),'PG',Length('PG'))<>0 then
    RunError(99);

  palette:=Odd(p^[i+3]);
  if palette then
    begin
      f:=pWord(@p^[i+pWord(@p^[i+4])^])^;
      if (f<1) or (f>16) then palette:=false;
      if palette then
        begin
          x:=pWord(@p^[i+pWord(@p^[i+4])^+0])^;
          y:=pWord(@p^[i+pWord(@p^[i+4])^+2])^;
          x2:=pWord(@p^[i+pWord(@p^[i+4])^+4*f+0])^;
          y2:=pWord(@p^[i+pWord(@p^[i+4])^+4*f+2])^;
          if (x2<8) or (x2>1024)
          or (y2<8) or (y2>1024) then
            if  (x>=8) and (x<=1024)
            and (y>=8) and (y<=1024) then
              palette:=false;
        end;
    end;

  Inc(i,pWord(@p^[i+4])^);

  if palette then
    begin
      f:=pWord(@p^[i+0])^;
      Move(p^[i+2],pal,4*f);
      Inc(i,2+4*f);
    end
  else
    f:=16;

  x:=pWord(@p^[i])^;
  Inc(i,2);
  y:=pWord(@p^[i])^;
  Inc(i,2);
  Inc(i,4);

  GetMem(b,x*y);
  FillChar(b^,x*y,0);
  for fb:=0 to 3 do
    begin
      fw:=1 shl fb;
      for yi:=0 to y-1 do
        for xi:=0 to (x div 8)-1 do
          begin
            for xb:=0 to 7 do
              if Odd(p^[i] shr xb) then
                Inc(b^[yi*x+xi*8+7-xb],fw);
            Inc(i);
          end;
    end;

  if ParamCount=1 then
    begin
      FSplit(ParamStr(1),Dir,Name,Ext);
      Assign(a,Dir+Name+'.ppm');
    end
  else
    Assign(a,ParamStr(2));
  {$I-}
  Rewrite(a);
  {$I+}
  rc:=IOResult;
  if rc<>0 then
    begin
      WriteLn('Can not create output file.');
      RunError(rc);
    end;
  WriteLn(a,'P3');
  WriteLn(a,x,' ',y);
  WriteLn(a,63);
  z:='';
  for yi:=0 to y-1 do
    begin
      for xi:=0 to x-1 do
        begin
          z:=z+fa(b^[yi*x+xi]);
          if Length(z)>240 then
            begin
              WriteLn(a,z);
              z:='';
            end;
        end;
    end;
  if z<>'' then
    begin
      WriteLn(a,z);
      z:='';
    end;
  Close(a);
  Dispose(p);
end.

