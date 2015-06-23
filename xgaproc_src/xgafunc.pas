// OS/2 boot logo file format procedure for MMOS2
// 2005.02.01..2005.06.27 Veit Kannegieser
// based on MMIOPROC - IBM C sample code
//          XGA_PPM - command line converter
//          mmref - IPF documentation
// note: do not use functions that use thread local variables
//       avoid memory leaks even when having paramter errors, out of memory situations
//       please mind that some comments are still for MMOTION image format

{$Use32+,Delphi+}
unit xgafunc;

interface

{&CDecl+}
function XGA_Proc_EntryF(const pmmioStr  :pointer;
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
  XGA;

const
  FOURCC_XGA            =Ord('X')+Ord('G') shl 8+Ord('A') shl 16+Ord(' ') shl 24;
  xga_ext               ='XGA';
//xga_formatname        ='Phoenix PhDisk Save2Dsk.XGA hibernate progress image';
//xga_formatname        ='XGA image';
  xga_formatname        ='Phoenix hibernate image';
  SEEK_SET              =0;
  SEEK_CUR              =1;
  SEEK_END              =2;

type
  pByte                 =^Byte;
  tByteArray            =packed array[0..High(Longint)] of Byte;
  pByteArray            =^tByteArray;
  tWordArray            =packed array[0..High(Longint) div 2] of SmallWord;
  pWordArray            =^tWordArray;

//RGB                   =packed record r,g,b:byte end;

  pMMFileStatus         =^tMMFileStatus;
  tMMFileStatus         =
    record

      RGBBuf            :pByteArray;            (* 24-bit RGB Buf for trans data *)
      RGBLineLengthPad  :Longint;
      RGBTotalBytes     :Longint;               (* Length of 24-bit RGBBuf      *)
      RGBPos            :Longint;

      bSetHeader        :BOOL;                  (* TRUE if header set in WRITE mode *)

      convert_and_save_changes:boolean;

      (* MMIO handle to Storage System IOProc that provides data.               *)
      hmmioSS           :HMMIO;

      mmImgHdr          :MMIMAGEHEADER;         (* Standard image header        *)
      xga_header        :t_xga_header;          (* Custom image header          *)
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
    


{$I close.inc   } (* xga_Close                  *)
{$I open.inc    } (* xga_Open                   *)
{$I read.inc    } (* xga_Read                   *)
{$I seek.inc    } (* xga_Seek                   *)
{$I write.inc   } (* xga_Write                  *)
{$I identify.inc} (* xga_IdentifyFile           *)
{$I geth.inc    } (* xga_GetHeader              *)
{$I seth.inc    } (* xga_SetHeader              *)
{$I queryhl.inc } (* xga_QueryHeaderLength      *)
{$I getfname.inc} (* xga_GetFormatName          *)
{$I getfinfo.inc} (* xga_GetFormatInfo          *)
{ I save.inc    } (* xga_Save                   *)
{$I qimage.inc  } (* xga_QueryImage             *)
{$I qimagec.inc } (* xga_QueryImageCount        *)
{$I setimage.inc} (* xga_SetImage               *)
{$I unsuppor.inc} (* xga_Unsupported_Message    *)



function XGA_Proc_EntryF(const pmmioStr  :pointer;
                         const usMessage :SmallWord;
                         const lParam1   :Longint;
                         const lParam2   :Longint):Longint;
  begin
    {$IfDef LOG_TO_FILE}
    Log_Ausgabe('* XGA_Proc_Entry('+Ptr2hex(pmmioStr)+','+MMIOM_Name(usMessage)+','+Int2Hex(lParam1,8)+','+Int2Hex(lParam2,8)+')');
    {$EndIf LOG_TO_FILE}
    case usMessage of
      MMIOM_CLOSE               :Result:=xga_Close(pmmioStr,lParam1);
      MMIOM_OPEN                :Result:=xga_Open(pmmioStr,Ptr(lParam1));
      MMIOM_READ                :Result:=xga_Read(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_SEEK                :Result:=xga_Seek(pmmioStr,lParam1,lParam2);
      MMIOM_WRITE               :Result:=xga_Write(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_IDENTIFYFILE        :Result:=xga_IdentifyFile(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_GETHEADER           :Result:=xga_GetHeader(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_SETHEADER           :Result:=xga_SetHeader(pmmioStr,Ptr(lParam1),lParam2);
      MMIOM_QUERYHEADERLENGTH   :Result:=xga_QueryHeaderLength(pmmioStr);
      MMIOM_GETFORMATNAME       :Result:=xga_GetFormatName(Ptr(lParam1),lParam2);
      MMIOM_GETFORMATINFO       :Result:=xga_GetFormatInfo(Ptr(lParam1));
    //MMIOM_SAVE                :Result:=xga_Save(pmmioStr,Ptr(lParam1));
      MMIOM_QUERYIMAGE          :Result:=xga_QueryImage(pmmioStr,Pointer(lParam1));
      MMIOM_QUERYIMAGECOUNT     :Result:=xga_QueryImageCount(pmmioStr,Ptr(lParam1));
      MMIOM_SETIMAGE            :Result:=xga_SetImage(pmmioStr,lParam1);
    else
                                 Result:=xga_Unsupported_Message(pmmioStr,usMessage,lParam1,lParam2);
    end;
    {$IfDef LOG_TO_FILE}
    Log_Ausgabe('  XGA_Proc_Entry('+Ptr2hex(pmmioStr)+','+MMIOM_Name(usMessage)+','+Int2Hex(lParam1,8)+','+Int2Hex(lParam2,8)+')='+Int2Hex(Result,8));
    {$EndIf LOG_TO_FILE}
  end;

//function IOProc_Entry  (const pmmioStr  :pointer;
//                        const usMessage :SmallWord;
//                        const lParam1   :Longint;
//                        const lParam2   :Longint):Longint;cdecl;
//  begin
//    Result:=XGA_Proc_Entry(pmmioStr,usMessage,lParam1,lParam2);
//  end;

end.
