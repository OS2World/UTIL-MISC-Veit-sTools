program unpacker_fuer_xlink;

(*$D Entpacker fr XLINK [2.02] * V.K. *)
(* Veit Kannegieser 21,22,29.11.1997 *)
(*                  30.12.1997 uses suchedat *)
(*                  17.01.1998 filemode $40 *)
(*                  27.01.1998 unxlink test.exe X\ nicht runerror 3 (mkdir2) *)
(*                  11.03.1998 sprache *)
(*                  01.04.1998 mkdir neu *)
(*                  1999.01.06 funktioniert auch mit anderen Versionen als 2.02 *)
(*                             strnull -> strings *)

uses mkdir2,strings,suchedat,unxl_spr;

type
  word_ptr   =^word;
  longint_ptr=^longint;

const
  suchfolge1='XL'#$02#$82;
  suchfolge2='XL'#$00#$83;

var
  d1,d2:file;
  p:array[0..20000] of byte;
  xlink_start:longint;
  gelesen:(*$IFDEF OS2*)longint(*$ELSE*)word(*$ENDIF*);
  zaehler:word;
  datei_zaehler,anzahl_dateien:word;
  dateiname:string;
  datei_laenge:longint;
  kopflaenge:longint;


procedure abbruch(s:string);
  begin
    writeln(s);
    halt(1);
  end;

procedure entschluesseln(var p:array of byte;anzahl:word;startwert:byte);
  var
    z:word;
  begin
    for z:=0 to anzahl-1 do
      dec(p[z],startwert+z);
  end;

begin
  if  (paramcount<1) or (paramcount>2) then
    abbruch(textz_Benutzung_^+paramstr(0)+textz_systax2^);

  assign(d1,paramstr(1));
  filemode:=$40;
  reset(d1,1);

  xlink_start:=suche_zeichenkette_in_datei(paramstr(1),0,suchfolge1);
  if xlink_start=nicht_gefunden then
    xlink_start:=suche_zeichenkette_in_datei(paramstr(1),0,suchfolge2);

  if xlink_start=nicht_gefunden then
    abbruch(textz_kein_XLINK_gefunden^);

  seek(d1,xlink_start);

  blockread(d1,p,$10,gelesen);

  anzahl_dateien:=word_ptr   (@p[$8])^;
  kopflaenge    :=longint_ptr(@p[$c])^;

  mkdir_verschachtelt(paramstr(2));


  for datei_zaehler:=1 to anzahl_dateien do
    begin
      seek(d1,xlink_start+kopflaenge+(datei_zaehler-1)*$20);
      blockread(d1,p,$20);
      entschluesseln(p,$20,(datei_zaehler-1)*$20);

      dateiname:=StrPas(PChar(@p[$0]));
      datei_laenge:=longint_ptr(@p[$10])^;

      seek(d1,xlink_start+longint_ptr(@p[$14])^); (* Start der Daten *)

      writeln('þ ',dateiname);


      if datei_zaehler=1 then
        dateiname:='_____XLC.SRT'; (* '@' -> '.' *)

      assign(d2,paramstr(2)+dateiname);
      rewrite(d2,1);

      while datei_laenge>0 do
        begin
          if datei_laenge>512 then
            blockread(d1,p,512,gelesen)
          else
            blockread(d1,p,datei_laenge,gelesen);

          if datei_zaehler=1 then entschluesseln(p,gelesen,filepos(d2));

          blockwrite(d2,p,gelesen);
          dec(datei_laenge,gelesen);
        end;

      close(d2);
    end;

  close(d1);


end.
