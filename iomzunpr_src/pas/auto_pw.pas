{$Use32+}
program iomega_zip100_send_automatic_unprotect_password;

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
      passwordlength    :byte;
    end;

var
  iomzunp_flt_handle    :longint;
  rc                    :ApiRet;
  action                :longint;
  unit_number           :byte=0;

procedure show_help;
  begin
    WriteLn('Usage: AUTO_PW unitnumber password');
    WriteLn('  unitnumber is 0..number of units-1');
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

procedure send_password;
  var
    para_len,
    data_len            :longint;
    para                :para_passthru;
    data                :array[$00..$1f] of byte;
    password            :string[$20];
    i                   :word;
  begin
    password:=ParamStr(2);
    para_len:=SizeOf(para);
    data_len:=Length(password);
    Move(password[1],data,data_len);
    with para do
      begin
        unitnumber:=unit_number;
        passwordlength:=data_len;
      end;
    if data_len=0 then data_len:=1; (* avoild 'invalid parameter' *)
    rc:=DosDevIOCtl(iomzunp_flt_handle,
                    $80,
                    $00,
                    @para,para_len,@para_len,
                    @data,data_len,@data_len);
    if rc=0 then
      begin
      end
    else
      begin
        WriteLn('Send-password-DosDevIOCtl failed!');
        WriteLn(OS_error_message(rc));
      end;


  end;

begin
  if (ParamStr(1)='/?') or (ParamStr(1)='-?') or (ParamCount<1) or (ParamCount>2) then
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

  if ParamCount>=1 then
    unit_number:=ValF(ParamStr(1));

  send_password;

  DosClose(iomzunp_flt_handle);
  Halt(rc);
end.
