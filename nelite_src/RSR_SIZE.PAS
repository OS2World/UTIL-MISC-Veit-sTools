{&Use32+}
program show_resource_size;

uses
  Os2Base;

var
  module,
  rc,
  Size,
  IdType,IdName         :longint;
  resource              :pointer;
  outfile               :file;
  kontrolle             :integer;
  errorbuffer           :array[0..260] of char;
  errorbuffer_len       :word=SizeOf(errorbuffer);

begin
  Val(ParamStr(2),IdType,kontrolle);
  Val(ParamStr(3),IdName,kontrolle);
  rc:=DosLoadModule(nil,0{,errorbuffer_len,@errorbuffer},@(ParamStr(1)+#0)[1],module);
  if rc<>0 then
    begin
      WriteLn('DosLoadModule:',rc);
      Halt(rc);
    end;
  rc:=DosQueryResourceSize(module,IdType,IdName,Size);
  if rc<>0 then
    WriteLn('DosQueryResourceSize:',rc)
  else
    begin
      rc:=DosGetResource(module,Idtype,IdName,resource);
      if rc<>0 then
        WriteLn('DosGetResource:',rc)
      else
        begin
          Assign(outfile,ParamStr(4));
          Rewrite(outfile,1);
          BlockWrite(outfile,resource^,Size);
          Close(outfile);
          DosFreeResource(resource);
        end;
    end;
  DosFreeModule(module);
end.
