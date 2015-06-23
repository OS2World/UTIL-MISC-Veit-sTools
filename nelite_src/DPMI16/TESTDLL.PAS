{$F+}
program testdll;

function Min(X, Y: Integer): Integer; external 'MINMAX' index  1;
function Max(X, Y: Integer): Integer; external 'minmax' index 40;

begin
  WriteLn('Min(1,2)=',Min(1,2));
  WriteLn('Max(1,2)=',Max(1,2));
end.

