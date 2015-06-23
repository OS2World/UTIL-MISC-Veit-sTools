(***************************************************************************
 viowin, unit for virtual pascal by tam@gmx.de
 please send improvments of any kind to me. remember that any code you
 add should run under OS/2 and WIN32.

 usage and distribution is free, as long as nobody has to pay for it.
 ***************************************************************************
 22.11.1999 - first public release (tam@gmx.de)
 23.11.1999 - droped dos support to concentrate on 32bit code. (tam@gmx.de)
 09.12.1999 - Dpmi32 support, some const ShortString parameters
              (veit.kannegieser@gmx.de)
 15.12.1999 - some changes in GetScreen(), only Win32 code (tam@gmx.de)
            - added initialization of global variables
 04.01.2000 - changed all string types to ShortString
 19.07.2000 - renamed from mywin to viowin, added some more comments
              (tam@gmx.de)
 13.03.2001 - found small bug in CWin
 19.10.2001 - derived TP compatibe version using TPSysLow
              (Veit.Kannegieser@gmx.de)
 ***************************************************************************)

{&H+,Delphi+,Use32+}
{$X+}

Unit VioWin;

Interface

{$IfDef OS2}   {$Define OS2_Win32} {$EndIf}
{$IfDef Win32} {$Define OS2_Win32} {$EndIf}

{$IfNDef VirtualPascal}
type
  ShortString=string;
{$EndIf}

Procedure OWin(x1,y1,x2,y2,att : byte; Text : ShortString);
Procedure OcWin(Width,Height,StartH,Color : byte; Text : ShortString);
Procedure CWin;
Procedure CloseAllWin;
Procedure FillScreen(x1,y1,x2,y2,Color : byte; c : char);
Procedure WriteXY(x,y : byte; const s : ShortString; att : byte);
Procedure WriteXYabs(x,y : byte; const s : ShortString; att : byte);
Procedure Invers(x,y,l,c : byte);
Function GetScreen(x,y,l : byte) : ShortString;
Procedure CText(y : byte; s : ShortString; att :  byte);
Procedure HiLight(x,y : byte; const s : ShortString; att : byte);
Procedure Frame(art,x1,y1,x2,y2 : byte);
Function StrOfChar(c : Char; len : LongInt) : ShortString;
Procedure invisibleWin;

var XMax,YMax : byte;
    NumWin    : LongInt; { number of open win }

Implementation

uses Crt,
     {$IfDef VirtualPascal}
     VpSysLow
     {$Else}
     TpSysLow
     {$EndIf}
     {$IfDef OS2}
     ,Os2Base
     {$EndIf}
     {$IfDef Win32}
     ,Windows
     {$EndIf}
     ;

type WinPtr = ^Win;
     Win = record
             x1,y1,            { upper left and lower right coordinates }
             x2,y2  : byte;
             Buffer : pChar;   { buffer for background }
             BSize  : word;    { size of background }
             Next,             { pointer to next win }
             Last   : WinPtr;  { pointer previous win }
           end;

var Root,                     { pointer to first win }
    CurrentWin,               { pointer to current win }
    Last       : WinPtr;      { pointer to last win }
    WinCounter  : LongInt;     { number of currently open win }
    StartWinX1,StartWinY1,StartWinX2,StartWinY2 : byte;
    {$IfDef WIN32}
    SysConOut : LongInt;      { handle for std out }
    {$EndIf}

Procedure Invers(x,y,l,c : byte);
{ inverts the screen at x,y, if c (color) <> 0 then the invers color is c
  else color is textattr xor 127 }
var Att : Word;
begin
  inc(x,Lo(WindMin));  { adjust x,y to the current window }
  inc(y,Hi(WindMin));
  Att := SysReadAttributesAt(x-1,y-1); { read attribute at (x,y) }
  if c = 0 then
    Att := Att XOR 127
  else
    Att := c;
  writexyabs(x,y,GetScreen(x-Lo(WindMin),y-Hi(WindMin),l),Att);
end;

Procedure WriteXYabs(x,y : byte; const s : ShortString; att : byte);
begin
  SysWrtCharStrAtt(@s[1],Length(s),x-1,y-1,att);
end;

Procedure WriteXY(x,y : Byte; const s : ShortString; att : Byte);
begin
  inc(x,Lo(WindMin)); { adjust x,y to the current window }
  inc(y,Hi(WindMin));
  WriteXYabs(x,y,s,att);
end;

Procedure CText(y : byte; s : ShortString; att :  byte);
{ centers ShortString s in the current window }
var x,x1,x2,l,zl : byte;
begin
  x1 := Lo(WindMin); { adjust x,y to the current window }
  x2 := Lo(WindMax);
  zl := (x2-x1) shr 1 + 1;
  l := length(s);
  if l >= (x2-x1) then begin
    Delete(s,1,l-(x2-x1)+1);
    l := length(s);
  end;
  x := zl - (l shr 1);
  WriteXY(x,y,s,att);
end;

Procedure HiLight(x,y : byte; const s : ShortString; att : byte);
var b,l : byte;
begin
  l := length(s);
  for b := 1 to l do begin
    if (b <> l) and (s[b+1] = '^') then begin
      WriteXY(x,y,s[b],att);
      inc(b);
    end
    else
      WriteXY(x,y,s[b],TextAttr);
    inc(x);
  end;
end;

Procedure FillScreen(x1,y1,x2,y2,Color : byte; c : char);
{ fills the rectangle with character "c" and "color" }
var s : ShortString;
    a,b : LongInt;
begin
  inc(x1,Lo(WindMin));
  inc(y1,Hi(WindMin));
  inc(x2,Lo(WindMin));
  inc(y2,Hi(WindMin));
  FillChar(s,SizeOf(s),c);
  while y2 >= y1 do begin
    dec(y2);
    SysWrtCharStrAtt(@s[1],x2-x1+1,x1-1,y2,Color);
  end;
end;

Function GetScreen(x,y,l : byte) : ShortString;
{ returns a ShortString at pos x,y with length l }
var b    : LongInt;
    s    : ShortString;
    {$IfDef WIN32}
    Len  : LongInt;
    Coor : TCoord;
    {$Else}
    p    : pChar;
    Len  : SmallWord;
    {$EndIf}
begin
  s := '';
  {$IfDef WIN32}
  SysTVInitCursor;
  {$EndIf}
  inc(x,Lo(WindMin)-1); { adjust x,y to the current window }
  inc(y,Hi(WindMin)-1);
  if l = 0 then
    s := ''
  else begin
    {$IfDef OS2}
    Len := l*2;
    GetMem(p,Len);
    VioReadCellStr(p[0],Len,y,x,0);
    for b := 0 to l-1 do
      s[b+1] := Char(p[b*2]);
    FreeMem(p);
    {$Else}
    {$IFDEF Win32}
    Coor.x := x;
    Coor.y := y;
    ReadConsoleOutputCharacter(SysConOut,@s[1],l,Coor,b);
    {$Else} { DPMI32 }
    for b := 0 to l-1 do
      s[b+1]:=SysReadCharAt(x+b,y);
    {$EndIf}
    {$EndIf}
  end;
  SetLength(s,l);
  GetScreen := s;
end;

Function StrOfChar(c : Char; len : LongInt) : ShortString;
var s : ShortString;
begin
  FillChar(s,SizeOf(s),c);
  SetLength(s,len);
  StrOfChar := s;
end;

Procedure Frame(art,x1,y1,x2,y2 : byte);
{ draws a frame }
var s : ShortString;
    a,Color : LongInt;
    tmp : ShortString;
begin
  case art of
    1 : s := 'ڿ��ĳ'; { different types of frameborder }
    2 : s := 'ַӽĺ'; { needs some changes for windows codepage }
    3 : s := 'ɻȼͺ';
    4 : s := 'ոԾͳ';
  end;
  { upper }
  tmp:=StrOfChar(s[5],x2-x1-1);
  SysWrtCharStrAtt(@tmp[1],x2-x1-1,x1,y1-1,TextAttr);
  { lower }
  SysWrtCharStrAtt(@tmp[1],x2-x1-1,x1,y2-1,TextAttr);
  for a := 1 to y2-y1-1 do
    SysWrtCharStrAtt(@s[6],1,x1-1,y1+a-1,TextAttr); { left }
  for a := 1 to y2-y1-1 do
    SysWrtCharStrAtt(@s[6],1,x2-1,y1+a-1,TextAttr); { right }
  SysWrtCharStrAtt(@s[1],1,x1-1,y1-1,TextAttr); { upper left corner }
  SysWrtCharStrAtt(@s[2],1,x2-1,y1-1,TextAttr); { upper right corner }
  SysWrtCharStrAtt(@s[3],1,x1-1,y2-1,TextAttr); { lower left corner }
  SysWrtCharStrAtt(@s[4],1,x2-1,y2-1,TextAttr); { lower right corner }
end; { Frame }

Procedure SaveBackGround(fx1,fy1,fx2,fy2 : byte);
{ ceates a new win and saves the background of this }
var Start,Size,Rows,y,z : LongInt;
    Win      : WinPtr;
    Len      : SmallWord;
    {$IfDef WIN32}
    WasRead : Longint;
    UpLeft  : TCoord;
    ReadFrom: TSmallRect;
    BufferSize: TCoord;
    {$EndIf}
    {$IfNDef OS2_Win32}
    x       : word;
    {$EndIf}
begin
  Inc(WinCounter);
  Rows := fy2-fy1+2;
  Len := (fx2-fx1+2)*2;
  Size := Len*Rows;
  {$IfDef WIN32}
  SysTVInitCursor;
  Size := Size*2;
  {$EndIf}
  New(Win);
  with Win^ do begin { save the win coordinates }
    x1 := fx1;
    y1 := fy1;
    x2 := fx2;
    y2 := fy2;
    BSize:=Size;
    GetMem(Buffer,Size); { get memory for the background }
    z := 0;
    {$IfDef WIN32}
    BufferSize.x := x2-x1+2;
    BufferSize.y := y2-y1+2;
    UpLeft.x := 0; { upper left corner of buffer, always (0,0) in this case }
    UpLeft.y := 0;
    with ReadFrom do begin { rectangle on screen to read from }
      Left:=fx1-1;
      Top:=fy1-1;
      Right:=fx2;
      Bottom:=fy2;
    end;
    ReadConsoleOutput(SysConOut,@Buffer[z], BufferSize, UpLeft, ReadFrom);
    {$Else}
    {$IfDef OS2}
    for y := fy1 to fy2+1 do begin { OS/2 }
      VioReadCellStr(Buffer[z],Len,y-1,fx1-1,0);
      inc(z,Len);
    end;
    {$Else}
    { DPMI32 }
    for y := fy1-1 to fy2+1-1 do
      for x := fx1-1 to fx2+1-1 do
        begin
          Buffer[z]:=SysReadCharAt(x,y);
          Inc(z);
          Buffer[z]:=Chr(SysReadAttributesAt(x,y));
          Inc(z);
        end;
    {$EndIf}
    {$EndIf}
    Next := NIL;
  end; { with Win^ }
  if Last = NIL then { no win open }
    Win^.Last := NIL { set last pointer to NIL }
  else
    Win^.Last := Last; { set last pointer to last open win }
  if CurrentWin = NIL then begin { first win }
    Root := Win; { set root pointer to this }
    Root^.Last := NIL; { set last pointer to NIL }
  end
  else
    CurrentWin^.Next := Win; { set next pointer to this win }
  Last := Win;
  CurrentWin := Win;
end; { SaveBackGround }

Procedure CWin;
{ closes the last opened win }
var Start,Len,y,z : LongInt;
    Win         : WinPtr;
    att         : Byte;
    {$IfDef WIN32}
    WasRead     : Longint;
    BufferSize,
    Coord       : TCoord;
    WriteRegion : TSmallRect;
    {$EndIf}
begin
  {$IfDef WIN32}
  SysTVInitCursor;
  {$EndIf}
  if CurrentWin = NIL then
    Exit;
  Dec(NumWin);
  Win := CurrentWin;
  with Win^ do begin
    Len := (x2-x1+2)*2;
    Start := 0;
    {$IfDef WIN32}
    BufferSize.x := (x2-x1+2);
    BufferSize.y := y2-y1+2;

    Coord.x := 0;
    Coord.y := 0;
    with WriteRegion do begin
      Left := x1-1;
      Top := y1-1;
      Right := x2;
      Bottom := y2;
    end;
    WriteConsoleOutput(SysConOut,@Buffer[Start],BufferSize,Coord,WriteRegion);
    {$Else}
    {$IfDef OS2}
    for y := y1 to y2+1 do begin // OS/2
      VioWrtCellStr(@Buffer[Start],Len,y-1,x1-1,0);
      inc(Start,Len);
    end;
    {$Else}
    for y := y1 to y2+1 do
      for z := x1 to x2+1 do
        begin
          SysWrtCharStrAtt(@Buffer[Start],1,z-1,y-1,Byte(Buffer[Start+1]));
          Inc(Start,2);
        end;
    {$EndIf}
    {$EndIf}
    FreeMem(Buffer{$IfNDef VirtualPascal},BSize{$EndIf});
  end; { with Win^ }
  CurrentWin^.Next := NIL;
  CurrentWin := CurrentWin^.Last;
  Dispose(win);
  dec(WinCounter);
  Last := CurrentWin;
  if Last = NIL then { last win closed, set startup window }
    Window(StartWinX1,StartWinY1,StartWinX2,StartWinY2)
  else begin { set the window }
    with CurrentWin^ do
      Window(x1+1,y1+1,x2-1,y2-1);
  end;
end; { CWin }

Procedure OWin(x1,y1,x2,y2,att : byte; Text : ShortString);
var s,s1,s2 : ShortString;
    Start,b,l : LongInt;
    p : pChar;
    c : Char;
begin
  if NumWin = 0 then begin { store original window size }
    StartWinX1 := Lo(WindMin)+1;
    StartWinY1 := Hi(WindMin)+1;
    StartWinX2 := Lo(WindMax)+1;
    StartWinY2 := Hi(WindMax)+1;
  end;

  inc(NumWin);
  Window(1,1,XMax,YMax); { set "fullscreen" window }
  SaveBackGround(x1,y1,x2,y2);
  TextAttr := att;
  Frame(3,x1,y1,x2,y2);

  l := x1+((x2-x1) div 2 - (Length(Text) div 2));
  WriteXY(l,y1,Text,att); { write win title }
  TextAttr := 7; { color of shadow }
  for b := x1 to x2 do begin  { lower shadow }
    c := SysReadCharAt(b,y2);
    SysWrtCharStrAtt(@c,1,b,y2,TextAttr);
  end;
  for b := y1 to y2 do begin  { right shadow }
    c := SysReadCharAt(x2,b);
    SysWrtCharStrAtt(@c,1,x2,b,TextAttr);
  end;
  Window(x1+1,y1+1,x2-1,y2-1); { set window with current win coordinates }
  TextAttr := att; { set the win color }
  ClrScr;
end; { OWin }

Procedure CloseAllWin;
{ closes all open win }
begin
  CurrentWin := Last;
  while WinCounter > 0 do
    CWin;
  Window(1,1,XMax,YMax);
end; { CloseAllWin }

Procedure OcWin(Width,Height,StartH,Color : byte; Text : ShortString);
{ opens a centered win, StartH usually = 0 }
var WinC : array[1..4] of Byte;
begin
  WinC[1] := (XMax div 2) - (Width div 2);
  WinC[3] := WinC[1] + Width;
  if StartH <> 0 then
    WinC[2] := StartH
  else
    WinC[2] := (YMax div 2) - (Height div 2);
  WinC[4] := WinC[2] + Height;
  OWin(WinC[1],WinC[2],WinC[3],WinC[4],Color,Text);
end; { OcWin }

Procedure invisibleWin;
  begin
    if WinCounter=0 then
      Exit;

    with CurrentWin^ do
      begin
        SaveBackGround(x1,y1,x2,y2);
        SaveBackGround(x1,y1,x2,y2);
        Move(Buffer^,CurrentWin^.Buffer^,BSize);
        CWin;
      end;
  end; { invisibleWin }

begin
  Root := NIL;
  Last := NIL;
  CurrentWin := NIL;
  NumWin := 0;
  XMax := Lo(WindMax)+1;
  YMax := Hi(WindMax)+1;
  {$IfDef WIN32}
  SysConOut := GetStdHandle(std_Output_Handle); { get the handle for std out }
  {$EndIf}
end.

