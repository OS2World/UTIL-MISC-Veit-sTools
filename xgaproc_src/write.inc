function xga_Write(const info:pmmIOInfo;const pBuffer:pointer;const Len:Longint):Longint;
  var
    ulImgBytesToWrite   :ULONG;

  begin
    (************************************************************
     * Check for valid MMIOINFO block.
     ************************************************************)
    if not Assigned(info) then
      begin
        Result:=MMIO_ERROR;
        Exit;
      end;

    if not Assigned(info^.pExtraInfoStruct) then
      begin
        info^.ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
        Result:=MMIO_ERROR;
        Exit;
      end;

    with info^,PMMFILESTATUS(info^.pExtraInfoStruct)^ do
      begin

        (************************************************************
         * See if a SetHeader has been done on this file.
         ************************************************************)
        if not bSetHeader then
          begin
            ulErrorRet:=MMIOERR_INVALID_FILE;
            Result:=MMIO_ERROR;
            Exit;
          end;

        if (ulTranslate and MMIO_TRANSLATEDATA)=0 then
          begin
            (********************************************************
             * Translation is off, take amount of bytes sent and
             * write to the file.
             ********************************************************
             * Ensure that there is a data buffer to write from.
             ********************************************************)
            if not Assigned(pBuffer) then
              begin
                ulErrorRet:=MMIOERR_INVALID_PARAMETER;
                Result:=MMIO_ERROR;
                Exit;
              end;

            Result:=mmioWrite(hmmioSS,pBuffer,Len);
          end
        else
          begin
            (************************************************************
             * Translation is on.
             ************************************************************

            (************************************************************
             * Ensure we do not attempt to write past the end of the
             *    buffer...
             ************************************************************)
            ulImgBytesToWrite:=Min(RGBTotalBytes-RGBPos,Len);

            (************************************************************
             * Write the data into the image buffer.  It will be converted to
             *   RGB, then YUV  when the file is closed.  This allows the
             *   application to seek to arbitrary  positions within the
             *   image in terms of the bits/pel, etc they are writing.
             ************************************************************)
            Move(pBuffer^,RGBBuf^[RGBPos],ulImgBytesToWrite);

            (* Update current position in the image buffer *)
            Inc(RGBPos,ulImgBytesToWrite);
            
            convert_and_save_changes:=true;

            Result:=ulImgBytesToWrite;
          end;

      end; (* with info^, info^.pExtraInfoStruct^ *)

  end; (* xga_Write *)

