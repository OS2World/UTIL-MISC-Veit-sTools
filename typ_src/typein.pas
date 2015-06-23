(*$Define TYPEIN_EXE*)
(*$I TYP_COMP.PAS*)

program typ_ein;

(*$D TypEin: Einstellungprogramm zu Typ * Veit Kannegieser*)

(*$IfDef OS2*)
  (*$IfDef ENDVERSION*)
    (*$PMTYPE VIO*)
  (*$Else*)
    (*$PMTYPE NOVIO*)
  (*$EndIf*)
(*$EndIf*)

(*$IfNDef TYP_DOS*)
  (*$IfNDef TYP_OS2*)
    (*$IfNDef TYP_DPMI32*)
       (*$IfNDef TYP_W32*)
         (*$IfNDef TYP_LNX*)
           ein Ziel muá definiert sein
         (*$EndIf*)
       (*$EndIf*)
    (*$EndIf*)
  (*$EndIf*)
(*$EndIf*)


uses
  typ_type,
  dos,
  crt,
  typein_f,
  typ_varx,
  typ_para,
  typ_spra;

const
  bat_name                                              ='TY';
  (*$IfDef TYP_OS2*)
  bat_erweiterung                                       ='.CMD';
  (*$EndIf*)
  (*$IfDef TYP_DOS*)
  bat_erweiterung                                       ='.BAT';
  (*$EndIf*)
  (*$IfDef TYP_DPMI32*)
  bat_erweiterung                                       ='.BAT';
  (*$EndIf*)
  (*$IfDef TYP_LNX*)
  bat_erweiterung                                       ='';
  (*$EndIf*)
  (*$IfDef TYP_W32*)
  bat_erweiterung                                       ='.BAT';
  (*$EndIf*)

  minus_plus            :array[falsch..wahr] of char    =('-','+');


var
  ein_aus               :array[falsch..wahr] of ^string;
  taste                 :char;
  bat_pfad,exe_pfad     :string;
  fehler                :word;
  reservezeile          :string;

procedure zk_anhaengen(var zk:string;const a:string);
  begin
    Insert(a,zk,Length(zk)+1);
  end;

function UpCase_ReadKey:char;
  begin
    UpCase_ReadKey:=UpCase(ReadKey);
  end;

procedure Abbruch(const zk:string);
  begin
    TextAttr:=$0C;
    write(#13,zk);clreol;
    TextAttr:=$1E;
    writeln;
    repeat
    until keypressed;
    UpCase_ReadKey;
    halt;
  end;


procedure readln_word_norm(var l:word_norm;const min,max:longint);
  var
    z                   :string;
    (*$IfDef DOS_ODER_DPMI*)
    k                   :integer;
    (*$Else*)
    k                   :integer_norm;
    (*$EndIf*)
  begin
    repeat
      ReadLn(z);
      Val(z,l,k);
    until (k=0) and (l>=min) and (l<=max);
  end;

function pfad_aussuchen:string;
  var
    pfad_umgebung       :string;
    zaehl,pfadnr        :word_norm;
    pftab               :array[1..20] of
                          record
                            pfad:string;
                          end;
    pfad_zk             :string;
    (*$IfDef DOS_ODER_DPMI*)
    k                   :integer;
    (*$Else*)
    k                   :integer_norm;
    (*$EndIf*)

  begin
    loeschen;
    WriteLn(textz_ein__Pfadauswahl_fuer^+bat_name+bat_erweiterung,^m^j
            );
    pfad_umgebung:=getenv('PATH');
    if (pfad_umgebung[length(pfad_umgebung)]<>';') and (pfad_umgebung<>'') then
      zk_anhaengen(pfad_umgebung,';');
    zk_anhaengen(pfad_umgebung,'.;');
    zaehl:=0;

    while (pfad_umgebung<>'') and (zaehl<20) do
      begin
        inc(zaehl);
        with pftab[zaehl] do
          begin
            pfad:=Copy(pfad_umgebung,1,Pos(';',pfad_umgebung));
            Delete(pfad_umgebung,1,length(pfad));
            Dec(pfad[0]);

            pfad:=FExpand(pfad);
            if pfad[length(pfad)]<>'\' then
              zk_anhaengen(pfad,'\');

            write(zaehl:6,' ',pfad);
            gotoxy(40,wherey);
            if (pos('\BAT',pfad)>0)
            or (pos('\CMD',pfad)>0)
             then
              WriteLn(textz_ein__Bitte_dieses^)
            else
              writeln;
          end;
      end;
    writeln;
    write  (textz_ein__In_welchem_Pfad^,' [1..',zaehl,'] ',textz_ein__darf_ich^,bat_name+bat_erweiterung,textz_ein__anlegen^);

    ReadLn(pfad_zk);
    if pfad_zk='' then
      pfad_zk:='.\';

    val(pfad_zk,pfadnr,k);
    if k=0 then
      if (pfadnr>0) and (pfadnr<=zaehl) then
        pfad_zk:=pftab[pfadnr].pfad;

    if pfad_zk[length(pfad_zk)]<>'\' then
      zk_anhaengen(pfad_zk,'\');

    pfad_aussuchen:=pfad_zk;
  end;

procedure lese_eintraege(const name:string);
  var
    d                   :text;
    bat_zeile           :string;

  begin
    farbtabellenname    :='';

    WriteLn(textz_ein__Auslesen_von^,name,' ...');
    Assign(d,name);
    Reset(d);
    ReadLn(d); (* ECHO OFF *) {// und bei Lesefehler?}
    ReadLn(d,reservezeile);

    if reservezeile='PARSE ARG PARA' then (* OS/2 REXX *)
      ReadLn(d,reservezeile);

    ReadLn(d,bat_zeile);
    Close(d);

    (* '@"C:\DAT EI EN\TYP2.EXE"' ...  *)
    if Pos('''',bat_zeile)=1 then
      Delete(bat_zeile,1,1);

    if Pos('@',bat_zeile)=1 then
      Delete(bat_zeile,1,1);

    if Pos('"',bat_zeile)=1 then
      begin
        Delete(bat_zeile,1,1);
        if Pos('"',bat_zeile)<>0 then
          Delete(bat_zeile,1,Pos('"',bat_zeile));
      end;

    Delete(bat_zeile,1,Pos(' ',bat_zeile)); (* 'D:\EXTRA\TYP2.EXE ' *)

    if Pos(' '#39'PARA',bat_zeile)>0 then
      SetLength(bat_zeile,Pos(' '#39'PARA',bat_zeile)-1);

    parameter_auswerten(bat_zeile);

  end;

procedure schreibe_eintraege(const name:string);
  var
    d                   :text;

  begin
    WriteLn(textz_ein__Schreiben_von^,name,' ...');

    assign(d,name);
    rewrite(d);
    (*$IfDef TYP_OS2*)
    (* Rexx friát die "" weg, Datei- oder Verzeichnisnamen mit Leerzeichen
       gehen dabei kaputt. ARG() ist entweder 0 oder 1...
    WriteLn(d,'/* REXX * TYPEIN2 */');
    WriteLn(d,'PARSE ARG PARA');*)
    WriteLn(d,'@ECHO OFF');
    (*$Else*)
    WriteLn(d,'@ECHO OFF');
    (*$EndIf*)
    WriteLn(d,reservezeile);

    if farbtabellenname<>'' then
      Insert(' -F',farbtabellenname,1);

    if entp_bat_cmd<>'' then
      Insert(' -N',entp_bat_cmd,1);

    Write  (d,
              (*$IfDef TYP_OS2*)(*#39'@',*)(*$EndIf*)
              exe_pfad,typ_exe_name,
              ' -!',minus_plus[multitask],
             (* -A... *)
              ' -B',terminal_para[term],
              ' -C',minus_plus[cpu_emulator],
              (*$IfDef TYP_DOS*)
              ' -D',minus_plus[direkt_ide],
              ' -E',ems_grenze,
              (*$EndIf*)
              (*$IfDef TYP_OS2*)
              ' -E',minus_plus[eas_anzeigen],
              (*$EndIf*)
              farbtabellenname,
              ' -G',minus_plus[gtdata_dll],
              ' -H',minus_plus[hexadezimal],
             (* -I... *)
              (*$IfDef TYP_DOS*)
              ' -J',minus_plus[spielhebel],
              (*$EndIf*)
              ' -L',minus_plus[langformat],
              ' -ICO',minus_plus[ico_anzeige],
              ' -M',minus_plus[maustreiber],
              entp_bat_cmd,
              ' -P',minus_plus[parti_und_speicher],
              ' -S',minus_plus[startsektoren],
              ' -U',minus_plus[unterverzeichnisse],

              (*$IfDef TYP_DOS*)
              ' -X',xms_grenze,
              (*$EndIf*)
              (*$IfDef TYP_VP*)
              ' -X',pas_grenze,
              (*$EndIf TYP_VP*)
              ' -Z',bzeilen,

              (*$IfDef TYP_OS2*)
              (*' '#39'PARA');*)
              ' %1 %2 %3 %4 %5 %6 %7 %8 %9');
              (*$Else*)
              ' %1 %2 %3 %4 %5 %6 %7 %8 %9');
              (*$EndIf*)
    Close(d);
  end;


procedure not_(var b:boolean);
  begin
    b:=not b;
  end;

(*************** HP *************)

begin
  ein_aus[falsch]:=textz_ein__aus;
  ein_aus[wahr]  :=textz_ein__ein;
  bestimme_switch_char;
  loeschen;
  (*$IfDef TYP_OS2*)
  (*REXX:reservezeile:=textz_ein__REXX_reserviert_Zeile_nicht_entfernen^;*)
  reservezeile:=textz_ein__REM_reserviert_Zeile_nicht_entfernen^;
  (*$Else*)
  reservezeile:=textz_ein__REM_reserviert_Zeile_nicht_entfernen^;
  (*$EndIf*)
  WriteLn(textz_ein__Einrichtungsprogramm_zu_Typ^);
  WriteLn;

  (* TYP.EXE *)
  exe_pfad:=FSearch(typ_exe_name,'.');
  if exe_pfad='' then
    Abbruch(textz_ein__Abbruch_doppelpunkt^+typ_exe_name+textz_ein__nicht_im_aktuellen_Verzeichnis^);

  exe_pfad:=FExpand(exe_pfad);
  SubLength(exe_pfad,Length(typ_exe_name));

  (* Diskette *)
  if (exe_pfad[1] in ['A','B']) then
    begin
      WriteLn(textz_ein__Dies_ist_kein_Kopierprogramm_Wollen_Sie_TYP_immer_von_Laufwerk^,exe_pfad[1],
        textz_ein__doppelpunkt_starten_frage^);
      Write  (textz_ein__JN^);

      repeat
        case UpCase_ReadKey of
          'N':Abbruch(textz_ein__Dann_kopiern_Sie_mich_auf_die_Festplatte^);
          'J',
          'Y':Break;
        end;
      until false;

    end;

  (* TY.BAT *)
  bat_pfad:=FSearch(bat_name+bat_erweiterung,GetEnv('PATH'));
  if bat_pfad='' then
    bat_pfad:=pfad_aussuchen
  else
    begin
      bat_pfad:=FExpand(bat_pfad);
      SubLength(bat_pfad,Length(bat_name+bat_erweiterung));
      lese_eintraege(bat_pfad+bat_name+bat_erweiterung);
    end;

  (* eigentliche Einstellungen *)
  repeat
    loeschen;
    WriteLn;
    WriteLn('                       ',textz_ein__Einrichtungsprogramm_zu_Typ^                                   );
    writeln;
    writeln;
    WriteLn('                     [u]  .. ',textz_ein__Unterverzeichnisse_fuell^  ,ein_aus[unterverzeichnisse]^ );
    WriteLn('                     [p]  .. ',textz_ein__Partitionstabelle_fuell^   ,ein_aus[parti_und_speicher]^ );
    WriteLn('                     [s]  .. ',textz_ein__Startsektoren_fuell^       ,ein_aus[startsektoren]^      );
    WriteLn('                     [l]  .. ',textz_ein__Langformat_fuell^          ,ein_aus[langformat]^         );
    WriteLn('                     [b]  .. ',textz_ein__Bildschirm_fuell^          ,terminal_para[term]          );
    WriteLn('                             ',terminal_namen[term]);
    WriteLn('                     [h]  .. ',textz_ein__hexadezimal_fuell^         ,ein_aus[hexadezimal]^        );
    WriteLn('                     [m]  .. ',textz_ein__Mausbenutzung_fuell^       ,ein_aus[maustreiber]^        );
    (*$IfDef TYP_DOS*)
    WriteLn('                     [j]  .. ',textz_ein__Spielhebelbenutzung_fuell^ ,ein_aus[spielhebel]^         );
    WriteLn('                     [d]  .. ',textz_ein__direkter_IDE_Zugriff_fuell^,ein_aus[direkt_ide]^         );
    (*$EndIf*)
    WriteLn('                     [c]  .. ',textz_ein__cpu_emulator^              ,ein_aus[cpu_emulator]^       );
    WriteLn('                     [r]  .. ',textz_ein__resource_anzeigen^         ,ein_aus[resource_anzeigen]^  );
    WriteLn('                     [i]  .. ',textz_ein__ico_anzeigen^              ,ein_aus[ico_anzeige]^  );
    WriteLn('                     [f]  .. ',textz_ein__Farbtabelle_benutzen_fuell^,farbtabellenname             );
    (*$IfDef TYP_DOS*)
    WriteLn('                     [e]  .. ',textz_ein__EMS_Obergrenze_fuell^      ,ems_grenze                   );
    WriteLn('                     [x]  .. ',textz_ein__XMS_Obergrenze_fuell^      ,xms_grenze                   );
    (*$EndIf*)
    (*$IfDef TYP_OS2*)
    WriteLn('                     [e]  .. ',textz_ein__EAS_anzeigen_fuell^        ,ein_aus[eas_anzeigen]^       );
    (*$EndIf*)
    (*$IfDef TYP_VP*)
    WriteLn('                     [x]  .. ',textz_ein__RAM_Obergrenze_fuell^      ,pas_grenze                   );
    (*$EndIf TYP_VP*)
    WriteLn('                     [z]  .. ',textz_ein__Zeilenzahl_fuell^          ,bzeilen                      );
    WriteLn('                     [*]  .. ',textz_ein__Farbtabelle_erstellen^                                   );
    WriteLn('                    [Esc] .. ',textz_ein__Programmabbruch^                                         );
    WriteLn('                    [<ÄÙ] .. ',textz_ein__Speichern^                                               );
    writeln;
    Write  ('                      ');

    repeat
      taste:=UpCase_ReadKey;
    until taste<>#0;

    case taste of
      'B':
        if term=High(term_typ) then
          term:=Low(term_typ)
        else
          Inc(term);

      'C':not_(cpu_emulator);

      (*$IfDef TYP_DOS*)
      'D':not_(direkt_ide);
      'E':
          begin
            Write  (^m^j,
                    textz_ein__Obergrenze_Nutzung_EMS_KB_alt^,ems_grenze,')'^m^j+
                    '   ');
            readln_word_norm(ems_grenze,0,32*1024 div 16);
          end;
      (*$EndIf*)
      (*$IfDef TYP_OS2*)
      'E':not_(eas_anzeigen);
      (*$EndIf*)


      'F':
          begin
            Write  (^m^j,
                    textz_ein__Farbtabellenname_alt^,farbtabellenname,')'^m^j+
                    '   ');
            ReadLn(farbtabellenname);
            if farbtabellenname<>'' then
              Insert(exe_pfad,farbtabellenname,1);
          end;

      'G':not_(gtdata_dll);
      'H':not_(hexadezimal);
      'I':not_(ico_anzeige);

      (*$IfDef TYP_DOS*)
      'J':not_(spielhebel);
      (*$EndIf*)

      'L':not_(langformat);
      'M':not_(maustreiber);

      'P':not_(parti_und_speicher);
      'R':not_(resource_anzeigen);
      'S':not_(startsektoren);
      'U':not_(unterverzeichnisse);

      'X':
        begin
          Write  (^m^j,
          (*$IfDef TYP_DOS*)
                  textz_ein__Obergrenze_Nutzung_XMS_KB_alt^,xms_grenze,')'^m^j+
                  '   ');
          readln_word_norm(xms_grenze,0,64*1024*1024);
          (*$EndIf*)
          (*$IfDef TYP_VP*)
                  textz_ein__Obergrenze_Nutzung_RAM_KB_alt^,pas_grenze,')'^m^j+
                  '   ');
          readln_word_norm(pas_grenze,0,2000*1024);
          (*$EndIf TYP_VP*)
        end;

      'Z':
        begin
          Write  (^m^j,
                  textz_ein__gewuenschte_Bildschirmdarstellung_80_Spalten_2528435060_Zeilen^,^m^j+
                  '   ');
          readln_word_norm(bzeilen,0,60);
          if not (bzeilen in [00,25,28,43,50,60]) then
            bzeilen:=25;
        end;

      '*':farb_edit(farbtabellenname);

      #27:
        begin
          TextAttr:=$0f;
          ClrScr;
          Abbruch(textz_ein__Abbruch^);
        end;
    end;
  until taste=#13;

  schreibe_eintraege(bat_pfad+bat_name+bat_erweiterung);

  TextAttr:=$0F;
  ClrScr;

  WriteLn(textz_ein__erfolgreicher_Abschluss^);
  writeln;
  WriteLn(textz_ein__Hilfe_doppelpunkt_anf^,bat_name+' -?"');
  WriteLn(textz_ein__Programmstart_doppelpunkt_anf^,bat_name+'"');

end.

