(*$I TYP_COMP.PAS*)
unit typ_erw;

interface

(*type
  erweiterungs_bereiche=(...)*)

uses
  typ_type;

procedure lade_erweiterungsdaten;
procedure suche_erweiterungen(const p:puffertyp);
procedure suche_erweiterungen2(const p:puffertyp);
procedure einrichten_typ_erw(const anfang:boolean);

implementation

uses
  typ_var,
  typ_varx,
  typ_eiau,
  typ_ausg;

type
  eintrag_z_typ         =^eintrag_typ;
  eintrag_typ=
    record
      naechster         :eintrag_z_typ;
      sig_z             :^string;
      titel_z           :^string;
      attr              :aus_attribute;
    end;


var
  anker                 :array[0..255] of eintrag_z_typ;

const
  speicher_angefordert  :boolean=false;


procedure lade_erweiterungsdaten;
  var
    erw_datei           :text;
    erw_dateiname       :string;
    zeile               :string;
    zeile_pos           :word_norm;

  procedure abbruch_erwartet(const erwartet:string);
    var
      hinweis:string;
    begin
      hinweis:='TYP.ERW parse error! (excpected: '+erwartet+')'#13#10
              +'line: >>'+zeile+'<<'#13#10;
      leerzeichenerweiterung(hinweis,length(hinweis)+length('line: >>')+zeile_pos-1);
      hinweis:=hinweis+'^';
      abbruch(hinweis,abbruch_unerwartete_erscheinung);
    end;

  procedure lies_zk(var s:string);
    type
      lies_zk_modus_typ=(modus_normal,
                         modus_doppelkreuz,
                         modus_doppelkreuz_zahl,
                         modus_doppelkreuz_dollar,
                         modus_doppelkreuz_dollar_zahl,
                         modus_zeichnkette);
    var
      lies_zk_modus     :lies_zk_modus_typ;
      zahl              :word_norm;
    begin
      lies_zk_modus:=modus_normal;
      s:='';
      repeat
        if zeile_pos>Length(zeile) then
          abbruch('TYP.ERW parse error! (unexpected end of line)'#13#10
                 +'line: >'+zeile+'<',abbruch_unerwartete_erscheinung);


        case lies_zk_modus of
          modus_normal:
            case zeile[zeile_pos] of
              ' ',#9:
                Inc(zeile_pos);

              #39:
                begin
                  lies_zk_modus:=modus_zeichnkette;
                  Inc(zeile_pos);
                end;

              '#':
                begin
                  lies_zk_modus:=modus_doppelkreuz;
                  Inc(zeile_pos);
                end;

              ',':
                begin
                  Inc(zeile_pos);
                  Exit;
                end;
            else
              abbruch_erwartet(#39' #');
            end;

          modus_doppelkreuz:
            case zeile[zeile_pos] of
              '0'..'9':
                begin
                  zahl:=0;
                  lies_zk_modus:=modus_doppelkreuz_zahl;
                end;
              '$':
                begin
                  Inc(zeile_pos);
                  lies_zk_modus:=modus_doppelkreuz_dollar;
                end;
            else
              abbruch_erwartet('0..9 $');
            end;

          modus_doppelkreuz_zahl:
            case zeile[zeile_pos] of
              '0'..'9':
                begin
                  zahl:=zahl*10+Ord(zeile[zeile_pos])-Ord('0');
                  Inc(zeile_pos);
                end;
            else
              if Length(s)<255 then
                begin
                  Inc(s[0]);
                  s[Length(s)]:=Chr(zahl);
                end;
              lies_zk_modus:=modus_normal;
            end;

          modus_doppelkreuz_dollar:
            case zeile[zeile_pos] of
              '0'..'9','A'..'F','a'..'f':
                begin
                  zahl:=0;
                  lies_zk_modus:=modus_doppelkreuz_dollar_zahl;
                end;
            else
              abbruch_erwartet('0..9 A..F');
            end;

          modus_doppelkreuz_dollar_zahl:
            case zeile[zeile_pos] of
              '0'..'9':
                begin
                  zahl:=zahl*16+Ord(zeile[zeile_pos])-Ord('0');
                  Inc(zeile_pos);
                end;
              'A'..'F':
                begin
                  zahl:=zahl*16+Ord(zeile[zeile_pos])-Ord('A')+10;
                  Inc(zeile_pos);
                end;
              'a'..'f':
                begin
                  zahl:=zahl*16+Ord(zeile[zeile_pos])-Ord('a')+10;
                  Inc(zeile_pos);
                end;
            else
              if Length(s)<255 then
                begin
                  Inc(s[0]);
                  s[Length(s)]:=Chr(zahl);
                end;
              lies_zk_modus:=modus_normal;
            end;

          modus_zeichnkette:
            case zeile[zeile_pos] of
              #39:
                begin
                  Inc(zeile_pos);
                  lies_zk_modus:=modus_normal;
                end;
            else
              if Length(s)<255 then
                begin
                  Inc(s[0]);
                  s[Length(s)]:=zeile[zeile_pos];
                end;
              Inc(zeile_pos);
            end;
        end;

      until false;
    end; (* lies_zk *)

  procedure lies_attr(var attr:aus_attribute);
    var
      zahl              :longint;

    begin
      zahl:=0;
      repeat
        if zeile_pos>Length(zeile) then
          begin
{          abbruch('TYP.ERW parse error! (unexpected end of line)'#13#10
                 +'line: >'+zeile+'<',abbruch_unerwartete_erscheinung);}
            attr:=aus_attribute(zahl mod Ord(High(aus_attribute)));
            Exit;
          end;


        case zeile[zeile_pos] of
          ' ',#9:
            Inc(zeile_pos);
          '0'..'9':
            begin
              zahl:=zahl*10+Ord(zeile[zeile_pos])-Ord('0');
              Inc(zeile_pos);
            end;
          ',':
            begin
              attr:=aus_attribute(zahl mod Ord(High(aus_attribute)));
              Inc(zeile_pos);
              Exit;
            end;
        else
          abbruch_erwartet('0..9');
        end;
      until false;
    end; (* lies_attr *)

  var
    sig                 :string;
    titel               :string;
    attr                :aus_attribute;
    arbeit              :^eintrag_z_typ;
    laenge              :longint;
    posi                :longint;

  begin
    FillCHar(anker,SizeOf(anker),0); (* nil *)
    speicher_angefordert:=true;

    erw_dateiname:=ParamStr(0);
    if (Pos('\',erw_dateiname) or Pos('/',erw_dateiname))=0 then
      erw_dateiname:=''
    else
      while not (erw_dateiname[Length(erw_dateiname)] in ['\','/']) do
        DecLength(erw_dateiname);
    erw_dateiname:=erw_dateiname+'TYP.ERW';

    FileMode:=$40;
    Assign(erw_datei,erw_dateiname);
    (*$I-*)
    Reset(erw_datei);
    (*$I+*)

    (*$IfNDef ENDVERSION*)
    if IOResult<>0 then
      begin
        Assign(erw_datei,'C:\SONST\TYP.ERW');
        (*$I-*)
        Reset(erw_datei);
        (*$I+*)
      end;
    (*$EndIf*)

    if IOResult<>0 then
      Exit;


    while not Eof(erw_datei) do
      begin
        ReadLn(erw_datei,zeile);
        if (zeile='')
        or (zeile[1] in ['%',';'])
         then
          Continue;

        zeile_pos:=1;
        lies_zk(sig);
        lies_zk(titel);
        lies_attr(attr);

        if (sig='') or (titel='') then
          abbruch('TYP.ERW parse error! (empty signature)'#13#10
                 +'line: >'+zeile+'<',abbruch_unerwartete_erscheinung);

        arbeit:=Addr(anker[Ord(sig[1])]);
        while arbeit^<>nil do
          (*arbeit:=@arbeit^^.naechster;*)
          arbeit:=Addr(arbeit^^.naechster);

        laenge:=SizeOf(eintrag_typ)+Length(sig)+1+Length(titel)+1;
        GetMem(arbeit^,laenge);
        FillChar(arbeit^^,laenge,0);
        posi:=Ofs(arbeit^^);
        Inc(posi,SizeOf(eintrag_typ));

        arbeit^^.sig_z:=Ptr(posi);
        Move(sig,arbeit^^.sig_z^,Length(sig)+1);
        Inc(posi,Length(sig)+1);

        arbeit^^.titel_z:=Ptr(posi);
        Move(titel,arbeit^^.titel_z^,Length(titel)+1);

        arbeit^^.attr:=attr;
      end;
    Close(erw_datei);
  end;

procedure suche_erweiterungen(const p:puffertyp);

  procedure verfolge(const arbeit:eintrag_z_typ;const p_d);
    begin
      if arbeit<>nil then
        begin
          if bytesuche(p_d,arbeit^.sig_z^) then
            ausschrift(arbeit^.titel_z^,arbeit^.attr);
          verfolge(arbeit^.naechster,p_d);
        end;
    end;

  begin
    verfolge(anker[p.d[0]],p.d);
    if Ord(p.d[0])<>Ord('?') then
      verfolge(anker[Ord('?')],p.d);

  end;

procedure suche_erweiterungen2(const p:puffertyp);

  function verfolge(const arbeit:eintrag_z_typ;const p:puffertyp):boolean;
    begin
      if arbeit<>nil then
        begin
          if puffer_pos_suche(p,arbeit^.sig_z^,512)<>nicht_gefunden then
            begin
              ausschrift(arbeit^.titel_z^,arbeit^.attr);
              verfolge:=true;
            end
          else
            verfolge:=verfolge(arbeit^.naechster,p);
        end;
    end;

  begin
    if not verfolge(anker[p.d[0]],p) then
      if Ord(p.d[0])<>Ord('?') then
        verfolge(anker[Ord('?')],p);

  end;

(*$IfDef SPEICHER_FREIGEBEN*)

procedure erw_speicher_freigeben;
  var
    z                   :word_norm;
    a,b                 :eintrag_z_typ;
  begin
    for z:=Low(anker) to High(anker) do
      begin
        a:=anker[z];
        anker[z]:=nil;
        while Assigned(a) do
          begin
            b:=a;
            a:=a.naechster;
            Dispose(b);
          end;
      end;
  end;
(*$EndIf*)

procedure einrichten_typ_erw(const anfang:boolean);
  begin
    (*$IfDef SPEICHER_FREIGEBEN*)
    if anfang then

    else
      if speicher_angefordert then
        erw_speicher_freigeben;
    (*$EndIf*)
  end;


(*$IfDef SPEICHER_FREIGEBEN*)
initialization
  einrichten_typ_erw(true);
finalization
  einrichten_typ_erw(false);
(*$EndIf*)
end.

