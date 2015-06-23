{&Use32+,H-}
{$O+}
unit zst;

interface


uses
  unidef,
  {$IfDef UNIAPI}
  UniAPi;
  {$Else}
  ztab,
  ntab;
  {$EndIf}


type
  zeichensatzumformung_8_8      =array[char] of char;
  zeichensatzumformung_16_8     =z_uc_zu_zeichensatz8_tabelle;
  zeichensatzumformung_8_16     =zeichensatz8_zu_uc_tabelle;


procedure berechne_zs_nummer(s:string;var n:word);

procedure berechne_umrechnungstabelle_8_8 (const von,nach:word;var t:zeichensatzumformung_8_8 );
procedure berechne_umrechnungstabelle_16_8(const nach    :word;var t:zeichensatzumformung_16_8);
procedure berechne_umrechnungstabelle_8_16(const von     :word;var t:zeichensatzumformung_8_16);

procedure umformung_8_8   (const q:string;var z:string;const t:zeichensatzumformung_8_8 );
procedure umformung_16_8  (const q:UniCharArray;var z:string;const t:zeichensatzumformung_16_8);
procedure umformung_16l_8 (const q:UniCharArray;var z:string;const t:zeichensatzumformung_16_8;maxl:word);
procedure umformung_8_16  (const q:string;var z:UniCharArray;const t:zeichensatzumformung_8_16);
{$IfDef VirtualPascal}
procedure umformung_8a_8a (const q:Ansistring;var z:Ansistring;const t:zeichensatzumformung_8_8 );
procedure umformung_16_8a (const q:UniCharArray;var z:Ansistring;const t:zeichensatzumformung_16_8);
procedure umformung_16l_8a(const q:UniCharArray;var z:Ansistring;const t:zeichensatzumformung_16_8;maxl:word);
procedure umformung_8a_16 (const q:Ansistring;var z:UniCharArray;const t:zeichensatzumformung_8_16);
{$EndIf VirtualPascal}

procedure freigeben_umrechnungstabelle_8_8 (var t:zeichensatzumformung_8_8 );
procedure freigeben_umrechnungstabelle_16_8(var t:zeichensatzumformung_16_8);
procedure freigeben_umrechnungstabelle_8_16(var t:zeichensatzumformung_8_16);

implementation

procedure berechne_zs_nummer(s:string;var n:word);
  var
    s1          :string;
  begin
    zk_vereinfachung(s,s1);
    n:=umwandlung(s1);
  end;

procedure berechne_umrechnungstabelle_8_8 (const von,nach:word;var t:zeichensatzumformung_8_8 );
  var
    t_von,
    t_nach      :z_uc_zu_zeichensatz8_tabelle;
    t16_von,
    t16_nach    :zeichensatz8_zu_uc_tabelle;
    c,c2        :char;
  begin
    if t_von=t_nach then
      for c:=Low(c) to High(c) do
        t[c]:=c;

    t_von:=suche_zeichensatz(von);
    t_nach:=suche_zeichensatz(nach);
    erzeuge_zeichensatz8_zu_uc_tabelle(t_von^,t16_von);
    erzeuge_zeichensatz8_zu_uc_tabelle(t_nach^,t16_nach);

    for c:=Low(c) to High(c) do
      if t16_von[c]=$ffff then
        t[c]:=t_nach^.fragezeichen
      else
      if t16_von[c]=t16_nach[c] then
        t[c]:=c
      else
        begin
          t[c]:=t_nach^.fragezeichen;
          for c2:=Low(c2) to High(c2) do
            if t16_von[c]=t16_nach[c2] then
              begin
                t[c]:=c2;
              end;
        end;
  end;

procedure berechne_umrechnungstabelle_16_8(const nach    :word;var t:zeichensatzumformung_16_8);
  begin
    t:=suche_zeichensatz(nach);
  end;

procedure berechne_umrechnungstabelle_8_16(const von     :word;var t:zeichensatzumformung_8_16);
  var
    t_von       :z_uc_zu_zeichensatz8_tabelle;
  begin
    t_von:=suche_zeichensatz(von);
    erzeuge_zeichensatz8_zu_uc_tabelle(t_von^,t);
  end;


procedure umformung_8_8 (const q:string;var z:string;const t:zeichensatzumformung_8_8 );
{$IfDef VirtualPascal}
  assembler;
  {$Frame-}
  {$Uses esi,edi,ebx}
  asm
    mov esi,q
    mov edi,z
    mov ebx,t
    cld
    lodsb
    stosb
    movzx ecx,al
    jecxz @ret
  @sl:
    lodsb
    xlat
    stosb
    loop @sl
  @ret:
  end;
{$Else}
  var
    i           :word;
  begin
    z:=q;
    for i:=1 to Length(z) do
      z[i]:=t[z[i]];
  end;
{$EndIf}

procedure umformung_16_8(const q:UniCharArray;var z:string;const t:zeichensatzumformung_16_8);
  begin
    umformung_16l_8(q,z,t,High(z));
  end;

procedure umformung_16l_8(const q:UniCharArray;var z:string;const t:zeichensatzumformung_16_8;maxl:word);
  var
    q1          :^UniChar;
    i           :word;
    c           :char;
  begin
    q1:=@q;
    z:='';
    with t^ do
      while (maxl>0) and (q1^<>0) do
        begin
          Dec(maxl);
          {$IfDef VirtualPascal}
          SetLength(z,Length(z)+1);
          {$Else}
          Inc(z[0]);
          {$EndIf}
          z[Length(z)]:=fragezeichen;
          i:=1;
          c:=#0;
          while i<=anzahl_folgen do
            with folgen[i] do
              begin

                if (unicode_z<=q1^) and (q1^<=unicode_z+nachfolge+1) then
                  begin
                    z[Length(z)]:=Chr(Ord(c)+q1^-unicode_z);
                    Break;
                  end;

                Inc(c,1+nachfolge);
                Inc(i);

              end; (* folge[i] *)

          Inc(q1);

        end; (* q1^<>0 *)


  end;

procedure umformung_8_16(const q:string;var z:UniCharArray;const t:zeichensatzumformung_8_16);
{$IfDef VirtualPascal}
  assembler;
  {$Frame-}
  {$Uses esi,edi,edx,ecx}
  asm
    mov esi,q
    mov edi,z
    mov edx,t
    cld
    lodsb
    movzx ecx,al
    jecxz @ret
  @sl:
    sub eax,eax
    lodsb
    add eax,eax
    mov ax,[edx+eax]
    stosw
    loop @sl
  @ret:
    sub eax,eax
    stosw
  end;
{$Else}
  var
    zi          :^UniChar;
    i           :word;
  begin
    zi:=Pointer(@z);
    for i:=1 to Length(q) do
      begin
        zi^:=t[q[i]];
        Inc(zi);
      end;
  end;
{$EndIf}

{$IfDef VirtualPascal}
procedure umformung_8a_8a (const q:Ansistring;var z:Ansistring;const t:zeichensatzumformung_8_8 );
  var
    i           :word;
  begin
    z:=q;
    for i:=1 to Length(z) do
      z[i]:=t[z[i]];
  end;

procedure umformung_16_8a (const q:UniCharArray;var z:Ansistring;const t:zeichensatzumformung_16_8);
  begin
    umformung_16l_8a(q,z,t,High(Longint));
  end;

procedure umformung_16l_8a(const q:UniCharArray;var z:Ansistring;const t:zeichensatzumformung_16_8;maxl:word);
  var
    q1          :^UniChar;
    i           :word;
    c           :char;
  begin
    q1:=@q;
    z:='';
    with t^ do
      while (maxl>0) and (q1^<>0) do
        begin
          Dec(maxl);
          {$IfDef VirtualPascal}
          SetLength(z,Length(z)+1);
          {$Else}
          Inc(z[0]);
          {$EndIf}
          z[Length(z)]:=fragezeichen;
          i:=1;
          c:=#0;
          while i<=anzahl_folgen do
            with folgen[i] do
              begin

                if (unicode_z<=q1^) and (q1^<=unicode_z+nachfolge+1) then
                  begin
                    z[Length(z)]:=Chr(Ord(c)+q1^-unicode_z);
                    Break;
                  end;

                Inc(c,1+nachfolge);
                Inc(i);

              end; (* folge[i] *)

          Inc(q1);

        end; (* q1^<>0 *)


  end;

procedure umformung_8a_16 (const q:Ansistring;var z:UniCharArray;const t:zeichensatzumformung_8_16);
  var
    zi          :^UniChar;
    i           :word;
  begin
    zi:=Pointer(@z);
    for i:=1 to Length(q) do
      begin
        zi^:=t[q[i]];
        Inc(zi);
      end;
  end;

{$EndIf VirtualPascal}


procedure freigeben_umrechnungstabelle_8_8 (var t:zeichensatzumformung_8_8 );
  begin
  end;

procedure freigeben_umrechnungstabelle_16_8(var t:zeichensatzumformung_16_8);
  begin
    t:=nil;
  end;

procedure freigeben_umrechnungstabelle_8_16(var t:zeichensatzumformung_8_16);
  begin
  end;

end.

