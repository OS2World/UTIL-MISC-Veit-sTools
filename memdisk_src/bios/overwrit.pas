program overwritefile;
(* framentierungsproblem \memboot.bin *)

var
  d1,d2:file;
  p:array[0..512-1] of byte;
  s,j:longint;

begin
  Assign(d1,ParamStr(1));
  Reset(d1,1);
  Assign(d2,ParamStr(2));
  {$I-}
  Reset(d2,1);
  {$I+}
  if IOResult<>0 then
    Rewrite(d2,1);

  s:=FileSize(d1);
  while s>0 do
    begin
      Write('.');
      j:=SizeOf(p);
      if j>s then j:=s;
      BlockRead(d1,p,j);
      BlockWrite(d2,p,j);
      Dec(s,j);
    end;
  WriteLn;
  Close(d1);
  Truncate(d2);
  Close(d2);
end.