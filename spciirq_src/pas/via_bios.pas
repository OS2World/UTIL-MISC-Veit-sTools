program via_bios_pascal_zu_asm;

uses
  pci_hw,
  VpUtils;

{$I via_bios.inc}

var
  string_unique         :array[1..3*High(via_string_table)] of
    record
      n                 :integer;
      s                 :^string;
    end;

procedure create_unirqe_string(n:integer;const s:string);
  var
    i                   :integer;
  begin
    for i:=1 to n-1 do
      if string_unique[i].n=i then
        if string_unique[i].s^=s then
          begin
            string_unique[n].n:=i;
            string_unique[n].s:=string_unique[i].s;
            Exit;
          end;
    string_unique[n].n:=n;
    string_unique[n].s:=@s;

    Write('via_bios_string_'+Int2StrZ(n,4),' db 0',Int2Hex(Length(s),2),'h');
    for i:=1 to Length(s) do
      Write(',0',Int2Hex(Ord(s[i]),2),'h');
    WriteLn;
  end;

var
  i                     :word;
begin
  WriteLn('Title   automaticly generated BIOS serach strings to determine meaning of link values for VIA/AMD');
  WriteLn;
  for i:=Low(via_string_table) to High(via_string_table) do
    with via_string_table[i] do
      begin
        create_unirqe_string(3*(i-1)+1,s1);
        create_unirqe_string(3*(i-1)+2,s2);
        create_unirqe_string(3*(i-1)+3,tr);
      end;

  WriteLn;
  WriteLn('via_bios_string_table_begin  label word');
  for i:=Low(string_unique) to High(string_unique) do
    WriteLn('  dw Offset via_bios_string_'+Int2StrZ(string_unique[i].n,4));
  WriteLn('via_bios_string_table_end    label word');
  WriteLn;
end.

