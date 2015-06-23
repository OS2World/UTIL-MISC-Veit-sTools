(*$Use32+*)
unit uniapi; // IBM uniapi.inf

// -> Virtual Pascal    2001.06.12..20001.06.30 Veit Kannegieser


interface

uses
  unidef;

type

  size_t                =word;

  AttrObject            =pointer;

  conv_endian_t         =                               // Information about the source and target endian.
    packed record
      source            :smallword;                     //  Source information.
      target            :smallword;                     //  Target information.
    end;

  KBDNAME               =UniCharArray;

  KEYBOARDINFO          =                               // Query keyboard structure.
    packed record
      len               :longint;                       //  Length of structure.
      kbid              :smallword;                     //  Keyboard architecture identifier.
      version           :smallword;                     //  Version number.
      language          :array[0..1] of byte;           //  Normal language.
      country           :array[0..1] of byte;           //  Normal country.
      flags             :smallword;                     //  Flags.
      resv              :smallword;                     //  Reserved.
      description       :array[0..31] of UniChar;       //  Description of keyboard.
    end;

  KHAND                 =word;                          // Handle to translate table.

  LocaleItem            =^integer;                      // Used to identify a language or cultural item within a locale.

  LocaleObject          =pointer;                       // Used by functions that require language or cultural-sensitive processing.

  LocaleToken           =word;                          // Used as a shorthand method for identifying locales.

  tm                    =                               // Time structure defined in time.h.
    packed record
      tm_sec,                                           //  Seconds after the minute (0 through 61).
      tm_min,                                           //  Minutes after the hour (0 through 59).
      tm_hour,                                          //  Hours since midnight (0 through 23).
      tm_mday,                                          //  Day of the month (1 through 31).
      tm_mon,                                           //  Months since January (0 through 11).
      tm_year,                                          //  Years since 1900.
      tm_wday,                                          //  Days since Sunday (0 through 6).
      tm_yday,                                          //  Days since January 1 (0 through 365).
      tm_isdst          :integer;                       //  Daylight Saving Time flag.
    end;

  ptm                   =^tm;


  // Describes the attributes and characteristics of a conversion object. All of these fields are queryable through
  // UniQueryUconvObject. Some of the fields are settable through UniSetUconvObject; these are marked in the
  // descriptions.

  uconv_attribute_t     =
    packed record
      version           :word;                          //  Version (must be zero). Settable.
      mb_min_len        :char;                          //  Minimum character size.
      mb_max_len        :char;                          //  Maximum character size.
      usc_min_len       :char;                          //  UCS minimum character size.
      usc_max_len       :char;                          //  UCS maximum character size.
      esid              :smallword;                     //  Encoding scheme ID.
      options           :char;                          //  Substitution options. Settable.
      state             :char;                          //  Current state. Settable.
      endian            :conv_endian_t;                 //  Source and target chain. Settable.
      displaymask       :word;                          //  Display and data mask. Settable.
      converttype       :word;                          //  Conversion type. Settable.
      subchar_len       :smallword;                     //  MBCS sub-character length. Settable.
      subuni_len        :smallword;                     //  Unicode sub-character length. Settable.
      subchar           :array[0..15] of char;          //  MBCS subcharacters. Settable.
      subuni            :array[0..7] of UniChar;        //  Unicode subcharacters. Settable.
    end;

  puconv_attribute_t   =^uconv_attribute_t;


  UconvObject           =pointer;                       // Used by functions that convert to and from Unicode.

  // Provides a set of ranges of characters that make up the user-defined character range.
  udcrange_t            =
    packed record
      first,                                            //  First code point.
      last              :smallword;                     //  Last code point.
    end;

  pudcrange_t           =^udcrange_t;

  array_32_udcrange_t   =array[0..32-1] of udcrange_t;

  ulsbool               =longbool;

  UniLconv              =                               // Describes the locale conventions.
    packed record
      decimal_point     :pUniCharArray;                 //  Non-monetary decimal point.
      thousands_sep     :pUniCharArray;                 //  Non-monetary thousands' separator.
      grouping          :psmallword;                    //  Size of each group of digits in non-monetary quantities.
      int_curr_symbol   :pUniCharArray;                 //  International currency symbol and separator.
      currency_symbol   :pUniCharArray;                 //  Local currency symbol.
      mon_decimal_point :pUniCharArray;                 //  Monetary decimal point.
      mon_thousands_sep :pUniCharArray;                 //  Monetary thousands' separator.
      mon_grouping      :psmallword;                    //  Size of each group of digits in monetary quantities.
      positive_sign     :pUniCharArray;                 //  Non-negative values sign.
      negative_sign     :pUniCharArray;                 //  Negative values sign.
      int_frac_digits   :smallword;                     //  Number of fractional digits for international currency.
      frac_digits       :smallword;                     //  Number of fractional digits for local currency.
      p_cs_precedes     :smallword;                     //  Non-negative currency symbol: 1 - precedes; 0 - succeeds.
      p_sep_by_space    :smallword;                     //  Non-negative currency symbol: 1 - space; 0 - no space.
      n_cs_precedes     :smallword;                     //  Negative currency symbol: 1 - precedes; 0 - succeeds.
      n_sep_by_space    :smallword;                     //  Negative currency symbol: 1 - space; 0 - no space.
      p_sign_posn       :smallword;                     //  Positioning of non-negative monetary sign.
      os2_mondecpt      :smallword;                     //  OS/2 currency symbol positioning.
      debit_sign        :pUniCharArray;                 //  Non-negative valued debit monetary symbol.
      credit_sign       :pUniCharArray;                 //  Negative valued credit monetary symbol.
      left_parenthesis  :pUniCharArray;                 //  Negative valued left parenthesis monetary symbol.
      right_parenthesis :pUniCharArray;                 //  Negative valued right parenthesis monetary symbol.
    end;

  pUniLconv             =^UniLconv;


  USHIFTSTATE           =                               // Unicode shift states.
    packed record
      shift             :word;                          //  Actual shift and lock state.
      Effective         :word;                          //  Effective shift and lock state.
      Led               :word;                          //  Keyboard indicators.
    end;

  PUSHIFTSTATE          =^USHIFTSTATE;


  VDKEY                 =smallword;                     // Virtual or dead key.
  p_VDKEY               =^VDKEY;
  VSCAN                 =byte;                          // Virtual scan code.


  XformObject           =pointer;                       // Used to perform string transformations.

  array_256_byte        =array[byte] of byte;



const
  UCONV_BADATTR         =$20415;        // Incorrect attribute
                                        // specified.

  UCONV_E2BIG           =$20412;        // Input conversion stopped
                                        // due to lack of space in
                                        // the output buffer.

  UCONV_EBADF           =$2040F;        // An object specified on a
                                        // parameter of this
                                        // function is not a valid
                                        // object.

  UCONV_EILSEQ          =$20402;        // Input conversion stopped
                                        // due to an input byte that
                                        // does not belong to the
                                        // input code page.

  UCONV_EINVAL          =$2040E;        // A locale specification
                                        // string or token that is
                                        // not valid was passed; the
                                        // locale object pointer
                                        // points to undefined data.

  UCONV_EMFILE          =$20403;        // File descriptors are
                                        // currently open in the
                                        // calling process.

  UCONV_ENFILE          =$20404;        // Too many files currently
                                        // open in the system.

  UCONV_ENOMEM          =$2040D;        // Insufficient memory to
                                        // create the requested
                                        // object.

  UCONV_EOTHER          =$20401;        //

  UCONV_NOTIMPLEMENTED  =$2040C;        //

  ULS_BADATTR           =$20415;        // Incorrect attribute
                                        // specified.

  ULS_BADHANDLE         =$20408;        // Bad keyboard handle.

  ULS_BADOBJECT         =$2040F;        // An object specified on a
                                        // parameter of this
                                        // function is not a valid
                                        // object.

  ULS_BUFFERFULL        =$20412;        // Input conversion stopped
                                        // due to lack of space in
                                        // the output buffer.

  ULS_ILLEGALSEQUENCE   =$20402;        // Input conversion stopped
                                        // due to an input byte that
                                        // does not belong to the
                                        // input code page.

  ULS_INVALID           =$2040E;        // A locale specification
                                        // string or token that is
                                        // not valid was passed; the
                                        // locale object pointer
                                        // points to undefined data.

  ULS_INVALIDSCAN       =$2040B;        //

  ULS_KBDNOTFOUND       =$20407;        // Cannot find the specified
                                        // keyboard layout.

  ULS_MAXFILES          =$20404;        // Too many files currently
                                        // open in the system.

  ULS_MAXFILESPERPROC   =$20403;        // File descriptors are
                                        // currently open in the
                                        // calling process.

  ULS_NODEAD            =$20409;        // The dead key value is not
                                        // valid.

  ULS_NOMATCH           =$20411;        // No code element meets the
                                        // specified criteria.

  ULS_NOMEMORY          =$2040D;        // Insufficient memory to
                                        // create the requested
                                        // object.

  ULS_NOOP              =$20405;        // Attempted to close a
                                        // resource that has already
                                        // been closed.

  ULS_NOSCAN            =$2040A;        // Bad scan code.

  ULS_NOTIMPLEMENTED    =$2040C;        //

  ULS_NOTOKEN           =$20410;        // No appropriate locale
                                        // token exists for this
                                        // locale string.

  ULS_OTHER             =$20401;        //

  ULS_RANGE             =$20413;        // The conversion resulted
                                        // in an out-of-range
                                        // condition.

  ULS_SUCCESS           =     0;        // Successful completion.

  ULS_TOOMANYKBD        =$20406;        // Too many keyboard handles
                                        // were created.

  ULS_UNSUPPORTED       =$20414;        // A specified parameter
                                        // value is unsupported.

  ULS_VERSION           =$20416;        //


(*$OrgName+,Cdecl+*)

//*** Universal Language Support Functions

// Creates an attribute object that is used to determine character classifications.
function UniCreateAttrObject(const locale_object:LocaleObject;const AttrName:UniCharArray;var attr_object:AttrObject):integer;

// Creates a locale object.
function UniCreateLocaleObject(const LocaleSpecType:integer;const LocaleSpec;var locale_object:LocaleObject):integer;

// Creates a string transform object.
function UniCreateTransformObject(const locale_object:LocaleObject;const xtype:UniCharArray;var xform_object:XformObject):integer;

// Frees the character attribute object.
function UniFreeAttrObject(const attr_object:AttrObject):integer;

// Frees the locale information structure.
function UniFreeLocaleInfo(const UniLconv_addr:UniLconv):integer;

// Frees a locale object that was created by UniCreateLocaleObject.
function UniFreeLocaleObject(const locale_object:LocaleObject):integer;

// Frees memory allocated by UniQueryLocaleObject.
function UniFreeMem(const memory):integer;

// Frees a string transform object.
function UniFreeTransformObject(const xform_object:XformObject):integer;

// Converts a locale specification string to a token.
function UniLocaleStrToToken(const LocaleStringType:integer;const locale_string;var locale_token:LocaleToken):integer;

// Converts a locale token to a locale specification string.
function UniLocaleTokenToStr(const locale_token:LocaleToken;const LocaleStringType:integer;var locale_string:pointer):integer;

// Converts a ULONG country code into a locale name represented as a UniChar string that is acceptable as input to other Unicode functions.
function UniMapCtryToLocale(const ulCountryCode:word;                   //  An OS/2 country code.
                            var   ucsLocaleName:UniCharArray;           //  A buffer for placing the Unicode string.
                            const n:size_t):integer;                    //  Size, in characters, of the ucsLocaleName buffer. This should be at least eight Unicode characters.

// Queries character attributes.
function UniQueryAlnum(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryAlpha(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryBlank(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryCharAttr(const attr_object:AttrObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryCntrl(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryDigit(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryGraph(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Retrieves information about locale conventions.
function UniQueryLocaleInfo(const locale_object:LocaleObject;var UniLconv_addr_ptr:pUniLconv):integer;

// Retrieves locale information by item.
function UniQueryLocaleItem(const locale_object:LocaleObject;const liItem:LocaleItem;var info_item_addr_ptr:pUniCharArray):integer;

// Retrieves the locale name.
function UniQueryLocaleObject(const locale_object:LocaleObject;const category,LocaleSpecType:integer;var locale_name:pUniCharArray):integer;

// Queries character attributes.
function UniQueryLower(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryPrint(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryPunct(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQuerySpace(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryUpper(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Queries character attributes.
function UniQueryXDigit(const locale_object:LocaleObject;const ucCharacter:UniChar):longbool;

// Scans for attribute match.
function UniScanForAttr(const attr_object:AttrObject;const ucs:UniCharArray;const num_elems:integer;const inverse_op:ulsBool;var offset:size_t):integer;

//  Concatenates code element strings. :=ucs1+ucs2
function UniStrcat(var ucs1:UniCharArray;const ucs2:pUniCharArray):pUniCharArray;

// Searches for the first occurrence of a code element.
function UniStrchr(const ucs:UniCharArray;const ucCharacter:UniChar):pUniCharArray;

// Compares code element strings.
function UniStrcmp(const ucs1,ucs2:UniCharArray):integer;

// Compares strings without sensitivity to case.
function UniStrcmpi(const locale_object:LocaleObject;const ucs1,ucs2:UniCharArray):integer;

// Compares language collation strings.
function UniStrcoll(const locale_object:LocaleObject;const ucs1,ucs2:UniCharArray):integer;

// Copies code element string.
function UniStrcpy(var ucs1:UniCharArray;const ucs2:UniCharArray):pUniCharArray;

// Searches for code element string.
function UniStrcspn(const ucs1,ucs2:UniCharArray):size_t;

// Converts a monetary value to a string.
function UniStrfmon(const locale_object:LocaleObject;var ucs:UniCharArray;const maxsize:size_t;const format:UniCharArray;const args:array of const):integer;

// Formats date and time.
function UniStrftime(const locale_object:LocaleObject;var ucs:UniCharArray;const maxsize:size_t;const format:UniCharArray;const timeptr:tm):size_t;

// Determines code element count.
function UniStrlen(const ucs:UniCharArray):size_t;

// Converts a Unicode string to lowercase according to the language neutral case mapping tables.
function UniStrlwr(var ucsUniStringIn:UniCharArray):pUniCharArray;

// Concatenates a specific number of code elements. :=ucs1+Copy(ucs2,1,n)
function UniStrncat(var ucs1:UniCharArray;const ucs2:UniCharArray;const n:size_t):pUniCharArray;

// Compares a specific number of code elements.
function UniStrncmp(const ucs1,ucs2:UniCharArray;const n:size_t):integer;

// Compares one or more code elements of strings without sensitivity to case.
function UniStrncmpi(const locale_object:LocaleObject;const ucs1,ucs2:UniCharArray;const n:size_t):integer;

// Copies a specific number of code elements. ucs1:=Copy(uncs2,1,n)+#0...
function UniStrncpy(var ucs1:UniCharArray;const ucs2:UniCharArray;const n:size_t):pUniCharArray;

// Locates code elements in a code element string.
function UniStrpbrk(const ucs1,ucs2:UniCharArray):pUniCharArray;

// Converts date and time.
function UniStrptime(const locale_object:LocaleObject;const buf,fmt:UniCharArray;var tm_:tm):pUniCharArray;

// Locates the last occurrence of a code element.
function UniStrrchr(const ucs:UniCharArray;const ucCharacter:UniChar):pUniCharArray;

// Determines the number of code elements in a segment.
function UniStrspn(const ucs1,ucs2:UniCharArray):size_t;

// Locates a code element sequence.
function UniStrstr(const ucs1,ucs2:UniCharArray):pUniCharArray;

// Converts character string to double-precision floating point.
function UniStrtod(const locale_object:LocaleObject;const nptr:UniCharArray;var endptr:pUniCharArray;var fResult:double):integer;

// Converts a character string to a long integer.
function UniStrtol(const locale_object:LocaleObject;const nptr:UniCharArray;var endptr:pUniCharArray;const base:integer;var liResult:integer):integer;

// Converts a Unicode string to tokens.
function UniStrtok(var ucsString1,ucsString2:UniCharArray):pUniCharArray;

// Converts a character string to a ULONG integer.
function UniStrtoul(const locale_object:LocaleObject;const nptr:UniCharArray;var endptr:pUniCharArray;const base:integer;var ulResult:integer):integer;

// Converts a Unicode string to uppercase according to the language neutral case mapping tables.
function UniStrupr(var ucsUniStringIn:UniCharArray):pUniCharArray;

// Transforms a character string.
function UniStrxfrm(const locale_object:LocaleObject;var ucs1:UniCharArray;const ucs2:UniCharArray;const n:size_t):size_t;

// Converts a Unicode character to lowercase according to the language neutral case mapping tables.
function UniTolower(const ucUniCharIn:UniChar):UniChar;

// Converts a Unicode character to uppercase according to the language neutral case mapping tables.
function UniToupper(const ucUniCharIn:UniChar):UniChar;

// Transforms strings according to an transform object created by UniCreateTransformObject.
function UniTransformStr(const xform_object:XformObject;const InpBuf:UniCharArray;const InpSize:integer;var OutBuf:UniCharArray;var OutSize:integer):integer;

// Converts a Unicode character to lowercase using the specified locale.
function UniTransLower(const locale_object:LocaleObject;Const ucCharacter:UniChar):UniChar;

// Converts a Unicode character to uppercase using the specified locale.
function UniTransUpper(const locale_object:LocaleObject;Const ucCharacter:UniChar):UniChar;



//*** Conversion Functions

// Creates and initializes a Uconv object.
function UniCreateUconvObject(const cpname:UniCharArray;var uconv_object:UconvObject):integer;

// Frees a conversion object.
function UniFreeUconvObject(const uconv_object:UconvObject):integer;

// Converts a code page number into a code page represented as a UniChar
// string that is acceptable as input to the UniCreateUconvObject.
function UniMapCpToUcsCp(const ulCodepage:longint;var ucsCodepage:UniCharArray;const n:size_t):integer;

// Queries the attributes of a conversion object.
function UniQueryUconvObject(const uconv_object:UconvObject;var attr:uconv_attribute_t;const size:size_t;var first_256,other_256:array_256_byte;var udcrange:array_32_udcrange_t):integer;

// Sets the attributes of a conversion object.
function UniSetUconObject(const uconv_object:UconvObject;const attr_t:uconv_attribute_t):integer;

// Converts UCS characters to code page characters.
function UniUconvFromUcs(const uconv_object:UconvObject;var ucsbuf:pUniCharArray;var UniCharsleft:size_t;var outbuf:pchar;var outbytesleft:size_t;var nonidentical:size_t):integer;

// Converts a code page string to a UCS string.
function UniUconvToUcs(const uconv_object:UconvObject;var inbuf:pchar;var inbytesleft:size_t;var ucsbuf:pUniCharArray;var UniCharsleft:size_t;var nonidentical:size_t):integer;

(* UniStrToUcs  UniStrFromUcs  UniQueryUconvCp  _UniFree  _UniMalloc *)



//*** Universal Language Support Keyboard Functions

// Loads a keyboard layout from the disk and returns a handle.
function UniCreateKeyboard(var pkhand:KHAND;const pname:KBDNAME;const mode:word):integer;

// Closes a keyboard handle.
function UniDestroyKeyboard(const khand_:KHAND):integer;

// Queries information from the header in a keyboard table.
function UniQueryKeyboard(const khand_:KHAND;var pkbdinfo:KEYBOARDINFO):integer;


// Resets the actual and effective shift states and LED status.
//      KEYEV_RELEASE           Release all pressed keys
//      KEYEV_SET               Set to specified value
//      KEYEV_ZERO              Release all pressed and locked keys
function UniResetShiftState(const khand_:KHAND;var pUss:USHIFTSTATE;const type_:word):integer;

// Translates a dead key and a Unicode character to a composite character.
function UniTranslateDeadKey(const khand_:KHAND;var vdk:p_VDKEY;const inchar:UniChar;var outchar:UniChar;var newdead:VDKEY):integer;

// Translates a scan code and effective shift state to a Unicode and virtual and dead key. Sets the BIOS scan code.
function UniTranslateKey(const khand_:KHAND;const eshift:word;const scan:VSCAN;var uc:UniChar;var vdk:VDKEY;var bscan:byte):integer;

// Translates a Unicode character and virtual or dead key to a scan code and creates the effective shift state.
function UniUntranslateKey(const khand_:KHAND;const uc:UniChar;const vdk:VDKEY;var pscan:VSCAN;var eshift:word):integer;

// Updates the actual and effective shift states and LED status.
function UniUpdateShiftState(const khand_:KHAND;var pUss:USHIFTSTATE;const v_scan:VSCAN;const makebreak:byte):integer;


(*$OrgName-,Cdecl-*)

function UniStringToUcs(const s:shortstring):pUniCharArray;
function UniUcsToString(const u:UniCharArray):shortstring;

const
  UCS_null:UniChar=0;
  UCS_nil:pUniCharArray=pUniCharArray(@UCS_null);

implementation

uses
  Strings;

// LIBUNI.DLL
(*$L LIBUNI.LIB*)

function UniCreateAttrObject            ;external;
function UniCreateLocaleObject          ;external;
function UniCreateTransformObject       ;external;
function UniFreeAttrObject              ;external;
function UniFreeLocaleInfo              ;external;
function UniFreeLocaleObject            ;external;
function UniFreeMem                     ;external;
function UniFreeTransformObject         ;external;
function UniLocaleStrToToken            ;external;
function UniLocaleTokenToStr            ;external;
function UniMapCtryToLocale             ;external;
function UniQueryAlnum                  ;external;
function UniQueryAlpha                  ;external;
function UniQueryBlank                  ;external;
function UniQueryCharAttr               ;external;
function UniQueryCntrl                  ;external;
function UniQueryDigit                  ;external;
function UniQueryGraph                  ;external;
function UniQueryLocaleInfo             ;external;
function UniQueryLocaleItem             ;external;
function UniQueryLocaleObject           ;external;
function UniQueryLower                  ;external;
function UniQueryPrint                  ;external;
function UniQueryPunct                  ;external;
function UniQuerySpace                  ;external;
function UniQueryUpper                  ;external;
function UniQueryXDigit                 ;external;
function UniScanForAttr                 ;external;
function UniStrcat                      ;external;
function UniStrchr                      ;external;
function UniStrcmp                      ;external;
function UniStrcmpi                     ;external;
function UniStrcoll                     ;external;
function UniStrcpy                      ;external;
function UniStrcspn                     ;external;
function UniStrfmon                     ;external;
function UniStrftime                    ;external;
function UniStrlen                      ;external;
function UniStrlwr                      ;external;
function UniStrncat                     ;external;
function UniStrncmp                     ;external;
function UniStrncmpi                    ;external;
function UniStrncpy                     ;external;
function UniStrpbrk                     ;external;
function UniStrptime                    ;external;
function UniStrrchr                     ;external;
function UniStrspn                      ;external;
function UniStrstr                      ;external;
function UniStrtod                      ;external;
function UniStrtol                      ;external;
function UniStrtok                      ;external;
function UniStrtoul                     ;external;
function UniStrupr                      ;external;
function UniStrxfrm                     ;external;
function UniTolower                     ;external;
function UniToupper                     ;external;
function UniTransformStr                ;external;
function UniTransLower                  ;external;
function UniTransUpper                  ;external;


// UCONV.DLL
(*$L UCONV.LIB*)

function UniCreateUconvObject           ;external;
function UniFreeUconvObject             ;external;
function UniMapCpToUcsCp                ;external;
function UniQueryUconvObject            ;external;
function UniSetUconObject               ;external;
function UniUconvFromUcs                ;external;
function UniUconvToUcs                  ;external;


// UNIKBD.DLL
(*$L UNIKBD.LIB*)

function UniCreateKeyboard              ;external;
function UniDestroyKeyboard             ;external;
function UniQueryKeyboard               ;external;
function UniResetShiftState             ;external;
function UniTranslateDeadKey            ;external;
function UniTranslateKey                ;external;
function UniUntranslateKey              ;external;
function UniUpdateShiftState            ;external;


var
  default_cp_conversion :UconvObject=nil;

function UniStringToUcs(const s:shortstring):pUniCharArray;
  var
    rc                  :integer;
    pc                  :array[0..255] of char;
    inbuf               :pchar;
    inbytesleft         :size_t;
    ucsbuf              :pUniCharArray;
    UniCharsleft        :size_t;
    nonidentical        :size_t;

  begin
    if s='' then
      begin
        Result:=nil;
        Exit;
      end;

    if not Assigned(default_cp_conversion) then
      begin
        rc:=UniCreateUconvObject(UCS_nil^,default_cp_conversion);
        if rc<>ULS_SUCCESS then RunError(rc);
      end;

    StrPCopy(pc,s);

    Result:=NewUniCharArray(Length(s));
    inbuf:=@pc;
    inbytesleft:=Length(s);
    ucsbuf:=Result;
    UniCharsleft:=Length(s);

    {rc:=}
    UniUConvToUcs(
      default_cp_conversion,
      inbuf,inbytesleft,
      ucsbuf,UniCharsleft,
      nonidentical);

  end;

function UniUcsToString(const u:UniCharArray):shortstring;
  var
    rc                  :integer;
    ucsbuf              :pUniCharArray;
    UniCharsleft        :size_t;
    pc                  :array[0..255] of char;
    outbuf              :pchar;
    outbytesleft        :size_t;
    nonidentical        :size_t;
  begin

    if not Assigned(default_cp_conversion) then
      begin
        rc:=UniCreateUconvObject(UCS_nil^,default_cp_conversion);
        if rc<>ULS_SUCCESS then RunError(rc);
      end;

    ucsbuf:=@u;
    UniCharsleft:=UniStrLen(u);
    outbuf:=pc;
    //outbuf[0]:=#0;
    FillChar(pc,SizeOf(pc),0);
    outbytesleft:=SizeOf(pc);

    UniUconvFromUcs(
      default_cp_conversion,
      ucsbuf,UniCharsleft,
      outbuf,outbytesleft,
      nonidentical);

    Result:=StrPas(pc);

  end;

end.

