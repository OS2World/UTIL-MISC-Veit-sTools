(*$X+*)
(*&Use32+*)
unit popup;

(* 199?.??.?? *)
(* 1999.01.30 VP 2.0 Version auch DPMI32 *)
(* 2000.12.07 Quelltextversch”nerung, gepackte record-Typen *)

interface

const
  popup_zeilen          = 8;
  popup_spalten         =30;

const
  popup_attr            :byte=$4A;

type
  bildschirmzeichen=
    packed record
      c                 :char;
      a                 :byte;
    end;

  popup_sicherung_typ=
    record
      fehler            :longint;
      TextAttr_org      :byte;
      WindMin_org       :word;
      windmax_org       :word;
      x                 :byte;
      y                 :byte;
      speicher          :packed array[1..popup_zeilen] of
                         packed array[1..popup_spalten] of bildschirmzeichen;
    end;

procedure popup_ein(var st:popup_sicherung_typ);
procedure popup_aus(var st:popup_sicherung_typ);

implementation

uses
  (*$IFDEF VIRTUALPASCAL*)
  VpSysLow,
  (*$ENDIF*)
  Crt;

(*$IFNDEF VIRTUALPASCAL*)
var
  text_modus            :byte absolute $0040:$0049;
  zeichen_je_zeile      :word absolute $0040:$004a;
(*$ENDIF*)

procedure popup_ein(var st:popup_sicherung_typ);
  var
    maxzeilen           :word;
    maxspalten          :word;
    (*$IFNDEF VIRTUALPASCAL*)
    laenge              :word;
    (*$ENDIF*)
    spalte              :word;
    zeile               :word;

  begin
    maxzeilen:=Hi(WindMax)+1;
    maxspalten:=Lo(WindMax)+1;

    with st do
      begin
        x:=WhereX;
        y:=WhereY;
        TextAttr_org:=TextAttr;
        WindMin_org:=WindMin;
        WindMax_org:=WindMax;

        (*$IFNDEF VIRTUALPASCAL*)
        laenge:=2*popup_spalten;
        spalte:=maxspalten-popup_spalten+1;
        (*$ENDIF*)

        for zeile:=1 to popup_zeilen do
        (*$IFDEF VIRTUALPASCAL*)
          for spalte:=1 to popup_spalten do
            begin
              speicher[zeile][spalte].c:=SysReadCharAt      (maxspalten-popup_spalten+spalte-1,zeile-1);
              speicher[zeile][spalte].a:=SysReadAttributesAt(maxspalten-popup_spalten+spalte-1,zeile-1);
            end;
        (*$ELSE*)
          if text_modus in [7] then
            Move(Ptr($b000,2*((zeile-1)*zeichen_je_zeile+(spalte-1)))^,speicher[zeile],laenge)
          else
            Move(Ptr($b800,2*((zeile-1)*zeichen_je_zeile+(spalte-1)))^,speicher[zeile],laenge);
        (*$ENDIF*)
      end;

    Window(maxspalten-popup_spalten+1,1,maxspalten,popup_zeilen);
    TextAttr:=popup_attr;
    ClrScr;
  end;

procedure popup_aus(var st:popup_sicherung_typ);
  var
    maxzeilen           :word;
    maxspalten          :word;
    (*$IFNDEF VIRTUALPASCAL*)
    laenge              :word;
    (*$ENDIF*)
    spalte              :word;
    zeile               :word;

  begin
    maxzeilen:=Hi(WindMax)+1;
    maxspalten:=Lo(WindMax)+1;

    with st do
      begin
        TextAttr:=TextAttr_org;
        WindMin:=WindMin_org;
        WindMax:=WindMax_org;

        (*$IFNDEF VIRTUALPASCAL*)
        laenge:=2*popup_spalten;
        spalte:=maxspalten-popup_spalten+1;
        (*$ENDIF*)

        for zeile:=1 to popup_zeilen do
        (*$IFDEF VIRTUALPASCAL*)
          for spalte:=1 to popup_spalten do
            SysWrtCharStrAtt(addr(speicher[zeile][spalte].c),1,
              maxspalten-popup_spalten+spalte-1,zeile-1,speicher[zeile][spalte].a);
        (*$ELSE*)
          if text_modus in [7] then
            Move(speicher[zeile],Ptr($b000,2*((zeile-1)*zeichen_je_zeile+(spalte-1)))^,laenge)
          else
            Move(speicher[zeile],Ptr($b800,2*((zeile-1)*zeichen_je_zeile+(spalte-1)))^,laenge);
        (*$ENDIF*)
        GotoXY(x,y);
      end;

  end;

end.

