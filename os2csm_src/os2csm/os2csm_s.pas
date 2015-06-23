unit os2csm_s;

interface

(*$I OS2CSM1$.002 *)
(*$I OS2CSM2$.002 *)


implementation

uses spr2_aus;

(*$I OS2CSM1$.001 *)
(*$I OS2CSM2$.001 *)


begin
  setze_sprachzeiger(@sprach_modul1,@sprach_start1);
  setze_sprachzeiger(@sprach_modul2,@sprach_start2);
end.

