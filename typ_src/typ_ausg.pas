(*$I TYP_COMP.PAS*)
unit typ_ausg;

(*$IfDef VirtualPascal*)
(*$Define Benutze_stream *)
(*$EndIf VirtualPascal*)


interface

uses
  (*$IfDef VirtualPascal*)
  VpSysLow,
  (*$EndIf*)
  (*$IfDef Benutze_stream*)
  Objects,
  (*$EndIf Benutze_stream*)
  (*$IfDef OS2*)
  Os2Base,
  Os2Def,
  (*$EndIf*)
  Strings,
  typ_type,
  typ_varx;

type
  ausgabepuffer_typ=
    record
      laenge            :word_norm;
      daten             :array[1..15*80] of char;
    end;


const
  (*$IfDef OS2*)
  benutzereingabe       :TSemHandle     =-1;
  (*$EndIf OS2*)
  sofortanzeige         :boolean=wahr;
  terminal_dateiname    :string='';
  terminal_sichtbare_anzeige:boolean=true;
  geschwindigkeit       :word_norm=0;
  norm_geschwindigkeit  :word_norm=6;
  richtung              :longint=1;
  umgeschaltet          :boolean=falsch;
  speicher_belegt       :boolean=falsch;
  maxzeile              :longint=$7fffffff;
  codepage_str          :string[3+4]='IBM437';


var
  hersteller_gefunden   :boolean;
  herstellersuche       :integer_norm;
  hersteller_erforderlich:boolean;
  leerzeile             :buntzeilen_typ;
  arbeitszeile          :buntzeilen_typ;
  zeilenspeicherung     :boolean;
  zeilenstand           :longint;
  anzeigezeile0         :longint;


procedure erkenne_grafik_adapter;
procedure gotoxy(const x,y:word_norm);
procedure schreibe_zeile(var zi:buntzeilen_typ);
procedure schreibe_monozeile(var zi:buntzeilen_typ;const a:aus_attribute);
procedure hole_zeile(var zi:buntzeilen_typ;const zn:longint);
procedure speicher_anfordern;
procedure speicher_weggeben;
procedure speicher_bericht;

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_far(const txt:string;const attribut:aus_attribute);
const     adr_ausschrift:pointer=@ausschrift_far;
procedure ausschrift(const txt:string;const attribut:aus_attribute);
  inline($ff/$1e/>adr_ausschrift);
(*$Else*)
procedure ausschrift(const txt:string;const attribut:aus_attribute);
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_ttt_far(const txt1,txt2,txt3:string;const attribut:aus_attribute);
const     adr_ausschrift_ttt:pointer=@ausschrift_ttt_far;
procedure ausschrift_ttt(const txt1,txt2,txt3:string;const attribut:aus_attribute);
  inline($ff/$1e/>adr_ausschrift);
(*$Else*)
procedure ausschrift_ttt(const txt1,txt2,txt3:string;const attribut:aus_attribute);
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_v_far(const txt:string);
const     adr_ausschrift_v:pointer=@ausschrift_v_far;
procedure ausschrift_v(const txt:string);
  inline($ff/$1e/>adr_ausschrift_v);
(*$Else*)
procedure ausschrift_v(const txt:string);
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_tab_far(const txt:string);
const     adr_ausschrift_tab:pointer=@ausschrift_tab_far;
procedure ausschrift_tab(const txt:string);
  inline($ff/$1e/>adr_ausschrift_tab);
(*$Else*)
procedure ausschrift_tab(const txt:string);
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_leerzeile_far;
const     adr_ausschrift_leerzeile:pointer=@ausschrift_leerzeile_far;
procedure ausschrift_leerzeile;
  inline($ff/$1e/>adr_ausschrift_leerzeile);
(*$Else*)
procedure ausschrift_leerzeile;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_x_far(const txt:string;const attribut:aus_attribute;anfang:spaltenplatz);
const     adr_ausschrift_x:pointer=@ausschrift_x_far;
procedure ausschrift_x(const txt:string;const attribut:aus_attribute;anfang:spaltenplatz);
  inline($ff/$1e/>adr_ausschrift_x);
(*$Else*)
procedure ausschrift_x(const txt:string;const attribut:aus_attribute;anfang:spaltenplatz);
(*$EndIf*)

procedure ausschrift_ueberschrift_wechsleblock(const txt:string);
procedure bildschirmaufbau;
procedure bildschirmverwaltung(const ein:boolean);
procedure sichere_statuszeile(var s:buntzeilen_typ);
procedure restauriere_statuszeile(const s:buntzeilen_typ);
procedure normalen_statuszeilenanfang(const rest:string);
procedure nachholen;
procedure ruecklauf_warten;
procedure ruecklauf_warten_kurz;
function setze_modus:byte;
procedure schreibe_statuszeile(const s:string;sofort:boolean);
procedure zeile_zu_mono_zk(var zeile:buntzeilen_typ;var zk:ausgabepuffer_typ);
procedure zeile_zu_filter_zk(var zeile:buntzeilen_typ;var zk:ausgabepuffer_typ);
procedure zeile_zu_ansi_zk(var zeile:buntzeilen_typ;var zk:ausgabepuffer_typ);
procedure zeile_zu_html_zk(var zeile:buntzeilen_typ;var zk:ausgabepuffer_typ);
procedure schreiben(const typ:term_typ;const dn:string);

(*$IfDef Benutze_stream*)
procedure schreibe_datei(const f:pBufStream;var was;const wieviel:longint);
(*$Else Benutze_stream*)
procedure schreibe_datei(var f:file;var was;const wieviel:longint);
(*$EndIf Benutze_stream*)

(*$IfDef OS2*)
procedure aktiviere_vioerneuerung;
procedure beende_vioerneuerung;
(*$IfDef TERM_ROLLEN*)
function  ldt_b8xx_anfordern:boolean;
procedure ldt_b8xx_weggeben;
(*$EndIf*)
(*$EndIf*)
procedure ausschrift_nichts_gefunden(const attribut:aus_attribute);
procedure typ_ausg_init;
procedure suche_im_zeilenspeicher(const weitersuchen:boolean);
procedure zeilenpositionierung_plus(const zeilen:longint;const punkte:longint);
procedure zeilenpositionierung_minus(const zeilen:longint;const punkte:longint);
procedure zeilenpositionierung_sprung(const zeile:longint;const punkte:longint);
function ausgabe_umgeleitet:boolean;

procedure einrichten_typ_ausg(const anfang:boolean);

implementation

uses
  (*$IfDef VirtualPascal*)
  VpUtils,
  (*$EndIf VirtualPascal*)
  (*$IfDef DPMIX*)
  crt,???
  (*$EndIf*)
  {$IfDef Win32}
  Windows,
  {$EndIf}
  typ_os,
  typ_takt,
  typ_eing,
  typ_eiau,
  typ_var,
  typ_spra;

const
  (* NC 4.0,FC/2 eine Zeile leer, eine Komandozeile, eine Zeile Funktionstasten *)
  schwarzer_rand_beim_beenden=3;
  attr_schwarzer_rand_beim_beenden=$0720;
  statuszeile_kuerzen   :boolean=falsch;
  zeilen_wechsel        =1;

  vio_show_verzoegerung :longint=50; (* 50+/1000 s *)
  alt_anzeigezeile0     :longint=$8FFFFFFF;
  alt_punktzeile        :longint=0;
  bildschirmseite       :byte=0;
  punktzeile            :longint=0;

  benutze_speicher      :boolean=falsch;
  zeichen_cr            :array[1.. 1] of char=#13;
  zeichen_reset         :array[1..17] of char=#13#9#9#9#9#9#9#9#9#9'      '#13;
  ansi_cls              :array[1.. 4] of char=#27'[2J';
  ansi_reset            :array[1.. 8] of char=#13#27'[0m'#27'[K';
  ansi_gotoxy11         :array[1.. 8] of char=#27'[01;01f';
  ansi_init             :(*Žrger mit 132 Zeilen: array[1.. 5] of char=#27'[=3h';*)
                         array[1.. 4] of char=#27'[2J';
  html_anfang1          :               pchar='<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'#13#10
                                             +'<html><head><title>typ</title>'#13#10
                                             +'<meta http-equiv="Content-Type" content="text/html; charset=';
  html_anfang2          :               pchar='">'#13#10
                                             +'<!-- Typ -->'#13#10
                                             +'</head><body><pre>'#13#10;
  html_ende             :               pchar='</pre></body></html>'#13#10;


(*  zeilen_laenge         :word_norm           =80*2;*)

  zeilenbreite          :word_norm=80;
  nutzbare_zeilenbreite :word_norm=80;

  unendlich_zeichen     :byte=236; (* ì *)

  (*$IfNDef Linux*)
  nul_dev               ='\DEV\NUL';
  (*$Else*)
  nul_dev               ='/dev/null';
  (*$EndIf*)

var
  suche_im_zeilenspeicher_zeichenkette:string;
  zeilenaenderung       :boolean;
  ausgabepuffer         :ausgabepuffer_typ;
  (*$IfDef Benutze_stream*)
  terminal_datei        :pBufStream;
  (*$Else Benutze_stream*)
  terminal_datei        :file;
  (*$EndIf Benutze_stream*)


(*$IfDef OS2*)
const
  (*$IfDef TERM_ROLLEN*)
  screen_handhabe       :longint        =0;
  b8xxx_sel             :smallword      =0;
  lock_Status           :byte           =lock_Fail;
  weggeschaltet         :boolean        =false;
  (*$EndIf*)
  vio_thread_id         :longint=0;
  vio_thread_zustand    :(darf_laufen,soll_beenden,ist_beendet)=ist_beendet;
  vio_thread_sinnvoll   :boolean=false;
(*$EndIf*)




(*$IfDef TYP_DOS*)
type
  xmm_register_typ=
    record
      _ax,_bx,_cx,_dx,_si:word;
    end;
(*$EndIf*)

const
  (*$IfDef DOS*)
  Seg0040=$0040;
  SegB800=$b800;
  (*$EndIf*)

  max_bzeilen=60;

  (*$IfDef TERM_ROLLEN*)
  crtc=$3d4;
  (*$EndIf*)

  (*$IfDef TYP_DOS*)
  speichermax           =   30;
  (*$Else*)
  speichermax           =  100;
  (*$EndIf*)

  sp_keiner             =    0;
  (*$IfDef TYP_DOS*)
  sp_dos                =    1;
  sp_xms                =    2;
  sp_ems                =    3;
  (*$EndIf*)

  (*$IfDef TYP_DPMI*)
  sp_pas                =    4;
  (*$EndIf*)

  (*$IfDef TYP_DPMI32*)
  sp_pas                =    4;
  (*$EndIf*)

  (*$IfDef TYP_LNX*)
  sp_pas                =    4;
  (*$EndIf*)

  (*$IfDef TYP_OS2*)
  sp_pas                =    4;
  (*$EndIf*)

  (*$IfDef TYP_W32*)
  sp_pas                =    4;
  (*$EndIf*)

  (*$IfDef DOS*)
  emmsig                :array[1..8] of char='þþTYPþþþ';
  xmm_treiber           :pointer=nil;
  ems_handhabe          :word=0;
  xmm_handhabe          :word=0;
  (*$EndIf*)

  virus_gefunden        :boolean=false;

var
  zeichen_hoehe         :byte;
  (*$IfDef TERM_FARBIG*)
  (*$IfDef OS2*)

  viopuffer             :^maxbildschirm_typ=nil;
  viopuffer_p           :pointer absolute viopuffer;
  viopuffer_groesse     :word;
  vio_fehler            :longint;
  viopuffer_GetMem      :boolean=false;

  (*$EndIf OS2*)
  (*$EndIf TERM_FARBIG*)
  aktive_seite          :byte;
  bildschirmbyte        :word_norm;
  speicherverwaltungs_nutzung:word_norm;
  statuszeile           :^buntzeilen_typ;
  statuszeile_indirekt  :buntzeilen_typ;
  umschalter0           :^buntzeilen_typ;
  umschalter1           :^buntzeilen_typ;
  umschalter2           :^buntzeilen_typ;
  viopuffer_anzahl_spalten:word_norm;
  bildschirmpuffer      :array[1..70] of buntzeilen_typ;
  speicherverwaltung:
    array[1..speichermax] of
      record
        sorte           :byte;
        (*$IfDef KEINE_SEGMENTE*)
        offset          :longint;
        (*$Else*)
        segment         :word;
        offset          :word;
        (*$EndIf*)
        groesse         :longint;
        startzahl,endzahl:longint;
      end;

  (*$IfDef TYP_DOS*)
  ems_kopierer:
    record
      laenge            :longint;
      quelltyp          :byte;      (* 00 konventionell, 01 EMS *)
      quellhandhabe     :word;      (* 0000 konventionell *)
      quelloff          :word;      (* zu Rahmen, Segment *)
      quellseg          :word;      (* logische EMS-Seite, Segment *)
      zieltyp           :byte;
      zielhandhabe      :word;
      zieloff           :word;
      zielseg           :word;
    end;


  ems_seiten            :word;
  xmm_off,xmm_seg       :word;

  xmm_kilo              :word;
  xmm_register          :xmm_register_typ;

  xmm_zu_dat_kopierer:
    record
      wieviel           :longint;
      xmm_handhabe      :word;
      xmm_off           :longint;
      dat_handhabe      :word;
      dat_zeiger        :pointer;
    end;
  dat_zu_xmm_kopierer:
    record
      wieviel           :longint;
      dat_handhabe      :word;
      dat_zeiger        :pointer;
      xmm_handhabe      :word;
      xmm_off           :longint;
    end;
  (*$EndIf*)


procedure erkenne_grafik_adapter;
  begin
    (*$IfDef DOS_ODER_DPMI_ODER_DPMI32*)
    ega_oder_besser     :=false;
    vga                 :=false;

    asm
      mov ah,$12 (* Video Subsystem configuration (EGA/VGA) *)
      mov bl,$10 (* return video configuration information *)
      int $10
      cmp bl,$10
      jne @ega_vga

    @ega_vga:
      mov ega_oder_besser,true

      mov ah,$1A (* Video Display Combination *)
      mov al,$00 (* get *)
      mov bl,$00
      int $10

      cmp bl,7 (* Mono *)
      je @vga
      cmp bl,8 (* Farbe *)
      jne @weiter

    @vga:
      mov vga,true

    @weiter:
    end;

    (*$IfDef VirtualPascal*)
    mono_bei_b000:=(Mem[Seg0040+$0049]=7);
    (*$Else*)
    mono_bei_b000:=(Mem[Seg0040:$0049]=7);
    (*$EndIf*)

    (*$Else*)
    ega_oder_besser     :=true;
    vga                 :=true;
    (*$EndIf*)
  end;

procedure gotoxy(const x,y:word_norm);
  begin
    (*$IfDef DOS_ODER_DPMI*)
    (*$IfNDef ENDVERSION*)
    if not zeilenspeicherung then
      abbruch('GOTOXY nicht erlaubt',abbruch_unerwartete_erscheinung);
    (*$EndIf*)
    if (y=0) or (x=0) then
      runerror(1);

    asm
      mov ah,$02
      mov bh,$00
      mov dh,Byte Ptr y
      mov dl,Byte Ptr x
      sub dx,$0101
      int $10
    end;
    (*$EndIf*)

    (*$IfDef VirtualPascal*)
    SysTVSetCurPos(x-1,y-1);
    (*$EndIf*)

    (*$IfDef DPMIX*)
    Crt.GotoXY(x,y);
    (*$EndIf*)
  end;


procedure ruecklauf_warten;
  begin
    (*$IfDef TERM_ROLLEN*)
    (*$IfDef VirtualPascal*)
    while ((Port[$3da] and $8)=$0) do ;
    while ((Port[$3da] and $1)=$1) do ;
    (*$Else*)
    asm
      mov dx,$3da
      @hori:
      in al,dx
      test al,8
      jz @hori
      @vert:
      in al,dx
      rcr al,1
      jc @vert
    end;
    (*$EndIf*)
    (*$EndIf*)
  end;

procedure ruecklauf_warten_kurz;
  begin
    (*$IfDef TERM_ROLLEN*)
    (*$IfDef VirtualPascal*)
    while ((Port[$3da] and $1)=$1) do ;
    (*$Else*) (* VirtualPascal *)
    asm
      mov dx,$3da
      @vert:
      in al,dx
      rcr al,1
      jc @vert
    end;
    (*$EndIf*) (* VirtualPascal *)
    (*$EndIf*) (* TERM_ROLLEN *)
  end;

procedure anzeigestart(const o:word_norm);
  begin
    (*$IfDef TERM_ROLLEN*)
    (*$IfDef VirtualPascal*)
    (*PortW[crtc]:=Hi(o)*$100+$000c;
      PortW[crtc]:=Lo(o)*$100+$000d;*)
    Port[crtc  ]:=$0c;
    Port[crtc+1]:=Hi(o);
    Port[crtc  ]:=$0d;
    Port[crtc+1]:=Lo(o);
    (*$Else*)
    asm
      mov bx,o
      mov dx,crtc
      mov al,$0c        (* CRTC: hi(Startaddresse Video) *)
      out dx,al
      mov al,bh
      inc dx
      out dx,al
      dec dx
      mov al,$0d        (* CRTC: lo(Startaddresse Video) *)
      out dx,al
      inc dx
      mov al,bl
      out dx,al
    end;
    (*$EndIf*)

    (* "BIOS-Variable nachbessern" *)
    (*$IfDef VirtualPascal*)
      (*$IfDef DPMI32*)
      MemW[Seg0040+$004e]:=o;
      (*$EndIf*)
    (*$Else*)
      MemW[seg0040:$004e]:=o;
    (*$EndIf*)

    (*$EndIf*)
  end;

procedure setze_punkt_zeile(const b:byte);
  begin
    (*$IfDef TERM_ROLLEN*)
    (*PortW[crtc]:=8+b shl 8;*)
    Port[crtc  ]:=8;
    Port[crtc+1]:=b;
    (*$EndIf*)
  end;

procedure statuszeile_unten(const u:boolean);
  var
    splitzeile          :word_norm;
    (*$IfDef VirtualPascal*)
    temp                :word_norm;
    (*$EndIf*)
  begin
    (*$IfDef TERM_ROLLEN*)
    if u then
      splitzeile:=(word(bzeilen)-1)*zeichen_hoehe-1
    else
      splitzeile:=word(bzeilen)*zeichen_hoehe-1;

    (*$IfDef VirtualPascal*)
    Port[crtc  ]:=$18;
    Port[crtc+1]:=Lo(splitzeile);

    Port[crtc  ]:=$07;
    temp:=Port[crtc+1];
    temp:=temp and (not bit04) or (Hi(splitzeile) and 1) shl 4;
    Port[crtc  ]:=$07;
    Port[crtc+1]:=temp;

    Port[crtc  ]:=$09;
    temp:=Port[crtc+1];
    temp:=temp and (not bit06) or (Hi(splitzeile) and 2) shl 5;
    Port[crtc  ]:=$09;
    Port[crtc+1]:=temp;
    (*$Else*)
    asm
      mov dx,crtc

      (* $18 *)
      mov al,$18
      out dx,al                   (* "Index fr Line Compare Register" *)

      mov al,byte ptr [splitzeile]
      inc dx
      out dx,al                   (* "Lowbyte laden" *)
      dec dx

      (* $07 *)
      mov al,$07
      out dx,al                   (* "Index: Overflow Register" *)

      inc dx
      in al,dx                    (* Line Compare-Bit 8 :=splitzeile and $100 =$100*)
      dec dx

      mov ah,byte ptr [splitzeile+1]
      and ah,$01
      shl ah,4

      and al,($ff-bit04)          (* -> Overflow-Bit 4 *)
      or ah,al

      mov al,$07
      out dx,al
      mov al,ah
      inc dx
      out dx,al
      dec dx

      (* $09 *)
      mov al,$09                  (* "Index: Maximum Scanline Register" *)
      out dx,al

      mov ax,splitzeile
      and ah,$02
      shl ah,5
      inc dx
      in al,dx
      dec dx
      and al,($ff-$40)            (* Line Compare-Bit 9 :=splitzeile and $200=$200 *)
      or ah,al                    (* "also Max. Scanline-Bit 6" ..  *)

      mov al,$09
      out dx,al
      mov al,ah
      inc dx
      out dx,al
      dec dx

    end;
    (*$EndIf*)

    (*$EndIf TERM_ROLLEN*)
  end;

(*$IfDef TYP_DOS*)
procedure xmm_ruf(var xr:xmm_register_typ);assembler;
  asm
    les di,xr
    mov ax,es:[di].xmm_register_typ._ax
    mov bx,es:[di].xmm_register_typ._bx
    mov cx,es:[di].xmm_register_typ._cx
    mov dx,es:[di].xmm_register_typ._dx
    mov si,es:[di].xmm_register_typ._si
    call xmm_treiber
    les di,xr
    mov es:[di].xmm_register_typ._ax,ax
    mov es:[di].xmm_register_typ._bx,bx
    mov es:[di].xmm_register_typ._cx,cx
    mov es:[di].xmm_register_typ._dx,dx
    mov es:[di].xmm_register_typ._si,si
  end;
(*$EndIf*)

procedure speicherverwaltung_initialisieren;
  begin
    FillChar(speicherverwaltung,SizeOf(speicherverwaltung),0);
    speicherverwaltungs_nutzung:=0;
  end;

function bestimme_speichersorte(const n:longint):word_norm;
  var
    speicher            :word_norm;
  begin
    speicher:=1;

    repeat
      if  (speicherverwaltung[speicher].startzahl<=n)
      and (speicherverwaltung[speicher].endzahl  >=n)
       then
        begin
          bestimme_speichersorte:=speicher;
          Exit;
        end;
      Inc(speicher);
    until speicher>speichermax;

    abbruch('kann existierende Zeilennummer keiner Speichersorte zuordnen',abbruch_unerwartete_erscheinung);
  end;


procedure zk_zu_buntzeile(const zk:string;const farbe:aus_attribute;var z:buntzeilen_typ);

  var
    (*$IfDef DUMM*)
    zae                 :byte;
    maxz                :byte;
    (*$EndIf*)
    maxz                :word_norm;
    farbe_b             :byte;

  begin

    farbe_b:=ftab.f[farbe,vf]+ftab.f[farbe,hf];
    maxz:=Length(zk);
    if maxz>80{} then maxz:=80{};

    (*$IfDef DUMM*)
    fuell_word(z,80{},word(farbe_b)*$100+Ord(' '));
    for zae:=1 to maxz do
      z[zae,1]:=Ord(zk[zae]);
    (*$EndIf*)

    (*$IfDef DOS_ODER_DPMI*)
    asm
      push ds
        lds si,zk
        les di,z
        mov ah,[farbe_b]
        cld
        inc si
        mov cx,maxz
        mov dx,80{}
        sub dx,cx
        test cx,cx
        jz @esl1
    @sl1:
        lodsb
        stosw
        dec cx
        jnz @sl1

    @esl1:
        mov cx,dx
        mov al,' '
        rep stosw

      pop ds
    end;
    (*$EndIf*)

    (*$IfDef VirtualPascal*)
    asm (*$Alters EAX,ECX,EDX,ESI,EDI*)
      mov esi,[zk]
      mov edi,[z]
      mov ah,[farbe_b]
      cld
      inc esi
      mov ecx,[maxz]
      mov edx,80{}
      sub edx,ecx
      test ecx,ecx
      jz @esl1
    @sl1:
      lodsb
      stosw
      dec ecx
      jnz @sl1

    @esl1:
      mov ecx,edx
      mov al,' '
      mov edx,eax
      shl eax,16
      mov ax,dx
      shr ecx,1
      jnc @nostosw
      stosw
    @nostosw:
      rep stosd
    end;
    (*$EndIf*)
  end;

procedure schreibe_monozeile(var zi:buntzeilen_typ;const a:aus_attribute);
  var
    farbe               :byte;
    sp                  :word_norm;
  begin
    farbe:=ftab.f[a,vf]+ftab.f[a,hf];
    for sp:=Low(zi) to High(zi) do
      zi[sp][2]:=farbe;
    schreibe_zeile(zi);
  end;

procedure schreibe_zeile(var zi:buntzeilen_typ);
  var
    speicher            :byte;
    li                  :longint;
    hp                  :pointer;
    ems_fehler          :byte;

  begin
    if herstellersuche=1 then
      hersteller_gefunden:=wahr;

    if zeilenstand>=maxzeile then Exit;


    zeilenaenderung:=wahr;

    if zeilenstand=maxzeile-1 then
      zk_zu_buntzeile(textz_Speicher_voll_keine_weitere_Bearbeitung^,dat_fehler,zi);

    Inc(zeilenstand);
    if (anzeigezeile0<zeilenstand) and (zeilenstand<anzeigezeile0+bzeilen+zeilen_wechsel+1) then
      bildschirmpuffer[zeilenstand-anzeigezeile0]:=zi;

    case term of
      (*$IfDef TERM_ROLLEN*)
      term_rollen,
      (*$EndIf*)

      (*$IfDef TERM_FARBIG*)
      term_farbig:
        begin

          speicher:=bestimme_speichersorte(zeilenstand);

          case speicherverwaltung[speicher].sorte of
            (*$IfDef TYP_DOS*)
            sp_dos   :
              begin
                li:=longint(speicherverwaltung[speicher].segment)*16
                 +longint(zeilenstand-speicherverwaltung[speicher].startzahl)*SizeOf(zi);
                 Move(zi,
                     Ptr(word(li shr 4),word(li and $F))^,
                     SizeOf(zi));
              end;
            sp_xms   :
              begin
                dat_zu_xmm_kopierer.wieviel:=SizeOf(zi);
                dat_zu_xmm_kopierer.dat_handhabe:=0;
                dat_zu_xmm_kopierer.xmm_handhabe:=xmm_handhabe;

                dat_zu_xmm_kopierer.dat_zeiger:=@zi;
                dat_zu_xmm_kopierer.xmm_off:=longint(zeilenstand
                 -speicherverwaltung[speicher].startzahl)*SizeOf(buntzeilen_typ);
                xmm_register._ax:=$0B00;
                (* xmm_register._ds:=seg(dat_zu_xmm_kopierer); *)
                xmm_register._si:=ofs(dat_zu_xmm_kopierer);
                xmm_ruf(xmm_register);
                if xmm_register._ax<>$0001 then
                  abbruch(textz_Fehler_waehrend_Kopieren_konventioneller_Speicher_XMS^,abbruch_unerwartete_erscheinung);
              end;
            sp_ems   :
              begin
                with ems_kopierer do
                  begin
                    laenge:=SizeOf(zi);
                    quelltyp:=0;
                    quellhandhabe:=0;
                    quelloff:=Ofs(zi);
                    quellseg:=Seg(zi);
                    zieltyp:=1;
                    zielhandhabe:=ems_handhabe;
                    li:=longint(zeilenstand-speicherverwaltung[speicher].startzahl)*SizeOf(zi);
                    zieloff:=li and $3fff; (* mod $4000 *)
                    zielseg:=li shr    14; (* div $4000 *)
                  end;
                asm
                  mov ah,$57 (* Kopieren *)
                  mov al,$00 (* nur Kopieren *)
                  mov bx,seg ems_kopierer
                  mov cx,offset ems_kopierer
                  push ds
                  mov ds,bx
                  mov si,cx
                  int $67
                  pop ds
                  mov ems_fehler,ah
                end;
                if ems_fehler<>0 then
                  abbruch(textz_Fehler_waehrend_Kopieren_konventioneller_EMS_Speicher_int_67_AH57^
                   ,abbruch_unerwartete_erscheinung);
              end;
            (*$Else*)
            sp_pas   :
              begin
                (*$IfDef KEINE_SEGMENTE*)
                Move(zi,Ptr(
                     speicherverwaltung[speicher].offset+
                     longint(zeilenstand-speicherverwaltung[speicher].startzahl)*SizeOf(zi))^
                     ,SizeOf(zi));
                (*$Else*)
                Move(zi,Ptr(speicherverwaltung[speicher].segment,
                     speicherverwaltung[speicher].offset+
                     longint(zeilenstand-speicherverwaltung[speicher].startzahl)*SizeOf(zi))^
                     ,SizeOf(zi));
                (*$EndIf*)

              end;
            (*$EndIf*)
            end;
          bildschirmaufbau;
        end;
      (*$EndIf*)

      term_ansi:
        begin
          zeile_zu_ansi_zk(zi,ausgabepuffer);
          (*$IfDef Benutze_stream*)
          terminal_datei^.Write(ausgabepuffer.daten,ausgabepuffer.laenge);
          if terminal_sichtbare_anzeige and sofortanzeige then terminal_datei^.Flush;
          (*$Else Benutze_stream*)
          BlockWrite(terminal_datei,ausgabepuffer.daten,ausgabepuffer.laenge);
          (*$EndIf Benutze_stream*)
          schreibe_statuszeile('',falsch);
        end;

      term_mono:
        begin
          zeile_zu_mono_zk(zi,ausgabepuffer);
          (*$IfDef Benutze_stream*)
          terminal_datei^.Write(ausgabepuffer.daten,ausgabepuffer.laenge);
          if terminal_sichtbare_anzeige and sofortanzeige then terminal_datei^.Flush;
          (*$Else Benutze_stream*)
          BlockWrite(terminal_datei,ausgabepuffer.daten,ausgabepuffer.laenge);
          (*$EndIf Benutze_stream*)
          schreibe_statuszeile('',falsch);
        end;

      term_gefiltert:
        begin
          zeile_zu_filter_zk(zi,ausgabepuffer);
          (*$IfDef Benutze_stream*)
          terminal_datei^.Write(ausgabepuffer.daten,ausgabepuffer.laenge);
          if terminal_sichtbare_anzeige and sofortanzeige then terminal_datei^.Flush;
          (*$Else Benutze_stream*)
          BlockWrite(terminal_datei,ausgabepuffer.daten,ausgabepuffer.laenge);
          (*$EndIf Benutze_stream*)
          schreibe_statuszeile('',falsch);
        end;

      term_html:
        begin
          zeile_zu_html_zk(zi,ausgabepuffer);
          (*$IfDef Benutze_stream*)
          terminal_datei^.Write(ausgabepuffer.daten,ausgabepuffer.laenge);
          if terminal_sichtbare_anzeige and sofortanzeige then terminal_datei^.Flush;
          (*$Else Benutze_stream*)
          BlockWrite(terminal_datei,ausgabepuffer.daten,ausgabepuffer.laenge);
          (*$EndIf Benutze_stream*)
          schreibe_statuszeile('',falsch);
        end;

    (*$IfNDef ENDVERSION*)
    else
      abbruch('unbekannter Bildschirmtyp',abbruch_unerwartete_erscheinung);
    (*$EndIf*)
    end;
  end;

procedure hole_zeile(var zi:buntzeilen_typ;const zn:longint);
  var
    speicher            :byte;
    li                  :longint;
    (*$IfDef TYP_DOS*)
    ems_fehler          :byte;
    (*$EndIf TYP_DOS*)
  begin

    if zn>zeilenstand then
      begin
        zi:=leerzeile;
        Exit;
      end;

    speicher:=bestimme_speichersorte(zn);

    case speicherverwaltung[speicher].sorte of
      (*$IfDef DOS*)
      sp_dos   :
        begin
          li:=longint(speicherverwaltung[speicher].segment)*16
           +longint(zn-speicherverwaltung[speicher].startzahl)*SizeOf(zi);
          Move(ptr(word(li shr 4),word(li and $F))^,zi,SizeOf(zi));
        end;
      sp_xms   :
        begin
          xmm_zu_dat_kopierer.wieviel:=SizeOf(zi);
          xmm_zu_dat_kopierer.dat_handhabe:=0;
          xmm_zu_dat_kopierer.xmm_handhabe:=xmm_handhabe;

          xmm_zu_dat_kopierer.dat_zeiger:=@zi;
          xmm_zu_dat_kopierer.xmm_off:=longint(zn-speicherverwaltung[speicher].startzahl)*SizeOf(zi);
          xmm_register._ax:=$0B00;
          (* xmm_register._ds:=seg(xmm_zu_dat_kopierer); *)
          xmm_register._si:=ofs(xmm_zu_dat_kopierer);
          xmm_ruf(xmm_register);
          if xmm_register._ax<>$0001 then
            abbruch(textz_Fehler_waehrend_Kopieren_XMS_konventioneller_Speicher^,abbruch_unerwartete_erscheinung);
        end;
      sp_ems   :
        begin
          with ems_kopierer do
            begin
              laenge:=SizeOf(zi);
              zieltyp:=0;
              zielhandhabe:=0;
              zieloff:=ofs(zi);
              zielseg:=seg(zi);
              quelltyp:=1;
              quellhandhabe:=ems_handhabe;
              li:=longint(zn-speicherverwaltung[speicher].startzahl)*SizeOf(zi);
              quelloff:=li and $3fff; (* mod $4000 *)
              quellseg:=li shr    14; (* div $4000 *)
            end;
          asm
            mov ah,$57 (* Kopieren *)
            mov al,$00 (* nur Kopieren *)
            mov bx,seg ems_kopierer
            mov cx,offset ems_kopierer
            push ds
            mov ds,bx
            mov si,cx
            int $67
            pop ds
            mov ems_fehler,ah
          end;
          if ems_fehler<>0 then
            abbruch(textz_Fehler_waehrend_Kopieren_EMS_konventioneller_Speicher_int_67_AH57^,abbruch_unerwartete_erscheinung);
        end;
      (*$Else*)
      sp_pas   :
        begin
          (*$IfDef KEINE_SEGMENTE*)
          Move(ptr(speicherverwaltung[speicher].offset+longint(zn-speicherverwaltung[speicher].startzahl)*SizeOf(zi))^,
               zi,SizeOf(zi));
          (*$Else*)
          Move(ptr(speicherverwaltung[speicher].segment,
               speicherverwaltung[speicher].offset+longint(zn-speicherverwaltung[speicher].startzahl)*SizeOf(zi))^,
               zi,SizeOf(zi));
          (*$EndIf*)
        end;
      (*$EndIf*)
    end;
  end;

(*$IfDef DOS*)
procedure speicher_anfordern;
  var
    org_umb             :word;
    org_strat           :word;
    paragr              :word;
    emm_treiber         :file;
    start_segment       :word;
    emm_suche           :word;
  begin
    maxzeile:=0; (* wenn Speicher benutzt wird: nur begrenzt viele Zeilen *)

    asm
      mov ah,$58 (* UMB Status sichern *)
      mov al,$02
      int $21
      mov ah,00
      mov org_umb,ax
      mov ah,$58
      mov al,$03 (* UMB dazu *)
      mov bx,$0001
      int $21

      mov ax,$5800 (* Strategie sichern *)
      int $21
      mov org_strat,ax

      mov ax,$5801 (* Strategie setzen *)
      mov bx,$0081 (* m”glichst auch besten hohen Speicher *)
      int $21
    end;

    repeat
      inc(speicherverwaltungs_nutzung);
      asm
        mov ah,$48
        mov bx,$ffff
        int $21
        mov paragr,bx
      end;

      if longint(paragr)*16<SizeOf(buntzeilen_typ) then break;
      asm
        mov ah,$48
        mov bx,paragr
        int $21
        jnc @speicher_anforderung_fehlerfrei
        mov ax,0
        @speicher_anforderung_fehlerfrei:
        mov start_segment,ax
      end;

      if start_segment=0 then
        abbruch(textz_konventionellen_Speicher_nicht_bekommen_obwohl_genug_frei_gewesen_sein_sollte^
        ,abbruch_unerwartete_erscheinung);

      with speicherverwaltung[speicherverwaltungs_nutzung] do
        begin
          groesse:=longint(paragr)*16;
          segment:=start_segment;
          sorte:=sp_dos;
          startzahl:=maxzeile+1;
          inc(maxzeile,word(groesse div SizeOf(buntzeilen_typ)));
          endzahl:=maxzeile;
        end;
    until falsch;

    asm
      mov ah,$58 (* UMB Status zurck *)
      mov al,$03
      mov bx,org_umb
      int $21

      mov ax,$5801 (* Strategie rcksetzen *)
      mov bx,org_strat
      int $21
    end;
    (*ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ[ XMS ]ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ*)
    xmm_kilo:=0;
    xmm_handhabe:=0;
    xmm_off:=0;
    xmm_seg:=0;

    if xms_grenze>0 then
      begin
        asm
          mov ax,$4300
          int $2F
          mov bx,$0000
          mov es,bx
          cmp al,$80
          jnz @xmm_ende (* kein XMS installiert *)

          mov ax,$4310 (* Adresse *)
          mov bx,$0000
          push bx
          pop es
          int $2F

          @xmm_ende:
          mov xmm_off,bx
          mov xmm_seg,es
        end;
        xmm_treiber:=ptr(xmm_seg,xmm_off);
        if xmm_treiber<>nil  then
          begin
            xmm_register._ax:=$0800; (* Wieviel ist frei? *)
            xmm_register._bx:=$0000;
            xmm_ruf(xmm_register);

            (* fehlerfrei , Speicher frei? *)
            if (lo(xmm_register._bx)=$00) and (xmm_register._ax>0) then
              begin
                xmm_kilo:=xmm_register._ax;
                if xmm_kilo>xms_grenze then xmm_kilo:=xms_grenze;
                xmm_register._ax:=$0900; (* Anfo *)
                xmm_register._dx:=xmm_kilo; (* alles ... *)
                xmm_ruf(xmm_register);

                if xmm_register._ax=$0001 then
                  begin
                    xmm_handhabe:=xmm_register._dx;
                    with speicherverwaltung[speicherverwaltungs_nutzung] do
                      begin
                        groesse:=longint(xmm_kilo)*1024;
                        segment:=0;
                        sorte:=sp_xms;
                        startzahl:=maxzeile+1;
                        inc(maxzeile,groesse div SizeOf(buntzeilen_typ));
                        endzahl:=maxzeile;
                      end;
                    inc(speicherverwaltungs_nutzung);
                  end
                else
                  xmm_kilo:=0; (* hat nicht geklappt *)
              end;
          end;
      end;

    (*ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ[ EMS ]ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ*)
    if ems_grenze>0 then
      begin
        Assign(emm_treiber,'EMMXXXX0');
        (*$I-*)
        Reset(emm_treiber);
        (*$I+*)
        emm_suche:=IOResult;

        if emm_suche<>0 then
          begin
            Assign(emm_treiber,'EMMQXXX0');
            (*$I-*)
            Reset(emm_treiber);
            (*$I+*)
            emm_suche:=IOResult;
          end;

        if emm_suche=0 then
          begin
            (*$I-*)
            Close(emm_treiber);
            (*$I+*)
            fehler:=IOResult; (* ignorieren *)
            asm
              mov ah,$46
              int $67
              cmp ax,$0040 (* EMS=4.0? *)
              jl @ems_ende

              mov ah,$42 (* wieviel ist frei? *)
              int $67
              cmp ah,$00
              jnz @ems_ende
              (* -> BX Seiten frei *)
              mov ems_seiten,bx
              cmp ems_grenze,bx
              jnl @wenig

              mov bx,ems_grenze
              mov ems_seiten,bx

              @wenig:
              cmp bx,$0000
              jz @ems_ende

              mov ah,$43
              (* BX seiten anfordern *)
              int $67
              cmp ah,$00
              jnz @ems_ende
              mov ems_handhabe,dx

              mov ah,$53 (* Handhabe Name *)
              mov al,$01 (* setzen *)
              mov dx,ems_handhabe
              mov bx,seg emmsig
              mov cx,offset emmsig
              push ds
              push si
              mov ds,bx
              mov si,cx
              int $67
              pop si
              pop ds

              @ems_ende:
            end;
            if ems_handhabe<>0 then
              begin
                with speicherverwaltung[speicherverwaltungs_nutzung] do
                  begin
                    groesse:=longint(ems_seiten)*16384;
                    segment:=0;
                    sorte:=sp_ems;
                    startzahl:=maxzeile+1;
                    inc(maxzeile,groesse div SizeOf(buntzeilen_typ));
                    endzahl:=maxzeile;
                  end;
                Inc(speicherverwaltungs_nutzung);
              end;
          end;
      end;

    speicherverwaltung[speicherverwaltungs_nutzung].sorte:=sp_keiner;
    speicher_belegt:=wahr;
  end;
(*$Else*)
procedure speicher_anfordern;
  var
    p                   :^buntzeilen_typ;
    zz                  :longint;
    hp                  :pointer;
    org_heaperror       :pointer;
    (*$IfNDef ENDVERSION*)
    g0,g1,g2,rc         :longint;
    (*$EndIf*)

  begin
    maxzeile:=0; (* wenn Speicher benutzt wird nur begrenzt viele Zeilen *)
    Inc(speicherverwaltungs_nutzung);
    zz:=MaxAvail;

    (* gleich nach OS/2 Warp4 Fix 5 "SWAPPATH=H:\ 50000 51000" aber nur 38 MB frei *)
    if zz<250000 then
      begin
        (*$IfDef VirtualPascal*)
        if DebugHook then asm int 3 end;
        (*$EndIf*)
        abbruch('MaxAvail='+str0(zz)+' -> CONFIG.SYS SWAPPATH=X:\ MINFREE DEFAULT!',abbruch_unerwartete_erscheinung);
      end;

    (* Heapmanager abziehen *)
    if zz>200000 then
      Dec(zz,200000)
    else
      zz:=0;

    if pas_grenze*1024>zz then
      pas_grenze:=zz div 1024;

    while (MaxAvail>SizeOf(buntzeilen_typ)*5)
      and (speicherverwaltungs_nutzung<speichermax)
      and (longint(pas_grenze)*1024>=longint(maxzeile)*SizeOf(buntzeilen_typ)) do
      begin
        with speicherverwaltung[speicherverwaltungs_nutzung] do
          begin
            sorte:=sp_pas;
            groesse:=Max(MaxAvail,4096);
            Dec(groesse,4096);

            (*$IfNDef VirtualPascal*)
            if groesse>$ffff then
              groesse:=($ffff div SizeOf(buntzeilen_typ))*SizeOf(buntzeilen_typ);
            (*$EndIf*)
            if groesse+longint(maxzeile)*SizeOf(buntzeilen_typ)>longint(pas_grenze)*1024 then
              groesse:=longint(pas_grenze)*1024-longint(maxzeile-5)*SizeOf(buntzeilen_typ);

            if groesse<=0 then
              begin
                (*$IfDef VirtualPascal*)
                if DebugHook then asm int 3 end;
                (*$EndIf*)
                Break;
              end;

            GetMem(hp,groesse);

            if hp=nil then
              Abbruch('konventionellen Speicher nicht bekommen obwohl genug frei gewesen sein sollte'
              ,abbruch_unerwartete_erscheinung);

            (*$IfNDef KEINE_SEGMENTE*)
            segment:=Seg(hp^);
            (*$EndIf*)
            offset:=Ofs(hp^);
            startzahl:=maxzeile+1;
            Inc(maxzeile,groesse div SizeOf(buntzeilen_typ));
            endzahl:=maxzeile;
          end;
        Inc(speicherverwaltungs_nutzung);
      end;

    speicher_belegt:=wahr;
  end;
(*$EndIf*)

procedure speicher_weggeben;
  var
    z                   :word_norm;
  begin
    (*$IfDef DOS*)
    if xmm_handhabe<>0 then
      begin
        xmm_register._ax:=$0A00; (* XMS weggeben *)
        xmm_register._dx:=xmm_handhabe;
        xmm_ruf(xmm_register);
        (* hier wird nicht mehr auf Fehler geachtet *)
      end;
    if ems_handhabe<>0 then
      asm
        mov ah,$45
        mov dx,ems_handhabe
        int $67
      end;
    (*$Else*)
      (*$IfDef SPEICHER_FREIGEBEN*)
      for z:=Low(speicherverwaltung) to speicherverwaltungs_nutzung do
        with speicherverwaltung[z] do
          case sorte of
            sp_pas:
              begin
                Dispose(@Mem[offset]);
                offset:=0;
              end;
          end;

      (*$EndIf*)
    (*$EndIf*)
    speicher_belegt:=false;
  end;

procedure speicher_bericht;
  var
    sps                 :byte;
  begin
    ausschrift_v(textz_klammer_Speichernutzung_klammer^);
    ausschrift_x('ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿',signatur,anstrich);
    ausschrift_x('³    '+textz_speicher__sorte^+'     ³ '
                    +textz_speicher__bei_Handhabe^+' ³      '+textz_speicher__Blockgroesse^+'       ³    '
                    +textz_speicher__Zeilen^+'    ³',signatur,leer);
    ausschrift_x('ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´',signatur,leer);
    sps:=0;
    repeat
      inc(sps);
      with speicherverwaltung[sps] do
        begin
          case sorte of
            sp_keiner:break;

            (*$IfDef DOS*)
            sp_dos:ausschrift_x('³ '+textz_konventionell^+' ³     '
            +hex_word(segment)
            +'    ³   '+str_(groesse shr 4,5)+' '+textz_Paragraphen^+' ³'
            +str_(groesse div SizeOf(buntzeilen_typ),10)+'    ³'
            ,signatur,leer);

            sp_xms:ausschrift_x('³ XMS           ³     '
            +hex_word(xmm_handhabe)
            +'    ³   '+str_(xmm_kilo  ,5)                            +' '+textz_Kilo^+'          ³'
            +str_(groesse div SizeOf(buntzeilen_typ),10)+'    ³'
            ,signatur,leer);

            sp_ems:ausschrift_x('³ EMS           ³     '
            +hex_word(ems_handhabe)
            +'    ³   '+str_(ems_seiten,5)                            +' '+textz_Seiten^+' ³'
            +str_(groesse div SizeOf(buntzeilen_typ),10)+'    ³'
            ,signatur,leer);
            (*$Else*)

            sp_pas:ausschrift_x('³ Pascal/Heap   ³  '
            (*$IfDef KEINE_SEGMENTE*)
            +hex_longint(offset)
            (*$Else*)
            +hex_word(segment)+':'+hex_word(offset)
            (*$EndIf*)
            +'   ³  '+str_(groesse,9)                                 +' '+textz_ausg__Byte^+' ³'
            +str_(groesse div SizeOf(buntzeilen_typ),10)+'    ³'
            ,signatur,leer);

            (*$EndIf*)
          end;
      end;
    until falsch;
    ausschrift_x('ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ',signatur,leer);
  end;

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_far(const txt:string;const attribut:aus_attribute);assembler;
  asm
    les di,txt
    push es
      push di

        mov al,attribut
        cbw
        push ax

          push anstrich

            (* call ausschrift_x *)
            push cs
            call near ptr ausschrift_x_far
  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
procedure ausschrift(const txt:string;const attribut:aus_attribute);assembler;
(*$Frame-*)(*$Uses NONE*)
  asm
    mov al,attribut
    push txt
      push eax
        push anstrich
          call ausschrift_x
  end;
(*$EndIf*)

(*$IfDef DPMIX*)
procedure ausschrift(const txt:string;const attribut:aus_attribute);
  begin
    ausschrift_x(txt,attribut,anstrich);
  end;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_ttt_far(const txt1,txt2,txt3:string;const attribut:aus_attribute);
  begin
    ausschrift_x_far(txt1+txt2+txt3,attribut,anstrich);
  end;
(*$Else*)
procedure ausschrift_ttt(const txt1,txt2,txt3:string;const attribut:aus_attribute);
  begin
    ausschrift_x(txt1+txt2+txt3,attribut,anstrich);
  end;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_v_far(const txt:string);
(*$Else*)
procedure ausschrift_v(const txt:string);
(*$EndIf*)
  begin
    ausschrift_x(txt,normal,vorne);
  end;

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_tab_far(const txt:string);
(*$Else*)
procedure ausschrift_tab(const txt:string);
(*$EndIf*)
  begin
    ausschrift_x('         '+txt,normal,vorne);
  end;

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_leerzeile_far;
(*$Else*)
procedure ausschrift_leerzeile;
(*$EndIf*)
  begin
    ausschrift_x('',normal,vorne);
  end;

procedure ausschrift_ueberschrift_wechsleblock(const txt:string);
  begin
    ausschrift_x('         '+txt,normal,vorne);
    ausschrift_x('         '+Copy('±²±²±²±²±±²±²±²±²±²±²±²±²±²±²±²±²±²±²±²±²±±²±²±²±²±²±²±',1,Length(txt)),normal,vorne);
    ausschrift_leerzeile;
  end;

(*$IfDef DOS_ODER_DPMI*)
procedure ausschrift_x_far(const txt:string;const attribut:aus_attribute;anfang:spaltenplatz);
(*$Else*)
procedure ausschrift_x(const txt:string;const attribut:aus_attribute;anfang:spaltenplatz);
(*$EndIf*)
  var
    farbe               :byte;
    txt2                :string[128];
    lesen               :word_norm;

  procedure zeilenanfang;
    begin
      case anfang of
        (* auch in typ_dien.ansi_anzeige „ndern *)
        anstrich  :txt2:='  þ  ';
        vorne     :txt2:=''     ;
        absatz    :txt2:='  ú  ';
        leer      :txt2:='     ';
        ea_zeichen:txt2:='  *  ';
      end;
    end; (* zeilenanfang *)

  procedure ausschrift_zeile;
    begin

      zk_zu_buntzeile(txt2,attribut,arbeitszeile);
      schreibe_zeile(arbeitszeile);

      case anfang of
        anstrich,
        ea_zeichen:
          anfang:=absatz;
      (*sonst bleibt es so *)
      end;
      zeilenanfang;

    end; (* ausschrift_zeile *)

  procedure virus_markierung;
    begin
      errorlevel:=abbruch_Virus_gefunden;
      virus_gefunden:=true;
      txt2:=txt2+'>>> '+txt+' <<<';
      ausschrift_zeile;

      statuszeile^[33,1]:=19;
      statuszeile^[33,2]:=ftab.f[virus,vf]+ftab.f[virus,hf];
      statuszeile^[34,1]:=19;
      statuszeile^[34,2]:=ftab.f[virus,vf]+ftab.f[virus,hf];
      statuszeile^[35,1]:=19;
      statuszeile^[35,2]:=ftab.f[virus,vf]+ftab.f[virus,hf];
    end; (* virus_markierung *)


  begin (* ausschrift_x *)

    farbe:=ftab.f[attribut,vf]+ftab.f[attribut,hf];

    lesen:=1;
    zeilenanfang;

    if (attribut=virus) and (not hilfe_aktiv) then
      begin
        virus_markierung;
        Exit;
      end;


    repeat

      while (lesen<=Length(txt)) and (Length(txt2)<nutzbare_zeilenbreite) do

        case txt[lesen] of
          (*
          #08: ?*)

          #09:
            begin
              Inc(lesen);
              repeat
                Inc(txt2[0]);
                txt2[Length(txt2)]:=' ';
              until (Length(txt2) and 7)=1;
            end;

          #10:
            begin
              Inc(lesen);
              if lesen<=Length(txt) then
                if txt[lesen]=#13 then
                  Inc(lesen);

              Break;
            end;

          #13:
            begin
              Inc(lesen);
              if lesen<=Length(txt) then
                if txt[lesen]=#10 then
                  Inc(lesen);

              Break;
            end;

        else
          Inc(txt2[0]);
          txt2[Length(txt2)]:=txt[lesen];
          Inc(lesen);
        end;

      ausschrift_zeile;

   until lesen>Length(txt);

  end; (* ausschrift_x *)

procedure positionskorrektur;
  begin
    while (punktzeile>=zeichen_hoehe) do
      begin
        Dec(punktzeile,zeichen_hoehe);
        Inc(anzeigezeile0);
      end;

    while (punktzeile<0) do
      begin
        Inc(punktzeile,zeichen_hoehe);
        Dec(anzeigezeile0);
      end;

    if anzeigezeile0+bzeilen>zeilenstand then
      if zeilenstand<bzeilen then
        begin
          anzeigezeile0:=0;
          punktzeile:=0;
        end
      else
        begin
          anzeigezeile0:=zeilenstand-bzeilen+1;
          punktzeile:=0;
        end;

    if anzeigezeile0<0 then
      begin
        anzeigezeile0:=0;
        punktzeile:=0;
      end;
  end;

(*$IfDef OS2*)
procedure VioScrLock1;
  var
    rc                  :ApiRet;
  begin
    if lock_Status=lock_Success then
      Exit;

    rc:=Os2Base.VioScrLock(lockIO_NoWait,lock_Status,0);
    if rc<>0 then RunError(rc);

    if lock_Status<>lock_Success then
      weggeschaltet:=true;
  end;

procedure VioScrUnLock1;
  var
    rc                  :ApiRet;
  begin
    if lock_Status<>lock_Success then
      Exit;

    rc:=Os2Base.VioScrUnLock(0);
    if rc<>0 then
      RunError(rc);

    lock_Status:=lock_Fail;
  end;
(*$EndIf*)

procedure bildschirmaufbau;
  var
    i                   :word_norm;

  begin
    (*$IfDef TERM_FARBIG*) (* also auch bei TERM_ROLLEN *)
    if zeilenspeicherung then
      begin

        if sofortanzeige then
          begin
            positionskorrektur;

            if (alt_anzeigezeile0<>anzeigezeile0) or zeilenaenderung then
              begin

                zeilenaenderung:=wahr;
                (* keine Žnderung *)
                if anzeigezeile0=alt_anzeigezeile0 then
                  (* nichts zu tun *)
                else
                (* 1 Zeile + *)
                if anzeigezeile0=alt_anzeigezeile0+1 then
                  begin
                    Move(bildschirmpuffer[2],
                         bildschirmpuffer[1],
                         SizeOf(buntzeilen_typ)*(bzeilen-1));
                    hole_zeile(bildschirmpuffer[bzeilen],anzeigezeile0+bzeilen)
                  end
                else
                (* 1 Zeile - *)
                if anzeigezeile0+1=alt_anzeigezeile0 then
                  begin
                    Move(bildschirmpuffer[1],
                         bildschirmpuffer[2],
                         SizeOf(buntzeilen_typ)*(bzeilen-1));
                    hole_zeile(bildschirmpuffer[1],anzeigezeile0+1)
                  end
                else
                (* <>(-1,0,1) Zeilen„nderung *)
                  begin
                    for i:=1 to bzeilen do
                      hole_zeile(bildschirmpuffer[i],anzeigezeile0+i);
                  end;


                case term of
                  (*$IfDef TERM_ROLLEN*)
                  term_rollen:
                    begin
                      aktive_seite:=aktive_seite xor 1;
                      (*$IfNDef OS2*)
                      ruecklauf_warten;
                      (*$EndIf*)
                      Move(bildschirmpuffer,
                           (*$IfDef VirtualPascal*)
                           (*$IfDef OS2*)
                           viopuffer^[100*aktive_seite+4+1],
                           (*$Else*)
                           Ptr($b8000+(100*(aktive_seite)+4)*160)^,
                           (*$EndIf*)
                           (*$Else*)
                           Ptr(SegB800,(100*(aktive_seite)+4)*160)^,
                           (*$EndIf*)
                           (bzeilen+zeilen_wechsel)*SizeOf(buntzeilen_typ));

                      (*$IfDef OS2*)
                      VioScrLock1;
                      if lock_Status=lock_Success then
                        begin
                          ruecklauf_warten;
                          aktiviere_vioerneuerung;
                      (*$EndIf OS2*)
                          anzeigestart(((aktive_seite)*100+4)*80{});
                          setze_punkt_zeile(punktzeile mod (zeichen_hoehe*zeilen_wechsel));
                      (*$IfDef OS2*)
                          VioScrUnlock1;
                        end;
                      (*$EndIf OS2*)
                    end;
                  (*$EndIf*)

                  (*$IfDef TERM_FARBIG*)
                  term_farbig:
                    begin
                      (*$IfDef VirtualPascal*)

                        (*$IfDef OS2*)
                        if viopuffer_anzahl_spalten=80 then
                          Move(bildschirmpuffer,
                               viopuffer^,
                               (bzeilen-1)*SizeOf(buntzeilen_typ))
                        else
                          for i:=1 to bzeilen-1 do
                            begin
                              Move(bildschirmpuffer[i],
                                   Ptr(Ofs(viopuffer^)+(i-1)*2*viopuffer_anzahl_spalten)^,
                                   SizeOf(buntzeilen_typ));
                              //<<80->x->spaltenzahl erweitern
                            end;

                        aktiviere_vioerneuerung;
                        (*$EndIf*)

                        (*$IfDef DPMI32*)
                        Move(bildschirmpuffer,
                             SysTVGetSrcBuf^,
                             (bzeilen-1)*SizeOf(buntzeilen_typ));
                        (*$EndIf*)

                        (*$IfDef Win32*)
                        Move(bildschirmpuffer,
                             SysTVGetSrcBuf^,
                             (bzeilen-1)*SizeOf(buntzeilen_typ));
                        SysTVShowBuf(0,(bzeilen-1)*SizeOf(buntzeilen_typ));
                        (*$EndIf*)

                        (*$IfDef Linux*)
                        Move(bildschirmpuffer,
                             SysTVGetSrcBuf^,
                             (bzeilen-1)*SizeOf(buntzeilen_typ));
                        SysTVShowBuf(0,(bzeilen-1)*SizeOf(buntzeilen_typ));
                        (*$EndIf*)

                      (*$Else*)
                      Move(bildschirmpuffer,
                           Ptr(SegB800,0)^,
                           (bzeilen-1)*SizeOf(buntzeilen_typ));
                      (*$EndIf*)
                    end;
                (*$EndIf*)
                end;
              end
            (*$IfDef TERM_ROLLEN*)
            else (* nicht: (alt_anzeigezeile0<>anzeigezeile0) or zeilenaenderung *)
              if punktzeile<>alt_punktzeile then
                if term=term_rollen then
                  begin
                    (*$IfDef OS2*)
                    VioScrLock1;
                    if lock_Status=lock_Success then
                      begin
                    (*$EndIf*)
                        ruecklauf_warten;
                        setze_punkt_zeile(punktzeile mod (zeichen_hoehe*zeilen_wechsel));
                    (*$IfDef OS2*)
                        VioScrUnLock1;
                      end;
                    (*$EndIf*)
                  end
            (*$EndIf*);

            if zeilenaenderung then
              begin
                schreibe_statuszeile('',falsch);
                zeilenaenderung:=falsch
              end;

            alt_anzeigezeile0:=anzeigezeile0;
            alt_punktzeile:=punktzeile;
          end;(* sofortanzeige *)
      end; (* zeilenspeicherung *)
    (*$EndIf*) (* TERM_FARBIG *)
  end;

procedure schreibe_statuszeile(const s:string;sofort:boolean);

  procedure li_zu_ganzzahl6(w:longint;var _g);

    type
      ganzzahl6         =array[0..5,0..1] of byte;

    const
      ord_0             =ord('0');
      ord_leer          =ord(' ');

    var
      tmp6              :array[0..5] of byte;
      g                 :ganzzahl6 absolute _g;

    begin

      if w=unendlich then
        begin
          g[5,0]:=unendlich_zeichen;
          Exit;
        end;

      tmp6[5]:=(w mod 10)+ord_0;
      w:=w div 10;
      tmp6[4]:=(w mod 10)+ord_0;
      w:=w div 10;
      tmp6[3]:=(w mod 10)+ord_0;
      w:=w div 10;
      tmp6[2]:=(w mod 10)+ord_0;
      w:=w div 10;
      tmp6[1]:=(w mod 10)+ord_0;
      w:=w div 10;
      tmp6[0]:=(w mod 10)+ord_0;

      if tmp6[0]=ord_0 then
        begin
          tmp6[0]:=ord_leer;
          if tmp6[1]=ord_0 then
            begin
              tmp6[1]:=ord_leer;
              if tmp6[2]=ord_0 then
                begin
                  tmp6[2]:=ord_leer;
                  if tmp6[3]=ord_0 then
                    begin
                      tmp6[3]:=ord_leer;
                      if tmp6[4]=ord_0 then
                        tmp6[4]:=ord_leer;
                    end;
                end;
            end;
        end;
      g[0,0]:=tmp6[0];
      g[1,0]:=tmp6[1];
      g[2,0]:=tmp6[2];
      g[3,0]:=tmp6[3];
      g[4,0]:=tmp6[4];
      g[5,0]:=tmp6[5];

    end;

  begin
    if ((zeilenstand mod bzeilen)=bzeilen-1)
    and (terminal_sichtbare_anzeige) then
      sofort:=wahr;

    if s='' then
      begin
        li_zu_ganzzahl6(anzeigezeile0+1,statuszeile^[10+0*7,1]);
        li_zu_ganzzahl6(zeilenstand    ,statuszeile^[10+1*7,1]);
        li_zu_ganzzahl6(maxzeile       ,statuszeile^[10+2*7,1]);
      end
    else
      zk_zu_buntzeile(s,rand,statuszeile^);


    statuszeile^[zeilenbreite,2]:=(statuszeile^[zeilenbreite,2] shr 4)*$11;

    case term of
      (*$IfDef TERM_ROLLEN*)
      term_rollen:
        begin
          (*$IfDef OS2*)
          VioScrLock1;
          if lock_Status=lock_Success then
            begin
              aktiviere_vioerneuerung;
              VioScrUnlock1;
            end;
          (*$EndIf*)
        end;
      (*$EndIf*)

      (*$IfDef TERM_FARBIG*)
      term_farbig:
        begin
          (*$IfDef OS2*)
          aktiviere_vioerneuerung;
          if sofort then
            SysCtrlSleep(1);
          (*$EndIf*)

          (*$IfDef Win32*)
          SysTVShowBuf((bzeilen-1)*SizeOf(buntzeilen_typ),SizeOf(buntzeilen_typ));
          (*$EndIf*)

          (*$IfDef Linux*)
          SysTVShowBuf((bzeilen-1)*SizeOf(buntzeilen_typ),SizeOf(buntzeilen_typ));
          (*$EndIf*)
        end;
      (*$EndIf*)

      term_ansi,
      term_mono,
      term_gefiltert,
      term_html:
        if sofort then
          begin
            statuszeile_kuerzen:=wahr;
            schreibe_zeile(statuszeile^);
            statuszeile_kuerzen:=falsch;
            (*$IfDef Benutze_stream*)
            if terminal_sichtbare_anzeige then terminal_datei^.Flush;
            (*$EndIf Benutze_stream*)
            repeat
              benutzer_abfrage(true,true);
            until seite_weiter;

            if suche_beendet then
              Halt(abbruch_kein_problem);

            if term=term_ansi then
              begin
                (*$IfDef Benutze_stream*)
                terminal_datei^.Write(ansi_gotoxy11,SizeOf(ansi_gotoxy11))
                (*$Else Benutze_stream*)
                BlockWrite(terminal_datei,ansi_gotoxy11,SizeOf(ansi_gotoxy11))
                (*$EndIf Benutze_stream*)
              end
            else
              begin
                (*$IfDef Benutze_stream*)
                terminal_datei^.Write(zeichen_reset,SizeOf(zeichen_reset));
                (*$Else Benutze_stream*)
                BlockWrite(terminal_datei,zeichen_reset,SizeOf(zeichen_reset));
                (*$EndIf Benutze_stream*)
              end;
          end;
    (*$IfNDef ENDVERSION*)
    else
      abbruch('unbekannter Bildschirmtyp',abbruch_unerwartete_erscheinung);
    (*$EndIf*)
    end;

  end;

procedure bildschirmverwaltung(const ein:boolean);
  var
    tmpzk               :string;
    zael                :byte;
    dummi               :byte;
  begin

    if ein then
      begin
        if SysGetCodePage<>437 then
          unendlich_zeichen:=Ord(' '); (* leere Stelle anzeigen *)

        zk_zu_buntzeile('',normal,leerzeile);

        case term of
          (*$IfDef TERM_ROLLEN*)
          term_rollen:
            (*$IfDef OS2*)setze_rollgeschwindigkeit(geschwindigkeit)(*$EndIf*);
          (*$EndIf*)

          (*$IfDef TERM_FARBIG*)
          term_farbig:;
          (*$EndIf*)

          term_ansi,term_mono,term_gefiltert,term_html:
            begin
              (*$IfDef Benutze_stream*)
              if terminal_dateiname='' then
                begin
                  terminal_datei:=New(pBufStream,Init(nul_dev,stCreate,4*1024));
                  SysFileClose(terminal_datei^.Handle);
                  terminal_datei^.Handle:=SysFileStdOut;
                end
              else
                terminal_datei:=New(pBufStream,Init(terminal_dateiname,stCreate,4*1024));
              if terminal_datei^.Status<>stOK then
                abbruch(textz_Fehler_beim_OEffnen_der_Bildschirmdatei^,abbruch_unerwartete_erscheinung);
              (*$Else Benutze_stream*)
              Assign(terminal_datei,terminal_dateiname);
              (*$I-*)
              Rewrite(terminal_datei,1);
              (*$I+*)
              if IOResult<>0 then
                abbruch(textz_Fehler_beim_OEffnen_der_Bildschirmdatei^,abbruch_unerwartete_erscheinung);
              (*$EndIf Benutze_stream*)

              statuszeile:=Addr(statuszeile_indirekt);
            end;
        (*$IfNDef ENDVERSION*)
        else
          abbruch('unbekannter Bildschirmtyp',abbruch_unerwartete_erscheinung);
        (*$EndIf*)
        end;

        case setze_modus of
          0:;
          1:abbruch(textz_Wie_soll_ich_ohne_VESA_60_Zeilen_auf^,abbruch_Problem_beim_Auswerten_der_Parameter);
          2:abbruch(textz_VESA_meldet_Fehler_zurueck^,abbruch_Problem_beim_Auswerten_der_Parameter);
        end;

        alt_anzeigezeile0:=$7FFFFFFF;

        (*$IfDef TERM_FARBIG*)
        case term of
        (*$IfDef TERM_ROLLEN*)
          term_rollen:
            GotoXY(zeilenbreite,1);
        (*$EndIf*)
          term_farbig:
            GotoXY(zeilenbreite,bzeilen);
        end;
        (*$EndIf*)


        normalen_statuszeilenanfang(textz_Zeilen_Hilfe_TYP2^
        (*$IfDef ENDVERSION *)

        (*$IfDef DOS*)   +'           DOS:  '(*$EndIf*)
        (*$IfDef DPMI*)  +'           DPMI: '(*$EndIf*)
        (*$IfDef OS2*)   +'           OS/2: '(*$EndIf*)
        (*$IfDef DPMI32*)+'         DPMI32: '(*$EndIf*)
        (*$IfDef Linux*) +'          Linux: '(*$EndIf*)
        (*$IfDef Win32*) +'          Win32: '(*$EndIf*)

        (*$Else*)

        (*$IfDef DOS*)   +'      Test DOS:  '(*$EndIf*)
        (*$IfDef DPMI*)  +'      Test DPMI: '(*$EndIf*)
        (*$IfDef OS2*)   +'      Test OS/2: '(*$EndIf*)
        (*$IfDef DPMI32*)+'    Test DPMI32: '(*$EndIf*)
        (*$IfDef Linux*) +'     Test Linux: '(*$EndIf*)
        (*$IfDef Win32*) +'     Test Win32: '(*$EndIf*)

        (*$EndIf*)

        +str_(typ_jahr,4)+'.'+str_(typ_mon,2)+'.'+str_(typ_tag,2)+'    ###');

        case term of
          (*$IfDef TERM_ROLLEN*)
          term_rollen:
            begin
              zeilenbreite:=80;
              nutzbare_zeilenbreite:=80;
              (*$IfDef OS2*)
              VioScrLock1;
              if lock_Status=lock_Success then
                begin
              (*$EndIf*)
                  statuszeile_unten(wahr);
                  anzeigestart(0+4*zeilenbreite);
              (*$IfDef OS2*)
                  VioScrUnLock1;
                end;
              (*$EndIf*)
              gotoxy(zeilenbreite,1);
              zk_zu_buntzeile('',rand,umschalter0^);
              zk_zu_buntzeile(textz_verdeckte_zeile_1^
               ,dat_fehler,umschalter1^);
              zk_zu_buntzeile(textz_verdeckte_zeile_2^
               ,dat_fehler,umschalter2^);
            end;
          (*$EndIf*)

          (*$IfDef TERM_FARBIG*)
          term_farbig:
            begin
              zeilenbreite:=80;
              nutzbare_zeilenbreite:=zeilenbreite;
              GotoXY(zeilenbreite,bzeilen);
            end;
          (*$EndIf*)

          term_ansi:
            begin
              zeilenbreite:=80;
              nutzbare_zeilenbreite:=zeilenbreite-1;
            end;

          term_html:
            begin
              zeilenbreite:=80;{oder mehr}
              nutzbare_zeilenbreite:=zeilenbreite;
            end;

          term_mono:
            begin
              zeilenbreite:=80;
              nutzbare_zeilenbreite:=zeilenbreite-1;
            end;

          term_gefiltert:
            begin
              zeilenbreite:=80;
              nutzbare_zeilenbreite:=zeilenbreite-1;
            end;
        (*$IfNDef ENDVERSION*)
        else
          abbruch('unbekannter Bildschirmtyp',abbruch_unerwartete_erscheinung);
        (*$EndIf*)
        end;

        bildschirmbyte:=(bzeilen)*2*zeilenbreite;(* ohne Statuszeile *)

        aktive_seite:=1;
        umgeschaltet:=wahr;
        zeilenaenderung:=wahr;

        nachholen;
      end
    else
      begin
        case term of
          (*$IfDef TERM_FARBIG*)
          (*$IfDef TERM_ROLLEN*)
          term_rollen,
          (*$EndIf TERM_ROLLEN*)
          term_farbig:
            begin

              (*$IfDef TERM_ROLLEN*)
              if term=term_rollen then
                begin
                  (*$IfDef OS2*)
                  (*$IfDef OS2*)setze_rollgeschwindigkeit(0)(*$EndIf*);
                  VioScrLock1;
                  if lock_Status=lock_Success then
                    begin
                  (*$EndIf*)
                      statuszeile_unten(falsch);
                      anzeigestart(0);
                      setze_punkt_zeile(0);
                  (*$IfDef OS2*)
                      VioScrUnLock1;
                    end;
                  (*$EndIf*)
                end;
              (*$EndIf TERM_ROLLEN*)

              dummi:=setze_modus;
              (*$IfDef VirtualPascal*)
                (*$IfDef OS2*)
                for zael:=1 to bzeilen do
                  if zael<=bzeilen-schwarzer_rand_beim_beenden then
                    Move(bildschirmpuffer[zael],
                         Ptr(Ofs(viopuffer^)+(zael-1)*2*viopuffer_anzahl_spalten)^,
                         SizeOf(buntzeilen_typ))
                  else
                    fuell_word(Ptr(Ofs(viopuffer^)+(zael-1)*2*viopuffer_anzahl_spalten)^,
                         SizeOf(buntzeilen_typ) shr 1,
                         attr_schwarzer_rand_beim_beenden);

                (*$IfDef TERM_ROLLEN*)
                if term=term_rollen then
                  begin
                    VioScrLock1;
                    if lock_Status=lock_Success then
                      begin
                        aktiviere_vioerneuerung;
                        VioScrUnlock1;
                      end;
                  end
                else
                (*$EndIf TERM ROLLEN *)
                  aktiviere_vioerneuerung;
                (*$EndIf OS2 *)

                (*$IfDef DPMI32*)
                Move(bildschirmpuffer,
                     SysTVGetSrcBuf^,
                     (bzeilen-schwarzer_rand_beim_beenden)*SizeOf(buntzeilen_typ));
                fuell_word(ptr(ofs(SysTVGetSrcBuf^)+(bzeilen-schwarzer_rand_beim_beenden)*SizeOf(buntzeilen_typ))^,
                   schwarzer_rand_beim_beenden*SizeOf(buntzeilen_typ) shr 1,
                   attr_schwarzer_rand_beim_beenden);
                (*$EndIf DPMI32*)

                (*$IfDef Win32*)
                Move(bildschirmpuffer,
                     SysTVGetSrcBuf^,
                     (bzeilen-schwarzer_rand_beim_beenden)*SizeOf(buntzeilen_typ));
                fuell_word(ptr(ofs(SysTVGetSrcBuf^)+(bzeilen-schwarzer_rand_beim_beenden)*SizeOf(buntzeilen_typ))^,
                   schwarzer_rand_beim_beenden*SizeOf(buntzeilen_typ) shr 1,
                   attr_schwarzer_rand_beim_beenden);
                SysTVShowBuf(0,bzeilen*SizeOf(buntzeilen_typ));
                (*$EndIf Win32*)

                (*$IfDef Linux*)
                Move(bildschirmpuffer,
                     SysTVGetSrcBuf^,
                     (bzeilen-schwarzer_rand_beim_beenden)*SizeOf(buntzeilen_typ));
                fuell_word(ptr(ofs(SysTVGetSrcBuf^)+(bzeilen-schwarzer_rand_beim_beenden)*SizeOf(buntzeilen_typ))^,
                   schwarzer_rand_beim_beenden*SizeOf(buntzeilen_typ) shr 1,
                   attr_schwarzer_rand_beim_beenden);
                SysTVShowBuf(0,bzeilen*SizeOf(buntzeilen_typ));
                (*$EndIf Linux*)

              (*$Else*) (* -VirtualPascal*)
              Move(bildschirmpuffer,
                   Ptr(SegB800,0)^,
                   (bzeilen-schwarzer_rand_beim_beenden)*SizeOf(buntzeilen_typ));
              fuell_word(
                   ptr(SegB800,(bzeilen-schwarzer_rand_beim_beenden)*SizeOf(buntzeilen_typ))^,
                   schwarzer_rand_beim_beenden*SizeOf(buntzeilen_typ) shr 1,
                   attr_schwarzer_rand_beim_beenden);
              (*$EndIf*)
              GotoXY(1,bzeilen-schwarzer_rand_beim_beenden+1);
            end;
          (*$EndIf*)

          term_ansi:
            begin
              schreibe_datei(terminal_datei,ansi_reset,SizeOf(ansi_reset));
              (*$IfDef Benutze_stream*)
              terminal_datei^.Done;
              (*$Else Benutze_stream*)
              Close(terminal_datei);
              (*$EndIf Benutze_stream*)
            end;

          term_html:
            begin
              schreibe_datei(terminal_datei,html_ende^,StrLen(html_ende));
              (*$IfDef Benutze_stream*)
              terminal_datei^.Done;
              (*$Else Benutze_stream*)
              Close(terminal_datei);
              (*$EndIf Benutze_stream*)
            end;

          term_mono:
            begin
              if terminal_dateiname='' then
                schreibe_datei(terminal_datei,zeichen_reset,SizeOf(zeichen_reset));
              (*$IfDef Benutze_stream*)
              terminal_datei^.Done;
              (*$Else Benutze_stream*)
              Close(terminal_datei);
              (*$EndIf Benutze_stream*)
            end;

          term_gefiltert:
            begin
              if terminal_dateiname='' then
                schreibe_datei(terminal_datei,zeichen_reset,SizeOf(zeichen_reset));
              (*$IfDef Benutze_stream*)
              terminal_datei^.Done;
              (*$Else Benutze_stream*)
              Close(terminal_datei);
              (*$EndIf Benutze_stream*)
            end;
        (*$IfNDef ENDVERSION*)
        else
          abbruch('unbekannter Bildschirmtyp',abbruch_unerwartete_erscheinung);
        (*$EndIf*)
        end;
        umgeschaltet:=falsch;
      end;

    blinken_aus;

  end;

procedure sichere_statuszeile(var s:buntzeilen_typ);
  begin
    s:=statuszeile^;
    nachholen;
  end;

procedure restauriere_statuszeile(const s:buntzeilen_typ);
  begin
    statuszeile^:=s;
    if virus_gefunden then
      begin
        statuszeile^[33,1]:=19;
        statuszeile^[33,2]:=ftab.f[virus,vf]+ftab.f[virus,hf];
        statuszeile^[34,1]:=19;
        statuszeile^[34,2]:=ftab.f[virus,vf]+ftab.f[virus,hf];
        statuszeile^[35,1]:=19;
        statuszeile^[35,2]:=ftab.f[virus,vf]+ftab.f[virus,hf];
      end;
    nachholen;
  end;

procedure normalen_statuszeilenanfang(const rest:string);
  begin
    zk_zu_buntzeile(textz_Zeilen_Hilfe_TYP1^+rest,rand,statuszeile^);
    statuszeile^[zeilenbreite,2]:=(statuszeile^[zeilenbreite,2] shr 4)*$11;
    nachholen;
  end;

procedure nachholen;
  begin
    sofortanzeige:=wahr;
    alt_anzeigezeile0:=-1024;
    bildschirmaufbau;
    (*$IfDef Benutze_stream*)
    if term in [term_ansi,term_mono,term_gefiltert,term_html] then
      if terminal_sichtbare_anzeige then
        terminal_datei^.Flush;
    (*$EndIf Benutze_stream*)
  end;

function setze_modus:byte;
  (* 0: fehlerfrei       *)
  (* 1: kein VESA        *)
  (* 2: VESA,aber Fehler *)

  (*$IfDef DOS_ODER_DPMI*)
  var
    vesa_fehler         :word;
  (*$EndIf*)

  (*$IfDef OS2*)
  var
    VioMode             :^VioModeInfo;
    VioMode_            :array[0..1] of VioModeInfo;
    vio_res             :longint;
  (*$EndIf*)

  (*$IfDef Win32*)
  var
    Cols,Rows,Colours   :word_norm;
  (*$EndIf Win32*)

  (*$IfDef Linux*)
  var
    Cols,Rows,Colours   :word_norm;
  (*$EndIf Linux*)

  label
    bildschirmmodus_schon_richtig;

  begin
    setze_modus:=0;

    case term of
    (*$IfDef TERM_ROLLEN*)
      term_rollen,
    (*$EndIf TERM_ROLLEN*)
    (*$IfDef TERM_FARBIG*)
      term_farbig:
        begin

          (*$IfDef DOS_ODER_DPMI*)
          if bzeilen=0 then
            if ega_oder_besser then
              bzeilen:=Min(Mem[Seg0040:$0084]+1,max_bzeilen)
            else
              bzeilen:=25;

          (* schon 80*bzeilen? *)
          if  (MemW[Seg0040:$004a]=80{})
          and (Mem [Seg0040:$0084]=bzeilen-1)
          and ega_oder_besser
           then
            begin
              asm
                mov ax,$0500 (* Bildschirmseite 0 *)
                int $10
              end;
              goto bildschirmmodus_schon_richtig;
            end;


          if vga and (bzeilen=60) then
            begin
              vesa_fehler:=$004f;
              asm
                mov ax,$4F02 (* VESA 108 *)
                mov bx,$0108 (* 80*60 TEXT *)
                int $10
                mov vesa_fehler,ax
                cmp ax,$004F (* kein Fehler+Funktion untersttzt? *)
                jz @weiter
                mov ax,$0012   (* UNIVESA VBE Fehler *)
                int $10
                mov ax,$0003
                int $10
                mov ax,$0026
                int $10
                @weiter:
              end;

              case vesa_fehler of
                $004f:setze_modus:=0;
                $014f:setze_modus:=2;
              else
                setze_modus:=1;
              end;
            end
          else
            asm (* 80*XX *)
              mov ax,3
              int $10
            end;

          if vga then (* +Font20 *)
            case bzeilen of
              28:
                asm
                  mov ax,$1111 (* Font 14 *)
                  mov bl,0
                  int $10
                end;
              50:
                asm
                  mov ax,$1112 (* Font 08 *)
                  mov bl,0
                  int $10
                end;
            end
          else (* ega *)
            if ega_oder_besser then
              case bzeilen of
                43:
                  asm
                    mov ax,$1112 (* Font 08 *)
                    mov bl,0
                    int $10
                  end;
              end;


bildschirmmodus_schon_richtig:

          if ega_oder_besser then
            begin
              zeichen_hoehe:=MemW[Seg0040:$0085];
              bzeilen:=Mem[Seg0040:$0084]+1;
            end
          else
            begin
              zeichen_hoehe:=8;
              bzeilen:=25;
            end;
          (*$EndIf DOS_ODER_DPMI*)

          (*$IfDef OS2*)
          VioMode:=Fix_64k(@VioMode_,SizeOf(VioMode^));
          VioMode.cb:=SizeOf(VioMode^);
          vio_res:=VioGetMode(VioMode^,0);

          if bzeilen=0 then
            bzeilen:=Min(VioMode^.Row,max_bzeilen);

          (* schon 80+*bzeilen? *)
          if (VioMode^.Col<80{})
          or (VioMode^.Row<>bzeilen) then
            begin
              with VioMode^ do
                begin
                  cb     :=Ofs(HRes)-Ofs(cb);
                  fbType :=vgmt_Other;
                  Color  :=colors_16;
                  Row    :=bzeilen;
                  Col    :=80;
                end;
              vio_res:=VioSetMode(VioMode^,0);
            end;

          (*$IfDef TERM_ROLLEN*)
          if term=term_rollen then
            begin
              viopuffer_groesse:=2*100+4*SizeOf(viopuffer^[1]);
              if viopuffer=nil then
                begin
                  New(viopuffer);
                  viopuffer_GetMem:=true;
                end;
            end
          else
          (*$EndIf TERM_ROLLEN*)
            begin
              viopuffer_p:=nil;
              viopuffer_groesse:=0;
              vio_fehler:=VioGetBuf(viopuffer_p,viopuffer_groesse,0);
              SelToFlat(viopuffer_p);
            end;

          VioMode.cb:=SizeOf(VioMode^);
          vio_res:=VioGetMode(VioMode^,0);
          zeichen_hoehe:=VioMode^.VRes div VioMode^.Row;
          viopuffer_anzahl_spalten:=VioMode^.Col;
          (*$EndIf OS2*)

          (*$IfDef DPMI32*)
          if bzeilen=0 then
            if ega_oder_besser then
              bzeilen:=Min(Mem[$00000484]+1,max_bzeilen)
            else
              bzeilen:=25;

          (* schon 80*bzeilen? *)
          if  (MemW[$0000044a]=80{})
          and (mem [$00000484]=bzeilen-1)
          and ega_oder_besser
           then
            begin
              asm
                mov ax,$0500 (* Bildschirmseite 0 *)
                int $10
              end;
              goto bildschirmmodus_schon_richtig;
            end;

          if SysSetVideoMode(80,bzeilen) then
            setze_modus:=0  // success
          else
            setze_modus:=1;

bildschirmmodus_schon_richtig:

          if ega_oder_besser then
            begin
              zeichen_hoehe:=MemW[$0485];
              bzeilen:=Mem[$0484]+1;
            end
          else
            begin
              zeichen_hoehe:=8;
              bzeilen:=25;
            end;
          (*$EndIf DPMI32*)

          (*$IfDef Linux*)
          GetVideoModeInfo(Cols,Rows,Colours);
          if bzeilen=0 then
            bzeilen:=Min(Rows,max_bzeilen);
          if (bzeilen<>Rows) or (Cols<>80) then
            SetVideoMode(80,bzeilen);
          GetVideoModeInfo(Cols,Rows,Colours);
          if (Cols=80) and (Rows=bzeilen) then
            setze_modus:=0  // success
          else
            setze_modus:=1;

          zeichen_hoehe:=8;
          (*$EndIf Linux*)

          (*$IfDef Win32*)
          if GetConsoleCP=1 then
            abbruch('Console functions does no seem to work.',abbruch_unerwartete_erscheinung);
          GetVideoModeInfo(Cols,Rows,Colours);
          if bzeilen=0 then
            bzeilen:=Min(Rows,max_bzeilen);
          if (bzeilen<>Rows) or (Cols<>80) then
            SetVideoMode(80,bzeilen);
          GetVideoModeInfo(Cols,Rows,Colours);
          if (Cols=80) and (Rows=bzeilen) then
            setze_modus:=0  // success
          else
            setze_modus:=1;

          zeichen_hoehe:=8;
          (*$EndIf Win32*)

          case term of
            (*$IfDef TERM_ROLLEN*)
            term_rollen:
              begin
                (*$IfDef VirtualPascal*)
                (*$IfDef OS2*)
                statuszeile:=Ptr(Ofs(viopuffer^)+{SizeOf(buntzeilen_typ)}2*viopuffer_anzahl_spalten*0);
                umschalter0:=Ptr(Ofs(viopuffer^)+{SizeOf(buntzeilen_typ)}2*viopuffer_anzahl_spalten*1);
                umschalter1:=Ptr(Ofs(viopuffer^)+{SizeOf(buntzeilen_typ)}2*viopuffer_anzahl_spalten*2);
                umschalter2:=Ptr(Ofs(viopuffer^)+{SizeOf(buntzeilen_typ)}2*viopuffer_anzahl_spalten*3);
                (*$Else*)
                statuszeile:=Ptr($b8000+SizeOf(buntzeilen_typ)*0);
                umschalter0:=Ptr($b8000+SizeOf(buntzeilen_typ)*1);
                umschalter1:=Ptr($b8000+SizeOf(buntzeilen_typ)*2);
                umschalter2:=Ptr($b8000+SizeOf(buntzeilen_typ)*3);
                (*$EndIf*)
                (*$Else*) (* BP *)
                (*$IfDef OS2*)
                statuszeile:=Ptr(SegB800,2*viopuffer_anzahl_spalten*0);
                umschalter0:=Ptr(SegB800,2*viopuffer_anzahl_spalten*1);
                umschalter1:=Ptr(SegB800,2*viopuffer_anzahl_spalten*2);
                umschalter2:=Ptr(SegB800,2*viopuffer_anzahl_spalten*3);
                (*$Else*)
                statuszeile:=Ptr(SegB800,SizeOf(buntzeilen_typ)*0);
                umschalter0:=Ptr(SegB800,SizeOf(buntzeilen_typ)*1);
                umschalter1:=Ptr(SegB800,SizeOf(buntzeilen_typ)*2);
                umschalter2:=Ptr(SegB800,SizeOf(buntzeilen_typ)*3);
                (*$EndIf*)
                (*$EndIf*)

                (*$IfDef OS2*)
                (*vio_thread_sinnvoll:=false;*)
                beende_vioerneuerung;
                (*$EndIf*)
              end;
            (*$EndIf*)

            (*$IfDef TERM_FARBIG*)
            term_farbig:
              begin
                (*$IfDef VirtualPascal*)
                  (*$IfDef OS2*)
                  statuszeile:=Ptr(Ofs(viopuffer^)+2*viopuffer_anzahl_spalten*(bzeilen-1));
                  (*$Else*)
                  statuszeile:=Ptr(Ofs(SysTVGetSrcBuf^)+SizeOf(buntzeilen_typ)*(bzeilen-1));
                  (*$EndIf*)
                (*$Else*)
                statuszeile:=Ptr(SegB800,SizeOf(buntzeilen_typ)*(bzeilen-1));
                (*$EndIf*)

                (*$IfDef OS2*)
                vio_thread_sinnvoll:=true;
                (*$EndIf OS2*)
              end;
            (*$EndIf*)
            end;

        end; (* ROLLEN/FARBIG *)
      (*$EndIf TERM_FARBIG*)

      term_ansi:
        begin
          bzeilen:=25;
          schreibe_datei(terminal_datei,ansi_init,SizeOf(ansi_init));
        end;

      term_html:
        begin
          bzeilen:=25;
          schreibe_datei(terminal_datei,html_anfang1^,StrLen(html_anfang1));
          schreibe_datei(terminal_datei,codepage_str[1],Length(codepage_str));
          schreibe_datei(terminal_datei,html_anfang2^,StrLen(html_anfang2));
        end;

      term_mono:
        bzeilen:=25;

      term_gefiltert:
        bzeilen:=25;

    (*$IfNDef ENDVERSION*)
    else
      abbruch('unbekannter Bildschirmtyp',abbruch_unerwartete_erscheinung);
    (*$EndIf*)
    end;
  end;

(************************************************************************)

var
  hfarbe,vfarbe         :byte;

procedure ansi_farbe_steuerzeichen(const h,v:byte;var feld:ausgabepuffer_typ);
  const
    isotab              :array[0..7] of char=('0','4','2','6','1','5','3','7');
  begin
    vfarbe:=v;
    hfarbe:=h;

    with feld do
      begin
        daten[laenge+1]:=#27;
        daten[laenge+2]:='[';
        daten[laenge+3]:='0';
        Inc(laenge,3);

        if h>=8 then
          begin
            daten[laenge+1]:=';';
            daten[laenge+2]:='5';
            Inc(laenge,2);
          end;

        if v>=8 then
          begin
            feld.daten[laenge+1]:=';';
            feld.daten[laenge+2]:='1';
            inc(laenge,2);
          end;
        daten[laenge+1]:=';';
        daten[laenge+2]:='4';
        daten[laenge+3]:=isotab[h and $7];
        daten[laenge+4]:=';';
        daten[laenge+5]:='3';
        daten[laenge+6]:=isotab[v and $7];
        daten[laenge+7]:='m';
        Inc(laenge,7);
      end;
  end;

procedure zeile_zu_mono_zk;
  var
    w1                  :word_norm;
  begin
    for w1:=1 to zeilenbreite do
      begin

        if zeile[w1,1] in [7,Ord(^Z)] then (* OS/2 Bootmanager Titel *)
          zeile[w1,1]:=Ord('.');

        if zeile[w1,1]=Ord('ß') then
          begin
            if (zeile[w1,2] shr 4)>=7 then
              begin
                if (zeile[w1,2] and $0f)>=7 then
                  zeile[w1,1]:=Ord('Û')
                else
                  zeile[w1,1]:=Ord('Ü');
              end
            else
              begin
                if (zeile[w1,2] and $0f)>=7 then
                  zeile[w1,1]:=Ord('ß')
                else
                  zeile[w1,1]:=Ord(' ');
              end;
          end;

      end;

    for w1:=1 to nutzbare_zeilenbreite do
      zk.daten[w1]:=Chr(zeile[w1,1]);

    zk.laenge:=nutzbare_zeilenbreite;
    with zk do
      while (laenge<>0) and (daten[laenge]=' ') do
        Dec(laenge);

    if not statuszeile_kuerzen then
      with zk do
        begin
          daten[laenge+1]:=^m;
          daten[laenge+2]:=^j;
          Inc(laenge,2);
        end;
  end;

procedure zeile_zu_filter_zk;
  var
    w1                  :word_norm;
    pruef_ende          :word_norm;

  begin
    zeile_zu_mono_zk(zeile,zk);

    pruef_ende:=zk.laenge;
    if not statuszeile_kuerzen then
      Dec(pruef_ende,2);

    for w1:=1 to pruef_ende do
      if zk.daten[w1]<#32 then
        zk.daten[w1]:='.';
  end;

procedure zeile_zu_ansi_zk;
  var
    w1                  :word_norm;
  begin

    with zk do
      begin

        laenge:=0;
        for w1:=1 to nutzbare_zeilenbreite do
          begin
            if (w1=1)
            or ((zeile[w1,2] shr  4)<>hfarbe)
            or ((zeile[w1,2] and $f)<>vfarbe) then
              ansi_farbe_steuerzeichen(zeile[w1,2] shr 4,zeile[w1,2] and $f,zk);

            if Chr(zeile[w1,1]) in [#7,^z] then
              daten[zk.laenge+1]:='.'
            else
              daten[zk.laenge+1]:=Chr(zeile[w1,1]);

            Inc(laenge);
          end;

        {Dec(laenge);}

        while (laenge>0) and (daten[laenge] in [#0,' ']) do
          Dec(laenge);

        daten[laenge+1]:=#27;
        daten[laenge+2]:='[';
        daten[laenge+3]:='K';
        Inc(laenge,3);

        if not statuszeile_kuerzen then
          begin
            daten[zk.laenge+1]:=#13;
            daten[zk.laenge+2]:=#10;
            Inc(laenge,2);
          end;

      end;

  end;

procedure zeile_zu_html_zk(var zeile:buntzeilen_typ;var zk:ausgabepuffer_typ);
  var
    zk_tmp              :ausgabepuffer_typ;
    i                   :word_norm;
  begin
    zeile_zu_mono_zk(zeile,zk_tmp);

    with zk do
      begin
        laenge:=0;
        for i:=1 to zk_tmp.laenge do
          case zk_tmp.daten[i] of
            ' ':
              begin
                StrCopy(Addr(daten[laenge+1]),'&nbsp;');
                Inc(laenge,Length('&nbsp;'));
              end;
            '&':
              begin
                StrCopy(Addr(daten[laenge+1]),'&amp;');
                Inc(laenge,Length('&amp;'));
              end;
            '<':
              begin
                StrCopy(Addr(daten[laenge+1]),'&lt;');
                Inc(laenge,Length('&lt;'));
              end;
            '>':
              begin
                StrCopy(Addr(daten[laenge+1]),'&gt;');
                Inc(laenge,Length('&gt;'));
              end;
          else
            daten[laenge+1]:=zk_tmp.daten[i];
            Inc(laenge);
          end;
      end;
  end;


(*$IfDef Benutze_stream*)
procedure schreibe_datei(const f:pBufStream;var was;const wieviel:longint);
  var
    rc:integer_norm;
  begin
    f^.Write(was,wieviel);
    rc:=f^.Status;
    if rc<>stOK then
      abbruch(textz_ausg__Fehler_beim_Schreiben_der_Datei^+fehlertext(rc)+')',abbruch_unerwartete_erscheinung);
  end;
(*$Else Benutze_stream*)
procedure schreibe_datei(var f:file;var was;const wieviel:longint);
  var
    sf                  :word_norm;
  begin
    (*$I-*)
    BlockWrite(f,was,wieviel);
    (*$I+*)
    sf:=IOResult;
    if sf<>0 then
      abbruch(textz_ausg__Fehler_beim_Schreiben_der_Datei^+fehlertext(sf)+')',abbruch_unerwartete_erscheinung);
  end;
(*$EndIf Benutze_stream*)

procedure schreiben(const typ:term_typ;const dn:string);
  var
    (*$IfDef Benutze_stream*)
    protokolldatei      :pBufStream;
    (*$Else Benutze_stream*)
    protokolldatei      :file;
    (*$EndIf Benutze_stream*)
    l1                  :longint;
    z2,z3               :word_norm;
    rohzeile            :buntzeilen_typ;
    textzeile           :string;
    protokollname       :string;

  begin
    FileMode:=$02(* DENY WRITE *) shl 3 +$01 (* WRITE ONLY *);

    if dn='?' then
      begin
        case typ of
          term_ansi     :protokollname:='#_TYP_#.ANS';
          term_mono     :protokollname:='#_TYP_#.TXT';
          term_gefiltert:protokollname:='#_TYP_#.FIL';
          term_html     :protokollname:='#_TYP_#.HTM';
        end;
        texteingabe_statuszeile(textz_statuszeile__Dateiname_doppelpunkt^,protokollname,60,false);
      end
    else
      protokollname:=dn;

    schreibe_statuszeile(textz_statuszeile__OEffne^+protokollname+' ...',wahr);

    (*$IfDef Benutze_stream*)
    if protokollname='' then
      begin
        protokolldatei:=New(pBufStream,Init(nul_dev,stCreate,4*1024));
        SysFileClose(protokolldatei^.Handle);
        protokolldatei^.Handle:=SysFileStdOut;
        schreibe_statuszeile(textz_statuszeile__Schreiben_von^+protokollname+' ...',wahr);
      end
    else
      begin
        protokolldatei:=New(pBufStream,Init(protokollname,stOpenWrite,4*1024));

        if protokolldatei^.Status=stOK then
          begin
            schreibe_statuszeile(textz_statuszeile__Anhaengen_an^+protokollname+' ...',wahr);
            protokolldatei^.Seek(protokolldatei^.GetSize);
          end
        else
          begin
            schreibe_statuszeile(textz_statuszeile__Schreiben_von^+protokollname+' ...',wahr);
            protokolldatei^.Done;
            protokolldatei:=New(pBufStream,Init(protokollname,stCreate,4*1024));
          end;
      end;

    if protokolldatei^.Status<>stOK then
      abbruch(textz_Datei_kann_nicht_angelegt_werden^,abbruch_unerwartete_erscheinung);

    (*$Else Benutze_stream*)
    Assign(protokolldatei,protokollname);
    (*$I-*)
    Reset(protokolldatei,1);
    (*$I+*)
    if IOResult=0 then
      begin
        schreibe_statuszeile(textz_statuszeile__Anhaengen_an^+protokollname+' ...',wahr);
        (*$I-*)
        Seek(protokolldatei,FileSize(protokolldatei));
        (*$I+*)
        fehler_val:=IOResult;
        if (fehler_val<>0)
        (*$IfDef OS2*)
        and (fehler_val<>-132) (* con,nul *)
        and (fehler_val<> 132) (* con,nul *)
        (*$EndIf*)
         then
          abbruch(textz_Positionierungsfehler_Protokolldatei^,abbruch_unerwartete_erscheinung);
      end
    else
      begin
        schreibe_statuszeile(textz_statuszeile__Schreiben_von^+protokollname+' ...',wahr);
        (*$I-*)
        Rewrite(protokolldatei,1);
        (*$I+*)
        if IOResult<>0 then
          abbruch(textz_Datei_kann_nicht_angelegt_werden^,abbruch_unerwartete_erscheinung);
      end;
    (*$EndIf Benutze_stream*)

    if term=term_ansi then
      schreibe_datei(protokolldatei,ansi_cls,SizeOf(ansi_cls));

    if term=term_html then
      begin
        schreibe_datei(protokolldatei,html_anfang1^,StrLen(html_anfang1));
        schreibe_datei(terminal_datei,codepage_str[1],Length(codepage_str));
        schreibe_datei(protokolldatei,html_anfang2^,StrLen(html_anfang2));
      end;

    for l1:=1 to zeilenstand do
      begin
        hole_zeile(rohzeile,l1);

        case typ of
          term_ansi     :zeile_zu_ansi_zk     (rohzeile,ausgabepuffer);
          term_mono     :zeile_zu_mono_zk     (rohzeile,ausgabepuffer);
          term_gefiltert:zeile_zu_filter_zk   (rohzeile,ausgabepuffer);
          term_html     :zeile_zu_html_zk     (rohzeile,ausgabepuffer);
        end;

        schreibe_datei(protokolldatei,ausgabepuffer.daten,ausgabepuffer.laenge);
      end;

    if term=term_ansi then
      schreibe_datei(protokolldatei,ansi_cls,4);

    if term=term_html then
      schreibe_datei(terminal_datei,html_ende^,StrLen(html_ende));

    (*$IfDef Benutze_stream*)
    protokolldatei^.Done;
    (*$Else Benutze_stream*)
    Close(protokolldatei);
    (*$EndIf Benutze_stream*)
    Halt(abbruch_kein_problem);
  end;


(*$IfDef OS2*)
var
  vioerneuerung_semaphor_handhabe       :longint;

procedure aktiviere_vioerneuerung;
  var
    egal                :longint;
    gs_org              :smallword;
    previous_post_count :longint;

  begin
    case term of
      term_farbig:
        begin
          egal:=DosResetEventSem(vioerneuerung_semaphor_handhabe,previous_post_count);
          egal:=DosPostEventSem(vioerneuerung_semaphor_handhabe);
        end;

    (*$IfDef TERM_ROLLEN*)
      term_rollen:
        begin
          try
            asm (*$Alters ESI,EDI,ECX*)
              mov [gs_org],gs
              mov esi,[viopuffer]
              mov edi,0
              mov gs,[b8xxx_sel]
              cld
              //mov ecx,type maxbildschirm_typ/4
              mov ecx,type maxbildschirm_typ/16
              align 4
            @@sl:
              {lodsd
              mov gs:[edi],eax
              add edi,4
              loop @@sl}
              mov eax,ds:[esi]
              mov gs:[edi],eax
              mov eax,ds:[esi+4]
              mov gs:[edi+4],eax
              mov eax,ds:[esi+8]
              mov gs:[edi+8],eax
              mov eax,ds:[esi+12]
              mov gs:[edi+12],eax
              add esi,16
              add edi,16
              dec ecx
              jnz @@sl

            end;
          finally
            asm
              mov gs,[gs_org]
            end;
          end;

          if weggeschaltet                      (* wenn VioScrLock einmal fehlschlug *)
          or (Random($00ffffff)<$0007ffff)      (* oder zuf„llig 7/255 um den Bildschrim zu restaurieren *)
           then
            begin
              statuszeile_unten(wahr);
              weggeschaltet:=false;
            end;
        end;
    (*$EndIf*)
    end;
  end;

procedure beende_vioerneuerung;
  var
    fehler              :longint;
    ended               :longint;
  begin
    if vio_thread_id=0 then exit;

    vio_thread_zustand:=soll_beenden;
    (* in jedem fall einmal schicken aktiviere_vioerneuerung; *)
    DosPostEventSem(vioerneuerung_semaphor_handhabe);
    ended:=vio_thread_id;
    if ended<>0 then
      fehler:=DosWaitThread(ended,dcww_Wait);
    DosCloseEventSem(vioerneuerung_semaphor_handhabe);
    vio_thread_id:=0;
  end;

{
procedure bildschirmerneuerung(para:pointer); (* mein erster 2. thread ... *)
  var
    fehler              :longint;
    postcount           :longint;
    ist_vollbild        :boolean;
  begin
    ist_vollbild:=(SysCtrlSelfAppType<=1);

    repeat
      if vio_thread_sinnvoll then
        begin
          (*fehler:=*)VioShowBuf(0,viopuffer_groesse,0);
          if not ist_vollbild then      (* langsamere Grafik im Fenster *)
            (*fehler:=*)DosSleep(10);   (* Millisekunden *)
        end
      else
        DosSleep(100); (* eigentlich keine Aufagbe (ANSI/ASCII)

      (*fehler:=*)DosWaitEventSem(vioerneuerung_semaphor_handhabe,-1);
      (*fehler:=*)DosResetEventSem(vioerneuerung_semaphor_handhabe,postcount);

    until vio_thread_zustand=soll_beenden;
    (*fehler:=*)VioShowBuf(0,viopuffer_groesse,0);
  end;}

procedure bildschirmerneuerung(para:pointer); (* mein erster 2. thread ... *)
  var
    fehler              :longint;
    postcount           :longint;
    ist_vollbild        :boolean;
  begin
    ist_vollbild:=(SysCtrlSelfAppType<=1);

    repeat
      if vio_thread_sinnvoll then
        VioShowBuf(0,viopuffer_groesse,0)
      else
        (* eigentlich keine Aufagbe (ANSI/ASCII) *)
        ;

      DosWaitEventSem(vioerneuerung_semaphor_handhabe,-1);
      DosResetEventSem(vioerneuerung_semaphor_handhabe,postcount);

    until vio_thread_zustand=soll_beenden;

    if vio_thread_sinnvoll then
      VioShowBuf(0,viopuffer_groesse,0);
  end;
(*$EndIf*)

procedure ausschrift_nichts_gefunden(const attribut:aus_attribute);
  begin
    ausschrift(textz_ausg__nichts_gefunden^,attribut);
  end;

procedure typ_ausg_init;
(*$IfDef OS2*)
  var
    egal                :longint;
    funk                :tthreadfunc;
    poin                :pointer absolute funk;

(*$EndIf*)
  begin

    Str(SysGetCodepage,codepage_str);
    Insert('IBM',codepage_str,1);

    Fuell_Word(bildschirmpuffer,SizeOf(bildschirmpuffer) shr 1,$0720);
    suche_im_zeilenspeicher_zeichenkette:='';
    zeilenstand:=0;
    speicherverwaltung_initialisieren;
    zeichen_hoehe:=16;
    (*$IfDef OS2*)
    egal:=DosCreateEventSem(pchar(nil),
                            vioerneuerung_semaphor_handhabe,
                            0, (* privat *)
                            false); (* true=offen=neuer Bildschirmaufbau *)
    if egal<>0 then
      runerror(egal);

    vio_thread_zustand:=darf_laufen;
    poin:=addr(bildschirmerneuerung);

    (*egal:=*)
      BeginThread(nil,                  (* security *)
        10000,                          (* stack *)
        funk,                           (* Prozedur *)
        nil,                            (* Para *)
        create_ready or stack_committed,(* Sicherheit *)
        vio_thread_id);                 (* Ergebnis *)
    (*$EndIf*)

  end;

procedure suche_im_zeilenspeicher(const weitersuchen:boolean);
  var
    zeile               :longint;
    test_position,
    pruefung            :word_norm;
    roh                 :buntzeilen_typ;
    gleichheit          :boolean;
  begin
    if (suche_im_zeilenspeicher_zeichenkette='')
    or (not weitersuchen)
     then
      texteingabe_statuszeile(textz_ausg__suchfolgeeingabe^,suche_im_zeilenspeicher_zeichenkette,60,true);

    if suche_im_zeilenspeicher_zeichenkette='' then
      begin
        normalen_statuszeilenanfang('');
        Exit;
      end;

    if weitersuchen then
      schreibe_statuszeile(textz_ausg__suche_punktpunktpunkt^,wahr);



    zeile:=anzeigezeile0+1;

    repeat
      Inc(zeile);
      if zeile>zeilenstand then
        begin
          normalen_statuszeilenanfang('');
          Exit;
        end;

      hole_zeile(roh,zeile);

      for test_position:=Low(roh) to High(roh) do
        if test_position+length(suche_im_zeilenspeicher_zeichenkette)<high(roh) then
          begin
            gleichheit:=true;
            for pruefung:=1 to Length(suche_im_zeilenspeicher_zeichenkette) do
              if (gross(suche_im_zeilenspeicher_zeichenkette[pruefung])
                  <>gross(Chr(roh[test_position+pruefung-1,1])) ) then
                begin
                  gleichheit:=false;
                  Break;
                end;

            if gleichheit then
              begin
                zeilenpositionierung_sprung(zeile-1,0);
                normalen_statuszeilenanfang('');
                Exit;
              end;
          end;

    until false;

  end;

procedure zeilenpositionierung_plus(const zeilen:longint;const punkte:longint);
  begin
    Inc(anzeigezeile0,zeilen);
    Inc(punktzeile,punkte);

    if anzeigezeile0>=zeilenstand-1 then
      begin
        anzeigezeile0:=zeilenstand-1;
        punktzeile:=0;
      end;

    if anzeigezeile0<0 then
      begin
        anzeigezeile0:=0;
        punktzeile:=0;
      end;

  end;

procedure zeilenpositionierung_minus(const zeilen:longint;const punkte:longint);
  begin
    zeilenpositionierung_plus(-zeilen,-punkte);
  end;

procedure zeilenpositionierung_sprung(const zeile:longint;const punkte:longint);
  begin
    anzeigezeile0:=zeile;
    zeilenaenderung:=wahr;
    zeilenpositionierung_plus(0,0);
  end;

(*$IfDef OS2*)
(*$IfDef TERM_ROLLEN*)
function ldt_b8xx_anfordern:boolean;
  var
    action,phys,rc:longint;
    ParmRec1     :
      record       // Input parameter record
        phys32:longint;
        laenge:smallword;
      end;

    ParmLen     : ULong;  // Parameter length in bytes
    DataLen     : ULong;  // Data length in bytes
    Data1:
      record
        sel:smallword;
      end;

  begin
    ldt_b8xx_anfordern:=false;

    if DosOpen('SCREEN$',screen_handhabe,action,0,0,1,$40,nil)<>0 then
      Exit;

    ParmLen:=SizeOf(ParmRec1);
    with ParmRec1 do
      begin
        phys32:=$b8000;
        laenge:=$08000;
      end;

    DataLen:=SizeOf(Data1);
    Data1.sel:=0;

    rc:=DosDevIOCtl(
            screen_handhabe,            // Handle to device
            IOCTL_SCR_AND_PTRDRAW,      // Category of request
            SCR_ALLOCLDT,               // Function being requested
            @ParmRec1,                  // Input/Output parameter list
            ParmLen,                    // Maximum output parameter size
            addr(ParmLen),              // Input:  size of parameter list
                                        // Output: size of parameters returned
            @Data1,                     // Input/Output data area
            Datalen,                    // Maximum output data size
            addr(DataLen));             // Input:  size of input data area

    if rc=0 then
      begin
        ldt_b8xx_anfordern:=true;
        b8xxx_sel:=Data1.sel;
      end;

  end;

procedure ldt_b8xx_weggeben;
  var
    rc                  :longint;
    ParmRec2:
      record
        sel             :smallword;
      end;
    ParmLen             :ULong;  // Parameter length in bytes
    DataLen             :ULong;  // Data length in bytes

  begin
    if screen_handhabe=0 then exit;

    ParmLen:=SizeOf(ParmRec2);
    with ParmRec2 do
      begin
        sel:=b8xxx_sel;
      end;

    DataLen:=0;
    rc:=DosDevIOCtl(
            screen_handhabe,                // Handle to device
            IOCTL_SCR_AND_PTRDRAW,          // Category of request
            SCR_DEALLOCLDT,                 // Function being requested
            @ParmRec2,                      // Input/Output parameter list
            ParmLen,                        // Maximum output parameter size
            addr(ParmLen),                  // Input:  size of parameter list
                                            // Output: size of parameters returned
            nil,                            // Input/Output data area
            Datalen,                        // Maximum output data size
            addr(DataLen));                 // Input:  size of input data area

    DosClose(screen_handhabe);
  end;
(*$EndIf*) (* TERM_ROLLEN*)
(*$EndIf*) (* OS2*)

function ausgabe_umgeleitet:boolean;
  begin
    ausgabe_umgeleitet:=
      (*$IfDef VirtualPascal*)
      not IsFileHandleConsole(SysFileStdOut);
      (*$Else*)
      (* TpSysLow.? *)
      false;
      (*$EndIf VirtualPascal*)
  end;

procedure einrichten_typ_ausg(const anfang:boolean);
  begin
    (*$IfDef OS2*)
    if anfang then
      benutzereingabe:=SemCreateEvent(nil,false,false)
    else
      SemCloseEvent(benutzereingabe);
    (*$EndIf*)

    (*$IfDef SPEICHER_FREIGEBEN*)
    (*$IfDef OS2*)
    if not anfang then
      if Assigned(viopuffer) and viopuffer_GetMem then
        begin
          Dispose(viopuffer);
          viopuffer:=nil;
        end;
    (*$EndIf OS2*)
    (*$EndIf SPEICHER_FREIGEBEN*)
  end;

(*$IfDef VirtualPascal*)
initialization
  einrichten_typ_ausg(true);
finalization
  einrichten_typ_ausg(false);
(*$EndIf VirtualPascal*)

end.

