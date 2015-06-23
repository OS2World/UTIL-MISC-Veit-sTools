{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q+,R+,S+,T+,V+,X+,Y+}
{$M 16384,0,200000}
program icon_gal;

uses
  vpe_obj,
  Dos,
  Graph;

var
  grDriver: Integer;
  grMode: Integer;
  ErrCode: Integer;
  i                     :word;

  kx,ky,x0,y0,zx,zy,x,y :word;
  farbe                 :byte;
  bgi                   :string;

begin
  grDriver := VGA;
  grMode   := VGAHi;

  bgi:=GetEnv('BGI');
  if bgi='' then
    bgi:='C:\BP\BGI';
  InitGraph(grDriver, grMode,bgi);
  WriteLn(graphresult);

  SetColor(15);
  Bar(0,0,GetMaxX,GetMaxY);

  with icons^ do

    for i:=1 to anzahl do
      with ico_tab[i] do
        begin
          kx:=((i-1) mod 8)*80;
          ky:=((i-1) div 8)*80;
          SetColor(0);
          x:=(80-TextWidth(titel)) div 2;
          OutTextXY(kx+x,ky+56,titel);
          for zy:=0 to 1 do
            for zx:=0 to 3 do
              begin
                x0:=kx+zx* 8+(80-32) div 2;
                y0:=ky+zy*16+16;
                for y:=0 to 15 do
                  for x:=0 to 7 do
                    begin
                      farbe:=0;
                      if (daten[1+(zy*4+zx)*16*4+y+0*16] and (1 shl (7-x)))<>0 then Inc(farbe,1);
                      if (daten[1+(zy*4+zx)*16*4+y+1*16] and (1 shl (7-x)))<>0 then Inc(farbe,2);
                      if (daten[1+(zy*4+zx)*16*4+y+2*16] and (1 shl (7-x)))<>0 then Inc(farbe,4);
                      if (daten[1+(zy*4+zx)*16*4+y+3*16] and (1 shl (7-x)))<>0 then Inc(farbe,8);
                      PutPixel(x0+x,y0+y,farbe);
                    end;

              end;
        end;

  ReadLn;
  CloseGraph;

end.