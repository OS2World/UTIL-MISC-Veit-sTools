uses
  zst,
  zst_obj;

var
  zeile         :string;
  u             :zeichensatzumformung_8_8;

begin
  berechne_umrechnungstabelle_8_8(1252{1004},0,u);

  while not Eof(Input) do
    begin
      ReadLn(zeile);
      umformung_8_8(zeile,zeile,u);
      WriteLn(zeile);
    end;

  freigeben_umrechnungstabelle_8_8(u);
end.
