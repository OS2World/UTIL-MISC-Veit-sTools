uses
  zst,
  zst_obj;

var
  zeile         :ansistring;
  u             :zeichensatzumformung_8_8;

begin
  berechne_umrechnungstabelle_8_8(1252{1004},0,u);

  while not Eof(Input) do
    begin
      ReadLn(zeile);
      umformung_8a_8a(zeile,zeile,u);
      WriteLn(zeile);
    end;

  freigeben_umrechnungstabelle_8_8(u);
end.
