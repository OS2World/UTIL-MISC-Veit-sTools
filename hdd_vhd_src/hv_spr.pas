unit hv_spr;

interface

(*$I HDD_VHD$.002 *)

implementation

uses spr2_aus;

(*$I HDD_VHD$.001 *)

begin
  setze_sprachzeiger(@sprach_modul,@sprach_start);
end.

