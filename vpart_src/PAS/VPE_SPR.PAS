(* 11.10.1996*)
unit vpe_spr;

interface

(*$I vpart$$$.002 *)

implementation

uses spr2_aus;

(*$I vpart$$$.001 *)

begin
  (*setze_sprachzeiger_aus_datei('VPARTEIN.SPR',@sprach_start);*)
  setze_sprachzeiger(@sprach_modul,@sprach_start);
end.

