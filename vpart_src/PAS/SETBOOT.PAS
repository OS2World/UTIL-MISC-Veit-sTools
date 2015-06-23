(* SETBOOI.EXE fÅr VPART mit speichern des gewÑhlten Eintrages im CMOS *)
(* 2000.05.31 Veit Kannegieser *)
(* 2000.07.12 *)
(* 2001.03.20 Suche nach SETBOOTC.CFG verbessert, >255 Zeichen PATH    *)
(* 2001.03.23 SETBOOTF hinzugefÅgt                                     *)

uses
  (*$IFDEF OS2*)
  Os2Base,
  Os2Def,
  (*$ENDIF OS2*)
  (*$IFDEF DPMI32*)
  dpmi32,
  dpmi32df,
  (*$ENDIF DPMI32*)
  (*$IFDEF VirtualPascal*)
  VpSysLow,
  VpUtils,
  (*$ELSE*)
  TpUtils,
  TpSysLow,
  (*$ENDIF*)
  WinDos,
  Dos,
  Strings,
  mb1,
  setb_spr;

(*$IFDEF SETBOOTC*)
type
  cmos_tabelle_typ      =array[$10..$7f] of byte;
(*$ENDIF SETBOOTC*)

const
  datum                 ='2000. 5.31..'+(*'2001.03.23';*)
                         (*$I ..\DATUM.PAS*);
(*$IFDEF SETBOOTC*)
  biostyp_Award         =1;
  biostyp_AMI_Hi_Flex   =2;
  biostyp_AMI_WinBIOS   =3;
  biostyp_SystemSoft    =4;
  setbootc_cfg_name     ='SETBOOTC.CFG';
(*$ENDIF SETBOOTC*)
(*$IFDEF SETBOOTF*)
  setbootc_cfg_name     ='SETBOOTF.CFG';
(*$ENDIF SETBOOTF*)
  zeige_hilfe           :boolean=false;
  zeige_liste           :boolean=false;
  neustart              :boolean=false;
  wunschbetriebbssystem :string='';

var
  menu_anzahl           :word;
  menu_namen            :array[1..10] of string;
  setbootc_cfg          :text;
  z                     :word;
  para                  :string;
  standardwert          :word;
  dos_sys               :word;
  fehler                :word;
  biostyp               :word;
(*$IFDEF SETBOOTC*)
  cmos_tabelle          :cmos_tabelle_typ;

  pruefsumme_start,
  pruefsumme_ende       :word;
(*$ENDIF SETBOOTC*)

procedure gross(var s:string);
  var
    z:byte;
  begin
    for z:=1 to Length(s) do
      case s[z] of
       'a'..'z' :s[z]:=UpCase(s[z]);
       'Ñ'      :s[z]:='é';
       'î'      :s[z]:='ô';
       'Å'      :s[z]:='ö';
      end;
  end;

(*$IFDEF SETBOOTC*)
procedure bestimme_bios;
  var
    f000ff00    :packed array[0..$fff0] of char (*$IFNDEF VirtualPascal*) absolute $f000:$0000(*$ENDIF*);
    z           :word;
  begin
    (*$IFDEF VirtualPascal*)
    bios_speicher_lesen(f000ff00);
    (*$ENDIF*)
    if StrLComp(@f000ff00[$e000],'Award ',Length('Award '))=0 then
      begin
        biostyp:=biostyp_Award;
        Exit;
      end;

    if StrLComp(@f000ff00[$0000],'0123AAAAMMMMIIIIB',Length('0123AAAAMMMMIIIIB'))=0 then
      begin
        biostyp:=biostyp_AMI_Hi_Flex;
        Exit;
      end;

    if StrLComp(@f000ff00[$e010],'SystemSoft',Length('SystemSoft'))=0 then
      begin
        biostyp:=biostyp_SystemSoft;
        Exit;
      end;

    (* nicht so schîn *)
    for z:=Low(f000ff00) to High(f000ff00)-40 do
      if StrLComp(@f000ff00[z],'AMIBIOS',Length('AMIBIOS'))=0 then
        begin
          biostyp:=biostyp_AMI_WinBIOS;
          Exit;
        end;

    Writeln(textz_bios_unbekannt^);
    Halt(1);
  end;

procedure cli;
  begin
    (*$IFDEF OS2*)
    DosSetPriority(prtys_Thread,prtyc_TimeCritical,0+31,0);
    (*$ELSE*)
    asm
      cli
    end;
    (*$ENDIF*)
  end;

procedure sti;
  begin
    (*$IFDEF OS2*)
    DosSetPriority(prtys_Thread,prtyc_Regular,0,0);
    (*$ELSE*)
    asm
      sti
    end;
    (*$ENDIF*)
  end;

procedure cmos_sicher_lesen(var cmt:cmos_tabelle_typ);
  var
    z           :word;
    cmt2,cmt3   :cmos_tabelle_typ;

  label
    nochmal;

  begin
    cli;

  nochmal:
    (*$IFDEF VirtualPascal*)
    SysCtrlSleep(50);
    (*$ENDIF*)

    for z:=Low(cmt) to High(cmt) do
      begin
        Port[$70]:=z;
        cmt[z]:=Port[$71];
      end;

    for z:=Low(cmt2) to High(cmt2) do
      begin
        Port[$70]:=z;
        cmt2[z]:=Port[$71];
      end;

    for z:=Low(cmt3) to High(cmt3) do
      begin
        Port[$70]:=z;
        cmt3[z]:=Port[$71];
      end;

    for z:=Low(cmt) to High(cmt) do
      if (cmt[z]<>cmt2[z])
      or (cmt[z]<>cmt3[z])
       then
        goto nochmal;

    sti;
  end;

procedure cmos_sicher_schreiben(const cmt:cmos_tabelle_typ);
  var
    z           :word;
    cmt2,cmt3   :cmos_tabelle_typ;

  label
    nochmal;

  begin
    cli;

  nochmal:
    (*$IFDEF VirtualPascal*)
    SysCtrlSleep(50);
    (*$ENDIF*)

    for z:=Low(cmt) to High(cmt) do
      begin
        Port[$70]:=z;
        Port[$71]:=cmt[z];
      end;

    for z:=Low(cmt2) to High(cmt2) do
      begin
        Port[$70]:=z;
        cmt2[z]:=Port[$71];
      end;

    for z:=Low(cmt3) to High(cmt3) do
      begin
        Port[$70]:=z;
        cmt3[z]:=Port[$71];
      end;

    for z:=Low(cmt) to High(cmt) do
      if (cmt[z]<>cmt2[z])
      or (cmt[z]<>cmt3[z])
       then
        goto nochmal;

    sti;
  end;


procedure lade_standardwert;
  var
    z                   :word;
    summe               :word;

  begin

    cmos_sicher_lesen(cmos_tabelle);

    pruefsumme_start:=$10;
    pruefsumme_ende :=$2d;

    if biostyp=biostyp_SystemSoft then
      begin
        pruefsumme_start:=$40;
        pruefsumme_ende :=$5d;
      end;

    (* Summe Åber den ersten Bereich prÅfen *)
    summe:=0;
    for z:=pruefsumme_start to pruefsumme_ende do
      Inc(summe,cmos_tabelle[z]);

    if (Hi(summe)<>cmos_tabelle[pruefsumme_ende+1])
    or (Lo(summe)<>cmos_tabelle[pruefsumme_ende+2])
     then
      begin
        if pruefsumme_start=$10 then
          WriteLn(textz_pruefsummenfehler_10_2d^)
        else
          WriteLn(textz_pruefsummenfehler_40_5d^);
        RunError(1);
      end;

    case biostyp of
      biostyp_Award:
        standardwert:=cmos_tabelle[$13] shr 2;
      biostyp_AMI_Hi_Flex:
        standardwert:=cmos_tabelle[$11];
      biostyp_AMI_WinBIOS:
        standardwert:=cmos_tabelle[$13] shr 5;
      biostyp_SystemSoft:
        standardwert:=cmos_tabelle[$44] and $7f;
    else
      RunError(1);
    end;

    Inc(standardwert); (* 0->1 *)

  end;

procedure schreibe_standardwert;
  var
    z           :word;
    summe       :word;
  begin
    Dec(standardwert); (* 1->0 *)

    case biostyp of
      biostyp_Award:
        cmos_tabelle[$13]:=(cmos_tabelle[$13] and $03) or (standardwert shl 2);
      biostyp_AMI_Hi_Flex:
        cmos_tabelle[$13]:=standardwert;
      biostyp_AMI_WinBIOS:
        cmos_tabelle[$13]:=(cmos_tabelle[$13] and $1f) or (standardwert shl 5);
      biostyp_SystemSoft:
        cmos_tabelle[$44]:=(cmos_tabelle[$44] and $80) or  standardwert;
    else
      RunError(1);
    end;

    (* PrÅfsumme neu berechnen *)
    summe:=0;
    for z:=pruefsumme_start to pruefsumme_ende do
      Inc(summe,cmos_tabelle[z]);

    cmos_tabelle[pruefsumme_ende+1]:=Hi(summe);
    cmos_tabelle[pruefsumme_ende+2]:=Lo(summe);

    (* énderungen schreiben *)
    cmos_sicher_schreiben(cmos_tabelle);

  end;
(*$ENDIF SETBOOTC*)


(*$IFDEF SETBOOTF*)
const
  vpart_cfg_pfad        :string='';
var
  vpart_cfg             :text;

procedure oeffne_vpart_cfg;
  var
    l                   :char;
    groesse             :word;
  begin
    if vpart_cfg_pfad='' then
      begin
        vpart_cfg_pfad:=GetEnv('VPART_FAT_CFG');
      end;

    if vpart_cfg_pfad<>'' then
      begin

        if  (Pos(':\',vpart_cfg_pfad)<>2)
        and (Pos(':/',vpart_cfg_pfad)<>2)
         then
          vpart_cfg_pfad:=vpart_cfg_pfad[1]+':\';

        if (vpart_cfg_pfad[Length(vpart_cfg_pfad)] in ['\','/']) then
          vpart_cfg_pfad:=vpart_cfg_pfad+'VPART.CFG';

        Assign(vpart_cfg,vpart_cfg_pfad);
        (*$I-*)
        Reset(vpart_cfg);
        (*$I+*)
        if IOResult=0 then
          Exit;

        WriteLn(textz_kann_VPART_CFG_nicht_oeffnen^,vpart_cfg_pfad);
        Rewrite(vpart_cfg);
        WriteLn(vpart_cfg,0);
        Reset(vpart_cfg);
      end;


    l:='C';
    repeat
      vpart_cfg_pfad:=l+':\VPART.CFG';
      Write(^m,textz_Suche_VPART_CFG_^,vpart_cfg_pfad,' ');

      (*$IFDEF OS2*)
      Os2Base.DosError(ferr_DisableHardErr);
      (*$ENDIF OS2*)
      groesse:=DiskSize(Ord(l)-Ord('A')+1);
      (*$IFDEF OS2*)
      Os2Base.DosError(ferr_EnableHardErr);
      (*$ENDIF OS2*)

      if groesse<>-1 then
        begin

          Assign(vpart_cfg,vpart_cfg_pfad);
          (*$I-*)
          Reset(vpart_cfg);
          (*$I+*)
          if IOResult=0 then
            begin
              WriteLn;
              Exit;
            end;

        end;

      Inc(l);
      if l>'Z' then
        l:='A';
    until l='C';

    Write(textz_kann_VPART_CFG_nicht_finden__welcher_laufwerksbuchstabe^);
    ReadLn(l);
    vpart_cfg_pfad:=l+':\VPART.CFG';
    Assign(vpart_cfg,vpart_cfg_pfad);
    Rewrite(vpart_cfg);
    WriteLn(vpart_cfg,0);
    Reset(vpart_cfg);

  end;

procedure lade_standardwert;
  begin
    oeffne_vpart_cfg;
    ReadLn(vpart_cfg,standardwert);
    Close(vpart_cfg);
  end;

procedure schreibe_standardwert;
  begin
    oeffne_vpart_cfg;
    Rewrite(vpart_cfg);
    WriteLn(vpart_cfg,standardwert);
    Close(vpart_cfg);
  end;

(*$ENDIF SETBOOTF*)

procedure lade_liste;
  var
    fehler              :word;
    suchpfad            :string;
    suchpfad_pchar      :array[0..260] of char;

  procedure versuche_zu_oeffnen(const dateiname:string);
    begin
      if dateiname='' then Exit;

      Assign(setbootc_cfg,dateiname);
      (*$I-*)
      Reset(setbootc_cfg);
      (*$I+*)
      fehler:=IOResult;

    end;

  begin
    fehler:=2; (* noch nicht gefunden *)

    versuche_zu_oeffnen(setbootc_cfg_name); (* .\ *)

    if fehler<>0 then (* ParamStr(0) *)
      begin
        suchpfad:=ParamStr(0);
        while not (suchpfad[Length(suchpfad)] in ['\','/']) do
          Dec(suchpfad[0]);
        suchpfad:=suchpfad+setbootc_cfg_name;

        versuche_zu_oeffnen(suchpfad);
      end;

    if fehler<>0 then (* Path *)
      begin
        (*suchpfad:=FSearch(GetEnv('PATH'),setbootc_cfg_name);*)
        FillChar(suchpfad_pchar,SizeOf(suchpfad_pchar),0);
        WinDos.FileSearch(suchpfad_pchar,setbootc_cfg_name,GetEnvVar('PATH'));
        suchpfad:=StrPas(suchpfad_pchar);
        versuche_zu_oeffnen(suchpfad);
      end;

    if fehler<>0 then
      begin
        WriteLn(setbootc_cfg_name,textz__nicht_gefunden_^);
        RunError(fehler);
      end;

    menu_anzahl:=0;
    while (not Eof(setbootc_cfg)) and (menu_anzahl<High(menu_namen)) do
      begin
        Inc(menu_anzahl);
        ReadLn(setbootc_cfg,menu_namen[menu_anzahl]);
      end;
    Close(setbootc_cfg)
  end;

(*$IFNDEF OS2*)
procedure sim_taste(const s:byte);assembler;(*&Uses EAX*)(*&Alters EAX*)(*&Frame-*)
  asm
    mov ah,$4f
    mov al,s
    stc
    int $15
  end;

var
  tastatur_status       :^byte;
  post_anweisung        :^word;

(*$IFDEF DPMI32*)
procedure jmp_ffff_0000;
  var
    r:real_mode_call_structure_typ;
  begin
    init_register(r);
    r.cs_:=$ffff;
    r.ip_:=$0000;
    callf_realmode(r);
  end;
(*$ENDIF DPMI32*)

(*$IFNDEF VirtualPascal*)
procedure jmp_ffff_0000;assembler;
  asm
    db $ea
    dw $0000,$ffff
  end;
(*$ENDIF*)
(*$ENDIF*)

procedure setboot_aufruf;
  begin
    if ParamCount=0 then zeige_hilfe:=true;

    for z:=1 to ParamCount do
      begin
        para:=ParamStr(z);
        gross(para);
        if para[1] in ['-','/'] then
          begin
            Delete(para,1,1);
            if para='Q' then
              zeige_liste:=true
            else if para='B' then
              neustart:=true
            else if Pos('N:',para)=1 then
              begin
                wunschbetriebbssystem:=Copy(para,Length('N:')+1,255);
              end
            else if Pos('IBA:',para)=1 then
              begin
                wunschbetriebbssystem:=Copy(para,Length('IBA:')+1,255);
                neustart:=true;
              end
            (*$IFDEF SETBOOTF*)
            else if Pos('VPART_CFG:',para)=1 then
              begin
                vpart_cfg_pfad:=Copy(para,Length('VPART_CFG:')+1,255);
              end
            (*$ENDIF SETBOOTF*)
            else
              zeige_hilfe:=true;
          end
        else
          zeige_hilfe:=true;
      end;

    if zeige_hilfe then
      begin
        (*$IFDEF SETBOOTC*)
        WriteLn(textz_titel1c^);
        (*$ENDIF SETBOOTC*)
        (*$IFDEF SETBOOTF*)
        WriteLn(textz_titel1f^);
        (*$ENDIF SETBOOTF*)
        WriteLn('Veit Kannegieser * ',datum);
        WriteLn;
        WriteLn(textz_hilfe1^);
        WriteLn(textz_hilfe2^);
        WriteLn(textz_hilfe3^);
        WriteLn('  /IBA:Name     -> /N:Name /B');
        (*$IFDEF SETBOOTF*)
        WriteLn(textz_hilfe_vpart_cfg^);
        (*$ENDIF SETBOOTF*)
        Halt(1);
      end;

    if zeige_liste then
      begin
        lade_liste;
        for z:=1 to menu_anzahl do
          WriteLn(z:3,': ',menu_namen[z]);

        (*$IFDEF SETBOOTC*)
        bestimme_bios;

        case biostyp of
          biostyp_Award:
            Writeln('BIOS: Award');
          biostyp_AMI_Hi_Flex:
            Writeln('BIOS: AMI Hi-Flex');
          biostyp_AMI_WinBIOS:
            Writeln('BIOS: AMI WinBIOS');
          biostyp_SystemSoft:
            WriteLn('BIOS: SystemSoft');
        else
          RunError(1);
        end;

        pruefsumme_start:=$10;
        pruefsumme_ende :=$2d;
        if biostyp=biostyp_SystemSoft then
          begin
            pruefsumme_start:=$30;
            pruefsumme_ende :=$5d;
          end;
        (*$ENDIF SETBOOTC*)

        lade_standardwert;
        Write(textz_Standardwert__^,standardwert:3);
        if (1<=standardwert) and (standardwert<=menu_anzahl) then
          WriteLn(': ',menu_namen[standardwert])
        else
          WriteLn(textz___ungueltig^);
      end;

    if wunschbetriebbssystem<>'' then
      begin
        lade_liste;

        for z:=1 to menu_anzahl do
          gross(menu_namen[z]);

        (*$IFDEF SETBOOTC*)
        bestimme_bios;
        (*$ENDIF SETBOOTC*)
        lade_standardwert;

        standardwert:=0;
        for z:=1 to menu_anzahl do
          if (Pos(wunschbetriebbssystem,menu_namen[z])<>0)
          or (wunschbetriebbssystem=Int2Str(z))
           then
            if standardwert=0 then
              standardwert:=z
            else
              begin
                WriteLn('"',wunschbetriebbssystem,textz___ist_mehrdeutig_^);
                Halt(1);
              end;

        if standardwert=0 then
          begin
            WriteLn('"',wunschbetriebbssystem,textz___ist_unbekannt^);
            Halt(2);
          end;
        schreibe_standardwert;
      end;

    if neustart then
      begin
        (*$IFDEF OS2*)
        fehler:=SysFileOpen('\DEV\DOS$',$40,dos_sys);
        if fehler<>0 then
          begin
            WriteLn(textz_kann_DOS_SYS_nicht_oeffnen^);
            RunError(fehler);
          end
        else
          DosDevIOCtl(dos_sys,$d5,$ab,
            nil,0,nil,
            nil,0,nil);
          SysFileClose(dos_sys);

        (*$ELSE*)

        (*$IFDEF DPMI32*)
        tastatur_status:=Ptr(Seg0040+$0017);
        post_anweisung :=Ptr(Seg0040+$0072);
        (*$ELSE*)
        tastatur_status:=Ptr(Seg0040,$0017);
        post_anweisung :=Ptr(Seg0040,$0072);
        (*$ENDIF*)
        sim_taste($1d); (* Strg *)
        tastatur_status^:=tastatur_status^ or $04;
        sim_taste($38); (* Alt  *)
        tastatur_status^:=tastatur_status^ or $04 or $08;
        sim_taste($53); (* Entf *)
        post_anweisung^:=$1234;
        jmp_ffff_0000;
        (*$ENDIF*)
      end;
  end;


(*
---------------------------------------------------------------------
Mit SETBOOT kann der Boot Manager fÅr eine Festplatte eingerichtet
werden.
SYNTAX:     SETBOOT [/Q]
            SETBOOT [/T:x or /T:NO][/M:m][/X:x][/N:name][/B]
                    [/IBD:d][/IBA:name]

ErklÑrung:
 /Q         ->  Abfragen der Startinformationen
 /T:x       ->  Das Zeitintervall wird mit x Sekunden festgelegt
 /T:NO      ->  Das Zeitlimit wird inaktiviert.
 /M:m       ->  Festlegen des Modus; m = n normaler Modus (Standard)
                                     m = a erweiterter Modus
 /X:x       ->  Systemindex wird mit x (0-3) festgelegt.
 /N:name    ->  Die Partition oder logische Platte ("name" mit Indexwert
                "N") als zu startendes Betriebssystem festlegen.
 /B         ->  Systemabschlu· durchfÅhren und System neu starten.
 /IBD:l     ->  Systemabschlu· durchfÅhren und System vom logischen Laufwerk
                "l" neu starten.
 /IBA:name  ->  Systemabschlu· durchfÅhren und Computer vom System
                "name" starten.
*)
