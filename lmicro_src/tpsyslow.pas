(* VpSysLow fr BP 7 * 2000.05.25  Veit Kannegieser fr mywin.pas *)
{$G+}
{$O+}

unit TpSysLow;


interface

type
  smallword=word;

const
  open_access_ReadOnly  =$00;
  open_access_WriteOnly =$01;
  open_access_WReadrite =$02;

  open_share_DenyNone   =$40;

function SysReadAttributesAt(x,y: SmallWord): Byte;
function SysReadCharAt(x,y: SmallWord): Char;
procedure SysWrtCharStrAtt(CharStr: Pointer; Len,X,Y: SmallWord; var Attr: Byte);
procedure SetLength(var s:string;const len:byte);
function SysReadKey:char;
function SysKeyPressed:boolean;
function SysTVGetShiftState:byte;
procedure SysCtrlSleep(const l:longint);
function SysGetCodePage:word;

implementation

  
function SysGetTextVideoColumns:word;
  begin
    SysGetTextVideoColumns:=MemW[Seg0040:$004a];
  end;

function SysGetTextVideoRows:word;
  begin
    SysGetTextVideoRows:=MemW[Seg0040:$0084]+1;
  end;

function SysReadAttributesAt(x,y: SmallWord): Byte;
  begin
    SysReadAttributesAt:=Mem[SegB800:(SysGetTextVideoColumns*y+x)*2+1];
  end;

function SysReadCharAt(x,y: SmallWord): Char;
  begin
    SysReadCharAt:=Chr(Mem[SegB800:(SysGetTextVideoColumns*y+x)*2+0]);
  end;


procedure SysWrtCharStrAtt(CharStr: Pointer; Len,X,Y: SmallWord; var Attr: Byte);
  var
    quelle:^char absolute CharStr;
    ziel:^smallword;
  begin
    ziel:=Ptr(SegB800,(SysGetTextVideoColumns*y+x)*2);
    while Len>0 do
      begin
        ziel^:=Ord(quelle^)+Attr shl 8;
        Inc(quelle);
        Inc(ziel);
        Dec(Len);
      end;
  end;

procedure SetLength(var s:string;const len:byte);
  begin
    s[0]:=Chr(len);
  end;

const
  keybuffer:char=#0;
  
function SysReadKey:char;
  var
    ascii,scan:char;
  begin
    if keybuffer<>#0 then
      begin
        SysReadKey:=keybuffer;
        keybuffer:=#0;
      end
    else
      begin
        asm
          mov ah,$10
          int $16
          mov ascii,al
          mov scan,ah
        end;
        SysReadKey:=ascii;
        if ascii in [#$00,#$e0] then
          keybuffer:=scan;
      end;
  end;

function SysKeyPressed:boolean;assembler;
  asm
    mov al,true
    cmp keybuffer,0
    jne @ret

    mov ah,$11
    int $16
    mov al,true
    jnz @ret

    dec ax (* false *)

  @ret:
  end; 

function SysTVGetShiftState:byte;    
  begin
    SysTVGetShiftState:=Mem[Seg0040:$0017];
  end;

procedure SysCtrlSleep(const l:longint);assembler;
  asm
    mov cx,word ptr [l+2]
    mov dx,word ptr [l+0]
    (* cx:dx * 1024 *)
    mov ax,dx
    shl dx,10
    shr ax,(16-10)
    shl cx,10
    or cx,ax
    mov ah,$86
    int $15
  end;

function SysGetCodePage:word;assembler;
  asm
    mov ax,$6601
    int $21
    mov ax,bx
  end;

end.
