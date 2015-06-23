(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_for2;

interface

uses
  typ_type;

procedure pgp_binaer;
procedure binscii(o0:dateigroessetyp);
procedure jar(const jp:puffertyp);
procedure ea_archiv(const titel:string;start:dateigroessetyp);
procedure leolzw;
procedure buildsfx(o,copyr:dateigroessetyp);
procedure pksmart(const p:puffertyp);
procedure dirk_paehl;
procedure kboom(const p:puffertyp);
procedure esp(const p:puffertyp);
procedure jbf_enh(const ende:dateigroessetyp;const anzahl:word);
procedure car;
procedure bzip;
procedure backagain;
procedure zet;
procedure ace(const ver:byte);
procedure sky;
procedure gammatech;
procedure abcomp(const p:puffertyp);
procedure ppmz(const p:puffertyp);
procedure terse(const p:puffertyp);
procedure mov;
procedure descent_hog;
procedure descent_dsnd(const p:puffertyp);
procedure packit;
procedure backup(const p:puffertyp);
procedure backupjfs(const p:puffertyp);
procedure xlink(const p:puffertyp);
procedure dog(const p:puffertyp);
procedure arg(const p:puffertyp);
procedure jarcs(const p:puffertyp);
procedure pack_3com(const p:puffertyp);
procedure rd_archiv(const p:puffertyp);
procedure xpack_arc;
procedure xpa32_100;
procedure impos2;
procedure unipatchvolume(const p:puffertyp);
procedure emf(anzahl:word;ende:dateigroessetyp);
procedure eli;
procedure msxie(const ver:byte);
procedure nfvp(const p:puffertyp);
procedure uha2;
procedure cdf(const p:puffertyp);
procedure mpc3;
procedure install_svga;
procedure rax;
procedure hit;
procedure dietdisk(const p:puffertyp);
procedure pak_dd;
procedure arh;
procedure asd01(const p:puffertyp);
procedure nsk;
procedure psarc(const p:puffertyp);
procedure azt;
procedure arch_lib;
procedure wise_glb(const p:puffertyp;const o1:dateigroessetyp);
procedure cfos;
procedure ldf(const p:puffertyp);
procedure ldiff_210(const p:puffertyp);
procedure screenthief_install;
procedure qip(const p:puffertyp);
procedure imp(const p:puffertyp);
procedure ark101(const o0:dateigroessetyp);
procedure stirling_isc(const p:puffertyp);
procedure gpfpack(const p:puffertyp);
procedure bix;
procedure quickfilecollection;
procedure rpm(const p:puffertyp);
procedure lza_100_lzz(const p:puffertyp);
procedure lza_100_lza(const p:puffertyp);
procedure szip(const p:puffertyp);
procedure blink_dts(const p:puffertyp);
procedure par147(const p:puffertyp);
procedure par148(const p:puffertyp);
procedure sbx;
procedure pocket_arch(const p:puffertyp);
procedure compress_ii204(const p:puffertyp;const i0:word_norm);
procedure pw2_install;
procedure ati_exe_archiv(const p:puffertyp);
procedure sextwiz;
procedure saxsetup(const anfang,ende:dateigroessetyp);
procedure saxsetup_6(const anfang,ende:dateigroessetyp);
procedure akt_06(const p:puffertyp);
procedure stardock_sf_archiv;
procedure zap_zip_archiv(const ende:dateigroessetyp;const verzeichnislaenge:word_norm;
                         const pfade_abgespeichert:boolean;const version:byte);
procedure graham_archiv(const p:puffertyp);
procedure semone(const p:puffertyp);
procedure bdsap(const p:puffertyp;name_id:word_norm);
procedure gather_2;
procedure rid;
procedure pm2you24_zap;
procedure rtd_dat;
procedure timesink_install(const typ:string);
procedure norton_av_archiv(const oe:dateigroessetyp);
procedure wpi(const o0:dateigroessetyp;const dnn:string);
procedure zpak;
procedure logitech_expand(const p:puffertyp);
procedure tpwm(const p:puffertyp);
procedure graphics_bpd(const anzahl:longint);
procedure vxrexx{(const o_:longint;const version:byte;const zusatzblock:longint)};
procedure nai_lzhuflib;
procedure linkit_michael_badichi;
procedure svct;
procedure tgcf;
procedure oberon_arc;
procedure vise_pe(const p:puffertyp);
procedure jls_archiv(const p:puffertyp);

implementation

uses
  typ_eiau,
  typ_ausg,
  typ_var,
  typ_varx,
  typ_dien,
  typ_dat,
  typ_eas,
  typ_for0,
  typ_spra,
  typ_posm,
  typ_entp;

procedure pgp_binaer;
  var
    o                   :longint;
    laenge              :longint;
    markierung          :aus_attribute;
    laenge_laenge       :longint;

  function pgp_version(b:byte):string;
    begin
      case b of
        2:pgp_version:='2.5-';
        3:pgp_version:='2.6+';
        4:pgp_version:='5.x';
      else
          pgp_version:='?.?';
      end;
    end;

  begin
    ausschrift('PGP / Phillip Zimmerman',packer_dat);
    if not langformat then exit;

    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,100);
      if (form_puffer.d[0] and (1 shl 7))=0 then
        (* kein CTB? *)
        break;

      case form_puffer.d[0] and 3 of
        0:laenge:=1+longint(form_puffer.d[1]);
        1:laenge:=1+longint(m_word(form_puffer.d[1]));
        2:laenge:=1+m_longint(form_puffer.d[1]);
        3:laenge:=-1; (* unbekannt *)
      end;

      laenge_laenge:=1 shl (form_puffer.d[0] and 3);

      markierung:=packer_dat;
      case (form_puffer.d[0] shr 2) and $f of
        1:
          begin
            markierung:=beschreibung;
            exezk:=textz_form__leerleer_verschluesselt_mit_oeffentlichem_Schluessel^;
          end;
        2:
          begin
            markierung:=beschreibung;
            exezk:=textz_form__Unterschrift_mit_privatem_Schluessel^;
          end;
        5:
          begin
            exezk:=textz_form__PRIVATER_SCHLueSSEL^;
            exezk_anhaengen(' '+textz_form__Version_leer^+pgp_version(form_puffer.d[1+laenge_laenge]));
            (* >7000 bit ... exezk_anhaengen(' '+str((laenge-14)*8,0)+' Bit'); *)
          end;
        6:
          begin
            exezk:=textz_form__oeffentlicher_Schluessel^;
            exezk_anhaengen(' '+textz_form__Version_leer^+pgp_version(form_puffer.d[1+laenge_laenge]));
            if form_puffer.d[1+laenge_laenge]<=3 then (* 2.x *)
              begin
                exezk_anhaengen(' '+str0((laenge-14)*8)+' Bit');
              end
            else  (* 5.x *)
              begin
                exezk_anhaengen(' '+str0((laenge-14)*8)+' Bit');
                {case form_puffer.d[1+laenge_laenge+1+8] of
                  1:exezk_anhaengen(' RSA');
                  2:exezk_anhaengen(' DSS/Diffie-Hellman');

            else
                exezk_anhaengen(' ???');}
            end;
          end;
{!!!!!!!!!
        7:
          begin

            exezk:='.7';
          end;}
        8:exezk:=textz_form__komprimierte_Daten^;
        9:exezk:=textz_form__normal_verschluesselte_Daten^;
       11:exezk:=textz_form__klammer_Klartext_klammer^;
       12:exezk:=textz_form__Schluesselbestaetigung^;
       13:
         begin
           markierung:=beschreibung;
           exezk:=textz_form__Erzeuger_doppelpunkt_anf^+puffer_zu_zk_pstr(form_puffer.d[1])+'"';
         end;

       14:
         begin
           markierung:=beschreibung;
           exezk:=textz_form__Kommentar_doppelpunkt_anf^+puffer_zu_zk_pstr(form_puffer.d[1])+'"';
         end;
      else
          exezk:='???';
          markierung:=signatur;
      end;

      ausschrift(exezk,markierung);

      if laenge=-1 then break;

      Inc(o,laenge);
      Inc(o,laenge_laenge);

    until (o>=einzel_laenge);
    if o>einzel_laenge then
      ausschrift(textz_form__beschaedigt^,packer_dat);
  end;


procedure binscii(o0:dateigroessetyp);
  var
    kodierung           :string[64];
    cr_lf               :byte;
    l1                  :longint;
    start               :longint;
    w1                  :word_norm;
  begin
    ausschrift('APPLE II Binscii / Marcel J. E. Mol',packer_dat);

    IncDGT(o0,length('FiLeStArTfIlEsTaRt'));
    datei_lesen(form_puffer,analyseoff+o0,2);
    if form_puffer.d[1]=Ord(^m) then
      cr_lf:=2
    else
      cr_lf:=1;

    IncDGT(o0,cr_lf);
    datei_lesen(form_puffer,analyseoff+o0,64);
    kodierung:=puffer_zu_zk_l(form_puffer.d[0],64);
    IncDGT(o0,64);
    IncDGT(o0,cr_lf);

    datei_lesen(form_puffer,analyseoff+o0,64);

    form_puffer.d[0]:=pos(chr(form_puffer.d[0]),kodierung);
    for w1:=0 to ((64-16) div 4)-1 do
      begin
        l1:=longint(pos(chr(form_puffer.d[16+w1*4+0]),kodierung)-1) shl (0*6)
           +longint(pos(chr(form_puffer.d[16+w1*4+1]),kodierung)-1) shl (1*6)
           +longint(pos(chr(form_puffer.d[16+w1*4+2]),kodierung)-1) shl (2*6)
           +longint(pos(chr(form_puffer.d[16+w1*4+3]),kodierung)-1) shl (3*6);
        form_puffer.d[16+w1*3+0]:=(l1 shr (2*8)) and $ff;
        form_puffer.d[16+w1*3+1]:=(l1 shr (1*8)) and $ff;
        form_puffer.d[16+w1*3+2]:=(l1 shr (0*8)) and $ff;
      end;

    archiv_start_leise;
    start:=longint_z(@form_puffer.d[16+3])^ and $ffffff;
    laenge_ausgepackt:=longint_z(@form_puffer.d[16+21])^ and $ffffff;
    laenge_eingepackt:=(((laenge_ausgepackt*4) div 3) div 64)*(64+cr_lf)-1;

    IncDGT(o0,$3a+cr_lf);

    if (einzel_laenge<o0+laenge_eingepackt)
    or (einzel_laenge>o0+laenge_eingepackt+64+cr_lf) then
      einzel_laenge:=o0+laenge_eingepackt;

    archiv_datei;
    ausschrift_x(textz_form__Teildatei_von^+strx(start,11)
                +textz_form__bis^+strx(start+laenge_ausgepackt,11)
                +verhaeltnis_zk+'% '
     +puffer_zu_zk_pstr(form_puffer.d[0]),packer_dat,absatz);

    archiv_summe_leise;
  end;



procedure jar(const jp:puffertyp);
  begin
    ausschrift('Jar / R.Jung',packer_dat);
    if not langformat then exit;

    einzel_laenge:=64+longint_z(@jp.d[8])^;

    if (word_z(@jp.d[$1c])^>0) or (longint_z(@jp.d[$24])^=0) then
      ausschrift(textz_form__Multi_Volum_Archiv_Diskette^+str0(word_z(@jp.d[$1c])^+1),packer_dat);

    case jp.d[$c] of
      0:(* Daten ... *)
        begin
          ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
        end;
      3:(* Sample.j .. secured+locked *)
        begin
          ausschrift(textz_form__mit_Sicherheitshuelle^,packer_dat);
        end;
    end;

    if bytesuche(jp.d[$40],#$19#$96'?0?0') then
      if jp.d[$40+6]=ord('2') then
        ausschrift(textz_form__gesichert^,packer_dat);

  end;

procedure ea_archiv(const titel:string;start:dateigroessetyp);
  begin
    if titel<>'' then
      ausschrift(titel,beschreibung);
    ea_block_eautil(start);
  end;


procedure leolzw;
  var
    o:longint;
  begin
    ausschrift('PAKLEO / Leonardus Leonardi',packer_dat);
    if not langformat then exit;

    datei_lesen(form_puffer,analyseoff,512);
    o:=puffer_pos_suche(form_puffer,#$1a'??-ll',$40);
    if o=nicht_gefunden then exit;

    Inc(o);
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,300);
      if not bytesuche(form_puffer.d[2],'-ll') then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      laenge_eingepackt:=longint_z(@form_puffer.d[$07  ])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$07+4])^;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$19]));

      Inc(o,$19+1+form_puffer.d[$19]);
      Inc(o,laenge_eingepackt);

    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure buildsfx(o,copyr:dateigroessetyp);
  begin
    ausschrift('BuildSFX / Prominence Computer Services Ltd.',packer_dat);
    if not langformat then exit;

    ansi_anzeige(analyseoff+copyr,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
              ,unendlich,'');

    archiv_start;
    repeat
      if einzel_laenge-o<=4 then break;

      datei_lesen(form_puffer,analyseoff+o,100);

      laenge_eingepackt:=word_z(@form_puffer.d[$00])^+form_puffer.d[$02]*$ff80;
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;

      exezk:=puffer_zu_zk_e(form_puffer.d[$4],#0,80);
      archiv_datei_ausschrift(exezk);

      IncDGT(o,4+1+length(exezk));
      befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
      IncDGT(o,laenge_eingepackt+4);

    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure pksmart(const p:puffertyp);
  begin
    (* als Daten *)
    ausschrift('Pksmart / PuchKov Sergey, Alex [1.0]',packer_dat);
    archiv_start_leise;
    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=-1;
    archiv_datei64;
    ausschrift('.'+puffer_zu_zk_e(p.d[8],#0,3),beschreibung);
    archiv_summe_leise;
  end;


procedure dirk_paehl;
  var
    o:longint;
    o1:longint;
  begin
    ausschrift('Dirks Packer / Dirk Peahl',packer_dat);
    if not langformat then exit;


    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,$50);
      o1:=puffer_pos_suche(form_puffer,^z,$50);
      if o1=nicht_gefunden then break;

      Inc(o1);

      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_ausgepackt:=longint_z(@form_puffer.d[o1+$02  ])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[o1+$02+4])^-o;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[o1+2+4+4],#0,255));

      Inc(o,laenge_eingepackt);

    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure kboom(const p:puffertyp);
  begin
    archiv_start_leise;

    laenge_ausgepackt64:=longint_z(@p.d[4])^;
    laenge_eingepackt64:=einzel_laenge;
    archiv_datei64;

    ausschrift('KBOOM / Miles Pawski '+laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);
    archiv_summe_leise;
  end;


procedure esp(const p:puffertyp);
  begin
    ausschrift('Extension-Sort Packer / GyikSoft'+version_div16_mod16(p.d[4]),packer_dat);
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
  end;

procedure jbf_enh(const ende:dateigroessetyp;const anzahl:word);
  var
    zaehler:word;
  begin
    (* 1JELLY2 *)
    ausschrift(textz_form__unbekanntes_Archiv^+' <Jelly Bean Factory/Summit Software>¯',packer_dat);
    if not langformat then exit;

    archiv_start;
    for zaehler:=1 to anzahl do
      begin
        datei_lesen(form_puffer,ende-(anzahl-zaehler+1)*$1f-1,$1f);
        laenge_ausgepackt:=longint_z(@form_puffer.d[$11  ])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[$11-4])^;
        archiv_datei;

        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,8+1+3));
      end;
    archiv_summe;

  end;


procedure car;
  var
    o:longint;
  begin
    (* Control alt del commander *)
    ausschrift(textz_form__unbekanntes_Archiv^+' <CAR/Perez Computing Service>¯',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,80+2+1+10);
      if not bytesuche(form_puffer.d[0],#$03#$01) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;
      exezk:=puffer_zu_zk_e(form_puffer.d[2],#0,80);

      laenge_ausgepackt:=longint_z(@form_puffer.d[2+length(exezk)+2  ])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[2+length(exezk)+2+4])^;
      archiv_datei;


      archiv_datei_ausschrift(exezk);
      Inc(o,length(exezk));
      Inc(o,laenge_eingepackt);
      Inc(o,$18);
    until o+1>=einzel_laenge;
    archiv_summe;
  end;

procedure bzip;
  begin
    ausschrift('BZip / Julian Seward',packer_dat);
    archiv_start_leise;
    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=-1;
    archiv_datei64;
    archiv_summe_leise;
  end;

procedure backagain;
  var
    o:longint;
  begin
    ausschrift('Back Again/2 / Computer Data Strategies + Box Turtle Software ¯',packer_dat);
(* fehlerhaft    if not langformat then exit;

    o:=$1800;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,280);
      if form_puffer.d[8]<>$20 then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;
      exezk:=puffer_zu_zk_e(form_puffer.d[$10],#0,256);
      laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$18+length(exezk)])^;

      archiv_datei;
      archiv_datei_ausschrift(
          +exezk,packer_dat,absatz);

      Inc(o,length(exezk)+$18+$3c+longint_z(@form_puffer.d[$18+length(exezk)])^);
    until false;
    archiv_summe;
             *)
  end;

procedure zet;
  var
    o:longint;
    verzeichnis:string;
  begin
    ausschrift('Zet / Oleg V. Zaimkin',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    verzeichnis:='';

    repeat
      datei_lesen(form_puffer,analyseoff+o,300);


      if not bytesuche(form_puffer.d[0],'OZ') then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      case form_puffer.d[2] of
        $dd:
          (* ›*)
          (* Start *)
          if form_puffer.d[$10]>0 then
            ausschrift(textz_form__Multi_Volum_Archiv_Diskette^+str0(form_puffer.d[$10]+1),packer_dat);

        $de:
          (* ﬁ *)
          (* Ende *)
          break;

        $df:
          (* ﬂ *)
          (* Ende Mulivolume *)
          ausschrift(textz_form__sternsternstern_mit_Fortsetzung_sternsternstern^,packer_dat);

        $e0:
          (* ‡ *)
          (* Verzeichnis *)
          verzeichnis:=puffer_zu_zk_e(form_puffer.d[$a],#0,255);

        $e1:
          (* · *)
          (* Datenblock *)
          Inc(o,word_z(@form_puffer.d[$10-8])^);

        $e2:
          (* ‚ *)
          (* Dateiname *)
          begin
            laenge_ausgepackt:=longint_z(@form_puffer.d[$18])^;
            laenge_eingepackt:=longint_z(@form_puffer.d[$06])^;
            archiv_datei;

            archiv_datei_ausschrift(verzeichnis+puffer_zu_zk_e(form_puffer.d[$1c],#0,80));
          end;
        $e3:
          (* „ *)
          (* Zusatzinformationen *)

      else
        ausschrift('??? '+puffer_zu_zk_l(form_puffer.d[0],4)+' ¯',signatur);
      end;

      Inc(o,form_puffer.d[3]);

    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure ace(const ver:byte);
  var
    o:longint;
  begin

    ausschrift('ACE / Marcel Lemke'+version_div10_mod10(ver),packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,400);

      laenge_eingepackt:=4+word_z(@form_puffer.d[2])^;
      if (form_puffer.d[4+1] and $01)<>0 then (* ADDSIZE *)
        Inc(laenge_eingepackt,longint_z(@form_puffer.d[$07])^);

      if (form_puffer.d[5+1] and $40)<>0 then (* Bit 14 *)
        exezk:=textz_form__eckauf_Kennwort_eckzu^
      else
        exezk:='';

      if (form_puffer.d[5+1] and $10)<>0 then (* Bit 12 *)
        exezk_anhaengen(textz_form__leer_eckauf_Fortsetzung_eckzu^);
      if (form_puffer.d[5+1] and $20)<>0 then (* Bit 13 *)
        exezk_anhaengen(textz_form__leer_eckauf_Bruchstueck_eckzu^);

      case form_puffer.d[4] of
        $00: (* Archivkopf *)
          begin
            if form_puffer.d[$1e]<>0 then (* Regtext *)
              ausschrift(puffer_zu_zk_pstr(form_puffer.d[$1e]),beschreibung);
          end;

        $01:
          begin
            (* Datei *)
            laenge_ausgepackt:=longint_z(@form_puffer.d[$0b])^;
            archiv_datei;

            archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$23],form_puffer.d[$21])+exezk);

            if (form_puffer.d[5+1] and $10)<>0 then (* Fortsetzung *)
              begin
                DecDGT(archiv_summe_ausgepackt,laenge_ausgepackt);
                Dec(archiv_summen_dateien);
              end;

          end;
        $02:
          begin
            (* Wiederherstellungsinformationen .. *)
            ausschrift_x(strx(longint_z(@form_puffer.d[$07])^,11)+textz_form__ecc_^,packer_dat,leer);
          end;

        $05:
          begin
            ausschrift_x(textz_form__ecc_^,packer_dat,leer);

          end;
      else
        if bytesuche(form_puffer.d[0],'DBSOF') then
          begin
            einzel_laenge:=o;
            break;
          end;
        ausschrift('????',signatur);
      end;

      Inc(o,laenge_eingepackt);;

    until o>=einzel_laenge;

    archiv_summe;

    (* DBSOFT Install, SFX.. *)
    if analyseoff<>0 then
      Befehl_Schnitt(analyseoff,einzel_laenge,erzeuge_neuen_dateinamen('.'+DGT_str0(analyseoff)+'.ACE'));

  end;

procedure sky;
  var
    o:longint;
    pfad:string[80];
  begin
    o:=0;
    datei_lesen(form_puffer,analyseoff+o,12);

    ausschrift('Sky / Jean-Michel Herve'+version_div16_mod16(form_puffer.d[2]),packer_dat);
    if not langformat then exit;

    archiv_start;
    ansi_anzeige(analyseoff+o+12,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
            ,o+12+word_z(@form_puffer.d[$a])^,'');
    Inc(o,12+word_z(@form_puffer.d[$a])^);

    repeat
      datei_lesen(form_puffer,analyseoff+o,120);

      laenge_ausgepackt:=longint_z(@form_puffer.d[$06])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$02])^;
      (* datumzeit:=longint_z(@form_puffer.d[$0a])^; *)
      archiv_datei;

      archiv_datei_ausschrift((* +zeit_zk *)
               puffer_zu_zk_l(form_puffer.d[$23],form_puffer.d[$20]) (* Pfad *)
              +puffer_zu_zk_e(form_puffer.d[$15],#0,8)+'.'           (* Name *)
              +puffer_zu_zk_e(form_puffer.d[$15+8],#0,3));           (* Erweiterung *)
      Inc(o,laenge_eingepackt);

    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure gammatech;
  var
    o:longint;
    grenze:longint;
    kopfl:word;

  procedure gamma_einzel(oo:longint);
    var
      nl:word;
      zaehler:word;
      exezk_tmp:string;
    begin
      datei_lesen(form_puffer,analyseoff+oo,512);

      nl:=word_z(@form_puffer.d[$0a])^;
      Inc(oo,nl+$c);

      if nl>255 then nl:=255;
      exezk_tmp:=puffer_zu_zk_l(form_puffer.d[$0c],nl);
      exezk[0]:=exezk_tmp[0];
      exezk_tmp[0]:=chr(24-ord(exezk_tmp[0]));

      for zaehler:=1 to length(exezk) do
        begin
          exezk[zaehler]:=chr(ord(exezk_tmp[zaehler]) -ord(exezk[zaehler-1]));
        end;

      datei_lesen(form_puffer,analyseoff+oo,512);

      laenge_ausgepackt:=longint_z(@form_puffer.d[$0c])^;
      laenge_eingepackt:=-1;
      archiv_datei;

      archiv_datei_ausschrift(exezk);

    end;

  begin
    ausschrift('GammaTech-Archiv',packer_dat);
    if not langformat then exit;

    o:=4;
    archiv_start;

    datei_lesen(form_puffer,analyseoff+o,8);
    grenze:=longint_z(@form_puffer.d[0])^;
    while o<grenze do
      begin
        datei_lesen(form_puffer,analyseoff+o,12);
        kopfl:=12+word_z(@form_puffer.d[$0a])^;
        gamma_einzel(longint_z(@form_puffer.d[0])^);
        Inc(o,kopfl);
      end;

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=falsch;
    archiv_summe;
  end;


procedure wa;
  var
    o:longint;
  begin
    ausschrift('Waveform Archiver / Dennis Lee',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,80);
      if form_puffer.d[0]=0 then break;

      laenge_ausgepackt:=longint_z(@form_puffer.d[form_puffer.d[0]+ 6])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[form_puffer.d[0]+10])^;
      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]));

      Inc(o,form_puffer.d[0]+22+laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;


procedure abcomp(const p:puffertyp);
  begin
    if bytesuche(p.d[p.d[0]+2],'0CPY')
    or bytesuche(p.d[p.d[0]+2],'1DIF')
    or bytesuche(p.d[p.d[0]+2],'2SLP')
    or bytesuche(p.d[p.d[0]+2],'3NLP')
    or bytesuche(p.d[p.d[0]+2],'4ALP')
    or bytesuche(p.d[p.d[0]+2],'5ELP')
     then
      begin
        wa;
        Exit;
      end;

    (* nicht Apogee (ALIEN CARNAGE,..) als ABCOMP werten! *)
    if longint_z(@p.d[1+8+1+3])^=0 then Exit;

    archiv_start_leise;
    laenge_ausgepackt64:=longint_z(@p.d[1+8+1+3])^;
    laenge_eingepackt64:=einzel_laenge;
    exezk:=puffer_zu_zk_pstr(p.d[0]);
    if not ist_ohne_steuerzeichen_nicht_so_streng(exezk) then Exit;

    archiv_datei64;

    leerzeichenerweiterung(exezk,8+1+3);
    ausschrift('ABComp / Avinesh Bangar [2.04] ( '+exezk+' ) '
      +laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);

    archiv_summe_leise;
  end;

procedure ppmz(const p:puffertyp);
  begin
    archiv_start_leise;
    laenge_ausgepackt64:=m_longint(p.d[8]);
    laenge_eingepackt64:=einzel_laenge;
    archiv_datei64;
    ausschrift('PPMZ / Charles Bloom'+version100(p.d[4]*100+p.d[5])+' '
      +laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);

    archiv_summe_leise;
  end;

procedure terse(const p:puffertyp);
  begin
    archiv_start_leise;
    laenge_ausgepackt64:=-1;
    laenge_eingepackt64:=einzel_laenge;
    archiv_datei64;
    ausschrift('Terse / Michael Nagy',packer_dat);
    archiv_summe_leise;
  end;

procedure mov;
  var
    o:longint;
  begin
    ausschrift('Quicktime / Apple',musik_bild);
    if not langformat then exit;

    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,30);
      ausschrift(puffer_zu_zk_l(form_puffer.d[4],4)+str_(m_longint(form_puffer.d[0]),8),musik_bild);
      Inc(o,m_longint(form_puffer.d[0]));
    until o>=einzel_laenge;
  end;

procedure descent_hog;
  var
    o:longint;
  begin
    ausschrift('Descent HOG / Parallax',packer_dat);
    if not langformat then exit;

    o:=3;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,80);
      if form_puffer.d[0] in [0,255] then break;
      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,8+1+3);
      laenge_ausgepackt:=longint_z(@form_puffer.d[13])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[13])^;
      archiv_datei;
      archiv_datei_ausschrift(exezk);

      Inc(o,17+laenge_eingepackt);
    until o>einzel_laenge;
    archiv_summe;
  end;

procedure descent_dsnd(const p:puffertyp);
  var
    anzahl,zaehler:longint;
  begin
    ausschrift('Descent DSND / Parallax',packer_dat);
    if not langformat then exit;

    archiv_start;
    anzahl:=longint_z(@p.d[8])^;
    for zaehler:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+zaehler*(8+4+4+4)-8,8+4+4+4);
        laenge_ausgepackt:=longint_z(@form_puffer.d[8])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[8+4])^;
        archiv_datei;
        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,8));
      end;
    archiv_summe;

  end;

procedure packit;
  var
    o:longint;
  begin
    (* BW22_OS2.ZIP *)
    ausschrift(textz_form__unbekanntes_Archiv^+' <PACKIT ¯>',packer_dat);
    if not langformat then exit;

    o:=$10;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,40);
      if form_puffer.d[1]=$ff then break;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$02])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$02])^;
      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$12]));
      Inc(o,20+form_puffer.d[$12]+laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure backup(const p:puffertyp);
  var
    anzahl,zaehler      :word;
    o                   :longint;
    pfad                :string;
    os2_backup          :boolean;
  begin
    if p.d[$8b]=ord('F') then
      begin
        os2_backup:=falsch;
        exezk:='XX-DOS';
      end
    else
      begin
        os2_backup:=wahr;
        exezk:='OS/2';
      end;

    ausschrift('BACKUP / '+exezk+textz_form__Datentraeger^+str0(word_z(@p.d[$9])^),packer_dat);
    if not langformat then exit;

    pfad:='';
    archiv_start;
    o:=$8b;

    if os2_backup then
      repeat
        datei_lesen(form_puffer,analyseoff+o,512);

{            if form_puffer.d[$11]=2 then
               exezk:=' [Fortsetzung]'
            else        !!!!!}
              exezk:='';

        case form_puffer.d[7] of
          $00, (* Verzeichnis *)
          $ff: (* Verzeichnis mit EA *)
            begin
              pfad:=puffer_zu_zk_l(form_puffer.d[$13],word_z(@form_puffer.d[$11])^);
              ausschrift(pfad,packer_dat);
            end;

          $01: (* richtige Dateien *)
            begin
              laenge_ausgepackt:=longint_z(@form_puffer.d[$03])^;
              laenge_eingepackt:=laenge_ausgepackt;
              archiv_datei;

              archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$21],word_z(@form_puffer.d[$1f])^)+exezk);
            end;
        else
          ausschrift('???',signatur);
        end;

        Inc(o,word_z(@form_puffer.d[0])^);
      until o>=einzel_laenge
    else (* DOS *)
      repeat
        datei_lesen(form_puffer,analyseoff+o+0,$40+2);
        pfad:=puffer_zu_zk_e(form_puffer.d[1],#0,$40)+'\';
        ausschrift(pfad,packer_dat);
        anzahl:=word_z(@form_puffer.d[$40])^;
        Inc(o,$47);
        for zaehler:=1 to anzahl do
          begin
            datei_lesen(form_puffer,analyseoff+o+(zaehler-1)*$22,$22);
            laenge_ausgepackt:=longint_z(@form_puffer.d[$17])^;
            laenge_eingepackt:=laenge_ausgepackt;

            archiv_datei;
            if form_puffer.d[$11]=2 then
               exezk:=textz_form__Datentraeger^
            else
              exezk:='';

            archiv_datei_ausschrift(pfad+puffer_zu_zk_e(form_puffer.d[0],#0,12)+exezk);

          end;
        Inc(o,anzahl*$22-1);
      until o>=einzel_laenge;

    archiv_summe;
  end;

procedure backupjfs(const p:puffertyp);
  var
    anzahl,zaehler      :word;
    o                   :longint;
    pfad                :string;
  begin
    ausschrift('BackupJFS / IBM [OS/2 4.51, 64bit]'+textz_form__Datentraeger^+str0(word_z(@p.d[$9])^),packer_dat);
    if not langformat then exit;

    pfad:='';
    archiv_start;
    o:=$8b;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      case form_puffer.d[7+4] of
        $00, (* Verzeichnis *)
        $ff: (* Verzeichnis mit EA *)
          begin
            pfad:=puffer_zu_zk_l(form_puffer.d[$13+$c],word_z(@form_puffer.d[$11+$c])^);
            ausschrift(pfad,packer_dat);
          end;

        $01: (* richtige Dateien *)
          begin
            (*$IfDef dateigroessetyp_comp*)
            laenge_ausgepackt64:=comp_z(@form_puffer.d[$03])^;
            (*$Else dateigroessetyp_comp*)
            if longint_z(@form_puffer.d[$03+4])^=0 then
              laenge_ausgepackt64:=longint_z(@form_puffer.d[$03+4])^
            else
              laenge_ausgepackt64:=-1;
            (*$EndIf dateigroessetyp_comp*)
            laenge_eingepackt64:=laenge_ausgepackt64;
            archiv_datei64;

            archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$21+$14],word_z(@form_puffer.d[$1f+$14])^));
          end;
      else
        ausschrift('???',signatur);
      end;

      Inc(o,word_z(@form_puffer.d[0])^);
    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure xlink(const p:puffertyp);
  var
    anzahl,zaehler,entschluesselung:word;
  begin
    case p.d[2] of
      2:exezk:='2.02';
      8:exezk:='2.50'; (* XLC Professional Version 2.50b .. 1994-96 *)
    else
        exezk:='?.?? ¯';
    end;

    ausschrift('XLINK / J.E.Hoffmann ['+exezk+']',bibliothek);
    if not langformat then exit;

    archiv_start;
    anzahl:=word_z(@p.d[8])^;

    for zaehler:=0 to anzahl-1 do
      begin
        datei_lesen(form_puffer,analyseoff+zaehler*$20+longint_z(@p.d[$c])^,512);

        for entschluesselung:=0 to { $1f}511 do
          Dec(form_puffer.d[entschluesselung],(entschluesselung+zaehler*$20) and $ff);

        laenge_eingepackt:=longint_z(@form_puffer.d[$10])^;
        laenge_ausgepackt:=laenge_eingepackt;

        archiv_datei;

        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$00],#0,8+1+3));
      end;

    archiv_summe;

  end;

procedure dog(const p:puffertyp);
  var
    o                   :longint;
    datei_anzahl        :word_norm;
    datei_zaehler       :word_norm;
    schluessel          :word;
    w1                  :word_norm;
  function dog_schluessel(posi:longint):byte;
    var
      _ax,_dx,_bx:word;
      tmp:byte;
    begin
      if schluessel=0 then
        begin
          dog_schluessel:=0;
          exit;
        end;

      _ax:=(posi shr  0) and $ffff;
      _dx:=(posi shr 16) and $ffff;
      _bx:=schluessel;
      asm
        mov bx,_bx
        mov ax,_ax
        mov dx,_dx
        stc
        xor ax,42142
        xchg al,dh
        not ax
        not dx
        xor dx,7555
        rcl ax,1
        rcr dx,1
        rcr ax,1
        mul dx
        xor dx,57425
        xor dx,bx
        xor ax,dx
        xor al, ah
        mov tmp,al
      end;
      dog_schluessel:=tmp;
    end;

  begin
    if (longint_z(@p.d[2])^+word_z(@p.d[$c])^+6<>einzel_laenge) then exit;

    schluessel:=word_z(@p.d[8])^;
    ausschrift('DOG / K^3 [2.12]  ('+hex_word(schluessel)+')',packer_dat);

    if not langformat then exit;

    datei_anzahl:=word_z(@p.d[6])^;

    o:=0;

    archiv_start;

    for datei_zaehler:=1 to datei_anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+$60+o,512);
        for w1:=low(form_puffer.d) to high(form_puffer.d) do
          form_puffer.d[w1]:=form_puffer.d[w1] xor dog_schluessel(o+w1);

        laenge_eingepackt:=longint_z(@form_puffer.d[6])^;
        laenge_ausgepackt:=laenge_eingepackt;

        archiv_datei;

        exezk:=puffer_zu_zk_e(form_puffer.d[$16],#0,128);
        archiv_datei_ausschrift(exezk);
        Inc(o,$16+length(exezk)+1);
      end;

    archiv_summe;


  end;

procedure arg(const p:puffertyp);
  var
    o:longint;
  begin
    exezk:=puffer_zu_zk_e(p.d[1],#0,8+1+3);

    if length(exezk)<=3 then exit;

    if filter(exezk)<>exezk then exit;

    if (length(exezk)>=8+1) and (pos('.',exezk)=0) then exit;

    if longint_z(@p.d[$12])^<longint_z(@p.d[$12+4])^ then exit;

    if longint_z(@p.d[$12])^<1 then exit;

    if longint_z(@p.d[$12])^>1024*1024*500 then exit;

    ausschrift('ARG / Igor Pavlov [1.01]',packer_dat);

    if not langformat then exit;

    archiv_start;
    o:=0;

    repeat
      datei_lesen(form_puffer,analyseoff+o,$20);

      case form_puffer.d[0] of
        0:
          begin
            laenge_eingepackt:=longint_z(@form_puffer.d[$12+4])^;
            laenge_ausgepackt:=longint_z(@form_puffer.d[$12+0])^;

            archiv_datei;

            archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[1],#0,8+1+3));
            Inc(o,$1a);
            Inc(o,laenge_eingepackt);
          end;
        1:break;
      else
          ausschrift('???',signatur);
          break;
      end;
    until o>=einzel_laenge;

    archiv_summe;

  end;

procedure jarcs(const p:puffertyp);
  var
    o,kommentarlaenge:longint;
  begin
    ausschrift('JARCS / Junichi Uekawa [0.94‚]',packer_dat);

    if not langformat then exit;

    if p.d[$c]=1 then
      begin
        ausschrift('-S (solid)',packer_dat);
        exit;
      end;

    archiv_start;

    (* Archivkommentar *)
    o:=$20;
    datei_lesen(form_puffer,analyseoff+o,$4);
    kommentarlaenge:=longint_z(@form_puffer.d[0])^;
    Inc(o,4);

    if kommentarlaenge<>0 then
      ansi_anzeige(analyseoff+o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
      ,o+kommentarlaenge,'');

    Inc(o,kommentarlaenge);

    (* Archiv *)
    repeat
      datei_lesen(form_puffer,analyseoff+o,$a0);

      laenge_eingepackt:=longint_z(@form_puffer.d[$68])^;
      case form_puffer.d[$60] of
        $01:laenge_ausgepackt:=longint_z(@form_puffer.d[$7e])^;
        $04:laenge_ausgepackt:=m_longint(form_puffer.d[$7c]);
        $05:laenge_ausgepackt:=m_longint(form_puffer.d[$7c]);
      else
            laenge_ausgepackt:=-1;
      end;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,$60));
      Inc(o,$7c);
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;

    archiv_summe;

  end;

procedure pack_3com(const p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('PACK / 3COM (?)',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,$30);
      laenge_eingepackt:=longint_z(@form_puffer.d[$00])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$19])^;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$c],#0,8+1+3));
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;

    archiv_summe;

  end;

procedure rd_archiv(const  p:puffertyp);
  var
    zaehler,anzahl:word{!!!!!!!};
  begin
    (* TAKEONE *)
    ausschrift(textz_form__unbekanntes_Archiv^+' <RD/Rainer Dîble>',packer_dat);
    if not langformat then exit;

    anzahl:=word_z(@p.d[$2])^;

    archiv_start;

    for zaehler:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+2+2+(zaehler-1)*22,22*2);
        laenge_ausgepackt64:=longint_z(@form_puffer.d[$12])^;

        if zaehler=anzahl then
          laenge_eingepackt64:=einzel_laenge-longint_z(@form_puffer.d[$0e])^
        else
          laenge_eingepackt64:=longint_z(@form_puffer.d[$0e+22])^-longint_z(@form_puffer.d[$0e])^;

        archiv_datei64;

        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,8+1+3));
      end;

    archiv_summe;

  end;

procedure xpack_arc;
  var
    o:longint;
  begin
    ausschrift('XPACK / JauMing Tseng',packer_dat);
    if not langformat then exit;

    o:=$f;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,300);
      laenge_eingepackt:=longint_z(@form_puffer.d[$04])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$16])^;

      archiv_datei;

      exezk:=puffer_zu_zk_e(form_puffer.d[$1a],#0,255);
      archiv_datei_ausschrift(exezk);

      Inc(o,$28);
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure xpa32_100;
  var
    o:longint;
    w1:word_norm;
  begin
    (* APLIB ~~ 0.20 *)
    ausschrift('XPA32 / JauMing Tseng [1.0.2]',packer_dat);
    if not langformat then exit;

    o:=$5;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,300);
      if form_puffer.d[0]<1 then break;

      w1:=form_puffer.d[0];
      laenge_eingepackt:=longint_z(@form_puffer.d[w1+5])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[w1+1])^;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]));

      Inc(o,w1+9+laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure impos2;
  var
    o:longint;
  begin
    ausschrift('PACKER <IMPOS/2 / Compart Systemhaus> [PKWARE-LIB]',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$20);
      if not bytesuche(form_puffer.d[0],'DH'#$09#$02) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;


      laenge_eingepackt:=longint_z(@form_puffer.d[$14])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$18])^;

      archiv_datei;

      exezk:=puffer_zu_zk_e(form_puffer.d[4],#$0a,8+1+3);
      archiv_datei_ausschrift(exezk);

      Inc(o,$20);
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure unipatchvolume(const  p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('UniPatchVolume / LKCC "'+puffer_zu_zk_e(p.d[$27],#0,60)+'"',packer_dat);
    if not langformat then exit;

    o:=longint_z(@p.d[$14])^;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,130);
      laenge_eingepackt:=longint_z(@form_puffer.d[$00])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$00])^;

      archiv_datei;

      exezk:=puffer_zu_zk_e(form_puffer.d[$e],#0,120);
      archiv_datei_ausschrift(exezk);

      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure emf(anzahl:word;ende:dateigroessetyp);
  var
    zaehler:word;
  begin
    ausschrift('EMF / Electromotive Force',packer_dat);
    if not langformat then exit;

    archiv_start;
    for zaehler:=1 to anzahl do
      begin
        datei_lesen(form_puffer,ende-zaehler*$20-$0c,$20);
        laenge_eingepackt:=longint_z(@form_puffer.d[$14])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[$14])^; (* ? $1c *)

        archiv_datei;

        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,8+1+3);
        archiv_datei_ausschrift(exezk);
      end;
    archiv_summe;

  end;

procedure eli;
  var
    o:longint;
  begin
    ausschrift('ELI / Jule Revsin',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,200);
      if not bytesuche(form_puffer.d[0],'Ora ') then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      laenge_eingepackt:=longint_z(@form_puffer.d[$0f])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$04])^;

      archiv_datei;

      exezk:=puffer_zu_zk_pstr(form_puffer.d[$1a]);
      archiv_datei_ausschrift(exezk);

      Inc(o,$1a+1+length(exezk));
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;

    archiv_summe;
  end;

procedure msxie(const ver:byte);
  var
    o:longint;
  begin
    (* MSXIE140 *)
    ausschrift('XiE / Mercury Soft'+version_div10_mod10(ver),packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,80);
      if not bytesuche(form_puffer.d[0],'MS') then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      laenge_eingepackt:=longint_z(@form_puffer.d[$08])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$04])^;

      archiv_datei;

      exezk:=puffer_zu_zk_pstr(form_puffer.d[$0c]);
      archiv_datei_ausschrift(exezk);

      Inc(o,$0c+1+8+1+3);
      Inc(o,laenge_eingepackt);

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure nfvp(const p:puffertyp);
  begin
    archiv_start_leise;
    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=longint_z(@p.d[$05])^;
    archiv_datei64;
    if p.d[4]=1 then
      exezk:=' [-s]'
    else
     exezk:='';
    ausschrift('VOCPACK / Nicola Ferioli '+laenge_ausgepackt_zk+verhaeltnis_zk+'%'+exezk,packer_dat);
    archiv_summe_leise;
  end;

procedure uha2;
  var
    o:longint;
    _dl,_al,_ah:byte;
    _a,_b,_c,_d:
      record
        case integer of
          0:(l,h:byte);
          1:(x:word);
      end;

  begin
    o:=0;
    datei_lesen(form_puffer,analyseoff+o,$4+$28+1);
    _d.h:=form_puffer.d[4+$28];
    _d.l:=0;
    repeat
      _a.x:=sqr(word(_d.l));
      _b.x:=0;
      _b.l:=_d.l;
      Inc(_a.l,_d.h);
      _a.h:=form_puffer.d[_b.x+4];
      _a.h:=_a.h xor _a.l;
      Inc(_d.l);
      form_puffer.d[_b.x+4]:=_a.h;
    until _d.l>=$28;

    if form_puffer.d[$1b]<>0 then exit;

    ausschrift('UHARC / Uwe Herklotz [0.2]',packer_dat);
    (* signatur_anzeige('DUMP',form_puffer); *)

    archiv_start;
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    archiv_summe_eingepackt:=longint_z(@form_puffer.d[$14])^;
    archiv_summe_ausgepackt:=longint_z(@form_puffer.d[$10])^;
    archiv_summen_dateien  :=longint_z(@form_puffer.d[$0c])^;
    archiv_summe;

  end;

procedure cdf(const p:puffertyp);
  var
    o                   :longint;
    grenze              :longint;
  begin
    ausschrift(puffer_zu_zk_l(p.d[0],4)+' / Supernar Systems',packer_dat);
    if not langformat then exit;

    archiv_start;
    grenze:=word_z(@p.d[6])^;
    o:=8;
    (* Verzeichnisse .. *)
    while o<grenze do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        if form_puffer.d[0]=0 then break;
        laenge_eingepackt:=0;
        laenge_ausgepackt:=0;

        archiv_datei;

        exezk:=puffer_zu_zk_e(form_puffer.d[$0],#0,255);
        Inc(o,length(exezk)+1);
        archiv_datei_ausschrift_verzeichnis(exezk);
      end;

    o:=grenze;

    (* Dateien .. *)
    while o<einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_e(form_puffer.d[$0],#0,255);
        laenge_eingepackt:=longint_z(@form_puffer.d[length(exezk)+5])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[length(exezk)+1])^;
        archiv_datei;
        archiv_datei_ausschrift(exezk);

        Inc(o,length(exezk)+1+4+4+4+laenge_eingepackt);
        if p.d[3]=ord('1') then
          Inc(o,4);

      end;
    archiv_summe;
  end;

procedure mpc3;
  var
    o:longint;
  begin
    ausschrift('MPC / Marco Czudej [3.00] "PowerCompressor III"',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'MP3') then break;
      laenge_eingepackt:=longint_z(@form_puffer.d[$10])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$14])^;
      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$1a],form_puffer.d[$18]));
      Inc(o,$1a+form_puffer.d[$18]+laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure install_svga;
  var
    o:longint;
  begin
    ausschrift(textz_form__unbekanntes_Archiv^+' <ET6000> [PKWARE-LIB]',packer_dat);
    if not langformat then exit;

    o:=$3a;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_eingepackt:=longint_z(@form_puffer.d[$88])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$88])^;
      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,80));
      Inc(o,$a8+laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure rax;
  var
    o:longint;
  begin
    ausschrift('Romanian Archiver eXpert / GeCAD [1.02]',packer_dat);
    if not langformat then exit;

    o:=12;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_eingepackt:=longint_z(@form_puffer.d[$c])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$8])^;
      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$14],form_puffer.d[$2]));
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure hit;
  var
    o:longint;
  begin
    ausschrift('HIT / Bogdan Ureche [2.10]',packer_dat);
    if not langformat then exit;

    o:=7;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,100);
      laenge_eingepackt:=longint_z(@form_puffer.d[$0])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$4])^;
      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$13]));
      Inc(o,$13+1+form_puffer.d[$13]+laenge_eingepackt+5);
    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure dietdisk(const p:puffertyp);
  begin
    archiv_start_leise;
    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=longint_z(@p.d[6])^;
    archiv_datei64;
    ausschrift('Diet Disk / Barry Nance [1.0] '+laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);
    archiv_summe_leise;
  end;

procedure pak_dd;
  var
    o:longint;
  begin
    ausschrift('oPAQue / Dmitry Dvoinikov [1.0a]',packer_dat);
    if not langformat then exit;

    o:=$19;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,80);
      laenge_eingepackt:=longint_z(@form_puffer.d[$11])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$0d])^;
      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$0]));
      Inc(o,$20+laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure arh;
  var
    o:longint;
    verzeichnis:string;
    pos:word_norm;
  begin
    ausschrift('ARH / George Lyapko [1.30]',packer_dat);
    if not langformat then exit;

    o:=4;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_eingepackt:=longint_z(@form_puffer.d[$1])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$5])^;
      archiv_datei;

      pos:=$11;
      verzeichnis:=puffer_zu_zk_e(form_puffer.d[pos],#0,128);
      Inc(pos,length(verzeichnis)+1);
      exezk:=puffer_zu_zk_e(form_puffer.d[pos],#0,128);
      Inc(pos,length(exezk));
      archiv_datei_ausschrift(verzeichnis+exezk(*$IfNDef ENDVERSION*)+str_(form_puffer.d[0],4)(*$EndIf*));

      Inc(o,laenge_eingepackt+pos+1+2);

      (* Version 1.30 BMC -> 3 Byte (Nullen) zuviel *)
      if form_puffer.d[0]=$3 then
        Inc(o,3);
      (* ARHANGEL 1.34a *)
      if form_puffer.d[0]=$52 then
        Inc(o,3);

    until o+4>=einzel_laenge;
    archiv_summe;
  end;

procedure asd01(const p:puffertyp);
  var
    o                   :longint;
    anzahl,zaehler      :word_norm;
    posi                :word_norm;
  begin
    ausschrift('ASD / Tobias Svensson [0.1]',packer_dat);
    if not langformat then exit;

    archiv_start;
    anzahl:=word_z(@p.d[6])^;
    o:=8;
    for zaehler:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        posi:=form_puffer.d[0]+1;
        laenge_eingepackt:=-1;
        laenge_ausgepackt:=longint_z(@form_puffer.d[posi])^;
        Inc(posi,14);
        archiv_datei;
        archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]));
        Inc(o,posi);
      end;

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure nsk;
  var
    o:longint;
  begin
    ausschrift('NaShrink / NashSoft Systems [5.0, PKWARE LIB]',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_eingepackt:=longint_z(@form_puffer.d[$3])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$c])^;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$10]));

      Inc(o,laenge_eingepackt+$11+form_puffer.d[$10]);

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure psarc(const p:puffertyp);
  var
    anzahl,
    zaehler             :longint;
  begin
    ausschrift('PSARC / Peter Szymanski',packer_dat);
    if not langformat then exit;

    archiv_start;
    anzahl:=longint_z(@p.d[8])^;
    for zaehler:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+$10+(zaehler-1)*$30,$30*2);

        if zaehler=anzahl then
          laenge_eingepackt64:=einzel_laenge-longint_z(@form_puffer.d[$2c])^
        else
          laenge_eingepackt64:=longint_z(@form_puffer.d[$2c+$30])^-longint_z(@form_puffer.d[$2c])^;

        laenge_ausgepackt64:=longint_z(@form_puffer.d[$1c])^;
        archiv_datei64;

        archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]));
      end;
    archiv_summe;

  end;

procedure azt;
  var
    o                   :longint;
  begin
    ausschrift('AZT / ??? ¯',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$40);

      laenge_eingepackt:=longint_z(@form_puffer.d[$11])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$00])^;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$04],#0,8+1+3));

      Inc(o,laenge_eingepackt+$1a);

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure arch_lib;
  var
    o                   :dateigroessetyp;
    einzel_laenge_org   :dateigroessetyp;
    analyseoff_org      :dateigroessetyp;
    pos_modulenames,
    lae_modulenames,i,l :dateigroessetyp;
  begin
    ausschrift('AR-LIB ¯',compiler);
    if not langformat then Exit;

    pos_modulenames:=-1;
    einzel_laenge_org:=einzel_laenge;
    analyseoff_org   :=analyseoff;
    o:=8;

    archiv_start;
    repeat

      datei_lesen(form_puffer,analyseoff_org+o,512);

      if form_puffer.d[$00] in [$0a] then
        begin
          IncDGT(o,1);
          Continue;
        end;

      exezk:=puffer_zu_zk_l(form_puffer.d[$00],$10);
      while (exezk<>'') and (exezk[Length(exezk)]=' ') do
        DecLength(exezk);

      if (exezk='___.SYMDEF')
      or (exezk='/') or (exezk='\') then
        begin
          laenge_eingepackt64:=val_f(puffer_zu_zk_l(form_puffer.d[$30],9));
          laenge_ausgepackt64:=laenge_eingepackt; (* noch keine komprimierten gefunden! *)
          archiv_datei64;
          if (exezk='/') or (exezk='\') then
            exezk_anhaengen('  [___.SYMDEF]');
          archiv_datei_ausschrift(exezk);
          IncDGT(o,$3c);
          IncDGT(o,laenge_eingepackt64);
          Continue;
        end
      else
      if (exezk='ARFILENAMES/')
      or (exezk='//') or (exezk='\\') then
        begin
          laenge_eingepackt64:=val_f(puffer_zu_zk_l(form_puffer.d[$30],9));
          laenge_ausgepackt64:=laenge_eingepackt; (* noch keine komprimierten gefunden! *)
          archiv_datei64;
          if (exezk='//') or (exezk='\\') then
            exezk_anhaengen(' [ARFILENAMES/]');
          archiv_datei_ausschrift(exezk);
          IncDGT(o,$3c);
          pos_modulenames:=analyseoff_org+o;
          lae_modulenames:=laenge_eingepackt64;
          IncDGT(o,laenge_eingepackt64);
          Continue;
        end
      else
      if  (pos_modulenames<>-1)   and (Length(exezk)>=Length('/0'))
      and (exezk[1] in ['\','/',' ']) and (val_f(Copy(exezk,2,255))>=0) then
        begin
          Delete(exezk,1,1);
          if Pos(' ',exezk)<>0 then
            SetLength(exezk,Pos(' ',exezk)-1);
          i:=val_f(exezk);
          l:=lae_modulenames-i;
          if l<0 then
            l:=0
          else
          if l>255 then
            l:=255;
          exezk:=datei_lesen__zu_zk_e(pos_modulenames+i,#0,DGT_zu_longint(l));
          if Pos(#$a,exezk)<>0 then
            SetLength(exezk,Pos(#$a,exezk)-1);
        end
      else
      if ((Pos('/',exezk)<>0) or (Pos('\',exezk)<>0)) and (pos_modulenames=-1)
      and (not bytesuche__datei_lesen(o+$3c,#$7f'ELF')) then
        begin (* ncurses *)
          IncDGT(o,$3c);
          laenge_eingepackt64:=val_f(puffer_zu_zk_l(form_puffer.d[$30],9));
          laenge_ausgepackt64:=laenge_eingepackt; (* noch keine komprimierten gefunden! *)
          archiv_datei64;
          archiv_datei_ausschrift(exezk);
          ansi_anzeige(o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
              ,o+laenge_eingepackt64,'');
          IncDGT(o,laenge_eingepackt64);
          Continue;
        end;

      if form_puffer.d[$10] in [Ord(' ')] then
        begin
          IncDGT(o,1);
          Continue;
        end;



      laenge_eingepackt64:=val_f(puffer_zu_zk_l(form_puffer.d[$30],9));
      laenge_ausgepackt64:=laenge_eingepackt; (* noch keine komprimierten gefunden! *)
      archiv_datei64;
      archiv_datei_ausschrift(exezk);

      IncDGT(o,$3c);

      analyseoff:=analyseoff_org+o;
      einzel_laenge:=laenge_eingepackt64;

      datei_lesen(form_puffer,analyseoff_org+o,512);
      obj(form_puffer);

      IncDGT(o,laenge_eingepackt64);
    until o+$30>=einzel_laenge_org;
    archiv_summe;

    einzel_laenge:=einzel_laenge_org;
    analyseoff   :=analyseoff_org;

  end;

procedure wise_glb(const p:puffertyp;const o1:dateigroessetyp);
  var
    o,l,flags           :longint;
    w1                  :word_norm;
  begin
    ausschrift('InstallMaster / Wise Solutions',packer_dat);

    flags:=0;

    (* e_wise: init_text *)
    if (analyseoff=$3c80) or (analyseoff=$3bd0) or (analyseoff=$3c10) (* NE *)
    or (analyseoff=$3800) or (analyseoff=$3a00) (* PE *) then
      begin
        o:=1+p.d[0];
        datei_lesen(form_puffer,analyseoff+o,4);
        flags:=longint_z(@form_puffer.d[0])^;
        Inc(o,$5a);
        datei_lesen(form_puffer,analyseoff+o,1);
        Inc(o);
        l:=form_puffer.d[0];
        while l>0 do
          begin
            datei_lesen(form_puffer,analyseoff+o,512);
            exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
            ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
            Inc(o,Length(exezk)+1);
            Dec(l,Length(exezk)+1);
          end;

        if (flags and $100)=$100 then (* zip *)
          begin
            einzel_laenge:=o;
            Exit;
          end;
      end;

    (* 32PEX20A.ZIP:SETUP.EXE *)
    w1:=puffer_pos_suche(p,'PK'#$03#$04,120);
    if w1<>nicht_gefunden then
      begin
        einzel_laenge:=w1;
        Exit;
      end;

    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    {!!??!!}
  end;

procedure cfos; (* CFOS *)
  var
    o:longint;
  begin
    ausschrift('"FOO" / Martin Winkler, Chris Lueders',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],#$59#$56) then break;
      case word_z(@form_puffer.d[2])^ of
        $0201: (* Datei *)
          begin
            laenge_ausgepackt:=longint_z(@form_puffer.d[$10])^;
            laenge_eingepackt:=longint_z(@form_puffer.d[$14])^;
            archiv_datei;

            archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$20],#0,255));
            Inc(o,laenge_eingepackt);
          end;
        $0403: (* Dateiliste *)
          begin
          end;
        $0605: (* Anfang *)
          begin
            ausschrift(puffer_zu_zk_pstr(form_puffer.d[$10]),beschreibung);
          end;
        $0807: (* Dateiende *)
          begin
            Inc(o,4);
            break;
          end;
      else
           ausschrift('???',signatur);
      end;
      Inc(o,6+word_z(@form_puffer.d[4])^);
    until o>=einzel_laenge;
    archiv_summe;

    if o<einzel_laenge then
      einzel_laenge:=o;
  end;

procedure ldf(const p:puffertyp);
  begin
    ausschrift('LDF / Lintaro [1.03]',packer_dat);
    if not langformat then exit;

    (* nur "eine" Datei *)
    archiv_start;
    laenge_eingepackt:=longint_z(@p.d[$c])^;
    laenge_ausgepackt:=longint_z(@p.d[p.d[$16]+p.d[p.d[$16]+$22]+$27])^;
    archiv_datei;
    archiv_datei_ausschrift(puffer_zu_zk_pstr(p.d[$16])+' -> '+puffer_zu_zk_pstr(p.d[p.d[$16]+$22]));

    archiv_summe;

    einzel_laenge:=laenge_eingepackt+word_z(@p.d[$06])^;

  end;

procedure ldiff_210(const p:puffertyp);
  var
    name1,
    name2               :string;
  begin
    ausschrift('LDIFF / Kazuhiko MIKI [2.10]',packer_dat);
    if not langformat then exit;

    (* nur "eine" Datei *)
    archiv_start;
    name1:=puffer_zu_zk_e(p.d[$14],#0,255);
    name2:=puffer_zu_zk_e(p.d[$2e+length(name1)],#0,255);
    laenge_eingepackt:=longint_z(@p.d[$6])^;
    laenge_ausgepackt:=longint_z(@p.d[$1a+length(name1)])^;
    archiv_datei;
    archiv_datei_ausschrift(name2+' -> '+name1);

    archiv_summe;

  end;

procedure screenthief_install;
  var
    o                   :longint;
    verzeichnis         :string;
  begin
    verzeichnis:='';
    (* ausschrift('?? <SCREEN THIEF/NILDRAM>',packer_dat); *)
    ausschrift('THE FINISHING TOUCH / ImagiSOFT',packer_dat);
    if not langformat then Exit;

    o:=8;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      exezk:=puffer_zu_zk_pstr(form_puffer.d[$2]);
      if exezk[Length(exezk)]='\' then
        begin
          laenge_eingepackt:=0;
          laenge_ausgepackt:=0;
          archiv_datei;
          archiv_datei_ausschrift_verzeichnis(exezk);
          Inc(o,form_puffer.d[$2]+2);
          befehl_mkdir(exezk);
          Inc(o,laenge_eingepackt);
          verzeichnis:=exezk;
        end
      else
        begin
          Insert(verzeichnis,exezk,1);
          laenge_eingepackt:=longint_z(@form_puffer.d[form_puffer.d[2]+$11])^;
          laenge_ausgepackt:=longint_z(@form_puffer.d[form_puffer.d[2]+$03])^;
          archiv_datei;
          archiv_datei_ausschrift(exezk);
          Inc(o,form_puffer.d[$2]+$15);
          if laenge_eingepackt=laenge_ausgepackt then
            befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk)
          else
            befehl_ttdecomp(analyseoff+o,laenge_eingepackt,exezk);
          Inc(o,laenge_eingepackt);
        end;

    until o+2>=einzel_laenge;
    archiv_summe;

  end;

procedure qip(const p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('QIP / Quaterdeck [PKWARE-LIB]',packer_dat);
    if not langformat then exit;

    o:=longint_z(@p.d[$10])^;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'QD') then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      laenge_eingepackt:=longint_z(@form_puffer.d[$04])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$13])^;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$17],#0,8+1+3));

      Inc(o,laenge_eingepackt+$24);

    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure imp(const p:puffertyp);
  var
    zaehler             :word_norm;
    o,o_text            :dateigroessetyp;
    anzahl              :word_norm;
    laenge              :word_norm;
  begin
    ausschrift('IMP / Technelysium Pty Ltd',packer_dat);
    if not langformat then exit;

    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);

    o:=analyseoff+longint_z(@p.d[$14])^;
    datei_lesen(form_puffer,o,512);

    anzahl:=word_z(@form_puffer.d[4])^;
    IncDGT(o,6);
    o_text:=o+anzahl*2;
    for zaehler:=1 to anzahl do
      begin
        datei_lesen(form_puffer,o,2);
        laenge:=word_z(@form_puffer.d[0])^;

        datei_lesen(form_puffer,o_text,512);

        IncDGT(o_text,laenge);
        IncDGT(o,2);

        if laenge>255 then laenge:=255;
        ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,laenge),beschreibung);

      end;
  end;

procedure ark101(const o0:dateigroessetyp);
  var
    o:dateigroessetyp;
  begin
    ausschrift('ARK / Kris Heidenstrom [1.0.1]',packer_exe);
    if not langformat then exit;

    archiv_start;
    o:=o0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$20);

      if form_puffer.d[0]=0 then break;

      laenge_eingepackt:=word_z(@form_puffer.d[$0c])^;
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,8));

      IncDGT(o,longint(word_z(@form_puffer.d[$0e])^)*16);

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure stirling_isc(const p:puffertyp);
  var
    datei_info_start    :dateigroessetyp;
    anzahl,anzahl_dir,
    zaehler             :longint;
    o_dft,o0,o          :dateigroessetyp;

  function pfadname(const n:longint):string;
    var
      pfad_namen_puffer :puffertyp;
    begin
      datei_lesen(pfad_namen_puffer,o_dft+x_longint__datei_lesen(o_dft+(n)*4),256);
      if pfad_namen_puffer.d[0]=0 then
        pfadname:=''
      else
        pfadname:=puffer_zu_zk_e(pfad_namen_puffer.d[0],#0,255)+'\';
    end;

  begin
    (* Danke fÅr i6comp02.zip! *)

    exezk:='';
    if p.d[5]<>0 then
      exezk:=version_div16_mod16(p.d[5]);

    ausschrift('ISC / InstallShield Software Corporation'+exezk,packer_dat);
    if not langformat then exit;

    datei_info_start:=longint_z(@p.d[$c])^;

    if (datei_info_start<$200)
    or (datei_info_start>einzel_laenge) then
      Exit;

    if datei_info_start=longint_z(@p.d[$14])^ then (* Keine Dateinamen vorhanden *)
      begin
        archiv_start_leise;
        archiv_summe_eingepackt:=einzel_laenge;
        archiv_summe_ausgepackt:=0;
        archiv_summe_leise;
        Exit;
      end;

    archiv_start;

    datei_lesen(form_puffer,analyseoff+datei_info_start,$40);

    anzahl:=longint_z(@form_puffer.d[$28])^; (* "cFiles" *)
    anzahl_dir:=longint_z(@form_puffer.d[$1c])^; (* "cDirs" *)

    o_dft:=longint_z(@form_puffer.d[$0c])^; (* "ofsDFT" *)
    o0   :=longint_z(@form_puffer.d[$2c])^; (* "ofsFilesDFT" *)

    o_dft:=analyseoff+datei_info_start+o_dft;


    for zaehler:=1 to anzahl_dir do
      begin
        laenge_eingepackt:=0;
        laenge_ausgepackt:=0;
        archiv_datei;

        exezk:=pfadname(zaehler-1);
        archiv_datei_ausschrift_verzeichnis(exezk);
      end;


    for zaehler:=1 to anzahl do
      begin

        if p.d[5]<$60 then
          o:=x_longint__datei_lesen(o_dft+o0+(zaehler-1)*4)
        else
          o:=o0+(zaehler-1)*$57;

        datei_lesen(form_puffer,o_dft+o,$57);

        if p.d[5]<$60 then
          begin

            (* +1:split, +2:encrypted +4:compressed +8:invalid *)
            if (word_z(@form_puffer.d[8])^ and $08)<>0 then Continue;

            laenge_ausgepackt:=longint_z(@form_puffer.d[$a])^; (* 32 bit *)
            laenge_eingepackt:=longint_z(@form_puffer.d[$e])^; (* 32 bit *)
            archiv_datei;

            exezk:=
                   (*$IfNDef ENDVERSION*)
                   (* '('+hex_word(word_z(@form_puffer.d[0])^)+') '+ *)
                   (*$EndIf*)
                   pfadname(word_z(@form_puffer.d[$04])^)
                  +datei_lesen__zu_zk_e(o_dft+longint_z(@form_puffer.d[$00])^,#0,255);

            exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);

            if (word_z(@form_puffer.d[8])^ and $04)=0 then
              exezk_anhaengen(' [extern]');

            archiv_datei_ausschrift(exezk);

          end
        else
          begin
            if (word_z(@form_puffer.d[0])^ and $08)<>0 then Continue;

            (*$IfDef dateigroessetyp_comp*)
            laenge_ausgepackt64:=comp_z(@form_puffer.d[$2])^; (* 64 bit *)
            laenge_eingepackt64:=comp_z(@form_puffer.d[$a])^; (* 64 bit *)
            archiv_datei64;
            (*$Else*)
            laenge_ausgepackt:=longint_z(@form_puffer.d[$2])^; (* 64 bit *)
            laenge_eingepackt:=longint_z(@form_puffer.d[$a])^; (* 64 bit *)
            archiv_datei;
            (*$EndIf*)

            exezk:=
                   (*$IfNDef ENDVERSION*)
                   (* '('+hex_word(word_z(@form_puffer.d[0])^)+') '+ *)
                   (*$EndIf*)
                   pfadname(word_z(@form_puffer.d[$3e])^)
                  +datei_lesen__zu_zk_e(o_dft+longint_z(@form_puffer.d[$3a])^,#0,255);

            exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);

            if (word_z(@form_puffer.d[0])^ and $04)=0 then
              exezk_anhaengen(' [extern]');

            archiv_datei_ausschrift(exezk);

          end;



      end; (* FOR *)

    {

    if (datei_info_start<>512) or (longint_z(@p.d[$14])^<>512) then
      begin (* dateinamen vorhanden *)

        datei_lesen(form_puffer,datei_info_start,$40);
        Inc(datei_info_start,longint_z(@form_puffer.d[$c])^);


        (* wieviele EintrÑge? *)
        eintraege_min:=x_longint__datei_lesen(datei_info_start);
        anzahl:=0;
        while eintraege_min>anzahl*4 do
          begin
            Inc(anzahl);
            (* temp:=x_longint__datei_lesen(datei_info_start+anzahl*4); *)
            temp:=x_word__datei_lesen(datei_info_start+anzahl*4);
            if eintraege_min>temp then
              begin
                eintraege_min:=temp;
                (* start_dateinamen_bereich:=x_longint__datei_lesen(datei_info_start+temp); *)
                start_dateinamen_bereich:=x_word__datei_lesen(datei_info_start+temp);
              end;
          end;



        for zaehler:=1 to anzahl do
          begin
            (* temp:=x_longint__datei_lesen(datei_info_start+(zaehler-1)*4); *)
            temp:=x_word__datei_lesen(datei_info_start+(zaehler-1)*4);

            if temp>=start_dateinamen_bereich then
              begin (* VERZEICHNIS *)
                laenge_eingepackt:=0;
                laenge_ausgepackt:=0;
                archiv_datei;

                datei_lesen(datei_namen_puffer,datei_info_start+temp,512);

                exezk:=puffer_zu_zk_e(datei_namen_puffer.d[0],#0,255);
                exezk_leerzeichen_erweiterung_wie_letzte_zeile;<
                archiv_datei_ausschrift(exezk+textz_form__eckauf_Verzeichnis_eckzu^);
              end
            else
              begin (* DATEI *)
                datei_lesen(form_puffer,datei_info_start+temp,$50);

                case word_z(@form_puffer.d[8])^ of
                  $0, (* extern *)
                  $4, (* gepackt *)
                  $6: (* gepackt *)
                    begin
                      laenge_eingepackt:=longint_z(@form_puffer.d[$e])^;
                      laenge_ausgepackt:=longint_z(@form_puffer.d[$a])^;
                      archiv_datei;

                      datei_lesen(datei_namen_puffer,datei_info_start+longint_z(@form_puffer.d[$0])^,512);

                      archiv_datei_ausschrift(
                        (*$IfNDef ENDVERSION*)
                        (* '('+hex_word(word_z(@form_puffer.d[8])^)+') '+ *)
                        (*$EndIf*)
                        pfadname(word_z(@form_puffer.d[$4])^)
                       +puffer_zu_zk_e(datei_namen_puffer.d[0],#0,255));
                    end;
                  $8,
                  $c,
                  $e: (* pgp651d.exe:data1.hdr *)
                    begin
                      (* gelîscht? *)
                    end;
                else
                  ausschrift('? ('+str0(form_puffer.d[8])+')',packer_dat);
                end;

              end;

          end; (* FOR *)

      end; (* Dateinamen vorhanden *)}

    if p.d[5]<$60 then
      befehl_i5comp
    else
      befehl_i6comp;

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;

  end;


procedure gpfpack(const p:puffertyp);
  begin
    ausschrift('GPFPACK / Jean-Bernard CLERIN',packer_dat);
    if not langformat then exit;

    archiv_start;

    laenge_eingepackt:=-1;
    laenge_ausgepackt:=-1;
    archiv_datei;

    archiv_datei_ausschrift(puffer_zu_zk_e(p.d[$e],#0,255));

    archiv_summe;
  end;

procedure bix;
  var
    o:longint;
  begin
    (* 1.00 BETA 2 *)
    ausschrift('BIX / Igor Pavlov',packer_dat);
    if not langformat then exit;

    o:=$18;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_eingepackt:=longint_z(@form_puffer.d[$09])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$0d])^;

      if laenge_eingepackt>laenge_ausgepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$22],form_puffer.d[$1c]));

      Inc(o,laenge_eingepackt+form_puffer.d[$07]);
    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure quickfilecollection;
  var
    o:longint;
  begin
    ausschrift('QuickFileCollection / George G.Lyapko [2.02a]',packer_dat);
    if not langformat then exit;

    o:=3;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_eingepackt:=longint_z(@form_puffer.d[$01])^ and $ffffff;
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$9]));
      Inc(o,$9+1+form_puffer.d[$9]+laenge_eingepackt);

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure rpm(const p:puffertyp);
  var
    anzahl_eintraege    :longint;
    verzeichnisanfang   :dateigroessetyp;
    zaehler             :longint;
  begin
    ausschrift('RedHat '+textz_Programmpacket^+' [RPM '+str0(p.d[4])+'] '
        +puffer_zu_zk_e(p.d[10],#0,40),packer_dat);
    einzel_laenge:=$70
                  +m_longint(p.d[$70-4-4])*$10
                  +m_longint(p.d[$70-4  ]);
    einzel_laenge:=AndDGT(einzel_laenge+7,-8); (* bis $8eade801 *)

    verzeichnisanfang:=einzel_laenge;

    IncDGT(einzel_laenge,$10
                  +m_longint__datei_lesen(analyseoff+einzel_laenge+$8)*$10
                  +m_longint__datei_lesen(analyseoff+einzel_laenge+$c));

    if not langformat then exit;

    anzahl_eintraege:=m_longint__datei_lesen(analyseoff+verzeichnisanfang+$8);
    for zaehler:=1 to anzahl_eintraege do
      begin
        datei_lesen(form_puffer,analyseoff+verzeichnisanfang+(zaehler)*$10,$10);
        if m_longint(form_puffer.d[0])=1005 then
          ansi_anzeige(analyseoff+verzeichnisanfang+$10+(anzahl_eintraege)*$10+m_longint(form_puffer.d[8]),
            #0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
            absatz,wahr,not wahr,unendlich,'');
      end;
  end;

procedure lza_100_lzz(const p:puffertyp);
  begin
    ausschrift('LZA[.LZZ] / Dr Abimbola A Olowofoyeku [1.00]',packer_dat);
    archiv_start;

    laenge_eingepackt:=longint_z(@p.d[$f])^+$100+1;
    laenge_ausgepackt:=longint_z(@p.d[$b])^;
    archiv_datei;

    archiv_datei_ausschrift(puffer_zu_zk_pstr(p.d[$28]));

    einzel_laenge:=laenge_eingepackt;

    archiv_summe;
  end;

procedure lza_100_lza(const p:puffertyp);
  var
    anzahl_dateien,
    zaehler1,
    zaehler2,
    namen_laenge        :word_norm;
    o_name              :dateigroessetyp;
  begin
    ausschrift('LZA / Dr Abimbola A Olowofoyeku [1.00]',packer_dat);
    if not langformat then exit;

    anzahl_dateien:=word_z(@p.d[$17])^;
    archiv_start;

    o_name:=analyseoff+anzahl_dateien*41+126;
    for zaehler1:=1 to anzahl_dateien do
      begin
        datei_lesen(form_puffer,analyseoff+(zaehler1-1)*41,512);
        (* 294=$126 156=$9c *)
        laenge_eingepackt:=longint_z(@form_puffer.d[$8d])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[$91])^;
        archiv_datei;

        namen_laenge:=form_puffer.d[$a1];

        datei_lesen(form_puffer,o_name,namen_laenge);
        for zaehler2:=1 to namen_laenge do
          Dec(form_puffer.d[zaehler2-1],zaehler2+3);
        IncDGT(o_name,namen_laenge);

        archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[0],namen_laenge));
      end;

    archiv_summe;
  end;

procedure szip(const p:puffertyp);
  begin
    ausschrift('SZIP / Michael Schindler'+version100(p.d[4]*100+p.d[5]),packer_dat);
    if not langformat then exit;

    archiv_start;

    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=m_longint(p.d[8-1]) and $ffffff;
    archiv_datei64;
    archiv_datei_ausschrift('?');

    archiv_summe;
  end;

procedure blink_dts(const p:puffertyp);
  var
    o:longint;
    f2_puffer:puffertyp;
    version:(ver250_alt,ver250_neu,ver251);
    name:string;
    zwischensumme:longint;
  const
    kopf_laenge=$19;
  begin
    case word_z(@p.d[$10])^ of
      0..249:
        version:=ver250_alt;
      250:
        if p.d[$19]<>0 then
          version:=ver250_alt
        else
          version:=ver250_neu;
    else
        version:=ver251;
    end;

    ausschrift('Blink / D.T.S.'+version100(word_z(@p.d[$10])^),packer_dat);
    if not langformat then exit;

    o:=$12;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      case version of
        ver250_alt:
          laenge_ausgepackt:=longint_z(@form_puffer.d[$00])^;

        ver250_neu:
          laenge_ausgepackt:=longint_z(@form_puffer.d[$04])^;

        ver251:
          laenge_ausgepackt:=longint_z(@form_puffer.d[$0e])^;
      end;

      laenge_eingepackt:=word_z(@form_puffer.d[$17])^;
      zwischensumme:=0; {!!}

      (* naechster block *)
      if {laenge_eingepackt<laenge_ausgepackt} laenge_ausgepackt>$ff78 then
        repeat
          fillchar(f2_puffer,sizeof(f2_puffer),$ee);
          datei_lesen(f2_puffer,analyseoff+o+kopf_laenge+zwischensumme+laenge_eingepackt,3);
          if not (f2_puffer.d[0] in [0,1]) then
            break;
          if f2_puffer.g<>3 then
            begin
              (* ausschrift('break<*3',signatur); *)
              break;
            end;
          Inc(laenge_eingepackt,word_z(@f2_puffer.d[1])^);
          Inc(zwischensumme,3);
          (* ausschrift(str(f2_puffer.d[0],1)+':  +'+hex_word(word_z(@f2_puffer.d[1])^),signatur); *)
        until (word_z(@f2_puffer.d[1])^=0) or (laenge_eingepackt>=laenge_ausgepackt);
        Inc(laenge_eingepackt,zwischensumme);

      archiv_datei;

      if version=ver251 then
        name:=+puffer_zu_zk_e(form_puffer.d[$00],#0,255)
      else
        name:=+puffer_zu_zk_e(form_puffer.d[$08],#0,255);

      archiv_datei_ausschrift(name);

      Inc(o,kopf_laenge+laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure par147(const p:puffertyp);
  begin
    ausschrift('PAR / Philipp Druyts ['+puffer_zu_zk_l(p.d[$1c],4)+'] <BZIP2>',packer_dat);
    if not langformat then exit;

    archiv_start;
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    archiv_summe_eingepackt:=longint_z(@p.d[$10])^;
    archiv_summe_ausgepackt:=longint_z(@p.d[$0c])^;
    archiv_summen_dateien  :=longint_z(@p.d[$14])^;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe_ausgepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure par148(const p:puffertyp);
  begin

    ausschrift('PAR / Philipp Druyts ['+puffer_zu_zk_l(p.d[$18],4)+'] <BZIP2>',packer_dat);
    if not langformat then exit;

    archiv_start;
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    archiv_summe_eingepackt:=longint_z(@p.d[$0c])^;
    archiv_summe_ausgepackt:=longint_z(@p.d[$08])^;
    archiv_summen_dateien  :=longint_z(@p.d[$10])^;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe_ausgepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure sbx;
  var
    o:longint;
  begin
    (* VERSION 1.4 *)
    ausschrift('SBX / SpinnerBaker',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_eingepackt:=longint_z(@form_puffer.d[$04])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$0e+form_puffer.d[$0d]])^;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$0d]));

      Inc(o,laenge_eingepackt);

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure pocket_arch(const p:puffertyp);
  var
    o:longint;
  begin
    if (word_z(@p.d[2])^>500) (* 1.00 mit RTPATCH DEMO 5 *)
    or (not ist_ohne_steuerzeichen(puffer_zu_zk_pstr(p.d[4])))
    or (p.d[4]<4)
    or (p.d[4]>150)
     then
      exit;

    ausschrift('ARCH / Pocket Soft'+version100(word_z(@p.d[2])^),packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=4;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if form_puffer.d[$00]=0 then break;

      laenge_ausgepackt:=longint_z(@form_puffer.d[form_puffer.d[$00]+$07])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[form_puffer.d[$00]+$0b])^;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$00]));

      Inc(o,form_puffer.d[$00]+15+laenge_eingepackt);

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure compress_ii204(const p:puffertyp;const i0:word_norm);
  begin
    (* II204 *)
    ausschrift('Compress / Rick Pedley [2.00]',packer_dat);
    if not langformat then exit;

    archiv_start;

    laenge_ausgepackt64:=val_f(puffer_zu_zk_e(p.d[i0+$20],'x',9));
    laenge_eingepackt64:=einzel_laenge;
    archiv_datei64;

    archiv_datei_ausschrift(puffer_zu_zk_e(p.d[i0+6],' ',8+1+3));

    archiv_summe;
  end;

procedure pw2_install;
  var
    o                   :longint;
    anzahl_dateien      :longint;
  begin
    (* die Anzeige von java-Archiven klappt noch nicht, weil die LÑnge unbekannt ist *)
    (* PW2-Dateien haben eine leicht verÑnderte Dateiliste *)
    ausschrift('PackageWizard / Marco Maccaferri Software Development',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=4; (* Versionsummer? *)

    (* Titel *)
    datei_lesen(form_puffer,analyseoff+o,512);
    ausschrift(puffer_zu_zk_e(form_puffer.d[4],#0,255),beschreibung);
    Inc(o,longint_z(@form_puffer.d[0])^+5);

    (* Version *)
    datei_lesen(form_puffer,analyseoff+o,512);
    ausschrift(puffer_zu_zk_e(form_puffer.d[4],#0,255),beschreibung);
    Inc(o,longint_z(@form_puffer.d[0])^+5);

    (* Hersteller *)
    datei_lesen(form_puffer,analyseoff+o,512);
    ausschrift(puffer_zu_zk_e(form_puffer.d[4],#0,255),beschreibung);
    Inc(o,longint_z(@form_puffer.d[0])^+5);

    (* Copyright *)
    datei_lesen(form_puffer,analyseoff+o,512);
    ausschrift(puffer_zu_zk_e(form_puffer.d[4],#0,255),beschreibung);
    Inc(o,longint_z(@form_puffer.d[0])^+5);

    (* Liesmich-Datei*)
    datei_lesen(form_puffer,analyseoff+o,4);
    Inc(o,4);
    if form_puffer.d[0]=1 then
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        ausschrift((*'README='+*)puffer_zu_zk_e(form_puffer.d[4],#0,255),beschreibung);
        Inc(o,longint_z(@form_puffer.d[0])^+5);
      end
    else
      Inc(o,5);

    (* Lizenzdatei *)
    datei_lesen(form_puffer,analyseoff+o,4);
    Inc(o,4);
    if form_puffer.d[0]=1 then
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        ausschrift((*'::LIZEN='+*)puffer_zu_zk_e(form_puffer.d[4],#0,255),beschreibung);
        Inc(o,longint_z(@form_puffer.d[0])^+5);
      end
    else
      Inc(o,5);

    (* Zielverzeichnisvorschlag *)
    datei_lesen(form_puffer,analyseoff+o,512);
    ausschrift((*'::Verzeichnis='+*)puffer_zu_zk_e(form_puffer.d[4],#0,255),beschreibung);
    Inc(o,longint_z(@form_puffer.d[0])^+5);

    datei_lesen(form_puffer,analyseoff+o,4);
    anzahl_dateien:=longint_z(@form_puffer.d[0])^;
    (*anzahl_dateien:=99;*)
    Inc(o,4);

    while anzahl_dateien>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        Dec(anzahl_dateien);
        case form_puffer.d[0] of
          0: (* Verzeichnis *)
            begin
              laenge_ausgepackt:=0;
              laenge_eingepackt:=0;
              archiv_datei;

              archiv_datei_ausschrift_verzeichnis(puffer_zu_zk_e(form_puffer.d[8],#0,255));
              Inc(o,longint_z(@form_puffer.d[4])^+5+4);
            end;
          1: (* Datei *)
            begin
              laenge_ausgepackt:=-1;
              laenge_eingepackt:=-1;
              archiv_datei;

              archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[8],#0,255));
              Inc(o,longint_z(@form_puffer.d[4])^+5+8);
              (* 4 zusÑtzliche Byte (Åberscheiben/nicht Åberschreiben/.. *)
            end;

        else
          ausschrift('?  '+str0(form_puffer.d[0]),dat_fehler);
          Break;
        end;

      end;

    (* anzulegende Objekte auf der ArbeitsoberflÑche werden nicht angezeigt *)
    archiv_summe;

  end;

procedure ati_exe_archiv(const p:puffertyp);
  var
    o,kopf_laenge       :dateigroessetyp;
    uebrig              :word_norm;
    p2                  :puffertyp;
  begin
    (* 64vbe210.exe / ATI *)
    (* dw20_95.exe *)
    (*ausschrift('?? / ATI [PKWARE-LIB]',packer_dat);*)
    (* PC-INSTALL *)
    ausschrift('INSTALL-PC? / ? [PKWARE-LIB]',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=-$10;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if longint_z(@form_puffer.d[0])^=0 then
        laenge_eingepackt64:=einzel_laenge-$10-o
      else
        laenge_eingepackt64:=longint_z(@form_puffer.d[0])^-(analyseoff+o);

      datei_lesen(p2,analyseoff+o+$14e,512);
      if (einzel_laenge>$14e+$a8) and bytesuche(p2.d[$a8-2],#$00#$00#$00#$06) then
        begin
          ausschrift(puffer_zu_zk_e(form_puffer.d[$14],#0,8+1+3),beschreibung);
          uebrig:=word_z(@form_puffer.d[$124])^;
          IncDGT(o,$14e);
          while uebrig>0 do
            begin
              datei_lesen(p2,analyseoff+o,512);

              laenge_ausgepackt64:=longint_z(@p2.d[$9c])^;
              if laenge_ausgepackt64<=0 then
                laenge_ausgepackt64:=-1;
              laenge_eingepackt64:=longint_z(@p2.d[$88])^;
              kopf_laenge:=$a8;
              archiv_datei64;

              archiv_datei_ausschrift(puffer_zu_zk_e(p2.d[0],#0,$88));

              IncDGT(o,kopf_laenge+laenge_eingepackt64);
              Dec(uebrig);
            end;
        end
      else
        begin
          exezk:=puffer_zu_zk_e(form_puffer.d[$14],#0,8+1+3);
          kopf_laenge:=$114;
          DecDGT(laenge_eingepackt64,kopf_laenge);
          laenge_ausgepackt64:=laenge_eingepackt;
          archiv_datei64;
          archiv_datei_ausschrift(exezk);
          IncDGT(o,kopf_laenge+laenge_eingepackt64);
        end;

    until (o+$10>=einzel_laenge) or (o<0);

    archiv_summe;

  end;

procedure sextwiz;
  var
    o:longint;
  begin
    (* entpackt saxsetup *)
    ausschrift('Self-Extracting EXE Creator / ? ¯',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=$11;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      (* "->" *)
      if form_puffer.d[form_puffer.d[0]+5]=ord('>') then
        begin (* Datei *)
          laenge_eingepackt:=longint_z(@form_puffer.d[form_puffer.d[0]+6])^;
          laenge_ausgepackt:=laenge_eingepackt;
          archiv_datei;

          archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[4],form_puffer.d[0]));

          Inc(o,laenge_eingepackt+form_puffer.d[0]+14);
        end
      else if form_puffer.d[form_puffer.d[0]+5]=0 then
        begin (* Hauptprogramm *)
          ausschrift(puffer_zu_zk_l(form_puffer.d[4],form_puffer.d[0]),beschreibung);
          Inc(o,form_puffer.d[0]+9);
        end;

    until o>=einzel_laenge;

    archiv_summe;

  end;

procedure saxsetup(const anfang,ende:dateigroessetyp);
  var
    zk4                 :array[0..3] of char absolute anfang;
    ziel                :string;
    o                   :dateigroessetyp;
    w1                  :word_norm;

  procedure lies_zk0(var zk:string);
    begin
      zk:=datei_lesen__zu_zk_e(o,#0,255);
      IncDGT(o,Length(zk)+1);
    end;

  begin
    (* "Sax Setup DLL -- Copyright (c) 1996, Sax Software Corporation" *)
    ausschrift('Sax Setup / Sax Software Corporation',packer_dat);
    if not langformat then exit;


    o:=anfang;

    (* Beschreibung *)
    lies_zk0(exezk);
    if exezk<>'' then
      ausschrift(exezk,beschreibung);

    (* Zielverzeichnis *)
    lies_zk0(exezk);
    if exezk<>'' then
      ausschrift(exezk,beschreibung);

    (* uninstall.exe? *)
    datei_lesen(form_puffer,o,512);
    w1:=puffer_pos_suche(form_puffer,zk4[0]+zk4[1]+zk4[2]+zk4[3]+'?'#$00,512);
    if w1=nicht_gefunden then Exit;

    IncDGT(o,w1+4+4);
    archiv_start;
    while o<ende do
      begin
        datei_lesen(form_puffer,o,512);
        IncDGT(o,2);
        if form_puffer.d[1]<>0 then Break;

        case form_puffer.d[0] of
          $02: (* Verzeichnis *)
            begin
              lies_zk0(exezk);
              lies_zk0(ziel);
              ausschrift(exezk,packer_dat);
            end;

          $03: (* Datei *)
            begin
              lies_zk0(exezk);
              lies_zk0(ziel);
              if ziel<>'' then exezk:=ziel+'\'+exezk;
              datei_lesen(form_puffer,o,$25);
              IncDGT(o,$25);
              laenge_eingepackt:=-1;
              laenge_ausgepackt:=longint_z(@form_puffer.d[$1d])^;
              archiv_datei;

              archiv_datei_ausschrift(exezk(*+strx(longint_z(@form_puffer.d[$21])^,11)*));
            end;

          $0d: (* Anmelden an OberflÑche? *)
            begin
              lies_zk0(exezk);
              lies_zk0(ziel);
              ausschrift(exezk+' '+ziel,beschreibung);
              for w1:=1 to 5 do
                lies_zk0(exezk);
            end;

          $11: (* Zeilverzeichnis? *)
            begin
              lies_zk0(exezk);
              lies_zk0(ziel);
              ausschrift(exezk+' '+ziel,beschreibung);
            end;

          $12: (* binÑr *)
            IncDGT(o,6);

          $14: (* Gruppe *)
            begin
              lies_zk0(exezk);
              lies_zk0(ziel);
              ausschrift(exezk+' '+ziel,beschreibung);
            end;

          $15: (* Stop *)
            Break;

        else
          ausschrift('?',signatur);
          Break;
        end;
      end;

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;

  end;

procedure saxsetup_6(const anfang,ende:dateigroessetyp);
  var
    o:dateigroessetyp;
    zp:puffertyp;
  begin
    ausschrift('Sax Setup / Sax Software Corporation [6.0]',packer_dat);
    if not langformat then exit;

    o:=anfang;
    archiv_start;
    repeat

      datei_lesen(zp,o,2*4);
      IncDGT(o,2*4);
      if longint_z(@zp.d[0])^=0 then Continue;
      datei_lesen(form_puffer,longint_z(@zp.d[0])^,512);

      if bytesuche(form_puffer.d[0],#$a6#$d6#$b2#$10) then
        exezk:=textz_form__packed_data^
      else if bytesuche(form_puffer.d[0],#$78#$56#$34#$12) then
        exezk:=textz_form__setup_info^
      else if bytesuche(form_puffer.d[0],'TXT1') then
        exezk:=textz_form__setup_strings^
      else
        exezk:='? ¯';

      exezk_leerzeichen_erweiterung(30);

      exezk_anhaengen(' [');
      exezk_anhaengen(str11_oder_hex(longint_z(@zp.d[0])^));
      exezk_anhaengen(']');

      laenge_eingepackt:=longint_z(@zp.d[4])^;
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;

      archiv_datei_ausschrift(exezk);

    until o>=ende;
    archiv_summe;
  end;

procedure akt_06(const p:puffertyp);
  var
    o                   :longint;
    zaehler,
    anzahl              :word_norm;
    pfad                :string;
    w1                  :word_norm;
  begin
    case p.d[3] of
      6:
        begin
          exezk:='0.58';
          o:=$c;
        end;
      7:
        begin
          exezk:='0.5c';
          o:=$d;
        end;
      8:
        begin
          exezk:='0.5db2';
          o:=$9;
        end;
      9:
        begin
          exezk:='0.70b3';
          o:=p.d[4];
        end;
      $a:
        begin
          exezk:='0.70b7';
          o:=p.d[4];
        end;
    else
        exezk:='?.? ¯';
        o:=p.d[4];
    end;
    ausschrift('AKT / TRT/Agyhal†l ['+exezk+']',packer_dat);
    if not langformat then exit;

    archiv_start;

    (* Kommentar vorhanden? *)
    if word_z(@p.d[6])^<>0 then
      ansi_anzeige(analyseoff+$c,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
              ,analyseoff+$c+word_z(@p.d[6])^,'');

    Inc(o,word_z(@p.d[6])^);

    pfad:='';

    if p.d[3]<8 then
      begin
        anzahl:=word_z(@p.d[4])^;

        for zaehler:=1 to anzahl do
          begin
            datei_lesen(form_puffer,analyseoff+o,512);
            if not bytesuche(form_puffer.d[0],#$01#$01) then
              pfad:=puffer_zu_zk_pstr(form_puffer.d[0]);

            laenge_eingepackt:=-1;
            laenge_ausgepackt:=longint_z(@form_puffer.d[form_puffer.d[0]+$13+4])^
                              -longint_z(@form_puffer.d[form_puffer.d[0]+$13+0])^;

            archiv_datei;

            archiv_datei_ausschrift(pfad+puffer_zu_zk_e(form_puffer.d[form_puffer.d[0]+1],#0,12));

            Inc(o,form_puffer.d[0]+$1b);

          end;

        archiv_summe_eingepackt:=einzel_laenge;
        archiv_summe_eingepackt_unbekannt:=falsch;
      end
    else if p.d[3]=8 then
      repeat
        datei_lesen(form_puffer,analyseoff+o,512);
        laenge_eingepackt:=longint_z(@form_puffer.d[13+0])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[13+4])^;
        archiv_datei;

        archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]));


        Inc(o,laenge_eingepackt+8+1+3+4+4+12);
      until o>=einzel_laenge
    else (* 9 *)
      repeat
        datei_lesen(form_puffer,analyseoff+o,512);
        pfad:=puffer_zu_zk_pstr(form_puffer.d[0]);
        w1:=1+form_puffer.d[0];

        laenge_eingepackt:=longint_z(@form_puffer.d[w1+12])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[w1+16])^;
        archiv_datei;

        exezk:=puffer_zu_zk_e(form_puffer.d[w1],#0,12);
        archiv_datei_ausschrift(pfad+exezk);


        Inc(o,w1+12+4+4+4+4+1+1+1+laenge_eingepackt);

        (* steht nicht in der Doku! *)
        Inc(o,2);
        if form_puffer.d[w1+$1d]<>2 then (* history.txt *)
          Inc(o,form_puffer.d[w1+$1f]);

        (*ausschrift(str0(form_puffer.d[w1+$1d])+' '
                  +str0(form_puffer.d[w1+$1f]),signatur);*)
      until o>=einzel_laenge;


    archiv_summe;

  end;

procedure stardock_sf_archiv;
  var
    o:longint;
  begin
    (* STELLAR FRONTIER 0.947 BETA SF947O/W.EXE *)
    ausschrift(textz_form__unbekanntes_Archiv^+' <Stellar Frontier/Stardock>',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=$c;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_eingepackt:=longint_z(@form_puffer.d[$0c])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$10])^;
      archiv_datei;

      exezk:=puffer_zu_zk_l(form_puffer.d[$14],form_puffer.d[$04]);
      archiv_datei_ausschrift(exezk);

      Inc(o,form_puffer.d[$04]+$14);
      befehl_e_infla(analyseoff+o+2,laenge_eingepackt-2,exezk);
      Inc(o,laenge_eingepackt);

    until (o=einzel_laenge) or (o+4=einzel_laenge);
    archiv_summe;

  end;

procedure zap_zip_archiv(const ende:dateigroessetyp;const verzeichnislaenge:word_norm;
                         const pfade_abgespeichert:boolean;const version:byte);
  var
    o                   :dateigroessetyp;
    verzeichnis         :string;
  begin
    ausschrift('ZIP-Archiv / Peter Troxler'+version100((version shr 4)*100+(version mod 8)),packer_dat);
    if not langformat then exit;

    verzeichnis:='';

    archiv_start;
    o:=ende-verzeichnislaenge;
    while o<ende do
      begin
        if pfade_abgespeichert then
          begin
            datei_lesen(form_puffer,o,257);
            verzeichnis[0]:=chr(form_puffer.d[0]);
            verzeichnis:=verzeichnis+puffer_zu_zk_pstr(form_puffer.d[1]);
            IncDGT(o,form_puffer.d[1]+2);
          end;

        datei_lesen(form_puffer,o,256);
        form_puffer.d[0]:=form_puffer.d[0] and $0f;
        exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
        IncDGT(o,form_puffer.d[0]+1);
        laenge_eingepackt:=x_longint__datei_lesen(o);
        laenge_ausgepackt:=-1;
        IncDGT(o,4);
        archiv_datei;
        archiv_datei_ausschrift(verzeichnis+exezk);
      end;
    archiv_summe;

  end;

procedure graham_archiv(const p:puffertyp);
  var
    o                   :longint;
    ea_anzahl           :word_norm;
    ea_name             :string;
  begin
    ausschrift('Graham Utilities CSD / Chris Graham',packer_dat);
    if not langformat then exit;

    archiv_start;
    (* CSD *)
    ausschrift(puffer_zu_zk_e(p.d[$00e],#0,$10),beschreibung);
    (* Datum *)
    ausschrift(puffer_zu_zk_e(p.d[$01e],#0,$80),beschreibung);
    (* Titel *)
    ausschrift(puffer_zu_zk_e(p.d[$09e],#0,$80),beschreibung);
    (* zu Startendes Programm *)
    ausschrift(puffer_zu_zk_e(p.d[$11e],#0,$14),beschreibung);
    (* Textdatei *)
    ausschrift(puffer_zu_zk_e(p.d[$132],#0,$14),beschreibung);


    o:=$146;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$11c);

      laenge_eingepackt:=longint_z(@form_puffer.d[$110])^;
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;

      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
      archiv_datei_ausschrift(exezk);

      Inc(o,laenge_eingepackt+$11c);

      ea_anzahl:=form_puffer.d[$11a];
      while ea_anzahl>0 do(* EA? *)
        begin
          (* EA Name *)
          Inc(o);
          datei_lesen(form_puffer,analyseoff+o,$100);
          ea_name:=exezk+puffer_zu_zk_pstr(form_puffer.d[0])+' [EA]';
          Inc(o,$105);
          (* LÑnge *)
          laenge_eingepackt:=x_word__datei_lesen(o);
          laenge_ausgepackt:=laenge_eingepackt;
          archiv_datei;
          archiv_datei_ausschrift(ea_name);
          Inc(o,2+laenge_eingepackt);
          Dec(ea_anzahl);
        end;

    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure semone(const p:puffertyp);
  begin
    ausschrift('SEMONE / V. Semenjuk',packer_dat); (* 0.4 *)
    if not langformat then exit;

    archiv_start;

    laenge_eingepackt:=longint_z(@p.d[$12])^;
    laenge_ausgepackt:=longint_z(@p.d[$16])^;
    archiv_datei;

    archiv_datei_ausschrift(puffer_zu_zk_e(p.d[$1f],' ',8+1+3));
    archiv_summe;
  end;

procedure bdsap(const p:puffertyp;name_id:word_norm);
  var
    o:longint;
  begin
    if not bytesuche(p.d[0],'VK*ARAP'#$1a) then exit;

    if name_id=1 then
      ausschrift('BDSAP / Veit Kannegieser',packer_dat);

    if not langformat then exit;

    if name_id=1 then
      archiv_start;

    exezk:=puffer_zu_zk_pstr(p.d[40]);
    if exezk<>'' then
      if exezk[Length(exezk)]=#0 then
        Dec(exezk[0]);

    laenge_eingepackt:=longint_z(@p.d[24])^;
    laenge_ausgepackt:=longint_z(@p.d[28])^;

    case p.d[12] of
      0:
        begin
          archiv_summe;
        end;

      1: (* Datei *)
        begin
          archiv_datei;
          archiv_datei_ausschrift(exezk);
        end;
      2: (* Verzeichnis *)
        begin
          archiv_datei;
          archiv_datei_ausschrift_verzeichnis(exezk);
        end;
    end;

  end;

procedure gather_2;
  var
    zaehler,
    zaehler2,
    anzahl              :word_norm;
    verzeichnisnummer   :word_norm;
    daten_off           :longint;
  begin
    ausschrift('Gather / Bruno Olsen [1.2]',packer_dat);
    if not langformat then exit;

    archiv_start;
    datei_lesen(form_puffer,analyseoff,26);
    anzahl:=word_z(@form_puffer.d[18])^ (* Dateien       *)
           +word_z(@form_puffer.d[20])^;(* Verzeichnisse *)
    daten_off:=+longint_z(@form_puffer.d[22])^;

    for zaehler:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+zaehler*26,26);
        laenge_eingepackt:=longint_z(@form_puffer.d[22])^;
        if form_puffer.d[17]=0 then
          begin
            Dec(laenge_eingepackt,daten_off);
            daten_off:=+longint_z(@form_puffer.d[22])^; (* fÅr nÑchstes mal *)
          end;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;

        exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);

        if form_puffer.d[17]=1 then (* Verzeichnis *)
          begin
            leerzeichenerweiterung(exezk,20); (* ? *)
            archiv_datei_ausschrift_verzeichnis(exezk);
          end
        else (* Datei *)
          begin
            verzeichnisnummer:=word_z(@form_puffer.d[18])^;
            if verzeichnisnummer>=1 then
              begin
                for zaehler2:=1 to anzahl do
                  begin
                    datei_lesen(form_puffer,analyseoff+zaehler2*26,26);
                    if  (verzeichnisnummer=word_z(@form_puffer.d[18])^)
                    and (form_puffer.d[17]=1)
                     then
                      begin
                        exezk:=puffer_zu_zk_pstr(form_puffer.d[0])+'\'+exezk;
                      end;
                  end;
              end;
            archiv_datei_ausschrift(exezk);
          end;

      end;

    archiv_summe;

  end;

procedure rid;
  var
    o                   :longint;
    blockgroesse        :word_norm;
  begin
    (* PM2YOU23/24 *)
    ausschrift('RID / Ridax programutveckling',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_ausgepackt:=longint_z(@form_puffer.d[$1a])^;
      laenge_eingepackt:=0;
      exezk:=puffer_zu_zk_e(form_puffer.d[$1e],#0,8+1+3);

      Inc(o,$2b);
      repeat
        datei_lesen(form_puffer,analyseoff+o,3);
        blockgroesse:=3+word_z(@form_puffer.d[0])^;
        Inc(o,blockgroesse);
        Inc(laenge_eingepackt,blockgroesse);
      until form_puffer.d[2]=$ff;

      archiv_datei;

      archiv_datei_ausschrift(exezk);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure pm2you24_zap;
  var
    o:longint;
  begin
    (* PM2YOU24.ZIP\WINTERM.ZAP *)
    ausschrift('ZAP / Ridax programutveckling',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,80);
      laenge_ausgepackt:=-1;
      laenge_eingepackt:=longint_z(@form_puffer.d[$11])^;
      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]));
      Inc(o,laenge_eingepackt+$15);
    until o>=einzel_laenge;
    archiv_summe;
  end;


procedure rtd_dat;
  var
    anzahl,
    z                   :word_norm;
    o                   :longint;

  begin
    ausschrift('RTD DAT / MR WiCKED',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=0;
    anzahl:=x_word__datei_lesen(analyseoff+o);
    Inc(o,2);
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,17*2);
        Inc(o,17);
        (*$IfDef VirtualPascal*)
        asm
          pushad

            mov esi,offset form_puffer.d
            mov edi,esi
            mov ecx,17*2
            cld
          @schleife:
            lodsb
            rol al,1
            xor al,$2a
            stosb
            loop @schleife

          popad
        end;
        (*$EndIf*)
        (*$IfDef DOS*)
        asm
          pusha
            push ds

              mov si,offset form_puffer.d
              mov di,si
              push seg form_puffer (* DSEG *)
              pop ds
              push ds
              pop es

              mov cx,17*2
              cld
            @schleife:
              lodsb
              rol al,1
              xor al,$2a
              stosb
              loop @schleife

            pop ds
          popa
        end;
        (*$EndIf*)
        (*$IfDef DUMM*)
        for z:=0 to (17*2)-1 do
          begin
            ..
          end;
        (*$EndIf*)

        laenge_ausgepackt64:=-1;
        if anzahl=1 then (* letzte Datei *)
          laenge_eingepackt64:=einzel_laenge-longint_z(@form_puffer.d[12+1])^
        else
          laenge_eingepackt64:=longint_z(@form_puffer.d[17+12+1])^-longint_z(@form_puffer.d[12+1])^;
        archiv_datei64;

        archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]));
        Dec(anzahl);
      end;

    archiv_summe;
  end;

procedure timesink_install(const typ:string); (* 3,4 *)
  var
    o                   :longint;
    datenposition       :longint;
    z                   :word_norm;
    version             :byte;
    anzahl              :longint;
  begin
    (* PK2602AD.EXE               (3) *)
    (* TSINST.EXE in PK270WSP.EXE (4) *)
    ausschrift('?? TimeSink Install / TimeSink Communications '(*+str0(version)*)+typ,packer_dat);

    if not langformat then exit;

    archiv_start;
    anzahl:=x_longint__datei_lesen(analyseoff);
    o:=4;
    datei_lesen(form_puffer,analyseoff+o,512);
    exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
    ausschrift(exezk,beschreibung);
    Inc(o,Length(exezk)+1);
    Inc(o,4+x_longint__datei_lesen(analyseoff+o));

    case typ[3] of
      'I': (* getestet mit TSI1 und TSI2 *)
        begin
          for z:=1 to 2 do
            begin
              datei_lesen(form_puffer,analyseoff+o,512);
              exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,80);
              Inc(o,Length(exezk)+1);
            end;
          if typ[4]='1' then
            Inc(o,4)
          else
            Inc(o,8);
        end;

      'W': (* getestet mit TSW3 *)
        begin
          Inc(o,4+x_longint__datei_lesen(analyseoff+o));
          Inc(o,8);
        end;
    end;


    (* Schnelldurchlauf zur Berechnung der KopflÑnge *)
    datenposition:=o;
    for z:=anzahl downto 1 do
      begin
        datei_lesen(form_puffer,analyseoff+datenposition,512);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,80);
        Inc(datenposition,Length(exezk)+1+16);
      end;

    einzel_laenge:=datenposition;

    for z:=anzahl downto 1 do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,80);
        Inc(o,Length(exezk)+1);

        laenge_ausgepackt:=x_longint__datei_lesen(analyseoff+o);
        Inc(o,16);
        laenge_eingepackt:=laenge_ausgepackt;
        archiv_datei;

        leerzeichenerweiterung(exezk,30);
        exezk_anhaengen(' [');
        exezk_anhaengen(str11_oder_hexDGT(analyseoff+datenposition));
        exezk_anhaengen(']');
        archiv_datei_ausschrift(exezk);
        Inc(datenposition,laenge_eingepackt)
      end;

    archiv_summe;

  end;

procedure norton_av_archiv(const oe:dateigroessetyp);
  var
    o                   :dateigroessetyp;
    ende                :boolean;
  begin
    ausschrift('Symantec Antivirus Research Center',packer_dat);
    if not langformat then exit;

    archiv_start;

    datei_lesen(form_puffer,oe,512);
    o:=oe-longint_z(@form_puffer.d[$0e])^;
    datei_lesen(form_puffer,o,512);
    ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,80),beschreibung);

    repeat
      DecDGT(o,$1e);
      datei_lesen(form_puffer,o,512);
      ende:=(form_puffer.d[9] and $80)<>0;
      laenge_eingepackt:=longint_z(@form_puffer.d[$0e])^;
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;
      DecDGT(o,longint_z(@form_puffer.d[$16])^+1);
      datei_lesen(form_puffer,o,512);
      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[1],#0,255));
      DecDGT(o,laenge_eingepackt);
    until (*form_puffer.d[0]=0;*) (o<=analyseoff) or ende;

    archiv_summe;
  end;

procedure wpi(const o0:dateigroessetyp;const dnn:string);
  var
    o           :dateigroessetyp;
    unbekannt   :longint;
    h4          :dateigroessetyp;
  begin
    if not bytesuche__datei_lesen(o0,#$77#$04#$02#$be) then
      Exit;

    ausschrift('WarpIN / Jens BÑckmann; Ulrich Mîller; Teemu Ahola ['
      +textz_form__Format^+' '+str0(byte__datei_lesen(o0+4))+']',packer_dat);
    if not langformat then exit;

    (* Format:

    $000 Kennung
    $004 Mindestversion
    $006 Pfad
    $106 'Test application'
    $146 'Ulrich Mîller'
    $186 'N/A'
    $1c6 -
    $206 revision
    $208 os
    $20a packs
    $20c LÑnge .ins ausgepackt
    $20e LÑnge .ins eingepackt
    $210 extended data

    $214 ...
oder
    $214 Block($28)
    ...                 *)


    (* BZIP2 fÅr *.INS prÅfen *)
    unbekannt:=0;
    datei_lesen(form_puffer,o0+$214,8);

    if not bytesuche(form_puffer.d[0],'BZh?1A') then (* kein BZIP2 *)
      begin

        (* finde ich dumm, aber als exe hat ein Archiv einen 2. Kopf am Ende *)
        unbekannt:=longint_z(@form_puffer.d[0])^;
        if (unbekannt and $ffff0000)<>0 then unbekannt:=0; (* meist $28 *)

        o:=o0 +$214                               (* KopflÑnge          *)
              +unbekannt
              +x_word__datei_lesen(o0+$20e)       (* Script eingepackt  *)
              +x_longint__datei_lesen(o0+$210)    (* extra              *)
              +x_word__datei_lesen(o0+$20a)*$30;  (* Paktekîpfe         *)

        if ($214=einzel_laenge)
        or (o0+einzel_laenge=o) then (* keine Daten -kaputt *)
          Exit;

        if x_word__datei_lesen(o0+$20e)=0 then (* kein .INS *)
          begin
            (* dann erwarte ich wenigstens eine Datei .. *)
            if not bytesuche__datei_lesen(o,#$12#$f0) then
              if bytesuche__datei_lesen(o-unbekannt,#$12#$f0) then
                unbekannt:=0
              else
                Exit;
          end
        else (* .INS vorhanden (gepackt) *)
          begin
            (* 0.9.14 EXE *)
            if not bytesuche__datei_lesen(o0+$214+unbekannt,'BZh?1A') then
              Exit;
          end;
      end;


    o:=o0;
    archiv_start;

    datei_lesen(form_puffer,o,512);
    (* Ñrgerlicherweise immer gleich *)
    exezk:=puffer_zu_zk_e(form_puffer.d[$106],#0,$40);
    if  (exezk<>'Test application')
    and (exezk<>'reserved') then (* xwp-0-99-13.wpi *)
      begin
        ausschrift(exezk,beschreibung);
        exezk:=puffer_zu_zk_e(form_puffer.d[$146],#0,$40);
        (* 'Ulrich Mîller' *)
        ausschrift(exezk,beschreibung);
      end;

    laenge_ausgepackt:=x_word__datei_lesen(o+$20c);
    if laenge_ausgepackt=0 then laenge_ausgepackt:=-1;
    laenge_eingepackt:=x_word__datei_lesen(o+$20e);
    if laenge_eingepackt>0 then
      begin
        archiv_datei;
        exezk:='?.INS';
        exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
        archiv_datei_ausschrift(exezk);

        if laenge_ausgepackt<=0 then
        archiv_start_leise; (* neu anfangen, damit die Summenzeile durch
        die Fehlende Angabe zur Installationsanweisung nicht gestîrt wird *)
      end;

    o:=o0
       +$214                               (* KopflÑnge          *)
       +unbekannt
       +x_word__datei_lesen(o0+$20e)       (* Script eingepackt  *)
       +x_longint__datei_lesen(o0+$210)    (* extra              *)
       +x_word__datei_lesen(o0+$20a)*$30;  (* Paktekîpfe         *)



    repeat
      datei_lesen(form_puffer,o,512);
      if not bytesuche(form_puffer.d[0],#$12#$f0) then
        begin
          {ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);}
          Break;
        end;

      laenge_ausgepackt:=longint_z(@form_puffer.d[$08])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$0c])^;
      archiv_datei;
      exezk:=puffer_zu_zk_e(form_puffer.d[$14],#0,255);
      exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(47);
      exezk_anhaengen(' [');
      exezk_anhaengen(str0(word_z(@form_puffer.d[$06])^));
      exezk_anhaengen(']');
      archiv_datei_ausschrift(exezk);
      IncDGT(o,$11d+form_puffer.d[$11c]+laenge_eingepackt);

    until o>=o0+einzel_laenge;
    archiv_summe;

    if o0=analyseoff then
      einzel_laenge:=o-o0;

    if o0<>0 then
      begin
        h4:=AndDGT(o+512-1,-512);
        if h4<dateilaenge then
          (* WPI Format 4 nach Format 3.. -> Dateiposition ist verschoben -> nicht benutzbar *)
          if not bytesuche__datei_lesen(h4,#$77#$04#$02#$be#$04) then
            befehl_schnitt(o0,o-o0,erzeuge_neuen_dateinamen({dnn}'.WPI'));
      end;

  end;

procedure zpak;
  var
    anzahl,
    zaehler             :word_norm;
  begin
    (* IBM BookManager Reader *)
    (* PKWARE LIB .. *)
    ausschrift('ZPAK / IBM [PKWARE-LIB]',packer_dat);
    if not langformat then exit;


    anzahl:=x_word__datei_lesen(analyseoff+einzel_laenge-$16);
    if (anzahl*$72>einzel_laenge) or (anzahl>10000) then
      begin
        ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
        Exit;
      end;

    archiv_start;

    for zaehler:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+einzel_laenge-(anzahl-zaehler+1)*$72-$16,$72);

        laenge_eingepackt:=longint_z(@form_puffer.d[$66])^;
        laenge_ausgepackt:=laenge_eingepackt; (* eigentlich unbekannt, sieht aber besser aus *)
        archiv_datei;

        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,$40));
      end;
    archiv_summe;

  end;

procedure logitech_expand(const p:puffertyp);
  var
    w1                  :word_norm;
  begin
    archiv_start_leise;
    laenge_eingepackt:=DGT_zu_longint(einzel_laenge);
    laenge_ausgepackt:=longint_z(@p.d[4])^;
    archiv_datei;
    exezk:=dateiname;
    repeat
      w1:=pos('\',exezk);
      if w1=0 then
      w1:=pos('/',exezk);
      if w1=0 then break;
      delete(exezk,1,w1);
    until false;
    exezk[length(exezk)]:=chr(p.d[2]);
    ausschrift('Logitech Expand '+laenge_ausgepackt_zk+verhaeltnis_zk+'% '+exezk,packer_dat);
    archiv_summe_leise;
  end;

procedure tpwm(const p:puffertyp);
  begin
    (* Battle Isle 2 *)
    archiv_start_leise;
    laenge_eingepackt:=DGT_zu_longint(einzel_laenge);
    laenge_ausgepackt:=longint_z(@p.d[4])^;
    archiv_datei;
    ausschrift({'TPWM / BlueByte '}
                'Turbo Packer / Wolfgang Mayerle (BlueByte)'+laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);
    archiv_summe_leise;
  end;

procedure graphics_bpd(const anzahl:longint);
  var
    z,z2                :longint;
    o                   :longint;
    namenlaenge         :word_norm;
  begin
    (* GRAPHICS.BPD *)
    ausschrift('binary portable DLL / SciTech Software',packer_dat); (* OS2 SDD GRADD BETA 8 *)
    if not langformat then exit;

    archiv_start;
    o:=4;
    namenlaenge:=40;

    for z:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+o,namenlaenge+4+4);

        if z=1 then
          if analyseoff+4+anzahl*(40+4+4)<>longint_z(@form_puffer.d[40])^ then
            namenlaenge:=8+1+3+1;

        for z2:=0 to namenlaenge-1 do
          form_puffer.d[z2]:=form_puffer.d[z2]
                             xor $ff
                             xor (1 shl ((z2+5) and $7) );

        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,namenlaenge);
        laenge_eingepackt:=longint_z(@form_puffer.d[namenlaenge+4])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;

        befehl_schnitt(longint_z(@form_puffer.d[namenlaenge])^,laenge_eingepackt,exezk);

        leerzeichenerweiterung(exezk,namenlaenge);
        exezk_anhaengen(' [');
        exezk_anhaengen(str11_oder_hex(longint_z(@form_puffer.d[namenlaenge])^));
        merke_position(longint_z(@form_puffer.d[namenlaenge])^,datentyp_unbekannt);

        exezk_anhaengen(']');
        archiv_datei_ausschrift(exezk);
        Inc(o,namenlaenge+4+4);
      end;
    archiv_summe;
    einzel_laenge:=o;

  end;

procedure vxrexx{(const o_:longint;const version:byte;const zusatzblock:longint)};
  var
    zk                  :string;
    o,o1                :dateigroessetyp;
    ende                :dateigroessetyp;
    delta               :dateigroessetyp;
    version             :longint;
    inhaltsverzeichnis_anfang   :dateigroessetyp;
    inhaltsverzeichnis_ende     :dateigroessetyp;
    datenende                   :dateigroessetyp;
  begin
    (* Tyra/2 TYRA2.EXE, INSTALL.EXE *)

    datei_lesen(form_puffer,analyseoff+einzel_laenge-$14,$14);
    version:=longint_z(@form_puffer.d[0])^;
    if version>$ff then
      version:=0;

    inhaltsverzeichnis_ende  :=analyseoff+einzel_laenge-$10;

    if version<>0 then
      DecDGT(inhaltsverzeichnis_ende,8+4);

    inhaltsverzeichnis_anfang:=inhaltsverzeichnis_ende
                              -longint_z(@form_puffer.d[$14-$8])^
                              +longint_z(@form_puffer.d[$14-$c])^;

    datenende:=inhaltsverzeichnis_ende-longint_z(@form_puffer.d[$14-$8])^;


    case version of
      0:zk:='1.00'; (* CALC *)
      1:zk:='1.01,2.00'; (* (1.01, PATCH C, DEMO) (VXTECH05.ZIP: "2.00" *)
    (*2:zk:=''*)
      2:zk:='2.10';
      3:zk:='2.1?..2.14'
    else
        zk:='?.?? ¯'
    end;
    zk:=str0(version)+': '+zk;

    ausschrift('VX-Rexx / Watcom ['+zk+']',compiler);
    if not langformat then exit;

    (* wahren Anfang suchen *)
    o:=inhaltsverzeichnis_anfang;

    ende:=0;
    repeat
      datei_lesen(form_puffer,o,512);
      IncDGT(o,$c+2+form_puffer.d[$c]);
      if longint_z(@form_puffer.d[0])^<>-1 then
        ende:=MaxDGT(ende,longint_z(@form_puffer.d[0])^+longint_z(@form_puffer.d[4])^);
    until o>=inhaltsverzeichnis_ende;

    if ende=0 then
      delta:=0
    else
      delta:=datenende-ende;

    if delta<>0 then
      begin
        zk:='Delta ';
        if delta<0 then
          zk_anhaengen(zk,'-');
        zk_anhaengen(zk,str11_oder_hexDGT(Abs(delta)));
        zk_anhaengen(zk,'!');
        ausschrift(zk,dat_fehler)
      end;

    archiv_start;
    o:=inhaltsverzeichnis_anfang;
    repeat
      datei_lesen(form_puffer,o,512);

      laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
      laenge_ausgepackt:=laenge_eingepackt;

      (* Format 2, .vrm *)
      if (version=2) and (form_puffer.d[8]=1) then
        (* gepackt, nicht xor32 *)
        if x_longint__datei_lesen(delta+longint_z(@form_puffer.d[0])^+4)=0 then
          begin
            ende:=datenende;
            o1:=o;
            IncDGT(o1,$c+2+form_puffer.d[$c]); (* zur nÑchsten Datei *)
            while o1<inhaltsverzeichnis_ende do
              begin
                datei_lesen(form_puffer,o1,$e);
                (* Anfangsposition gÅltig? *)
                if  (longint_z(@form_puffer.d[4])^>0)
                and (longint_z(@form_puffer.d[0])^<>-1) then
                  begin
                    ende:=delta+longint_z(@form_puffer.d[0])^;
                    Break;
                  end;
                IncDGT(o1,$c+2+form_puffer.d[$c]);
              end;


            datei_lesen(form_puffer,o,512);
            laenge_eingepackt:=DGT_zu_longint(ende-(delta+longint_z(@form_puffer.d[0])^));
          end;


      (* .VRM,.VRW *)
      if (form_puffer.d[8] in [1,2])
      and (longint_z(@form_puffer.d[0])^<>-1)
      and (version>=2) then
        if (version=3)
        or (x_longint__datei_lesen(delta+longint_z(@form_puffer.d[0])^+4)<>1) then
          laenge_ausgepackt:=x_longint__datei_lesen(delta+longint_z(@form_puffer.d[0])^);

      archiv_datei;

      exezk:=puffer_zu_zk_l(form_puffer.d[$e],form_puffer.d[$c]);
      exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(35);
      exezk:=exezk+' ('+str0(form_puffer.d[8])+')';

      (* bei Verweisen auf lose Dateien keine Dateiposition ausgeben *)
      if longint_z(@form_puffer.d[0])^<>-1 then
        exezk:=exezk+'  -> '+str11_oder_hexDGT(delta+longint_z(@form_puffer.d[0])^);

      archiv_datei_ausschrift(exezk);

      IncDGT(o,$c+2+form_puffer.d[$c]);

    until o>=inhaltsverzeichnis_ende;
    archiv_summe;

  end;

procedure nai_lzhuflib;
  var
    o                   :longint;
    alt                 :boolean;
  begin
    (* "superdat" fÅr virscan (superschrott) *)
    ausschrift('NAI LZHUFLIB; SuperDAT',packer_dat);
    befehl_sonst('copy '+dateiname+' tmptyp.exe');
    befehl_sonst('command /c tmptyp.exe /e');
    befehl_sonst('del tmptyp.exe');

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[4],'__NAI') then
        Break;

      laenge_ausgepackt:=longint_z(@form_puffer.d[$116+0])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$116+4])^;

      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$12],#0,255));

      Inc(o,$120+laenge_eingepackt);

    until o>=einzel_laenge;

    alt:=true;

    if bytesuche(form_puffer.d[4],'NAISIGN') then
      begin
        Inc(o,$11);
        repeat
          datei_lesen(form_puffer,analyseoff+o,512);

          (* 4281xdat.exe *)
          if bytesuche(form_puffer.d[$04],#$ef#$be#$ad#$de'__NAI') then
            begin
              Inc(o,4);
              Break;
            end;

          if bytesuche(form_puffer.d[$04],'_SUPERDAT_HEADER') then
            begin
              Inc(o,4+$21);
              if longint_z(@form_puffer.d[$15])^=0 then
                begin (* sdat4055.exe *)
                  Inc(o,$108);
                end;
              Break;
            end;

          if bytesuche(form_puffer.d[$04+4],'_SUPERDAT_HEADER') then
            begin
              Inc(o,4+4+$21);
              Break;
            end;

          if form_puffer.d[$04]=0 then Break;
          exezk:=puffer_zu_zk_e(form_puffer.d[$04],#0,$90);
          exezk_leerzeichen_erweiterung(8+1+3+2);
          exezk:=exezk+puffer_zu_zk_e(form_puffer.d[$98],#0,$0c);
          ausschrift(exezk,beschreibung);


          if alt then
            begin
              exezk:=puffer_zu_zk_e(form_puffer.d[$aa+$04],#0,$90);
              if (not ist_ohne_steuerzeichen(exezk))
              or (Length(exezk) in [1..3]) then
                alt:=false;
            end;

          if alt then
            Inc(o,$aa)
          else
            Inc(o,$aa+8);
        until o+$21>einzel_laenge;

      end;

    einzel_laenge:=o;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;

  end;

procedure linkit_michael_badichi;
  var
    o:longint;
  begin
    ausschrift('LINK IT / Michael Badichi [1.0·]',packer_dat);

    if not langformat then exit;
    archiv_start;
    o:=0;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_eingepackt:=word_z(@form_puffer.d[0])^*$10000+word_z(@form_puffer.d[2])^;
      laenge_ausgepackt:=laenge_eingepackt;

      exezk:=puffer_zu_zk_e(form_puffer.d[4],#0,128);

      Inc(o,5+Length(exezk)+laenge_eingepackt);

      if exezk='' then exezk:='?';

      archiv_datei;
      archiv_datei_ausschrift(exezk);


    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure svct; (* MAC *)

  procedure svct_rekursiv(const pfad:string;const tiefe:integer_norm;var o:longint);
    begin
      repeat
        datei_lesen(form_puffer,analyseoff+o,512);
        if not bytesuche(form_puffer.d[1],'VCT') then break;

        case Chr(form_puffer.d[0]) of
          'S': (* gepackte Daten *)
            Inc(o,m_longint(form_puffer.d[$24]));
          'C': (* ? *)
            Inc(o,$64);
          'D': (* Verzeichnis *)
            begin
              if tiefe>=form_puffer.d[$49] then
                exit;

              laenge_eingepackt:=0;
              laenge_ausgepackt:=0;

              exezk:=pfad+puffer_zu_zk_l(form_puffer.d[$94],form_puffer.d[$50]);
              archiv_datei;
              archiv_datei_ausschrift_verzeichnis(exezk);

              Inc(o,$94+form_puffer.d[$50]);
              svct_rekursiv(exezk+'\',tiefe+1,o);
            end;
          'F': (* Datei *)
            begin
              exezk:=pfad+puffer_zu_zk_l(form_puffer.d[$ba],form_puffer.d[$7a]);
              Inc(o,$ba+form_puffer.d[$7a]);

              laenge_eingepackt:=-1;
              laenge_ausgepackt:=m_longint(form_puffer.d[$48]);

              exezk_leerzeichen_erweiterung(45);
              exezk:=exezk+' ['+puffer_zu_zk_l(form_puffer.d[$2c],4)+'/'+puffer_zu_zk_l(form_puffer.d[$30],4)+']';
              archiv_datei;
              archiv_datei_ausschrift(exezk);

              if (form_puffer.d[$7b]<>0) and ((form_puffer.d[$c] and $08)<>0) then
                begin
                  ausschrift_x(datei_lesen__zu_zk_l(analyseoff+o,form_puffer.d[$7b]),beschreibung,leer);
                  Inc(o,form_puffer.d[$7b]);
                end;

            end;
        else
          ausschrift('???',dat_fehler);
          Break;
        end;

      until o>=einzel_laenge;
    end;

  var
    o:longint;
  begin
    (* ffymacos.bin, netfinde.bin *)
    (*ausschrift('? SVCT/CVCT/FVCT/DVCT',packer_dat);*)
    ausschrift('Installer VISE / Mindvision',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=0;

    svct_rekursiv('',-1,o);

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=falsch;
    archiv_summe;

  end;

procedure tgcf;
  var
    o:longint;
  begin
    (* This program uses the TG Byte SoftWare Data Compression Specialist 97
       Version 1.30.970c (Jul 14 1997) - Copyright (C) 1995-1997
       Thilo-Alexander Ginkel *)
    (*ausschrift('? TGCF / TG Byte Software (zip/bzip2)',packer_dat);*)
    ausschrift('TG Byte SoftWare Data Compression / Thilo-Alexander Ginkel [zlib]',packer_dat);

    if not langformat then exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'TGCF') then
        Break;

      case form_puffer.d[4] of
        0: (* Archivkopf?? *)
          begin

             if bytesuche(form_puffer.d[4],#$00#$24#$01#$50) then
               (* 'SETUP.EXE' *)
               begin
                 (* ? Inc(o,5+form_puffer.d[4]+4); ( * Kopf+Daten[$24]+CRC? *)
                 laenge_eingepackt:=0;
                 laenge_ausgepackt:=0;

                 archiv_datei;
                 exezk:=puffer_zu_zk_pstr(form_puffer.d[$1c-1]);
                 archiv_datei;
                 archiv_datei_ausschrift(exezk);
                 Inc(o,$1c+Length(exezk)+4);
                 Continue;
               end;

             if bytesuche(form_puffer.d[4],#$00#$48#$01#$50) then
               begin
                 laenge_eingepackt:=m_longint(form_puffer.d[$14]);
                 laenge_ausgepackt:=m_longint(form_puffer.d[$18]);

                 archiv_datei;
                 exezk:=puffer_zu_zk_e(form_puffer.d[$24],#0,255);
                 Inc(o,$24+1+Length(exezk));

                 datei_lesen(form_puffer,analyseoff+o,512);

                 exezk:=puffer_zu_zk_e(form_puffer.d[$00],#0,255);
                 archiv_datei_ausschrift(exezk);

                 Inc(o,Length(exezk));
                 Inc(o,1+5);
                 befehl_erzeuge_verzeichnisse_rekursiv(exezk);
                 befehl_e_infla(analyseoff+o+2,laenge_eingepackt-2,exezk);
                 Inc(o,laenge_eingepackt);
                 Continue;
               end;



            (*klappt nicht mit DXBUSTER.EXE: Inc(o,5+form_puffer.d[5]);
              if o+5=einzel_laenge then Inc(o,5);*)

            if form_puffer.d[5]=0 then
              Inc(o,5+5) (*ENDE*)
            else
              Inc(o,$1c+form_puffer.d[$1b]+4);

          end;
        3:
          begin
            laenge_eingepackt:=m_longint(form_puffer.d[$14]);
            laenge_ausgepackt:=m_longint(form_puffer.d[$18]);

            archiv_datei;
            exezk:=puffer_zu_zk_e(form_puffer.d[$24],#0,255);
            Inc(o,$24+1+Length(exezk));

            datei_lesen(form_puffer,analyseoff+o,512);

            exezk:=puffer_zu_zk_e(form_puffer.d[$00],#0,255);
            archiv_datei_ausschrift(exezk);

            Inc(o,Length(exezk));
            Inc(o,1+5+laenge_eingepackt);
          end;
      else
        ausschrift(str0(form_puffer.d[4]),dat_fehler);
        Break;
      end;

    until o>=einzel_laenge;
    archiv_summe;
    einzel_laenge:=o;

  end;

procedure oberon_arc;
  var
    o:longint;
  begin
    ausschrift('Oberon-compressed',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=$1a;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_eingepackt:=longint_z(@form_puffer.d[$20])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$24])^;

      archiv_datei;
      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,$20));
      Inc(o,52+laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure vise_pe(const p:puffertyp); (* MSW (PE) *)
  var
    bl,o1,o2,
    o:longint;
    i,anzahl:word_norm;
  begin
    ausschrift('Installer VISE / Mindvision',packer_dat);

    if not langformat then exit;

    archiv_start;

    o:=puffer_pos_suche(p,#$00'?vise',180);
    if o=nicht_gefunden then
      o:=$2e (* geraten *)
    else
      Dec(o,2);


    anzahl:=p.d[o+1];
    Inc(o,3);
    for i:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
        Inc(o,1+form_puffer.d[0]);
        datei_lesen(form_puffer,analyseoff+o,16);
        Inc(o,16);
        laenge_eingepackt:=longint_z(@form_puffer.d[$c])^;
        laenge_ausgepackt:=-1;
        archiv_datei;
        archiv_datei_ausschrift(exezk);

        Inc(o,laenge_eingepackt);
      end;

    ausschrift(hex_longint({analyseoff}+o),signatur);

    (*$IfDef MUELL*)

    //....

    // Suche "Support files (4x oder $15x mal Installationsauswahl, lÑnge $71

    o1:=datei_pos_suche(analyseoff+0,analyseoff+einzel_laenge,#$0d#$00'Support Files'#$00);
    if o1=nicht_gefunden then Exit;
    Dec(o1,analyseoff);

    o2:=datei_pos_suche(analyseoff+0,analyseoff+einzel_laenge,#$0d#$00'Typical Setup'#$00);
    if o2=nicht_gefunden then Exit;
    Dec(o2,analyseoff);

    bl:=o2-o1;
    ausschrift('Blockgrî·e:'+str0(bl),normal);

    o:=o1;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      ausschrift(puffer_zu_zk_e(form_puffer.d[2],#0,80),beschreibung);
      Inc(o,bl);
    until o>=einzel_laenge;
    archiv_summe;
    Exit;




    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      exezk:=puffer_zu_zk_pstr(form_puffer.d[4]);
      if exezk='' then
        begin
          Inc(o,form_puffer.d[3]);
          laenge_eingepackt:=x_longint__datei_lesen(analyseoff+o);
          laenge_ausgepackt:=-1;
          Inc(o,4+15);
        end
      else
        begin
          if exezk[1]=#0 then
            begin
              ausschrift('???',dat_fehler);
              break;
            end;
          laenge_eingepackt:=longint_z(@form_puffer.d[5+form_puffer.d[4]+12])^;
          laenge_ausgepackt:=-1;
          Inc(o,5+form_puffer.d[4]+12);
        end;

      archiv_datei;
      archiv_datei_ausschrift(exezk);

      Inc(o,laenge_eingepackt);

      ausschrift(hex_longint(analyseoff+o),signatur);
(*      ausschrift(str0(5+form_puffer.d[4]+12),signatur);*)


    until o>=einzel_laenge;
    (*$EndIf MUELL*)
    archiv_summe;
  end;

procedure jls_archiv(const p:puffertyp);
  var
    z:longint;
  begin
    (*  MEGA303B.ZIP *)
    ausschrift('?JLS / Jayeson Lee-Steere',packer_dat);
    if not langformat then exit;

    archiv_start;
    for z:=1 to longint_z(@p.d[8])^ do
      begin
        datei_lesen(form_puffer,analyseoff+$14+(z-1)*$1f,$1f);
        laenge_eingepackt:=longint_z(@form_puffer.d[$13])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[$13])^;

        archiv_datei;
        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,8+1+3));
      end;
    archiv_summe;
  end;

end.

