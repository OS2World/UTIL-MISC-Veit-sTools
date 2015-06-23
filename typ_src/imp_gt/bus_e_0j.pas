{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y-}
(*$IFNDEF VIRTUALPASCAL*)
{$M 16384,0,655360}
(*$ENDIF*)
(* $I TYP_COMP.PAS*)
program bus_exe0;

uses
  crt,
  bus_exe2,
  typ_type,
  buschbau;

function bytesuche_codepuffer_0(const sig:string):boolean;
  var
    egal:byte;
  begin
    bytesuche_codepuffer_0:=bytesuche(egal,sig);
  end;


var
  z:byte;
begin
  for z:=$00 to $ff do
    begin
      write(^m,z:3);
      exe_verteiler[z];
    end;
  writeln;

  abspeichern('gt_e_0j.dat');
end.

