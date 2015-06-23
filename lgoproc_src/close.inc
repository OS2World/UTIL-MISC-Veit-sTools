{$Define use_wait_pointer}
function lgo_Close(const info:pmmIOInfo;const usFlags:Longint):Longint;
  var
    x,y                 :Longint;
    si,di               :Longint;
    r,g,b               :byte;
    lBytesWritten       :LONG;                  (* #bytes output on a write     *)
    lRetCode            :LONG;
    rc                  :USHORT;
    tmp_remap           :pByteArray;
    unpacked_buffer     :pByteArray;
    packed_buffer       :pByteArray;
    pal_fast_remap      :array[0..255] of byte;
    plane               :word;
    w                   :word;
    last_SearchPaletteColor_r,
    last_SearchPaletteColor_g,
    last_SearchPaletteColor_b,
    last_SearchPaletteColor_p:word;

{$IfDef use_wait_pointer}
    ab                  :HAB;
    hptrOld             :HPOINTER;
    hptrWait            :HPOINTER;
{$EndIf use_wait_pointer}

  label
    exit_close;

  function SearchPaletteColor(const r,g,b:word):byte;
    var
      best              :word;
      error,error2      :longint;
      i                 :word;
    begin
      if  (r=last_SearchPaletteColor_r)
      and (g=last_SearchPaletteColor_g)
      and (b=last_SearchPaletteColor_b) then
        begin
          Result:=last_SearchPaletteColor_p;
          Exit;
        end;

      best:=Low(pal16_color);
      error:=High(error);
      for i:=Low(pal16_color) to High(pal16_color) do
        begin
          (* error2<=Sqr(255)*3 *)
          error2:=Sqr(pal16_color[i][0]-r)
                 +Sqr(pal16_color[i][1]-g)
                 +Sqr(pal16_color[i][2]-b);
          if error>error2 then
            begin
              error:=error2;
              best:=i;
            end;
        end;

      last_SearchPaletteColor_r:=r;
      last_SearchPaletteColor_g:=g;
      last_SearchPaletteColor_b:=b;
      last_SearchPaletteColor_p:=best;
      Result:=best;
    end;

  begin
    tmp_remap:=nil;
    unpacked_buffer:=nil;
    packed_buffer:=nil;

    {$IfDef use_wait_pointer}
    hptrOld:=0;
    hptrWait:=0;
    ab:=0;
    {$EndIf use_wait_pointer}

    (***********************************************************
     * Check for valid MMIOINFO block.
     ***********************************************************)
    if not Assigned(info) then
      begin
        Result:=MMIO_ERROR;
        Exit;
      end;

    (***********************************************************
     * Set up our working file status variable.
     ***********************************************************)
    with info^,PMMFILESTATUS(info^.pExtraInfoStruct)^ do
      begin

        (***********************************************************
         * Assume success for the moment....
         ***********************************************************)
        lRetCode:=MMIO_SUCCESS;

        (************************************************************
         * see if we are in Write mode and have a buffer to write out.
         *    We have no image buffer in UNTRANSLATED mode.
         ************************************************************)
        {$IfDef LOG_TO_FILE}
        Log_Ausgabe('close: ulTranslate and MMIO_WRITE='+Int2Hex(ulTranslate and MMIO_WRITE,8));
        Log_Ausgabe('close: ulTranslate='+Int2Hex(ulTranslate,8));
        Log_Ausgabe('close: ulFlags='+Int2Hex(ulFlags,8));
        {$EndIf LOG_TO_FILE}
        //if ((ulTranslate and MMIO_WRITE)<>0) and Assigned(RGBBuf) then
        if convert_and_save_changes then
          with mmImgHdr do
            begin
              (*******************************************************
               * The buffer should be in palettized or 24-bit RGB
               * We must convert it to YUV to be written to the file.
               *******************************************************
               * The buffer should be complete.  If not, then we
               * should still close, but can flag an error to the
               * user that the data may be corrupted.  The only way
               * we can estimate if this is true is to check the final
               * position.  If not at the end...
               *******************************************************)
              if RGBPos<>RGBTotalBytes then
                lRetCode:=MMIO_WARNING;

              (* remap any BMP to 16 fixed color palette entries *)
              rc:=DosAllocMem2(Pointer(tmp_remap),640*480);
              if rc<>No_Error then
                begin
                  ulErrorRet:=rc;
                  Result:=MMIO_ERROR;
                  goto exit_close;
                end;

              last_SearchPaletteColor_r:=999;
              last_SearchPaletteColor_g:=999;
              last_SearchPaletteColor_b:=999;
              last_SearchPaletteColor_p:=999;

              for x:=0 to 255 do
                with mmImgHdr.bmiColors[x] do
                  pal_fast_remap[x]:=SearchPaletteColor(bRed,bGreen,bBlue);

              for y:=lgo_y-1 downto 0 do
                begin
                  si:=(lgo_y-y-1)*RGBLineLengthPad;
                  for x:=0 to lgo_x-1 do
                    begin
                      case mmImgHdr.mmXDIBHeader.BMPInfoHeader2.cBitCount of
                        1:b:=pal_fast_remap[(RGBBuf^[si+x div 8] shr (7-  (x and 7))) and  1];
                        4:b:=pal_fast_remap[(RGBBuf^[si+x div 2] shr (4-4*(x and 1))) and $f];
                        8:b:=pal_fast_remap[ RGBBuf^[si+x      ]                            ];
                       24:b:=SearchPaletteColor(RGBBuf^[si+x*3+2],RGBBuf^[si+x*3+1],RGBBuf^[si+x*3+0]);
                      end;
                      tmp_remap^[y*lgo_x+x]:=b;
                    end;
                end;

              Ensure_Dispose(Pointer(RGBBuf));

              rc:=DosAllocMem2(Pointer(unpacked_buffer),max_unpacked_size);
              if rc<>No_Error then
                begin
                  ulErrorRet:=rc;
                  Result:=MMIO_ERROR;
                  goto exit_close;
                end;

              rc:=DosAllocMem2(Pointer(packed_buffer),max_packed_size);
              if rc<>No_Error then
                begin
                  ulErrorRet:=rc;
                  Result:=MMIO_ERROR;
                  goto exit_close;
                end;


              (* compression is slow.. *)
              {$IfDef use_wait_pointer}
              ab:=WinInitialize(0);
              hptrOld := WinQueryPointer(HWND_DESKTOP);
              hptrWait := WinQuerySysPointer(HWND_DESKTOP, SPTR_WAIT, FALSE);
              {$EndIf use_wait_pointer}

              for plane:=Low(lgo_header.blocks) to High(lgo_header.blocks) do
                begin

                  {$IfDef use_wait_pointer}
                  WinSetPointer(HWND_DESKTOP, hptrWait);
                  {$EndIf use_wait_pointer}

                  FillChar(unpacked_buffer^,max_unpacked_size,0);
                  FillChar(packed_buffer^,max_packed_size,0);

                  (* convert palette(0..16) values to plane bits *)
                  for w:=0 to lgo_x*lgo_y-1 do
                    if Odd(tmp_remap^[w] shr plane) then
                      unpacked_buffer^[w div 8]:=unpacked_buffer^[w div 8]
                                                +1 shl (7-(w and 7));

                  rc:=EP2_Compress(unpacked_buffer^,
                                   packed_buffer^,
                                   lgo_x*lgo_y div 8,
                                   max_packed_size);

                  {$IfDef LOG_TO_FILE}
                  Log_Ausgabe('EP2_Compress rc='+Int2Hex(rc,8));
                  {$EndIf LOG_TO_FILE}

                  if rc<=0 then
                    begin
                      ulErrorRet:=MMIOERR_ERROR_IN_FRAME_DATA; (* better? *)
                      Result:=MMIO_ERROR;
                      goto exit_close;
                    end;

                  if plane=Low(lgo_header.blocks) then
                    lgo_header.blocks[plane].filepos:=SizeOf(lgo_header)
                  else
                    lgo_header.blocks[plane].filepos:=lgo_header.blocks[plane-1].filepos
                                                     +lgo_header.blocks[plane-1].packed_size;
                  lgo_header.blocks[plane].packed_size:=rc;

                  lBytesWritten:=mmioWrite(hmmioSS,@packed_buffer^,lgo_header.blocks[plane].packed_size);
                  if lBytesWritten<>lgo_header.blocks[plane].packed_size then
                    begin
                      ulErrorRet:=lBytesWritten;
                      Result:=MMIO_ERROR;
                      goto exit_close;
                    end;
                end;

              (* now we have the valid header, write it *)
              rc:=mmioSeek(hmmioSS,0,SEEK_SET);
              if rc<>0 then
                begin
                  ulErrorRet:=rc;
                  Result:=MMIO_ERROR;
                  goto exit_close;
                end;

              rc:=mmioWrite(hmmioSS,@lgo_header,SizeOf(lgo_header));
              if rc<>SizeOf(lgo_header) then
                begin
                  ulErrorRet:=lBytesWritten;
                  Result:=MMIO_ERROR;
                  goto exit_close;
                end;

            end;  (* end IF WRITE & IMAGE BUFFER block *)

        Ensure_Dispose(Pointer(RGBBuf));

        (***********************************************************
         * Close the file with mmioClose.
         ***********************************************************)
        rc:=mmioClose(hmmioSS,usFlags);

      end; (* info^,PMMFILESTATUS(info^.pExtraInfoStruct)^ *)

    Ensure_Dispose(Pointer(info^.pExtraInfoStruct));

    if rc<>MMIO_SUCCESS then
      lRetCode:=rc;

    Result:=lRetCode;

  exit_close:
    Ensure_Dispose(Pointer(tmp_remap));
    Ensure_Dispose(Pointer(unpacked_buffer));
    Ensure_Dispose(Pointer(packed_buffer));

    {$IfDef use_wait_pointer}
    if (hptrOld<>0) or (hptrWait<>0) then
      begin
        rc:=PMError(WinSetPointer(HWND_DESKTOP, hptrOld),ab);
      //Log_Ausgabe('WinSetPointer(HWND_DESKTOP, hptrOld)='+Int2Hex(rc,8));
        rc:=PMError(WinDestroyPointer(hptrWait),ab);
      //Log_Ausgabe('WinDestroyPointer(hptrWait)='+Int2Hex(rc,8));
        rc:=Ord(WinTerminate(ab));
      //Log_Ausgabe('WinTerminate='+Int2Hex(rc,8));
      end;
    {$EndIf use_wait_pointer}

  end; (* lgo_Close *)

