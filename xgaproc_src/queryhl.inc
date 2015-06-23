function xga_QueryHeaderLength(const info:pmmIOInfo):Longint;
  begin
    (************************************************************
     * If there is no MMIOINFO block then return an error.
     ************************************************************)
    if not Assigned(info) then
      begin
        Result:=0; // failure
        Exit;
      end;

    (************************************************************
     * If header is in translated mode then return the media
     * type specific structure size.
     ************************************************************)
    if (info^.ulTranslate and MMIO_TRANSLATEHEADER)<>0 then
      Result:=SizeOf(MMIMAGEHEADER)
    else
        (********************************************************
         * Header is not in translated mode so return the size
         * of the M-Motion header.
         ********************************************************)
      Result:=SizeOf(t_xga_header);

  end; (* xga_QueryHeaderLength *)

