begin
  Port[$4d0]:=Port[$4d0] or (1 shl (5   ));
  Port[$4d1]:=Port[$4d1] or (1 shl (10-8));
end.
