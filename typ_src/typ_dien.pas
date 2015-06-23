(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_dien;

interface

uses
  typ_type,
  typ_ausg;

procedure anzeige_ega_font(hoehe,breite:integer_norm;o0:longint;text_anzeige,patchmodus:boolean;patch_anzahl:integer_norm);
procedure os2_ico(const analyseoff:dateigroessetyp;const anfang:spaltenplatz);
procedure windows_ico1(datenoff,ico_laenge:dateigroessetyp;kommentarlos:boolean;ico_oder_bmp:byte);
procedure windows_ico(const anzahl:word_norm;ico_cur:byte);
procedure thegrab(const ao:dateigroessetyp;const zz:byte;const x80:byte;const titeltext:string);
procedure thedraw_com(offs:dateigroessetyp;const thedraw_dat:boolean);
procedure thedraw_com_alt(const start:dateigroessetyp);
procedure blocktext(const pu:puffertyp;const o,zeilen,laenge:word_norm);
procedure bsmp(const pu:puffertyp;o:word_norm);
procedure contain(const pu:puffertyp;o:word_norm);
procedure teletext(const pu:puffertyp;o:word_norm;const ende:char;const kein_13:boolean);
procedure screen_designer(const pos0:dateigroessetyp);
procedure tc_verfolgung(const p:puffertyp);
procedure ts_verfolgung(var pu:puffertyp;const ver:string);
procedure ansi_anzeige(o:dateigroessetyp;const ende:string;const farbe:byte;const rand:spaltenplatz;
          ignoriere_anfang:boolean;const cr_lf:boolean;ende_pos:dateigroessetyp;const vortext:string);
procedure bat_datei(const p:puffertyp);
procedure tpu_system(const p:puffertyp);
procedure vpi_system(const p:puffertyp);
procedure obj(const obj_puffer:puffertyp);
procedure lib(const p:puffertyp);
procedure hackstop(const ver:string);
procedure crackstop(const o:dateigroessetyp);
procedure wpc(const wpc_puffer:puffertyp);
procedure codeview(const p:puffertyp;const i:word_norm;const spalte:spaltenplatz);
function teste_lha_kopf(const o:dateigroessetyp):boolean;
procedure rom_modul(var r:puffertyp;const posi:dateigroessetyp;const zusatz:string;var einzel_laenge:dateigroessetyp);
procedure bild_format_filter(const format:string;const x,y:longint;f:longint;fbit:shortint;
  const unsicher,sicher:boolean;const anfang:spaltenplatz);
procedure c_kommentar;
procedure p_kommentar;
procedure html;
procedure test_shar(const p:puffertyp);
procedure teledisk(const l:word_norm);
procedure vpart1_anzeige(const p:puffertyp);
procedure vpart_neu(const vpp:puffertyp);
procedure bestimme_einzel_laenge_exelock;
procedure kopftext_anzeige(hinweis:string;const f:aus_attribute);
procedure suche_txt2com_titel(const o0:longint);
procedure chlib(const p:puffertyp);
procedure avatar;
procedure rscc_endekennung;
procedure rcc_test(const ip_neu:smallword);
procedure rosetiny(const ver:string);
procedure bliztcopy_test(const p:puffertyp);
procedure mcm_anzeige(var p:puffertyp;const o:word_norm);
procedure ls000c;
procedure ls000d;
procedure prestel;
procedure ttx;
procedure test_photocd(const p:puffertyp);
procedure feldtext_anzeige(const o:dateigroessetyp;const spalten,zeilen:integer_norm;const attr:aus_attribute);
procedure award_flash_writer;
function upx_version(const p,p2:puffertyp;const o:word_norm;const minversion,maxversion:byte):string;
procedure ausschrift_upx_version(const p,p2:puffertyp;const o:word_norm;const minversion,maxversion:byte;const exe:string);
procedure ausschrift_upx_version_dat(const p,p2:puffertyp;const o:word_norm;const minversion,maxversion:byte);
procedure turbo_pascal(const p:puffertyp;const aenderung:string);
function version100(const w:word_norm):string;
function version_div10_mod10(const b:byte):string;
function version_div16_mod16(const b:byte):string;
function version_x_y(const x,y:byte):string;
function version_x_y_z(const x,y,z:byte):string;
function version161616(const v:word):string;
function version_einstellig(const v:byte):string;
procedure upstop(const version:string);
procedure trap(const version:string);
procedure untersuche_ob_textdatei;
procedure viotbl_dcp(const kopf:puffertyp);
procedure keyboard_dcp(const kopf:puffertyp);
procedure mp3_tag; (* analysepuffer *)
procedure mp3_anzeige; (* analysepuffer *)
procedure zeichensatz;
procedure mess(const ver,zusatz:string);
function zusatzcodelaenge_zk:string;
procedure award_logo(const p:puffertyp);
procedure com2text_nide(const ver:string;const nide;const laenge:word_norm);
procedure loesche_muell(var s:string;const z2:string);
procedure cpi_anzeige(const p:puffertyp);
procedure os2_font(volle_anzeige:boolean;speicher:speicherbereich_z;speicher_laenge:word_norm);
procedure font_windows(const o0,laenge:dateigroessetyp);
procedure text_gic_icon;
procedure psf1(const p:puffertyp);
procedure psf2(const p:puffertyp);
procedure amibios_font;
procedure viotbl_dcp_block(const p:puffertyp);

procedure einrichten_typ_dien(const anfang:boolean);

implementation

uses
  Dos,
  typ_spra,
  typ_spru,
  typ_eiau,
  typ_var,
  typ_varx,
  typ_spei,
  typ_entp,
  typ_posm,
  typ_poem,
  typ_die2,
  typ_xexe;

const
  dumm                  =0;
  ansi_maxzeilen        =120;
  windws_ico_farbe      =15;
  os_2_ico_farbe        =15;

type
  bild_puffer_typ       =array[1..ansi_maxzeilen] of buntzeilen_typ;

var
  dien_puffer           :puffertyp;
  bild                  :array[0..63,0..63] of byte;
  rgb_tauschtabelle     :array[0..255] of byte;

function rgb(r,g,b:byte):byte;
  const
    EGAColors:
      array[0..15] of
        record
          RedVal, GreenVal, BlueVal: Integer_norm;
        end =
    ((* verÑnderte Werte! *)
    (RedVal:$00;GreenVal:$00;BlueVal:$00),
    (RedVal:$00;GreenVal:$00;BlueVal:$7f),
    (RedVal:$00;GreenVal:$8f;BlueVal:$00),
    (RedVal:$00;GreenVal:$6f;BlueVal:$6f),

    (RedVal:$8f;GreenVal:$00;BlueVal:$00),
    (RedVal:$6f;GreenVal:$00;BlueVal:$6f),
    (RedVal:$6f;GreenVal:$6f;BlueVal:$00),
    (RedVal:$b6;GreenVal:$b6;BlueVal:$b6),

    (RedVal:$65;GreenVal:$65;BlueVal:$65),
    (RedVal:$38;GreenVal:$38;BlueVal:$f0),
    (RedVal:$48;GreenVal:$f0;BlueVal:$48),
    (RedVal:$38;GreenVal:$f0;BlueVal:$f0),

    (RedVal:$f0;GreenVal:$55;BlueVal:$55),
    (RedVal:$f0;GreenVal:$55;BlueVal:$f0),
    (RedVal:$f0;GreenVal:$f0;BlueVal:$55),
    (RedVal:$f0;GreenVal:$f0;BlueVal:$f0)
    );
  var
    min_diff,diff       :integer_norm;
    min_diff_farbe,farbe:byte;
    diff_1,diff_2,diff_4:integer_norm;
  begin
    min_diff:=High(min_diff);

    for farbe:=0 to 15 do
      begin
        diff_1:=integer_norm(r)-egacolors[farbe].redval  ;
        diff_2:=integer_norm(g)-egacolors[farbe].greenval;
        diff_4:=integer_norm(b)-egacolors[farbe].blueval ;

        diff:=Abs(diff_1)
             +Abs(diff_2)
             +Abs(diff_4)
             +(Abs(diff_1-diff_2)
              +Abs(diff_1-diff_4)
              +Abs(diff_2-diff_4)) * 2;

        if diff<min_diff then
          begin
            min_diff:=diff;
            min_diff_farbe:=farbe;
          end;
      end;


    if (min_diff_farbe=4) and (r>$AA) then Inc(min_diff_farbe,8);
    if (min_diff_farbe=2) and (g>$AA) then Inc(min_diff_farbe,8);
    if (min_diff_farbe=1) and (b>$AA) then Inc(min_diff_farbe,8);

    rgb:=min_diff_farbe;
  end;

procedure schreibe_bild(x,y:word_norm;hf:byte);
  var
    zeile,spalte        :word_norm;
    ico_h               :buntzeilen_typ;
  begin

    if (x=0) or (y=0) then Exit;

    if (x>64) or (y>64) then
      begin
        x:=(x+1) shr 1;
        y:=(y+1) shr 1;
      end;

    ico_h:=leerzeile;
    for spalte:=6 to 6+1+x+2 do
      ico_h[spalte,2]:=16*hf;

    sofortanzeige:=falsch;

    schreibe_zeile(ico_h);

    if odd(y) then
      begin
        for spalte:=0 to x-1 do
          bild[spalte,y]:=hf;
      end;


    for zeile:=0 to ((y+1) shr 1)-1 do
      begin
        arbeitszeile:=ico_h;
        for spalte:=0 to x-1 do
          begin
            arbeitszeile[
            spalte+8,2]:=bild[spalte,zeile*2]+16*bild[spalte,zeile*2+1];
            arbeitszeile[spalte+8,1]:=Ord('ﬂ');
          end;
        schreibe_zeile(arbeitszeile);
      end;

    schreibe_zeile(ico_h);

    nachholen;
  end;

function bestimme_breite89(hoehe:integer_norm;o0:longint):integer_norm;
  begin
    datei_lesen(dien_puffer,analyseoff+o0+Ord('M')*hoehe,hoehe);
    if Odd(dien_puffer.d[hoehe shr 1]) then
      bestimme_breite89:=9
    else
      bestimme_breite89:=8;
  end;

procedure anzeige_ega_font(hoehe,breite:integer_norm;o0:longint;text_anzeige,patchmodus:boolean;patch_anzahl:integer_norm);
  const
    beispiel            :array[0..6-1] of Char='Typ:00'; (* ∞±≤€ *)
  var
    x,y,i,j,l           :word_norm;
    b                   :byte;
  begin
    if (breite=-8) and (not patchmodus) then
      breite:=bestimme_breite89(hoehe,o0);


    if text_anzeige then
      ausschrift_x('Font '+str0(hoehe)+'x'+str0(breite),musik_bild,absatz);

    if (not ico_anzeige) or (hoehe>32) or (breite>9) or (breite<1) then Exit;

    l:=Min(64 div breite,SizeOf(beispiel));
    if patchmodus then
      l:=Min(l,patch_anzahl);

    beispiel[4]:=Chr(hoehe div 10+Ord('0'));
    beispiel[5]:=Chr(hoehe mod 10+Ord('0'));
    FillChar(bild,SizeOf(bild),os_2_ico_farbe);
    for i:=Low(beispiel) to l-1 do
      begin
        if patchmodus then
          datei_lesen(dien_puffer,analyseoff+o0+1+(hoehe+1)*i,hoehe)
        else
          datei_lesen(dien_puffer,analyseoff+o0+hoehe*Ord(beispiel[i]),hoehe);
        j:=0;
        for y:=0 to hoehe-1 do
          begin
            b:=dien_puffer.d[j];
            Inc(j);
            for x:=7+i*breite downto 0+i*breite do
              if x<=63 then
                begin
                  if Odd(b) then
                    bild[x,y]:=bild[x,y] xor $f;
                  b:=b shr 1;
                end;
          end;
      end;
    schreibe_bild(l*breite,hoehe,os_2_ico_farbe);
  end;


procedure thegrab(const ao:dateigroessetyp;const zz:byte;const x80:byte;const titeltext:string);
  var
    ze,sp               :byte;
    gleich              :word_norm;
  begin
    sofortanzeige:=falsch;

    if titeltext<>'' then
      begin
        gleich:=0;
        for ze:=1 to zz do
          begin
            datei_lesen(dien_puffer,ao+(ze-1)*x80,80*2);
            for sp:=1 to 80-1 do
              if dien_puffer.d[sp*2-1]=dien_puffer.d[sp*2+1] then
                Inc(gleich);
          end;

        if gleich<1000 then
          begin
            sofortanzeige:=true;
            exit;
          end;

        ausschrift(titeltext,musik_bild);
      end;

    for ze:=1 to zz do
      begin
        datei_lesen(dien_puffer,ao+(ze-1)*x80,80*2);
        move(dien_puffer.d[0],arbeitszeile,80*2);
        schreibe_zeile(arbeitszeile);
      end;
    nachholen;
  end;

procedure thedraw_com(offs:dateigroessetyp;const thedraw_dat:boolean);
  var
    sp,zaehl,
    vfarbe,hfarbe       :byte;
    p                   :word_norm;
    start               :boolean;

  procedure schreibe(const z:byte);
    begin
      arbeitszeile[sp,1]:=Ord(z);
      arbeitszeile[sp,2]:=vfarbe+16*hfarbe;
      Inc(sp);
      if sp=81 then
        begin
          schreibe_zeile(arbeitszeile);
          arbeitszeile:=leerzeile;
          sp:=1;
        end;
    end;
  begin
    sofortanzeige:=falsch;

    if thedraw_dat then
      start:=wahr
    else
      begin
        IncDGT(offs,$90);
        start:=falsch;
      end;

    p:=0;
    vfarbe:=$0F;
    hfarbe:=$00;
    sp:=1;
    arbeitszeile:=leerzeile;
    datei_lesen(dien_puffer,offs,512);
    sofortanzeige:=falsch;
    repeat
      if p+10>sizeof(dien_puffer) then
        begin
          offs:=offs+p;
          datei_lesen(dien_puffer,offs,512);
          p:=0;
        end;
      if not start then
        begin
          if (dien_puffer.d[p]=$E2) and (dien_puffer.d[p+2]=$C3) then
            begin
              start:=wahr; (* RET *)
              Inc(p,2);
            end
          else
            if offs>=300 then exit;
          Inc(p);
        end
      else
        begin
          case dien_puffer.d[p] of
          $00..$0F:                      (* Vordergrundfarbe *)
            begin
              vfarbe:=dien_puffer.d[p]+(vfarbe and $80);
              Inc(p);
            end;
          $10..$17:                      (* Hintergrundfarbe *)
            begin
              hfarbe:=dien_puffer.d[p]-$10;
              Inc(p);
            end;
          $18:                           (* Zeilenvorschub *)
            begin
              while sp>1 do schreibe(Ord(' '));
              Inc(p);
            end;
          $19:                           (* Leerzeichen *)
            begin
              for zaehl:=0 to dien_puffer.d[p+1] do schreibe(Ord(' '));
              Inc(p,2);
            end;
          $1A:                           (* Vielfache von Zeichen *)
            begin
              for zaehl:=0 to dien_puffer.d[p+1] do schreibe(dien_puffer.d[p+2]);
              Inc(p,3);
            end;
          $1B:
            begin
              vfarbe:=vfarbe xor $80;
              Inc(p);
            end;

          else
            schreibe(dien_puffer.d[p]);         (* normale Zeichen *)
            Inc(p,1);
          end;
          if (dien_puffer.d[p]=0) and (dien_puffer.d[p+1]=0) then break;
        end;
    until falsch;
    nachholen;
  end;

procedure thedraw_com_alt(const start:dateigroessetyp);
  var
    zeilen_laenge,zeilen:byte;
    zz                  :byte;
  begin
    sofortanzeige:=falsch;

    datei_lesen(dien_puffer,start-$3f+4,2);
    zeilen       :=dien_puffer.d[0];
    zeilen_laenge:=dien_puffer.d[1];
    if (zeilen_laenge<1) or (zeilen_laenge>80) then exit;

    for zz:=0 to zeilen-1 do
      begin
        FillChar(arbeitszeile,SizeOf(arbeitszeile),0);
        datei_lesen(dien_puffer,start+zeilen_laenge*2*zz+$b0-$3f,zeilen_laenge*2);
        Move(dien_puffer.d[0],arbeitszeile[1],zeilen_laenge*2);
        schreibe_zeile(arbeitszeile);
      end;

    nachholen;
  end;

procedure blocktext(const pu:puffertyp;const o,zeilen,laenge:word_norm);
  var
    w1                  :word_norm;
  begin
    for w1:=0 to zeilen-1 do
      ausschrift_x(puffer_zu_zk_l(pu.d[o+w1*laenge],laenge),farblos,vorne);
  end;

procedure bsmp(const pu:puffertyp;o:word_norm);
  var
    xp,yp               :byte;
    bild_puffer         :bild_puffer_typ;
  begin
    FillChar(bild_puffer,SizeOf(bild_puffer),0);
    repeat
      xp:=pu.d[o];
      Inc(o);
      yp:=pu.d[o];
      Inc(o);
      repeat
        bild_puffer[yp+1][xp+1][1]:=pu.d[o];
        bild_puffer[yp+1][xp+1][2]:=$07;
        Inc(xp);
        Inc(o);
      until pu.d[o]=0;
      Inc(o);
    until pu.d[o]=0;

    for o:=1 to 25 do
      schreibe_monozeile(bild_puffer[o],farblos);
  end;

procedure contain(const pu:puffertyp;o:word_norm);
  var
    xp,yp               :byte;
    zae,zaehlmax        :byte;
    c_                  :byte;
    bild_puffer         :bild_puffer_typ;
  begin
    FillChar(bild_puffer,SizeOf(bild_puffer),0);
    xp:=0;
    yp:=0;
    repeat
      c_:=pu.d[o];
      Inc(o);
      if c_>=$80 then zaehlmax:=$100-c_ else zaehlmax:=c_;
      for zae:=1 to zaehlmax do
        begin
          if (pu.d[o] in [$0d,$0a,$07]) then
            begin
              xp:=0;
              if pu.d[o]=$0a then Inc(yp);
            end
          else
            begin
              bild_puffer[yp+1][xp+1][1]:=pu.d[o];
              bild_puffer[yp+1][xp+1][2]:=$07;
              Inc(xp);
            end;
          if c_<$80 then Inc(o);
        end;
      if c_>=$80 then Inc(o);
    until pu.d[o]=0;

    for o:=1 to yp do
      schreibe_monozeile(bild_puffer[o],farblos);

  end;

procedure teletext(const pu:puffertyp;o:word_norm;const ende:char;const kein_13:boolean);
  var
    xp,yp               :byte;
    zae,zaehlmax        :byte;
    c_                  :byte;
    leer                :boolean;
    bild_puffer         :bild_puffer_typ;
  begin
    if (o<0) or (o>510) then
      begin
        (*$IfNDef ENDVERSION*)
        RunError(333);
        (*$EndIf*)
        Exit;
      end;

    FillChar(bild_puffer,SizeOf(bild_puffer),0);
    xp:=1;
    yp:=1;
    (* keine leeren Zeilen *)
    while pu.d[o] in [7,10,13] do
      Inc(o);

    while pu.d[o]<>Ord(ende) do
      case pu.d[o] of
         7:Inc(o);
        10:
          begin
            Inc(yp);
            Inc(o);
            if kein_13 then
              xp:=1;
          end;
        13:
          begin
            xp:=1;
            Inc(o);
          end;
         9:
           begin
             Inc(xp);
             while (xp mod 8)<>1 do
               Inc(xp);
             Inc(o);
           end;
        else
          bild_puffer[yp][xp][1]:=pu.d[o];
          Inc(o);
          Inc(xp);
        end;

    leer:=wahr;
    while (yp>=1) and leer do
      begin
        for xp:=1 to 80 do
          if bild_puffer[yp][xp][1]<>0 then leer:=falsch;
        if leer then Dec(yp);
      end;

    for o:=1 to yp do
      schreibe_monozeile(bild_puffer[o],farblos);

  end;

procedure tc_verfolgung(const p:puffertyp);
  var
    int_off             :longint;
    ds_off              :longint;
    null                :word_norm;
    f1,f2               :word_norm;
    w1                  :word_norm;
  begin
    if bytesuche(p.d[0],#$8C#$CA) then
      begin
        if exe then
          begin
            ds_off:=longint(exe_kopf.kopfgroesse)*16;
            if exe_kopf.cs_wert=$FFF0 then Dec(ds_off,$100);
          end
        else
          ds_off:=-$100;
      end
    else
      begin
        if bytesuche(p.d[0],#$FB#$BA) then
          ds_off:=longint(word_z(@p.d[2])^)*16
        else
          ds_off:=longint(word_z(@p.d[1])^)*16;

        if exe then Inc(ds_off,longint(exe_kopf.kopfgroesse)*16);
      end;

    int_off:=0;

    w1:=puffer_pos_suche(p,#$b8#$09#$12#$bb#$43#$41#$cd#$15,100);
    if w1<>nicht_gefunden then
      begin
        ausschrift('BORLAND C, ORIGIN: Test JEMM.OVL',dos_win_extender);
        exit;
      end;

    if bytesuche(p.d[$29],#$FF#$FF#$E8) then
      int_off:=word_z(@p.d[$2C])^+$2B+3; (* DMODE.EXE *)

    if bytesuche(p.d[$25],#$E8'??'#$C4#$3E) then
      int_off:=word_z(@p.d[$26])^+$25+3; (* ARJ.EXE *)

    if bytesuche(p.d[$21],#$89#$2E'??'#$E8'??'#$A1) then
      int_off:=word_z(@p.d[$26])^+$25+3; (* CLEAN.EXE *)

    if bytesuche(p.d[$24],#$E8'??'#$C4#$3E) then
      int_off:=word_z(@p.d[$25])^+$24+3; (* TOUCH.COM *)

    if bytesuche(p.d[$28],#$FF#$FF#$E8) then
      int_off:=word_z(@p.d[$2B])^+$2A+3; (* BUILDSFX *)

    if bytesuche(p.d[$20],#$89#$2E'??'#$E8'??'#$A1) then
      int_off:=word_z(@p.d[$25])^+$24+3; (* SPEECH.COM *)

    if bytesuche(p.d[$21],#$89#$2E'??'#$E8'??'#$9C) then
      int_off:=word_z(@p.d[$26])^+$25+3; (* SPEAR.EXE *)

    if bytesuche(p.d[$3A],#$75#$1D#$57) then
      int_off:=p.d[$3B]+$3A+2;         (* PATCH.COM *)

{doppelt
    if bytesuche(p.d[$3A],#$75#$1D#$57) then
      int_off:=p.d[$3B]+$3A+2;         (* PATCH.COM *)}

    if bytesuche(p.d[$15],#$89#$2e'??'#$e8'??'#$8c#$da) then
      int_off:=p.d[$20]+$20+2;         (* EVERY.COM *)

    if bytesuche(p.d[0],#$FB#$BA) then
      int_off:=word_z(@p.d[$2D])^+$2C+3;

    if int_off=0 then (* 1987, kein Prozeduraufruf *)
      begin
        (*$IfNDef ENDVERSION *)
        {ausschrift('TC uni ',signatur);}
        (*$EndIf*)
        int_off:=60;                            (* GMS2.EXE und andere *)
      end;

    Inc(int_off,codeoff_off);
    Inc(int_off,longint(codeoff_seg)*16);
    datei_lesen(dien_puffer,analyseoff+int_off,512);


    f1:=puffer_pos_suche(dien_puffer,#$b8#$00#$25#$0e#$1f#$ba'??'#$cd#$21,500);
    f2:=puffer_pos_suche(dien_puffer,#$b8#$00#$25#$8c#$ca#$8e#$da#$ba'??'#$cd#$21,500);

    if f1<>nicht_gefunden then
      int_off:=word_z(@dien_puffer.d[f1+6])^
    else
      if f2<>nicht_gefunden then
        int_off:=word_z(@dien_puffer.d[f2+8])^
      else
        begin
          ausschrift('Turbo / Borland C? <1: '+textz_dien__veraendert_oder_neu^+'>',signatur);
          exit;
        end;

    Inc(int_off,codeoff_seg*16);

    datei_lesen(dien_puffer,analyseoff+int_off,16);
    int_off:=0;

    if bytesuche(dien_puffer.d[0],#$B9'??'#$90) then
      int_off:=ds_off+longint(word_z(@dien_puffer.d[5])^);

    if bytesuche(dien_puffer.d[0],#$BA'??'#$1E#$52) then
      int_off:=ds_off+longint(word_z(@dien_puffer.d[1])^);

    if bytesuche(dien_puffer.d[0],#$B9'??'#$BA) then
      int_off:=ds_off+longint(word_z(@dien_puffer.d[4])^);

    if bytesuche(dien_puffer.d[0],#$B9'??'#$90#$BA) then
      int_off:=ds_off+longint(word_z(@dien_puffer.d[5])^);

    if bytesuche(dien_puffer.d[0],#$1E'??'#$90#$BA) then
      int_off:=ds_off+longint(word_z(@dien_puffer.d[5])^);

    if bytesuche(dien_puffer.d[0],#$51#$1E#$52#$50#$b9'??'#$ba) then (* TF1942 *)
      int_off:=ds_off+longint(word_z(@dien_puffer.d[8])^);

    if bytesuche(dien_puffer.d[0],#$ba'??'#$52#$e8) then (* KX.EXE *)
      int_off:=ds_off+longint(word_z(@dien_puffer.d[1])^);

    if bytesuche(dien_puffer.d[0],#$ba'??'#$52#$90#$0e#$e8) then (* BOOTDI.EXE *)
      int_off:=ds_off+longint(word_z(@dien_puffer.d[1])^);

    if bytesuche(dien_puffer.d[0],#$8b#$0e'??'#$ba'??') then (* WSSM531.EXE *)
      int_off:=ds_off+longint(word_z(@dien_puffer.d[5])^);

    if int_off=0 then
      begin
        ausschrift('Turbo / Borland C? <2: '+textz_dien__unbekannte_DIV_0_Behandlung^+'>',signatur);
        exit;
      end;

    datei_lesen(dien_puffer,analyseoff+int_off-130,140);
    null:=puffer_pos_suche(dien_puffer,'Null',140);
    if null=nicht_gefunden then null:=puffer_pos_suche(dien_puffer,'Divi',140);
    if null=nicht_gefunden then null:=puffer_pos_suche(dien_puffer,'Div/0',140);
    (* Dunfield: xasm220.zip *)
    if null=nicht_gefunden then null:=puffer_pos_suche(dien_puffer,'/0 - Abort',160);
    if null<140 then
      begin
        b1:=null-2;
        exezk:='';
        while (dien_puffer.d[b1]>31) and (b1>0) do
          begin
            exezk:=chr(dien_puffer.d[b1])+exezk;
            Dec(b1);
          end;
        ausschrift(exezk,compiler)
      end
    else
      ausschrift('Turbo / Borland C? <3: '+textz_dien__veraenderter_Text^+'>',signatur);

  end;

procedure ts_verfolgung(var pu:puffertyp;const ver:string);
  var
    w                   :word_norm;
    ts_rtl              :string;
  begin
    if pu.d[$62]=$EA then
      begin
        pu.d[0]:=$EB;
        pu.d[1]:=$60;
        trace(pu);
        w:=80;
        datei_lesen(dien_puffer,analyseoff+codeoff_off+codeoff_seg*16-w,w);
        ts_rtl:='';
        Dec(w);
        while (w>0) and (not bytesuche(dien_puffer.d[w],#$b4#$4c#$cd#$21)) do
          begin
            ts_rtl:=chr(dien_puffer.d[w])+ts_rtl;
            Dec(w);
          end;
        Delete(ts_rtl,1,3);
        ts_rtl:=filter(ts_rtl);
        ausschrift('Modula 2 '+ver+' / '+ts_rtl,compiler)
      end
  end;

procedure screen_designer(const pos0:dateigroessetyp);
  var
    posi                :dateigroessetyp;
    farboff             :word_norm;
    zae                 :word_norm;
    bild_puffer         :bild_puffer_typ;
  begin
    sofortanzeige:=falsch;

    posi:=pos0;
    farboff:=0;
    while farboff<80*25 do
      begin
        datei_lesen(dien_puffer,posi,10);
        if dien_puffer.d[0]=$80 then
          begin
            for zae:=1 to dien_puffer.d[1] do
              begin
                bild_puffer[farboff div 80 +1][farboff mod 80 +1,2]:=dien_puffer.d[2];
                Inc(farboff);
              end;
            IncDGT(posi,3);
          end
        else
          begin
            bild_puffer[farboff div 80 +1][farboff mod 80 +1,2]:=dien_puffer.d[0];
            Inc(farboff);
            IncDGT(posi,1);
          end;
      end;
    farboff:=0;
    while farboff<80*25 do
      begin
        datei_lesen(dien_puffer,posi,10);
        if dien_puffer.d[0]=$1a then
          begin
            for zae:=1 to dien_puffer.d[1] do
              begin
                bild_puffer[farboff div 80 +1][farboff mod 80 +1,1]:=dien_puffer.d[2];
                Inc(farboff);
              end;
            IncDGT(posi,3);
          end
        else
          begin
            bild_puffer[farboff div 80 +1][farboff mod 80 +1,1]:=dien_puffer.d[0];
            Inc(farboff);
            IncDGT(posi,1);
          end;
      end;

    for zae:=1 to 25 do
      schreibe_zeile(bild_puffer[zae]);

    nachholen;
  end;

procedure ansi_anzeige(      o                  :dateigroessetyp;
                       const ende               :string;
                       const farbe              :byte;
                       const rand               :spaltenplatz;
                             ignoriere_anfang   :boolean;
                       const cr_lf              :boolean;
                             ende_pos           :dateigroessetyp;
                       const vortext            :string);
  var
    xp,yp,
    vfarbe,hfarbe,
    ymax,
    blinken,
    hell                :byte;
    gefunden            :boolean;
    ansi_merker         :array[0..10] of byte;
    ansi_merker_pos     :byte;
    ziffernzeiger       :byte;
    zae                 :byte;
    x_sich,y_sich       :byte;
    ansi_tastaturdefinion:boolean;
    randabstand         :byte;
    vortext_zaehler     :byte;
    alt64_code          :boolean;
    bild_puffer         :bild_puffer_typ;
    fundstelle          :word_norm;
    mac_modus_moeglich  :boolean;

  label
    ansi_fertig;

  function hexz_zu_integer(const z:char):byte;
    begin
      case z of
        '0'..'9':hexz_zu_integer:=Ord(z)-Ord('0');
        'A'..'F':hexz_zu_integer:=Ord(z)-Ord('A')+10;
        'a'..'f':hexz_zu_integer:=Ord(z)-Ord('a')+10;
      else
        hexz_zu_integer:=0;
      end;
    end; (* hexz_zu_integer *)

  procedure zahlen_konvertierung;
    var
      zk_laenge         :word_norm;
    begin
      ansi_merker[ansi_merker_pos]:=0;
      while (dien_puffer.d[2+ziffernzeiger] in [Ord('0')..Ord('9'),Ord('"')]) do
        begin
          if dien_puffer.d[2+ziffernzeiger]=Ord('"') then
            begin
              zk_laenge:=0;
              while (dien_puffer.d[2+ziffernzeiger+1+zk_laenge]<>Ord('"')) and (2+ziffernzeiger+1+zk_laenge<511) do
                Inc(zk_laenge);
              Inc(ziffernzeiger,1+zk_laenge+1);
            end
          else
            ansi_merker[ansi_merker_pos]:=10*ansi_merker[ansi_merker_pos]
              +Ord(dien_puffer.d[2+ziffernzeiger])-Ord('0');
          Inc(ziffernzeiger);
        end;

      Inc(ansi_merker_pos);
      Inc(ziffernzeiger);
    end; (* zahlen_konvertierung *)

  procedure schreibe_zeichen(const z:char);
    begin
      bild_puffer[yp][xp+randabstand][1]:=Ord(' ');
      bild_puffer[yp][xp+randabstand][2]:=(hfarbe+blinken)*16+(vfarbe+hell);
      Inc(xp);
      if xp>80 then
        begin
          Dec(xp,80);
          Inc(yp);
        end;
    end; (* schreibe_zeichen *)

  var
    x_alt,y_alt         :word_norm;

  begin (* ansi_anzeige *)
    if rand=vorne then
      randabstand:=0
    else
      randabstand:=+6;

    Inc(randabstand,Length(vortext));

    fuell_word(bild_puffer,SizeOf(bild_puffer) shr 1,farbe*$100+Ord(' '));
    alt64_code:=false;
    xp:=1;
    yp:=1;
    x_sich:=1;
    y_sich:=1;
    hfarbe:=farbe shr  4; (* div 16 *)
    vfarbe:=farbe and $f; (* mod 16 *)
    blinken:=0;
    hell:=0;
    ymax:=1;
    ansi_tastaturdefinion:=false;
    sofortanzeige:=false;
    mac_modus_moeglich:=true;

    if ende_pos=unendlich then
      ende_pos:=dateilaenge;


    if o<ende_pos then
      begin
        datei_lesen(dien_puffer,o,30);
        fundstelle:=puffer_pos_suche(dien_puffer,'@X',25);
        if fundstelle<>nicht_gefunden then
        (*if (fundstelle=0) or (fundstelle=2) then *schlÑgt bei TRX-GFX2.ZIP\BARS\bar8.PCB fehl *)
          if  (chr(dien_puffer.d[fundstelle+2]) in ['0'..'9','A'..'F'])
          and (chr(dien_puffer.d[fundstelle+3]) in ['0'..'9','A'..'F'])
           then
            (* UCF ... *)
            alt64_code:=true;

        alt64_code:=alt64_code or (puffer_pos_suche(dien_puffer,'@CLS@',20)<>nicht_gefunden);
      end;

    repeat
      if o=ende_pos then
        goto ansi_fertig;

      datei_lesen(dien_puffer,o,20);

      if bytesuche(dien_puffer.d[0],ende) then
        goto ansi_fertig;

      gefunden:=falsch;
      ansi_merker_pos:=0;
      ziffernzeiger:=0;

      case dien_puffer.d[0] of
        0:
          if ignoriere_anfang then (* cachejfs.exe *)
            begin
              IncDGT(o,1);
              gefunden:=true;
            end;


        7:
          begin
            IncDGT(o,1);
            gefunden:=wahr;
          end;

        8:
          begin
            if xp>1 then
              Dec(xp);
            IncDGT(o,1);
            gefunden:=wahr;
          end;

        9:
          begin
            repeat
              schreibe_zeichen(' ');
            until (xp and 7)=1;
            IncDGT(o,1);
            gefunden:=wahr;
          end;

        10:
          begin
            mac_modus_moeglich:=false;
            if (yp>1)
            or (not ignoriere_anfang)
            or (xp>1) then
              Inc(yp);
            IncDGT(o,1);
            gefunden:=wahr;
            if not cr_lf then
              xp:=1;
          end;

        12:
          begin
            xp:=1;
            yp:=1;
            IncDGT(o,1);
            gefunden:=wahr;
          end;

        13:
          begin
            if alt64_code then
              while xp<42 do
                schreibe_zeichen(' ');

            (* énderung ... gif-Kommentar alchemy mindworks *)
            if mac_modus_moeglich and (dien_puffer.d[1]<>10) then
              if (yp>1)
              or (not ignoriere_anfang)
              or (xp>1) then
                Inc(yp);
            (* ... *)

            if xp>1 then
              ignoriere_anfang:=falsch;
            xp:=1;
            IncDGT(o,1);
            gefunden:=wahr;
          end;

        26:
         (* STRG-Z *)
         goto ansi_fertig;

        27:
          if dien_puffer.d[1]=Ord('[') then
            case chr(dien_puffer.d[2]) of
              '0'..'9':
                begin
                  zahlen_konvertierung;
                  while chr(dien_puffer.d[2+ziffernzeiger-1]) in [';',','] do
                    zahlen_konvertierung;
                  Dec(ziffernzeiger);


                  case chr(dien_puffer.d[2+ziffernzeiger]) of
                    'm':
                      begin
                        for zae:=0 to ansi_merker_pos-1 do
                          case ansi_merker[zae] of
                            0:
                              begin
                                hfarbe:=0;
                                vfarbe:=7;
                                blinken:=0;
                                hell:=0;
                              end;
                            1:hell:=8;
                            5:blinken:=8;
                            7:
                              begin
                                vfarbe:=0;
                                hfarbe:=7;
                                (* blinken ... ? *)
                              end;
                            8:
                              begin
                                hfarbe:=0;
                                vfarbe:=0;
                                blinken:=0;
                                hell:=0;
                              end;
                           30:vfarbe:=0;
                           31:vfarbe:=4;
                           32:vfarbe:=2;
                           33:vfarbe:=6; (* dunkelgelb *)
                           34:vfarbe:=1;
                           35:vfarbe:=5;
                           36:vfarbe:=3;
                           37:vfarbe:=7;
                           40:hfarbe:=0;
                           41:hfarbe:=4;
                           42:hfarbe:=2;
                           43:hfarbe:=6;
                           44:hfarbe:=1;
                           45:hfarbe:=5;
                           46:hfarbe:=3;
                           47:hfarbe:=7;
                         end;
                         gefunden:=wahr;
                         IncDGT(o,2+ziffernzeiger+1);
                      end;
                    'p':
                      begin
                        ansi_tastaturdefinion:=true;
                        gefunden:=wahr;
                        IncDGT(o,2+ziffernzeiger+1);
                      end;

                    'H':
                      begin
                        yp:=ansi_merker[0];
                        if ansi_merker_pos=2 then
                          xp:=ansi_merker[1]
                        else
                          xp:=1;
                        gefunden:=wahr;
                        IncDGT(o,2+ziffernzeiger+1);

                      end;
                    'J':
                      begin
                        fuell_word(bild_puffer,SizeOf(bild_puffer) shr 1,$100*Word((hfarbe+blinken)*$10+(vfarbe+hell)));
                        gefunden:=wahr;
                        xp:=1;
                        yp:=1;
                        IncDGT(o,2+ziffernzeiger+1);
                      end;
                    'A':
                      begin
                        if ansi_merker[0]>yp then
                          yp:=1
                        else
                          Dec(yp,ansi_merker[0]);
                        gefunden:=wahr;
                        IncDGT(o,2+ziffernzeiger+1);
                      end;
                    'B':
                      begin
                        Inc(yp,ansi_merker[0]);
                        gefunden:=wahr;
                        IncDGT(o,2+ziffernzeiger+1);
                      end;
                    'C':
                      begin
                        Inc(xp,ansi_merker[0]);
                        while xp>80 do (* TSG.NFO *)
                          begin
                            Dec(xp,80);
                            Inc(yp);
                          end;
                        gefunden:=wahr;
                        IncDGT(o,2+ziffernzeiger+1);
                      end;
                    'D':
                      begin
                        if xp<=ansi_merker[0] then
                          xp:=1
                        else
                          Dec(xp,ansi_merker[0]);
                        gefunden:=wahr;
                        IncDGT(o,2+ziffernzeiger+1);
                      end;

                   end;
                end;
              's':
                begin
                  x_sich:=xp;
                  y_sich:=yp;
                  gefunden:=wahr;
                  IncDGT(o,2+1);
                end;
               'u':
                 begin
                   xp:=x_sich;
                   yp:=y_sich;
                   gefunden:=wahr;
                   IncDGT(o,2+1);
                 end;
               'A':
                 begin
                   if yp>1 then Dec(yp);
                   gefunden:=wahr;
                   IncDGT(o,2+1);
                 end;
               'B':
                 begin
                   Inc(yp);
                   gefunden:=wahr;
                   IncDGT(o,2+1);
                 end;
               'C':
                 begin
                   if xp<80 then Inc(xp);
                   gefunden:=wahr;
                   IncDGT(o,2+1);
                 end;
               'D':
                 begin
                   if xp>1 then Dec(xp);
                   gefunden:=wahr;
                   IncDGT(o,2+1);
                 end;
               'H':
                 begin
                   xp:=1;
                   yp:=1;
                   gefunden:=wahr;
                   IncDGT(o,2+1);
                 end;
               'K':
                 begin
                   x_alt:=xp;
                   y_alt:=yp;
                   for zae:=xp to 80 do
                     schreibe_zeichen(' ');
                   xp:=x_alt;
                   yp:=y_alt;
                   gefunden:=wahr;
                   IncDGT(o,2+1);
                 end;
               '=': (* set video mode .. *)
                 begin
                   gefunden:=wahr;
                   IncDGT(o,2+3);
                 end;
            end; (* CASE .. ESC "[" *)

        Ord('@'):
          begin
            if  (dien_puffer.d[1]=Ord('X'))
            and alt64_code
            and (chr(dien_puffer.d[2]) in ['0'..'9','A'..'F']) (* "@XFree86.Org" *)
            and (chr(dien_puffer.d[3]) in ['0'..'9','A'..'F'])
             then
              begin
                gefunden:=wahr;
                IncDGT(o,4);
                blinken:=0;
                hell:=0;
                vfarbe:=hexz_zu_integer(chr(dien_puffer.d[3]));
                hfarbe:=hexz_zu_integer(chr(dien_puffer.d[2]));
              end;

            (* TRX-GFX2.ZIP\BARS\*.PCB *)
            if bytesuche(dien_puffer.d[1],'PB@')
            or bytesuche(dien_puffer.d[1],'PE@')
             then
              begin
                gefunden:=wahr;
                IncDGT(o,Length('@PB@'));
              end;

            if bytesuche(dien_puffer.d[1],'CLS@') then
              begin
                gefunden:=wahr;
                IncDGT(o,Length('@CLS@'));
              end;
          end; (* '@' *)

      end;  (* CASE .d[0] *)

      if vfarbe>=8 then
        begin
          hell:=8;
          vfarbe:=vfarbe and 7;
        end;

      if not gefunden then
        begin
          if xp>80 then
            begin
              Inc(yp);
              xp:=1;
            end;

          if xp+randabstand<=80 then
            begin
              bild_puffer[yp][xp+randabstand][1]:=dien_puffer.d[0];
              bild_puffer[yp][xp+randabstand][2]:=(hfarbe+blinken)*16+(vfarbe+hell);
            end;
          Inc(xp);
          IncDGT(o,1);
        end;

      (* PCXDUMP 9.30 vertraut auf 80 Spalten *)
      if xp>80 then
        begin
          Inc(yp);
          xp:=1;
        end;

      if yp>ymax then
        Inc(ymax);
    until (dien_puffer.g<=0) or (ymax>=pred(ansi_maxzeilen));

    ansi_fertig:

    if ymax>ansi_maxzeilen then
      ymax:=ansi_maxzeilen;

    sofortanzeige:=falsch;

    (* keine Anzeige von "" *)
    if (ignoriere_anfang) and (1=ymax) and (1=xp) then
      begin
        nachholen;
        Exit;
      end;

    if rand<>vorne then
      begin
        xp:=80;
        while ((ymax+xp)>1) and (bild_puffer[ymax][xp][1]=$20) and (bild_puffer[ymax][xp][2]=farbe) do
          if (xp=1) and (ymax>1) then
            begin
              Dec(ymax);
              xp:=80;
            end
          else
            Dec(xp);

        if xp>=80 then
          begin
            Inc(ymax);
            xp:=6;
          end;

        case rand of
          (* auch in typ_ausg.ausschrift_x Ñndern *)
          anstrich  :bild_puffer[1][3][1]:=Ord('˛');
          absatz    :bild_puffer[1][3][1]:=Ord('˙');
          leer      :bild_puffer[1][3][1]:=Ord(' ');
          ea_zeichen:bild_puffer[1][3][1]:=Ord('*');
        end;

        for vortext_zaehler:=1 to Length(vortext) do
          bild_puffer[1][3+vortext_zaehler][1]:=Ord(vortext[vortext_zaehler]);
        bild_puffer[1][randabstand][1]:=Ord('"');
        if (ymax=1) and (xp+1<=randabstand) then
          bild_puffer[1][randabstand+1][1]:=Ord('"')
        else
          bild_puffer[ymax][xp+1][1]:=Ord('"');
      end;

    for yp:=1 to ymax do
      schreibe_zeile(bild_puffer[yp]);

    if ansi_tastaturdefinion then
      ausschrift(textz_dien__WARNUNG_Umdefinition_der_Tastaturbelegung^,signatur);

    nachholen;

  end;


procedure bat_datei(const p:puffertyp);
  begin
    ausschrift(textz_dien__Stapelverarbeitungsdatei^,signatur);

    if puffer_zeilen_anfang_suche(p,'DEBUG') then
      ausschrift(textz_dien__mit_DEBUG^,signatur);

    if puffer_zeilen_anfang_suche(p,'DOSINFO.EXE') then
      ausschrift('Erichs letzte Rache',virus);

    if puffer_gefunden(p,': THIS IS A COMMAND.COM ARCHIVE (PRODUCED BY DSHAR ?.??), MEANING:') then
      ausschrift('dshar / NIDE Naoyuk',packer_dat);

  end;

procedure os2_ico(const analyseoff:dateigroessetyp;const anfang:spaltenplatz);
  var
    os2_ico_puffer      :puffertyp;
    bildoff             :longint;
    start_tab           :array[1..2] of dateigroessetyp;
    x_richtung_tab,
    y_richtung_tab,
    ebenen_tab          :array[1..2] of word_norm;
    ba_laenge           :word_norm;

  type
    mal_modus=(modus_bilddaten,
               modus_transparenz,
               modus_invers);

  procedure zeichnung(const start:dateigroessetyp;x_richtung,y_richtung,ebenen:word;const modus:mal_modus);
    var
      x,y               :word_norm;
      farbe             :byte;
      zeilenlaenge      :word_norm;
      ignore_shift      :byte;
    begin
      if (x_richtung>64) or (y_richtung>64) then
        ignore_shift:=1
      else
        ignore_shift:=0;

      zeilenlaenge:=x_richtung*ebenen;
      aufrunden_word_norm(zeilenlaenge,32);
      zeilenlaenge:=zeilenlaenge shr 3; (* /8 *)

      for y:=1-1 to y_richtung-1 do
        begin
          if (ignore_shift and y)=1 then Continue;

          datei_lesen(dien_puffer,start+y*zeilenlaenge,zeilenlaenge);
          (*$IfNDef ENDVERSION*)
          if dien_puffer.g<>zeilenlaenge then
            {runerror(888)};
          (*$EndIf*)

          for x:=1-1 to x_richtung-1 do
            begin
              if (ignore_shift and x)=1 then Continue;
              case ebenen of
                1:
                  begin
                    farbe:=(dien_puffer.d[x shr 3] shr (7-(x and 7))) and 1;
                    if modus=modus_bilddaten then
                      farbe:=rgb_tauschtabelle[farbe];
                  end;

                2:
                  begin
                    case x and 3 of
                     0:farbe:=(dien_puffer.d[x shr 2] shr 6) and 3;
                     1:farbe:=(dien_puffer.d[x shr 2] shr 4) and 3;
                     2:farbe:=(dien_puffer.d[x shr 2] shr 2) and 3;
                     3:farbe:=(dien_puffer.d[x shr 2] shr 0) and 3;
                    end;
                    farbe:=rgb_tauschtabelle[farbe];
                  end;

                4:
                  case x and 1 of
                    0:farbe:=rgb_tauschtabelle[dien_puffer.d[x shr 1] shr   4];
                    1:farbe:=rgb_tauschtabelle[dien_puffer.d[x shr 1] and $0f];
                  end;

                8:farbe:=rgb_tauschtabelle[dien_puffer.d[x]];

               24:farbe:=rgb(dien_puffer.d[x*3+2],
                             dien_puffer.d[x*3+1],
                             dien_puffer.d[x*3+0]);
              end;

              case ignore_shift of
                0:
                  case modus of
                    modus_bilddaten:
                      bild[x,(y_richtung-y-1)]:=farbe;
                    modus_transparenz:
                      if farbe=1 then
                        bild[x,(y_richtung-y-1)]:=os_2_ico_farbe;
                    modus_invers:
                      if farbe=1 then
                        bild[x,(y_richtung-y-1)]:=15-bild[x,(y_richtung-y-1)];
                  end;
                1:
                  case modus of
                    modus_bilddaten:
                      bild[x shr 1,(y_richtung-y-1) shr 1]:=farbe;
                    modus_transparenz:
                      if farbe=1 then
                        bild[x shr 1,(y_richtung-y-1) shr 1]:=os_2_ico_farbe;
                    modus_invers:
                      if farbe=1 then
                        bild[x shr 1,(y_richtung-y-1) shr 1]:=15-bild[x shr 1,(y_richtung-y-1) shr 1];
                  end;
              end;


            end;
        end;
    end;

  procedure einzelbild(analyseoff,off:dateigroessetyp);
    var
      einzel_puffer     :puffertyp;
      z1                :word_norm;
      bild_anzahl       :word_norm;
      zaehl             :word_norm;
      maske_vorhanden   :boolean;
      o_palette         :dateigroessetyp;

    function kompression(b:byte):string;
      begin
        case b of
          0:kompression:='';
          1:kompression:=', RLE8';       (* PMVIEW  8 bit *)
          2:kompression:=', RLE4';       (* PMVIEW  4 bit *)
          3:kompression:=', Huffman-1D'; (* PMVIEW  1 bit *)
          4:kompression:=', RLE24';      (*?PMVIEW 24 bit *)
        else
            kompression:=' (¯'+str0(b)+')';
        end;
      end;

    begin
      datei_lesen(einzel_puffer,analyseoff+off,$160);

      bild_anzahl:=0;
      exezk:='??? ¯ ';
      if bytesuche(einzel_puffer.d[0],'CI') then (* COLOUR ICON *)
        begin
          exezk:='Icon';
          bild_anzahl:=2;
          maske_vorhanden:=true;
        end;
      if bytesuche(einzel_puffer.d[0],'CP') then (* COLOUR POINTER *)
        begin
          exezk:=textz_dien__Zeiger^;
          bild_anzahl:=2;
          maske_vorhanden:=true;
        end;
      if bytesuche(einzel_puffer.d[0],'BM') then (* BITMAP *)
        begin
          exezk:='BMP';
          bild_anzahl:=1;
          maske_vorhanden:=false;
        end;
      if bytesuche(einzel_puffer.d[0],'PT') then (* POINTER [MONO] *)
        begin
          exezk:=textz_dien__Mauszeiger^;
          bild_anzahl:=1;
          maske_vorhanden:=true;
        end;
      if bytesuche(einzel_puffer.d[0],'IC') then (* ICON [MONO] *)
        begin
          (* OS/2 4.0 PMVIOP.DLL RESOURCE *)
          {ausschrift(textz_dien__Farbtabelle^+' OS/2',musik_bild);}
          exezk:='Icon';
          bild_anzahl:=1;
          maske_vorhanden:=true;
        end;

      if bild_anzahl=0 then
        Exit;

      case einzel_puffer.d[$e] of
        $0c:
          begin
            for zaehl:=1 to bild_anzahl do
              begin
                start_tab     [zaehl]    :=word_z(@einzel_puffer.d[$0a+$20*(zaehl-1)])^;
                x_richtung_tab[zaehl]    :=word_z(@einzel_puffer.d[$12+$20*(zaehl-1)])^;
                y_richtung_tab[zaehl]    :=word_z(@einzel_puffer.d[$14+$20*(zaehl-1)])^;
                ebenen_tab    [zaehl]    :=word_z(@einzel_puffer.d[$18+$20*(zaehl-1)])^;
              end;

            if maske_vorhanden then
              y_richtung_tab[1]:=y_richtung_tab[1] shr 1; (* div 2 *)

            bild_format_filter(exezk+' [OS/2 1.x]',
                               x_richtung_tab[bild_anzahl],
                               y_richtung_tab[bild_anzahl],
                               -1,ebenen_tab[bild_anzahl],false,true,anfang);


            if (ebenen_tab[bild_anzahl]>32)
            or (not (ebenen_tab[bild_anzahl] in [1,2,4,8,24])) then
              begin
                ausschrift_x(textz_dien__ungewohnte_Anzahl_Farbebenen^,signatur,anfang);
                exit;
              end;

            if (x_richtung_tab[bild_anzahl]>64*2) or (y_richtung_tab[bild_anzahl]>64*2)
            or (not ico_anzeige) then
              Exit;

            if ebenen_tab[bild_anzahl] in [4,8] then (* und 1/2? *)
              begin
                o_palette:=analyseoff+off+$3a+$20*(bild_anzahl-2);
                for z1:=0 to (1 shl longint(ebenen_tab[bild_anzahl])-1) do
                  begin
                    datei_lesen(einzel_puffer,o_palette,3);
                    IncDGT(o_palette,3);
                    rgb_tauschtabelle[z1]:=
                    rgb(einzel_puffer.d[2-2*dumm]  (* in machen FÑllen -2 *)
                       ,einzel_puffer.d[1]
                       ,einzel_puffer.d[0+2*dumm]);(* in machen FÑllen +2 *)
                  end;
              end
            else
              begin
                rgb_tauschtabelle[0]:=0;
                rgb_tauschtabelle[1]:=15;
              end;
          end;

        $28, (* Windows 3, OS/2 Starwriter *)
        $18: (* dazugeraten - papyrus *)
          begin
            for zaehl:=1 to bild_anzahl do
              begin
                start_tab     [zaehl]    :=longint_z(@einzel_puffer.d[$0a+$3e*(zaehl-1)])^;
                x_richtung_tab[zaehl]    :=word_z(@einzel_puffer.d[$12+$3e*(zaehl-1)])^;
                y_richtung_tab[zaehl]    :=word_z(@einzel_puffer.d[$16+$3e*(zaehl-1)])^;
                ebenen_tab    [zaehl]    :=word_z(@einzel_puffer.d[$1c+$3e*(zaehl-1)])^;
              end;

            if maske_vorhanden then
              y_richtung_tab[1]:=y_richtung_tab[1] shr 1; (* div 2 *)

            if einzel_puffer.d[$e]=$28 then
              bild_format_filter(exezk+(*' [OS/2 ?.? (StarWriter 3.0)'*)+' [Windows 3'+kompression(einzel_puffer.d[$1e])+']',
                                 x_richtung_tab[bild_anzahl],
                                 y_richtung_tab[bild_anzahl],
                                 -1,ebenen_tab[bild_anzahl],false,true,anfang)
            else
              bild_format_filter(exezk+' [OS/2 ?.? (Papyrus 9.21)'+kompression(einzel_puffer.d[$1e])+']',
                                 x_richtung_tab[bild_anzahl],
                                 y_richtung_tab[bild_anzahl],
                                 -1,ebenen_tab[bild_anzahl],false,true,anfang);

            (* komprimiert? *)
            if einzel_puffer.d[$1e]<>0 then exit;


            if (ebenen_tab[bild_anzahl]>32)
            or (not (ebenen_tab[bild_anzahl] in [1,2,4,8,24])) then
              begin
                ausschrift_x(textz_dien__ungewohnte_Anzahl_Farbebenen^,signatur,anfang);
                Exit;
              end;

            if (x_richtung_tab[bild_anzahl]>64*2) or (y_richtung_tab[bild_anzahl]>64*2)
            or (not ico_anzeige) then
              Exit;

            if ebenen_tab[bild_anzahl] in [4,8] then (* und 1/2? *)
              begin
                o_palette:=analyseoff+off+$74+$3e*(bild_anzahl-2);
                for z1:=0 to (1 shl longint(ebenen_tab[bild_anzahl])-1) do
                  begin
                    datei_lesen(einzel_puffer,o_palette,4);
                    IncDGT(o_palette,4);

                    rgb_tauschtabelle[z1]:=
                    rgb(einzel_puffer.d[2]
                       ,einzel_puffer.d[1]
                       ,einzel_puffer.d[0]);
                  end;
              end
            else
              begin
                rgb_tauschtabelle[0]:=0;
                rgb_tauschtabelle[1]:=15;
              end;
          end;


        $24: (* alchemy -O "OS/2" *)
          begin
            for zaehl:=1 to bild_anzahl do
              begin
                start_tab     [zaehl]:=word_z(@einzel_puffer.d[$0a+$56*(zaehl-1)])^;
                x_richtung_tab[zaehl]:=word_z(@einzel_puffer.d[$12+$56*(zaehl-1)])^;
                y_richtung_tab[zaehl]:=word_z(@einzel_puffer.d[$16+$56*(zaehl-1)])^;
                ebenen_tab    [zaehl]:=word_z(@einzel_puffer.d[$1c+$56*(zaehl-1)])^;
              end;

            if not bytesuche(einzel_puffer.d[0],'BM') then
              y_richtung_tab[1]:=y_richtung_tab[1] shr 1; (* div 2 *)

            bild_format_filter(exezk+' [OS/2 ?.?'+kompression(einzel_puffer.d[$1e])+']',
                               x_richtung_tab[bild_anzahl],
                               y_richtung_tab[bild_anzahl],
                               -1,ebenen_tab[bild_anzahl],false,true,anfang);

            (* komprimiert? *)
            if einzel_puffer.d[$1e]<>0 then exit;

            if not(ebenen_tab[bild_anzahl] in [1,2,4,8,24]) then
              begin
                ausschrift_x(textz_dien__ungewohnte_Anzahl_Farbebenen^,signatur,anfang);
                exit;
              end;

            if (x_richtung_tab[bild_anzahl]>64*2) or (y_richtung_tab[bild_anzahl]>64*2)
            or (not ico_anzeige) then
              exit;


            if ebenen_tab[bild_anzahl] in [4,8] then
              begin
                o_palette:=analyseoff+off+$e+longint_z(@einzel_puffer.d[$e])^;
                for z1:=0 to (1 shl longint(ebenen_tab[bild_anzahl])-1) do
                  begin
                    datei_lesen(einzel_puffer,o_palette,4);
                    IncDGT(o_palette,4);
                    rgb_tauschtabelle[z1]:=
                    rgb(einzel_puffer.d[2]
                       ,einzel_puffer.d[1]
                       ,einzel_puffer.d[0]);
                end
              end
            else
              begin
                rgb_tauschtabelle[0]:=0;
                rgb_tauschtabelle[1]:=15;
              end;
          end; (* $24 *)

        $40:
          begin
            for zaehl:=1 to bild_anzahl do
              begin
                start_tab     [zaehl]:=word_z(@einzel_puffer.d[$0a+$56*(zaehl-1)])^;
                x_richtung_tab[zaehl]:=word_z(@einzel_puffer.d[$12+$56*(zaehl-1)])^;
                y_richtung_tab[zaehl]:=word_z(@einzel_puffer.d[$16+$56*(zaehl-1)])^;
                ebenen_tab    [zaehl]:=word_z(@einzel_puffer.d[$1c+$56*(zaehl-1)])^;
              end;

            if not bytesuche(einzel_puffer.d[0],'BM') then
              y_richtung_tab[1]:=y_richtung_tab[1] shr 1; (* div 2 *)

            bild_format_filter(exezk+' [OS/2 2.x'+kompression(einzel_puffer.d[$1e])+']',
                               x_richtung_tab[bild_anzahl],
                               y_richtung_tab[bild_anzahl],
                               -1,ebenen_tab[bild_anzahl],false,true,anfang);

            (* komprimiert? *)
            if einzel_puffer.d[$1e]<>0 then exit;

            if not(ebenen_tab[bild_anzahl] in [1,2,4,8,24]) then
              begin
                ausschrift_x(textz_dien__ungewohnte_Anzahl_Farbebenen^,signatur,anfang);
                exit;
              end;

            if (x_richtung_tab[bild_anzahl]>64*2) or (y_richtung_tab[bild_anzahl]>64*2)
            or (not ico_anzeige) then
              Exit;


            if ebenen_tab[bild_anzahl] in [1{??},2{??},4,8] then
              begin
                o_palette:=analyseoff+off+$A4+$56*(bild_anzahl-2);
                for z1:=0 to (1 shl longint(ebenen_tab[bild_anzahl])-1) do
                  begin
                    datei_lesen(einzel_puffer,o_palette,4);
                    IncDGT(o_palette,4);

                    rgb_tauschtabelle[z1]:=
                    rgb(einzel_puffer.d[2]
                       ,einzel_puffer.d[1]
                       ,einzel_puffer.d[0]);
                  end;
              end
            else
              begin
                rgb_tauschtabelle[0]:=0;
                rgb_tauschtabelle[1]:=15;
              end;
          end;
      else
        ausschrift_x(textz_dien__unbekannte_Version^+' ¯',signatur,anfang);
        Exit;
      end;



      if bild_anzahl=1 then
        begin
          if not maske_vorhanden then
            begin (* normales BMP *)
              (* Bilddaten *)
              zeichnung(
                analyseoff+start_tab[1],
                x_richtung_tab[1],
                y_richtung_tab[1],
                ebenen_tab[1],
                modus_bilddaten);
            end
          else
            begin (* MONO ICON *)
              (* Bilddaten *)
              zeichnung(
                analyseoff+start_tab[1]+aufrundenf(x_richtung_tab[1],32)*y_richtung_tab[1] shr 3,
                x_richtung_tab[1],
                y_richtung_tab[1],
                ebenen_tab[1],
                modus_bilddaten);

              (* Maske/Invers *)
              zeichnung(
                analyseoff+start_tab[1],
                x_richtung_tab[1],
                y_richtung_tab[1],
                ebenen_tab[1],
                modus_invers);
            end;
        end
      else (* bild_anzahl=2 *)
        begin
          (* Farbdaten *)
          zeichnung(
            analyseoff+start_tab[2],
            x_richtung_tab[2],
            y_richtung_tab[2],
            ebenen_tab[2],
            modus_bilddaten);

          (* Bildmaske *)
          zeichnung(
            analyseoff+start_tab[1]+aufrundenf(x_richtung_tab[1],32)*y_richtung_tab[1] shr 3,
            x_richtung_tab[1],
            y_richtung_tab[1],
            ebenen_tab[1],
            modus_transparenz);

          (* Invers *)
          zeichnung(
            analyseoff+start_tab[1],
            x_richtung_tab[1],
            y_richtung_tab[1],
            ebenen_tab[1],
            modus_invers);
        end;

      schreibe_bild(
        x_richtung_tab[bild_anzahl],
        y_richtung_tab[bild_anzahl],
        os_2_ico_farbe);
      sofortanzeige:=falsch;

    end; (* EINZELBILD *)

  begin
    sofortanzeige:=falsch;
    bildoff:=0;
    repeat
      datei_lesen(os2_ico_puffer,analyseoff+bildoff,10);

      if bytesuche(os2_ico_puffer.d[0],'CI')
      or bytesuche(os2_ico_puffer.d[0],'CP')
      or bytesuche(os2_ico_puffer.d[0],'BM')
      or bytesuche(os2_ico_puffer.d[0],'IC')
      or bytesuche(os2_ico_puffer.d[0],'PT')
       then
        einzelbild(analyseoff,0)
      else
        if bytesuche(os2_ico_puffer.d[0],'BA') then
          begin
            ba_laenge:=word_z(@os2_ico_puffer.d[6])^;
            einzelbild(analyseoff,bildoff+14);

            bildoff:=ba_laenge;
          end
        else
          bildoff:=0;

      until bildoff=0;
    if sofortanzeige=falsch then
      nachholen;
  end;

(*
0=wei· nicht
1=ico
2=bmp
3=cur *)
procedure windows_ico1(datenoff,ico_laenge:dateigroessetyp;kommentarlos:boolean;ico_oder_bmp:byte);
  var
    x_richtung,
    y_richtung,
    ebenen              :word_norm;
    z1,zy,zx            :word_norm;
    zeilenlaenge,
    zeilenlaenge_maske  :word_norm;
    o,l                 :dateigroessetyp;
    beschreibung        :string;
    i,j                 :integer_norm;
  begin

    o:=0;

    datei_lesen(dien_puffer,datenoff+o,$28);
    IncDGT(o,longint_z(@dien_puffer.d[$0])^); (* Kopf ($28) *)

    x_richtung:=word_z(@dien_puffer.d[$4])^;
    y_richtung:=word_z(@dien_puffer.d[$8])^(* div 2*);

    ebenen    :=word_z(@dien_puffer.d[$e])^;

    zeilenlaenge:=x_richtung*ebenen;
    aufrunden_word_norm(zeilenlaenge,32);
    zeilenlaenge:=zeilenlaenge shr 3; (* div 8 *)

    zeilenlaenge_maske:=x_richtung*1;
    aufrunden_word_norm(zeilenlaenge_maske,32);
    zeilenlaenge_maske:=zeilenlaenge_maske shr 3;

    l:=o;
    if ebenen<=8 then (* Palette *)
      IncDGT(l,4 shl ebenen);

    (* Ungerade Anzahl Zeilen->keine Maske->Bitmap *)
    if (ico_oder_bmp=0) and Odd(y_richtung) then
      ico_oder_bmp:=2;


    if ico_oder_bmp=0 then
      begin

        if  (ico_laenge>=l+(zeilenlaenge+zeilenlaenge_maske)*(y_richtung shr 1))
        and (ico_laenge< l+(zeilenlaenge                   )*(y_richtung      )) then
          ico_oder_bmp:=1 (* y=y_farbe+y_maske -> 2 icon *)
        else
        if  (ico_laenge>=l+(zeilenlaenge                   )*(y_richtung      )+ 0)
        and (ico_laenge< l+(zeilenlaenge                   )*(y_richtung      )+16) then
          begin

            if zeilenlaenge<>zeilenlaenge_maske then
              ico_oder_bmp:=2 (* y=y_farbe -> bitmap *)
            else (* kînnte beides  sein, wenn Mono *)
              begin
                ico_oder_bmp:=1; (* geraten: icon *)
                { funktioniert       bei top1058 CMDIALOG.VBX Icon.3
                  funktioniert nicht bei top1076 setup.exe    icon.5
                for i:=y_richtung shr 1 to y_richtung-1 do
                  begin
                    datei_lesen(dien_puffer,datenoff+l+i*zeilenlaenge,Min(zeilenlaenge,512));
                    with dien_puffer do
                      for j:=0 to g-1 do
                        if d[j]<>0 then
                          ico_oder_bmp:=2; (* geraten: bitmap *)
                    if ico_oder_bmp=2 then Break;
                  end;
                deshalb abgeschaltet. besser:
                vergeleiche Zeile y/2 und y/2-1
                éhnlichkeit->Bitmap, sonst Icon}
              end;

          end
        else
          begin
            if (ico_laenge=$100) and (l+zeilenlaenge*y_richtung<$100) then
              begin
                (* fÅr top1076 setup.exe    icon.5 *)
                windows_ico1(datenoff,l+zeilenlaenge*y_richtung,kommentarlos,0);
                Exit;
              end;
          end;
      end;


    if (ico_oder_bmp in [1,3]) and ((y_richtung and 1)=0) then
      y_richtung:=y_richtung shr 1; (* div 2 *)

    if not kommentarlos then
      begin
        case ico_oder_bmp of
          1:beschreibung:='Windows ICO';
          3:beschreibung:='Windows Cursor';
        else
            beschreibung:='Windows Bitmap';
        end;
        bild_format_filter(beschreibung,
                           x_richtung,
                           y_richtung,
                           -1,ebenen,false,true,anstrich);
      end;

    if (ebenen>32)
    or (not ico_anzeige)
    or (not (ebenen in [1,2,4,8,24]))
    or (x_richtung>64)
    or (y_richtung>64)
     then
      Exit;

    (* Farbtabelle vorhanden? *)
    if ebenen<=8 then
      for z1:=0 to (1 shl ebenen)-1 do
        begin
          datei_lesen(dien_puffer,datenoff+o,4);
          IncDGT(o,4);
          rgb_tauschtabelle[z1]:=
            rgb(dien_puffer.d[2],
                dien_puffer.d[1],
                dien_puffer.d[0]);
        end;



    (* Farbdaten *)
    for zy:=y_richtung-1 downto 0 do
      begin
        datei_lesen(dien_puffer,datenoff+o,zeilenlaenge);
        IncDGT(o,zeilenlaenge);
        for zx:=0 to x_richtung-1 do
          begin
            case ebenen of
             1:bild[zx,zy]:=rgb_tauschtabelle[(dien_puffer.d[zx shr 3] shr (7-(zx and 7))) and $1];
             2:bild[zx,zy]:=rgb_tauschtabelle[(dien_puffer.d[zx shr 2] shr (3-(zx and 3))) and $3];
             4:
               if Odd(zx) then
                 bild[zx,zy]:=rgb_tauschtabelle[dien_puffer.d[zx shr 1] and $f]
               else
                 bild[zx,zy]:=rgb_tauschtabelle[dien_puffer.d[zx shr 1] shr  4];
             8:
               bild[zx,zy]:=rgb_tauschtabelle[dien_puffer.d[zx]];
            24:
               bild[zx,zy]:=
                 rgb(dien_puffer.d[zx*3+2],
                     dien_puffer.d[zx*3+1],
                     dien_puffer.d[zx*3  ]);
            end;
          end;
      end;



    (* Negativpunkte *)
    if ico_oder_bmp<>2 then
      if ico_laenge>o then
        for zy:=y_richtung-1 downto 0 do
          begin
            datei_lesen(dien_puffer,datenoff+o,zeilenlaenge_maske);
            IncDGT(o,zeilenlaenge_maske);

            for zx:=0 to x_richtung-1 do
              if odd( dien_puffer.d[zx shr 3] shr (7-(zx and $7))) then
                bild[zx,zy]:=windws_ico_farbe;

          end;

    schreibe_bild(x_richtung,y_richtung,windws_ico_farbe);

  end;

(* 1=ico 2=cur 1/2 -> 1/3 *)
procedure windows_ico(const anzahl:word_norm;ico_cur:byte);
  var
    zaehler             :word_norm;
    o                   :longint;
  begin
    if not ico_anzeige then Exit;

    for zaehler:=1 to anzahl do
      begin
        o:=x_longint__datei_lesen(analyseoff+2+$10*zaehler);
        windows_ico1(analyseoff+o,{einzel_laenge-o}
          x_longint__datei_lesen(analyseoff+$10*zaehler-$10+6+8),false,ico_cur*2-1);
      end;
  end;

const
  name_oder_import:array[false..true] of spaltenplatz
    =(anstrich,absatz);

procedure tpu_system(const p:puffertyp);
  var
    compilername        :string;
    compilerversion     :string;
    zielsystem          :string;
    o                   :dateigroessetyp;
    erweitertet_unterstuetzt:
      (nicht_erweitertet_unterstuetzt,
       erweitert_tp6,
       erweitert_tp7);
  const
    tpu_namen_id:array[Low(erweitertet_unterstuetzt)..High(erweitertet_unterstuetzt)] of Char
      =('-',
        'Y',  (* 6.0 *)
        'S'); (* 7.0 *)

  procedure bestimme_zielsystem;
    begin
      case word_z(@p.d[$2f])^ and $3 of
        $0:zielsystem:=' [Real Mode]';
        $1:zielsystem:=' [Protected Mode]';
        $2:zielsystem:=' [Windows,OS/2]';
        $3:zielsystem:=' [???]';
      end;
    end;

  procedure inc_einzellaenge(const w);
    begin
      IncDGT(einzel_laenge,(word_z(@w)^+15) and $fff0);
    end;

  begin
    zielsystem:='';
    erweitertet_unterstuetzt:=nicht_erweitertet_unterstuetzt;

    if p.d[0]=Ord('T') then (* TPU* *)
      begin
        compilername:='Turbo / Borland Pascal ';
        case chr(p.d[3]) of
         '0':compilerversion:='4.0';
         '5':compilerversion:='5.0'; (* Alexx *)
         '6':compilerversion:='5.5';
         '9':
           begin
             compilerversion:='6.0 + TPW 1.0';
             bestimme_zielsystem;
             erweitertet_unterstuetzt:=erweitert_tp6;
           end;
         'Q':
           begin
             compilerversion:='7.0 + TPW 1.5';
             bestimme_zielsystem;
             erweitertet_unterstuetzt:=erweitert_tp7;
           end;
        else
             compilerversion:='?.?'
        end;
      end;

    if p.d[0]=Ord('D') then (* DCU* *)
      begin
        compilername:='Borland Pascal ';
        if p.d[3]=Ord('1') then
          compilerversion:='8.0'
        else
          compilerversion:='8.?';
        bestimme_zielsystem;
      end;

    if p.d[0]=$df then (* DCU delphi 4 *)
      begin
        compilername:='Borland Delphi ';
        case p.d[3] of
          $0f:compilerversion:='4';
        else
              compilerversion:='?';
        end;
      end;

    ausschrift(compilername+compilerversion+' Unit'+zielsystem,compiler);

    case erweitertet_unterstuetzt of
      erweitert_tp6:
        begin
          einzel_laenge:=0;
          inc_einzellaenge(p.d[$1c]);
          inc_einzellaenge(p.d[$1e]);
          inc_einzellaenge(p.d[$22-2]);
          inc_einzellaenge(p.d[$24-2]);
          inc_einzellaenge(p.d[$26-2]);
        end;

      erweitert_tp7:
        begin
          einzel_laenge:=0;
          inc_einzellaenge(p.d[$1e]); (* Kopf + Verwaltung *)
          inc_einzellaenge(p.d[$20]); (* ? test.tpu *)
          inc_einzellaenge(p.d[$22]); (* Code *)
          inc_einzellaenge(p.d[$24]); (* Daten *)
          inc_einzellaenge(p.d[$26]); (* Zeilen? *)
          inc_einzellaenge(p.d[$28]); (* ? Wincrt.tpw *)
        end;
    end;

    if erweitertet_unterstuetzt<>nicht_erweitertet_unterstuetzt then
      begin
        o:=0;
        repeat
          datei_lesen(dien_puffer,analyseoff+word_z(@p.d[$8])^+o,30);
          if dien_puffer.d[2]<>Ord(tpu_namen_id[erweitertet_unterstuetzt]) then break;
          ausschrift_x(puffer_zu_zk_pstr(dien_puffer.d[3]),beschreibung,name_oder_import[o<>0]);
          case erweitertet_unterstuetzt of
            erweitert_tp6:IncDGT(o,3+1+dien_puffer.d[3]+8);
            erweitert_tp7:IncDGT(o,3+1+dien_puffer.d[3]+9);
          end;
        until false;
      end;
  end;

procedure vpi_system(const p:puffertyp);
  var
    o                   :dateigroessetyp;
    z                   :longint;
  begin
    ausschrift('Virtual Pascal Unit '+textz_vorcompiliert^,compiler);
    if p.d[3]=Ord('3') then(* 1.10,2.0b1 *)
      begin
        z:=0;
        o:=word_z(@p.d[$10])^;
        repeat
          datei_lesen(dien_puffer,analyseoff+o,80);
          ausschrift_x(puffer_zu_zk_pstr(dien_puffer.d[5]),beschreibung,name_oder_import[z<>0]);
          o:=longint_z(@dien_puffer.d[6+dien_puffer.d[5]+4])^;
          Inc(z);
        until o=0;
      end;
  end;

procedure obj(const obj_puffer:puffertyp);
  var
    obj_titel           :string;
    b1                  :word_norm;
    position,
    test_position       :longint;
    pruefsumme          :byte;
  begin
    (* COFF? *)
    if bytesuche(obj_puffer.d[0],#$4c#$01) then
      begin
        ausschrift('COFF-OBJ',compiler);
        Exit;
      end;

    (* BZIP2 fÅr OS/2 mit EMX *)
    if bytesuche(obj_puffer.d[0],#$07#$01#$64) then
      begin
        ausschrift('a.out',compiler);
        Exit;
      end;

    (* libmagic.a *)
    if bytesuche(obj_puffer.d[0],#$7f'ELF') then
      begin
        (*ausschrift('ELF',compiler);*)
        elf(obj_puffer);
        (*elf_386(obj_puffer);*)
        Exit;
      end;

    (* OMF? *)
    if (obj_puffer.d[0]<>$80) (* "THEADR"=$80 *)
    or (word_z(@obj_puffer.d[1])^>400)
    or (word_z(@obj_puffer.d[1])^<obj_puffer.d[3]+2) (* reciht nicht fÅr Modulnamen *)
     then Exit;

    (* wenn PrÅfsumme vorhanden mu· Sie auch stimmen *)
    if obj_puffer.d[word_z(@obj_puffer.d[1])^+2]<>0 then
      begin
        pruefsumme:=0;
        for position:=0 to word_z(@obj_puffer.d[1])^+2 do
          Inc(pruefsumme,obj_puffer.d[position]);

        if pruefsumme<>0 then
          Exit;
      end;

    obj_titel:=' "'+puffer_zu_zk_pstr(obj_puffer.d[$03])+'"';

    if bytesuche(obj_puffer.d[0],#$80#$04#$00#$02#$3A#$3A#$06#$96#$08#$00#$00#$04'CODE'#$00#$43#$98#$07) then
      begin
        ausschrift('OMF-OBJ (Borland BINOBJ) "'+puffer_zu_zk_pstr(obj_puffer.d[$21])+'"',compiler);
      end
    else
      begin
        b1:=word_z(@obj_puffer.d[1])^+3;
        case obj_puffer.d[b1] of
          $96:
            if puffer_pos_suche(obj_puffer,'.MOD',18)<>nicht_gefunden then
              ausschrift('OMF-OBJ Modula 2 / [JPI,CLARION]',compiler)
            else
              if (puffer_pos_suche(obj_puffer,'.asm',18)<>nicht_gefunden)
               or (puffer_pos_suche(obj_puffer,'.Asm',18)<>nicht_gefunden)
               or (puffer_pos_suche(obj_puffer,'.ASM',18)<>nicht_gefunden) then
                ausschrift('OMF-OBJ '+textz_dien__unbekannter_Assembler^+obj_titel,compiler)
              else
                ausschrift((* textz_dien__unbestimbare_OBJ_Form^+' ¯'*)'OMF-OBJ '+obj_titel,compiler);
          (* TopSpeed,Borland *)
          $88:
            begin
              exezk:=puffer_zu_zk_l(obj_puffer.d[b1+5],obj_puffer.d[b1+1]-3);
              if exezk[0]=succ(exezk[1]) then
                delete(exezk,1,1);
              exezk:=filter(exezk);
              if exezk='0sO' then exezk:=textz_dien__unbestimbare_OBJ_Form^+' ¯';
              if exezk[1]='J' then
                ausschrift('OMF-OBJ '+copy(exezk,1,9)+' [M2]'+obj_titel,compiler)
              else
                ausschrift('OMF-OBJ '+exezk+obj_titel,compiler);
            end
        else
          exit; (* nur zufÑllig mit $80 angefangen *)
        end;
      end;

    if not langformat then exit;

    position:=0;
    repeat
      datei_lesen(dien_puffer,analyseoff+position,3);
      if dien_puffer.d[0]=0 then break;
      Inc(position,word_z(@dien_puffer.d[1])^+3);
    until position>=einzel_laenge;

    if position<einzel_laenge then
      begin
        test_position:=((position+lib_page_size-1) div lib_page_size)*lib_page_size;

        (* einzel_laenge bei lib-Hauptverzeichnis nicht anpassen *)
        if analyseoff+test_position=lib_lib_start then exit;

        if test_position<einzel_laenge then
          begin
            datei_lesen(dien_puffer,analyseoff+test_position,3);
            (* end of obj? *)
            if dien_puffer.d[0]=$F1 then
              exit;
            if dien_puffer.d[0]=$80 then
              position:=test_position;
          end;
      end;

    einzel_laenge:=position;
  end;

procedure lib(const p:puffertyp);
  begin
    ausschrift(textz_dien__OBJ_Bibliothek_Kopf^,compiler);
    lib_page_size:=word_z(@p.d[1])^+3;
    einzel_laenge:=lib_page_size;
    datei_lesen(dien_puffer,analyseoff+einzel_laenge,16);
    if dien_puffer.d[0]=$f1 then (* MSLEND *)
      IncDGT(einzel_laenge,3+word_z(@dien_puffer.d[1])^);
    lib_lib_start:=analyseoff+(longint_z(@p.d[3])^ and $ffffff);
    (* weitere Untersuchung in typ_dien.obj *)
    merke_position(lib_lib_start,datentyp_libindex); (* dort folgt MSLIBR index *)
    merke_position(lib_lib_start+(word_z(@p.d[7])^*512),datentyp_unbekannt); (* Anzahl Blîcke *)
  end;

procedure hackstop(const ver:string);
  var
    o                   :dateigroessetyp;
    p,w1,w2             :word_norm;

  begin
    ausschrift('Hackstop / Ralp Roth ['+ver+']',packer_exe);

    if not langformat then exit;

    if einzel_laenge>2100 then
      o:=einzel_laenge-2100
    else
      o:=0;
      repeat
        datei_lesen(dien_puffer,analyseoff+o,512);
        p:=puffer_pos_suche(dien_puffer,#$e9'??'#13#10#13#10,500);
        if p<>nicht_gefunden then
          begin
            ansi_anzeige(analyseoff+o+p+3,'SQ',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,
            analyseoff+o+p+word_z(@dien_puffer.d[p+1])^,'');
            break;
          end;
        p:=puffer_pos_suche(dien_puffer,#$eb'??'#$c3#13#10#13#10,500);
        if p<>nicht_gefunden then
          begin
            ansi_anzeige(analyseoff+o+p+4,'PU',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,
            analyseoff+o+p+word_z(@dien_puffer.d[p+1])^,'');
            break;
          end;
        p:=puffer_pos_suche(dien_puffer,#13#10#13#10'Hack?top',500); (* HackStop/Hackstop .. *)
        if p=nicht_gefunden then (* "DarkStop" *)
          p:=puffer_pos_suche(dien_puffer,#13#10#13#10#$c4#$cd'(N',500);
        if p<>nicht_gefunden then
          begin
            IncDGT(o,p);
            datei_lesen(dien_puffer,analyseoff+o,512);
            w2:=puffer_pos_suche(dien_puffer,#$1e#$16#$51,500);
            w1:=puffer_pos_suche(dien_puffer,#$1e#$16#$52#$53,500);
            if (w2=nicht_gefunden) or (w1<w2) then
              w2:=w1;
            w1:=puffer_pos_suche(dien_puffer,#$16#$52#$53#$1e,500); (* BOTSTLTH.COM *)
            if (w2=nicht_gefunden) or (w1<w2) then
              w2:=w1;
            w1:=puffer_pos_suche(dien_puffer,#$4c#$12#$74,500); (* DarkStop *)
            if (w2=nicht_gefunden) or (w1<w2) then
              w2:=w1;

            if w2=nicht_gefunden then
              ansi_anzeige(analyseoff+o,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,
                unendlich,'')
            else
              ansi_anzeige(analyseoff+o,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,
                analyseoff+o+w2,'');
            break;
          end;

        IncDGT(o,300);
      until o>=einzel_laenge;

  end;

procedure crackstop(const o:dateigroessetyp);
  var
    w1:word_norm;
  begin
    datei_lesen(dien_puffer,analyseoff+o-512,512);
    w1:=puffer_pos_suche(dien_puffer,'CrackStop v',500);
    if w1<>nicht_gefunden then
      ansi_anzeige(o-512+w1,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,o,'');
  end;

procedure wpc(const wpc_puffer:puffertyp);
  var
    attr:aus_attribute;
  begin
    with wpc_puffer do
      begin
        attr:=bibliothek;
        case d[$09] of
          1:exezk:='Macro';
          2:exezk:=textz_dien__Hilfedatei^;
          3:exezk:=textz_dien__Tastaturdefinition^;
          4..9:exezk:='???';
          10:begin exezk:=textz_dien__Dokument^;attr:=musik_bild;end;
          11:exezk:=textz_dien__Woerterbuch^;
          12:exezk:=textz_dien__Rechtschreibpruefung^;
          13:exezk:=textz_dien__Block^;
          14:exezk:=textz_dien__Rechteck_Block^;
          15:exezk:=textz_dien__Spalten_Block^;
          16:exezk:=textz_dien__Druckerdatei^+' .PRS';
          17:exezk:=textz_dien__Einstellungsdatei^;
          18:exezk:='(prefix information file)';
          19:exezk:=textz_dien__Druckerdatei^+' .ALL';
          20:exezk:='(Display Resource File .DRS)';
          21:exezk:='Overlay';
          22:begin exezk:=textz_dien__Grafik^;attr:=musik_bild;end;
          23:exezk:='(Hypenation Code '+textz_Modul^+')';
          24:exezk:='(Hypenation Data '+textz_Modul^+')';
          25:exezk:='(Macro Resource File (MRS))';
          26:exezk:=textz_dien__Grafik_Bildschirmtreiber^;
          27:exezk:='(Hypenation Lex '+textz_Modul^+')';
          (* selbst gefunden *)
          36:exezk:='VGA/VESA';
        else
          exezk:=textz_dien__Typ^+str0(d[$09]);
        end;


        ausschrift('Word Perfect ['+str0(d[$0a]+4)+'.'+str0(d[$0b])+'] '+exezk,attr);
      end;
  end;

procedure codeview(const p:puffertyp;const i:word_norm;const spalte:spaltenplatz);
  var
    v:byte;
  begin
    v:=p.d[i+2]*10+p.d[i+3]-Ord('0')*11;
    case v of (* OMF/LX Doku (OMF.INF) *)
      0:exezk:='Codeview [32] / MS';
      1:exezk:='AIX';
      2:exezk:='Codeview [16] / MS';
      4:exezk:='OS/2 PM [32] / IBM'
    else
        exezk:='? ('+puffer_zu_zk_l(p.d[i],4)+')'
    end;

    if bytesuche(p.d[i+$10],#$fb#$52) then
      exezk:='TLink / Borland'+version_x_y(p.d[i+$13],p.d[i+$12]);

    ausschrift_x(exezk+'  '+textz_dien__Debug_Informationen^,bibliothek,spalte);
    if (v>=10) and (einzel_laenge>$10) and (einzel_laenge<255) then
      begin
        exezk:=puffer_zu_zk_e(p.d[$10],#0,DGT_zu_longint(einzel_laenge)-10);
        if Pos(':\',exezk)=2 then
          ausschrift_x(exezk,beschreibung,absatz);
      end;
  end;


(* siehe typ_for1.pas *)
function teste_lha_kopf(const o:dateigroessetyp):boolean;
  var
    p:puffertyp;
    i:word_norm;
    s:byte;
  begin
    teste_lha_kopf:=false;
    datei_lesen(p,o,512);
    if (p.d[0]<$15) or (p.d[0]>$80) then Exit;
    s:=0;
    for i:=2 to p.d[0]-1 do
      Inc(s,p.d[i]);
    teste_lha_kopf:=s=p.d[1];
  end;



procedure rom_modul(var r:puffertyp;const posi:dateigroessetyp;const zusatz:string;var einzel_laenge:dateigroessetyp);
  var
    sprung_pos          :smallword;
    sprung_weite        :smallword;
    pcir_puffer         :puffertyp;
    klartext            :puffertyp;
    position,weiter     :word_norm;
    max_ip              :word_norm;
    pcir,pnp            :word_norm;
    anzahl_gefunden     :word_norm;
    gefunden            :dateigroessetyp;
    pci_hersteller      :word_norm;

  procedure loesche_klartext(const p,l:word_norm);
    var
      z:word_norm;
    begin
      for z:=p+0 to p+l-1 do
        if z<klartext.g then
          klartext.d[z]:=0;
    end;

  procedure nur_klartext_belassen;
    var
      zaehler:word_norm;
    begin
      with klartext do
        begin
          (* sauberer Abschlu· *)
          d[High(d)]:=0;

          if g=0 then exit;

          for zaehler:=1 to g-1 do
            if d[zaehler] in [0..8,11,12,14..31,127..255] then
              d[zaehler]:=0;

          for zaehler:=2 to g-1 do
            if (d[zaehler] in [13,10]) and (d[zaehler-2]=0) then
              begin
                d[zaehler-1]:=0;
                d[zaehler  ]:=0;
              end;

          for zaehler:=g-1 downto 2 do
            if (d[zaehler-2] in [13,10]) and (d[zaehler]=0) then
              begin
                d[zaehler-1]:=0;
                d[zaehler-2]:=0;
              end;

        end;
    end;

  function klartextanzeige(const suchfolge:string;const mindestlaenge:word_norm):boolean;
    var
      position          :word_norm;
      zk                :string;
    begin
      position:=0;
      with klartext do
        while position+2<g do
          begin
            if (d[position]=0) and (d[position+1]<>0) then
              begin
                zk:=puffer_zu_zk_e(d[position+1],#0,255);
                if  (Pos(suchfolge,zk)<>0)
                and (Length(zk)>=mindestlaenge) then
                  begin
                    loesche_klartext(position+1,Length(zk));
                    ausschrift_x(zk,beschreibung,absatz);
                    klartextanzeige:=true;
                    Exit;
                  end;
              end;
            Inc(position);
          end;
      klartextanzeige:=false;
    end;

  function klartextdatum_anzeige:boolean;
    var
      position          :word_norm;
      zk                :string;
    begin
      klartextdatum_anzeige:=false;
      position:=0;
      with klartext do
        while position+20<g do
          begin
            (* SIS 6326 *)
            if  bytesuche(d[position],'??/??/????-??:??:??')
            and (d[position+6] in [Ord('1'),Ord('2')]) then
              begin
                ausschrift_x(puffer_zu_zk_l(d[position],Length('??/??/????-??:??:??')),beschreibung,absatz);
                loesche_klartext(position,Length('??/??/????-??:??:??'));
                klartextdatum_anzeige:=true;
                Exit;
              end;

            (* ATI *)
            if  bytesuche(d[position],'????/??/?? ??:??'#$00)
            and (d[position+0] in [Ord('1'),Ord('2')]) then
              begin
                ausschrift_x(puffer_zu_zk_l(d[position],Length('????/??/?? ??:??')),beschreibung,absatz);
                loesche_klartext(position,Length('????/??/?? ??:??'#$00));
                klartextdatum_anzeige:=true;
                Exit;
              end;

            (* WESTERN DIGITAL *)
            if  bytesuche(d[position],'??/??/??-??:??:??'#$00)
            and (d[position+0] in [Ord('0')..Ord('3')])
            and (d[position+9] in [Ord('0')..Ord('2')]) then
              begin
                ausschrift_x(puffer_zu_zk_l(d[position],Length('??/??/??-??:??:??')),beschreibung,absatz);
                loesche_klartext(position,Length('??/??/??-??:??:??'));
                klartextdatum_anzeige:=true;
                Exit;
              end;


            Inc(position);

          end;
    end;

  var
    w1,w2:word_norm;
  begin

    einzel_laenge:=longint(r.d[2])*512;
    ausschrift('ROM-'+textz_Modul^+zusatz+' ('
      (*$IfDef dateigroessetyp_comp*)
      +str0_DGT(DivDGT(einzel_laenge,1024))
      (*$Else*)
      +str0(einzel_laenge div 1024)
      (*$EndIf*)
      +' K)',bibliothek);

    klartext:=r;
    position:=0;
    loesche_klartext(position,3);
    Inc(position,3);

    if (klartext.d[position] in [$00,$f8,$fc])
    and bytesuche(klartext.d[position+3+3],#$eb)
     then (* OS/2 ABIOS ROM *)
      Inc(position,3+3);

    max_ip:=position;
    repeat

      max_ip:=Max(position,max_ip);

      case klartext.d[position] of
        $cb: (* SIS VGA *)
          begin
            loesche_klartext(position,1);
            Inc(position,1);
            Break;
          end;

        $e8: (* SIS VGA *)
          begin
            weiter:=(position+1+2+word_z(@klartext.d[position+1])^) and $ffff;
            loesche_klartext(weiter,1);
            loesche_klartext(position,1+2);
            Inc(position,1+2);
          end;

        $e9:
          begin
            weiter:=(position+1+2+word_z(@klartext.d[position+1])^) and $ffff;
            loesche_klartext(position,1+2);
            position:=weiter;
          end;

        $eb:
          begin
            weiter:=(position+1+1+klartext.d[position+1]) and $ffff;
            loesche_klartext(position,1+1);
            if klartext.d[position]=$90 then
              loesche_klartext(position+2,1);
            position:=weiter;
          end;

        else
          loesche_klartext(position,1);
          Break;
        end;

    until position+3>klartext.g;


    (* Chips and Technologies *)
    if bytesuche(klartext.d[5],'7400') then
      begin
        weiter:=5;
        loesche_klartext(weiter,Length('7400'));
        Inc(weiter,Length('7400'));
        if bytesuche(klartext.d[weiter],'00') then (* Datum '05/01/93' im WD VGA ROM *)
          while (weiter<klartext.g) and (klartext.d[weiter]=Ord('0')) do
            begin
              loesche_klartext(weiter,Length('0'));
              Inc(weiter,Length('0'));
            end;

      end;


    pcir:=word_z(@r.d[$18])^; (* PCIR *)
    pnp :=word_z(@r.d[$1a])^; (* $PnP *)

    if (pcir<$18+2) or (pcir>einzel_laenge) then pcir:=0; (* SIS VGA ROM: -> $1A *)
    if (pnp <$18+4) or (pnp >einzel_laenge) then pnp :=0;

    pci_hersteller:=0;

    if pcir<>0 then
      begin
        datei_lesen(pcir_puffer,analyseoff+pcir,4+4);
        if not bytesuche(pcir_puffer.d,'PCIR') then
          pcir:=0
        else
          begin

            if pcir=$1a then
              pnp:=0;

            ausschrift('PCI: '+hex_word(word_z(@pcir_puffer.d[4+0])^)+':'+hex_word(word_z(@pcir_puffer.d[4+2])^),beschreibung);

            pci_hersteller:=word_z(@pcir_puffer.d[4+0])^;

            loesche_klartext($18,2);
            loesche_klartext(pcir,8);

            if pnp<>0 then
              begin
                datei_lesen(pcir_puffer,analyseoff+pnp,4+2);
                if bytesuche(pcir_puffer,'$PnP') then
                  begin
                    loesche_klartext($1a,2);
                    loesche_klartext(pnp,4+2);
                  end
                else
                  pnp:=0;

              end;
          end;
      end;

    nur_klartext_belassen;

    if signaturen then
      signatur_anzeige('',klartext);

    (* Trident *)
    if bytesuche(klartext.d[$0d],'**RESERVED ????R IBM COMPATIBILITY **') then
      loesche_klartext($0d,Length('**RESERVED ????R IBM COMPATIBILITY **'));

    (* chips: durch PCIR zerbrochene 7400000 - Kette *)
    if bytesuche(klartext.d[$1c],'00IBM') then
      loesche_klartext($1c,Length('00'));

    (* S3 *)
    if bytesuche(klartext.d[$1e],'IBM VGA Compatible BIOS')
    or bytesuche(klartext.d[$1e],'IBM VGA COMPATIBLE BIOS') then
      loesche_klartext($1e,Length('IBM VGA Compatible BIOS'));

    (* WD/PARADISE *)
    if bytesuche(klartext.d[$1e],'IBM COMPATIBLE ') then
      loesche_klartext($1e,Length('IBM COMPATIBLE '));


    (* ATI *)
    if bytesuche(klartext.d[$1d],#$00'IBM'#$00) then
      loesche_klartext($1d,Length(#$00'IBM'#$00));

    anzahl_gefunden:=0;
    while klartextanzeige('Tseng La',20) do
      Inc(anzahl_gefunden);
    if Bytesuche(klartext.d[$31],'761295520') then
      while klartextanzeige('ATI',12) do
        Inc(anzahl_gefunden);
    while klartextanzeige('VGA',12) do
      Inc(anzahl_gefunden);
    while klartextanzeige('Video BIOS',20) do (* S3[TOSHIBA] *)
      Inc(anzahl_gefunden);
    while klartextanzeige('SCSI BIOS',20) do (* NCR *)
      Inc(anzahl_gefunden);
    while klartextanzeige('Service',20) do (* INTEL LAN *)
      Inc(anzahl_gefunden);
    while klartextanzeige(' BIOS:',18) do (* Adaptec *)
      Inc(anzahl_gefunden);
    while klartextanzeige('Copyr',20) do
      Inc(anzahl_gefunden);
    while klartextanzeige('COPYR',20) do
      Inc(anzahl_gefunden);
    while klartextdatum_anzeige do
      Inc(anzahl_gefunden);
    while klartextanzeige('BIOS Ver ',Length('BIOS Ver 1.26')) do (* SIS 6326 *)
      Inc(anzahl_gefunden);
    while klartextanzeige('version',15) do (* INTEL LAN *)
      Inc(anzahl_gefunden);

    if klartextanzeige('Memory Error',10) (* Adaptex: LHA *)
    or klartextanzeige('BIOS expand',10)
    or (pci_hersteller=$9004) (* Adaptec *)
    or (pci_hersteller=$9005) (* Adaptec *)
     then
      begin
        Inc(anzahl_gefunden);
        gefunden:=analyseoff+2;
        repeat
          gefunden:=datei_pos_suche(gefunden,analyseoff+einzel_laenge,'-lh5-');
          if gefunden=nicht_gefunden then Break;
          if teste_lha_kopf(gefunden-2) then (* fÅr ADPTAdaptec AIC-7902 SCSI BIOS v4.25 notwendig *)
            begin
              einzel_laenge:=gefunden-analyseoff-2;
              Break;
            end;
          IncDGT(gefunden,1);
        until gefunden>=analyseoff+einzel_laenge;
      end;

    if anzahl_gefunden>0 then Exit;

    (* SIS ohne vernÅnftige Ziehcnkette im Kopf, ATI MACH64 wÅrde auch gehen *)
    gefunden:=analyseoff;
    repeat
      gefunden:=datei_pos_suche(gefunden+1,analyseoff+einzel_laenge,'VESA');
      if gefunden=nicht_gefunden then Break;
      datei_lesen(pcir_puffer,gefunden,4+2+4);
      w1:=word_z(@pcir_puffer.d[4])^;
      w2:=word_z(@pcir_puffer.d[4+2])^;
      if (Hi(w1) in [1..5]) (* 1..3 *)
      and (w2<>0)  and (w2<einzel_laenge) then
        begin
          datei_lesen(pcir_puffer,analyseoff+w2,512);
          ausschrift('VESA'+version_x_y(Hi(w1),Lo(w1))+' : '+puffer_zu_zk_e(pcir_puffer.d[0],#0,80),beschreibung);
          Exit;
        end;
    until false;

    (*$IfNDef ENDVERSION*)
    (*signatur_anzeige('',klartext);*)
    poly_emulator(poem_modus_rom);
    (*$EndIf*)

  end;

procedure bild_format_filter(const format:string;const x,y:longint;f:longint;fbit:shortint;
                             const unsicher,sicher:boolean;const anfang:spaltenplatz);
  var
    erg                 :string;
    attribut            :aus_attribute;
    t                   :longint;
    b                   :byte;
  begin
    if ((x>1024*4)
    or (y>1024*4)
    or (f>1 shl 24)
    or (x<1)
    or (y<1)
    or (f<-1)
    or (f=0)
    or (unsicher and ((x div 10>y) or (y div 10>x))))
    and (not sicher)
     then
      begin
        (*$IfNDef ENDVERSION*)
        Dec(herstellersuche);
        ausschrift_x('mîglicherweise: '+format,virus,anfang);
        Inc(herstellersuche);
        (*$EndIf*)
      end
    else
      begin

        if format<>'' then
          erg:=format+' '
        else
          erg:='';

        erg:=erg+str0(x)+' * '+str0(y);

        if (fbit>0) and (fbit<15) then
          f:=1 shl longint(fbit);

        t:=f;
        b:=0;
        while (t>0) and (not Odd(t)) do
          begin
            Inc(b);
            t:=t shr 1;
          end;

        if b>=15 then
          begin
            f:=-1;
            fbit:=b;
          end;

        if f<>-1 then
          erg:=erg+textz_dien__leerleer_Farben_doppelpunkt_leer^+str0(f)
        else
          if fbit<>-1 then
            erg:=erg+textz_dien__leerleer_Farben_doppelpunkt_leer^+'2^'+str0(fbit);

        attribut:=musik_bild;
        if erg[1]='%' then (* typ_eas *)
          begin
            attribut:=beschreibung;
            Delete(erg,1,1);
          end;

        ausschrift_x(erg,attribut,anfang);
      end;
  end;

procedure c_kommentar;
  var
    versuch             :word_norm;
    exe_name            :dateigroessetyp;
    w1,w2,w3            :word_norm;
    rexx_modus          :(rexx_anweisung,kommentar_ein,kommentar);
    lesen,schreiben     :word_norm;
    dienpuffer_gross    :puffertyp;
  begin
    for versuch:=1 to 10 do (* 10*400=4000 mu· reichen *)
      begin
        datei_lesen(dien_puffer,analyseoff+(versuch-1)*400,512);
        if dien_puffer.g=0 then break;

        (* mit REXXC Åbersetzt *)
        w1:=puffer_pos_suche(dien_puffer,'/*OBJREXX*/@REXX'#$00'g+',132);
        if w1<>nicht_gefunden then
          begin
            ausschrift_rexx(puffer_zu_zk_e(dien_puffer.d[$15],#0,$31));
            Exit;
          end;


        puffer_gross(dien_puffer,dienpuffer_gross);

          w1:=puffer_pos_suche(dienpuffer_gross,'RCINCLUDE ',400);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche(dienpuffer_gross,'.PTR',500);

        if w1<>nicht_gefunden then
          begin
            ausschrift('Resource Compiler '+textz_dien__Quelltext^,signatur);
            Exit;
          end;



        w1:=puffer_pos_suche(dienpuffer_gross,'#INCLUDE <',400);
        if w1<>nicht_gefunden then
          Break; (* C-Quelltext *)

        w1:=puffer_pos_suche(dienpuffer_gross,'/* XPM */',40);
        if w1<>nicht_gefunden then
          begin
            ausschrift('Sun Icon C-Code XPM',musik_bild);
            Exit;
          end;

          w1:=puffer_pos_suche(dienpuffer_gross,'RXFUNCADD',500);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche(dienpuffer_gross,'SYSLOADFUNCS',500);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche(dienpuffer_gross,'REXX',500); (* RxFuncAdd *)
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche(dienpuffer_gross,'SIGNAL ON',500);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche(dienpuffer_gross,'PARSE ARG',500);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche(dienpuffer_gross,'PARSE UPPER ARG ',500);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche(dienpuffer_gross,'PARSE SOURCE ',500);

        if w1<>nicht_gefunden then
          begin
            ausschrift('REXX-'+textz_dien__Stapelverarbeitungsdatei^,signatur);

            (* say "January June's REXX self-extract installer" *)
            (* say "'Yotogi-Hime's APM Monitor v0.61e' install" *)
            (* base64 im Rexx-Quelltext als Kommentar *)
            if puffer_pos_suche(dienpuffer_gross,'SELF-EXTRACT',500)<>nicht_gefunden then
              begin
                exe_name:=datei_pos_suche(analyseoff,analyseoff+10000,'octet-stream; name="');
                if exe_name<>nicht_gefunden then
                  ausschrift('  '+datei_lesen__zu_zk_e(exe_name+Length('octet-stream; name="'),'"',80)+' (base64)',packer_dat);
              end;

            (* Kommentarzeile+Leerzeile -> anzeigen *)
            datei_lesen(dien_puffer,analyseoff,512);
            rexx_modus:=rexx_anweisung;
            lesen:=0;
            schreiben:=0;
            w1:=0; (* Anzahl Zeilen Rexx-Anweisungen *)
            with dien_puffer do
              while lesen<g do
                case rexx_modus of
                  rexx_anweisung:
                    begin

                      if d[lesen]=10 then Inc(w1);
                      if w1=3 then Break;

                      if (lesen+1<g) and (d[lesen]=Ord('/')) and (d[lesen+1]=Ord('*')) then
                        begin
                          rexx_modus:=kommentar_ein;
                          Inc(lesen,Length('/*'));
                        end
                      else
                        if (d[lesen] in [10,13]) and (schreiben>0) then
                          begin
                            d[schreiben]:=d[lesen];
                            Inc(lesen);
                            Inc(schreiben);
                          end
                        else
                          Inc(lesen);

                    end;

                  kommentar_ein:
                    begin
                      if d[lesen]=Ord('*') then
                        if (lesen+1<g) and (d[lesen+1]=Ord('/')) then
                          rexx_modus:=kommentar
                        else
                          Inc(lesen)
                      else
                        rexx_modus:=kommentar;
                    end;

                  kommentar:
                    begin
                      w1:=0; (* Nicht-Kommentarzeilen zurÅcksetzen *)
                      if (lesen+1<g) and (d[lesen]=Ord('*')) and (d[lesen+1]=Ord('/')) then
                        begin
                          Inc(lesen,2);
                          rexx_modus:=rexx_anweisung;
                          while (schreiben>0) and (d[schreiben]=Ord('*')) do
                            Dec(schreiben);
                        end
                      else
                        begin

                          if (not (d[lesen] in [10,13])) or (schreiben<>0) then
                            begin
                              d[schreiben]:=d[lesen];
                              Inc(schreiben);
                            end;

                          Inc(lesen);

                          if (d[lesen-1] in [10,13]) then
                            if (lesen+1<g) and (d[lesen]=Ord(' ')) and (d[lesen+1]=Ord('*')) then
                              if (lesen+2>=g) or (d[lesen+2]<>Ord('/')) then
                                Inc(lesen,2);
                        end;
                    end;
                end; (* case rexx_modus of *)

            if schreiben>0 then
              begin
                (* erstes Zeichen wird gelîscht, wenn es ein Leerzeichen ist,
                   damit " die Spalttten nicht verschiebt *)
                if dien_puffer.d[0]=$20 then
                  exezk:=puffer_zu_zk_l(dien_puffer.d[1],Min(schreiben-1,255))
                else
                  exezk:=puffer_zu_zk_l(dien_puffer.d[0],Min(schreiben  ,255));

                (* gnu license-Teppich ist zu lang, abschneiden *)
                w1:=Pos('This program is free software; you can redistribute it and/or modify',exezk);
                if w1<>0 then SetLength(exezk,w1-1);

                (* Leerzeichen und ZeilenumbrÅche vom Ende entfernen *)
                while (exezk<>'') and (exezk[Length(exezk)] in [#9,#10,#13,' ']) do
                  DecLength(exezk);

                repeat
                  w1:=Pos(#13#10#13#10#13#10,exezk);
                  if w1=0 then Break;
                  Delete(exezk,w1,2);
                until false;

                if exezk<>'' then
                  ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
              end;


            {
            if bytesuche(dien_puffer.d[0],'/*') then
              begin
                w1:=puffer_pos_suche(dien_puffer,'*/'#$0d#$0a#$0d#$0a,400);
                if w1=nicht_gefunden then
                  w1:=puffer_pos_suche(dien_puffer,'*/'#$0d#$0a,400);
                if w1<>nicht_gefunden then
                  begin
                    exezk:=puffer_zu_zk_l(dien_puffer.d[2],Min(255,w1-2));
                    if Pos(#$0a,exezk)=0 then
                      begin
                        while (exezk<>'') and (exezk[1]='*') do Delete(exezk,1,Length('*'));
                        while (exezk<>'') and (exezk[Length(exezk)]='*') do DecLength(exezk);
                      end;
                    repeat
                      w1:=Pos('*/'#$0d#$0a,exezk);
                      if w1=0 then Break;
                      Delete(exezk,w1,Length('*/'));
                    until false;
                    repeat
                      w1:=Pos(#$0d#$0a'/*',exezk);
                      if w1=0 then Break;
                      Delete(exezk,w1+2,Length('/*'));
                    until false;
                    repeat
                      w1:=Pos(#$0d#$0a' *',exezk);
                      if w1=0 then Break;
                      Delete(exezk,w1+2,Length(' *'));
                    until false;
                    exezk:=leer_filter(exezk);
                    if exezk<>'' then
                      ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
                  end;
              end;}
            Exit;
          end;

        w1:=puffer_pos_suche(dienpuffer_gross,'USES ',500);
        w2:=puffer_pos_suche(dienpuffer_gross,'VAR'  ,500);
        w3:=puffer_pos_suche(dienpuffer_gross,':='   ,500);
        if ((w1<>nicht_gefunden) and (w2<>nicht_gefunden))
        or ((w1<>nicht_gefunden) and (w3<>nicht_gefunden))
        or ((w2<>nicht_gefunden) and (w3<>nicht_gefunden))
         then
          begin
            p_kommentar;
            if not hersteller_gefunden then
              ausschrift('Pascal-'+textz_dien__Quelltext^,signatur);
            Exit;
          end;

        if puffer_gefunden(dien_puffer,'package ')
        or puffer_gefunden(dien_puffer,'import java.') then
          begin
            ausschrift('Java '+textz_dien__Quelltext^,signatur);
            Exit;
          end;

      end;

    p_kommentar;

    if not hersteller_gefunden then
      ausschrift('C-'+textz_dien__Quelltext^,signatur);
  end;

procedure p_kommentar;
  var
    versuch             :word_norm;
    w1,w2,w3,w4,w5,w6   :word_norm;

  procedure laden;
    begin
      datei_lesen(dien_puffer,analyseoff+(versuch-1)*400,512);
    end;

  begin
    for versuch:=1 to 10 do
      begin
        laden;
        if dien_puffer.g=0 then break;

        puffer_gross(dien_puffer,dien_puffer);

        w1:=puffer_pos_suche(dien_puffer,#$0d#$0a'UNIT ',400);
        if w1<>nicht_gefunden then
          begin
            laden;
            exezk:=puffer_zu_zk_e(dien_puffer.d[w1+2+4+1],';',512-w1-5);
            if ist_ohne_steuerzeichen(exezk) then
              begin
                ausschrift('Pascal Unit "'+exezk+'"',signatur);
                exit;
              end;
          end;

        w1:=puffer_pos_suche(dien_puffer,#$0d#$0a'LIBRARY ',400);
        if w1<>nicht_gefunden then
          begin
            laden;
            exezk:=puffer_zu_zk_e(dien_puffer.d[w1+2+7+1],';',512-w1-5);
            if ist_ohne_steuerzeichen(exezk) then
              begin
                ausschrift('Pascal Library "'+exezk+'"',signatur);
                exit;
              end;
          end;

        w1:=puffer_pos_suche(dien_puffer,#$0d#$0a'PROGRAM ',400);
        if w1<>nicht_gefunden then
          begin
            laden;
            exezk:=puffer_zu_zk_e(dien_puffer.d[w1+2+7+1],';',512-w1-5);
            if ist_ohne_steuerzeichen(exezk) then
              begin
                ausschrift('Pascal Program "'+exezk+'"',signatur);
                exit;
              end;
          end;

        (* VPSYSOS2 *)
        w1:=puffer_pos_suche(dien_puffer,'FUNCTION ',400);
        w2:=puffer_pos_suche(dien_puffer,'PROCEDURE ',400);
        w3:=puffer_pos_suche(dien_puffer,'BEGIN',400);
        w4:=puffer_pos_suche(dien_puffer,'END;',400);
        w5:=puffer_pos_suche(dien_puffer,'VAR',400);
        w6:=puffer_pos_suche(dien_puffer,'IF ',400);

        if  ((w1<>nicht_gefunden) or (w2<>nicht_gefunden))
        and ((w3<>nicht_gefunden) or (w4<>nicht_gefunden))
        and ((w5<>nicht_gefunden) or (w6<>nicht_gefunden))
        then
          begin
            ausschrift('Pascal '+textz_datx__Quelltext^,signatur);
            exit;
          end;



      end;
  end;

procedure html;
  var
    p                   :puffertyp;
    o                   :dateigroessetyp;
    zk,doctype,
    doctype_org         :string;
    sguide              :boolean;
    transitional        :boolean;
    frames              :boolean;
    xhtml               :boolean;

  function doctype_loesche_vom_anfang(const s:string):boolean;
    begin
      if Copy(doctype,1,Length(s))=s then
        begin
          Delete(doctype,1,Length(s));
          doctype:=leer_filter(doctype);
          doctype_loesche_vom_anfang:=true;
        end
      else
        doctype_loesche_vom_anfang:=false;
    end;

  function doctype_loesche_vom_ende(const s:string):boolean;
    begin
      if Copy(doctype,Length(doctype)-Length(s)+1,Length(s))=s then
        begin
          SetLength(doctype,Length(doctype)-Length(s));
          doctype:=leer_filter(doctype);
          doctype_loesche_vom_ende:=true;
        end
      else
        doctype_loesche_vom_ende:=false;

    end;

  begin
    zk:='HTML';
    doctype:='';
    sguide:=false;
    transitional:=false;
    frames:=false;
    xhtml:=false;

    o:=datei_pos_suche_gross(analyseoff,analyseoff+MinDGT(einzel_laenge,200),'<!DOCTYPE HTML PUBLIC "');
    if o<>nicht_gefunden then
      begin
        doctype:=datei_lesen__zu_zk_e(o+Length('<!DOCTYPE html PUBLIC "'),'"',255);
        doctype:=gross(doctype);
        if Pos('>',doctype)<>0 then
          SetLength(doctype,Pos('>',doctype)-1);

        doctype_org:=doctype;


        (*
        4 strict
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

        4 deprecated
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

        4 deprecated+frames
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">

        3.2
        <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">

        2.0
        <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">

        ?
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <!doctype html public "-//W3C//DTD HTML 4.0 Transitional//EN"
           "http://www.w3.org/TR/REC-html40/loose.dtd">


                                                                *)

        doctype_loesche_vom_anfang('-//');

        doctype_loesche_vom_anfang('IETF//');
        doctype_loesche_vom_anfang('W3C//');
        doctype_loesche_vom_anfang('W3O//');
        doctype_loesche_vom_anfang('WEBTECHS//');
        doctype_loesche_vom_anfang('NETSCAPE COMM. CORP.//');
        doctype_loesche_vom_anfang('MICROSOFT//');

        doctype_loesche_vom_anfang('DTD');
        doctype_loesche_vom_anfang('HTML');
        xhtml:=doctype_loesche_vom_anfang('XHTML');

        doctype_loesche_vom_ende('//EN');
        doctype_loesche_vom_ende('FINAL');
        transitional:=transitional or doctype_loesche_vom_ende('TRANSITIONAL');
        frames      :=frames       or doctype_loesche_vom_ende('FRAMESET');

        if (doctype='') then
          begin
            zk:='HTML 2.0';
            doctype:='';
          end
        else
        if (doctype='1.0')
        or (doctype='2.0')
        or (doctype='3.0')
        or (doctype='3.2')
        or (doctype='4.0')
        or (doctype='4.01')
         then
          begin
            zk:='HTML '+doctype;
            if frames then
              zk:=zk+' deprecated+frameset'
            else
            if transitional then
              zk:=zk+' deprecated';
            doctype:='';
          end;

        if xhtml then
          Insert('X',zk,1);

      end; (* <!DOCTYPE *)

    if datei_pos_suche_gross(analyseoff,analyseoff+3000,'<SGUIDE')<>nicht_gefunden then
      begin
        zk:='OS/2 Smart Guide';
        sguide:=true;
      end;

    o:=datei_pos_suche_gross(analyseoff,analyseoff+5000,'<TITLE>');
    if o=nicht_gefunden then
      ausschrift(zk,musik_bild)
    else
      begin
        IncDGT(o,Length('<TITLE>'));
        datei_lesen(p,o,512);
        if sguide then
          exezk:=puffer_zu_zk_zeilenende(p.d[0],255)
        else
          exezk:=puffer_zu_zk_e(p.d[0],'</',255);
        html_filter(exezk);
        ausschrift(zk+' "'+exezk+'"',musik_bild);
      end;
    if doctype<>'' then
      ausschrift(doctype_org,beschreibung);
  end;

procedure test_shar(const p:puffertyp);
  var
    w1                  :word_norm;
  begin
    w1:=puffer_pos_suche(p,'This is a shell archive (shar',490);
    if w1=nicht_gefunden then
      w1:=puffer_pos_suche(p,'shar:'#9'Shell Archiver',490);
    if w1=nicht_gefunden then
      w1:=puffer_pos_suche(p,'shar:    Shell Archiver',490);
    if w1<>nicht_gefunden then
      ausschrift('SHAR .. Shell Archiver',packer_dat);

  end;

procedure teledisk(const l:word_norm);
  var
    o:longint;
  begin
    ausschrift(' TeleDisk / Sydex',signatur);

    if not langformat then exit;

    if l>80*25 then exit;
    o:=$16;

    repeat
      datei_lesen(dien_puffer,analyseoff+o,90);
      exezk:=puffer_zu_zk_e(dien_puffer.d[0],#0,89);
      Inc(o,Length(exezk)+1);
      ausschrift_x(exezk,beschreibung,absatz);
    until o>=$16+l;
  end;

procedure vpart1_anzeige;
  var
    posi                :word_norm;
    zaehler             :word_norm;
  begin
    datei_lesen(dien_puffer,analyseoff,512);
    posi:=16;
    if dien_puffer.d[posi] in [Ord('0'),Ord('1')] then Inc(posi);
    exezk:='';
    while dien_puffer.d[posi]<>0 do
      begin
        if dien_puffer.d[posi]=1 then
          begin
            for zaehler:=1 to dien_puffer.d[posi+1] do
              exezk_anhaengen(chr(dien_puffer.d[posi+2]));
            Inc(posi,3);
          end
        else
          begin
            exezk_anhaengen(chr(dien_puffer.d[posi]));
            Inc(posi);
          end;
        if (Length(exezk)=80) or (dien_puffer.d[posi]=0) then
          begin
            ausschrift_x(exezk,farblos,vorne);
            exezk:='';
          end;
      end;
  end;

procedure vpart_neu(const vpp:puffertyp);
  var
    w1:word_norm;
  begin
    exezk:=puffer_zu_zk_pstr(vpp.d[$50]);
    if exezk='' then
      ausschrift('""',beschreibung)
    else
      begin
        for w1:=1 to Length(exezk) do
          exezk[w1]:=chr(Ord(exezk[w1]) xor Ord('„'));
        ausschrift('"'+puffer_zu_zk_pstr(vpp.d[$50])+'" / "'+exezk+'"',beschreibung);
      end;
  end;


procedure bestimme_einzel_laenge_exelock;
  var
    msg_gefunden:dateigroessetyp;
  begin
    msg_gefunden:=datei_pos_suche(analyseoff+$e,analyseoff+60*80,#$eb#$eb'0MSG');
    if msg_gefunden<>nicht_gefunden then
      einzel_laenge:=msg_gefunden-analyseoff+$d;
  end;

procedure kopftext_anzeige(hinweis:string;const f:aus_attribute);
  begin
    if kopftextlaenge<=0 then
      begin
        if Length(hinweis)>0 then
          ausschrift(hinweis+' ""',f);
        exit;
      end;

    if kopftextlaenge<80 then
      begin
        if hinweis<>'' then
          hinweis:='  '+hinweis+'  ';

        ansi_anzeige(kopftextstart,#0,ftab.f[f,hf]+ftab.f[f,vf],
          absatz,wahr,wahr,kopftextstart+kopftextlaenge,hinweis);
      end
    else
      begin
        ausschrift(hinweis,f);
        ansi_anzeige(kopftextstart,#0,ftab.f[f,hf]+ftab.f[f,vf],
          absatz,wahr,wahr,kopftextstart+kopftextlaenge,'');
      end;

  end;

procedure kopftext_nullen;
  begin
    kopftext:='';
    kopftextlaenge:=0;
  end;

procedure suche_txt2com_titel(const o0:longint);
  var
    o                   :dateigroessetyp;
    w1                  :word_norm;
  begin
    o:=datei_pos_suche(analyseoff+o0,analyseoff+o0+$2000,'IQPH');
    if o=nicht_gefunden then
      Exit;

    IncDGT(o,10);

    datei_lesen(dien_puffer,o,512);
    w1:=0;
    while (dien_puffer.d[w1]=0) and (w1<80) do
      Inc(w1);

    if w1<80 then
      ausschrift(puffer_zu_zk_e(dien_puffer.d[w1],#0,80),beschreibung);
  end;

procedure chlib(const p:puffertyp);
  begin
    if (p.d[3]<$10) or (p.d[3]>$20) then exit;
    if word_z(@p.d[$e])^<1996 then
      exezk:=str0(p.d[$5]+1)+'.'+str0(word_z(@p.d[$6])^)
    else
      exezk:=str0(p.d[$d]+1)+'.'+str0(word_z(@p.d[$e])^);

    ausschrift('CHLib / Spyral '+textz_dien__Version^+str0(p.d[3] shr 4)+'.'+str0(p.d[3] and $f)
     +textz_dien__leer_Datum_doppelpunkt^+exezk,spielstand);
  end;

procedure avatar; (* A3E *)
  var
    o                   :longint;
    xp,yp               :byte;
    farbe               :byte;
    zaehler             :byte;
    bild_puffer         :bild_puffer_typ;

  procedure zeichen(var x,y:byte;f,z:byte);
    begin
      if (x>=1) and (x<=80) and (y>=1) and (y<=25) then
        begin
          bild_puffer[y][x][1]:=z;
          bild_puffer[y][x][2]:=f;
        end;
      if x<255 then
        Inc(x);
    end;

  begin
    ausschrift('Avatar / George A. Stanislav + Wynn Wagner III',musik_bild);
    if not langformat then exit;

    o:=1;
    xp:=1;
    yp:=1;
    FillChar(bild_puffer,SizeOf(bild_puffer),0);

    repeat
      datei_lesen(dien_puffer,o,2+2);
      if dien_puffer.g=0 then break;

      case dien_puffer.d[0] of
        $12:;
        $16:
          begin
            Inc(o,2);
            case dien_puffer.d[1] of
              $01:
                begin
                  farbe:=dien_puffer.d[2];
                  Inc(o);
                end;
              $08:
                begin
                  xp:=dien_puffer.d[3];
                  yp:=dien_puffer.d[2];
                  Inc(o,2);
                end;
              else
                {}
              end;
          end;
        $19:
          begin
            for zaehler:=1 to dien_puffer.d[2] do
              zeichen(xp,yp,farbe,dien_puffer.d[1]);
            Inc(o,3);
          end;
        else
          begin
            zeichen(xp,yp,farbe,dien_puffer.d[0]);
            Inc(o);
          end;
      end;
    until o>=einzel_laenge;

    for zaehler:=1 to 25 do
      schreibe_zeile(bild_puffer[zaehler]);

  end;

function ende_ausschrift(rueckwaerts:word_norm;kennung:string):boolean;
  var
    p:puffertyp;
  begin
    ende_ausschrift:=false;
    datei_lesen(p,analyseoff+einzel_laenge-rueckwaerts,rueckwaerts);
    if not bytesuche(p.d[0],kennung) then Exit;

    exezk:=puffer_zu_zk_e(p.d[0],#0,rueckwaerts);
    if Pos('MsDos',exezk)<>0 then Delete(exezk,Pos('MsDos',exezk),Length('MsDos'));
    while Pos('˛',exezk)<>0 do exezk[Pos('˛',exezk)]:=' ';
    exezk:=leer_filter(exezk);
    ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
    ende_ausschrift:=true;
  end;

procedure rscc_endekennung;
  begin
    if not ende_ausschrift(7,'RSCC1') then (* 1.04 *)
      if not ende_ausschrift(5,'1.4.4') then
        if not ende_ausschrift(8,'rscc1.') then (* 1.20 *)
  end;

procedure rcc_test(const ip_neu:smallword);


  procedure rcc286(const version:string);
    begin
      ausschrift('RC286 / Ralph Roth ['+version+']',packer_exe);
      if not ende_ausschrift(17,'RCC-II˛1.') then (* 1.02 *)
        if not ende_ausschrift(9,'RCC˛1.') then (* 1.12m *)
          if not ende_ausschrift(8,'RCC1.??h') then (* 1.17 *)
            if not ende_ausschrift(8,'RCC1.??m') then (* 1.17 *)
              if not ende_ausschrift(5,'1.??h') then (* 1.18 *)
                 if not ende_ausschrift(5,'1.??m') then (* 1.18 *)
                   if not ende_ausschrift(7,'1.??.?h') then (* 1.18.2 *)
                     if not ende_ausschrift(7,'1.??.?m') then (* 1.18.2 *)
    end;

  begin
    datei_lesen(dien_puffer,analyseoff+longint(codeoff_seg)*16+ip_neu,$80);

    if bytesuche(dien_puffer.d[0],#$87#$e5#$83#$c4#$16#$87#$e5) then
      begin
        hackstop('1.00 COM'); (* 1.10.ST *)
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$87#$e5#$83#$c4) then
      begin
        hackstop('1.10..13 COM'); (* 1.10a1,1.13·s *)
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$87#$e3#$83#$c4#$16#$83#$c4#$16#$87#$e3) then
      begin
        hackstop('1.14 COM'); (* CUNP016.COM im Archiv CUNP 0.17 *)
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$87#$e6#$83#$c4) then
      begin
        hackstop('1.15 COM');
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$3a#$c0#$74#$0b) then
      begin
        hackstop('1.17 COM'); (* 1.17 und 1.17/386 *)
        Exit;
      end;

    { Wahrscheinlich 109
    if bytesuche(dien_puffer.d[0],#$52#$b8#$00#$30) then
      begin
        ausschrift('RC286 / Ralph Roth [1.??]',packer_exe); (* CGL0997 *)
        goto hs_gefunden;
      end;}

    if bytesuche(dien_puffer.d[0],#$87#$ec#$81#$c4#$ab#$01#$87#$ec#$bc) then
      begin
        (* ROSETINY 0.94 ROSETINY.EXE INTRO.COM *)
        rcc286('1.01');
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$f7#$dc#$87#$ec#$83#$c4#$10#$81#$c4) then
      begin
        (* RAS.COM *)
        rcc286('1.05');
        Exit;
      end;


    if bytesuche(dien_puffer.d[0],#$fa#$52#$b8#$00#$30) then
      begin
        (* HS 1.13· FLAMES.COM *)
        rcc286('1.08m');
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$52#$b8#$00#$30#$1e#$cd#$21#$86#$e0#$3d#$ff#$02#$73) then
      begin
        (* 1.09m in CUNPCFG.COM in CUNP 0.17 *)
        (* 1.09m in CUNP012.COM in CUNP 0.17 *)
        rcc286('1.09');
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$fa#$f7#$dc#$87) then
      begin
        (* 1.10b HARD *)
        rcc286('1.10H');
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$52#$b8#$02) then
      begin
        case dien_puffer.d[$1f] of
          $b0:rcc286('1.11');   (* Hard und Mild *)
          $53:rcc286('1.10·M');
          $d8:rcc286('1.12m');  (* kein 1.12h gefunden *)
        else
              rcc286('1.1? ¯');
        end;
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$52#$b8#$11) then
      begin
        rcc286('1.13');
        Exit;
      end;

    if bytesuche(dien_puffer.d[0],#$1e#$52#$b8#$4d) then
      begin
        case dien_puffer.d[$50] of
          $60:rcc286('1.14h');
          $57:rcc286('1.14m');
        else
              rcc286('1.14?');
        end;
        Exit;
      end;

    (*    HS,RC286 1.16                                               $d6  *)
    if bytesuche(dien_puffer.d[0],#$1e#$52#$b4#$30#$cd#$21#$86#$c4#$3d'?'#$02) then
      begin
        case dien_puffer.d[$31] of
          $fa:
            begin
              if dien_puffer.d[$11]=$50 then
                begin
                  (* 1.16m/h *)
                  rcc286('1.16');
                  Exit;
                end
              else (* 53 *)
                case dien_puffer.d[$33] of
                  $e6:
                    begin
                      hackstop('1.19 217 COM');
                      Exit;
                    end;
                  $ec:
                    begin
                      rcc286('1.17');
                      Exit;
                    end;
                end;
            end;
          $87:
            begin
              hackstop('1.19 COM');
              exit;
            end;
        end;
      end;


    if bytesuche(dien_puffer.d[0],#$fa#$87#$ec#$44#$83#$c4#$0f#$87#$ec#$1e#$52#$b4) then
      begin
        exezk:='.2?';
        case dien_puffer.d[$5c] of
          $b8:
            case dien_puffer.d[$5d] of
              $83:exezk:='h';           (* 1.18                 hard *)
              $e2:exezk:='.2/19h';      (* 1.18.2,.3,1.19       hard *)
            end;
          $61:exezk:='m';               (* 1.18                 mild *)
          $c0:exezk:='.2/19m';          (* 1.18.2,1.19          mild *)
        end;
        rcc286('1.18'+exezk);
        Exit;
      end;




    if bytesuche(dien_puffer.d[0],#$83#$c4#$09#$bc) then
      begin
        ausschrift('RCC386 / Ralph Roth [0.51,0.61]',packer_exe); (* 0.51/386 *)
        if not ende_ausschrift(12,'RCC') then
          if not ende_ausschrift(21,'RCC') then ;
        Exit;
      end;


    ausschrift('RCC,HS,.. / Ralph Roth [?.?] ¯',signatur);

  end;

procedure rosetiny(const ver:string);
  begin
    if copy(kopftext,1,2)='RT' then
      ausschrift('ROSETINY / Ralph Roth'+version_x_y(Ord(kopftext[3]),Ord(kopftext[4])),packer_exe)
    else
      begin
        ausschrift('ROSETINY / Ralph Roth '+ver,packer_exe);
        kopftext_anzeige(textz_exe__veraenderter_Kopf^,packer_exe);
      end;
    kopftext_nullen;
  end;

procedure bliztcopy_test(const p:puffertyp);
  begin
    if p.d[1] in [0,1,2] then
      if ((p.d[$58]=$eb) and (p.d[$58+2]=$90))
      or ((p.d[$58]=$e9) and (p.d[$58+2]=$00))
       then
        ausschrift('BlitzCopy / Oliver Siebenhaar, Udo Steger',packer_dat);
  end;

procedure mcm_anzeige(var p:puffertyp;const o:word_norm);
  var
    x,y                 :word_norm;
    merker              :array[1..25] of buntzeilen_typ;
    posi                :word_norm;
    farbe               :byte;
  begin
    FillChar(merker,sizeof(merker),0);
    x:=1;
    y:=1;
    farbe:=$07;
    posi:=o;
    repeat
      case p.d[posi] of
        $00:
          begin
            farbe:=p.d[posi+1];
            Inc(posi,2);
          end;
        $01:
          begin
            if p.d[posi+1]=$ff then
              break; (* Textende *)

            merker[y][x][1]:=p.d[posi+2];
            merker[y][x][2]:=farbe;
            Inc(x);
            Dec(p.d[posi+1]);

            if p.d[posi+1]=$ff then
              Inc(posi,3);

           end;
        $0a:
          begin
            Inc(y);
            x:=1;
            Inc(posi);
          end;
      else
        merker[y][x][1]:=p.d[posi];
        merker[y][x][2]:=farbe;
        Inc(x);
        Inc(posi);
      end;

      if x>80 then
        begin
          Inc(y);
          x:=1;
        end;
    until (posi+3>=sizeof(p.d)) or (y>24);

    for x:=1 to y do
      schreibe_zeile(merker[x]);

  end;

procedure ls000c;
  var
    o                   :longint;
  begin
    if not langformat then exit;
    o:=12+4;
    (* repeat *)
      datei_lesen(dien_puffer,analyseoff+o,512);
      ausschrift(puffer_zu_zk_e(dien_puffer.d[0],#0,255),beschreibung);
    (* until ..*)
  end;

procedure ls000d;
  var
    o                   :longint;
  begin
    if not langformat then exit;
    o:=8;
    repeat
      datei_lesen(dien_puffer,analyseoff+o,30);
      if dien_puffer.d[0]=0 then break;
      exezk:=puffer_zu_zk_pstr(dien_puffer.d[0]);
      leerzeichenerweiterung(exezk,8);
      ausschrift(exezk+' ->'+str_(longint_z(@dien_puffer.d[dien_puffer.d[0]+1])^,7),packer_dat);
      Inc(o,dien_puffer.d[0]+1+4);
    until false;
  end;

procedure videotext_anzeigen;
  const
    spalte0             =20;
  var
    videotextzeile1,
    videotextzeile2     :buntzeilen_typ;
    zeile,spalte        :word_norm;

    zeichen             :byte;

    blinken             :boolean;
    blockgrafik         :boolean;
    doppelte_hoehe      :boolean;
    vordergrundfarbe    :byte;
    hintergrundfarbe    :byte;
    naechste_zeile_mitbearbeiten:boolean;
    naechste_zeile_ignorieren:boolean;
    ueberschreiben      :boolean;

    farb_attr           :byte;

  procedure blockgrafikzeichen(const b:byte);
    var
      z:char;

    begin
 {     if blinken then
        farb_attr:=hintergrundfarbe*$10+vordergrundfarbe+$80
      else}
        farb_attr:=hintergrundfarbe*$10+vordergrundfarbe;

      if naechste_zeile_mitbearbeiten then
        begin
          videotextzeile2[spalte0+spalte,2]:=farb_attr;
          if doppelte_hoehe then
            videotextzeile2[spalte0+spalte,1]:=Ord('˝')
          else
            videotextzeile2[spalte0+spalte,1]:=Ord(' ');
        end;

      case b of
       $00:z:=' ';
       $03:z:='ﬂ';
       $0c:z:='ƒ';
       $15:z:='›';
       $2a:z:='ﬁ';
       $30:z:=#22;
       $3c:z:='‹';
       $3f:z:='€';
      else
           z:='ˆ';
      end;

      videotextzeile1[spalte0+spalte,2]:=farb_attr;
      videotextzeile1[spalte0+spalte,1]:=Ord(z);
    end;

  procedure normales_zeichen(const c:char);
    begin
{      if blinken then
        farb_attr:=hintergrundfarbe*$10+vordergrundfarbe+$80
      else}
        farb_attr:=hintergrundfarbe*$10+vordergrundfarbe;

      if naechste_zeile_mitbearbeiten then
        begin
          videotextzeile2[spalte0+spalte,2]:=farb_attr;
          if doppelte_hoehe then
            videotextzeile2[spalte0+spalte,1]:=Ord('˝')
          else
            videotextzeile2[spalte0+spalte,1]:=Ord(' ');
        end;

      videotextzeile1[spalte0+spalte,2]:=farb_attr;
      videotextzeile1[spalte0+spalte,1]:=Ord(c);
    end;


  function farbtabelle(const f:byte):byte;
    begin
      case f of
        0:farbtabelle:= 8; (* grau    *)
        1:farbtabelle:=12; (* rot     *)
        2:farbtabelle:=10; (* grÅn    *)
        3:farbtabelle:=14; (* gelb    *)
        4:farbtabelle:= 1; (* blau    *)
        5:farbtabelle:=13; (* magenta *)
        6:farbtabelle:= 3; (* zyan    *)
        7:farbtabelle:=15; (* wei·    *)
      else
        runerror(0);
      end
    end;

  procedure konvertiere_zeichen(const b:byte);
    begin
      case chr(b) of
        '@':normales_zeichen('');
   'A'..'Z':normales_zeichen(chr(b));
        '[':normales_zeichen('é');
        '\':normales_zeichen('ô');
        ']':normales_zeichen('ö');
      else
        if blockgrafik then
          case chr(b) of
            ' '..'?' :blockgrafikzeichen(b-Ord(' ')+00);
            '`'..#127:blockgrafikzeichen(b-Ord('`')+32);

          end
        else
          case chr(b) of
            '`':normales_zeichen('¯');
            '{':normales_zeichen('Ñ');
            '|':normales_zeichen('î');
            '}':normales_zeichen('Å');
            '~':normales_zeichen('·');
           #127:blockgrafikzeichen(63);
          else
                normales_zeichen(chr(b));
          end;
      end;
    end;


  begin
    ueberschreiben              :=false;
    naechste_zeile_ignorieren   :=false;

    for zeile:=1 to 24 do
      begin
        if naechste_zeile_ignorieren then
          begin
            naechste_zeile_ignorieren:=false;
            continue;
          end;

        fillchar(videotextzeile1,sizeof(videotextzeile1),0);
        fillchar(videotextzeile2,sizeof(videotextzeile2),0);


        hintergrundfarbe      :=farbtabelle(0); (* grau    *)
        vordergrundfarbe      :=farbtabelle(7); (* wei·    *)
        blinken               :=false;
        doppelte_hoehe        :=false;
        blockgrafik           :=false;

        naechste_zeile_mitbearbeiten:=false;
        for spalte:=1 to 40 do
          if bild[zeile][spalte]=$0d then
            naechste_zeile_mitbearbeiten:=true;

        for spalte:=1 to 40 do
          begin
            zeichen:=bild[zeile][spalte];
            case zeichen of
              0: (* NUL *)
                begin
                  blockgrafikzeichen(0);
                  vordergrundfarbe:=farbtabelle(zeichen);
                  blockgrafik:=false;
                end;
              1..7: (* Alpha ... *)
                begin
                  blockgrafikzeichen(0);
                  ueberschreiben:=false; (* ZurÅcksetzen *)
                  vordergrundfarbe:=farbtabelle(zeichen);
                  blockgrafik:=false;
                end;
              8: (* Blinken ein *)
                begin
                  blockgrafikzeichen(0);
                  blinken:=true;
                end;
              9: (* Blinken aus *)
                begin
                  blinken:=false;
                  blockgrafikzeichen(0);
                end;
              10: (* Einblendfeld Ende *)
                begin
                  blockgrafikzeichen(0);
                end;
              11: (* Einblendfeld Anfang *)
                begin
                  blockgrafikzeichen(0);
                end;
              12:
                begin
                  doppelte_hoehe:=false;
                  blockgrafikzeichen(0);
                end;
              13:
                begin
                  blockgrafikzeichen(0);
                  doppelte_hoehe:=true;
                  naechste_zeile_ignorieren:=true;
                end;
              14:
                begin
                  blockgrafikzeichen(0);
                  {"S0" ignorieren }
                end;
              15:
                begin
                  blockgrafikzeichen(0);
                  {"S1" ignorieren }
                end;
              16:
                begin
                  blockgrafikzeichen(0);
                  {"DLE" ignorieren }
                  vordergrundfarbe:=farbtabelle(zeichen-16);
                  blockgrafik:=true;
                end;
              17..23: (* Mosaik ... *)
                begin
                  blockgrafikzeichen(0);
                  ueberschreiben:=false; (* ZurÅcksetzen *)
                  vordergrundfarbe:=farbtabelle(zeichen-16);
                  blockgrafik:=true;
                end;
              24: (* verdeckt *) (* RÑtsel *)
                begin
                  blockgrafikzeichen(0);
                  {ignorieren}
                end;
              25: (* Grafik verbunden *)
                begin
                  blockgrafikzeichen(0);
                end;
              26: (* Grafik gerastert *)
                begin
                  blockgrafikzeichen(0);
                end;
              27: (* "ESC" *)
                begin
                  blockgrafikzeichen(0);
                end;
              28: (* Hintergund Schwarz *)
                begin
                  hintergrundfarbe:=farbtabelle(0);
                  blockgrafikzeichen(0);
                end;
              29: (* Hintergrund neu *)
                begin
                  hintergrundfarbe:=vordergrundfarbe;
                  blockgrafikzeichen(0);
                end;
              30: (* Åberschreiben *)
                begin (* LOGO.VTS *)
                  ueberschreiben:=true;
                  blockgrafikzeichen(0);
                end;
              31: (* nicht Åberschreiben *)
                begin
                  ueberschreiben:=false;
                  blockgrafikzeichen(0);
                end;

              Ord(' ')..127:
                konvertiere_zeichen(zeichen);
            else
              exit;
            end;
          end;

        schreibe_zeile(videotextzeile1);

        if naechste_zeile_mitbearbeiten then
          begin
            naechste_zeile_ignorieren:=true;
            schreibe_zeile(videotextzeile2)
          end;
      end;
  end;

procedure prestel;
  var
    o                   :longint;
    seitennummer        :word_norm;
  begin
    fillchar(bild,sizeof(bild),' ');
    datei_lesen(dien_puffer,analyseoff,7);
    seitennummer:=(dien_puffer.d[0] mod $10)*100
                 +(dien_puffer.d[1] div $10)* 10
                 +(dien_puffer.d[1] mod $10)*  1;
    ausschrift('Prestel '+str_(seitennummer,3),musik_bild);
    o:=7;
    repeat
      datei_lesen(dien_puffer,analyseoff+o,40+1);
      dien_puffer.d[40]:=dien_puffer.d[40] and $7f;
      if not (dien_puffer.d[40] in [1..23]) then break;
      move(dien_puffer.d[0],bild[dien_puffer.d[40]][1],40);
      Inc(o,40+1);
    until o>=einzel_laenge;

    videotext_anzeigen;
  end;

procedure ttx;
  var
    z                   :word_norm;
  begin
    datei_lesen(dien_puffer,analyseoff+1000-40,40);

    ausschrift('Videotext (TTX)',musik_bild);
    for z:=1 to 24 do
      begin
        datei_lesen(dien_puffer,analyseoff+(z-1)*40,40);
        move(dien_puffer.d[0],bild[z][1],40);
      end;
    videotext_anzeigen;
  end;

procedure test_photocd(const p:puffertyp);
  var
    r                   :integer_norm;
  begin
    for r:=0 to $1f do
      if p.d[r]<>$ff then exit;

    datei_lesen(dien_puffer,analyseoff+$800,512);
    if dien_puffer.g<>512 then exit;

    if not bytesuche(dien_puffer.d[0],'PCD') then exit;

    ausschrift('PhotoCD / KODAK "'+puffer_zu_zk_e(dien_puffer.d[0],#0,80)+'"',musik_bild);
    ausschrift(puffer_zu_zk_l(dien_puffer.d[$3e],$30),beschreibung);
  end;

procedure feldtext_anzeige(const o:dateigroessetyp;const spalten,zeilen:integer_norm;const attr:aus_attribute);
  var
    z                   :integer_norm;
  begin
    for z:=1 to zeilen do
      begin
        datei_lesen(dien_puffer,o+(z-1)*spalten,spalten);
        ausschrift_x(puffer_zu_zk_l(dien_puffer.d[0],spalten),attr,vorne);
      end;
  end;

procedure award_flash_writer;
  var
    gefunden,gefunden2  :dateigroessetyp;
  begin
    ausschrift('Award Flash Memory Writer',signatur);
    if not langformat then Exit;

    (* EXE Titel *)
    gefunden:=datei_pos_suche(analyseoff+einzel_laenge,analyseoff+einzel_laenge-$6000,#$ba#$03#$19'FLASH ');
    if gefunden<>nicht_gefunden then
      IncDGT(gefunden,3)
    else
      begin (* 7.97A *)
        gefunden:=datei_pos_suche(analyseoff+einzel_laenge,analyseoff+einzel_laenge-$6000,'*** '#$03#$19'FLASH ');
        if gefunden<>nicht_gefunden then
          IncDGT(gefunden,6)
        else
          begin (* 8.23 Phoenix *)
            gefunden:=datei_pos_suche(analyseoff+einzel_laenge,analyseoff+einzel_laenge-$6000,
              '*** '#$03#$17'AwardBIOS Flash ');
            if gefunden<>nicht_gefunden then
              IncDGT(gefunden,6)
            else
              Exit;
          end
      end;

    ansi_anzeige(gefunden,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
      ,absatz,wahr,wahr,unendlich,'');

    (* Chips *)
    gefunden2:=datei_pos_suche(analyseoff,analyseoff+einzel_laenge,
      #$01#$20#$00#$00'????'#$00#$00'??'#$ff#$ff'AMD 2'); (* 7.1 *)
    if gefunden2<>nicht_gefunden then
      repeat
        datei_lesen(dien_puffer,gefunden2,39);
        if bytesuche(dien_puffer.d[7*2],'Unk') then Exit;
        ausschrift(puffer_zu_zk_l(dien_puffer.d[7*2],39-7*2),signatur);
        IncDGT(gefunden2,39);
      until false;


    gefunden2:=datei_pos_suche(analyseoff,analyseoff+einzel_laenge,
      #$01#$20#$00#$00'????????'#$ff#$ff'AMD 29F'); (* 7.97A *)
    if gefunden2<>nicht_gefunden then
      repeat
        datei_lesen(dien_puffer,gefunden2,39);
        if bytesuche(dien_puffer.d[7*2],'Unk') then Exit;
        ausschrift(puffer_zu_zk_l(dien_puffer.d[7*2],39-7*2),signatur);
        IncDGT(gefunden2,39);
      until false;


    gefunden2:=datei_pos_suche(gefunden,analyseoff+einzel_laenge,#$07#$21'SST 28');
    if gefunden2=nicht_gefunden then
      gefunden2:=datei_pos_suche(gefunden,analyseoff+einzel_laenge,#$07#$24{'SST 28'});

    if gefunden2=nicht_gefunden then
      Exit;

    repeat
      datei_lesen(dien_puffer,gefunden2,512);
      if (dien_puffer.d[0]=0)
      or (dien_puffer.d[0]>=Ord(' ')) (* "Awa.." *)
       then break;
      exezk:=puffer_zu_zk_e(dien_puffer.d[2],'$',80);
      ausschrift(exezk,signatur);
      IncDGT(gefunden2,Length(exezk)+2+1);
    until false;

  end;

procedure ausschrift_upx_version(const p,p2:puffertyp;const o:word_norm;const minversion,maxversion:byte;const exe:string);
  begin
    ausschrift('UPX / Markus F.X.J. Oberhumer & L†szl¢ Moln†r ['
      +upx_version(p,p2,o,minversion,maxversion)+' '+exe+']',packer_exe);
  end;

procedure ausschrift_upx_version_dat(const p,p2:puffertyp;const o:word_norm;const minversion,maxversion:byte);
  begin
    ausschrift('UPX / Markus F.X.J. Oberhumer & L†szl¢ Moln†r ['
      +upx_version(p,p2,o,minversion,maxversion)+']',packer_dat);
  end;

function upx_version(const p,p2:puffertyp;const o:word_norm;const minversion,maxversion:byte):string;
  var
    fund                :word_norm;
    version             :byte;
  label
    auswertung;
  begin
    version:=0;

    if (minversion=maxversion) then
      begin
        if minversion=005 then
          begin
            version:=1;
            goto auswertung
          end;
      end;

    for fund:=0 to 30+30 do
      if o+fund+6<high(p.d) then
        if bytesuche(p.d[o+fund],'UPX!') then
          begin
            version:=p.d[o+fund+4];
            goto auswertung
          end;

    for fund:=0 to 30+30 do
      if o>low(p.d)+fund then
        if bytesuche(p.d[o-fund],'UPX!') then
          begin
            version:=p.d[o-fund+4];
            goto auswertung
          end;

    fund:=puffer_pos_suche(p,'UPX!',p.g);
    if fund<>nicht_gefunden then
      begin
        version:=p.d[fund+4];
        goto auswertung
      end;

    fund:=puffer_pos_suche(p2,'UPX!',p2.g);

    (* Versuch scrambleupx105 *)
    if fund=nicht_gefunden then
      if (p2.d[$183]=$21) and (p2.d[$183+2] in [1..9]) then
        version:=p2.d[$183+1];

    if fund<>nicht_gefunden then
      begin
        version:=p2.d[fund+4];
        goto auswertung
      end;


    auswertung:

    case version of
        0:upx_version:='?¯ >='+str0(minversion);
      $01:upx_version:='0.05';
      $03:upx_version:='0.20';
      $04:upx_version:='0.30';
      $05:
        begin
          if minversion=50 then
            upx_version:='0.50'
          else if maxversion=40 then
            upx_version:='0.40'
          else
            upx_version:='0.40,0.50';
        end;
      $07:upx_version:='0.60';
      $08:upx_version:='0.70';
      $09:upx_version:='0.72';
      $0a:
        if minversion<81 then
          upx_version:='0.76.1'
        else if minversion<84 then
          upx_version:='0.81'
        else
          upx_version:='0.84';

      $0b:
        begin
          upx_version:='0.90';
          if minversion=092 then
            upx_version:='0.92'; (* UPX.EXE 0.92d *)
          if minversion=120 then
            upx_version:='1.20'; (* djgpp2/coff *)
        end;
      $0c:
        begin
          upx_version:='0.90'; (* CPUIDLE.DLL *)
          if minversion=092 then
            upx_version:='0.92'; (* UPX.EXE 0.92d *)
          if minversion=099 then
            upx_version:='0.99'; (* djgpp2/coff *)
          if minversion=120 then
            upx_version:='1.20'; (* djgpp2/coff *)
        end;
      $0d:
        begin
          upx_version:='1.90';
        end;
      $0e:
        begin
          upx_version:='1.91';
        end;

      $ff:upx_version:='?.?? (UPX.EXE)';
    else
          upx_version:='?.?? ('+str0((*p.d[o+4]*)version)+')¯';
    end;
  end;

procedure turbo_pascal(const p:puffertyp;const aenderung:string);
  var
    w1,w2:word_norm;
  begin
    exezk:='?.?';
    if bytesuche(p.d[9],#$8B#$C4#$05#$13#$00#$B1#$04#$D3#$E8) then
      exezk:='4';

    if bytesuche(p.d[9],#$33#$ED) then
      begin
        if bytesuche(p.d[11],#$8B#$C4#$05#$13#$00#$B1#$04#$D3#$E8) then
          case p.d[$2B] of
            $26:exezk:='5.5'; (* 5.0? *)
            $A3:exezk:='6.0';
          end;

        if bytesuche(p.d[11],#$E8'??'#$E8'??'#$8B#$C4) then
          exezk:='7.0';

      end;
    ausschrift('Turbo / Borland Pascal '+exezk,compiler);

    if (exezk='6.0') or (exezk='7.0') then
      begin
        if bytesuche(p.d[$4f],#$b9#$12#$00#$90) then
          ausschrift('AntiUPC / B†rth†zi Andr†s [1.00·]',packer_exe);

        datei_lesen(dien_puffer,analyseoff+codeoff_off+longint(codeoff_seg)*16+$1E0,512);
        w1:=0;
        while (w1<200) and (not bytesuche(dien_puffer.d[w1],#$2e#$0d#$0a)) do
          Inc(w1);
        if w1=200 then
          ausschrift(textz_exe__grossv_veraenderte_leer^+textz_exe__Laufzeitbibliothek^,signatur)
        else
          begin
            w2:=w1+4;
            exezk:=puffer_zu_zk_l(dien_puffer.d[w1+4],80);
            w1:=3;
            while w1<Length(exezk) do
              if exezk[w1] in [#0,#123..#255,'U'] then
                exezk[0]:=chr(w1-1)
              else
                Inc(w1);

            while (exezk<>'') and (exezk[Length(exezk)] in ['3','U',#$8b]) do
              Dec(exezk[0]);

            if not ((bytesuche(exezk[1],'Portions Copyright (c) 1983,9? Borland')
              and (Length(exezk)=Length('Portions Copyright (c) 1983,9? Borland')))) then
              if exezk<>'' then
                ausschrift(exezk,beschreibung);

            if bytesuche(dien_puffer.d[w2],#$e8#$15#$00#$26#$8b#$07#$26#$8e#$47#$02) then
              ausschrift('XPACK.UPC.Guard.TP6/7 / JauMing Tseng',packer_exe); (* 1.67 *)

          end;
      end;

    if bytesuche(p.d[0],#$BA#$B6#$09#$8e#$DA#$8C#$06#$EA#$28) then
      ausschrift('Erichs letzte Rache',virus);

    if bytesuche(p.d[0],#$BA#$38#$01#$8E#$DA#$8C#$06#$38#$00#$33#$ED#$E8#$14) then
      ausschrift('AVPL Testvirus Companion',virus);

    if bytesuche(p.d[$53],#$90#$90#$90#$90#$90) then
      ausschrift('Pascal patch / Daniel Arndt [1.3]',packer_exe);

    if bytesuche(p.d[0],#$ba#$e1#$00#$8e#$da#$8c#$06#$3e#$00) and (einzel_laenge=$0f50) then
      (* Typ kann die gepackten Daten nicht erkennen, also erkenne ich
         den Entpacker *)
      ausschrift('EPACK / Stepanyuk Oleg [1.6]',packer_exe); (* oder vielleicht packer_dat? *)

    if aenderung<>'' then
      ausschrift(aenderung,packer_exe);


  end;

function version100(const w:word_norm):string;
  begin
    version100:=' ['+str0(w div 100)+'.'+chr(Ord('0')+(w mod 100) div 10)+chr(Ord('0')+(w mod 10))+']';
  end;

function version_div10_mod10(const b:byte):string;
  begin
    version_div10_mod10:=' ['+str0(b div 10)+'.'+str0(b mod 10)+']';
  end;

function version_div16_mod16(const b:byte):string;
  begin
    version_div16_mod16:=' ['+str0(b div 16)+'.'+str0(b mod 16)+']';
  end;

function version_x_y(const x,y:byte):string;
  begin
    version_x_y:=version100(x*100+y);
  end;

function version_x_y_z(const x,y,z:byte):string;
  begin
    version_x_y_z:=' ['+str0(x)+'.'+str0(y)+'.'+str0(z)+']';
  end;

function version161616(const v:word):string;
  var
    nachkkomma:byte;
  begin
    nachkkomma:=Lo(v);
    version161616:=version100((v shr 8)*100+(nachkkomma shr 4)*10+(nachkkomma and $0f));
  end;

function version_einstellig(const v:byte):string;
  begin
    version_einstellig:=' ['+str0(v)+']';
  end;

procedure upstop(const version:string);
  begin
    ausschrift('UnPackStop / Szab¢ L†szl¢ '+version,packer_exe);
    if langformat then
      ansi_anzeige(analyseoff+ds_off+$100,
        '$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'')
  end;

procedure trap(const version:string);
  begin
    ausschrift('Trap / Christoph Gabler ['+version+']',packer_exe);
  end;

procedure untersuche_ob_textdatei;
  var
    z1:word_norm;
  begin
    for z1:=1 to analysepuffer.g do
      (* 9/10/12/13/26/27 *)
      if analysepuffer.d[z1-1] in [0..8,11,14..25,28..31,127] then
        Exit;

    z1:=puffer_pos_suche(analysepuffer,#10,512);
    if (z1=nicht_gefunden)
    or (z1>132)
     then
      Exit;

    textdatei:=true;
    (*Dec(herstellersuche);
    ausschrift('<<<Textdatei>>>',signatur);
    Inc(herstellersuche);*)
  end;

procedure viotbl_dcp(const kopf:puffertyp);
  var
    anzahl,
    zaehler             :word_norm;
    o,
    cp                  :longint;
  begin
    ausschrift('OS/2 VIOTBL.DCP',bibliothek);
    if not langformat then exit;

    datei_lesen(dien_puffer,word_z(@kopf.d[6])^*4+8,512);
    ausschrift(puffer_zu_zk_e(dien_puffer.d[0],#0,word_z(@kopf.d[0])^-(word_z(@kopf.d[6])^*4+8)),beschreibung);

    anzahl:=word_z(@kopf.d[6])^;
    cp:=-1;
    for zaehler:=1 to anzahl do
      begin
        o:=x_longint__datei_lesen(analyseoff+(zaehler-1)*4+8);
        datei_lesen(dien_puffer,analyseoff+o,24);
        if cp=-1 then
          cp:=longint_z(@dien_puffer.d[4])^;
        ausschrift('CP'+str_(longint_z(@dien_puffer.d[4])^,5)+' : '
         +str0(dien_puffer.d[10])+' * '+str_(dien_puffer.d[11],2),musik_bild);
        if ico_anzeige then
          if cp=longint_z(@dien_puffer.d[4])^ then
            case dien_puffer.d[10] of
              8:anzeige_ega_font(dien_puffer.d[11],dien_puffer.d[10],o+$18,false,false,word_z(@dien_puffer.d[$12])^);
              9:anzeige_ega_font(dien_puffer.d[11],dien_puffer.d[10],o+$18,false,true ,word_z(@dien_puffer.d[$12])^);
            end
      end;
  end;

procedure keyboard_dcp(const kopf:puffertyp);
  var
    erster_datenanfang,
    o_verz              :dateigroessetyp;
    z,anzahl,
    blocklaenge         :word_norm;
    flag                :word_norm;

  begin
    ausschrift('OS/2 KEYBOARD.DCP',bibliothek);
    if not langformat then exit;

    o_verz:=analyseoff+longint_z(@kopf.d[0])^;
    datei_lesen(dien_puffer,o_verz,4);
    anzahl:=word_z(@dien_puffer.d[0])^;
    blocklaenge:=word_z(@dien_puffer.d[2])^;
    erster_datenanfang:=o_verz;

    IncDGT(o_verz,2+2);

    for z:=anzahl downto 1 do
      begin
        datei_lesen(dien_puffer,o_verz,$12);
        IncDGT(o_verz,blocklaenge);

        (* 00 country   smallword                       *)
        (* 02 keyboard  array[1..4] of char             *)
        (* 06 ?? (0)    smallword                       *)
        (* 08 codepage  smallword                       *)
        (* 0a ?         byte                            *)
        (* 0b ?         byte                            *)
        (* 0c offset    longint                         *)
        (* 10 ?         smallword                       *)



        (* keypatch:

        types C: 89 keys, D: dito (sel. bit A), E: 101/102 "extended", F: dito (bit A)

        flag bit 0: AltGr = shift Alt (89 keys) | bit 6: CapsLock (???)
        flag bit 1: AltGr =  left Alt (101/102) | bit 7: CapsLock used with -3,-5,+6
        flag bit 2: AltGr = right Alt (101/102) | bit 8: multiple layouts TOC bit 8
        flag bit 3: CapsLock used with +6,-7    | bit 9: bidirectional    TOC bit 1
        flag bit 4: default codepage TOC bit 0  | bit A: bidi. selective  TOC bit 2
        flag bit 5: CapsLock used with +3,+6,-7 | bit B: multiple default TOC bit 3   *)


        flag:=x_word__datei_lesen(analyseoff+longint_z(@dien_puffer.d[$c])^+2);

        (*
        exezk:=hex_word(word_z(@dien_puffer.d[$0a])^)+' '
              +hex_word(word_z(@dien_puffer.d[$10])^)+' '
              +hex_word(flag)+' ';
        *)
        exezk:='';


        if Odd(dien_puffer.d[$0a]) then
          exezk_anhaengen(' 102') (* oder auch 101? *)
        else
          exezk_anhaengen('  89');

        (*
        if Odd(flag shr 4) then
          exezk_anhaengen(' default')
        else
          exezk_anhaengen('        ');*)


        ausschrift(Chr(dien_puffer.d[1])+Chr(dien_puffer.d[0])
          +' '+puffer_zu_zk_l(dien_puffer.d[2],4)
          +' '+Strx(word_z(@dien_puffer.d[8])^,4)
          +' '+exezk,
          musik_bild);
        if erster_datenanfang>longint_z(@dien_puffer.d[$c])^ then
          erster_datenanfang:=longint_z(@dien_puffer.d[$c])^;
      end;

    ansi_anzeige(analyseoff+$4,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
                 absatz,falsch,wahr,erster_datenanfang,'');

  end;

procedure mp3_tag; (* analysepuffer *)
  var
    track:byte;
  const
    id3_genre:array[0..147] of PChar=
      ('Blues', (* 0 *)
       'Classic Rock',
       'Country',
       'Dance',
       'Disco',
       'Funk',
       'Grunge',
       'Hip-Hop',
       'Jazz',
       'Metal',
       'New Age',
       'Oldies',
       'Other',
       'Pop',
       'R&B',
       'Rap',
       'Reggae',
       'Rock',
       'Techno',
       'Industrial',
       'Alternative',
       'Ska',
       'Death Metal',
       'Pranks',
       'Soundtrack',
       'Euro-Techno',
       'Ambient',
       'Trip-Hop',
       'Vocal',
       'Jazz+Funk',
       'Fusion',
       'Trance',
       'Classical',
       'Instrumental',
       'Acid',
       'House',
       'Game',
       'Sound Clip',
       'Gospel',
       'Noise',
       'AlternRock',
       'Bass',
       'Soul',
       'Punk',
       'Space',
       'Meditative',
       'Instrumental Pop',
       'Instrumental Rock',
       'Ethnic',
       'Gothic',
       'Darkwave',
       'Techno-Industrial',
       'Electronic',
       'Pop-Folk',
       'Eurodance',
       'Dream',
       'Southern Rock',
       'Comedy',
       'Cult',
       'Gangsta',
       'Top 40',
       'Christian Rap',
       'Pop/Funk',
       'Jungle',
       'Native American',
       'Cabaret',
       'New Wave',
       'Psychadelic',
       'Rave',
       'Showtunes',
       'Trailer',
       'Lo-Fi',
       'Tribal',
       'Acid Punk',
       'Acid Jazz',
       'Polka',
       'Retro',
       'Musical',
       'Rock & Roll',
       'Hard Rock', (* 79 *)
       'Folk',
       'Folk-Rock',
       'National Folk',
       'Swing',
       'Fast Fusion',
       'Bebob',
       'Latin',
       'Revival',
       'Celtic',
       'Bluegrass',
       'Avantgarde',
       'Gothic Rock',
       'Progressive Rock',
       'Psychedelic Rock',
       'Symphonic Rock',
       'Slow Rock',
       'Big Band',
       'Chorus',
       'Easy Listening',
       'Acoustic',
       'Humour',
       'Speech',
       'Chanson',
       'Opera',
       'Chamber Music',
       'Sonata',
       'Symphony',
       'Booty Bass',
       'Primus',
       'Porn Groove',
       'Satire',
       'Slow Jam',
       'Club',
       'Tango',
       'Samba',
       'Folklore',
       'Ballad',
       'Power Ballad',
       'Rhythmic Soul',
       'Freestyle',
       'Duet',
       'Punk Rock',
       'Drum Solo',
       'A capella',
       'Euro-House',
       'Dance Hall', (* 125 *)
       'Goa',
       'Drum & Bass',
       'Club-House',
       'Hardcore',
       'Terror',
       'Indie',
       'BritPop',
       'Negerpunk',
       'Polsk Punk',
       'Beat',
       'Christian',
       'Heavy Metal',
       'Black Metal',
       'Crossover',
       'Contemporary',
       'Christian Rock',
       'Merengue',
       'Salsa',
       'Thrash Metal',
       'Anime',
       'JPop',
       'Synthpop');

  begin
    exezk:='';
    if analysepuffer.d[3+30+30+30+4+30]<High(id3_genre) then
      exezk_anhaengen(' ('+puffer_zu_zk_e(id3_genre[analysepuffer.d[3+30+30+30+4+30]]^,#0,255)+')');
    ausschrift((* Titel *)
               leer_filter(puffer_zu_zk_e(analysepuffer.d[3         ],#0,30))
              +' / '
               (* KÅnstler *)
              +leer_filter(puffer_zu_zk_e(analysepuffer.d[3+30      ],#0,30))
              +' ['
               (* Album *)
              +leer_filter(puffer_zu_zk_e(analysepuffer.d[3+30+30   ],#0,30))
              +' '
               (* Jahr *)
              +leer_filter(puffer_zu_zk_e(analysepuffer.d[3+30+30+30],#0,4))
              +']'+exezk
              ,beschreibung);

    if  (analysepuffer.d[3+30+30+30+4+29-1]=0)
    and (analysepuffer.d[3+30+30+30+4+29  ]<>0) then
      track:=analysepuffer.d[3+30+30+30+4+29]
    else
      track:=0;

    (* Kommentar *)
    exezk:=leer_filter(puffer_zu_zk_e(analysepuffer.d[3+30+30+30+4],#0,30));
    if track<>0 then
      begin
        if exezk<>'' then
          exezk_anhaengen(+' ('+str0(analysepuffer.d[3+30+30+30+4+29])+')')
        else
          exezk:='('+str0(analysepuffer.d[3+30+30+30+4+29])+')';
      end;


    ausschrift(exezk,beschreibung);

    (* Genre: letztes Byte *)
  end;

procedure mp3_anzeige; (* analysepuffer *)

  type
    tabelle             =array[0..14] of byte;


  const
    tabelle_448_bit     :tabelle=( 0, 4, 8,12,16,20,24,28,32,36,40,44,48,52,56);
    tabelle_384_bit     :tabelle=( 0, 4, 6, 7, 8,10,12,14,16,20,24,28,32,40,48);
    tabelle_320_bit     :tabelle=( 0, 4, 5, 6, 7, 8,10,12,14,16,20,24,28,32,40);
    tabelle_256_bit     :tabelle=( 0, 4, 6, 7, 8,10,12,14,16,18,20,22,24,28,32);
    tabelle_160_bit     :tabelle=( 0, 1, 2, 3, 4, 5, 6, 7, 8,10,12,14,16,18,20);

                            (* Version *)        (* Layer *)
    bitrate_verweis_tabelle:array[0..1] of array[1..3] of ^tabelle=
      ((Addr(tabelle_448_bit),Addr(tabelle_384_bit),Addr(tabelle_320_bit)),
       (Addr(tabelle_256_bit),Addr(tabelle_160_bit),Addr(tabelle_160_bit)));

  var
    bitrate_index,
    version,
    layer               :byte;

  begin
    (* [0].7 1
           . 1
           0 1

        [1].7 1
            6 1
            5 1
            4 ?
            3            \ Version 0:2"MPEG-2.5" 1:? 2:0"MPEG-1" 3:1"MPEG-2 LSF" ??
            2 \ layer    /?
            1 /
            0 - -error protection

        [2].7 \
            6  | Bitrate
            5  |
            4 /
            3 \ sample-frequenz
            2 /
            1 - padding
            0 - extension

        [3].7 \ mode
            6 /
            5 \ mode-ext
            4 /
            3 - copyright
            2 - original
            1 \ emphasis
            0 /                                    *)

    exezk:='MPEG Audio ';
    layer:=4-(analysepuffer.d[1] shr 1) and 3;

    version:=2-(analysepuffer.d[1] shr 3) and 1;

    exezk_anhaengen(str0(version)+' ');

    exezk_anhaengen('Layer '+Str0(layer)+', ');

    bitrate_index:=analysepuffer.d[2] shr 4;
    if (bitrate_index=15) or (layer=4) or (version>2) then
      exezk_anhaengen('?? KB/S, ')
    else
      exezk_anhaengen(str0(bitrate_verweis_tabelle[version-1,layer]^[bitrate_index]*8)+' KB/s, ');

    case (analysepuffer.d[3] shr 6) of
      0:exezk_anhaengen('Stereo');
      1:exezk_anhaengen(textz_jointstereo^);
      2:exezk_anhaengen(textz_zweikanalton^);
      3:exezk_anhaengen('Mono');
    end;

    ausschrift(exezk,musik_bild);

    repeat

      if einzel_laenge>$80 then
        if bytesuche__datei_lesen(analyseoff+einzel_laenge-$80,'TAG') then
          begin
            DecDGT(einzel_laenge,$80);
            Continue;
          end;

      if einzel_laenge>10 then
        if bytesuche__datei_lesen(analyseoff+einzel_laenge-10,'3DI') then
          if id3ende then
            Continue;

      Break;
    until false;
  end;

procedure zeichensatz;
  var
    hoehe,
    breite,
    anzahl              :word_norm;
  begin
    datei_lesen(dien_puffer,analyseoff,512);
    (*$IfDef dateigroessetyp_comp*)
    hoehe:=DGT_zu_longint(DivDGT(einzel_laenge,$100));
    (*$Else*)
    hoehe:=einzel_laenge shr 8;
    (*$EndIf*)

    if hoehe>32 then Exit;

    (* Zeichen #0 *)
    for z:=0 to hoehe-1 do
      if dien_puffer.d[z]<>0 then
        Exit;

    if not
      (

         (*** 20 ***)
         (* FONT20 CP850_20.FNT Quelle unbekannt, vermutlich aus x19 umgerechnet *)
          bytesuche(dien_puffer.d[hoehe],#$00#$00#$00#$7e#$81#$81#$a5#$81#$81#$81#$bd#$99#$81#$81#$7e#$00)
         (* OS/2 System VIO 8x18->20 (sfont) *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$00#$00#$1c#$22#$41#$55#$41#$41#$63#$5d#$41#$22#$1c#$00#$00#$00#$00#$00)

         (*** 19 ***)
         (* ASUS(Intel) 1005vm.rom *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$00#$00#$7c#$82#$aa#$82#$82#$ba#$92#$82#$82#$7c#$00#$00#$00#$00#$00)

         (*** 18 ***)
         (* OS/2 System VIO 8x18 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$00#$1c#$22#$41#$55#$41#$41#$63#$5d#$41#$22#$1c#$00#$00#$00#$00)

         (*** 16 ***)
         (* DGINTRO.com, kyrillisch *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$7e#$81#$a5#$a5#$a5#$81#$81#$bd#$99#$81#$7e#$00#$00#$00)
         (* Normalfall? *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$7e#$81#$a5#$81#$81#$bd#$99#$81#$81#$7e#$00#$00#$00#$00)
         (* 53338c01.vga: Toshiba S3 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$3c#$42#$81#$81#$a5#$a5#$81#$81#$a5#$99#$81#$42#$3c#$00#$00)
         (* prophmxo.rom: hercules prophietics *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$7e#$81#$a5#$81#$81#$a5#$99#$81#$81#$7e#$00#$00#$00#$00)
         (* BIOS125.vga: SystemSoft C&T 65510 VGA BIOS *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$3e#$41#$41#$55#$41#$41#$41#$5d#$49#$41#$3e#$00#$00#$00#$00)
         (* VIOTBL.DCP: 863 8x16 - um eine Zeile nach unten versetzt? *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$00#$7e#$81#$a5#$81#$81#$bd#$99#$81#$81#$7e#$00#$00#$00)
         (* VIOTBL.ISO: 437  8x16 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$3e#$41#$41#$55#$41#$41#$5d#$49#$41#$3e#$00#$00#$00#$00)
         (* VIOTBL.ISO: 851  8x16 - shl 1 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$7c#$82#$82#$AA#$82#$82#$ba#$92#$82#$7c#$00#$00#$00#$00)
         (* OS/2 System VIO 8x16 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$1c#$22#$41#$55#$41#$41#$63#$5d#$41#$22#$1c#$00#$00#$00)
         (* top1171.zip\KRUEPPEL.FON *)
       or bytesuche(dien_puffer.d[hoehe],#$95#$55#$7e#$81#$a5#$81#$81#$bd#$a5#$bd#$81#$42#$3c#$00#$00#$00)

         (*** 14 ***)
         (* OS/2 System VIO 8x14?? *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$00#$7e#$81#$a5#$81#$81#$bd#$99#$81#$7e#$00#$00)
         (* VIOTBL.DCP: 851 8x14 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$7e#$81#$a5#$81#$81#$bd#$99#$81#$7e#$00#$00#$00)
         (* VIOTBL.DCP: 1004 8x14 *)
       or bytesuche(dien_puffer.d[10*hoehe],#$00#$33#$66#$44#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00)
         (* OS/2 System VIO 8x14 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$1c#$22#$41#$55#$55#$41#$41#$63#$5d#$41#$22#$1c#$00)
         (* fontpack.tgz\fontpack.tar\usr\lib\kbd\consolefonts\thin-14 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$38#$44#$82#$aa#$82#$aa#$ba#$44#$38#$00#$00#$00)
         (* fontpack.tgz\fontpack.tar\usr\lib\kbd\consolefonts\squashed-14 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$70#$f8#$f8#$a8#$a8#$f8#$d8#$88#$f8#$70#$00#$00)


         (*** 12 ***)
         (* OS/2 System VIO 8x12 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$00#$3e#$41#$55#$41#$63#$5d#$41#$3e#$00#$00)

         (*** 10 ***)
         (* OS/2 System VIO 8x10 *)
       or bytesuche(dien_puffer.d[hoehe],#$00#$3e#$41#$55#$41#$63#$5d#$41#$3e#$00)

         (*** 08 ***)
         (* Normalfall *)
       or bytesuche(dien_puffer.d[hoehe],#$7e#$81#$a5#$81#$bd#$99#$81#$7e)
         (* 53338c01.vga: Toshiba S3 *)
       or bytesuche(dien_puffer.d[hoehe],#$3c#$42#$a5#$81#$a5#$99#$42#$3c)
         (* VIOTBL.DCP: 1004 8x8 *)
       or bytesuche(dien_puffer.d[10*hoehe],#$33#$66#$44#$00#$00#$00#$00#$00)
         (* OS/2 System VIO 8x8 *)
       or bytesuche(dien_puffer.d[hoehe],#$3e#$41#$55#$41#$5d#$41#$3e#$00)
         (* fontpack.tgz\fontpack.tar\usr\lib\kbd\consolefonts\squashed-8 *)
       or bytesuche(dien_puffer.d[hoehe],#$70#$f8#$a8#$f8#$d8#$88#$70#$00)

       ) then
      begin

        {$IfNDef EndVersion}
        ausschrift('Zeichensatz?',dat_fehler);
        {$EndIf EndVersion}

        (* Zeichen #7 und #8 *)
        for z:=0 to hoehe-1-2 do (* in OS/2 CP864/14 ist die 14.Zeile leer *)
                                 (* in ET4000 /8 ist die 7. und 8. Zeile leer *)
          if (dien_puffer.d[7*hoehe+z] xor dien_puffer.d[8*hoehe+z])<>$ff then
            Exit;

        (* Zeichen #61 '=' *)
        datei_lesen(dien_puffer,analyseoff+hoehe*61,32);
        anzahl:=0;
        for z:=0 to hoehe-1 do
          case (dien_puffer.d[z] and $7c) of (* ET4000 /8 : $7c *)
            $00:;
            $7c:Inc(anzahl);
          else
            Exit;
          end;
      end;

    if anzahl>=2 then
      begin
        breite:=bestimme_breite89(hoehe,0);
        ausschrift('EGA/VGA '+textz_schrift^+' '+str0(breite)+'*'+str0(hoehe),musik_bild);
        anzeige_ega_font(hoehe,breite,0,false,false,256);
      end;
  end;

procedure mess(const ver,zusatz:string);
  var
    w1                  :word_norm;
  begin
    exezk:=ver;
    if exe then
      begin
        w1:=exe_kopf.pruefsumme;
        if (w1>=$100) and (w1<=$100+99) then
        exezk:=version_x_y(1,lo(w1));
        if  (lo(w1)<20)  (* ab 1.20 kein .COM mehr *)
        and (Pos('EXE',exezk)=0) then
          insert('EXE ',exezk,3);
      end;
    ausschrift('Mess / Stonehead'+exezk+zusatz,packer_exe);
  end;

function zusatzcodelaenge_zk:string;
  begin
    zusatzcodelaenge_zk:=' [+'+DGT_str0(einzel_laenge-longint(codeoff_seg)*16-codeoff_off)+']';
  end;

procedure award_logo(const p:puffertyp);
  var
    z,s                 :word_norm;
    zeile               :array[0..1] of buntzeilen_typ;
    z1                  :word_norm;
    farbe,
    zeichen_a,
    zeichen_b           :byte;
  const
    zeichentabelle:array[0..3] of byte=
      (Ord(' '),Ord('ﬂ'),Ord('‹'),Ord('€'));

    zeichensatz_zu_bits_tabelle:array[0..14-1] of byte=
      (1,1,1,2,2,2,2,4,4,4,8,8,8,8);
  begin
    ausschrift('Award BIOS Logo',musik_bild);

    if not ico_anzeige then Exit;

    for z:=1 to p.d[1] do
      begin
        datei_lesen(dien_puffer,analyseoff+2+(z-1)*p.d[0],p.d[0]);
        zeile[0]:=leerzeile;
        zeile[1]:=leerzeile;
        for s:=1 to p.d[0] do
          begin
            farbe:=dien_puffer.d[s-1]; (* Farbe *)
            zeile[0][s*2+5+0][2]:=farbe;
            zeile[0][s*2+5+1][2]:=farbe;
            zeile[1][s*2+5+0][2]:=farbe;
            zeile[1][s*2+5+1][2]:=farbe;
          end;

        datei_lesen(dien_puffer,analyseoff+2+p.d[0]*p.d[1]+(z-1)*p.d[0]*14,p.d[0]*14);
        for s:=1 to p.d[0] do
          begin
            zeichen_a:=0;
            zeichen_b:=0;
            for z1:=0 to 14-1 do
              begin
                if (dien_puffer.d[(s-1)*14+0+z1] and $f0)<>0 then
                  zeichen_a:=zeichen_a or zeichensatz_zu_bits_tabelle[z1];
                if (dien_puffer.d[(s-1)*14+0+z1] and $0f)<>0 then
                  zeichen_b:=zeichen_b or zeichensatz_zu_bits_tabelle[z1];
              end;
            zeile[0][s*2+5+0][1]:=zeichentabelle[zeichen_a and 3];
            zeile[1][s*2+5+0][1]:=zeichentabelle[zeichen_a shr 2];
            zeile[0][s*2+5+1][1]:=zeichentabelle[zeichen_b and 3];
            zeile[1][s*2+5+1][1]:=zeichentabelle[zeichen_b shr 2];
          end;
        schreibe_zeile(zeile[0]);
        schreibe_zeile(zeile[1]);
      end;


  end;


procedure com2text_nide(const ver:string;const nide;const laenge:word_norm);
  var
    nide_zk             :string;
  begin
    nide_zk:=puffer_zu_zk_l(nide,laenge);
    if (nide_zk='com2txt/Nide')
    or (nide_zk='com2txtNide' )
    or (nide_zk='Nide/com2txt')
  (*or (nide_zk='JauMingTseng')*)
     then
      ausschrift('COM2TXT / NIDE Naoyuki ['+ver+']',packer_exe)
    else
      ausschrift('COM2TXT / NIDE Naoyuki ['+ver+' '+in_doppelten_anfuerungszeichen(nide_zk)+']',packer_exe);

  end;


procedure loesche_muell(var s:string;const z2:string);
  var
    p1:word_norm;
    sg:string;
  begin
    sg:=gross(s);
    repeat
      p1:=pos(z2,sg);
      if p1=0 then break;
      Delete(s ,p1,Length(z2));
      Delete(sg,p1,Length(z2));
    until false;
  end;

procedure cpi_anzeige(const p:puffertyp);
  var
    schon_angezeigt     :boolean;

  procedure anzeige_msfont(o:longint);
    var
      anzahl,x,y        :word_norm;
      o2                :longint;
      ico_anzeige_org   :boolean;
    begin
      datei_lesen(dien_puffer,analyseoff+o,2+2+2); (* font data header *)
      if word_z(@dien_puffer.d[0])^<>1 then Exit;

      Inc(o,2+2+2);
      anzahl:=word_z(@dien_puffer.d[2])^;
      ico_anzeige_org:=ico_anzeige;
      if schon_angezeigt then
        ico_anzeige:=false;
      while anzahl>0 do
        begin
          Dec(anzahl);
          datei_lesen(dien_puffer,analyseoff+o,1+1+2+2);
          Inc(o,1+1+2+2);
          y:=dien_puffer.d[0];
          x:=dien_puffer.d[1];
          o2:=o+word_z(@dien_puffer.d[4])^*y*((x+7) shr 3);
          anzeige_ega_font(y,x,o,true,false,256);
          schon_angezeigt:=true;
          o:=o2;
        end;
      ico_anzeige:=ico_anzeige_org;
    end;

  procedure anzeige_font_tabelle(o:longint);
    var
      anzahl:word_norm;
    begin
      anzahl:=x_word__datei_lesen(analyseoff+o);
      Inc(o,2);
      while (anzahl>0) and (o>0) do (* <>0 und <>-1 *)
        begin
          Dec(anzahl);
          datei_lesen(dien_puffer,analyseoff+o,$1c);
          case word_z(@dien_puffer.d[6])^ of
            1:exezk:='Display';
            2:exezk:='Printer';
          else
              exezk:=Str0(word_z(@dien_puffer.d[6])^)+'?¯';
          end;
          exezk_anhaengen(': ');
          exezk_anhaengen(in_doppelten_anfuerungszeichen(puffer_zu_zk_l(dien_puffer.d[8],8)));
          exezk_anhaengen(': ');
          exezk_anhaengen(Str0(word_z(@dien_puffer.d[16])^));
          ausschrift_x(exezk,beschreibung,absatz);
          o:=longint_z(@dien_puffer.d[2])^;
          if (word_z(@dien_puffer.d[6])^=1)
          and (not bytesuche(p.d[0],#$7f'DR'))
          and (not bytesuche(dien_puffer.d[8],'4201 ')) (* DR DOS Fehler, Quelle: cpi.lst *)
          and (not bytesuche(dien_puffer.d[8],'4208 '))
          and (not bytesuche(dien_puffer.d[8],'5202 '))
          and (not bytesuche(dien_puffer.d[8],'1050 '))
           then
            anzeige_msfont(longint_z(@dien_puffer.d[24])^);
        end;
      if o>0 then
        ansi_anzeige(analyseoff+o,#$1a,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,
          true,true,analyseoff+einzel_laenge,'');
    end;

  var
    w1          :word_norm;
  begin
    if not langformat then Exit;

    schon_angezeigt:=false;
    if bytesuche(p.d[0],#$7f'DR') then
      begin
        for w1:=1 to p.d[$17] do
          anzeige_ega_font(p.d[$18-1+w1],8,longint_z(@p.d[$1c-4+w1*4])^,true,false,256(*+..*));
        schon_angezeigt:=true;
        anzeige_font_tabelle(longint_z(@p.d[$13])^);
      end
    else
      anzeige_font_tabelle(longint_z(@p.d[$13])^);
  end;

procedure os2_font(volle_anzeige:boolean;speicher:speicherbereich_z;speicher_laenge:word_norm);
  const
    beispiel            :array[0..6-1] of Char='Typ:00'; (* ∞±≤€ *)
  var
    hoehe,breite,
    x,y,i               :word_norm;
    b                   :word_norm;
    xteil,
    xs,
    xe                  :word_norm;
    dp                  :longint;
    p                   :puffertyp;
    c                   :word_norm;
  begin
    if Assigned(speicher) then
      Move(speicher^[0],p.d,Min(512,speicher_laenge))
    else
      datei_lesen(p,analyseoff,512);
    with p do
      begin
        breite:=word_z(@d[$72])^;
        hoehe:=word_z(@d[$76])^;
        ausschrift('OS/2 Font '+in_doppelten_anfuerungszeichen(puffer_zu_zk_e(d[$3c],#0,31))
          +'  ('+str0(breite)+' * '+str0(hoehe)+')',musik_bild);
      end;

    if not (ico_anzeige and volle_anzeige) then Exit;

    if (hoehe>64) or (breite>64) then Exit;

    beispiel[4]:=Chr(hoehe div 10+Ord('0'));
    beispiel[5]:=Chr(hoehe mod 10+Ord('0'));
    FillChar(bild,SizeOf(bild),os_2_ico_farbe);
    xs:=0;
    for i:=Low(beispiel) to SizeOf(beispiel)-1 do
      begin
        c:=Ord(beispiel[i]);
        if c<word_z(@p.d[$86])^ then
          Continue;
        Dec(c,word_z(@p.d[$86])^);

        dp:=$d8+6*c;
        if Assigned(speicher) then
          begin
            if (speicher_laenge>dp+6) and (dp>0) then
              Move(speicher^[dp],dien_puffer.d,6);
          end
        else
          datei_lesen(dien_puffer,analyseoff+dp,6);
        xe:=word_z(@dien_puffer.d[4])^;
        if xs+xe>64 then Break;
        dp:=longint_z(@dien_puffer.d[0])^;
        if dp=0 then Continue;
        for xteil:=1 to (xe+7) shr 3 do
          begin
            if Assigned(speicher) then
              begin
                if (speicher_laenge>dp+hoehe) and (dp>0) then
                  Move(speicher^[dp],dien_puffer.d,hoehe);
              end
            else
              datei_lesen(dien_puffer,analyseoff+dp,hoehe);
            Inc(dp,hoehe);
            for y:=0 to hoehe-1 do
              begin
                b:=dien_puffer.d[y];
                for x:=xs+Min(xe,8)-1 downto xs do
                  if Odd(b shr (7-(x-xs))) then
                    bild[x,y]:=bild[x,y] xor $f;
              end;
            Inc(xs,Min(xe,8));
            Dec(xe,Min(xe,8))
          end;
      end;
    schreibe_bild(xs,hoehe,os_2_ico_farbe);
  end;

procedure font_windows(const o0,laenge:dateigroessetyp);
  const
    beispiel            :array[0..6-1] of Char='Typ:00';
  var
    hoehe,breite,
    x,y,i,l             :word_norm;
    b                   :word_norm;
    xteil,
    xs,
    xe                  :word_norm;
    dp                  :longint;
    p                   :puffertyp;
    w1                  :word_norm;
    c                   :word_norm;
    version             :byte;

  procedure loesche(var zk:string;const sub:string);
    var
      w1:word_norm;
    begin
      repeat
        w1:=Pos(sub,zk);
        if w1=0 then Exit;
        Delete(zk,w1,Length(sub));
        while (Length(zk)>=w1) and (zk[w1] in [' ',',','.']) do
          Delete(zk,w1,1);
      until false;
    end;

  begin
    datei_lesen(p,o0,512);
    if (laenge<$70)
    or (einzel_laenge<longint_z(@p.d[2])^)
    or (longint_z(@p.d[2])^<$70) then Exit;

    version:=p.d[1];
    if (version<1) or (version>3) then Exit;

    if (*(word_z(@p.d[$76])^<3) {klappt nicht mit admui316.fon }
    or*) (word_z(@p.d[$76])^>100) then Exit;

    case version of
      1,
      2:dp:=word_z(@p.d[$76+2])^;
      3:dp:=longint_z(@p.d[(* $76 *)$94+2])^;
    end;
    if (dp<$76+10) or (dp>laenge) then Exit;

    exezk:=puffer_zu_zk_e(p.d[6],#0,$44-6);
    if not ist_ohne_steuerzeichen_nicht_so_streng(exezk) then Exit;


    hoehe:=word_z(@p.d[$58])^;
    breite:=word_z(@p.d[$56])^;

    dp:=longint_z(@p.d[$69])^;
    if dp=0 then
      exezk:=''
    else
      exezk:=datei_lesen__zu_zk_e(o0+dp,#0,128);
    if exezk<>'' then
      exezk:=in_doppelten_anfuerungszeichen(exezk);
    ausschrift('MS Windows Font '
      +exezk
      +'  ('+str0(breite)+' * '+str0(hoehe)+')'
      +version_x_y(version,0),musik_bild);

    exezk:=puffer_zu_zk_e(p.d[6],#0,$44-6);
    loesche(exezk,'(c)');
    loesche(exezk,'(C)');
    loesche(exezk,'Copyright');
    loesche(exezk,'COPYRIGHT');
    loesche(exezk,'All rights reserved');
    loesche(exezk,'All rights reserved');
    loesche(exezk,'ALL RIGHTS RESERVED');
    loesche(exezk,'ALL RIGHTS RESERV');

    exezk:=leer_filter(exezk);
    exezk:=leer_filter(exezk);
    ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);

    if not ico_anzeige then Exit;

    if Odd(p.d[$42]) then Exit; (* kein Raster *)

    beispiel[4]:=Chr(hoehe div 10+Ord('0'));
    beispiel[5]:=Chr(hoehe mod 10+Ord('0'));
    FillChar(bild,SizeOf(bild),os_2_ico_farbe);
    xs:=0;
    for i:=Low(beispiel) to SizeOf(beispiel)-1 do
      begin
        c:=Ord(beispiel[i]);
        if c<p.d[$5f] then Continue;
        Dec(c,p.d[$5f]);
        case version of
          1,
          2:dp:=$76+4*c;
          3:dp:=$94+6*c;
        end;
        if dp=0 then Continue;
        datei_lesen(dien_puffer,o0+dp,8);
        xe:=word_z(@dien_puffer.d[0])^;
        if xs+xe>64 then Break;
        case version of
          1,
          2:dp:=word_z(@dien_puffer.d[2])^;
          3:dp:=longint_z(@dien_puffer.d[2])^;
        end;
        if dp=0 then Continue;
        for xteil:=1 to (xe+7) shr 3 do
          begin
            datei_lesen(dien_puffer,o0+dp,hoehe);
            Inc(dp,hoehe);
            for y:=0 to hoehe-1 do
              begin
                b:=dien_puffer.d[y];
                for x:=xs+Min(xe,8)-1 downto xs do
                  if Odd(b shr (7-(x-xs))) then
                    bild[x,y]:=bild[x,y] xor $f;
              end;
            Inc(xs,Min(xe,8));
            Dec(xe,Min(xe,8))
          end;
      end;
    schreibe_bild(xs,hoehe,os_2_ico_farbe);
  end;


procedure text_gic_icon;
  var
    w1,w2:word_norm;
  begin
    (* OGEM210.ZIP\OGEM210.ZIP\GEMAPPS\ICONS\*.gic *)
    for w1:=0 to 22-1 do
      begin
        datei_lesen(dien_puffer,w1*42,42);
        for w2:=0 to 40-1 do
          case dien_puffer.d[w2] of
            Ord('0')..Ord('9'):bild[w2,w1]:=dien_puffer.d[w2]-Ord('0');
            Ord('A')..Ord('F'):bild[w2,w1]:=dien_puffer.d[w2]-Ord('A')+10;
          else
            Exit;
          end;
      end;
    schreibe_bild(40,22,os_2_ico_farbe);
  end;

procedure psf1(const p:puffertyp);
  var
    l:longint;
  begin
    with p do
      begin
        if (d[3]<4) or (d[3]>32) then Exit;
        l:=d[3]*256;
        if Odd(d[2]) then
          l:=l*2;
        Inc(l,4);
        if (einzel_laenge<l) then Exit;
        ausschrift('PC Screen Font / H. Peter Anvin [1]',musik_bild);
        anzeige_ega_font(d[3],-8,4,false,false,256);
      end;
  end;

procedure psf2(const p:puffertyp);
  begin
    ausschrift('PC Screen Font / H. Peter Anvin [2]',musik_bild);
    {// nich nicht implementiert}
  end;

procedure amibios_font;
  begin
    ausschrift('AMIBIOS Font',bibliothek);
    befehl_schnitt(analyseoff+4,einzel_laenge-4,erzeuge_neuen_dateinamen('.fn8'));
    anzeige_ega_font(DGT_zu_longint(einzel_laenge) div 256,-8,4,false,false,256);
  end;


procedure einrichten_typ_dien(const anfang:boolean);
  begin
    einrichten_typ_poem(anfang);
  end;

procedure viotbl_dcp_block(const p:puffertyp);
  var
    cp                  :longint;
    x,y,o,a             :word_norm;
  begin
    with p do
      begin
        if d[0]>=$2e then
          begin
            cp:=longint_z(@d[4])^;
            x:=d[10+4];
            y:=d[11+1];
            o:=word_z(@d[2])^;
            a:=word_z(@d[$14])^;
          end
        else
          begin
            cp:=longint_z(@d[4])^;
            x:=d[10];
            y:=d[11];
            o:=word_z(@d[2])^;
            a:=word_z(@d[$12])^;
          end;

        ausschrift('CP'+str_(cp,5)+' : '+str0(x)+' * '+str_(y,2),musik_bild);

        if ico_anzeige then
          case x of
            8:anzeige_ega_font(y,x,o,false,false,a);
            9:anzeige_ega_font(y,x,o,false,true ,a);
          end
      end;
  end;

end.

