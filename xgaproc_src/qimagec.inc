function xga_QueryImageCount(const info:pmmIOInfo;const ImageCount:pLong):Longint;
  begin

    if not Assigned(info) then
      begin
        Result:=MMIO_ERROR;
        Exit;
      end;

    if not Assigned(ImageCount) then
      begin
        info^.ulErrorRet:=MMIOERR_INVALID_PARAMETER;
        Result:=MMIO_ERROR;
        Exit;
      end;

    ImageCount^:=1;
    Result:=MMIO_SUCCESS;

  end; (* xga_QueryImage *)

