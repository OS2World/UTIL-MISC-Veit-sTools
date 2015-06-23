{$Use32+}
program iomega_zip100_protect;

uses
  Strings,
  Os2Def,
  Os2Base,
  HilfsFun;

const
  iomzunp_flt_name      ='\DEV\I$Z$UNP$'#0;

  PT_DIRECTION_OUT      =0;
  PT_DIRECTION_IN       =1;

type
  para_passthru         =
    packed record
      unitnumber        :byte;
      datasize          :smallword;
      direction         :byte;
      command           :array[0..5] of byte
    end;

var
  iomzunp_flt_handle    :longint;
  rc                    :ApiRet;
  action                :longint;
  unit_number           :byte=0;
  old_protect_status    :byte;

procedure show_help;
  begin
    WriteLn('Usage: PROTECT unitnumber new_status password');
    WriteLn('  unitnumber is 0..number of units-1');
    WriteLn('  possible values for new_status:');
    WriteLn('    WRITE_PROTECTED');
    WriteLn('    READ_WRITE_PROTECTED');
    WriteLn('    UNPROTECTED_UNIT_EJECT');
    WriteLn('    NOT_PROTECTED');
    Halt(99);
  end;

function ValF(const s:string):integer;
  var
    kontrolle           :integer;
  begin
    Val(s,Result,kontrolle);
    if kontrolle<>0 then
      begin
        WriteLn('"',s,'" is not a valid number!');
        show_help;
      end;
  end;

function get_protect_status:byte;
  var
    para_len,
    data_len            :longint;
    para                :para_passthru;
    data                :array[$00..$5f] of byte;
  begin
    para_len:=SizeOf(para);
    data_len:=SizeOf(data);
    FillChar(para,SizeOf(para),0);
    with para do
      begin
        unitnumber:=unit_number;
        datasize:=data_len;
        direction:=PT_DIRECTION_IN;
        command[0]:=$06;
        command[1]:=$00;
        command[2]:=$02;
        command[3]:=$00;
        command[4]:=data_len;
        command[5]:=$00;
      end;
    FillChar(data,SizeOf(data),$cc);
    rc:=DosDevIOCtl(iomzunp_flt_handle,
                    $80,
                    $10,
                    @para,para_len,@para_len,
                    @data,data_len,@data_len);
    if rc=0 then
      begin
        Result:=data[$15];
      end
    else
      begin
        Result:=0;
        WriteLn('Get-status-DosDevIOCtl failed!');
        WriteLn(OS_error_message(rc));
      end;

  end;



procedure set_protect_status(const m:byte);
  var
    para_len,
    data_len            :longint;
    para                :para_passthru;
    data                :array[$00..$1f] of byte;
    password            :string[$20];
    i                   :word;
  begin
    if Odd((m or old_protect_status) shr 0) then
      password:=ParamStr(3)
    else
      password:='';
    para_len:=SizeOf(para);
    data_len:=Length(password);
    Move(password[1],data,data_len);
    FillChar(para,SizeOf(para),0);
    with para do
      begin
        unitnumber:=unit_number;
        datasize:=data_len;
        direction:=PT_DIRECTION_OUT;
        command[0]:=$0c;
        command[1]:=m;
        command[2]:=$00;
        command[3]:=$00;
        command[4]:=data_len;
        command[5]:=$00;
      end;
    if data_len=0 then data_len:=1; (* avoild 'invalid parameter' *)
    rc:=DosDevIOCtl(iomzunp_flt_handle,
                    $80,
                    $10,
                    @para,para_len,@para_len,
                    @data,data_len,@data_len);
    if rc=0 then
      begin
      end
    else
      begin
        WriteLn('Set-status-DosDevIOCtl failed!');
        WriteLn(OS_error_message(rc));
      end;

  end;

begin
  if (ParamStr(1)='/?') or (ParamStr(1)='-?') or (ParamCount<2) or (ParamCount>3) then
    show_help;

  rc:=DosOpen(iomzunp_flt_name,
              iomzunp_flt_handle,
              action,
              0,
              0,
              open_action_Fail_If_New+open_action_Open_If_Exists,
              open_flags_Write_Through+open_flags_Fail_On_Error+open_flags_No_Cache+open_flags_No_Locality+open_flags_NoInherit+open_share_DenyNone+open_access_ReadOnly,
              nil);
  if rc<>0 then
    begin
      WriteLn('Can not access driver!');
      WriteLn(OS_error_message(rc));
      Halt(rc);
    end;

  unit_number:=ValF(ParamStr(1));

  old_protect_status:=get_protect_status;
  if rc<>0 then Halt(0);

  if ParamStr(2)='WRITE_PROTECTED' then
    set_protect_status((1 shl 1)+(1 shl 0))
  else
  if ParamStr(2)='READ_WRITE_PROTECTED' then
    set_protect_status((1 shl 2){+(1 shl 1)}+(1 shl 0))
  else
  if ParamStr(2)='UNPROTECTED_UNIT_EJECT' then
    set_protect_status(old_protect_status or (1 shl 3))
  else
  if ParamStr(2)='NOT_PROTECTED' then
    set_protect_status(0)
  else
    begin
      WriteLn('Can not understand "',ParamStr(2),'"');
      rc:=99;
    end;

  DosClose(iomzunp_flt_handle);
  Halt(rc);
end.
