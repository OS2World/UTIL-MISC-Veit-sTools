program tag_monat_jahr;

(* 28.12.1997                   *)
(* 05.08.1998 Ausgabe in Datei  *)
(* 1999.01.16 /A86..,/PAS...    *)
(* 1999.01.29 /DIZ              *)

uses dos;

var
  tag,
  monat,
  jahr,
  wochentag :(*$IFDEF VIRTUALPASCAL*)longint(*$ELSE*)word(*$ENDIF*);

  ausgabe:text;

begin
  if paramcount=0 then
    assign(ausgabe,'')
  else
    assign(ausgabe,paramstr(paramcount));

  getdate(jahr,monat,tag,wochentag);
  if paramstr(1)='/PAS' then
    begin
      rewrite(ausgabe);
      writeln(ausgabe,'const');
      writeln(ausgabe,'  typ_tag =',tag  :4,';');
      writeln(ausgabe,'  typ_mon =',monat:4,';');
      writeln(ausgabe,'  typ_jahr=',jahr :4,';');
    end
  else if paramstr(1)='/PASTTMMJJJJ' then
    begin
      rewrite(ausgabe);
      writeln(ausgabe,#39,tag:2,'.',monat:2,'.',jahr:4,#39);
    end
  else if paramstr(1)='/PASJJJJMMTT' then
    begin
      rewrite(ausgabe);
      writeln(ausgabe,#39,jahr:4,'.',monat:2,'.',tag:2,#39);
    end
  else if paramstr(1)='/A86TTMMJJJJ' then
    begin
      rewrite(ausgabe);
      writeln(ausgabe,'db "',tag:2,'.',monat:2,'.',jahr:4,'"');
    end
  else if paramstr(1)='/A86JJJJMMTT' then
    begin
      rewrite(ausgabe);
      writeln(ausgabe,'db "',jahr:4,'.',monat:2,'.',tag:2,'"');
    end
  else if paramstr(1)='/DIZ' then 
    begin
      rewrite(ausgabe);
      writeln(ausgabe,paramstr(2),' ',jahr:4,'.',monat:2,'.',tag:2);
    end
  else
    begin
      rewrite(ausgabe);
      writeln(ausgabe,paramstr(1),' ',tag:2,'.',monat:2,'.',jahr:4);
    end;

  close(ausgabe);
end.

