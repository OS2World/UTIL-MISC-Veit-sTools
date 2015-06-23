(* VpUtils.PAS fÅr BP7 * Veit Kannegieser 2000.05.28 *)

{$O+}

unit TpUtils; 


interface

procedure SetCursorSize(beginline,endline:integer);
function  GetCursorSize:word;
function  Max(const l1,l2:longint):longint;
function  Min(const l1,l2:longint):longint;
procedure SysBeepEx(const freq,dur:word);
function  Int2Hex(l:longint;z:byte):string;
function  Int2Str(const z:longint):string;

implementation

{do not use Crt}

procedure SetCursorSize(beginline,endline:integer);
  begin
    if beginline<0 then
      beginline:=-beginline*MemW[Seg0040:$0085] div 100;
    if endline<0 then
      endline:=-endline*MemW[Seg0040:$0085] div 100;
    asm
      mov ah,$01
      mov ch,byte ptr [beginline]
      mov cl,byte ptr [endline]
      int $10
    end;
  end;

function  GetCursorSize:word;assembler;
  asm
    mov ah,$03
    mov bh,0 (* Seite 0 *)
    int $10
    mov ax,cx
    and ax,$1f1f
  end;

function  Max(const l1,l2:longint):longint;
  begin
    if l1>l2 then
      Max:=l1
    else
      Max:=l2;
  end;

function  Min(const l1,l2:longint):longint;
  begin
    if l1<l2 then
      Min:=l1
    else
      Min:=l2;
  end;

procedure Sound(freq:word);assembler;
  asm
    mov ax,$34dd
    mov dx,$0012
    div freq

    push ax

    in al,$61
    or al,$03
    out $61,al

    mov al,(2 shl 6)+(3 shl  4)+(3 shl 1)+(0 shl 0)
    out $43,al

    pop ax

    out $42,al
    mov al,ah
    out $42,al

  end;

procedure Delay(dur:word);assembler;
  asm
    mov ax,1000
    mul dur
    mov cx,ax
    mov dx,ax
    mov ah,$86
    stc
    int $15
  end;

procedure NoSound;assembler;
  asm
    in al,$61
    and al,(not $03)       
    out $61,al
  end;

procedure SysBeepEx(const freq,dur:word);
  begin
    Sound(freq);
    Delay(dur);
    NoSound;
  end;

function  Int2Hex(l:longint;z:byte):string;
  const
    hex_ziffern:array[0..15] of char=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
  {$IfNDef VirtualPascal}
  var
    Result:string;
  {$EndIf}
  begin
    {$IfDef VirtualPascal}
    SetLength(Result,z);
    {$Else}
    Result[0]:=Chr(z);
    {$EndIf}
    while z>0 do
      begin
        Result[z]:=hex_ziffern[l and $f];
        l:=l shr 4;
        Dec(z);
      end;
    {$IfNDef VirtualPascal}
    Int2Hex:=Result;
    {$EndIf}
  end;

function Int2Str(const z:longint):string;
  {$IfNDef VirtualPascal}
  var
    Result:string;
  {$EndIf}
  begin
    System.Str(z,Result);
    {$IfNDef VirtualPascal}
    Int2Str:=Result;
    {$EndIf}
  end;


end.