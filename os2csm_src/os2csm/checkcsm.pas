program checkcsm;

(* v.k. 2003.03.15
   Load %bootdrive%\config.sys and verify 512 byte alignment,
   if altered, print warning and start CMD.EXE
   Usage in config.sys: call=...\checkcsm.exe config.sys *)

uses
  Dos,
  Strings,
  VpSysLow;


var
  config_sys            :file;
  config_sys_name       :string;
  config_sys_buffer     :array[0..60000] of char;
  laenge,o              :longint;

const
  lastsector_sig        :array[boolean] of char=('+','-');

procedure shell;
  var
    path_csm,path_config,n,e:string;
  begin

    FSplit(ParamStr(0),path_csm,n,e);
    if not (path_csm[Length(path_csm)] in ['\','/']) then path_csm:=path_csm+SysPathSep{'\'};

    FSplit(config_sys_name,path_config,n,e);
    if not (path_config[Length(path_config)] in ['\','/']) then path_config:=path_config+SysPathSep{'\'};

    WriteLn(config_sys_name,' markup is not valid.');
    WriteLn('Please check file and rerun ',path_csm,'Align512.exe');
    WriteLn('or ',path_csm,'os2csm.exe ',path_config,' /i');
    WriteLn;

    Exec(GetEnv('COMSPEC'),'/K');
    if Dos.DosError<>0 then
      Exec(SysGetBootDrive+':\os2\cmd.exe','/K');

    Halt(1);
  end;

begin

  case ParamCount of
   {0:
      config_sys_name:=SysGetBootDrive+':\config.sys';}
    1:
      config_sys_name:=ParamStr(1);
  else
    WriteLn('call=...\checkcsm.exe (bootdrive:)\config.sys');
    Halt(99);
  end;

  Assign(config_sys,config_sys_name);
  Reset(config_sys,1);
  BlockRead(config_sys,config_sys_buffer,SizeOf(config_sys_buffer),laenge);
  Close(config_sys);

  if laenge=SizeOf(config_sys_buffer) then
    begin
      WriteLn(config_sys_name,' is to large.');
      RunError(99);
    end;

  if (laenge mod 512)<>0 then
    shell;

  o:=0;
  while o<laenge do
    begin
      if (StrLComp(@config_sys_buffer[o+0],'REM V.K. * OS2CFG * 0',Length('REM V.K. * OS2CFG * 0'))<>0)
      or (StrLComp(@config_sys_buffer[o+512-2],^M^J,Length(^M^J))<>0)
      or (config_sys_buffer[o+512-3]<>lastsector_sig[o+512=laenge]) then
        shell;
      Inc(o,512);
    end;

end.
