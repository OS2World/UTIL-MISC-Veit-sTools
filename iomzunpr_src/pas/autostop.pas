{&Use32+}
program iomega_zip100_autostop;

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
  auto_stop             :integer=-1;

procedure show_help;
  begin
    WriteLn('Usage: AUTOSTOP [unitnumber [autostoptime]]');
    WriteLn('  unitnumber is 0..number of units-1');
    WriteLn('  autostoptime is 1..255, where 255 indicates "never"');
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

procedure set_autostop;
  var
    para_len,
    data_len            :longint;
    para                :para_passthru;
    data1               :array[$00..$0f] of byte;
    data2               :array[$00..$09] of byte;
    i                   :word;
  begin
    para_len:=SizeOf(para);
    data_len:=SizeOf(data1);
    FillChar(para,SizeOf(para),0);
    with para do
      begin
        unitnumber:=unit_number;
        datasize:=data_len;
        direction:=PT_DIRECTION_IN;
        command[0]:=$1a;
        command[1]:=$00;
        command[2]:=$2f;
        command[3]:=$00;
        command[4]:=$10;
        command[5]:=$00;
      end;
    FillChar(data1,SizeOf(data1),$00);
    rc:=DosDevIOCtl(iomzunp_flt_handle,
                    $80,
                    $10,
                    @para ,para_len,@para_len,
                    @data1,data_len,@data_len);
    if rc<>0 then
      begin
        WriteLn('Auto-stop status query failed!');
        WriteLn(OS_error_message(rc));
        Exit;
      end;

    Write('Old auto-stop: ');
    case data1[$0f] of
      0..254:
        Write(data1[$0f],' minute(s)');
      255:
        Write('never');
    end;
    WriteLn;

    if (auto_stop<0) or (auto_stop>255) then Exit;

    para_len:=SizeOf(para);
    data_len:=SizeOf(data2);
    FillChar(para,SizeOf(para),0);
    with para do
      begin
        unitnumber:=unit_number;
        datasize:=data_len;
        direction:=PT_DIRECTION_OUT;
        command[0]:=$15;
        command[1]:=$10;
        command[2]:=$00;
        command[3]:=$00;
        command[4]:=$0a;
        command[5]:=$00;
      end;
    data2[$0]:=$00;             // unknown...
    data2[$1]:=$00;
    data2[$2]:=$00;
    data2[$3]:=$00;
    data2[$4]:=data1[$c];       // 2f
    data2[$5]:=data1[$d];       // 04
    data2[$6]:=data1[$e];       // 5c
    data2[$7]:=auto_stop;
    data2[$8]:=$ff;             // unknown
    data2[$9]:=$0f;             // unknown
    rc:=DosDevIOCtl(iomzunp_flt_handle,
                    $80,
                    $10,
                    @para ,para_len,@para_len,
                    @data2,data_len,@data_len);
    if rc<>0 then
      begin
        WriteLn('Set Auto-stop status failed!');
        WriteLn(OS_error_message(rc));
        Exit;
      end;


  end;

begin
  if (ParamStr(1)='/?') or (ParamStr(1)='-?') or (ParamCount>2) then
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

  if ParamCount>=2 then
    auto_stop:=ValF(ParamStr(2));

  set_autostop;

  DosClose(iomzunp_flt_handle);
  Halt(rc);
end.

