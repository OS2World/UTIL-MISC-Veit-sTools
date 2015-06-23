(*$I TYP_COMP.PAS*)

unit typ_dat2;

interface

uses
  typ_type;

procedure dat_80;
procedure dat_81;
procedure dat_83;
procedure dat_88;
procedure dat_89;
procedure dat_8a;
procedure dat_8b;
procedure dat_8d;
procedure dat_8e;
procedure dat_8f;
procedure dat_90;
procedure dat_91;
procedure dat_93;
procedure dat_95;
procedure dat_9d;
procedure dat_a4;
procedure dat_a5;
procedure dat_a8;
procedure dat_aa;
procedure dat_ac;
procedure dat_ad;
procedure dat_b0;
procedure dat_b1;
procedure dat_b2;
procedure dat_b8;
procedure dat_ba;
procedure dat_bc;
procedure dat_bd;
procedure dat_c0;
procedure dat_c4;
procedure dat_c5;
procedure dat_c6;
procedure dat_c7;
procedure dat_c8;
procedure dat_c9;
procedure dat_ca;
procedure dat_cc;
procedure dat_cd;
procedure dat_ce;
procedure dat_d0;
procedure dat_d1;
procedure dat_d4;
procedure dat_d5;
procedure dat_d7;
procedure dat_d8;
procedure dat_da;
procedure dat_de;
procedure dat_df;
procedure dat_e0;
procedure dat_e1;
procedure dat_e3;
procedure dat_e5;
procedure dat_e9;
procedure dat_eb;
procedure dat_ed;
procedure dat_ee;
procedure dat_ef;
procedure dat_f0;
procedure dat_f4;
procedure dat_f6;
procedure dat_f7;
procedure dat_f9;
procedure dat_fb;
procedure dat_fc;
procedure dat_fd;
procedure dat_fe;
procedure dat_ff;

implementation

uses
  typ_dat,
  typ_exe1, (* sekt_busch *)
  buschsuc,
  (*$IfDef ERWEITERUNGSDATEI*)
  typ_erw,
  (*$EndIf*)
  typ_eiau,
  typ_entp,
  typ_dien,
  typ_die2,
  typ_die3,
  typ_sekt,
  typ_ausg,
  typ_varx,
  typ_datx,
  typ_bios,
  typ_xexe,
  typ_eas,
  typ_spra,
  typ_for1,
  typ_for2,
  typ_for3,
  typ_for4,
  typ_for5,
  typ_var,
  typ_posm,
  typ_zeic,
  typ_cd,
  typ_ende;


var
  dat_puffer_zeiger:^puffertyp absolute typ_dat.dat_puffer_zeiger00;


(*$IfDef DPMIX*)
function bytesuche_dat_puffer_0(const s:string):boolean;
  begin
    bytesuche_dat_puffer_0:=bytesuche(dat_puffer_zeiger^.d[0],s);
  end;
(*$EndIf*)

(*$IfDef DOS_ODER_DPMI*)
function bytesuche_dat_puffer_0(const s:string):boolean;assembler;
  asm
    mov ax,seg dat_puffer_zeiger
    mov es,ax
    les di,es:[offset dat_puffer_zeiger]
    inc di (* dat_puffer_zeiger^.d *)
    inc di

    push es
      push di

        les di,s
        push es
          push di

            call typ_var.bytesuche_far
  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
function bytesuche_dat_puffer_0(const s:string):boolean;assembler;
(*$Frame+*)(*$Uses NONE*)
  asm
    mov eax,[dat_puffer_zeiger00]
    inc eax (* dat_puffer.d *)
    inc eax
    push eax
      push s
        call bytesuche
  end;
(*$EndIf*)

(*$IfDef DUMM*)
function bytesuche_dat_puffer_0(const s:string):boolean;
  begin
    bytesuche_dat_puffer_0:=bytesuche(dat_puffer_zeiger^.d[0],s);
  end;
(*$EndIf*)


procedure dat_80;
  begin
    obj(dat_puffer_zeiger^);
  end;

procedure dat_81;
  var
    x,y:longint;
  begin
    if  bytesuche_dat_puffer_0(#$81#$8a)
    and (dat_puffer_zeiger^.d[2] in [Ord('0')..Ord('2')])
     then (* PACKER! *)
      begin
        x:=word_z(@dat_puffer_zeiger^.d[$4])^;
        y:=word_z(@dat_puffer_zeiger^.d[$6])^;
        if  (1<=x) and (x<8000)
        and (1<=y) and (y<8000)
         then
          bild_format_filter('BMF / Dimitry Shkarin "'+puffer_zu_zk_l(dat_puffer_zeiger^.d[2],2)+'"',
                             x,
                             y,
                             -1,(dat_puffer_zeiger^.d[$e] and (*?$7f?*)$3f),false,true,anstrich);
      end;
  end;

procedure dat_83;
  begin
    dbase3(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$83#$cd#$8e#$d0#$bc) then
      begin
        case word_z(@dat_puffer_zeiger^.d[5])^ of
          $1cda:exezk:='Guardian 4.2';
          $2f0a:exezk:='NetSafe 4.2';
          $1312:exezk:='ZipProt 4.15';
          $123a:exezk:='NetSafe 4.15';
        else
                exezk:='? ?.?';
        end;
        ausschrift(exezk+' / NetSafe',packer_exe);
      end;
  end;

procedure dat_88;
  begin
    if bytesuche_dat_puffer_0(#$88#$07#$00#$00#$C7) then
      ausschrift('Jensen & Partners I. [Modula-2] '+textz_LIB_Kode^,compiler);
  end;

procedure dat_89;
  begin

    if bytesuche_dat_puffer_0(#$89'LZO') then
      lzop;

    if bytesuche_dat_puffer_0(#$89) (* *.sig in INTERR 5.1 *)
    and (m_word(dat_puffer_zeiger^.d[1])+3=einzel_laenge)
     then
      pgp_binaer;

    if bytesuche_dat_puffer_0(#$89'PNG'#$0d#$0a#$1a#$0a) then
      png(dat_puffer_zeiger^);

  end;

procedure dat_8a;
  begin
    if bytesuche_dat_puffer_0(#$8a'MNG'#$0d#$0a#$1a#$0a) then
      begin
        ausschrift('Multi-image Network Graphics',musik_bild);
        {mehr...}
      end;
  end;

procedure dat_8b;
  begin
    if bytesuche_dat_puffer_0(#$8b'BACKUP') then
      backup(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$8b'BKUPJFS') then
      backupjfs(dat_puffer_zeiger^);
  end;

procedure dat_8d;
  begin
    if bytesuche_dat_puffer_0(#$8d'?SOL') then (* resource.aud: pepper, QFG3,.. (WAV->RAW) *)
      begin
        ausschrift('Sierra audio',musik_bild);
        einzel_laenge:=$9+4+longint_z(@dat_puffer_zeiger^.d[$9])^;
      end;
  end;

procedure dat_8e;
  begin
    (*noch unklar
    if bytesuche_dat_puffer_0(#$8e#$ad#$e8#$01) then
      rpm(dat_puffer_zeiger^);*)

    if bytesuche_dat_puffer_0(#$8e#$00#$00#$9b'2.000'#$0A#$FE) then
      ausschrift('Quest for Glory 1 / Sierra',spielstand);

    if bytesuche_dat_puffer_0(#$8e#$00#$90#$a2'1.000'#$0A) then
      ausschrift('Pepper'#$27's Adventures in Time / Sierra',spielstand);

  end;

procedure dat_8f;
  begin
    if bytesuche_dat_puffer_0(#$8f#$af#$ac#$84) then
      (* "variant b" *)
      ausschrift('PPM / Dmitry Shkarin',packer_dat); (* warum nicht in typ_for? *)
  end;

procedure dat_90;
  begin
    if bytesuche_dat_puffer_0(#$90#$ca'NeoP') then
      ausschrift(textz_Druckertreiber^+' NeoPaint "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[$24],#0,80),bibliothek);
  end;

procedure dat_91;
  begin
    if bytesuche_dat_puffer_0(#$91'3HF') then
      hap3;
  end;

procedure dat_93;
  begin
    if bytesuche_dat_puffer_0(#$93#$b9) then
      splint(dat_puffer_zeiger^);
  end;

procedure dat_95;
  begin
    if bytesuche_dat_puffer_0(#$95#$04#$12#$de) then
      with dat_puffer_zeiger^ do (* .mo=machine object *)
        ausschrift('GNU message catalog ('+str0(m_longint(d[4]))+') ['
          +str0(m_longint(d[8]))+']',bibliothek);
  end;

procedure dat_9d;
  begin
    if bytesuche_dat_puffer_0(#$9d#$89'dlz') then
      diet_datendatei(dat_puffer_zeiger^,'1.10a,1.20',5);
  end;

procedure dat_a4;
  begin
    if bytesuche_dat_puffer_0(#$a4#$41#$00#$00)
    or bytesuche_dat_puffer_0(#$a4#$81#$00#$00) then
      atheos(dat_puffer_zeiger^);
  end;

procedure dat_a5;
  begin
    if bytesuche_dat_puffer_0(#$A5#$96) then (* OS/2 3.0: +#$FD#$FF *)
      pack_ibm(analyseoff,integer_z(@dat_puffer_zeiger^.d[2])^,'');
  end;

procedure dat_a8;
  begin
    if bytesuche_dat_puffer_0(#$a8'MP'#$a8) then
      kboom(dat_puffer_zeiger^);
  end;

procedure dat_aa;
  procedure dsk(z,k,s:word);
    var
      l:longint;
    begin
      l:=Longint(z)*k*s div 2;
      ausschrift_x(str0(z)+'/'+str0(k)+'/'+str0(s)+' => '+str0(l)+' KiB',normal,absatz);
    end;

  begin
    if bytesuche_dat_puffer_0(#$AA#$55) then
      rom_modul(dat_puffer_zeiger^,analyseoff,' [$AA$55]',einzel_laenge);

    if bytesuche_dat_puffer_0(#$aa#$59'?'#$00) (* warp patch *)
    or bytesuche_dat_puffer_0(#$aa#$58'?'#$00) (* IBM Peer Fixpack 8412 *)
     then
      begin
        ende_suche(analyseoff+einzel_laenge); (* wegen MKXDSKF *)
        ausschrift(textz_Vorspann_gekuerzte_Abzugsdatei^+' SaveDskF/LoadDskF / IBM [ Parameter /N ]',signatur);
        einzel_laenge:=word_z(@dat_puffer_zeiger^.d[$26])^;
        ansi_anzeige(analyseoff+$28,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
          ,absatz{vorne},wahr,wahr,unendlich,'');
        (* bei $14 ist die PrÅfsumme abgespeichert *)

        with dat_puffer_zeiger^ do
          dsk(word_z(@d[$18])^,word_z(@d[$1a])^,word_z(@d[$1c])^);

      end;

    if bytesuche_dat_puffer_0(#$aa#$5a'?'#$00) then
      begin
        (* warp patch *)
        ende_suche(analyseoff+einzel_laenge); (* wegen MKXDSKF *)
        ausschrift(textz_komprimierte_Abzugsdatei^+' SaveDskF/LoadDskF / IBM',packer_dat);
        ansi_anzeige(analyseoff+$28,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
          ,absatz,wahr,wahr,unendlich,'');

        with dat_puffer_zeiger^ do
          dsk(word_z(@d[$18])^,word_z(@d[$1a])^,word_z(@d[$1c])^);
      end;

  end;

procedure dat_ac;
  begin
    if  bytesuche_dat_puffer_0(#$ac#$bc)
    and (AndDGT(einzel_laenge,$f)=0)
    and (longint_z(@dat_puffer_zeiger^.d[$10])^=0)
     then (* MEM1/2.DAT -> MKEXE *) (* TR 2.52 *)
      ausschrift('TR / Liu TaoTao',signatur);
  end;

procedure dat_ad;
  begin
    if bytesuche_dat_puffer_0(#$ad'6?'#$0) then
      amgc(dat_puffer_zeiger^);
  end;

procedure dat_b0;
  begin
    if bytesuche_dat_puffer_0(#$b0'MFN') then
      (* neth.msg: Kennwortlistdatei *)
      ausschrift(textz_dat__Kennwortlistdatei^+' [IBM DOS Lan Services]',bibliothek);
  end;

procedure dat_b1;
  begin
    if bytesuche_dat_puffer_0(#$b1#$68#$de#$3a'??'#$00#$00) then
      begin
        ausschrift('Digital Communication Associates/Intel FAX',musik_bild);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[4])^;
      end;

  end;

procedure dat_b2;
  begin
    if bytesuche_dat_puffer_0(#$b2#$97#$e1#$69) then
      begin
        ausschrift('WordPerfect Envoy [1.0a]',musik_bild);
        einzel_laenge:=$22+$1c+longint_z(@dat_puffer_zeiger^.d[4])^;
      end;
  end;

procedure dat_b8;
  begin
    if bytesuche_dat_puffer_0(#$b8#$c9#$0c#$00) then
      (* #define ISHIELD_MAGIC 0x000cc9b8
         #define ISHIELD_MAGIC_v2_20_905 0x1234001c
         #define ISHIELD_MAGIC_v3_00_065 0x12340016
         #define ISHIELD_MAGIC_v5_00_000 0x00010050 *)
      begin
        ausschrift(textz_dat__compiled^+' Install Shield Setup Script',compiler);
        befehl_sonst('call pec isDcc '+dateiname+' > '+erzeuge_neuen_dateinamen('.isDcc'))
      end;

  end;

procedure dat_ba;
  var
    dat_tmp_puffer      :puffertyp;
    w1                  :word_norm;
  begin
    if bytesuche_dat_puffer_0(#$BA#$37#$53#$01#$49#$97#$E8#$00) then
      begin
        datei_lesen(dat_tmp_puffer,analyseoff+$b481,16);
        for w1:=0 to 79 do
          dat_tmp_puffer.d[w1]:=not dat_tmp_puffer.d[w1];
        dat_tmp_puffer.d[16]:=0;
        ausschrift(textz_Laufzeit_Link_Bibliothek^
         +' Norton Utils [7] "'+puffer_zu_zk_e(dat_tmp_puffer.d[0],#0,255)+'"',bibliothek);
      end;

    if bytesuche_dat_puffer_0(#$BA#$37#$53#$01#$92#$00#$E8#$00) (* DEU *)
    or bytesuche_dat_puffer_0(#$BA#$37#$53#$01#$dc#$5d#$E8#$00) (* ENG *) then
      begin
        datei_lesen(dat_tmp_puffer,analyseoff+$b49d,16);
        for w1:=0 to 79 do
          dat_tmp_puffer.d[w1]:=not dat_tmp_puffer.d[w1];
        dat_tmp_puffer.d[16]:=0;
        ausschrift(textz_Laufzeit_Link_Bibliothek^
         +' Norton Utils [8] "'+puffer_zu_zk_e(dat_tmp_puffer.d[0],#0,255)+'"',bibliothek);
      end;
  end;

procedure dat_bc;
  begin
    if bytesuche_dat_puffer_0(#$bc#$40) and (dat_puffer_zeiger^.d[2]<$80) then
      sky;
  end;

procedure dat_bd;
  begin
    if bytesuche_dat_puffer_0(#$bd#$86#$66#$3b#$76#$0d) then
      ausschrift('? - Intel BIOS',packer_dat);
  end;

procedure dat_c0;
  begin
    if bytesuche_dat_puffer_0(#$c0#$00#$00#$00'GPFPACK') then
      gpfpack(dat_puffer_zeiger^);
  end;

procedure dat_c4;
  var
    f1:dateigroessetyp;
  begin
    if bytesuche_dat_puffer_0(#$c4#$01#$c4#$01) then
      if bytesuche__datei_lesen(analyseoff+80*25*2,'TDS'#$0d#$0a) then
        begin
          epic_exe_installation(false);
          (* OMF Shareware Installation *)
          einzel_laenge:=80*25*2;
          thegrab(analyseoff,25,80*2,textz_datx__Kopie_Textmodus_Bildschirmspeicher^);
        end;
  end;

procedure dat_c5;
  begin
    if bytesuche_dat_puffer_0(#$c5#$d0#$d3#$c6) then
      eps_vorspann(dat_puffer_zeiger^);
  end;

procedure dat_c6;
  var
    uc2sfx_gefunden     :dateigroessetyp;
  begin
    if bytesuche_dat_puffer_0('∆ÕÕÕ') then
      begin
        uc2sfx_gefunden:=datei_pos_suche(analyseoff,analyseoff+2000,'UC2SFX');
        if uc2sfx_gefunden<>nicht_gefunden then
          ausschrift('UC2 / AIP',packer_dat);
      end;
  end;

procedure dat_c7;
  begin
    if bytesuche_dat_puffer_0(#$c7#$dd#$cc#$cc#$d0#$d5#$df#$dd#$c8#$d5#$d3#$d2) then
      begin
        ausschrift('SETUP.INF (XOR $9c) EDI Install Pro / Robert Salesas',bibliothek);
        befehl_xor(analyseoff,einzel_laenge,erzeuge_neuen_dateinamen('.X9C'),$9c);
      end;

    if bytesuche_dat_puffer_0(#$c7'E'#$cf'S') then
      ausschrift('"'+puffer_zu_zk_e(dat_puffer_zeiger^.d[$20],#0,255)+'" / GeoWorks [1.0]',bibliothek);

    if bytesuche_dat_puffer_0(#$c7'E'#$c1'S') then
      ausschrift('"'+puffer_zu_zk_e(dat_puffer_zeiger^.d[$04],#0,255)+'" / GeoWorks [2.0]',bibliothek);

    if bytesuche_dat_puffer_0(#$c7#$71) then
      cpio;

  end;

procedure dat_c8;
  begin
    (* jetzt in DATX
    if bytesuche_dat_puffer_0(#$c8#0#0#0'SPFP') then
      ausschrift('Unit Pascal Compiler Lite / TMT Development Corporation',compiler);
      *)

    if bytesuche_dat_puffer_0(#$c8#0#0#0) and (not bytesuche(dat_puffer_zeiger^.d[4],'SPFP')) then
      quickfix;
  end;

procedure dat_c9;
  begin
    if bytesuche_dat_puffer_0(#$c9#$41#$00#$00)
    or bytesuche_dat_puffer_0(#$c9#$81#$00#$00) then
      atheos(dat_puffer_zeiger^);

    (* AJAZSS01.EXE NCR Disk Creation Tool 1.00? *)
    if bytesuche_dat_puffer_0('…ÕÕÕÕÕ') then
      versuche_doppelrahmen_kasten(dat_puffer_zeiger^);

  end;

procedure dat_ca;
  begin
    if bytesuche_dat_puffer_0(#$ca#$fe#$ba#$be) then
      ausschrift('Java '+textz_Bytecode^,compiler);
  end;

procedure dat_cc;
  var
    w1                  :word_norm;
  begin
    if bytesuche_dat_puffer_0(#$cc#$cc#$cc#$cc#$cc#$cc#$cc) then
      begin
        w1:=puffer_pos_suche(dat_puffer_zeiger^,'MZ',512);
        if w1<>nicht_gefunden then
          begin
            ausschrift(textz_Fuell_byte^+'"Ã",'+str_(w1,1)+')',signatur);
            einzel_laenge:=w1;
          end;
      end;
  end;

procedure dat_cd;
  begin
    if bytesuche_dat_puffer_0(#$cd#$20'jm'#$04#$05) then
      xpack_pd(dat_puffer_zeiger^,2);
  end;

procedure dat_ce;
  begin
    if bytesuche_dat_puffer_0(#$ce#$01#$00#$00) then
      ausschrift('OS/2 Workplace Shell "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[$3c],#0,80)+'"',bibliothek);

  end;

procedure dat_d0;
  begin
    if bytesuche_dat_puffer_0(#$d0#$cf#$11#$e0#$a1#$b1#$1a#$e1) then
      d0_cf_11_e0(dat_puffer_zeiger^); (* typ_for3 *)
  end;

procedure dat_d1;
  begin
    if bytesuche_dat_puffer_0(#$d1#$ff#$d1#$ff) then
      gdiff(dat_puffer_zeiger^);
  end;

procedure dat_d4;
  begin
    if bytesuche_dat_puffer_0(#$d4#$01#$00#$00) then
      updateit;
  end;

procedure dat_d5;
  begin
    (* AdbeRdr60_deu_full.exe *)
    if bytesuche_dat_puffer_0(#$d5#$d9#$e9#$1d#$a1#$b9#$a0#$9c) then
      fead_optimizer;
  end;


procedure dat_d7;
  begin
    if bytesuche_dat_puffer_0(#$d7#$cd#$c6#$9a) then
      begin
        bild_format_filter(textz_dat__Metadatei^+' Windows / MS',
                           -integer(word_z(@dat_puffer_zeiger^.d[6])^)+integer(word_z(@dat_puffer_zeiger^.d[10])^)+1,
                           -integer(word_z(@dat_puffer_zeiger^.d[8])^)+integer(word_z(@dat_puffer_zeiger^.d[12])^)+1,
                           -1,-1,false,true,anstrich);
      end;

  end;

procedure dat_d8;
  begin
    if bytesuche_dat_puffer_0(#$d8#$a6#$68#$47) then
      begin
        ausschrift('Borland Delphi 4.0 Unit ',bibliothek);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[4])^;
      end;
  end;

procedure dat_da;
  begin
    if bytesuche_dat_puffer_0(#$da#$35) then
      if (longint_z(@dat_puffer_zeiger^.d[4])^=longint_z(@dat_puffer_zeiger^.d[4+8])^+4)
      and (word_z(@dat_puffer_zeiger^.d[2])^>0)
      and (word_z(@dat_puffer_zeiger^.d[2])^<10000) then
        bcomp(word_z(@dat_puffer_zeiger^.d[2])^);


    if bytesuche_dat_puffer_0(#$da#$fa'?'#$29'???'#$00) then
      logitech_expand(dat_puffer_zeiger^);

  end;

procedure dat_de;
  begin
    if bytesuche_dat_puffer_0(#$DE#$DA#$00#$00) then
      ausschrift(textz_Hilfedatei^+' Digital Research Dos 6',bibliothek);

    {if bytesuche_dat_puffer_0(#$de#$12#$04#$95) then
      (* LYX/2 1.0.4.1 XFree86/lib/X11/locale/*/*.mo *)
      ausschrift('gettext',compiler);}
    if bytesuche_dat_puffer_0(#$de#$12#$04#$95) then
      with dat_puffer_zeiger^ do (* .mo=machine object *)
        ausschrift('GNU message catalog ('+str0(longint_z(@d[4])^)+') ['
          +str0(longint_z(@d[8])^)+']',bibliothek);
  end;

procedure dat_df;
  begin
    if bytesuche_dat_puffer_0(#$DF#$DA#$00#$00) then
      ausschrift(textz_Hilfedatei^+' Novell Dos 7',bibliothek);

    if bytesuche_dat_puffer_0(#$df#$00#$00'?')
    and (einzel_laenge=longint_z(@dat_puffer_zeiger^.d[4])^) then
      tpu_system(dat_puffer_zeiger^);

  end;

procedure dat_e0;
  begin
    if bytesuche_dat_puffer_0(#$e0#$ea#$0b#$0c) then
      begin
        if dat_puffer_zeiger^.d[4]<>0 then
          exezk:=' [P]'
        else
          exezk:='';

        ausschrift('Disk Factory / Responsive Software "'+puffer_zu_zk_pstr(dat_puffer_zeiger^.d[$e])+'"'+exezk,packer_dat)
      end;

    if bytesuche_dat_puffer_0(#$e0#$e1#$e2#$e3#$e4#$e5#$e6#$e7'??'#$00#$00) then
      indigorose_archiv;
  end;

procedure dat_e1;
  begin
    if bytesuche_dat_puffer_0(#$e1#$00#$68#$16#$00) then
      begin
        ausschrift('EFP / Alexei Bulushev [1.23]',packer_exe);

        (* DOG / K^3 ? *)
        if  bytesuche__datei_lesen(analyseoff+$6b03+$00,#$1a#$f6)
        and bytesuche__datei_lesen(analyseoff+$6b03+$10,#$00#$00)
         then
          einzel_laenge:=$6b03;
      end;

  end;

procedure dat_e3;
  begin
    if bytesuche_dat_puffer_0(#$e3#$82#$85#$96) then
      ausschrift(textz_dat__Kennwortlistdatei^+' [MS Windows 98]',bibliothek);
  end;

procedure dat_e5;
  begin
    if bytesuche_dat_puffer_0(#$e5#$3d#$f2#$a4) then
      seau(analyseoff,einzel_laenge,dat_puffer_zeiger^);
  end;

procedure dat_e9;
  begin
    if bytesuche_dat_puffer_0(#$e9'???'#$21#$43#$65#$87) then
      sierra_drv(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$e9'???'#$00#$00#$00#$00) then
      begin
        if bytesuche__datei_lesen(analyseoff+longint_z(@dat_puffer_zeiger^.d[$1])^+1+4,
          #$89#$1d'????'#$89#$0d'????'#$89#$15'????'#$a3'????'#$89#$35)
        or bytesuche__datei_lesen(analyseoff+longint_z(@dat_puffer_zeiger^.d[$1])^+1+4,
          #$a3'????'#$89#$1d'????'#$89#$0d'????'#$89#$15'????'#$89#$35) then
            ausschrift('Forth32 / Rick VanNorman',compiler);
      end;
  end;

procedure dat_eb;
  begin
    if bytesuche_dat_puffer_0(#$eb#$fe#$90#$90#$90#$90) then
      ausschrift('Watcom DOS32-extender file (W32RUN.EXE)',{dos_win_extender}compiler);

    if bytesuche_dat_puffer_0(#$eb'???'#$21#$43#$65#$87) then
      sierra_drv(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$eb#$0c#$90#$10) then
      elite_datsfx(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$eb#$eb'0MSG') then
      begin
        ausschrift(textz_dat__Daten_leerzeichen^+'ExeLock / Solid OAK Software',signatur);
        ansi_anzeige(analyseoff+$e,#$eb#$eb'0MSG',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
         vorne,wahr,wahr,unendlich,'');
        bestimme_einzel_laenge_exelock;
      end;
  end;

procedure dat_ed;
  begin
    if bytesuche_dat_puffer_0(#$ed#$41#$00#$00)
    or bytesuche_dat_puffer_0(#$ed#$81#$00#$00) then
      atheos(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$ED#$AC#$02#$01) then
      ausschrift(textz_Aufgaben_fuer^+' The Incredible Machine',bibliothek);

    if bytesuche_dat_puffer_0(#$ed#$ab#$ee#$db) then
      rpm(dat_puffer_zeiger^);

  end;

procedure dat_ee;
  begin
    if bytesuche_dat_puffer_0(#$ee#$76) then
      rtpatch(dat_puffer_zeiger^,'[DEMO] ');
  end;

procedure dat_ef;
  begin
    if bytesuche_dat_puffer_0(#$ef#$be#$ad#$de'nsisinstall') then
      nullsoft_inst_x(dat_puffer_zeiger^,3,$18,$20);
  end;

procedure dat_f0;
  begin
    (* 512 Byte *)
    if  bytesuche_dat_puffer_0(#$f0#$fd#$01) (* 3+509 *)
    and (word_z(@dat_puffer_zeiger^.d[3])^<einzel_laenge) then
      lib(dat_puffer_zeiger^); (* VPASCAL LIB /P512 *)

    (* 16 Byte *)
    if  bytesuche_dat_puffer_0(#$f0#$0d#$00) (* 3+13 *)
    and (word_z(@dat_puffer_zeiger^.d[3])^<einzel_laenge)
    and (dat_puffer_zeiger^.d[$10] in [$80,$f1]) then
      lib(dat_puffer_zeiger^);
  end;

procedure dat_f4;
  begin
    if bytesuche_dat_puffer_0(#$f4#$ff#$f3#$ff#$ed#$ff#$f0#$ff) then
      begin
        ausschrift('Simply Docs [3.0] / SimpleWare',compiler);
        ansi_anzeige(analyseoff+einzel_laenge-356,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
          absatz,wahr,wahr,analyseoff+einzel_laenge-356+39,'')
      end;
  end;

procedure dat_f6;
  begin
    if bytesuche_dat_puffer_0(#$f6) then
      if puffer_anzahl_suche(dat_puffer_zeiger^,'.ASM',80)>=1 then
        ausschrift('AFIX / Eric Iscason "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[3],#0,80)+'"',signatur);
  end;

procedure dat_f7;
  begin
    if bytesuche_dat_puffer_0(#$f7#$07'Compress.NewD') then
      oberon_arc;

    if bytesuche_dat_puffer_0(#$f7#$02#$01#$83) then
      ausschrift('DVI "'+puffer_zu_zk_l(dat_puffer_zeiger^.d[$f],dat_puffer_zeiger^.d[$e])+'"',musik_bild);

    if bytesuche_dat_puffer_0(#$f7'Y2GFtoPK') then
      (* .PK *)
      ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[$3],#0,$32)+'"',musik_bild);
  end;

procedure dat_f9;
  var
    dat_tmp_puffer:puffertyp;
  begin

    (* Warp 4 MPTS,TCPIP  Hilfe saget "XPG/4" *)
    if bytesuche_dat_puffer_0(#$f9#$01#$00#$00) and (einzel_laenge>$20)
    and (word_z(@dat_puffer_zeiger^.d[$1e])^>0) then
      with dat_puffer_zeiger^ do
        begin
          datei_lesen(dat_tmp_puffer,$20+(word_z(@dat_puffer_zeiger^.d[$1e])^-1)*8,8);
          if Abs(einzel_laenge-word_z(@dat_tmp_puffer.d[2])^-longint_z(@dat_tmp_puffer.d[4])^)<=1 then
            ausschrift('GENCAT '+textz_dat__Nachrichtenkatalog^
              +' ['+str0(word_z(@dat_puffer_zeiger^.d[$1e])^)+']',musik_bild);
        end;
  end;

procedure dat_fb;
  begin
    if bytesuche_dat_puffer_0(#$fb'R') then
      ausschrift('Borland '+textz_Debug_Informationen^,bibliothek);
  end;

procedure dat_fc;
  begin
    if bytesuche_dat_puffer_0(#$fc#$70#$9a#$51) then
      gsfx;
  end;

procedure dat_fd;
  begin
    if bytesuche_dat_puffer_0(#$fd#$00#$b8#$00) then
      begin
        (* HOGBEAR.ARC *)
        ausschrift('Basic (?) '+textz_Bildschirmspeicherabzug^,musik_bild);
        if einzel_laenge<=60*25 then (* LÑnge 64007=320*200*256 *)
          thegrab(analyseoff+7,25,160,'');
      end;
  end;

procedure dat_fe;
  begin

    if bytesuche_dat_puffer_0(#$fe#$ed#$fa#$ce#$00#$00) then
      mach_o(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$fe#$ff#$ff#$ff#$14#$00#$00#$00'OS/2 F') then
      (* DSPRES.DLL AUS GRADD 0.77 *)
      os2_font(true,nil,0);

  end;

procedure dat_ff;
  var
    f1:dateigroessetyp;
  begin
    if bytesuche(dat_puffer_zeiger^.d[0],#$ff#$ff#$ff#$ff) then
      (* phoenix bios mit Daten+Programmodul *)
      if ((einzel_laenge> 128*1024+1000) and (einzel_laenge< 128*1024+5000))
      or ((einzel_laenge> 256*1024+1000) and (einzel_laenge< 256*1024+5000))
      or ((einzel_laenge> 512*1024+1000) and (einzel_laenge< 512*1024+5000))
      or ((einzel_laenge>1024*1024+1000) and (einzel_laenge<1024*1024+5000))
      or ((einzel_laenge>2048*1024+1000) and (einzel_laenge<2048*1024+5000)) then
        begin
          f1:=AndDGT(einzel_laenge,$ffff0000);
          if bytesuche__datei_lesen(analyseoff+f1,'BC??'#$00'11') then
            einzel_laenge:=f1;
          (* wird dann in typ_ende gefunden *)
        end;

    if bytesuche(dat_puffer_zeiger^.d[0],#$ff#$ff) then
      with dat_puffer_zeiger^ do
        if bytesuche(d[2],#$18#$00) (* normal *)
        or bytesuche(d[2],#$47#$00) (* Deskpress+description *) then
          if  (word_z(@d[4])^>=0)   (* Version *)
          and (word_z(@d[4])^<=999)
          and (d[7]=0)       (* coords *)
          and (d[6] in [0,2]) then
            ausschrift('GEM Metafile / Digital Research'+version100(word_z(@d[4])^),musik_bild);

    if (dat_puffer_zeiger^.d[1] and $e0)=$e0 then
      if mpeg_erweiterung
      or (puffer_gefunden(dat_puffer_zeiger^,'LAME'))
      or (puffer_gefunden(dat_puffer_zeiger^,'UUUU'))
       then
        mp3_anzeige;

    if bytesuche_dat_puffer_0(#$ff#$ff#$ff#$ff'Disk1'#$00) then
      begin  (* PGPSEA *)
        hersteller_gefunden:=true;
        ende_suche_erzwungen:=true;
        Exit;
      end;

    if bytesuche_dat_puffer_0(#$ff#$ff#$ff#$ff) then
      test_photocd(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$ff#$ff#$ff#$ff#$14) and
      (longint_z(@dat_puffer_zeiger^.d[8])^=einzel_laenge) then
        os2_ini;

    if bytesuche_dat_puffer_0(#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff) and
       (dat_puffer_zeiger^.d[$50]=0) and
       (dat_puffer_zeiger^.d[$51] in [$eb,$e9]) then
      begin
        ausschrift(textz_dat__Kopf^+' FastPacked / Oliver Weindl [1.2] "'
         +puffer_zu_zk_pstr(dat_puffer_zeiger^.d[$11])+'"',signatur);
        einzel_laenge:=$51;
      end;

    if bytesuche_dat_puffer_0(#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff)
    and (dat_puffer_zeiger^.d[$11] in [0,1,2])
    and (dat_puffer_zeiger^.d[$12] in [40..42,80..85]) then
      fastpacked_oliver_weindl(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$FF'FONT') then
      begin
        ausschrift('MS+PC+DR+NW+PTS - DOS '+textz_Schriftdefinitionen^,bibliothek);
        cpi_anzeige(dat_puffer_zeiger^);
      end;

    if bytesuche_dat_puffer_0(#$FF'COUNTRY') then
      begin
        ausschrift('MS+PC+PTS - DOS + OS/2 '+textz_Landesinformationen^,bibliothek);
        country_sys_anzeige(dat_puffer_zeiger^);
      end;

    if bytesuche_dat_puffer_0(#$FF'KEYB') then
      begin
        ausschrift('MS+PC+PTS - DOS '+textz_Tastaturbelegung^,bibliothek);
        keyboard_sys_anzeige;
      end;

    if bytesuche_dat_puffer_0(#$ff'BSG'#0) then (* 0 0 alt , 0 1 bei PTSDOS 2000 *)
      bsn(0);

    if bytesuche_dat_puffer_0(#$FF'WPC') then
      wpc(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$ff#$d8#$ff) then
      jfif(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$ff#$ff#$ff#$ff#$ff#$7f#$12#$00#$80#$00'ST') then
      begin (* COPY /B STARTSYS + *.COM ... *)
        ausschrift('STARTSYS / Alexey Falin',signatur);
        einzel_laenge:=$100;
      end;

    if bytesuche_dat_puffer_0(#$FF#$FF#$FF#$FF) and (dat_puffer_zeiger^.d[4]<>$FF) then
      geraete_treiber(dat_puffer_zeiger^,textz_dat__Geraetetreiber^);

    if bytesuche_dat_puffer_0(#$FF'MKMSGF') then
      ausschrift(textz_Meldungsdatei^+' OS/2 "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[8],#0,3)+'"',bibliothek);

    if bytesuche_dat_puffer_0(#$FF#$18)
    and bytesuche(dat_puffer_zeiger^.d[$10],#1#1) then
      ausschrift(textz_komprimierter_Plattenabzug^+' HD-Copy / Oliver Fromme "'
      +puffer_zu_zk_pstr(dat_puffer_zeiger^.d[2])
      +'" '+str0(dat_puffer_zeiger^.d[$e]+1)+'/'+str0(dat_puffer_zeiger^.d[$f])+'/2',packer_dat);


    if bytesuche_dat_puffer_0(#$ff'??'#$ff'???????'#$00) then
      with dat_puffer_zeiger^ do
        if  (word_z(@d[1])^>0)
        and (word_z(@d[1])^<4096)
        and (word_z(@d[4])^>0)
        and ((d[6] and $0f)=0)
        and (d[7] in [$00,$10])
        and (longint_z(@d[8])^>0)
        and (longint_z(@d[8])^<einzel_laenge)
         then
          os2_resource;

    (* Delphi *.DFM "TRFMAIN" "TFORM1" ... *)
    if bytesuche_dat_puffer_0(#$ff#$0a#$00) then
      if puffer_pos_suche(dat_puffer_zeiger^,#$00'TPF0',200)<>nicht_gefunden then
        os2_resource;

    if bytesuche_dat_puffer_0(#$ff#$ff'SYSLEVEL') then
      syslevel(dat_puffer_zeiger^);

    if einzel_laenge>$20000 then
      (* 64K FF (ACFG?) bei D1-0102.011 (ASUS D1 ACPI BIOS Revision 0102 Beta 011) *)
      (* 4k ff, 2K CPU, rest 122K ff: 6A69MV39.a *)
      if bytesuche_dat_puffer_0(#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff) then
        begin
          f1:=verfolge_nullen($ff,$20000,einzel_laenge);
          if f1>0 then
            begin
              einzel_laenge:=f1;
              ausschrift('$FF ('+strxDGT(einzel_laenge,0)+')',normal);
              (* kann mit $01 00 00 00 .. (Intel CPU microkode)
              (*          '??-lh?-' (Award BIOS block) aufhîren *)
              if bytesuche__datei_lesen(analyseoff+f1-2,'??-lh?-') then
                DecDGT(einzel_laenge,2)
              else
              if  bytesuche__datei_lesen(analyseoff+f1-1,'??-lh?-') then
                DecDGT(einzel_laenge,1);
            end;
        end;

  end;

end.
