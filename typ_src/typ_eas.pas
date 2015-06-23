(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_eas;

interface

uses
  typ_type;

var
  letztes_ea:boolean;

(*$IfDef OS2*)
procedure untersuche_eas(const dn,titel:string);
(*$EndIf*)

procedure ea_einzel_untersuchung(const anfang:dateigroessetyp);
procedure ea_block_eautil(const start:dateigroessetyp);

implementation

uses
  typ_entp,
  typ_ausg,
  typ_varx,
  typ_var,
  typ_eiau,
  typ_dien,
  typ_spra;

(*$IfDef OS2*)
procedure untersuche_eas(const dn,titel:string);
  var
    ea_position,ea_einzel_laenge:longint;
  begin
    if not eas_anzeigen then exit;

    ea_oeffnen(dn,titel,langformat);
    if quelle.ea_anzahl=0 then exit;

    befehl_eautil(dn);

    ea_position:=0;
    repeat
      ea_einzel_untersuchung(ea_position+4);
      ea_einzel_laenge:=x_longint__datei_lesen(ea_position);
      inc(ea_position,ea_einzel_laenge);
    until ea_einzel_laenge=0;

  end;
(*$EndIf*)

(*  Fea2 = record
    oNextEntryOffset: ULong;
    fEA:              Byte;
    cbName:           Byte;
    cbValue:          SmallWord;
    szName:           Char;
  end;
  *)
(* aus os2base.pas *)

const
  eat_Binary                    = $FFFE;     (* length preceeded binary           *)
  eat_Ascii                     = $FFFD;     (* length preceeded ASCII            *)
  eat_BitMap                    = $FFFB;     (* length preceeded bitmap           *)
  eat_MetaFile                  = $FFFA;     (* length preceeded metafile         *)
  eat_Icon                      = $FFF9;     (* length preceeded icon             *)
  eat_Ea                        = $FFEE;     (* length preceeded ASCII            *)
                                             (* name of associated data           *)
  eat_Mvmt                      = $FFDF;     (* multi-valued, multi-typed field   *)
  eat_Mvst                      = $FFDE;     (* multi-valued, single-typed field  *)
  eat_Asn1                      = $FFDD;     (* ASN.1 field                       *)


procedure ea_einzel_untersuchung(const anfang:dateigroessetyp);

  function ea_block_rekursiv(const titel,doppelpunkt,einrueckung:string;const datentypstart:dateigroessetyp;
                             const org_ea_name:string;laenge_etwa:dateigroessetyp;
                             const typ_ueberschreibung:longint):dateigroessetyp;
    var
      ea_typ            :word_norm;
      anzahl            :longint;
      o                 :dateigroessetyp;
      org_analyseoff    :dateigroessetyp;
      org_einzel_laenge :dateigroessetyp;
      bearbeitete_laenge:dateigroessetyp;
      l                 :longint;
      p                 :puffertyp;
      jetzt             :word_norm;
      z1                :word_norm;
      inhalt            :word_norm;
    begin (* ea_block_rekursiv *)
      org_analyseoff:=analyseoff;
      analyseoff:=datentypstart+4; (* 2 Byte Typ, 2 Byte LÑnge *)
      org_einzel_laenge:=einzel_laenge;

      if typ_ueberschreibung=-1 then
        begin
          ea_typ:=x_word__datei_lesen(datentypstart);
          einzel_laenge:=x_word__datei_lesen(datentypstart+2);
        end
      else
        begin
          ea_typ:=typ_ueberschreibung;
          einzel_laenge:=laenge_etwa;
        end;

      if quelle.sorte=q_datei then
        begin
          exezk:=org_ea_name;
          if Pos('.',exezk)<>1 then
            Insert('.',exezk,1);
          Insert(erzeuge_kurzen_dateinamen,exezk,1);
          (*if (pos('REXX.',org_ea_name)=1) and (laenge_etwa<>-1) then
            befehl_schnitt(analyseoff-4,laenge_etwa,exezk)
          else*)
            befehl_schnitt(analyseoff,einzel_laenge,exezk);
        end;




      case ea_typ of
        $00fe, (* Prominare Designer: PMCX.H (.LASTEDITED) *)
        eat_Binary:
          begin
            ausschrift_x(titel+doppelpunkt+einrueckung+textz_eas__binear^
              +' ('+DGT_str0(einzel_laenge)+')',signatur,ea_zeichen);

            if (org_ea_name='REXX.METACONTROL') then
              begin
                (* OS/2     REXXSAA 4.00 24 Oct 1997 *)
                exezk:=datei_lesen__zu_zk_l(analyseoff+4,33(* einzel_laenge ist nur $c *));
                (* OS/2     REXXSAA 4.00 3 Feb 1999  *)
                if exezk[28]=' ' then
                  Dec(exezk[0]);
                ausschrift_x(in_doppelten_anfuerungszeichen(exezk),beschreibung,absatz);
              end;

            (* REXX.LITERALPOOL *)
            (* REXX.VARIABLEBUF *)
            (* REXX.TOKENSIMAGE *)


            (* sehr eigenwillig ... (wahrscheinlich von WPS erzeugt) D:\OS2\BITMAP\WICKER2.BMP *)
            if org_ea_name='.POSTER' then
              begin
                einzel_laenge:=x_longint__datei_lesen(analyseoff+4);
                IncDGT(analyseoff,12);
                os2_ico(analyseoff,absatz);
              end;


            if (org_ea_name='.CLASSINFO')
            or (org_ea_name='.PREVCLASS') then
              begin
                (*$IfDef dateigroessetyp_comp*)
                if 4+4+einzel_laenge>512 then
                  jetzt:=512
                else
                  jetzt:=DGT_zu_longint(4+4+einzel_laenge);
                (*$Else*)
                jetzt:=4+4+einzel_laenge;
                if jetzt>512 then
                  jetzt:=512;
                (*$EndIf*)
                datei_lesen(p,analyseoff,jetzt);
                ausschrift_x('"'+puffer_zu_zk_e(p.d[8],#0,80)+'" ...',beschreibung,leer);
              end;

            if org_ea_name='GRPHFILEINFO' then
              begin
                datei_lesen(p,analyseoff,4+4+4+2+2);
                bild_format_filter('%'+puffer_zu_zk_e(p.d[0],' ',4),
                  longint_z(@p.d[4])^,
                  longint_z(@p.d[8])^,
                  -1,word_z(@p.d[12])^,
                  false,true,
                  leer);

                (* AnfÅhrungszeichen um die ganze Zeichenkette, aber 24-Bit bringt lange Zahlen
                ausschrift_x(
                  '"'+
                  puffer_zu_zk_e(p.d[0],' ',4)+
                  ' '+
                  str0(longint_z(@p.d[4])^)+
                  ' * '+
                  str0(longint_z(@p.d[8])^)+
                  textz_dien__leerleer_Farben_doppelpunkt_leer^+
                  str0(1 shl word_z(@p.d[12])^)+
                  '"'
                  ,musik_bild,leer);*)
              end
            else if org_ea_name='CURSORPOINT' then (* UpdSig20c / Peter Engels *)
              begin
                datei_lesen(p,analyseoff,4);
                ausschrift_x(str0(p.d[0])+':'+str0(p.d[1]),beschreibung,leer);
              end
            else if org_ea_name='.APPTYPE' then (* LINK386 *)
              begin
                datei_lesen(p,analyseoff,4);

                if odd(p.d[3] shr (14-8)) then
                  exezk:='32 Bit'
                else
                  exezk:='';
                if odd(p.d[3] shr (8-8)) then
                  exezk_anhaengen_komma(textz_eas__Protected_Mode_Library^);
                if odd(p.d[2] shr 7) then
                  exezk_anhaengen_komma(textz_eas__Virtual_Device_Driver^);
                if odd(p.d[2] shr 6) then
                  exezk_anhaengen_komma(textz_eas__Physical_Device_Driver^);
                if odd(p.d[2] shr 5) then
                  exezk_anhaengen_komma('DOS');
                if odd(p.d[2] shr 4) then
                  exezk_anhaengen_komma(textz_eas__Dynamic_Link_Library^);

                case p.d[2] and (bit02+bit01+bit00) of
                  1:exezk_anhaengen_komma(textz_eas__Not_Window_Compatible^);
                  2:exezk_anhaengen_komma(textz_eas__Window_Compatible^);
                  3:exezk_anhaengen_komma(textz_eas__Window_API^);
                end;

                ausschrift_x(exezk,signatur,leer);

              end
            else if (org_ea_name='UID') or (org_ea_name='GID') then
              begin
                ausschrift_x(str0(x_word__datei_lesen(analyseoff)),beschreibung,leer)
              end
            else if org_ea_name='MR.ED.TXTPOS' then
              begin
                ausschrift_x(str0(x_longint__datei_lesen(analyseoff)+1)+':'
                            +str0(x_longint__datei_lesen(analyseoff+4)+1),beschreibung,leer)
              end
            else if Pos('.ASSOCTABLE.',org_ea_name)=1 then
              begin
                datei_lesen(p,analyseoff,2);
                exezk:='0';
                if Odd(p.d[0] shr 0) then exezk_anhaengen('+EAF_DEFAULTOWNER');
                if Odd(p.d[0] shr 1) then exezk_anhaengen('+EAF_UNCHANGEABLE');
                if Odd(p.d[0] shr 2) then exezk_anhaengen('+EAF_REUSEICON');
                if word_z(@p.d[0])^ and (not (1+2+4))<>0 then
                  exezk_anhaengen(hex_word(word_z(@p.d[0])^));
                if Pos('0+',exezk)=1 then
                  Delete(exezk,1,Length('0+'));
                ausschrift_x(einrueckung+exezk,beschreibung,leer)

              end
            else if org_ea_name='.CHECKSUM' then
              begin (* nur 4 Byte Benutzt, siehe UNIMAINT OS2.INI PMWP_ASSOC_CHECKSUM explain *)
                datei_lesen(p,analyseoff,4);
                ausschrift_x(einrueckung+hex_longint(longint_z(@p.d[0])^),beschreibung,leer)
              end;


          end;

        $00fd, (* Prominare Designer: EXAMPLE.PDF (.TYPE,.VERSION,.HISTORY,.COMMENTS) *)
        eat_Ascii:
          begin
            (* einzellÑnge besser bestimmbar: *)
            if titel<>'' then
              ausschrift_x(titel+doppelpunkt+einrueckung+textz_eas__Text^,beschreibung,ea_zeichen);
            ansi_anzeige(analyseoff,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
              leer,wahr,falsch(*Warpin: TMF mit #10 Umbruch*),analyseoff+einzel_laenge,einrueckung);
          end;

        eat_BitMap:
          begin
            ausschrift_x(titel+doppelpunkt+einrueckung+'BMP',musik_bild,ea_zeichen);
            os2_ico(analyseoff,absatz);
          end;

        eat_Icon:
          begin
            ausschrift_x(titel+doppelpunkt+einrueckung+'ICO',musik_bild,ea_zeichen);
            os2_ico(analyseoff,absatz);
          end;

        eat_Mvmt:
          begin (* ".TYPE" *)
            einzel_laenge:=laenge_etwa;(* fÅr ASSOCTABLE *)
            ausschrift_x(titel+doppelpunkt+einrueckung+textz_eas__mvmt^,beschreibung,ea_zeichen);

            anzahl:=x_word__datei_lesen(datentypstart+2);
            if anzahl=0 then
              begin
                anzahl:=x_word__datei_lesen(datentypstart+4);
                o:=datentypstart+6; (* 2 Byte Typ,2 Byte LÑnge(0),2 Byte Anzahl *)
                for z1:=1 to anzahl do
                  begin
                    bearbeitete_laenge:=ea_block_rekursiv('','',einrueckung+'  ',o,org_ea_name+'.'+Str0(z1),einzel_laenge,-1);
                    IncDGT(o,bearbeitete_laenge);
                    DecDGT(einzel_laenge,bearbeitete_laenge);
                  end;
                einzel_laenge:=o-4-datentypstart; (* ohne "Kopf" (4) *)
              end
            else
              begin
                o:=datentypstart+4;
                for z1:=1 to anzahl do
                  begin
                    bearbeitete_laenge:=ea_block_rekursiv('','',einrueckung+'  ',o,org_ea_name+'.'+Str0(z1),einzel_laenge,-1);
                    IncDGT(o,bearbeitete_laenge);
                    DecDGT(einzel_laenge,bearbeitete_laenge);
                    if einzel_laenge<0 then
                      Break;
                  end;
                einzel_laenge:=o-4-datentypstart; (* ohne Kopf (4) *)
              end;
          end;

        eat_Mvst:
          begin
            einzel_laenge:=laenge_etwa;(* fÅr ASSOCTABLE *)
            ausschrift_x(titel+doppelpunkt+einrueckung+textz_eas__mvst^,beschreibung,ea_zeichen);

            anzahl:=x_word__datei_lesen(datentypstart+4);
            ea_typ:=x_word__datei_lesen(datentypstart+6);
            o:=datentypstart+8;
            case ea_typ of
              eat_Ascii:
                while anzahl>0 do
                  begin (* IBM.IWFMMAKE.FILES *)
                    l:=x_word__datei_lesen(o);
                    IncDGT(o,2);
                    ansi_anzeige(o,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
                      leer,wahr,falsch,analyseoff+o+l,einrueckung);
                    IncDGT(o,l);
                    Dec(anzahl);
                  end;
            else
              {?}
            end;

          end;

      else
        ausschrift_x(titel+doppelpunkt+einrueckung
          +'(T='+hex_word(ea_typ)+',L='+hex_word(
            (*$IfDef dateigroessetyp_comp*)
            DGT_zu_longint(einzel_laenge)
            (*$Else*)
            einzel_laenge
            (*$EndIf*)
              )+')',signatur,ea_zeichen);

        (*$IfNDef ENDVERSION*)
        if  (Pos('REXX.',titel)<>1)
        and (Pos('ACHVCHK',titel)<>1)
        and (Pos('MR.ED.TXTPOS',titel)<>1)
         then
          begin
            (*runerror(986);*)
            ausschrift_x('unbekanntes erweitertes Attribut',virus,absatz);
          end;
        (*$EndIf*)

      end; (* CASE *)

      ea_block_rekursiv:=einzel_laenge+4;

      analyseoff:=org_analyseoff;
      einzel_laenge:=org_einzel_laenge;
    end; (* ea_block_rekursiv *)

  var
    kopf_puffer :puffertyp;
    nameende    :word_norm;
    datenlaenge :word_norm;
    ea_name0,
    ea_name1    :string;
    eat,eal     :word_norm;
    critical    :boolean;

  begin (* ea_einzel_untersuchung *)
    datei_lesen(kopf_puffer,anfang,512);
    critical:=Odd(kopf_puffer.d[0] shr 7);
    nameende:=kopf_puffer.d[1]+5;
    datenlaenge:=word_z(@kopf_puffer.d[2])^;
    ea_name0:=puffer_zu_zk_l(kopf_puffer.d[4],kopf_puffer.d[1]);
    ea_name1:=ea_name0;
    leerzeichenerweiterung(ea_name1,Length('.CLASSINFO'));
    if critical then
      zk_anhaengen(ea_name1,' [critical EA] ')
    else
      zk_anhaengen(ea_name1,' [EA] ');

    if dateilaenge<anfang+nameende+datenlaenge then
      begin
        ausschrift_x(ea_name1+textz_eas__DEFEKT_LAENGE^,dat_fehler,ea_zeichen);
        Exit;
      end;

    eat:=x_word__datei_lesen(anfang+nameende+0);
    eal:=x_word__datei_lesen(anfang+nameende+2);

    (* REXX hat sie verpfuscht *)
    if Pos('REXX.',ea_name0)=1 then
      begin
        ea_block_rekursiv(ea_name1,': ','',anfang+nameende-4,ea_name0,datenlaenge,eat_Binary);
        Exit;
      end;

    (* WÅrg-Around fÅr .poster - unbekannte Anwendung MM-WPS? Leuchttisch? *)
    if (ea_name0='.POSTER') (* Informationen + BMP *)
    or (ea_name0='UID') (* hpfs? Name ohne '.', also lieber nichtt maulen *)
    or (ea_name0='GID') (* hpfs? Name ohne '.', also lieber nichtt maulen *)
     then
      begin
        ea_block_rekursiv(ea_name1,': ','',anfang+nameende-4,ea_name0,datenlaenge,eat_Binary);
        Exit;
      end;

    (* richtig *)
    if datenlaenge>=eal then
      case eat of
        eat_Binary,eat_Ascii,eat_BitMap,
        eat_MetaFile,eat_Icon,eat_Ea,
        eat_Mvmt,eat_Mvst,eat_Asn1:
          begin
            ea_block_rekursiv(ea_name1,': ','',anfang+nameende,ea_name0,datenlaenge,-1);
            Exit;
          end;
      end;

    (* alle anderen sollen sich gefÑlligst an das Format halten! *)
    ausschrift_x(ea_name1+textz_eas__DEFEKT_TYP_LEANGE^,dat_fehler,ea_zeichen);

    if (ea_name0='.FEDSTATE') (* immer falsch *)
    or (ea_name0='.VERSION') (* acarco0.fnt *)
     then
      begin
        ea_block_rekursiv(ea_name1,': ','',anfang+nameende-4,ea_name0,datenlaenge,eat_Ascii);
        Exit;
      end;

    if ea_name0='.ICON' then
      begin
        if eal=Ord('I')+Ord('C') shl 8 then (* WLO-Installation *)
          ea_block_rekursiv(ea_name1,': ','',anfang+nameende  ,ea_name0,datenlaenge,eat_Icon)
        else (* vielleicht fehlerhaftes RC.EXE *)
          ea_block_rekursiv(ea_name1,': ','',anfang+nameende-4,ea_name0,datenlaenge,eat_Icon);
        Exit;
      end;

    if ea_name0='MR.ED.TXTPOS' then
      begin
        ea_block_rekursiv(ea_name1,': ','',anfang+nameende-4,ea_name0,datenlaenge,eat_Binary);
        Exit;
      end;


  end; (* ea_einzel_untersuchung *)


procedure ea_block_eautil(const start:dateigroessetyp);
  var
    bpuffer:puffertyp;
    posi,ende:dateigroessetyp;
  begin
    ende:=start+x_longint__datei_lesen(start);
    posi:=start+4;

    repeat
      datei_lesen(bpuffer,posi,4);
      ea_einzel_untersuchung(posi);
      IncDGT(posi,bpuffer.d[1]+word_z(@bpuffer.d[2])^+5);
    until posi=ende;
  end;

end.

