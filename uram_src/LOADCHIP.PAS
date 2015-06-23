type
  tabelle_typ=array[0..255] of byte;

var
  tabelle:tabelle_typ;
  d:file of tabelle_typ;
  z:word;
  index,daten:word;

begin
  assign(d,paramstr(1));
  reset(d);
  read(d,tabelle);
  close(d);

  index:=$22;
  daten:=$24;

  for z:=0 to 255 do
    begin
      port[index]:=z;
      port[daten]:=tabelle[z];
    end;
  
end.
