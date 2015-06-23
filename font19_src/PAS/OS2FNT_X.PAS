{&Use32+}{$X+}
program os2_font_extractor;
// {&PMTYPE NoVio}
{&PMTYPE Vio}
(* usage: OS2FNT_X <file.fon> <file.fn8> <codepage> *)

(* 1999.08.09? VK *)
(* 2004.04.24 \ddk\video\rel\os2c\include\base\os2\pmfont.h *)
(*            uniapi *)


(*$IFDEF VirtualPascal*)
uses
  HilfsFun,
  PMFont,
(*$IFDEF OS2*)
  Strings,
  UniDef,
  UniApi,
  OS2Def,OS2Base,
(*$ENDIF*)
  Objects,
  VpUtils,
  VpSysLow;
(*$ENDIF*)

//(*$I OS2UGL.INC*)

type
  mono_vgamem           =array[0..640*480 div 8-1] of byte;
  os2_ugl               =0..$5ff; (* vermutlich <$5ff *)

var
  d1,d2                 :file;

  vio_buffer            :^mono_vgamem;
  (*$IFDEF OS2*)
  vio_size              :smallword;
  (*$ENDIF*)

  FirstChar             :smallint;
  LastChar              :smallint;
  DefaultChar           :smallint;
  BreakChar             :smallint;

  max_yCellHeight       :smallint;
  os2_ugl_font          :array[os2_ugl] of array[0..31] of byte;
  result_font           :array[char] of array[0..31] of byte;
  result_font_set       :array[char] of boolean;

const
  tabellenspalten       :word=$40;

procedure grafik_anzeige(const x,y:word;zeichen:smallint);
  var
    z2                  :word;
  begin
    if (zeichen<FirstChar) or (zeichen>LastChar) then
      zeichen:=DefaultChar;
    if (zeichen>=FirstChar) and (zeichen<=LastChar) then
      for z2:=0 to max_yCellHeight-1 do
        if y*max_yCellHeight+z2<480 then
          vio_buffer^[x+(y*max_yCellHeight+z2)*(640 div 8)]:=os2_ugl_font[zeichen][z2];
  end;

procedure grafik_anzeige_zk(const x,y:word;const zk:string);
  var
    z1                  :word;
  begin
    for z1:=1 to Length(zk) do
      if x+z1-1<80 then
        grafik_anzeige(x+z1-1,y,Ord(zk[z1]));
  end;
(*$IFDEF OS2*)
var
  vmi  :^VioModeInfo;
  vmi_ :array[1..2] of VioModeInfo;
  pbuf :^VioPhysBuf;
  pbuf_:array[1..2] of VioPhysBuf;
(*$ENDIF*)

var
  target_cpname         :pUniCharArray;
  target_unicode        :UconvObject;
  unicode_os2ugl        :UconvObject;
  i                     :Char;
  u                     :SmallWord;
  cpbuf                 :PChar;
  rc                    :longint;
  uc                    :UniChar;
  ucsbuf                :pUniCharArray;
  input_remain,
  output_remain,
  gleich                :size_t;
  ugl,ugl2              :SmallWord;
  codepage_to_os2ugl    :array[char] of SmallWord;
//os2ugl_to_codepage    :array[Low(os2ugl_to_unicode_map)..High(os2ugl_to_unicode_map)] of Char;
  os2ugl_to_codepage    :array[smallword] of Char;

  l                     :longint;
  os2font               :pByteArray;
  os2font_bufpos        :longint;


  codepoint             :SmallWord;
  off                   :longint;
  char_data             :longint;
  char_xCellWidth,
  char_yCellHeight,
  char_xCellIncrement,
  char_xCellA,
  char_xCellB,
  char_xCellC,
  char_pCellBaseOffset  :smallint;

  zeichen               :smallint;

  para1,para2,para3     :string;

begin
  max_yCellHeight:=0;
  FillChar(os2_ugl_font,SizeOf(os2_ugl_font),0);
  FillChar(result_font,SizeOf(result_font),0);
  FillChar(result_font_set,SizeOf(result_font_set),false);

  para1:=ParamStr(1);{$IfDef Debug}para1:='c:\v\font19\font19.vk\VIO_8_18.FON';{$EndIf}
  para2:=ParamStr(2);{$IfDef Debug}para2:='-';{$EndIf}
  para3:=ParamStr(3);//{$IfDef Debug}para3:='850';{$EndIf}

  if (ParamCount<1) or (ParamCount>3) or (para1='/?') or (para1='-?') then
    begin
      WriteLn('Usage: OS2FNT_X OS/2-font-filename [ output-filename [ output-codepage ]]');
      WriteLn;
      WriteLn('       If no output file name is given, the font is displayed on screen.');
      WriteLn('       If no codepage is specified, assumes current.');
      WriteLn;
      WriteLn('Examples:');
      WriteLn('   OS2FNT_X VIO_8_18.FON - 437');
      WriteLn('     displays subset of font in codepage 437');
      WriteLn;
      WriteLn('   OS2FNT_X VIO_8_18.FON 00437_18.FN8 437');
      WriteLn('     saves raw font file for use in codepage 437');
      Halt(1);
    end;


  if para3='' then
    para3:=Int2Str(SysGetCodePage);

  para3:='IBM-'+para3+'@map=display,subchar=\x00';

  target_cpname:=UniStringToUcs(para3+#0);
  rc:=UniCreateUconvObject(target_cpname^,target_unicode);
  FreeUniCharArray(target_cpname^);
  if rc<>0 then
    Abbruch('Call to UniCreateUconvObject('+para3+') failed, rc=$'+Int2Hex(rc,8)+'.',1);


  target_cpname:=UniStringToUcs('os2ugl@map=display'#0);
  rc:=UniCreateUconvObject(target_cpname^,unicode_os2ugl);
  FreeUniCharArray(target_cpname^);
  if rc<>0 then
    Abbruch('Call to UniCreateUconvObject(OS2UGL@map=display) failed, rc=$'+Int2Hex(rc,8)+'.',1);



  //FillChar(os2ugl_to_codepage,SizeOf(os2ugl_to_codepage),#0);

  // 1.1 Versuche fÅr alle Unicode-Nummern in os2ugl_to_unicode_map das
  //     Zeichen in die Codeseite umzuwandeln
  //      Ergebnis: os2ugl_to_codepage[UGL-codepoint]:Chr(0..255)
  for ugl:=Low(os2ugl_to_codepage) to High(os2ugl_to_codepage) do
    begin

      ugl2:=ugl;
      cpbuf:=@ugl2;
      input_remain:=2;
      ucsbuf:=@uc;
      output_remain:=1;
      rc:=UniUconvToUcs(unicode_os2ugl,cpbuf,input_remain,ucsbuf,output_remain,gleich);
      if rc<>0 then
        RunError(rc);
      if (input_remain<>0) or (output_remain<>0) or (gleich<>0) then
        uc:=$fffd;

      ucsbuf:=@uc;
      input_remain:=1;
      os2ugl_to_codepage[ugl]:=#0;
      cpbuf:=@os2ugl_to_codepage[ugl];
      output_remain:=1;
      rc:=UniUconvFromUcs(target_unicode,ucsbuf,input_remain,cpbuf,output_remain,gleich);
      if rc<>0 then
        RunError(rc);
      if (input_remain<>0) or (output_remain<>0) or (gleich<>0) then (* clear $7f *)
        os2ugl_to_codepage[ugl]:=#0;
    end;

  // 1.2 Suche Chr(0..255) -> OS/2 UGL-codepoint
  for i:=Low(codepage_to_os2ugl) to High(codepage_to_os2ugl) do
    begin
      ugl:=$fffd;
      for ugl2:=Low(os2ugl_to_codepage) to High(os2ugl_to_codepage) do
        if os2ugl_to_codepage[ugl2]=i then
          begin
            ugl:=ugl2;
            Break; (* bullet #7 und nicht #511 finden *)
          end;
      codepage_to_os2ugl[i]:=ugl;
    end;

  // 2. fÅr alle ungelîsten FÑlle (850: #$14/#$15)
  //    Suche Chr(0..255) -> OS/2 UGL-codepoint
  for i:=Low(codepage_to_os2ugl) to High(codepage_to_os2ugl) do
    if codepage_to_os2ugl[i]=$fffd then
      begin
        // 2.1 Codeseite->Unicode
        cpbuf:=@i;
        input_remain:=1;
        uc:=$fffd;
        ucsbuf:=@uc;
        output_remain:=1;
        gleich:=0;
        rc:=UniUconvToUcs(target_unicode,cpbuf,input_remain,ucsbuf,output_remain,gleich);
        if rc<>0 then Abbruch('Error determining unicode number of #'+Int2Str(Ord(i))+'.',rc);
        if (output_remain<>0) or (gleich<>0) then
          uc:=$fffd;

        // 2.2 Unicode -> OS/2 universal glyph
        if uc=0 then
          ugl:=0
        else
          begin
            ucsbuf:=@uc;
            input_remain:=1;
            cpbuf:=@ugl;
            output_remain:=SizeOf(ugl);
            gleich:=0;
            rc:=UniUconvFromUcs(unicode_os2ugl,ucsbuf,input_remain,cpbuf,output_remain,gleich);
            if rc<>0 then Abbruch('Error determining OS/2 glyph # of Unicode &#'+Int2Str(uc)+'!',rc);
            if (input_remain<>0) or (output_remain<>0) or (gleich<>0) then
              ugl:=$fffd;
          end;

        codepage_to_os2ugl[i]:=ugl;

      end;

  UniFreeUconvObject(target_unicode);
  UniFreeUconvObject(unicode_os2ugl);


  (* Schriftart laden und verarbeiten *)

  Assign(d1,para1);
  FileMode:=$40;
  {$I-}
  Reset(d1,1);
  {$I+}
  rc:=IOResult;
  if rc<>0 then
    Abbruch('Can not open font file: '+OS_error_message(rc),rc);
  l:=FileSize(d1);
  GetMem(os2font,l);
  BlockRead(d1,os2font^,l);
  Close(d1);

  if l<SizeOf(FONTSIGNATURE) then
    Abbruch('Input file is not an OS/2 font file.',1);

  os2font_bufpos:=0;
  repeat
    with FONTSIGNATURE(os2font^[os2font_bufpos]) do
      begin
        if (ulSize<8) or (ulSize>l) then
          Abbruch('Bad ulSize in OS2FONT header.',1);
        case ulIdentity of
          FONT_SIGNATURE: (* header start *)
            begin
              //WriteLn('"',achSignature,'"');
            end;

          FONT_METRICS: (* metrics *)
            with FONTFILEMETRICS(os2font^[os2font_bufpos]) do
              begin
                //WriteLn('"',szFamilyname,'": "',szFacename,'"');
                if usCodePage<>850 then
                  Abbruch('Codepage<>850, can not assume OS2 UGL.',1);
                FirstChar:=usFirstChar;
                LastChar:=FirstChar+usLastChar;
                DefaultChar:=FirstChar+usDefaultChar;
                BreakChar:=FirstChar+usBreakChar;
              end;

          FONT_DEFINITION: (* definition *)
            with FONTDEFINITIONHEADER(os2font^[os2font_bufpos]) do
              begin
                char_data:=0;
                char_yCellHeight:=yCellHeight;
                char_xCellIncrement:=xCellIncrement;
                char_xCellA:=xCellA;
                char_xCellB:=xCellB;
                char_xCellC:=xCellC;
                char_pCellBaseOffset:=pCellBaseOffset;

                off:=Ofs(os2font^)+os2font_bufpos+SizeOf(FONTDEFINITIONHEADER);
                if ((fsFontdef=FONTDEFFONT1) and (fsChardef=FONTDEFCHAR1) and (usCellSize= 6))
                or ((fsFontdef=FONTDEFFONT2) and (fsChardef=FONTDEFCHAR2) and (usCellSize= 6))
                or ((fsFontdef=FONTDEFFONT3) and (fsChardef=FONTDEFCHAR3) and (usCellSize=10)) then
                  for codepoint:=FirstChar to LastChar do
                    begin
                      if Odd(FsChardef shr 7) then
                        begin
                          char_data:=MemL[off]; (* =0 fÅr leer *)
                          Inc(off,4);
                        end;
                      if Odd(FsChardef shr 0) then
                        begin
                          char_xCellWidth:=MemW[off];
                          Inc(off,2);
                        end;
                      if Odd(FsChardef shr 1) then
                        begin
                          char_yCellHeight:=MemW[off];
                          Inc(off,2);
                        end;
                      if Odd(FsChardef shr 2) then
                        begin
                          char_xCellIncrement:=MemW[off];
                          Inc(off,2);
                        end;
                      if Odd(FsChardef shr 3) then
                        begin
                          char_xCellA:=MemW[off];
                          Inc(off,2);
                        end;
                      if Odd(FsChardef shr 4) then
                        begin
                          char_xCellB:=MemW[off];
                          Inc(off,2);
                        end;
                      if Odd(FsChardef shr 5) then
                        begin
                          char_xCellC:=MemW[off];
                          Inc(off,2);
                        end;
                      if Odd(FsChardef shr 6) then
                        begin
                          char_pCellBaseOffset:=MemW[off];
                          Inc(off,2);
                        end;

                      if  (char_xCellWidth*char_yCellHeight>0)
                      and (char_data>0) then
                        begin
                          if char_xCellWidth<>8 then
                            Abbruch('Sorry, need xCellWidth=8, found '+Int2Str(char_xCellWidth)+'!',1);
                          if (char_yCellHeight<4) or (char_yCellHeight>32) then
                            Abbruch('Sorry, yCellHeight='+Int2Str(char_yCellHeight)+' is not useable for textmode font!',1);

                          max_yCellHeight:=Max(max_yCellHeight,char_yCellHeight);

                          Move(os2font^[char_data],os2_ugl_font[codepoint],char_yCellHeight);
                          for i:=Low(result_font) to High(result_font) do
                            if codepage_to_os2ugl[i]=codepoint then
                              begin
                                Move(os2font^[char_data],result_font[i],char_yCellHeight);
                                result_font_set[i]:=true;
                                //Write('.');
                              end;
                        end;
                    end
                else
                  Abbruch('Wrong Font Type (not FONTDEFFONT123/FONTDEFCHAR123)!',1);

              end;

          FONT_KERNPAIRS: (* Kern Pairs *)
            ;
          FONT_ADDITIONALMETRICS: (* Additional Metrics *)
            ;
          FONT_ENDRECORD: (* record end *)
            ;
        else
          WriteLn('Unknown OS2FONT header type (',Int2Hex(ulIdentity,8),'), skipped.');
        end;
        Inc(os2font_bufpos,ulSize);
      end;
  until os2font_bufpos>=l;


  (* alle nicht bekannten Zeichen markieren *)
  if (DefaultChar>=FirstChar) and (DefaultChar<=LastChar) then
    for i:=Low(result_font) to High(result_font) do
      if not result_font_set[i] then
        if (codepage_to_os2ugl[i] and $ff00)=$ff00 then (* Unicode-Ergebnis*)
          begin
            Move(os2_ugl_font[DefaultChar],result_font[i],char_yCellHeight);
            result_font_set[i]:=true;
            //Write('?');
          end;


  (* Ergebnis anzeigen *)

  if (para2='')
  or (para2='-') then
    begin
      (*$IFDEF VirtualPascal*)

        (*$IFDEF OS2*)
        if SysCtrlSelfAppType>1 then
          Abbruch('Can not display graphics when not run fullscreen!',1);

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

      if ParamStr(3)='' then
        begin
          tabellenspalten:=$10;
          while (tabellenspalten<$40)
            and (((LastChar+tabellenspalten-1) div tabellenspalten)*max_yCellHeight>=480) do
              tabellenspalten:=tabellenspalten*2;
          for zeichen:=0 to LastChar do
            begin
              if (zeichen mod tabellenspalten)=0 then
                grafik_anzeige_zk(4,zeichen div tabellenspalten,Int2Hex(zeichen,3));
              grafik_anzeige(10+(zeichen mod tabellenspalten),(zeichen div tabellenspalten),zeichen);
            end;
        end
      else
        begin
          tabellenspalten:=$10;
          for zeichen:=0 to $ff do
            begin
              if (zeichen mod tabellenspalten)=0 then
                grafik_anzeige_zk(4,zeichen div tabellenspalten,Int2Hex(zeichen,3));
              grafik_anzeige(10+(zeichen mod tabellenspalten),(zeichen div tabellenspalten),codepage_to_os2ugl[Chr(zeichen)]);
            end;
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
      Exit;
    end;

  (* Ergebnis speichern *)

  Assign(d2,para2);
  Rewrite(d2,1);

  for i:=Low(result_font) to High(result_font) do
    BlockWrite(d2,result_font[i],max_yCellHeight);

  Close(d2);

end.
