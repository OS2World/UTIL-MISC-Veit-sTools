(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_ende;

interface

uses
  typ_type;

procedure ende_suche(const ende_pos:dateigroessetyp);

var
  exe_crypter_gefunden  :string;

implementation

uses
  typ_var,
  typ_eiau,
  typ_dien,
  typ_die2,
  typ_ausg,
  typ_varx,
  typ_dat,
  typ_for1,
  typ_for2,
  typ_for3,
  typ_for4,
  typ_for5,
  typ_bios,
  typ_spra,
  typ_posm,
  typ_entp;


procedure ende_suche(const ende_pos:dateigroessetyp);
  var
    ende_puffer         :puffertyp;
    herstell_org        :boolean;
    zip_start           :longint;
    sauce_laenge        :longint;
    ende_tmp_puffer     :puffertyp;
    l1                  :longint;
    w1,w2               :word_norm;
    g                   :dateigroessetyp;
  const
    zh                  =128;
  label
    zip_bearbeitet;
  begin
    exe_crypter_gefunden:='';
    if ende_pos<zh then Exit;

    datei_lesen(ende_puffer,ende_pos-zh,zh);

    if bytesuche(ende_puffer.d[zh-$28],'$EndOfFileCheckSum'#$00) then
      intel_itk;

    if bytesuche(ende_puffer.d[zh-10],'3DI') then
      id3ende;
      with ende_puffer do
        if (d[zh-10+3]>=1) and (d[zh-10+3]<=20)
        and (d[zh-10+6]<128) and (d[zh-10+7]<128) and (d[zh-10+8]<128) and (d[zh-10+9]<128) then
          begin
          end;

    if ende_pos>500 then
    if bytesuche(ende_puffer.d[zh-8],#$00#$00#$00'?'#$00#$00) then
      begin
        if bytesuche__datei_lesen(ende_pos-$114,'STOP'#0) then
          winbatch_windowware;
      end;

    (* borland resource backlink *)
    if bytesuche(ende_puffer.d[zh-(4+8)],'fbbl') then
      begin
        g:=ende_pos-x_dateigroessetyp(ende_puffer.d[zh-8]);
        if g>analyseoff then
          einzel_laenge:=g-analyseoff;
      end;

    if bytesuche(ende_puffer.d[zh-(4+4)],'FBBL') then
      begin
        g:=ende_pos-x_longint(ende_puffer.d[zh-4]);
        if g>analyseoff then
          einzel_laenge:=g-analyseoff;
      end;

    (* MKXDSKF / C.Langanke *)
    if bytesuche(ende_puffer.d[zh-$1e],'DX???'#$00)
    and (longint_z(@ende_puffer.d[zh-8])^=analyseoff) then
      begin
        einzel_laenge:=longint_z(@ende_puffer.d[zh-4])^;
        befehl_schnitt(analyseoff,einzel_laenge,erzeuge_neuen_dateinamen('.dsk'));
      end;

    if bytesuche(ende_puffer.d[zh-$12],#$00#$00'0123456789012345') then
      exp1;

    if bytesuche(ende_puffer.d[zh-$6],#0#0'DWV') then
      digiwrap;

    if bytesuche(ende_puffer.d[zh-$10],#$20#$20#$20#$20#$20#$20#$20#$20#$20#$20#$20#$20'?'#$00#$00#$00) then
      if bytesuche__datei_lesen(ende_pos-$635,'INSTALL.DAT') then
        ydkj4_flash_archiv;

    if analyseoff>0 then
      if bytesuche(ende_puffer.d[zh-$04],#$00'?'#$00#$00) then
        if longint_z(@ende_puffer.d[zh-$04])^=analyseoff then
          versuche_exebundle;

    if bytesuche(ende_puffer.d[zh-12],'TDPUESIV') then
      vise_updater;

    if   bytesuche(ende_puffer.d[zh-8],#$00#$00'GIPEND')
    and (analyseoff>=longint_z(@ende_puffer.d[zh-$1a])^) then
      ghostinstaller;

    if bytesuche(ende_puffer.d[zh-$1f],'ARDI-(C)1991-????-Daniel Valot') then
      ardi;

    if bytesuche(ende_puffer.d[zh-$10],'5FWS?????'#$00#$00#$00)
    or bytesuche(ende_puffer.d[zh-$10],'VPC2?????'#$00#$00#$00)
    or bytesuche(ende_puffer.d[zh-$10],'VRC:?????'#$00#$00#$00)
     then
      swf5(longint_z(@ende_puffer.d[zh-$10+8])^,true,longint_z(@ende_puffer.d[zh-$10+4])^);

    if bytesuche(ende_puffer.d[zh-$14],'PACK??????'#$00#$00'??'#$00#$00'?'#$00#$00#$00) then
      smartsetup;

    if bytesuche(ende_puffer.d[zh-$34],'PGPSEA'#$00) then
      pgpsea(longint_z(@ende_puffer.d[zh-$34+$0c])^);

    (* MP3 tag *)
    if bytesuche(ende_puffer.d[zh-128],'TAG')
    and (ende_puffer.d[zh-128+3+30-1] in [0,ord(' ')])
    and (ende_puffer.d[zh-128+3+30+30-1] in [0,ord(' ')])
    and (einzel_laenge>2000)
     then
      DecDGT(einzel_laenge,128);

    if bytesuche(ende_puffer.d[zh-12],'XFILELIB')
    and (longint_z(@ende_puffer.d[zh-4])^=einzel_laenge-12) then
      semtex_xfilelib(longint_z(@ende_puffer.d[zh-4])^);

    if bytesuche(ende_puffer.d[zh-10],#$09'0000') then
      if analyseoff=ziffer(10,puffer_zu_zk_pstr(ende_puffer.d[zh-10])) then
        zupmaker;

    if  (longint_z(@ende_puffer.d[zh-4])^<=einzel_laenge-26)
    and (longint_z(@ende_puffer.d[zh-4])^>=einzel_laenge-50)
     then
      rkive(ende_puffer,zh,$11);

    if  (longint_z(@ende_puffer.d[zh-6])^<=einzel_laenge-26)
    and (longint_z(@ende_puffer.d[zh-6])^>=einzel_laenge-60)
    and (ende_puffer.d[zh-2]=0)
     then
      rkive(ende_puffer,zh-2,ende_puffer.d[zh-1] xor Ord('R'));

    if bytesuche(ende_puffer.d[zh-2],'RK')
    and (einzel_laenge>5000)
    and (ende_puffer.d[zh-2-1] in [1..10])
    and (ende_puffer.d[zh-2-2] in [1..10])
     then
      rk_filearchiver(ende_puffer,zh);

    if bytesuche(ende_puffer.d[zh-$1e],#$0b#$00'RUNTIME.PUB'#$01) then
      neobook(longint_z(@ende_puffer.d[zh-4])^,ende_pos-4);


    if  (einzel_laenge>200)
    and bytesuche(ende_puffer.d[zh-$2b],'CP2.00')
     then
      compress_ii204(ende_puffer,zh-$2b);


    if bytesuche(ende_puffer.d[zh-5],#$00#$00'DWC') then
      dwc(word_z(@ende_puffer.d[zh-7])^,ende_pos);

    if bytesuche(ende_puffer.d[zh-5],#$00'EMF!') then
      emf(word_z(@ende_puffer.d[zh-$c])^,ende_pos);

    if bytesuche(ende_puffer.d[zh-$12],#$ef#$be#$ad#$de) then
      begin
        norton_av_archiv(ende_pos-$12);
        (* kann als letzte Datei ZIP enthalten -> doppelte Auflistung *)
        exit;
      end;

    if bytesuche(ende_puffer.d[zh-$24],'UPX!')
    or bytesuche(ende_puffer.d[zh-$20],'UPX!') (* 0.70 *)
     then
      begin
        if analyseoff<longint_z(@ende_puffer.d[zh-$04])^ then
          einzel_laenge:=longint_z(@ende_puffer.d[zh-$04])^-analyseoff
        else
          ausschrift_upx_version_dat(ende_puffer,ende_puffer,zh-$24,0,255);
        hersteller_gefunden:=true;
      end;


    if bytesuche(ende_puffer.d[zh-$1c],'VRX ENC'#0) then
      vxrexx;

    if bytesuche(ende_puffer.d[zh-$18],'WATCOM patch level ') then
      begin
        DecDGT(einzel_laenge,$18);

        (* VRXEDIT.EXE *)
        if bytesuche(ende_puffer.d[zh-$1c-$18],'VRX ENC'#0) then
          vxrexx;
      end;

    if bytesuche(ende_puffer.d[zh-7+3],'NS') then
      (* Windows 0.98 DOS-Programme Textblock *)
      if  (ende_puffer.d[zh-7+0] in [Ord('A')..Ord('Z')])
      and (ende_puffer.d[zh-7+1] in [Ord('A')..Ord('Z')])
      and (ende_puffer.d[zh-7+2] in [Ord('A')..Ord('Z')])
      and (word_z(@ende_puffer.d[zh-7+5])^<=einzel_laenge) then
        begin
          if word_z(@ende_puffer.d[zh-7+5])^<einzel_laenge then
            merke_position(analyseoff+einzel_laenge-word_z(@ende_puffer.d[zh-7+5])^,datentyp_unbekannt);
        end;


    if bytesuche(ende_puffer.d[zh-3],'PT?') and (analyseoff+einzel_laenge=dateilaenge) then
      zap_zip_archiv(ende_pos-7,word_z(@ende_puffer.d[zh-5])^,(ende_puffer.d[zh-7] and bit02)=bit02,ende_puffer.d[zh-1]);

    if bytesuche(ende_puffer.d[zh-5],'eNh'#$1b) then
      jbf_enh(analyseoff+einzel_laenge,ende_puffer.d[zh-1]); (* typ_for2 *)

    if bytesuche(ende_puffer.d[zh-29],'934730434875') then
      if longint_z(@ende_puffer.d[zh-4])^=0 then
        instalit(longint_z(@ende_puffer.d[zh-16])^,longint_z(@ende_puffer.d[zh-16-8])^)
      else
        instalit(longint_z(@ende_puffer.d[zh- 4])^,longint_z(@ende_puffer.d[zh- 4-8])^);

    if bytesuche(ende_puffer.d[zh-30],'ENIGMA') then
      ausschrift('Enigma / Hans Steiner',signatur);

    if (AndDGT(einzel_laenge,$7f)=0) and bytesuche(ende_puffer.d[zh-5],#$1a#$1a#$1a#$1a#$1a) then
      ausschrift('Worstar Text',musik_bild);

    if bytesuche(ende_puffer.d[zh-4],'DKNJ') then
      begin
        (* Zeiger auf RTPatch-Daten *)
        pocket_soft:=falsch;

        (* SFX mit Titeltext? *)
        if bytesuche(ende_puffer.d[zh-12-2],#$00#$10) then
          (* nur Titeltext, nicht Erfolgsmeldung *)
          ansi_anzeige(longint_z(@ende_puffer.d[zh-12])^,#0,
            ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
            absatz,wahr,wahr,unendlich,'');

        einzel_laenge:=longint_z(@ende_puffer.d[zh-8])^-analyseoff;
      end;

    if bytesuche(ende_puffer.d[zh-$20],#$01'??'#$01)
    and bytesuche(ende_puffer.d[zh-4],#$06'?'#$01#$ff) then
      ausschrift('Indy 4 / Lucas Arts "'+puffer_zu_zk_e(analysepuffer.d[0],#0,255)+'"',spielstand);

    if bytesuche(ende_puffer.d[zh-9],#$00'SaxSetup') then
      begin

        if longint_z(@ende_puffer.d[zh-$10])^=0 then
          l1:=longint_z(@ende_puffer.d[zh-$18])^
        else
          l1:=longint_z(@ende_puffer.d[zh-$38])^;

        if analyseoff<l1 then
          einzel_laenge:=l1-analyseoff
        else
          if longint_z(@ende_puffer.d[zh-$10])^=0 then
            saxsetup(longint_z(@ende_puffer.d[zh-$14])^,ende_pos-$18)
          else
            saxsetup_6(ende_pos-$38,ende_pos-$08);
      end;

    w1:=puffer_pos_suche(ende_puffer,'-----END PGP ',zh);
    if w1<>nicht_gefunden then
      pgp(ende_puffer,w1+13,zh-w1+13);


    if bytesuche(ende_puffer.d[zh-$10],#$ea'??????/??/??')
    or bytesuche(ende_puffer.d[zh-$10],#$b8#$ff#$ff#$cd#$e6'??/??/??')
    or bytesuche(ende_puffer.d[zh-$10],#$ea#$5b#$e0#$00#$f0)
    (* Phoenix (gepackt: ea 2f 3f 00 f0) *)
    or bytesuche(ende_puffer.d[zh-$10],#$ea'??'#$00#$f0#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff)
    (* OS/2 *)
    or bytesuche(ende_puffer.d[zh-$10],#$cd#$19'?????/??/')
    (* BOCHS x86 Emulator*)
    or bytesuche(ende_puffer.d[zh-$10],#$e9#$68#$e0#$00#$00)
    (* 38w2106a.rom, Phoenix[SystemSoft], 512 KB *)
    or bytesuche(ende_puffer.d[zh-$10],#$e9'??'#$00#$00#$00#$00#$00#$ea'??'#$00#$f0)
    (* Toshiba *)
    or (    bytesuche(ende_puffer.d[zh-$10],#$ea'??'#$00#$f0'??/')
        and (ende_puffer.d[zh-$05] in [Ord('8'),Ord('9')]))
    (* sanyo update - phoenix mit debugger *)
    or bytesuche(ende_puffer.d[zh-$10],#$ea'??'#$00#$fc'199?/??/??'#$00)
    (* intel wbinvd+jmp - P07-0014.BI6 *)
    or bytesuche(ende_puffer.d[zh-$10],#$0f#$09#$eb#$ce'??????????'#$fc'?')
    (* systemsoft dimm1175.ROM *)
    or bytesuche(ende_puffer.d[zh-$10],#$e9#$0d#$fe#$00#$00'??/??/')
     then
      begin
        ermittle_bios_hersteller(
          textz_ende__Bios_Abzugsdatei_klammer^+hex_word(DGT_zu_longint($100000-ende_pos+analyseoff) div 16)+
            +':$0000 .. $F000:$FFFF )',
          falsch,falsch,wahr,DGT_zu_longint(MinDGT(ende_pos,64*1024*1024)),DGT_zu_longint(MinDGT(einzel_laenge,64*1024*1024)));
      end;

    w1:=puffer_pos_suche(ende_puffer,'PK'#$05#$06,zh);
    if w1<>nicht_gefunden then
      if (w1>=9) and (bytesuche(ende_puffer.d[w1-9],'VENDDATA'))
      and (longint_z(@ende_puffer.d[w1+12])^=$2a)
       then
        begin
          ausschrift(textz_ende__fehlerhaftes_Zip_Archiv^+' (VendInfo.Diz)',dat_fehler);
          zip(ende_pos-zh+w1-$37,falsch,kein_art_prg_code);
        end
      else
        begin
          (* sinnvoll fÅr PEACE100.EXE *)
          zip_start:=longint_z(@ende_puffer.d[w1+$10])^; (* Anfang des Hauptverzeichnisses *)
          if (analyseoff<zip_start) and (zip_start<ende_pos) then (* vernÅnftiger Wert *)
            if bytesuche__datei_lesen(zip_start,'PK'#$01#$02) then
             begin
               (* Position des ZIP-Datenanfangs lesen *)
               zip_start:=x_longint__datei_lesen(zip_start+$2a);
               (* sinnvoll? *)
               if analyseoff<zip_start then
                 begin
                   einzel_laenge:=zip_start-analyseoff;
                   goto zip_bearbeitet;
                 end;
             end;

          if (einzel_laenge=0)
          or (einzel_laenge-zh+w1>0)
           then
            zip(ende_pos-zh+w1-longint_z(@ende_puffer.d[w1+12])^,falsch,kein_art_prg_code);

          zip_bearbeitet:
        end;


    (* TEST auf .RAW (SOX) *)
    if not hersteller_gefunden then
      begin
        w2:=0;
        for w1:=1 to zh do
          if ende_puffer.d[w1] in [$7d,$7e,$7f,$80] then
            inc(w2);

        if w2*2>zh then
          ausschrift(textz_ende__vermutlich_Klangdaten^,signatur);
      end;


    if bytesuche(ende_puffer.d[zh-14],#$84#$00'?'#$00#$84#$03#$84#$03#$fa#$03)
    and (puffer_anzahl_suche(ende_puffer,#$01,200)>15)
     then
      begin
        ausschrift('Transport Tycoon / Microprose "'+puffer_zu_zk_e(analysepuffer.d[0],#0,40)+'"',spielstand);
      end;

    if einzel_laenge>100 then
      if  (longint_z(@analysepuffer.d[0])^ =einzel_laenge-12) (* Kompimiert *)
      and (longint_z(@analysepuffer.d[4])^ >einzel_laenge+30) (* unkomprimiert *)
      and (longint_z(@ende_puffer.d[zh-4])^=einzel_laenge-12)
       then
        ausschrift('UpdateIt! / Innovative Data Concepts Incorporated',packer_dat);

    if  bytesuche(ende_puffer.d[zh-8],#$ff#$ff#$ff#$ff#$ff#$ff#$ff#$ff)
    and bytesuche(analysepuffer.d[0],#$ff'??'#$44#$00)
    and (analysepuffer.d[1]>=$f0)
    and ((analysepuffer.d[2] and $0f)=0)
     then
      ausschrift('MPEG [MP3?]',musik_bild);

    (* PKZIP 2.70 W TimeSink Install *)
    (* Zeiger auf Anfang des Archivkopfes *)
    if (   bytesuche(ende_puffer.d[zh-8],'TSI')
        or bytesuche(ende_puffer.d[zh-8],'TSW'))
    and (longint_z(@ende_puffer.d[zh-4])^=analyseoff)
    and (ende_puffer.d[zh-5] in [ord('0')..ord('9')]) (* Versionsnummer '1'/'2' *)
    and (longint_z(@analysepuffer.d[0])^<10)   (* andere Versionsnummer 3/4 *)
     then
      timesink_install(puffer_zu_zk_l(ende_puffer.d[zh-8],4));


    if (puffer_pos_suche(ende_puffer,'copyrite'#$00'.txt'#$00,zh)<>nicht_gefunden) then
      softpaq;

    Dec(herstellersuche);

    if bytesuche(ende_puffer.d[zh-$10],#$8d'?'#$0e#$01#$b9'??'#$81'???'+'??'#$e2#$f8#$c3) then
      begin
        case ende_puffer.d[zh-5] of
          $46:exezk:='si';
          $47:exezk:='di';
        else
              exezk:='??'
        end;
        ausschrift(textz_ende__VCL_Verschluesselung_Entschluesselungcode^
         +exezk+'/'+hex_word(word_z(@ende_puffer.d[zh-7])^)+']',virus);
      end;

    if bytesuche(ende_puffer.d[zh-$80],'SAUCE00') then
      begin
        ausschrift('SAUCE / ACiD Productions',beschreibung);
        ausschrift_tab(leer_filter(puffer_zu_zk_l(ende_puffer.d[zh-$80+7      ],35)));
        ausschrift_tab(leer_filter(puffer_zu_zk_l(ende_puffer.d[zh-$80+7+35   ],20)));
        ausschrift_tab(leer_filter(puffer_zu_zk_l(ende_puffer.d[zh-$80+7+35+20],20)));

        if longint_z(@ende_puffer.d[zh-$80+$5a])^<ende_pos-$80 then
          begin
            datei_lesen(ende_tmp_puffer,longint_z(@ende_puffer.d[zh-$80+$5a])^+1,5);
            if bytesuche(ende_tmp_puffer.d[0],'COMNT') then
              feldtext_anzeige(longint_z(@ende_puffer.d[zh-$80+$5a])^+1+5,64,
               DGT_zu_longint(DivDGT(ende_pos-$80-longint_z(@ende_puffer.d[zh-$80+$5a])^,64)),beschreibung);
          end;

        (*if longint_z(@ende_puffer.d[zh-$80+$5a])^+einzel_laenge=dateilaenge then*)
        if (longint_z(@ende_puffer.d[zh-$80+$5a])^=analyseoff  )
        or (longint_z(@ende_puffer.d[zh-$80+$5a])^=analyseoff+1)
        or (longint_z(@ende_puffer.d[zh-$80+$5a])^=analyseoff+2) (* VACUUM.EXE / Dark Fiber *)
         then
          hersteller_gefunden:=true;
      end;

    if bytesuche(ende_puffer.d[zh-$34],#$f0#$fd#$c5#$aa) then
      ausschrift('SCAN /AG / MCAFEE',signatur);

    if bytesuche(ende_puffer.d[zh-$0a],#$f0#$fd#$c5#$aa) then
      ausschrift('SCAN /AV / MCAFEE',signatur);

    if  bytesuche(ende_puffer.d[zh-5],'MsDos')
    and (ende_puffer.d[zh-5-2-2] in [ord('A')..ord('Z')])
    and (ende_puffer.d[zh-5-2-1] in [ord('A')..ord('Z')])
     then
      exe_crypter_gefunden:='"'+puffer_zu_zk_l(ende_puffer.d[zh-5-2-2],2)+'" '
       +str_(ende_puffer.d[zh-5-2],1)+'.'+str_(ende_puffer.d[zh-5-1],1)+' ¯';


    Inc(herstellersuche);

  end;

end.

