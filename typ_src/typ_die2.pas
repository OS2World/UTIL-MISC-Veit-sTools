(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_die2;

interface

uses
  typ_type,
  typ_ausg;

procedure gif_anzeige(const p:puffertyp);
procedure adobe_photshop(const p:puffertyp);
function os2_resourcetyp_namen(n:longint):string;
function windows_resourcetyp_namen(n:longint):string;
function win32_languagecode(l:longint):string;
procedure tesca3(const p:puffertyp);
procedure suche_bin_bldlevel;
procedure ausschrift_modulbeschreibung(zk:string);
procedure paint_shop_pro_image_file(const p:puffertyp);
procedure profan(const p:puffertyp;const i:word_norm);
procedure airboot_kennwort;
procedure sbm_kennwort;
procedure bootstar_kennwort;
procedure masterbooter_kennwort;
procedure tbutil_dat(var p:puffertyp);
procedure conectix_vpc_hd(var p:puffertyp);
procedure elf(const p:puffertyp);
procedure handmade_software_raw(const p:puffertyp);
procedure eps_vorspann(const p:puffertyp);
procedure palmpilot(const p:puffertyp);
procedure softimage_pic(const p:puffertyp);
procedure ATARI_TOS_prg(const p:puffertyp);
procedure rdoff(const p:puffertyp);
procedure FlexibleImageTransportSystem;
procedure probiere_sfv;
procedure anzeige_sdw_reg;
procedure country_sys_anzeige(const p:puffertyp);
procedure drdos_country_sys_anzeige(copyr:word_norm);
procedure keyboard_sys_anzeige;
procedure linux_software_map;
procedure hobbes_upload_text;
procedure versuche_lizenz_readme(const p:puffertyp);
procedure versuche_adaptec_readme(const p:puffertyp);
procedure extproc(const p:puffertyp);
procedure probiere_readme_ueberschrift(const p:puffertyp;c:char);
procedure probiere_readme_zwischenzeile(c:char);
procedure probiere_readme_ueberschrift_unterstrichen(const p:puffertyp;c:char);
procedure probiere_readme_bootmenu_txt(const p:puffertyp);
procedure versuche_tmf;
procedure bootwiz_cfg(const o0,laenge:dateigroessetyp);
procedure pascal_quelle;
procedure versuche_dsp_oder_ddp_datei;
procedure versuche_def;
procedure xosl_kennwort(const o0,laenge:dateigroessetyp);
procedure versuche_ibm_software_installer;
procedure troff;
procedure syslevel(const p:puffertyp);
procedure vcard(const p:puffertyp);
procedure watcom_patch_level(const p:puffertyp);
procedure versuche_doppelrahmen_kasten(const p:puffertyp);
procedure fastpacked_oliver_weindl(const p:puffertyp);
procedure mach_o(const p:puffertyp);
procedure win32_debuginfo(const p:puffertyp);
procedure os2_font_metrics(const p:puffertyp);
procedure theme_park_bullfrog;
procedure mod_anzeige(const doppelt:boolean);
procedure scream_tracer_3(const p:puffertyp);
procedure scream_tracer_2(const p:puffertyp);
procedure ft_extended_module(var p:puffertyp);
function versuche_carmel_pruefsummen_datei(const blocklaenge,rest:word_norm):boolean;
procedure Delusion_Digital_Music_Fileformat;
procedure MAS_UTrack_V00(const p:puffertyp);
procedure textini;
procedure scg_setup_info(const p:puffertyp;const version:word_norm);
function lha_variante(const p:puffertyp;const index:word_norm):string;
procedure eddie_test(var p:puffertyp);
procedure cascade(const p:puffertyp);
procedure dos4gw_exp(const p:puffertyp);
procedure diff(anfang:dateigroessetyp;nur_ein_diff:boolean);
procedure rcs;
procedure versuche_scitech_driver_tab;
procedure EddyHawk_infolist;
procedure tr_script;
procedure vrml(const p:puffertyp);
procedure shell_script(const p:puffertyp);
procedure smpzipse(const p:puffertyp);
procedure sql;
procedure ecsmt_lst;
procedure bink_video(const p:puffertyp);
procedure versuche_mpeg(const p:puffertyp);
procedure ausschrift_rexx(s:string);
procedure myresource_1024_installshield(const o:dateigroessetyp;var l:dateigroessetyp;const aenderbar:boolean);
procedure install_shield_stub_archiv(const p:puffertyp);
procedure phoenix_bitmap;
procedure debug_comp_id(const p:puffertyp);
procedure acpi_dsdt(const p:puffertyp;const t:string);
procedure acpi_facs(const p:puffertyp;const t:string);
function cpu_microcode(const p:puffertyp;var einzel_laenge:dateigroessetyp):boolean;
function mime_encode(const o0:dateigroessetyp;var l:dateigroessetyp;const verschachtelt:boolean;const prefix:string):boolean;
procedure sierra_drv(const p:puffertyp);
procedure id3(const p:puffertyp);
function  id3ende:boolean;
procedure ausschrift_watcom(const p:puffertyp;i,l:word_norm);
procedure ASN1(const o0:dateigroessetyp);
procedure postscript(const dateityp:string;const p:puffertyp;i:word_norm;const font:boolean);
procedure winhelp_picture(const werkzeug:string);
procedure macintosh_hfs(o:longint);
procedure versuche_iso9660;
function tbfence_pw(const p:puffertyp):string;
function pkver(const flag,ver:byte):string;
function wwpack_version(const v:byte):string;
function double_density_pass(w:smallword):string;
procedure bgi_text(const p:puffertyp);
function username300_pw(const p:puffertyp):string;
procedure c_copy_run(posi:dateigroessetyp;const zusatztext,ausweichtext:string;
                     const attribut:aus_attribute;const min_laenge:byte;const ende,enthalten:string);
function pctools_pw(const p:string):string;
procedure pgp(const p:puffertyp;const po,laenge:word_norm);

implementation

uses
  typ_dien,
  typ_var,
  typ_eiau,
  typ_for3,
  typ_for4,
  typ_for5,
  typ_cd,
  typ_spra,
  typ_varx,
  typ_posm,
  typ_xexe,
  typ_entp,
  typ_dat;

procedure gif_anzeige(const p:puffertyp);
  var
    o                   :longint;
    x,y,f,x1,y1,f1      :word_norm;
    et,l                :byte;
    erster_durchlauf    :boolean;
    dien_puffer         :puffertyp;
  begin
    o:=6; (* Kopf *)

    (* logical screen descriptor *)
    x:=word_z(@p.d[6+0])^;
    y:=word_z(@p.d[6+2])^;
    f:=1 shl ((p.d[6+4] and $07)+1);

    if not langformat then
      begin
        bild_format_filter('GIF / CompuServe',x,y,f,-1,false,true,anstrich);
        Exit;
      end;

    Ausschrift('GIF / CompuServe',musik_bild);

    Inc(o,7);

    if (p.d[6+4] and $80)=$80 then (* global color table *)
      Inc(o,f*3);

    (* Datenblîcke *)
    while o<einzel_laenge do
      begin
        datei_lesen(dien_puffer,analyseoff+o,11);
        case dien_puffer.d[0] of
          $00: (* Fehler! *)
            begin
              ausschrift('Invalid descriptor! ('+hex(dien_puffer.d[0])+')',dat_fehler);
              l:=0;
              while (dien_puffer.d[l]=0) and (l<dien_puffer.g) do Inc(l);
              if l=dien_puffer.g then
                Break;
              if dien_puffer.d[l]=$3b then
                Inc(o,l+1);
            end;


          $2c: (* image description *)
            begin
              x1:=word_z(@dien_puffer.d[5])^;
              y1:=word_z(@dien_puffer.d[7])^;
              f1:=1 shl (1+dien_puffer.d[9] and $07);
              Inc(o,11);

              if (dien_puffer.d[9] and $80)=$80 then(* local colortable *)
                begin
                  bild_format_filter('',x1,y1,f1,-1,false,true,absatz);
                  Inc(o,3*f1);
                end
              else
                bild_format_filter('',x1,y1,f ,-1,false,true,absatz);
              (* .. and $40: interlaced *)
              with dien_puffer do
                repeat
                  datei_lesen(dien_puffer,analyseoff+o,1);
                  Inc(o,1+d[0]);
                until (d[0]=0) or (g<>1);
            end;

          $21: (* extension introducer *)
            begin
              et:=dien_puffer.d[1];
              Inc(o,2);
              erster_durchlauf:=true;

              with dien_puffer do
                repeat
                  datei_lesen(dien_puffer,analyseoff+o,1);
                  Inc(o);
                  l:=d[0];
                  if (l=0) or (g=0) then Break;

                  (*datei_lesen(dien_puffer,analyseoff+o,l);*)

                  case et of
                    $01: (* plain text extension *)
                      ; (* 12+Subblocks.. *)

                    $f9: (* Graphic control extension *)
                      begin (* 4 Byte *)
                        (* 2.W: Delay 1/100s *)
                      end;

                    $fe: (* comment extension *)
                      begin
                        ansi_anzeige(o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,
                         false,false,o+l,'');
                      end;

                    $ff:(* application extension *)
                      begin
                        (*if bytesuche(dien_puffer.d[1],'NETSCAPE') then
                          ausschrift_x('animation',signatur,absatz);*)
                        if erster_durchlauf then
                          begin
                            datei_lesen(dien_puffer,o,8+3);
                            ausschrift_x(puffer_zu_zk_l(dien_puffer.d[0],8)
                             +' ['+puffer_zu_zk_l(dien_puffer.d[8],3)+']',bibliothek,absatz);
                          end;
                      end;
                  end;

                  Inc(o,l);
                  erster_durchlauf:=false;
                until false;

            end;

          $3b: (* trailer *)
            begin
              Inc(o,1);
              Break;
            end;

        else
          ausschrift('Invalid descriptor! ('+hex(dien_puffer.d[0])+')',dat_fehler);
          Break;

        end; (* case [0] *)

      end; (* while <einzel_laenge *)

    if o<einzel_laenge then
      einzel_laenge:=o;
  end;

procedure adobe_photshop(const p:puffertyp);
  var
    o,l:longint;
    kopflaenge:integer_norm;
  begin
    bild_format_filter('Photoshop / Adobe',
                               m_longint(p.d[14+4]),
                               m_longint(p.d[14+0]),
                               -1,m_word(p.d[14+8]),false,true,absatz);
    (*
    if not langformat then Exit;

    //ausschrift(!!)
    //_----
    o:=4+2+6+2+4+4+2+2+m_longint(p.d[$1a])+8;

    repeat
      datei_lesen(dien_puffer,analyseoff+o,270);
      if not bytesuche(dien_puffer.d[0],'8BIM') then Break;

      kopflaenge:=4+2;
      exezk:=puffer_zu_zk_e(dien_puffer.d[kopflaenge],#0,255);
      Inc(kopflaenge,Length(exezk)+1);
      if Odd(kopflaenge) then Inc(kopflaenge);
      l:=m_longint(dien_puffer.d[kopflaenge]);
      Inc(kopflaenge,4);
      ausschrift(strx_oder_hex(o)+':'+strx_oder_hex(m_word(dien_puffer.d[4]))+' '+strx_oder_hex(l)+' '+exezk,normal);
      Inc(o,kopflaenge+l);
      if Odd(o) then Inc(o);
    until o>=einzel_laenge;*)
  end;

function os2_resourcetyp_namen(n:longint):string;
  const
    resource_typen:array[1..24] of string[Length('HelpSubtable')]=
    ('Pointer',          (* mouse pointer shape                    *)
     'Bitmap',           (* bitmap                                 *)
     'Menu',             (* menu template                          *)
     'Dialog',           (* dialog template                        *)
     'String',           (* string tables                          *)
     'FontDir',          (* font directory                         *)
     'Font',             (* font                                   *)
     'AccelTable',       (* accelerator tables                     *)
     'RCData',           (* binary data                            *)
     'Message',          (* error msg tables                       *)
     'DLGInclude',       (* dialog include file name               *)
     'VKeyTbl',          (* key to vkey tables                     *)
     'KeyTbl',           (* key to UGL tables                      *)
     'CharTbl',          (* glyph to character tables              *)
     'DisplayInfo',      (* screen display information             *)
     'FKAShort',         (* function key area short form           *)
     'FKALong',          (* function key area long form            *)
     'HelpTable',        (* Help table for Cary Help manager       *)
     'HelpSubtable',     (* Help subtable for Cary Help manager    *)
     'FDDir',            (* DBCS uniq/font driver directory        *)
     'FD',               (* DBCS uniq/font driver                  *)
     'DefaultIcon',
     'AssocTable',       (* EA *)
     'ResNames');


  begin
    if (n>=Low(resource_typen)) and (n<=High(resource_typen)) then
      os2_resourcetyp_namen:=resource_typen[n]
    else
      os2_resourcetyp_namen:=str0(n);
  end;

function windows_resourcetyp_namen(n:longint):string;
  const
    resource_typen:array[1..24] of string[Length('Animated cursor')]=
    ('Cursor', (* aus TDUMP, RC Syntax wahrscheinlich ohne Leerzeichen .. *)
     'Bitmap',
     'Icon',
     'Menu',
     'Dialog',
     'String Table',
     'Font Directory',
     'Font',
     'Accelerator',
     'RC Data',
     'Error Table',
     'Group Cursor',
     '13',
     'Group Icon',
     'Name Table',
     'Version info',
     '17',
     '18',
     'Plug & Play', (* res file format *)
     'VXD',         (* res file format *)
     'Animated cursor',
     'Animated icon',
     '23',
     'manifest'); (* geraten (xml) *)
  begin
    n:=n and (not $2000); (* $2002,$2004,$2005 *)
    if (n>=Low(resource_typen)) and (n<=High(resource_typen)) then
      windows_resourcetyp_namen:=resource_typen[n]
    else
      windows_resourcetyp_namen:=str0(n);
  end;

function win32_languagecode(l:longint):string;
(*&J-*)
const (* Daten aus \vp21\source\rtl\windows.pas *)
  sprachtabelle:array[0..45] of
    packed record
      id:longint;
      zk:pChar;
    end=
   ((id:$00+$00 shl 10;zk:'neutral'),
    (id:$00+$01 shl 10;zk:'user'),
    (id:$00+$02 shl 10;zk:'system'),
    (id:$01           ;zk:'Arabic'),
    (id:$02           ;zk:'Bulgarian'),
    (id:$03           ;zk:'Catalan'),
    (id:$04           ;zk:'Chinese'),
    (id:$05           ;zk:'Czech'),
    (id:$06           ;zk:'Danish'),
    (id:$07           ;zk:'German'),
    (id:$08           ;zk:'Greek'),
    (id:$09           ;zk:'English'),
    (id:$0a           ;zk:'Spanish'),
    (id:$0b           ;zk:'Finnish'),
    (id:$0c           ;zk:'French'),
    (id:$0d           ;zk:'Hebrew'),
    (id:$0e           ;zk:'Hungarian'),
    (id:$0f           ;zk:'Icelandic'),
    (id:$10           ;zk:'Italian'),
    (id:$11           ;zk:'Japanese'),
    (id:$12           ;zk:'Korean'),
    (id:$13           ;zk:'Dutch'),
    (id:$14           ;zk:'Norvegian'),
    (id:$15           ;zk:'Polish'),
    (id:$16           ;zk:'Portuguese'),
    (id:$18           ;zk:'Romanian'),
    (id:$19           ;zk:'Russian'),
    (id:$1a           ;zk:'Croatian'),
    (id:$1a           ;zk:'Serbian'),
    (id:$1b           ;zk:'Slovak'),
    (id:$1c           ;zk:'Albanian'),
    (id:$1d           ;zk:'Swedish'),
    (id:$1e           ;zk:'Thai'),
    (id:$1f           ;zk:'Turkish'),
    (id:$21           ;zk:'Indonesian'),
    (id:$22           ;zk:'Ukrainian'),
    (id:$23           ;zk:'Belarusian'),
    (id:$24           ;zk:'Slovenian'),
    (id:$25           ;zk:'Estonian'),
    (id:$26           ;zk:'Latvian'),
    (id:$27           ;zk:'Lithuanian'),
    (id:$29           ;zk:'Farsi'),
    (id:$2a           ;zk:'Vietnamese'),
    (id:$2d           ;zk:'Basqur'),
    (id:$36           ;zk:'Afrikaans'),
    (id:$38           ;zk:'Faeroese'));

(* sind mir zuviel Daten

  SubLang_Arabic_Saudi_Arabia          = $01;    { Arabic (Saudi Arabia) }
  SubLang_Arabic_Iraq                  = $02;    { Arabic (Iraq) }
  SubLang_Arabic_Egypt                 = $03;    { Arabic (Egypt) }
  SubLang_Arabic_Libya                 = $04;    { Arabic (Libya) }
  SubLang_Arabic_Algeria               = $05;    { Arabic (Algeria) }
  SubLang_Arabic_Morocco               = $06;    { Arabic (Morocco) }
  SubLang_Arabic_Tunista               = $07;    { Arabic (Tunisia) }
  SubLang_Arabic_Oman                  = $08;    { Arabic (Oman) }
  SubLang_Arabic_Yemen                 = $09;    { Arabic (Yemen) }
  SubLang_Arabic_Syria                 = $0a;    { Arabic (Syria) }
  SubLang_Arabic_Jordan                = $0b;    { Arabic (Jordan) }
  SubLang_Arabic_Lebanon               = $0c;    { Arabic (Lebanon) }
  SubLang_Arabic_Kuwait                = $0d;    { Arabic (Kuwait) }
  SubLang_Arabic_UAE                   = $0e;    { Arabic (U.A.E) }
  SubLang_Arabic_Bahrain               = $0f;    { Arabic (Bahrain) }
  SubLang_Arabic_Qatar                 = $10;    { Arabic (Qatar) }
  SubLang_Chinese_Traditional          = $01;    { Chinese (Taiwan) }
  SubLang_Chinese_Simplified           = $02;    { Chinese (PR China) }
  SubLang_Chinese_Hongkong             = $03;    { Chinese (Hong Kong) }
  SubLang_Chinese_Singapore            = $04;    { Chinese (Singapore) }
  SubLang_Dutch                        = $01;    { Dutch }
  SubLang_Dutch_Belgian                = $02;    { Dutch (Belgian) }
  SubLang_English_US                   = $01;    { English (USA) }
  SubLang_English_UK                   = $02;    { English (UK) }
  SubLang_English_AUS                  = $03;    { English (Australian) }
  SubLang_English_CAN                  = $04;    { English (Canadian) }
  SubLang_English_NZ                   = $05;    { English (New Zealand) }
  SubLang_English_Eire                 = $06;    { English (Irish) }
  SubLang_English_South_Africa         = $07;    { English (South Africa) }
  SubLang_English_Jamaica              = $08;    { English (Jamaica) }
  SubLang_English_Caribbean            = $09;    { English (Caribbean) }
  SubLang_English_Belize               = $0a;    { English (Belize) }
  SubLang_English_Trinidad             = $0b;    { English (Trinidad) }
  SubLang_French                       = $01;    { French }
  SubLang_French_Belgian               = $02;    { French (Belgian) }
  SubLang_French_Canadian              = $03;    { French (Canadian) }
  SubLang_French_Swiss                 = $04;    { French (Swiss) }
  SubLang_French_Luxembourg            = $05;    { French (Luxembourg) }
  SubLang_German                       = $01;    { German }
  SubLang_German_Swiss                 = $02;    { German (Swiss) }
  SubLang_German_Austrian              = $03;    { German (Austrian) }
  SubLang_German_Luxembourg            = $04;    { German (Luxembourg) }
  SubLang_German_Liechtenstein         = $05;    { German (Liechtenstein) }
  SubLang_Italian                      = $01;    { Italian }
  SubLang_Italian_Swiss                = $02;    { Italian (Swiss) }
  SubLang_Korean                       = $01;    { Korean (Extended Wansung) }
  SubLang_Korean_Johab                 = $02;    { Korean (Johab) }
  SubLang_Norvegian_Bokmal             = $01;    { Norwegian (Bokmal) }
  SubLang_Norvegian_Nynorsk            = $02;    { Norwegian (Nynorsk) }
  SubLang_Portuguese                   = $02;    { Portuguese }
  SubLang_Portuguese_Brazilian         = $01;    { Portuguese (Brazilian) }
  SubLang_Serbian_Latin                = $02;    { Serbian (Latin) }
  SubLang_Serbian_Cyrillic             = $03;    { Serbian (Cyrillic) }
  SubLang_Spanish                      = $01;    { Spanish (Castilian) }
  SubLang_Spanish_Mexican              = $02;    { Spanish (Mexican) }
  SubLang_Spanish_Modern               = $03;    { Spanish (Modern) }
  SubLang_Spanish_Guatemala            = $04;    { Spanish (Guatemala) }
  SubLang_Spanish_Costa_Rica           = $05;    { Spanish (Costa Rica) }
  SubLang_Spanish_Panama               = $06;    { Spanish (Panama) }
  SubLang_Spanish_Dominican_Republic     = $07;  { Spanish (Dominican Republic) }
  SubLang_Spanish_Venezuela            = $08;    { Spanish (Venezuela) }
  SubLang_Spanish_Colombia             = $09;    { Spanish (Colombia) }
  SubLang_Spanish_Peru                 = $0a;    { Spanish (Peru) }
  SubLang_Spanish_Argentina            = $0b;    { Spanish (Argentina) }
  SubLang_Spanish_Ecuador              = $0c;    { Spanish (Ecuador) }
  SubLang_Spanish_Chile                = $0d;    { Spanish (Chile) }
  SubLang_Spanish_Uruguay              = $0e;    { Spanish (Uruguay) }
  SubLang_Spanish_Paraguay             = $0f;    { Spanish (Paraguay) }
  SubLang_Spanish_Bolivia              = $10;    { Spanish (Bolivia) }
  SubLang_Spanish_El_Salvador          = $11;    { Spanish (El Salvador) }
  SubLang_Spanish_Honduras             = $12;    { Spanish (Honduras) }
  SubLang_Spanish_Nicaragua            = $13;    { Spanish (Nicaragua) }
  SubLang_Spanish_Puerto_Rico          = $14;    { Spanish (Puerto Rico) }
  SUBLANG_Swedish                      = $01;    { Swedish }
  SUBLANG_Swedish_Finland              = $02;    { Swedish (Finland) }*)

  var
    i:word_norm;
  begin
    for i:=Low(sprachtabelle) to High(sprachtabelle) do
      with sprachtabelle[i] do
        if l=id then
          begin
            win32_languagecode:=puffer_zu_zk_e(zk^,#0,255);
            Exit;
          end;
    for i:=Low(sprachtabelle) to High(sprachtabelle) do
      with sprachtabelle[i] do
        if l and (1 shl 10-1)=id then
          begin
            win32_languagecode:=puffer_zu_zk_e(zk^,#0,255);
            Exit;
          end;

    if l shr 10=0 then
      win32_languagecode:=str0(l and (1 shl 10-1))
    else
      win32_languagecode:=str0(l and (1 shl 10-1))+'_'+str0(l shr 10);
  end;

procedure tesca3(const p:puffertyp);
  var
    o           :longint;
    anzahl      :word_norm;
  begin

    (* PrÅfung gegen Fehlmeldungen (lish.s3m beginnt mit "LightShade"
       und ist lang genug *)

    o:=word_z(@p.d[3])^;
    anzahl:=byte__datei_lesen(analyseoff+o);
    if (anzahl<0) or (anzahl>20) then Exit;
    Inc(o);
    if anzahl>=1 then
      begin
        exezk:=datei_lesen__zu_zk_pstr(analyseoff+o);
        if not ist_ohne_steuerzeichen_nicht_so_streng(exezk) then
          Exit;
      end;

    case p.d[2] of
      $01,
      $31:
          bild_format_filter('Tesca / R. Leitner [3]',
            word_z(@p.d[5])^,
            word_z(@p.d[7])^,
            2,-1,
            false,true,anstrich);
      $33:ausschrift('Tesca / R. Leitner [3]',musik_bild);
    else
          ausschrift('Tesca / R. Leitner?',musik_bild);
    end;
    o:=word_z(@p.d[3])^;
    anzahl:=byte__datei_lesen(analyseoff+o);
    Inc(o);
    while anzahl>0 do
      begin
        Dec(anzahl);
        exezk:=datei_lesen__zu_zk_pstr(analyseoff+o);
        ausschrift_x(exezk,beschreibung,leer);
        Inc(o,1+Length(exezk));
      end;
    (*einzel_laenge:=o;*)
  end;


procedure suche_bin_bldlevel;
  var
    l:dateigroessetyp;
  begin
    l:=analyseoff;
    repeat
      l:=datei_pos_suche(l,analyseoff+einzel_laenge,'@#');
      if l=nicht_gefunden then Break;
      exezk:=datei_lesen__zu_zk_e(l,#0,128);
      if  (Pos(':',exezk)>0)
      and (Pos('#@',exezk)>0) then
        begin
          ausschrift_modulbeschreibung(exezk);
          Break;
        end;
      IncDGT(l,1);
    until false;
  end;


procedure ausschrift_modulbeschreibung(zk:string);
  var
    dateiversion        :string;

  procedure ausschrift0(const zk1,bis:string;const laenge:word_norm;const anzeige:boolean);
    var
      z1,lbis:word_norm;
      zk2:string;
    begin
      lbis:=0;
      if laenge<>0 then
        z1:=laenge
      else
        begin
          z1:=Pos(bis,zk);
          if z1=0 then
            z1:=Length(zk)
          else
            begin
              lbis:=Length(bis);
              Dec(z1);
            end;
        end;

      zk2:=Copy(zk,1,z1);
      Delete(zk,1,z1+lbis);

      while (Length(zk2)>0) and (zk2[1] in [#9,' ']) do
        Delete(zk2,1,1);

      if (zk2<>'') and (anzeige) then
        ausschrift(zk1+zk2,beschreibung);
        if dateiversion='.' then

      if dateiversion='.' then
        if zk2='' then
          dateiversion:=''
        else
          dateiversion:=zk2+'.';
    end;

  var
    f1,f2:word_norm;

  begin
    dateiversion:='';
    if Pos('$@#',zk)=1 then
      Delete(zk,1,1);

    (* W4: INSTALL.EXE hat erst die Beschreibung und dann die Daten *)
    f1:=Pos('@#',zk);
    f2:=Pos('#@',zk);
    if (f1<>0) and (f2<>0) then
      if f2+1=Length(zk) then
        zk:=Copy(zk,f1,f2-f1+1+1)+Copy(zk,1,f1-1);

    if Pos('@#',zk)=1 then
      begin
        (*ausschrift ('Beschreibung : '+zk,beschreibung);*)

        Delete(zk,1,Length('@#'));

        ausschrift0(textz_xexe__Vendor^ ,':' ,0,true);

        dateiversion:='.';
        ausschrift0(textz_xexe__Version^,'#@',0,true);

        if Pos('##1##',zk)=1 then
          begin
            Delete(zk,1,Length('##1##'));
            ausschrift0(textz_xexe__erstellt^,''  ,24,true);
            ausschrift0(textz_xexe__auf^     ,':' , 0,true);
          end;


        if Pos(':',zk)<>0 then
          ausschrift0('ASD          : '      ,':' , 0,true);
        if Pos(':',zk)<>0 then
          ausschrift0(textz_xexe__lang^      ,':' , 0,true);
        if Pos(':',zk)<>0 then
          ausschrift0(textz_xexe__country^   ,':' , 0,true);
        if Pos(':',zk)<>0 then
          ausschrift0(textz_xexe__fileversion^+dateiversion,':' ,0,true);
        if Pos(':',zk)<>0 then
          ausschrift0('??           : '      ,':' , 0,true);
        if Pos('@@',zk)<>0 then
          ausschrift0(textz_xexe__fixpak^    ,'@@', 0,true);
      end;

    zk:=leer_filter(zk);

    if zk<>'' then
      ausschrift(in_doppelten_anfuerungszeichen(zk),beschreibung);
  end;

procedure paint_shop_pro_image_file(const p:puffertyp);
  var
    o:longint;
  begin
    with p do
      begin
        bild_format_filter(
          'Paint Shop Pro / Jasc Software'+version_x_y(word_z(@d[$20])^,word_z(@d[$22])^),
          longint_z(@d[$24+$0e])^,longint_z(@d[$24+$12])^,
          -1,word_z(@d[$24+$21])^,
          false,true,anstrich);

        if word_z(@d[$24+$32])^<>1 then
          ausschrift('Layer count:'+str0(word_z(@d[$24+$32])^),normal);



     (* Listfunktion?
        ausschrift('Paint Shop Pro / Jasc Software'+version_x_y(word_z(@d[$20])^,word_z(@d[$22])^),musik_bild);

       ~BK,lÑnge/lÑnge-4
        o:=$24;
        datei_lesen(dien_puffer,analyseoff+o,$3a); *)
    end;
  end;

procedure profan(const p:puffertyp;const i:word_norm);
  begin
    ausschrift('Profan / Roland G. HÅlsmann ['+Chr(p.d[i+11])+']',compiler);
    if p.d[i+$13]<>Ord(' ') then
    ausschrift_x('XOR '+hex(p.d[i+$13]),packer_exe,absatz);
  end;

procedure airboot_kennwort;
  var
    dien_puffer:puffertyp;

  function entschluessele(position,uebrig:word_norm):boolean;
    const
      schluessel:array[0..7+7] of byte=($be,$ba,$77,$fc,$2f,$63,$09,$cd,$50,$51,$1e,$56,$06,$57,$8c);
    var
      c,d,versuch:word_norm;
    begin
      entschluessele:=true;

      if uebrig=0 then
        Exit;

      c:=dien_puffer.d[position] xor dien_puffer.d[position-1];
      for versuch:=0 to 7 do
        begin
          d:=c xor schluessel[uebrig-1+versuch];
          if ((d xor $ab) and $07)=versuch then
            if Chr(d) in ['A'..'Z','0'..'9',' '] then
              if entschluessele(position-1,uebrig-1) then
                begin
                  exezk:=exezk+Chr(d);
                  Exit;
                end;
        end;

      entschluessele:=false;
    end;

  begin
    datei_lesen(dien_puffer,analyseoff+$6c00,$40);
    if bytesuche(dien_puffer.d[0],'AiRCFG') then
      begin
        dien_puffer.d[$2e-1]:=$c3;
        exezk:='';
        if entschluessele($2e+8-1,8) then
          ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);

        dien_puffer.d[$36-1]:=$c3;
        exezk:='';
        if entschluessele($36+8-1,8) then
          ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
      end;

  end;

procedure sbm_kennwort;
  var
    soll:longint;
    s:string[16];
    l:longint;

  (*

  function berechne(const s:string):longint;assembler;
    {&Frame+}{Uses eax,edx,esi,ecx}
    asm
      mov esi,s
      sub edx,edx
      sub eax,eax
      cld
      lodsb
      movzx ecx,al
      jecxz @U
    @R:
      lodsb
      not al
      rol al,4
      add edx,eax
      rol edx,2
      loop @R
    @U:
      mov eax,edx
    end;*)

  begin
    soll:=x_longint__datei_lesen($230);
    if soll=0 then
      s:=''
    else
      begin
        soll:=ror32(not soll,6);
        s:='0000000000000000';
        for l:=16 downto 1 do
          begin
            s[l]:=Chr(Ord('0')+soll and 3);
            soll:=soll shr 2;
          end;
      end;

    ausschrift(in_doppelten_anfuerungszeichen(s),normal);
  end;

procedure bootstar_kennwort;
  var
    p:puffertyp;
    i:word_norm;
  begin
    datei_lesen(p,analyseoff+$600,512);
    (* EntschlÅsselung von 704 *)
    with p do
      for i:=0 to $1fc-1 do
        d[i]:=d[i] xor $a5 xor Lo(i);
    exezk:=puffer_zu_zk_e(p.d[$10],#0,255);
    if not ist_ohne_steuerzeichen_nicht_so_streng(exezk) then Exit;
    ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz); (* unregistred! *)
    exezk:=puffer_zu_zk_e(p.d[$1e0],#0,12);
    ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz); (* Kennwort *)
  end;

procedure masterbooter_kennwort;
  var
    i:word_norm;
    p:puffertyp;
  begin
    (* 3.0 shareware: b50 *)
    (* 3.2 shareware: d50 *)

    for i:=0 to 4 do
      begin
        datei_lesen(p,analyseoff+$800+i*$200-$10,512);
        if bytesuche(p.d[0],#$99#$99#$99#$99#$99#$99#$99#$99#$99#$99#$99#$99#$99#$99#$99#$99) then
          begin
            exezk:=puffer_zu_zk_e(p.d[$150+$10],#0,16);
            ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
            Exit;
          end;
      end;
  end;


procedure tbutil_dat(var p:puffertyp);
  begin
    exezk:=in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[$14],#$1a,255));
    ausschrift('Thunderbyte AV '+textz_Systeminformationen_sicherung^
      +' '+exezk,signatur);

    (*
    ausschrift_v('');
    hersteller_gefunden:=falsch;
    codeoff_off:=0;
    codeoff_seg:=0;
    inc(analyseoff,512);
    datei_lesen(dat_tmp_puffer,analyseoff,512);
    einzel_laenge:=512;
    start_sekt(dat_tmp_puffer,wahr,255,wahr,0,0,0);
    if not hersteller_gefunden then ausschrift_nichts_gefunden(signatur);

    ausschrift_v('');
    hersteller_gefunden:=falsch;
    codeoff_off:=0;
    codeoff_seg:=0;
    inc(analyseoff,512);
    datei_lesen(dat_tmp_puffer,analyseoff,512);
    einzel_laenge:=512;
    start_sekt(dat_tmp_puffer,wahr,255,wahr,0,0,0);
    if not hersteller_gefunden then ausschrift_nichts_gefunden(signatur);

    dec(analyseoff,2*512);

    dat_puffer_zeiger^.d[0]:=0;
    einzel_laenge:=3*512;*)

    einzel_laenge:=$200;
    merke_position(analyseoff+$200,datentyp_unbekannt);
    merke_position(analyseoff+$400,datentyp_unbekannt);
    merke_position(analyseoff+$600,datentyp_unbekannt);
  end;

procedure conectix_vpc_hd(var p:puffertyp);
  begin
    with p do
      begin
        {::}
        ausschrift('Virtual PC / Conectix hard disk',packer_dat);
        ausschrift_x(puffer_zu_zk_l(d[$1c],4)+version_x_y(m_word(d[$20]),m_word(d[$22]))+' '
                    +puffer_zu_zk_l(d[$24],4),beschreibung,absatz);
        case m_longint(d[$3c]) of
          2:exezk:='raw';
          3:exezk:='sparse';
          4:exezk:='sparse+diff '+in_doppelten_anfuerungszeichen(uc16_datei_lesen__zu_zk_e(analyseoff+$241,#0,80));
        else
            exezk:='¯? ('+hex_longint(m_longint(d[$3c]))+')';
        end;
        ausschrift_x(exezk,packer_dat,absatz);
        ausschrift_x(textz_dien__Zylinder__^+str0(m_word(p.d[$38]))
                    +textz_dien____Heads__^+str0(p.d[$3a])
                    +textz_dien____Sectors__^+str0(p.d[$3b]),beschreibung,absatz);

      end;
  end;

procedure elf(const p:puffertyp);
  var
    w1,w2               :word_norm;
  begin
    with p do
      begin
        case d[4] of (* file class *)
          0:exezk:='invalid class';
          1:exezk:='32 Bit';
          2:exezk:='64 Bit';
        else
            exezk:='?? Bit'
        end;

        case d[5] of (* data encoding *)
          1:
            begin
              exezk_anhaengen(', LSB'); (* intel *)
              w1:=word_z(@d[16])^;
              w2:=word_z(@d[18])^;
            end;
          2:
            begin
              exezk_anhaengen(', MSB');
              w1:=m_word(d[16]);
              w2:=m_word(d[18]);
            end;
        end;

        case w1 of
          0:exezk_anhaengen(textz_komma_unbekannter_Typ^);
          1:exezk_anhaengen(', relocatable');
          2:exezk_anhaengen(textz_komma_ausfuehrbar^);
          3:exezk_anhaengen(', dynamic lib');
          4:exezk_anhaengen(', core');
        else
            exezk_anhaengen(', ?? Typ');
        end;

        exezk_anhaengen(textz_dat__x_Zielsystem_^);
        case (*dat_puffer_zeiger^.d[18]*)w2 of
          0:exezk_anhaengen(textz_dat__unbekannt^);
          1:exezk_anhaengen('AT&T WE32100+');
          2:exezk_anhaengen('SPARC');
          3:exezk_anhaengen('i386+');
          4:exezk_anhaengen('Motorola 68000');
          5:exezk_anhaengen('Motorola 88000');
          6:exezk_anhaengen('i486+');
          7:exezk_anhaengen('i860');
          8:exezk_anhaengen('MIPS R3000_BE');
          9:exezk_anhaengen('Amdahl');
        $0a:exezk_anhaengen('MIPS R3000_LE');
        $0b:exezk_anhaengen('RS6000');

        $0f:exezk_anhaengen('PA-RISC');
        $10:exezk_anhaengen('nCUBE');
        $11:exezk_anhaengen('Fujitsu VPP500');
        $12:exezk_anhaengen('SPARC32PLUS');

        $14:exezk_anhaengen('power-pc'); (* OS/2 ppc *) (* PowerPC or cisco 4500 *)
        $15:exezk_anhaengen('cisco 7500');
        $16:exezk_anhaengen('IBM S/390');

        $18:exezk_anhaengen('cisco SVIP');
        $19:exezk_anhaengen('cisco 7200');

        $24:exezk_anhaengen('NEC V800 or cisco 12000');
        $25:exezk_anhaengen('Fujitsu FR20');
        $26:exezk_anhaengen('TRW RH-32');
        $27:exezk_anhaengen('Motorola RCE');
        $28:exezk_anhaengen('Advanced RISC Machines ARM');
        $29:exezk_anhaengen('Alpha');
        $2a:exezk_anhaengen('Hitachi SH');
        $2b:exezk_anhaengen('SPARC V9');
        $2c:exezk_anhaengen('Siemens Tricore Embedded Processor');
        $2d:exezk_anhaengen('Argonaut RISC Core');
        $2e:exezk_anhaengen('Hitachi H8/300');
        $2f:exezk_anhaengen('Hitachi H8/300H');
        $30:exezk_anhaengen('Hitachi H8S');
        $31:exezk_anhaengen('Hitachi H8/500');
        $32:exezk_anhaengen('IA-64');
        $33:exezk_anhaengen('Stanford MIPS-X');
        $34:exezk_anhaengen('Motorola Coldfire');
        $35:exezk_anhaengen('Motorola M68HC12');
        $3e:exezk_anhaengen('AMD x86-64');
        $4b:exezk_anhaengen('Digital VAX');
        $61:exezk_anhaengen('NatSemi 32k');
        else
            exezk_anhaengen('??');
        end;

        if p.d[8]<>0 then
          begin
            exezk_anhaengen(', ');
            exezk_anhaengen(puffer_zu_zk_e(p.d[8],#0,8));
          end
        else
          case p.d[7] of
            0:(*exezk_anhaengen(', SYSV'/'unspecified')*);
            1:exezk_anhaengen(', HP-UX');
            2:exezk_anhaengen(', NetBSD');
            3:exezk_anhaengen(', GNU/Linux');
            4:exezk_anhaengen(', GNU/Hurd');
            5:exezk_anhaengen(', 86Open');
            6:exezk_anhaengen(', Solaris');
            7:exezk_anhaengen(', Monterey');
            8:exezk_anhaengen(', IRIX');
            9:exezk_anhaengen(', FreeBSD');
           10:exezk_anhaengen(', Tru64');
           11:exezk_anhaengen(', Novell Modesto');
           12:exezk_anhaengen(', OpenBSD');
           97:exezk_anhaengen(', ARM');
          255:exezk_anhaengen(', embedded');
          end;


        ausschrift((*textz_dat__Ausfuehrbare_Datei^+' '+*)'ELF '+exezk,signatur);



        if  bytesuche(d[4],#$01#$01#$01) (* 32 Bit, Intel, Version 1 *)
        and bytesuche(d[$10],#$02#$00#$03#$00) (* exe, Intel Architektur *)
         then
          elf_386(p);

        if einzel_laenge>100 then
          if bytesuche__datei_lesen(analyseoff+einzel_laenge-$1a,'BEOS:TYPE') then
            beos_information;
      end;

  end;

procedure handmade_software_raw(const p:puffertyp);
  var
    raw_farben          :longint;
  begin
    if m_word(p.d[10])<=0 then
      raw_farben:=16777216
    else
      raw_farben:=m_word(p.d[12]);

    bild_format_filter('RAW / Handmade Software, Inc',
                       m_word(p.d[ 8]),
                       m_word(p.d[10]),
                       raw_farben,-1,false,true,anstrich);
  end;

procedure eps_vorspann(const p:puffertyp);
  var
    o_analyseoff,
    o_einzel_laenge     :dateigroessetyp;
    dat_tmp_puffer      :puffertyp;
  begin
    ausschrift('EPS-'+textz_datx__Vorspann^,musik_bild);
    o_analyseoff:=analyseoff;
    o_einzel_laenge:=einzel_laenge;

    (* TIFF ... *)
    ausschrift_leerzeile;
    IncDGT(analyseoff,longint_z(@p.d[$14])^);
    einzel_laenge:=longint_z(@p.d[$18])^;
    (* Fehler bei GWS EPS *)
    if einzel_laenge=8 then
      einzel_laenge:=o_einzel_laenge-analyseoff;
    datei_lesen(dat_tmp_puffer,analyseoff,512);
    hersteller_gefunden:=false;
    dat_signaturen(dat_tmp_puffer);

    analyseoff:=o_analyseoff;
    einzel_laenge:=o_einzel_laenge;

    (* PS ... *)
    ausschrift_leerzeile;
    IncDGT(analyseoff,longint_z(@p.d[$04])^);
    einzel_laenge:=longint_z(@p.d[$08])^;
    (* Fehler bei GWS EPS *)
    if einzel_laenge=8 then
      einzel_laenge:=o_einzel_laenge-analyseoff;
    datei_lesen(dat_tmp_puffer,analyseoff,512);
    hersteller_gefunden:=false;
    dat_signaturen(dat_tmp_puffer);


    hersteller_gefunden:=true;
    analyseoff:=o_analyseoff;
    einzel_laenge:=o_einzel_laenge;
  end;

procedure palmpilot(const p:puffertyp);
  var
    i:word_norm;
  begin
    exezk:=puffer_zu_zk_e(p.d[$00],#0,16);
    if (Length(exezk)<=2) or (not ist_ohne_steuerzeichen(exezk)) then
      Exit;

    for i:=Length(exezk) to $0f do
      if p.d[i]<>0 then
        Exit;

    for i:=$3c to $43 do
      if not (Chr(p.d[i]) in ['A'..'Z','a'..'z','0'..'9']) then
        Exit;

    ausschrift('PalmPilot '+in_doppelten_anfuerungszeichen(exezk),beschreibung);

    exezk:=puffer_zu_zk_e(p.d[$3c],#0,4)+':'+puffer_zu_zk_e(p.d[$40],#0,4);
    if Pos('appl',exezk)=1 then
      ausschrift(exezk,compiler)
    else
      ausschrift(exezk,normal);


  end;

procedure softimage_pic(const p:puffertyp);
  begin
    if not bytesuche(p.d[$58],'PICT') then Exit;

    case p.d[$58+$12] of
      2: exezk:=' (RLE)';
    else exezk:='';
    end;

    bild_format_filter('Softimage'+exezk,
                           m_word(p.d[$58+4]),
                           m_word(p.d[$58+6]),
                           -1,24,false,true,anstrich);
  end;

procedure ATARI_TOS_prg(const p:puffertyp);
  var
    o,l1:longint;
  begin
    l1:=$1c+m_longint(p.d[2])+m_longint(p.d[6]);
    if l1>einzel_laenge then Exit;
    ausschrift('ATARI/TOS',compiler); (* upx: mint *)
    if p.d[$1c]=$60 then (* Sprung *)
      begin
        o:=puffer_pos_suche(p,'>>',400);
        if o<>nicht_gefunden then
          begin
            exezk:=puffer_zu_zk_e(p.d[o],#0,p.d[$1c+1]);
            while Pos('>' ,exezk)<>0 do Delete(exezk,Pos('>' ,exezk),Length('>'));
            while Pos('<' ,exezk)<>0 do Delete(exezk,Pos('<' ,exezk),Length('<'));
            while Pos('  ',exezk)<>0 do Delete(exezk,Pos('  ',exezk),Length(' '));
            exezk:=leer_filter(exezk);
            ausschrift_x(exezk,beschreibung,vorne);
          end;
      end;
  end;

procedure rdoff(const p:puffertyp);
  var
    o:longint;
    w1:word_norm;
  begin
    case p.d[5] of
      $01..$09:
        exezk:=Chr(Ord('0') or p.d[5])+',little-endian';
      Ord('1')..Ord('9'):
        exezk:=Chr(p.d[5])+',big-endian';
    end;
    ausschrift('RDOFF / Julian Hall ['+exezk+']',compiler);
    case p.d[5] and $0f of
      1:
        begin
          o:=6;
          for w1:=1 to 3 do (* header/.text/.data *)
            if p.d[5]=1 then
              Inc(o,4+m_longint__datei_lesen(analyseoff+o))
            else
              Inc(o,4+x_longint__datei_lesen(analyseoff+o));
          einzel_laenge:=o;
        end;
      2:
        begin
          o:=6;
          if p.d[5]=2 then
            Inc(o,4+m_longint__datei_lesen(analyseoff+o))
          else
            Inc(o,4+x_longint__datei_lesen(analyseoff+o));
          einzel_laenge:=o;
        end;
    end;
  end;

procedure FlexibleImageTransportSystem;
  var
    o,e                 :longint;
    x,y,b               :longint;
    l                   :longint;
    lp                  :longint;

  procedure werte(const s:string;var i:longint);
    begin
      if bytesuche(exezk[1],s) then
        i:=DGT_zu_longint(ziffer(10,leer_filter(Copy(exezk,11,80-11+1))));
    end;

  begin
    o:=0;
    e:=DGT_zu_longint(MinDGT(einzel_laenge,2880));
    x:=-1;
    y:=-1;
    b:=-1;
    lp:=1;
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_l(analyseoff+o,80);
        Inc(o,80);
        if exezk[6]<>' ' then
          begin
            werte('NAXIS???=',l);
            if l>0 then
              begin
                lp:=lp*l;
                l:=-1;
              end;
          end;
        werte('NAXIS1  = ',x);
        werte('NAXIS2  = ',y);
        werte('BITPIX  = ',b);
        if bytesuche(exezk,'COMMENT ') then
          ausschrift_x(Copy(exezk,9,80-9+1),beschreibung,absatz);
        if Pos('END',exezk)=1 then
          Break;
      end;

    if (x>1) and (y>1) and (b>1) then
      bild_format_filter('Flexible Image Transport System',x,y,-1,b,false,true,anstrich);

    if (lp>1) and (b>1) then
      einzel_laenge:=2880+(lp*b) shr 3;
  end;

procedure probiere_sfv;
  var
    o                   :longint;
    w1,w2,anzahl        :word_norm;

  begin
    o:=0;
    anzahl:=0;
    while o<einzel_laenge do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(analyseoff+o);
        Inc(o,Length(exezk)+1);
        if exezk='' then Continue;
        if exezk[1]=';' then Continue;
        if not ist_ohne_steuerzeichen_nicht_so_streng(exezk) then Exit;
        w1:=Pos(' ',exezk);
        if w1=0 then Exit;
        w2:=Pos('.',exezk);
        if (w2=0) or (w2>w1) then Exit;
        Delete(exezk,1,w1);
        if Length(exezk)<>8 then Exit;
        for w1:=0 to 7 do
          if not (exezk[Length(exezk)-w1] in ['0'..'9','A'..'F','a'..'f']) then
            Exit;
        Inc(anzahl);
      end;
    if anzahl>=1 then
      ausschrift('Simple File Verificator: '+str0(anzahl),normal);
  end;

procedure anzeige_sdw_reg;
  var
    f1:dateigroessetyp;
  begin
    f1:=datei_pos_suche(analyseoff+einzel_laenge,analyseoff+einzel_laenge-MinDGT(100,einzel_laenge),#$0d#$0a'[');
    if f1<>nicht_gefunden then
      ausschrift_x(in_doppelten_anfuerungszeichen(datei_lesen__zu_zk_e(f1+3,']',
        DGT_zu_longint(analyseoff+einzel_laenge-f1))),beschreibung,absatz);
  end;

procedure country_sys_anzeige(const p:puffertyp);
  var
    country,
    anzahl              :word_norm;
    o                   :longint;
    dien_puffer         :puffertyp;
  begin
    if not langformat then Exit;

    (* showctry.cmd,country.zip .. *)
    o:=x_longint__datei_lesen(analyseoff+$13); (* meist $17 *)
    anzahl:=x_word__datei_lesen(analyseoff+o);
    Inc(o,2);
    exezk:='';
    while anzahl>0 do
      begin
        Dec(anzahl);
        datei_lesen(dien_puffer,analyseoff+o,14);
        Inc(o,14);
        if word_z(@dien_puffer.d[0])^<>$000c then
          Continue; (* letzter Block bei PCDOS *)

        if (word_z(@dien_puffer.d[2])^<>country) and (exezk<>'') then
          begin
            ausschrift_x(exezk,beschreibung,absatz);
            exezk:='';
          end;

        country:=word_z(@dien_puffer.d[2])^;

        if Length(exezk)>62 then
          begin
            exezk_anhaengen(',');
            ausschrift_x(exezk,beschreibung,absatz);
            exezk:='                '+Str_(word_z(@dien_puffer.d[4])^,4);
            Continue;
          end;

        if exezk='' then
          exezk:='Country '+Str_(country,5)+':  '+Str_(word_z(@dien_puffer.d[4])^,4)
        else
          exezk_anhaengen(', '+Str_(word_z(@dien_puffer.d[4])^,4));
      end;
    if exezk<>'' then
      ausschrift_x(exezk,beschreibung,absatz);

  end;

procedure drdos_country_sys_anzeige(copyr:word_norm);
  var
    p                   :puffertyp;
    o                   :longint;
    country             :word_norm;
  begin
    ausschrift('DR DOS '+textz_Landesinformationen^,bibliothek);
    datei_lesen(p,analyseoff+copyr,512);
    exezk:=puffer_zu_zk_e(p.d[0],#0,80);
    exezk:=leer_filter(exezk);
    ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
    if not langformat then Exit;

    o:=$80;
    exezk:='';
    repeat
      datei_lesen(p,analyseoff+o,$14);
      Inc(o,$14);
      if word_z(@p.d[0])^=0 then Break;

      if (word_z(@p.d[0])^<>country) and (exezk<>'') then
        begin
          ausschrift_x(exezk,beschreibung,absatz);
          exezk:='';
        end;

      country:=word_z(@p.d[0])^;

      if Length(exezk)>62 then
        begin
          exezk_anhaengen(',');
          ausschrift_x(exezk,beschreibung,absatz);
          exezk:='                '+Str_(word_z(@p.d[2])^,4);
          Continue;
        end;

      if exezk='' then
        exezk:='Country '+Str_(country,5)+':  '+Str_(word_z(@p.d[2])^,4)
      else
        exezk_anhaengen(', '+Str_(word_z(@p.d[2])^,4));

    until o>=einzel_laenge;

    if exezk<>'' then
      ausschrift_x(exezk,beschreibung,absatz);
  end;

procedure keyboard_sys_anzeige;
  var
    dp                  :dateigroessetyp;
    o                   :longint;
    i,
    cpc,
    anzahl              :word_norm;
    p                   :puffertyp;
  begin
    if not langformat then Exit;

    o:=$1a;
    dp:=0;
    anzahl:=x_word__datei_lesen(analyseoff+o);
    Inc(o,2);
    while anzahl>0 do
      begin
        Dec(anzahl);
        datei_lesen(p,analyseoff+o,2+4);
        Inc(o,2+4);
        exezk:='Keyb '+puffer_zu_zk_l(p.d[0],2)+': ';
        datei_lesen(p,analyseoff+longint_z(@p.d[2])^,512);
        if bytesuche(p.d[2],#0#0) then
          cpc:=Min(p.d[8],500 div 6) (* PC DOS 3.30 *)
        else
          cpc:=Min(p.d[9],500 div 6); (* PC DOS 7? *)

        for i:=1 to cpc do
           begin
             if i<>1 then
               exezk_anhaengen(', ');
             exezk:=exezk+str0(word_z(@p.d[10+(i-1)*6])^);
           end;
        ausschrift(exezk,beschreibung);
      end;

    dp:=einzel_laenge-1;
    if bytesuche__datei_lesen(analyseoff+dp,#0) then
      DecDGT(dp,1);
    (* rÅckwÑrts suchen *)
    exezk:='';
    repeat
      datei_lesen(p,analyseoff+dp,1);
      case p.d[0] of
        0:break;
        1..9,11..12,14..25:Exit;
        26..31:DecDGT(dp,1);
      else
        exezk:=Chr(p.d[0])+exezk;
        DecDGT(dp,1);
      end;
    until ((einzel_laenge-dp)>255) or (dp<=0);

    if Length(exezk)>10 then
      ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
  end;

procedure linux_software_map;
  var
    o,e                 :dateigroessetyp;
    z2                  :string;
  begin
    (* freedos \disksets\*.lsm *)
    ausschrift('Linux Software Map',bibliothek);
    if not langformat then Exit;

    o:=analyseoff;
    e:=analyseoff+MinDGT(einzel_laenge,8000);
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        tabexpand(exezk);
        exezk:=leer_filter(exezk);
        if exezk='End' then Break;
        if (Pos('Author:',exezk)=1)
        or (Pos('Description:',exezk)=1)
         then
          begin
            Delete(exezk,1,Pos(':',exezk));
            exezk:=leer_filter(exezk);
            while o<e do
              begin
                z2:=datei_lesen__zu_zk_zeilenende(o);
                if z2='' then Break;
                if not (z2[1] in [' ',^I]) then Break;
                IncDGT(o,Length(z2));
                weiter_bis_zum_naechsten_zeilenanfang(o);
                tabexpand(z2);
                exezk_anhaengen(^M^J);
                exezk_anhaengen(leer_filter(z2));
              end;
            ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
          end;
      end;
  end;

procedure hobbes_upload_text;
  var
    o,e:dateigroessetyp;

  procedure anzeige(const s0:string);
    begin
      while o<e do
        begin
          exezk:=datei_lesen__zu_zk_zeilenende(o);
          IncDGT(o,Length(exezk));
          weiter_bis_zum_naechsten_zeilenanfang(o);
          if Pos(s0,exezk)<>0 then
            begin
              Delete(exezk,1,Pos(s0,exezk)+Length(s0));
              exezk:=leer_filter(exezk);
              if exezk<>'' then
                ausschrift_x((*s0+#9+*)exezk,beschreibung,absatz);
              Break;
            end;
        end;
    end;
  begin
    o:=analyseoff;
    e:=o+MinDGT(8000,einzel_laenge);
    ausschrift('Hobbes upload description',packer_dat);
    anzeige('Archive Filename:');
    anzeige('Short Description:');
    anzeige('Your name:');

  end;

procedure versuche_lizenz_readme(const p:puffertyp);
  var
    w1,w2               :word_norm;
    p2                  :puffertyp;
    o                   :dateigroessetyp;
  begin
    w1:=0;
    while (w1<128) and (p.d[w1]=Ord('=')) do Inc(w1);
    if (w1<70) or (w1>90) then Exit;

    o:=analyseoff+w1;
    weiter_bis_zum_naechsten_zeilenanfang(o);
    exezk:=datei_lesen__zu_zk_zeilenende(o);
    IncDGT(o,Length(exezk));
    weiter_bis_zum_naechsten_zeilenanfang(o);
    datei_lesen(p2,o,512);
    for w2:=0 to w1-1 do
      if p2.d[w2]<>Ord('=') then Exit;
    exezk:=leer_filter(exezk);
    repeat
      w1:=Pos('   ',exezk);
      if w1=0 then Break;
      Delete(exezk,w1,1);
    until false;

    if Length(exezk)>72 then
      ausschrift_x(exezk,beschreibung,vorne)
    else
      ausschrift(exezk,beschreibung);
  end;

procedure versuche_adaptec_readme(const p:puffertyp);
  var
    w1,w2,w3:word_norm;
  begin
    w1:=0;
    while (w1<80) and (p.d[w1]<>$20) do Inc(w1);
    while (w1<80) and (p.d[w1]=$20) do Inc(w1);
    w2:=w1;
    while (w2<160) and (p.d[w2] in [Ord('='),Ord('-')]) do Inc(w2);
    w3:=w2;
    while (w3<160) and (p.d[w3] in [$0d,$0a]) do Inc(w3);
    if w3<30 then Exit;
    exezk:=leer_filter(puffer_zu_zk_zeilenende(p.d[w3],128));

    if  (Length(exezk)  <>w2-w1)
    and (Length(exezk)+1<>w2-w1) then Exit;

    if Length(exezk)>72 then
      ausschrift_x(exezk,beschreibung,vorne)
    else
      ausschrift(exezk,beschreibung);
  end;

procedure extproc(const p:puffertyp);
  begin
    exezk:=leer_filter(puffer_zu_zk_zeilenende(p.d[8],255));
    ausschrift(textz_dien__extproc^+in_doppelten_anfuerungszeichen(exezk),compiler);
  end;

procedure probiere_readme_ueberschrift(const p:puffertyp;c:char);
  var
    o,i,w1              :word_norm;
    absatz1             :word_norm;
  begin
    o:=0;
    (* README.IBM *)
    if bytesuche(p.d[0],#$0d#$0a) then o:=2;
    i:=o;
    suche_zeilenanfang(p,o);
    exezk:=puffer_zu_zk_zeilenende(p.d[o],255);
    tabexpand(exezk);
    if (Length(exezk)<{70}10)
    or (Length(exezk)>90) then Exit;
    absatz1:=0;
    while (absatz1+1<Length(exezk)) and (exezk[absatz1+1]=' ') do
      Inc(absatz1);
    for w1:=Length(exezk) downto absatz1+1 do
      if exezk[w1]<>c then Exit;

    exezk:=puffer_zu_zk_zeilenende(p.d[i],255);
    tabexpand(exezk);
    if Length(exezk)<absatz1+1 then Exit;
    for w1:=1 to absatz1 do
      if exezk[w1]<>' ' then Exit;
    exezk:=leer_filter(exezk);

    if (Length(exezk)<7) and (absatz1<10) then Exit;

    repeat
      w1:=Pos('   ',exezk);
      if w1=0 then Break;
      Delete(exezk,w1,1);
    until false;

    if Length(exezk)>72 then
      ausschrift_x(exezk,beschreibung,vorne)
    else
      ausschrift(exezk,beschreibung);
  end;

(* Mr2S_English.txt *)
procedure probiere_readme_zwischenzeile(c:char);
  var
    o                   :dateigroessetyp;
    i                   :word_norm;
    s1                  :string;
  begin
    o:=analyseoff;
    s1:=datei_lesen__zu_zk_zeilenende(o);
    if (Length(s1)<60) or (Length(s1)>90) then Exit;
    for i:=1 to Length(s1) do if s1[i]<>c then Exit;
    weiter_bis_zum_naechsten_zeilenanfang(o);
    exezk:=leer_filter(datei_lesen__zu_zk_zeilenende(o));
    weiter_bis_zum_naechsten_zeilenanfang(o);
    if datei_lesen__zu_zk_zeilenende(o)<>s1 then Exit;

    (* pmodew.doc/faq *)
    while (exezk<>'') and (exezk[1]=c) do Delete(exezk,1,1);
    while (exezk<>'') and (exezk[Length(exezk)]=c) do Delete(exezk,Length(exezk),1);
    exezk:=leer_filter(exezk);

    ausschrift(exezk,beschreibung);
  end;

(* known_bugs.txt *)
procedure probiere_readme_ueberschrift_unterstrichen(const p:puffertyp;c:char);
  var
    o                   :word_norm;
    i                   :word_norm;
    p2                  :puffertyp;
  begin
    exezk:=puffer_zu_zk_zeilenende(p.d[0],255);
    if Length(exezk)<5 then Exit;
    o:=Length(exezk);
    suche_zeilenanfang(p,o);
    datei_lesen(p2,analyseoff+o,512);
    for i:=1-1 to o-2-1 do
      if p2.d[i]<>Ord(c) then
        Exit;
    if not bytesuche(p2.d[o-2],#$0d#$0a#$0d#$0a) then
      Exit;

    ausschrift(exezk,beschreibung);
  end;

procedure probiere_readme_bootmenu_txt(const p:puffertyp);
  var
    i,o                 :word_norm;
  begin
    exezk:=puffer_zu_zk_zeilenende(p.d[0],255);
    if (exezk[1]<>'*') or (exezk[Length(exezk)]<>'*') then Exit;
    for i:=2 to Length(exezk)-1 do
      if exezk[i]<>'_' then Exit;
    i:=Length(exezk);
    if (i<10) or (i>90) then Exit;
    o:=0;
    suche_zeilenanfang(p,o);
    exezk:=puffer_zu_zk_zeilenende(p.d[o],255);
    tabexpand(exezk);
    if (Length(exezk)<>i) or (exezk[1]<>'*') or (exezk[Length(exezk)]<>'*') then Exit;
    ausschrift(leer_filter(Copy(exezk,2,Length(exezk)-2)),beschreibung);
  end;

procedure versuche_tmf;
  var
    o,e:dateigroessetyp;
  begin
    o:=analyseoff;
    e:=o+MinDGT(einzel_laenge,4000);
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        exezk:=leer_filter(exezk);
        if exezk='' then Continue;
        if exezk[1]=';' then Continue;
        if bytesuche(exezk[1],'<--???????-->:') then
          ausschrift('text message file / Ulrich Mîller '+in_doppelten_anfuerungszeichen(Copy(exezk,4,3)),bibliothek);
        Break;
      end;
  end;

procedure bootwiz_cfg(const o0,laenge:dateigroessetyp);

  procedure pw(const slw:string);
    var
      cset              :set of byte;

    function versuche(w:word_norm):boolean;

      function gut(w:word_norm;c1:string):boolean;
        begin
          if (Lo(w) in cset) and (Hi(w) in cset) then
            begin
              gut:=true;
              exezk_anhaengen(in_doppelten_anfuerungszeichen(c1+Chr(Hi(w))+Chr(Lo(w))));
            end
          else
          if (c1='') and (Lo(w) in cset) and (Hi(w)=0) then
            begin
              gut:=true;
              exezk_anhaengen(in_doppelten_anfuerungszeichen(Chr(Lo(w))));
            end
          else
            gut:=false;
        end;

      var
        gefunden        :boolean;
        i               :word_norm;
      begin
        gefunden:=false;
        if gut(w,'') then
          gefunden:=true;

        if not gefunden then
          for i:=0 to $f do
            if gut(w xor ($3653+i*$1021) and $ffff,Chr(Ord('0')+i)) then
              begin
                gefunden:=true;
                Break;
              end;

        if not gefunden then
          for i:=0 to $f do
            if gut(w xor ($48c4+i*$1021) and $ffff,Chr(Ord('@')+i)) then
              begin
                gefunden:=true;
                Break;
              end;

        if not gefunden then
          for i:=0 to $f do
            if gut(w xor ($5EB7+i*$1021) and $ffff,Chr(Ord('P')+i)) then
              begin
                gefunden:=true;
                Break;
              end;

        if gefunden then
          ausschrift_x(exezk,beschreibung,absatz);

        versuche:=gefunden;
      end;

    var
      w:word_norm;

    begin
      if Pos(slw,exezk)<>1 then Exit;

      w:=DGT_zu_longint(ziffer(10,leer_filter(Copy(exezk,Length(slw),255))));
      SetLength(exezk,Length(slw));

      cset:=[Ord('0')..Ord('9'),ord('a')..Ord('z')];
      if versuche(w) then Exit;

      cset:=cset+[Ord('A')..Ord('Z')];
      if versuche(w) then Exit;

      cset:=cset+[Ord(' ')..$7f];
      if versuche(w) then Exit;

      cset:=cset+[Ord(' ')..$ff];
      if versuche(w) then Exit;

      exezk_anhaengen('?');
      ausschrift_x(exezk,beschreibung,absatz);
    end;

  var
    o,e                 :dateigroessetyp;

  begin
    ausschrift('Acronis OS Selector',normal);
    o:=o0;
    e:=o0+MinDGT(laenge,9999);
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        pw('ADMPASS ');
        pw('PASSWORD ');
      end;
  end;

procedure pascal_quelle;
  var
    o,e                 :dateigroessetyp;
    kommentar           :(kommentar_kein,kommentar_schweif,kommentar_klst);
    w1                  :word_norm;
    gr                  :string;
  procedure beschreibe(const ergebnis:string);
    begin
      (*Delete(exezk,1,Length(schluesselwort));*)
      w1:=Pos(' ',exezk);
      Delete(exezk,1,w1);

      w1:=Pos('{',exezk);
      if w1<>0 then SetLength(exezk,w1-1);
      w1:=Pos('(*',exezk);
      if w1<>0 then SetLength(exezk,w1-1);
      w1:=Pos('//',exezk);
      if w1<>0 then SetLength(exezk,w1-1);

      exezk:=leer_filter(exezk);
      if (exezk='')
      or (Pos(';',exezk)<>Length(exezk)) then
        Exit;

      if Pos('(',exezk)<>0 then
        SetLength(exezk,Pos('(',exezk)-1);
      if Pos(';',exezk)<>0 then
        SetLength(exezk,Pos(';',exezk)-1);
      if Pos(' ',exezk)<>0 then
        SetLength(exezk,Pos(' ',exezk)-1);
      if Pos(#9,exezk)<>0 then
        SetLength(exezk,Pos(#9,exezk)-1);

      exezk:=leer_filter(exezk);
      ausschrift(ergebnis+in_doppelten_anfuerungszeichen(exezk),signatur);
    end;
  begin
    o:=analyseoff;
    e:=o+MinDGT(einzel_laenge,2000);
    kommentar:=kommentar_kein;
    repeat
      exezk:=datei_lesen__zu_zk_zeilenende(o);
      IncDGT(o,Length(exezk));
      weiter_bis_zum_naechsten_zeilenanfang(o);
      repeat
        while (exezk<>'') and (exezk[1] in [' ',#9]) do Delete(exezk,1,1);
        if exezk='' then Break;

        case kommentar of
          kommentar_kein:
            begin
              if Pos('//',exezk)=1 then
                exezk:=''
              else
              if Pos('{',exezk)=1 then
                begin
                  kommentar:=kommentar_schweif;
                  Delete(exezk,1,1);
                end
              else
              if Pos('(*',exezk)=1 then
                begin
                  kommentar:=kommentar_klst;
                  Delete(exezk,1,2);
                end
              else
                begin
                  gr:=gross(exezk);
                  if Pos('UNIT ',gr)=1 then
                    beschreibe('Pascal Unit ')
                  else
                  if Pos('LIBRARY ',gr)=1 then
                    beschreibe('Pascal Library ')
                  else
                  if Pos('PROGRAM ',gr)=1 then
                    beschreibe('Pascal '+textz_datx__Programm^+' ');
                  Exit;
                end
            end;
          kommentar_schweif:
            begin
              if Pos('}',exezk)=1 then
                kommentar:=kommentar_kein;
              Delete(exezk,1,1);
            end;
          kommentar_klst:
            begin
              if Pos('*)',exezk)=1 then
                begin
                  kommentar:=kommentar_kein;
                  Delete(exezk,1,2);
                end
              else
                Delete(exezk,1,1);
            end;
        end; (* case *)
      until false; (* oder exezk='' *)
    until o>=e;
  end;

procedure versuche_dsp_oder_ddp_datei;
  var
    o,e                 :dateigroessetyp;
  begin
    if not textdatei then Exit;

    o:=analyseoff;
    e:=o+MinDGT(9999,einzel_laenge);
    repeat
      exezk:=datei_lesen__zu_zk_zeilenende(o);
      IncDGT(o,Length(exezk));
      weiter_bis_zum_naechsten_zeilenanfang(o);
      exezk:=gross(leer_filter(exezk));

      if Pos(':',exezk)<>1 then Continue;

      if exezk=':TITLE' then
        begin
          ausschrift('OS/2 Display Install (DSP), Device Driver Profile (DDP)',bibliothek);
          exezk:=leer_filter(datei_lesen__zu_zk_zeilenende(o));
          ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
          Exit;
        end;

      (* :TITLE, :CONFIG, :FILES, :PRESENCECHECK, :OS2INI *)
      if (Length(exezk)>20) or (Length(exezk)<5) then Break;

    until o>=e;
  end;

(* name,..,(def),..>linker definition file (program)
   library,..(def) ... > linker definition file (dll)
     aber wenn "imports" akber keine "exports" oder segments/stub/code/protmode dann implib
   physical,...(def)...> linker (pdd)
   virtual... (vdd)
   code
   data
   stack
   heapsize
   exetype.
   ; kommentar
   *)

procedure versuche_def;
  var
    o,e                 :dateigroessetyp;
    gr                  :string;
    zaehler_zeiger      :longint_z;
    kommentarzeilen     :longint;
    modultyp            :(modultyp_unbekannt,modultyp_dll,modultyp_pdd,modultyp_vdd,modultyp_exe);
    leerzeichen         :boolean;
    exetype_vorhanden   :boolean;
    exetype_zk          :string;
    protmode_vorhanden  :boolean;
    heapsize_vorhanden  :boolean;
    stacksize_vorhanden :boolean;
    stub_vorhanden      :boolean;
    description_vorhanden:boolean;
    description         :string;
    segments_vorhanden  :boolean;
    imports_vorhanden   :boolean;
    imports_zaehler     :longint;
    exports_vorhanden   :boolean;
    exports_zaehler     :longint;
    code_oder_data_zaehler:longint;
    description_offen   :boolean;
  begin
    zaehler_zeiger:=nil;
    kommentarzeilen:=0;
    modultyp:=modultyp_unbekannt;
    exetype_vorhanden:=false;
    protmode_vorhanden:=false;
    heapsize_vorhanden:=false;
    stacksize_vorhanden:=false;
    stub_vorhanden:=false;
    description_vorhanden:=false;
    segments_vorhanden:=false;
    imports_vorhanden:=false;
    imports_zaehler:=0;
    exports_vorhanden:=false;
    exports_zaehler:=0;
    description_offen:=false;
    code_oder_data_zaehler:=0;

    o:=analyseoff;
    e:=o+MinDGT(9999,einzel_laenge);
    repeat
      exezk:=datei_lesen__zu_zk_zeilenende(o);
      IncDGT(o,Length(exezk));
      weiter_bis_zum_naechsten_zeilenanfang(o);
      if Length(exezk)>200 then Exit;
      if exezk='' then Continue;

      tabexpand(exezk);
      leerzeichen:=exezk[1]=' ';
      exezk:=leer_filter(exezk);

      if description_offen then
        begin
          description:=description+#$0d#$0a+exezk;
          description_offen:=
                (Pos(#39,description)=1)
            and (description[Length(description)]<>#39)
            and (Length(description)>Length(#39));
          Continue;
        end;

      if Pos(';',exezk)=1 then
        begin
          Inc(kommentarzeilen);
          Continue;
        end;
      if not leerzeichen then
        zaehler_zeiger:=nil;
      gr:=gross(exezk);
      if (Pos('LIBRARY ',gr)=1) or ('LIBRARY'=gr) then
        begin
          if modultyp<>modultyp_unbekannt then Exit;
          modultyp:=modultyp_dll;
        end
      else
      if (Pos('PHYSICAL DEVICE ',gr)=1) or ('PHYSICAL DEVICE'=gr) then
        begin
          if modultyp<>modultyp_unbekannt then Exit;
          modultyp:=modultyp_pdd;
        end
      else
      if (Pos('VIRTUAL DEVICE ',gr)=1) or ('VIRTUAL DEVICE'=gr) then
        begin
          if modultyp<>modultyp_unbekannt then Exit;
          modultyp:=modultyp_vdd;
        end
      else
      if Pos('NAME ',gr)=1 then
        begin
          if modultyp<>modultyp_unbekannt then Exit;
          modultyp:=modultyp_exe;
        end
      else
      if Pos('EXETYPE ',gr)=1 then
        begin
          if exetype_vorhanden then Exit;
          exetype_zk:=leer_filter(Copy(exezk,Length('EXETYPE ')+1,255));
          exetype_vorhanden:=true;
        end
      else
      if Pos('PROTMODE',gr)=1 then
        begin
          if protmode_vorhanden then Exit;
          protmode_vorhanden:=true;
        end
      else
      if Pos('HEAPSIZE ',gr)=1 then
        begin
          if heapsize_vorhanden then Exit;
          (* PrÅfung ob Zahl? *)
          heapsize_vorhanden:=true;
        end
      else
      if Pos('STACKSIZE ',gr)=1 then
        begin
          if stacksize_vorhanden then Exit;
          (* PrÅfung ob Zahl? *)
          stacksize_vorhanden:=true;
        end
      else
      if Pos('STUB ',gr)=1 then
        begin
          if stub_vorhanden then Exit;
          stub_vorhanden:=true;
        end
      else
      if Pos('DESCRIPTION ',gr)=1 then
        begin
          if description_vorhanden then Exit;
          description:=leer_filter(Copy(exezk,Length('DESCRIPTION ')+1,255));
          description_vorhanden:=true;
          if (Pos(#39,description)=1)
          and (description[Length(description)]<>#39)
          and (Length(description)>Length(#39)) then
            description_offen:=true;
        end
      else
      if Pos('SEGMENTS',gr)=1 then
        begin
          if segments_vorhanden then Exit;
          segments_vorhanden:=true;
        end
      else
      if Pos('IMPORTS',gr)=1 then
        begin
          if imports_vorhanden then Exit;
          imports_vorhanden:=true;
          zaehler_zeiger:=Addr(imports_zaehler);
        end
      else
      if Pos('EXPORTS',gr)=1 then
        begin
          if exports_vorhanden then Exit;
          exports_vorhanden:=true;
          zaehler_zeiger:=Addr(exports_zaehler);
        end
      else
      if (Pos('CODE ',gr)=1) or ('CODE'=gr) then
        begin
          zaehler_zeiger:=Addr(code_oder_data_zaehler);
        end
      else
      if (Pos('DATA ',gr)=1) or ('DATA'=gr) then
        begin
          zaehler_zeiger:=Addr(code_oder_data_zaehler);
        end
      else
        begin
           if Assigned(zaehler_zeiger) then
             Inc(zaehler_zeiger^)
           else
           if Pos(' CLASS ',gr)<>0 then
           else
             Exit;
        end;
    until o>=e;

    if not (   description_vorhanden
            or imports_vorhanden
            or exports_vorhanden
            or (code_oder_data_zaehler<>0)
            or segments_vorhanden
            or stub_vorhanden
            or (modultyp<>modultyp_unbekannt)) then Exit;

    case modultyp of
      modultyp_unbekannt:
        exezk:='linker definition file';

      modultyp_dll:
        begin
          exezk:='linker definition file for dll or driver';
          if imports_vorhanden and (imports_zaehler>0) then
            exezk_anhaengen(' ('+str0(imports_zaehler)+' imports)');
          if exports_vorhanden and (exports_zaehler>0) then
            exezk_anhaengen(' ('+str0(exports_zaehler)+' exports)');
          if (not (imports_vorhanden or segments_vorhanden or stub_vorhanden or heapsize_vorhanden or stacksize_vorhanden))
          and exports_vorhanden
          and (exports_zaehler>0) then
            exezk:='import library definition ('+str0(exports_zaehler)+')';
        end;

      modultyp_pdd:
        exezk:='linker definition file for physical device driver';

      modultyp_vdd:
        exezk:='linker definition file for virtual device driver';

      modultyp_exe:
        exezk:='linker definition file for program';
    end;
    ausschrift(exezk,compiler);

    if description_vorhanden then
      begin
        if (description<>'')
        and (description[1]=description[Length(description)])
        and (description[1] in ['''','"']) then
          begin
            SetLength(description,Length(description)-1);
            Delete(description,1,1);
          end;
        ausschrift_modulbeschreibung(description);
      end;
  end;

procedure xosl_kennwort(const o0,laenge:dateigroessetyp);
  var
    statuszeile_org     :buntzeilen_typ;
    soll                :longint;
    pw                  :string;
    l                   :word_norm;
  function versuche(l,lmax:word_norm;jetzt,soll:longint):boolean;
    var
      c                 :shortint;
      w                 :longint;
    begin
      if l=lmax then
        begin
          versuche:=jetzt=soll;
          Exit;
        end;

      Inc(l);
      for c:=Ord(' ') to Ord('z') do
        begin
          (*$IfDef VirtualPascal*)
          asm (*&Alters eax,edx,ecx*)
            movsx eax,c
            mov ecx,jetzt
            shl eax,2
            add eax,$fb
            movsx eax,ax
            mov edx,ecx //jetzt
            shr edx,1
            add edx,$5d
            imul eax,edx
            movsx edx,c
            xor edx,ecx //jetzt
            add edx,eax
            mov w,edx
          end;
          (*$Else*)
          w:=((c shl 2)+$fb)*((jetzt shr 1)+$5d)+(c xor jetzt);
          (*$Endif*)
          if versuche(l,lmax,w,soll) then
            begin
              pw[l]:=Chr(c);
              versuche:=true;
              Exit;
            end;
        end;
      versuche:=false;
    end;

  begin
    soll:=x_longint__datei_lesen(o0+$62);
    if soll=0 then
      begin
        ausschrift(in_doppelten_anfuerungszeichen(''),normal);
        Exit;
      end;

    for l:=0 to 6 do
      begin
        benutzer_abfrage(false,false);
        if emulator_abbrechen then Exit;
        sichere_statuszeile(statuszeile_org);
        schreibe_statuszeile(' XOSL:'+str0(l)+'...',true);
        if versuche(0,l,$164e9,soll) then
          begin
            restauriere_statuszeile(statuszeile_org);
            SetLength(pw,l);
            ausschrift(in_doppelten_anfuerungszeichen(pw),normal);
            Exit;
          end;
        restauriere_statuszeile(statuszeile_org);
      end;
  end;

procedure versuche_ibm_software_installer;
  var
    o,e                 :dateigroessetyp;
    catalog,
    disk,
    component           :boolean;
    titel_angezeigt     :boolean;

  procedure ausschrift_zk_inhalt;
    var
      w1                :word_norm;
    begin
      if not titel_angezeigt then
        begin
          if catalog then
            ausschrift('IBM Software Installer Catalog File',bibliothek)
          else
            ausschrift('IBM Software Installer Package File',bibliothek);
          titel_angezeigt:=true;
        end;

      w1:=Pos(#39,exezk);
      if w1<>0 then
        begin
          Delete(exezk,1,w1);
          w1:=Pos(#39,exezk);
          if w1<>0 then
            begin
              SetLength(exezk,w1-1);
              if exezk<>'' then
                ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
            end;
        end;
    end;

  begin
    o:=analyseoff;
    e:=o+MinDGT(einzel_laenge,60000);
    titel_angezeigt:=false;
    catalog:=false;
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        if exezk='' then Continue;
        if exezk[1]='*' then Continue;

        if not (exezk[1] in [' ',#9]) then
          begin
            if catalog then
              Exit;
            component:=false;
            disk:=false;
          end;

        if exezk='CATALOG' then
          begin
            catalog:=true;
            Continue;
          end;
        if exezk='DISK' then
          begin
            disk:=true;
            Continue;
          end;

        if exezk='COMPONENT' then
          begin
            component:=true;
            COntinue;
          end;

        tabexpand(exezk);
        exezk:=leer_filter(exezk);

        if catalog then
          begin
            if (Pos('NAME ',exezk)=1)
            or (Pos('DESCRIPTION ',exezk)=1) then
              ausschrift_zk_inhalt;
          end;

        if disk then
          begin
            if (Pos('NAME ',exezk)=1)
            or (Pos('VOLUME ',exezk)=1) then
              ausschrift_zk_inhalt;
          end;

        if component then
          begin
            if (Pos('NAME ',exezk)=1)
            or (Pos('DESCRIPTION ',exezk)=1) then
              ausschrift_zk_inhalt;
          end;

      end;

  end;

procedure troff;
  var
    o,e                 :dateigroessetyp;
    w1                  :word_norm;
  begin
    o:=analyseoff;
    e:=o+MinDGT(einzel_laenge,3000);
    ausschrift('troff',signatur);
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        if Pos('.TH ',exezk)<>1 then Continue;
        tabexpand(exezk);
        Delete(exezk,1,Length('.TH '));
        w1:=Pos('\"',exezk);
        if w1<>0 then SetLength(exezk,w1-1);
        repeat
          w1:=Pos('"',exezk);
          if w1=0 then Break;
          exezk[w1]:=' ';
        until false;
        repeat
          w1:=Pos('   ',exezk);
          if w1=0 then Break;
          Delete(exezk,w1,1);
        until false;
        exezk:=leer_filter(exezk);
        if exezk<>'' then
          ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
        Break;
      end;
  end;

procedure syslevel(const p:puffertyp);
  var
    w1:word_norm;
  begin
    (* Warp 3 *)
    ausschrift('OS/2 '+textz_Versionsnummernverzeichnis_anf^,bibliothek);
    with p do
      begin
        if d[$0f] <=1 then
          w1:=0
        else
          w1:=$5e; (* 2 bei Warp4 FP10 deutsch *)

        ausschrift(puffer_zu_zk_e(d[$3c+w1],#0,80),beschreibung);
        ausschrift('Version '+version_x_y(d[$28+w1] shr 4,(d[$28+w1] and $0f)*10+(d[$29+w1] and $0f))
          +textz_dat__komponenten_id^+puffer_zu_zk_e(d[$8c+w1],#0,9),beschreibung);

        exezk:=puffer_zu_zk_e(d[$96+w1],#0,30);
        if (exezk<>'')
        and ist_ohne_steuerzeichen(exezk)
         then
          ausschrift(textz_dat__typ^+exezk,beschreibung);

        ausschrift(textz_dat__aktueller_csd_level^+puffer_zu_zk_e(d[$2c+w1],#0,7),beschreibung);
        ausschrift(textz_dat__voriger_csd_level^  +puffer_zu_zk_e(d[$34+w1],#0,7),beschreibung);
      end;
  end;

procedure vcard(const p:puffertyp);
  var
    w1:word_norm;
  begin
    w1:=puffer_pos_suche(p,#$0a'n:',100);
    if w1=nicht_gefunden then
      exezk:=''
    else
      exezk:=' "'+puffer_zu_zk_zeilenende(p.d[w1+Length(#$0a'n:')],80)+'"';
    ausschrift('virtual card format'+exezk,beschreibung);
  end;

procedure watcom_patch_level(const p:puffertyp);
  begin
    (*ausschrift('"Watcom patch level" "'+puffer_zu_zk_e(dat_puffer_zeiger^.d[19],#0,4)+'"',packer_dat);*)
    ausschrift(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[0],#0,$18-1)),packer_dat);
    (* LÑnge ist wichtig: z.B. Tyra/2 1.90 rexx-Archiv nach patch level *)
    einzel_laenge:=$18;
  end;

procedure versuche_doppelrahmen_kasten(const p:puffertyp);
  var
    bildschirmende:dateigroessetyp;
  begin
    if (not file_id_diz_datei)
    and (puffer_pos_suche(p,'ÕÕª'#$0d#$0a,82)<>nicht_gefunden) then
      begin
        bildschirmende:=datei_pos_suche(analyseoff,analyseoff+MinDGT(einzel_laenge,28*80),'Õº'#$0d#$0a{#$00});
        if bildschirmende<>nicht_gefunden then
          begin
            (* Eine einfache Textdattei hat keine Null am Ende *)
            if (einzel_laenge>bildschirmende+Length('Õº'#$0d#$0a#$00)-analyseoff)
            and (byte__datei_lesen(bildschirmende+Length('Õº'#$0d#$0a))=0) then
              einzel_laenge:=bildschirmende+Length('Õº'#$0d#$0a#$00)-analyseoff;
            ansi_anzeige(analyseoff,#0,ftab.f[farblos,hf]+ftab.f[farblos,vf],
              vorne,wahr,wahr,analyseoff+einzel_laenge,'')
          end;
      end;
  end;

procedure fastpacked_oliver_weindl(const p:puffertyp);
  var
    w1:word_norm;
  begin
    if p.d[$166] in [$eb,$e9] then
      begin
        exezk:=textz_dat__Kopf^+' ';
        einzel_laenge:=$166;
      end
    else
      exezk:='';

    ausschrift(exezk+'FastPacked / Oliver Weindl [1.4]',signatur);
    ausschrift(in_doppelten_anfuerungszeichen(puffer_zu_zk_pstr(p.d[$14])),beschreibung);
    for w1:=1 to 5 do
      ausschrift(in_doppelten_anfuerungszeichen(puffer_zu_zk_pstr(p.d[$67+(w1-1)*51])),beschreibung);

  end;

procedure mach_o(const p:puffertyp);
  begin
    with p do
      begin
        exezk:='Mach-O';
        case m_longint(d[12]) of
          1:exezk_anhaengen(' object');
          2:exezk_anhaengen(' executable');
          3:exezk_anhaengen(' shared library');
          4:exezk_anhaengen(' core');
          5:exezk_anhaengen(' preload executable');
        else
            exezk_anhaengen(' filetype:'+str0(m_longint(d[12])));
        end;

        case m_longint(d[4]) of
          1:exezk_anhaengen(' (mc68030)');
          2:exezk_anhaengen(' (mc68040)');
          3:exezk_anhaengen(' (mc68030 only)');
          7:exezk_anhaengen(' i386');
          8:exezk_anhaengen(' mips');
          9:exezk_anhaengen(' ns32532');
         11:exezk_anhaengen(' hp pa-risc');
         12:exezk_anhaengen(' acorn');
         13:exezk_anhaengen(' m88k');
         14:exezk_anhaengen(' SPARC');
         15:exezk_anhaengen(' i860-big');
         16:exezk_anhaengen(' i860');
         17:exezk_anhaengen(' rs6000');
         18:exezk_anhaengen(' powerPC');
        else
            exezk_anhaengen(' architecture:'+str0(m_longint(d[4])));
        end;

        ausschrift(exezk,compiler);
      end;
  end;

procedure win32_debuginfo(const p:puffertyp);
  var
    dat_tmp_puffer      :puffertyp;
    tl,l0,l1            :longint;
    w1                  :word_norm;
  begin
    ausschrift('Debuginfo / ??? ¯ '
      +in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[$c],#0,255)),bibliothek);
    if einzel_laenge>$0110 then
      begin
        tl:=$110;
        l0:=0;
        repeat
          datei_lesen(dat_tmp_puffer,analyseoff+tl,{4}$40);
          l1:=longint_z(@dat_tmp_puffer.d[0])^;
          if (l1<l0)
          or (    bytesuche(dat_tmp_puffer.d[0],'NB')
              and (dat_tmp_puffer.d[2] in [Ord('0')..Ord('2')])
              and (dat_tmp_puffer.d[3] in [Ord('0')..Ord('9')]))
          (* 'Authenticode ??, Netscape PKCS' *)
          or ((   bytesuche(dat_tmp_puffer.d[8],#$30#$82)
               or bytesuche(dat_tmp_puffer.d[8],#$30#$80)
              and puffer_gefunden(dat_tmp_puffer,#$06#$09#$2a#$86#$48#$86)))
           then
            begin
              einzel_laenge:=tl;
              break;
            end;
          l0:=l1;
          Inc(tl,$10);
        until {false}tl>=einzel_laenge;
      end;
    Exit; (* .OFM *)
  end;

procedure os2_font_metrics(const p:puffertyp);
  var
    dat_tmp_puffer      :puffertyp;
    o                   :longint;
  begin
    o:=longint_z(@p.d[$10])^;
    if (o<=$14) or (o>=einzel_laenge) then Exit; (* AIC78U2.SYS debuginfo *)
    datei_lesen(dat_tmp_puffer,analyseoff+o,512);
    ausschrift('OS/2 Font Metrics',musik_bild);
    ausschrift_x(puffer_zu_zk_l(dat_tmp_puffer.d[2],dat_tmp_puffer.d[0]),beschreibung,absatz);
  end;

procedure theme_park_bullfrog;
  var
    dat_tmp_puffer      :puffertyp;
    w1                  :word_norm;
  begin
    datei_lesen(dat_tmp_puffer,analyseoff+$4a589,3*$20+1);
    ausschrift('Theme Park / Bullfrog',spielstand);
    for w1:=0 to 2 do
      ausschrift_x(puffer_zu_zk_e(dat_tmp_puffer.d[w1*$20],#0,$20),beschreibung,absatz);
  end;

procedure mod_anzeige(const doppelt:boolean);
  var
    zaehler,
    anzahl              :word_norm;
    mod_puffer          :puffertyp;
    schon_nichtleer     :boolean;

  procedure lies_klang(klangnummer:word_norm);
    var
      posi              :word_norm;
    begin
      if ((klangnummer=16) and (not doppelt))
      or ((klangnummer=32) and (    doppelt)) then
        FillChar(mod_puffer,SizeOf(mod_puffer),0)
      else
        datei_lesen(mod_puffer,analyseoff+20+(klangnummer-1)*30,30);

      for posi:=Pred(1) to Pred(22) do
        if mod_puffer.d[posi]<Ord(' ') then (* VABANK.MOD *)
          mod_puffer.d[posi]:=Ord(' ');
    end;

  begin
    anzahl:=16;

    repeat

      lies_klang(anzahl);
      if leer_filter(puffer_zu_zk_e(mod_puffer.d[0],#0,22))<>'' then
        Break;

      if doppelt then
        begin
          lies_klang(16+anzahl);
          if leer_filter(puffer_zu_zk_e(mod_puffer.d[0],#0,22))<>'' then
            Break;
        end;

      Dec(anzahl);

    until anzahl=0;

    schon_nichtleer:=false;

    for zaehler:=1 to anzahl do
      begin
        lies_klang(zaehler);
        exezk:=puffer_zu_zk_e(mod_puffer.d[0],#0,22);
        leerzeichenerweiterung(exezk,40);
        if doppelt then
          begin
            lies_klang(16+zaehler);
            exezk:=exezk+puffer_zu_zk_e(mod_puffer.d[0],#0,22);
          end;

        if not schon_nichtleer then
          schon_nichtleer:=(leer_filter(exezk)<>'');

        if schon_nichtleer then
          ausschrift_x(exezk,beschreibung,absatz);
      end;

  end;

procedure scream_tracer_3(const p:puffertyp);
  var
    zaehler,
    anzahl_instrumente  :word_norm;
    o                   :longint;
    dien_puffer         :puffertyp;
  begin
    ausschrift('Scream Tracker 3 '+textz_Modul^+version161616(word_z(@p.d[$28])^ and $0fff)
        +' "'+puffer_zu_zk_e(p.d[0],#0,$1c)+'"',musik_bild);
    if not langformat then exit;

    anzahl_instrumente:=word_z(@p.d[$22])^;
    o:=$60+word_z(@p.d[$20])^;
    for zaehler:=1 to anzahl_instrumente do
      begin
        datei_lesen(dien_puffer,analyseoff+o+(zaehler-1)*2,2);
        datei_lesen(dien_puffer,analyseoff+longint(word_z(@dien_puffer.d[0])^)*16,$50);
        Ausschrift(puffer_zu_zk_e(dien_puffer.d[$30],#0,28),beschreibung);
      end;
  end;

procedure scream_tracer_2(const p:puffertyp);
  var
    zaehler,
    anzahl              :word_norm;
    mod_puffer          :puffertyp;
    schon_nichtleer     :boolean;

  procedure lies_klang(klangnummer:word_norm);
    var
      posi              :word_norm;
    begin
      if klangnummer=32 then
        FillChar(mod_puffer,$20,0)
      else
        datei_lesen(mod_puffer,analyseoff+$30+(klangnummer-1)*$20,$20);

      for posi:=Pred(1) to Pred(12) do
        if mod_puffer.d[posi]<Ord(' ') then
          mod_puffer.d[posi]:=Ord(' ');
    end;
  begin
    ausschrift('Scream Tracker 2 '+textz_Modul^+version_x_y(p.d[$1e],p.d[$1f])+' "'
      +puffer_zu_zk_e(p.d[0],#0,$14)+'"',musik_bild);

    if not langformat then exit;

    anzahl:=16;

    repeat

      lies_klang(anzahl);
      if leer_filter(puffer_zu_zk_e(mod_puffer.d[0],#0,12))<>'' then
        Break;

      if anzahl<>16 then (* nur 0..30(1..31) in Datei vorhanden *)
        begin
          lies_klang(16+anzahl);
          if leer_filter(puffer_zu_zk_e(mod_puffer.d[0],#0,12))<>'' then
            Break;
        end;

      Dec(anzahl);

    until anzahl=0;

    schon_nichtleer:=false;

    for zaehler:=1 to anzahl do
      begin
        lies_klang(zaehler);
        exezk:=puffer_zu_zk_e(mod_puffer.d[0],#0,12);
        leerzeichenerweiterung(exezk,40);
        lies_klang(16+zaehler);
        exezk:=exezk+puffer_zu_zk_e(mod_puffer.d[0],#0,12);

        if not schon_nichtleer then
          schon_nichtleer:=(leer_filter(exezk)<>'');

        if schon_nichtleer then
          ausschrift_x(exezk,beschreibung,absatz);
      end;

  end;

procedure ft_extended_module(var p:puffertyp);
  var
    o,o0,kopflaenge,
    sampledata_summe    :longint;
    zaehler,zaehler2,
    anzahl,durchlauf,
    erster_sichtbarer,
    letzter_sichtbarer  :word_norm;
    dien_puffer         :puffertyp;
  begin
    p.d[37]:=0;
    exezk:=puffer_zu_zk_e(p.d[17],#0,255);
    while (exezk<>'') and (exezk[Length(exezk)]=' ') do
      Dec(exezk[0]);
    ausschrift(textz_Erweiters_Modul^+' / Fast Tracker 2  "'+exezk+'"',musik_bild);

    if not langformat then exit;

    o:=60+longint_z(@p.d[60])^;
    (* "Pattern" Åbergehen *)
    zaehler:=word_z(@p.d[60+10])^;
    while zaehler>0 do
      begin
        Dec(zaehler);
        datei_lesen(dien_puffer,analyseoff+o,9);
        Inc(o,longint_z(@dien_puffer.d[0])^+word_z(@dien_puffer.d[7])^);
      end;

    (* Instrumente *)
    o0:=o;
    erster_sichtbarer:=$7fff;
    letzter_sichtbarer:=0;
    anzahl:=word_z(@p.d[60+12])^;

    for durchlauf:=1 to 2 do
      begin
        o:=o0;

       for zaehler:=1 to anzahl do
         begin
           sampledata_summe:=0;
           datei_lesen(dien_puffer,analyseoff+o,29+4);
           exezk:=puffer_zu_zk_e(dien_puffer.d[4],#0,22);
           case durchlauf of
             1:
               if leer_filter(exezk)<>''  then
                 begin
                   erster_sichtbarer :=Min(erster_sichtbarer ,zaehler);
                   letzter_sichtbarer:=Max(letzter_sichtbarer,zaehler);
                 end;

             2:
               if  (zaehler>=erster_sichtbarer)
               and (zaehler<=letzter_sichtbarer) then
                 ausschrift(exezk,beschreibung);
           end;

           Inc(o,longint_z(@dien_puffer.d[0])^);
           (* Anzahl Aufnahmen *)
           zaehler2:=word_z(@dien_puffer.d[27])^;
           kopflaenge:=longint_z(@dien_puffer.d[29])^;
           while zaehler2>0 do
             begin
               Dec(zaehler2);
               datei_lesen(dien_puffer,analyseoff+o,18+22);
               Inc(o,kopflaenge);
               Inc(sampledata_summe,longint_z(@dien_puffer.d[0])^);
               (*ausschrift('>'+puffer_zu_zk_e(dien_puffer.d[18],#0,80),beschreibung);*)
             end;
           Inc(o,sampledata_summe);
         end;

       end; (* Durchlauf *)
  end;

function versuche_carmel_pruefsummen_datei(const blocklaenge,rest:word_norm):boolean;
  var
    attr                :byte;
    dien_puffer         :puffertyp;
  begin
    versuche_carmel_pruefsummen_datei:=false;

    case blocklaenge of
      $3e:exezk:=puffer_zu_zk_pstr(analysepuffer.d[4]);
    else
          exezk:=puffer_zu_zk_e(analysepuffer.d[0],#0,8+1+3);
    end;

    if (Pos('.EXE',exezk)<=1) and (not chklist_name) then
      if (Length(exezk)<2+1+3)
      or (Length(exezk)>8+1+3)
      or (Pos('.',exezk)<3)
      or (not ist_ohne_steuerzeichen_nicht_so_streng(exezk)) then
        Exit;

    (* nicht TAR *)
    if analysepuffer.g>$110 then
      if bytesuche(analysepuffer.d[$101],'ustar')
      or bytesuche(analysepuffer.d[$101],'GNUtar')
      or bytesuche(analysepuffer.d[$101],#0#0#0#0#0#0#0#0#0#0#0#0#0) then
        Exit;

    (* nur Versteckt/System/nur Lesen/Archiv *)
    with analysepuffer do
      case blocklaenge of
        $1b:attr:=d[$e];
        $1c:attr:=d[$e];
        $3c:attr:=d[$d];
        $3e:attr:=d[rest+$15];
      end;

    if (attr and ($ff-($20+$4+2+1)))<>0 then
      Exit;

    (* ein Block aus der Mitte *)
    (*$IfDef dateigroessetyp_comp*)
    datei_lesen(dien_puffer,rest+DivDGT(einzel_laenge,blocklaenge*2)*blocklaenge,blocklaenge);
    (*$Else*)
    datei_lesen(dien_puffer,rest+((einzel_laenge div blocklaenge) shr 1)*blocklaenge,blocklaenge);
    (*$EndIf*)

    case blocklaenge of
      $3e:exezk:=puffer_zu_zk_pstr(dien_puffer.d[0]);
    else
          exezk:=puffer_zu_zk_e(dien_puffer.d[0],#0,8+1+3);
    end;

    if (Length(exezk)<2+1+3)
    or (Length(exezk)>8+1+3)
    or (Pos('.',exezk)<3)
    or (not ist_ohne_steuerzeichen_nicht_so_streng(exezk)) then
      Exit;

    (* nur Versteckt/System/nur Lesen/Archiv *)
    with dien_puffer do
      case blocklaenge of
        $1b:attr:=d[$e];
        $1c:attr:=d[$e];
        $3c:attr:=d[$d];
        $3e:attr:=d[$15];
      end;

    if (attr and ($ff-($20+$4+2+1)))<>0 then
      Exit;

    exezk:=strx_oder_hexDGT(
      (*$IfDef dateigroessetyp_comp*)
      DivDGT(einzel_laenge,blocklaenge)
      (*$Else*)
      einzel_laenge div blocklaenge
      (*$EndIf*)
        )+'*'+strx_oder_hex(blocklaenge);
    if rest>0 then
      exezk:=strx_oder_hex(rest)+'+'+exezk;
    ausschrift('Carmel Turbo AntiVirus, Central Point AntiVirus '+textz_Pruefsummen^+' ('
      +exezk+')',signatur);

    (* MPC.COM in MPC.EXE -> "MP"-> Phar Lap EXE ...  Fehlmeldung *)
    versuche_carmel_pruefsummen_datei:=true;

  end;

procedure Delusion_Digital_Music_Fileformat;
  var
    o,o0                :longint;
    dien_puffer         :puffertyp;
  begin
    ausschrift('Delusion Digital Music Fileformat',musik_bild);
    datei_lesen(dien_puffer,analyseoff,$42);
    ausschrift_x(puffer_zu_zk_e(dien_puffer.d[$d],#0,30)+' / '+puffer_zu_zk_e(dien_puffer.d[$2b],#0,20),beschreibung,absatz);
    if not langformat then exit;

    o:=$42;
    repeat
      datei_lesen(dien_puffer,analyseoff+o,4+4);
      if bytesuche(dien_puffer.d[0],'ENDE') then Break;
      if bytesuche(dien_puffer.d[0],'CMSG') then
        begin
          o0:=1;
          repeat
            ausschrift_x(datei_lesen__zu_zk_e(analyseoff+o+8+o0,#0,40),beschreibung,leer);
            Inc(o0,40);
          until o0>=longint_z(@dien_puffer.d[4])^
        end;
      Inc(o,8+longint_z(@dien_puffer.d[0])^);
    until o>=einzel_laenge;
  end;

procedure MAS_UTrack_V00(const p:puffertyp);
  var
    zaehler:word_norm;
  begin
    case p.d[$e] of
      $31:exezk:='1.0';
      $32:exezk:='2.0';
      $33:exezk:='2.1';
      $34:exezk:='2.2';
    else
          exezk:='?.? ¯'
    end;
    ausschrift('UltraTracker / Marc AndrÇ Schallehn ['+exezk+']',musik_bild);
    ausschrift_x(puffer_zu_zk_e(p.d[$f],#0,32),beschreibung,absatz);

    if not langformat then Exit;

    for zaehler:=1 to p.d[$2f] do
      ausschrift_x(datei_lesen__zu_zk_e(analyseoff+$30+(zaehler-1)*32,#0,32),beschreibung,leer);

  end;

procedure textini;
  var
    o                   :dateigroessetyp;
    p                   :puffertyp;
    pg                  :puffertyp;
    w1                  :word_norm;
    url_ausgegeben      :boolean;

  function lies_eintrag(const kapitel,eintrag:string):string;
    var
      o1,oe             :dateigroessetyp;
      p1                :puffertyp;
      kapitel_gefunden  :boolean;
      exezk_gross       :string;
    begin
      o1:=o;
      oe:=o+MinDGT(einzel_laenge,20*80);
      kapitel_gefunden:=(kapitel='');
      repeat
        datei_lesen(p1,o1,512);
        exezk:=leer_filter(puffer_zu_zk_zeilenende(p1.d[0],255));
        exezk_gross:=gross(exezk);

        if exezk<>'' then
          begin
            case exezk[1] of
              ';':;
              '[':
                begin
                  if exezk[Length(exezk)]=']' then
                    begin
                      if kapitel<>'' then
                        kapitel_gefunden:=('['+kapitel+']'=exezk_gross);
                    end;
                end;
            else
              if ((Pos(eintrag+' ',exezk_gross)=1) and (Pos('=',exezk)<>0))
              or (Pos(eintrag+'=',exezk_gross)=1) then
                begin
                  lies_eintrag:=leer_filter(Copy(exezk,Pos('=',exezk)+1,255));
                  Exit;
                end;
            end;
          end;

        weiter_bis_zum_naechsten_zeilenanfang(o1);

      until o1>=oe;
    end; (* lies_eintrag *)

  procedure suche_ini_ende;
    var
      o,e               :dateigroessetyp;
      p1                :puffertyp;
      i                 :word_norm;
    begin
      (* Beispiel: "progressive setup" -> temp_bz2.x *)
      o:=analyseoff;
      e:=analyseoff+MinDGT(einzel_laenge,80*80);
      repeat
        datei_lesen(p1,o,512);
        exezk:=leer_filter(puffer_zu_zk_zeilenende(p1.d[0],255));
        for i:=1 to Length(exezk) do
          if Ord(exezk[i]) in [0..8,11,12,14..$19,$1a..$1f,$7f] then
            begin
              einzel_laenge:=o-analyseoff;
              Exit;
            end;
        weiter_bis_zum_naechsten_zeilenanfang(o);
      until o>=e;
    end; (* suche_ini_ende *)

  var
    habe_sektionheader:boolean;

  begin (* textini *)
    o:=0;
    url_ausgegeben:=false;
    habe_sektionheader:=false;
    repeat

      datei_lesen(p,analyseoff+o,512);
      exezk:=puffer_zu_zk_zeilenende(p.d[0],255);
      if exezk<>'' then
        case exezk[1] of
          ';':;
          '[':
            begin
              exezk:=leer_filter(exezk);

              if exezk[Length(exezk)]<>']' then Exit;
              if not ist_ohne_steuerzeichen_nicht_so_streng(exezk) then Exit;

              habe_sektionheader:=true;

              puffer_gross(p,pg);
              if bytesuche(pg.d[0],'[DEFAULT]')
              or bytesuche(pg.d[0],'[INTERNETSHORTCUT]') then
                begin
                  if not url_ausgegeben then
                    begin
                      exezk:=lies_eintrag('InternetShortcut','URL');
                      if exezk<>'' then
                        begin
                          ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
                          (* Befehl_URL? -> SysCreateObject(..WPUrl,..exezk..) *)
                          url_ausgegeben:=true;
                        end;
                    end;
                end
              else
              if  puffer_gefunden(pg,'TYPE ')
              and puffer_gefunden(pg,'VERSION ')
               then
                begin
                  w1:=puffer_pos_suche(pg,'TITLE ',512);
                  if w1<>nicht_gefunden then
                    begin
                      ausschrift('OS/2 Network Information File'+#13#10
                      (* hat oft selbst schon "" *)
                        +lies_eintrag('','TITLE'),beschreibung);
                      Exit;
                    end;
                end
              else
                begin
                  if not url_ausgegeben then
                    ausschrift(exezk,beschreibung);
                  suche_ini_ende;
                  Exit;
                end;

            end;
        else
          if not habe_sektionheader then Exit;
        end; (* case  [1] *)

      weiter_bis_zum_naechsten_zeilenanfang(o);

    (* Bergrenzung, damit nicht etwa 1 MB auskommentierter ASM-Quelltext ausgewertet wird *)
    until (o>=einzel_laenge) or (o>40*80);
    suche_ini_ende;
  end;

procedure scg_setup_info(const p:puffertyp;const version:word_norm);
  var
    p2                  :puffertyp;
    i                   :word_norm;
    z                   :byte;
  begin
    i:=4;
    z:=Ord('a');
    p2:=p;

    einzel_laenge:=longint_z(@p2.d[$00])^+4;

    if p2.g>einzel_laenge then
      (*$IfDef dateigroessetyp_comp*)
      p2.g:=Round(einzel_laenge);
      (*$Else*)
      p2.g:=einzel_laenge;
      (*$EndIf*)

    repeat
      if version=2 then
        p2.d[i]:=not byte((p2.d[i] shl 4)+(p2.d[i] shr 4));
      p2.d[i]:=p2.d[i] xor z;
      Inc(z);
      if z=Ord('z')+1 then
        z:=Ord('a');
      Inc(i);
    until i>=p2.g;

    ausschrift('SCG1? SETUP INFO / ? <'+str0(version)+'>',packer_dat);

    if langformat then
      signatur_anzeige('',p2);

  end;

function lha_variante(const p:puffertyp;const index:word_norm):string;
  begin
    (* bytesuche(p.d[index],'-lh') *)
    case p.d[index+5] of
      Ord('0') .. Ord('5'):
        begin
          if  (p.d[5] in [Ord('0'),Ord('5')])
          and (p.d[0]=p.d[$f]+25)
          and (bytesuche(p.d[p.d[0]-1],#$20#$00#$00)) then
            lha_variante:='CAR / MylesHi! Software [Lha]'
          else
            lha_variante:='Lha / Haruyasu Yoshizaki';
        end;
      Ord('7'):
        lha_variante:='LHARK / K.F.Medina'
    else
        lha_variante:='Lha '+textz_dien__oder_aehnlich^+' / Haruyasu Yoshizaki';
    end;

    if bytesuche(p.d[index+2],'-sw') then
        lha_variante:='SourceWare Archival Group (Lha / Haruyasu Yoshizaki)';
  end;

procedure eddie_test(var p:puffertyp);
  begin
    if puffer_pos_suche(p,'MZ'#$74,30)<>nicht_gefunden then
      ausschrift('Eddie / Dark Avenger',virus);
  end;

procedure cascade(const p:puffertyp);
  var
    w1:word_norm;
  begin
    w1:=puffer_pos_suche(p,#$bc'??'#$31#$34,50);
    if w1=nicht_gefunden then
      exezk:=''
    else
      begin
        w1:=word_z(@p.d[w1+1])^+35;
        if w1=1707 then Dec(w1);
        exezk:='.'+str0(w1);
      end;
    ausschrift('Cascade'+exezk,virus);
  end;

procedure dos4gw_exp(const p:puffertyp);
  const
    exp_align           =16;
  var
    dos4gw_laenge       :longint;
    dien_puffer         :puffertyp;
  begin
    exezk:='';
    b1:=$70;
    while p.d[b1]>=32 do
      begin
        exezk_anhaengen(chr(p.d[b1]));
        Inc(b1);
      end;
    ausschrift('Phar Lap EXP [BW] "'+exezk+'"',dos_win_extender);

    dos4gw_laenge:=longint(word_z(@p.d[4])^)*512
                  +longint(word_z(@p.d[2])^);

    dos4gw_laenge:=(dos4gw_laenge+exp_align-1) and -exp_align;

    if dos4gw_laenge<einzel_laenge then (* DOS4GW.EXP 1.92,.. *)
      begin
        datei_lesen(dien_puffer,analyseoff+dos4gw_laenge,$10);
        if  (dien_puffer.d[0] in [$80,$88])
        and (dien_puffer.d[1]=0           )
        and (dien_puffer.d[2] in [$80,$88])
        and (dien_puffer.d[3]=0           )
         then
          begin
            {ausschrift('********',signatur);}
            Inc(dos4gw_laenge,longint_z(@p.d[$c0])^);
            dos4gw_laenge:=(dos4gw_laenge+exp_align-1) and -exp_align;
            Inc(dos4gw_laenge,longint_z(@p.d[$c0])^);
            dos4gw_laenge:=(dos4gw_laenge+exp_align-1) and -exp_align;
          end;
        end;

    einzel_laenge:=dos4gw_laenge;
  end;

(* keine UnterstÅtzung fÅr '-N' (normal):
1c1
< 1111
---
> 222222222
\ No newline at end of file *)
procedure diff(anfang:dateigroessetyp;nur_ein_diff:boolean);
  var
    o,e                 :dateigroessetyp;
    diffcontext         :boolean;
    dateiname1,
    dateiname2          :string;
    p                   :puffertyp;

  function pruefe_dateiname(var s:string):boolean;
    procedure ende_loeschen(var s:string;const e:string);
      begin
        if Length(s)>=Length(e) then
          if bytesuche(s[Length(s)-Length(e)+1],e) then
            SetLength(s,Length(s)-Length(e));
      end;

    var
      w1                :word_norm;
    begin

      s:=leer_filter(s);
      ende_loeschen(s,' +0?00');
      s:=leer_filter(s);
      ende_loeschen(s,'.000000000');


      w1:=Pos(#9,s);
      if (w1<49) and (Length(s)<72) then
        begin
          Delete(s,w1,1);
          while (w1<49) and (Length(s)<72) do
            begin
              Insert(' ',s,w1);
              Inc(w1);
            end;
        end;

      pruefe_dateiname:=true;
    end;

  begin
    if not textdatei then
      begin (* dn20700-to-30700-cumulative.patch:
               diff -urN DN270/DOC/ENGLISH/DN.INI DN/DOC/ENGLISH/DN.INI
               mit #$19                                                 *)
        datei_lesen(p,anfang,512);
        if  (not puffer_gefunden(p,#$0a'--- '))
        and (not puffer_gefunden(p,#$0a'+++ '))
        and (not puffer_gefunden(p,#$0a'*** ')) then Exit;
      end;
    o:=analyseoff+anfang;
    e:=analyseoff+einzel_laenge;

    if o>=e then Exit;

    exezk:=datei_lesen__zu_zk_zeilenende(o);
    if  (   (Pos('Only in ',exezk)=1)
         or (Pos('Common subdirectories: ',exezk)=1))
    and (Pos(': ',exezk)<>0)
     then
      begin
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        ausschrift(exezk,packer_dat);
        if not nur_ein_diff then
          einzel_laenge:=o-analyseoff;
        Exit;
      end;

    if Pos('diff ',exezk)=1 then
      begin
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
      end;

    if o>=e then Exit;

    exezk:=datei_lesen__zu_zk_zeilenende(o);
    IncDGT(o,Length(exezk));
    weiter_bis_zum_naechsten_zeilenanfang(o);
    if Pos('*** ',exezk)=1 then
      diffcontext:=true
    else
    if Pos('--- ',exezk)=1 then
      diffcontext:=false
    else
      Exit;
    dateiname1:=leer_filter(Copy(exezk,5,255));
    if not pruefe_dateiname(dateiname1) then Exit;

    if o>=e then Exit;

    exezk:=datei_lesen__zu_zk_zeilenende(o);
    IncDGT(o,Length(exezk));
    weiter_bis_zum_naechsten_zeilenanfang(o);
    if diffcontext then
      begin
        if Pos('--- ',exezk)<>1 then Exit;
      end
    else
      begin
        if Pos('+++ ',exezk)<>1 then Exit;
      end;

    dateiname2:=leer_filter(Copy(exezk,5,255));
    if not pruefe_dateiname(dateiname2) then
      Exit;

    if diffcontext then
      exezk:='context-'
    else
      exezk:='unified-';
    ausschrift(exezk+'diff',signatur); (* Eugene W. Myers? *)

    if not langformat then Exit;

    ausschrift_x(dateiname1,packer_dat,absatz);
    ausschrift_x(dateiname2,packer_dat,absatz);

    if nur_ein_diff then Exit;

    (*o:=datei_pos_suche_zeilenanfang(o,e,'diff ');
    if o<>nicht_gefunden then einzel_laenge:=o-analyseoff;*)
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        (* 'diff', 'Only in ', .. *)
        if (exezk<>'') and (exezk[1] in ['A'..'Z','a'..'z']) then
          begin
            einzel_laenge:=o-analyseoff;
            Exit;
          end;
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
      end;

  end;

procedure rcs;
  var
    o,e,o1              :dateigroessetyp;
    extrazaehler        :word_norm;
    soll                :string;
    dateiname           :string;
  begin
    if not textdatei then Exit;

    o:=analyseoff;
    e:=o+einzel_laenge;
    extrazaehler:=0;
    dateiname:='';
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        if (Pos('Index: ',exezk)=1)
        or (Pos('Prereq: ',exezk)=1)
        or (Pos('retrieving revision ',exezk)=1)
        or (Pos('RCS file: ',exezk)=1)
        or (Pos('====================',exezk)=1)
        or (Pos('diff -',exezk)=1) (* diff -u, diff -N *)
         then
          begin
            if langformat and (Pos('Index: ',exezk)=1) then
              dateiname:=': '+Copy(exezk,Length('Index: ')+1,255);
            Inc(extrazaehler);
            if extrazaehler>10 then Exit;
            IncDGT(o,Length(exezk));
            weiter_bis_zum_naechsten_zeilenanfang(o);
            Continue;
          end;
        if (Pos('--- ',exezk)=1) then soll:='+++ '
        else
        if (Pos('*** ',exezk)=1) then soll:='--- '
        else
          Exit;

        o1:=o+Length(exezk);
        weiter_bis_zum_naechsten_zeilenanfang(o1);
        if Pos(soll,datei_lesen__zu_zk_zeilenende(o1))<>1 then Exit;

        ausschrift('Revison Control System'+dateiname,bibliothek);
        if not langformat then
          Exit;

        o1:=datei_pos_suche_zeilenanfang(o1,analyseoff+einzel_laenge,'Index: ');
        if o1<>nicht_gefunden then
          einzel_laenge:=o1-analyseoff;

        diff(o-analyseoff,true);
        Break;
      end;

  end;

procedure versuche_scitech_driver_tab;
  var
    o,e                 :dateigroessetyp;
    anzahl_eintraege    :word_norm;
  begin
    if einzel_laenge>150000 then Exit;
    o:=analyseoff;
    e:=o+einzel_laenge;
    anzahl_eintraege:=0;
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        if exezk='' then Continue;
        if exezk[1]=';' then Continue;
        if not (exezk[1] in ['0','1']) then Exit;
        if not bytesuche(exezk[2],' ????:???? ') then Exit;
        if anzahl_eintraege<10 then
          begin
            if Pos('.drv',exezk)=0 then Exit;
            if ziffer($10,Copy(exezk,3,4))=-1 then Exit;
            if ziffer($10,Copy(exezk,8,4))=-1 then Exit;
          end;
        Inc(anzahl_eintraege);
      end;
    if anzahl_eintraege<>0 then
      ausschrift('Scitech Nucleus/SNAP PCI device list ('+str0(anzahl_eintraege)+')',bibliothek);
  end;

procedure EddyHawk_infolist;
  var
    o                   :dateigroessetyp;
    z                   :word_norm;
    titel               :string;
  begin
    o:=analyseoff;
    titel:=datei_lesen__zu_zk_zeilenende(o);
    weiter_bis_zum_naechsten_zeilenanfang(o);
    weiter_bis_zum_naechsten_zeilenanfang(o);
    exezk:=datei_lesen__zu_zk_zeilenende(o);
    if exezk[Length(exezk)]=':' then
      DecLength(exezk);
    if exezk<>'' then
      begin
        ausschrift(titel,signatur);
        ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
      end;
  end;

procedure tr_script;
  var
    o,e                 :dateigroessetyp;
    unbekannt_zaehller  :word_norm;
    cracker,target,
    gr                  :string;

  function wert(const sl:string):string;
    var
      s:string;
    begin
      s:=Copy(exezk,Length(sl)+1,255);
      while (s<>'') and (s[1] in [' ',#9,':']) do
        Delete(s,1,1);
      wert:=s;
    end;

  begin
    o:=analyseoff;
    e:=o+MinDGT(einzel_laenge,9999);
    target:='';
    cracker:='';
    unbekannt_zaehller:=0;
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        if Length(exezk)>80 then Exit;
        weiter_bis_zum_naechsten_zeilenanfang(o);
        if exezk='' then Continue;
        exezk:=leer_filter(exezk);
        if exezk[1]=';' then
          begin
            while (exezk<>'') and (exezk[1] in [';',' ','#']) do Delete(exezk,1,1);
            while (exezk<>'') and (exezk[Length(exezk)] in [';',' ','#']) do DecLength(exezk);
            if Pos('Target:',exezk)=1 then
              target:=wert('Target')
            else
            if Pos('Author:',exezk)=1 then
              cracker:=wert('Author')
            else
            if Pos('TR-script to',exezk)=1 then
              target:=wert('TR-script to')
            else
            if Pos('TR-script',exezk)=1 then
              target:=wert('TR-script')
            else
            if Pos('Unpacker script for',exezk)=1 then
              target:=wert('Unpacker script for')
            else
            if Pos('written by',exezk)=1 then
              cracker:=wert('written by');
            Continue;
          end;

        if Pos('Cracker ',exezk)=1 then
          begin
            cracker:=wert('Cracker');
            Continue;
          end;

        if Pos('Protector ',exezk)=1 then
          begin
            target:=wert('Protector ');
            Continue;
          end;

        gr:=gross(exezk);
        if (gr='RELOAD')
        or (gr='EXE1') or (gr='EXE2')
        or (gr='PRET')
        or (gr='GO 100')
        or (Pos('BPXB ',gr)=1)
        or (Pos('AUTOJMP ',gr)=1)
        or (Pos('D DS:10',gr)=1)
         then
          begin
            ausschrift('TR / Liu TaoTao',signatur);
            if cracker<>'' then
              ausschrift_x(in_doppelten_anfuerungszeichen(cracker),beschreibung,absatz);
            if target<>'' then
              ausschrift_x(in_doppelten_anfuerungszeichen(target),packer_dat,absatz);
            Exit;
          end;
        Inc(unbekannt_zaehller);
        if unbekannt_zaehller>30 then Break;
      end;

  end;

procedure vrml(const p:puffertyp);
  var
    w1                  :word_norm;
    desc                :dateigroessetyp;
  begin
    exezk:=puffer_zu_zk_zeilenende(p.d[7],128);
    w1:=Pos(' ',exezk);
    if w1<>0 then SetLength(exezk,w1-1);
    ausschrift('Virtual Realtity Markup Language ['+exezk+']',musik_bild);
    desc:=datei_pos_suche(analyseoff,analyseoff+MinDGT(einzel_laenge,1000),'Description {');
    if desc<>nicht_gefunden then
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(desc);
        w1:=Pos('info "',exezk);
        if w1<>0 then
          begin
            Delete(exezk,1,w1+Length('info "')-1);
            w1:=Pos('"',exezk);
            if w1<>0 then
              SetLength(exezk,w1-1);
            ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
          end;
      end;
  end;

procedure shell_script(const p:puffertyp);
  var
    w1                  :word_norm;
    scr                 :string;
  begin
    scr:=puffer_zu_zk_zeilenende(p.d[2],40);
    scr:=leer_filter(scr);
    while Pos('\',scr)<>0 do
      Delete(scr,1,Pos('\',scr));
    while Pos('/',scr)<>0 do
      Delete(scr,1,Pos('/',scr));

    (* #! /usr/bin/env python *)
    if Pos('env ',scr)=1 then
      begin
        Delete(scr,1,Length('env'));
        scr:=leer_filter(scr);
      end;

    exezk:=textz_dat__unbekanntes^+' '+in_doppelten_anfuerungszeichen(scr);

    if (scr='ksh') or (Pos('ksh ',scr)=1) then
      exezk:='Korn Shell';

    if (scr='sh') or (Pos('sh ',scr)=1) then
      exezk:='Bourne Shell';

    if (scr='bash') or (Pos('bash ',scr)=1) then
      exezk:='Bourne Again Shell';

    if (scr='csh') or (Pos('csh ',scr)=1) then
      exezk:='C Shell';

    if (scr='tcsh') or (Pos('tcsh ',scr)=1) then
      exezk:='Tenex C Shell';

    if (scr='zsh') or (Pos('zsh ',scr)=1) then
      exezk:='zsh Shell';

    if (scr='zsh') or (Pos('zsh ',scr)=1) then
      exezk:='zsh Shell';

    if (scr='awk' ) or (Pos('awk ' ,scr)=1)
    or (scr='gawk') or (Pos('gawk ',scr)=1)
    or (scr='nawk') or (Pos('nawk ',scr)=1)
     then
      exezk:='awk';

    if (scr='perl') or (Pos('perl ',scr)=1) then
      exezk:='Perl';

    if (scr='lite') or (Pos('lite ',scr)=1) then
      exezk:='lite [mSQL]';

    if (scr='python') then
      exezk:='Python';


    ausschrift(exezk+textz_dat__leerzeichen_Script^,signatur);

    test_shar(p);

    w1:=puffer_pos_suche(p,' >~/~;chmod +x ~/~;~/~ $*;rm ~/~;exit',80);
    if w1<>nicht_gefunden then
     begin
       ausschrift('ELFpack / Arpad Gereoffy',packer_dat);
       einzel_laenge:=w1+Length(' >~/~;chmod +x ~/~;~/~ $*;rm ~/~;exit'#$0a);
     end;
  end;

procedure smpzipse(const p:puffertyp);
  var
    o:longint;
  procedure anzeige(i:word_norm;a:boolean);
    begin
      if a then
        begin
          exezk:=datei_lesen__zu_zk_l(analyseoff+o,p.d[i]);
          if exezk<>'' then
            ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
        end;
      Inc(o,p.d[i]);
    end;
  begin
    if (p.d[3]<1) or (p.d[3]>3) then Exit;
    ausschrift('Simplyzip / Dirk Paehl',packer_dat);
    o:=$12;
    anzeige( 9,true);
    anzeige(10,false);
    anzeige(11,true);
    anzeige(13,true);
    einzel_laenge:=o+1+8;
  end;

procedure sql;
  var
    o,e                 :dateigroessetyp;
  begin
    o:=analyseoff;
    e:=o+MinDGT(einzel_laenge,5000);
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        if exezk='' then Continue;
        if Pos('--',exezk)=1 then Continue;
        exezk:=gross(exezk);
        if (Pos('DELETE FROM',exezk)=1)
        or (Pos('INSERT INTO',exezk)=1)
        or (Pos('DROP',exezk)=1)
         then
          begin
            ausschrift('Structured Query Language',compiler);
            Exit;
          end
        else
          Exit;
      end;
  end;

procedure ecsmt_lst;
  var
    o,e                 :dateigroessetyp;
    zaehler             :word_norm;
  begin
    if einzel_laenge>20000 then
      Exit;

    if not textdatei then Exit;

    zaehler:=0;
    o:=analyseoff;
    e:=o+einzel_laenge;
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        if exezk='' then Continue;
        if Pos(';',exezk)=1 then Continue;

        (* 'cmd ','patch ' *)
        if  (Pos('backup ',exezk)=1)
        or ((Pos('unzip ',exezk)=1) and ((Pos(' \',exezk)<>0) or (Pos('''\',exezk)<>0)))
        or  (Pos('copy ',exezk)=1)
        or ((Pos('call ',exezk)=1) and (Pos('_',exezk)<>0))
        or ((Pos('include ',exezk)=1) and (Pos('.lst',exezk)<>0))
        or  (Pos('note ',exezk)=1)
        or  (Pos('pause ',exezk)=1)
        or  (Pos('erase \\',exezk)=1)
        or  (Pos('erase .\',exezk)=1)
        or  (Pos('attrib -r -s -h',exezk)=1)
        or  (Pos('address cmd ',exezk)=1)
        or  (Pos('msg ',exezk)=1)
         then
          Inc(zaehler)
        else
          Exit;
      end;

    if zaehler<=0 then
      Exit;

    ausschrift('eComstation Maintenance tool',compiler);

    o:=analyseoff;
    while o<e do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(exezk));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        if Pos('note ',exezk)<>1 then Continue;
        Delete(exezk,1,Length('note '));
        ausschrift_x(in_doppelten_anfuerungszeichen(leer_filter(exezk)),beschreibung,absatz);
      end;

  end;


procedure bink_video(const p:puffertyp);
  begin
    ausschrift('Bink video / RAD Game Tools '+str0(longint_z(@p.d[$14])^)+' * '+str0(longint_z(@p.d[$18])^)
              +', '+str0(longint_z(@p.d[$10])^)+' frames, '+str0(longint_z(@p.d[$1c])^)+' f/s',
              musik_bild);
  end;

procedure versuche_mpeg(const p:puffertyp); (* Alexx 2000 *)
  var
    sh                  :dateigroessetyp;
    p2                  :puffertyp;
  const
    st                  :array [0..$f] of string[6]=
      ('30',
       '23.976', {1 NTSC encapsulated film rate }
       '24',     {2 Standard international cinema film rate }
       '25',     {3 PAL (625/50) video frame rate }
       '29.97',  {4 NTSC video frame rate }
       '30',     {5 NTSC drop-frame (525/60) video frame rate }
       '50',     {6 double frame rate/progressive PAL }
       '59.94',  {7 double frame rate NTSC }
       '60',     {8 double frame rate drop-frame NTSC }
       '15',     {9}
       '30',
       '30',
       '30',
       '30',
       '30',
       '30');
  begin
    if not (p.d[3] in [$b3,$ba]) then Exit;

    (* Search for sequence header *)
    sh:=datei_pos_suche(analyseoff,analyseoff+MinDGT(einzel_laenge,3000),#$00#$00#$01#$b3);
    if sh=nicht_gefunden then
      Exit;

    datei_lesen(p2,sh,32);
    with p2 do
      ausschrift('MPEG video '+str0(d[4] shl 4+d[5] shr 4)
                +' * '        +str0((d[5] and $f) shl 8+d[6])
                +', '+st[d[7] and $f]+' f/s',musik_bild);

  end;


procedure ausschrift_rexx(s:string);
  begin
    while (s<>'') and (s[Length(s)]<' ') do Dec(s[0]);
    ausschrift(s,compiler);
  end;

procedure entschluessele_installshield_dateiname_oder_myresource1024(var p:puffertyp;const anfang,ende:integer_norm);
  const
    schluessel:array[0..7] of byte=($b3,$f2,$ea,$1f,$aa,$27,$66,$13);

  var
    zaehler             :word_norm;
    a7                  :byte;

  begin
    with p do
      for zaehler:=anfang to ende-1 do
        begin
          a7:=(zaehler-anfang) and 7;
          p.d[zaehler]:=ror8(p.d[zaehler] xor schluessel[7-a7],7-a7) xor schluessel[a7];
        end;

    if signaturen then
      signatur_anzeige('',p);

  end;


procedure myresource_1024_installshield(const o:dateigroessetyp;var l:dateigroessetyp;const aenderbar:boolean);
  var
    p:puffertyp;
  begin
    Ausschrift_X('InstallShield '+textz_dien__Selbstentpacker^,packer_dat,absatz);

    datei_Lesen(p,o,512);

    if bytesuche(p.d[0],'1234') then
      begin
        ausschrift_x('12345.. ',beschreibung,leer);
        Exit;
      end;

    entschluessele_installshield_dateiname_oder_myresource1024(p,$01c,$019a);

    (* Kennwort *)
    ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[$01c],#0,$28)),beschreibung,leer);
    (* EXE *)
    ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[$044],#0,$80)),beschreibung,leer);
    (* Titel *)
    ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[$0c4],#0,$50)),beschreibung,leer);
    (* Verzeichnis *)
    ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[$114],#0,$80)),beschreibung,leer);

    befehl_echo(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(p.d[$0c4],#0,$50)));

    is_sfx_pfad:=puffer_zu_zk_e(p.d[$114],#0,$80);

    if aenderbar then
      einzel_laenge:=longint_z(@p.d[0])^;

  end;


procedure install_shield_stub_archiv(const p:puffertyp);
  var
    dateiname           :string;
    dien_puffer         :puffertyp;
  begin
    if (p.d[0]<8) or (p.d[0]>140)
    or (p.d[4]=0) or (p.d[5]=0)
    or (p.g<=4)
     then
      Exit;

    if longint_z(@p.d[p.d[0]+8])^>einzel_laenge then
      Exit; (* vielleich ein BruchstÅck *)

    dien_puffer.g:=p.g-4;
    Move(p.d[4],dien_puffer.d[0],dien_puffer.g);

    entschluessele_installshield_dateiname_oder_myresource1024(dien_puffer,0,dien_puffer.g-1);

    (* PGP553~1.EXE: 'Images\Disk1\setup.exe' *)
    dateiname:=puffer_zu_zk_l(dien_puffer.d[0],p.d[0]);
    if (    ist_ohne_steuerzeichen_nicht_so_streng(dateiname)
        and ((pos('\',dateiname)<>0) or (pos('/',dateiname)<>0)))
    or (copy(dateiname,2,2)=':\')
    or (copy(dateiname,2,2)='..\')
     then
      begin
        ausschrift(in_doppelten_anfuerungszeichen(dateiname),beschreibung);

        if Pos(is_sfx_pfad,dateiname)=1 then
          Delete(dateiname,1,Length(is_sfx_pfad));

        einzel_laenge:=p.d[0]+12;
        merke_position(analyseoff+einzel_laenge+longint_z(@p.d[p.d[0]+8])^,0);
        befehl_erzeuge_verzeichnisse_rekursiv(dateiname);
        befehl_schnitt(analyseoff+einzel_laenge,longint_z(@p.d[p.d[0]+8])^,dateiname);
      end;

  end;

procedure phoenix_bitmap;
  var
    x,y,x2,y2,f:longint;
    p:puffertyp;
    o:longint;
    palette:boolean;
  begin
    o:=0;
    datei_lesen(p,analyseoff+o,$20);
    palette:=Odd(p.d[$3]);
    Inc(o,word_z(@p.d[4])^);
    datei_lesen(p,analyseoff+o,$20);
    f:=word_z(@p.d[0])^;
    if palette then
      palette:=(f>=1) and (f<=16);

    if palette then
      begin
        x:=word_z(@p.d[0])^;
        y:=word_z(@p.d[2])^;
        x2:=word_z(@p.d[2+4*f+0])^;
        y2:=word_z(@p.d[2+4*f+2])^;
        if (x2<8) or (x2>1024)
        or (y2<8) or (y2>1024) then
          if  (x>=8) and (x<=1024)
          and (y>=8) and (y<=1024) then
            palette:=false;
      end;

    if palette then
      begin
        Inc(o,2+4*f);
        datei_lesen(p,analyseoff+o,$20);
      end;

    if not palette then
      f:=16; (* 2^4 *)

    x:=word_z(@p.d[0])^;
    y:=word_z(@p.d[2])^;
    if (x>=8) and (x<=1024) and (y>=8) and (y<=1024) then
      if einzel_laenge=o+8+x*y div 2 then
        bild_format_filter('Phoexix BIOS BitMap',
                            x,y,f,-1,false,true,anstrich);
  end;

procedure debug_comp_id(const p:puffertyp);

  begin
    ausschrift('debuginfo?',bibliothek);
    (* @comp.id-Teil *)
    einzel_laenge:=$20+$12*longint_z(@p.d[0])^;
    (* Symboltabelle *)
    einzel_laenge:=einzel_laenge+x_longint__datei_lesen(analyseoff+einzel_laenge);
    einzel_laenge:=AndDGT(einzel_laenge+3,not 3)
  end;

procedure acpi_dsdt(const p:puffertyp;const t:string);

  function version(i:word_norm):string;
    var
      s:string[4];
    begin
      if (longint_z(@p.d[i])^=0) or (longint_z(@p.d[i])^=-1) or (longint_z(@p.d[i])^=$20202020) then
        version:=''
      else
        begin
          s:=leer_filter(puffer_zu_zk_e(p.d[i],#0,4));
          if (Length(s)>Length(#$97)) and ist_ohne_steuerzeichen_nicht_so_streng(s) then
            version:=' '+in_doppelten_anfuerungszeichen(s)
          else
            version:=' '+hex_longint_min(longint_z(@p.d[i])^);
        end
    end;
  begin
    ausschrift(t+version_x_y(p.d[8],0),bibliothek);
    if (longint_z(@p.d[4])^>=$1c) and (longint_z(@p.d[4])^<einzel_laenge) then
      einzel_laenge:=longint_z(@p.d[4])^;

    exezk:='';
    if (p.d[$0a]<>0) and (p.d[$0a]<>$20) then
      exezk:=          in_doppelten_anfuerungszeichen(leer_filter(puffer_zu_zk_e(p.d[$0a],#0,6)));
    if (p.d[$10]<>0) and (p.d[$10]<>$20) then
      exezk:=exezk+' '+in_doppelten_anfuerungszeichen(leer_filter(puffer_zu_zk_e(p.d[$10],#0,8)));
    exezk:=exezk+version($18);
    if exezk<>'' then ausschrift_x(exezk,beschreibung,absatz);

    if p.d[8]>=1 then
      begin
        exezk:='';
        if (p.d[$1c]<>0) and (p.d[$1c]<>$20) then
          exezk:=          in_doppelten_anfuerungszeichen(leer_filter(puffer_zu_zk_e(p.d[$1c],#0,4)));
        exezk:=exezk+version($20);
        if exezk<>'' then ausschrift_x(exezk,beschreibung,absatz);
      end;

  end;

procedure acpi_facs(const p:puffertyp;const t:string);
  begin
    ausschrift(t,bibliothek);
    if (longint_z(@p.d[4])^>=$40) and (longint_z(@p.d[4])^<einzel_laenge) then
      einzel_laenge:=longint_z(@p.d[4])^;
  end;

function cpu_microcode(const p:puffertyp;var einzel_laenge:dateigroessetyp):boolean;
  var
    l                   :word_norm;
  begin
    (* 00 Header Version  (1)
       04 Patch ID
       08 DATE ($12311999)
       0c CPUID (stepping)
       10 Checksum
       14 Loader Version (1?)
       18 Product(s)
       1C ?
       20 LÑnge wenn<>$800 *)

    l:=longint_z(@p.d[$20])^;
    if l=0 then l:=$800;

    if (l<$800) or (l>einzel_laenge) or (l>32*1024) then Exit;

    if (l and $7ff)<>0 then Exit;

    if  bytesuche(p.d[0],#$01#$00#$00#$00)
    and (word_z(@p.d[$8])^>=$1990)
    and (word_z(@p.d[$8])^<=$2090)
    and (        p.d[$a]  >=$01  )
    and (        p.d[$a]  <=$31  )
    and (        p.d[$b]  >=$01  )
    and (        p.d[$b]  <=$12  ) then
      begin
        cpu_microcode:=true;
        ausschrift('CPU micro code ['+Copy(hex_word(word_z(@p.d[$8])^),2,4)
                  +'-'+Copy(hex(p.d[$b]),2,2)
                  +'-'+Copy(hex(p.d[$a]),2,2)+']',bibliothek);
        ausschrift_x('CPUID='+hex_word(word_z(@p.d[$c])^)
                    +' Patch ID='+hex_longint(longint_z(@p.d[4])^)
                   {+' Loader='+hex_longint(longint_z(@p.d[$14])^) immer 1?}
                    +' Product='+hex_longint(longint_z(@p.d[$18])^)
                       ,beschreibung,absatz);

        (* product: $00=PGA?
                    $01=SECS2
                    $02=Mini-Cart
                    $04=SLOT2=SECC?
                    $08=uFC-PGA
                    $10=PPGA(2)
                    $20=uFC-PGA(2)
                    $80=uFC-PGA         *)

        if (einzel_laenge>=l+1+$800)
        and bytesuche__datei_lesen(analyseoff+l,#$00#$01#$00#$00#$00) then
          einzel_laenge:=l+1
        else
          einzel_laenge:=l;
      end
    else
      cpu_microcode:=false;
  end;

function mime_encode(const o0:dateigroessetyp;var l:dateigroessetyp;const verschachtelt:boolean;const prefix:string):boolean;
  var
    ignoreres           :boolean;
    zeilennummer        :word_norm;
    o                   :dateigroessetyp;
    encoding,
    dateiname_mies,
    dateiname_gut,
    description,
    content_type,
    boundary,
    naechste,
    zeile,zeile_gross   :string;
    anao,
    elo,
    b1,b2               :dateigroessetyp;

  procedure zuweisung(const schluesselwort:string;var ergebnis:string);
    var
      w1                :word_norm;
      r                 :string;
    begin
      for w1:=2 to Length(zeile_gross)-Length(schluesselwort)-1 do
        begin
          if  (zeile_gross[w1-1] in [';',' '])
          and bytesuche(zeile_gross[w1],schluesselwort)
          and (zeile_gross[w1+Length(schluesselwort)] in [' ','=']) then
            begin
              r:=leer_filter(Copy(zeile,w1+Length(schluesselwort),255));
              if r='' then Continue;
              if r[1]<>'=' then Continue;
              Delete(r,1,1);
              r:=leer_filter(r);
              if r='' then Continue;
              if r[1]='"' then
                begin
                  Delete(r,1,1);
                  if Pos('"',r)<>0 then
                    SetLength(r,Pos('"',r)-1);
                end
              else
                if Pos(' ',r)<>0 then
                  SetLength(r,Pos(' ',r)-1);
              ergebnis:=r;
            end;
        end;
    end; (* zuweisung *)

  begin
    if Length(prefix)>20 then Exit;
    zeilennummer:=0;
    o:=o0;
    zeile:='';
    encoding:='';
    dateiname_mies:='';
    dateiname_gut:='';
    description:='';
    content_type:='';
    boundary:='';
    while (o<o0+l) and (o>=o0) and (zeilennummer<15) do
      begin
        Inc(zeilennummer);
        naechste:=datei_lesen__zu_zk_zeilenende(o);
        IncDGT(o,Length(naechste));
        weiter_bis_zum_naechsten_zeilenanfang(o);
        tabexpand(naechste);

        if (naechste<>'') and (naechste[1]=' ') then
          begin
            zeile:=zeile+naechste;
            Continue;
          end;


        zeile_gross:=gross(zeile);
        if zeile_gross='' then
          begin
          end
        else
        (* 'MIME-VERSION: ' *)
        if bytesuche(zeile_gross[1],'CONTENT-LOCATION:') then
          begin
            Delete(zeile,1,Length('CONTENT-LOCATION:'));
            dateiname_mies:=leer_filter(zeile)
          end
        else
        if bytesuche(zeile_gross[1],'CONTENT-TRANSFER-ENCODING:') then
          begin
            Delete(zeile,1,Length('CONTENT-TRANSFER-ENCODING:'));
            encoding:=leer_filter(zeile);
          end
        else
        if bytesuche(zeile_gross[1],'CONTENT-DISPOSITION:') then
          begin (* deglucker 0.4 stonehead 1999.01.04 *)
            Delete(zeile,1,Length('CONTENT-DISPOSITION:'));
            zeile_gross:=gross(zeile);
            zuweisung('FILENAME',dateiname_gut)
          end
        else
        if bytesuche(zeile_gross[1],'CONTENT-TYPE:') then
          begin
            Delete(zeile,1,Length('CONTENT-TYPE:'));
            zeile:=leer_filter(zeile);
            zeile_gross:=gross(zeile);
            zuweisung('NAME',dateiname_gut);
            zuweisung('BOUNDARY',boundary);
            if (Length(boundary)<3) and (boundary<>'-') then boundary:='';
            if Pos(';',zeile)<>0 then SetLength(zeile,Pos(';',zeile)-1);
            if Pos(' ',zeile)<>0 then SetLength(zeile,Pos(' ',zeile)-1);
            content_type:=leer_filter(zeile);
          end
        else
        if bytesuche(zeile_gross[1],'CONTENT-DESCRIPTION:') then
          begin
            Delete(zeile,1,Length('CONTENT-DESCRIPTION:'));
            zeile:=leer_filter(zeile);
            (* UMAIL *)
            if zeile<>'' then
              if (zeile[1]='<') and (zeile[Length(zeile)]='>') then
                zeile:=Copy(zeile,2,Length(zeile)-2);
            description:=zeile;
          end;

        if not ist_ohne_steuerzeichen_nicht_so_streng(naechste) then
          Break;

        if naechste='' then
          begin

            exezk:=' ';
            if dateiname_gut<>'' then
              begin
                if verschachtelt then
                  exezk_anhaengen(                               dateiname_gut )
                else
                  exezk_anhaengen(in_doppelten_anfuerungszeichen(dateiname_gut));
              end
            else
            if dateiname_mies<>'' then
              begin
                if verschachtelt then
                  exezk_anhaengen(                               dateiname_mies )
                else
                  exezk_anhaengen(in_doppelten_anfuerungszeichen(dateiname_mies));
              end
            else
            {if Pos('MESSAGE/',gross(content_type))=1 then}
            if content_type<>'' then
              begin
                if verschachtelt then
                  exezk_anhaengen(                               content_type )
                else
                  exezk_anhaengen(in_doppelten_anfuerungszeichen(content_type));
              end;

            zeile_gross:=gross(encoding);
            if  (zeile_gross<>'')
            and (zeile_gross<>'7BIT') and (zeile_gross<>'7-BIT')
            and (zeile_gross<>'8BIT') and (zeile_gross<>'8-BIT')
             then
              begin
                exezk_anhaengen(' (');
                exezk_anhaengen(encoding);
                exezk_anhaengen(')');
              end;

            if l-(o-o0)>10000 then
              if zeile_gross='BASE64' then
                begin
                  exezk_anhaengen(' (~');
                  (* Base64: 4*6 Bit->3x8 Bit, 80 Zeichne je Zeile (82 Byte) *)
                  (* 4*82*1024/(3*80)~=1400 *)
                  b1:=o+1024;
                  weiter_bis_zum_naechsten_zeilenanfang(b1);
                  zeile:=datei_lesen__zu_zk_zeilenende(b1);
                  b2:=b1+Length(zeile);
                  weiter_bis_zum_naechsten_zeilenanfang(b2);
                  exezk_anhaengen(str0_DGT(DivDGT((l-(o-o0))*Length(zeile)*3,1024*(b2-b1)*4)));
                  exezk_anhaengen(' KiB)');
                end;

            if verschachtelt then
              begin
                if (dateiname_gut <>'')
                or (dateiname_mies<>'')
                {or (Pos('MESSAGE/',gross(content_type))=1)}
                or (content_type<>'')
                 then
                  ausschrift_x(prefix+' '+exezk,packer_dat,absatz)

              end
            else
              ausschrift(prefix+'MIME encode'+exezk,packer_dat);

            if (description<>'') and (description<>dateiname_gut) and (description<>dateiname_mies) then
              begin
                description:=in_doppelten_anfuerungszeichen(description);
                if verschachtelt then Insert('  ',description,1);
                ausschrift_x(prefix+description,beschreibung,leer);
              end;

            mime_encode:=true;
            if zeile_gross='BINARY' then
              l:=o-o0;

            if gross(content_type)='MESSAGE/RFC822' then
              begin
                anao:=analyseoff;
                elo:=einzel_laenge;
                analyseoff:=o;
                einzel_laenge:=l-(o-o0);
                sendmail('',true,prefix+'  ');
                analyseoff:=anao;
                einzel_laenge:=elo;
              end
            else
            if (Pos('MULTIPART/',gross(content_type))=1) and (boundary<>'') then
              begin
                Insert('--',boundary,1);
                repeat
                  b1:=datei_pos_suche(o,o0+l,boundary);
                  if b1=nicht_gefunden then
                    Break; (* Fehler *)
                  if bytesuche__datei_lesen(b1,boundary+'--') then
                    Break; (* Ende von Multipart *)
                  IncDGT(b1,Length(boundary));
                  weiter_bis_zum_naechsten_zeilenanfang(b1);
                  b2:=datei_pos_suche(b1,o0+l,boundary);
                  if b2=nicht_gefunden then
                    Break; (* Fehler *)
                  elo:=b2-b1;
                  ignoreres:=mime_encode(b1,elo,true,prefix+'  ');
                  o:=b2;
                until false;
              end;
            Exit;
          end;

        zeile:=naechste;
      end;
    mime_encode:=false;
  end;

procedure sierra_drv(const p:puffertyp);
  const
    drv_typ:array[0..5] of string[8]=
     ('Graphics',
      'Music',
      'Audio',
      'Joystick',
      {'Mouse',}'Keyboard',
      'Memory');
  var
    i,o:word_norm;
  begin
    ausschrift('Sierry driver',bibliothek);
    if (p.d[8]>=Low(drv_typ)) and (p.d[8]<=High(drv_typ)) then
      exezk:=drv_typ[p.d[8]]
    else
      exezk:=str0(p.d[8]);
    o:=9;
    for i:=1 to 2 do
      begin
        if o>=$100 then Break;
        exezk:=exezk+': '+in_doppelten_anfuerungszeichen(puffer_zu_zk_pstr(p.d[o]));
        o:=o+1+p.d[o];
      end;
    ausschrift_x(exezk,beschreibung,absatz);
  end;

function lies_longint7777(const p:puffertyp;i:word_norm):longint;
  begin
    lies_longint7777:=
        p.d[i  ] shl (3*7)
       +p.d[i+1] shl (2*7)
       +p.d[i+2] shl (1*7)
       +p.d[i+3] shl (0*7);
  end;

function lies_longint777(const p:puffertyp;i:word_norm):longint;
  begin
    lies_longint777:=
        p.d[i  ] shl (2*7)
       +p.d[i+1] shl (1*7)
       +p.d[i+2] shl (0*7);
  end;

function lies_word77(const p:puffertyp;i:word_norm):word_norm;
  begin
    lies_word77:=
        p.d[i  ] shl (1*7)
       +p.d[i+1] shl (0*7);
  end;

procedure id3(const p:puffertyp);
  var
    o,l1,l2:longint;
    p2:puffertyp;
    i,flags:word_norm;
  begin
    (* Version *)
    if (p.d[3]<1)or (p.d[3]>=20) or (p.d[4]>=99)
    or (p.d[6]>=$80) or (p.d[7]>=$80) or (p.d[8]>=$80) or (p.d[9]>=$80) then Exit;
    l1:=lies_longint7777(p,6)+10;
    if l1>einzel_laenge then Exit;
    einzel_laenge:=l1;
    ausschrift('ID3 [2.'+str0(p.d[3])+'.'+str0(p.d[4])+']',signatur);
    (* p.d[5].7: unsync .6:extended header .5:experimental .4:footer *)

    if Odd(p.d[5] shr 4) then IncDGT(einzel_laenge,10); (* footer *)

    if p.d[3]>4 then Exit; (* nur ID3v2.(2|3|4).x bekannt *)

    (* implementation ohne unsync *)
    if Odd(p.d[5] shr 7) then Exit;

    o:=10;
    if Odd(p.d[5] shr 6) then (* extended header? -fÅr ID3V2.4.x - 2.3x ist unverstÑndlich. *)
      begin
        datei_lesen(p2,analyseoff+o,6);
        l2:=lies_longint7777(p2,0);
        Inc(o,l2);
      end;

    while (o<l1) and (o>=0) do
      begin
        datei_lesen(p2,analyseoff+o,4+4+2);
        exezk:=puffer_zu_zk_e(p2.d[0],#0,4);
        if Length(exezk)<2 then Exit;
        for i:=1 to Length(exezk) do
          if not (exezk[i] in ['0'..'9','A'..'Z']) then Exit;

        case p.d[3] of
          2:
            begin
              exezk:=puffer_zu_zk_l(p2.d[0],3);
              for i:=1 to Length(exezk) do
                if not (exezk[i] in ['0'..'9','A'..'Z']) then Exit;
              l2:=lies_longint777(p2,3);
              Inc(o,3+3);
              flags:=0;
            end;
          3:
            begin
              exezk:=puffer_zu_zk_l(p2.d[0],4);
              for i:=1 to Length(exezk) do
                if not (exezk[i] in ['0'..'9','A'..'Z']) then Exit;
              l2:=lies_longint7777(p2,4);
              Inc(o,4+4+2);
              flags:=m_word(p2.d[8]);
            end;
          4:
            begin
              exezk:=puffer_zu_zk_l(p2.d[0],4);
              for i:=1 to Length(exezk) do
                if not (exezk[i] in ['0'..'9','A'..'Z']) then Exit;
              l2:=lies_longint7777(p2,4);
              Inc(o,4+4+2);
              flags:=m_word(p2.d[8]);
            end;
        else
          Exit;
        end;

        if l2<=0 then Exit; (* ">=1 Byte" *)

        if (exezk[1]='T')
        and (l2>0)
        and (not Odd(flags shr 4)) (* nicht zlib *)
        and (not Odd(flags shr 3)) (* nicht verschlÅsselt *)
        and (not Odd(flags shr 2)) (* unsync *)
         then
          begin
            datei_lesen(p2,analyseoff+o,Min(l2,512));
            case p2.d[0] of
              0:exezk_anhaengen(': '+puffer_zu_zk_e(p2.d[1],#0,Min(l2,255)));
          (*  1: UTF-16 *)
          (*  2: UTF-16BE *)
          (*  1: UTF-8 *)
            end;
          end;

        ausschrift_x(exezk,normal,absatz);
        Inc(o,l2);
      end;

  end;

function  id3ende:boolean;
  var
    p:puffertyp;
    l1:longint;
  begin
    id3ende:=false;
    datei_lesen(p,analyseoff+einzel_laenge-10,10);
    with p do
      if (d[3]>=1) and (d[3]<=20)
      and Odd(d[5] shr 4) (* mit Footer *)
      and (d[6]<128) and (d[7]<128) and (d[8]<128) and (d[9]<128) then
          begin
            l1:=lies_longint7777(p,6)+20;
            if einzel_laenge>l1 then
              begin
                einzel_laenge:=einzel_laenge-l1;
                id3ende:=true;
              end;
          end;
  end;

procedure ausschrift_watcom(const p:puffertyp;i,l:word_norm);
  var
    w1                  :word_norm;
  begin
    (* p.g=0... l:=Min(l,p.g-i); *)
    exezk:=puffer_zu_zk_e(p.d[i],#0,l);

    w1:=Pos('All',exezk);
    if w1<>0 then
      SetLength(exezk,w1-1);

    for w1:=1 to Length(exezk) do
      if (exezk[w1]<' ') or (exezk[w1]>=#$7f) then
        begin
          SetLength(exezk,w1-1);
          Break;
        end;

    w1:=Pos('Portions',exezk); (* sybase *)
    if w1=0 then
      w1:=Pos('(c) Copyright by',exezk);
    if w1<>0 then
      Insert(^M^J,exezk,w1);

    ausschrift(exezk,compiler);
  end;

procedure ASN1(const o0:dateigroessetyp);
  type
    tag_class_typ       =(tag_universal,tag_application,tag_context_specific,tag_private);

  var
    p2                  :puffertyp;
    objekt_id_angezeigt :boolean;

  procedure lies_asn1(const tiefe:word;const anfang:dateigroessetyp;var ende:dateigroessetyp);
    var
      tag_class         :tag_class_typ;
      constructed       :boolean;
      tag               :longint;
      len               :longint;
      subseq_octet,b    :byte;
      indefinite        :boolean;
      w1,z1             :word;
      val               :longint;
      o,oe,ol           :dateigroessetyp;

    begin
      o:=anfang;
      datei_lesen(p2,o,20);
      w1:=0;
      tag_class:=tag_class_typ(p2.d[w1] shr 6);
      constructed:=Odd(p2.d[w1] shr 5);
      tag:=p2.d[w1] and $1f;
      (* Tag 0..30 *)
      if tag<>$1f then
        begin
          Inc(w1);
        end
      else (* tag>=31 *)
        begin
          tag:=0;
          Inc(w1);
          repeat
            tag:=(tag shl 7)+(p2.d[w1-1] and $7f);
            Inc(w1)
          until Odd(p2.d[w1-1] shr 7)
        end;
      (* LÑnge *)
      if (p2.d[w1] shr 7)=0 then
        begin (* kurzform, definit *)
          indefinite:=false;
          len:=p2.d[w1] and $7f; (* sowiso Null *)
          Inc(w1);
        end
      else
        begin (* langform, auch indefinite Form *)
          subseq_octet:=p2.d[w1] and $7f;
          Inc(w1);
          len:=0;
          indefinite:=subseq_octet=0;
          while subseq_octet>0 do
            begin
              len:=(len shl 8)+p2.d[w1];
              Inc(w1);
              Dec(subseq_octet);
            end;
        end;

      o:=o+w1;

      if constructed then
        begin
          if indefinite then
            repeat
              if o>analyseoff+einzel_laenge then Break;
              if bytesuche__datei_lesen(o,#$00#$00) then
                begin (* end-of-contets octets *)
                  IncDGT(o,2);
                  Break;
                end;
              lies_asn1(tiefe+1,o,oe);
              o:=oe;
            until false
          else
            begin
              ol:=o+len;
              while o>ol do
                begin
                  lies_asn1(tiefe+1,o,oe);
                  o:=oe;
                end;
            end;
        end
      else
        begin (* primitive *)
          (*ausschrift(hex_DGT(anfang)+': '+hex_longint(tag)+' Lenght='+hex_longint(len),normal);*)
          if tag_class=tag_universal then
            case tag of
             (* 1 boolean
                2 integer
                3 bitstring
                4 octetstring
                5 null
                6 object identifier
                7 object descriptor
                8 external
                9 real
               10 enumerated
               12..15 reserved
               16 sequence
               17 set
               18..22,25..27 string
               23,24 time *)


              $06: (* ObjectIdentifier *)
                begin
                  (* 2a 86 48 86 f7 0d 01 07 02
                   ->1 2 840 113549 1 7 2
                   =$01 $02 $348          $1bb8d $ 1 $ 7 $2
                   =        6 shr7+$48    ($377 shr 7)+$0d
                   =        6 shr7+$48    ($377 shr 7)+$0d
                                          6:77:0d  *)
                  val:=0;
                  w1:=0;

                  exezk:='';
                  z1:=0;
                  if not objekt_id_angezeigt then
                    for w1:=0 to len-1 do
                      begin
                        b:=byte__datei_lesen(o+w1);
                        val:=(val shl 7)+(b and $7f);
                        if (b shr 7)=0 then
                          begin

                            (* 0 *)
                            if exezk='' then
                              begin
                                case val div 40 of
                                  0:
                                    case val of
                                      0*40+0:exezk:='ccitt recommendation ';
                                      0*40+1:exezk:='ccitt question ';
                                      0*40+2:exezk:='ccitt administration ';
                                      0*40+3:exezk:='ccitt network-operator ';
                                    else
                                             exezk:='ccitt '+str0(val mod 40)+' ';
                                    end;
                                  1:
                                    case val of
                                      1*40+0:exezk:='iso standard ';
                                      1*40+1:exezk:='iso registration-authority ';
                                      1*40+2:exezk:='iso member-body ';
                                      1*40+3:exezk:='iso identified-organization ';
                                    else
                                             exezk:='iso '+str0(val mod 40)+' ';
                                    end;
                                  2:
                                    begin
                                             exezk:='joint-iso-ccitt '+str0(val mod 40)+' ';
                                    end;
                                else
                                    exezk:=str0(val div 40)+' '+str0(val mod 40)+' ';
                                end
                              end
                            else (* 1 *)
                            if exezk='iso member-body ' then
                              case val of
                                840:exezk_anhaengen('us ');
                              else
                                    exezk_anhaengen(str0(val)+' ');
                              end
                            else (* 2 *)
                            if exezk='iso member-body us ' then
                              begin
                                if val=113549 then
                                  exezk_anhaengen('rsadsi ')
                                else
                                  exezk_anhaengen(str0(val)+' ');
                              end
                            else (* 3 *)
                            if exezk='iso member-body us rsadsi ' then
                              case val of
                                1:exezk_anhaengen('pkcs ');
                              else
                                       exezk_anhaengen(str0(val)+' ');
                              end
                            else (* 4 *)
                            if exezk='iso member-body us rsadsi pkcs ' then
                              exezk_anhaengen('pkcs'+str0(val)+' ')
                            else (* ... *)
                              exezk_anhaengen(str0(val)+' ');

                            val:=0;
                          end;

                      end;

                  if exezk<>'' then
                    begin
                      ausschrift_x(exezk,beschreibung,absatz);
                      objekt_id_angezeigt:=true;
                    end;

                end;
              (* nur $16 is am besten, sonst wir bei MS-W9x-EXE zu viel angezeigt *)
              {//$12..$16-1,$19..$1b,}
              $16{, (* IA5String *)
              $17}: (* UTCTime *)
                ausschrift_x((* str0(tag)+': '+*)datei_lesen__zu_zk_l(o,len),beschreibung,absatz);
            end;
          IncDGT(o,len);
        end;

      ende:=o;
    end;


  var
    arbeit              :dateigroessetyp;
    ende                :dateigroessetyp;
  begin
    ausschrift('Abstract Syntax Notation One / ITU',bibliothek);
    if not langformat then Exit;

    objekt_id_angezeigt:=false;
    arbeit:=o0;
    repeat
      lies_asn1(0,arbeit,ende);
      arbeit:=ende;
      if ende>=analyseoff+einzel_laenge then Break;
    until bytesuche__datei_lesen(arbeit,#$00);
    einzel_laenge:=arbeit-analyseoff;
  end;

procedure postscript(const dateityp:string;const p:puffertyp;i:word_norm;const font:boolean);

  var
    o,oe,f:dateigroessetyp;

  procedure ps_f_anzeige(const element:string);
    var
      w1,w2:word_norm;
    begin
      f:=datei_pos_suche(o,oe,element);
      if f<>nicht_gefunden then
        begin
          exezk:=datei_lesen__zu_zk_zeilenende(f+Length(element));
          loesche_muell(exezk,'COPYRIGHT ');
          loesche_muell(exezk,'(C) ');
          loesche_muell(exezk,'ALL RIGHTS RESERVED.');
          loesche_muell(exezk,'IS A REGISTERED TRADEMARK OF ADOBE SYSTEMS INCORPORATED.');
          loesche_muell(exezk,'CONFIDENTIAL.');
          loesche_muell(exezk,'AS AN UNPUBLISHED WORK BY BITSTREAM INC.');
          w1:=1;
          for w2:=1 to Length(exezk) do
            if exezk[w2]='(' then
              Inc(w1)
            else
            if exezk[w2]=')' then
              begin
                Dec(w1);
                if w1=0 then
                  begin
                    SetLength(exezk,w2-1);
                    Break;
                  end;
              end;
          exezk:=leer_filter(exezk);
          if exezk<>'' then
            ausschrift_x(exezk,beschreibung,leer);
        end;
    end;

  procedure ps_anzeige(const element,benennung:string);
    var
      pr:byte;
    begin
      pr:=0;
      f:=datei_pos_suche_zeilenanfang(o,oe,element);
      if f=nicht_gefunden then
        begin
          pr:=1;
          f:=datei_pos_suche_zeilenanfang(o,oe,'%'+element);
        end;
      if f<>nicht_gefunden then
        begin
          exezk:=leer_filter(datei_lesen__zu_zk_zeilenende(f+pr+Length(element)));
          if exezk<>'' then
            ausschrift_x(benennung+' '+exezk,beschreibung,leer);
        end;
    end;

  begin
    exezk:=puffer_zu_zk_zeilenende(p.d[i],p.g-i);
    if Pos(':',exezk)<>0 then
      Delete(exezk,1,Pos(':',exezk))
    else
      exezk:='';
    exezk:=leer_filter(exezk);
    if exezk<>'' then
      begin
        if font then
          exezk:=' '+in_doppelten_anfuerungszeichen(exezk)
        else
          exezk:=' ['+exezk+']';
      end;
    ausschrift(dateityp+exezk,musik_bild);
    if not langformat then Exit;

    o :=analyseoff+i;
    oe:=analyseoff+MinDGT(einzel_laenge,2000);


    if font then
      begin
        ps_f_anzeige('/FullName (');
        ps_f_anzeige('/Notice (');
      end
    else
      begin
        ps_anzeige('%Title:',textz_datx__Titel_doppelpunkt^);
        ps_anzeige('%Creator:',textz_datx__Erzeuger_doppelpunkt^);
        ps_anzeige('%CreationDate:',textz_datx__erstellt_doppelpunkt^);
      end;

  end;

procedure winhelp_picture(const werkzeug:string);
  var
    i,a                 :word_norm;
    o                   :longint;
    p                   :puffertyp;
    zk                  :string;
    x,y,f               :longint;
  begin
    ausschrift(werkzeug,musik_bild);
    if not langformat then Exit;

    a:=x_word__datei_lesen(analyseoff+2);
    for i:=1 to a do
      begin
        o:=x_longint__datei_lesen(analyseoff+2+2+(i-1)*4);
        datei_lesen(p,analyseoff+o,512);
        case p.d[0] of
          5:zk:='DDB';
          6:zk:='DIB';
          8:zk:='metafile';
        else
          Continue;
        end;

        x:=-1;
        y:=-1;
        f:=-1;

        if (p.d[0] in [5,6]) and (p.d[6]=1) then
          begin
            x:=word_z(@p.d[$8+2])^ div 2;
            y:=word_z(@p.d[$8+4])^ div 2;
            f:=-1;
          end
        else
        if (p.d[0] in [5,6]) and (p.d[6]=2) then
          begin
            x:=word_z(@p.d[$8+0])^ div 2;
            y:=word_z(@p.d[$8+2])^ div 2;
            f:=-1;
          end
        else
         (* Meta??? *);

        bild_format_filter(zk,x,y,f ,-1,false,true,absatz);

      end;
  end;

procedure macintosh_hfs(o:longint);
  var
    p:puffertyp;
  begin
    datei_lesen(p,analyseoff+o,512);
    with p do
      if bytesuche(d[0],'BD')
      and (m_longint(d[$14])>=$200)
      and (m_longint(d[$14])<=$800) then
            begin
              ausschrift('Macintosh HFS '+in_doppelten_anfuerungszeichen(puffer_zu_zk_pstr(d[$24])),packer_dat);
              (* bei surfeu fehlen dann etwa $1600
              einzel_laenge:=m_word(d[$12])*m_longint(d[$14]);*)
            end;
  end;

procedure versuche_iso9660;
  begin
    if bytesuche__datei_lesen(analyseoff+16*2048+$00,#$01'CD001') then
      cd_spur_datei(2048,$00)
    else
    if bytesuche__datei_lesen(analyseoff+16*2352+$10,#$01'CD001') then
      cd_spur_datei(2352,$10)
    else
    if bytesuche__datei_lesen(analyseoff+16*2352+$18,#$01'CD001') then
      cd_spur_datei(2352,$18)
    else
    (* disc world 2 *)
    if bytesuche__datei_lesen(analyseoff+16*2336+$08,#$01'CD001') then
      cd_spur_datei(2336,$08)
    else
    (* "sacred cd1.mdf" (836M) "sacred cd1.mds" (3K) *)
    if bytesuche__datei_lesen(analyseoff+16*2448+$10,#$01'CD001') then
      cd_spur_datei(2448,$10);
  end;

function tbfence_pw(const p:puffertyp):string;
  var
    zk                  :string;
    _ax,_bx,_cx,pa      :smallword;
  begin
    _bx:=$A35D;
    _cx:=$0008;
    zk:='';
    repeat
      pa:=word_z(@p.d[$E+16-_cx*2])^;
      asm (*&Alters EAX,EBX,ECX*)
        mov ax,_ax
        mov bx,_bx
        mov cx,_cx
        mov ax,pa
        xchg al,ah
        rol ax,cl
        xor ax,bx
        mov bx,pa
        dec cx
        mov _ax,ax
        mov _bx,bx
        mov _cx,cx
      end;
      if Lo(_ax)>0 then zk:=zk+Chr(Lo(_ax))
      else _ax:=0;
      if Hi(_ax)>0 then zk:=zk+Chr(Hi(_ax))
      else _ax:=0;
    until (_ax=0) or (_cx=0);
    tbfence_pw:=zk;
  end;

function pkver(const flag,ver:byte):string;
  var
    tmp:string;
  begin
    tmp:='PKLite '
           +Chr(Ord('0')+flag and $0f)
           +'.'
           +Chr(Ord('0')+ver div 10)
           +Chr(Ord('0')+ver mod 10);
    if (flag and $10)<>0 then
      tmp:=tmp+textz_dien__minus_Extra^;
    pkver:=tmp;
  end;

function wwpack_version;
  var
    tmpzk:string[30];
  begin
    case v of
       9:tmpzk:='3.00/1 PR'; (* ---- *)
      10:tmpzk:='3.00 P';
      11:tmpzk:='3.00 PU';

      12:tmpzk:='3.01 P';
      13:tmpzk:='3.01 PU';

      14:tmpzk:='3.02 PR';
      15:tmpzk:='3.02 P';
      16:tmpzk:='3.02 PU';

      17:tmpzk:='3.03 PR';
      18:tmpzk:='3.03 P';
      19:tmpzk:='3.03 PU';
      20:tmpzk:='3.03 PP';

      21:tmpzk:='3.04/04A PR';
      22:tmpzk:='3.04/04A P';
      23:tmpzk:='3.04/04A PU';
      24:tmpzk:='3.04/04A PP';

      25:tmpzk:='3.05A PR';
      26:tmpzk:='3.05· P';
      27:tmpzk:='3.05· PU';
    else
      tmpzk:=textz_dien__unbekannte_Version_klammer^+str0(v)+')¯';
    end;

    wwpack_version:=tmpzk;
  end;

function double_density_pass(w:smallword):string;
  begin
    double_density_pass:='';
    if w=0 then exit;
    w:=(w+$1234) xor $575F;
    double_density_pass:=' (PW: "'+Chr(Lo(w))+Chr(Hi(w))+'" [ALT+'+str0(Lo(w))+'] [ALT+'+str0(Hi(w))+'] )';
  end;

procedure bgi_text(const p:puffertyp);
  var
    z:word_norm;
  begin
    z:=0;
    while not (p.d[z]=$8) do
      Inc(z);
    while  p.d[z]=$8 do
      Inc(z);
    exezk:=puffer_zu_zk_e(p.d[z],#$1a,512-z);
    while (Length(exezk)>0) and (exezk[Length(exezk)] in [#$00,#$0a,#$0d]) do
      Dec(exezk[0]);

    ausschrift(exezk,beschreibung);
  end;

function username300_pw(const p:puffertyp):string;
  var
    zae                 :byte;
    tmpzk               :string[20];
  begin
    tmpzk:='';
    zae:=0;
    while p.d[zae+3]<>$0d do
      begin
        tmpzk:=tmpzk+chr(p.d[zae+3] xor (255-zae) xor p.d[0]);
        Inc(zae);
      end;
    username300_pw:=tmpzk;
  end;

procedure c_copy_run(posi:dateigroessetyp;const zusatztext,ausweichtext:string;
                     const attribut:aus_attribute;const min_laenge:byte;const ende,enthalten:string);
  var
    copyrunpuffer       :puffertyp;
    zk                  :string;
    z                   :word_norm;

  begin
    if exe then
      IncDGT(posi,longint(exe_kopf.kopfgroesse)*16);
    datei_lesen(copyrunpuffer,posi+analyseoff,512);

    z:=0;
    zk:='';
    while (copyrunpuffer.d[z]<32) and (z<10) do
      Inc(z);

    if z<10 then
      begin

        zk:=puffer_zu_zk_e(copyrunpuffer.d[z],ende,120);

        zk:=filter(zk);

        if (enthalten<>'') and (pos(enthalten,zk)=0) then
          zk:='';
      end;

    if (Length(zk)<min_laenge) and (ausweichtext<>'') then
      ausschrift(ausweichtext+textz_dien__fraglich_oder_veraendert^,attribut)
    else
      ausschrift(zk+zusatztext,attribut);
  end;

function pctools_pw(const p:string):string;
  const
    (*                    ' !              0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_      '  *)
    schluessel:string[70]='This^Anti-Virus^was^written^by^CARMEL^Software^Engineering^1990,pira?T';
  var
    tmp                 :string;
    po                  :byte;
    um                  :byte;
    bb                  :byte;
  begin
    tmp[0]:=#16;
    for po:=16 downto 1 do
      begin
        um:=Pos(p[po],schluessel);
        for bb:=Max(um,Ord('A')-Ord(' ')+1) to Ord('Z')-Ord(' ')+1 do
          if schluessel[bb]=p[po] then
            begin
              um:=bb;
              Break;
            end;
        if um=0 then
          tmp[17-po]:='?'
        else
          tmp[17-po]:=Chr(32+um-1);
      end;

    pctools_pw:=textz_dien__z_punkt_B_punkt_doppelpunkt_leer_anf^+leer_filter(tmp)+'"';
  end;

procedure pgp(const p:puffertyp;const po,laenge:word_norm);
  var
    pv                  :word;
    variante            :string[30];
  begin
    pv:=puffer_pos_suche(p,^J'Version:',laenge);
    if pv=nicht_gefunden then
      exezk:=''
    else
      begin
        exezk:=puffer_zu_zk_e(p.d[pv+1],^j,512-pv-1);
        if (Length(exezk)>0) and (exezk[Length(exezk)]=^m) then
          Dec(exezk[0]);
        exezk:='"'+exezk+'"'
      end;

    variante:='(??? ¯)';

    if bytesuche(p.d[po],'PUBLIC') then
      variante:=textz_dien__oeffentlicher_Schluessel^;

    if bytesuche(p.d[po],'MESSAGE') then
      variante:=textz_dien__Nachricht^;

    if bytesuche(p.d[po],'SIGN') then
      variante:=textz_dien__Unterschrift^;

    ausschrift('PGP '+variante+' / Philip Zimmermann '+exezk,signatur);
  end;

end.

