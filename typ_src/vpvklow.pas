unit VpVKLow;

interface

function SysGetVolumeLabelTime(Drive: Char):longint;

implementation

(*$IfDef DPMI32*)
uses
  VpSysLow;

function SysGetVolumeLabelTime(Drive: Char):longint;
  var
    sr                  :TOSSearchRec;
    root                :array[0..6] of char;
  const
    suchmaske=$0800  // must  volume
             +$0008  // allow volume
             +$0020; // allow archive
  begin
    root:='@:\*.*'#0;
    root[0]:=drive;

    if SysFindFirst(root,suchmaske,sr,false)=0 then
      SysGetVolumeLabelTime:=sr.Time
    else
      SysGetVolumeLabelTime:=-1;
  end;
(*$EndIf DPMI32*)

(*$IfDef OS2*)
function SysGetVolumeLabelTime(Drive: Char): longint;
  begin
    SysGetVolumeLabelTime := -1;
  end;
(*$EndIf OS2*)

(*$IfDef Win32*)
function SysGetVolumeLabelTime(Drive: Char): longint;
  begin
    SysGetVolumeLabelTime := -1;
  end;
(*$EndIf Win32*)

(*$IfDef Linux*)
function SysGetVolumeLabelTime(Drive: Char): longint;
  begin
    SysGetVolumeLabelTime := -1;
  end;
(*$EndIf Linux*)
end.

