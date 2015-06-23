{$F+}
library MinMax;

{export-Prozedurdirektive, Min und Max werden exportiert}

function Min(X, Y: Integer): Integer; export;
begin
  if X < Y then Min := X else Min := Y;
end;

function Max(X, Y: Integer): Integer; export;
begin
  if X > Y then Max := X else Max := Y;
end;

{exports-Klausel exportiert die Routinen und weist ihnen eine optionale
 Ordinalzahl zu}

exports
  Min index  1,
  Max index 40;

begin
end.