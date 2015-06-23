{&Use32+}
{$O+}
unit ztab;


interface

type
  {$IfNDef VirtualPascal}
  smallword             =word;
  {$EndIf}
  zeichensatz8_zu_uc_tabelle=array[char] of smallword;

  uc_zu_zeichensatz8_tabelle=
    packed record
      anzahl_folgen     :smallword;
      fragezeichen      :char;
      folgen            :array[1..256] of
        packed record
          unicode_z     :smallword;
          nachfolge     :byte;
        end;
    end;

  z_uc_zu_zeichensatz8_tabelle=^uc_zu_zeichensatz8_tabelle;

procedure erzeuge_zeichensatz8_zu_uc_tabelle(const quelle:uc_zu_zeichensatz8_tabelle;var ziel:zeichensatz8_zu_uc_tabelle);
procedure erzeuge_uc_zu_zeichensatz8_tabelle(var   quelle:zeichensatz8_zu_uc_tabelle;var ziel:uc_zu_zeichensatz8_tabelle);
procedure merke_paket(const zeichensatznummer:word;const zeichensatz:uc_zu_zeichensatz8_tabelle);
procedure speichere_pakete;
procedure lade_pakete;
procedure lade_pakete_aus_dem_speicher(k0:pointer);
function  suche_zeichensatz(n:word):z_uc_zu_zeichensatz8_tabelle;


implementation

uses
  {$IfDef VirtualPascal}
  VpSysLow,
  {$Else}
  TPSysLow,
  {$EndIf}
  Strings;

type
  smallword_z   ={$IfDef VirtualPascal}^smallword{$Else}^word{$EndIf};

procedure erzeuge_zeichensatz8_zu_uc_tabelle(const quelle:uc_zu_zeichensatz8_tabelle;var ziel:zeichensatz8_zu_uc_tabelle);
  var
    z1,z2:word;
    n:char;
  begin
    with quelle do
      begin
        n:=#0;

        for z1:=1 to anzahl_folgen do
          with folgen[z1] do
            if unicode_z>=$fff0 then
              begin
                for z2:=nachfolge downto 0 do
                  begin
                    ziel[n]:=$ffff;
                    Inc(n);
                  end;
              end
            else
              begin
                ziel[n]:=unicode_z;
                Inc(n);
                for z2:=nachfolge downto 1 do
                  begin
                    ziel[n]:=ziel[Pred(n)]+1;
                    Inc(n);
                  end;
              end;
      end;
  end;

procedure erzeuge_uc_zu_zeichensatz8_tabelle(var quelle:zeichensatz8_zu_uc_tabelle;var ziel:uc_zu_zeichensatz8_tabelle);
  var
    z           :char;
  begin

    for z:=Low(z) to High(z) do
      if quelle[z]>=$fff0 then
        quelle[z]:=$ffff;

    with ziel do
      begin
        anzahl_folgen:=0;
        fragezeichen:='?';
        for z:=Low(z) to High(z) do
          if quelle[z]=Ord('?') then
            begin
              fragezeichen:=z;
              Break;
            end;

        z:=#0;
        repeat

          Inc(anzahl_folgen);

          with folgen[anzahl_folgen] do

            if quelle[z]=$ffff then
              begin
                unicode_z:=quelle[z];
                nachfolge:=0;
                Inc(z);
                while (z<>#0) and (quelle[z]=$ffff) do
                  begin
                    Inc(nachfolge);
                    Inc(z);
                  end;
              end

            else

              begin
                unicode_z:=quelle[z];
                nachfolge:=0;
                Inc(z);
                while (z<>#0) and (quelle[Pred(z)]+1=quelle[z]) do
                  begin
                    Inc(nachfolge);
                    Inc(z);
                  end;
              end;

        until z=#0;
      end; (* with ziel *)
  end;

type
  zeichensatz_information=
    packed record
      seite             :smallword;
      laenge            :smallword;
      case integer of
        0:(zeiger       :z_uc_zu_zeichensatz8_tabelle;);
        1:(zeiger_dp    :longint;);
    end;

  zeichensatz_information_tabelle_typ=
    packed array[1..1000] of zeichensatz_information;

  zeichensatz_information_tabelle_z_typ=
    ^zeichensatz_information_tabelle_typ;

const
  zst_kennung           ='ZST_TAB/V.K.'^Z^@;

const
  anzahl_zeichensaetze  :smallword=0;
  zst                   :zeichensatz_information_tabelle_z_typ=nil;

procedure merke_paket(const zeichensatznummer:word;const zeichensatz:uc_zu_zeichensatz8_tabelle);
  {$IfNDef VirtualPascal}
  var
    temp                 :zeichensatz_information_tabelle_z_typ;
  {$EndIf}
  begin
    Inc(anzahl_zeichensaetze);
    {$IfDef VirtualPascal}
    ReallocMem(zst,anzahl_zeichensaetze*SizeOf(zst^[1]));
    {$Else}
    GetMem(temp,anzahl_zeichensaetze*SizeOf(zst^[1]));
    Move(zst^,temp^,Pred(anzahl_zeichensaetze)*SizeOf(zst^[1]));
    Dispose(zst);
    zst:=temp;
    {$EndIf}
    with zst^[anzahl_zeichensaetze] do
      begin
        seite:=zeichensatznummer;
        with zeichensatz do
          laenge:=SizeOf(zeichensatz)-SizeOf(folgen)+anzahl_folgen*SizeOf(folgen[1]);
        GetMem(zeiger,laenge);
        Move(zeichensatz,zeiger^,laenge);
      end;
  end;

procedure speichere_pakete;
  var
    zst_kopie           :^zeichensatz_information_tabelle_typ;
    zeiger_laenge       :longint;
    datei_position      :longint;
    i                   :word;
    d                   :file;

    kennung             :array[0..Length(zst_kennung)-1] of char;

  begin
    Assign(d,'ZTAB');
    Rewrite(d,1);
    kennung:=zst_kennung;
    BlockWrite(d,kennung,SizeOf(kennung));
    BlockWrite(d,anzahl_zeichensaetze,SizeOf(anzahl_zeichensaetze));
    zeiger_laenge:=anzahl_zeichensaetze*SizeOf(zst^[1]);
    datei_position:=SizeOf(kennung)+SizeOf(anzahl_zeichensaetze)+zeiger_laenge;
    GetMem(zst_kopie,zeiger_laenge);
    Move(zst^,zst_kopie^,zeiger_laenge);

    for i:=1 to anzahl_zeichensaetze do
      with zst_kopie^[i] do
        begin
          zeiger_dp:=datei_position;
          Inc(datei_position,laenge);
        end;

    BlockWrite(d,zst_kopie^,zeiger_laenge);
    Dispose(zst_kopie);

    for i:=1 to anzahl_zeichensaetze do
      with zst^[i] do
        begin
          BlockWrite(d,zeiger^,laenge);
          Dispose(zeiger);
        end;

    Dispose(zst);
    Close(d);

  end;

procedure lade_pakete;
  var
    d           :file;
    kopf        :array[0..Length(zst_kennung)-1] of char;
    z           :word;
  begin
    Assign(d,'ZTAB');
    Reset(d,1);
    BlockRead(d,kopf,SizeOf(kopf));
    if StrLComp(kopf,zst_kennung,Length(zst_kennung))<>0 then
      RunError(0);
    BlockRead(d,anzahl_zeichensaetze,SizeOf(anzahl_zeichensaetze));
    GetMem(zst,SizeOf(zst^[1])*anzahl_zeichensaetze);
    BlockRead(d,zst^,SizeOf(zst^[1])*anzahl_zeichensaetze);

    for z:=1 to anzahl_zeichensaetze do
      with zst^[z] do
        begin
          Seek(d,Longint(zeiger));
          GetMem(zeiger,laenge);
          BlockRead(d,zeiger^,laenge);
        end;
  end;

procedure lade_pakete_aus_dem_speicher(k0:pointer);
  var
    z:word;
  begin
    if StrLComp(k0,zst_kennung,Length(zst_kennung))<>0 then
      RunError(0);
    Inc(longint(k0),Length(zst_kennung));
    anzahl_zeichensaetze:=smallword_z(k0)^;
    Inc(longint(k0),SizeOf(anzahl_zeichensaetze));
    GetMem(zst,SizeOf(zst^[1])*anzahl_zeichensaetze);
    Move(k0^,zst^,SizeOf(zst^[1])*anzahl_zeichensaetze);
    Inc(longint(k0),SizeOf(zst^[1])*anzahl_zeichensaetze);

    for z:=1 to anzahl_zeichensaetze do
      with zst^[z] do
        begin
          zeiger:=k0;
          Inc(longint(k0),laenge);
        end;

  end;

function  suche_zeichensatz(n:word):z_uc_zu_zeichensatz8_tabelle;
  var
    z:word;
  begin
    if n=0 then
      n:=SysGetCodePage;

    for z:=1 to anzahl_zeichensaetze do
      with zst^[z] do
        if seite=n then
          begin
            suche_zeichensatz:=zeiger;
            Exit;
          end;

    if n=1 then RunError(0);

    suche_zeichensatz:=suche_zeichensatz(1);
  end;


end.

