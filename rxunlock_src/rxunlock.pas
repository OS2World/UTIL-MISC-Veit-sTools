{$G5+}
// just a small change from the VP example..

Library RxUnlock;

{$CDecl+,OrgName+,I-,S-,Delphi+,Use32+}

Uses
//HeapChk,
  WinDos,
  Os2Def,
  Os2Base,
  Rexx,
  Strings,
  VpSysLow,
  VpUtils,
  ExeHdr,
  MD5,
  Objects;

Const
  FunctionTable         : Array[ 0..12 ] of pChar
                        = ( 'RxUnlockDebug',
                            'RxUnlockFiles',
                            'RxReplaceModule',
                            'RxUnlockDropFuncs',
                            'RxBldLevel',
                            'RxMD5',
                            'RxCRC32',
                            'RxFileCompare',
                            'RxCpuId',
                            'RxStemSearch3',
                            'RxRandomize',
                            'RxRandom',
                            'RxExecutableType');

  debug                 :boolean=false;
  crc32tableinitialized :boolean=false;

  buffersize            =1*1024*1024;
  bar_steps             =30;
  bar                   :array[boolean] of char=('±','Û');

var
  crc32table            :array[byte] of longint;

function DosReplaceModule(OldModName,NewModName,BackModName: PChar): ApiRet;
  external 'DOSCALLS' index 417;

procedure SetResult(const s: string; var Ret: RxString);
  begin
    Ret.strLength:=Length(s);
    StrPCopy(Ret.strptr,s);
  end;

procedure UpcaseStr(var s:string);
  var
    i                   :word;
  begin
    for i:=1 to Length(s) do
      s[i]:=UpCase(s[i]);
  end;

function SysFileSize(const Handle: Longint;var Size: TFileSize): ApiRet;
  var
    actual0             :TFileSize;
  begin
    Result := SysFileSeek(Handle, 0, 2, Size);
    if Result = 0 then
      Result := SysFileSeek(Handle, 0, 0, actual0);
  end;

procedure SetResultNum(const num: integer; var Ret: RxString);
  var
    s                   :string;
  begin
    Str(num,s);
    SetResult(s,Ret);
  end;

function clearline:string;
  begin
    SetLength(Result,1+77+1);
    FillChar(Result[1],1+77+1,' ');
    Result[1]:=^m;
    Result[1+77+1]:=^m;
  end;

//-------------------------------------------------------------------

Function RxUnlockDebug( FuncName  : PChar;
                        ArgC      : ULong;
                        Args      : pRxString;
                        QueueName : pChar;
                        Var Ret   : RxString ) : ULong; export;
begin
  If ArgC<>1 then
    begin
      Result := 40;
      Exit;
    end;

  debug:=StrComp(Args^.strptr,'1')=0;

  SetResult('0',Ret);
  Result:=0;
end;

//-------------------------------------------------------------------

Function RxUnlockLoadFuncs( FuncName  : PChar;
                            ArgC      : ULong;
                            Args      : pRxString;
                            QueueName : pChar;
                            Var Ret   : RxString ) : ULong; export;
Var
  j       : Integer;

begin
  Ret.strLength := 0;
  If ArgC > 0 then                        { Do not allow parameters }
    Result := 40
  else
    begin
      For j := Low( FunctionTable ) to High( FunctionTable ) do
        RexxRegisterFunctionDLL( FunctionTable[j],
                                 'RXUNLOCK',
                                 FunctionTable[j] );
      Result := 0;
    end;

end;

//-------------------------------------------------------------------

Function RxUnlockDropFuncs( FuncName  : PChar;
                            ArgC      : ULong;
                            Args      : pRxString;
                            QueueName : pChar;
                            Var Ret   : RxString ) : ULong; export;
Var
  j       : Integer;

begin
  Ret.strLength := 0;
  If ArgC > 0 then                        { Do not allow parameters }
    Result := 40
  else
    begin
      For j := Low( FunctionTable ) to High( FunctionTable ) do
        RexxDeregisterFunction(FunctionTable[j]);
      Result := 0;
    end;

end;

//-------------------------------------------------------------------

Function RxUnlockFiles( FuncName  : PChar;
                        ArgC      : ULong;
                        Args      : pRxString;
                        QueueName : pChar;
                        Var Ret   : RxString ) : ULong; export;
var
  I       : Integer;
  SR      : TSearchRec;
  FName,
  FileSpec,
  Dir, Name, Ext :array[0..260] of Char;
  rc,rc1  : ULong;
  FHandle : Longint;

begin
  If ArgC = 0 then
    begin
      Result := 40;                      { At least one parameter required }
      Exit;
    end;

  rc:=0;
  For i := 1 to ArgC do                   { For all arguments... }
    begin
      StrCopy(FileSpec,Args^.strptr);
      if debug then
        WriteLn(i,': "',FileSpec,'"');

      FileSplit(FileSpec,Dir,Name,Ext);
      FindFirst(FileSpec,faAnyFile and (not faDirectory),SR);
      if rc=0 then rc:=WinDos.DosError;

      if debug and (WinDos.DosError<>0) then
        begin
          WriteLn('  no files found: ',WinDos.DosError);
        end;

      while WinDos.DosError=0 do
        begin
          StrCopy(FName,Dir);
          StrCat(FName,SR.Name);

          if debug then
            Write('  Unlock "',FName,'" ');

          if SysFileOpen(FName,open_share_DenyReadWrite or open_access_ReadOnly,FHandle)=0 then
            begin
              if debug then
                WriteLn('- not locked.');

              SysFileClose(FHandle);
              rc1:=0
            end
          else
            begin
              rc1:=DosReplaceModule(FName,nil,nil);
              (* rc1=0 ok
                 rc1=2 not locked
                 rc1=296 ERROR_MODULE_IN_USE *)
              if debug then
                WriteLn(rc1);

              if rc=2 then rc:=0;
            end;
          if rc=0 then rc:=rc1;
          FindNext(SR);
        end;
      FindClose(SR);
      Inc(Args);
    end;

  SetResultNum(rc,Ret);
  Result:=0;
end;

//-------------------------------------------------------------------

Function RxReplaceModule( FuncName  : PChar;
                          ArgC      : ULong;
                          Args      : pRxString;
                          QueueName : pChar;
                          Var Ret   : RxString ) : ULong; export;
var
  TargetName,
  SourceName : array[0..260] of Char;
  FHandle : Longint;
  rc      : ULong;
  s       : String;
  SR      : TOSSearchRec;

begin
  If ArgC<>2 then
    begin
      Result := 40;
      Exit;
    end;

  Result:=0;

  SourceName[0]:=#0;
  SysFileExpand(SourceName,Args^.strptr);
  Inc(Args);

  TargetName[0]:=#0;
  SysFileExpand(TargetName,Args^.strptr);
  Inc(Args);

  if debug then
    WriteLn('RxReplaceModule("',SourceName,'", "',TargetName,'")');

  if StrIComp(SourceName,TargetName)=0 then
    begin
      if debug then WriteLn('  refer to same file');
      SetResultNum(0,Ret);
      Exit;
    end;


  rc:=SysFindFirst(TargetName,faAnyFile-faDirectory,SR,true);
  SysFindClose(SR);

  if rc=0 then
    begin // Target file exists.

      // is it in use?
      if SysFileOpen(TargetName,open_share_DenyReadWrite or open_access_ReadOnly,FHandle)=0 then
        begin
          if debug then
            WriteLn('  "',TargetName,'" is not locked.');

          SysFileClose(FHandle);
        end
      else
        // need unlocking
        begin
          if debug then Write('  DosReplaceModule("',TargetName,'", nil, nil) ');
          rc:=DosReplaceModule(@TargetName,nil,nil);
          if debug then WriteLn(rc);
          if (rc<>0) and (rc<>2) then
            begin
              SetResultNum(rc,Ret);
              Exit;
            end;
        end;

      // remove readonly... file attributes
      if debug then Write('  SysSetFileAttr("',TargetName,'", 0) ');
      rc:=SysSetFileAttr(TargetName, 0);
      if debug then WriteLn(rc);
      if rc<>0 then
        begin
          SetResultNum(rc,Ret);
          Exit;
        end;
    end
  else // target file does not exist
    begin
      if debug then WriteLn('  Target file "',TargetName,'" does not exist.');
    end;

  // copy Source to Target
  if debug then Write('  DosCopy("',SourceName,'", "',TargetName,'", dcpy_Existing) ');
  rc:=DosCopy(SourceName,TargetName,dcpy_Existing);
  if debug then WriteLn(rc);

  SetResultNum(rc,Ret);
end;

//-------------------------------------------------------------------

Function RxBldLevel(      FuncName  : PChar;
                          ArgC      : ULong;
                          Args      : pRxString;
                          QueueName : pChar;
                          Var Ret   : RxString ) : ULong; export;
var
  rc            : ULong;
  s             : String;
  exeheader     : exe_hdr;
  xx_header     :
    record
      case integer of
        0:(lx_header:e32_exe);
        1:(ne_header:new_exe);

    end;

  FHandle,
  o,
  l,
  i,j,
  actual        : Longint;
  ll,
  actualFS      : TFileSize;
  p             : pByteArray;
  test          : String;

begin
  If ArgC<>1 then
    begin
      Result := 40;
      Exit;
    end;

  if debug then WriteLn('RxBldLevel("',Args^.strptr,'")');
  s:='';
  rc:=SysFileOpen(Args^.strptr,open_access_ReadOnly or open_share_DenyNone,FHandle);
  if rc=0 then
    begin
      o:=0;
      rc:=SysFileRead(FHandle,exeheader,SizeOf(exeheader),actual);
      with exeheader do
        if (rc=0) and (actual>=$40)
        and ((e_magic=ExeId) or (e_magic=Swap(ExeId))) (* WLO: 'OZ'? *)
        and ((e_lfarlc>=$40) or (e_lfarlc+4*Longint(e_crlc)<=$3c))
        and (e_lfanew>=$40) then
          o:=e_lfanew;

      SysFileSeek(FHandle,o,0,actualFS);
      SysFileRead(FHandle,xx_header,SizeOf(xx_header),actual);
      with xx_header do
        if  (actual>=SizeOf(lx_header))
        and (lx_header.e32_Magic[0]=Ord(E32Magic1))
        and (lx_header.e32_Magic[1]=Ord(E32Magic2)) then
          begin (* LX *)
            if lx_header.e32_nrestab=0 then
              s:=''
            else
              begin
                SysFileSeek(FHandle,lx_header.e32_nrestab,0,actualFS);
                SysFileRead(FHandle,s[0],256,actual);
              end;
          end
        else
        if  (actual>=SizeOf(ne_header))
        and (ne_header.ne_magic=NEMagic) then
          begin (* NE *)
            if ne_header.ne_nrestab=0 then
              s:=''
            else
              begin
                SysFileSeek(FHandle,ne_header.ne_nrestab,0,actualFS);
                SysFileRead(FHandle,s[0],256,actual);
              end;
          end;

       (* anything else: *)
       if s='' then
          begin
            SysFileSize(FHandle,ll);
            if ll>20*1024*1024 then
              ll:=20*1024*1024;
            {$IfDef LargeFileSupport}
            l:=TFileSizeRec(ll).lo32;
            {$Else}
            l:=ll;
            {$EndIf}
            GetMem(p,l);
            FillChar(p^,l,0);
            SysFileRead(FHandle,p^,l,actual);
            s:='';
            for i:=0 to l-4 do
              if StrLComp(@p^[i],'@#',Length('@#'))=0 then
                begin
                  test:=StrPas(@p^[i]);
                  for j:=Length(test) downto 1 do
                    if test[j] in [^m,^j,^z] then SetLength(test,j-1);
                  if Pos('#@',test)=0 then Continue;
                  for j:=1 to Length(test) do
                    if test[j]<' ' then test[j]:=' ';
                  s:=test;
                  Break;
                end;
            rc:=0;
            Dispose(p);
          end;
      SysFileClose(FHandle);
    end;

  if rc=0 then
    begin
      if s='' then
        s:='no signature'
      else
        s:='"'+s+'"';
    end
  else
    Str(rc,s);

  SetResult(s,Ret);
  Result:=0;
end;

//-------------------------------------------------------------------

Function RxMD5          ( FuncName  : PChar;
                          ArgC      : ULong;
                          Args      : pRxString;
                          QueueName : pChar;
                          Var Ret   : RxString ) : ULong; export;

var
  mode_cdrom            :boolean;
  l,c,
  bar_stepsisze         :TFileSize;
  p                     :pByteArray;
  j                     :integer;
  md5context            :MD5_CTX;
  md5digest             :digest_t;
  i                     :word;
  InfileName            :array[0..260] of char;
  Infile                :Longint;
  DigestStr             :string;
  progressbar           :boolean;
  rc                    :ULong;

begin
  If (ArgC<1) or (ArgC>2) then
    begin
      Result := 40;
      Exit;
    end;

  Result:=0;

  InfileName[0]:=#0;
  StrCopy(InfileName,Args^.strptr);
  Inc(Args);

  if ArgC>=2 then
    begin
      progressbar:=StrComp(Args^.strptr,'1')=0;
      Inc(Args);
    end
  else
    progressbar:=debug;


  if StrLen(InfileName)=0 then
    begin
      SetResult('ERROR: can not open',Ret);
      Exit;
    end;


  // drive or file?
  if StrLen(InfileName)=Length('X:') then
    begin
      mode_cdrom:=true;
      if SysGetDriveType(infilename[0])<>dtCDRom then
        begin
          if progressbar then
            WriteLn('Media in drive ',infilename,' is not a CDROM.');
          SetResult('ERROR: not CDROM',Ret);
          Exit;
        end;
      // wait until ready or timeout(15 seconds)
      i:=0;
      repeat
        Inc(i);
        rc:=SysFileOpen(InfileName,open_flags_Sequential+open_flags_Fail_On_Error+open_flags_Dasd+open_share_DenyWrite,Infile);
        if rc<>error_Not_Ready then Break;
        if progressbar and (i=1) then
          Write('Waiting for drive ',infilename,' to become ready..'^m);
        SysCtrlSleep(1000);
      until i>15;
    end
  else
    begin
      mode_cdrom:=false;
      rc:=SysFileOpen(InfileName,open_flags_Sequential+open_flags_Fail_On_Error+open_share_DenyWrite,Infile);
    end;

  if rc<>0 then
    begin
      if progressbar then
        WriteLn('Can not open "',InfileName,'" -- rc=',rc);
      SetResult('ERROR: can not open',Ret);
      Exit;
    end;

  rc:=SysFileSize(infile,l);

  {$IfDef LargeFileSupport}
  if progressbar then
    bar_stepsisze:=l / bar_steps;
  {$Else}
  if progressbar then
    bar_stepsisze:=l div bar_steps;
  {$EndIf}
  MD5Init(md5context);
  GetMem(p,buffersize);
  c:=0;
  while c<l do
    begin
      j:=buffersize;

      rc:=SysFileRead(Infile,p^,buffersize,j);
      if (rc<>0) or (j<=0) then
        begin
          if progressbar then
            begin
              if mode_cdrom then
                WriteLn('Read error for media in drive ',InfileName,' -- rc=',rc)
              else
                WriteLn('Read error for file "',InfileName,'" -- rc=',rc);
            end;
          SysFileClose(Infile);
          Dispose(p);
          SetResult('ERROR: read error',Ret);
          Exit;
        end;

      MD5Update(md5context,p^,j);
      c:=c+j;
      if progressbar and (l>buffersize) then
        begin
          DigestStr:=^m'[';
          for i:=1 to bar_steps do
            DigestStr:=DigestStr+bar[c>i*bar_stepsisze];
          DigestStr:=DigestStr+'] ';
          Write(DigestStr(*,' read ',c:0{:0},' of ',l:0{:0},' bytes'*));
        end;
    end;

  SysFileClose(Infile);
  Dispose(p);

  if progressbar and (l>buffersize) then
    Write(clearline);

  MD5Final(md5digest,md5context);
  DigestStr:='';
  for i:=Low(md5digest) to High(md5digest) do
    DigestStr:=DigestStr+Int2Hex(md5digest[i],2);
  // fix for md5sum.exe -cv file -- seem to only accept lower case
  for i:=1 to Length(DigestStr) do
    if DigestStr[i] in ['A'..'F'] then Inc(DigestStr[i],Ord('a')-Ord('A'));
  if progressbar then
    WriteLn(DigestStr,' *',InfileName);

  SetResult(DigestStr,Ret);
end;

//-------------------------------------------------------------------

Function RxCRC32        ( FuncName  : PChar;
                          ArgC      : ULong;
                          Args      : pRxString;
                          QueueName : pChar;
                          Var Ret   : RxString ) : ULong; export;

var
  mode_cdrom            :boolean;
  l,c,
  bar_stepsisze         :TFileSize;
  p                     :pByteArray;
  j                     :integer;
  i                     :word;
  InfileName            :array[0..260] of char;
  Infile                :Longint;
  DigestStr             :string;
  progressbar           :boolean;
  rc                    :ULong;
  crc32context          :longint;

procedure crc32table_init;
  {&Frame-}{&Uses edi}
  asm
    mov edi,Offset crc32table
    cld
    sub edx,edx

  @create_crc32_table_sl2: // every byte
    mov eax,edx
    mov ecx,8

  @create_crc32_table_sl1: // every 8 Bit
    shr eax,1
    jnc @no_xor
    xor eax,$EDB88320
  @no_xor:
    loop @create_crc32_table_sl1

    stosd
    inc edx
    cmp edx,$100
    jne @create_crc32_table_sl2

    mov crc32tableinitialized,true
  end;

procedure crc32_init(var value:longint);
  var
    i                   :word;
  begin
    if not crc32tableinitialized then
      crc32table_init;
    value:=-1;
  end;

procedure crc32_update(var value:longint;const input;const inputlen:word);
  {&Uses All}{&Frame-}
  asm
    mov edx,value
    mov eax,[edx]
    mov esi,input
    mov ecx,inputlen
    mov edi,Offset crc32table
    test ecx,ecx
    jz @ret

    sub ebx,ebx
  @calculate_crc32_loop:
    mov bl,al
    lodsb
    xor bl,al
    shr eax,8
    xor eax,[edi+ebx*4]
    loop @calculate_crc32_loop
  @ret:
    mov [edx],eax
  end;

function crc32_final(var value:longint):longint;
  begin
    crc32_final:=not value;
  end;

begin
  If (ArgC<1) or (ArgC>2) then
    begin
      Result := 40;
      Exit;
    end;

  Result:=0;

  InfileName[0]:=#0;
  StrCopy(InfileName,Args^.strptr);
  Inc(Args);

  if ArgC>=2 then
    begin
      progressbar:=StrComp(Args^.strptr,'1')=0;
      Inc(Args);
    end
  else
    progressbar:=debug;


  if StrLen(InfileName)=0 then
    begin
      SetResult('ERROR: can not open',Ret);
      Exit;
    end;


  // drive or file?
  if StrLen(InfileName)=Length('X:') then
    begin
      mode_cdrom:=true;
      if SysGetDriveType(infilename[0])<>dtCDRom then
        begin
          if progressbar then
            WriteLn('Media in drive ',infilename,' is not a CDROM.');
          SetResult('ERROR: not CDROM',Ret);
          Exit;
        end;
      // wait until ready or timeout(15 seconds)
      i:=0;
      repeat
        Inc(i);
        rc:=SysFileOpen(InfileName,open_flags_Sequential+open_flags_Fail_On_Error+open_flags_Dasd+open_share_DenyWrite,Infile);
        if rc<>error_Not_Ready then Break;
        if progressbar and (i=1) then
          Write('Waiting for drive ',infilename,' ready..'^m);
        SysCtrlSleep(1000);
      until i>15;
    end
  else
    begin
      mode_cdrom:=false;
      rc:=SysFileOpen(InfileName,open_flags_Sequential+open_flags_Fail_On_Error+open_share_DenyWrite,Infile);
    end;

  if rc<>0 then
    begin
      if progressbar then
        WriteLn('Can not open "',InfileName,'" -- rc=',rc);
      SetResult('ERROR: can not open',Ret);
      Exit;
    end;

  rc:=SysFileSize(infile,l);

  {$IfDef LargeFileSupport}
  if progressbar then
    bar_stepsisze:=l / bar_steps;
  {$Else}
  if progressbar then
    bar_stepsisze:=l div bar_steps;
  {$EndIf}
  crc32_init(crc32context);
  GetMem(p,buffersize);
  c:=0;
  while c<l do
    begin
      j:=buffersize;

      rc:=SysFileRead(Infile,p^,buffersize,j);
      if (rc<>0) or (j<=0) then
        begin
          if progressbar then
            begin
              if mode_cdrom then
                WriteLn('Read error for media in drive ',InfileName,' -- rc=',rc)
              else
                WriteLn('Read error for file "',InfileName,'" -- rc=',rc);
            end;
          SysFileClose(Infile);
          Dispose(p);
          SetResult('ERROR: read error',Ret);
          Exit;
        end;

      crc32_update(crc32context,p^,j);
      c:=c+j;
      if progressbar and (l>buffersize) then
        begin
          DigestStr:=^m'[';
          for i:=1 to bar_steps do
            DigestStr:=DigestStr+bar[c>i*bar_stepsisze];
          DigestStr:=DigestStr+'] ';
          Write(DigestStr(*,' read ',c:0{:0},' of ',l:0{:0},' bytes'*));
        end;
    end;

  SysFileClose(Infile);
  Dispose(p);

  if progressbar and (l>buffersize) then
    Write(clearline);

  DigestStr:=Int2Hex(crc32_final(crc32context),8);

  if progressbar then
    WriteLn('Crc32(',InfileName,')=$',DigestStr);

  SetResult(DigestStr,Ret);
end;

//-------------------------------------------------------------------

Function RxFileCompare( FuncName  : PChar;
                        ArgC      : ULong;
                        Args      : pRxString;
                        QueueName : pChar;
                        Var Ret   : RxString ) : ULong; export;
var
  FileName1,
  FileName2             : PChar;
  File1,
  File2                 : Longint;
  remaining,
  FileSize1,
  FileSize2             : TFileSize;
  rc                    : ApiRet;
  i,j                   : Longint;
  Buffer1,
  Buffer2               : pByteArray;
  equal                 : Boolean;

const
  compare_fail          =0;
  compare_ok            =1;

begin
  If ArgC<>2 then
    begin
      Result := 40;
      Exit;
    end;

  Result:=0;

  FileName1:=Args^.strptr;
  Inc(Args);
  FileName2:=Args^.strptr;
  Inc(Args);

  if debug then
    WriteLn('RxFileCompare("',FileName1,'","',FileName2,'")');

  // open both files and get sizes
  rc:=SysFileOpen(FileName1,open_share_DenyNone+open_access_ReadOnly,File1);
  if rc<>0 then
    begin
      if debug then WriteLn('Can not open "',FileName1,'", rc=',rc);
      SetResultNum(compare_fail,Ret);
      Exit;
    end;
  rc:=SysFileSize(File1,FileSize1);
  if rc<>0 then
    begin
      SysFileClose(File1);
      if debug then WriteLn('Can get filesize of "',FileName1,'", rc=',rc);
      SetResultNum(compare_fail,Ret);
      Exit;
    end;
  if StrIComp(FileName1,FileName2)=0 then
    begin
      SysFileClose(File1);
      if debug then WriteLn('Both filenames are equal.');
      SetResultNum(compare_ok,Ret);
      Exit;
    end;
  rc:=SysFileOpen(FileName2,open_share_DenyNone+open_access_ReadOnly,File2);
  if rc<>0 then
    begin
      SysFileClose(File1);
      if debug then WriteLn('Can not open "',FileName2,'", rc=',rc);
      SetResultNum(compare_fail,Ret);
      Exit;
    end;
  rc:=SysFileSize(File2,FileSize2);
  if rc<>0 then
    begin
      SysFileClose(File1);
      SysFileClose(File2);
      if debug then WriteLn('Can get filesize of "',FileName2,'", rc=',rc);
      SetResultNum(compare_fail,Ret);
      Exit;
    end;

  // both have equal size?
  if FileSize1<>FileSize2 then
    equal:=false
  // compare data..
  else
    begin
      // assume ok..
      equal:=true;
      remaining:=FileSize1;
      GetMem(buffer1,buffersize);
      GetMem(buffer2,buffersize);
      while (remaining>0) and equal do
        begin
          j:=buffersize;
          if j>remaining then
            {$IfDef LargeFileSupport}
            j:=TFileSizeRec(remaining).lo32;
            {$Else}
            j:=remaining;
            {$EndIf}
          rc:=SysFileRead(File1,Buffer1^,j,i);
          if (rc<>0) or (j<>i) then
            begin
              equal:=false;
              Break;
            end;
          rc:=SysFileRead(File2,Buffer2^,j,i);
          if (rc<>0) or (j<>i) then
            begin
              equal:=false;
              Break;
            end;
          for i:=0 to j-1 do
            if Buffer1^[i]<>Buffer2^[i] then
              begin
                equal:=false;
                Break;
              end;
          remaining:=remaining-j;
        end;
      Dispose(Buffer1);
      Dispose(Buffer2);
    end;

  if equal then
    begin
      if debug then
        WriteLn('  Files are equal.');
      SetResultNum(compare_ok,Ret);
    end
  else
    begin
      if debug then
        WriteLn('  File differ.');
      SetResultNum(compare_fail,Ret);
    end;

  SysFileClose(File1);
  SysFileClose(File2);
end;


Function RxCpuId      ( FuncName  : PChar;
                        ArgC      : ULong;
                        Args      : pRxString;
                        QueueName : pChar;
                        Var Ret   : RxString ) : ULong; export;

var
  a,b,c,d:longint;
  s:string;

function Is486:boolean;assembler;
  {&Frame-}{&Uses ebx}
  asm
    pushfd
      pushfd
      pop eax
      mov ebx,eax
      xor eax,(1 shl 18) // Alignment Check bit
      push eax
      popfd
      pushfd
      pop eax
    popfd
    xor eax,ebx
    shr eax,18
    and eax,1
  end;

function CpuIdSupported:boolean;assembler;
  {&Frame-}{&Uses None}
  asm
    pushfd
    pop eax
    or eax,(1 shl 21) // set ID bit
    push eax
    popfd

    pushfd
    pop eax
    shr eax,21
    and eax,1
  end;


procedure CpuId(const subfunction:longint);assembler;
  {&Frame-}{&Uses All}
  asm
    mov eax,subfunction
    sub ebx,ebx
    sub ecx,ecx
    sub edx,edx
    cpuid
    mov a,eax
    mov b,ebx
    mov c,ecx
    mov d,edx
  end;

begin
  If ArgC<>1 then
    begin
      Result := 40;
      Exit;
    end;

  if debug then WriteLn('RxCpuId(',Args^.strptr,')');

  // subfunction
  if StrComp(Args^.strptr,'0')=0 then
    begin
      if not Is486 then
        SetResult('300 Unknown',Ret)
      else
      if not CpuIdSupported then
        SetResult('400 Unknown',Ret)
      else
        begin
          CpuId(0);
          SetLength(s,4+4+4);
          Move(b,s[1],4);
          Move(d,s[5],4);
          Move(c,s[9],4);
          CpuId(1);
          SetResult(Int2Hex(a and $fff,3)+' '+s,Ret);
        end;
    end
  else // unknown parameter
    SetResult('0',Ret);
  Result:=0;
end;


Function RxStemSearch3( FuncName  : PChar;
                        ArgC      : ULong;
                        Args      : pRxString;
                        QueueName : pChar;
                        Var Ret   : RxString ) : ULong; export;

var
  line,
  searchstring,
  sourcestemname,
  targetstemname        :string;

  i,
  count,
  sourcestem_0          :word;

function getvariable(const vn:string):string;
  var
    pool                :ShvBlock;
    rc                  :word;
    valuebuffer         :array[0..255] of char;
  begin
    with pool do
      begin
        shvnext:=nil;
        with shvname do
          begin
            strlength:=Length(vn);
            strptr:=@vn[1];
          end;
        with shvvalue do
          begin
            valuebuffer[0]:=#0;
            strlength:=SizeOf(valuebuffer);
            strptr:=@valuebuffer;
          end;
        shvnamelen:=Length(vn);
        shvvaluelen:=SizeOf(valuebuffer);
        shvcode:=rxshv_Fetch;
        shvret:=0;
      end;

    rc:=RexxVariablePool(pool);
    (*if rc=rxshv_Ok then*)
    Result:=StrPas(pool.shvvalue.strptr)
  end;

procedure setvariable(const vn,value:string);
  var
    pool                :ShvBlock;
    rc                  :word;
  begin
    with pool do
      begin
        shvnext:=nil;
        with shvname do
          begin
            strlength:=Length(vn);
            strptr:=@vn[1];
          end;
        with shvvalue do
          begin
            strlength:=Length(value);
            strptr:=@value[1];
          end;
        shvnamelen:=Length(vn);
        shvvaluelen:=Length(value);
        shvcode:=rxshv_Set;
        shvret:=0;
      end;

    rc:=RexxVariablePool(pool);
    if (rc<>rxshv_Ok) and (rc<>rxshv_NewV) then
      SetResult('Error('+vn+':='+value+'):'+Int2Str(rc),Ret);
  end;

function ValF(const s:string):integer;
  var
    k:integer;
  begin
    Val(s,Result,k);
    if k<>0 then Result:=0;
  end;


begin
  If ArgC<>3 then
    begin
      Result := 40;
      Exit;
    end;

  Result:=0;
  SetResult('',Ret);

  searchstring  :=StrPas(Args^.strptr);Inc(Args);
  sourcestemname:=StrPas(Args^.strptr);Inc(Args);
  targetstemname:=StrPas(Args^.strptr);Inc(Args);

  if debug then
    WriteLn('RxStemSearch3(',searchstring,',',sourcestemname,',',targetstemname,')');

  if searchstring='' then
    begin
      SetResult('Error: search string empty',Ret);
      Exit;
    end;

  UpcaseStr(sourcestemname);
  if (sourcestemname='')
  or (sourcestemname[Length(sourcestemname)]<>'.') then
    begin
      SetResult('Error: source stem invalid',Ret);
      Exit;
    end;

  UpcaseStr(targetstemname);
  if (targetstemname='')
  or (targetstemname[Length(targetstemname)]<>'.') then
    begin
      SetResult('Error: target stem invalid',Ret);
      Exit;
    end;

  if getvariable(sourcestemname+'0')=sourcestemname+'0' then
    begin
      SetResult('Error: target stem invalid',Ret);
      Exit;
    end;

  sourcestem_0:=ValF(getvariable(sourcestemname+'0'));
  count:=0;
  for i:=1 to sourcestem_0 do
    begin
      line:=getvariable(sourcestemname+Int2Str(i));
      if Pos(searchstring,line)<>0 then
        begin
          Inc(count);
          setvariable(targetstemname+Int2Str(count),line);
        end;
    end;
  setvariable(targetstemname+'0',Int2Str(count));

end;


Function RxRandomize(       FuncName  : PChar;
                            ArgC      : ULong;
                            Args      : pRxString;
                            QueueName : pChar;
                            Var Ret   : RxString ) : ULong; export;
begin
  Ret.strLength := 0;
  If ArgC > 0 then                        { Do not allow parameters }
    Result := 40
  else
    begin
      Randomize;
      Result := 0;
      SetResult('',Ret);
    end;
end;


Function RxRandom(          FuncName  : PChar;
                            ArgC      : ULong;
                            Args      : pRxString;
                            QueueName : pChar;
                            Var Ret   : RxString ) : ULong; export;
Var
  Range   : Longint;
  Code    : Integer;

begin
  Ret.strLength := 0;
  If ArgC > 1 then
    begin
      Result := 40;
      Exit;
    end;

  if ArgC = 0 then
    Range:= High(Range)
  else
    begin
      Val(Args^.strptr, Range, Code);
      if Code <> 0 then
        Range := High(Range);
    end;

  SetResultNum( Random(Range), Ret);
  Result := 0;
end;


Function RxExecutableType(  FuncName  : PChar;
                            ArgC      : ULong;
                            Args      : pRxString;
                            QueueName : pChar;
                            Var Ret   : RxString ) : ULong; export;
Var
  FName         : pChar;
  FHandle       : Longint;
  rc            : ULong;
  exeheader     : exe_hdr;
  o             : Longint;
  actual        : Longint;
  actualFS      : TFileSize;
  xx_header     :
    record
      case integer of
        0:(lx_header:e32_exe);
        1:(ne_header:new_exe);

    end;


begin
  Ret.strLength := 0;
  If ArgC <> 1 then
    begin
      Result := 40;
      Exit;
    end;

  FName:=Args^.strptr;

  if debug then
    WriteLn('RxExecutableType(',FName,')');

  rc:=SysFileOpen(FName,open_access_ReadOnly or open_share_DenyNone,FHandle);
  if rc<>0 then
    begin
      SetResult('Error: can not open file "'+StrPas(FName)+'"',Ret);
      Result := 0;
      Exit;
    end;

  SetResult('Error: unknown type',Ret);
  o:=0;
  rc:=SysFileRead(FHandle,exeheader,SizeOf(exeheader),actual);
  with exeheader do
    if (rc=0) and (actual>=$40)
    and ((e_magic=ExeId) or (e_magic=Swap(ExeId))) (* WLO: 'OZ'? *)
    and ((e_lfarlc>=$40) or (e_lfarlc+4*Longint(e_crlc)<=$3c))
    and (e_lfanew>=$40) then
      o:=e_lfanew;

  SysFileSeek(FHandle,o,0,actualFS);
  SysFileRead(FHandle,xx_header,SizeOf(xx_header),actual);
  with xx_header do
    if  (actual>=SizeOf(lx_header)) then
      if  (lx_header.e32_Magic[0] in [Ord('A')..Ord('Z')])
      and (lx_header.e32_Magic[1] in [Ord('A')..Ord('Z')]) then
        SetResult(Chr(lx_header.e32_Magic[0])
                 +Chr(lx_header.e32_Magic[1]),Ret);

  SysFileClose(FHandle);

  Result := 0;
end;



//-------------------------------------------------------------------

initialization
end.

