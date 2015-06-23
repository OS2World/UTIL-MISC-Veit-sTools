function xga_SetImage(const info:pmmIOInfo;const ImageIndex:Longint):Longint;
  begin

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

    if ImageIndex=0 then
      begin
        PMMFILESTATUS(info^.pExtraInfoStruct)^.RGBPos:=0;
        Result:=MMIO_SUCCESS
      end
    else
      begin
        info^.ulErrorRet:=MMIOERR_INVALID_PARAMETER;
        Result:=MMIO_ERROR;
      end;


  end; (* xga_QueryImage *)

