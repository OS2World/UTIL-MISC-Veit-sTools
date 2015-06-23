(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_for1;

interface

uses
  typ_type;

type
  peter_sabath_zip=(kein_art_prg_code,art_code,prg_code);

procedure form;
procedure riff;
procedure rifx(const p:puffertyp);
procedure rifx_intel(const p:puffertyp);
procedure voc(dof:dateigroessetyp);
procedure dbase3(const dbf_kopf_puffer:puffertyp);
procedure arj(o:dateigroessetyp;reg_auswerten:boolean;reg_zahl:word);
procedure arc(const titel:string);
procedure lzh_sfx(o:dateigroessetyp;const titel:string);
procedure lzh(o:dateigroessetyp;const titel:string);
procedure kazip_kopf;
procedure zip(off:dateigroessetyp;vom_anfang:boolean;const art_install:peter_sabath_zip);
procedure rar(o:dateigroessetyp);
procedure pack_ibm(const o0:dateigroessetyp;const ver:integer_norm;const nicht_lesbar:string);
procedure tar(o:dateigroessetyp);
procedure stirling_neu(const p:puffertyp);
procedure stirling_setup(const p:puffertyp);
procedure stirling_alt(o:dateigroessetyp);
procedure hap3;
procedure ha(const p:puffertyp;const zusatz:string);
procedure hyper(const version:byte);
procedure zoo;
procedure amgc(const p:puffertyp);
procedure freeze;
procedure quantum(const qv_puffer:puffertyp);
procedure instalit(start_verzeichnis,start_info:dateigroessetyp);
procedure rnc;
procedure compress_ms(const cpuffer:puffertyp;const o0,l:dateigroessetyp;const namensvorschlag:string);
procedure pnpack(var ppuffer:puffertyp);
procedure diet_datendatei(const dpuffer:puffertyp;const version:string;ofs:word);
procedure mthd;
procedure cpz;
procedure cp_backup(const p:puffertyp);
procedure bdiff;
procedure quickfix;
procedure tiff(const o0,l:dateigroessetyp;const verschachtelt:string);
procedure mscf(const o0,l:dateigroessetyp);
procedure rtpatch(const p:puffertyp;const demo:string);
procedure sqwez;
procedure sqz(const dat_puffer:puffertyp);
procedure jfif(const p:puffertyp);
procedure exx(const exxp:puffertyp);
procedure genus_micro;
procedure finish_packer;
procedure qez;
procedure charc;
procedure gnuzip(const p:puffertyp);
procedure yac;
procedure wavpack(const erweiterung:string);
procedure swf5(anzahl_dateien:longint;sichtbar:boolean;const dir_laenge:longint);

implementation

uses
  typ_eiau,
  typ_ausg,
  typ_varx,
  typ_dien,
  typ_dat,
  typ_eas,
  typ_for0,
  typ_for5,
  typ_spra,
  typ_var,
  typ_entp,
  typ_posm,
  typ_zeic,
  zst;


{var
  form_puffer:puffertyp;}


procedure form;
  type
    formkopf            =
      packed record
        gel             :word;
        element_name    :array[1..4] of char;
        element_laenge  :array[1..4] of byte;
        rest            :array[9..SizeOf(puffertyp)-2] of byte;
      end;

  var
    gerade_angeordnet   :boolean;
    o                   :longint;
    sonderzk            :string;
    fpuffer             :puffertyp;
    zkt:
      record
        xx              :word;
        d               :array[0..10] of array[1..4] of char
      end absolute fpuffer;
    attri               :aus_attribute;
    freq                :longint;

  begin (* form *)
    o:=0;
    datei_lesen(fpuffer,analyseoff+o,20);
    gerade_angeordnet:=wahr;
    exezk:=textz_FORM_Dateityp^+zkt.d[2]+'"';
    attri:=signatur;

    if zkt.d[2]='ILBM' then
       begin
         exezk_anhaengen(textz_minus_Grafik^);
         attri:=musik_bild;
       end;

    if zkt.d[2]='ANIM' then
       begin
         exezk_anhaengen('- Animation');
         attri:=musik_bild;
       end;

    if zkt.d[2]='PBM ' then
       begin
         exezk_anhaengen(textz_minus_Grafik^);
         attri:=musik_bild;
       end;

    if zkt.d[2]='FTXT' then
       begin
         exezk_anhaengen(textz_minus_reiner_Text^);
         attri:=musik_bild;
       end;

    if zkt.d[2]='PICS' then
       begin
         exezk_anhaengen(textz_minus_QuickDraw_Grafik^);
         attri:=musik_bild;
       end;

    if zkt.d[2]='SCDH' then
       begin
         (* nicht geradzahlig *)
         exezk_anhaengen(' - Simcity 2000 / Maxis');
         attri:=spielstand;
         gerade_angeordnet:=falsch;
       end;

    if zkt.d[2]='AIFF' then
       begin
         (* exezk_anhaengen(' - Apple Grafik+Klang Archiv'); *)
         exezk_anhaengen(' - Audio Interchange Format File');
         attri:=musik_bild;
       end;

    if zkt.d[2]='8SVX' then
       begin
         exezk_anhaengen(' - Interchange Format File : '+textz_Klangdatei^);
         attri:=musik_bild;
       end;

    if (zkt.d[2]='SCEN') and (zkt.d[3]='NAME') then
       begin
         exezk_anhaengen(' - Dune 2');
         attri:=spielstand;
       end;

    if (zkt.d[1]=#$00#$00#$0b#$3a) and (zkt.d[2]='SAVE') and (zkt.d[3]='INFO') then
       begin
         exezk_anhaengen(' - Wing Commander 3 / ORIGIN');
         attri:=spielstand;
       end;

    if (zkt.d[2]='SAVE') and (m_longint(fpuffer.d[$10])+84969=einzel_laenge) then
      begin
        exezk_anhaengen(' - Privateer 2 "The Darkening" / ORIGIN');
        attri:=spielstand;
      end;

    if zkt.d[2]='GDOC' then
      begin
        exezk_anhaengen(' TrueSpectra PhotoGraphics');
        attri:=musik_bild;
      end;

    if (zkt.d[2]='DJVU') or (zkt.d[2]='PM44')
     then
      begin
        exezk_anhaengen(' DjVu / LizardTech');
        attri:=musik_bild;
      end;

    ausschrift(exezk,attri);

    einzel_laenge:=m_longint(fpuffer.d[4])+8;
    if zkt.d[2]='XDIR' then IncDGT(einzel_laenge,12); (* Ausnahme? *)
    if not langformat then Exit;

    exezk:='';
    o:=4+4+4; (* FROM+LÑnge+Typ *)

    while (o<einzel_laenge-1) and (analyseoff+o<dateilaenge) do
      begin
        datei_lesen(fpuffer,analyseoff+o,4+4+100);

        sonderzk:='';
        if ((formkopf(fpuffer).element_name='TEXT')
        or  (formkopf(fpuffer).element_name='NAME')
        or  (formkopf(fpuffer).element_name='CRED'))
          and (m_longint(fpuffer.d[4])<10000+55) then
          sonderzk:='"'+puffer_zu_zk_e(fpuffer.d[8],(* #0 *) #$1a,m_longint(fpuffer.d[4]))+'"';

        if (formkopf(fpuffer).element_name='CNAM')
         then
          sonderzk:='"'+puffer_zu_zk_e(fpuffer.d[9],#0,m_longint(fpuffer.d[4]))+'"';

        if formkopf(fpuffer).element_name='BMHD' then
          sonderzk:=textz_Bildformat_doppelpunkt^+str0(m_word(fpuffer.d[8]))+' * '+str0(m_word(fpuffer.d[10]))+' * '
           +str0(1 shl longint(fpuffer.d[$10]));

        if formkopf(fpuffer).element_name='TINY' then
          sonderzk:=textz_Voransicht^;

        if formkopf(fpuffer).element_name='CMAP' then
          sonderzk:=textz_RGB_Farbtabelle^;

        if formkopf(fpuffer).element_name='BODY' then (* ILBM *)
          sonderzk:=textz_Hauptdaten^;

        if formkopf(fpuffer).element_name='SSND' then (* AIFF *)
          sonderzk:=textz_form__Klangdaten^;

        if formkopf(fpuffer).element_name='COMM' then (* AIFF *)
          with formkopf(fpuffer) do
            begin
              freq:=m_word(rest[9+$0a]);
              case rest[9+$09] of
                $0e..$11: (* *8,*4,*2,*1 *)
                  freq:=freq shl (rest[9+$09]-$0e);
                $00..$0d:
                  freq:=freq shr ($0e-rest[9+$09]);
              else
                  freq:=0;
              end;

              sonderzk:=str0(rest[9+$07])+' Bit, '+str0(freq div 1000)+' kHz, ';
              case rest[9+1] of
                1:sonderzk:=sonderzk+'Mono';
                2:sonderzk:=sonderzk+'Stereo';
              else
                  sonderzk:=sonderzk+str0(rest[9+1])+textz_form__Kanaele^;
              end;

            end;

        if formkopf(fpuffer).element_name='ANNO' then (* AIFF SOX: vorheriger Dateiname *)
          sonderzk:=puffer_zu_zk_e(formkopf(fpuffer).rest[9],#0,m_longint(formkopf(fpuffer).element_laenge));

        if  (formkopf(fpuffer).element_name='VER ')
        and bytesuche(formkopf(fpuffer).rest,'$VER:')
         then
          sonderzk:=puffer_zu_zk_e(formkopf(fpuffer).rest[9+5],#0,m_longint(formkopf(fpuffer).element_laenge)-5);

        if sonderzk<>'' then
          begin
            if exezk<>'' then
              ausschrift_x(exezk,signatur,absatz);
            ausschrift_x('"'+formkopf(fpuffer).element_name
             +'" ('+str_(m_longint(fpuffer.d[4]),4+1)+') : '+sonderzk,beschreibung,absatz);
            exezk:='';
          end
        else
          begin
            if length(exezk)>60 then
              begin
                ausschrift_x(exezk,signatur,absatz);
                exezk:='';
              end;
            if exezk<>'' then
              exezk_anhaengen(' ; ');
            exezk_anhaengen('"'+formkopf(fpuffer).element_name+'" ('+str_(m_longint(fpuffer.d[4]),4+1)+')');
          end;
        if m_longint(fpuffer.d[4])=0 then break;
        Inc(o,m_longint(fpuffer.d[4])+8);
        if gerade_angeordnet and Odd(o) then Inc(o);
      end;
      if exezk<>'' then
        ausschrift_x(exezk,signatur,absatz);

  end;

procedure riff;
  var
    l1                  :dateigroessetyp;
    zkt:
      record
        xx              :smallword;
        d               :array[0..10] of char4;
      end absolute form_puffer;
    attri               :aus_attribute;
    kaputte_laengen     :boolean;
    dateityp            :char4;

  procedure shdr(const start,ende:dateigroessetyp);
    var
      o:dateigroessetyp;
      p:puffertyp;
    begin
      o:=start;
      while o<ende do
        begin
          datei_lesen(p,o,$30);
          exezk:=puffer_zu_zk_e(p.d[0],#0,20);
          leerzeichenerweiterung(exezk,20);
          ausschrift_x(exezk+str0(p.d[$28]),packer_dat,absatz);
          IncDGT(o,$30);
        end;
    end;

  procedure riff_list(const start,ende:dateigroessetyp;const kopf:string);
    var
      off,off_neu       :dateigroessetyp;
      riff_zaehler      :word_norm;
      w1,w2,w3          :word_norm;
      gekuerzt          :boolean;
    begin
      off:=start;
      riff_zaehler:=0;
      gekuerzt:=false;
      repeat
        datei_lesen(form_puffer,analyseoff+off,4+4+256);

        if kaputte_laengen and (longint_z(@form_puffer.d[4])^=0) then
          begin
            off_neu:=ende;
            longint_z(@form_puffer.d[4])^:=DGT_zu_longint(off_neu-8-off);
          end
        else
          begin
            off_neu:=off+8+longint_z(@form_puffer.d[4])^;
            if zkt.d[0]='LIST' then
              if kaputte_laengen then
                if bytesuche__datei_lesen(off_neu,#0#0#0#0) then
                  IncDGT(off_neu,4);
          end;

        if Odd(longint_z(@form_puffer.d[4])^) then
          IncDGT(off_neu,1);

        if (zkt.d[0]='LIST') or (zkt.d[0]='RIFF') or (zkt.d[0]='INFO') then
          begin
            ausschrift_x(kopf+zkt.d[0]+' .... "'+zkt.d[2]+'"',attri,absatz);
            riff_list(off+8+4,off_neu,kopf+'≥ ');
          end
        else
          begin

            exezk:='';
            if zkt.d[0]='fmt ' then
              begin
                if dateityp='WAVE' then
                  begin
                    exezk:=' : '+str0(word_z(@form_puffer.d[22])^)+' Bit, '
                      +str0(longint_z(@form_puffer.d[12])^ div 1000)+' kHz, ';
                    if form_puffer.d[10]=1 then
                      exezk_anhaengen('Mono')
                    else
                      exezk_anhaengen('Stereo');
                  end
                {else CDXA:
                  exezk:=' : '+puffer_zu_zk_l(form_puffer.d[8],8) #0..'UXA'};
              end

            else
            if zkt.d[0]='DISP' then
              begin
                case form_puffer.d[8] of
                  8:
                    begin
                      exezk:=' : Grafik';
                      windows_ico1(analyseoff+off+12,off_neu-off-12,true,2);
                      befehl_schnitt(analyseoff+off+12,off_neu-off-12,
                        erzeuge_neuen_dateinamen('.'+DGT_str0(analyseoff+off+12)+'.ico'));
                    end;
                end;
              end

            else
            if (zkt.d[0]='data')
            or (zkt.d[0]='smpl') (* aurealgm 4MB sample *)
             then
              begin
                exezk:=' ['+DGT_str0(off_neu-off-8)+']';
                if dateityp='CDXA' then
                  befehl_schnitt(analyseoff+off+8,off_neu-off-8,erzeuge_neuen_dateinamen('.CDXA'));
              end

            else
            if (zkt.d[0]='strh') then (* ULTI/div4 *)
              if puffer_zu_zk_l(zkt.d[2],4)='vids' then
                exezk:='  "'+puffer_zu_zk_l(zkt.d[3],4)+'"';

            ausschrift_x(kopf+zkt.d[0]+exezk,attri,absatz);

            if zkt.d[0]='shdr' then (* aurealgm: Dateinamen *)
              shdr(off+8,off_neu);


            if (zkt.d[0]='data') and bytesuche(form_puffer.d[8],'wvpk'#$1c#$00#$00#$00) then
              wavpack(puffer_zu_zk_e(form_puffer.d[8+$1c],#0,3));

            if (zkt.d[0]='ICMT') or (zkt.d[0]='ISFT') or (zkt.d[0]='ISBJ')
            or (zkt.d[0]='IPRD') or (zkt.d[0]='INAM') or (zkt.d[0]='IART')
            or (zkt.d[0]='ICRD') or (zkt.d[0]='ICOP')
            then
              if form_puffer.d[8]<>0 then
                ausschrift_x('"'+puffer_zu_zk_e(form_puffer.d[8],#0,255)+'"',beschreibung,absatz);

            if ((zkt.d[0]='DISP') and (form_puffer.d[8]=1)) then
              ausschrift_x('"'+puffer_zu_zk_e(form_puffer.d[8+4],#0,255)+'"',beschreibung,absatz);

            if (zkt.d[0]='ptxt') then (* VFD *)
              ansi_anzeige(analyseoff+off+8,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
              ,analyseoff+off+8+longint_z(@form_puffer.d[4])^,'');

            if (zkt.d[0]='JUNK') then
              begin
                w2:=longint_z(@form_puffer.d[4])^;
                if w2=$6a4 then
                  for w1:=0 to w2 div 50-1 do
                    begin
                      datei_lesen(form_puffer,analyseoff+off+8+50*w1,50);
                      for w3:=1 to 50 do
                        if form_puffer.d[w3]<>ord(' ') then
                          begin
                            ausschrift_x(puffer_zu_zk_l(form_puffer.d[0],50),beschreibung,absatz);
                            Break;
                          end;
                    end
              end;
          end;
        off:=off_neu;
        Inc(riff_zaehler);

        if (not kaputte_laengen) and (riff_zaehler>=30) then
          begin
            ausschrift(kopf+textz_minusminusminus_gekuerzt_minusminusminus^,signatur);
            gekuerzt:=true;
            Break;
          end;

      until (off_neu>=ende-1) or (off>=einzel_laenge) or (off<0);

      if (not gekuerzt) then
        if (off<>ende) and (off<>ende+1) and (off+1<>ende) then
          ausschrift(textz_Berechnungsfehler_Dateigroesse^,dat_fehler);

    end; (* riff_list *)

  begin (* riff *)
    kaputte_laengen:=false;
    datei_lesen(form_puffer,analyseoff,40);
    exezk:=textz_RIFF_Dateityp^;

    l1:=longint_z(@form_puffer.d[4])^+8;
    if (l1=0) or (l1=8) then
      begin
        l1:=einzel_laenge;
        kaputte_laengen:=true;
      end;
    if l1+1=einzel_laenge then
      IncDGT(l1,1);
    einzel_laenge:=l1;

    attri:=signatur;
    dateityp:=zkt.d[2];
    if zkt.d[2]='WAVE' then
      begin
        exezk_anhaengen('Wave');
        attri:=musik_bild;
      end;

    if zkt.d[2]='AVI ' then
      begin
        exezk_anhaengen(textz_Animation^);
        attri:=musik_bild;
      end;

    if copy(zkt.d[2],1,3)='CDR' then
      begin
        exezk_anhaengen('Corel Draw '+copy(zkt.d[2],4,1));
        attri:=musik_bild;
      end;

    if copy(zkt.d[2],1,3)='cdr' then
      begin
        exezk_anhaengen('Corel Draw '+copy(zkt.d[2],4,1)+textz_form__muster^);
        attri:=musik_bild;
      end;

    if copy(zkt.d[2],1,3)='CDT' then
      begin
        exezk_anhaengen('Corel Draw '+copy(zkt.d[2],4,1)+textz_form__muster^);
        attri:=musik_bild;
      end;

    if copy(zkt.d[2],1,3)='CMX' then
      begin
        exezk_anhaengen('Corel Meta File');
        attri:=musik_bild;
      end;

    if zkt.d[2]='sfbk' then (* CONVERT *)
      begin
        exezk_anhaengen('EMU SoundFont Bank');
        attri:=musik_bild;
      end;

    if attri=signatur then
      exezk_anhaengen('"'+zkt.d[2]+'"');

    ausschrift(exezk,attri);
    if kaputte_laengen then
      ausschrift(textz_form_kaputte_laengen^,dat_fehler);
    if not langformat then Exit;



   riff_list(12,einzel_laenge,'');
  end;

procedure rifx(const p:puffertyp);
  var
    o:longint;
  begin
    ausschrift('"RIFX" / ??? "'+puffer_zu_zk_l(p.d[8],4)+'"',packer_dat);

    einzel_laenge:=m_longint(p.d[4])+8;
    if not langformat then exit;

    (* archiv_start; *)
    o:=12;
    repeat
      datei_lesen(form_puffer,analyseoff+o,40);
      laenge_eingepackt:=m_longint(form_puffer.d[4]);
      if (laenge_eingepackt<0) or (laenge_eingepackt>einzel_laenge) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          Break;
        end;
      ausschrift(puffer_zu_zk_l(form_puffer.d[0],4)+str_(laenge_eingepackt,9),packer_dat);
      Inc(o,laenge_eingepackt+8);
      if Odd(o) then Inc(o);
    until (o>=einzel_laenge) or (o<0);
    (* archiv_summe; *)

  end;

procedure rifx_intel(const p:puffertyp);
  var
    o:longint;
  procedure namen_umkehr;
    begin
      exezk:=exezk[4]+exezk[3]+exezk[2]+exezk[1];
    end;
  begin
    exezk:=puffer_zu_zk_l(p.d[8],4);
    namen_umkehr;
    ausschrift('"RIFX" / ??? "'+exezk+'"',packer_dat);

    einzel_laenge:=x_longint(p.d[4])+8;
    if not langformat then Exit;

    (* archiv_start; *)
    o:=12;
    repeat
      datei_lesen(form_puffer,analyseoff+o,40);
      exezk:=puffer_zu_zk_l(form_puffer.d[0],4);
      if bytesuche(form_puffer.d[0],'RIFF') then
        laenge_eingepackt:=m_longint(form_puffer.d[4])
      else
        begin
          laenge_eingepackt:=x_longint(form_puffer.d[4]);
          namen_umkehr;
        end;

      if (laenge_eingepackt<=0) or (laenge_eingepackt>einzel_laenge) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          Break;
        end;

      ausschrift(exezk+str_(laenge_eingepackt,9),packer_dat);
      Inc(o,laenge_eingepackt+8);
      if Odd(o) then Inc(o);
    until (o>=einzel_laenge) or (o<0);
    (* archiv_summe; *)

  end;


procedure voc(dof:dateigroessetyp);
  var
    datablock           :word;
    freq,kanaele        :string[20];
    datenlaenge         :longint;
    vocpuffer           :puffertyp;
    db_laenge           :longint;

  function voctyp(t:byte):string;
    begin
      case t of
        0:voctyp:='8 Bit';
        1:voctyp:='4 Bit';
        2:voctyp:='2,5 Bit';
        3:voctyp:='2 Bit';
      else
        voctyp:='Multi DAC ('+str0(t-3);
      end;
    end;
  function wdh(w:word):string;
    begin
      if w=$FFFF then
        wdh:=textz_endlos^
      else
        wdh:=str0(w-1);
    end;


  begin
    ausschrift('VOC-Creative Labs',musik_bild);
    if not langformat then Exit;

    repeat
      datei_lesen(vocpuffer,dof,512);
      db_laenge:=longint_z(@vocpuffer.d[1])^ and $00FFFFFF;

      case vocpuffer.d[0] of
        0:if signaturen then ausschrift(textz_Ende^,musik_bild);
        1:ausschrift_x(textz_Klangdaten^+str0(round(1000/(256-vocpuffer.d[4])))
         +' kHz '+voctyp(vocpuffer.d[5]),musik_bild,absatz);
        2:ausschrift_x(textz_Klangdaten_fortgesetzt^,musik_bild,absatz);
        3:ausschrift_x(textz_Stille^,musik_bild,absatz);
        4:if signaturen then ausschrift_x(textz_form__Markierung^,musik_bild,absatz);
        5:ausschrift_x('"'+puffer_zu_zk_e(vocpuffer.d[4],#0,255)+'"',musik_bild,absatz);
        6:ausschrift_x(textz_Wiederholung^+wdh(word_z(@vocpuffer.d[4])^),musik_bild,absatz);
        7:ausschrift_x(textz_Ende_Wiederholung^,musik_bild,absatz);
        8:
          begin
            if vocpuffer.d[6]=0 then
              exezk:=str0(round(265000/($FFFF-word_z(@vocpuffer.d[4])^)))+' kHz Mono'
            else
              exezk:=str0(round(132500/($FFFF-word_z(@vocpuffer.d[4])^)))+' kHz Stereo';

            if vocpuffer.d[7]<>0 then
              exezk_anhaengen(' (gepackt)');
            ausschrift_x(textz_erweitertes_Format_doppelpunkt^+exezk,musik_bild,absatz);
          end;
      else
          ausschrift_x(textz_unbekannter_Datenblocktyp^+str0(vocpuffer.d[0]),musik_bild,absatz);
      end;
      if vocpuffer.d[0]<>0 then
        begin
          if signaturen then ausschrift(textz_LAENGE_gleich^+str0(db_laenge),signatur);
          IncDGT(dof,db_laenge+4);
        end;
    until (vocpuffer.d[0]=0) or (dof>analyseoff+einzel_laenge) or (dof<analyseoff);
    einzel_laenge:=dof+1-analyseoff;

    (* Zum Beispiel igor.fsd *)
    if (analyseoff>0) or (einzel_laenge<>dateilaenge) then
      befehl_schnitt(analyseoff,einzel_laenge,hex_DGT(analyseoff)+'.voc');
  end;

procedure dbase3(const dbf_kopf_puffer:puffertyp);
  type
    db3_feldbeschreibung=
      record
        xx              :smallword;
        bezeichner      :array[1..11] of char;
        data_type       :char;
        x1              :longint;
        feldgroesse     :byte;
        dezimalstellen  :byte;
        reserviert      :array[1..14] of byte;
      end;
    dbf_kopf_typ=
      record
        xx              :smallword;
        version         :byte;
        jahr,monat,tag  :byte;
        saetze          :longint;
        kopflaenge      :smallword;
        satzgroesse     :smallword;
      end;

    var
      dbf:dbf_kopf_typ         absolute dbf_kopf_puffer;
      db3:db3_feldbeschreibung absolute form_puffer;

      db3_off           :longint;
      testlaenge        :longint;
  begin
    testlaenge:=longint(dbf.kopflaenge)+dbf.saetze*longint(dbf.satzgroesse);
    if (dateilaenge<>testlaenge) and (dateilaenge<>testlaenge+1) then
      exit;

    if dbf.version=$03 then
      exezk:=''
    else
      exezk:=textz_mit_Memo^;

    ausschrift('dBase 3+'+exezk+textz_form__leer_mit_leer^+str0(dbf.saetze)
     +textz_Saetzen_zu^+str0((dbf.kopflaenge-32) div 32)+textz_form__Spalten^,signatur);

    if not langformat then exit;
    db3_off:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+32+db3_off,32);
      if db3.bezeichner[1] in [#0,#13] then
        break;

      exezk:=copy(puffer_zu_zk_e(db3.bezeichner,#0,80)+'                ',1,11)+': ';
      case db3.data_type of
      'C':exezk_anhaengen(str_(db3.feldgroesse,3)+textz_form__Zeichen^);
      'N':exezk_anhaengen(str_(db3.feldgroesse,3)+textz_form__Numerisch^
                         +str_(db3.dezimalstellen,0)+textz_form__Nachkommastellen^);
      'L':exezk_anhaengen(str_(db3.feldgroesse,3)+textz_form_logisch^);
      'D':exezk_anhaengen(str_(db3.feldgroesse,3)+textz_form__Datum^);
      'M':exezk_anhaengen(str_(db3.feldgroesse,3)+textz_form__Memo^);
      else
        exezk_anhaengen(str_(db3.feldgroesse,3)+' ???');
      end;
      ausschrift(exezk,beschreibung);
      inc(db3_off,32);
    until falsch;

  end;

procedure arc(const titel:string);
  var
    o           :longint;
    kopflaenge  :longint;

  procedure arc_rekursiv(const verzeichnis:string);
    var
      naecheste_position:longint;
    begin
      repeat
        datei_lesen(form_puffer,analyseoff+o,100);
        if  (form_puffer.d[0]<>ord(^z))
        and (form_puffer.d[0]<>ord(#$1b))
         then
          begin
            ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
            Exit;
          end;

        laenge_eingepackt:=longint_z(@form_puffer.d[15])^;

        case form_puffer.d[1] of
          $00: (* Archivende *)
            begin
              Inc(o,2);
              Break;
            end;
          $01: (* ungepackt *)
            begin
              Inc(o,$1d-4);
              laenge_ausgepackt:=laenge_eingepackt;
              archiv_datei;
              archiv_datei_ausschrift(verzeichnis+puffer_zu_zk_e(form_puffer.d[2],#0,255));
            end;
          $02..$11: (* normale Kompressionsmethoden *)
            begin
              Inc(o,$1d);
              laenge_ausgepackt:=longint_z(@form_puffer.d[15+4+2+2+2])^;
              archiv_datei;
              archiv_datei_ausschrift(verzeichnis+puffer_zu_zk_e(form_puffer.d[2],#0,255));
            end;
          $14:  (* Archivkopf *)
            begin
              Inc(o,$1d);
              ausschrift('ARC 7+ / SEA '+textz_form__Archivkopf^,packer_dat);
              if form_puffer.d[$1f]=0 then (* <> 1 *)
                ansi_anzeige(analyseoff+o+3,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
                  ,unendlich,'');
            end;
          $15: (* Dateikommentar *)
            begin
              Inc(o,$1d);
              ansi_anzeige(analyseoff+o+3,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
                ,unendlich,'');
            end;
          $17: (* PartialBU,IncrementalBU *)
            begin
              Inc(o,$1d);
              ausschrift(textz_form__Diskette^+chr(form_puffer.d[2]),packer_dat);
            end;
          $1e: (* Verzeichnisse+ beim FullBU *)
            begin
              Inc(o,$1d);
              laenge_ausgepackt:=longint_z(@form_puffer.d[15+4+2+2+2])^;
              archiv_datei;
              exezk:=verzeichnis+puffer_zu_zk_e(form_puffer.d[2],#0,255);
              archiv_datei_ausschrift_verzeichnis(exezk);
              naecheste_position:=o+laenge_eingepackt;
              arc_rekursiv(verzeichnis+puffer_zu_zk_e(form_puffer.d[2],#0,255)+'\');
              o:=naecheste_position;
              laenge_eingepackt:=0;
            end;
          $1f: (* Verzeichnis- beim FULLBU *)
            begin
              Inc(o,$1d);
              Exit;
            end;
          else
              Inc(o,$1d);
              ausschrift(textz_unbekannter_Datenblock^+str0(form_puffer.d[1])+' ¯',dat_fehler);
          end;

        Inc(o,laenge_eingepackt);
      until o>=einzel_laenge;

    end;

  begin
    datei_lesen(form_puffer,analyseoff,20);
    if not (form_puffer.d[1] in [$01..$11,$14,$15,$17,$1e,$1f]) then Exit;
    o:=longint_z(@form_puffer.d[15])^;
    if form_puffer.d[1]=$01 then
      Inc(o,$1d-4)
    else
      Inc(o,$1d  );
    if (o>=einzel_laenge) or (o<=0) then Exit;
    if not bytesuche__datei_lesen(analyseoff+o,#$1a) then Exit;

    ausschrift('Arc, Pak / SEA, PKWare, NoGate, ..',packer_dat);
    if titel<>'' then ausschrift(titel,beschreibung);

    if not langformat then exit;

    archiv_start;
    o:=0;

    arc_rekursiv('');

    datei_lesen(form_puffer,analyseoff+o,20);
    if bytesuche(form_puffer.d[0],#$1b#$03'RegInfo.BTS') then
      begin
        (* Version 2.23 Beta 5 *)
        ausschrift('BTSPK / Jozsef Hidasi',packer_dat);
        arc_rekursiv('');
        archiv_summe;
        Exit;
      end;


    (* NoGate *)
    repeat
      datei_lesen(form_puffer,analyseoff+o,80);
      if form_puffer.d[0]<>254 then Break;

      kopflaenge:=longint_z(@form_puffer.d[4])^;
      case form_puffer.d[1] of
        0:
          begin
            archiv_summe;
            Exit;
          end;

        1:ansi_anzeige(analyseoff+o+8,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
          ,analyseoff+o+8+longint_z(@form_puffer.d[4])^,'');
        2:if longint_z(@form_puffer.d[4])^>0 then
            ausschrift_x(textz_form__Pfad_fuer^+str0(word_z(@form_puffer.d[2])^)
              +textz_punkt_Datei_gleich_anf^+puffer_zu_zk_l(form_puffer.d[8],
              longint_z(@form_puffer.d[4])^)+'"',packer_dat,absatz);
        3:ausschrift_x(textz_Sicherheitshuelle^,packer_dat,absatz);
        4:
      else
        ausschrift_x('???',packer_dat,absatz);
      end;

      Inc(o,kopflaenge);
      Inc(o,8);
    until o>=einzel_laenge;

    (* PKWARE *)
    if not (form_puffer.d[0] in [0,$1a]) then
      ansi_anzeige(analyseoff+o,'PK'#$aa#$55,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,wahr,unendlich,'');

    archiv_summe;
  end;

procedure lzh_sfx(o:dateigroessetyp;const titel:string);
  begin

    repeat
      datei_lesen(form_puffer,analyseoff+o,10);
      if bytesuche(form_puffer.d[0],'??-???-') then break;
      IncDGT(o,1);
    until analyseoff+o>dateilaenge;

    if analyseoff+o>dateilaenge then
      exit;

    ausschrift(textz_form__ab^+strx_oder_hexDGT(o)+' :',overlay_);

    lzh(o,titel);
  end;

procedure lzh(o:dateigroessetyp;const titel:string);
  var
    posi                :word_norm;
    award_ziel_segment  :word_norm;
    award_ziel_segment_name:string;
    kopf_position       :dateigroessetyp;
    verzeichnisname     :string;
    verzeichnis_jetzt   :string;
    swag                :boolean;
    kopflaenge,kl,pe    :longint;
    verzeichnis         :boolean;
  begin
    ausschrift(titel,packer_dat);
    if not langformat then exit;


    (* "normales" LHA:

        1 Byte KopflÑnge
        1 Byte PrÅfsumme kopf
        5 Byte "-lh5-"
        4 Byte LÑnge eingepackt
        4 Byte LÑnge ausgepackt
        4 Byte ? (Datum)
        1 0x20  Attribut
        1 Byte 0,1[2??]    Level 0,1,2 header
          AR.C: 0x01
        String Dateiname                        *)

    (*

    (*
          Header for CAR files (version 1.50)
       -----------------------------------
       Structure of archive block (low order byte first):
       -----preheader
00     1      basic header size
                       = 25 + strlen(filename) (= 0 if end of archive)
01     1      basic header algebraic sum (mod 256)
       -----basic header
02     5      method ("-lh0-" = stored, "-lh5-" = compressed)
07     4      compressed size (including extended headers)
0b     4      original size
0f     1      filename length (x)
       x      filename
       2      original file's CRC
       2      original file's attribute
       2      original file's time
       2      original file's date
       1      0x20 (placeholder, not used for now)
       2      first extended header size (0 if none) -- 0 for CAR files
       -----first extended header, etc. (none for CAR files)
       -----compressed file                                              *)


    archiv_start;

    repeat
      verzeichnisname:='';
      datei_lesen(form_puffer,analyseoff+o,85);

      if bytesuche(form_puffer.d[0],'-lh?-') then
        begin
          DecDGT(o,2);
          continue;
        end;

      if not (bytesuche(form_puffer.d[0],'??-???-') or
              bytesuche(form_puffer.d[0],'?? LH? '))
      then Break;

      swag:=bytesuche(form_puffer.d[2],'-sw');


      laenge_eingepackt:=longint_z(@form_puffer.d[7  ])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[7+4])^;
      (* kein Test: MAN.EXE erzeugt z.B. 100.6% Archive *)
      archiv_datei;
      verzeichnis:=false;

      kopflaenge:=form_puffer.d[$0]+2;

      (* CAR .. *)
      if  (form_puffer.d[5] in [ord('0'),ord('5')])
      and (form_puffer.d[0]=form_puffer.d[$f]+25)
      and (bytesuche(form_puffer.d[form_puffer.d[0]-1],#$20#$00#$00)) then
        begin
          exezk:=puffer_zu_zk_pstr(form_puffer.d[$f]);
        end
      else if bytesuche(form_puffer.d[0],'??-TK?-') then
        begin
          Dec(kopflaenge,2);
          exezk:=puffer_zu_zk_e(form_puffer.d[$15],#0,255);
        end
      else if bytesuche(form_puffer.d[0],'??-sw?-') then
        begin
          exezk:=puffer_zu_zk_pstr(form_puffer.d[$26]);
        end
      else if form_puffer.d[$14]=2 then (* LMELT093.EXE *)
        begin
          Dec(kopflaenge,2);
          kopf_position:=analyseoff+o+$18;
          repeat
            datei_lesen(form_puffer,kopf_position,512);
            if word_z(@form_puffer.d[0])^=0 then
              break;

            case form_puffer.d[$2] of
              $01:exezk          :=puffer_zu_zk_e(form_puffer.d[3],#$ff,word_z(@form_puffer.d[0])^-3);
              $02:verzeichnisname:=puffer_zu_zk_e(form_puffer.d[3],#$ff,word_z(@form_puffer.d[0])^-3);
            end;

            IncDGT(kopf_position,word_z(@form_puffer.d[0])^);
          until false;

        end
      else (* LHA/AR/... *)
        begin
          (*exezk:=puffer_zu_zk_pstr(form_puffer.d[$15]);*)
          exezk:=puffer_zu_zk_e(form_puffer.d[$15+1],#0,form_puffer.d[$15]); (* LEO.BMP im AWARD BIOS *)
          verzeichnis:=(form_puffer.d[5]=Ord('d'));

          (* AWARD BIOS (CBROM.EXE) *)
          award_ziel_segment:=word_z(@form_puffer.d[$11])^;

          case award_ziel_segment of
            $0800:award_ziel_segment_name:=' NCR ROM';
            $1000:award_ziel_segment_name:=' AHA/BusLogic ROM';
            $4000:award_ziel_segment_name:=' LOGO BitMap';
            $4001:award_ziel_segment_name:=' CPU micro code';
            $4002:award_ziel_segment_name:=' EPA pattern';
            $4003:award_ziel_segment_name:=' ACPI table';
            $4004:award_ziel_segment_name:=' VSA driver';
            $4005:award_ziel_segment_name:=' HPM ROM';
            $4006:award_ziel_segment_name:=' HPC ROM';
            $4007:award_ziel_segment_name:=' Virus ROM'; (* ? ChipAvayVirus';  GDLS1011 *)
            $4008..$400d:
                  award_ziel_segment_name:=' FNT'+Chr(Ord('0')+award_ziel_segment-$4008)+' ROM';
            $400e:award_ziel_segment_name:=' YGROUP ROM';
            $400f:award_ziel_segment_name:=' MIB ROM';
            $4010:award_ziel_segment_name:=' EPA1 ROM';
            $4011:award_ziel_segment_name:=' LOGO1 ROM';

            $4012..$4019:
                  award_ziel_segment_name:=' OEM'+Chr(Ord('0')+award_ziel_segment-$4012)+' CODE';
            $401a..$401f:
                  award_ziel_segment_name:=' EPA'+Chr(Ord('0')+award_ziel_segment-$401a+2)+' ROM';
            $4020..$4025:
                  award_ziel_segment_name:=' LOGO'+Chr(Ord('0')+award_ziel_segment-$4020+2)+' ROM';
            $4026:award_ziel_segment_name:=' Flash ROM';
            $407f:award_ziel_segment_name:=' XGROUP CODE';
            $4080..$4085:
                  award_ziel_segment_name:=' VGA ROM '+Chr(Ord('0')+award_ziel_segment-$4080+1);
            $4086..$409f:
                  award_ziel_segment_name:=' PCI driver '+Chr(Ord('A')+award_ziel_segment-$4086);
         (* $4086:award_ziel_segment_name:=' ? ncr 307';         SDA14A.BIN *)
            $40a0..$40a3:
                  award_ziel_segment_name:=' PCI driver '+Chr(Ord('A')+award_ziel_segment-$40a0);
            $40a4..$40a6:
                  award_ziel_segment_name:=' PCI driver '+Chr(Ord('1')+award_ziel_segment-$40a4);
            $4100:award_ziel_segment_name:=' EXT System BIOS';
            $5000:award_ziel_segment_name:=' System BIOS';
            $7000:award_ziel_segment_name:=' VGA ROM';
          else
                  award_ziel_segment_name:='';
          end;


          if  (   bytesuche(form_puffer.d[$0f],#$00#$00'??'#$20)
               or bytesuche(form_puffer.d[$0f],#$00#$80'??'#$20)) (* SI54PAIO.ZIP\5550XPNP.BIN MODE4.BIN *)
          and (award_ziel_segment<$a000)
          and (longint_z(@form_puffer.d[$0b])^<512*1024)
          and (award_ziel_segment_name<>'')
          and (form_puffer.d[$14]=1)
           then
            begin
              exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
              exezk_anhaengen(' [');
              exezk_anhaengen(hex_word(award_ziel_segment));
              exezk_anhaengen(':0000');
              exezk_anhaengen(award_ziel_segment_name);
              exezk_anhaengen(']');
            end;

          (* erweiterte Blîcke durchlaufen (Verzeichnisname) *)
          kopf_position:=analyseoff+o+form_puffer.d[0];
          (* öberhaupt Platz? *) (* GERMANY3 von einer alten CD *)
          if (kopf_position<kopflaenge-$16+form_puffer.d[$15])
          or (form_puffer.d[$14]=$01)
           then
            repeat
              datei_lesen(form_puffer,kopf_position,512);
              kl:=word_z(@form_puffer.d[0])^;
              if kl=0 then
                break;

              case form_puffer.d[$2] of
                $02:
                  begin
                    pe:=3;
                    while pe<kl do
                      begin
                        verzeichnis_jetzt:=datei_lesen__zu_zk_e(kopf_position+pe,#$ff,kl-pe);
                        Inc(pe,Length(verzeichnis_jetzt)+1);
                        if verzeichnisname<>'' then verzeichnisname:=verzeichnisname+'\';
                        verzeichnisname:=verzeichnisname+verzeichnis_jetzt;
                      end;
                  end;
              end;

              kopf_position:=kopf_position+kl;
            until false;
        end;


      if verzeichnisname<>'' then
        exezk:=verzeichnisname+'\'+exezk;


      if (Length(exezk)>0) and (exezk[Length(exezk)]='.') then
        Dec(exezk[0]);

      if verzeichnis then
        archiv_datei_ausschrift_verzeichnis(exezk)
      else
        archiv_datei_ausschrift(exezk);

      IncDGT(o,kopflaenge+laenge_eingepackt);
    until falsch;

    if swag then
      begin
        IncDGT(o,1);
        datei_lesen(form_puffer,analyseoff+o,$81);
        ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung);
        ausschrift(puffer_zu_zk_pstr(form_puffer.d[61]),beschreibung);
        IncDGT(o,$81);
      end;

    if  (o+1>=einzel_laenge)
    and (form_puffer.d[0]=0)
     then
      IncDGT(o,1); (* #0 Abschlu· *)
    archiv_summe;

    if einzel_laenge+1=o then DecDGT(o,1); (* LHARK 3,4 *)

    einzel_laenge:=o;

  end;


procedure kazip_kopf;
  var
    o:longint;
  begin
    o:=$14;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'KA') then break;
      if form_puffer.d[2]=6 then
        inc(o,4)
      else
        begin
          ausschrift(puffer_zu_zk_l(form_puffer.d[6],form_puffer.d[4]),beschreibung);
          inc(o,6+word_z(@form_puffer.d[4])^);
        end;
    until false;
    einzel_laenge:=o;
  end;

procedure zip(off:dateigroessetyp;vom_anfang:boolean;const art_install:peter_sabath_zip);
  const
    art_code_zk:array[0..31] of char='ArtInstall (C) 1993 Peter Sabath';
    prg_code_zk:array[0..31] of char='PrgInstall (C) 1991 Peter Sabath';
  var
    laenge_eingepackt64_kopie,
    laenge_ausgepackt64_kopie,
    o,o1,o_test,o_test1 :dateigroessetyp;
    diskettenzaehleranfang:byte;
    zip_zusatzpuffer    :puffertyp;
    version             :byte;
    zip_titel           :string[50];
    verzeichnis         :boolean;
    volumelabel         :boolean;

  procedure zip_lesen_und_entschluesseln(var p:puffertyp;o:dateigroessetyp;laenge:word_norm);
    var
      zaehler           :word_norm;
      o_xor_index       :word_norm;
    begin
      datei_lesen(p,o,laenge);
      (*$IfDef dateigroessetyp_comp*)
      o_xor_index:=Round(AndDGT(o,$1f)); (* 0..31 *)
      (*$Else*)
      o_xor_index:=AndDGT(o,$1f); (* 0..31 *)
      (*$EndIf*)


      case art_install of
        kein_art_prg_code:
          ;

        art_code:
          for zaehler:=1 to p.g do
            p.d[zaehler-1]:=p.d[zaehler-1] xor ord(art_code_zk[((o_xor_index+zaehler-1) xor 1) mod Length(art_code_zk)]);

        prg_code:
          for zaehler:=1 to p.g do
            p.d[zaehler-1]:=p.d[zaehler-1] xor ord(prg_code_zk[((o_xor_index+zaehler-1) xor 1) mod Length(prg_code_zk)]);
      end;

      if art_install<>kein_art_prg_code then
        if signaturen then
          signatur_anzeige('ArtI',p);

      if bytesuche(p.d[0],'PK'#$03#$04) then
        version:=Max(version,p.d[4])
      else
      if bytesuche(p.d[0],'PK'#$01#$02) then
        version:=Max(version,p.d[6])

    end;

  var
    schluessel          :byte;

  procedure entschluessele_0a09(var p:puffertyp;const anfang,ende:word_norm;const plus:byte);
    var
      z                 :word_norm;
    begin
      with p do
      for z:=anfang to ende do
        d[z]:=d[z] xor byte(schluessel+z+plus);
    end;

  procedure bearbeite_0a09(const oo:dateigroessetyp);
    var
      max               :longint;
      b                 :longint;
      ml                :longint;
      inst_puffer       :puffertyp;
    begin
      schluessel:=byte(form_puffer.d[$0b]-$b);

      entschluessele_0a09(form_puffer,$08,$0f,0);

      max:=longint_z(@form_puffer.d[8])^;
      if word_z(@form_puffer.d[4])^<=20 then
        (* 2.0: 2.60 W aber nicht 2.1 pkzw400s.exe *)
        Inc(max,4+8);
      if max<form_puffer.g then
        form_puffer.g:=max;

      entschluessele_0a09(form_puffer,$10,form_puffer.g-1,0);

      if signaturen then
        signatur_anzeige('PK 0a09:',form_puffer);

      b:=$10;
      while b<max do
        begin
          zip_lesen_und_entschluesseln(inst_puffer,oo+b,256+4+2);
          entschluessele_0a09(inst_puffer,0,inst_puffer.g-1,lo(b));
          ml:=longint_z(@inst_puffer.d[0])^;
          if ml<2 then Break;
          Dec(ml,2);
          if ml>255 then
            ml:=255;
          ausschrift(strx_oder_hex(word_z(@inst_puffer.d[4])^)+': "'+puffer_zu_zk_e(inst_puffer.d[4+2],#0,ml)
            +'"',beschreibung);
          Inc(b,4+longint_z(@inst_puffer.d[0])^);
        end;

    end;

  function zip_dateisystem(b:byte):string;
    begin
      case b of
        0:zip_dateisystem:=''; (* FAT *)
        1:zip_dateisystem:=' [Amiga]';
        2:zip_dateisystem:=' [VMS]';
        3:zip_dateisystem:=' [Unix]';
        4:zip_dateisystem:=' [VM/CMS]';
        5:zip_dateisystem:=' [Atari ST]';
        6:zip_dateisystem:=' [HPFS]';
        7:zip_dateisystem:=' [Macintosh]';
        8:zip_dateisystem:=' [Z-System]';
        9:zip_dateisystem:=' [CP/M]';
       10:zip_dateisystem:=' [TOPS-20]';
       11:zip_dateisystem:=' [NTFS]';
       12:zip_dateisystem:=' [SMS/QDOS]';
       13:zip_dateisystem:=' [Acorn RISC OS]';
       14:zip_dateisystem:=' [Win32 VFAT]';
       15:zip_dateisystem:=' [MVS]';
       16:zip_dateisystem:=' [BeOS]';
       17:zip_dateisystem:=' [Tandem NSK]';
       18:zip_dateisystem:=' [OS/400]';
      else
          zip_dateisystem:=' ['+textz_form__unbekanntes_Dateisystem^+strx(b,3)+' ¯]';
      end;
    end;

  procedure bearbeite_extrafelder(var o:dateigroessetyp;extrafeldlaenge:longint);
    var
      ep:puffertyp;
    begin
      while extrafeldlaenge>0 do
        begin
          zip_lesen_und_entschluesseln(ep,o,10);
          case word_z(@ep.d[0])^ of
          $0001: (* ZIP64 *)
            begin
              zip_lesen_und_entschluesseln(ep,o,2+2+8+8+8+4);
              if word_z(@ep.d[2])^>=8 then
                laenge_ausgepackt64:=dateigroessetyp_z(@ep.d[4])^;
              if word_z(@ep.d[2])^>=16 then
                laenge_eingepackt64:=dateigroessetyp_z(@ep.d[12])^;
              (* local_header_relativ: comp *)
              (* disk start number: long *)
            end;
          $0009: (* OS/2 Erweiterte Attribute *)
            begin
              exezk_anhaengen(str_(longint_z(@ep.d[4])^,6));
              exezk_anhaengen(textz_form__leer_Byte_EA^);
            end;
          $4453, (* Win32 ACL *)
          $4c41, (* OS/2 ACL *)
          $5356: (* AOS/VS ACL *)
            begin
              exezk_anhaengen(' [ACL]');
            end;

          end;
          IncDGT(o              ,4+word_z(@ep.d[2])^);
          Dec   (extrafeldlaenge,4+word_z(@ep.d[2])^);
        end;

      (* Fehler in installMultiShow.jar ausgleichen *)
      IncDGT(o,extrafeldlaenge);
    end;

  procedure kommentar(var o:dateigroessetyp;const kommentarlaenge:longint);
    begin
      if kommentarlaenge>0 then
        begin
          ansi_anzeige(o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,
            falsch,o+kommentarlaenge,'');
          IncDGT(o,kommentarlaenge);
        end;
    end;

  var
    namenlaenge,
    extrafeldlaenge,
    kommentarlaenge     :word_norm;
    oo                  :dateigroessetyp;

  begin
    version:=0;
    o:=off;

    if art_install=art_code then
      ausschrift(textz_verschluesseltes_ZIP_Archiv^+' ['+art_code_zk+']',packer_dat);

    if art_install=prg_code then
      ausschrift(textz_verschluesseltes_ZIP_Archiv^+' ['+prg_code_zk+']',packer_dat);

    zip_lesen_und_entschluesseln(form_puffer,o,270);

    if not bytesuche(form_puffer.d[0],'PK') then
      begin
        ausschrift_x(textz_Archiv_Fehler_Haupt_Archiv_Verzeichnis_nicht_an_korrekter_Position^,dat_fehler,absatz);
        Exit;
      end;


    if vom_anfang then
      zip_titel:=''
    else
      zip_titel:=textz_form__Dateiliste_ab^+strx_oder_hexDGT(off);


    if not langformat then
      begin
        if version>0 then
          zip_titel:=zip_titel+', '+textz_form__Version_leer^+str0(version div 10)+'.'+str0(version mod 10);

        ausschrift_x('Zip'+zip_titel,packer_dat,absatz);
        Exit;
      end;




    if (form_puffer.d[4] div 10)=0 then
      diskettenzaehleranfang:=1
    else
      diskettenzaehleranfang:=0;

    (* Spezialfall: TAR -c.vf erzeugt ZIP-Archive ohne LÑngenangabe und Dateiname *)
    if  bytesuche(form_puffer.d[0],'PK'#$03#$04#$13) (* Datei,Version 1.9 *)
    and (longint_z(@form_puffer.d[$12])^=0) (* eingepackt,ausgepackt=0 *)
    and (longint_z(@form_puffer.d[$16])^=0)
    and (longint_z(@form_puffer.d[$1a])^=0) (* LÑnge des Dateinamens=0 *)
    and vom_anfang then
      begin
        (* "end of central dir signature" *)
        zip_lesen_und_entschluesseln(zip_zusatzpuffer,dateilaenge-$16,$16);
        if bytesuche(zip_zusatzpuffer.d[0],'PK'#$05#$06) then
          begin
            o:=dateilaenge-$16-longint_z(@zip_zusatzpuffer.d[$0c])^;
            vom_anfang:=false;
          end;

      end;


    (* Hauptverzeichnis suchen und testen? *)
    (* Problem: keine EA-Anzeige mit Pkzip 2.5 OS/2: keine Informationen im Hauptverzeichnis *)
    if  (   bytesuche(form_puffer.d[0],'PK'#$03#$04)  (* "local file header signature" *)
         or bytesuche(form_puffer.d[0],'PK'#$09#$0a))
    and vom_anfang then
      begin
        o_test:=dateilaenge-$16;
        zip_lesen_und_entschluesseln(zip_zusatzpuffer,o_test,$16);

        (* winzip mit nullen bis zum nÑchsten *512 gefÅllt *)
        (* Beispiel: H:\_EMULATOREN\C64\64er-cd-rom.exe *)
        if  (not bytesuche(zip_zusatzpuffer.d[0],'PK'#$05#$06))
        and bytesuche(zip_zusatzpuffer.d[$16-4],#$00#$00#$00#$00) then
          begin

            oo:=datei_pos_suche(dateilaenge-$16,dateilaenge-$16-512,'PK'#$05#$06);
            if oo<>nicht_gefunden then
              begin
                o_test:=oo;
                zip_lesen_und_entschluesseln(zip_zusatzpuffer,o_test,$16);
              end;

          end;

        if  bytesuche(zip_zusatzpuffer.d[0],'PK'#$05#$06)
        and (o_test>longint_z(@zip_zusatzpuffer.d[$0c])^)
         then
          begin
            DecDGT(o_test,longint_z(@zip_zusatzpuffer.d[$0c])^);
            datei_lesen(zip_zusatzpuffer,o_test,270);

            (* Verzeichiskennung *)
            if  bytesuche(zip_zusatzpuffer.d[0],'PK'#$01#$02)
            (* Dateiname *)
            and (puffer_zu_zk_l(zip_zusatzpuffer.d[$2e],zip_zusatzpuffer.d[$1c])
               =(puffer_zu_zk_l(form_puffer.d[$1e],form_puffer.d[$1a]))) then
              begin

                (* PK 01 02 *)
                o_test1:=o_test+$2e+word_z(@zip_zusatzpuffer.d[$1c])^;

                laenge_eingepackt64:=longint_z(@zip_zusatzpuffer.d[$14])^;
                laenge_ausgepackt64:=longint_z(@zip_zusatzpuffer.d[$18])^;

                bearbeite_extrafelder(o_test1,word_z(@zip_zusatzpuffer.d[$1e])^);

                laenge_eingepackt64_kopie:=laenge_eingepackt64;
                laenge_ausgepackt64_kopie:=laenge_ausgepackt64;

                (* PK 03 04 *)
                o_test1:=o+30+word_z(@form_puffer.d[26])^;
                laenge_eingepackt64:=x_long(form_puffer.d[18]);
                laenge_ausgepackt64:=x_long(form_puffer.d[22]);

                bearbeite_extrafelder(o_test1,+word_z(@form_puffer.d[28])^);

                if  (laenge_eingepackt64_kopie=laenge_eingepackt64)
                and (laenge_ausgepackt64_kopie=laenge_ausgepackt64) then
                  begin
                    o:=o_test;
                    vom_anfang:=false;
                  end
                else
                (* weirdx.jar *)
                if  (laenge_eingepackt64=0)
                and (laenge_ausgepackt64=0)
                and (laenge_eingepackt64_kopie>0) (* 2 Byte.. *)
                and (laenge_ausgepackt64_kopie=0)
                 then
                  begin
                    o:=o_test;
                    vom_anfang:=false;
                  end;
              end;
          end;

        (* Archivschnelldurchlauf bis zum Hauptverzeichnis *)
        if vom_anfang then
          begin
            o_test:=o;
            repeat
              zip_lesen_und_entschluesseln(form_puffer,o_test,270);

              if not bytesuche(form_puffer.d[0],'PK') then
                Break;

              case word_z(@form_puffer.d[2])^ of
                $0201: (* Inhaltsverzeichniseintrag *)
                  begin
                    o:=o_test;
                    vom_anfang:=false;
                    Break;
                  end;
                $0403: (* Datenblock *)
                  begin
                    laenge_eingepackt64:=x_long(form_puffer.d[18]);
                    laenge_ausgepackt64:=x_long(form_puffer.d[22]);
                    (* Kopf+NamenlÑnge *)
                    IncDGT(o_test,30+word_z(@form_puffer.d[26])^);
                    (* ExtrafeldlÑnge *)
                    bearbeite_extrafelder(o_test,+word_z(@form_puffer.d[28])^);

                    IncDGT(o_test,laenge_eingepackt64);
                  end;

                $0807: (* Multi-Vol-Kopf *)
                  begin
                    IncDGT(o_test,4);
                    (* isnetworksmindterm1.2.1scp3.exe *)
                    if not bytesuche(form_puffer.d[$04],'PK') then
                      if bytesuche(form_puffer.d[$10],'PK') then
                        IncDGT(o_test,$10-4);
                  end;
                $0a09: (* PKZIP 2.60 W *)
                  begin
                    bearbeite_0a09(o_test);
                    IncDGT(o_test,longint_z(@form_puffer.d[8])^);
                    if word_z(@form_puffer.d[4])^<=20 then
                      (* 2.0: 2.60 W aber nicht 2.1 pkzw400s.exe *)
                      IncDGT(o_test,4+8);
                  end;
              else
                Break;
              end;

            until o_test>=analyseoff+einzel_laenge;
          end;
      end;

    (* Version ermitteln *)
    if not vom_anfang then
      begin
        o_test:=o;
        repeat
          zip_lesen_und_entschluesseln(form_puffer,o_test,$2e);
          if not bytesuche(form_puffer.d[0],'PK'#$01#$02) then Break;

          namenlaenge    :=word_z(@form_puffer.d[$1c])^;
          extrafeldlaenge:=word_z(@form_puffer.d[$1e])^;
          kommentarlaenge:=word_z(@form_puffer.d[$20])^;

          if (namenlaenge>200) or (namenlaenge<0) then
            Break;

          IncDGT(o_test,$2e+namenlaenge+extrafeldlaenge+kommentarlaenge);

        until falsch;

      end; (* Version ermitteln *)

    if version>0 then
      zip_titel:=zip_titel+', '+textz_form__Version_leer^+str0(version div 10)+'.'+str0(version mod 10);

    ausschrift_x('Zip'+zip_titel,packer_dat,absatz);
    archiv_start;


    repeat;
      zip_lesen_und_entschluesseln(form_puffer,o,270);

      if not bytesuche(form_puffer.d[0],'PK') then Break;

      case word_z(@form_puffer.d[2])^ of
       $0201: (* Inhaltsverzeichniseintrag *)
         begin
           IncDGT(o,$2e); (* LÑnge ohne Dateiname *)
           namenlaenge    :=word_z(@form_puffer.d[$1c])^;
           extrafeldlaenge:=word_z(@form_puffer.d[$1e])^;
           kommentarlaenge:=word_z(@form_puffer.d[$20])^;

           verzeichnis:=Odd(form_puffer.d[$26] shr 4) (* faDirectory *)
              and (form_puffer.d[$05] in [0,6,11,14]); (* DOS, OS/2, Windows *)

           volumelabel:=Odd(form_puffer.d[$26] shr 3) (* faVolumeID *)
              and (form_puffer.d[$05] in [0,6,11,14]); (* DOS, OS/2, Windows *)

           if (namenlaenge>200) or (namenlaenge<0) then
             begin
               ausschrift(textz_Archiv_Fehler_fragezeichen^,signatur);
               Break;
             end;

           IncDGT(o,namenlaenge);

           if vom_anfang then
             begin

               exezk:=zip_dateisystem(form_puffer.d[5]);
               if (exezk<>'')
               or (form_puffer.d[34]>diskettenzaehleranfang)
               or (kommentarlaenge<>0)
                then
                 ausschrift_x(textz_Informationen_zu_^+puffer_zu_zk_l(form_puffer.d[$2e],namenlaenge)+' :',packer_dat,absatz);

               bearbeite_extrafelder(o,extrafeldlaenge);



               if exezk<>'' then
                 ausschrift_x(textz_form__leer_Dateisystem_doppelpunkt^+exezk,packer_dat,absatz);

               if form_puffer.d[34]>diskettenzaehleranfang then
                 ausschrift_x(textz_form__Diskette^+': '+str0(form_puffer.d[34]+1-diskettenzaehleranfang),packer_dat,absatz);

               kommentar(o,kommentarlaenge);

             end
           else
             begin
               laenge_eingepackt64:=x_long(form_puffer.d[20]);
               laenge_ausgepackt64:=x_long(form_puffer.d[24]);

               exezk:=puffer_zu_zk_l(form_puffer.d[46],namenlaenge);

               exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(50);

               if (form_puffer.d[$08] and $01)=1 then
                 exezk_anhaengen(textz_form__eckauf_Kennwort_eckzu^);

               exezk_anhaengen(zip_dateisystem(form_puffer.d[5]));

               if form_puffer.d[34]>diskettenzaehleranfang then
                 exezk_anhaengen(' ['+textz_form__Diskette^+str0(form_puffer.d[34]+1-diskettenzaehleranfang)+']');

               bearbeite_extrafelder(o,extrafeldlaenge);

               (* bei PKZIP 2.50 fÅr OS/2 sind die EA nicht
                  im Inhaltsverzeichnis wiederholt *)
               if extrafeldlaenge=0 then
                 begin
                   (* Position des entsprechenden $0403 -Eintrages *)
                   oo:=analyseoff+longint_z(@form_puffer.d[42])^;
                   zip_lesen_und_entschluesseln(form_puffer,oo,46);
                   if bytesuche(form_puffer.d[0],'PK'#$03#$04) then
                     begin
                       IncDGT(oo,30+word_z(@form_puffer.d[26])^);
                       bearbeite_extrafelder(oo,word_z(@form_puffer.d[28])^);
                     end;
                 end;


               archiv_datei64;
               if volumelabel then
                 archiv_datei_ausschrift_label(exezk)
               else
               if verzeichnis then
                 archiv_datei_ausschrift_verzeichnis(exezk)
               else
                 archiv_datei_ausschrift(exezk);

               kommentar(o,kommentarlaenge);
             end;

         end; (* $0201 *)

       $0403: (* Datenblock *)
         begin
           laenge_eingepackt64:=x_long(form_puffer.d[18]);
           laenge_ausgepackt64:=x_long(form_puffer.d[22]);

           exezk:=puffer_zu_zk_l(form_puffer.d[30],form_puffer.d[26]);
           IncDGT(o,30+word_z(@form_puffer.d[26])^);
           exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);

           if (form_puffer.d[$06] and $01)=1 then
             exezk_anhaengen(textz_form__eckauf_Kennwort_eckzu^);

           bearbeite_extrafelder(o,word_z(@form_puffer.d[28])^);

           archiv_datei64;
           archiv_datei_ausschrift(exezk);

           IncDGT(o,laenge_eingepackt);

         end; (* $0403 *)

       $0505: (* header signature *)
         begin
           IncDGT(o,4+2+word_z(@form_puffer.d[2])^);
       end; (* $0505 *)

       $0605: (* Verzeichnisende *)
         begin
           if form_puffer.d[4]>diskettenzaehleranfang then
             ausschrift(textz_form__Dieses_Archiv_ist_auf^+str0(form_puffer.d[4]+1-diskettenzaehleranfang)
              +textz_form__Disketten_verteilt^,packer_dat);

           IncDGT(o,22);
           kommentarlaenge:=word_z(@form_puffer.d[20])^;
           if kommentarlaenge<>0 then
             begin
               ausschrift_x(textz_Archivkommentar^,packer_dat,absatz);
               ansi_anzeige(o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch
                ,o+kommentarlaenge,'');
               IncDGT(o,kommentarlaenge);
             end;

           (* JAOWDSK.ZIP -leerzeichen? Kommentar *)
           Break;
         end; (* $0605 *)

       $0606: (* Verzeichnisende(64) *)
         begin
           {
           if form_puffer.d[4]>diskettenzaehleranfang then
             ausschrift(textz_form__Dieses_Archiv_ist_auf^+str0(form_puffer.d[4]+1-diskettenzaehleranfang)
              +textz_form__Disketten_verteilt^,packer_dat);

           IncDGT(o,22);
           kommentarlaenge:=word_z(@form_puffer.d[20])^;
           if kommentarlaenge<>0 then
             begin
               ausschrift_x(textz_Archivkommentar^,packer_dat,absatz);
               ansi_anzeige(o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch
                ,o+kommentarlaenge,'');
               IncDGT(o,kommentarlaenge);
             end;

           (* JAOWDSK.ZIP -leerzeichen? Kommentar *)}
           IncDGT(o,4+8+2+2+4+4+8+8+8+8{+extra?});
           Break;
         end; (* $0605 *)

       $0706: (* Zip64 end of central directory locator *)
         begin
           IncDGT(o,4+4+8+4);
           {nutzbar?}
         end;

       $0807:
         begin
           ausschrift_x(textz_Multi_Volume_Archiv_Kopf^,packer_dat,absatz);
           IncDGT(o,4);
         end;

       $0a09:
         begin
           (* PKWARE ZIP 2.60 W Installationsanweisungen *)
           bearbeite_0a09(o);
           IncDGT(o,longint_z(@form_puffer.d[8])^);
           if word_z(@form_puffer.d[4])^<=20 then
             (* 2.0: 2.60 W aber nicht 2.1 pkzw400s.exe *)
             IncDGT(o,4+8);
         end;

      else
        Break;
      end;

    until falsch;
    archiv_summe;

    if o>dateilaenge then
      ausschrift(textz_Archiv_Fehler_fragezeichen^,signatur)
    else
      if o>analyseoff then
        einzel_laenge:=o-analyseoff;

  end;

procedure arj(o:dateigroessetyp;reg_auswerten:boolean;reg_zahl:word);
  var
    zeile               :string;
    sicherheitshuellen_o:dateigroessetyp;
    bemerkung           :string;
    kopflaenge2,o0      :dateigroessetyp;
    reco                :dateigroessetyp;
    kopflaenge          :integer_norm;
    w1                  :word_norm;
    arj_datei_typ       :(arj_datei_typ_normal,arj_datei_typ_verzeichnis,arj_datei_typ_volume,arj_datei_typ_kapitel);

  procedure suche_null;
    begin
      repeat
        datei_lesen(form_puffer,analyseoff+o,2);
        if form_puffer.d[0]=0 then Exit;
        IncDGT(o,1);
      until falsch;
    end;

  begin
    datei_lesen(form_puffer,analyseoff+o,$18);
    case form_puffer.d[5] of
       1:exezk:=textz_form__Version_leer^+'<0.14'; (* ARJZ.. *)
       2:exezk:=textz_form__Version_leer^+'0.14..0.20';
       3:exezk:=textz_form__Version_leer^+'1.00-2.22';
       4:exezk:=textz_form__Version_leer^+'2.30'; (* X1 *)
       5:exezk:=textz_form__Version_leer^+'2.39a';
       6:exezk:=textz_form__Version_leer^+'2.39c-2.41';
       7:exezk:=textz_form__Version_leer^+'2.42-2.50';
       8:exezk:=textz_form__Version_leer^+'2.55-2.61';
       9:exezk:=textz_form__Version_leer^+'2.62';
      10:exezk:=textz_form__Version_leer^+'2.62.*';
      11:exezk:=textz_form__Version_leer^+'2.77+';
      50:exezk:=textz_form__Version_leer^+'( 50, ARJZ )'; (* 32K *)
      51:exezk:=textz_form__Version_leer^+'( 51, ARJZ )'; (* 64K *)
     100:exezk:=textz_form__Version_leer^+'Arj32 3.00';
     101:exezk:=textz_form__Version_leer^+'Arj32 3.02';
    else
      exezk:='unbekannte '+textz_form__Version_leer^+'"('+str0(form_puffer.d[5])+')"';
    end;

    case form_puffer.d[7] of
      0:; (* DOS *)
      1:exezk_anhaengen(', PRIMOS');
      2:exezk_anhaengen(', UNIX');
      3:exezk_anhaengen(', AMIGA');
      4:exezk_anhaengen(', MAC');
      5:exezk_anhaengen(', OS/2');
      6:exezk_anhaengen(', APPLE');
      7:exezk_anhaengen(', ATARI');
      8:exezk_anhaengen(', NEXT');
      9:exezk_anhaengen(', VAX VMS');
     10:exezk_anhaengen(', WIN95');
     11:exezk_anhaengen(', WINNT');
    else
      exezk_anhaengen(', OS=?');
    end;

    if (form_puffer.d[8] and $42)>0 then
      exezk_anhaengen(', '+textz_Sicherheitshuelle^);

    if reg_auswerten then
      begin
        if (reg_zahl=$abc0) or ((form_puffer.d[5]<=6) and (reg_zahl<>0)) then
          exezk_anhaengen(', '+textz_form__registriert^)
        else
          exezk_anhaengen(', '+textz_form__nicht_registriert^);
      end;

    if (form_puffer.d[8] and $40)>0 then
      (* nur >2.30 *)
      sicherheitshuellen_o:=longint_z(@form_puffer.d[$14])^
    else
      sicherheitshuellen_o:=0;

    if sicherheitshuellen_o>0 then
      IncDGT(sicherheitshuellen_o,o+$14);

    ausschrift('Arj / Robert K. Jung, '+exezk,packer_dat);

    if not langformat then exit;


    (* zum Haupt-Kommentar *)
    kopflaenge2:=word_z(@form_puffer.d[2])^;
    o0:=o;
    IncDGT(o,form_puffer.d[4]);IncDGT(o,4);
    suche_null; (* Dateiname Åbergehen *)
    IncDGT(o,1);

    (* falls vorhanden: Hauptkommentar *)
    if form_puffer.d[1]<>0 then
      ansi_anzeige(analyseoff+o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],vorne,wahr,falsch,unendlich,'');

    (*
    suche_null;
    inc(o);
    inc(o,4+2);*)
    o:=o0+kopflaenge2+10; (* 2 SIG +2 Kopflaenge +4 CRC +2 Zusatzkopflaenge *)

    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,50);

      kopflaenge2:=word_z(@form_puffer.d[2])^;
      o0:=o;

      if not bytesuche(form_puffer.d[0],#$60#$ea) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          Exit;
        end;

      if kopflaenge2=0 then
        begin
          IncDGT(o,4);
          if bytesuche(form_puffer.d[4],'PSigx'#$00) then (* 2.71 *)
            begin
              ausschrift_x(textz_form__ecc_^+' (-hk)',packer_dat,absatz);
              reco:=longint(word_z(@form_puffer.d[4+12])^) shl 12;
              IncDGT(archiv_summe_eingepackt,reco);
              IncDGT(o,6+reco);
            end;
          Break;
        end;


      laenge_eingepackt:=longint_z(@form_puffer.d[16])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[20])^;
      archiv_datei;

      bemerkung:='';

      kopflaenge:=form_puffer.d[4]+3;

      if (form_puffer.d[8] and $20)=$20 then bemerkung:=bemerkung+textz_form__leer_eckauf_Backup_eckzu^;

      (* Flags *)
      if (form_puffer.d[8] and $08)=$08 then
        begin
          Dec(archiv_summen_dateien);
                                             bemerkung:=bemerkung+textz_form__leer_eckauf_Fortsetzung_eckzu^;
        end;
      if (form_puffer.d[8] and $04)=$04 then bemerkung:=bemerkung+textz_form__leer_eckauf_Bruchstueck_eckzu^;
      if (form_puffer.d[8] and $01)=$01 then bemerkung:=bemerkung+textz_form__eckauf_Kennwort_eckzu^;

      arj_datei_typ:=arj_datei_typ_normal;
      case form_puffer.d[10] of
        0:;(*binary *)
        1:bemerkung:=bemerkung+textz_form__eckauf_sieben_Bit_Text_eckzu^;
        2:;(*comment *)
        3:arj_datei_typ:=arj_datei_typ_verzeichnis;(*bemerkung:=bemerkung+textz_form__eckauf_Verzeichnis_eckzu^;*)
        4:arj_datei_typ:=arj_datei_typ_volume;(*bemerkung:=bemerkung+textz_form__eckauf_Datentraegername_eckzu^;*)
        5:arj_datei_typ:=arj_datei_typ_kapitel;
      (*6:uxspecial*)
      else
          bemerkung:=hex(form_puffer.d[10]);
      end;


      (* Dateiname *)
      IncDGT(o,kopflaenge+1);
      datei_lesen(form_puffer,analyseoff+o,260);
      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
      exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_grenze(41);
      case arj_datei_typ of
        arj_datei_typ_normal:
          archiv_datei_ausschrift(exezk+bemerkung);
        arj_datei_typ_verzeichnis:
          archiv_datei_ausschrift_verzeichnis(exezk+bemerkung);
        arj_datei_typ_volume:
          archiv_datei_ausschrift_label(exezk+bemerkung);
        arj_datei_typ_kapitel:
          archiv_datei_ausschrift_kapitel(exezk+bemerkung);
      end;
      suche_null;
      IncDGT(o,1);

      (* falls vorhanden: Dateikommentar *)
      if form_puffer.d[1]<>0 then
        ansi_anzeige(analyseoff+o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,falsch,unendlich,'');

      suche_null;
      IncDGT(o,1+4); (* 1:Kommentar, 4:CRC *)
      datei_lesen(form_puffer,analyseoff+o,260);
      if word_z(@form_puffer.d[0])^<>0 then
        begin
          Inc(laenge_eingepackt,word_z(@form_puffer.d[0])^+6);
          if form_puffer.d[2]=Ord('E') then
            begin
              ausschrift_x(str_(word_z(@form_puffer.d[5])^,6+5)+textz_form__leer_Byte_EA^,(*packer_dat*)beschreibung,leer);
            end;
        end;

      (*
      suche_null;
      inc(o);
      inc(o,laenge_eingepackt+6);*)
      o:=o0+kopflaenge2+10+laenge_eingepackt; (* 2 SIG +2 Kopflaenge +4 CRC +2 Zusatzkopflaenge *)
    until falsch;

    if o<sicherheitshuellen_o then
      begin
        (* o<>sicherheitshuellen_o aber o ist besser *)
        ausschrift_x(textz_form__Sicherheithuellendaten_ab^+strx_oder_hexDGT(sicherheitshuellen_o),packer_dat,absatz);
        datei_lesen(form_puffer,analyseoff+o+$08,$78);
        for w1:=0 to 76-1 do
          form_puffer.d[(* $08+*)$10+$10+w1]:=
          form_puffer.d[(* $08+*)$10+$10+w1] xor (form_puffer.d[(* $08+*) (w1 and $1f)] or $80);

        ausschrift(puffer_zu_zk_e(form_puffer.d[(* $08+*) $10+$10],#0,76),beschreibung);
        o:=einzel_laenge;
      end;

    archiv_summe;

    einzel_laenge:=o;


  end;

procedure rar(o:dateigroessetyp);
  var
    versuch     :word_norm;
    oh          :dateigroessetyp;
    kopflaenge  :word_norm;
  begin

    if o>0 then
      befehl_schnitt(o,einzel_laenge,erzeuge_neuen_dateinamen('.rar'));

    IncDGT(o,7);

    (* Suche Version=erster Dateiblock *)
    exezk:=' ?.?';
    oh:=o;
    versuch:=10;
    while versuch>0 do
      begin
        datei_lesen(form_puffer,oh,$19);
        if form_puffer.d[2]=Ord('t') then (* Dateiblock *)
          begin
            exezk:=' '+str0(form_puffer.d[$18] div 10)+'.'+str0(form_puffer.d[$18] mod 10);
            Break;
          end;
        (* Weitersuchen *)
        kopflaenge:=word_z(@form_puffer.d[$5])^;
        if (form_puffer.d[$4] and $80)=0 then
          laenge_eingepackt:=0
        else
          laenge_eingepackt:=longint_z(@form_puffer.d[$07])^;
        IncDGT(oh,kopflaenge+laenge_eingepackt);
        Dec(versuch);
      end;

    ausschrift('RAR / Eugene Roshal'+exezk,packer_dat);

    if not langformat then Exit;

    archiv_start;

    repeat
      datei_lesen(form_puffer,o,260); (* lange Dateinamen *)
      kopflaenge:=word_z(@form_puffer.d[$5])^;
      if (form_puffer.d[$4] and $80)=0 then
        laenge_eingepackt:=0
      else
        laenge_eingepackt:=longint_z(@form_puffer.d[$07])^;

      case Chr(form_puffer.d[2]) of
        #0:
          Break;

        'r': (* $72 MARK_HEAD *)
          ausschrift('"MARK_HEAD"',packer_dat);

        's': (* $73 MAIN_HEAD *)
          ausschrift(textz_form__Archivkopf^,packer_dat);

        't': (* $74 FILE_HEAD *)
          begin
            laenge_ausgepackt:=longint_z(@form_puffer.d[$0b])^;
            archiv_datei;
            exezk:=puffer_zu_zk_e(form_puffer.d[$20],#0,word_z(@form_puffer.d[$1a])^);
            exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);

            if (form_puffer.d[$03] and 4)=4 then
              exezk_anhaengen(textz_form__eckauf_Kennwort_eckzu^);

            if (form_puffer.d[$03] and 1)=1 then
              exezk_anhaengen(textz_form__leer_eckauf_Fortsetzung_eckzu^);
            if (form_puffer.d[$03] and 2)=2 then
              exezk_anhaengen(textz_form__leer_eckauf_Bruchstueck_eckzu^);

            (* Directory=$10 *)
            if Odd(form_puffer.d[$1c] shr 4) then
              archiv_datei_ausschrift_verzeichnis(exezk)
            else
              archiv_datei_ausschrift(exezk);

            (* eine 9 MB Datei auf 7 Disketten aufzuteilen sollte nicht 9*7 als Summe ergeben *)
            (* deshalb zÑhle ich diese Datei nur beim ersten mal *)
            if (form_puffer.d[$03] and 1)<>0 then
              begin
                DecDGT(archiv_summe_ausgepackt,laenge_ausgepackt);
                Dec(archiv_summen_dateien);
              end;
          end;

        'u': (* $75 COMM_HEAD *)
          ausschrift(textz_form__eckauf_Kennwort_eckzu^,packer_dat);

        'v': (* $76 AV_HEAD PrÅfsiegel *)
          ausschrift(textz_form__Pruefsummentext^,packer_dat);

        'w': (* $77 SUB_HEAD *)
          (*ausschrift(textz_form__Block_CRC^,packer_dat);*)
          begin (* Unterblock *)
            if bytesuche(form_puffer.d[$0b],#$00#$01) then
              begin
                ausschrift_x(str_(longint_z(@form_puffer.d[$e])^,6+5)+textz_form__leer_Byte_EA^,beschreibung,leer);
              end;
          end;

        'x': (* $78 PROTECT_HEAD (RECOVERY RECORD)  VSD200.EXE *)
          (*ausschrift('"Protect!"',packer_dat)*)
          ausschrift_x(strxDGT(laenge_eingepackt,11)+textz_form____ecc_^,packer_dat,leer);

        'y': (* $79 SIGN_HEAD RARX26B8.EXE *)
          begin (* "Eugene Roshal"... *)
            (*ausschrift('"Protect!"(2)',packer_dat);*)
            ausschrift(textz_form__Echtheitszertifikat^,packer_dat);
          end;

        'z': (* $7a NEWSUB_HEAD  RAR 3.0 Beta 2 *)
          begin
          end;

        '{': (* $7b END_ARC_HEAD  RAR 3.0 Beta 2 *)
          begin
          end;

      else
        ausschrift('???',signatur);
        break;
      end;

      IncDGT(o,kopflaenge+laenge_eingepackt);
      einzel_laenge:=o-analyseoff;

    until form_puffer.d[2]=0;

    archiv_summe;

  end;

(* siehe auch typ_xexe: Peter Koller *)
procedure pack_ibm(const o0:dateigroessetyp;const ver:integer_norm;const nicht_lesbar:string);
  var
    o                   :dateigroessetyp;
    kopflaenge          :word_norm;
  begin
    o:=o0;
    (* PACK.EXE CSF Disk1/2 *)
    (* PACK2.EXE Watcom 11  *)
    if ver<0 then
      (* PACK.EXE=2 PACK2.EXE=3 *)
      ausschrift('PACK / IBM ['+str0(-(ver+1))+']'+nicht_lesbar,packer_dat)
    else
      ausschrift('PACK / IBM'+version_x_y(Hi(ver),Lo(ver))+nicht_lesbar,packer_dat);

    if (not langformat)
    or (nicht_lesbar<>'') then
     Exit;


    (* Innotek: Flash5: DateilÑngen stumm berechnen *)
    if einzel_laenge>$110 then
      begin
        datei_lesen(form_puffer,analyseoff+einzel_laenge-$20,$20);
        (*
        if bytesuche(form_puffer.d[$10],'5FWS?????'#$00#$00#$00) then
          swf5(longint_z(@form_puffer.d[$10+8])^,false,longint_z(@form_puffer.d[$10+4])^)
        else
        if bytesuche(form_puffer.d[$10],'VPC2?????'#$00#$00#$00) then
          swf5(longint_z(@form_puffer.d[$10+8])^,false,longint_z(@form_puffer.d[$10+4])^)
        else *)
        if bytesuche(form_puffer.d[$00],#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00'??????'#$00#$00
            +'??'#$00#$00'??'#$00#$00) then
          begin
            if  (form_puffer.d[$10] in [$20..$7f])
            and (form_puffer.d[$11] in [$20..$7f])
            and (form_puffer.d[$12] in [$20..$7f])
            and (form_puffer.d[$13] in [$20..$7f]) then
              swf5(longint_z(@form_puffer.d[$10+8])^,false,longint_z(@form_puffer.d[$10+4])^)

          end;
      end;

    archiv_start;

    if Hi(ver)=10 then (* $0a14 und $0a15 *)
      begin
        datei_lesen(form_puffer,o,300);
        laenge_eingepackt64:=einzel_laenge;
        laenge_ausgepackt64:=-1;
        archiv_datei64;
        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$0a],#0,255))
      end

    else

      begin

        repeat
          datei_lesen(form_puffer,o,8*16);

          if not bytesuche(form_puffer.d[0],#$a5#$96) then
            Break;

          if ver<=-3 then
            begin
              exezk:=puffer_zu_zk_e(form_puffer.d[$29],#0,255);
              kopflaenge:=word_z(@form_puffer.d[$27])^+56;
            end
          else
            begin
              exezk:=puffer_zu_zk_e(form_puffer.d[$1a],#0,255);
              kopflaenge:=word_z(@form_puffer.d[$18])^+36;
            end;

          laenge_eingepackt64:=longint_z(@form_puffer.d[$14])^;
          if laenge_eingepackt64=0 then
            laenge_eingepackt64:={dateilaenge-o}einzel_laenge-(o-o0)
          else
            DecDGT(laenge_eingepackt64,o);

          DecDGT(laenge_eingepackt64,kopflaenge);
          laenge_ausgepackt64:=longint_z(@form_puffer.d[$10])^;
          if (laenge_ausgepackt64=1) and (longint_z(@form_puffer.d[$0c])^<>0) then
            laenge_ausgepackt:=-1;

          if longint_z(@form_puffer.d[$0c])^<>0 then
            begin
              exezk_leerzeichen_erweiterung_wie_letzte_zeile_mit_rand(20);
              exezk_anhaengen(' [EA]');
            end;

          archiv_datei64;
          archiv_datei_ausschrift(exezk);

          o:=longint_z(@form_puffer.d[$14])^;
          if o=0 then
            begin
              form_puffer.d[0]:=0;
              form_puffer.d[1]:=0;
              Break;
            end;

        until falsch;

        if (not bytesuche(form_puffer.d[0],#0#0))
        and (o+4<einzel_laenge) (* 32 Bit Dateizahl? *)
         then
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);

      end;

    archiv_summe;
  end;


procedure tar(o:dateigroessetyp);
  var
    datum       :dateigroessetyp;
  const
    tagsekunden =24*60*60;
  begin
    ausschrift('tar',packer_dat);
    if not langformat then Exit;

    archiv_start;

    repeat
      datei_lesen(form_puffer,o,512);

      (* VOLUME hat keine Grî·enangabe *)
      if Chr(form_puffer.d[$9c])='V' then
        laenge_eingepackt64:=0
      else
        laenge_eingepackt64:=ziffer_tar(8,puffer_zu_zk_l(form_puffer.d[$7c],12));
      if laenge_eingepackt64<0 then Break;

      (* Dateizeit *)
      datum:=ziffer_tar(8,puffer_zu_zk_l(form_puffer.d[$88],12));
      (* 1980 .. 2020 *)
      if (datum<tagsekunden*365*10) or (tagsekunden*365*50<datum) then Break;


      laenge_ausgepackt64:=laenge_eingepackt64;

      archiv_datei64;
      exezk:=puffer_zu_zk_e(form_puffer.d,#0,255);
      case Chr(form_puffer.d[$9c]) of
        #0,
        '0':; (* normale Datei *)
        '1':exezk_anhaengen(textz_form__eckauf_Link_eckzu^);
        '2':exezk_anhaengen(textz_form_eckauf_Sym_Link_eckzu^+' -> '+puffer_zu_zk_e(form_puffer.d[$9d],#0,255));
        '3':exezk_anhaengen(textz_form__eckauf_Zeichengeraet_eckzu^);
        '4':exezk_anhaengen(textz_form__eckauf_Blockgeraet_eckzu^);
        '5':; (*exezk_anhaengen(textz_form__eckauf_Verzeichnis_eckzu^);*)
        '6':exezk_anhaengen(' [FIFO]');
        '7':exezk_anhaengen(' [contigous]');
        'D':exezk_anhaengen(' [DUMPDIR]');
        'M':exezk_anhaengen(' [MULTIVOL]');
        'N':exezk_anhaengen(' [NAMES]');
        'S':exezk_anhaengen(' [SPARSE]');
        'V':exezk_anhaengen(' [VOLUME]');
        'A':exezk_anhaengen(' [EA]');
        'L':exezk_anhaengen(' [ACL]');
        'Z':exezk_anhaengen(' [COMPRESSED]');
      else
            exezk_anhaengen('? "'+Chr(form_puffer.d[$9c])+'"');
      end;

      if Chr(form_puffer.d[$9c])='5' then
        archiv_datei_ausschrift_verzeichnis(exezk)
      else
        archiv_datei_ausschrift(exezk);
      IncDGT(o,512);
      IncDGT(o,AndDGT(laenge_eingepackt64+512-1,-512));
    until falsch;

    archiv_summe;
  end;

procedure stirling_neu(const p:puffertyp);
  var
    zaehler,
    verzeichnis_anzahl,
    datei_anzahl        :word_norm;
    o                   :longint;
    verzeichnis_posi    :longint;
    verzeichnis_zaehler :word_norm;
    verzeichnis         :string;
    ende                :longint;
  begin
    ausschrift('The Stirling Compressor V. ?.?.X "]eå" / The Stirling Group [1993]',packer_dat);

    if not langformat then exit;

    if p.d[$1f]<>0 then
      ausschrift('['+textz_form__Diskette^+str0(p.d[$1f])+']',beschreibung);

    if p.d[$1f]>1 then
      begin
        archiv_start_leise;
        archiv_summe_eingepackt:=einzel_laenge;
        archiv_summe_leise;
        Exit;
      end;

    archiv_start;


    verzeichnis_anzahl:=word_z(@p.d[$31])^;
    datei_anzahl      :=word_z(@p.d[$0c])^;
    o                 :=longint_z(@p.d[$29])^;
    ende              :=longint_z(@p.d[$3b])^;

    verzeichnis_zaehler:=0;
    verzeichnis_posi:=o;



    for zaehler:=1 to verzeichnis_anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        inc(o,word_z(@form_puffer.d[$02])^);
      end;

    (* ------------------------------- *)

    o   :=longint_z(@p.d[$33])^;

    for zaehler:=1 to datei_anzahl do
      begin
        if verzeichnis_zaehler=0 then
          begin
            datei_lesen(form_puffer,analyseoff+verzeichnis_posi,512);
            verzeichnis:=puffer_zu_zk_e(form_puffer.d[$06],#0,500);
            if verzeichnis<>'' then verzeichnis:=verzeichnis+'\';
            verzeichnis_zaehler:=word_z(@form_puffer.d[  0])^;
            inc(verzeichnis_posi,word_z(@form_puffer.d[$02])^);
          end;

        Dec(verzeichnis_zaehler);

        datei_lesen(form_puffer,analyseoff+o,512);

        laenge_eingepackt:=longint_z(@form_puffer.d[3+4])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[3+0])^;

        archiv_datei;

        archiv_datei_ausschrift(verzeichnis+puffer_zu_zk_pstr(form_puffer.d[$1d]));

        Inc(o,word_z(@form_puffer.d[$17])^);
      end;

    archiv_summe;
    einzel_laenge:=o;
  end;

procedure stirling_setup(const p:puffertyp);
  var
    o                   :longint;
    anzahl              :word_norm;
    w1                  :word_norm;
  begin
    ausschrift('installSHIELD / The Stirling Group INSTALL',packer_dat);
    if not langformat then exit;

    o:=$52;
    archiv_start;
    anzahl:=word_z(@p.d[$4e])^;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,500);
        laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[8])^;

        archiv_datei;

        exezk:=puffer_zu_zk_l(form_puffer.d[$16],form_puffer.d[$14]);
        archiv_datei_ausschrift(exezk);

        befehl_ttdecomp(analyseoff+longint_z(@form_puffer.d[0])^,laenge_eingepackt,exezk);

        w1:=$16+word_z(@form_puffer.d[$14])^;
        Inc(w1, word_z(@form_puffer.d[w1 ])^);
        Inc(o,2+w1);
        Dec(anzahl);
      end;
    archiv_summe;

  end;

procedure stirling_alt;
  begin
    ausschrift('The Stirling Compressor V. 1.3.X "e]å" / The Stirling Group [1991]',packer_dat);

    if not langformat then exit;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      laenge_eingepackt:=-1;
      laenge_ausgepackt:=-1;

      archiv_datei;

      ausschrift_x(laenge_ausgepackt_zk+'   ?'+'  '
      +puffer_zu_zk_pstr(form_puffer.d[$0e]),packer_dat,absatz);

      o:= longint_z(@form_puffer.d[$04])^+1;
    until longint_z(@form_puffer.d[$04])^=0;

    archiv_summe;
  end;

procedure hap3;
  var
    o:longint;
  begin
    ausschrift('HAP 3 / Harald Feldmann',packer_dat);
    if not langformat then exit;
    archiv_start;
    o:=0;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if o+$f>=einzel_laenge then
        break;

      laenge_eingepackt:=longint_z(@form_puffer.d[$13])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$25])^;

      if laenge_eingepackt>laenge_ausgepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          Exit;
        end;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$29],#0,255));

      Inc(o,laenge_eingepackt);
      Inc(o,40);
    until falsch;

    archiv_summe;
  end;

procedure ha(const p:puffertyp;const zusatz:string);
  var
    o                   :longint;
    pfad                :string;
  begin
    if (puffer_anzahl_suche(p,' ',100)>8) then exit;

    (* Version *)
    if ((p.d[4] shr 4)<1) or ((p.d[4] shr 4)>10) then exit;

    (* Anzahl Dateien *)
    if (word_z(@p.d[2])^<1) or (16000<word_z(@p.d[2])^) then exit;

    laenge_eingepackt:=longint_z(@p.d[4+$01])^;
    laenge_ausgepackt:=longint_z(@p.d[4+$05])^;

    if laenge_eingepackt>laenge_ausgepackt then exit;

    pfad:=puffer_zu_zk_e(p.d[4+$11],#0,255);
    exezk:=puffer_zu_zk_e(p.d[4+$11+length(pfad)+1],#0,512-length(pfad)-50);
    if (length(pfad)>200)
    or (length(exezk)>200)
    or (length(exezk)<1)
     then
      Exit;


    (******************************************************************)

    ausschrift('HA / Harri Hirvola'+zusatz,packer_dat);

    if not langformat then exit;
    archiv_start;
    o:=4;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if o+$f>=einzel_laenge then
        break;

      laenge_eingepackt:=longint_z(@form_puffer.d[$01])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$05])^;

      if laenge_eingepackt>laenge_ausgepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      archiv_datei;

      pfad:=puffer_zu_zk_e(form_puffer.d[$11],#0,255);
      exezk:=puffer_zu_zk_e(form_puffer.d[$11+length(pfad)+1],#0,512-length(pfad)-50);

      Inc(o,laenge_eingepackt);
      Inc(o,length(pfad));
      Inc(o,length(exezk));
      Inc(o,22);

      if pfad[length(pfad)]=#255 then
        pfad[length(pfad)]:='/';

      archiv_datei_ausschrift(pfad+exezk);


    until falsch;

    archiv_summe;
  end;

procedure hyper(const version:byte);
  var
    o:longint;
  begin
    ausschrift('Hyper / Peter Sawatzki '+version_div16_mod16(version),packer_dat);

    if not langformat then exit;
    archiv_start;
    o:=0;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not (bytesuche(form_puffer.d[0],^z'HP') or bytesuche(form_puffer.d[0],^z'ST')) then
        break;

      laenge_eingepackt:=longint_z(@form_puffer.d[$04])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$08])^;

      if laenge_eingepackt>laenge_ausgepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      archiv_datei;

      Inc(o,laenge_eingepackt);
      Inc(o,5*4+2+form_puffer.d[5*4+1]);

      archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[5*4+1]));


    until falsch;

    if form_puffer.g<>0 then
      ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);

    archiv_summe;
  end;

procedure zoo;
  var
    o                   :longint;
    pfad                :string;
  begin
    datei_lesen(form_puffer,analyseoff,512);

    o:=puffer_pos_suche(form_puffer,#$dc#$a7#$c4#$fd,30);
    ausschrift('Zoo / Rahul Dhesi'+version100(word(form_puffer.d[o+$c])*100+form_puffer.d[o+$e]),packer_dat);
    if not langformat then exit;

    archiv_start;
    o:=word_z(@form_puffer.d[o+4])^;
    pfad:='';

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],#$dc#$a7#$c4#$fd) then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      (*
          4 b directory type
          5 b 0=m0 1=lzw
          6 l off von Anfang zur nÑchsten directory
          a l postion  dieser datei vom anfang
          e w datum
         10 w zeit
         12 w crc
         14 l grî·e aus
         18 l grî·e ein
         1c b major ver extr
         1d b minor ver extr
         1e b gelîscht=1
         1f b file structure if any
         20 l kommentar off vom anfang
         24 w kommentarlaenge
         26 0`dateiname 8+1+3+1
         33 w length of variable part of dir entry
         35 b zeitzohne
         36 w crc dir
         --------------------------------------------
         38 b lÑnge langer dateiname
         39 b lÑnge verzeichnis
         3a w dateisystem
?        3c w dateiattribute
?        3e w version flags
?        40 w versiondnummer
         *)

      laenge_eingepackt:=longint_z(@form_puffer.d[$18])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$14])^;

      if bytesuche(form_puffer.d[5],#0#0#0#0#0#0#0#0#0#0#0) then break;

      archiv_datei;

      o:=longint_z(@form_puffer.d[6])^;

      exezk:=puffer_zu_zk_e(form_puffer.d[$26],#0,8+1+3+1);
      (* langer Dateiname? *)
      if form_puffer.d[$38]>0 then
        exezk:=puffer_zu_zk_e(form_puffer.d[$3a],#0,form_puffer.d[$38]);

      if form_puffer.d[$39]>0 then
        pfad:=puffer_zu_zk_e(form_puffer.d[$3a+form_puffer.d[$38]],#0,form_puffer.d[$39])+'\';

      archiv_datei_ausschrift(pfad+exezk);

      (* Kommentar *)
      if word_z(@form_puffer.d[$24])^>0 then
        ansi_anzeige(longint_z(@form_puffer.d[$20])^,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
         ,absatz,wahr,not wahr,+longint_z(@form_puffer.d[$20])^+word_z(@form_puffer.d[$24])^,'');
    until falsch;

    if bytesuche(form_puffer.d[0],#$dc#$a7#$c4#$fd)
    and bytesuche(form_puffer.d[$36],#$fc#$83)
    and (o+$36+2<einzel_laenge)
     then
       ansi_anzeige(o+$36+2,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
         ,absatz,wahr,not wahr,unendlich,'');

    archiv_summe;
  end;


procedure amgc(const p:puffertyp);
  var
    o                   :longint;
    w1                  :word_norm;
  begin
    (* SuperPK2 ist kompatibel zu AMGC! (oder umgekehrt) *)
    ausschrift('AMGC / Milen Georgiev '+version_div16_mod16(p.d[2]),packer_dat);

    if not langformat then exit;
    archiv_start;
    o:=$e;

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      if form_puffer.g<$15 then break;

      laenge_eingepackt:=longint_z(@form_puffer.d[$00])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$04])^;

      if laenge_eingepackt>laenge_ausgepackt+50 then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      archiv_datei;

      Inc(o,laenge_eingepackt);

      exezk:=+puffer_zu_zk_l(form_puffer.d[$13],8+3);
      insert('.',exezk,9);
      w1:=8;
      while (exezk[w1]=#0) and (w1>1) do
        begin
          delete(exezk,w1,1);
          dec(w1);
        end;
      if exezk[length(exezk)]='.' then
        dec(exezk[0]);

      archiv_datei_ausschrift(
        puffer_zu_zk_l(form_puffer.d[$21],form_puffer.d[$1e])
       +exezk);


    until falsch;

    archiv_summe;

  end;

procedure freeze;
  var
    o                   :longint;
    verzeichnis         :string;
  begin
    ausschrift('Freeze! / Alan Reeve',packer_dat);

    if not langformat then exit;
    archiv_start;

    o:=0;
    datei_lesen(form_puffer,analyseoff+o,512);
    verzeichnis:=puffer_zu_zk_l(form_puffer.d[$14],word_z(@form_puffer.d[$12])^);
    Inc(o,length(verzeichnis));
    Inc(o,26);
    if verzeichnis<>'' then
      verzeichnis:=verzeichnis+'\';



    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      if form_puffer.g<20 then break;


      exezk:=puffer_zu_zk_l(form_puffer.d[$0c],word_z(@form_puffer.d[$0a])^);

      laenge_eingepackt:=longint_z(@form_puffer.d[$04])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$00])^;

      if laenge_eingepackt>laenge_ausgepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          exit;
        end;

      archiv_datei;

      Inc(o,laenge_eingepackt);
      Inc(o,length(exezk));
      Inc(o,18);

      archiv_datei_ausschrift(verzeichnis+exezk);


    until falsch;

    archiv_summe;

  end;

procedure quantum(const qv_puffer:puffertyp);
  var
    dateien             :word_norm;
    o                   :longint;
    namen_laenge        :word_norm;
    kommentar_laenge    :word_norm;
  begin
    if qv_puffer.d[2]*100+qv_puffer.d[3]<90 then  (* SIDEKICK *)
      begin
        ausschrift(textz_form__unbekanntes_Archiv^+' <SIDEKICK(Quantum?) ¯>',packer_dat);
        if not langformat then exit;

        archiv_start;

        o:=8;
        for dateien:=1 to qv_puffer.d[4] do
          begin
            datei_lesen(form_puffer,analyseoff+o,512);
            exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
            namen_laenge:=length(exezk)+1;
            kommentar_laenge:=form_puffer.d[namen_laenge+0]+1;

            laenge_eingepackt:=longint_z(@form_puffer.d[namen_laenge+kommentar_laenge])^;
            laenge_ausgepackt:=laenge_eingepackt;

            archiv_datei;

            Inc(o,namen_laenge+kommentar_laenge);
            Inc(o,4+2+2+2);

            ausschrift_x(laenge_ausgepackt_zk+'   ?'+'  '+exezk,packer_dat,absatz);

          end;

        archiv_summe_eingepackt:=einzel_laenge;
        archiv_summe_eingepackt_unbekannt:=falsch;
        archiv_summe;

      end
    else
      begin

        ausschrift('Quantum / Cinematronics '+str0(qv_puffer.d[2])+'.'+str0(qv_puffer.d[3]),packer_dat);
        if not langformat then exit;

        archiv_start;

        o:=8;
        for dateien:=1 to qv_puffer.d[4] do
          begin
            datei_lesen(form_puffer,analyseoff+o,512);
            if form_puffer.d[0]>=$80 then
              begin
                exezk:=puffer_zu_zk_l(form_puffer.d[2],(form_puffer.d[0] and $7f)*256+form_puffer.d[1]);
                namen_laenge:=length(exezk)+2;
              end
            else
              begin
                exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
                namen_laenge:=length(exezk)+1;
              end;

            if form_puffer.d[namen_laenge]>=$80 then
              kommentar_laenge:=(form_puffer.d[namen_laenge+0] and $7f)*256+form_puffer.d[namen_laenge+1]+2
            else
              kommentar_laenge:=form_puffer.d[namen_laenge+0]+1;

          laenge_eingepackt:=longint_z(@form_puffer.d[namen_laenge+kommentar_laenge])^;
          laenge_ausgepackt:=laenge_eingepackt;

          archiv_datei;

          Inc(o,namen_laenge+kommentar_laenge);
          Inc(o,4+2+2);

          ausschrift_x(laenge_ausgepackt_zk+'   ?'+'  '+exezk,packer_dat,absatz);

        end;

        archiv_summe_eingepackt:=einzel_laenge;
        archiv_summe_eingepackt_unbekannt:=falsch;
        archiv_summe;
      end;
  end;

procedure instalit(start_verzeichnis,start_info:dateigroessetyp);
  var
    o:dateigroessetyp;
  begin
    (*
      $1a: dott

      $1c: geoworks update
           sound blaster update
      *)
    o:=start_verzeichnis;

    datei_lesen(form_puffer,o,10);

    if bytesuche(form_puffer.d[1],'[IML')
    or bytesuche(form_puffer.d[1],'[LRM')
    or bytesuche(form_puffer.d[1],'[SCR')
    or bytesuche(form_puffer.d[1],'[Scr')
     then
      begin
        ausschrift(textz_form__Installationsanweisungen^+' Instalit Multilingual / ??? ¯',signatur);
        exit;
      end;

    if not bytesuche(form_puffer.d[1],'[PVM') then
      exit;

    ausschrift('Instalit Multilingual / ??? ¯',packer_dat);
    case form_puffer.d[$00+6] of
      $1a:ausschrift(textz_form__Einzeldatein_sind_mit^+'NOGATE'+textz_form__Bibliothek_gepackt^,packer_dat);
      $1c:ausschrift(textz_form__Einzeldatein_sind_mit^+'PKWARE'+textz_form__Bibliothek_gepackt^,packer_dat);
    else
      ausschrift(textz_form__unbekannte_Version^+' ¯',signatur);
    end;



    if not langformat then exit;


    archiv_start;


    (* Archivtitel *)
    if start_info=0 then
      start_info:=unendlich
    else
      begin
        datei_lesen(form_puffer,start_info,512);
        ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung);
      end;


    (* Dateien *)
    IncDGT(o,6);
    repeat
      datei_lesen(form_puffer,{analyseoff+}o,512);

      if form_puffer.g<20 then break;

      case form_puffer.d[$00] of
        $1a:
          begin

            laenge_ausgepackt:=longint_z(@form_puffer.d[$21])^;
            laenge_eingepackt:=-1;
            archiv_datei;

            exezk:=copy(puffer_zu_zk_e(form_puffer.d[6],#0,12)+'            ',1,12);

            ausschrift_x(laenge_ausgepackt_zk+'   ?'+'  '
            +exezk
            +textz_form__leerleer_Paket_doppelpunkt^+str0(form_puffer.d[$20])
            +textz_form__leerleer_Diskette_doppelpunkt^+str0(form_puffer.d[$1e])
            ,packer_dat,absatz);

            IncDGT(o,$2f);
          end;
        $1c:
          begin
            laenge_ausgepackt:=longint_z(@form_puffer.d[$23])^;
            laenge_eingepackt:=longint_z(@form_puffer.d[$14])^;
            archiv_datei;

            exezk:=copy(puffer_zu_zk_e(form_puffer.d[6],#0,12)+'            ',1,12);

            archiv_datei_ausschrift(
               exezk
              +textz_form__leerleer_Paket_doppelpunkt^+str0(form_puffer.d[$27])
              +textz_form__leerleer_Diskette_doppelpunkt^+str0(form_puffer.d[$20]));

            IncDGT(o,$37);
            if form_puffer.d[$37]=0 then
              begin
                (*$IfNDef ENDVERSION*)
                (* ausschrift('+4',virus); *)
                (*$EndIf*)
                IncDGT(o,4);
              end;
          end;
      else
        break;
      end;

    until o>=start_info;

    archiv_summe;

  end;

procedure rnc;
  var
    o                   :longint;
    verzeichnis         :string;
  begin
    o:=0;
    datei_lesen(form_puffer,analyseoff+o,16);
    verzeichnis:='';

    if not bytesuche(form_puffer.d[0],'RNCA') then
      begin
        (* M-pockets level0.pin *)

        archiv_start_leise;
        laenge_eingepackt:=m_longint(form_puffer.d[8]);
        laenge_ausgepackt:=m_longint(form_puffer.d[4]);
        archiv_datei;
        ausschrift(textz_form__Daten_minus^+'Pro-Pack / Rob Northen Computing '
         +laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);
        archiv_summe_leise;

        einzel_laenge:=$12+laenge_eingepackt;
      end
    else
      begin
        ausschrift('Pro-Pack '+textz_form__Archiv^+' / Rob Northen Computing',packer_dat);

        if not langformat then exit;
        archiv_start;

        o:=$b;
        repeat
          datei_lesen(form_puffer,analyseoff+o,512);
          exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
          if exezk='' then
            begin
              if  bytesuche(form_puffer.d[0],#0'RNC')
              and (form_puffer.d[4]<$10)
               then
                Break;

              verzeichnis:=puffer_zu_zk_e(form_puffer.d[3],#0,255);
              Inc(o,length(verzeichnis));
              Inc(o,4);
            end
          else
            begin
              datei_lesen(form_puffer,(* nicht analyseoff!+*)m_longint(form_puffer.d[length(exezk)+1]),$20);

              laenge_ausgepackt:=m_longint(form_puffer.d[4]);
              if form_puffer.d[3]=0 then (* 'RNC'#0 *)
                laenge_eingepackt:=laenge_ausgepackt
              else                       (* 'RNC'#1 *)
                laenge_eingepackt:=m_longint(form_puffer.d[8]);
              archiv_datei;

              Inc(o,length(exezk));
              Inc(o,5);

              archiv_datei_ausschrift(verzeichnis+exezk);
            end

        until falsch;

        archiv_summe;


      end;
  end;

procedure compress_ms(const cpuffer:puffertyp;const o0,l:dateigroessetyp;const namensvorschlag:string);
  var
    vers        :string;
    dname       :string;
    erw         :string;
  begin
    vers:=puffer_zu_zk_l(cpuffer.d[0],4);
    erw:='';
    if vers='SZDD' then (* LZ77? *)
      begin
        laenge_eingepackt64:=l;
        laenge_ausgepackt64:=longint_z(@cpuffer.d[10])^;

        archiv_start_leise;
        archiv_datei64;
        vers:='2.00'+' '+laenge_ausgepackt_zk+verhaeltnis_zk+'%';
        archiv_summe_leise;
      end
    else if vers='KWAJ' then
      begin
        vers:='1.4'; (* MSZIP--inflate? *)
        erw:=puffer_zu_zk_e(cpuffer.d[14],#0,3);
      end
    else
      begin
        vers:='"'+vers+'"';
        (*$IfNDef ENDVERSION*)
        ausschrift('version einordnen>>>>>>>>>>>>>',virus);
        (*$EndIf*)
      end;

    ausschrift('Compress / MS '+vers,packer_dat);

    if o0=-1 then Exit;

    dname:=namensvorschlag;

    if (o0=0) and (dname='') then
      begin
        dname:=dateiname;
        rate_dateinamenserweiterung(dname,erw);
      end;

    befehl_expand_ms(o0,l,dname);
  end;

procedure pnpack(var ppuffer:puffertyp);
  var
    o:dateigroessetyp;
  begin
    ausschrift('Netware Pack / Novell,Caldera ['+str0(ppuffer.d[$19])+']',packer_dat);
    if not langformat then exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'Pac') then break;

      if form_puffer.d[$19]>=3 then
        laenge_eingepackt64:=longint_z(@form_puffer.d[$1f])^
      else
        laenge_eingepackt64:=einzel_laenge;

      laenge_ausgepackt64:=longint_z(@form_puffer.d[$1b])^;

      archiv_datei64;
      archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[12],12));

      IncDGT(o,laenge_eingepackt64);
    until o>=einzel_laenge;

    archiv_summe;
    einzel_laenge:=o;

    ppuffer.d[0]:=0;
  end;


procedure diet_datendatei(const dpuffer:puffertyp;const version:string;ofs:word);
  begin
    if ofs=nicht_gefunden then
      begin
        laenge_eingepackt64:=einzel_laenge;
        laenge_ausgepackt64:=-1;
      end
    else
      begin
        laenge_eingepackt64:=longint(word_z(@dpuffer.d[ofs+1])^)+longint(dpuffer.d[ofs+0] and $0f)*$10000+
          +ofs+8; (* DLZ-Kopf *)
        laenge_ausgepackt64:=longint(word_z(@dpuffer.d[ofs+6])^)+longint(dpuffer.d[ofs+5])*$4000;
      end;

    archiv_start_leise;
    archiv_datei64;
    ausschrift('Diet '+textz_form__komprimierte_Daten^+' ['
      +version+'] '+laenge_ausgepackt_zk+verhaeltnis_zk+'%',packer_dat);
    archiv_summe_leise;

    einzel_laenge:=laenge_eingepackt64;

  end;

procedure mthd;
  var
    mtrk_start,
    mtrk_laenge,
    o                   :longint;
    zaehl               :word_norm;
    i                   :word_norm;
    z1,z2               :longint;

  function lies_wert_variabler_laenge:longint;
    var
      tmp:longint;

    begin
      tmp:=0;

      repeat
        tmp:=(tmp shl 7) or (form_puffer.d[i] and $7f);
        Inc(i);
      until (form_puffer.d[i-1] and $80)=0;

      lies_wert_variabler_laenge:=tmp;
    end;

  begin
    ausschrift('Midi',musik_bild);

    if not langformat then exit;

    o:=$e;

    repeat
      datei_lesen(form_puffer,analyseoff+o,8);Inc(o,8);
      if not bytesuche(form_puffer.d[0],'MT') then break;

      mtrk_start :=o;
      mtrk_laenge:=m_longint(form_puffer.d[4]);

      zaehl:=0;
      exezk:='';
      repeat
        Inc(zaehl);
        if zaehl=8 then
          begin
            (*$IfNDef ENDVERSION*)
            ausschrift(exezk,signatur);
            (*$Else*)
            ausschrift(exezk,signatur);
            (*$EndIf*)
            break;
          end;

        datei_lesen(form_puffer,analyseoff+o,512);
        i:=0;
        z1:=lies_wert_variabler_laenge; (* delta-time *)

        case form_puffer.d[i] of
          $ff: (* meta-event *)
            begin
              Inc(i); (* FF *)
              case form_puffer.d[i]  of
                1, (* Text Event                *)
                2, (* Copyright Notice          *)
                3, (* Sequence/Track Name       *)
               4 , (* Instrument Name           *)
            (*  5     Lyric                     *)
                6: (* Marker                    *)
                  begin
                    Inc(i);
                    z2:=lies_wert_variabler_laenge; (* LÑnge *)
                    if z2>255 then z2:=255;
                    ausschrift(puffer_zu_zk_l(form_puffer.d[i],z2),beschreibung);
                    Break;
                  end;
                $51:
                  begin
                    Inc(i);
                    Inc(i,lies_wert_variabler_laenge); (* LÑnge *)
                    exezk_anhaengen('Tempo ');
                  end;
                $58:
                  begin
                    Inc(i);
                    Inc(i,lies_wert_variabler_laenge); (* LÑnge *)
                    exezk_anhaengen('Time-Signature ');
                  end;
                $59:
                  begin
                    Inc(i);
                    Inc(i,lies_wert_variabler_laenge); (* LÑnge *)
                    exezk_anhaengen('Key-Signature ');
                  end;

              else
                Inc(i);
                Inc(i,lies_wert_variabler_laenge); (* LÑnge *)
              end;

            end;
        else
          ausschrift(exezk,signatur);
          Break;
        end;

        Inc(o,i);

      until o>=mtrk_start+mtrk_laenge;

      o:=mtrk_start+mtrk_laenge;
    until falsch

  end;

procedure cpz;
  var
    o                   :longint;
    dateizahl           :longint;
    zaehl               :longint;
  begin
    o:=0;
    datei_lesen(form_puffer,analyseoff+o,10);

    if not bytesuche(form_puffer.d[2],#0#0) then
      exit;

    ausschrift('CPSHRINK / PCT 9 [PKWARE-'+textz_form__Bibliothek^+']',packer_dat);
    if not langformat then exit;

    archiv_start;

    dateizahl:=longint_z(@form_puffer.d[0])^;

    o:=$c; (* 30573 *)
    for zaehl:=1 to dateizahl do
      begin
        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
        laenge_eingepackt:=longint_z(@form_puffer.d[$14])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[$10])^;

        archiv_datei;

        Inc(o,$20);

        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,255));
      end;

    archiv_summe;

  end;

procedure cp_backup(const p:puffertyp);
  const
    schluessel          :array[1..8] of byte=($DA,$C3,$B6,$E2,$A5,$FA,$EE,$AA);

  var
    o                   :longint;
    verzeichnis         :string;
    variante            :byte;
    z                   :byte;
    w1                  :word_norm;

  begin
    variante:=p.d[0];
    case variante of
      1:exezk:=textz_form__klammer_disk_klammer^;
      2:exezk:=textz_form__klammer_Band_klammer^;
    else
      exezk:='';
    end;

    case variante of
      1:o:=p.d[8]*4+$10; (* Diskettengrî·en? *)
      2:o:=$14;          (* Konstant? *)
    else
        o:=$14;
    end;

    datei_lesen(form_puffer,analyseoff+o,512);

    ausschrift('Central Point Backup '+textz_form__Inhaltsverzeichnis^+' [9]'+exezk,packer_dat);

    (* Sicherungstitel *)

    case variante of
      1:exezk:=puffer_zu_zk_e(form_puffer.d[$45],#0,31);
      2:exezk:=puffer_zu_zk_e(p.d[$47],#0,31);
    else
        exezk:='';
    end;
    ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);

    (* Kennwort *)
    exezk:='';
    for w1:=1 to 8 do
      begin
        z:=form_puffer.d[$64+Pred(w1)];
        if z in [$00,$80] then
          Break;
        z:=form_puffer.d[$64+Pred(w1)] xor schluessel[w1];
        if z<$20 then
          z:=z xor $80;
        exezk_anhaengen(Chr(z));
      end;

    if exezk<>'' then
      ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);

    (* Stammverzeichnis *)
    ausschrift(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(form_puffer.d[0],#0,81)),beschreibung);


    if not langformat then exit;

    archiv_start;

    (*...
    case variante of
      1:o:=$b8-$35-2;
      2:o:=$b8-$35;
    else
      exit;
    end;*)
    Inc(o,$6d);

    verzeichnis:='';

    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      case form_puffer.d[0] of
       $da: (* Verzeichnis + *)
         begin
           if (Length(verzeichnis)>0) and (verzeichnis[Length(verzeichnis)]<>'\') then
             verzeichnis:=verzeichnis+'\';

           verzeichnis:=verzeichnis+puffer_zu_zk_e(form_puffer.d[2],#0,255);

           laenge_ausgepackt:=0;
           laenge_eingepackt:=0;

           archiv_datei;

           archiv_datei_ausschrift(verzeichnis);
           Inc(o,$10);
         end;
       $db:  (* Datei *)
         begin
           laenge_ausgepackt:=longint_z(@form_puffer.d[$14])^;
           laenge_eingepackt:=laenge_ausgepackt;

           archiv_datei;

           exezk:=verzeichnis;
           if verzeichnis<>'' then
             if verzeichnis[Length(verzeichnis)]<>'\' then
               exezk_anhaengen('\');
           exezk_anhaengen(puffer_zu_zk_e(form_puffer.d[2],#0,255));
           archiv_datei_ausschrift(exezk);
           if variante=2 then
             Inc(o,$1e)
           else
             Inc(o,$1c);

         end;
       $dc:  (* Verzeichnis + *)
         begin
           if length(verzeichnis)>0 then
             begin
               while (Length(verzeichnis)>0) and (verzeichnis[Length(verzeichnis)]<>'\') do
                 Dec(verzeichnis[0]);
               if Length(verzeichnis)>0 then
                 Dec(verzeichnis[0]);
             end;
           Inc(o,1);
         end;
       $de: (* Ende *)
         begin
           Inc(o);
           einzel_laenge:=o;
           Break;
         end;
       $00: (* Ende *)
         begin
           einzel_laenge:=o;
           Break;
         end;
      else
        ausschrift(textz_Archiv_Fehler_fragezeichen^,signatur);
        Break;
      end;

    until falsch;

    archiv_summe;

  end;

procedure bdiff;
  var
    o:longint;
  begin
    ausschrift('BDIFF / T.Tanaka',packer_dat);
    if not langformat then exit;

    archiv_start;

    o:=0;
    repeat;
      datei_lesen(form_puffer,analyseoff+o,512);

      if not bytesuche(form_puffer.d[0],')v') then break;

      laenge_ausgepackt:=longint_z(@form_puffer.d[10])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[2])^;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$22],#0,255));

       Inc(o,$4e);

    until falsch;

    archiv_summe;

  end;

procedure quickfix;
  var
    o                   :longint;
    zeile               :string;
    zaehler             :word_norm;
  begin
    o:=4;
    for zaehler:=1 to 4 do
      begin
        datei_lesen(form_puffer,analyseoff+o,270);
        zeile:=puffer_zu_zk_pstr(form_puffer.d[0]);
        if filter(zeile)<>zeile then
          Exit;

        Inc(o,form_puffer.d[0]+1);
        if ({o}zaehler in [1,3]) and ((Length(zeile)=0) or (Length(zeile)>80)) then
          Exit;
      end;

    ausschrift('QUICKFIX / R.Janorkar [2.01]',packer_dat);
    (* Archive sind teilweise verschlÅsselt *)

    o:=4;
    for zaehler:=1 to 4 do
      begin
        datei_lesen(form_puffer,analyseoff+o,270);
        if zaehler>1 then
          ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung);
        Inc(o,form_puffer.d[0]+1);
      end;

  end;


(* referenzhandbuch dateiformate g.born *)
procedure tiff(const o0,l:dateigroessetyp;const verschachtelt:string);
  var
    intel               :boolean;
    datetime            :string[20];

  procedure exif_subifd(const ifd_o0,l:dateigroessetyp);forward;

  procedure tag(const tof:dateigroessetyp);
    var
      tagtyp            :word_norm;
      datentyp,
      laenge,
      zeiger_oder_wert  :longint;
      i                 :word_norm;
      wo                :dateigroessetyp;
      wert              :array[1..4] of longint;
      wert1_zk          :string[30];

    function datentyp_laenge:longint;
      begin
        case datentyp of
          1: (* unsigned Byte *)
            datentyp_laenge:=1;
          2: (* ASCII strings *)
            datentyp_laenge:=1;
          3: (* unsigned short *)
            datentyp_laenge:=2;
          4: (* unsigned long *)
            datentyp_laenge:=4;
          5: (* unsigned rational *)
            datentyp_laenge:=8;
          6: (* /signed Byte *)
            datentyp_laenge:=1;
          7: (* undefined *)
            datentyp_laenge:=1;
          8: (* signed short *)
            datentyp_laenge:=2;
          9: (* signed long *)
            datentyp_laenge:=4;
          10: (* signed rational *)
            datentyp_laenge:=8;
          11: (* sigle float *)
            datentyp_laenge:=4;
          12: (* double float *)
            datentyp_laenge:=8;
        else (* ungÅltig *)
            datentyp_laenge:=1;
        end;
      end;

    begin
      datei_lesen(form_puffer,tof,12);
      if intel then
        begin
          tagtyp             :=word_z(@form_puffer.d[0])^;
          datentyp           :=word_z(@form_puffer.d[2])^;
          laenge             :=longint_z(@form_puffer.d[4])^;
          zeiger_oder_wert   :=longint_z(@form_puffer.d[8])^;
        end
      else
        begin
          tagtyp             :=m_word(form_puffer.d[0]);
          datentyp           :=m_word(form_puffer.d[2]);
          laenge             :=m_longint(form_puffer.d[4]);
          zeiger_oder_wert   :=m_longint(form_puffer.d[8]);
        end;

      (* Fehler in GWS TIF und EPS: LÑnge=1 statt $13+xxx *)
      if (datentyp=2) and (tagtyp=$131) and (laenge=1) and (zeiger_oder_wert=8) then
        laenge:=255;

      if datentyp_laenge*laenge<=4 then
        wo:=tof+8
      else
        wo:=o0+zeiger_oder_wert;

      FillChar(wert,SizeOf(wert),0);
      wert1_zk:='';
      for i:=1 to Min(laenge,High(wert)) do
        case datentyp of
            1: (* unsigned Byte *)
              begin
                wert[i]:=byte__datei_lesen(wo);
                IncDGT(wo,1);
              end;
            6: (* signed Byte *)
              begin
                wert[i]:=shortint(byte__datei_lesen(wo));
                IncDGT(wo,1);
              end;
            2: (* ASCII string *)
              begin
                (* bleibt erhalten fÅr Verwendung weiter unten *)
              end;
            3: (* unsigned short *)
              begin
                if intel then
                  wert[i]:=x_word__datei_lesen(wo)
                else
                  wert[i]:=m_word__datei_lesen(wo);
                IncDGT(wo,2);
              end;
            8: (* signed short *)
              begin
                if intel then
                  wert[i]:=smallint(x_word__datei_lesen(wo))
                else
                  wert[i]:=smallint(m_word__datei_lesen(wo));
                IncDGT(wo,2);
              end;
            4: (* unsigned long *)
              begin
                if intel then
                  wert[i]:=x_longint__datei_lesen(wo)
                else
                  wert[i]:=m_longint__datei_lesen(wo);
                IncDGT(wo,4);
              end;
            9: (* unsigned long *)
              begin
                if intel then
                  wert[i]:=x_longint__datei_lesen(wo)
                else
                  wert[i]:=m_longint__datei_lesen(wo);
                IncDGT(wo,4);
              end;
            5: (* rational *)
              begin
                (* nicht unterstÅtzt *)
                if intel then
                  wert1_zk:=str0(x_longint__datei_lesen(wo  ))+'/'
                           +str0(x_longint__datei_lesen(wo+4));
                IncDGT(wo,8);
              end;
         (* 10: signed rational *)
         (* 11: signle float *)
         (* 12: double float *)
          else
                IncDGT(wo,datentyp_laenge);
          end;

      exezk:='';
      case tagtyp of
        $00fe:
          begin (* NewSubFile *)
            exezk:='';
            if Odd(wert[1]      ) then exezk_anhaengen(', reduced resolution');
            if Odd(wert[1] shr 1) then exezk_anhaengen(', multipage image part');
            if Odd(wert[1] shr 2) then exezk_anhaengen(', transparency mask');
            if exezk<>'' then
              begin
                Delete(exezk,1,2);
                ausschrift_x(verschachtelt+exezk,musik_bild,absatz);
              end;
            exezk:='';
          end;
     (* $00ff: - SubFile- deprecated *)
        $0100:ausschrift_x(verschachtelt+textz_form__Spalten_doppelpunkt^+str_(wert[1],5),musik_bild,absatz);
        $0101:ausschrift_x(verschachtelt+textz_form__Zeilen_doppelpunkt^+str_(wert[1],5),musik_bild,absatz);
        $0102:
          begin
            exezk:='';
            for i:=1 to Min(laenge,128) do
              case i of
                1:
                  exezk_anhaengen(str_(1 shl wert[1],5));
              else
                  exezk_anhaengen('/');
                  exezk_anhaengen(str0(1 shl wert[1]));
              end;
            ausschrift_x(verschachtelt+textz_form__Farben_doppelpunkt^+exezk,musik_bild,absatz);
            exezk:='';
          end;
        $010d:exezk:=textz_form__Titel_doppelpunkt^;
        $010e:exezk:=textz_form__Beschreibung_doppelpunkt^; (* Exif: ImageDescription *)
        $010f:exezk:='Make:';
        $0110:exezk:='Model:';
     (* $011a: XResolution usigned rational *)
     (* $011b: YResolution usigned rational *)
     (* $0128: Resolution unit /inch/cm *)
        $0132:exezk:='Date/Time:';
        $0131:exezk:=textz_form__Software_doppelpunkt^;
        $013b:exezk:=textz_form__Autor_doppelpunkt^;
     (* $013e: Whitepointt *)
     (* $0211: YCbCrCoefficients *)
     (* $0213: YCbCrPosotioning *)
     (* $0214: ReferenceBlackWhite *)
        $8298:exezk:='Copyright:';
        $8769:(* ExifOffset *)
          exif_subifd(o0+zeiger_oder_wert,laenge);
        $829a:
          begin
            if wert1_zk='' then
              wert1_zk:=str0(wert[1]);
            ausschrift_x(verschachtelt+'ExposureTime: '+wert1_zk+' s',musik_bild,absatz);
          end;
     (* $829d: FNumber *)
     (* $8822: ExposureProgramm *)
     (* $8827: ISOSpeedRattings *)
        $9000:ausschrift_x(verschachtelt+'ExifVersion : '+puffer_zu_zk_l(form_puffer.d[8],4),musik_bild,absatz);
        $9003:exezk:='Date/Time Original:';
        $9004:exezk:='Date/Time Digitized:';
     (* $9101: ComponentsConfiguration *)
     (* $9102: CompressedBitsPerPixel *)
     (* $9201: ShutterSpeedValue *)
     (* $9202: ApertureValue *)
     (* $9203: BrightnessValue *)
     (* $9204: ExposeBiasValue *)
     (* $9205: MaxApertureValue *)
     (* $9206: SubjectDestance *)
     (* $0207: MeteringMode *)
     (* $9208: LightSource *)
     (* $9209: Flash *)
     (* $920a: FocalLength *)
     (* $927c: MakerNote --> IFD *)
        $9286: (* UserComment *)
          begin
            (* JIS/ASCII/UniCode,
            exezk:='UserComment:'; *)
          end;
     (* $9290: SubsecTime *)
     (* $9291: SubsecTimeOriginal *)
     (* $9292: SubsecTimeDigitized *)
     (* $a000: FlashPixVersion *)
     (* $a001: ColorSpace *)
     (* $a002: ExifImageWidth *)
     (* $a003: ExifImageHeigth *)
        $a004:exezk:='RelatedSoundFile:';
     (*   $
     (* .. *)

      (*else
        ausschrift('Tag '+hex_word(tagtyp),signatur); *)
      end;


      if ((exezk<>'') or (datentyp=2)) and (laenge>0) then
        with form_puffer do
          begin

            if exezk='' then
              exezk:='Tag['+str0(tagtyp)+']:';

            datei_lesen(form_puffer,wo,Min(laenge,256));

            if datetime<>'' then
              if bytesuche(d[0],datetime) then
                if d[Length(datetime)]=$00 then
                  d[0]:=0;

            if d[0]<>0 then
              ausschrift_x(verschachtelt+exezk+
                in_doppelten_anfuerungszeichen(puffer_zu_zk_e(d[0],#0,g)),musik_bild,absatz);

            if tagtyp=$0132 then
               datetime:=puffer_zu_zk_e(d[0],#0,g)
          end;

    end;

  procedure exif_subifd(const ifd_o0,l:dateigroessetyp);
    var
      zahl_der_tag_eintraege,
      tzaehl            :word_norm;
      o                 :longint;
    begin
      o:=0;
      repeat
        datei_lesen(form_puffer,ifd_o0+o,512);
        if intel then
          zahl_der_tag_eintraege:=word_z(@form_puffer.d[0])^
        else
          zahl_der_tag_eintraege:=m_word(form_puffer.d[0]);


        if (zahl_der_tag_eintraege<0)
        or (zahl_der_tag_eintraege>$4000) then Break;

        for tzaehl:=1 to zahl_der_tag_eintraege do
          begin
            tag(ifd_o0+o+12*tzaehl-12+2);
          end;

        (* Zeiger zum nÑchsten Tag Dircory laden *)
        datei_lesen(form_puffer,ifd_o0+o+12*zahl_der_tag_eintraege+2,4);

        if intel then
          o:=longint_z(@form_puffer.d[0])^
        else
          o:=m_longint(form_puffer.d[0]);

      until (*o=0*) (o<8) or (o>=einzel_laenge);
    end;

  var
    o                   :longint;
    zahl_der_tag_eintraege:word_norm;
    tzaehl              :word_norm;


  begin
    datetime:='';
    intel:=bytesuche__datei_lesen(o0,'II*'#$00);
    if intel then
      exezk:=''
    else
      exezk:=' [Motorola]'; (* [MAC] *)
    ausschrift(verschachtelt+'Tiff'+exezk+' / Aldus',musik_bild);

    if not langformat then exit;

    datei_lesen(form_puffer,o0+4,4);

    if intel then
      o:=longint_z(@form_puffer.d[0])^
    else
      o:=m_longint(form_puffer.d[0]);

    repeat
      datei_lesen(form_puffer,o0+o,512);
      if intel then
        zahl_der_tag_eintraege:=word_z(@form_puffer.d[0])^
      else
        zahl_der_tag_eintraege:=m_word(form_puffer.d[0]);

      for tzaehl:=1 to zahl_der_tag_eintraege do
        begin
          tag(o0+o+12*tzaehl-12+2);
        end;

      (* Zeiger zum nÑchsten Tag Dircory laden *)
      datei_lesen(form_puffer,o0+o+12*zahl_der_tag_eintraege+2,4);

      if intel then
        o:=longint_z(@form_puffer.d[0])^
      else
        o:=m_longint(form_puffer.d[0]);

      if o<>0 then
        ausschrift_leerzeile;


    until o=0;

  end;

procedure mscf(const o0,l:dateigroessetyp);
  var
    o                   :longint;
    datei_anz,zaehl     :word_norm;
    w1,z                :word_norm;
    xorwert             :byte;
  begin

    datei_lesen(form_puffer,o0,512);
    xorwert:=form_puffer.d[0] xor Ord('M');
    with form_puffer do
      for z:=1 to g do
        d[z-1]:=d[z-1] xor xorwert;
    einzel_laenge:=longint_z(@form_puffer.d[8])^;

    exezk:='';
    if xorwert<>0 then
      exezk:=' [XOR '+hex(xorwert)+']';

    (*ausschrift('MSCF / MS'+exezk,packer_dat);*)
    ausschrift('MicroSoft CabinetFile / MS'+exezk,packer_dat);

    if xorwert=0 then
      begin
        if o0<>0 then
          befehl_schnitt(o0,l,erzeuge_neuen_dateinamen('.CAB'));
      end
    else
      begin
        befehl_schnitt(o0,l,'%tmp%\xor.tmp');
        befehl_sonst('XOR %tmp%\xor.tmp '+erzeuge_neuen_dateinamen('.CAB')+' '+hex(xorwert));
        befehl_sonst('del %tmp%\xor.tmp');
      end;


    if not langformat then exit;

    archiv_start;
    o        :=word_z(@form_puffer.d[$10])^;
    datei_anz:=word_z(@form_puffer.d[$1c])^;

    for zaehl:=1 to datei_anz do
      begin
        datei_lesen(form_puffer,o0+o,200);
        with form_puffer do
          for z:=1 to g do
            d[z-1]:=d[z-1] xor xorwert;

        exezk:=puffer_zu_zk_e(form_puffer.d[$10],#0,255);

        w1:=Length(exezk)+1;

        case word_z(@form_puffer.d[8])^ of
         $0000..$7fff:
           begin
             laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
             laenge_eingepackt:=-1;
           end;
         $fffd:
           begin
             exezk_anhaengen(textz_form__leer_eckauf_Fortsetzung_eckzu^);
             laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
             laenge_eingepackt:=-1;
           end;
         $fffe:
           begin
             exezk_anhaengen(textz_form__leer_eckauf_Bruchstueck_eckzu^);
             laenge_ausgepackt:=longint_z(@form_puffer.d[0])^;
             laenge_eingepackt:=-1;
           end;
        else
          exezk_anhaengen(' [?'+hex_word(word_z(@form_puffer.d[8])^)+']');
          laenge_ausgepackt:=0;
          laenge_eingepackt:=0;
        end;

        archiv_datei;
        archiv_datei_ausschrift(exezk(* +' '+hex_word(word_z(@form_puffer.d[8])^)*));

        Inc(o,w1+$10);

      end;

    archiv_summe_eingepackt:=l;
    archiv_summe_eingepackt_unbekannt:=false;

    archiv_summe;

  end;

(* keine UnterstÅtzung fÅr "GROUP" (zu hÑ·lich) *)
procedure rtpatch(const p:puffertyp;const demo:string);
  var
    p1                  :word_norm;

  procedure laengen_berechnung;
    var
      arbeit            :word_norm;
    begin
      arbeit:=2;

      (* Reihenfolge? *)
      if (form_puffer.d[0] and $02)<>0 then (* irgenwelche Bits *)
        Inc(arbeit,2);


      if (form_puffer.d[0] and $04)<>0 then (* Dateinamen mit Unterverzeichnis *)
        Inc(arbeit,form_puffer.d[arbeit]);

      if (form_puffer.d[0] and $80)<>0 then (* SYSTEMTAG-Index vorhanden *)
        Inc(arbeit,1);

      if (form_puffer.d[1] and $02)<>0 then (* DOBEFORE/DOAFTER *)
        begin
          ausschrift('DOBEFORE    '+puffer_zu_zk_pstr(form_puffer.d[arbeit]),beschreibung);
          arbeit:=arbeit+form_puffer.d[arbeit]+1; (* DOBEFORE *)
          ausschrift('DOAFTER     '+puffer_zu_zk_pstr(form_puffer.d[arbeit]),beschreibung);
          arbeit:=arbeit+form_puffer.d[arbeit]+1; (* DOAFTER  *)
        end;

      if (form_puffer.d[0] and $08)<>0 then (* 386MAX *)
        Inc(arbeit,4); {?}

      case form_puffer.d[1] and $f0 of
        $20: (* ADD *)
          begin
            Inc(arbeit,10);
            while form_puffer.d[arbeit]=0 do
              Inc(arbeit);
            if (form_puffer.d[arbeit]=1) and (form_puffer.d[arbeit+8]=0) then
              Inc(arbeit);
          end;
        $30: (* DELETE *)
          begin
            Inc(arbeit,11);
            while form_puffer.d[arbeit]=0 do
              Inc(arbeit);
            if (form_puffer.d[arbeit]=1) then
              Inc(arbeit);
          end;
        $40: (* MODIFY *)
          begin
            Inc(arbeit,11-1);
            while form_puffer.d[arbeit]=0 do
              Inc(arbeit);
            if  (form_puffer.d[arbeit] in [1..21]) (* gefunden 9,11 *)
            and (form_puffer.d[arbeit+1]=0)
            and (form_puffer.d[arbeit+2]=1) (* keine UnterstÅtzung fÅr "GROUP" *)
            and (form_puffer.d[arbeit+3]=1) (* keine UnterstÅtzung fÅr "GROUP" *)
             then
              Inc(arbeit,4);
          end;
        $60: (* TEMPFILE *)
          begin
            Inc(arbeit,10);
            while form_puffer.d[arbeit]=0 do
              Inc(arbeit);
            if (form_puffer.d[arbeit]=1) and (form_puffer.d[arbeit+8]=0) then
              Inc(arbeit);
          end;

      end;

      p1:=arbeit;
    end;

  var
    o                   :longint;
    v                   :word_norm;

    kommentar_anzahl,
    zaehler             :word_norm;

    lange_dateinamen    :boolean;

    name1,name2         :string;

  begin
    (* p.d[$00]\ Kennung
          [$01]/
          [$02]\ Version
          [$03]/
          [$04] $01 Archivverzeichnis vorhanden
                $02 Kommentar vorhanden
                $08 Kennwort vorhanden
                $60 $00 none
                    $20 backup
                    $40 basic
                    $60 advanced
          [$05] $08 Systemtag vorhanden
                $04 ERRORFILE
                $02 Unterverzeichnise vorhanden
                $01 ? (+4:  T120_US.EXE)

          [$08] $01 2.Dateinamen (EN401RES.RTP)

          [$0a] $08 IGNOREMISSING

          [$0c] longint nîtiger freier Plattenplatz

          Version 5.00 DEMO:
          [$18  $20 DOBEFOREALL
                $40 DOAFTEREALL
                $01 TZCHECK


              *)



    v:=word_z(@p.d[2])^;

    ausschrift('RTPatch / Pocket Soft '+demo+version100(v)
     +textz_form__schweifauf_noch_in_Entwicklung_schweifzu^,packer_dat);

    if not langformat then exit;


    archiv_start;

    (* 211: $1a *)
    o:=$1a;
    if v>=300 then (* SIMTOWER *)
      o:=$1e;

    if v>=320 then
      o:=$22;


    lange_dateinamen:=(v>=300) and ((p.d[8] and $01)<>0);


    (* DOBEFOREALL *)
    if (v>=300{?}) and ((p.d[$18] and $20)<>0) then
      begin
        datei_lesen(form_puffer,analyseoff+o,256);
        ausschrift('DOBEFOREALL '+puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung);
        Inc(o,form_puffer.d[0]+1);
      end;

    (* DOAFTEREALL *)
    if (v>=300{?}) and ((p.d[$18] and $40)<>0) then
      begin
        datei_lesen(form_puffer,analyseoff+o,256);
        ausschrift('DOAFTERALL  '+puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung);
        Inc(o,form_puffer.d[0]+1);
      end;


    (* BACKUPDIR *)
    if (p.d[4] and $01)<>0 then
      begin
        datei_lesen(form_puffer,analyseoff+o,256);
        ausschrift('BACKUPDIR   '+puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung);
        Inc(o,form_puffer.d[0]+1);
      end;

    (* SYSTEMTAG *)
    if (p.d[5] and $08)<>0 then
      begin
        kommentar_anzahl:=x_word__datei_lesen(analyseoff+o);
        Inc(o,2);
        for zaehler:=1 to kommentar_anzahl do
          begin
            datei_lesen(form_puffer,analyseoff+o,256);
            name1:=puffer_zu_zk_pstr(form_puffer.d[0]);
            Inc(o,form_puffer.d[0]+1);
            datei_lesen(form_puffer,analyseoff+o,256);
            name2:=puffer_zu_zk_pstr(form_puffer.d[0]);
            if name1<>name2 then
              begin
                zk_anhaengen(name1,^m^j);
                zk_anhaengen(name1,name2);
              end;
            ausschrift('SYSTEMTAG   '+name1,beschreibung);
            Inc(o,form_puffer.d[0]+3);
          end;
      end;


    (* Verzeichnisliste *)
    if (p.d[5] and $02)<>0 then
      begin
        kommentar_anzahl:=x_word__datei_lesen(analyseoff+o);
        Inc(o,2);
        for zaehler:=1 to kommentar_anzahl do
          begin
            datei_lesen(form_puffer,analyseoff+o,256);
            { [VERZEICHNIS] }
            ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung);
            Inc(o,form_puffer.d[0]+1);
          end;
      end;


    (* Kommentar *)
    if (p.d[4] and $02)<>0 then
      begin
        kommentar_anzahl:=x_word__datei_lesen(analyseoff+o);
        Inc(o,2);
        for zaehler:=1 to kommentar_anzahl do
          begin
            datei_lesen(form_puffer,analyseoff+o,256);
            ausschrift(puffer_zu_zk_pstr(form_puffer.d[0]),beschreibung);
            Inc(o,form_puffer.d[0]+1);
          end;
      end;

    (* Kennwort *)
    if (p.d[4] and $08)<>0 then
      begin
        datei_lesen(form_puffer,analyseoff+o,256);
        name1:=puffer_zu_zk_pstr(form_puffer.d[0]);
        dec(name1[0]);
        for zaehler:=1 to length(name1) do
          dec(name1[zaehler],zaehler+$30);
        ausschrift('PASSWORD "'+name1+'"',beschreibung);
        Inc(o,form_puffer.d[0]+1);
      end;


    repeat
      datei_lesen(form_puffer,analyseoff+o,512);

      (* au·erhalb Dateigrenzen -> Abbruch *)
      if form_puffer.g=0 then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          Break;
        end;

      case (form_puffer.d[1] and $f0) of
        $10: (* Archivende *)
          begin
            p1:=puffer_pos_suche(form_puffer,'DKNJ',20);
            if p1=nicht_gefunden then
              Inc(o,2)
            else
              Inc(o,p1+4);
            Break;
          end;
        $20: (* ADD *)
          begin
            laengen_berechnung;

            laenge_ausgepackt:=longint_z(@form_puffer.d[p1+$00])^;
            laenge_eingepackt:=longint_z(@form_puffer.d[p1+$04])^;
            archiv_datei;

            name1:=puffer_zu_zk_e(form_puffer.d[p1+$08],#0,255);

            Inc(p1,$2a);

            if lange_dateinamen then
              begin
                Inc(p1,8);
                name1:=puffer_zu_zk_pstr(form_puffer.d[p1]);
                Inc(p1,form_puffer.d[p1]+1);
              end;

            archiv_datei_ausschrift('[ADD     ] '+name1);


            Inc(o,p1+laenge_eingepackt);
          end;
        $30: (* DELETE *)
          begin
            laengen_berechnung;

            laenge_ausgepackt:=longint_z(@form_puffer.d[p1+$10])^;
            laenge_eingepackt:=0;
            archiv_datei;

            name1:=puffer_zu_zk_e(form_puffer.d[p1],#0,8+1+3);

            Inc(p1,$22);

            if lange_dateinamen then
              begin
                Inc(p1,8);
                name1:=puffer_zu_zk_pstr(form_puffer.d[p1]);
                Inc(p1,form_puffer.d[p1]+1);
              end;

            archiv_datei_ausschrift('[DELETE  ] '+name1);

            Inc(o,p1);
          end;
        $40:(* $44 bei Simtower *)
          begin
            laengen_berechnung;

            laenge_ausgepackt:=longint_z(@form_puffer.d[p1+$00])^;
            laenge_eingepackt:=longint_z(@form_puffer.d[p1+$04])^;
            archiv_datei;

            name1:=puffer_zu_zk_e(form_puffer.d[p1+$08],#0,255);

            Inc(p1,8+$22);
            if lange_dateinamen then
              begin
                Inc(p1,8);
                name1:=puffer_zu_zk_pstr(form_puffer.d[p1]);
                Inc(p1,form_puffer.d[p1]+1);
              end;

            name2:=puffer_zu_zk_e(form_puffer.d[p1],#0,8+1+3);
            Inc(p1,$10);
            if lange_dateinamen then
              begin
                Inc(p1,$1a);
                name2:=puffer_zu_zk_pstr(form_puffer.d[p1]);
                Inc(p1,form_puffer.d[p1]+1);
              end
            else
              Inc(p1,$12);

            if name1<>name2 then
              begin
                zk_anhaengen(name1,' -> ');
                zk_anhaengen(name1,name2);
              end;

            archiv_datei_ausschrift('[MODIFY  ] '+name1);
            Inc(o,p1+laenge_eingepackt);
          end;
        $50: (* HISTORY *)
          begin
            (*laengen_berechnung;*)
            name1:=puffer_zu_zk_e(form_puffer.d[$05],#0,255);

            if form_puffer.d[$03]<>0 then (* LF106PAT (5.11) *)
              begin
                p1:=5+form_puffer.d[4]+2;
                Inc(p1,longint_z(@form_puffer.d[p1])^+$10);
                laenge_eingepackt:=0;
              end
            else
              begin

                p1:=5+length(name1);
                if form_puffer.d[p1+1+4]<>2 then
                  begin
                    Inc(form_puffer.d[4]);
                    Inc(p1);
                  end;
                Inc(p1,$11);

                laenge_eingepackt:=longint_z(@form_puffer.d[5+form_puffer.d[4]])^;
              end;

            laenge_ausgepackt:=-1;
            archiv_datei;

            archiv_datei_ausschrift('[HISTORY ] '+name1);

            Inc(o,p1+laenge_eingepackt);
          end;
        $60: (* TEMPFILE *)
          begin
            laengen_berechnung;

            laenge_ausgepackt:=longint_z(@form_puffer.d[p1  ])^;
            laenge_eingepackt:=longint_z(@form_puffer.d[p1+4])^;
            archiv_datei;
            Inc(p1,8);

            archiv_datei_ausschrift('[TEMPFILE] '+puffer_zu_zk_pstr(form_puffer.d[p1]));
            Inc(p1,form_puffer.d[p1]+1);
            if form_puffer.d[p1+4]=0 then
              Inc(p1,2)
            else
              Inc(p1,3); (* Tempdatei > 10K ?? *)
            Inc(o,p1+laenge_eingepackt);
          end;

        else
          ausschrift_x(textz_unbekannter_Datenblocktyp^+'('+str0(form_puffer.d[1])+')',dat_fehler,absatz);
          Break;
        end;

    until o>=einzel_laenge;
    archiv_summe;

    if (einzel_laenge>=o) and (o>0) then
      einzel_laenge:=o
    else
      if hersteller_erforderlich=falsch then
        (* Installit Multilingual Archiv *)
        hersteller_gefunden:=falsch;

  end;

procedure sqwez;
  var
    o                   :longint;
  begin
    ausschrift('SQWEZ / JM Sofware',packer_dat);

    if not langformat then
      exit;

    o:=$12;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,60);

      laenge_ausgepackt:=longint_z(@form_puffer.d[$1b])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[$00])^;
      if laenge_ausgepackt+40<laenge_eingepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          break;
        end;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[$0e],#0,255));
      Inc(o,laenge_eingepackt);

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure sqz(const dat_puffer:puffertyp);
  var
    o                   :longint;
    intel               :boolean;
  begin
    case dat_puffer.d[6] and (1+2+4) of
      0:exezk:='[DOS]';
      1:exezk:='[OS/2]';
      2:exezk:='[MVS]';
      3:exezk:='[OS/2 HPFS]';
      4:exezk:='[Amiga]';
      5:exezk:='[Macintosh]';
      6:exezk:='[UNIX]';
      7:exezk:='[???]';
    end;

    intel:=(dat_puffer.d[7] and bit01)=bit01;

    if (dat_puffer.d[7] and bit03)=bit03 then
      exezk_anhaengen(' ['+textz_Sicherheitshuelle^+']');

    if (dat_puffer.d[7] and bit04)=bit04 then
      exezk_anhaengen(textz_form__eckauf_Kennwort_eckzu^);

    ausschrift('SQZ '+chr(dat_puffer.d[5])+'.X / Jonas I. Hammarberg '+exezk,packer_dat);

    if not langformat then
      exit;

    o:=$8;
    archiv_start;

    repeat
      datei_lesen(form_puffer,analyseoff+o,60);
      case form_puffer.d[0] of
        0:break;
       18..255:
         begin
           if intel then
             begin
               (* 4482,3092 *)
               laenge_ausgepackt:=longint_z(@form_puffer.d[$07])^;
               laenge_eingepackt:=longint_z(@form_puffer.d[$03])^;
             end
           else
             begin
               laenge_ausgepackt:=m_longint(form_puffer.d[$07]);
               laenge_eingepackt:=m_longint(form_puffer.d[$03]);
             end;

           if laenge_ausgepackt+40<laenge_eingepackt then
             begin
               ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
               break;
             end;

           archiv_datei;

           archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[20],form_puffer.d[0]-18));
           Inc(o,laenge_eingepackt);
           Inc(o,form_puffer.d[0]);
           Inc(o,2);
         end;
      else
        case form_puffer.d[0] of
          5:
            begin
              laenge_ausgepackt:=0;
              laenge_eingepackt:=0;
              archiv_datei;
              archiv_datei_ausschrift(
                puffer_zu_zk_l(form_puffer.d[11+1],form_puffer.d[1]-9)
               +textz_form__eckauf_Datentraegername_eckzu^);
            end;
          6:
            begin
              laenge_ausgepackt:=0;
              laenge_eingepackt:=0;
              archiv_datei;
              archiv_datei_ausschrift_verzeichnis(puffer_zu_zk_l(form_puffer.d[8+1],form_puffer.d[1]-6));
            end;
        end;
        Inc(o,3);
        if intel then
          Inc(o,word_z(@form_puffer.d[$01])^)
        else
          Inc(o,m_word(form_puffer.d[$01]));
      end;

    until o>=einzel_laenge;
    archiv_summe;


  end;

procedure iptc_naa(const o0,l:dateigroessetyp);
  var
    o                   :dateigroessetyp;
    i                   :word_norm;
    p                   :puffertyp;
    s                   :string;
  begin
    (*ausschrift('IPTC-NAA',normal);*)
    o:=0;
    while o<l do
      begin
        datei_lesen(p,o0+o,$104);
        IncDGT(o,5);
        i:=m_word(p.d[3]);
        s:=puffer_zu_zk_e(p.d[5],#0,Min(i,255));
        umformung_8_8(s,s,konverter_iso_8859_1);
        if Length(s)>0 then
          if not (p.d[2] in [$00,
                             $0a, (* "4" - Bildnummer? *)
                             $0f, (* "PL" "VM" *)
                             $41, (* "DC" *)
                             $5a, (* Zeichensatz *)
                             $82] (* "3P" "9P" *)
                                 ) then
            if ist_ohne_steuerzeichen(s) then
              ausschrift((*hex_word(o)+':'+hex_word(i)+' '+hex(p.d[2])+' '+*)s,farblos);
        IncDGT(o,i);
      end;
  end;

procedure photoshop_kette(const o0,l:dateigroessetyp);
  var
    o                   :dateigroessetyp;
    i                   :word_norm;
    p                   :puffertyp;
    t                   :word_norm;
  begin
    o:=0;
    while o<l do
      begin
        datei_lesen(p,o0+o,512);
        if not bytesuche(p.d[0],'8BIM') then Exit;
        i:=4;
        t:=m_word(p.d[i]);
        Inc(i,2);
        (*if p.d[i]<>0 then ausschrift(puffer_zu_zk_pstr(p.d[i]),normal);*)
        Inc(i,1+p.d[i]); (* Name *)
        if Odd(i) then Inc(i);
        IncDGT(o,i);
        datei_lesen(p,o0+o,512);
        i:=m_longint(p.d[0]);
        IncDGT(o,4);

        if signaturen then
          ausschrift('  8BIM: '+hex_DGT(o0+o)+' : '+str0(t)+' : '+str0(i),normal);

        case t of
          1028:
            iptc_naa(o0+o,i);
          1036: (* kleines Bild eingebettet *)
            befehl_schnitt(o0+o+$1c,i,ohne_pfad(dateiname)+'.jpeg');
        end;
        if Odd(i) then Inc(i);
        IncDGT(o,i);
      end;
  end;

procedure jfif(const p:puffertyp);
  var
    o                   :longint;
    l                   :word_norm;
  begin
    if not (p.d[3] in [$01,$c0..$fe]) then Exit; (* Segmenttyp (Oliver Fromme) *)
    o:=2;
    exezk:='(?)';
    if p.d[3] in [$e0..$ef,$fe] then (* APP0..APP15,Kommentar *)
      begin
        l:=m_word(p.d[2+2]);
        exezk:=puffer_zu_zk_e(p.d[6],#0,Min(l-2,40));
        if exezk='JFIF' then
          exezk_anhaengen(version_x_y(p.d[$b],p.d[$c]))
        else
          exezk:=in_doppelten_anfuerungszeichen(exezk);
        Inc(o,2+l);
      end;

    ausschrift('JPEG '+exezk,musik_bild);

    if not langformat then
      Exit;

    if bytesuche(p.d[2],#$ff#$e1'??Exif'#$00#$00) then
      tiff(analyseoff+2+10,l-10,'  ');

    repeat
      datei_lesen(form_puffer,analyseoff+o,50);

      if form_puffer.d[0]<>$ff then
        Break;

      if form_puffer.d[1] in [$01,$d0..$d7] then (* FFE200.ZIP: JFIF *)
        l:=0
      else
        l:=m_word(form_puffer.d[2]);

      if signaturen then
        ausschrift(hex_longint(o)+': '+hex(form_puffer.d[1])+' '+hex_word(l),normal);

      case form_puffer.d[1] of

        $c0.. (* START OF FRAME $c0..$c7 *)
        $c2:
          ausschrift(str0(m_word(form_puffer.d[7]))
            +' * '+str0(m_word(form_puffer.d[5]))
            +textz_form__leerleer_farben_doppelpunkt^
            (* Bit*Grau/YCbCr,YIQ/CMYK *)
            +'2^'+str0(longint(form_puffer.d[4]*form_puffer.d[9])),musik_bild);
           (* jpeg kann nur farbe oder grau nicht "256"! *)

    (*  $c4:;  Palette *)
    (*  $db:;  Quantiziation Table *)
    (*  $da:;  Daten *)
        $d9:
          Break; (* Ende *)
    (*  $e0:;  JFIF KOPF (APP0) *)
        $e1..$ef, (* APP1..APP15 *)
        $fe: (* Kommentar *)
        (* Adobe ED:TEST.JPG *)
          begin
            ansi_anzeige(analyseoff+o+4,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,wahr
              ,o+4+m_word(form_puffer.d[2])-2,'');
            if bytesuche__datei_lesen(analyseoff+o+4,'Photoshop') then
              if bytesuche__datei_lesen(analyseoff+o+18,'8BIM') then
                photoshop_kette(analyseoff+o+18,l-18);

            if bytesuche__datei_lesen(analyseoff+o+4,'Exif'#$00#$00) then
              tiff(analyseoff+o+10,l-10,'  ');
          end;
          {
            exezk:=datei_lesen__zu_zk_e(analyseoff+o+4,#0,l-4);
            ausschrift(exezk,beschreibung);
            (*//E:\$typ\jpeg\EF.jpeg*)
          }

      (* else? *)
      end;
      Inc(o,2+l);
    until o>=einzel_laenge;
  end;

procedure exx(const exxp:puffertyp);
  const
    soll                :string[12]='PEARL AGENCY';
  var
    pwx,pwy             :string[12];
    pwz                 :string;
    summe               :byte;
    b1                  :byte;
    z2,z3               :word_norm;
    bestaetigt          :boolean;
    tmpzk               :string[255];
    xor_variante        :boolean;
    o                   :dateigroessetyp;
  begin
    tmpzk:='';

    pwx:=puffer_zu_zk_l(exxp.d[$193],12);
    for z2:=1 to High(soll) do
      pwx[z2]:=Chr(Ord(pwx[z2]) xor Ord(soll[z2]));

    for b1:=0 to 255 do
      begin
        xor_variante:=wahr;

        pwy:=pwx;
        for z2:=1 to 12 do
          pwy[z2]:=Chr((Ord(pwy[z2]) xor b1)-z2);

        for z2:=1 to 12 do (* zu prÅfende LÑnge *)
          begin

            bestaetigt:=xor_variante; (* fÅr jeden XOR-Wert das kÅrzeste Wort *)

            for z3:=1 to 12 do
              if (z2+z3)<=12 then
                if pwy[z3]<>pwy[z3+z2] then
                  begin
                    bestaetigt:=falsch;
                    Break;
                  end;

            if bestaetigt then
              for z3:=1 to 12 do
                if not (pwy[z3] in ['A'..'Z','0'..'9']) then
                  begin
                    bestaetigt:=falsch;
                    Break; (* b3 *)
                  end;

            if bestaetigt and xor_variante then
              begin

                pwz:=Copy(pwy,1,z2);
                while Length(pwz)<128 do
                  pwz:=pwz+pwz;

                summe:=0;
                for z3:=1 to 128 do
                  Inc(summe,Ord(pwz[z3]));

                if summe+$40<>b1 then
                  bestaetigt:=falsch;

                if bestaetigt then
                  begin
                    if tmpzk<>'' then
                      tmpzk:=tmpzk+', ';

                    pwz:=Copy(pwy,1,z2);

                    tmpzk:=tmpzk+(*hex(b1)+hex(summe)+*)'"'+pwz+'"';

                    befehl_exx(pwz);

                    xor_variante:=falsch;
                    Break; (* b2 *)
                  end;
              end;
          end;
      end;

    if tmpzk='' then
      tmpzk:=textz_form_klammer_nicht_gefunden_klammer^;

    ausschrift('EXX '+textz_form__verschluesselt^+' / P.Grabau '+tmpzk,packer_dat);
    if not langformat then
      exit;

    archiv_start;

    (* $000..$07f ist scheinbar MÅll *)

    (* $080..$0ff EXE-Name *)
    ausschrift(datei_lesen__zu_zk_pstr(analyseoff+$80),beschreibung);

    (* $100 ? *)
    (* $101 ? *)
    (* $102 ? *)
    (* $103..$13e Pfad *)
    ausschrift(datei_lesen__zu_zk_pstr(analyseoff+$103),beschreibung);
    (* $13f..$18e Hinweis[$50-1]*)
    ausschrift(datei_lesen__zu_zk_pstr(analyseoff+$13f),beschreibung);
    (* $18f:longint Plattenplatzbedarf *)
    (* $193:array[1..12] of char Kennwort *)
    (* $19f: ? *)
    (* $1ac:smallword Anzahl Dateien *)

    o:=$1ae;
    z2:=word_z(@exxp.d[$1ac])^;

    while (z2>0) and (o<einzel_laenge) do
      begin
        Dec(z2);
        datei_lesen(form_puffer,analyseoff+o,150);
        laenge_ausgepackt:=longint_z(@form_puffer.d[$0d])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[$0d+4])^; (* gleiche Werte *)

        if (laenge_ausgepackt+40<laenge_eingepackt)
        or (form_puffer.d[0]=0) then (* CD-Fehler *)
          begin
            ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
            Break;
          end;

        archiv_datei;
        (* 8+1+3 Name bei 0, mit Pfad bei $15 *)
        archiv_datei_ausschrift(puffer_zu_zk_pstr(form_puffer.d[$15]));

        IncDGT(o,$52+laenge_eingepackt);

      end; (* Dateischleife *)

    archiv_summe;

  end;

procedure genus_micro;
  var
    anzahl_elemente     :word_norm;
    zaehler             :word_norm;
    datei_pos           :dateigroessetyp;
  begin
    ausschrift('Genus Microprogramming '+textz_form__archiv^,packer_dat);

    if not langformat then
      Exit;

    datei_lesen(form_puffer,analyseoff+$5e,2);
    anzahl_elemente:=word_z(@form_puffer.d[0])^;
    einzel_laenge:=$80+anzahl_elemente*$1a;

    archiv_start;
    for zaehler:=1 to anzahl_elemente do
      begin
        datei_lesen(form_puffer,analyseoff+(zaehler-1)*$1a+$80,$1a);
        exezk:=puffer_zu_zk_e(form_puffer.d[1],' ',8 )
              +puffer_zu_zk_e(form_puffer.d[9],' ',1+3);
        laenge_eingepackt:=longint_z(@form_puffer.d[$12])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        datei_pos:=analyseoff+longint_z(@form_puffer.d[$e])^;
        befehl_schnitt(datei_pos,laenge_eingepackt,exezk);
        merke_position(datei_pos,datentyp_unbekannt);
      end;
    archiv_summe;
  end;

procedure finish_packer;
  var
    o                   :longint;
    verzeichnis         :string;
  begin
    ausschrift('The Finishing Touch / ImagiSOFT  [PKWARE-'+textz_form__Bibliothek^+']',packer_dat);
    if not langformat then Exit;

    o:=9;
    verzeichnis:='';
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,150);

      case form_puffer.d[0] of
        $00: (* Ende *)
          break;
        $14: (* Fortsetung auf 2.Diskette *)
          Break;
        $0a: (* Datei *)
          begin
            laenge_ausgepackt:=longint_z(@form_puffer.d[form_puffer.d[1]+ 2])^;
            laenge_eingepackt:=longint_z(@form_puffer.d[form_puffer.d[1]+16])^;

            if laenge_ausgepackt+40<laenge_eingepackt then
              begin
                ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
                break;
              end;

            exezk:=verzeichnis+puffer_zu_zk_pstr(form_puffer.d[1]);

            archiv_datei;
            archiv_datei_ausschrift(exezk);

            Inc(o,form_puffer.d[1]+20);
            if laenge_ausgepackt=laenge_eingepackt then
              befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk)
            else
              befehl_ttdecomp(analyseoff+o,laenge_eingepackt,exezk);

            Inc(o,1+laenge_eingepackt);
          end;
        $64: (* Unterverzeichnis *)
          begin
            verzeichnis:=puffer_zu_zk_pstr(form_puffer.d[1]);
            Inc(o,1+1+form_puffer.d[1]);
          end;
      else
        ausschrift(textz_unbekannter_Datenblock^,signatur);
        Exit;
      end;

    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure qez;
  var
    o                   :longint;
    verzeichnis         :string;
    anz                 :word_norm;
  begin
    if analyseoff<>0 then Exit; (* OS/2 DOSCALL1.DLL *)

    datei_lesen(form_puffer,analyseoff,512);
    exezk:=puffer_zu_zk_l(form_puffer.d[2],word_z(@form_puffer.d[0])^);
    if (length(exezk)<=3) or (not ist_ohne_steuerzeichen(exezk)) then Exit; (* SPEED.RES Speed-Pascal *)

    ausschrift('QEZ-Archiv / Robert Simpson',packer_dat);
    if not langformat then
      Exit;

    archiv_start;

    ausschrift(puffer_zu_zk_l(form_puffer.d[2],word_z(@form_puffer.d[0])^),beschreibung);

    o:=word_z(@form_puffer.d[0])^+2;
    datei_lesen(form_puffer,analyseoff+o,512);
    anz:=word_z(@form_puffer.d[3])^;

    verzeichnis:=puffer_zu_zk_e(form_puffer.d[8],#0,255);
    Inc(o,Length(verzeichnis)+9);

    while anz>0 do
      begin
        Dec(anz);

        datei_lesen(form_puffer,analyseoff+o,512);
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,12);
        laenge_ausgepackt:=longint_z(@form_puffer.d[12+1+4])^;
        laenge_eingepackt:=longint_z(@form_puffer.d[12+1+0])^;

        if laenge_ausgepackt+40<laenge_eingepackt then
          begin
            ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
            Break;
          end;

        archiv_datei;

        archiv_datei_ausschrift(verzeichnis+exezk);
        Inc(o,12+1+14);
      end;

    archiv_summe;
  end;

procedure charc;
  var
    o                   :longint;
  begin
    ausschrift('CHArc / S.Chernivetsky',packer_dat);
    if not langformat then Exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,190);
      laenge_ausgepackt:=longint_z(@form_puffer.d[8])^;
      laenge_eingepackt:=longint_z(@form_puffer.d[4])^;

      if laenge_ausgepackt+40<laenge_eingepackt then
        begin
          ausschrift_x(textz_archiv_fehler^,dat_fehler,absatz);
          Break;
        end;

      archiv_datei;

      archiv_datei_ausschrift(puffer_zu_zk_l(form_puffer.d[$18],form_puffer.d[$16]));
      if bytesuche(form_puffer.d[$16],#$01#$00'!') then
        ausschrift_x(puffer_zu_zk_l(form_puffer.d[$19],laenge_ausgepackt),beschreibung,absatz);

      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure gnuzip;
  var
    l:dateigroessetyp;
  begin
    datei_lesen(form_puffer,analyseoff+einzel_laenge-4,4);
    if bytesuche(form_puffer.d[2],'cz') then
      begin
        modules_cs;
        Exit;
      end;

    if einzel_laenge>1024*1024 then
      begin
        l:=einzel_laenge-longint_z(@form_puffer.d[0])^;
        if (l>2+4) and (l<4000)
        and (ModDGT(l-2-4,$17)=0) then
          Super_Retriss_Pro_Install_Utility(einzel_laenge-l,l)
        (* weiter mit der ersten gepackten Datei *)
      end;


    laenge_ausgepackt64:=longint_z(@form_puffer.d[0])^;
    laenge_eingepackt64:=einzel_laenge;


    archiv_start_leise;
    archiv_datei64;
    exezk:=laenge_ausgepackt_zk+verhaeltnis_zk+'%';
    archiv_summe_leise;

    if p.d[3]=8 then
      exezk_anhaengen(' "'+puffer_zu_zk_e(p.d[$A],#0,255)+'"');

    ausschrift('GNU-Zip / Jean-loup Gailly  '+exezk,packer_dat);

    if (analyseoff>0) (* Beispiel: rpm *)
    or (einzel_laenge<>dateilaenge) (* Super Retriss Pro Install Utility *)
     then
      begin
        if p.d[3]=8 then
          exezk:=puffer_zu_zk_e(p.d[$A],#0,255)
        else
          exezk:=erzeuge_neuen_dateinamen('.');
        befehl_gnuunzip(analyseoff,einzel_laenge,exezk);
      end;

  end;

procedure yac;
  var
    w1,anz              :word_norm;
    o                   :longint;
  begin
    ausschrift('YAC / Alexander Shurna',packer_dat);
    if not langformat then Exit;

    datei_lesen(form_puffer,analyseoff+$14,2);
    anz:=word_z(@form_puffer.d[0])^;

    archiv_start;
    o:=$37;

    for w1:=1 to anz do
      begin
        datei_lesen(form_puffer,analyseoff+o,100);
        laenge_ausgepackt:=longint_z(@form_puffer.d[8])^;
        laenge_eingepackt:=-1;

        archiv_datei;

        ausschrift_x(laenge_ausgepackt_zk+'   ?  '
        +puffer_zu_zk_l(form_puffer.d[$12],form_puffer.d[0]),packer_dat,absatz);

        Inc(o,form_puffer.d[0]);
        Inc(o,$13);
      end;

    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;

    archiv_summe;
  end;

procedure wavpack(const erweiterung:string);
  begin
    ausschrift('WAVPACK / Conifer Software [3.0] "'+erweiterung+'"',packer_dat);
    (* laenge_augepackt nicht gefunden *)
  end;

procedure swf5(anzahl_dateien:longint;sichtbar:boolean;const dir_laenge:longint);
  var
    o                   :dateigroessetyp;
    wo                  :dateigroessetyp;
    dateityp            :word_norm;
    blocklaenge         :longint;
    variante_pstr_zip   :boolean;
  begin
    (* Macromedia Flash 5 Installation fÅr OS/2 *)
    if sichtbar then
      (*ausschrift('SWF5 / Innotek GmbH',packer_dat);*)
      ausschrift('Installer / Innotek GmbH',packer_dat);
    if not langformat then Exit;

    if anzahl_dateien<=0 then Exit;

    blocklaenge:=dir_laenge div anzahl_dateien;
    if (blocklaenge<$100) or (blocklaenge>$200) then Exit;

    if sichtbar then
      archiv_start;
    o:=analyseoff+einzel_laenge-$10-anzahl_dateien*blocklaenge;


    variante_pstr_zip:=false;
    if anzahl_dateien>0 then
      begin
        datei_lesen(form_puffer,o,blocklaenge);
        exezk:=puffer_zu_zk_e(form_puffer.d[12+blocklaenge-$110],#0,255);
        variante_pstr_zip:=Ord(exezk[1])+1=Length(exezk);
      end;

    if not sichtbar then
      begin
        if variante_pstr_zip then
          merke_position(o,datentyp_innotek_pstr_zip)
        else
          merke_position(o,datentyp_innotek);
      end;

    while anzahl_dateien>0 do
      begin
        Dec(anzahl_dateien);
        datei_lesen(form_puffer,o,blocklaenge);
        laenge_eingepackt:=longint_z(@form_puffer.d[8])^;
        laenge_ausgepackt:=laenge_eingepackt;
        if variante_pstr_zip then
          begin
            exezk:=puffer_zu_zk_pstr(form_puffer.d[12+blocklaenge-$110]);
            wo:=longint_z(@form_puffer.d[$c])^;
          end
        else
          begin
            exezk:=puffer_zu_zk_e(form_puffer.d[12+blocklaenge-$110],#0,255);
            wo:=longint_z(@form_puffer.d[4])^;
          end;

        if sichtbar then
          begin
            archiv_datei;
            if variante_pstr_zip then
              begin
                (*  1:next ('unzip.exe', 'WND_UNINSTALL_EXIT')
                    2:Datei
                    6:InnoTek Runtime Initialization
                    7:WND_ (resource)
                    8:WelcomeWndProc (0 Byte - interne Funktion)
                   10:installer-Datei (Inhalt: "WND_WELCOME")
                   *)
                case longint_z(@form_puffer.d[0])^ of
                  2:
                  archiv_datei_ausschrift(exezk);
                else
                  archiv_datei_ausschrift(exezk+' ('+str0(longint_z(@form_puffer.d[0])^)+')');
                end;
              end
            else
              begin
                if longint_z(@form_puffer.d[0])^=2 then
                  archiv_datei_ausschrift_verzeichnis(exezk)
                else
                  archiv_datei_ausschrift(exezk);
              end;

            if (laenge_eingepackt>0) then
              if ((longint_z(@form_puffer.d[0])^<>2) and (not variante_pstr_zip))
              or  (variante_pstr_zip) then
                begin
                  if bytesuche__datei_lesen(wo,#$a5#$96) then
                    befehl_unpack2(wo,laenge_eingepackt,exezk)
                  else
                  if bytesuche__datei_lesen(wo,'PK') then
                    befehl_unzip2(wo,laenge_eingepackt,exezk)
                  else
                    befehl_schnitt(wo,laenge_eingepackt,exezk);
                end;
          end

        else (* nicht sichtbar *)

          if laenge_eingepackt>0 then
            begin
              if variante_pstr_zip then
                case longint_z(@form_puffer.d[0])^ of
                  1,10:
                    if laenge_eingepackt<200 then
                      merke_position(wo,datentyp_wp_cfg)
                    else
                      merke_position(wo,datentyp_unbekannt); (* BMP,README..*)
                else
                    merke_position(wo,datentyp_unbekannt); (* Datei/gepackt *)
                end
              else
                case longint_z(@form_puffer.d[0])^ of
                  1:
                    merke_position(wo,datentyp_wp_cfg); (* WPS *)
                  2:
                    merke_position(wo,datentyp_wp_directory); (* verzeichnis *)
                else (* 0 *)
                    merke_position(wo,datentyp_unbekannt); (* Datei/gepackt *)
                end;
            end;

        IncDGT(o,blocklaenge);
      end;

    if sichtbar then
      archiv_summe;
    bestimme_naechste_einzellaenge(analyseoff,einzel_laenge,dateityp);
  end;

end.

