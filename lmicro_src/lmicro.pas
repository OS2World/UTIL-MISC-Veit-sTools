{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$G+}
{$IfNDef VirtualPascal}
{$M 65000,0,655360}
{$EndIf}
{$Q-}{&G5+}
{&M 90000}
{&Use32+}

program load_cpu_microcode;

(* Veit Kannegieser 2003.12.16..2003.12.17 *)
Uses
  mit,
  Dos,
  {$IfDef OS2}
  Os2Base,
  Os2Def,
  {$EndIf OS2}
  Objects,
  {$IfDef VirtualPascal}
  VpUtils,
  VpSysLow;
  {$Else}
  TpUtils,
  TpSysLow;
  {$EndIf}

const
  datum                 ='2005.07.02';
  process_amd           :boolean=false;

{$ifdef bla}
type

  {$IfNDef VirtualPascal}
  tLongArray            =array[0..$3ffe] of Longint;
  pLongArray            =^tLongArray;
  {$EndIf}
  microcode_update_block=
    packed record
      update_header_version_number,
      revision_number_of_this_microcode_update,
      update_creation_date,
      family_model_stepping_of_processor_to_which_update_applied,
      checksum,
      revision_number_of_loader_needed_to_install_update:longint;
      product:longint;
      (*reserved_for_future_expansion:array[$1c..$2f] of byte;*)
      unknown_1c:longint;
      blocksize:longint;
      reserved_for_future_expansion:array[$24..$2f] of byte;
      encrypted_microcode_data:array[$30..{ $30+2000-1}$7fff] of byte;
    end;

  Pmicrocode_update_block=^microcode_update_block;
{$EndIf bla}

var
  d                     :file;
  l,w                   :longint;
  p                     :pByteArray;
  cpu_ver_eax           :longint;
  found                 :boolean;
  applied               :boolean;
  i                     :longint;
  block_size            :integer;
  msr_8b_lo,
  msr_8b_hi,
  msr_8b_hi_org         :longint;
  current_msw           :smallword;
  option,
  ParamStr1             :string;
  productseries_search  :longint;
  lmicro_p              :DirStr;
  lmicro_n              :NameStr;
  lmicro_e              :ExtStr;
  lmicro_cfg            :Text;
  lmicro_cfg_line       :string;
  id_from,id_to         :longint;
  kontrolle             :integer;
  rc                    :longint;

const
  load_lower_revision   :boolean=false;
  quiet                 :boolean=false;

{$IfDef VirtualPascal}
{$IfDef OS2}
procedure genioctl_sddhelp(const code:byte;const para:pointer;const paralmax:longint;
                                           const data:pointer;const datalmax:longint);
  var
    sddhelp_handle      :longint;
    paral,datal         :longint;
    rc                  :longint;
  begin
    rc:=SysFileOpen('SDDHELP$',0,sddhelp_handle);
    if rc<>0 then
      begin
        WriteLn('Can not open SDDHELP.SYS driver (',rc,')!');
        Halt(rc);
      end;
    paral:=paralmax;
    datal:=datalmax;
    rc:=DosDevIOCtl(sddhelp_handle,$80,code,
          para,paralmax,@paral,
          data,datalmax,@datal);
    if rc<>0 then
      begin
        WriteLn('IOCtl to SDDHELP failed (',rc,')!');
        Halt(rc);
      end;
    SysFileClose(sddhelp_handle);
  end;

procedure wrmsr_(const _ecx_,_edx_,_eax_:longint);
  var
    para                :
      packed record
        ecx,eax,edx     :longint;
      end;
    data                :
      packed record
      end;
  begin
    with para do
      begin
        ecx:=_ecx_;
        eax:=_eax_;
        edx:=_edx_;
      end;
    genioctl_sddhelp($0f,@para,SizeOf(para),{@data,SizeOf(data)}nil,0);
  end;

procedure rdmsr_(const _ecx_:longint;var _edx_,_eax_:longint);
  var
    para                :
      packed record
        ecx             :longint;
      end;
    data                :
      packed record
        eax,edx         :longint;
      end;
  begin
    with para do
      ecx:=_ecx_;
    genioctl_sddhelp($0e,@para,SizeOf(para),@data,SizeOf(data));
    with data do
      begin
        _edx_:=edx;
        _eax_:=eax;
      end;
  end;
{$Else OS2}
procedure wrmsr_(const _ecx_,_edx_,_eax_:longint);assembler;
  {&Frame-}{&Uses All}
  asm
    mov ecx,[_ecx_]
    mov edx,[_edx_]
    mov eax,[_eax_]
    wrmsr
  end;
procedure rdmsr_(const _ecx_:longint;var _edx_,_eax_:longint);assembler;
  {&Frame-}{&Uses All}
  asm
    mov ecx,[_ecx_]
    rdmsr
    mov ecx,[_edx_]
    mov [ecx],edx
    mov ecx,[_eax_]
    mov [ecx],eax
  end;

{$EndIf OS2}
{$Else VirtualPascal}
procedure wrmsr_(const _ecx_,_edx_,_eax_:longint);assembler;
  asm
    db $66
    mov cx,Word Ptr [_ecx_]
    db $66
    mov dx,Word Ptr [_edx_]
    db $66
    mov ax,Word Ptr [_eax_]
    db $0f,$30 {wrmsr}
  end;
procedure rdmsr_(const _ecx_:longint;var _edx_,_eax_:longint);assembler;
  asm
    db $66
    mov cx,Word Ptr [_ecx_]
    db $0f,$32 {rdmsr}
    les bx,[_edx_]
    db $66
    mov es:[bx],dx
    les bx,[_eax_]
    db $66
    mov es:[bx],ax
  end;
{$EndIf VirtualPascal}


procedure update(const microcode);
  var
    l                   :longint;
  begin

    {$IfDef VirtualPascal}
    l:=Ofs(microcode);
    {$Else VirtualPascal}
    l:=Longint(Seg(microcode)) shl 4;
    l:=l+Ofs(microcode);
    {$EndIf VirtualPascal}
    if process_amd then
      wrmsr_($c0010020,0,l)
    else
      wrmsr_($00000079,0,l);
  end;

function is_intel_p6:boolean;assembler;
  asm
    {$IfDef VirtualPascal}
    mov eax,0
    cpuid
    cmp ecx,$6c65746e (* 'ntel' *)
    jne @no_ip6
    mov eax,1
    cpuid
    push ax
    and ah,$0f
    cmp ah,6
    pop ax
    jb @no_ip6
    mov cpu_ver_eax,eax
    {$Else VirtualPascal}
    db $66
    sub ax,ax
    db $0f,$a2 {cpuid}
    db $66
    cmp cx,$746e (* 'ntel' *)
    dw $6c65
    jne @no_ip6
    db $66
    sub ax,ax
    inc ax
    db $0f,$a2 {cpuid}
    push ax
    and ah,$0f
    cmp ah,6
    pop ax
    jb @no_ip6
    db $66
    mov Word Ptr cpu_ver_eax,ax
    {$EndIf VirtualPascal}
    mov al,true
    jmp @ret
  @no_ip6:
    mov al,false
  @ret:
  end;

function is_amd_k8:boolean;assembler;
  asm
    {$IfDef VirtualPascal}
    mov eax,0
    cpuid
    cmp ecx,$444d4163 (* 'cAMD' *)
    jne @no_ak8
    mov eax,1
    cpuid
    push ax
    and ah,$0f
    cmp ah,$0f
    pop ax
    jb @no_ak8
    mov cpu_ver_eax,eax
    {$Else VirtualPascal}
    db $66
    sub ax,ax
    db $0f,$a2 {cpuid}
    db $66
    cmp cx,$4163 (* 'cAMD' *)
    dw $444d
    jne @no_ak8
    db $66
    sub ax,ax
    inc ax
    db $0f,$a2 {cpuid}
    push ax
    and ah,$0f
    cmp ah,6
    pop ax
    jb @no_ak8
    db $66
    mov Word Ptr cpu_ver_eax,ax
    {$EndIf VirtualPascal}
    mov al,true
    jmp @ret
  @no_ak8:
    mov al,false
  @ret:
  end;

procedure get_id;
  begin
    (* writing to MSR $8b causes an error on AMD Athlon64, avoid *)
    if not process_amd then
      begin
        (* place some value, causes readout of current value read later? *)
        wrmsr_($8b,0,0);
      end;

    rdmsr_($8b,msr_8b_hi,msr_8b_lo);
  end;

function Int2HexM(const l:longint;n:Byte):string;
  begin
    while (n<8) and ((l shr (4*n))<>0) do Inc(n);
    Int2HexM:=Int2Hex(l,n);
  end;

procedure strip(var s:string);
  begin
    while s<>'' do
      if s[1]=' ' then
        Delete(s,1,1)
      else
        Break;

    (* comment for remainder of line *)
    if s<>'' then
      if s[1] in ['%',';','#','|'] then
        s:='';
  end;

function read_number:longint;
  var
    tmp         :longint;
  begin
    tmp:=-1;
    i:=Pos(' ',lmicro_cfg_line);
    if i=0 then
      i:=Length(lmicro_cfg_line)
    else
      Dec(i);
    Val(Copy(lmicro_cfg_line,1,i),tmp,kontrolle);
    Delete(lmicro_cfg_line,1,i);
    strip(lmicro_cfg_line);
    read_number:=tmp;
  end;


procedure show_help;
  begin
    WriteLn;
    WriteLn('Usage: LMICRO.EXE <filename> [ /U | /Q ]');
    WriteLn('  where <filename> is an bios flash image or CPU microcode file.');
(*    WriteLn('  This program is only intended for Intel P6+ CPU.');*)
    WriteLn('  /U load lower revisions');
    WriteLn('  /Q quiet');
    Halt(97);
  end;


begin
  for i:=ParamCount downto 2 do
    begin
      option:=ParamStr(i);
      if not (option[1] in ['-','/']) then show_help;
      Delete(option,1,1);
      if Length(option)<>Length('Q') then show_help;
      case UpCase(option[1]) of
        'U':load_lower_revision:=not load_lower_revision;
        'Q':quiet              :=not quiet;
      else show_help;
      end;
    end;

  if quiet then
    begin
      Assign(Output,'\dev\nul');
      Rewrite(Output);
    end;

  WriteLn('LMicro * load Intel P6+, AMD K8 cpu microcode * V.K. * 2003.12.16..'+datum);
  ParamStr1:=ParamStr(1);
  if (ParamStr1='/?') or (ParamStr1='-?') then
    show_help;

  if Test8086<2 then
    begin
      WriteLn('Program does not run on <=286!');
      Halt(96);
    end;

  {$IfNDef OS2}
  asm
    smsw current_msw
  end;

  if Odd(current_msw shr 0) then
    begin
      WriteLn('Program does not run in protected mode environment!');
      Halt(95);
    end;
  {$EndIf OS2}

  Write('Reading CPU ID.. ');
  if not is_intel_p6 then
    begin
      if not is_amd_k8 then
        begin
          WriteLn('Not Intel P6+ or AMD K8 CPU!');
          (* continue here? *)
          Halt(97);
        end;

      process_amd:=true;

      productseries_search:=cpu_ver_eax;
      if (productseries_search and $0000ffff)=$00000fe0 then
        Dec(productseries_search,$20); (* 0FE0->0FC0, unknown reason, K8NSC939.F2 *)

      (* 02xxb1->02b1xx->02b1 *)
      productseries_search:=((productseries_search and $ffff0000) shr 8)
                           +((productseries_search and $000000ff) shr 0);

      FSplit(ParamStr(0),lmicro_p,lmicro_n,lmicro_e);
      {$IfDef Debug}
      if DebugHook then
        lmicro_p:='\v\lmicro\lmicro.vk\';
      {$EndIf}
      Assign(lmicro_cfg,lmicro_p+'lmicro.cfg');
      FileMode:=$40;
      {$I-}
      Reset(lmicro_cfg);
      {$I+}
      rc:=IOResult;
      if rc<>0 then
        WriteLn('Warning: can not read "',lmicro_p,'lmicro.cfg", rc=',rc,'!')
      else
        begin
          while not Eof(lmicro_cfg) do
             begin
               ReadLn(lmicro_cfg,lmicro_cfg_line);
               for i:=1 to Length(lmicro_cfg_line) do if lmicro_cfg_line[i]=^i then lmicro_cfg_line[i]:=' ';
               strip(lmicro_cfg_line);
               if lmicro_cfg_line='' then Continue;

               id_from:=read_number;
               id_to  :=read_number;

               (* error? *)
               if lmicro_cfg_line<>'' then Continue;

               if productseries_search=id_from then
                 begin
                   productseries_search:=id_to;
                   Break;
                 end;
             end;

          Close(lmicro_cfg);
        end;
    end;

  get_id;WriteLn;
  WriteLn('CPU Family/Model/Stepping: ',Int2HexM(cpu_ver_eax,3));
  Write('Micro code update sign: ',Int2HexM(msr_8b_hi,8));
  if msr_8b_lo<>0 then
    Write(':',Int2HexM(msr_8b_lo,3));
  WriteLn;
  msr_8b_hi_org:=msr_8b_hi;

  if process_amd then
    Writeln('Searching for ID='+Int2Hex(productseries_search,4));

  if (ParamStr1='') then
    show_help;

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
  w:=0;
  found:=false;
  applied:=false;

  if process_amd then
    (* AMD *)
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

          if (modell_series=productseries_search) then
            begin
              (* use >= because of claim of unchangged MSR 8B *)
              if load_lower_revision or (msr_8b_after_patch>=msr_8b_hi_org) then
                begin
                  Write('Updating.. ');
                  update(p^[w]); (* pass all data, including header! *)
                end
              else
                begin
                  Write('ignored.');
                end;
              applied:=true;
            end;
          Inc(w,block_size);
          WriteLn;
        end


  else
    (* Intel *)
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
              WriteLn('Position Date       ID  Rev');
            end;

          Write(Int2Hex(w,8),' ');
          Write(Int2Hex(year,4),'-',Int2Hex(month,2),'-',Int2Hex(day,2),' ');
          Write(Int2Hex(family_model_stepping_of_processor_to_which_update_applied,3),' ');
          Write(Int2Hex(revision_number_of_this_microcode_update,8),' ');

          if (family_model_stepping_of_processor_to_which_update_applied=cpu_ver_eax)
          (* guess *)
          or (    (family_model_stepping_of_processor_to_which_update_applied<=cpu_ver_eax)
              and (unknown_1c                                                >=cpu_ver_eax))
           then
            begin
              if load_lower_revision or (revision_number_of_this_microcode_update>msr_8b_hi_org) then
                begin
                  Write('Updating.. ');
                  update(encrypted_microcode_data);
                end
              else
                begin
                  Write('ignored.');
                end;
              applied:=true;
            end;
          Inc(w,block_size);
          WriteLn;
        end;

  Dispose(p);

  if not found then
    begin
      WriteLn('no microcode block found.');
      if not quiet then
        SysReadKey;
      Halt(99);
    end;

  if not applied then
    begin
      WriteLn('no microcode block applied.');
      if not quiet then
        SysReadKey;
      Halt(98);
    end;

  get_id;
  Write('Micro code update sign: ',Int2HexM(msr_8b_hi,8));
  if msr_8b_lo<>0 then
    Write(':',Int2HexM(msr_8b_lo,3));
  Write(' - ');
  if msr_8b_hi_org=msr_8b_hi then
    Write('unchanged.')
  else
  if msr_8b_hi_org<msr_8b_hi then
    Write('level up.')
  else
    Write('level down.');
  WriteLn;
end.
