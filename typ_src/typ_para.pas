(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

unit typ_para;

interface

(*$IfDef TYP_EXE*)
var
  dateiliste            :string;
(*$EndIf TYP_EXE*)

procedure parameter_auswerten(*$IfDef TYPEIN_EXE*)(var paramzk:string)(*$EndIf*);

implementation

uses
  typ_varx,
  typ_type,
(*$IfDef TYP_EXE*)
  typ_ausg,
  typ_spra,
(*$IfDef VirtualPascal*)
  VpUtils,
(*$EndIf VirtualPascal*)
(*$EndIf*)
  Strings;

procedure parameter_auswerten;
  var
    schalterzk          :string;
    schalterzk_org      :string;
    list_datei          :boolean;
    ParamCount_0        :boolean;

  function para_erkennung(const ft:string):boolean;
    begin
      para_erkennung:=falsch;
      if Pos(ft,typ_varx.gross(schalterzk))<>1 then
        Exit;

      para_erkennung:=true;
      Delete(schalterzk,1,Length(ft));
      while (schalterzk<>'') and (schalterzk[1] in [':','=']) do Delete(schalterzk,1,1);

    end;



  procedure para_schalten_boolean(var b:boolean);
    begin

      if schalterzk='' then
        b:=not b

      else
      if schalterzk[1]='-' then
        b:=falsch

      else
      if schalterzk[1]='+' then
        b:=wahr

      else
        (*$IfDef TYP_EXE*)
        (*abbruch(textz_para__ungueltiger_Schalter_doppelpunkt_minus^+schalterzk,
          abbruch_Problem_beim_Auswerten_der_Parameter);*)
        abbruch(textz_para__ungueltiger_Parameter^+' '+schalterzk_org,abbruch_Problem_beim_Auswerten_der_Parameter);
        (*$Else*)
        (*$EndIf*)

    end;

  procedure schalter_setzen;
    var
      datei             :file;
      vergleich_term    :term_typ;
      wert_longint      :longint;

    begin
      schalterzk_org:=schalterzk;

      if para_erkennung('!') then
        para_schalten_boolean(multitask)

      (*$IfDef TYP_EXE*)
      else
      if para_erkennung('?') then
        para_schalten_boolean(hilfe_anzeigen)
      (*$EndIf TYP_EXE*)

      else
      if para_erkennung('A') then
        para_schalten_boolean(bios_pw_anzeigen)

      else
      if para_erkennung('BILDSCHIRM')
      or para_erkennung('B') then
        begin
          vergleich_term:=Low(term_typ);
          repeat
            if para_erkennung(terminal_para[vergleich_term]) then
              begin
                term:=vergleich_term;
                (*$IfDef TYP_EXE*)
                terminal_dateiname:=schalterzk;
                (*$EndIf*)
                Break;
              end;

             if vergleich_term=high(term_typ) then
               (*$IfDef TYP_EXE*)
               abbruch(textz_para__ungueltiger_Parameter^+' B...',abbruch_Problem_beim_Auswerten_der_Parameter);
               (*$Else*)
               Break;
               (*$EndIf*)

             Inc(vergleich_term)
          until false;

        end

      else
      if para_erkennung('CPU')
      or para_erkennung('C') then
        para_schalten_boolean(cpu_emulator)

      else
      if para_erkennung('DIREKT_IDE')
      or para_erkennung('D') then
        (*$IfDef DOS*)
        para_schalten_boolean(direkt_ide)
        (*$Else*)
        (* ignorieren *)
        (*$EndIf*)

      else
      if para_erkennung('EMS')
      (*$IfDef TYP_DOS*)
      or para_erkennung('E')
      (*$EndIf TYP_DOS*)
       then
        begin
          (*$IfDef TYP_DOS*)
          (* EMS *)

          wert_longint:=ems_grenze*16; (* 16 KB Seiten *)
          Val(schalterzk,wert_longint,fehler_val);

          (*$IfDef TYP_EXE*)
          if fehler_val<>0 then
            abbruch(textz_para__ungueltiger_Parameter^+' E...',abbruch_Problem_beim_Auswerten_der_Parameter);
          (*$EndIf*)

          wert_longint:=Min(wert_longint,32*1024); (* EMS <= 32 MB *)

          ems_grenze:=word(wert_longint (*div 16*) shr 4);
          (*$EndIf TYP_DOS*)
        end (* EMS *)

      else
      if para_erkennung('EA')
      (*$IfDef OS2*)
      or para_erkennung('E')
      (*$EndIf OS2*)
       then
        (*$IfDef OS2*)
        para_schalten_boolean(eas_anzeigen)
        (*$Else*)
        (*$EndIf*)

      else
      if para_erkennung('FARBTABELLE')
      or para_erkennung('F') then
        begin

          (*$IfDef TYPEIN_EXE*)
          farbtabellenname:=schalterzk;
          (*$EndIf TYPEIN_EXE*)

          (*$IfDef TYP_EXE*)
          Assign(datei,schalterzk);
          (*$I-*)
          Reset(datei,1);
          (*$I+*)
          if IOResult<>0 then
            abbruch(textz_para__Fehler_beim_OEffenen_der_Farbtabelle^,
              abbruch_Problem_beim_Auswerten_der_Parameter);

          BlockRead(datei,ftab,sizeof(ftab),fehler_val);
          if fehler_val<>SizeOf(ftab) then
            abbruch(textz_para__Fehler_beim_Lesen_der_Farbtabelle^,
              abbruch_Problem_beim_Auswerten_der_Parameter);

          Close(datei);
          (*$EndIf TYP_EXE*)
        end

      else
      if para_erkennung('GTDATADLL')
      or para_erkennung('G') then
        para_schalten_boolean(gtdata_dll)

      else
      if para_erkennung('HEX')
      or para_erkennung('H') then
        para_schalten_boolean(hexadezimal)

      else
      if para_erkennung('ICO')
      or para_erkennung('I') then
        para_schalten_boolean(ico_anzeige)

      else
      if (*para_erkennung('I')
      or *)para_erkennung('SIGNATUREN') then
        para_schalten_boolean(signaturen)

      else
      if para_erkennung('JOYSTICK')
      or para_erkennung('J') then
        (*$IfDef DOS*)
        para_schalten_boolean(spielhebel)
        (*$Else*)
        (* ignorieren *)
        (*$EndIf*)

      else
      if para_erkennung('ZEILEN')
      or para_erkennung('LINES')
      or para_erkennung('Z') then
        begin
          (* Zeilen *)
          if (Length(schalterzk)<Length('0')) or (Length(schalterzk)>length('80')) then
            (*$IfDef TYP_EXE*)
            abbruch(textz_para__Es_ist_unlogisch_dass_ein_Parameter_der_Form_Zxx_nicht_4_Zeichen_lang_ist^,
              abbruch_Problem_beim_Auswerten_der_Parameter);
            (*$Else*)
            schalterzk:='0';
            (*$EndIf*)

          Val(schalterzk,bzeilen,fehler_val);
          if (fehler_val<>0)
          or ((bzeilen<25) and (bzeilen<>0))
          or (bzeilen>80)
           then
            (*$IfDef TYP_EXE*)
            abbruch(schalterzk+textz_para__scheint_kein_gueltiger_Zahlenwert_zu_sein^,
              abbruch_Problem_beim_Auswerten_der_Parameter);
            (*$Else*)
            bzeilen:=0;
            (*$EndIf*)

        end

      else
      if para_erkennung('LANGFORMAT')
      or para_erkennung('L') then
        para_schalten_boolean(langformat)

      else
      if para_erkennung('MAUS')
      or para_erkennung('MOUSE')
      or para_erkennung('M') then
        para_schalten_boolean(maustreiber)

      else
      if para_erkennung('ENTPACKER')
      or para_erkennung('UNPACKER')
      or para_erkennung('N') then
        entp_bat_cmd:=schalterzk

      else
      if para_erkennung('PARTITION')
      or para_erkennung('P') then
        para_schalten_boolean(parti_und_speicher)

      else
      if para_erkennung('RESOURCE')
      or para_erkennung('R') then
        para_schalten_boolean(resource_anzeigen)

      else
      if para_erkennung('XMS')
      or para_erkennung('MEMORY')
      or para_erkennung('SPEICHER')
      or para_erkennung('X') then
       begin

         (* XMS *)

         (*$IfDef TYP_DOS*)
         wert_longint:=xms_grenze;
         (*$EndIf*)

         (*$IfDef VirtualPascal*)
         wert_longint:=pas_grenze;
         (*$EndIf*)

         Val(schalterzk,wert_longint,fehler_val);

         (*$IfDef TYP_EXE*)
         if fehler_val>0 then
           abbruch(textz_para__ungueltiger_Parameter^+' X...',abbruch_Problem_beim_Auswerten_der_Parameter);
         (*$EndIf*)

         (*$IfDef TYP_DOS*)
         xms_grenze:=word(Min(wert_longint,$ffff));
         (*$EndIf*)
         (*$IfDef VirtualPascal*)
         pas_grenze:=Min(wert_longint,High(longint) (*div 1024*) shr 10); // limit to 2GB :)
         (*$EndIf*)
       end

      else
      if para_erkennung('UNTERVERZEICHNISSE')
      or para_erkennung('SUBDIR')
      or para_erkennung('U') then
        para_schalten_boolean(unterverzeichnisse)

      else
      if para_erkennung('SEKTOREN')
      or para_erkennung('SECTORS')
      or para_erkennung('S') then
        para_schalten_boolean(startsektoren)

      else
        (*$IfDef TYP_EXE*)
        abbruch(textz_para__Unbekannter_Parameter^+': "'+schalterzk_org+'"',
          abbruch_Problem_beim_Auswerten_der_Parameter);
        (*$Else*)
        ;
        (*$EndIf*)

    end;


  var
    (*$IfDef TYP_EXE*)
    paramzk             :string;
    (*$EndIf TYP_EXE*)
    (*$IfDef TYPEIN_EXE*)
    dateiliste          :string;
    (*$EndIf TYPEIN_EXE*)
    parameter_nummer    :word_norm;
    anfz_pos            :word_norm;
    tmp                 :string;

  begin
    bestimme_switch_char;

    (*$IfDef TYP_EXE*)
    (*$IfDef VirtualPascal*)

    (*$IfDef Os2*)
    paramzk:=StrPas(StrEnd(CmdLine)+1);
    if Length(paramzk)=255 then
      SetLength(paramzk,254);
    paramzk:=paramzk+' ';

    ParamCount_0:=true;
    for parameter_nummer:=1 to Length(paramzk) do
      if not (paramzk[parameter_nummer] in [' ',#9]) then
        begin
          ParamCount_0:=false;
          Break;
        end;
    (*$Else OS2*)
    ParamCount_0:=(ParamCount=0);
    (* alle Parameter summieren *)
    paramzk:='';
    for parameter_nummer:=1 to ParamCount do
      begin
        tmp:=ParamStr(parameter_nummer);
        if Pos(' ',tmp)<>0 then
          tmp:='"'+tmp+'"';
        paramzk:=paramzk+tmp+' ';
      end;


    (*$EndIf OS2*)
    (*$Else VirtualPascal*)
    ParamCount_0:=(ParamCount=0);
    (* alle Parameter summieren *)
    paramzk:='';
    for parameter_nummer:=1 to ParamCount do
      begin
        tmp:=ParamStr(parameter_nummer);
        if Pos(' ',tmp)<>0 then
          tmp:='"'+tmp+'"';
        paramzk:=paramzk+tmp+' ';
      end;
    (*$EndIf VirtualPascal*)

    hilfe_anzeigen:=ParamCount_0;
    dateiliste:='';
    (*$EndIf TYP_EXE*)



    (* Schalter heraussammeln *)
    while paramzk<>'' do
      begin
        (* Leerstellen *)
        while (Length(paramzk)>0) and (paramzk[1] in [' ',#9]) do
          Delete(paramzk,1,1);

        if paramzk='' then Break;

        (* Listdateien ... *)
        list_datei:=(paramzk[1]='@');
        if list_datei then
          begin
            dateiliste:=dateiliste+'@';
            Delete(paramzk,1,1);
          end;

        if paramzk='' then Break;

        (* Sonderdateinamen? *)
        if paramzk[1] in ['"',''''] then
          begin
            anfz_pos:=Pos(paramzk[1],Copy(paramzk,2,255)+paramzk[1]);
            dateiliste:=dateiliste+Copy(paramzk,2,anfz_pos-1)+#0;
            Delete(paramzk,1,1+anfz_pos);
          end
        else
          (* normale Dateinamen *)
          if list_datei or (not (paramzk[1] in [(*$IfNDef Linux*)'/',(*$EndIf*)'-',switch_char])) then
            begin
              anfz_pos:=Pos(' ',paramzk+' ');
              dateiliste:=dateiliste+Copy(paramzk,1,anfz_pos-1)+#0;
              Delete(paramzk,1,anfz_pos);
            end
          else
            (* Schalter *)
            begin
              Delete(paramzk,1,1);
              schalterzk:=Copy(paramzk,1,Pos(' ',paramzk+' ')-1);
              Delete(paramzk,1,Length(schalterzk)+1);
              schalter_setzen;
            end;

      end;

    (*$IfDef TYP_EXE*)
    if (ParamCount>0) and (dateiliste='') and (not hilfe_anzeigen) then
      dateiliste:='*.*'#0;

    terminal_sichtbare_anzeige:=(terminal_dateiname='');
    (*$IfDef term_farbig*)
    if term in [(*$IfDef term_rollen*)term_rollen,(*$EndIf*)term_farbig] then
      terminal_sichtbare_anzeige:=true;
    (*$EndIf term_farbig*)


    if ausgabe_umgeleitet then
      begin

        terminal_sichtbare_anzeige:=false;

        (*$IfDef term_farbig*)
        if term in [(*$IfDef term_rollen*)term_rollen,(*$EndIf*)term_farbig] then
          begin
            term:=term_ansi;
            (*$IfDef VirtualPascal*)
            if IsFileHandleConsole(SysFileStdIn) then
              begin
                term:=term_mono;
              end;
            (*$EndIf VirtualPascal*)
          end;
        (*$EndIf term_farbig*)
      end;

    if multitask then
      begin
        term:=term_mono;
      end;

    (*$EndIf TYP_EXE*)

  end;

end.

