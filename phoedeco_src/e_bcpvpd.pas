{&Use32+}
program entpacker_BCPVPD;
(* 2005.02.27..2005.03.17 Veit Kannegieser *)

uses
  Objects,
  Strings;

const
  writebuffersize       =256*1024;

var
  dn1,dn2               :string;
  f1,f2                 :file;
  p1,p2                 :pByteArray;
  l,i,o,s               :longint;
  puffer                :array[0..4096+18{?}] of byte;
  puffer_gefuellt       :word;
  rc                    :integer;

procedure flush_writebuffer;
  begin
    if o>0 then
      begin
        BlockWrite(f2,p2^,o);
        Inc(s,o);
        o:=0;
        Write('.');
      end;
  end;

procedure schreibe_byte(const b:byte);
  begin
    p2^[o]:=b;
    Inc(o);
    if o=writebuffersize then flush_writebuffer;
    puffer[puffer_gefuellt]:=b;
    puffer_gefuellt:=(puffer_gefuellt+1) and $0fff;
  end;

procedure entpacke;
  var
    bitspeicher         :word;
    off                 :word;
    anzahl              :word;
  begin
    o:=0;
    s:=0;
    FillChar(puffer,SizeOf(puffer),$00);
    puffer_gefuellt:=$fee;
    FillChar(puffer,puffer_gefuellt,$20);
    bitspeicher:=0;
    repeat

      bitspeicher:=bitspeicher shr 1;
      if not Odd(bitspeicher shr 8) then
        begin
          bitspeicher:=$ff00+p1^[i];
          Inc(i);
        end;

      if Odd(bitspeicher) then
        begin
          if i>=l then Break;
          schreibe_byte(p1^[i]);
          Inc(i);
        end
      else
        begin
          if i>=l then Break;
          off:=p1^[i];
          Inc(i);
          if i>=l then Break;
          off:=off+(p1^[i] shr 4) shl 8;
          anzahl:=(p1^[i] and $0f)+2 + 1;
          Inc(i);
          while anzahl>0 do
            begin
              schreibe_byte(puffer[off and $fff]);
              Inc(off);
              Dec(anzahl);
            end;
        end;

    until false;
  end;

begin
  dn1:=ParamStr(1);
  dn2:=ParamStr(2);
  if ParamCount<>2 then
    begin
      WriteLn('Usage: E_BCPVPD <source file> <target file>');
      WriteLn;
      WriteLn('unpacks files starting with BCPVPD or $COMPIBM.');
    (*WriteLn('example file: $018f000.fl1');*)
      Halt(1);
    end;
  {$IfDef debug}
  dn1:='G:\daten.pho\bcpvpd\$018f000.fl1';
  dn2:='M:\tmp\$018f000.fl~';
  {$EndIf debug}

  Assign(f1,dn1);
  FileMode:=$40;
  Reset(f1,1);
  rc:=IOResult;
  if rc<>0 then
    begin
      WriteLn('Can not open "',dn1,'", rc=',rc);
      Halt(rc);
    end;
  l:=FileSize(f1);
  if (l<8) or (l>16*1024*1024) then
    begin
      WriteLn('Source file format not acceptable - bad size!');
      Halt(1);
    end;
  GetMem(p1,l);
  BlockRead(f1,p1^,l);
  Close(f1);

  i:=0;
  if StrLComp(@p1^[i],'BCPVPD',Length('BCPVPD'))=0 then
    Inc(i,$52)
  else
  if StrLComp(@p1^[i],'$COMPIBM',Length('$COMPIBM'))=0 then
    Inc(i,$08)
  else
    begin
      WriteLn('Source file format not acceptable - missing header!');
      Halt(1);
    end;

  GetMem(p2,writebuffersize);
  Assign(f2,dn2);
  Rewrite(f2,1);

  entpacke;

  flush_writebuffer;
  Close(f2);
  Dispose(p1);
  Dispose(p2);
  WriteLn('done, ',l,' -> ',s);
end.
