function xga_Seek(const info:pmmIOInfo;const lPosDesired:Longint;const sSeekMode:Longint):Longint;
  var
    lNewFilePosition    :LONG;

  begin
    (************************************************************
     * Check to make sure MMIOINFO block is valid.
     ************************************************************)
    if not Assigned(info) then
      begin
        Result:=MMIO_ERROR;
        Exit;
      end;

    with info^,PMMFILESTATUS(info^.pExtraInfoStruct)^ do
      begin

        (************************************************************
         * Is Translate Data on?
         ************************************************************)
        if (ulTranslate and MMIO_TRANSLATEDATA)<>0 then
          begin
            (********************************************************
             * Attempt to move the Image buffer pointer to the
             * desired location.  App sends SEEK requests in
             * positions relative to the image planes & bits/pel
             * We must also convert this to RGB positions
             ********************************************************)
            case sSeekMode of
              SEEK_SET:lNewFilePosition:=              lPosDesired;
              SEEK_CUR:lNewFilePosition:=RGBPos       +lPosDesired;
              SEEK_END:lNewFilePosition:=RGBTotalBytes+lPosDesired;
            else
              ulErrorRet:=MMIOERR_INVALID_PARAMETER;
              Result:=MMIO_ERROR;
              Exit;
            end;

            (********************************************************
             * Make sure seek did not go before start of file.
             * If so, then don't change anything, just return an error
             ********************************************************)
            if lNewFilePosition<0 then
              begin
                ulErrorRet:=MMIOERR_SEEK_BEFORE_BEGINNING;
                Result:=MMIO_ERROR;
                Exit;
              end;

            (********************************************************
             * Make sure seek did not go past the end of file.
             ********************************************************)
            RGBPos:=Min(lNewFilePosition,RGBTotalBytes);

            Result:=RGBPos;
          end (* end  IF DATA TRANSLATED *)
        else
          begin

            (************************************************************
             * Translate Data is OFF...
             ************************************************************
             * if this is a seek from the beginning of the file,
             *    we must account for and pass the header
             ************************************************************)
            if sSeekMode=SEEK_SET then
              lNewFilePosition:=SizeOf(t_xga_header)+lPosDesired
            else
              lNewFilePosition:=lPosDesired;

            lNewFilePosition:=mmioSeek(hmmioSS,lNewFilePosition,sSeekMode);

            (********************************************
             * Ensure we did not move to within the header
             ********************************************)
            if lNewFilePosition<>MMIO_ERROR then
              if lNewFilePosition<SizeOf(t_xga_header) then
                lNewFilePosition:=mmioSeek(hmmioSS,SizeOf(t_xga_header),SEEK_SET);

            (************************************************************
             * Return new position.  Always remove the length of the
             *    header from the this position value
             ************************************************************)
            if lNewFilePosition<>MMIO_ERROR then
               Dec(lNewFilePosition,SizeOf(t_xga_header));

            Result:=lNewFilePosition;

          end;

      end; (* with info^, info^.pExtraInfoStruct *)

  end; (* xga_Seek *)

