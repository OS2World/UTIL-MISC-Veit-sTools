(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_kopf;

interface

procedure kopftext_nullen;
procedure kopftext_berechnen;
procedure kopf_signaturen;

implementation

uses
  typ_eiau,
  typ_dien,
  typ_die2,
  typ_die3,
  typ_spra,
  typ_ausg,
  typ_type,
  typ_varx,
  typ_var;


procedure kopftext_nullen;
  begin
    (*kopftext:='';*)
    FillChar(kopftext,SizeOf(kopftext),0);
    kopftextlaenge:=0;
  end;

procedure kopftext_berechnen;
  var
    kopf_tmp_puffer:puffertyp;
  begin
    kopftext_nullen;

    (* Kopf EXE >=$1c *)
    if exe_kopf.relooffset<$1c then
      exe_kopf.relooffset:=$1c;

    if longint(exe_kopf.relooffset)>longint(exe_kopf.kopfgroesse)*16 then (* VIZ *)
      exe_kopf.relooffset:=longint(exe_kopf.kopfgroesse)*16;


    if exe_kopf.relooffset=$1c then
      begin
        kopftextstart:=analyseoff+exe_kopf.relooffset+longint(exe_kopf.relokationspositionen)*4;
        kopftextlaenge:=DGT_zu_longint(longint(exe_kopf.kopfgroesse)*16-kopftextstart+analyseoff);
      end
    else
      begin
        kopftextstart:=analyseoff+$1c;
        kopftextlaenge:=DGT_zu_longint(exe_kopf.relooffset-(kopftextstart-analyseoff));
      end;

    if kopftextlaenge>0 then
      begin
        if kopftextlaenge>255 then
          begin
            datei_lesen(kopf_tmp_puffer,kopftextstart,512);
            if kopf_tmp_puffer.d[511]=0 then
              kopftextlaenge:=511;
          end
        else
          begin
            datei_lesen(kopf_tmp_puffer,kopftextstart,kopftextlaenge);
            kopf_tmp_puffer.d[kopftextlaenge]:=0;
          end;

        while (kopftextlaenge>0)
          and (kopftextlaenge<512)
          and (kopf_tmp_puffer.d[kopftextlaenge-1]=0) do
           dec(kopftextlaenge);

        if kopftextlaenge>255 then
          kopftext:=puffer_zu_zk_l(kopf_tmp_puffer.d[0],255)
        else
          kopftext:=puffer_zu_zk_l(kopf_tmp_puffer.d[0],kopftextlaenge);
      end
    else
      kopftext_nullen;

    if (length(kopftext)>10) and (kopftext[length(kopftext)-4]=#0) and (kopftext[length(kopftext)-5]=#26) then
      dec(kopftext[0],6);

    if bytesuche(kopftext[1],#$01#$00#$FB) then
      begin
        ausschrift(
           'TLink '
          +str0(ord(kopftext[4]) div 16)
          +'.'
          +str0(ord(kopftext[4]) mod 16)
          +' / Borland',compiler);
        kopftext_nullen;
      end;

    if bytesuche(kopftext[1],' iCE') then
      begin
        (* 0.3.4 *)
        ausschrift('Intel Complex Emulator / JauMing Tseng',signatur);
        kopftext_nullen;
      end;

    if bytesuche(kopftext[1+4],'-MKEXE') then
      begin
        (* TR MKEXE *)
        (* -MKEXE 1997. Ld- *)
        ausschrift(puffer_zu_zk_l(kopftext[1+4+1],14),signatur);
        kopftext_nullen;
      end;

    if bytesuche(kopftext[1],' TEU')
    or bytesuche(kopftext[1],' SHG')
     then
      begin
        ausschrift('TEU / JVP',signatur);
        kopftext_nullen;
      end;

    if bytesuche(kopftext[1],'MJ.C') then
      ausschrift('EXEShape / Ming Jei Chen',signatur);

    relo_off:=analyseoff+exe_kopf.kopfgroesse;

  end;

procedure kopf_signaturen;
  var
    kopf_puffer         :puffertyp;
    w1                  :word_norm;
  begin

    datei_lesen(kopf_puffer,analyseoff+longint(exe_kopf.kopfgroesse)*16,512);

    if bytesuche(kopf_puffer.d[0],#$55#$aa) then
      rom_modul(kopf_puffer,analyseoff+longint(exe_kopf.kopfgroesse)*16,'',einzel_laenge);

    if bytesuche(kopf_puffer.d[0],'Libr') then
      c_copy_run(analyseoff,'','',compiler,15,#0,'');

    if bytesuche(kopf_puffer.d[0],'Copy') then
      c_copy_run(analyseoff,'','',compiler,15,#0,'');

    if bytesuche(kopf_puffer.d[0],'(C) Copy') then
      (* QBACKUP *)
      ausschrift(puffer_zu_zk_e(kopf_puffer.d[0],#0,80),beschreibung);

    if not hersteller_gefunden then
      begin
        w1:=puffer_pos_suche(kopf_puffer,'VESA',50);
        if (w1<>nicht_gefunden) and (chr(kopf_puffer.d[0]) in textzeichen) then
          ausschrift(puffer_zu_zk_e(kopf_puffer.d[0],#0,255),beschreibung);
      end;

    if bytesuche(kopf_puffer.d[0],'bl')
    or bytesuche(kopf_puffer.d[0],'bm')
    or bytesuche(kopf_puffer.d[0],'br') then
      ausschrift('Basic '+textz_kopf__Kopf^,compiler);

    if bytesuche(kopf_puffer.d[0],'FW2') then
      ausschrift('Framework II / Aston Thate ',bibliothek);

    if bytesuche(kopf_puffer.d[0],'FW3') then
      ausschrift('Framework III / Aston Thate ',bibliothek);

    if bytesuche(kopf_puffer.d[0],#$FF#$FF#$FF#$FF) and (kopf_puffer.d[4]<>$FF) then
      begin
        geraete_treiber(kopf_puffer,'EXE/SYS '+textz_kopf__Geraetetreiber^);
        exe_sys_datei:=wahr;
      end;

    w1:=puffer_pos_suche(kopf_puffer,'zyxg',500);
    if (w1<>nicht_gefunden)
    and (kopf_puffer.d[w1+4] in [0..4,255]) then
      begin
        inc(w1,$13);
        if kopf_puffer.d[w1-1]<>0 then
          dec(w1);
        ausschrift('GEM: '+puffer_zu_zk_e(kopf_puffer.d[w1],#0,80),bibliothek);
        (* dauert sonst zu lange in TYP_POEM *)
        hersteller_gefunden:=true;
      end;
  end;

end.

