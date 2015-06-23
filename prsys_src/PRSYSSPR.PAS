unit prsysspr;

interface

(*$I PRSYS$$$.002 *)

implementation

uses spr2_aus;

(*$I PRSYS$$$.001 *)

begin
  setze_sprachzeiger(@sprach_modul,@sprach_start);
end.

