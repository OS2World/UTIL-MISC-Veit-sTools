{&Use32+}
{$I-}
program testmd5;

uses
  Os2Base,
  Strings,
  VpSysLow,
  VpUtils,
  md5;

const
  bar_steps             =30;
  bar                   :array[boolean] of char=('_','Û');

var
  mode_cdrom            :boolean;
  l,actual0,c,
  bar_stepsisze         :TFileSize;
  p                     :array[0..1*1024*1024] of byte;
  j                     :integer;
  md5context            :MD5_CTX;
  md5digest             :digest_t;
  i                     :word;
  infilename            :array[0..260] of char;
  rc                    :word;
  infile                :Longint;
  digest_str            :string;

begin
  if (ParamCount<>1) or (ParamStr(1)='-?') or (ParamStr(1)='/?') then
    begin
      WriteLn('Usage: TESTMD5.EXE (filename|cdrom drive:)');
      Halt(1);
    end;

  StrPCopy(infilename,ParamStr(1));
  if StrLen(infilename)=Length('R:') then
    begin
      mode_cdrom:=true;
      if GetDriveType(infilename[0])<>dtCDRom then
        begin
          WriteLn('Media in drive ',infilename,' is not a CDROM.');
          Halt(99);
        end;
      i:=0;
      repeat
        Inc(i);
        rc:=SysFileOpen(infilename,open_flags_Sequential+open_flags_Fail_On_Error+open_flags_Dasd+open_share_DenyWrite,infile);
        if rc<>error_Not_Ready then Break;
        if i=1 then
          Write('Waiting for drive ',infilename,' ready..'^m);
        SysCtrlSleep(1000);
      until i>15;
    end
  else
    begin
      mode_cdrom:=false;
      rc:=SysFileOpen(infilename,$40,infile);
    end;

  if rc<>0 then
    begin
      WriteLn('Can not open "',infilename,'" -- rc=',rc);
      Halt(rc);
    end;

  rc:=SysFileSeek(infile,0,2,l);
  rc:=SysFileSeek(infile,0,0,actual0);

  bar_stepsisze:=l div 20;
  MD5Init(md5context);
  c:=0;
  while c<l do
    begin
      rc:=SysFileRead(infile,p,SizeOf(p),j);
      if rc<>0 then
        begin
          if mode_cdrom then
            WriteLn('Read error for media in drve ',infilename,' -- rc=',rc)
          else
            WriteLn('Read error for file "',infilename,'" -- rc=',rc);
          SysBeepEx(1000,1000);
          SysCtrlSleep(8000);
          Halt(rc);
        end;
      if j<=0 then RunError(99);
      MD5Update(md5context,p,j);
      c:=c+j;
      if l>SizeOf(p) then
        begin
          bar_stepsisze:=l div 20;
          digest_str:=^m'[';
          for i:=1 to bar_steps do
            digest_str:=digest_str+bar[c>i*bar_stepsisze];
          Write(digest_str,']  read ',c:0{:0},' of ',l:0{:0},' bytes');
        end;
    end;

  SysFileClose(infile);
  if l>SizeOf(p) then
    begin
      Write(^m);
      for i:=1 to 70 do
        Write(' ');
      Write(^m);
    end;

  MD5Final(md5digest,md5context);
  digest_str:='';
  for i:=Low(md5digest) to High(md5digest) do
    digest_str:=digest_str+Int2Hex(md5digest[i],2);
  // fix for md5sum.exe -cv file -- seem to only accept lower case
  for i:=1 to Length(digest_str) do
    if digest_str[i] in ['A'..'F'] then Inc(digest_str[i],Ord('a')-Ord('A'));
  WriteLn(digest_str,' *',infilename);
end.

