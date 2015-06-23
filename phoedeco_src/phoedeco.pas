{$I+}
{&Use32+}
{$M 42000}

program phoenix_nubios_decoder;

(* 1998.04.02 TP fÅr 'BC'#$d6#$f1                                       *)
(* 2000.10.03 VP m0/m2/m5 hinzugefÅgt                                   *)
(* 2000.10.07 lzh5x                                                     *)
(* 2001.04.05..06 m4                                                    *)
(* 2002.07.30 m3                                                        *)
(* 2003.11.02 2460v105.rom mit eeprom-tabelle und flash?                *)
(* 2005.03.15 D1042_00.1 suche nach zusÑtzlichen Blîcken                *)
(*            zielpuffer 1M, damit VGA-Logo nichts Åberschreibt         *)
(*            alle Dateien (2460v105.rom) im Zielverzeichnis ablegen    *)
(*            Anbieten Entpacken von Blîcken ohne Kopf                  *)
(*            letztes Byte von D1042_00.OMF ignorieren                  *)
(*            UnterstÅtzung fragmentierter komprimierter Daten (!)      *)
(* 2005.03.16 Verschiedene Kompressionsverfahren fÅr 'BC'#$d6#$f1       *)
(*            Tauschen C0000/E0000 fÅr 968B0501.BIN                     *)
(*            $FIX-Block beachten                                       *)
(*            rom_.scr schreiben (funktioniert nicht)                   *)
(*            fragmentierte Daten auch ohne Kompression                 *)
(*            pushad/popad fÅr m4                                       *)
(* 2005.03.17 Entpacken von 1Mi+$13c6 gro·en Dateien (Flash-Anhang)     *)
(*            Seitenwechsel                                             *)
(*            Wahrscheinlichkeit BlockerprÅfung angepa·t (P14-0095.BIO) *)
(* 2006.01.04..12 Kennfehler durch Raten von xor $20000 bei             *)
(*           ftp://aiedownload.intel.com/df-support/364/eng/bios_12.exe *)
(*            behoben                                                   *)
(* 2006.04.25 Kettenfehler bei Fujitsu-Siemens Computer D1219 umgangen:
              LÑnge eingepackt/ausgepackt hat dort in Bit 24..31 nicht 0*)

uses
  bcd6f1,
  m2,
  m3,
  m4,
  m5,
  phoe_spr,
  Dos,
  MkDir2,
  Strings,
  VpSysLow,
  VpUtils;

const
  datum                 ='1998.04.02..2006.01.13';
  dateizaehler          :longint=0;
  neue_basisadresse_erforderlich :boolean=false;
  min_ladeadresse       :longint=1024*1024;
  need_WriteLn          :boolean=false;
  benutzte_kompressionsmethode:byte=0;

  kompressionsverfahren:array[0..5] of string[8]=
    ('NONE',
     'ERROR',
     'LZARI',
     'LZSS',
     'LZHUF',
     'LZINT');

  seiten_groesse        :longint=256*1024;

type
  c6                    =array[1..6] of char;
  bcd6f1_kopf           =
    packed record
      kennung1          :longint;
      kennung2          :smallword;
      kopflaenge        :byte;
      db07              :byte;
      zielsegment       :smallword;
      laenge_ausgepackt :longint;
      laenge_eingepackt :longint;
    end;

  phoenix_kopf          =
    packed record
(*00*)nachfolger        :Longint;
(*04*)seitenwechsel     :Byte;
(*05*)u5                :array[5..6] of Char; (* '1','1' *)
(*07*)block_nummer      :Byte;
(*08*)block_typ         :Char;
(*09*)kopflaenge        :Byte;
(*0a*)kompression       :Byte;
(*0b*)zieladresse       :Longint;
(*0f*)laenge_ausgepackt :Longint;
(*13*)laenge_eingepackt :Longint;
(*17*)teil2_adresse     :Longint;
(*1b*)
    end;

  ibm_rom_kopf          =
    packed record
      kennung           :smallword;
      anzahl512         :byte;
    end;

  bcpsys_kopf           =
    packed record
      kennung           :c6;
      version           :smallword;
      laenge            :smallword;
      u_0a              :array[$0a..$76] of byte;
      l77               :longint;
      l7b               :smallword; (* KiB *)
    end;

  acfg_kopf             =
    packed record
      laenge            :smallword;
      kennung           :array[1..4] of char;
      version_minor     :byte;
      version_major     :byte;
    end;

  standard_kompression_kopf=
    packed record
      laenge_eingepackt :longint;
    end;

  teil2_kopf            =
    packed record
      teil3adresse      :longint;
      teil3seite        :byte;
      laenge_eingepackt2:longint;
    end;

  bcpcmp_kopf           =
    packed record
(*00*)kennung                           :c6;            (* BCPCMP *)
(*06*)version                           :smallword;     (* $0102 *)
(*08*)laenge                            :smallword;     (* $0021 *)
(*0a*)compression_flags                 :byte;          (* $3f *)
(*0b*)algorithmus_bit                   :byte;          (* 1+2+.. *)
(*0c*)non_compressed_offset             :smallword;
(*0e*)size_compressed_data              :longint;       (* 100672 *)
(*12*)start_segment_of_BIOS_located     :smallword;     (* $1000 *)
(*14*)start_segment_of_BIOS_work_area   :smallword;     (* $3000 *)
(*16*)low_memory_start                  :smallword;     (* $4000 *)
(*18*)low_memory_size                   :smallword;     (* $0100 *)
(*1a*)common_character_for_LZSS         :byte           (* $20 *)
(*1b*)
    end;

  bcpcmp_kopf_alt       =
    packed record
(*00*)kennung                           :c6;            (* BCPCMP *)
(*06*)version                           :smallword;     (* $0000 *)
(*08*)laenge                            :smallword;     (* $0015 *)
(*0a*)compression_flags                 :byte;          (* $09 *)
(*0b*)algorithmus_bit                   :byte;          (* $01 *)
(*0c*)size_compressed_data              :longint;       (* $35000 *)
(*10*)o_5000                            :smallword;     (* $5000 *)
(*12*)start_segment_of_BIOS_work_area   :smallword;     (* $2000 *)
(*14*)common_character_for_LZSS         :byte           (* $20 *)
(*15*)
    end;

  fix_block             =
    packed record
      block_typ         :char;
      adresse           :longint;
      laenge            :longint;
    end;

  omf_kopf              =
    packed record
      b2                :byte;
      omflaenge         :longint;
      datum             :array[1..32] of char;
      u25               :array[$25..$32] of byte;
      modell            :array[1..8] of char;
      u3b               :array[$3b..$67] of byte;
      zieladresse       :longint;
      laenge            :longint;
    end;

var
  d1                    :file;
  ziel                  :array[0..$fffff] of byte;
  rom                   :array[0..$fffff] of byte;
  quellzeiger           :pointer;
  quell_laenge          :longint;
  kopie                 :array[0..$fffff] of byte;
  dateilaenge           :longint;
  logischer_anfang      :longint;
  suchposition,arbeit   :longint;
  quellverzeichnis,
  quellname,
  quellerweiterung,
  dateiname             :string;
  zielverzeichnis       :string;
  ladeadresse           :longint;

  ami_flash_kopf        : (* I: T00544 *)
    packed record
      kommentar         :array[0..31] of char;
      Logical_area_type :byte;
      logical_area_size :longint;
      load_from_file    :byte;
      reboot_after_update:byte;
      update_entire_image:byte;
      logical_area_name :array[0..23] of char;
      time_stamp        :array[0..14] of char;
      checksum_for_this_header:byte;
      offset_in_image   :longint;
      size_of_image_chunk:longint;
      logical_area_type2:byte;
      last_file_in_chain:byte;
      signature         :array[0..5] of char;
      filename_of_next_file:array[0..15] of char;
      BIOS_reserved     :array[0..15] of char;
    end;

  fuell_tabelle         :array[1..1000] of
    record
      o,l               :longint;
    end;
  fuell_tabelle_benutzt :word;

  try_unpack_str        :string;

  verschiebung          :longint;

  anzahl_entpackt       :word;

  scr                   :text;
  scr_offen             :boolean=false;
  scr_command1          :string;
  scr_command2          :string;

  fixed_tabelle         :array[1..100] of
    record
      eintrag_benutzt   :boolean;
      adresse           :longint;
      laenge            :longint;
      block_typ         :char;
    end;

  implementierte_alg    :byte;
  noncompressed_off,
  noncompressed_len     :longint;
  bcpcmp_vorhanden      :boolean;

  dateinamen_tabelle    :array[1..1000] of string[8+1+3];
  dateinamen_tabelle_benutzt:word;

  omf                   :omf_kopf;

procedure oeffne_scr;
  begin
    Assign(scr,zielverzeichnis+'rom_.scr');
    Rewrite(scr);
    scr_offen:=true;
  end;

procedure schreibe_scr(const s:string);
  begin
    if scr_offen then
      WriteLn(scr,s);
  end;

procedure schliesse_scr;
  begin
    if scr_offen then
      begin
        Close(scr);
        scr_offen:=false;
      end;
  end;

function gleich_c6(const k1,k2:c6):boolean;
  begin
    gleich_c6:=StrLComp(@k1,@k2,SizeOf(c6))=0;
  end;

procedure merke_fixed(const no,nl:longint;const nt:char);
  var
    i                   :word;
  begin
    if no+nl>$100000 then Exit;
    for i:=Low(fixed_tabelle) to High(fixed_tabelle) do
      with fixed_tabelle[i] do
        if not eintrag_benutzt then
          begin
            eintrag_benutzt:=true;
            adresse:=no;
            laenge:=nl;
            block_typ:=nt;
            Break;
          end;
  end;

function suche_adresse_fixed(const o:longint;var f_adresse:longint):boolean;
  var
    i                   :word;
  begin
    suche_adresse_fixed:=false;
    for i:=Low(fixed_tabelle) to High(fixed_tabelle) do
      with fixed_tabelle[i] do
        if eintrag_benutzt and (o=adresse and $000fffff) then
          begin
            suche_adresse_fixed:=true;
            eintrag_benutzt:=false;
            f_adresse:=adresse;
            Break;
          end;
  end;


procedure vermerke_in_fuelltabelle(const no,nl:longint);
  begin
    if no+nl>$100000 then Exit;
    if fuell_tabelle_benutzt<High(fuell_tabelle) then
      begin
        Inc(fuell_tabelle_benutzt);
        with fuell_tabelle[fuell_tabelle_benutzt] do
          begin
            o:=no;
            l:=nl;
          end;
      end;
  end;

procedure bearbeite_fuelltabelle;
  begin
    while fuell_tabelle_benutzt>=Low(fuell_tabelle) do
      begin
        with fuell_tabelle[fuell_tabelle_benutzt] do
          FillChar(rom[o],l,0);
        Dec(fuell_tabelle_benutzt);
      end;
  end;

function frage_adresse(const vorschlag:longint):longint;
  var
    antwort             :string;
    ergebnis            :longint;
    kontrolle           :longint;
  begin
    repeat
      Write('[$',Int2Hex(vorschlag,5),'] ? ');

      if Eof(input) then
        antwort:=''
      else
        ReadLn(antwort);

      Write(^m);

      if antwort='' then
        begin
          kontrolle:=0;
          ergebnis:=vorschlag;
        end
      else
        Val(antwort,ergebnis,kontrolle);

    until kontrolle=0;
    frage_adresse:=ergebnis;
  end;


function biostyp_alt(const t:byte):string;
  var
    tmp:string;
  begin
    case t of
      2:tmp:='Setup_2';
      3:tmp:='Setup_3';
      4:tmp:='Suspend'; (* Aber auch animiertes EPA-Logo *)
      5:tmp:='VGA';
      9:tmp:='POST'; (* BOOT? *)
    else
      Str(t,tmp);
    end;

    while Length(tmp)<12 do
      tmp:=tmp+' ';

    biostyp_alt:=tmp;
  end;

function biostyp_m025(const c:char;const nummer:byte):string;
  var
    tmp:string;
  begin
    case c of
      '?':tmp:='TCPA'; (* ? *)
      'A':tmp:='ACPI'; (*'DSDT,FACP'*)
      'B':tmp:='BIOSCode'; (* (EPP,..) *)
      'C':tmp:='CPU'; (*UPDATE*)
      'D':tmp:='Display';
      'E':tmp:='Setup' (* 'Editor' *);
      'F':tmp:='Font'; (* 8x8 *)
      'G':tmp:='DeCompCode';
      'H':tmp:='USB';
      'I':tmp:='BootBlock';
    (*'J'*)
    (*'K'*)
      'L':tmp:='Logo';
      'M':tmp:='Suspend';(*MISER*)
      'N':tmp:='ROMPilotLoad';
      'O':tmp:='Network';
      'P':tmp:='ROMPilotInit';
    (*'Q':tmp:='Q-(TCPA?)';*)
      'R':tmp:='OpROM'; (* R=Trend Micro,VGA *)
      'S':tmp:='Strings'; (* 'STRPACK' *)
      'T':tmp:='Template';
      'U':tmp:='User';
      'V':tmp:='PLHOLDER(?)';
      'W':tmp:='Wave';
      'X':tmp:='ROMExec';
    (*'Y'*)
    (*'Z'*)
    else
      tmp:=c;
    end;

    if nummer<>0 then
      tmp:=tmp+'.'+Int2Str(nummer{+1});

    while Length(tmp)<12 do
      tmp:=tmp+' ';

    biostyp_m025:=tmp;

  end;

const
  modultypen_nicht_packbar=['G','X','C'];
  modultypen_syntax:array[1..18] of record t:char;n:string[Length('ROMPILOTLOAD')] end=
    ((t:'A';n:'ACPI'),
     (t:'B';n:'BIOSCODE'),
     (t:'C';n:'UPDATE'),
     (t:'D';n:'DISPLAY'),
     (t:'E';n:'SETUP'),
     (t:'G';n:'DECOMPCODE'),
     (t:'I';n:'BOOTBLOCK'),
     (t:'L';n:'LOGO'),
     (t:'M';n:'MISER'),
     (t:'N';n:'ROMPILOTLOAD'),
     (t:'O';n:'NETWORK'),
     (t:'P';n:'ROMPILOTINIT'),
     (t:'R';n:'OPROM'),
     (t:'S';n:'STRINGS'),
     (t:'T';n:'TEMPLATE'),
     (t:'U';n:'USER'),
     (t:'W';n:'WAV'),
     (t:'X';n:'ROMEXEC'));
(* HOLE, MODULE, ESCD, ESCDBANK, RESETVEC *)

procedure bestimme_dateiname(const c:char;const nummer:byte);
  var
    i                   :word;
  begin
    scr_command1:='';
    scr_command2:='';
    for i:=Low(modultypen_syntax) to High(modultypen_syntax) do
      with modultypen_syntax[i] do
        if c=t then
          begin
            scr_command1:=n;
            Break;
          end;

    if scr_command1='' then
      begin
        scr_command1:='MODULE';
        dateiname:='MOD__'+Int2Hex(Ord(c) shl 4+nummer,3);
        if c in ['A'..'Z'] then
          scr_command2:=' -C:'+c+Int2Hex(nummer,1)
        else
          scr_command2:=' -C:0x'+Int2Hex(Ord(c) shl 4+nummer,3)
      end
    else
      dateiname:=Copy(scr_command1+'_______',1,7)+Int2Hex(nummer,1);

    while Length(scr_command1)<14 do scr_command1:=scr_command1+' ';

  end;

procedure speichere(var e;const l:longint);
  var
    d2                  :file;
    ea                  :array[0..1000] of byte absolute e;
    i                   :word;
  begin
    if Pos('.',dateiname)=0 then
      begin
        if (ea[0]=1) and (ea[1]=0) and (ea[2]=0) and (ea[3]=0) and (ea[8] in [$00..$99])
           and (ea[9] in [$19,$20])                  then dateiname:=dateiname+'.cpu'
        else (* option rom header .. *)
        if (ea[0]=Ord('O')) and (ea[1]=Ord('R')) and (ea[2]=0) and (ea[3]=0)
                                                     then dateiname:=dateiname+'.oro'
        else
        if StrLComp(@e,'PG'     ,Length('PG'    ))=0 then dateiname:=dateiname+'.pgx'
        else
        if StrLComp(@e,'BM'     ,Length('BM'    ))=0 then dateiname:=dateiname+'.bmp'
        else
        if StrLComp(@e,#$55#$aa ,Length(#$55#$aa))=0 then dateiname:=dateiname+'.rom'
        else
        if StrLComp(@e,'DSDT'   ,Length('DSDT'  ))=0 then dateiname:=dateiname+'.dsd'
        else
        if StrLComp(@e,'TCPA'   ,Length('TCPA'  ))=0 then dateiname:=dateiname+'.tcp'
        else
        if StrLComp(@e,'ECDT'   ,Length('ECDT'  ))=0 then dateiname:=dateiname+'.ecd'
        else
        if StrLComp(@e,'SSDT'   ,Length('SSDT'  ))=0 then dateiname:=dateiname+'.ssd'
        else
        if StrLComp(@e,'FACP'   ,Length('FACP'  ))=0 then dateiname:=dateiname+'.fac'
        else
        if StrlComp(@e,'$INI'   ,Length('$INI'  ))=0 then dateiname:=dateiname+'.edi'
        else
        if StrlComp(@e,'$FIX'   ,Length('$FIX'  ))=0 then dateiname:=dateiname+'.fix'
        else
        if StrlComp(@e,'STRPA'  ,Length('STRPA' ))=0 then dateiname:=dateiname+'.str'
        else
                                                          dateiname:=dateiname+'.dec';

      end;

    (* Vermeidung doppelter Dateinamen - Beispiel:zusÑtzliche BIOSCOD0.dec *)
    for i:=Low(dateinamen_tabelle) to dateinamen_tabelle_benutzt do
      if dateinamen_tabelle[i]=dateiname then
        dateiname:=Int2StrZ(dateinamen_tabelle_benutzt+1,8)+'.unq';

    if dateinamen_tabelle_benutzt<High(dateinamen_tabelle_benutzt) then
      begin
        Inc(dateinamen_tabelle_benutzt);
        dateinamen_tabelle[dateinamen_tabelle_benutzt]:=dateiname;
      end;

    Write(dateiname,' ');
    Assign(d2,zielverzeichnis+dateiname);
    FileMode:=$41;
    Rewrite(d2,1);
    Blockwrite(d2,e,l);
    Close(d2);
    WriteLn;

    if StrlComp(@e,'$FIX'   ,Length('$FIX'  ))=0 then
      if ((l-4) mod 9)=0 then
        begin

          i:=4;
          while i<l do
            with fix_block(ea[i]) do
              begin
                merke_fixed(adresse,laenge,block_typ);
                Inc(i,SizeOf(fix_block));
              end;

          (* FIX wird nicht im *.SCR gespeichert! *)
          dateiname:='';
          scr_command1:='';
          scr_command2:='';
        end;

  end;


procedure WriteLn_if_needed;
  begin
    if need_WriteLn then
      begin
        WriteLn;
        need_WriteLn:=false;
      end;
  end;

procedure oeffne_datei;
  begin
    Write(dateiname,' ');need_WriteLn:=true;
    Assign(d1,dateiname);
    FileMode:=$40;
    Reset(d1,1);
    Inc(dateizaehler);
  end;

procedure standardkompression(const o:longint);
  var
    l,i                 :longint;
    h                   :array[byte] of longint;
    c                   :char;
  begin
    l:=standard_kompression_kopf(rom[o]).laenge_eingepackt;
    if o>SizeOf(rom)-4 then Exit;
    if (l<=0) or (l>SizeOf(rom)-o-4) then Exit;
    FillChar(h,SizeOf(h),0);
    if (pLongint(@rom[o+SizeOf(teil2_kopf)])^=0) then Exit;
    for i:=o+4+0 to o+4+l-1 do
      Inc(h[rom[i]]);
    for i:=Low(h) to High(h) do
      //if h[i]>(l div 256)*20+20 then Exit;
      if h[i]>(l div 256)*4+10 then Exit;

    Write(Int2Hex(o,8),' ',Int2Hex(l,8),' ',Int2Hex(benutzte_kompressionsmethode,2),' ',Int2Hex($10000,8),' ',textz_no_header^,'':16);
    Write(textz_versuchen^);
    if try_unpack_str[1] in ['J','N'] then
      begin
        c:=try_unpack_str[1];
        WriteLn(c)
      end
    else
      ReadLn(c);
    if UpCase(c)='N' then Exit;
    Write(Int2Hex(o,8),' ',Int2Hex(l,8),' ',Int2Hex(benutzte_kompressionsmethode,2),' ',Int2Hex($10000,8),' ',textz_no_header^,'':12,' -> ');
    dateiname:=Int2Hex(o,8);
    dateiname[1]:='r';
    case benutzte_kompressionsmethode of
      2:
        begin
          entpacke_m2(rom[o+4],ziel,l);
          speichere(ziel,$10000);
          vermerke_in_fuelltabelle(o,4+l);
        end;
      3:
        begin
          entpacke_m3(rom[o+4],ziel,l);
          speichere(ziel,$10000);
          vermerke_in_fuelltabelle(o,4+l);
        end;
      4:
        begin
          entpacke_m4(rom[o+4],ziel,l,$10000);
          speichere(ziel,$10000);
          vermerke_in_fuelltabelle(o,4+l);
        end;
      5:
        begin
          entpacke_m5(rom[o+4],ziel,l,$10000);
          speichere(ziel,$10000);
          vermerke_in_fuelltabelle(o,4+l);
        end;
    else
      WriteLn('?');
    end;
  end;

procedure wechsele_seiten(b:byte);
  var
    verschiebung_neu    :longint;
  begin
    verschiebung_neu:=b*-seiten_groesse;
    if verschiebung<>verschiebung_neu then
      begin
        (*WriteLn('Seitenwechsel: -'+Int2Hex(-verschiebung,8));*)
        verschiebung:=verschiebung_neu;
      end;
  end;

function gueltiger_teil2_kopf(const o:longint;const gepackt:boolean):boolean;
  var
    i                   :longint;
    h                   :array[byte] of longint;
    c                   :char;
  begin
    gueltiger_teil2_kopf:=false;
    if (o>$ffe00) or (o<0) then Exit;
    with teil2_kopf(rom[o]) do
      begin
        if ((teil3seite shr 4)<>0) then Exit;
        if (teil3adresse<>0) and ((teil3adresse shr 20)<>$fff) then Exit;
        if (laenge_eingepackt2<1) or (laenge_eingepackt2>$ffff) then Exit;
        if (o+SizeOf(teil2_kopf)+laenge_eingepackt2>=SizeOf(rom)) then Exit;
        if gepackt then
          begin
            if (pLongint(@rom[o+SizeOf(teil2_kopf)])^=0) then Exit;
            FillChar(h,SizeOf(h),0);
            for i:=o+SizeOf(teil2_kopf)+0 to o+SizeOf(teil2_kopf)+laenge_eingepackt2-1 do
              Inc(h[rom[i]]);
            for i:=Low(h) to High(h) do
              if h[i]>(laenge_eingepackt2 div 256)*20+20 then
                Exit;
          end;
      end;
    gueltiger_teil2_kopf:=true;
  end;

function gueltiger_phoenix_kopf_neu(const o:longint):boolean;
  begin
    gueltiger_phoenix_kopf_neu:=false;
    with phoenix_kopf(rom[o]) do
      begin
        if kopflaenge <> SizeOf(phoenix_kopf) then
          Exit;

        (* for Fujitsu-Siemens Computer D1219 *)
        if  (kompression in [0..5])
        and (u5[5]='1')
        and (u5[6]='1') then
          begin
            laenge_eingepackt := laenge_eingepackt and $00ffffff;
            laenge_ausgepackt := laenge_ausgepackt and $00ffffff;
          end;

        if kompression<>0 then
          if (laenge_eingepackt<1) or (o+kopflaenge+laenge_eingepackt>SizeOf(rom)) then
            Exit;
        if (laenge_ausgepackt<1) or (laenge_ausgepackt>1024*1024) then
          Exit;
      end;
    gueltiger_phoenix_kopf_neu:=true;
  end;

procedure bearbeite_block(bezugsbasis:longint);
  var
    n,n_alt             :longint;
    f_adresse           :longint;
  begin

{
    if (verschiebung<>0)
    and (not gueltiger_phoenix_kopf_neu(arbeit))
    and (    gueltiger_phoenix_kopf_neu(arbeit-verschiebung)) then
      begin
        Dec(arbeit,verschiebung);
        verschiebung:=0;
      end;}

    (* Intel(1999): bios_12.exex\P12-0012.BIO F0000->C4A99->E4A99 *)
    if not gueltiger_phoenix_kopf_neu(arbeit) then
      if arbeit>$20000 then
        if gueltiger_phoenix_kopf_neu(arbeit-$20000) then
          Dec(arbeit,$20000);

    (* Intel(1999): bios_12.exex\P12-0012.BIO D4776->CEBF4->EEBF4 *)
    if not gueltiger_phoenix_kopf_neu(arbeit) then
      if arbeit<$e0000 then
        if gueltiger_phoenix_kopf_neu(arbeit+$20000) then
          Inc(arbeit,$20000);

    if not gueltiger_phoenix_kopf_neu(arbeit) then
      begin
        WriteLn(textz_kettenfehler^,' (',Int2Hex(arbeit,8),')');
        (*Halt(1);*)
        arbeit:=0;
        Exit;
      end;

    with phoenix_kopf(rom[arbeit]) do
      begin

        vermerke_in_fuelltabelle(arbeit,kopflaenge);

        Write(Int2Hex(bezugsbasis+arbeit,8),' ',Int2Hex(laenge_eingepackt,8),' ',Int2Hex(kompression,2),' ',Int2Hex(laenge_ausgepackt,8),
              ' ',biostyp_m025(block_typ,block_nummer),' ');
        if zieladresse=0 then
          Write('-        ')
        else
          Write(Int2Hex(zieladresse,8),' ');

        if scr_offen then
          begin
            bestimme_dateiname(block_typ,block_nummer);
            if suche_adresse_fixed(arbeit,f_adresse) then
              scr_command2:=scr_command2+' -A:0x'+Int2Hex(f_adresse,8);
          end
        else
          begin
            if zieladresse=0 then
              begin
                dateiname:=Int2Hex(bezugsbasis+arbeit,8);
                dateiname[1]:='r';
              end
            else
              dateiname:=Int2Hex(zieladresse,8);
          end;

        FillChar(ziel,SizeOf(ziel),0);

        quellzeiger:=@rom[arbeit+kopflaenge];
        quell_laenge:=laenge_eingepackt;
        vermerke_in_fuelltabelle(arbeit+kopflaenge,laenge_eingepackt);

        if (kopflaenge>=SizeOf(phoenix_kopf))
        and ((teil2_adresse shr 20)=$fff)
        and ((teil2_adresse and $fffff)>logischer_anfang) then
          begin
            Move(quellzeiger^,kopie[0],laenge_eingepackt);
            n:=teil2_adresse and $fffff;
            n_alt:=arbeit;
            (* fÅr D1042_00.OMF: E0000 *)
            wechsele_seiten(seitenwechsel shr 4);
            repeat

{
              (* D1042_00.OMF *)
              if (n_alt=$e0000) then
              if (n>$20000)
              and (not gueltiger_teil2_kopf(n       ,kompression<>0))
              and (    gueltiger_teil2_kopf(n-$20000,kompression<>0)) then
                Inc(verschiebung,-$20000);}

              Inc(n,verschiebung);

              if not gueltiger_teil2_kopf(n,kompression<>0) then
                if gueltiger_teil2_kopf(n xor $20000,kompression<>0) then
                  begin
                    n:=n xor $20000;
                  end;


              if gueltiger_teil2_kopf(n,kompression<>0) then
                with teil2_kopf(rom[n]) do
                  begin
                    WriteLn('+');
                    Write(Int2Hex(bezugsbasis+n,8),' ',Int2Hex(laenge_eingepackt2,8),' ',Int2Hex(kompression,2),'':1+8+1+12+1+8+1);
                    Move(rom[n+SizeOf(teil2_kopf)],kopie[quell_laenge],laenge_eingepackt2);
                    Inc(quell_laenge,laenge_eingepackt2);
                    vermerke_in_fuelltabelle(n,SizeOf(teil2_kopf)+laenge_eingepackt2);
                    n_alt:=n;
                    wechsele_seiten(teil3seite);
                    n:=teil3adresse and $fffff;
                  end
              else
                begin
                  WriteLn(textz_kettenfehler^,' (',Int2Hex(n,8),')');
                  n:=0;
                end;
            until n=0;
            quellzeiger:=@kopie[0];
          end;



        if kompression=0 then
          if not (block_typ in modultypen_nicht_packbar) then
            scr_command2:=scr_command2+' -X';

        case kompression of
          0: (* "NONE" *)
            begin
              Write('=> ');
              speichere(quellzeiger^,laenge_ausgepackt);
            end;
          2: (* "LZARI" *)
            begin
              Write('-> ');
              entpacke_m2(quellzeiger^,ziel,quell_laenge);
              speichere(ziel,laenge_ausgepackt);
              benutzte_kompressionsmethode:=2;
            end;
          3: (* "LZSS" *)
            begin
              Write('-> ');
              entpacke_m3(quellzeiger^,ziel,quell_laenge);
              speichere(ziel,laenge_ausgepackt);
              benutzte_kompressionsmethode:=3;
            end;
          4: (* "LZHUF" *)
            begin
              Write('-> ');
              if entpacke_m4(quellzeiger^,ziel,quell_laenge,laenge_ausgepackt) then
                speichere(ziel,laenge_ausgepackt)
              else
                WriteLn(textz_entpackfehler^);
              benutzte_kompressionsmethode:=4;
            end;
          5: (* "LZINT" *)
            begin
              Write('-> ');
              if entpacke_m5(quellzeiger^,ziel,quell_laenge,laenge_ausgepackt) then
                speichere(ziel,laenge_ausgepackt)
              else
                WriteLn(textz_entpackfehler^);
              benutzte_kompressionsmethode:=5;
            end;
        else
              WriteLn('?',textz_unbekanntes_verfahren^);
        end;

        if dateiname<>'' then
          schreibe_scr(scr_command1+dateiname+scr_command2);

        Inc(anzahl_entpackt);

        if nachfolger=$f1d64342 then
          begin
            arbeit:=arbeit+kopflaenge;
            if kompression=0 then
              arbeit:=arbeit+laenge_ausgepackt
            else
              arbeit:=arbeit+laenge_eingepackt;
          end
        else
          begin
            wechsele_seiten(seitenwechsel and $0f);
            arbeit:=nachfolger;
            if (arbeit<>-1) and (arbeit<>0) then
              Inc(arbeit,verschiebung);
          end;
      end;

    bearbeite_fuelltabelle;
  end;

procedure rohformat(const o,l:longint;const dn:string;const titel:string);
  begin
    if (l<=0) or (l>SizeOf(rom)) or (o<0) or (o+l>SizeOf(rom)) then Exit;
    Write(Int2Hex(o,8),' ',Int2Hex(l,8),' ','--',' ',Int2Hex(l,8),
              ' ',titel,'':25-Length(titel));
    dateiname:=dn;
    speichere(rom[o],l);
    vermerke_in_fuelltabelle(o,l);
  end;

procedure verarbeite_fixed;
  var
    i                   :word;
  begin
    for i:=Low(fixed_tabelle) to High(fixed_tabelle) do
      with fixed_tabelle[i] do
        if eintrag_benutzt then
          begin
            eintrag_benutzt:=false;
            Write(Int2Hex(adresse,8),' ',Int2Hex(laenge,8),'  - ',Int2Hex(laenge,8),' ',
                  biostyp_m025(block_typ,0),' ',Int2Hex(adresse,8),' => ');
            bestimme_dateiname(block_typ,0);
            speichere(rom[adresse and $000fffff],laenge);
            vermerke_in_fuelltabelle(adresse and $000fffff,laenge);
            if block_typ=' ' then
              begin
                scr_command1:='HOLE          ';
                scr_command2:=' -A:0x'+Int2Hex(adresse,8)+' -SB:'+Int2Str(laenge);
              end
            else
              begin
                if not (block_typ in modultypen_nicht_packbar) then
                  scr_command2:=scr_command2+' -X';
                scr_command2:=scr_command2+' -A:0x'+Int2Hex(adresse,8);
              end;
            schreibe_scr(scr_command1+dateiname+scr_command2);
          end;


              end;

procedure bearbeite_BCPSYS_kette;
  begin
    (* Version 6.0 - Blîcke *)
    arbeit:=0;
    for suchposition:=High(rom)-$80 downto 0 do
      with bcpsys_kopf(rom[suchposition]) do
        if  gleich_c6(kennung,'BCPSYS')
        and (laenge>=$77+4) and (laenge<$0800)
        and (version>0) and  (version<$0900)
         then
          begin
            arbeit:=l77;
            if laenge>=$77+4+2 then
              begin
                oeffne_scr;
                schreibe_scr('# Phoedeco '+datum);
                schreibe_scr('BANKS         -N:'+Int2Str((SizeOf(rom)-logischer_anfang) div l7b div 1024)+' -S:'+Int2Str(l7b));
                schreibe_scr('');
                seiten_groesse:=l7b*1024;
                (*WriteLn('L7B: ',l7b,' Ki');*)
              end;
            Break;
          end;

    (* Intel: str_gr.lng *)
    if arbeit=0 then
      with phoenix_kopf(rom[logischer_anfang]) do
        if nachfolger=$acedaced then
          begin
            arbeit:=$fff00000 or logischer_anfang;
            nachfolger:=0;
          end;


    if ((arbeit and $fff00000)<>$fff00000) or (phoenix_kopf(rom[arbeit and $000fffff]).kopflaenge<10) then
      begin
        (* Anker nicht gefunden.
           Wenn einzeldatei, dann brauche ich hier keine Fehlermeldung auszugeben *)
        (*
        if  (rom[logischer_anfang+5]=Ord('1'))
        and (rom[logischer_anfang+6]=Ord('1')) then Exit;
        WriteLn(textz_Anker_nicht_gefunden^);*)
        (*Halt(1);*)
        Exit;
      end;

    repeat

      if (arbeit and $fff00000)<>$fff00000 then
        begin
          WriteLn(textz_kettenfehler^,' (',Int2Hex(arbeit,8),')');
          (*Halt(1);*)
          Break;
        end;

      arbeit:=arbeit and $000fffff;

      bearbeite_block(0);

    until arbeit=0;
  end;

label
  geladen;

begin
  WriteLn(^m'PHOEDECO * V.K. * ',datum);

  FillChar(dateinamen_tabelle,SizeOf(dateinamen_tabelle),0);
  dateinamen_tabelle_benutzt:=0;

  FillChar(fuell_tabelle,SizeOf(fuell_tabelle),0);
  fuell_tabelle_benutzt:=0;

  FillChar(fixed_tabelle,SizeOf(fixed_tabelle),0);

  FillChar(rom,SizeOf(rom),0);
  verschiebung:=0;


  if not (ParamCount in [1,2,3]) then
    begin
      WriteLn(textz_hilfe^);
      Halt(1);
    end;

  dateiname:=ParamStr(1);

  if ParamCount>=2 then
    begin
      zielverzeichnis:=FExpand(Paramstr(2));
      if not (zielverzeichnis[Length(zielverzeichnis)] in ['\','/']) then
        zielverzeichnis:=zielverzeichnis+{'\'}SysPathSep;
      mkdir_verschachtelt(zielverzeichnis);
    end
  else
    zielverzeichnis:='';

  if ParamCount>=3 then
    begin
      try_unpack_str:=ParamStr(3)+' ';
      while (try_unpack_str<>'') and (try_unpack_str[1] in ['/','-']) do Delete(try_unpack_str,1,1);
      try_unpack_str[1]:=UpCase(try_unpack_str[1]);
      if try_unpack_str[1] in ['Y','J'] then try_unpack_str[1]:='J';
      if try_unpack_str[1] in ['N','N'] then try_unpack_str[1]:='N';
    end
  else
    try_unpack_str:=' ';

  (*$IFDEF DEBUG*)
  //dateiname:='..\m2\0307.rom';
  //dateiname:='..\m5\83-0103a.rom';
  //dateiname:='..\m5\30i3107a.rom';
  //dateiname:='..\alt\403\devel002.rom';
  //dateiname:='..\alt\404_1994\881_v21.rom';
  //dateiname:='..\alt\404_1994\881_v21.rom';
  //dateiname:='..\alt\404_1995\968b0501.bin';
  //dateiname:='K:\p20-0043.bio';Assign(Input,'K:\p20-0043.rsp');Reset(input);
  //dateiname:='I:\bios.rom';
  //dateiname:='M:\2460v105.rom';
  //dateiname:='M:\x\D1042_00.1';
  //dateiname:='M:\x\D1042_00.2';
  //dateiname:='M:\d1219_00.~~1';
  (*$ENDIF*)

  FSplit(dateiname,quellverzeichnis,quellname,quellerweiterung);
  oeffne_datei;
  dateilaenge:=FileSize(d1);

  Seek(d1,0);
  Blockread(d1,omf,SizeOf(omf));
  with omf do
    if (b2=$b2) and (omflaenge=dateilaenge) and (laenge>0) and (SizeOf(omf)+laenge+1<=dateilaenge) then
      begin
        WriteLn_if_needed;
        WriteLn('OMF: "',datum,'" "',modell,'"');

        logischer_anfang:=SizeOf(rom)-laenge;
        if logischer_anfang<0 then
          begin
            WriteLn(textz_datei_ist_zu_gross^);
            Halt(1);
          end;
        BlockRead(d1,rom[logischer_anfang],laenge);
        goto geladen;
      end;

  if ((dateilaenge> 128*1024+1000) and (dateilaenge< 128*1024+5000))
  or ((dateilaenge> 256*1024+1000) and (dateilaenge< 256*1024+5000))
  or ((dateilaenge> 512*1024+1000) and (dateilaenge< 512*1024+8000))
  or ((dateilaenge>1024*1024+1000) and (dateilaenge<1024*1024+8000))
  or ((dateilaenge>2048*1024+1000) and (dateilaenge<2048*1024+8000))
  or ((dateilaenge>4096*1024+1000) and (dateilaenge<4096*1024+8000)) then
    begin
      Seek(d1,dateilaenge and $ffff0000);
      BlockRead(d1,rom,dateilaenge and $0000ffff);
      WriteLn_if_needed;
      arbeit:=0;
      while arbeit<dateilaenge and $0000ffff do
        with phoenix_kopf(rom[arbeit]) do
           begin
             if nachfolger=$f1d64342 then
               bearbeite_block(dateilaenge and $ffff0000)
             else
               Break;
           end;
      FillChar(rom,SizeOf(rom),0);
      dateilaenge:=dateilaenge and $ffff0000;
    end;

  bearbeite_fuelltabelle;

  logischer_anfang:=SizeOf(rom);

  if logischer_anfang<dateilaenge then
    begin
      WriteLn(textz_datei_ist_zu_gross^);
      Halt(1);
    end;

  neue_basisadresse_erforderlich:=true;

  repeat
    Seek(d1,0);
    BlockRead(d1,ami_flash_kopf,SizeOf(ami_flash_kopf));
    if StrComp(ami_flash_kopf.signature,'FLASH')=0 then
      with ami_flash_kopf do
        begin
          if neue_basisadresse_erforderlich then
            begin
              Dec(logischer_anfang,logical_area_size);
              if dateizaehler>1 then
                logischer_anfang:=logischer_anfang and $ffff0000;
              neue_basisadresse_erforderlich:=false;
            end;

          Seek(d1,FileSize(d1)-size_of_image_chunk);
          ladeadresse:=frage_adresse(logischer_anfang+offset_in_image);
          if ladeadresse<min_ladeadresse then
            min_ladeadresse:=ladeadresse;
          BlockRead(d1,rom[ladeadresse],size_of_image_chunk);
          Close(d1);
          (*WriteLn;*)

          if (StrComp(logical_area_name,'Boot Block')=0) and (last_file_in_chain=$ff) then
            begin
              last_file_in_chain:=0;
              StrPCopy(filename_of_next_file,quellname+'.BIO');
              neue_basisadresse_erforderlich:=true;
            end;

          if last_file_in_chain=$ff then
            begin
              dateilaenge:=0;
              logischer_anfang:=min_ladeadresse;
              Break;
            end;

          dateiname:=quellverzeichnis+StrPas(filename_of_next_file);
          oeffne_datei;

        end
    else
      begin
        Seek(d1,0);
        Dec(logischer_anfang,dateilaenge);
        BlockRead(d1,rom[logischer_anfang],dateilaenge);
        Close(d1);
        WriteLn_if_needed;
        Break;
      end;

  until false;

  (* bei D1042_00.OMF ist noch ein Byte ('Q') am Ende zuviel *)
(* ÅberflÅssig durch Auswertung des OMF-Formates
  if  (rom[$fffef]=$ea)
  and (rom[$ffff0]=$5b)
  and (rom[$ffff1]=$e0)
  and (rom[$ffff2]=$00)
  and (rom[$ffff3]=$f0) then
    begin
      Move(rom[0],Rom[1],SizeOf(rom)-1);
    end; *)

  geladen:

  (* D1219_00.OCF hat noch ein Byte am Dateiende (PrÅfsumme?) *)
  (* kann nicht vermieden werden da nicht im OMF-Format *)
  (* suche 'jmp F000:E05B' an verschobener Position *)
  if  (rom[$fffef]=$ea)
  and (rom[$ffff0]=$5b)
  and (rom[$ffff1]=$e0)
  and (rom[$ffff2]=$00)
  and (rom[$ffff3]=$f0) then
    begin
      Move(rom[0], rom[1], SizeOf(rom)-1);
      rom[0] := 0;
    end;

  (* 404\404_1995\968B0501.BIN: 2*64K phoenix + 2*64 VGA -> tauschen *)
  if logischer_anfang=$c0000 then
    begin
      arbeit:=($100000-logischer_anfang) div 2;
      if  (rom[$100000-arbeit-$10+0]=$ea         ) and (rom[$100000-arbeit-$10+4]=$f0         )
      and (rom[$100000       -$10+0] in [$00,$ff]) and (rom[$100000       -$10+4] in [$00,$ff]) then
        begin
          Move(rom[$100000-1*arbeit],kopie                ,arbeit);
          Move(rom[$100000-2*arbeit],rom[$100000-1*arbeit],arbeit);
          Move(kopie                ,rom[$100000-2*arbeit],arbeit);
        end;
    end;

  (*$IFDEF DEBUG*)
  dateiname:='BIOS.ROM';
  speichere(rom,SizeOf(rom));
  (*$ENDIF*)

  implementierte_alg:=0;
  noncompressed_off:=0;
  noncompressed_len:=0;
  bcpcmp_vorhanden:=false;

  for suchposition:=logischer_anfang to $fff00 do
    begin
      with bcpcmp_kopf(rom[suchposition]) do
        if gleich_c6(kennung,'BCPCMP') and (version>0) and (version<=$900) and (laenge>=SizeOf(bcpcmp_kopf)) then
          begin
            m2.fuellbyte:=common_character_for_LZSS;
            m3.fuellbyte:=common_character_for_LZSS;
            implementierte_alg:=algorithmus_bit;
            noncompressed_off:=$f0000+non_compressed_offset;
            noncompressed_len:=$10000-non_compressed_offset;
            bcpcmp_vorhanden:=true;
            Break;
          end;

      with bcpcmp_kopf_alt(rom[suchposition]) do
        if gleich_c6(kennung,'BCPCMP') and (version=0) and (laenge>=SizeOf(bcpcmp_kopf_alt)) then
          begin
            m2.fuellbyte:=common_character_for_LZSS;
            m3.fuellbyte:=common_character_for_LZSS;
            implementierte_alg:=algorithmus_bit;
            noncompressed_off:=$f0000+o_5000;
            noncompressed_len:=$10000-o_5000;
            bcpcmp_vorhanden:=true;
            Break;
          end;
    end;

  WriteLn(textz_kopfzeile^);
  WriteLn('-------- -------- -- -------- ------------ -------- -- ------------');

  anzahl_entpackt:=0;

  bearbeite_BCPSYS_kette;
  bearbeite_fuelltabelle;
  verarbeite_fixed;
  bearbeite_fuelltabelle;

  if anzahl_entpackt>0 then
    WriteLn('-------- -------- -- -------- ------------ -------- -- ------------');

  (* Suche 'BC'#$d6#$f1 - alt *)
  suchposition:=logischer_anfang;
  while suchposition<$ffff0 do
    with bcd6f1_kopf(rom[suchposition]) do
      if (kennung1=$f1d64342) and (kennung2=$00000) and (kopflaenge=SizeOf(bcd6f1_kopf)) then
        begin
          Write(Int2Hex(suchposition,8),' ',Int2Hex(laenge_eingepackt,8));
          if implementierte_alg=0 then
            Write(' BC ')
          else
            Write(' 02 ');
          Write(Int2Hex(laenge_ausgepackt,8),' ',{Int2Hex(db07,2),'':10}biostyp_alt(db07),' ',Int2Hex(zielsegment shl 4,8));
          if zielsegment=0 then
            begin
              dateiname:=Int2Hex(suchposition,8);
              dateiname[1]:='r';
            end
          else
            dateiname:=Int2Hex(zielsegment,4)+'0000';
          vermerke_in_fuelltabelle(suchposition,kopflaenge);
          Inc(suchposition,kopflaenge);
          FillChar(ziel,SizeOf(ziel),0);
          Write(' -> ');
          case implementierte_alg of
            (* 404\404_1994\885v23.ROM *)
            0:entpacke_bcd6f1(rom[suchposition],ziel,laenge_eingepackt);
          else
            (* 404\405_700\BIOS.ROM *)
              entpacke_m2(rom[suchposition],ziel,laenge_eingepackt);
          (*
          else
             write('?');*)
          end;
          speichere(ziel,laenge_ausgepackt);
          vermerke_in_fuelltabelle(suchposition,laenge_eingepackt);
          Inc(suchposition,laenge_eingepackt);
          Inc(anzahl_entpackt);
        end
      else
        Inc(suchposition);

  bearbeite_fuelltabelle;

  (* 55 AA - Blîcke *)
  (* NuBIOS - Blîcke *)
  suchposition:=(logischer_anfang+2*1024-1) and (-2*1024);
  while suchposition<High(rom) do
    with ibm_rom_kopf(rom[suchposition]) do
      if (kennung=$aa55) and (anzahl512>0) and (anzahl512<=$ff) then
        begin
          rohformat(suchposition,anzahl512*512,Int2hex(suchposition,8)+'.rom','55 AA ROM block');
          Inc(suchposition,anzahl512*512);
          suchposition:=(suchposition+2*1024-1) and (-2*1024);
        end
      else
      if (rom[suchposition+0]=$70) and (rom[suchposition+1]=$e7)
      and (StrLComp(@rom[suchposition+$0e],'IBM AT Compatible Phoenix',Length('IBM AT Compatible Phoenix'))=0) then
        begin
          rohformat(suchposition,$2000,'bootrom.rom','bootrom?');
          Inc(suchposition,$2000);
        end
      else
        Inc(suchposition,2*1024);

  bearbeite_fuelltabelle;

  for suchposition:=logischer_anfang to SizeOf(rom)-SizeOf(phoenix_kopf) do
    begin

      with phoenix_kopf(rom[suchposition]) do
        if (u5[5]='1') and (u5[6]='1') and (kompression in [0..5]) then
          if gueltiger_phoenix_kopf_neu(suchposition) then
            begin
              arbeit:=suchposition;
              bearbeite_block(0);
              bearbeite_fuelltabelle;
            end;

      if (suchposition and (2*1024-1))=0 then
        if StrLComp(@rom[suchposition],'NAPI',Length('NAPI'))=0 then
          begin
            rohformat(suchposition,$2000,Int2hex(suchposition,8)+'.nap','NAPI');
            bearbeite_fuelltabelle;
          end;

      with acfg_kopf(rom[suchposition]) do
        if  (laenge>SizeOf(acfg_kopf))
        and (kennung='ACFG')
        and (version_major in [1,2])
         then
          begin
            rohformat(suchposition,laenge,Int2hex(suchposition,8)+'.acf','ACFG');
            bearbeite_fuelltabelle;
          end;

    end;

  (* inzwischen nicht mehr notwendig, da Problem fragmentierter komprimierter Blîcke gelîst! *)
  for suchposition:=logischer_anfang to SizeOf(rom)-SizeOf(phoenix_kopf) do
    begin
      with standard_kompression_kopf(rom[suchposition]) do
        if  (laenge_eingepackt>$0800) (* 700_b3.rom: 1d37, 2460v105.rom: 0daa *)
        and (laenge_eingepackt<$8000)
        and (rom[suchposition+4]<>0) then
          begin
            standardkompression(suchposition);
            bearbeite_fuelltabelle;
          end;
    end;

  bearbeite_fuelltabelle;

  if (noncompressed_off<>0) and (noncompressed_len<>0) then
    begin
      rohformat(noncompressed_off,noncompressed_len,'noncomp.rom','noncompressed');
      bearbeite_fuelltabelle;
    end;

  arbeit:=logischer_anfang;
  suchposition:=High(rom)-1; (* das letzte Byte is PrÅfsumme (vgacrt.bin) *)
  while (arbeit<=suchposition) and (rom[arbeit      ] in [$00,$ff]) do Inc(arbeit      );
  while (arbeit<=suchposition) and (rom[suchposition] in [$00,$ff]) do Dec(suchposition);
  if arbeit<=suchposition then
    rohformat(arbeit,suchposition-arbeit+1,'remain.rom',textz_remaining_unprocessed^);

  if (anzahl_entpackt=0) and (not bcpcmp_vorhanden) then
    begin
      WriteLn(textz_ist_vermutlich_kein_komprimiertes_phoenix_bios^);
      Halt(2);
    end;

  schreibe_scr('');
  schreibe_scr('COMPRESS      '+kompressionsverfahren[benutzte_kompressionsmethode]);
  schliesse_scr;
end.

