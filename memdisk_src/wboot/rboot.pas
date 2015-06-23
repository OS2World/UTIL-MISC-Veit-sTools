program read_bootsector_to_file;

uses
  {$IfDef Os2}
  Os2Base,
  Os2Def,
  {$EndIf Os2}
  {$IfDef Os2}
  oint2526;
  {$EndIf Os2}
  {$IfDef MSDOS}
  tint2526;
  {$EndIf MSDOS}

var
  lw            :byte;
  s1            :array[0..511] of char;
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
  or (Length(ParamStr1)<>Length('A:'))
  or (ParamStr1[2]<>':') then
    begin
      WriteLn('read bootsector to file.');
      WriteLn('Usage:  RBOOT A: <file>');
      Halt(1);
    end;

  lw:=Ord(UpCase(ParamStr1[1]))-Ord('A');

  if read_logical_sector(lw,s1,0)<>0 then
    Error('can not read sector 0!',99);

  Assign(d,ParamStr2);
  FileMode:=$41;
  {$I-}
  Rewrite(d,1);
  {$I+}
  HandleError('Can not open target file!');
  {$I-}
  BlockWrite(d,s1,512);
  {$I+}
  HandleError('Can not write target file!');
  Close(d);

end.

