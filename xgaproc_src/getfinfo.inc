function xga_GetFormatInfo(const info:pMMFormatInfo):Longint;
  begin
    (************************************************************
     * Fill in the values for the MMFORMATINFO structure.
     ************************************************************)
    with info^ do
      begin
        ulStructLen:=SizeOf(MMFORMATINFO);
        fccIOProc:=FOURCC_XGA;
        ulIOProcType:=MMIO_IOPROC_FILEFORMAT;
        ulMediaType:=MMIO_MEDIATYPE_IMAGE;
        ulFlags:=   MMIO_CANREADTRANSLATED      or MMIO_CANREADUNTRANSLATED
                 or MMIO_CANWRITETRANSLATED     or MMIO_CANWRITEUNTRANSLATED
              // or MMIO_CANREADWRITETRANSLATED
                                                or MMIO_CANREADWRITEUNTRANSLATED
                 or MMIO_CANSEEKTRANSLATED      or MMIO_CANSEEKUNTRANSLATED
              // or MMIO_CANSAVETRANSLATED      or MMIO_CANSAVEUNTRANSLATED
                ;
        StrCopy(szDefaultFormatExt,xga_ext);
        ulCodePage:=MMIO_DEFAULT_CODE_PAGE;
        ulLanguage:=MMIO_LC_US_ENGLISH;
        lNameLength:=Length(xga_formatname);
      end;

    (************************************************************
     * Return success back to the application.
     ************************************************************)
    Result:=MMIO_SUCCESS;
  end; (* xga_GetFormatInfo *)

