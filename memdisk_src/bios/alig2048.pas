program align2048;
var
  d:file;
  p:array[1..2048] of byte;
begin
  FillChar(p,SizeOf(p),$ff);
  Assign(d,ParamStr(1));
  Reset(d,1);
  Seek(d,FileSize(d));
  BlockWrite(d,p,SizeOf(p)-(FileSize(d) and (SizeOf(p)-1) ));
  Close(d);
end.
