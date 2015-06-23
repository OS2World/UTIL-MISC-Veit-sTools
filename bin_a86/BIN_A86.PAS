(* V.K. 01.12-21.12.1995 *)
(*      29.12.1997 gr”áere Dateien *)
(*      04.08.1998 Zeilenpuffer    *)


(*$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+*)
(*$D Binaere Dateien -> A86 db * V.K.*)
(*$IFDEF VIRTUALPASCAL*)
(*$M 16384*)
(*$ELSE
(*$M 16384,0,0*)
(*$ENDIF*)


program bin_zu_a86;

type
  word_norm=(*$IFDEF VIRTUALPASCAL*)longint(*$ELSE*)word(*$ENDIF*);

const
  hex:array[0..15] of char='0123456789abcdef';
  umbruch=^m^j;

var
  d1:file;
  d2:text;
  s:word;
  zeichen:char;


var
  lies_d1_cache:array[1..512] of char;
const
  lies_d1_uebrig:word_norm=0;
  lies_d1_position:word_norm=high(lies_d1_cache);

function lies_d1(var z:char):boolean;
  begin

    (* Noch Daten im Cache ? *)
    if lies_d1_uebrig<=0 then
      begin
        (* NEIN -> neu laden *)
        lies_d1_position:=0;
        (*$I-*)
        blockread(d1,lies_d1_cache,sizeof(lies_d1_cache),lies_d1_uebrig);
        (*$I+*)

        (* Fehler oder Dateiende ? *)
        if (ioresult<>0) or (lies_d1_uebrig=0) then
          begin
            lies_d1:=false;
            exit;
          end;

      end;

    lies_d1:=true;

    inc(lies_d1_position);
    dec(lies_d1_uebrig);
    z:=lies_d1_cache[lies_d1_position];

  end;

const
  schreibe_d2_cache:string='';

procedure schreibe_d2(s:string);
  begin
    schreibe_d2_cache:=schreibe_d2_cache+s;
    if pos(^j,schreibe_d2_cache)>0 then
      begin
        write(d2,schreibe_d2_cache);
        schreibe_d2_cache:='';
      end;
  end;

begin
  filemode:=$40;
  assign(d1,paramstr(1));
  assign(d2,paramstr(2));
  reset(d1,1);
  if filesize(d1)=0 then runerror(1);
  rewrite(d2);
  writeln(d2,'                ; '+paramstr(1));

  repeat
    for s:=1 to 16 do
      begin
        if s=1 then
          schreibe_d2('                db ');

        if not lies_d1(zeichen) then
          begin
            (* Programmende *)
            schreibe_d2(umbruch);
            close(d1);
            close(d2);
            halt;
          end;

        if s<>1 then
          schreibe_d2(',');

        schreibe_d2('0');
        schreibe_d2(hex[ord(zeichen) div 16]);
        schreibe_d2(hex[ord(zeichen) mod 16]);

        if s=16 then
          schreibe_d2(umbruch);

      end;
  until false;

end.

