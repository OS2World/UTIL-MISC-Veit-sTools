function lgo_GetHeader(const info:pmmIOInfo;const pHeader:Pointer;const Len:Longint):Longint;

  begin
    (************************************************************
     * Check for valid MMIOINFO block.
     ************************************************************)
    if not Assigned(info) then
      begin
        Result:=0; // failure
        Exit;
      end;

    with info^,PMMFILESTATUS(info^.pExtraInfoStruct)^ do
      begin

        (**************************************************
         * Getheader only valid in READ or READ/WRITE mode.
         * There is no header to get in WRITE mode.  We
         * must also have a valid file handle to read from
         **************************************************)
        if (ulFlags and MMIO_READ)=0 then
          begin
            ulErrorRet:=MMIOERR_INVALID_FILE;
            Result:=0; // failure
            Exit;
          end;

        if hmmioSS=0 then
          begin
            ulErrorRet:=MMIOERR_INVALID_HANDLE;
            Result:=0; // failure
            Exit;
          end;

        (************************************************************
         * Check for Translation mode.
         ************************************************************)
        if (ulTranslate and MMIO_TRANSLATEHEADER)=0 then
          begin
            (********************************************************
             * Translation is off.
             ********************************************************)
            if Len<SizeOf(lgo_header) then
              begin
                ulErrorRet:=MMIOERR_INVALID_BUFFER_LENGTH;
                Result:=0; // failure
                Exit;
              end;

            if not Assigned(pHeader) then
              begin
                ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
                Result:=0; // failure
                Exit;
              end;

            (********************************************************
             * Read in first 16 bytes to fill up M-Motion header.
             ********************************************************)
            p_lgo_header(pHeader)^:=lgo_header;
            //Log_Dump('GetHeader (untranslated):',lgo_header,SizeOf(lgo_header));

            (* Indicate that the header has been set, which    *)
            (* is meaningless in read mode, but allows the     *)
            (* application to do writes in read/write mode     *)
            bSetHeader:=TRUE;

            Result:=SizeOf(lgo_header);
          end   (* end IF NOT TRANSLATED block *)
        else
          begin
            (******************
             * TRANSLATION IS ON
             ******************)
            if Len<SizeOf(MMIMAGEHEADER) then
              begin
                ulErrorRet:=MMIOERR_INVALID_BUFFER_LENGTH;
                Result:=0; // failure
                Exit;
              end;

            if not Assigned(pHeader) then
              begin
                ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
                Result:=0; // failure
                Exit;
              end;

            PMMIMAGEHEADER(pHeader)^:=mmImgHdr;
            //Log_Dump('GetHeader (translated):',mmImgHdr,SizeOf(mmImgHdr));

            Result:=SizeOf(mmImgHdr);
          end; (* end case of MMIOM_GETHEADER *)

      end; (* info^ *)

  end; (* lgo_GetHeader *)
