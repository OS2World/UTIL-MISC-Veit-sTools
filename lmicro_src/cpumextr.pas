{&Use32+}
program extract_cpu_microcode;
Uses
  mit,
  Objects,
  {$IfDef VirtualPascal}
  VpUtils,
  VpSysLow;
  {$Else}
  TpUtils,
  TpSysLow;
  {$EndIf}

var
  d                     :file;
  l,w                   :longint;
  p                     :pByteArray;
  found                 :boolean;
  sum,i                 :longint;
  block_size            :integer;
  fill_800              :array[0..$7ff] of byte;

function Int2HexM(const l:longint;n:Byte):string;
  begin
    while (n<8) and ((l shr (4*n))<>0) do Inc(n);
    Int2HexM:=Int2Hex(l,n);
  end;

begin

  if (ParamCount<>1) or (ParamStr(1)='/?') or (ParamStr(1)='-?') then
    begin
      WriteLn('Usage: CPUEXTR <filename>');
      Halt(1);
    end;

  FileMode:=$40;
  Assign(d,ParamStr(1));
  Reset(d,1);
  l:=FileSize(d);
  {$IfNDef VirtualPascal}
  if l>$ff00 then
    begin
      WriteLn('Reading only less than 64KiB file...');
      l:=$ff00;
    end;
  {$EndIf VirtualPascal}
  GetMem(p,l);
  BlockRead(d,p^,l);
  Close(d);

  found:=false;

  (*** Intel ***)
  w:=0;
  while w+$30<l do
    with Pmicrocode_update_block( Addr(p^[w]) )^,update_creation_date do
      begin

        block_size:=is_valid_intel_p6_microcode(p^[w],l-w);

        if block_size<0 then
          begin
            Inc(w);
            Continue;
          end;

        if block_size=0 then
          begin
            Writeln('checksum error (pos=',Int2Hex(w,8),').');
            Inc(w);
            Continue;
          end;

        if not found then
          begin
            found:=true;
            WriteLn('Position Date       ID  Rev      Product');
          end;

        Write(Int2Hex(w,8),' ');
        Write(Int2Hex(year,4),'-',Int2Hex(month,2),'-',Int2Hex(day,2),' ');
        Write(Int2Hex(family_model_stepping_of_processor_to_which_update_applied,3),' ');
        Write(Int2Hex(revision_number_of_this_microcode_update,8),' ');
        Write(Int2Hex(product,8),' ');

        Assign(d,Int2HexM(family_model_stepping_of_processor_to_which_update_applied,3)+'_'
                +Int2HexM(revision_number_of_this_microcode_update,2)
                +Int2HexM(product,2)+'.cpu');
        Rewrite(d,1);
        BlockWrite(d,p^[w],block_size);
        Close(d);
        Inc(w,block_size);
        WriteLn;
      end;

  (*** AMD ***)
  w:=0;
  while w+$40<l do
    with Pamd_microcode_update_block( Addr(p^[w]) )^,date do
      begin

        block_size:=is_valid_amd_k8_microcode(p^[w],l-w);

        if block_size<0 then
          begin
            Inc(w);
            Continue;
          end;

        if block_size=0 then
          begin
            Writeln('checksum error (pos=',Int2Hex(w,8),').');
            Inc(w);
            Continue;
          end;

        if not found then
          begin
            found:=true;
            WriteLn('Position Date       ID           Product series');
          end;

        Write(Int2Hex(w,8),' ');
        Write(Int2Hex(year,4),'-',Int2Hex(month,2),'-',Int2Hex(day,2),' ');
        Write(Int2Hex(msr_8b_after_patch,3),' ');
        Write('         '); (* no revision *)
        Write(Int2Hex(modell_series,8),' ');

        Assign(d,Int2HexM(modell_series,4)
                +Int2HexM(msr_8b_after_patch,4)
                +'.amd');
        Rewrite(d,1);
        BlockWrite(d,p^[w],block_size);
        if block_size<SizeOf(fill_800) then
          begin
            FillChar(fill_800,SizeOf(fill_800),0);
            BlockWrite(d,fill_800,SizeOf(fill_800)-block_size);
          end;
        Close(d);
        Inc(w,block_size);
        WriteLn;


      end;


  Dispose(p);


  if not found then
    begin
      WriteLn('no microcode block found.');
      SysReadKey;
      Halt(99);
    end;

end.
