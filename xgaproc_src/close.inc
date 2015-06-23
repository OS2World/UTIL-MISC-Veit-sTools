function xga_Close(const info:pmmIOInfo;const usFlags:Longint):Longint;
  var
    x,y                 :Longint;
    si,di               :Longint;
    r,g,b               :byte;
    xga_buf_tmp         :pWordArray;
    lBytesWritten       :LONG;                  (* #bytes output on a write     *)
    lRetCode            :LONG;
    rc                  :USHORT;
    remap31             :array[0..255] of byte;
    remap63             :array[0..255] of byte;

  begin
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

              {$IfDef LOG_TO_FILE}
              Log_Ausgabe('  Close: RGBPos=$'+Int2hex(RGBPos,8)+', RGBTotalBytes=$'+Int2Hex(RGBTotalBytes,8));
              {$EndIf LOG_TO_FILE}


              if DosAllocMem2(Pointer(xga_buf_tmp),xga_header.datenlaenge)<>No_Error then
                begin
                  ulErrorRet:=MMIOERR_OUTOFMEMORY;
                  Result:=MMIO_ERROR;
                  Exit;
                end;

              for x:=Low(remap31) to High(remap31) do remap31[x]:=Round(x*31/255);
              for x:=Low(remap63) to High(remap63) do remap63[x]:=Round(x*63/255);

              {$IfDef LOG_TO_FILE}
              Log_Ausgabe('  Close: '+Int2Str(mmXDIBHeader.BMPInfoHeader2.cBitCount)+' bit');
              {$EndIf LOG_TO_FILE}

              for y:=0 to xga_header.bild_y-1 do
                begin
                  si:= y*RGBLineLengthPad;
                  di:= y*xga_header.bild_x;
                  for x:=0 to xga_header.bild_x-1 do
                    begin
                      case mmXDIBHeader.BMPInfoHeader2.cBitCount of
                        1:
                         begin
                           with bmiColors[(RGBBuf^[si] shr (7-(x and 7))) and 1] do
                             begin
                               r:=bRed;
                               g:=bGreen;
                               b:=bBlue;
                             end;
                           if (x and 7)=7 then Inc(si);
                         end;
                        4:
                         begin
                           with bmiColors[(RGBBuf^[si] shr (4-4*(x and 1))) and 15] do
                             begin
                               r:=bRed;
                               g:=bGreen;
                               b:=bBlue;
                             end;
                           if (x and 1)=1 then Inc(si);
                         end;
                        8:
                         begin
                           with bmiColors[RGBBuf^[si]] do
                             begin
                               r:=bRed;
                               g:=bGreen;
                               b:=bBlue;
                             end;
                           Inc(si);
                         end;
                       24:
                         begin
                         //r:=RGBBuf^[si];Inc(si);
                         //g:=RGBBuf^[si];Inc(si);
                         //b:=RGBBuf^[si];Inc(si);
                           b:=RGBBuf^[si];Inc(si);
                           g:=RGBBuf^[si];Inc(si);
                           r:=RGBBuf^[si];Inc(si);
                         end;
                      end;

                      xga_buf_tmp^[di]:=remap31[r] shl 11
                                       +remap63[g] shl  5
                                       +remap31[b] shl  0;
                      Inc(di);
                    end;

                end;

              lBytesWritten:=mmioWrite(hmmioSS,@xga_buf_tmp^,xga_header.datenlaenge);

              if lBytesWritten<>xga_header.datenlaenge then
                begin
                  ulErrorRet:=lBytesWritten; (* MMIOERR_WRITE_FAILED? *)
                  Result:=MMIO_ERROR;
                  Exit;
                end;

              Ensure_Dispose(Pointer(xga_buf_tmp))

            end;  (* end IF WRITE & IMAGE BUFFER block *)



          Ensure_Dispose(Pointer(RGBBuf));

        (***********************************************************
         * Close the file with mmioClose.
         ***********************************************************)
        rc:=mmioClose(hmmioSS,0);

      end; (* info^,PMMFILESTATUS(info^.pExtraInfoStruct)^ *)

    Ensure_Dispose(info^.pExtraInfoStruct);

    if rc<>MMIO_SUCCESS then
      lRetCode:=rc;

    Result:=lRetCode;

  end; (* xga_Close *)

