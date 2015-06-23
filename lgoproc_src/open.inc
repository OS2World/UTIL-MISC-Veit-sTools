{-$Define Translate24}
function lgo_Open(const info:pmmIOInfo;const FileName:PChar):Longint;
  var
    ulActualFileLength  :ULONG;
    CurrentFilePos      :ULONG;
    packed_buffer,
    unpacked_buffer     :pByteArray;
    rc                  :LONG;
    hmmioSS_work        :HMMIO;
    fccStorageSystem    :FOURCC;        (* SS I/O Proc FOURCC       *)
    mmioinfoSS          :MMIOINFO;      (* I/O info block for SS ref*)
    x,y                 :Longint;
    w                   :Word;
    plane               :word;
    w1,w2               :word;
    b                   :byte;

  label
    exit_open;

  begin
    packed_buffer:=nil;
    unpacked_buffer:=nil;
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
        {$IfDef LOG_TO_FILE}
        Log_Ausgabe('  ulFlags='+Int2Hex(ulFlags,8));
        Log_Ausgabe('  ulTranslate='+Int2Hex(ulTranslate,8));
        {$EndIf LOG_TO_FILE}
        if  ((ulFlags and MMIO_READWRITE)<>0)
        and (   ((ulTranslate and MMIO_TRANSLATEDATA  )<>0)
             or ((ulTranslate and MMIO_TRANSLATEHEADER)<>0)) then
          begin
            {$IfDef LOG_TO_FILE}
            Log_Ausgabe('  flags invalid.');
            {$EndIf LOG_TO_FILE}
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
                    //Log_Ausgabe('  mmioIdentifyStorageSystem failed.');
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
            //Log_Ausgabe('  open failed.');
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
            //Log_Ausgabe('  DosAllocMem failed.');
            mmioClose(hmmioSS_work,0);
            ulErrorRet:=rc;
            Result:=MMIO_ERROR;
            Exit;
          end;
        (************************************************************
         * Set the fields of the FileStatus structure that the
         * IOProc is responsible for.
         ************************************************************)
        (*InitFileStruct(pVidInfo);*)
        with PMMFILESTATUS(pExtraInfoStruct)^ do
          begin
            hmmioSS:=hmmioSS_work;
            RGBBuf:=nil;
            RGBLineLength:=0;
            RGBTotalBytes:=0;
            RGBPos:=0;
{$IfDef Translate24}
            mmImgHdr.mmXDIBHeader.BMPInfoHeader2.cBitCount:=24;
{$Else}
            mmImgHdr.mmXDIBHeader.BMPInfoHeader2.cBitCount:= 4;
{$EndIf}
            bSetHeader:=false;
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
                rc:=mmioRead(hmmioSS,@lgo_header,SizeOf(lgo_header));
                if rc<>SizeOf(lgo_header) then
                  begin
                    //Log_Ausgabe('  mmioRead(header) failed.');
                    ulErrorRet:=rc;
                    Result:=MMIO_ERROR;
                    goto exit_open;
                  end;

                //Log_Ausgabe('  mmioRead(header) done.');

                CurrentFilePos:=mmioSeek(hmmioSS,0,SEEK_CUR);
                ulActualFileLength:=mmioSeek(hmmioSS,0,SEEK_END);
                mmioSeek(hmmioSS,CurrentFilePos,SEEK_SET);

                with lgo_header do
                  begin
                    if (blocks[0].filepos <>SizeOf(lgo_header)                     )
                    or (blocks[1].filepos <>blocks[0].filepos+blocks[0].packed_size)
                    or (blocks[2].filepos <>blocks[1].filepos+blocks[1].packed_size)
                    or (blocks[3].filepos <>blocks[2].filepos+blocks[2].packed_size)
                    or (ulActualFileLength<>blocks[3].filepos+blocks[3].packed_size)
                    or (blocks[0].packed_size<=0) or (blocks[0].packed_size>max_packed_size)
                    or (blocks[1].packed_size<=0) or (blocks[1].packed_size>max_packed_size)
                    or (blocks[2].packed_size<=0) or (blocks[2].packed_size>max_packed_size)
                    or (blocks[3].packed_size<=0) or (blocks[3].packed_size>max_packed_size)
                     then
                      begin
                        {$IfDef LOG_TO_FILE}
                        Log_Ausgabe('  header not valid');
                        {$EndIf LOG_TO_FILE}
                        ulErrorRet:=MMIOERR_INVALID_PARAMETER;
                        Result:=MMIO_ERROR;
                        goto exit_open;
                      end;

                    {$IfDef LOG_TO_FILE}
                    Log_Ausgabe('  header valid.');
                    {$EndIf LOG_TO_FILE}


                    lgo_x:=640;
                    (* need to unpack before can tell the size.. *)
                    rc:=DosAllocMem2(Pointer(packed_buffer),max_packed_size);
                    if rc<>No_Error then
                      begin
                        {$IfDef LOG_TO_FILE}
                        Log_Ausgabe('  DosAllocMem failed.');
                        {$EndIf LOG_TO_FILE}
                        ulErrorRet:=rc;
                        Result:=MMIO_ERROR;
                        goto exit_open;
                      end;

                    rc:=DosAllocMem2(Pointer(unpacked_buffer),max_unpacked_size);
                    if rc<>No_Error then
                      begin
                        {$IfDef LOG_TO_FILE}
                        Log_Ausgabe('  DosAllocMem failed.');
                        {$EndIf LOG_TO_FILE}
                        ulErrorRet:=rc;
                        Result:=MMIO_ERROR;
                        goto exit_open;
                      end;

                    {$IfDef LOG_TO_FILE}
                    Log_Ausgabe('  unpacked/packed buffer');
                    {$EndIf LOG_TO_FILE}

                    rc:=mmioSeek(hmmioSS,blocks[0].filepos,SEEK_SET);
                    if rc<>blocks[0].filepos then
                      begin
                        //Log_Ausgabe('  mmioSeek failed.');
                        ulErrorRet:=rc;
                        Result:=MMIO_ERROR;
                        goto exit_open;
                      end;

                    {$IfDef LOG_TO_FILE}
                    Log_Ausgabe('  seek set');

                    Log_Ausgabe('  read(,,'+Int2Hex(blocks[0].packed_size,8)+')');
                    Log_Dump('header',blocks,$20);
                    {$EndIf LOG_TO_FILE}

                    rc:=mmioRead(hmmioSS,Pointer(packed_buffer),blocks[0].packed_size);
                    if rc<>blocks[0].packed_size then
                      begin
                        //Log_Ausgabe('  mmioRead failed.');
                        ulErrorRet:=rc;
                        Result:=MMIO_ERROR;
                        goto exit_open;
                      end;

                    {$IfDef LOG_TO_FILE}
                    Log_Ausgabe('  vor EP2');
                    {$EndIf LOG_TO_FILE}

                    rc:=EP2_Decompress(packed_buffer^,
                                       unpacked_buffer^,
                                       blocks[0].packed_size,
                                       max_unpacked_size);
                    {$IfDef LOG_TO_FILE}
                    Log_Ausgabe('  EP2_Decompress rc='+Int2Hex(rc,8));
                    {$EndIf LOG_TO_FILE}
                    if (rc<=0)
                    or ((rc mod (lgo_x div 8))<>0) then
                      begin
                        {$IfDef LOG_TO_FILE}
                        Log_Ausgabe('  EP2_Decompress failed.');
                        {$EndIf LOG_TO_FILE}
                        ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
                        Result:=MMIO_ERROR;
                        goto exit_open;
                      end;

                    lgo_y:=rc div (lgo_x div 8);

                    {$IfDef LOG_TO_FILE}
                    Log_Ausgabe('  lgo_y='+Int2Str(lgo_y));
                    {$EndIf LOG_TO_FILE}

{$IfDef Translate24}
                    RGBBuf_berechnen(lgo_x,lgo_y,24,PMMFILESTATUS(pExtraInfoStruct)^);
{$Else}
                    RGBBuf_berechnen(lgo_x,lgo_y, 4,PMMFILESTATUS(pExtraInfoStruct)^);
{$EndIf}

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
                        ulContentType:={MMIO_IMAGE_PHOTO}MMIO_IMAGE_UNKNOWN;
                        ulMediaType:=MMIO_MEDIATYPE_IMAGE;
                        with mmXDIBHeader.XDIBHeaderPrefix do
                          begin
                            ulMemSize:=RGBTotalBytes;
{$IfDef Translate24}
                            ulPelFormat:=Ord('R') shl  0
                                        +Ord('G') shl  8
                                        +Ord('B') shl 16
                                        +Ord('B') shl 24;
{$Else}
                            ulPelFormat:=Ord('P') shl  0
                                        +Ord('A') shl  8
                                        +Ord('L') shl 16
                                        +Ord('B') shl 24;
{$EndIf}
                            usTransType:=0; (* no transparency *)
                            ulTransVal:=0;
                          end;
                        with mmXDIBHeader.BMPInfoHeader2 do
                          begin
                            cbFix           :=SizeOf(BITMAPINFOHEADER2);
                            cx              := lgo_x;
                            cy              := lgo_y;
                            cPlanes         := 1;
{$IfDef Translate24}
                            cBitCount       := 24;
{$Else}
                            cBitCount       :=  4;
{$EndIf}
                            ulCompression   := BCA_UNCOMP;
                            // padding not needed for 480 columns
                            cbImage         := RGBTotalBytes;
                            cxResolution    := 0;
                            cyResolution    := 0;
                            cclrUsed        := 0; (* all *)
                            cclrImportant   := 0; (* all *)
                            usUnits         := 0;
                            usReserved      := 0;
                            usRecording     := BRA_BOTTOMUP;
                            usRendering     := BRH_NOTHALFTONED;
                            cSize1          := 0;
                            cSize2          := 0;
{$IfDef Translate24}
                            ulColorEncoding := bce_Rgb;
{$Else}
                            ulColorEncoding := bce_Rgb; (* bce_Palette does not work! *)
{$EndIf}
                            ulIdentifier    := 0;
                          end;
                        FillChar(bmiColors,SizeOf(bmiColors),0);
{$IfDef Translate24}
{$Else}
                        for w:=Low(pal16_color) to High(pal16_color) do
                          begin
                            bmiColors[w].bBlue :=pal16_color[w,2];
                            bmiColors[w].bGreen:=pal16_color[w,1];
                            bmiColors[w].bRed  :=pal16_color[w,0];
                          end;
{$EndIf}
                      end;


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
                        rc:=DosAllocMem2(Pointer(RGBBuf),RGBTotalBytes);
                        if rc<>No_Error then
                          begin
                            ulErrorRet:=rc;
                            Result:=MMIO_ERROR;
                            goto exit_open;
                          end;

                        for plane:=Low(blocks) to High(blocks) do
                          with blocks[plane] do
                            begin
                              //Log_Ausgabe('  plane='+Int2Str(plane));
                              rc:=mmioSeek(hmmioSS,filepos,SEEK_SET);
                              if rc<>filepos then
                                begin
                                  ulErrorRet:=rc;
                                  Result:=MMIO_ERROR;
                                  goto exit_open;
                                end;

                              rc:=mmioRead(hmmioSS,Pointer(packed_buffer),packed_size);
                              if rc<>packed_size then
                                begin
                                  ulErrorRet:=rc;
                                  Result:=MMIO_ERROR;
                                  goto exit_open;
                                end;

                              rc:=EP2_Decompress(packed_buffer^,
                                                 unpacked_buffer^,
                                                 packed_size,
                                                 lgo_x*lgo_y div 8);

                              //Log_Ausgabe('EP2_Decompress='+Int2Hex(rc,8));
                              if rc<>lgo_x*lgo_y div 8 then
                                begin
                                  ulErrorRet:=MMIOERR_INVALID_STRUCTURE;
                                  Result:=MMIO_ERROR;
                                  goto exit_open;
                                end;

                              for y:=0 to lgo_y-1 do
                                begin
                                  (* in os2logo source. one byte has 8 bits *)
                                  w1:=y*(lgo_x div 8);
                                  (* in BMP target. one byte has 2 touples of 4 bits *)
                                  w2:=(lgo_y-y-1)*(lgo_x div 2);
                                  (* for each byte(8 pixel of plane) do.. *)
                                  for x:=0 to (lgo_x div 8)-1 do
                                    begin
                                      (* for 8 pixel of this plane *)
                                      b:=unpacked_buffer^[w1+x];
                                      RGBBuf^[w2+x*4+0]:=RGBBuf^[w2+x*4+0]+((b shr 7) and 1) shl (4+plane);
                                      RGBBuf^[w2+x*4+0]:=RGBBuf^[w2+x*4+0]+((b shr 6) and 1) shl (0+plane);
                                      RGBBuf^[w2+x*4+1]:=RGBBuf^[w2+x*4+1]+((b shr 5) and 1) shl (4+plane);
                                      RGBBuf^[w2+x*4+1]:=RGBBuf^[w2+x*4+1]+((b shr 4) and 1) shl (0+plane);
                                      RGBBuf^[w2+x*4+2]:=RGBBuf^[w2+x*4+2]+((b shr 3) and 1) shl (4+plane);
                                      RGBBuf^[w2+x*4+2]:=RGBBuf^[w2+x*4+2]+((b shr 2) and 1) shl (0+plane);
                                      RGBBuf^[w2+x*4+3]:=RGBBuf^[w2+x*4+3]+((b shr 1) and 1) shl (4+plane);
                                      RGBBuf^[w2+x*4+3]:=RGBBuf^[w2+x*4+3]+((b shr 0) and 1) shl (0+plane);
                                    end;
                                end;

                            end; (* with blocks[plane] do *)
{$IfDef Translate24}
                        //Log_Ausgabe('RGBTotalBytes='+Int2Str(RGBTotalBytes));
                        for w1:=(RGBTotalBytes div (3*2))-1 downto 0 do
                          begin
                            b:=RGBBuf^[w1];
                            RGBBuf^[w1*6+0]:=pal16_color[(b shr 4) and $f][2];
                            RGBBuf^[w1*6+1]:=pal16_color[(b shr 4) and $f][1];
                            RGBBuf^[w1*6+2]:=pal16_color[(b shr 4) and $f][0];
                            RGBBuf^[w1*6+3]:=pal16_color[(b shr 0) and $f][2];
                            RGBBuf^[w1*6+4]:=pal16_color[(b shr 0) and $f][1];
                            RGBBuf^[w1*6+5]:=pal16_color[(b shr 0) and $f][0];
                          end;
{$EndIf}

                      end;

                    (********************************************************
                     * RGB buffer now full, set position pointers to the
                     * beginning of the buffer.
                     ********************************************************)
                    RGBPos:=0;

                  end; (* with lgo_header do *)

              end; (* end IF READ block *)

          end; (* info^.pExtraInfoStruct *)
      end; (* info^ *)

    Result:=MMIO_SUCCESS;


  exit_open:

    if Result=MMIO_ERROR then
      begin
        if Assigned(info) then
          with info^ do
            begin
              if Assigned(pExtraInfoStruct) then
                with PMMFILESTATUS(pExtraInfoStruct)^ do
                  begin

                    if hmmioSS<>0 then
                      begin
                        mmioClose(hmmioSS,0);
                        hmmioSS:=0;
                      end;

                    Ensure_Dispose(Pointer(RGBBuf));

                  end; (* pExtraInfoStruct *)

              Ensure_Dispose(pExtraInfoStruct);

            end; (* info *)

      end; (* Result=MMIO_ERROR *)

    Ensure_Dispose(Pointer(unpacked_buffer));
    Ensure_Dispose(Pointer(packed_buffer));

  end; (* lgo_Open *)

