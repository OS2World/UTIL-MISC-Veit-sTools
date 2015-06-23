type
  tabelle_typ=array[0..255] of byte;

var
  tabelle:tabelle_typ;
  d:file of tabelle_typ;
  z:word;
  index,daten:word;

begin
  assign(d,paramstr(1));
  rewrite(d);
  index:=$22;
  daten:=$24;

  for z:=0 to 255 do
    begin
      port[index]:=z;
      tabelle[z]:=port[daten];
    end;
  
  write(d,tabelle);
  close(d);
end.
