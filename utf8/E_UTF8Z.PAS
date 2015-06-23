{&Use32+}
program encode_utf8z;

uses
  zst,
  ztab,
  zst_obj,
  utf8z,
  unidef,
  VpSysLow;

var
  sourceline,
  outputline            :string;

  default_cp_conversion :zeichensatzumformung_8_16;

begin
  Assign(Input,ParamStr(1));
  Reset(Input);
  Assign(Output,ParamStr(2));
  Rewrite(Output);

  berechne_umrechnungstabelle_8_16(SysGetCodePage,default_cp_conversion);

  while not Eof do
    begin
      ReadLn(sourceline);
      write_utf8_from_string(sourceline,outputline,default_cp_conversion);
      WriteLn(outputline);
    end;

  freigeben_umrechnungstabelle_8_16(default_cp_conversion)
end.

