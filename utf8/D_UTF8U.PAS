{&Use32+}
program decode_utf8u;

uses
  utf8u,
  unidef,
  uniapi,
  VpSysLow;

var
  sourceline,
  outputline            :string;

  default_cp            :pUniCharArray;
  default_cp_conversion :UconvObject=nil;
  rc                    :word;

begin
  Assign(Input,ParamStr(1));
  Reset(Input);
  Assign(Output,ParamStr(2));
  Rewrite(Output);

  default_cp:=NewUniCharArray(12);
  UniMapCpToUcsCp(SysGetCodePage,default_cp^,12);
  rc:=UniCreateUconvObject(default_cp^,default_cp_conversion);
  if rc<>ULS_SUCCESS then RunError(rc);

  FreeUniCharArray(default_cp^);

  while not Eof do
    begin
      ReadLn(sourceline);
      read_utf8_to_string(sourceline,outputline,default_cp_conversion);
      WriteLn(outputline);
    end;

  UniFreeUconvObject(default_cp_conversion);
end.

