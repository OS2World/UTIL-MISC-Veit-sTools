(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_for3;

interface

uses
  typ_type;

procedure norman_access_control;
procedure cryogen(const p:puffertyp);
procedure knowledge_hex;
procedure bsq(const p:puffertyp;w1:word_norm);
procedure d0_cf_11_e0(const p:puffertyp);
procedure lu_;
procedure rkive(const p:puffertyp;const index:word_norm;const version:byte);
procedure rk_filearchiver(const p:puffertyp;const index:word_norm);
procedure maxis_archiv;
procedure avp_archiv;
procedure splint(const p:puffertyp);
procedure knowledge;
procedure wic;
procedure stuffit(const laenge:longint);
procedure stuffit_510(const p:puffertyp);
procedure dda2;
procedure pit;
procedure binhex(const doppelpunkt_anfang:word_norm);
procedure dune_pak;
procedure codec;
procedure sqpc(const p:puffertyp);
procedure ain_22(const p:puffertyp);
procedure pronews;
procedure elm_oder_nntp(const p:puffertyp);
procedure sendmail(const nntp_gruppe:string;const nur_ein_beitrag:boolean;const prefix:string);
procedure compactor(vo:dateigroessetyp);
procedure origin_tre(const anzahl:word);
procedure goblins_stk(const anzahl:word);
procedure compak(const o:dateigroessetyp);
procedure arcv;
procedure jasc;
procedure crossepac(const p:puffertyp);
procedure crusher_scitech;
procedure wwp_dat(const p:puffertyp);
procedure xpack_pd(const p:puffertyp;const i:word_norm);
procedure zinstall;
procedure ari;
procedure os2_ini;
procedure elite_datsfx(const p:puffertyp);
procedure limit(const ver:byte);
procedure jrc;
procedure hpack;
procedure mdmd;
procedure bsa(o:dateigroessetyp);
procedure bsn(o:dateigroessetyp);
procedure x1_s_valantini(const p:puffertyp);
procedure grasp(anzahl:word_norm);
procedure cpio;
procedure quark;
procedure shrinkit;
procedure crush(const ver:string;const anz:word_norm;const o:dateigroessetyp);
procedure dwc(const anz:word_norm;o:dateigroessetyp);
procedure os2_resource_ausschrift(const typ,name_:word_norm;const l:longint);
procedure msw_resource__exezk(const typ,name_:word_norm;const typ_zk,name_zk:string;const l:longint;var entpackt_name:string);
procedure os2_resource;
procedure resource_datei_w32;
procedure createinstall;
procedure zzip(const p:puffertyp);
procedure zzip_36b(const p:puffertyp);
procedure yamazakizipper(const p:puffertyp);
procedure wsp_wup(const p:puffertyp);
procedure ufa(const p:puffertyp);
procedure abcomp_206(const p:puffertyp);
procedure spis(const o0:word_norm);
procedure ybs;
procedure phoenix_bios_archiv_m025(const anker,delta:dateigroessetyp);
procedure phoenix_bios_modul(const p:puffertyp);
procedure setup_twk;
procedure versuche_ttf(const p:puffertyp);
procedure protectit2(const p:puffertyp);
procedure indigorose_archiv;
procedure ffs_archiv;
procedure pkware_lib;

implementation

uses
  typ_eiau,
  typ_ausg,
  typ_var,
  typ_varx,
  typ_dien,
  typ_die2,
  typ_dat,
  typ_eas,
  typ_for0,
  typ_spra,
  typ_posm,
  typ_zeic,
  typ_entp,
  zst;


procedure norman_access_control;
  var
    o                   :dateigroessetyp;
    w1                  :word_norm;
  begin
    exezk:='';
    o:=analyseoff;
    for w1:=1 to 3 do
      begin
        datei_lesen(form_puffer,o,512);
        exezk:=exezk+puffer_zu_zk_l(form_puffer.d[4],form_puffer.d[0])+' ';
        IncDGT(o,4+longint_z(@form_puffer.d[0])^);
      end;
    Dec(exezk[0]);
    ausschrift((*'Norman Access Control'*)exezk,packer_dat);
    if not langformat then exit;

    archiv_start;
    IncDGT(o,$39);
    (*repeat*)
      datei_lesen(form_puffer,o,512);
      laenge_ausgepackt:=longint_z(@form_puffer.d[4+form_puffer.d[0]])^;
      laenge_eingepackt:=laenge_ausgepackt;
      IncDGT(o,longint_z(@form_puffer.d[0])^);

      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[4],form_puffer.d[0]));
      (*Inc(o,$36+laenge_eingepackt);*)
    (*until true;*) (* noch nicht ausprobiert *)
    archiv_summe;
    (*einzel_laenge:=o;*)
  end;

procedure cryogen(const p:puffertyp);
  begin
    case p.d[$11] of (* CyGMode *)
      0:exezk:='store';
      1:exezk:='normal';
      2:exezk:='cyg.exe: matrixor 32*32*32';
      3:exezk:='matrixor 37*37*37';
      4:exezk:='matrixor 30*30*60';
      5:exezk:='matrixor 48*48*96';
      6:exezk:='cyg32.exe: matrixor 77*77*77';
      7:exezk:='matrixor 60*60*120';
    else
        exezk:='?.exe: CyGMode?';
    end;
    ausschrift('CryoGen / EddyHawk ['+exezk+']',packer_dat);
    if not langformat then exit;

    archiv_start;

    laenge_ausgepackt:=longint_z(@p.d[$14])^;
    laenge_eingepackt:=DGT_zu_longint(einzel_laenge-$2c);
    archiv_datei;
    archiv_datei_ausschrift(puffer_zu_zk_pstr(p.d[4]));

    archiv_summe;

  end;

procedure knowledge_hex;
  var
    o:longint;
  begin

    (*
    ____ ____ Eeee eeee
    Aaaa aaaa ____ ____
    __Na me.. .... ....
    .... ..Da ten* ****
    **** **** **** ****
     *)

    datei_lesen(form_puffer,analyseoff+0,80);
    laenge_eingepackt:=DGT_zu_longint(ziffer(16,puffer_zu_zk_l(form_puffer.d[$08],8)));
    laenge_ausgepackt:=DGT_zu_longint(ziffer(16,puffer_zu_zk_l(form_puffer.d[$10],8)));
    if (laenge_eingepackt<=0)
    or (laenge_ausgepackt<=0)
    or (laenge_ausgepackt<laenge_eingepackt) then
      exit;

    ausschrift(textz_form__Archiv_zum_Knowledge_Dynamics_Installationsprogramm^+' (3.05,1990)',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,80);
      laenge_eingepackt:=DGT_zu_longint(ziffer(16,puffer_zu_zk_l(form_puffer.d[$08],8)));
      laenge_ausgepackt:=DGT_zu_longint(ziffer(16,puffer_zu_zk_l(form_puffer.d[$10],8)));

      if laenge_eingepackt<0 then
        begin
          ausschrift(textz_Archiv_Fehler_fragezeichen^,signatur);
          exit;
        end;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$22],#0,20));

      inc(o,$36);
      inc(o,laenge_eingepackt);

    until o>=einzel_laenge;

    archiv_summe;

  end;

procedure bsq(const p:puffertyp;w1:word_norm);
  begin
    archiv_start_leise;
    exezk:=puffer_zu_zk_e(p.d[w1+$2c],^j,8+1+3);
    exezk:=filter(exezk);
    exezk_leerzeichen_erweiterung_wie_letzte_zeile;(*?*)
    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=ziffer(10,puffer_zu_zk_l(p.d[$10],6));

    archiv_datei64;
    ausschrift('BSQ ( '+exezk+' ) '+laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);
    archiv_summe_leise;
  end;

procedure d0_cf_11_e0(const p:puffertyp);
  var
    o                   :longint;
    z                   :word_norm;
    halbe_loesung       :string;
    blocknummer         :longint;
    daten_anfang        :puffertyp;
    vielleicht_packword :boolean;
    f1                  :dateigroessetyp;

  procedure lies_block(var pb:puffertyp;const i,blockoffset,laenge:longint);
    begin
      datei_lesen(pb,analyseoff+512+i*512+blockoffset,laenge);
    end;

  function nachfolgeblock(i:longint):longint;
    var
      bat_nummer:longint;
      xbat      :longint;
    begin
      (* Berechnung der zustÑndigen BAT (je 512/4=128 Blîcke *)
      (* 109*BAT Åber den Kopfblock erreichbar, der Rest verkettet *)
      if i<109*128 then
        bat_nummer:=longint_z(@p.d[$4c+(i shr 7)*4])^
      else
        begin
          Dec(i,109*128);
          xbat:=longint_z(@p.d[$44])^; (* xbat start *)
          while i>=127*128 do
            begin
              xbat:=x_longint__datei_lesen(analyseoff+512+xbat*512+512-4);
              Dec(i,127*128)
            end;
          bat_nummer:=x_longint__datei_lesen(analyseoff+512+xbat*512+(i shr 7)*4);
        end;

      i:=i and 127;
      nachfolgeblock:=x_longint__datei_lesen(analyseoff+512+bat_nummer*512+i*4);
    end;

  procedure lies_stream(var ps:puffertyp;block,offs,laenge:longint);
    begin
      while offs>=1 shl 9 do
        begin
          Dec(offs,1 shl 9);
          block:=nachfolgeblock(block);
        end;
      lies_block(ps,block,offs,laenge);
    end;

  var
    pbl                 :puffertyp;
    unterverzeichnis    :string;
    verzeichnis         :string; (* au·erhalb der Prozedur um Stapelspeicher zu sparen *)

  procedure anzeige(const indexnummer:word_norm;const verzeichnis_laenge:word_norm);
    begin
      if stack_knapp then Exit;

      lies_stream(pbl,longint_z(@p.d[$30])^,indexnummer*$80,$80);

      (* previous *)
      if longint_z(@pbl.d[$44])^<>-1 then
        begin
          anzeige(longint_z(@pbl.d[$44])^,verzeichnis_laenge);
          lies_stream(pbl,longint_z(@p.d[$30])^,indexnummer*$80,$80);
        end;

      exezk:=uc16_puffer_zu_zk_e(pbl.d[$00],#0#0,Min($40,word_z(@pbl.d[$40])^));
      if Ord(exezk[1]) in [1..$1f] then
        exezk:='_'+str0(Ord(exezk[1]))+'_'+Copy(exezk,2,Length(exezk)-1);
      if (pbl.d[$42]=2) and (exezk='AutoOpen') then
        vielleicht_packword:=true;

      unterverzeichnis:=exezk+'\';
      exezk:=Copy(verzeichnis,1,verzeichnis_laenge)+exezk;
      exezk_leerzeichen_erweiterung(30);
      laenge_eingepackt:=longint_z(@pbl.d[$78])^;
      laenge_ausgepackt:=laenge_eingepackt;
      case pbl.d[$42] of
        1: (* Verzeichnis *)
          begin
            (* Lotus Approach, embellish 202.doc *)
            laenge_eingepackt:=0;
            laenge_ausgepackt:=0;
            archiv_datei;
            archiv_datei_ausschrift_verzeichnis(exezk);
          end;

        2: (* Datei *)
          begin
            archiv_datei;
            archiv_datei_ausschrift(exezk);
          end;

        5: (* RootEntry - ignorieren *)
          begin
            (*smallblockfilestart:=...*)
            unterverzeichnis:='';
          end;

      else
        exezk_anhaengen('? ('+str0(pbl.d[$42])+')');
      end;

      (*if Pos('_5_SummaryInformation',exezk)=1 then
        begin
          //!!
        end;*)

      if  (pbl.d[$42]=2) (* Datei *)
      and (laenge_ausgepackt>=4096) (* small block-Verkettung ist mir hier zu umstÑndlich *) then
        with daten_anfang do
          begin
            datei_lesen(daten_anfang,512+longint_z(@pbl.d[$74])^*512,16);
            if bytesuche(d[0],'MSCF') then
              ausschrift_x('MicroSoft CabinetFile / MS',packer_dat,leer);
            if bytesuche(d[0],'MZ') and (word_z(@d[8])^>=2) then
              ausschrift_x('EXE/DLL/..',bibliothek,leer);
            if bytesuche(d[0],#$ff'WPC') then
              wpc(daten_anfang);
          end;

      (* child *)
      if longint_z(@pbl.d[$4c])^<>-1 then
        begin
          verzeichnis:=verzeichnis+unterverzeichnis;
          anzeige(longint_z(@pbl.d[$4c])^,verzeichnis_laenge+Length(unterverzeichnis));
          SetLength(verzeichnis,verzeichnis_laenge);
          lies_stream(pbl,longint_z(@p.d[$30])^,indexnummer*$80,$80);
        end;

      (* next *)
      if longint_z(@pbl.d[$48])^<>-1 then
        begin
          anzeige(longint_z(@pbl.d[$48])^,verzeichnis_laenge);
          (* Neuladen nicht notwendig *)
        end;

    end;

  begin
             (* DocFile *)
    ausschrift('D0CF11E0 OLE2 / MS',packer_dat);
    befehl_ole2x;
    if not langformat then Exit;

    if (word_z(@p.d[$1e])^<>9) (* 512 *)
    or (longint_z(@p.d[$20])^<>6) (* 64 *)
     then Exit;

    vielleicht_packword:=false;
    archiv_start;
    verzeichnis:='';
    anzeige(0,Length(''));


    if  vielleicht_packword
    and (archiv_summe_eingepackt<40000)
    and (einzel_laenge>archiv_summe_eingepackt) then
      begin
        f1:=datei_pos_suche(analyseoff+laenge_eingepackt,analyseoff+MinDGT(einzel_laenge,80000),'SZDD');
        if f1<>nicht_gefunden then
          einzel_laenge:=f1-analyseoff;
      end;

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;


  end;

procedure lu_;
  var
    o                   :longint;
    anzahl_eintraege    :byte;
  begin
    ausschrift('LU / Gary Novosielski',packer_dat);
    if not langformat then exit;

    datei_lesen(form_puffer,analyseoff+0,$20);
    anzahl_eintraege:=form_puffer.d[$e];
    o:=$20;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,$20);
      if (form_puffer.d[1]=ord(' '))
      or (form_puffer.d[1]=$00)
       then
        break;

      laenge_eingepackt:=longint(form_puffer.d[$0e])*$80;
      laenge_ausgepackt:=longint(form_puffer.d[$0e])*$80;
      archiv_datei;

      case form_puffer.d[0] of
         0:exezk:='';
       $fe:exezk:=textz_form__eckauf_geloescht_eckzu^;
      else
           exezk:=' [???]';
      end;


      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[1],' ',8)+'.'+puffer_zu_zk_e(form_puffer.d[9],' ',3)+exezk);

      inc(o,$20);
    until o=(anzahl_eintraege+2)*$20;

    archiv_summe;
  end;

procedure rkive(const p:puffertyp;const index:word_norm;const version:byte);
  begin
    if (version<$10)
    or (version>$15)
    or (longint_z(@p.d[index-4-4])^<1)
    or (longint_z(@p.d[index-4-4])^>1000)
     then
      exit;

    ausschrift('RKIVE / Malcolm Taylor '+version_div16_mod16(version),packer_dat);
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    ausschrift(str0(longint_z(@p.d[index-4-4])^)+textz_form__Datei_en__im_Archiv^,packer_dat);
  end;

procedure rk_filearchiver(const p:puffertyp;const index:word_norm);
  var
    anz_dateien:longint;
  begin
    (* nur mit einer Datei probiert: 1.1 *)
    ausschrift('RK File Archiver / Malcolm Taylor '+version_x_y_z(1,p.d[index-4],p.d[index-3]),packer_dat);
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    if p.d[index-4]<2 then (* 1.1.1 *)
      anz_dateien:=longint_z(@p.d[index-$1a])^
    else (* 1.2.5 *)
      anz_dateien:=longint_z(@p.d[index-$1a-4])^;
    ausschrift(str0(anz_dateien)+textz_form__Datei_en__im_Archiv^,packer_dat);
  end;

procedure maxis_archiv;
  var
    o:longint;
  begin
    ausschrift('MAXIS-'+textz_form__Archiv^+' (SimCity 2000) ¯',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,80);
      laenge_ausgepackt:=longint_z(@form_puffer.d[$11])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$00])^;


      if (laenge_eingepackt>laenge_ausgepackt+50) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      exezk:=puffer_zu_zk_e(form_puffer.d[$4],#0,255);

      archiv_datei;

      archiv_datei_ausschrift(exezk);


      inc(o,laenge_eingepackt+$11);
    until o>=einzel_laenge;

    archiv_summe;

  end;

procedure avp_archiv;
  var
    o                   :longint;
    datei_anzahl        :word_norm;
    datei_zaehler       :word_norm;
  begin
    o:=0;
    datei_lesen(form_puffer,analyseoff+o,$80);
    ausschrift('Nice-Install-'+textz_form__Archiv^+' / Data Way Systems  ['
     +textz_form__Diskette^+str0(form_puffer.d[3])+']',packer_dat);
    if (form_puffer.d[3]>1) or (not langformat) then
      exit;

    archiv_start;
    inc(o,$80-8);
    datei_anzahl:=word_z(@form_puffer.d[$6])^;
    for datei_zaehler:=1 to datei_anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+o,$1d+10);

        laenge_ausgepackt:=longint_z(@form_puffer.d[$11+8])^;

        if datei_zaehler=datei_anzahl then
          begin
            if (form_puffer.d[0]=1) (* auf der 1. *)
            and (analyseoff+einzel_laenge>longint_z(@form_puffer.d[$1])^)
            and (analyseoff+einzel_laenge-longint_z(@form_puffer.d[$1])^<laenge_ausgepackt+10)
             then
              laenge_eingepackt:=DGT_zu_longint(analyseoff+einzel_laenge-longint_z(@form_puffer.d[$1])^)
            else
              laenge_eingepackt:=-1;
          end
        else
          begin
            if form_puffer.d[0]<>form_puffer.d[0+$1d] then
              laenge_eingepackt:=-1
            else
              begin
                laenge_eingepackt:=longint_z(@form_puffer.d[$1+$1d])^
                                  -longint_z(@form_puffer.d[$1    ])^;
              end;
          end;

        exezk:=puffer_zu_zk_e(form_puffer.d[1+8],' ',8)+'.'+puffer_zu_zk_e(form_puffer.d[1+8+8],' ',3);
        (*befehl_schnitt(longint_z(@form_puffer.d[$1    ])^,laenge_eingepackt,exezk);*)
        exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);

        if form_puffer.d[0]>1 then
          exezk_anhaengen(' ['+textz_form__Diskette^+str0(form_puffer.d[0])+']');
        archiv_datei;

        if laenge_eingepackt>=0 then
          archiv_datei_ausschrift(exezk)
        else
          ausschrift_x(laenge_ausgepackt_zk+'   ?'+'  '
           +exezk,packer_dat,absatz);
        inc(o,$1d);
      end;

    archiv_summe;

  end;

procedure splint;
  begin
    exezk:=puffer_zu_zk_e(p.d[7],#$0,255);
    laenge_eingepackt:=DGT_zu_longint(einzel_laenge);
    laenge_ausgepackt:=longint_z(@p.d[$3])^;
    archiv_start_leise;
    archiv_datei;
    ausschrift('SPLINT / Kenji Rikitake ( '+exezk+' ) '+laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);
    archiv_summe_leise;

  end;

procedure knowledge;
  var
    o:longint;
  begin
    (* MIROSOUND, ICU *)
    ausschrift('INSTALL - '+textz_form__archiv^+' / Knowledge Dynamics Corp',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,80);

      if not bytesuche(form_puffer.d[$00],'RR') then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          Exit;
        end;

      laenge_ausgepackt:=longint_z(@form_puffer.d[8+$04])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[8+$00])^;

      exezk:=puffer_zu_zk_e(form_puffer.d[8+$12],#0,8+1+3);
      if (laenge_ausgepackt=0) and (laenge_eingepackt>0) then
        begin
          laenge_ausgepackt:=0;
          exezk_anhaengen(textz_form__leer_eckauf_Fortsetzung_eckzu^);
        end
      else
        if (laenge_eingepackt>laenge_ausgepackt+50) then
          begin
            ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
            Exit;
          end;

      archiv_datei;

      archiv_datei_ausschrift(exezk);

      inc(o,laenge_eingepackt);
      inc(o,$21+8);

    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure wic;
  var
    o:longint;
  begin
    ausschrift('Wavelet-based Inteligent Compressor / Robert DEBRAYEL',packer_dat);
    ausschrift(textz_form__wictext_1^,virus);
    ausschrift(textz_form__wictext_2^,virus);

    if not langformat then exit;

    o:=8;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,80);
      laenge_ausgepackt:=longint_z(@form_puffer.d[$27])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$2b])^;


      if (laenge_eingepackt>laenge_ausgepackt+50) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      exezk:=puffer_zu_zk_pstr(form_puffer.d[$0]);

      archiv_datei;

      archiv_datei_ausschrift(exezk);


      inc(o,laenge_eingepackt+$36);
    until o>=einzel_laenge;

    archiv_summe;

  end;

procedure stuffit(const laenge:longint);
  var
    o:longint;

  procedure sit_rekursiv(o:longint;const pfad:string;const anzahl:word);
    var
      name              :string;
      naechster_anfang  :longint;
      zaehler           :longint;
    begin
      for zaehler:=1 to anzahl do
        begin
          datei_lesen(form_puffer,analyseoff+o,512);
          naechster_anfang:=m_longint(form_puffer.d[$36]);
          exezk:=puffer_zu_zk_pstr(form_puffer.d[$02]);

          if bytesuche(form_puffer.d[$42],#$00#$00) then
            begin (* Verzeichnis *)
              ausschrift(textz_form__eckauf_Verzeich_punkt_eckzu^+pfad+exezk+'\',packer_dat);
              sit_rekursiv(m_longint(form_puffer.d[$3e]),pfad+exezk+'\',m_word(form_puffer.d[$30]));
            end
          else
            begin (* Datei *)
              laenge_ausgepackt:=m_longint(form_puffer.d[$54]);
              laenge_eingepackt:=m_longint(form_puffer.d[$5c]);

              if (laenge_eingepackt>laenge_ausgepackt+$70) then
                ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);

              archiv_datei;
              ausschrift_x('['+puffer_zu_zk_l(form_puffer.d[$42],4)+'/'+puffer_zu_zk_l(form_puffer.d[$46],4)+'] '
                          +pfad+exezk,packer_dat,absatz);
              archiv_datei_ausschrift('Rsrc ');

              laenge_ausgepackt:=m_longint(form_puffer.d[$58]);
              laenge_eingepackt:=m_longint(form_puffer.d[$60]);


              if (laenge_eingepackt>laenge_ausgepackt+$70) then
                ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);

              archiv_datei;
              dec(archiv_summen_dateien);

              archiv_datei_ausschrift('Data ');
            end;

          o:=naechster_anfang;
        end;
    end;


  begin
    ausschrift('StuffIt / Raymond Lau',packer_dat);
    if not langformat then exit;

    archiv_start;
    datei_lesen(form_puffer,analyseoff,$16);
    einzel_laenge:=m_longint(form_puffer.d[$06]);
    o            :=m_longint(form_puffer.d[$10]);
    sit_rekursiv(o,'',m_word(form_puffer.d[$04]));

    archiv_summe;
    einzel_laenge:=laenge;
  end;

procedure stuffit_510(const p:puffertyp);

  procedure stuffit_510_proc(o:longint;const verzeichnis:string);
    var
      naechster         :longint;
      a                   :word_norm;
    begin
      repeat
        datei_lesen(form_puffer,analyseoff+o,512);
        if not bytesuche(form_puffer.d[0],#$a5#$a5#$a5#$a5) then
          begin
            ausschrift(textz_Archiv_Fehler_fragezeichen^,signatur);
            Break;
          end;

        naechster:=m_longint(form_puffer.d[$16]);

        (* Machmal ist ^M im Name enthalten *)
        exezk:=verzeichnis+leer_filter(puffer_zu_zk_e(form_puffer.d[$a2-$72],#0,255));
        if (form_puffer.d[$09] and $40)=$40 then
          begin
            (* Ende einer Kette - nach .. absteigen *)
            if m_longint(form_puffer.d[$22])=$ffffffff then
              Exit;
            (* Verzeichnis 40 *)
            laenge_ausgepackt:=0;
            laenge_eingepackt:=0;
            archiv_datei;
            archiv_datei_ausschrift_verzeichnis(exezk);
            stuffit_510_proc(m_longint(form_puffer.d[$22]),exezk+'\');
          end
        else
          begin
            (* Datei 00 *)
            a:=form_puffer.d[7]+4;
            if Odd(form_puffer.d[4] shr 1) then
              begin (* ohne Data/Rsrc *)
                laenge_ausgepackt:=m_longint(form_puffer.d[$22]);
                laenge_eingepackt:=m_longint(form_puffer.d[$26]);
                archiv_datei;
                archiv_datei_ausschrift(exezk);
              end
            else
              begin (* MAC *)
                exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
                exezk_anhaengen(' ['+puffer_zu_zk_l(form_puffer.d[a],4)+'/'+puffer_zu_zk_l(form_puffer.d[a+4],4)+']');
                laenge_ausgepackt:=m_longint(form_puffer.d[$22]);
                laenge_eingepackt:=m_longint(form_puffer.d[$26]);
                archiv_datei;
                archiv_datei_ausschrift(exezk+' [Data]');
                laenge_ausgepackt:=m_longint(form_puffer.d[a+$20]);
                laenge_eingepackt:=m_longint(form_puffer.d[a+$24]);
                archiv_datei;
                archiv_datei_ausschrift(exezk+' [Rsrc]');
                Dec(archiv_summen_dateien);
              end;
          end;

        if naechster<o then Break;
        o:=naechster;
      until (o>=einzel_laenge);
    end;

  begin
    ausschrift('StuffIt / Raymond Lau; Alladin Systems'+version161616(m_word(p.d[$52])),packer_dat);
    if not langformat then Exit;

    archiv_start;

    exezk_leerzeichen_erweiterung(36);
    exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);

    stuffit_510_proc(m_longint__datei_lesen(analyseoff+$58),'');

    archiv_summe_eingepackt:=m_longint__datei_lesen(analyseoff+$54);
    archiv_summe;

  end;

procedure dda2;
  var
    o                   :longint;
    pfad_tabelle        :array[1..10] of string[30];
    pfadtiefe           :byte;
    w1                  :word_norm;
  begin
    ausschrift('DiskDoubler / Symantec',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    pfadtiefe:=0;
    pfad:='';

    repeat;
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'DDA2') then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      case form_puffer.d[4] of
        $00:
          begin
            (* Anfang *)
            inc(o,form_puffer.d[5]);
          end;
        $10:
          begin
            (* TRAIN.SEA *)
            ausschrift_x(
               '['+puffer_zu_zk_l(form_puffer.d[$3e],4)+'/'+puffer_zu_zk_l(form_puffer.d[$3e+4],4)+'] '
              +pfad+puffer_zu_zk_pstr(form_puffer.d[6]),packer_dat,absatz);
            inc(o,m_longint(form_puffer.d[$2a]));

            laenge_ausgepackt:=m_longint(form_puffer.d[$2a]);
            laenge_eingepackt:=laenge_ausgepackt;
            archiv_datei;
            archiv_datei_ausschrift('Rsrc ');
            (* keine Testmîglichkeit vorhanden *)
            laenge_ausgepackt:=m_longint(form_puffer.d[$2a+4]);
            laenge_eingepackt:=laenge_ausgepackt;
            archiv_datei;
            dec(archiv_summen_dateien);
            archiv_datei_ausschrift('Data ');

          end;
        $50:
          begin
            ausschrift_x(
               '['+puffer_zu_zk_l(form_puffer.d[$58],4)+'/'+puffer_zu_zk_l(form_puffer.d[$58+4],4)+'] '
              +pfad+puffer_zu_zk_pstr(form_puffer.d[6]),packer_dat,absatz);
            inc(o,m_longint(form_puffer.d[$2a]));

            laenge_ausgepackt:=m_longint(form_puffer.d[$3c+0]);
            laenge_eingepackt:=m_longint(form_puffer.d[$3c+4]);
            archiv_datei;
            archiv_datei_ausschrift('Rsrc ');
            laenge_ausgepackt:=m_longint(form_puffer.d[$3c+8]);
            laenge_eingepackt:=m_longint(form_puffer.d[$3c+12]);
            archiv_datei;
            dec(archiv_summen_dateien);
            archiv_datei_ausschrift('Data ');

          end;
        $90:
          begin
            (* Verzeichnis *)
            if form_puffer.d[$29]>10 then
              begin
                ausschrift(textz_form__Verzeichnisverschatelung_zu_gross^,dat_fehler);
                exit;
              end;
            pfadtiefe:=form_puffer.d[$29];
            pfad_tabelle[pfadtiefe]:=puffer_zu_zk_pstr(form_puffer.d[6]);
            pfad:='';
            for w1:=2 to pfadtiefe do
              pfad:=pfad+pfad_tabelle[w1]+'\';

            if pfad<>'' then
              begin
                ausschrift(textz_form__eckauf_Verzeich_punkt_eckzu^+pfad,packer_dat);
                laenge_ausgepackt:=0;
                laenge_eingepackt:=0;
                archiv_datei;
              end;
            inc(o,m_longint(form_puffer.d[$2a]));
          end;
        $bb:
          (* Ende *)
          break;
      else
        ausschrift(textz_unbekannter_Datenblocktyp^+'¯',dat_fehler);
        break;
      end;

    until o>=einzel_laenge;

    archiv_summe;

  end;

procedure pit;
  var
    o:longint;
  label
    pit_schleife,
    pit_ende_ohen_fehler;
  begin
    ausschrift('PackIt / Harry Chesley ¯',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    pit_schleife:
    datei_lesen(form_puffer,analyseoff+o,$60);

    if bytesuche(form_puffer.d[0],'PEnd') then goto pit_ende_ohen_fehler;
    if bytesuche(form_puffer.d[0],'PMag') then
      begin
        inc(o,$64);
        laenge_ausgepackt:=m_longint(form_puffer.d[4+$4c]);
        laenge_eingepackt:=m_longint(form_puffer.d[4+$4c]);

        archiv_datei;

        ausschrift_x(puffer_zu_zk_pstr(form_puffer.d[4+0]),packer_dat,absatz);
        archiv_datei_ausschrift('Data');

        inc(o,laenge_eingepackt);

        laenge_ausgepackt:=m_longint(form_puffer.d[4+$4c+4]);
        laenge_eingepackt:=m_longint(form_puffer.d[4+$4c+4]);

        archiv_datei;
        dec(archiv_summen_dateien);

        archiv_datei_ausschrift('Rsrc');

        inc(o,laenge_eingepackt);

        goto pit_schleife;
      end;

    if bytesuche(form_puffer.d[0],'PM') then
      ausschrift_x(textz_form__TYP_unterstuetzt_Kompression_nicht^,dat_fehler,absatz)
    else
      ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);

    exit;

    pit_ende_ohen_fehler:

    archiv_summe;

  end;

procedure binhex(const doppelpunkt_anfang:word_norm);
  var
    o                   :word_norm;
    lese_index          :word_norm;
    vierer              :array[0..3] of byte;
    l1                  :longint;
    entschluesselt      :puffertyp;
    w1,w2,w3            :word_norm;

  const
    hqx_00_12:set of char=['!'..'-'];
    hqx_13_19:set of char=['0'..'6'];
    hqx_20_21:set of char=['8'..'9'];
    hqx_22_36:set of char=['@'..'N'];
    hqx_37_43:set of char=['P'..'V'];
    hqx_44_47:set of char=['X'..'['];
    hqx_48_54:set of char=['`'..'f'];
    hqx_55_60:set of char=['h'..'m'];
    hqx_61_63:set of char=['p'..'r'];
  label
    zeichen_suche;
  begin
    ausschrift('Binhex [HQX7]',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=0;
    datei_lesen(form_puffer,analyseoff+o,$200);
    o:=doppelpunkt_anfang;

    while (o<$200) and (form_puffer.d[o]<>ord(':')) do
      Inc(o);

    if (o>=$200) then
      begin
        ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
        Exit;
      end;

    Inc(o);

    datei_lesen(form_puffer,analyseoff+o,$200);
    lese_index:=0;

    for w1:=0 to (150 div 3) do
      begin
        for w2:=0 to 3 do
          begin
            zeichen_suche:
                 if chr(form_puffer.d[lese_index]) in hqx_00_12 then vierer[w2]:=(form_puffer.d[lese_index]-ord('!')+ 0)
            else if chr(form_puffer.d[lese_index]) in hqx_13_19 then vierer[w2]:=(form_puffer.d[lese_index]-ord('0')+13)
            else if chr(form_puffer.d[lese_index]) in hqx_20_21 then vierer[w2]:=(form_puffer.d[lese_index]-ord('8')+20)
            else if chr(form_puffer.d[lese_index]) in hqx_22_36 then vierer[w2]:=(form_puffer.d[lese_index]-ord('@')+22)
            else if chr(form_puffer.d[lese_index]) in hqx_37_43 then vierer[w2]:=(form_puffer.d[lese_index]-ord('P')+37)
            else if chr(form_puffer.d[lese_index]) in hqx_44_47 then vierer[w2]:=(form_puffer.d[lese_index]-ord('X')+44)
            else if chr(form_puffer.d[lese_index]) in hqx_48_54 then vierer[w2]:=(form_puffer.d[lese_index]-ord('`')+48)
            else if chr(form_puffer.d[lese_index]) in hqx_55_60 then vierer[w2]:=(form_puffer.d[lese_index]-ord('h')+55)
            else if chr(form_puffer.d[lese_index]) in hqx_61_63 then vierer[w2]:=(form_puffer.d[lese_index]-ord('p')+61)
            else if chr(form_puffer.d[lese_index])=':' then break
            else
              begin
                inc(lese_index);
                goto zeichen_suche;
              end;

            inc(lese_index);
          end;

        if chr(form_puffer.d[lese_index])=':' then break;
        l1:=longint(vierer[3])+longint(vierer[2]) shl 6+longint(vierer[1]) shl 12+longint(vierer[0]) shl 18;

        form_puffer.d[w1*3+2]:=(l1 shr  0) and $ff;
        form_puffer.d[w1*3+1]:=(l1 shr  8) and $ff;
        form_puffer.d[w1*3+0]:=(l1 shr 16) and $ff;
      end;

    w1:=0;
    w2:=0;
    while (w1<$100) and (w2<$100) do
      begin
        entschluesselt.d[w1]:=form_puffer.d[w2];
        if (form_puffer.d[w2+1]=$90) and (form_puffer.d[w2+2]<>0) then
          begin
            for w3:=2 to form_puffer.d[w2+2] do
              begin
                inc(w1);
                if w1>=$100 then break;
                entschluesselt.d[w1]:=form_puffer.d[w2];
              end;
            inc(w2,2);
          end;
        inc(w1);
        inc(w2);
      end;


    w1:=entschluesselt.d[0]+2;

    laenge_ausgepackt:=m_longint(entschluesselt.d[w1+$0a]);
    laenge_eingepackt:=-1;
    archiv_datei;

    ausschrift_x('['+puffer_zu_zk_l(entschluesselt.d[w1+0],4)+'/'+puffer_zu_zk_l(entschluesselt.d[w1+4],4)+'] '
     +puffer_zu_zk_pstr(entschluesselt.d[0]),packer_dat,absatz);
    ausschrift_x(laenge_ausgepackt_zk+'   ?'+'  '
      +'Data ',packer_dat,absatz);

    laenge_ausgepackt:=m_longint(entschluesselt.d[w1+$0a+4]);
    laenge_eingepackt:=-1;
    archiv_datei;
    dec(archiv_summen_dateien);
    ausschrift_x(laenge_ausgepackt_zk+'   ?'+'  '
      +'Rsrc ',packer_dat,absatz);


    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;

    archiv_summe;
  end;

procedure dune_pak;
  var
    o,
    o_anfang,
    o_ende              :dateigroessetyp;

  begin
    ausschrift(textz_form__unbekannte_Bibliotheksdatei^+' <Dune2/WestWood>',packer_dat);
    (* auch Kyrandia *)
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat;
      datei_lesen(form_puffer,analyseoff+o,20);
      o_anfang:=longint_z(@form_puffer.d[0])^;
      if o_anfang=0 then break;

      exezk:=puffer_zu_zk_e(form_puffer.d[4],#0,8+1+3);
      o_ende:=longint_z(@form_puffer.d[4+length(exezk)+1])^;
      IncDGT(o,4+Length(exezk)+1);
      if o_ende=0 then
        o_ende:=einzel_laenge;


      laenge_eingepackt64:=o_ende-o_anfang;
      laenge_ausgepackt64:=laenge_eingepackt;
      if laenge_eingepackt=0 then Break; (* KYRANDIA 2 - HOF *)

      archiv_datei64;

      archiv_datei_ausschrift(exezk);

    until false;

    archiv_summe;
  end;

procedure codec;
  var
    o:longint;
  begin
    ausschrift('CODEC / TELEVOX TELEINFORMATICA',packer_dat);
    if not langformat then exit;

    o:=$33;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      if not bytesuche(form_puffer.d[0],'w'#$ff'x'#$ff) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      laenge_ausgepackt:=longint_z(@form_puffer.d[$0a])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$12])^;


      if form_puffer.d[$2c]=0 then
        exezk:=''
      else
        exezk:=puffer_zu_zk_l(form_puffer.d[$32],form_puffer.d[$2c]-1)+'\';

      exezk_anhaengen(puffer_zu_zk_l(form_puffer.d[$32+form_puffer.d[$2c]],form_puffer.d[$2d]));

      archiv_datei;

      archiv_datei_ausschrift(exezk);

      inc(o,laenge_eingepackt);
    until o=einzel_laenge;

    archiv_summe;
  end;

procedure sqpc(const p:puffertyp);
  begin
    exezk:=puffer_zu_zk_e(p.d[4],#0,12);
    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=-1;
    archiv_start_leise;
    archiv_datei64;
    ausschrift('SQPC / Richard Greenslaw ( '+exezk+' )',packer_dat);
    archiv_summe_leise;
  end;

procedure ain_22(const p:puffertyp);
  begin
    if (longint_z(@p.d[$e])^>einzel_laenge)
    or (longint_z(@p.d[$e])^<200)
    or (word_z(@p.d[8])^=0)
    or (word_z(@p.d[8])^>9000)
     then
      exit;

    ausschrift('AIN / Transas Marine [2.2,3], '+str0(word_z(@p.d[8])^)+textz_datei_klammerauf_en_klammerzu^,packer_dat);
    archiv_start_leise;
    archiv_summen_dateien:=p.d[8];
    archiv_summe_ausgepackt_unbekannt:=true;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_leise;
  end;

procedure pronews;
  var
    aoo,
    elo                 :dateigroessetyp;
    form_puffer2        :puffertyp;
  begin
    ausschrift('Pronews2 / Panacea Software ...',packer_dat); (* 1.51.ib110 *)

    if not langformat then exit;
    aoo:=analyseoff;
    elo:=einzel_laenge;
    while analyseoff<aoo+elo do
      begin
        ausschrift_leerzeile;
        datei_lesen(form_puffer2,analyseoff,$10);
        IncDGT(analyseoff,$10);
        einzel_laenge:=longint_z(@form_puffer2.d[4])^;
        (*ausschrift(str0(einzel_laenge),normal);*)
        sendmail('',true,'');
        IncDGT(analyseoff,einzel_laenge);
      end;
    analyseoff:=aoo;
    einzel_laenge:=elo;

  end;

procedure elm_oder_nntp(const p:puffertyp);
  var
    gruppe_o            :dateigroessetyp;
    gruppe              :string;
  begin
    gruppe:='';

    gruppe_o:=datei_pos_suche(analyseoff,analyseoff+MinDGT(1200,einzel_laenge),#10'Newsgroups: ');
    if gruppe_o<>nicht_gefunden then
      gruppe:=datei_lesen__zu_zk_zeilenende(gruppe_o+Length(#10'Newsgroups: '));

    if (gruppe<>'')
    or (puffer_anzahl_suche(p,'Received: ',$150)>0)
    or puffer_gefunden(p,#$0a'X-Mailer: ') (* PMMAIL Entwurf *)
    or puffer_gefunden(p,#$0a'Subject: ')
    or puffer_gefunden(p,#$0a'Delivered-To: ') (* PMMAIL von GMX mit POP *)
    or puffer_gefunden(p,#$0a'Date: ') then
      sendmail(gruppe,false,'')
    else
    if puffer_gefunden(p,'Content-Transfer-Encoding: binary') then
      begin
        (* I-Worm.Mimail.a
           TrojanDropper.JS.Mimail.b *)
        gruppe_o:=datei_pos_suche(analyseoff,analyseoff+MinDGT(1200,einzel_laenge),#$0a#$0a);
        if gruppe_o<>nicht_gefunden then
          einzel_laenge:=gruppe_o+Length(#$0a#$0a)-analyseoff;
        gruppe_o:=datei_pos_suche(analyseoff,analyseoff+MinDGT(1200,einzel_laenge),#$0a'Content-Location:File://');
        if gruppe_o<>nicht_gefunden then
          ausschrift('MIME: '+datei_lesen__zu_zk_zeilenende(gruppe_o+Length(#$0a'Content-Location:File://')),packer_dat);
      end;
  end;

procedure sendmail(const nntp_gruppe:string;const nur_ein_beitrag:boolean;const prefix:string);
(*$IfNDef ENVERSION*)
  (*$Define X_MAILER*)
(*$EndIf ENDVERSION*)
  var
    o,o5000             :dateigroessetyp;
    pos_subject         :dateigroessetyp;
    pos_content_length  :dateigroessetyp;
    pos_status          :dateigroessetyp;
    pos_from            :dateigroessetyp;
    (*$IfDef X_MAILER*)
    pos_x_mailer        :dateigroessetyp;
    (*$EndIf*)
    pos_boundary        :dateigroessetyp;
    test_dateilaenge    :dateigroessetyp;
    boundary_sig        :string;
    block_ende          :dateigroessetyp;
    zeile               :string;
    w1,w2               :word_norm;
    dl1                 :dateigroessetyp;
    zz                  :word_norm;

  procedure puffer_zu_zk_zeilenende_oder_eingerueckt_ende(const p;const l:integer_norm);
    var
      pp                :speicherbereich_z;
      pp_byte           :^byte absolute pp;
      u                 :integer_norm;
      jetzt             :string;
    begin
      exezk:=puffer_zu_zk_zeilenende(p,l);
      u:=l-Length(exezk);
      pp:=Addr(p);
      Inc(pp_byte,Length(exezk));
      while u>3 do
        begin
          (* 2 Zeichen Zeileumbruch *)
          if (pp^[0]=$0d) and (pp^[1]=$0a) then
            begin
              Inc(pp_byte,2);
              Dec(u,2);
            end
          else
          if pp^[0] in [$0d,$0a] then
            begin
              Inc(pp_byte);
              Dec(u);
            end
          else
            Break;

          if not (pp^[0] in [Ord(' '),$09]) then
            Break;
          Inc(pp_byte);
          Dec(u);

          while (u>0) and (pp^[0] in [Ord(' '),$09]) do
            begin
              Inc(pp_byte);
              Dec(u);
            end;

          jetzt:=puffer_zu_zk_zeilenende(pp^,u);
          if jetzt='' then Break;

          exezk:=exezk+jetzt;
          Inc(pp_byte,Length(jetzt));
          Dec(u,Length(jetzt));

        end;
    end; (* puffer_zu_zk_zeilenende_oder_eingerueckt_ende *)

  function element_anzeige(von,bis:dateigroessetyp;const was_gross:string;wie:aus_attribute):boolean;
    var
      p                 :dateigroessetyp;
      l                 :word_norm;
    begin
      element_anzeige:=false;

      p:=datei_pos_suche_gross(o,pos_status,#$0a+was_gross+': ');
      l:=Length(#$0a)+Length(was_gross)+Length(': ');

      if p=nicht_gefunden then
        begin
          p:=datei_pos_suche_gross(o,pos_status,#$0a'X-'+was_gross+': ');
          Inc(l,Length('X-'));
        end;

      if p=nicht_gefunden then
        Exit;

      IncDGT(p,l);
      element_anzeige:=true;
      datei_lesen(form_puffer,p,512);
      ausschrift_x(prefix+puffer_zu_zk_zeilenende(form_puffer.d[0],70),wie,absatz);
    end; (* element_anzeige *)

  begin
    if not nur_ein_beitrag then
      begin
        if nntp_gruppe='' then
          ausschrift('Sendmail/Formail/..',musik_bild)
        else
          ausschrift('nntp: '+nntp_gruppe,musik_bild);
      end;
    if not langformat then exit;

    o:=analyseoff;
    repeat
      if o<>analyseoff then
        begin
          if nur_ein_beitrag then Exit;
          ausschrift_leerzeile;
        end;


      o5000:=MinDGT(o+5000,analyseoff+einzel_laenge);

      pos_subject       :=datei_pos_suche_zeilenanfang_gross(o,o5000,'SUBJECT: ');
      (*$IfDef LAENGE_BEACHTEN*)
      pos_content_length:=datei_pos_suche_zeilenanfang_gross(o,o5000,'CONTENT-LENGTH: ');
      (*$EndIf*)
     {pos_status        :=datei_pos_suche_gross(o-1,o5000,#$0a'STATUS: ');
      if pos_status=nicht_gefunden then}
        begin
          pos_status:=datei_pos_suche(o,o5000,#$0a#$0a);
          if pos_status=nicht_gefunden then
            pos_status:=datei_pos_suche(o,o5000,#$0d#$0a#$0d#$0a);
          if pos_status=nicht_gefunden then
            pos_status:=analyseoff+einzel_laenge;

        end;


      (* FROM *)
      pos_from:=datei_pos_suche_zeilenanfang_gross(pos_status,o,'FROM: ');
      if pos_from<>nicht_gefunden then
        datei_lesen(form_puffer,pos_from+Length('FROM: '),512)
      else
        begin
          pos_from:=datei_pos_suche_zeilenanfang_gross(pos_status,o,'FROM ');
          if pos_from<>nicht_gefunden then
            datei_lesen(form_puffer,pos_from+Length('FROM '),512)
        end;

      if pos_from<>nicht_gefunden then
        begin
          puffer_zu_zk_zeilenende_oder_eingerueckt_ende(form_puffer.d[0],160);
          umformung_quote_base64;
          ausschrift_x(prefix+exezk,signatur,absatz);
        end;

      (* SUBJECT *)
      if pos_subject<>nicht_gefunden then
        begin
          datei_lesen(form_puffer,pos_subject,512);
          puffer_zu_zk_zeilenende_oder_eingerueckt_ende(form_puffer.d[Length('SUBJECT: ')],160);
          umformung_quote_base64;
          ausschrift_x(prefix+exezk,beschreibung,absatz)
        end;

      (*$IfDef X_MAILER*)
      pos_x_mailer:=0;
      if pos_status<>nicht_gefunden then
        begin
          if not element_anzeige(o,pos_status,'MAILER',compiler) then
            (*if nntp_gruppe<>'' then
              begin*)
                if not element_anzeige(o,pos_status,'USER-AGENT',compiler) then
                if not element_anzeige(o,pos_status,'NEWSREADER',compiler) then
                if not element_anzeige(o,pos_status,'NEWSEDITOR',compiler) then
                if not element_anzeige(o,pos_status,'MAILCONVERTER',compiler) then
              (*end;*)

        end;
      (*$EndIf*)

      (*$IfDef LAENGE_BEACHTEN*)
      lÑngenteil ignorieren ...

      (* LÑngenberechnung *)
      if  (pos_content_length<>nicht_gefunden)
      and (pos_status        <>nicht_gefunden)
       then
        begin
          datei_lesen(form_puffer,pos_content_length,512);
          test_dateilaenge:=ziffer(10,puffer_zu_zk_zeilenende(form_puffer.d[Length('CONTENT-LENGTH: ')],10));
          if test_dateilaenge>0 then
            begin
              datei_lesen(form_puffer,pos_status,512);
              o:=pos_status
                +length(puffer_zu_zk_zeilenende(form_puffer.d[1],80))
                +test_dateilaenge;

              (* Dateiende? *)
              if (o<=dateilaenge) and (o+20>dateilaenge) then
                begin
                  einzel_laenge:=dateilaenge+analyseoff;
                  exit;
                end;

              (* ein paar ZeilenumbrÅche dazurechnen? *)
              datei_lesen(form_puffer,o,100);
              pos_from:=puffer_pos_suche(form_puffer,'From ',20);
              if pos_from<>nicht_gefunden then
                inc(o,pos_from);

            end
          else (* Fehler bei Berechnung LÑnge Inhalt *)
            begin
              ausschrift(prefix+'???',dat_fehler);
              Break;
            end;
        end
      else
      (*$EndIf*)

        (* keine LÑnegenangaben *)
        begin
          pos_boundary:=datei_pos_suche_gross(o,pos_status,'BOUNDARY=');

          if pos_boundary=nicht_gefunden then
            begin (* keine mehrteilige Nachricht *)
              (* mÅhselige Suche nach dem nÑchsten Anfang .. *)
              o:=pos_status;
              repeat
                pos_from:=datei_pos_suche_gross(o,analyseoff+einzel_laenge,#$0a'FROM');
                if pos_from=nicht_gefunden then
                  begin
                    o:=analyseoff+einzel_laenge;
                    Break;
                  end;
                if pos_from>analyseoff+13 then
                  if bytesuche__datei_lesen(pos_from+1-2,#$0a#$0a)
                  or bytesuche__datei_lesen(pos_from+1-4,#$0d#$0a#$0d#$0a) then
                    if bytesuche__datei_lesen(pos_from+Length(#$0a'FROM'),' ')
                    or bytesuche__datei_lesen(pos_from+Length(#$0a'FROM'),': ') then
                      begin
                        o:=pos_from+Length(#$0a);
                        Break;
                      end;
                IncDGT(o,Length(#$0a'FROM'));
              until false;
              (* FROM: oder Ende gefunden -> dort weiterarbeiten *)
              Continue;
            end;

          (* mehrteilig, anzeigen *)

          datei_lesen(form_puffer,pos_boundary+Length('boundary='),80);
          if form_puffer.d[0]=Ord('"') then
            boundary_sig:=puffer_zu_zk_e(form_puffer.d[1],'"',70)
          else
            boundary_sig:=puffer_zu_zk_zeilenende(form_puffer.d[0],120);

          if (Length(boundary_sig)<3)
          and (boundary_sig<>'-')
           then
            begin (* Fehler aufgetreten *)
              ausschrift(prefix+'???',dat_fehler);
              Break;
            end;

          (* 'CONTENT-TYPE: APPLICATION/OCTET-STREAM; NAME="VEIT-KANNEGIESER_GMX-DE.KEY"'
             wÅrde bei Trennung '-' gefunden werden - dfsee reg/mensys *)
          Insert('--',boundary_sig,1);


          o:=pos_status; (* Anfang der Suche nach dem Kopf *)
          repeat (* alle mime-Blîcke.. *)

            (* Trennfolge suchen *)
            block_ende:=datei_pos_suche_zeilenanfang(o,analyseoff+einzel_laenge,boundary_sig);
            if block_ende=nicht_gefunden then
              begin (* unerwartetes Dateiende *)
                ausschrift(prefix+'??? ('+boundary_sig+')',dat_fehler);
                o:=dateilaenge;
                Break;
              end;

            (* Ende des Blockes: boundary+'--' *)
            if bytesuche__datei_lesen(block_ende,boundary_sig+'--') then
              begin
                o:=block_ende+Length(boundary_sig)+Length('--');
                weiter_bis_zum_naechsten_zeilenanfang(o);
                Break;
              end;

            (* was kommt nach der Trennfolge? *)
            o:=block_ende+Length(boundary_sig);
            weiter_bis_zum_naechsten_zeilenanfang(o);

            {
            (* 'From: ' - Anfang der nÑchsten Nachricht *)
            pos_from:=datei_pos_suche_gross(o-1,o+13,#$0a'FROM: ');
            if pos_from=nicht_gefunden then
              pos_from:=datei_pos_suche_gross(o-1,o+13,#$0a'FROM ');
            if pos_from<>nicht_gefunden then
              begin
                o:=pos_from+1;
                Break;
              end;}

            (* Ende des aktuellen Blockes ermitteln *)
            block_ende:=datei_pos_suche(o,analyseoff+einzel_laenge,boundary_sig);
            if block_ende=nicht_gefunden then
              block_ende:=analyseoff+einzel_laenge;

            zz:=0;
            while (zz<20) and (o<block_ende) do
              begin
                Inc(zz);
                exezk:=gross(datei_lesen__zu_zk_zeilenende(o));
                if exezk='' then
                  begin
                    weiter_bis_zum_naechsten_zeilenanfang(o);
                    Continue;
                  end

                {
                else
                (* 'From: ' - Anfang der nÑchsten Nachricht *)
                if bytesuche(exezk[1],'FROM: ')
                or bytesuche(exezk[1],'FROM ') then
                  Break}

                else
                (* schimm 2000.06.27 hat 3 Zeilen MIME-Warnung als Klartext (UMAIL) *)
                if bytesuche(exezk[1],'CONTENT-LOCATION:')
                or bytesuche(exezk[1],'CONTENT-TRANSFER-ENCODING:')
                or bytesuche(exezk[1],'CONTENT-DISPOSITION:')
                or bytesuche(exezk[1],'CONTENT-TYPE:')
                or bytesuche(exezk[1],'CONTENT-DESCRIPTION:') then
                  begin
                    dl1:=block_ende-o;
                    mime_encode(o,dl1,true,prefix);
                    o:=block_ende;
                    Break;
                  end

                else
                if zeile=gross(boundary_sig) then
                  Break; (* hier ist der MIME-Block wirklich zu Ende *)

                IncDGT(o,Length(exezk)+1);
                weiter_bis_zum_naechsten_zeilenanfang(o);
              end; (* zz<20 *)

          until false; (* alle MIME-Blîcke *)

          while o<analyseoff+einzel_laenge do
            begin
              datei_lesen(form_puffer,o,1);
              if form_puffer.d[0] in [10,13] then
                o:=o+1
              else
                Break;
            end;

        end; (* keine LÑngenangaben *)


    until o>=analyseoff+einzel_laenge;

  end;


procedure compactor(vo:dateigroessetyp);
  var
    pfad                :string;
    programm            :string[20];
  begin
    ausschrift('Compactor Pro / Bill Goodman',packer_dat);
    if not langformat then exit;

    IncDGT(vo,6);
    archiv_start;

    datei_lesen(form_puffer,analyseoff+vo,512);
    if form_puffer.d[0]>0 then
      begin
        (* Kommentar *)
        ansi_anzeige(analyseoff+vo+1,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
        ,analyseoff+vo+1+form_puffer.d[0],'');
        incDGT(vo,form_puffer.d[0]);
      end;

    pfad:='';
    IncDGT(vo,1);

    repeat
      datei_lesen(form_puffer,analyseoff+vo,512);
      if bytesuche(form_puffer.d[0],#0#0#0#0#0#0#0) then break;
      exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
      if pos(#0,exezk)=0 then
        begin
          (* Datei *)
          programm:='['+puffer_zu_zk_l(form_puffer.d[1+form_puffer.d[0]+5],4)
                   +'/'+puffer_zu_zk_l(form_puffer.d[1+form_puffer.d[0]+5+4],4)+'] ';

          ausschrift_x(programm+pfad+exezk,packer_dat,absatz);

          laenge_ausgepackt:=m_longint(form_puffer.d[1+form_puffer.d[0]+6+33-10]);
          laenge_eingepackt:=m_longint(form_puffer.d[1+form_puffer.d[0]+6+33+8-10]);
          archiv_datei;
          archiv_datei_ausschrift('Data');

          laenge_ausgepackt:=m_longint(form_puffer.d[1+form_puffer.d[0]+6+33-10+4]);
          laenge_eingepackt:=m_longint(form_puffer.d[1+form_puffer.d[0]+6+33+8-10+4]);
          archiv_datei;
          dec(archiv_summen_dateien);
          archiv_datei_ausschrift('Rsrc');

          IncDGT(vo,1+length(exezk));
          IncDGT(vo,$2d);
        end
      else
        begin
          (* Verzeichnis *)
          exezk:=puffer_zu_zk_e(form_puffer.d[1],#0,255);
          laenge_ausgepackt:=0;
          laenge_eingepackt:=0;
          archiv_datei;
          ausschrift(textz_form__eckauf_Verzeich_punkt_eckzu^+pfad+exezk,packer_dat);
          pfad:=pfad+exezk+'\';
          IncDGT(vo,1+Length(exezk));
          IncDGT(vo,$2);
        end;

    until vo>=einzel_laenge;

    archiv_summe;

    if einzel_laenge>vo then
      einzel_laenge:=vo;

  end;

procedure origin_tre(const anzahl:word);
  var
    w1                  :word_norm;
  begin
    (* Strike Commander,Privateer *)
    ausschrift(textz_form__Verzeichnisbaum^+' / Origin',packer_dat);
    if not langformat then exit;

    archiv_start;
    for w1:=1 to anzahl do
      begin
        datei_lesen(form_puffer,w1*$4a-$4a+4,512);
        laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[5],#0,$4a));
      end;
    archiv_summe;
  end;

procedure goblins_stk(const anzahl:word);
  var
    w1                  :word_norm;
  begin
    ausschrift('.STK Goblins '+textz_form__klammer_Einzeldateien_noch_komprimiert_klammer^,packer_dat);
    if not langformat then exit;

    archiv_start;
    for w1:=1 to anzahl do
      begin
        datei_lesen(form_puffer,(w1-1)*$16+2,512);
        laenge_eingepackt:=longint_z(@form_puffer.d[$d])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,8+1+3));
      end;
    archiv_summe;
  end;

procedure compak(const o:dateigroessetyp);
  var
    w1                  :word_norm;
  begin
    ausschrift('COM-'+textz_form__Bibliothek^+' COMPAK / Jack A. Orman [1.0,1.1,1.2]',packer_exe);
    if not langformat then exit;

    ansi_anzeige(analyseoff+o+3,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
              ,unendlich,'');

    datei_lesen(form_puffer,analyseoff+o+$40,$160);
    for w1:=0 to 15 do
      begin
        if form_puffer.d[w1*$10] in [0,$ff] then exit; (* <16 Dateien *)
        ausschrift(copy(puffer_zu_zk_e(form_puffer.d[w1*$10],#$ff,8)+'        ',1,8)
        +' ab '    +str_(form_puffer.d[w1*$10+$b],5)
        +' LÑnge: '+str_(form_puffer.d[w1*$10+$9],5),packer_dat);
      end;
  end;

procedure arcv;
  var
    o:longint;
  begin
    ausschrift('ARCV / Eschalon Development',packer_dat);
    if not langformat then exit;

    o:=$0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,256);

      if      bytesuche(form_puffer.d[0],'ARCV') then
        begin

          (* Anfang bei SETUPFM.EXE F-Prot 3.02 *)
          if bytesuche(form_puffer.d[$e],'BLCK') then
            begin
              (* inc(o,0) *)
            end
          else
            begin
              laenge_eingepackt:=longint_z(@form_puffer.d[$c+form_puffer.d[$c]+5])^;
              laenge_ausgepackt:=longint_z(@form_puffer.d[$c+form_puffer.d[$c]+1])^;

              archiv_datei;

              archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$c]));
            end;
        end
      else if bytesuche(form_puffer.d[0],'CHNK') then
        begin
          (* Datenblock *)
          inc(o,longint_z(@form_puffer.d[$c])^);
        end
      else if bytesuche(form_puffer.d[0],'BLCK') then
        begin
          (* Dateiblock *)
          laenge_eingepackt:=longint_z(@form_puffer.d[$0c])^;
          laenge_ausgepackt:=longint_z(@form_puffer.d[$11+form_puffer.d[$10]])^;

          archiv_datei;

          archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$10]));

          inc(o,laenge_eingepackt);
        end
      else
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          break;
        end;

      inc(o,form_puffer.d[6]);
      if form_puffer.d[6]=0 then inc(o); (* kein Stop *)

    until o=einzel_laenge;
    archiv_summe;

  end;

procedure jasc;
  var
    o:longint;
  begin
    (* OS/2 : vsio.dll *)
    datei_lesen(form_puffer,analyseoff,256);
    laenge_eingepackt:=longint_z(@form_puffer.d[$2])^;
    laenge_ausgepackt:=longint_z(@form_puffer.d[$6])^;

    if (laenge_ausgepackt>2000000)
    or (laenge_eingepackt>laenge_ausgepackt+100)
      then
        exit;

    ausschrift(textz_form__unbekanntes_Archiv^+' <JASC>',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,256);
      if form_puffer.d[0]=0 then break;

      laenge_eingepackt:=longint_z(@form_puffer.d[$2])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$6])^;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$10]));

      inc(o,2);
      inc(o,form_puffer.d[$0]);
      inc(o,laenge_eingepackt);

    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure crossepac(const p:puffertyp);
  var
    o:dateigroessetyp;
  begin
    case p.d[6] of
      ord('A'):
        begin
          exezk:=textz_form__Text^;
          o:=$62;
        end;
      ord('B'):
        begin
          exezk:='ASCII';
          o:=$87;
        end;
      ord('C'):
        begin
          exezk:=textz_form__Binaer^;
          o:=$107;
        end;
    else
          exezk:=chr(p.d[6])+'?';
          o:=einzel_laenge;
    end;

    ausschrift('CrossePAC / Digital Strategies ['+exezk+']',packer_dat);

    if (not langformat) or (o=einzel_laenge) then exit;

    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    {
    archiv_start;

    datei_lesen(form_puffer,analyseoff+o,80);
    inc(o,form_puffer.d[1]); (* Betriebssystem *)

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_eingepackt:=longint_z(@form_puffer.d[$16])^;
      laenge_ausgepackt:=m_longint(form_puffer.d[$a]);

      archiv_datei;

      archiv_datei_ausschrift(
        +puffer_zu_zk_e(form_puffer.d[$1c],#0,255),packer_dat,absatz);

      inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
     }
  end;

procedure crusher_scitech;
  var
    o:longint;
  begin
    (* UNIVBE 5.3 SDD53-D.ZIP *)
    (* ARQ 3.2 *)
    ausschrift('ARQ "CRUSHER!" / DC Micro Development',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'gW') then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      if word_z(@form_puffer.d[6])^=0 then break;

      case form_puffer.d[3] of
        $01:
          begin
            laenge_eingepackt:=longint_z(@form_puffer.d[word_z(@form_puffer.d[6])^+$12  ])^;
            laenge_ausgepackt:=longint_z(@form_puffer.d[word_z(@form_puffer.d[6])^+$12+4])^;

            archiv_datei;

            exezk:='';
            if word_z(@form_puffer.d[$22+word_z(@form_puffer.d[6])^])^<>0 then
              exezk:=textz_form__eckauf_Kennwort_eckzu^;

            archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[8],form_puffer.d[6])+exezk);

            inc(o,$29);
            inc(o,word_z(@form_puffer.d[6])^);
            inc(o,laenge_eingepackt);
          end;
        $02:
          begin
            (*ausschrift('?<2>',packer_dat);*)
            inc(o,12);
          end;
      else

      end;

    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure wwp_dat(const p:puffertyp);
  begin
    case p.d[3] of
       $a:exezk:='[3.02]';
       $b:exezk:='[3.05]';
       $c:exezk:='[?.?? ¯]';
    else
      exit;
    end;

    archiv_start_leise;

    laenge_eingepackt:=DGT_zu_longint(einzel_laenge);
    laenge_ausgepackt:=longint_z(@p.d[4])^;

    archiv_datei;

    ausschrift('WWPACK PD / Rafal Wierzbicki '+textz_form__und^+' Piotr Warezak '+exezk
     +laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);

    archiv_summe_leise;

  end;

procedure xpack_pd(const p:puffertyp;const i:word_norm);
  begin
    archiv_start_leise;

    if i=0 then
      begin
        laenge_eingepackt:=word_z(@p.d[$04])^;
        laenge_ausgepackt:=word_z(@p.d[$14])^;
        exezk:='';
      end
    else (* 2 *)
      begin
        laenge_eingepackt:=DGT_zu_longint(einzel_laenge);
        laenge_ausgepackt:=longint_z(@p.d[$6])^;
        exezk:='[1.67] ';
      end;

    archiv_datei;

    ausschrift('XPACK -pd / JauMing Tseng '+exezk+laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);

    archiv_summe_leise;

  end;

procedure zinstall;
  var
    o:longint;
  begin
    ausschrift('Z/Install Lite / SpeedSOFT Development',packer_dat);
    if not langformat then exit;

    o:=$c;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if form_puffer.g<=2 then break;

      laenge_eingepackt:=longint_z(@form_puffer.d[$15])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$11])^;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,8+1+3));

      inc(o,$27);
      inc(o,laenge_eingepackt);

    until o>=einzel_laenge;

    archiv_summe;

  end;

procedure ari;
  var
    o                   :longint;
    pfad                :string;
    w1,w2               :word_norm;
  begin
    ausschrift('ARI / RAO Inc.',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,50);

      w1:=0;
      w2:=0;


      while (w1<w2+9) and (w1<256) do
        begin
          inc(w1);
          if form_puffer.d[w1]=ord('\') then
            w2:=w1+1;
        end;

      pfad:='';
      if w2>0 then
        pfad:=puffer_zu_zk_l(form_puffer.d[0],w2);

      laenge_eingepackt:=longint_z(@form_puffer.d[w2+$14])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[w2+$10])^;

      if laenge_eingepackt>laenge_ausgepackt+80 then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      archiv_datei;


      if puffer_zu_zk_e(form_puffer.d[w2+8],' ',3)='' then
        exezk:=''
      else
        exezk:='.'+puffer_zu_zk_e(form_puffer.d[w2+8],' ',3);

      archiv_datei_ausschrift(pfad+puffer_zu_zk_e(form_puffer.d[w2+0],' ',8)+exezk);

      inc(o,w2);
      inc(o,laenge_eingepackt);

    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure os2_ini;
  var
    anwendung           :string;

  procedure ini_teil_untersuchung(const start,stop:longint);
    var
      u1,u2             :longint;
      schluessel        :longint;
      zaehler           :word_norm;
      tmp               :string;

    function ecsmt_entschluesseln(const q:string):string;
      var
        e1              :string;
        i,j             :word_norm;
        c0,c1           :byte;
      begin (* Umgekehrter Bitstrom *)
        e1:='';
        for i:=1 to Length(q) do
          begin
            c0:=Ord(q[Length(q)-i+1]);
            c1:=0;
            for j:=0 to 7 do
              if Odd(c0 shr j) then
                Inc(c1,1 shl (7-j));
            e1:=e1+Chr(c1);
          end;
        ecsmt_entschluesseln:=e1;
      end;

    begin
      u1:=start;
      while u1<stop do
        begin
          datei_lesen(form_puffer,analyseoff+u1,512);
          u2:=longint_z(@form_puffer.d[0])^;
          if u2<u1 then u2:=stop;

          exezk:=puffer_zu_zk_e(form_puffer.d[$18],#0,255);
          laenge_eingepackt:=u2-u1-Length(exezk)-1-$18;
          laenge_ausgepackt:=laenge_eingepackt;
          archiv_datei;

          archiv_datei_ausschrift('* '+exezk);

          if (anwendung='PM_Lockup')  (* OS2.INI *)
          and (exezk='LockupOptions') then
            begin
              schluessel:=word_z(@form_puffer.d[24+$14])^;
              dec(schluessel,132);
              schluessel:=schluessel div 3;
              (* doslpwfd.exe: if schluessel<0 then *)
                inc(schluessel,32);

              tmp:=puffer_zu_zk_e(form_puffer.d[24+$18],#0,16);
              for zaehler:=1 to Length(tmp) do tmp[zaehler]:=Chr(Ord(tmp[zaehler]) xor schluessel);
              ausschrift_x(in_doppelten_anfuerungszeichen(tmp),spielstand,leer);
            end;

          if (anwendung='Download') then (* ECSMT.INI *)
            if (exezk='WWW_Userid') or (exezk='WWW_Password')
            or (exezk='FTP_Userid') or (exezk='FTP_Password')
            or (exezk='PROXY_Userid') or (exezk='PROXY_Password') then
              begin
                tmp:=puffer_zu_zk_e(form_puffer.d[$18+Length(exezk)+1],#0,laenge_eingepackt);
                ausschrift_x(in_doppelten_anfuerungszeichen(ecsmt_entschluesseln(tmp)),spielstand,leer);
              end;

          if (anwendung='Version')
          and (exezk='Level') then
            begin
              tmp:=puffer_zu_zk_e(form_puffer.d[$18+Length(exezk)+1],#0,laenge_eingepackt);
              ausschrift_x(in_doppelten_anfuerungszeichen(tmp),beschreibung,leer);
            end;

          if anwendung='PM_Abstract:Icons' then
            begin
              befehl_schnitt(analyseoff+u1+$18+Length(exezk)+1,laenge_eingepackt,exezk+'.ptr');
              os2_ico(analyseoff+u1+$18+Length(exezk)+1,absatz);
            end;

          u1:=u2;
        end;
    end;

  var
    o,o2                :longint;

  begin
    ausschrift('OS/2 - '+textz_form__Konfigurationsdatei^,packer_dat);

    if not langformat then exit;

    o:=$14;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_eingepackt:=word_z(@form_puffer.d[0])^;
      laenge_ausgepackt:=laenge_eingepackt;
      anwendung:=puffer_zu_zk_e(form_puffer.d[$14],#0,108);
      ausschrift(anwendung,beschreibung);
      o2:=longint_z(@form_puffer.d[0])^;
      if o2=0 then o2:=DGT_zu_longint(einzel_laenge);
      ini_teil_untersuchung(longint_z(@form_puffer.d[4])^,o2);
      o:=o2;
    until (o>=einzel_laenge) or (o=0);
    archiv_summe;
  end;

procedure elite_datsfx(const p:puffertyp);
  begin
    archiv_start_leise;
    laenge_ausgepackt:=longint(word_z(@p.d[6])^-1)*16+p.d[$c];
    laenge_eingepackt:=longint(word_z(@p.d[8])^  )*16+p.d[$d];
    archiv_datei;
    ausschrift('ExeLITE 2.00 DAT-SFX / Code Blasters '+laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);
    archiv_summe_leise;
    einzel_laenge:=laenge_eingepackt;
  end;

procedure limit(const ver:byte);
  var
    o                   :longint;
    verzeichnis         :string;
  begin
    ausschrift('Limit / J. Y. Lim '+version_div16_mod16(ver),packer_dat);
    if not langformat then
      exit;

    archiv_start;

    o:=8;
    verzeichnis:='';

    repeat
      datei_lesen(form_puffer,o,100);

      case form_puffer.d[$00] of
        $33:
          begin
            (* Kommentar *)
            ansi_anzeige(o+4,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
              ,o+4+longint_z(@form_puffer.d[2])^,'');

            inc(o,word_z(@form_puffer.d[$02])^);

          end;
        else
          begin
            (* Datei oder Verzeichnis *)

            exezk:=puffer_zu_zk_e(form_puffer.d[$1e],#0,80);

            if (form_puffer.d[$f] and $20)=$20 then
              begin
                laenge_ausgepackt:=longint_z(@form_puffer.d[$12])^;
                laenge_eingepackt:=longint_z(@form_puffer.d[$16])^;

                archiv_datei;

                archiv_datei_ausschrift(verzeichnis+exezk);

                inc(o,laenge_eingepackt);
              end
            else
              verzeichnis:=puffer_zu_zk_e(form_puffer.d[$11],#0,80)+'\';

            inc(o,word_z(@form_puffer.d[$7])^); (* Kopf *)
          end;
      end;

    until o+$26>einzel_laenge;

    archiv_summe;

  end;

procedure jrc;
  var
    o:longint;
  begin
    o:=0;
    datei_lesen(form_puffer,analyseoff+o,20);
    ausschrift('JRchive Version '+chr(form_puffer.d[7])+'.'+chr(form_puffer.d[8])+'X / JAYAR Systems',packer_dat);
    if not langformat then
      exit;

    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,100);

      exezk:=puffer_zu_zk_e(form_puffer.d[$16],#$0a,80);
      laenge_ausgepackt:=0;
      laenge_eingepackt:=longint_z(@form_puffer.d[$12])^;

      archiv_datei;

      ausschrift_x('          ?'+'   ?'+'  '
        +exezk,packer_dat,absatz);

      inc(o,laenge_eingepackt);
      inc(o,22-12);
      inc(o,length(exezk));

    until o+$30>=einzel_laenge;

    archiv_summe_ausgepackt_unbekannt:=true;

    archiv_summe;

  end;

procedure hpack;
  var
    anz,w1              :word_norm;
    tabellen_start,
    tabellen_position,
    namen_position      :longint;
  begin
    (*









333.hpk:

   (74 d4 00 00 )
   dd zeitstempel
   dw dateilaÑnge 333
   dw dateilaÑnge 333+2
   333




HPACK~.HPK:


    (80 40)
    dd zeitstempel
    dd dateilÑnge hpack~.exe
    (a5 d3) (=lÑnge eingepackt)
    HPACK~.EXE


H2.HPK:

    (80 40)
    dd zeitstempel
    dd dateilÑnge ?.exe
    (a5 d3) (=lÑnge eingepackt)

    (80 40)
    dd zeitstempel
    dd dateilÑnge ?.exe
    (a5 d3) (=lÑnge eingepackt)

    HPACK.EXE
    HPACK~.EXE


    *)
    ausschrift('HPACK / Peter Gutmann',packer_dat);
    if not langformat then
      exit;

    tabellen_start:=DGT_zu_longint(einzel_laenge-$f);
    datei_lesen(form_puffer,analyseoff+tabellen_start,4+4);
    anz:=m_longint(form_puffer.d[0]);


    dec(tabellen_start,m_longint(form_puffer.d[4]));

    tabellen_position:=0;
    for w1:=1 to anz do
      begin
        datei_lesen(form_puffer,analyseoff+tabellen_start+tabellen_position,2);
        case form_puffer.d[0] and $c0 of
          $00:inc(tabellen_position,$a);
          $40:inc(tabellen_position,$a); (*???*)
          $80:inc(tabellen_position,$c);
          $c0:inc(tabellen_position,$e);
        end;
      end;

    namen_position:=tabellen_position;
    tabellen_position:=0;

    archiv_start;

    for w1:=1 to anz do
      begin
        datei_lesen(form_puffer,analyseoff+tabellen_start+tabellen_position,$c);
        case form_puffer.d[0] and $c0 of
          $00,$40 (*???*):
            begin
              laenge_ausgepackt:=m_word(form_puffer.d[6]);
              laenge_eingepackt:=-1;
              inc(tabellen_position,$a);
            end;
          $80:
            begin
              (* dd [2]=Zeit *)
              laenge_ausgepackt:=m_longint(form_puffer.d[6]);
              laenge_eingepackt:=-1;
              inc(tabellen_position,$c)
            end;
          $c0: (* OS/2: hpack(hpack("hpack.exe","hpack~.exe")) *)
            begin
              laenge_ausgepackt:=m_longint(form_puffer.d[6]);
              laenge_eingepackt:=-1;
              inc(tabellen_position,$e)
            end;
        end;
        archiv_datei;

        datei_lesen(form_puffer,analyseoff+tabellen_start+namen_position,$c);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
        archiv_datei_ausschrift(exezk);

        inc(namen_position,length(exezk)+1);
      end;

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=falsch;
    archiv_summe;

  end;

procedure mdmd;
  var
    o:longint;
  begin
    ausschrift('MDCD / Mike Davenport',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,120);
      laenge_ausgepackt:=longint_z(@form_puffer.d[$19])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$1d])^;

      if laenge_eingepackt>laenge_ausgepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;


      archiv_datei;

      archiv_datei_ausschrift(
         puffer_zu_zk_pstr(form_puffer.d[$36])
        +puffer_zu_zk_pstr(form_puffer.d[$29]));

      inc(o,form_puffer.d[$6]);
      inc(o,laenge_eingepackt);

    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure bsa(o:dateigroessetyp);
  begin
    ausschrift('BSA / PhysTechSoft',packer_dat);
    if not langformat then exit;

    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,100);

      laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[8])^;

      if laenge_eingepackt>laenge_ausgepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$16]));

      IncDGT(o,laenge_eingepackt);
      IncDGT(o,word_z(@form_puffer.d[0])^+2);

    until o+10>=einzel_laenge;

    archiv_summe;

  end;

procedure bsn(o:dateigroessetyp);
  begin
    ausschrift('BSN [BSA.EXE] / PhysTechSoft',packer_dat);
    if not langformat then exit;

    IncDGT(o,7);
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,100);
      if not bytesuche(form_puffer.d[0],'BSA') then
        break;

      exezk:=puffer_zu_zk_e(form_puffer.d[13],#0,80);

      if (form_puffer.d[6] and $20)<>0 then
        ausschrift(puffer_zu_zk_pstr(form_puffer.d[Length(exezk)+$1b]),beschreibung);

      laenge_ausgepackt:=m_longint(form_puffer.d[13+length(exezk)+$01]);
      laenge_eingepackt:=m_longint(form_puffer.d[13+length(exezk)+$05]);


      (* PTSDOS 2000: 1150 > 1102 *)
      if laenge_eingepackt>laenge_ausgepackt+100 then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;


      archiv_datei;

      archiv_datei_ausschrift(exezk);

      IncDGT(o,laenge_eingepackt);
      IncDGT(o,form_puffer.d[4]);
      IncDGT(o,10);

    until false;

    archiv_summe;

  end;

procedure x1_s_valantini(const p:puffertyp);
  var
    o:longint;
  begin
    if (p.d[2] and $10)=$10 then
      begin
        laenge_ausgepackt:=word_z(@p.d[$e+0])^;
        laenge_eingepackt:=word_z(@p.d[$e+2])^;
        exezk:=puffer_zu_zk_l(p.d[$19],p.d[$12]);
      end
    else
      begin
        laenge_ausgepackt:=word_z(@p.d[$e+0])^;
        laenge_eingepackt:=word_z(@p.d[$e+2])^;
        exezk:=puffer_zu_zk_l(p.d[$1d],p.d[$16]);
      end;

    if laenge_eingepackt>einzel_laenge then exit;
    if laenge_eingepackt>laenge_ausgepackt then exit;
    if exezk<>filter(exezk) then exit;
    if length(exezk)<3 then exit;


    ausschrift('X1 / Stig Valentini',packer_dat);

    if not langformat then exit;

    archiv_start;
    o:=0;

    repeat
      datei_lesen(form_puffer,analyseoff+o,100);

      if not bytesuche(form_puffer.d[0],'X1') then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      if (form_puffer.d[2] and $10)=$10 then
        begin
          (* $3c ... <64k *)
          laenge_ausgepackt:=word_z(@form_puffer.d[$e+0])^;
          laenge_eingepackt:=word_z(@form_puffer.d[$e+2])^;
          exezk:=puffer_zu_zk_l(form_puffer.d[$19],form_puffer.d[$12]);
          Inc(o,$19);
          Inc(o,form_puffer.d[$12]);
        end
      else
        begin
          (* $2c ... >=64k *)
          laenge_ausgepackt:=longint_z(@form_puffer.d[$e+0])^;
          laenge_eingepackt:=longint_z(@form_puffer.d[$e+4])^;
          exezk:=puffer_zu_zk_l(form_puffer.d[$1d],form_puffer.d[$16]);
          Inc(o,$1d);
          Inc(o,form_puffer.d[$16]);
        end;


      if laenge_eingepackt>laenge_ausgepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;


      archiv_datei;

      archiv_datei_ausschrift(exezk);

      Inc(o,laenge_eingepackt);

    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure grasp(anzahl:word_norm);
  var
    o,daten:longint;
  begin

    (* Absicherung *)
    datei_lesen(form_puffer,analyseoff+2+$11*2,$11);
    exezk:=puffer_zu_zk_e(form_puffer.d[4],#0,8+1+3);
    if Pos('.',exezk)>8+1 then Exit;
    if not ist_ohne_steuerzeichen_nicht_so_streng(exezk) then Exit;
    daten:=longint_z(@form_puffer.d[0])^;
    if (daten<2+$11*anzahl) or (daten>einzel_laenge) then Exit;
    datei_lesen(form_puffer,analyseoff+daten,4);
    laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
    if (laenge_eingepackt<=0) or (daten+4+laenge_eingepackt>einzel_laenge) then Exit;


    ausschrift('GRaphic Animation System for Professionals / Microtex Industies Inc.',musik_bild);
    if not langformat then exit;

    o:=2;
    archiv_start;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,$11);
        Inc(o,$11);
        Dec(anzahl);
        exezk:=puffer_zu_zk_e(form_puffer.d[4],#0,8+1+3);
        daten:=longint_z(@form_puffer.d[0])^;
        if daten=0 then Continue;
        datei_lesen(form_puffer,analyseoff+daten,4);
        laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+daten+4,laenge_eingepackt,exezk);
      end;
    archiv_summe;

  end;

(*procedure cpio;
  var
    o:longint;
  begin
    ausschrift('CPIO',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,300);

      laenge_ausgepackt:=longint(word_z(@form_puffer.d[$18])^)+$10000*longint(word_z(@form_puffer.d[$16])^);
      laenge_eingepackt:=laenge_ausgepackt;


      if (laenge_eingepackt>laenge_ausgepackt)
      or (not bytesuche(form_puffer.d[0],#$c7#$71))
       then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      exezk:=puffer_zu_zk_e(form_puffer.d[$1a],#0,255);
      if exezk='TRAILER!!!' then break;

      archiv_datei;

      archiv_datei_ausschrift(exezk);

      w1:=length(exezk)+1;
      if odd(w1)                then Inc(w1);
      if odd(laenge_eingepackt) then Inc(laenge_eingepackt);
      Inc(o,$1a+w1+laenge_eingepackt);

    until o>einzel_laenge;

    archiv_summe;

  end;*)

procedure cpio;
  var
    o,dateinamenlaenge  :dateigroessetyp;
    a                   :byte;
  begin
    ausschrift('CPIO / Mark H. Colburn',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,300);

      if bytesuche(form_puffer.d[0],#$c7#$71) then
        begin
          laenge_ausgepackt64:=longint(word_z(@form_puffer.d[$18])^)+$10000*longint(word_z(@form_puffer.d[$16])^);
          IncDGT(o,$1a);
          a:=2;
        end
      else if bytesuche(form_puffer.d[0],'070707') then
        begin
          laenge_ausgepackt64:=ziffer($08,puffer_zu_zk_l(form_puffer.d[$41],11));
          dateinamenlaenge   :=ziffer($08,puffer_zu_zk_l(form_puffer.d[$3b], 6));
          IncDGT(o,$4c);
          a:=1;
        end
      else if bytesuche(form_puffer.d[0],'070701') then
        begin
          laenge_ausgepackt64:=ziffer($10,puffer_zu_zk_l(form_puffer.d[$36],8));
          dateinamenlaenge :=ziffer($10,puffer_zu_zk_l(form_puffer.d[$5e],8));
          IncDGT(o,$6e);
          a:=4;
        end
      else
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          Break;
        end;

      laenge_eingepackt64:=laenge_ausgepackt64;
      if (laenge_ausgepackt64<0) or (dateinamenlaenge<0) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          Break;
        end;

      datei_lesen(form_puffer,analyseoff+o,128);
      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);

      if exezk='TRAILER!!!' then
        begin
          IncDGT(o,Length(exezk));
          repeat
            if o>=einzel_laenge then Break;
            (*if o and (a-1)=0 then Break;*)
            if AndDGT(o,(512-1))=0 then Break; (* zum Beispiel in xarchie-2.0.10 *)
            datei_lesen(form_puffer,analyseoff+o,1);
            if form_puffer.d[0]<>0 then Break;
            IncDGT(o,1);
          until false;
          Break;
        end;

      archiv_datei64;

      archiv_datei_ausschrift(exezk);

      IncDGT(o,Length(exezk)+1);
      while AndDGT(o,(a-1))<>0 do IncDGT(o,1);
      IncDGT(o,laenge_eingepackt64);
      while AndDGT(o,(a-1))<>0 do IncDGT(o,1);

    until o>=einzel_laenge;
    einzel_laenge:=o;
    if analyseoff>0 then
      befehl_schnitt(analyseoff,einzel_laenge,erzeuge_neuen_dateinamen('.'+DGT_str0(analyseoff)+'.CPIO'));
    archiv_summe;
  end;

procedure quark;
  var
    o:longint;
  begin
    ausschrift('QUARK 1.0 / Kunz Robert',packer_dat);
    if not langformat then
      Exit;

    archiv_start;
    o:=0;

    repeat
      datei_lesen(form_puffer,analyseoff+o,120);

      laenge_ausgepackt:=longint_z(@form_puffer.d[$c+form_puffer.d[$b]+8-2+0])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$c+form_puffer.d[$b]+8-2+4])^;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$b]));

      Inc(o,form_puffer.d[$b]);
      Inc(o,$c+9);
      Inc(o,laenge_eingepackt);

    until o+10>=einzel_laenge;

    archiv_summe;
  end;

procedure shrinkit;(* nulib *)
  var
    o                   :longint;
    kopflaenge          :longint;
    name_off            :longint;
    name_laenge         :word_norm;
    anzahl_threads,
    thread_zaehler,
    thread_off          :word_norm;
    datenlaenge         :longint;

    thread_dat_aus,
    thread_dat_ein      :longint;

  function ermittle_dateiname:string;
    begin
      if name_off+name_laenge<512 then
        ermittle_dateiname:=puffer_zu_zk_l(form_puffer.d[name_off],name_laenge)
      else
        ermittle_dateiname:=textz_form_klammer_kann_Dateiname_nicht_ermitteln_klammer^;
    end;

  begin
    ausschrift('ShrinkIt / L&L Productions [Apple II; Apple IIGS] ≥ NuLib / Andy McFadden',packer_dat);
    if not langformat then
      exit;

    archiv_start;
    o:=$30;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$200);
      if not bytesuche(form_puffer.d[0],'N'#$f5'F'#$d8) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          break;
        end;

      name_off:=0; (* "unbekannt" *)
      name_laenge:=0;
      anzahl_threads:=word_z(@form_puffer.d[$08+2])^;
      if anzahl_threads>10 then anzahl_threads:=10; (* <=512 *)


      kopflaenge:=word_z(@form_puffer.d[$06])^;
      if kopflaenge>=$40 then
        begin
          (* Zeiger auf Dateinamen *)
          if word_z(@form_puffer.d[$3e])^>0 then
            begin
              name_laenge:=word_z(@form_puffer.d[$3e])^;
              name_off:=kopflaenge;
              Inc(kopflaenge,name_laenge);
            end;
        end;

      datenlaenge:=kopflaenge+$10*anzahl_threads;

      for thread_zaehler:=1 to anzahl_threads do
        begin
          thread_off:=kopflaenge+$10*(thread_zaehler-1);
          thread_dat_aus:=longint_z(@form_puffer.d[thread_off+$8])^;
          thread_dat_ein:=longint_z(@form_puffer.d[thread_off+$c])^;
          case form_puffer.d[thread_off] of
            0:
              begin
                (* Kommentar *)
                (* kein Kommentar: in Beispielen Nullen *)
              end;
            1:
              begin
                (* "control" *)
                (* was ist das? *)
              end;
            2:
              begin
                (* Daten *)
                laenge_ausgepackt:=thread_dat_aus;
                laenge_eingepackt:=thread_dat_ein;

                archiv_datei;
                (* RESR, Data, DISK,... noch nicht implementiert *)

                archiv_datei_ausschrift(ermittle_dateiname);
              end;
            3:
              begin
                (* Name *)
                name_off:=datenlaenge;
                name_laenge:=thread_dat_aus;
              end;
          else
                (* unbekannt *)
                ausschrift(textz_unbekannter_Datenblocktyp^+'('+str0(form_puffer.d[thread_off])+') ¯',dat_fehler);
          end;

          Inc(datenlaenge,thread_dat_ein);
        end;


      Inc(o,datenlaenge);

    until o+80>=einzel_laenge;

    archiv_summe;
    einzel_laenge:=o;
  end;

procedure crush(const ver:string;const anz:word_norm;const o:dateigroessetyp);
  var
    verzeichnis         :string;
    w1,w2,w3            :word_norm;
  begin
    ausschrift('CRUSH '+ver+' / J.Rollanson',packer_dat);
    if not langformat then
      exit;

    archiv_start;

    for w1:=1 to anz do
      begin
        datei_lesen(form_puffer,analyseoff+o+(w1-1)*24,24);
        laenge_ausgepackt:=longint_z(@form_puffer.d[$06])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[$06])^;
        exezk:=puffer_zu_zk_e(form_puffer.d[$a],#0,80);

        archiv_datei;

        w3:=form_puffer.d[$00];
        if w3>0 then
          begin
            datei_lesen(form_puffer,analyseoff+o+anz*24,512);
            w2:=0;
            while (w3>0) and (w2<500) do
              begin
                verzeichnis:=puffer_zu_zk_e(form_puffer.d[w2],#0,80);
                Inc(w2,length(verzeichnis)+1);
                dec(w3);
              end;
          end
        else
          verzeichnis:='';

        archiv_datei_ausschrift(verzeichnis+exezk);

      end;

    archiv_summe;

  end;

procedure dwc(const anz:word_norm;o:dateigroessetyp);
  var
    w1,zaehl            :word_norm;
  begin
    ausschrift('DWC / Dean W. Cooper',packer_dat);
    if not langformat then
      Exit;

    archiv_start;

    DecDGT(o,$3d-$22);

    for zaehl:=1 to anz do
      begin
        DecDGT(o,$22);
        datei_lesen(form_puffer,o,$3e);

        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,80);

        laenge_ausgepackt:=longint_z(@form_puffer.d[13+0])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[13+8])^;

        archiv_datei;

        archiv_datei_ausschrift(exezk);

        w1:=form_puffer.d[$1e];
        if w1>0 then
          begin
            DecDGT(o,w1);
            ansi_anzeige(o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
              ,o+w1,'');
          end;
      end;

    archiv_summe;
  end;

procedure os2_resource_ausschrift(const typ,name_:word_norm;const l:longint);
  begin
    exezk:=os2_resourcetyp_namen(typ);

    exezk_leerzeichen_erweiterung(Length('POINTER      '));

    if typ=5 then (* Stringtable *)
      begin
        exezk_anhaengen(str_((name_-1) shl 4,6));
        exezk_anhaengen('..');
        exezk_anhaengen(str_((name_) shl 4-1,5));
      end
    else
      exezk_anhaengen(str_(name_,5+2+6));

    exezk_anhaengen('  ');
    (*exezk_anhaengen(str11_oder_hex(l));*)
    exezk_anhaengen(strx(l,11));

    ausschrift(exezk,musik_bild);
  end;

procedure msw_resource__exezk(const typ,name_:word_norm;const typ_zk,name_zk:string;const l:longint;var entpackt_name:string);
  begin
    if typ_zk<>'' then
      exezk:=typ_zk
    else
      exezk:=windows_resourcetyp_namen(typ);

    entpackt_name:=exezk;

    exezk_leerzeichen_erweiterung(Length('Animated cursor '));
    exezk_anhaengen(' ');

    if name_zk<>'' then
      begin
        exezk_anhaengen(name_zk);
        entpackt_name:=entpackt_name+'.'+name_zk;
      end
    else
      begin
        if typ=6 then (* Stringtable *)
          begin
            exezk_anhaengen(str_((name_-1) shl 4,6));
            exezk_anhaengen('..');
            exezk_anhaengen(str_((name_) shl 4-1,5));
          end
        else
          exezk_anhaengen(str_(name_,5+2+6));
        entpackt_name:=entpackt_name+'.'+str0(name_);
      end;

    exezk_leerzeichen_erweiterung(Length('Animated cursor '+'               '));

    exezk_anhaengen('  ');
    exezk_anhaengen(strx(l,11));

    (*ausschrift(exezk,musik_bild);*)
  end;

procedure os2_resource;
  var
    o,n,i               :longint;
    p                   :word_norm;
    res_name            :string;
    entpackt_name       :string;

  begin
    ausschrift('OS/2,Windows RC '+textz_copilierte_Resource^,bibliothek); (* Warp 3 *)

    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      n:=word_z(@form_puffer.d[1])^;

      exezk:=os2_resourcetyp_namen(n);
      entpackt_name:=exezk;
      exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(Length('POINTER      '));

      if form_puffer.d[3]=$ff then
        begin
          i:=word_z(@form_puffer.d[4])^;

          if n=5 then
            begin
              exezk_anhaengen(strx((i-1) shl 4,6));
              exezk_anhaengen('..');
              exezk_anhaengen(strx((i) shl 4-1,5));
            end
          else
            exezk_anhaengen(strx(i,6));

          entpackt_name:=entpackt_name+'.'+str0(i);

          p:=3+1+2+2;

        end
      else (* OWLCHESS.RES *)
        begin
          res_name:=puffer_zu_zk_e(form_puffer.d[3],#0,255);
          p:=4+Length(res_name)+1+1;
          exezk_anhaengen('"');
          exezk_anhaengen(res_name);
          exezk_anhaengen('"');
          entpackt_name:=entpackt_name+'.'+res_name;
        end;


      laenge_eingepackt:=longint_z(@form_puffer.d[p])^;
      laenge_ausgepackt:=laenge_eingepackt;

      archiv_datei;
      archiv_datei_ausschrift(exezk);

      befehl_schnitt(analyseoff+o+p+4,laenge_eingepackt,entpackt_name);

      if ico_anzeige then
        if (n=1) (* pointer *)
        or (n=2) (* bitmap *)
         then
          os2_ico(analyseoff+o+p+4,leer);

      Inc(o,p+4+laenge_eingepackt);

    until (o>=einzel_laenge) or (o<0);
    archiv_summe;
  end;

procedure resource_datei_w32;
  var
    o,o1                :longint;
    typ_id,name_id      :word_norm;
    typ_str,name_str    :string;
    entpackt_name       :string;
    kopflaenge          :longint;

  begin
    ausschrift('Win32 RC '+textz_copilierte_Resource^,bibliothek); (* RES.W32\ *)

    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
      laenge_eingepackt:=laenge_ausgepackt;
      kopflaenge:=longint_z(@form_puffer.d[4])^;

      if (o=0) and (kopflaenge=$20) and (laenge_eingepackt=0) then
        begin
          o:=$20;
          Continue;
        end;

      o1:=8;

      if word_z(@form_puffer.d[o1])^=$ffff then
        begin
          typ_id:=word_z(@form_puffer.d[o1+2])^;
          typ_str:='';
          Inc(o1,4);
        end
      else
        begin
          typ_id:=0;
          typ_str:=uc16_puffer_zu_zk_e(form_puffer.d[o1],#0,255);
          Inc(o1,2*Length(typ_str)+2);
          o1:=o1+3 and (not 3);
        end;

      if word_z(@form_puffer.d[o1])^=$ffff then
        begin
          name_id:=word_z(@form_puffer.d[o1+2])^;
          name_str:='';
          Inc(o1,4);
        end
      else
        begin
          name_id:=0;
          name_str:=uc16_puffer_zu_zk_e(form_puffer.d[o1],#0,255);;
          Inc(o1,2*Length(name_str)+2);
          o1:=o1+3 and (not 3);
        end;

      msw_resource__exezk(typ_id,name_id,typ_str,name_str,laenge_ausgepackt,entpackt_name);
      if ico_anzeige then
        begin
          if typ_id=2 (* BITMAP *) then
            windows_ico1(analyseoff+o+kopflaenge,laenge_ausgepackt,true,2);
          if typ_id=3 (* ICON *) then
            windows_ico1(analyseoff+o+kopflaenge,laenge_ausgepackt,true,1);
        end;

      archiv_datei;
      archiv_datei_ausschrift(exezk);

      befehl_schnitt(analyseoff+o+kopflaenge,laenge_eingepackt,entpackt_name);

      o:=(o+kopflaenge+laenge_eingepackt+3) and (not 3)

    until o+8>einzel_laenge;
    einzel_laenge:=o;
    archiv_summe;

  end;

procedure createinstall;
  var
    o,f,o1              :dateigroessetyp;
  begin
    (* aspack 2.001 *)
    (* komprimierte Daten sehen nach zip aus .. *)
    (* alex@pirit.sibtel.ru *)
    (* Version 3.41 geht aber 2000 nicht *)
    ausschrift('CreateInstall / Alexey Krivonogov',packer_dat);
    if not langformat then exit;

    (* die erste Datei und die Installationsanweisungen werden nicht genannt *)
    o:=analyseoff;
    o1:=o+MinDGT(50000,einzel_laenge);
    f:=datei_pos_suche(o,o1,#$01#$00#$20#$00#$00#$00#$00'???????'#$00);

    if f=nicht_gefunden then Exit;

    archiv_start;
    repeat
      o:=f;
      datei_lesen(form_puffer,o,512);

      exezk:=puffer_zu_zk_l(form_puffer.d[$11],form_puffer.d[$0f]);
      if not ist_ohne_steuerzeichen_nicht_so_streng(exezk) then break;

      laenge_ausgepackt64:=longint_z(@form_puffer.d[$11+form_puffer.d[$0f]])^;

      o1:=o+laenge_ausgepackt64;
      if o1>analyseoff+einzel_laenge then
        o1:=analyseoff+einzel_laenge;

      f:=datei_pos_suche(o+$20,o1,#$01#$00#$20#$00#$00#$00#$00'???????'#$00);

      if f=nicht_gefunden then
        laenge_eingepackt64:=o1-o
      else
        laenge_eingepackt64:=f-o;

      archiv_datei64;
      archiv_datei_ausschrift(exezk);

      IncDGT(o,laenge_eingepackt64);

    until o>=analyseoff+einzel_laenge;

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;

  end;

procedure zzip(const p:puffertyp);
  begin
    ausschrift('ZZIP / Damien Debin'+version_x_y(p.d[3],p.d[2]),packer_dat);
    (*
    if not langformat then exit;

    archiv_start_leise;
    laenge_eingepackt:=einzel_laenge;
    laenge_ausgepackt:=laenge_eingepackt+longint_z(@p.d[$9])^-$22;..falsch
    archiv_datei;
    archiv_datei_ausschrift('?');
    archiv_summe_leise;*)
  end;

procedure zzip_36b(const p:puffertyp);
  var
    anzahl,
    o                   :longint;
  begin
    anzahl:=longint_z(@p.d[3])^;
    if (anzahl<1) or (anzahl>99999) then Exit;
    exezk:=puffer_zu_zk_l(p.d[$b],p.d[$7]);
    if not ist_ohne_steuerzeichen_nicht_so_streng(exezk) then Exit;
    if Pos('.',exezk)=0 then Exit;

    ausschrift('ZZIP / Damien Debin [~0.36b]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=7;
    while (anzahl>0) and (o<einzel_laenge) do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_l(form_puffer.d[4],form_puffer.d[0]);
        Inc(o,4+longint_z(@form_puffer.d[0])^);
        datei_lesen(form_puffer,analyseoff+o,$10);
        Inc(o,$10);
        laenge_ausgepackt:=longint_z(@form_puffer.d[$a])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[$6])^;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,laenge_eingepackt);
      end;
    archiv_summe;
  end;


procedure yamazakizipper(const p:puffertyp);
  var
    ver:longint;
  begin
    ver:=DGT_zu_longint(ziffer(10,puffer_zu_zk_l(p.d[2],8-2-2)));
    if ver=0 then exit;

    (* deepfreezer: depf105a.exe *)
    ausschrift('YamazakiZipper / BinaryTechnology'+version100(ver),packer_dat);
    if not langformat then exit;

    archiv_start;
    ausschrift('?',packer_dat);
    archiv_summen_dateien:=m_longint(p.d[$10]);
    archiv_summe_ausgepackt_unbekannt:=false; (* fast genau .. *)
    archiv_summe_ausgepackt:=m_longint(p.d[$08]);
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe_eingepackt:=einzel_laenge;

    archiv_summe;

  end;

procedure wsp_wup(const p:puffertyp);
  begin
    exezk:=puffer_zu_zk_e(p.d[$e],#0,8+1+3);
    if Length(exezk)<3 then Exit;
    if not ist_ohne_steuerzeichen(exezk) then Exit;
    exezk:=puffer_zu_zk_e(p.d[$1b],#0,8+1+3);
    if Length(exezk)<3 then Exit;
    if not ist_ohne_steuerzeichen(exezk) then Exit;

    ausschrift('WSP self update amapro Wakichi [1.50]',packer_dat);
    if not langformat then exit;

    archiv_start;
    laenge_ausgepackt64:=-1;
    laenge_eingepackt64:=einzel_laenge;
    exezk:=puffer_zu_zk_e(p.d[$e],#0,8+1+3);
    exezk_anhaengen(' -> ');
    exezk_anhaengen(puffer_zu_zk_e(p.d[$1b],#0,8+1+3));
    archiv_datei64;
    archiv_datei_ausschrift(exezk);

    archiv_summe;
  end;

procedure ufa(const p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('UFA,777 / Igor Pavlov ['+puffer_zu_zk_l(p.d[0],3)+']',packer_dat); (* 0.04 *)
    if not langformat then exit;

    o:=8;
    archiv_start;

    case p.d[$6] of
      0:
        begin
          datei_lesen(form_puffer,analyseoff+o,512);

          if word_z(@form_puffer.d[$06])^=$1d+2+word_z(@form_puffer.d[$1d])^ then
            (* UFA 0.00 *)
            repeat
              datei_lesen(form_puffer,analyseoff+o,512);
              laenge_ausgepackt:=longint_z(@form_puffer.d[$14+4])^;
              laenge_eingepackt:=longint_z(@form_puffer.d[$14+0])^;
              archiv_datei;
              archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$1d+2],form_puffer.d[$1d]));
              Inc(o,word_z(@form_puffer.d[$06])^);
              Inc(o,laenge_eingepackt);
            until o>=einzel_laenge

          else if word_z(@form_puffer.d[$06])^=$1f+2+word_z(@form_puffer.d[$1f])^ then
            (* UFA 0.01 *)
            repeat
              datei_lesen(form_puffer,analyseoff+o,512);
              laenge_ausgepackt:=longint_z(@form_puffer.d[$16+4])^;
              laenge_eingepackt:=longint_z(@form_puffer.d[$16+0])^;
              archiv_datei;
              archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$1f+2],form_puffer.d[$1f]));
              Inc(o,word_z(@form_puffer.d[$06])^);
              Inc(o,laenge_eingepackt);
            until o>=einzel_laenge

          else if word_z(@form_puffer.d[$06])^=$36+2+word_z(@form_puffer.d[$36])^ then
            (* 0.04 *)
            repeat
              datei_lesen(form_puffer,analyseoff+o,512);
              laenge_ausgepackt:=longint_z(@form_puffer.d[$2e+4])^;
              laenge_eingepackt:=longint_z(@form_puffer.d[$2e+0])^;
              archiv_datei;
              archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$36+2],form_puffer.d[$36]));
              Inc(o,word_z(@form_puffer.d[$06])^);
              Inc(o,laenge_eingepackt);
            until o>=einzel_laenge

          else
            (* unbekannte Version *)
            ausschrift('?',packer_dat);
        end;

      1: (* -s *)
        begin
          Inc(o,longint_z(@p.d[8+$d])^);
          Inc(o,$d+6);
          repeat
            datei_lesen(form_puffer,analyseoff+o,512);
            laenge_ausgepackt:=longint_z(@form_puffer.d[$21])^;
            laenge_eingepackt:=-1;
            archiv_datei;
            archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$27],form_puffer.d[$25]));
            Inc(o,$27+word_z(@form_puffer.d[$25])^);
          until o>=einzel_laenge;
          archiv_summe_eingepackt:=einzel_laenge;
          archiv_summe_eingepackt_unbekannt:=falsch;
        end;
    else
      ausschrift('?',dat_fehler);
    end;
    archiv_summe;
  end;

procedure abcomp_206(const p:puffertyp);
  begin
    ausschrift('ABComp / Avinesh Bangar [2.06]',packer_dat);
    if not langformat then exit;

    archiv_start;

    laenge_ausgepackt64:=longint_z(@p.d[$2c])^;
    laenge_eingepackt64:=einzel_laenge;
    archiv_datei64;
    archiv_datei_ausschrift('?');

    archiv_summe;
  end;

procedure spis(const o0:word_norm);
  var
    o:longint;
  begin
    ausschrift('? SPIS,presetup / ?',packer_exe);
    if not langformat then exit;

    o:=o0+$15;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if bytesuche(form_puffer.d[0],'SPIS') then
        begin
          einzel_laenge:=o;
          Break;
        end;

      laenge_ausgepackt:=longint_z(@form_puffer.d[$8])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$c])^;
      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$19],form_puffer.d[$00]));
      Inc(o,$19+form_puffer.d[$00]+laenge_eingepackt);

    until o+$19>=einzel_laenge;
    archiv_summe;
  end;

procedure ybs;
  var
    o                   :longint;
    w1                  :word_norm;
  begin

    (* YBS.TXT ausschlie·en... *)
    datei_lesen(form_puffer,analyseoff+6,512);
    exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
    w1:=Length(exezk)+1;
    laenge_ausgepackt:=longint_z(@form_puffer.d[w1])^;
    if (w1<4)
    or (w1>80)
    or (not ist_ohne_steuerzeichen_nicht_so_streng(exezk))
    or (laenge_ausgepackt<0)
    or (laenge_ausgepackt>800*1024*1024)
     then
      Exit;

    ausschrift('YBS / ? [0.02]',packer_dat);
    if not langformat then exit;

    o:=6;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if form_puffer.d[0]=0 then Break;

      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
      w1:=Length(exezk)+1;
      laenge_ausgepackt:=longint_z(@form_puffer.d[w1])^;
      laenge_eingepackt:=-1;
      Inc(w1,3*4);
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      Inc(o,w1);
    until false;

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure phoenix_bios_archiv_m025(const anker,delta:dateigroessetyp);
  var
    o:longint;
  begin
    (* keinen Titel anzeigen *)
    if not langformat then Exit;

    o:=x_longint__datei_lesen(anker+delta);
    (* Sany Beispiel: 2*256K-Blîcke mÅssen vertauscht werden damit
       die Startposition stimmt *)
    if (o and $fff00000)<>$fff00000 then Exit;
    o:=o and $000fffff;
    if o+delta<0 then Exit;
    datei_lesen(form_puffer,o+delta,$30);
    laenge_eingepackt:=longint_z(@form_puffer.d[$b+8])^;
    laenge_ausgepackt:=longint_z(@form_puffer.d[$b+4])^;
    if laenge_eingepackt>laenge_ausgepackt then Exit;
    if laenge_ausgepackt>1024*1024 then Exit;
    if laenge_eingepackt<0 then Exit;

    o:=x_longint__datei_lesen(anker+delta);
    archiv_start;
    repeat
      if (o and $fff00000)<>$fff00000 then Break;
      o:=o and $000fffff;
      if o+delta<0 then Break;
      datei_lesen(form_puffer,o+delta,$30);
      laenge_eingepackt:=longint_z(@form_puffer.d[$b+8])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$b+4])^;
      archiv_datei;
      exezk:=hex_longint(o)+' '+hex_longint(longint_z(@form_puffer.d[$b+0])^)+' '+Chr(form_puffer.d[$8]);
      archiv_datei_ausschrift(exezk);
      o:=longint_z(@form_puffer.d[0])^;
    until false;
    archiv_summe;
  end;

procedure phoenix_bios_modul(const p:puffertyp);
  begin
    ausschrift('Phoenix BIOS BCxxxx [6]',packer_dat);
    archiv_start_leise;
    laenge_eingepackt:=longint_z(@p.d[$b+8])^;
    laenge_ausgepackt:=longint_z(@p.d[$b+4])^;
    if laenge_eingepackt=0 then laenge_eingepackt:=laenge_ausgepackt;
    archiv_datei;
    exezk:=hex_longint(DGT_zu_longint(analyseoff))+' '+hex_longint(longint_z(@p.d[$b+0])^)+' '+Chr(p.d[$8]);
    archiv_datei_ausschrift(exezk);
    einzel_laenge:=word_z(@p.d[$9])^+laenge_eingepackt;
    befehl_schnitt(analyseoff+$1b,laenge_eingepackt,hex_longint(DGT_zu_longint(analyseoff)));
    archiv_summe_leise;
  end;


procedure setup_twk;
  var
    w1                  :word;
    o                   :dateigroessetyp;
  begin
    ausschrift(textz_form__unbekanntes_Archiv^+' <SETUP_TWK / TOWITOKO electronics GmBH>',packer_dat);
    if not langformat then exit;

    o:=$e;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,256);

      exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
      if exezk='ende' then
        begin
          IncDGT(o,1+Length('ende')+16+2);
          einzel_laenge:=o;
        end;

      if Pos('file,',exezk)<>1 then
        Break;

      IncDGT(o,1+Length(exezk));
      Delete(exezk,1,Length('file,'));
      w1:=Pos(',',exezk);
      if w1=0 then Break;

      laenge_eingepackt64:=ziffer(10,Copy(exezk,1,w1-1));
      Delete(exezk,1,w1);

      laenge_ausgepackt64:=laenge_eingepackt;
      (* meist noch mit compress / ms gepackt *)
      datei_lesen(form_puffer,analyseoff+o,14);
      if bytesuche(form_puffer.d[0],'SZDD') then
        laenge_ausgepackt64:=longint_z(@form_puffer.d[10])^;

      archiv_datei64;
      archiv_datei_ausschrift(exezk);
      IncDGT(o,laenge_eingepackt64);
    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure versuche_ttf(const p:puffertyp);
  var
    z,anzahl    :longint;
    namen_puffer:puffertyp;
    laenge      :longint;
    datenanfang :longint;
    o,l,
    ende,
    oo          :longint;
    hersteller  :string;
    schriftname :string;
    schriftform :string;
    w1,w2       :word_norm;
    gefunden    :boolean;
  begin
    w1:=m_word(p.d[4]);
    ende:=12+w1*16;
    if einzel_laenge<ende then Exit;

    gefunden:=false;
    for w2:=1 to w1 do
      if bytesuche__datei_lesen(analyseoff+12+(w2-1)*16,'OS/2') then
        begin
          gefunden:=true;
          Break;
        end;


    if not gefunden then Exit;

    for w2:=1 to w1 do
      begin
        datei_lesen(form_puffer,analyseoff+12+(w2-1)*16,$10);
        o:=m_longint(form_puffer.d[4+4]);
        l:=m_longint(form_puffer.d[4+4+4]);
        ende:=Max(ende,o+l);

        if bytesuche(form_puffer.d[0],'name') then
          begin
            hersteller:='';
            schriftname:='';
            schriftform:='';

            datei_lesen(form_puffer,o,6);
            anzahl:=m_longint(form_puffer.d[0]);
            datenanfang:=o+m_word(form_puffer.d[4]);

            for z:=1 to anzahl do
              begin
                datei_lesen(form_puffer,o+6+z*12-12,12);

                laenge:=m_word(form_puffer.d[8]);
                if laenge>255 then
                  laenge:=255;

                oo:=datenanfang+m_word(form_puffer.d[10]);

                case form_puffer.d[1] of
                  $01:exezk:=datei_lesen__zu_zk_l(oo,laenge);
                  $03:
                    begin
                      (*exezk:=uc16_datei_lesen__zu_zk_e(oo+1,#0,laenge div 2);*)
                      (* comic.ttf: "Standar?" weil Null eingespart wurde *)
                      datei_lesen(namen_puffer,oo+1,laenge);
                      if laenge>=1 then
                        namen_puffer.d[laenge-1]:=0; (* SyrCOMAdiabene.otf *)
                      namen_puffer.d[laenge-0]:=0;
                      namen_puffer.d[laenge+1]:=0;
                      exezk:=uc16_puffer_zu_zk_e(namen_puffer.d[0],#0,(laenge) div 2);
                    end;
                else
                      exezk:='';
                end;


                if (m_word(form_puffer.d[4])=0)
                or ((textz_xexe__sprache^='D') and (m_word(form_puffer.d[4])=$0407))
                or ((textz_xexe__sprache^='E') and (m_word(form_puffer.d[4])=$0409))
                 then
                  case m_word(form_puffer.d[6]) of
                    $0000:hersteller :=exezk;
                    $0001:schriftname:=exezk;
                    $0002:schriftform:=exezk;
                  end;

                (*
                ausschrift(
                  hex_longint(m_longint(form_puffer.d[0]))+' '+
                  hex_longint(m_longint(form_puffer.d[4]))+' '+

                  exezk,beschreibung);*)
              end;

            ausschrift('TrueTypeFont "'+schriftname+'" "'+schriftform+'"',bibliothek);

            loesche_muell(hersteller,'ALL RIGHTS RESERVED.');
            loesche_muell(hersteller,'ALL RIGHTS RESERVED');
            if hersteller<>'' then
              ausschrift(hersteller,beschreibung);
          end;
      end;

    if einzel_laenge<>(ende+3) and (-4) then
      einzel_laenge:=ende;

  end;


procedure protectit2(const p:puffertyp);
  const
    ziel                :string[16]='ProtectIt/2 OS/2';
    verteilung          :array[1..16] of byte=(1,2,3,4,13,14,15,16,9,10,11,12,5,6,7,8);
  var
    kennwort            :string[16];
    z,i                 :word_norm;
    t                   :byte;
  begin
    kennwort[0]:=#16;
    for z:=1 to 16 do
      begin
        i:=verteilung[z];
        t:=p.d[4+i-1] xor Ord(ziel[i]);
        t:=t shr 2;
        if Odd(z) then
          kennwort[z]:=Chr(t xor ($a5 and $3f))
        else
          kennwort[z]:=Chr(t xor ($5a and $3f));
      end;

    for z:=16 downto 1 do
      if kennwort[z]<'0' then
        if (kennwort[z]=#0) and (z=Length(kennwort)) then
          Dec(kennwort[0])
        else
          Inc(kennwort[z],Ord(#$40));

    ausschrift('ProtectIt/2 / Roman Stangl '+in_doppelten_anfuerungszeichen(kennwort),packer_dat);

    befehl_protect(kennwort);

    if not langformat then exit;

    archiv_start;
    laenge_eingepackt64:=einzel_laenge-$118;
    laenge_ausgepackt64:=laenge_eingepackt;
    archiv_datei64;
    archiv_datei_ausschrift(puffer_zu_zk_e(p.d[$14],#0,255));
    archiv_summe;
  end;

procedure indigorose_archiv;
  var
    o                   :dateigroessetyp;
    anzahl              :word_norm;
    exe2_anfang         :dateigroessetyp;
  begin
    (* DISCON.EXE *)
    ausschrift('Setup Factory / Indigo Rose [PKWARE-LIB]',packer_dat);
    if not langformat then exit;

    anzahl:=x_longint__datei_lesen(analyseoff+8);
    o:=$8+4;
    archiv_start;
    while (anzahl>0) do
      begin
        Dec(Anzahl);
        datei_lesen(form_puffer,analyseoff+o,(* $18*)$10c);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
        if bytesuche(form_puffer.d[$100-4],#$00#$00#$00#$00'???????'#$00) then
          begin
            IncDGT(o,$10c-$18);
            datei_lesen(form_puffer,analyseoff+o,$18);
          end;
        laenge_eingepackt:=longint_z(@form_puffer.d[$10])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        IncDGT(o,$18);
        befehl_ttdecomp(analyseoff+o,laenge_eingepackt,exezk);
        IncDGT(o,laenge_eingepackt);
      end;
    archiv_summe;

    (* Die Dateibereiche sind

      PE-EXE
      Archiv (6 Dateinen)
      PKWARE: BASIC DLL
      PKWARE: OLE DLL
      PKWARE: ASYCFILT DLL
      PKWARE: OLE DLL
      ....


      ZIP                         oder vei Virtual PC 5: nur pkware-blîcke
      PKWARE: DELDLL.BAT
      PKWARE: DELDLL.PIF           *)

    datei_lesen(form_puffer,analyseoff+o,2);
    if bytesuche(form_puffer.d[0],#$00#$06) then
      begin

        exe2_anfang:=analyseoff+o;

        while exe2_anfang<analyseoff+einzel_laenge do
          begin
            exe2_anfang:=datei_pos_suche(exe2_anfang,analyseoff+einzel_laenge,#$00#$06{#$9a#$68}{#$81#$04});
            if exe2_anfang=nicht_gefunden then Break;

            datei_lesen(form_puffer,exe2_anfang-4,4+8);
            (* Keine sichere Erkennung, aber gut genug *)
            if not bytesuche(form_puffer.d[4+2],#$9a#$68) (* 'MZ'? *)
             then
              (* gepackte Daten scheinen auf 0f,03,... zu enden *)
              if ((form_puffer.d[4-1] and $f0)<>$00)
              (* vorher FC,F0,.. *)
              or ((form_puffer.d[4-2] and $f0)<>$f0) then
                begin
                  (* ausschrift('?:'+hex_longint(exe2_anfang)+' : '+hex(form_puffer.d[4-2])
                      +' '+hex(form_puffer.d[4-1]),normal); *)
                  IncDGT(exe2_anfang,1);
                  Continue;
                end;

            merke_position(exe2_anfang,datentyp_unbekannt);
            IncDGT(exe2_anfang,10);

          end; (* exe2_anfang<analyseoff+einzel_laenge *)

      end; (* 00 06 *)

    exe2_anfang:=datei_pos_suche(analyseoff+o,analyseoff+einzel_laenge,'MZ?????'#$00'?'#$00#$00#$00);
    if exe2_anfang<>nicht_gefunden then
      merke_position(exe2_anfang,datentyp_unbekannt);
    einzel_laenge:=o;
  end;

procedure ffs_archiv;
  var
    o,o2,begrenzung:dateigroessetyp;
  begin
    ausschrift('FFS / ?',packer_dat);
    if not langformat then exit;

    (* Anzahl der Dateien kînnte bei [4].longint sein *)
    o:=analyseoff+16;
    begrenzung:=dateilaenge;
    archiv_start;
    repeat
      o2:=x_longint__datei_lesen(o+4);
      if begrenzung>o2 then
        begrenzung:=o2;
      datei_lesen(form_puffer,o2,4+4+4);
      laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
      laenge_ausgepackt:=laenge_eingepackt; (* unbekannt *)
      archiv_datei;
      archiv_datei_ausschrift('?');
      IncDGT(o,2*4);
    until o>=begrenzung;
    archiv_summe;
  end;

procedure pkware_lib;
  var
    dname:string;
  begin
    dname:=hex_DGT(analyseoff);
    while Length(dname)>8 do Delete(dname,1,1);
    ausschrift('TTCOMP / SWFT International (PKWARE'+textz_form__Bibliothek_gepackt^+')',packer_dat);
    if analyseoff>0 then
      befehl_ttdecomp(analyseoff,einzel_laenge,dname);
      (* habe keinen richtigen Dateinamen und ttdecom ist ein DOS-Programm...*)
  end;

end.

