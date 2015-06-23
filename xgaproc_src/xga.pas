unit xga;

interface

type
  pSmallWord            =^SmallWord;
  p_xga_header          =^t_xga_header;
  t_xga_header          =
    packed record
      signature         :longint;
      kopflaenge        :longint;
      datenlaenge       :longint;
      bild_x            :smallword;
      bild_y            :smallword;
      balken_start_x    :smallword; (* upper left corner=0/0 *)
      balken_start_y    :smallword;
      balken_groesse_x  :smallword;
      balken_groesse_y  :smallword;
      balkenfarbe       :smallword;
      rest              :array[$1a..$1ff] of byte;
    end;

const
  xga_signature         =$9e7128f5;
  leerzeichen           =[' ',^I,^M,^J];

implementation

end.
