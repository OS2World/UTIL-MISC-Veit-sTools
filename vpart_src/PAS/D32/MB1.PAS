(*&Use32+*)
unit mb1; (* Lesen des Speichers 0..1 MB *)

interface

procedure bios_speicher_lesen(var ziel);
function word_speicher_lesen(const segm,offs:word):smallword;

implementation

(***************************************************************************)

procedure bios_speicher_lesen(var ziel);
  begin
    Move(Mem[$f0000],ziel,$f000);
  end;

(***************************************************************************)

function word_speicher_lesen(const segm,offs:word):smallword;
  begin
    word_speicher_lesen:=MemW[segm shl 4+offs];
  end;

(***************************************************************************)

end.

