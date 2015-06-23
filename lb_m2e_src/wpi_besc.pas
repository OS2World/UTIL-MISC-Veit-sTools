uses
  Strings;

var
  d                     :file;
  titel,autor           :array[0..$3f] of char;

begin
  if ParamCount<>3 then RunError(1);

  Assign(d,ParamStr(1));
  Reset(d,1);

  Seek(d,$106);

  BlockRead(d,titel,SizeOf(titel));
  BlockRead(d,autor,SizeOf(autor));

  if ((StrComp(titel,'Test application')<>0) and (StrComp(titel,'WIC 1.0.1'   )<>0))
  or ((StrComp(autor,'Ulrich M”ller'   )<>0) and (StrComp(autor,'OS/2 Netlabs')<>0))
   then
    RunError(99);

  FillChar(titel,SizeOf(titel),0);StrPCopy(titel,ParamStr(2));
  FillChar(autor,SizeOf(autor),0);StrPCopy(autor,ParamStr(3));

  Seek(d,$106);
  BlockWrite(d,titel,SizeOf(titel));
  BlockWrite(d,autor,SizeOf(autor));

  Close(d);

end.
