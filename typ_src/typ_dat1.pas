(*$I TYP_COMP.PAS*)

unit typ_dat1;

interface

uses
  typ_type;

procedure dat_00;
procedure dat_01;
procedure dat_02;
procedure dat_03;
procedure dat_04;
procedure dat_05;
procedure dat_06;
procedure dat_07;
procedure dat_08;
procedure dat_09;
procedure dat_0a;
procedure dat_0b;
procedure dat_0c;
procedure dat_0d;
procedure dat_13;
procedure dat_15;
procedure dat_1a;
procedure dat_1b;
procedure dat_1d;
procedure dat_1f;
procedure dat_20;
procedure dat_21;
procedure dat_22;
procedure dat_23;
procedure dat_25;
procedure dat_28;
procedure dat_29;
procedure dat_2a;
procedure dat_2d;
procedure dat_2e;
procedure dat_2f;
procedure dat_30;
procedure dat_31;
procedure dat_32;
procedure dat_33;
procedure dat_34;
procedure dat_36;
procedure dat_37;
procedure dat_38;
procedure dat_39;
procedure dat_3a;
procedure dat_3b;
procedure dat_3c;
procedure dat_3e;
procedure dat_3f;
procedure dat_40;
procedure dat_41;
procedure dat_42;
procedure dat_43;
procedure dat_44;
procedure dat_45;
procedure dat_46;
procedure dat_47;
procedure dat_48;
procedure dat_49;
procedure dat_4a;
procedure dat_4b;
procedure dat_4c;
procedure dat_4d;
procedure dat_4e;
procedure dat_4f;
procedure dat_50;
procedure dat_51;
procedure dat_52;
procedure dat_53;
procedure dat_54;
procedure dat_55;
procedure dat_56;
procedure dat_57;
procedure dat_58;
procedure dat_59;
procedure dat_5a;
procedure dat_5b;
procedure dat_60;
procedure dat_61;
procedure dat_62;
procedure dat_63;
procedure dat_64;
procedure dat_65;
procedure dat_66;
procedure dat_67;
procedure dat_68;
procedure dat_69;
procedure dat_6a;
procedure dat_6b;
procedure dat_6c;
procedure dat_6d;
procedure dat_6e;
procedure dat_70;
procedure dat_72;
procedure dat_73;
procedure dat_75;
procedure dat_76;
procedure dat_77;
procedure dat_78;
procedure dat_79;
procedure dat_7a;
procedure dat_7b;
procedure dat_7f;

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
    mov eax,[dat_puffer_zeiger]
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


procedure dat_00;
  var
    pvm_dir_o,pvm_info_o:longint;
    targa_laenge        :longint;
    targa_farben        :longint;
    bios_modul_gefunden :longint;
    fuellnullen         :boolean;
    anzahl_fuellnullen  :dateigroessetyp;
    mz_suchpuffer       :puffertyp;
    exel                :dateigroessetyp;
    toshiba_bios_segment:longint;
    img_farbbit         :word_norm;

  begin

    if einzel_laenge=1024 then
      if bytesuche_dat_puffer_0(#$00#$00#$00#$00#$00#$00#$00#$00#$7e#$81#$a5#$81#$bd#$99#$81#$7e)
      (* toshiba *)
      or bytesuche_dat_puffer_0(#$00#$00#$00#$00#$00#$00#$00#$00#$3c#$42#$a5#$81#$a5#$99#$42#$3c)
       then
        begin
          ausschrift('F000:FA6E '+textz_schrift^+' 8*8 (00..7f)',musik_bild);
          anzeige_ega_font(8,8,0,false,false,128);
        end;

    if bytesuche_dat_puffer_0(#$00#$00#$00#$00) then
      begin
        macintosh_hfs($400);
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0(#$00#$00#$01) then
      begin
        versuche_mpeg(dat_puffer_zeiger^);
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0(#$00#$00#$00#$00) then
      begin
        versuche_ext2fs;
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0(#$00#$01'???'#$00) (* 2.0 *)
    or bytesuche_dat_puffer_0(#$00#$02'???'#$00) (* 2.0 *)
    or bytesuche_dat_puffer_0(#$00#$03'???'#$00) (* 3.0 *) then
      font_windows(analyseoff,einzel_laenge);

    (* mu· vor ARG kommen *)
    if not hersteller_gefunden then
      if  (m_longint(dat_puffer_zeiger^.d[0])<=einzel_laenge)
      and (m_longint(dat_puffer_zeiger^.d[0])>=4            ) then
        if bytesuche(dat_puffer_zeiger^.d[4],'moov')
        or bytesuche(dat_puffer_zeiger^.d[4],'mdat') then
          mov;

    if bytesuche_dat_puffer_0(#$00'???ftyp') then
      mpeg4;

    if bytesuche_dat_puffer_0(#$00#$00#$00#$00#$ef#$be#$ad#$de'NullSoftInst') then
      nullsoft_inst_x(dat_puffer_zeiger^,1,$1c,0); (* nur vermutet *)
    if bytesuche_dat_puffer_0(#$00#$00#$00#$00#$ef#$be#$ad#$de'NullsoftInst') then
      nullsoft_inst_x(dat_puffer_zeiger^,2,$18,0);

    (* musicm6d.exe: SparkInstall Version 1.0*)
    if bytesuche_dat_puffer_0(#$00#$00#$00#$00)
    and (analyseoff>$04000) (* b000 *)
    and (analyseoff< 50000) then
      if bytesuche__datei_lesen(50000,'MZ') then
        einzel_laenge:=50000-analyseoff;

    if trk_erweiterung or (AndDGT(einzel_laenge,2048-1)=0) then
      if bytesuche_dat_puffer_0(#$00#$00#$00#$00#$00#$00) then
        if bytesuche__datei_lesen(analyseoff+16*2048,#$01'CD001') then
          begin
            cd_spur_datei(2048,0);
            Exit;
          end;

    (* mode2,form1 wenn $18 Byte am Anfang entfernt sind *)
    if trk_erweiterung or (ModDGT(einzel_laenge,2352-$18)=0) then
      if bytesuche_dat_puffer_0(#$00#$00#$00#$00#$00#$00) then
        if bytesuche__datei_lesen(analyseoff+16*(2352-$18),#$01'CD001') then
          begin
            cd_spur_datei(2352-$18,0);
            Exit;
          end;



    if bytesuche_dat_puffer_0(#$00#$00#$00'BIOS????V?.')
    or bytesuche_dat_puffer_0(#$00#$00#$00'BIOS????v?.') then
      begin
        ausschrift('Toshiba BIOS',normal);
        toshiba_bios_segment:=$100;
        while toshiba_bios_segment<einzel_laenge do
          begin
            merke_position(analyseoff+toshiba_bios_segment,datentyp_unbekannt);
            Inc(toshiba_bios_segment,$10000);
          end;
        ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_l(dat_puffer_zeiger^.d[$b],$10)),beschreibung,absatz);
        einzel_laenge:=$100;
      end;

    (* .pfm *)
    if  bytesuche_dat_puffer_0(#$00#$01) then
      with dat_puffer_zeiger^ do
        if bytesuche(d[$c7],'PostScript'#$00)
        and (   (longint_z(@d[2])^  =einzel_laenge)
             or (longint_z(@d[2])^+1=einzel_laenge))
         then
          begin
            ausschrift('Printer Font Metrics [#'+str0(d[$5f])+'..#'+str0(d[$60])+']',musik_bild);
            exezk:=puffer_zu_zk_e(dat_puffer_zeiger^.d[$d2],#0,80);
            ausschrift_x(puffer_zu_zk_e(dat_puffer_zeiger^.d[$d2+Length(exezk)+1],#0,2*80),beschreibung,absatz);
            exezk:=puffer_zu_zk_e(dat_puffer_zeiger^.d[$06],#0,60);
            if exezk<>'' then
              ausschrift_x(exezk,beschreibung,absatz);
          end;


    if bytesuche_dat_puffer_0(#$00#$00#$15#$00) then
      wsp_wup(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$00#$00#$00#$00'PSFT') then
      begin
        ausschrift('PillarSoft SFX ['+str11_oder_hex(longint_z(@dat_puffer_zeiger^.d[8])^)+textz_byte^+']',signatur);
        einzel_laenge:=12;
      end;

    if (einzel_laenge>1000)
    and (analyseoff>4000)
    and bytesuche_dat_puffer_0(#$00#$2d#$3f)
     then
      begin
        (* NE .. *)
        exel:=datei_pos_suche(analyseoff,analyseoff+einzel_laenge,'CrypteX');
        if exel<>nicht_gefunden then
          begin
            DecDGT(exel,analyseoff);
            (* 5872 NE *)
            ausschrift('CrypteXeC / G†bor Keve [NE 1.0x] ('+DGT_str0(exel)+'+'+DGT_str0(einzel_laenge-exel)+')',packer_exe);
            Exit;
          end;
      end;

    {baum}
    if bytesuche_dat_puffer_0(#$00#$08#$db#$33#$45#$ab) then
      begin
        if (analyseoff=$cbec) then
          exezk:='1.0·'
        else
          if (analyseoff=$56ad)
          or (analyseoff=$1d23) then
          exezk:='DCREXE 2.0'
        else
          exezk:='?.? ¯';

        ausschrift('LuCeStop / LuCe ['+exezk+']',packer_exe); (* packer_dat .. *)
      end;

    if bytesuche_dat_puffer_0(#$00#$5a#$00#$14)
    and (word_z(@dat_puffer_zeiger^.d[4])^=word_z(@dat_puffer_zeiger^.d[4+2])^)
     then
      screenthief_install;

    if  bytesuche_dat_puffer_0(#$00#$00#$00#$00)
    and bytesuche(dat_puffer_zeiger^.d[$c],#$00#$00#$74#$00'?'#$00#$74)
     then
      install_svga;

    if bytesuche_dat_puffer_0(#$00#$00#$02#$00'?'#$04) then
      {noch nicht vollstÑndig/richtig}
      begin
        case dat_puffer_zeiger^.d[$4] of
          $04:
            ausschrift('1-2-3 Worksheet / Lotus [1.0,1.A]',musik_bild);
          $05:
            ausschrift('Symphony Worksheet / Lotus [1.0]',musik_bild);
          $06:
            (* WORD PERFECT 1.0 DOS *)
            ausschrift('1-2-3 Worksheet / Lotus [2.01]',musik_bild);
        else
            ausschrift('??? Worksheet / Lotus',musik_bild);
        end;
      end;

    if not hersteller_gefunden then
      if bytesuche_dat_puffer_0(#$00+'????????'+'?'+'???'+#$00) then
        arg(dat_puffer_zeiger^);

    (* PACK1.PRG *)
    if bytesuche_dat_puffer_0(#$00'MZ') then
      begin
        ausschrift(textz_Fuell_Nullen^+'1)',signatur);
        einzel_laenge:=1;
        Exit;
      end;

    if  bytesuche_dat_puffer_0(#$00#$00#$00#$00)
    and bytesuche(dat_puffer_zeiger^.d[$131],'Dis') then
      begin
        ausschrift(textz_Fuell_Nullen^+'305)',signatur);
        einzel_laenge:=$131;
        Exit;
      end;

    if bytesuche_dat_puffer_0(#$00#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff) then
      begin
        bios_modul_gefunden:=-1;

        if (analyseoff<$10000) then
          begin
            if bytesuche__datei_lesen(analyseoff+$10000+2,'-lh5-') then
              bios_modul_gefunden:=$10000;
          end;

        if (analyseoff<$20000) and (bios_modul_gefunden<0) then
          begin
            if bytesuche__datei_lesen(analyseoff+$20000+2,'-lh5-') then
              bios_modul_gefunden:=$20000;
          end;

        if (analyseoff<$20000) and (bios_modul_gefunden>0) then
          begin
            ausschrift(textz_Fuell_byte^+'255)',signatur);
            einzel_laenge:=bios_modul_gefunden-analyseoff;
          end;
      end;

    if bytesuche_dat_puffer_0(#$00#$00#$01#$b3) then
      ausschrift('MPEG '
        +str0(m_word(dat_puffer_zeiger^.d[4]) div $0010)+' * '
        +str0(m_word(dat_puffer_zeiger^.d[5]) mod $1000),musik_bild);


    if bytesuche_dat_puffer_0(#$00'??'#$00'?'#$00#$00#$02)
    and (dat_puffer_zeiger^.d[8] in [$eb,$e9])
     then
      begin
        ausschrift(textz_dat__Kopf^+'OS/2 VMDISK',signatur);
        einzel_laenge:=8;
      end;

    if bytesuche_dat_puffer_0(#$00'???'#$00'???'#$00#$b5#$9c#$00) then
      begin
        ausschrift('Overlay <Pocket Soft> ¯',overlay_);
        pocket_soft:=wahr;
      end;

    if bytesuche_dat_puffer_0(#$00#$06) then
      begin
        (* Virtual PC Addidtions=SetupFactory-Paket mit pkware-Blîcken *)
        if bytesuche(dat_puffer_zeiger^.d[0],#$00#$06#$9a#$68 (* fÅr 'MZ' *) ) then
          begin
            pkware_lib;
            vermutung_pk:=falsch; (* schon behandelt *)
          end
        else
          vermutung_pk:=wahr;
      end;

    if bytesuche_dat_puffer_0(#$00'?'#$d3#$a8) then
      ausschrift('OS/2 '+textz_dat__Metadatei^,musik_bild);

    if bytesuche_dat_puffer_0(#$00'PGMPAK ?.') then
      ausschrift(textz_Kennzeichnung^+puffer_zu_zk_l(dat_puffer_zeiger^.d[1],11)+'"',signatur);

    if (bytesuche_dat_puffer_0(#0#6)
      or bytesuche_dat_puffer_0(#0#4))
    and (einzel_laenge>2000) then
      begin
        pvm_dir_o:=x_longint__datei_lesen(einzel_laenge-4);
        pvm_info_o:=x_longint__datei_lesen(einzel_laenge-4-8);

        if (analyseoff+pvm_dir_o+6<=einzel_laenge)
        and (analyseoff+pvm_dir_o<=einzel_laenge)
        and (analyseoff+pvm_dir_o>0)
        and (analyseoff+pvm_dir_o+6>0) then
          begin
            if bytesuche__datei_lesen(analyseoff+pvm_dir_o,#5'[PVM]') then
              instalit(pvm_dir_o,pvm_info_o);
          end;
      end;

    if bytesuche_dat_puffer_0(#$00#$00#$01#$00) (* ICO *)
    or bytesuche_dat_puffer_0(#$00#$00#$02#$00) (* CUR *)
     then (* Kopf *)
      with dat_puffer_zeiger^ do
        begin
          if  (d[4] in [1..9]) and (d[5]=0)     (* Anzahl *)
          and (d[5]=0)
          and (d[6+0]=d[6+1])                   (* Quadratisch *)
          and (d[6+0] in [16..80])              (* VernÅnftige Grî·e *)
          and (not odd(d[6+0]))                 (* FFE sagt 16/32/64 *)
          (* 6+2: Farben *)
(*          and (d[6+2] in [$00,                ( * PMVIEW 256 Farben * )
                            $10,                ( * C:\DRDOS\COMMAND.ICO * )
                            $ff,                ( * LOKA.ICO * )
                            $02]) in HAFASWIN.ICO MONO (PMVIEW) *)
          (* 6+3: reserviert *)
          and (   ((d[2]=1) and (d[6+4] in [0,1]) and (d[6+5]=0))  (* Ebenen/reserviert *)
               or ((d[2]=2) and (d[6+4] in [0..d[6]]) and (d[6+6] in [0..d[6]]) and (d[6+5]=0))) (* "Mitte" sinnvoll *)
          (* 6+6/6+7: bit *)
          and (longint_z(@d[6+12])^=6+$10*d[4])
           then
             windows_ico(d[4],d[2]);
        end;

    if bytesuche_dat_puffer_0(#$00#$01#$00#$00) then
      versuche_ttf(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$00#$00#$02#$00#$04#$04#$05#$54) then
      ausschrift('Kalkulation / MS [2.0]',musik_bild);

    if bytesuche_dat_puffer_0(#$00'           '#$00#$00) then
      lu_;

    (****************************************************)
    if hersteller_gefunden then exit;

    if bytesuche_dat_puffer_0(#$00#$01'??'#$00'?'#$00) then
      with dat_puffer_zeiger^ do
      if (   (m_word(d[2])=8) (* KopflÑnge 8 *)
          or (m_word(d[2])=9) (* KopflÑnge 9 - Ventura *)
          or bytesuche(d[$10],'XIMG')) (* Minibild? *)
      and (dat_puffer_zeiger^.d[5] in [1..8]) (* Ebenen *)
      and (dat_puffer_zeiger^.d[7] in [1..8]) (* pattern size in bytes *)
       then
        begin
          (* Versuche mit Alchemy, GWS und PMVIEW               *)
          (* 8,1,1       1 bit S/W                              *)
          (* 8,2,1       2 bit 4 Farben                         *)
          (* 8,3,1       3 bit 5(8) Farben                      *)
          (* 9,3,1       3 bit 8 Graustufen                     *)
          (* 8,4,1       4 bit 3(16) Farben                     *)
          (* 8,4,2       4 bit 1,9(16) Farben                   *)
          (* 8,8,1       8 bit 86(256) Graustufen               *)
          (* 9,1,3      24 bit Echtfarben oder Untermenge       *)
          img_farbbit:=dat_puffer_zeiger^.d[$05];
          if dat_puffer_zeiger^.d[7]=3 then
            img_farbbit:=img_farbbit*8*dat_puffer_zeiger^.d[7];
          bild_format_filter('GEM Paint,Ventura Image / Digital Research',
                               m_word(dat_puffer_zeiger^.d[$0c]),
                               m_word(dat_puffer_zeiger^.d[$0e]),
                               -1,img_farbbit,false,true,anstrich);
        end;

    (* bessere Variante in typ_datx
    if bytesuche_dat_puffer_0(#$00'??'#$00)
    and (not bytesuche_dat_puffer_0(#$00#$00#$00#$00#$00))
    and (word_z(@dat_puffer_zeiger^.d[$c])^<10000)
    and (word_z(@dat_puffer_zeiger^.d[$e])^<10000)
    and (word_z(@dat_puffer_zeiger^.d[$c])^>10)
    and (word_z(@dat_puffer_zeiger^.d[$e])^>10)
    then
      begin
        case dat_puffer_zeiger^.d[2] of
          1:
            begin
              targa_laenge:=longint(word_z(@dat_puffer_zeiger^.d[$c])^)
                           *longint(word_z(@dat_puffer_zeiger^.d[$e])^)
                           *1
                           +3*256+$12;
              targa_farben:=256;
            end;
          2:
            begin
              targa_laenge:=longint(word_z(@dat_puffer_zeiger^.d[$c])^)
                           *longint(word_z(@dat_puffer_zeiger^.d[$e])^)
                           *3
                           +$12;
              targa_farben:=16777216;
            end;
          3:
            begin
              targa_laenge:=longint(word_z(@dat_puffer_zeiger^.d[$c])^)
                           *longint(word_z(@dat_puffer_zeiger^.d[$e])^) div 8+$12;
              targa_farben:=2;
            end;
        else
          targa_laenge:=$7fffffff;
          targa_farben:=0;
        end;

        if (targa_laenge=einzel_laenge)  then
          bild_format_filter('Truevision Targa',
                             word_z(@dat_puffer_zeiger^.d[$c])^,
                             word_z(@dat_puffer_zeiger^.d[$e])^,
                             targa_farben,-1,true,false,anstrich);
      end;
    ende Truevision *)

    if bytesuche_dat_puffer_0(#$00'P'#$0) then
      finish_packer;

    (* die lieben Nullen .. *)
    if bytesuche_dat_puffer_0(#0) {and (dat_puffer_zeiger^.g>4)} then
      if (quelle.sorte<>q_datei) or hersteller_erforderlich
      or (analyseoff<>0) (* RSJ: ??? Nullen bis zum RAR-Archiv *)
       then

        with dat_puffer_zeiger^ do
          begin

            (* mîgliche FÑlle:

               - NE/LX/LE/PE/.. ist auf Seitengrî·e ausgerichtet
                 -> stumm,einzellaenge:=
               - bis zu 511 Nullen und dann andere Daten
                 -> "fÅllnullen",einzel_laenge
               - >511 nullen aber analyseoff+einzellaenge<dateilaenge
                 -> "nullen"
               - bis zu 511 Nullen und dann Dateiende
                 -> "nullen"
                                                                        *)
            anzahl_fuellnullen:=verfolge_nullen($00,4096,einzel_laenge);
            if (anzahl_fuellnullen<>einzel_laenge) and (anzahl_fuellnullen>=1) then
              begin

                datei_lesen(mz_suchpuffer,analyseoff+anzahl_fuellnullen,4);
                if bytesuche(mz_suchpuffer.d[0],'MZ')
                or bytesuche(mz_suchpuffer.d[0],'ZM')
                 then
                  begin
                    einzel_laenge:=anzahl_fuellnullen;
                    Exit;
                  end;

                (* Arachne *)
                if bytesuche(mz_suchpuffer.d[0],'Rar!'#26)
                 then
                  begin
                    einzel_laenge:=anzahl_fuellnullen;
                    ausschrift(textz_Fuell_Nullen^+DGT_str0(anzahl_fuellnullen)+')',signatur);
                  end;
              end;

            if  (anzahl_fuellnullen=einzel_laenge)
            and x_exe_vorhanden
            and (x_exe_basis+x_exe_ofs=analyseoff+einzel_laenge)
             then
              begin (* Stumm, bis x_exe *)
                hersteller_gefunden:=true;
                zwischzeile:=false;
                Exit;
              end;

            (* Vorsicht zum Beispiel bei TTCOMP-Dateien .. *)
            (* mae·ig viele Nullen *)
            if ((8<=anzahl_fuellnullen) and (anzahl_fuellnullen<4096))
            or (einzel_laenge=anzahl_fuellnullen)
             then
              begin
                {}(* erst TYP_DATX abarbeiten: es kînnte sonst zum Beispiel
                   die Null am Anfang des WISE-GLB Archives "gefunden" werden *)
                (* oder: AMIBIOS 'FONT': 4 Byte Kennung, dann Font chr[0]=0^19.. *)

                dat_sigx(dat_puffer_zeiger^);
                datx_aufgerufen:=true;

                if (not hersteller_gefunden) then{}
                  begin
                    hersteller_gefunden:=true;
                    einzel_laenge:=anzahl_fuellnullen;

                    if analyseoff+einzel_laenge=dateilaenge then
                      ausschrift(textz_Nullen^,signatur)
                    else
                      ausschrift(textz_Fuell_Nullen^+DGT_str0(anzahl_fuellnullen)+')',signatur);
                  end;

                Exit;
              end;

            (* zu viele .. *)
            (*if anzahl_fuellnullen>=16 then*)
            {  begin
                ausschrift(textz_Nullen^,signatur);
                ende_suche_erzwungen:=true;
                Exit;
              end;}
          end;

  end;

procedure dat_01;
  begin
    if bytesuche_dat_puffer_0(#$01#$00#$00#$00) then
      cpu_microcode(dat_puffer_zeiger^,einzel_laenge);

    if bytesuche_dat_puffer_0(#$01#$da) then (* magic *)
      with dat_puffer_zeiger^ do
        if  (d[2] in [0,1]) (* storage: verbatim/rle *)
        and (d[3] in [1,2]) (* bytes per pixel *)
        and (d[4]=0) and (d[5] in [1,2,3]) (* dimension *) then
          bild_format_filter('SGI image',
                               m_word(d[$6]),
                               m_word(d[$8]),
                               -1,d[3]*8*m_word(d[$a]),true,false,anstrich);

    if bytesuche_dat_puffer_0(#$01#$08#$5b#$08)
    and puffer_gefunden(dat_puffer_zeiger^,'LYNX') then
      fastlynx(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$01'?'#$00#$00)
    and bytesuche(dat_puffer_zeiger^.d[$1e],#$55#$aa#$88) then
      cdrom_boot_catalog(analyseoff,DGT_zu_longint(einzel_laenge),nil);

    if  bytesuche_dat_puffer_0(#$01#$00#$00#$00'?'#$00#$00#$00)
    and (dat_puffer_zeiger^.d[4] in [$58,$5c])
    and bytesuche(dat_puffer_zeiger^.d[$28],' EMF')  then
      with dat_puffer_zeiger^ do
        bild_format_filter('EnhancedMetaFile / MS',
            Abs(longint_z(@d[ 8])^-longint_z(@d[16])^),
            Abs(longint_z(@d[12])^-longint_z(@d[20])^),
            -1,-1,
            false,true,anstrich);

    if bytesuche_dat_puffer_0(#$01#$00#$00#$00#$ef#$be#$ad#$de'NullSoftInst') then
      nullsoft_inst_x(dat_puffer_zeiger^,1,$1c,0);
    if bytesuche_dat_puffer_0(#$01#$00#$00#$00#$ef#$be#$ad#$de'NullsoftInst') then
      nullsoft_inst_x(dat_puffer_zeiger^,2,$18,0);


    if bytesuche_dat_puffer_0(#$01#$00#$00#$00) then
      if bytesuche(dat_puffer_zeiger^.d[$27],#$00'@ExtractSetupFiles') then
        compaq_install_pe_4;

    (* RISC System/6000 (V3.1) in diesem Fall Power PC *)
    if bytesuche_dat_puffer_0(#$01#$df) then
      pruefe_coff(dat_puffer_zeiger^,false);

    bliztcopy_test(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$01#$00#$00#$00#$10#$01#$00#$00)
    and (einzel_laenge>=$110) then
      win32_debuginfo(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$01#$00'???2??'#$00#$00#$00'???.') then
      ausschrift(textz_dat__Daten_leerzeichen^+'EABackup / David Thorn',signatur);

    if bytesuche_dat_puffer_0(#$01#$01) and (m_longint(dat_puffer_zeiger^.d[4])<einzel_laenge)
     and (m_longint(dat_puffer_zeiger^.d[4])>DivDGT(einzel_laenge,2)) then
      compactor(m_longint(dat_puffer_zeiger^.d[4]));

    if bytesuche_dat_puffer_0(#$01#$00#$00#$00) and (longint_z(@dat_puffer_zeiger^.d[4])^=einzel_laenge) then
      os2_font_metrics(dat_puffer_zeiger^);

    (* Sicherung auf wechselbaren DatentrÑger *)
    if bytesuche_dat_puffer_0(#$01'DCP') then
      cp_backup(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$01'ICP') then
      ausschrift('Central Point Backup '+textz_Verzeichnisangaben^+' [9]',bibliothek);

    if bytesuche_dat_puffer_0(#$01'SCP') then
      ausschrift('Central Point Backup '+textz_dat__Daten_leerzeichen^+'[9]',bibliothek);

    if bytesuche_dat_puffer_0(#$01'??'#$00#$00'??'#$00#$00#$02)
    and (dat_puffer_zeiger^.d[1]=dat_puffer_zeiger^.d[5]) (* Konflikt mit Siedler 2 conti???.dat *)
     then
      ausschrift('CP/M '+textz_dat__Befehl^+' [DOSPLUS 1.2]',signatur);

    if bytesuche_dat_puffer_0(#$01#$00#$00#$00) and (einzel_laenge=304668) then
      theme_park_bullfrog;

    if bytesuche_dat_puffer_0(#$01#$ca'Copy') then
      genus_micro;

    if bytesuche_dat_puffer_0(#$01'ZPK'#$01) then
      zinstall;

  end;

procedure dat_02;
  begin
    bliztcopy_test(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$02#$0b#$01#$08) then
      ausschrift(textz_dat__Ausfuehrbare_Datei^+'HP-UNIX',signatur);

    (* Teil einer öbersichtsdatei (BAND) *)
    if bytesuche_dat_puffer_0(#$02'DCP') then
      cp_backup(dat_puffer_zeiger^);
  end;

procedure dat_03;
  begin
    dbase3(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$03'AB2') then
      abcomp_206(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$03#$01) then
      if puffer_anzahl_suche(dat_puffer_zeiger^,'.',2+8+1+3+10)>=1 then
        car;

    (* Cursor.* Resource aus BWCC.DLL *)
    if bytesuche_dat_puffer_0(#$03#$00#$03#$00#$28#$00#$00#$00) then
      windows_ico1(analyseoff+4,einzel_laenge-4,false,3);
  end;

procedure dat_04;
  begin
    if bytesuche_dat_puffer_0(#$04'-ID-') then
      id_archiv; (* alien carnage *)

    if bytesuche_dat_puffer_0(#$04#$1e#$00#$0a#$10) then
      (* A86.COM 4.02 *)
      ausschrift(textz_symboltabelle^+' A86 / Eric Isaacson',compiler);
  end;

procedure dat_05;
  begin
    if bytesuche_dat_puffer_0(#$05'vuZIP') then
      vuzip;

    if bytesuche_dat_puffer_0(#$05'GTH_2'#$00) then
      gather_2;

    if bytesuche_dat_puffer_0(#$05#$01#$01#$00#$00#$00#$00#$00) then
      terse(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$05'SP?0') then
      begin
        case dat_puffer_zeiger^.d[3] of
          ord('U'):exezk:='O';
          ord('W'):exezk:='W';
        else
                   exezk:='?';
        end;
        ausschrift('SpeedSoft Pascal Unit ['+exezk+'] '+textz_vorcompiliert^,compiler);
      end;

  end;

procedure dat_06;
  begin
    if bytesuche_dat_puffer_0(#6'2.50·2') then
      ausschrift('The Cheat Engine 2.50·2 / NUKE '
        +in_doppelten_anfuerungszeichen(puffer_zu_zk_pstr(dat_puffer_zeiger^.d[7])),compiler);
  end;

procedure dat_07;
  begin
    if bytesuche_dat_puffer_0(#$07#$01#$64) then
      (* ACTIVATE *)
      ausschrift(textz_dat__Ausfuehrbare_Datei^+'Linux/i386 [$07$01$64]',signatur);
      {vermultlich eher a.out}

    if bytesuche_dat_puffer_0(#$07#$01#$00#$00'???'#$00'???'#$00) then
       if dat_puffer_zeiger^.d[$20]<>0 then (* z.B. push ebp bei fpk *)
         ausschrift('386 a.out',compiler);
  end;

procedure dat_08;
  begin
    if bytesuche_dat_puffer_0(#$08'aChiefM#') then
      lza_100_lzz(dat_puffer_zeiger^);

  end;

procedure dat_09;
  begin
    if bytesuche_dat_puffer_0(#$09'setup.cfg') then
      zupmaker;

  end;

procedure dat_0a;
  begin
    if bytesuche_dat_puffer_0(#$0a'APOGEE.BAT'#$00#$00#$00) then
      if bytesuche__datei_lesen(analyseoff+$1f,#$00#$06) then
        apogee_raptor;

  end;

procedure dat_0b;
  begin
    if bytesuche_dat_puffer_0(#$0b#$01#$64) then
      (* LILO *)
      ausschrift(textz_dat__Ausfuehrbare_Datei^+'a.out/i386 [$0b$01$64]',signatur);

    if bytesuche_dat_puffer_0(#$0b#$01#$00) then
      (* GZIP386.EXE *)
      ausschrift(textz_dat__Ausfuehrbare_Datei^+'a.out/i386 [$0b$01$00]',signatur);
  end;

procedure dat_0c;
  begin
    if  bytesuche_dat_puffer_0(#$0C#$0A#$0A#$0A#$0F#$0A#$09#$09)
    and bytesuche(dat_puffer_zeiger^.d[$5c],#$0F#$0F#$0F#$0F#$0A#$0A#$0A#$0A) then
      multics_archive;

    if bytesuche_dat_puffer_0(#$0c#$00#$00#$00) then
      with dat_puffer_zeiger^ do
        if  (einzel_laenge>40000)
        (*and (analyseoff>200000)*)
        and (longint_z(@d[  4])^<=longint_z(@d[8])^)
        and (longint_z(@d[$10])^>=5) and (longint_z(@d[$10])^<=80) (* LÑnge Dateiname *)
        and ist_ohne_steuerzeichen_nicht_so_streng(puffer_zu_zk_l(d[$20],d[$10]))
         then
          stardock_sf_archiv;

    if bytesuche_dat_puffer_0(#$0c#$04#$0d'ChfLZ_2'#$05#$06#$04) then
      lza_100_lza(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$0c#$16#$08#$01#$01) then
      avatar;
  end;

procedure dat_0d;
  begin
    (* GROFF patches.os2 *)
    if (bytesuche_dat_puffer_0(#$0d#$0a'Only in ') and puffer_gefunden(dat_puffer_zeiger^,': '))
    or bytesuche_dat_puffer_0(#$0d#$0a'diff -'  ) then
      begin
        diff(2,false);
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0(#$0d#$0a) then
      begin (* drm.inf *)
        textini;
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0(#$0d#$0a#$1a'CAZIP??'#$00) then
      cazip;

    if bytesuche_dat_puffer_0(#$0d#$0a'[') then (* OS/2 Warp 4 \ibmcomp\macs\dc21x4.nif *)
      begin
        textini;
        if hersteller_gefunden then Exit;
      end;


    if bytesuche_dat_puffer_0(#$0d#$0a';') then (* Nm2kMf.inf *)
      begin
        textini;
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0(#$0d'(C) STEPANYUK') then
      begin
        ausschrift('ARS / Stephanyuk Oleg',packer_dat);
        ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
      end;

    (* ROSE .. (f_mirc.exe,..) *)
    if bytesuche_dat_puffer_0(#$0d#$0a'RegStr') then
      ansi_anzeige(analyseoff,#0,ftab.f[farblos,hf]+ftab.f[farblos,vf]
       ,absatz,wahr,wahr,analyseoff+einzel_laenge,'')
  end;


procedure dat_13;
  begin
    if bytesuche_dat_puffer_0(#$13']eå') then
      stirling_neu(dat_puffer_zeiger^);
  end;

procedure dat_15;
  begin

    if bytesuche_dat_puffer_0(#$15#$B6) and (einzel_laenge=31744) then
      ausschrift('Populous / Bullfrog',spielstand);

    if bytesuche_dat_puffer_0(#$15'TheDraw Save') then
      begin
        ausschrift('TheGrab / TheSoft Programming Services '+str0(dat_puffer_zeiger^.d[$29])+' * '
         +str0(dat_puffer_zeiger^.d[$27]),spielstand);
        if (dat_puffer_zeiger^.d[$21]=8) then
          thedraw_com(analyseoff+$16e,wahr)
        else
          thegrab(analyseoff+$16E,dat_puffer_zeiger^.d[$29],160,'');

      end;

  end;

procedure dat_1a;
  begin
    if bytesuche_dat_puffer_0(#$1a#$01'?'#$00) then
      with dat_puffer_zeiger^ do
        if (d[2]>0) and (d[12+d[2]-1]=0) then
          begin
            exezk:=puffer_zu_zk_l(d[12],d[2]-1);
            if ist_ohne_steuerzeichen_nicht_so_streng(exezk) then
              begin
                exezk_in_doppelten_anfuerungszeichen;
                ausschrift('terminfo: '+exezk,compiler);
              end;
          end;

    (*if bytesuche_dat_puffer_0(#$1a) then*)
    if (analyseoff=$2006) and (dateilaenge=longint_z(@dat_puffer_zeiger^.d[5])^) then
      (* = CryExe 1.0 *)
      ausschrift('HackFuck / Iosco [1.0]',packer_exe); (* eher packer_dat *)

    if bytesuche_dat_puffer_0(#$1a'QF'#$1a) then
      quickfilecollection;

    if bytesuche_dat_puffer_0(#$1a#$f6) then
      dog(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$1a'FDF') then
      ausschrift(textz_dat__Diskettenabzug^+'EZ-DisKlone Plus / EZX-Publishing '
        +in_doppelten_anfuerungszeichen(puffer_zu_zk_e(dat_puffer_zeiger^.d[6],#0,80)),packer_dat);

    if (dat_puffer_zeiger^.d[0]=$1A) and (einzel_laenge>10) then
      begin
        if (dat_puffer_zeiger^.d[1]=ord('H')) and (dat_puffer_zeiger^.d[2]=ord('P'))
        or (dat_puffer_zeiger^.d[1]=ord('S')) and (dat_puffer_zeiger^.d[2]=ord('T')) then
          hyper(dat_puffer_zeiger^.d[3]);

        if ((1<=dat_puffer_zeiger^.d[1]) and (dat_puffer_zeiger^.d[1]<=11))  (* Kompressionstyp 1..11 *)
         and (dat_puffer_zeiger^.d[18]<10)                           (* DateilÑnge  *)
         and (puffer_pos_suche(dat_puffer_zeiger^,#0,20)<=1+1+12) then (* Dateiname-Ende *)
            arc('')
        else
        if bytesuche_dat_puffer_0(#$1a#$14#$00) then
          arc('') (* normal *)
        else
        if bytesuche_dat_puffer_0(#$1a#$17)
        and (dat_puffer_zeiger^.d[2]>=ord('1'))
        and (dat_puffer_zeiger^.d[2]<=ord('9'))
         then
          arc(''); (* full backup *)

      end;
  end;

procedure dat_1b;
  begin

    if bytesuche_dat_puffer_0(#$1b'GM') and bytesuche__datei_lesen(analyseoff+einzel_laenge-3,#$1b'GN') then
      bild_format_filter('CompuServe RLE',128, 96,-1,1,false,true,anstrich);
    if bytesuche_dat_puffer_0(#$1b'GH') and bytesuche__datei_lesen(analyseoff+einzel_laenge-3,#$1b'GN') then
      bild_format_filter('CompuServe RLE',256,192,-1,1,false,true,anstrich);

    (* PTSPK BIG SOFTWARE ARCHIVER *)
    if bytesuche_dat_puffer_0(#$1b#$03'Descript') then
      arc('Big Software Archiver / Hidasy Jozsef');

  end;


procedure dat_1d;
  var
    l1          :longint;
  begin
    if bytesuche_dat_puffer_0(#$1d#$00#$00#$00'Norman Acc') then
      norman_access_control;

    if bytesuche_dat_puffer_0(#$1D#$00#$AE) then
      bsa(0);

  end;

procedure dat_1f;
  begin
    if bytesuche_dat_puffer_0(#$1f#$00#$ae) then
      bsa(0);

    if bytesuche_dat_puffer_0(#$1f#$8b#$08) then
      gnuzip(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$1F#$9d) then
      ausschrift('COMPRESS / Joseph M. Orost',packer_dat);

    (* rtssco(314).zip *)
    if bytesuche_dat_puffer_0(#$1F#$a0) then
      ausschrift('COMPRESS / [SCO, lzh]',packer_dat);

    if bytesuche_dat_puffer_0(#$1f#$9f#$4a#$10) then
      ausschrift('FREEZE / ???? Leo',packer_dat);
  end;

procedure dat_20;
  begin
    if bytesuche_dat_puffer_0(' ') and puffer_gefunden(dat_puffer_zeiger^,'TR') then
      tr_script;

    if  bytesuche_dat_puffer_0(' AKZENT')
    and bytesuche(dat_puffer_zeiger^.d[$16],'V ?.') then
      ausschrift('Akzent / Harald Czech & Axel Peter Winkler ['+char(dat_puffer_zeiger^.d[$18])+']',musik_bild);

    if bytesuche_dat_puffer_0(' RGH-PROFAN? DATEI'#$1a) then
      profan(dat_puffer_zeiger^,0);

    if bytesuche_dat_puffer_0(#$20#$20#$20#$20#$20#$20#$20#$07)
    and (einzel_laenge=1000)
     then
      ttx;

    if bytesuche_dat_puffer_0(#$20#$54#$02#$00#$00#$00#$05#$54) then
      ausschrift(textz_dat__Datenbank^+' / MS [2.0]',musik_bild);

    if bytesuche_dat_puffer_0(#$20#$00#$00#$00) then
      (* 4 Farbenen,Pos+LÑnge(32bit) *)
      if longint_z(@dat_puffer_zeiger^.d[$18])^+longint_z(@dat_puffer_zeiger^.d[$1c])^=einzel_laenge then
        ausschrift('OS/2 '+textz_BootLogos_Datei^,musik_bild);

  end;

procedure dat_21;
  begin
    if bytesuche_dat_puffer_0('!!!!@@@@WEBSHOTS_FILE_BEGINS_HERE@@@@!!!!!!!@@@@@@@@@@@@@@@@@@@@') then
      wenshots_file;

    if bytesuche_dat_puffer_0('!3PS') then
      softpaq_5(dat_puffer_zeiger^.d[4]);

    if bytesuche_dat_puffer_0('!sfx!'#$00)
    and (longint_z(@dat_puffer_zeiger^.d[6])^<einzel_laenge)
     then
      begin
        (* sfxfct2x.exe *)
        ausschrift('SFX-Factory / e-merge GmbH',packer_dat);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[6])^;
        (* und dann ACE... *)
      end;

    if bytesuche_dat_puffer_0('!<arch>'#$0a) then
      arch_lib;

    if bytesuche_dat_puffer_0('!!') then
      ha(dat_puffer_zeiger^,' [dUCKiNG]');

    if bytesuche_dat_puffer_0('!'#$12#0#0#0#0#0#0)
    or bytesuche_dat_puffer_0('!'#$11#0#0#0#0#0#0) then
      ain_22(dat_puffer_zeiger^);
  end;

procedure dat_22;
  begin
    if bytesuche_dat_puffer_0('"'#$0A'Jpyn') then
      zip(0,wahr,art_code);
    if bytesuche_dat_puffer_0('"'#$1b'Jcyn') then
      zip(0,wahr,prg_code);
  end;

procedure dat_23;
  begin
    if bytesuche_dat_puffer_0('#VRML V?.') then
      vrml(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('# PaCkAgE DaTaStReAm') then
      begin
        ansi_anzeige(analyseoff,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
                vorne,wahr,falsch,analyseoff+512,'');
        einzel_laenge:=512;
      end;

    if bytesuche_dat_puffer_0(#$23#$CC#$24#$00) then
      (* Visual basic win 1 *)
      ausschrift('Visual Basic '+textz_dat__Programmdaten^,signatur);

    if bytesuche_dat_puffer_0(#$23#$01#$23#$01) then
      backagain;

    if bytesuche_dat_puffer_0('#!/')
    or bytesuche_dat_puffer_0('#!\')
    or bytesuche_dat_puffer_0('#! /')
    or bytesuche_dat_puffer_0('#! \')
    or bytesuche_dat_puffer_0('#! sh')
     then
      shell_script(dat_puffer_zeiger^);

  end;

procedure dat_25;
  var
    w1,w2               :word_norm;
  begin

    (* putbi.pfa D:\extra\gstools\fonts\putbi.pfa *)
    if bytesuche_dat_puffer_0('%!PS-AdobeFont')
    (* D:\extra\gstools\fonts\hrger.pfa *)
    or bytesuche_dat_puffer_0('%!FontType1') then
      begin
        postscript('Postscript Font (text)',dat_puffer_zeiger^,0,true);
        Exit;
      end;

    if bytesuche_dat_puffer_0('%!PS-Adobe')
    or bytesuche_dat_puffer_0('%!'#$0d#$0a)
    or bytesuche_dat_puffer_0('%!'#$0a) then
      begin
        postscript('Postscript / Adobe',dat_puffer_zeiger^,0,false);
        Exit;
      end;

    (* 3c59xn.exe\@\* *)
    if bytesuche_dat_puffer_0('%VER') then
      if einzel_laenge<60 then (* 3COM %VER<DATEINAME_OHNE_EXE> *)
        begin
          exezk:=puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[4],DGT_zu_longint(MinDGT(60,einzel_laenge-4)));
          w1:=Pos(#0,exezk);
          if w1<>0 then
            SetLength(exezk,w1-1);
          exezk_in_doppelten_anfuerungszeichen;
          ausschrift(exezk,beschreibung);
        end;

    if bytesuche_dat_puffer_0('%PDF-?.?') then
      (* ausschrift('Adobe Acrobat',musik_bild); *)
      ausschrift('Portable Document File / Adobe ['
        +leer_filter(puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[5],4))+']',musik_bild);

    if bytesuche_dat_puffer_0('%!KDF-') then
      begin
        (* verschluesseltes PDF *)
        exezk:=leer_filter(puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[6],$a0-6));
        if Pos(':',exezk)<>0 then SetLength(exezk,Pos(':',exezk)-1);
        ausschrift('Kinko'#$27's File Prep Tool ['+exezk+']',musik_bild);

        (* entschlÅsselt? *)
        if bytesuche(dat_puffer_zeiger^.d[$a0],'%PDF-?.?') then
          ausschrift_x('Portable Document File / Adobe ['
            +leer_filter(puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[$a5],4))+']',musik_bild,absatz)
        else
          befehl_sonst('call pe "apdfpr.exe" '+dateiname);
      end;

    (* OS2TEX: .MF *)
    if bytesuche_dat_puffer_0('%% ')
    or bytesuche_dat_puffer_0('% ')
    or bytesuche_dat_puffer_0('%'#$0a'% ')
     then
      begin
        for w2:=1 to 10 do
          begin
            if dat_puffer_zeiger^.d[w2]=ord(' ') then
              begin
                inc(w2);
                exezk:=puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[w2],80);
                if length(exezk)<=1 then
                  inc(w2)
                else
                  begin
                    if ist_ohne_steuerzeichen(exezk) then
                      ausschrift(exezk,beschreibung);
                    break;
                  end;
              end
            else
              inc(w2);
          end;
      end;
  end;

procedure dat_28;
  begin
    if bytesuche_dat_puffer_0('(*') then
      if textdatei then
        pascal_quelle;

    (* Windows ICO oder BMP aus Resourcen es fehlen also meist die ersten $16 byte *)
    if bytesuche_dat_puffer_0(#$28#$00#$00#$00'???'#$00'???'#$00'?'#$00'?'#$00) then
      with dat_puffer_zeiger^ do
        begin
          if {(not Odd(longint_z(@d[8])^)) (* 32*(2*32) weil Farbe+Maske *)
          and} (d[$e] in [1,2,4,8,24])
           then
             windows_ico1(analyseoff,einzel_laenge,false,0);
        end;
  end;

procedure dat_29;
  begin
    if bytesuche_dat_puffer_0(')v') then
      bdiff;
  end;

procedure dat_2a;
  var
    f1:dateigroessetyp;
  begin
    if bytesuche_dat_puffer_0('*________') then
      probiere_readme_bootmenu_txt(dat_puffer_zeiger^);

    if textdatei then (* readme.d32 *)
      if bytesuche_dat_puffer_0('*******************') then
        probiere_readme_zwischenzeile('*');

    if bytesuche_dat_puffer_0('*BEGIN ') then
      with dat_puffer_zeiger^ do
      begin
        if bytesuche(d[7],'WORDS ') then
          exezk:='Words Document'
        else
        if bytesuche(d[7],'GRAPHICS ') then
          exezk:='Graphic'
        else
        if bytesuche(d[7],'RASTER ') then
          exezk:='Bitmap'
        else
        if bytesuche(d[7],'SPREADSHEETS ') then
          exezk:='Spreadsheet'
        else
        if bytesuche(d[7],'MACRO ') then
          exezk:='Macro'
        else
        if bytesuche(d[7],'BUILDER ') then
          exezk:='Builder Object'
        else
          exezk:='';

        if exezk<>'' then
          begin
            (* kînnte Version-Feld auswerten? *)
            (* '*BEGIN GRAPHICS VERSION=442/420 ENCODING=7BIT' *)
            ausschrift('Applixware '+exezk,musik_bild);
          end;

      end;

    if bytesuche_dat_puffer_0('*** ')
    and puffer_gefunden(dat_puffer_zeiger^,#$0a'--- ') then
      begin
        diff(0,true);
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0('*') and textdatei then
      versuche_ibm_software_installer;

    if bytesuche_dat_puffer_0(#$2a#$ab#$79#$d8) then
      stirling_setup(dat_puffer_zeiger^);

    (* OS/2 GRADD .DSC *)
    if bytesuche_dat_puffer_0('* Title'#13#10) then
      ausschrift('GRADD: '+puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[Length('* Title'#13#10)],80),beschreibung);

    if bytesuche_dat_puffer_0('****') then
      (*begin
        f1:=datei_pos_suche(analyseoff,analyseoff+2*1024,#$0d#$0a':TITLE'#$0d#$0a);
        if f1<>nicht_gefunden then
          dsp_oder_ddp_datei(f1+Length(#$0d#$0a':TITLE'#$0d#$0a));
      end;*)
      versuche_dsp_oder_ddp_datei;
  end;

procedure dat_2d;
  const
    cexec_schluessel:array[0..31] of byte=($60,$65,$62,$e7,$f4,$b3,$b4,$b8, $f6,$df,$9c,$80,$d7,$91,$d0,$dd,
                                           $b7,$71,$72,$77,$f4,$e1,$e4,$e9, $a3,$e3,$c8,$c1,$c3,$d2,$1e,$1d);
  var
    deco                :array[0..31] of byte;
    exel                :longint;
    w1                  :word_norm;
  begin
    if textdatei then
      if bytesuche_dat_puffer_0('-------------------') then
        probiere_readme_zwischenzeile('-');

    if bytesuche_dat_puffer_0('--- ')
    and puffer_gefunden(dat_puffer_zeiger^,#$0a'+++ ') then
      begin
        diff(0,true);
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0(#$2d#$ed#$0d#$0a) then
      ausschrift('Python',compiler); (* psyco-1.0-emx-py22.zip *)

    if bytesuche_dat_puffer_0('-ZPAK') then
      zpak;

    if bytesuche_dat_puffer_0('--DRAWIT VERSION') then
      begin
        exezk:=puffer_zu_zk_e(dat_puffer_zeiger^.d[16],'-',2);
        Insert('.',exezk,2);
        ausschrift('DrawIt / Jasper de Keijze ['+exezk+']',musik_bild);
      end;

    if (einzel_laenge>1000)
    and (analyseoff>4000)
    and bytesuche_dat_puffer_0(#$2d#$3f)
     then
      with dat_puffer_zeiger^ do
        begin
          for w1:=0 to 31 do
            deco[w1]:=d[w1] xor cexec_schluessel[w1];
          exel:=word_z(@deco[4])^*512;
          if word_z(@deco[2])^<>0 then
            exel:=exel-512+word_z(@deco[2])^;

          if  bytesuche(deco,'MZ')
          and (exel<einzel_laenge)
          and (einzel_laenge<exel+10000)
           then
            begin
              exezk:='?.??';
              if analyseoff=6373 then
                exezk:='0.9·';
              if analyseoff=6000 then
                exezk:='1.0';
              if analyseoff=8312 then
                exezk:='1.01';
              ausschrift('CrypteXeC / G†bor Keve ['+exezk+'] ('+DGT_str0(exel)+'+'
                +DGT_str0(einzel_laenge-exel)+')',packer_exe);
              exit;
            end;
        end;


    if bytesuche_dat_puffer_0('-'#0'Copyright (C) ????,???? Miles D') then
      begin
        exezk:='';
        w1:=$0;
        while not ((dat_puffer_zeiger^.d[w1]=$FF) and (dat_puffer_zeiger^.d[w1+1]=$FF) and (dat_puffer_zeiger^.d[w1+2]=$FF)) do
          begin
            inc(w1);
            if w1>500 then break;
          end;

        while not (dat_puffer_zeiger^.d[w1]=$00) do
          begin
            inc(w1);
            if w1>500 then break;
          end;
        while (dat_puffer_zeiger^.d[w1]<32) or (dat_puffer_zeiger^.d[w1+1]<32) or (dat_puffer_zeiger^.d[w1+2]<32) do
          begin
            inc(w1);
            if w1>500 then break;
          end;
        while (w1<500) and (dat_puffer_zeiger^.d[w1]>31) do
          begin
            exezk_anhaengen(chr(dat_puffer_zeiger^.d[w1]));
            inc(w1);
          end;
        (* Strike Comander,,,, *)
        ausschrift(in_doppelten_anfuerungszeichen(+exezk)+' / Miles Design',bibliothek);
      end;

    if bytesuche_dat_puffer_0('-----BEGIN PGP ') then
      pgp(dat_puffer_zeiger^,15,500);

    if bytesuche_dat_puffer_0('-S'#$c2#$00) then
       ausschrift('AV-'+textz_dat__Bibliothek^+' ('+str_(dat_puffer_zeiger^.d[$A],2)+'.'+str_(dat_puffer_zeiger^.d[$B],2)+'.'
       +str_(word_z(@dat_puffer_zeiger^.d[$8])^,4)+') / Eugene Kaspersky',bibliothek);

  end;

procedure dat_2e;
  begin
    if bytesuche_dat_puffer_0('.TH ') then
      troff;

    if bytesuche_dat_puffer_0('.**') then
      if datei_pos_suche_gross(analyseoff,analyseoff+3000,'<SGUIDE')<>nicht_gefunden then
        html;

    if bytesuche_dat_puffer_0('.rzt'#$00#$00'??'#$00#$00) then
      rzt_realnetworks(analyseoff,einzel_laenge);

    if bytesuche_dat_puffer_0('.RMF'#$00#$00'??'#$00) then
      rmf_realnetworks;

    if bytesuche_dat_puffer_0('.ra')
    and ((dat_puffer_zeiger^.d[3] and $f8)=$f8)
     then
      (* keine Formatdaten zur Zeit *)
      ausschrift('RealAudio',musik_bild);

    if bytesuche_dat_puffer_0('.snd'#0) then
      ausschrift('SUN Microsystems '+textz_dat__Klangdatei^,musik_bild);

    if bytesuche_dat_puffer_0('.\"') then
      (*ausschrift('groff',signatur);*)
      troff;

    if textdatei and (not hersteller_gefunden) then
      if puffer_gefunden(dat_puffer_zeiger^,#$0a'.TH ') then
        troff;

  end;

procedure dat_2f;
  begin
    if bytesuche_dat_puffer_0('/*:VRX') then
      if x_longint__datei_lesen(analyseoff+einzel_laenge-4)=$000de2c5 then
        begin
          vxrexx;
          Exit;
        end;

    if bytesuche_dat_puffer_0('/*') then
      c_kommentar;

    if bytesuche_dat_puffer_0('//') then
      c_kommentar;
  end;

procedure dat_30;
  var
    einzel_laenge_neu:longint;
  begin

    if bytesuche_dat_puffer_0('00JP') then  (* PJ00 *)
      pj10(dat_puffer_zeiger^,$100);

    if bytesuche_dat_puffer_0('0 ????:???? ') then
      versuche_scitech_driver_tab;

    (* DB-Einzeldatei, z.B.: G:\db2\NODE0000\SQL00001\SQLT0000.0\SQL00070.DAT/INX , 7.1 *)
    if bytesuche_dat_puffer_0(#$30#$00#$d0#$0f) then
      ausschrift('IBM DB2 Universal Database',bibliothek);


    if bytesuche_dat_puffer_0('0123456789012345BZh?1A') then
      if bytesuche__datei_lesen(analyseoff+einzel_laenge-$12,#$00#$00'0123456789012345') then
        exp1;

    if bytesuche_dat_puffer_0('070701') (* entpacktes RPM *)
    or bytesuche_dat_puffer_0('070707') (* CPIO aus PAX2EXE *)
     then
      cpio;

    if bytesuche_dat_puffer_0(#$30#$80)
    or bytesuche_dat_puffer_0(#$30#$82) then (* auch nochmal in datx *)
      if (puffer_gefunden(dat_puffer_zeiger^,'VeriSign Tr'))
      or (puffer_gefunden(dat_puffer_zeiger^,'<'#0'<'#0'O'#0'b'#0's'#0'o'#0'l'#0'e'#0't'#0'e')
      or (puffer_gefunden(dat_puffer_zeiger^,#$06#$09#$2a#$86#$48#$86))) (* WEB.DE *)

       then
        ASN1(analyseoff);
        (*
        begin ( * in Windows *.CAB * )
          ausschrift('Authenticode ??, Netscape PKCS, S/MIME',signatur);
          einzel_laenge_neu:=m_word(dat_puffer_zeiger^.d[2])+4;
          while ((einzel_laenge_neu and (8-1))<>0) and (einzel_laenge>einzel_laenge_neu) do
            Inc(einzel_laenge_neu);
          einzel_laenge:=einzel_laenge_neu;
        end;*)
  end;

procedure dat_31;
  begin

    if bytesuche_dat_puffer_0('10JP') then  (* PJ10 *)
      pj10(dat_puffer_zeiger^,$21);

    if bytesuche_dat_puffer_0(#$31#$00#$34#$12'???'#$00'???'#$00) then
      begin
        ausschrift('Mewel Window System / Magma Systems; 3Com Resource',bibliothek);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[$4])^+longint_z(@dat_puffer_zeiger^.d[$8])^;
      end;

    if bytesuche_dat_puffer_0('1 ????:???? ') then
      versuche_scitech_driver_tab;

    if bytesuche_dat_puffer_0('1'#$00'??'#$00#$00'??'#$00#$00) then
      kingston_qdata;
  end;


procedure dat_32;
  begin
    if bytesuche_dat_puffer_0('2.0')
    and (analyseoff=$8000) then
      gkware_selfextractor;

    if bytesuche_dat_puffer_0(#$32#$54#$76#$98#$97#$97#$97#$97) then
      tshtsh_daniel_valot;

    if bytesuche_dat_puffer_0(#$32#$5e#$10#$10) then
      begin
        ausschrift('WordPerfect Envoy [1.0]',musik_bild);
        einzel_laenge:=$22+longint_z(@dat_puffer_zeiger^.d[4])^;
      end;

    if bytesuche_dat_puffer_0(#$32#$45#$ea#$dc) then
      begin
        ausschrift(textz_unbekannter_Linux_Diskttenabzugstyp^,signatur);
        einzel_laenge:=16;
      end;
  end;

procedure dat_33;
  begin
    hmi_386:=wahr;

    if  bytesuche_dat_puffer_0('3P')
    and (einzel_laenge>$100)
    and (   bytesuche(dat_puffer_zeiger^.d[$40],'CWC'   )
         or bytesuche(dat_puffer_zeiger^.d[$40],#0#0#0#0))
    then
      begin
        if bytesuche(dat_puffer_zeiger^.d[$40],'CWC') then
          exezk:=textz_dat__gepackt^
        else
          exezk:='';

        ausschrift('Causeway DOS Extender '+textz_dat__Programm^+exezk,dos_win_extender);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[2])^;
      end;
  end;

procedure dat_34;
  var
    w1                  :word_norm;
  begin

    if bytesuche_dat_puffer_0(#$34#$12) then
      with dat_puffer_zeiger^ do
        if  ((d[10] and $0f) in [1..8]) (* bit.. *)
        (* nicht von PMVIEW geschrieben: and (d[11]=$ff) - marker *)
        and (Chr(d[12]) in ['A'..'O']) (* Modus *)
         then
          begin
            w1:=Max(d[10] shr 4,1)*Max(d[10] and $0f,1);
            bild_format_filter('PCPAINT / Pictor',
                           word_z(@d[$02])^,
                           word_z(@d[$04])^,
                           -1,w1,true,false,anstrich);
          end;
  end;

procedure dat_36;
  begin
    if bytesuche_dat_puffer_0(#$36#$04) then
      psf1(dat_puffer_zeiger^);
  end;

procedure dat_37;
  begin
    if bytesuche_dat_puffer_0('777'#$c6#$d2#$c1) then
      ufa(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('7'#$04#$10) then
      quark;

    if bytesuche_dat_puffer_0('7z'#$bc#$af) then
      siebenzip;
  end;

procedure dat_38;
  begin
    (*                         Sig  Ver     Reserved                Channels... *)
    if bytesuche_dat_puffer_0('8BPS'#$00#$01#$00#$00#$00#$00#$00#$00) then
      adobe_photshop(dat_puffer_zeiger^); (* typ_dien *)
  end;

procedure dat_39;
  begin
    (* einzel_lanege=78032 *)
    if bytesuche_dat_puffer_0('9611071510B1')
    or bytesuche_dat_puffer_0('9611271134B1') then
      begin
        ausschrift('Discworld 2 / PSYGNOSIS',spielstand);
        ausschrift_x(puffer_zu_zk_e(dat_puffer_zeiger^.d[12],#0,24),beschreibung,absatz);
      end;


  end;

procedure dat_3a;
  const
    hexzifferngross     =['0'..'9','A'..'F'];
  var
    zeile               :string;
    fehler              :boolean;
    w1                  :word_norm;
  begin
    (*if bytesuche_dat_puffer_0(':') then*)
      (* Intel hex *)
      zeile:=puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[1],240);
      if (not Odd(Length(zeile))) and (Length(zeile)>=(1+2+1+0+1)*2) then
        begin
          fehler:=false;
          for w1:=1 to Length(zeile) do
            if not (zeile[w1] in hexzifferngross) then
              begin
                fehler:=true;
                Break;
              end;
          if not fehler then
            begin
              if  (Length(zeile)=(1+2+1+ziffer(16,Copy(zeile,1,2))+1)*2)
              and (zeile[7  ]='0') and (zeile[8  ] in ['0'..'5']) then
                ausschrift('"Intel Hexadecimal Object File" [16 Bit]',compiler)
              else
              if  (Length(zeile)=(1+4+1+ziffer(16,Copy(zeile,1,2))+1)*2)
              and (zeile[7+4]='0') and (zeile[8+4] in ['0'..'5']) then
                ausschrift('"Intel Hexadecimal Object File" [32 Bit]',compiler)
            end;
        end;
  end;

procedure dat_3b;
  begin
    if bytesuche_dat_puffer_0(';') then
      tr_script;

    if bytesuche_dat_puffer_0('; ') then
      ecsmt_lst;

    if bytesuche_dat_puffer_0('; ') then
      versuche_scitech_driver_tab;

    if bytesuche_dat_puffer_0('; Automatically generated file.') then
      if einzel_laenge<9999 then
        if (na<>'BOOTWIZ') or (ex<>'.CFG') then
          if datei_pos_suche(analyseoff,analyseoff+einzel_laenge,#$0d#$0a'[BOOTMGR]'#$0d#$0a)<>nicht_gefunden then
            bootwiz_cfg(analyseoff,einzel_laenge);

    if bytesuche_dat_puffer_0(';!@Install@') then
      Siebenzip_install_text;

    if bytesuche_dat_puffer_0(';') then
      begin
        if puffer_gefunden(dat_puffer_zeiger^,#$0d#$0a'CardID ')
        or puffer_gefunden(dat_puffer_zeiger^,#$0d#$0a';* hlp.cardid = ') then
          begin
            exezk:=leer_filter(puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[1],80));
            exezk_in_doppelten_anfuerungszeichen;
            ausschrift('Auto Configurator / IBM '+exezk,beschreibung);
            Exit;
          end;

        if (    puffer_gefunden(dat_puffer_zeiger^,'Type ' )  (* OS/2 NIF *)
            and puffer_gefunden(dat_puffer_zeiger^,'Title '))
        or puffer_gefunden(dat_puffer_zeiger^,'[version]')    (* WINDOWS INF*)
        or puffer_gefunden(dat_puffer_zeiger^,'[Version]')    (* WINDOWS INF*)
         then
          begin
            textini;
            Exit;
          end;

        if  (puffer_pos_suche(dat_puffer_zeiger^,#$0a,30)<>nicht_gefunden)
        and (   (puffer_pos_suche(dat_puffer_zeiger^,'.ASM',20)<>nicht_gefunden)
             or (puffer_pos_suche(dat_puffer_zeiger^,'.asm',20)<>nicht_gefunden)
             or (puffer_pos_suche(dat_puffer_zeiger^,'.Asm',20)<>nicht_gefunden))
         then
          ausschrift('Assembler '+textz_dat__Quelltext^,beschreibung);
      end;

  end;

procedure dat_3c; (* '<' *)
  var
    p2                  :puffertyp;
    f1                  :dateigroessetyp;
    w1,w2,w3            :word_norm;
  begin
    with dat_puffer_zeiger^ do
      if (d[1]=$3f) and (d[5]=$20) then
        begin
          puffer_gross(dat_puffer_zeiger^,p2);
          if bytesuche(p2.d[0],'<?XML VERSION="') then
            begin
              ausschrift(puffer_zu_zk_e(d[2],'?',80),signatur);
              f1:=datei_pos_suche(analyseoff,analyseoff+MinDGT(einzel_laenge,1000),'<PAPBASE V');
              if f1<>nicht_gefunden then
                ausschrift('Papyrus',signatur);
            end;
        end;

    if  bytesuche_dat_puffer_0('<   ')
    and bytesuche(dat_puffer_zeiger^.d[$3a],'   '#$01#$01'?'#$2f#$01) then
      begin
        ausschrift('EXETEXT / DRK-SOFT [4.50]',compiler);
        ausschrift(puffer_zu_zk_pstr(dat_puffer_zeiger^.d[0]),beschreibung);
      end;

    (* OS/2 Fixpack Textdateien *)
    if bytesuche_dat_puffer_0('<      ')
    or bytesuche_dat_puffer_0('<'#$0d#$0a#$0d#$0a#$0d#$0a#$0d#$0a)
    or bytesuche_dat_puffer_0('<'#$0a#$0a#$0a#$0a)
     then
      begin
        w2:=0;
        w1:=0;
        while w2<2 do
          begin
            Inc(w2);
            datei_lesen(p2,analyseoff+w1,512);
            w3:=puffer_pos_suche(p2,' ',500);
            if w3=nicht_gefunden then Break;

            Inc(w3,w1);
            w1:=w3+Length(exezk)+2;

            exezk:=datei_lesen__zu_zk_zeilenende(analyseoff+w3);
            if (Length(exezk)>80) or (not ist_ohne_steuerzeichen(exezk)) then Break;

            exezk:=leer_filter(exezk);
            if exezk='' then
              Continue;

            ausschrift(exezk,beschreibung);
            Break;
          end;
      end;
  end;

procedure dat_3e;
  begin
    if bytesuche_dat_puffer_0('>>>McA?ph') then
      ausschrift('MCAFEE '+textz_Kopfkopie^,signatur);
  end;

procedure dat_3f;
  begin
    if bytesuche_dat_puffer_0(#$3F#$5F#$03) then
      windows_hilfedatei(dat_puffer_zeiger^);
  end;

procedure dat_40;
  var
    p_gross             :puffertyp;
  begin
    puffer_gross(dat_puffer_zeiger^,p_gross);

    (* EZ108.EXE\EZSETUP.EXE '@(#)smchdw.h'#$09'   1.00 -93/06/10' *)
    if bytesuche_dat_puffer_0('@(#)') and (einzel_laenge<80) then
      begin
        exezk:=puffer_zu_zk_l(dat_puffer_zeiger^.d[4],DGT_zu_longint(einzel_laenge-4));
        tabexpand(exezk);
        if ist_ohne_steuerzeichen_nicht_so_streng(exezk) then
          ausschrift(exezk,beschreibung);
      end;

    (* Virtual PC 5.1 vpc.exe: keine nonresident name table sonder overlay *)
    if bytesuche_dat_puffer_0('@#') and (einzel_laenge<200) then
      if puffer_gefunden(dat_puffer_zeiger^,'@#') then
        begin
          exezk:=puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[0],DGT_zu_longint(einzel_laenge));
          ausschrift_modulbeschreibung(exezk);
        end;

    if puffer_zeilen_anfang_suche(p_gross,'@ECHO ') then
      bat_datei(p_gross);

    (* *.PCB *)
    if not file_id_diz_datei then
      if bytesuche_dat_puffer_0('@X') then
        if dat_puffer_zeiger^.d[2] in [ord('0') .. ord('9')] then
          ansi_anzeige(analyseoff,#0,ftab.f[farblos,hf]+ftab.f[farblos,vf]
            ,vorne,wahr,wahr,analyseoff+einzel_laenge,'')

  end;

procedure dat_41;
  var
    l1                  :longint;
  begin
    if bytesuche_dat_puffer_0('ASCARON_ARCHIVE V') then
      ascaron_archive(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('APIC???'#$00) then
      acpi_dsdt(dat_puffer_zeiger^,'ACPI Multiple APIC Description Table');

    if bytesuche_dat_puffer_0('Ai?????'#$00#$00'?'#$00) then
      aialf21(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('AddD??'#$00#$00) then
      (* 1503Startup.exe *)
      addd(dat_puffer_zeiger^); (* typ_for4 *)

    if bytesuche_dat_puffer_0('ADdv?'#$00) then
      netscape_reg(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('AP32') and (einzel_laenge>12) then
      aplib(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('AT&TFORM') then
      begin
        l1:=m_longint(dat_puffer_zeiger^.d[8])+4+4+4;
        if (l1<=einzel_laenge) and (l1+1>=einzel_laenge) then
          begin
            ausschrift('"AT&T"',beschreibung);
            einzel_laenge:=4;
            zwischzeile:=false;
          end;
      end;

    if bytesuche_dat_puffer_0('AKT') then
      with dat_puffer_zeiger^ do
        if  (d[3] in [6..10]) (* Version *)
        and (word_z(@d[4])^>=1)
        and (word_z(@d[4])^<=8000) (* Anzahl Dateien *)
         then
          akt_06(dat_puffer_zeiger^);

    with dat_puffer_zeiger^ do
      if bytesuche_dat_puffer_0('AWBM')
      and (word_z(@d[4])^<=640)
      and (word_z(@d[6])^<=480)
      and (word_z(@d[4])^>=  8)
      and (word_z(@d[6])^>=  8)
       then

        begin
          bild_format_filter('AWARD BMP', (* VIA 590: 109CD12.AWD *)
            word_z(@d[4])^,
            word_z(@d[6])^,
            -1,DGT_zu_longint(einzel_laenge) div ((word_z(@d[4])^*word_z(@d[6])^) shr 3),
            false,true,anstrich);
      end;

    if bytesuche_dat_puffer_0(#$41#$86#$51#$44) and (longint_z(@dat_puffer_zeiger^.d[4])^<=einzel_laenge) then
      begin
        ausschrift('Borland Delphi 3.0 Unit ',bibliothek);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[4])^;
      end;

    (* ARJ 2.62 zwischen EXE und SFX Modulen *)
    if  bytesuche_dat_puffer_0('ARJ_SFX'#$00)
    and (einzel_laenge>longint_z(@dat_puffer_zeiger^.d[$c])^) then
      begin
        ausschrift('"ARJ_SFX"',signatur);
        einzel_laenge:=$10;
      end;

    if bytesuche_dat_puffer_0('ASD01'#$1a) then
      asd01(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('ArcBld˛') then
      begin
        if Copy(dateiname,Length(dateiname)+1-2,2)='.1' then
          exezk:=' '+puffer_zu_zk_pstr(dat_puffer_zeiger^.d[7])
        else
          exezk:='';
        (* 1.01 *)
        ausschrift('Archiv UnBuilder / Eric-A. Chan T.'+exezk,packer_dat);
      end;

    if bytesuche_dat_puffer_0('AIShdr'#$1a) then
      ausschrift('Advanced Instrument System / Velvet Studio "'+puffer_zu_zk_pstr(dat_puffer_zeiger^.d[10])+'"',musik_bild);

    if bytesuche_dat_puffer_0('AMShdr'#$1a) then
      ausschrift('Advanced Module System / Velvet Studio "'+puffer_zu_zk_pstr(dat_puffer_zeiger^.d[7])+'"',musik_bild);

    if bytesuche_dat_puffer_0('AH') and (analyseoff=0) then
      ausschrift('HALO / Media Cybernetics',musik_bild);

    if bytesuche_dat_puffer_0('AMF') then
      (* CANNON FUDDER 2 *)
      (* DMP 1.09 *)
      (* ausschrift('AMF '+textz_Klangdatenbibliothek^,musik_bild); *)
      ausschrift('AMF: Digital Sound & Module Interface '+textz_Modul^+' '
        +in_doppelten_anfuerungszeichen(puffer_zu_zk_e(dat_puffer_zeiger^.d[4],#0,32)),musik_bild);

    if bytesuche_dat_puffer_0('ARCV') then
      arcv;

    if bytesuche_dat_puffer_0('ALCHRSRC') then
      ausschrift(textz_dat__Bibliothek^+'  Alchemy Mindworks',bibliothek);

    if bytesuche_dat_puffer_0('Adam') then
      begin
        x_exe_vorhanden:=true;
        x_exe_basis:=analyseoff;
        x_exe_ofs:=0;
        x_exe_untersuchung;
      end;


    if bytesuche_dat_puffer_0('AIL3DIG')
    or bytesuche_dat_puffer_0('AIL3MDI')
     then
      begin
        if dat_puffer_zeiger^.d[4]=ord('M') then
          exezk:=textz_dat__Musik^
        else
          exezk:=textz_dat__Klang^;

        ausschrift('Audio Interface Library / Miles Design [3] '+exezk,bibliothek);
        if chr(dat_puffer_zeiger^.d[$ba]) in ['A'..'Z'] then
          ausschrift_x(puffer_zu_zk_e(dat_puffer_zeiger^.d[$ba],#0,255),beschreibung,absatz);
      end;

    if bytesuche_dat_puffer_0('AMM'#$1a) then (* pp3 *)
      ausschrift('Audio Manager Module / Renegade "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[8],#0,40)+'"',musik_bild);

  end;

procedure dat_42;
  begin

    if bytesuche_dat_puffer_0('BD') then
      macintosh_hfs($000);

    if bytesuche_dat_puffer_0('BOOT???'#$00) then
      acpi_dsdt(dat_puffer_zeiger^,'ACPI Simple Boot Flag Table');

    if bytesuche_dat_puffer_0('BC??'#$00'11') then
      phoenix_bios_modul(dat_puffer_zeiger^);

    if (bytesuche_dat_puffer_0('BIK'))
    and (Chr(dat_puffer_zeiger^.d[3]) in ['i','g','f'])
    and (einzel_laenge=8+longint_z(@dat_puffer_zeiger^.d[4])^) then
      bink_video(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('BH???'#$00) then
      archivarius_bh(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Begin3') then
      with dat_puffer_zeiger^ do
        if d[6] in [$0a,$0d] then
          linux_software_map;

    if bytesuche_dat_puffer_0('BILR?'#$00) then
      xact_lib(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Bee'#$1a) then
      bee;

    if bytesuche_dat_puffer_0('BAR'#$00#$00'?'#$00) then
      bar;

    if bytesuche_dat_puffer_0(#$42#$12#$01#$00'???'#$00) then
      clickteam;

    if bytesuche_dat_puffer_0('BioArc!'#$01#$00) then
      bioarc;

    if bytesuche_dat_puffer_0('BZh?1A') then
      bzip2;

    if bytesuche_dat_puffer_0('Blink by D.T.S.'#0) then
      blink_dts(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('BIX0') and (dat_puffer_zeiger^.d[$1c]<10) then
      bix;

    if bytesuche_dat_puffer_0('BIOSABZUG+CMOS *') then
      begin
        ausschrift(textz_BIOS_Speicherabzug_und_CMOS_Informationen^+' / HOLEN.COM V.K.',beschreibung);
        ermittle_bios_hersteller('',wahr,wahr,wahr,$20000+$80,$20000);
        befehl_schnitt(analyseoff+$00080,$10000,erzeuge_neuen_dateinamen('.Exxx'));
        befehl_schnitt(analyseoff+$10080,$10000,erzeuge_neuen_dateinamen('.Fxxx'));
        befehl_schnitt(analyseoff+$20080,$00080,erzeuge_neuen_dateinamen('.CMOS'));
      end;

    if bytesuche_dat_puffer_0('BZ0')
    and (chr(dat_puffer_zeiger^.d[3]) in ['0'..'9'])
     then
      bzip;

    if bytesuche_dat_puffer_0('BKPNCIHI') then
      ausschrift(textz_dat__Index_fuer^+' Image / Norton Utils',bibliothek);

    if bytesuche_dat_puffer_0('BA???'#0) then
      os2_ico(analyseoff,anstrich);

    if bytesuche_dat_puffer_0('BM') then
      case word_z(@dat_puffer_zeiger^.d[$e])^ of
        $000c, (* OS/2 1.x *)
        $0040, (* OS/2 2.x *)
        $0028, (* OS/2 starwriter, Windows 3 *)
        $0018, (* papyrus 9.21 .exe resourcen *)
        $0024: (* image alchemy -O  "OS/2" *)
          os2_ico(analyseoff,anstrich);
          (*bild_format_filter('BMP [Windows]',
                                 word_z(@dat_puffer_zeiger^.d[$12])^,
                                 word_z(@dat_puffer_zeiger^.d[$16])^,
                                 -1,dat_puffer_zeiger^.d[$1c],false,true,anstrich);*)
      else
        ausschrift('BMP ? ¯',signatur);
      end;

    if bytesuche_dat_puffer_0('BSWF') then
      ausschrift(textz_dat__Font_anf^+puffer_zu_zk_e(dat_puffer_zeiger^.d[$0d],#0,255)+'" / GeoWorks',bibliothek);

    if bytesuche_dat_puffer_0('BW') (* warum? and (analyseoff>0)*)
    and (longint(word_z(@dat_puffer_zeiger^.d[4])^)*512<=einzel_laenge)
     then
      dos4gw_exp(dat_puffer_zeiger^);

  end;

procedure dat_43;
  var
    f1          :dateigroessetyp;
  begin
    if bytesuche_dat_puffer_0('CLU'#$00#$02#$00#$00#$00) then
      clu_eldorado(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Common subdirectories: ') then
      begin
        diff(0,false);
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0('Content-Type: ') then
      mime_encode(analyseoff,einzel_laenge,false,'');

    (* ga110all.exe BIOS disk *)
    if bytesuche_dat_puffer_0('COPYDISK'#$00'?'#$00) then
      with dat_puffer_zeiger^ do
        begin
          ausschrift('CopyDisk / Randy Rumbaugh;HP'+version_x_y(d[9],d[11]),packer_dat);
          einzel_laenge:=$20;
        end;

    if bytesuche_dat_puffer_0('CWS') then
      swc(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Cracker  ') then
      tr_script;

    if bytesuche_dat_puffer_0('CXF'#$1a) then
      cxf(longint_z(@dat_puffer_zeiger^.d[$e])^);

    if bytesuche_dat_puffer_0('CREG'#$00#$00#$01#$00) then
      ausschrift('Windows Registry',bibliothek);

    if bytesuche_dat_puffer_0('COUNTRY.SYS R2.0?  Copy') then
      drdos_country_sys_anzeige(0);

    if bytesuche_dat_puffer_0('CMP0CMP1') then
      comprsia(dat_puffer_zeiger^); (* typ_for4 *)

    if bytesuche_dat_puffer_0('Copyright Daniel F Valot ??????TSHTSH - 1991-') then
      begin
        (* PrÅfsummenblock? *)
        exezk:=puffer_zu_zk_l(dat_puffer_zeiger^.d[0],$32);
        Delete(exezk,26,6);
        exezk_in_doppelten_anfuerungszeichen;
        ausschrift(exezk,beschreibung);
        einzel_laenge:=$32;
      end;

    if bytesuche_dat_puffer_0('CyG ') and (dat_puffer_zeiger^.d[4] in [1..8+1+3]) then
      cryogen(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Cnt') and (einzel_laenge=5) then
      ausschrift('2MF Format: '+str0(word_z(@dat_puffer_zeiger^.d[3])^),signatur);

    if bytesuche_dat_puffer_0('CDF?'#$00#$00)
    and (dat_puffer_zeiger^.d[3] in [ord('1')..ord((*'2'*)'5')])
     then
      cdf(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('CDISK Compressed Image  (') then
      begin
        if dat_puffer_zeiger^.d[$4c]>3 then
          exezk:=' [P]'
        else
          exezk:='';
        ausschrift('FLoppy-Copy / Soenke Mumm, Oliver J. Albrecht "'
         +leer_filter(puffer_zu_zk_e(dat_puffer_zeiger^.d[$34],#0,8+3))+'"'+exezk,packer_dat);
      end;

    if bytesuche_dat_puffer_0('CFSDISKEMU') then
      begin
        if dat_puffer_zeiger^.d[$3e]=0 then
          exezk:=textz_dat__ohne^
        else
          exezk:=textz_dat__mit^;
        ausschrift(textz_dat__Kopf^+'DISK-EMU / Carlos Fern†ndez Sanz ['+exezk+' CRC]',signatur);
        einzel_laenge:=$44;
      end;

    if bytesuche_dat_puffer_0('CQ') then
      begin
        if dat_puffer_zeiger^.d[8] in [$e9,$eb] then
          begin
            ausschrift(textz_dat__Kopf^+'EZ-Copy Plus / EZX Corp',signatur);
            einzel_laenge:=8;
          end
        else
          if dat_puffer_zeiger^.d[$b0] in [$e9,$eb] then
            ausschrift('CopyQM / Sydex "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[$60],' ',11)+'"',signatur);

      end;

    if bytesuche_dat_puffer_0('CoPyRiGhT=') then
      begin
        f1:=puffer_pos_suche(dat_puffer_zeiger^,'>>>M',120);
        if f1=nicht_gefunden then
          f1:=unendlich
        else
          begin
            einzel_laenge:=f1;
            IncDGT(f1,analyseoff);
          end;

        ansi_anzeige(analyseoff,#0#0,ftab.f[farblos,hf]+ftab.f[farblos,vf]
        ,absatz,wahr,wahr,f1,'');
      end;

    if bytesuche_dat_puffer_0('C:\LOADER.SAV'#$00'$') then
      begin
        ausschrift(textz_dat__gesicherte_Partitionstabelle^+' / Loader.Com / Digital Research',signatur);
        einzel_laenge:=$f;
      end;

    if bytesuche_dat_puffer_0('CHNK') then
      ausschrift(textz_dat__Fortsetung^+' ARCV / Eschalon Development',packer_dat);

    if bytesuche_dat_puffer_0('CNT:') then
      ausschrift('Unchunk / Knowledge Dynamics ['+textz_dat__Fortsetung^+']',packer_dat);

    if bytesuche_dat_puffer_0('CI?'#$00) then
      os2_ico(analyseoff,anstrich);

    if bytesuche_dat_puffer_0('CP?'#$00) then
      os2_ico(analyseoff,anstrich);

    if bytesuche_dat_puffer_0('Creative Voice') then
      voc(longint(word_z(@dat_puffer_zeiger^.d[$14])^)+analyseoff);

    if bytesuche_dat_puffer_0('CTMF') then
      ausschrift('Creative '+textz_musikformat^,musik_bild);

    if bytesuche_dat_puffer_0('CRUSH v?.?'#$0a) then
      crush(puffer_zu_zk_e(dat_puffer_zeiger^.d[7],#$0a,4),word_z(@dat_puffer_zeiger^.d[$12])^,
       longint_z(@dat_puffer_zeiger^.d[$16])^);

    if bytesuche_dat_puffer_0('Copy')
     and bytesuche(dat_puffer_zeiger^.d[15],'Syma') then
      begin
        ausschrift(textz_Hilfedatei^+' Norton Utils',bibliothek);
        dat_puffer_zeiger^.d[0]:=0;
      end;

    if bytesuche_dat_puffer_0('CK6'#0#$C5#$A6) then
      begin
        exezk:='';
        b1:=8;
        while dat_puffer_zeiger^.d[b1]>31 do
          begin
            exezk_anhaengen(chr(dat_puffer_zeiger^.d[b1]));
            inc(b1);
          end;
        ausschrift('Commander Keen 6 "'+exezk+'" / id Software',spielstand);

      end;

  end;

procedure dat_44;
  var
    p_gross             :puffertyp;
    w1                  :word_norm;
  begin
    puffer_gross(dat_puffer_zeiger^,p_gross);

    if bytesuche_dat_puffer_0('DFSeeImageFile ') then
      begin
        ausschrift('DFSee image / Jan van Wijk',packer_dat);
        ansi_anzeige(analyseoff,^Z,ftab.f[farblos,hf]+ftab.f[farblos,vf]
       ,absatz,wahr,wahr,analyseoff+einzel_laenge,'')
      end;


    if bytesuche(p_gross.d[0],'DATE: ') then
       elm_oder_nntp(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('DSDT???'#$00) then
      acpi_dsdt(dat_puffer_zeiger^,'ACPI Differentiated System Description Table');

    if bytesuche_dat_puffer_0('DZ???'#$00) then
      smpzipse(dat_puffer_zeiger^);

    (* z.B.: G:\db2\NODE0000\SQL00001\SQLT0002.0\SQLTAG.NAM, 7.1 *)
    if bytesuche_dat_puffer_0('DB2CONT'#$00) then
      ausschrift('IBM DB2 Universal Database SQLTAG.NAM '
        +in_doppelten_anfuerungszeichen(puffer_zu_zk_e(dat_puffer_zeiger^.d[$26],#0,255)),bibliothek);

    if bytesuche_dat_puffer_0('DCA') then
      dca(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('DOS'#$00) and (AndDGT(einzel_laenge,512-1)=0) then
      adf(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Dr.Web ') then
      with dat_puffer_zeiger^ do
        begin
          w1:=puffer_pos_suche(dat_puffer_zeiger^,'IDRW',$180);
          if w1<>nicht_gefunden then
            begin
              ausschrift('Doctor Web Anti-virus',bibliothek);
              ansi_anzeige(analyseoff,'         ',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
                vorne,wahr,wahr,analyseoff+w1-2,'');
              if Odd(d[w1+$47] shr 7) then
                exezk:=textz_dat__main_base^
              else
                exezk:=textz_dat__update^;
              ausschrift_x(exezk+', '+Str0(longint_z(@d[w1+$40])^)+textz_dat___definitions^,bibliothek,absatz);
            end;
        end;

    if bytesuche_dat_puffer_0('DDMF') and (dat_puffer_zeiger^.d[4] in [0..10]) then
      Delusion_Digital_Music_Fileformat;

    if bytesuche_dat_puffer_0('DELL_LZ_IMAGE'#$00) then
      dell_lz_image(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('DBSOFT-HEADER') then
      dbsoft_header(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('DBSOFT-ACE') then
      dbsoft_ace(dat_puffer_zeiger^);

    if  bytesuche_dat_puffer_0('DLL ')
    and (word_z(@dat_puffer_zeiger^.d[4])^<$500)
     then
      begin
        x_exe_vorhanden:=true;
        x_exe_basis:=analyseoff;
        x_exe_ofs:=0;
        x_exe_untersuchung;
      end;

    if bytesuche_dat_puffer_0('DCE!') and (analyseoff>0) then
      ausschrift('Data Crack Engine / Piratel [3.0]',compiler);

    if bytesuche_dat_puffer_0('DH'#$09#$02) then
      impos2;

    if puffer_zeilen_anfang_suche(p_gross,'DEBUG.')
    or puffer_zeilen_anfang_suche(p_gross,'DEBUG ')
     then
      bat_datei(p_gross);


    if bytesuche_dat_puffer_0('DHF') then
      descent_hog;

    if bytesuche_dat_puffer_0('DSND') then
      descent_dsnd(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('DiskFile') then
      begin
        ausschrift('Scopy / Craig Gaumer, Ed Bachman [/2|/C]',packer_dat);
        if dat_puffer_zeiger^.d[$13]>0 then
          ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[$20],#0,80),beschreibung);
      end;

    if bytesuche_dat_puffer_0('DISKFILE') then
      begin
        ausschrift('Scopy / Craig Gaumer, Ed Bachman [/'+str0(dat_puffer_zeiger^.d[$12])+']',packer_dat);
        if dat_puffer_zeiger^.d[$13]>0 then
          ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[$20],#0,80),beschreibung);
      end;

    if bytesuche_dat_puffer_0('DSIGDC') then
      crossepac(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('DCU') then
      tpu_system(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('DS'#$27'L install') then
      ausschrift(textz_dat__unbekanntes_Archiv^+' <Doctor Stein''s Labs> ¯',packer_dat);

    if bytesuche_dat_puffer_0('DSM') then
      (* CMC *)
      ausschrift('Digital Sound Module / Psychic Monks "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[4],#0,$20)+'"',musik_bild);

    if bytesuche_dat_puffer_0('DS') and (dat_puffer_zeiger^.d[2]<=3)then
      quantum(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('DDSF') then
      ausschrift('Delusion Digital Sound File "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[5],#0,22)+'"',musik_bild);

    if bytesuche_dat_puffer_0('DiskImage') then
      ausschrift('DISKCOPY '+textz_dat__Abzugsdaten^+' / DR-DOS, Novell Dos 7',bibliothek);

    if bytesuche_dat_puffer_0('DskImage'#$00#$00) then
      begin
        ausschrift('PMFloppy '+textz_dat__Abzugsdaten^+' / Greg Bryant',bibliothek);
        einzel_laenge:=$2d;
      end;

    if bytesuche_dat_puffer_0('DOUBLE DENSITY VOLUME') then
      begin
        exezk:='';
        b1:=0;
        while dat_puffer_zeiger^.d[b1]>31 do
          begin
            exezk_anhaengen(chr(dat_puffer_zeiger^.d[b1]));
            inc(b1);
          end;
        exezk_anhaengen(double_density_pass(word_z(@dat_puffer_zeiger^.d[$172])^));
        ausschrift(exezk,packer_dat);
      end;

    if bytesuche_dat_puffer_0('DISKREET ') then
      begin
        exezk:='';
        b1:=$29;
        while dat_puffer_zeiger^.d[b1]>31 do
          begin
            exezk_anhaengen(chr(dat_puffer_zeiger^.d[b1]));
            inc(b1);
          end;
        ausschrift('Norton Utils Diskreet '+textz_dat__Datentraeger^+' / Symantec "'+exezk+'"',packer_dat);
      end;


    if bytesuche_dat_puffer_0('DIRH') then
      begin
        ausschrift(textz_Inhaltsverzeichnis^+' Phar Lap .EXP',signatur);
        einzel_laenge:=$60;
        if longint_z(@dat_puffer_zeiger^.d[$38])^<>0 then
          einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[$38])^-analyseoff;
      end;

    if bytesuche_dat_puffer_0('DGSS') then
      begin
        exezk:=puffer_zu_zk_e(dat_puffer_zeiger^.d[8],#0,255);
        if dat_puffer_zeiger^.d[4]>=$13 then
          ausschrift('DESCENT / PARALLAX [2] "'+exezk+'"',spielstand)
        else
          ausschrift('DESCENT / PARALLAX [REG 1] "'+exezk+'"',spielstand)
      end;

    if bytesuche_dat_puffer_0('DOSEMU'#$00) then
      begin
        ausschrift(textz_dat__simulierte_Festplatte^+' / Linux DOSEMU',signatur);
        einzel_laenge:=$80;
      end;

    if bytesuche_dat_puffer_0('DDA2') then
      dda2;

    if bytesuche_dat_puffer_0('Dirk Paehl(c)9') then
      dirk_paehl;

    if  bytesuche_dat_puffer_0('DR')
    and (longint(word_z(@dat_puffer_zeiger^.d[2])^)*22+4=longint_z(@dat_puffer_zeiger^.d[$12])^)
     then
      rd_archiv(dat_puffer_zeiger^);
  end;

procedure dat_45;
  var
    ea_groesse          :longint;
    p_gross             :puffertyp;
    w                   :word_norm;
  begin
    puffer_gross(dat_puffer_zeiger^,p_gross);

    if bytesuche_dat_puffer_0('ER') then
      begin
        apple_driver_descriptor;
        versuche_iso9660;
      end;

    if bytesuche_dat_puffer_0('EALIB') then
      ealib;

    if bytesuche(p_gross.d[0],'EXTPROC ') then
      extproc(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('EddyHawk'#$27's Info List') then
      EddyHawk_infolist;

    if bytesuche_dat_puffer_0(#$45#$3d#$cd#$28) then
      romfs;

    if bytesuche_dat_puffer_0('ESE') then
      ese(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Ench'#$00) then
      ENhanced_Compressor;

    if bytesuche_dat_puffer_0('ESIV') and (analyseoff>0) then
      vise_pe(dat_puffer_zeiger^);

    (* F-PROT SETUPFS.EXE *)
    if  bytesuche_dat_puffer_0('EPSF')
    and (dat_puffer_zeiger^.d[4] in [$01..$10])
     then
      ausschrift('Eschalon Setup',packer_dat);

    if bytesuche_dat_puffer_0('EZCP??'#$00) then
      begin
        ausschrift(textz_dat__Kopf^+'EZ-DiskCopy Pro / EZX',signatur);
        einzel_laenge:=$2e;
      end;

    if bytesuche_dat_puffer_0('ED')
    and bytesuche(dat_puffer_zeiger^.d[$84],'ED!LNG') then
      ausschrift('Easy Docs / Martin King [2.2]',compiler);


    if bytesuche_dat_puffer_0('ED'#0#0) then
      begin
        ausschrift(textz_Tabelle_OS2_Erweiterte_Attribute_auf_FAT^,signatur);
        ea_data_sf_clustersize:=1;
        for w:=9 to 15 do
          if bytesuche__datei_lesen(analyseoff+1 shl w,'EA??'#$00#$00) then
            begin
              ea_data_sf_clustersize:=1 shl w;
              einzel_laenge:=1 shl w;
              Break;
            end;
      end;

    if bytesuche_dat_puffer_0('EA??'#0#0) then
      begin
        ausschrift(textz_Erweiterte_Attribute_OS2_anf^+puffer_zu_zk_e(dat_puffer_zeiger^.d[8],#0,100)+'"',signatur);
        ea_groesse:=longint_z(@dat_puffer_zeiger^.d[$1a])^+$20;

        ea_archiv('',analyseoff+$1a);
        (*ausschrift(hex_longint(analyseoff)+': '+hex_longint(ea_groesse)
               +'->'+hex_longint((ea_groesse+ea_data_sf_clustersize-1) and (-ea_data_sf_clustersize)),normal);*)
        ea_groesse:=(ea_groesse+ea_data_sf_clustersize-1) and (-ea_data_sf_clustersize);

        if ea_groesse<einzel_laenge then
          einzel_laenge:=ea_groesse;
      end;

    if bytesuche_dat_puffer_0('ENTPACK#'#13#10) then
      ausschrift(textz_Speicherabzug^+chr(dat_puffer_zeiger^.d[$86])+' FOTO.COM / Veit Kannegieser ['+
      puffer_zu_zk_e(dat_puffer_zeiger^.d[$89],#0,255)+']',signatur);

    if puffer_zeilen_anfang_suche(p_gross,'ECHO ') then
      bat_datei(p_gross);

    if bytesuche_dat_puffer_0('EDILZSS1') then
      (* 'EDILZSS1' Microsoft CD Compusoft *)
      (*
      ausschrift(textz_dat__unbekanntes_Archiv^
       +' <EDILZSS1/ Robert Salesas> "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[8],#0,255)+'"',packer_dat);*)
      edi_install(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('EDILZSS2') then
      edi_install(dat_puffer_zeiger^);


    if bytesuche_dat_puffer_0('EL'#$08#$08) then
      begin
        ausschrift(textz_Grafiktreiber^+' BGI [Eurologic]',bibliothek);
        bgi_text(dat_puffer_zeiger^);
      end;


    if bytesuche_dat_puffer_0('ExVira -') then
      ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[0],#27,255),packer_dat);

    if bytesuche_dat_puffer_0('ELITE Com') then
      begin
        ausschrift('Elite [2] / Bell & Braben + Realtime Sofware',spielstand);
        dat_puffer_zeiger^.d[0]:=0;
      end;

    if bytesuche_dat_puffer_0('ELITE2') then
      begin
        ausschrift('Elite 2.00 / Code Blasters',packer_dat);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[$c])^+$10;
      end;

    if bytesuche_dat_puffer_0('Erweiterter Plattenabzug fÅr E0X') then
      begin
        ausschrift(textz_Erweiter_Plattenabzug_fuer_E0X_Kopf^,signatur);
        einzel_laenge:=512;
      end;

    if bytesuche_dat_puffer_0('Extended Module: ') then
      ft_extended_module(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Extended Instrument: ') then
      ausschrift(textz_Erweiters_Instrument^+' / Fast Tracker 2  "'
       +puffer_zu_zk_e(dat_puffer_zeiger^.d[$15],#0,21)+'"',musik_bild);

    if bytesuche_dat_puffer_0('ESP>') then
      esp(dat_puffer_zeiger^);

  end;

procedure dat_46;
  var
    w1                  :word_norm;
  begin
    if bytesuche_dat_puffer_0('FACP???'#$00) then
      acpi_dsdt(dat_puffer_zeiger^,'ACPI Fixed ACPI Description Table');

    if bytesuche_dat_puffer_0('FACS??'#00#$00) then
      acpi_facs(dat_puffer_zeiger^,'ACPI Firmware ACPI Control Structure');

    if bytesuche_dat_puffer_0('FL'#$03#$04) then
      LSP_SFX_Builder;

    if bytesuche_dat_puffer_0('FINEAR') then
      finear(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('FXPF') and (longint_z(@dat_puffer_zeiger^.d[6])^=einzel_laenge) then
      foxpatchf(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('FLASHImageData'#$00#$1a) then
      dell_falshimagedata;

    if bytesuche_dat_puffer_0('FFS!??'#$00#$00) then
      ffs_archiv;

    if bytesuche_dat_puffer_0('FarStone$CD') then
      (* von Ehm mitgebracht - wahrscheinlich windows-schrott *)
      ausschrift((*'FarStone CD EMU?'*)puffer_zu_zk_e(dat_puffer_zeiger^.d[$30],#0,255),beschreibung);

    if bytesuche_dat_puffer_0('FWS')
    and ((dat_puffer_zeiger^.d[3] and $f8)=0) then (* 3 4 bei OS/2 "5" *)
      macromedia_flash(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$46#$01#$00#$01#$21) then
      graham_archiv(dat_puffer_zeiger^);

    if  bytesuche_dat_puffer_0('FR')
    and (word_z(@dat_puffer_zeiger^.d[$12])^<60)
     then
      freeze;

    if bytesuche_dat_puffer_0('FAR˛') then
      ausschrift('Farandole '+textz_Modul^+' '+puffer_zu_zk_l(dat_puffer_zeiger^.d[4],40),musik_bild);

    if bytesuche_dat_puffer_0('FSM˛') then
      ausschrift('Farandole Sample "'+puffer_zu_zk_l(dat_puffer_zeiger^.d[4],32)+'"',musik_bild);

    if bytesuche_dat_puffer_0('FORM') then
      form;

    if bytesuche_dat_puffer_0('FBOV') then
      begin
        ausschrift('Borland Overlay',overlay_);
        (* NWDOS\FBX.EXE *)
        if bytesuche(dat_puffer_zeiger^.d[$10],'(c)199? Tal') then
          ausschrift('Kvetch / Tal Nevo',packer_exe)
        else
          begin
            if einzel_laenge<>longint_z(@dat_puffer_zeiger^.d[4])^+8+8 then
              einzel_laenge:= longint_z(@dat_puffer_zeiger^.d[4])^+8;
            (* STRIKE C.:  while einzel_laenge mod 16<>0 do inc(einzel_laenge);*)
          end;
      end;

    if bytesuche_dat_puffer_0('FBPR') then
      begin
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[4])^+8;
        borland_pascal_resource(longint_z(@dat_puffer_zeiger^.d[8])^,longint_z(@dat_puffer_zeiger^.d[4])^,32);
      end;

    if bytesuche_dat_puffer_0('FBHF') then
      begin
        (* \bp\exampels\dos\tvfm\ *)
        ausschrift('Turbo Vision '+textz_Hilfedatei^+' [TVHC]',bibliothek);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[4])^+8;
      end;

    if bytesuche_dat_puffer_0('FBGD'#$08#$08) then
      begin
        ausschrift(textz_Grafiktreiber^+' BGI [TP 7.00]',bibliothek);
        bgi_text(dat_puffer_zeiger^);
      end;

    if bytesuche_dat_puffer_0('FBIN') then
      begin (* Compushow 2000!  2schow *)
        ausschrift(textz_Installationskonfiguration^+' / ???',signatur);
        w1:=dat_puffer_zeiger^.d[4];
        ansi_anzeige(analyseoff+8,#26,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,analyseoff+4+w1,'');
        einzel_laenge:=w1+8;
      end;

    if bytesuche_dat_puffer_0('FBEX') then
      begin (* Compushow 2000!  2schow *)
        ausschrift(textz_Installationsdaten^,signatur);
        einzel_laenge:=8;
      end;

    if bytesuche_dat_puffer_0('FxH!') then
      begin
        ausschrift(textz_Hilfedatei^+' Flambeaux Sofware',bibliothek);
        ansi_anzeige(analyseoff+6,#26,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr,unendlich,'')
      end;

    if (   bytesuche_dat_puffer_0('From ')
        or bytesuche_dat_puffer_0('From: ')) (* nicht voll unterstÅtzt *)
     then
      elm_oder_nntp(dat_puffer_zeiger^);

  end;

procedure dat_47;
  begin
    if bytesuche_dat_puffer_0('GRFX') then
      amibios_grfx(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('GNAL') then
      with dat_puffer_zeiger^ do
        if  (Chr(d[4]) in ['A'..'Z'])
        and (Chr(d[5]) in ['A'..'Z'])
        and (d[$8]=$18) then
          begin
            ausschrift('AMI BIOS language strings: '+Chr(d[5])+Chr(d[4])+', '+str0((word_z(@d[$18])^-$18) div 2),bibliothek);
          end;

    if bytesuche_dat_puffer_0('Ghido?'#$00) then
      qlfc;

    if bytesuche_dat_puffer_0('GDM˛') then
      with dat_puffer_zeiger^ do
        if d[4+31]=0 then
          (*FI*)
          (* gdmkit10 *)
          ausschrift('Generic Mod Music / Edward Shlunder "'+puffer_zu_zk_e(d[4],#0,32)+'"',musik_bild);

    if bytesuche_dat_puffer_0('GIF8?a') then
      gif_anzeige(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('GX2') then
      ausschrift('Freelance '+textz_Grafik^,musik_bild);

    if bytesuche_dat_puffer_0('GSC') then
      ausschrift('Worms '+textz_Landschaft^,musik_bild);

    if bytesuche_dat_puffer_0('GF1PA') then (* CONVERT *)
      ausschrift('GUS Patch "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[$ef],#0,80)+'"',musik_bild);

  end;

procedure dat_48;
  begin
    if bytesuche_dat_puffer_0('HEROSOFTSOUTHERN') then
      herosoft(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('HMIMIDIP') then
      begin
        ausschrift('Hmi Midi P / Human Machine Interface',musik_bild);
        befehl_hmp;
      end;

    if bytesuche_dat_puffer_0('HPAK') then
      hpack;

    if bytesuche_dat_puffer_0('HA') then
      ha(dat_puffer_zeiger^,'');

    if bytesuche_dat_puffer_0('HLSQZ') then
      sqz(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('HSPP') then
      begin
        ausschrift('Borland Delphi 2.0 Unit ',bibliothek);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[4])^;
      end
    else
      if bytesuche_dat_puffer_0('HSP') then
        with dat_puffer_zeiger^ do
          begin
            case d[3] of
              $01:exezk:=textz_Infodatei^;
              $10:exezk:=textz_Hilfedatei^;
            else
              exezk:=textz_Hilfedatei^+' ? ¯';
            end;

            exezk_anhaengen(' OS/2 "');

            z:=$6b;
            while d[z]>=Ord(' ') do
              begin
                exezk_anhaengen(chr(d[z]));
                Inc(z);
              end;

            ausschrift(exezk+'"',bibliothek);
            ausschrift_x(textz_dat__Themen__^+str0(word_z(@d[$8])^)+textz___Woerter__^+str0(word_z(@d[$48])^),bibliothek,leer);
          end;

  end;

procedure dat_49;
  var
    w1                  :word_norm;
  begin
    if bytesuche_dat_puffer_0('ID3') then
      id3(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Index: ') then
      rcs;

    if bytesuche_dat_puffer_0('IFAH') then
      ifah;

    if bytesuche_dat_puffer_0('ICTSELFX??'#$00#$00) then
      ictselfx;

    if bytesuche_dat_puffer_0('IBM DDPAK V?.?'#$00#$00) then
      ibm_dd_pak(dat_puffer_zeiger^); (* typ_for4 *)

    if bytesuche_dat_puffer_0('InS_StArT'#$0d#$0a) then (* DRDOS: *.INS *)
      begin
        ausschrift('Open Data-Link Interface - '+textz_dat__treiber_beschreibung^,signatur);
        w1:=puffer_zeilen_anfang_suche_pos(dat_puffer_zeiger^,'^');
        exezk:=datei_lesen__zu_zk_zeilenende(analyseoff+w1+Length('^'));
        ausschrift_x(exezk,beschreibung,absatz);
      end;

    if bytesuche_dat_puffer_0('ITSF??'#$00#$00) then
      HtmlHelp_ms;

    if bytesuche_dat_puffer_0('ITOLITLS??'#$00#$00) then
      its_ms(dat_puffer_zeiger^);

    if  bytesuche_dat_puffer_0('ISc(?'#$00#$00)
    or  bytesuche_dat_puffer_0('ISc(?'+'R')
    or (bytesuche_dat_puffer_0('ISc(?') and (word_z(@dat_puffer_zeiger^.d[$c])^=$0200))
     then
      stirling_isc(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('InstallShield'#$00'?'#$00#$00) then
      if longint_z(@dat_puffer_zeiger^.d[$13a])^>0 then
        installshield_18000;

    if  bytesuche_dat_puffer_0('IMP'#$0a)
    and (longint_z(@dat_puffer_zeiger^.d[4])^<=einzel_laenge)
    and (longint_z(@dat_puffer_zeiger^.d[4])^>=1000)
     then
      imp(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('IDA0') then
      begin
        exezk:='';
        if not bytesuche(dat_puffer_zeiger^.d[$2c],'B-tree v') then
          exezk_anhaengen(' (pack)');
        ausschrift('Interactive Disassembler / Ilfak Guilfanov [3.5,3.7]'+exezk,bibliothek);
      end;

    if bytesuche_dat_puffer_0('IDAIDS') then
      ausschrift('DLL-'+textz_beschreibung^+' Interactive Disassembler / Ilfak Guilfanov [3.7]',bibliothek);

    if bytesuche_dat_puffer_0('IDASGN') then
      ausschrift('Interactive Disassembler / Ilfak Guilfanov [3.7] "'
      +puffer_zu_zk_l(dat_puffer_zeiger^.d[$25],dat_puffer_zeiger^.d[$22])+'"',bibliothek);

    if bytesuche_dat_puffer_0('II*'#0) then
      tiff(analyseoff,einzel_laenge,'');

    if bytesuche_dat_puffer_0('IWAD') then
      ausschrift('IWAD-'+textz_Hauptbibliothek^+' DOOM 2 / id-Sofware',bibliothek);

    if bytesuche_dat_puffer_0('IC?'#$00) then
      os2_ico(analyseoff,anstrich);

    if bytesuche_dat_puffer_0('IMPM') then
      (* FTP.CDROM.COM MUSIC/ *)
      ausschrift('Impulse Tracker '+textz_Modul^+' "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[4],#0,80)+'"',musik_bild);

  end;

procedure dat_4a;
  begin
    if not textdatei then
      if bytesuche_dat_puffer_0('JN') then
        modul_669; (* extended *)

    if bytesuche_dat_puffer_0('JFCP') and not textdatei then
      jfcp;

    (* AVI auf 2048 Byte CD-Sektorgroesse erwietert *)
    if bytesuche_dat_puffer_0('JUNK??'#$00#$00) then
      with dat_puffer_zeiger^ do
        if (longint_z(@d[4])^+8>8) and (longint_z(@d[4])^+8<=einzel_laenge) then
          begin
            einzel_laenge:=longint_z(@d[4])^+8;
            ausschrift('JUNK ('+str11_oder_hexDGT(einzel_laenge)+')',normal);
          end;

    if bytesuche_dat_puffer_0('JLS??'#$00#$00) then
      jls_archiv(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('JARCS'#$00) then
      jarcs(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('JN') then
      begin
        ausschrift(textz_Modul^+' 669',musik_bild);
        ausschrift(puffer_zu_zk_l(dat_puffer_zeiger^.d[$02],$24),beschreibung);
        ausschrift(puffer_zu_zk_l(dat_puffer_zeiger^.d[$26],$24),beschreibung);
        ausschrift(puffer_zu_zk_l(dat_puffer_zeiger^.d[$4A],$24),beschreibung);
      end;

    if bytesuche_dat_puffer_0('JRchive') then
      jrc;

    if bytesuche_dat_puffer_0('JPI') then
      ausschrift('Jensen & Partners I. [Modula-2] '+textz_Debug_Informationen^+' ['
      +str0(dat_puffer_zeiger^.d[3] div 16)+'.'+str0(dat_puffer_zeiger^.d[3] mod 16)+']',bibliothek);
  end;

procedure dat_4b;
  begin
    if bytesuche_dat_puffer_0('KJ') then
      pocket_arch(dat_puffer_zeiger^);

    (* EXPLZ250.EXE *)
    if bytesuche_dat_puffer_0('KM')
    and (word_z(@dat_puffer_zeiger^.d[2])^<600)
     then
      begin
        (*ausschrift('EXPLZ250: KM / ? ¯',packer_dat);*)
        ausschrift('CabSfx / K. Miyauchi',packer_dat);
        einzel_laenge:=word_z(@dat_puffer_zeiger^.d[2])^
      end;

    if bytesuche_dat_puffer_0('KWAJ') then
      (* 'KWAJà'—' org MS-DOS 6.20 VSAFE.CO_ *)
      compress_ms(dat_puffer_zeiger^,analyseoff,einzel_laenge,'');

    if bytesuche_dat_puffer_0('K*') then
      rtpatch(dat_puffer_zeiger^,'');

    (* KAZIP 0.99 *)
    if bytesuche_dat_puffer_0('KA'#$00#$01) then
      kazip_kopf;

  end;

procedure dat_4c;
  var
    coff_laenge:dateigroessetyp;
  begin

    if bytesuche_dat_puffer_0('LinS') then
      with dat_puffer_zeiger^ do
        if  (word_z(@d[4])^<9999) and (word_z(@d[4])^>0)
        and (word_z(@d[6])^<9999) and (word_z(@d[6])^>0) then
          bild_format_filter('MicroSoft Paint',
                               word_z(@d[4])^,
                               word_z(@d[6])^,
                               -1,1,false,true,anstrich);

    if bytesuche_dat_puffer_0('LZX'#$00) then
      lzx;

    if bytesuche_dat_puffer_0('LZK Version 1.0'#$00) then
      lzk;

    if bytesuche_dat_puffer_0('LPAC') then
      lpac(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Li') then
      if  (word_z(@dat_puffer_zeiger^.d[3])^<einzel_laenge)
      and (word_z(@dat_puffer_zeiger^.d[3])^>2+1+2+2+2) then
        tesca3(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('LDF0'#$1a#$00) then
      ldf(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('LG') then
      with dat_puffer_zeiger^ do
        begin
          if  (g>200)
          and (d[4] in [0,1,2,3,4,$52]) (* CPY ASC HSC BMP INC *)
          and (longint_z(@d[5  ])^<=longint_z(@d[5+4])^)
          and (longint_z(@d[5+4])^<800*1024*1024)
          and (word_z(@d[2])^>=1)
          and (word_z(@d[2])^<20000)
           then arh;
        end;

    if bytesuche_dat_puffer_0('LS'#$00#$0c) then
      begin
        ausschrift('LS_000c / LaserStars Technologies',signatur);
        ls000c;
        einzel_laenge:=16+longint_z(@dat_puffer_zeiger^.d[8])^;
      end;

    if bytesuche_dat_puffer_0('LS'#$00#$0d) then
      begin
        ausschrift('LS_000d / LaserStars Technologies',signatur);
        ls000d;
        einzel_laenge:=8+longint_z(@dat_puffer_zeiger^.d[4])^;
      end;

    if bytesuche_dat_puffer_0('LEOLZW') then
      leolzw;

    if bytesuche_dat_puffer_0('LI'#$00#$01) then
      ausschrift(textz_Sammlung^+' Icon Heaven / Frobozz Magic Software',musik_bild);

    if bytesuche_dat_puffer_0('LBC') then
      chlib(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$4c#$01) then
      begin
        coff(analyseoff,0,coff_laenge);
        if coff_laenge<>0 then
          einzel_laenge:=coff_laenge;
      end;

    if bytesuche_dat_puffer_0('LOGO') then
      ausschrift('Windows / MS '+textz_Logokode^,bibliothek);

    if bytesuche_dat_puffer_0('LN'#$02#$00#$00#$00#$3A#$00) then
      ausschrift(textz_Hilfedatei^+' QBasic',bibliothek);

    if bytesuche_dat_puffer_0('LM'#$1a) then
      limit(dat_puffer_zeiger^.d[5]);

    if (bytesuche_dat_puffer_0('LX')
    or bytesuche_dat_puffer_0('LE'))
    and (dat_puffer_zeiger^.d[2] in [0,1,255]) then
      begin
        x_exe_basis:=analyseoff;
        x_exe_ofs:=0;
        x_exe_untersuchung;
      end;


  end;

procedure dat_4d;
  var
    coff_laenge         :dateigroessetyp;
    zaehler             :word_norm;
    schluessel          :byte;
    xorl4               :longint;
    mpv2_laenge         :longint;
    w1                  :word_norm;
  begin

    if bytesuche_dat_puffer_0('MegaGraph Font File:'#$00) then
      with dat_puffer_zeiger^ do
        begin
          ausschrift('MegaGraph Font File '+str0(word_z(@d[$10a])^)+'*'+str0(word_z(@d[$108])^),musik_bild);
          ausschrift_x(leer_filter(puffer_zu_zk_e(d[$15],#$00,$3a)),beschreibung,absatz);
          ausschrift_x(leer_filter(puffer_zu_zk_e(d[$4f],#$1a,$af)),beschreibung,absatz);
        end;

    if bytesuche_dat_puffer_0('MONITOR.DBX'#$00#$00) then
      if ModDGT(einzel_laenge,$74)=$13 then
        begin
          ausschrift('ScitechSoft Montior.DBX ('+str0_DGT(DivDGT(einzel_laenge,$74))+')',bibliothek);
        end;

  (*if bytesuche_dat_puffer_0('MIME-Version: 1.?'#$0a'Content-') then
    if bytesuche_dat_puffer_0('MIME-Version: 0'#$0d#$0a'Content-') then*)
    if bytesuche_dat_puffer_0('MIME-Version: ') then
      mime_encode(analyseoff,einzel_laenge,false,'');


    if bytesuche_dat_puffer_0('MPU'#$00) then
      with dat_puffer_zeiger^ do
        if bytesuche(d[$100-2],#$00#$00'PK') then
          begin
            einzel_laenge:=$100;
            ausschrift('DelZip / C. Bunton, E. W. Engler, M. Stephany ; "SE MAKER"',packer_dat);

            w1:=7;
            if d[4]>0 then
              ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_l(d[w1],d[4])),beschreibung,absatz);
            Inc(w1,d[4]);
            if d[5]>0 then
              ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_l(d[w1],d[5])),beschreibung,absatz);
            Inc(w1,d[5]);
            if d[6]>0 then
              ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_l(d[w1],d[6])),beschreibung,absatz);
          end;

    if bytesuche_dat_puffer_0('MCFX') then
      mcfx(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('MAS_UTrack_V00') then
      MAS_UTrack_V00(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('MAUL')
    and (einzel_laenge>300)
    and (longint_z(@dat_puffer_zeiger^.d[$24])^=0)
     then
      ausschrift('Maul / Peter Koller',musik_bild);

    if bytesuche_dat_puffer_0('MZ'#$53#$01#$02#$ff#$ff#$f0#$ff#$01#$f0#$ff) then
      begin
        exezk:=puffer_zu_zk_pstr(dat_puffer_zeiger^.d[$40]);
        schluessel:=$96;
        for zaehler:=1 to length(exezk) do
          begin
            exezk[zaehler]:=chr(ord(exezk[zaehler]) xor schluessel);
            inc(schluessel,3);
          end;
        ausschrift('KLOCK / MaX / MovSD "'+exezk+'"',beschreibung);
      end;

    if bytesuche_dat_puffer_0('MRI'#$01) then
      with dat_puffer_zeiger^ do
        begin
          if (d[$10]<>0) or (d[$0c]<>0) then
            begin (* alte Version mit zip *)
              ausschrift('MRI / ??? <1:zip>',packer_dat);
              ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_l(d[$15],d[$4])),beschreibung,absatz);
              einzel_laenge:=d[4]+d[5]+d[6]+d[7]+longint_z(@d[8])^+longint_z(@d[$c])^+$15;
            end
          else
            begin (* neue Version mit MSCF *)
              ausschrift('MRI / ??? <2:mscf>',packer_dat);
              ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_l(d[$15+5],d[$4])),beschreibung,absatz);
              ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_l(d[$15+5+d[$4]],d[$5])),beschreibung,absatz);
              einzel_laenge:=d[4]+d[5]+d[6]+d[7]+d[8]+longint_z(@d[8+1])^+longint_z(@d[$c+1])^+$15+5;
              xorl4:=x_longint__datei_lesen(analyseoff+einzel_laenge) xor $4643534d; (* MSCF *)
              if Lo(xorl4)=Hi(xorl4) then
                merke_position(analyseoff+einzel_laenge,datentyp_mscf_xor);
            end;
        end;

    if bytesuche_dat_puffer_0(#$4d#$01'?'#$00) then
      begin
        coff(analyseoff,0,coff_laenge);
        if coff_laenge<>0 then
          einzel_laenge:=coff_laenge;
      end;

    if bytesuche_dat_puffer_0('MP3'#$1a#$00) then
      begin
        mpc3;
        Exit; (* PH .EXP .. *)
      end;

    if bytesuche_dat_puffer_0('MPV????'#$00) then
      with dat_puffer_zeiger^ do
        if bytesuche(d[d[6]],'PK') then
          begin
            einzel_laenge:=d[6];
            install_builder_joseph_leung(d[3]);
            Exit; (* PH .EXP .. *)
          end;

    if bytesuche_dat_puffer_0('MS') then
      with dat_puffer_zeiger^ do
        if  (d[2]>10) (* Version 1.0 *)
        and (d[2]<90) (* Version 9.0 *)
        and (d[3] in [0..10]) (* Methode *)
        and (longint_z(@d[4])^>=longint_z(@d[8])^) (* mit "Erfolg" gepackt *)
        and (d[$0c]>3)   (* Name 3.. *)
        and (d[$0c]<100) (*    ..100 *)
         then
          begin
            exezk:=puffer_zu_zk_pstr(d[$0c]);
            (* Dateiname? *)
            if filter(exezk)=exezk then
              msxie(d[2]);
          end;

    if codebuilder then
      ausschrift('Intel Code Builder "'+puffer_zu_zk_l(dat_puffer_zeiger^.d[0],2)+'"',compiler);

    if bytesuche_dat_puffer_0('MPQ'#$1a) then
      begin
        ausschrift('MPQ / ??? ¯',packer_dat);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[8])^;
        exit; (* PH .EXP .. *)
      end;

    if bytesuche_dat_puffer_0('MPV2') then (* powarc800.exe *)
      with dat_puffer_zeiger^ do
        begin
          mpv2_laenge:=word_z(@d[6])^;
          if (mpv2_laenge>20) and (mpv2_laenge<1000) then
            begin
              ausschrift('MPV2 - PowerArchiver CAB SFX / ConeXware',bibliothek);
              ausschrift_x(puffer_zu_zk_pstr(d[$c]),beschreibung,absatz);
              einzel_laenge:=mpv2_laenge;
            end;
        end;

    if bytesuche_dat_puffer_0('MP')
    and (not textdatei) (* MPAUSE.TXT *)
    and (not hersteller_gefunden)
     then
      ausschrift('Phar Lap .EXP '+textz_dat__Datei_alt^,dos_win_extender);

    if bytesuche_dat_puffer_0('MDA  1.1') then
      begin
        ausschrift('MDA 1.1 / [? Micrografx : DESIGNER]',packer_dat);
        dat_puffer_zeiger^.d[0]:=0;
      end;

    if bytesuche_dat_puffer_0('MDF'#0) then
      ausschrift('MDIFF '+puffer_zu_zk_l(dat_puffer_zeiger^.d[4],4)+' / Maurizio Giunti',packer_dat);

    if bytesuche_dat_puffer_0('MThd') then
      mthd;

    if bytesuche_dat_puffer_0('MTM') then
      multitracker(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('MsDos') then
      ausschrift(textz_Infektionsschutz_Jerusalem_Familie^+' "MsDos"',signatur);

    if bytesuche_dat_puffer_0('MDmd') then
      mdmd;

    if bytesuche_dat_puffer_0('MM'#0'*') then
      tiff(analyseoff,einzel_laenge,'');

    if bytesuche_dat_puffer_0('MM????'#$02) and (longint_z(@dat_puffer_zeiger^.d[2])^=einzel_laenge) then
      ausschrift('3D-Studio / AutoDesk Software',musik_bild);

    if bytesuche_dat_puffer_0('MSCF') then
      mscf(analyseoff,einzel_laenge);


  end;

procedure dat_4e;
  var
    coff_laenge,
    nb_ende             :dateigroessetyp;
  begin
    if bytesuche_dat_puffer_0('NDBA') then
      ndba;

    if bytesuche_dat_puffer_0('NEO!'#$00'???NEO') then
      if m_longint(dat_puffer_zeiger^.d[$4])+4+4=einzel_laenge then
        (* whale's voyage *.brs *)
        form;

    if bytesuche_dat_puffer_0(#$4e#$42) then
      nbasmc_lib;

    if bytesuche_dat_puffer_0(#$4e#$61#$bc#$00) then
      begin
        (* SElfinstallingArchivUtility *)
        ausschrift('SEAU / Gammadyne [?.?]',packer_dat);
        ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
      end;

    if bytesuche_dat_puffer_0(#$4e#$01'?'#$00) then
      begin
        coff(analyseoff,0,coff_laenge);
        if coff_laenge<>0 then
          einzel_laenge:=coff_laenge;
      end;


    if  bytesuche_dat_puffer_0('NE')
    and (word_z(@dat_puffer_zeiger^.d[$32])^<=32) (* Shift *)
    and (word_z(@dat_puffer_zeiger^.d[$0e])^<=100) (* Auto Data *)
     then
      begin
        x_exe_vorhanden:=true;
        x_exe_basis:=analyseoff;
        x_exe_ofs:=0;
        x_exe_untersuchung;
      end;

    if bytesuche_dat_puffer_0('NSK???'#$00) then
      with dat_puffer_zeiger^ do
        begin
          if  (longint_z(@d[3])^<=longint_z(@d[$c])^)
          and (1<longint_z(@d[3 ])^)
          and (  longint_z(@d[$c])^<800*1024*1024)
          and (d[$10]<100)
          and (d[d[$10]+$11]=0)
          and (d[d[$10]+$12] in [4,5,6]) (* Kompression .. PKWARE *)
           then nsk;

        end;

    if  bytesuche_dat_puffer_0('NFVP')
    and (dat_puffer_zeiger^.d[4] in [0,1])
     then
      nfvp(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Novell Me') then
      ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[0],#26,255),beschreibung);

    if bytesuche_dat_puffer_0('NetWare Loadable Module') then
      begin
        (* 'Novell 3.11' *)
        ausschrift('Novell Netware '+textz_Modul^+'',bibliothek);
        ansi_anzeige(analyseoff+$83,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
         absatz,wahr,wahr,analyseoff+dat_puffer_zeiger^.d[$82],'');
        dat_puffer_zeiger^.d[0]:=0;
      end;

    if bytesuche_dat_puffer_0('NB0')
    or bytesuche_dat_puffer_0('NB1')
     then
      if dat_puffer_zeiger^.d[3] in [ord('0')..ord('9')] then
        begin
          codeview(dat_puffer_zeiger^,0,anstrich);

          (* PAULATIM.EXE: ZIPSFX+Codeview(NB00)+Zip *)
          if  (longint_z(@dat_puffer_zeiger^.d[4])^<>0        ) (* bei NB10(PE) ist es 0 *)
          and (longint_z(@dat_puffer_zeiger^.d[4])^<>$ffffffff) (* NB02 (NE,Borland) *)
           then
            begin
              nb_ende:=longint_z(@dat_puffer_zeiger^.d[4])^;
              IncDGT(nb_ende,2+10*x_word__datei_lesen(analyseoff+nb_ende));

              if bytesuche__datei_lesen(analyseoff+nb_ende,'NB') then
                einzel_laenge:=nb_ende+8(* NB02 *)
              else (* NB04: PatchLdr *)
                if not bytesuche__datei_lesen(analyseoff+einzel_laenge-8,puffer_zu_zk_l(dat_puffer_zeiger^.d[0],4)) then
                  begin
                    nb_ende:=datei_pos_suche(analyseoff+8,analyseoff+einzel_laenge,puffer_zu_zk_l(dat_puffer_zeiger^.d[0],4));
                    if nb_ende<>nicht_gefunden then
                      if x_longint__datei_lesen(analyseoff+nb_ende+4)=nb_ende+8 then
                        einzel_laenge:=nb_ende+8;
                  end;
            end;

           if bytesuche(dat_puffer_zeiger^.d[0],'NB02'#$ff#$ff#$ff#$ff)
          (*if longint_z(@dat_puffer_zeiger^.d[4])^=$ffffffff*) then (* NB02 (NE,Borland) *)
            begin
              nb_ende:=datei_pos_suche(analyseoff+$10,analyseoff+einzel_laenge,puffer_zu_zk_l(dat_puffer_zeiger^.d[0],4));
              if (nb_ende<>nicht_gefunden) and (nb_ende+8-analyseoff=x_longint__datei_lesen(nb_ende+4)) then
                einzel_laenge:=nb_ende+8-analyseoff;
            end;

          if bytesuche(dat_puffer_zeiger^.d[$100-2],#$00#$00'DCA') then
            einzel_laenge:=$100;
        end;

    if bytesuche_dat_puffer_0(#$4E#$f5#$46#$e9) then
      shrinkit;

    if bytesuche_dat_puffer_0('NG') then
      begin
        ausschrift(textz_Hilfedatei^+' Norton Guide "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[8],#0,$28)+'"',bibliothek);
        ausschrift('"'+leer_filter(puffer_zu_zk_e(dat_puffer_zeiger^.d[$30],#0,$40))+'"',beschreibung);
      end;

    if bytesuche_dat_puffer_0('NI') then
      avp_archiv;

  end;

procedure dat_4f;
  begin
    if bytesuche_dat_puffer_0('OKTASONGCMOD'#$00) then
      oktasongmod(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Only in ')
    and puffer_gefunden(dat_puffer_zeiger^,': ') then
      begin
        diff(0,false);
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0('OFR ?'#$00#$00#$00) then
      optimfrog;

    if bytesuche_dat_puffer_0('OggS'#$00#$02#$00#$00) then
      ogg_vorbis;

    if bytesuche_dat_puffer_0('Ora ') then
      eli;

    if bytesuche_dat_puffer_0('OZ'#$dd#$12) then
      zet;

    if bytesuche_dat_puffer_0('Overlay for') then
      ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[0],#26,255),beschreibung);

    if bytesuche_dat_puffer_0('OPN:') then (* LODERUNNER / SIERRA *)
      ausschrift('Unchunk / Knowledge Dynamics ['+textz_dat__Anfang^+']',packer_dat);

  end;

procedure dat_50;
  var
    gruppe_o            :longint;
    gruppe              :string;
    l1                  :longint;
    x,y,c,unknown       :longint;
    w1                  :word_norm;

  function skip_whitespace:boolean;
    var
      search_newline:boolean;
    begin

      search_newline:=false;
      with dat_puffer_zeiger^ do
        repeat

          (* kein Ende gefunden *)
          if l1>=g then
            begin
              skip_whitespace:=false;
              Exit;
            end;

          if search_newline then
            case d[l1] of
              10:search_newline:=false;
            else
              Inc(l1);
              Continue;
            end;

          (* Kommentarzeile *)
          case d[l1] of
            Ord(' '),9,10,13:Inc(l1);
            Ord('#'):search_newline:=true;
          else
            skip_whitespace:=true;
            Break;
          end;

        until false;

    end;

  function read_decimal(var w:longint;const minw,maxw:longint):boolean;
    begin

      w:=0;
      read_decimal:=false;
      with dat_puffer_zeiger^ do
        repeat

          if l1>=g then
            Exit;

          case Chr(d[l1]) of
            '0'..'9':
              begin
                read_decimal:=true;
                w:=10*w+d[l1]-Ord('0');
                Inc(l1);
              end;
            '#',' ',#9,#10,#13:Break;
          else
            read_decimal:=false;
            Exit;
          end;

        until false;

      if (w<minw) or (w>maxw) then
        read_decimal:=false;

    end;

  begin
    if bytesuche_dat_puffer_0('PSA'#$01#$03) then
      psa(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('PSDT???'#$00) then
      acpi_dsdt(dat_puffer_zeiger^,'Persistent System Description Table');

    if bytesuche_dat_puffer_0('PG') then
      phoenix_bitmap;

    (* Soyo Extra-CD *)
    if bytesuche_dat_puffer_0('PORTSOFTHEADVBOB')
    or bytesuche_dat_puffer_0('PORTSOFTPBOBHEAD') then
      vbox;

    if bytesuche_dat_puffer_0('PIMPFILE'#$00)
    and bytesuche(dat_puffer_zeiger^.d[$113],#$00#$00) then
      nullsoft_pimp(dat_puffer_zeiger^);

    if  bytesuche_dat_puffer_0('PPU') then
      with dat_puffer_zeiger^ do
        if longint_z(@d[$10])^+$28=einzel_laenge then
          begin
            w1:=word_z(@d[6])^;
            exezk:=str0(w1 shr 14);
            if (w1 and $3fff)<>0 then
              begin
                exezk_anhaengen('.');
                exezk_anhaengen(str0((w1 shr 7) and $7f));
                if (w1 and $7f)<>0 then
                  begin
                    exezk_anhaengen('.');
                    exezk_anhaengen(str0(w1 and $7f));
                  end;
              end;
            ausschrift('FreePascal Unit '+in_doppelten_anfuerungszeichen(puffer_zu_zk_pstr(d[$2e]))+' ['+exezk+']',compiler);
          end;

    if bytesuche_dat_puffer_0('P12'#$0d#$0a' ???????? ')
    or bytesuche_dat_puffer_0('P5'#$0d#$0a' ???????? ')
    or bytesuche_dat_puffer_0('P6'#$0d#$0a' ???????? ')
    or bytesuche_dat_puffer_0('PAQ1'#$0d#$0a' ????????? ') then
      begin
        l1:=puffer_pos_suche(dat_puffer_zeiger^,#$0a,8)+1;
        if skip_whitespace then
          if read_decimal(x,1,99999999) then
            begin
              p12_p5_p6(dat_puffer_zeiger^);
              Exit; (* nicht nochmal pbm *)
            end;
      end;

    if bytesuche_dat_puffer_0('PSA???'#$00'FILES') then
      progressive_setup(dat_puffer_zeiger^,-1);

    if bytesuche_dat_puffer_0('P#R????-sqx-') then
      with dat_puffer_zeiger^ do
        if d[3] in [3..10] then (* 4 *)
          squez4(dat_puffer_zeiger^);


    if bytesuche_dat_puffer_0('PSID'#$00'?'#$00) then
      with dat_puffer_zeiger^ do
        if  (d[5] in [1,2])
        and (d[7] in [$76,$7c]) then
          begin
            ausschrift('SIDPlay ['+str0(d[5])+']',musik_bild);
            (* Name *)
            ausschrift_x(puffer_zu_zk_e(d[$16],#0,32),beschreibung,absatz);
            (* Autor *)
            ausschrift_x(puffer_zu_zk_e(d[$36],#0,32),beschreibung,absatz);
            (* Urheberrecht *)
            ausschrift_x(puffer_zu_zk_e(d[$56],#0,32),beschreibung,absatz);
          end;


    if bytesuche_dat_puffer_0('Packed by ??????Unpacked by AVP'#$ff) then
      with dat_puffer_zeiger^ do
        begin
          if bytesuche(d[$a],'VISE'#$ff#$ff) then
            vise_avp
          else
          if bytesuche(d[$a],'CHM'#$ff#$ff#$ff) then
            chp_avp
          else
            ausschrift(in_doppelten_anfuerungszeichen(puffer_zu_zk_l(d[0],32))+' ¯',packer_dat)

        end;

    if bytesuche_dat_puffer_0('P2P CHALKBOARD V') then
      begin (* Kreidetafel? *)
        ausschrift('Person to Person / IBM '
         +in_doppelten_anfuerungszeichen(puffer_zu_zk_e(dat_puffer_zeiger^.d[0],#0,80)),musik_bild);
        Exit; (* P2 Phar Lap.. *)
      end;

    if bytesuche_dat_puffer_0(#$50#$c3'?'#$00) then
      windows_clp;

    if bytesuche_dat_puffer_0('Packer (c) 1994 IH software.'#$0d#$0a#$1a) then
      packer_IH;

    if bytesuche_dat_puffer_0('Path: ') then
      begin
        exezk:=puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[0],255);
        if ((Pos('.',exezk)<>0) and (Pos('!',exezk)<>0))
        or (Pos('not-for-mail',exezk)<>0) then
          elm_oder_nntp(dat_puffer_zeiger^);
      end;

    if bytesuche_dat_puffer_0('Paint Shop Pro Image File'#$0a#$1a#$00#$00#$00) then
      with dat_puffer_zeiger^ do
        paint_shop_pro_image_file(dat_puffer_zeiger^); (* typ_die2 *)

    if bytesuche_dat_puffer_0('PDMP'#$00) then
      begin
        Ausschrift('OS/2 ProcDump',signatur);
        Ausschrift_x('PID='+str11_oder_hex(word_z(@dat_puffer_zeiger^.d[$3e])^)+' '+
          puffer_zu_zk_e(dat_puffer_zeiger^.d[$16b],#0,80),beschreibung,Absatz);
        Ausschrift_x(puffer_zu_zk_e(dat_puffer_zeiger^.d[$cc],#0,80),beschreibung,Absatz);
      end;

    if  bytesuche_dat_puffer_0('PT')
    and (dat_puffer_zeiger^.d[3] in [0,1])
    and (einzel_laenge<5000)
     then
       os2_ico(analyseoff,anstrich);

    if bytesuche_dat_puffer_0('PAR'#$00#$00#$00#$00) then
      with dat_puffer_zeiger^ do
        if  (dateigroessetyp_z(@d[$30])^>=0)  (* Archinummer 0=par 1=p01... *)
        and (dateigroessetyp_z(@d[$30])^<100000)
        and (dateigroessetyp_z(@d[$38])^>=1) (* Anzahl Dateien *)
        and (dateigroessetyp_z(@d[$38])^<100000)
        and (dateigroessetyp_z(@d[$40])^+dateigroessetyp_z(@d[$48])^=dateigroessetyp_z(@d[$50])^) then
          par1_Willem_Monsuwe(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('PAR2'#$00'PKT') then
      par2_Willem_Monsuwe;

    if  bytesuche_dat_puffer_0('PHILIPP'#0)
    and (longint_z(@dat_puffer_zeiger^.d[$10])^>=einzel_laenge)
     then
      par147(dat_puffer_zeiger^);

    if  bytesuche_dat_puffer_0('PAR'#0)
    and (longint_z(@dat_puffer_zeiger^.d[$0c])^>=einzel_laenge)
    and (not hersteller_gefunden) (* Konflikt zu PAR / Willem Monsuwe *)
     then
      par148(dat_puffer_zeiger^);


    if  bytesuche_dat_puffer_0('PIT2')
    and bytesuche(dat_puffer_zeiger^.d[$80],#0#0)
     then
      (* APM2V14.ZIP *)
      protectit2(dat_puffer_zeiger^);

    if  bytesuche_dat_puffer_0('PE'#$00#$00)
    and (word_z(@dat_puffer_zeiger^.d[4])^<1000) (* Anzahl obj *)
     then
      begin
        x_exe_basis:=analyseoff;
        x_exe_ofs:=0;
        x_exe_untersuchung;
      end;

    if bytesuche_dat_puffer_0('PSARC1.0') then
      psarc(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('PKS') and (dat_puffer_zeiger^.d[3] in [0..10]) then
      pksmart(dat_puffer_zeiger^);


    if bytesuche_dat_puffer_0('P   M   PRE,POST') then
      ausschrift('PNT / ???',signatur);
    if bytesuche_dat_puffer_0('PGI'#$09) then
      ausschrift('Graphics Vison '+textz_dat__Treiber^
       +' / Solar Designer "'+puffer_zu_zk_l(dat_puffer_zeiger^.d[4],20)+'"',bibliothek);

    if bytesuche_dat_puffer_0('Packed File') then
      pnpack(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('PACKIT by MJP'#$0d#$0a#$1a) then
      packit;

    if bytesuche_dat_puffer_0('PK'#$08#$08) then
      begin
        ausschrift(textz_Zeichensatz^+' BGI',bibliothek);
        bgi_text(dat_puffer_zeiger^);
      end;

    if bytesuche_dat_puffer_0('PK'#$09#$09)
    and not textdatei then
      pklite_unix(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('PPMZ')
    and (not textdatei) (* file_id.diz von PPMZ *)
     then
      ppmz(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('PMW1') then
      begin
        (* normal PMWLITE aber mit Overlay -> nicht 2*PMWLITE anzeigen *)
        x_exe_vorhanden:=true;
        x_exe_basis:=analyseoff;
        x_exe_ofs:=0;
        x_exe_untersuchung;
      end;

    if bytesuche_dat_puffer_0('PMCC') then
      begin
        exezk:=datei_lesen__zu_zk_e(analyseoff+word_z(@dat_puffer_zeiger^.d[$16])^,#0,255);
        exezk_in_doppelten_anfuerungszeichen;
        ausschrift(textz_Programmgruppe^+' Windows '+exezk,bibliothek);
      end;

    if bytesuche_dat_puffer_0('PMa')
    or bytesuche_dat_puffer_0('PEnd') then
      pit;

    if bytesuche_dat_puffer_0('PWAD') then
      ausschrift('PWAD-'+textz_Teilbibliothek^+' DOOM 2 / id-Sofware',bibliothek);

    if bytesuche_dat_puffer_0('PNCI') then
       begin
         if bytesuche(dat_puffer_zeiger^.d[4],#$00'????'#$5C) then
           ausschrift('Norton '+textz_Verzeichnisbaum^,bibliothek);
         if bytesuche(dat_puffer_zeiger^.d[4],'BHDMK') then
           ausschrift(textz_Hilfedatei^+' Norton Utils [Generell]',bibliothek);
         if bytesuche(dat_puffer_zeiger^.d[4],'CRYPT') then
           ausschrift('Norton Utils Diskreet '+textz_Verschluesselungsarchiv^+' / Symantec ',packer_dat);
         if bytesuche(dat_puffer_zeiger^.d[4],'UNDO') then
           ausschrift('Norton Utils Disk Doctor '+textz_UNDO_Datei^+' / Symantec ',bibliothek);
         if bytesuche(dat_puffer_zeiger^.d[4],'HIBK') then
           ausschrift('Image / Norton Utils',bibliothek);
         dat_puffer_zeiger^.d[511]:=0;
       end;


    if bytesuche_dat_puffer_0('PK') then
      with dat_puffer_zeiger^ do
        (* Eine Datei die mit 'PK01.LNG' anfÑngt, is kein ZIP... *)
        if (d[2] in [1..9]) and (d[2]+1=d[3]) then
          (* PKZIPSFX 1.1 *)
          zip(analyseoff,wahr,kein_art_prg_code);

    if bytesuche_dat_puffer_0('PK00PK') then
      zip(analyseoff+4,wahr,kein_art_prg_code);

    if bytesuche_dat_puffer_0('PCM') and (dat_puffer_zeiger^.d[$d] in [$e9,$eb]) then
      begin
        ausschrift('2Floppy+2Disk '+textz_dat__Kopf^+'/ PC Magazine',signatur);
        einzel_laenge:=$d;
      end;

    if bytesuche_dat_puffer_0('PCB') then
      begin
        (* PC-TOOLS *)
        ausschrift('Central Point Backup '+textz_Inhaltsverzeichniskopf^+' [9]',bibliothek);
        einzel_laenge:=$35;
      end;

    if bytesuche_dat_puffer_0('P') then
      with dat_puffer_zeiger^ do
        if Chr(d[1]) in ['1'..'7'] then
          begin
            l1:=2;
            case Chr(d[1]) of
              '1':
                if skip_whitespace then
                if read_decimal(x,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(y,1,High(longint)) then
                  bild_format_filter('Portable BitMap / Jef Poskanzer',x,y,-1,1,false,true,anstrich);

              '4':
                if skip_whitespace then
                if read_decimal(x,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(y,1,High(longint)) then
                  begin
                    bild_format_filter('Portable BitMap rawbits / Jef Poskanzer',x,y,-1,1,false,true,anstrich);
                    einzel_laenge:=l1+1+((x+7) shr 3)*y;
                  end;

              '2':
                if skip_whitespace then
                if read_decimal(x,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(y,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(c,1,255) then
                  begin
                    Inc(c);
                    bild_format_filter('Portable GrayMap / Jef Poskanzer',x,y,c,-1,false,true,anstrich);
                  end;

              '5':
                if skip_whitespace then
                if read_decimal(x,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(y,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(c,1,255) then
                  begin
                    Inc(c);
                    bild_format_filter('Portable GrayMap rawbits / Jef Poskanzer',x,y,c,-1,false,true,anstrich);
                    einzel_laenge:=l1+1+x*y;
                  end;

              '3':
                if skip_whitespace then
                if read_decimal(x,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(y,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(c,1,255) then
                  begin
                    Inc(c);
                    bild_format_filter('Portable PixMap / Jef Poskanzer',x,y,c*c*c,-1,false,true,anstrich);
                  end;

              '6':
                if skip_whitespace then
                if read_decimal(x,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(y,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(c,1,255) then
                  begin
                    Inc(c);
                    bild_format_filter('Portable PixMap rawbits / Jef Poskanzer',x,y,c*c*c,-1,false,true,anstrich);
                    einzel_laenge:=l1+1+x*y*3;
                  end;
              '7':
                (* 'P7 332' 3+3+2=8=Verteilung Farbbit?         *)
                (* '#IMGINFO:640x480 Indexed (309108 bytes)'    *)
                (* '#END_OF_COMMENTS'                           *)
                if skip_whitespace then
                if read_decimal(unknown,1,High(longint)) then
                if skip_whitespace then
                (* 80 60 255 *)
                if read_decimal(x,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(y,1,High(longint)) then
                if skip_whitespace then
                if read_decimal(c,1,High(longint)) then
                  begin
                    if c=High(longint) then
                      bild_format_filter('Portable ANYMAP?? rawbits / Jef Poskanzer',x,y, -1,32,false,true,anstrich)
                    else
                      bild_format_filter('Portable ANYMAP?? rawbits / Jef Poskanzer',x,y,c+1,-1,false,true,anstrich);

                   c:=0;
                   while unknown>0 do
                     begin
                       c:=c+unknown mod 10;
                       unknown:=unknown div 10;
                     end;
                   if (c and 7)=0 then
                     c:=(c shr 3)
                   else
                     c:=(c shr 3)+1;
                   einzel_laenge:=l1+1+x*y*c;
                  end;

            end;

        end;



    if (bytesuche_dat_puffer_0('P2') or bytesuche_dat_puffer_0('P3'))
    and (not hersteller_gefunden)
    and (not textdatei) then
      begin
        exezk:='Phar Lap .EXP '+textz_dat__Datei^;
        case chr(dat_puffer_zeiger^.d[1]) of
         '2':exezk_anhaengen(' (286+)');
         '3':exezk_anhaengen(' (386+)');
        end;
        case word_z(@dat_puffer_zeiger^.d[2])^ of
         1:exezk_anhaengen(' (flat model)');
         2:exezk_anhaengen(' (multisegmented)');
        else
          exezk_anhaengen(' (???)');
        end;
        ausschrift(exezk,dos_win_extender);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[6])^;
      end;

    if bytesuche_dat_puffer_0('PICT'#0) then
      bild_format_filter('ADEX',
                         word_z(@dat_puffer_zeiger^.d[6])^,
                         word_z(@dat_puffer_zeiger^.d[8])^,
                         -1,dat_puffer_zeiger^.d[5],false,false,anstrich);

  end;

procedure dat_51;
  begin
    if bytesuche_dat_puffer_0('QP?'#$00'??'#$00#$00)
    and (longint(word_z(@dat_puffer_zeiger^.d[2])^)*16=longint_z(@dat_puffer_zeiger^.d[4])^)
     then
      qip(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('QRST') and (dat_puffer_zeiger^.d[$7d]=$0a) then
      quick_release_sector_transfer;

  end;

procedure dat_52;
  var
    dunzip_dll_position :dateigroessetyp;
    w1                  :word_norm;
  begin
    if bytesuche_dat_puffer_0('ROS'#$00#$00) then
      ros_bin_archiv;

    if bytesuche_dat_puffer_0('RSDT???'#$00) then
      acpi_dsdt(dat_puffer_zeiger^,'ACPI Root System Description Table');

    with dat_puffer_zeiger^ do
      if (bytesuche_dat_puffer_0('RDOFF????'#$00) and (d[5] in [Ord('1')..Ord('9')]))
      or (bytesuche_dat_puffer_0('RDOFF?#$00'   ) and (d[5] in [   $01  ..   $09  ])) then
      rdoff(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('RKA') then
      if longint_z(@dat_puffer_zeiger^.d[$10])^=einzel_laenge then
        rkau(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('RsDl') then
      begin
        w1:=puffer_pos_suche(dat_puffer_zeiger^,'PK'#$03#$04,500);
        if w1<>nicht_gefunden then
          begin
            einzel_laenge:=w1;
            ausschrift('WinImage / Gilles Vollant',signatur); (* 4.0 *)
            exezk:=puffer_zu_zk_l(dat_puffer_zeiger^.d[4],w1-4-4);
            zeichenfilter(exezk);
            exezk_in_doppelten_anfuerungszeichen;
            ausschrift(exezk,beschreibung); (* /FLOP /F *)
          end;
      end;

    if bytesuche_dat_puffer_0('Received:') then
      elm_oder_nntp(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Return-Path:') then (* packet driver archiv: SNMP.NOT *)
      elm_oder_nntp(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('RSJ CDWFS TRACK FILE'#0) then
      begin
        ausschrift('CDWFS / RSJ Software GmbH',packer_dat);
        einzel_laenge:=Max($28,longint_z(@dat_puffer_zeiger^.d[$24])^);
      end;

    if bytesuche_dat_puffer_0('REGEDIT4'#$0d#$0a)
    or bytesuche_dat_puffer_0('REGEDIT4 '#$0d#$0a) then
      ausschrift('Regedit [Windows], RegEdit/2 [OS/2]  '+textz_textini_profildatei^,signatur);

    if bytesuche_dat_puffer_0('RE~^') then
      rar140;

    (* AOL SETUP.EXE *)
    (* Informationen Åber nachfolgene DUNZIP.DLL und ~~70 *.ZIP *)
    if (   bytesuche_dat_puffer_0('RS?'#$00'C:\')
        or bytesuche_dat_puffer_0('RS?'#$00'c:\'))
    and (dat_puffer_zeiger^.d[2] in [3..40]) (* PfadlÑnge *)
     then
      begin
        ausschrift('RS?? / AOL ',signatur);
        dunzip_dll_position:=datei_pos_suche(analyseoff,analyseoff+20000,'MZ????'#$00#$00);
        if dunzip_dll_position<>nicht_gefunden then
          einzel_laenge:=dunzip_dll_position-analyseoff;
      end;

    if bytesuche_dat_puffer_0('RNC') and (not exe ) then
      rnc;

    if bytesuche_dat_puffer_0('Rar!'#26) then
      rar(analyseoff);

    if bytesuche_dat_puffer_0('RIFF') then
      if not textdatei then
        riff;

    if bytesuche_dat_puffer_0('RIFX') then
      rifx(dat_puffer_zeiger^);


    if bytesuche_dat_puffer_0('RR'#1')') then
      (* ausschrift('unbekanntes Archiv <LIF/SPEA>',packer_dat); *)
      knowledge;

    if bytesuche_dat_puffer_0('RLPD') then
      if dat_puffer_zeiger^.d[4]=4 then
        begin
          ausschrift('DESCENT / PARALLAX [SW 1]',spielstand);
          for w1:=1 to 10 do
            begin
              exezk:=datei_lesen__zu_zk_e(analyseoff+(w1-1)*174+$14,#0,27);
              if exezk<>'' then
                ausschrift(str0(w1)+' : '+exezk,spielstand);
            end;
        end
      else
        if einzel_laenge=522 then
          ausschrift('DESCENT / PARALLAX [REG 1] '+textz_Spielstandverzeichnis^,spielstand)
        else
          ausschrift('DESCENT / PARALLAX [2] '+textz_Spielstandverzeichnis^,spielstand);

    if bytesuche_dat_puffer_0('RIX3') then
      ausschrift('ColoRIX '+str0(word_z(@dat_puffer_zeiger^.d[4])^)+' * '
                           +str0(word_z(@dat_puffer_zeiger^.d[6])^),musik_bild);

     if bytesuche_dat_puffer_0('R'#$cc#$00#$00) then
       with dat_puffer_zeiger^ do
         bild_format_filter('Utah RLE',
                               word_z(@d[6])^,
                               word_z(@d[8])^,
                               -1,Max(d[11],1)*Max(d[12],1),false,true,anstrich)
       (*
       ausschrift('Utah RLE '+str0(word_z(@dat_puffer_zeiger^.d[6])^)+' * '
                             +str0(word_z(@dat_puffer_zeiger^.d[8])^),musik_bild);*)

  end;

procedure dat_53;
  var
    o,o1                :dateigroessetyp;

  begin
    if bytesuche_dat_puffer_0('SXINST-HEADER') then
      dbsoft_header(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('SXINST-ZIP') then
      dbsoft_ace(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('SSDT???'#$00) then
      acpi_dsdt(dat_puffer_zeiger^,'Secondary System Description Table');

    if bytesuche_dat_puffer_0('SBST???'#$00) then
      acpi_dsdt(dat_puffer_zeiger^,'ACPI Smart Battery Description Table');

    if bytesuche_dat_puffer_0('SPCR???'#$00) then
      acpi_dsdt(dat_puffer_zeiger^,'ACPI Serial Port Console Redirection Table');

    if bytesuche_dat_puffer_0('STRPACK-') then
      ausschrift('String Resource [Phoenix BIOS]',bibliothek);

    (* Sicherung einer DB in einer Datei, 7.1 *)
    if bytesuche_dat_puffer_0('SQLUBRMEDHEAD?'#$00#$00) then
      ausschrift('IBM DB2 Universal Database '
        +in_doppelten_anfuerungszeichen(puffer_zu_zk_e(dat_puffer_zeiger^.d[$10],#0,255)),bibliothek);

    if bytesuche_dat_puffer_0('SIMPLE  = ') then
      FlexibleImageTransportSystem;

    if bytesuche_dat_puffer_0('Sfff?'#$00#$00#$00) then
      with dat_puffer_zeiger^ do
        bild_format_filter('Structured Fax File',
                             word_z(@d[$1a])^,
                             word_z(@d[$1c])^,
                             -1,-1,false,true,anstrich);

    if bytesuche_dat_puffer_0('S0030000FC') then
      ausschrift('Motorola S-Record',compiler);

    if bytesuche_dat_puffer_0(#$53#$80#$f6#$34) then
      softimage_pic(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('SETUP.EXE'#$00)
    and bytesuche__datei_lesen(analyseoff+$10c,'MZ') then
      gkware_selfextractor_tmp;

    if bytesuche_dat_puffer_0('SG09'#$00#$00)
    and bytesuche(dat_puffer_zeiger^.d[$30],'Scripts compiled ??? ??? ') then
      begin
        ausschrift('Monkey Island 3 "The Curse of Monkey Island" / LucasArts',spielstand);
        ausschrift_x(puffer_zu_zk_e(dat_puffer_zeiger^.d[8],#0,$28),beschreibung,absatz);
      end;

    if bytesuche_dat_puffer_0('SCRIPT'#$00#$00#$00) then
      if (longint_z(@dat_puffer_zeiger^.d[$0e])^ mod $12)=0 then
        if (longint_z(@dat_puffer_zeiger^.d[$0e])^>0) then
          animated_system_design;

    if bytesuche_dat_puffer_0('Stash 1.0'#$00#$00#$00) and (einzel_laenge>$26c) then
      ausschrift('IconEase / Dave Lester [2.0]',musik_bild);

    if bytesuche_dat_puffer_0('StartFontMetrics') then (* .afm *)
      begin
        Ausschrift('Adobe Font Metrics',musik_bild);
        o:=0;
        repeat
          o1:=datei_pos_suche_zeilenanfang(o,analyseoff+1000,'Comment ');
          if o1=nicht_gefunden then Break;
          o:=o1+Length('Comment ');
          exezk:=datei_lesen__zu_zk_zeilenende(o);
          IncDGT(o,Length(exezk));
          Ausschrift_x(exezk,beschreibung,absatz);
        until false;

        if o=0 then
          begin
            o:=datei_pos_suche_zeilenanfang(analyseoff,analyseoff+1000,'FullName ');
            if o<>nicht_gefunden then
              Ausschrift_x(datei_lesen__zu_zk_zeilenende(o+Length('FullName ')),beschreibung,absatz);
          end;
      end; (* .afm *)

    if bytesuche_dat_puffer_0('SBC') then
      versuche_sbc(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('SCSO') and (analyseoff>0) then
      (* "PE"-Packer ... *)
      ausschrift('SecuPack / SC-SOFT 2000 [1.5]',packer_exe);

    if bytesuche_dat_puffer_0('SVCT'#$00#$00(* #$00#$01 *)) then
      svct; (* TYP APPL/VIS3 *)

    if  bytesuche_dat_puffer_0('SEM')
    and (einzel_laenge=longint_z(@dat_puffer_zeiger^.d[$12])^+$2b)
     then
      semone(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('SFXSTART') then
      sextwiz;

    if bytesuche_dat_puffer_0('SB1'#00) then
      sbx;

    if bytesuche_dat_puffer_0('SZ'#$0a#$04) then
      szip(dat_puffer_zeiger^);

    (* SADT2.ZIP *)
    if  bytesuche_dat_puffer_0('SAdT')
    and (dat_puffer_zeiger^.d[4]<=16)
     then
      ausschrift('Surprise! Adlib Tracker / Erik Pojar',musik_bild);


    if bytesuche_dat_puffer_0('SPU') then
      if dat_puffer_zeiger^.d[3] in [ord('1')..ord('9')] then
        ausschrift('Speed Soft Pascal Unit "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[0],#0,10)+'"',compiler);

    if bytesuche_dat_puffer_0('Sonarc-squeezed ') then
      ausschrift('Sonarc / Speech Compression "'+puffer_zu_zk_l(dat_puffer_zeiger^.d[16],3)+'"',packer_dat);

    if bytesuche_dat_puffer_0('SXD') then (* DOS/1.04 *)
      with dat_puffer_zeiger^ do
        begin
          ausschrift('Self-extracting image processor (CopyQM?) / Sydex',packer_dat);
          ausschrift_x(str0(d[5])+'/'+str0(d[6])+'/'+str0(d[8])+'('+str0(d[7])+') => '+str0(d[5]*d[6]*d[7] div 2)
            +' KiB',normal,absatz);
          o:=analyseoff+$21;
          o1:=o+word_z(@d[$13])^;
          while o<o1 do
            begin
              exezk:=datei_lesen__zu_zk_e(o,#0,DGT_zu_longint(o1-o));
              ausschrift_x(exezk,beschreibung,absatz);
              IncDGT(o,Length(exezk)+1);
            end;
          if analyseoff>0 then
            begin
              befehl_schnitt(analyseoff,einzel_laenge,erzeuge_neuen_dateinamen('.SXD'));
              befehl_sonst('call unp_sxd '+erzeuge_neuen_dateinamen('.SXD'));
            end;
        end;

    if bytesuche_dat_puffer_0('SB?????Ant') then
      begin
        ausschrift(textz_Kopie_Partitionstabelle_startsektor^+' / Eugene Kaspersky',bibliothek);
        einzel_laenge:=$144;
      end;

    if bytesuche_dat_puffer_0('SZDD') then
      (* 'SZDDà'3' *)
      begin

        if analyseoff>0 then
          begin (* WordPerfect Envoy [1.0] *)
            o:=Datei_pos_Suche(analyseoff+1,analyseoff+MinDGT(einzel_laenge,
                (longint_z(@dat_puffer_zeiger^.d[$a])^*9 div 8)),'SZDD');
            if o=nicht_gefunden then
              begin
                (* LSPSFX20.EXE *)
                o:=Datei_pos_Suche(analyseoff+1,analyseoff+MinDGT(einzel_laenge,
                    (longint_z(@dat_puffer_zeiger^.d[$a])^*9 div 8)),'FL'#$03#$04);
              end;
            if o<>nicht_gefunden then
              einzel_laenge:=o-analyseoff;
          end;

        compress_ms(dat_puffer_zeiger^,analyseoff,einzel_laenge,'');
      end;

    if bytesuche_dat_puffer_0('STACKER  ve') then
      ausschrift('Stacker '+textz_dat__Datentraeger^+' / Stac Electronics',signatur);

    if bytesuche_dat_puffer_0('SQWEZ v') then
      sqwez;

    if bytesuche_dat_puffer_0('SpidyGfx') then
      begin
        ausschrift('SpidyGfx Grafik [Reunion]',musik_bild);
        dat_puffer_zeiger^.d[0]:=0;
      end;

    if bytesuche_dat_puffer_0('SCB1.') then
      begin
        exezk:=datei_lesen__zu_zk_e(analyseoff+$1f1,#0,$30);
        exezk_in_doppelten_anfuerungszeichen;
        ausschrift('Strike Commander / ORIGIN '+exezk,spielstand);
      end;

    if bytesuche_dat_puffer_0('SAVE????VARS??by') then
      ausschrift('Day of the Tentacle (Maniac Mansion 2) / Lucas Arts',spielstand);

    if bytesuche_dat_puffer_0('SMK') then
      ausschrift('Smacker / RAD Software '
        +str0(longint_z(@dat_puffer_zeiger^.d[ 4])^)+' * '
        +str0(longint_z(@dat_puffer_zeiger^.d[ 8])^)+' '
        +str0(longint_z(@dat_puffer_zeiger^.d[12])^)+' Bilder',musik_bild);

    if bytesuche_dat_puffer_0('SCMI ') then
      ausschrift('Img Soft Set '+puffer_zu_zk_l(dat_puffer_zeiger^.d[$12],8),musik_bild);

    if bytesuche_dat_puffer_0('SWG2') then
      begin
        if (dat_puffer_zeiger^.d[6] and bit03)=bit03 then
          exezk:=textz_dat__eckauf_verschluesselt_eckzu^
        else
          exezk:='';

        ausschrift('Star Writer 2.0 / Star Division '+exezk,musik_bild);
        ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[$63],#0,70),beschreibung);
        if (dat_puffer_zeiger^.d[$153]<>0) then
          ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[$153],#0,512-$153-2),beschreibung);
      end;

    if bytesuche_dat_puffer_0('SChF') then
      charc;

    if bytesuche_dat_puffer_0('SDX:') then (* CONVERT *)
      ausschrift('Sample DUMP Exchange File "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[4],#$1a,80)+'"',musik_bild);


    if not textdatei then
      begin
        if bytesuche_dat_puffer_0('SIT!')
        or bytesuche_dat_puffer_0('ST50') then
          stuffit(m_longint(dat_puffer_zeiger^.d[6]));

        if bytesuche_dat_puffer_0('StuffIt (c)1997-???? Aladdin Systems, Inc., '
             +'http://www.aladdinsys.com/StuffIt/'+#$0d#$0a#$1a#$00) then
          stuffit_510(dat_puffer_zeiger^);
      end;


  end;

procedure dat_54;
  var
    f1:dateigroessetyp;
  begin
    if bytesuche_dat_puffer_0('TNOF'#$00#$00#$00#$00) then
      if ModDGT(einzel_laenge,256)=4 then
        if  (DivDGT(einzel_laenge,256)>= 8)
        and (DivDGT(einzel_laenge,256)<=32) then
          amibios_font;

    if bytesuche_dat_puffer_0('TDS'#$0d#$0a) then
      if einzel_laenge<1000 then
        begin (* Installationsprogramm zu OMF *)
          ausschrift('TDS? / EPIC Megagames',packer_dat);
          ansi_anzeige(analyseoff,#12,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
          ,absatz,wahr,wahr,analyseoff+einzel_laenge,'')
        end;

    if bytesuche_dat_puffer_0('This is a binary data file. Keep out !'#$1a#$00) then
      gkware_bin_tiefe3;

    (* BP 7.01 -- vp 2.1 olf nachbessern *)
    (* BP.*    '$*#$$*#$*' *)
    (* TURBO.* '$*#$$#*$*' *)
    if bytesuche_dat_puffer_0('Turbo Pascal Desktop File'#$1a#$00'$*#$$??$*?FBPR') then
      begin
        zwischzeile:=false; (* ->FBPR *)
        einzel_laenge:=$25;
      end;

    if bytesuche_dat_puffer_0('Turbo Pascal Configuration File'#$1a#$00'$*#$$??$*?FBPR') then
      begin
        zwischzeile:=false; (* ->FBPR *)
        einzel_laenge:=$2b;
      end;

    if bytesuche_dat_puffer_0('To ')
    or bytesuche_dat_puffer_0('To: ') then
      elm_oder_nntp(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('TRAVADO') then
      (* hei·t TRAVADO vielleicht Schutz? *)
      ausschrift('Trava / Fabio Becker ["detrava '+Chr(dat_puffer_zeiger^.d[7])+'"]',packer_dat);

    if bytesuche_dat_puffer_0('TGCF'#$00) then
      tgcf;

    if bytesuche_dat_puffer_0('TPWM???'#$00) then
      tpwm(dat_puffer_zeiger^);

    if  bytesuche_dat_puffer_0('TAG')
    and (einzel_laenge=128)
     then
      mp3_tag;

    (* Zeiger auf Anfang des Archivkopfes *)
    if  (   bytesuche_dat_puffer_0('TSI')
         or bytesuche_dat_puffer_0('TSW'))
    and (dat_puffer_zeiger^.d[3] in [ord('0')..ord('9')])
    and (longint_z(@dat_puffer_zeiger^.d[4])^<analyseoff)
     then
      begin
        ausschrift('?? TimeSink Install',packer_dat);
        einzel_laenge:=8;
      end;

    if bytesuche_dat_puffer_0('TDF'#$00) then
      ausschrift('Trace Definition File / IBM ['+puffer_zu_zk_e(dat_puffer_zeiger^.d[$1e],#0,255)+']',compiler);

    if bytesuche_dat_puffer_0('TFF'#$00) then
      ausschrift('Trace Formating File / IBM',compiler);

    if bytesuche_dat_puffer_0('Thunderbyte ') then
      begin
        if bytesuche(dat_puffer_zeiger^.d[$c],'che') then
          begin
            ausschrift('Thunderbyte AV '+textz_Pruefsummen^,signatur);
            dat_puffer_zeiger^.d[0]:=0;
          end;
      end;

    if bytesuche_dat_puffer_0('TbUtil.Dat ') then
      tbutil_dat(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('TypeT') then
      ausschrift('RTDEMO2 / Software Garden  '+textz_Lernprogramm_Daten^,musik_bild);

    if bytesuche_dat_puffer_0('TPU') then
      tpu_system(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('TD'#$00) then
      teledisk(word_z(@dat_puffer_zeiger^.d[$e])^);

    if bytesuche_dat_puffer_0('This file contains Exact i') then
      ausschrift('Thunderbyte AV ECI'+version_x_y(dat_puffer_zeiger^.d[$103],dat_puffer_zeiger^.d[$102]),bibliothek);

  end;

procedure dat_55;
  var
    l1,l2:longint;
  begin
    if bytesuche_dat_puffer_0('UHA') then
      uharc(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('UpSh??'#$00#$00) then
      begin
        ausschrift('UpShot / Autumn Hill Software',bibliothek);
        ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(dat_puffer_zeiger^.d[$10],#0,$28)),beschreibung,absatz);
      end;

    if bytesuche_dat_puffer_0('UHI?????'#$00'???'#$00) then
      with dat_puffer_zeiger^ do
        begin
          case d[4] of
            5:exezk:='.RAS';
            6:exezk:='.TGA';
          else
            (* 2 *)
              exezk:='.BMP';
          end;
          ausschrift('UIHC / Uwe Herklotz'+version_div16_mod16(d[3]),packer_dat);
          bild_format_filter('*'+exezk,
                         word_z(@d[$1d])^,
                         word_z(@d[$1f])^,
                         -1,24,false,true,anstrich);
        end;

    if bytesuche_dat_puffer_0('UB') then
      begin
        l1:=longint_z(@dat_puffer_zeiger^.d[$7])^;
        l2:=longint_z(@dat_puffer_zeiger^.d[$b])^;
        if (l1>=0) and (l2>=0) and (l1<=l2) and (l2<512*1024*1024) then
          hit;
      end;

    if bytesuche_dat_puffer_0('ULEB') then
      rax;

    if bytesuche_dat_puffer_0('UHA'#$02) then
      uha2;

    if bytesuche_dat_puffer_0('UniPatchVolume') then
      unipatchvolume(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('UPD') then
      chlib(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('UHS'#$0d) then
      begin
        if dat_puffer_zeiger^.d[4]=$0a then
          exezk:='Ú 91a'
        else
          exezk:='Û 88a';

        ausschrift('Universal Hint System Compiler / Jason Strautman ['+exezk+']',musik_bild);
      end;

    if bytesuche_dat_puffer_0('USS2.0') then
      begin
        exezk:=puffer_zu_zk_l(dat_puffer_zeiger^.d[$9c],40);
        while (length(exezk)>0) and (exezk[length(exezk)]=' ') do
          dec(exezk[0]);
        ausschrift('Ultimate Solution System / Christian Lupp "'+exezk+'"',musik_bild);
      end;

    if bytesuche_dat_puffer_0('UFA'#$c6) then
      ufa(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$55#$AA) then
      if dat_puffer_zeiger^.d[2] in [$01..$80] then (* 512..64KB *)
        rom_modul(dat_puffer_zeiger^,analyseoff,'',einzel_laenge);

  end;

procedure dat_56;
  var
    w1:word_norm;
  begin

    if bytesuche_dat_puffer_0('VSN?000'#$00) then
      with dat_puffer_zeiger^ do
        begin (* LIBERTY.EXE *)
          (* Visual Smalltalk 3.0.1 *)
          ausschrift(puffer_zu_zk_e(d[$10],#0,80),compiler);
        end;

    if bytesuche_dat_puffer_0('VOL?000??'#$00#$00#$00) then
      with dat_puffer_zeiger^ do
        begin
          (* $8/"3.0.1.84"/$1d/"Visual Smalltalk Base Library" *)
          w1:=$c;
          exezk:=puffer_zu_zk_l(d[w1+4],d[w1]);
          Inc(w1,4+d[w1]);
          ausschrift(puffer_zu_zk_l(d[w1+4],d[w1])+' '+exezk,compiler);
        end;


                           (* 'VRX   OS/2 v2.14'#$1a *)
    if bytesuche_dat_puffer_0('VRX   ???? v?.??'#$1a) then
      if x_longint__datei_lesen(analyseoff+einzel_laenge-4)=$000de2c5 then
        begin
          vxrexx;
          exit;
        end
      else
        ausschrift('VX-Rexx / Watcom "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[6],#$1a,10+5)+'"',bibliothek);

    if bytesuche_dat_puffer_0('VPI') then
      vpi_system(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('V??_LIB') then
      begin
        case dat_puffer_zeiger^.d[$8] of
          2:exezk:='8.0 d';
          5:exezk:='9.0 d';
         $1e:exezk:='8.0 e';
        else
          exezk:='?.?';
        end;
        ausschrift(textz_Laufzeit_Link_Bibliothek^+' PC-Tools '+exezk+' / Central Point',bibliothek);
      end;


    if bytesuche_dat_puffer_0('VKTyFa') then
      begin
        for b1:=0 to dat_puffer_zeiger^.d[6] do exezk[b1]:=chr(dat_puffer_zeiger^.d[6+b1]);
        ausschrift(textz_Farbtabelle_anf^+exezk+textz_anf_fuer_mich^,bibliothek);
      end;

    if bytesuche_dat_puffer_0('VI1') then
      ausschrift('Jovian VI  '+str0(word_z(@dat_puffer_zeiger^.d[3])^)+' * '
                              +str0(word_z(@dat_puffer_zeiger^.d[5])^),musik_bild);
  end;

procedure dat_57;
  var
    l1:longint;
  begin

    if bytesuche_dat_puffer_0('WithoutFreeSpace?'#$00#$00#$00) then
      with dat_puffer_zeiger^ do
        begin
          ausschrift('SVISTA/2OS2 '+textz_dat__packed_hard_disk_image^,packer_dat);
          ausschrift_x(textz_dien__Zylinder__^ +str0(x_longint(d[$18]))
                      +textz_dien____Heads__^  +str0(x_longint(d[$14]))
                      +textz_dien____Sectors__^+str0(x_longint(d[$1c])),beschreibung,absatz);
        end;

    (* imgcpy10a.zip *)
    if bytesuche_dat_puffer_0('WENDY - DDT ') then
      begin
        ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[0],#0,$20)+' / Wendy Krieger',beschreibung);
        l1:=512;
        while l1<einzel_laenge do
          begin
            (* Startsektoren fÅr verschiedene DOS-Versionen *)
            merke_position(analyseoff+l1,datentyp_unbekannt);
            Inc(l1,512);
          end;
        einzel_laenge:=512;
      end;

    if bytesuche_dat_puffer_0('WFSE') and (longint_z(@dat_puffer_zeiger^.d[4])^<=einzel_laenge) then
      begin
        ausschrift('Wdosx File System Extensions',bibliothek);
        ausschrift(puffer_zu_zk_e(dat_puffer_zeiger^.d[$10],#0,255),beschreibung);
        einzel_laenge:=longint_z(@dat_puffer_zeiger^.d[4])^;
      end;

    if bytesuche_dat_puffer_0('WordPro'#$00#$00) then
      ausschrift('Lotus WordPro "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[$10],#0,16)+'"',musik_bild);


    if (bytesuche_dat_puffer_0('WB') or bytesuche_dat_puffer_0('WA')) then
    (* WB=binÑre Lizenz? - IBM... *)
      with dat_puffer_zeiger^ do
        if (word_z(@d[4])^>=1) and (word_z(@d[4])^<=100)
        and (word_z(@d[2])^<512) then
          begin
            ausschrift('Self-extracting image processor (CopyQM?) / Sydex ['+'Text'+']',packer_dat);
            einzel_laenge:=word_z(@d[4])^*512;
            if word_z(@d[2])^<>0 then
              IncDGT(einzel_laenge,word_z(@d[2])^-512);
          end;

    if bytesuche_dat_puffer_0('WRF') then
      (* DOOM2, GALACTIX *)
      ausschrift('Setup '+textz_dat__Daten_leerzeichen^+'Cygnus Studios',bibliothek);

    if bytesuche_dat_puffer_0('WPSbkup ?.??'#$00) then
      wps_backup(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('WWP') then
      wwp_dat(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('WATCOM patch l') then
      watcom_patch_level(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('WICA') then
      wic;
  end;

procedure dat_58;
  begin
    if bytesuche_dat_puffer_0('XFIR') then (* Macromedia director *)
      rifx_intel(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('XPCOM'#$0a) then
      begin
        exezk:=puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[$6],20);
        if exezk='MozFASL' then
          exezk:='Fastload resource'
        else
          exezk:=in_doppelten_anfuerungszeichen(exezk);
        ausschrift('Mozilla '+exezk,bibliothek);
      end;
    if bytesuche_dat_puffer_0('X-Mozilla-Status2: ') then
      elm_oder_nntp(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('Xref: ')
    or bytesuche_dat_puffer_0('XREF: ') then
      elm_oder_nntp(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('XE') and (dat_puffer_zeiger^.d[2] in [0..20]) then
      xpack_le(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('X1') then
      x1_s_valantini(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0('XMF_') then
      begin
        ausschrift('HugeRealMode '+textz_dat__ausfuehrbare_Datei^+' / ??? ¯',signatur);
        einzel_laenge:=word_z(@dat_puffer_zeiger^.d[4])^;
      end;

    if bytesuche_dat_puffer_0('XL'#$02#$82)
    or bytesuche_dat_puffer_0('XL'#$00#$83)
    or bytesuche_dat_puffer_0('XL'#$08#$82) (* TERRATEC.EXE *)
     then
      xlink(dat_puffer_zeiger^);

  end;

procedure dat_59;
  begin
    if bytesuche_dat_puffer_0('YBS') then
      ybs;

    if bytesuche_dat_puffer_0(#$59#$56#$05#$06) then
      cfos;

    if bytesuche_dat_puffer_0(#$59#$a6#$6a#$95) then
      bild_format_filter('Sun Raster',
                         m_longint(dat_puffer_zeiger^.d[4]),
                         m_longint(dat_puffer_zeiger^.d[8]),
                         -1,dat_puffer_zeiger^.d[15],false,true,anstrich);
  end;

procedure dat_5a;
  begin
    if bytesuche_dat_puffer_0('ZPK'#$00#$01#$00) then
      ausschrift('Ebook Pack / Caislabs',packer_dat);

    if bytesuche_dat_puffer_0(#$5a#$00#$34#$d3) then (* codepage 395..*)
      ausschrift('IBM Advanced Function Print',musik_bild); (* auch *.list3820 *)

    if bytesuche_dat_puffer_0('ZZ') and (longint_z(@dat_puffer_zeiger^.d[$f])^+$f+4=einzel_laenge) then
      zzip(dat_puffer_zeiger^)
    else
    if bytesuche_dat_puffer_0('ZZ???'#$00#$00'?'#$00#$00#$00) then
      zzip_36b(dat_puffer_zeiger^);


    if bytesuche_dat_puffer_0('ZOO ') then
      begin
        zoo;
        dat_puffer_zeiger^.d[0]:=0;
      end;
  end;

procedure dat_5b;
  var
    f1                  :dateigroessetyp;
    w1                  :word_norm;
  begin

    if bytesuche_dat_puffer_0('[ver]'#$0d#$0a#$09'?'#$0d#$0a'[sty]'#$0d#$0a#$09#$0d#$0a'[charset]'#$0d#$0a) then
      begin (* 4 *)
        ausschrift('Lotus Ami Pro ['+puffer_zu_zk_zeilenende(dat_puffer_zeiger^.d[8],1)+']',musik_bild);
        Exit;
      end;


    if bytesuche_dat_puffer_0('[NWUPD]'#$00) then
      begin
        ausschrift('NoteWorthy Upgrade',packer_dat);
        ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(dat_puffer_zeiger^.d[$b],#0,255)),beschreibung,absatz);
      end;

    (* KurtZimmermann: wincheck.exe *)
    if bytesuche_dat_puffer_0('[FE]'#$0a) then
      begin
        ausschrift('FreeExtractor',packer_dat); (* 1.44 http://www.disoriented.com/ *)
        f1:=datei_pos_suche(analyseoff,analyseoff+MinDGT(1000,einzel_laenge),'PK'#$03#$04);
        if f1<>nicht_gefunden then
          begin
            einzel_laenge:=f1-analyseoff;
            ansi_anzeige(analyseoff,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
              absatz,wahr,falsch,analyseoff+einzel_laenge,'')
          end;
        Exit; (* nicht nochmal .ini *)
      end;


    (* if bytesuche_dat_puffer_0('[' then *)
    w1:=puffer_pos_suche(dat_puffer_zeiger^,']',30);
    if w1<>nicht_gefunden then
      with dat_puffer_zeiger^ do
        begin
          if d[w1+1] in [0,10,13] then (* '[ESP]'#$b5.. bei 624 Version 1.1 *)
            textini
          else
            (* acelpacm.inf: '[Version] '#13#10'Signature'... *)
            if leer_filter(puffer_zu_zk_zeilenende(d[w1+1],255))='' then
              textini;
        end;

  end;

procedure dat_60;
  begin
    if bytesuche_dat_puffer_0(#$60#$1a#$00'???'#$00'???'#$00'???') then
      ATARI_TOS_prg(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$60#$EA) then
      with dat_puffer_zeiger^ do
        if bytesuche(d[2],#$0c#$00'OS/2') then
          (* siehe auch EA: REXX.METACONTROL *)
          (* entpacktes tyra2.tok *)
          (* OS/2 REXXSAA *)
          begin
            (* OS/2     REXXSAA 4.00 24 Oct 1997 *)
            exezk:=puffer_zu_zk_l(d[$4],33);
            (* OS/2     REXXSAA 4.00 3 Feb 1999  *)
            if exezk[28]=' ' then
              Dec(exezk[0]);
            ausschrift(exezk,compiler);
          end
        else
          arj(0,false,0);
  end;

procedure dat_61;
  begin
    (* Antiy Ghostbusters 4 Installation *)
    if bytesuche_dat_puffer_0('abcdefghijkl') then
      if bytesuche(dat_puffer_zeiger^.d[$140],'MZ???'#$00#$00#$00#$04#$00) then
        einzel_laenge:=$140;


    if bytesuche_dat_puffer_0('aLuZ'#$00#$00'Copy') then (* 6.0? *)
      begin
        ausschrift(textz_dat__compiled^+' Install Shield Setup Script',compiler);
        befehl_sonst('rem ? call pec isDcc '+dateiname+' > '+erzeuge_neuen_dateinamen('.isDcc'))
      end;

    if bytesuche_dat_puffer_0('aWAW'#$ae)
    and (analyseoff=$2000)
    and (einzel_laenge>80000)
    then
      createinstall;

    if bytesuche_dat_puffer_0('ajkg')
    and (dat_puffer_zeiger^.d[4] in [1,2])
     then
      ausschrift('shorten / Tony Robinson + SoftSound Ltd',packer_dat);

  end;

procedure dat_62;
  var
    w1                  :word_norm;
  begin

    if bytesuche_dat_puffer_0('backup ') then
      ecsmt_lst;

    if bytesuche_dat_puffer_0('blz'#$1a) then
      BriefLZ(dat_puffer_zeiger^,'BriefLZ');

    if bytesuche_dat_puffer_0('begin:vcard') then
      vcard(dat_puffer_zeiger^);
  end;

procedure dat_63;
  begin
    if bytesuche_dat_puffer_0('copy ') then
      ecsmt_lst;

    if bytesuche_dat_puffer_0('call ') then
      ecsmt_lst;

    if bytesuche_dat_puffer_0('conectix'#$00) then
      conectix_vpc_hd(dat_puffer_zeiger^);

  end;

procedure dat_64;
  var
    p_gross             :puffertyp;
  begin
    puffer_gross(dat_puffer_zeiger^,p_gross);

    if bytesuche_dat_puffer_0('data1.cab'#$00'Disk1\data1.cab') then
      installshield_19200(true);

    if bytesuche_dat_puffer_0('diff ') then
      begin
        diff(0,false);
        if hersteller_gefunden then Exit;
      end;

    if bytesuche_dat_puffer_0(#$64#$00#$00#$00'??'#$00#$00) then
      pw2_install;

    if puffer_zeilen_anfang_suche(p_gross,'DEBUG') then
      bat_datei(p_gross);

  end;

procedure dat_65;
  var
    p_gross             :puffertyp;
  begin
    puffer_gross(dat_puffer_zeiger^,p_gross);

    if bytesuche(p_gross.d[0],'EXTPROC ') then
      extproc(dat_puffer_zeiger^);

    if puffer_zeilen_anfang_suche(p_gross,'ECHO ') then
      bat_datei(p_gross);

    if bytesuche_dat_puffer_0('engine32.cab'#$00'Disk1\engine32.cab') then
      installshield_19200(true);

    if bytesuche_dat_puffer_0('e]'#$13'å') then
      (* Compusoft  HOPSCH *)
      (* enthÑlt PKWARE ... *)
      stirling_alt($e);
  end;

procedure dat_66;
  begin
    if bytesuche_dat_puffer_0('fbpr') then
      begin
        einzel_laenge:=x_dateigroessetyp(dat_puffer_zeiger^.d[4])+4+8;
        borland_pascal_resource(x_dateigroessetyp(dat_puffer_zeiger^.d[4+8]),x_dateigroessetyp(dat_puffer_zeiger^.d[4]),64);
      end;
  end;

procedure dat_67;
  begin
    if bytesuche_dat_puffer_0('gW') then (* und dann ^A^P^P *)
      crusher_scitech;

    (* CONFIGS.TOK aus einigen VX-REXX *)
    (* 'OS/2     OBJREXX 6.00 22 Oct 1998' *)
    if bytesuche_dat_puffer_0(#$67#$2b#$1e#$00) then
      ausschrift_rexx(puffer_zu_zk_e(dat_puffer_zeiger^.d[4],#0,$31));

  end;

procedure dat_68;
  begin
    if bytesuche_dat_puffer_0(#$68#$ea#$de#$72'XS') then
      with dat_puffer_zeiger^ do
        begin
          (* XS36208b.zip: 1.04.36208b *)
          exezk:=puffer_zu_zk_e(d[6],#0,$1e);
          if exezk='.Res ' then
            exezk:=puffer_zu_zk_e(d[$c],#0,$18);
          ausschrift('XSCompiler / Victor Prodan [1.04] "'+exezk+'"',compiler);
        end;

    if bytesuche_dat_puffer_0('head')
    and (dat_puffer_zeiger^.d[4] in [9,ord(' ')])
     then
      begin
        if  puffer_gefunden(dat_puffer_zeiger^,#$0a'access')
        and puffer_gefunden(dat_puffer_zeiger^,#$0a'comment')
         then
          ausschrift('Revision Control System',bibliothek);

      end;
  end;

procedure dat_69;
  begin
    if not textdatei then
      if bytesuche_dat_puffer_0('if') then
        modul_669;

    if bytesuche_dat_puffer_0('include ') then
      ecsmt_lst;
  end;

procedure dat_6a;
  begin
    if bytesuche_dat_puffer_0('jm'#$03#$05) then
      xpack_pd(dat_puffer_zeiger^,0);

    if bytesuche_dat_puffer_0('jm'#$02#$04) then
      ausschrift(textz_komprimierter_Plattenabzug^+' XPACK -P / JauMing Tseng',packer_dat);
  end;

procedure dat_6b;
  begin
    (* OS/2 4.0 D:\LANGUAGE\KEYBOARD\* *)
    if bytesuche_dat_puffer_0('kbl'#$00)
    and (dat_puffer_zeiger^.d[$16] in [ord('1'),ord('2')])
     then
      ausschrift('IBM keyboard layout "'+uc16_puffer_zu_zk_e(dat_puffer_zeiger^.d[$20],#0,64)+'"',bibliothek);
  end;

procedure dat_6c;
  begin
    if bytesuche_dat_puffer_0('lingvoArc2'#$00) then
      lingvoarc2;

    if bytesuche_dat_puffer_0('lZdIeT') then
      dietdisk(dat_puffer_zeiger^);

    if bytesuche_dat_puffer_0(#$6c#$50'?'#$00'?'#$00#$00#$00) then
      winhelp_picture('SHG/SHED');
    if bytesuche_dat_puffer_0(#$6c#$70'?'#$00'?'#$00#$00#$00) then
      winhelp_picture('MRB/MRBC');
  end;

procedure dat_6d;
  begin
    if bytesuche_dat_puffer_0('mhwanh') then
      if m_word(dat_puffer_zeiger^.d[6])=4 then
        handmade_software_raw(dat_puffer_zeiger^)
      else
        ausschrift('Handmade Software Raw (alt) ',musik_bild);
  end;

procedure dat_6e;
  begin
    if bytesuche_dat_puffer_0('note ') then
      ecsmt_lst;
  end;

procedure dat_70;
  begin
    if bytesuche_dat_puffer_0('package ')
    and textdatei then
      c_kommentar;


    if bytesuche_dat_puffer_0(#$70#$00#$68#$8F'1.000'#$0A#$FE) then
      ausschrift('EcoQuest 1 / Sierra',spielstand);

    if bytesuche_dat_puffer_0('pret'#$0d#$0a) then
      tr_script;

    if bytesuche_dat_puffer_0('pk'#$08#$08) then
      begin
        ausschrift(textz_Grafiktreiber^+' BGI',bibliothek);
        bgi_text(dat_puffer_zeiger^);
      end;

  end;

procedure dat_72;
  begin
    if bytesuche_dat_puffer_0('r32'#$0d#$0a) then
      tr_script; (* U_JMCE7R.TR *)

    if bytesuche_dat_puffer_0(#$72#$b5#$4a#$86) then
      psf2(dat_puffer_zeiger^);
  end;

procedure dat_73;
  begin
    if bytesuche_dat_puffer_0('setup.dl_'#$00'Setup.dll'#$00) then
      installshield_19200(true);
  end;

procedure dat_75;
  begin
    if bytesuche_dat_puffer_0('unzip.exe'#$00'-uo') then
      swf5(x_longint__datei_lesen(analyseoff+einzel_laenge-$10+4),
           false,
           x_longint__datei_lesen(analyseoff+einzel_laenge-$10+0));

    if bytesuche_dat_puffer_0('unzip ') then
      ecsmt_lst;

    if bytesuche_dat_puffer_0('uflz'#$01#$00#$00#$00) then
      BriefLZ(dat_puffer_zeiger^,'ultra fast lempel ziv');
  end;

procedure dat_76;
  begin
    if bytesuche_dat_puffer_0(#$76#$98#$a0#$a2) then
      begin
        ausschrift('InnoTek Application Loader -> '+hex_longint(longint_z(@dat_puffer_zeiger^.d[4])^),signatur);
        einzel_laenge:=8;
      end;

    (* PE SchutzhÅlle *)
    if bytesuche_dat_puffer_0(#$76#$78#$00#$00#$f1) and (analyseoff>0) then
      ausschrift('Armadillo / Silicon Realms Toolworks [1.21]',packer_exe);

    if bytesuche_dat_puffer_0('v'#$FF) then
      begin
        if bytesuche_dat_puffer_0('v'#$FF'1') and bytesuche(dat_puffer_zeiger^.d[$18],'     '#0) then
          codec
        else
          if puffer_anzahl_suche(dat_puffer_zeiger^,'.???'#0,8)<>nicht_gefunden then
            sqpc(dat_puffer_zeiger^);
      end;
  end;

procedure dat_77;
  begin
    if bytesuche_dat_puffer_0('wvpk'#$1c#$00#$00#$00) then
      wavpack(puffer_zu_zk_e(dat_puffer_zeiger^.d[$1c],#0,3));

    if bytesuche_dat_puffer_0(#$77#$04#$02#$be) then
      wpi(analyseoff,dateiname);
  end;

procedure dat_78;
  begin
    if bytesuche_dat_puffer_0('xxxxx?'#$00#$00#$00) then
      living;

    if bytesuche_dat_puffer_0(#$78#$56#$34#$12'%1') then
      begin
        (* SAXSETUP 6 teilweise ausgepackt im TMP-Verzeichnis *)
        hersteller_gefunden:=true; (* <TITLE> ... ignorieren (HTML) *)
        ende_suche_erzwungen:=true;
      end;

    if bytesuche_dat_puffer_0('xpa?'#$00) then (* 1.67 *)
      xpack_arc;
    if bytesuche_dat_puffer_0('xpa?'#$01) then (* 1.0.2 *)
      xpa32_100;

    if bytesuche_dat_puffer_0(#$78#$9f#$3e#$22) then
      tnef;

  end;

procedure dat_79;
  begin
    if bytesuche_dat_puffer_0('yz0') then
      yamazakizipper(dat_puffer_zeiger^);

  end;

procedure dat_7a;
  begin
    if bytesuche_dat_puffer_0('zlb'#$1a) then
      inno_setup;

  end;

procedure dat_7b;
  begin
    if bytesuche_dat_puffer_0('{') then
      if textdatei then
        pascal_quelle;

    if puffer_anzahl_suche(dat_puffer_zeiger^,'rtf',7)>0 then
      (* RTF *)
      ausschrift('Rich '+textz_Textformat^+' / MS',musik_bild);

  end;

procedure dat_7f;
  begin
    if bytesuche_dat_puffer_0(#$7F'DRFONT') then
      begin
        ausschrift('DR+NW - DOS '+textz_Schriftdefinitionen^,bibliothek);
        cpi_anzeige(dat_puffer_zeiger^);
      end;

    if bytesuche_dat_puffer_0(#$7f'PDZ') then
      with dat_puffer_zeiger^ do
        if d[4] in [Ord('0')..Ord('9')] then
          begin
            ausschrift('PDZ / Ivan Zhukov [BZip2]',packer_dat);
            (* mehrere BZIP2-Pakete, aber nicht nutzbar *)
          end;

    if bytesuche_dat_puffer_0(#$7f'ELF') then
      elf(dat_puffer_zeiger^);
  end;

end.
