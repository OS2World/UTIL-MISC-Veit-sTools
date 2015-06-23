// unpack FUJITSU SIEMENS flash file -- simple runlength encoding scheme
//
// Veit Kannegieser 2006-04-22
//
// usage E_SNIPAC <compressed file> <decompressed file>

{&Use32+}
program un_snipac;

uses
  Strings,
  Objects;

var
  f: File;
  p: pByteArray;
  i, j, l: Longint;
  fill: Byte;
  fillsize: Longint;
  valr: Integer;

procedure WriteF;
  begin
    if j < i then
      begin
        BlockWrite(f, p^[j], i - j);
        j := i;
      end;
  end;

procedure FillF;
  var
    buffer: array[0..512-1] of byte;
    now: Longint;
  begin
    FillChar(buffer, SizeOf(buffer), fill);
    while fillsize > 0 do
      begin
        now := SizeOf(buffer);
        if now > fillsize then
          now := fillsize;
        BlockWrite(f, buffer, now);
        Dec(fillsize, now);
      end;
  end;

begin
  if ParamCount<>2 then
    begin
      WriteLn('Usage: E_SNIPAC <source file> <target file>');
      WriteLn;
      WriteLn('unpacks files than contain SNIPAC00 or SNIPACFF.');
      Halt(1);
    end;

  Assign(f, ParamStr(1));
  FileMode := $40;
  Reset(f, 1);
  l := FileSize(f);
  GetMem(p, l + 20);
  FillChar(p^, l + 20, 0);
  BlockRead(f, p^, l);
  Close(f);

  Assign(f, ParamStr(2));
  Rewrite(f, 1);
  i := 0;
  j := 0;
  while i < l do
    begin
      if StrLComp(PChar(@p^[i]), 'SNIPAC', Length('SNIPAC')) = 0 then
        begin
          WriteF;
          Inc(i, Length('SNIPAC'));
          Val('$' + Chr(p^[i]) + Chr(p^[i + 1]), fill, valr);
          Inc(i, Length('FF'));
          fillsize := MemL[Ofs(p^[i])];
          Inc(i, 4);
          j := i;
          FillF;
        end
      else
        Inc(i);
    end;

  WriteF;
  Close(f);
end.
