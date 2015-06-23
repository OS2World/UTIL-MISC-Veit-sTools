program svga_et4;
(* zusÑtzliche EintrÑge zu SVGADATA.PMI fÅr ET4000 *)

var
  pmi:text;
  bildschirm_modus:byte absolute $0040:$0049;

const
  svga_et4_mark='/* ADD BY SVGA_ET4/FONT20 */';

function hex(const b:byte):string;
  const
    hex_ziffer:array[0..15] of char='0123456789abcdef';
  begin
    hex:=hex_ziffer[b shr  4]
        +hex_ziffer[b and 15];
  end;

function lies_3c0(const index:byte):byte;
  var
    reset:byte;
  begin
    reset:=port[$3da];
    port[$3c0]:=index;
    lies_3c0:=port[$3c1];
    reset:=port[$3da];
    port[$3c0]:=$20;
  end;

function lies_3c4(const index:byte):byte;
  begin
    port[$3c4]:=index;
    lies_3c4:=port[$3c5];
  end;

function lies_3ce(const index:byte):byte;
  begin
    port[$3ce]:=index;
    lies_3ce:=port[$3cf];
  end;

function lies_3d4(const index:byte):byte;
  begin
    port[$3d4]:=index;
    lies_3d4:=port[$3d5];
  end;

procedure schreibe_modus_info;
  var
    z           :word;
    xcharsize   :word;
    pagesize    :word;

  begin
    if (lies_3c0($10) and (1 shl 2))=0 then
      xcharsize:=8
    else
      xcharsize:=9;

    WriteLn(pmi,'[comment]');
    if odd(lies_3c0(10)) then
      (* WriteLn(pmi,'        Graphics Mode: ')*) runerror(1)
    else
      WriteLn(pmi,'        Text Mode: ',memw[$0040:$004a],' cols, ',mem[$0040:$0084]+1,' rows.');
    WriteLn(pmi);
    WriteLn(pmi,'[ModeInfo]');
    WriteLn(pmi,'        ModeAttributes   = 0x08');
    WriteLn(pmi,'        BytesPerScanLine = ',memw[$0040:$004a]);
    WriteLn(pmi,'        XResolution      = ',memw[$0040:$004a]*xcharsize);
    WriteLn(pmi,'        YResolution      = ',word(mem[$0040:$0084]+1)*memw[$0040:$0085]);
    WriteLn(pmi,'        XCharSize        = ',xcharsize);
    WriteLn(pmi,'        YCharSize        = ',memw[$0040:$0085]);
    WriteLn(pmi,'        TextRows         = ',mem[$0040:$0084]+1);
    WriteLn(pmi,'        BitsPerPixel     = 4'); (* 16 Farben *)
    WriteLn(pmi,'        NumberOfPlanes   = 1'); (* Text ! *)
    (*
    pagesize:=memw[$0040:$004c];
    if pagesize<80*25*2 then
      pagesize:=80*25*2;*)
    pagesize:=memw[$0040:$004a]*word(mem[$0040:$0084]+1)*2;

    WriteLn(pmi,'        PageLength       = ',pagesize);
    WriteLn(pmi,'        SaveSize         = ',pagesize);
    WriteLn(pmi,'        TotalMemory      = ',1024*1024);
    WriteLn(pmi,'        InterlaceMode    = 1'); (* ? *)
    WriteLn(pmi,'        BufferAddress    = 0x000b8000');
    WriteLn(pmi,'        ApertureSize     = 0x00008000');
    WriteLn(pmi,'        Int10ModeSet     = 0x0'+hex(mem[$0040:$0049]));
    WriteLn(pmi,'        Colors           = 16');
    WriteLn(pmi);
    WriteLn(pmi,'[MonitorModeInfo]');
    WriteLn(pmi,'        VerticalRefresh         = 254');
    WriteLn(pmi,'        VPolarityPositive       = ',1-((port[$3cc] shr 7) and 1));
    WriteLn(pmi,'        HPolarityPositive       = ',1-((port[$3cc] shr 6) and 1));
    WriteLn(pmi);
    WriteLn(pmi,'[SetBank]');
    WriteLn(pmi,'SetBankLinear;');
    WriteLn(pmi);
    WriteLn(pmi,'[GetBank]');
    WriteLn(pmi,'GetBankLinear;');
    WriteLn(pmi);
    WriteLn(pmi,'[SetMode]');
    WriteLn(pmi);
    WriteLn(pmi,'/*');
    WriteLn(pmi,' *      Set Miscellaneous Output Register');
    WriteLn(pmi,' */');
    WriteLn(pmi);
    WriteLn(pmi,'outb(0x3c2, 0x',hex(port[$3cc]),');');
    WriteLn(pmi,'/*');
    WriteLn(pmi,' *      Set Other Registers');
    WriteLn(pmi,' */');
    WriteLn(pmi);
    WriteLn(pmi,'r0   = 0x00;');
    WriteLn(pmi,'boutb(1, 0x00, 0x3cd, 0x3cd);');
    WriteLn(pmi);
    WriteLn(pmi,'/*');
    WriteLn(pmi,' *      Set Sequencer Registers');
    WriteLn(pmi,' */');
    WriteLn(pmi);
    WriteLn(pmi,'r0   = 0x',hex(lies_3c4($00)),'; r1   = 0x',hex(lies_3c4($01)),'; r2   = 0x',hex(lies_3c4($02)),
                '; r3   = 0x',hex(lies_3c4($03)),'; r4   = 0x',hex(lies_3c4($04)),';');
    WriteLn(pmi,'boutb(5, 0x00, 0x3c4, 0x3c5);');
    WriteLn(pmi);
    WriteLn(pmi,'outw(0x3c4, 0x0300);');
    WriteLn(pmi,'r6   = 0x',hex(lies_3c4($06)),'; r7   = 0x',hex(lies_3c4($07)),';');
    WriteLn(pmi,'boutb(2, 0x06, 0x3c4, 0x3c5);');
    WriteLn(pmi);
    WriteLn(pmi,'/*');
    WriteLn(pmi,' *      Set CRT Registers');
    WriteLn(pmi,' */');
    WriteLn(pmi);
    WriteLn(pmi,'outb(0x3d4, 0x11);');
    WriteLn(pmi,'outb(0x3d5, 0x',hex(lies_3d4($11) and $7f),');');
    for z:=0 to 24 do
      begin
        Write(pmi,'r',z);
        if z<10 then Write(pmi,' ');
        Write(pmi,'  = 0x',hex(lies_3d4(z)),';');
        if (z mod 5)=4 then
          WriteLn(pmi)
        else
          Write(pmi,' ');
      end;
    WriteLn(pmi,'boutb(25, 0x00, 0x3d4, 0x3d5);');
    WriteLn(pmi);
    WriteLn(pmi,'r49  = 0x',hex(lies_3d4($31)),';');
    WriteLn(pmi,'boutb(1, 0x31, 0x3d4, 0x3d5);');
    WriteLn(pmi);
    WriteLn(pmi,'r52  = 0x',hex(lies_3d4($34)),'; r53  = 0x',hex(lies_3d4($35)),';');
    WriteLn(pmi,'boutb(2, 0x34, 0x3d4, 0x3d5);');
    WriteLn(pmi);
    WriteLn(pmi,'/*');
    WriteLn(pmi,' *      Set Attribute Registers');
    WriteLn(pmi,' */');
    WriteLn(pmi);
    for z:=0 to 20 do
      begin
        Write(pmi,'r',z);
        if z<10 then Write(pmi,' ');
        Write(pmi,'  = 0x',hex(lies_3c0(z)),';');
        if ((z mod 5)=4) or (z=20) then
          WriteLn(pmi)
        else
          Write(pmi,' ');
      end;
    WriteLn(pmi,'boutb(21, 0x00, 0x3c0, 0x3c1);');
    WriteLn(pmi);
    WriteLn(pmi,'r22  = 0x',hex(lies_3c0($16)),';');
    WriteLn(pmi,'boutb(1, 0x16, 0x3c0, 0x3c1);');
    WriteLn(pmi);
    WriteLn(pmi,'/*');
    WriteLn(pmi,' *      Set GDC Registers');
    WriteLn(pmi,' */');
    WriteLn(pmi);
    for z:=0 to 8 do
      begin
        Write(pmi,'r',z);
        if z<10 then Write(pmi,' ');
        Write(pmi,'  = 0x',hex(lies_3ce(z)),';');
        if ((z mod 5)=4) or (z=8) then
          WriteLn(pmi)
        else
          Write(pmi,' ');
      end;
    WriteLn(pmi,'boutb(9, 0x00, 0x3ce, 0x3cf);');
    WriteLn(pmi);
    WriteLn(pmi,'/*');
    WriteLn(pmi,' *      Set DAC Registers');
    WriteLn(pmi,' */');
    WriteLn(pmi);
    WriteLn(pmi,'ProgramDAC;');
    WriteLn(pmi,'inb(r0, 0x3da);');
    WriteLn(pmi,'outb(0x3c0, 0x20);');
    WriteLn(pmi);
  end;

var
  pmi_name:string;
  zeile:string;

begin
  if ParamCount=0 then
    begin
      pmi_name:='@:\OS2\BOOT\SVGADATA.PMI';
      asm
        (* Startlaufwerk *)
        mov ax,$3305
        int $21
        add byte ptr [pmi_name+1],dl
      end;
    end
  else
    pmi_name:=ParamStr(1);

  Assign(pmi,{'SVGADATA.ADD'}pmi_name);
  (*$I-*)
  Reset(pmi);
  (*$I+*)
  if ioresult<>0 then
    begin
      WriteLn('can not open file ',pmi_name,'.');
      WriteLn('be sure to call \OS2\SVGATMP.BAT before.');
      Halt(1);
    end;

  while not Eof(pmi) do
    begin
      ReadLn(pmi,zeile);
      if Pos(svga_et4_mark,zeile)<>0 then
        begin
          WriteLn('the file ',pmi_name,' is alredy modified.');
          Writeln('please give me a fresh file by calling SVGATMP.BAT again.');
          Halt(1);
        end;
    end;

  Append(pmi);
  WriteLn(pmi,svga_et4_mark);

{  (* Vergleichstest 80*25 *)
  asm
    mov ax,$0003
    int $10
  end;
  schreibe_modus_info;}


  (* 100*40 *)
  asm
    mov ax,$002a
    int $10
  end;
  if bildschirm_modus=$2a then
    schreibe_modus_info;


  (* 80*28 (25*20=500 aber 18*28=504, OS/2 macht daraus 17*28=476) *)
  asm
    mov ax,$0003
    int $10
    mov ax,$1111
    mov bl,0
    int $10
  end;
  schreibe_modus_info;

  (* 80*31 (16*31=496) *)
  asm
    push bp
      push es
        mov ax,$0003
        int $10
        mov ax,$1130
        mov bh,6        (* 8*16 *)
        int 010
        mov ax,$1110
        mov bx,16*$100+0
        mov cx,256
        mov dx,0
        int $10
      pop es
    pop bp
  end;
  schreibe_modus_info;
  
  (* 80*36 (14*36=504) *)
  asm
    push bp
      push es
        mov ax,$0003
        int $10
        mov ax,$1130
        mov bh,2        (* 8*14 *)
        int 010
        mov ax,$1110
        mov bx,14*$100+0
        mov cx,256
        mov dx,0
        int $10
      pop es
    pop bp
  end;
  schreibe_modus_info;  
  (* 80*63 (8*63=504) *)
  asm
    push bp
      push es
        mov ax,$0003
        int $10
        mov ax,$1130
        mov bh,3        (* 8*8 *)
        int $10
        mov ax,$1110
        mov bx,8*$100+0
        mov cx,256
        mov dx,0
        int $10
      pop es
    pop bp
  end;
  schreibe_modus_info;

  Close(pmi);

  asm
    mov ax,$0003
    int $10
  end;

end.
