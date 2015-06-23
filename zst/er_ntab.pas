{&Use32+}
program er_ntab;

uses
  ntab;

var
  z,n1,n2:string;
  zahl:word;
  kontrolle:integer;

begin
  while not Eof(Input) do
    begin
      ReadLn(z);
      while (z<>'') and (z[1] in [#9,' ']) do
        Delete(z,1,1);

      if (z='') or (z[1]='#') then Continue;

      if Pos(' ',z)=0 then Continue;

      zk_vereinfachung(Copy(z,1,Pos(' ',z)),n1);
      Delete(z,1,Pos(' ',z));
      zk_vereinfachung(z,n2);

      Val(n1,zahl,kontrolle);
      if (kontrolle=0) and (zahl>0) and (zahl<$7fff) then Continue;

      Val(n2,zahl,kontrolle);
      if kontrolle<>0 then Continue;

      zuordung(n1,zahl);
    end;


  schreibe_datei__cp_ntab;
end.

