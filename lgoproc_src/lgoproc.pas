{$Use32+,Delphi+,OrgName-}
library LGOPROC;

uses
  lgofunc;

procedure fix_rtl;
  begin
    ExitProc:=nil; // else would cause an SYS3170 in DOSCALL1.DLL 0003:0000a291
  end;

exports
  LGO_Proc_EntryF name 'LGO_Proc_Entry';

initialization
  fix_rtl;
end.
