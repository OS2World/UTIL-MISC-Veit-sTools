program bin_pas;

const 
  br=80 div 5;

var
  d:file of byte;
  t:text;
  p,l:longint;
  b:byte;

begin
  assign(d,paramstr(1));
  assign(t,paramstr(2));
  reset(d);
  rewrite(t);
  l:=filesize(d);
  writeln(t,'array[0..',l-1,'] of byte=');
  write  (t,'(');

  for p:=0 to l-1 do
    begin
      read(d,b);
      write(t,b:3);
      if p=l-1 then
        write(t,');')
      else
        write(t,',');
      if p mod br=br-1 then
        begin
          writeln(t);
          write  (t,' ');
        end;
    end;

  writeln(t);
  close(d);
  close(t);
end.

