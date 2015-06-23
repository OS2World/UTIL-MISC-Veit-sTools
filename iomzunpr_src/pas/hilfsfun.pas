{&Use32+}
unit hilfsfun; (* Hilfsfunktionen *)

interface

{$IfNDef VirtualPascal}
type
  SmallWord             =Word;
{$EndIf VirtualPascal}

{$IfDef Os2}
function PMPresent:boolean;
function SelToFlatFunction(p:pointer):pointer;
{$EndIf}
procedure Abbruch(const zk:string;rc:word);
procedure Fehlerbehandlung(const call:string;const rc:longint);
function OS_error_message(n:word):string;
procedure wait;
function crtc(const n:byte):byte;
function Int2Hex(const Number:Longint;const n:Byte):String;
function Int2Str(const Number:Longint):String;

implementation

Uses
  {$IfDef VirtualPascal}
  Os2Base,
  VpUtils,
  VpSysLow,
  {$EndIf VirtualPascal}
  Strings;


{$IfDef Os2}
{&Far16+}
function Dos16SMPMPresent(var present:smallword):smallword;
  External 'DOSCALLS' index 712;
{&Far16-}

function PMPresent;
  var
    present:smallword;
  begin
    PMPresent:=false;
    if Dos16SMPMPresent(present)=0 then
      PMPresent:=(present=1);
  end;

function SelToFlatFunction(p:pointer):pointer;
  var
    tmp:pointer;
  begin
    tmp:=p;
    SelToFlat(tmp);
    Result:=tmp;
  end;

{$EndIf Os2}

procedure Abbruch(const zk:string;rc:word);
  begin
    WriteLn(zk);
    Halt(rc);
  end;

procedure Fehlerbehandlung(const call:string;const rc:longint);
  begin
    if rc<>0 then
      Abbruch(call+': '+OS_error_message(rc),rc);
  end;

function OS_error_message(n:word):string;
  var
    {$IfDef VirtualPascal}
    buffer              :array[0..512] of char;
    msglen              :word;
    message_start       :PChar;
    {$EndIf VirtualPascal}
    {$IfNDef VirtualPascal}
    Result              :string;
    {$EndIf VirtualPascal}
  begin
    if n>=$fe00 then
      Result:=' $'+Int2Hex(n,4)
    else
      Result:=' '+Int2Str(n);
    {$IfDef VirtualPascal}
    SysGetSystemError(n,buffer,SizeOf(buffer),msglen);
    buffer[Min(High(buffer),msglen)]:=#0;

    if StrLen(buffer)=0 then
      case n of
        $ff01:StrCopy(buffer,'IOERR_CMD');
        $ff02:StrCopy(buffer,'IOERR_UNIT');
        $ff03:StrCopy(buffer,'IOERR_RBA');
        $ff04:StrCopy(buffer,'IOERR_MEDIA');
        $ff05:StrCopy(buffer,'IOERR_ADAPTER');
        $ff06:StrCopy(buffer,'IOERR_DEVICE');
      end;
    msglen:=StrLen(buffer);
    if msglen>0 then
      begin
        message_start:=@buffer[0];
        if StrLComp(@('SYS'+Int2StrZ(n,4)+#0)[1],message_start,3+4)=0 then
          begin
            Inc(message_start,3+4);
            while message_start[0] in [' ',':'] do Inc(message_start);
          end;
        Result:=Result+': '+StrPas(message_start);
      end

    {$EndIf VirtualPascal}
    {$IfNDef VirtualPascal}
    OS_error_message:=Result;
    {$EndIf VirtualPascal}
  end;

procedure wait;
  {$IfNDef VirtualPascal}
  var
    i                   :word;
  {$EndIf VirtualPascal}
  begin
    {$IfDef VirtualPascal}
    SysCtrlSleep(0);
    {$Else VirtualPascal}
    for i:=1 to 100 do
      Port[$eb]:=0;
    {$EndIf VirtualPascal}
  end;

const
  crtc_base:SmallWord=0;

function crtc(const n:byte):byte;
  begin
    if crtc_base=0 then
      begin
        if Odd(Port[$3cc] shr 0) then
           crtc_base:=$3d4
        else
           crtc_base:=$3b4;
        wait;
      end;
    Port[crtc_base]:=n;
    wait;
    crtc:=Port[crtc_base+1];
    wait;
  end;

function Int2Hex(const Number:Longint;const n:Byte):String;
  const
    hexz                :array[0..15] of char ='0123456789abcdef';
  var
    {$IfNDef VirtualPascal}
    Result              :string;
    {$EndIf VirtualPascal}
    i                   :word;
  begin
    Result[0]:=Chr(n);
    for i:=0 to n-1 do
      Result[n-i]:=hexz[(Number shr (i*4)) and $f];
    {$IfNDef VirtualPascal}
    Int2Hex:=Result;
    {$EndIf VirtualPascal}
  end;

function Int2Str(const Number:Longint):String;
  {$IfNDef VirtualPascal}
  var
    Result              :string;
  {$EndIf VirtualPascal}
  begin
    Str(Number,Result);
    {$IfNDef VirtualPascal}
    Int2Str:=Result;
    {$EndIf VirtualPascal}
  end;

end.
