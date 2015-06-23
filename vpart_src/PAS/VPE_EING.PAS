(*&Use32+*)
unit vpe_eing;

interface

var
  spalten,zeilen                :word;
  programmverwendung            :(programmverwendung_unbekannt,
                                  installation,
                                  testprogramm,
                                  entfernen,
                                  passwort_setzen,
                                  schnellkonfigurtaion,
                                  hilfe_bildschirm);
  org_cursor                    :word;

  quelldatei,logdatei           :text;

type
  (*$IFNDEF VirtualPascal*)
  smallword                     =word;
  (*$ENDIF*)

  auswahlliste_eintrag_typ=
    record
      titel                     :string;
      taste                     :char;
      hilfe                     :string;
      ergebnis                  :string; (* Kennung *)
      wert                      :char;   (* ' '=leer *)
    end;

  (* liefert true fÅr Wahl des Ende-Eintrages *)
  anwahlliste_aenderungsprozedur_typ=function(var element:auswahlliste_eintrag_typ):boolean;
  anwahlliste_ladeprozedur_typ      =function(var element:auswahlliste_eintrag_typ;var sollwert:string):boolean;

  auswahl_tabelle_typ=
    record
      anzahl_benutzt            :word;
      eintraege                 :array[1..500] of ^auswahlliste_eintrag_typ;
      j_y_gleich                :boolean;
      ist_anwahlliste           :boolean;
      anwahlliste_aenderungsprozedur     :anwahlliste_aenderungsprozedur_typ;
      anwahlliste_ladeprozedur           :anwahlliste_ladeprozedur_typ;
    end;

  tasten8                       =array[1..8] of smallword;

const
  anzahl_hilfezeilen            =5;
  log_farbe                     =$1e;
  antwort_farbe                 =$1a;
  hilfe_farbe                   =$6f;
  fenster_farbe                 =$70;
  fenster_balken_farbe          =$2f;
  komandozeilen_farbe           =$07;

  quelldatei_offen              :boolean        =false;
  logdatei_offen                :boolean        =false;
  quelldatei_eintraege_uberspringen :boolean    =true;

  kommentarbalken='############################################################';


procedure cursor_sichtbar;
procedure cursor_unsichtbar;
function  ja_nein_str(const jn:char):string;
procedure gross(var s:string);
procedure klein(var s:string);
procedure leerzeichenerweiterung(var zk:string;const stellen:word);
procedure doppelleerzeichenerweiterung(var zk:string;const stellen:word);
procedure Abbruch_durch_den_Benutzer;
procedure abbruch(const t:string);
procedure hilfestatus(const zk:string);
procedure auswahlliste_neu(var l:auswahl_tabelle_typ;const j_y_gleich:boolean);
procedure auswahlliste_zu_anwahlliste(var l:auswahl_tabelle_typ;aenderungsprozedur:anwahlliste_aenderungsprozedur_typ;
            anwahlliste_ladeprozedur:anwahlliste_ladeprozedur_typ);
procedure auswahlliste_eintrag(var l:auswahl_tabelle_typ;const titel1:string;
            const taste1:char;const ergebnis1,hilfe1:string);
procedure anwahlliste_eintrag(var l:auswahl_tabelle_typ;const titel1:string;
            const taste1:char;const ergebnis1,hilfe1:string;const wert1:char);
function  auswahlliste_anzeigen(var l:auswahl_tabelle_typ;const vorgabe:string;
            const ueberschrift:string;const log_kommentar:string):string;
function  ja_nein_frage(const frage:string;standardwert:char;
            const log_kommentar:string;const hilfe:string):string;
function  eingabe(const frage:string;const standardwert:string;const maxl:word;
            const log_kommentar:string;const hilfe:string):string;
procedure Befehlszeile;
procedure abbruch_oder_weiter(const frage,log_name,kurzmeldung:string;const standardwert:char);
procedure antwort_ausschrift_gz(const zk:string);
procedure antwort_ausschrift   (const zk:string);
procedure tasten_aufzeichnung(var tastendruecke_anzahl:byte;var tastendruecke:tasten8;const titel,log_kommentar,hilfe:string);
procedure oeffne_quelle(const quellname:string);
procedure oeffne_log   (const logname  :string);
procedure schliesse_quelle;
procedure schliesse_log;
function  lies_quelle(const stichwort:string;var gelesen:string):boolean;
procedure uebergehe_quelle(const stichwort:string);
procedure schreibe_log(const stichwort:string;const eintrag:string);
procedure schreibe_log_kommentar(const zeile:string);


implementation

uses
  (*$IFDEF OS2*)
  Os2Base,Os2Def,
  (*$ENDIF*)
  vpe_spr,
  VioWin,
  (*$IFDEF VirtualPascal*)
  VpSysLow,
  VpUtils,
  (*$ELSE*)
  TpSysLow,
  TpUtils,
  (*$ENDIF*)
  Crt,
  Dos;


function SysReadKey2:char;
  begin
    while not SysKeyPressed do

      if (SysTVGetShiftState and (1 or 2 or 4 or 8))<>0 then
        begin
          invisibleWin;

          while (SysTVGetShiftState and (1 or 2 or 4 or 8))<>0 do
            begin

              (*
              if (Mem[Seg0040:$0071] and $80)=$80 then
                begin
                  CWin;
                  SysReadKey2:=^C;
                  Exit;
                end;*)

              if SysKeyPressed then
                if SysReadKey=^C then
                  begin
                    CWin;
                    SysReadKey2:=^C;
                    Exit;
                  end
               else
                 {asm int 3 end};
              SysCtrlSleep(50);
            end;

          CWin;

        end
      else
        SysCtrlSleep(50);

    SysReadKey2:=SysReadKey;
  end;

procedure cursor_sichtbar;
  begin
    SetCursorSize(-80,-100);
  end;

procedure cursor_unsichtbar;
  begin
    SetCursorSize($20,$00);
  end;

function ja_nein_str(const jn:char):string;
  begin
    if UpCase(jn)='N' then
      ja_nein_str:=textz_nein_normal^
    else
      ja_nein_str:=textz_ja_normal^;
  end;

procedure gross(var s:string);
  var
    z:byte;
  begin
    for z:=1 to Length(s) do
      case s[z] of
       'a'..'z':s[z]:=UpCase(s[z]);
       'Ñ':s[z]:='é';
       'î':s[z]:='ô';
       'Å':s[z]:='ö';
      end;
  end;

procedure klein(var s:string);
  var
    z:byte;
  begin
    for z:=1 to Length(s) do
      case s[z] of
       'A'..'Z':Inc(s[z],Ord('a')-Ord('A'));
       'é':s[z]:='Ñ';
       'ô':s[z]:='î';
       'ö':s[z]:='Å';
      end;
  end;

procedure leerzeichenerweiterung(var zk:string;const stellen:word);
  var
    l,z:word;
  begin
    l:=Length(zk);
    for z:=1 to Length(zk) do
      if zk[z]='^' then
        Dec(l);

    while l<stellen do
      begin
        zk:=zk+' ';
        Inc(l);
      end;
  end;

procedure doppelleerzeichenerweiterung(var zk:string;const stellen:word);
  var
    l,z:word;
  begin
    l:=Length(zk);
    for z:=1 to Length(zk) do
      if zk[z]='^' then
        Dec(l);

    if l>stellen then Exit;
    l:=(stellen-l) div 2;
    Insert(Copy('                                        ',1,l),zk,1);
    leerzeichenerweiterung(zk,stellen);
  end;


procedure abbruch(const t:string);
  begin
    WriteLn(t);
    WriteLn;

    schliesse_quelle;
    schliesse_log;

    Window(1,1,spalten,zeilen);
    NormVideo;
    FillScreen(1,zeilen-anzahl_hilfezeilen+1,spalten,zeilen,TextAttr,' ');
    GotoXY(1,zeilen-anzahl_hilfezeilen+1);
    SetCursorSize(Hi(org_cursor),Lo(org_cursor));
    Halt({fehler}0);
  end;

procedure Abbruch_durch_den_Benutzer;
  begin
    abbruch(textz_Abbruch_auf_Wunsch_des_Benutzers^);
  end;

procedure hilfestatus(const zk:string);
  var
    tmp                 :string;
    rest                :string;
    z                   :word;
    p                   :word;
    zeilen_benutzt      :word;
  begin
    rest:=zk;

    zeilen_benutzt:=1;
    if rest<>'' then
      for z:=1 to Length(rest)-1 do
        if (rest[z]=^m) and (rest[z+1]=^j) then
          Inc(zeilen_benutzt);

    for z:=1 to anzahl_hilfezeilen do
      begin
        if (anzahl_hilfezeilen-zeilen_benutzt) div 2>=z then
          tmp:=''
        else
          begin
            p:=Pos(^M^J,rest);
            if p=0 then
              begin
                tmp:=' '+rest;
                rest:='';
              end
            else
              begin
                tmp:=' '+Copy(rest,1,p-1);
                Delete(rest,1,p+1);
              end;
          end;

        leerzeichenerweiterung(tmp,spalten-1);

        WriteXYabs(1,zeilen-anzahl_hilfezeilen+z,tmp,hilfe_farbe);
      end;
  end;


procedure auswahlliste_neu(var l:auswahl_tabelle_typ;const j_y_gleich:boolean);
  begin
    FillChar(l,SizeOf(l),0);
    l.j_y_gleich:=j_y_gleich;
    l.ist_anwahlliste:=false;
    l.anwahlliste_aenderungsprozedur:=nil;
    l.anwahlliste_ladeprozedur:=nil;
  end;

procedure auswahlliste_zu_anwahlliste(var l:auswahl_tabelle_typ;aenderungsprozedur:anwahlliste_aenderungsprozedur_typ;
    anwahlliste_ladeprozedur:anwahlliste_ladeprozedur_typ);
  begin
    l.ist_anwahlliste:=true;
    l.anwahlliste_aenderungsprozedur:=aenderungsprozedur;
    l.anwahlliste_ladeprozedur:=anwahlliste_ladeprozedur;
  end;

procedure auswahlliste_eintrag(var l:auswahl_tabelle_typ;const titel1:string;const taste1:char;const ergebnis1,hilfe1:string);
  begin
    with l do
      begin
        Inc(anzahl_benutzt);
        if anzahl_benutzt>High(eintraege) then
          RunError(215);
        New(eintraege[anzahl_benutzt]);
        with eintraege[anzahl_benutzt]^ do
          begin
            titel:=titel1;
            taste:=taste1;
            ergebnis:=ergebnis1;
            hilfe:=hilfe1;
            wert:=' ';
          end;
      end;
  end;

procedure anwahlliste_eintrag(var l:auswahl_tabelle_typ;const titel1:string;
            const taste1:char;const ergebnis1,hilfe1:string;const wert1:char);
  begin
    with l do
      begin
        Inc(anzahl_benutzt);
        if anzahl_benutzt>High(eintraege) then
          RunError(215);
        New(eintraege[anzahl_benutzt]);
        with eintraege[anzahl_benutzt]^ do
          begin
            titel:=titel1;
            taste:=taste1;
            ergebnis:=ergebnis1;
            hilfe:=hilfe1;
            wert:=wert1;
          end;
      end;
  end;

function auswahlliste_anzeigen(var l:auswahl_tabelle_typ;const vorgabe:string;
           const ueberschrift:string;const log_kommentar:string):string;
  var
    maxx                :word;
    z                   :word;
    z1                  :word;
    anzeige0            :integer;
    zeilensichtbar      :word;
    angewaehlt          :word;
    farbe               :byte;
    zk,zk1              :string;
    xo,yo,ao            :byte;
    t                   :char;
    gleiche_kurztasten  :boolean;
    u1,u2               :string;
    startzeile          :word;

  label
    fertig;

  begin

    (* aus Quelle lesen *)

    if l.ist_anwahlliste then
      while lies_quelle(log_kommentar,zk) do
        begin
          if Pos(':',zk)=0 then Continue;
          zk1:=Copy(zk,1,Pos(':',zk)-1);
          Delete(zk,1,Length(zk1)+Length(':'));
          for z:=1 to l.anzahl_benutzt do
            if l.eintraege[z]^.ergebnis=zk1 then
              begin
                angewaehlt:=z;
                if l.anwahlliste_ladeprozedur(l.eintraege[z]^,zk) then
                  goto fertig;
                Break;
              end;
        end

    else

      if lies_quelle(log_kommentar,zk) then
        begin

          if l.j_y_gleich and (Length(zk)=1) and (zk[1] in ['J','Y']) then
            zk:=UpCase(textz_j_zeichen^[1]);

          for z:=1 to l.anzahl_benutzt do
            if zk=l.eintraege[z]^.ergebnis then
              begin
                angewaehlt:=z;
                goto fertig;
              end;

        end;


    (* sonst Bildschirmarbeit *)
    gleiche_kurztasten:=false;
    for z:=1 to l.anzahl_benutzt-1 do
      for z1:=z+1 to l.anzahl_benutzt do
        if l.eintraege[z]^.taste=l.eintraege[z1]^.taste then
          gleiche_kurztasten:=true;

    z:=Pos(^m^j,ueberschrift);
    if z=0 then
      begin
        u1:=ueberschrift;
        u2:='';
        startzeile:=0;
      end
    else
      begin
        u1:=Copy(ueberschrift,1,z-1);
        u2:=Copy(ueberschrift,z+2,255);
        startzeile:=1;
      end;

    maxx:=Max(Length(u1),Length(u2));
    for z:=1 to l.anzahl_benutzt do
      maxx:=Max(maxx,Length(l.eintraege[z]^.titel));

    (* 5 Zeilen oben + 1 Rand + (1 zusatz) + sichtbar + 2 Rand + 5 Hilfe *)
    zeilensichtbar:=Min(l.anzahl_benutzt,zeilen-2*anzahl_hilfezeilen-3-startzeile);

    xo:=WhereX;
    yo:=WhereY;
    ao:=TextAttr;
    OcWin(maxx+3,zeilensichtbar+startzeile+1,0,fenster_farbe,u1);

    if u2<>'' then
      begin
        doppelleerzeichenerweiterung(u2,maxx);
        WriteXY(2,startzeile+0,u2,fenster_farbe);
      end;


    angewaehlt:=1;
    for z:=1 to l.anzahl_benutzt do
      if vorgabe=l.eintraege[z]^.ergebnis then
        begin
          angewaehlt:=z;
          Break;
        end;

    anzeige0:=0;
    repeat
      if angewaehlt<1 then angewaehlt:=1;
      if angewaehlt>l.anzahl_benutzt then angewaehlt:=l.anzahl_benutzt;

      while anzeige0+1>angewaehlt do
        Dec(anzeige0);

      while (angewaehlt-anzeige0>zeilensichtbar) do
        Inc(anzeige0);

      while (anzeige0>0) and (anzeige0+zeilensichtbar>l.anzahl_benutzt) do
        Dec(anzeige0);


      for z:=1 to zeilensichtbar do
        begin
          z1:=z+anzeige0;
          farbe:=fenster_farbe;
          if z1<=l.anzahl_benutzt then
            begin
              if z1=angewaehlt then
                begin
                  farbe:=fenster_balken_farbe;
                  hilfestatus(l.eintraege[z1]^.hilfe);
                end;
              zk:=l.eintraege[z1]^.titel;
            end
          else
            zk:='';

          leerzeichenerweiterung(zk,maxx+1);
          if (z=1) and (anzeige0>0) then
            zk[Length(zk)]:=#$1e  (* ^ *)
          else
          if (z=zeilensichtbar) and (z1<l.anzahl_benutzt) then
            zk[Length(zk)]:=#$1f; (* v *)
          WriteXY(2,startzeile+z,zk,farbe);
        end;

      t:=SysReadKey2;
      case t of
        ^C:
          begin
            CWin;
            GotoXY(xo,yo);
            TextAttr:=ao;
            Abbruch_durch_den_Benutzer;
          end;

        #$00,#$e0:
         case SysReadKey of
            #$47:angewaehlt:=1;
            #$48:if angewaehlt=1 then angewaehlt:=l.anzahl_benutzt
                 else Dec(angewaehlt);
            #$49:if angewaehlt<5 then angewaehlt:=1
                 else Dec(angewaehlt,5);
            #$4f:angewaehlt:=l.anzahl_benutzt;
            #$50:if angewaehlt=l.anzahl_benutzt then angewaehlt:=1
                 else Inc(angewaehlt);
            #$51:if angewaehlt+5>l.anzahl_benutzt then angewaehlt:=l.anzahl_benutzt
                 else Inc(angewaehlt,5);
          else
            SysBeepEx(100,1);
          end;

        ^M:
          begin
            if not l.ist_anwahlliste then
              Break
            else
              if l.anwahlliste_aenderungsprozedur(l.eintraege[angewaehlt]^) then
                Break;
          end;

      else
        t:=UpCase(t);
        if gleiche_kurztasten then
          begin
            z:=angewaehlt+1;
            repeat
              if z>l.anzahl_benutzt then
                z:=1;
              if l.eintraege[z]^.taste=t then
                Break;

              if z=angewaehlt then
                Break;

              Inc(z);
            until false;

            if z=angewaehlt then
              SysBeepEx(100,1)
            else
              angewaehlt:=z;
          end
        else
          begin
            for z:=1 to l.anzahl_benutzt do
              if l.eintraege[z]^.taste=t then
                begin
                  angewaehlt:=z;
                  t:=^M;
                  Break;
                end;

            if t=^M then
              begin

                if not l.ist_anwahlliste then
                  Break
                else
                  if l.anwahlliste_aenderungsprozedur(l.eintraege[angewaehlt]^) then
                    Break;
              end

            else
              SysBeepEx(100,1);
          end;
      end;

    until false;

    CWin;
    GotoXY(xo,yo);
    TextAttr:=ao;

    hilfestatus('');

  fertig:

    with l do
      begin
        auswahlliste_anzeigen:=eintraege[angewaehlt]^.ergebnis;

        if ist_anwahlliste then
          begin
            for z:=1 to anzahl_benutzt do
              with eintraege[z]^ do
                if (z<>angewaehlt) and (wert<>' ') then
                  schreibe_log(log_kommentar,ergebnis+':'+wert);
            for z:=1 to l.anzahl_benutzt do
              with eintraege[z]^ do
                if (z=angewaehlt) and (wert<>' ') then
                  schreibe_log(log_kommentar,ergebnis+':'+wert);
          end
        else
          begin
            schreibe_log(log_kommentar,eintraege[angewaehlt]^.ergebnis);
          end;


        for z:=1 to anzahl_benutzt do
          Dispose(eintraege[z]);
      end;

  end;

function ja_nein_frage(const frage:string;standardwert:char;const log_kommentar:string;const hilfe:string):string;
  var
    l                   :byte;
    xo,yo,ao            :byte;
    f1,f2,
    frage3              :string;
    t                   :char;
    zeile               :word;
    ergebnis            :char;

  label
    fertig;

  begin

    (* aus Quelldatei lesen *)
    if lies_quelle(log_kommentar,frage3) then
      begin
        ergebnis:=frage3[1];
        if (* j_y_gleich and *) (ergebnis in ['J','Y']) then
           ergebnis:=UpCase(textz_j_zeichen^[1]);
        goto fertig;
      end;

    (* sonst Bildschirmarbeit *)
    hilfestatus(hilfe);
    standardwert:=UpCase(standardwert);
    xo:=WhereX;
    yo:=WhereY;
    ao:=TextAttr;

    l:=Pos(^m^j,frage);
    if l=0 then
      begin
        f1:=frage;
        f2:='';
      end
    else
      begin
        f1:=Copy(frage,1,l-1);
        f2:=Copy(frage,l+2,255);
      end;

    l:=Max(Length(f1),Length(f2))+10;
    if f2='' then
      OcWin(l,3,0,fenster_farbe,'')
    else
      OcWin(l,4,0,fenster_farbe,'');

    zeile:=1;
    doppelleerzeichenerweiterung(f1,l-2);
    WriteXY(2,zeile,f1,fenster_farbe);
    Inc(zeile);

    if f2<>'' then
      begin
        doppelleerzeichenerweiterung(f2,l-2);
        WriteXY(2,zeile,f2,fenster_farbe);
        Inc(zeile);
      end;


    repeat
      frage3:='(';
      if standardwert in ['J','Y'] then
        frage3:=frage3+textz_ja_aktiv^
      else
        frage3:=frage3+textz_ja_normal^;
      frage3:=frage3+'/';
      if standardwert in ['N'] then
        frage3:=frage3+textz_nein_aktiv^
      else
        frage3:=frage3+textz_nein_normal^;
      frage3:=frage3+')';
      doppelleerzeichenerweiterung(frage3,l-2);
      HiLight(2,zeile,frage3,fenster_balken_farbe);


      t:=SysReadKey2;
      if t=^C then
        begin
          CWin;
          GotoXY(xo,yo);
          TextAttr:=ao;
          Abbruch_durch_den_Benutzer;
        end;

      if t=^M then
        t:=standardwert;

      case t of
        #$00,#$e0:
          case SysReadKey of
            #$4b,
            #$4d:
              if standardwert in [' ','n','N'] then
                standardwert:=UpCase(textz_j_zeichen^[1])
              else
                standardwert:='N';
          else
            SysBeepEx(100,1);
          end;
        'j','J','Y','y':
          begin
            ergebnis:=UpCase(textz_j_zeichen^[1]);
            Break;
          end;
        'n','N':
          begin
            ergebnis:='N';
            Break;
          end;
      else
        SysBeepEx(100,1);
      end;
    until false;

    hilfestatus('');

    CWin;
    GotoXY(xo,yo);
    TextAttr:=ao;

fertig:

    if UpCase(ergebnis) in ['J','Y'] then
      ergebnis:=UpCase(textz_j_zeichen^[1])
    else
      ergebnis:='N';

    ja_nein_frage:=ergebnis;
    schreibe_log(log_kommentar,ergebnis);
  end;

function eingabe(const frage:string;const standardwert:string;const maxl:word;
           const log_kommentar:string;const hilfe:string):string;
  var
    l                   :byte;
    xo,yo,ao            :byte;
    frage2              :string;
    zeile               :byte;
    tmp                 :string;
    sp                  :word;

  label
    fertig;

  begin

    (* aus Quelldatei lesen *)
    if lies_quelle(log_kommentar,tmp) then
      if Length(tmp)<=maxl then
        goto fertig;

    (* sonst Bildschirmarbeit *)
    hilfestatus(hilfe);
    xo:=WhereX;
    yo:=WhereY;
    ao:=TextAttr;

    l:=Max(Max(Length(frage)+1,Length(standardwert)+3),maxl);

    zeile:=3;
    if standardwert='' then
      Dec(zeile);
    OcWin(l+2,zeile+1,0,fenster_farbe,'');
    Inc(WindMax,$0100); (* eine Zeile mehr, damit keine hÑ·lichen Effekte auftreten *)

    frage2:=frage;
    doppelleerzeichenerweiterung(frage2,l);
    WriteXY(2,1,frage2,fenster_farbe);

    if standardwert<>'' then
      begin
        frage2:='['+standardwert+']';
        doppelleerzeichenerweiterung(frage2,l);
        WriteXY(2,2,frage2,fenster_farbe);
      end;


    sp:=(l-maxl) div 2+2;
    repeat
      frage2:='';
      leerzeichenerweiterung(frage2,l);
      WriteXY(2,zeile,frage2,fenster_farbe);
      frage2:='';
      leerzeichenerweiterung(frage2,maxl);
      WriteXY(sp,zeile,frage2,fenster_balken_farbe);
      GotoXY(sp,zeile);
      TextAttr:=fenster_balken_farbe;
      cursor_sichtbar;
      ReadLn(tmp);
      cursor_unsichtbar;
    until Length(tmp)<=maxl;

    CWin;
    GotoXY(xo,yo);
    TextAttr:=ao;
    hilfestatus('');

  fertig:

    if tmp='' then
      tmp:=standardwert;

    eingabe:=tmp;
    schreibe_log(log_kommentar,tmp);
  end;

procedure Befehlszeile;
  var
    xo,yo,ao            :byte;
    shell               :string;
  begin
    shell:=GetEnv('COMSPEC');
    xo:=WhereX;
    yo:=WhereY;
    ao:=TextAttr;
    OWin(1,1,spalten,zeilen,komandozeilen_farbe,shell);

    Window(1,1,spalten,zeilen);
    TextAttr:=komandozeilen_farbe;
    ClrScr;

    cursor_sichtbar;

    Exec(shell,'');

    cursor_unsichtbar;
    CWin;
    GotoXY(xo,yo);
    TextAttr:=ao;
  end;

procedure abbruch_oder_weiter(const frage,log_name,kurzmeldung:string;const standardwert:char);
  var
    l:auswahl_tabelle_typ;
  begin
    Write(kurzmeldung,' ');
    auswahlliste_neu(l,false);
    auswahlliste_eintrag(l,textz_Abbruch^,'A','A','');
    auswahlliste_eintrag(l,textz_Weiter^ ,UpCase(textz_Weiter^[1]),UpCase(textz_Weiter^[1]),'');
    if auswahlliste_anzeigen(l,standardwert,frage,log_name)='A' then
      Abbruch_durch_den_Benutzer;
    WriteLn(textz_Weiter^);
  end;

procedure antwort_ausschrift_gz(const zk:string);
  begin
    TextAttr:=antwort_farbe;
    Write(zk);
    TextAttr:=log_farbe;
  end;

procedure antwort_ausschrift(const zk:string);
  begin
    antwort_ausschrift_gz(zk);
    WriteLn;
  end;

procedure tasten_aufzeichnung(var tastendruecke_anzahl:byte;var tastendruecke:tasten8;const titel,log_kommentar,hilfe:string);
  var
    tmp                 :string;
    z                   :word;
    taste               :word;
    xo,yo,ao            :byte;
    l                   :word;

  label
    fertig;

  (*$IFDEF OS2*)
  (* VpSysOs2.pas *)
  function Invalid16Parm(const p: Pointer; const Length: Longint): Boolean;
  begin
    Invalid16Parm := (Longint(p) and $0000ffff) + Length >= $00010000;
  end;

  function Fix_64k(const _Memory: Pointer; const _Length: Longint): pointer;
  begin
    // Test if memory crosses segment boundary
    if Invalid16Parm(_Memory, _Length) then
      // It does: Choose address in next segment
      Fix_64k := Ptr((Ofs(_memory) and $ffff0000) + $00010000)
    else
      // It doesn't: return original pointer
      Fix_64k := _Memory;
  end;


  function lies_taste_smallword:smallword;
    var
      Key  : ^KbdKeyInfo;
      LKey : Array[1..2] of KbdKeyInfo;
    begin
      Key := Fix_64k(@LKey, SizeOf(Key^));
      KbdCharIn(Key^, io_Wait, 0);
      lies_taste_smallword:=Ord(Key^.chChar)+Key^.chScan shl 8;
    end;
  (*$ENDIF*)

  (*$IFDEF DPMI32*)
  function lies_taste_smallword:smallword;assembler;(*$FRAME-*)(*$USES NONE*)
    asm
      mov ah,$10
      int $16
    end;
  (*$ENDIF*)

  (*$IFNDEF VirtualPascal*)
  function lies_taste_smallword:smallword;assembler;
    asm
      mov ah,$10
      int $16
    end;
  (*$ENDIF*)

  function hex_zu_int(z:char):word;
    begin
      z:=UpCase(z);
      case z of
        '0'..'9':hex_zu_int:=Ord(z)-Ord('0');
        'A'..'F':hex_zu_int:=Ord(z)-Ord('A')+10
      else
                 hex_zu_int:=0;
      end;
    end;

  begin

    (* aus Quelldatei lesen *)
    if lies_quelle(log_kommentar,tmp) then
      begin
        tastendruecke_anzahl:=0;

        while (tmp<>'') and (tastendruecke_anzahl<High(tastendruecke)) do
          begin
            if tmp[1]='#' then
              begin
                taste:=hex_zu_int(tmp[2]) shl (3*4)
                      +hex_zu_int(tmp[3]) shl (2*4)
                      +hex_zu_int(tmp[4]) shl (1*4)
                      +hex_zu_int(tmp[5]) shl (0*4);
                Delete(tmp,1,5);
              end
            else
              begin
                taste:=Ord(tmp[1]);
                Delete(tmp,1,1);
              end;
            Inc(tastendruecke_anzahl);
            tastendruecke[tastendruecke_anzahl]:=taste
          end;

        goto fertig;
      end;


    (* sonst Bildschirmarbeit *)
    hilfestatus(hilfe);
    xo:=WhereX;
    yo:=WhereY;
    ao:=TextAttr;
    l:=Max(Length(titel),22);
    OcWin(l+2,3,0,fenster_farbe,titel);

    tastendruecke_anzahl:=0;
    while tastendruecke_anzahl<High(tastendruecke) do
      begin
        taste:=lies_taste_smallword;
        if taste=$0001 then
          Break; (* Alt-1 *)

        if Lo(taste) in [Ord(' ')..Ord('"'),Ord('$')..126] then (* ohne '#' *)
          Write(Chr(Lo(taste)))
        else
          Write('#',Int2Hex(taste,4));

        Inc(tastendruecke_anzahl);
        tastendruecke[tastendruecke_anzahl]:=taste;
      end;

    hilfestatus('');
    CWin;
    GotoXY(xo,yo);
    TextAttr:=ao;

  fertig:

    tmp:='';
    for z:=1 to tastendruecke_anzahl do
      tmp:=tmp+'#'+Int2Hex(tastendruecke[z],4);
    schreibe_log(log_kommentar,tmp);

  end;


type
  quell_inhalt=
    record
      stichwort         :string[30];
      gemerkt           :string[120];
    end;

const
  quelle_inhalt_anzahl  :word   =0;
  quelle_inhalt_lesepos :word   =1;

var
  quelle_inhalt_tabelle :array[1..200] of ^quell_inhalt;

procedure oeffne_quelle(const quellname:string);
  var
    qn                  :string;
  begin
    FillChar(quelle_inhalt_tabelle,SizeOf(quelle_inhalt_tabelle),0);

    qn:=quellname;
    gross(qn);
    if (qn='') or (qn='NUL') or (qn='CON') then
      Exit;

    Assign(quelldatei,quellname);
    (*$I-*)
    Reset(quelldatei);
    (*$I+*)
    quelldatei_offen:=(IOResult=0);

    if quelldatei_offen then
      WriteLn(textz_Verwende_Quelle__^,quellname,'"')
    else
      Exit;

    while (not Eof(quelldatei)) and (quelle_inhalt_anzahl<High(quelle_inhalt_tabelle)) do
      begin
        ReadLn(quelldatei,qn);
        if Pos('Æ',qn)<>1 then Continue;
        if Pos('Ø',qn)< 3 then Continue;
        Delete(qn,1,Length('Æ'));

        Inc(quelle_inhalt_anzahl);
        New(quelle_inhalt_tabelle[quelle_inhalt_anzahl]);
        with quelle_inhalt_tabelle[quelle_inhalt_anzahl]^ do
          begin
            stichwort:=Copy(qn,1,Pos('Ø',qn)-1);
            gemerkt  :=Copy(qn,Pos('Ø',qn)+1,255);
            while (gemerkt<>'') and (gemerkt[1] in [' ',#9]) do
              Delete(gemerkt,1,1);
            while (gemerkt<>'') and (gemerkt[Length(gemerkt)] in [' ',#9]) do
              Delete(gemerkt,1,1);
          end;
      end;

    Close(quelldatei);
  end;

procedure oeffne_log(const logname:string);
  var
    ln                  :string;
  begin
    ln:=logname;
    gross(ln);
    if (ln='') or (ln='NUL') or (ln='CON') then
      Exit;

    Assign(logdatei,logname);
    (*$I-*)
    Rewrite(logdatei);
    (*$I+*)
    logdatei_offen:=(IOResult=0);

    if logdatei_offen then
      WriteLn(textz_Verwende_Logdatei__^,logname,'"')
    else
      Exit;
  end;

procedure schliesse_quelle;
  var
    z:word;
  begin

    if quelldatei_offen then
      begin
        quelldatei_offen:=false;
        while quelle_inhalt_anzahl>0 do
          begin
            if Assigned(quelle_inhalt_tabelle[quelle_inhalt_anzahl]) then
              Dispose(quelle_inhalt_tabelle[quelle_inhalt_anzahl]);
            Dec(quelle_inhalt_anzahl);
          end;
      end;
  end;

procedure schliesse_log;
  begin
    if logdatei_offen then
      begin
        Close(logdatei);
        logdatei_offen:=false;
      end;
  end;

function lies_quelle(const stichwort:string;var gelesen:string):boolean;
  var
    z,ende              :word;
  begin
    lies_quelle:=false;
    if quelle_inhalt_lesepos<=quelle_inhalt_anzahl then
      begin
        if quelldatei_eintraege_uberspringen then
          ende:=quelle_inhalt_anzahl
        else
          ende:=quelle_inhalt_lesepos;

        for z:=quelle_inhalt_lesepos to ende do
          if quelle_inhalt_tabelle[z]^.stichwort=stichwort then
            begin
              lies_quelle:=true;
              quelle_inhalt_lesepos:=z;
              gelesen:=quelle_inhalt_tabelle[quelle_inhalt_lesepos]^.gemerkt;
              Inc(quelle_inhalt_lesepos);
              Break;
            end;
      end;
  end;

procedure uebergehe_quelle(const stichwort:string);
  begin
    if quelle_inhalt_lesepos<=quelle_inhalt_anzahl then
      if quelle_inhalt_tabelle[quelle_inhalt_lesepos]^.stichwort=stichwort then
        Inc(quelle_inhalt_lesepos);
  end;

procedure schreibe_log(const stichwort:string;const eintrag:string);
  var
    zeile:string;
  begin
    if logdatei_offen and (stichwort<>'') then
      begin
        zeile:='Æ'+stichwort+'Ø';
        leerzeichenerweiterung(zeile,30);
        zeile:=zeile+eintrag;
        WriteLn(logdatei,zeile);
        Flush(logdatei);
      end;
  end;

procedure schreibe_log_kommentar(const zeile:string);
  begin
    if logdatei_offen then
      if Pos('##',zeile)=1 then
        WriteLn(logdatei,'##',zeile)
      else
        WriteLn(logdatei,'# ',zeile);
  end;

end.

