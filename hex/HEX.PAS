unit hex;
(* Veit Kannegieser * 50.11.1997 *)

interface

function hexstr(l:longint;ziffern:byte):string;

implementation

const
  hexziffern:array[0..15] of char='0123456789abcdef';

function hexstr(l:longint;ziffern:byte):string;
  begin
    case ziffern of
      1:hexstr:=hexziffern[ l            and $f];

      2:hexstr:=hexziffern[(l shr (1*4)) and $f]
               +hexziffern[(l shr (0*4)) and $f];

      4:hexstr:=hexziffern[(l shr (3*4)) and $f]
               +hexziffern[(l shr (2*4)) and $f]
               +hexziffern[(l shr (1*4)) and $f]
               +hexziffern[(l shr (0*4)) and $f];

      8:hexstr:=hexziffern[(l shr (7*4)) and $f]
               +hexziffern[(l shr (6*4)) and $f]
               +hexziffern[(l shr (5*4)) and $f]
               +hexziffern[(l shr (4*4)) and $f]
               +hexziffern[(l shr (3*4)) and $f]
               +hexziffern[(l shr (2*4)) and $f]
               +hexziffern[(l shr (1*4)) and $f]
               +hexziffern[(l shr (0*4)) and $f];
    else
      runerror(0);
    end;
  end;

end.
