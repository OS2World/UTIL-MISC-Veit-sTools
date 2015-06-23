(*$A-,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+*)
(*$M 16384,0,0*)
program e0x_einstellungen;
(* V.K. 06.09.1996,11.09.1996         *)
(*      14.04.1997 LH LH C:\NC\NC.EXE *)
(*      05.07.1997 OPT! OPT %1        *)
(*                 und kein LH E0X (OS/2: OPT DISKOPT.EXE -> SYS3015  *)

uses crt,dos,e0x_ein2;

const
  e0x_com='E0X.COM';
var
  e0x_pfad:string;
  nc_pfad:string;
  path_pfad:string;
  bat_pfad:string;
  einzel:string;
  laufwerk:char;
  datei:text;
  fehler:word;
  rem:string[4];

function pfad_suche(programm:string):string;
  var
    tmpzk:string;
  begin
    tmpzk:=fsearch(programm,getenv('PATH'));

    if tmpzk='' then
      if rem='' then
        tmpzk:='REM '+programm
      else
        tmpzk:=programm
    else
      begin
        rem:='REM ';
      end;

    if pos('.BAT',tmpzk)>0 then
      tmpzk:='CALL '+tmpzk;

    pfad_suche:=tmpzk;
  end;

procedure abbruch(zk:string);
  var
    taste:char;
  begin
    writeln(zk);
    taste:=readkey;
    halt(length(zk));
  end;

function fehlertext(f:word):string;
  var
    zk:string;
  begin
    case f of
      3:fehlertext:=textz_fehler_dos_003^;
      5:fehlertext:=textz_fehler_dos_005^;
     15:fehlertext:=textz_fehler_dos_015^;
    101:fehlertext:=textz_fehler_dos_101^;
    150:fehlertext:=textz_fehler_dos_150^;
    152:fehlertext:=textz_fehler_dos_152^;
    158:fehlertext:=textz_fehler_dos_158^;
    162:fehlertext:=textz_fehler_dos_162^;
    else
       str(f,zk);
      fehlertext:=textz_unbekannter_Fehler^+zk;
    end;
  end;

begin


  checkbreak:=true;
  clrscr;
  writeln(textz_Dieses_Programm_erzeugt_Hilfsdateien1^);
  writeln(textz_Dieses_Programm_erzeugt_Hilfsdateien2^);
  writeln;
  path_pfad:=fexpand('.\')+';'+getenv('PATH');


  writeln('1. '+textz_Suche_von^+' ',e0x_com);
  e0x_pfad:=fsearch(e0x_com,path_pfad);
  if e0x_pfad='' then
    abbruch(#7+e0x_com+textz_nicht_gefunden^);

  e0x_pfad:=fexpand(e0x_pfad);
  writeln('  -> '+textz_gefunden_als^+' "'+e0x_pfad+'"');
  delete(e0x_pfad,1+length(e0x_pfad)-length(e0x_com),length(e0x_com));
  writeln;


  writeln('2. '+textz_Suche_von^+' NC.EXE');
  nc_pfad:=fsearch('NC.EXE',path_pfad);
  if nc_pfad='' then
    begin
      writeln('  '+textz_nicht_gefunden^+textz_waehle_deshalb_COMSPEC^);
      nc_pfad:='%COMSPEC%';
    end
  else
    begin
      nc_pfad:=fexpand(nc_pfad);
      writeln('  -> '+textz_gefunden_als^+' "'+nc_pfad+'"');
    end;
  writeln;


  writeln('3. '+textz_Zielfadauswahl_fuer_die_BAT_Dateien^);
  writeln;

  path_pfad:=path_pfad+';';
  repeat
    einzel:=copy(path_pfad,1,pos(';',path_pfad)-1);
    delete(path_pfad,1,1+length(einzel));
    if einzel<>'' then
      begin
        if copy(einzel,length(einzel),1)<>'\' then
          einzel:=einzel+'\';
        writeln('   - '+einzel);
      end;
  until path_pfad='';
  writeln;

  write  (textz_Ihre_Entscheidung^);
  readln(bat_pfad);
  bat_pfad:=fexpand(bat_pfad);
  if copy(bat_pfad,length(bat_pfad),1)<>'\' then
    bat_pfad:=bat_pfad+'\';
  writeln('  -> "'+bat_pfad+'"');
  writeln;


  writeln('4. '+textz_Schreiben_der_Hilfsdateien^);
  for laufwerk:='A' to 'B' do
    begin
      write  ('   '+bat_pfad+'E0'+laufwerk+'.BAT  ');
      assign(datei,bat_pfad+'E0'+laufwerk+'.BAT');
      (*$I-*)
      rewrite(datei);
      (*$I+*)
      fehler:=ioresult;
      if fehler<>0 then abbruch(#7+textz_fehler^+fehlertext(fehler));

      writeln(datei,'@ECHO OFF');
      writeln(datei,'IF "%1"=="/?" GOTO HILFE');
      writeln(datei,'IF "%1"=="-?" GOTO HILFE');
      writeln(datei,'IF "%1"=="?" GOTO HILFE');
      writeln(datei,'IF "%1"=="" GOTO HILFE');
      writeln(datei,'IF "%2"=="" GOTO START_1');
      writeln(datei,'IF "%2"=="1" GOTO START_X');
      writeln(datei,'IF "%2"=="2" GOTO START_X');
      writeln(datei,'IF "%2"=="3" GOTO START_X');
      writeln(datei,'GOTO HILFE');

      writeln(datei,':START_1');
      writeln(datei,e0x_pfad+e0x_com+' '+laufwerk+' %1 1 0 %COMSPEC% /E:1024 /C'+bat_pfad+'NC!.BAT '+laufwerk);
      writeln(datei,'GOTO ENDE');

      writeln(datei,':START_X');
      writeln(datei,e0x_pfad+e0x_com+' '+laufwerk+' %1 %2 0 %COMSPEC% /E:1024 /C'+bat_pfad+'NC!.BAT '+laufwerk);
      writeln(datei,'GOTO ENDE');

      writeln(datei,':HILFE');
      writeln(datei,'ECHO €ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€');
      writeln(datei,'ECHO €  '+textz_e0a_hilfe1^+laufwerk+textz_e0a_hilfe2^+' €');
      writeln(datei,'ECHO €  '+textz_e0a_hilfe3^+'  €');
      writeln(datei,'ECHO €                                                                      €');
      writeln(datei,'ECHO €  '+textz_e0a_hilfe4^+e0x_com+textz_e0a_hilfe5^+'  €');
      writeln(datei,'ECHO €‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€');
      writeln(datei,':ENDE');

      close(datei);

      writeln;
    end;

  write  ('   '+bat_pfad+'NC!.BAT  ');
  assign(datei,bat_pfad+'NC!.BAT');
  (*$I-*)
  rewrite(datei);
  (*$I+*)
  fehler:=ioresult;
  if fehler<>0 then abbruch(#7+textz_fehler^+fehlertext(fehler));

  writeln(datei,'@ECHO OFF');
  writeln(datei,'IF "%1"=="A" GOTO START');
  writeln(datei,'IF "%1"=="B" GOTO START');
  writeln(datei,'ECHO '+textz_Bitte_benutzen_sie_E0A_oder_E0B^);
  writeln(datei,'GOTO ENDE');

  writeln(datei,':START');
  writeln(datei,'IF NOT EXIST %1:\NUL GOTO FEHLER');
  writeln(datei,'%1:');
  writeln(datei,'SET PROMPT=[E0%1] %PROMPT%');
  writeln(datei,nc_pfad);
  writeln(datei,'GOTO ENDE');

  writeln(datei,':FEHLER');
  writeln(datei,'ECHO '+textz_Fehler_aufgetreten_Abbruch^);
  writeln(datei,':ENDE');

  close(datei);
  writeln;

  (* OPT.BAT *)
  write  ('   '+bat_pfad+'OPT.BAT  ');
  assign(datei,bat_pfad+'OPT.BAT');
  (*$I-*)
  rewrite(datei);
  (*$I+*)
  fehler:=ioresult;
  if fehler<>0 then abbruch(#7+textz_fehler^+fehlertext(fehler));

  writeln(datei,'@ECHO OFF');
  writeln(datei,'IF "%1"=="/?" GOTO HILFE');
  writeln(datei,'IF "%1"=="-?" GOTO HILFE');
  writeln(datei,'IF "%1"=="?" GOTO HILFE');
  writeln(datei,'IF "%1"=="" GOTO HILFE');

  writeln(datei,e0x_pfad+e0x_com+' A: %1 2 0 %COMSPEC% /E:1024 /C'+bat_pfad+'OPT!.BAT OPT %1');
  writeln(datei,'GOTO ENDE');

  writeln(datei,':HILFE');
  writeln(datei,'ECHO €ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€');
  writeln(datei,'ECHO €  '+textz_opt_hilfe1^+'             €');
  writeln(datei,'ECHO €  '+textz_opt_hilfe2^+'                                           €');
  writeln(datei,'ECHO €  '+textz_e0a_hilfe4^+e0x_com+textz_e0a_hilfe5^+'  €');
  writeln(datei,'ECHO €‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€');
  writeln(datei,':ENDE');

  close(datei);
  writeln;

  (* OPT!.BAT *)
  write  ('   '+bat_pfad+'OPT!.BAT  ');
  assign(datei,bat_pfad+'OPT!.BAT');
  (*$I-*)
  rewrite(datei);
  (*$I+*)
  fehler:=ioresult;
  if fehler<>0 then abbruch(#7+textz_fehler^+fehlertext(fehler));

  writeln(datei,'@ECHO OFF');
  writeln(datei,textz_REM_Bei_Bedarf_selbst_anpassen^);
  writeln(datei,'');
  writeln(datei,'IF "%1"=="OPT" GOTO START');
  writeln(datei,'ECHO '+textz_Bitte_benutzen_sie_OPT^);
  writeln(datei,'GOTO ENDE');
  writeln(datei,'');
  rem:='';
  writeln(datei,':START');
  writeln(datei,'');
  writeln(datei,'ECHO ========================== AV-Scanner ==========================');
  writeln(datei,'REM ˛ Thunderbyte');
  writeln(datei,rem,pfad_suche('TB.BAT'),' A: /IGNOFILE');
  writeln(datei,rem,pfad_suche('TBSCAN.EXE'),' A: /IGNOFILE');
  writeln(datei,'');
  writeln(datei,'REM ˛ Antivirial Toolkit Pro');
  writeln(datei,rem,pfad_suche('AVP.BAT'),' '+textz_avp_deutsch_parameter^+'A:');
  writeln(datei,rem,pfad_suche('AVP.EXE'),' '+textz_avp_deutsch_parameter^+'A:');
  writeln(datei,'');
  writeln(datei,'REM ˛ F-Prot');
  writeln(datei,rem,pfad_suche('FP.BAT'),' A:');
  writeln(datei,rem,pfad_suche('F-PROT.EXE'),' A:');
  writeln(datei,'IF ERRORLEVEL 1 GOTO FEHLER');
  writeln(datei,'');

  rem:='';
  writeln(datei,'ECHO ========================== Plattentest =========================');
  writeln(datei,'REM ˛ Symantec');
  writeln(datei,rem,pfad_suche('NDD.EXE'),' A: /Q /MULTITASK');
  writeln(datei,'');
  writeln(datei,'REM ˛ Central Point');
  writeln(datei,rem,pfad_suche('DISKFIX.EXE'),' A: /TEST');
  writeln(datei,'');
  writeln(datei,'REM ˛ DOS');
  writeln(datei,rem,pfad_suche('CHKDSK.COM'),' A: /F');
  writeln(datei,rem,pfad_suche('CHKDSK.EXE'),' A: /F');
  writeln(datei,'IF ERRORLEVEL 1 GOTO FEHLER');
  writeln(datei,'');

  rem:='';
  writeln(datei,'ECHO ========================== Optimierer ==========================');
  writeln(datei,'REM ˛ Novell');
  writeln(datei,rem,pfad_suche('DISKOPT.EXE'),' A: /O /Sa /M2');
  writeln(datei,'');
  writeln(datei,'REM ˛ Symantec');
  writeln(datei,rem,pfad_suche('SD.EXE'),' A: /FF /Q /Sne /SKIPHIGH /MULTITASK');
  writeln(datei,rem,pfad_suche('SPEEDISK.EXE'),' A: /FF /Q /Sne /SKIPHIGH /MULTITASK');
  writeln(datei,'');
  writeln(datei,'REM ˛ Central Point');
  writeln(datei,rem,pfad_suche('OPTIMIZR.EXE'),' A: /FC /NM /OO /SF /SKIPALL /NF /IM');
  writeln(datei,'');
  writeln(datei,'REM ˛ Micro$oft');
  writeln(datei,rem,pfad_suche('DEFRAG.EXE'),' A: /F /Sne /H /SKIPHIGH /MULTITASK');
  writeln(datei,'IF ERRORLEVEL 1 GOTO FEHLER');
  writeln(datei,'');

  rem:='';
  writeln(datei,'ECHO ============== gelîschte Informationen vernichten ==============');
  writeln(datei,'REM ˛ Symantec');
  writeln(datei,rem,pfad_suche('WIPEINFO'),' A: /E /BATCH /MULTITASK');
  writeln(datei,'');
  writeln(datei,'REM ˛ Central Point');
  writeln(datei,rem,pfad_suche('WIPE'),' A: /UNUSED /DISK /QUIET');
  writeln(datei,'IF ERRORLEVEL 1 GOTO FEHLER');
  writeln(datei,'');

  rem:='';
  writeln(datei,'ECHO ========================== PrÅfsummen ==========================');
  writeln(datei,'REM ˛ Thunderbyte');
  writeln(datei,rem,pfad_suche('TBS.BAT'),' A:');
  writeln(datei,rem,pfad_suche('TBSETUP.EXE'),' A:');
  writeln(datei,'IF ERRORLEVEL 1 GOTO FEHLER');
  writeln(datei,'');

  rem:='';
  writeln(datei,'ECHO ==================== Entlîschinformatioen ======================');
  writeln(datei,'REM ˛ Novell');
  writeln(datei,rem,pfad_suche('DISKMAP.EXE'),' A:');
  writeln(datei,'');
  writeln(datei,'REM ˛ Symantec');
  writeln(datei,rem,pfad_suche('IMAGE.EXE'),' A: /NOBACKUP');
  writeln(datei,'');
  writeln(datei,'REM ˛ Central Point, Micro$oft');
  writeln(datei,rem,pfad_suche('MIRROR.COM'),' A: /1');
  writeln(datei,'IF ERRORLEVEL 1 GOTO FEHLER');
  writeln(datei,'');
  writeln(datei,'GOTO ENDE');
  writeln(datei,'');

  writeln(datei,':FEHLER');
  writeln(datei,textz_opt_hilfe3^);
  writeln(datei,textz_opt_hilfe4^);
  writeln(datei,textz_opt_hilfe5^);
  writeln(datei,'%COMSPEC%');
  writeln(datei,'');
  writeln(datei,':ENDE');

  close(datei);
  writeln;

end.
