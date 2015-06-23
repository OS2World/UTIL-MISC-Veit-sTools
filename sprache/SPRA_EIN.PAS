(* V.K. 04.10.1996 *)
(* 23.10.1996 Kennung *)
(* 01.12.1996 Untersttzung fr ^array[...] *)
(* 12.06.1998 VP20 Frame-, USES NONE, S- *)
unit spra_ein;

interface

(*$I SPRA_DAT*)

procedure sprachtabellenkopf(englisch,deutsch,franzoesisch,russisch:boolean);
procedure sprachtabellenkopf_ereitert(englisch,deutsch,franzoesisch,russisch,nur_ein_feld:boolean);
procedure sprach_eintrag(bezeichner,englisch,deutsch,franzoesisch,russisch:string);
procedure schreibe_sprach_datei(name_dat,name_pas,objekt_bezeichner,start_bezeichner,typ_bezeichner:string);

implementation

const
  null:byte=0;
var
  sprachen_vorhanden:sprachen_vorhanden_typ;
  sprach_elemente:word;
  zeichenketten_tabelle:zeichenketten_tabelle_typ;
  eine_variable:boolean;
  textz_praefix:string;

procedure sprachtabellenkopf(englisch,deutsch,franzoesisch,russisch:boolean);
  begin
    sprachtabellenkopf_ereitert(englisch,deutsch,franzoesisch,russisch,false);
  end;

procedure sprachtabellenkopf_ereitert(englisch,deutsch,franzoesisch,russisch,nur_ein_feld:boolean);
  begin
    sprach_elemente:=0;
    sprachen_vorhanden[name_bezeichner      ]:=true        ;
    sprachen_vorhanden[sprache_englisch     ]:=englisch    ;
    sprachen_vorhanden[sprache_deutsch      ]:=deutsch     ;
    sprachen_vorhanden[sprache_franzoesisch ]:=franzoesisch;
    sprachen_vorhanden[sprache_russisch     ]:=russisch    ;
    eine_variable:=nur_ein_feld;
    if nur_ein_feld then 
      textz_praefix:=''
    else
      textz_praefix:='textz_'
  end;

procedure sprach_eintrag(bezeichner,englisch,deutsch,franzoesisch,russisch:string);
  var
    zeile:eintragsfeld_typ;

  procedure einzel_eintrag(sprache:byte;eintrag:string);
    begin
      if not sprachen_vorhanden[sprachen_vorhanden_menge(sprache)] then
        zeichenketten_tabelle[sprach_elemente][sprachen_vorhanden_menge(sprache)]:=nil
      else
        begin
          getmem(zeichenketten_tabelle[sprach_elemente][sprachen_vorhanden_menge(sprache)],length(eintrag)+1);
          zeichenketten_tabelle[sprach_elemente][sprachen_vorhanden_menge(sprache)]^:=eintrag;
        end;

    end;

  var
    zaehl:byte;

  begin
    if (pos(' ',bezeichner)>0)
    or (pos('„',bezeichner)>0)
    or (pos('”',bezeichner)>0)
    or (pos('',bezeichner)>0)
    or (pos('Ž',bezeichner)>0)
    or (pos('™',bezeichner)>0)
    or (pos('š',bezeichner)>0)
    or (pos('á',bezeichner)>0)
      then
        begin
          writeln('Fehler:',bezeichner);
          readln;
          halt;
        end;

    zeile[name_bezeichner     ]:=bezeichner  ;
    zeile[sprache_englisch    ]:=englisch    ;
    zeile[sprache_deutsch     ]:=deutsch     ;
    zeile[sprache_franzoesisch]:=franzoesisch;
    zeile[sprache_russisch    ]:=russisch    ;

    inc(sprach_elemente);
    if sprach_elemente>high(zeichenketten_tabelle) then
      begin
        writeln('zu viele Spracheintr„ge !');
        halt(1);
      end;

    for zaehl:=ord(low(sprachen_vorhanden_menge)) to ord(high(sprachen_vorhanden_menge)) do
      einzel_eintrag(zaehl,zeile[sprachen_vorhanden_menge(zaehl)]);

end;

procedure schreibe_sprach_datei(name_dat,name_pas,objekt_bezeichner,start_bezeichner,typ_bezeichner:string);
  var
    datei_dat:text;
    datei_pas:text;
    zaehler:word;
    sprachzaehler:byte;
    zk:str_z;

  procedure block_asm(var f:text;var p;anzahl:word);
    var
      za:word;
      b_z:^byte;
      b_z_longint:longint absolute b_z;
      b:byte;
    begin
      write(f,'    db ');
      for za:=0 to anzahl-1 do
        begin

          b_z:=addr(p);
          inc(b_z_longint,za);
          b:=b_z^;
          if (b<ord(' ')) or (b=ord('''')) then
            write(f,b)
          else
            write(f,'''',chr(b),'''');

          if za<anzahl-1 then
            begin
              if (za mod (60 div 4))=(60 div 4)-1 then
                begin
                  writeln(f);
                  write(f,'      db ');
                end
              else
                write(f,',');
            end;

        end;
      writeln(f);
    end;
  begin
    assign(datei_dat,name_dat);
    rewrite(datei_dat);
    writeln(datei_dat,'(* nicht editieren ! *)');
    writeln(datei_dat,'procedure ',objekt_bezeichner,';assembler;(*&FRAME-*) (*&USES NONE*) (*$S-*)');
    writeln(datei_dat,'  asm');
    writeln(datei_dat,'    db ',length(spra_kennung),',',#39,spra_kennung,#39);
    block_asm(datei_dat,sprachen_vorhanden,sizeof(sprachen_vorhanden));
    block_asm(datei_dat,sprach_elemente,sizeof(sprach_elemente));


    assign(datei_pas,name_pas);
    rewrite(datei_pas);
    writeln(datei_pas,'(* nicht editieren ! *)');
    writeln(datei_pas,'var');
    writeln(datei_pas,'  ',start_bezeichner,':longint;'); (* 4 Byte *)

    for zaehler:=1 to sprach_elemente do
      begin
        if (zaehler=1) or (not eine_variable) then
          writeln(datei_pas,'  ',textz_praefix,zeichenketten_tabelle[zaehler][name_bezeichner]^,'  :',typ_bezeichner,';');

        for sprachzaehler:=succ(ord(low(sprachen_vorhanden_menge))) to ord(high(sprachen_vorhanden_menge)) do
          begin
            zk:=zeichenketten_tabelle
                [zaehler]
                [sprachen_vorhanden_menge(sprachzaehler)];
            if zk<>nil then
              block_asm(datei_dat,zk^,length(zk^)+1)
            else
              block_asm(datei_dat,null,1)
          end;
      end;

    writeln(datei_dat,'  end;');
    close(datei_dat);

    close(datei_pas);
  end;

end.
