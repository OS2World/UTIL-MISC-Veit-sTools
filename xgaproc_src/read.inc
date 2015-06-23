function xga_Read(const info:pmmIOInfo;const pBuffer:pointer;const Len:Longint):Longint;
  var
    lBytesToRead        :LONG;

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
         * Is Translate Data off?
         ************************************************************)
        if (ulTranslate and MMIO_TRANSLATEDATA)=0 then
          begin
            (********************************************************
             * Since no translation, provide exact number of bytes req.
             ********************************************************)
            if not Assigned(pBuffer) then
              begin
                ulErrorRet:=MMIOERR_INVALID_PARAMETER;
                Result:=MMIO_ERROR;
                Exit;
              end;

            Result:=mmioRead(hmmioSS,pBuffer,Len);
          end
        else
          begin

            (************************************************************
             * Otherwise, Translate Data is on...
             ************************************************************)

            (************************************************************
             * Ensure we do NOT write more data out than is remaining
             *    in the buffer.  The length of read was requested in
             *    image bytes, so confirm that there are that many of
             *    virtual bytes remaining.
             ************************************************************)
            lBytesToRead:=Min(Len,RGBTotalBytes-RGBPos);

            (************************************************************
             * Perform this block on ALL reads.  The image data should
             * be in the RGB buffer at this point, and can be handed
             * to the application.
             *
             * Conveniently, the virtual image position is the same
             *    as the RGB buffer position, since both are 24 bit-RGB
             ************************************************************)
            Move(RGBBuf^[RGBPos],pBuffer^,lBytesToRead);

            (************************************************************
             * Move RGB buffer pointer forward by number of bytes read.
             * The Img buffer pos is identical since both are 24 bits.
             ************************************************************)
            Inc(RGBPos,lBytesToRead);

            Result:=lBytesToRead;

          end;

      end; (* with info^, info^.pExtraInfoStruct^ *)

  end; (* xga_Read *)

