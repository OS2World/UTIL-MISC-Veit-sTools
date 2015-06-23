{$Use32+}
program iomega_zip100_inquiry;

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

procedure show_help;
  begin
    WriteLn('Usage: INQUIRY [unitnumber]');
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

procedure inquiry;
  var
    para_len,
    data_len            :longint;
    para                :para_passthru;
    data                :array[$00..$5f] of byte;
    i                   :word;
  begin
    para_len:=SizeOf(para);
    data_len:=SizeOf(data);
    FillChar(para,SizeOf(para),0);
    with para do
      begin
        unitnumber:=unit_number;
        datasize:=data_len;
        direction:=PT_DIRECTION_IN;
        command[0]:=$12;
        command[1]:=$00;
        command[2]:=$00;
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
    if rc<>0 then
      begin
        WriteLn('Inquiry-DosDevIOCtl failed!');
        WriteLn(OS_error_message(rc));
        Exit;
      end;

    WriteLn(StrPas(@data[8]));
  end;

begin
  if (ParamStr(1)='/?') or (ParamStr(1)='-?') or (ParamCount>1) then
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

  inquiry;

  DosClose(iomzunp_flt_handle);
  Halt(rc);
end.
