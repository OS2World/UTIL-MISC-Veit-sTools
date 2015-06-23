program norm_fat;

(* 29.09úú30.09.1997 *)
(* 31.12.1997 Sprache *)
(* 11.03.1998 crt,spra_aus neu *)
(* 1999.01.30 BP->BP+VP 2.0 (DPMI32) *)

(*$IFDEF VIRTUALPASCAL*)
  (*$M 2000000*)
  (*$USE32-*)
(*$ELSE*)
  (*$G+*)
  (*$M 64384,0,0*)
(*$ENDIF*)

uses
  (*$IFDEF VIRTUALPASCAL*)
  int_2526,dpmi32df,dpmi32,
  (*$ENDIF*)
  crt,
  dos,
  tast,
  popup,
  gross,
  norm_spr;

const
  datum='1997.09.29úú1999.01.30';
  verzoegerung:boolean=false;
  laenge_verzeichniseintrag=$20;

  geloescht_zeichen='å'; (* #$E5 *)
  korrekturmodus:(unbekannt,immer_ja,immer_nein)=unbekannt;

type
  word_norm=(*$IFDEF VIRTUALPASCAL*)longint(*$ELSE*)word(*$ENDIF*);
  puffertyp=array[0..2048-1] of byte;

  varzeichnis_typ=
    record
      name:array[1..8+3] of char;
      attribute:byte;
      reserviert:array[$0c..$15] of byte;
      zeit_datum:longint;
      start_cluster:word;
      groesse:longint;
    end;
  verzeichnis_sektor=array[1..(sizeof(puffertyp) div sizeof(varzeichnis_typ))] of varzeichnis_typ;

  word_z=^word;
  longint_z=^longint;

procedure abbruch(t:string);
  begin
    if wherex>1 then writeln;
    writeln(t,#7);
    halt(1);
  end;

procedure abbruch_test;
  begin
    if keypressed then
      if readkey=#27 then
        begin
          writeln('[ESC]');
          halt(0);
        end;
  end;

(*$IFDEF VIRTUALPASCAL*)
procedure schreibe(laufwerk:char;nummer:longint;var puffer:puffertyp);
  begin
    abbruch_test;
    if write_logical_sector(ord(upcase(laufwerk))-ord('A'),
         puffer,
         nummer)<>0 then
      abbruch(textz_Schreibfehler_INT_26^);;
  end;
(*$ELSE*)
procedure schreibe(laufwerk:char;nummer:longint;var puffer:puffertyp);
  var
    forderung:
      record
        sektor:longint;
        anzahl:word;
        puffer_zeiger:pointer;
      end;
    fehler:boolean;
  begin
    abbruch_test;
    forderung.sektor:=nummer;
    forderung.anzahl:=1;
    forderung.puffer_zeiger:=@puffer;
    fehler:=false;
    asm
      push ds
        mov al,laufwerk
        and al,$df
        sub al,'A'
        mov cx,-1
        mov bx,ss
        mov ds,bx
        lea bx,forderung
        int $26
        jnc @fehlerfrei

        mov fehler,true

      @fehlerfrei:
        popf
      pop ds
    end;
    if fehler then
       abbruch(textz_Schreibfehler_INT_26^);
  end;
(*$ENDIF*)

(*$IFDEF VIRTUALPASCAL*)
procedure lies(laufwerk:char;nummer:longint;var puffer:puffertyp);
  begin
    abbruch_test;
    if read_logical_sector(ord(upcase(laufwerk))-ord('A'),
         puffer,
         nummer)<>0 then
      abbruch(textz_Lesefehler_INT_25^);
  end;
(*$ELSE*)
procedure lies(laufwerk:char;nummer:longint;var puffer:puffertyp);
  var
    forderung:
      record
        sektor:longint;
        anzahl:word;
        puffer_zeiger:pointer;
      end;
    fehler:boolean;
  begin
    abbruch_test;
    forderung.sektor:=nummer;
    forderung.anzahl:=1;
    forderung.puffer_zeiger:=@puffer;
    fehler:=false;
    asm
      push ds
        mov al,laufwerk
        and al,$df
        sub al,'A'
        mov cx,-1
        mov bx,ss
        mov ds,bx
        lea bx,forderung
        !int $25
        jnc @fehlerfrei

        mov fehler,true

      @fehlerfrei:
        popf
      pop ds
    end;
    if fehler then
       abbruch(textz_Lesefehler_INT_25^);
  end;
(*$ENDIF*)

function leerzeichen_beseitigung(t:string):string;
  var
    posi:byte;
  begin
    while (length(t)>8) and (t[length(t)]=' ') do
      dec(t[0]);

    (* mit Erweiterung ? *)
    if length(t)>8 then
      t:=copy(t,1,8)+'.'+copy(t,9,length(t)-8);

    posi:=8;
    while (posi>0) and (length(t)>=posi) and (t[posi]=' ') do
      begin
        delete(t,posi,1);
        dec(posi);
      end;
    leerzeichen_beseitigung:=t;
  end;

var
  bootsektor:puffertyp;
  b_tab:
    record
      jmp:array[0..2] of byte;
      name:array[3..$a] of char;
      byte_je_sektor:word;
      sektor_je_cluster:byte;
      reservierte_sektoren:word;
      fat_anzahl:byte;
      hauptverzeichnis_eintraege:word;
      sektor_zahl_alt:word;
      media:byte;
      sektoren_je_fat:word;
      sektoren_je_spur:word;
      anzahl_koepfe:word;
      versteckte_sektoren:word;
      sektor_anzahl_neu:longint;
      phys_laufwerksnummer:byte;
      res_25:byte;
      signatur:byte;
      seriennummer:longint;
      vol_name:array[0..10] of char;
    end absolute bootsektor;


    laufwerk:char;
    verzeichnis:string;

    fat_groesse:(bits_12,bits_16,bits_fehler);

    sektor_groesse:word;

procedure bestimme_fat_groesse;
  (*$IFDEF VIRTUALPASCAL*)
  var
    regs:real_mode_call_structure_typ;
  (*$ENDIF*)
  begin
    (*$IFDEF VIRTUALPASCAL*)
    regs.ah_ :=$1c;
    regs.dl_ :=ord(upcase(laufwerk))-ord('A')+1;
    regs.ecx_:=0;
    intr_realmode(regs,$21);

    sektor_groesse:=regs.cx_;
    if regs.dx_<$ff1 then
      fat_groesse:=bits_12
    else
      fat_groesse:=bits_16;

    (*$ELSE*)
    asm
      push ds
        mov ah,$1c
        mov dl,laufwerk
        and dl,$df
        sub dl,'A'
        inc dl
        mov cx,0
        int $21
      pop ds

      mov fat_groesse,bits_fehler

      mov sektor_groesse,cx
      (* cmp cx,512
      jnz @ende *)

      mov fat_groesse,bits_12
      cmp dx,$ff1
      jb @ende

      mov fat_groesse,bits_16

@ende:
    end;
    (*$ENDIF*)

    if (fat_groesse=bits_fehler) or (sektor_groesse<128) or (sektor_groesse>sizeof(puffertyp)) then
      abbruch(textz_nicht_12_16_BIT_FAT_mit_128_512_1024_2048_Byte_je_Sektor^);
  end;

function berechne_nachfolge_cluster(c_nummer:word):word;
  var
    fat_sekt01:array[0..1] of puffertyp;
    fat_mod:array[0..1023] of byte absolute fat_sekt01;
    temp:longint;

    fat_bit_start:longint;
  begin

    berechne_nachfolge_cluster:=$ffff;

    case fat_groesse of
      bits_12:
        begin
          fat_bit_start:=longint(c_nummer)*12;

          lies(laufwerk,b_tab.reservierte_sektoren+fat_bit_start div (sektor_groesse*8)+0,fat_sekt01[0]);
          lies(laufwerk,b_tab.reservierte_sektoren+fat_bit_start div (sektor_groesse*8)+1,fat_sekt01[1]);
          temp:=longint_z(@fat_mod[(fat_bit_start mod (sektor_groesse*8)) div 8])^ shr (fat_bit_start mod 8);
          temp:=temp and $fff;
          if (temp=$000) (* frei *)
          or (temp>$ff0) (* FF1..FF7 schlecht, FF8..FFE,FFF Dateikette *)
           then
            temp:=$ffff;
          berechne_nachfolge_cluster:=temp;
        end;
      bits_16:
        begin
          fat_bit_start:=longint(c_nummer)*16;

          lies(laufwerk,b_tab.reservierte_sektoren+fat_bit_start div (sektor_groesse*8)+0,fat_sekt01[0]);
          lies(laufwerk,b_tab.reservierte_sektoren+fat_bit_start div (sektor_groesse*8)+1,fat_sekt01[1]);
          temp:=word_z(@fat_mod[(fat_bit_start mod (sektor_groesse*8)) div 8])^;
          if (temp=$0000) (* frei *)
          or (temp>$fff0) (* FFF1..FFF7 schlecht, FFF8..FFFE,FFFF Dateikette *)
           then
            temp:=$ffff;
          berechne_nachfolge_cluster:=temp;
        end;
    else
      runerror(0);
    end;
  end;

function berchne_sektor_aus_cluster(c_nummer:word):longint;
  begin
    berchne_sektor_aus_cluster:=(c_nummer-2)*longint(b_tab.sektor_je_cluster)
      +b_tab.hauptverzeichnis_eintraege div (sektor_groesse div laenge_verzeichniseintrag)
      +b_tab.reservierte_sektoren
      +b_tab.fat_anzahl*b_tab.sektoren_je_fat;
  end;

procedure unterverzeichnis(verzeichnisname:string;start_cluster:word);forward;


procedure untersuche(var verzeichnisname:string;var datei_block:varzeichnis_typ;var veraendert:boolean);
  var
    dt:datetime;

  function frage_aenderung:boolean;
    var
      pop_sich:popup_sicherung_typ;
    begin
      case korrekturmodus of
        unbekannt:
          begin
            repeat
              popup_ein(pop_sich);
              writeln;
              writeln(textz_AEnderung_schreiben_^);
              writeln(textz__J_a^);
              writeln(textz__N_ein^);
              writeln(textz__I_mmer^);
              writeln(textz_ni_e_^);
              writeln(textz__A_bbruch^);
              write  ('    ');
              hole_taste;
              if upcase(taste.ascii)='Y' then taste.ascii:='J';
              if upcase(taste.ascii)='L' then taste.ascii:='I';
              popup_aus(pop_sich);
            until upcase(taste.ascii) in ['J','N','I','E','A'];

            case upcase(taste.ascii) of
              'J':frage_aenderung:=true;
              'N':frage_aenderung:=false;
              'I':
                begin
                  korrekturmodus:=immer_ja;
                  frage_aenderung:=true;
                end;
              'E':
                begin
                  korrekturmodus:=immer_nein;
                  frage_aenderung:=false;
                end;
              'A':halt(255);
            end;
          end;
        immer_ja:
          frage_aenderung:=true;
        immer_nein:
          frage_aenderung:=false;
      end;

    end;

  procedure frage_loeschen;
    var
      altx:byte;
    begin
      altx:=wherex;
      writeln(textz_geloescht^);
      gotoxy(altx,wherey);
      if not frage_aenderung then exit;

      datei_block.name[1]:=geloescht_zeichen;
      veraendert:=true;
    end;

  procedure frage_ruecksetzen_auf_datentraegerbezeichnung;
    var
      altx:byte;
    begin
      altx:=wherex;
      writeln(textz_auf_Datentraegerbezeichnung_zurueckgesetzt^);
      gotoxy(altx,wherey);
      if not frage_aenderung then exit;

      datei_block.attribute:=$08;
      veraendert:=true;
    end;

  procedure frage_ruecksetzen_auf_normales_vberzeichnis;
    var
      altx:byte;
    begin
      altx:=wherex;
      writeln(textz_auf_normales_Verzeichnis_zurueckgesetzt^);
      gotoxy(altx,wherey);
      if not frage_aenderung then exit;

      datei_block.attribute:=$10;
      veraendert:=true;
    end;

  procedure zeit_korrektur(titel:string;var wert:word_norm;min,max:word_norm);
    var
      temp:word_norm;
      altx:byte;
    begin
      if (wert<min) or (wert>max) then
        begin
          altx:=wherex;
          temp:=wert;
          while temp<min do inc(temp);
          while temp>max do dec(temp);
          writeln(textz_Zeitkorrektur_^+titel+':',wert,'->',temp,')');
          gotoxy(altx,wherey);
          if not frage_aenderung then exit;

          wert:=temp;
          veraendert:=true;
        end;
    end;

  begin
    (**********************************************************************)
    write(^m,verzeichnisname+leerzeichen_beseitigung(datei_block.name));
    clreol;
    if verzoegerung then writeln;

    (* Untersuchung gewnscht *)
    if pos(verzeichnis+'\',verzeichnisname+leerzeichen_beseitigung(datei_block.name)+'\')=1 then
      begin

        (* Verzeichnis+Volume..."LFN" *)
        if ((datei_block.attribute and $18)=$18)
        or (datei_block.attribute=$0f)
         then
          frage_loeschen;

        if datei_block.name[1]=geloescht_zeichen then exit;

        (* Datentr„gername ? *)
        if (datei_block.attribute and $08)=$08 then
          (* nicht im Hauptverzeichnis ? *)
          if length(verzeichnisname)>length('?:\') then
            frage_loeschen
          else
            (* im Hauptverzeichnis, aber Zusatzattribute ? *)
            (* 2MF: VOL+ARC *)
            if (datei_block.attribute or archive)<>(volumeid or archive) then
              frage_ruecksetzen_auf_datentraegerbezeichnung;

        if datei_block.name[1]=geloescht_zeichen then exit;


        (* Verzeichnis mit Zus„tzen ? *)
        if  ((datei_block.attribute and $10)=$10)
        and (datei_block.attribute<>$10) then
          frage_ruecksetzen_auf_normales_vberzeichnis;


        unpacktime(datei_block.zeit_datum,dt);

        zeit_korrektur(textz_Monat^,dt.month,1,12);

        case dt.month of
          1,3,5,7,8,10,12:
            zeit_korrektur(textz_Tag^,dt.day,1,31);
          4,6,9,11:
            zeit_korrektur(textz_Tag^,dt.day,1,30);
          2:
            if ((dt.year mod 4)<>0)
            or (((dt.year mod 100)=0) and (dt.year<>2000)) then
              zeit_korrektur(textz_Tag^,dt.day,0,28)
            else
              zeit_korrektur(textz_Tag^,dt.day,0,29)
        end;
        zeit_korrektur(textz_Stunden^ ,dt.hour,0,23);
        zeit_korrektur(textz_Minuten^ ,dt.min ,0,59);
        zeit_korrektur(textz_Sekunden^,dt.sec ,0,58);

        packtime(dt,datei_block.zeit_datum);
      end;

    (**********************************************************************)

    if ((datei_block.attribute and $10)=$10)
    and (datei_block.name<>'.       '+'   ')
    and (datei_block.name<>'..      '+'   ')
    and (
         (* pos('C:\TEST1\TEST2\','C:\TEST1\TEST2\UNTER') *)
         (pos(verzeichnis+'\',verzeichnisname+leerzeichen_beseitigung(datei_block.name)+'\')=1)
         or
         (* pos('C:\TEST1\','C:\TEST1\TEST2\' *)
         (pos(verzeichnisname+leerzeichen_beseitigung(datei_block.name)+'\',verzeichnis+'\')=1)
        )
     then
      unterverzeichnis(verzeichnisname+leerzeichen_beseitigung(datei_block.name)+'\',datei_block.start_cluster);
  end;



procedure bearbeite(verzeichnisname:string;sektor:longint;var stop:boolean);
  var
    arbeitssektor:puffertyp;
    zaehler2:word;
    veraendert:boolean;
  begin
    stop:=false;
    veraendert:=false;
    lies(laufwerk,sektor,arbeitssektor);

    for zaehler2:=1 to sektor_groesse div laenge_verzeichniseintrag do
      begin
        if verzeichnis_sektor(arbeitssektor)[zaehler2].name[1]=#0 then
          begin
            stop:=true;
            break;
          end;

        if (verzeichnis_sektor(arbeitssektor)[zaehler2].name[1]<>geloescht_zeichen) then
          untersuche(verzeichnisname,verzeichnis_sektor(arbeitssektor)[zaehler2],veraendert);
      end;

    if veraendert then
      schreibe(laufwerk,sektor,arbeitssektor);
  end;

procedure unterverzeichnis(verzeichnisname:string;start_cluster:word);
  var
    stop:boolean;
    start_sektor:longint;
    zaehler1:word;
  begin
    start_sektor:=berchne_sektor_aus_cluster(start_cluster);
    zaehler1:=0;
    repeat
      bearbeite(verzeichnisname,start_sektor+zaehler1,stop);
      inc(zaehler1);

      if zaehler1=b_tab.sektor_je_cluster then
        begin
          zaehler1:=0;
          start_cluster:=berechne_nachfolge_cluster(start_cluster);
          if start_cluster=$ffff then stop:=true;
          start_sektor:=berchne_sektor_aus_cluster(start_cluster);
        end;

    until stop;
  end;


procedure hauptverzeichnis;
  var
    zaehler1:word;
    stop:boolean;
  begin
    zaehler1:=0;

    repeat
      bearbeite(laufwerk+':\',zaehler1+b_tab.reservierte_sektoren
      +b_tab.fat_anzahl*b_tab.sektoren_je_fat,stop);
      inc(zaehler1);
    until stop or (zaehler1=b_tab.hauptverzeichnis_eintraege div (sektor_groesse div laenge_verzeichniseintrag));

  end;

var
  para:string;
  para_zaehler:word;

begin
  writeln('NORM-FAT * Veit Kannegieser * ',datum);

  if paramcount=0 then
    abbruch(textz_hilfe_text^);

  for para_zaehler:=1 to paramcount do
    begin
      para:=paramstr(para_zaehler);
      if length(para)=2 then
        if para[1] in ['-','/'] then
          case upcase(para[2]) of
            'Y','J':korrekturmodus:=immer_ja;
            'N'    :korrekturmodus:=immer_nein;
            '?','H':abbruch(textz_hilfe_text^);
            'Z'    :verzoegerung:=true;
          end;
    end;

  for para_zaehler:=1 to paramcount do
    begin
      para:=paramstr(para_zaehler);

      if upcase(para[1]) in ['-','/'] then continue;

      verzeichnis:=fexpand(para);
      gross_str(verzeichnis);
      laufwerk:=verzeichnis[1];

      if not (laufwerk in ['A'..'`']) then
        abbruch('unzul„ssiges Laufwerk '+laufwerk);

      if verzeichnis[length(verzeichnis)]='\' then
        (* C:\      -> C:      *)
        (* C:\TEST  -> C:\TEST *)
        (* C:\TEST\ -> C:\TEST *)
        dec(verzeichnis[0]);


      bestimme_fat_groesse;
      fat_groesse:=bits_16;
      fillchar(bootsektor,sizeof(bootsektor),0);
      lies(laufwerk,0,bootsektor);
      if (sektor_groesse=512) and (word_z(@bootsektor[$1fe])^<>$aa55) then
        abbruch(textz_ungueltiger_Bootsktor^);
      hauptverzeichnis;
      write(^m);clreol;
    end;
end.
