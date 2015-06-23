(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_type;

interface

const
  bit00                         =1 shl  0;
  bit01                         =1 shl  1;
  bit02                         =1 shl  2;
  bit03                         =1 shl  3;
  bit04                         =1 shl  4;
  bit05                         =1 shl  5;
  bit06                         =1 shl  6;
  bit07                         =1 shl  7;
  bit08                         =1 shl  8;
  bit09                         =1 shl  9;
  bit10                         =1 shl 10;
  bit11                         =1 shl 11;
  bit12                         =1 shl 12;
  bit13                         =1 shl 13;
  bit14                         =1 shl 14;
  bit15                         =1 shl 15;
  bit16                         =1 shl 16;
  bit17                         =1 shl 17;
  bit18                         =1 shl 18;
  bit19                         =1 shl 19;
  bit20                         =1 shl 20;
  bit21                         =1 shl 21;
  bit22                         =1 shl 22;
  bit23                         =1 shl 23;
  bit24                         =1 shl 24;
  bit25                         =1 shl 25;
  bit26                         =1 shl 26;
  bit27                         =1 shl 27;
  bit28                         =1 shl 28;
  bit29                         =1 shl 29;
  bit30                         =1 shl 30;
  bit31                         =1 shl 31;

  falsch                        =system.false;
  wahr                          =system.true;
  nicht_gefunden                =$FFFF;
  fast_unendlich                =$3fffffff;
  unendlich                     =$7FFFFFFF;

  witz:string[226]=^m^j
                  +^m^j
                  +^m^j'          Was ist ein Dieselfisch?'
                  +^m^j'      Pilze werden zum Gemse gerechnet ...'
                  +^m^j'   W„re es nicht einfacher den Quelltext zu lesen?'
                  +^m^j' Will produce faster (but slightly larger) depacker. Will cost you 2 - 3 bytes.'
(*                +^m^j' Mutter bekommt CD-Hllen nicht auf, Kind bekommt Marmeladengl„ser nicht auf' *)
                  +^m^j (* '>>>>>>>>>>>>>>>>' *);

type
  n08                           =System.byte;
  n16                           =System.word;
  z07                           =System.shortint;
  z15                           =System.integer;
  z31                           =System.longint;

  smallint                      =z15;
  smallword                     =n16;

  blockread_groesse=
  (*$IfDef TYP_DOS*)
                                word;
  (*$EndIf*)
  (*$IfDef TYP_DPMI*)
                                word;
  (*$EndIf*)
  (*$IfDef TYP_DPMI32*)
                                longint;
  (*$EndIf*)
  (*$IfDef TYP_LNX*)
                                longint;
  (*$EndIf*)
  (*$IfDef TYP_OS2*)
                                longint;
  (*$EndIf*)
  (*$IfDef TYP_W32*)
                                longint;
  (*$EndIf*)


  integer_norm=
  (*$IfDef TYP_DOS*)
                                integer;
  (*$EndIf*)
  (*$IfDef TYP_DPMI*)
                                integer;
  (*$EndIf*)
  (*$IfDef TYP_DPMI32*)
    (*$IfDef TYPEIN_EXE_TP*)
                                integer;
    (*$Else*)
                                longint;
    (*$EndIf*)
  (*$EndIf*)
  (*$IfDef TYP_LNX*)
                                longint;
  (*$EndIf*)
  (*$IfDef TYP_OS2*)
                                longint;
  (*$EndIf*)
  (*$IfDef TYP_W32*)
                                longint;
  (*$EndIf*)

  word_norm=
  (*$IfDef TYP_DOS*)
                                word;
  (*$EndIf*)
  (*$IfDef TYP_DPMI*)
                                word;
  (*$EndIf*)
  (*$IfDef TYP_DPMI32*)
                                longint;
  (*$EndIf*)
  (*$IfDef TYP_LNX*)
                                longint;
  (*$EndIf*)
  (*$IfDef TYP_OS2*)
                                longint;
  (*$EndIf*)
  (*$IfDef TYP_W32*)
                                longint;
  (*$EndIf*)

  buntzeilen_typ                =array[1..80,1..2] of byte;

(*maxbildschirm_typ             =array[1..70] of buntzeilen_typ;*)
  maxbildschirm_typ             =array[1..2*100+4] of buntzeilen_typ;

  string1                       =string[1];
  string3                       =string[3];
  string5                       =string[5];
  string8                       =string[8];
  string9                       =string[9];
  string10                      =string[10];

  char4                         =array[1..4] of char;

  puffer_daten_typ              =array[0..511] of byte;

  (*$IfDef VirtualPascal*)
  speicherbereich               =array[0..$7fffffff] of byte;
  (*$Else*)
  speicherbereich               =array[0..$0000fffe] of byte;
  (*$EndIf*)

  speicherbereich_z             =^speicherbereich;

  puffertyp=
    record
      g:word;
      d:puffer_daten_typ;
    end;
  puffer_zeiger_typ             =^puffertyp;

  cd_puffer_typ                 =array[0..2047] of char;
  z_cd_puffer_typ               =^cd_puffer_typ;


  aus_attribute=(
    normal,
    compiler,
    packer_dat,
    packer_exe,
    musik_bild,
    overlay_,
    dat_fehler,
    virus,
    dos_win_extender,
    beschreibung,
    signatur,
    bibliothek,
    spielstand,
    farblos,
    rand);

  aus_attr_namen_typ            =array[normal..rand] of ^string;

  strz                          =^string;
  strzz                         =^strz;

  spaltenplatz                  =(anstrich,vorne,absatz,leer,ea_zeichen);

  byte_z                        =^byte;
  word_z                        =^word;
  integer_z                     =^integer;
  longint_z                     =^longint;

(*$IfDef dateigroessetyp_comp*)
  dateigroessetyp               =comp;
  comp_rec                      =
    packed record
      l0,l1                     :longint;
    end;
  comp_z                        =^comp;
  dateigroessetyp_z             =^dateigroessetyp;
(*$Else*)
  dateigroessetyp               =longint;
  dateigroessetyp_z             =^dateigroessetyp;
  comp_z                        =^dateigroessetyp; (* geschummelt *)
(*$EndIf*)
  ptr_rec                       =
    packed record
      offs                      :word_norm;
(*$IfDef KEINE_SEGMENTE*)
(*$Else KEINE_SEGMENTE*)
      selector                  :smallword;
(*$EndIf KEINE_SEGMENTE*)
    end;

implementation

begin

  asm
    (*$IfDef DOS_ODER_DPMI*)
    mov ax,offset witz
    (*$EndIf*)
    (*$IfDef DPMI*)
      (*$IfNDef ENDVERSION*)
        (*sub ax,ax
        int $16*)
      (*$EndIf*)
    (*$EndIf*)
    (*$IfDef VirtualPascal*)
    mov eax,offset witz
    (*$EndIf*)
  end;

end.

