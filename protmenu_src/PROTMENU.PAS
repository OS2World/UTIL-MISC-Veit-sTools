(*$AlignCode+,AlignData+,AlignRec-,Asm-,B-,D-,Delphi-,Frame+,G3+,I-,LocInfo+*)
(*$Optimise+,OrgName-,P-,Q-,R-,S-,SmartLink+,Speed+,T-,V+,W-,X+,Z-,ZD-*)
(*$M 16384*)

(*$D ProtMenu * Veit Kannegieser *)
program protmenu;
(* V.K. 18.01.1996 *)
(*      26.04.1997 flexible Verzeichnisse *)
(*      04.10.1997 MenÅtext ladbar *)
(*      31.12.1997 mehr Fehlerbehandlung, Sprache *)
(*      11.03.1998 spra_aus neu *)

uses crt,dos,prot_spr;

var
  taste         :char;
  egal          :char;
  comspec       :string;
  protmenu_pfad :string;
  name_str      :namestr;
  ext_str       :extstr;

  zeilennummer  :char;
  menue_datei   :text;
  menu_anzahl   :word;
  zaehler       :word;

  menue_zeilen:array[1..9] of string[40];
  erweitert     :boolean;
  fehler        :word;

procedure exec2(prg,para:string);
  begin
    exec(prg,para);
    fehler:=doserror;
    if fehler<>0 then
      begin
        write('SYS',fehler,textz_beim_Ausfuehren_von_^,prg,'","'+para+'"');
        writeln;
        egal:=readkey;
        exit;
      end;

    fehler:=dosexitcode;
    if fehler<>0 then
      begin
        writeln('[',fehler,']');
        (* CMD exit: 255 *)
        if (fehler<>$ff) then delay(1000);
      end;
  end;

procedure verzweigung(n:char);
  var
    datei_test:text;
  begin
    assign(datei_test,protmenu_pfad+n+'.CMD');
    (*$I-*)
    reset(datei_test);
    (*$I+*)

    fehler:=ioresult;
    if fehler<>0 then
      begin
        writeln('SYS',fehler,': ',n,textz_CMD_nicht_im_Verzeichnis_^+protmenu_pfad+textz_gefunden_^);
        egal:=readkey;
        exit;
      end;

    close(datei_test);

    exec2(comspec,'/C'+protmenu_pfad+n+'.CMD');
  end;

begin
  writeln('PROTMENU * Veit Kannegieser');

  comspec:=getenv('COMSPEC');
  if comspec='' then
    begin
      writeln(textz_SET_COMSPEC_fehlt_in_der_CONFIG_SYS^);
      egal:=readkey;
      halt(2);
    end;

  fsplit(paramstr(0),protmenu_pfad,name_str,ext_str);

  repeat
    menu_anzahl:=0;

    assign(menue_datei,protmenu_pfad+'PROTMENU.LST');
    (*$I-*)
    reset(menue_datei);
    (*$I+*)
    if ioresult=0 then
      begin

        for zaehler:=1 to 9 do
          begin
            if eof(menue_datei) then break;

            readln(menue_datei,menue_zeilen[menu_anzahl+1]);

            if length(menue_zeilen[zaehler])>0 then
              inc(menu_anzahl);
          end;

        close(menue_datei);
      end
    else
      begin
        writeln(protmenu_pfad+'PROTMENU.LST'+textz_fehlt^);
        egal:=readkey;
      end;

    textattr:=$07;
    clrscr;
    textattr:=$1e;
    window(15,13-(menu_anzahl+2),65,13+(menu_anzahl+2));
    clrscr;
    window( 1, 1,80,25);


    for zaehler:=1 to menu_anzahl do
      begin
        gotoxy(20,13-(menu_anzahl+1)+2*zaehler-1);
        write(menue_zeilen[zaehler]);
      end;

    textattr:=$0c;
    gotoxy(20,13-(menu_anzahl+1)+2*(menu_anzahl+1)-1);
    write('_ '^h^h);

    textattr:=$07;
    taste:=readkey;
    erweitert:=(taste=#$00);
    if erweitert then
      taste:=readkey;

    if erweitert and (taste in [#$3b..#$45]) then
      write('F',(ord(taste)-$3b+1) mod 10)
    else
      write(taste);

    gotoxy( 1,24);

    if erweitert then
      case taste of
        #$44:halt(0);
        #$3b..#$43:verzweigung(chr(ord(taste)-ord(#$3b)+ord('1')));
      else
        write('???');
        delay(1000);
      end
    else
      case taste of
        #27:exec2(comspec,'/K SET PROMPT=[PROTMENU] $P$G');
        '0':halt(0);
        '1'..'9':verzweigung(taste);
      else
        write('???');
        delay(1000);
      end;

  until false;
end.

