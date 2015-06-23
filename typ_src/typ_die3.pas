(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_die3;

interface

uses
  typ_type,
  typ_ausg;

procedure apack_code_mover(const p:puffertyp);
procedure amibios_grfx(const p:puffertyp);
procedure geraete_treiber(const k_puffer:puffertyp;const zk:string);
function verfolge_nullen(const nullwert:byte;laenge1,laenge2:dateigroessetyp):dateigroessetyp;
procedure xpack_le(var p:puffertyp);


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
  typ_spru,
  typ_varx,
  typ_poem,
  typ_posm,
  typ_xexe,
  typ_entp,
  typ_dat;


procedure apack_code_mover(const p:puffertyp);
  var
    dien_puffer         :puffertyp;
    aufruf              :word_norm;
  begin
     aufruf:=puffer_pos_suche(p,#$be'??'#$05'??'#$0e#$50#$6a,100);

     if aufruf=nicht_gefunden then exit;

     datei_lesen(dien_puffer,analyseoff+longint(codeoff_seg+word_z(@p.d[aufruf+3+1])^)*16+p.d[aufruf+8+1],100);

     if bytesuche(dien_puffer.d[0],#$b2#$80#$bd'??'#$50)
     or bytesuche(dien_puffer.d[0],#$2e#$01#$06'??'#$b2#$80#$bd'??'#$50)
      then
       (* aPack *)
       exit;

     if bytesuche(dien_puffer.d[0],#$b9'?'#$00#$51#$e8)

      then
       ausschrift('->XPACK XE / JauMing Tseng [dos/exe 1.3.*,1.4.*]',packer_exe);

  end;

procedure amibios_grfx(const p:puffertyp);
  var
    x,y,f:longint;
  begin
    x:=word_z(@p.d[$04])^;
    y:=word_z(@p.d[$14])^;
    f:=word_z(@p.d[$1a])^;
    if  (1<x) and (x<=4096)
    and (1<y) and (y<=4096)
    and (1<f) and (f<=16) then
      bild_format_filter('AMI BIOS Graphic',x,y,f,-1,false,true,anstrich);
  end;

procedure geraete_treiber(const k_puffer:puffertyp;const zk:string);
  var
    sys_puffer          :puffertyp;
    org_codeoff_off,
    org_codeoff_seg     :longint;
    k2_puffer           :puffertyp;
  begin
    if  bytesuche(k_puffer.d[0],#$ff#$ff#$ff#$ff#$14)
    and (longint_z(@k_puffer.d[8])^=einzel_laenge) then
      exit; (* OS/2 INI *)

    (* WDOS/X 0.95 PESTUB (im MZ-Overlay) *)
    (* aber nicht OS/2 FSFILTER.SYS       *)
    if (longint_z(@k_puffer.d[4])^=0)  then
      exit;

    ausschrift(zk,bibliothek);
    if odd(word_z(@k_puffer.d[4])^ shr 15) then
      ausschrift_x(textz_dien__Zeichen_Geraet^+' "'+puffer_zu_zk_l(k_puffer.d[10],8)+'"',beschreibung,absatz)
    else
      ausschrift_x(textz_dien__Block_Geraet^+' ['+str0(k_puffer.d[10])+textz_dien__einheiten_^,signatur,absatz);

    if bytesuche(k_puffer.d[$14],'SYSPACK') then
      begin
        ausschrift('SYSPACK / Vadim V. Vlasov',packer_exe);
        exit;
      end;

    if bytesuche(k_puffer.d[$14],#$0e#$2e#$ff#$36) then
      begin
        if bytesuche(k_puffer.d[$1d],#$33#$f6#$8b#$fe#$8c#$c8) then
          ausschrift('XPACK XE / JauMing Tseng [dos/sys 1.3.*,1.4.*]',packer_exe)
        else
          ausschrift('XPACK / JauMing Tseng [1.23..1.65 .SYS]',packer_exe);
        exit;
      end;

    if bytesuche(k_puffer.d[$14],#$2e#$89#$1e#$10) then
      begin
        ausschrift('Diet / Teddy Matsumoto [1.20 .SYS]',packer_exe);
        Exit;
      end;

    if bytesuche(k_puffer.d[$24],#$0e#$2e#$ff#$36#$12#$00#$1e#$06) then
      begin
        ausschrift('XPACK / JauMing Tseng [1.67.[f..m] .SYS]',packer_exe);
        Exit;
      end;

    if bytesuche(k_puffer.d[$24],#$0e#$6a#$12#$1e#$06#$60#$b8'??'#$bb#$06#$00#$2e#$89#$07) then
      begin
        ausschrift('XPACK / JauMing Tseng [1.67.[n..r] .SYS]',packer_exe);
        Exit;
      end;

    if bytesuche(k_puffer.d[$06],#$08#$00#$68'??'#$60#$be'??'#$bf'??'#$89#$f1) then
      begin
        (* pusha - 286+ *)
        case k_puffer.d[$1e] of
          $bd:ausschrift_upx_version(k_puffer,k_puffer,0    ,005,005,'dos/sys');
          $8b:ausschrift_upx_version(k_puffer,k_puffer,$2d-4,  0, 40,'dos/sys');
        else
              (* ?.?? ø *)
              ausschrift_upx_version(k_puffer,k_puffer,0    ,  0, 49,'dos/sys');
        end;
        Exit;
      end;

    (* Version 0.50+ *)
    if bytesuche(k_puffer.d[$06],#$0a#$00'??'#$60#$be'??'#$bf'??'#$89#$f1#$06#$1e#$07#$fd) then
      begin
        (* pusha - 286+ *)
        ausschrift_upx_version(k_puffer,k_puffer,$2d-4,50,255,'dos/sys');
        Exit;
      end;
    if bytesuche(k_puffer.d[$06],#$0a#$00'??'#$50#$53#$51#$52#$56#$57#$55#$be'??'#$bf'??'#$89#$f1#$06#$1e#$07#$fd) then
      begin
        (* push ... - 86+ *)
        ausschrift_upx_version(k_puffer,k_puffer,$2d-4,50,255,'dos/sys --8086');
        Exit;
      end;

    if bytesuche(k_puffer.d[$0b],#$50#$50#$55#$8b#$ec#$b8'??'#$89#$46#$04#$9c) then
      begin
        ausschrift('Compack [5.1]',packer_exe);
        exit;
      end;


    (*******************************************************)
    org_codeoff_off:=codeoff_off;
    org_codeoff_seg:=codeoff_seg;

    codeoff_off:=word_z(@k_puffer.d[6])^;
    if exe then
      codeoff_seg:=exe_kopf.kopfgroesse
    else
      codeoff_seg:=0;
    datei_lesen(k2_puffer,analyseoff+longint(codeoff_seg)*16+codeoff_off,512);

    trace(k2_puffer);

    if bytesuche(k2_puffer.d[0],#$50#$53#$51#$52#$1e#$06#$57#$e8#$00#$00#$5f#$83#$ef) then
      begin
        (* CPT20  SYS *)
        ausschrift('Copy Protector / A.Vodyanik [2.0]',packer_exe);
        exit;
      end;

    if bytesuche(k2_puffer.d[0],#$60#$be#$12#$00#$2e#$8b#$3e#$06#$00#$2e#$ff#$b5) then
      begin
        ausschrift('Crypt / Alex Lemenkov [2.0 .SYS]',packer_exe);
        exit;
      end;

    if bytesuche(k2_puffer.d[0],#$06#$60#$be'??'#$b9'??'#$fc#$8c#$ca#$ad#$8b#$f8#01#$15#$ad) then
      begin
        ausschrift('PRSYS / Veit Kannegieser [1999.12.09]',packer_exe);
        exit;
      end;

    codeoff_off:=org_codeoff_off;
    codeoff_seg:=org_codeoff_seg;
    (*******************************************************)

    hersteller_gefunden:=false;
    poly_emulator(poem_modus_sys);

    (*$IfDef ALT_CD_TEXT*)

    org_codeoff_off:=codeoff_off;
    org_codeoff_seg:=codeoff_seg;

    codeoff_off:=word_z(@k_puffer.d[8])^;
    if exe then
      codeoff_seg:=exe_kopf.kopfgroesse
    else
      codeoff_seg:=0;

    datei_lesen(sys_puffer,analyseoff+longint(codeoff_seg)*16+codeoff_off,512);
    w1:=puffer_pos_suche(sys_puffer,#$ea#$00#$00,$1f0);
    if w1<>nicht_gefunden then
      begin
        (*NEC,OAK CD-Treiber *)
        codeoff_off:=0;
        Inc(codeoff_seg,word_z(@sys_puffer.d[w1+1+2])^);

        datei_lesen(sys_puffer,analyseoff+longint(codeoff_seg)*16+codeoff_off,512);

        if sys_puffer.d[0]=$e8 then
          ansi_anzeige(analyseoff+longint(codeoff_seg)*16+codeoff_off+$10,#0
          ,ftab.f[farblos,hf]+ftab.f[farblos,vf],absatz,wahr,wahr,unendlich,'');
      end;
    codeoff_off:=org_codeoff_off;
    codeoff_seg:=org_codeoff_seg;
    (*$EndIf*)

  end;

function verfolge_nullen(const nullwert:byte;laenge1,laenge2:dateigroessetyp):dateigroessetyp;
  var
    dien_puffer         :puffertyp;
    posi                :dateigroessetyp;
    jetzt,
    zaehler             :word_norm;
  begin
    if laenge1>laenge2 then
      laenge1:=laenge2;

    posi:=0;
    while posi<laenge1 do
      begin
        (*$IfDef dateigroessetyp_comp*)
        if laenge1-posi>512 then
          jetzt:=512
        else
          jetzt:=Round(laenge1-posi);
        (*$Else*)
        jetzt:=laenge1-posi;
        if jetzt>512 then
          jetzt:=512;
        (*$EndIf*)
        datei_lesen(dien_puffer,analyseoff+posi,jetzt);
        with dien_puffer do
          for zaehler:=1 to jetzt do
            if d[zaehler-1]<>nullwert then
              begin
                verfolge_nullen:=posi+zaehler-1;
                Exit;
              end;
        IncDGT(posi,jetzt);
      end;
    verfolge_nullen:=posi; (* genug Nullwerte *)
  end;

procedure xpack_le(var p:puffertyp);
  begin
    with p do
      begin
        case d[2] of
          0:exezk:='1.2.0';
          1:exezk:='1.2.9,1.3.*,1.4.*';
        else
            exezk:='?.?.? ø';
        end;

        if d[$40]=0 then d[$40]:=3;
        exezk_anhaengen(' -i'+str0(d[$40]));
        if d[$41]=0 then d[$41]:=3;
        exezk_anhaengen(' -r'+str0(d[$41]));

        ausschrift('Xpack XE / JauMing Tseng [watcom/le '+exezk+']',packer_exe (*? packer_dat*));
        (* IMG + RELO *)
        einzel_laenge:=longint_z(@d[$8])^+longint_z(@d[$18])^;
      end;
  end;



end.
