(*$I TYP_COMP.PAS*)
unit typ_var;

interface

uses
  typ_type,
  dos;

procedure puffer_gross(const quelle:puffertyp;var ziel:puffertyp);
function  fehlertext(const fn:word):string;
function  exe_dateierweiterung(const name_,erweiterung:string):boolean;
procedure zeichenfilter(var zk:string);
procedure html_filter(var zk:string);
function  filter(const zk:string):string;

(*$IfDef DOS_ODER_DPMI*)
function  bytesuche_far(const feld;const pruefzk:string):boolean;
const     adr_bytesuche:pointer=@bytesuche_far;
function  bytesuche(const feld;const pruefzk:string):boolean;
  inline($ff/$1e/>adr_bytesuche);
(*$Else*)
function  bytesuche(const feld;const pruefzk:string):boolean;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function  puffer_zu_zk_l_far(const p;const l:byte):string;
const     adr_puffer_zu_zk_l:pointer=@puffer_zu_zk_l_far;
function  puffer_zu_zk_l(const p;const l:byte):string;
  inline($ff/$1e/>adr_puffer_zu_zk_l);
(*$Else*)
function  puffer_zu_zk_l(const p;const l:byte):string;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function  puffer_zu_zk_e_far(const p;const e:string;maxl:integer_norm):string;
const     adr_puffer_zu_zk_e:pointer=@puffer_zu_zk_e_far;
function  puffer_zu_zk_e(const p;const e:string;maxl:integer_norm):string;
  inline($ff/$1e/>adr_puffer_zu_zk_e);
(*$Else*)
function puffer_zu_zk_e(const p;const e:string;maxl:integer_norm):string;
(*$EndIf*)

function  puffer_zu_zk_zeilenende(const p;maxl:integer_norm):string;
function  puffer_zu_zk_zeilenende2(const p:puffertyp;const posi,maxl:integer_norm):string;
function  puffer_zu_zk_pstr(const p):string;

(*$IfDef DOS_ODER_DPMI*)
function  puffer_pos_suche_far(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
const     adr_puffer_pos_suche:pointer=@puffer_pos_suche_far;
function  puffer_pos_suche(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
  inline($ff/$1e/>adr_puffer_pos_suche);
(*$Else*)
function  puffer_pos_suche(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
(*$EndIf*)
function  puffer_pos_suche_rueckwaerts(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;

function  puffer_pos_suche_anfang(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
function  puffer_anzahl_suche(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
function  puffer_gefunden(const p:puffertyp;const suchzk:string):boolean;
function  ist_ohne_steuerzeichen(const s:string):boolean;
function  ist_ohne_steuerzeichen_nicht_so_streng(const s:string):boolean;
procedure tabexpand(var zk:string);
function  ziffer(const sys:byte;const str:string):dateigroessetyp;
function  ziffer_tar(const sys:byte;const str:string):dateigroessetyp;
function  val_f(const s:string):dateigroessetyp;
procedure zk_anhaengen(var zk1:string;const zk2:string);
procedure exezk_anhaengen(const zk2:string);
procedure exezk_anhaengen_komma(const zk2:string);
function  puffer_zeilen_anfang_suche(const p:puffertyp;const zk:string):boolean;
function  puffer_zeilen_anfang_suche_pos(const p:puffertyp;const zk:string):word_norm;
procedure suche_wortanfang(const p:puffertyp;var posi:word_norm);
procedure suche_zeilenanfang(const p:puffertyp;var posi:word_norm);
function  in_doppelten_anfuerungszeichen(const zk:string):string;
procedure exezk_in_doppelten_anfuerungszeichen;
function  vergleiche_zk_ende(const teil,zk:string):boolean;
procedure exezk_von1250;
procedure umformung_quote_base64;

const
  textzeichen           :set of char=
    [' ','0'..'9','A'..'Z','a'..'z','Ž','™','š','„','”','',
     '.',',',';','(',')','&','/','`','-','+','_','#','[',']','*',':'];

  (*$IfDef BILDWIEDERHOLRATE*)
  strahl_ruecklaeufe    :word=10;
  (*$EndIf*)


  zeige_ueberhang_nicht_an:boolean=falsch;

type

  maskentyp             =pathstr;

  quelle_typ=
    record
      sorte             :(q_datei,q_speicher,q_sektor_bios_cxdx,q_sektor_bios_zks,q_sektor_dos,q_ea,q_entpackt_puffer);
      bios_cx           :smallword;
      bios_dx           :smallword;
      dos_nr            :dateigroessetyp;
      dos_lw            :byte;
      ea_anzahl         :word;
      ea_groesse        :longint;
      zylinder          :word_norm;     (* q_sektor_bios_zks *)
      kopf              :word_norm;     (* q_sektor_bios_zks *)
      sektor            :word_norm;     (* q_sektor_bios_zks *)
      platte            :word_norm;     (* q_sektor_bios_zks *)
      sektoren_je_spur  :word_norm;     (* q_sektor_bios_zks *)
      anzahl_koepfe     :word_norm;     (* q_sektor_bios_zks *)
      entpackt_laenge   :longint;       (* q_entpackt_puffer *)
    end;

var
  quelle,quelle_kopie   :quelle_typ;
  absatzbeginn          :spaltenplatz;

  exe,
  exe_sys_datei,
  physikalisch,
  suche_beendet,
  o1,o2,u1,u2,
  vermutung_pk,
  com2exe_test,
  codebuilder,
  unterverzeichnis_para,
  trk_erweiterung,
  chklist_name,
  rid_erweiterung,
  cpz_erweiterung,
  ari_erweiterung,
  pgp_erweiterung,
  mpeg_erweiterung,
(*wpi_erweiterung,*)
  hmi_386,
  pocket_soft,
  ende_suche_erzwungen,
  file_id_diz_datei,
  textdatei,
  x_exe_vorhanden,
  zwischzeile,
  pruefsummezeigen      :boolean;


  lib_page_size,(* 16/512                        *)
  codeoff_seg,  (* def cs_off:= ( ( position cs:0 in exe ) - analyseoff ) div  16 *)
  codeoff_off,
  org_code_seg,
  org_code_off          :longint;


  lib_lib_start,(* wo h”ren OMF-OBJ-Module auf? *)
  dateilaenge,
  analyseoff,
  org_code_imagestart,
  sektor_off,
  ds_off,       (* def ds_off:= ( position ds:0 in exe ) - analyseoff *)
  relo_off,
  x_exe_ofs,
  x_exe_basis,
  typ_start_zeit,
  li                    :dateigroessetyp;

  gelesen,
  kontrolle,
  zeilenpuffer_attr,
  sekt_bios_fehler,
  sekt_dos_fehler,
  dos_version,
  fehler,
  stack_inhalt,
  such_fehler           :word;

  parameternr,
  b1,b2,
  stringende,
  z,
  hyperdisk_schalter,
  speicher              :byte;


  orgexitproc           :pointer;

  analysepuffer         :puffertyp;

  exezk,
  dateiname             :string;

  dt                    :datetime;


  dat_zeit_rec          :datetime;

  para                  :string;
  pf,pfad               :dirstr;
  na,name               :namestr;
  ex,erweiterung        :extstr;
  erstverzeichnis       :pathstr;

  einzel_laenge         :dateigroessetyp;

  exe_kopf:
    record
      xx                :smallword;
      signatur,
      sektorrest,
      sektoren,
      relokationspositionen,
      kopfgroesse,
      memmin,
      memmax,
      stackoffset,
      sp_wert,
      pruefsumme,
      ip_wert,
      cs_wert,
      relooffset,
      overlaynummer     :smallword;
      x                 :array[$1c..$3b] of byte;
      ne_exe_offset     :longint;
    end absolute analysepuffer;

  lw_tabelle            :array['A'..'`'] of boolean;
  datentraegername      :array['A'..'`'] of boolean;

  emulator_abbrechen    :boolean;

  is_sfx_pfad           :string;

implementation

uses
  typ_varx,
  typ_spra,
  typ_zeic,
  zst;

procedure puffer_gross(const quelle:puffertyp;var ziel:puffertyp);
  var
    z                   :integer_norm;
    null_anzahl         :integer_norm;
  begin
    ziel.g:=quelle.g;

    if quelle.g>0 then
      begin
        Move(quelle.d[0],ziel.d[0],quelle.g);
        for z:=Low(quelle.d) to quelle.g-1 do
          case quelle.d[z] of
            ord('a')..Ord('z'):ziel.d[z]:=quelle.d[z]-32;
            ord('„')          :ziel.d[z]:=Ord('Ž');
            ord('”')          :ziel.d[z]:=Ord('™');
            ord('')          :ziel.d[z]:=Ord('š');
          end;
      end;

    null_anzahl:=High(quelle.d)+1-quelle.g;
    if null_anzahl>0 then
      FillChar(ziel.d[ziel.g],null_anzahl,0);
  end;

function fehlertext(const fn:word):string;
  begin
    case fn of
      1:fehlertext:=textz_dos_fehler_001^;
      2:fehlertext:=textz_dos_fehler_002^;
      3:fehlertext:=textz_dos_fehler_003^;
      4:fehlertext:=textz_dos_fehler_004^;
      5:fehlertext:=textz_dos_fehler_005^;
      6:fehlertext:=textz_dos_fehler_006^;
      7:fehlertext:=textz_dos_fehler_007^;
      8:fehlertext:=textz_dos_fehler_008^;
      9:fehlertext:=textz_dos_fehler_009^;
     11:fehlertext:=textz_dos_fehler_011^;
     12:fehlertext:=textz_dos_fehler_012^;
     13:fehlertext:=textz_dos_fehler_013^;
     15:fehlertext:=textz_dos_fehler_015^;
     16:fehlertext:=textz_dos_fehler_016^;
     18:fehlertext:=textz_dos_fehler_018^;
     21:fehlertext:=textz_dos_fehler_021^;
     27:fehlertext:=textz_dos_fehler_027^;
     32:fehlertext:=textz_dos_fehler_032^;
     86:fehlertext:=textz_dos_fehler_086^;
     87:fehlertext:=textz_dos_fehler_087^;
    100:fehlertext:=textz_dos_fehler_100^;
    102:fehlertext:=textz_dos_fehler_102^;
    103:fehlertext:=textz_dos_fehler_103^;
    150:fehlertext:=textz_dos_fehler_150^;
    152:fehlertext:=textz_dos_fehler_152^;
    154:fehlertext:=textz_dos_fehler_154^;
    156:fehlertext:=textz_dos_fehler_156^;
    157:fehlertext:=textz_dos_fehler_157^;
    158:fehlertext:=textz_dos_fehler_158^;
    161:fehlertext:=textz_dos_fehler_161^;
    162:fehlertext:=textz_dos_fehler_162^;
    216:fehlertext:=textz_dos_fehler_216^;
  15616:fehlertext:=textz_dos_fehler_15616^;
    else
      fehlertext:=textz_var__unbekannter_Fehler_Nr_doppelpunkt^+str0(fn)
    end;
  end;

function filter(const zk:string):string;
  var
    za                  :word_norm;
  begin
    for za:=1 to Length(zk) do
      if not (zk[za] in textzeichen) then
        begin
          filter:=Copy(zk,1,za-1);
          Exit;
        end;
    filter:=zk;
  end;

procedure zeichenfilter(var zk:string);
  var
    za                  :word_norm;
  begin
    za:=1;
    while za<=Length(zk) do
      if not(zk[za] in textzeichen) or (zk[za] in [^j,^m]) then
        Delete(zk,za,1)
      else
        Inc(za);
  end;


procedure html_filter(var zk:string);
  var
    tmp                 :string;
    ersatz              :string[4];
    zkg                 :string;
    teil                :string;
    p                   :word_norm;
    zeichennummer,
    kontrolle           :integer_norm;
  const
    umsetzung:array[1..8] of
      record
        s1:string[5];
        s2:string[3];
      end=
    ((s1:'LT'   ;s2:'<'),
     (s1:'GT'   ;s2:'>'),
     (s1:'NBSP' ;s2:' '),
     (s1:'SP'   ;s2:' '),
     (s1:'QUOT' ;s2:'"'),
     (s1:'AMP'  ;s2:'&'),
     (s1:'QUOT' ;s2:'"'),
     (s1:'COPY' ;s2:'(c)'));



  begin
    zkg:=gross(zk);
    tmp:='';
    p:=1;

    while p<=Length(zk) do
      begin
        case zk[p] of
          #13:
            ;
          #9,#10:
            tmp:=tmp+' ';
          '&':
            begin
              Inc(p);
              teil:=puffer_zu_zk_e(zkg[p],';',Length(zk)-p);
              ersatz:='';

              if Copy(teil,2,Length('UML'))='UML' then
                case zk[p] of
                  'A':ersatz:='Ž';
                  'O':ersatz:='™';
                  'U':ersatz:='š';
                  'a':ersatz:='„';
                  'o':ersatz:='”';
                  'u':ersatz:='';
                else
                      ersatz:=zk[p];
                end

              else if Copy(teil,2,Length('CEDIL'))='CEDIL' then
                case zk[p] of
                  'C':ersatz:='€';
                  'c':ersatz:='‡';
                else
                      ersatz:=zk[p];
                end

              else if Copy(teil,2,Length('ACUTE'))='ACUTE' then
                case zk[p] of
                  'E':ersatz:='';
                  'a':ersatz:=' ';
                  'e':ersatz:='‚';
                  'i':ersatz:='¡';
                  'o':ersatz:='¢';
                  'u':ersatz:='£';
                else
                      ersatz:=zk[p];
                end

              else if Copy(teil,2,Length('CIRC'))='CIRC' then
                case zk[p] of
                  'a':ersatz:='ƒ';
                  'e':ersatz:='ˆ';
                  'i':ersatz:='Œ';
                  'o':ersatz:='“';
                  'u':ersatz:='–';
                else
                      ersatz:=zk[p];
                end

              else if Copy(teil,2,Length('GRAVE'))='GRAVE' then
                case zk[p] of
                  'a':ersatz:='…';
                  'e':ersatz:='Š';
                  'i':ersatz:='';
                  'o':ersatz:='•';
                  'u':ersatz:='—';
                else
                      ersatz:=zk[p];
                end

              else if Copy(teil,2,Length('RING'))='RING' then
                case zk[p] of
                  'A':ersatz:='';
                  'a':ersatz:='†';
                else
                      ersatz:=zk[p];
                end

              else if Copy(teil,2,Length('TILDE'))='TILDE' then
                case zk[p] of
                  'N':ersatz:='¥';
                  'n':ersatz:='¤';
                else
                      ersatz:=zk[p];
                end

              else if Copy(teil,2,Length('SLASH'))='SLASH' then
                ersatz:=zk[p]+'/'

              else if teil='THORN;' then
                ersatz:='TH'

              else if teil='thorn;' then
                ersatz:='th'

              else if Copy(teil,3,Length('LIG'))='LIG' then
                begin
                  ersatz:=Copy(zk[p],1,2);
                  if ersatz='sz' then ersatz:='á';
                  if ersatz='AE' then ersatz:='’';
                  if ersatz='ae' then ersatz:='‘';
                end

              else if Copy(teil,1,Length('#'))='#' then
                begin
                  Val(Copy(teil,2,255),zeichennummer,kontrolle);
                  if kontrolle=0 then
                    ersatz:=Chr(zeichennummer); (* nur 0..255 *)
                end

              else
                begin
                  for z:=Low(umsetzung) to High(umsetzung) do
                    with umsetzung[z] do
                      if teil=s1 then
                        begin
                          ersatz:=s2;
                          Break;
                        end;
                end;

              tmp:=tmp+ersatz;
              Inc(p,Length(teil)+Length(';')-1);

            end;

        else
          tmp:=tmp+zk[p]
        end;
        Inc(p);
      end;
    zk:=leer_filter(tmp);
  end;

(* schon in Groábuchstaben *)
function  exe_dateierweiterung(const name_,erweiterung:string):boolean;
  begin
    lib_lib_start:=-1;
    lib_page_size:=1;

    rid_erweiterung     := (erweiterung='.RID');

    cpz_erweiterung     := (erweiterung='.CPZ');

    ari_erweiterung     := (erweiterung='.ARI')
                       or  (erweiterung='.ERI');

    pgp_erweiterung     := (erweiterung='.PGP')
                       or  (erweiterung='.PKR')  (* Public Key Ring *)
                       or  (erweiterung='.SKR'); (* Secret Key Ring *)

    mpeg_erweiterung    := (erweiterung='.MPG')
                       or  (erweiterung='.MPE')
                       or  (erweiterung='.MP3')
                       or  (erweiterung='.MP2')
                       or  (erweiterung='.MPEG');

(*  wpi_erweiterung     := (erweiterung='.WPI');*)

    exe_dateierweiterung:= (erweiterung='.EXE')
                       or  (erweiterung='.OLE') (* XPACK OLd+exE *)
                       or  (erweiterung='.COM')
                       or  (erweiterung='.CO~')
                       or  (erweiterung='.OLM') (* XPACK OLd+coM *)
                       or  (erweiterung='.CUP')
                       or  (erweiterung='.EX~')
                       or  (erweiterung='.GEO')
                       or  (erweiterung='.386')
                       or  (erweiterung='.286')
                       or ((erweiterung='.BIN') and (name_<>'LAYOUT')) (* nicht installshield *)
                       or  (erweiterung='.BOO')
                       or  (erweiterung='.DRV')
                       or  (erweiterung='.BIO')
                       or  (erweiterung='.SEK')
                       or ((erweiterung='.SYS') and (name_<>'CONFIG') and (name_<>'ABIOS'))
                       or  (erweiterung='.OLS') (* XPACK OLd+ysS *)
                       or  (erweiterung='.OVL')
                       or  (erweiterung='.OVR')
                       or  (erweiterung='.COD')  (* PTS-Boot *)
                       or  (erweiterung='.VOM')  (* TBAV *)
                       or  (erweiterung='.VXE')  (* TBAV *)
                       or  (erweiterung='.SNP')  (* OS/2 4.0 SNOOPER *)
                       or  (erweiterung='.I13')
                       or  (erweiterung='.BID')
                       or  (erweiterung='.FLT') (* OS/2 oder PMVIEW *)
                       or  (erweiterung='.DMD')
                       or  (erweiterung='.VSD')
                       or  (erweiterung='.TSD')
                     (*or ((erweiterung='.DAT') and (name_='MEM1'..))*)
                       or  (erweiterung='.$1' )  (* Cup386 *)
                       or  (erweiterung='.$2' )
                       or  ((Length(erweiterung)=Length('.@00')) and (Pos('.@',erweiterung)=1))
                       or  (erweiterung='.SS')  (* dos navigator screen saver *)
                       or  (erweiterung='.DSS');

    {
    if (erweiterung='.ADD') then (* OS/2 REF: BASEDEV *)
      begin
        untersuche_ob_textdatei;
        if not textdatei then
          exe_dateierweiterung:=true;
      end;}


    trk_erweiterung:=      (erweiterung='.TRK')  (* ecs test *)
                       or  (erweiterung='.ISO')
                       or  (erweiterung='.IMG')  (* shsucd14.zip *)
                       or ((erweiterung='.BIN') and (dateilaenge>100*1024*1024)) (* .BIN/.CUE *)
                       or  (erweiterung='.MDF'); (* "sacred cd1.mdf" (836M) "sacred cd1.mds" (3K) *)

    chklist_name:=
                        (   (name_='CHKLIST')
                         or (name_='CHKLST' )
                         or (name='SMARTCHECK'{?}))
                    and (   (erweiterung='.MS')
                         or (erweiterung='.TAV')
                         or (erweiterung='.TNT')
                         or (erweiterung='.CPS'));


  end;

(*$IfDef DOS_ODER_DPMI*)
function bytesuche_far(const feld;const pruefzk:string):boolean;assembler;
  asm
    push ds
      lds si,pruefzk
      les di,feld
      cld
      lodsb
      mov cl,al
      mov ch,0

      @SCHLEIFE:
      jcxz @GLEICH

      dec cx
      cmpsb (* ds:[si],es:[di] *)
      jz @SCHLEIFE

      cmp byte [si-1],'?'
      jz @SCHLEIFE

      (* ungleich *)
      mov ax,falsch
      jmp @ENDE

      @GLEICH:
      mov ax,wahr

      @ENDE:

    pop ds
  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
function bytesuche(const feld;const pruefzk:string):boolean;assembler;
(*$Frame-*)(*$Uses ECX,ESI,EDI*)
  asm
    cld
    sub ecx,ecx
    mov esi,pruefzk
    mov edi,feld

    lodsb
    mov cl,al


  @bytesuche_schleife:
    jecxz @gleich

    rep cmpsb
    jz @gleich

    mov al,[esi-1]
    cmp al,'?'
    jz @bytesuche_schleife

    mov eax,false
    jmp @bytesuche_fertig

  @gleich:
    mov eax,true

  @bytesuche_fertig:

  end;
(*$EndIf*)

(*$IfDef DUMM*)
function bytesuche(const feld;const pruefzk:string):boolean;
  var
    zaehler             :word_norm;
    feld1               :array[1..256] of char absolute feld;
  begin
    bytesuche:=true;
    zaehler:=1;
    while zaehler<Length(pruefzk) do
      if  (pruefzk[zaehler]<>feld1[zaehler])
      and (pruefzk[zaehler]<>'?')
       then
        begin
          bytesuche:=false;
          Exit;
        end
      else
        Inc(zaehler);
  end;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function puffer_zu_zk_l_far(const p;const l:byte):string;
(*$Else*)
function puffer_zu_zk_l(const p;const l:byte):string;
(*$EndIf*)
  var
    tmpzk:array[1..255] of char absolute p;
  begin
    (*$IfDef DOS_ODER_DPMI*)
    puffer_zu_zk_l_far:=Copy(tmpzk,1,l);
    (*$Else*)
    puffer_zu_zk_l:=Copy(tmpzk,1,l);
    (*$EndIf*)
  end;

(*$IfDef DOS_ODER_DPMI*)
function puffer_zu_zk_e_far(const p;const e:string;maxl:integer_norm):string;
(*$Else*)
function puffer_zu_zk_e(const p;const e:string;maxl:integer_norm):string;(*$Delphi+*)
(*$EndIf*)
  var
    tmpzk               :array[1..255] of char absolute p;
    po                  :integer_norm;
  begin
    if maxl<0 then
      maxl:=0;

    if maxl>255 then
      maxl:=255;

    (*$IfDef DOS_ODER_DPMI*)
    po:=Pos(e,tmpzk)-1;
    if po>maxl then
      po:=maxl;

    if po<0 then
      po:=maxl;

    puffer_zu_zk_e_far:=Copy(tmpzk,1,po);
    (*$Else*)
    (* bringt Laufzeitfehler 216 in OS/2 wenn auf fremde Speicherbereiche
       zugegriffen wird: Kann nicht fr CmdLine verwendet werden *)
    puffer_zu_zk_e:=Copy(tmpzk,1,maxl);
    po:=Pos(e,Result);
    if po>0 then
      SetLength(Result,po-1)
    (*$EndIf*)
  end;

function puffer_zu_zk_zeilenende(const p;maxl:integer_norm):string;
  var
    tmpzk               :array[1..255] of char absolute p;
    po,po1,po2          :integer_norm;
  begin
    if maxl<0 then
      maxl:=0;

    if maxl>255 then
      maxl:=255;

    (*$IfDef VirtualPascal*)
    (*$Delphi+*)
    Result:=Copy(tmpzk,1,maxl);
    po:=Pos(#$0a,Result);
    if po>0 then
      SetLength(Result,po-1);
    po:=Pos(#$0d,Result);
    if po>0 then
      SetLength(Result,po-1);

    (*$Else*)

    po1:=pos(#$0a,tmpzk)-1;
    if po1=-1 then po1:=255;
    po2:=pos(#$0d,tmpzk)-1;
    if po2=-1 then po2:=255;

    if po1>maxl then po1:=maxl;
    if po2>maxl then po2:=maxl;

    po:=po1;
    if (po1>po2) then
      po:=po2;

    if po<0 then
      po:=maxl;

    puffer_zu_zk_zeilenende:=Copy(tmpzk,1,po);
    (*$EndIf*)
  end;

function puffer_zu_zk_zeilenende2(const p:puffertyp;const posi,maxl:integer_norm):string;
  begin
    if p.g<posi then
      puffer_zu_zk_zeilenende2:=''
    else
      if p.g>posi+maxl then
        puffer_zu_zk_zeilenende2:=puffer_zu_zk_zeilenende(p.d[posi],p.g-posi)
      else
        puffer_zu_zk_zeilenende2:=puffer_zu_zk_zeilenende(p.d[posi],maxl);
  end;

function puffer_zu_zk_pstr(const p):string;
  var
    s:string absolute p;
  begin
    puffer_zu_zk_pstr:=s;
  end;

(*$IfDef DOS_ODER_DPMI*)
function puffer_pos_suche_far(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;assembler;
  asm
    push ds
      mov dx,ds
      cld
      lds si,suchzk
      les di,p
      add di,2
      mov cx,l
      lodsb
      sub ah,ah
      sub cx,ax
      jc @puffer_pos_suche_nicht_gefunden
      inc cx

@puffer_pos_suche_schleife:
      (* Suche des 1. Zeichens *)
      lodsb

      cld
      repnz scasb

      (* alles abgesucht? *)
      (* jcxz @puffer_pos_suche_nicht_gefunden cx=0 fr letzten Versuch *)
      jnz @puffer_pos_suche_nicht_gefunden

      (* Suchzustand sichern *)
      push di
        push es
          push cx
            push dx

              (* Bytesuche, Parameterbergabe *)
              mov ax,di
              dec ax

              push es
              push ax

              lds si,suchzk
              push ds
              push si


              mov ds,dx

              call bytesuche_far

            pop dx
          pop cx
        pop es
      pop di

      (* zum ersten Zeichen und DS restaurieren *)
      lds si,suchzk
      inc si

      (* Bytesuche erfolgreich? *)
      cmp ax,wahr
      jnz @puffer_pos_suche_schleife

      (* wieviel schon abgesucht -> Ergebnis *)
@puffer_pos_suche_erfolgreich:
      mov ax,di
      les di,p
      sub ax,di
      sub ax,3 (* 3=1+2 ... scansb, p+2=p.d *)

      jmp @puffer_pos_suche_ende

      (* nicht gefunden -> Funktionsergebnis *)
@puffer_pos_suche_nicht_gefunden:
      mov ax,nicht_gefunden

@puffer_pos_suche_ende:
    pop ds
  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
function puffer_pos_suche(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
  assembler;(*$Frame+*)(*$Uses ECX,ESI,EDI*)
  asm
    cld
    mov esi,suchzk
    mov edi,p
    movzx eax,Smallword Ptr [edi]
    inc edi // Offset p.d
    inc edi
    mov ecx,l
    cmp ecx,eax
    jb @puffer_nicht_vollstaendig_gefuellt
    mov ecx,eax
  @puffer_nicht_vollstaendig_gefuellt:
    movzx eax,Byte Ptr [esi]
    sub ecx,eax                                 // Anzahl Versuche
    jc @puffer_pos_suche_nicht_gefunden
    inc ecx                                     // Null Spielraum=1 Versuch

  @puffer_pos_suche_schleife:
    mov al,[esi+1]                              // 1. Zeichen
    cld
    repnz scasb

    (* alles abgesucht? *)
    //jecxz @puffer_pos_suche_nicht_gefunden - ecx=0 fr letzten Versuch
    jnz @puffer_pos_suche_nicht_gefunden

    (* Suchzustand sichern *)
    push esi
      push edi
        push ecx

          (* Bytesuche, Parameterbergabe *)
          dec edi
          push edi                      // p.d[Position]

            push esi                    // suchzk

              call bytesuche

        pop ecx
      pop edi
    pop esi

    (* Bytesuche erfolgreich? *)
    cmp eax,wahr
    jne @puffer_pos_suche_schleife

    (* wieviel schon abgesucht -> Ergebnis *)
  @puffer_pos_suche_erfolgreich:
    mov eax,edi
    sub eax,p
    sub eax,3 (* 3=1+2 ... scansb, p+2=p.d *)

    jmp @puffer_pos_suche_ende

      (* nicht gefunden -> Funktionsergebnis *)
  @puffer_pos_suche_nicht_gefunden:
    mov eax,nicht_gefunden

  @puffer_pos_suche_ende:

  end;
(*$EndIf*)

(*$IfDef DUMM*)
function puffer_pos_suche(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
  var
    z                   :word_norm;
    z_ende              :word_norm;
  begin
    if l>=Length(suchzk) then
      begin
        z_ende:=l-Length(suchzk);
        for z:=0 to z_ende do
          if p.d[z]=Ord(suchzk[1]) then
            if bytesuche(p.d[z],suchzk) then
              begin
                puffer_pos_suche:=z;
                Exit;
              end;
      end;
    puffer_pos_suche:=nicht_gefunden;
  end;
(*$EndIf DUMM*)

(*  -$IfDef DUMM*)
function puffer_pos_suche_rueckwaerts(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
  var
    i:word_norm;
  begin
    if l>=Length(suchzk) then
      for i:=l-Length(suchzk) downto 0 do
        if p.d[i]=Ord(suchzk[1]) then
          if bytesuche(p.d[i],suchzk) then
            begin
              puffer_pos_suche_rueckwaerts:=i;
              Exit;
            end;
    puffer_pos_suche_rueckwaerts:=nicht_gefunden;
  end;
(*  -$EndIf DUMM*)

function puffer_pos_suche_anfang(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
  var
    z                   :word_norm;
    lf_pos              :word_norm;
  begin
    if bytesuche(p.d[0],suchzk) then
      puffer_pos_suche_anfang:=0
    else
      begin
        lf_pos:=puffer_pos_suche(p,^j+suchzk,l);
        if lf_pos<>nicht_gefunden then
          puffer_pos_suche_anfang:=lf_pos+1
        else
          puffer_pos_suche_anfang:=puffer_pos_suche(p,suchzk,l);
      end;
  end;

function puffer_anzahl_suche(const p:puffertyp;const suchzk:string;const l:word_norm):word_norm;
  var
    z                   :word_norm;
    gefunden            :word_norm;
  begin
    if suchzk='' then
      RunError(99);
    gefunden:=0;
    for z:=0 to l-Length(suchzk) do
      if p.d[z]=Ord(suchzk[1]) then
        if bytesuche(p.d[z],suchzk) then
          Inc(gefunden);
    puffer_anzahl_suche:=gefunden;
  end;

function puffer_gefunden(const p:puffertyp;const suchzk:string):boolean;
  begin
    (*$IfDef DOS*)
    puffer_gefunden:=puffer_pos_suche_far(p,suchzk,p.g)<>nicht_gefunden;
    (*$Else*)
    puffer_gefunden:=puffer_pos_suche(p,suchzk,p.g)<>nicht_gefunden;
    (*$EndIf*)
  end;

function ist_ohne_steuerzeichen(const s:string):boolean;
  var
    z:word_norm;
  begin
    for z:=1 to Length(s) do
      if not (s[z] in textzeichen) then
        begin
          ist_ohne_steuerzeichen:=falsch;
          Exit;
        end;
    ist_ohne_steuerzeichen:=wahr;
  end;

function ist_ohne_steuerzeichen_nicht_so_streng(const s:string):boolean;
  var
    z:word_norm;
  begin
    for z:=1 to Length(s) do
      if s[z]<' ' then
        begin
          ist_ohne_steuerzeichen_nicht_so_streng:=falsch;
          exit;
        end;
    ist_ohne_steuerzeichen_nicht_so_streng:=wahr;
  end;

procedure tabexpand(var zk:string);
  var
    tabpos              :byte;
  begin
    if (zk<>'') and (zk[Length(zk)]=^m) then
      DecLength(zk);

    repeat
      tabpos:=Pos(#9,zk);
      if tabpos=0 then Exit;

      zk:=Copy(zk,1,tabpos-1)
         +Copy('        ',1,((tabpos-1) div 8)*8+8-(tabpos-1))
         +Copy(zk,tabpos+1,255);

    until false;
  end;


function ziffer(const sys:byte;const str:string):dateigroessetyp;
  var
    l                   :dateigroessetyp;
    gueltige_stellen    :byte;
    pos                 :byte;
  begin
    gueltige_stellen:=0;
    l:=0;
    for pos:=1 to Length(str) do
      if str[pos] in ['0'..'9'] then
        begin
          l:=l*sys+Ord(str[pos])-Ord('0');
          Inc(gueltige_stellen);
        end
      else if sys=16 then
        begin
          if str[pos] in ['a'..'f'] then
            begin
              l:=l*sys+Ord(str[pos])-Ord('a')+10;
              Inc(gueltige_stellen);
            end;
          if str[pos] in ['A'..'F'] then
            begin
              l:=l*sys+Ord(str[pos])-Ord('A')+10;
              Inc(gueltige_stellen);
            end;
        end
      else
        begin
          gueltige_stellen:=0;
          l:=0;
        end;

    if gueltige_stellen=0 then
      (*$IfDef dateigroessetyp_comp*)
      ziffer:=9.2e18
      (*$Else*)
      ziffer:=High(dateigroessetyp)
      (*$EndIf*)
    else
      ziffer:=l;
  end;

function ziffer_tar(const sys:byte;const str:string):dateigroessetyp;
  var
    tmp:string;
  begin
    tmp:=str;
    while (tmp<>'') and (tmp[1          ] in [#0,' ']) do Delete(tmp,1,1);
    while (tmp<>'') and (tmp[Length(tmp)] in [#0,' ']) do Dec(tmp[0]);
    ziffer_tar:=ziffer(sys,tmp);
  end;

function val_f(const s:string):dateigroessetyp;
  var
    t                   :dateigroessetyp;
    (*$IfDef VirtualPascal*)
    pruef               :longint;
    (*$Else*)
    pruef               :integer;
    (*$EndIf*)
    s_tmp               :string;
  begin
    s_tmp:=leer_filter(s);
    Val(s_tmp,t,pruef);
    if pruef=0 then
      val_f:=t
    else
      val_f:=0;
  end;

procedure zk_anhaengen(var zk1:string;const zk2:string);
  begin
    zk1:=zk1+zk2;
  end;

procedure exezk_anhaengen(const zk2:string);
  begin
    exezk:=exezk+zk2;
  end;

procedure exezk_anhaengen_komma(const zk2:string);
  begin
    if exezk<>'' then
      exezk:=exezk+', ';
    exezk:=exezk+zk2;
  end;

function puffer_zeilen_anfang_suche(const p:puffertyp;const zk:string):boolean;
  var
    pp:word_norm;
  begin
    puffer_zeilen_anfang_suche:=false;
    pp:=puffer_pos_suche(p,zk,p.g);
    if pp<>nicht_gefunden then
      repeat
        if pp=0 then
          begin
            puffer_zeilen_anfang_suche:=true;
            break;
          end;

        dec(pp);

        if p.d[pp] in [13,10] then
          begin
            puffer_zeilen_anfang_suche:=true;
            break;
          end;

        until not (p.d[pp] in [9,ord(' '),ord('@')])
  end;

function puffer_zeilen_anfang_suche_pos(const p:puffertyp;const zk:string):word_norm;
  var
    pp,pp_org           :word_norm;
  begin
    puffer_zeilen_anfang_suche_pos:=nicht_gefunden;
    pp:=puffer_pos_suche(p,zk,p.g);
    pp_org:=pp;
    if pp<>nicht_gefunden then
      repeat
        if pp=0 then
          begin
            puffer_zeilen_anfang_suche_pos:=pp_org;
            break;
          end;

        dec(pp);

        if p.d[pp] in [13,10] then
          begin
            puffer_zeilen_anfang_suche_pos:=pp_org;
            break;
          end;

        until not (p.d[pp] in [9,ord(' '),ord('@')])
  end;

procedure suche_wortanfang(const p:puffertyp;var posi:word_norm);
  begin
    while posi<p.g do
      begin
        if p.d[posi]>ord(' ') then exit;
        inc(posi);(* #9 #13 #10 ' ' *)
      end;
  end;

procedure suche_zeilenanfang(const p:puffertyp;var posi:word_norm);
  begin

    while posi<p.g do
      begin
        if p.d[posi] in [13,10] then Break;
        Inc(posi);
      end;

    while (posi<p.g) and (p.d[posi] in [13,10]) do
      Inc(posi);

  end;

function in_doppelten_anfuerungszeichen(const zk:string):string;
  const
    anf1={'¯'}'"';{,,}
    anfe={'®'}'"';{''}
  begin
    if (zk='') or (zk[1]<>anf1) then
      in_doppelten_anfuerungszeichen:=anf1+zk+anfe
    else
      in_doppelten_anfuerungszeichen:=zk;
  end;

procedure exezk_in_doppelten_anfuerungszeichen;
  begin
    exezk:=in_doppelten_anfuerungszeichen(exezk);
  end;

function  vergleiche_zk_ende(const teil,zk:string):boolean;
  begin
    vergleiche_zk_ende:=false;
    if Length(teil)<=Length(zk) then
      vergleiche_zk_ende:=bytesuche(zk[Length(zk)-Length(teil)+1],teil);
  end;

procedure exezk_von1250;
 begin
   umformung_8_8(exezk,exezk,konverter_iso_8859_1);
 end;

function base64wert(const z:char):longint;
  (*
  const
    b64c:array[0..63] of char='+/0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    *)
  begin
    case z of
      'A'..'Z':base64wert:=Ord(z)-Ord('A')     ; (*  0..25 *)
      'a'..'z':base64wert:=Ord(z)-Ord('a')+  26; (* 26..51 *)
      '0'..'9':base64wert:=Ord(z)-Ord('0')+  52; (* 52..61 *)
      '+'     :base64wert:=                  62; (* 62?    *)
      '/'     :base64wert:=                  63; (* 63?    *)
      '='     :base64wert:=                   0;
    else
               base64wert:=                   0;
      (*$IfNDef ENDVERSION*)
      RunError(0);
      (*$EndIf*)
    end;
  end; (* base64wert *)

procedure umformung_quote_base64;
  var
    zeichensatz,
    anfang,
    arbeit            :string;
    w1                :word_norm;
    modus             :(base64,quotedprintable);
    lw64              :longint;
    umwandlung_8_8    :zeichensatzumformung_8_8;

  begin
    arbeit:=exezk;
    exezk:='';

    while arbeit<>'' do
      begin

        w1:=Pos('=?',arbeit);
        if w1=0 then
          begin
            umformung_8_8(arbeit,arbeit,konverter_iso_8859_1);
            exezk:=exezk+arbeit;
            arbeit:='';
          end
        else
          begin
            anfang:=Copy(arbeit,1,w1-1);
            umformung_8_8(anfang,anfang,konverter_iso_8859_1);
            exezk:=exezk+anfang;
            Delete(arbeit,1,w1+Length('=?')-1);
            zeichensatz:=Copy(arbeit,1,Pos('?',arbeit)-1);
            erzeuge_8_8_tabelle(zeichensatz,umwandlung_8_8);
            Delete(arbeit,1,Length(zeichensatz)+Length('?'));
            if arbeit='' then Break; (* Fehler *)
            case UpCase(arbeit[1]) of
             'B':modus:=base64;
             'Q':modus:=quotedprintable;
            else
              arbeit:='';
              Break; (* Unbekannte Darstellung *)
            end;

            if Pos('?',arbeit)<>2 then
              begin
                arbeit:=''; (* Fehler *)
                Break;
              end;

            Delete(arbeit,1,Length('q?'));

            while (arbeit<>'') and (arbeit[1]<>'?') do
              case modus of
                base64:
                  begin
                    (* 'SGFubm8' -> 'Hanno ' *)
                    lw64:=base64wert(arbeit[1]) shl (3*6)
                         +base64wert(arbeit[2]) shl (2*6)
                         +base64wert(arbeit[3]) shl (1*6)
                         +base64wert(arbeit[4]) shl (0*6);
                    Delete(arbeit,1,4);
                    if Lo(lw64 shr (2*8))<>0 then
                      exezk:=exezk+umwandlung_8_8[Chr(Lo(lw64 shr (2*8)))];
                    if Lo(lw64 shr (1*8))<>0 then
                      exezk:=exezk+umwandlung_8_8[Chr(Lo(lw64 shr (1*8)))];
                    if Lo(lw64 shr (0*8))<>0 then
                      exezk:=exezk+umwandlung_8_8[Chr(Lo(lw64 shr (0*8)))];
                  end;

                quotedprintable:
                  case arbeit[1] of
                    '=':
                      begin
                        exezk:=exezk+umwandlung_8_8[Chr(DGT_zu_longint(ziffer(16,Copy(arbeit,2,2))))];
                        Delete(arbeit,1,Length('=F8'));
                      end;
                    '_':
                      begin
                        exezk:=exezk+#$20;
                        Delete(arbeit,1,1);
                      end
                  else
                      exezk:=exezk+umwandlung_8_8[arbeit[1]];
                      Delete(arbeit,1,1);
                  end;

              end;

            if Pos('?=',arbeit)<>1 then
              begin
                arbeit:='';
                Break; (* Fehler *)
              end;
            Delete(arbeit,1,Length('?='));

          end; (* '=?' *)

      end; (* while arbeit<>'' *)

    exezk:=leer_filter(exezk);
  end; (* umformung_quote_base64 *)


end.

