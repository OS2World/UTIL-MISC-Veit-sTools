{&Use32+}
program display_VioModeInfo;
{&PMType NoVio}

uses
  HilfsFun,
  Os2Base,
  VpUtils;

var
  vmi                   :VioModeInfo;
  vfi                   :VioFontInfo;
  rc                    :word;
  work                  :^byte;
  b0,b1                 :byte;
  i,j,k                 :word;
  hwvres                :word;
  mc                    :byte;
  debug                 :boolean;

const
  charselect            ='0'; (* T,R *)
  pseudografik          :array[boolean,boolean] of char=((' ','Ü'),('ß','Û'));

begin
  debug:=ParamStr(1)='/debug';
  WriteLn('*** VioModeInfo ***   *** Hardware ***');
  FillChar(vmi,SizeOf(vmi),0);
  vmi.cb:=SizeOf(vmi);
  rc:=VioGetMode(vmi,0);
  if rc<>0 then
    Abbruch('VioGetMode:'+OS_error_message(rc),rc);

  with vmi do
    begin
      if debug then
        begin
          WriteLn('cb:             ',cb);
          WriteLn('fbType:         ',fbType);
          if Odd(fbType shr 0) then
            WriteLn('  not monochrome compatible')
          else
            WriteLn('  monochrome compatible');
         if Odd(fbType shr 1) then
            WriteLn('  graphics mode')
          else
            WriteLn('  text mode');
          if Odd(fbType shr 2) then
            WriteLn('  disable color burst')
          else
            WriteLn('  enable color burst');
          if Odd(fbType shr 3) then
            WriteLn('  native mode')
          else
            WriteLn('  vga compatible mode 0..13H');
        end; (* debug *)
      WriteLn('Color:          ',Color);
      if Color=0 then
        WriteLn('  monochrome (mode 7,7+,F)')
      else
        WriteLn('  ',1 shl Color,' colors');
      hwvres:=crtc($12)+(crtc($07) shl 7) and $100+(crtc($07) shl 3) and $200+1;
      mc:=Port[$3da];
      wait;
      Port[$3c0]:=$10 or $20;
      wait;
      mc:=Port[$3c1];
      wait;
      WriteLn('Col:           ',Col:4  ,crtc($01)+1:19);
      WriteLn('Row:           ',Row:4  ,hwvres div (crtc($09) and $1f+1):19);
      WriteLn('HRes:          ',HRes:4 ,(crtc($01)+1)*(8+((mc shr 2) and 1)):19);
      WriteLn('VRes:          ',VRes:4 ,hwvres:19);
      if debug then
         begin
           WriteLn('fmt_ID:         ',fmt_ID);
           WriteLn('Attrib:         ',Attrib);
           WriteLn('Buf_Addr:       ',Int2Hex(Buf_Addr,8));
           WriteLn('Buf_Length:     ',Int2Hex(Buf_Length,8));
           WriteLn('Full_Length:    ',Int2Hex(Full_Length,8));
           WriteLn('Partial_Length: ',Int2Hex(Partial_Length,8));
           WriteLn('Ext_Data_Addr:  ',Ptr2Hex(Ext_Data_Addr));
         end;
    end;

  WriteLn;
  WriteLn('*** VioFontInfo ***   *** Hardware ***');
  FillChar(vfi,SizeOf(vfi),0);
  with vfi do
    begin
      cb:=SizeOf(vfi);
      rType:=0; (* current ram font *)
      //rType:=1; (* rom font *)
    end;
  rc:=VioGetFont(vfi,0);
  if rc<>0 then
    begin
      WriteLn('VioGetFont:',OS_error_message(rc));
      Halt(rc);
    end;
  with vfi do
    begin
//    WriteLn('cb:             ',cb);
//    WriteLn('rType:          ',rType);
      WriteLn('cxCell:         ',cxCell:3,8+((mc shr 2) and 1):19);
      WriteLn('cyCell:         ',cyCell:3,crtc($09) and $1f+1:19);
//    WriteLn('pbData:         ',Ptr2Hex(pbData));
//    WriteLn('cbData:         ',Int2Hex(cbData,8));
      if cbData>0 then
        begin
          work:=pbData;
          SelToFlat(Pointer(work));
          Inc(work,cyCell*Ord(charselect));
          //for i:=0 to 255 do
          for i:=Ord(charselect) to Ord(charselect) do
            begin
              Write(' Char #$',Int2Hex(i,2));
              if i in [$20..$7e] then Write(' '#39,Chr(i),#39);
              WriteLn;
              for j:=1 to cyCell do
                begin
                  if not Odd(j) then Continue;
                  Write('    |');
                  b0:=work^;
                  Inc(work);
                  if j<cyCell then
                    begin
                      b1:=work^;
                      Inc(work);
                    end
                  else
                    b1:=0;

                  for k:=0 to 7 do
                    Write(pseudografik[Odd(b0 shr (7-k)),Odd(b1 shr (7-k))]);

                  WriteLn('|');

                end;
            end;
        end;
    end;

end.

