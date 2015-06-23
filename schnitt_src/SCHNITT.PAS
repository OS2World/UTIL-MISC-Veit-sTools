(*$A-,B-,D-,E-,F-,G+,I+,L-,N-,O-,R-,S-,V-,X-*)
(*$IFDEF DEBUG*)
(*$D+,L+*)
(*$ENDIF*)

(*$IFDEF VirtualPascal*)
(*$M 40000*)
(*$Use32+*)
(*$ELSE*)
(*$M 16384,0,0*)
(*$ENDIF*)

program schnitt;

uses
  Crt,
  Dos,
  Schnitts,
  LuxDatei,
  VpUtils;

(*29.12.1993..*)

(* 04.12.1994 FILEMODE.. *)
(* 31.03.1995 ???? *)
(* 19.10.1996 Test Startposition, Taste bei Fehler *)
(* 23.10...24.10.1996 OS/2 und englisch *)
(* 06.11.1996 Zeiger auf n„chsten Vorgang (Lesen/Schreiben) beim Ende l”schen *)
(* 18.01.1998 Luxusdatei *)
(* 20.01.1998 oeffne->erzeuge *)
(* 11.03.1998 crt,spra_aus neu *)
(* 07.04.1998 Szymon Grabowski: "start position" 		*)
(* 2000.12.07 Quelltextversch”nerung, Sprache2,  		*)
(*            negative Startposition/L„nge wird umgerechnet   	*)
(*            optische Umgestaltung                             *)

const
  datum                 ='1993.12.29..2000.12.08';
  puffergroesse_min     =  512;
  (*$IFDEF VirtualPascal*)
  puffergroesse_max     =1024*1024*10;
  (*$ELSE*)
  puffergroesse_max     =$ff00;
  (*$ENDIF*)

var
  d1,d2                 :luxus_datei;
  startpos,laenge       :longint;
  lese_zaehler,
  schreib_zaehler       :longint;
  blockgroesse          :longint;
  kontrolle             :integer;

  reaktion_auf_fehler   :(fragen,immer_ignorieren,immer_wiederholen);
  taste                 :char;

  puffergroesse         :word;
  puffer                :pointer;

procedure status(const naechstes:char);
  begin
    (*
    Write(^m,'   ',startpos:10,' º ',lese_zaehler:10,' ³ ',laenge:10,' º ',schreib_zaehler:10,' ³ ',laenge:10);
    if naechstes='L' then
      Write(^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h'>');
    if naechstes='S' then
      Write(^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h'>');*)

    GotoXY(9,WhereY);

    NormVideo;
    if naechstes='L' then
      TextAttr:=$1e;

    Write('$',Int2Hex(startpos+lese_zaehler,8),' $',Int2Hex(lese_zaehler,8));

    NormVideo;
    Write(' ');

    if naechstes='S' then
      TextAttr:=$1c;

    Write('$',Int2Hex(schreib_zaehler,8));

    NormVideo;
    Write(' ');

  end;

procedure abbruch(const te:string);
  var
    taste:char;
  begin
    WriteLn(#7+te);
    taste:=ReadKey;
    Halt(1);
  end;


(****************** HP ************************)

begin
  reaktion_auf_fehler:=fragen;

  case ParamCount of
     3:if FExpand(ParamStr(1))=FExpand(ParamStr(3)) then abbruch(textz_gleiche_Dateinamen^);
     4:if FExpand(ParamStr(1))=FExpand(ParamStr(4)) then abbruch(textz_gleiche_Dateinamen^);
  else
    WriteLn('Schnitt * Veit Kannegieser * ',datum);
    WriteLn(textz_Benutzung_SCHNITT_Quelldatei^);
    Halt(0);
  end;

  ld_oeffne(d1,ParamStr(1),false); (* nur zum Lesen *)

  Val(ParamStr(2),startpos,kontrolle);
  if kontrolle>0 then
    abbruch(textz_Der_Parameter^+ParamStr(2)+textz_ist_unsinnig^);

  if startpos<0 then
    Inc(startpos,ld_laenge(d1));

  if startpos>ld_laenge(d1) then
    abbruch(textz_Die_Startpostion_in_der_Quelldatei_liegt_ausserhalb_der_Dateigrenzen^);

  if ParamCount=4 then
    begin
      Val(ParamStr(3),laenge,kontrolle);
      if kontrolle>0 then
        abbruch(textz_Der_Parameter^+ParamStr(3)+textz_ist_unsinnig^);
      if laenge<0 then
        laenge:=ld_laenge(d1)+laenge-startpos;
      if ld_laenge(d1)<startpos+laenge then
        abbruch(textz_Der_Parameter_Laenge_ist_groesser_als_der_Rest_der_Quelldatei^);
    end
  else
    laenge:=ld_laenge(d1)-startpos;

  ld_sprung(d1,startpos);

  ld_erzeuge(d2,ParamStr(ParamCount));

  lese_zaehler   :=0;
  schreib_zaehler:=0;
  (*WriteLn('Startposition º      ',textz_Lesen^,' ³        ',textz_von^,' º  ',textz_Schreiben^,' ³        ',textz_von^);*)
  WriteLn(textz_tabelle_z1^);
  WriteLn(textz_tabelle_z2^);
  WriteLn(textz_tabelle_z3^,'$',Int2Hex(startpos,8),' $',Int2Hex(0,8),' $',Int2Hex(0,8));
  WriteLn(textz_tabelle_z4^);
  WriteLn(textz_tabelle_z5^,'$',Int2Hex(startpos+laenge,8),' $',Int2Hex(laenge,8),' $',Int2Hex(laenge,8));

  if (WhereY>=6) then
    GotoXY(1,WhereY-6+4);

  status('L');

  puffergroesse:=MemAvail shr 2;

  if puffergroesse>puffergroesse_max then
    puffergroesse:=puffergroesse_max;

  if puffergroesse<puffergroesse_min then
    puffergroesse:=puffergroesse_min;

  GetMem(puffer,puffergroesse);

  repeat
    if lese_zaehler+puffergroesse<laenge then
      blockgroesse:=puffergroesse
    else
      blockgroesse:=laenge-lese_zaehler;

    ld_lies(d1,puffer^,blockgroesse);
    inc(lese_zaehler,blockgroesse);
    status('S');

    ld_schreibe(d2,puffer^,blockgroesse);
    inc(schreib_zaehler,blockgroesse);
    status('L');

  until schreib_zaehler=laenge;

  status('E');
  ld_schliesse(d1);
  ld_schliesse(d2);

  WriteLn;
  WriteLn;

  (*FreeMem(puffer,puffergroesse)*)
end.

