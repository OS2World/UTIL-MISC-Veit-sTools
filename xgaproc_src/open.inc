function xga_Open(const info:pmmIOInfo;const FileName:PChar):Longint;
  var
    ulRequiredFileLength:ULONG;
    ulActualFileLength  :ULONG;
    ulWidth             :ULONG;
    ulHeight            :ULONG;
    xga_buf             :pWordArray;
    rc                  :LONG;
    hmmioSS_work        :HMMIO;
    RGBBuf_idx          :longint;
    fccStorageSystem    :FOURCC;   (* SS I/O Proc FOURCC       *)
    mmioinfoSS          :MMIOINFO;         (* I/O info block for SS ref*)
    x,y                 :Longint;
    w                   :Word;
    Remap31             :array[0..31] of byte;
    Remap63             :array[0..63] of byte;
  begin
    (************************************************************
     * Check for valid MMIOINFO block.
     ************************************************************)
    if not Assigned(info) then
      begin
        Result:=MMIO_ERROR;
        Exit;
      end;
    (************************************************************
     * If flags show read and write then send back an error.  We
     * only support reading or writing but not both at the same
     * time on the same file.
     ************************************************************)
    with info^ do
      begin
        if  ((ulFlags and MMIO_READWRITE)<>0)
        and (   ((ulTranslate and MMIO_TRANSLATEDATA  )<>0)
             or ((ulTranslate and MMIO_TRANSLATEHEADER)<>0)) then
          begin
            ulErrorRet:=MMIOERR_INVALID_ACCESS_FLAG;
            Result:=MMIO_ERROR;
            Exit;
          end;
        (*********************************************************
         *   Determine the storage system/child IOProc that actually
         *   obtains the data for us.  The M-Motion data may be contained
         *   in a memory (RAM) file, as a component in a database or
         *   library (a Compound file), or as a stand-alone disk file.
         *
         *   While the application uses this M-Motion IOProc to obtain
         *   untranslated (M-Motion) or translated (bitmap) data,
         *   the IOProc must obtain it's data from something that
         *   reads and writes to a storage media.  The exact storage
         *   media is immaterial - so long as the read and write
         *   operations generate data that LOOKS like it is part
         *   of a standard file.
         *********************************************************)
        if fccChildIOProc=0 then
          begin
            (* Need to determine SS if create from pmmioinfo and filename. *)
            if (ulFlags and MMIO_CREATE)<>0 then
              begin
                if mmioDetermineSSIOProc(FileName,info,@fccStorageSystem,nil)<>0 then
                  fccStorageSystem:={FOURCC_DOS}HEX_FourCC_DOS;
              end
            else
              begin
                rc:=mmioIdentifyStorageSystem(FileName,info,@fccStorageSystem);
                if rc<>0 then
                  begin
                    ulErrorRet:=rc; (* MMIOERR_INVALID_FILENAME? *)
                    Result:=MMIO_ERROR;
                    Exit;
                  end;
              end;

           if fccStorageSystem=0 then
             begin
               ulErrorRet:=MMIOERR_INVALID_FILENAME;
               Result:=MMIO_ERROR;
               Exit;
             end
           else
             fccChildIOProc:=fccStorageSystem;

          end; (* end storage system identification block *)

        (**************************************************************
         * Direct the open to the specific storage system necessary
         **************************************************************)
        mmioinfoSS:=info^;
        mmioinfoSS.pIOProc:=nil;
        mmioinfoSS.fccIOProc:=fccChildIOProc;
        mmioinfoSS.ulFlags:=mmioinfoSS.ulFlags or MMIO_NOIDENTIFY;
        (************************************************************
         * Try to open the file.  Add the NO IDENTIFY flag to
         *    ENSURE THAT WE DON'T LOOP RECURSIVELY!!!
         ************************************************************)
        hmmioSS_work:=mmioOpen(FileName,@mmioinfoSS,mmioinfoSS.ulFlags);
        (************************************************************
         * Check if a DELETE was requested - mmioOpen returns a 1,
         *    so we much check this separately
         ************************************************************)
        if (ulFlags and MMIO_DELETE)<>0 then
          begin
            (* was the delete successful?         *)
            if hmmioSS_work<>0 then
              begin
                ulErrorRet:=MMIOERR_DELETE_FAILED;
                Result:=MMIO_ERROR;
                Exit;
              end
            else
              begin
                Result:=MMIO_SUCCESS;
                Exit;
              end;
          end;
        (************************************************************
         * Check the return code from the open call for an error.
         *    If not delete, then the open should have worked.
         ************************************************************)
        if hmmioSS_work=0 then
          begin
            ulErrorRet:=mmioinfoSS.ulErrorRet;
            Result:=MMIO_ERROR;
            Exit;
          end;
        (************************************************************
         * Allocate memory for one M-Motion FileStatus structures
         ************************************************************)
        rc:=DosAllocMem2(Pointer(pExtraInfoStruct),SizeOf(TMMFILESTATUS));
        (************************************************************
         * Ensure the allocate was successful.  If not, then
         *   close the file and return open as unsuccessful...
         ************************************************************)
        if rc<>No_Error then
          begin
            mmioClose(hmmioSS_work,0);
            ulErrorRet:=MMIOERR_OUTOFMEMORY;
            Result:=MMIO_ERROR;
            Exit;
          end;
        FillChar(pExtraInfoStruct^,SizeOf(TMMFILESTATUS),0);
        (************************************************************
         * Set the fields of the FileStatus structure that the
         * IOProc is responsible for.
         ************************************************************)
        (*InitFileStruct(pVidInfo);*)
        with PMMFILESTATUS(pExtraInfoStruct)^ do
          begin
            hmmioSS:=hmmioSS_work;
            RGBBuf:=nil;
            RGBLineLengthPad:=0;
            RGBTotalBytes:=0;
            RGBPos:=0;
            mmImgHdr.mmXDIBHeader.BMPInfoHeader2.cBitCount    := 24;
            bSetHeader                       := FALSE;
            convert_and_save_changes:=false;

            (*********************************************************
             * If this is a read, we need to check that is a M-Motion
             *    file and perhaps get the data.
             *********************************************************)
            if (ulFlags and MMIO_READ)<>0 then
              begin
                (*********************************************************
                 * First we must get some basic information from the file
                 * Read in data to fill up the MMOTIONHEADER structure.
                 *
                 * If the read is unsuccessful, this is not a M-Motion file
                 * and we should return a failure on the open
                 *********************************************************)
                  if SizeOf(xga_header)<>mmioRead(hmmioSS,@xga_header,SizeOf(xga_header)) then
                    begin
                      mmioClose(hmmioSS,0);
                      Ensure_Dispose(pExtraInfoStruct);
                      ulErrorRet:=MMIOERR_READ_FAILED;
                      Result:=MMIO_ERROR;
                      Exit;
                    end;

                (* Ensure this IS an M-Motion file header before we continue  *)
                with xga_header do
                  if (signature<>xga_signature)
                  or (kopflaenge<>SizeOf(xga_header))
                  or (datenlaenge<>bild_x*bild_y*2)
                   then
                    begin
                      mmioClose(hmmioSS,0);
                      Ensure_Dispose(pExtraInfoStruct);
                      ulErrorRet:=MMIOERR_INVALID_PARAMETER;
                      Result:=MMIO_ERROR;
                      Exit;
                    end;
                (********************************************************
                 * Set up width and height of image.
                 ********************************************************)
                ulWidth:=xga_header.bild_x;
                ulHeight:=xga_header.bild_y;
                (* Calculate what the length of the file SHOULD be based on the *)
                (*   header contents                                            *)
                ulRequiredFileLength:=xga_header.kopflaenge+xga_header.datenlaenge;
                (* Query what the ACTUAL length of the file is,                 *)
                (*   then move back to just after the header.                   *)
                ulActualFileLength:=mmioSeek(hmmioSS,0,SEEK_END);
                mmioSeek(hmmioSS,SizeOf(xga_header),SEEK_SET);
                (* If these don't match, then it isn't a VALID M-Motion file    *)
                (*    - regardless of what the header says.                     *)
                if ulRequiredFileLength<>ulActualFileLength then
                  begin
                    mmioClose(hmmioSS,0);
                    Ensure_Dispose(pExtraInfoStruct);
                    ulErrorRet:=MMIOERR_INVALID_BUFFER_LENGTH;
                    Result:=MMIO_ERROR;
                    Exit;
                  end;

                (************************************************************
                 * If the app intends to read in translation mode, we must
                 * allocate and set-up the buffer that will contain the RGB data.
                 *
                 * We must also read in the data to insure that the first
                 * read, seek, or get-header operation will have data
                 * to use.  This is ONLY NECESSARY FOR TRANSLATED MODE
                 * operations, since we must process reads/writes pretending
                 * the image is stored from the bottom-up.
                 *
                 ************************************************************
                 ************************************************************
                 * Fill out the MMIMAGEHEADER structure.
                 ************************************************************)
                with MMImgHdr do
                  begin
                    ulHeaderLength:=SizeOf(MMIMAGEHEADER);
                    ulContentType:=MMIO_IMAGE_PHOTO;
                    ulMediaType:=MMIO_MEDIATYPE_IMAGE;
                    FillChar(mmXDIBHeader.XDIBHeaderPrefix,SizeOf(mmXDIBHeader.XDIBHeaderPrefix),0);
                    with mmXDIBHeader.BMPInfoHeader2 do
                      begin
                        cbFix           :=SizeOf(BITMAPINFOHEADER2);
                        cx              := ulWidth;
                        cy              := ulHeight;
                        cPlanes         := 1;
                        cBitCount       := 24;
                        ulCompression   := BCA_UNCOMP;
                        // padding??
                        cbImage         := (ulWidth * ulHeight * 3 +3) and -4;
                        cxResolution    := 0;
                        cyResolution    := 0;
                        cclrUsed        := 0;
                        cclrImportant   := 0;
                        usUnits         := 0;
                        usReserved      := 0;
                        usRecording     := BRA_BOTTOMUP;
                        usRendering     := BRH_NOTHALFTONED;
                        cSize1          := 0;
                        cSize2          := 0;
                        ulColorEncoding := bce_RGB;
                        ulIdentifier    := 0;
                      end;
                    FillChar(bmiColors,SizeOf(bmiColors),0);
                  end;

                RGBLineLengthPad:=(ulWidth*3+3) and -4;
                RGBTotalBytes:=RGBLineLengthPad*ulHeight;
                RGBPos:=0;

                (*********************************************************
                 * For translated data READ mode, we must allocate a buffer,
                 * get the YUV data from the file, and load the RGB buffer.
                 * Place format-specific code here to load the image into the
                 * buffer.  The code below is M-Motion format specific.
                 *********************************************************)
                if (ulTranslate and MMIO_TRANSLATEDATA)<>0 then
                  begin
                    (********************************************************
                     * Get space for full image buffer.
                     * This will be retained until the file is closed.
                     ********************************************************)
                    if DosAllocMem2(Pointer(RGBBuf),RGBTotalBytes)<>No_Error then
                      begin
                        mmioClose(hmmioSS,0);
                        Ensure_Dispose(pExtraInfoStruct);
                        ulErrorRet:=MMIOERR_OUTOFMEMORY;
                        Result:=MMIO_ERROR;
                        Exit;
                      end;

                    (**********************************************************
                     * Get temporary space for complete untranslated image data
                     **********************************************************)
                    if DosAllocMem2(Pointer(xga_buf),xga_header.datenlaenge)<>No_Error then
                      begin
                        mmioClose(hmmioSS,0);
                        Ensure_Dispose(pExtraInfoStruct);
                        Ensure_Dispose(Pointer(RGBBuf));
                        ulErrorRet:=MMIOERR_OUTOFMEMORY;
                        Result:=MMIO_ERROR;
                        Exit;
                      end;

                    rc:=mmioRead(hmmioSS,Pointer(xga_buf),xga_header.datenlaenge);

                    for x:=0 to 31 do Remap31[x]:=Round(x*255/31);
                    for x:=0 to 63 do Remap63[x]:=Round(x*255/63);

                    RGBBuf_idx:=0;

                    //for y:=xga_header.bild_y-1 downto 0 do
                    for y:=0 to xga_header.bild_y-1 do
                      begin

                        for x:=0 to xga_header.bild_x-1 do
                          begin
                            w:=xga_buf^[x+y*xga_header.bild_x];
                            RGBBuf^[RGBBuf_idx]:=Remap31[(w shr  0) and $1f];
                            Inc(RGBBuf_idx);
                            RGBBuf^[RGBBuf_idx]:=Remap63[(w shr  5) and $3f];
                            Inc(RGBBuf_idx);
                            RGBBuf^[RGBBuf_idx]:=Remap31[(w shr 11) and $1f];
                            Inc(RGBBuf_idx);
                          end;

                        while (RGBBuf_idx and 3)<>0 do
                          begin
                            RGBBuf^[RGBBuf_idx]:=0;
                            Inc(RGBBuf_idx);
                          end;
                      end;

                    Ensure_Dispose(Pointer(xga_buf));

                    (********************************************************
                     * RGB buffer now full, set position pointers to the
                     * beginning of the buffer.
                     ********************************************************)
                    RGBPos:=0;

                  end;   (*  end IF TRANSLATED block *)
               end; (* end IF READ block *)

          end; (* info^.pExtraInfoStruct *)
      end; (* info^ *)

    Result:=MMIO_SUCCESS;

  end; (* xga_Open *)

