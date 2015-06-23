{$Use32+,Delphi+,OrgName-}
library XGAPROC;
// SAVE2DSK.XGA image format MMIO procedure
// 2005.02.01 Veit Kannegieser

uses
  xgafunc;

//function IOProc_Entry  (const pmmioStr  :pointer;
//                        const usMessage :SmallWord;
//                        const lParam1   :Longint;
//                        const lParam2   :Longint):Longint;cdecl;
//  begin
//    Result:=XGA_Proc_Entry(pmmioStr,usMessage,lParam1,lParam2);
//  end;

procedure fix_rtl;
  begin
    ExitProc:=nil; // else would cause an SYS3170 in DOSCALL1.DLL 0003:0000a291
  end;

exports
  XGA_Proc_EntryF name 'XGA_Proc_Entry';

initialization
  fix_rtl;
end.
