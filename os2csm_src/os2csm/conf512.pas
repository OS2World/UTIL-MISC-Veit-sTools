(*&Use32+*)
(*$I+*)
unit conf512;

(*$I+*)

(* Veit Kannegieser * 1999.01.24 *)
(*                    1999.01.28 L”schen+Umbenennen, /U, Sprache *)
(*                    1999.02.21 SET=RUNWORKPLACE PMSHELL.EXE
                               ->SET RUNWORKPLACE=PMSHELL.EXE *)
(*                    1999.11.20 Sprache 2 *)
(*                    1999.11.28 DSPINSTL: "^DOS:1:REM ^DEVICE=.." -> ^DOS:1:REM=^DEVICE .." berichtigen *)
(*                    2000.03.24 ^SVDISK:TRUE:REM=^^RAMFS:TRUE:SET RAMFS64=K^ *)
(*                     und nicht ^SVDISK:TRUE:REM=^^RAMFS:TRUE:SET=RAMFS64=K^ *)
(*                    ****.**.** os2csm.deu/.eng *)

interface

procedure config_sys_anpassen(const pfad,quelle,ziel:string;const s512,vereinfachen:boolean);

implementation

uses
  Dos,
  menucomp,
  os2csm_s,
  VpSysLow;

const
  kopfanfang            ='REM V.K. * OS2CFG * 0000';
  kommentaranfang       ='REM 512CONF';
  kommentar_breit       ='REM 512CONF************************************************************';
  umbruch               =^m^j;

  SchluesselWoerter1    :array[1.. 2] of string[Length('RESERVEDRIVELETTER')]=
    ('REM',
     'SET');

  SchluesselWoerter2    :array[1..57] of string[Length('RESERVEDRIVELETTER')]=
    ('AUTOFAIL',
     'BASEDEV',
     'BREAK',
     'BUFFERS',
     'CALL',
     'CLOCKSCALE',
     'CODEPAGE',
     'COUNTRY',
     'DEVICE',
     'DEVICEHIGH',
     'DEVINFO',
     'DLLBASING',
     'DISKCACHE',
     'DOS',
     'DUMPPROCESS',
     'EARLYMEMINIT',
     'FCBS',
     'FAKEISS',
     'FILES',
     'I13PAGES',
     'IFS',
     'IOPL',
     'JITDBGFLGS',
     'JITDBGREG',
     'LASTDRIVE',
     'LIBPATH',
     'MAXWAIT',
     'MEMMAN',
     'NORESETBUFFER',
     'NWDTIMER',
     'PAUSEONERROR',
     'PRINTMONBUFSIZE',
     'PRIORITY',
     'PRIORITY_DISK_IO',
     'PROCESSES',
     'PROTECT16',
     'PROTECTONLY',
     'PROTSHELL',
     'PSD',
     'PVWQSIZE',
     'RASKDATA',
     'REIPL',
     'RESERVEDRIVELETTER',
     'RMSIZE',
     'RUN',
     'SHELL',
     'STRACE',
     'SUPPRESSPOPUPS',
     'SWAPPATH',
     'SXFAKEHWFPU',
     'THREADS',
     'TIMESLICE',
     'TRACE',
     'TRACEBUF',
     'TRAPDUMP',
     'VIRTUALADDRESSLIMIT',
     'VME');

var
  d1,d2,d3              :text;
  posd2                 :longint;
  zeilenlaenge_d2       :longint;
  max_zeilenlaenge_d2   :longint;
  zeilenzahl_d2         :longint;

procedure WriteLn_d2(const zk:ansistring);
  begin
    WriteLn(d2,zk);
    Inc(posd2,Length(zk)+2);
    Inc(zeilenlaenge_d2,Length(zk));
    if max_zeilenlaenge_d2<zeilenlaenge_d2 then
      max_zeilenlaenge_d2:=zeilenlaenge_d2;
    Inc(zeilenzahl_d2);
    zeilenlaenge_d2:=0;
  end;

procedure Write_d2(const zk:ansistring);
  begin
    Write(d2,zk);
    Inc(posd2,Length(zk));
    Inc(zeilenlaenge_d2,Length(zk));
  end;

function Vergleiche(const zk1:ansistring;const pos1:longint;const zk2:shortstring):boolean;
  var
    z           :longint;
  begin
    Vergleiche:=false;

    (* kann nicht geleich sein weil zk1 zu kurz ist *)
    if Length(zk1)-(pos1-1)<Length(zk2)+Length('=') then
      Exit;

    (* ungleich *)
    for z:=1 to Length(zk2) do
      if zk1[pos1+(z-1)]<>zk2[z] then
        Exit;

    if not (zk1[pos1+(Length(zk2)-1)+1] in [' ','=',#9]) then
      Exit;

    Vergleiche:=true;
  end;

procedure schreibe_kopf;
  var
    zeile       :string;
    p           :longint;
  begin
    if (posd2 mod 512)=0 then
      begin
        zeile:=kopfanfang;
        p:=posd2 div 512;
        Inc(zeile[length(zeile)-0],p mod 10);
        p:=p div 10;
        Inc(zeile[length(zeile)-1],p mod 10);
        p:=p div 10;
        Inc(zeile[length(zeile)-2],p mod 10);
        p:=p div 10;
        Inc(zeile[length(zeile)-3],p mod 10);

        WriteLn_d2(zeile);
      end;
  end;

function uebrig:longint;
  begin
    uebrig:=512-(posd2 mod 512);
  end;

procedure grossbuchstaben(const zk1:ansistring;var zk2:ansistring);
  var
    zaehler     :longint;
  begin
    zk2:=zk1;
    for zaehler:=1 to Length(zk2) do
      case zk2[zaehler] of
        'a'..'z':
          Dec(zk2[zaehler],Ord('a')-Ord('A'));
      end;
  end;

procedure syntaxfehler(const zeile:string;const stelle:word;const fehlermeldung:string);
  begin
    WriteLn(zeile);
    WriteLn(textz_Syntaxfehler_in_Spalte_^,stelle,': ',fehlermeldung);
    fehler_ende(1);
  end;

function ja_nein:boolean;
  var
    s:char;
  begin
    repeat
      s:=UpCase(SysReadKey);
      case s of
        'J'{Ja},'Y'{Yes},'S'{S¡}:
          begin
            WriteLn(s);
            ja_nein:=true;
            Exit;
          end;
        'N'{Nein,No,No}:
          begin
            WriteLn(s);
            ja_nein:=false;
            Exit;
          end;
      end;
    until false;
  end;

function zaehle_anzahl_auftreten(const zeichen:char;const zk:ansistring):word;
  var
    z:word;
  begin
    Result:=0;
    for z:=1 to Length(zk) do
      if zk[z]=zeichen then
        Inc(Result);
  end;

function wertumwandlung(const zk,vorgabe:string):word;
  var
    zk_gross    :ansistring;
    tmp         :word;
    kontrolle   :integer;
  begin
    if zk='' then
      grossbuchstaben(vorgabe,zk_gross)
    else
      grossbuchstaben(zk,zk_gross);

    if (zk_gross='WAHR') or (zk_gross='TRUE') then
      wertumwandlung:=1
    else  if (zk_gross='FALSCH') or (zk_gross='FALSE') then
      wertumwandlung:=0
    else
      begin
        Val(zk_gross,tmp,kontrolle);
        if kontrolle=0 then
          wertumwandlung:=tmp
        else
          wertumwandlung:=High(word);
      end;
  end;

var
  zeile                 :ansistring;
  zeile_gross           :ansistring;
  zeile_erledigt        :boolean;
  para,pfad             :string;
  zaehler               :longint;
  fund1,fund2           :longint;
  korrigiert            :boolean;

  pos1,pos2             :word;
  variablenwert         :word;
  uebereinstimmung      :boolean;
  ende_der_aufzaehlung  :boolean;

procedure config_sys_anpassen(const pfad,quelle,ziel:string;const s512,vereinfachen:boolean);
  const
    tempname            ='config.$$$';
  var
    variablenname       :string;
    variablenwertzk     :string;
  begin
    WriteLn(textz_plus_Lade_^,pfad,quelle);
    FileMode:=$0000+$0010; (* open_access_ReadOnly+open_share_DenyReadWrite *)
    Assign(d1,pfad+quelle);
    Reset(d1);

    FileMode:=$0001+$0010; (* open_access_WriteOnly+open_share_DenyReadWrite *)
    Assign(d2,pfad+tempname);
    Rewrite(d2);

    posd2:=0;
    zeilenlaenge_d2:=0;
    max_zeilenlaenge_d2:=0;
    zeilenzahl_d2:=0;

    while not Eof(d1) do
      begin

        ReadLn(d1,zeile);

        (* Leerzeichen am Zeilenende l”schen *)
        while (zeile<>'') and (zeile[Length(zeile)] in [' ',#9]) do
          SetLength(zeile,Length(zeile)-1);

        (* Gr”ábuchstaben zur schnellen Findung von Schlsselw”rtern *)
        grossbuchstaben(zeile,zeile_gross);

        (* Fehlermeldung bei zu langen Zeilen *)
        if Length(zeile)>512-( Length(kopfanfang)+Length(umbruch)
                              +Length(umbruch)
                              +Length(kommentaranfang)+Length('+')+Length(umbruch)) then
          begin
            WriteLn(textz_Zeile_zu_lang_^,zeile);
            fehler_ende(2);
          end;

        if odd(zaehle_anzahl_auftreten('^',zeile)) then
          begin
            WriteLn(textz_Ungradzahlige_Anzahl_von_dachzeichen^);
            WriteLn(zeile);
            fehler_ende(2);
          end;


        if vereinfachen then
          begin

            (* '?' vereinfachen **************************************)
            if Pos('?',zeile)=1 then
              begin
                pos1:=Pos('"',zeile);
                if pos1<>2 then
                  syntaxfehler(zeile,2,textz__anf_erwartet_^);
                pos2:=pos1+1;
                repeat
                  if Length(zeile)<pos2 then
                    syntaxfehler(zeile,pos2,textz__anf_erwartet_^);
                  if zeile[pos2]='"' then
                    Break;
                  Write(zeile[pos2]);
                  Inc(pos2);
                until false;

                Write(textz__j_n_^);
                if ja_nein then
                  Delete(zeile,1,pos2)
                else
                  zeile:='';

                grossbuchstaben(zeile,zeile_gross);
              end;


            (* '^' vereinfachen **************************************)
            pos1:=1;
            while pos1<=Length(zeile) do
              begin

                if zeile[pos1]='^' then
                  begin
                    Delete(zeile,pos1,1);

                    pos2:=pos1;
                    while not (zeile[pos2] in [':','=']) do
                      if pos2>=Length(zeile) then
                        syntaxfehler(zeile,pos2,textz__doppelpunkt_erwartet_^)
                      else
                        Inc(pos2);

                    variablenname:=Copy(zeile,pos1,pos2-pos1);
                    Delete(zeile,pos1,pos2-pos1+1);

                    (* ^USER:******^ *)
                    if zeile[pos1]='*' then
                      begin (* Zeichenkette *)
                        variablenwertzk:=liefere_standardwert_zeichenkette(variablenname);

                        (* beendendes '^' suchen *)
                        pos2:=pos1;
                        while zeile[pos2]<>'^' do
                          if pos2>=Length(zeile) then
                            syntaxfehler(zeile,pos2,textz__dach_erwartet_^)
                          else
                            Inc(pos2);
                        (* bis zum und mit '^' l”schen *)
                        Delete(zeile,pos1,pos2-pos1+1);
                        (* Einfgen und weiterrcken *)
                        Insert(variablenwertzk,zeile,pos1);
                        Inc(pos1,Length(variablenwertzk));
                      end
                    else
                      begin (* Zahl/boolean/"Wert" *)


                        uebereinstimmung:=false;
                        repeat
                          pos2:=pos1;

                          (* "Wert",... *)
                          if zeile[pos2] in ['"',''''] then
                            begin
                              repeat
                                Inc(pos2);
                                if pos2>=Length(zeile) then
                                  syntaxfehler(zeile,pos2,textz__schliessende_Anfuehrungszeichen_erwartet_^);
                              until zeile[pos2]=zeile[pos1];
                              variablenwertzk:=Copy(zeile,Succ(pos1),pos2-Succ(pos1));
                              if variablenwertzk=liefere_standardwert_zeichenkette(variablenname) then
                                uebereinstimmung:=true;
                              Inc(pos2); (* " *)

                              while not (zeile[pos2] in [':','=',',']) do
                                if pos2>=Length(zeile) then
                                  syntaxfehler(zeile,pos2,textz__doppelpunkt_oder_komma_erwartet_^)
                                else
                                  Inc(pos2);

                            end
                          else (* Zahl,... *)
                            begin

                              (* Ende der Zahl suchen,,*)
                              while not (zeile[pos2] in [':','=',',']) do
                                if pos2>=Length(zeile) then
                                  syntaxfehler(zeile,pos2,textz__doppelpunkt_oder_komma_erwartet_^)
                                else
                                  Inc(pos2);

                              variablenwertzk:=Copy(zeile,pos1,pos2-pos1);
                              if wertumwandlung(variablenwertzk,'')=liefere_standardwert_zahl(variablenname) then
                                uebereinstimmung:=true;

                            end;


                          ende_der_aufzaehlung:=(zeile[pos2]<>',');
                          Delete(zeile,pos1,pos2-pos1+1);
                        until ende_der_aufzaehlung;

                        repeat
                          if pos1>Length(zeile) then
                            syntaxfehler(zeile,pos1,textz__dach_erwartet_^);

                          if zeile[pos1]='^' then
                            Break;

                          if uebereinstimmung then
                            Inc(pos1)
                          else
                            Delete(zeile,pos1,1);
                        until false;
                        Delete(zeile,pos1,1);
                      end; (* zahl/boolean *)
                  end (* '^' *)
                else
                  Inc(pos1);
              end;

            grossbuchstaben(zeile,zeile_gross);

            (* ECHO-Befehl in Kommentar umwandeln *)
            if vereinfachen and (Pos('ECHO ',zeile_gross)=1) then
              begin
                Insert('REM ',zeile      ,1);
                Insert('REM ',zeile_gross,1);
              end;

          end;



        (* KORREKTUR FšR DSPINSTL,.. *)
        fund1:=Pos('SET=',zeile_gross);
        if fund1<>0 then
          begin
            Inc(fund1,Length('SET'));
            fund2:=fund1;
            while (fund2<Length(zeile_gross)) and (zeile_gross[fund2]<>' ') do
              Inc(fund2);
            if zeile_gross[fund2]=' ' then
              begin
                zeile_gross[fund1]:=' ';
                zeile_gross[fund2]:='=';
                zeile      [fund1]:=' ';
                zeile      [fund2]:='=';
              end;
          end;

        (* ^DOS:1:REM ^DEVICE=D:\OS2\BOOT\DOS.SYS *)
        (* ^DOS:1:REM=^DEVICE D:\OS2\BOOT\DOS.SYS *)
        (* ^DOS:1:REM=^DEVICE=D:\OS2\BOOT\DOS.SYS *)

        (* ^SVDISK:TRUE:REM=^^RAMFS:TRUE:SET=RAMFS64=K^ *)
        (* ^SVDISK:TRUE:REM=^^RAMFS:TRUE:SET RAMFS64=K^ *)

        fund1:=Pos(':REM=^',zeile_gross);
        if fund1<>0 then
          begin
            Inc(fund1,Length(':REM=^'));
            korrigiert:=false;

            while (fund1<Length(zeile_gross)) and (not korrigiert) do
              begin
                for zaehler:=Low(SchluesselWoerter2) to High(SchluesselWoerter2) do
                  if Vergleiche(zeile_gross,fund1,SchluesselWoerter2[zaehler]) then
                    begin
                      Inc(fund1,Length(SchluesselWoerter2[zaehler]));
                      if zeile[fund1]=' ' then
                        zeile[fund1]:='=';
                      korrigiert:=true;
                      Break;
                    end;
                Inc(fund1);
              end;

          end;


        zeile_erledigt:=false;

        repeat
          if s512 then
            schreibe_kopf;

          if (Pos(Copy(kopfanfang,1,Length(kopfanfang)-4),zeile)=1)
          or (Pos(kommentaranfang                        ,zeile)=1)
          (*      kommentar_breit ist eine Sonderform von kommentaranfang *)
           then
            begin
              zeile_erledigt:=true;
              Continue;
            end;

          if (s512) and (uebrig<Length(zeile)+Length(umbruch)+Length(kommentaranfang)+Length('+')+Length(umbruch)) then
            begin

              (* erstmal lange Zeilen *)
              while uebrig>=Length(kommentar_breit)+Length(umbruch)+Length(kommentaranfang)+Length('+')+Length(umbruch) do
                WriteLn_d2(kommentar_breit);

              (* dann den brigen Platz verbrauchen *)
              Write_d2(kommentaranfang);

              while uebrig>Length('+')+Length(umbruch) do
                Write_d2('*');

              WriteLn_d2('+');
              Continue;
            end;

          WriteLn_d2(zeile);
          zeile_erledigt:=true;

        until zeile_erledigt;

      end; (* WHILE NOT EOF *)


    (* CONFIG.SYS auf 512 Byte auffllen *)
    if s512 then
      begin

        (* erstmal lange Zeilen *)
        while uebrig>=Length(kommentar_breit)+Length(umbruch)+Length(kommentaranfang)+Length('-')+Length(umbruch) do
          WriteLn_d2(kommentar_breit);

        (* dann den brigen Platz verbrauchen *)
        Write_d2(kommentaranfang);

        while uebrig>Length('-')+Length(umbruch) do
          Write_d2('*');

        WriteLn_d2('-');
      end;

    Close(d1);
    Close(d2);

    Write(textz_gleich_Schreibe_^,pfad,ziel,' -> ');

    Assign(d3,pfad+ziel);
    (*$I-*)
    Erase(d3);
    (*$I+*)
    if IOResult<>0 then;

    Assign(d2,pfad+tempname);
    Rename(d2,pfad+ziel);

    if s512 then
      Writeln(((posd2+511) div 512),textz_sektoren^)
    else
      WriteLn((*posd2,' Byte, '*)' ',zeilenzahl_d2,textz_zeilen^,max_zeilenlaenge_d2,textz_maximale_zeilenlaenge^);

  end;

end.

