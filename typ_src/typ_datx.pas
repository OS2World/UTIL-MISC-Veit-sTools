(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_datx;

interface

uses
  typ_type;

procedure dat_sigx(var datx_puffer:puffertyp);

implementation

uses
  typ_eiau,
  typ_dien,
  typ_die2,
  typ_die3,
  typ_ausg,
  typ_var,
  typ_varx,
  typ_spra,
  typ_ende,
  typ_for1,
  typ_for2,
  typ_for3,
  typ_for4,
  typ_for5,
  typ_posm,
  typ_xexe,
  typ_cd,
  typ_entp;


procedure dat_sigx_teil2(var datx_puffer,gross_datx_puffer:puffertyp);forward;

procedure dat_sigx(var datx_puffer:puffertyp);
  var
    l1,l2               :longint;
    f1,f2               :dateigroessetyp;
    gross_datx_puffer   :puffertyp;
    datx_tmp_puffer     :puffertyp;
    titel_position      :longint;
    dp1                 :dateigroessetyp;
  label
    datx_fertig;

  function puffer_pos_suche_datx_puffer(const suchzk:string;const max:word_norm):word_norm;
    begin
      puffer_pos_suche_datx_puffer:=puffer_pos_suche(datx_puffer,suchzk,max);
    end;

  function puffer_pos_suche_gross_datx_puffer(const suchzk:string;const max:word_norm):word_norm;
    begin
      puffer_pos_suche_gross_datx_puffer:=puffer_pos_suche(gross_datx_puffer,suchzk,max);
    end;

  var
    w1,w2                                 :word_norm;

  begin (* dat_sigx *)

    (* Mu· vor HTML,... kommen, weil z.B. HTML eingepackt sein kann. *)
    if  (datx_puffer.d[0]=0)
    and (datx_puffer.d[1] in [1..$3e])
    (*unzulÑssig: z.B. Compactor hat MÅll dort  and (datx_puffer.d[datx_puffer.d[1]+2]=0)*)
     then
      begin

        {
        if bytesuche(datx_puffer.d[$41],'FSSD'    ) (* Macintosh Sound Tools Format *)
        or bytesuche(datx_puffer.d[$41],'SMCB'    ) (* MACB10 *)
        or bytesuche(datx_puffer.d[$41],'APPL'    ) (* T-ONL_MA.BIN *)
        or bytesuche(datx_puffer.d[$41],'PIT '    ) (* unpackit.doc , MACBEST2.ZIP\galaxy.pic *)
        or bytesuche(datx_puffer.d[$41],'ZIP '    ) (* MYFOLDER.ZIP *)
        or bytesuche(datx_puffer.d[$41],'VWMD'    ) (* SCROLT.MMD *)
        or bytesuche(datx_puffer.d[$45],    'SIT!') (* MACLYNX.BIN (STUFFIT) *)
        or bytesuche(datx_puffer.d[$41],'TEXTMBin') (* VALEN121:BIN: Macbinary von Macbinary *)}

        if  (ist_ohne_steuerzeichen_nicht_so_streng(puffer_zu_zk_pstr(datx_puffer.d[1])))
        and (ist_ohne_steuerzeichen_nicht_so_streng(puffer_zu_zk_l(datx_puffer.d[$41],8)))
         then
          MacBinary(datx_puffer)
        else
        (* installMultiShow.jar: \Volumes\Docs\Developer\Java\MultiShow\current\release\lib\acrobat.jar *)
        if bytesuche(datx_puffer.d[$66],'mBIN') then
          MacBinary(datx_puffer);
      end;

    if hersteller_gefunden then goto datx_fertig;

    if bytesuche(datx_puffer.d[$20],#$00#$01#$00#$01) then
      palmpilot(datx_puffer);

    (* DAWICONTROL: DC2975.SYS: "$$CAM00" und "SCSIMGR$" *)
    if (einzel_laenge<50000)
    and bytesuche(datx_puffer.d[1],#$00#$ff#$ff)
    and (datx_puffer.d[0]>4+2+2+2+8) then
      begin
        w1:=datx_puffer.d[0];
        if bytesuche(datx_puffer.d[w1],#$ff#$ff#$ff#$ff) then
          begin
            geraete_treiber(datx_puffer,textz_dat__Geraetetreiber^);
            goto datx_fertig;
          end;
      end;

    puffer_gross(datx_puffer,gross_datx_puffer);
    l1:=longint(m_word(datx_puffer.d[0]))*4;
    if (einzel_laenge=l1) and (l1>300) and bytesuche(datx_puffer.d[2],#$00'?'#$00'???'#$00) then
      begin
        exezk:=puffer_zu_zk_pstr(datx_puffer.d[$20]);
        if (filter(exezk)=exezk) and (length(exezk)>0) then
          ausschrift('TFM "'+exezk+'"',signatur);
      end;

    l1:=4+16*(word_z(@datx_puffer.d[0]))^;
    if  ((einzel_laenge=l1) or (einzel_laenge=l1+1))
    and (einzel_laenge>50)
    and (datx_puffer.d[$0f] in [1..8]) (* E.SYM .. *)
     then
      ausschrift(textz_datx__Symboltabelle^+' OS/2 [WARP 4] "'+puffer_zu_zk_pstr(datx_puffer.d[$0f])+'"',compiler);

    if puffer_anzahl_suche(datx_puffer,#0#0,datx_puffer.g)<5 then
      (* nicht debuginfo bei UMSSFDIK.SYS *)
      begin
        (* nicht Ansied 2.0 *)
        if not bytesuche(datx_puffer.d[0],#$b4#$0f#$cd#$10#$32#$e4#$50#$b8#$14#$11#$cd#$10#$b4#$01) then
          if (einzel_laenge=80*25*2) (* Thyrian *)
          or (einzel_laenge=80*25*2+2) (* IOMEGA Backup *)
           then
            thegrab(analyseoff,25,80*2,textz_datx__Kopie_Textmodus_Bildschirmspeicher^);

        if (einzel_laenge=80*50*2) (* TheDraw *)
         then
          thegrab(analyseoff,50,80*2,textz_datx__Kopie_Textmodus_Bildschirmspeicher^);
      end;

    if bytesuche(datx_puffer.d[4],'moov') then
      (* simon 3D *)
      (*ausschrift('Quicktime movie / Apple',musik_bild);*)
      mov;

    if hersteller_gefunden then
      goto datx_fertig;

    (* sehr unsicher: z.B. Konflikt mit .SYM *)
    if (datx_puffer.d[0]=$0a) and (datx_puffer.d[1]<=5) and
       (* nicht 1: Adobe\Acrobat 4.0\Resource\Font\PFM\Zy______.mmm *)
       (datx_puffer.d[1] in [0,2,3,5]) and
       ((datx_puffer.d[2]=1) or (datx_puffer.d[2]=2)
        or (datx_puffer.d[2]=4) or (datx_puffer.d[2]=8)) then
       begin
         case datx_puffer.d[1] of
           0:exezk:='2.5';
           2:exezk:='2.8';
           3:exezk:='2.8 '+textz_datx__ohne_Palette^;
           5:exezk:='3.0';
         else
           exezk:='?.?';
         end;
         bild_format_filter('PCX / ZSoft ['+exezk+']',
          word_z(@datx_puffer.d[ 8])^-word_z(@datx_puffer.d[ 4])^+1,
          word_z(@datx_puffer.d[10])^-word_z(@datx_puffer.d[ 6])^+1,
          -1,datx_puffer.d[$3]*datx_puffer.d[$41],true,false,anstrich);
       end;

    if hersteller_gefunden then
      goto datx_fertig;

    if  bytesuche(datx_puffer.d[$0a],#$28#$00#$00#$00)
    and bytesuche(datx_puffer.d[$16],#$01#$00'?'#$00) then
      if  (longint_z(@datx_puffer.d[$e])^>    0)
      and (longint_z(@datx_puffer.d[$e])^<16000)
      and (longint_z(@datx_puffer.d[$12])^>    0)
      and (longint_z(@datx_puffer.d[$12])^<16000)
      and (datx_puffer.d[$16] in [1,2,4,8,24]) then
        windows_ico1(analyseoff+$a,einzel_laenge-$a,false,0);

    if not hersteller_gefunden then
      with datx_puffer do
        if                 (* id text *)
            (d[1] in [0,1]) (* color map type *)
        and (d[2] in [0,1,2,3,9,10,11]) (* image type/rle *)
     (* and (word_z(@d[3])^ color map first entry *)
     (* and (word_z(@d[5])^ color map length *)
        and (d[7] in [0,15,16,24,32]) (* color map entry size *)
        and (word_z(@d[8])^<10000) (* x-origin *)
        and (word_z(@d[$a])^<10000) (* y-origin *)
        and (word_z(@d[$c])^>=1) and (word_z(@d[$c])^<10000) (* image with *)
        and (word_z(@d[$e])^>=1) and (word_z(@d[$e])^<10000) (* image height *)
        and (d[$10] in [1..16,24,32]) (* pixel depth *)
    (* and  (d[$11] image descriptor *)
        then
         begin
           if d[1]=0 then (* ohne Palette *)
             bild_format_filter('Truevision Targa',
                               word_z(@d[$c])^,
                               word_z(@d[$e])^,
                               -1           ,d[$10],true,false,anstrich)
           else
             bild_format_filter('Truevision Targa',
                               word_z(@d[$c])^,
                               word_z(@d[$e])^,
                               word_z(@d[5])^,-1   ,true,false,anstrich);

           if d[0]>0 then
             ausschrift_x(puffer_zu_zk_l(d[$12],d[0]),beschreibung,absatz);
         end;

    (* Mu· vor HTML kommen, weil eine HTML-Datei eingepackt werden kann ... *)
    if bytesuche(datx_puffer.d[1],#$00#$00#$00) then
      (* Netscape Comunicator Installation *)
      install_shield_stub_archiv(datx_puffer);

    (* mu· vor MSCF kommen *)
    if  puffer_gefunden(datx_puffer,'.cab'#$00'Disk1\')
    and puffer_gefunden(datx_puffer,'.cab'#$00'0.0.0.0'#$00) then
      installshield_19200(true);

    if analyseoff=$A25 then
      versuche_Basic_Linker(datx_puffer);

    (* JAR *)
    if bytesuche(datx_puffer.d[14],#$1a'Jar'#$1b#$00) then
      begin
        jar(datx_puffer);
        goto datx_fertig;
      end;

    w1:=puffer_pos_suche_datx_puffer(#$1a'Jar'#$1b#$00,50);
    if w1<>nicht_gefunden then
      einzel_laenge:=w1-14;

    if hersteller_gefunden then goto datx_fertig;

    if bytesuche(datx_puffer.d[$20],'@comp.id'#$00) then
      debug_comp_id(datx_puffer);

    (* Textvorspann ****************************************************)

    (* ROSE: RHBVS233.RAR *)
    w1:=puffer_pos_suche_gross_datx_puffer('<!-- X-URL: ',$100);
    if w1<>nicht_gefunden then
      begin
        exezk:=puffer_zu_zk_zeilenende(gross_datx_puffer.d[w1+12],160);
        inc(w1,12+length(exezk));
        if length(exezk)>10 then
          if copy(exezk,length(exezk)-4+1,4)=' -->' then
            dec(exezk[0],4);
        ausschrift('"'+exezk+'"',beschreibung);

        repeat
          if not(w1<high(gross_datx_puffer.d)) then break;

          if (gross_datx_puffer.d[w1] in [$0a,$0d,ord(' '),$09]) then
            begin
              inc(w1);
              continue;
            end;

          if  (not bytesuche(gross_datx_puffer.d[w1],'<BASE'))
          and (not bytesuche(gross_datx_puffer.d[w1],'<!-- DATE'))
           then
            Break;

          exezk:=puffer_zu_zk_zeilenende(gross_datx_puffer.d[w1],128);
          inc(w1,length(exezk));

        until false;
        einzel_laenge:=w1;
        goto datx_fertig;
      end;

    w1:=puffer_pos_suche_gross_datx_puffer('CUT HERE',400); (* Vermutung *)

    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_gross_datx_puffer('CLIP HERE',400); (* NETPIC .NPX *)

    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_gross_datx_puffer('REMOVE THIS LINE AND',400); (* NETSEND *)

    if w1<>nicht_gefunden then
      begin
        while (w1<511) and (datx_puffer.d[w1]<>$0a) do
          inc(w1);
        while (w1<511) and (datx_puffer.d[w1] in [$0a,$0d]) do
          inc(w1);
        if w1<511 then
          begin
            ausschrift(textz_datx__Textvorspann_punktpunktpunkt^,signatur);
            einzel_laenge:=w1;
            goto datx_fertig;
          end;
      end;

    if  (puffer_pos_suche_datx_puffer('From'     ,400)<>nicht_gefunden)
    and (puffer_pos_suche_datx_puffer('Received:',400)<>nicht_gefunden)
     then
      sendmail('',false,'');
    (* Spezialtexte ****************************************************)

    if datx_puffer.d[0] in [$20,$09] then
      if puffer_gefunden(datx_puffer,'Upload Information Template for Hobbes.nmsu.edu') then
        hobbes_upload_text;

    if bytesuche(datx_puffer.d[0],'==============') then
      versuche_lizenz_readme(datx_puffer);

    if puffer_gefunden(datx_puffer,'    =-=-=-=-=') then
      versuche_adaptec_readme(datx_puffer);


    (* Quelltexte ******************************************************)

    if puffer_pos_suche_anfang(datx_puffer,'-- ',512)<>nicht_gefunden then
      sql;

    w1:=puffer_pos_suche_anfang(gross_datx_puffer,'FILE ',512);
    if w1<>nicht_gefunden then
      begin
        w2:=puffer_pos_suche_anfang(gross_datx_puffer,'CHA ',512);
        if (w2<>nicht_gefunden) and (w1<w2) then
          begin
            exezk:=datei_lesen__zu_zk_zeilenende(analyseoff+w1+Length('FILE '));
            exezk:=in_doppelten_anfuerungszeichen(leer_filter(exezk));
            ausschrift('OS/2 Patch '+exezk,packer_dat);
          end;
      end
    else
      begin
        w1:=puffer_pos_suche_anfang(gross_datx_puffer,'VER ',512);
        if w1<>nicht_gefunden then
          begin
            exezk:=leer_filter(datei_lesen__zu_zk_zeilenende(analyseoff+w1+Length('CHA ')));
            w1:=Pos(' ',exezk);
            w2:=puffer_pos_suche_anfang(gross_datx_puffer,'CHA ',512);
            if (w2<>nicht_gefunden) and (w1<w2)
            and (w1>=3) and (Length(exezk)-w1>=2) and (Length(exezk)-w1<=8*2)
             then
              begin
                (* ohne Dateiname *)
                ausschrift('OS/2 Patch',packer_dat);
              end;
          end;
      end;


    (* schon in typ_dat erledigt:
    if puffer_gefunden(datx_puffer,'TR ')
    or puffer_gefunden(gross_datx_puffer,'TR-SCRIPT')
    or puffer_gefunden(gross_datx_puffer,'TRSCRIPT')
    or (puffer_gefunden(datx_puffer,#$0d#$0a'exe1'#$0d#$0a) and puffer_gefunden(datx_puffer,#$0d#$0a'reload'#$0d#$0a))
    or (puffer_gefunden(datx_puffer,'pret'#$0d#$0a) and puffer_gefunden(datx_puffer,#$0d#$0a'r ?? '))
     then
      tr_script; *)

    if puffer_pos_suche_datx_puffer('\begin{picture}(',400)<>nicht_gefunden then
      (* GV 4/GS 7.00 *)
      ausschrift('Tex '+textz_datx__Quelltext^,signatur)
    else
      begin
        w1:=puffer_pos_suche_datx_puffer('\documentclass',400);
        if w1<>nicht_gefunden then
          if datx_puffer.d[w1+Length('\documentclass')] in [Ord('['),Ord('{')] then
            ausschrift('Tex '+textz_datx__Quelltext^,signatur);
      end;

    w1:=puffer_pos_suche_gross_datx_puffer(':TITLE'#$0d#$a,400);
    if w1<>nicht_gefunden then
      (*
      if (w1=0) or ( (w1>=2) and bytesuche(datx_puffer.d[w1-2],#$0d#$0a) ) then
        begin
          Inc(w1,Length(':TITLE'#$0d#$a));
          dsp_oder_ddp_datei(analyseoff+w1);
        end;*)
      versuche_dsp_oder_ddp_datei;

    if not hersteller_gefunden then
      if textdatei then
        if puffer_gefunden(datx_puffer,'CATALOG'#$0d#$0a) then
          versuche_ibm_software_installer;

    (* @NUMMER.ADF *)
    w1:=puffer_zeilen_anfang_suche_pos(gross_datx_puffer,'ADAPTERID ');
    if w1<>nicht_gefunden then
      begin
        ausschrift('Adapter Definition File / ? '
          +in_doppelten_anfuerungszeichen(
            datei_lesen__zu_zk_zeilenende(analyseoff+w1+Length('AdapterId '))),signatur);
        w1:=puffer_zeilen_anfang_suche_pos(gross_datx_puffer,'ADAPTERNAME ');
        if w1<>nicht_gefunden then
          ausschrift_x(leer_filter(datei_lesen__zu_zk_zeilenende(analyseoff+w1+Length('AdapterName '))),beschreibung,absatz);
      end;

    if textdatei or (einzel_laenge<200) then
      if bytesuche(gross_datx_puffer.d[0],'NAME ')
      or bytesuche(gross_datx_puffer.d[0],'LIBRARY')
      or bytesuche(gross_datx_puffer.d[0],'VIRTUAL DEVICE')
      or bytesuche(gross_datx_puffer.d[0],'PHYSICAL DEVICE')
      or bytesuche(gross_datx_puffer.d[0],'DESCRIPTION ')
      or bytesuche(gross_datx_puffer.d[0],'IMPORTS ')
      or bytesuche(gross_datx_puffer.d[0],';')
       then
        versuche_def;

    (* ROSE EXEHEAD *)
    if einzel_laenge<800 then
      begin
        w1:=puffer_pos_suche_datx_puffer(#$0d#$0a#$09'RegStr',100);
        if w1<>nicht_gefunden then
          ansi_anzeige(analyseoff,#0,ftab.f[farblos,hf]+ftab.f[farblos,vf]
           ,absatz,wahr,wahr,analyseoff+einzel_laenge,'')
      end;

    w1:=puffer_pos_suche_datx_puffer(#$0d#$0a' E 0100 ?? ?? ',120);
    if w1<>nicht_gefunden then
      ausschrift('DebugSCR / Michael J. Mefford "'+puffer_zu_zk_e(datx_puffer.d[3],#$0d,20)+'"',signatur);

    w1:=puffer_pos_suche_datx_puffer(#$0d#$0a'a100'#$0d#$0a'db ??,??,',120);
    if w1<>nicht_gefunden then
      ausschrift('DebugSCR(?) / Michael J. Mefford "'+puffer_zu_zk_e(datx_puffer.d[1],#$0d,20)+'"',signatur);

    w1:=puffer_pos_suche_datx_puffer(#$0d#$0a'E 0100 ?? ',120);
    if w1<>nicht_gefunden then
      begin
        if w1>=14 then w1:=w1-14 else w1:=0;
        datei_lesen(datx_tmp_puffer,analyseoff+w1,20);
        w1:=puffer_pos_suche(datx_tmp_puffer,'N ',20);
        if w1<>nicht_gefunden then
          exezk:=' "'+puffer_zu_zk_e(datx_tmp_puffer.d[w1+2],#$0d,8+1+3)+'"'
        else
          exezk:='';
        ausschrift('DbgScrpt / Nowhere Man '+exezk,signatur);
      end;

    w1:=puffer_pos_suche_datx_puffer(':userdoc.',500);
    if w1<>nicht_gefunden then
      begin
        ausschrift('IBM Information Present Facility - '+textz_datx__Quelltext^,signatur);
        w1:=puffer_pos_suche_datx_puffer(':title.',400);
        if w1<>nicht_gefunden then
          ausschrift(puffer_zu_zk_zeilenende(datx_puffer.d[w1+7],80),beschreibung);
      end;

    if puffer_pos_suche_datx_puffer(#$0a'/*',6)<>nicht_gefunden then
      c_kommentar;

    if puffer_gefunden(gross_datx_puffer,'<WARPIN>') then
      ausschrift('WarpIN script',signatur);


    (* vor MIME weil auch content-type ... vorkommen kann *)
    if puffer_gefunden(gross_datx_puffer,'<!DOCTYPE HTML')
    or puffer_gefunden(gross_datx_puffer,'<HTML>')
    or puffer_gefunden(gross_datx_puffer,'<HTML ') (* <html xmlns:v="urn:schemas-microsoft-com:vml" *)
    or puffer_gefunden(gross_datx_puffer,'<TITLE>')
    or puffer_gefunden(gross_datx_puffer,'<SGUIDE')
     then
      html;

    (* JavaScript *)
    w1:=puffer_pos_suche(gross_datx_puffer,'<SCRIPT LANGUAGE="',200);
    if w1<>nicht_gefunden then
      begin
        Inc(w1,Length('<SCRIPT LANGUAGE="'));
        ausschrift(puffer_zu_zk_e(datx_puffer.d[w1],'"',20),signatur);
      end;

    (* pascal spÑter *)

    (* SPIELSTéNDE *****************************************************)

    if einzel_laenge=242042 then
      begin (* MM4 *)
        exezk:=datei_lesen__zu_zk_e(analyseoff+$962,#0,$1f);
        if ist_ohne_steuerzeichen_nicht_so_streng(exezk)
        and (Length(exezk)>2) then
          begin
            ausschrift('Might and Magic: Swords of Xeen / New World Computing',spielstand);
            ausschrift_x(exezk,beschreibung,absatz);
          end;
      end;

    if einzel_laenge=283796 then
      begin (* MM5 *)
        exezk:=datei_lesen__zu_zk_e(analyseoff+$96a,#0,$1f);
        if ist_ohne_steuerzeichen_nicht_so_streng(exezk)
        and (Length(exezk)>2) then
          begin (* Wolkenwelt *)
            ausschrift('Might and Magic: Clouds of Xeen / New World Computing',spielstand);
            ausschrift_x(exezk,beschreibung,absatz);
          end;
      end;

    if einzel_laenge=381691 then
      begin (* MM5 *)
        exezk:=datei_lesen__zu_zk_e(analyseoff+$de2,#0,$1f);
        if ist_ohne_steuerzeichen_nicht_so_streng(exezk)
        and (Length(exezk)>2) then
          begin
            ausschrift('Might and Magic: Darkside of Xeen / New World Computing',spielstand);
            ausschrift_x(exezk,beschreibung,absatz);
          end;
      end;

    if (einzel_laenge=65276) and (x_longint__datei_lesen(einzel_laenge-4)=$feedface) then
      begin (* Drachen bekÑmpfen *)
        ausschrift('Discworld / Perfect Entertainment [1]',spielstand);
        ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(datx_puffer.d[0],#0,$22)),beschreibung,absatz);
      end;


    if  ((einzel_laenge=3092)
    and bytesuche(datx_puffer.d[$14],#$00#$c1#$ff#$ff)
    and bytesuche(datx_puffer.d[$44],#$00#$00#$02#$11))
    or  ((einzel_laenge=3098)
    and bytesuche(datx_puffer.d[$14],#$00#$c1#$ff#$ff)
    and bytesuche(datx_puffer.d[$44+6],#$00#$00#$02#$11))
     then
      ausschrift('Simon the Sorcerer 1 / Adventuresoft',spielstand);

    if bytesuche(datx_puffer.d[$34],'IFCPT') then
      ausschrift('Eternam / Infogrames "'+puffer_zu_zk_e(datx_puffer.d[0],#0,$26)+'"',spielstand);

    if (einzel_laenge=225745) and (datx_puffer.d[0] in [0,1]) then
      ausschrift('Caesar 2 / Sierra',spielstand);

    if (einzel_laenge=45628) and bytesuche(datx_puffer.d[$30],#$00#$00) then
      begin
        exezk:=puffer_zu_zk_e(datx_puffer.d[0],#0,$f);
        if filter(exezk)=exezk then
          ausschrift('Victory / TopWare "'+exezk+'"',spielstand);
      end;

    if puffer_pos_suche_datx_puffer(#$02#$11#$00#$4b#$00#$6f#$00#$06,$60)<>nicht_gefunden then
      ausschrift('Simon the Sorcerer / Adventure Soft "'+puffer_zu_zk_e(datx_puffer.d[0],#0,80)+'"',spielstand);

    if dateilaenge=576590 then
      if bytesuche(datx_puffer.d[$80],#$00#$00#$00#$0f#$27#$0f#$27#$0f#$27) then
        ausschrift('Z / ??? "'+puffer_zu_zk_e(datx_puffer.d[1],#0,40)+'"',spielstand);

    if bytesuche(datx_puffer.d[$20],#$00#$03#$03#$04#$06#$06#$08#$0a) then
      (*ausschrift('Anvil of the Dawn / New World Computing "'+puffer_zu_zk_e(datx_puffer.d[0],#0,$20)+'"',spielstand);*)
      anvil_of_dawn(datx_puffer);

    if bytesuche(datx_puffer.d[$a9],'Gorath') and (einzel_laenge=334605) then
      ausschrift('Beatryl at Krondor / Dynamix/Sierra "'+puffer_zu_zk_e(datx_puffer.d[0],#0,255)+'"',spielstand);

    if bytesuche(datx_puffer.d[$28],'War2') then
      ausschrift('Warcarft 2  "'+puffer_zu_zk_e(datx_puffer.d[0],^z,40)+'"',spielstand);

    if bytesuche(datx_puffer.d[$10],#$e8#$c6#$14#$10) then
      begin
        case datx_puffer.d[$30] of
          0:exezk:='NOD';
          1:exezk:='GDI';
        else
            exezk:='???'
        end;

        ausschrift('Command & Conquer / Westwood "'+puffer_zu_zk_e(datx_puffer.d[0],#$0d,80)+'" '
         +exezk+textz_datx__Mission^+str0(datx_puffer.d[$2c]),spielstand);
        goto datx_fertig;
      end;


    w1:=puffer_pos_suche_datx_puffer(#$0d#$0a#$00#$1a#$00#$00#$00#$00#$00#$00#$00,$2c);
    if (w1<>nicht_gefunden) and (w1>0) and (datx_puffer.d[$30] in [0,1,2]) then
      begin
        case datx_puffer.d[$30] of
          1:exezk:='Allianz';
          2:exezk:='Sowjets';
        else
            exezk:='???'
        end;

        ausschrift('Coommand & Conquer 2 / Westwood "'+puffer_zu_zk_e(datx_puffer.d[0],#$0d,$2c)+'" '
          +exezk+textz_datx__Mission^+str0(datx_puffer.d[$2c]),spielstand);
        goto datx_fertig;
      end;

    (* ARCHIVE *********************************************************)

    if hersteller_gefunden then
      goto datx_fertig;

    if bytesuche(datx_puffer.d[3],#$00'TCT ') then
      bluebyte_tct(datx_puffer);

    if bytesuche(datx_puffer.d[0],'??'#$00#$00#$ef#$be#$ad#$de'NullSoftInst') then
      nullsoft_inst_x(datx_puffer,1,$1c,0);
    if bytesuche(datx_puffer.d[0],'??'#$00#$00#$ef#$be#$ad#$de'NullsoftInst') then
      nullsoft_inst_x(datx_puffer,2,$18,0);

    (* agb4p.exe: Antiy Ghostbusters 4 Installation *)
    {if bytesuche(datx_puffer.d[3],#$00'engine\')
    or bytesuche(datx_puffer.d[3],#$00'dat\')
    or bytesuche(datx_puffer.d[3],#$00'isolate\')
    or bytesuche(datx_puffer.d[3],#$00'log\')
    or bytesuche(datx_puffer.d[3],#$00'alive.ini')}
    if  (longint_z(@datx_puffer.d[0])^<=einzel_laenge)
    and (longint_z(@datx_puffer.d[0])^>$240) then
      begin
        exezk:=puffer_zu_zk_e(datx_puffer.d[4],#0,$23c);
        if ist_ohne_steuerzeichen_nicht_so_streng(exezk) then
          if bytesuche__datei_lesen(analyseoff+$240,'PK') then
            begin
              ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
              einzel_laenge:=$240;
              befehl_schnitt(analyseoff+$240,longint_z(@datx_puffer.d[0])^-$240,exezk+'.zip');
            end;
      end;

    if (einzel_laenge=683*$100) (* 35       *)
    or (einzel_laenge=683*$101) (* 35+Error *)
    or (einzel_laenge=768*$100) (* 40       *)
    or (einzel_laenge=768*$101) (* 40+Error *)
     then
      d64;

    if (einzel_laenge=3200*$100) (* 80       *)
    or (einzel_laenge=3200*$101) (* 80+Error *)
     then
      d81;


    if bytesuche(datx_puffer.d[$20],'{SLF}') then (* powarc800.exe *)
      begin
        ausschrift('SLF - PowerArchiver CAB SFX / ConeXware',bibliothek);
        einzel_laenge:=$20+longint_z(@datx_puffer.d[$25])^;
      end;

    if bytesuche(datx_puffer.d[1],#$00#$00#$00#$00'?archivefile/20??-??-??/') then
      archivefile;


    if (longint_z(@datx_puffer.d[0])^>=1) and (longint_z(@datx_puffer.d[0])^<=8000) then
      if longint_z(@datx_puffer.d[0])^*$28+4=longint_z(@datx_puffer.d[$24])^ then
        iconease_dat_130;

    if (datx_puffer.d[$13]=0) then
      if bytesuche(datx_puffer.d[$48],#$00#$04) then
        if longint_z(@datx_puffer.d[$3f])^<75366 then (* 64KB, 1,15 al schlechteste Kompression *)
          if not bytesuche(datx_puffer.d[$28],' EMF') then (* VaderBulb.emf - windows metadatei *)
            rompaq;

    if puffer_gefunden(gross_datx_puffer,'COMPAQ') then
      softpaq;

    (* sp6545.exe, sp6975.exe *)
    if (analyseoff>$7000) and (analyseoff<$a000) then
      if datei_pos_suche(analyseoff,analyseoff+DGT_zu_longint(MinDGT(5000,einzel_laenge)),#$0d#$0a'[FIT]')<>nicht_gefunden then
        softpaq;

    if analyseoff<>0 then
      begin (* ChArc *)
        l1:=puffer_pos_suche(datx_puffer,'SChF???'#$00'???'#$00,$40);
        if l1<>nicht_gefunden then
          einzel_laenge:=l1;
      end;

    if bytesuche(datx_puffer.d[2],#$fe#$00#$00#$00#$01#$00) then
      SaveRam2(word_z(@datx_puffer.d[0])^);

    (*
    if (not wpi_erweiterung)
    and (   bytesuche(datx_puffer.d[$105],#$00'Test Appli')
         or bytesuche(datx_puffer.d[$105],#$00'reserved'#$00))
     then
      wpi(analyseoff,'.WPI');*)

    if (analyseoff>0) and bytesuche(datx_puffer.d[$f],'file,') then
      begin
        setup_twk;
        goto datx_fertig;
      end;

    w1:=puffer_pos_suche_datx_puffer('SPIS'#$1a,512); (* + NON RLE LZH CUS LH5 *)
    if w1<>nicht_gefunden then
      spis(w1); (* presetup *)

    if (datx_puffer.d[1]=0) and (analyseoff=$49b) then
      begin
        l1:=word_z(@datx_puffer.d[0])^*$10000+word_z(@datx_puffer.d[2])^;
        if (l1>=5) and (l1<einzel_laenge) then
          if ist_ohne_steuerzeichen(puffer_zu_zk_e(datx_puffer.d[4],#0,128)) then
            linkit_michael_badichi;
      end;

    if bytesuche(datx_puffer.d[$c],'b1'#$05#$00) then
      ausschrift('Berkeley DB 2.X',normal); (* bogofilter *)

    if bytesuche(datx_puffer.d[4],'__NAILZHUFLIB'#$00) then
      nai_lzhuflib;

    dp1:=$2711-analyseoff;
    if (dp1>0) and (dp1+10<datx_puffer.g) then
      begin
        l1:=DGT_zu_longint(dp1);
        if (datx_puffer.d[l1+3]=0) and (longint_z(@datx_puffer.d[l1+4])^=dateilaenge) then
          (* Crypta II *)
          ausschrift('CryEXE / Iosco Capitolino [3.0] '+DGT_str0(dateilaenge-$2711-38),packer_dat); (* _exe ? *)
      end;

    dp1:=$2ee1-analyseoff;
    if (dp1>0) and (dp1<datx_puffer.g) then
      begin
        l1:=DGT_zu_longint(dp1);
        if (datx_puffer.d[l1+3]=0) and (longint_z(@datx_puffer.d[l1+4])^=dateilaenge) then
          ausschrift('CryEXE / Iosco Capitolino [4.0] '+DGT_str0(dateilaenge-$2ee1-40),packer_dat); (* _exe ? *)
      end;

    dp1:=$1e78-analyseoff;
    if (dp1>2) and (dp1<datx_puffer.g) then
      begin
        l1:=DGT_zu_longint(dp1);
        if bytesuche(datx_puffer.d[l1-2],#$c7#$04'??'#$00#$00) then
          ausschrift('DCREXE / LuCe [2.0] '+DGT_str0(dateilaenge-$1e78-4),packer_dat); (* _exe ? *)
      end;

    if analyseoff=14608 then
      begin
        w1:=0;
        for w2:=0 to 2 do
          if chr(datx_puffer.d[w2]) in ['A'..'Z','0'..'9'] then
            inc(w1);

        if w1=3 then
          ausschrift('LockTite Plus / Michael Wegner [1990] ".'+puffer_zu_zk_l(datx_puffer.d[0],3)+'" '
            +DGT_str0(einzel_laenge-11),packer_dat);
      end;

    (* Scitechsoft Display Driver *)
    if bytesuche(datx_puffer.d[4],#$bc#$d0#$11#$98#$94#$9c#$d9) (* config.bdp *)
    or bytesuche(datx_puffer.d[4],#$bb#$cd#$16#$88#$98#$89#$d9) (* driver.tab *)
    or bytesuche(datx_puffer.d[4],#$b2#$d4#$1c#$8c#$89#$98#$d9) (* mkcrtc.bdp - OS/2 Beta 11 *)
    or bytesuche(datx_puffer.d[4],#$bc#$da#$0d#$8a#$94#$9d#$8e) (* certify.tab - OS/2 IBM/se GA 1 *)
     then
      graphics_bpd(longint_z(@datx_puffer.d[0])^);

    if bytesuche(datx_puffer.d[2],#$11#$b7#$39#$b7#$b4#$02#$3c) then
      rtd_dat;

    if  (longint_z(@datx_puffer.d[$00])^<5000000)
    and (analyseoff>10000)

     then
      begin
        exezk:=puffer_zu_zk_e(datx_puffer.d[$04],#0,80);
        exezk:=gross(exezk);
        if  ist_ohne_steuerzeichen_nicht_so_streng(exezk)
        and (Pos('.CFG',exezk)>0)
        and (Length(exezk) in [7..8+1+3])
        and (   (x_longint__datei_lesen(dateilaenge-$10+$8)=analyseoff-$10)
             or (Pos('INSTALL.CFG',exezk)>0))
         then
          ati_exe_archiv(datx_puffer);
      end;


    (* 'SCG'#01 xor 'abcd' *)
    if (bytesuche(datx_puffer.d[$04],#$32#$21#$24#$65) and (longint_z(@datx_puffer.d[$00])^<32000))
    (* 'SCG'#$88 xor 'abcd': rb2_3d.exe - red baron 2 3d patch *)
    or (bytesuche(datx_puffer.d[$04],#$32#$21#$24#$ec) and (longint_z(@datx_puffer.d[$00])^<32000))
     then
      begin
        scg_setup_info(datx_puffer,1);
        goto datx_fertig;
      end;

    (* 'SCG'#01 xor 'abcd' xor #$ffffffff rol 4 *)
    if bytesuche(datx_puffer.d[$04],#$dc#$ed#$bd#$a9) and (longint_z(@datx_puffer.d[$00])^<320000) then
      begin
        scg_setup_info(datx_puffer,2);
        goto datx_fertig;
      end;

    if bytesuche(datx_puffer.d[$1c-4],#$00#$00#$00#$00#$ca#$da#$7a#$5b) (* "DISK1\SETUP.EXE" *)
    or bytesuche(datx_puffer.d[0],#$94#$01#$00#$00#$06#$00#$00#$00)
     then
      begin
        myresource_1024_installshield(analyseoff,einzel_laenge,true);
        goto datx_fertig;
      end;

    w1:=puffer_pos_suche(datx_puffer,'MSCF'#$00,200);
    if w1<>nicht_gefunden then
      (* EXE mit MSCF und noch zusÑtzlichen Daten *)
      if (longint_z(@datx_puffer.d[w1+8])^+w1<=einzel_laenge)
       then
        begin
          (* SETUP.EXE "bootie4s.exe" *)
          einzel_laenge:=w1;
        end;


    if  bytesuche(datx_puffer.d[$04],'LZ')
    and (word_z(@datx_puffer.d[$00])^+longint_z(@datx_puffer.d[$06])^+6=einzel_laenge) then
     ldiff_210(datx_puffer);


    (* Erst die Variante mit Kommentar ... *)
    if (datx_puffer.d[0]=0) and bytesuche(datx_puffer.d[$5b+1],'MS ') then
      begin
        w1:=$5c;
        exezk:=datei_lesen__zu_zk_e(analyseoff+w1,#0,255);
        Inc(w1,Length(exezk)+1);
        exezk:=datei_lesen__zu_zk_e(analyseoff+w1,#0,255);
        Inc(w1,Length(exezk)+1);
        exezk:=datei_lesen__zu_zk_e(analyseoff+w1,#0,255);
        Inc(w1,Length(exezk)+1);
        if w1=datx_puffer.d[$5b]+$5c then
          begin
            l1:=longint_z(@datx_puffer.d[$4d])^;
            if (l1<>0) and (l1>analyseoff) and (analyseoff<=$6e00) then
              einzel_laenge:=l1-analyseoff;
            wise_glb(datx_puffer,w1);
            goto datx_fertig;
          end;
      end;

    (* Dann die Ñlteren ohne ... *)
    if (analyseoff>8000) and (AndDGT(analyseoff,$f)=0) then
      if ((analyseoff=$3660) and (   bytesuche(datx_puffer.d[$1f],#$00#$9f#$d2#$00#$00)
                                  or bytesuche(datx_puffer.d[$1f],#$00#$c0#$d1#$00#$00)
                                  or bytesuche(datx_puffer.d[$1f],#$00#$77#$d2#$00#$00)   (* AUTOPLAY.EXE *)
                                  or bytesuche(datx_puffer.d[$1f],#$00#$87#$d1#$00#$00))) (* DICTGE.EXE   *)
      or ((analyseoff=$36f0) and     bytesuche(datx_puffer.d[$1f],#$00#$a2#$db#$00#$00))
      or ((analyseoff=$3780) and  {   bytesuche(datx_puffer.d[$20],#$00#$4a#$05#$01#$00)}
                                  {or bytesuche(datx_puffer.d[$20],#$00#$6e#$0a#$01#$00)}{)}  (* FSUPDATE.EXE *)
                                     (longint_z(@datx_puffer.d[$4d])^=dateilaenge))

      or ((analyseoff=$37d0) and (   bytesuche(datx_puffer.d[$20],#$00#$b7#$e4#$00#$00)
                                  or bytesuche(datx_puffer.d[$20],#$00#$cc#$e5#$00#$00))) (* XING DEMO XME220T.EXE *)
      (* !!zip ? *)
      or ((analyseoff=$3c30))
      or ((analyseoff=$3e10))
      or ((analyseoff=$3c80))
      or ((analyseoff=$3e50))
      or ((analyseoff=$3bd0))
      or ((analyseoff=$3c10))
      or ((analyseoff=$84b0))
      or ((analyseoff=$3c20)) (* 14FF51.EXE *)
      or ((analyseoff=$7760)) (* CMRCDE.EXE *)

      (* PE *)
      or ( (AndDGT(analyseoff,512-1)=0)
      and (     (longint_z(@datx_puffer.d[$4d])^=dateilaenge)
            or ((longint_z(@datx_puffer.d[$4c])^=dateilaenge) and (analyseoff=$6e00))))
           (* es gibt aber immernoch nicht erkannte Dateienen .. *)
       then
        begin
          wise_glb(datx_puffer,w1);
          goto datx_fertig;
        end;





    (* WINZIP (NE) *)
    w2:=puffer_pos_suche_datx_puffer('PK'#$03#$04'?'#$00,500);
    if (w2<>nicht_gefunden)
    and (datx_puffer.d[w2+4]>= 9) (* Version 0.9 .. 5.0 *)
    and (datx_puffer.d[w2+4]<=50)
     then
      begin
        einzel_laenge:=w2;
        w1:=puffer_pos_suche_gross_datx_puffer('NICO MAK COM',w2);

        if  (w1<>nicht_gefunden) then
          begin
            if w2>w1 then
              dec(w2,w1);

            if w2>100 then w2:=100;

            exezk:=puffer_zu_zk_zeilenende(datx_puffer.d[w1],w2);
            ausschrift(exezk,beschreibung);
          end;
      end;

    if  bytesuche(datx_puffer.d[$19],#$50#$01#$06)
    and (longint_z(@datx_puffer.d[0])^>=longint_z(@datx_puffer.d[$11])^)
     then
      begin
        exezk:=puffer_zu_zk_e(datx_puffer.d[4],#0,255);
        if length(exezk)=8+1+3 then
          azt;
      end;

    if bytesuche(datx_puffer.d[8],#$30#$82)
    or bytesuche(datx_puffer.d[8],#$30#$82) then
      if  (einzel_laenge>=longint_z(@datx_puffer.d[0])^)
      and (longint_z(@datx_puffer.d[0])^<20*1024)
      and (   (puffer_gefunden(datx_puffer,'VeriSign Tr'))
           or (puffer_gefunden(datx_puffer,'<'#0'<'#0'O'#0'b'#0's'#0'o'#0'l'#0'e'#0't'#0'e'))
           or (puffer_gefunden(datx_puffer,#$06#$09#$2a#$86#$48#$86))) (* WEB.DE *)
       then
        begin
          (*ausschrift('Authenticode ??, Netscape PKCS, S/MIME',signatur);*)
          ASN1(analyseoff+8);
          einzel_laenge:=longint_z(@datx_puffer.d[0])^;
        end;

    if bytesuche(datx_puffer.d[81-1],#$00'MZ') and (datx_puffer.d[81] in [0..80]) then
      begin
        exezk:=puffer_zu_zk_pstr(datx_puffer.d[0]);
        for w1:=1 to length(exezk) do
          dec(exezk[w1],(((w1-1) mod 5)+1)*8);
        ausschrift('EXELocker / Ong Hui Lam [1.0] "'+exezk+'"',packer_exe);
        einzel_laenge:=81;
      end;

    if bytesuche(datx_puffer.d[$03],#$00#$26#$96#$92#$00#$00#$18#$02#$10) then
      ausschrift('Armadillo / Silicon Realms Toolworks [1.72,1.75a,1.76,1.77b]',packer_exe);

    (* unter verschieden Betriebssystemen verschiedene AnfÑnge *)
    if  (longint_z(@datx_puffer.d[$10])^=einzel_laenge)
    and (longint_z(@datx_puffer.d[$14])^>0)
    and (longint_z(@datx_puffer.d[$14])^<10000)
    and (longint_z(@datx_puffer.d[$08])^=0)
     then
      pak_dd;


    if bytesuche(datx_puffer.d[0],'?'#$00#$00#$00'FILES?'#$00) then
      begin
        f2:=datei_pos_suche(analyseoff+10,analyseoff+MinDGT(1000,einzel_laenge),'BZh?1A');
        f1:=longint_z(@datx_puffer.d[0])^;
        if (f1>=3) and (f1<=500) and (f2<>nicht_gefunden) then
          progressive_setup(datx_puffer,f2-analyseoff);
      end;

    if datx_puffer.d[3]=0 then
      if bytesuche(datx_puffer.d[$100],#$cd#$cd#$cd#$cd#$cd#$cd#$cd#$cd'???'#$00) then
        begin
          exezk:=puffer_zu_zk_e(datx_puffer.d[$4],#0,255);
          if ist_ohne_steuerzeichen_nicht_so_streng(exezk) then
            trillian_install_program;
        end;

    w1:=puffer_pos_suche_datx_puffer('TTCODE TTCODE 1',$1e0);
    if w1<>nicht_gefunden then
      begin
        ausschrift('TTCode / Tom Torfs',packer_dat);
        goto datx_fertig;
      end;

    if  bytesuche(datx_puffer.d[$18],#$00+'????'+#$09)
    and (longint_z(@datx_puffer.d[$4])^=longint_z(@datx_puffer.d[$8])^)
    and (longint_z(@datx_puffer.d[0])^<=einzel_laenge)
    and (einzel_laenge>200)
     then
      begin
        exezk:=puffer_zu_zk_e(datx_puffer.d[$c],#0,8+1+3);
        if (length(exezk)>4) and (pos('.',exezk)>2) then
          pack_3com(datx_puffer);
      end;

    (* sanyo update - phoenix mit debugger *)
    if bytesuche(datx_puffer.d[$10],'Prog_$ID') then
      begin
        (* .COM Anteil *)
        einzel_laenge:=longint_z(@datx_puffer.d[$18])^;
        (* BIOS-Block *)
        merke_position(analyseoff+longint_z(@datx_puffer.d[$18])^+longint_z(@datx_puffer.d[$20])^,datentyp_unbekannt);
      end;

    if ((einzel_laenge>$020000) and (einzel_laenge<$021000))
    or ((einzel_laenge>$040000) and (einzel_laenge<$041000))
    or ((einzel_laenge>$080000) and (einzel_laenge<$081000))
    or ((einzel_laenge>$100000) and (einzel_laenge<$101000))
    or ((einzel_laenge>$200000) and (einzel_laenge<$201000)) then
      if bytesuche__datei_lesen(AndDGT(einzel_laenge,$ff0000),'BC'#$d6#$f1) then
        (* ende_suche findet dann 1*Phoenix BIOS archiv,+2 BCxxx *)
        einzel_laenge:=AndDGT(einzel_laenge,$ff0000);


    if bytesuche(datx_puffer.d[$a],#$01#$01'CP') then
      begin
        ausschrift('Compaq BIOS-ROM "'+puffer_zu_zk_e(datx_puffer.d[$c],#0,4+3)+'" "'
                                      +puffer_zu_zk_e(datx_puffer.d[$14],#0,2+1+2+1+2)+'"',signatur);
        einzel_laenge:=longint_z(@datx_puffer.d[$3f])^+$48;
      end;

    (* unbekannte Datenstruktur bei 512KB-Award-BIOS-Vraianten,
       dc6p6273.bin W6787VMS.240
       danach folgt Intel P6+ microcode *)
    if bytesuche(datx_puffer.d[4],#$fe#$ff#$00#$00#$fe#$ff#$00#$00) then
      if bytesuche__datei_lesen(analyseoff+$1000-4,#$ff#$ff#$ff#$ff#$01#$00#$00#$00) then
        einzel_laenge:=$1000;

    if bytesuche(datx_puffer.d[4],'mdat') and (m_longint(datx_puffer.d[0])<=einzel_laenge) then
      mov;

    if datx_puffer.d[0] in [8..8+1+3] then
      if datx_puffer.d[datx_puffer.d[0]+1]=0 then
        begin
          w1:=puffer_pos_suche_datx_puffer('.',datx_puffer.d[0]);
          if (w1<>nicht_gefunden) and (w1>4) then
            begin
              (* LÑnge <16MB, PKWARE Anfang *)
              if bytesuche(datx_puffer.d[$14],#$00#$00#$06) then
                pm2you24_zap
              else
              if bytesuche(datx_puffer.d[$14],#0#0#0#0#0#0#0#0#0#0#0#0) and (datx_puffer.d[$20] in [4,5,6]) then
                apogee_raptor (* ALIEN CARNAGE *)
              else
                abcomp(datx_puffer);
            end;
        end;

{    if  bytesuche(datx_puffer.d[$03],#$00'???'#$00#$01#$00#$00#$00#$00#$00#$0c#$00)
    and (bytesuche(datx_puffer.d[$19],#$71#$97#$a0) then
      gammatech;}
    if  (longint_z(@datx_puffer.d[$00])^=einzel_laenge)
    and bytesuche(datx_puffer.d[$07],#$00#$01#$00#$00#$00#$00#$00'?'#$00)
    and (datx_puffer.d[$0e] in [5+1..12+1])
    and bytesuche(datx_puffer.d[13+datx_puffer.d[$0e]],#$71#$97#$a0)
     then
      gammatech;

    if  (longint_z(@datx_puffer.d[$00])^>$20000) (* 24ef8 *)
    and (longint_z(@datx_puffer.d[$00])^<$30000) then
      if (analyseoff>=$8000) and (analyseoff<=$a000) then
        begin
          (* sq4.exe sqeez: sq4.exe SQ38009.TMP, mit inflate gepackt *)
          f1:=datei_pos_suche(analyseoff,analyseoff+MinDGT(einzel_laenge,$20000),'P#R????-sqx-');
          if f1<>nicht_gefunden then
            einzel_laenge:=f1-analyseoff;
        end;

    if bytesuche(datx_puffer.d[2],'SFXF') then (* wace22d.exe sfxfiles\*.sfx *)
      begin
        l1:=word_z(@datx_puffer.d[0])^;
        if (l1>500) and (l1<einzel_laenge) then
          begin
            ausschrift('ACE SFX / Marcel Lemke; Daniel Pantke',packer_dat);
            ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(datx_puffer.d[$21],#0,255)),beschreibung,absatz);
            einzel_laenge:=l1;
          end;
      end;

    if bytesuche(datx_puffer.d[2],'MSGF') then (* ace20.exe\MSGFILES\*.MSG  *)
      begin
        l1:=word_z(@datx_puffer.d[0])^;
        if (l1>40) and (l1<einzel_laenge) then
          begin
            ausschrift('ACE message file / Marcel Lemke; Daniel Pantke',packer_dat);
            ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(datx_puffer.d[$36],#0,255)),beschreibung,absatz);
            einzel_laenge:=l1;
          end;
      end;

    if bytesuche(datx_puffer.d[$07],'**ACE**') (* normal *)
    or bytesuche(datx_puffer.d[$07],'**SFX**') (* wace22d.exe *)
     then
      ace(datx_puffer.d[$e]);

    if bytesuche(datx_puffer.d[$37],'**ACE**') then
      begin
        ausschrift('SFX-Daten ACE / Marcel Lemke',packer_dat);
        einzel_laenge:=$30;
      end;

    if not hersteller_gefunden then
      begin (* AXSETUP *)
        w1:=puffer_pos_suche_datx_puffer('**ACE**',400);
        if (w1<>nicht_gefunden) and (w1>7) then
          einzel_laenge:=w1-7;
      end;


    if bytesuche(datx_puffer.d[1],#$00'TX???'#$00) then
      begin
        exezk:=puffer_zu_zk_e(datx_puffer.d[4],#0,3);
        ausschrift('textfile '+in_doppelten_anfuerungszeichen(exezk)+' MKXDSKF / C.Langanke',packer_dat);
        einzel_laenge:=datx_puffer.d[0]+word_z(@datx_puffer.d[$8])^;
        befehl_schnitt(analyseoff+datx_puffer.d[0],word_z(@datx_puffer.d[$8])^,
          erzeuge_neuen_dateinamen('.'+exezk));
      end;

    if bytesuche(datx_puffer.d[1],#$00'DX???'#$00) then
      begin
        ausschrift('cfg/index: MKXDSKF / C.Langanke',packer_dat);
        einzel_laenge:=datx_puffer.d[0];
      end;


    if (datx_puffer.d[$4] in [$e9,$eb])
    and (word_z(@datx_puffer.d[$0])^=word_z(@datx_puffer.d[$17])^)
     then
      begin
        ausschrift(textz_datx__Kopf^+' DiskFile / AST',signatur);
        einzel_laenge:=4;
      end;

    if (longint_z(@datx_puffer.d[$0])^=einzel_laenge)
    and (integer_z(@datx_puffer.d[$6])^>0) (* cbValue *)
    and (integer_z(@datx_puffer.d[$6])^<einzel_laenge)
     then
      begin

        if (datx_puffer.d[$8]=Ord('.')) and
          (   bytesuche(datx_puffer.d[$9],'TYPE'        )
           or bytesuche(datx_puffer.d[$9],'ASSOCTABLE'#0)
           or bytesuche(datx_puffer.d[$9],'CLASSINFO'#0 ) (* wps .CLASSINFO *)
           or bytesuche(datx_puffer.d[$9],'CODEPAGE'#0  )
           or bytesuche(datx_puffer.d[$9],'COMMENTS'#0  )
           or bytesuche(datx_puffer.d[$9],'HISTORY'#0   )
           or bytesuche(datx_puffer.d[$9],'ICON'        ) (* .ICON/.ICON1/.ICONPOS *)
           or bytesuche(datx_puffer.d[$9],'KEYPHRASES'#0)
           or bytesuche(datx_puffer.d[$9],'LONGNAME'#0  )
           or bytesuche(datx_puffer.d[$9],'PREVNAME'#0  )
           or bytesuche(datx_puffer.d[$9],'SUBJECT'#0   )
           or bytesuche(datx_puffer.d[$9],'TYPE'#0      )
           or bytesuche(datx_puffer.d[$9],'VERSION'#0   ) (* IBMNULL.DRV *)

           or bytesuche(datx_puffer.d[$9],'CHECKSUM'#0  ) (* Erzeugt von RC - ibmnull.drv *)
           or bytesuche(datx_puffer.d[$9],'APPT'        )
           or bytesuche(datx_puffer.d[$9],'EXPAND'#0    ) (* IBMNULL.DRV *)
           or bytesuche(datx_puffer.d[$9],'POSTER'      )
           or bytesuche(datx_puffer.d[$9],'PREVCLASS'   )
           or bytesuche(datx_puffer.d[$9],'URL'#0       ) (* wget *)
           or bytesuche(datx_puffer.d[$9],'PPDIMPORTING'#0) (* pscript.drv *)
           or bytesuche(datx_puffer.d[$9],'EXPANDHARDWIRED'#0) (* pscript.drv *)
           or bytesuche(datx_puffer.d[$9],'FEDSTATE'#0  ) (* fed0225s.zip *)
           )
        or bytesuche(datx_puffer.d[$8],'REXX')
        or bytesuche(datx_puffer.d[$8],'OPTIONALDRIVERFILES'#0)
        or bytesuche(datx_puffer.d[$8],'REQUIREDDRIVERFILES'#0)
        or bytesuche(datx_puffer.d[$8],'FONT_INFO'#0) (* \os2\dll\printers\*.fnt - PS *)
        or bytesuche(datx_puffer.d[$8],'CLASSNAME'#0) (* ibmpcl5.drv *)
        or bytesuche(datx_puffer.d[$8],'VENDORNAME'#0) (* ibmpcl5.drv *)
        or bytesuche(datx_puffer.d[$8],'UID'#0)

         then
          ea_archiv(textz_datx__Erweiterte_Attribut^+' EAUTIL / OS/2',analyseoff);
      end;

    (* 2.63 :
    if bytesuche(datx_puffer.d[$70],#$b0#$01#$00#$b4)
    or bytesuche(datx_puffer.d[$90],#$b0#$01#$00#$b4)
     then
      pgp_binaer; *)

    w1:=puffer_pos_suche_datx_puffer(#$b0#$01#$00#$b4,200);
    if w1<>nicht_gefunden then
      begin
        exezk:=puffer_zu_zk_pstr(datx_puffer.d[w1+4]);
        ausschrift(exezk,signatur);
        pgp_binaer;
      end;

    test_shar(datx_puffer);
    w1:=puffer_pos_suche_datx_puffer('This is a shell archive' (* zuviel ' (shar' *),490);
    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_datx_puffer('shar:'#9'Shell Archiver Shar',490);
    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_datx_puffer('shar:'#9'Shell Archiver',490);
    if w1<>nicht_gefunden then
      ausschrift('SHAR .. Shell Archiver',packer_dat);

    if puffer_gefunden(datx_puffer,': This is a command.com archive (produced by dshar ?.??), meaning:') then
      ausschrift('dshar / NIDE Naoyuk',packer_dat);

    w2:=puffer_pos_suche_datx_puffer(#$FF'BSG'#0,12); (* #0#0/#0#1 Versionsnummer? *)
    if w2<>nicht_gefunden then
      bsn(w2);

    if word_z(@datx_puffer.d[0])^<80 then
      if bytesuche(datx_puffer.d[word_z(@datx_puffer.d[0])^+2],#$00#$01#$00) then
        qez;

    if einzel_laenge>20000 then
      if (longint(datx_puffer.d[$00])=longint(datx_puffer.d[$10]+$f)) and (datx_puffer.d[$10]<8+1+3) then
        begin
          exezk:=puffer_zu_zk_pstr(datx_puffer.d[$10]);
          if ist_ohne_steuerzeichen(exezk) then
            jasc;
        end;

    w1:=puffer_pos_suche_datx_puffer('=== BSQ ',400);
    if w1<>nicht_gefunden then
      bsq(datx_puffer,w1);

    (* uue ... *)
    w1:=puffer_pos_suche_datx_puffer('*XX3402-',440);
    if w1<>nicht_gefunden then
      begin
        (* 0.2 *)
        exezk:=puffer_zu_zk_l(datx_puffer.d[w1+$27],8+1+3);
        while exezk[1]='-' do delete(exezk,1,1);
        ausschrift('XX34 / Guy McLoughlin [0.2] '+in_doppelten_anfuerungszeichen(exezk),packer_dat);
        befehl_xx3402(analyseoff,einzel_laenge,exezk);
      end;

    if puffer_pos_suche_datx_puffer('xbtoa',40)<>nicht_gefunden then
      begin
        ausschrift('XBTOA (ecd75*) / Michel Forget',packer_dat);
        goto datx_fertig;
      end;

    (* ybegin line= *)
    (* ybegin part= *)

    w1:=puffer_pos_suche_datx_puffer('ybegin ????=',512);
    if w1<>nicht_gefunden then
      begin
        f1:=datei_pos_suche(analyseoff+w1,analyseoff+w1+512,' name=');
        if f1<>nicht_gefunden then
          begin
            exezk:=datei_lesen__zu_zk_zeilenende(l1+Length(' name='));
            ausschrift('yEncode / JÅrgen Helbing '+
              in_doppelten_anfuerungszeichen(leer_filter(exezk)),packer_dat);
          end;
      end;

    w1:=puffer_pos_suche_datx_puffer('.Begin CODE91',490);
    if w1<>nicht_gefunden then
      ausschrift('CODE91 / GyikSoft "'+puffer_zu_zk_e(datx_puffer.d[w2+30],'"',80)+'"',packer_dat);

    (* begin 666        rw-rw-rw-       uuenview (OS/2)
       begin 644        rw-r--r--
       begin 600        rw-------
       begin 755        rwxr-xr-x
       ....                                                     *)

      w1:=puffer_zeilen_anfang_suche_pos(datx_puffer,'begin 6?? ');
    if w1=nicht_gefunden then
      w1:=puffer_zeilen_anfang_suche_pos(datx_puffer,'begin 7?? ');

    if w1<>nicht_gefunden then
      if datx_puffer.d[w1+7] in [Ord('0')..datx_puffer.d[w1+6]] then
        if datx_puffer.d[w1+8] in [Ord('0')..datx_puffer.d[w1+7]] then
          begin
            exezk:=datei_lesen__zu_zk_zeilenende(analyseoff+w1+10);
            (* kann auch XXEncode sein, aber wie soll ich das schnell herausbekommen? *)
            ausschrift('UUEncode "'+exezk+'"',packer_dat);
            goto datx_fertig;
          end;

    if puffer_gefunden(gross_datx_puffer,'CONTENT-DISPOSITION: ')
    or puffer_gefunden(gross_datx_puffer,'CONTENT-TYPE: ')
     then
      if mime_encode(analyseoff,einzel_laenge,false,'') then
        goto datx_fertig;

    w1:=puffer_pos_suche_datx_puffer('$'#$0d#$0a'ship',$200-25);
    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_datx_puffer('$'#$0a'ship',$200-25)
    else
      inc(w1);

    if w1<>nicht_gefunden then
      begin
        exezk:=puffer_zu_zk_e(datx_puffer.d[w1+7],#$0a,512-w1-20);
        if (length(exezk)>0) and (exezk[length(exezk)]=#$0d) then
          dec(exezk[0]);
        ausschrift('SHIP-Encode "'+exezk+'" (ecd75*) / Michel Forget',packer_dat);
        goto datx_fertig;
      end;

    w1:=puffer_pos_suche_datx_puffer('d with BinHex ',$1f0); (* PCBHEX *)
    if w1<>nicht_gefunden then
      begin
        binhex(w1);
        goto datx_fertig;
      end;

    w1:=puffer_pos_suche_datx_puffer(';ABE ASCII-B',$1f0);
    if w1<>nicht_gefunden then
      begin
        (* datei_lesen(datx_tmp_puffer,analyseoff+w1,512);*)
        ausschrift('ASCII-Binary-Encoding / Brad Templeton',packer_dat);
        goto datx_fertig;
      end;

    if bytesuche(datx_puffer.d[3],#0)
    and (analyseoff=0)
    then
      begin
        exezk:=puffer_zu_zk_e(datx_puffer.d[4],#0,255);
        if ist_ohne_steuerzeichen(exezk)
        and (Pos('\',exezk)=0)
        and (Pos('/',exezk)=0) (* STEELSKY.RST *)
        and (word_z(@datx_puffer.d[0])^>10)
        and (longint_z(@datx_puffer.d[0])^<=longint_z(@datx_puffer.d[$11])^+4)
        and (Length(exezk)>=Length('READ.ME'))
        and (     (Pos('.',exezk)=0)
               or (Pos('.',exezk)>=(Length(exezk)-3)) )
         then
          begin
            exezk:=puffer_zu_zk_e(datx_puffer.d[4+length(exezk)+1+4],#0,8+1+3);
            if (length(exezk)>5) and (pos('.',exezk)>0) then
              dune_pak
            else
              if longint_z(@datx_puffer.d[$00])^+$11=einzel_laenge then (* sonst A86.LIB *)
                maxis_archiv (* Einzeldatei *)
              else
                if longint_z(@datx_puffer.d[$00])^+$11*2<einzel_laenge then
                  begin (* mindestens 2 .. *)
                    datei_lesen(datx_tmp_puffer,analyseoff+longint_z(@datx_puffer.d[$00])^+$11,512);
                    exezk:=puffer_zu_zk_e(datx_tmp_puffer.d[4],#0,128);
                    if ist_ohne_steuerzeichen(exezk) and (Length(exezk) in [5..(8+1+3)]) then
                      maxis_archiv
                  end;
            end;
      end;

    if bytesuche(datx_puffer.d[1],'MMBuilder') then
      mmbuilder(datx_puffer); (* typ_for4 *)

    if trk_erweiterung
    or (ModDGT(einzel_laenge,2352)=0)
    or (ModDGT(einzel_laenge,2048)=0) (* surfeu: Hybrid Mac/PC *)
     then
       versuche_iso9660;

    if hersteller_gefunden then goto datx_fertig;

    dat_sigx_teil2(datx_puffer,gross_datx_puffer);

    datx_fertig:

  end; (* dat_sigx *)

procedure dat_sigx_teil2;
  label
    datx_fertig;

  var
    l1                  :longint;
    f1                  :dateigroessetyp;
    datum               :dateigroessetyp;
    asscii              :boolean;
    m1,m2               :byte;
    datx_tmp_puffer     :puffertyp;
    mod4                :string[4];
    w1,w2,w3,w4,w5      :word_norm;

  function puffer_pos_suche_datx_puffer(const suchzk:string;const max:word_norm):word_norm;
    begin
      puffer_pos_suche_datx_puffer:=puffer_pos_suche(datx_puffer,suchzk,max);
    end;

  function puffer_pos_suche_gross_datx_puffer(const suchzk:string;const max:word_norm):word_norm;
    begin
      puffer_pos_suche_gross_datx_puffer:=puffer_pos_suche(gross_datx_puffer,suchzk,max);
    end;

  const
    tagsekunden=24*60*60;

  begin (* dat_sigx_teil2 *)

    if bytesuche(datx_puffer.d[$8],'RSE-Author'#$00#$00) then
      ausschrift('RSE-Author / Reitz Software-Entwicklung',compiler);

    if  bytesuche(datx_puffer.d[$1a],'SYSTRACE')
    and (longint_z(@datx_puffer.d[0])^+$1a=einzel_laenge) then
      ausschrift('OS/2 Trace Spool / IBM',signatur);


    (* Arachne 1.69: 1 byte $FF vor dem RAR-SFX-Teil *)
    w1:=puffer_pos_suche_datx_puffer('MZ',100);
    if w1<>nicht_gefunden then
      if w1<einzel_laenge then
        if  (word_z(@datx_puffer.d[w1+8])^>=$0002)      (* KopflÑnge/16 *)
        and (word_z(@datx_puffer.d[w1+8])^<=$1000)
        and (word_z(@datx_puffer.d[w1+2])^> 0)          (* mod 512 *)
        and (word_z(@datx_puffer.d[w1+2])^<=511)
        and (word_z(@datx_puffer.d[w1+4])^>=1)          (* p512 *)
        and (word_z(@datx_puffer.d[w1+4])^<=2048)
         then
          begin
            einzel_laenge:=w1;
          end;


    if  bytesuche(datx_puffer.d[$08],'00')
    and bytesuche(datx_puffer.d[$10],'00')
    and bytesuche(datx_puffer.d[$30],#$00#$00#$00#$00#$00#$00)
     then
      knowledge_hex;

    if ((einzel_laenge=1602) and bytesuche(datx_puffer.d[0],#17#06))
    or ((einzel_laenge=2367) and bytesuche(datx_puffer.d[0],#17#09))
     then
      award_logo(datx_puffer);

    if  (einzel_laenge>1000) then
      begin
        l1:=m_longint(datx_puffer.d[0])+m_longint(datx_puffer.d[4]);
        if (einzel_laenge>=l1) and (einzel_laenge<=l1+2000) then
          begin
            if bytesuche(datx_puffer.d[8],'DPL2')
            or bytesuche(datx_puffer.d[8],'CGDC')
             then (* "DigitalPaper" *)
              ausschrift('Common Ground / No Hands Software; Hummingbird Communicatios Ltd.',musik_bild);
              (* 1.00 No Hands Software *)
          end;
      end;

    if bytesuche(datx_puffer.d[$14],'GPAT') then
      begin
        l1:=m_longint(datx_puffer.d[0]);
        if (l1<einzel_laenge) and (l1>$14+1) then
          begin
            bild_format_filter('GIMP pattern',
                             m_longint(datx_puffer.d[8]),
                             m_longint(datx_puffer.d[$c]),
                             -1,-1,false,true,anstrich);
            ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(datx_puffer.d[$14+4],#0,255)),beschreibung,absatz);
          end;
      end;

    if bytesuche(datx_puffer.d[$14],'GIMP') then
      begin
        l1:=m_longint(datx_puffer.d[0]);
        if (l1<einzel_laenge) and (l1>$1c) then
          begin
            bild_format_filter('GIMP brush',
                             m_longint(datx_puffer.d[8]),
                             m_longint(datx_puffer.d[$c]),
                             -1,-1,false,true,anstrich);
            ausschrift_x(in_doppelten_anfuerungszeichen(puffer_zu_zk_e(datx_puffer.d[$1c],#0,255)),beschreibung,absatz);
          end;
      end;

(*
    with datx_puffer do
      if  (d[0]*d[1]*(15)+$48-1215=einzel_laenge)
      and (d[0] in [ 6.. 9])
      and (d[1] in [17..31])
       then
        award_logo(datx_puffer);*)

    if  (einzel_laenge>=1588+1152-1)
    and (einzel_laenge<64*1024)
    and bytesuche(datx_puffer.d[$1f0],#$00#$00#$00#$00)
     then
      begin

        datei_lesen(datx_tmp_puffer,analyseoff+$600,20);
        w2:=0;
        for w1:=0 to 10-1 do
          if datx_tmp_puffer.d[w1] in [0..30,$ff] then
            inc(w2);

        if w2=10 then
          begin
            w1:=(DGT_zu_longint(einzel_laenge)-1588) mod 1152;
            if (w1=0) or (w1=1152-1) then
              ausschrift('HSC / Hannes Seifert Composer (NEO) | HSC-Tracker / CHiCKEN',musik_bild);
          end;
      end;




    if bytesuche(datx_puffer.d[4],'0?:'#$0a'1') then
      with datx_puffer do
        if d[5] in [Ord('A')..Ord('Z')] then
          begin
            exezk:=puffer_zu_zk_zeilenende(d[9],255);
            if  (d[9+Length(exezk)]=$0a)
            and (d[10+Length(exezk)] in [Ord('1')..Ord('2')]) then
              ausschrift('FileCommander Directory Tree ('+puffer_zu_zk_l(d[5],2)+')',signatur);
          end;


    (* AMD: CONQUEROR AMUSIC11.ZIP *)
    if  (datx_puffer.d[$17]=0)
    and (datx_puffer.d[$2f]=0)
    and bytesuche__datei_lesen(analyseoff+$426,'<o'#$ef'QU'#$ee'RoR')
     then
      begin
        ausschrift('Adlib Module Format / Steffen Kiefer',musik_bild);
        ausschrift(puffer_zu_zk_e(datx_puffer.d[$00],#0,$17)+' / '
                  +puffer_zu_zk_e(datx_puffer.d[$18],#0,$17),beschreibung);
      end;

    if bytesuche(datx_puffer.d[$1b8],#$04#$00'TTYCRLF'#$00) then
      ausschrift('MultiMate / ? [3.3,4.0,ADV]',musik_bild);

    if ((DGT_zu_longint(einzel_laenge) and 255)=0) (* mod 256 *)
    and (einzel_laenge>= 8*256)    (* div 256 *)
    and (einzel_laenge<=32*256)    (* div 256 *)
     then
      zeichensatz;

    if bytesuche(datx_puffer.d[$3c],'TEXtREAd')
    and (datx_puffer.d[$1f]=0) then
      ausschrift('makeDOC (PalmPilot) '+in_doppelten_anfuerungszeichen(puffer_zu_zk_e(datx_puffer.d[0],#0,32)),musik_bild);



    if bytesuche(datx_puffer.d[2],#$00#$00'?????..\..') then
      begin
        origin_tre(word_z(@datx_puffer.d[0])^);
        goto datx_fertig;
      end;


    if (datx_puffer.d[1]=0) and (datx_puffer.d[0]>0) and ($16*longint(datx_puffer.d[0])+2=longint_z(@datx_puffer.d[$13])^) then
      goblins_stk(word_z(@datx_puffer.d[0])^);

    if bytesuche(datx_puffer.d[4],#$11#$11) and (longint(word_z(@datx_puffer.d[6])^)*$1000=einzel_laenge) then
      ausschrift(textz_datx__Reperaturdaten_zu_ARJ^,packer_dat);

    w1:=puffer_pos_suche_datx_puffer('FiLeStArTfIlEsTaRt',500);
    if w1<>nicht_gefunden then
      begin
        binscii(w1);
        goto datx_fertig;
      end;

    w1:=puffer_pos_suche_datx_puffer('Nice-Install.',500);
    if w1<>nicht_gefunden then
      begin
        ausschrift(textz_datx__Zusatzdaten^+'Nice-Install / Data Way Systems',packer_dat);
        f1:=datei_pos_suche(analyseoff,analyseoff+$2000,'NI');
        if f1<>nicht_gefunden then
          einzel_laenge:=f1-analyseoff;
      end;

    if bytesuche(datx_puffer.d[$80],'EK.8') then
      ausschrift('Anti Virial Pro (Lite) / Eugene Kaspersky [3+, '
       +str_(word_z(@datx_puffer.d[$98])^,4)+'.' (* Jahr  *)
       +str_(datx_puffer.d[$9a],2)+'.'           (* Monat *)
       +str_(datx_puffer.d[$9e],2)               (* tag   *)
       +']',bibliothek);

    (* OS/2 4.0: D:\LANGUAGE\CODEPAGE\* *)
    if bytesuche(datx_puffer.d[4],#$ff#$fe#$02#$00'ucv') then
      begin
        w1:=$60;
        while datx_puffer.d[w1]<>0 do inc(w1);
        inc(w1);
        ausschrift('IBM codepage: "'
                  +puffer_zu_zk_e(datx_puffer.d[$10],#0,16)
                  +' '
                  +puffer_zu_zk_e(datx_puffer.d[w1],#0,80)+'"',bibliothek);
      end;


    if bytesuche(datx_puffer.d[4],#$20#$00#$00#$00#$ff#$ff'??'#$ff#$ff'??'#$00#$00#$00#$00) then
      if (word_z(@datx_puffer.d[$14])^ and ($ffff-$1070)=0)
      and (longint_z(@datx_puffer.d[0])^<einzel_laenge) then
        resource_datei_w32;

    (* format.com  windows 0.98 *)
    if bytesuche(datx_puffer.d[8],#$00'??NS')
    and (datx_puffer.d[$4] in [Ord('A')..Ord('Z')])
    and (datx_puffer.d[$5] in [Ord('A')..Ord('Z')])
    and (datx_puffer.d[$6] in [Ord('A')..Ord('Z')])
    and (datx_puffer.d[$d] in [Ord('A')..Ord('Z')])
    and (datx_puffer.d[$e] in [Ord('A')..Ord('Z')]) then
      begin
        ausschrift(puffer_zu_zk_l(datx_puffer.d[$d],2)+': '+puffer_zu_zk_l(datx_puffer.d[4],3)+' '
          +str0(word_z(@datx_puffer.d[9])^),bibliothek);
        einzel_laenge:=4+word_z(@datx_puffer.d[0])^+7;
      end;


    (* Klang ***********************************************************)

    if bytesuche(datx_puffer.d[$22],'MUWFD') then
      ausschrift('Ultratracker WaveSample "'+puffer_zu_zk_e(datx_puffer.d[0],#$1a,32)+'"',musik_bild);

    (* Schrift *********************************************************)

    if bytesuche(datx_puffer.d[$39],#$00'?'#$00'?'#$00#$55#$55#$55#$55#$00) then
      begin
        if datx_puffer.d[2]=0 then
          exezk:=''
        else
          exezk:=textz_datx__Hoehe_doppelpunkt^+str_(datx_puffer.d[2],3);
        ausschrift('GEM Font "'+puffer_zu_zk_e(datx_puffer.d[4],#0,20)+'"'+exezk,musik_bild);
        goto datx_fertig;
      end;

    if bytesuche(datx_puffer.d[2],#$00#$00#$08#$00'????'#$00#$00) then
      if  (word_z(@datx_puffer.d[0])^=word_z(@datx_puffer.d[8])^)
      and (3<word_z(@datx_puffer.d[6])^)   (* Anzahl EintrÑge *)
      and (word_z(@datx_puffer.d[6])^<300) (* 3..300 *)
      and (word_z(@datx_puffer.d[6])^*4<=word_z(@datx_puffer.d[0])^)
       then
        viotbl_dcp(datx_puffer);

    (* 4.0 oder ?.?? *)
    if  bytesuche(datx_puffer.d[4],'Version ?.??   (C)')
    and (longint_z(@datx_puffer.d[0])^<einzel_laenge)
    and (longint_z(@datx_puffer.d[0])^>$61+1*1251) then
     keyboard_dcp(datx_puffer);


    (* Icon ************************************************************)

    if (einzel_laenge=22*42) then
      text_gic_icon;

    w1:=puffer_pos_suche_datx_puffer('/* Format_version=?, Width=',100);
    if w1<>nicht_gefunden then
      ausschrift('Sun Icon',musik_bild);

    w1:=puffer_pos_suche_datx_puffer('#define ',40);
    if w1<>nicht_gefunden then
      begin
        w1:=puffer_pos_suche_datx_puffer('_width ',80);
        if w1<>nicht_gefunden then
          begin
            w1:=puffer_pos_suche_datx_puffer('_chars_per_pixel ',180);
            if w1<>nicht_gefunden then
              ausschrift('Sun Icon C-Code XPM',musik_bild)
            else
              begin
                w1:=puffer_pos_suche_datx_puffer('_height ',100);
                if w1<>nicht_gefunden then
                  ausschrift('Sun Icon C-Code XBM',musik_bild);
              end;
            goto datx_fertig;
          end;
      end;

    (* Filme ***********************************************************)

    w1:=word_z(@datx_puffer.d[0])^;
    w2:=word_z(@datx_puffer.d[2])^;
    if ((w1 mod $11)=0) and (w1+2=w2) then
      begin
        w1:=w1 div $11;
        if (w1>=2) and (w1<=1000) then (* war vorher 6..40 *)
          grasp(w1);
      end;

    if puffer_pos_suche_datx_puffer('59JP???'#$00,80)<>nicht_gefunden then
      (* ausschrift('Quicktime / Apple',musik_bild); ?? *)
      ausschrift('Projector / Macromedia',musik_bild);



    if  bytesuche(datx_puffer.d[$4],#$00#$00#$7f#$00'??'#$10#$00'????'+'??'#$00(* #$01,#$02 .. *))
    and (bytesuche(datx_puffer.d[$a4],'(C)') or bytesuche(datx_puffer.d[$a4],'Copyr'))
     then
      begin
        ausschrift('TBSCAN.DEF "'+puffer_zu_zk_l(datx_puffer.d[$124],24)+'"'
        +version100(datx_puffer.d[$11]*100+datx_puffer.d[$10]),signatur);
      end;

    if (datx_puffer.d[1]=ord('L')) and (datx_puffer.d[0] in [1..7]) then
      begin
        if datx_puffer.d[0] in [1,3] then w1:=1 else w1:=2;
        if datx_puffer.d[0]>4 then w1:=w1*80 else w1:=w1*40;
        w2:=puffer_anzahl_suche(datx_puffer,'L',w1+4);
        w3:=puffer_anzahl_suche(datx_puffer,'˙',w1+4);
        if datx_puffer.d[w1]=0 then exezk:=textz_datx__unkomprimiert^ else exezk:=textz_datx__kompimiert^;
        if w2+w3>=w1 then
          ausschrift('CisCopy / Klaus Holtorf ['+exezk+']',signatur);
      end;

    if (datx_puffer.d[0] in [0..3]) and (datx_puffer.d[$a2] in [$eb,$e9]) and (word_z(@datx_puffer.d[$a2+$0b])^=512) then
      begin
        ausschrift('Kopf DDUMP.EXE',signatur);
        blocktext(datx_puffer,2,4,40);
        einzel_laenge:=$a2;
      end;

    if  (analyseoff>0)
    and (longint_z(@datx_puffer.d[4])^+8=einzel_laenge)
    and (word_z(@datx_puffer.d[2])^*80>einzel_laenge)
    and (word_z(@datx_puffer.d[2])^*20<einzel_laenge)
     then
      (* TURBOTXT 5.00 *)
      ausschrift('TurboTxt / Hyperware, '+str0(word_z(@datx_puffer.d[2])^)+textz_datx__Zeilen^,compiler);

    if bytesuche(datx_puffer.d[1],' RGH-PROFAN? DATEI'#$1a) then
      profan(datx_puffer,1);

    if bytesuche(datx_puffer.d[2],'ACFG') then
      (* ICU: ESCD.RF *)
      ausschrift(textz_datx__Konfigurationsdatei^+'Intel ISA Configuration Util',signatur);

    w1:=puffer_pos_suche_datx_puffer('AS'#$02,12);
    if (w1>=0) and (w1<=10) then
      begin
        ausschrift(textz_datx__Kopf^+' Disk eXPress / Albert J. Shan  '
        +str0(datx_puffer.d[w1+5])+'.'+str0(datx_puffer.d[w1+4] div 16),packer_dat);
         einzel_laenge:=w1+$200;
        blocktext(datx_puffer,w1+$134,5,40);
      end;


    if bytesuche(datx_puffer.d[$8],#$00#$00#$00#$00'?'#$00#$00#$00) then
      if bytesuche(gross_datx_puffer.d[$10],'PATH:')
      or bytesuche(gross_datx_puffer.d[$10],'XREF:')
      or bytesuche(gross_datx_puffer.d[$10],'NEWSGROUPS:')
      or bytesuche(gross_datx_puffer.d[$10],'FROM:')
      or bytesuche(gross_datx_puffer.d[$10],'MESSAGE-ID:') then
        pronews;

    if bytesuche(datx_puffer.d[$70],'Copyright (C) Footprint') then
      ausschrift(textz_datx__Textdatei^+' OS/2 Works / Footprint Software',musik_bild);

    if bytesuche(datx_puffer.d[$00],'??'#$00#$08) and
       bytesuche(datx_puffer.d[$3c],#$00#$00#$1f#$0f) then
      ausschrift('Paradox / Borland '+textz_datx__Datenbank^+str0(datx_puffer.d[$21])+textz_datx__Felder^
       +str0(datx_puffer.d[$06])+textz_datx__Saetze^,signatur);

    if bytesuche(datx_puffer.d[5],'HOLMES SAVE') then
      ausschrift('Holmes / Electronic Arts',spielstand);

    if bytesuche(datx_puffer.d[$A],'VFS') then
      ausschrift('Virtual File System '+textz_datx__Daten^+' / Lone Ranger/ACME',packer_dat);

    if bytesuche(datx_puffer.d[4],'BM') and (einzel_laenge>$20) then
      if longint_z(@datx_puffer.d[0])^+4=einzel_laenge then
        begin
          ausschrift('_1_Ole10Native bmp?',packer_dat);
          befehl_schnitt(analyseoff+4,einzel_laenge-4,erzeuge_neuen_dateinamen('.bmp'));
          einzel_laenge:=4;
          Exit;
        end;

    if (puffer_pos_suche_datx_puffer(#$1b'[',10)<>nicht_gefunden) then
      begin
        dec(herstellersuche);
        ausschrift('ANSI '+textz_datx__Grafik^+' ..',musik_bild);
        if einzel_laenge<20000 then
          ansi_anzeige(analyseoff,#0#0#0,$07,vorne,falsch,wahr,unendlich,'');
        inc(herstellersuche);
      end;

    if bytesuche(datx_puffer.d[1],'NB0') then
      codeview(datx_puffer,1,anstrich);
    if bytesuche(datx_puffer.d[2],'NB0') then
      codeview(datx_puffer,2,anstrich);

    if einzel_laenge=71667 then
      ausschrift('Battle Island 2 / Blue Byte',spielstand);

    if not textdatei then
      if bytesuche(datx_puffer.d[0],'?Cry') then
        begin
          exezk:=puffer_zu_zk_l(datx_puffer.d[5],12);
          exezk:=in_doppelten_anfuerungszeichen(exezk);
          if datx_puffer.d[5]>=1 then
            exezk_anhaengen(textz_datx__eckauf_Hochsicherheit_eckzu^);
          ausschrift('Cry '+exezk+' / Sven Winnecke '+str0(datx_puffer.d[0] div (4*8))+'.'+str0((datx_puffer.d[0] div 4) mod 8)
            +' test8087='+str0(datx_puffer.d[0] mod 4),packer_dat);
        end;


    w1:=puffer_pos_suche_datx_puffer('HMI',$100);

    if w1<>nicht_gefunden then
      if hmi_386 then
        begin
          hmi_archiv;
          {w2:=w1;
          while (w1>0) and (datx_puffer.d[w1]<>$e9) do
            dec(w1);
          if (w1>=$30) and (datx_puffer.d[w1]=$e9) then
            begin
              exezk:=puffer_zu_zk_e(datx_puffer.d[w1-$30],#0,512-w1);

              ausschrift(textz_datx__Kopf^+' HMI '+textz_datx__Treiber^+' [386] '
               +in_doppelten_anfuerungszeichen(exezk),bibliothek);
              ansi_anzeige(analyseoff+w2,#$1a,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
               ,absatz,falsch,wahr,unendlich,'');
              l1:=longint_z(@datx_puffer.d[w1-$c])^+$30;
              if l1+44<>einzel_laenge then
                einzel_laenge:=l1;
              befehl_schnitt(analyseoff+$30,einzel_laenge-$30,exezk);
            end;}
        end
      else
        begin
          w2:=w1;
          while (w1>0) and (datx_puffer.d[w1]<>$e9) do
            dec(w1);
          if (w1>=$16) and (datx_puffer.d[w1]=$e9) then
            begin
              ausschrift(textz_datx__Kopf^+' HMI '+textz_datx__Treiber^+' "'
               +puffer_zu_zk_e(datx_puffer.d[w1-$16],#0,512-w1)+'"',bibliothek);
              ansi_anzeige(analyseoff+w2,#$1a,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf]
               ,absatz,falsch,wahr,unendlich,'');
              l1:=longint_z(@datx_puffer.d[w1-$8])^-$1e;
              if l1+$1e<>einzel_laenge then
                einzel_laenge:=l1;
            end;
        end;

    if not hersteller_gefunden then
      begin
        (*
        w1:=puffer_pos_suche_anfang(gross_datx_puffer,'UNIT ',$1c0);
        if w1<>nicht_gefunden then
          begin
            exezk:=puffer_zu_zk_e(datx_puffer.d[w1+5],';',512-w1-5);
            if ist_ohne_steuerzeichen(exezk) then
              ausschrift('Pascal Unit "'+exezk+'"',signatur);
          end;*)
        if puffer_gefunden(gross_datx_puffer,'UNIT ') then
          pascal_quelle; (* Pascal Unit *)
      end;

    if not hersteller_gefunden then
      begin
        (*
        w1:=puffer_pos_suche_anfang(gross_datx_puffer,'LIBRARY ',$1c0);
        if w1<>nicht_gefunden then
          begin
            exezk:=puffer_zu_zk_e(datx_puffer.d[w1+8],';',512-w1-5);
            if ist_ohne_steuerzeichen(exezk) then
              ausschrift('Pascal Library "'+exezk+'"',signatur);
          end; *)
        if puffer_gefunden(gross_datx_puffer,'LIBRARY ') then
          pascal_quelle; (* Pascal Library *)
      end;

    if not hersteller_gefunden then
      begin
        (*
        w1:=puffer_pos_suche_anfang(gross_datx_puffer,'PROGRAM ',$1c0);
        if w1<>nicht_gefunden then
          begin
            exezk:=puffer_zu_zk_e(datx_puffer.d[w1+8],';',512-w1-8);
            if pos('(',exezk)>0 then
              exezk[0]:=chr(pos('(',exezk));

            if ist_ohne_steuerzeichen(exezk) and (pos(' ',exezk)=0) then
              ausschrift('Pascal '+textz_datx__Programm^+' "'+exezk+'"',signatur);
          end;*)
        if puffer_gefunden(gross_datx_puffer,'PROGRAM ') then
          pascal_quelle; (* Pascal Programm *)
      end;


    if not hersteller_gefunden then
      begin
        w1:=puffer_pos_suche_anfang(datx_puffer,'MODULE ',$1c0);
        if w1<>nicht_gefunden then
          begin
            exezk:=puffer_zu_zk_e(datx_puffer.d[w1+7],';',512-w1-7);
            if ist_ohne_steuerzeichen(exezk) then
              if (puffer_anzahl_suche(datx_puffer,'DEFINITION MODULE ',$1c0)>0) then
                ausschrift('Modula 2 '+textz_Modul^+'-'+textz_datx__Schnittstelle^+' "'+exezk+'"',signatur)
              else
                if (puffer_anzahl_suche(datx_puffer,'IMPLEMENTATION MODULE ',$1c0)>0) then
                  ausschrift('Modula 2 '+textz_Modul^+'-'+textz_datx__Implementierung^+' "'+exezk+'"',signatur)
                else
                  ausschrift('Modula 2 '+textz_datx__Programm^+' "'+exezk+'"',signatur);
          end;
      end;

    if not hersteller_gefunden then
      begin
        w1:=puffer_pos_suche(gross_datx_puffer,'USES ',$1c0);
        if (w1<>nicht_gefunden) then
          begin
            exezk:=puffer_zu_zk_e(datx_puffer.d[w1+5],';',512-w1-5);
            if ist_ohne_steuerzeichen(exezk) then
              ausschrift('Pascal '+textz_datx__Quelltext^,signatur);
          end;
      end;

    if not hersteller_gefunden then
      begin
        w1:=puffer_pos_suche_datx_puffer('#include ',$1c0);
        w2:=puffer_pos_suche_datx_puffer('#include<',$1c0);
        if (w1<>nicht_gefunden)
        or (w2<>nicht_gefunden)
         then
          c_kommentar;
      end;

    if (not hersteller_gefunden) and (not file_id_diz_datei) then
      begin
        w1:=puffer_zeilen_anfang_suche_pos(gross_datx_puffer,'TITLE ');
        if w1=nicht_gefunden then
        w1:=puffer_zeilen_anfang_suche_pos(gross_datx_puffer,'TITLE'#$09);
        if (w1<>nicht_gefunden) and (w1<$1c0) then
          begin
            inc(w1,length('TITLE '));
            suche_wortanfang(datx_puffer,w1);
            ausschrift('Assembler-'+textz_datx__Quelltext^+' "'
             +puffer_zu_zk_zeilenende2(datx_puffer,w1,80)+'"',beschreibung);
            goto datx_fertig;
          end;

        w1:=puffer_pos_suche_anfang(gross_datx_puffer,'ASSUME ',$1c0);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche_anfang(gross_datx_puffer,'SEGMENT ',$1c0);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche_anfang(gross_datx_puffer,'MACRO ',$1c0);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche_anfang(gross_datx_puffer,'PUSH ',$1c0);
        if w1=nicht_gefunden then
          w1:=puffer_pos_suche_anfang(gross_datx_puffer,'.MODEL ',$1c0);

        (* EXECON 2.5 TC2  "Push ESC" *)
        if bytesuche(datx_puffer.d[0],'BWT') then
          w1:=nicht_gefunden;

        if w1<>nicht_gefunden then
          begin
            ausschrift('Assembler-'+textz_datx__Quelltext^,signatur);
            goto datx_fertig;
          end;

      end;

    if not hersteller_gefunden then
      begin
        w1:=puffer_pos_suche_anfang(gross_datx_puffer,'ORG',$1c0);
        if (w1<>nicht_gefunden) and (datx_puffer.d[w1+3] in [ord(' '),ord(^i)])
        and ((w1=0) or (chr(datx_puffer.d[w1-1]) in [#9,#10,#13,' '])) then
          begin
            ausschrift('Assembler '+textz_datx__Quelltext^,signatur);
            goto datx_fertig;
          end;
      end;

    if not hersteller_gefunden then
      begin
        w1:=puffer_pos_suche_gross_datx_puffer('0 REM ',40);
        w2:=puffer_pos_suche_gross_datx_puffer('DECLARE FUNCTION',40);
        if (w1<>nicht_gefunden) then
          ausschrift('Basic '+textz_datx__Quelltext^,signatur)
        else
          if (w2<>nicht_gefunden)
           then
            ausschrift('QBasic '+textz_datx__Quelltext^,signatur)
      end;

    if bytesuche(datx_puffer.d[$83],#$89#$af#$c4) then
      ausschrift('Cheat '+textz_datx__Tabelle^+' Game Wizard / Ray Hsu + Gerald Ryckman',spielstand);

    (* Dateizeit *)
    datum:=ziffer_tar(8,puffer_zu_zk_l(datx_puffer.d[$88],12));
    (* 1980 .. 2030 *)
    if (tagsekunden*365*10<=datum) and (datum<=tagsekunden*365*60)
    (* and (bytesuche(datx_puffer.d[$6a],' '#0) or bytesuche(datx_puffer.d[$6a],'0'#0)) *)
    (* :problem mit xaccel... (DISKEXPRESS Datei) *)
    and (datx_puffer.d[$6a+1]=0)
    and (  (datx_puffer.d[$6a] in [ord(' '),ord('0')..ord('9')])
         or bytesuche(datx_puffer.d[$9c],'V'#$00)) (* tar -cvf 1.tar --label NAME UUDF.DLL *)

     then
      begin
        if bytesuche(datx_puffer.d[$101],'ustar')
        or bytesuche(datx_puffer.d[$101],'GNUtar')
        or bytesuche(datx_puffer.d[$101],#0#0#0#0) then
          tar(analyseoff);
      end;

    if bytesuche(datx_puffer.d[$0c],'WPCMNFMT') then
      (* unformatierte Daten zur Ablaufverfolgung/ *.itf *)
      ausschrift('IBM OS/2 tracefmt',bibliothek);

    if bytesuche(datx_puffer.d[$2c],'SCRM') then
      scream_tracer_3(datx_puffer);

    if bytesuche(datx_puffer.d[$14],'!Scream!') then
      scream_tracer_2(datx_puffer);

    if bytesuche(datx_puffer.d[$14],'BMOD2STM') then
      (* vermutlich nicht "_2" *)
      scream_tracer_2(datx_puffer);

    if bytesuche(datx_puffer.d[1],#$90#$C8#$37) then
      ausschrift(textz_datx__Lernprogramm^+' [WORKS] '+textz_datx__Daten^,musik_bild);

    if (einzel_laenge=4007) and bytesuche(datx_puffer.d[$50],'MBL2') then
      ausschrift('Kyrandia 2 (HOF) / Westwood "'+puffer_zu_zk_e(datx_puffer.d[0],#0,255)+'"',spielstand);

    if bytesuche(datx_puffer.d[$28],'War1') then
      ausschrift('Warcraft / Blizzard "'+puffer_zu_zk_e(datx_puffer.d[0],#0,255)+'"',spielstand);

    if bytesuche(datx_puffer.d[$189],#$01#$3e#$05#$00#$64) then
      exx(datx_puffer);

    if bytesuche(datx_puffer.d[$e6],#$01#$00#$FF#$19#$50)
    or bytesuche(datx_puffer.d[$e6],#$04#$00#$FF#$19#$50)
     then
      begin
        ausschrift(textz_datx__Programminformationen_zu_anf^
                  +leer_filter(puffer_zu_zk_l(datx_puffer.d[2],$1e))
                  +'"',beschreibung);
      end;

    if bytesuche(datx_puffer.d[0],'?AR7 e-') then
      ausschrift('AR7 / Timothy R. Erickson',packer_dat);

    if puffer_pos_suche_datx_puffer(#$dc#$a7#$c4#$fd,30)<>nicht_gefunden then
      zoo;

    if bytesuche(datx_puffer.d[0],'??'#$60#$EA) then
      (* in 'RJSX' *)
      begin
        arj(2,true,word_z(@datx_puffer.d[0])^);
        goto datx_fertig;
      end;

    if bytesuche(datx_puffer.d[6],#$60#$EA) then
      (* OS/2 2.61 Beta *)
      begin
        arj(6,true,word_z(@datx_puffer.d[0])^);
        goto datx_fertig;
      end;

    w1:=puffer_pos_suche(datx_puffer,#$60#$ea'????????'#$02,80);
    if w1<>nicht_gefunden then
      if word_z(@datx_puffer.d[w1+2])^<=2600 then
        begin
          arj(w1,not true,0);
          goto datx_fertig;
        end;

    w1:=puffer_pos_suche(datx_puffer,'Rar!'#$1a,200);
    if w1<>nicht_gefunden then
      einzel_laenge:=w1;

    if bytesuche(datx_puffer.d[2],'-lh?-') then
      lzh(0,lha_variante(datx_puffer,0));

    if bytesuche(datx_puffer.d[2],'-sw?-') then
      lzh(0,lha_variante(datx_puffer,0));

    if bytesuche(datx_puffer.d[2+1],'-lh?-') then
      lzh(1,lha_variante(datx_puffer,1));

    if bytesuche(datx_puffer.d[2+2],'-lh?-') then
      lzh(2,lha_variante(datx_puffer,2));

    if bytesuche(datx_puffer.d[2+4],'-lh?-') then
      (* PSETUP *)
      lzh(4,lha_variante(datx_puffer,4));

    if bytesuche(datx_puffer.d[2],'-TK?-') then
      lzh(0,'TKP / ? T. Haukamp');

    if bytesuche(datx_puffer.d[2],' LH? ') then
      lzh(0,'SAR / Streamline Design [1.0, 99,9% Lha]');

    if bytesuche(datx_puffer.d[2],'-lz?-') then
      lzh(0,'LArc / K.Miki, H.Okumura, K.Masuyama');

    if bytesuche(datx_puffer.d[2],'-lZ?-') then
      lzh(0,'PUT / Microfox');

    if bytesuche(datx_puffer.d[2],'-LD?-') then
      lzh(0,'LDIFF / Kazuhiko MIKI [1.20]');

    if bytesuche(datx_puffer.d[2],'-???-') then
      if chr(datx_puffer.d[5]) in ['0'..'9'] then
        begin
          if bytesuche(datx_puffer.d[3],'hf') then
            lzh(0,'generic Huffman / MAN   Haruhiko Okumura');
          if bytesuche(datx_puffer.d[3],'ah') then
            lzh(0,'adaptive Huffman / MAN   Haruhiko Okumura');
        end
      else
        begin
          if bytesuche(datx_puffer.d[3],'ari') then
            lzh(0,'arithmetic / MAN   Haruhiko Okumura');
          if bytesuche(datx_puffer.d[3],'arn') then
            lzh(0,'arithmetic N / MAN   Haruhiko Okumura');
          if bytesuche(datx_puffer.d[3],'lzs') then
            lzh(0,'LZS / MAN   Haruhiko Okumura');
          if bytesuche(datx_puffer.d[3],'lzw') then
            lzh(0,'LZW / MAN   Haruhiko Okumura');
        end;

    if (datx_puffer.d[$15]=01) and bytesuche(datx_puffer.d[$20],#$00 (* #$12#$12 *) ) and (einzel_laenge=46891)
     and (datx_puffer.d[$21]=datx_puffer.d[$22]) then
      ausschrift('Eye of The Beholder II / SSI "'+puffer_zu_zk_e(datx_puffer.d[0],#0,255)+'"',spielstand);

    if bytesuche(datx_puffer.d[0],#0#0#0#$14#0#0#$f) and (einzel_laenge=28254) then
      ausschrift('Alone in the Dark / INFOGRAMES',spielstand);

    if  (einzel_laenge<128000*31+80000)
    and (einzel_laenge>20+15*30+4000)
    and (datx_puffer.d[20-1] in [0,Ord(' ')..$ff]) (* Ende der Zeichenkette *)

    and (datx_puffer.d[20+0*30+22+2+1-1  ]< $10) (* Finetune $00..$0f      *)
    and (datx_puffer.d[20+0*30+22+2+1+1-1]<=$40) (* Sample Volume $00..$40 *)

    and (datx_puffer.d[20+1*30+22+2+1-1  ]< $10) (* Finetune $00..$0f      *)
    and (datx_puffer.d[20+1*30+22+2+1+1-1]<=$40) (* Sample Volume $00..$40 *)

    and (datx_puffer.d[20+2*30+22+2+1-1  ]< $10) (* Finetune $00..$0f      *)
    and (datx_puffer.d[20+2*30+22+2+1+1-1]<=$40) (* Sample Volume $00..$40 *)

     then
      begin

        exezk:=puffer_zu_zk_e(datx_puffer.d[0],#0,20);

        if ist_ohne_steuerzeichen_nicht_so_streng(exezk) then
          begin
            exezk:=leer_filter(exezk);

            datei_lesen(datx_tmp_puffer,analyseoff+$438,4); (* 20+30*31+130 *)

            (*$IfDef MK___1*)
            if bytesuche(datx_tmp_puffer.d,'M.K.')
            or bytesuche(datx_tmp_puffer.d,'M!K!') (* Protracker >64 Seiten *)
            or bytesuche(datx_tmp_puffer.d,'M&K!') (* XMP2.EXE *)
            or bytesuche(datx_tmp_puffer.d,'N.T.') (* XMP2.EXE *)
            or bytesuche(datx_tmp_puffer.d,'FLT4') (* Startrekker 4 KanÑle *)
            or bytesuche(datx_tmp_puffer.d,'FLT8')
            or bytesuche(datx_tmp_puffer.d,'4CHN')
            or bytesuche(datx_tmp_puffer.d,'6CHN')
            or bytesuche(datx_tmp_puffer.d,'8CHN')
            or bytesuche(datx_tmp_puffer.d,'1?CH')
            or bytesuche(datx_tmp_puffer.d,'2?CH')
            or bytesuche(datx_tmp_puffer.d,'3?CH')
            or bytesuche(datx_tmp_puffer.d,'CD81') (* XMP2.EXE *)
            or bytesuche(datx_tmp_puffer.d,'OCTA') (* MikMod2.exe*)
            or bytesuche(datx_tmp_puffer.d,'EXO4') (* StraTrekker 4 KanÑle *)
            or bytesuche(datx_tmp_puffer.d,'EXO8') (* StraTrekker 8 KanÑle *)
            or bytesuche(datx_tmp_puffer.d,'NSMS') (* ? (Alexx) *)
            or bytesuche(datx_tmp_puffer.d,'M&K&') (* ? (Alexx) *)
            (*$Else*)
            mod4:=puffer_zu_zk_l(datx_tmp_puffer.d,4);
            if ((Pos(mod4,'M.K.'+'M!K!'+'M&K!'+'N.T.'+'FLT4'+'FLT8'+'CD81'+'OCTA'+'EXO4'+'EXO8'+'NSMS'+'M&K&') and 3)=1)
            or ((mod4[1] in ['1'..'3']) and bytesuche(mod4[3],'CH'))
            or ((mod4[1] in ['4','6','8']) and bytesuche(mod4[2],'CHN'))
            (*$EndIf*)
             then
               begin
                 ausschrift('Mod "'+exezk+'" ['+puffer_zu_zk_l(datx_tmp_puffer.d,4)+']',musik_bild);
                 if langformat then
                   mod_anzeige(true);
               end
            else
              if (datx_puffer.d[$1d6] in [(*0*)1..$80]) (* Anzahl Seiten *)
              and (datx_puffer.d[$1d7]=Ord('x'))
               then
                begin
                  ausschrift('Mod "'+exezk+'" [<=15 Instr.]',musik_bild);
                  if langformat then
                    mod_anzeige(false);
                end;

          end;
      end;

    (*alt:
    if bytesuche(datx_puffer.d[$1d5],#$01'?x') then
      ausschrift('Mod "'+puffer_zu_zk_e(datx_puffer.d[0],#0,255)+'" [<=15 Instr.]',musik_bild);*)


    if bytesuche(datx_puffer.d[7],'Stronghold S') then
      begin
        ausschrift('Stronghold / SSI',spielstand);
        datx_puffer.d[0]:=0;
      end;

    if bytesuche(datx_puffer.d[$20],#0#0#0#0#0#0#0#0#$0B'???'#$90) then
      begin
        exezk:='';
        b1:=0;
        while datx_puffer.d[b1]>=32 do
          begin
            exezk_anhaengen(chr(datx_puffer.d[b1]));
            inc(b1);
          end;
        ausschrift('Monkey Island I / Lucas Arts "'+exezk+'"',spielstand);
      end;

    if bytesuche(datx_puffer.d[$28],#$1B#$15#$62#$00#$90) then
      begin
        exezk:='';
        b1:=0;
        while datx_puffer.d[b1]>=32 do
          begin
            exezk_anhaengen(chr(datx_puffer.d[b1]));
            inc(b1);
          end;
        ausschrift('Monkey Island II / Lucas Arts "'+exezk+'"',spielstand);
      end;


    if bytesuche(datx_puffer.d[7],#$4E#$DB#$04#$01) and (einzel_laenge=59000) then
      ausschrift('Master of Orion / SSI',spielstand);

    if bytesuche(datx_puffer.d[$1e],#$55#$00#$00#$00#$01) and (einzel_laenge=28247) then
      ausschrift('Syndicate / Bullfrog',spielstand);

    if bytesuche(datx_puffer.d[65],'CITYMCRP') then
      ausschrift('Simcity / Maxis "'+puffer_zu_zk_e(datx_puffer.d[2],#0,255)+'"',spielstand);

    if bytesuche(datx_puffer.d[$14],#$0A#$00#$14#$00#$28#$00) and (einzel_laenge=41670) then
      ausschrift('Reunion / Grandslam "'+puffer_zu_zk_pstr(datx_puffer.d[0])+'"',spielstand);

    if not hersteller_gefunden then
      begin
        (* Konflik mit Reunion *)
        if bytesuche(datx_puffer.d[0],#4) and (puffer_anzahl_suche(datx_puffer,'--',20)>0) then
          ausschrift('Magic Carpet / Bullfrog ['+puffer_zu_zk_e(datx_puffer.d[4],'--',255)+']',spielstand);
      end;


    if bytesuche(datx_puffer.d[$18],'version 106'#0#0#0#0) then
      begin
        exezk:='';
        b1:=0;
        while datx_puffer.d[b1]>=32 do
          begin
            exezk_anhaengen(chr(datx_puffer.d[b1]));
            inc(b1);
          end;
        ausschrift('Doom2 / id Software "'+exezk+'"',spielstand);
      end;

    if (einzel_laenge=7168) and bytesuche(datx_puffer.d[2],#$FF#$FE) then
      (* 2 Minuten ... ausreichend? *)
      ausschrift('Zak Mc Kracken '+textz_datx__oder^+' Maniac Mansion / Lucas Film',spielstand);

    if bytesuche(datx_puffer.d[2],'SpidyAnim') then
      ausschrift('SpidyGfx Animation [Reunion]',musik_bild);

    if bytesuche(datx_puffer.d[$F0],#$7f#$f0#$ff#$FF#$7f#$f0#$ff#$FF) then
      ausschrift('Indy 4 / Lucas Arts',spielstand);

    if bytesuche(datx_puffer.d[1],'PK')
    and (datx_puffer.d[3]+1=(datx_puffer.d[4])) then
      zip(analyseoff+1,true,kein_art_prg_code);

    (* PKL3211.EXE b8 00 cd 00 'PK' 09 0a ... *)
    if bytesuche(datx_puffer.d[4],'PK'#$09#$0a) then
      einzel_laenge:=4;

    if bytesuche(datx_puffer.d[$e],'YC') then
      yac;

    if bytesuche(datx_puffer.d[8],'JPI?'#$1A) then
      begin
        ausschrift(textz_datx__Hilfe^+'Jensen & Partners I. [Modula-2]',bibliothek);
        datx_puffer.d[0]:=0;
      end;

    (* Y:\vpsrc2\compiler\vp\asm\vhelp.def.. *)
    with datx_puffer do
    if bytesuche(d[3],#$00#$00#$00#$00)
    and (d[0]<>0)
    and (integer_z(@d[1])^<>0) then
      begin
        l1:=Abs(integer_z(@d[1])^);
        if bytesuche__datei_lesen(analyseoff+1+2+d[0]*4+l1*(1+2),#$69#$19#$04#$19) then
          begin
            if integer_z(@d[1])^<0 then
              exezk:=', compressed'
            else
              exezk:='';
            ausschrift('Virtual Pascal Helpfile, '+str0(d[0])+' file(s), '+str0(l1)+' topic(s)'+exezk,bibliothek);
          end;
      end;

    if (einzel_laenge=37912) and (datx_puffer.d[2]<>0) and (datx_puffer.d[3]=0) and bytesuche(datx_puffer.d[$1b],'  '#$00) then
      begin
        ausschrift('Civilisation / Microprose "'
                  +(puffer_zu_zk_e(datx_puffer.d[$10+$0E*datx_puffer.d[2]],#$00,255))
                  +'"',spielstand);
      end;

    if bytesuche(datx_puffer.d[0],'??'#$FF#$FE#$FF#$FF#$5F#$FF) then
      ausschrift('Loom / Lucas Film',spielstand);

    if (word_z(@datx_puffer.d[0])^=einzel_laenge) and bytesuche(datx_puffer.d[7],#$E0'???'#$E0'???'#$E0'???'#$E0'???') then
      begin
        datei_lesen(datx_tmp_puffer,dateilaenge-33,33);
        exezk:='';
        b1:=0;
        while (b1<=33) and (datx_tmp_puffer.d[b1]>31) do
          begin
            exezk_anhaengen(chr(datx_tmp_puffer.d[b1]));
            inc(b1);
          end;
        ausschrift('Privateer / ORIGIN "'+exezk+'"',spielstand);
      end;


    if hersteller_gefunden then
      goto datx_fertig;

    l1:=puffer_pos_suche(datx_puffer,'-lh?-',100); (* touchstone .TII Diskimage setup (checkit 7..) *)
    if (l1<>nicht_gefunden) and (l1>2) then
      (* lzh(l1,lha_variante(datx_puffer,l1));*)
      einzel_laenge:=l1-2;

    w1:=puffer_pos_suche_datx_puffer('#B1: ',500); (* DLH___ *)
    if w1<>nicht_gefunden then
      begin
        ausschrift('HT-System / ??? "'
                  +leer_filter(puffer_zu_zk_e(datx_puffer.d[w1+5],#$0a,512-w1-5))
                  +'"',musik_bild);
      end;

    if longint_z(@datx_puffer.d[0])^=einzel_laenge then
      begin
        if bytesuche(datx_puffer.d[4],#$11#$af) then
          ausschrift('FLI / Autodesk Animator '
           +str0(word_z(@datx_puffer.d[6])^)+textz_datx__leer_Bilder_leer^
           +str0(word_z(@datx_puffer.d[8])^)+' * '
           +str0(word_z(@datx_puffer.d[10])^)+textz_datx__in_oder_mit^
           +str0(1 shl longint(word_z(@datx_puffer.d[12])^))+textz_datx__Farben^
           ,musik_bild);
        if bytesuche(datx_puffer.d[4],#$12#$af) then
          ausschrift('FLC / Autodesk Animator Pro '
           +str0(word_z(@datx_puffer.d[6])^)+textz_datx__leer_Bilder_leer^
           +str0(word_z(@datx_puffer.d[8])^)+' * '
           +str0(word_z(@datx_puffer.d[10])^)+textz_datx__in_oder_mit^
           +str0(1 shl longint(word_z(@datx_puffer.d[12])^))+textz_datx__Farben^
           ,musik_bild);
      end;

    if bytesuche(datx_puffer.d[$28],'SYSTEM BIOS') then
      begin
        ausschrift(textz_datx__Kopf^+' INTEL BIOS-Update "'+puffer_zu_zk_e(datx_puffer.d[0],#0,255)+'"',signatur);
        einzel_laenge:=$80;
      end;

    if bytesuche(datx_puffer.d[$28],'System BIOS') then
      begin (* neuer? *)
        ausschrift(textz_datx__Kopf^+' INTEL BIOS-Update "'+puffer_zu_zk_e(datx_puffer.d[0],#0,255)+'"',signatur);
        einzel_laenge:=$a0;
      end;

    with datx_puffer do
      if  (d[$0] in [$18,$20,$2e])
      and (d[$2] in [$18,$20,$2e])
      and ((d[$e] in [8,9]) or (d[$a] in [8,9]))
      and ((d[$1]=d[$c]) or (d[$1]=d[$b]))
      and (einzel_laenge>=word_z(@d[0])^) then
        viotbl_dcp_block(datx_puffer);


{
    w1:=puffer_pos_suche_datx_puffer('!PS-AdobeFont',50);
    if w1=nicht_gefunden then
      w1:=puffer_pos_suche_datx_puffer('!FontType',50);
    if w1<>nicht_gefunden then
      begin
        (*ausschrift('Postscriptfont "'+puffer_zu_zk_zeilenende(datx_puffer.d[w1+$1a-7],512-w1-$1a)+'" [OS/2]',musik_bild);*)
        ausschrift('Postscript Printer Binary Font "'
          +puffer_zu_zk_zeilenende(datx_puffer.d[w1+$1a-7],512-w1-$1a)+'"',musik_bild);
      end
    else
      begin
        w1:=puffer_pos_suche_datx_puffer('!PS-Adobe',50);
        if w1<>nicht_gefunden then
          begin
            exezk:=puffer_zu_zk_zeilenende(datx_puffer.d[w1+10],512-w1-10);

            ausschrift('Postscript / Adobe ['+exezk+']',musik_bild);

            w1:=puffer_pos_suche_datx_puffer('%Title:',400);
            if w1<>nicht_gefunden then
              begin
                exezk:=puffer_zu_zk_zeilenende(datx_puffer.d[w1+7],512-w1-7);
                ausschrift(textz_datx__Titel_doppelpunkt^+exezk,musik_bild);
              end;

            w1:=puffer_pos_suche_datx_puffer('%Creator:',400);
            if w1<>nicht_gefunden then
              begin
                exezk:=puffer_zu_zk_zeilenende(datx_puffer.d[w1+9],512-w1-9);
                ausschrift(textz_datx__Erzeuger_doppelpunkt^+exezk,musik_bild);
              end;
          end; (* !PS-Adobe *)
      end;  (* !FontType *)}

    (* E:\PSFONTS\SYMB.PFB *)
    if bytesuche(datx_puffer.d[6],'%!PS-AdobeFont') then
      postscript('Postscript Printer Binary Font',datx_puffer,6,true)
    else
      begin
        w1:=puffer_pos_suche_datx_puffer('!PS-Adobe',50);
        if w1<>nicht_gefunden then
          postscript('Postscript / Adobe',datx_puffer,w1,false);
      end;  (* %!PS-AdobeFont *)


    if bytesuche(datx_puffer.d[2],#0#0'SPFP') then
      (* #$c8#$00=200 -> ?.??  OS/2 *)
      (* #$04#$01=260 -> 2.11 DOS *)
      ausschrift('Unit Pascal Compiler Lite / TMT Development Corporation',compiler);

    if (puffer_pos_suche_datx_puffer('(c) 19',130+180)<>nicht_gefunden)
    and (puffer_pos_suche_datx_puffer('P.Fischer-',150+180)<>nicht_gefunden) then
      ausschrift('TXT2EXE / P.Fischer-Haaser [4.00,4.01]',compiler);

    if  ((DGT_zu_longint(einzel_laenge) mod (40+1))=7)
    and (einzel_laenge>=(40+1)*20)
    and (einzel_laenge<=(40+1)*24)
    and (datx_puffer.d[7+40] in [1..3])
    and (datx_puffer.d[2] in [20..24])
    and ((datx_puffer.d[0] mod $10)<=9)
     then
      prestel;

    if not hersteller_gefunden then
      begin
        w1:=puffer_anzahl_suche(gross_datx_puffer,#$0d#$0a'(*',512);
        w2:=puffer_anzahl_suche(gross_datx_puffer,#$0d#$0a'{' ,512);
        w3:=puffer_anzahl_suche(gross_datx_puffer,'*)'#$0d#$0a,512);
        w4:=puffer_anzahl_suche(gross_datx_puffer, '}'#$0d#$0a,512);
        w5:=puffer_anzahl_suche(gross_datx_puffer,#$0d#$0a'//',512);
        if ((w1>4) and (w3>4)) or ((w2>4) and (w4>4)) or (w4>5) then
          p_kommentar;
      end;

    if hersteller_gefunden or file_id_diz_datei then
      goto datx_fertig;

    if textdatei and (einzel_laenge<20000) then
      begin
        probiere_sfv;
        if hersteller_gefunden then
          goto datx_fertig;
      end;

    if textdatei and (einzel_laenge<1000000) then
      begin
        (* cdrecord.exe > xxx *)
        if bytesuche(gross_datx_puffer.d[0],'USAGE: ') then
          begin
            exezk:=puffer_zu_zk_zeilenende(datx_puffer.d[0],255);
            exezk:=in_doppelten_anfuerungszeichen(leer_filter(exezk));
            if (Length(exezk)>=Length('Usage: x')) and (Length(exezk)<128) then
              ausschrift(exezk,beschreibung);
          end;
        if hersteller_gefunden then
          goto datx_fertig;

        (* lynx: CHANGES *)
        if puffer_gefunden(datx_puffer,'============') then
          probiere_readme_ueberschrift(datx_puffer,'=');
        (* v.k: amideco.deu *)
        if puffer_gefunden(datx_puffer,'') then
          probiere_readme_ueberschrift(datx_puffer,'');
        (* ohne Beispiel *)
        if puffer_gefunden(datx_puffer,'------------') then
          probiere_readme_ueberschrift(datx_puffer,'-');
        if hersteller_gefunden then
          goto datx_fertig;

        if Chr(datx_puffer.d[0]) in [' ',#9,'<',';',#$0d,#$0a] then
          begin
            versuche_tmf;
            if hersteller_gefunden then
              goto datx_fertig;
          end;

        if puffer_gefunden(datx_puffer,'~~~~~'#$0d#$0a#$0d#$0a) then
          begin
            probiere_readme_ueberschrift_unterstrichen(datx_puffer,'~');
            if hersteller_gefunden then
              goto datx_fertig;
          end;

      end; (* textdatei and (einzel_laenge<1000000) *)

    w1:=puffer_anzahl_suche(datx_puffer,'@X',512);
    if w1>8 then
      begin (* PCBOARD *)
        ansi_anzeige(analyseoff,#0,ftab.f[farblos,hf]+ftab.f[farblos,vf],
          vorne,falsch,wahr,analyseoff+einzel_laenge,'');
        goto datx_fertig;
      end;

    if not (datx_puffer.d[0] in [$e8,$e9,$eb]) then
      begin
        w1:=0; (* Anzahl $0a    *)
        w2:=0; (* Anzahl $0d$0a *)
        w4:=0; (* Anzahl $0a$0a *)

        fehler:=datx_puffer.g;
        if fehler>0 then
          dec(fehler);

        for w3:=1 to fehler do
          begin
            if datx_puffer.d[w3]<8 then
              begin
                w1:=0;
                w2:=0;
                w4:=0;
                break;
              end;

            if datx_puffer.d[w3]=$0a then
              begin
                inc(w1);
                if datx_puffer.d[w3-1]=$0d then
                  inc(w2);
                if datx_puffer.d[w3-1]=$0a then
                  inc(w4);
              end;
          end;

        if (w1>=6) and ((w2=0) or (w4>0)) then
          begin
            (* PGP-Text im UNIX-Textformat? *)
            ende_suche(analyseoff+einzel_laenge);
            if not hersteller_gefunden then
              ausschrift(textz_datx__Textdatei_ohne_chr_klammer_13_klammer^,signatur);
          end;
      end;

    if hersteller_gefunden then
      goto datx_fertig;

    (* DISK.ID (Installshield) 'DML'#$0d#$0a *)
    if (einzel_laenge>=3+2)and (einzel_laenge<10) then
      if bytesuche(datx_puffer.d[DGT_zu_longint(einzel_laenge)-2],#$0d#$0a) then
        begin
          exezk:=puffer_zu_zk_l(datx_puffer.d[0],DGT_zu_longint(einzel_laenge)-2);
          if ist_ohne_steuerzeichen_nicht_so_streng(exezk) then
            begin
              Ausschrift('"'+exezk+'"',Beschreibung);
              Goto datx_fertig;
            end;
        end;

    exezk:='';
    asscii:=wahr;
    b1:=0;

    m1:=datx_puffer.d[1];
    m2:=datx_puffer.d[2];

    if datx_puffer.d[0]=$eb then
      begin
        b1:=2;
        datx_puffer.d[1]:=0; (* Kein ESC *)
      end;

    if datx_puffer.d[0]=$e9 then
      begin
        b1:=3;
        datx_puffer.d[1]:=0; (* Kein ESC *)
        datx_puffer.d[2]:=0;
      end;


    w1:=puffer_pos_suche_datx_puffer(#$1a,$90);
    (* $90 fÅr tbsacn.eci *)
    if (w1<>nicht_gefunden) and (w1>b1+7) then
      begin
        asscii:=wahr;
        dec(w1);

        while (w1>b1+7) and (datx_puffer.d[w1] in [$00,$0a,$0d]) do
          dec(w1);

        for w2:=b1 to w1 do
          if not (chr(datx_puffer.d[w2]) in [' ','A'..'Z','a'..'z','é','ô','ö','˙',
           'Ñ','î','Å','·','-','0'..'9','/','\',':','!','.',',','(',')',#7,'&',#10,#13,'˛','$','*','+','@','#']) then
            begin
              asscii:=falsch;
              break;
            end;

        (* OS/2 MDOS COMMAND.COM *)
        if asscii and (w2-b1<128) and bytesuche__datei_lesen(analyseoff+b1,#$0d'@#') then
          begin
            Inc(b1);
            ausschrift_modulbeschreibung(datei_lesen__zu_zk_l(analyseoff+b1,w1-b1+1));
            asscii:=false;
          end;

        if asscii then
          begin
            dec(herstellersuche);
            ansi_anzeige(analyseoff+b1,'$',ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
              absatz,falsch,wahr,analyseoff+w1+1,'');
            inc(herstellersuche);
          end;
      end;

    datx_puffer.d[1]:=m1;
    datx_puffer.d[2]:=m2;


    datx_fertig:
  end;

end.

