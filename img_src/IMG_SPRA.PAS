unit img_spra;

interface

type
  str_z=^string;

(*$I img$$$.002 *)

implementation

uses spra_aus;

(*$I img$$$.001 *)

begin
  setze_sprachzeiger(@sprach_modul,@sprach_start);
end.
