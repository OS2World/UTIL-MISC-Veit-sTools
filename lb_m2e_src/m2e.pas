(*&Use32+*)
program maestro_2e_pipemixer_treiber;


(* 2000.11.04..2001.02.06 Veit Kannegieser *)



(* Dokumentation:
   ESS   DOS APM-Treiber(m2e0v.asm)
         Beispielquellen(BTM2E102.ZIP)
   INTEL AC97r22.pdf
   LbMix Quelltext                           *)

uses
  M2E_spra,
  PCI_Hw,
  {$IfDef VirtualPascal}
  Dos,
  Os2Base,
  Os2Def,
  VpUtils,
  VpSysLow,
  {$Else VirtualPascal}
  Dos,
  TpUtils,
  TpSysLow,
  {$EndIf VirtualPascal}
  Strings;

const
  mute_untertuetzt      =4; (* 0=aus 4=ein *)

(*$DEFINE MERKE_FEINEINSTELLUNG*) (* 0..100 statt 100*0/31, 100*1/31..100*31/31 *)
(* mit 0.07b4 veraltet $DEFINE MONOMIX_STEREOMIX*)

type
  kanalbeschreibung     =
    packed record
      quellkanal        :byte;
      lautstaerke       :byte;
    end;

const
  datum                 ='2000.11.04..2004.08.05';
  apilevel              ='2';
  beenden               :boolean=false;
  beenden_befehl        :string[2]='FF';
  ess_index             :word=1; (* Erstes gefundenes GerÑt verwenden *)
  geschwaetzig          :boolean=false;
  cdrom_treiber         :longint=0;
  cd_laufwerk_verzoegert:boolean=false;
  cdrom_laufwerk        :array[0..2] of char='H:'#0;
  (*$IfDef OS2*)
  leitungsname          :array[0..260] of char='\PIPE\MIXER';
  (*$EndIf*)

  benutze_monomix_stereomix:boolean=true; (* 0.7 B4+ *)

var
  basisport             :word;
  (*$IfDef OS2*)
  leitung               :HPipe;
  (*$Else*)
  leitung               :Text;
  (*$EndIf*)
  lesepuffer,
  schreibpuffer         :array[0..2048-1] of char;
  gelesen,
  leseposition,
  geschrieben           :word;

  funktion,
  para1,
  para2,
  para3                 :longint;

  antwort,
  alt                   :string;

  cdrom_para            :array[1..4] of char;
  cdrom_data            :packed array[0..3] of kanalbeschreibung;
  paralen,datalen       :longint;

type
  regler_beschreibung   =
    record
      indexreg          :integer;
      stereo            :boolean;
      maxwert           :byte;
      negativ           :boolean;
      stumm_bit15       :boolean;
      zusatzbit         :word;
    end;

const
  PMIXFLG_MONO          =$100; (* Force stereo control to mono *)
  PMIXFLG_NOSEL         =$200; (* Remove control from the input selector *)
  PMIXFLG_ONLYSEL       =$400; (* The control can not be enabled and can only appear *)
                               (* in the input selector. *)



  master                :array[1..1] of regler_beschreibung=
  (((*Master Volume*)
    indexreg:$02    ;stereo:true  ;maxwert:$3f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0));


  regler                :array[0..$c] of regler_beschreibung=
  (((*0: MONOIN*)
    indexreg:$0a    ;stereo:false ;maxwert:$1e     ;negativ:true ;stumm_bit15:true ;zusatzbit:0), (* Bit 0 wird ignoriert *)
   ((*1: PHONE*)
    indexreg:$0c    ;stereo:false ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:PMIXFLG_MONO),
   ((*2: MIC*)
    indexreg:$0e    ;stereo:false ;maxwert:$1f+$40 ;negativ:true ;stumm_bit15:true ;zusatzbit:PMIXFLG_MONO),
   ((*3: LINE*)
    indexreg:$10    ;stereo:true  ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0),
   ((*4: CD*)
    indexreg:$12    ;stereo:true  ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0),
   ((*5: VIDEO*)
    indexreg:$14    ;stereo:true  ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0),
   ((*6: AUX*)
    indexreg:$16    ;stereo:true  ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0),
   ((*7: ?*)
    indexreg:-1     ;stereo:true  ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0),
   ((*8: ?*)
    indexreg:-1     ;stereo:true  ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0),
   ((*9: ?*)
    indexreg:-1     ;stereo:true  ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0),
   ((*A: ?*)
    indexreg:-1     ;stereo:true  ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0),
   ((*B: bass/trebble*)
    indexreg:$08    ;stereo:true  ;maxwert:$0f     ;negativ:false;stumm_bit15:false;zusatzbit:0),
   ((*C: THREED*)
    indexreg:$22    ;stereo:true  ;maxwert:$0f     ;negativ:false;stumm_bit15:false;zusatzbit:0));


   pcm_out              :array[1..1] of regler_beschreibung=
   (((*PCM Out*)
    indexreg:$18    ;stereo:true  ;maxwert:$1f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0));

   recordgain           :array[1..2] of regler_beschreibung=
   (((*Record Gain*)
    indexreg:$1c    ;stereo:true  ;maxwert:$0f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0),
    ((*Record Gain Mic*)
    indexreg:$1e    ;stereo:false ;maxwert:$0f     ;negativ:true ;stumm_bit15:true ;zusatzbit:0));


(*$IFDEF MERKE_FEINEINSTELLUNG*)
var
  feineinstellungen     :array[0..255] of
    record
      zk                :string(*$IfNDef VirtualPascal*)[10](*$EndIf*);
      wert              :smallword;
    end;
(*$ENDIF MERKE_FEINEINSTELLUNG*)

procedure keypress;
  {$IfDef OS2}
  var
    ansimode            :smallword;
  {$EndIf OS2}
  begin
    WriteLn(textz_press_key_to_exit^);
    {$IfDef OS2}
    if (ViogetAnsi(ansimode,0)<>0)
    or (not IsFileHandleConsole(TextRec(Input ).Handle))
    or (not IsFileHandleConsole(TextRec(Output).Handle))
     then
      SysBeepEx(1000,500)
    else
    {$EndIf OS2}
      SysReadKey;
  end;


function lies_cdrom:boolean;
  var
    z                   :word;
  begin
    (*$IfDef OS2*)
    cdrom_para:='CD01';
    paralen:=SizeOf(cdrom_para);
    FillChar(cdrom_data,SizeOf(cdrom_data),0);
    datalen:=SizeOf(cdrom_data);

    lies_cdrom:=
      DosDevIOCtl(cdrom_treiber,ioctl_cdromaudio,cdromaudio_getchannel,
        @cdrom_para,paralen,@paralen,
        @cdrom_data,datalen,@datalen)=0;

    if geschwaetzig then
      begin
        WriteLn;
        for z:=Low(cdrom_data) to High(cdrom_data) do
          with cdrom_data[z] do
            WriteLn(z:3,quellkanal:3,lautstaerke:4,'/255');
      end;
    (*$Else*)
    lies_cdrom:=false;
    {DOS implementation...}
    (*$EndIf*)
  end;

function schreibe_cdrom:boolean;
  var
    z                   :word;
  begin
    (*$IfDef OS2*)
    cdrom_para:='CD01';
    paralen:=SizeOf(cdrom_para);

    for z:=Low(cdrom_data) to High(cdrom_data) do
      cdrom_data[z].quellkanal:=z;

    datalen:=SizeOf(cdrom_data);

    schreibe_cdrom:=
      DosDevIOCtl(cdrom_treiber,ioctl_cdromaudio,cdromaudio_setchannelctrl,
        @cdrom_para,paralen,@paralen,
        @cdrom_data,datalen,@datalen)=0;
    (*$Else*)
    schreibe_cdrom:=false;
    {DOS-Implemantation}
    (*$EndIf*)
  end;

(*$IfDef OS2*)
procedure versuche_cd_laufwerk_zu_oeffnen;
  var
    rc                  :ApiRet;
    ergebnis            :longint;
  begin
    rc:=DosOpen(cdrom_laufwerk,cdrom_treiber,ergebnis,0,0,
                open_action_Fail_If_New+open_action_Open_If_Exists,
                open_flags_Dasd+open_share_DenyNone+open_flags_NoInherit (*+open_access_ReadWrite*)+open_flags_Fail_On_Error,
                nil);
    case rc of
      0:;
      5:
        begin
          cd_laufwerk_verzoegert:=true;
          if geschwaetzig then
            WriteLn(textz_CD_Laufwerk_wird_noch_benutzt^);
          Exit;
        end;
      21:
        begin
          cd_laufwerk_verzoegert:=true;
          if geschwaetzig then
            WriteLn(textz_CD_Laufwerk_ist_nicht_bereit^);
          Exit;
        end
    else
      WriteLn(textz_kein_zugriff_auf_cd_Laufwerk^);
      keypress;
      Halt(rc);
    end;

    cd_laufwerk_verzoegert:=false;

    if geschwaetzig then
      WriteLn(textz_Laufwerk_^,cdrom_laufwerk[0],textz__ist_bereit^);

    if not lies_cdrom then
      begin
        WriteLn(textz_Das_Laufwerk_versteht_die_CD_ROM_Funktionen_nicht^);
        keypress;
        Halt(1);
      end;
  end;
(*$Else*)
procedure versuche_cd_laufwerk_zu_oeffnen;
  begin
    WriteLn(textz_kein_zugriff_auf_cd_Laufwerk^);
    keypress;
    Halt(99);
  end;
(*$EndIf*)

procedure werte_parameter;
  var
    z,kontrolle         :word;
    (*$IfDef OS2*)
    rc                  :ApiRet;
    (*$EndIf*)
    para                :string;
  const
    hilfe_anzeigen      :boolean=false;
    m2e_beenden         :boolean=false;

  begin

    z:=1;
    while z<=ParamCount do
      begin

        para:=ParamStr(z);
        Inc(z);

        if (Length(para)>=Length('/?')) and (para[1] in ['-','/']) then
          case UpCase(para[2]) of
            '?',
            'H':hilfe_anzeigen:=true;
            'P',
            'B':
              begin
                Delete(para,1,Length('/P'));

                if Pos(':',para)=1 then
                  Delete(para,1,Length(':'));

                if para='' then
                  begin
                    para:=ParamStr(z);
                    Inc(z);
                  end;

                if Pos('$',para)<>1 then
                  Insert('$',para,1);

                Val(para,ess_index,kontrolle);
                if kontrolle<>0 then
                  hilfe_anzeigen:=true;
                if (ess_index<1) or (ess_index>16) then
                  begin
                    WriteLn(textz_Ignoriere_ungueltigen_ESS_Nummer_Parameter_^);
                    ess_index:=1;
                  end;
              end;
            'L':; (* "LOCK" - ignoriert *)
            'R':; (* "RESET MIXER" - ignoriert *)
            'V':geschwaetzig:=true;
            'Q':m2e_beenden:=true;
            'C':
              begin
                if UpCase(para[3])<>'D' then
                  begin
                    hilfe_anzeigen:=true;
                    Break;
                  end;
                Delete(para,1,Length('/CD'));
                if Pos(':',Para)=1 then
                  Delete(para,1,Length(':'));

                if para='' then
                  begin
                    para:=ParamStr(z);
                    Inc(z);
                  end;

                cdrom_laufwerk[0]:=UpCase(para[1]);
                versuche_cd_laufwerk_zu_oeffnen;
              end;

            (*$IfDef OS2*)
            'N':
              begin
                Delete(para,1,Length('/N'));

                if Pos(':',para)=1 then
                  Delete(para,1,Length(':'));

                if para='' then
                  begin
                    para:=ParamStr(z);
                    Inc(z);
                  end;

                StrPCopy(leitungsname,para);
              end;
            (*$EndIf*)

          else
            hilfe_anzeigen:=true;
          end
        else
          hilfe_anzeigen:=true;

      end;

    if hilfe_anzeigen then
      begin
        WriteLn(textz_hilfe1^);
        WriteLn(textz_hilfe2^);
        WriteLn(textz_hilfe4^);
        WriteLn(textz_hilfe5^);
        WriteLn(textz_hilfe6^);
        WriteLn(textz_hilfe7^);
        WriteLn;
        WriteLn(textz_hilfe9^);
        keypress;
        Halt(1);
      end;

    if m2e_beenden then
      begin
        (*$IfDef OS2*)
        rc:=SysFileOpen(leitungsname,open_access_ReadWrite+open_share_DenyNone,leitung);
        if rc<>0 then
          begin
            WriteLn(textz_Kann_Leitung__1^,leitungsname,textz_Kann_Leitung__2^);
            (*keypress;*)
            Halt(1);
          end;
        SysFileWrite(leitung,beenden_befehl[1],Length(beenden_befehl),z);
        SysFileFlushBuffers(leitung);
        SysFileClose(leitung);
        (*$Else*)
        {not implemented}
        (*$EndIf*)
        Halt(0);
      end;

  end;


procedure lies(var l:longint;const dezimal_hexadezimal:byte);
  var
    z                   :char;
  begin
    l:=0;
    repeat
      z:=UpCase(lesepuffer[leseposition]);
      case z of
        '0'..'9':
          begin
            l:=l*dezimal_hexadezimal+Ord(z)-Ord('0');
            Inc(leseposition);
          end;
        'A'..'F':
          begin
            l:=l*dezimal_hexadezimal+Ord(z)-Ord('A')+10;
            Inc(leseposition);
          end;
        ' ',#0:
          Break;
      else
        WriteLn(textz_Syntaxfehler^,StrPas(lesepuffer),'"');
        keypress;
        Halt(255);
      end;
    until false;

    while lesepuffer[leseposition]=' ' do
      Inc(leseposition);
  end;

const
  IO_PT_CODEC_CMD       =$30;
  IO_PT_CODEC_STATUS    =$30;
  IO_PT_CODEC_DATA      =$32;
  IO_PT_CODEC_FORMATA   =$34;
  IO_PT_CODEC_FORMATB   =$36;

  _CODEC_RST_TIMEOUT=1; (* _1uS * 30 *)
  _CODEC_RW_TIMEOUT =1; (* _1uS * 10 *)


procedure vDelay(const m:word);
  var
    z:word;
  begin
    for z:=1 to 100 do
      Port[$ed]:=$ed;
  end;

procedure warte_auf_codec;
  const
    wartezeit1          =100;
    wartezeit2          =wartezeit1+(4000 div 31);
  var
    zaehler             :word;
  begin
    zaehler:=0;
    while (Port[basisport+IO_PT_CODEC_STATUS] and 1)<>0 do
      begin

        if zaehler=wartezeit2 then
          begin
            WriteLn(textz_Der_AC97_Baustein_wurde_nicht_verfuegbar^);
            keypress;
            Halt(1);
          end;

        Inc(zaehler);

        if zaehler>=wartezeit1 then
          SysCtrlSleep(31);

      end;
  end;

function codec_lies(const regindex:byte):word;
  begin
    warte_auf_codec;

    PortW[basisport+IO_PT_CODEC_CMD]:=regindex or $80;
    vDelay( _CODEC_RW_TIMEOUT );
    codec_lies:=PortW[basisport+IO_PT_CODEC_DATA];
  end;

procedure codec_schreibe(const regindex:byte;const wert:word);
  begin
    warte_auf_codec;

    PortW[basisport+IO_PT_CODEC_DATA]:=wert;
    vDelay( _CODEC_RW_TIMEOUT );
    PortW[basisport+IO_PT_CODEC_CMD]:=regindex;
  end;

function Int2Hex1(const l:longint):string;
  begin
    if l<=$f then
      Int2Hex1:=Int2Hex(l,1)
    else if l<=$ff then
      Int2Hex1:=Int2Hex(l,2)
    else if l<=$fff then
      Int2Hex1:=Int2Hex(l,3)
    else
      Int2Hex1:=Int2Hex(l,4);
  end;


procedure verschluessele(const rb:regler_beschreibung);
  var
    w                   :word;
    maximalwert1        :word;
    plus20db            :boolean;

  function umformung(p:word):word;
    begin
      if rb.negativ then
        umformung:=Round(maximalwert1-(p*maximalwert1)/100) and maximalwert1
      else
        umformung:=Round(             (p*maximalwert1)/100) and maximalwert1;
    end;

  begin
    with rb do
      begin

        (*$IFDEF MERKE_FEINEINSTELLUNG*)
        with feineinstellungen[indexreg] do
          begin
            zk:=Int2Str(para1)+' ';
            if stereo then
              zk:=zk+Int2Str(para2)+' '
            else
              zk:=zk+Int2Str(    0)+' ';
            zk:=zk+Int2Hex1(para3 or mute_untertuetzt or zusatzbit);
          end;
        (*$ENDIF MERKE_FEINEINSTELLUNG*)


        plus20db:=(maxwert and ($40+$20))=$40;
        maximalwert1:=maxwert and ($ff-$40);

        if para1>100 then para1:=100;
        if para1<  0 then para1:=  0;
        if para2>100 then para2:=100;
        if para2<  0 then para2:=  0;

        (* Bit 15 zum verstummen verwenden, wenn vorhanden *)
        w:=0;
        if stumm_bit15 and Odd(para3) then
          Inc(w,1 shl 15);

        (* MirofonverstÑrker *)
        if plus20db then
          begin
            if (Max(para1,para2))>=50 then
              begin
                Inc(w,$40);
                para1:=Max(0,para1-50);
                para2:=Max(0,para2-50);
              end;
            para1:=para1*2;
            para2:=para2*2;
          end;

        if stereo then
          Inc(w,umformung(para2)
               +umformung(para1) shl  8)
        else
          Inc(w,umformung(Max(para1,para2)));

        codec_schreibe(indexreg,w);
        (*$IFDEF MERKE_FEINEINSTELLUNG*)
        feineinstellungen[indexreg].wert:=w;
        (*$ENDIF MERKE_FEINEINSTELLUNG*)

      end; (* with rb *)
  end;

function entschluessele(const rb:regler_beschreibung):string;
  var
    w,m,r,l             :word;
    maximalwert1        :word;
    plus20db            :boolean;
    e                   :word;

  function umformung(w:word):word;
    begin
      if maximalwert1=0 then
        umformung:=0
      else
        begin
          w:=w and maximalwert1;
          if rb.negativ then
            umformung:=100-Round(w*100/maximalwert1)
          else
            umformung:=    Round(w*100/maximalwert1);
        end;
    end;

  begin
    with rb do
      begin

        plus20db:=(maxwert and $40)=$40;
        maximalwert1:=rb.maxwert and ($ff-$40);

        w:=codec_lies(indexreg);
        (*$IFDEF MERKE_FEINEINSTELLUNG*)
        with feineinstellungen[indexreg] do
          if (w=wert) and (zk<>'') then
            begin
              entschluessele:=zk;
              Exit;
            end;
        (*$ENDIF MERKE_FEINEINSTELLUNG*)

        if stumm_bit15 then
          m:= (w shr 15) and 1
        else
          m:=0;

        l:=umformung(w shr  8);
        r:=umformung(w       );

        if plus20db then
          begin
            if (w and $40)=$40 then
              e:=50
            else
              e:=0;
            l:=e+l div 2;
            r:=e+r div 2;
          end;

        if stereo then
          entschluessele:=Int2Str(l)+' '+Int2Str(r)+' '+Int2Hex1(m or mute_untertuetzt or zusatzbit)
        else
          entschluessele:=Int2Str(r)+' '+Int2Str(0)+' '+Int2Hex1(m or mute_untertuetzt or zusatzbit);

      end; (* with *)
  end;




procedure verarbeite_befehl;
  const
    fehlerfrei          ='OK';
    fehler              ='FAILED';
    nicht_implementiert ='UNSUPPORTED';

  var
    z                   :longint;

  begin
    antwort:=nicht_implementiert;

    case funktion of

      $01: (* SetMasterVolume (mute=0) *)
        with master[1] do
          if indexreg<>-1 then
            begin
              verschluessele(master[1]);
              antwort:=fehlerfrei;
            end;

      $02, (* AC97 Stereo mix *)
      $03: (* AC97 Mono mix   *)
        antwort:=fehlerfrei;

      $11: (* QueryMasterVolume (mute=0) *)
        with master[1] do
          if indexreg<>-1 then
            begin
              antwort:=entschluessele(master[1]);
            end;

      $12, (* AC97 Stereo mix *)
      $13: (* AC97 Mono mix   *)
        antwort:='0 0 '+Int2Hex1(PMIXFLG_ONLYSEL);


      $40..$4a: (* ..Set *)
        begin
          if (funktion=$44) and (cd_laufwerk_verzoegert) then
            versuche_cd_laufwerk_zu_oeffnen;

          if (funktion=$44) and (cdrom_treiber<>0) then
            begin

              if Odd(para3) then (* Stumm *)
                begin
                  cdrom_data[0].lautstaerke:=0;
                  cdrom_data[1].lautstaerke:=0;
                end
              else
                begin
                  cdrom_data[0].lautstaerke:=Round((255*para1)/100);
                  cdrom_data[1].lautstaerke:=Round((255*para2)/100);
                end;

              cdrom_data[2].lautstaerke:=cdrom_data[0].lautstaerke;
              cdrom_data[3].lautstaerke:=cdrom_data[1].lautstaerke;

              schreibe_cdrom;
            end;

          with regler[funktion and $f] do
            if indexreg<>-1 then
              begin
                verschluessele(regler[funktion and $f]);
                antwort:=fehlerfrei;
              end;
        end;

      $4b: (* BassTrebleSet *)
        begin
          with regler[funktion and $f] do
            if indexreg<>-1 then
              begin
                para3:=0;
                verschluessele(regler[funktion and $f]);
                antwort:=fehlerfrei;
              end;
        end;

      $4c: (* ThreeDSet *)
        begin
          with regler[funktion and $f] do
            if indexreg<>-1 then
              begin
                (* Ein/Aus *)
                z:=codec_lies($20) and ($ffff-(1 shl 13));
                codec_schreibe($20,z or (1-(para3 and 1)) shl 13);
                para3:=0;

                (* 0..15 *)
                verschluessele(regler[funktion and $f]);
                antwort:=fehlerfrei;
              end;
        end;

      $4d: (* StreamVolSet *)
        begin

          with pcm_out[1] do
            if indexreg<>-1 then
              begin
                verschluessele(pcm_out[1]);
                antwort:=fehlerfrei;
              end;

        end;

      $4e: (* RecordSrcSet *)
        begin
          (* Record Select Control Register *)
          (* kein Mischen sondern nur Auswahl *)

          if (para1 and $20000)=$20000 then
            begin
              para1:=$10 shl 6;
              benutze_monomix_stereomix:=true;
            end
          else if (para1 and $10000)=$10000 then
            begin
              para1:=$10 shl 5;
              benutze_monomix_stereomix:=true;
            end;

          para1:=(para1 shr 4) and $ff;

          (*$IFDEF MONOMIX_STEREOMIX*)
          if para1=0 then (* MonoMix *)
            begin
              para1:=1 shl 6;
              benutze_monomix_stereomix:=false;
            end
          else if para1=$01+$02 then (* StereoMix *)
            begin
              para1:=1 shl 5;
              benutze_monomix_stereomix:=false;
            end;
          (*$ENDIF MONOMIX_STEREOMIX*)

          if not (para1 in [$01,$02,$04,$08,$10,$20,$40,$80]) then
            para1:=para1 and (not (1 shl (codec_lies($1a) and $07)));

          for z:=0 to 7 do
            if (para1 and (1 shl z))<>0 then
              codec_schreibe($1a,z+z shl 8);

          antwort:=fehlerfrei;
        end;

      $4f: (* RecordGainSet *)
        begin
          para2:=para1; (* Stereo und Mono *)

          with recordgain[1] do
            if indexreg<>-1 then
              begin
                verschluessele(recordgain[1]);
                antwort:=fehlerfrei;
              end;

          z:=codec_lies($1a);
          if (z and $07)=1 then
            (* Record Gain Mic *)
            with recordgain[2] do
              if indexreg<>-1 then
                begin
                  verschluessele(recordgain[2]);
                  antwort:=fehlerfrei;
                end;
        end;

      $60..$6a: (* ..Query *)
        begin
          with regler[funktion and $f] do
            if indexreg<>-1 then
              antwort:=entschluessele(regler[funktion and $f]);

          if (funktion=$64) and (cdrom_treiber<>0) then
            begin
              lies_cdrom;

              antwort:=Int2Str(Round((cdrom_data[0].lautstaerke*100)/255))+' ' (* links  *)
                      +Int2Str(Round((cdrom_data[1].lautstaerke*100)/255))+' ' (* rechts *)
                      +Int2Hex1(0);                                            (* mute   *)

              with regler[funktion and $f] do
                if indexreg<>-1 then
                  if Odd(codec_lies(indexreg) shr 15) then
                    Inc(antwort[Length(antwort)]); (* +stumm *)
            end;
        end;

      $6b: (* BassTrebbleQuery *)
        begin
          with regler[funktion and $f] do
            if indexreg<>-1 then
              begin
                antwort:=entschluessele(regler[funktion and $f]);
                Inc(antwort[Length(antwort)],1); (* Bass unterstÅtzt *)
                if stereo then
                  Inc(antwort[Length(antwort)],2); (* BlÑser unterstÅtzt *)
              end;
        end;

      $6c: (* ThreeDQuery *)
        begin
          with regler[funktion and $f] do
            if indexreg<>-1 then
              begin
                antwort:=entschluessele(regler[funktion and $f]);
                antwort[Length(antwort)]:=Chr(Ord('1')-(codec_lies($20) shr 13) and 1);
                if maxwert>0 then
                  begin
                    Inc(antwort[Length(antwort)],2); (* Raum unterstÅtzt *)
                    if stereo then
                      Inc(antwort[Length(antwort)],4); (* Zentrum unterstÅtzt *)
                  end;
              end;
        end;

      $6d: (* StreamVolQuery *)
        begin
          with pcm_out[1] do
            if indexreg<>-1 then
              antwort:=entschluessele(pcm_out[1]);
        end;

      $6e: (* RecordSrcQuery *)
        begin
          (* Record Select Control Register *)
          z:=$10 shl (codec_lies($1a) and 7);
          (*$IFDEF MONOMIX_STEREOMIX*)
          if not benutze_monomix_stereomix then
            case z of
              $10 shl 6:(* MonoMix *)
                z:=$000;
              $10 shl 5: (* StereoMix *)
                z:=$010+$020;
            end
          else
          (*$ENDIF*)
            case z of
              $10 shl 6:(* MonoMix *)
                z:=$20000;
              $10 shl 5: (* StereoMix *)
                z:=$10000;
            end;

          (* b1=0:global,b2:0=kein Mischer *)
          antwort:=Int2Str((0 shl 1)+(0 shl 2)+z )+' '+Int2Str(0)+' '
            (*$IFDEF MONOMIX_STEREOMIX*)
                  +Int2Hex1(4);
            (*$ELSE*)
                  +Int2Hex1(0);
            (*$ENDIF*)

        end;

      $6f: (* RecordGainQuery *)
        begin
          z:=codec_lies($1a);
          if (z and $07)=1 then (* Mic *)
            begin
              with recordgain[2] do
                if indexreg<>-1 then
                  antwort:=entschluessele(recordgain[2])
            end
          else
            begin
              with recordgain[1] do
                if indexreg<>-1 then
                  antwort:=entschluessele(recordgain[1]);
            end;
        end;


      $80:
        antwort:=apilevel; (* Version 2 *)

      $83:
        antwort:=textz_titel^+datum; (* infobuf ? *)

      $ff:
        begin
          beenden:=true;
          antwort:=fehlerfrei;
        end;

    else
      antwort:=nicht_implementiert;
    end;

    if geschwaetzig then
      begin
        WriteLn(' =',antwort);
        (*if antwort=nicht_implementiert then SysCtrlSleep(1000);*)
      end;

  end;

function pruefe_aenderbar(const indexreg,bit,stumm,mindestwert:word):boolean;
  var
    ow:word;
  begin
    ow:=codec_lies(indexreg);
    codec_schreibe(indexreg,bit or stumm);
    pruefe_aenderbar:=(codec_lies(indexreg) and bit)>=mindestwert;
    codec_schreibe(indexreg,ow);
  end;

procedure codec_auswahl(n:byte);
  begin
    Port[basisport+$38  ]:=(Port[basisport+$38  ] and $fc)+n;
    Port[basisport+$38+2]:=(Port[basisport+$38+2] and $fc)+n;
    Port[basisport+$38+4]:=(Port[basisport+$38+4] and $fc)+n;
  end;

procedure decode_command;
  var
    z                   :word;
  begin
    if geschwaetzig then
      begin
        Write('"',StrPas(lesepuffer),'" ');
        if gelesen<15 then
          Write(Copy('             ',1,15-gelesen));
      end;

    for z:=Low(lesepuffer) to gelesen do
      if lesepuffer[z] in [#9,#10,#13] then
        lesepuffer[z]:=' ';

    if lesepuffer[0]=' ' then
      lesepuffer[0]:='0';

    alt:=StrPas(lesepuffer);

    leseposition:=0;
    (* Funktion *)
    if leseposition=gelesen then
      funktion:=-1
    else
      lies(funktion,16);

    (* Parameter 1 *)
    if leseposition=gelesen then
      para1:=100
    else
      lies(para1,10);

    (* Parameter 2 *)
    if leseposition=gelesen then
      para2:=para1
    else
      lies(para2,10);

    (* Parameter 3 *)
    if leseposition=gelesen then
      para3:=0
    else
      lies(para3,16);
  end;

procedure load_startup_commands_from(const directory:string);
  var
    loa                 :text;
  begin
    if directory='' then Exit;
    Assign(loa,directory+'m2e.loa');
    {$I-}
    Reset(loa);
    {$I+}
    if IOResult=0 then
      begin
        while not Eof(loa) do
          begin
            ReadLn(loa,lesepuffer);
            gelesen:=StrLen(lesepuffer);
            if gelesen=0 then Continue;
            if lesepuffer[0] in ['#',';','%'] then Continue;
            decode_command;
            verarbeite_befehl;
          end;
        Close(loa);
      end;
  end;

procedure load_startup_commands;
  var
    m2e_loa_path        :DirStr;
    ignore_name         :NameStr;
    ignore_ext          :ExtStr;
  begin
    FSplit(ParamStr(0),m2e_loa_path,ignore_name,ignore_ext);
    load_startup_commands_from(m2e_loa_path);
    m2e_loa_path:=GetEnv('HOME');
    if m2e_loa_path<>'' then
      load_startup_commands_from(m2e_loa_path);
  end;

procedure main_loop;
  var
    rc                  :word;
  begin
    repeat
      (*$IfDef OS2*)
      rc:=
      DosConnectNPipe(leitung);

      if rc<>0 then
        begin
          WriteLn(textz_Fehler_beim_Verbindungsaufbau_^,rc,')');
          keypress;
          Halt(rc);
        end;

      rc:=
      DosRead(leitung,lesepuffer,SizeOf(lesepuffer)-1,gelesen);
      if rc<>0 then
        begin
          WriteLn(textz_Lesefehler_^,rc,')!');
          keypress;
          Halt(rc)
        end;
      lesepuffer[gelesen]:=#0;
      (*$Else*)
      (* DOS console input *)

      WriteLn('01/11=Set/Query Master');
      WriteLn('4x/6x=Set/Query {0:MONO,1:PHONE,2:MIC,3:LINE,4:CD,5:VIDEO,6:AUX,C=3D,D:WAVE}');

      if Eof then
        begin
          StrPCopy(lesepuffer,'255');
        end
      else
        ReadLn(lesepuffer);
        if StrLen(lesepuffer)=0 then
          StrPCopy(lesepuffer,'FF');

      gelesen:=StrLen(lesepuffer+1);
      (*$EndIf*)

      decode_command;

      if funktion<>-1 then
        begin
          verarbeite_befehl;
          (*$IfDef OS2*)
          antwort:=alt+' '+antwort;
          DosWrite(leitung,antwort[1],Length(antwort),geschrieben);
          (*$Else*)
          WriteLn(alt,'> ',antwort);
          (*$EndIf*)
        end;

      (*$IfDef OS2*)
      DosResetBuffer(leitung);
      DosDisConnectNPipe(leitung);
      (*$EndIf*)

    until beenden;

  end;

procedure suche_ESS;
  var
    bus,deviceid,func   :word;
    infotbl_cache       :array[0..$ff] of byte;
    infotbl_read        :array[0..$ff] of boolean;

  procedure reset_infotbl_cache;
    begin
      FillChar(infotbl_read,SizeOf(infotbl_read),false);
    end;

  function infotbl(const i:word):byte;
    begin
      if not infotbl_read[i] then
        begin
          infotbl_cache[i]:=lookup(deviceid,func,bus,i);
          infotbl_read[i]:=true;
        end;
      infotbl:=infotbl_cache[i];
    end;

  function infotbl_W(const i:word):Word;
    begin
      infotbl_W:=Word(infotbl(i+1)) shl 8
                +     infotbl(i  )       ;
    end;

  function infotbl_L(const i:word):longint;
    begin
      infotbl_L:=Longint(infotbl_W(i+2)) shl 16
                +        infotbl_W(i  )        ;
    end;

  var
    nn,pp               :byte;
    addr                :longint;
    numberof_ess__devices_found:word;

  begin
    {$IfDef OS2}
    open_pci_access_driver;
    {$EndIf OS2}

    pci_present_test;
    if failed then
      begin
        WriteLn(textz_PCI_nicht_vorhanden^);
        keypress;
        Halt(99);
      end;

    numberof_ess__devices_found:=0;

    bus:=0;
    repeat

      for deviceid:=0 to $1f do
        begin

          func:=0;
          repeat

            reset_infotbl_cache;

            if infotbl_W(0)<>$ffff then
              begin

                if (infotbl($19)>bus) then (* bus<>0 and not already known bus *)
                  case infotbl($e) and $7f of
                    (* 0:other *)
                    1, (* PCI-PCI (+AGP) *)
                    2: (* CardBus *)
                      begin
                        pci_hibus:=Max(pci_hibus,infotbl($19)); (* secondary bus   *)
                        pci_hibus:=Max(pci_hibus,infotbl($1a)); (* subordinate bus *)
                      end;
                  end;

                if {debughook or} ((infotbl($b)=4) and (infotbl($a)=1)) (* multimedia(4):audio(1) *) then
                  begin

                    if geschwaetzig then
                      WriteLn(textz_Klangchip_gefunden__Bus_^,bus,textz__Geraet_^,deviceid,textz__Funktion_^,func,
                        textz__Hersteller_^,Int2Hex(infotbl_W(0),4),textz__Produkt_^,Int2Hex(infotbl_W(2),4));

                    if infotbl_W(0)=$125d then
                      begin

                        Inc(numberof_ess__devices_found);

                        if geschwaetzig then
                          case infotbl_W(2) of
                            $1948:WriteLn('  ESS: Solo??');
                            $1968:WriteLn('  ESS: ES1968 Maestro-2 Audiodrive');
                            $1969:WriteLn('  ESS: ES1938/41/46 SOLO-1(E) AudioDrive');
                            $1978:WriteLn('  ESS: ES1978 Maestro-2E Audiodrive, ES1970 Canyon3D');
                            $1988:WriteLn('  ESS: ES1988/9 Allegro-1 Audiodrive');
                            $1989:WriteLn('  ESS: ES1989 Allegro ES56CVM-PI PCI Voice+Fax Modem');
                            $1998:WriteLn('  ESS: ES1980 Maestro-3 PCI Audio Accelerator');
                            $1999:WriteLn('  ESS: ES1983 Maestro-3.COMM ES56CVM-PI PCI oice+Fax Modem');
                            $199A:WriteLn('  ESS: ES1980 Maestro-3 PCI Audio Accelerator');
                            $199B:WriteLn('  ESS: ES1983 Maestro-3.COMM ES56CVM-PI PCI oice+Fax Modem');
                          else
                                  WriteLn('  ESS: ',textz_Produktname_ist_unbekannt_^);
                          end;

                        if numberof_ess__devices_found=ess_index then
                          begin

                            if geschwaetzig then
                              WriteLn(textz____benutze_diese_Geraet^);

                            basisport:=0;
                            (* type 0 header = 6 entries, *)
                            (*      1        = 2          *)
                            (*      2          skip       *)
                            case infotbl($e) and $7f of
                              0:pp:=6;
                              1:pp:=1;
                            else
                              pp:=0;
                            end;

                            nn:=0;
                            while nn<pp do
                              begin
                                addr:=infotbl_L($10+(nn*4));
                                if addr<>0 then
                                  begin
                                    if addr and 1=1 then
                                      basisport:=addr and $fffffffc
                                    else
                                      (* memory address *)
                                      if ((addr shr 1) and $3)=2 then
                                        Inc(nn); (* 64 bit needs next addr *)
                                  end;
                                Inc(nn);
                              end;

                            if basisport=0 then
                              begin
                                WriteLn(textz_No_valid_IOBase_is_set^);
                                keypress;
                                Halt(99);
                              end;

                            if geschwaetzig then
                              WriteLn(textz_Basisadresse_des_Geraetes___^,Int2Hex(basisport,4));

                          end;
                      end
                    else
                      begin
                        if geschwaetzig then
                          WriteLn(textz_ignoring__not_ESS_^);
                      end;


                  end; (* audio *)
              end;

            if (func=0) and (infotbl($e) and $80=0) then
              Break; (* single-function device *)

            Inc(func);

          until func>7;

        end;
      Inc(bus);
    until bus>pci_hibus;

    {$IfDef OS2}
    close_pci_access_driver;
    {$EndIf OS2}

    if numberof_ess__devices_found<ess_index then
      begin
        WriteLn(textz_ESS_Geraet__^,ess_index,textz__wurde_nicht_gefunden_^);
        keypress;
        Halt(99);
      end;

  end; (* suche_ESS *)

var
  (*$IfDef OS2*)
  rc                    :ApiRet;
  (*$EndIf*)
  c,z                   :word;
  anz_codec             :word;
  docked                :boolean;

  dd                    :text;

begin

  (* DETACH erlaubt keine Ausgabe *)
  (*$I-*)
  Write(' '^m);
  (*$I+*)
  if IOResult<>0 then
    begin
      Assign(Output,'\DEV\NUL');
      Rewrite(Output);
    end;


  WriteLn(textz_titel^+datum);
  WriteLn;

  werte_parameter;

  suche_ESS;




  (*$IFDEF MERKE_FEINEINSTELLUNG*)
  FillChar(feineinstellungen,SizeOf(feineinstellungen),0);
  (*$ENDIF MERKE_FEINEINSTELLUNG*)


  if geschwaetzig then (*******************************************)
    begin

      docked:=(Port[basisport+$61] and $80)<>0;

      if docked then
        anz_codec:=2
      else
        anz_codec:=1;

      for c:=0 to anz_codec-1 do
        begin
          WriteLn('codec ',c,':');
          codec_auswahl(c);
          for z:=0 to 127 do
            if (z and $1)=0 then
              begin
                Write(Int2Hex(z,2),':',Int2Hex(codec_lies(z),4));
                if (z and $f)=$e then
                  WriteLn
                else
                  Write(' ');
              end;
        end;

      codec_auswahl(0);
    end; (**********************************************************)

  (*
  antwort:='????';
  z:=codec_lies($7c);
  antwort[1]:=Chr(Hi(z));
  antwort[2]:=Chr(Lo(z));
  z:=codec_lies($7e);
  antwort[3]:=Chr(Hi(z));
  antwort[4]:=Chr(Lo(z));
  WriteLn(antwort);*)

  if not pruefe_aenderbar($02,$003f,$8000,$3f) then master[1].maxwert:=$1f;
  (* mute abschalten *)
  codec_schreibe($02,codec_lies($02) and $7fff);

  (* Seite 47: 5.5.3.2 *)
  (* MONO_OUT *)if not pruefe_aenderbar($06,$001f   ,$8000, 1) then ;
  (* PC_BEEP  *)if not pruefe_aenderbar($0a,$001e   ,$8000, 1) then regler[ 0].indexreg:=-1;
  (* PHONE    *)if not pruefe_aenderbar($0c,$001f   ,$8000, 1) then regler[ 1].indexreg:=-1;
  (* VIDEO    *)if not pruefe_aenderbar($14,$001f   ,$8000, 1) then regler[ 5].indexreg:=-1;
  (* AUX_IN   *)if not pruefe_aenderbar($14,$001f   ,$8000, 1) then regler[ 6].indexreg:=-1;
  (* MIC2     * if not pruefe_aenderbar($20,$001f,0,?) then ; *)

  (* Seite 55: 5.7.8 *)
  (* 3D       *)if not pruefe_aenderbar($20,1 shl 13,    0, 1) then regler[$c].indexreg:=-1;
  (* Seite 56: 5.7.9 *)
                if not pruefe_aenderbar($22,$000f   ,    0,$f) then regler[$c].maxwert :=$e;
                if not pruefe_aenderbar($22,$000e   ,    0, 1) then regler[$c].indexreg:=-1;
                if not pruefe_aenderbar($22,$0e00   ,    0, 1) then regler[$c].stereo  :=false;

  (* Seite 52: 5.7.3 *)
  (* Hîhen/Tiefen *)
                if not pruefe_aenderbar($08,$000f   ,    0,$f) then regler[$b].maxwert :=$e;
                if not pruefe_aenderbar($08,$000e   ,    0, 1) then regler[$b].indexreg:=-1;
                if not pruefe_aenderbar($08,$0e00   ,    0, 1) then regler[$b].stereo  :=false;


  z:=codec_lies($00);
  if geschwaetzig then
    begin
      (*
      WriteLn('Dedicated Mic ADC Input Channel : ',Odd(z shr 0));
      WriteLn('bass/trebble : ',Odd(z shr 2));
      WriteLn('simulated mono>stereo : ',Odd(z shr 3));
      WriteLn('headphone : ',Odd(z shr 4));
      WriteLn('loadness/bass boost : ',Odd(z shr 5));
      WriteLn('18 bit dac : ',Odd(z shr 6));
      WriteLn('20 bit dac : ',Odd(z shr 7));
      WriteLn('18 bit adc : ',Odd(z shr 8));
      WriteLn('20 bit adc : ',Odd(z shr 9));
      WriteLn('3d stereo technique : ',(z shr 10) and $1f);*)
      WriteLn(textz_3D_stereo_technique___^,(z shr 10) and $1f);
    end;

  (*$IfDef OS2*)
  rc:=
  DosCreateNPipe(
    leitungsname,
    leitung,
    np_Access_Duplex,
    np_Wait or np_Type_Byte or np_ReadMode_Byte or 1,
    SizeOf(lesepuffer),
    SizeOf(schreibpuffer),
    0);

  if rc<>0 then
    begin
      WriteLn(textz_Fehler_beim_Erzeugen_von_1^,rc,textz_Fehler_beim_Erzeugen_von_2^,StrPas(leitungsname),'"!');
      keypress;
      Halt(rc);
    end;
  (*$EndIf*)

  load_startup_commands;

  main_loop;

  (*$IfDef OS2*)
  DosClose(leitung);
  (*$EndIf*)

  if cdrom_treiber<>0 then
    begin
      (*$IfDef OS2*)
      DosClose(cdrom_treiber);
      (*$EndIf*)
    end;

end.

