(*$I TYP_COMP.PAS*)
(*$X+*)
(* $Define CACHE_STATISTIK*)

unit typ_eiau;

interface

uses
  typ_type,
  dos;

type
  einaustyp=(ein,aus);

const
  seite_weiter:boolean=falsch;

  suchmaske_datei=
                  (*$IfDef OS2*)
                  anyfile-directory;
                  (*$Else*)
                  anyfile-directory-volumeid;
                  (*$EndIf*)


  suchmaske_verzeichnis=directory+archive+hidden+sysfile;

  suchmaske_datentraegername=volumeid;

procedure benutzer_abfrage(const zeit_weggeben,nur_auf_tastatur_warten:boolean);
procedure signatur_anzeige(const t:string;const p:puffertyp);

(*$IfDef DOS*)
procedure ermittle_bios_int_13;
(*$EndIf*)

(*$IfDef OS2*)
function  ermittle_partitionierbare_platten:byte;
(*$EndIf*)

procedure physikalische_festplatten_parameter(const _dl:byte;
                                              var zylinder,koepfe,sektoren:word_norm;
                                              var hersteller,lba_text:string);
function  bios_sektor_lesen(const platte,zylinder,kopf,sektor,sektoren_je_spur,anzahl_koepfe:word_norm;
                            var   s_puffer:puffertyp):word_norm;

(*$IfDef OS2*)
function  ifs_name(const laufwerk:char):string;
(*$EndIf*)

function  dos_sektor_lesen(const sektor:dateigroessetyp;const laufwerk:byte;var s_puffer:puffertyp):word;
procedure datei_oeffnen;

procedure vergiss_cache;
(*$IfDef DOS*)
procedure datei_lesen_far(var puffer:puffertyp;off:dateigroessetyp;anz_byte:word_norm);
const     adr_datei_lesen:pointer=@datei_lesen_far;
procedure datei_lesen(var puffer:puffertyp;off:dateigroessetyp;anz_byte:word_norm);
  inline($ff/$1e/>adr_datei_lesen);
(*$Else*)
procedure datei_lesen(var puffer:puffertyp;off:dateigroessetyp;anz_byte:word_norm);
(*$EndIf*)
procedure datei_lesen_grosser_block(var p;const off:dateigroessetyp;const anz_byte:word_norm);

procedure datei_schliessen;
procedure speicher_lesen(const quell_seg,quell_off:word;var ziel:puffertyp;const anz_byte:word_norm);
(*$IfDef DPMI*)
function  lies_speicher_word(const seg,ofs:word):word;
(*$EndIf*)
procedure text_lesen(var zeile:string);

(*$IfDef DOS*)
procedure cache(const einaus:einaustyp);
(*$EndIf*)

(*$IfDef OS2*)
procedure ea_oeffnen(const dn:string;const titel:string;const auch_ea_daten:boolean);
procedure ea_lesen(const o:dateigroessetyp;var p:puffertyp;const anz:word_norm);
(*$EndIf*)
function  byte__datei_lesen     (const o:dateigroessetyp):byte;
function  x_word__datei_lesen   (const o:dateigroessetyp):word;
function  x_longint__datei_lesen(const o:dateigroessetyp):longint;
function  m_word__datei_lesen   (const o:dateigroessetyp):word;
function  m_longint__datei_lesen(const o:dateigroessetyp):longint;
function  x_dateigroessetyp__datei_lesen(const o:dateigroessetyp):dateigroessetyp;
function  bytesuche__datei_lesen(const o:dateigroessetyp;const suchfolge:string):boolean;
function  datei_pos_suche(anfang,ende:dateigroessetyp;const suchzk:string):dateigroessetyp;
function  datei_pos_suche_zeilenanfang(anfang,ende:dateigroessetyp;const suchzk:string):dateigroessetyp;
function  datei_pos_suche_gross(anfang,ende:dateigroessetyp;const suchzk:string):dateigroessetyp;
function  datei_pos_suche_zeilenanfang_gross(anfang,ende:dateigroessetyp;const suchzk:string):dateigroessetyp;
function  datei_lesen__zu_zk_e(const dateiposition:dateigroessetyp;const e:string;const maxlaenge:word_norm):string;
function  datei_lesen__zu_zk_l(const dateiposition:dateigroessetyp;laenge:longint):string;
function  datei_lesen__zu_zk_zeilenende(const dateiposition:dateigroessetyp):string;
function  datei_lesen__zu_zk_pstr(const dateiposition:dateigroessetyp):string;
function  uc16_datei_lesen__zu_zk_e(const dateiposition:dateigroessetyp;const e:string;maxl:integer):string;

procedure weiter_bis_zum_naechsten_zeilenanfang(var posi:dateigroessetyp);

procedure typ_eiau_init;

(*$IfDef DPMI*)
procedure loesche_dos_puffer;

var
  dos_puffer_seg,
  dos_puffer_sel,
  dos_stack_seg,
  dos_stack_sel         :word;

type
  real_mode_call_structure_typ=
    packed record
      case longint of
        0:(edi_,esi_,ebp_,res1,ebx_,edx_,ecx_,eax_:longint;
           flags_,es_,ds_,fs_,gs_,ip_,cs_,sp_,ss_:word;);
        1:(di_,hdi_,si_,hsi_,bp_,hbp_,res2,res3,bx_,hbx_,dx_,hdx_,cx_,hcx_,ax_,hax_:word);
        2:(res4:array[0..15] of byte;bl_,bh_:byte;res5:word;dl_,dh_:byte;res6:word;cl_,ch_:byte;res7:word;al_,ah_:byte);
    end;

procedure intr_realmode(var reg:real_mode_call_structure_typ;i_num:byte);
procedure callf_realmode(var reg:real_mode_call_structure_typ);
(*$EndIf*)

const
  q_entpackt_puffer_maximalgroesse=
                        (*$IfDef DOS_ODER_DPMI*)
                        4096;
                        (*$EndIf DOS_ODER_DPMI*)
                        (*$IfDef VirtualPascal*)
                        64*1024;
                        (*$EndIf VirtualPascal*)

var
  q_entpackt_puffer_speicher:array [0..q_entpackt_puffer_maximalgroesse-1] of byte;

implementation

uses
  (*$IfDef OS2*)
  Os2Base,
  Os2Def,
  (*$EndIf*)
  (*$IfDef DPMI32*)
  int_2526,
  int_13,
  (*$EndIf*)
  (*$IfDef VirtualPascal*)
  VpSysLow,
  (*$EndIf*)
  typ_zeic,
  typ_var,
  typ_ausg,
  typ_varx,
  typ_spra,
  typ_eing,
  typ_takt,
  typ_os;


(*$IfDef DOS*)
var
  zeit_ziel_spielhebel  :longint;
(*$EndIf*)

(*$IfNDef OS2*)
var
  zeit_ziel_maus        :longint;
  zeit_ziel_rollen      :longint;
(*$EndIf*)

(*$IfDef DOS*)
var
  lba                   :array[$80..$83] of
    record
      lba               :boolean;
      zylinder          :word;
      koepfe            :byte;
      sektoren          :byte;
    end;
(*$EndIf*)

(*$IfDef DOS*)
const
  festplatten_prim      =$1f0;
  festplatten_seku      =$170;
  daten_register        =0;
  fehler_register       =1;
  sektor_zahl_register  =2;
  sektor_nummer_register=3;
  zylinder_lo_register  =4;
  zylinder_hi_register  =5;
  laufwerk_kopf_register=6;
  status_register       =7;
  befehl_register       =7;
(*$EndIf*)

(*$IfDef DPMI*)
procedure intr_realmode(var reg:real_mode_call_structure_typ;i_num:byte);
  begin
    reg.ss_ :=dos_stack_seg;
    reg.sp_ :=8*1024;
    reg.res1:=0;
    asm
      mov ax,$0300 (* Simulate Real Mode Interrupt *)
      mov bl,i_num
      mov bh,0
      sub cx,cx    (* CX=0 (Stack push..) *)
      les di,reg
      int $31
    end;
  end;

procedure callf_realmode(var reg:real_mode_call_structure_typ);
  begin
    reg.ss_ :=dos_stack_seg;
    reg.sp_ :=8*1024;
    reg.res1:=0;
    asm
      mov ax,$0301 (* Call Real Mode Procedure with FAR Return Frame *)
      mov bh,0
      sub cx,cx    (* CX=0 (Stack push..) *)
      les di,reg
      int $31
    end;
  end;

(*$EndIf*)


procedure benutzer_abfrage(const zeit_weggeben,nur_auf_tastatur_warten:boolean);
  var
    tast:word;

  begin
    (*$IfDef OS2*)
    if zeit_weggeben then
      begin
        if not warte_auf_benutzereingabe(-1) then
          Exit;
      end
    else
      begin
        if not warte_auf_benutzereingabe(0) then
          Exit;
      end;
    (*$EndIf*)

    taktberechnung;
    seite_weiter:=falsch;

    (*$IfDef DOS*)
    (* Spielhebelabfrage aufrufen *)

    if spielhebel and (zeit_ziel_spielhebel<=taktwert) then
      begin
        spielhebel_abfrage;

        case spielhebel_y1 of
        -200.. -61:zeilenpositionierung_minus(0,8);
         -60.. -51:zeilenpositionierung_minus(0,4);
         -50.. -31:zeilenpositionierung_minus(0,1);
          30.. -30:;
          31..  50:zeilenpositionierung_plus (0,1);
          51..  60:zeilenpositionierung_plus (0,4);
          61.. 200:zeilenpositionierung_plus (0,8);
        end;

        if not spielhebel_blockiert then
          begin
            if o1 or o2 then zeilenpositionierung_plus(bzeilen-2,0);
            if u1 or u2 then Halt(0);
          end;

        spielhebel_blockiert:=o1 or o2 or u1 or u2;
        zeit_ziel_spielhebel:=taktwert+100;
      end;
    (*$EndIf*)

    (* Mausabfrage aufrufen *)

    (*$IfNDef DOS*)
    (*$IfNDef OS2*)
    maus_holen;
    (*$EndIf*)
    (*$EndIf*)

    if maustreiber then
      begin

        if (not keine_mausbewegung) (*$IfNDef OS2*)and (zeit_ziel_maus<=taktwert)(*$EndIf*) then
          begin

            if (maus_zeile<100-10) or (maus_zeile>100+10) then
              begin
                case maus_zeile of
                  0.. 25:zeilenpositionierung_plus(0,-8);
                 26.. 44:zeilenpositionierung_plus(0,-4);
                 45.. 69:zeilenpositionierung_plus(0,-2);
                 70.. 88:zeilenpositionierung_plus(0,-1);
                 89..111:;
                112..130:zeilenpositionierung_plus(0, 1);
                131..155:zeilenpositionierung_plus(0, 2);
                156..174:zeilenpositionierung_plus(0, 4);
                175..200:zeilenpositionierung_plus(0, 8);
                end;
              end;
            (*$IfNDef OS2*)
            zeit_ziel_maus:=taktwert+60;
            (*$EndIf*)
          end;

        if maus_taste_l then
          begin
            maus_taste_l:=falsch;
            zeilenpositionierung_plus(bzeilen-2,0);
          end;

        if maus_taste_m then
          begin
            maus_taste_m:=falsch;
            zeilenpositionierung_minus(bzeilen-2,0);
          end;

        if maus_taste_r then
          begin
            maus_taste_r:=falsch;
            Halt(0);
          end;
      end; (* Maustreiber *)


    (* Auto-Rollen *)
    (*$IfDef OS2*)
    if rollen_behandlung then
      begin
        case geschwindigkeit of
          9:zeilenpositionierung_plus(0,richtung*8);
          8:zeilenpositionierung_plus(0,richtung*4);
          7:zeilenpositionierung_plus(0,richtung*2);
        else
            zeilenpositionierung_plus(0,richtung*1);
        end;
        rollen_behandlung:=false;
      end;
    (*$Else*)
    if (zeit_ziel_rollen<=taktwert) then
      begin
        case geschwindigkeit of
        0:
            zeit_ziel_rollen:=taktwert+256*8;
        1:
          begin
            zeilenpositionierung_plus(0,richtung);
            zeit_ziel_rollen:=taktwert+256*8;
          end;
        2:
          begin
            zeilenpositionierung_plus(0,richtung);
            zeit_ziel_rollen:=taktwert+128*8;
          end;
        3:
          begin
            zeilenpositionierung_plus(0,richtung);
            zeit_ziel_rollen:=taktwert+ 64*8;
          end;
        4:
          begin
            zeilenpositionierung_plus(0,richtung);
            zeit_ziel_rollen:=taktwert+ 32*8;
          end;
        5:
          begin
            zeilenpositionierung_plus(0,richtung);
            zeit_ziel_rollen:=taktwert+ 16*8;
          end;
        6:
          begin
            zeilenpositionierung_plus(0,richtung);
            zeit_ziel_rollen:=taktwert+  8*8;
          end;
        7:
          begin
            (*$IfDef OS2*)
            zeilenpositionierung_plus(0,richtung);
            zeit_ziel_rollen:=taktwert+  4*8;
            (*$Else*)
            zeilenpositionierung_plus(0,richtung*2);
            zeit_ziel_rollen:=taktwert+  8*8;
            (*$EndIf*)
          end;
        8:
          begin
            (*$IfDef OS2*)
            zeilenpositionierung_plus(0,richtung);
            zeit_ziel_rollen:=taktwert+  2*8;
            (*$Else*)
            zeilenpositionierung_plus(0,richtung*4);
            zeit_ziel_rollen:=taktwert+  8*8;
            (*$EndIf*)
          end;
        9:
          begin
            (*$IfDef OS2*)
            zeilenpositionierung_plus(0,richtung*2);
            zeit_ziel_rollen:=taktwert+  2*8;
            (*$Else*)
            zeilenpositionierung_plus(0,richtung*8);
            zeit_ziel_rollen:=taktwert+  8*8;
            (*$EndIf*)
          end;
        end;
      end;
    (*$EndIf*)

    (* Tastaturbehandlung *)
    tast:=$ffff;
    repeat
      (*$IfDef TERM_ROLLEN*)
      (*$IfDef OS2*)
      //if (term=term_rollen) and (geschwindigkeit>=6) and (Random($0fffffff)>$00ffffff) then
      //  Break; (* Tastaturabfrage einsparen *)
      (*$EndIf*)
      (*$EndIf*)

      if (not nur_auf_tastatur_warten) or (tast<>$ffff) then
        if not ty_keypressed then
          begin
            (*$IfDef VirtualPascal*)
            if zeit_weggeben and (tast=$ffff) then
              (*SysCtrlSleep(50);*)
              (*$IfDef OS2*)
              ;
              (*$Else*)
              (*?warte_auf_benutzereingabe(50);*)
              ;
              (*$EndIf*)
            (*$EndIf*)
            Break;
          end;

      tast:=ty_readkey;
      case tast of
        $001b,                                 (* ESC *)
        $6b00,                                 (* Alt-F4 *)
        $2d00:                                 (* Alt-X *)
          Halt(abbruch_kein_problem);

        $8400,                                 (* Strg-Bild auf *)
        $4700:                                 (* POS1 *)
          if zeilenspeicherung then
            begin
              if richtung>0 then
                begin
                  geschwindigkeit:=0;
                  (*$IfDef OS2*)
                  setze_rollgeschwindigkeit(geschwindigkeit);
                  (*$EndIf*)
                end;
              zeilenpositionierung_sprung(0,0);
            end;

        $4800:                                 (* hoch *)
          if zeilenspeicherung then
            begin
              if richtung>0 then
                richtung:=-richtung;

              if (richtung<=0) or (geschwindigkeit=0) then
                zeilenpositionierung_minus(1,0);
            end;

        $4900:                                 (* BILD hoch *)
          if zeilenspeicherung then
            begin
              if richtung>0 then
                richtung:=-richtung;
              zeilenpositionierung_minus(bzeilen-2,0);
            end;

        $7600,                                 (* Strg-Bild ab *)
        $4f00:                                 (* ENDE *)
          if zeilenspeicherung then
            begin
              if richtung<0 then
                begin
                  geschwindigkeit:=0;
                  (*$IfDef OS2*)
                  setze_rollgeschwindigkeit(geschwindigkeit);
                  (*$EndIf*)
                end;
              zeilenpositionierung_sprung(zeilenstand,0);
            end;

        $5000:                                 (* runter *)
          if zeilenspeicherung then
            begin
              if richtung<0 then
                richtung:=-richtung;

              if (richtung>=0) or (geschwindigkeit=0) then
                zeilenpositionierung_plus(1,0);
            end;

        $000d,                                 (* Enter *)
        $5100:                                 (* BILD runter *)
          if zeilenspeicherung then
            begin
              if richtung<0 then
                richtung:=-richtung;
              zeilenpositionierung_plus(bzeilen-2,0);
            end
          else
            seite_weiter:=wahr;

        $0065,                                 (*  e  *)
        $0045:
          if zeilenspeicherung then
            schreiben(term_ansi,'?');

        $0061,                                 (*  a  *)
        $0041:
          if zeilenspeicherung then
            schreiben(term_mono,'?');

        $0066,                                 (*  f  *)
        $0046:
          if zeilenspeicherung then
            schreiben(term_gefiltert,'?');
            
        $0068,                                 (*  h  *)
        $0048:
          if zeilenspeicherung then
            schreiben(term_html,'?');
        

        $0020:                                (* Leertaste *)
          if zeilenspeicherung then
            begin
              (*$IfDef TERM_ROLLEN*)
              if term=term_rollen then
                begin
                  richtung:=-richtung;
                  if geschwindigkeit=0 then
                    begin
                      geschwindigkeit:=norm_geschwindigkeit;
                      (*$IfDef OS2*)
                      setze_rollgeschwindigkeit(geschwindigkeit);
                      (*$EndIf*)
                    end;
                  if anzeigezeile0=0 then richtung:=1;
                end
              else
              (*$EndIf*)
                zeilenpositionierung_plus(bzeilen-2,0);
            end
          else
            seite_weiter:=wahr;

        $002b:                                 (* +           *)
          if zeilenspeicherung then
            if geschwindigkeit<9 then
              begin
                Inc(geschwindigkeit);
                (*$IfDef OS2*)
                setze_rollgeschwindigkeit(geschwindigkeit);
                (*$EndIf*)
              end;

        $002d:                                 (* -           *)
          if zeilenspeicherung then
            if geschwindigkeit>0 then
              begin
                Dec(geschwindigkeit);
                (*$IfDef OS2*)
                setze_rollgeschwindigkeit(geschwindigkeit);
                (*$EndIf*)
              end;
        $0008:                                 (* <-          *)
          if zeilenspeicherung then
            begin
              geschwindigkeit:=0;
              (*$IfDef OS2*)
              setze_rollgeschwindigkeit(geschwindigkeit);
              (*$EndIf*)
              maus_schalten(falsch);
              maus_schalten(wahr);
              (*$IfDef DOS*)
              if spielhebel then spielhebel_schalten;
              (*$EndIf*)
            end;

        Ord('m'):                              (* m           *)
          if zeilenspeicherung then
            begin
              geschwindigkeit:=0;
              (*$IfDef OS2*)
              setze_rollgeschwindigkeit(geschwindigkeit);
              (*$EndIf*)
              maus_schalten(falsch);
              maus_schalten(wahr);
              keine_mausbewegung:=not keine_mausbewegung;
            end;

        Ord('s'),                              (* s           *)
        $4100:                                 (* F7          *)
          if zeilenspeicherung then
            suche_im_zeilenspeicher(falsch);

        ord('S'),                              (* S           *)
        $5a00:                                 (* U-F7        *)
          if zeilenspeicherung then
            suche_im_zeilenspeicher(wahr);

        $4200:                                 (* F8          *)
          if zeilenspeicherung then
            begin
              bildschirmverwaltung(falsch);
              bildschirmverwaltung(wahr);
            end;

        $4300,                                 (* F9          *)
        $8500:                                 (* F11         *)
          begin
            emulator_abbrechen:=true;
          end;

        $4400,                                 (* F10         *)
        $8600:                                 (* F12         *)
          if zeilenspeicherung then
            begin
              bildschirmverwaltung(falsch);

              (*$IfDef DOS*)
              if taskmgr then
                begin
                  asm
                    mov ax,$2715
                    int $2f
                  end;
                end
              else
                begin
                  schreibe_statuszeile(textz_eiau__Pause_weiter_mit_Tastendruck^,wahr);
                  tast:=ty_readkey;
                end;
              (*$EndIf*)

              (*$IfDef DPMI32*)
              if taskmgr then
                begin
                  asm
                    mov ax,$0003
                    int $10
                    mov ax,$2715
                    int $2f
                    int $28
                  end;
                end
              else
                begin
                  schreibe_statuszeile(textz_eiau__Pause_weiter_mit_Tastendruck^,wahr);
                  tast:=ty_readkey;
                end;
              (*$EndIf*)

              (*$IfDef OS2*)
              GotoXY($01,bzeilen-1);
              Write(output,textz_eiau__Pause_Aufruf_der_Fensterliste_mit_Strg_Esc_Weiter_mit^);
              tast:=ty_readkey;
              (*$EndIf*)

              bildschirmverwaltung(wahr);
            end;
      else
        (*$IfNDef ENDVERSION*)
        schreibe_statuszeile(' Taste='+str_(hi(tast),4)+'¯'+str_(lo(tast),4),wahr);
        (*$EndIf*)
      end;

    until false;

    bildschirmaufbau;
  end;

(*$IfDef DOS*)

const
  orgbiosint13_einsprung:pointer=nil;

procedure ermittle_bios_int_13;
  var
    s,o:word;
  begin
(*    if os_2 or (dos_version>7-7) then*)
      getintvec($13,orgbiosint13_einsprung)
(*    else
      begin
         asm
           push ds
             mov ax,cs
             mov ds,ax
             mov es,ax
             mov ah,$13
             mov bx,0
             mov dx,0
             cli
             int $2f
             push ds
               push dx
                 mov ah,$13
                 int $2f
                 sti
               pop ax
             pop bx
           pop ds

           mov o,ax
           mov s,bx
         end;
         orgbiosint13_einsprung:=ptr(s,o);

     end *);
  end;
(*$EndIf*)

(*$IfDef OS2*)
function ermittle_partitionierbare_platten:byte;
  var
    usNumDrives:word;
    fehler:longint;
  begin
    ermittle_partitionierbare_platten:=0;

    fehler:=DosPhysicalDisk(INFO_COUNT_PARTITIONABLE_DISKS,
                            @usNumDrives,
                            SizeOf(usNumDrives),
                            nil,0);

    if fehler<>0 then exit;

    ermittle_partitionierbare_platten:=usNumDrives;
  end;
(*$EndIf*)

(*$IfDef DOS*)
procedure cache(const einaus:einaustyp);
  var
    HyperCallout:byte;(*  Dos MultiPlex Number for HyperWare *)
  begin
    asm
      mov HyperCallout,$DF
      @hyper_api_suche:

      mov cx,0
      mov dx,0
      mov bx,'DH'                   (* Product Code for HyperDisk *)
      mov ah,HyperCallOut           (* Disk Cache installed? *)
      mov al,0                      (* install check request *)

      push ds                       (* make sure not changed *)
      int $2f                       (* go do multiplex interrupt *)
      pop ds

      or al,al                      (* zero...no change *)
      je @HYPERDISK_WEITER          (* nothing installed *)

      cmp al,-1                     (* something installed is -1 *)
      jne @SearchHyAPINxt           (* try next Multiplex number if not -1 *)

      cmp cx,'YH'                   (* HyperWare Product? *)
      jne @SearchHyAPINxt           (* if not skip to next Multiplex number *)

      or dx,dx                      (* non-zero if HyperDisk installed *)

      jz @HYPERDISK_WEITER          (* ; HyperDisk not here *)

                                    (* Found Product, Carry is clear *)
                                    (* AH = Multiplex # *)
                                    (* BX = CS segment of HyperDisk *)
                                    (* DX = HyperDisk Local Data Version # *)

      cmp einaus,aus
      jz @hyperdisk_ausschalten

      (* Hyperdisk einschalten *)
      mov dl,hyperdisk_schalter

      mov ah,HyperCallOut           (* HyperWare Multiplex Number *)
      mov bx,'DH'                   (* HyperDisk product selector *)
      mov al,$02                    (* set cache state *)
      int $2f                       (* do multiplex interrupt *)

      jmp @HYPERDISK_WEITER


      @hyperdisk_ausschalten:

      mov ah,HyperCallOut           (* HyperWare Multiplex Number *)
      mov bx,'DH'                   (* HyperDisk product selector *)
      mov al,$01                    (* Get current cache state *)
      int $2f                       (* do multiplex interrupt *)

      mov hyperdisk_schalter,dl

      (* Bit 7 : AUS! *)
      and dl,$7F

      mov ah,HyperCallOut           (* HyperWare Multiplex Number *)
      mov bx,'DH'                   (* HyperDisk product selector *)
      mov al,$02                    (* set cache state *)
      int $2f                       (* do multiplex interrupt *)

      jmp @HYPERDISK_WEITER


      @SearchHyAPINxt:

      inc HyperCallOut            (* Disk Cache installed? *)
      jnz @hyper_api_suche       (* stop at 0FFh *)

      @HYPERDISK_WEITER:
    end;

    if einaus=aus then
      begin
        (* QUICKCHACHE II *)
        asm
          mov ax,$2C00
          int $13
        end;
        (* Super PC-Kwik 5.10+ *)
        asm
          mov ah,$A1
          mov si,$4358
          int $13
        end;
        (* SMARTDRV 4.00+ (PC-CACHE 8.0) (NWCACHE) *)
        asm
          mov ax,$4a10
          mov bx,$0001
          int $2f
          mov ax,$4a10
          mov bx,$0002
          int $2f
        end;
        (* FAST! 4.02+ *)
        asm
          mov ax,$8009  (* flush *)
          mov cx,$6572
          mov dx,$1970
          int $13
        end;
        (* PC-Cache 6+ *)
        asm
          mov ax,$FFA5
          mov cx,$FFFF
          int $16
        end;
        (* NCACHE 5+,6+ *)
        asm
          mov ax,$fe03
          mov di,$4e55
          mov si,$4346
          int $2f
          mov ax,$fe03
          mov di,$4e55
          mov si,$4353
          int $2f
        end;
      end
    else
      begin

      end;
  end;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function bios_sektor_lesen_alt0(const cx_r,dx_r:word;var s_puffer:puffertyp):word;
  var
    puffer              :array[0..511] of char;
    z                   :word;
    versuche            :byte;
    fehler              :word;
    p_fpl_kopf,
    p_sektor,
    p_zyl_hi,
    p_zyl_lo            :byte;
    ide_port            :word;
    integritaet         :boolean;
    lba_adr             :longint;
    (*$IfDef DPMI*)
    r                   :real_mode_call_structure_typ;
    (*$EndIf*)
  begin
    dateilaenge:=fast_unendlich;
    quelle.sorte:=q_sektor_bios_cxdx;
    quelle.bios_cx:=cx_r;
    quelle.bios_dx:=dx_r;

    (*$IfDef DOS*)
    if direkt_ide and (lo(dx_r)>=$80) and (lo(dx_r)<=$83) then
      begin

        p_fpl_kopf:=$A0+(dx_r and $1) shl 4+(hi(dx_r) and $f);
        p_sektor  :=lo(cx_r and $003F);
        p_zyl_lo  :=hi(cx_r);
        p_zyl_hi  :=hi((cx_r and $FF) shl 2);

        if lba[lo(dx_r)].lba then
          begin
            lba_adr:=(p_sektor-1)
                    +longint(p_zyl_lo+p_zyl_hi*256)*lba[lo(dx_r)].koepfe*lba[lo(dx_r)].sektoren
                    +(longint(hi(dx_r)) and $f)*64;

            p_sektor:=(lba_adr shr  0) and $ff;
            p_zyl_lo:=(lba_adr shr  8) and $ff;
            p_zyl_hi:=(lba_adr shr 16) and $ff;
            p_fpl_kopf:=$A0+((dx_r and $1) shl 4)+bit06+((lba_adr shr 24) and $ff);
          end;


        if lo(dx_r)<=$81 then
          ide_port:=festplatten_prim
        else
          ide_port:=festplatten_seku;


        FillChar(s_puffer.d,512,$21); (* '!!' *)
        cache(aus);

        asm
          mov integritaet,falsch

          (* Auswahl Festplatte *)
          mov dx,ide_port
          add dx,laufwerk_kopf_register
          mov al,p_fpl_kopf
          out dx,al

          (* 1 Sektor *)
          mov dx,ide_port
          add dx,sektor_zahl_register
          mov al,1
          out dx,al

          (* Sektor *)
          mov dx,ide_port
          add dx,sektor_nummer_register
          mov al,p_sektor
          out dx,al

          (* Zylinder lo *)
          mov dx,ide_port
          add dx,zylinder_lo_register
          mov al,p_zyl_lo
          out dx,al

          (* Zylinder hi *)
          mov dx,ide_port
          add dx,zylinder_hi_register
          mov al,p_zyl_hi
          out dx,al

          (* Lesebefehl *)
          mov dx,ide_port
          add dx,befehl_register
          mov al,$20
          out dx,al


          mov cx,0
          (* warten bis bereit *)
          @warten:
          inc cx
          (* zu langsam ... *)
          cmp cx,$ffff
          jz @port_lesen_ende

          (* warten auch auf schnellen Rechnern *)
          push dx
            mov dx,$00eb
            mov al,0
            out dx,al
          pop dx

          in al,dx

          (* Fehlerbit? *)
          test al,1
          jnz @port_lesen_ende

          in al,dx
          test al,8
          jz @warten


          (* Lesen ... *)

          mov cx,256
          les di,s_puffer
          add di,2 (* s_puffer.d *)
          mov dx,ide_port
          add dx,daten_register

          @weiter_lesen:
          rep insw
          cmp cx,0
          jnz @weiter_lesen

          mov dx,ide_port
          add dx,fehler_register
          in al,dx
          mov ah,0
          mov fehler,ax


          mov dx,ide_port
          add dx,sektor_zahl_register
          in al,dx
          cmp al,0
          jnz @port_lesen_ende

          mov dx,ide_port
          add dx,sektor_nummer_register
          in al,dx
          cmp al,p_sektor
          jnz @port_lesen_ende

          mov dx,ide_port
          add dx,zylinder_lo_register
          in al,dx
          cmp al,p_zyl_lo
          jnz @port_lesen_ende

          mov dx,ide_port
          add dx,zylinder_hi_register
          in al,dx
          cmp al,p_zyl_hi
          jnz @port_lesen_ende

          mov integritaet,wahr

          @port_lesen_ende:

        end;
        cache(ein);
        if (not integritaet) and (fehler=0) then
          ausschrift(textz_eiau__Beim_direkten_Lesen_der_Festplatte_hat_jemand_gemogelt^,dat_fehler);
        if fehler=0 then
          s_puffer.g:=512
        else
          s_puffer.g:=0;
      end
    else (* direkt_ide=falsch *)
      (*$EndIf*)
      begin
        versuche:=2;
        fehler:=$FF;
        while (versuche>0) and (fehler<>0) do
          begin
            Dec(versuche);
            (*$IfDef DOS*)
            asm
              mov ax,$0201 (* Lesen *) (* 1 Sektor *)
              les bx,s_puffer
              add bx,2 (* s_puffer.d *)
              mov cx,cx_r
              mov dx,dx_r
              pushf
                call orgbiosint13_einsprung (* INT $13 *)
              shr ax,8
              mov fehler,ax
            end;
            (*$EndIf*)
            (*$IfDef DPMI*)
            loesche_dos_puffer;
            with r do
              begin
                FillChar(r,SizeOf(r),0);
                ax_:=$0201;
                es_:=dos_puffer_seg;
                bx_:=0;
                cx_:=cx_r;
                dx_:=dx_r;
                intr_realmode(r,$13);
                fehler:=ah_;
                Move(Ptr(dos_puffer_sel,0)^,s_puffer.d,512);
              end;
            (*$EndIf*)
            if fehler=0 then
              s_puffer.g:=512
            else
              s_puffer.g:=0;
          end;
      end;

    if fehler<>0 then
      FillChar(s_puffer.d,512,0);
    bios_sektor_lesen_alt0:=fehler;
    if signaturen then
      (*$IfDef DOS*)
      if direkt_ide and ((lo(dx_r)>=$80) and (lo(dx_r)<=$83)) then
        signatur_anzeige(textz_eiau__Platte_PORT^,s_puffer)
      else
      (*$EndIf*)
        signatur_anzeige(textz_eiau__Platte_INT_13^,s_puffer);
  end;

function  bios_sektor_lesen(const platte,zylinder,kopf,sektor,sektoren_je_spur,anzahl_koepfe:word_norm;
                            var   s_puffer:puffertyp):word_norm;
  type
    disk_address_packet_typ=
      record
        size_of_packet  :byte;
        reserved        :byte;
        number_of_blocks:smallword;
        transferbuffer_o:smallword;
        transferbuffer_s:smallword;
        absoluteblocknum:longint;
        absoluteblocknum2:longint;
      end;

  var
    cx,dx               :word_norm;
    (*$IfDef DOS*)
    disk_address_packet :disk_address_packet_typ;
    (*$EndIf*)
    (*$IfDef DPMI*)
    r                   :real_mode_call_structure_typ;
    (*$EndIf*)
    versuche            :word_norm;
  begin

    if zylinder>=1024 then
      begin
        dateilaenge             :=fast_unendlich;
        quelle.sorte            :=q_sektor_bios_zks;
        quelle.zylinder         :=zylinder;
        quelle.kopf             :=kopf;
        quelle.sektor           :=sektor;
        quelle.platte           :=platte;
        quelle.sektoren_je_spur :=sektoren_je_spur;
        quelle.anzahl_koepfe    :=anzahl_koepfe;

        (*$IfDef DOS*)
        with disk_address_packet do
        (*$EndIf*)
        (*$IfDef DPMI*)
        loesche_dos_puffer;
        with disk_address_packet_typ(Ptr(dos_puffer_sel,512)^) do
        (*$EndIf*)
          begin
            size_of_packet  :=SizeOf(disk_address_packet_typ);
            reserved        :=0;
            number_of_blocks:=1;
            (*$IfDef DOS*)
            transferbuffer_o:=Ofs(s_puffer.d);
            transferbuffer_s:=Seg(s_puffer);
            (*$EndIf*)
            (*$IfDef DPMI*)
            transferbuffer_o:=0;
            transferbuffer_s:=dos_puffer_seg;
            (*$EndIf*)
            (* 64 Bit .. *)
            absoluteblocknum:=(longint(zylinder)*anzahl_koepfe+kopf)*longint(sektoren_je_spur)+sektor-1;
            absoluteblocknum2:=0;
            (*ausschrift('>>'+str0(absoluteblocknum),normal);*)

            versuche:=2;
            fehler:=$FF;
            while (versuche>0) and (fehler<>0) do
              begin
                Dec(versuche);
                number_of_blocks:=1;
                (*$IfDef DOS*)
                asm
                  push ds
                  pop es

                  mov ax,$4200
                  mov dx,platte
                  push ss
                  pop ds
                  lea si,disk_address_packet
                  pushf
                    call es:orgbiosint13_einsprung (* INT $13 *)

                  push es
                  pop ds

                  shr ax,8
                  mov fehler,ax
                end;
                (*$EndIf*)
                (*$IfDef DPMI*)
                with r do
                  begin
                    FillChar(r,SizeOf(r),0);
                    ax_:=$4200;
                    dx_:=platte;
                    ds_:=dos_puffer_seg;
                    si_:=512;
                    intr_realmode(r,$13);
                    fehler:=ah_;
                    Move(Ptr(dos_puffer_sel,0)^,s_puffer.d,512);
                  end;
                (*$EndIf*)
                if fehler=0 then
                  s_puffer.g:=512
                else
                  s_puffer.g:=0;

              end; (* while versuche>0 *)
          end; (* with *)

        if fehler=0 then
          begin
            bios_sektor_lesen:=0;
            if signaturen then
              signatur_anzeige(textz_eiau__Platte_INT_13_EXT^,s_puffer);
            Exit;
          end;
      end;

    (* Wenn die Ertweiterten Funktionen nicht fehlerfrei liefen
       werden die alten Funktionen aufgerufen                   *)

    dx:=platte                                       (* DL              *)
       +kopf shl 8                                   (* DH bit   543210 *)
       +(zylinder and (bit10+bit11)) shl ((6+8)-10); (* DH bit 76       *)
    cx:=sektor                                       (* CL bit   543210 *)
       +(zylinder and $ff) shl 8                     (* CH              *)
       +(zylinder and (bit08+bit09)) shr (8-6);      (* CL bit 76       *)

    bios_sektor_lesen:=bios_sektor_lesen_alt0(cx,dx,s_puffer);

  end;

(*$EndIf*)

(*$IfDef OS2*)
procedure physikalische_festplatten_parameter(const _dl:byte;var zylinder,koepfe,sektoren:word_norm;
                                              var hersteller,lba_text:string);
  var
    hand                :smallword;
    laufwerk            :string[3];
    parameter_laenge,
    datenpaket_laenge   :longint;

    parameter:
      record
        befehl          :byte;
      end;
    datenpaket:
      record
        reserviert1     :smallword;
        zylinder        :smallword;
        koepfe          :smallword;
        sektoren        :smallword;
        reserviert2     :smallword;
        reserviert3     :smallword;
        reserviert4     :smallword;
        reserviert5     :smallword;
      end;

  begin
    hersteller:='';
    lba_text:='';
    parameter_laenge :=SizeOf(parameter);
    datenpaket_laenge:=SizeOf(datenpaket);

    laufwerk:='1:'#0;
    Inc(laufwerk[1],_dl-$80);

    parameter.befehl:=0;

    datenpaket.zylinder:=0;
    datenpaket.koepfe  :=0;
    datenpaket.sektoren:=0;

    (* ôffnen *)
    fehler:=DosPhysicalDisk(INFO_GETIOCTLHANDLE,@hand,SizeOf(hand),Addr(laufwerk[1]),length(laufwerk));

    if fehler=0 then
      begin
        fehler:=DosDevIOCtl(hand,ioctl_physicaldisk,pdsk_getphysdeviceparams,
                        Addr(parameter),SizeOf(parameter),Addr(parameter_laenge),
                        Addr(datenpaket),SizeOf(datenpaket),Addr(datenpaket_laenge));

        fehler:=DosPhysicalDisk(INFO_FREEIOCTLHANDLE,ptr(0),0,Addr(hand),2);
      end;

    zylinder:=datenpaket.zylinder;
    koepfe  :=datenpaket.koepfe;
    sektoren:=datenpaket.sektoren;

  end;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
procedure physikalische_festplatten_parameter(const _dl:byte;
                                              var   zylinder,koepfe,sektoren:word_norm;
                                              var   hersteller,lba_text:string);

  type
    ext_drive_parameter_typ=
      record
        size_of_buffer          :smallword;
        information_flags       :smallword;
        cylinders               :longint;
        heads                   :longint;
        sectors_per_track       :longint;
        number_of_sectors       :longint;
        number_of_sectors_hi    :longint;
        bytes_per_sector        :smallword;
      end;
  const
    valid_bit           =1 shl 1;

  var
    s_puffer            :puffertyp;
    ide_port            :word_norm;
    (*$IfDef DOS*)
    ext_drive_parameter :ext_drive_parameter_typ;
    (*$EndIf*)
    (*$IfDef DPMI*)
    r                   :real_mode_call_structure_typ;
    (*$EndIf*)
    ext_drive_parameter_z:^ext_drive_parameter_typ;
    ext_fehler          :smallword;
    w1,w2               :word_norm;
  begin
    lba_text:='';
    hersteller:='';
    zylinder:=0;
    koepfe  :=0;
    sektoren:=0;
    (*$IfDef DOS*)
    if direkt_ide and (_dl>=$80) and (_dl<=$83) then
      begin
        FillChar(s_puffer.d,512,$21); (* '!!' *)
        s_puffer.g:=512;
        cache(aus);

        if _dl<=$81 then
          ide_port:=festplatten_prim
        else
          ide_port:=festplatten_seku;

        asm
          (* Auswahl Festplatte *)
          mov dx,ide_port
          add dx,laufwerk_kopf_register
          mov al,_dl
          and al,1
          shl al,4
          add al,$a0
          out dx,al

          (* ID-Befehl *)
          mov dx,ide_port
          add dx,befehl_register
          mov al,$ec
          out dx,al

          mov cx,0
          (* warten bis bereit *)
          @warten:
          inc cx
          (* zu langsam ... *)
          cmp cx,$ffff
          jz @port_lesen_ende

          (* warten auch auf schnellen Rechnern *)
          push dx
            mov dx,$00eb
            mov al,0
            out dx,al
          pop dx

          in al,dx

          (* Fehlerbit? *)
          test al,1
          jnz @port_lesen_ende

          in al,dx
          test al,8
          jz @warten


          (* Lesen ... *)

          mov cx,256

          lea di,s_puffer
          add di,2 (* s_puffer.d *)
          mov ax,ss
          mov es,ax
          mov dx,ide_port
          add dx,daten_register

          @weiter_lesen:
          rep insw
          cmp cx,0
          jnz @weiter_lesen

          @port_lesen_ende:
        end;
        cache(ein);
        for w1:=0 to 255 do
          begin
            w2:=s_puffer.d[w1*2+0];
            s_puffer.d[w1*2+0]:=s_puffer.d[w1*2+1];
            s_puffer.d[w1*2+1]:=w2;
          end;

        if signaturen then
          signatur_anzeige(textz_eiau__Platte_PORT^,s_puffer);

        if (word_z(@s_puffer.d[0])^<>$2121) and (word_z(@s_puffer.d[4])^=0) then
          begin
            zylinder:=m_word(s_puffer.d[$2]);
            koepfe  :=m_word(s_puffer.d[$6]);
            sektoren:=m_word(s_puffer.d[$c]);
            hersteller:=puffer_zu_zk_e(s_puffer.d[$36],#0,40);
            while (length(hersteller)>0) and (hersteller[length(hersteller)]=' ') do
              Dec(hersteller[0]);

            if zylinder<1024 then
              lba[_dl].lba:=falsch
            else
              begin
                lba[_dl].lba:=wahr;
                lba[_dl].zylinder:=zylinder div 2;
                lba[_dl].koepfe:=koepfe*2;
                lba[_dl].sektoren:=63;
                while (lba[_dl].zylinder>1024) and (lba[_dl].koepfe<=(256 div 2)) do
                  begin
                    lba[_dl].zylinder:=lba[_dl].zylinder div 2;
                    lba[_dl].koepfe  :=lba[_dl].koepfe*2;
                  end;
              end;

            if zylinder<>lba[_dl].zylinder then
              lba_text:='PHYS:'+str0(         zylinder)+'/'+str0(         koepfe)+'/'+str0(         sektoren)
                       +' LBA:'+str0(lba[_dl].zylinder)+'/'+str0(lba[_dl].koepfe)+'/'+str0(lba[_dl].sektoren);

            (* Annahmen: Partitionstabelle ist in der umgewandelten Geometrie..*)
            zylinder:=lba[_dl].zylinder;
            koepfe  :=lba[_dl].koepfe;
            sektoren:=lba[_dl].sektoren;

          end;
      end
    else
      (*$EndIf*)
      begin
        (* erstmal die erweiterte Form versuchen *)
        (*$IfDef DOS*)
        ext_drive_parameter_z:=@ext_drive_parameter;
        (*$EndIf*)
        (*$IfDef DPMI*)
        ext_drive_parameter_z:=Ptr(dos_puffer_sel,0);
        (*$EndIf*)
        with ext_drive_parameter_z^ do
          begin
            FillChar(ext_drive_parameter_z^,SizeOf(ext_drive_parameter_z^),0);
            size_of_buffer          :=SizeOf(ext_drive_parameter_z^);
            (*$IfDef DOS*)
            asm
              push ds
                mov ah,$48
                mov dl,_dl
                lds si,[ext_drive_parameter_z]
                int $13
              pop ds
              shr ax,8
              mov ext_fehler,ax
            end;
            (*$EndIf*)
            (*$IfDef DPMI*)
            loesche_dos_puffer;
            FillChar(r,SizeOf(r),0);
            with r do
              begin
                ah_:=$48;
                dl_:=_dl;
                ds_:=dos_puffer_seg;
                si_:=0;
                intr_realmode(r,$13);
                ext_fehler:=ah_;
              end;
            (*$EndIf*)
          end;



        asm
          cld
          sub ax,ax
          les di,sektoren
          stosw
          les di,zylinder
          stosw
          les di,koepfe
          stosw

          mov ah,$15
          mov dl,_dl
          (*$IfDef DOS*)
          pushf
            call orgbiosint13_einsprung (* INT $13 *)
          (*$Else*)
          int $13
          (*$EndIf*)

          cmp ah,3 (* "Festplatte"? *)
          jnz @fertig

          mov ah,$08
          mov dl,_dl
          (*$IfDef DOS*)
          pushf
            call orgbiosint13_einsprung (* INT $13 *)
          (*$Else*)
          int $13
          (*$EndIf*)

          jc @fertig

          cmp ah,0
          jnz @fertig

          mov al,cl (* Sektoren *)
          and ax,bit00+bit01+bit02+bit03+bit04+bit05
          les di,sektoren
          stosw

          mov al,ch (* Zylinder *)
          shr cl,6  (* Bit 67   *)
          mov ah,cl
          inc ax    (* 0..x     *)
          les di,zylinder
          stosw

          mov al,dh (* Kîpfe    *)
          sub ah,ah
          inc ax    (* 0..x     *)
          les di,koepfe
          stosw

          @fertig:
        end;

        (* systemsoft liefert daten fÅr $48 zurÅck aber $15 ist richtig *)
        if (ext_fehler=0) and (koepfe>0) and (sektoren>0) then
          zylinder:=(ext_drive_parameter_z^.number_of_sectors div longint(koepfe)) div longint(sektoren);
      end;
  end;
(*$EndIf*)

(*$IfDef DPMI32*)
procedure physikalische_festplatten_parameter(const _dl:byte;
                                              var   zylinder,koepfe,sektoren:word_norm;
                                              var   hersteller,lba_text:string);
  var
    floppy_typ          :byte;

  begin
    hersteller:='';
    lba_text:='';
    zylinder:=0;
    koepfe:=0;
    sektoren:=0;

    int_13.get_phys_drive_parameters(
       _dl,
       zylinder,koepfe,sektoren,
       floppy_typ);
  end;
(*$EndIf*)

(*$IfDef LNX_ODER_W32*)
procedure physikalische_festplatten_parameter(const _dl:byte;
                                              var   zylinder,koepfe,sektoren:word_norm;
                                              var   hersteller,lba_text:string);
  begin
    hersteller:='';
    lba_text:='';
    zylinder:=0;
    koepfe:=0;
    sektoren:=0;
  end;
(*$EndIf*)


(*$IfDef OS2*)
function bios_sektor_lesen_alt0(const cx_r,dx_r:smallword;var s_puffer:puffertyp):word_norm;
  begin
    bios_sektor_lesen_alt0:=
      bios_sektor_lesen(
        Lo(dx_r),
        Hi(cx_r)+(Lo(cx_r) shr 6) shl 8(*+(dx_r and (bit15+bit14)) shr (14-10)*),
        Hi(dx_r),
        Lo(cx_r) and $3f,
        0, (* nicht notwendig fÅr die OS/2 Implementierung *)
        0,
        s_puffer);
  end;

function bios_sektor_lesen(const platte,zylinder,kopf,sektor,sektoren_je_spur,anzahl_koepfe:word_norm;
                            var   s_puffer:puffertyp):word_norm;
  var
    laufwerk            :string[3];
    hand                :smallword;

    tl                  :tracklayout;
    tl_laenge           :longint;

    puffer_gelesen      :longint;

  begin
    dateilaenge             :=fast_unendlich;
    quelle.sorte            :=q_sektor_bios_zks;
    quelle.zylinder         :=zylinder;
    quelle.kopf             :=kopf;
    quelle.sektor           :=sektor;
    quelle.platte           :=platte;
    quelle.sektoren_je_spur :=sektoren_je_spur;
    quelle.anzahl_koepfe    :=anzahl_koepfe;

    if platte<$80 then
      begin
        bios_sektor_lesen:=1;
        Exit;
      end;

    s_puffer.g:=0;
    laufwerk:='1:'#0;
    Inc(laufwerk[1],platte-$80);

    (* Zuordnen/ôffnen *)
    fehler:=DosPhysicalDisk(INFO_GETIOCTLHANDLE,@hand,SizeOf(hand),Addr(laufwerk[1]),length(laufwerk));
    if fehler<>0 then
      begin
        bios_sektor_lesen:=fehler;
        Exit;
      end;

    (* Lesen *)
    tl_laenge     :=SizeOf(tl);
    puffer_gelesen:=SizeOf(s_puffer.d);

    with tl do
      begin
        bCommand:=1-1; (* ??? *)
        usHead:=kopf;
        usCylinder:=zylinder;
        usFirstSector:=0;
        cSectors:=1;
        TrackTable[0].usSectorNumber:=sektor;
        TrackTable[0].usSectorSize:=512;
      end;

    fehler:=DosDevIOCtl(hand,ioctl_physicaldisk,pdsk_readphystrack,
                        Addr(tl        ),SizeOf(tl        ),Addr(tl_laenge     ),
                        Addr(s_puffer.d),SizeOf(s_puffer.d),Addr(puffer_gelesen));

    if fehler<>0 then
      begin
        bios_sektor_lesen:=fehler;
        DosPhysicalDisk(INFO_FREEIOCTLHANDLE,
                            ptr(0),0,
                            Addr(hand),2);
        Exit;
      end;

    (* Schliessen *)
    fehler:=DosPhysicalDisk(INFO_FREEIOCTLHANDLE,
                            ptr(0),0,
                            Addr(hand),2);

    if fehler<>0 then
      begin
        bios_sektor_lesen:=fehler;
      end;

    bios_sektor_lesen:=fehler;
    s_puffer.g:=puffer_gelesen;

    if signaturen then
      signatur_anzeige(textz_eiau__Partitionierbare_Platten_IOCTL^,s_puffer);
  end;
(*$EndIf*)

(*$IfDef DPMI32*)
function bios_sektor_lesen_alt0(const cx_r,dx_r:smallword;var s_puffer:puffertyp):word_norm;
  begin
    bios_sektor_lesen_alt0:=
      bios_sektor_lesen(
        Lo(dx_r),
        Hi(cx_r)+(Lo(cx_r) shr 6) shl 8(*+(dx_r and (bit15+bit14)) shr (14-10)*),
        Hi(dx_r),
        Lo(cx_r) and $3f,
        0, (* nicht notwendig fÅr die OS/2 Implementierung *)
        0,
        s_puffer);
  end;


function bios_sektor_lesen(const platte,zylinder,kopf,sektor,sektoren_je_spur,anzahl_koepfe:word_norm;
                            var   s_puffer:puffertyp):word_norm;
  var
    ergebnis:longint;
  begin
    dateilaenge             :=fast_unendlich;
    quelle.sorte            :=q_sektor_bios_zks;
    quelle.zylinder         :=zylinder;
    quelle.kopf             :=kopf;
    quelle.sektor           :=sektor;
    quelle.platte           :=platte;
    quelle.sektoren_je_spur :=sektoren_je_spur;
    quelle.anzahl_koepfe    :=anzahl_koepfe;

    ergebnis:=read_phys_sector(platte,
                               zylinder,
                               kopf,
                               sektor,
                               anzahl_koepfe,
                               sektoren_je_spur,
                               sector_typ(s_puffer.d));
    if ergebnis=0 then
      s_puffer.g:=512
    else
      s_puffer.g:=0;

    bios_sektor_lesen:=ergebnis;

    if signaturen then
      signatur_anzeige(textz_eiau__Platte_INT_13^,s_puffer);
  end;
(*$EndIf*)

(*$IfDef DOS*)
function dos_sektor_lesen(const sektor:dateigroessetyp;const laufwerk:byte;var s_puffer:puffertyp):word;
  var
    int_25_tabelle:
      record
        startsektor     :longint;
        anzahl          :smallword;
        ziel            :pointer;
      end;
    versuche            :byte;
    fehler,
    sektor_word         :smallword;
    int_25_tabelle_seg,
    int_25_tabelle_ofs  :smallword;
  begin
    longint_z(@s_puffer.d[$080])^:=$12345678;
    longint_z(@s_puffer.d[$100])^:=$12345678;
    dateilaenge:=fast_unendlich;
    quelle.sorte:=q_sektor_dos;
    quelle.dos_nr:=sektor;
    quelle.dos_lw:=laufwerk;

    fehler:=0;
    versuche:=2;
    if dos_version<4 then
      begin
        sektor_word:=word(sektor and $FFFF);
        int_25_tabelle_seg:=seg(s_puffer.d);
        int_25_tabelle_ofs:=Ofs(s_puffer.d);
        repeat
          Dec(versuche);
          asm
            mov al,laufwerk
            mov cx,$0001
            mov dx,sektor_word
            mov bx,int_25_tabelle_seg
            push ds
              push bx
                mov bx,int_25_tabelle_ofs
              pop ds
              int $25
              pop ds
            pop ds
            jc @1
            mov ax,$0000
            @1:
            mov fehler,ax
          end;
        until (versuche=0) or (fehler=0);

        if fehler=0 then
          begin
            s_puffer.g:=512;
            if longint_z(@s_puffer.d[$100])^=$12345678 then
              if longint_z(@s_puffer.d[$080])^=$12345678 then
                s_puffer.g:=128
              else
                s_puffer.g:=256;
          end
        else
          begin
            FillChar(s_puffer.d,512,0);
            s_puffer.g:=0;
          end;
      end
    else
      begin
        int_25_tabelle_seg:=seg(int_25_tabelle);
        int_25_tabelle_ofs:=Ofs(int_25_tabelle);
        repeat
          Dec(versuche);
          int_25_tabelle.startsektor:=sektor;
          int_25_tabelle.anzahl:=1;
          int_25_tabelle.ziel:=@s_puffer.d;

          asm
            push ds
              mov al,laufwerk
              mov cx,$FFFF
              mov dx,0
              mov bx,int_25_tabelle_seg
              push bx
                mov bx,int_25_tabelle_ofs
              pop ds
                int $25
              pop ds
            pop ds
            jc @1
            mov ax,$0000
            @1:
            mov fehler,ax
          end;
        until (versuche=0) or (fehler=0);
        if fehler=0 then
          begin
            s_puffer.g:=512;
            if longint_z(@s_puffer.d[$100])^=$12345678 then
              if longint_z(@s_puffer.d[$080])^=$12345678 then
                s_puffer.g:=128
              else
                s_puffer.g:=256;
          end
        else
          begin
            FillChar(s_puffer.d,512,0);
            s_puffer.g:=0;
          end;
      end;
    dos_sektor_lesen:=fehler;
    if signaturen then signatur_anzeige(textz_eiau__Platte_DOS^,s_puffer);
  end;
(*$EndIf*)

(*$IfDef DPMI*)
function dos_sektor_lesen(const sektor:longint;const laufwerk:byte;var s_puffer:puffertyp):word;
  type
    int_25_tabelle=
      record
        startsektor     :longint;
        anzahl          :smallword;
        ziel            :pointer;
      end;
    int_25_tabelle_z    =^int_25_tabelle;
  var
    versuche            :byte;
    fehler              :word_norm;
    r                   :real_mode_call_structure_typ;
  begin
    loesche_dos_puffer;
    MemL[dos_puffer_sel:$080]:=$12345678;
    MemL[dos_puffer_sel:$100]:=$12345678;
    dateilaenge:=fast_unendlich;
    quelle.sorte:=q_sektor_dos;
    quelle.dos_nr:=sektor;
    quelle.dos_lw:=laufwerk;

    fehler:=0;
    versuche:=2;

    if dos_version<4 then
      repeat
        Dec(versuche);
        with r do
          begin
            FillChar(r,SizeOf(r),0);
            ip_:=lies_speicher_word($0000,$25*4+0);
            cs_:=lies_speicher_word($0000,$25*4+2);
            al_:=laufwerk;
            cx_:=$0001;
            dx_:=word(sektor);
            ds_:=dos_puffer_seg;
            bx_:=0;
            callf_realmode(r);

            if (flags_ and fCarry)=0 then
              fehler:=0
            else
              fehler:=ax_;
          end;
      until (versuche=0) or (fehler=0)

    else
      repeat
        Dec(versuche);
        with r do
          with int_25_tabelle_z(@Mem[dos_puffer_sel:4096])^ do
            begin
              startsektor:=sektor;
              anzahl:=1;
              ziel:=Ptr(dos_puffer_seg,0);

              ip_:=lies_speicher_word($0000,$25*4+0);
              cs_:=lies_speicher_word($0000,$25*4+2);
              al_:=laufwerk;
              cx_:=$ffff;
              ds_:=dos_puffer_seg;
              bx_:=4096;
              callf_realmode(r);

              if (flags_ and fCarry)=0 then
                fehler:=0
              else
                fehler:=ax_;
            end;
        until (versuche=0) or (fehler=0);


    if fehler=0 then
      begin
        Move(MemL[dos_puffer_sel:0],s_puffer.d,512);
        s_puffer.g:=512;
        if longint_z(@s_puffer.d[$100])^=$12345678 then
          if longint_z(@s_puffer.d[$080])^=$12345678 then
            s_puffer.g:=128
          else
            s_puffer.g:=256;
      end
    else
      begin
        FillChar(s_puffer.d,512,0);
        s_puffer.g:=0;
      end;

    dos_sektor_lesen:=fehler;
    if signaturen then
      signatur_anzeige(textz_eiau__Platte_DOS^,s_puffer);
  end;
(*$EndIf*)

(*$IfDef OS2*)

(*$IfOpt X-*)
(*$X+*)
(*$Define XX*)
(*$EndIf*)

function ifs_name(const laufwerk:char):string;
  var
    fehler              :word_norm;
    laufwerk_zk         :string[3];
    ifs_puffer          :Array[0..SizeOf(FSQBUFFER2) + (3 * CCHMAXPATH)] of char;
    ifs_puffer_groesse  :longint;
    ifs_name_pos        :longint;
  begin
    fillchar(ifs_puffer,SizeOf(ifs_puffer),0);
    laufwerk_zk:=laufwerk+':'+#0;
    ifs_puffer_groesse:=SizeOf(ifs_puffer);
    fehler:=DosQueryFSAttach(pchar(@laufwerk_zk[1]),1,FSAIL_QUERYNAME,pFsqBuffer2(@ifs_puffer),ifs_puffer_groesse);
    ifs_name_pos:=8;
    while ifs_puffer[ifs_name_pos]<>#0 do Inc(ifs_name_pos);
    Inc(ifs_name_pos);
    ifs_name:=puffer_zu_zk_e(ifs_puffer[ifs_name_pos],#0,CCHMAXPATH);
  end;

function dos_sektor_lesen(const sektor:dateigroessetyp;const laufwerk:byte;var s_puffer:puffertyp):word;
  var
    hfFileHandle        :longint;
    gelesen             :longint;
    ulAction            :longint;
    laufwerk_zk         :string[3];
    datalen,paralen     :ULong;
    f_sicher            :array[0..512*2] of byte;
    p_sicher            :pointer;
    (*$IfDef LargeFileSupport*)
    actual_pos          :dateigroessetyp;
    (*$Else LargeFileSupport*)
    actual_pos          :word_norm;
    (*$EndIf LargeFileSupport*)

  const
    para                :longint=$DEADFACE;

  begin
    p_sicher:=Fix_64K(@f_sicher,512);
    gelesen:=0;
    dateilaenge:=fast_unendlich;
    quelle.sorte:=q_sektor_dos;
    quelle.dos_nr:=sektor;
    quelle.dos_lw:=laufwerk;

    laufwerk_zk:=chr(ord('A')+laufwerk)+':'#0;

    fehler:=DosOpen(Addr(laufwerk_zk[1]),hfFileHandle,ulAction,0,0,FILE_OPEN,
                    OPEN_FLAGS_DASD or OPEN_SHARE_DENYNONE or OPEN_ACCESS_READONLY,
                    nil);
    if fehler=NO_ERROR then
      begin (* offen *)

        //!!!64 bit!
        (*$IfDef LargeFileSupport*)
        fehler:=SysFileSeek(hfFileHandle,sektor*512,FILE_BEGIN,actual_pos);
        (*$Else*)
        fehler:=DosSetFilePtr(hfFileHandle,DGT_zu_longint(sektor*512),FILE_BEGIN,actual_pos);
        (*$EndIf*)
        if fehler=NO_ERROR then
          begin

            (*$IfDef LargeFileSupport*)
            fehler:=SysFileRead(hfFileHandle,p_sicher^{s_puffer.d},512,gelesen);
            (*$Else*)
            fehler:=DosRead(hfFileHandle,p_sicher^{s_puffer.d},512,gelesen);
            (*$EndIf*)
            Move(p_sicher^,s_puffer.d,512);

            if (fehler=5) {or true}  then
              begin (* HPFS >4 GB *)
                datalen:=0;
                paralen:=SizeOf(para);
                fehler:=DosFSCtl(nil  ,datalen,datalen,
                                 @para,paralen,paralen,
                                 $9014,
                                 nil,hfFileHandle,fsctl_Handle);
                if fehler=NO_ERROR then
                  begin (* Byte->Sektormodus *)
                    (*$IfDef LargeFileSupport*)
                    fehler:=SysFileSeek(hfFileHandle,sektor,FILE_BEGIN,actual_pos);
                    (*$Else*)
                    fehler:=DosSetFilePtr(hfFileHandle,DGT_zu_longint(sektor),FILE_BEGIN,actual_pos);
                    (*$EndIf*)
                    if fehler=NO_ERROR then
                      begin
                        fehler:=DosRead(hfFileHandle,p_sicher^{s_puffer.d},1,gelesen);
                        Move(p_sicher^,s_puffer.d,512);
                      end;
                  end; (* *512 *)

              end; (* >4 GB *)

          end; (* seek(0) *)

        DosClose(hfFileHandle);

      end; (* offen *)


    s_puffer.g:=gelesen;

    if fehler=NO_ERROR then
      s_puffer.g:=512
    else
      FillChar(s_puffer,SizeOf(s_puffer),0);

    dos_sektor_lesen:=fehler;

    if signaturen then
      signatur_anzeige(textz_eiau__Platte_OS2^,s_puffer);

  end;
(*$IfDef XX*)
(*$X-*)
(*$UnDef XX*)
(*$EndIf*)

(*$EndIf*)

(*$IfDef DPMI32*)
function dos_sektor_lesen(const sektor:dateigroessetyp;const laufwerk:byte;var s_puffer:puffertyp):word;
  var
    l:longint;
  begin
    dateilaenge:=fast_unendlich;
    quelle.sorte:=q_sektor_dos;
    quelle.dos_nr:=sektor;
    quelle.dos_lw:=laufwerk;

    l:=sector_size(laufwerk);
    if l<=SizeOf(s_puffer.d) then
      begin
        s_puffer.g:=l;
        dos_sektor_lesen:=read_logical_sector(laufwerk,s_puffer.d,DGT_zu_longint(sektor));
      end
    else
      begin
        s_puffer.g:=0;
        dos_sektor_lesen:=8;
      end;
    if signaturen then signatur_anzeige(textz_eiau__Platte_DOS^,s_puffer);
  end;
(*$EndIf*)

(*$IfDef LNX_ODER_W32*)
function dos_sektor_lesen(const sektor:dateigroessetyp;const laufwerk:byte;var s_puffer:puffertyp):word;
  begin
    dos_sektor_lesen:=99;
  end;
(*$EndIf*)

(*$IfDef LNX_ODER_W32*)
function bios_sektor_lesen_alt0(const cx_r,dx_r:smallword;var s_puffer:puffertyp):word_norm;
  begin
    bios_sektor_lesen_alt0:=99;
  end;
function  bios_sektor_lesen(const platte,zylinder,kopf,sektor,sektoren_je_spur,anzahl_koepfe:word_norm;
                            var   s_puffer:puffertyp):word_norm;
  begin
    bios_sektor_lesen:=99;
  end;
(*$EndIf*)

procedure signatur_anzeige(const t:string;const p:puffertyp);
  var
    zw                  :byte;
    szk                 :string[80];
    posi,zae            :word_norm;
    xzk                 :string;
  begin
    Dec(herstellersuche);
    sofortanzeige:=falsch;
    if t<>'' then
      ausschrift(t,signatur);
    posi:=0;
    while posi<=p.g do
      begin
        xzk:='';
        for zae:=0 to 15 do
          if posi+zae<p.g then xzk:=xzk+ (* hex(p.d[posi+zae])+ *) ' '+copy(hex(p.d[posi+zae]),2,2);

        while length(xzk)<16*3+3 do xzk:=xzk+' ';
        for zae:=0 to 15 do
          if posi+zae<p.g then
            if (p.d[posi+zae] in [0,7,8,9,10,13,26]) then
              xzk:=xzk+' '
            else
              xzk:=xzk+chr(p.d[posi+zae]);

        if xzk[2]<>' ' then ausschrift(xzk,signatur);
        Inc(posi,16);
      end;
    Inc(herstellersuche);
    nachholen;
  end;

procedure datei_oeffnen;
  (*$IfDef LargeFileSupport*)
  var
    pos0                :dateigroessetyp;
  (*$EndIf LargeFileSupport*)
  begin
    vergiss_cache;
    quelle.sorte:=q_datei;
    analyseoff:=0;
    (*$I-*)
    Reset(datei,1);
    (*$I+*)
    fehler:=IOResult;
    if fehler<>0 then
      begin
        ausschrift_x(textz_eiau__Fehler_leer_anf^+fehlertext(fehler)+textz_eiau__anf_leer_beim_oeffnen^,dat_fehler,vorne);
        Exit;
      end;



    (*$IfDef LargeFileSupport*)
    fehler:=SysFileSeek(FileRec(datei).Handle,0,2,dateilaenge);
            SysFileSeek(FileRec(datei).Handle,0,2,pos0);
    (*$Else LargeFileSupport*)
    (*$I-*)
    dateilaenge:=FileSize(datei);
    (*$I+*)
    fehler:=IOResult;
    (*$EndIf LargeFileSupport*)
    if fehler<>0 then
      begin
        ausschrift_x(textz_eiau__Fehler_leer_anf^+fehlertext(fehler)
         +textz_eiau__anf_leer_beim_Bestimmen_der_Groesse^,dat_fehler,vorne);
        Exit;
      end;

    codebuilder:=falsch;
    x_exe_ofs:=0;
    x_exe_basis:=0;
    x_exe_vorhanden:=false;
    hmi_386:=falsch;
    pocket_soft:=falsch;
    textdatei_offen:=true;
    textdatei_seek_position:=0;
  end;

const
  (* nur fÅr Dateien *)
  (*$IfDef VirtualPascal*)
  cache_puffer_groesse  =2048;
  cache_bloecke         =  60;
  (*$Else*)
  cache_puffer_groesse  =1024;
  cache_bloecke         =   3;
  (*$EndIf*)

var
  cache_p1,
  cache_p2              :puffertyp; (* fÅr q_sektor_dos und q_sektor_bios.. *)
  cache_quelle          :quelle_typ;

  cache_puffer          :array[1..cache_bloecke] of array[0..cache_puffer_groesse-1] of byte;
  cache_puffer_start    :array[1..cache_bloecke] of dateigroessetyp;
  cache_puffer_status   :array[1..cache_bloecke] of (geleert,gefuellt);
  cache_puffer_gefuellt :array[1..cache_bloecke] of blockread_groesse;
  cache_zuletzt_benutzt :array[1..cache_bloecke] of word_norm;
  anzahl_bloecke_benutzt:word_norm;

procedure vergiss_cache;
  var
    z:word_norm;
  begin
    for z:=1 to cache_bloecke do
      begin
        cache_puffer_status[z]:=geleert;
        cache_zuletzt_benutzt[z]:=cache_bloecke+1;
      end;
    anzahl_bloecke_benutzt:=0;
    quelle.sorte:=q_datei;
  end;

(*$IfDef CACHE_STATISTIK*)
const
  aufrufe  :longint=0;
  vonplatte:longint=0;
(*$EndIf*)

(*$IfDef DOS*)
procedure datei_lesen_far(var puffer:puffertyp;off:dateigroessetyp;anz_byte:word_norm);
(*$Else*)
procedure datei_lesen(var puffer:puffertyp;off:dateigroessetyp;anz_byte:word_norm);
(*$EndIf*)
  var
    fehler              :word;
    gelesen             :blockread_groesse;
    fe                  :word;
    r                   :dateigroessetyp;
    z,z2                :word_norm;

    uebrig              :word_norm;
    ofs                 :dateigroessetyp;
    jetzt               :dateigroessetyp;
    bl                  :word_norm;
    wert                :word_norm;
    actual_pos          :dateigroessetyp;
  begin
    FillChar(puffer,SizeOf(puffer),$cc);

    (* mîglich? if sofortanzeige then *)
    benutzer_abfrage(false,false);

    if (anz_byte>SizeOf(puffer.d)) or (anz_byte<0) then
      begin
        (*$IfNDef Endversion*)
        RunError(6);
        (*$EndIf*)
        anz_byte:=SizeOf(puffer.d);
      end;

    if off<0 then
      begin
        (*$IfNDef ENDVERSION*)
        ausschrift('[Lesen au·erhalb der Dateigrenzen]',dat_fehler);
        (*$IfDef VirtualPascal*)
        if DebugHook then
          asm int 3 end;
        (*$EndIf*)
        (*$EndIf*)
        FillChar(puffer,anz_byte,0);
        Exit;
      end;



    case quelle.sorte of
      q_datei:
        begin

          if off>dateilaenge then
            begin
              FillChar(puffer,anz_byte,0);
              Exit;
            end;

          (* Datei nicht mehr lang genug? *)

          r:=dateilaenge-off;
          if r<anz_byte then
            begin
              FillChar(puffer.d[DGT_zu_longint(r)],DGT_zu_longint(anz_byte-r),0);
              anz_byte:=DGT_zu_longint(r);
            end;


          uebrig:=anz_byte;
          ofs:=off;
          puffer.g:=0;

          while uebrig>0 do
            begin

             (*$IfDef CACHE_STATISTIK*)
             Inc(aufrufe);
             (*$EndIf*)

              jetzt:=0; (* "Nichts erreicht" *)

              for z:=1 to cache_bloecke do
                if  (cache_puffer_status[z]=gefuellt)
                and (cache_puffer_start[z]<=ofs)
                and (cache_puffer_start[z]+cache_puffer_gefuellt[z]>ofs)
                 then
                  begin
                    (* aus CACHE holen *)

                    jetzt:=cache_puffer_start[z]+cache_puffer_gefuellt[z]-ofs;
                    if jetzt>uebrig then
                      jetzt:=uebrig;
                    Move(cache_puffer[z][DGT_zu_longint(ofs-cache_puffer_start[z])],
                         puffer.d[puffer.g],
                         DGT_zu_longint(jetzt));
                    Inc(puffer.g,DGT_zu_longint(jetzt));
                    IncDGT(ofs,jetzt);
                    Dec(uebrig,DGT_zu_longint(jetzt));

                    (* Benutzung mitzÑhlen *)
                    for z2:=1 to cache_bloecke do
                      if z2<>z then
                        if cache_zuletzt_benutzt[z2]<cache_zuletzt_benutzt[z] then
                          Inc(cache_zuletzt_benutzt[z2]);
                    cache_zuletzt_benutzt[z]:=1;
                    Break; (* Weitersuchen nicht nîtig *)
                  end;

              if jetzt=0 then (* Wirklich nichts erreicht *)
                begin
                  (*$IfDef CACHE_STATISTIK*)
                  Inc(vonplatte);
                  (*$EndIf*)

                  (* -> in den cache laden *)
                  (* aber in welchen Block? *)

                  if anzahl_bloecke_benutzt=cache_bloecke then
                    begin (* einen rauswerfen *)
                      bl:=0;
                      wert:=0;
                      for z:=1 to cache_bloecke do
                        if wert<cache_zuletzt_benutzt[z] then
                          begin
                            wert:=cache_zuletzt_benutzt[z];
                            bl:=z;
                          end;
                      Dec(anzahl_bloecke_benutzt);
                      cache_puffer_status[bl]:=geleert;
                    end;

                  (* freien Block suchen *)
                  bl:=0;
                  repeat
                    Inc(bl);
                  until cache_puffer_status[bl]=geleert;

                  Inc(anzahl_bloecke_benutzt);
                  cache_puffer_status[bl]:=gefuellt;

                  cache_puffer_start[bl]:=AndDGT(ofs,-cache_puffer_groesse);
                  r:=dateilaenge-cache_puffer_start[bl];
                  if r>cache_puffer_groesse then
                    r:=cache_puffer_groesse;
                  cache_puffer_gefuellt[bl]:=DGT_zu_longint(r);
                  cache_zuletzt_benutzt[bl]:=anzahl_bloecke_benutzt; (* wird spÑter verbessert *)

                  (* CACHE fÅllen *)

                  (*$IfDef LargeFileSupport*)
                  fehler:=SysFileSeek(FileRec(datei).Handle,cache_puffer_start[bl],0,actual_pos);
                  (*$Else*)
                  (*$I-*)
                  Seek(datei,DGT_zu_longint(cache_puffer_start[bl]));
                  (*$I+*)
                  fehler:=IOResult;
                  (*$EndIf*)
                  (*if fehler<>0 then
                    abbruch(textz_eiau__Seek_Fehler^,fehler);*)

                  if fehler<>0 then
                    begin
                      ausschrift_x(textz_eiau__Positionierungsfehler_leer_anf^+fehlertext(fehler)
                        +textz_eiau__anf_leer_auf^+DGT_str0(cache_puffer_start[bl])+'!',dat_fehler,vorne);
                      FillChar(cache_puffer[bl],cache_puffer_groesse,0);
                    end
                  else
                    begin
                      (*$I-*)
                      BlockRead(datei,cache_puffer[bl],DGT_zu_longint(r),gelesen);
                      (*$I+*)
                      fehler:=IOResult;

                      if (gelesen<>r) or (fehler<>0) then
                        begin
                          ausschrift_x(textz_eiau__Lesefehler_leer_anf^+fehlertext(fehler)
                             +textz_eiau__anf_leer_bei_Position^
                             +DGT_str0(cache_puffer_start[bl]+gelesen)+'!',dat_fehler,vorne);
                          FillChar(cache_puffer[bl],cache_puffer_groesse,0);
                        end;

                    end;
                end;

            end; (* while *)

          if signaturen then
            signatur_anzeige(textz_eiau__Datei_leer_klammer^+DGT_str0(off)+')',puffer);

          (*$IfDef CACHE_STATISTIK*)
          ausschrift(strx(vonplatte,11)+' / '+strx(aufrufe,11),normal);
          (*$EndIf*)
        end;

      q_speicher:
        begin
          quelle_kopie:=quelle;
          speicher_lesen(DGT_zu_longint(off) shr 4,DGT_zu_longint(off) and $f,puffer,anz_byte);
          quelle:=quelle_kopie;
        end;

      q_sektor_bios_cxdx:
        begin
          (* relativ zum ersten gelesenen Sektor *)
          quelle_kopie:=quelle;
          Inc(quelle.bios_cx,DGT_zu_longint(off) shr 9); (* div 512 *) (*!!!*)
          off:=AndDGT(off,512-1); (* off:=off mod 512;*)

          if (cache_quelle.sorte   <>q_sektor_bios_cxdx)
          or (cache_quelle.bios_cx <>quelle.bios_cx)
          or (cache_quelle.bios_dx <>quelle.bios_dx)
           then
            begin
              cache_quelle:=quelle;
              fe:=bios_sektor_lesen_alt0(quelle.bios_cx+0,quelle.bios_dx,cache_p1);
              fe:=bios_sektor_lesen_alt0(quelle.bios_cx+1,quelle.bios_dx,cache_p2);
            end;

          Move(cache_p1.d[DGT_zu_longint(off)],puffer.d[0      ],512-DGT_zu_longint(off));
          if off>0 then
            Move(cache_p2.d[512-DGT_zu_longint(off)],puffer.d[512-DGT_zu_longint(off)],DGT_zu_longint(off));
          puffer.g:=anz_byte;

          quelle:=quelle_kopie;
        end;

      q_sektor_bios_zks:
        begin
          (* relativ zum ersten gelesenen Sektor *)
          quelle_kopie:=quelle;
          Inc(quelle.sektor,DGT_zu_longint(off) shr 9); (* div 512 *)
          off:=AndDGT(off,512-1); (* off:=off mod 512;*)

          if (cache_quelle.sorte   <>q_sektor_bios_zks )
          or (cache_quelle.zylinder<>quelle.zylinder   )
          or (cache_quelle.kopf    <>quelle.kopf       )
          or (cache_quelle.sektor  <>quelle.sektor     )
          or (cache_quelle.platte  <>quelle.platte     )
           then
            with quelle do
              begin
                cache_quelle:=quelle;
                fe:=bios_sektor_lesen(platte,zylinder,kopf,sektor  ,sektoren_je_spur,anzahl_koepfe,cache_p1);
                fe:=bios_sektor_lesen(platte,zylinder,kopf,sektor+1,sektoren_je_spur,anzahl_koepfe,cache_p2);
              end;

          Move(cache_p1.d[DGT_zu_longint(off)],puffer.d[0],512-DGT_zu_longint(off));
          if off>0 then
            Move(cache_p2.d[512-DGT_zu_longint(off)],puffer.d[512-DGT_zu_longint(off)],DGT_zu_longint(off));
          puffer.g:=anz_byte;

          quelle:=quelle_kopie;
        end;

      q_sektor_dos:
        begin
          (* relativ zum ersten gelesenen Sektor *)
          quelle_kopie:=quelle;
          IncDGT(quelle.dos_nr,DivDGT(off,512)); (* div 512 *)
          off:=AndDGT(off,512-1); (* off:=off mod 512;*)

          if not ((cache_quelle.dos_nr=quelle.dos_nr) and
                  (cache_quelle.dos_lw=quelle.dos_lw) and
                  (cache_quelle.sorte=q_sektor_dos))
                  then
            begin
              cache_quelle:=quelle;
              fe:=dos_sektor_lesen(0+quelle.dos_nr,quelle.dos_lw,cache_p1);
              fe:=dos_sektor_lesen(1+quelle.dos_nr,quelle.dos_lw,cache_p2);
            end;

          Move(cache_p1.d[DGT_zu_longint(off)],puffer.d[0],512-DGT_zu_longint(off));
          if off>0 then
            Move(cache_p2.d[512-DGT_zu_longint(off)],puffer.d[512-DGT_zu_longint(off)],DGT_zu_longint(off));
          puffer.g:=anz_byte;
          quelle:=quelle_kopie;
        end;
      (*$IfDef OS2*)
      q_ea:
        begin
          quelle_kopie:=quelle;
          ea_lesen(off,puffer,anz_byte);
          quelle:=quelle_kopie;
        end;
      (*$EndIf*)
      q_entpackt_puffer:
        begin
          r:=quelle.entpackt_laenge-off;
          if r>anz_byte then
            r:=anz_byte;
          if r<=0 then
            FillChar(puffer,SizeOf(puffer),0)
          else
            begin
              Move(q_entpackt_puffer_speicher[DGT_zu_longint(off)],puffer.d,DGT_zu_longint(r));
              puffer.g:=DGT_zu_longint(r);
              (*if r<>anz_byte then asm int 3 end;*)
            end;
        end;

      end;
  end;

procedure datei_lesen_grosser_block(var p;const off:dateigroessetyp;const anz_byte:word_norm);
  var
    posi                :word_norm;
    uebrig              :word_norm;
    jetzt               :word_norm;
    tmp                 :puffertyp;
    ps                  :speicherbereich absolute p;
  begin
    posi:=0;
    uebrig:=anz_byte;
    while uebrig>0 do
      begin
        if uebrig>SizeOf(tmp.d) then
          jetzt:=SizeOf(tmp.d)
        else
          jetzt:=uebrig;
        datei_lesen(tmp,off+posi,jetzt);
        Move(tmp.d[0],ps[posi],jetzt);
        Inc(posi,jetzt);
        Dec(uebrig,jetzt);
      end;
  end;

procedure datei_schliessen;
  begin
    (*$I-*)
    Close(datei);
    (*$I+*)
    fehler:=IOResult;
    if fehler<>0 then
      ausschrift_x(textz_eiau__Fehler_leer_anf^+fehlertext(fehler)+textz_eiau__anf_leer_beim_Schliessen^,dat_fehler,vorne);
  end;

procedure speicher_lesen(const quell_seg,quell_off:word;var ziel:puffertyp;const anz_byte:word_norm);
  (*$IfDef OS2*)
  var
    hand,
    action,
    phys,
    rc                  :longint;

    ParmRec1:
      record            // Input parameter record
        phys32          :longint;
        laenge          :smallword;
      end;

    ParmRec2:
      record
        sel             :smallword;
      end;

    ParmLen             : ULong;  // Parameter length in bytes
    DataLen             : ULong;  // Data length in bytes
    Data1:
      record
        sel             :smallword;
      end;

  (*$EndIf*)

  (*$IfDef DPMI*)
  var
    sel                 :smallword;
  (*$EndIf*)

  begin
    dateilaenge:=fast_unendlich;

    ziel.g:=0;

    (*$IfDef DOS*)
    quelle.sorte:=q_speicher;
    ziel.g:=anz_byte;
    Move(ptr(quell_seg,quell_off)^,ziel.d,anz_byte);
    (*$EndIf*)

    (*$IfDef DPMI*)
    quelle.sorte:=q_speicher;
    ziel.g:=anz_byte;
    asm
      mov ax,$0002              (* DPMI: segment->descriptor *)
      mov bx,quell_seg
      int $31
      jnc @l1

      sub ax,ax

    @l1:
      mov sel,ax
    end;
    Move(Ptr(sel,quell_off)^,ziel.d,anz_byte);
    (*$EndIf*)

    (*$IfDef DPMI32*)
    quelle.sorte:=q_speicher;
    ziel.g:=anz_byte;
    Move(ptr(seg0000+quell_seg*16+quell_off)^,ziel.d,anz_byte);
    (*$EndIf*)


    (*$IfDef OS2*)
    quelle.sorte:=q_speicher;
    ziel.g:=0;

    if DosOpen('SCREEN$',hand,action,0,0,1,$40,nil)<>0 then
      exit;

    phys:=quell_seg*16+quell_off;
    (*$IfNDef ENDVERSION*)
    dateiname:='MEM ['+hex_word(quell_seg)+':'+hex_word(quell_off)+','+hex_word(anz_byte)+']';
    (*$EndIf*)
    ParmLen:=SizeOf(ParmRec1);

    with ParmRec1 do
      begin
        phys32:=(phys div 4096)*4096;
        laenge:=4096;
        if phys32+laenge<phys+anz_byte then
          Inc(laenge,4096);
      end;

    datalen:=SizeOf(data1);
    rc:=DosDevIOCtl(
            hand,                       // Handle to device
            IOCTL_SCR_AND_PTRDRAW,      // Category of request
            SCR_ALLOCLDT,               // Function being requested
            @ParmRec1,                  // Input/Output parameter list
            ParmLen,                    // Maximum output parameter size
            Addr(ParmLen),              // Input:  size of parameter list
                                        // Output: size of parameters returned
            @Data1,                     // Input/Output data area
            Datalen,                    // Maximum output data size
            Addr(DataLen));             // Input:  size of input data area
    if rc=0 then
      begin

        asm (*$SAVES NONE*)
          push gs

            mov esi,phys
            and esi,(4096-1)
            mov gs,data1.sel

            mov edi,ziel
            inc edi  (* ziel.d *)
            inc edi

            mov ecx,anz_byte
            jecxz @l2

            cld
          @l1:
            mov al,gs:[esi]
            inc esi
            stosb
            loop @l1

          @l2:

          pop gs
        end;
        ziel.g:=anz_byte;

        ParmLen:=SizeOf(ParmRec2);

        with ParmRec2 do
          begin
            sel:=data1.sel;
          end;

        DataLen:=0;
        rc:=DosDevIOCtl(
                hand,                           // Handle to device
                IOCTL_SCR_AND_PTRDRAW,          // Category of request
                SCR_DEALLOCLDT,                 // Function being requested
                @ParmRec2,                      // Input/Output parameter list
                ParmLen,                        // Maximum output parameter size
                Addr(ParmLen),                  // Input:  size of parameter list
                                                // Output: size of parameters returned
                nil,                            // Input/Output data area
                Datalen,                        // Maximum output data size
                Addr(DataLen));                 // Input:  size of input data area

    (*$IfNDef ENDVERSION*)
      end
    else
      begin
        ausschrift('Lesefehler!: '+dateiname,dat_fehler);
    (*$EndIf*)
      end;

    DosClose(hand);
    (*$EndIf*)

    if signaturen then signatur_anzeige(textz_eiau__Speicher_leer_klammer^
      +hex_word(quell_seg)+':'+hex_word(quell_off)+')',ziel);
  end;

(*$IfDef DPMI*)
function lies_speicher_word(const seg,ofs:word):word;
  var
    sp:puffertyp;
    qu:quelle_typ;
  begin
    qu:=quelle;
    speicher_lesen(seg,ofs,sp,2);
    lies_speicher_word:=word_z(@sp.d[0])^;
    quelle:=qu;
  end;
(*$EndIf*)


procedure text_lesen(var zeile:string);
  var
    lp:puffertyp;
  begin
    datei_lesen(lp,textdatei_seek_position,257);
    if lp.g=0 then
      begin
        zeile:='';
        textdatei_offen:=false;
      end
    else
      begin
        zeile:=puffer_zu_zk_zeilenende(lp.d[0],lp.g);
        Inc(textdatei_seek_position,length(zeile));

        if lp.d[length(zeile)]=$0d then (* $0d$0a *)
          Inc(textdatei_seek_position,2)
        else
          if lp.d[length(zeile)]=$0a then (* $0a *)
          Inc(textdatei_seek_position,1)
      end;
  end;

(*$IfDef OS2*)
var
  ea_puffer             :array[0..$ffff] of byte;
  ea_daten_puffer       :array[0..$ffff] of byte;
  rc                    :longint;
  ea_anzahl             :longint;
  tempname              :string;
  zaehler_ea            :longint;
  pea                   :PFea2;

  pEAOP                 :pEAop2;
  pFEA                  :pFEA2;
  pGEA                  :pGEA2;
  offset                :Longint;
  tlength               :Longint;
  kopier_zk             :string;

procedure ea_oeffnen(const dn:string;const titel:string;const auch_ea_daten:boolean);
  (*$IfDef EA_DEBUG*)
  var
    EADEBUG:file;
  (*$EndIf*)
  begin
    quelle.sorte:=q_ea;
    quelle.ea_groesse:=0;
    quelle.ea_anzahl:=0;

    ea_anzahl:=-1;
    tempname:=dn+#0;
    rc:=DosEnumAttribute(enumea_RefType_Path,pchar(@tempname[1]),1,ea_puffer,SizeOf(ea_puffer),
          ea_anzahl,enumea_Level_No_Value);

    if rc<>0 then Exit;           (* Fehler aufgetreten *)

    if ea_anzahl<=0 then Exit;    (* keine vorhanden *)

    if titel<>'' then
      ausschrift_x(titel,normal,vorne);

    if not langformat then        (* Kurzform *)
      begin
        pEA:=PFEa2(Addr(ea_puffer));
        for zaehler_ea:=1 to ea_anzahl do
          begin
            ausschrift_x(puffer_zu_zk_e(pEA^.szName,#0,255)+' : '+str0( pEA^.cbValue)+' Byte EA',signatur,ea_zeichen);
            Inc(longint(pEA), pEA^.oNextEntryOffset );
          end;
        Exit;
      end;

    (* Langformat ... *)

    (* aus VP/2 os2ea.pas *)
    (* Puffer mit Null fÅllen *)
    FillChar(ea_daten_puffer,SizeOf(ea_daten_puffer),0);

    (* Lezezeiger Quelle *)
    pEA:=PFEa2(@ea_puffer);
    (* Schreibpuffer Ziel *)
    pEAOP:=pEAop2(@ea_daten_puffer);

    pEAOP^.fpGEA2List:=Ptr(Longint(pEAOP)+SizeOf(EAOP2));

    pGEA:=Addr(pEAOP^.fpGEA2List^.List[0]);
    offset := 0;

    (* Move all EA's to structure for DosQueryPathInfo *)
    repeat
      (* WeiterrÅcken zum nÑchsten Block *)
      Inc(longint(pEA),offset);
      (* EA Name kopieren *)
      kopier_zk:=puffer_zu_zk_e(pEA^.szName,#0,255)+#0;
      Move(kopier_zk[1],pGEA^.szName,Length(kopier_zk));

      pGEA^.cbName:=Length(kopier_zk)-Length(#0);
      Offset:=pEA^.oNextEntryOffset;
      tlength:=pGEA^.cbName+SizeOf(pGEA^.cbName)+SizeOf(pGEA^.oNextEntryOffset);

      (* DatenlÑnge (leerer Platz): Double word aligned *)
      if tlength mod 4 <> 0 then
        Inc(tlength,4-tlength mod 4);
      Inc(tlength,4); (* D:\EXTRA\BITMAP\BURLAP.BMP .POSTER: 12->16 *)

      if Offset<>0 then
        pGEA^.oNextEntryOffset:=tlength
      else
        pGEA^.oNextEntryOffset:=0;

      Inc(longint(pGEA),tlength);
    until pEA^.oNextEntryOffset=0;

    with PEAOP^, PEAOP^.fpGEA2List^ do
      begin
        cbList:=longint(pGEA)-longint(fpGEA2List);
        fpFEA2List:=ptr(longint(fpGEA2List)+cbList);
        fpFEA2List^.cbList:=SizeOf(ea_puffer)-(longint(fpFEA2List)-longint(pEAOP));
      end;

    (* // Get list of EA values from OS/2 *)
    rc:=DosQueryPathInfo(pchar(@tempname[1]),fil_QueryEAsFromList,
          pEAOP^,SizeOf(EAOP2));
    if rc<>0 then
      begin
        if rc<>254 (* ERROR_INVALID_EA_NAME *)
         then
          ausschrift(textz_eiau__Fehler_leer_anf^+fehlertext(rc)+textz_eiau__anf_leer_beim_Laden_der_EA^,dat_fehler);
        exit;
      end;

    quelle.ea_groesse:=PEAOP^.fpFEA2List^.cbList-4;
    quelle.ea_anzahl:=ea_anzahl;

    dateilaenge  :=quelle.ea_groesse;
    einzel_laenge:=quelle.ea_groesse;
    //naechste_einzel_laenge:=0;

    analyseoff:=0;
    (*$IfDef EA_DEBUG*)
    Assign(EADEBUG,'K:\EADEBUG.DAT');
    Rewrite(EADEBUG,1);
    BlockWrite(EADEBUG,ptr(Ofs(PEAOP^.fpFEA2List^.cbList)+4)^,dateilaenge);
    Close(EADEBUG);
    (*$EndIf*)
  end;

procedure ea_lesen(const o:dateigroessetyp;var p:puffertyp;const anz:word_norm);
  var
    l:dateigroessetyp;
  begin
    l:=dateilaenge-o;
    if l>anz then
      l:=anz;

    if l>0 then
      begin
        p.g:=DGT_zu_longint(l);
        Move(Ptr(Ofs(PEAOP^.fpFEA2List^.cbList)+4+DGT_zu_longint(o))^,p.d,p.g);
        if signaturen then
          signatur_anzeige('EA ('+strxDGT(o,4)+')',p)
      end
    else
      begin
        fillchar(p.d,anz,0);
        p.g:=0;
      end;
  end;
(*$EndIf*)

function byte__datei_lesen   (const o:dateigroessetyp):byte;
  var
    eiau_puffer:puffertyp;
  begin
    datei_lesen(eiau_puffer,o,1);
    byte__datei_lesen:=eiau_puffer.d[0];
  end;

function x_word__datei_lesen   (const o:dateigroessetyp):word;
  var
    eiau_puffer:puffertyp;
  begin
    datei_lesen(eiau_puffer,o,2);
    x_word__datei_lesen:=word_z(@eiau_puffer.d[0])^;
  end;

function x_longint__datei_lesen(const o:dateigroessetyp):longint;
  var
    eiau_puffer:puffertyp;
  begin
    datei_lesen(eiau_puffer,o,4);
    x_longint__datei_lesen:=longint_z(@eiau_puffer.d[0])^;
  end;

function m_word__datei_lesen   (const o:dateigroessetyp):word;
  var
    eiau_puffer:puffertyp;
  begin
    datei_lesen(eiau_puffer,o,2);
    m_word__datei_lesen:=m_word(eiau_puffer.d[0]);
  end;

function m_longint__datei_lesen(const o:dateigroessetyp):longint;
  var
    eiau_puffer:puffertyp;
  begin
    datei_lesen(eiau_puffer,o,4);
    m_longint__datei_lesen:=m_longint(eiau_puffer.d[0]);
  end;

function  x_dateigroessetyp__datei_lesen   (const o:dateigroessetyp):dateigroessetyp;
  var
    eiau_puffer:puffertyp;
  begin
    datei_lesen(eiau_puffer,o,8);
    x_dateigroessetyp__datei_lesen:=dateigroessetyp_z(@eiau_puffer.d[0])^;
  end;


function bytesuche__datei_lesen(const o:dateigroessetyp;const suchfolge:string):boolean;
  var
    eiau_puffer:puffertyp;
  begin
    datei_lesen(eiau_puffer,o,length(suchfolge)+1);
    bytesuche__datei_lesen:=bytesuche(eiau_puffer.d[0],suchfolge);
  end;

function datei_pos_suche(anfang,ende:dateigroessetyp;const suchzk:string):dateigroessetyp;
  var
    posi                :dateigroessetyp;
    gefunden            :word_norm;
    eiau_puffer         :puffertyp;
  begin
    if anfang>ende then
      begin
        if ende<0 then ende:=0;
        posi:=anfang-512;
        if posi<0 then posi:=0;
        repeat
          if posi<ende then posi:=ende;
          datei_lesen(eiau_puffer,posi,512);
          gefunden:=puffer_pos_suche(eiau_puffer,suchzk,512);
          if gefunden<>nicht_gefunden then
            begin
              datei_pos_suche:=posi+gefunden;
              Exit;
            end;
          if posi<=ende then break;
          DecDGT(posi,512-length(suchzk)-10);
        until false;
        datei_pos_suche:=nicht_gefunden;
      end
    else
      begin
        if anfang<0 then anfang:=0;
        posi:=anfang;
        repeat
          datei_lesen(eiau_puffer,posi,512);
          gefunden:=puffer_pos_suche(eiau_puffer,suchzk,512);
          if gefunden<>nicht_gefunden then
            begin
              datei_pos_suche:=posi+gefunden;
              Exit;
            end;
          IncDGT(posi,512-length(suchzk)-10);
        until posi>ende;
        datei_pos_suche:=nicht_gefunden;
      end;

  end;

function  datei_pos_suche_zeilenanfang(anfang,ende:dateigroessetyp;const suchzk:string):dateigroessetyp;
  var
    a,e,gefunden:dateigroessetyp;
  begin
    a:=anfang;
    repeat
      gefunden:=datei_pos_suche(a,ende,suchzk);
      if gefunden=nicht_gefunden then
        begin
          datei_pos_suche_zeilenanfang:=nicht_gefunden;
          Exit;
        end;

      if gefunden=anfang then
        begin
          datei_pos_suche_zeilenanfang:=gefunden;
          Exit;
        end;

      if byte__datei_lesen(gefunden-1) in [$0a,$0d] then
        begin
          datei_pos_suche_zeilenanfang:=gefunden;
          Exit;
        end;

      if anfang<=ende then
        IncDGT(a,1)
      else
        DecDGT(a,1)

    until false;
  end;

function datei_pos_suche_gross(anfang,ende:dateigroessetyp;const suchzk:string):dateigroessetyp;
  var
    posi                :dateigroessetyp;
    gefunden            :word_norm;
    eiau_puffer         :puffertyp;
  begin
    if anfang>ende then (* Suche rÅckwÑrts *)
      begin
        if ende<0 then ende:=0;
        posi:=anfang-512;
        if posi<0 then posi:=0;
        repeat
          if posi<ende then posi:=ende;
          datei_lesen(eiau_puffer,posi,512);
          puffer_gross(eiau_puffer,eiau_puffer);
          gefunden:=puffer_pos_suche_rueckwaerts(eiau_puffer,suchzk,512);
          if (gefunden<>nicht_gefunden)
          and (posi+gefunden<anfang)
          and (posi+gefunden>=ende) (* auch nicht gefunden, wenn vor der unteren Grenze *)
           then
            begin
              datei_pos_suche_gross:=posi+gefunden;
              Exit;
            end;
          if posi<=ende then Break;
          DecDGT(posi,512-length(suchzk)-10);
        until false;
        datei_pos_suche_gross:=nicht_gefunden;
      end
    else
      begin
        if anfang<0 then anfang:=0;
        posi:=anfang;
        repeat
          datei_lesen(eiau_puffer,posi,512);
          puffer_gross(eiau_puffer,eiau_puffer);
          gefunden:=puffer_pos_suche(eiau_puffer,suchzk,512);
          if  (gefunden<>nicht_gefunden)
          and (posi+gefunden<ende)
          and (posi+gefunden>=anfang)
           then
            begin
              datei_pos_suche_gross:=posi+gefunden;
              Exit;
            end;
          IncDGT(posi,512-length(suchzk)-10);
        until posi>ende;
        datei_pos_suche_gross:=nicht_gefunden;
      end;

  end;

function datei_pos_suche_zeilenanfang_gross(anfang,ende:dateigroessetyp;const suchzk:string):dateigroessetyp;
  {$IfNDef VirtualPascal}
  var
    Result              :dateigroessetyp;
  {$EndIf VirtualPascal}
  begin
    Result:=datei_pos_suche_gross(MinDGT(anfang,ende),MinDGT(anfang,ende),suchzk);
    if Result=nicht_gefunden then
      Result:=datei_pos_suche_gross(anfang+1,ende,#$0a+suchzk);
    {$IfNDef VirtualPascal}
    datei_pos_suche_zeilenanfang_gross:=Result;
    {$EndIf VirtualPascal}
  end;


function datei_lesen__zu_zk_e(const dateiposition:dateigroessetyp;const e:string;const maxlaenge:word_norm):string;
  var
    p                   :puffertyp;
    ml                  :word_norm;
  begin
    ml:=maxlaenge;
    if ml>255 then
      ml:=255
    else
      if ml<=0 then
        begin
          datei_lesen__zu_zk_e:='';
          exit;
        end;

    datei_lesen(p,dateiposition,ml);
    datei_lesen__zu_zk_e:=puffer_zu_zk_e(p.d[0],e,ml);
  end;

function datei_lesen__zu_zk_l(const dateiposition:dateigroessetyp;laenge:longint):string;
  var
    p:puffertyp;
  begin
    if laenge>255 then
      laenge:=255
    else
      if laenge<=0 then
        begin
          datei_lesen__zu_zk_l:='';
          Exit;
        end;

    datei_lesen(p,dateiposition,laenge);
    datei_lesen__zu_zk_l:=puffer_zu_zk_l(p.d[0],laenge);
  end;

function datei_lesen__zu_zk_zeilenende(const dateiposition:dateigroessetyp):string;
  var
    p:puffertyp;
    l:word_norm;
  begin
    l:=DGT_zu_longint(MinDGT(256,analyseoff+einzel_laenge-dateiposition));
    if l<0 then l:=0;
    datei_lesen(p,dateiposition,l);
    datei_lesen__zu_zk_zeilenende:=puffer_zu_zk_zeilenende(p.d[0],l);
  end;

function  datei_lesen__zu_zk_pstr(const dateiposition:dateigroessetyp):string;
  var
    p:puffertyp;
  begin
    datei_lesen(p,dateiposition,256);
    datei_lesen__zu_zk_pstr:=puffer_zu_zk_pstr(p.d[0]);
  end;

function uc16_datei_lesen__zu_zk_e(const dateiposition:dateigroessetyp;const e:string;maxl:integer):string;
  var
    p:puffertyp;
  begin
    datei_lesen(p,dateiposition,256);
    uc16_datei_lesen__zu_zk_e:=uc16_puffer_zu_zk_e(p.d[0],e,maxl);
  end;

(*$IfDef DPMI*)
procedure loesche_dos_puffer;
  begin
    FillChar(Ptr(dos_puffer_sel,0)^,8*1024,$ee);
  end;
(*$EndIf*)

procedure weiter_bis_zum_naechsten_zeilenanfang(var posi:dateigroessetyp);
  var
    p                   :puffertyp;
    l                   :dateigroessetyp;
    w1                  :word_norm;
  begin
    repeat
      l:=analyseoff+einzel_laenge-posi;
      if l>SizeOf(p.d) then
        l:=SizeOf(p.d);
      if l<=0 then break;
      datei_lesen(p,posi,DGT_zu_longint(l));
      w1:=puffer_pos_suche(p,#$0a,DGT_zu_longint(l));
      if w1<>nicht_gefunden then
        begin
          IncDGT(posi,w1+1);
          Exit;
        end;
      IncDGT(posi,l);
    until false;

  end;

procedure typ_eiau_init;
  begin
    (*$IfDef OS2*)
    (* VPHRT bietet bessere Auflîsung *)
    (*DosQuerySysInfo(qsv_Timer_Interval,qsv_Timer_Interval,taktgenauigkeit,SizeOf(taktgenauigkeit));*)
    taktgenauigkeit:=310;
    if not multitask then
      typ_eing.starte_tastatur_thread;
    (*$EndIf*)

    (*$IfDef PRUEFE_TAKT*)
    alttakt:=$80000000;
    (*$EndIf*)
    (*$IfDef DOS*)
    hib_alt:=0;
    (*$EndIf*)
    bioswert_alt:=0;
    taktberechnung;
    typ_start_zeit      :=taktwert;
    (*$IfDef DOS*)
    zeit_ziel_spielhebel:=taktwert;
    (*$EndIf*)
    (*$IfNDef OS2*)
    zeit_ziel_maus      :=taktwert;
    zeit_ziel_rollen    :=taktwert;
    (*$EndIf*)


    (*$IfDef DPMI*)
    asm
      mov ax,$0100              (* DPMI: DOS Speicher anfordern *)
      mov bx,512                (* 8KB/16=512                   *)

      int $31
      jnc @l1

      sub ax,ax

    @l1:
      mov dos_puffer_seg,ax
      mov dos_puffer_sel,dx

      mov ax,$0100              (* DPMI: DOS Speicher anfordern *)
      mov bx,512                (* 8KB/16=512                   *)
      int $31
      jnc @l2

      sub ax,ax

    @l2:
      mov dos_stack_seg,ax
      mov dos_stack_sel,dx
    end;
    if dos_puffer_seg=0 then
      RunError(8);
    (*$EndIf*)

  end;

end.

