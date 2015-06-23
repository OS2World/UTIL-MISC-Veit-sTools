// OS/2 boot logo file format procedure for MMOS2
// 2005.02.16..2005.06.27 Veit Kannegieser
// based on MMIOPROC - IBM C sample code
//          XGAPROC
//          mmref - IPF documentation
//          OS2KRNL - disassebly for palettes and decompression
//          LxLite - understanding the compression
// note: do not use functions that use thread local variables
//       avoid memory leaks even when having paramter errors, out of memory situations
//       please mind that some comments are still for MMOTION image format

{$Use32+,Delphi+}
unit lgofunc;

interface

{&CDecl+}
function LGO_Proc_EntryF(const pmmioStr  :pointer;
                         const usMessage :SmallWord;
                         const lParam1   :Longint;
                         const lParam2   :Longint):Longint;
{&CDecl-}

implementation

uses
  Os2mm,
  Os2Def,
  Os2Base,
  Os2PmApi,
  Strings,
  VpUtils,
  {$IfDef LOG_TO_FILE}
  Log,
  {$EndIf LOG_TO_FILE}
  LGO;

const
  FOURCC_LGO            =Ord('O')+Ord('L') shl 8+Ord('G') shl 16+Ord('O') shl 24;
  lgo_ext               ='LGO';
  lgo_formatname        ='OS/2 boot logo image';
  SEEK_SET              =0;
  SEEK_CUR              =1;
  SEEK_END              =2;

//RGB                   =packed record r,g,b:byte end;

type
  pMMFileStatus         =^tMMFileStatus;
  tMMFileStatus         =
    record
      lgo_x             :word;
      lgo_y             :word;

      RGBBuf            :pByteArray;            (* 24-bit RGB Buf for trans data *)
      RGBLineLength     :Longint;
      RGBLineLengthPad  :Longint;
      RGBTotalBytes     :Longint;               (* Length of 24-bit RGBBuf      *)
      RGBPos            :Longint;

      bSetHeader        :boolean;               (* TRUE if header set in WRITE mode *)

      convert_and_save_changes:boolean;

      (* MMIO handle to Storage System IOProc that provides data.               *)
      hmmioSS           :HMMIO;

      mmImgHdr          :MMIMAGEHEADER;         (* Standard image header        *)
      lgo_header        :t_lgo_header;          (* Custom image header          *)
    end;

(* non-inlined(safe) Max/Min functions to replace VpUtils.. *)
function Max(const a,b:longint):longint;
  begin
    Result:=a;
    if b>Result then
      Result:=b;
  end;
function Min(const a,b:longint):longint;
  begin
    Result:=a;
    if b<Result then
      Result:=b;
  end;

procedure RGBBuf_berechnen(const x,y,b:word;var fs:tMMFileStatus);
  begin
    with fs do
      begin
        lgo_x:=x;
        lgo_y:=y;

        RGBLineLength:=(lgo_x*b+7) div 8;
        RGBLineLengthPad:=(RGBLineLength+3) and -4;
        RGBTotalBytes:=RGBLineLengthPad*lgo_y;
        RGBPos:=0;

      end;
  end;

function DosAllocMem2(var p:pointer;const s:longint):longint;
  begin
    Result:=DosAllocMem(p,s,HeapAllocFlags);

    (* not sure if FillChar is needed, or if the pages are always zeroed *)
    (* better to do it here than scattered through the source *)
    if Result=No_Error then
      FillChar(p^,s,0);
  end;

procedure Ensure_Dispose(var p:pointer);
  begin
    if Assigned(p) then
      begin
        DosFreeMem(p);
        p:=nil;
      end;
  end;

function PMError(const b:boolean;const ab:hab):longint;
  begin
    if b then
      Result:=0
    else
      Result:=WinGetLastError(ab);
  end;


{$I close.inc   } (* lgo_Close                  *)
{$I open.inc    } (* lgo_Open                   *)
{$I read.inc    } (* lgo_Read                   *)
{$I seek.inc    } (* lgo_Seek                   *)
{$I write.inc   } (* lgo_Write                  *)
{$I identify.inc} (* lgo_IdentifyFile           *)
{$I geth.inc    } (* lgo_GetHeader              *)
{$I seth.inc    } (* lgo_SetHeader              *)
{$I queryhl.inc } (* lgo_QueryHeaderLength      *)
{$I getfname.inc} (* lgo_GetFormatName          *)
{$I getfinfo.inc} (* lgo_GetFormatInfo          *)
{ I save.inc    } (* lgo_Save                   *)
{$I qimage.inc  } (* lgo_QueryImage             *)
{$I qimagec.inc } (* lgo_QueryImageCount        *)
{$I setimage.inc} (* lgo_SetImage               *)
{$I unsuppor.inc} (* lgo_Unsupported_Message    *)



function LGO_Proc_EntryF(const pmmioStr  :pointer;
                         const usMessage :SmallWord;
                         const lParam1   :Longint;
                         const lParam2   :Longint):Longint;
  begin
    {$IfDef LOG_TO_FILE}
    Log_Ausgabe('* LGO_Proc_Entry('+Ptr2hex(pmmioStr)+','+MMIOM_Name(usMessage)+','+Int2Hex(lParam1,8)+','+Int2Hex(lParam2,8)+')');
    {$EndIf LOG_TO_FILE}
    case usMessage of
      MMIOM_CLOSE               :Result:=lgo_Close(pmmioStr,lParam1);
      MMIOM_OPEN                :Result:=lgo_Open(pmmioStr,Ptr(lParam1));
      MMIOM_READ                :Result:=lgo_Read(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_SEEK                :Result:=lgo_Seek(pmmioStr,lParam1,lParam2);
      MMIOM_WRITE               :Result:=lgo_Write(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_IDENTIFYFILE        :Result:=lgo_IdentifyFile(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_GETHEADER           :Result:=lgo_GetHeader(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_SETHEADER           :Result:=lgo_SetHeader(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_QUERYHEADERLENGTH   :Result:=lgo_QueryHeaderLength(pmmioStr);
      MMIOM_GETFORMATNAME       :Result:=lgo_GetFormatName(Ptr(lParam1),lParam2);
      MMIOM_GETFORMATINFO       :Result:=lgo_GetFormatInfo(Ptr(lParam1));
    //MMIOM_SAVE                :Result:=lgo_Save(pmmioStr,Ptr(lParam1));
      MMIOM_QUERYIMAGE          :Result:=lgo_QueryImage(pmmioStr,Pointer(lParam1));
      MMIOM_QUERYIMAGECOUNT     :Result:=lgo_QueryImageCount(pmmioStr,Ptr(lParam1));
      MMIOM_SETIMAGE            :Result:=lgo_SetImage(pmmioStr,lParam1);
    else
                                 Result:=lgo_Unsupported_Message(pmmioStr,usMessage,lParam1,lParam2);
    end;
    {$IfDef LOG_TO_FILE}
    Log_Ausgabe('  LGO_Proc_Entry('+Ptr2hex(pmmioStr)+','+MMIOM_Name(usMessage)+','+Int2Hex(lParam1,8)+','+Int2Hex(lParam2,8)+')='+Int2Hex(Result,8));
    {$EndIf LOG_TO_FILE}
  end;

end.

