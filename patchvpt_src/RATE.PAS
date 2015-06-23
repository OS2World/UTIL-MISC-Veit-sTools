(*$A+,B-,D-,E-,F-,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X-*)
(*$M 16384,0,0*)

(*&AlignCode+,AlignData+,AlignRec-,Delphi-,G3+,LocInfo-*)
(*&Optimise+,SmartLink+,Speed+*)
(*&M 16384*)

program miss_bildwiederholrate;
(*$D Messung der Bildwiederholrate *)

(* V.K. 18.10.1996 *)
(*      15.08.1997 OS/2-Version *)
(*      21.11.1997 MDA-Emulation unter DOS -> Port $3B4 *)
(*      31.12.1997 Sprache *)
(*      11.03.1998 spra_aus neu *)

uses
  (*$IFDEF OS2*)
  os2base,os2def,
  (*$ENDIF*)
  rate_spr;

const
  (*$IFDEF OS2*)
  messgroesse=1000;    (* Millisekunden *)
  (*$ELSE*)
  messgroesse=18.2;    (* 1/18 Sekunden *)
  (*$ENDIF*)

  dauer=4*messgroesse; (* 4 Sekunden    *)

  crtc_port:word=$03d4;

var
  zaehler:longint;
  zeit0,zeit1:longint;
  rate:real;

  (*$IFNDEF OS2*)
  bios_zaehler:longint absolute $0040:$6c;
  (*$ENDIF*)

(*$IFDEF OS2*)
function bios_zaehler:longint;
  var
    tmp:longint;
    fehler:apiret;
  begin
    fehler:=DosQuerySysinfo(QSV_MS_COUNT,QSV_MS_COUNT,tmp,sizeof(tmp));
    bios_zaehler:=tmp;
  end;
(*$ENDIF*)


begin
  (*$IFNDEF OS2*)
  crtc_port:=memw[$0040:$0063]; (* $3B4/$3D4 *)
  (*$ENDIF*)
  write(textz_Messen_der_Bildwiederholrate_bitte_warten_^);
  zaehler:=0;
  zeit0:=bios_zaehler;
  while zeit0=bios_zaehler do;
  zeit0:=bios_zaehler;

  repeat
    if (port[crtc_port+$3da-$3d4] and $08)=0 then
      begin
        inc(zaehler);
        while (port[crtc_port+$3da-$3d4] and $08)=0 do;
      end;
  until bios_zaehler>=zeit0+dauer;
  zeit1:=bios_zaehler;

  rate:=zaehler*messgroesse/dauer;
  writeln(' ',rate:4:1,' Hz');
  if rate>200 then
    writeln(textz_Entweder_sehr_guter_Wert_oder_Fehler_durch_Betriebssystem_oder_Geraete_^);

  if rate<53 then
    writeln(textz_Sehr_schlechter_Wert_oder_Fehler_^);

end.

