{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$G+}
{$Q-}{&G4+}
{&M 90000}

program icd;

Uses
  Os2Base,
  Os2Def,
  VpSysLow;

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

procedure enable_cache(const _cr4:longint);
  var
    para                :
      packed record
        cr4             :longint;
      end;
    data                :
      packed record
        cr4             :longint;
      end;
  begin
    para.cr4:=_cr4;
    data.cr4:=_cr4;
    genioctl_sddhelp($0f-2,@para,SizeOf(para),@data,SizeOf(data));
  end;

function disable_cache:longint;
  var
    para                :
      packed record
        cr4             :longint;
      end;
    data                :
      packed record
        cr4             :longint;
      end;
  begin
    para.cr4:=0;
    data.cr4:=0;
    genioctl_sddhelp($0e-2,@para,SizeOf(para),@data,SizeOf(data));
    Result:=data.cr4;
  end;

function check486:boolean;assembler;
  {&Frame-}{&Uses ebx}
  asm
    // 486 check from uniflash
    pushfd
      pushfd
      pop eax
      mov ebx,eax
      xor eax,(1 shl 18) // Bit 18 Alignment Check
      push eax
      popfd
      pushfd
      pop eax
    popfd
    xor eax,ebx
    shr eax,18
    and eax,1
  end;

begin
  if not check486 then
    begin
      WriteLn('Program does not run on <=386!');
      Halt(99);
    end;

  //WriteLn(Int2Hex(disable_cache,8));
  disable_cache;
  WriteLn('internal cache disabled.');
end.
