{$IfNDef VirtualPascal}
{$M 16384,0,0}
{$EndIf}
{&Use32+}
program show_vpt;

uses
  {$IfDef Os2}
  Os2Def,
  Os2Base,
  {$EndIf Os2}
  HilfsFun;

type
  Video_Parameter_Table_entry=
    packed record
      number_of_displayed_character_columns     :byte;
      number_of_displayed_screen_rows_minus_1   :byte;
      character_matrix_height_in_points         :byte;
      video_buffer_size_in_bytes                :smallword;
      contents_of_sequencer_registers           :array[1..4] of byte;
      misc_output_register_values               :byte;
      contents_of_CRTC_registers                :array[$00..$18] of byte;
      contents_of_attribute_controller_regs     :array[$00..$13] of byte;
      contents_of_graphics_controller_regs      :array[$00..$08] of byte;
    end;

  Video_Parameter_Table                         =array[$00..$1c] of Video_Parameter_Table_entry;

  pLongint                                      =^Longint;

const
  Video_Parameter_Table_description             :array[$00..$1c] of PChar=
   ('Mode $00 in 200-line CGA emulation mode',
    'Mode $01 in 200-line CGA emulation mode',
    'Mode $02 in 200-line CGA emulation mode',
    'Mode $03 in 200-line CGA emulation mode',

    'Mode $04',
    'Mode $05',
    'Mode $06',
    'Mode $07',
    'Mode $08',
    'Mode $09',
    'Mode $0A',
    'Mode $0B',
    'Mode $0C',
    'Mode $0D',
    'Mode $0E',

    'Mode $0f when only 64kB RAM on adapter',
    'Mode $10 when only 64kB RAM on adapter',

    'Mode $0f when >64kB RAM on adapter',
    'Mode $10 when >64kB RAM on adapter',

    'Mode $00 in 350-line mode',
    'Mode $01 in 350-line mode',
    'Mode $02 in 350-line mode',
    'Mode $03 in 350-line mode',

    'Mode $00 or $01 in 400-line mode',
    'Mode $02 or $03 in 400-line mode',
    'Mode $07 in 400-line mode',
    'Mode $11',
    'Mode $12',
    'Mode $13');

var
  {$IfDef Os2}
  mb1                   :array[0..$fffff] of byte;
  {$Endif Os2}
  o                     :longint;
  pvpt                  :^Video_Parameter_Table;


{$IfDef Os2}
procedure os2_read_mb1;

  var
    hand,
    action,
    i,
    rc                  :longint;

    ParmRec1:
      record            // Input parameter record
        phys32          :longint;
        laenge          :smallword;
      end;

    ParmRec2:
      record
        sel             :smallword;
      end;

    ParmLen             : ULong;  // Parameter length in bytes
    DataLen             : ULong;  // Data length in bytes
    Data1:
      record
        sel             :smallword;
      end;

  begin
    FillChar(mb1,SizeOf(mb1),0);

    Fehlerbehandlung('Can not open driver "SCREEN$"',
      DosOpen('SCREEN$',hand,action,0,0,1,$40,nil));

    ParmLen:=SizeOf(ParmRec1);

    i:=0;
    repeat

    with ParmRec1 do
      begin
        phys32:=i;
        laenge:=0;
      end;

    datalen:=SizeOf(data1);
    rc:=DosDevIOCtl(
            hand,                       // Handle to device
            IOCTL_SCR_AND_PTRDRAW,      // Category of request
            SCR_ALLOCLDT,               // Function being requested
            @ParmRec1,                  // Input/Output parameter list
            ParmLen,                    // Maximum output parameter size
            @ParmLen,                   // Input:  size of parameter list
                                        // Output: size of parameters returned
            @Data1,                     // Input/Output data area
            Datalen,                    // Maximum output data size
            @DataLen);                  // Input:  size of input data area
    if rc=0 then
      begin

        asm {&Saves None}
          push gs

            sub esi,esi
            mov gs,data1.sel

            mov edi,offset mb1
            add edi,[i]
            mov ecx,$10000
            cld
          @l1:
            mov al,gs:[esi]
            inc esi
            stosb
            loop @l1

          pop gs
        end;

        ParmLen:=SizeOf(ParmRec2);

        with ParmRec2 do
          begin
            sel:=data1.sel;
          end;

        DataLen:=0;
        rc:=DosDevIOCtl(
                hand,                           // Handle to device
                IOCTL_SCR_AND_PTRDRAW,          // Category of request
                SCR_DEALLOCLDT,                 // Function being requested
                @ParmRec2,                      // Input/Output parameter list
                ParmLen,                        // Maximum output parameter size
                @ParmLen,                       // Input:  size of parameter list
                                                // Output: size of parameters returned
                nil,                            // Input/Output data area
                Datalen,                        // Maximum output data size
                @DataLen);                      // Input:  size of input data area

      end;

    Inc(i,$10000);
    until i=$100000;


    DosClose(hand);
  end;
{$EndIf Os2}

procedure load_vpte(var vpte:Video_Parameter_Table_entry;description:PChar);
  var
    i                   :word;
    video_base          :integer;
    reset               :byte;

  procedure set_crtc(i,val:byte);
    begin
      Port[video_base+$3d4]:=i;
      wait;
      Port[video_base+$3d5]:=val;
      wait;
    end;

  procedure set_sequenzer(i,val:byte);
    begin
      Port[video_base+$3c4]:=i;
      wait;
      Port[video_base+$3c5]:=val;
      wait;
    end;

  begin
    with vpte do
      begin

        Port[$3c2]:=misc_output_register_values and (not $0c);
        if Odd(misc_output_register_values) then
          video_base:=$3d0-$3d0
        else
          video_base:=$3b0-$3d0;

        (* disable video *)
        reset:=Port[video_base+$3da];
        wait;
        Port[video_base+$3c0]:=$00;

        {set_sequenzer($00,$01);?}
        for i:=Low(contents_of_sequencer_registers) to High(contents_of_sequencer_registers) do
          set_sequenzer(i,contents_of_sequencer_registers[i]);

        set_crtc($11,contents_of_CRTC_registers[$11] and (not $80));
        for i:=Low(contents_of_CRTC_registers) to High(contents_of_CRTC_registers) do
          set_crtc(i,contents_of_CRTC_registers[i]);

        Port[$3c2]:=misc_output_register_values;

        (* attribute controller *)
        reset:=Port[video_base+$3da];
        wait;
        for i:=Low(contents_of_attribute_controller_regs) to High(contents_of_attribute_controller_regs) do
          begin
            Port[video_base+$3c0]:=i;
            wait;
            Port[video_base+$3c0]:=contents_of_attribute_controller_regs[i];
            wait;
          end;

        (* graphics controller *)
        for i:=Low(contents_of_graphics_controller_regs) to High(contents_of_graphics_controller_regs) do
          begin
             Port[video_base+$3ce]:=i;
             wait;
             Port[video_base+$3cf]:=contents_of_graphics_controller_regs[i];
          end;

        (* enable video *)
        reset:=Port[video_base+$3da];
        wait;
        Port[video_base+$3c0]:=$20;

      end;
  end;

procedure gen_vpte(var vpte:Video_Parameter_Table_entry;description:PChar;index:word);
  var
    i                   :word;
    VRes,
    HRes                :word;
    grafik              :boolean;
    mono                :boolean;
    color_bit           :byte;
    character_matrix_with_in_points:byte;
    mem_base,
    mem_size            :longint;
    flagstring          :string;

  procedure setze_flagstring(const s1:string);
    begin
      if flagstring='0' then
        flagstring:=s1
      else
        flagstring:=flagstring+'+'+s1;
    end;

  begin

(* IBM: ddk\video\video\vdh\vdhdata.h ***************************************

/*
**  Mode index 0
*/
{ 12, NOT_MONO, 4, 80, 25, 720, 400, 0, 1,            /* @V2.0TLB15 VioSetMode Structure */
  MemMap_Text80, ROMFont9x16, NOT_PLASMA,
 { 0x67, 0x0C, 0x0F, 0x00 },
 {  /* [0][0-6] vga3p */
  { RegOutput_CMD,  { "\x63", MiscOutputRegWrite, 0x01 } },
  { Sequencers_CMD, { "\x01\x00\x03\x00\x02", 0x00, 0x04+1 } },
  { CRTCtlRegs_CMD, { "\x0E", 0x11, 0x01 } },
  { CRTCtlRegs_CMD, { "\x5F\x4F\x50\x82\x55\x81\xBF\x1F\x0\x4F\xD\xE\x0\x0\x0\x0\x9C\xAE\x8F\x28\x1F\x96\xB9\xA3\xFF",
                      0x00, 0x18+1 } },
  { RegOutput_CMD,  { "\x67", MiscOutputRegWrite, 0x01 } },
  { Attributes_CMD, { "\x0\x1\x2\x3\x4\x5\x14\x7\x38\x39\x3A\x3B\x3C\x3D\x3E\x3F\xC\x0\xF\x8", 0x00, 0x14 } },
  { Graphics_CMD,   { "\x0\x0\x0\x0\x0\x10\x0E\x00\xFF", 0x00, 0x09 } },
  { Terminate_CMD }
 } },   /* Modes 2+, 3+ */

****************************************************************************)


    with vpte do
      begin
        VRes:= contents_of_CRTC_registers[$12]
             +(contents_of_CRTC_registers[$07] shl 7) and $100
             +(contents_of_CRTC_registers[$07] shl 3) and $200
             +1;
        if Odd(contents_of_attribute_controller_regs[$10] shr 2) then
          character_matrix_with_in_points:=9
        else
          character_matrix_with_in_points:=8;
        HRes:=character_matrix_with_in_points*number_of_displayed_character_columns;
        grafik:=Odd(contents_of_attribute_controller_regs[$10] shr 0);
        mono:=Odd(contents_of_attribute_controller_regs[$10] shr 1);
        if Odd(contents_of_attribute_controller_regs[$10] shr 6) then
          color_bit:=8
        else
          begin
            color_bit:=4; (* oder weniger *)
            (* enabled pale bit *)
            case (contents_of_attribute_controller_regs[$12] and $0f) of
              $1:color_bit:=1;
              $3:color_bit:=2;
              $7:color_bit:=3;
              $f:color_bit:=4;
            end;
          end;
        case (contents_of_graphics_controller_regs[$06] shr 2) and $3 of
          0: (* A000-BFFF *)
            begin
              mem_base:=$a0000;
              mem_size:=$20000;
            end;
          1: (* A000-AFFF *)
            begin
              mem_base:=$a0000;
              mem_size:=$10000;
            end;
          2: (* B000-B7FF *)
            begin
              mem_base:=$b0000;
              mem_size:=$08000;
            end;
          3: (* B800-BFFF *)
            begin
              mem_base:=$b8000;
              mem_size:=$08000;
            end;
        end;


        WriteLn('/*');
        WriteLn('**  Mode index __'); (* <-fix youreself field (can not guess) *)
        WriteLn('**  taken from BIOS mode index x',Int2Hex(index,2));
        WriteLn('**  ',description);
        WriteLn('*/');
        WriteLn('{ 12, ');

        flagstring:='0';
        if not mono then
          setze_flagstring('NOT_MONO');
        if grafik then
          setze_flagstring('GRAPHICS');
        Write(flagstring,', ');

        if mono then
          Write(0)
        else
          Write(color_bit);
        Write(', ');

        Write(number_of_displayed_character_columns,', ');
        Write(number_of_displayed_screen_rows_minus_1+1,', ');

        Write(HRes,', ',VRes,', ');
        Write(0,', '); (* ?? DefaultFormat    *)
        Write(1,',');  (* ?? DefaultAttrCount *)
        WriteLn;
        Write('  ');


        if mono and (mem_base=$b0000) then
          Write('MemMap_Mono') (* 0 *)
        else
        if  (mem_base=$b8000)
        and (number_of_displayed_character_columns=40)
        and (not grafik) then
          Write('MemMap_Text40') (* 1 *)
        else
        if  (mem_base=$b8000)
        and (number_of_displayed_character_columns=80)
        and (VRes<=400)
        and (not grafik) then
          Write('define MemMap_Text80') (* 2 *)
        else
        if  (mem_base=$b8000)
        and grafik
        and (VRes=200)
        and ((HRes=320) or (HRes=640))
        and ((color_bit=2) or (color_bit=1)) then
          Write('MemMap_LoRes') (* 3 *)
        (* MemMap_Mode40 4 *)
        else
        if (mem_base=$a0000)
        and (grafik)
        and (HRes=320)
        and (VRes=200)
        and (color_bit=4) then
          Write('MemMap_ModeD')  (* 4 *)
        else
        if (mem_base=$a0000)
        and (grafik)
        and (HRes=640)
        and (VRes=200)
        and (color_bit=4) then
          Write('MemMap_ModeE') (* 5 *)
        else
        if (mem_base=$a0000)
        and (grafik)
        and (HRes=640)
        and (VRes=350)
        and (color_bit<=1) then
          Write('MemMap_ModeF') (* 6 *)
        else
        if (mem_base=$a0000)
        and (grafik)
        and (HRes=640)
        and (VRes=350)
        and ((color_bit=2) or (color_bit=4)) then
          Write('MemMap_Mode10') (* 7 *)
        else
        if (mem_base=$a0000)
        and (grafik)
        and (HRes=640)
        and (VRes=480)
        and (color_bit<=1) then
          Write('MemMap_Mode11') (* 8 *)
        else
        if (mem_base=$a0000)
        and (grafik)
        and (HRes=640)
        and (VRes=480)
        and (color_bit=4) then
          Write('MemMap_Mode12') (* 9 *)
        else
        if (mem_base=$a0000)
        and (grafik)
        and (HRes=320)
        and (VRes=200)
        and (color_bit=8) then
          Write('MemMap_Mode13') (* 10 *)
        else
        if  (mem_base=$b8000)
        and (number_of_displayed_character_columns>=80)
        and (VRes>400)
        and (not grafik) then
          Write('MemMap_Text480') (* 11 *)
        else
        if (mem_base=$a0000)
        and (grafik)
        and (HRes=640)
        and (VRes=480)
        and (color_bit=8) then
          Write('MemMap_Mode2E') (* 12 *)
        else
          Write('MemMap_UNKNOWN!');
        Write(', ');

        Write('ROMFont',character_matrix_with_in_points,'x',character_matrix_height_in_points,', ');

        flagstring:='0';
        if (HRes=360) or (HRes>=720) then
          setze_flagstring('NOT_PLASMA');
        if contents_of_attribute_controller_regs[1]=contents_of_attribute_controller_regs[2] then
          setze_flagstring('IGNORE_CLR_BRST');
        WriteLn(flagstring,',');
        WriteLn('{ 0x',Int2Hex(misc_output_register_values,2),
                ', 0x',Int2Hex(contents_of_attribute_controller_regs[$10],2),
                ', 0x',Int2Hex(contents_of_attribute_controller_regs[$12],2),
                ', 0x',Int2Hex(contents_of_sequencer_registers[$01],2),' },');
        WriteLn(' {');
        WriteLn('  { RegOutput_CMD,  { "\x',Int2Hex(misc_output_register_values and (not $c),2),
                '", MiscOutputRegWrite, 0x01 } },');
        Write  ('  { Sequencers_CMD, { "');
        Write('\x01'); (* Sequennzer [0]: reset *)
        for i:=Low(contents_of_sequencer_registers) to High(contents_of_sequencer_registers) do
          Write('\x',Int2Hex(contents_of_sequencer_registers[i],2));
        WriteLn('", 0x00, 0x04+1 } },');
        WriteLn('  { CRTCtlRegs_CMD, { "\x',Int2Hex(contents_of_CRTC_registers[$11] and (not $80),2),'", 0x11, 0x01 } },');
        Write  ('  { CRTCtlRegs_CMD, { "');
        for i:=Low(contents_of_CRTC_registers) to High(contents_of_CRTC_registers) do
          Write('\x',Int2Hex(contents_of_CRTC_registers[i],2));
        WriteLn('", 0x',Int2Hex(Low(contents_of_CRTC_registers),2),
                 ', 0x',Int2Hex(SizeOf(contents_of_CRTC_registers)-1,2),'+1 } },');
        WriteLn('  { RegOutput_CMD,  { "\x',Int2Hex(misc_output_register_values,2),'", MiscOutputRegWrite, 0x01 } },');
        Write('  { Attributes_CMD, { "');
        for i:=Low(contents_of_attribute_controller_regs) to High(contents_of_attribute_controller_regs) do
           Write('\x',Int2Hex(contents_of_attribute_controller_regs[i],2));
        WriteLn('", 0x',Int2Hex(Low(contents_of_attribute_controller_regs),2),
                 ', 0x',Int2Hex(SizeOf(contents_of_attribute_controller_regs)-1,2),'+1 } },');
        Write('  { Graphics_CMD,   { "');
        for i:=Low(contents_of_graphics_controller_regs) to High(contents_of_graphics_controller_regs) do
          Write('\x',Int2Hex(contents_of_graphics_controller_regs[i],2));
        WriteLn('", 0x',Int2Hex(Low(contents_of_graphics_controller_regs),2),
                 ', 0x',Int2Hex(SizeOf(contents_of_graphics_controller_regs)-1,2),'+1 } },');
        WriteLn('  { Terminate_CMD }');
        WriteLn(' } },');

      end;
  end;

procedure displac_vpte(var vpte:Video_Parameter_Table_entry;description:PChar);
  var
    i                   :word;
  begin
    WriteLn(description,':');
    with vpte do
      begin
        WriteLn('number of displayed character columns     ',number_of_displayed_character_columns);
        WriteLn('number of displayed screen rows minus 1   ',number_of_displayed_screen_rows_minus_1);
        WriteLn('character matrix height in points         ',character_matrix_height_in_points);
        WriteLn('video buffer size in bytes                ',video_buffer_size_in_bytes);
        WriteLn('contents of sequencer registers           ');
        Write('  ');
        for i:=Low(contents_of_sequencer_registers) to High(contents_of_sequencer_registers) do
          Write(Int2Hex(contents_of_sequencer_registers[i],2),' ');
        WriteLn;
        WriteLn('misc output register value                ',Int2Hex(misc_output_register_values,2));
        WriteLn('contents of CRTC registers                ');
        Write('     ');
        for i:=0 to $0f do
          Write('x',Int2Hex(i,1),'  ');
        WriteLn;
        for i:=Low(contents_of_CRTC_registers) to High(contents_of_CRTC_registers) do
          begin
            if (i and $0f)=0 then
              Write(Int2Hex(i shr 4,1),'x   ');
            Write(Int2Hex(contents_of_CRTC_registers[i],2),'  ');
            if ((i and $0f)=$0f) or (i=High(contents_of_CRTC_registers)) then
              WriteLn;
          end;
        WriteLn('contents of attribute controller regs     ');
        Write('  ');
        for i:=Low(contents_of_attribute_controller_regs) to High(contents_of_attribute_controller_regs) do
          Write(Int2Hex(contents_of_attribute_controller_regs[i],2),' ');
        WriteLn;
        WriteLn('contents_of_graphics_controller_regs      ');
        Write('  ');
        for i:=Low(contents_of_graphics_controller_regs) to High(contents_of_graphics_controller_regs) do
          Write(Int2Hex(contents_of_graphics_controller_regs[i],2),' ');
        WriteLn;
      end;
    WriteLn;
  end;

var
  para1,para2           :string;
  mode_index            :word;
  kontrolle             :integer;
  i                     :word;

begin
  para1:=ParamStr(1);
  para2:=ParamStr(2);

  if (ParamCount>2) or (para1='/?') or (para1='-?') then
    begin
      WriteLn('show or load video parameter table from VGA BIOS.');
      WriteLn('Usage: SHOW_VPT [ mode-index [LOAD|GEN] ]');
      WriteLn('  possible values for mode index are:');
      WriteLn('    $00 (cga 200 lines emulation) to $1c (VGA mode $13)');
      WriteLn('  default $18 (mode 3/4 400 lines VGA)');
      WriteLn('  LOAD   causes table values written to hardware');
      WriteLn('  GEN    causes bvh-compatible source code to be created');
      Halt(1);
    end;

  if (para1='') or (para1='*') then
    para1:='$18';
  Val(para1,mode_index,kontrolle);
  if (kontrolle<>0) or (mode_index<Low(Video_Parameter_Table)) or (mode_index>High(Video_Parameter_Table)) then
    Abbruch('mode index value '+para1+' is invalid',1);

  for i:=1 to Length(para2) do para2[i]:=UpCase(para2[i]);

  {$IfDef Os2}
  os2_read_mb1;
  // Video Save/Override Pointer Table
  o:=$a8+$40 shl 4;
  o:=MemW[Ofs(mb1[o])+0]+MemW[Ofs(mb1[o])+2] shl 4;
  // Video Parameter Table pointer
  o:=MemW[Ofs(mb1[o])+0]+MemW[Ofs(mb1[o])+2] shl 4;
  pvpt:=Ptr(Ofs(mb1[o]));
  {$Else}
  (* Video Parameter Table pointer *)
  pvpt:=Pointer(pLongint(Pointer(MemL[$40:$a8]))^);
  {$EndIf}

  if para2='LOAD' then
    load_vpte(pvpt^[mode_index],Video_Parameter_Table_description[mode_index])
  else
  if para2='GEN' then
    gen_vpte(pvpt^[mode_index],Video_Parameter_Table_description[mode_index],mode_index)
  else
  if (para2='')
  or (para2='SHOW') then
    displac_vpte(pvpt^[mode_index],Video_Parameter_Table_description[mode_index])
  else
    Abbruch('Unknown command '+para2,1);
end.

