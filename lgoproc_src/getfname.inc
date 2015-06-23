function lgo_GetFormatName(const FormatName:PChar;const Len:Longint):Longint;
  begin
    if (Len<=0) or (not Assigned(FormatName)) then
      Result:=0 // failure
    else
      begin
        FillChar(FormatName^,Len,#0);
        StrLCopy(FormatName,lgo_formatname,Len-1);
        Result:=StrLen(FormatName);
      end;
  end; (* lgo_GetFormatName *)
