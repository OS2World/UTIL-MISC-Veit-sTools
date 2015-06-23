{&Use32+}
program size_font_bold_vertical;
// Probleme mit z.B. #$F3 #$C4 #$E2 - nicht allgemein verwendbar

Uses
  HilfsFun,
  Objects;

var
  para1,para2,para3     :string;
  f                     :file;
  l                     :longint;
  p1,p2                 :pByteArray;
  s1,s2                 :word;
  w1,w2                 :word;
  i                     :char;
  kontrolle             :integer;
  grafikzeichen         :boolean;
  z                     :word;

begin

  para1:=ParamStr(1);{if DebugHook then para1:='C:\V\FONT19\FONT19.VK\VIOTBL.EXT\00437_18.fn8';}
  para2:=ParamStr(2);{if DebugHook then para2:='C:\V\FONT19\FONT19.VK\VIOTBL.EXT\00437_20.fn8';}
  para3:=ParamStr(3);{if DebugHook then para3:='20';}

  if (ParamCount<>3) or (para1='/?') or (para1='-?') then
    begin
      WriteLn('SFONT: resize raw font - bold horizontaly');
      WriteLn('Usage: SFONT inputfile ouputfile outputsize');
      WriteLn('Example: SFONTBV 000437_18.FN8 000437_19.FN8 19');
      Halt(1);
    end;

  Val(para3,s2,kontrolle);
  if (kontrolle<>0) or (s2<4) or (s2>32) then
    Abbruch('Invalid numeric parameter 3.',1);

  Assign(f,para1);
  FileMode:=$40;
  Reset(f,1);
  l:=FileSize(f);
  if (l mod 256)<>0 then
    Abbruch('Input file has invalid size.',1);
  s1:=l div 256;
  if (s1<4) or (s1>32) then
    Abbruch('Input file has invalid size.',1);

  GetMem(p1,s1*256);
  BlockRead(f,p1^,s1*256);
  Close(f);

  GetMem(p2,s2*256);

  w1:=0;
  w2:=0;
  for i:=Low(i) to High(i) do
    begin

      (* Sonderbehandlung von '∞', #$F4 in 437 *)
      grafikzeichen:=false;
      if (p1^[w1]<>0) or (p1^[w1+s1-1]<>0) then
        begin
          grafikzeichen:=true;
          if p1^[w1]<>0 then
            if p1^[w1]<>p1^[w1+2] then
              grafikzeichen:=false;
          if p1^[w1+s1-1]<>0 then
            if p1^[w1+s1-1]<>p1^[w1+s1-3] then
              grafikzeichen:=false;
        end;

      if s1+1=s2 then
        begin
          (* eine Zeile mehr - unten anfÅgen *)
          Move(p1^[w1],p2^[w2],s1);
          Inc(w1,s1);
          Inc(w2,s1);
          if grafikzeichen then
            p2^[w2]:=p2^[w2-2] (* vorletzte Zeile *)
          else
            p2^[w2]:=0;        (* leer *)
          Inc(w2,1);
          if not grafikzeichen then
            for z:=w2-s2+1 to w2-1 do
              p2^[z-1]:=p2^[z-1] or p2^[z]
        end
      else
      if s1+2=s2 then
        begin
          (* zwei Zeilen mehr - erste und letzte Zeile einfÅgen *)
          if grafikzeichen then
            p2^[w2]:=p1^[w1+1] (* zweite Zeile *)
          else
            p2^[w2]:=0;
          Inc(w2);
          Move(p1^[w1],p2^[w2],s1);
          Inc(w1,s1);
          Inc(w2,s1);
          if grafikzeichen then
            p2^[w2]:=p1^[w1-2] (* vorletzte Zeile *)
          else
            p2^[w2]:=0;
          Inc(w2);
          if not grafikzeichen then
            for z:=w2-s2+1 to w2-1 do
              p2^[z-1]:=p2^[z-1] or p2^[z]
        end
      else
        Abbruch('Program supports only old size +1/+2!',1);
    end;

  Assign(f,para2);
  FileMode:=$02;
  Rewrite(f,1);
  BlockWrite(f,p2^,s2*256);
  Close(f);

  Dispose(p1);
  Dispose(p2);

end.
