{&Use32+}
program decode_utf8z;

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

  default_cp_conversion :zeichensatzumformung_16_8;

begin
  Assign(Input,ParamStr(1));
  Reset(Input);
  Assign(Output,ParamStr(2));
  Rewrite(Output);

  berechne_umrechnungstabelle_16_8(SysGetCodePage,default_cp_conversion);

  while not Eof do
    begin
      ReadLn(sourceline);
      read_utf8_to_string(sourceline,outputline,default_cp_conversion);
      WriteLn(outputline);
    end;

  freigeben_umrechnungstabelle_16_8(default_cp_conversion)
end.

