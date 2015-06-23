program write_file_to_bootsector;

uses
  {$IfDef Os2}
  Os2Base,
  Os2Def,
  {$EndIf Os2}
  {$IfDef Os2}
  oint2526,
  {$EndIf Os2}
  {$IfDef MSDOS}
  tint2526,
  {$EndIf MSDOS}
  Strings;

var
  lw            :byte;
  s1,s2         :array[0..511] of char;
  d             :file;
  ParamStr1,
  ParamStr2     :string;

{$IfDef Os2}
{$Cdecl+,Orgname+}
function DosReplaceModule(OldModName,NewModName,BackModName: PChar): ApiRet;
  external 'DOSCALLS' index 417;
{$Cdecl-,Orgname-}
{$EndIf Os2}

procedure Error(const s:string;ec:integer);
  begin
    WriteLn(s);
    Halt(ec);
  end;

procedure HandleError(const s:string);
  begin
    if InOutRes<>0 then
      Error(s,IOResult);
  end;

begin
  {$IfDef Os2}
  DosReplaceModule(@(ParamStr(0)+#0)[1],nil,nil);
  {$EndIf Os2}

  ParamStr1:=ParamStr(1);
  ParamStr2:=ParamStr(2);

  if (ParamCount<>2)
  or (Length(ParamStr2)<>Length('A:'))
  or (ParamStr2[2]<>':') then
    begin
      WriteLn('write file to bootsector.');
      WriteLn('Usage:  WBOOT <file> A:');
      Halt(1);
    end;

  Assign(d,ParamStr1);
  FileMode:=$40;
  {$I-}
  Reset(d,1);
  {$I+}
  HandleError('Can not open source file!');
  {$I-}
  BlockRead(d,s1,512);
  {$I+}
  HandleError('Can not read source file!');
  Close(d);

  if (s1[$1fe]<>#$55) or (s1[$1ff]<>#$aa) then
    Error('Source file is not a valid bootsector!',99);

  lw:=Ord(UpCase(ParamStr2[1]))-Ord('A');

  if read_logical_sector(lw,s2,0)<>0 then
    Error('can not read sector 0',98);

  if (s2[$1fe]<>#$55) or (s2[$1ff]<>#$aa) then
    Error('Target volme does not have a valid bootsector!',97);

  if StrLComp(@s2[$36],'FAT',Length('FAT'))<>0 then
    Error('Target volme is not FAT filesystem!',96);

  Move(s2[$b],s1[$b],$3e-$b); (* Bios Parameter Block *)

  if write_logical_sector(lw,s1,0)<>0 then
    Error('can not write sector 0!',95);

end.

