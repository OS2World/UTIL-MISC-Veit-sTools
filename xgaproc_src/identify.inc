function xga_IdentifyFile(const info:pmmIOInfo;const FileName:PChar;const Handle:hmmio):Longint;
  var
    xga_header          :t_xga_header;   (* M-Motion structure variable *)
    hmmioTemp           :HMMIO;    (* MMIO File Handle            *)
    ulWidth             :ULONG;
    ulHeight            :ULONG;
    ulRequiredFileLength:ULONG;
    ulActualFileLength  :ULONG;
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
    if SizeOf(xga_header)<>mmioRead(hmmioTemp,@xga_header,SizeOf(xga_header)) then
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

    fValidMMotionFile:=false;
    with xga_header do
      if  (signature=xga_signature)
      and (kopflaenge=SizeOf(xga_header))
      and (datenlaenge=bild_x*bild_y*2)
       then
        begin
          ulWidth:=bild_x;
          ulHeight:=bild_y;

        (* Calculate what the length of the file SHOULD be based on the *)
        (*   header contents                                            *)
        ulRequiredFileLength:=xga_header.kopflaenge+xga_header.datenlaenge;

        (* Query what the ACTUAL length of the file is                  *)
        ulActualFileLength:=mmioSeek(hmmioTemp,0,SEEK_END);

        (* If these don't match, then it isn't a VALID M-Motion file    *)
        (*     - regardless of what the header says.                    *)
        fValidMMotionFile:=(ulRequiredFileLength=ulActualFileLength);
      end;  (* end header check block *)

    (************************************************************
     * Close file before returning.
     ************************************************************)
    close_private;

    if fValidMMotionFile then
      Result:=MMIO_SUCCESS
    else
      Result:=MMIO_ERROR;

  end; (* xga_IdentifyFile *)

