(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_for4;

interface

uses
  typ_type;

procedure dell_lz_image(const p:puffertyp);
procedure pgpsea(const ende:longint);
procedure n6setup_gepackte_datei(const o,l:dateigroessetyp;const name_:string);
procedure rzt_realnetworks(const o,l:dateigroessetyp);
procedure dell_falshimagedata;
procedure winzip(const name_:string);
procedure SaveRam2(const anzahl_dateien:word_norm);
procedure systemsoft_bios_archiv(const o0:longint);
procedure softpaq_5(const version:byte);
procedure install_builder_joseph_leung(v:byte);
procedure rar140;
procedure softpaq;
procedure quick_release_sector_transfer;
procedure compaq_install_pe_4;
procedure rompaq;
procedure wps_backup(const p:puffertyp);
procedure installshield_18000;
procedure iconease_dat_130;
procedure versuche_sbc(const p:puffertyp);
procedure MacBinary(const p:puffertyp);
procedure foxpatchf(const p:puffertyp);
procedure nullsoft_inst_x(const p:puffertyp;ver,offs,extra:word_norm);
procedure nullsoft_pimp(const p:puffertyp);
procedure semtex_xfilelib(e:longint);
procedure aplib(const p:puffertyp);
procedure atheos(const p:puffertyp);
procedure bioarc;
procedure animated_system_design;
procedure packer_IH;
procedure tshtsh_daniel_valot;
procedure ardi;
procedure smartsetup;
procedure bzip2;
procedure clickteam;
procedure archivefile;
procedure disketten_abzugsdatei_fat(zylinder,sektoren_je_spur,anzahl_koepfe:word_norm);
procedure windows_clp;
procedure inno_setup;
procedure lpac(const p:puffertyp);
procedure updateit;
procedure neobook(const dir_anfang,dir_ende:dateigroessetyp);
procedure dateisystem_iso9660(const sektorgroesse,sektordatenstart:dateigroessetyp);
procedure cdrom_boot_catalog(o0:dateigroessetyp;l:word_norm;z_cd_sektor:z_cd_puffer_typ);
procedure cazip;
procedure ogg_vorbis;
procedure vise_avp;
procedure chp_avp;
procedure amibios_archiv(o,mb0:longint;const titel:string);
procedure amibios_einzelblock_alt(const p:puffertyp;const dname:string);
procedure borland_pascal_resource(o,e:dateigroessetyp;version:byte);
procedure png(const p:puffertyp);
procedure bar;
procedure lzk;
procedure versuche_exebundle;
procedure macromedia_flash(const p:puffertyp);
procedure mcfx(const p:puffertyp);
procedure netscape_reg(const p:puffertyp);
procedure BriefLZ(const p:puffertyp;const titel:string);
procedure lzx;
procedure mmbuilder(const p:puffertyp);
procedure addd(const p:puffertyp);
procedure comprsia(const p:puffertyp);
procedure ibm_dd_pak(const p:puffertyp);
procedure hmi_archiv;
procedure anvil_of_dawn(const p:puffertyp);
procedure adf(const p:puffertyp);
procedure d64;
procedure fastlynx(const p:puffertyp);
procedure d81;
procedure lingvoarc2;
procedure finear(const p:puffertyp);
procedure living;
procedure gkware_selfextractor;
procedure gkware_selfextractor_tmp;
procedure gkware_bin_tiefe3;
procedure multics_archive;
procedure bcomp(anzahl:word_norm);
procedure ictselfx;
procedure dca(const p:puffertyp);
procedure pklite_unix(const p:puffertyp);
procedure seau(const o0,l:dateigroessetyp;const p:puffertyp);
procedure squez4(const p:puffertyp);
procedure Siebenzip_install_text;
procedure siebenzip;
procedure wise_pw_msi(const o,l:dateigroessetyp);
procedure zupmaker;
procedure ifah;
procedure ashampoo_rawdata(const o,l:dateigroessetyp);
procedure progressive_setup(const p:puffertyp;bz2:dateigroessetyp);
procedure trillian_install_program;
procedure lzop;
procedure bee;
procedure p12_p5_p6(const p:puffertyp);
procedure qlfc;
procedure ENhanced_Compressor;
procedure optimfrog;
procedure dbsoft_header(const p:puffertyp);
procedure dbsoft_ace(const p:puffertyp);
procedure rkau(const p:puffertyp);
procedure tnef;
procedure versuche_Basic_Linker(const p:puffertyp);
procedure COMPACKR;
procedure vise_updater;
procedure exp1;
procedure LSP_SFX_Builder;
procedure ese(const p:puffertyp);
procedure xact_lib(const p:puffertyp);
procedure mpeg4;
procedure vuzip;
procedure gsfx;
procedure aialf21(const p:puffertyp);
procedure pe2com(pos_name,code_laenge,exe_laenge:longint);
procedure nbasmc_lib;
procedure cxf(o0:longint);
procedure uharc(const p:puffertyp);
procedure romfs;

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
  typ_entp;

procedure dell_lz_image(const p:puffertyp);
  begin
    ausschrift('DCOPY : "DELL_LZ_IMAGE"',packer_dat);
    if not langformat then exit;

    archiv_start{_halb};
    laenge_eingepackt:=DGT_zu_longint(einzel_laenge);
    laenge_ausgepackt:=longint_z(@p.d[14])^;
    archiv_datei;
    archiv_datei_ausschrift('?');
    archiv_summe_leise;

  end;

procedure pgpsea(const ende:longint);
  var
    o:longint;
  begin
    ausschrift('PGPSEA / NAI',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
      exezk:=puffer_zu_zk_e(form_puffer.d[4],#0,255);
      Inc(o,Length(exezk)+1+4);
      if laenge_eingepackt=$ffffffff then
        begin
          laenge_eingepackt:=0;
          laenge_ausgepackt:=0;
          archiv_datei;
          archiv_datei_ausschrift_verzeichnis(exezk);
        end
      else
        begin
          befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
          laenge_ausgepackt:=laenge_eingepackt;
          archiv_datei;
          archiv_datei_ausschrift(exezk);
        end;

      Inc(o,laenge_eingepackt);
    until o>=ende;
    archiv_summe;

  end;

procedure n6setup_gepackte_datei(const o,l:dateigroessetyp;const name_:string);
  begin
    if not langformat then exit;

    if archiv_summen_dateien=0 then
      begin
        ausschrift('<n6setup>',packer_dat);
        archiv_start;
      end;

    datei_lesen(form_puffer,o,$10);
    laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
    laenge_ausgepackt:=longint_z(@form_puffer.d[4])^;
    archiv_datei;
    archiv_datei_ausschrift(name_);

    befehl_e_infla(o+$0a,laenge_eingepackt,name_);

  end;

procedure rzt_realnetworks(const o,l:dateigroessetyp);
  var
    oo,anzahl:longint;
  begin
    ausschrift('rzt / RealNetworks',packer_dat);
    if not langformat then exit;

    archiv_start;
    oo:=8;
    anzahl:=m_longint__datei_lesen(o+oo);
    Inc(oo,4);
    while anzahl>0 do
      begin
        Dec(anzahl);
        exezk:=datei_lesen__zu_zk_pstr(o+oo);
        Inc(oo,1+Length(exezk));
        laenge_ausgepackt:=m_longint__datei_lesen(o+oo);Inc(oo,4);
        laenge_eingepackt:=-1;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
      end;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe_eingepackt:=l;
    archiv_summe;

  end;

procedure dell_falshimagedata;
  var
    o:longint;
  begin
    ausschrift('FLASHImageData / DELL',packer_dat);
    if not langformat then exit;

    o:=$10;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$20);
      Inc(o,$20);
      laenge_ausgepackt:=longint_z(@form_puffer.d[$18])^;
      laenge_eingepackt:=laenge_ausgepackt;
      exezk:=puffer_zu_zk_e(form_puffer.d[$08],#0,8+1+3);
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure winzip(const name_:string);
  var
    zip_anfang:dateigroessetyp;
  begin
    zip_anfang:=datei_pos_suche(analyseoff,analyseoff+einzel_laenge,'PK'#$03#$04);

    if zip_anfang<>nicht_gefunden then
      einzel_laenge:=zip_anfang-analyseoff;

    ausschrift('WinZip / Nico Mak Computing',packer_dat);
    befehl_e_infla(analyseoff,einzel_laenge,name_);

  end;

procedure SaveRam2(const anzahl_dateien:word_norm);
  var
    dateityp            :byte;
    dateiname_pos,
    name_,
    verzeichnis_zaehler :word_norm;
    ea_laenge,
    o_dir               :dateigroessetyp;
    zaehler             :word_norm;
    kommentar           :string;

  begin
    o_dir:=analyseoff+2+anzahl_dateien*$2c;

    datei_lesen(form_puffer,o_dir,258);
    if bytesuche(form_puffer.d[0],#$fe#$ff) then
      begin
        kommentar:=puffer_zu_zk_e(form_puffer.d[2],#0,256);
        datei_lesen(form_puffer,o_dir+(2+Length(kommentar)+1),258);
      end
    else
      kommentar:='';

    if not bytesuche(form_puffer.d[0],#$ff#$ff'SaveRam2 ') then
      Exit;

    ausschrift('SaveRam2 / Jack Gersbach;IBM',packer_dat);(* 2.0u *)


    if not langformat then exit;

    archiv_start;

    exezk:=puffer_zu_zk_e(form_puffer.d[2],#0,200);
    ausschrift(exezk,beschreibung);

    if kommentar<>'' then
      ausschrift(kommentar,beschreibung);

    (* smallword: Anzahl-1
       dateiblock: $2c

      00:   fe 00 00 00 00
      05:   byte 0=VOL 1=Datei
      06:   byte ATTR 20/08
      07:   ?
      08:   Position des Dateinamens
      0c:   Anzahl Namenteile
      0e:   longint EA-LÑnge

      13:   Ofs(Daten)
      17:   LÑnge eingepackt
      1d:   Datum
      1f:   LÑnge ausgepackt    *)

    for zaehler:=1 to anzahl_dateien-1 do
      begin
        datei_lesen(form_puffer,analyseoff+2+$2c*zaehler,$2c);
        laenge_ausgepackt:=longint_z(@form_puffer.d[$1f])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[$17])^;
        ea_laenge        :=longint_z(@form_puffer.d[$0e])^;
        dateityp:=form_puffer.d[$06];

        dateiname_pos:=longint_z(@form_puffer.d[$08])^;
        verzeichnis_zaehler:=word_z(@form_puffer.d[$0c])^;
        exezk:='';

        while verzeichnis_zaehler>0 do
          begin
            name_:=x_longint__datei_lesen(o_dir+dateiname_pos);
            datei_lesen(form_puffer,o_dir+name_,Min(256+4,dateiname_pos-name_));

            if verzeichnis_zaehler=1 then
              (* Dateiname *)
              exezk:=exezk+puffer_zu_zk_pstr(form_puffer.d[0])
            else
              (* Zeiger auf EA+Namen des Verzeichnisses *)
              exezk:=exezk+puffer_zu_zk_pstr(form_puffer.d[4])+'\';

            Dec(verzeichnis_zaehler);
            Inc(dateiname_pos,4);
          end;

        if ea_laenge<>0 then
          begin
            exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
            exezk_anhaengen(str_(DGT_zu_longint(ea_laenge),6));
            exezk_anhaengen(textz_form__leer_Byte_EA^);
          end;

        if (dateityp and $08)=$08 then
          begin
            exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
            exezk_anhaengen(textz_form__eckauf_Datentraegername_eckzu^);
          end;

        archiv_datei;
        archiv_datei_ausschrift(exezk);

        if ea_laenge<>0 then
          begin
            IncDGT(archiv_summe_eingepackt,ea_laenge);
            IncDGT(archiv_summe_ausgepackt,ea_laenge);
          end;
      end;

    archiv_summe;

  end;

procedure systemsoft_bios_archiv;
  var
    o                   :dateigroessetyp;
    anzahl_informationen,
    zaehler,
    nullpos             :word_norm;
    l                   :dateigroessetyp;
  begin
    if not langformat then exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,o,{ $14}$30);
      l:=einzel_laenge-o;
      if bytesuche(form_puffer.d[0],#$ee#$88) then
        begin
          laenge_eingepackt64:=word_z(@form_puffer.d[$c])^;
          laenge_ausgepackt64:=-1;
          archiv_datei64;
          archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[2],#0,8));
          IncDGT(o,$14);

          anzahl_informationen:=form_puffer.d[$a] shr 4;
          for zaehler:=1 to anzahl_informationen do
            begin
              datei_lesen(form_puffer,o,31+2);
              IncDGT(o,31+2);
              if bytesuche(form_puffer.d[0],#$dd#$88) then
                begin
                  exezk:=puffer_zu_zk_l(form_puffer.d[2],30);
                  repeat
                    nullpos:=Pos(#0,exezk);
                    if nullpos=0 then break;
                      exezk[nullpos]:=' ';
                  until true;
                  ausschrift_x(exezk,beschreibung,absatz);
                end;
            end;

          IncDGT(o,laenge_eingepackt64);
        end
      else if bytesuche(form_puffer.d[0],#$55#$aa) then
        begin
          rom_modul(form_puffer,analyseoff+o,'',laenge_eingepackt64);
          IncDGT(o,laenge_eingepackt64);
        end
      else if cpu_microcode(form_puffer,l) then
        begin
          IncDGT(o,l)
        end
      else
        o:=AndDGT(o,-512)+512;

    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure softpaq_5(const version:byte);
  var
    o,wo,m:dateigroessetyp;
  begin
(*  3.10,5.00*)
    case version of
      $00:exezk:='3.10';
      $08:exezk:='4.00';
      $10:exezk:='5.00';
    else
          exezk:='?.?? ¯ ('+str0(version)+')';
    end;

    ausschrift('SoftPaq  / Compaq ['+exezk+']',packer_exe);
    if not langformat then exit;

    case version of
      $00:o:=$08;
      $08:o:=$0c;
      $10:o:=$0c;
    else
      Exit;
    end;

    m:=analyseoff+o+8;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,8+4);
      IncDGT(o,8);
      if bytesuche(form_puffer.d[4],#$0#$0#$0#$0) then Break;
      if bytesuche(form_puffer.d[0],#$0#$0#$0#$0) then Continue;

      laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
      wo:=longint_z(@form_puffer.d[4])^;
      m:=MaxDGT(m,wo+laenge_eingepackt);


      datei_lesen(form_puffer,wo,256);
      if form_puffer.d[0]<=8+1+3 then
        begin
          Dec(laenge_eingepackt,1+form_puffer.d[0]);
          IncDGT(wo,1+form_puffer.d[0]);
          exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
        end
      else
        begin
          if laenge_eingepackt>50 then Break;
          exezk:=puffer_zu_zk_l(form_puffer.d[0],laenge_eingepackt);
          IncDGT(wo,laenge_eingepackt);
          laenge_eingepackt:=0;
          if exezk='.' then Continue;
        end;

      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      befehl_schnitt(wo,laenge_eingepackt,exezk);
    until false;
    archiv_summe;
    if version=$10 then IncDGT(m,8);
    einzel_laenge:=m-analyseoff;
  end;

procedure install_builder_joseph_leung(v:byte);
  var
    o:longint;
  begin
    ausschrift('Install Builder / Joseph Leung; SFX Maker / David Cornish',packer_dat);
    if not langformat then exit;

    if v<Ord('2') then
      o:=8
    else
      o:=10;
    while o<einzel_laenge do
      begin
        exezk:=datei_lesen__zu_zk_pstr(analyseoff+o);
        if exezk<>'' then
          ausschrift_x(exezk,beschreibung,absatz);
        Inc(o,1+Length(exezk));
      end;

  end;

procedure rar140;
  var
    o,l1                :longint;
    w1                  :word_norm;
  begin
    (* Eugene... *)
    ausschrift('RAR / Yevgeniy Roshal [<=1.40]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    (* Archivkopf *)
    datei_lesen(form_puffer,analyseoff+o,9);
    l1:=word_z(@form_puffer.d[4])^;
    if (form_puffer.d[6] and $12)=$02 then (* ungepackter Archivkommentar *)
      ansi_anzeige(analyseoff+o+9,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch,
        analyseoff+o+9+word_z(@form_puffer.d[7])^,'');
    Inc(o,l1);

    (* Dateien *)
    while o<einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,23);
        laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[4])^;
        archiv_datei;
        l1:=word_z(@form_puffer.d[10])^+laenge_eingepackt;
        (* nach der Dokumentation...
        w1:=21;
        ( * Dateikommentar * )
        if (form_puffer.d[17] and $08)<>0 then
          begin
            ansi_anzeige(analyseoff+o+w1+2,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch,
                         analyseoff+o+w1+2+word_z(@form_puffer.d[w1])^,'');
            Inc(w1,2+word_z(@form_puffer.d[w1])^);
          end;
        exezk:=datei_lesen__zu_zk_l(analyseoff+o+w1,form_puffer.d[19]);

        und nach der Wirklichkeit ...*)
        if (form_puffer.d[17] and $08)<>0 then
          begin
            w1:=21+form_puffer.d[19];
            ansi_anzeige(analyseoff+o+w1+2,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch,
                         analyseoff+o+w1+2+x_word__datei_lesen(analyseoff+o+w1),'');
          end;
        exezk:=datei_lesen__zu_zk_l(analyseoff+o+21,form_puffer.d[19]);

        exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);

        if (form_puffer.d[17] and $04)<>0 then
          exezk_anhaengen(textz_form__eckauf_Kennwort_eckzu^);
        if (form_puffer.d[17] and $01)<>0 then
          exezk_anhaengen(textz_form__leer_eckauf_Fortsetzung_eckzu^);
        if (form_puffer.d[17] and $02)<>0 then
          exezk_anhaengen(textz_form__leer_eckauf_Bruchstueck_eckzu^);

        archiv_datei_ausschrift(exezk);
        Inc(o,l1);
      end;
    archiv_summe;

  end;

procedure softpaq;
  var
    o,e,wo:dateigroessetyp;
  begin
    if einzel_laenge<2000 then
      Exit;

    o:=datei_pos_suche(analyseoff+einzel_laenge,analyseoff+einzel_laenge-2000,
      'spcu?'#$00#$00#$00#$00'.exe'#$00'??'#$00#$00#$00#$00#$00#$00);
    if o=nicht_gefunden then Exit;

    ausschrift('SoftPaq / Compaq [2.x] [PKWARE-LIB]',packer_dat);
    if not langformat then Exit;

    e:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,o,$26);
      exezk:=puffer_zu_zk_e(form_puffer.d[$0],#0,8)+puffer_zu_zk_e(form_puffer.d[9],#0,4);

      if  (longint_z(@form_puffer.d[$12])^>=e)
      and (longint_z(@form_puffer.d[$12])^<=e+2000) then
        begin
          wo:=longint_z(@form_puffer.d[$12])^;
          laenge_eingepackt:=longint_z(@form_puffer.d[$0e])^;
          laenge_ausgepackt:=laenge_eingepackt;
          befehl_schnitt(wo,laenge_eingepackt,exezk);
          IncDGT(o,$17);
        end
      else
        begin
          wo:=longint_z(@form_puffer.d[$22])^;
          laenge_eingepackt:=longint_z(@form_puffer.d[$1c])^;
          laenge_ausgepackt:=longint_z(@form_puffer.d[$18])^;
          befehl_ttdecomp(wo,laenge_eingepackt,exezk);
          IncDGT(o,$26);
        end;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      e:=wo+laenge_eingepackt;

    until o>=analyseoff+einzel_laenge;
    archiv_summe;

  end;

procedure quick_release_sector_transfer;
  begin
    ausschrift('Quick Release Sector Transfer / Compaq',packer_dat);
    ausschrift_x(datei_lesen__zu_zk_e(analyseoff+$0f,#0,$4b-$0f),beschreibung,absatz);
    if not langformat then exit;

    archiv_start;
    ansi_anzeige(analyseoff+$4b,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch,
        analyseoff+$27b,'');
    datei_lesen(form_puffer,analyseoff+$314,512);
    laenge_eingepackt:=longint_z(@form_puffer.d[$0d])^;
    laenge_ausgepackt:=-1;
    archiv_datei;
    exezk:=erzeuge_neuen_dateinamen('.IMG');
    archiv_datei_ausschrift(exezk);
    befehl_ttdecomp(analyseoff+$314+$21,laenge_eingepackt,erzeuge_neuen_dateinamen('.IMG'));
    archiv_summe;
  end;


procedure compaq_install_pe_4;
  var
    o,wo                :dateigroessetyp;
    anzahl_dateien      :word_norm;
  begin
    (* inflate 1.1.2 *)
    (* SP16035.EXE *)
    ausschrift('CPT Install / Compaq',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=$928;
    (* Titel *)
    ansi_anzeige(analyseoff+o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch,
        analyseoff+o+$200,'');
    IncDGT(o,$200);
    (* Zielverzeichnis *)
    ansi_anzeige(analyseoff+o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch,
        analyseoff+o+$100,'');
    IncDGT(o,$100);
    (* softpaqname *)
    IncDGT(o,$100);

    anzahl_dateien:=x_longint__datei_lesen(analyseoff+o);
    IncDGT(o,4);
    wo:=analyseoff+o+anzahl_dateien*($100+$10);
    while anzahl_dateien>0 do
      begin
        Dec(anzahl_dateien);
        datei_lesen(form_puffer,analyseoff+o,$100+$10);
        IncDGT(o,$100+$10);
        IncDGT(wo,4);
        laenge_eingepackt:=x_longint__datei_lesen(wo);
        IncDGT(wo,4);
        laenge_ausgepackt:=longint_z(@form_puffer.d[$00])^;
        archiv_datei;
        exezk:=puffer_zu_zk_e(form_puffer.d[4],#0,255);
        archiv_datei_ausschrift(exezk);
        (* entpackte grî·ere Dateien sind fehlerhaft!
        befehl_e_infla(wo+2,laenge_eingepackt-2-4,exezk); *)
        IncDGT(wo,laenge_eingepackt);
      end;
    archiv_summe;
  end;

procedure rompaq;
  var
    o                   :longint;
    zaehler             :word_norm;
  begin
    ausschrift('RomPaq / Compaq [PKWARE-LIB]',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    zaehler:=0;
    repeat
      Inc(zaehler);
      datei_lesen(form_puffer,analyseoff+o,$48);
      Inc(o,$48);
      laenge_ausgepackt:=-1;
      laenge_eingepackt:=longint_z(@form_puffer.d[$3f])^;
      if laenge_eingepackt=0 then
        laenge_eingepackt:=DGT_zu_longint(einzel_laenge-o);
      archiv_datei;
      exezk:=puffer_zu_zk_e(form_puffer.d[12],#0,7)+'.'+str0(zaehler);
      archiv_datei_ausschrift(exezk+' '
                             +puffer_zu_zk_e(form_puffer.d[$14],#0,40)+' '
                             +hex_word(word_z(@form_puffer.d[$08])^));
      befehl_ttdecomp(analyseoff+o,laenge_eingepackt,exezk);
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe_ausgepackt:=x_longint__datei_lesen(analyseoff);
    archiv_summe_ausgepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure wps_backup(const p:puffertyp);
  var
    o                   :longint;
    zaehler             :word_norm;
  begin
    ausschrift(puffer_zu_zk_e(p.d[0],#0,20)+' / Dave Lester',packer_dat);
    if not langformat then exit;

    o:=$12c;
    zaehler:=0;
    archiv_start;
    repeat
      Inc(zaehler);
      datei_lesen(form_puffer,analyseoff+o,$10);
      Inc(o,$10);
      laenge_ausgepackt:=longint_z(@form_puffer.d[$08])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$0c])^;
      archiv_datei;
      exezk:=hex_longint(zaehler);
      archiv_datei_ausschrift(exezk);
      befehl_e_infla(analyseoff+o+4,laenge_eingepackt,exezk);
      Inc(o,laenge_eingepackt);
    until o+$10>=einzel_laenge;
    archiv_summe;

  end;

procedure installshield_18000;
  var
    o:longint;
    anzahl:longint;
  begin
    (* "Setup launcher", auch bei $31000-vmware *)
    ausschrift('<"InstallShield"/18000>',packer_dat);
    if not langformat then exit;

    anzahl:=x_longint__datei_lesen(analyseoff+$e);
    o:=$2e;
    archiv_start;
    repeat
      Dec(anzahl);
      datei_lesen(form_puffer,analyseoff+o,$138);
      Inc(o,$138);
      laenge_ausgepackt:=longint_z(@form_puffer.d[$10c])^;
      laenge_eingepackt:=laenge_ausgepackt;
      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,$100);
      archiv_datei;
      befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
      if (form_puffer.d[$104] and $2)<>0 then
        begin
          befehl_isssldeco(exezk);
          exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
          exezk_anhaengen(' [ror4/xor]');
        end;
      archiv_datei_ausschrift(exezk);
      Inc(o,laenge_eingepackt);
    until (o>=einzel_laenge) or (anzahl<=0);
    archiv_summe;
  end;

procedure iconease_dat_130;
  var
    o                   :longint;
    anzahl              :word_norm;
  begin
    ausschrift('IconEase / Dave Lester [1.30]',musik_bild);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    anzahl:=x_longint__datei_lesen(o);
    Inc(o,4);
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,$28);
        laenge_eingepackt:=longint_z(@form_puffer.d[$24])^;
        laenge_ausgepackt:=x_longint__datei_lesen(analyseoff+longint_z(@form_puffer.d[$20])^);
        archiv_datei;
        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,$20)+'.ICO');
        Inc(o,$28);
        Dec(anzahl);
      end;
    archiv_summe;

  end;

procedure versuche_sbc(const p:puffertyp);
  const
    beta_zk             :array[boolean] of string[1]=('','b');
    (*funktioniert nur mit Version 0.310b
    sbc_alg:array[1..7] of string[2]=('cb','cc','ct','cr','cs','?','p');*)
  var
    version             :word;
    beta                :boolean;
  begin
    if textdatei then Exit;

    version:=m_word(p.d[3]) shr 3;
    beta:=((version and $1000)<>0);
    version:=version and $fff;

    if (version>2000) then Exit;
    (* 903d "beta" hat aber kein Beta-Bit *)
    if (version< 800) and (not beta) then Exit;


    (*if p.d[4] and $f in [1..7] then
      exezk:=sbc_alg[p.d[4] and $f]
    else
      exezk:='?';*)

    (* VerschlÅsselungsmethode *)
    if version<1000 then
      if not (p.d[4] and $f) in [1..7] then Exit;

    (* Anzeiger der Dateinamen nicht mîglich *)
    (* Version 0.310 *)
    ausschrift('SBC / Sami J. MÑkinen ['+str0(version div 1000)+'.'+strx(version mod 1000,3)+beta_zk[beta]+']',packer_dat);
    (* sicherlich nie *)
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
  end;


procedure MacBinary(const p:puffertyp);
  var
    i                   :word_norm;
    o                   :longint;
    hersteller_vorhanden:boolean;
  begin

    (* Kennung prÅfen *)
    hersteller_vorhanden:=true;
    for i:=$41 to $41+8-1 do
      if p.d[i] in [$00..$1f,$7f..$ff] then
        begin
          hersteller_vorhanden:=false;
          Break;
        end;

    if  (not hersteller_vorhanden)
    and (not bytesuche(p.d[$66],'mBIN')) then
      Exit;


    (* LÑngenangaben prÅfen *)
    laenge_ausgepackt:=m_longint(p.d[$53]);
    if (laenge_ausgepackt<0) or (laenge_ausgepackt>einzel_laenge) then Exit;
    o:=$80+laenge_ausgepackt;

    laenge_ausgepackt:=m_longint(p.d[$57]);
    if laenge_ausgepackt<>0 then
      o:=(o and -$80)+$80;
    if (laenge_ausgepackt<0) or (laenge_ausgepackt>einzel_laenge) then Exit;

    if o>einzel_laenge then Exit;



    exezk:=puffer_zu_zk_pstr(p.d[1]);
    exezk_in_doppelten_anfuerungszeichen;
    if hersteller_vorhanden then
      Insert('['+puffer_zu_zk_l(p.d[$41],4)+'/'+puffer_zu_zk_l(p.d[$45],4)+'] ',exezk,1);

    ausschrift('MacBinary '+textz_datx__kopf^+' '+exezk,packer_dat);

    (***************************************************************)
    archiv_start_leise;

    laenge_ausgepackt:=m_longint(p.d[$53]);
    laenge_eingepackt:=laenge_ausgepackt;
    archiv_datei;
    archiv_datei_ausschrift('Data ');

    laenge_ausgepackt:=m_longint(p.d[$57]);
    laenge_eingepackt:=laenge_ausgepackt;
    archiv_datei;
    dec(archiv_summen_dateien);
    archiv_datei_ausschrift('Rsrc ');

    archiv_summe_leise;
    (***************************************************************)

    if bytesuche(p.d[$41],'PNTG') then
      begin
       (* MACBEST2.ZIP\*.pic *)
       ausschrift('MacBinary '+textz_datx__Kopf_plus_Bild^+' MacPaint "'+puffer_zu_zk_pstr(p.d[1])+'"',musik_bild);
     end;

    einzel_laenge:=$80;
    o:=$80;

    if m_longint(p.d[$53])<>0 then
      begin
        exezk:=trenne_pfad_ab(puffer_zu_zk_pstr(p.d[1])+'.data');
        befehl_schnitt(analyseoff+o,m_longint(p.d[$53]),exezk);
        Inc(o,m_longint(p.d[$53]));
        merke_position(analyseoff+o,datentyp_unbekannt);
      end;

    if ((o and $7f)<>0) and (m_longint(p.d[$57])<>0) then
      begin
        o:=(o and -$80)+$80;
        merke_position(analyseoff+o,datentyp_unbekannt);
      end;

    if m_longint(p.d[$57])<>0 then
      begin
        exezk:=trenne_pfad_ab(puffer_zu_zk_pstr(p.d[1])+'.rsrc');
        befehl_schnitt(analyseoff+o,m_longint(p.d[$57]),exezk);
        Inc(o,m_longint(p.d[$57]));
        merke_position(analyseoff+o,datentyp_unbekannt);
      end;
  end;

procedure foxpatchf(const p:puffertyp);
  begin (* 3COM Netzwerkkarte: 3c90xx.exe\DISK1\MSUPDATE\EMM386.* *)
    ausschrift('FoxPatch / MS',packer_dat);
    if not langformat then exit;

    archiv_start;
    laenge_ausgepackt:=longint_z(@p.d[$e])^; (* ZiellÑnge? oder erwartete LÑnge ($a?) *)
    laenge_eingepackt:=longint_z(@p.d[$6])^;
    archiv_datei;
    archiv_datei_ausschrift(puffer_zu_zk_e(p.d[$34],#0,80));
    archiv_summe;
  end;

procedure nullsoft_inst_x(const p:puffertyp;ver,offs,extra:word_norm);
  begin
    (* 1                1.32,1.44 *)

    ausschrift('Nullsoft Install System Development Kit [inflate 1.1.3] <'+str0(ver)+'>',packer_dat);

    einzel_laenge:=longint_z(@p.d[offs])^+extra;
    if ver=3 then
      begin
        exezk:=puffer_zu_zk_e(p.d[offs+4],#0,$80);
        exezk_in_doppelten_anfuerungszeichen;
        ausschrift_x(exezk,beschreibung,absatz);
      end;
    if not langformat then Exit;

    (* ich mÅ·te inflate einbauen *)
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
  end;

procedure nullsoft_pimp(const p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('Nullsoft PIMP Install System [inflate]',packer_dat); (* 1.3 *)
    exezk:=puffer_zu_zk_e(p.d[9],#0,$80);
    exezk_von1250;
    exezk_in_doppelten_anfuerungszeichen;
    ausschrift_x(exezk,beschreibung,absatz);
    exezk:=puffer_zu_zk_e(p.d[$89],#0,$80);
    exezk_von1250;
    exezk_in_doppelten_anfuerungszeichen;
    ausschrift_x(exezk,beschreibung,absatz);
    if not langformat then Exit;

    archiv_start;
    o:=$109;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      exezk:=puffer_zu_zk_e(form_puffer.d[$c],#0,form_puffer.d[$8]);
      Inc(o,$c+longint_z(@form_puffer.d[$8])^);
      laenge_eingepackt:=x_longint__datei_lesen(analyseoff+o);
      if laenge_eingepackt=0 then
        laenge_ausgepackt:=0
      else
        laenge_ausgepackt:=x_longint__datei_lesen(analyseoff+o+4);
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      (* das jetzige e_infla produziert endlos gro·e Dateien! *)
      if laenge_eingepackt>8+2 then
        befehl_e_infla(analyseoff+o+8+2,laenge_eingepackt-8-2,exezk);
      Inc(o,laenge_eingepackt);
    until (o>=einzel_laenge) or (o<0);
    archiv_summe;
  end;

procedure semtex_xfilelib(e:longint);
  var
    o:longint;
  begin
    ausschrift('"XFILELIB" Semtex / Phobyx Creativ Labs',musik_bild);
    if not langformat then Exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,270);
      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
      Inc(o,Length(exezk)+1+4);
      laenge_eingepackt:=longint_z(@form_puffer.d[Length(exezk)+1])^;
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
      Inc(o,laenge_eingepackt);
    until o>=e;
    archiv_summe;

  end;

procedure aplib(const p:puffertyp);
  begin
    if longint_z(@p.d[4])^=$18 then
      begin
        ausschrift('aPLib / Joergen Ibsen <safe>',packer_dat);
        if not langformat then Exit;

        archiv_start_leise;

        laenge_eingepackt:=longint_z(@p.d[8])^;
        laenge_ausgepackt:=longint_z(@p.d[16])^;
        archiv_datei;
        archiv_datei_ausschrift('?');

        archiv_summe_leise;

      end
    else
      ausschrift('aPackage SFX / Joergen Ibsen',packer_dat);

  end;


procedure atheos(const p:puffertyp);

  procedure atheos_bloecke(const pfad:string;var o:dateigroessetyp;e:dateigroessetyp);
    var
      blockname:string;
    begin

      while o<e do
        begin

          datei_lesen(form_puffer,analyseoff+o,260);

          if longint_z(@form_puffer.d[0])^=$ffffffff then
            begin
              (*ausschrift('                 '+pfad+'..',packer_dat);*)
              IncDGT(o,4);
              Break;
            end

          else
          case longint_z(@form_puffer.d[0])^ shr 12 of
            (* Verzeichnis *)
            $4: (* $000041a4  0100 000 110 100 100 *)
                (* $000041ed  0100 000 111 101 101 *)
              begin
                blockname:=puffer_zu_zk_pstr(form_puffer.d[4]);
                IncDGT(o,4+1+form_puffer.d[4]);
                befehl_mkdir(pfad+blockname);
                atheos_bloecke(pfad+blockname+'\',o,e);
              end;

            (* Datei *)
            $8: (* $000081a4  1000 000 110 100 100 *)
                (* $000081c9  1000 000 111 001 001 *)
                (* $000081ed  1000 000 111 101 101 *)
              begin
                blockname:=puffer_zu_zk_pstr(form_puffer.d[4]);
                IncDGT(o,4+1+form_puffer.d[4]);
                laenge_ausgepackt:=x_longint__datei_lesen(analyseoff+o);
                laenge_eingepackt:=laenge_ausgepackt;
                IncDGT(o,4);
                archiv_datei;
                archiv_datei_ausschrift(pfad+blockname);
                befehl_schnitt(analyseoff+o,laenge_eingepackt,pfad+blockname);
                IncDGT(o,laenge_eingepackt);
              end;

            (* Dateiverweis *)
            $a: (* $0000a1ff  1010 000 111 111 111 *)
              begin
                blockname:=puffer_zu_zk_pstr(form_puffer.d[4]);
                IncDGT(o,4+1+form_puffer.d[4]);
                laenge_ausgepackt:=x_longint__datei_lesen(analyseoff+o);
                laenge_eingepackt:=laenge_ausgepackt;
                IncDGT(o,4);
                exezk:='';
                if laenge_eingepackt<80 then
                  exezk:=datei_lesen__zu_zk_l(analyseoff+o,laenge_eingepackt);
                archiv_datei;
                archiv_datei_ausschrift(pfad+blockname+' -> '+exezk);
                befehl_schnitt(analyseoff+o,laenge_eingepackt,pfad+blockname);
                IncDGT(o,laenge_eingepackt);
              end;


          else
            ausschrift('? ['+hex_longint(longint_z(@form_puffer.d[0])^)+']',dat_fehler);
            o:=einzel_laenge;
          end; (* case *)

        end; (* while *)
    end;

  var
    o:dateigroessetyp;

  begin
    (* sinnvoller Name? *)
    if (p.d[4]<1) or (p.d[4]>80) then
      Exit;
    if not ist_ohne_steuerzeichen(puffer_zu_zk_pstr(p.d[4])) then
      Exit;

    ausschrift('<?/atheos>',packer_dat);
    if not langformat then Exit;

    o:=0;
    archiv_start;
    atheos_bloecke('',o,einzel_laenge);
    archiv_summe;
  end;


procedure bioarc;
  var
    o,kopflaenge        :dateigroessetyp;
    w                   :word_norm;
  begin
    ausschrift('BioArc / Merlin+',packer_dat); (* 1.92 *)
    if not langformat then Exit;

    o:=9;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      kopflaenge:=longint_z(@form_puffer.d[5])^;
      case form_puffer.d[2] of
        $00: (* Archivkopf *)
          begin
            (* Kommentar ... *)
            kopflaenge:=longint_z(@form_puffer.d[3])^-2;
          end;
        $01: (* Datei *)
          begin
            (*$IfDef dateigroessetyp_comp*)
            laenge_eingepackt64:=comp_z(@form_puffer.d[$09])^; (* 64 Bit *)
            laenge_ausgepackt64:=comp_z(@form_puffer.d[$11])^; (* 64 Bit *)
            (*$Else dateigroessetyp_comp*)
            if longint_z(@form_puffer.d[$09+4])^=0 then
              laenge_eingepackt64:=longint_z(@form_puffer.d[$09])^
            else
              laenge_eingepackt64:=-1;
            if longint_z(@form_puffer.d[$11+4])^=0 then
              laenge_ausgepackt64:=longint_z(@form_puffer.d[$11])^
            else
              laenge_ausgepackt64:=-1;
            (*$EndIf dateigroessetyp_comp*)
            archiv_datei64;
            w:=Min(word_z(@form_puffer.d[$29])^,255);
            exezk:=datei_lesen__zu_zk_l(analyseoff+o+$35,w);
            exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);

            (* sehr RAR-Ñhnlich *)
            if (form_puffer.d[$03] and 4)=4 then
              exezk_anhaengen(textz_form__eckauf_Kennwort_eckzu^);

            if (form_puffer.d[$03] and 1)=1 then
              exezk_anhaengen(textz_form__leer_eckauf_Fortsetzung_eckzu^);
            if (form_puffer.d[$03] and 2)=2 then
              exezk_anhaengen(textz_form__leer_eckauf_Bruchstueck_eckzu^);

            if (form_puffer.d[$03] and $10)=$10 then
              archiv_datei_ausschrift_verzeichnis(exezk)
            else
              archiv_datei_ausschrift(exezk);
            (* Kommentar ... *)
            IncDGT(kopflaenge,laenge_eingepackt64);
          end;
        $02: (* Kommentar *)
          ;
        $03: (* subblock *)
          ;
        $04: (* recovery record *)
          ausschrift(textz_form__ecc_^,packer_dat);
        $05: (* authenticity information *)
          ausschrift(textz_form__Echtheitszertifikat^,packer_dat);
      else
        ausschrift_x('?',packer_dat,absatz);
      end;
      IncDGT(o,kopflaenge);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure animated_system_design;
  var
    o,verzeichnis_ende:longint;
  begin

    (* Word Perfect 6 DEMO "Animated Systems&Design"  *)
    ausschrift('Creative Bridge Animation Tools / dsp Ltd/ASDI',packer_dat);
    if not langformat then Exit;

    archiv_start;
    verzeichnis_ende:=x_longint__datei_lesen(analyseoff+$e);
    o:=$0;
    while o<verzeichnis_ende do
      begin
        datei_lesen(form_puffer,analyseoff+o,$12);
        if longint_z(@form_puffer.d[$e])^=0 then Break; (* leerer Eintrag *)
        laenge_eingepackt:=word_z(@form_puffer.d[$0c])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,8+1+3);
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+longint_z(@form_puffer.d[$e])^,laenge_eingepackt,exezk);
        Inc(o,$12);
      end;
    archiv_summe;

  end;

procedure packer_IH;
  var
    o           :longint;
    anzahl      :word_norm;
  begin
    ausschrift('Packer / IH software',packer_dat);
    if not langformat then exit;

    archiv_start;
    anzahl:=x_word__datei_lesen(analyseoff+$21);
    o:=$23;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,1+8+1+3+4+4);
        laenge_eingepackt:=longint_z(@form_puffer.d[$0d])^;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+longint_z(@form_puffer.d[$11])^,laenge_eingepackt,exezk);
        Dec(anzahl);
        Inc(o,1+8+1+3+4+4);
      end;
    archiv_summe;
  end;

procedure tshtsh_daniel_valot;
  var
    o                   :dateigroessetyp;
    l,lb                :longint;
    plus4_2002          :word_norm;
    w1                  :word_norm;
  begin
    plus4_2002:=0;
    datei_lesen(form_puffer,analyseoff+einzel_laenge-$32,$32);
    if bytesuche(form_puffer.d[0],'Copyright Daniel F Valot ??????TSHTSH - 1991-') then
      begin
        DecDGT(einzel_laenge,$32);
        exezk:=puffer_zu_zk_l(form_puffer.d[$32-5],4);
        if val_f(exezk)<2002 then
          plus4_2002:=0
        else
          plus4_2002:=4;
      end;

    ausschrift('Ardi unpacker "DVISU" / Daniel F Valot',packer_dat);
    if not langformat then Exit;


    archiv_start;
    o:=analyseoff+einzel_laenge-4;
    l:=x_longint__datei_lesen(o);
    DecDGT(o,l);

    while o>0 do
      begin
        (*ausschrift(hex_dgt(o),normal);*)

        lb:=Min(255,l);
        if lb>4 then
          Dec(lb,4)
        else
          lb:=0;
        datei_lesen(form_puffer,o,512);

        if bytesuche(form_puffer.d[4+1],'V4') then (* Dateien *)
          case Chr(form_puffer.d[4+0]) of
            'w': (* Kopf *)
              begin
                laenge_ausgepackt:=-1;
                laenge_eingepackt:=-1; (* eigentlich das nachfolgende (vorhergehende l) *)
                archiv_datei;

                exezk:=puffer_zu_zk_e(form_puffer.d[8+plus4_2002],#0,lb);
                w1:=Pos('!',exezk);
                if w1<>0 then
                  begin
                    exezk:=Copy(exezk,1,w1-1);
                    exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
                    exezk:=exezk+in_doppelten_anfuerungszeichen(
                      puffer_zu_zk_e(form_puffer.d[8+plus4_2002+w1+1],#0,lb));
                  end
                else
                  exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);

                archiv_datei_ausschrift(exezk);
              end;
            'x':; (* Daten *)
          else
                ausschrift('? '+in_doppelten_anfuerungszeichen(
                  puffer_zu_zk_l(form_puffer.d[4],lb)),dat_fehler);
          end

        else
        if bytesuche(form_puffer.d[4],#$22#$11#$22#$11) (* Pfad *)
        or bytesuche(form_puffer.d[4],#$97#$97#$97#$97) (* Titel *)
         then
          begin
            ausschrift(in_doppelten_anfuerungszeichen(
              puffer_zu_zk_e(form_puffer.d[8],#$00,lb)),beschreibung);
          end

        else
        if bytesuche(form_puffer.d[4],#$12#$12#$12#$12) (* Kurzbeschreibung *)
         then
          begin
            ausschrift(in_doppelten_anfuerungszeichen(
              puffer_zu_zk_e(form_puffer.d[8],#$1a,lb)),beschreibung);
          end

        else
        if bytesuche(form_puffer.d[4],#$13#$13#$13#$13) (* Lizenz *)
         then
          begin
            ansi_anzeige(o+8,#$1a,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch,
              o+l-4,'');
          end


        else
          ausschrift('? '+in_doppelten_anfuerungszeichen(
            puffer_zu_zk_l(form_puffer.d[4],lb)),dat_fehler);

        l:=longint_z(@form_puffer.d[0])^;
        DecDGT(o,l);
        if (l<=0) or (l>einzel_laenge) then
        Break;
      end;
    archiv_summe;

  end;

procedure ardi;
  var
    z,k,s:word_norm;
  begin
    ausschrift('DSK4PM "ARDI" / Daniel F Valot',packer_dat);
    if not langformat then Exit;

    archiv_start;
    datei_lesen(form_puffer,analyseoff,$24);
    laenge_eingepackt:=DGT_zu_longint(einzel_laenge);
    laenge_ausgepackt:=word_z(@form_puffer.d[0])^  (* 512  *)
                      *word_z(@form_puffer.d[8])^; (* 2880 *)
    archiv_datei;
    s:=Max(1,form_puffer.d[13]);
    k:=Max(1,form_puffer.d[15]);
    z:=word_z(@form_puffer.d[8])^ div (s*k);
    exezk:='A: ['+str0(z)+'/'+str0(k)+'/'+str0(s)+']';
    archiv_datei_ausschrift(exezk);
    archiv_summe;

  end;

procedure smartsetup;
  var
    o,oe                :dateigroessetyp;
    dateityp            :word_norm;
  begin
    (* Format:
       LX EXE
       BZIP2: INFO
       BZIP2: FILE
       BZIP2: OBJE =$14*3 (INFO,FILE,OBJE)
       PACK -> OBJE                             *)



    if einzel_laenge=$14 then
      begin
        ausschrift('SmartSetup / OS2.Ru DevTeam',packer_dat);
        Exit;
      end;

    merke_position(analyseoff+einzel_laenge-$14,datentyp_unbekannt);
    datei_lesen(form_puffer,analyseoff+einzel_laenge-$14,$14);
    oe:=longint_z(@form_puffer.d[4])^;
    merke_position(oe,datentyp_unbekannt);
    if langformat then
      begin
        o:=analyseoff;
        repeat (* scheint auch falsche Blîcke zu finden... *)
          IncDGT(o,4);
          o:=datei_pos_suche(o,oe-4,'BZh?1A');
          if o=nicht_gefunden then Break;
          merke_position(o,datentyp_unbekannt);
        until o>=oe-4;
      end;
    bestimme_naechste_einzellaenge(analyseoff,einzel_laenge,dateityp);
  end;

procedure bzip2;
  begin
    if einzel_laenge>$14 then
      begin
        datei_lesen(form_puffer,analyseoff+einzel_laenge-$14,$14);
        if bytesuche(form_puffer.d[0],'PACK??????'#$00#$00'??'#$00#$00'?'#$00#$00#$00) then
          smartsetup;
      end;

    ausschrift('BZIP2 / Julian Seward [0.9.0c]',packer_dat);
    if analyseoff>0 then
      befehl_bzip2_d(analyseoff,einzel_laenge,erzeuge_kurzen_dateinamen+'.BZ2.'+hex_DGT(analyseoff));
  end;

procedure clickteam;
  var
    o:longint;
  begin
    ausschrift('Install Maker / Clickteam',packer_dat); (* [1999] *)
    if not langformat then Exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      case word_z(@form_puffer.d[0])^ of
      (* $1242:    1. Datenblock
         $1234:    4 Byte                       *)
         $1235, (* Zielpfad                     *)
         $1238, (* Titel                        *)
         $1239: (* Titel ?                      *)
          ausschrift(puffer_zu_zk_e(form_puffer.d[$f],#0,80),beschreibung);
     (* $1246:    34 byte
        $1236:    3KB, vielleicht ein Bild
        $1237:    2KB, vielleicht ein Bild
        $123a:    3KB, vielleicht ein Bild
        $1243:    1KB, ?                        *)

         $7f7f: (* Daten *)
           begin
             laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
             laenge_ausgepackt:=-1;
             archiv_datei;
             archiv_datei_ausschrift('?');
           end;

         $0f1b:;(* Ende                         *)
      (*
      else
        ausschrift('? '+hex_longint(longint_z(@form_puffer.d[0])^)+' , '+str0(longint_z(@form_puffer.d[4])^),normal);*)
      end;
      Inc(o,8+longint_z(@form_puffer.d[4])^);
    until o+8>=einzel_laenge;
    archiv_summe;
  end;

procedure archivefile;

  function n83(const s:string):string;
    var
      tmp:string;
    begin
      tmp:=leer_filter(copy(s,1,8))+'.'+leer_filter(copy(s,9,3));
      if tmp='.' then tmp:='';
      n83:=tmp;

    end;

  function l83(const s:string):string;
    begin
      l83:=leer_filter(copy(s,1,8+3));
    end;

  var
    o:longint;

  begin
    ausschrift('ArchiveFile / Veit Kannegieser',packer_dat);
    if not langformat then Exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      case form_puffer.d[4] of
        0: (* bt_header *)
          begin
            exezk:=puffer_zu_zk_pstr(form_puffer.d[5]);
            zeichenfilter(exezk);
            ausschrift_x(exezk,beschreibung,leer);
          end;

        1: (* bt_nextpack *)
          begin
            exezk:=n83(puffer_zu_zk_l(form_puffer.d[5],8+3));
            if exezk<>'' then
              ausschrift('-> '+exezk,normal);
          end;

        2: (* bt_file *)
          begin
            exezk:=n83(puffer_zu_zk_l(form_puffer.d[5],8+3));
            laenge_eingepackt:=longint_z(@form_puffer.d[5+8+3])^;
            laenge_ausgepackt:=longint_z(@form_puffer.d[5+8+3+4])^;
            archiv_datei;
            archiv_datei_ausschrift(exezk);
          end;

        3: (* bt_output *)
          begin
            exezk:=puffer_zu_zk_e(form_puffer.d[5],#0,256);
            if Pos(^m^j,exezk)=Length(exezk)-1 then
              Delete(exezk,Length(exezk)-1,2);
            ausschrift_x(exezk,beschreibung,vorne);
          end;

        4: (* bt_sector *)
          begin
            ausschrift('boot sector ...',packer_dat);
          end;

        5: (* bt_volume *)
          begin
            exezk:=l83(puffer_zu_zk_l(form_puffer.d[5],8+3));
            ausschrift('label '+exezk,packer_dat);
          end;

        6: (* bt_delete *)
          begin
            exezk:=n83(puffer_zu_zk_l(form_puffer.d[5],8+3));
            ausschrift('delete '+exezk,packer_dat);
          end;

        7: (* bt_requestdisk *)
          begin
            exezk:=l83(puffer_zu_zk_l(form_puffer.d[5],8+3));
            ausschrift('requestdisk '+exezk,packer_dat);
          end;
      else
        ausschrift('?',packer_dat);
      end;
      Inc(o,longint_z(@form_puffer.d[0])^);
    until o>=einzel_laenge;
    archiv_summe;
  end;


procedure disketten_abzugsdatei_fat(zylinder,sektoren_je_spur,anzahl_koepfe:word_norm);
  var
    clustergroesse              :word_norm;
    fat_sektor                  :longint;
    fatbit                      :byte;
    hauptverzeichniseintraege   :word_norm;
    hauptverzeichnis_sektor     :longint;
    datenstart_position         :longint;
    anzahl_sektoren             :longint;
    media_byte                  :byte;

  function berechne_sektor(c:longint):longint;
    begin
      berechne_sektor:=datenstart_position+(c-2)*clustergroesse;
    end;

  function folgecluster(c:longint):longint;
    var
      w:word;
    begin
      case fatbit of
        12:
          begin
            datei_lesen(form_puffer,analyseoff+fat_sektor*512+((c*3) shr 1),2);
            w:=word_z(@form_puffer.d[0])^;
            if Odd(c) then w:=w shr 4;
            w:=w and $0fff;
            if w>=$ff1 then w:=w or $f000;
            folgecluster:=w;
          end;
        16:
          begin
            datei_lesen(form_puffer,analyseoff+fat_sektor*512+c*2,2);
            folgecluster:=word_z(@form_puffer.d[0])^;
          end;
        32:
          begin
            datei_lesen(form_puffer,analyseoff+fat_sektor*512+c*4,4);
            folgecluster:=longint_z(@form_puffer.d[0])^;
          end;
      end;

    end;



  procedure verzeichnis(tiefe:word_norm;const pfad:string;clusternummer,sektornummer,anzahl_eintraege:word_norm);
    var
      i                         :word;
      verzeichnis_oder_dateiname:string[12];

    procedure berechne_verzeichnis_oder_dateiname;
      begin
        verzeichnis_oder_dateiname:=leer_filter(puffer_zu_zk_l(form_puffer.d[$0],8))+'.'
                                   +leer_filter(puffer_zu_zk_l(form_puffer.d[$8],3));
        while (verzeichnis_oder_dateiname<>'')
          and (verzeichnis_oder_dateiname[Length(verzeichnis_oder_dateiname)] in ['.',' ']) do
            Delete(verzeichnis_oder_dateiname,Length(verzeichnis_oder_dateiname),1);
      end;

    begin
      if tiefe>20 then Exit;

      repeat
        if clusternummer<>0 then
          begin
            sektornummer:=berechne_sektor(clusternummer);
            anzahl_eintraege:=clustergroesse*16; (* *512/32 *)
          end;


        i:=0;
        repeat
          datei_lesen(form_puffer,analyseoff+sektornummer*512+i,$20);
          Inc(i,$20);
          Dec(anzahl_eintraege);
          if form_puffer.g<>$20 then Exit; (* Lesefehler *)
          if form_puffer.d[0]=0 then Exit; (* Verzeichnisende *)
          if form_puffer.d[0]=$e5 then Continue; (* gelîscht *)
          if bytesuche(form_puffer.d[0],'. ')
          or bytesuche(form_puffer.d[0],'.. ') then Continue;

          if (form_puffer.d[$b] and $08)=$08 then (* volume label *)
            begin
              if pfad<>'' then Continue;

              if (form_puffer.d[$b] and $02)=$02 then (* versteckt? -> windows mÅll *)
                Continue;
              exezk:=puffer_zu_zk_e(form_puffer.d[$0],#0,8+3);
              exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
              laenge_eingepackt:=0;
              laenge_ausgepackt:=0;
              archiv_datei;
              archiv_datei_ausschrift_label(pfad+exezk);
            end

          else
          if (form_puffer.d[$b] and $10)=$10 then (* Verzeichnis *)
            begin
              berechne_verzeichnis_oder_dateiname;
              exezk:=verzeichnis_oder_dateiname;
              exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
              laenge_eingepackt:=0;
              laenge_ausgepackt:=0;
              archiv_datei;
              archiv_datei_ausschrift_verzeichnis(pfad+exezk);
              if fatbit=32 then
                verzeichnis(tiefe+1,
                            pfad+verzeichnis_oder_dateiname+'\',
                            word_z(@form_puffer.d[$1a])^+word_z(@form_puffer.d[$14])^ shl 16,
                            0,0)
              else
                verzeichnis(tiefe+1,pfad+verzeichnis_oder_dateiname+'\',word_z(@form_puffer.d[$1a])^,0,0);
            end

          else (* Datei *)
            begin
              berechne_verzeichnis_oder_dateiname;
              exezk:=verzeichnis_oder_dateiname;
              exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
              laenge_eingepackt:=longint_z(@form_puffer.d[$1c])^;
              laenge_ausgepackt:=laenge_eingepackt;
              archiv_datei;
              archiv_datei_ausschrift(pfad+exezk);
            end;

        until anzahl_eintraege=0;

        if clusternummer=0 then Break;
        clusternummer:=folgecluster(clusternummer);
      until (clusternummer<2)
         or ((clusternummer>=    $fff1) and (fatbit<=16))
         or ((clusternummer>=$0ffffff1) and (fatbit =32));
    end;

  begin
    datei_lesen(form_puffer,analyseoff+0,512);
    if bytesuche(form_puffer.d[$52],'FAT32') then
      begin
        if word_z(@form_puffer.d[$b])^<>512 then Exit; (* Byte je Sektor *)
        clustergroesse:=form_puffer.d[$d];
        if (clustergroesse<1) or (clustergroesse>64) then Exit;
        fat_sektor:=word_z(@form_puffer.d[$e])^;
        hauptverzeichniseintraege:={word_z(@form_puffer.d[$11])^}512;
        if not (form_puffer.d[$10] in [1,2]) then Exit; (* FAT-Anzahl *)
        media_byte:=byte__datei_lesen(analyseoff+fat_sektor*512+0);
        (* F0 auf super virtual disk
        if (media_byte and $f8)<>$f8 then Exit;*)
        if (media_byte<>0) and ((media_byte and $f0)<>$f0) then Exit;
        datenstart_position:=fat_sektor+form_puffer.d[$10]*word_z(@form_puffer.d[$24])^;
        hauptverzeichnis_sektor:=berechne_sektor(longint_z(@form_puffer.d[$2c])^);
        anzahl_sektoren:=longint_z(@form_puffer.d[$20])^;
        fatbit:=32;
      end
    else
      begin
        (* FAT 12/16 *)

        if word_z(@form_puffer.d[$b])^<>512 then Exit; (* Byte je Sektor *)
        clustergroesse:=form_puffer.d[$d];
        if (clustergroesse<1) or (clustergroesse>64) then Exit;
        fat_sektor:=word_z(@form_puffer.d[$e])^;
        hauptverzeichniseintraege:=word_z(@form_puffer.d[$11])^;
        if not (form_puffer.d[$10] in [1,2]) then Exit; (* FAT-Anzahl *)
        media_byte:=byte__datei_lesen(analyseoff+fat_sektor*512+0);
        (* F0 auf super virtual disk
        if (media_byte and $f8)<>$f8 then Exit;*)
        if (media_byte<>0) and ((media_byte and $f0)<>$f0) then Exit;
        hauptverzeichnis_sektor:=fat_sektor+form_puffer.d[$10]*word_z(@form_puffer.d[$16])^;
        datenstart_position:=hauptverzeichnis_sektor+hauptverzeichniseintraege shr 4;

        anzahl_sektoren:=word_z(@form_puffer.d[$13])^;
        if anzahl_sektoren=0 then anzahl_sektoren:=longint_z(@form_puffer.d[$20])^;
        if (anzahl_sektoren-datenstart_position) div clustergroesse<$ff1 then
          fatbit:=12
        else
          fatbit:=16;
      end;

    ausschrift('FAT'+str0(fatbit),packer_dat);

    archiv_start;
    verzeichnis(0,'',0,hauptverzeichnis_sektor,hauptverzeichniseintraege);
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure windows_clp;
  var
    anzahl      :word_norm;
    o           :longint;
  begin
    ausschrift('CLPBRD.EXE / MS',musik_bild);
    if not langformat then exit;

    archiv_start;
    o:=2;
    anzahl:=x_word__datei_lesen(analyseoff+o);
    Inc(o,2);
    while (anzahl>0) and (o<einzel_laenge) do
      begin
        Dec(anzahl);
        datei_lesen(form_puffer,analyseoff+o,10+79);
        Inc(o,10+79);
        laenge_eingepackt:=longint_z(@form_puffer.d[2])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        exezk:=puffer_zu_zk_e(form_puffer.d[10],#0,79);
        if Pos('&',exezk)=1 then Delete(exezk,1,Length('&'));
        exezk:=str0(word_z(@form_puffer.d[0])^)+'.'+exezk;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(longint_z(@form_puffer.d[6])^,laenge_eingepackt,erzeuge_neuen_dateinamen('.'+exezk));
      end;
    archiv_summe;
  end;

procedure inno_setup;
  begin
    ausschrift('Inno Setup / Jordan Russell [zlib]',packer_dat);
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    (* ich mÅ·te inflate einbauen *)
  end;

procedure lpac(const p:puffertyp);
  begin
    ausschrift('Lossless Predictive Audio Compression / Tilman Liebchen',packer_dat);
    if not langformat then exit;

    archiv_start;
    laenge_ausgepackt64:=$25+m_longint(p.d[$6]);
    laenge_eingepackt64:=einzel_laenge;
    archiv_datei64;
    archiv_datei_ausschrift('?');
    archiv_summe;

  end;

procedure updateit;
  var
    o:longint;
  begin
    ausschrift('UpdateIt! / Innovative Data Concepts Incorporated [1.00]',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    while o+12<einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,8);
        laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[4])^;
        archiv_datei;
        if (laenge_eingepackt=$1d4) and (laenge_ausgepackt=$3bd) then archiv_datei_ausschrift('(msg)')
        else archiv_datei_ausschrift('?');
        Inc(o,12+laenge_eingepackt);
      end;
    archiv_summe;
    einzel_laenge:=o;
  end;

procedure neobook(const dir_anfang,dir_ende:dateigroessetyp);
  var
    o,dp:dateigroessetyp;
  begin
    ausschrift('NeoBook (Windows) / Neo Software [?.?]',musik_bild);
    if not langformat then exit;

    archiv_start;
    o:=dir_anfang+4+$72-$2f+$29+6;
    while o<dir_ende do
      begin
        datei_lesen(form_puffer,o,256+3);
        exezk:=puffer_zu_zk_l(form_puffer.d[2],form_puffer.d[0]);
        IncDGT(o,2+word_z(@form_puffer.d[0])^);
        datei_lesen(form_puffer,o,20);
        laenge_ausgepackt:=longint_z(@form_puffer.d[ 1])^;
        dp               :=longint_z(@form_puffer.d[ 5])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[ 9])^;

        if laenge_ausgepackt=0 then
          begin
            befehl_schnitt(dp,laenge_eingepackt,ohne_pfad(exezk));
            laenge_ausgepackt:=laenge_eingepackt;
          end
        else
          begin
            befehl_e_infla(dp,laenge_eingepackt,ohne_pfad(exezk));
          end;

        case form_puffer.d[0] of
          1: (* RUNTIME.PUB *)
            IncDGT(o,1+3*4);
          2: (* C:\Documents and Settings\ththo\Desktop\soft\n¯ytrale tester.RTF *)
            IncDGT(o,1+3*4);
          3: (* C:\Documents and Settings\ththo\Desktop\soft\kontakt_oss_bilde.jpg *)
            IncDGT(o,1+5*4);
          6: (* Arial Narrow.ttf *)
            IncDGT(o,1+3*4);

        else
            ausschrift(str0(form_puffer.d[0])+'?',dat_fehler);
            IncDGT(o,1+3*4);
        end;

        archiv_datei;
        archiv_datei_ausschrift(str0(form_puffer.d[0])+':'+exezk);

      end;
    archiv_summe;

  end;

procedure dateisystem_iso9660(const sektorgroesse,sektordatenstart:dateigroessetyp);
  const
    sektorgroesse_software      =2048;

  var
    name_org                    :string;
    letzter_dateisystem_block   :dateigroessetyp;

  procedure verzeichnis_abarbeiten(verschachtelung:word_norm;const verzeichnis:string;
      const verzeichnisstart,verzeichnislaenge:dateigroessetyp);
    var
      o,
      doff                      :dateigroessetyp;
      extra                     :integer_norm;
      entpackbar                :boolean;
    begin
      if verschachtelung>100 then Exit;
      Inc(verschachtelung);
      o:=0;
      while o<verzeichnislaenge do
        begin  (* shsucd14.zip: cdrom.h *)
          datei_lesen(form_puffer,analyseoff+verzeichnisstart
            +ModDGT(o,sektorgroesse_software)
            +DivDGT(o,sektorgroesse_software)*sektorgroesse+sektordatenstart,$200);
          if form_puffer.g=0 then Break;

          if form_puffer.d[0]=0 then (* am Ende eines Sektors kommen keine angebrochenen Daten *)
            begin
              o:=AndDGT(o+sektorgroesse_software-1,-sektorgroesse_software);
              Continue;
            end;

          if form_puffer.d[0]<$21 then
            Break;



          exezk:=puffer_zu_zk_pstr(form_puffer.d[$20]);
          extra:=$20+1+form_puffer.d[$20];
          if form_puffer.d[extra]=0 then Inc(extra);

          if extra+$a<form_puffer.d[0] then
            begin
              (* Rockridge .. geraten *)
              if bytesuche(form_puffer.d[extra],'RR'#$05#$01'?NM') then
                exezk:=datei_lesen__zu_zk_l(analyseoff+verzeichnisstart+o+extra+10,form_puffer.d[extra+7]-5);
            end;

          IncDGT(o,form_puffer.d[0]);

          name_org:=exezk;

          if (form_puffer.d[$19] and $02)=0 then
            begin (* Datei *)
              if Pos(';',exezk)>0 then SetLength(exezk,Pos(';',exezk)-1);
              if exezk<>'' then
                if exezk[Length(exezk)]='.' then
                  SetLength(exezk,Length(exezk)-1);

              laenge_eingepackt64:=longint_z(@form_puffer.d[$0a])^;
              entpackbar:=(sektorgroesse=sektorgroesse_software) or (laenge_eingepackt64<=sektorgroesse_software);
              doff:=sektordatenstart;
              (* SVCD: wird als voller 2352-Sektor gezÑhlt-mîglicherweise ohne sektordatenstart*)
              if longint_z(@form_puffer.d[$02])^>=letzter_dateisystem_block then
                begin
                  laenge_eingepackt64:=DivDGT(laenge_eingepackt64+sektorgroesse_software-1,
                    sektorgroesse_software)*sektorgroesse;
                  entpackbar:=true;
                  doff:=0;
                end;
              laenge_ausgepackt64:=laenge_eingepackt64;
              archiv_datei64;
              archiv_datei_ausschrift(verzeichnis+exezk);

              if entpackbar then
                if quelle.sorte=q_datei then
                  befehl_schnitt(analyseoff+longint_z(@form_puffer.d[$02])^*sektorgroesse+doff,laenge_eingepackt64,
                    verzeichnis+exezk);

              einzel_laenge:=MaxDGT(einzel_laenge,
                longint_z(@form_puffer.d[$02])^*sektorgroesse+laenge_eingepackt64);
            end
          else
            begin (* Verzeichnis *)
              if (exezk<>#0) and (exezk<>#1) then (* '.' '..' *)
                begin
                  laenge_eingepackt:=0;
                  laenge_ausgepackt:=0;
                  archiv_datei;
                  Insert(verzeichnis,exezk,1);
                  exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(35);
                  archiv_datei_ausschrift_verzeichnis(exezk);
                  if quelle.sorte=q_datei then
                    befehl_mkdir(verzeichnis+name_org);

                  einzel_laenge:=MaxDGT(einzel_laenge,
                    longint_z(@form_puffer.d[$02])^*sektorgroesse+longint_z(@form_puffer.d[$0a])^);

                  verzeichnis_abarbeiten(
                    verschachtelung,
                    verzeichnis+(*--puffer_zu_zk_pstr(form_puffer.d[$20])--*) name_org+'\',
                    longint_z(@form_puffer.d[$02])^*sektorgroesse,
                    longint_z(@form_puffer.d[$0a])^);

                end;
          end;
        end;

      Dec(verschachtelung);
    end;

  begin
    letzter_dateisystem_block:=x_longint__datei_lesen(analyseoff+16*sektorgroesse+sektordatenstart+$50);
    einzel_laenge:=letzter_dateisystem_block*sektorgroesse;
    archiv_start;
    verzeichnis_abarbeiten(0,'',
      x_longint__datei_lesen(analyseoff+16*sektorgroesse+sektordatenstart+$9e)*sektorgroesse,
      x_longint__datei_lesen(analyseoff+16*sektorgroesse+sektordatenstart+$a6));
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure cdrom_boot_catalog(o0:dateigroessetyp;l:word_norm;z_cd_sektor:z_cd_puffer_typ);
  var
    o:word_norm;
  begin

    ausschrift('Bootable CD-ROM',normal);

    if Assigned(z_cd_sektor) then
      Move(z_cd_sektor^[DGT_zu_longint(o0)],form_puffer.d,$20)
    else
      datei_lesen(form_puffer,o0,$20);
    if form_puffer.d[0]<>1 then exit;

    case form_puffer.d[1] of
      0:exezk:='80x86';
      1:exezk:='Power PC';
      2:exezk:='Mac';
    else
        exezk:=hex(form_puffer.d[1]);
    end;

    ausschrift_x('Platform ID='+exezk,packer_dat,absatz);

    o:=$20;
    while o<l do
      begin
        if Assigned(z_cd_sektor) then
          Move(z_cd_sektor^[DGT_zu_longint(o0+o)],form_puffer.d,$20)
        else
          datei_lesen(form_puffer,o0+o,$20);
        if form_puffer.d[0]=$88 then
          begin
            case form_puffer.d[1] and $0f of
              0:exezk:='No Emulation';
              1:exezk:='A:/1220 KB';
              2:exezk:='A:/1440 KB';
              3:exezk:='A:/2880 KB';
              4:exezk:='Hard disk';
            else
                exezk:='T='+hex(form_puffer.d[1] and $0f);
            end;

            exezk_anhaengen(', CS:IP=');
            if word_z(@form_puffer.d[2])^=0 then
              exezk_anhaengen('$0000:$7c00')
            else
              exezk_anhaengen(hex_word(word_z(@form_puffer.d[2])^)+':$0000');


            (* LÑnge *)
            exezk_anhaengen(', '+str0(word_z(@form_puffer.d[6])^*512));

            ausschrift_x(exezk,normal,absatz);

          end;
        Inc(o,$20);
      end;
  end;

procedure cazip;
  begin
    ausschrift('CAZIP / Computer Associates [PKWARE-LIB]',packer_dat);
    archiv_start;
    archiv_datei;
    laenge_eingepackt:=DGT_zu_longint(einzel_laenge-10);
    laenge_ausgepackt:=-1;
    archiv_datei;
    exezk:=erzeuge_kurzen_dateinamen;
    while Pos('$',exezk)<>0 do exezk[Pos('$',exezk)]:='~';
    befehl_ttdecomp(analyseoff+10,laenge_eingepackt,exezk);
    archiv_datei_ausschrift(exezk);
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure ogg_vorbis;
  var
    o                   :dateigroessetyp;
    anzahl_beschreibungen:longint;
  begin
    ausschrift('Ogg Vorbis',musik_bild);
    if not langformat then Exit;

    o:=analyseoff+$3a;
    datei_lesen(form_puffer,o,$1c);
    if not bytesuche(form_puffer.d[0],'OggS'#0) then Exit;
    IncDGT(o,$1a+form_puffer.d[$1a]+8);
    (* Software Version *)
    datei_lesen(form_puffer,o,256+4);
    ausschrift_x(puffer_zu_zk_l(form_puffer.d[4],form_puffer.d[0]),packer_dat,absatz);
    IncDGT(o,4+longint_z(@form_puffer.d[0])^);

    (* Variablen anzeigen... *)
    anzahl_beschreibungen:=x_longint__datei_lesen(o);
    IncDGT(o,4);
    while anzahl_beschreibungen>0 do
      begin
        datei_lesen(form_puffer,o,256+4);
        ausschrift_x(puffer_zu_zk_l(form_puffer.d[4],form_puffer.d[0]),beschreibung,absatz);
        IncDGT(o,4+longint_z(@form_puffer.d[0])^);
        Dec(anzahl_beschreibungen);
      end;

  end;

procedure vise_avp;
  var
    o:longint;
  begin
    ausschrift('VISE / Mindvision -> Kaspersky Antivirus [ZLIB]',packer_dat);
    if not langformat then exit;

    o:=$20;
    archiv_start;
    while o<einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,128);
        laenge_eingepackt:=longint_z(@form_puffer.d[Length(exezk)+1])^;
        laenge_ausgepackt:=-1;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,$200);
        befehl_e_infla(analyseoff+o,laenge_eingepackt,exezk);
        Inc(o,laenge_eingepackt);
      end;
    archiv_summe;
  end;

procedure chp_avp;
  var
    o,d,dir_ende:longint;
  begin
    ausschrift('CHM / Microsoft -> Kaspersky Antivirus',packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=$20;
    dir_ende:=x_longint__datei_lesen(analyseoff+o);
    Inc(o,4);

    while o<dir_ende do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,128);
        if exezk='' then Break;
        laenge_eingepackt:=longint_z(@form_puffer.d[Length(exezk)+1+4])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,$200);
        d:=dir_ende+longint_z(@form_puffer.d[Length(exezk)+1+0])^;
        befehl_schnitt(analyseoff+d,laenge_eingepackt,exezk);
      end;
    archiv_summe;
  end;


procedure amibios_archiv(o,mb0:longint;const titel:string);
  begin
    ausschrift(exezk+' [LZH5]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    repeat
      datei_lesen(form_puffer,o+mb0,$20);
      laenge_eingepackt:=word_z(@form_puffer.d[$04])^;
      if (laenge_eingepackt>$30000) then Break;
      if (form_puffer.d[7] and $80)=0 then
        laenge_ausgepackt:=longint_z(@form_puffer.d[$10])^
      else
        laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;
      archiv_datei_ausschrift('AMI_'+str0(form_puffer.d[6]));

      if bytesuche(form_puffer.d[$0],#$ff#$ff#$ff#$ff)
      or bytesuche(form_puffer.d[$0],#$00#$00#$00#$00) then Break;

      o:=word_z(@form_puffer.d[$0])^
        +word_z(@form_puffer.d[$2])^ shl 4;
    until false;
    archiv_summe;
  end;

procedure amibios_einzelblock_alt(const p:puffertyp;const dname:string);
  begin
    ausschrift('AMI BIOS packed block [LZH5]',packer_dat);
    if not langformat then Exit;

    archiv_start_leise;
    laenge_eingepackt:=longint_z(@p.d[0])^;
    laenge_ausgepackt:=longint_z(@p.d[4])^;
    archiv_datei;
    archiv_datei_ausschrift(dname);
    archiv_summe_leise;
  end;

procedure borland_pascal_resource(o,e:dateigroessetyp;version:byte);
  var
    anzahl:longint;
    daten:dateigroessetyp;
  begin
    datei_lesen(form_puffer,analyseoff+o,3*4);

    (* Anzahl Elemente, Max-Elemente, Vergrî·erungschritt *)

    if version=32 then
      if word_z(@form_puffer.d[2])^<>0 then
        version:=16;

    case version of
      16:exezk:=' [Borland Pascal]';
      32:exezk:=' [Virtual Pascal]'; (* mit $Use32+ *)
      64:exezk:=' [Virtual Pascal LargeFileSupport]';
    else Exit;
    end;

    ausschrift('Borland '+textz_Resourcendatei^+exezk,bibliothek);
    (*if not langformat then Exit;*)
    if not resource_anzeigen then Exit;

    archiv_start;
    datei_lesen(form_puffer,analyseoff+o,4+3*2);

    if version=16 then
      begin
        anzahl:=word_z(@form_puffer.d[0])^;
        IncDGT(o,2*3);
      end
    else (* 32/64 *)
      begin
        anzahl:=longint_z(@form_puffer.d[0])^;
        IncDGT(o,4*3);
      end;

    while anzahl>0 do
      begin
        if version<64 then
          begin
            datei_lesen(form_puffer,analyseoff+o,4+4);
            daten:=x_longint(form_puffer.d[0]);
            laenge_eingepackt64:=longint_z(@form_puffer.d[4])^;
            IncDGT(o,4+4);
          end
        else
          begin
            datei_lesen(form_puffer,analyseoff+o,8+8);
            daten:=x_dateigroessetyp(form_puffer.d[0]);
            laenge_eingepackt64:=x_dateigroessetyp(form_puffer.d[8]);
            IncDGT(o,8+8);
          end;

        laenge_ausgepackt64:=laenge_eingepackt64;
        archiv_datei64;

        datei_lesen(form_puffer,analyseoff+o,256);
        exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
        IncDGT(o,1+form_puffer.d[0]);
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+daten,laenge_eingepackt,exezk);
        Dec(anzahl);
      end;
    archiv_summe;
  end;

procedure png(const p:puffertyp);
  var
    o           :longint;
    w1          :word_norm;
    durchlauf   :word_norm;

  function fbit(colortype,bitdepth:byte):shortint;
    begin
      case colortype of                         (* +1        +2      +4      *)
        0: (* gray bit depths *)                (* palette:- color:- alpha:- *)
          fbit:=bitdepth;
        2: (* RGB tuples *)                     (* palette:- color:+ alpha:- *)
          fbit:=3*bitdepth;
        3: (* palette index *)                  (* palette:+ color:+ alpha:- *)
          fbit:=bitdepth;
        4: (* grayscale/alphachannel tuples *)  (* palette:- color:- alpha:+ *)
          fbit:=2*bitdepth;
        6: (* RGB/Alpha tuples *)               (* palette:- color:+ alpha:+ *)
          fbit:=4*bitdepth;
      else
          fbit:=-1;
      end;
    end;

  begin


    (* QPV 1.7c *)
    (* IMD102 *)

    if not langformat then
      begin
        w1:=puffer_pos_suche(p,'IHDR',50);
        if w1=nicht_gefunden then
          ausschrift('Portable Network Graphics',musik_bild)
        else
          begin
            bild_format_filter('Portable Network Graphics',
                                m_longint(p.d[w1+4]),
                                m_longint(p.d[w1+8]),
                                -1,fbit(p.d[w1+$d],p.d[w1+$c]),false,true,anstrich);
          end;
        Exit;
      end;

    for durchlauf:=1 to 2 do
      begin
        o:=8;
        while o<einzel_laenge do
          begin

            datei_lesen(form_puffer,analyseoff+o,4+4+20);
            Inc(o,8);
            laenge_eingepackt:=m_longint(form_puffer.d[0]);

            if durchlauf=1 then
              with form_puffer do
              if bytesuche(d[4],'IHDR') then
                begin
                  bild_format_filter('Portable Network Graphics',
                                     m_longint(d[8]),
                                     m_longint(d[12]),
                                     -1,fbit(d[4+$d],d[4+$c]),false,true,anstrich);
                  Break; (* zum 2. Durchlauf *)
                end;

            if durchlauf=2 then
              if bytesuche(form_puffer.d[4],'tEXt') then
                while laenge_eingepackt>0 do
                  begin
                    datei_lesen(form_puffer,analyseoff+o,512);
                    exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,Min(255,laenge_eingepackt));
                    Inc(o,Length(exezk)+1);
                    Dec(laenge_eingepackt,Length(exezk)+1);
                    ausschrift_x(exezk,beschreibung,absatz);
                  end;

            Inc(o,laenge_eingepackt);
            Inc(o,4); (* crc32 *)
          end;
      end;
  end;

procedure bar;
  var
    o:longint;
    exezk_o:string;

  procedure bar_anzeige(const verzeichnis:string);
    begin
      repeat
        datei_lesen(form_puffer,analyseoff+o,512);
        Inc(o,1);
        case form_puffer.d[0] of
          0, (* info *)
          1, (* comment *)
          2: (* status *)
            begin
              ausschrift_x(puffer_zu_zk_l(form_puffer.d[3],form_puffer.d[1]),beschreibung,absatz);
              Inc(o,2+word_z(@form_puffer.d[1])^);
            end;

          100: (* Datei *)
            begin
              exezk:=verzeichnis+puffer_zu_zk_l(form_puffer.d[3],form_puffer.d[1]);
              Inc(o,2+word_z(@form_puffer.d[1])^);
              Inc(o,1+2+2);
              laenge_eingepackt:=x_longint__datei_lesen(analyseoff+o);
              Inc(o,4);
              befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
              laenge_ausgepackt:=laenge_eingepackt;
              archiv_datei;
              archiv_datei_ausschrift(exezk);
              Inc(o,laenge_eingepackt);
            end;

          101: (* Verzeichnis *)
            begin
              exezk:=verzeichnis+puffer_zu_zk_l(form_puffer.d[3],form_puffer.d[1]);
              Inc(o,2+word_z(@form_puffer.d[1])^);
              befehl_mkdir(exezk);
              exezk_o:=exezk+'\';
              laenge_eingepackt:=0;
              laenge_ausgepackt:=0;
              archiv_datei;
              archiv_datei_ausschrift_verzeichnis(exezk);
              bar_anzeige(exezk_o);
            end;

          102: (* Verzeichnisende *)
            begin
              Exit;
            end;

          255: (* Ende *)
            begin
              Dec(o);
              Exit;
            end;

        else
          ausschrift('?',dat_fehler);
          Dec(o);
          Exit;
        end;
      until o>=einzel_laenge;
    end;

  begin
    ausschrift('Bad ARchive / Kostas Michalopoulos',packer_dat); (* 1.0 *)
    if not langformat then Exit;

    archiv_start;
    o:=4;
    bar_anzeige('');
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure lzk;
  var
    o:longint;
    j,bl:word_norm;
  begin
    ausschrift('LZK / Ralph Kirschner',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=$10;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$18);
      Inc(o,$16);
      laenge_ausgepackt:=longint_z(@form_puffer.d[$05])^;
      laenge_eingepackt:=0;
      exezk:=puffer_zu_zk_e(form_puffer.d[$09],#0,255);
      bl:=(laenge_ausgepackt+$fe00-1) div $fe00; (* Anzahl Blîcke *)
      while bl>0 do
        begin
          datei_lesen(form_puffer,analyseoff+o,3);
          j:=word_z(@form_puffer.d[$00])^;
          Inc(laenge_eingepackt,2+j);
          Inc(o,2+j);
          Dec(bl);
        end;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure versuche_exebundle;
  var
    o:longint;
  begin
    o:=0;
    (* erste Datei gÅltig? *)
    datei_lesen(form_puffer,analyseoff+o,512);
    if (not bytesuche(form_puffer.d[0],'???'#$00'?'#$00#$00#$00))
    or (form_puffer.d[4]<3) then
      Exit;

    (* zweite Datei gÅltg? *)
    exezk:=puffer_zu_zk_l(form_puffer.d[8],form_puffer.d[4]);
    laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
    Inc(o,8+Length(exezk));
    Inc(o,laenge_eingepackt);
    if o+50>einzel_laenge then
      Exit;

    datei_lesen(form_puffer,analyseoff+o,512);
    if (not bytesuche(form_puffer.d[0],'???'#$00'?'#$00#$00#$00))
    or (form_puffer.d[4]<3) then
      Exit;


    ausschrift('ExeBundle / Hanspeter Imp',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    while o+4<einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_l(form_puffer.d[8],form_puffer.d[4]);
        laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
        laenge_eingepackt:=laenge_ausgepackt;
        Inc(o,8+Length(exezk));
        befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
        Inc(o,laenge_eingepackt);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
      end;
    archiv_summe;
  end;

procedure macromedia_flash(const p:puffertyp);

  var
    o                   :longint;
    bit_verbraucht      :word_norm;

  function lies_u_bits(n:word_norm):word_norm;
    var
      nn,j,b            :word_norm;
      l                 :longint;
    begin
      nn:=n;
      l:=0;
      while nn>0 do
        begin
          if bit_verbraucht=8 then
            begin
              Inc(o);
              bit_verbraucht:=0;
            end;
          j:=Min(8-bit_verbraucht,nn);
          b:=(byte__datei_lesen(analyseoff+o) shr (8-bit_verbraucht-j)) and (1 shl j-1);
          l:=(l shl j) or b;
          Dec(nn,j);
          Inc(bit_verbraucht,j);
        end;
      lies_u_bits:=l;
    end;

  function lies_s_bits(n:word_norm):longint;
    var
      l:longint;
    begin
      l:=lies_u_bits(n);
      if Odd(l shr (n-1)) then
        l:=-(l and ((1 shl n)-1));
      lies_s_bits:=l;
    end;

  procedure skip_bits(n:word_norm);
    begin
      Inc(bit_verbraucht,n);
      Inc(o,bit_verbraucht shr 3);
      bit_verbraucht:=bit_verbraucht and 7;
    end;

  procedure align_byte;
    begin
      if bit_verbraucht>0 then
        begin
          Inc(o);
          bit_verbraucht:=0;
        end;
    end;


  procedure parse_DoAction;
    var
      j                 :longint;
    begin
      repeat
        datei_lesen(form_puffer,analyseoff+o,512);
        if Odd(form_puffer.d[0] shr 7) then
          j:=1+2+word_z(@form_puffer.d[1])^
        else
          j:=1;

        (*$IfNDef EndVersion*)
        if signaturen then
          ausschrift('Action: '+hex(form_puffer.d[0])+', LÑnge='+str0(j),normal);
        (*$EndIf EndVersion*)

        case form_puffer.d[0] of
          $00: (* End *)
            Break;
     (*   $81: Goto Frame *)
          $83: (* Get URL *)
            begin
              (* Inc(i,3);Dec(j,3);*)
              exezk:=puffer_zu_zk_e(form_puffer.d[3],#0,255);
              ausschrift_x('Get URL '+in_doppelten_anfuerungszeichen(exezk),beschreibung,leer);
              (* target window string..*)
            end;
     (*   $04: Next Frame *)
     (*   $05: Previous Frame *)
     (*   $06: Play *)
     (*   $07: Stop *)
     (*   $08: Toggle Quality *)
     (*   $09: Stop Sounds *)
     (*   $8a: Wait For Frame *)
     (*   $8b: Set Target *)
          $8c: (* Comment *)
            begin
              exezk:=puffer_zu_zk_e(form_puffer.d[3],#0,255);
              ausschrift_x('Comment '+in_doppelten_anfuerungszeichen(exezk),beschreibung,leer);
             end;
        end; (* case *)
        Inc(o,j);
      until false;
    end; (* parse_DoAction *)

  procedure Skip_Matrix;
    var
      b                 :word_norm;
    begin
    (*ausschrift('Matrix '+hex_longint(o),normal);*)
      if lies_u_bits(1)=1 then (* scale *)
        begin
          b:=lies_u_bits(5);
          skip_bits(2*b);
        (*ausschrift('  Scale X:'+str0(lies_s_bits(b)),normal);
          ausschrift('  Scale Y:'+str0(lies_s_bits(b)),normal);*)
        end;
      if lies_u_bits(1)=1 then (* rotate *)
        begin
          b:=lies_u_bits(5);
          skip_bits(2*b);
        (*ausschrift('  Rotate X:'+str0(lies_s_bits(b)),normal);
          ausschrift('  Rotate Y:'+str0(lies_s_bits(b)),normal);*)
        end;
      b:=lies_u_bits(5); (* translate *)
      skip_bits(2*b);
    (*ausschrift('  Translate X:'+str0(lies_s_bits(b) div 20),normal);
      ausschrift('  Translate Y:'+str0(lies_s_bits(b) div 20),normal);*)
      align_byte;
    end; (* Skip_Matrix *)


  procedure Parse_DefineButton;
    begin
      Inc(o,2); (* id *)
      repeat
        if byte__datei_lesen(analyseoff+o)=0 then Break;
        Inc(o,1+2+2);(*skip_bits(4+1+1+1+1+16+16);*)
        Skip_Matrix;
      until o>=einzel_laenge;
      Inc(o); (* ButtonEndFlag *)

      repeat
        if byte__datei_lesen(analyseoff+o)=0 then Break;
        parse_DoAction;
      until o>=einzel_laenge;
      Inc(o); (* ActionEndFlag *)
    end; (* Parse_DefineButton *)

  procedure Parse_DefineButton2;
    var
      last:boolean;
    begin
      Inc(o,2+1+2); (* id,menu_flag,offset *)
      repeat
        if byte__datei_lesen(analyseoff+o)=0 then Break;
        Inc(o,1+2+2);(*skip_bits(4+1+1+1+1+16+16);*)
        Skip_Matrix;
        Inc(o,1);
      until o>=einzel_laenge;
      Inc(o); (* ButtonEndFlag *)

      repeat
        last:=(x_word__datei_lesen(analyseoff+o)=0)
            or (o>=einzel_laenge);
        Inc(o,2+2); (* ActionOffset, Condition *)
        parse_DoAction;
      until last;
      Inc(o); (* ActionEndFlag *)
    end; (* Parse_DefineButton2 *)

  var
    l                   :longint; (* BlocklÑnge *)
    k                   :longint; (* KopflÑnge *)
    t                   :word_norm;  (* tag  *)
    rect_bits           :longint;
    xmin,xmax,ymin,ymax :longint;
    l1                  :dateigroessetyp;
    o2                  :longint;

  begin
    einzel_laenge:=longint_z(@p.d[4])^;
    o:=4+4;
    (* frame size *)
    bit_verbraucht:=0;
    rect_bits:=lies_u_bits(5);
    xmin:=lies_s_bits(rect_bits);
    xmax:=lies_s_bits(rect_bits);
    ymin:=lies_s_bits(rect_bits);
    ymax:=lies_s_bits(rect_bits);
    align_byte;

    (* frame delay; frame count *)
    exezk:=str0(p.d[o+1]);
    if p.d[o]<>0 then
      exezk_anhaengen(','+str0(p.d[o]));
    Inc(o,2+2);
    bild_format_filter('Flash / Macromedia ['+str0(p.d[3] and $7)+'], '+exezk+textz_form__Rahmen_je_Sekunde_^,
                         (xmax-xmin) div 20,
                         (ymax-ymin) div 20,
                         -1,-1,false,true,anstrich);

    if not langformat then Exit;

    while o+2<=einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,2+4);
        if form_puffer.g=0 then Break;

        t:=word_z(@form_puffer.d[0])^ shr 6;
        l:=form_puffer.d[0] and $3f;
        k:=2;
        if l=$3f then (* lange Variante *)
          begin
            l:=longint_z(@form_puffer.d[2])^;
            Inc(k,4);
          end;

        (*$IfNDef EndVersion*)
        if signaturen then
          ausschrift(hex_longint(o)+' TAG '+hex_word(t)+' '+strx_oder_hex(l),packer_dat);
        (*$EndIf EndVersion*)

        Inc(o,k);

        case t of
           0:(* End html nach dem Dateiende? *)
             (* AGB Tutorial.exe: Markierung der SWF-LÑnge vom Ende der Datei aus *)
             if not bytesuche__datei_lesen(analyseoff+o,#$56#$34#$12#$fa) then
               begin
                 exezk:=datei_lesen__zu_zk_e(analyseoff+o,#0,80);
                 if exezk<>'' then
                   ausschrift(exezk,beschreibung);
               end;
       (*  1:ShowFrame
           2:DefineShape
           4:PlaceObject
           5:RemoveObject *)
           6: (* DefineBits *)
             begin
               datei_lesen(form_puffer,analyseoff+o,2);
               exezk:='image'+str0(word_z(@form_puffer.d[0])^)+'.jpg';
               befehl_schnitt(analyseoff+o+2,l-2,exezk);
             end;
           7: (* DefineButton *)
             begin
               o2:=o;
               Parse_DefineButton;
               o:=o2;
             end;
       (*  8:JPEGTables
           9:SetBackgroundColor
          10:DefineFont
          11:DefineText *)
          12: (* DoAction *)
            begin
              o2:=o;
              parse_DoAction;
              o:=o2;
            end;
        (*13:DefineFontInfo
          14:DefineSound
          15:StartSound
          17:DefineButtonSound
          18:SoundStreamHead
          19:SoundStreamBlock *)
          20:(* DefineBitsLossless *)
            begin
              (* zlib...
              ?? grafik_ausschrift*)
            end;
          21:(* DefineBitsJPEG2 16bit-id, encodingdata, image data *)
            begin
              datei_lesen(form_puffer,analyseoff+o,2);
              l1:=datei_pos_suche(analyseoff+o+2,analyseoff+o+l,#$ff#$d9#$ff#$d8);
              if l1<>nicht_gefunden then
                begin
                  IncDGT(l1,2);
                  if bytesuche__datei_lesen(l1,#$ff#$d8#$ff#$d8) then
                    IncDGT(l1,2);
                  exezk:='encod'+str0(word_z(@form_puffer.d[0])^)+'.jpg';
                  befehl_schnitt(analyseoff+o+2,l1-(analyseoff+o+2),exezk);
                  exezk:='image'+str0(word_z(@form_puffer.d[0])^)+'.jpg';
                  befehl_schnitt(l1,l-2-(l1-(analyseoff+o+2)),exezk);
                end;
            end;
        (*22:DefineShape2
          23:ColorTransform *)
          24:(* Protect *)
            ausschrift_x('Protect',beschreibung,leer);
        (*26:PlaceObject2
          28:RemoveObject2
          32:DefineShape3 *)
          34: (* DefineButton2 *)
            begin
              o2:=o;
              Parse_DefineButton2;
              o:=o2;
            end;
       (* 35:DefineBitsJPEG3 16bit-id, encodingdata, imagedata, alphadata *)
        (*36:DefineBitsLossless2: zlib grafik...*)
        (*39:DefineSprite->rekursiv *)
        (*43:FrameLabel
          45:SoundStreamHead2
          46:DefineMorphShape
          48:DefineFont2 *)
        end;
        Inc(o,l);
      end;
  end;

procedure mcfx(const p:puffertyp);
  var
    o:longint;
    anzahl:word_norm;
  begin
    (* dm_v957img.bin  IBM disk manager 2000 *)
    ausschrift('MCFX / ONTRACK [PKWARE-LIB]',packer_dat);
    if not langformat then exit;

    anzahl:=word_z(@p.d[4])^;
    o:=4+2;
    archiv_start;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,$15);
        laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
        laenge_ausgepackt:=-1;
        exezk:=puffer_zu_zk_e(form_puffer.d[8],#0,8+1+3);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,$15);
        befehl_ttdecomp(analyseoff+o,laenge_eingepackt,exezk);
        Inc(o,laenge_eingepackt);
        Dec(anzahl);
      end;
    archiv_summe;
  end;

procedure netscape_reg(const p:puffertyp);
  var
    o(*,o1*):dateigroessetyp;
    (*p2:puffertyp;*)

  begin
    ausschrift('Netscape nsreg.dat',bibliothek);
    if not langformat then exit;

    einzel_laenge:=longint_z(@p.d[2*4])^;

    o:=einzel_laenge-8*4;
    repeat
      datei_lesen(form_puffer,analyseoff+o,8*4);
      if longint_z(@form_puffer.d[1*4])^=0 then Exit;

      if longint_z(@form_puffer.d[5*4])^<>0 then
        begin
          exezk:='';
          (*
          o1:=longint_z(@form_puffer.d[4*4])^;
          while o1>0 do
            begin
              datei_lesen(p2,analyseoff+o1,8*4);
              if longint_z(@p.d[1*4])^=0 then Break;
              Insert('\',exezk,1);
              Insert(datei_lesen__zu_zk_e(analyseoff+longint_z(@p.d[1*4])^,#0,80),exezk,1);
              if longint_z(@p.d[4*4])^>=o1 then Break;
              o1:=longint_z(@p.d[4*4])^
            end;*)

          ausschrift_x(exezk+datei_lesen__zu_zk_e(analyseoff+longint_z(@form_puffer.d[1*4])^,#0,80),normal,absatz);
          ausschrift_x(datei_lesen__zu_zk_e(analyseoff+longint_z(@form_puffer.d[5*4])^,#0,longint_z(@form_puffer.d[6*4])^),
            normal,leer);
        end;

      DecDGT(o,8*4+word_z(@form_puffer.d[2*4])^+longint_z(@form_puffer.d[6*4])^);

    until o<=0;
  end;

(*        uflz_ibsen *)
procedure BriefLZ(const p:puffertyp;const titel:string);
  begin
    ausschrift(titel+' / Joergen Ibsen',packer_dat); (* 1.00 *)
    if not langformat then Exit;

    if longint_z(@p.d[4])^=1 then
      begin
        archiv_start_leise;
        laenge_eingepackt:=0;
        laenge_ausgepackt:=0;
        while laenge_eingepackt<einzel_laenge do
          begin
            datei_lesen(form_puffer,analyseoff+laenge_eingepackt,$18);
            if longint_z(@form_puffer.d[4])^<>1 then Break;
            Inc(laenge_eingepackt,$18+longint_z(@form_puffer.d[  8])^);
            Inc(laenge_ausgepackt,    longint_z(@form_puffer.d[$10])^);
          end;
        archiv_datei;
        archiv_datei_ausschrift('?');
        archiv_summe_leise;
        einzel_laenge:=laenge_eingepackt;
      end
    else
      begin
        archiv_start_leise;
        laenge_eingepackt:=$18+longint_z(@p.d[  8])^;
        laenge_ausgepackt:=    longint_z(@p.d[$10])^;
        archiv_datei;
        archiv_datei_ausschrift('?');
        archiv_summe_leise;
        einzel_laenge:=laenge_eingepackt;
      end;

  end;


procedure lzx;
  var
    o,s1:longint;
  begin
    ausschrift('LZX / ?',packer_dat); (* amiga *)
    if not langformat then Exit;

    o:=$a;
    archiv_start;
    s1:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_eingepackt:=-1;
      Inc(s1,longint_z(@form_puffer.d[$06])^);
      laenge_ausgepackt:=longint_z(@form_puffer.d[$02])^;
      archiv_datei;
      exezk:=puffer_zu_zk_pstr(form_puffer.d[$1e]);
      archiv_datei_ausschrift(exezk);
      Inc(o,$1e+1+Length(exezk));
      if form_puffer.d[$0e]<>0 then
        begin
          ausschrift_x(puffer_zu_zk_l(form_puffer.d[$1e+1+Length(exezk)],form_puffer.d[$0e]),beschreibung,absatz);
          Inc(o,form_puffer.d[$0e]);
        end;
    until (o>einzel_laenge) or (longint_z(@form_puffer.d[$06])^<>0);
    archiv_summe_eingepackt:=s1;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure mmbuilder(const p:puffertyp);
  begin
    ausschrift(puffer_zu_zk_pstr(p.d[0]),packer_dat);
    if not langformat then Exit;

    archiv_start;
    ausschrift('?',normal);
    archiv_summe;
  end;

procedure addd(const p:puffertyp);
  var
    i:longint;
  begin
    (* 1503Startup.exe *)
    ausschrift('AddD / ? '+in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[8],#$1a,80)),packer_dat);
    if not langformat then Exit;

    einzel_laenge:=$84+$30*longint_z(@p.d[4])^;
    archiv_start;
    for i:=1 to longint_z(@p.d[4])^ do
      begin
        datei_lesen(form_puffer,analyseoff+$84+$30*i-$30,$30);
        laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk:=puffer_zu_zk_e(form_puffer.d[$20],#0,8+1+3);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        merke_position(longint_z(@form_puffer.d[0])^,datentyp_unbekannt);
        befehl_schnitt(longint_z(@form_puffer.d[0])^,laenge_eingepackt,exezk);
      end;
    archiv_summe;


  end;

procedure comprsia(const p:puffertyp);
  var
    o:dateigroessetyp;
  begin
    ausschrift('Compressia / Yaakov Gringeler [1.0]',packer_dat);
    if not langformat then Exit;

    einzel_laenge:=longint_z(@p.d[8])^;
    o:=$28;
    archiv_start;
    while (o<einzel_laenge) and (o>0) do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        (*$IfDef dateigroessetyp_comp*)
        laenge_ausgepackt64:=comp_z(@form_puffer.d[0])^;
        laenge_eingepackt64:=comp_z(@form_puffer.d[8])^;
        (*$Else dateigroessetyp_comp*)
        if longint_z(@form_puffer.d[0+4])^=0 then
          laenge_ausgepackt64:=longint_z(@form_puffer.d[0])^
        else
          laenge_ausgepackt64:=-1;
        if longint_z(@form_puffer.d[8+4])^=0 then
          laenge_eingepackt64:=longint_z(@form_puffer.d[8])^
        else
          laenge_eingepackt64:=-1;
        (*$EndIf dateigroessetyp_comp*)
        exezk:=puffer_zu_zk_l(form_puffer.d[$42],Min(word_z(@form_puffer.d[$40])^,255));
        archiv_datei64;
        archiv_datei_ausschrift(exezk);
        IncDGT(o,laenge_eingepackt64);
      end;
    archiv_summe;
  end;

procedure ibm_dd_pak(const p:puffertyp);
  var
    i,anzahl:word_norm;
  begin
    (* Postscript-Druckertreiber-Daten, mit pin.exe erzeugt?*)
    ausschrift(puffer_zu_zk_e(p.d[0],#0,$2c),packer_dat);
    if not langformat then Exit;

    anzahl:=word_z(@p.d[$2c])^;
    archiv_start;
    for i:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+i*$38-4,$38);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,$28);
        laenge_eingepackt:=longint_z(@form_puffer.d[$2c])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+longint_z(@form_puffer.d[$28])^,laenge_eingepackt,exezk);
      end;
    archiv_summe;
  end;

procedure hmi_archiv;
  var
    anzahl              :longint;
    o,hmi_text          :dateigroessetyp;
  begin
    ausschrift('HMI Sound Operating System / Human Machine Interfaces [386]',bibliothek);
    if not langformat then Exit;

    archiv_start;

    datei_lesen(form_puffer,analyseoff+$20,4+4);
    anzahl:=longint_z(@form_puffer.d[0])^; (* 100 *)
    o:=longint_z(@form_puffer.d[4])^; (* $2c *)

    while anzahl>0 do
      begin
        if o>einzel_laenge then
          begin
            ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
            Break;
          end;

        datei_lesen(form_puffer,analyseoff+o,$30);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,$20);
        laenge_eingepackt:=longint_z(@form_puffer.d[$20])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[$24])^;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        IncDGT(o,$30);
        befehl_schnitt(analyseoff+o,laenge_ausgepackt,exezk);
        hmi_text:=datei_pos_suche(analyseoff+o,analyseoff+o+Min(laenge_ausgepackt,256),'HMI');
        if hmi_text<>nicht_gefunden then
        ansi_anzeige(hmi_text,#$1a,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
               ,leer,falsch,wahr,analyseoff+o+laenge_ausgepackt,'');
        IncDGT(o,laenge_eingepackt-$2c-$30);
        Dec(anzahl);
      end;
    archiv_summe;
  end;

procedure anvil_of_dawn(const p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('Anvil of Dawn / DreamForge Intertainment,New World Computing,Softgold',spielstand); (* de:softgold *)
    ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[0],#0,$20)),beschreibung,absatz);
    ausschrift_x(in_doppelten_anfuerungszeichen(datei_lesen__zu_zk_e(analyseoff+$4d01,#0,$20)),beschreibung,absatz);

    (*
    if not langformat then Exit;


    archiv_start;
    //o:=$4e98;---?
    while o>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,$22);
        laenge_eingepackt:=
      end;
    archiv_summe;*)
  end;

procedure adf(const p:puffertyp);
  var
    anzahl_bloecke      :longint;
    pfad                :string;

  procedure verzeichnis(anfang:longint);
    var
      i                 :longint;
      pfad_laenge       :word_norm;
    begin
      if (anfang<=0)
      or (anfang>=anzahl_bloecke) then Exit;

      datei_lesen(form_puffer,analyseoff+anfang*512,512);
      case m_longint(form_puffer.d[$1fc]) of
        2: (* Verzeichnis *)
          begin
            pfad_laenge:=Length(pfad);
            pfad:=pfad+puffer_zu_zk_pstr(form_puffer.d[$1b0])+'\';
            exezk:=pfad;
            laenge_eingepackt:=0;
            laenge_ausgepackt:=0;
            archiv_datei;
            archiv_datei_ausschrift_verzeichnis(exezk);
            for i:=1-1 to $48-1 do
              verzeichnis(m_longint__datei_lesen(analyseoff+anfang*512+$18+i*4));
            SetLength(pfad,pfad_laenge);
          end;
       -3: (* Datei *)
          begin
            exezk:=pfad+puffer_zu_zk_pstr(form_puffer.d[$1b0]);
            exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
            laenge_eingepackt:=m_longint(form_puffer.d[$144]);
            laenge_ausgepackt:=laenge_eingepackt;
            archiv_datei;
            archiv_datei_ausschrift(exezk);
          end;
      else
        ausschrift(hex_longint(anfang)+': '+hex_longint(m_longint(form_puffer.d[$1fc]))+'?',dat_fehler);
      end;

    end;

  var
    i,o:longint;

  begin
    ausschrift('A(miga?)D(disk?)F(ile?)',packer_dat);
    if not langformat then Exit;

    anzahl_bloecke:=DGT_zu_longint(einzel_laenge) div 512;

    (* root-block: adf_blk.h *)
    archiv_start;
    o:=m_longint(p.d[8]);
    pfad:='';
    for i:=1-1 to $48-1 do
      verzeichnis(m_longint__datei_lesen(analyseoff+o*512+$18+i*4));
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;


procedure petascii(var s:string);
  var
    i:word_norm;
    c:byte;

  const
    s1:array[0..255] of byte=
     ( 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
       80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91,156, 93, 24, 27,
       32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
       48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
       64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
       80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91,156, 93, 24, 27,
      196,  6,179,196,196,196,196,179,179,191,192,217,192, 92, 47,218,
      191,  7,196,  3,179,218, 88,  9,  5,179,  4,197,221,179,227,177,
      196,  6,179,196,196,196,196,179,179,191,192,217,192, 92, 47,218,
      191,  7,196,  3,179,218, 88,  9,  5,179,  4,197,221,179,227,177,
       32,221,220,196, 95,179,178,179,220,177,179,195,218,192,191, 95,
      218,193,194,180,179,221,222,196,223,220,217,191,192,217,217, 92,
      196,  6,179,196,196,196,196,179,179,191,192,217,192, 92, 47,218,
      191,  7,196,  3,179,218, 88,  9,  5,179,  4,179,221,179,227,177,
       32,221,220,196, 95,179,178,179,220,177,179,195,218,192,191, 95,
      218,193,194,180,179,221,222,196,223,220,217,191,192,217,217,227);

  begin
    for i:=1 to Length(s) do
      s[i]:=Chr(s1[Ord(s[i])]);
  end;


procedure d64;

  function Umrechung(spur,sektor:byte):longint;
    var
      l:longint;
    begin
      case spur of
         1..17:l:=sektor+21*(spur- 1)    ;
        18..24:l:=sektor+19*(spur-18)+357;
        25..30:l:=sektor+18*(spur-25)+490;
        31..40:l:=sektor+17*(spur-31)+598;
      else
               l:=0;
      end;
      Umrechung:=l*$100;
    end;



  var
    z,s         :byte;
    i           :word_norm;

  begin
    (* Label sinnvoll? *)
    datei_lesen(form_puffer,analyseoff+Umrechung(18,0),$100);
    if bytesuche(form_puffer.d[0],#$00#$00#$00#$00) then Exit;

    z:=18;s:=1;
    datei_lesen(form_puffer,analyseoff+Umrechung(z,s),$100);
    (* Dateiattribut prÅfen *)
    for i:=0 to 7 do
      begin
        if not ((form_puffer.d[i*$20+2] and $0f) in [0..4]) then Exit;
        laenge_eingepackt:=word_z(@form_puffer.d[i*$20+$1e])^*$100;
        if laenge_eingepackt>einzel_laenge then Exit;
      end;
    (* Verzeichnis bleibt in der vorgesehenen Spur oder ist zu Ende?*)
    if not (form_puffer.d[0] in [0,18]) then Exit;
    if (form_puffer.d[1]>21) and (form_puffer.d[0]=18) then Exit;

    exezk:='35T'; if einzel_laenge>=768*$100 then exezk:='40T';
    if (DGT_zu_longint(einzel_laenge) mod $101)=0 then exezk_anhaengen('+error byte');

    ausschrift('C64 1541 disk ['+exezk+']',packer_dat);


    datei_lesen(form_puffer,analyseoff+Umrechung(18,0),$100);
    exezk:=puffer_zu_zk_l(form_puffer.d[$90],16);
    petascii(exezk);
    if exezk<>'' then
      ausschrift_x(exezk,beschreibung,absatz);

    if not langformat then Exit;

    archiv_start;
    z:=18;s:=1;
    repeat
      datei_lesen(form_puffer,analyseoff+Umrechung(z,s),$100);
      for i:=0 to 7 do
        begin
          exezk:=puffer_zu_zk_l(form_puffer.d[i*$20+5],16);
          petascii(exezk);
          exezk_leerzeichen_erweiterung(18);
          case form_puffer.d[i*$20+2] and $0f of
            0:exezk_anhaengen('[DEL]');
            1:exezk_anhaengen('[SEQ]');
            2:exezk_anhaengen('[PRG]');
            3:exezk_anhaengen('[USR]');
            4:exezk_anhaengen('[REL]');
          else
              exezk_anhaengen('[???]');
          end;

          laenge_eingepackt:=word_z(@form_puffer.d[i*$20+$1e])^*$100;
          laenge_ausgepackt:=laenge_eingepackt;
          if not Bytesuche(form_puffer.d[i*$20+5],#$00#$00#$00#$00#$00#$00#$00) then
            begin
              archiv_datei;
              archiv_datei_ausschrift(exezk);
            end;
        end;
      z:=form_puffer.d[0];
      s:=form_puffer.d[1];
    until (z<>18) or (s>21);
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;

  end;

procedure fastlynx(const p:puffertyp);
  var
    o:longint;

  function lies_zahl_element:longint;
    var
      i:word_norm;
      z:longint;
    begin
      i:=0;
      datei_lesen(form_puffer,analyseoff+o,512);
      while (i+1<form_puffer.g) and (form_puffer.d[i] in [$20,$09]) do
        Inc(i);
      z:=0;
      while (i+1<form_puffer.g) and (form_puffer.d[i] in [Ord('0')..Ord('9')]) do
        begin
          z:=z*10+form_puffer.d[i]-Ord('0');
          Inc(i);
        end;
      while (i+1<form_puffer.g) and (form_puffer.d[i] in [$20,$09]) do
        Inc(i);
      if (i+1<form_puffer.g) and (form_puffer.d[i]=$0d) then
        Inc(i);
      lies_zahl_element:=z;
      Inc(o,i);
    end;

  var
    anzahl_dirsektoren,
    anzahl_verzeichniseintraege,
    lsu                 :longint;
    tmpstring:string;
  begin
    ausschrift('LyNX / Will Corley',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=3+p.d[2];
    Inc(o,Length(#$0d));
    anzahl_dirsektoren:=lies_zahl_element;
    datei_lesen(form_puffer,analyseoff+o,512);
    exezk:=puffer_zu_zk_e(form_puffer.d[1-1],#$0d,256);
    Inc(o,1-1+Length(exezk)+1);
    ausschrift_x(exezk,beschreibung,absatz);
    anzahl_verzeichniseintraege:=lies_zahl_element;
    while anzahl_verzeichniseintraege>0 do
      begin
        (* Dateiname *)
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#$0d,256);
        Inc(o,Length(exezk)+1);
        petascii(exezk);
        (* LÑnge *)
        laenge_eingepackt:=lies_zahl_element*254;
        (* Typ *)
        datei_lesen(form_puffer,analyseoff+o,512);
        tmpstring:=puffer_zu_zk_e(form_puffer.d[0],#$0d,256);
        Inc(o,Length(tmpstring)+1);
        tmpstring:=leer_filter(tmpstring);
        (* LSU *)
        lsu:=lies_zahl_element;
        if tmpstring='R' then
          lsu:=lies_zahl_element;
        laenge_eingepackt:=laenge_eingepackt-254+lsu-1;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(18);
        exezk_anhaengen(' [');
        exezk_anhaengen(tmpstring);
        exezk_anhaengen(']');
        archiv_datei;
        archiv_datei_ausschrift(exezk);

        Dec(anzahl_verzeichniseintraege);
      end;
    archiv_summe;

  end;

procedure d81;

  function Umrechung(spur,sektor:byte):longint;
    begin
      if (sektor in [0..39]) and (spur in [1..80]) then
        Umrechung:=(sektor+40*(spur-1))*$100
      else
        Umrechung:=0;
    end;

  var
    z,s         :byte;
    i           :word_norm;

  begin
    (* Label sinnvoll? *)
    datei_lesen(form_puffer,analyseoff+Umrechung(40,0),$100);
    if bytesuche(form_puffer.d[0],#$00#$00#$00#$00) then Exit;

    z:=40;s:=3;
    datei_lesen(form_puffer,analyseoff+Umrechung(z,s),$100);
    (* Dateiattribut prÅfen *)
    for i:=0 to 7 do
      if not ((form_puffer.d[i*$20+2] and $0f) in [0..4]) then Exit;
    (* Verzeichnis bleibt in der vorgesehenen Spur oder ist zu Ende?*)
    if not (form_puffer.d[0] in [0..80]) then Exit;
    if not (form_puffer.d[1] in [0..39]) then Exit;

    exezk:='80T';
    if (DGT_zu_longint(einzel_laenge) mod $101)=0 then exezk_anhaengen('+error byte');

    ausschrift('C64 1581 disk ['+exezk+']',packer_dat);


    datei_lesen(form_puffer,analyseoff+Umrechung(40,0),$100);
    exezk:=puffer_zu_zk_l(form_puffer.d[$04],16);
    petascii(exezk);
    if exezk<>'' then
      ausschrift_x(exezk,beschreibung,absatz);

    if not langformat then Exit;

    archiv_start;
    z:=40;s:=3;
    repeat
      datei_lesen(form_puffer,analyseoff+Umrechung(z,s),$100);
      for i:=0 to 7 do
        begin
          exezk:=puffer_zu_zk_l(form_puffer.d[i*$20+5],16);
          petascii(exezk);
          exezk_leerzeichen_erweiterung(18);
          case form_puffer.d[i*$20+2] and $0f of
            0:exezk_anhaengen('[DEL]');
            1:exezk_anhaengen('[SEQ]');
            2:exezk_anhaengen('[PRG]');
            3:exezk_anhaengen('[USR]');
            4:exezk_anhaengen('[REL]');
          else
              exezk_anhaengen('[???]');
          end;

          laenge_eingepackt:=word_z(@form_puffer.d[i*$20+$1e])^*$100;
          laenge_ausgepackt:=laenge_eingepackt;
          if not Bytesuche(form_puffer.d[i*$20+5],#$00#$00#$00#$00#$00#$00#$00) then
            begin
              archiv_datei;
              archiv_datei_ausschrift(exezk);
            end;
        end;
      z:=form_puffer.d[0];
      s:=form_puffer.d[1];
    until (z=0) or (not (s in [0..39]));
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;

  end;

procedure lingvoarc2;
  var
    o,o2,o2min:longint;
  begin
    ausschrift('lingvoArc2 / ABBYY Software House [+FINEAR]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=$12;
    o2min:=High(longint);
    while o<o2min do
      begin
        datei_lesen(form_puffer,analyseoff+o,$6d);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,$64);
        exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
        o2:=longint_z(@form_puffer.d[$65])^;
        o2min:=Min(o2,o2min);
        datei_lesen(form_puffer,analyseoff+o2,$47+$11);
        laenge_eingepackt:=longint_z(@form_puffer.d[$3d])^;
        if bytesuche(form_puffer.d[$47],'FINEAR') then
          laenge_ausgepackt:=longint_z(@form_puffer.d[$47+$0d])^
        else
          begin
            laenge_ausgepackt:=0; (* Fortsetzung *)
            exezk_anhaengen(textz_form__leer_eckauf_Fortsetzung_eckzu^);
          end;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,$6d);
      end;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure finear(const p:puffertyp);
  begin
    ausschrift('FINEAR / ABBYY Software House',packer_dat);
    if not langformat then Exit;

    archiv_start_leise;
    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=longint_z(@p.d[$0d])^;
    archiv_datei64;
    archiv_datei_ausschrift('?');
    archiv_summe_leise;
  end;

procedure living;
  var
    o,l:longint;
    dateimodus:boolean;
  begin
    ausschrift('living? / I-D Media AG',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=5;
    dateimodus:=false;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      Inc(o,4);
      exezk:=puffer_zu_zk_l(form_puffer.d[4],form_puffer.d[0]);
      Inc(o,form_puffer.d[0]);
      datei_lesen(form_puffer,analyseoff+o,512);
      l:=longint_z(@form_puffer.d[0])^;
      dateimodus:=dateimodus or (l>200);
      if dateimodus then
        begin
          Inc(o,4);
          laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
          laenge_ausgepackt:=laenge_eingepackt;
          archiv_datei;
          archiv_datei_ausschrift(exezk);
          befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
          Inc(o,laenge_eingepackt);
        end
      else
        ausschrift_x(exezk,beschreibung,absatz);

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure gkware_selfextractor;
  begin
    ausschrift('GkWare Self Extractor [inflate]',packer_dat);
    if not langformat then Exit;

    archiv_start;

    datei_lesen(form_puffer,analyseoff+$11c,512);
    exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,$104);
    ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);

    datei_lesen(form_puffer,analyseoff+$220,512);
    exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,$100);
    ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);

    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=x_longint__datei_lesen(analyseoff+$2cc);
    exezk:='gksfx.tmp';
    archiv_datei64;
    archiv_datei_ausschrift(exezk);
    befehl_e_infla(analyseoff+$2d2,einzel_laenge-$2d2,exezk);

    archiv_summe;
  end;

procedure gkware_selfextractor_tmp;
  var
    o:longint;
  begin
    ausschrift('GkWare Self Extractor [tmp:inflate]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$10c+8);
      Inc(o,$10c);
      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,$104);
      laenge_eingepackt:=longint_z(@form_puffer.d[$104])^;
      if exezk[Length(exezk)]<>'_' then
        begin
          laenge_ausgepackt:=laenge_eingepackt;
          befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
        end
      else (* inflate *)
        begin
          rate_dateinamenserweiterung(exezk,'');
          laenge_ausgepackt:=longint_z(@form_puffer.d[$10c+4])^;
          befehl_e_infla(analyseoff+o+8+2,laenge_eingepackt-8-2,exezk);
        end;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      Inc(o,laenge_eingepackt);
    until (o>=einzel_laenge) or (o<0);
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;

  end;

procedure gkware_bin_tiefe3;
  var
    o,kl        :longint;
    pfad        :string;
  begin
    ausschrift('GkWare setup.da_',packer_dat);
    if not langformat then Exit;

    if bytesuche__datei_lesen(analyseoff+$72,'NORMAL'#$00) then
      begin
        o:=x_longint__datei_lesen(analyseoff+$72+$28); (* "normal"/"system"/.. *)
        kl:=$140;
      end
    else
    if bytesuche__datei_lesen(analyseoff+$100,'NORMAL'#$00) then
      begin
        o:=x_longint__datei_lesen(analyseoff+$100+$28); (* "normal"/"system"/.. *)
        kl:=$128;
      end
    else
      begin
        ausschrift('? ¯',dat_fehler);
        Exit;
      end;

    archiv_start;
    pfad:='';
    repeat
      datei_lesen(form_puffer,analyseoff+o,kl);
      Inc(o,kl);

      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,$104);
      if exezk='..' then
        begin
          repeat
            if pfad='' then Break;
            Dec(pfad[0]);
            if pfad='' then Break;
          until pfad[Length(pfad)]='\';
          Continue;
        end;

      exezk:=pfad+exezk;
      exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
      case kl of
        $140:laenge_eingepackt:=longint_z(@form_puffer.d[$12c])^;
        $128:laenge_eingepackt:=longint_z(@form_puffer.d[$120])^;
      else
        RunError(99);
      end;
      laenge_ausgepackt:=laenge_eingepackt;

      if (form_puffer.d[$104] and $10)=$10 then
        begin
          archiv_datei;
          archiv_datei_ausschrift_verzeichnis(exezk);
          pfad:=pfad+puffer_zu_zk_e(form_puffer.d[0],#0,$104);
          befehl_mkdir(pfad);
          pfad:=pfad+'\';
        end
      else
        begin
          befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
          archiv_datei;
          archiv_datei_ausschrift(exezk);
        end;

      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure multics_archive;
  var
    o:dateigroessetyp;
  begin
    ausschrift('Multics Archive'(*OS/2:Peter Flass*),packer_dat);
    if not langformat then Exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$64);
      if not bytesuche(form_puffer.d[0],#$0C#$0A#$0A#$0A#$0F#$0A#$09#$09) then
        Break;

      exezk:=leer_filter(puffer_zu_zk_l(form_puffer.d[$c],32));
      laenge_eingepackt64:=ziffer(10,puffer_zu_zk_l(form_puffer.d[$54],8));
      (*$IfDef dateigroessetyp_comp*)
      laenge_eingepackt64:=DivDGT(laenge_eingepackt,36)*4; (* 9->36 Bit "Wort" *)
      (*$Else*)
      laenge_eingepackt64:=(laenge_eingepackt div 36)*4; (* 9->36 Bit "Wort" *)
      (*$EndIf*)
      laenge_ausgepackt64:=laenge_eingepackt;
      archiv_datei64;
      archiv_datei_ausschrift(exezk);
      IncDGT(o,$64);
      befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
      IncDGT(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
    einzel_laenge:=o;
  end;

procedure bcomp(anzahl:word_norm);
  var

    o:longint;
  begin
    ausschrift('BComp / Bruno RIVIERE',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=4;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        laenge_ausgepackt:=longint_z(@form_puffer.d[4])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[8])^;
        exezk:=puffer_zu_zk_pstr(form_puffer.d[12]);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,laenge_eingepackt);
        Dec(anzahl);
      end;
    archiv_summe;
  end;

procedure ictselfx;
  var
    o,l:longint;
  begin
    ausschrift(in_doppelten_anfuerungszeichen('Intelligent Compression Technologies'),packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=8;

    (* Zielverzeichnis *)
    datei_lesen(form_puffer,analyseoff+o,4+255);
    ausschrift_x(puffer_zu_zk_l(form_puffer.d[4],Min(255,longint_z(@form_puffer.d[0])^)),beschreibung,absatz);
    Inc(o,4+longint_z(@form_puffer.d[0])^);

    (* unbekannt *)
    datei_lesen(form_puffer,analyseoff+o,4+255);
    Inc(o,4+longint_z(@form_puffer.d[0])^);

    (* PrÅfsumme? (8) *)
    datei_lesen(form_puffer,analyseoff+o,4+255);
    Inc(o,4+longint_z(@form_puffer.d[0])^);

    (* Dateinamen *)
    datei_lesen(form_puffer,analyseoff+o,4);
    l:=longint_z(@form_puffer.d[0])^;
    Inc(o,4);
    while l>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,256);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
        laenge_eingepackt:=-1;
        laenge_ausgepackt:=-1;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,Length(exezk)+1);
        Dec(l,Length(exezk)+1);
      end;
    Inc(o,11);
    datei_lesen(form_puffer,analyseoff+o,256);
    archiv_summe_eingepackt:=longint_z(@form_puffer.d[4])^;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe_ausgepackt:=longint_z(@form_puffer.d[0])^;
    archiv_summe_ausgepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure dca(const p:puffertyp);
  var
    o,l:longint;
  begin
    if not p.d[3] in [0..10] then Exit;
    ausschrift('DCA /?',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=13;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      l:=longint_z(@form_puffer.d[$1])^ and $ffff;
      exezk:=puffer_zu_zk_l(form_puffer.d[$e],Min(255,Max(0,l-9)));
      Inc(o,1+4+l);
      if (form_puffer.d[$1+3] and $80)=$80 then
        begin
          datei_lesen(form_puffer,analyseoff+o,8);
          laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
          laenge_ausgepackt:=longint_z(@form_puffer.d[4])^;
          Inc(o,7);
          archiv_datei;
          archiv_datei_ausschrift(exezk);
        end
      else
        begin
          laenge_eingepackt:=0;
          laenge_ausgepackt:=0;
          Inc(o,2);
          archiv_datei;
          archiv_datei_ausschrift_verzeichnis(exezk);
        end;

      Inc(o,laenge_eingepackt);
    until (o>=einzel_laenge);
    archiv_summe;
  end;

procedure pklite_unix(const p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('PKLite for Unix / PKWARE',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    while o<einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        (*ausschrift(hex_longint(o),normal);*)

        if bytesuche(form_puffer.d[0],'PK') then
          begin
            if not bytesuche(form_puffer.d[0],'PK'#$09#$09) then
             begin
               einzel_laenge:=o;
               Break;
             end;

            laenge_ausgepackt:=-1;(*longint_z(@form_puffer.d[$c])^;*)
            laenge_eingepackt:=longint_z(@form_puffer.d[$8])^;
            archiv_datei;
            archiv_datei_ausschrift('');
            Inc(o,$14);
            (*befehl_e_infla(analyseoff+o,laenge_eingepackt,hex_longint(o));*)
            Inc(o,laenge_eingepackt);
          end
        else
          begin
            ansi_anzeige(analyseoff+o+4,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,falsch,
                         analyseoff+o+4+longint_z(@form_puffer.d[0])^,'');
            Inc(o,4+longint_z(@form_puffer.d[0])^);
          end;
      end;
    archiv_summe;
  end;

procedure seau(const o0,l:dateigroessetyp;const p:puffertyp);
  var
    i,anzahl:longint;
  begin
    ausschrift('Self-Extracting Archive Utility / Gammadyne Software',packer_dat);
    if not langformat then Exit;

    archiv_start;
    anzahl:=longint_z(@p.d[$18])^;
    for i:=1 to anzahl do
      begin
        laenge_eingepackt:=-1;
        laenge_ausgepackt:=x_longint__datei_lesen(o0+$20+i*4);
        archiv_datei;
        archiv_datei_ausschrift('?');
      end;
    archiv_summe_eingepackt:=l;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure squez4(const p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('Squeez / Rainer Nausedat'+version_einstellig(p.d[3]),packer_dat);
    if not langformat then Exit;

    o:=5+word_z(@p.d[5])^;
    archiv_start;
    while o<einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_l(form_puffer.d[$1e],Min(word_z(@form_puffer.d[$1c])^,255));
        laenge_eingepackt:=longint_z(@form_puffer.d[$14])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[$18])^;
        if laenge_eingepackt<0 then
          begin
            ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
            Break;
          end;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,word_z(@form_puffer.d[$0])^+laenge_eingepackt);
      end;
    archiv_summe;
  end;

procedure Siebenzip_install_text;
  var
    o:dateigroessetyp;
  begin
    o:=datei_pos_suche(analyseoff,analyseoff+MinDGT(einzel_laenge,8000),';!@InstallEnd@!');
    if o<>nicht_gefunden then
      begin
        einzel_laenge:=o-analyseoff+Length(';!@InstallEnd@!');
        if bytesuche__datei_lesen(analyseoff+einzel_laenge,#$0d#$0a) then
          IncDGT(einzel_laenge,Length(#$0d#$0a));
      end;

    o:=datei_pos_suche(analyseoff,analyseoff+MinDGT(einzel_laenge,8000),'Title="');
    if o<>nicht_gefunden then
      begin
        datei_lesen(form_puffer,o+Length('Title="'),512);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],'"',255);
        ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
      end;
  end;

procedure siebenzip;
  begin
    ausschrift('7-Zip / Igor Pavlov',packer_dat);
    if not langformat then Exit;

    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    (* ? *)
  end;

procedure wise_pw_msi(const o,l:dateigroessetyp);
  var
    anzahl,z            :longint;
    i,j,posi            :dateigroessetyp;

  procedure bearbeite(const o,l:dateigroessetyp);
    begin
      datei_lesen(form_puffer,o,10);
      Inc(anzahl);
      exezk:='WISE'+str0(anzahl)+'.';
      if bytesuche(form_puffer.d[0],'MZ') then
        exezk_anhaengen('EXE')
      else
      if bytesuche(form_puffer.d[0],#$d0#$cf) then
        exezk_anhaengen('MSI')
      else
        exezk_anhaengen('DAT');
      laenge_eingepackt64:=l;
      laenge_ausgepackt64:=l;
      archiv_datei64;
      archiv_datei_ausschrift(exezk);
      befehl_schnitt(o,l,exezk);
    end; (* bearbeite *)

  begin (* wise_pw_msi *)
    ausschrift('WISE Setup <PE .WISE,MSI>',packer_dat);
    if not langformat then Exit;

    archiv_start;
    i:=l;
    (* Aufruf von: typ_xexe  '.wise' *)


    (* l-LÑnge EXE1 -LÑnge EXE2 *)
    for z:=1 to 2 do
      begin
        datei_lesen(form_puffer,o+$10+z*4,4);
        j:=longint_z(@form_puffer.d[0])^;
        DecDGT(i,j);
      end;
    datei_lesen(form_puffer,o+4,4);
    j:=longint_z(@form_puffer.d[0])^;
    DecDGT(i,j);

    (* Korrektur wegen FÅllnullen *)
    z:=DGT_zu_longint(MinDGT(1000,l));
    if i<z then
      i:=z;

    posi:=datei_pos_suche(o,o+i,'MZ??????'#$04#$00);
    if posi=nicht_gefunden then
      posi:=datei_pos_suche(o,o+i,#$d0#$cf#$11#$e0#$a1#$b1#$1a#$e1);
    if posi<>nicht_gefunden then
      i:=DGT_zu_longint(posi-o);

    anzahl:=0;

    datei_lesen(form_puffer,o+$14,4);
    j:=longint_z(@form_puffer.d[0])^;
    if j<>0 then
      begin
        bearbeite(o+i,j);
        IncDGT(i,j);
      end;

    datei_lesen(form_puffer,o+$04,4);
    j:=longint_z(@form_puffer.d[0])^;
    if j<>0 then
      begin
        bearbeite(o+i,j);
        IncDGT(i,j);
      end;

    datei_lesen(form_puffer,o+$18,4);
    j:=longint_z(@form_puffer.d[0])^;
    if j<>0 then
      begin
        bearbeite(o+i,j);
        IncDGT(i,j);
      end;

    archiv_summe;
  end;

procedure zupmaker;
  var
    o:longint;
  begin
    (* Vorsicht: inflate-Blîcke kînnen mehr als eine Datei enthallten *)
    ausschrift('Z-Up Maker / Ingo Bordasch [+inflate**]',packer_dat);
    if not langformat then Exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$104);
      exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);

      (* if exezk[1]='0' then
        if ziffer(10,exezk)=analyseoff then Break;*)
      if o+1+Length(exezk)=einzel_laenge then Break;

      laenge_eingepackt:=longint_z(@form_puffer.d[$100])^;
      laenge_ausgepackt:=laenge_eingepackt;
      Inc(o,$104);

      datei_lesen(form_puffer,analyseoff+o,10);

      befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
      if not bytesuche(form_puffer.d[0],'MZ') then
        befehl_e_infla(analyseoff+o+2,laenge_eingepackt-2,exezk+'~');

      archiv_datei;
      archiv_datei_ausschrift(exezk);

      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure ifah;
  var
    o:longint;
  begin
    ausschrift('<IFAH/?> [inflate]',packer_dat);
    einzel_laenge:=x_longint__datei_lesen(analyseoff+4)-analyseoff;
    if not langformat then Exit;

    (* IFAH=archive header? *)
    (* IFFH=file header?    *)
    (* IFII=installinfo?    *)
    (* IFPI=programinfo?    *)
    (* IFWB=bitmap?         *)

    archiv_start;
    o:=$11;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$120);
      if bytesuche(form_puffer.d[0],'IFFH') then
        begin
          laenge_eingepackt:=longint_z(@form_puffer.d[8])^;
          laenge_ausgepackt:=longint_z(@form_puffer.d[4])^;
          exezk:=puffer_zu_zk_pstr(form_puffer.d[$1c]);
          archiv_datei;
          archiv_datei_ausschrift(exezk);
          Inc(o,$1d+Length(exezk));
          befehl_mkdir_fuer_datei(exezk);
          befehl_e_infla(analyseoff+o,laenge_eingepackt,exezk);
          Inc(o,laenge_eingepackt);
        end
      else
       Break;
    until (o>=einzel_laenge) or (o<0);
    archiv_summe;

  end;

procedure ashampoo_rawdata(const o,l:dateigroessetyp);
  begin
    ausschrift('Ashampoo RAWDATA [inflate]',packer_dat);
    if not langformat then Exit;

    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    befehl_e_infla(o+$1c+2,l-$1c-2,'as_part1');
    (* tyx.cmd benutzen ... *)
  end;

procedure progressive_setup(const p:puffertyp;bz2:dateigroessetyp);
  var
    o,o2:dateigroessetyp;
  begin

    if bz2=-1 then
      begin
        bz2:=datei_pos_suche(analyseoff,analyseoff+MinDGT(einzel_laenge,10000),'BZh?1A');
        if bz2=nicht_gefunden then Exit;
        DecDGT(bz2,analyseoff);
      end;

    ausschrift('Progressive Setup / ? [bzip2]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    befehl_bzip2_d(analyseoff+bz2,einzel_laenge-bz2,'temp_bz2.x');
    o:=0;
    o2:=0;
    datei_lesen(form_puffer,analyseoff+o,512);
    if bytesuche(form_puffer.d[0],'PSA???'#$00) then
      IncDGT(o,Length('PSA'));
    IncDGT(o,4+Length('FILES'));
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if bytesuche(form_puffer.d[0],'CDATA') then
        begin (* "compressed data"? *)
          IncDGT(o,5+4+4+longint_z(@form_puffer.d[5])^);
          einzel_laenge:=o;
          Break;
        end;
      exezk:=puffer_zu_zk_l(form_puffer.d[2],Min(255,word_z(@form_puffer.d[0])^));
      IncDGT(o,2+word_z(@form_puffer.d[0])^);
      datei_lesen(form_puffer,analyseoff+o,4);
      laenge_eingepackt:=-1;
      laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
      IncDGT(o,4);
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      befehl_schnitt2('temp_bz2.x',o2,laenge_ausgepackt,exezk);
      IncDGT(o2,laenge_ausgepackt);
    until o>=bz2;
    befehl_del('temp_bz2.x');
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure trillian_install_program;
  var
    anzahl,o,o2:longint;
  begin (* normalerweise mit bzip2 gepackt *)
    ausschrift('Trillian Install Program',packer_dat);
    if not langformat then Exit;

    archiv_start;
    anzahl:=x_longint__datei_lesen(analyseoff+0);
    o:=4;
    o2:=4+anzahl*$108;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,$108);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
        laenge_eingepackt:=longint_z(@form_puffer.d[$104])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,$108);
        Dec(anzahl);
        befehl_schnitt(analyseoff+o2,laenge_eingepackt,exezk);
        Inc(o2,laenge_eingepackt);
      end;
    archiv_summe;
   end;

procedure lzop;
  begin
    ausschrift('LZOP / Markus F.X.J. Oberhumer',packer_dat);
    if not langformat then Exit;

    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
    (* vermutlich auch nie *)
  end;

procedure bee;
  var
    o,e:dateigroessetyp;
    z:word_norm;
  begin
    ausschrift('Bee / Andrew Filinsky',packer_dat); (* 074 *)
    if not langformat then Exit;

    o:=$33;
    archiv_start;
    e:=MaxDGT(x_longint__datei_lesen(analyseoff+o+$14),o);
    e:=MinDGT(e,einzel_laenge);
    z:=0;
    repeat
      Inc(z);
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_ausgepackt:=longint_z(@form_puffer.d[$00])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$10])^;
      exezk:=puffer_zu_zk_l(form_puffer.d[$1c],Min(255,Max(0,longint_z(@form_puffer.d[$18])^)));
      if (laenge_ausgepackt<laenge_eingepackt)
      or (laenge_ausgepackt<0)
      or (laenge_eingepackt<0)
      or (laenge_eingepackt>500000000)
      or (not bytesuche(form_puffer.d[$08],'?'#$00#$00#$00))
      or (not bytesuche(form_puffer.d[$18],'?'#$00#$00#$00))
      or (not ist_ohne_steuerzeichen_nicht_so_streng(exezk))
      or (Length(exezk)=0)
       then
        begin
          (*ausschrift('?',normal);*)
          IncDGT(o,+43); (* oder +1 *)
          Continue;
        end;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      IncDGT(o,$18+4+longint_z(@form_puffer.d[$18])^+1);
    until o>=e;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure p12_p5_p6(const p:puffertyp);
  var
    o:dateigroessetyp;

  procedure ueberspringe_leerzeichen;
    begin
      while o<einzel_laenge do
        begin
          datei_lesen(form_puffer,analyseoff+o,1);
          if form_puffer.d[0] in [Ord(' '),13,10] then
            IncDGT(o,1)
          else
            Break;
        end;
    end;
  begin
    ausschrift('paq1,p12,p5,p6 / Matt Mahoney',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=puffer_pos_suche(p,#$0a,20)+1;
    repeat
      ueberspringe_leerzeichen;
      datei_lesen(form_puffer,analyseoff+o,20);
      if form_puffer.d[0]=$1a then Break;
      exezk:=puffer_zu_zk_e(form_puffer.d[0],' ',20);
      IncDGT(o,Length(exezk));
      ueberspringe_leerzeichen;
      laenge_ausgepackt64:=ziffer(10,exezk);
      laenge_eingepackt64:=-1;
      datei_lesen(form_puffer,analyseoff+o,512);
      exezk:=puffer_zu_zk_zeilenende(form_puffer.d[0],255);
      IncDGT(o,Length(exezk));
      archiv_datei64;
      archiv_datei_ausschrift(exezk);
    until false;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;

    archiv_summe;
  end;

procedure qlfc;
  var
    o:longint;
  begin (* qlfc6_6w.rar *)
    ausschrift('Quantized Local Frequency Coding / Ghido Florin Valentin',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=5;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      exezk:=puffer_zu_zk_l(form_puffer.d[2],Min(word_z(@form_puffer.d[0])^,255));
      if word_z(@form_puffer.d[0])^=0 then Break;
      Inc(o,2+word_z(@form_puffer.d[0])^);
      datei_lesen(form_puffer,analyseoff+o,8);
      laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
      Inc(o,8+4+laenge_eingepackt);
      archiv_datei;
      archiv_datei_ausschrift(exezk);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure ENhanced_Compressor; (* enc015.zip *)
  var
    o:longint;
  begin (* v0.15 (Feb 14 2003) *)
    ausschrift('ENhanced Compressor / Enchanter',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=7;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
      exezk:=puffer_zu_zk_pstr(form_puffer.d[12]);
      Inc(o,15+form_puffer.d[12]+laenge_eingepackt);
      archiv_datei;
      archiv_datei_ausschrift(exezk);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure optimfrog;
  var
    o:longint;
  begin
    ausschrift('OptimFROG Lossless WAVE Audio Coder / Florin Ghido',packer_dat);
    if not langformat then Exit;

    o:=0;
    exezk:=erzeuge_neuen_dateinamen('.wav');
    archiv_start_leise;
    laenge_ausgepackt:=-1;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$14);
      if bytesuche(form_puffer.d[0],'HEAD') then
        laenge_ausgepackt:=4+4+longint_z(@form_puffer.d[12])^;
      Inc(o,4+4+longint_z(@form_puffer.d[4])^);
    until (o>=einzel_laenge) or bytesuche(form_puffer.d[0],'TAIL');
    einzel_laenge:=o;
    laenge_eingepackt:=o;
    archiv_datei;
    archiv_datei_ausschrift(exezk);
    archiv_summe_leise;
  end;

procedure dbsoft_header(const p:puffertyp);
  var
    dbsoft_naechster_block:dateigroessetyp;
    w1,w2                 :word_norm;
    dbsoft                :string[Length('DBSOFT-')];
  begin
    (* entweder SXINST oder DBSOFT *)
    dbsoft:=puffer_zu_zk_l(p.d[0],Length('DBSOFT-'));
    (* OS/2, KOPF mit Installationsdaten ACE *)
    ausschrift('DBSOFT Installer / Brian Smith',packer_dat);
    with p do
      begin
        w1:=Length('DBSOFT-HEADER');
        w2:=w1;
        while (w2<g-10) and (d[w2]<>Ord('-')) do
          Inc(w2);
        ausschrift(puffer_zu_zk_l(d[w1],w2-w1),beschreibung);

        w1:=w2+1;
        w2:=w1;
        while (w2<g-10) and (d[w2]<>Ord('-')) do
          Inc(w2);
        ausschrift(puffer_zu_zk_l(d[w1],w2-w1),beschreibung);

        dbsoft_naechster_block:=datei_pos_suche(analyseoff+w2,analyseoff+einzel_laenge,{'DBSOFT-'}dbsoft);
        if dbsoft_naechster_block<>nicht_gefunden then
          einzel_laenge:=dbsoft_naechster_block-analyseoff;
      end;
  end;

procedure dbsoft_ace(const p:puffertyp);
  var
    w1                  :word_norm;
    kennung             :string;
    archivlaenge        :dateigroessetyp;
  begin
    with p do
      begin
        (* LÑnge des Folgenden ACE-Archivs als Text *)
        (* beendet mit '~' oder ';' je nach Version ..*)
        w1:=Length('DBSOFT-ACE');
        while (w1<g) and (not (d[w1] in [Ord('~'),Ord(';')])) do
          Inc(w1);

        kennung:=puffer_zu_zk_l(d[0],w1);
        ausschrift(kennung,beschreibung);
        einzel_laenge:=w1+1;
        w1:=Length(kennung);
        while (w1>=3) and (kennung[w1]<>'-') do
          Dec(w1);
        archivlaenge:=ziffer(10,Copy(kennung,w1+1,255));
        merke_position(analyseoff+einzel_laenge+archivlaenge,datentyp_unbekannt);
        if Pos('-ZIP',kennung)>0 then
          befehl_schnitt(analyseoff+einzel_laenge,archivlaenge,kennung+'.zip');
      end;
  end;

procedure rkau(const p:puffertyp);
  begin
    ausschrift('RK Audio / Malcolm Taylor [1.'+Chr(p.d[3])+']',packer_dat);
    archiv_start_leise;
    laenge_eingepackt:=longint_z(@p.d[$10])^;
    laenge_ausgepackt:=longint_z(@p.d[$04])^;
    archiv_datei;
    archiv_datei_ausschrift(erzeuge_neuen_dateinamen('.wav'));
    archiv_summe_leise;
  end;

procedure tnef;
  var
    o,l                 :dateigroessetyp;
    blockid,blocktyp    :word_norm;
    dateiname           :string;
    blockmodus          :(modus_frei,modus_habe_name,modus_habe_daten,modus_habe_beides);
    daten_anfang        :dateigroessetyp;
    daten_laenge        :dateigroessetyp;
    name_voll           :boolean;

  (* -$Define tnef_debug*)

  procedure loesche_daten;
    begin
      blockmodus:=modus_frei;
      dateiname:='';
      daten_anfang:=-1;
      daten_laenge:=-1;
      name_voll:=false;
    end;


  procedure schreibe_daten;
    begin
      laenge_eingepackt64:=daten_laenge;
      laenge_ausgepackt64:=daten_laenge;
      if dateiname='' then
        begin
          dateiname:=hex_DGT(daten_anfang)+'.dat';
          Delete(dateiname,1,Length('$'));
        end;
      archiv_datei64;
      archiv_datei_ausschrift(dateiname);
      befehl_schnitt(daten_anfang,daten_laenge,dateiname);
      loesche_daten;
    end;

  procedure flush;
    begin
      if blockmodus in [modus_habe_daten,modus_habe_beides] then
        schreibe_daten;
      loesche_daten;
    end;

  procedure merke_namen(const dname:string;const voll:boolean);
    begin
      case blockmodus of
        modus_frei:
          begin
            dateiname:=dname;
            name_voll:=voll;
            blockmodus:=modus_habe_name;
          end;

        modus_habe_beides,
        modus_habe_name:
          begin
            if dname<>'' then
              if not name_voll then (* bedingt, wenn besserer name? *)
                begin
                  dateiname:=dname;
                  name_voll:=voll;
                end;
          end;

        modus_habe_daten:
          begin
            if dname<>'' then
              if not name_voll then (* bedingt, wenn besserer name? *)
                dateiname:=dname; (* bedingt, wenn besserer name? *)
            blockmodus:=modus_habe_beides;
          end;

      end;
    end;

  procedure merke_daten(const o,l:dateigroessetyp);
    begin

      if (o<=analyseoff) or (o>=analyseoff+einzel_laenge) then Exit;
      if l<0 then Exit;
      if o+l>analyseoff+einzel_laenge then Exit;

      case blockmodus of
        modus_frei:
          begin
            daten_anfang:=o;
            daten_laenge:=l;
            blockmodus:=modus_habe_daten;
          end;

        modus_habe_name:
          begin
            daten_anfang:=o;
            daten_laenge:=l;
            blockmodus:=modus_habe_beides;
          end;

        modus_habe_beides,
        modus_habe_daten:
          begin
            schreibe_daten;
            daten_anfang:=o;
            daten_laenge:=l;
            blockmodus:=modus_habe_daten;
          end;

      end;
    end;


  procedure attachment(const o0,l:dateigroessetyp);
    var
      o                 :dateigroessetyp;
      ap                :puffertyp;
    begin
      o:=4;
      while (o<l) and (o>=4) do
        begin
          datei_lesen(ap,analyseoff+o0+o,512);

          (*$IfDef tnef_debug*)
          ausschrift(hex_longint(o)+' : '+hex_word(word_z(@ap.d[0])^)+'/'+hex_word(word_z(@ap.d[2])^),normal);
          (*$EndIf tnef_debug*)

          if word_z(@ap.d[0])^=$1e then
            begin
              if word_z(@ap.d[2])^=$3001 then (* display name *)
                merke_namen(puffer_zu_zk_e(ap.d[$c],#0,longint_z(@ap.d[8])^),true);
              if word_z(@ap.d[2])^=$3704 then (* attachment name *)
                merke_namen(puffer_zu_zk_e(ap.d[$c],#0,longint_z(@ap.d[8])^),true);
            end;

          if word_z(@ap.d[0])^=$102 then (* bin *)
            begin
              case word_z(@ap.d[2])^ of
              {
                $3702: (* Daten *) (* Åberhaupt benutzt? istt scheinbar immer 0 byte *)
                  begin
                    (*$IfDef tnef_debug*)
                    ausschrift_x('bin/daten!<'+str0(longint_z(@ap.d[4+4])^),normal,absatz);
                    (*$EndIf tnef_debug*)
                    merke_daten(analyseoff+o0+o+$18,longint_z(@ap.d[4+4])^-$18);
                  end; }
                $3701: (* attach data obj *) (* MAPI_ATTACH_DATA_OBJ.tnef:C31 *)
                  begin
                    (*$IfDef tnef_debug*)
                    ausschrift_x('bin/obj!<'+str0(longint_z(@ap.d[4+4])^),normal,absatz);
                    (*$EndIf tnef_debug*)
                    merke_daten(analyseoff+o0+o+$0c,longint_z(@ap.d[4+4])^    );
                  end;
              else
                (*$IfDef tnef_debug*)
                ausschrift_x('bin/?<'+str0(longint_z(@ap.d[4+4])^),normal,absatz);
                (*$EndIf tnef_debug*)
              end;
            end
          else
          if word_z(@ap.d[0])^=$000d then (* embedded object *)
            begin
              if (word_z(@ap.d[2])^=$3701) then (* attach data obj *) (* MAPI_OBJECT.tnef:991 *)
                begin
                  (*$IfDef tnef_debug*)
                  ausschrift_x('obj/attach!<'+str0(longint_z(@ap.d[4+4])^),normal,absatz);
                  (*$EndIf tnef_debug*)
                  merke_daten(analyseoff+o0+o+$0c+$10,longint_z(@ap.d[4+4])^-$10);
                end;
            end;

          IncDGT(o,2+2);


          case word_z(@ap.d[0])^ of
            $0000: (* unspecified *)
              IncDGT(o,0);
            $0002: (* smallint *)
              IncDGT(o,2);
            $0003: (* longint *)
              IncDGT(o,4);
            $0006, (* currency *)
            $0040: (* time *)
              IncDGT(o,8);
            $000d, (* embedded object *)
            $001e, (* string *)
            $0102: (* binary *)
              IncDGT(o,4+4+longint_z(@ap.d[4+4])^);
          else (* unbekannt *)
            (*$IfDef tnef_debug*)
            ausschrift('>??',dat_fehler);
            (*$EndIf tnef_debug*)
            Break;
          end;

          o:=AndDGT(o+4-1,-4);
        end;

      flush;
    end;


  begin (* tnef *)
    ausschrift('Transport Neutral Encapsulation Format / MS',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=6;
    loesche_daten;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      IncDGT(o,1+2+2+4);
      blockid :=word_z(@form_puffer.d[1])^;
      blocktyp:=word_z(@form_puffer.d[3])^;
      l:=longint_z(@form_puffer.d[5])^;

      (*$IfDef tnef_debug*)
      ausschrift('LVL:'+hex(form_puffer.d[0])+' ID:'+hex_word(blockid)+' TYP:'+hex_word(blocktyp)+' L:'+hex_longint(l),normal);
      (*$EndIf tnef_debug*)

      case blockid of
        $8010: (* attachment name *)
          begin
            if blocktyp=1 then (* /string *)
              merke_namen(puffer_zu_zk_e(form_puffer.d[9],#0,DGT_zu_longint(MinDGT(l,255))),false);
          end;

        $800f: (* attachment data *) (* one-file.tnef:70f*)
          begin (* / normalerweise 6:byte *)
            (*$IfDef tnef_debug*)
            ausschrift('::data ('+str0(l)+')',normal);
            (*$EndIf tnef_debug*)
            merke_daten(analyseoff+o,l);
          end;

        $8000: (* from *)
          if blocktyp=1 then (* /string *)
            ausschrift('From     '+puffer_zu_zk_e(form_puffer.d[9],#0,DGT_zu_longint(MinDGT(l,255))),beschreibung);

        $8004: (* subject *)
          if blocktyp=1 then (* /string *)
            ausschrift('Subject: '+puffer_zu_zk_e(form_puffer.d[9],#0,DGT_zu_longint(MinDGT(l,255))),beschreibung);

        $9005:
          begin
            attachment(o,l);
          end;

      end;

      IncDGT(o,l);
      IncDGT(o,2);
    until o>=einzel_laenge;
    flush;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure versuche_Basic_Linker(const p:puffertyp);
  var
    anzahl,i,j          :word_norm;
    o                   :dateigroessetyp;
  begin
    anzahl:=0;
    repeat
      o:=word_z(@p.d[2*anzahl])^ xor $6666;
      if o=$ffff then Break;
      if (o<analyseoff) or (o>=dateilaenge) then Exit;
      Inc(anzahl);
    until anzahl>=100;

    if (anzahl<1) or (anzahl>=100) then Exit;

    ausschrift('Basic Linker / Troels Windfeldt Hansen [2.0]',packer_exe);
    if not langformat then Exit;

    archiv_start;
    o:=analyseoff+2*(anzahl+1);
    for i:=1 to anzahl do
      begin
        datei_lesen(form_puffer,o,4+4+1+255);
        for j:=0 to 4+4+1+255-1 do
          form_puffer.d[j]:=form_puffer.d[j] xor $66;
        laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk:=puffer_zu_zk_pstr(form_puffer.d[8]);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(longint_z(@form_puffer.d[4])^,laenge_eingepackt,exezk);
        merke_position(longint_z(@form_puffer.d[4])^                  ,datentyp_unbekannt);
        merke_position(longint_z(@form_puffer.d[4])^+laenge_eingepackt,datentyp_unbekannt);
        if i=1 then
          einzel_laenge:=longint_z(@form_puffer.d[4])^-analyseoff;
        IncDGT(o,4+4+1+Length(exezk));
      end;
    archiv_summe;
  end;

procedure COMPACKR;
  var
    o:dateigroessetyp;
  begin
    ausschrift('COMPACKR / ?',packer_exe); (* packcom.zip *)
    if not langformat then Exit;

    o:=datei_pos_suche(analyseoff,analyseoff+DGT_zu_longint(MinDGT(1000,einzel_laenge)),#$b7#$ff#$8b#$c3#$5b#$8b#$4f#$08
       +#$8d#$77#$0a#$bf#$00#$01#$89#$3e#$fe#$00#$ff#$26);
    if o=nicht_gefunden then Exit;

    IncDGT(o,$16);

    archiv_start;
    while o<einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,8+2);
        IncDGT(o,8+2);
        if bytesuche(form_puffer.d[0],'  EOF') then Break;
        laenge_eingepackt:=word_z(@form_puffer.d[8])^;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk:=puffer_zu_zk_l(form_puffer.d[0],8);
        exezk:=leer_filter(exezk);
        exezk_anhaengen('.com');
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
        IncDGT(o,laenge_eingepackt);
      end;
    archiv_summe;

  end;

procedure vise_updater;
  var
    o                   :longint;
    anzahl              :word_norm;

  procedure ueberspringe_pstr;
    begin
      datei_lesen(form_puffer,analyseoff+o,1);
      form_puffer.d[0]:=form_puffer.d[0] and $7f;
      Inc(o,1+form_puffer.d[0]);
    end;

  begin
    ausschrift('Updater VISE / MindVision Software',packer_dat);
    if not langformat then Exit;

    o:=4;
    archiv_start;
    datei_lesen(form_puffer,analyseoff+o,512);
    form_puffer.d[0]:=form_puffer.d[0] and $7f;
    ausschrift_x(puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung,absatz);
    Inc(o,1+form_puffer.d[0]);
    datei_lesen(form_puffer,analyseoff+o,512);
    form_puffer.d[0]:=form_puffer.d[0] and $7f;
    ausschrift_x(puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung,absatz);
    Inc(o,1+form_puffer.d[0]);
    ueberspringe_pstr; (* english.ulg *)
    ueberspringe_pstr; (* *)
    ueberspringe_pstr; (* readme.txt *)
    ueberspringe_pstr; (* update 1.10.upd *)
    anzahl:=0;
    repeat

      if anzahl=0 then
        begin
          datei_lesen(form_puffer,analyseoff+o,1);
          Inc(o);
          anzahl:=form_puffer.d[0];
          Continue;
        end;

      datei_lesen(form_puffer,analyseoff+o,256);
      exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
      Inc(o,1+form_puffer.d[0]);
      datei_lesen(form_puffer,analyseoff+o,4);
      Inc(o,4);
      laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
      laenge_ausgepackt:=-1{laenge_eingepackt};
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      Inc(o,laenge_eingepackt);
      Dec(anzahl);
    until o+8+4>=einzel_laenge;
    archiv_summe;
  end;

procedure exp1;
  var
    o,e,s,datenende:dateigroessetyp;
  begin
    ausschrift('Experimental archiver / Bulat Ziganshin [1] [BZip2]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    e:=analyseoff+einzel_laenge-$14;
    datenende:=e-x_longint__datei_lesen(e);
    o:=datenende+$10;

    while o<e do
      begin
        datei_lesen(form_puffer,o,256);
        s:=o;
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
        IncDGT(o,Length(exezk)+1);
        datei_lesen(form_puffer,o,13);
        IncDGT(o,13);
        DecDGT(s,longint_z(@form_puffer.d[9])^);
        laenge_ausgepackt64:=longint_z(@form_puffer.d[5])^;
        if o>=e then
          laenge_eingepackt64:=datenende-s
        else
          begin
            datei_lesen(form_puffer,o,256);
            laenge_eingepackt64:=o-longint_z(@form_puffer.d[puffer_pos_suche(form_puffer,#0,255)+1+9])^-s;
          end;


        archiv_datei64;
        archiv_datei_ausschrift(exezk);

        (*befehl_bzip2_d(s,laenge_eingepackt64,exezk);*)
      end;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure LSP_SFX_Builder;
  var
    o:longint;
  begin
    (* Format ist zip-Ñhnlich *)
    ausschrift('LSP SFX-Builder / Friedrich Linder jr.',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'FL'#$03#$04) then Break;
      exezk:=puffer_zu_zk_l(form_puffer.d[$28],form_puffer.d[$24]);
      laenge_eingepackt:=longint_z(@form_puffer.d[$12])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$16])^;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      Inc(o,$28);
      Inc(o,form_puffer.d[$24]); (* vielleicht 16 bit *)
      Inc(o,form_puffer.d[$26]);
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    einzel_laenge:=o;
    archiv_summe;
  end;

procedure ese(const p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('<ESE> / PowerArchiver2000',packer_dat);
    einzel_laenge:=word_z(@p.d[6])^;
    if not langformat then Exit;

    o:=8;
    while o<einzel_laenge do
      begin
        datei_lesen(form_puffer,analyseoff+o,256);
        exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
        if exezk<>'' then
          ausschrift_x(exezk,beschreibung,absatz);
        Inc(o,1+form_puffer.d[0]);
      end;

  end;

procedure xact_lib(const p:puffertyp);
  var
    z,anzahl    :word_norm;
    kopflaenge  :longint;
  begin
    ausschrift('XACT LIB / SciLab',bibliothek);
    if not langformat then Exit;

    archiv_start;
    anzahl:=word_z(@p.d[4])^;
    kopflaenge:=6+anzahl*$20;
    einzel_laenge:=kopflaenge;
    for z:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+6+(z-1)*$20,$20);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,8);
        laenge_eingepackt:=longint_z(@form_puffer.d[$12])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        einzel_laenge:=MaxDGT(einzel_laenge,kopflaenge+longint_z(@form_puffer.d[$16])^+laenge_eingepackt);
        befehl_schnitt(analyseoff+kopflaenge+longint_z(@form_puffer.d[$16])^,laenge_eingepackt,exezk);
      end;
    archiv_summe;
  end;

procedure mpeg4;
  var
    tiefe:string;

  procedure mpeg4_rekursiv(o0,laenge:longint);
    var
      o,l:longint;
    begin
      o:=0;
      repeat
        datei_lesen(form_puffer,analyseoff+o0+o,512);
        l:=m_longint(form_puffer.d[0]);
        exezk:=puffer_zu_zk_l(form_puffer.d[4],4);
        ausschrift_x(tiefe+exezk+' ('+str11_oder_hex(l)+')',packer_dat,absatz);
        if exezk='ftyp' then
          ausschrift_x(tiefe+in_doppelten_anfuerungszeichen(puffer_zu_zk_e(form_puffer.d[8],#0,8))+' '
            +in_doppelten_anfuerungszeichen(puffer_zu_zk_e(form_puffer.d[8+8],#0,8)),beschreibung,leer)
        else
        if exezk='cprt' then
          ausschrift_x(tiefe+in_doppelten_anfuerungszeichen(puffer_zu_zk_e(form_puffer.d[8+4+2],#0,255)),beschreibung,leer)
        else
        if (exezk='moov')
        or (exezk='udta')
         then
          begin
            tiefe:=tiefe+'  ';
            mpeg4_rekursiv(o0+o+8,l-8);
            SetLength(tiefe,Length(tiefe)-2);
          end
        else
        if (exezk='mdat') then
          begin
            (*
            if bytesuche(form_puffer.d[8]#$ff#$d8) then
              jpeg... *)
          end;
        Inc(o,l);
      until o>=laenge;
    end;

  begin
    ausschrift('MPEG-4',musik_bild);
    tiefe:='';
    mpeg4_rekursiv(0,DGT_zu_longint(einzel_laenge));

  end;

procedure vuzip;
  begin
    ausschrift('vuZIP / Valentin Kuprovich',packer_dat);
    (* keine Ahnung *)
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
  end;

procedure gsfx;
  var
    sl,f1:dateigroessetyp;
  begin
    ausschrift('GSfx / Guillaume Di Giusto [lzh?]',packer_dat);

    if not langformat then sl:=$3800 else sl:=$10000;
    f1:=datei_pos_suche(analyseoff,analyseoff+MinDGT(sl,einzel_laenge),'MSCF???????'#$00);
    if f1<>nicht_gefunden then
      einzel_laenge:=f1-analyseoff;
  end;


procedure aialf21(const p:puffertyp);
  var
    anzahl              :longint;
    o                   :dateigroessetyp;
  begin
    anzahl:=longint_z(@p.d[5])^;
    if anzahl<1 then Exit;
    if not (p.d[2] in [0,1]) then Exit;
    if not (p.d[3] in [0,1]) then Exit; (* solid? *)
    ausschrift('Ai archivator / E.Ilya',packer_dat);
    if not langformat then Exit;

    archiv_start;
    anzahl:=longint_z(@p.d[5])^;
    o:=5+4;
    while anzahl>0 do
      begin
        Dec(anzahl);
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_l(form_puffer.d[2],Min(word_z(@form_puffer.d[0])^,255));
        IncDGT(o,2+word_z(@form_puffer.d[0])^);
        datei_lesen(form_puffer,analyseoff+o,$20);
        IncDGT(o,$20);
        laenge_eingepackt:=-1;
        laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
      end;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;

  end;

procedure pe2com(pos_name,code_laenge,exe_laenge:longint);
  begin
    ausschrift('PE-2-COM/EXE / franky^NME',packer_exe);
    if not langformat then Exit;

    archiv_start;
    exezk:=datei_lesen__zu_zk_e(analyseoff+pos_name,#0,255);
    laenge_eingepackt:=exe_laenge;
    laenge_ausgepackt:=exe_laenge;
    archiv_datei;
    archiv_datei_ausschrift(exezk);
    befehl_schnitt(analyseoff+code_laenge,exe_laenge,exezk);
    archiv_summe;
    einzel_laenge:=MinDGT(einzel_laenge,code_laenge);
    merke_position(analyseoff+code_laenge+exe_laenge,datentyp_unbekannt);
  end;

procedure nbasmc_lib;
  var
    o:longint;
  begin
    o:=x_word__datei_lesen(analyseoff+$1e);
    if (o<0) or (o>einzel_laenge) then Exit;
    if not bytesuche__datei_lesen(analyseoff+$20+o,'NB') then Exit;

    ausschrift('NewBasic Library / Forever Young Software',compiler);
    if not langformat then Exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$20);
      Inc(o,$20);
      exezk:=puffer_zu_zk_e(form_puffer.d[3],#0,13);
      laenge_eingepackt:=word_z(@form_puffer.d[$1e])^;
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure cxf(o0:longint);
  var
    o:longint;
  begin
    ausschrift('CTXf / Nikita Lesnikov',packer_dat); (* 0.69 *)
    if not langformat then Exit;

    o:=o0+8;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_eingepackt:=m_longint(form_puffer.d[$6]);
      laenge_ausgepackt:=m_longint(form_puffer.d[$2]);
      exezk:=puffer_zu_zk_pstr(form_puffer.d[$1a]);
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      Inc(o,$1b+form_puffer.d[$1a]);
    until o>=einzel_laenge;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure uharc(const p:puffertyp);
  begin
    if textdatei then Exit;
    if (p.d[3]<1) or (p.d[3]>$11) then Exit;(* nur 0.4 gesehen *)
    ausschrift('UHARC / Uwe Herklotz'+version_div16_mod16(p.d[3]),packer_dat);

    (* sicherlich nie *)
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
  end;

procedure romfs;
  var
    pfad:string;

  procedure verzeichnis(o0,e:longint);
    var
      o,dp              :longint;
      pfadlaenge        :word_norm;
    begin
      pfadlaenge:=Length(pfad);
      o:=o0;
      while o<e do
        begin
          datei_lesen(form_puffer,analyseoff+o,3*4+$f*4);
          exezk:=puffer_zu_zk_e(form_puffer.d[3*4],#0,(form_puffer.d[2*4] and $f)*4);
          laenge_eingepackt:=-1;
          laenge_ausgepackt:=longint_z(@form_puffer.d[1*4])^;

          Inc(o,3*4+(form_puffer.d[2*4] and $f)*4);
          dp:=longint_z(@form_puffer.d[2*4])^ shr 4;

          case form_puffer.d[0*4+1] shr 6 of
            1:
              begin
                pfad:=pfad+exezk+'\';
                laenge_eingepackt:=0;
                laenge_ausgepackt:=0;
                archiv_datei;
                archiv_datei_ausschrift_verzeichnis(pfad);
                verzeichnis(dp,dp+longint_z(@form_puffer.d[1*4])^);
                SetLength(pfad,pfadlaenge);
              end;
            2:
              begin
                if laenge_ausgepackt>0 then
                  laenge_eingepackt:=x_longint__datei_lesen(analyseoff+dp+((laenge_ausgepackt-1) shr 12)*4)-dp;
                archiv_datei;
                archiv_datei_ausschrift(pfad+exezk);
              end;
          else
            ausschrift('?',dat_fehler);
            Break;
          end;
        end;
    end;

  begin
    exezk:=datei_lesen__zu_zk_e(analyseoff+$10,#0,$10);
    exezk_in_doppelten_anfuerungszeichen;

    (* redhat linux *)
    ausschrift(exezk+' / ? [inflate]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    pfad:='';
    verzeichnis($40,$40+3*4+0); (* Eintrag '' *)

    (* hard links in der summe berÅcksichtigen... *)
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;
  end;


end.

