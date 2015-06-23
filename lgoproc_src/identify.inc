function lgo_IdentifyFile(const info:pmmIOInfo;const FileName:PChar;const Handle:hmmio):Longint;
  var
    lgo_header          :t_lgo_header;   (* M-Motion structure variable *)
    hmmioTemp           :HMMIO;    (* MMIO File Handle            *)
    ulWidth             :ULONG;
    ulHeight            :ULONG;
    ulRequiredFileLength:ULONG;
    ulActualFileLength  :ULONG;
    CurrentFilePos      :ULONG;
    fValidMMotionFile   :BOOL;

  const
    ulTempFlags         :ULONG  = MMIO_READ or MMIO_DENYWRITE or MMIO_NOIDENTIFY;
                                   (* Flags used for temp open  *)
                                   (* and close                 *)

  procedure close_private;
    begin
      if Handle=0 then (* Don't close handle if provided to us  *)
        mmioClose(hmmioTemp,0);
    end;

  begin
    fValidMMotionFile := FALSE;

    (************************************************************
     * We need either a file name (lParam1) or file handle (lParam2)
     ************************************************************)
    if not Assigned(FileName) and (Handle=0) then
      begin
        Result:=MMIO_ERROR;
        Exit;
      end;

    (* Copy the file handle, assuming one was provided... *)
    hmmioTemp := Handle;

    (************************************************************
     * If no handle, then open the file using the string name
     ************************************************************)
    if hmmioTemp=0 then
      begin
        hmmioTemp:=mmioOpen(FileName,nil,ulTempFlags);
        if hmmioTemp=0 then
          begin
            Result:=MMIO_ERROR;
            Exit;
          end;
      end;

    (************************************************************
     * Read in enough bytes to check out file.
     ************************************************************)
    if SizeOf(lgo_header)<>mmioRead(hmmioTemp,@lgo_header,SizeOf(lgo_header)) then
        (********************************************************
         * Fail so close file and then return.
         ********************************************************)
      begin
        close_private;
        Result:=MMIO_ERROR;
        Exit;
      end;

    (************************************************************
     * Check validity of file and return result.
     ************************************************************)

     CurrentFilePos:=mmioSeek(hmmioTemp,0,SEEK_CUR);
     ulActualFileLength:=mmioSeek(hmmioTemp,0,SEEK_END);
     mmioSeek(hmmioTemp,CurrentFilePos,SEEK_SET);


    with lgo_header do
      fValidMMotionFile:=
          (blocks[0].filepos =SizeOf(lgo_header)                     )
      and (blocks[1].filepos =blocks[0].filepos+blocks[0].packed_size)
      and (blocks[2].filepos =blocks[1].filepos+blocks[1].packed_size)
      and (blocks[3].filepos =blocks[2].filepos+blocks[2].packed_size)
      and (ulActualFileLength=blocks[3].filepos+blocks[3].packed_size)
      and (blocks[0].packed_size>0) and (blocks[0].packed_size<=max_packed_size)
      and (blocks[1].packed_size>0) and (blocks[1].packed_size<=max_packed_size)
      and (blocks[2].packed_size>0) and (blocks[2].packed_size<=max_packed_size)
      and (blocks[3].packed_size>0) and (blocks[3].packed_size<=max_packed_size);

    (************************************************************
     * Close file before returning.
     ************************************************************)
    close_private;

    if fValidMMotionFile then
      Result:=MMIO_SUCCESS
    else
      Result:=MMIO_ERROR;

  end; (* lgo_IdentifyFile *)

