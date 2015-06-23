(*$I TYP_COMP.PAS*)

unit typ_varx;

interface


uses
  typ_type;

(*$IfDef ENDVERSION*)
(*$I TYPDATUM.PAS*)
(*$Else*)
(*$I TYPDATUM.PA_*)
(*$EndIf*)

type
  term_typ=(
  (*$IfDef TERM_ROLLEN*)
  term_rollen,
  (*$EndIf*)
  (*$IfDef TERM_FARBIG*)
  term_farbig,
  (*$EndIf*)
  term_ansi,
  term_mono,
  term_gefiltert,
  term_html);

  farbteil              =(vf,hf);

  farbtabelle           =
    record
      sign              :array[1..6] of char;
      h                 :string[30];
      f                 :array[normal..rand,vf..hf] of byte;
    end;

const
  unterverzeichnisse    :boolean=wahr;
  (*$IfDef DOS_ODER_DPMI*)
  parti_und_speicher    :boolean=wahr;
  startsektoren         :boolean=wahr;
  (*$EndIf DOS_ODER_DPMI*)
  (*$IfDef DPMI32*)
  parti_und_speicher    :boolean=wahr;
  startsektoren         :boolean=wahr;
  (*$EndIf DPMI32*)
  (*$IfDef Linux*)
  parti_und_speicher    :boolean=false;
  startsektoren         :boolean=false;
  (*$EndIf Linux*)
  (*$IfDef OS2*)
  parti_und_speicher    :boolean=wahr;
  startsektoren         :boolean=wahr;
  (*$EndIf OS2*)
  (*$IfDef Win32*)
  parti_und_speicher    :boolean=false;
  startsektoren         :boolean=false;
  (*$EndIf Win32*)
  bios_pw_anzeigen      :boolean=falsch;
  resource_anzeigen     :boolean=falsch;
  (*$IfDef DOS*)
  spielhebel            :boolean=falsch;
  spielhebel_blockiert  :boolean=falsch;
  direkt_ide            :boolean=falsch;
  (*$EndIf*)
  gtdata_dll            :boolean=wahr;
  maustreiber           :boolean=wahr;
  keine_mausbewegung    :boolean=false;
  multitask             :boolean=falsch;
  langformat            :boolean=wahr;
  signaturen            :boolean=falsch;
  ico_anzeige           :boolean=wahr;
  hexadezimal           :boolean=wahr;
  cpu_emulator          :boolean=wahr;
  hilfe_anzeigen        :boolean=falsch;

  abbruch_kein_problem                        =  0;
  abbruch_Rechnerausruestung_passt_nicht      =240;
  abbruch_Problem_beim_Auswerten_der_Parameter=241;
  abbruch_unerwartete_erscheinung             =242;
  abbruch_Virus_gefunden                      =243;
  hilfe_aktiv:boolean                         =falsch;
  errorlevel :word_norm                       =abbruch_kein_problem;

  (*$IfDef TYP_OS2*)
  typ_exe_name          ='TYP2.EXE';
  typein_exe_name       ='TYPEIN2.EXE';
  ty_bat_name           ='TY.CMD';
  (*$EndIf*)

  (*$IfDef TYP_DOS*)
  typ_exe_name          ='TYP.EXE';
  typein_exe_name       ='TYPEIN.EXE';
  ty_bat_name           ='TY.BAT';
  (*$EndIf*)

  (*$IfDef TYP_DPMI*)
  typ_exe_name          ='TYP1.EXE';
  typein_exe_name       ='TYPEIN1.EXE';
  ty_bat_name           ='TY1.BAT';
  (*$EndIf*)

  (*$IfDef TYP_DPMI32*)
  typ_exe_name          ='TYP3.EXE';
  typein_exe_name       ='TYPEIN3.EXE';
  ty_bat_name           ='TY.BAT';
  (*$EndIf*)

  (*$IfDef TYP_W32*)
  typ_exe_name          ='TYP4.EXE';
  typein_exe_name       ='TYPEIN4.EXE';
  ty_bat_name           ='TY.BAT';
  (*$EndIf*)

  (*$IfDef TYP_LNX*)
  typ_exe_name          ='TYP5';
  typein_exe_name       ='TYPEIN5';
  ty_bat_name           ='TY';
  (*$EndIf*)

  (*$IfDef TYP_BSD*)
  typ_exe_name          ='TYP6';
  typein_exe_name       ='TYPEIN6';
  ty_bat_name           ='TY';
  (*$EndIf*)

  term                  :term_typ
    (*$IfDef TYP_DOS*)
    =term_farbig;
    (*$EndIf*)
    (*$IfDef TYP_DPMI*)
    =term_farbig;
    (*$EndIf*)
    (*$IfDef TYP_DPMI32*)
    =term_farbig;
    (*$EndIf*)
    (*$IfDef TYP_LNX*)
    (*$IfDef TERM_FARBIG*)
    =term_farbig;
    (*$Else TERM_FARBIG*)
    =term_ansi;
    (*$EndIf TERM_FARBIG*)
    (*$EndIf*)
    (*$IfDef TYP_OS2*)
    =term_farbig;
    (*$EndIf*)
    (*$IfDef TYP_W32*)
    =term_farbig;
    (*$EndIf*)



  terminal_para:
    array[low(term_typ)..high(term_typ)] of char
      =((*$IfDef TERM_ROLLEN*)
        'R',
        (*$EndIf*)
        (*$IfDef TERM_FARBIG*)
        'C',
        (*$EndIf*)
        'E',
        'A',
        'F',
        'H');


  (*$IfDef TYPEIN_EXE*)
  farbtabellenname      :string='';
  (*$EndIf TYPEIN_EXE*)

  ftab:farbtabelle=(
    sign:
      ('V','K','T','y','F','a');
    h:
      ('Vorgaben des Autors');
    f:(
      ($00,$20),  (* normal *)
      ($0A,$20),  (* compiler *)
      ($0B,$20),  (* packer_dat *)
      ($0E,$20),  (* packer_exe *) (* braun sieht im OS/2 Fenster nicht besonders gut aus *)
    (*($06,$20),*)(* musik_bild *)
      ($0d,$20),  (* musik_bild *)
      ($0A,$20),  (* overlay *)
      ($0E,$00),  (* dat_fehler *)
      ($02,$C0),  (* virus *)
      ($0B,$20),  (* dos_win_extender *)
      ($0E,$20),  (* beschreibung *)
      ($0F,$20),  (* signatur *)
      ($0A,$20),  (* bibliothek *)
      ($0D,$20),  (* spielstand *)
      ($0F,$00),  (* farblos *)
      ($0E,$80)));(* rand *)

  (*$IfDef ENDVERSION*)

    (*$IfDef TYP_DOS*)
    xms_grenze          :word=1000;
    ems_grenze          :word=200;
    (*$EndIf*)

    (*$IfDef TYP_DPMI*)
    pas_grenze          :longint=3000;
    (*$EndIf*)
    (*$IfDef TYP_DPMI32*)
    pas_grenze          :longint=3000; (* 3MB *)
    (*$EndIf*)
    (*$IfDef TYP_LNX*)
    pas_grenze          :longint=3000;
    (*$EndIf*)
    (*$IfDef TYP_OS2*)
    pas_grenze          :longint=3000; (* 3MB *)
    (*$EndIf*)
    (*$IfDef TYP_W32*)
    pas_grenze          :longint=3000;
    (*$EndIf*)

  (*$Else*)

    (*$IfDef TYP_DOS*)
    xms_grenze          :word=$100;
    ems_grenze          :word=$100;
    (*$EndIf*)

    (*$IfDef TYP_DPMI*)
    pas_grenze          :longint=512;
    (*$EndIf*)
    (*$IfDef TYP_DPMI32*)
    pas_grenze          :longint=512;
    (*$EndIf*)
    (*$IfDef TYP_LNX*)
    pas_grenze          :longint=512;
    (*$EndIf*)
    (*$IfDef TYP_OS2*)
    pas_grenze          :longint=512; (* 0,5 MB *)
    (*$EndIf*)
    (*$IfDef TYP_W32*)
    pas_grenze          :longint=512;
    (*$EndIf*)

  (*$EndIf*)

  eas_anzeigen          :boolean=wahr;

  entp_bat_cmd          :string='';

  bzeilen               :word_norm=0; (* 25 *)


  {$IfDef dateigroessetyp_comp}
  bit32maske            :
    packed record
      lo32,hi32         :longint;
    end=
    (lo32:$ffffffff;hi32:0);
  {$EndIf}

var

  (*$IfDef TYP_EXE*)
  kopftext                      :string;
  kopftextstart                 :dateigroessetyp;
  kopftextlaenge                :longint;



  vga                           :boolean;
  ega_oder_besser               :boolean; (* Memmax *)
  mono_bei_b000                 :boolean;
  (*$EndIf*)
  switch_char                   :char;

  fehler_val                    :integer_norm;
  jahr,monat,tag,
  wochentag                     :word_norm;

  (*$IfDef TYP_EXE*)
  datei                         :file;
  textdatei_offen               :boolean;
  textdatei_seek_position       :longint;
  (*$EndIf*)

  terminal_namen                :array[term_typ] of string[46];

function  gross(const zkk:string):string;

(*$IfDef TYP_EXE*)
var
  abbruch_meldung       :string;

procedure abbruch(const zk:string;const fehler:word_norm);
procedure fuell_word(var anfang;const word_anz:word_norm;const muster:word);

(*$IfDef DOS*)
function  x_word_far(const by0):word;
const     adr_x_word:pointer=@x_word_far;
function  x_word(const by0):word;
  inline($ff/$1e/>adr_x_word);
(*$EndIf*)
(*$IfDef VirtualPascal*)
function  x_word(const by0):word;inline;
  begin
    x_word:=memw[ofs(by0)];
  end;
(*$EndIf*)
(*$IfDef DUMM*)
function  x_word(const by0):word;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function  x_longint_far(const by0):longint;
const     adr_x_longint:pointer=@x_longint_far;
function  x_longint(const by0):longint;
  inline($ff/$1e/>adr_x_longint);
(*$EndIf*)
(*$IfDef VirtualPascal*)
function  x_longint(const by0):longint;inline;
  begin
    x_longint:=meml[ofs(by0)];
  end;
(*$EndIf*)
(*$IfDef DUMM*)
function  x_longint(const by0):longint;
(*$EndIf*)


function  x_dateigroessetyp(const by0):dateigroessetyp;
function  m_dateigroessetyp(const by0):dateigroessetyp;
function  x_long(const by0):dateigroessetyp;

function  m_word(const by0):word;
function  m_longint(const by0):longint;

function  DGT_zu_longint(n:dateigroessetyp):longint;

(*$IfDef DOS_ODER_DPMI*)
function  str_far(const z:longint;const ziffern:byte):string;
const     adr_str:pointer=@str_far;
function  str_(const z:longint;const ziffern:byte):string;
  inline($ff/$1e/>adr_str);
(*$Else*)
function  str_(const z:longint;const ziffern:byte):string;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function  str0_far(const z:longint):string;
const     adr_str0:pointer=@str0_far;
function  str0(const z:longint):string;
  inline($ff/$1e/>adr_str0);
(*$Else*)
function  str0(const z:longint):string;
(*$EndIf*)

function  str0_DGT(const z:dateigroessetyp):string;

function strZ(const z:longint;n:word_norm):string;

(*$IfDef DOS_ODER_DPMI*)
function  strx_oder_hex_far(const z:longint):string;
const     adr_strx_oder_hex:pointer=@strx_oder_hex_far;
function  strx_oder_hex(const z:longint):string;
  inline($ff/$1e/>adr_strx_oder_hex);
(*$Else*)
function  strx_oder_hex(const z:longint):string;
(*$EndIf*)

function  strx_oder_hexDGT(const n:dateigroessetyp):string;

(*$IfDef DOS_ODER_DPMI*)
function  str11_oder_hex_far(const z:longint):string;
const     adr_str11_oder_hex:pointer=@str11_oder_hex_far;
function  str11_oder_hex(const z:longint):string;
  inline($ff/$1e/>adr_str11_oder_hex);
(*$Else*)
function  str11_oder_hex(const z:longint):string;
(*$EndIf*)
function  str9_oder_hex(const z:longint):string;

function  str11_oder_hexDGT(const n:dateigroessetyp):string;

function  strx(const z:longint;const ziffern:byte):string;
function  strxDGT(const z:dateigroessetyp;const ziffern:byte):string;
(*$IfDef dateigroessetyp_comp*)
function  comp_strx(c:comp;const ziffern:byte):string;
function  comp_str0(c:comp):string;
(*$EndIf dateigroessetyp_comp*)
function  DGT_str0(l:dateigroessetyp):string;
function  r_str(const z:real;const ziffern,nachkomma:byte):string;
function  hex(const z:byte):string;
function  hex_word(const w:word):string;
function  hex_longint(const l:longint):string;
function  hex_longint_min(const l:longint):string;
function  hex_DGT(const l:dateigroessetyp):string;
function  prozent(const anteil,voll:dateigroessetyp):dateigroessetyp;
procedure leerzeichenerweiterung(var zk:string;const stellen:byte);
function  leerzeichenerweiterung_f(const zk:string;const stellen:byte):string;
function  ror8(const by:byte;r:byte):byte;
function  ror32(const l:longint;r:byte):longint;
(*$EndIf TYP_EXE*)

(* auch TYPEIN *)
procedure bestimme_switch_char;
procedure blinken_aus;
function  aufrundenf(const l,schrittweite:longint):longint;
procedure aufrunden_longint  (var l:longint  ;const schrittweite:longint  );
procedure aufrunden_word_norm(var w:word_norm;const schrittweite:word_norm);
procedure aufrunden_word     (var w:word     ;const schrittweite:word     );

function  leer_filter(const zk:string):string;

function  bcd_zu_dezimal(const w:word_norm):word_norm;

function  Max(const l1,l2:longint):longint;
(*$IfDef VirtualPascal_*)
  inline;
  begin
    if l1>l2 then
      Max:=l1
    else
      Max:=l2;
  end;
(*$EndIf*)
function  Min(const l1,l2:longint):longint;
(*$IfDef VirtualPascal_*)
  inline;
  begin
    if l1<l2 then
      Min:=l1
    else
      Min:=l2;
  end;
(*$EndIf*)
function  MaxDGT(const l1,l2:dateigroessetyp):dateigroessetyp;
(*$IfDef VirtualPascal_*)
  inline;
  begin
    if l1>l2 then
      MaxDGT:=l1
    else
      MaxDGT:=l2;
  end;
(*$EndIf*)
function  MinDGT(const l1,l2:dateigroessetyp):dateigroessetyp;
(*$IfDef VirtualPascal_*)
  inline;
  begin
    if l1<l2 then
      MinDGT:=l1
    else
      MinDGT:=l2;
  end;
(*$EndIf*)

(*$IfNDef VirtualPascal*)
procedure SetLength(var s:string;const w:word_norm);
(*$EndIf VirtualPascal*)
procedure DecLength(var s:string);
procedure SubLength(var s:string;l:word_norm);

function stack_knapp:boolean;

procedure IncDGT(var o:dateigroessetyp;d:dateigroessetyp);
{  (*$IfDef VirtualPascal*)
  Inline;
  begin
    o:=o+d;
  end;
  (*$EndIf*)}

procedure DecDGT(var o:dateigroessetyp;d:dateigroessetyp);
{  (*$IfDef VirtualPascal*)
  Inline;
  begin
    o:=o-d;
  end;
  (*$EndIf*)}

function AndDGT(o:dateigroessetyp;d:dateigroessetyp):dateigroessetyp;
function ModDGT(o:dateigroessetyp;d:dateigroessetyp):dateigroessetyp;
function DivDGT(o:dateigroessetyp;d:dateigroessetyp):dateigroessetyp;

(*$IfNDef EndVersion*)
procedure dst(const s:string);
(*$EndIf EndVersion*)

procedure einrichten_typ_varx(const anfang:boolean);

implementation



uses
  (*$IfDef OS2*)
  os2base,
  (*$EndIf*)
  (*$IfDef VirtualPascal*)
  VpSysLow, (* SysGetCurrencyFormat *)
  (*$EndIf VirtualPascal*)
  typ_spra;

(*$IfDef OS2*)
const
  blink_daten:viointensity=
  (cb:sizeof(viointensity);
   rtype:2; (* Blink/Hell *)
   fs:1);   (* helle Hintergrundfarben *)
(*$EndIf*)

const
  tausendertrenner      :string1='.';
  dezimaltrenner        :char=',';

function gross(const zkk:string):string;
  var
    z:integer_norm;
  begin
    gross:=zkk;
    for z:=1 to Length(zkk) do
      case zkk[z] of
      'a'..'z':gross[z]:=Chr(Ord(zkk[z])-32);
      '„':gross[z]:='Ž';
      '”':gross[z]:='™';
      '':gross[z]:='š';
      end;
  end;


(*$IfDef TYP_EXE*)
procedure abbruch(const zk:string;const fehler:word_norm);
  begin
    abbruch_meldung:=zk;
    Halt;(* Aufruf der eigenen EXITPROC *)
  end;

(*$IfDef DOS_ODER_DPMI*)
procedure fuell_word(var anfang;const word_anz:word_norm;const muster:word);assembler;
  asm
    les di,[anfang]
    mov cx,[word_anz]
    mov ax,[muster]
    cld
    jcxz @fuellword_ende

    rep stosw

  @fuellword_ende:
  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
procedure fuell_word(var anfang;const word_anz:word_norm;const muster:word);assembler;
  (*$Uses ALL*)
  asm
    mov ecx,[word_anz]
    test ecx,ecx
    jz @fuel_word_fertig

    mov ax,[muster]
    mov edx,eax
    shl eax,16
    mov ax,dx

    mov edi,[anfang]
    cld

    shr ecx,1
    pushf
    rep stosd
    popf
    jnc @fuel_word_fertig

    stosw

    @fuel_word_fertig:

  end;
(*$EndIf*)

(*$IfDef DPMIX*)
procedure fuell_word(var anfang;const word_anz:word_norm;const muster:word);
  var
    za                  :longint;
    anfang_             :array[0..$7ffe] of word absolute anfang;
  begin
    for za:=1 to word_anz do
      anfang_[za-1]:=muster;
  end;
(*$EndIf*)

(*$IfDef DUMM*)
procedure fuell_word(var anfang;const word_anz:word_norm;const muster:word);
  var
    za                  :longint;
    offs                :longint;
    segm,offs           :word;
  begin
    segm:=Seg(anfang);
    offs:=Ofs(anfang);
    for za:=1 to word_anz do
      MemW[segm:offs+(za-1)*2]:=muster;
  end;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function x_word_far(const by0):word;assembler;
  asm
    les di,by0
    mov ax,es:[di]
  end;
function m_word(const by0):word;assembler;
  asm
    les di,by0
    mov ax,es:[di]
    xchg ah,al
  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
function m_word(const by0):word;assembler;(*$Frame-*)(*$Uses None*)
  asm
    mov eax,by0
    mov ax,[eax]
    xchg al,ah
  end;
(*$EndIf*)

(*$IfDef DPMIX*)
function m_word(const by0):word;
  begin
    m_word:=Swap(word_z(@by0)^);
  end;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function x_longint_far(const by0):longint;assembler;
  asm
    les di,by0
    mov dx,es:[di]
    mov ax,es:[di+2]
  end;
function  x_dateigroessetyp(const by0):dateigroessetyp;assembler;
  asm
    {$IfDef dateigroessetyp_comp}
    les di,by0
    fldi es:[di]
    fwait
    {$Else dateigroessetyp_comp}
    les di,by0
    mov dx,es:[di]
    mov ax,es:[di+2]
    {$EndIf dateigroessetyp_comp}
  end;
function  m_dateigroessetyp(const by0):dateigroessetyp;assembler;
  {$IfDef dateigroessetyp_comp}
  var
    c:comp;
  {$EndIf dateigroessetyp_comp}
  asm
    {$IfDef dateigroessetyp_comp}
    les si,by0
    lea di,c

    mov ax,[si+0]
    xchg al,ah
    mov [di+6],ax
    mov ax,[si+2]
    xchg al,ah
    mov [di+4],ax
    mov ax,[si+4]
    xchg al,ah
    mov [di+2],ax
    mov ax,[si+6]
    xchg al,ah
    mov [di+0],ax

    fldi c
    fwait
    {$Else dateigroessetyp_comp}
    les di,by0
    mov ax,es:[di]
    mov dx,es:[di+2]
    xchg al,ah
    xchg dl,dh
    {$EndIf dateigroessetyp_comp}
  end;
function m_longint(const by0):longint;assembler;
  asm
    les di,by0
    mov dx,es:[di]
    mov ax,es:[di+2]
    xchg al,ah
    xchg dl,dh
  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
function x_dateigroessetyp(const by0):dateigroessetyp;
  var
    c:dateigroessetyp absolute by0;
  begin
    x_dateigroessetyp:=c;
  end;
function m_dateigroessetyp(const by0):dateigroessetyp;assembler;(*$Frame-*)(*$Uses eax,edi*)
  asm
    {$IfDef dateigroessetyp_comp}
    mov edi,by0
    mov eax,[edi+4]
    xchg al,ah
    rol eax,16
    xchg al,ah
    push eax
    mov eax,[edi+0]
    xchg al,ah
    rol eax,16
    xchg al,ah
    push eax
    fld [esp].Comp
    fwait
    add esp,4+4
    {$Else dateigroessetyp_comp}
    mov eax,by0
    mov eax,[eax]
    xchg al,ah
    rol eax,16
    xchg al,ah
    {$EndIf dateigroessetyp_comp}
  end;
function m_longint(const by0):longint;assembler;(*$Frame-*)(*$Uses None*)
  asm
    mov eax,by0
    mov eax,[eax]
    xchg al,ah
    rol eax,16
    xchg al,ah
  end;
(*$EndIf*)

(*$IfDef dateigroessetyp_comp*)
function  x_long(const by0):dateigroessetyp;
  var
    w:dateigroessetyp;
  begin
    w:=x_dateigroessetyp(by0);
    x_long:=AndDGT(w,comp(bit32maske));
  end;
(*$Else dateigroessetyp_comp*)
function  x_long(const by0):dateigroessetyp;
  begin
    x_long:=longint_z(@by0)^;
  end;
(*$EndIf dateigroessetyp_comp*)

(*$IfDef DPMIX*)
function m_longint(const by0):longint;
  var
    mac_l:array[0..3] of byte absolute by0;
  begin
    m_longint:=longint(mac_l[0])*$01000000
              +longint(mac_l[1])*$00010000
              +longint(mac_l[2])*$00000100
              +longint(mac_l[3])*$00000001;
  end;
(*$EndIf*)

function DGT_zu_longint(n:dateigroessetyp):longint;
  begin
    (*$IfDef dateigroessetyp_comp*)
    with comp_rec(n) do
      if (0-(l0 shr 31))<>l1 then (* Vorzeichenerweiterung *)
      //if (n<Low(longint)) or (n>High(longint)) then
        DGT_zu_longint:=-1
      else
        DGT_zu_longint:=comp_rec(n).l0;
    (*$Else*)
    DGT_zu_longint:=n;
    (*$EndIf*)
  end;



(*$IfDef DOS_ODER_DPMI*)
function str_far(const z:longint;const ziffern:byte):string;
  var
    zk:string;
  begin
    System.Str(z:ziffern,zk);
    str_far:=zk;
  end;

function str0_far(const z:longint):string;
  var
    zk:string;
  begin
    System.Str(z,zk);
    str0_far:=zk;
  end;

function strx_oder_hex_far(const z:longint):string;
  begin
    if hexadezimal then
      begin
        if (z shr 16)<>0 then
          strx_oder_hex_far:=hex_longint(z)
        else if (z shr 8)<>0 then
          strx_oder_hex_far:=hex_word(z)
        else
          strx_oder_hex_far:=hex(z);
      end
    else
      strx_oder_hex_far:=leer_filter(strx(z,11));
  end;

function str11_oder_hex_far(const z:longint):string;
  begin
    if hexadezimal then
      str11_oder_hex_far:=hex_longint(z)
    else
      str11_oder_hex_far:=strx(z,11);
  end;

(*$EndIf*)

function str0_DGT(const z:dateigroessetyp):string;
  var
    tmp:string;
  begin
    (*$IfDef dateigroessetyp_comp*)
    System.Str(z:20:0,tmp);
    (*$Else -dateigroessetyp_comp*)
    System.Str(z:20,tmp);
    (*$EndIf -dateigroessetyp_comp*)
    str0_DGT:=leer_filter(tmp);
  end;

function strZ(const z:longint;n:word_norm):string;

  var
    (*$IfNDef VirtualPascal*)
    Result      :string;
    (*$EndIf*)
    i           :word_norm;
  begin
    System.Str(z:n,Result);
    for i:=1 to Length(Result) do
      if Result[i]=' ' then
        Result[i]:='0'
      else
        Break;
    (*$IfNDef VirtualPascal*)
    strZ:=Result;
    (*$EndIf*)
  end;

function strx_oder_hexDGT(const n:dateigroessetyp):string;
  (*$IfNDef VirtualPascal*)
  var
    Result      :string;
  (*$EndIf*)
  begin
    (*$IfDef dateigroessetyp_comp*)
    if hexadezimal then
      begin
        Result:=hex_DGT(n);
        while (Length(Result)>Length('$0')) and (Result[2]='0') do
          Delete(Result,2,Length('0'));
        (*$IfNDef VirtualPascal*)
        strx_oder_hexDGT:=Result;
        (*$EndIf*)
      end
    else
      strx_oder_hexDGT:=leer_filter(comp_strx(n,11));
    (*$Else*)
    strx_oder_hexDGT:=strx_oder_hex(n);
    (*$EndIf*)
  end;

function str9_oder_hex(const z:longint):string;
  var
    zk:string;
  begin
    if hexadezimal then
      str9_oder_hex:=hex_longint(z)
    else
      str9_oder_hex:=strx(z,9);
  end;

function  str11_oder_hexDGT(const n:dateigroessetyp):string;
  begin
    if hexadezimal then
      begin
        (*$IfDef dateigroessetyp_comp*)
        str11_oder_hexDGT:=strx_oder_hexDGT(n);
        (*$Else dateigroessetyp_comp*)
        str11_oder_hexDGT:=strx_oder_hex(n)
        (*$EndIf dateigroessetyp_comp*)
      end
    else
      str11_oder_hexDGT:=strxDGT(n,11);
  end;


(*$IfDef DPMIX*)
function str_(const z:longint;const ziffern:byte):string;
  var
    zk:string;
  begin
    System.Str(z:ziffern,zk);
    str_:=zk;
  end;
function str0(const z:longint):string;
  var
    zk:string;
  begin
    System.Str(z,zk);
    str0:=zk;
  end;
function strx_oder_hex(const z:longint):string;
  begin
    if hexadezimal then
      begin
        if (z shr 16)<>0 then
          strx_oder_hex:=hex_longint(z)
        else if (z shr 8)<>0 then
          strx_oder_hex:=hex_word(z)
        else
          strx_oder_hex:=hex(z);
      end
    else
      strx_oder_hex:=leer_filter(strx(z,11));
  end;

function str11_oder_hex(const z:longint):string;
  begin
    if hexadezimal then
      str11_oder_hex:=hex_longint(z)
    else
      str11_oder_hex:=strx(z,11);
  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
function str_(const z:longint;const ziffern:byte):string;
  begin
    System.Str(z:ziffern,Result);
  end;
function str0(const z:longint):string;
  begin
    System.Str(z,Result);
  end;
function strx_oder_hex(const z:longint):string;
  begin
    if hexadezimal then
      begin
        if (z shr 16)<>0 then
          strx_oder_hex:=hex_longint(z)
        else if (z shr 8)<>0 then
          strx_oder_hex:=hex_word(z)
        else
          strx_oder_hex:=hex(z);
      end
    else
      strx_oder_hex:=leer_filter(strx(z,11));
  end;
function str11_oder_hex(const z:longint):string;
  begin
    if hexadezimal then
      str11_oder_hex:=hex_longint(z)
    else
      str11_oder_hex:=strx(z,11);
  end;

(*$EndIf*)

function strx(const z:longint;const ziffern:byte):string;
  var
    (*$IfNDef VirtualPascal*)
    result      :string;
    (*$EndIf*)
    l           :byte;
  begin
    System.Str(z:ziffern,result);
    l:=Length(result);
    if ziffern>=11 then
      begin
        if (result[1]=' ') and (result[l-3] in ['0'..'9']) then
          begin
            Delete(result,1,1);
            Insert(tausendertrenner,result,l-3);
          end;
        if (result[1]=' ') and (result[l-4-3] in ['0'..'9']) then
          begin
            Delete(result,1,1);
            Insert(tausendertrenner,result,l-4-3);
          end;
      end;
    (*$IfNDef VirtualPascal*)
    strx:=result;
    (*$EndIf*)
  end;

function strxDGT(const z:dateigroessetyp;const ziffern:byte):string;
  begin
   (*$IfDef dateigroessetyp_comp*)
   strxDGT:=comp_strx(z,ziffern);
   (*$Else*)
   strxDGT:=strx(z,ziffern);
   (*$EndIf*)
  end;

(*$IfDef dateigroessetyp_comp*)
function comp_strx(c:comp;const ziffern:byte):string;
  (*$IfNDef VirtualPascal*)
  var
    Result:string;
  (*$EndIf*)
  var
    prefix      :string[3];
    l           :byte;
  begin
    prefix:='';

    if ziffern=11 then
      begin
        (*$IfDef dateigroessetyp_comp*)
        if Abs(c)>999999.0*1024*1024*1024*1024 then (* >' 999.999 Ti' *)
          begin
            c:=c/(1024.0*1024*1024*1024*1024);
            prefix:=' Ei';
          end
        else
        if Abs(c)>999999.0*1024*1024*1024 then (* >' 999.999 Gi' *)
          begin
            c:=c/(1024.0*1024*1024*1024);
            prefix:=' Ti';
          end
        else
        if Abs(c)>999999.0*1024*1024 then (* >' 999.999 Mi' *)
          begin
            c:=c/(1024.0*1024*1024);
            prefix:=' Gi';
          end
        else
        if Abs(c)>999999999 then (* >'999.999.999' *)
          begin
            c:=c/(1024.0*1024);
            prefix:=' Mi';
          end;
        (*  ' 999.999 Ki' bringt keinen Platzgewinn *)
        (*$EndIf dateigroessetyp_comp*)
      end;


    System.Str(c:ziffern-Length(prefix):0,Result);
    l:=Length(result);
    if ziffern>=11 then
      begin
        if (result[1]=' ') and (result[l-3] in ['0'..'9']) then
          begin
            Delete(result,1,1);
            Insert(tausendertrenner,result,l-3);
          end;
        if (result[1]=' ') and (result[l-4-3] in ['0'..'9']) then
          begin
            Delete(result,1,1);
            Insert(tausendertrenner,result,l-4-3);
          end;
      end;
    result:=result+prefix;
    (*$IfNDef VirtualPascal*)
    strx:=result;
    (*$EndIf*)
  end;
(*$EndIf dateigroessetyp_comp*)

(*$IfDef dateigroessetyp_comp*)
function comp_str0(c:comp):string;
  (*$IfNDef VirtualPascal*)
  var
    Result:string;
  (*$EndIf*)
  begin
    System.Str(c:0:0,Result);
    (*$IfNDef VirtualPascal*)
    comp_str0:=Result;
    (*$EndIf*)
  end;
(*$EndIf dateigroessetyp_comp*)

function DGT_str0(l:dateigroessetyp):string;
  begin
    (*$IfDef dateigroessetyp_comp*)
    DGT_str0:=comp_str0(l);
    (*$Else*)
    DGT_str0:=str0(l);
    (*$EndIf*)
  end;

function r_str(const z:real;const ziffern,nachkomma:byte):string;
  (*$IfNDef VirtualPascal*)
  var
    Result:string;
  (*$EndIf*)
  begin
    System.Str(z:ziffern:nachkomma,Result);
    if Pos('.',Result)>0 then
      Result[Pos('.',Result)]:=dezimaltrenner;
    (*$IfNDef VirtualPascal*)
    r_str:=Result;
    (*$EndIf*)
  end;

const
  hexadezimalziffern:array[0..15] of char=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

function hex(const z:byte):string;
  begin
    (*$IfDef VirtualPascal*)
    SetLength(Result,1+2);
    Result[1]:='$';
    Result[2]:=hexadezimalziffern[z shr  4];
    Result[3]:=hexadezimalziffern[z and $F];
    (*$Else*)
    hex:='$'+hexadezimalziffern[z shr  4]
            +hexadezimalziffern[z and $F];
    (*$EndIf*)
  end;

function hex_word(const w:word):string;
  var
    (*$IfNDef VirtualPascal*)
    Result      :string5;
    (*$EndIf*)
    wr          :
      packed record
        lo,hi:byte;
      end       absolute w;

  begin
    with wr do
      begin
        (*$IfDef VirtualPascal*)
        SetLength(Result,5);
        (*$Else*)
        Result[0]:=#5;
        (*$EndIf*)
        Result[1]:='$';
        Result[2]:=hexadezimalziffern[hi shr  4];
        Result[3]:=hexadezimalziffern[hi and $F];
        Result[4]:=hexadezimalziffern[lo shr  4];
        Result[5]:=hexadezimalziffern[lo and $F];
      end;
    (*$IfNDef VirtualPascal*)
    hex_word:=Result;
    (*$EndIf*)
  end;

function hex_longint(const l:longint):string;
  (*$IfNDef VirtualPascal*)
  var
    Result:string10;
  (*$EndIf*)
  var
    lr:
      packed record
        lo,hi:word;
      end absolute l;
  begin
    with lr do
      Result:=hex_word(hi)
             +hex_word(lo);
    Delete(Result,1+4+1,1);
    (*$IfNDef VirtualPascal*)
    hex_longint:=Result;
    (*$EndIf*)
  end;

function hex_longint_min(const l:longint):string;
  (*$IfNDef VirtualPascal*)
  var
    Result:string10;
  (*$EndIf*)
  var
    lr:
      packed record
        lo,hi:word;
      end absolute l;
  begin
    with lr do
      Result:=hex_word(hi)
             +hex_word(lo);
    Delete(Result,1+4+1,1);
    while (Length(Result)>Length('$0')) and (Pos('$0',Result)=1) do
      Delete(Result,2,Length('0'));
    (*$IfNDef VirtualPascal*)
    hex_longint_min:=Result;
    (*$EndIf*)
  end;

(*$IfDef dateigroessetyp_comp*)
function hex_DGT(const l:dateigroessetyp):string;
  (*$IfNDef VirtualPascal*)
  var
    Result:string20;
  (*$EndIf*)
  var
    lrec:comp_rec absolute l;
  begin
    with lrec do
      Result:=hex_longint(l1)
             +hex_longint(l0);
    Delete(Result,1+8+1,1);
    (*$IfNDef VirtualPascal*)
    hex_longint:=Result;
    (*$EndIf*)
  end;
(*$Else dateigroessetyp_comp*)
function hex_DGT(const l:dateigroessetyp):string;
  begin
    hex_DGT:=hex_longint(l);
  end;
(*$EndIf dateigroessetyp_comp*)

function prozent(const anteil,voll:dateigroessetyp):dateigroessetyp;
  begin
    if voll=0 then
      prozent:=0
    else
      if voll>1000000 then
        (*$IfDef dateigroessetyp_comp*)
        prozent:=anteil /   (voll /   100)
        (*$Else*)
        prozent:=anteil div (voll div 100)
        (*$EndIf*)
      else
        (*$IfDef dateigroessetyp_comp*)
        prozent:=anteil*100 /   voll;
        (*$Else*)
        prozent:=anteil*100 div voll;
        (*$EndIf*)
  end;
(*$EndIf TYP_EXE*)

procedure bestimme_switch_char;
  begin
    (*$IfDef VirtualPascal*)
    switch_char:='-';
    (*$Else*)
    asm
      mov ax,$3700
      int $21
      cmp ax,00
      jz @switch_char_bestimmt
      mov dl,$2f
      @switch_char_bestimmt:
      mov switch_char,dl
    end;
    (*$EndIf*)
  end;

procedure blinken_aus;
  begin
    (*$IfDef OS2*)
    fehler_val:=VioSetState(blink_daten, 0) (* 0=VioHandle *)
    (*$EndIf OS2*)
    (*$IfDef DOS_ODER_DPMI_ODER_DPMI32*)
    asm(* Blinken aus *)
      mov ax,$1003
      mov bl,0
      int $10
    end;
    (*$EndIf DOS_ODER_DPMI_ODER_DPMI32*)
  end;

procedure leerzeichenerweiterung(var zk:string;const stellen:byte);
  var
    l:word_norm;
  begin
    if Length(zk)<stellen then
      begin
        l:=Length(zk);
        SetLength(zk,stellen);
        FillChar(zk[l+1],stellen-l,' ');
      end;
  end;

function leerzeichenerweiterung_f(const zk:string;const stellen:byte):string;
  var
    tmp:string;
  begin
    tmp:=zk;
    leerzeichenerweiterung(tmp,stellen);
    leerzeichenerweiterung_f:=tmp;
  end;

function ror8(const by:byte;r:byte):byte;
  begin
    (*$IfDef DOS_ODER_DPMI*)
    asm
      mov al,by
      mov cl,r
      ror al,cl
      mov @result,al
    end;
    (*$EndIf*)

    (*$IfDef VirtualPascal*)
    asm
      mov al,by
      mov cl,r
      ror al,cl
      mov @result,al
    end;
    (*$EndIf*)

    (*$IfDef DUMM*)
    r:=r and $07;
    (* r and $7 weil ror8(x,z+8)=ror8(x,z) *)
    ror8:=((word(by) shr r)) or (word(by shl 8) shr r)) and $ff;
    (*$EndIf*)
  end;

function ror32(const l:longint;r:byte):longint;
  begin
    (*$IfDef DOS_ODER_DPMI*)
    asm
      mov ax,Word Ptr [l+0]
      mov dx,Word Ptr [l+2]
      mov cl,r
      mov ch,0
      test cx,cx
      jz @U
    @R:
      ror dx,1
      rcr ax,1
      dec cx
      jnz @R
    @U:
      mov Word Ptr @result+0,ax
      mov Word Ptr @result+2,dx
    end;
    (*$EndIf*)

    (*$IfDef VirtualPascal*)
    asm
      mov eax,l
      mov cl,r
      ror eax,cl
      mov @result,eax
    end;
    (*$EndIf*)

    (*$IfDef DUMM*)
    r:=r and 31;
    ror32:=(l shr r) or (l shl (32-r));
    (*$EndIf*)
  end;

function aufrundenf(const l,schrittweite:longint):longint;
  begin
    if (l mod schrittweite)=0 then
      aufrundenf:=l
    else
      aufrundenf:=l-(l mod schrittweite)+schrittweite;
  end;

procedure aufrunden_longint  (var l:longint  ;const schrittweite:longint  );
  begin
    if (l mod schrittweite)<>0 then
      inc(l,schrittweite-(l mod schrittweite));
  end;

procedure aufrunden_word_norm(var w:word_norm;const schrittweite:word_norm);
  begin
    if (w mod schrittweite)<>0 then
      inc(w,schrittweite-(w mod schrittweite));
  end;

procedure aufrunden_word     (var w:word     ;const schrittweite:word     );
  begin
    if (w mod schrittweite)<>0 then
      inc(w,schrittweite-(w mod schrittweite));
  end;

function leer_filter(const zk:string):string;
  var
    tzk                 :string;
  begin
    tzk:=zk;
    while (tzk<>'') and (tzk[1          ] in [#0,#9,' ',#13,#10]) do
      Delete(tzk,1,1);
    while (tzk<>'') and (tzk[Length(tzk)] in [#0,#9,' ',#13,#10]) do
      Dec(tzk[0]);
    leer_filter:=tzk;
  end;

function bcd_zu_dezimal(const w:word_norm):word_norm;
  var
    a,e,p               :word_norm;
  begin
    a:=w;
    e:=0;
    p:=1;
    while a>0 do
      begin
        Inc(e,p*(a and $f));
        a:=a shr 4;
        p:=p*10;
      end;
    bcd_zu_dezimal:=e;
  end;

(*$IfNDef VirtualPascal_*)
function  max(const l1,l2:longint):longint;
  begin
    if l1>l2 then
      max:=l1
    else
      max:=l2;
  end;
function  min(const l1,l2:longint):longint;
  begin
    if l1<l2 then
      min:=l1
    else
      min:=l2;
  end;
function  MaxDGT(const l1,l2:dateigroessetyp):dateigroessetyp;
  begin
    if l1>l2 then
      MaxDGT:=l1
    else
      MaxDGT:=l2;
  end;
function  MinDGT(const l1,l2:dateigroessetyp):dateigroessetyp;
  begin
    if l1<l2 then
      MinDGT:=l1
    else
      MinDGT:=l2;
  end;
(*$EndIf*)

(*$IfNDef VirtualPascal*)
procedure SetLength(var s:string;const w:word_norm);
  begin
    s[0]:=Chr(Min(w,255));
  end;
(*$EndIf VirtualPascal*)

procedure DecLength(var s:string);
  begin
    if s<>'' then
      Dec(s[0]);
  end;

procedure SubLength(var s:string;l:word_norm);
  begin
    l:=Min(Length(s),l);
    s[0]:=Chr(Length(s)-l);
  end;


(*$IfDef VirtualPascal*)
function stack_knapp:boolean;assembler;
  {&Frame-}{&Uses None}
  asm
    mov eax,esp
    sub eax,fs:[4]
    cmp eax,8*1024
    setb al
  end;
(*$Else*)
(*$IfDef MSDOS*)
function stack_knapp:boolean;assembler;
  asm
    mov ax,sp
    sub ax,stacklimit
    cmp ax,8*1024
    mov ax,0
    jnb @ret
    inc ax
  @ret:
  end;
(*$Else*)
function stack_knapp:boolean;
  begin
    stack_knapp:=false;
  end;
(*$EndIf*)
(*$EndIf*)

(*$IfDef VirtualPascal*)
(*$IfDef dateigroessetyp_comp*)
procedure IncDGT(var o:dateigroessetyp;d:dateigroessetyp);assembler;
  (*&Uses eax*)(*&Frame-*)
  asm
    mov eax,[o]
    fIld [eax].dateigroessetyp
    fIld [d]
    fAddP ST(1),ST
    fIstP [eax].dateigroessetyp
  end;
(*$Else dateigroessetyp_comp*)
procedure IncDGT(var o:dateigroessetyp;d:dateigroessetyp);assembler;
  (*&Uses eax,edx*)(*&Frame-*)
  asm
    mov edx,[o]
    mov eax,[edx]
    add eax,[d]
  end;
(*$EndIf dateigroessetyp_comp*)
(*$IfDef dateigroessetyp_comp*)
procedure DecDGT(var o:dateigroessetyp;d:dateigroessetyp);assembler;
  (*&Uses eax*)(*&Frame-*)
  asm
    mov eax,[o]
    fIld [eax].dateigroessetyp
    fIld [d]
    fSubP ST(1),ST
    fIstP [eax].dateigroessetyp
  end;
(*$Else dateigroessetyp_comp*)
procedure DecDGT(var o:dateigroessetyp;d:dateigroessetyp);assembler;
  (*&Uses eax,edx*)(*&Frame-*)
  asm
    mov edx,[o]
    mov eax,[edx]
    sub eax,[d]
  end;
(*$EndIf dateigroessetyp_comp*)
(*$Else*)
(*$IfDef dumm*)
procedure IncDGT(var o:dateigroessetyp;d:dateigroessetyp);
  begin
    o:=o+d;
  end;
procedure DecDGT(var o:dateigroessetyp;d:dateigroessetyp);
  begin
    o:=o-d;
  end;
(*$Else dumm*)
procedure IncDGT(var o:dateigroessetyp;d:dateigroessetyp);
  {asm
    les di,[o]
    mov ax,[
    (*$IfDef dateigroessetyp_comp*)
    mov ax,comp_rec(
    o:=o+d;
    (*$Else dateigroessetyp_comp*)
    inline(
      $cc); mov ax,d
    (*$EndIf dateigroessetyp_comp*)}
  begin
    o:=o+d;
  end;
procedure DecDGT(var o:dateigroessetyp;d:dateigroessetyp);
  begin
    {inline(
      $cc);}
    o:=o-d;
  end;
(*$EndIf dumm*)
(*$EndIf VirtualPascal*)

function AndDGT(o:dateigroessetyp;d:dateigroessetyp):dateigroessetyp;
  (*$IfDef dateigroessetyp_comp*)
  var
    orec:comp_rec absolute o;
    drec:comp_rec absolute d;
  (*$EndIf*)
  begin
    (*$IfDef dateigroessetyp_comp*)
    with comp_rec(Result) do
      begin
        l0:=orec.l0 and drec.l0;
        l1:=orec.l1 and drec.l1;
      end
    (*$Else*)
    AndDGT:=o and d;
    (*$EndIf*)
  end;

(*$IfDef dateigroessetyp_comp*)
function ModDGT(o:dateigroessetyp;d:dateigroessetyp):dateigroessetyp;assembler;
  var
    org_controlword,
    round_controlword   :smallword;
  asm
    // Result:=o-Trunc(o/d)*d
    fIld o
    fIld d
    fDivP ST(1),ST
    fStCw org_controlword
    mov ax,org_controlword
    and ah,(not 3*4)    // rounding control: bit 11..10
    or ah,(1*4)         // 1: round down
    mov round_controlword,ax
    fLdCw round_controlword
    fRndInt
    fIld d
    fMulP ST(1),ST
    fIld o
    fXch ST(1)
    fSubP ST(1),ST
    fWait
    fLdCw org_controlword
  end;
(*$Else*)
function ModDGT(o:dateigroessetyp;d:dateigroessetyp):dateigroessetyp;
  begin
    ModDGT:=o mod d;
  end;
(*$EndIf*)

(*$IfDef dateigroessetyp_comp*)
function DivDGT(o:dateigroessetyp;d:dateigroessetyp):dateigroessetyp;assembler;
  var
    org_controlword,
    round_controlword   :smallword;
  asm
    // Result:=Trunc(o/d)
    fIld o
    fIld d
    fDivP ST(1),ST
    fStCw org_controlword
    mov ax,org_controlword
    and ah,(not 3*4)    // rounding control: bit 11..10
    or ah,(1*4)         // 1: round down
    mov round_controlword,ax
    fLdCw round_controlword
    fRndInt
    fWait
    fLdCw org_controlword
  end;
(*$Else*)
function DivDGT(o:dateigroessetyp;d:dateigroessetyp):dateigroessetyp;
  begin
    DivDGT:=o div d;
  end;
(*$EndIf*)

(*$IfNDef EndVersion*)
procedure dst(const s:string);
  begin
    WriteLn(s);
    ReadLn;
  end;
(*$EndIf EndVersion*)


procedure einrichten_typ_varx(const anfang:boolean);
  (*$IfDef VirtualPascal*)
  var
    CString:array[0..259] of char;
    CFormat,CNegFormat,CDecimals:byte;
  (*$EndIf VirtualPascal*)

  begin
    if anfang then
      begin
        (*$IfDef VirtualPascal*)
        SysGetCurrencyFormat(CString,CFormat,CNegFormat,CDecimals,tausendertrenner[1],dezimaltrenner);
        (*$EndIf VirtualPascal*)
        (*$IfDef TYP_EXE*)
        abbruch_meldung:='';
        (*$EndIf*)

        (*$IfDef TERM_ROLLEN*)
        terminal_namen[term_rollen   ]:=textz_varx__16_16_Farben_EGA_VGA_mit_punktweisem_Rollen^;
        (*$EndIf*)

        (*$IfDef TERM_FARBIG*)
        terminal_namen[term_farbig   ]:=textz_varx__16_16_Farben_CGA_schnell^;
        (*$EndIf*)
        terminal_namen[term_ansi     ]:=textz_varx__16_16_Farben_Ansi_lahm^;
        terminal_namen[term_mono     ]:=textz_varx__2_2_Farbe_Ascii_maessig^;
        terminal_namen[term_gefiltert]:=textz_varx__2_2_Farben_Ascii_gefiltert^;
        terminal_namen[term_html     ]:=textz_varx__html_mono^;

        (* Problemreport TYP3 mit maus Fehlermeldung angeblicher direkter Hardwarezugriff *)

        (*$IfDef DOS_ODER_DPMI_ODER_DPMI32*)
        asm
          mov ax,$160a
          int $2f
          or ax,ax  (* ax=0 -> windoofs *)
          jnz @ohne_kruecken
          mov maustreiber,false
        @ohne_kruecken:
        end;
        (*$EndIf*)
      end

  end;

begin
  (*
  WriteLn(ModDGT( 10001,10):0:2);
  WriteLn(ModDGT(-10001,10):0:2);
  WriteLn(DivDGT( 10001,10):0:2);
  WriteLn(DivDGT(-10001,10):0:2);
  ReadLn;
  Halt;*)
  einrichten_typ_varx(true);
end.

