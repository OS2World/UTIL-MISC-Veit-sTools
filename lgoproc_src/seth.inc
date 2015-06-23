(* in the sample source, return code=0 means error? *)
function lgo_SetHeader(const info:pmmIOInfo;const pHeader:Pointer;const Len:Longint):Longint;
  var
    ulBytesWritten      :ULONG;
    i                   :word;
    rc                  :longint;
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
            if Len<>SizeOf(t_lgo_header) then
              begin
                ulErrorRet:=MMIOERR_INVALID_BUFFER_LENGTH;
                Result:=MMIO_ERROR;
                Exit;
              end;

            (********************************************************
             * Ensure that the header at least begins with "YUV12C"
             ********************************************************)
             with t_lgo_header(pHeader^) do
               if blocks[0].filepos<>SizeOf(lgo_header) then
                 begin
                   ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
                   Result:=MMIO_ERROR;
                   Exit;
                 end;

            (********************************************************
             * Take 16 byte buffer (lParam1), write to file and .
             *    copy to internal structure.
             ********************************************************)
            lgo_header:=p_lgo_header(pHeader)^;
            ulBytesWritten:=mmioWrite(hmmioSS,@lgo_header,SizeOf(lgo_header));

            (*********************************
             * Check for an error on the write..
             *********************************)
            if ulBytesWritten<>SizeOf(lgo_header) then
              begin
                ulErrorRet:=MMIOERR_WRITE_FAILED;
                Result:=MMIO_ERROR;
                Exit;
              end;

            (*********************************
             * Success...
             *********************************)
            bSetHeader:=TRUE;
            Result:=SizeOf(t_lgo_header);
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
                  or (not ((cBitCount=24) or (cBitCount=8) or (cBitCount=4) or (cBitCount=1)))
                   then
                    begin
                      ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
                      Result:=MMIO_ERROR;
                      Exit;
                    end


                  (* OS2LOGO has requirement for size 640*400 or 640*480
                     also 16 colors, but that can translated *)
                  else
                  if (cx<>640)
                  or ((cy<>400) and (cy<>480))
                   then
                    begin
                      ulErrorRet:=MMIOERR_INCOMPATIBLE_DATA;
                      Result:=MMIO_ERROR;
                      Exit;
                    end;

                (* header acceptable, copy it *)
                mmImgHdr:=PMMIMAGEHEADER(pHeader)^;


                (************************************************************
                 * Complete MMOTIONHEADER.
                 ************************************************************)
                FillChar(lgo_header,SizeOf(lgo_header),0);
                lgo_header.blocks[0].filepos:=SizeOf(lgo_header);
                lgo_header.blocks[0].packed_size:=0;
                for i:=1 to High(lgo_header.blocks) do
                  begin
                    lgo_header.blocks[i].filepos:=lgo_header.blocks[i-1].filepos
                                                 +lgo_header.blocks[i-1].packed_size;
                    lgo_header.blocks[i].packed_size:=0;
                  end;

                with mmXDIBHeader.BMPInfoHeader2 do
                  RGBBuf_berechnen(cx,cy,cBitCount,PMMFILESTATUS(info^.pExtraInfoStruct)^);

                (************************************************************
                 * Write the M-Motion Header.
                 ************************************************************)
                ulBytesWritten:=mmioWrite(hmmioSS,@lgo_header,SizeOf(lgo_header));

                (***************************************
                 * Check for an error on the write...
                 ***************************************)
                if ulBytesWritten<>SizeOf(lgo_header) then
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
                rc:=DosAllocMem2(Pointer(RGBBuf),RGBTotalBytes);
                if rc<>No_Error then
                  begin
                    ulErrorRet:=rc; (* MMIOERR_OUTOFMEMORY *)
                    Result:=MMIO_ERROR;
                    Exit;
                  end;

                Result:=SizeOf(MMIMAGEHEADER);
              end; (* PMMIMAGEHEADER(pHeader)^ *)
          end; (* translate *)
      end; (* with info^, info^.pExtraInfoStruct^ *)
  end; (* lgo_SetHeader *)
