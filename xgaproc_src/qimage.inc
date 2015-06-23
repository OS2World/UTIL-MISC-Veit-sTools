function xga_QueryImage(const info:pmmIOInfo;const ImageCurrent:pLong):Longint;
  begin

    if not Assigned(info) then
      begin
        Result:=MMIO_ERROR;
        Exit;
      end;

    if not Assigned(ImageCurrent) then
      begin
        info^.ulErrorRet:=MMIOERR_INVALID_PARAMETER;
        Result:=MMIO_ERROR;
        Exit;
      end;

    ImageCurrent^:=0;
    Result:=MMIO_SUCCESS;

  end; (* xga_QueryImage *)

