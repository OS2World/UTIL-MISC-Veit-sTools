program os2_font_extractor;
(*$X+*)
(*&USE32-*)
(*&PMTYPE NOVIO*)
(*$D extract raw font from OS/2 font*)

(* usage: OS2FNT_X <file.fon> <file.fn8> <codepage> *)

(*$IFDEF VirtualPascal*)
uses
(*$IFDEF OS2*)
  OS2Def,OS2Base,
(*$ENDIF*)
  VpSysLow;
(*$ENDIF*)

type
  mono_vgamem=array[0..640*480 div 8-1] of byte;

var
  d1,d2:file;

  kopf:
    packed record
      sig0:longint;
      sig1:longint;
      sig2:array[1..9] of char;
      xxx1:array[$11..$71] of byte;
      breite:word;
      xxx2:array[$74..$75] of byte;
      hoehe:word;
    end;

  zeichen_zeiger:
    packed record
      dateiposition:longint;
      breite:word;
    end;

  zeichen,z2:longint;

  puffer:array[0..31] of byte;

  vio_buffer:^mono_vgamem;
  (*$IFDEF OS2*)
  vio_size:smallword;
  (*$ENDIF*)

type
  codepage_index=array[0..255] of word;

const
  anzeigebreite=32;
  hexzeichen:array[0..15] of word=(
    ord('0'),ord('1'),ord('2'),ord('3'),
    ord('4'),ord('5'),ord('6'),ord('7'),
    ord('8'),ord('9'),ord('a'),ord('b'),
    ord('c'),ord('d'),ord('e'),ord('f'));

  index_850:codepage_index=
    ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,
     $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,
     $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,
     $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,
     $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,
     $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,
     $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,
     $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,
     $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,
     $90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,
     $a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,
     $b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf,
     $c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,
     $d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,
     $e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,
     $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff);

  index_uuu1:codepage_index= (* mit akzenten *)
    ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,
     $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,
     $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,
     $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,
     $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,
     $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,
     $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,
     $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,
     $100,$101,$102,$103,$104,$105,$106,$107,$108,$109,$10a,$10b,$10c,$10d,$10e,$10f,
     $110,$111,$112,$113,$114,$115,$116,$117,$118,$119,$11a,$11b,$11c,$11d,$11e,$11f,
     $120,$121,$122,$123,$124,$125,$126,$127,$128,$129,$12a,$12b,$12c,$12d,$12e,$12f,
     $130,$131,$132,$133,$134,$135,$136,$137,$138,$139,$13a,$13b,$13c,$13d,$13e,$13f,
     $140,$141,$142,$143,$144,$145,$146,$147,$148,$149,$14a,$14b,$14c,$14d,$14e,$14f,
     $150,$151,$152,$153,$154,$155,$156,$157,$158,$159,$15a,$15b,$15c,$15d,$15e,$15f,
     $160,$161,$162,$163,$164,$165,$166,$167,$168,$169,$16a,$16b,$16c,$16d,$16e,$16f,
     $170,$171,$172,$173,$174,$175,$176,$177,$178,$179,$17a,$17b,$17c,$17d,$17e,$17f);

  index_437:codepage_index=
    ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,
     $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,
     $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,
     $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,
     $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,
     $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,
     $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,
     $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,
     $080,$081,$082,$083,$084,$085,$086,$087,$088,$089,$08a,$08b,$08c,$08d,$08e,$08f,
     $090,$091,$092,$093,$094,$095,$096,$097,$098,$099,$09a,$0BD,$09c,$0BE,$100,$09f,
     $0a0,$0a1,$0a2,$0a3,$0a4,$0a5,$0a6,$0a7,$0a8,$101,$0aa,$0ab,$0ac,$0ad,$0ae,$0af,
     $0b0,$0b1,$0b2,$0b3,$0b4,$102,$103,$104,$105,$0b9,$0ba,$0bb,$0bc,$106,$107,$0bf,
     $0c0,$0c1,$0c2,$0c3,$0c4,$0c5,$108,$109,$0c8,$0c9,$0ca,$0cb,$0cc,$0cd,$0ce,$10a,
     $10b,$10c,$10d,$10e,$10f,$110,$111,$112,$113,$0d9,$0da,$0db,$0dc,$114,$115,$0df,
     $116,$0e1,$117,$118,$119,$11a,$0e6,$11b,$11c,$11d,$11e,$11f,$120,$121,$122,$123,
     $124,$0f1,$125,$126,$127,$128,$0f6,$129,$0f8,$12a,$0fa,$12b,$12c,$0fd,$0fe,$000);

var
  cp:^codepage_index;
  cp_num:word;
  kontrolle:(*$IFDEF VirtualPascal*)longint(*$ELSE*)integer(*$ENDIF*);

procedure abbruch(const zk:string);
  begin
    WriteLn(zk);
    Halt(1);
  end;

procedure grafik_anzeige(const x,y:word;const zeichen:word);
  var
    z2:word;
  begin
    Seek(d1,$d2+zeichen*SizeOf(zeichen_zeiger));
    BlockRead(d1,zeichen_zeiger,SizeOf(zeichen_zeiger));
    if (zeichen_zeiger.dateiposition=0) then
      FillChar(puffer,SizeOf(puffer),0)
    else
      begin
        Seek(d1,zeichen_zeiger.dateiposition);
        BlockRead(d1,puffer,kopf.hoehe);
      end;


    for z2:=0 to kopf.hoehe-1 do
      vio_buffer^[x+(y*kopf.hoehe+z2)*(640 div 8)]:=puffer[z2];
  end;

(*$IFDEF OS2*)
var
  vmi  :^VioModeInfo;
  vmi_ :array[1..2] of VioModeInfo;
  pbuf :^VioPhysBuf;
  pbuf_:array[1..2] of VioPhysBuf;
(*$ENDIF*)

begin
  Assign(d1,ParamStr(1));
  Reset(d1,1);
  BlockRead(d1,kopf,SizeOf(kopf));
  if (kopf.sig0<>-2)
  or (kopf.sig1<>20)
  or (kopf.sig2<>'OS/2 FONT')
   then
    begin
      Close(d1);
      abbruch('::kein OS/2 FONT');
    end;

  if not (kopf.breite in [8{,9}]) then
    begin
      Close(d1);
      abbruch('::Schriftbreite nicht 8 oder 9');
    end;

  if ParamCount=1 then
    begin
      (*$IFDEF VirtualPascal*)

        (*$IFDEF OS2*)
        if ((Ofs(vmi_[1])+SizeOf(vmi_[1])) and $0000ffff)>=SizeOf(vmi_[1]) then
          vmi:=@vmi_[1]
        else
          vmi:=@vmi_[2];

        if ((Ofs(pbuf_[1])+SizeOf(pbuf_[1])) and $0000ffff)>=SizeOf(pbuf_[1]) then
          pbuf:=@pbuf_[1]
        else
          pbuf:=@pbuf_[2];

        with vmi^ do
          begin
            cb:=Ofs(fmt_ID)-Ofs(cb);
            fbType:=vgmt_Other+vgmt_Graphics;
            Color:=1;
            Col:=80;
            Row:=30;
            HRes:=640;
            VRes:=480;
          end;
        if VioSetMode(vmi^,0)<>0 then
          RunError(162);

        pbuf^.pBuf:=Ptr($a0000);
        pbuf^.cb  :=640*480 div 8;
        pbuf^.Sel :=0;
        VioGetPhysBuf(pbuf^,0);
        vio_buffer:=Ptr(pbuf^.Sel shl 16);
        SelToFlat(Pointer(vio_buffer));
        FillChar(vio_buffer^,SizeOf(vio_buffer^),0);
        (*$ENDIF*)

        (*$IFDEF DPMI32*)
        asm
          mov ax,$0011
          int $10
        end;
        vio_buffer:=Ptr(SegA000);
        (*$ENDIF*)

      (*$ELSE*)
        asm
          mov ax,$0011
          int $10
        end;
        vio_buffer:=Ptr(SegA000,0);
      (*$ENDIF*)

      for zeichen:=$00 to $1f do
        begin
          grafik_anzeige(4+0,zeichen,hexzeichen[ zeichen shr 4]       );
          grafik_anzeige(4+1,zeichen,hexzeichen[(zeichen shr 0) and $f]);
          grafik_anzeige(4+2,zeichen,hexzeichen[0                     ]);
        end;

      for zeichen:=0 to $1f7 do
        begin
          grafik_anzeige(10+(zeichen mod 16),(zeichen div 16),zeichen);
        end;

      for zeichen:=0 to $ff do
        begin
          grafik_anzeige(30+(zeichen mod 16),(zeichen div 16),index_437[zeichen]);
        end;

      (*$IFDEF VirtualPascal*)
      SysReadKey;
      SysTvSetScrMode(3);
      (*$ELSE*)
      asm
        mov ah,$00
        int $16
        mov ax,$0003
        int $10
      end;
      (*$ENDIF*)
      exit;
    end;


  Assign(d2,ParamStr(2));
  Rewrite(d2,1);

  cp_num:=437;
  if ParamCount=3 then
    Val(ParamStr(3),cp_num,kontrolle);

  case cp_num of
    437:cp:=@index_437;
    850:cp:=@index_850;
  else
     WriteLn('please implement that code page in OS2FNT_X.PAS :)');
     ReadLn;
     Halt(255);
  end;

  for zeichen:=0 to 255 do
    begin
      Seek(d1,$d2+cp^[zeichen]*SizeOf(zeichen_zeiger));
      BlockRead(d1,zeichen_zeiger,SizeOf(zeichen_zeiger));
      if (zeichen_zeiger.dateiposition=0) then
        FillChar(puffer,SizeOf(puffer),0)
      else
        begin
          Seek(d1,zeichen_zeiger.dateiposition);
          BlockRead(d1,puffer,kopf.hoehe);
        end;
      BlockWrite(d2,puffer,kopf.hoehe);
    end;

  Close(d1);
  Close(d2);

end.
