{&Use32+}
unit p_vga_u;

interface

procedure patch_bvhvga_tabellen(stumm:boolean;ParamCount:word;para1:string);

implementation


Uses
  Objects,
  hilfsfun,
  Os2Def,
  Os2Base,
  Strings;

const
  attributes_mode3:array[$00..$13] of byte=($00,$01,$02,$03,$04,$05,$14,$07, $38,$39,$3a,$3b,$3c,$3d,$3e,$3f, $0c,$00,$0f,$08);
  attributes_mode7:array[$00..$13] of byte=($00,$08,$08,$08,$08,$08,$18,$10, $18,$18,$18,$18,$18,$18,$18,$18, $0e,$00,$0f,$08);
  graphics_mode3:array[$00..$08] of byte=($00,$00,$00,$00,$00,$10,$0e,$00,$ff);
  graphics_mode7:array[$00..$08] of byte=($00,$00,$00,$00,$00,$10,$0a,$00,$ff);

procedure patch_bvhvga_tabellen(stumm:boolean;ParamCount:word;para1:string);

// VDH.H
type
  REGDATA               =
    packed record
      DataArea          :Pointer; (* 16:16 *)
      FirstEntry        :SmallWord;
      NumEntries        :SmallWord;
    end;

  REGCMD                =
    packed record
      Command           :Byte;
      RegData           :REGDATA;
    end;

  VioModeInfo = record
    cb:         SmallWord;      // Size of this structure
    fbType:     Byte;           // 8-bit mask identifying the mode
    Color:      Byte;           // Colors available. Power of 2 (1=2,2=4,4=16)
    Col:        SmallWord;      // Number of text character columns
    Row:        SmallWord;      // Number of text character rows
    HRes:       SmallWord;      // Display width in pixels
    VRes:       SmallWord;      // Display height in pixels
    fmt_ID:     Byte;           // Format of the attributes
    Attrib:     Byte;           // Number of attributes in the attribfmt field
  //Buf_Addr:   ULong;          // Address of the phisical display buffer
  //Buf_Length: ULong;          // Length of the phisical display buffer
  //Full_Length: ULong;         // Size of the buffer to save entire phis. buf.
  //Partial_Length: ULong;      // Size of the buffer to save part of the phis. buf. overwritten by VioPopup
  //Ext_Data_Addr: Pointer;     // Address of an extended-mode structure

    MemMap      :Byte;          // Index in memory map table
    ROMFontIndex:Byte;          // Index in ROM font table
    Flags       :Byte;

    CompRegs    :array[1..4] of Byte; // Unique mode-identifying registers: MiscOut, Att10, Att12, Seq01
                // Att10=mode control register: bit3:blink bit2:col8=col9
                // Att12=color enable register enable plane 3210
    ModeRegs    :array[1..{"MAX_MODE_CMDS"}8] of REGCMD; // Register command table
  end;

 VioModeInfoTable           =array [0..1000] of VioModeInfo;


const
  Terminate_CMD         =0;
  Attributes_CMD        =1;
  Sequencers_CMD        =2;
  CRTCtlRegs_CMD        =3;
  Graphics_CMD          =4;
  RegOutput_CMD         =5;

{
type
  crtc00_19             =array[$00..$19] of byte;}

var
  moduleerror           :array[0..512] of char;
  bvhvga_dll            :HModule;
  rc                    :longint;
  entry6                :^VioModeInfoTable;

{
const
  default_crtc          :crtc00_19
    =($5F,$4F,$50,$82,$55,$81,$BF,$1F,$00,$4F,$0D,$0E,$00,$00,$00,$00,
      $9C,$AE,$8F,$28,$1F,$96,$B9,$A3,$FF,$00);
  font_9x19_crtc        :crtc00_19
    =($5F,$4F,$50,$82,$55,$81,$0B,$3E,$00,$12,$11,$12,$00,$00,$07,$82,
//    $EA,$AC,$DA,$28,$1F,$E7,$04,$A3,$FF,$00);
      $EA,$2C,$DA,$28,$1F,$E7,$04,$A3,$FF,$00);
//     x0  x1  x2  x3  x4  x5  x6  x7  x8  x9  xa  xb  xc  xd  xe  xf
  font_9x20_crtc        :crtc00_19
    =($5F,$4F,$50,$82,$55,$81,$0B,$3E,$00,$12,$12,$13,$00,$00,$07,$82,
      $EA,$2C,$DA,$28,$1F,$E7,$04,$A3,$FF,$00);}

// 06 vertical total-2 (0..7)              (400:$1BF=447  480:
// 07.7 bit9 start vertical retrace  (10h) (400:0->$19c) (480:0->$1ea)
//   .6 bit9 vertical display end    (12h) (400:0->$18f) (480:0->$1da)
//   .5 bit9 vertical total          (06h) (400:0->$1bf) (480:1->$20b)
//   .4 bit8 line compare   (?)      (18h) (400:1->$3ff) (480:1->$3ff)
//   .3 bit8 start vertical blanking (15h) (400:1->$196) (480:1->$1e7)
//   .2 bit8 vertical retrace start  (10h) (400:1->$19c) (480:1->$1ea)
//   .1 bit8 vertical display end    (12h) (400:1->$18f) (480:1->$1da)
//   .0 bit8 vertical total          (06h) (400:1->$1bf) (480:0->$20b)
// 09.7 double scan active                 (400:0      ) (480:0      )
//   .6 bit9 line compare            (18h) (400:1->$3ff) (480:0->$1ff)
//   .5 bit9 start vertical blanking (15h) (400:0->$196) (480:0->$1e7)
//   .4-0 maximum scan line 00..31 (h-1)   (400:16-1   ) (480:19-1   )
// 0A   first cursor scanline...           (400:13     ) (480:17     )
// 0b   end cursor row...                  (400:14     ) (480:18     )
// 10   start vertical retrace 400+12; 480+10; -> 500+10?
// 11.7 protect [00]..[07] ; ohne [07].4   (400:1      ) (480:1      )
//   .6 refresh                            (400:0      ) (480:0      )
//   .5 enable vertical int                (400:1      ) (480:1      )
//   .4 clear  vertical int                (400:0      ) (480:0      )
//   .3-0 vertical retrace end             (400:14     ) (480:12     )
// 12 vertical display end register (480-1)
// 15 start vertical blanking-1 (480+8-1)
// 16 end vertical blanking (Bit 4..0)     (400:$19    ) (480:$0b)

var
  cellrow,
  vertical_total,               (* 06 *)
  start_vertical_retrace,       (* 10 *)
  vertical_retrace_end,         (* 11 *)
  vertical_display_end,         (* 12 *)
  start_vertical_blanking,      (* 15 *)
  end_vertical_blanking,        (* 16 *)
  line_compare                  (* 18 *)
                        :word;

  misc_out_or           :byte;
  misc_out_and          :byte;

procedure SetBit(var w:word;bit:byte;var bvar:byte;orconst:byte);
  begin
    if Odd(w shr bit) then
      bvar:=bvar or       orconst
    else
      bvar:=bvar and (not orconst);
  end;

procedure show_modetable(var table:VioModeInfoTable);
  var
    i                   :word;
  begin
    for i:=Low(table) to High(table) do
      with table[i] do
        begin
          if cb<>12 then Break;

          if Odd(fbType shr 1) then
            Write('Grafik ')
          else
            Write('Text   ');
          Write(Color:2,' Bit Farbe, ',Col:3,' x',Row:3,' / ',HRes:4,' x',VRes:4);
          WriteLn;
        end;
  end; (* show_modetable *)

procedure patch_modetable_entry(var entry:VioModeInfo;const cellrow,lines:word;const set_color:boolean);
  var
    cmd                 :word;
    p                   :pByteArray;
    i                   :word;
  const
    mono_color_text     :array[boolean] of string[20]=('Mono','Color');
  begin
    with entry do
      begin
        if not stumm then
          begin
            WriteLn('80*',lines,', 9x',cellrow,', ',mono_color_text[set_color]);
          end;

        (* Register berechnen ***************************************)


        VRes:=cellrow*lines;
        misc_out_or :=$00;
        misc_out_and:=$ff;


        // Bit 7-6: sync polarity / vertical resolution
        misc_out_and:=misc_out_and and (not $c0);
        if VRes<=200 then
          misc_out_or:=misc_out_or or (0 shl 6)
        else
        if VRes<=350 then
          misc_out_or:=misc_out_or or (2 shl 6)
        else
        if VRes<=400 then
          misc_out_or:=misc_out_or or (1 shl 6)
        else
          misc_out_or:=misc_out_or or (3 shl 6);

        // Bit 3-2 pixelclock
        misc_out_and:=misc_out_and and (not $0c);
      //// default 25.175 -> 70Hz
      //misc_out_or:=misc_out_or or (0 shl 2);
      //// better  28.322 even for 9x16 mode
      //if (VRes>400) or (not true{?}) then
      //  misc_out_or:=misc_out_or or (1 shl 2);
        // vdhdata.h allways sets  28 MHz clock, ("0x67")
        misc_out_or:=misc_out_or or (1 shl 2);
        // more clocks, but chipset specific - let SNAP find a solution here...

        // Bit 0 mono/color
        misc_out_and:=misc_out_and and (not $01);
        if set_color then
          misc_out_or:=misc_out_or or $01;


        case VRes of // verringern: oberer schwarzer Rand verschwindet
          400{16}:vertical_total:=VRes+49-2;
          475{19}:vertical_total:=VRes+50-2 {!+14};
          480    :vertical_total:=VRes+45-2;{IBM: $20b}
          500{20}:vertical_total:=VRes+50-2;{?}
          504    :vertical_total:=VRes+18-2;{SNAP/SiS:$208}

        else
          RunError(99);
        end;

        case VRes of // erh”hen: oberste Zeile ist besser sichtbar
          400{16}:start_vertical_retrace:=VRes+12;
          475{19}:start_vertical_retrace:=VRes+15 {!+7};
          480    :start_vertical_retrace:=VRes+10;{IBM: $1ea}
          500{20}:start_vertical_retrace:=VRes+16;{?}
          504    :start_vertical_retrace:=VRes+ 1;{SNAP/SiS:$1f9}
        else
          RunError(99);
        end;

        case VRes of  //?
          400{16}:vertical_retrace_end:=14;
          475{19}:vertical_retrace_end:=12  {!+0};
          480    :vertical_retrace_end:=12;{IBM:$xC}
          500{20}:vertical_retrace_end:=12  +2;{?}
          504    :vertical_retrace_end:=12;{SNAP/SiS:$xC}
        else
          RunError(99);
        end;

        case VRes of // erh”hen -> weniger schwarzer Rand oben
          400{16}:end_vertical_blanking:=25;
          475{19}:end_vertical_blanking:= 4 {!+19};
          480    :end_vertical_blanking:= 4;{IBM:$x4}
          500{20}:end_vertical_blanking:= 4 +21 ;{?}
          504    :end_vertical_blanking:= 1;{SNAP/SiS:$01}
        else
          RunError(99);
        end;

        vertical_display_end:=VRes-1;

        case VRes of  // erh”hen: letzte Zeile ist besser sichtbar
          400{16}:start_vertical_blanking:=VRes+ 6;
          475{19}:start_vertical_blanking:=VRes+12-1{!+9};
          480    :start_vertical_blanking:=VRes+ 8-1;{IBM:$1e7}
          500{20}:start_vertical_blanking:=VRes+12-1;{?}
          504    :start_vertical_blanking:=VRes+ 0;{SNAP/SiS:$1f8}
        else
          RunError(99);
        end;

        // Split Screen abschalten
        line_compare:=(1 shl 9)+(1 shl 8)+$ff;

        (* berechnete Register in Tabelle eintragen *****************)

        if set_color then fbType:=$01 else fbType:=$00;
        if set_color then Color :=$04 else Color :=$00;
        Col:=80;
        Row:=lines;
        HRes:=720;
        VRes:=lines*cellrow;
        fmt_ID:=0;
        Attrib:=1;
        if set_color then
          begin
            if VRes>400 then
              MemMap:=11 (* VDH.H: MemMap_Text480 *)
            else
              MemMap:=2 (* VDH.H: MemMap_Text80 *)
          end
        else
          MemMap:=0;(* VDH.H: MemMap_Mono *)

        if cellrow=14 then
          ROMFontIndex:=3 (* 9x14 *)
        else
          ROMFontIndex:=5;(* 9x16 *)

        if set_color then
          Flags:=8 (* NOT_PLASMA *)
        else
          Flags:=9;(* IGNORE_CLR_BRST+NOT_PLASMA *)

        // miscout register
        CompRegs[1]:=(CompRegs[1] and misc_out_and) or misc_out_or;

        if set_color then
          begin
            CompRegs[2]:=attributes_mode3[$10];
            CompRegs[3]:=attributes_mode3[$12];
          end
        else
          begin
            CompRegs[2]:=attributes_mode7[$10];
            CompRegs[3]:=attributes_mode7[$12];
          end;

        CompRegs[4]:=$00; (* seq[$01] *)


        for cmd:=Low(ModeRegs) to High(ModeRegs) do
          with ModeRegs[cmd],ModeRegs[cmd].RegData do
            case Command of

              Terminate_CMD:
                Break;

              Attributes_CMD: // Port[$3c0]..
                begin
                  p:=SelToFlatFunction(DataArea);
                  if set_color then
                    Move(attributes_mode3[FirstEntry],p^[0],NumEntries)
                  else
                    Move(attributes_mode7[FirstEntry],p^[0],NumEntries);
                end;

              Sequencers_CMD: // Port[$3c4],Port[$3c5]
                ;

              CRTCtlRegs_CMD: // Port[$3d4],Port[$3d5] (mono: 3b4/3b5)
                begin
                  p:=SelToFlatFunction(DataArea);
                  for i:=0 to NumEntries-1 do

                    case FirstEntry+i of

                      $06:
                        begin
                          // 06: vertical total-2 Bit7..0
                          p^[i]:=vertical_total and $ff;
                        end;

                      $07:
                        begin
                          // 07: various 9/8 bits
                          SetBit(start_vertical_retrace ,9,p^[i],$80);
                          SetBit(vertical_display_end   ,9,p^[i],$40);
                          SetBit(vertical_total         ,9,p^[i],$20);
                          SetBit(line_compare           ,8,p^[i],$10);
                          SetBit(start_vertical_blanking,8,p^[i],$08);
                          SetBit(start_vertical_retrace ,8,p^[i],$04);
                          SetBit(vertical_display_end   ,8,p^[i],$02);
                          SetBit(vertical_total         ,8,p^[i],$01);
                        end;

                      $09:
                        begin
                          // 09.7 double scan active
                          //   .6 bit9 line compare
                          SetBit(line_compare           ,9,p^[i],$40);
                          //   .5 bit9 start vertical blanking
                          SetBit(start_vertical_blanking,9,p^[i],$20);
                          //   .4-0 maximum scan line 00..31 (h-1)
                          p^[i]:=(p^[i] and (not $1f)) or (cellrow-1);
                        end;

                      $0a:
                        begin
                          // 0A first cursor scanline...
                          p^[i]:=cellrow-1-1(*-1*);
                        end;

                      $0b:
                        begin
                          // 0b end cursor row...
                          p^[i]:=cellrow-1(*-1*);
                        end;

                      $10:
                        begin
                          // 10 start vertical retrace
                          p^[i]:=start_vertical_retrace and $ff;
                        end;

                      $11:
                        begin
                          // 11.7 protect [00]..[07] ; ohne [07].4
                          //   .6 refresh
                          //   .5 enable vertical int
                          //   .4 clear  vertical int
                          //   .3-0 vertical retrace end
                          p^[i]:=(p^[i] and (not $0f)) or vertical_retrace_end;
                        end;

                      $12:
                        begin
                          // 12 vertical display end
                          p^[i]:=vertical_display_end and $ff;
                        end;

                      $14:
                        begin
                          // 14 Bit 4-0 4  Position of underline within Character cell.
                          // sonst bewirkt 'LxLite /?' im Modus (2 ($14:$0f)) Unterstreichungen
                          p^[i]:=p^[i] and (not $1f);
                          if set_color then
                            p^[i]:=p^[i] or $1f
                          else
                            p^[i]:=p^[i] or $0f;
                        end;

                      $15:
                        begin
                          // 15 start vertical blanking-1
                          p^[i]:=start_vertical_blanking and $ff;
                        end;

                      $16:
                        begin
                          // 16 end vertical blanking (Bit 4..0)
                          p^[i]:=0;
                          // unknown bit 7..5 (101x-xxxx)
                          if cellrow=16 then p^[i]:=$a0;
                          p^[i]:=(p^[i] and (not $1f)) or end_vertical_blanking;
                        end;
                      $18:
                        begin
                          p^[i]:=Lo(line_compare);
                        end;

                    end;
                end;
              Graphics_CMD:   // Port[$3ce],Port[$3cf]
                begin
                  p:=SelToFlatFunction(DataArea);
                  if set_color then
                    Move(graphics_mode3[FirstEntry],p^[0],NumEntries)
                  else
                    Move(graphics_mode7[FirstEntry],p^[0],NumEntries);
                end;

              RegOutput_CMD:
                begin
                  p:=SelToFlatFunction(DataArea);
                  if (FirstEntry=$3c2) and (NumEntries=1) then
                    p^[0]:=(p^[0] and misc_out_and) or misc_out_or;
                end;

            else
              Abbruch('Unknown ModeRegs command, ask for update.',1);
            end;
      end;
  end; (* patch_modetable_entry *)

procedure patch_modetable(var table:VioModeInfoTable);
  var
    i,Entry             :word;
  begin
    // entry #0: IBM: 80x25 720x400 2^4 color "2+, 3+"
    case cellrow of
      16:patch_modetable_entry(table[0],16,25,true ); (* 400 *)
      19:patch_modetable_entry(table[0],19,25,true ); (* 475 *)
      20:patch_modetable_entry(table[0],20,25,true ); (* 500 *)
    end;

    // entry #2: IBM: 80x25 720x400 MONO "7+"
    case cellrow of
      16:patch_modetable_entry(table[2],16,25,false); (* 400 *)
      19:patch_modetable_entry(table[2],10,48,true ); (* 480 *)
      20:patch_modetable_entry(table[2],14,36,true ); (* 504 *)
    end;

    {
    for i:=Low(table) to High(table) do
      with table[i] do
        begin
          if  (cb<>12) then Break;

          (* table entry #1 *)
          if  (fbType=1) (* not mono(1);not graphic(2);enable color burst(4);vga compatible(8) *)
          and (Color=4) (* 2^4=16 *)
          and (Col=80)
          and (Row=25)
          and (HRes=720)
          and ((VRes=400) or (VRes=475) or (VRes=480) or (VRes=500)) then
            case cellrow of  //?
              16:patch_modetable_entry(table[i],16,25); (* 400 *)
              19:patch_modetable_entry(table[i],19,25); (* 475 *)
              20:patch_modetable_entry(table[i],20,25); (* 500 *)
            else
            end;
        end;
     }
  end; (* patch_modetable *)


var
  para1pos              :word;

begin
  for para1pos:=1 to Length(para1) do para1[para1pos]:=UpCase(para1[para1pos]);

  if para1='16' then
    cellrow:=16
  else
  if para1='19' then
    cellrow:=19
  else
  if para1='20' then
    cellrow:=20
  else
  if para1='' then
    para1:='SHOW'
  else
  if para1='SHOW' then
    //
  else
    para1:='/?';

  if (ParamCount>1) or (para1='/?') or (para1='-?') then
    begin
      WriteLn('Usage: P_VGA (SHOW|16|19|20)');
      WriteLn('  P_VGA allows to list video modes in BVHVGA.DLL,');
      WriteLn('  or alter the 80x25 text mode parameters to font 9x16/9x19/9x20.');
      Halt(1);
    end;

{
  if not PMPresent then
    Abbruch('Can not run, because PM is not active.',1);}

  rc:=DosLoadModule(moduleerror,SizeOf(moduleerror),'BVHVGA.DLL',bvhvga_dll);

  {rc:=DosQueryModuleHandle('BVHVGA.DLL',bvhvga_dll);
  if rc=Error_Invalid_Name then
    Abbruch('Can not run, BVHVGA.DLL is not loaded.',1);}

  if rc<>0 then RunError(rc);

  // '_VideoHardware' - im Datensegment (3)
  rc:=DosQueryProcAddr(bvhvga_dll,6,nil,Pointer(entry6));
  if rc<>0 then
    Abbruch('Can not get access to BVHVGA.DLL data segment.',1);

  // Anfang des Datensegmentes
  entry6:=Ptr(Ofs(entry6^) and $ffff0000);

  // suche 80*25 VGA-Textmodus, erster Eintrag
  repeat
    with entry6^[Low(entry6^)] do
      if  (cb=12)
      and (fbType=1) (* not mono(1);not graphic(2);enable color burst(4);vga compatible(8) *)
      and (Color=4) (* 2^4=16 *)
      and (Col=80)
      and (Row=25)
      and (HRes=720)
      and ((VRes=400) or (VRes=475) or (VRes=480) or (VRes=500)) then
        Break;

    if StrComp(PChar(entry6),'\SHAREMEM\DOS\CDIB')=0 then
      Abbruch('Mode table not found.',1);

    Inc(Longint(entry6));
  until false;

  // gefunden!

  if para1='SHOW' then
    show_modetable(entry6^)
  else
    patch_modetable(entry6^);

  DosFreeModule(bvhvga_dll);
end;

end.

