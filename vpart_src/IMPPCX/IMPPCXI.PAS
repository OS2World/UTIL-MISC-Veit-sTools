type       (*  Y0...Y1        X0...X3           RGBH          Zeilen   *)
  symb_typ=array[0..1] of array[0..3] of array[0..3] of array[0..15] of byte;
  (* 32*32*16:

       XXXX
       0123
    Y0 ≤≤≤≤
    Y1 ≤≤≤≤


    Reihenfolge:
       0123
       4567


   0=Block Blau,Block GrÅn,Block Rot,Block Wei·


   Block Blau=≤

   ≤=-------Zeile  0
     \   ...........
       \ ---Zeile 15
                     *)

const
  vga_palette:array[0..15+3] of array[1..4] of byte=
  ((  0,  0,  0, 0),
   (  0,  0,170, 1),
   (  0,170,  0, 2),
   (  0,170,170, 3),
   (170,  0,  0, 4),
   (170,  0,170, 5),
   (170, 85,  0, 6),
   (170,170,170, 7),
   ( 85, 85, 85, 8),
   ( 85, 85,255, 9),
   ( 85,255, 85,10),
   ( 85,255,255,11),
   (255, 85, 85,12),
   (255, 85,255,13),
   (255,255, 85,14),
   (255,255,255,15),

   (255,  0,  0,12), (* reines Rot *)
   (  0,255,  0,10), (* reines GrÅn *)
   (  0,  0,255, 9)  (* reines Blau *)
   );


function importiere_pcx_32_32_16_zu_512(dateiname:string;var vp512:symb_typ):boolean;

  type
    (*$IFNDEF VirtualPascal*)
    smallword           =word;
    (*$ENDIF*)
    word_z              =^smallword;
    longint_z           =^longint;

  const
    x_max               =32 div 8;
    y_max               =32;
    e_max               =4;

  var
    d                   :file;
    x,y,e,b             :word;
    zaehler             :word;
    kopf                :array[0..127] of byte;
    bb                  :byte;
    modus               :(modus_normal,modus_mehrfach);

    zwischenbild        :array[1..32,1..32] of byte;
    palette_permutation :array[0..15] of byte;

    puffer              :array[0..32*32+500] of byte;
    leseindex           :word;
    groesse             :longint;


procedure palette_berechnung;
  var
    f,i                 :word;
    diff_min,diff_neu   :longint;
    index_min           :word;
  begin
    FillChar(palette_permutation,SizeOf(palette_permutation),0);

    for f:=0 to 15 do
      begin
        diff_min:=999999;
        index_min:=0;
        for i:=Low(vga_palette) to High(vga_palette) do
          begin
            diff_neu:=Sqr((kopf[$10+f*3+0]{ and $fc})-(vga_palette[i,1]{ and $fc}))
                     +Sqr((kopf[$10+f*3+1]{ and $fc})-(vga_palette[i,2]{ and $fc}))
                     +Sqr((kopf[$10+f*3+2]{ and $fc})-(vga_palette[i,3]{ and $fc}));
            if diff_neu<diff_min then
              begin
                diff_min:=diff_neu;
                index_min:=i;
              end;

          end;

        (*$IFDEF ANZEIGEN*)
        if diff_min<>0 then
          begin
            WriteLn('R=',kopf[$10+f*3+0]:3,' G=',kopf[$10+f*3+1]:3,' B=',kopf[$10+f*3+2]:3,' ?=',diff_min:7);
            SysReadKey;
           end;
        (*$ENDIF*)

        palette_permutation[f]:=vga_palette[index_min,4];
      end;
  end; (* paletteberechnung *)


procedure anzeige_und_umrechnung;
  var
    y,x                 :word;
  begin
    for y:=1 to 32 do
      begin
        (*$IFDEF ANZEIGEN*)
        GotoXY(1,y);
        (*$ENDIF*)
        for x:=1 to 32 do
          begin
            (*$IFDEF ANZEIGEN*)
            TextAttr:=palette_permutation[zwischenbild[y][x]];
            Write(Int2Hex(zwischenbild[y][x],1));
            (*$ENDIF*)
            zwischenbild[y][x]:=palette_permutation[zwischenbild[y][x]];
          end;
      end;
  end;


procedure berechnung_512;
  var
    x,y,f,z,b           :word;
  begin
    FillChar(vp512,SizeOf(vp512),0);

    for x:=0 to 3 do
      for y:=0 to 1 do
        for f:=0 to 3 do
          for z:=0 to 15 do
            for b:=0 to 7 do
              Inc(vp512[y][x][f][z],((zwischenbild[1+y*16+z][1+x*8+b] shr f) and 1) shl (7-b));
  end;


procedure blockread2(var z;const anzahl:word);
  begin
    Move(puffer[leseindex],z,anzahl);
    Inc(leseindex,anzahl);
  end;



begin
  importiere_pcx_32_32_16_zu_512:=false;

  FillChar(zwischenbild,SizeOf(zwischenbild),0);

  if dateiname='' then Exit;

  FileMode:=$40;
  Assign(d,dateiname);
  (*$I-*)
  Reset(d,1);
  (*$I+*)
  if IOResult<>0 then Exit;

  groesse:=FileSize(d);
  if groesse>SizeOf(puffer) then Exit;

  BlockRead(d,puffer,groesse);
  leseindex:=0;
  Close(d);

  BlockRead2(kopf,SizeOf(kopf));

  if  (kopf[ 0]= 10)                                    (* ZSoft *)
  and (kopf[ 2]=  1)                                    (* RLE   *)
  and (kopf[ 3]=  1)                                    (* 1 Bit *)
  and (word_z(@kopf[ 8])^-word_z(@kopf[ 4])^+1=32)      (* Spalten *)
  and (word_z(@kopf[10])^-word_z(@kopf[ 6])^+1=32)      (* Zeilen *)
  and (kopf[65]=  4)                                    (* 4 Ebenen 2^4=16 *)
  and (kopf[66]= 32 div 8)                              (* MEM Scanline *)
   then
    begin

      x:=1;
      y:=1;
      e:=1;
      modus:=modus_normal;

      repeat
        (* write(^m,x*8:4,y:4,e:4); *)
        case modus of
          modus_normal:
            begin
              BlockRead2(bb,SizeOf(bb));
              if (bb and $c0)=$c0 then
                begin
                  modus:=modus_mehrfach;
                  zaehler:=bb-$c0;
                  BlockRead2(bb,SizeOf(bb));
                end
              else
                begin
                  modus:=modus_mehrfach;
                  zaehler:=1;
                end;
            end;

          modus_mehrfach:
            begin
              for b:=0 to 7 do
                if (bb and (1 shl b))<>0 then
                  Inc(zwischenbild[y,1+(x-1)*8+7-b],1 shl (e-1));
              Inc(x);
              Dec(zaehler);
              if zaehler=0 then
                modus:=modus_normal;
            end;
        end;

        if x>x_max then
          begin
            Inc(e);
            x:=1;
          end;

        if e>e_max then
          begin
            Inc(y);
            e:=1;
          end;

      until y>y_max;

      palette_berechnung;
      anzeige_und_umrechnung;
      berechnung_512;
      importiere_pcx_32_32_16_zu_512:=(groesse=leseindex);

    end;

  (* PMVIEW 2.000 *)
  if  (kopf[ 0]= 10)                                    (* ZSoft *)
  and (kopf[ 2]=  1)                                    (* RLE   *)
  and (kopf[ 3]=  4)                                    (* 4 Bit *)
  and (word_z(@kopf[ 8])^-word_z(@kopf[ 4])^+1=32)      (* Spalten *)
  and (word_z(@kopf[10])^-word_z(@kopf[ 6])^+1=32)      (* Zeilen *)
  and (kopf[65]=  1)                                    (* 1 Ebenen *)
  and (kopf[66]= 32 div 2)                              (* MEM Scanline *)
   then
    begin

      x:=1;
      y:=1;
      modus:=modus_normal;

      repeat
        case modus of
          modus_normal:
            begin
              Blockread2(bb,SizeOf(bb));
              if (bb and $c0)=$c0 then
                begin
                  modus:=modus_mehrfach;
                  zaehler:=bb-$c0;
                  BlockRead2(bb,SizeOf(bb));
                end
              else
                begin
                  modus:=modus_mehrfach;
                  zaehler:=1;
                end;
            end;

          modus_mehrfach:
            begin
              zwischenbild[y][x+0]:=bb shr   4;
              zwischenbild[y][x+1]:=bb and $0f;
              Inc(x,2);
              Dec(zaehler);
              if zaehler=0 then
                modus:=modus_normal;
            end;
        end;

        if x>32 then
          begin
            Inc(y);
            x:=1;
          end;

      until y>32;

      palette_berechnung;
      anzeige_und_umrechnung;
      berechnung_512;
      importiere_pcx_32_32_16_zu_512:=(groesse=leseindex);

    end;

end;

