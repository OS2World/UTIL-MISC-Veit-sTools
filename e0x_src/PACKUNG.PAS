{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X-}
{$M 16384,0,0}
program packung;
(* V. K. 15.08.1995  .. 07.03.1996 *)
(* 11.10.1996 Sprache *)

uses packung2;

type
  einzelsektor_typ=
    record
      cl,ch,dh:byte;
      xms_off:longint;
    end;

  kopf_typ=
    record
      text:array[1..80] of char;
      sektoren:word;
      spuren:byte;
      sekt_spur:byte;
      koepfe:byte;
      anzahl_extra:byte;
      extra:array[1..4] of einzelsektor_typ;
      rest:array[1..398] of byte;
    end;

  sektor=array[0..511] of byte;

const
  kopf:kopf_typ=(
    text:'Erweiterter Plattenabzug f걊 E0X / V.K.'+#26+'                                        ';
    sektoren:0;
    spuren:0;
    sekt_spur:0;
    koepfe:0;
    anzahl_extra:0;
    extra:((cl:255;ch:255;dh:255),(cl:255;ch:255;dh:255),(cl:255;ch:255;dh:255),(cl:255;ch:255;dh:255)));

var
  test:longint;
  quellname,zielname:string;
  quelle,ziel:file;
  puffer:sektor;
  w1,w2,w3:word;

function x_word(var x):word;
  var
    wp:^word;
  begin
    wp:=@x;
    x_word:=wp^;
  end;

function eingabe(vorgabe:word):word;
  var
    ein:string;
    tmp:word;
    kontrolle:word;
  begin
    eingabe:=vorgabe;
    write('[',vorgabe,'] : ');
    readln(ein);
    if ein<>'' then
      begin
        val(ein,tmp,kontrolle);
        if kontrolle=0 then eingabe:=tmp;
      end;
  end;

begin
  filemode:=0;
  writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
  writeln('Packung / V.K. '+textz_fuer^+' E0X');
  writeln;
  write(textz_Zieldatei^+' : ');
  readln(zielname);
  if zielname='' then halt;

  write(textz_Haupt_Quelldatei^+' : ');
  readln(quellname);
  if quellname='' then halt;

  assign(quelle,quellname);
  filemode:=0;
  reset(quelle,512);
  blockread(quelle,puffer,1);

  assign(ziel,zielname);
  rewrite(ziel,512);

  writeln;

  write(textz_Spuren^+' ');
  test:=x_word(puffer[$18])*longint(x_word(puffer[$1a]));
  if (test=0) or (test>50*2) then
    kopf.spuren:=eingabe(80)
  else
    kopf.spuren:=eingabe((x_word(puffer[$13]) div (test)));

  write(textz_Sektoren_je_Spur^+' ');
  kopf.sekt_spur:=eingabe(x_word(puffer[$18]));

  write(textz_Seiten^+' ');
  kopf.koepfe:=eingabe(x_word(puffer[$1a]));

  kopf.sektoren:=kopf.koepfe*kopf.sekt_spur*kopf.spuren;

  blockwrite(ziel,kopf,1);

  writeln;

  seek(quelle,0);

  for w1:=1 to kopf.spuren do
    for w2:=1 to kopf.koepfe do
      for w3:=1 to kopf.sekt_spur do
        begin
          write(textz_Kopieren^+' ',w1:2,'/',w2:2,'/',w3:2,#13);
          blockread(quelle,puffer,1);
          blockwrite(ziel,puffer,1);
        end;

  writeln;
  close(quelle);

  writeln;
  write(textz_Anzahl_zusaetzlicher_Sektoren^+' ');
  kopf.anzahl_extra:=eingabe(0);

  for w1:=1 to kopf.anzahl_extra do
    begin
      writeln;
      write(textz_Quelldatei^+' : ');
      readln(quellname);
      assign(quelle,quellname);
      reset(quelle,512);
      blockread(quelle,puffer,1);
      blockwrite(ziel,puffer,1);
      write(textz_Spur_1_CH^+' : ');
      readln(kopf.extra[w1].ch);
      write(textz_Seite_1_DH^+' : ');
      readln(kopf.extra[w1].dh);
      write(textz_Sektor_CL^+' : ');
      readln(kopf.extra[w1].cl);
      close(quelle);
      kopf.extra[w1].xms_off:=longint(filesize(ziel)-2)*512;
    end;

  if kopf.anzahl_extra>0 then
    begin
      seek(ziel,0);
      blockwrite(ziel,kopf,1);
    end;

  close(ziel);
  writeln('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
end.
