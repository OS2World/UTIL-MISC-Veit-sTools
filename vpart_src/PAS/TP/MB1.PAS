unit mb1; (* Lesen des Speichers 0..1 MB *)

interface

procedure bios_speicher_lesen(var ziel);
function word_speicher_lesen(const segm,offs:word):word;

implementation

(***************************************************************************)

procedure bios_speicher_lesen(var ziel);
  begin
    Move(Mem[$f000:$0000],ziel,$f000);
  end;

(***************************************************************************)

function word_speicher_lesen(const segm,offs:word):word;
  begin
    word_speicher_lesen:=MemW[segm:offs];
  end;

(***************************************************************************)

end.

