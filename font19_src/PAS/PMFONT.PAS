unit pmfont;

interface

uses
  Os2Def;

type

  FONTRANGEENTRY        =
    packed record
      ulRun             :longint;       (* number of consecutive glyphs contained in the font *)
      ulSkip            :longint;       (* number of consecutive glyphs skipped in the font, *)
    end;


  FONTCHARDEF           =
    packed record
      ulGlyphOffset     :longint;       (* offset to rendered character bitmap (0 from driver) *)
      sAspace           :smallint;      (* pre-character space *)
      sBspace           :smallword;     (* character width (always non-zero) *)
      sCspace           :smallint;      (* post-character space *)
    end;

  FOCAMETRICSEXT        =
    packed record
      ulSize            :longint;       (* Total size of extension  *)
      ulFlags           :longint;       (* Reserved, must be 0      *)
      ulGlyphCount      :longint;
      ulDefaultIndex    :longint;
      ulRangeTableEntries:longint;
      afreRangeTable    :array[1..1] of FONTRANGEENTRY;
    end;


  FOCAMETRICS           =
    packed record
      ulIdentity        :longint;
      ulSize            :longint;
      szFamilyname      :array[0..31] of char;
      szFacename        :array[0..31] of char;
      usRegistryId      :smallint;
      usCodePage        :smallint;
      yEmHeight         :smallint;
      yXHeight          :smallint;
      yMaxAscender      :smallint;
      yMaxDescender     :smallint;
      yLowerCaseAscent  :smallint;
      yLowerCaseDescent :smallint;
      yInternalLeading  :smallint;
      yExternalLeading  :smallint;
      xAveCharWidth     :smallint;
      xMaxCharInc       :smallint;
      xEmInc            :smallint;
      yMaxBaselineExt   :smallint;
      sCharSlope        :smallint;
      sInlineDir        :smallint;
      sCharRot          :smallint;
      usWeightClass     :smallword;
      usWidthClass      :smallword;
      xDeviceRes        :smallint;
      yDeviceRes        :smallint;
      usFirstChar       :smallint;
      usLastChar        :smallint;
      usDefaultChar     :smallint;
      usBreakChar       :smallint;
      usNominalPointSize:smallint;
      usMinimumPointSize:smallint;
      usMaximumPointSize:smallint;
      fsTypeFlags       :smallint;
      fsDefn            :smallint;
      fsSelectionFlags  :smallint;
      fsCapabilities    :smallint;
      ySubscriptXSize   :smallint;
      ySubscriptYSize   :smallint;
      ySubscriptXOffset :smallint;
      ySubscriptYOffset :smallint;
      ySuperscriptXSize :smallint;
      ySuperscriptYSize :smallint;
      ySuperscriptXOffset:smallint;
      ySuperscriptYOffset:smallint;
      yUnderscoreSize   :smallint;
      yUnderscorePosition:smallint;
      yStrikeoutSize    :smallint;
      yStrikeoutPosition:smallint;
      usKerningPairs    :smallint;
      sFamilyClass      :smallint;
      pszDeviceNameOffset:PChar;
    end;

  FONTFILEMETRICS       =
    packed record
      ulIdentity        :longint;
      ulSize            :longint;
      szFamilyname      :array[0..31] of char;
      szFacename        :array[0..31] of char;
      usRegistryId      :smallint;
      usCodePage        :smallint;
      yEmHeight         :smallint;
      yXHeight          :smallint;
      yMaxAscender      :smallint;
      yMaxDescender     :smallint;
      yLowerCaseAscent  :smallint;
      yLowerCaseDescent :smallint;
      yInternalLeading  :smallint;
      yExternalLeading  :smallint;
      xAveCharWidth     :smallint;
      xMaxCharInc       :smallint;
      xEmInc            :smallint;
      yMaxBaselineExt   :smallint;
      sCharSlope        :smallint;
      sInlineDir        :smallint;
      sCharRot          :smallint;
      usWeightClass     :smallword;
      usWidthClass      :smallword;
      xDeviceRes        :smallint;
      yDeviceRes        :smallint;
      usFirstChar       :smallint;
      usLastChar        :smallint;
      usDefaultChar     :smallint;
      usBreakChar       :smallint;
      usNominalPointSize:smallint;
      usMinimumPointSize:smallint;
      usMaximumPointSize:smallint;
      fsTypeFlags       :smallint;
      fsDefn            :smallint;
      fsSelectionFlags  :smallint;
      fsCapabilities    :smallint;
      ySubscriptXSize   :smallint;
      ySubscriptYSize   :smallint;
      ySubscriptXOffset :smallint;
      ySubscriptYOffset :smallint;
      ySuperscriptXSize :smallint;
      ySuperscriptYSize :smallint;
      ySuperscriptXOffset:smallint;
      ySuperscriptYOffset:smallint;
      yUnderscoreSize   :smallint;
      yUnderscorePosition:smallint;
      yStrikeoutSize    :smallint;
      yStrikeoutPosition:smallint;
      usKerningPairs    :smallint;
      sFamilyClass      :smallint;
      ulReserved        :longint;
      panose            :Os2Def.panose;
   end;


  FONTDEFINITIONHEADER  =
    packed record
      ulIdentity        :longint;
      ulSize            :longint;
      fsFontdef         :smallint;
      fsChardef         :smallint;
      usCellSize        :smallint;
      xCellWidth        :smallint;
      yCellHeight       :smallint;
      xCellIncrement    :smallint;
      xCellA            :smallint;
      xCellB            :smallint;
      xCellC            :smallint;
      pCellBaseOffset   :smallint;
    end;

const
  FONTDEFFONT1          =$0047;         (* set width, height, inc. & base offset *)
  FONTDEFFONT2          =$0042;         (* set height & base offset            *)
  FONTDEFFONT3          =$0042;         (* set height & base offset            *)
  FONTDEFCHAR1          =$0081;         (* set char offset and width           *)
  FONTDEFCHAR2          =$0081;         (* set char offset and width           *)
  FONTDEFCHAR3          =$00b8;         (* set char offset, A, B, and C space  *)
  SPACE_UNDEF           =$8000;         (* space undefined = take default      *)
  FONTDEFFOCA32         =$4000;
  FONTDEFDEVFONT        =$2000;         (* Device or Downloadable font         *)

type
  FONTSIGNATURE         =
    packed record
      ulIdentity        :longint;
      ulSize            :longint;
      achSignature      :array[1..12] of char;
    end;

  ADDITIONALMETRICS     =
    packed record
      ulIdentity        :longint;
      ulSize            :longint;
      panose            :PANOSE;
    end;

  FOCAFONT              =
    packed record
      fsSignature       :FONTSIGNATURE;
      fmMetrics         :FOCAMETRICS;
      fdDefinitions     :FONTDEFINITIONHEADER;
    end;

const
  FONT_SIGNATURE        =$fffffffe; (* Identity header start    *)
  FONT_METRICS          =$00000001; (* Identity metrics         *)
  FONT_DEFINITION       =$00000002; (* Identity definition      *)
  FONT_KERNPAIRS        =$00000003; (* Identity Kern Pairs      *)
  FONT_ADDITIONALMETRICS=$00000004; (* Identity Additional Metrics *)
  FONT_ENDRECORD        =$ffffffff; (* Identity record end      *)

  (* Options for QueryFonts *)

  QUERY_PUBLIC_FONTS    =$0001;
  QUERY_PRIVATE_FONTS   =$0002;

  CDEF_GENERIC          =$0001;
  CDEF_BOLD             =$0002;
  CDEF_ITALIC           =$0004;
  CDEF_UNDERSCORE       =$0008;
  CDEF_STRIKEOUT        =$0010;
  CDEF_OUTLINE          =$0020;


implementation

end.

