unit setb_spr;

interface

(*$I SETBO$$$.002 *)

implementation

uses spr2_aus;

(*$I SETBO$$$.001 *)

begin
  setze_sprachzeiger(@sprach_modul,@sprach_start);
end.

