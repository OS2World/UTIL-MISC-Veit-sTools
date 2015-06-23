{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+}
(*$IFDEF VirtualPascal*)
{$M 16384}
(*$ELSE*)
{$M 16384,0,0}
(*$ENDIF*)
program imppcx;
(* V.K. 04.04.1998 *)

(*$IFDEF VirtualPascal*)
(*$DEFINE ANZEIGEN*)
(*$ENDIF*)

(*$IFDEF ANZEIGEN*)
uses
  Crt,
  VpUtils,
  VpSysLow;
(*$ENDIF*)

(*$I IMPPCXI.PAS*)

var
  fertig                :symb_typ;
  d                     :file of symb_typ;

begin
  (*$IFDEF ANZEIGEN*)
  WriteLn(^m,ParamStr(1));
  if Hi(WindMax)<35 then
    TextMode(Co80+Font8x8);
  (*$ENDIF*)
  if not importiere_pcx_32_32_16_zu_512(ParamStr(1),fertig) then
    begin
      WriteLn('Fehler bei ',ParamStr(1),' !');
      ReadLn;
    end
  else
    begin
      Assign(d,ParamStr(2));
      Rewrite(d);
      Write(d,fertig);
      Close(d);
    end;

end.

