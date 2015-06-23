(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_for5;

interface

uses
  typ_type;

procedure jfcp;
procedure archivarius_bh(const p:puffertyp);
procedure versuche_ext2fs;
procedure vbox;
procedure rmf_realnetworks;
procedure kingston_qdata;
procedure modul_669;
procedure epic_exe_installation(sichtbar:boolean);
procedure apogee_raptor;
procedure swc(const p:puffertyp);
procedure id_archiv;
procedure digiwrap;
procedure ydkj4_flash_archiv;
procedure wenshots_file;
procedure ealib;
procedure ndba;
procedure herosoft(const p:puffertyp);
procedure fead_optimizer;
procedure installshield_19200(anfang:boolean);
procedure pj10(const p:puffertyp;const namenlaenge:word_norm);
procedure multitracker(const p:puffertyp);
procedure oktasongmod(const p:puffertyp);
procedure ghostinstaller;
procedure ascaron_archive(const p:puffertyp);
procedure winbatch_windowware;
procedure pdata(const o,l:dateigroessetyp);
procedure modules_cs;
procedure par1_Willem_Monsuwe(const p:puffertyp);
procedure par2_Willem_Monsuwe;
procedure intel_itk;
procedure psa(const p:puffertyp);
procedure bluebyte_tct(const p:puffertyp);
procedure windows_hilfedatei(const p:puffertyp);
procedure HtmlHelp_ms;
procedure its_ms(const p:puffertyp);
procedure apple_driver_descriptor;
procedure edi_install(const p:puffertyp);
procedure Super_Retriss_Pro_Install_Utility(const o,l:dateigroessetyp);
procedure clu_eldorado(const p:puffertyp);
procedure ros_bin_archiv;
procedure gdiff(const p:puffertyp);

implementation

uses
  typ_eiau,
  typ_ausg,
  typ_var,
  typ_varx,
  typ_for0,
  typ_spra,
  typ_posm,
  typ_entp,
  typ_dien,
  typ_zeic;

procedure jfcp; (* ocsfxp5a.zip *)
  var
    o                   :longint;
  begin
    ausschrift('Fast Compressor (OCS Self-Extractor) / Jim Moore',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      exezk:=puffer_zu_zk_pstr(form_puffer.d[$13]);
      Inc(o,$14+form_puffer.d[$13]);
      datei_lesen(form_puffer,analyseoff+o,$d);
      laenge_eingepackt:=m_longint(form_puffer.d[0]);
      laenge_ausgepackt:=-1;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      Inc(o,laenge_eingepackt);
    until o+$13>=einzel_laenge;
    archiv_summe;
  end;

procedure archivarius_bh(const p:puffertyp);
  var
    o                   :longint;
  begin
    if p.d[4]<=$25 then Exit;
    if p.d[4]<>$25+longint_z(@p.d[$21])^ then Exit;
    (*ausschrift('archivarius - Bh / Oleg Shashin',packer_dat);*)
    ausschrift('Blak-hole / ?',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      exezk:=puffer_zu_zk_l(form_puffer.d[$25],form_puffer.d[$21]);
      laenge_eingepackt:=longint_z(@form_puffer.d[$0f])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$13])^;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      Inc(o,word_z(@form_puffer.d[$04])^);
      Inc(o,laenge_eingepackt);
    until (o>=einzel_laenge) or (o<0) or (laenge_eingepackt=0);
    archiv_summe;
  end;

procedure versuche_ext2fs;
  var
    p:puffertyp;
  begin
    datei_lesen(p,analyseoff+1024,512);
    if (word_z(@p.d[$38])^<>$ef53) (* Signatur *)
    or (word_z(@p.d[$3a])^<1) or (word_z(@p.d[$3a])^>2) (* filesystem state *)
    or (word_z(@p.d[$3c])^<1) or (word_z(@p.d[$3c])^>3) (* Fehlerreaktion *)
     then Exit;

    ausschrift('EXT2FS / Godmar Back',packer_dat);
    (*
    if not langformat then Exit;

    Anzeigen? - zu h„álich *)
  end;

procedure vbox;
  var
    l:longint;
  begin
    datei_lesen(form_puffer,analyseoff,512);
    exezk:=puffer_zu_zk_l(form_puffer.d[0],16);
    ausschrift('VBOX / Preview Systems '+in_doppelten_anfuerungszeichen(exezk),packer_dat);

    if bytesuche(form_puffer.d[8],'HEADVBOB') then
      l:=longint_z(@form_puffer.d[$2c])^;
    if bytesuche(form_puffer.d[8],'PBOBHEAD') then
      l:=longint_z(@form_puffer.d[$30])^;

    if (l<einzel_laenge) and (l>0) then
      einzel_laenge:=l;

    if not langformat then Exit;

    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
  end;

procedure rmf_realnetworks;
  var
    o:longint;

  procedure mdpr;
    var
      p,l,i:longint;
    begin
      if not bytesuche__datei_lesen(analyseoff+o+4+4+$20,#$00#$10'logical-fileinfo') then Exit;
      p:=4+4+$20+$22;
      while (p+6<laenge_eingepackt) and (p>0) do
        begin
          datei_lesen(form_puffer,analyseoff+o+p,512);
          ausschrift(puffer_zu_zk_e(form_puffer.d[7],#0,form_puffer.d[6]),beschreibung);
          l:=m_longint(form_puffer.d[0]);
          i:=7+form_puffer.d[6];
          while (i+5<l) and (i>0) do
            begin
              datei_lesen(form_puffer,analyseoff+o+p+i,512);
              ausschrift_x(puffer_zu_zk_e(form_puffer.d[6],#0,form_puffer.d[5]),beschreibung,absatz);
              Inc(i,6+form_puffer.d[5]);
            end;
          Inc(p,l);
        end;
    end;

  procedure cont;
    var
      p:longint;
    begin
      p:=4+4+2;
      while (p<laenge_eingepackt) and (p>0) do
        begin
          datei_lesen(form_puffer,analyseoff+o+p,512);
          if m_word(form_puffer.d[0])<>0 then
            ausschrift_x(puffer_zu_zk_e(form_puffer.d[2],#0,form_puffer.d[1]),beschreibung,absatz);
          Inc(p,2+m_word(form_puffer.d[0]));
        end;
    end;

  begin
    ausschrift('RealMedia / Realnetworks',musik_bild);
    if not langformat then Exit;

    o:=0;
    archiv_start_leise;
    archiv_anzeige_ohne_prozent:=true;
    repeat
      datei_lesen(form_puffer,analyseoff+o,4+4);
      exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,4);
      laenge_eingepackt:=m_longint(form_puffer.d[4]);
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      if exezk='MDPR' then
        mdpr
      else
      if exezk='CONT' then
        cont;
      Inc(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe_leise;
  end;

procedure kingston_qdata;
  var
    anzahl              :longint;
    o,daten             :dateigroessetyp;
  begin
    anzahl:=x_longint__datei_lesen(analyseoff+2);
    if (anzahl<1) or (anzahl>10000) then Exit;
    daten:=x_longint__datei_lesen(analyseoff+6);
    if (daten<$20) or (daten>einzel_laenge) then Exit;
    datei_lesen(form_puffer,analyseoff+daten,2);
    if not bytesuche(form_puffer.d[0],#$00#$06) then Exit;
    ausschrift('Kingston QSTART [PKWare LIB]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=6+4;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      exezk:=puffer_zu_zk_e(form_puffer.d[$14],#$0a,255);
      laenge_eingepackt:=longint_z(@form_puffer.d[$0])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$8])^;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      IncDGT(o,$14+Length(exezk)+1);
      befehl_mkdir_fuer_datei(exezk);
      befehl_ttdecomp(analyseoff+daten,laenge_eingepackt,exezk);
      IncDGT(daten,laenge_eingepackt);
      Dec(anzahl);
    until anzahl=0;
    archiv_summe;
    einzel_laenge:=daten;
  end;

procedure modul_669;
  var
    p:puffertyp;
    w1,pat:word_norm;
    o:longint;
  begin
    datei_lesen(p,analyseoff,512);
    if (p.d[$6e]>64)  (* number of samples *)
    or (p.d[$67]>128) (* number of pattern *)
     then Exit;

    if p.d[0]=Ord('i') then
      ausschrift('669',musik_bild)
    else
      ausschrift('Extended 669',musik_bild);

    for w1:=0 to 2 do
      ausschrift_x(puffer_zu_zk_l(p.d[2+$24*w1],$24),beschreibung,absatz);

    pat:=p.d[$6e];

    archiv_start_leise;
    archiv_anzeige_ohne_prozent:=true;
    o:=$1f1;
    while pat>0 do
      begin
        datei_lesen(p,analyseoff+o,$19);
        exezk:=puffer_zu_zk_e(p.d[0],#0,13);
        laenge_eingepackt:=longint_z(@p.d[13])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Inc(o,$19);
        Dec(pat);
      end;
    archiv_summe_leise;
  end;

procedure epic_exe_installation(sichtbar:boolean);
  var
    o                   :dateigroessetyp;
    anzahl              :word_norm;
  begin
    o:=datei_pos_suche(analyseoff+einzel_laenge-MinDGT(einzel_laenge,$500),analyseoff+einzel_laenge,#$00#$00'CiPE?'#$00);
    if o=nicht_gefunden then Exit;
    IncDGT(o,2);
    anzahl:=x_word__datei_lesen(o+4);
    DecDGT(o,anzahl*$15);

    if sichtbar then
      ausschrift('Install Epic MegaGames [1994:OMF]',packer_dat);
    if not langformat then Exit;

    if sichtbar then
      archiv_start;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,o,$15);
        IncDGT(o,$15);
        Dec(anzahl);
        laenge_eingepackt:=longint_z(@form_puffer.d[$d])^;
        laenge_ausgepackt:=laenge_eingepackt;
        if sichtbar then
          begin
            exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
            archiv_datei;
            archiv_datei_ausschrift(exezk);
            befehl_schnitt(longint_z(@form_puffer.d[$11])^,laenge_eingepackt,exezk);
          end
        else
          begin
            merke_position(longint_z(@form_puffer.d[$11])^,datentyp_unbekannt);
            if anzahl=0 then
              merke_position(longint_z(@form_puffer.d[$11])^+laenge_eingepackt,datentyp_epicinst);
          end;
      end;

    if sichtbar then
      archiv_summe;


  end;

procedure apogee_raptor;
  var
    o,oa,o2,el          :dateigroessetyp;
    p2                  :puffertyp;
  procedure korrigiere_blake(var p:puffertyp);
    var
      w1:word_norm;
    begin
      if p.d[0]=$1a then
        begin
          w1:=puffer_pos_suche(p,'.EXE',1+8+3+1);
          if w1<>nicht_gefunden then
            p.d[0]:=w1+Length('.EXE')-1;
        end;
    end;
  begin (* RAPTOR Ä v1.2 *)
    ausschrift('INSTALL / SubZero Software [2.1 1994] <APOGEE> [PKWARE-LIB]',packer_dat);
    (* die vorhandenen Dateien werden nicht alle angezeigt (ALIEN CARNAGE) *)
    if not langformat then Exit;

    archiv_start;
    o:=analyseoff;
    while o<analyseoff+einzel_laenge do
      begin

        datei_lesen(form_puffer,o,$1f+5);
        korrigiere_blake(form_puffer);
        oa:=o+$1f;
        repeat
          if oa>=analyseoff+einzel_laenge then
            begin
              o2:=analyseoff+einzel_laenge;
              Break;
            end;
          o2:=datei_pos_suche(oa,analyseoff+einzel_laenge,#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0#0);
          if o2=nicht_gefunden then
            begin
              o2:=analyseoff+einzel_laenge;
              Break;
            end;
          oa:=o2+1;
          DecDGT(o2,1+8+1+3);
          datei_lesen(p2,o2,$1f+5);
          korrigiere_blake(p2);
          if (p2.d[0]<3) or (p2.d[0]>8+1+3) then Continue;
          exezk:=puffer_zu_zk_pstr(p2.d[0]);
          if not ist_ohne_steuerzeichen(exezk) then Continue;

          if bytesuche(p2.d[$1f],'MZ')
          or bytesuche(p2.d[$1f],#4'-ID-')
          or bytesuche(p2.d[$1f],#0#4)
          or bytesuche(p2.d[$1f],#0#5)
          or bytesuche(p2.d[$1f],#0#6) then
            Break;
        until false;

        laenge_eingepackt64:=o2-(o+$1f);
        laenge_ausgepackt64:=-1;
        exezk:=puffer_zu_zk_pstr(form_puffer.d[0]);
        archiv_datei;
        archiv_datei_ausschrift(exezk);

        if o=analyseoff then el:=$1f;
        merke_position(o,datentyp_unbekannt);
        merke_position(o2,datentyp_unbekannt);
        if (form_puffer.d[$1f+0]=0) and (form_puffer.d[$1f+1] in [4,5,6]) then
          befehl_ttdecomp(o+$1f,laenge_eingepackt64,exezk)
        else
          befehl_schnitt(o+$1f,laenge_eingepackt64,exezk);
        o:=o2;
      end;

    archiv_summe;
    einzel_laenge:=el;
  end;

procedure swc(const p:puffertyp);
  begin
    ausschrift('Macromedia Flash + Inflate ['+str0(p.d[3])+']',packer_dat);
    exezk:=na+'.swf';
    archiv_start_leise;
    laenge_eingepackt64:=einzel_laenge-8;
    laenge_ausgepackt:=longint_z(@p.d[4])^;
    archiv_datei;
    archiv_datei_ausschrift(exezk);
    befehl_swc(analyseoff+8+2,laenge_eingepackt-2,exezk,p);
    archiv_summe_leise;
  end;

procedure id_archiv;
  var
    o:longint;
  begin
    (* "Alien Carnage" (Formerly called Halloween Harry) *)
    ausschrift('ID? / Animation FX [PKWARE-LIB]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$1a);
      Inc(o,$1a);
      laenge_eingepackt:=longint_z(@form_puffer.d[$12])^;
      laenge_ausgepackt:=longint_z(@form_puffer.d[$16])^;
      exezk:=puffer_zu_zk_pstr(form_puffer.d[$05]);
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      befehl_ttdecomp(analyseoff+o,laenge_eingepackt,exezk);
      Inc(o,laenge_eingepackt);
    until (o<0) or (o>=einzel_laenge);
    archiv_summe;
  end;

procedure digiwrap;
  begin
    ausschrift('DigiWrap / BitArts ['+datei_lesen__zu_zk_l(analyseoff+einzel_laenge-1,1)+'] (BZip2)',packer_dat);
    if not langformat then Exit;
    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
  end;

procedure ydkj4_flash_archiv;
  var
    o,omin:dateigroessetyp;
  begin
    ausschrift('? <YDK4> [inflate]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    omin:=0;
    o:=einzel_laenge-$2be;
    datei_lesen(form_puffer,analyseoff+o,256);
    ausschrift_x(puffer_zu_zk_e(form_puffer.d[0],#0,255),beschreibung,absatz);
    DecDGT(o,$210);
    repeat
      DecDGT(o,$167);
      if o<omin then Break;
      datei_lesen(form_puffer,analyseoff+o,$167);
      if form_puffer.d[0]=0 then Break;
      exezk:=leer_filter(puffer_zu_zk_e(form_puffer.d[0],#0,$40));
      if exezk[Length(exezk)]='_' then exezk[Length(exezk)]:=Chr(form_puffer.d[$4f]);
      laenge_eingepackt:=longint_z(@form_puffer.d[$57])^;
      laenge_ausgepackt:=-1;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      ausschrift_x(puffer_zu_zk_e(form_puffer.d[$40],#0,10),beschreibung,absatz);
      if form_puffer.d[$5b]=0 then
        befehl_schnitt(longint_z(@form_puffer.d[$53])^  ,laenge_eingepackt  ,exezk)
      else
        befehl_e_infla(longint_z(@form_puffer.d[$53])^+2,laenge_eingepackt-2,exezk);
    until o<=0;
    archiv_summe;
  end;

procedure wenshots_file;
  var
    o:dateigroessetyp;
  begin
    ausschrift('Webshots Installation',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$84);
      if not bytesuche(form_puffer.d[0],'!!!!@@@@') then Break;
      IncDGT(o,$84);
      exezk:=puffer_zu_zk_e(form_puffer.d[$44],#0,$40);
      laenge_eingepackt:=longint_z(@form_puffer.d[$40])^;
      laenge_ausgepackt:=laenge_eingepackt;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      befehl_schnitt(analyseoff+o,laenge_eingepackt,exezk);
      IncDGT(o,laenge_eingepackt);
    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure ealib;
  var
    anzahl:word_norm;
    o:longint;
  begin
    anzahl:=x_word__datei_lesen(analyseoff+5);
    if (anzahl>500) or (anzahl<3) then Exit;
    ausschrift('EALIB / Electronic Arts <YEAGER>',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=5+2;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,$12*2);
        Inc(o,$12);
        Dec(anzahl);
        laenge_eingepackt:=longint_z(@form_puffer.d[$12+$e])^
                          -longint_z(@form_puffer.d[    $e])^;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,8+1+3);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+longint_z(@form_puffer.d[$e])^,laenge_eingepackt,exezk);
      end;
    Inc(o,$12);
    IncDGT(archiv_summe_eingepackt,o);
    einzel_laenge:=archiv_summe_eingepackt;
    archiv_summe;
  end;

procedure ndba;
  var
    o,l                 :dateigroessetyp;
    version             :byte;
  begin
    version:=byte__datei_lesen(analyseoff+4);
    ausschrift('no Double Blocks / Peter Wiesneth [inflate] [0.'+str0(version)+'.x]',packer_dat);
    case version of
      2:ausschrift_x(datei_lesen__zu_zk_e(analyseoff+$29,#0,$a0-$29),beschreibung,absatz);
      4:ausschrift_x(datei_lesen__zu_zk_e(analyseoff+$30,#0,$98-$30),beschreibung,absatz);
      6:ausschrift_x(datei_lesen__zu_zk_e(analyseoff+$32,#0,$98-$32),beschreibung,absatz);
    end;
    if not langformat then Exit;
    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$80);
      if bytesuche(form_puffer.d[0],'NDBA') then
        (* Archivkopf *)
        IncDGT(o,$8+word_z(@form_puffer.d[$6])^)
      else
      if bytesuche(form_puffer.d[0],'NDBC') then
        (* chapter *)
        begin
          case version of
            2:ausschrift_x(puffer_zu_zk_e(form_puffer.d[$0e],#0,$20),{packer_dat}beschreibung,absatz);
            4:ausschrift_x(puffer_zu_zk_e(form_puffer.d[$2c],#0,$20),{packer_dat}beschreibung,absatz);
            6:ausschrift_x(puffer_zu_zk_e(form_puffer.d[$32],#0,$20),{packer_dat}beschreibung,absatz);
          end;
          IncDGT(o,8+word_z(@form_puffer.d[$6])^)
        end
      else
      if bytesuche(form_puffer.d[0],'NDBB') then
        (* Dateblock - inflate *)
        begin
          IncDGT(o,12+longint_z(@form_puffer.d[$4])^);
          if version>=6 then
            IncDGT(o,4);
        end
      else
      if bytesuche(form_puffer.d[0],'NDBH') then
        (* header - ? *)
        begin
          IncDGT(o,12+longint_z(@form_puffer.d[$4])^);
          if version>=6 then
            IncDGT(o,4);
        end
      else
      if bytesuche(form_puffer.d[0],'NDBF') then
        (* Dateinamen und Informationen *)
        begin
          IncDGT(o,12);
          if version>=6 then
            IncDGT(o,4);
          l:=longint_z(@form_puffer.d[$4])^;
          case version of
            2:
             while l>=$2c do
               begin
                 datei_lesen(form_puffer,analyseoff+o,512);
                 laenge_ausgepackt:=longint_z(@form_puffer.d[$6])^;
                 laenge_eingepackt:=longint_z(@form_puffer.d[$a])^;
                 exezk:=puffer_zu_zk_l(form_puffer.d[$2c],form_puffer.d[$2a]);
                 archiv_datei;
                 if (form_puffer.d[$1e] and $10)=0 then
                   archiv_datei_ausschrift(exezk)
                 else
                   archiv_datei_ausschrift_verzeichnis(exezk);

                 DecDGT(l,$2c+word_z(@form_puffer.d[$2a])^);
                 IncDGT(o,$2c+word_z(@form_puffer.d[$2a])^);
               end;
            4:
              while l>=$2e do
               begin
                 datei_lesen(form_puffer,analyseoff+o,512);
                 laenge_ausgepackt:=longint_z(@form_puffer.d[$6])^;
                 laenge_eingepackt:=longint_z(@form_puffer.d[$a])^;
                 exezk:=puffer_zu_zk_l(form_puffer.d[$2e],form_puffer.d[$2c]);
                 archiv_datei;
                 if (form_puffer.d[$1e] and $10)=0 then
                   archiv_datei_ausschrift(exezk)
                 else
                   archiv_datei_ausschrift_verzeichnis(exezk);

                 DecDGT(l,$2e+word_z(@form_puffer.d[$2c])^);
                 IncDGT(o,$2e+word_z(@form_puffer.d[$2c])^);
               end;
            6:
              while l>=$44 do
               begin
                 datei_lesen(form_puffer,analyseoff+o,512);
                 laenge_ausgepackt64:=comp_z(@form_puffer.d[$08])^;
                 laenge_eingepackt64:=comp_z(@form_puffer.d[$10])^;
                 exezk:=utf8_zu_zk(puffer_zu_zk_l(form_puffer.d[$44],form_puffer.d[$42]));
                 archiv_datei64;
                 if (form_puffer.d[$34] and $10)=0 then
                   archiv_datei_ausschrift(exezk)
                 else
                   archiv_datei_ausschrift_verzeichnis(exezk);

                 DecDGT(l,$44+word_z(@form_puffer.d[$42])^);
                 IncDGT(o,$44+word_z(@form_puffer.d[$42])^);
               end;

          end;
          IncDGT(o,l); (* +-0 *)
        end

      else
      if bytesuche(form_puffer.d[0],'NDBD') then
        (* data? *)
        begin
          IncDGT(o,12+longint_z(@form_puffer.d[$4])^);
          if version>=6 then
            IncDGT(o,4);
        end

      else
        begin
          ausschrift(str0_DGT(o)+': '+puffer_zu_zk_l(form_puffer.d[0],4)+' ?',dat_fehler);
          Break;
        end;

      o:=AndDGT(o+3,-4);

    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure herosoft(const p:puffertyp);
  var
    o                   :dateigroessetyp;
    anzahl              :longint;
  begin
    ausschrift('<HEROSOFTSOUTHERN>',packer_dat);
    if not langformat then Exit;

    anzahl:=longint_z(@p.d[$10])^;
    o:=$18;
    archiv_start;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,$10);
        IncDGT(o,$10);
        Dec(anzahl);
        exezk:=datei_lesen__zu_zk_e(analyseoff+$10+longint_z(@form_puffer.d[0])^,#0,255);
        laenge_eingepackt:=longint_z(@form_puffer.d[$0c])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[$08])^;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_erzeuge_verzeichnisse_rekursiv(exezk);
        if laenge_eingepackt=laenge_ausgepackt then
          befehl_schnitt(analyseoff+$10+longint_z(@form_puffer.d[4])^  ,laenge_eingepackt  ,exezk)
        else
          befehl_e_infla(analyseoff+$10+longint_z(@form_puffer.d[4])^+2,laenge_eingepackt-2,exezk);
      end;
    archiv_summe;
  end;

procedure fead_optimizer;
  begin
    ausschrift('Netopsystems FEAD Optimizer',packer_dat);
    if not langformat then Exit;

    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
  end;

procedure installshield_19200(anfang:boolean);
  var
    o                   :dateigroessetyp;
    w1                  :word_norm;
  procedure suche_null;
    begin
      repeat
        if w1>=form_puffer.g then Break;
        Inc(w1);
      until form_puffer.d[w1-1]=0;
    end;
  begin (* olxpdfsetup.exe *)
    ausschrift('<ISPNickel-19200> / InstallShield',packer_dat);
    if not langformat then Exit;

    o:=0;
    archiv_start;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      w1:=0;
      (* data1.cab *)
      suche_null;
      (* Disk1\data1.cab *)
      exezk:=puffer_zu_zk_e(form_puffer.d[w1],#0,255);
      suche_null;
      (* 0.0.0.0 *)
      suche_null;
      (* 505194 *)
      laenge_eingepackt64:=val_f(puffer_zu_zk_e(form_puffer.d[w1],#0,20));
      laenge_ausgepackt64:=laenge_eingepackt64;
      suche_null;

      IncDGT(o,w1);
      befehl_mkdir_fuer_datei(exezk);
      if bytesuche__datei_lesen(analyseoff+o,'SZDD') then
        begin
          laenge_ausgepackt:=x_longint__datei_lesen(analyseoff+o+$a);
          befehl_expand_ms(analyseoff+o,laenge_eingepackt64,exezk);
          exezk_leerzeichen_erweiterung(30);
          exezk_anhaengen(' [COMPRESS 2.0/MS]');
        end
      else
        begin
          befehl_schnitt(analyseoff+o,laenge_eingepackt64,exezk);
        end;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      IncDGT(o,laenge_eingepackt64);

    until o>=einzel_laenge;
    archiv_summe;
  end;

procedure pj10(const p:puffertyp;const namenlaenge:word_norm);
  var
    i,anzahl,blocklaenge:longint;
  begin
    ausschrift(Chr(p.d[3])+Chr(p.d[2])+Chr(p.d[1])+Chr(p.d[0])+' / Macromedia',packer_dat);
    if not langformat then Exit;


    if namenlaenge=$100 then (* PJ00 *)
      blocklaenge:=$208
    else (* PJ10 *)
      blocklaenge:=namenlaenge+$34-$21;

    anzahl:=longint_z(@p.d[$10])^;
    archiv_start;
    for i:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+$18+blocklaenge*(i-1),Min(blocklaenge,$200));
        laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk:=puffer_zu_zk_e(form_puffer.d[$08            ],#0,$20)+'.'
              +puffer_zu_zk_e(form_puffer.d[$08+namenlaenge],#0,$04);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(longint_z(@form_puffer.d[0])^,laenge_eingepackt,exezk);
        merke_position(longint_z(@form_puffer.d[0])^,datentyp_unbekannt);
      end;
    archiv_summe;
    einzel_laenge:=$18+(anzahl+1)*blocklaenge;
  end;

procedure multitracker(const p:puffertyp);
  var
    i,anzahl,j:word_norm;
  begin
    ausschrift('MultiTracker '+textz_Modul^+' / Renaissance '#39'93'
        +version_div16_mod16(p.d[3])
        +' "'+puffer_zu_zk_e(p.d[4],#0,20)+'"',musik_bild);
    if not langformat then Exit;

    anzahl:={p.d[$1e]}$1f;
    while (anzahl>0)
     and bytesuche__datei_lesen(analyseoff+$42+(anzahl-1)*$25,#$00)            (* ohne Name *)
     and bytesuche__datei_lesen(analyseoff+$42+(anzahl-1)*$25+$16,#$00#$00) do (* L„nge=0 *)
      Dec(anzahl);


    (* eher geraten ... *)
    archiv_start_leise;
    archiv_anzeige_ohne_prozent:=true;
    for i:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+$42+(i-1)*$25,$25);
        (* 0..$15 Name? $16=Position? $23=L„nge? *)
        laenge_eingepackt:=m_word(form_puffer.d[$16]);
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,$16));
      end;
    archiv_summe_leise;

    (* song message ... *)
  end;

procedure oktasongmod(const p:puffertyp);
  var
    anzahl,i:word_norm;
  begin
    ausschrift('Amiga Oktalyzer',musik_bild);
    if not langformat then Exit;

    (* eher geraten ... *)
    anzahl:=$1f;
    archiv_start_leise;
    archiv_anzeige_ohne_prozent:=true;
    for i:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+i*$20,$20);
        laenge_eingepackt:=m_word(form_puffer.d[$16]);
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(puffer_zu_zk_e(form_puffer.d[0],#0,$16));
      end;
    archiv_summe_leise;
  end;

procedure ghostinstaller;
  var
    xorb:byte;
  begin
    xorb:=byte__datei_lesen(analyseoff) xor Ord('M');
    ausschrift('Ghost Installer / ? [XOR '+hex(xorb)+']',packer_dat);
    if not langformat then Exit;

    archiv_start;
    laenge_eingepackt64:=einzel_laenge-$1a;
    laenge_ausgepackt64:=laenge_eingepackt;
    exezk:=erzeuge_neuen_dateinamen('.cab');
    archiv_datei;
    archiv_datei_ausschrift(exezk);
    befehl_xor(analyseoff,laenge_eingepackt64,exezk,xorb);
    archiv_summe;
  end;

procedure ascaron_archive(const p:puffertyp);
  var
    anzahl:longint;
    o:dateigroessetyp;
  begin
    (* Sacred: 'ASCARON_ARCHIVE V0.9' *)
    ausschrift(puffer_zu_zk_e(p.d[0],#0,$20),packer_dat);
    if not langformat then Exit;

    archiv_start;
    anzahl:=longint_z(@p.d[$28])^;
    o:=$30;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,analyseoff+o,12+256);
        laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk:=puffer_zu_zk_e(form_puffer.d[$0c],#0,255);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        IncDGT(o,12+Length(exezk)+1);

        befehl_erzeuge_verzeichnisse_rekursiv(exezk);
        befehl_schnitt(longint_z(@form_puffer.d[0])^,laenge_eingepackt,exezk);
        Dec(anzahl);
      end;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;

  end;

procedure winbatch_windowware;
  var
    anzahl:longint;
    o,d:dateigroessetyp;
  begin
    ausschrift('Winbatch / WindowWare',compiler);
    if not langformat then Exit;

    archiv_start;
    anzahl:=m_longint__datei_lesen(analyseoff+einzel_laenge-8);
    o:=analyseoff+einzel_laenge-(anzahl+1)*$114;
    d:=0;
    while anzahl>0 do
      begin
        datei_lesen(form_puffer,o,$114);
        IncDGT(o,$114);
        Dec(anzahl);
        laenge_ausgepackt:=m_longint(form_puffer.d[$114-$10+0]);
        laenge_eingepackt:=m_longint(form_puffer.d[$114-$10+4]);
        if laenge_eingepackt=0 then
          laenge_eingepackt:=laenge_ausgepackt;
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,255);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        if (d>0) and (laenge_eingepackt>0) then
          begin
            if laenge_eingepackt=laenge_ausgepackt then
              befehl_schnitt(d,laenge_eingepackt,exezk)
            else
              befehl_e_infla(d+2,laenge_eingepackt-2,exezk);
          end;

        IncDGT(d,laenge_eingepackt);

      end;
    archiv_summe;
  end;

procedure pdata(const o,l:dateigroessetyp);
  begin
    datei_lesen(form_puffer,o,512);
    ausschrift('protected program DATA: Autoplay Media Studio / Indigo Rose',packer_dat);

    if not langformat then Exit;

    ausschrift(textz_listfunktion_noch_nicht_implementiert^,signatur);
  end;

procedure modules_cs;
  var
    anzahl,namen_laenge,o_dir,o_name:longint;
  begin
    anzahl      :=m_longint__datei_lesen(analyseoff+einzel_laenge-$34);
    namen_laenge:=m_longint__datei_lesen(analyseoff+einzel_laenge-$30);
    ausschrift('modules.cz/? [gnu-zip]',packer_dat);

    if not langformat then Exit;

    archiv_start;
    o_dir:=DGT_zu_Longint(einzel_laenge)-$40-anzahl*$10;
    o_name:=o_dir-namen_laenge;
    while anzahl>0 do
      begin
        exezk:=datei_lesen__zu_zk_zeilenende(analyseoff+o_name);
        Inc(o_name,Length(exezk)+1);
        datei_lesen(form_puffer,analyseoff+o_dir,$10);
        Inc(o_dir,$10);
        laenge_eingepackt:=-1;
        laenge_ausgepackt:=m_longint(form_puffer.d[$c]);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        Dec(anzahl);
        if m_longint(form_puffer.d[$8])=0 then
          befehl_gnuunzip(m_longint(form_puffer.d[$0]),m_longint(form_puffer.d[$4]),'TMP2.TYP');
        befehl_schnitt2('TMP2.TYP',m_longint(form_puffer.d[$8]),laenge_ausgepackt,exezk);
      end;
    befehl_del('TMP2.TYP');
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;

  end;

procedure par1_Willem_Monsuwe(const p:puffertyp);
  var
    o:dateigroessetyp;
    anzahl:longint;
  begin
    ausschrift('Parity Archive 2 / Willem Monsuwe [volume '+str0(longint_z(@p.d[$30])^)+']',packer_dat);
    if not langformat then Exit;

    archiv_start;
    anzahl:=longint_z(@p.d[$38])^;
    o:=dateigroessetyp_z(@p.d[$40])^;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      laenge_eingepackt64:=-1;
      laenge_ausgepackt64:=dateigroessetyp_z(@form_puffer.d[$10])^;
      exezk:=uc16_puffer_zu_zk_e(form_puffer.d[$38],#0,(longint_z(@form_puffer.d[$0])^-$38) shr 1);
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      IncDGT(o,dateigroessetyp_z(@form_puffer.d[0])^);
      Dec(anzahl);
    until anzahl=0;
    archiv_summe;
  end;

procedure par2_Willem_Monsuwe;
  var
    o:dateigroessetyp;
  begin
    (* http://parchive.sourceforge.net/ *)
    ausschrift('Parity Archive 2 / Willem Monsuwe',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'PAR2'#$00'PKT') then Break;
      laenge_eingepackt64:=dateigroessetyp_z(@form_puffer.d[8])^;
      laenge_ausgepackt64:=laenge_eingepackt64;
      exezk:=puffer_zu_zk_e(form_puffer.d[$30],#0,255);
      exezk_anhaengen(' ');
      exezk_anhaengen(puffer_zu_zk_e(form_puffer.d[$38],#0,8));
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      if bytesuche(form_puffer.d[$38],'Creator'#0) then
        ausschrift_x(puffer_zu_zk_e(form_puffer.d[$40],#0,255),beschreibung,leer)
      else
      if bytesuche(form_puffer.d[$38],'FileDesc') then
        ausschrift_x(puffer_zu_zk_e(form_puffer.d[$78],#0,255),beschreibung,leer);

      IncDGT(o,laenge_eingepackt64);
    until o>=einzel_laenge;
    archiv_summe;
    einzel_laenge:=o;
  end;

procedure intel_itk;
  var
    o:dateigroessetyp;
  begin
    ausschrift('ITK? / Intel',packer_dat);
    if not langformat then Exit;

    o:=analyseoff;
    repeat
      o:=datei_pos_suche(o,analyseoff+einzel_laenge,'$');
      if o=nicht_gefunden then Exit;
      exezk:=datei_lesen__zu_zk_e(o,#0,255);
    until (Length(exezk)>8) and (Length(exezk)<$18);

    archiv_start;
    while (o>=0) and (o<analyseoff+einzel_laenge) do
      begin
        datei_lesen(form_puffer,o,$28);
        exezk:=datei_lesen__zu_zk_e(o,#0,$18);
        laenge_eingepackt:=longint_z(@form_puffer.d[$18])^-$28;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        IncDGT(o,$28);
        if laenge_eingepackt>0 then
          befehl_schnitt(o,laenge_eingepackt,exezk);
        IncDGT(o,laenge_eingepackt);
      end;
    archiv_summe;
  end;

procedure psa(const p:puffertyp);
  var
    o:dateigroessetyp;
  begin
    ausschrift('Pretty Simple Archiver / Serge Pachkovsky [0.91alpha]',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=5;
    repeat
      datei_lesen(form_puffer,analyseoff+o,$200);
      laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
      if bytesuche(form_puffer.d[$16],#0#0#0#0) then
        begin
          laenge_ausgepackt:=longint_z(@form_puffer.d[$e])^;
          exezk:=puffer_zu_zk_l(form_puffer.d[$1e],form_puffer.d[$1c]);
        end
      else
        begin
          laenge_ausgepackt:=-1;
          exezk:='?';
        end;
      archiv_datei;
      archiv_datei_ausschrift(exezk);
      IncDGT(o,laenge_eingepackt);
    until (o>=einzel_laenge) or (laenge_eingepackt<=0);
    archiv_summe;
  end;

procedure bluebyte_tct(const p:puffertyp);
  var
    daten_ende          :longint;
    anzahl,
    i                   :word_norm;
  begin
    daten_ende:=longint_z(@p.d[0])^;
    anzahl:=word_z(@p.d[8])^;
    if daten_ende+anzahl*$c<>einzel_laenge then Exit;

    (* C:\BLUEBYTE\BI2\FGT\fgtexplo.lib *)
    ausschrift('<TCT> / BlueByte',packer_dat);
    if not langformat then Exit;

    archiv_start;
    for i:=1 to anzahl do
      begin
        if i=anzahl then
          begin
            datei_lesen(form_puffer,analyseoff+daten_ende+(i-1)*$c,$c);
            laenge_eingepackt:=daten_ende-longint_z(@form_puffer.d[8])^;
          end
        else
          begin
            datei_lesen(form_puffer,analyseoff+daten_ende+(i-1)*$c,$c*2);
            laenge_eingepackt:=longint_z(@form_puffer.d[8+$c])^
                              -longint_z(@form_puffer.d[8   ])^;
          end;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk:=puffer_zu_zk_e(form_puffer.d[0],#0,8);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+longint_z(@form_puffer.d[8])^,laenge_eingepackt,exezk);
      end;
    archiv_summe;
  end;

procedure windows_hilfedatei(const p:puffertyp);
  var
    btreeheader         :puffertyp;
    pagesize,
    page,
    n_entry             :word_norm;
    o,oo,fo             :Longint;

  procedure system_anzeige(const o,l:longint);
    var
      Minor             :word_norm;
      i,j               :longint;
      zk                :string;
    begin
      datei_lesen(form_puffer,analyseoff+o,2+2+2+4+2);
      i:=2+2+2+4+2;
      if not bytesuche(form_puffer.d[0],#$6c#$03) then Exit;
      Minor:=word_z(@form_puffer.d[2])^;
      if Minor<=16 then
        begin
          ausschrift_x(in_doppelten_anfuerungszeichen(datei_lesen__zu_zk_e(o+i,#0,255)),beschreibung,absatz);
          Exit;
        end;

      while i<l do
        begin
          datei_lesen(form_puffer,analyseoff+o+i,2+2);
          j:=Min(word_z(@form_puffer.d[2])^,l-i-2-2);

          (*
          case word_z(@form_puffer.d[0])^ of
            1: ( * TITLE                * )
            2: ( * COPYRIGHT            * )
            3: ( * CONTENTS             * )
            4: ( * CONFIG               * )
            5: ( * ICON                 * )
            6: ( * WINDOW               * )
            8: ( * CITATION             * )
            9: ( * LCID                 * )
           10: ( * CNT                  * )
           11: ( * CHARSET              * )
           12: ( * DEFFONT,FTINDEX      * )
           13: ( * GROUPS               * )
           14: ( * INDEX_S, KEYINDEX    * )
           18: ( * LANGUAGE             * )
           19: ( * DLLMAPS              * )
          end; *)

          case word_z(@form_puffer.d[0])^ of
            1,2:
            begin
              zk:=datei_lesen__zu_zk_e(o+i+2+2,#0,Min(255,j));
              if zk<>'' then
                ausschrift_x({str0(word_z(@form_puffer.d[0])^)+': '+}in_doppelten_anfuerungszeichen(zk),beschreibung,absatz);
            end;
          end;
          Inc(i,2+2+j);
        end;

    end;

  begin
    ausschrift('MS Windows '+textz_Hilfedatei^+' [LZ77]',bibliothek);
    einzel_laenge:=longint_z(@p.d[$c])^;

    if not langformat then Exit;
    archiv_start;
    o:=longint_z(@p.d[$4])^+4+4+1; (* DirectoryStart *)
    datei_lesen(btreeheader,analyseoff+o,$26);
    if bytesuche(btreeheader.d[0],';)') then
      begin
        pagesize:=word_z(@btreeheader.d[$1e])^;
        for page:=1 to word_z(@btreeheader.d[$1e])^ (* TotalPages *) do
          begin
            oo:=o+$26+(page-1)*pagesize;
            n_entry:=x_word__datei_lesen(analyseoff+oo+2);
            (* Zweig:
                 dw Byte frei am Ende
                 dw Anzahl Eintr„ge
                 dw Vorg„ngerseite
                 (string0+dw,...)
               Blatt:
                 dw Byte frei am Ende
                 dw Anzahl Eintr„ge
                 dw Vorg„ngerseite
                 dw Nachfolgerseite
                 (string0+dd,...) *)

            Inc(oo,2+2+2+2);

            (* nur Blatt-Seiten anzeigen *)
            exezk:=datei_lesen__zu_zk_e(analyseoff+oo,#0,255);
            if (Length(exezk)<3) then Continue;
            if (exezk[1]<' ') or (exezk[1]>=#$7f) then Continue;

            while n_entry>0 do
              begin
                exezk:=datei_lesen__zu_zk_e(analyseoff+oo,#0,255);
                Inc(oo,Length(exezk)+1);
                fo:=x_longint__datei_lesen(oo);
                Inc(oo,4);
                datei_lesen(form_puffer,analyseoff+fo,4+4+1);
                Dec(n_entry);
                laenge_eingepackt:=longint_z(@form_puffer.d[0])^;
                laenge_ausgepackt:=longint_z(@form_puffer.d[4])^;
                archiv_datei;
                archiv_datei_ausschrift(exezk);
                if exezk='|SYSTEM' then
                  system_anzeige(fo+4+4+1,laenge_ausgepackt);

                while Pos('|',exezk)>0 do
                  exezk[Pos('|',exezk)]:='_';
                befehl_rem_zaehler(+1);
                befehl_schnitt(fo+4+4+1,laenge_ausgepackt,erzeuge_kurzen_dateinamen+exezk);
                befehl_rem_zaehler(-1);
              end;
          end;
      end;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe;
  end;

procedure HtmlHelp_ms;
  var
    o           :dateigroessetyp;
    version     :longint;
    blockgroesse:longint;
    anzahlbloecke:longint;
    anzahl      :word_norm;
    j,k         :word_norm;
    section     :longint;
    datenoffset :longint;

  function read_encint:longint;
    var
      v:longint;
      i:word_norm;
    begin
      datei_lesen(form_puffer,analyseoff+o+j,11);
      with form_puffer do
        begin
          d[12]:=0;
          v:=0;
          i:=0;
          repeat
            v:=v shl 7+(d[i] and $7f);
            Inc(i);
            Inc(j);
          until (d[i-1] shr 7)=0;
        end;
      read_encint:=v;
    end;

  begin
    ausschrift('HtmlHelp / MS',bibliothek);
    if not langformat then Exit;

    archiv_start;
    o:=0;
    repeat (* keine wiederholung *)
      datei_lesen(form_puffer,analyseoff+o,$38);
      if not bytesuche(form_puffer.d[0],'ITSF') then
        Break;

      version:=longint_z(@form_puffer.d[4])^;
      IncDGT(o,longint_z(@form_puffer.d[8])^);
      datei_lesen(form_puffer,analyseoff+o,8+8+8);
      laenge_eingepackt64:=dateigroessetyp_z(@form_puffer.d[8])^;
      if version>=3 then
        IncDGT(o,3*8)
      else
        IncDGT(o,2*8);

      datei_lesen(form_puffer,analyseoff+o,$54);
      if not bytesuche(form_puffer.d[0],'ITSP') then
        Break;
      blockgroesse:=longint_z(@form_puffer.d[$10])^;
      anzahlbloecke:=longint_z(@form_puffer.d[$2c])^;
      IncDGT(o,longint_z(@form_puffer.d[8])^);

      while anzahlbloecke>0 do
        begin
          if bytesuche__datei_lesen(analyseoff+o,'PMGL') then
            begin
              anzahl:=x_word__datei_lesen(analyseoff+o+blockgroesse-2);
              j:=$14;
              while anzahl>0 do
                begin
                  Dec(anzahl);
                  datei_lesen(form_puffer,analyseoff+o+j,256);
                  exezk:=utf8_zu_zk(puffer_zu_zk_pstr(form_puffer.d[0]));
                  if exezk<>'' then
                    if exezk[1]='/' then
                      Delete(exezk,1,1);
                  Inc(j,1+form_puffer.d[0]);
                  section:=read_encint;
                  datenoffset:=read_encint;
                  laenge_ausgepackt:=read_encint;

                  (* gepackte Daten nicht anzeigen *)
                  if not ((Length(exezk)>2) and (exezk[1]=':') and (exezk[2]=':')) then
                    begin

                      if section=0 then
                        laenge_eingepackt:=laenge_ausgepackt
                      else
                        laenge_eingepackt:=-1;
                      if ((laenge_ausgepackt<>0) or (exezk<>'')) then
                        begin
                          archiv_datei;
                          if (laenge_ausgepackt=0) and (exezk[Length(exezk)] in ['\','/']) then
                            archiv_datei_ausschrift_verzeichnis(exezk)
                          else
                            archiv_datei_ausschrift(exezk);
                        end;

                    end;

                  if (exezk='#SYSTEM') and (laenge_eingepackt=laenge_ausgepackt) then
                    begin
                      k:=$c;
                      while (k>=$c) and (k<laenge_eingepackt) do
                        begin
                          datei_lesen(form_puffer,analyseoff+o+blockgroesse*anzahlbloecke+datenoffset+k,512);
                          case word_z(@form_puffer.d[0])^ of
                            3:ausschrift_x(
                              in_doppelten_anfuerungszeichen(
                                cp1004_zu_zk(
                                  puffer_zu_zk_e(
                                    form_puffer.d[4],#0,Min(255,word_z(@form_puffer.d[2])^)))),beschreibung,leer);
                          end;
                          Inc(k,2+2+word_z(@form_puffer.d[2])^);
                        end;
                    end;
                end;
            end;
          IncDGT(o,blockgroesse);
          Dec(anzahlbloecke);
        end;

    until true;
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;
  end;

procedure its_ms(const p:puffertyp);

  procedure ifcm_anzeige(o0,l:dateigroessetyp);
    var
      o                 :dateigroessetyp;
      blockgroesse      :longint;
      anzahlbloecke     :longint;
      anzahl            :word_norm;
      j,k               :word_norm;
      section           :longint;
      datenoffset       :longint;


    function read_encint:longint;
      var
        v:longint;
        i:word_norm;
      begin
        datei_lesen(form_puffer,analyseoff+o+j,11);
        with form_puffer do
          begin
            d[12]:=0;
            v:=0;
            i:=0;
            repeat
              v:=v shl 7+(d[i] and $7f);
              Inc(i);
              Inc(j);
            until (d[i-1] shr 7)=0;
          end;
        read_encint:=v;
      end;

    begin
      o:=o0+$20;
      blockgroesse:=x_longint__datei_lesen(o0+8);
      anzahlbloecke:=x_longint__datei_lesen(o0+$18);
      while anzahlbloecke>0 do
        begin
          anzahl:=x_word__datei_lesen(analyseoff+o+blockgroesse-2);
          j:=$30;
          while anzahl>0 do
            begin
              Dec(anzahl);
              datei_lesen(form_puffer,analyseoff+o+j,256);
              exezk:=utf8_zu_zk(puffer_zu_zk_pstr(form_puffer.d[0]));
              if exezk<>'' then
                if exezk[1]='/' then
                  Delete(exezk,1,1);
              Inc(j,1+form_puffer.d[0]);
              section:=read_encint;
              datenoffset:=read_encint;
              laenge_ausgepackt:=read_encint;

              (* gepackte Daten nicht anzeigen *)
              if not ((Length(exezk)>2) and (exezk[1]=':') and (exezk[2]=':')) then
                begin

                  if section=0 then
                    laenge_eingepackt:=laenge_ausgepackt
                  else
                    laenge_eingepackt:=-1;
                  if ((laenge_ausgepackt<>0) or (exezk<>'')) then
                    begin
                      archiv_datei;
                      if (laenge_ausgepackt=0) and (exezk[Length(exezk)] in ['\','/']) then
                        archiv_datei_ausschrift_verzeichnis(exezk)
                      else
                        archiv_datei_ausschrift(exezk);
                    end;

                end;
            end;
          Dec(anzahlbloecke);
          IncDGT(o,blockgroesse);
        end;
    end;

  begin
    ausschrift('Internet Document Set / MS',packer_dat);
    if not langformat then Exit;

    einzel_laenge:=x_dateigroessetyp__datei_lesen(analyseoff+dateigroessetyp_z(@p.d[$28])^+8);
    archiv_start;
    ifcm_anzeige(dateigroessetyp_z(@p.d[$38])^,dateigroessetyp_z(@p.d[$40])^);
  (*ifcm_anzeige(comp_z(@p.d[$48])^,comp_z(@p.d[$50])^);*)
    archiv_summe_eingepackt:=einzel_laenge;
    archiv_summe_eingepackt_unbekannt:=false;
    archiv_summe;

  end;

procedure apple_driver_descriptor;
  var
    o,d:dateigroessetyp;
    blockgroesse:longint;
  begin
    ausschrift('Apple driver descriptor',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=m_word__datei_lesen(analyseoff+2);
    repeat
      datei_lesen(form_puffer,analyseoff+o,512);
      if not bytesuche(form_puffer.d[0],'PM') then Break;
      ausschrift_x(puffer_zu_zk_e(form_puffer.d[$10],#0,$20),beschreibung,leer);
      blockgroesse:=512;(*m_longint(form_puffer.d[$08])*$100??*);
      laenge_eingepackt64:=m_longint(form_puffer.d[$0c])*blockgroesse;
      laenge_ausgepackt64:=laenge_eingepackt64;
      d:=m_longint(form_puffer.d[$08])*blockgroesse;
      exezk:=puffer_zu_zk_e(form_puffer.d[$30],#0,$24);
      archiv_datei64;
      archiv_datei_ausschrift(exezk);
      befehl_schnitt(d,analyseoff+laenge_eingepackt64,exezk);
      (* SURFEU/MediaMarkt HFS Teil liegt auáerhalb des ISO9660-Bereiches *)
      if laenge_eingepackt64>8*1024 then
        begin
          merke_position(analyseoff+d                    ,datentyp_unbekannt);
          merke_position(analyseoff+d+laenge_eingepackt64,datentyp_unbekannt);
        end;
      IncDGT(o,512);
    until o>=einzel_laenge;
    archiv_summe;

  end;

procedure edi_install(const p:puffertyp);
  begin
    ausschrift('EDI Install Pro / Robert Salesas ['+puffer_zu_zk_l(p.d[3],4+1)+']',packer_dat);
    if not langformat then Exit;

    archiv_start_leise;
    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=longint_z(@p.d[$15])^;
    archiv_datei64;
    archiv_datei_ausschrift(puffer_zu_zk_e(p.d[8],#0,8+1+3));
    archiv_summe_leise;
  end;

procedure Super_Retriss_Pro_Install_Utility(const o,l:dateigroessetyp);
  var
    p                   :puffertyp;
    anzahl,z            :word_norm;
  begin
    if not langformat then Exit;
    anzahl:=x_word__datei_lesen(analyseoff+einzel_laenge-l);
    if 2+anzahl*$17+4<>l then Exit;

    ausschrift('Super Retriss Pro Install Utility / Rogelio Bernal [GNU-Zip]',packer_dat);
    archiv_start;
    for z:=0 to anzahl-1 do
      begin
        datei_lesen(p,analyseoff+o+2+z*$17,$17);
        laenge_eingepackt:=longint_z(@p.d[$13])^;
        laenge_ausgepackt:=laenge_eingepackt;
        archiv_datei;
        exezk:=puffer_zu_zk_e(p.d[0],#0,8+1+3);
        archiv_datei_ausschrift(exezk);
        merke_position(analyseoff+longint_z(@p.d[$0f])^                  ,datentyp_unbekannt);
        merke_position(analyseoff+longint_z(@p.d[$0f])^+laenge_eingepackt,datentyp_unbekannt);
        befehl_schnitt(analyseoff+longint_z(@p.d[$0f])^,laenge_eingepackt,exezk);
        if z=0 then einzel_laenge:=laenge_eingepackt;
      end;
    archiv_summe;
    ausschrift_leerzeile;
  end;

procedure clu_eldorado(const p:puffertyp);
  var
    anzahl,i            :word_norm;
  begin
    ausschrift('<CLU?/eldorado>',packer_dat);
    if not langformat then Exit;

    archiv_start;
    anzahl:=longint_z(@p.d[$c])^;
    for i:=1 to anzahl do
      begin
        datei_lesen(form_puffer,analyseoff+$54+(i-1)*$10,$10);
        laenge_eingepackt:=longint_z(@form_puffer.d[4])^;
        laenge_ausgepackt:=laenge_eingepackt;
        exezk:=puffer_zu_zk_e(p.d[$18],#0,$3c)+'.'+StrZ(i,3);
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+longint_z(@form_puffer.d[8])^,laenge_eingepackt,exezk);
      end;
    archiv_summe;
  end;

procedure ros_bin_archiv;
  var
    o:longint;
  begin
    ausschrift('<ROS.BIN/Kvtp2ba2.bin/Soyo??>',packer_dat);
    if not langformat then Exit;

    archiv_start;
    o:=$20;
    while (o+$20<einzel_laenge) and (o>=$20) do
      begin
        datei_lesen(form_puffer,analyseoff+o,$20);
        exezk:=puffer_zu_zk_e(form_puffer.d[$11],#0,8)+'.'+puffer_zu_zk_e(form_puffer.d[$19],#0,3);
        laenge_eingepackt:=longint_z(@form_puffer.d[$00])^;
        laenge_ausgepackt:=longint_z(@form_puffer.d[$0a])^;
        archiv_datei;
        archiv_datei_ausschrift(exezk);
        befehl_schnitt(analyseoff+o+word_z(@form_puffer.d[$04])^,laenge_eingepackt-word_z(@form_puffer.d[$04])^,exezk);
        Inc(o,laenge_eingepackt);
      end;
    archiv_summe;
  end;

procedure gdiff(const p:puffertyp);
  var
    o:dateigroessetyp;
    k:byte;
    l:dateigroessetyp;
  begin
    ausschrift('Generic Diff / Arthur van Hoff; Jonathan Payne ['+str0(p.d[4])+']',packer_dat);
    if not langformat then Exit;

    if p.d[4]<>4 then Exit;

    archiv_start;
    o:=5;
    laenge_eingepackt64:=einzel_laenge;
    laenge_ausgepackt64:=0;
    repeat
      datei_lesen(form_puffer,analyseoff+o,1+8+4);
      with form_puffer do
      case d[0] of
        0:              (* eof *)
          Break;
        1..246:         (* append 1..246 *)
          begin
            k:=1;
            l:=d[0];
          end;
        247:            (* append smallword *)
          begin
            k:=1+2;
            l:=m_word(d[1]);
          end;
        248:            (* append longint *)
          begin
            k:=1+4;
            l:=m_longint(d[1]);
          end;
        249:            (* copy smallword/byte *)
          begin
            k:=1+2+1;
            l:=d[1+2];
          end;
        250:            (* copy smallword/smallword *)
          begin
            k:=1+2+2;
            l:=m_word(d[1+2]);
          end;
        251:            (* copy smallword/longint *)
          begin
            k:=1+2+4;
            l:=m_longint(d[1+2]);
          end;
        252:            (* copy longint/byte *)
          begin
            k:=1+4+1;
            l:=d[1+4];
          end;
        253:            (* copy longint/smallword *)
          begin
            k:=1+4+2;
            l:=m_word(d[1+4]);
          end;
        254:            (* copy longint/longint *)
          begin
            k:=1+4+4;
            l:=m_longint(d[1+4]);
          end;
        255:            (* copy comp/longint *)
          begin
            k:=1+8+4;
            l:=m_longint(d[1+8]);
          end;
      end;

      laenge_ausgepackt64:=laenge_ausgepackt64+l;

      o:=o+k;

      if form_puffer.d[0]<=248 then
        o:=o+l;

    until (o>=einzel_laenge) or (o<=5);
    archiv_datei;
    archiv_datei_ausschrift('?');
    archiv_summe;
  end;

end.
