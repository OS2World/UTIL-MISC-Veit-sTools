(* in the sample source, return code=0 means error? *)
function xga_SetHeader(const info:pmmIOInfo;const pHeader:Pointer;const Len:Longint):Longint;
  var
    ulBytesWritten      :ULONG;

  begin

    (************************************************************
     * Check for valid MMIOINFO block.
     ************************************************************)
    if not Assigned(info) then
      begin
        Result:=MMIO_ERROR;
        Exit;
      end;

    with info^,PMMFILESTATUS(info^.pExtraInfoStruct)^ do
      begin

        (************************************************************
         * Only allow this function if we are in WRITE mode
         * And only if we have not already set the header
         ************************************************************)
        if (ulFlags and MMIO_WRITE)=0 then
          begin
            ulErrorRet:=MMIOERR_READ_ONLY_FILE;
            Result:=MMIO_ERROR;
            Exit;
          end;

        if hmmioSS=0 then
          begin
            ulErrorRet:=MMIOERR_INVALID_HANDLE;
            Result:=MMIO_ERROR;
            Exit;
          end;

        if bSetHeader then
          begin
            ulErrorRet:=MMIOERR_INCOMPATIBLE_DATA;
            Result:=MMIO_ERROR;
            Exit;
          end;

        (********************************************************
         * Make sure lParam1 is a valid pointer
         ********************************************************)
        if not Assigned(pHeader) then
          begin
            ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
            Result:=MMIO_ERROR;
            Exit;
          end;

        (************************************************************
         * Header is not in translated mode.
         ************************************************************)
        if (ulTranslate and MMIO_TRANSLATEHEADER)=0 then
          begin
            (********************************************************
             * Make sure lParam2 is correct size
             ********************************************************)
            if Len<>SizeOf(t_xga_header) then
              begin
                ulErrorRet:=MMIOERR_INVALID_BUFFER_LENGTH;
                Result:=MMIO_ERROR;
                Exit;
              end;

            (********************************************************
             * Ensure that the header at least begins with "YUV12C"
             ********************************************************)
             with t_xga_header(pHeader^) do
               if (signature<>xga_signature)
               or (kopflaenge<>SizeOf(xga_header)) then
                 begin
                   ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
                   Result:=MMIO_ERROR;
                   Exit;
                 end;

            (********************************************************
             * Take 16 byte buffer (lParam1), write to file and .
             *    copy to internal structure.
             ********************************************************)
            xga_header:=p_xga_header(pHeader)^;
            ulBytesWritten:=mmioWrite(hmmioSS,@xga_header,SizeOf(xga_header));

            (*********************************
             * Check for an error on the write..
             *********************************)
            if ulBytesWritten<>SizeOf(xga_header) then
              begin
                ulErrorRet:=MMIOERR_WRITE_FAILED;
                Result:=MMIO_ERROR;
                Exit;
              end;

            (*********************************
             * Success...
             *********************************)
            bSetHeader:=TRUE;
            Result:=SizeOf(t_xga_header);
          end  (* end IF NOT TRANSLATED block *)
        else
          begin
            (************************************************************
             * Header is translated.
             ************************************************************)

            if Len<>SizeOf(MMIMAGEHEADER) then
              begin
                ulErrorRet:=MMIOERR_INVALID_BUFFER_LENGTH;
                Result:=MMIO_ERROR;
                Exit;
              end;

            (************************************************************
             * Check for validity of header contents supplied
             ************************************************************
             *  --  Length must be that of the standard header
             *  --  NO Compression
             *      1 plane
             *      24, 8, 4 or 1 bpp
             ************************************************************)
            with PMMIMAGEHEADER(pHeader)^ do
              begin

                with mmXDIBHeader.BMPInfoHeader2 do
                  if (ulCompression<>BCA_UNCOMP)
                  or (cPlanes<>1)
                  or (not ((cBitCount=24) or (cBitCount=8) or (cBitCount=4) or (cBitCount=1))) then
                    begin
                      ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
                      Result:=MMIO_ERROR;
                      Exit;
                    end;

                (* copy validated header *)
                mmImgHdr:=PMMIMAGEHEADER(pHeader)^;

                (************************************************************
                 * Complete MMOTIONHEADER.
                 ************************************************************)
                FillChar(xga_header,SizeOf(xga_header),0);
                xga_header.signature:=xga_signature;
                xga_header.kopflaenge:=SizeOf(xga_header);
                xga_header.datenlaenge:=2*mmXDIBHeader.BMPInfoHeader2.cx*mmXDIBHeader.BMPInfoHeader2.cy;
                xga_header.bild_x:=mmXDIBHeader.BMPInfoHeader2.cx;
                xga_header.bild_y:=mmXDIBHeader.BMPInfoHeader2.cy;
                xga_header.balken_start_x:=Min(8,xga_header.bild_x);
                xga_header.balken_start_y:=Max(xga_header.bild_y-8,0);
                xga_header.balken_groesse_x:=Max(xga_header.bild_x-2*xga_header.balken_start_x,0);
                xga_header.balken_groesse_y:=xga_header.bild_y-xga_header.balken_start_y;
                xga_header.balkenfarbe:=$ffff; (* 255/255/255 *)

                (********************************************************
                 * Ensure we will save stuff on 4-pel boundaries when
                 * we actually convert to YUV and pack the bits.
                 * We don't change what the user is actually going to
                 * give us.  The user thinks he is on 1-pel boundaries,
                 * and that is how we buffer the RGB data.
                 ********************************************************)
                RGBLineLengthPad:=( mmXDIBHeader.BMPInfoHeader2.cx
                                    *mmXDIBHeader.BMPInfoHeader2.cBitCount
                                    +7) div 8;
                RGBLineLengthPad:=(RGBLineLengthPad+3) and -4;
                RGBTotalBytes:=RGBLineLengthPad*mmXDIBHeader.BMPInfoHeader2.cy;
                RGBPos:=0;

                (************************************************************
                 * Write the M-Motion Header.
                 ************************************************************)
                ulBytesWritten:=mmioWrite(hmmioSS,@xga_header,SizeOf(xga_header));

                (***************************************
                 * Check for an error on the write...
                 ***************************************)
                if ulBytesWritten<>SizeOf(xga_header) then
                  begin
                    ulErrorRet:=MMIOERR_WRITE_FAILED;
                    Result:=MMIO_ERROR;
                    Exit;
                  end;

                (************************************************************
                 * Flag that MMIOM_SETHEADER has been done.  It can only
                 * be done ONCE for a file.  All future attempts will
                 * be flagged as errors.
                 ************************************************************)
                bSetHeader:=TRUE;

                (********************************************************
                 * Get space for full image buffer.
                 ********************************************************)
                if DosAllocMem2(Pointer(RGBBuf),RGBTotalBytes)<>No_Error then
                  begin
                    ulErrorRet:=MMIOERR_OUTOFMEMORY;
                    Result:=MMIO_ERROR;
                    Exit;
                  end;

                Result:=SizeOf(MMIMAGEHEADER);
              end; (* PMMIMAGEHEADER(pHeader)^ *)
          end; (* translate *)
      end; (* with info^, info^.pExtraInfoStruct^ *)
  end; (* xga_SetHeader *)
