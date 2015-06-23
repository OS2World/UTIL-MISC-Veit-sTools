unit phoe_spr;

interface

(*$I PHOEDEC$.002 *)

implementation

uses spr2_aus;

(*$I PHOEDEC$.001 *)

begin
  setze_sprachzeiger(@sprach_modul,@sprach_start);
end.

