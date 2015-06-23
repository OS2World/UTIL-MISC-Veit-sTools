uses crt,popup;
var
  sicherung:popup_sicherung_typ;
begin
{  asm
    mov ax,$002a
    int $10
  end;
  windmax:=(132-1)+(44-1) shl 8;}
  textattr:=$1e;
  clrscr;
  writeln('normal...');
  popup_ein(sicherung);
  writeln('test');
  readln;
  popup_aus(sicherung);
  write('zurck ');
  readln;
end.
