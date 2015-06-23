unit unidef;

interface

type
  UniChar               =smallword;
  UniCharArray          =Array[0..High(word) div SizeOf(UniChar)] of UniChar;
  pUniCharArray         =^UniCharArray;

function  NewUniCharArray(const length:integer):pUniCharArray;
procedure FreeUniCharArray(const uc:UniCharArray);

implementation

function  NewUniCharArray(const length:integer):pUniCharArray;
  begin
    GetMem(Result,Succ(length)*SizeOf(UniChar));
  end;

procedure FreeUniCharArray(const uc:UniCharArray);
  begin
    FreeMem(@uc);
  end;

end.