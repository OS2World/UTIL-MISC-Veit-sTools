{&Use32+}
{$O+}
unit ntab;

interface


procedure lade_datei__cp_ntab;
procedure lade_speicher__cp_ntab(s0:pointer); (* nur zum Lesen *)
procedure schreibe_datei__cp_ntab;
procedure zk_vereinfachung(const zk1:string;var zk2:string);
procedure zuordung(const zeichensatz_name:string;const zeichensatz:word);
function  umwandlung(const zeichensatz_name:string):word;

implementation

uses
  Strings,
  WinDos,
  {$IfDef VirtualPascal}
  VpSysLow;
  {$Else}
  TPSysLow;
  {$EndIf}


const
  kopf_kennung          ='cp_ntab/V.K.'^Z^@;

type
  string13              =String[13];

  cp_namen_zuordnung    =
    packed record
      cp_nummer         :smallword;
      cp_name           :string13;
    end;

  cp_namen_zuordnung_tab        =array[1..1000] of cp_namen_zuordnung;

  cp_namen_zuordnung_tab_z      =^cp_namen_zuordnung_tab;

  cp_ntab_kopf_typ      =
    packed record
      kennung           :array[0..Length(kopf_kennung)-1] of char;
      anzahl            :smallword;
    end;

  cp_ntab_kopf_und_daten=
    packed record
      k                 :cp_ntab_kopf_typ;
      d                 :cp_namen_zuordnung_tab;
    end;

const

  cp_ntab_kopf          :cp_ntab_kopf_typ=
  (  kennung            :kopf_kennung;
      anzahl            :0);

  cp_z                  :cp_namen_zuordnung_tab_z=nil;


procedure lade_datei__cp_ntab;
  var
    d                   :file;
    dn                  :array[0..260] of Char;
    path                :PChar;
  begin
    path := GetEnvVar('PATH');
    if Assigned(path) then
      FileSearch(dn,'cp_ntab', path)
    else
      FileSearch(dn,'cp_ntab', '.' );

    if StrLen(dn)=0 then
      RunError(2);

    Assign(d,StrPas(dn));
    FileMode:=open_access_ReadOnly or open_share_DenyNone;
    Reset(d,1);

    BlockRead(d,cp_ntab_kopf,SizeOf(cp_ntab_kopf));
    if cp_ntab_kopf.kennung<>kopf_kennung then RunError(1);

    GetMem(cp_z,cp_ntab_kopf.anzahl*SizeOf(cp_namen_zuordnung));
    BlockRead(d,cp_z^,cp_ntab_kopf.anzahl*SizeOf(cp_namen_zuordnung));

    Close(d);
  end;

procedure lade_speicher__cp_ntab(s0:pointer);
  var
    s:^cp_ntab_kopf_und_daten absolute s0;
  begin

    with s^.k do
      begin
        if StrLComp(kennung,kopf_kennung,Length(kopf_kennung))<>0 then
          RunError(2);

        cp_ntab_kopf.anzahl:=anzahl;
      end;

    cp_z:=@s^.d;
  end;

procedure schreibe_datei__cp_ntab;
  var
    d:file;
  begin
    Assign(d,'cp_ntab');
    Rewrite(d,1);
    BlockWrite(d,cp_ntab_kopf,SizeOf(cp_ntab_kopf));
    BlockWrite(d,cp_z^,cp_ntab_kopf.anzahl*SizeOf(cp_namen_zuordnung));
    Close(d);

    cp_ntab_kopf.anzahl:=0;
    DisPose(cp_z);cp_z:=nil;
  end;

procedure zk_vereinfachung(const zk1:string;var zk2:string);
  var
    i:word;
  begin
    zk2:='';
    for i:=1 to Length(zk1) do
      if not (zk1[i] in [' ',#9,'-','/']) then
        zk2:=zk2+UpCase(zk1[i]);

    if Pos('CP'     ,zk2)=1 then Delete(zk2,1,Length('CP'     ));
    if Pos('IBM'    ,zk2)=1 then Delete(zk2,1,Length('IBM'    ));
    if Pos('WINDOWS',zk2)=1 then Delete(zk2,1,Length('WINDOWS'));

  end;

procedure zuordung(const zeichensatz_name:string;const zeichensatz:word);
  var
    i                   :word;
    zeichensatz_name2   :string;
    {$IfNDef VirtualPascal}
    temp                :cp_namen_zuordnung_tab_z;
    {$EndIf}
  begin
    zk_vereinfachung(zeichensatz_name,zeichensatz_name2);
    for i:=1 to cp_ntab_kopf.anzahl do
      with cp_z^[i] do
        if zeichensatz_name2=cp_name then
          begin
            cp_nummer:=zeichensatz;
            Exit;
          end;


    Inc(cp_ntab_kopf.anzahl);
    {$IfDef VirtualPascal}
    ReallocMem(cp_z,cp_ntab_kopf.anzahl*SizeOf(cp_namen_zuordnung));
    {$Else}
    GetMem(temp,cp_ntab_kopf.anzahl*SizeOf(cp_namen_zuordnung));
    Move(cp_z^,temp^,Pred(cp_ntab_kopf.anzahl)*SizeOf(cp_namen_zuordnung));
    Dispose(cp_z);
    cp_z:=temp;
    {$EndIf}
    with cp_z^[cp_ntab_kopf.anzahl] do
      begin
        cp_nummer:=zeichensatz;
        if Length(zeichensatz_name2)>High(cp_name) then RunError(8);
        cp_name:=zeichensatz_name2;

        for i:=Length(cp_name)+1 to High(cp_name) do
          cp_name[i]:=#0;
      end;
  end;


function  umwandlung(const zeichensatz_name:string):word;
  var
    i:word;
    zeichensatz_name2:string;
    kontrolle:integer;
  begin
    zk_vereinfachung(zeichensatz_name,zeichensatz_name2);

    Val(zeichensatz_name2,i,kontrolle);
    if kontrolle=0 then
      umwandlung:=i
    else
      begin
        for i:=1 to cp_ntab_kopf.anzahl do
          with cp_z^[i] do
            if zeichensatz_name2=cp_name then
              begin
                umwandlung:=cp_nummer;
                Exit;
              end;

      umwandlung:=0;
    end;
  end;


end.

