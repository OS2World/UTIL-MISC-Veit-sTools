(*$I TYP_COMP.PAS*)
(*$IfDef DOS_OVERLAY*)
(*$O+*)
(*$EndIf*)

(* $Define ENDVERSION*)
unit typ_entp;

interface

uses
  typ_type;

function  ohne_pfad(const dateiname:string):string;
procedure befehl_schnitt(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
procedure befehl_schnitt2(const quelle:string;const anfangsposition,laenge:dateigroessetyp;const zielname:string);
procedure befehl_unpack2(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
procedure befehl_unzip2(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
procedure befehl_e_infla(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
procedure befehl_ttdecomp(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
procedure befehl_echo(const kommentar:string);
procedure befehl_exx(const kennwort:string);
function  erzeuge_neuen_dateinamen(const neue_erweiterung:string):string;
function  erzeuge_vollen_neuen_dateinamen(const neue_erweiterung:string):string;
function  erzeuge_kurzen_dateinamen:string;
procedure befehl_erzeuge_verzeichnisse_rekursiv(const dateiname:string);
procedure befehl_gnuunzip(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
procedure befehl_bzip2_d(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
procedure befehl_mkdir(const verzeichnisname:string);
procedure befehl_mkdir_fuer_datei(const dateiname:string);
function  trenne_pfad_ab(const dateiname:string):string;
procedure befehl_rexx2exe(const dateiname:string;schluessel:longint);
procedure befehl_eautil(const dn:string);
procedure befehl_protect(const kennwort:string);
procedure befehl_ole2x;
procedure befehl_xx3402(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
procedure befehl_sonst(const befehl:string);
procedure befehl_expand_ms(const anfangsposition,laenge:dateigroessetyp;var zielname:string);
procedure rate_dateinamenserweiterung(var zielname:string;const vorschlag:string);
procedure befehl_del(const dateiname:string);
procedure befehl_petite2122;
procedure befehl_hmp;
procedure befehl_i5comp;
procedure befehl_i6comp;
procedure befehl_swc(const anfangsposition,laenge:dateigroessetyp;const zielname:string;const p:puffertyp);
procedure befehl_isssldeco(const dateiname:string);
procedure befehl_xor(const anfangsposition,laenge:dateigroessetyp;const zielname:string;xorb:byte);
procedure befehl_rem_zaehler(summand:integer_norm);

implementation

uses
  Dos,
  typ_var,
  typ_varx,
  typ_ausg;

{$IfDef OS2}
const
  betriebssystemkennung='O';
{$Else}
const
  betriebssystemkennung='D';
{$EndIf}

const
  rem_zaehler           :integer_norm=0;

(*$IfDef ENTP_BAT_CMD*)
(*$EndIf*)

function anfzeichen_wenn_noetig(const dateiname:string):string;
  begin
    if (Pos(' ',dateiname)<>0)
    or (Pos('&',dateiname)<>0)
    or (Pos('^',dateiname)<>0)
     then
      anfzeichen_wenn_noetig:='"'+dateiname+'"'
    else
      anfzeichen_wenn_noetig:=dateiname;
  end;

function entferne_laufwerk_und_anfangspfadstrich(dateiname:string):string;
  begin
    if (Pos(':',dateiname)=2) and (UpCase(dateiname[1]) in ['A'..'`']) then
      Delete(dateiname,1,Length('C:'));

    while (dateiname<>'') and (dateiname[1] in ['\','/']) do
      Delete(dateiname,1,Length('\'));

    entferne_laufwerk_und_anfangspfadstrich:=dateiname;
  end;

function ohne_pfad(const dateiname:string):string;
  var
    ver                 :DirStr;
    nam                 :NameStr;
    erw                 :ExtStr;
  begin
    FSplit(dateiname,ver,nam,erw);
    ohne_pfad:=nam+erw;
  end;


procedure schreibe_entp(const zeile:string);
  var
    e                   :text;
  begin
    if entp_bat_cmd='' then Exit;

    Assign(e,entp_bat_cmd);
    (*$I-*)
    Append(e);
    (*$I+*)
    if IOResult<>0 then
      begin
        (*$I-*)
        Rewrite(e);
        (*$I+*)
        if IOResult<>0 then
          Exit;

        WriteLn(e,'@ECHO OFF');
        WriteLn(e,'REM ',typ_exe_name,' ',str_(typ_jahr,4),'.',str_(typ_mon,2),'.',str_(typ_tag,2));
      end;

    if rem_zaehler>0 then
      Write(e,'REM  ');
    WriteLn(e,zeile);
    Close(e);
  end;

procedure befehl_schnitt(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
  begin
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '+DGT_str0(laenge)+' '
      +anfzeichen_wenn_noetig(entferne_laufwerk_und_anfangspfadstrich(zielname)));
  end;

procedure befehl_schnitt2(const quelle:string;const anfangsposition,laenge:dateigroessetyp;const zielname:string);
  begin
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(quelle)+' '+DGT_str0(anfangsposition)+' '+DGT_str0(laenge)+' '
      +anfzeichen_wenn_noetig(entferne_laufwerk_und_anfangspfadstrich(zielname)));
  end;

procedure befehl_unpack2(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
  var
    p:DirStr;
    n:NameStr;
    e:ExtStr;
  begin
    schreibe_entp('REM '+zielname);
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
      +DGT_str0(laenge)+' TMP.TYP');
    FSplit(zielname,p,n,e);
    schreibe_entp('unpack2.exe TMP.TYP '+anfzeichen_wenn_noetig(entferne_laufwerk_und_anfangspfadstrich(p)));
    schreibe_entp('DEL TMP.TYP');
  end;

procedure befehl_unzip2(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
  var
    p:DirStr;
    n:NameStr;
    e:ExtStr;
  begin
    schreibe_entp('REM '+zielname);
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
      +DGT_str0(laenge)+' TMP.TYP');
    FSplit(zielname,p,n,e);
    schreibe_entp('unzip.exe TMP.TYP '+anfzeichen_wenn_noetig(entferne_laufwerk_und_anfangspfadstrich(p)));
    schreibe_entp('DEL TMP.TYP');
  end;

procedure befehl_e_infla(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
  begin
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
      +DGT_str0(laenge)+' TMP.TYP');
    schreibe_entp('CALL E_INFLA TMP.TYP '+anfzeichen_wenn_noetig(entferne_laufwerk_und_anfangspfadstrich(zielname)));
    schreibe_entp('DEL TMP.TYP');
  end;

procedure befehl_ttdecomp(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
  begin
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
      +DGT_str0(laenge)+' TMP.TYP');
    schreibe_entp('CALL TTDECOMP TMP.TYP '+anfzeichen_wenn_noetig(zielname));
    schreibe_entp('DEL TMP.TYP');
  end;

procedure befehl_echo(const kommentar:string);
  begin
    schreibe_entp('ECHO '+kommentar);
  end;

procedure befehl_set(const zuweisung:string);
  begin

  end;

procedure befehl_exx(const kennwort:string);
  var
    name_:string;
  begin
    name_:=anfzeichen_wenn_noetig(erzeuge_vollen_neuen_dateinamen(''));
    schreibe_entp('MkDir '+name_);
    schreibe_entp('EXX.EXE '+name_+'.EXX'+' '+name_+' '+kennwort+' -');
  end;

function  erzeuge_neuen_dateinamen(const neue_erweiterung:string):string;
  var
    ver                 :DirStr;
    nam                 :NameStr;
    erw                 :ExtStr;
  begin
    FSplit(dateiname,ver,nam,erw);
    erzeuge_neuen_dateinamen:=nam+neue_erweiterung;
  end;

function  erzeuge_vollen_neuen_dateinamen(const neue_erweiterung:string):string;
  var
    ver                 :DirStr;
    nam                 :NameStr;
    erw                 :ExtStr;
  begin
    FSplit(dateiname,ver,nam,erw);
    erzeuge_vollen_neuen_dateinamen:=ver+nam+neue_erweiterung;
  end;

(*
function  erzeuge_vollen_neuen_dateinamen2(const dateiname,neue_erweiterung:string):string;
  var
    ver                 :DirStr;
    nam                 :NameStr;
    erw                 :ExtStr;
  begin
    FSplit(dateiname,ver,nam,erw);
    erzeuge_vollen_neuen_dateinamen2:=ver+nam+neue_erweiterung;
  end;*)

function  erzeuge_neuen_dateinamen2(const dateiname,neue_erweiterung:string):string;
  var
    ver                 :DirStr;
    nam                 :NameStr;
    erw                 :ExtStr;
  begin
    FSplit(dateiname,ver,nam,erw);
    erzeuge_neuen_dateinamen2:=nam+neue_erweiterung;
  end;

function erzeuge_kurzen_dateinamen:string;
  var
    ver                 :DirStr;
    nam                 :NameStr;
    erw                 :ExtStr;
  begin
    FSplit(dateiname,ver,nam,erw);
    erzeuge_kurzen_dateinamen:=nam+erw;
  end;

procedure befehl_erzeuge_verzeichnisse_rekursiv(const dateiname:string);
  var
    verz                :DirStr;
    name_               :NameStr;
    erw                 :ExtStr;
    verz_anfang         :string;
    w1                  :word_norm;
    jetzt               :string;
  begin
    FSplit(dateiname,verz,name_,erw);
    verz_anfang:='';

    repeat
      if verz='' then Break;
      if verz[1] in ['\','/'] then
        begin
          Delete(verz,1,1);
          Continue;
        end
      else
      if Copy(verz,2,1)=':' then
        begin
          (*verz_anfang:=Copy(verz,1,2);*)
          Delete(verz,1,2);
          Continue;
        end
      else
        Break;
    until false;

    while verz<>'' do
      begin
        w1:=Pos('\',verz);
        if w1=0 then
          w1:=Pos('/',verz);
        if w1=0 then
          w1:=Length(verz)+1;

        Dec(w1);

        if w1<>0 then
          begin
            jetzt:=verz_anfang+Copy(verz,1,w1);
            (*$IfDef OS2*)
            schreibe_entp('If Not Exist '+anfzeichen_wenn_noetig(jetzt       )+' MkDir '+anfzeichen_wenn_noetig(jetzt));
            (*$Else*)
            schreibe_entp('If Not Exist '+anfzeichen_wenn_noetig(jetzt+'\NUL')+' MkDir '+anfzeichen_wenn_noetig(jetzt));
            (*$EndIf*)
          end;

        verz_anfang:=verz_anfang+Copy(verz,1,w1)+'\';
        Delete(verz,1,w1+1);

      end;

  end;

procedure befehl_gnuunzip(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
  begin
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
      +DGT_str0(laenge)+' TMP.TYP');
    schreibe_entp('CALL gzip -d < TMP.TYP > '+anfzeichen_wenn_noetig(zielname));
    schreibe_entp('DEL TMP.TYP');
  end;

procedure befehl_bzip2_d(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
  begin
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
      +DGT_str0(laenge)+' TMP.TYP');
    schreibe_entp('CALL bzip2 -d < TMP.TYP > '+anfzeichen_wenn_noetig(zielname));
    schreibe_entp('DEL TMP.TYP');
  end;

procedure befehl_mkdir(const verzeichnisname:string);
  var
    kopie       :string;
    z           :word_norm;
  begin
    {
    kopie:=verzeichnisname;
    for z:=1 to Length(kopie) do
      if kopie[z]='/' then
        kopie[z]:='\';

    if Length(kopie)>=Length('C:') then
      if (UpCase(kopie[1]) in ['A'..'`']) and (kopie[2]='\') then
        Delete(kopie,1,Length('C:'));
    if kopie<>'' then
      if kopie[1]='\' then
        Delete(kopie,1,Length('\'));
    if kopie<>'' then
      if kopie[Length(kopie)]='\' then
        DecLength(kopie);

    if kopie<>'' then
      begin
        (*$IfDef OS2*)
        schreibe_entp('If Not Exist '+kopie+' MkDir '+kopie);
        (*$Else*)
        schreibe_entp('If Not Exist '+kopie+'\NUL MkDir '+kopie);
        (*$EndIf*)
      end;
     }
    kopie:=verzeichnisname;
    if kopie<>'' then
      begin
        if not (kopie[Length(kopie)] in ['\','/']) then
          begin
            kopie:=kopie+'\nul';
          end;
        befehl_erzeuge_verzeichnisse_rekursiv(kopie);
      end;
  end;

procedure befehl_mkdir_fuer_datei(const dateiname:string);
{  var
    p:DirStr;
    n:NameStr;
    e:ExtStr;}
  begin
{    FSplit(dateiname,p,n,e);
    befehl_mkdir(p);}
    befehl_erzeuge_verzeichnisse_rekursiv(dateiname);
  end;

function trenne_pfad_ab(const dateiname:string):string;
  var
    p1:word_norm;
  begin
    p1:=Length(dateiname);
    while (p1>1) and (not (dateiname[p1-1] in ['\','/'])) do
      Dec(p1);
    trenne_pfad_ab:=Copy(dateiname,p1,Length(dateiname)-(p1-1));
  end;

procedure befehl_rexx2exe(const dateiname:string;schluessel:longint);
  begin
    schreibe_entp('echo  72 22 ... eb 22');
    schreibe_entp('echo please wait..');
    schreibe_entp('SET '+dateiname+'=0x'+Copy(hex_longint(schluessel),2,8));
    schreibe_entp(dateiname+' > '+erzeuge_neuen_dateinamen('.log'));
  end;

procedure befehl_eautil(const dn:string);
  begin
    schreibe_entp('EAUtil '+anfzeichen_wenn_noetig(dn)+' '
      +anfzeichen_wenn_noetig(erzeuge_neuen_dateinamen2(dn,'.EA'))+' /P /S');
  end;

procedure befehl_protect(const kennwort:string);
  begin
    schreibe_entp('Protect.exe '+anfzeichen_wenn_noetig(kennwort)+' '+anfzeichen_wenn_noetig(dateiname));
  end;

procedure befehl_ole2x;
  begin
    schreibe_entp('ole2x_'+betriebssystemkennung+' '
      +anfzeichen_wenn_noetig(dateiname)+' '+anfzeichen_wenn_noetig(erzeuge_neuen_dateinamen('')+'\'));
  end;

procedure befehl_xx3402(const anfangsposition,laenge:dateigroessetyp;const zielname:string);
  begin
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
      +DGT_str0(laenge)+' TMP.TYP');
    schreibe_entp('xx3402.exe d TMP.TYP');
    schreibe_entp('DEL TMP.TYP');
  end;

procedure befehl_sonst(const befehl:string);
  begin
    schreibe_entp(befehl);
  end;

procedure befehl_expand_ms(const anfangsposition,laenge:dateigroessetyp;var zielname:string);
  begin
    if zielname='' then
      zielname:=ohne_pfad(dateiname)+'.'+DGT_str0(anfangsposition);

    if (anfangsposition=0) and (Length(ohne_pfad(dateiname))<=8+1+3) then
      begin
        schreibe_entp('CALL EXPAND '+anfzeichen_wenn_noetig(dateiname)+' '+anfzeichen_wenn_noetig(zielname));
      end
    else
      begin
        schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
          +DGT_str0(laenge)+' TMP.TYP');
        schreibe_entp('CALL EXPAND TMP.TYP TMP2.TYP');
        schreibe_entp('DEL TMP.TYP');
        schreibe_entp('IF EXIST '+anfzeichen_wenn_noetig(zielname)+' DEL '+anfzeichen_wenn_noetig(zielname));
        schreibe_entp('REN TMP2.TYP '+anfzeichen_wenn_noetig(zielname));
      end;
  end;

procedure rate_dateinamenserweiterung(var zielname:string;const vorschlag:string);
  const
    erw         :array[1..28] of string[3]=
      (''   ,'HLP','EXE','DLL','TXT','DAT','OVL','REG','BMP','FON',
       'DRV','386','2GR','3GR','SYS','MID','VID','BAT','BIN','FNT',
       'PIF','WRI','CFG','HIM','COM','OPT','URL','ICO');
    (* OPT/DAT: gkware_selfextractor_tmp *)

    (* CPI/CPL
       INI/INF
       PRG/PRO
       RSP/RSL *)
  var
    p           :DirStr;
    n           :NameStr;
    e           :ExtStr;
    i           :integer_norm;
  begin
    FSplit(zielname,p,n,e);
    if (vorschlag<>'') and (Pos('@',vorschlag)=0) then
      e:='.'+vorschlag
    else
      begin
        e:=gross(e);
        while (e<>'') and (e[Length(e)] in ['_','%','$']) do
          (*$IfDef VirtualPascal*)
          DecLength(e);
          (*$Else*)
          Dec(e[0]);
          (*$EndIf*)

        if Pos('.',e)=1 then Delete(e,1,Length('.'));

        for i:=Low(erw) to High(erw) do
          if Pos(e,erw[i])=1 then
            begin
              e:=erw[i];
              Break;
            end;
      end;

    zielname:=n+'.'+e;
  end;

procedure befehl_del(const dateiname:string);
  begin
    schreibe_entp('del '+anfzeichen_wenn_noetig(dateiname));
  end;

procedure befehl_petite2122;
  var
    u:string;
  begin
    (* enlarge13.zip / r!sc *)
    schreibe_entp('pec "petite_unpacker.exe" '+anfzeichen_wenn_noetig(dateiname));
    u:=anfzeichen_wenn_noetig(ohne_pfad(dateiname)+'~');
    schreibe_entp('if exist '+u+' del '+u);
    schreibe_entp('ren un-packed.exe '+u);
  end;

procedure befehl_hmp;
  begin
    schreibe_entp('REM ripper5 convert.zip ');
    schreibe_entp('hmp2mid.exe '+anfzeichen_wenn_noetig(dateiname)+' '
                                +anfzeichen_wenn_noetig(erzeuge_neuen_dateinamen('.mid')));
  end;

procedure befehl_i5comp;
  begin
    schreibe_entp('call pec "i5comp2.exe" x '+anfzeichen_wenn_noetig(dateiname));
  end;

procedure befehl_i6comp;
  begin
    schreibe_entp('REM i6cmp13b.zip');
    schreibe_entp('call pec "i6comp.exe" x '+anfzeichen_wenn_noetig(dateiname));
  end;

procedure befehl_swc(const anfangsposition,laenge:dateigroessetyp;const zielname:string;const p:puffertyp);
  var
    i:word_norm;
    b:byte;
    s:string;
  begin
    s:='046h'; (* F *)
    for i:=1 to 7 do
      s:=s+',0'+Copy(hex(p.d[i]),2,2)+'h';
    schreibe_entp('echo db '+s+' > %tmp%\swf.a86');

    schreibe_entp('a86 %tmp%\swf.a86 to %tmp%\swf.hdr nul');
    schreibe_entp('del %tmp%\swf.a86');

    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
      +DGT_str0(laenge)+' %TMP%\TMP.TYP');
    schreibe_entp('CALL E_INFLA %TMP%\TMP.TYP %TMP%\swf.dat');
    schreibe_entp('del %TMP%\TMP.TYP');
    schreibe_entp('copy /b %TMP%\swf.hdr + %TMP%\swf.dat '+
      anfzeichen_wenn_noetig(entferne_laufwerk_und_anfangspfadstrich(zielname)));
    schreibe_entp('del %TMP%\swf.hdr');
    schreibe_entp('del %TMP%\swf.dat');
  end;

procedure befehl_isssldeco(const dateiname:string);
  begin
    schreibe_entp('IssSlDeco.exe '+anfzeichen_wenn_noetig(dateiname)+' '+anfzeichen_wenn_noetig(dateiname));
  end;

procedure befehl_xor(const anfangsposition,laenge:dateigroessetyp;const zielname:string;xorb:byte);
  begin
    schreibe_entp('CALL SCHNITT '+anfzeichen_wenn_noetig(dateiname)+' '+DGT_str0(anfangsposition)+' '
      +DGT_str0(laenge)+' %TMP%\TMP.TYP');
    schreibe_entp('call xor %TMP%\TMP.TYP '+anfzeichen_wenn_noetig(ohne_pfad(zielname))+' '+hex(xorb));
    schreibe_entp('del %TMP%\TMP.TYP');
  end;

procedure befehl_rem_zaehler(summand:integer_norm);
  begin
    Inc(rem_zaehler,summand);
  end;

end.

