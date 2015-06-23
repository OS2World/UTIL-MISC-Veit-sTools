(*$G+,R-,S-*)
(*$M 16384,0,0*)

(* 29.04.1998 Veit Kannegieser *)

uses eic,test;

begin
  exec_internal_com(@test_com,' /?');
  exec_internal_com(@test_com,' 123.COM');
{  writeln(eic_result);}
end.
