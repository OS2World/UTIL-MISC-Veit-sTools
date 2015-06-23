{&Use32+}{&H-}
program StampDef;

(* V.K. 2002.11.24 *)
(* V.K. 2003.06.07 Do not write file if date is correct *)
(* V.K. 2004.05.20 do not store trailing #0 in case of newly created def file *)


uses
  {$IfDef VirtualPascal}
  VpUtils,
  VpSysLow,
  {$EndIf}
  WinDos,
  Strings;

const
  changed       :boolean=false;

var
  f             :file;
  p,work        :PChar;
  l             :longint;
  y,m,d,w       :word;
  line          :string;
  newfilespace  :array[0..1024] of char;

procedure error(const s:string);
  begin
    WriteLn(s);
    Halt(255);
  end;

procedure Int_to_str_z(i:word;p:PChar;num:word);
  var
    c:char;
  begin
    Inc(p,num-1);
    while num>0 do
      begin
        c:=Chr(Ord('0')+i mod 10);
        if p[0]<>c then
          begin
            p[0]:=c;
            changed:=true;
          end;
        i:=i div 10;
        Dec(p);
        Dec(num);
      end;
  end;

begin
  if ParamCount=0 then
    error('Usage: StampDef FILE.def');

  (* filename fix for IDE *)
  p:=StrpCopy(@newfilespace,ParamStr(1));

  while p[0]>=' ' do
    if StrIComp(p,'.pas.def')=0 then
      StrCopy(p,'.def')
    else
      Inc(p);

  line:=StrPas(@newfilespace);


  (* file exist ? *)
  Assign(f,line{ParamStr(1)});
  {$I-}
  Reset(f,1);
  {$I+}

  if IOResult<>0 then
    begin (* new file *)
      {$IfDef VirtualPascal}
      if not IsFileHandleConsole(SysFileStdOut) then
        Error('file '+line+' does not exist. - no primary file ?');
      {$EndIf}
      WriteLn('Definition file does not exist. Creating new.');
      p:=@newfilespace;
      StrCopy(p,'DESCRIPTION '#39'@#');
      Write('enter vendor or programmer: ');
      ReadLn(line);
      StrPCopy(StrEnd(p),line);
      StrCat(p,':YYYY.MM.DD#@');
      Write('enter short description : ');
      ReadLn(line);
      StrPCopy(StrEnd(p),line);
      StrCat(p,#39#13#10);
      l:=StrLen(p);
    end

  else

    begin (* read existing file *)
      l:=FileSize(f);
      GetMem(p,l+1);
      BlockRead(f,p^,l);
      p[l]:=#0;
      Close(f);
    end;

  (* process def file *)
  work:=StrPos(p,'DESCRIPTION');
  if not Assigned(work) then
    work:=StrPos(p,'Description');
  if not Assigned(work) then
    Error('DESCRIPTION not found.');
  Inc(work,Length('DESCRIPTION'));

  repeat
    if work[0] in [#0..#31] then
      Error('date field not found.');

    if  (work[0] in ['1'..'2','Y'])
    and (work[1] in ['0'..'9','Y'])
    and (work[2] in ['0'..'9','Y'])
    and (work[3] in ['0'..'9','Y'])
    and (work[4]='.')
    and (work[5] in ['0'..'1','M'])
    and (work[6] in ['0'..'9','M'])
    and (work[7]='.')
    and (work[8] in ['0'..'3','D'])
    and (work[9] in ['0'..'9','D']) then
      begin
        GetDate(y,m,d,w);
        Int_to_str_z(y,@work[0],4);
        Int_to_str_z(m,@work[5],2);
        Int_to_str_z(d,@work[8],2);
        Break;
      end;

    Inc(work);
  until false;

  if changed then
    begin
      Rewrite(f,1);
      Seek(f,0);
      BlockWrite(f,p^,l);
      Close(f);
    end;

  if Pointer(p)<>@newfilespace then Dispose(p);
end.
