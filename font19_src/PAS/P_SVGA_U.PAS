unit p_svga_u;

// remove SVGA mode 80x25 Text (fallback to bvh_vga)
// VK 2004.04.23

interface

procedure patch_bvhsvga_tabellen(stumm:boolean;ParamCount:word;para1:string);

implementation


Uses
  Hilfsfun,
  Os2Def,
  Os2Base,
  Strings;

procedure patch_bvhsvga_tabellen(stumm:boolean;ParamCount:word;para1:string);

type
  // from \ddk\video\video\svdh\bvhtype.h

  VIDEOMODE                     =
    packed record
      cb                        :smallword;
      fbType                    :byte;
      color                     :byte;
      col                       :smallword;
      row                       :smallword;
      hres                      :smallword;
      vres                      :smallword;
      fmt_ID                    :byte;
      attrib                    :byte;
      BufferAddress             :pointer;
      BufferLength              :longint;
      ulTotalSize               :longint;
      ulPageLength              :longint;
      miModeId                  :{smallword}longint;
      XCharSize                 :byte;
      YCharSize                 :byte;
      bVrtRefresh               :byte;
      bHrtRefresh               :byte;
      bVrtPolPos                :byte;
      bHrtPolPos                :byte;
      bRedMaskSize              :byte;
      bRedFieldPosition         :byte;
      bGreenMaskSize            :byte;
      bGreenFieldPosition       :byte;
      bBlueMaskSize             :byte;
      bBlueFieldPosition        :byte;
      bRsvdMaskSize             :byte;
      bRsvdFieldPosition        :byte;
    end;

  VIDEOMODE_array           =array[1..1000] of VIDEOMODE;

var
  moduleerror           :array[0..512] of char;
  bvhsvga_dll           :HModule;
  rc                    :longint;
  entry4                :pointer;
  svga_ds               :pointer;
  _pModes               :^VIDEOMODE_array;
  _ulTotalVideoModes    :word;
  i                     :word;

begin
  if (ParamCount<>1) or (para1='/?') or (para1='-?') then
    begin
      WriteLn('Usage: P_SVGA <VGA|SVGA|SHOW>');
      WriteLn('  VGA:  disable SVGA 720x400 Textmodes');
      WriteLn('        80x25 mode will be set by BVHVGA.DLL.');
      WriteLn('  SVGA: (re-)enable SVGA 720x400 Textmodes');
      WriteLn('        80x25 mode will be set by BVHVSGA.DLL');
      WriteLn('  SHOW  show BVHVSGA.DLL mode table');
      Halt(1);
    end;

  for i:=1 to Length(para1) do para1[i]:=UpCase(para1[i]);

  (*if not PMPresent then
    Abbruch('Can not run, because PM is not active.',1);*)
  rc:=DosQueryModuleHandle('BVHSVGA.DLL',bvhsvga_dll);
  if rc<>0 then
    begin
{//<<
      WriteLn('BVHSVGA.DLL is not loaded in this system configuration!'#7#7);}
      if stumm then Exit;
      Abbruch('BVHSVGA.DLL is not loaded in this system configuration!',rc);
    end;

  rc:=DosLoadModule(moduleerror,SizeOf(moduleerror),'BVHSVGA.DLL',bvhsvga_dll);
  if rc<>0 then
    Abbruch('Can not load/access BVHSVGA.DLL: '+OS_error_message(rc),rc);

  // 'DEVENABLE' - 16:16 -> CS2(Ring3)
  rc:=DosQueryProcAddr(bvhsvga_dll,4,nil,entry4);
  if rc<>0 then RunError(rc);

  // Laden des Datensegmentes DSEG3: bei +7
  Longint(svga_ds):=MemW[Ofs(entry4^)+7+1] shl 16;
  SelToFlat(svga_ds);
  _pModes:=Ptr(MemL[Longint(svga_ds)+$198]);
  SelToFlat(Pointer(_pModes));
  _ulTotalVideoModes:=MemW[Longint(svga_ds)+$1a2];

  for i:=1 to _ulTotalVideoModes do
    with _pModes^[i] do
      begin
        if (hres=0) and (vres=0) then Continue; (* Eintr„ge 1..60? *)
        if not stumm then
          begin
            Write(i:3,' : ');
            if Odd(fbType shr 1) then
              Write('Graphics ')
            else
              Write('Text     ');
            Write(hres:5,' x',vres:5,', ',color:2,' bit color, ');
            if Odd(fbType shr 1) then
              Write('':10)
            else
              Write(Col:3,' x',Row:3,', ');
            Write('Cell: ',XCharSize,' x',YCharSize:2);
          end; (* not stumm *)

        if (hres=720)                           // 80*9
        and ((vres=400) or (vres=14*28))        // 25*16/28*14/50*8
        and (color in [1,4])                    // 16 or "16 disabled"
        and Odd(fbType shr 0)                   // color mode
         then
          begin
            if (para1='VGA') or (para1='DISABLE') then
              color:=1 (* disable mode in BVHSVGA *)
            else
            if (para1='SVGA') or (para1='ENABLE') then
              color:=4;(* enable mode in BVHSVGA *)

            if not stumm then
              case color of
                1:Write(' -> disabled');
                4:Write(' -> enabled');
              end;
          end;

        if not stumm then
          WriteLn;
      end;

  DosFreeModule(bvhsvga_dll);
end;

end.

