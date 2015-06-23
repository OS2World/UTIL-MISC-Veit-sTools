{&Use32+}
(* LZINT *)
unit m5;

interface

function entpacke_m5(const quelle,ziel;const laenge_eingepackt,laenge_ausgepackt:longint):boolean;

implementation

uses
  lzh5x;

type
  k4                    =
    packed record
      CompSize          :longint;
      rest              :byte;
    end;

function entpacke_m5(const quelle,ziel;const laenge_eingepackt,laenge_ausgepackt:longint):boolean;
  begin
    entpacke_m5:=entpacke_lzh5(k4(quelle).rest,ziel,laenge_ausgepackt,laenge_eingepackt);
  end;

end.

