(*$A+,B-,D+,E-,F-,G+,I+,L+,N-,P-,Q-,R-,S-,T-,V+,X+,Y-*)
(*$M 16384,0,0*)
program zufalls_pw;

(* 22.06.1995 .. 15.02.1996 *)
(* 30.12.1997 OS/2 und ohne CRT *)

uses tast;

(* &Dynamic System*)
(* &L VPRTL.LIB*)

const
  zeichen_vorrat:array[0..47] of char='abcdefghijklmnopqrstuvwxyz0123456789#\-+.:,_*?/&';

var
  z:byte;
  p:char;

begin
  randomize;
  writeln;
  writeln('Zufallspw * V.K. * 22.06.1995 .. 30.12.1997');

  for z:=1 to 8 do
    begin
      repeat
        p:=zeichen_vorrat[random(sizeof(zeichen_vorrat))];
        write(p,#8);
      until frage_ob_taste_vorhanden_erw;
      hole_taste_erw;
      write(p);
    end;
end.
