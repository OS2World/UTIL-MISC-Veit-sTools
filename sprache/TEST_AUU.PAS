unit test_auu;

interface

type
  str_z=^string;

(*$I test$$$.002 *)

implementation

uses spra_aus;

(*$I test$$$.001 *)

begin
  setze_sprachzeiger(@sprach_modul,@sprach_start);
end.

