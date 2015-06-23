function xga_Unsupported_Message(const info:pmmIOInfo;const usMsg:SmallWord;const lParam1:Longint;const lParam2:Longint):Longint;
  (*
   * If the IOProc has a child IOProc, then pass the message
   *  on to the Child, otherwise return Unsupported Message
   *)
  var
    lRC                 :LONG;

  begin
    (************************************************************
     * Check for valid MMIOINFO block.
     ************************************************************)
    if not Assigned(info) then
      begin
        Result:=MMIO_ERROR;
        Exit;
      end;

    with info^ do
      begin

        ulErrorRet:=MMIOERR_UNSUPPORTED_MESSAGE;
        Result:=MMIOERR_UNSUPPORTED_MESSAGE;

        if Assigned(pExtraInfoStruct) then
          with PMMFILESTATUS(pExtraInfoStruct)^ do
            if hmmioSS<>0 then
             begin
               lRC:=mmioSendMessage(hmmioSS,usMsg,lParam1,lParam2);
               if lRC=0 then
                 ulErrorRet:=mmioGetLastError(hmmioSS);
               Result:=lRC;
             end;

      end;

  end; (* xga_Unsupported_Message *)

