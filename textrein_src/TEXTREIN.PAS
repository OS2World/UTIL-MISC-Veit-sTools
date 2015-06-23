(*$A+,B-,D-,E-,F-,G+,I+,L-,N-,O-,P-,Q-,R-,S-,T-,V+,X-,Y+*)
(*$M 16384,0,0*)

(* $D+,L+*)

program textrein;
(*$D Textrein: Umwandlung in "normalen" Text*)

(*
   07.02.1996       V.K. Neuanfang
   23.02.1996
   11.03.1996
   13.03.1996
   25.03.1996
   03.04.1996        chr(8),virtual pas
   20.12.1997        umgestrickt fÅr lîschen/umbenennen        
   11.03.1998        crt,spra_aus neu *)

uses crt,dos,textreis;

const
  puffergroesse=40*512;
  alle_wieviel_zeilen
  (*$IFDEF OS2*)
   =100;
  (*$ELSE*)
   =1;
  (*$ENDIF*)

type
  blockread_typ=(*$IFDEF OS2*)longint(*$ELSE*)word(*$ENDIF*);

var
  ein_puffer:array[0..puffergroesse-1] of char;
  ein_puffer_pos:word;
  ein_puffer_gefuellt:blockread_typ;
  aus_puffer:array[0..puffergroesse-1] of char;
  aus_puffer_pos:word;
  eingabe,ausgabe:file;
  eingabe_name,ausgabe_name:string;
  fehler:word;
  eingabezeichen:char;
  verwirf_zeichen:boolean;
  xpos,ypos:longint;
  dateizeit:longint;
  eingabe_laenge:longint;
  eingabe_pos:longint;
  pfad:dirstr;
  name:namestr;
  erweiterung:extstr;
  umbenennen:boolean;


procedure hole_ein;
  begin
    if ein_puffer_pos=puffergroesse then
      ein_puffer_gefuellt:=0;


    if ein_puffer_gefuellt=0 then
      begin
        ein_puffer_pos:=0;
        blockread(eingabe,ein_puffer,puffergroesse,ein_puffer_gefuellt);
        if ein_puffer_gefuellt=0 then
          begin
            fehler:=1;
            eingabezeichen:=^z;
            exit;
          end;
        fehler:=0;
      end;

    if ein_puffer_gefuellt<=ein_puffer_pos then
      begin
        fehler:=1;
        eingabezeichen:=^z;
      end
    else
      begin
        fehler:=0;
        eingabezeichen:=ein_puffer[ein_puffer_pos];
      end;
    inc(ein_puffer_pos);
    inc(eingabe_pos);

  end;

procedure schreibe(a:char);
  var
    geschrieben:blockread_typ;
  begin
    if a<>#0 then
      begin
        aus_puffer[aus_puffer_pos]:=a;
        inc(aus_puffer_pos);
      end;
    if (aus_puffer_pos=puffergroesse) or (a=#0) then
      begin
        blockwrite(ausgabe,aus_puffer,aus_puffer_pos,geschrieben);
        if geschrieben<>aus_puffer_pos then
          begin
            writeln(^g,textz_Schreibfehler^);
            halt(3);
          end;
        aus_puffer_pos:=0;
      end;
  end;

procedure rueckloeschen(nur_leerzeichen:boolean); (* oder nur ein Zeichen *)
  begin
    repeat
      if aus_puffer_pos=0 then
        begin
          if filepos(ausgabe)=0 then break;
          seek(ausgabe,filepos(ausgabe)-1);
          blockread(ausgabe,aus_puffer,1);
          seek(ausgabe,filepos(ausgabe)-1);
          aus_puffer_pos:=1;
        end;

      if nur_leerzeichen and (aus_puffer[aus_puffer_pos-1]<>' ') then
          break;

      dec(aus_puffer_pos);

    until not nur_leerzeichen;
  end;

begin
  writeln('Textrein * V.K.');
  if (paramcount=0)
  or (paramcount>=3)
  or (paramstr(1)='?')
  or (paramstr(1)='/?')
  or (paramstr(1)='-?')
   then
    begin
      writeln(^g,paramstr(0),textz_Eingabedatei_Ausgabedatei^);
      halt(1);
    end;

  eingabe_name:=fexpand(paramstr(1));
  fsplit(eingabe_name,pfad,name,erweiterung);

  if paramcount=2 then
    begin
      ausgabe_name:=fexpand(paramstr(2));
      umbenennen:=false;
    end
  else
    begin
      umbenennen:=true;
      ausgabe_name:=pfad+'TEXTREIN'+'.TMP';
    end;


  if eingabe_name=ausgabe_name then
    begin
      writeln(^g,textz_beide_Namen_sollten_verschieden_sein^);
      halt(1);
    end;

  assign(ausgabe,ausgabe_name);
  (*$I-*)
  reset(ausgabe);
  (*$I+*)
  if ioresult=0 then
    begin
      close(ausgabe);
      writeln(^g,textz_Ausgabedatei_existiert_schon^);
      halt(1);
    end;

  filemode:=64;(* deny none, read only *)
  assign(eingabe,eingabe_name);

  ein_puffer_gefuellt:=0;
  aus_puffer_pos:=0;

  (*$I-*)
  reset(eingabe,1);
  (*$I+*)
  fehler:=ioresult;
  if fehler<>0 then
    begin
      writeln(^g,textz_Fehler^,fehler,textz_beim_OEffnen_der_Eingabedatei^);
      halt(2);
    end;

  (*$I-*)
  rewrite(ausgabe,1);
  (*$I+*)
  fehler:=ioresult;
  if fehler<>0 then
    begin
      writeln(^g,textz_Fehler^,fehler,textz_beim_OEffnen_der_Ausgabedatei^);
      halt(2);
    end;

  eingabe_laenge:=filesize(eingabe);
  eingabe_pos:=0;



  hole_ein;
  verwirf_zeichen:=false;
  if ((ein_puffer[0]='M' ) and (ein_puffer[1]='Z' ))
  or ((ein_puffer[0]=#$60) and (ein_puffer[1]=#$ea))
   then
    begin
      close(eingabe);
      close(ausgabe);
      erase(ausgabe);
      writeln(textz_ist_keine_Textdatei_Abrruch^);
      halt(3);
    end;
  xpos:=1;
  ypos:=1;
  repeat
    if (xpos=1) and ((ypos mod alle_wieviel_zeilen)=0) then
      write(^m,textz_Bearbeite_Zeile^,ypos,' ... ',eingabe_pos*100/eingabe_laenge:1:2,' % ');

    if verwirf_zeichen then hole_ein;
    verwirf_zeichen:=true;
    if fehler=0 then
      begin
        case eingabezeichen of
          #$00..#$06,
          #$0b,
          #$0c,
          #$0e..#$1f:;

          #$07:schreibe(#$07);

          #$08:rueckloeschen(false);

          #$09:
            repeat
              inc(xpos);
              schreibe(' ');
            until (xpos mod 8)=1;

          #$0a:
            begin
              rueckloeschen(true);
              hole_ein;
              schreibe(#$0d);schreibe(#$0a);
              xpos:=1;
              inc(ypos);
              verwirf_zeichen:=(eingabezeichen=#$0d);
            end;

          #$0d:
            begin
              rueckloeschen(true);
              hole_ein;
              schreibe(#$0d);schreibe(#$0a);
              xpos:=1;
              inc(ypos);
              verwirf_zeichen:=(eingabezeichen=#$0a);
            end;
        else
          schreibe(eingabezeichen);
          inc(xpos);
        end;
      end;
  until fehler<>0;

  (* alles zurÅckschreiben, schlie·en, Dateizeit setzen *)
  schreibe(#0);
  getftime(eingabe,dateizeit);
  close(eingabe);
  truncate(ausgabe);
  reset(ausgabe,1);
  setftime(eingabe,dateizeit);
  writeln(^m,eingabe_laenge,textz_zu^,filesize(ausgabe),textz_Byte_umgewandelt_^);
  close(ausgabe);

  if umbenennen then
    begin
      erase(eingabe);
      rename(ausgabe,eingabe_name);
    end;

end.

