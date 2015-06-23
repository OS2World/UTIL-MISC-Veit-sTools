(* K:\ C:\ Q:\021\*.exe /U- /P- /S- /x1800 /Bc /M- /R- /h- /g- /s+*)
(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)


unit typ_haup;

interface

procedure EXE_HAUPTPROGRAMMAUFRUF;
(*$IfDef VirtualPascal*)
procedure einrichten_typ_haup(const anfang:boolean);
(*$EndIf VirtualPascal*)

implementation

(*$IfDef DPMI32*)
  (* $Define SPEICHERTEST*)
(*$EndIf DPMI32*)


uses
  (*heapchk,*)
  (*memleaks,*)

  (*$IfDef DPMI32*)
    dpmi32df,dpmi32,
  (*$EndIf DPMI32*)

  (*$IfDef DPMI32*)
    (*$IfNDef ENDVERSION*)
//      deb_link,
    (*$EndIf ENDVERSION*)
  (*$EndIf DPMI32*)

  (*$IfDef OS2*)
    Os2Base,
  (*$EndIf OS2*)

  (*$IfDef VirtualPascal*)
    typ_gt,
    VpUtils,
    VpSysLow,
    VpVKLow,
    aufrufst,
  (*$EndIf VirtualPascal*)

  (*$IfDef DOS_OVERLAY*)
    typ_ovr,
  (*$EndIf*)


  typ_type,
  typ_spra,(* Erst Sprache...dann Fehlermeldungen! *)

  (*$IfDef OS2*)
    typ_eas,
  (*$EndIf OS2*)

  (*$IfDef ERWEITERUNGSDATEI*)
  typ_erw,
  (*$EndIf ERWEITERUNGSDATEI*)

  typ_takt,
  typ_var,
  typ_eiau,
  typ_kopf,
  typ_dat,
  typ_exe0,
  typ_sekt,
  typ_ende,
  typ_hilf,
  typ_bios,
  typ_os,
  typ_poly,
  dos,
  typ_ausg,
  typ_varx,
  typ_eing,
  typ_dien,
  typ_die2,
  typ_entp,
  typ_for0,
  typ_for1,
  typ_for2,
  typ_for3,
  typ_for4,
  typ_for5,
  typ_xexe,
  typ_para,
  typ_c2e,
  typ_boot,
  typ_posm,
  typ_desc,
  typ_zeic;


(*$IfOpt S+*)
(*$Define STACK_PRUEFUNG1*)
(*$S-*)
(*$EndIf*)
procedure sauber_beenden;far;
  begin
    if ExitCode=202 then (* Stack Overflow *)
      asm
        (*$IfDef OS2*)
        (* Virtual Pascal 2.0 Beta2+
        add esp,020000
        add ebp,020000 *)
        (*$Else OS2*)
        add sp,02000
        add bp,02000
        (*$EndIf OS2*)
      end;

    ExitProc:=orgexitproc;

    if umgeschaltet then
      bildschirmverwaltung(falsch)
    else
      WriteLn(output);

    if maustreiber then
      maus_schalten(falsch);

    (*$IfDef OS2*)
    if ismultithread then
      beende_vioerneuerung;
    (*$EndIf OS2*)

    (*$IfDef TERM_ROLLEN*)
    (*$IfDef OS2*)
    if (term=term_rollen) then
      ldt_b8xx_weggeben;
    (*$EndIf OS2*)
    (*$EndIf TERM_ROLLEN*)

    if speicher_belegt then
      speicher_weggeben;

    if ErrorAddr<>nil then
      begin
        (*$IfDef Win32*)
        Assign(Output,'error.txt');
        Rewrite(Output);
        (*$EndIf*)
        Write(Output,' ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø'+#13#10
                    +textz_Laufzeitfehler_Alles_notieren^       +#13#10
                    +textz_Weiter_mit_enter^                    +#13#10
                    +' ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ'+#13#10
                    +' F=',ExitCode,
                     (*$IfDef KEINE_SEGMENTE*)
                       (*$IfDef DPMI32*)
                       ' EIP=',hex_longint(ptr_rec(ErrorAddr).offs                    ),' -> ',
                               hex_longint(ptr_rec(ErrorAddr).offs-code_base+$00401000),#13#10,
                       (*$Else DPMI32*)
                       ' EIP=',hex_longint(ptr_rec(ErrorAddr).offs),#13#10,
                       (*$EndIf DPMI32*)
                     (*$Else KEINE_SEGMENTE*)
                     ' CS:IP=',hex_word(CSeg+ptr_rec(ErrorAddr).selector),':',hex_word(ptr_rec(ErrorAddr).offs),
                     ' -> '   ,hex_word(     ptr_rec(ErrorAddr).selector),':',hex_word(ptr_rec(ErrorAddr).offs),+#13#10,
                     (*$EndIf KEINE_SEGMENTE*)
                     textz_typ__Dateiname^,dateiname,'" ');
      end
    else
      if abbruch_meldung<>'' then
        WriteLn(output,abbruch_meldung);

    if titel_geaendert then
      titel_aendern(falsch);

    if exitcode=0 then
      exitcode:=errorlevel;

    (*$IfDef PRUEFE_TAKT*)
    WriteLn(output,'richtig=',richtig);
    WriteLn(output,'falsch =',falsch);
    (*$EndIf*)

  end;

(*$IfDef STACK_PRUEFUNG1*)
(*$S+*)
(*$UnDef STACK_PRUEFUNG1*)
(*$EndIf*)


var
  datei_trennung        :string;

procedure verknuepfen(const dn:pathstr);
  var
    dateiname_gross     :string;
    datentyp            :word_norm;
    w1,w2,w3            :word_norm;
    dat_zeit            :longint;
  label
    berechne_naechsten_block,
    trotzdem_bearbeiten;

  begin
    dateiname:=dn;
    dateiname_gross:=gross(dateiname);
    ausschrift_v(dn);

    (* NDOS-Dateibeschreibung *)
    FSplit(dateiname_gross,pf,na,ex);
    verwerte_index(pf,na,ex);

    (*$IfDef OS2*)
    untersuche_eas(dn,'');
    (*$EndIf*)

    (* Ab hier ist die eigentliche Datei offen *)
    Assign(datei,dn);
    datei_oeffnen;
    if fehler<>0 then (* konnte nicht geîffnet werden *)
      Exit;

    loesche_merkpositionen;

    file_id_diz_datei:=falsch;

    (* Beschreibungsdateien *)
    if ((na='DESC') and (ex='.SDI'))
    or ((na='FILE_ID')) (* .DIZ .DEU .GER .ENG .PCB ... *)
    or ((na='DISK') and (ex='.ID'))
    or ((na='DIRINFO') and (ex=''))
    or ((na='DV') and (ex='.DAT'))
    or ((na='SDN') and (ex='.ID'))
     then
      begin
        ansi_anzeige(0,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,falsch,unendlich,'');
        file_id_diz_datei:=wahr;
      end;

    (* IBM Software Installer *.DSC *)
    if ex='.DSC' then
      begin
        datei_lesen(analysepuffer,analyseoff,512);
        (* aber nicht gradd .dsc *)
        if not bytesuche(analysepuffer.d[0],'* Title'#13#10) then
          begin
            ansi_anzeige(0,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],absatz,wahr,falsch,unendlich,'');
            file_id_diz_datei:=wahr;
          end;
      end;

    if (na='PASSWORD') and (ex='.DAT') then
      begin
        kopftext:='';
        w2:=0;
        while (w2<5) and textdatei_offen do
          begin
            text_lesen(exezk);
            inc(w2);
            for w3:=1 to Length(exezk) do
              case ((w3-1) mod 4) of
               0:exezk[w3]:=Chr(Ord(exezk[w3]) xor $b0);
               1:exezk[w3]:=Chr(Ord(exezk[w3]) xor $92);
               2:exezk[w3]:=Chr(Ord(exezk[w3]) xor $9d);
               3:exezk[w3]:=Chr(Ord(exezk[w3]) xor $ac);
              end;
            if w2>1 then
              kopftext:=kopftext+#$0d#$0a;
            kopftext:=kopftext+exezk;
          end;
        if w2>=4 then
          ausschrift(kopftext,beschreibung);
      end;

    if (na='PASSWORD') and (ex='.INI') then
      begin
        if textdatei_offen then
          begin
            text_lesen(kopftext);
            ausschrift(pctools_pw(kopftext),beschreibung);
          end;
      end;

    if (na='BOOTWIZ') and (ex='.CFG') then
      begin
        einzel_laenge:=dateilaenge;
        bootwiz_cfg(0,dateilaenge);
      end;

    if (na='XOSLDATA') and (ex='.XDF') then
      begin
        einzel_laenge:=dateilaenge;
        xosl_kennwort(0,einzel_laenge);
      end;


    if (na='WINFILE') and (ex='.DLL') then
      ausschrift(textz_Archivbetrug_von^+'WIC / Robert DEBRAYEL',virus);

    hersteller_erforderlich:=exe_dateierweiterung(na,ex);
    (*$I-*)
    GetFTime(datei,dat_zeit);
    (*$I+*)
    fehler:=IOResult;
    if fehler>0 then
      begin
        ausschrift_x(textz_Fehler^+'"'+fehlertext(fehler)+'" '+textz_beim_Bestimmen_von_Datum_und_Zeit^,dat_fehler,vorne);
        exit;
      end;
    UnpackTime(dat_zeit,dat_zeit_rec);

    with dat_zeit_rec do
      begin
        if (year>2080) then
          ausschrift(textz_Bereichsueberschreitung^+' '+textz_Jahr4^+'    : '+str0(year ),dat_fehler);
        if (month<1) or (month>12) then
          ausschrift(textz_Bereichsueberschreitung^+' '+textz_Monat5^+'   : '+str0(month),dat_fehler);
        if ((day<1) or (day>31))
        or ((day=29) and (month=2) and ((year mod 4>0) or (year mod 100=0)) and (year<>2000))
        or ((day=30) and (month=2))
        or ((day=31) and (month in [2,4,6,9,11]))
         then
          ausschrift(textz_Bereichsueberschreitung^+' '+textz_Tag3^+'     : '+str0(day  ),dat_fehler);
        if hour>23 then
          ausschrift(textz_Bereichsueberschreitung^+' '+textz_Stunde5^+'  : '+str0(hour ),dat_fehler);
        if min>59 then
          ausschrift(textz_Bereichsueberschreitung^+' '+textz_Minute6^+'  : '+str0(min  ),dat_fehler);
        if sec>59 then
          ausschrift(textz_Bereichsueberschreitung^+' '+textz_Sekunde7^+' : '+str0(sec  ),dat_fehler);
      end;
    if (dat_zeit_rec.year>jahr)
    or ((dat_zeit_rec.year=jahr) and (dat_zeit_rec.month>monat))
    or ((dat_zeit_rec.year=jahr) and (dat_zeit_rec.month=monat) and (dat_zeit_rec.day>tag)) then
      ausschrift(textz_Dateidatum_aktuelles_Datum^,dat_fehler);

    (* Anfang der eigentlichen Untersuchung *)
    einzel_laenge:=dateilaenge;
    is_sfx_pfad:='';

    (* Hauptschleife Einzeldatei *)
    (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)
    repeat

      zwischzeile:=true;
      hersteller_gefunden:=falsch;
      herstellersuche:=0;
      ende_suche_erzwungen:=false;
      textdatei:=false;

      einzel_laenge:=dateilaenge-analyseoff;
      bestimme_naechste_einzellaenge(analyseoff,einzel_laenge,datentyp);

      exe_sys_datei:=falsch;
      vermutung_pk:=falsch;
      zeige_ueberhang_nicht_an:=falsch;
      kopftext_nullen;


      (* NE/NF/LX/LE/PE/PMW1/...*)
      if x_exe_vorhanden and (analyseoff=x_exe_basis+x_exe_ofs) then
        begin
          x_exe_untersuchung;
          goto berechne_naechsten_block
        end;


      if einzel_laenge>0 then
        begin
          datei_lesen(analysepuffer,analyseoff,512);
          exe:=(exe_kopf.signatur=Ord('M')+Ord('Z') shl 8) or (exe_kopf.signatur=Ord('Z')+Ord('M') shl 8);
          if not exe then
            begin
              (* OS2KRNL UNI 2001.03.09 *)
              if ((analyseoff=   0) and (exe_kopf.signatur=Ord('O')+Ord('Z') shl 8))
              (* XLOADER / CyberMan + ST!LLS0N [2.00] *)
              or ((analyseoff=$270) and (exe_kopf.signatur=Ord('W')+Ord('G') shl 8))
              (* CC / UniHackers Group [2.61] 'UH' *)
              or ((analyseoff=$060) and (exe_kopf.signatur=Ord('U')+Ord('H') shl 8))
              (* XPACK 1.45 *)
              or ((analyseoff=$0b0) and (exe_kopf.signatur=Ord('j')+Ord('m') shl 8))
               then
                exe:=true;
            end;

          (* KLOCK / MaX MovSD *)
          if exe and (einzel_laenge=605) and (exe_kopf.kopfgroesse>(8000 div 16)) then
            exe:=false;

          case datentyp of
            datentyp_winzip:
              begin
                winzip(na+'.CFG');
                goto berechne_naechsten_block;
              end;
            datentyp_wp_cfg:
              begin
                ansi_anzeige(analyseoff,#0,ftab.f[beschreibung,hf]+ftab.f[beschreibung,vf],
                  absatz,wahr,wahr,analyseoff+einzel_laenge,'');
                goto berechne_naechsten_block;
              end;
            datentyp_wp_directory:
              begin
                exezk:=datei_lesen__zu_zk_e(analyseoff,#0,255);
                ausschrift(in_doppelten_anfuerungszeichen(exezk),beschreibung);
                befehl_mkdir(exezk);
                goto berechne_naechsten_block;
              end;
            datentyp_packexe:
              begin
                if bytesuche(analysepuffer.d[0],#$b4#$09#$ba'??'#$cd#$21#$cd#$20) then
                  begin
                    ansi_anzeige(analyseoff+8,'$',ftab.f[farblos,hf]+ftab.f[farblos,vf],
                      absatz,wahr,wahr,analyseoff+einzel_laenge,'');
                    goto berechne_naechsten_block;
                  end;
              end;
            datentyp_mscf_xor:
              begin
                mscf(analyseoff,einzel_laenge);
                goto berechne_naechsten_block;
              end;
            datentyp_innotek:
              begin
                swf5(x_longint__datei_lesen(analyseoff+einzel_laenge-$10+8),
                     true,
                     x_longint__datei_lesen(analyseoff+einzel_laenge-$10+4));
                goto berechne_naechsten_block;
              end;
            datentyp_innotek_pstr_zip:
              begin
                swf5(x_longint__datei_lesen(analyseoff+einzel_laenge-$10+4),
                     true,
                     x_longint__datei_lesen(analyseoff+einzel_laenge-$10+0));
                goto berechne_naechsten_block;
              end;
            datentyp_libindex:
              begin
                ausschrift('LIB Index',compiler);
                goto berechne_naechsten_block;
              end;
            datentyp_epicinst:
              begin
                epic_exe_installation(true);
                goto berechne_naechsten_block;
              end;
            datentyp_w32run_fc:
              begin
                (* siehe auch: typ_dat: dat_eb *)
                ausschrift('Watcom DOS32-extender file (W32RUN.EXE)',{dos_win_extender}compiler);
                goto berechne_naechsten_block;
              end;
            datentyp_flashtek:
              begin
                (* siehe auch: typ_exe0: exe_0e *)
                ausschrift('X-32(VM) Dos-Extender file / Doug Huffman; FlashTek',{dos_win_extender}compiler);
                goto berechne_naechsten_block;
              end;
          end;



          (* EXE *********************************************************)
          if exe then
            begin
              ds_off:=longint(exe_kopf.kopfgroesse)*16-$100;
              hersteller_erforderlich:=wahr;

              if signaturen and (exe_kopf.signatur=$5A4D) then
                if exe_kopf.overlaynummer=0 then
                  ausschrift('EXE',signatur)
                else
                  ausschrift('EXE-Overlay '+str0(exe_kopf.overlaynummer),signatur);

              if exe_kopf.signatur=$4D5A then
                ausschrift(textz_verdrehter_EXE_Kopf^,signatur);


              einzel_laenge:=longint(exe_kopf.sektorrest)+512*longint(exe_kopf.sektoren);
              if exe_kopf.sektorrest>0 then
                DecDGT(einzel_laenge,512);



              (* NE/LX/LE/PE/.. berechnen *)
              if not x_exe_vorhanden then
                with exe_kopf do
                  begin

                    if (ne_exe_offset>=$40)
                    and ( (relooffset>=$40) or (relooffset+longint(relokationspositionen)*4<=$3c) )
                    (* exe32pack [pe] *)
                    and ( (kopfgroesse>=4) or (kopfgroesse=0) or ((kopfgroesse=2) and (einzel_laenge<=$3c)) )
                    and (analyseoff+ne_exe_offset<dateilaenge)
                    (* and ((ne_exe_offset mod 2)=0) nicht: pksfx.prgm os/2 *)
                     then
                      begin
                        x_exe_vorhanden:=true;
                        x_exe_ofs:=exe_kopf.ne_exe_offset;
                        x_exe_basis:=analyseoff;
                      end
                    else
                      begin
                        x_exe_vorhanden:=false;
                        x_exe_ofs:=0;
                        x_exe_basis:=0;
                      end;


                    if exe then
                      begin

                        (* exe-kopf 0 para, cs:ip=0000:001c -> Spezialbehandlung *)
                        if bytesuche(analysepuffer.d[$10],#$1c#00#$00#$00#$1c#00#$00#$00#$00#$00#$00#$00
                            +#$8c#$ce#$8e#$de#$8e#$c6#$b8'??'#$c1#$e8#$04#$01#$c6#$b4#$3c#$31#$c9#$ba'??'
                            +#$52#$cd#$21#$93#$1e#$b9'??'#$51#$8e#$de) then
                           pe2com(word_z(@analysepuffer.d[$2e+1])^,
                                  word_z(@analysepuffer.d[$22+1])^,
                                  longint(word_z(@analysepuffer.d[$36+1])^) shl 4);


                        (* intro.exe und fsg.exe aus fsg133.zip *)
                        if bytesuche(analysepuffer.d[0],'MZ???'#$00#$00#$00#$04#$00'?'#$00'PE'#$00#$00#$4c#$01'?'#$00) then
                          begin
                            einzel_laenge:=$0c;
                            x_exe_vorhanden:=true;
                            x_exe_ofs:=exe_kopf.ne_exe_offset;
                            x_exe_basis:=analyseoff;
                          end
                        else
                        (* tinystub / crayzee  1.10 default *)
                        if  bytesuche(analysepuffer.d[0],'MZ'#$00#$00#$02#$00#$00#$00#$02#$00#$1e#$00#$1e#$00#$00#$00#$00)
                        and bytesuche(analysepuffer.d[$3c],#$40#$00#$00#$00'PE'#$00#$00) then
                          begin
                            einzel_laenge:=$40;
                            x_exe_vorhanden:=true;
                            x_exe_ofs:=exe_kopf.ne_exe_offset;
                            x_exe_basis:=analyseoff;
                          end
                        else
                        (* tinystub / crayzee  1.10 -s *)
                        if bytesuche(analysepuffer.d[0],'MZ????'#$00'tstubPE'#$00#$00#$4c#$01) then
                          begin
                            einzel_laenge:=$0c;
                            x_exe_vorhanden:=true;
                            x_exe_ofs:=exe_kopf.ne_exe_offset;
                            x_exe_basis:=analyseoff;
                          end;

                      end;
                  end;


              if longint(exe_kopf.kopfgroesse)*16=einzel_laenge then
                begin
                  ausschrift(textz_typ__leeres_programm^,signatur);
                  if einzel_laenge=0 then
                    einzel_laenge:=x_exe_ofs;
                  goto berechne_naechsten_block;
                end;

              (* ??? PECOMPACTOR 971 *)
              if (exe_kopf.kopfgroesse=0)
              or (exe_kopf.kopfgroesse>DivDGT(einzel_laenge,16)) (* inno setup verpfuscht den EXE-Kopf *)
               then
                begin
                  ausschrift(textz_kein_gueltiges_Programm^,signatur);

                  (* VACCINE / Rustam M. Abdrakhimov *)
                  if  (exe_kopf.ip_wert>=$1c)
                  and (exe_kopf.ip_wert<=$100)
                  and (exe_kopf.ip_wert=exe_kopf.relooffset)
                   then
                    goto trotzdem_bearbeiten;

                  if einzel_laenge=0 then
                    einzel_laenge:=x_exe_ofs;
                  goto berechne_naechsten_block;
                end;

  trotzdem_bearbeiten:
              codeoff_off:=0;
              codeoff_seg:=longint(exe_kopf.kopfgroesse);

              (* ausschrift ist nicht ganz sicher berechtigt
                 ss:sp=0:0 mit minheap/maxheap=0 ist schon schlimmer,
                 kommt aber auch noch vor: mkintor.exe (DOS-Anteil) *)
              (*
              if  (exe_kopf.stackoffset=0) ( * IMMUSE* )
              and (exe_kopf.sp_wert=0)
              and (exe_kopf.ip_wert=0)
              and (exe_kopf.cs_wert=0)
              and (exe_kopf.relooffset=0)
              and (not bytesuche(analysepuffer.d[$20],#$31#$c0#$48#$ba'???'#$00#$cd)) ( * 32LiTE 0.02d WDOSX EXE * )
               then
                ausschrift(textz_kein_gueltiges_Programm^,signatur)
              else*)
                begin
                  (* wenn nicht integer dann Probleme mit DERIVE/LISP *)

                  codeoff_off:=longint(exe_kopf.ip_wert);
                  codeoff_seg:=longint(exe_kopf.kopfgroesse)+longint(exe_kopf.cs_wert);
                  if exe_kopf.cs_wert>=$FFF0 then dec(codeoff_seg,$10000);

                  org_code_imagestart:=analyseoff+longint(exe_kopf.kopfgroesse)*16;
                  org_code_seg:=longint(exe_kopf.cs_wert);
                  org_code_off:=longint(exe_kopf.ip_wert);

                  herstellersuche:=0;
                  kopf_signaturen;
                  herstellersuche:=0;

                  if codeoff_seg*16+codeoff_off<0 then
                    begin
                      ausschrift(textz_Sprung_ins_PSP^,signatur);
                      FillChar(codepuffer,SizeOf(codepuffer),0);
                    end
                  else
                    datei_lesen(codepuffer,analyseoff+codeoff_seg*16+codeoff_off,512);

                  com2exe_test:=wahr;
                  pruefsummezeigen:=signaturen;


                  kopftext_berechnen;



                  herstellersuche:=1;

                  (* EXE0/EXE2 *)
                  durchsuchen;

                  (* SCAN/AG,... *)
                  if ((not hersteller_gefunden) or hersteller_erforderlich) and (x_exe_ofs=0) then
                    ende_suche(analyseoff+einzel_laenge);

                  (* Viren/Crypter *)
                  if (not hersteller_gefunden) then
                    poly_test(codepuffer);

                  herstellersuche:=0;

                  if  (not hersteller_gefunden)
                  and (length(exe_crypter_gefunden)>0) then
                    ausschrift(exe_crypter_gefunden,packer_exe);

                  if pruefsummezeigen then
                    ausschrift(textz_typ__negative_Pruefsumme^+hex_word(exe_kopf.pruefsumme),signatur);

                  if not hersteller_gefunden and not signaturen and (exe_kopf.signatur=$5A4D) then
                    if exe_kopf.overlaynummer=0 then
                      begin
                        if not exe_sys_datei then
                          ausschrift('EXE',signatur)
                      end
                    else
                      ausschrift('EXE-Overlay '+str0(exe_kopf.overlaynummer),signatur);

                  comtoexe_test;

                  if not(hersteller_gefunden) then
                    begin
                      if kopftext<>'' then
                        kopftext_anzeige(textz_Kopftext^,signatur);

                      ausschrift_nichts_gefunden(signatur);
                    end;

                  if ((not hersteller_gefunden) and com2exe_test) or signaturen then
                    begin

                      if exe_kopf.relokationspositionen=0 then
                        ausschrift(textz_0_relozierbare_Adressen^,signatur);

                      if exe_kopf.relokationspositionen=1 then
                        ausschrift(textz_1_relozierbare_Adresse^,signatur);

                    end;
                end;

              if einzel_laenge=0 then
                begin
                  ausschrift(textz_Fehler_in_der_Kopfstruktur^,dat_fehler);
                  analyseoff:=dateilaenge;
                end;
            end

          else (* nicht EXE **********************************************)

            begin
              if x_exe_vorhanden then
                begin
                  if analyseoff+einzel_laenge>x_exe_basis+x_exe_ofs then
                    begin
                      einzel_laenge:=x_exe_basis+x_exe_ofs-analyseoff;
                      (* Beispiel: SUNWUTIL.EXE (INSTALL SHIELD SFX *)
                      if einzel_laenge<0 then
                        begin
                          IncDGT(analyseoff,einzel_laenge);
                          Continue;
                        end;
                    end;
                end;

              untersuche_ob_textdatei;

              if (not textdatei) and (analyseoff=0) and (einzel_laenge>0) then
                begin
                  (* SMARTCHECK.CPS *)
                  if (ModDGT(einzel_laenge,$3c)=0) and (DivDGT(einzel_laenge,$3c)<=8000)
                  and versuche_carmel_pruefsummen_datei($3c,0) then
                    goto berechne_naechsten_block
                  else
                  (* MSAV MS DOS 6.22 *)
                  if (ModDGT(einzel_laenge,$1b)=0) and (DivDGT(einzel_laenge,$1b)<=8000)
                  and versuche_carmel_pruefsummen_datei($1b,0) then
                    goto berechne_naechsten_block
                  else
                  (* TNTSCAN 96/III CHKLST.TNT *)
                  if (ModDGT(einzel_laenge,$1c)=0) and (DivDGT(einzel_laenge,$1c)<=8000)
                  and versuche_carmel_pruefsummen_datei($1c,0) then
                    goto berechne_naechsten_block
                  else
                  (* CHKLIST.TAV *)
                  if (ModDGT(einzel_laenge,$3e)=4) and (DivDGT(einzel_laenge,$3e)<=8000)
                  and bytesuche__datei_lesen(analyseoff,#$34#$12)
                  and versuche_carmel_pruefsummen_datei($3e,4) then
                    goto berechne_naechsten_block;
                end;

              ds_off:=-$100;
              Move(analysepuffer,codepuffer,SizeOf(analysepuffer));
              w1:=puffer_pos_suche(codepuffer,'PKLITE Copr. ',$44);
              if w1=nicht_gefunden then
                w1:=puffer_pos_suche(codepuffer,'PKlite(R) Copr. ',$44);
              if (w1<>nicht_gefunden) and (w1>20) then
                kopftext:=puffer_zu_zk_l(codepuffer.d[w1-2],70)
              else
                kopftext:='';

              kopftextlaenge:=Length(kopftext);

              if {bin_erweiterung}
                 vergleiche_zk_ende('.BIN',dn)
              or vergleiche_zk_ende('IBMBIO.COM',dn)
              or vergleiche_zk_ende('IBMDOS.COM',dn)
               then
                begin (* ODIKRNL.BIN / Ontrack Diskmanager (TYP_POEM) *)
                  codeoff_seg:=0;
                  codeoff_off:=0;
                end
              else if bytesuche(analysepuffer.d[0],#$55#$aa) then
                begin
                  codeoff_seg:=0;
                  codeoff_off:=$3;
                end
              else
                begin
                  codeoff_seg:=-$10;
                  codeoff_off:=$100;
                end;

              herstellersuche:=1;
              org_code_imagestart:=analyseoff;
              org_code_seg:=codeoff_seg;
              org_code_off:=codeoff_off;

              start_sekt(codepuffer,wahr,255,falsch,0,0,0);

              dat_signaturen(analysepuffer);

              if rid_erweiterung then rid;
              if cpz_erweiterung then cpz;
              if ari_erweiterung then ari;
              if pgp_erweiterung then pgp_binaer;
              (*doppelt if wpi_erweiterung then wpi(analyseoff,'.WPI');*)

              relo_off:=analyseoff;

              if (not hersteller_gefunden) then
                durchsuchen;

              herstellersuche:=0;
              if (not hersteller_gefunden) or pocket_soft{!!!!} or ende_suche_erzwungen then
                begin
                  herstellersuche:=1;
                  if not x_exe_vorhanden then
                    ende_suche(analyseoff+einzel_laenge);
                  ende_suche_erzwungen:=false;
                  if (not hersteller_gefunden) and (hersteller_erforderlich or (analyseoff<>0) or vermutung_pk)
                  and (x_exe_ofs=0) then
                    poly_test(codepuffer);
                  herstellersuche:=0;

                  if  (not hersteller_gefunden)
                  and (length(exe_crypter_gefunden)>0) then
                    ausschrift(exe_crypter_gefunden,packer_exe);

                  (* RP/x86 "M.H." (RPX86.EXE) *)
                  (* IOMEGA (D_ASPI.AT) *)
                  if (not(hersteller_gefunden)) and (analyseoff>100) and (4<=einzel_laenge) and (einzel_laenge<80) then
                    begin
                      exezk:=puffer_zu_zk_l(analysepuffer.d[0],DGT_zu_longint(einzel_laenge));
                      if bytesuche(exezk[1],#13#10) then
                        delete(exezk,1,2); (* FSE 0.76 *)
                      if ist_ohne_steuerzeichen_nicht_so_streng(exezk) then
                        begin
                          ausschrift('"'+exezk+'"',beschreibung);
                          hersteller_gefunden:=true;
                        end;
                    end;

                  if not(hersteller_gefunden) and (hersteller_erforderlich or ((analyseoff<>0) and (x_exe_ofs=0))) then
                    ausschrift_nichts_gefunden(signatur);

                end;

            end; (* ELSE EXE *)

berechne_naechsten_block:

          (* OS/2 \OS2\MDOS\JOIN.EXE  *)
          (* QEMM: QEMM386.SYS        *)
          (* auch mit ARJ/2 probieren *)
          if x_exe_vorhanden and (analyseoff+einzel_laenge>x_exe_basis+x_exe_ofs) then
            begin
              exezk:=datei_lesen__zu_zk_l(x_exe_basis+x_exe_ofs{-analyseoff},2);
              if (exezk[1] in ['A'..'Z']) and (exezk[2] in ['A'..'Z']) then
                begin
                  einzel_laenge:=x_exe_basis+x_exe_ofs-analyseoff;
                  zeige_ueberhang_nicht_an:=true;
                end;
            end;


          if (einzel_laenge<=0) and (dateilaenge>0) then
            begin
              ausschrift(textz_Fehler_bei_Berechnung_der_Dateilaenge^,signatur);
              analyseoff:=dateilaenge;
            end
          else
            IncDGT(analyseoff,einzel_laenge);

          if analyseoff=x_exe_basis+x_exe_ofs then
            zeige_ueberhang_nicht_an:=true;

          if not zeige_ueberhang_nicht_an then
            if analyseoff<dateilaenge then
              ausschrift(textz_UEberhang_ab^+strx_oder_hexDGT(analyseoff)
                +textz_um^+strx_oder_hexDGT(dateilaenge-analyseoff),overlay_);

          if analyseoff>dateilaenge then
            begin
              ausschrift(textz_Bruchstueck_um^+strx_oder_hexDGT(analyseoff-dateilaenge),overlay_);
              analyseoff:=dateilaenge;
            end;


          if (analyseoff<dateilaenge) then
            if zwischzeile then
              ausschrift_leerzeile;

          (* exe32pack [pe] *)
          if (analyseoff-x_exe_basis=$3c) and x_exe_vorhanden and (x_exe_ofs=$40) then
            IncDGT(analyseoff,4);

        end;

    until (analyseoff>=dateilaenge);
    (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)

    datei_schliessen;

    if datei_trennung<>'' then
      ausschrift_x(datei_trennung,normal,vorne)

  end;
(*************************************************************)

function pass_versuch(var maske,dateiname:string;const m_i,m_l,d_i,d_l:word_norm):boolean;
  var
    z                   :word_norm;
  begin

    (* ''='' *)
    if m_l=0 then
      begin
        pass_versuch:=(d_l=0);
        Exit;
      end;

    (* '*' pa·t auf 0..n Zeichen im Dateiname *)
    if maske[m_i]='*' then
      for z:=d_l downto 0 do
        if pass_versuch(maske,dateiname,m_i+1,m_l-1,d_i+z,d_l-z) then
          begin
            pass_versuch:=true;
            Exit;
          end;

    pass_versuch:=false;

    (* 'Xxxx'<>'' *)
    if d_l<>0 then
      (* 'X'='X' oder '?'='X' *)
      if (maske[m_i]=dateiname[d_i]) or (maske[m_i]='?') then
        pass_versuch:=pass_versuch(maske,dateiname,m_i+1,m_l-1,d_i+1,d_l-1);

  end;

function passt(const maske0,dateiname0:string):boolean;
  var
    maske,dateiname     :string;
  begin
    passt:=false;

    maske    :=gross(maske0    );
    dateiname:=gross(dateiname0);

    if (maske=dateiname)
    or (maske='*.*')
    (*$IfDef VirtualPascal*)
    or (maske=AllFilesMask)
    (*$EndIf VirtualPascal*)
     then
      passt:=true
    else
      passt:=pass_versuch(maske,dateiname,1,Length(maske),1,Length(dateiname));
  end;

procedure datei_suche(const pf:DirStr;maske:maskentyp);
  var
    sr                  :SearchRec;
    laufwerksbuchstabe  :char;
    beschreibung_gesucht:boolean;
    index_vorhanden     :boolean;

  begin
    (*$IfDef DOS*)
    asm
      mov fehler,sp
    end;
    if fehler<8000 then
      begin
        ausschrift(pf,signatur);
        ausschrift_x(textz_Verzeichnisverschachtelung_zu_tief_uebergangen^,signatur,absatz);
        Exit;
      end;
    (*$EndIf DOS*)

    (*$IfNDef ENDVERSION*)
    dateiname:=pf+maske;
    (*$EndIf*)

    if maske='' then
      (*$IfDef VirtualPascal*)
      maske:=AllFilesMask;
      (*$Else*)
      maske:='*.*';
      (*$EndIf*)

    beschreibung_gesucht:=false;

    laufwerksbuchstabe:=UpCase(pf[1]);

    if  (laufwerksbuchstabe in ['A'..'`'])
    and (not datentraegername[laufwerksbuchstabe]) then
      begin
        (* DatentrÑgername *)
        benutzer_abfrage(false,false);

        (*$IfDef DOS_ODER_DPMI*)
        FindFirst(pf+'*.*',suchmaske_datentraegername,sr);
        if Dos.DosError=0 then
          begin
            exezk:=sr.name;
            (* "CANNON2.1" *)
            if Copy(exezk,9,1)='.' then
              Delete(exezk,9,1);
            if (sr.time<>-1) and (sr.time<>0) then
              begin
                UnpackTime(sr.time,dt);
                ausschrift(textz_Datentraegername^+': "'+exezk+'"'+textz_typ__erzeugt_am^
                  +str_(dt.year,4)+'.'+str_(dt.month,2)+'.'+str_(dt.day,2)+'  '
                  +str_(dt.hour,2)+'.'+str_(dt.min,2)+'.'+str_(dt.sec,2),beschreibung);
              end
            else
              ausschrift(textz_Datentraegername^+': "'+exezk+'"',beschreibung);
          end;
        (*$EndIf DOS_ODER_DPMI*)

        (*$IfDef VirtualPascal*)
        exezk:=GetVolumeLabel(laufwerksbuchstabe);
        (*while (exezk<>'') and (exezk[Length(exezk)]=' ') do
          DecLength(exezk);*)
        if exezk<>'' then
          begin
            sr.time:=SysGetVolumeLabelTime(laufwerksbuchstabe);
            if (sr.time<>-1) and (sr.time<>0) then
              begin
                UnpackTime(sr.time,dt);
                ausschrift(textz_Datentraegername^+': "'+exezk+'"'+textz_typ__erzeugt_am^
                  +str_(dt.year,4)+'.'+str_(dt.month,2)+'.'+str_(dt.day,2)+'  '
                  +str_(dt.hour,2)+'.'+str_(dt.min,2)+'.'+str_(dt.sec,2),beschreibung);
              end
            else
              ausschrift(textz_Datentraegername^+': "'+exezk+'"',beschreibung);
          end;
        (*$EndIf VirtualPascal*)

        datentraegername[laufwerksbuchstabe]:=wahr;
      end;

    (***************************************************************)
    (* Verzeichnisse                                               *)
    (***************************************************************)

    if unterverzeichnisse then
      begin
        Dos.DosError:=0;
        (*$IfDef VirtualPascal*)
        FindFirst(pf+AllFilesMask,suchmaske_verzeichnis,sr);
        (*$Else*)
        FindFirst(pf+'*.*'       ,suchmaske_verzeichnis,sr);
        (*$EndIf*)
        such_fehler:=Dos.DosError;

        while (such_fehler=0) and (zeilenstand<maxzeile) do
          begin
            if  ((sr.attr and directory)=directory)
            and (sr.name<>'.')
            and (sr.name<>'..')
            and (not passt(maske,sr.name))
            then
              (*$IfDef VirtualPascal*)
              datei_suche(pf+sr.name+SysPathSep,maske);
              (*$Else*)
              datei_suche(pf+sr.name+'\'       ,maske);
              (*$EndIf*)

            FindNext(sr);
            such_fehler:=Dos.DosError;

          end; (* while *)

        if not (such_fehler in [0,18]) then
          ausschrift(fehlertext(such_fehler),signatur);

        (*$IfDef VirtualPascal*)
        FindClose(sr);
        (*$EndIf VirtualPascal*)
      end;

    (***************************************************************)
    (* Dateien                                                     *)
    (***************************************************************)

    benutzer_abfrage(false,false);

    index_vorhanden:=suche_index(pf);
    beschreibung_gesucht:=true;

    FindFirst(pf+maske,suchmaske_datei or suchmaske_verzeichnis,sr);
    such_fehler:=Dos.DosError;

    while (such_fehler=0) and (zeilenstand<maxzeile) do
      begin

        if (sr.name<>'.') and (sr.name<>'..') then

          (* IHPFS liefert auch Verzeichnisse bei sehr tiefen
            Verzeichnisverschachtelungen zurÅck:
            'J:\GEM\GEM301D.ZIP\GEM301D\1STWORD2\DISK1\GEMAPPS\*.*
            mit Unterverzeichnis 'formats' *)
          if (sr.attr and Directory)=0 then
            begin

              if not beschreibung_gesucht then
                begin
                  if index_vorhanden then suche_index(pf)
                  else                    vergiss_index;
                  beschreibung_gesucht:=true;
                end;

              verknuepfen(pf+sr.name);
            end

          else (* Angegebenes Verzeichnis *)
            begin

              (*$IfDef OS2*)
              if eas_anzeigen then
                untersuche_eas(pf+sr.name,pf+sr.name+'\ [Verzeichnis]');
              (*$EndIf OS2*)

              if unterverzeichnisse then
                begin
                  beschreibung_gesucht:=false;
                  (*$IfDef VirtualPascal*)
                  datei_suche(pf+sr.name+SysPathSep,AllFilesMask);
                  (*$Else*)
                  datei_suche(pf+sr.name+'\'       ,'*.*'       );
                  (*$EndIf*)
                end;

            end;

        FindNext(sr);
        such_fehler:=Dos.DosError;

      end;

    if not (such_fehler in [0,18]) then
      ausschrift(fehlertext(such_fehler),signatur);

    (*$IfDef VirtualPascal*)
    FindClose(sr);
    (*$EndIf VirtualPascal*)
  end;

(***************************************************************************)
(*                                                                         *)
(*                               Hauptprg                                  *)
(*                                                                         *)
(***************************************************************************)

var
  list_datei_datei      :text;
  list_datei_offen      :boolean;
  list_datei            :boolean;

(*$IfDef SPEICHERTEST*)
procedure speichertest;
  var
    p:pointer;
    info:dpmimeminfo09_typ;
  begin
    if sysreadkey='j' then
      asm
        int 3
      end;

    fillchar(info,sizeof(info),$33);
    dpmi_getmeminfo09(info);
    with info do
      begin
        writeln('largest_available_block_in_bytes       =',largest_available_block_in_bytes);
        writeln('maximum_unlocked_page_allocation       =',maximum_unlocked_page_allocation);
        writeln('maximum_locked_page_allocation         =',maximum_locked_page_allocation);
        writeln('total_linear_address_space_in_pages    =',total_linear_address_space_in_pages);
        writeln('total_unlocked_pages                   =',total_unlocked_pages);
        writeln('free_pages                             =',free_pages);
        writeln('total_physical_pages                   =',total_physical_pages);
        writeln('free_linear_address_space_in_pages     =',free_linear_address_space_in_pages);
        writeln('size_of_paging_file_partition_in_pages =',size_of_paging_file_partition_in_pages);
      end;

    writeln('memavail:',memavail);
    writeln('memused :',memused);
    getmem(p,873947);
    writeln('memavail:',memavail);
    writeln('memused :',memused);


    readln;

    if sysreadkey='j' then
      asm
        sub eax,eax
        div eax
      end;
  end;
(*$EndIf SPEICHERTEST*)

procedure EXE_HAUPTPROGRAMMAUFRUF;
  begin
    (*$IfDef VirtualPascal*)
    if not Assigned(CmdLine) then
      CmdLine:=SysCmdln;
    (*$EndIf VirtualPascal*)

    (*$IfDef SPEICHERTEST*)
    speichertest;
    (*$EndIf SPEICHERTEST*)
    randomize;
    typ_eiau_init;
    typ_ausg_init;
    typ_os_init;
    einrichten_typ_zeic(true);

    suche_beendet:=falsch;

    orgexitproc:=exitproc;
    exitproc:=@sauber_beenden;

    dos_version:=Lo(DosVersion);

    (*$IfDef DOS*)
    if dos_version<3 then
      abbruch(textz_Programm_erfordert_XX_DOS_3^,abbruch_Rechnerausruestung_passt_nicht);

    (* VSAFE++ ausschalten *)
    (*$IfDef VSAFE *)
    swapvectors;
    asm
      mov ax,$fa02
      mov dx,$5945
      mov bx,0 (* aus *)
      int $21
      nop
      nop
    end;
    swapvectors;
    (*$EndIf VSAFE*)
    (*$EndIf DOS*) (* Dosversion*)

    blinken_aus;

    erkenne_grafik_adapter;

    parameter_auswerten;

    datei_trennung:=GetEnv('DATEI_TRENNUNG');
    if datei_trennung='' then
      datei_trennung:=GetEnv('FILE_SEPARATOR');

    (*$IfDef TERM_ROLLEN*)

      (*$IfDef OS2*)
      if (term=term_rollen) then
        if (SysCtrlSelfAppType>1)
        or (not ldt_b8xx_anfordern)
         then
          term:=term_farbig;

      (*$EndIf OS2*)

    if (term=term_rollen) and (not ega_oder_besser) then
      begin
        writeln(output,textz_kein_EGA_gefunden_Schalte_zu_CGA^);
        term:=term_farbig;
      end;
    (*$EndIf TERM_ROLLEN*)

    (*$IfDef DOS_ODER_DPMI*)
    if vga and (not (bzeilen in [0,25,28,50,60])) then
      abbruch(textz_Wie_soll_ich_bei_VGA^+str0(bzeilen)+textz_Zeilen_auf_den_Bildschirm_bekommen^+textz_VMODE_EGA^,
        abbruch_Rechnerausruestung_passt_nicht);

    if (not vga) and (not (bzeilen in [0,25,43])) then
      abbruch(textz_Wie_soll_ich_bei_EGA^+str0(bzeilen)+textz_Zeilen_auf_den_Bildschirm_bekommen^,
        abbruch_Rechnerausruestung_passt_nicht);
    (*$EndIf DOS_ODER_DPMI*)

    (*$IfDef TERM_FARBIG*)
    if term in [(*$IfDef TERM_ROLLEN*)term_rollen,(*$EndIf*)term_farbig] then
      if mono_bei_b000 then
        term:=term_mono;
    (*$EndIf TERM_FARBIG*)

    (*$IfNDef DPMI*)(* nicht fÅr DPMI implementiert! *)
    if multitask then
      begin
        (*$IfDef OS2*)
        beende_tastatur_thread;
        (*$EndIf OS2*)
        multitask_start;
      end;
    (*$EndIf DPMI*)

    zeilenspeicherung:=term in [
        (*$IfDef TERM_ROLLEN*)term_rollen,(*$EndIf*)
        (*$IfDef TERM_FARBIG*)term_farbig (*$EndIf*)];

    (*$IfDef OS2*)
    FileMode:=64(* DENY NONE *)+0 (* READ ONLY *);
    (*$EndIf OS2*)

    (*$IfDef DOS*)
    FileMode:=64(* DENY NONE *)+0 (* READ ONLY *);
    (*$EndIf DOS*)

    (*$IfDef DPMI*)
    FileMode:=64(* DENY NONE *)+0 (* READ ONLY *);
    (*$EndIf DPMI*)

    (*$IfDef DPMI32*)
    FileMode:=64(* DENY NONE *)+0 (* READ ONLY *);
    (*$EndIf DPMI32*)

    GetDir(0,erstverzeichnis);

    bildschirmverwaltung(wahr);

    titel_aendern(wahr);

    if zeilenspeicherung then
      speicher_anfordern;

    (* sonst kann TYP in Speichermangelsitualtionen hÑngen bleiben *)
    if maxzeile<2*bzeilen(*120*) then
      abbruch('MAXZEILE='+hex_longint(maxzeile)+' bzeilen='+hex_longint(bzeilen)+' - '
        +textz_Zu_wenig_Hauptspeicher_verfuegbar^,abbruch_Rechnerausruestung_passt_nicht);

    zeilenstand:=0;


    if not zeilenspeicherung then
      begin
        maustreiber:=falsch;
        (*$IfDef DOS*)
        spielhebel:=falsch;
        (*$EndIf DOS*)
      end;

    if maustreiber then
      maus_schalten(wahr);

    (*$IfDef DOS*)
    if spielhebel then
      spielhebel_schalten;
    (*$EndIf DOS*)

    (*$IfDef BILDWIEDERHOLRATE*)
    wiedrholratentest;
    if bildwiederholrate>200 then
      ausschrift('Angeblicher Bildaufbau '+str(bildwiederholrate,0)+' Hz!',signatur);
    (*$EndIf BILDWIEDERHOLRATE*)

    (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)
    (*€€  Anfang                                           €€*)
    (*€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€*)

    GetDate(jahr,monat,tag,wochentag);

    (*$IfDef DOS*)
    ermittle_bios_int_13;
    (*$EndIf DOS*)

    if hilfe_anzeigen then hilfe;

    (*$IfDef ERWEITERUNGSDATEI*)
    lade_erweiterungsdaten;
    (*$EndIf ERWEITERUNGSDATEI*)

    (*$IfDef GTDATA*)
    if gtdata_dll then
      lade_gtdata;
    (*$EndIf GTDATA*)

    (*$IfDef BILDWIEDERHOLRATE*)
    if signaturen then
      ausschrift('Bildwiederholrate = '+str(bildwiederholrate,0)+' Hz',signatur);
    (*$EndIf BILDWIEDERHOLRATE*)

    if parti_und_speicher then
      systemuntersuchung;

    (*$IfDef TERM_ROLLEN*)
    if term=term_rollen then
      begin
        geschwindigkeit:=norm_geschwindigkeit;

        (*$IfDef OS2*)
        starte_rollen_thread;
        setze_rollgeschwindigkeit(geschwindigkeit);
        (*$EndIf*)

      end;
    (*$EndIf TERM_ROLLEN*)



    selbsttest;

    initialisiere_laufwerkstabelle(startsektoren);

    if bios_pw_anzeigen then
      begin
        speicher_lesen(0,0,analysepuffer,16);
        einzel_laenge:=1024*1024;
        analyseoff:=0;
        ermittle_bios_hersteller('',wahr,falsch,falsch,$100000,$100000);
        (*alt:
        ermittle_bios_hersteller('',wahr,falsch,falsch,$0,$20000);*)
      end;

    while dateiliste<>'' do
      begin
        para:=Copy(dateiliste,1,Pos(#0,dateiliste)-1);
        Delete(dateiliste,1,Length(para)+1);

        if (length(para)>0) and (para[1]='@') then
          begin
            list_datei:=wahr;
            Delete(para,1,1);
            Assign(list_datei_datei,para);
            (*$I-*)
            Reset(list_datei_datei);
            (*$I+*)
            fehler:=IOResult;
            if fehler=0 then
              list_datei_offen:=true
            else
              begin
                list_datei_offen:=false;
                ausschrift(textz_Fehler_beim_OEffnen_der_Listdatei^+fehlertext(fehler),dat_fehler);
              end;
          end
        else
          begin
            list_datei_offen:=falsch;
            list_datei:=falsch;
          end;

        while (not list_datei) or (list_datei_offen) do
          begin
            if list_datei then
              begin
                if Eof(list_datei_datei) then
                  begin
                    Close(list_datei_datei);
                    list_datei_offen:=false;
                    Continue;
                  end;

                (*$I-*)
                Readln(list_datei_datei,para);
                (*$I+*)
                fehler:=IOResult;
                if fehler<>0 then
                  begin
                    ausschrift(textz_Lesefehler_Listdatei^+fehlertext(fehler),dat_fehler);
                    list_datei_offen:=false;
                    Continue;
                  end;
              end;

            unterverzeichnis_para:=(para='.') or ((Length(para)>1) and (para[Length(para)]='.')
             and (para[Length(para)-1] in [':','\','/']));
            para:=fexpand(para);
            if unterverzeichnis_para and (Length(para)>0) and (not (para[Length(para)] in ['\','/'])) then
              (*$IfDef VirtualPascal*)
              para:=para+SysPathSep;
              (*$Else*)
              para:=para+'\';
              (*$EndIf*)
            FSplit(para,pfad,name,erweiterung);

            bearbeite_startsektor(UpCase(para[1]));

            if startsektoren or parti_und_speicher or bios_pw_anzeigen or list_datei_offen then
              ausschrift_v(textz_Dateien_doppelpunkt^+pfad+name+erweiterung+']');

            datei_suche(pfad,name+erweiterung);
            (* recht.??? trift auch recht. *)

            if not list_datei then Break;
          end;
      end;

    gesamt_archiv_summe;

    if terminal_sichtbare_anzeige then (* nicht /B:A=CON *)
      repeat
        ausschrift_v('');
      until (zeilenstand>=longint(bzeilen)-2);

    suche_beendet:=wahr;
    if not zeilenspeicherung then
      begin
        while terminal_sichtbare_anzeige do
          ausschrift_v('');
        halt(abbruch_kein_problem);
      end;

    ausschrift_v('≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±≤'+textz_Alles_geschafft^+'≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±≤±');

    (*$IfDef DOS*)
    if multitask then
      asm
        (* TASK umschaltung *)
        mov ax,$2701 (* Index NR? *)
        int $2F

        add si,bx    (* Index ->ID *)
        mov dl,es:[si]
        mov dh,0

        mov ax,$2706 (* Umschalten zu Task DX *)
        int $2f
      end;
    (*$EndIf DOS*)

    repeat
      (*$IfDef OS2*)
      benutzer_abfrage(true,false)
      (*$Else*)
      if  (not maustreiber) (*$IfDef DOS*)and (not spielhebel)(*$EndIf*)
      and (richtung*geschwindigkeit=0)
       then
        benutzer_abfrage(false,true)
      else
        begin
          benutzer_abfrage(false,false);
          zeit_weggeben;
        end;
      (*$EndIf*)
    until falsch;


  end;

(*$IfDef VirtualPascal*)
procedure einrichten_typ_haup(const anfang:boolean);
  begin
    if anfang then
      begin
        aufrufst.install_exitproc;
        einrichten_typ_zeic(true);
        einrichten_typ_ausg(true);
        (*$IfDef ERWEITERUNGSDATEI*)
        einrichten_typ_erw (true);
        (*$EndIf ERWEITERUNGSDATEI*)
        einrichten_typ_gt  (true);
        einrichten_typ_dien(true);
        einrichten_typ_spra(true);
        {einrichten_typ_varx(true);}
      end
    else
      begin
        einrichten_typ_varx(false);
        einrichten_typ_spra(false);
        einrichten_typ_dien(false);
        einrichten_typ_gt  (false);
        (*$IfDef ERWEITERUNGSDATEI*)
        einrichten_typ_erw (false);
        (*$EndIf ERWEITERUNGSDATEI*)
        einrichten_typ_ausg(false);
        {einrichten_typ_zeic(false);}
      end;
  end;
(*$EndIf VirtualPascal*)

end.

