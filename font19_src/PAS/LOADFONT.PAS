{&Use32+}
program loadfont;

uses
  {$IfDef Os2}
  Os2Base,
  {$EndIf}
  HilfsFun;

var
  {$IfDef Os2}
  fd                    :VioFontInfo;
  {$EndIf}
  font                  :array[0..32*256-1] of byte;
  l                     :longint;
  f                     :file;
  fn                    :string;

begin
  fn:=ParamStr(1);
  if (ParamCount<>1) or (fn='/?') or (fn='-?') then
    begin
      WriteLn('Usage: LOADFONT filename');
      Halt(1);
    end;

  Assign(f,fn);
  FileMode:=$40;
  {$I-}
  Reset(f,1);
  {$I+}
  Fehlerbehandlung('Can not load font file.',IOResult);
  l:=FileSize(f);
  if ((l and $ff)<>0) or (l<$400) or (l>SizeOf(font)) then
    Abbruch('Invalid filesize: must be CellHeigth*256, and CellHeigth in [4..32]',1);
  BlockRead(f,font,l);
  Close(f);

  {$IfDef Os2}
  FillChar(fd,SizeOf(fd),0);
  with fd do
    begin
      cb:=SizeOf(fd);
      rType:=0;
      cxCell:= 9;
      cyCell:=l div $100;
      if cyCell<=8 then cxCell:=8;
      pbdata:=@font;
      FlatToSel(pbdata);
      cbdata:=SizeOf(font);
    end;

  Fehlerbehandlung('VioSetFont',VioSetFont(fd,0));

  {$Else}
  asm
    mov ax,$1110
    mov bx,Word Ptr [l] (* BH=Y *)
    mov bl,0            (* BL=table 0 *)
    mov cx,256
    mov dx,0
    push ds
    pop es
    push bp
      mov bp,Offset font
      int $10
    pop bp
  end;
  {$EndIf}

end.

