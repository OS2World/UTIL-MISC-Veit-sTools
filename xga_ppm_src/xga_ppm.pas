// Veit Kannegieser 2005.01.20..2005.06.30
{Use32+}
program xga_ppm;

Uses
  Objects,
  VpUtils,
  XGA,
  xga_ppms;

const
  output_maxvalue       =63; (* 63 or 255 *)

type
  pSmallWord            =^SmallWord;

var
  d1                    :file;
  d2                    :text;
  p                     :pByteArray;
  x,y,i,l,zx,zy         :Longint;
  z,z1                  :string;
  r,g,b                 :smallword;
  tab31                 :array[0..31] of byte;
  tab63                 :array[0..63] of byte;

procedure decode_color(const fw:word);
  begin
    (* 34F9=6/31                39/63           25/31
            49.3548387097       157.8571428571  205.6451612903
            48.5714285714       157.8571428571  202.380952381
            49                  157             205

       best would not converting the values, but ppm requires
       all components to be scaled to one maximum value *)
    (* Integer:
    r:=(((fw shr 11) and $1f)*output_maxvalue+15) div 31;
    g:=(((fw shr  5) and $3f)*output_maxvalue+31) div 63;
    b:=(((fw shr  0) and $1f)*output_maxvalue+15) div 31; *)
    (* fpu:
    r:=Round(((fw shr 11) and $1f)*output_maxvalue/31);
    g:=Round(((fw shr  5) and $3f)*output_maxvalue/63);
    b:=Round(((fw shr  0) and $1f)*output_maxvalue/31); *)
    (* Tabelle *)
    r:=tab31[(fw shr 11) and $1f];
    g:=tab63[(fw shr  5) and $3f];
    b:=tab31[(fw shr  0) and $1f];
  end;

begin

  if (ParamCount<>2) or (ParamStr(1)='/?') or (ParamStr(1)='-?') then
    begin
      WriteLn(textz_benutzung1^);
      WriteLn(textz_benutzung2^);
      Halt(1);
    end;

  Assign(d1,ParamStr(1));
  FileMode:=$40;
  Reset(d1,1);
  l:=FileSize(d1);
  GetMem(p,l);
  BlockRead(d1,p^,l);
  Close(d1);

  for i:=Low(tab31) to High(tab31) do tab31[i]:=Round(i*output_maxvalue/31);
  for i:=Low(tab63) to High(tab63) do tab63[i]:=Round(i*output_maxvalue/63);

  with t_xga_header(p^[0]) do
    begin

      if signature<>xga_signature then
        begin
          WriteLn(textz_SAVE2DSK_XGA_Signature_not_present_^);
          Halt(1);
        end;

      x:=bild_x;
      y:=bild_y;

      Assign(d2,ParamStr(2));
      Rewrite(d2);
      WriteLn(d2,'P3');
      WriteLn(d2,x,' ',y);
      WriteLn(d2,output_maxvalue);
      z:='';
      for zy:=0 to y-1 do
        for zx:=0 to x-1 do
          begin
            i:=(y-1-zy)*x+zx;
            decode_color(pSmallWord(@p^[kopflaenge+i*2])^);
            z1:= ' '+Int2Str(r)
                +' '+Int2Str(g)
                +' '+Int2Str(b);
            if Length(z)+Length(z1)>70 then
              begin
                Delete(z,1,Length(' '));
                WriteLn(d2,z);
                z:='';
              end;
            z:=z+z1;
          end;

      if z<>'' then
        begin
          Delete(z,1,Length(' '));
          WriteLn(d2,z);
          z:='';
        end;

      WriteLn(d2,'# SAVE2DSK.XGA extra informations:');
      WriteLn(d2,'#*BAR_POS_X ' ,balken_start_x);
      WriteLn(d2,'#*BAR_POS_Y ' ,balken_start_y);
      WriteLn(d2,'#*BAR_SIZE_X ',balken_groesse_x);
      WriteLn(d2,'#*BAR_SIZE_Y ',balken_groesse_y);
      decode_color(balkenfarbe);
      WriteLn(d2,'#*BAR_COLOR ',r,' ',g,' ',b);
    end;

  Close(d2);
  Dispose(p);
end.

