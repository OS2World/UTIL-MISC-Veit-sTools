(*&Use32+*)
program make512;
(* Veit Kannegieser 27.06.1996 *)
(* 1999.02.03 fillchar(titel)  *)
(* 2000.05.21 Dateien sortiert *)

uses
  dos;


(*$IFNDEF VirtualPascal*)
type
  smallword     =word;
(*$ENDIF*)

var
  p             :packed array[1..512] of byte;
  datei1,datei2 :file;
  titel         :string[8];
  anzahl        :smallword;
  sr            :SearchRec;
  fehler        :word;
  feld          :array[1..255] of string[8];
  z             :word;

begin
  anzahl:=0;
  FillChar(feld,SizeOf(feld),0);

  FindFirst(paramstr(2)+'*.512',archive,sr);
  fehler:=Dos.DosError;
  while fehler=0 do
    begin
      FillChar(titel,SizeOf(titel),0);
      titel:=Copy(sr.name,1,Pos('.',sr.name)-1);
      
      for z:=1 to High(titel) do
        case titel[z] of 
          'A'..'Z':
            Inc(titel[z],Ord('a')-Ord('A'));
          'é':titel[z]:='Ñ';
          'ô':titel[z]:='î';
          'ö':titel[z]:='Å';
        end;
        
      z:=1;
      while (z<=anzahl) and (titel>feld[z]) do
        Inc(z);
      Move(feld[z],feld[z+1],(High(feld)-z)*SizeOf(feld[z]));
      Move(titel,feld[z],SizeOf(titel));
      Inc(anzahl);
      FindNext(sr);
      fehler:=Dos.DosError;
    end;
  (*$IFDEF VirtualPascal*)
  FindClose(sr);
  (*$ENDIF*)



  Assign(datei1,ParamStr(1));
  Rewrite(datei1,1);

  BlockWrite(datei1,anzahl,SizeOf(anzahl));

  for z:=1 to anzahl do
    begin
      BlockWrite(datei1,feld[z],SizeOf(feld[z]));
      Assign(datei2,feld[z]+'.512');
      Reset(datei2,1);
      BlockRead(datei2,p,SizeOf(p));
      close(datei2);
      BlockWrite(datei1,p,SizeOf(p));
    end;
  Close(datei1);
end.
