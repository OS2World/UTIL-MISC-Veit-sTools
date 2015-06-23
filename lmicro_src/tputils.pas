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

uses
  Crt;

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

procedure SysBeepEx(const freq,dur:word);
  begin
    Sound(freq);
    Delay(dur);
    NoSound;
  end;

function  Int2Hex(l:longint;z:byte):string;
  const
    hex_ziffern:array[0..15] of char=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
  var
    tmp:string;
  begin
    tmp:='';
    while (l>0) or (z>0) do
      begin
        Insert(hex_ziffern[l and $f],tmp,1);
        l:=l shr 4;
        Dec(z);
      end;
    Int2Hex:=tmp;
  end;

function Int2Str(const z:longint):string;
  var
    tmp:string;
  begin
    system.str(z,tmp);
    Int2Str:=tmp;
  end;


end.