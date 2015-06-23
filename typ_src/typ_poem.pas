(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf DOS_OVERLAY*)


(* $Define POEM_EINSPAREN*)
(* $Define DEBUG*)
(* $Define DEBUG_REG*)
(* $Define UNBEKANNT_ANZEIGEN*)

(*$IfDef ENDVERSION*)
  (*$UnDef POEM_EINSPAREN*)
  (*$UnDef DEBUG*)
  (*$UnDef DEBUG_REG*)
  (*$UnDef UNBEKANNT_ANZEIGEN*)
(*$EndIf ENDVERSION*)

(*$Define POEM_ROM*)
(*$Define POEM_SYS*)


(*$IfDef VirtualPascal*)
  // nicht nach 0:0 laden sondern nach 1000:0 und Relaktionstabelle anwenden
  // -> Interrupttabelle,BIOS-Datenbereich
  (*$Define ERWEITERTE_EMULATION*)
  (*$Define VIDEO_BIOS*)
  (*$Define POEM_BIO*)
(*$EndIf VirtualPascal*)

(*$IfDef DPMI*)
  (*$Define ERWEITERTE_EMULATION*)
  (*  ???$Define VIDEO_BIOS*)
(*$EndIf DPMI*)

unit typ_poem; (* poly-emulator *)

interface

type
  poem_modus=(poem_modus_normal,poem_modus_sys,poem_modus_rom,poem_modus_sekt);

procedure poly_emulator(const modus:poem_modus);

procedure einrichten_typ_poem(const anfang:boolean);

implementation

(*$IfDef POEM_EINSPAREN*)
procedure poly_emulator(const modus:poem_modus);
  begin
  end;
(*$Else POEM_EINSPAREN*)


(* Probleme:
 ˛ kein Speicher fÅr Interrupttabelle und BIOS-Variablen reserviert
 ˛ [0000046c] Ñndert sich nicht
 ˛ GetIntvec+ pushf call d [] funktioniert nicht (iceunp)
                                                                        *)

uses
  (*$IfDef ERWEITERUNGSDATEI*)
  typ_erw,
  (*$EndIf ERWEITERUNGSDATEI*)
  typ_type,
  typ_var,
  typ_eiau,
  typ_varx,
  typ_ausg,
  typ_dien,
  typ_die2,
  typ_spra,
  typ_spei,
  Dos;

type
  register_16=
    packed record
      l,h:byte;
    end;

  register_32=
    packed record
      case boolean of
        0:(w0,w1:word);
        1:(b0,b1,b2,b3:byte);
        2:(l0:longint);
    end;

  mcb                                   =
    packed record
      sig                               :char;
      eigentuemer                       :smallword;
      anzahl_para                       :smallword;
      leer                              :array[5..7] of byte;
      prgname                           :array[0..7] of char;
    end;

  mcb_z                                 =^mcb;

  (*$IfDef DOS*)
  speicherseite                         =array[0..512] of byte;
  speicherseite_z                       =^speicherseite;
  (*$EndIf DOS*)

  (*$IfDef DPMI*)
  speicherseite                         =array[0..$7fff] of byte;
  speicherseite_z                       =^speicherseite;
  (*$EndIf DPMI*)

  (*$IfDef VirtualPascal*)
  dos_1mb_feld                          =array[0..(1024+64)*1024+4] of byte;
  (*$EndIf VirtualPascal*)

  disk_typ                              =(disk_a,disk_b,disk_c);

(*$IfDef DEBUG*)
const
  debug_ein                             :boolean=not false;
(*$EndIf DEBUG*)

var
  _ax                                   :word;
  _bx                                   :word;
  _cx                                   :word;
  _dx                                   :word;
  _sp                                   :word;
  _bp                                   :word;
  _si                                   :word;
  _di                                   :word;

  _flags                                :word;
  _flags_interrupt                      :boolean;

  postbyte1                             :byte;
  postword1                             :word;
  postbyte2                             :byte;
  postword2                             :word;
  postword3                             :word;
  postbyte1_shr_6                       :byte;
  postbyte1_and_7                       :byte;
  postbyte1_shr_3_and_7                 :byte;

  dumm                                  :longint;

  maustext_gefunden                     :dateigroessetyp;
  ibmbio_text_pos                       :dateigroessetyp;
  _cs                                   :word;
  _ip                                   :word;
  _ds,_es,_ss                           :word;

  schritt                               :longint;
  emu_puffer                            :puffertyp;

  sprung_zaehler                        :longint;
  pacific_cld_gefunden                  :boolean;
  unbekannt1_zaehler                    :integer_norm;

  pos1                                  :dateigroessetyp;

  ziel_8                                :^byte;
  ziel_16                               :^word;
  ziel_32                               :^longint;
  operand_8                             :byte;
  operand_16                            :word;
  tmp16                                 :word;

  (*$IfDef DOS*)
  speicher_bereichs_tabelle_gefuellt    :word_norm;
  speicher_bereichs_tabelle             :
    array[1..(groesse_allgemeiner_zwischenspeicher div SizeOf(speicherseite))] of
      record
        speicherzeiger                  :speicherseite_z;
        wirklichkeitsbereich_anfang     :longint;
        schon_veraendert                :boolean;
      end;
  nichts_mehr_frei                      :longint;
  (*$EndIf DOS*)

  (*$IfDef DPMI*)
  (* 1024*(1024+64)/(32*1024) also 34 32K StÅcke *)
  speicher_bereichs_tabelle             :array[0..34-1] of speicherseite_z;
  (*$EndIf DPMI*)

  (*$IfDef VirtualPascal*)
  poem_dos_speicher                     :^dos_1mb_feld=nil;
  (*$EndIf VirtualPascal*)

  segment_ueberschreibung               :(segment_ueberschreibung_keine,
                                          segment_ueberschreibung_cs,
                                          segment_ueberschreibung_ds,
                                          segment_ueberschreibung_es,
                                          segment_ueberschreibung_ss);

  prefix                                :boolean;

  zaehler                               :word_norm;

  protect55                             :word_norm;
  cybershadow                           :word_norm;

  emulation_stoppen                     :boolean;

  in_datei_vorhanden_laenge             :longint;
  (*$IfDef dateigroessetyp_comp*)
  in_datei_vorhanden_laenge_comp        :dateigroessetyp;
  (*$EndIf*)

  (*$IfNDef VIDEO_BIOS*)
  textzeile                             :string;
  textzeile_zeile                       :byte;
  textzeile_spalte                      :byte;
  erste_textzeile                       :boolean;
  (*$EndIf VIDEO_BIOS*)

  org_ip_bei_int_21_30                  :word absolute tmp16;

  obc_00_zaehler                        :longint;

  (*$IfDef DOS_ODER_DPMI*)
  speicher_emulation                    :
    record
      feld                              :word;
      seg_,
      off_                              :word;
      aktiv                             :boolean;
    end;
  (*$EndIf DOS_ODER_DPMI*)

  max_schritte                          :longint;

  (*$IfNDef POEM_BIO*)
  tasten_vorhanden                      :word;
  (*$EndIf POEM_BIO*)
  zaehler_y_taste                       :word_norm;

  mte_gefunden                          :boolean;
  ruecksprung_gefunden                  :boolean;

  org_ss,org_sp                         :word;

  poem_modus_variable                   :poem_modus;

  w1,w2                                 :word_norm;
  l1                                    :longint;

  (*$IfDef POEM_BIO*)
  trap_flag_zu_beginn_der_anweisung     :boolean;
  (*$EndIf POEM_BIO*)

  (*$IfDef POEM_BIO*)
  dta_seg,dta_ofs                       :word;
  (*$EndIf POEM_BIO*)

  org_status_zeile                      :buntzeilen_typ;

  disk                                  :disk_typ;

  stunde,minute,sekunde,hundertstel     :word_norm;

  (*$IfDef ERWEITERTE_EMULATION*)
  programm_speicherlaenge               :word_norm;
  arbeits_seg                           :word_norm;
  (*$EndIf ERWEITERTE_EMULATION*)

  psp_segment                           :smallword; (*smallword($fff0+lade_segment);*)

  dosver_zaehler                        :longint;
  softice_zaehler                       :longint;

const
  statuszeilenanzeige_ab_schritt        =(*$IfNDef DEBUG*)   30000(*$Else*)       40(*$EndIf*);
  statuszeilenanzeige_wiederholung      =(*$IfNDef DEBUG*)$0000fff(*$Else*)$00000000(*$EndIf*);


  (*$IfDef ERWEITERTE_EMULATION*)
  lade_segment                          :smallword=$1000;
  umgebungs_segment                     :smallword=0; (* wird geÑndert *)
  (*$Else ERWEITERTE_EMULATION*)
  lade_segment                          :smallword=$0000;
  umgebungs_segment                     :smallword=$e000;
  (*$EndIf ERWEITERTE_EMULATION*)


  (* noch nicht Ñnderbar *)


  (*$IfDef DOS_ODER_DPMI*)
  speicher_bereichs_laenge=512; (* wie puffertyp.d *)
  (*$EndIf DOS_ODER_DPMI*)
  mb_grenze=1024*1024-1;

  max_schritte_normal=6000;
  (* RSCC 200..800 Schritte *)
  (* ALEC 108..200 Schritte *)
  (* TRAP 300..600 Schritte *)
  (* Uruguay 2500*? Schritte *)
  (* SLCD.SYS CD-Treiber 6000 Schritte *)

  register_tabelle_8:array[0..7] of byte_z=
    (byte_z(@register_16(_ax).l), (* AL *)
     byte_z(@register_16(_cx).l), (* CL *)
     byte_z(@register_16(_dx).l), (* DL *)
     byte_z(@register_16(_bx).l), (* BL *)
     byte_z(@register_16(_ax).h), (* AH *)
     byte_z(@register_16(_cx).h), (* CH *)
     byte_z(@register_16(_dx).h), (* DH *)
     byte_z(@register_16(_bx).h));(* BH *)

  register_tabelle_16:array[0..7] of word_z=
    (word_z(@_ax),
     word_z(@_cx),
     word_z(@_dx),
     word_z(@_bx),
     word_z(@_sp),
     word_z(@_bp),
     word_z(@_si),
     word_z(@_di));



  flags_carry                           =bit00;
  flags_parity                          =bit02;
  flags_zero                            =bit06;
  flags_sign                            =bit07;
  flags_trap                            =bit08;
  flags_direction                       =bit10;
  flags_overflow                        =bit11;
  flags_maske                           =flags_carry+flags_parity+flags_zero+flags_sign+flags_direction+flags_overflow;

  protect55_selbstmodifikation          =bit00;
  protect55_push_cs                     =bit01;
  protect55_pop_ds                      =bit02;
  protect55_pop_es                      =bit03;
  protect55_maske                       =bit00+bit01+bit02+bit03;


(*$IfDef POEM_ROM*)
poem_rom_lader:
(*$I POEM_SYS\POEM_ROM.PAS*)
(*$EndIf POEM_ROM*)


(*$IfDef POEM_SYS*)
poem_sys_lader:
(*$I POEM_SYS\POEM_SYS.PAS*)
(*$EndIf POEM_SYS*)

(*$IfDef POEM_BIO*)
poem_bios:
(*$I POEM_SYS\POEM_BIO.PAS*)
(*$EndIf POEM_BIO*)


procedure schritt_beschraenkung(const m:longint);
  begin
    if max_schritte>schritt+m then
      max_schritte:=schritt+m;
  end;

(*$IfDef VIDEO_BIOS*)(* oder POEM_BIOS *)
type
  textbildschirm=
    packed array[0..59] of
      packed array[0..79] of
        packed record
          case integer of
             1:(asc:char;
                attr:byte;);
             2:(zeichen_attr_paar:word;);
          end;

  speicher_modus3=
    packed record
      b1:packed array[0..255] of longint;
      b2a:packed array[$0400..$0419] of byte;
      tastatur_naechstes_zeichen_offs:word;     (* 1a *)
      tastatur_erster_freier_platz_offs:word;   (* 1c *)
      b2b:packed array[$041e..$0448] of byte;
      bildschirmmodus:byte;
      spalten:word;
      bildschirmspeichergroesse:word;
      bildschirmspeicheranfang:word;
      cursorpos:packed array[0..7] of
        packed record
          case integer of
            1:(spalte,zeile:byte);
            2:(sz:word);
        end;
      cursorgroesse:word;
      aktive_bildschirmseite:byte;
      crtc_port:word;
      b3:packed array[$0465..$047f] of byte;
      tastaturpuffer_anfang_offs:word;          (* 80 *)
      tastaturpuffer_endeplus1_offs:word;       (* 82 *)
      bildschrimzeilen_minus1:byte;
      zeichenhoehe:word;
      b4:packed array[$0487..$b7fff] of byte;
      bs:textbildschirm;
    end;
  speicher_modus3_z=^speicher_modus3;

procedure textbildschirm_zuruecksetzen(const loeschen:boolean);
  begin
    with speicher_modus3_z(poem_dos_speicher)^ do
      begin
        if loeschen then
          fuell_word(bs,SizeOf(bs) div 2,(ftab.f[farblos,hf]+ftab.f[farblos,vf])*$100+Ord(' '));
        bildschirmmodus:=3;
        spalten:=80;
        bildschirmspeichergroesse:=80*25*2;
        bildschirmspeicheranfang:=0;
        FillChar(cursorpos,SizeOf(cursorpos),0);
        cursorgroesse:=$0607;
        aktive_bildschirmseite:=0;
        crtc_port:=$3d4;
        bildschrimzeilen_minus1:=25-1;
        zeichenhoehe:=16;
      end;
  end;

function textbildschirm_auslesen:boolean;
  var
    z1,z2,z:word_norm;

    bz:buntzeilen_typ;

  function ist_leer(const zeile:byte):boolean;
    var
      z:word_norm;
    begin
      ist_leer:=true;
      for z:=1 to 80 do
        with speicher_modus3_z(poem_dos_speicher)^.bs[zeile-1,z-1] do
          if  (not (asc in [#0,#9,' ',#255]))
          and (attr<>$00)
           then
            begin
              ist_leer:=false;
              Exit;
            end;
    end;

  begin
    with speicher_modus3_z(poem_dos_speicher)^ do
      begin
        z1:= 1;
        z2:=60;
        while (z2>0) and ist_leer(z2) do
          Dec(z2);

        while (z1<=z2) and ist_leer(z1) do
          Inc(z1);

        textbildschirm_auslesen:=(z1<=z2);

        for z:=z1 to z2 do
          begin
            Move(bs[z-1],bz,SizeOf(bz));
            schreibe_zeile(bz);
          end;

        textbildschirm_zuruecksetzen(true);
      end;
  end;

var
  bildschirmkopie_vor_tastendruck:textbildschirm;


procedure erstelle_bildschirmkopie;
  begin
    Move(speicher_modus3_z(poem_dos_speicher)^.bs,
         bildschirmkopie_vor_tastendruck,
         SizeOf(bildschirmkopie_vor_tastendruck));
  end;

procedure textbildschirm_auslesen2;
  begin
    if not textbildschirm_auslesen then
      begin
        Move(bildschirmkopie_vor_tastendruck,
             speicher_modus3_z(poem_dos_speicher)^.bs,
             SizeOf(bildschirmkopie_vor_tastendruck));
        textbildschirm_auslesen;
      end;
    erstelle_bildschirmkopie;
  end;

(*$Else VIDEO_BIOS*)
procedure neue_textzeile;
  begin
    FillChar(textzeile,SizeOf(textzeile),' ');
    textzeile[0]:=#80;
    textzeile_spalte:=0;
  end;

procedure textausgabe_puffer_leeren(const auch_leerzeilen:boolean);
  begin
    textzeile:=leer_filter(textzeile);
    if (textzeile<>'') or auch_leerzeilen then
      begin
        ausschrift_x(leer_filter(textzeile),farblos,vorne);
        erste_textzeile:=false;
      end;
    neue_textzeile;
  end;
(*$EndIf VIDEO_BIOS*)


procedure emulationstoppen(const zk:string;const attr:aus_attribute);
  begin
    (*$IfDef VIDEO_BIOS*)
    textbildschirm_auslesen2;
    (*$Else VIDEO_BIOS*)
    textausgabe_puffer_leeren(false);
    (*$EndIf VIDEO_BIOS*)
    if zk<>'' then
      ausschrift(zk,attr);
    emulation_stoppen:=true;
  end;

procedure emulationstoppen_kein_hersteller(const zk:string;const attr:aus_attribute);
  (*$IfDef DOS*)
  (*$IfDef DEBUG*)
  var
    z:word;
  (*$EndIf DEBUG*)
  (*$EndIf DOS*)
  begin
    (*$IfDef DOS*)
    (*$IfDef DEBUG*)
    if zk=textz_speichermangel^ then
      begin
        for z:=1 to speicher_bereichs_tabelle_gefuellt do
          ausschrift('['+str_(z,2)+']='+hex_longint(speicher_bereichs_tabelle[z].
            wirklichkeitsbereich_anfang),signatur);
      end;
    (*$EndIf DEBUG*)
    (*$EndIf DOS*)

    (*$IfDef VIDEO_BIOS*)
    textbildschirm_auslesen2;
    (*$Else VIDEO_BIOS*)
    textausgabe_puffer_leeren(false);
    (*$EndIf VIDEO_BIOS*)

    Dec(herstellersuche);
    if zk<>'' then
      if (zk<>textz_speichermangel^) or (not emulation_stoppen) then
        ausschrift(zk,attr);
    emulation_stoppen:=true;
    Inc(herstellersuche);
  end;

(*$IfDef DOS*)
function versuche_in_den_schreibpuffer_zu_lesen(o:longint):boolean;
  var
    z                                   :word_norm;
    tmp_puffer                          :puffertyp;
    gleich                              :boolean;
    z2                                  :word;
  begin
    Dec(o,word(o) mod speicher_bereichs_laenge);
    for z:=Low(speicher_bereichs_tabelle) to speicher_bereichs_tabelle_gefuellt do
      if speicher_bereichs_tabelle[z].wirklichkeitsbereich_anfang=o then
        begin
          (* schon passiert *)
          versuche_in_den_schreibpuffer_zu_lesen:=true;
          exit;
        end;

    (* voll? -> Versuchen zu Lîschen *)
    if (speicher_bereichs_tabelle_gefuellt=High(speicher_bereichs_tabelle)) then
      begin
        for z:=Low(speicher_bereichs_tabelle) to speicher_bereichs_tabelle_gefuellt do
          begin

            if speicher_bereichs_tabelle[z].schon_veraendert then Continue;

            if  (speicher_bereichs_tabelle[z].wirklichkeitsbereich_anfang>=0)
            and (speicher_bereichs_tabelle[z].wirklichkeitsbereich_anfang<in_datei_vorhanden_laenge)
             then
              datei_lesen(
                tmp_puffer,
                org_code_imagestart+speicher_bereichs_tabelle[z].wirklichkeitsbereich_anfang,
                speicher_bereichs_laenge)
            else
              FillChar(tmp_puffer,SizeOf(tmp_puffer),0);

            gleich:=true;
            for z2:=Low(tmp_puffer.d) to High(tmp_puffer.d) do
              gleich:=gleich and
                (tmp_puffer.d[z2]=speicher_bereichs_tabelle[z].speicherzeiger^[z2]);

            if  (speicher_bereichs_tabelle[z].wirklichkeitsbereich_anfang>=$fffa0000)
            and (speicher_bereichs_tabelle[z].wirklichkeitsbereich_anfang<     -$200)
             then
              gleich:=true;

            if gleich then
              begin
                (*$IfDef DEBUG*)
                ausschrift('entfernen von '+hex_longint(speicher_bereichs_tabelle[z].wirklichkeitsbereich_anfang),normal);
                (*$EndIf DEBUG*)

                for z2:=z to speicher_bereichs_tabelle_gefuellt-1 do
                  begin
                    Move(speicher_bereichs_tabelle[z2+1].speicherzeiger^,
                         speicher_bereichs_tabelle[z2  ].speicherzeiger^,
                         speicher_bereichs_laenge);
                    speicher_bereichs_tabelle[z2  ].wirklichkeitsbereich_anfang:=
                    speicher_bereichs_tabelle[z2+1].wirklichkeitsbereich_anfang;
                    speicher_bereichs_tabelle[z2  ].schon_veraendert:=
                    speicher_bereichs_tabelle[z2+1].schon_veraendert;
                  end;

                Dec(speicher_bereichs_tabelle_gefuellt);
                Break; (* for z .. *)
              end
            else
              speicher_bereichs_tabelle[z].schon_veraendert:=true;
          end;


      end;

    (* geht nicht *)
    if (speicher_bereichs_tabelle_gefuellt=High(speicher_bereichs_tabelle)) then
      begin
        versuche_in_den_schreibpuffer_zu_lesen:=false;

        (* msdos 7 command.com kopiert 64 und springt dann dahin *)
        emulationstoppen_kein_hersteller(textz_speichermangel^,signatur);
        exit;
      end;

    if  (poem_modus_variable=poem_modus_sys)
    and (o=$fffa0000)
     then
      begin
        Inc(speicher_bereichs_tabelle_gefuellt);
        with speicher_bereichs_tabelle[speicher_bereichs_tabelle_gefuellt] do
          begin
            wirklichkeitsbereich_anfang:=o;
            schon_veraendert:=true;
            FillChar(speicherzeiger^,speicher_bereichs_laenge,0);
            Move(poem_sys_lader,speicherzeiger^,SizeOf(poem_sys_lader));
          end;
        versuche_in_den_schreibpuffer_zu_lesen:=true;
        Exit;
      end;

    if  (poem_modus_variable=poem_modus_rom)
    and (o=$fffa0000)
     then
      begin
        Inc(speicher_bereichs_tabelle_gefuellt);
        with speicher_bereichs_tabelle[speicher_bereichs_tabelle_gefuellt] do
          begin
            wirklichkeitsbereich_anfang:=o;
            schon_veraendert:=true;
            FillChar(speicherzeiger^,speicher_bereichs_laenge,0);
            Move(poem_rom_lader,speicherzeiger^,SizeOf(poem_rom_lader));
          end;
        versuche_in_den_schreibpuffer_zu_lesen:=true;
        Exit;
      end;

    (* virtuell *)
    if (o<0)
    or (o>=in_datei_vorhanden_laenge)
     then
      begin
        Inc(speicher_bereichs_tabelle_gefuellt);
        with speicher_bereichs_tabelle[speicher_bereichs_tabelle_gefuellt] do
          begin
            wirklichkeitsbereich_anfang:=o;
            schon_veraendert:=true;
            FillChar(speicherzeiger^,speicher_bereichs_laenge,0);
            if o=-$200 then (* Spezialfall PSP *)
              begin
                speicherzeiger^[$100]:=$cd;
                speicherzeiger^[$101]:=$20;
                speicherzeiger^[$102]:=$ff;
                speicherzeiger^[$103]:=$9f;
                speicherzeiger^[$106]:=$f0;
                speicherzeiger^[$107]:=$ef;
                (* Umgebung $8000:$0000 *)
                word_z(@speicherzeiger^[$12c])^:=umgebungs_segment;
                (* speicherzeiger^[$180]:=0 *)
                speicherzeiger^[$181]:=13; (* Ende der Komandozeile *)
              end
            else if (o=integer(umgebungs_segment) shl 4) then (* Spezialfall Umgebung *)
              begin
                exezk:='COMSPEC=C:\DOS\COMMAND.COM'#0#0#1#0+dateiname+#0;
                Move(exezk[1],speicherzeiger^[0],Length(exezk));
              end;

          end;
        versuche_in_den_schreibpuffer_zu_lesen:=true;
        Exit;
      end;


    (* laden und merken *)
    Inc(speicher_bereichs_tabelle_gefuellt);
    datei_lesen(tmp_puffer,org_code_imagestart+o,speicher_bereichs_laenge);
    with speicher_bereichs_tabelle[speicher_bereichs_tabelle_gefuellt] do
      begin
        Move(
          tmp_puffer.d,
          speicherzeiger^,
          speicher_bereichs_laenge);
        wirklichkeitsbereich_anfang:=o;
        schon_veraendert:=false;
      end;
    versuche_in_den_schreibpuffer_zu_lesen:=true;
  end;
(*$EndIf DOS*)

(*$IfDef DOS*)
procedure lies_emu(var p:puffertyp;const wieviel:word_norm;const seg_,off_:word_norm);
  var
    o,o0                                :longint;
    o1                                  :word_norm;
    z                                   :word_norm;
    w                                   :word_norm;
    wieviel_jetzt                       :word_norm;
    tmp_puffer                          :puffertyp;

  label
    weitersuchen;

  begin
    o:=longint(integer(seg_))*16+off_;

    w:=0;
    p.g:=0;

weitersuchen:
    while w<wieviel do
      begin
        (* Seitenstart *)
        o1:=word(o) mod speicher_bereichs_laenge;
        o0:=o-o1;
        (* hîchstens 512 *)
        wieviel_jetzt:=speicher_bereichs_laenge-o1;
        (* aber nicht mehr als gefordert *)
        if wieviel_jetzt>wieviel-w then
          wieviel_jetzt:=wieviel-w;

        for z:=Low(speicher_bereichs_tabelle) to speicher_bereichs_tabelle_gefuellt do
          with speicher_bereichs_tabelle[z] do
            if wirklichkeitsbereich_anfang=o0 then
              begin
                (* soviel kopieren *)
                Move(speicherzeiger^[o1],p.d[w],wieviel_jetzt);
                (* weiterrechnen *)
                Inc(o,wieviel_jetzt);
                Inc(w,wieviel_jetzt);
                Inc(p.g,wieviel_jetzt);
                goto weitersuchen
              end;

        (* noch nicht im Schreibpuffer *)
        if versuche_in_den_schreibpuffer_zu_lesen(o) then
          continue;

        (* nicht innerhalb der Dateigrenzen *)
        if (o>=in_datei_vorhanden_laenge)
        or (o<0)
         then
          begin
            p.g:=0;
            exit;
          end;

        (* vom Lesepuffer holen *)
        if w=0 then
          begin
            datei_lesen(p,org_code_imagestart+o,wieviel_jetzt);
            w:=p.g;
            Inc(o,p.g);
          end
        else
          begin
            datei_lesen(tmp_puffer,org_code_imagestart+o,wieviel_jetzt);
            Move(tmp_puffer.d,p.d[w],tmp_puffer.g);
            Inc(p.g,tmp_puffer.g);
            Inc(w,p.g);
            Inc(o,p.g);
          end;

      end; (* WHILE *)
  end;
(*$EndIf DOS*)

(*$IfDef DPMI*)
procedure lies_emu(var p:puffertyp;const wieviel:word_norm;const seg_,off_:word_norm);
  var
    l:longint;
    f0,r0:word_norm;
    w,jetzt:word_norm;
  begin
    l:=longint(seg_) shl 4+off_;
    f0:=l shr 15;
    r0:=l and $7fff;
    p.g:=0;
    w:=wieviel;

    while w>0 do
      begin
        jetzt:=w;
        if jetzt>SizeOf(speicherseite)-r0 then
          jetzt:=SizeOf(speicherseite)-r0;

        Move(speicher_bereichs_tabelle[f0]^[r0],p.d[p.g],jetzt);
        Inc(p.g,jetzt);
        Dec(w,jetzt);
        r0:=0;
        Inc(f0);
        if f0>High(speicher_bereichs_tabelle) then
          f0:=0;
      end;
  end;
(*$EndIf DPMI*)

(*$IfDef VirtualPascal*)
procedure lies_emu(var p:puffertyp;const wieviel:word_norm;const seg_,off_:word_norm);
  begin
    Move(poem_dos_speicher^[(longint(seg_)*16+off_) and mb_grenze],p.d,wieviel);
    p.g:=wieviel;
  end;
(*$EndIf VirtualPascal*)


procedure lies_emu_puffer(const wieviel:word_norm);
  begin
    (*$IfDef DOS_ODER_DPMI*)
    lies_emu(emu_puffer,wieviel,_cs,_ip);
    (*$EndIf DOS_ODER_DPMI*)
    (*$IfDef VirtualPascal*)
    Move(poem_dos_speicher^[(longint(_cs)*16+_ip) and mb_grenze],emu_puffer.d,wieviel);
    emu_puffer.g:=wieviel;
    (*$EndIf VirtualPascal*)
  end;

function emu_zu_zk_e(const segm,off:word;const e:char):string;
  var
    p:puffertyp;
  begin
    lies_emu(p,255,segm,off);
    emu_zu_zk_e:=puffer_zu_zk_e(p.d[0],e,255);
  end;

function emu_zu_zk_l(const segm,off:word;const l:byte):string;
  var
    p:puffertyp;
  begin
    lies_emu(p,l,segm,off);
    emu_zu_zk_l:=puffer_zu_zk_l(p.d[0],l);
  end;

(*$IfDef DOS*)
function lade_byte(const segm,off:word):byte;
  var
    z1                                  :word_norm;
    o,o0                                :longint;
    o1                                  :word_norm;
    tmp_puffer                          :puffertyp;
  label
    nochmal;

  begin
    if ((segm=$0040) and (off =$006c))
    or ((segm=$0040) and (off =$006e))
     then
      begin
        lade_byte:=byte(schritt);
        exit;
      end;

    o:=longint(integer(segm))*16+off;
    o1:=word(o) mod speicher_bereichs_laenge;
    o0:=o-o1;

  nochmal:
    for z1:=Low(speicher_bereichs_tabelle) to speicher_bereichs_tabelle_gefuellt do
      if speicher_bereichs_tabelle[z1].wirklichkeitsbereich_anfang=o0 then
        begin
          lade_byte:=speicher_bereichs_tabelle[z1].speicherzeiger^[o1];
          exit;
        end;

    if versuche_in_den_schreibpuffer_zu_lesen(o0) then
      goto nochmal;

    (* au·erhalb der Dateigrenzen? *)
    if (o>=in_datei_vorhanden_laenge)
    or (o<0)
     then
      begin
        (* raten *)
        lade_byte:=0;
      end
    else
      begin
        datei_lesen(tmp_puffer,org_code_imagestart+o,1);
        lade_byte:=tmp_puffer.d[0];
      end;
  end;
(*$EndIf DOS*)

(*$IfDef DPMI*)
function lade_byte(const segm,off:word):byte;
  var
    l:longint;
  begin
    if ((segm=$0040) and (off =$006c))
    or ((segm=$0040) and (off =$006e))
     then
      begin
        lade_byte:=byte(schritt);
        exit;
      end;

    l:=longint(segm) shl 4+off;
    lade_byte:=speicher_bereichs_tabelle[l shr 15]^[l and $7fff];
  end;
(*$EndIf DPMI*)

(* inline macht zu viele Probleme (C:\NWDOS\DPMS.EXE) *)
(*$IfDef VirtualPascal*)
function lade_byte(const segm,off:word):byte;{inline;}
  begin
    (* JauMing Tseng COM Unpacker *)
    if ((segm=$0040) and (off =$006c))
    or ((segm=$0040) and (off =$006e))
     then
      begin
        lade_byte:=byte(schritt);
        exit;
      end;
    lade_byte:=poem_dos_speicher^[(longint(segm)*16+off) and mb_grenze];
  end;
(*$EndIf VirtualPascal*)

(*$IfDef DOS*)
function lade_word(const segm,off:word):word;
  var
    z1                                  :word_norm;
    o,o0                                :longint;
    o1                                  :word_norm;
    tmp_puffer                          :puffertyp;
  label
    nochmal;

  begin
    (* einige CD-Treiber mit EXE-Abteil brauchen sonst zu lange *)
    if (segm=$0040) and (off =$006c) then
      begin
        lade_word:=word(schritt {shr 4});
        exit;
      end;
    if (segm=$0040) and (off =$006e) then
      begin
        lade_word:=word(schritt shr (16{+4}));
        exit;
      end;

    o:=longint(integer(segm))*16+off;
    o1:=word(o) mod speicher_bereichs_laenge;
    o0:=o-o1;

    if o1=speicher_bereichs_laenge-1 then (* 512. Byte schon auf der nÑchsten Seite *)
      begin
        (* sicher Åber Seitengrenzen ... *)
        lade_word:=word(lade_byte(segm,off  ))
                  +word(lade_byte(segm,off+1)) shl 8;
        exit;
      end;

  nochmal:
    for z1:=Low(speicher_bereichs_tabelle) to speicher_bereichs_tabelle_gefuellt do
      if speicher_bereichs_tabelle[z1].wirklichkeitsbereich_anfang=o0 then
        begin
          lade_word:=word_z(@speicher_bereichs_tabelle[z1].speicherzeiger^[o1])^;
          exit;
        end;

    if versuche_in_den_schreibpuffer_zu_lesen(o0) then
      goto nochmal;

    (* au·erhalb der Dateigrenzen? *)
    if (o>=in_datei_vorhanden_laenge)
    or (o<0)
     then
      begin
        (* raten *)
        lade_word:=0; (* eigentlich auch Byte/Byte probieren *)
      end
    else
      begin
        datei_lesen(tmp_puffer,org_code_imagestart+o,2);
        lade_word:=word_z(@tmp_puffer.d[0])^;
      end;
  end;
(*$EndIf DOS*)

(*$IfDef DPMI*)
function lade_word(const segm,off:word):word;
  var
    l:longint;
  begin
    l:=longint(segm) shl 4+off;
    if (l and $7fff)=$7fff then
      lade_word:=lade_byte(segm,off)+lade_byte(segm,(off+1) and $ffff) shl 8
    else
      lade_word:=word_z(@speicher_bereichs_tabelle[l shr 15]^[l and $7fff])^;
  end;
(*$EndIf DPMI*)

(*$IfDef VirtualPascal*)
function lade_word(const segm,off:word):word;{ inline; }
  begin
    (* einige CD-Treiber mit EXE-Abteil brauchen sonst zu lange *)
    if (segm=$0040) and (off =$006c) then
      begin
        lade_word:=word(schritt{ shr 4});
        exit;
      end;
    if (segm=$0040) and (off =$006e) then
      begin
        lade_word:=word(schritt shr (16{+4}));
        exit;
      end;
    lade_word:=word_z(@poem_dos_speicher^[(longint(segm)*16+off) and mb_grenze])^;
  end;
(*$EndIf VirtualPascal*)

(*$IfDef DOS*)
function liefere_adresse_8(const segm,off:word):byte_z;
  var
    z1                                  :word_norm;
    o,o0                                :longint;
    o1                                  :word_norm;

  label
    nochmal;

  begin
    o:=longint(integer(segm))*16+off;
    o1:=word(o) mod speicher_bereichs_laenge;
    o0:=o-o1;

  nochmal:
    for z1:=Low(speicher_bereichs_tabelle) to speicher_bereichs_tabelle_gefuellt do
      if speicher_bereichs_tabelle[z1].wirklichkeitsbereich_anfang=o0 then
        begin
          liefere_adresse_8:=byte_z(@speicher_bereichs_tabelle[z1].speicherzeiger^[o1]);
          exit;
        end;

    if versuche_in_den_schreibpuffer_zu_lesen(o0) then
      goto nochmal;

    (* wird nicht gemerkt *)
    with speicher_emulation do
      begin
        liefere_adresse_8:=byte_z(@feld);
        feld:=lade_byte(segm,off);
      end;
  end;
(*$EndIf DOS*)

(*$IfDef DPMI*)
function liefere_adresse_8(const segm,off:word):byte_z;
  var
    l:longint;
  begin
    l:=longint(segm) shl 4+off;
    liefere_adresse_8:=byte_z(@speicher_bereichs_tabelle[l shr 15]^[l and $7fff]);
  end;
(*$EndIf DPMI*)

(*$IfDef VirtualPascal*)
function liefere_adresse_8(const segm,off:word):byte_z;{inline;}
  begin
    liefere_adresse_8:=byte_z(@poem_dos_speicher^[(longint(segm)*16+off) and mb_grenze]);
  end;
(*$EndIf VirtualPascal*)

(*$IfDef DOS*)
function liefere_adresse_16(const segm,off:word):word_z;
  var
    z:pointer;
    w:word_norm;
    o,o0                                :longint;
    z1                                  :word_norm;
    o1                                  :word_norm;
  begin
    o:=longint(integer(segm))*16+off;
    o1:=word(o) mod speicher_bereichs_laenge;
    o0:=o-o1;

    (* Åberlappung? *)
    if o1=speicher_bereichs_laenge-1 then (* 512. Byte schon auf der nÑchsten Seite *)
      with speicher_emulation do
        begin
          liefere_adresse_16:=word_z(@feld);
          seg_:=segm;
          off_:=off;
          feld:=lade_word(segm,off);
          aktiv:=true;
          exit;
        end;

    if versuche_in_den_schreibpuffer_zu_lesen(o) then
      begin
        for z1:=Low(speicher_bereichs_tabelle) to speicher_bereichs_tabelle_gefuellt do
          if speicher_bereichs_tabelle[z1].wirklichkeitsbereich_anfang=o0 then
            begin
              liefere_adresse_16:=word_z(@speicher_bereichs_tabelle[z1].speicherzeiger^[o1]);
              exit;
            end;
      end
    else
      (* wird nicht gemerkt *)
      with speicher_emulation do
        begin
          liefere_adresse_16:=word_z(@feld);
          feld:=lade_word(segm,off);
        end;
  end;
(*$EndIf DOS*)

(*$IfDef DPMI*)
function liefere_adresse_16(const segm,off:word):word_z;
  var
    l:longint;
  begin
    l:=longint(segm) shl 4+off;
    if (l and $7fff)=$7fff then
      with speicher_emulation do
        begin
          feld:=lade_word(segm,off);
          seg_:=segm;
          off_:=off;
          aktiv:=true;
          liefere_adresse_16:=word_z(@feld);
        end
    else
      liefere_adresse_16:=word_z(@speicher_bereichs_tabelle[l shr 15]^[l and $7fff]);
  end;
(*$EndIf DPMI*)

(*$IfDef VirtualPascal*)
function liefere_adresse_16(const segm,off:word):word_z;{inline;}
  begin
    liefere_adresse_16:=word_z(@poem_dos_speicher^[(longint(segm)*16+off) and mb_grenze]);
  end;
(*$EndIf VirtualPascal*)

procedure schreibe_speicher_8(const segm,off:word;const wert:byte);
  begin
    liefere_adresse_8(segm,off)^:=wert;
  end;
(*$IfDef DOS_ODER_DPMI*)
procedure schreibe_speicher_16(const segm,off:word;const wert:word);
  begin
    liefere_adresse_16(segm,off)^:=wert;
    if speicher_emulation.aktiv then
      with speicher_emulation do
        begin
          aktiv:=false;
          liefere_adresse_8(seg_,off_  )^:=lo(feld);
          liefere_adresse_8(seg_,off_+1)^:=hi(feld);
        end;
  end;
(*$EndIf DOS_ODER_DPMI*)

(*$IfDef VirtualPascal*)
procedure schreibe_speicher_16(const segm,off:word;const wert:word);
  begin
    word_z(@poem_dos_speicher^[(longint(segm)*16+off) and mb_grenze])^:=wert;
  end;
(*$EndIf VirtualPascal*)

procedure schreibe_speicher(const segm,off:word;const zk:string);
  var
    z:word_norm;
  begin
    for z:=1 to Length(zk) do
      schreibe_speicher_8(segm,off+z-1,Ord(zk[z]));
  end;


function ds_oder_ueberschreibung:word;
  begin
    case segment_ueberschreibung of
      segment_ueberschreibung_cs:
        ds_oder_ueberschreibung:=_cs;
      segment_ueberschreibung_keine,
      segment_ueberschreibung_ds:
        ds_oder_ueberschreibung:=_ds;
      segment_ueberschreibung_es:
        ds_oder_ueberschreibung:=_es;
      segment_ueberschreibung_ss:
        ds_oder_ueberschreibung:=_ss;
    end;
  end;


function zusatzlaenge_opcode:word_norm;
  (* 16-Bit "memory address"! *)
  (*
     OPCODES.LST:

     POSTBYTE

     MM RRR MMM
     MM OOO MMM
     memory addressing mode
        register operand address (RRR)
        select operation in this extension fiel (OOO)
            memory operand address

    RRR= 8 Bit: AL,CL,DL,BL,AH,CH,DH,BH
        16 Bit: AX,CX,DX,BX,SP,BP,SI,DI
        32 Bit: ..
    (fÅr LÑngenberechnung unwichtig)
                                                      *)
  begin
    case (* "MM" *) postbyte1_shr_6 of
      0:
        (* "MMM": [BX+SI],[BX+DI],[BP+SI],[BP+DI],[SI],[DI],[o16],[BX] *)
        if (postbyte1_and_7)=6 then
          zusatzlaenge_opcode:=2 (* [o16] *)
        else
          zusatzlaenge_opcode:=0;
      1:
        (* "MMM": [BX+SI+o8],[BX+DI+o8],[BP+SI+o8],[BP+DI+o8],[SI+o8],[DI+o8],[BP+o8],[BX+o8] *)
        zusatzlaenge_opcode:=1; (* [...+o8] *)
      2:
        (* "MMM": [BX+SI+o16],[BX+DI+o16],[BP+SI+o16],[BP+DI+o16],[SI+o16],[DI+o16],[BP+o16],[BX+o16] *)
        zusatzlaenge_opcode:=2; (* [...+o16] *)
      3:
        (* "MMM" wie RRR *)
        zusatzlaenge_opcode:=0;
    end;
  end;

function bestimme_quell_ofs:word_norm;
  var
    off16:word     absolute postword2;
    off8 :shortint absolute postbyte2;
  begin
    case postbyte1_shr_6 of
      0:
        case postbyte1_and_7 of
          0:bestimme_quell_ofs:=word(_bx+_si);
          1:bestimme_quell_ofs:=word(_bx+_di);
          2:bestimme_quell_ofs:=word(_bp+_si);
          3:bestimme_quell_ofs:=word(_bp+_di);
          4:bestimme_quell_ofs:=word(_si    );
          5:bestimme_quell_ofs:=word(_di    );
          6:bestimme_quell_ofs:=word(off16  );
          7:bestimme_quell_ofs:=word(_bx    );
        end;
      1:
        begin
        case postbyte1_and_7 of
          0:bestimme_quell_ofs:=word(_bx+_si+word(integer(off8)));
          1:bestimme_quell_ofs:=word(_bx+_di+word(integer(off8)));
          2:bestimme_quell_ofs:=word(_bp+_si+word(integer(off8)));
          3:bestimme_quell_ofs:=word(_bp+_di+word(integer(off8)));
          4:bestimme_quell_ofs:=word(_si    +word(integer(off8)));
          5:bestimme_quell_ofs:=word(_di    +word(integer(off8)));
          6:bestimme_quell_ofs:=word(_bp    +word(integer(off8)));
          7:bestimme_quell_ofs:=word(_bx    +word(integer(off8)));
        end;
        end;
      2:
        case postbyte1_and_7 of
          0:bestimme_quell_ofs:=word(_bx+_si+off16);
          1:bestimme_quell_ofs:=word(_bx+_di+off16);
          2:bestimme_quell_ofs:=word(_bp+_si+off16);
          3:bestimme_quell_ofs:=word(_bp+_di+off16);
          4:bestimme_quell_ofs:=word(_si    +off16);
          5:bestimme_quell_ofs:=word(_di    +off16);
          6:bestimme_quell_ofs:=word(_bp    +off16);
          7:bestimme_quell_ofs:=word(_bx    +off16);
        end;
      3:
        bestimme_quell_ofs:=register_tabelle_16[postbyte1_and_7]^;
    end;
  end;

function bestimme_segment:word_norm;
  begin
    case segment_ueberschreibung of
      segment_ueberschreibung_keine:
        case postbyte1_and_7 of
          0,1,4,5,7:
            bestimme_segment:=_ds;
          2,3:
            bestimme_segment:=_ss;
          6:
            if postbyte1_shr_6=0 then
              bestimme_segment:=_ds
            else
              bestimme_segment:=_ss;
        end;
      segment_ueberschreibung_cs:
        bestimme_segment:=_cs;
      segment_ueberschreibung_ds:
        bestimme_segment:=_ds;
      segment_ueberschreibung_es:
        bestimme_segment:=_es;
      segment_ueberschreibung_ss:
        bestimme_segment:=_ss;
    end;
  end;

function berechne_speicher_8:byte_z;
  begin
    case postbyte1_shr_6 of
      0,1,2:
        berechne_speicher_8:=liefere_adresse_8(bestimme_segment,bestimme_quell_ofs);
      3:
        berechne_speicher_8:=register_tabelle_8[postbyte1_and_7];
    end;
  end;

function berechne_speicher_16:word_z;
  begin
    case postbyte1_shr_6 of
      0,1,2:
        berechne_speicher_16:=liefere_adresse_16(bestimme_segment,bestimme_quell_ofs);
      3:
        berechne_speicher_16:=register_tabelle_16[postbyte1_and_7];
    end;
  end;

function berechne_speicher_8_inhalt:byte;
  begin
    case postbyte1_shr_6 of
      0,1,2:
        berechne_speicher_8_inhalt:=lade_byte(bestimme_segment,bestimme_quell_ofs);
      3:
        berechne_speicher_8_inhalt:=register_tabelle_8[postbyte1_and_7]^;
    end;
  end;

function berechne_speicher_16_inhalt:word;
  begin
    case postbyte1_shr_6 of
      0,1,2:
        begin
          berechne_speicher_16_inhalt:=lade_word(bestimme_segment,bestimme_quell_ofs);
        end;
      3:
        begin
          berechne_speicher_16_inhalt:=register_tabelle_16[postbyte1_and_7]^;
        end;
    end;
  end;

var
  r32:register_32;

function berechne_speicher_32_inhalt:boolean;
  var
    segment_,offset_:word;
  begin
    case postbyte1_shr_6 of
      0,1,2:
        begin
          segment_:=bestimme_segment;
          offset_ :=bestimme_quell_ofs;
          r32.w0:=lade_word(segment_,     offset_   );
          r32.w1:=lade_word(segment_,word(offset_+2));
          berechne_speicher_32_inhalt:=true;
        end;
      3: (* ungÅltig *)
        berechne_speicher_32_inhalt:=false;
    end;
  end;


function richtungsflag_wert:word;
  begin
    if (_flags and flags_direction)=0 then
      richtungsflag_wert:=1
    else
      richtungsflag_wert:=$ffff; (* -1 *)
  end;

(*$IfOpt S+*)
  (*$Define S_PLUS*)
  (*$S-*)
(*$EndIf*)

procedure setze_zu_emulierende_flags;assembler;
  (*&FRAME-*)(*&Uses None*)
  asm
    (*$IfDef VirtualPascal*)
    pushfd
    pop eax
    and eax,($ffffffff-flags_maske)
    movzx ecx,[_flags]
    and ecx,flags_maske
    or eax,ecx
    push eax
    popfd
    (*$Else VirtualPascal*)
    pushf
    pop ax
    and ax,($ffff-flags_maske)
    mov cx,[_flags]
    and cx,flags_maske
    or ax,cx
    push ax
    popf
    (*$EndIf VirtualPascal*)
  end;

procedure sichere_zu_emulierende_flags;assembler;
  (*&FRAME-*)(*&Uses None*)
  asm
    (*$IfDef VirtualPascal*)
    pushfd
    pop eax
    and eax,flags_maske
    and [_flags],($ffff-flags_maske)
    or  [_flags],ax
    cld
    (*$Else VirtualPascal*)
    pushf
    pop ax
    and ax,flags_maske
    and [_flags],($ffff-flags_maske)
    or  [_flags],ax
    cld
    (*$EndIf VirtualPascal*)
  end;

(*$IfDef S_PLUS*)
  (*$S+*)
  (*$UnDef S_PLUS*)
(*$EndIf*)

procedure add_16(var o1:word;const o2:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cx,[o2]
      add [eax],cx
      (*$Else VirtualPascal*)
      les di,o1
      mov cx,[o2]
      seges add [di],cx
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure add_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      add [eax],cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges add [di],cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure sub_16(var o1:word;const o2:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cx,[o2]
      sub [eax],cx
      (*$Else VirtualPascal*)
      les di,o1
      mov cx,[o2]
      seges sub [di],cx
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure sub_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      sub [eax],cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges sub [di],cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure or_16(var o1:word;const o2:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cx,[o2]
      or [eax],cx
      (*$Else VirtualPascal*)
      les di,o1
      mov cx,[o2]
      seges or [di],cx
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure or_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      or [eax],cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges or [di],cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure adc_16(var o1:word;const o2:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cx,[o2]
      adc [eax],cx
      (*$Else VirtualPascal*)
      les di,o1
      mov cx,[o2]
      seges adc [di],cx
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure adc_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      adc [eax],cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges adc [di],cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure sbb_16(var o1:word;const o2:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cx,[o2]
      sbb [eax],cx
      (*$Else VirtualPascal*)
      les di,o1
      mov cx,[o2]
      seges sbb [di],cx
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure sbb_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      sbb [eax],cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges sbb [di],cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure and_16(var o1:word;const o2:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cx,[o2]
      and [eax],cx
      (*$Else VirtualPascal*)
      les di,o1
      mov cx,[o2]
      seges and [di],cx
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure and_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      and [eax],cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges and [di],cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure cmp_16(const o1:word;const o2:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov  ax,[o1]
      mov  cx,[o2]
      cmp ax,cx
      (*$Else VirtualPascal*)
      mov ax,[o1]
      mov cx,[o2]
      cmp ax,cx
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure cmp_8(const o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov  al,[o1]
      mov  cl,[o2]
      cmp al,cl
      (*$Else VirtualPascal*)
      mov al,[o1]
      mov cl,[o2]
      cmp al,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure xor_16(var o1:word;const o2:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cx,[o2]
      xor [eax],cx
      (*$Else VirtualPascal*)
      les di,o1
      mov cx,[o2]
      seges xor [di],cx
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure xor_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      xor [eax],cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges xor [di],cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure rol_16(var o1:word;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      rol [eax].smallword,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges rol [di].word,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure rol_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      rol [eax].byte,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges rol [di].byte,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure ror_16(var o1:word;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      ror [eax].smallword,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges ror [di].word,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure ror_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      ror [eax].byte,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges ror [di].byte,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure rcl_16(var o1:word;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      rcl [eax].smallword,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges rcl [di].word,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure rcl_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      rcl [eax].byte,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges rcl [di].byte,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure rcr_16(var o1:word;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      rcr [eax].smallword,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges rcr [di].word,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure rcr_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      rcr [eax].byte,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges rcr [di].byte,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure shl_16(var o1:word;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      shl [eax].smallword,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges shl [di].word,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure shl_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      shl [eax].byte,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges shl [di].byte,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure shr_16(var o1:word;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      shr [eax].smallword,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges shr [di].word,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure shr_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      shr [eax].byte,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges shr [di].byte,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure sar_16(var o1:word;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      sar [eax].smallword,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges sar [di].word,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure sar_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      sar [eax].byte,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges sar [di].byte,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure sal_16(var o1:word;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      sal [eax].smallword,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges sal [di].word,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure sal_8(var o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      mov  cl,[o2]
      sal [eax].byte,cl
      (*$Else VirtualPascal*)
      les di,o1
      mov cl,[o2]
      seges sal [di].byte,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure test_8(const o1:byte;const o2:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov  al,[o1]
      mov  cl,[o2]
      test al,cl
      (*$Else VirtualPascal*)
      mov al,[o1]
      mov cl,[o2]
      test al,cl
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;


procedure test_16(const o1:word;const o2:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov  ax,[o1]
      mov  cx,[o2]
      test ax,cx
      (*$Else VirtualPascal*)
      mov ax,[o1]
      mov cx,[o2]
      test ax,cx
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure not_16(var o1:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      not [eax].smallword
      (*$Else VirtualPascal*)
      les di,o1
      seges not [di].word
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure not_8(var o1:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      not [eax].byte
      (*$Else VirtualPascal*)
      les di,o1
      seges not [di].byte
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure neg_16(var o1:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      neg [eax].smallword
      (*$Else VirtualPascal*)
      les di,o1
      seges neg [di].word
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure neg_8(var o1:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      neg [eax].byte
      (*$Else VirtualPascal*)
      les di,o1
      seges neg [di].byte
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure xchg_8(var o1:byte;var o2:byte);
  var
    temp:byte;
  begin
    temp:=o1;
    o1  :=o2;
    o2  :=temp;
  end;

procedure xchg_16(var o1:word;var o2:word);
  var
    temp:word;
  begin
    temp:=o1;
    o1  :=o2;
    o2  :=temp;
  end;

procedure mul_16(const o1:word);
  begin
    asm
      call setze_zu_emulierende_flags
      mov  ax,[_ax]
      mov  cx,[o1]
      mul cx (* AX*CX->DX_AX *)
      mov [_ax],ax
      mov [_dx],dx
      call sichere_zu_emulierende_flags
    end;
  end;

procedure mul_8(const o1:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      mov  al,[_ax].byte
      mov  ah,[o1]
      mul ah (* AL*AH->AX *)
      mov [_ax],ax
      call sichere_zu_emulierende_flags
    end;
  end;

procedure imul_16(const o1:word);
  begin
    asm
      call setze_zu_emulierende_flags
      mov  ax,[_ax]
      imul [o1] (* DX_AX:=AX*o1 *)
      mov [_ax],ax
      mov [_dx],dx
      call sichere_zu_emulierende_flags
    end;
  end;

function imul_16im(const o1,o2:word):integer;
  begin
    asm
      call setze_zu_emulierende_flags
    end;
    imul_16im:=smallint(longint(integer(o1))*longint(integer(o2)));
    asm
      call sichere_zu_emulierende_flags
    end;
  end;

procedure imul_8(const o1:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      mov  ax,[_ax]
      imul [o1] (* AX:=AL*o1 *)
      mov [_ax],ax
      call sichere_zu_emulierende_flags
    end;
  end;

function  div_16(const o1:word):boolean;
  var
    l1:longint;
  begin {asm variante implementieren}

    if (o1=0) then
      begin
        (*emulationstoppen('',signatur)*)
        div_16:=false;
      end
    else
      begin
        l1:=_ax+_dx shl 16;
        (* nicht ganz korrekt - aber sicher *)
        _ax:=word(l1 div o1);
        _dx:=word(l1 mod o1);
        div_16:=true;
      end;
  end;

function  div_8(const o1:byte):boolean;
  var
    w1:word;
  begin {asm variante implementieren}
    if o1=0 then
      begin
        (* emulationstoppen('',signatur);*)
        div_8:=false;
      end
    else
      begin
        w1:=_ax;
        _ax:=word(w1 div o1 + (w1 mod o1) shl 8);
        div_8:=true;
      end;
  end;

function  idiv_16(const o1:word):boolean;
  var
    o1i:integer absolute o1;
  begin
    if (o1i=0) or (((longint(_dx*$10000+_ax) div o1i) and $ffff0000)<>0) then
      idiv_16:=false
    else
      begin
        asm
          call setze_zu_emulierende_flags
          mov  ax,[_ax]
          mov  dx,[_dx]
          idiv [o1] (* AX:=DX_AX/o1 *) (* die Hilfe ist hier falsch (Quotient nicht in al sondern ax) *)
          mov  [_ax],ax
          mov  [_dx],dx
          call sichere_zu_emulierende_flags
        end;
        idiv_16:=true;
      end;
  end;

function  idiv_8(const o1:byte):boolean;
  var
    o1i:shortint;
  begin
    if (o1i=0) or (((integer(_ax) div o1i) and $ff00)<>0) then
      idiv_8:=false
    else
      begin
        asm
          call setze_zu_emulierende_flags
          mov  ax,[_ax]
          idiv [o1]
          mov  [_ax],ax
          call sichere_zu_emulierende_flags
        end;
        idiv_8:=true;
      end;

  end;

procedure inc_16(var o1:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      inc [eax].smallword
      (*$Else VirtualPascal*)
      les di,o1
      seges inc [di].word
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure inc_8(var o1:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      inc [eax].byte
      (*$Else VirtualPascal*)
      les di,o1
      seges inc [di].byte
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure dec_16(var o1:word);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      dec [eax].smallword
      (*$Else VirtualPascal*)
      les di,o1
      seges dec [di].word
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;

procedure dec_8(var o1:byte);
  begin
    asm
      call setze_zu_emulierende_flags
      (*$IfDef VirtualPascal*)
      mov eax,o1
      dec [eax].byte
      (*$Else VirtualPascal*)
      les di,o1
      seges dec [di].byte
      (*$EndIf VirtualPascal*)
      call sichere_zu_emulierende_flags
    end;
  end;


procedure push_(const w:word);
  begin
    Dec(_sp,2);
    liefere_adresse_16(_ss,_sp)^:=w;
  end;

procedure push32_(const w:word);
  begin
    push_(0);
    push_(w);
  end;

procedure pop_(var w:word);
  begin
    Inc(_sp,2);
    w:=lade_word(_ss,word(_sp-2));
  end;

(*$IfDef VIDEO_BIOS*)
procedure textausgabe_xyza(const x,y:word_norm;const z:char;const a:byte);
  begin
    if (x<0) or (y<0) or (x>=80) or (y>=60) then exit;

    with speicher_modus3_z(poem_dos_speicher)^.bs[y,x] do
      begin
        asc:=z;
        attr:=a;
      end;
  end;

procedure textausgabe_char(const z:char);
  begin
    with speicher_modus3_z(poem_dos_speicher)^ do
      begin
        case z of
          #07:;
          #08:
            if cursorpos[0].spalte>0 then Dec(cursorpos[0].spalte);
          #09:
            begin
              textausgabe_char(' ');
              while (cursorpos[0].spalte and $7)<>(1-1) do
                textausgabe_char(' ');
            end;
          #10:
            Inc(cursorpos[0].zeile);
          #13:
            cursorpos[0].spalte:=0;
        else
          bs[cursorpos[0].zeile,cursorpos[0].spalte].asc:=z;
          Inc(cursorpos[0].spalte);
        end;

        if cursorpos[0].spalte=80 then
          begin
            cursorpos[0].spalte:=0;
            Inc(cursorpos[0].zeile);
          end;

        if cursorpos[0].zeile=60 then
          begin
            Move(bs[1,0],bs[0,0],(60-1)*2*80);
            fuell_word(bs[59],SizeOf(bs[59]) div 2,(ftab.f[farblos,hf]+ftab.f[farblos,vf])*$100+Ord(' '));
            cursorpos[0].zeile:=59;
          end;
      end;
  end;

(*$Else VIDEO_BIOS*)
procedure textausgabe_char(const z:char);forward;

procedure textausgabe_xyza(const x,y:word_norm;const z:char;const a:byte);
  begin
    if (x<0) or (y<0) or (x>=80) or (y>=60) then exit;

    if y<>textzeile_zeile then
      begin
        textausgabe_char(#13);
        textausgabe_char(#10);
      end;

    textzeile[x+1]:=z;
  end;

procedure textausgabe_char(const z:char);
  var
    a:word_norm;
  begin
    if textzeile_spalte=80 then
      textausgabe_puffer_leeren(not erste_textzeile);

    case z of
      #07:; (* Gong *)
      #08: (* RÅcklîschen *)
        begin
          if textzeile_spalte<>0 then
            Dec(textzeile_spalte);
        end;
      #09: (* Tab zu 8 Leerzeichen ausweiten *)
       begin
         repeat
           textausgabe_char(' ');
         until (textzeile_spalte and 7)=(1-1);
       end;
      #10:
        textausgabe_puffer_leeren(not erste_textzeile);
      #13:;
    else
      textzeile[textzeile_spalte+1]:=z;
      Inc(textzeile_spalte);
    end;

    if textzeile_spalte=80 then
      begin
        textausgabe_puffer_leeren(not erste_textzeile);
        textzeile_spalte:=0;
        Inc(textzeile_zeile);
      end;

    if textzeile_zeile=60 then
      textzeile_zeile:=0;
  end;
(*$EndIf VIDEO_BIOS*)

procedure textausgabe_ende(seg_,off_:word;const ende:char);
  var
    z:char;
    zaehler:word_norm;
  begin
    zaehler:=0;
    repeat
      z:=Chr(lade_byte(seg_,off_));
      Inc(off_);
      if z=ende then break;
      textausgabe_char(z);
      Inc(zaehler);
    until zaehler>80*25;
  end;

procedure textausgabe_laenge(seg_,off_:word;const laenge:word_norm);
  var
    z:char;
    zaehler:word_norm;
  begin
    for zaehler:=1 to laenge do
      begin
        z:=Chr(lade_byte(seg_,off_));
        Inc(off_);
        textausgabe_char(z);
      end;
  end;

(****************************************************************************)

  procedure int_behandlung(const i:byte);
    label
      nochmal_dosversion_verarbeitung;
    var
      tmp_puffer        :puffertyp;
      x,y,z             :word_norm;
      ip_stack,cs_stack :word;
      (*$IfDef POEM_BIO*)
      rueckkehr         :(r_weiter,r_iret,r_retf);
      (*$EndIf POEM_BIO*)

    procedure lies_tmp_puffer_stack;
      const
        wieviel         =100;
      begin
        (*$IfDef DOS_ODER_DPMI*)
        lies_emu(tmp_puffer,wieviel,cs_stack,ip_stack);
        (*$EndIf DOS_ODER_DPMI*)
        (*$IfDef VirtualPascal*)
        Move(poem_dos_speicher^[(longint(cs_stack)*16+ip_stack) and mb_grenze],tmp_puffer.d,wieviel);
        tmp_puffer.g:=wieviel;
        (*$EndIf VirtualPascal*)
      end;

    procedure flags_auf_stack_aendern(const und,oder:integer);
      var
        st_ip,
        st_cs,
        st_fl           :word;
      begin
        pop_(st_ip);
        pop_(st_cs);
        pop_(st_fl);
        st_fl:=(st_fl and und) or oder;
        push_(st_fl);
        push_(st_cs);
        push_(st_ip);
        _flags:=(_flags and und) or oder;
      end;

    (*$IfDef VIDEO_BIOS*)
    procedure bildschirm_schieben(x1,y1,x2,y2,zeilen:word_norm;const loesch_attribut:byte;const nach_unten:boolean);
      var
        y,zl:word_norm;
      begin
        if x1>79 then x1:=79;
        if y1>24 then y1:=24;
        if x2>79 then x2:=79;
        if y2>24 then y2:=24;

        if (x1>x2) or (y1>y2) then exit;

        if (zeilen=0) or (zeilen>(y2-y1+1)) then zeilen:=y2-y1+1;

        zl:=(x2-x1+1)*2;

        with speicher_modus3_z(poem_dos_speicher)^ do
          if nach_unten then
            for y:=y2 downto y1 do
              if y-zeilen>y1 then
                Move(bs[y-zeilen,x1],bs[y,x1],zl)
              else
                Fuell_Word(bs[y,x1],zl div 2,loesch_attribut*$100+Ord(' '))
          else
            for y:=y1 to y2 do
              if y+zeilen<=y2 then
                Move(bs[y+zeilen,x1],bs[y,x1],zl)
              else
                Fuell_Word(bs[y,x1],zl div 2,loesch_attribut*$100+Ord(' '));

      end;
    (*$EndIf VIDEO_BIOS*)

    (*$IfNDef POEM_BIO*)
    function hole_dos_taste(var b:byte):boolean;
      begin
        hole_dos_taste:=true;
        if tasten_vorhanden<>0 then
          begin
            b:=Lo(tasten_vorhanden);
            tasten_vorhanden:=0;
          end
        else
          if zaehler_y_taste=0 then
            begin
              b:=Ord('y');
              Inc(zaehler_y_taste);
            end
          else
            hole_dos_taste:=false;
      end;
    (*$EndIf POEM_BIO*)

    (*$IfDef ERWEITERTE_EMULATION*)

    var
      versuche          :word_norm;
      groesster_block   :smallword;
      a2,l2             :smallword;
      s2                :char;

    label
      nochmal_214a;

    function suche_mcb(const seg_:smallword):boolean;
      begin
        versuche:=0;
        arbeits_seg:=smallword(umgebungs_segment-1);
        repeat
          Inc(versuche);
          with mcb_z(liefere_adresse_8(arbeits_seg,0))^ do
            begin
              (* Fehler in der Speicherkette? *)
              if ((sig<>'M') and (sig<>'Z'))
              or (arbeits_seg>=$a000)
              or (versuche=1000)
               then
                begin
                  _ax:=7; (* MCB zerstîrt *)
                  flags_auf_stack_aendern(0,flags_carry);
                  suche_mcb:=false;
                  Exit;
                end;

              if arbeits_seg=seg_ then (* gefunden *)
                begin
                  flags_auf_stack_aendern(not flags_carry,0);
                  suche_mcb:=true;
                  Exit;
                end;

              if sig='Z' then (* nicht gefunden *)
                begin
                  _ax:=9; (* MCB ungÅltig *)
                  flags_auf_stack_aendern(0,flags_carry);
                  suche_mcb:=false;
                  Exit;
                end;

              Inc(arbeits_seg,1+anzahl_para);
            end;
        until false;
      end;

    procedure speicher_aufraeumen;
      var
        a2:smallword;
      begin
        versuche:=0;
        arbeits_seg:=smallword(umgebungs_segment-1);
        while (versuche<1000) and (mcb_z(liefere_adresse_8(arbeits_seg,0))^.sig='M') do
          begin
            Inc(versuche);
            a2:=word(arbeits_seg+1+mcb_z(liefere_adresse_8(arbeits_seg,0))^.anzahl_para);
            if  (mcb_z(liefere_adresse_8(arbeits_seg,0))^.eigentuemer=0)
            and (mcb_z(liefere_adresse_8(a2         ,0))^.eigentuemer=0)
            and (mcb_z(liefere_adresse_8(a2         ,0))^.sig in ['M','Z'])
             then
              with mcb_z(liefere_adresse_8(arbeits_seg,0))^ do
                begin
                  sig:=mcb_z(liefere_adresse_8(a2,0))^.sig;
                  Inc(anzahl_para,1+mcb_z(liefere_adresse_8(a2,0))^.anzahl_para);
                  FillChar(leer,SizeOf(leer),0);
                  FillChar(prgname,SizeOf(prgname),0);
                end
            else
              arbeits_seg:=a2;
          end;

      end;
    (*$EndIf ERWEITERTE_EMULATION*)


    begin
      if  (register_16(_ax).h=$fa) (* al=01/02 *)
      and (_dx=$5945) (* 'YE' *)
      and (i in [$13,$16,$21])
       then
        case register_16(_ax).l of
          0:ausschrift('VSAFE,TSAFE,VWATCH / Carmel Install Test',signatur);
          1:ausschrift('VSAFE,TSAFE,VWATCH / Carmel Deinstallation',virus);
          2:ausschrift('VSAFE,TSAFE,VWATCH / Carmel GET/SET Options',virus);
        end;

      (*$IfDef POEM_BIO*)
      rueckkehr:=r_iret;
      (*$EndIf POEM_BIO*)

      case i of
        $00:
          emulationstoppen('',signatur); (* /0 *)
        $05:
          emulationstoppen('',signatur); (* BOUND *)
        $06:
          emulationstoppen('',signatur); (* invalid opcode *)
        $10:
          begin
            case register_16(_ax).h of
              (*$IfDef VIDEO_BIOS*)
              $00:
                if (register_16(_ax).l and $7f)=$03 then
                  textbildschirm_zuruecksetzen((register_16(_ax).l and $80)=0);
              (*$EndIf VIDEO_BIOS*)

              (*$IfDef VIDEO_BIOS*)
              $01: (* Cursorgrî·e Ñndern *)
                speicher_modus3_z(poem_dos_speicher)^.cursorgroesse:=_cx;
              (*$EndIf VIDEO_BIOS*)

              $02: (* Cursorposition Ñndern *)
                begin
                  (*$IfDef VIDEO_BIOS*)
                  speicher_modus3_z(poem_dos_speicher)^.cursorpos[0].sz:=_dx;
                  (*$Else VIDEO_BIOS*)
                  if register_16(_dx).h<>textzeile_zeile then (* Zeilenumbruch z.B. FBINST (BAT2EXEC) *)
                    begin
                      textausgabe_char(#13);
                      textausgabe_char(#10);
                    end;
                  textzeile_zeile :=register_16(_dx).h;
                  textzeile_spalte:=register_16(_dx).l
                  (*$EndIf VIDEO_BIOS*)
                end;
              $03: (* Cursorgrî·e und Position ermitteln *)
                begin
                  (*$IfDef VIDEO_BIOS*)
                  _cx:=speicher_modus3_z(poem_dos_speicher)^.cursorgroesse;
                  _dx:=speicher_modus3_z(poem_dos_speicher)^.cursorpos[0].sz;
                  (*$Else VIDEO_BIOS*)
                  register_16(_dx).l:=textzeile_spalte;
                  register_16(_dx).h:=textzeile_zeile
                  (* der Rest wird nicht emuliert *)
                  (*$EndIf VIDEO_BIOS*)
                end;
              (* Lichtstift (alles unverÑndert)
              $04:*)

              (* Bildschirmseite festlegen (alles unverÑndert)
              $05:*)

              (*$IfDef VIDEO_BIOS*)
              $06:
                begin
                  (* C:\v\disk2\*.com: *)
                  if (_cx=0) and (register_16(_dx).l=79) and (register_16(_dx).h=24) then
                    erstelle_bildschirmkopie;

                  bildschirm_schieben(register_16(_cx).l,register_16(_cx).h,
                                      register_16(_dx).l,register_16(_dx).h,
                                      register_16(_ax).l,
                                      register_16(_bx).h,
                                      false);
                end;
              $07:
                bildschirm_schieben(register_16(_cx).l,register_16(_cx).h,
                                    register_16(_dx).l,register_16(_dx).h,
                                    register_16(_ax).l,
                                    register_16(_bx).h,
                                    true);
              $08: (* Zeiche+Attr ermitteln *)
                begin
                  with speicher_modus3_z(poem_dos_speicher)^ do
                  _ax:=bs[cursorpos[0].zeile,cursorpos[0].spalte].zeichen_attr_paar;
                end;
              (*$EndIf VIDEO_BIOS*)

              $09: (* mit FARBE aber keine énderung der Spalte * UNCC.COM *)
                begin
                  (*$IfDef VIDEO_BIOS*)
                  x:=speicher_modus3_z(poem_dos_speicher)^.cursorpos[0].spalte;
                  y:=speicher_modus3_z(poem_dos_speicher)^.cursorpos[0].zeile;
                  for z:=1 to _cx do
                    begin
                      textausgabe_xyza(x,y,Chr(register_16(_ax).l),register_16(_bx).l);
                      Inc(x);
                      if x=80 then
                        begin
                          Inc(y);
                          x:=0;
                        end;
                    end;
                  (*$Else VIDEO_BIOS*)
                  x:=textzeile_spalte;
                  y:=textzeile_zeile ;
                  for z:=1 to _cx do
                    begin
                      textausgabe_xyza(x,y,Chr(register_16(_ax).l),register_16(_bx).l);
                      Inc(x);
                      if x=80 then
                        begin
                          Inc(y);
                          x:=0;
                        end;
                    end;
                  (*$EndIf VIDEO_BIOS*)
                end;

              $0e: (* BIOS 1 Zeichen ausgeben * COM2EXE: ADY *)
                textausgabe_char(Chr(register_16(_ax).l));

              $0f:
                begin
                  _ax:=80*$100+3; (* 80 Spalten, Modus 3 *)
                  register_16(_bx).l:=0; (* Seite 0 *)
                end;
            (*$IfNDef ENDVERSION*)
            else
              asm nop end;
            (*$EndIf ENDVERSION*)
            end;
          end;

        $12:
          begin
            _ax:=lade_word($0040,$0013);
          end;

        $13: (* INT $13 *)
          begin (* DROPPER ... (FILLER.COM) *)
            if register_16(_ax).h=$03 then
              ausschrift('INT $13 / AH=03 !!',virus);
            flags_auf_stack_aendern(not flags_carry,0);
          end;

        $15: (* INT $15 *)
          begin
            register_16(_ax).h:=$86; (* "unbekannte Funktion" *)
            flags_auf_stack_aendern(0,flags_carry);
          end;

        $40: (* INT $13->$40 *)
          begin
            if register_16(_ax).h=$03 then
              ausschrift('INT $40 / AH=03 !!',virus);
            flags_auf_stack_aendern(not flags_carry,0);
          end;

        $16: (* FOOLTEU.EXE: INT $16 *)
          begin
            (*$IfDef POEM_BIO*)
            with speicher_modus3_z(poem_dos_speicher)^ do
              case register_16(_ax).h of
                $00,
                $10:
                  begin
                    if tastatur_naechstes_zeichen_offs<>tastatur_erster_freier_platz_offs then
                      begin (* Taste vorhanden *)
                        _ax:=lade_word($0040,tastatur_naechstes_zeichen_offs);
                        Inc(tastatur_naechstes_zeichen_offs,2);
                        if tastatur_naechstes_zeichen_offs=tastaturpuffer_endeplus1_offs then
                          tastatur_naechstes_zeichen_offs:=tastaturpuffer_anfang_offs;
                        Inc(tastatur_erster_freier_platz_offs,2);
                        if tastatur_erster_freier_platz_offs=tastaturpuffer_endeplus1_offs then
                          tastatur_erster_freier_platz_offs:=tastaturpuffer_anfang_offs;
                      end
                    else
                      begin
                        if zaehler_y_taste=0 then (* fÅr INT 21/01 *)
                          begin
                            _ax:=$2c00+Ord('y');
                            Inc(zaehler_y_taste);
                          end
                        else
                          emulationstoppen('',signatur); (* Tastatureingabe *)

                      end;
                  end;
                $01,
                $11:
                  begin
                    if tastatur_naechstes_zeichen_offs<>tastatur_erster_freier_platz_offs then
                      begin
                        _ax:=lade_word($0040,tastatur_naechstes_zeichen_offs);
                        flags_auf_stack_aendern(not flags_zero,0);
                      end
                    else
                      begin
                        (* keine Taste vorhanden *)
                        flags_auf_stack_aendern(0,flags_zero);
                        (* deutet nicht auf polymorphen Code hin -> schneller beenden *)
                        (* z.B.: CRKPROU.EXE aus PROTEL98.ZIP *)
                        schritt_beschraenkung(400);
                      end;
                  end;
                $05:
                  begin
                    if (tastatur_erster_freier_platz_offs+2=tastatur_naechstes_zeichen_offs)
                    or (    (tastatur_erster_freier_platz_offs+2=tastaturpuffer_endeplus1_offs)
                        and (tastatur_naechstes_zeichen_offs=tastaturpuffer_anfang_offs))
                     then
                      register_16(_ax).l:=1 (* Fehler *)
                    else
                      begin
                        register_16(_ax).l:=0;
                        schreibe_speicher_16($0040,tastatur_erster_freier_platz_offs,_cx);
                        Inc(tastatur_erster_freier_platz_offs,2);
                        if tastatur_erster_freier_platz_offs=tastaturpuffer_endeplus1_offs then
                          tastatur_erster_freier_platz_offs:=tastaturpuffer_anfang_offs;
                      end;
                  end;
              end;

            (*$Else POEM_BIO*)

            case register_16(_ax).h of
              $00,
              $10:
                begin
                  if tasten_vorhanden<>0 then
                    begin
                      _ax:=tasten_vorhanden;
                      tasten_vorhanden:=0;
                    end
                  else
                    emulationstoppen('',signatur); (* Tastatureingabe *)
                end;
              $01,
              $11:
                begin
                  if tasten_vorhanden<>0 then
                    begin
                      _ax:=tasten_vorhanden;
                      flags_auf_stack_aendern(not flags_zero,0);
                    end
                  else
                    begin
                      (* keine Taste vorhanden *)
                      flags_auf_stack_aendern(0,flags_zero);
                      (* deutet nicht auf polymorphen Code hin -> schneller beenden *)
                      (* z.B.: CRKPROU.EXE aus PROTEL98.ZIP *)
                      schritt_beschraenkung(400);
                    end;
                end;
              $05:
                begin
                  register_16(_ax).l:=0;
                  tasten_vorhanden:=_cx;
                end;
            end;
            (*$EndIf POEM_BIO*)

            unbekannt1_zaehler:=unbekannt1_zaehler or bit01;
            if (unbekannt1_zaehler and (bit00+bit01+bit02+bit03+bit04+bit05))=(bit00+bit01+bit02+bit03+bit04+bit05) then
              begin
                (*emulationstoppen(textz_exe__unbekannte_Verschluesselung^+'<FOOLTEU/G†bor Keve>',packer_exe);*)
                emulationstoppen('$pirit / Night $pirit [1.5, UPD 2.1]',packer_exe);
              end;

          end;


        $19:
          begin
            (*$IfDef POEM_BIO*)
            rueckkehr:=r_weiter; (* $ffff:0000 *)
            (*$Else POEM_BIO*)
            emulationstoppen('',signatur); (* Neustart *)
            (*$EndIf POEM_BIO*)
          end;

        $20: (* INT $20 *)
          begin
            (*$IfDef POEM_BIO*)
            rueckkehr:=r_weiter;
            (*$Else POEM_BIO*)
            emulationstoppen('',signatur); (* Programmende *)
            (*$EndIf POEM_BIO*)
          end;

        (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)
        $21: (* INT $21 *)
          begin
            (* Sonderfunktion $0c?? *)
            if (register_16(_ax).h=$0c) and (register_16(_ax).l in [1,6,7,8,$a]) then
              begin
                (* "Tastaturpuffer lîschen" ignorieren *)
                register_16(_ax).h:=register_16(_ax).l;
              end;

            case register_16(_ax).h of

              $00,
              $4c: (* Programmende *)
                emulationstoppen('',signatur);

              $01: (* VIRUS DROPPER Y/N *)
                begin
                  ip_stack:=lade_word(_ss,_sp  );
                  cs_stack:=lade_word(_ss,_sp+2);
                  lies_tmp_puffer_stack;

                  (* TYP(EIN)2 DOS-Kopf - ich hÑtte eine Tastatureingabe
                    ohne Bildschirmausgabe nehmen sollen *)
                  if bytesuche(tmp_puffer.d[0],#$b8'?'#$4c#$cd#$21) then
                    begin
                      emulationstoppen('',signatur);
                      register_16(_ax).l:=Ord('o');
                    end
                  else
                    begin
                      (*$IfDef POEM_BIO*)
                      rueckkehr:=r_weiter;
                      (*$Else POEM_BIO*)
                      if hole_dos_taste(register_16(_ax).l) then
                         textausgabe_char(Chr(register_16(_ax).l))
                      else
                         emulationstoppen('',signatur); (* warten auf Tastatureingabe *)
                      (*$EndIf POEM_BIO*)
                    end;

                end;

              $02:
                begin
                  (*$IfDef POEM_BIO*)
                  rueckkehr:=r_weiter;
                  (*$Else POEM_BIO*)
                  textausgabe_char(Chr(register_16(_dx).l));
                  (*$EndIf POEM_BIO*)
                end;

              $06:
                begin
                  (*$IfDef POEM_BIO*)
                  rueckkehr:=r_weiter;
                  (*$Else POEM_BIO*)
                  if register_16(_dx).l<>$ff then
                    textausgabe_char(Chr(register_16(_dx).l))
                  else
                    if hole_dos_taste(register_16(_ax).l) then
                      flags_auf_stack_aendern(not flags_zero,0)
                    else
                      flags_auf_stack_aendern(0,flags_zero);
                  (*$EndIf POEM_BIO*)
                end;

              $07,
              $08:
                begin
                  (*$IfDef POEM_BIO*)
                  rueckkehr:=r_weiter;
                  (*$Else POEM_BIO*)
                  if not hole_dos_taste(register_16(_ax).l) then
                    emulationstoppen('',signatur); (* Tastatureingabe *)
                  (*$EndIf POEM_BIO*)
                end;

              $09:
                begin
                  (*$IfDef POEM_BIO*)
                  rueckkehr:=r_weiter;
                  (*$Else POEM_BIO*)
                  textausgabe_ende(_ds,_dx,'$');
                  (*$EndIf POEM_BIO*)
                end;

              $0a: (* Zeichenketteneingabe *) (* Endlosaufruf XD.COM *)
                begin
                  emulationstoppen_kein_hersteller('',signatur);
                end;

           (* $0b: tastatur: zeichen verfÅgbar? !!!!!!!*)

           (* $0c:    Tastaturpuffer lîschen und andere Unterfunktion aufrufen
                      pc dos 1.10 command.com *)

           (* $0d: disk reset *)

              $0e: (* select disk *)
                begin
                  if register_16(_dx).l<3 then (* A: B: C: *)
                    disk:=disk_typ(register_16(_dx).l);
                  register_16(_ax).l:=3; (* A: B: C: *)
                end;

              $0f..$17: (* FCB Funktionen *)
                begin
                  exezk:=emu_zu_zk_l(_ds,_dx,1+8+3);
                  Inc(exezk[1],Ord('@'));
                  Insert(':',exezk,2);
                  Insert('.',exezk,1+1+8+1);
                  ausschrift('FCB !! "'+exezk+'"',signatur);

                  register_16(_ax).l:=$ff; (* Fehler *)
                end;

              $19: (* get default drive *)
                begin
                  register_16(_ax).l:=Ord(disk); (* A: -> 0 ..  *)
                end;

              $1a: (* SET DTA *)
                begin (* vor FINDFISRT benutzt *)
                  (*$IfDef POEM_BIO*)
                  dta_seg:=_ds;
                  dta_ofs:=_dx;
                  (*$EndIf POEM_BIO*)
                end;

              $25: (* INT setzen *)
                begin
                  if register_16(_ax).l in [$1b, (* ^C      *)
                                            $24, (* Fehler  *)
                                            $38] (* x87-EMU *)
                   then
                    (* emulation_stoppen:=true; wÑre schlecht weil einige Viren INT $24 abfangen *)
                    (*schritt_beschraenkung(400); BeschrÑnkung ist aber in der 386-Variante Unsinn
                       (z.B. OS-BS / Thomas WolfRAM *);

                  if register_16(_ax).l in [$21]
                   then
                    begin
                      Dec(herstellersuche);
                      ausschrift('ISR '+textz_fuer^+' INT $21',signatur);
                      Inc(herstellersuche);
                    end;
                  (*$IfDef POEM_BIO*)
                  schreibe_speicher_16($0000,word_norm(register_16(_ax).l)*4  ,_dx);
                  schreibe_speicher_16($0000,word_norm(register_16(_ax).l)*4+2,_ds);
                  (*$EndIf POEM_BIO*)
                end;

              $2a: (* GET DATE *)
                begin
                  ausschrift('GetDate !!',signatur);
                  (* 1999.05.11 *)
                  _cx:=1999;                    (* Jahr      *)
                  _dx:=5*$100+11;               (* Monat/Tag *)
                  register_16(_ax).l:=2;        (* Dienstag  *)
                end;

              $2c: (* GET TIME *)
                begin
                  (* wird von jmt com unpacker benutzt *)
                  GetTime(stunde,minute,sekunde,hundertstel);
                  register_16(_cx).h:=stunde;
                  register_16(_cx).l:=minute;
                  register_16(_dx).h:=sekunde;
                  register_16(_dx).l:=hundertstel;
                end;

              $2f: (* GET DTA *)
                begin
                  (*$IfDef POEM_BIO*)
                  _es:=dta_seg;
                  _bx:=dta_ofs;
                  (*$EndIf POEM_BIO*)
                end;

              $30: (* INT 21/30 DOS VERSION *********************************)
                begin
                  ip_stack:=lade_word(_ss,_sp  );
                  cs_stack:=lade_word(_ss,_sp+2);
                  lies_tmp_puffer_stack;

                  _ax:=$0002;
                  _bx:=$0000;
                  _cx:=$0000;

                  (* Hackstop hat mehr als genug davon ... *)
                  if puffer_pos_suche(tmp_puffer,#$50#$b8#$eb#$04#$58,100)<>nicht_gefunden then
                    begin
                      _ax:=$0006; (* DOS 6 *)
                      exit;
                    end;

                  org_ip_bei_int_21_30:=_ip;
                  exezk:='';

nochmal_dosversion_verarbeitung:

                  lies_tmp_puffer_stack;

                  case tmp_puffer.d[0] of
                    $3c: (* 3c 03: CMP AL,003 *) (* NWDOS\UNSTACK.COM *)
                      begin
                        exezk:=str0(tmp_puffer.d[1])+'.xx';
                        Inc(ip_stack,2);
                      end;

                    $3d: (* 3d xx yy: CMP AX,YYXX *)
                      begin
                        exezk:=str0(tmp_puffer.d[1])+'.'+str0(tmp_puffer.d[2]);
                        Inc(ip_stack,3);
                      end;

                    $a3: (* A3 2e 00: MOV [$002e],AX *) (* AFD.EXE *)
                      begin
                        Inc(ip_stack,3);
                        lies_tmp_puffer_stack;
                        goto nochmal_dosversion_verarbeitung;
                      end;
                  else
                    (* NOERA (QED) *)
                    (* 86 e0:         xchg ah,al      *)
                    (* 3d xx yy:      cmp ax,..       *)
                    if bytesuche(tmp_puffer.d[0],#$86#$e0#$3d)
                    (* DOSKEY (OS/2 4.0) *)
                    (* 86 c4:         xchg al,ah      *)
                    (* 3d xx yy:      cmp ax,..       *)
                    or bytesuche(tmp_puffer.d[0],#$86#$c4#$3d)
                     then
                      begin
                        exezk:=str0(tmp_puffer.d[4])+'.'+str0(tmp_puffer.d[3]);
                        Inc(ip_stack,2+3);
                      end;
                  end;

                  lies_tmp_puffer_stack;

                  case tmp_puffer.d[0] of
                    $73: (* 73 XX: JNC+XX *)
                      begin
                        insert('>= ',exezk,1);
                        Inc(ip_stack,2); (* in Fehlermeldungszweig *)
                      end;
                    $72: (* 72 xx: JC+XX *)
                      begin
                        insert('< ',exezk,1);
                        Inc(ip_stack,2+shortint(tmp_puffer.d[1])); (* in Fehlermeldungszweig *)
                      end;
                    $74, (* 74 xx: JE/JZ+XX *)
                    $75: (* 75 xx: JNE/JNZ+XX *) (* OS/2 4.0 GRAFTABL.COM *)
                      begin
                        insert('= ',exezk,1);
                        Inc(ip_stack,2); (* in Fehlermeldungszweig *)
                      end;
                    $7f: (* 7F XX: JG+XX *) (* PCDOS 6.1 CHOICE.COM *)
                      begin
                        insert('> ',exezk,1);
                        Inc(ip_stack,2);
                      end;
                  end;
                  (* if exezk<>'' then*)
                  if dosver_zaehler<10 then (* rPCP_Rel01.zip\rc386\rc386_061\4.COM tausende.. *)
                    ausschrift(textz_Abfrage_der_DOS_Version^+' '+exezk,signatur);
                  Inc(dosver_zaehler);

                  (****_ip:=org_ip_bei_int_21_30;*)
                  (* _ax:=$0002;  "DOS 2.0" - Fehlermeldung provozieren *)
                end; (*******************************************************)

              $31: (* TSR *)
                begin
                  emulationstoppen('TSR ('+str0(longint(_dx)*16)+' Byte)',signatur);
                end;

              $35: (* GETINTVEC *)
                begin
                  (*$IfDef POEM_BIO*)
                  _bx:=lade_word($0000,word_norm(register_16(_ax).l)*4  );
                  _es:=lade_word($0000,word_norm(register_16(_ax).l)*4+2);
                  (*$Else POEM_BIO*)
                  _es:=8000;
                  _bx:=0000;
                  (*$EndIf POEM_BIO*)
                end;

              $3c:  (* create file *)
                begin
                  exezk:=emu_zu_zk_e(_ds,_dx,#0);
                  ausschrift(textz_poem__create_file^+exezk+'"',signatur);
                end;

              $3d:  (* open file *)
                begin
                  exezk:=emu_zu_zk_e(_ds,_dx,#0);
                  if exezk<>'' then
                    begin
                      ausschrift(textz_poem_datei_oeffnen^+exezk+'"',signatur);
                      flags_auf_stack_aendern(0,flags_carry);
                      _ax:=5;
                      exit;
                    end
                  else
                    begin
                      register_16(_ax).h:=0; (* Annahme 0/1/2... -> 0=stdin/1=stdout/2=stderr *)
                      flags_auf_stack_aendern(not flags_carry,0);
                    end;
                end;

           (* $3e: Datei schlie·en *)

              $3f: (* Datei lesen  *)
                begin
                  if _bx=0 then
                    (* Annhahme: keine Taste.. *)
                    (* z.B. wie ARROW SOFT ASM.EXE (MOONROCK) *)
                    emulationstoppen('',signatur);

                  flags_auf_stack_aendern(0,flags_carry);
                  _ax:=6;
                  exit;
                end;

              $40: (* in Datei (con) schreiben *)
                begin
                  (* bx nicht auf null testen: einige Viren schreiben blind ohne Fehlertest
                     in *.com -der text enthÑlt oft Meldungen *)
                  (* z.B.: BRENDER 3dfx_win.bdd *)
                  textausgabe_laenge(_ds,_dx,_cx);
                  _ax:=_cx;
                  flags_auf_stack_aendern(not flags_carry,0);
                end;

              $47:
                begin
                  exezk:=emu_zu_zk_e(_ds,_si,#0); (* z.B. jmt com unpacker *)
                  w1:=register_16(_dx).l;
                  ausschrift('ChDir "'+Chr(w1+Ord('@'))+':\'+exezk+'"',signatur);
                  if w1=0 then w1:=Ord(disk)+1;
                  if (w1 in [1..3]) and (exezk='') then (* A..C und nur im Hauptverzeichnis *)
                    begin
                      flags_auf_stack_aendern(not flags_carry,0);
                      _ax:=$0100;
                    end
                  else
                    begin
                      flags_auf_stack_aendern(0,flags_carry);
                      _ax:=$000f;
                    end;

                end;

              $48:  (* Speicheranforderung *)
                begin
                  (*$IfDef ERWEITERTE_EMULATION*)
                  arbeits_seg:=smallword(umgebungs_segment-1);
                  groesster_block:=0;
                  versuche:=0;
                  repeat
                    Inc(versuche);
                    with mcb_z(liefere_adresse_8(arbeits_seg,0))^ do
                      begin
                        (* Fehler in der Speicherkette? *)
                        if ((sig<>'M') and (sig<>'Z'))
                        or (arbeits_seg>=$a000)
                        or (versuche=1000)
                         then
                          begin
                            _ax:=7; (* MCB zerstîrt *)
                            _bx:=groesster_block;
                            flags_auf_stack_aendern(0,flags_carry);
                            Break;
                          end;

                        if eigentuemer=0 then
                          begin
                            groesster_block:=max(groesster_block,anzahl_para);
                            if anzahl_para=_bx then      (* pa·t genau *)
                              begin
                                eigentuemer:=psp_segment;
                                anzahl_para:=_bx;
                                FillChar(leer,SizeOf(leer),0);
                                prgname:='PROGNAME';
                                _ax:=arbeits_seg+1;
                                flags_auf_stack_aendern(not flags_carry,0);
                                Break;
                              end
                            else if anzahl_para>_bx then (* zuviel frei *)
                              begin
                                a2:=arbeits_seg+1+_bx;
                                l2:=anzahl_para-1-_bx;
                                s2:=sig;
                                with mcb_z(liefere_adresse_8(a2,0))^ do
                                  begin
                                    sig:=s2;
                                    eigentuemer:=0;
                                    anzahl_para:=l2;
                                    FillChar(leer,SizeOf(leer),0);
                                    FillChar(prgname,SizeOf(prgname),0);
                                  end;
                                sig:='M';
                                eigentuemer:=psp_segment;
                                anzahl_para:=_bx;
                                FillChar(leer,SizeOf(leer),0);
                                prgname:='PROGNAME';
                                _ax:=arbeits_seg+1;
                                flags_auf_stack_aendern(not flags_carry,0);
                                speicher_aufraeumen;
                                Break;
                              end;
                          end;

                        if sig='Z' then
                          begin
                            _ax:=8; (* nicht genug Speicher *)
                            _bx:=groesster_block;
                            flags_auf_stack_aendern(0,flags_carry);
                            Break;
                          end;

                        Inc(arbeits_seg,1+anzahl_para);
                      end;

                  until false;
                  (*$Else ERWEITERTE_EMULATION*)
                  _ax:=8;
                  _bx:=0;
                  flags_auf_stack_aendern(0,flags_carry);
                  (*$EndIf ERWEITERTE_EMULATION*)

                  (* deutet nicht auf polymorphen Code hin -> schneller beenden *)
                  (*$IfDef DOS*)
                  schritt_beschraenkung(400);
                  (*$Else DOS*)
                  schritt_beschraenkung(40000);
                  (*$EndIf DOS*)
                end;

              (*$IfDef ERWEITERTE_EMULATION*)
              $49: (* Speicherfreigabe *)
                begin
                  if suche_mcb(smallword(_es-1)) then
                    begin
                      mcb_z(liefere_adresse_8(arbeits_seg,0))^.eigentuemer:=0;
                      flags_auf_stack_aendern(not flags_carry,0);
                    end;
                  speicher_aufraeumen;
                end;
              (*$EndIf ERWEITERTE_EMULATION*)

              (*$IfDef ERWEITERTE_EMULATION*)
              $4a: (* SpeicherÑnderung *)
                begin
                  if suche_mcb(smallword(_es-1)) then
                    begin

                      nochmal_214a:

                      with mcb_z(liefere_adresse_8(arbeits_seg,0))^ do
                        begin
                          if anzahl_para>_bx then      (* verkleinern    *)
                            begin
                              a2:=arbeits_seg+1+_bx;
                              l2:=anzahl_para-1-_bx;
                              s2:=sig;
                              with mcb_z(liefere_adresse_8(a2,0))^ do
                                begin
                                  sig:=s2;
                                  eigentuemer:=0;
                                  anzahl_para:=l2;
                                  FillChar(leer,SizeOf(leer),0);
                                  FillChar(prgname,SizeOf(prgname),0);
                                end;
                              sig:='M';
                              anzahl_para:=_bx;
                              flags_auf_stack_aendern(not flags_carry,0);
                            end
                          else if anzahl_para=_bx then (* gleichbleibend *)
                            begin
                              flags_auf_stack_aendern(not flags_carry,0);
                            end
                          else                         (* vergrî·ern     *)
                            begin
                              a2:=arbeits_seg+1+anzahl_para;
                              if  (mcb_z(liefere_adresse_8(a2,0))^.eigentuemer=0)
                              and (mcb_z(liefere_adresse_8(a2,0))^.sig in ['M','Z'])
                               then
                                begin
                                  sig:=mcb_z(liefere_adresse_8(a2,0))^.sig;
                                  Inc(anzahl_para,1+mcb_z(liefere_adresse_8(a2,0))^.anzahl_para);
                                  goto nochmal_214a;
                                end;

                              _ax:=8; (* nicht genug Speicher *)
                              _bx:=anzahl_para;
                              flags_auf_stack_aendern(0,flags_carry);
                            end;


                        end;

                    end;
                  speicher_aufraeumen;
                end;
              (*$EndIf ERWEITERTE_EMULATION*)


              {unsinn $4a: (* A86.COM *)
                begin
                  _flags:=_flags or flags_carry;<
                  _ax:=8;
                  _bx:=$ffff;
                end;  }

              $4b:
                case register_16(_ax).l of
                  $00..$03:
                    begin
                      (* SHRINKER.COM lÑd SHRINKER.EXE als Overlay *)
                      exezk:=textz_ausfueren__^;
                      lies_emu(tmp_puffer,512,_ds,_dx);
                      exezk_anhaengen(puffer_zu_zk_e(tmp_puffer.d[0],#0,80));
                      exezk_anhaengen(' ');
                      lies_emu(tmp_puffer,6,_es,_bx);
                      lies_emu(tmp_puffer,512,word_z(@tmp_puffer.d[4])^,word_z(@tmp_puffer.d[2])^);
                      (*if tmp_puffer.d[0]>0 then Dec(tmp_puffer.d[0]);*)
                      exezk_anhaengen(puffer_zu_zk_pstr(tmp_puffer.d[0]));
                      exezk_anhaengen('" !!');
                      emulationstoppen(exezk,signatur);
                    end;
                  $ff: (* $4bff *)
                    begin
                      ausschrift('Cascade',virus);
                      (* weiter durchsuchen .. zum Host *)
                    end;
                end;

              $4e: (* FINDFIRST *)
                begin
                  lies_emu(tmp_puffer,512,_ds,_dx);
                  (* Viren/ErstinfektorverdÑchtig (VMEDEMO.COM) *)
                  exezk:=puffer_zu_zk_e(tmp_puffer.d[0],#0,80);
                  ausschrift('FindFirst "'+exezk+'" !!',signatur);

                  (*$IfDef POEM_BIO*)
                  _ax:=0;
                  flags_auf_stack_aendern(not flags_carry,0);

                  while Pos('\',exezk)>0 do
                    Delete(exezk,1,Pos('\',exezk));
                  if exezk='*.*' then
                    exezk:='ICH_AUCH.EXE';
                  while Pos('?',exezk)>0 do
                    exezk[Pos('?',exezk)]:='A';
                  while Pos('*',exezk)>0 do
                    exezk[Pos('*',exezk)]:='A';

                  schreibe_speicher_8 (dta_seg,dta_ofs+$15  ,  $20{_cx}); (* Attribut  *)
                  schreibe_speicher_16(dta_seg,dta_ofs+$16  ,    0); (* 00.00     *)
                  schreibe_speicher_16(dta_seg,dta_ofs+$18  ,    0); (* 1980..    *)
                  schreibe_speicher_16(dta_seg,dta_ofs+$1a  ,12345); (* Grî·e     *)
                  schreibe_speicher_16(dta_seg,dta_ofs+$1a+2,    0);
                  exezk:=exezk+'             ';
                  exezk[13]:=#0;
                  for w1:=1 to 13 do                                 (* Dateiname *)
                    schreibe_speicher_8(dta_seg,dta_ofs+$1e+w1-1,Ord(exezk[w1]));
                  (*$Else POEM_BIO*)
                  _ax:=18; (* NO MORE FILES *)
                  flags_auf_stack_aendern(0,flags_carry);
                  (*$EndIf POEM_BIO*)
                end;

              $4f: (* FINDNEXT *)
                begin
                  _ax:=18; (* NO MORE FILES *)
                  flags_auf_stack_aendern(0,flags_carry);
                end;

              $50:  (* SET PSP (MSDOS 7 COMMAND.COM *)
                begin
                  emulationstoppen('',signatur);
                  exit;
                end;

              $51: (* GET PSP SEG (NWCACHE.OV2) *)
                begin
                  _bx:=smallword(psp_segment);
                end;

              $5b:  (* create new file *)
                begin
                  exezk:=emu_zu_zk_e(_ds,_dx,#0);
                  ausschrift(textz_poem__create_new_file^+exezk+'"',signatur);
                end;

              $60: (* TRUENAME *)
                begin
                  lies_emu(tmp_puffer,512,_ds,_dx);
                  exezk:=puffer_zu_zk_e(tmp_puffer.d[0],#0,80);
                  (* faule Implementierung... *)
                  schreibe_speicher(_es,_di,exezk);
                end;

              $62:
                begin
                  (* GET PSP *) (* EMM386.EXE / MS *)
                  _bx:=smallword(psp_segment);
                end;


              $f0:
                if _ax=$f078 then
                  begin
                    (* Installationstest *)
                    emulationstoppen('Burglar/H ≥ Burglar.1150',virus);
                  end;
              (* $fe:
                begin
                  (tequila)
                end;*)



            else
{
              $49, (* Umgebung freigeben in STB-VESA.COM *)
              $4a, (* Speichergrî·e Ñndern (CTMOUSE 1.6) *)

              $19, (* get default drive \                         *)
              $34, (* indos             |                         *)
              $4d, (* exitcode          |                         *)
              $54, (* verify            - in FOOLTEU/FILESPY.EXE  *)
              $62: (* list of list      /                         *)
                begin
                end;}
              (*$IfNDef ENDVERSION*)
              asm
                nop
              end;
              (*$EndIf ENDVERSION*)

            end;


          end; (* INT $21 *)
        (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)

        $24,$25: (* DOS Lesen/Schreiben *) (* NWDOS\STACHIGH.SYS *)
          begin
            _ax:=$0103; (* Unbekannter Befehl *)
            _flags:=_flags or flags_carry;
            (*$IfDef POEM_BIO*)
            rueckkehr:=r_retf;
            (*$EndIf POEM_BIO*)
          end;

        $27:
          begin
            (* eigenlich erst ab $100 aber das PSP bleibt ja auch resident *)
            emulationstoppen('TSR ('+str0(_dx)+' Byte)',signatur);
          end;

        $29: (* FC131KEY *)
          begin
            (*$IfDef POEM_BIO*)
            rueckkehr:=r_weiter;
            (*$Else POEM_BIO*)
            textausgabe_char(Chr(register_16(_ax).l));
            (*$EndIf POEM_BIO*)
          end;

        $2f:   (* INT $2f *)
          begin
            if _ax=$4010 then
              (* keine énderung an AX damit Fehlermeldung ausgegeben wird *)
              ausschrift(textz_OS2_Installationstest^,signatur);
          end;

      (*$IfDef POEM_BIO*)
      else
        rueckkehr:=r_weiter;
      (*$EndIf POEM_BIO*)
      end;     (* CASE    *)

      (*$IfDef POEM_BIO*)
      if rueckkehr=r_iret then
        begin
          _cs:=$f000; (* hier ist in poem_bio.a86 ein iret *)
          _ip:=$0400;
        end
      else if rueckkehr=r_retf then
        begin
          _cs:=$f000; (* hier ist in poem_bio.a86 ein retf *)
          _ip:=$0401;
        end;

      (*$EndIf POEM_BIO*)

    end;

  procedure int_aufrufen(const i:byte);
    begin
      push_(_flags);            (* Nîtig fÅr COM2EXE aus HACKSTOP 1.19 217 *)
      push_(_cs);
      push_(_ip);
      (*$IfDef POEM_BIO*)
      _cs:=lade_word($0000,i*4+2);
      _ip:=lade_word($0000,i*4+0);
      _flags:=_flags and ((not flags_trap) (* and (not flags_int*));

      (* ein bischen beschleunigen *)
      if (_cs=$f400+postbyte1) and (_ip=0) (*and ((_flags and flags_trap)=0)*) then
        begin
          _cs:=$f000;
          _ip:=postbyte1*4;
        end;
      (*$Else POEM_BIO*)
      int_behandlung(i);
      pop_(_ip);
      pop_(_cs);
      if not (i in [$25,$26]) then
        pop_(_flags);
      (*$EndIf POEM_BIO*)
    end;

  procedure opc_uu;
    begin
      (*$IfDef ENDVERSION*)
      emulationstoppen('',signatur);
      (*$Else ENDVERSION*)
      Dec(herstellersuche);
      emulationstoppen('unbekannt:'+hex_word(_cs)+':'+hex_word(_ip)+' '
        +hex(emu_puffer.d[0])+' '+hex(emu_puffer.d[1]),signatur);
      Inc(herstellersuche);
      (*$EndIf ENDVERSION*)
    end;

  procedure opc_00; (* ADD ...,REG8 *)
    begin
      (* CSGRADE.BIN und andere Datendateien *)
      Inc(obc_00_zaehler);
      if (obc_00_zaehler=10) and (schritt<19) then
        emulationstoppen_kein_hersteller('',signatur);


      (* Fehler aufgetreten *)
      if bytesuche(emu_puffer.d[1],#$00#$00#$00#$00#$00#$00#$00#$00) then
        (*$IfDef ENDVERSION*)
        emulationstoppen('',signatur);
        (*$Else ENDVERSION*)
        emulationstoppen('<Nullen>',signatur);
        (*$EndIf ENDVERSION*)


      add_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_01; (* ADD ...,REG16 *)
    begin
      add_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_02; (* ADD REG8,... *)
    begin
      add_8(
        register_tabelle_8[postbyte1_shr_3_and_7]^,
        berechne_speicher_8_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_03; (* ADD REG16,... *)
    begin
      add_16(
        register_tabelle_16[postbyte1_shr_3_and_7]^,
        berechne_speicher_16_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_04; (* ADD AL,$xx *)
    begin
      add_8(register_16(_ax).l,postbyte1);
      Inc(_ip,2);
    end;

  procedure opc_05; (* ADD AX,$xx *)
    begin
      add_16(_ax,postword1);
      Inc(_ip,3);
    end;

  procedure opc_06; (* PUSH ES *)
    begin
      push_(_es);
      Inc(_ip);
    end;

  procedure opc_07; (* POP ES *)
    begin
      pop_(_es);
      Inc(_ip);
      protect55:=protect55 or protect55_pop_es;
    end;

  procedure opc_08; (* OR ...,REG8 *)
    begin
      or_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_09; (* OR ...,REG16 *)
    begin
      or_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_0a; (* OR REG8,... *)
    begin
      or_8(
        register_tabelle_8[postbyte1_shr_3_and_7]^,
        berechne_speicher_8_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_0b; (* OR REG16,... *)
    begin
      or_16(
        register_tabelle_16[postbyte1_shr_3_and_7]^,
        berechne_speicher_16_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_0c; (* OR AL,$xx *)
    begin
      or_8(register_16(_ax).l,postbyte1);
      Inc(_ip,2);

      (* FOOLTEU.EXE: 0c 1a *)
      if postbyte1=$1a then (* OR AL,01A *)
        unbekannt1_zaehler:=unbekannt1_zaehler or bit04;
    end;

  procedure opc_0d; (* OR AX,$xxxx *)
    begin
      or_16(_ax,postword1);
      Inc(_ip,3);
    end;

  procedure opc_0e; (* PUSH CS *)
    begin
      Inc(_ip);
      push_(_cs);

      if bytesuche(emu_puffer.d[0],#$0e#$b0#$f5#$e6#$60#$b0#$cb#$e8'??'#$86#$06#$00#$01#$e8'??'#$2e#$8b#$36'??'#$ba) then
        begin
          emulationstoppen('FSE / Zenix Yang [0.4]',packer_exe);
          exit;
        end;

      protect55:=protect55 or protect55_push_cs;
    end;

  procedure opc_0f; (* code extension # 21 * 286/386+ *)
    begin
      case emu_puffer.d[1] of
        $01:
          if bytesuche(emu_puffer.d[1],#$01#$e0) then (* SMSW AX *)
            begin
              (* HIRWI.ZIP\HHPARTY.EXE *)
              _ax:=bit00; (* Protect Enable *)
              Inc(_ip,3);
            end
          else
            emulationstoppen('',signatur); (* nicht implementiert *) (* z.B. LMSW *)
        (* $80:.. $8f J?? *)
        $82: (* JB +$xxxx *) (* ANITUPC / B†rt†zi Andr†s *)
          begin
            Inc(_ip,4);
            if (_flags and flags_carry)<>0 then
              Inc(_ip,postword2);
            Inc(sprung_zaehler);
          end;
        $83: (* JAE +$xxxx *)
          begin
            Inc(_ip,4);
            if (_flags and flags_carry)=0 then
              Inc(_ip,postword2);
            Inc(sprung_zaehler);
          end;
        $84: (* JZ +$xxxx *) (* ICEUNP.EXE *)
          begin
            Inc(_ip,4);
            if (_flags and flags_zero)<>0 then
              Inc(_ip,postword2);
            Inc(sprung_zaehler);
          end;
        $85: (* JNZ +$xxxx *)
          begin
            Inc(_ip,4);
            if (_flags and flags_zero)=0 then
              Inc(_ip,postword2);
            Inc(sprung_zaehler);
          end;
      else
        emulationstoppen('',signatur); (* nicht implementiert *)
      end;
    end;

  procedure opc_10; (* ADC ...,REG8 *)
    begin
      adc_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_11; (* ADC ...,REG16 *)
    begin
      adc_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_12; (* ADC REG8,... *)
    begin
      adc_8(
        register_tabelle_8[postbyte1_shr_3_and_7]^,
        berechne_speicher_8_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_13; (* ADC REG16,... *)
    begin
      adc_16(
        register_tabelle_16[postbyte1_shr_3_and_7]^,
        berechne_speicher_16_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_14; (* ADC AL,$xx *)
    begin
      adc_8(
        register_16(_ax).l,
        postbyte1);

      Inc(_ip,2);
    end;

  procedure opc_15; (* ADC AX,$xxxx *)
    begin
      adc_16(
        _ax,
        postword1);

      Inc(_ip,3);
    end;

  procedure opc_16; (* PUSH SS *)
    begin
      push_(_ss);
      Inc(_ip);
    end;

  procedure opc_17; (* POP SS *)
    begin
      pop_(_ss);
      Inc(_ip);
    end;

  procedure opc_18; (* SBB ...,REG8 *)
    begin
      sbb_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_19;
    begin
      sbb_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_1a; (* SBB REG8,... *) (* FOOLTEU.EXE: 1a c1 = SBB AL,CL *)
    begin
      sbb_8(
        register_tabelle_8[postbyte1_shr_3_and_7]^,
        berechne_speicher_8_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_1b; (* SBB REG16,... *)
    begin
      sbb_16(
        register_tabelle_16[postbyte1_shr_3_and_7]^,
        berechne_speicher_16_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_1c; (* SBB AL,$xx *)
    begin
      (* FS6X86.EXE *)
      sbb_8(register_16(_ax).l,postbyte1);
      Inc(_ip,2);
    end;

  procedure opc_1d; (* SBB AX,$xxxx *)
    begin
      sbb_16(_ax,postword1);
      Inc(_ip,3);
    end;

  procedure opc_1e; (* PUSH DS *)
    begin
      push_(_ds);
      Inc(_ip);

      (*if bytesuche(emu_puffer.d[0],#$1e#$b8#$40#$00#$8e#$d8#$bb#$8e#$00#$80#$27#$7f) then
        emulationstoppen('CD-Treiber ????',signatur);*)

      if bytesuche(emu_puffer.d[0],#$1e#$52#$b8'?'#$30#$cd#$21#$86#$c4#$3d'?'#$02#$73#$02#$cd#$20) then
        begin
          hackstop('1.19');
          emulationstoppen('',signatur);
        end;

      if bytesuche(emu_puffer.d[0],#$1e#$52#$b4#$30#$cd#$21#$86#$c4#$3d'?'#$02#$73#$02#$cd#$20#$0e#$1f#$e8) then
        begin (* HS(3)86D.EXE *)
          hackstop('1.20d,b226');
          emulationstoppen('',signatur);
        end;

      if bytesuche(emu_puffer.d[0],#$1e#$52#$b4#$30#$cd#$21#$86#$c4#$3d'?'#$02#$73#$02#$cd#$20#$0e#$1f#$57#$bf#$eb#$04) then
        begin (* Hackstop mutation wegen Kaspersky... *)
          emulationstoppen('RSCC / Ralph Roth [1.05/20]',packer_exe);
          rscc_endekennung;
          Exit;
        end;

      if bytesuche(emu_puffer.d[0],#$1e#$06#$57#$b9#$20#$00#$bb#$ff#$ff
        +#$8c#$da#$8e#$c2#$8d#$16'??'#$8b#$fa#$ba#$ff#$ff#$b8#$01#$65#$cd#$21) then
        begin
          ausschrift(textz_Maustreiber^+' [Genius 10.43]',signatur);
          maustext_gefunden:=datei_pos_suche(org_code_imagestart+longint(integer(_cs))*16+_ip,analyseoff+einzel_laenge,
            '$'#$0d#$0a'…ÕÕÕ');
          if maustext_gefunden<>nicht_gefunden then
            ansi_anzeige(maustext_gefunden+1
             ,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'');
          emulationstoppen('',signatur);
        end;
    end;

  procedure opc_1f; (* POP DS *)
    begin
      pop_(_ds);
      Inc(_ip);
      protect55:=protect55 or protect55_pop_ds;
    end;

  procedure opc_20; (* AND ...,REG8 *)
    begin
      and_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_21; (* AND ...,REG16 *)
    begin
      and_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_22; (* AND REG8,... *)
    begin
      and_8(
        register_tabelle_8[postbyte1_shr_3_and_7]^,
        berechne_speicher_8_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_23; (* AND REG16,... *)
    begin
      and_16(
        register_tabelle_16[postbyte1_shr_3_and_7]^,
        berechne_speicher_16_inhalt);

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_24; (* AND AL,$xx *)
    begin
      and_8(register_16(_ax).l,postbyte1);
      Inc(_ip,2);
    end;

  procedure opc_25; (* AND AX,$xxxx *)
    begin
      and_16(_ax,postword1);
      Inc(_ip,3);
    end;

  procedure opc_26; (* ES: *)
    begin
      prefix:=true;
      segment_ueberschreibung:=segment_ueberschreibung_es;

      Inc(_ip);
    end;

  procedure opc_27; (* DAA *)
    begin
      Inc(_ip);
      asm
        call setze_zu_emulierende_flags
        mov ax,[_ax]
        daa
        mov [_ax],ax
        call sichere_zu_emulierende_flags
      end;
    end;

  procedure opc_28; (* SUB ...,REG8 *)
    begin
      sub_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_29; (* SUB ...,REG16 *)
    begin
      Inc(_ip,2+zusatzlaenge_opcode);
      sub_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);
    end;

  procedure opc_2a; (* SUB REG8,... *)
    begin
      Inc(_ip,2+zusatzlaenge_opcode);
      sub_8(
        register_tabelle_8[postbyte1_shr_3_and_7]^,
        berechne_speicher_8_inhalt);
    end;

  procedure opc_2b; (* SUB REG16,... *)
    begin
      Inc(_ip,2+zusatzlaenge_opcode);
      sub_16(
        register_tabelle_16[postbyte1_shr_3_and_7]^,
        berechne_speicher_16_inhalt);
    end;

  procedure opc_2c; (* SUB AL,0xx *)
    begin
      (* FS6X86.EXE *)
      sub_8(register_16(_ax).l,postbyte1);
      Inc(_ip,2);
    end;


  procedure opc_2d; (* SUB AX,0XXXX *)
    begin
      sub_16(_ax,postword1);
      Inc(_ip,3);
    end;

  procedure opc_2e; (* CS: *)
    begin
      Inc(_ip);
      prefix:=true;
      segment_ueberschreibung:=segment_ueberschreibung_cs;

      if cybershadow=0 then
        if bytesuche(emu_puffer.d[0],#$2e#$30#$22) then
          Inc(cybershadow);

      if bytesuche(emu_puffer.d[0],#$2e#$ff#$36#$00#$00#$be#$03#$01#$8b#$d4#$2e#$c7#$06#$00#$00) then
        begin
          emulationstoppen('ShaDoW COM cryptor / MANtiC0RE [1.71 /b]',packer_exe);
          anzeige_sdw_reg;
        end;
      if bytesuche(emu_puffer.d[0],#$2e#$ff#$36#$00#$00#$8b#$d4#$2e#$c7#$06#$00#$00#$cd#$20) then
        begin
          Dec(_ip);
          lies_emu_puffer($60);
          Inc(_ip);
          case emu_puffer.d[$23] of
            $0f:exezk:='1.74 /b';
            $75:exezk:='1.78';
          else
                exezk:='1.?? ¯';
          end;
          emulationstoppen('ShaDoW COM cryptor / MANtiC0RE ['+exezk+']',packer_exe);
          anzeige_sdw_reg;
        end;
    end;

  procedure opc_2f; (* DAS *)
    begin
      Inc(_ip);
      asm
        call setze_zu_emulierende_flags
        mov ax,[_ax]
        das
        mov [_ax],ax
        call sichere_zu_emulierende_flags
      end;
    end;

  procedure opc_30; (* XOR ...,REG8 *)
    begin
      xor_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_31; (* XOR ...,REG16 *)
    begin
      if bytesuche(emu_puffer.d[0],#$31#$c0#$06#$1e#$50#$2d#$00#$48#$50#$1f#$07#$26#$ff#$77) then
        (* nur 2 Demo-Dateien *)
        emulationstoppen('Lock-Master (=CodeLock) / Andrew Kacy [9.0]',packer_exe);

      xor_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_32; (* XOR REG8,... *)
    begin
      xor_8(
        register_tabelle_8[postbyte1_shr_3_and_7]^,
        berechne_speicher_8_inhalt);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_33; (* XOR REG16,... *)
    begin
      xor_16(
        register_tabelle_16[postbyte1_shr_3_and_7]^,
        berechne_speicher_16_inhalt);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_34; (* XOR AL,$xx *)
    begin
      xor_8(register_16(_ax).l,postbyte1);
      Inc(_ip,2);
    end;

  procedure opc_35; (* XOR AX,$xxxx *)
    begin
      xor_16(_ax,postword1);
      Inc(_ip,3);
    end;

  procedure opc_36; (* SS: ... *) (* FILESPY.EXE: *)
    begin
      prefix:=true;
      segment_ueberschreibung:=segment_ueberschreibung_ss;
      Inc(_ip);
    end;

  procedure opc_37; (* AAA *)
    begin
      Inc(_ip);
      asm
        call setze_zu_emulierende_flags
        mov ax,[_ax]
        aaa
        mov [_ax],ax
        call sichere_zu_emulierende_flags
      end;
    end;

  procedure opc_38; (* CMP ...,REG8 *)
    begin
      cmp_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_39; (* CMP ...,REG16 *)
    begin
      cmp_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_3a; (* CMP REG8,... *)
    begin
      cmp_8(
        register_tabelle_8[postbyte1_shr_3_and_7]^,
        berechne_speicher_8_inhalt);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_3b; (* CMP REG16,... *)
    begin
      (* CMP AX,[$046c] * ausgepacktes PROTECT!.EXE 6.0 *)
      if bytesuche(emu_puffer.d[0],#$3b#$06#$6c#$04) then
        Dec(_ax);

      (* CMP AX,[$006c] * ausgepacktes Hackstop 1.19.206 *)
      if bytesuche(emu_puffer.d[0],#$3b#$06#$6c#$00) then
        Dec(_ax);


      cmp_16(
        register_tabelle_16[postbyte1_shr_3_and_7]^,
        berechne_speicher_16_inhalt);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_3c; (* CMP AL,$xx *) (* AFD.EXE *)
    begin
      cmp_8(register_16(_ax).l,postbyte1);
      Inc(_ip,2);
    end;

  procedure opc_3d; (* CMP AX,$xxxx *)
    begin
      cmp_16(_ax,postword1);
      Inc(_ip,3);
    end;

  procedure opc_3e; (* DS: *) (* FILESPY.EXE: *)
    begin
      prefix:=true;
      segment_ueberschreibung:=segment_ueberschreibung_ds;
      Inc(_ip);
    end;

  procedure opc_3f; (* AAS *)
    begin
      Inc(_ip);
      asm
        call setze_zu_emulierende_flags
        mov ax,[_ax]
        aas
        mov [_ax],ax
        call sichere_zu_emulierende_flags
      end;
    end;

  procedure opc_40_47; (* 40..$47: INC REG16 *)
    begin
      inc_16(register_tabelle_16[emu_puffer.d[0]-$40]^);
      Inc(_ip);

      if cybershadow=1 then
        if bytesuche(emu_puffer.d[0],#$45) then
          Inc(cybershadow);
    end;

  procedure opc_48_4f; (* 48..$4f: DEC REG16 *)
    begin
      if schritt<80 then
        (* eigentlich auch noch mov cs:[],.. vorher *)
        if  bytesuche(emu_puffer.d[2],#$74#$02#$eb)
        and (emu_puffer.d[1] in [$48..$4f])
         then
          if register_tabelle_16[emu_puffer.d[1]-$48]^
            -register_tabelle_16[emu_puffer.d[0]-$48]^
            +_ip+5=0 then
          begin
            emulationstoppen('ProtEXE / Tom Torfs [3.11]',packer_exe);
          end;

      dec_16(register_tabelle_16[emu_puffer.d[0]-$48]^);
      Inc(_ip);

      if cybershadow=3 then
        if bytesuche(emu_puffer.d[0],#$49) then
          Inc(cybershadow);
    end;

  procedure opc_50_57;  (* 50..$57: PUSH REG16 *)
    var
      abpe:dateigroessetyp;
    begin
      push_(register_tabelle_16[emu_puffer.d[0]-$50]^);
      Inc(_ip);

      if bytesuche(emu_puffer.d[0],#$55#$fa#$8b#$ec#$8b#$46#$fe#$50#$c7#$46#$fe#$00#$00) then
        begin
          (* 1.04.04: RC286.1.18.2 *)
          (* 1.04.06: ? *)
          emulationstoppen('RSCC / Ralph Roth [1.04.04,1.04.06]',packer_exe);
          rscc_endekennung;
          Exit;
        end;

      (* Fehler: fÅr DOS<4 springt das Programm ins nichts *)
      if bytesuche(emu_puffer.d[0],#$50#$0e#$eb#$0e#$ea#$3c#$04#$73#$0e#$b4#$4c#$e9#$c7#$fe#$cd#$21#$eb#$f3
           +#$b4#$30#$eb#$f8#$ea#$2b#$c9#$51) then
        begin
          exezk:='';
          if datei_pos_suche(analyseoff,analyseoff+einzel_laenge,
            #$3a#$d6#$74#$e5#$ba#$eb#$05#$5b#$eb#$fb#$66#$69#$9c#$58)<>nicht_gefunden then
              exezk:='c';
          emulationstoppen('ExOM / AbdelAziz BELBACHiR [0.01'+exezk+']',packer_exe);
          Exit;
        end;

      if bytesuche(emu_puffer.d[0],#$50#$50#$55#$58#$54#$5b#$05#$18#$00#$2b#$c9#$0e#$87#$07#$51#$5b) then
        begin
          abpe:=datei_pos_suche(analyseoff,analyseoff+einzel_laenge,'[ABPE]');
          if abpe=nicht_gefunden then
            exezk:='2'{ist hier nicht sinnvoll!}
          else
            exezk:='3/4';
          emulationstoppen('ExOM / AbdelAziz BELBACHiR [0.0'+exezk+']',packer_exe);
          Exit;
        end;

      if bytesuche(emu_puffer.d[0],#$55#$e8#$00#$00#$5d#$81#$ed'??'#$1e#$33#$d2#$8d#$b6) then
        begin
          exezk:='?.?';
          if word_z(@emu_puffer.d[7])^=$438 then
            exezk:='1.107 "TREKLOCK"';

          emulationstoppen('SnoopStop / Trills and Technologies ['+exezk+']',packer_exe);
          exit;
        end;

      if bytesuche(emu_puffer.d[0],#$55#$e8#$00#$00#$59#$8b#$e9#$81#$ed'??'#$66#$60#$8d) then
        begin
          exezk:='?.?';
          if word_z(@emu_puffer.d[9])^=$3ad then
            exezk:='1.12 "TREKLOCK"';
          if word_z(@emu_puffer.d[9])^=$388 then
            exezk:='1.13';
          if word_z(@emu_puffer.d[9])^=$2d5 then
            exezk:='1.15';
          if word_z(@emu_puffer.d[9])^=$282 then
            exezk:='1.15r'; (* SNPSTP.COM 1.15 *)
          emulationstoppen('SnoopStop / Trills and Technologies ['+exezk+']',packer_exe);
          exit;
        end;

      (* STB VESA TSR (PV-VESA.COM,STB-VESA.COM) *)
      if bytesuche(emu_puffer.d[0],#$56#$8b#$f2#$2e#$8a#$14#$46#$b4#$02#$51#$cd#$21) then
        begin
          pos1:=org_code_imagestart+longint(integer(_ds))*16+_dx;
          ansi_anzeige(pos1,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,pos1+_cx,'');
          emulationstoppen('',signatur);
          (*exit;*)
        end;

    end; (* $50..$57 *)

  procedure opc_58_5f; (* 58..$5f: 58..$5f: POP REG16 *)
    begin
      Inc(_ip);
      pop_(register_tabelle_16[emu_puffer.d[0]-$58]^);

      if bytesuche(emu_puffer.d[0],#$5f#$8b#$f7#$56#$2e#$ff#$36#$00#$00) then
        emulationstoppen('ShaDoW COM cryptor / MANtiC0RE [1.76 /b]',packer_exe);
    end;

  procedure opc_60; (* PUSHA *)
    begin
      tmp16:=_sp;
      push_(_ax);
      push_(_cx);
      push_(_dx);
      push_(_bx);
      push_(tmp16);
      push_(_bp);
      push_(_si);
      push_(_di);
      Inc(_ip);
    end;

  procedure opc_61; (* POPA *)
    begin
      pop_(_di);
      pop_(_si);
      pop_(_bp);
      pop_(tmp16);(* SP unverÑndert*)
      pop_(_bx);
      pop_(_dx);
      pop_(_cx);
      pop_(_ax);
      Inc(_ip);
    end;

  procedure opc_62; (* BOUND *)
    begin
      if not berechne_speicher_32_inhalt then
        int_aufrufen($06) (* invalid opcode *)
      else
      if (register_tabelle_16[postbyte1_shr_3_and_7]^<r32.w0)
      or (register_tabelle_16[postbyte1_shr_3_and_7]^>r32.w1)
       then
        begin
          (* _ip bleibt unverÑndert auf 286+ *)
          int_aufrufen($05);
        end
      else
        Inc(_ip,2+zusatzlaenge_opcode);
    end;

  (* $63: ARPL *)
  (* $64: FS: *)
  (* $65: GS: *)

  procedure opc_66; (* 16/32 bit Prefix *)
    var
      w1:word;
      version_puffer:puffertyp;
    begin

      if bytesuche(emu_puffer.d[0],#$66#$9c#$67#$80#$4c#$24#$02#$01#$be'??'#$03#$f5#$81#$c6#$00#$01) then
        begin
          (* mess on the moon *)
          emulationstoppen('Mess / Stonehead [1.31 /m]',packer_exe);
          Exit;
        end;

      if bytesuche(emu_puffer.d[0],#$66#$33#$c0#$0f#$23#$f8) then
        begin
          (* mess on the moon   *)
          (* xor eax,eax        *)
          (* mov dr7,eax        *)
          Inc(_ip,3+3);
          _ax:=0; (* eax! *)
          max_schritte:=High(max_schritte) shr 1; (* damit alle Schichten entschlÅsselt werden.. *)
          Exit;
        end;


      if bytesuche(emu_puffer.d[0],#$66#$0f#$a0#$66#$0f#$a1) then
        if puffer_gefunden(emu_puffer,#$0e#$eb#$01'?'#$2b#$c9#$51#$fb#$8e#$d9#$8a#$16#$6c#$04) then
          begin
            emulationstoppen('ExOM / AbdelAziz BELBACHiR [0.02]',packer_exe);
            Exit;
          end;

      if bytesuche(emu_puffer.d[0],#$66#$c1#$cc#$10) then
        begin
          (* FSEE/F: SHL ESP,$10 *)
          Inc(_ip);
          Exit; (* emulation_stoppen:=false *)
        end;

      (* MTMCDAI.SYS - MITSUMI ATAPI CD
        bringt aber trotzdem keine Anzeige
      if bytesuche(emu_puffer.d[0],#$66#$50) then
        begin
          push_(_ax);
          push_(0);
          Inc(_ip,2);
          exit;
        end;

      if bytesuche(emu_puffer.d[0],#$66#$58) then
        begin
          pop_(_ax);
          pop_(_ax);
          Inc(_ip,2);
          exit;
        end; *)



      if bytesuche(emu_puffer.d[0],#$66#$60#$8d#$9e'??'#$8d#$8e'??'#$2b#$cb#$2e#$8a#$07#$34) then
        begin
          case word_z(@emu_puffer.d[4])^ of
            $38a:exezk:='1.00·';
            $495:exezk:='1.01';
          else
                 exezk:='1.?? ¯'
          end;
          emulationstoppen('PirateStop / Trills and Technologies ['+exezk+']',packer_exe);
          (*emulation_stoppen:=true;*)
        end;

      if bytesuche(emu_puffer.d[0],#$66#$8b#$dc#$66#$83#$e4#$f0#$66#$9c#$66#$9c#$66#$58#$66#$8b#$c8#$66#$0f#$ba#$e8#$12
            +#$66#$50 (* ... *)) then
        begin
          lies_emu(version_puffer,512,_cs,_ip{+$80});
          w1:=puffer_pos_suche(version_puffer,'iLU',500);
          if w1<>nicht_gefunden then
            emulationstoppen(puffer_zu_zk_e(version_puffer.d[w1],' -',80)+' / Christan Schwarz',packer_exe);
         (*signatur_anzeige('',version_puffer);*)
        end;

      if bytesuche(emu_puffer.d[0],#$66#$60) then
        begin (* PUSHAD: ADAPTEC ASPI8DOS.SYS *)
          tmp16:=_sp;
          push32_(_ax);
          push32_(_ax);
          push32_(_cx);
          push32_(_dx);
          push32_(_bx);
          push32_(tmp16);
          push32_(_bp);
          push32_(_si);
          push32_(_di);
          Inc(_ip,2);
          Exit;
        end;

      if bytesuche(emu_puffer.d[0],#$66#$52) then
        begin (* PUSH EDX:  BTDOSM.SYS *)
          push32_(_dx);
          Inc(_ip,2);
          Exit;
        end;

      if bytesuche(emu_puffer.d[0],#$66#$fa) then
        begin (* OP32: CLI *)
          Inc(_ip,2);
          _flags_interrupt:=false;
          Exit;
        end;

      (* keine Emulation *)
      emulationstoppen('',signatur);
    end;

  (* $67: 16/32 bit Prefix *)

  procedure opc_68; (* PUSH $xxxx *)
    begin
      push_(postword1);
      Inc(_ip,3);
    end;

  procedure opc_69; (* IMUL reg,imm,mem *)
    begin (* UNRECAV 1.03 *)
      register_tabelle_16[postbyte1_shr_3_and_7]^
        :=word(
            imul_16im(
              berechne_speicher_16_inhalt,
              word_z(@emu_puffer.d[2+zusatzlaenge_opcode])^));
      Inc(_ip,2+zusatzlaenge_opcode+2);
    end;

  procedure opc_6a; (* PUSH $xx *)
    begin
      push_(postbyte1);
      Inc(_ip,2);
    end;

  procedure opc_6b; (* IMUL reg,imm8,mem *)
    begin
      register_tabelle_16[postbyte1_shr_3_and_7]^
        :=word(
            imul_16im(
              berechne_speicher_16_inhalt,
              emu_puffer.d[2+zusatzlaenge_opcode]));
      Inc(_ip,2+zusatzlaenge_opcode+1);
    end;

  (* $6c: INSB *)
  (* $6d: INS *)
  (* $6e: OUTSB *)
  (* $6f: OUTS *)

  procedure opc_70; (* JO +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_overflow)<>0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_71; (* JNO +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_overflow)=0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_72; (* JC +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_carry)<>0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_73; (* JNC +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_carry)=0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_74; (* JE/JZ +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_zero)<>0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);

      if cybershadow=4 then
        if bytesuche(emu_puffer.d[0],#$74#$03#$e9) then
          Inc(cybershadow);
    end;

  procedure opc_75; (* JNE/JNZ +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_zero)=0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_76; (* JNA +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and (flags_carry or flags_zero))<>0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_77; (* JA +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and (flags_carry or flags_zero))=0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_78; (* JS +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_sign)<>0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_79; (* JNS +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_sign)=0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_7a; (* JP +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_parity)<>0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_7b; (* JNP +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_parity)=0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_7c; (* JL +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_sign)<>(_flags and flags_overflow) then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_7d; (* JNL +$xx *)
    begin
      Inc(_ip,2);
      if (_flags and flags_sign)=(_flags and flags_overflow) then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_7e; (* JNG +$xx *)
    begin
      Inc(_ip,2);
      if ((_flags and flags_zero)<>0)
      or ((_flags and flags_sign)<>(_flags and flags_overflow)) then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_7f; (* JG +$xx *)
    begin
      Inc(_ip,2);
      (* Fehler in HELP_PC! *)
      if ((_flags and flags_zero)=0)
      and ((_flags and flags_sign)=(_flags and flags_overflow)) then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_80; (* code extension # 1 *)
    begin
      ziel_8   :=berechne_speicher_8;
      operand_8:=emu_puffer.d[2+zusatzlaenge_opcode];

      case postbyte1_shr_3_and_7 of
        0:add_8(ziel_8^,operand_8);
        1: or_8(ziel_8^,operand_8);
        2:adc_8(ziel_8^,operand_8);
        3:sbb_8(ziel_8^,operand_8);
        4:and_8(ziel_8^,operand_8);
        5:sub_8(ziel_8^,operand_8);
        6:xor_8(ziel_8^,operand_8);
        7:cmp_8(ziel_8^,operand_8);
      end;

      Inc(_ip,2+zusatzlaenge_opcode+1);

      if cybershadow=2 then
        if bytesuche(emu_puffer.d[0],#$80#$c4) then
          Inc(cybershadow);
    end;

  procedure opc_81; (* code extension # 2 *)
    begin
      ziel_16   :=berechne_speicher_16;
      operand_16:=word_z(@emu_puffer.d[2+zusatzlaenge_opcode])^;

      case postbyte1_shr_3_and_7 of
        0:add_16(ziel_16^,operand_16);
        1: or_16(ziel_16^,operand_16);
        2:adc_16(ziel_16^,operand_16);
        3:sbb_16(ziel_16^,operand_16);
        4:and_16(ziel_16^,operand_16);
        5:sub_16(ziel_16^,operand_16);
        6:xor_16(ziel_16^,operand_16);
        7:cmp_16(ziel_16^,operand_16);
      end;

      Inc(_ip,2+zusatzlaenge_opcode+2);

      (* (2e) 81 86 0a 00 00 10: add es:[bp+000a],1000 (DRDOS.703\IBMBIO.COM) *)
      (*   2e 81 3e 00 00 cd 20: cmp es:[0],20cd                              *)
      (*   75 21                                                              *)
      (*   2e 8b 0e 02 00      : mov cx,cs:[2]                                *)
      (*   2e 2b 8e 0e 00      : sub cx,cs:[bp+0e]                            *)
      (*   81 f9 00 20         : cmp cx,2000                                  *)
      if bytesuche(emu_puffer.d,#$81#$86#$0a#$00#$00#$10#$2e#$81#$3e#$00#$00#$cd#$20#$75'?'
       +#$2e#$8b#$0e#$02#$00#$2e#$2b#$8e#$0e#$00#$81#$f9#$00#$20) then
        begin
          ibmbio_text_pos:=datei_pos_suche(analyseoff,analyseoff+einzel_laenge,'NaMe S');
          if ibmbio_text_pos<>nicht_gefunden then
            ansi_anzeige(ibmbio_text_pos,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
              ,absatz,wahr,wahr,unendlich,'');
          emulationstoppen('',signatur);
        end;
    end;

  procedure opc_82; (* code extension #3 *)
    begin
      ziel_8    :=berechne_speicher_8;
      operand_8 :=emu_puffer.d[2+zusatzlaenge_opcode];

      case postbyte1_shr_3_and_7 of
        0:add_8(ziel_8^,operand_8);
        1: or_8(ziel_8^,operand_8); (* teilweise undefiniert *)
        2:adc_8(ziel_8^,operand_8);
        3:sbb_8(ziel_8^,operand_8);
        4:and_8(ziel_8^,operand_8); (* teilweise undefiniert *)
        5:sub_8(ziel_8^,operand_8);
        6:xor_8(ziel_8^,operand_8); (* teilweise undefiniert *)
        7:cmp_8(ziel_8^,operand_8);
      end;

      Inc(_ip,2+zusatzlaenge_opcode+1);
    end;

  procedure opc_83; (* code extension #4 *)
    begin
      ziel_16   :=berechne_speicher_16;
      operand_16:=word(integer(shortint(emu_puffer.d[2+zusatzlaenge_opcode])));

      case postbyte1_shr_3_and_7 of
        0:add_16(ziel_16^,operand_16);
        1:or_16 (ziel_16^,operand_16);
        2:adc_16(ziel_16^,operand_16);
        3:sbb_16(ziel_16^,operand_16);
        4:and_16(ziel_16^,operand_16);
        5:sub_16(ziel_16^,operand_16);
        6:xor_16(ziel_16^,operand_16);
        7:cmp_16(ziel_16^,operand_16);
      end;

      Inc(_ip,2+zusatzlaenge_opcode+1);
    end;

  procedure opc_84; (* TEST ...,REG8 *)
    begin
      test_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_85; (* TEST ...,REG16 *)
    begin
      test_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_86; (* XCHG ...,REG8 *)
    begin
      xchg_8(
        berechne_speicher_8^,
        register_tabelle_8[postbyte1_shr_3_and_7]^);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_87; (* XCHG ...,REG16 *)
    begin
      xchg_16(
        berechne_speicher_16^,
        register_tabelle_16[postbyte1_shr_3_and_7]^);
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_88; (* MOV ...,REG8 *)
    begin
        berechne_speicher_8^
      :=register_tabelle_8[postbyte1_shr_3_and_7]^;

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_89; (* MOV ...,REG16 *)
    begin
        berechne_speicher_16^
      :=register_tabelle_16[postbyte1_shr_3_and_7]^;

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_8a; (* MOV REG8,... *)
    begin
        register_tabelle_8[postbyte1_shr_3_and_7]^
      :=berechne_speicher_8_inhalt;

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_8b; (* MOV REG16,... *)
    begin
      if bytesuche(emu_puffer.d[0],#$8b#$e2#$54#$5b#$3b#$dc#$74#$46#$90#$90#$b9'??'#$bb'??'#$2e#$c6#$07#$00#$43) then
        begin
          emulationstoppen('TCEC / ThE CLERiC; MasterBall [?.??(e-prot.exe 1.0.4)]',packer_exe);
          Exit;
        end;

        register_tabelle_16[postbyte1_shr_3_and_7]^
      :=berechne_speicher_16_inhalt;

      Inc(_ip,2+zusatzlaenge_opcode);

    end;

  procedure opc_8c; (* code extension # 5 *)
    begin
      ziel_16   :=berechne_speicher_16;

      case postbyte1_shr_3_and_7 of
        0:ziel_16^:=_es;
        1:ziel_16^:=_cs;
        2:ziel_16^:=_ss;
        3:ziel_16^:=_ds;
     (* 4     FS
        5     GS
        6     ??
        7     ?? *)
      end;

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_8d; (* LEA REG16,... *)
    begin
      (* Quellmodus Zielregister Quelle *)
      register_tabelle_16[postbyte1_shr_3_and_7]^
        :=bestimme_quell_ofs;

      Inc(_ip,2+zusatzlaenge_opcode);

      if bytesuche(emu_puffer.d[0],#$8d#$9e'??'#$8d#$8e'??'#$2b#$cb#$2e#$8a#$07#$34) then
        begin
          case postword2 of
            $455:exezk:='1.05';
            $448:exezk:='1.09B';
          else
                 exezk:='1.?? ¯'
          end;
          ausschrift('PirateStop / Trills and Technologies ['+exezk+']',packer_exe);
          ansi_anzeige(analyseoff+codeoff_seg*16+$0b+_bp-3,
            #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,analyseoff+codeoff_seg*16+_ip,'');
          emulationstoppen('',signatur);
        end;
    end;

  procedure opc_8e; (* code extension # 6 *)
    begin
      if bytesuche(emu_puffer.d[0],#$8e#$e0#$bd'??'#$66#$c1#$e5#$10#$8b#$ec#$c7#$46#$02'??'#$f3#$9c) then
        begin
          emulationstoppen('FSE / Zenix Yang [0.6]',packer_exe);
        end;

      operand_16:=berechne_speicher_16_inhalt;

      case postbyte1_shr_3_and_7 of
        0:_es:=operand_16;
        1:_cs:=operand_16;
        2:_ss:=operand_16;
        3:_ds:=operand_16;
     (* 4     FS
        5     GS
        6     ??
        7     ?? *)
      end;

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_8f; (* code extension # 7 *)
    begin
      (* FSE 0.70: CS:16D5,16DE *)
      if bytesuche(emu_puffer.d[0],#$8f#$c3#$eb#$0b#$a1'??'#$02#$39) then
        emulationstoppen('FSE / Zenix Yang [0.7]',packer_exe);

      (* case postbyte1_shr_3_and_7 of
        0:*)pop_(berechne_speicher_16^);
      (* end; *)
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_90; (* NOP/XCHG AX,AX *)
    begin
      Inc(_ip);
    end;

  procedure opc_91; (* XGHG AX,CX *)
    begin
      tmp16:=_ax  ;
      _ax  :=_cx  ;
      _cx  :=tmp16;
      Inc(_ip);
    end;

  procedure opc_92; (* XCHG AX,DX *)
    begin
      tmp16:=_ax  ;
      _ax  :=_dx  ;
      _dx  :=tmp16;
      Inc(_ip);
    end;

  procedure opc_93; (* XCHG AX,BX *)
    begin
      tmp16:=_ax  ;
      _ax  :=_bx  ;
      _bx  :=tmp16;
      Inc(_ip);
    end;

  procedure opc_94; (* XCHG AX,SP *)
    begin
      tmp16:=_ax  ;
      _ax  :=_sp  ;
      _sp  :=tmp16;
      Inc(_ip);
    end;

  procedure opc_95; (* XCHG AX,BP *)
    begin
      tmp16:=_ax  ;
      _ax  :=_bp  ;
      _bp  :=tmp16;
      Inc(_ip);
    end;

  procedure opc_96; (* XCHG AX,SI *)
    begin
      tmp16:=_ax  ;
      _ax  :=_si  ;
      _si  :=tmp16;
      Inc(_ip);
    end;

  procedure opc_97; (* XCHG AX,DI *)
    begin
      tmp16:=_ax  ;
      _ax  :=_di  ;
      _di  :=tmp16;
      Inc(_ip);
    end;

  procedure opc_98; (* CBW *) (* z.B. FASTOPEN.COM / NWDOS 7 *)
    begin
      Inc(_ip);
      _ax:=word(integer(shortint(register_16(_ax).l)));
    end;

  procedure opc_99; (* CWD *)
    begin
      Inc(_ip);
      _dx:=word(longint(integer(_ax)) shl 16);
    end;

  procedure opc_9a; (* CALL FAR $xxxx:$xxxx *)
    begin
      Inc(_ip,5);
      push_(_cs);
      push_(_ip);
      _ip:=postword1;
      _cs:=postword3;

      (*$IfDef POEM_BIO*)
      (* XPack 1.67.n braucht fÅr den Hilfebildschirm viele Aufrufe *)
      if bytesuche(emu_puffer.d[0],#$9a#$00#$00'?'#$f4#$cb) then
        begin
          sprung_zaehler:=schritt;
          max_schritte:=400000;
        end;
      (*$EndIf POEM_BIO*)
    end;

  procedure opc_9b; (* (F)WAIT *)
    begin
      Inc(_ip);
    end;

  procedure opc_9c; (* PUSHF *)
    begin
      push_(_flags);
      Inc(_ip);
    end;

  procedure opc_9d; (* POPF *)
    begin
      pop_(_flags);
      Inc(_ip);
    end;

  procedure opc_9e; (* SAHF *)
    begin
      register_16(_flags).l:=register_16(_ax).h;
      Inc(_ip);
    end;

  procedure opc_9f; (* LAHF *)
    begin
      register_16(_ax).h:=register_16(_flags).l;
      Inc(_ip); (* FS6X86.EXE *)
    end;

  procedure opc_a0; (* MOV AL,[$xxxx] *)
    begin
        register_16(_ax).l
      :=lade_byte(ds_oder_ueberschreibung,postword1);
      Inc(_ip,3);
    end;

  procedure opc_a1; (* MOV AX,[$xxxx] *)
    begin
      _ax
      :=lade_word(ds_oder_ueberschreibung,postword1);
      Inc(_ip,3);
    end;

  procedure opc_a2; (* MOV [$xxxx],AL *)
    begin
      liefere_adresse_8(ds_oder_ueberschreibung,postword1)^
      :=register_16(_ax).l;
      Inc(_ip,3);
    end;

  procedure opc_a3; (* A3 XXXX MOV [XXXX],AX *) (* XGAVESA *)
    begin
      liefere_adresse_16(ds_oder_ueberschreibung,postword1)^
      :=_ax;
      Inc(_ip,3);
    end;

  procedure opc_a4; (* MOVSB *)
    begin
      liefere_adresse_8(_es,_di)^:=
        lade_byte(_ds,_si);
      Inc(_si,richtungsflag_wert);
      Inc(_di,richtungsflag_wert);
      Inc(_ip);
    end;

  procedure opc_a5; (* MOVSW *)
    begin
      Inc(_ip);

      liefere_adresse_16(_es,_di)^:=
        lade_word(_ds,_si);
      Inc(_si,richtungsflag_wert*2);
      Inc(_di,richtungsflag_wert*2);
    end;

  procedure opc_a6; (* CMPSB *)
    begin
      cmp_8(lade_byte(ds_oder_ueberschreibung,_si),lade_byte(_es,_di));
      Inc(_si,richtungsflag_wert);
      Inc(_di,richtungsflag_wert);
      Inc(_ip);
    end;

  procedure opc_a7; (* CMPSW *)
    begin
      cmp_8(lade_byte(ds_oder_ueberschreibung,_si),lade_byte(_es,_di));
      Inc(_si,richtungsflag_wert*2);
      Inc(_di,richtungsflag_wert*2);
      Inc(_ip);
    end;

  procedure opc_a8; (* TEST AL,$xx *)
    begin
      test_8(register_16(_ax).l,postbyte1);
      Inc(_ip,2);
    end;

  procedure opc_a9; (* TEST AX,$xxxx *)
    begin
      test_16(_ax,postword1);
      Inc(_ip,3);
    end;

  procedure opc_aa; (* STOSB *)
    begin
      liefere_adresse_8(_es,_di)^:=
        register_16(_ax).l;
      Inc(_di,richtungsflag_wert);
      Inc(_ip);
    end;

  procedure opc_ab; (* STOSW *)
    begin
      liefere_adresse_16(_es,_di)^:=
        _ax;
      Inc(_di,richtungsflag_wert*2);
      Inc(_ip);
    end;

  procedure opc_ac; (* LODSB *)
    begin
      register_16(_ax).l:=
        lade_byte(ds_oder_ueberschreibung,_si);
      Inc(_si,richtungsflag_wert);
      Inc(_ip);
    end;

  procedure opc_ad; (* LODSW *)
    begin
      _ax:=
        lade_word(ds_oder_ueberschreibung,_si);
      Inc(_si,richtungsflag_wert*2);
      Inc(_ip);
    end;

  procedure opc_ae; (* SCASB *)
    begin
      cmp_8(
        register_16(_ax).l,
        lade_byte(_es,_di));
      Inc(_di,richtungsflag_wert);
      Inc(_ip);
    end;

  procedure opc_af; (* SCASW *)
    begin
      cmp_16(
        _ax,
        lade_word(_es,_di));
      Inc(_di,richtungsflag_wert*2);
      Inc(_ip);
    end;

  procedure opc_b0_b7; (* b0..$b7: *)
       (* B1 0XX  MOV CL,0XX *)
       (* B3 0XX  MOV BL,0XX *)
       (* B4 0XX  MOV AH,0XX *)
       (* B6 0XX  MOV DH,0XX *)
       (* B7 0XX  MOV BH,0XX *)
    begin
      register_tabelle_8[emu_puffer.d[0]-$b0]^:=postbyte1;
      Inc(_ip,2);

      if bytesuche(emu_puffer.d,#$b0#$ad#$e6#$64#$e8#$00#$00#$5d#$81#$ed'??'#$9c) then
        begin
          emulationstoppen('DS-CRP / Dark Stalker [1.31]',packer_exe);
        end;
    end;

  procedure opc_b8_bf; (* b8..$bf: MOV REG16,$xxxx *)
    var
      w1:word;
      version_puffer:puffertyp;
    begin
      Inc(_ip,3);

      if cybershadow=5 then
        if bytesuche(emu_puffer.d[0],#$bf#$00#$01) then
          Inc(cybershadow);

      if cybershadow=6 then
        if bytesuche(emu_puffer.d[0],#$be#$05#$01) then
          (* 2000.12.15 *)
          emulationstoppen('Com file cryptor / CyberShadow//SMF',packer_exe);

      if bytesuche(emu_puffer.d[0],#$b8#$eb#$02#$eb#$fc#$50#$e4#$15#$0c#$02#$e6#$15#$66#$67#$90#$66) then
        (* e-prot hat einen Fehler in der ersten Entschluesselungsschicht
           wenn die LÑnge der Quelldatei nicht ein Vielfaches von 16 ist *)
        emulationstoppen('E-Prot 386+ / MasterBall Systems [1.0· .EXE]',packer_exe);

      if bytesuche(emu_puffer.d[0],#$b9#$ff#$ff#$83#$c4#$04#$f3#$26#$ac#$e3#$02#$eb#$0c
        +#$b8#$00#$70#$50#$9d#$9c#$58#$25#$00#$70#$75#$02#$cd#$20) then
        (* MESS Ñhnlich *)
        emulationstoppen('E-Prot 386+ / MasterBall Systems [1.0.3 .EXE]',packer_exe);

      (* es dauert lange bis diese Stelle erreicht wird, besonders bei
         mehrfacher HÅlle um das Hauptmodul *)
      if bytesuche(emu_puffer.d[0],#$b8'??'#$bf'??'#$2d#$62#$8a#$8b#$d0#$b9'??'#$96#$fd) then
        emulationstoppen('PC-Guard / Blagoje Ceklic [3.05,3.10,3.20]',packer_exe);


      if bytesuche(emu_puffer.d[0],#$bf#$14#$00#$90#$f8#$13#$fe#$f8#$66#$ba'??'#$00#$00#$eb#$0d) then
        (* EXELISTE 1999.06.05 TCEC *)
        ausschrift('Guerilla.1996',virus);

      if bytesuche(emu_puffer.d[0],#$ba'??'#$b8#$00#$70#$50#$9d#$9c#$58#$25#$00#$70#$74'?'#$db#$e3) then
        begin
          ausschrift('iLUCRYPT / Christian Schwarz',packer_exe);
          w1:=postword1;
          while lade_byte(_cs,w1)<>ord('[') do Dec(w1);
          lies_emu(version_puffer,255,_cs,w1);
          emulationstoppen(puffer_zu_zk_e(version_puffer.d[1],' -',80),beschreibung);
        end;

        register_tabelle_16[emu_puffer.d[0]-$b8]^
      :=postword1;

      (* neu lesen weil Suchfolge lÑnger ist *)
      (* dec ip,lies_emu_puffer(512); *)
      if bytesuche(emu_puffer.d[0],#$b8#$00#$03#$b7#$00#$cd#$10#$89#$4e#$2a#$89#$56#$2c
          +#$c6#$46'?O'#$c6#$46'?K'#$c6#$46'?$') then
        begin
          award_flash_writer;
          emulationstoppen('',signatur);
        end;

      (* FOOLTEU.EXE: AH=05 *)
      if emu_puffer.d[2]=$05 then
        unbekannt1_zaehler:=unbekannt1_zaehler or bit05;

      if  (schritt<7)
      and pacific_cld_gefunden
      {and bytesuche(emu_puffer.d[0],#$b8'??'#$8e#$d0)}
       then
        begin
          lies_emu(version_puffer,512,postword1,0);
          w1:=puffer_pos_suche(version_puffer,'C Lib',512);
          if w1<>nicht_gefunden then
            begin
              emulationstoppen('Pacific C / Hi-Tech Software',compiler);
              ausschrift(puffer_zu_zk_e(version_puffer.d[w1],#0,80),beschreibung);
            end;
        end;

      if bytesuche(emu_puffer.d[0],#$ba#$21#$00) then
        unbekannt1_zaehler:=unbekannt1_zaehler or bit00;


    end;

  procedure opc_c0; (* code extension # 8 *)
    begin
      ziel_8:=berechne_speicher_8;
      operand_8:=emu_puffer.d[2+zusatzlaenge_opcode];

      case postbyte1_shr_3_and_7 of
        0:rol_8(ziel_8^,operand_8);
        1:ror_8(ziel_8^,operand_8);
        2:rcl_8(ziel_8^,operand_8);
        3:rcr_8(ziel_8^,operand_8);
        4:shl_8(ziel_8^,operand_8);
        5:shr_8(ziel_8^,operand_8);
        6:sal_8(ziel_8^,operand_8);
        7:sar_8(ziel_8^,operand_8);
      end;

      Inc(_ip,3+zusatzlaenge_opcode);
    end;

  procedure opc_c1; (* code extension # 9 *)
    begin
      ziel_16:=berechne_speicher_16;
      operand_8:=emu_puffer.d[2+zusatzlaenge_opcode];

      case postbyte1_shr_3_and_7 of
        0:rol_16(ziel_16^,operand_8);
        1:ror_16(ziel_16^,operand_8);
        2:rcl_16(ziel_16^,operand_8);
        3:rcr_16(ziel_16^,operand_8);
        4:shl_16(ziel_16^,operand_8);
        5:shr_16(ziel_16^,operand_8);
        6:sal_16(ziel_16^,operand_8);
        7:sar_16(ziel_16^,operand_8);
      end;

      Inc(_ip,3+zusatzlaenge_opcode);
    end;

  procedure opc_c2; (* RET $xxxx *)
    begin
      (* Inc(_ip,3) *)
      pop_(_ip);
      Inc(_sp,postword1);
    end;

  procedure opc_c3; (* RET *)
    begin
      pop_(_ip);
    end;

  procedure opc_c4; (* LES REG16,... *)
    begin
      if not berechne_speicher_32_inhalt then
        int_aufrufen($06) (* invalid opcode *)
      else
        begin
          register_tabelle_16[postbyte1_shr_3_and_7]^:=r32.w0;
          _es                                        :=r32.w1;
          Inc(_ip,2+zusatzlaenge_opcode);
        end;
    end;

  procedure opc_c5; (* LDS REG16,... *)
    begin
      if not berechne_speicher_32_inhalt then
        int_aufrufen($06) (* invalid opcode *)
      else
        begin
          register_tabelle_16[postbyte1_shr_3_and_7]^:=r32.w0;
          _ds                                        :=r32.w1;
          Inc(_ip,2+zusatzlaenge_opcode);
        end;
    end;

  procedure opc_c6; (* code extension # 10 *)
    begin
      (* postbyte1_shr_3_and_7=0 *)

      (* MOV B ...,$xx *)
      berechne_speicher_8^:=
        emu_puffer.d[2+zusatzlaenge_opcode];
      Inc(_ip,3+zusatzlaenge_opcode);

      if bytesuche(emu_puffer.d[0],#$c6#$46'?O'#$c6#$46'?K'#$c6#$46'?$') then
        (* C6 46 64 FF MOV BYTE [BP+064],0FF *) (* AWDFLASH.EXE *)
        (* C6 46 ?? 'O' .. *)
        begin
          award_flash_writer;
          emulationstoppen('',signatur);
          exit;
        end;

      if bytesuche(emu_puffer.d[0],#$c6#$04#$98#$46#$49#$75#$f9#$fa) then
        begin
          ausschrift('PMUTARE / PReDaToR 666 [1.1]',packer_exe);
          (* lies_emu_puffer(512);
          ausschrift(puffer_zu_zk_e(emu_puffer.d[$11a-3],#$0d,255),beschreibung); *)
          emulationstoppen('',signatur);
          (* exit *)
        end;

    end;

  procedure opc_c7; (* code extension # 11 *)
    begin
      (* postbyte1_shr_3_and_7=0 *)

      (* MOV W ...,$xxxx *)
      berechne_speicher_16^:=
        word_z(@emu_puffer.d[2+zusatzlaenge_opcode])^;
      Inc(_ip,4+zusatzlaenge_opcode);
    end;

  procedure opc_c8; (* ENTER $xxxx,$xx *)
    var
      verschachtelung   :word_norm;
      temp_sp           :smallword;
    begin
      Inc(_ip,4);
      push_(_bp);
      temp_sp:=_sp;
      for verschachtelung:=emu_puffer.d[3] downto 1 do
        begin
          Dec(_bp,2);
          push_(lade_word(_ss{_oder_ueberschreibung},_bp));
        end;
      _bp:=temp_sp;
      Dec(_sp,postword1);
    end;

  procedure opc_c9; (* LEAVE *)
    begin
      Inc(_ip);
      _sp:=_bp;
      pop_(_bp);
    end;

  procedure opc_ca; (* RET FAR IMM *)
    begin
      (* Inc(_ip); *)
      pop_(_ip);
      pop_(_cs);
      Inc(_sp,postword1);
    end;

  procedure opc_cb; (* RET FAR *)
    begin
      (* ET4000.DRV,.. aus QPV *)
      (* RÅcksprung (Treiber) *)
      if exe and (_sp=org_sp) and (_ss=org_ss) then
        emulationstoppen('',signatur);
      pop_(_ip);
      pop_(_cs);
    end;

  procedure opc_cc; (* INT $3 *)
    begin
      Inc(_ip);

      if  (_si=Ord('F') shl 8 + Ord('G'))
      and (_di=Ord('J') shl 8 + Ord('M'))
       then
        begin
          if _ax=$0911 then
            begin
              exezk:=' "'+emu_zu_zk_e(_ds,_dx,#0);
              if exezk[Length(exezk)]=#$0d then
                Dec(exezk[0]);
              exezk_anhaengen('"');
            end
          else
            exezk:='';
          if softice_zaehler<10 then
            ausschrift('SoftICE back door!'+exezk,signatur);
          Inc(softice_zaehler);
        end;

      int_aufrufen($03);
    end;




  procedure opc_cd; (* INT $xx *)
    begin
      if (postbyte1=$21) and (_ax=$fe02)
      and (not bytesuche(emu_puffer.d[0],#$cd#$21#$80#$fc#$00)) (* LOCKKING 2.0? KINST.EXE, RUN.DAT *)
       then
        emulationstoppen('Tequila',virus); (* mit .2468.a getestet *)

      Inc(_ip,2);
      int_aufrufen(postbyte1);
    end;

  procedure opc_ce; (* INTO *) (* FSE.EXE *)
    begin
      Inc(_ip);
      (* FSE06P ruft INTO mit O-Flag=1 auf
      if (_flags and flags_overflow)<>0 then
        emulationstoppen('INTO',signatur);*) (* INT 4 *)

      (*$IfDef POEM_BIO*)
      if (_flags and flags_overflow)<>0 then
        int_aufrufen($04);
      (*$EndIf POEM_BIO*)
    end;

  procedure opc_cf; (* IRET *)
    begin
      pop_(_ip);
      pop_(_cs);
      pop_(_flags);
    end;

  procedure opc_d0; (* code extension # 12 *)
    begin
      ziel_8:=berechne_speicher_8;

      case postbyte1_shr_3_and_7 of
        0:rol_8(ziel_8^,1);
        1:ror_8(ziel_8^,1);
        2:rcl_8(ziel_8^,1);
        3:rcr_8(ziel_8^,1);
        4:shl_8(ziel_8^,1);
        5:shr_8(ziel_8^,1);
        6:sal_8(ziel_8^,1);
        7:sar_8(ziel_8^,1);
      end;

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_d1; (* code extension # 13 *)
    begin
      ziel_16:=berechne_speicher_16;

      case postbyte1_shr_3_and_7 of
        0:rol_16(ziel_16^,1);
        1:ror_16(ziel_16^,1);
        2:rcl_16(ziel_16^,1);
        3:rcr_16(ziel_16^,1);
        4:shl_16(ziel_16^,1);
        5:shr_16(ziel_16^,1);
        6:sal_16(ziel_16^,1);
        7:sar_16(ziel_16^,1);
      end;

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_d2; (* code extension # 14 *)
    begin
      ziel_8:=berechne_speicher_8;

      case postbyte1_shr_3_and_7 of
        0:rol_8(ziel_8^,register_16(_cx).l);
        1:ror_8(ziel_8^,register_16(_cx).l);
        2:rcl_8(ziel_8^,register_16(_cx).l);
        3:rcr_8(ziel_8^,register_16(_cx).l);
        4:shl_8(ziel_8^,register_16(_cx).l);
        5:shr_8(ziel_8^,register_16(_cx).l);
        6:sal_8(ziel_8^,register_16(_cx).l);
        7:sar_8(ziel_8^,register_16(_cx).l);
      end;

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_d3; (* code extension # 15 *)
    begin
      ziel_16:=berechne_speicher_16;

      case postbyte1_shr_3_and_7 of
        0:rol_16(ziel_16^,register_16(_cx).l);
        1:ror_16(ziel_16^,register_16(_cx).l);
        2:rcl_16(ziel_16^,register_16(_cx).l);
        3:rcr_16(ziel_16^,register_16(_cx).l);
        4:shl_16(ziel_16^,register_16(_cx).l);
        5:shr_16(ziel_16^,register_16(_cx).l);
        6:sal_16(ziel_16^,register_16(_cx).l);
        7:sar_16(ziel_16^,register_16(_cx).l);
      end;

      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_d4; (* AAM $xx *)
    begin
      Inc(_ip,2);
      if postbyte1=0 then postbyte1:=1; (* division durch 0? *)
      asm
        call setze_zu_emulierende_flags
        mov ax,[_ax]
        mov ah,0
        mov cl,postbyte1
        div cl
        xchg al,ah
        cmp ax,0
        mov [_ax],ax
        call sichere_zu_emulierende_flags
      end;
    end;

  procedure opc_d5; (* AAD $xx *)
    begin
      Inc(_ip,2);
      asm
        call setze_zu_emulierende_flags
        mov ax,[_ax]
        mov cl,al
        shr ax,8
        mul [postbyte1]
        mov ah,0
        add al,cl
        mov [_ax],ax
        call sichere_zu_emulierende_flags
      end;
    end;

  (* $d6: SETALC *)

  procedure opc_d7; (* XLAT *)
    begin
      register_16(_ax).l:=lade_byte(_ds,_bx+register_16(_ax).l);
      Inc(_ip);
    end;

  (* $d8..$df: Koprozessor *)

  procedure opc_e0; (* LOOPNZ +$xx *)
    begin
      Inc(_ip,2);
      Dec(_cx);
      if  (_cx<>0)
      and ((_flags and flags_zero)=0) (* zero flag clear *)
       then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_e1; (* LOOPZ +$xx *)
    begin
      Inc(_ip,2);
      Dec(_cx);
      if  (_cx<>0)
      and ((_flags and flags_zero)<>0) (* zero flag set *)
       then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_e2; (* LOOP +$xx * TRAP 1.22 *)
    begin
      Inc(_ip,2);
      Dec(_cx);
      if _cx<>0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_e3; (* JCXZ *)
    begin
      Inc(_ip,2);
      if _cx=0 then
        Inc(_ip,shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure cscrypt(const segm,offs:word);
    var
      version_puffer:puffertyp;
    begin
      ausschrift('CSCRYPT / Christian Schwarz',packer_exe);
      lies_emu(version_puffer,260,segm,offs);
      ausschrift(puffer_zu_zk_e(version_puffer.d[2],']',80),beschreibung);
    end;

  procedure opc_e4; (* IN AL,$xx *)
    begin
      if bytesuche(emu_puffer.d[0],#$e4#$21#$50#$b0#$ff#$e6#$21#$fa#$8d#$96'??'#$87#$d4#$bb'??'#$b9) then
        cscrypt(_cs,_bp); (* COM *)
      if bytesuche(emu_puffer.d[0],#$e4#$21#$50#$b0#$ff#$e6#$21#$fa#$8b#$d4#$bc'??'#$bb'??'#$b9) then
        cscrypt(_cs,  1); (* EXE *)
      Inc(_ip,2);
      if postbyte1=$21 then (* IN AL,021 *)
        unbekannt1_zaehler:=unbekannt1_zaehler or bit02 or bit00;
      register_16(_ax).l:=random($ff);
    end;

  procedure opc_e5; (* IN AX,$xx *)
    begin
      Inc(_ip,2);
      _ax:=random($ffff);
    end;

  procedure opc_e6; (* OUT $xx,AL *)
    begin
      Inc(_ip,2);
      if postbyte1=$21 then (* OUT 021,AL *)
        unbekannt1_zaehler:=unbekannt1_zaehler or bit03;
    end;

  procedure opc_e7; (* OUT $xx,AX *)
    begin
      Inc(_ip,2);
    end;

  procedure opc_e8; (* CALL XXXX *)
    begin
      Inc(_ip,3);
      push_(_ip);
      Inc(_ip,postword1);

      (* Start des nicht polymorphen Programmbereiches *)
      if postword1=0 then
        begin

          if bytesuche(emu_puffer.d[0],#$e8#$00#$00#$5d#$81#$ed#$98#$04#$53#$bb#$eb#$04#$5b#$eb#$fb#$9a#$89#$ae#$84#$07
                                      +#$e9#$73#$01#$52#$ba) then (* BC 1.120 *)
            emulationstoppen('bANZAi-cRYPt / Valmii^tKD [1.x]',packer_exe);

          (*if bytesuche(emu_puffer.d[0],#$e8#$00#$00#$58#$1e#$57#$04#$0c#$bf'??'#$5f#$eb#$fb) then
            emulationstoppen('IRoNtHoRN / ReDragon [1.0]',packer_exe);*)

          if bytesuche(emu_puffer.d[0],#$e8#$00#$00#$59#$fa#$8b#$dc#$36#$c7#$47#$fe#$ff#$ff#$36#$83
            +#$7f#$fe#$ff#$75#$fe#$fb) then
            emulationstoppen('DEEPER / ? <FS_TOOLS.ZIP #2> [1.0c]',packer_exe);

          if bytesuche(emu_puffer.d[0],#$e8#$00#$00#$33#$c0#$5d#$8e#$d8) then
            emulationstoppen('Protect! / Jeremy Lilley [5.5]',packer_exe);

          if bytesuche(emu_puffer.d[0],#$e8#$00#$00#$5e#$83#$c6#$08#$c6#$04#$fe#$eb#$00#$06#$b8) then
            (* TPE 1.4! *)
            emulationstoppen('CRuNCH / Luck [1.4]',packer_exe);

        end;

    end;

  procedure opc_e9; (* JMP *)
    begin
      Inc(_ip,3+postword1);
      Inc(sprung_zaehler);
    end;

  procedure opc_ea; (* JMP FAR $xxxx:$xxxx *)
    begin
      _ip:=postword1;
      _cs:=postword3;
    end;

  procedure opc_eb; (* JMPS *)
    begin
      if bytesuche(emu_puffer.d[0],#$eb#$09#$e8#$00#$00#$5d#$81#$ed#$50#$01#$c3#$eb#$02#$f4#$eb#$e8) then
        begin
          emulationstoppen('TCEC / ThE CLERiC; MasterBall [3.60·]',packer_exe);
          Exit;
        end;

      Inc(_ip,2+shortint(postbyte1));
      Inc(sprung_zaehler);
    end;

  procedure opc_ec; (* IN AL,DX *)
    begin
      Inc(_ip);
      unbekannt1_zaehler:=unbekannt1_zaehler or bit02;

      (* CD-Treiber: keine Festplatte/kein CD-Laufwerk vorhanden *)
      case _dx of
        $170..$177,
        $1f0..$1f7,
        $370..$377,
        $3f0..$3f7:
          begin
            (* ausschrift('Festplattenport!',signatur);*)
            register_16(_ax).l:=$ff;
            (*$IfDef DOS*)
            schritt_beschraenkung(400);
            (*$Else DOS*)
            schritt_beschraenkung(40000);
            (*$EndIf DOS*)
          end;
      else
        register_16(_ax).l:=random($ff);
      end;
    end;

  procedure opc_ed; (* IN AX,DX *)
    begin
      Inc(_ip);
      _ax:=random($ffff);
    end;

  procedure opc_ee; (* OUT DX,AL *)
    begin
      Inc(_ip);
      unbekannt1_zaehler:=unbekannt1_zaehler or bit03;
    end;

  procedure opc_ef; (* OUT DX,AX *)
    begin
      Inc(_ip);
    end;

  procedure opc_f0; (* LOCK: *)
    begin
      Inc(_ip);
    end;

  procedure opc_f1; (* SMI *)
    begin
      Inc(_ip);
    end;

  procedure repx_movsb;
    begin
      Inc(_ip,2);

      (*$IfDef DOS_ODER_DPMI*)
      if _cx>High(speicher_bereichs_tabelle)*speicher_bereichs_laenge  then
        begin
          emulationstoppen_kein_hersteller(textz_speichermangel^,signatur);
          exit;
        end;
      (*$EndIf DOS_ODER_DPMI*)

      (* deutet nicht auf polymorphen Code hin -> schneller beenden *)
      if _cx>500 then
        (*$IfDef DOS*)
        schritt_beschraenkung(400);
        (*$Else DOS*)
        schritt_beschraenkung(40000);
        (*$EndIf DOS*)

      while _cx<>0 do
        begin
          liefere_adresse_8(_es,_di)^:=
            lade_byte(ds_oder_ueberschreibung,_si);
          Inc(_si,richtungsflag_wert);
          Inc(_di,richtungsflag_wert);
          Dec(_cx);
          if emulation_stoppen then break;
        end;
    end;

  procedure repx_movsw;
    begin
      Inc(_ip,2);

      (*$IfDef DOS_ODER_DPMI*)
      if _cx>High(speicher_bereichs_tabelle)*speicher_bereichs_laenge div 2 then
        begin
          emulationstoppen_kein_hersteller(textz_speichermangel^,signatur);
          exit;
        end;
      (*$EndIf DOS_ODER_DPMI*)

      (* deutet nicht auf polymorphen Code hin -> schneller beenden *)
      if _cx>500 then
        (*$IfDef DOS*)
        schritt_beschraenkung(400);
        (*$Else DOS*)
        schritt_beschraenkung(40000);
        (*$EndIf DOS*)

      while _cx<>0 do
        begin
          liefere_adresse_16(_es,_di)^:=
            lade_word(ds_oder_ueberschreibung,_si);
          Inc(_si,richtungsflag_wert*2);
          Inc(_di,richtungsflag_wert*2);
          Dec(_cx);
          if emulation_stoppen then break;
        end;
    end;

  procedure repx_stosw;
    begin
      Inc(_ip,2);
      while _cx<>0 do
        begin
          liefere_adresse_16(_es,_di)^:=
            _ax;
          Inc(_di,richtungsflag_wert*2);
          Dec(_cx);
          if emulation_stoppen then break;
        end;
    end;

  procedure repx_stosb;
    begin
      Inc(_ip,2);
      while _cx<>0 do
        begin
          liefere_adresse_8(_es,_di)^:=
            register_16(_ax).l;
          Inc(_di,richtungsflag_wert);
          Dec(_cx);
          if emulation_stoppen then break;
        end;
    end;

  procedure opc_f2; (* REPNZ *) (* CATAPILAR Virus: F2 A4 REPNZ MOVSB *)
    begin
      case postbyte1 of
        $a4:repx_movsb;(* REPNZ MOVSB *)
        $a5:repx_movsw;(* REPNZ MOVSW *)
        $aa:repx_stosb;(* REPNZ STOSB *)
        $ab:repx_stosw;(* REPNZ STOSW *)
        $ae: (* REPNE SCASB *)
          begin
            Inc(_ip,2);
            while _cx<>0 do
              begin
                cmp_8(
                  register_16(_ax).l,
                  lade_byte(_es,_di));
                Inc(_di,richtungsflag_wert);
                Dec(_cx);
                if ((_flags and flags_zero)<>0)
                or emulation_stoppen
                 then break;
              end;
          end;
      else
        emulationstoppen('',signatur); (* unbekanntes REP xx *)
      end;
    end;

  procedure opc_f3; (* F3 A5: REPZ MOVSW *)
    begin
      case postbyte1 of
        $a4:repx_movsb;(* REPZ MOVSB *)
        $a5:repx_movsw;(* REPZ MOVSW *)
        $a6:           (* REPZ CMPSB *)
          begin
            Inc(_ip,2);
            while _cx<>0 do
              begin
                cmp_8(lade_byte(ds_oder_ueberschreibung,_si),lade_byte(_es,_di));
                Inc(_si,richtungsflag_wert);
                Inc(_di,richtungsflag_wert);
                Dec(_cx);
                if ((_flags and flags_zero)=0)
                or emulation_stoppen
                 then break;
              end;
          end;
        $a7:           (* REPZ CMPSW: KILL.EXE (PCTOOLS?) *)
          begin
            Inc(_ip,2);
            while _cx<>0 do
              begin
                cmp_16(lade_word(ds_oder_ueberschreibung,_si),lade_word(_es,_di));
                Inc(_si,2*richtungsflag_wert);
                Inc(_di,2*richtungsflag_wert);
                Dec(_cx);
                if ((_flags and flags_zero)=0)
                or emulation_stoppen
                 then break;
              end;
          end;
        $aa:repx_stosb;(* REPZ STOSB *)
        $ab:repx_stosw;(* REPZ STOSW *)
        $ae:           (* REPZ SCASB *) (* VSP1173\INFECTME.COM *)
          begin
            Inc(_ip,2);
            while _cx<>0 do
              begin
                cmp_8(register_16(_ax).l,lade_byte(_es,_di));
                Inc(_si,richtungsflag_wert);
                Inc(_di,richtungsflag_wert);
                Dec(_cx);
                if ((_flags and flags_zero)=0)
                or emulation_stoppen
                 then break;
              end;
          end;
      else
        emulationstoppen('',signatur); (* unbekanntes REP xx *)
      end;
    end;

  procedure opc_f4; (* HLT *)
    begin
      Inc(_ip);
      if bytesuche(emu_puffer.d[0],#$f4#$02#$fd) and (_ax=0) then
        begin
          emulationstoppen(textz_OS2_Virtuelle_Maschine_beenden^,signatur);
        end
      else
        if not _flags_interrupt then (* in vielen VCL-verschlÅsselten Viren *)
          emulationstoppen('',signatur);
    end;

  procedure opc_f5; (* CMC *)
    begin
      _flags:=_flags xor flags_carry;
      Inc(_ip);
    end;

  procedure opc_f6; (* code extension # 16 *)
    begin
      ziel_8:=berechne_speicher_8;

      case postbyte1_shr_3_and_7 of
        0,
        1:test_8(ziel_8^,emu_puffer.d[2+zusatzlaenge_opcode]);
        2: not_8(ziel_8^);
        3: neg_8(ziel_8^);
        4: mul_8(ziel_8^);
        5:imul_8(ziel_8^);
        6:if not div_8(ziel_8^) then
            begin
              int_aufrufen($00);
              exit; (* ip unverÑndert *)
            end;
        7:if not idiv_8(ziel_8^) then
            begin
              int_aufrufen($00);
              exit; (* ip unverÑndert *)
            end;
      end;

      Inc(_ip,2+zusatzlaenge_opcode);
      if (postbyte1_shr_3_and_7) in [0,1] then
        Inc(_ip);
    end;

  procedure opc_f7; (* code extension # 17 *)
    begin
      ziel_16:=berechne_speicher_16;

      case postbyte1_shr_3_and_7 of
        0,
        1:test_16(ziel_16^,word_z(@emu_puffer.d[2+zusatzlaenge_opcode])^);
        2: not_16(ziel_16^);
        3: neg_16(ziel_16^);
        4: mul_16(ziel_16^);
        5:imul_16(ziel_16^);
        6:if not div_16(ziel_16^) then
            begin
              int_aufrufen($00);
              exit; (* ip unverÑndert *)
            end;
        7:if not idiv_16(ziel_16^) then
            begin
              int_aufrufen($00);
              exit; (* ip unverÑndert *)
            end;
      end;

      Inc(_ip,2+zusatzlaenge_opcode);
      if (postbyte1_shr_3_and_7) in [0,1] then
        Inc(_ip,2);

    end;

  procedure opc_f8; (* CLC *)
    begin
      _flags:=_flags and (not flags_carry);
      Inc(_ip);
    end;

  procedure opc_f9; (* STC *)
    begin
      _flags:=_flags or flags_carry;
      Inc(_ip);
    end;

  procedure opc_fa; (* CLI *)
    begin
      (* FSE 0.76 *)
      if bytesuche(emu_puffer.d[0],#$fa#$b0#$ff#$e6#$21#$eb#$00#$b0#$11#$e6#$20#$eb#$00#$b0#$08#$e6#$21#$eb#$00) then
        emulationstoppen('FSE / Zenix Yang [0.76]',packer_exe);

      Inc(_ip);
      _flags_interrupt:=false;
    end;

  procedure opc_fb; (* STI *)
    begin
      Inc(_ip);
      _flags_interrupt:=true;

      if bytesuche(emu_puffer.d[0],#$fb#$b8#$06#$33#$cd#$21#$8b#$eb#$50#$58#$4c#$4c#$5b#$33#$c3) then
        begin
          emulationstoppen('X3 / MANtiC0RE [1.4]',packer_exe);
          anzeige_sdw_reg;
        end;

    end;

  procedure opc_fc; (* CLD *)
    begin
      _flags:=_flags and (not  flags_direction);
      Inc(_ip);

      if bytesuche(emu_puffer.d[0],#$fc#$33#$c9#$ba#$64#$00#$50#$58#$4c#$4c#$5b#$33#$c3#$74#$02#$cd#$20#$fb#$b0'?'#$2e) then
        begin
          emulationstoppen('X3 / MANtiC0RE [1.3]',packer_exe);
          Exit;
        end;


      (*lies_emu_puffer(512); *)
      if bytesuche(emu_puffer.d[0],#$fc#$55#$fa#$8b#$ec#$c7#$46#$fe#$00#$00) then
        begin
          emulationstoppen('RSCC / Ralph Roth [1.01]',packer_exe);
          rscc_endekennung;
          Exit;
        end;

      if puffer_pos_suche(emu_puffer,#$fc#$55#$fa#$8b#$ec#$8b#$46#$fe#$50#$c7,512)<>nicht_gefunden then
        begin
          emulationstoppen('RSCC / Ralph Roth [1.03/4]',packer_exe);
          rscc_endekennung;
          Exit;
        end;

      if bytesuche(emu_puffer.d[0],#$fc#$50#$58#$4c#$4c#$5b#$33#$c3#$74#$02#$cd#$20#$b8#$06#$33) then
        begin
          emulationstoppen('x3 / MANtiC0RE [1.3]',packer_exe);
          exit;
        end;

      if schritt<=1 then
        pacific_cld_gefunden:=true;
    end;

  procedure opc_fd; (* STD *) (* FOOLTEU.EXE: *)
    begin
      _flags:=_flags or flags_direction;
      Inc(_ip);
    end;

  procedure opc_fe; (* code extension # 18 *)
    begin
      (* INC/DEC (CS:/ES:/) BYTE [x] ; x etwa aktuelles _ip *)
      if  (schritt<100)
      and (postbyte1 in [$06,$0e])
      and (_ip<=postword2+4) and (postword2<=_ip+4) (* bei PROTEXCM.EXE _IP=3 (3-4=$ffff) *)
       then
        protect55:=protect55 or protect55_selbstmodifikation;

      ziel_8:=berechne_speicher_8;
      case postbyte1_shr_3_and_7 of
        0:inc_8(ziel_8^);
        1:dec_8(ziel_8^);
      (*2..7 *)
      end;
      Inc(_ip,2+zusatzlaenge_opcode);
    end;

  procedure opc_ff; (* code extension # 19 *)
    begin
      ziel_16:=berechne_speicher_16;
      Inc(_ip,2+zusatzlaenge_opcode);
      case postbyte1_shr_3_and_7 of
        0:inc_16(ziel_16^);                       (* INC  W [...] *)
        1:dec_16(ziel_16^);                       (* DEC  W [...] *)
        2:                                        (* CALL W [...] *)
          begin
            push_(_ip);
            _ip:=berechne_speicher_16_inhalt;
          end;
        3:                                        (* CALL D [...] *)
          begin
            if not berechne_speicher_32_inhalt then
              begin
                Dec(_ip,2+zusatzlaenge_opcode);
                int_aufrufen($06); (* invalid opcode *)
              end
            else
              begin
                push_(_cs);
                push_(_ip);
                _ip:=r32.w0;
                _cs:=r32.w1;
              end;
          end;
        4:_ip:=berechne_speicher_16_inhalt;       (* JMP  W [...] *) (* JMP AX/../DI *)
        5:                                        (* JMP  D [...] *)
          begin
            if not berechne_speicher_32_inhalt then
              begin
                Dec(_ip,2+zusatzlaenge_opcode);
                int_aufrufen($06); (* invalid opcode *)
              end
            else
              begin
                _ip:=r32.w0;
                _cs:=r32.w1;
              end;
          end;
        6:push_(berechne_speicher_16_inhalt);     (* PUSH D [...] *)
        7:emulationstoppen('',signatur);          (* $ffff....    *)
      end;
    end;



  const
    opc_tab:array[0..255] of word_norm=
      (Ofs(opc_00),
       Ofs(opc_01),
       Ofs(opc_02),
       Ofs(opc_03),
       Ofs(opc_04),
       Ofs(opc_05),
       Ofs(opc_06),
       Ofs(opc_07),
       Ofs(opc_08),
       Ofs(opc_09),
       Ofs(opc_0a),
       Ofs(opc_0b),
       Ofs(opc_0c),
       Ofs(opc_0d),
       Ofs(opc_0e),
       Ofs(opc_0f),
       Ofs(opc_10),
       Ofs(opc_11),
       Ofs(opc_12),
       Ofs(opc_13),
       Ofs(opc_14),
       Ofs(opc_15),
       Ofs(opc_16),
       Ofs(opc_17),
       Ofs(opc_18),
       Ofs(opc_19),
       Ofs(opc_1a),
       Ofs(opc_1b),
       Ofs(opc_1c),
       Ofs(opc_1d),
       Ofs(opc_1e),
       Ofs(opc_1f),
       Ofs(opc_20),
       Ofs(opc_21),
       Ofs(opc_22),
       Ofs(opc_23),
       Ofs(opc_24),
       Ofs(opc_25),
       Ofs(opc_26),
       Ofs(opc_27),
       Ofs(opc_28),
       Ofs(opc_29),
       Ofs(opc_2a),
       Ofs(opc_2b),
       Ofs(opc_2c),
       Ofs(opc_2d),
       Ofs(opc_2e),
       Ofs(opc_2f),
       Ofs(opc_30),
       Ofs(opc_31),
       Ofs(opc_32),
       Ofs(opc_33),
       Ofs(opc_34),
       Ofs(opc_35),
       Ofs(opc_36),
       Ofs(opc_37),
       Ofs(opc_38),
       Ofs(opc_39),
       Ofs(opc_3a),
       Ofs(opc_3b),
       Ofs(opc_3c),
       Ofs(opc_3d),
       Ofs(opc_3e),
       Ofs(opc_3f),
       Ofs(opc_40_47),
       Ofs(opc_40_47),
       Ofs(opc_40_47),
       Ofs(opc_40_47),
       Ofs(opc_40_47),
       Ofs(opc_40_47),
       Ofs(opc_40_47),
       Ofs(opc_40_47),
       Ofs(opc_48_4f),
       Ofs(opc_48_4f),
       Ofs(opc_48_4f),
       Ofs(opc_48_4f),
       Ofs(opc_48_4f),
       Ofs(opc_48_4f),
       Ofs(opc_48_4f),
       Ofs(opc_48_4f),
       Ofs(opc_50_57),
       Ofs(opc_50_57),
       Ofs(opc_50_57),
       Ofs(opc_50_57),
       Ofs(opc_50_57),
       Ofs(opc_50_57),
       Ofs(opc_50_57),
       Ofs(opc_50_57),
       Ofs(opc_58_5f),
       Ofs(opc_58_5f),
       Ofs(opc_58_5f),
       Ofs(opc_58_5f),
       Ofs(opc_58_5f),
       Ofs(opc_58_5f),
       Ofs(opc_58_5f),
       Ofs(opc_58_5f),
       Ofs(opc_60),
       Ofs(opc_61),
       Ofs(opc_62),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_66),
       Ofs(opc_uu),
       Ofs(opc_68),
       Ofs(opc_69),
       Ofs(opc_6a),
       Ofs(opc_6b),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_70),
       Ofs(opc_71),
       Ofs(opc_72),
       Ofs(opc_73),
       Ofs(opc_74),
       Ofs(opc_75),
       Ofs(opc_76),
       Ofs(opc_77),
       Ofs(opc_78),
       Ofs(opc_79),
       Ofs(opc_7a),
       Ofs(opc_7b),
       Ofs(opc_7c),
       Ofs(opc_7d),
       Ofs(opc_7e),
       Ofs(opc_7f),
       Ofs(opc_80),
       Ofs(opc_81),
       Ofs(opc_82),
       Ofs(opc_83),
       Ofs(opc_84),
       Ofs(opc_85),
       Ofs(opc_86),
       Ofs(opc_87),
       Ofs(opc_88),
       Ofs(opc_89),
       Ofs(opc_8a),
       Ofs(opc_8b),
       Ofs(opc_8c),
       Ofs(opc_8d),
       Ofs(opc_8e),
       Ofs(opc_8f),
       Ofs(opc_90),
       Ofs(opc_91),
       Ofs(opc_92),
       Ofs(opc_93),
       Ofs(opc_94),
       Ofs(opc_95),
       Ofs(opc_96),
       Ofs(opc_97),
       Ofs(opc_98),
       Ofs(opc_99),
       Ofs(opc_9a),
       Ofs(opc_9b),
       Ofs(opc_9c),
       Ofs(opc_9d),
       Ofs(opc_9e),
       Ofs(opc_9f),
       Ofs(opc_a0),
       Ofs(opc_a1),
       Ofs(opc_a2),
       Ofs(opc_a3),
       Ofs(opc_a4),
       Ofs(opc_a5),
       Ofs(opc_a6),
       Ofs(opc_a7),
       Ofs(opc_a8),
       Ofs(opc_a9),
       Ofs(opc_aa),
       Ofs(opc_ab),
       Ofs(opc_ac),
       Ofs(opc_ad),
       Ofs(opc_ae),
       Ofs(opc_af),
       Ofs(opc_b0_b7),
       Ofs(opc_b0_b7),
       Ofs(opc_b0_b7),
       Ofs(opc_b0_b7),
       Ofs(opc_b0_b7),
       Ofs(opc_b0_b7),
       Ofs(opc_b0_b7),
       Ofs(opc_b0_b7),
       Ofs(opc_b8_bf),
       Ofs(opc_b8_bf),
       Ofs(opc_b8_bf),
       Ofs(opc_b8_bf),
       Ofs(opc_b8_bf),
       Ofs(opc_b8_bf),
       Ofs(opc_b8_bf),
       Ofs(opc_b8_bf),
       Ofs(opc_c0),
       Ofs(opc_c1),
       Ofs(opc_c2),
       Ofs(opc_c3),
       Ofs(opc_c4),
       Ofs(opc_c5),
       Ofs(opc_c6),
       Ofs(opc_c7),
       Ofs(opc_c8),
       Ofs(opc_c9),
       Ofs(opc_ca),
       Ofs(opc_cb),
       Ofs(opc_cc),
       Ofs(opc_cd),
       Ofs(opc_ce),
       Ofs(opc_cf),
       Ofs(opc_d0),
       Ofs(opc_d1),
       Ofs(opc_d2),
       Ofs(opc_d3),
       Ofs(opc_d4),
       Ofs(opc_d5),
       Ofs(opc_uu),
       Ofs(opc_d7),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_uu),
       Ofs(opc_e0),
       Ofs(opc_e1),
       Ofs(opc_e2),
       Ofs(opc_e3),
       Ofs(opc_e4),
       Ofs(opc_e5),
       Ofs(opc_e6),
       Ofs(opc_e7),
       Ofs(opc_e8),
       Ofs(opc_e9),
       Ofs(opc_ea),
       Ofs(opc_eb),
       Ofs(opc_ec),
       Ofs(opc_ed),
       Ofs(opc_ee),
       Ofs(opc_ef),
       Ofs(opc_f0),
       Ofs(opc_f1),
       Ofs(opc_f2),
       Ofs(opc_f3),
       Ofs(opc_f4),
       Ofs(opc_f5),
       Ofs(opc_f6),
       Ofs(opc_f7),
       Ofs(opc_f8),
       Ofs(opc_f9),
       Ofs(opc_fa),
       Ofs(opc_fb),
       Ofs(opc_fc),
       Ofs(opc_fd),
       Ofs(opc_fe),
       Ofs(opc_ff));

  (*$IfDef VirtualPascal*)
  var
    opc_tab_procedure:array[0..255] of procedure absolute opc_tab;
  (*$EndIf VirtualPascal*)

  (*$IfDef DOS_OVERLAY*)
  var
    opc_tab_ref:array[0..255] of word_norm;
  (*$EndIf DOS_OVERLAY*)

  procedure mte_suche(const p:puffertyp);
    var
      w1:word_norm;
    begin
      if mte_gefunden then exit;

      w1:=puffer_pos_suche(p,'MtE ',500);
      if w1<>nicht_gefunden then
        begin
          ausschrift(puffer_zu_zk_e(p.d[w1],#0,9),virus);
          mte_gefunden:=true;
        end;

      (* klappt nicht weil die Kennung nicht weit genug am Anfang ist
      w1:=puffer_pos_suche(p,'˚iCE v',490);
      if w1<>nicht_gefunden then
        begin
          ausschrift(puffer_zu_zk_e(p.d[w1],']',30),virus);
          mte_gefunden:=true;
        end;*)
    end;


  procedure regelmaessige_suche;
    var
      mte_such_puffer:puffertyp;
    begin
      benutzer_abfrage(false,false);

      if not mte_gefunden then
        begin
          if _cs>0 then
            begin
              lies_emu(mte_such_puffer,512,_cs,$0000);
              mte_suche(mte_such_puffer);
            end;
          lies_emu(mte_such_puffer,512,_cs,$0100);
          mte_suche(mte_such_puffer);
          lies_emu(mte_such_puffer,512,_cs,_ip+$180);
          mte_suche(mte_such_puffer);
        end;

      lies_emu_puffer(512);
      mte_suche(emu_puffer);

      (*$IfDef ERWEITERUNGSDATEI*)
      suche_erweiterungen2(emu_puffer);
      (*$EndIf ERWEITERUNGSDATEI*)


      (* Hackstop *)
      if puffer_pos_suche(emu_puffer,#$59#$5f#$1e#$2b#$c0#$8e#$d8#$ff#$36#$04#$00#$ff#$36#$06#$00,100)
         <>nicht_gefunden then
        begin
          hackstop('1.19 (204/6 EXE)');
          emulationstoppen('',signatur);
          exit;
        end;

      (* Uruguay *)
      if  (puffer_pos_suche(emu_puffer,#$fc#$e8#$00#$00#$5b#$0e#$53,512)<>nicht_gefunden)
      and (puffer_pos_suche(emu_puffer,#$33#$c0#$8e#$c0#$26#$8a#$0e#$6c#$04,512)<>nicht_gefunden)
       then
        begin
          emulationstoppen('Uruguay',virus);
          exit;
        end;

      if puffer_gefunden(emu_puffer,#$b8#$da#$33#$cd#$21#$80#$fc#$a5) then
        begin
          emulationstoppen('CoffeShop',virus);
          exit;
        end;

      if puffer_gefunden(emu_puffer,#$bf#$00#$01#$be'??'#$03#$f7#$2e#$8b#$8d'??'#$cd#$21#$8c#$c8#$05#$10#$00) then
        begin
          emulationstoppen('Jerusalem',virus);
          exit;
        end;

      (* ALEC *)
      w1:=puffer_pos_suche(emu_puffer,#$e8#$00#$00#$5d#$81#$ed'??'#$2e#$8c#$86'??'#$33#$c0
          +#$8e#$e0#$66#$64#$a1#$04#$01#$66#$2e,512);
      if w1<>nicht_gefunden then
        begin
          case word_z(@emu_puffer.d[w1+6])^ of
            $1073:exezk:='[1.3]'; (* KILLHS.EXE *)
            $10d4:exezk:='[1.6]';
          else
                  exezk:='[1.?? ¯]';
          end;
          emulationstoppen('ALEC / rANDOM '+exezk,packer_exe);
          exit;
        end;

      (* FSE *)
      if puffer_gefunden(emu_puffer,#$b0#$cb#$e8'?'#$00#$86#$06#$00#$01#$58#$fb#$e8'?'#$00#$2e#$8b#$36'??'#$ba) then
        begin
          emulationstoppen('FSE / Zenix Yang [0.5x]',packer_exe);
          exit;
        end;


      (* SUCKSTOP *)
      if puffer_gefunden(emu_puffer,#$1e#$06#$b8#$00#$30#$cd#$21#$86#$e0#$3d#$ff#$02#$73#$0c#$b8#$ff#$4c#$cd#$21
                                   +'HBOOT'#$00#$9a#$9c#$58) then
        emulationstoppen('SuckStop / Ka0t^N0Ps [1.05r] '(*+zusatzcodelaenge_zk*),packer_exe);


      (* PROTECT! *)

      if (schritt<=600)
      and puffer_gefunden(emu_puffer,#$e8#$00#$00#$5d#$8b#$f5#$81#$c6#$c9#$00#$b9'??'#$eb#$01'?'#$89#$f7)
       then
        begin
          emulationstoppen('Protect! / Jeremy Lilley [5.0]',packer_exe);
          exit;
        end;

      (* Protect 5.5 *)
      if (protect55=protect55_maske)
      and (schritt<200) (* 100 *)
      and (sprung_zaehler>3)
       then
        begin
          emulationstoppen('Protect! / Jeremy Lilley [5.5, 6.0 no UnAV]',packer_exe);
          exit;
        end;

      (* TRAP : 1.14˙˙19 .COM, 1.2* *)

      if puffer_pos_suche(emu_puffer,#$8b#$f6#$8b#$c0#$b8#$01#$fa#$ba#$45#$59#$33,512)<>nicht_gefunden then
        begin
          trap('1.14 .COM');
          emulationstoppen('',signatur);
          exit;
        end;

      if puffer_pos_suche(emu_puffer,#$8b#$f6#$8b#$c0#$b8#$21#$43#$ba#$34#$12#$33,512)<>nicht_gefunden then
        begin
          trap('1.16/17 .COM');
          emulationstoppen('',signatur);
          exit;
        end;

      if puffer_pos_suche(emu_puffer,#$e8#$00#$00#$5b#$83#$c3#$56#$90#$8b#$d3,512)<>nicht_gefunden then
        begin
          trap('1.22');
          emulationstoppen('',signatur);
          exit;
       end;


      if puffer_pos_suche(emu_puffer,#$33#$d2#$33#$ff#$33#$c0#$b9#$34#$12#$bb#$21#$43,512)<>nicht_gefunden then
        begin
          trap('1.21/22/23 .COM');
          emulationstoppen('',signatur);
          exit;
        end;

      if puffer_pos_suche(emu_puffer,#$e8#$00#$00#$5b#$83#$c3#$5b#$8b#$d3,512)<>nicht_gefunden then
        begin
          trap('1.24..1.25 EXE');
          emulationstoppen('',signatur);
          exit;
        end;

      if puffer_pos_suche(emu_puffer,#$e8'?'#$00'?'#$b0#$ad#$e8'?'#$00'?'#$90#$e8,512)<>nicht_gefunden then
        begin
          trap('1.24..1.25 COM');
          emulationstoppen('',signatur);
          exit;
        end;

      if puffer_pos_suche(emu_puffer,#$e8#$00#$00#$8b#$fc#$33#$c0#$36#$8b#$2d#$8b#$c8
          +#$81#$ed#$0f#$01#$87#$d2#$44#$44,512)<>nicht_gefunden then
        begin
          (* allgemeiner *)
          trap('1.14..1.22 COM ¯');
          emulationstoppen('',signatur);
          exit;
        end;


    end;



  procedure poly_emulator(const modus:poem_modus);

  (*$IfDef ERWEITERTE_EMULATION*)
  procedure lade_code;
    type
      relo=
        packed record
          ofs_,seg_:word;
        end;
    var
      z1                :word_norm;
      poem_gelesen      :longint;
      (*$IfDef DPMI*)
      relo_pos_seg,
      relo_pos_ofs,
      relo_ziel_seg,
      relo_ziel_ofs     :word;
      w1                :word_norm;
      (*$Else DPMI*)
      relo_zeiger       :^relo;
      (*$EndIf DPMI*)
      jetzt             :word_norm;

      seek_pos          :dateigroessetyp;
      p                 :puffertyp;

    procedure Seek1(var d:file;o:dateigroessetyp);
      var
        actual          :dateigroessetyp;
      begin
        seek_pos:=o;
        if quelle.sorte=q_datei then
          begin
            (*$I-*)
            (*$IfDef dateigroessetyp_comp*)
            (*$IfDef LargeFileSupport*)
            SysFileSeek(FileRec(datei).Handle,o,0,actual);
            (*$Else*)
            Seek(datei,DGT_zu_longint(o));
            (*$EndIf*)
            (*$Else*)
            Seek(datei,o);
            (*$EndIf*)
            (*$I+*)
            if IOResult<>0 then;
          end;
      end; (* Seek1 *)


    (*$IfDef DPMI*)
    procedure blockread1(segm,offs:word;laenge:longint;var gelesen:longint);
      var
        l               :longint;
        jetzt,g         :word;

      begin
        l:=longint(segm) shl 4+offs;
        gelesen:=0;
        while laenge>0 do
          begin
            jetzt:=$8000-(l and $7fff);
            if jetzt>laenge then
              jetzt:=laenge;
            BlockRead(datei,speicher_bereichs_tabelle[l shr 15]^[l and $7fff],jetzt,g);
            Inc(l,jetzt);
            Dec(laenge,jetzt);
            Inc(gelesen,g);
            if g<>jetzt then Break;
          end;
      end; (* blockread1 *)
    (*$EndIf DPMI*)

    begin (* lade_code *)
      (*$IfDef DPMI*)
      for w1:=Low(speicher_bereichs_tabelle) to High(speicher_bereichs_tabelle) do
        FillChar(speicher_bereichs_tabelle[w1]^,SizeOf(speicher_bereichs_tabelle[w1]^),0);
      (*$Else DPMI*)
      FillChar(poem_dos_speicher^,SizeOf(poem_dos_speicher^),0);
      (*$EndIf DPMI*)

      if exe then
        begin
          poem_gelesen:=IOResult;

          (* EXE-Kopf nach A000:0000,4*64K laden *)
          Seek1(datei,analyseoff);
          (*$IfDef DPMI*)
          blockread1($a000,$0000,longint(exe_kopf.kopfgroesse) shl 4,poem_gelesen);
          (*$Else DPMI*)
          BlockRead(datei,poem_dos_speicher^[$a000*16],longint(exe_kopf.kopfgroesse) shl 4,poem_gelesen);
          (*$EndIf DPMI*)

          (*$IfDef DPMI*)
          relo_pos_seg:=$a000;
          relo_pos_ofs:=exe_kopf.relooffset;
          (*$Else DPMI*)
          relo_zeiger:=Pointer(@poem_dos_speicher^[$a000*16+exe_kopf.relooffset]);
          (*$EndIf DPMI*)

        end; (* EXE *)


      Seek1(datei,org_code_imagestart);

      case modus of
        poem_modus_normal,
        poem_modus_sys,
        poem_modus_rom:
          jetzt:=Min(in_datei_vorhanden_laenge,1024*1024);

        poem_modus_sekt:
          jetzt:=Min(in_datei_vorhanden_laenge,512);
      end;

      if quelle.sorte=q_datei then
        begin
          (* ohne Benutzung des Caches lesen (512 byte sind zuwenig..) *)
          (*$IfDef DPMI*)
          BlockRead1(lade_segment,$0000,jetzt,poem_gelesen);
          (*$Else DPMI*)
          BlockRead(datei,poem_dos_speicher^[lade_segment*16],jetzt,poem_gelesen);
          (*$EndIf DPMI*)
        end
      else
        begin
          datei_lesen(p,seek_pos,Min(512,jetzt));
          Move(p.d,liefere_adresse_8(lade_segment,0)^,p.g);
        end;


      if exe then
        for z1:=exe_kopf.relokationspositionen downto 1 do
          begin
            (*$IfDef DPMI*)
            if relo_pos_ofs>16 then
              begin
                Dec(relo_pos_ofs,16);
                Inc(relo_pos_seg);
              end;
            relo_ziel_ofs:=lade_word(relo_pos_seg,relo_pos_ofs  );
            relo_ziel_seg:=lade_word(relo_pos_seg,relo_pos_ofs+2)+lade_segment;
            Inc(relo_pos_ofs,2+2);
            Inc(liefere_adresse_16(relo_ziel_seg,relo_ziel_ofs)^,
                lade_segment);
            if speicher_emulation.aktiv then
              with speicher_emulation do
                begin
                  aktiv:=false;
                  liefere_adresse_8(seg_,off_  )^:=lo(feld);
                  liefere_adresse_8(seg_,off_+1)^:=hi(feld);
                end;
            (*$Else DPMI*)
            Inc(liefere_adresse_16(word(relo_zeiger^.seg_+lade_segment),relo_zeiger^.ofs_)^,
                lade_segment);
            Inc(relo_zeiger); (* +4 *)
            (*$EndIf DPMI*)
          end;

      (* alle diese Einstellungen auch im DOS-Teil Ñndern! *)
      (* INT 20 *)
      liefere_adresse_16(smallword(psp_segment),$0000)^:=$20cd;
      (* Speichergrî·e *)
      liefere_adresse_16(smallword(psp_segment),$0002)^:=$9fff;
      (* CP/M, wird von ANSI.COM abgefragt *)
      liefere_adresse_16(smallword(psp_segment),$0006)^:=$eff0;

      (* Umgebungssegment *)
      exezk:='COMSPEC=C:\DOS\COMMAND.COM'#0#0#1#0+dateiname+#0;
      while (Length(exezk) and $f)<>0 do
        exezk_anhaengen(#0);
      umgebungs_segment:=smallword(psp_segment<-1-Length(exezk) shr 4);
      with mcb_z(liefere_adresse_8(smallword(umgebungs_segment-1),0))^ do
        begin
          sig:='M';
          eigentuemer:=psp_segment;
          anzahl_para:=Length(exezk) shr 4;
          FillChar(leer,SizeOf(leer),0);
          prgname:='PROGNAME';
        end;
      liefere_adresse_16(smallword(psp_segment),$002c)^:=umgebungs_segment;

      (*$IfDef DPMI*)
      Move(exezk[1],liefere_adresse_16(umgebungs_segment,$0000)^,Length(exezk));
      (*$Else DPMI*)
      Move(exezk[1],poem_dos_speicher^[umgebungs_segment shl 4],Length(exezk));
      (*$EndIf DPMI*)

      (* Ende der Komandozeile *)
      liefere_adresse_8 (smallword(psp_segment),$0081)^:=$0d;

      (* Speichergrî·e fÅr einige Viren *)
      liefere_adresse_16($0040,$0013)^:=640;

    end; (* lade_code *)
  (*$EndIf ERWEITERTE_EMULATION*)

  label
    kein_ruecksprung,
    poem_ende;

  begin
    poem_modus_variable:=modus;
    emulator_abbrechen:=false;

    if poem_modus_variable=poem_modus_sekt then
      begin
        lade_segment     :=$07c0;
        umgebungs_segment:=$e000;
      end
    else
      begin
        (*$IfDef ERWEITERTE_EMULATION*)
        lade_segment     :=$1000;
        umgebungs_segment:=0; (* wird geÑndert *)
        (*$Else ERWEITERTE_EMULATION*)
        lade_segment     :=$0000;
        umgebungs_segment:=$e000;
        (*$EndIf ERWEITERTE_EMULATION*)
      end;

    psp_segment          :=smallword($fff0+lade_segment);

    (*$IfNDef ERWEITERTE_EMULATION*)
    if quelle.sorte<>q_datei then
      Exit;
    (*$EndIf ERWEITERTE_EMULATION*)

    if not cpu_emulator then
      Exit;

    (*$IfDef dateigroessetyp_comp*)
    in_datei_vorhanden_laenge_comp:=einzel_laenge-(org_code_imagestart-analyseoff);
    if in_datei_vorhanden_laenge_comp<0 then
      in_datei_vorhanden_laenge:=0
    else
    if in_datei_vorhanden_laenge_comp>1024*1024 then
      in_datei_vorhanden_laenge:=10124*1024
    else
      in_datei_vorhanden_laenge:=DGT_zu_longint(in_datei_vorhanden_laenge_comp);
    (*$Else*)
    in_datei_vorhanden_laenge:=einzel_laenge-(org_code_imagestart-analyseoff);
    (*$EndIf*)

    if in_datei_vorhanden_laenge<20 then Exit;

    if modus=poem_modus_normal then
      if  (in_datei_vorhanden_laenge>500*1024)
      or ((einzel_laenge>$fff0) and (not exe))
       then
        Exit;

    (*$IfDef ERWEITERTE_EMULATION*)
    (* 1 MB mîglich aber mehr als 4*64 technisch sinnlos *)
    if exe and (exe_kopf.kopfgroesse>=(4*64*1024 shr 4)) then
      Exit;
    (*$EndIf ERWEITERTE_EMULATION*)

    (* Initialisierung *)
    (*$IfDef DOS*)
    speicher_bereichs_tabelle_gefuellt:=0;
    for zaehler:=Low(speicher_bereichs_tabelle) to High(speicher_bereichs_tabelle) do
      begin
        FillChar(speicher_bereichs_tabelle[zaehler].speicherzeiger^,speicher_bereichs_laenge,0);
        speicher_bereichs_tabelle[zaehler].schon_veraendert:=false;
      end;

    speicher_emulation.aktiv:=false;
    (*$EndIf DOS*)

    (*$IfDef DPMI*)
    (*!!!!!!!!*)
    (*$EndIf DPMI*)

    (*$IfDef ERWEITERTE_EMULATION*)
    lade_code;
    (*$EndIf ERWEITERTE_EMULATION*)

    (*$IfDef DEBUG*)
    Dec(herstellersuche);
    case poem_modus_variable of
      poem_modus_normal:
        ausschrift('############## POEM:EXE ##############',signatur);
      poem_modus_sys:
        ausschrift('############## POEM:SYS ##############',signatur);
      poem_modus_rom:
        ausschrift('############## POEM:ROM ##############',signatur);
      poem_modus_sekt:
        ausschrift('############## POEM:SEK ##############',signatur);
    else
      RunError(0);
    end;
    Inc(herstellersuche);
    (*$EndIf DEBUG*)

    emulation_stoppen:=false;
    dosver_zaehler:=0;
    softice_zaehler:=0;

    sprung_zaehler:=0;
    pacific_cld_gefunden:=false;
    unbekannt1_zaehler:=0;
    protect55:=0;
    cybershadow:=0;

    _cs:=word(org_code_seg+lade_segment);
    _ip:=org_code_off;
    _flags:=0;
    _flags_interrupt:=true;

    _ds:=smallword($fff0+lade_segment); (* PSP *)
    _es:=smallword($fff0+lade_segment);

    _ax:=0;
    _bx:=smallword(in_datei_vorhanden_laenge shl 16);
    _cx:=smallword(in_datei_vorhanden_laenge       );


    if exe then
      begin
        (*$IfDef ERWEITERTE_EMULATION*)
        l1:=$10+(in_datei_vorhanden_laenge+15) shr 4
           +longint(exe_kopf.memmax);
        if l1>$ffff then
          programm_speicherlaenge:=$ffff
        else
          programm_speicherlaenge:=smallword(l1);
        (*$EndIf ERWEITERTE_EMULATION*)

        _ss:=word(exe_kopf.stackoffset+lade_segment);
        _sp:=exe_kopf.sp_wert;
        if exe_kopf.sp_wert=$fffe then
          (* fÅr COM->EXE mit RET statt INT 20 *)
          begin
            Inc(_sp,2); (* $10000 *)
            push_(0);
          end;
      end
    else (* .COM *)
      begin

        (*$IfDef ERWEITERTE_EMULATION*)
        programm_speicherlaenge:=$ffff;
        (*$EndIf ERWEITERTE_EMULATION*)

        if  (lade_word(lade_segment,0)=$ffff)
        and (lade_word(lade_segment,2)=$ffff)
        and (poem_modus_variable<>poem_modus_sys)
         then
          Exit;

        _ss:=_cs;
        _sp:=0;
        push_(0); (* PSP:0 = INT 20 *)
      end;

    (*$IfDef ERWEITERTE_EMULATION*)
    if programm_speicherlaenge>$9fff-(lade_segment-$10) then
      programm_speicherlaenge:=$9fff-(lade_segment-$10); (* $10=PSP/16 *)

    with mcb_z(liefere_adresse_8(smallword(_es-1),0))^ do
      begin
        sig:='M';
        eigentuemer:=_es;
        anzahl_para:=programm_speicherlaenge;
        FillChar(leer,SizeOf(leer),0);
        prgname:='PROGNAME';
        arbeits_seg:=smallword(_es-1+1+anzahl_para);
      end;



    with mcb_z(liefere_adresse_8(arbeits_seg,0))^ do
      begin
        sig:='Z';
        eigentuemer:=0;
        anzahl_para:=$a000-(arbeits_seg+1);
        FillChar(leer,SizeOf(leer),0);
        FillChar(prgname,SizeOf(prgname),0)
      end;

    (* COMMAND.COM emulieren:

    (* parent PSP: wird von comhack.com abgefragt ... *)
    arbeits_seg:=smallword(umgebungs_segment-1-$10-$10);
    liefere_adresse_16(arbeits_seg,$0000)^:=$20cd;
    liefere_adresse_16(arbeits_seg,$0002)^:=$9fff;
    liefere_adresse_16(arbeits_seg,$0006)^:=$eff0;
    liefere_adresse_16(arbeits_seg,$0016)^:=arbeits_seg; (* bei command verweist dieser Wert auf sich selbst *)
    exezk:=' /C 12345678.EXE'#$0d;
    liefere_adresse_8(arbeits_seg,$0081)^:=Length(exezk)-1;
    Move(exezk,liefere_adresse_8(arbeits_seg,$0081)^,Length(exezk)+1);

    (* parent PSP: wird von comhack.com abgefragt ... *)
    liefere_adresse_16(smallword(psp_segment),$0016)^:=arbeits_seg;

    (*$EndIf ERWEITERTE_EMULATION*)

    _bp:=$1234; (* fÅr Tinypack, alt war _sp, DRDOS: 17DA, OS/2 MDOS 091E *);
    _dx:=_ds;
    _si:=_ip;
    _di:=_sp;

    if poem_modus_variable=poem_modus_sekt then
      begin
        _ax:=$0001; (* 1 Sektor *)
        _bx:=$7c00; (* ofs      *)
        _cx:=$0001; (* Sektor 1 *)
        _dx:=$0000; (* A:       *)
        _si:=$7c00;
        _di:=$7c00;
        _sp:=$7c00;
        _bp:=$7c00;
        _ip:=$7c00;
        _cs:=$0000;
        _ds:=$0000;
        _es:=$0000;
        _ss:=$0000;
      end;

    org_ss:=_ss;
    org_sp:=_sp;


    segment_ueberschreibung:=segment_ueberschreibung_keine;

    (*$IfNDef VIDEO_BIOS*)
    textzeile:='';
    neue_textzeile;
    erste_textzeile:=true;
    textzeile_zeile:=0;
    textzeile_spalte:=0;
    (*$EndIf VIDEO_BIOS*)

    obc_00_zaehler:=0;

    (*$IfDef POEM_BIO*)
    with speicher_modus3_z(poem_dos_speicher)^ do
      begin
        tastatur_naechstes_zeichen_offs  :=$1e;
        tastatur_erster_freier_platz_offs:=$1e;
        tastaturpuffer_anfang_offs       :=$1e;
        tastaturpuffer_endeplus1_offs    :=$1e+16*2;
        erstelle_bildschirmkopie;
      end;
    (*$Else POEM_BIO*)
    tasten_vorhanden:=0;
    (*$EndIf POEM_BIO*)
    zaehler_y_taste:=0;

    schritt:=0;
    max_schritte:=max_schritte_normal;
    mte_gefunden:=false;
    ruecksprung_gefunden:=false;

    (*$IfDef POEM_SYS*)
    if (poem_modus_variable=poem_modus_sys) then
       begin
         (*$IfDef VirtualPascal*)
         Move(poem_sys_lader,poem_dos_speicher^[$a0000],SizeOf(poem_sys_lader));
         (*$Else VirtualPascal*)
         (* wird automatisch geladen *)
         (*$EndIf VirtualPascal*)
         _cs:=$a000;
         _ip:=$0000;
         Inc(_ds,$10); (* kein PSP *)
         Inc(_es,$10); (* kein PSP *)
       end;
    (*$EndIf POEM_SYS*)

    (*$IfDef POEM_ROM*)
    if (poem_modus_variable=poem_modus_rom) then
       begin
         (*$IfDef VirtualPascal*)
         Move(poem_rom_lader,poem_dos_speicher^[$a0000],SizeOf(poem_rom_lader));
         (*$Else VirtualPascal*)
         (* wird automatisch geladen *)
         (*$EndIf VirtualPascal*)
         _cs:=$a000;
         _ip:=$0000;
         Inc(_ds,$10); (* kein PSP *)
         Inc(_es,$10); (* kein PSP *)
       end;
    (*$EndIf POEM_ROM*)

    (*$IfDef VIDEO_BIOS*)
    textbildschirm_zuruecksetzen(true);
    (*$EndIf VIDEO_BIOS*)

    (*$IfDef POEM_BIO*)
    Move(poem_bios,poem_dos_speicher^[$f0000],SizeOf(poem_bios));
    (* F400:0,F401:0,...F4ff:0 *)
    w2:=$f4000+0*16;
    for w1:=0 to 255 do
      begin
        (* Mem[F400:0000]:=Jmp F000:0000 *)
        (* Mem[F401:0000]:=Jmp F000:0004 *)
        poem_dos_speicher^[w2]:=$ea;
        longint_z(@poem_dos_speicher^[w2+1])^:=$f0000000+w1*4;

        (* Meml[0000:0000]:=F400:0000 *)
        (* Meml[0000:0004]:=F401:0000 *)
        longint_z(@poem_dos_speicher^[w1*4])^:=$f4000000+w1*$10000;
        Inc(w2,16);
      end;
    poem_dos_speicher^[$ffff0]:=$ea;
    word_z(@poem_dos_speicher^[$ffff1])^:=$19*4;
    word_z(@poem_dos_speicher^[$ffff3])^:=$f000;
    poem_dos_speicher^[$ffff5]:=Ord('0');
    poem_dos_speicher^[$ffff6]:=Ord('0');
    poem_dos_speicher^[$ffff7]:=Ord('/');
    poem_dos_speicher^[$ffff8]:=Ord('0');
    poem_dos_speicher^[$ffff9]:=Ord('0');
    poem_dos_speicher^[$ffffa]:=Ord('/');
    poem_dos_speicher^[$ffffb]:=Ord('0');
    poem_dos_speicher^[$ffffc]:=Ord('0');
    poem_dos_speicher^[$ffffd]:=$00;
    poem_dos_speicher^[$ffffe]:=$fc;
    poem_dos_speicher^[$fffff]:=$ff;


    (*$EndIf POEM_BIO*)

    (*$IfDef POEM_BIO*)
    dta_seg:=_es; (* .SYS? *)
    dta_ofs:=$0080;
    (*$EndIf POEM_BIO*)

    (*$IfDef DOS_OVERLAY*)
    (*Overlay-manager-Umleitung abkÅrzen *)
    for z:=Low(opc_tab_ref) to High(opc_tab_ref) do
      opc_tab_ref[z]:=MemW[Seg(opc_00):opc_tab[z]+1];
    (*$EndIf DOS_OVERLAY*)

    sichere_statuszeile(org_status_zeile);

    disk:=disk_c;

    (***********************************************************************)
    repeat
      (*$IfDef POEM_BIO*)
      if (_cs=$f000) and (_ip>=0*4) and (_ip<256*4) and ((_ip and 3)=0) then
        int_behandlung(_ip shr 2); (* /4 *)
      (*$EndIf POEM_BIO*)

      (*$IfDef POEM_BIO*)
      trap_flag_zu_beginn_der_anweisung:=(_flags and flags_trap)<>0;
      (*$EndIf POEM_BIO*)

      (* mindestens 30: gmouse 10.43 *)
      lies_emu_puffer(30);
      if emu_puffer.g<>30 then break;

      (* regelmÑ·ige Suche *)
      if ((schritt mod 100)=0)
      or (schritt=180) (* PROTECT! 5.5 *)
      or (schritt<10) (* schon decodierter URUGUAY *)
       then
        begin
          regelmaessige_suche;
          if emulation_stoppen then break;
        end;


      (* Start Emulation *)

      (*$IfDef DEBUG*)
      (*if (_ip>$de00)
      or (schritt=max_schritte-100)
       then
        debug_ein:=true;*)
        debug_ein:=true;
      (*$EndIf DEBUG*)

      (*$IfDef DEBUG*)
      Dec(herstellersuche);
      if debug_ein then
        ausschrift(hex_longint(schritt)
                  +' CS:IP='+hex_word(_cs)+':'+hex_word(_ip)
                  +' SS:SP='+hex_word(_ss)+':'+hex_word(_sp)
                  +' FL='+hex_word(_flags)
                  +' '+hex(emu_puffer.d[0])+' '+hex(emu_puffer.d[1])
                  +' ' +hex(emu_puffer.d[2])+' '+hex(emu_puffer.d[3])
                  +' ' +hex(emu_puffer.d[4]),signatur);

      (*$IfDef DEBUG_REG*)
      ausschrift_x('         '
              +' AX='+hex_word(_ax)+' BX='+hex_word(_bx)
              +' CX='+hex_word(_cx)+' DX='+hex_word(_dx)
              +' SI='+hex_word(_si)+' DI='+hex_word(_di),signatur,leer);
      ausschrift_x('         '
              +' DS='+hex_word(_ds)+' ES='+hex_word(_es),signatur,leer);
      (*$EndIf DEBUG_REG*)

      Inc(herstellersuche);
      (*$EndIf DEBUG*)


      postbyte1:=emu_puffer.d[1];
      postword1:=word_z(@emu_puffer.d[1])^;
      postbyte2:=emu_puffer.d[2];
      postword2:=word_z(@emu_puffer.d[2])^;
      postword3:=word_z(@emu_puffer.d[3])^;

      postbyte1_shr_6:=postbyte1 shr 6;
      postbyte1_shr_3_and_7:=(postbyte1 shr 3) and $7;
      postbyte1_and_7:=postbyte1 and 7;

      prefix:=false;

      (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)

      (*$IfDef VirtualPascal*)
      opc_tab_procedure[emu_puffer.d[0]];
      (*$Else VirtualPascal*)
      asm
        sub ax,ax
        mov al,byte [emu_puffer+2]
        mov si,ax
        add si,ax
        (*$IfDef DOS_OVERLAY*)
        call word [opc_tab_ref+si]
        (*$Else DOS_OVERLAY*)
        call word [opc_tab    +si]
        (*$EndIf DOS_OVERLAY*)
      end;
      (*$EndIf VirtualPascal*)

      Inc(schritt);

      (*$IfDef DOS_ODER_DPMI*)
      if speicher_emulation.aktiv then
        with speicher_emulation do
          begin
            aktiv:=false;
            liefere_adresse_8(seg_,off_  )^:=lo(feld);
            liefere_adresse_8(seg_,off_+1)^:=hi(feld);
          end;
      (*$EndIf DOS_ODER_DPMI*)

      if not prefix then
        segment_ueberschreibung:=segment_ueberschreibung_keine;

      if  (schritt=max_schritte_normal)
      and (poem_modus_variable=poem_modus_normal)
        then
        (* 60 Befehle je Schleifendurchlauf (URUGUAY) *)
        if langformat then
          if sprung_zaehler>max_schritte_normal div 60 then
            max_schritte:=8000*50;

      if  (not emulation_stoppen)
      and (not ruecksprung_gefunden)
      and (poem_modus_variable=poem_modus_normal)
       then
        begin
          if (_ip=$0100) and (_cs=word($fff0+lade_segment)) then (* z.B. ACE2.COM (polymorpher Code und Dateiname) *)
            begin
              (*$IfDef VIDEO_BIOS*)
              textbildschirm_auslesen2;
              (*$Else VIDEO_BIOS*)
              textausgabe_puffer_leeren(false);
              (*$EndIf VIDEO_BIOS*)
              ausschrift('CS:IP=PSP:0100 -> Com Packer/Crypter/Virus? ('+textz_schritt_^+str0(schritt)+')',packer_exe);
              ruecksprung_gefunden:=true;
            end;

          if (_ip=$0000) and (_cs=word($0000+lade_segment)) then
            begin
              (* CALL 0000 ?  (Hackstop 1.19 bei 0000:0255) *)
              lies_emu(emu_puffer,1,_cs,lade_word(_ss,_sp)-3);
              if (emu_puffer.d[0]=$e8) then
                goto kein_ruecksprung;

              (* CALL 0000:0000 ? *)
              lies_emu(emu_puffer,1+2,lade_word(_ss,_sp+2),lade_word(_ss,_sp)-5);
              if bytesuche(emu_puffer.d[0],#$9a#$00#$00) then
                goto kein_ruecksprung;

              (*$IfDef VIDEO_BIOS*)
              textbildschirm_auslesen2;
              (*$Else VIDEO_BIOS*)
              textausgabe_puffer_leeren(false);
              (*$EndIf VIDEO_BIOS*)
              ausschrift('CS:IP=0000:0000 -> Exe Packer/Crypter/Virus? ('+textz_schritt_^+str0(schritt)+')',packer_exe);
              ruecksprung_gefunden:=true;

              kein_ruecksprung:

            end;
        end;

      (*$IfDef POEM_BIO*)
      if not prefix then
        if trap_flag_zu_beginn_der_anweisung then
          begin
            (* Einzelschritt verdient mehr Zeit *)
            sprung_zaehler:=schritt;
            max_schritte:=400000;
            int_aufrufen($01);
          end;
      (*$EndIf POEM_BIO*)

      if schritt>statuszeilenanzeige_ab_schritt then
        if (schritt and statuszeilenanzeige_wiederholung )=0 then
          schreibe_statuszeile(' CPU-EMU = '+str11_oder_hex(schritt)+' CS:IP='+hex_word(_cs)+':'+hex_word(_ip),false);

    until (schritt>max_schritte) or (emulation_stoppen) or emulator_abbrechen;

    if schritt>statuszeilenanzeige_ab_schritt then
      restauriere_statuszeile(org_status_zeile);

    (***********************************************************************)

    if not hersteller_gefunden then
      regelmaessige_suche;

    (*$IfDef DEBUG*)
    if not hersteller_gefunden then
      begin
        Dec(herstellersuche);
        ausschrift(':VirenlÑnge='+str0(in_datei_vorhanden_laenge-longint(_cs)*16),signatur);
        if emulation_stoppen then
          ausschrift(':(emulation_stoppen)',signatur);
        if schritt>max_schritte then
          ausschrift(':(max_schritte)',signatur);
        ausschrift('CS:IP='+hex_word(_cs)+':'+hex_word(_ip),signatur);
        ausschrift('SCHRITT='+str0(schritt)+'/'+str0(max_schritte),signatur);
        Inc(herstellersuche);
      end;
    (*$EndIf DEBUG*)


poem_ende:

    (*$IfDef VIDEO_BIOS*)
    textbildschirm_auslesen2;
    (*$Else VIDEO_BIOS*)
    textausgabe_puffer_leeren(false);
    (*$EndIf VIDEO_BIOS*)

    (*$IfDef UNBEKANNT_ANZEIGEN*)
    Dec(herstellersuche);
    lies_emu_puffer(512);
    signatur_anzeige('STOP=',emu_puffer);
    ausschrift('CS:IP='+hex_longint(_cs)+':'+hex_word(_ip),signatur);
    Inc(herstellersuche);
    (*$EndIf UNBEKANNT_ANZEIGEN*)

    (*$IfDef DEBUG*)
    Dec(herstellersuche);

    ausschrift( 'AX='+hex_word(_ax)+' BX='+hex_word(_bx)
              +' CX='+hex_word(_cx)+' DX='+hex_word(_dx)
              +' SI='+hex_word(_si)+' DI='+hex_word(_di),signatur);

    (*lies_emu_puffer(512);
    signatur_anzeige('STOP=',emu_puffer);*)

    (*ausschrift('CS:IP='+hex_longint(_cs)+':'+hex_word(_ip),signatur);
    ausschrift('SPRUNG  ='+str(sprung_zaehler   ,0),signatur);
    ausschrift('SCHRITTE='+str(schritt          ,0),signatur);
    ausschrift('PACIFIC ='+str(pacific_zaehler  ,0),signatur);
    ausschrift('U1      ='+str(unbekannt1_zaehler,0),signatur);*)

    Inc(herstellersuche);

    (*$EndIf DEBUG*)
  end;

procedure einrichten_typ_poem(const anfang:boolean);
  begin
    einrichten_typ_spei(anfang);

    if anfang then
      begin

        (* der Speicher wird zum Programmende nicht noch extra freigegeben *)
        (*$IfDef DOS*)
        for w1:=Low(speicher_bereichs_tabelle) to High(speicher_bereichs_tabelle) do
          speicher_bereichs_tabelle[w1].speicherzeiger:=
            speicherseite_z(@allgemeiner_zwischenspeicher^[(w1-1)*SizeOf(speicherseite)]);
        (*$EndIf DOS*)

        (*$IfDef DPMI*)
        for w1:=Low(speicher_bereichs_tabelle) to High(speicher_bereichs_tabelle) do
          New(speicher_bereichs_tabelle[w1]);
        (*$EndIf DPMI*)

        (*$IfDef VirtualPascal*)
        New(poem_dos_speicher)
        (*$EndIf VirtualPascal*)
      end

    else

      (*$IfDef SPEICHER_FREIGEBEN*)
      (*$IfDef VirtualPascal*)
      if Assigned(poem_dos_speicher) then
        begin
          Dispose(poem_dos_speicher)
          poem_dos_speicher:=nil;
        end;
      (*$EndIf VirtualPascal*)
      (*$EndIf SPEICHER_FREIGEBEN*)
  end;



(*$IfNDef VirtualPascal*)
begin
  einrichten_typ_poem(true);
(*$Else VirtualPascal*)
initialization
  einrichten_typ_poem(true);
finalization
  einrichten_typ_poem(false);
(*$EndIf VirtualPascal*)

(*$EndIf POEM_EINSPAREN*)

end.

