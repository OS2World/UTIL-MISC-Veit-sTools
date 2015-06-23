program eisa_4d0;

var
  w,i                   :word;

begin
  WriteLn('EISA edge/level setting at port $4d0:');

  w:=Port[$4d0]+Port[$4d1]*$100;
  for i:=0 to 15 do
    Write(i:3);
  WriteLn;
  for i:=0 to 15 do
    if Odd(w shr i) then
      Write('  l')
    else
      Write('  e');
  WriteLn;

end.
