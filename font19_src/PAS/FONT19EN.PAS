{&Use32+}
program font19_startup_enabler;

{$Define CONFIG_SYS_RUN}

{$IfNDef CONFIG_SYS_RUN}
{&PMType PM}
{$R font19en.res}
{$EndIf CONFIG_SYS_RUN}

// PM  program run from startup folder to do 'P_SVGA (s)VGA'/'P_VGA (16|19|20)'
// VIO ..               config.sys     ...

uses
  {$IfDef CONFIG_SYS_RUN}
  Os2Base,
  {$Else CONFIG_SYS_RUN}
  WinCrt,
  {$EndIf  CONFIG_SYS_RUN}
  HilfsFun,
  p_vga_u,
  p_svga_u,
  VpSysLow;

var
  para1                 :string;

procedure setmode(cellrow:byte);
  {$IfDef CONFIG_SYS_RUN}
  var
    cursor_row,
    cursor_col          :SmallWord;
    vmi                 :VioModeInfo;
  {$EndIf CONFIG_SYS_RUN}
  begin
    {$IfDef CONFIG_SYS_RUN}
    // Fullscreen?
    if SysCtrlSelfAppType<=1 then
      // cell change?
      if (crtc($09) and $1f)+1<>cellrow then
        begin
          // remember cursor position
          VioGetCurPos(cursor_row,cursor_col,0);
          // reset mode
          with vmi do
            begin
              cb:=Ofs(fmt_ID)-Ofs(cb);
              fbType:=1; (* color,text *)
              Color:=4;
              Col:=80;
              Row:=25;
              HRes:=720;
              VRes:=25*cellrow;
              VioSetMode(vmi,0);
              //SysSetVideoMode(80,25);
            end;
          // restor cursor position
          VioSetCurPos(cursor_row,cursor_col,0);
        end;
    {$EndIf CONFIG_SYS_RUN}
  end;

begin
  para1:=ParamStr(1);
  if para1='16' then
    begin
      patch_bvhvga_tabellen(true,1,'16');
      patch_bvhsvga_tabellen(true,1,'SVGA');
      setmode(16);
    end
  else
  if para1='19' then
    begin
      patch_bvhvga_tabellen(true,1,'19');
      patch_bvhsvga_tabellen(true,1,'VGA');
      setmode(19);
    end
  else
  if para1='20' then
    begin
      patch_bvhvga_tabellen(true,1,'20');
      patch_bvhsvga_tabellen(true,1,'VGA');
      setmode(20);
    end
  else
    begin
      WriteLn('Usage: FONT19EN (16|19|20)');
      Halt(1);
    end;
end.
