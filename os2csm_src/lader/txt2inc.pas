{&Use32+}
program tastatur_txt_zu_inc;

uses
  VpUtils;

type
  maptable              =array[byte] of char;
  maptable5             =array[1..5] of maptable;

const
  scancode:array[1..13+12+12+11] of byte=
    // ¯   1   2   3   4   5   6   7   8   9   0   ·   Ô
    ($29,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,
    // q   w   e   r   t   z   u   i   o   p   Å   +
     $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,
    // a   s   d   f   g   h   j   k   l   î   Ñ   #
     $1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$2b,
    // <   y   x   c   v   b   n   m   ,   .   -
     $56,$2c,$2d,$2e,$2f,$30,$31,$32,$33,$34,$35);

  // numeric pad:               scancode
  //  Num  /    *    -          45-FA/FA-C5 E0-35/E0-B5 37/B7 4A/CA
  //  7    8    9               47/C7       48/C8       49/C9
  //  4    5    6    +          4B/CB       4C/CC       4D/CD 4E/CE
  //  1    2    3               4F/CF       50/D0       51/D1
  //  0         ,    CR         52/D2                   53/D3 E0-1C/E0-9C
  //
  // difference to original: ',' instead of '.'
  //   implemented in fixed code
  // problem: 35 is mapped differntly on main area (-) and keypad(/)
  //   soultion: do not remap any extended (E0-XX) key

procedure lies_scancode(var t:maptable5;const dateiname:string);
  var
    datei               :text;

  procedure lies_r4(var t:maptable);

    procedure lies(i0,l:word);
      var
        zeile           :string;
        i               :word;
      begin
        ReadLn(datei,zeile);
        if Length(zeile)<>l then
          RunError(9990);
        for i:=1 to l do
          t[scancode[i0+i-1]]:=zeile[i];
      end; (* lies *)

    begin
      FillChar(t,SizeOf(t),0);
      lies(1         ,13);
      lies(1+13      ,12);
      lies(1+13+12   ,12);
      lies(1+13+12+12,11);
    end; (* lies_r4 *)

  var
    i                   :word;
  begin
    Assign(datei,dateiname);
    Reset(datei);
    lies_r4(t[1]); (* lower *)
    lies_r4(t[2]); (* Shift *)
    lies_r4(t[3]); (* AltGr *)
    for i:=Low(t[3]) to High(t[3]) do
      if t[3][i]='.' then
        t[3][i]:=#0;
    (* Alt: special for A..Z (char=#0,scan=swapped *)
    FillChar(t[4],SizeOf(t[4]),0);
    (* Ctrl *)
    FillChar(t[5],SizeOf(t[5]),#0);
    for i:=Low(t[5]) to High(t[5]) do
      if UpCase(t[1][i]) in ['A'..'Z'] then
        t[5][i]:=Chr(Ord(UpCase(t[1][i]))-Ord('A')+Ord(^A));
    Close(datei);
  end; (* lies_scancode *)


procedure erzeuge_tabellen(const m5_bios,m5_nls:maptable5;const dateiname,languagedescription:string);
  var
    datei               :text;
    remap_scan          :array[byte] of byte;

  procedure erzeuge_tabelle(const m_bios,m_nls:maptable;const id:string);
    var
      remapped          :maptable;
      must_define       :array[byte] of boolean;
      i1,i2             :word;
      i                 :word;

    function asc_asm(const a:char):string;
      begin
        if a in [#$00..#$1f,''''] then
          Result:='0'+Int2Hex(Ord(a),2)+'h'
        else
          Result:=''''+a+'''';
      end;

    begin
      FillChar(must_define,SizeOf(must_define),false);
      remapped:=m_nls;

      for i:=Low(remap_scan) to High(remap_scan) do
        if remap_scan[i]<>i then
          begin
            remapped[i]:=m_nls[remap_scan[i]];
            must_define[i]:=true;
          end;

      for i:=Low(remapped) to High(remapped) do
        if remapped[i]<>m_bios[i] then
          must_define[i]:=true;

      WriteLn(datei,'keytable_',id,':');
      (*$IfDef BLOCK_KEY_TABLE*)
      i1:=Low(remapped);
      while i1<=High(remapped) do
        begin
          if not must_define[i1] then
            begin
              Inc(i1);
              Continue;
            end;
          i2:=i1;
          while true do
            begin
              if i2+1>High(remapped) then
                Break;
              if must_define[i2+1] then
                begin
                  Inc(i2);
                  Continue;
                end;
              if t1[i2+1]=#0 then Break; //<<??
              if i2+2>High(remapped) then
                Break;
              if must_define[i2+2] then
                begin
                  Inc(i2,2);
                  Continue;
                end;
              if t1[i2+2]=#0 then Break; //<<??
              if i2+3>High(remapped) then
                Break;
              if must_define[i2+3] then
                begin
                  Inc(i2,3);
                  Continue;
                end;
              Break;
            end;
          Write(datei,'  db 0',Int2Hex(i1,2),'h,0',Int2Hex(i2,2),'h-0',Int2Hex(i1,2),'h+1, ');
          repeat
            Write(datei,asc_asm(remapped[i1]));
            if i1<>i2 then Write(datei,',');
            Inc(i1);
          until i1>i2;
          WriteLn(datei);
        end;
      (*$Else BLOCK_KEY_TABLE*)
      for i:=Low(remapped) to High(remapped) do
        if must_define[i] then
          WriteLn(datei,'  db 0',Int2Hex(i,2),'h,',asc_asm(remapped[i]));
      (*$EndIf BLOCK_KEY_TABLE*)
      WriteLn(datei,'  db 0');
      WriteLn(datei);
    end; (* erzeuge_tabelle *)

  procedure berechne_umordnung_alpha(const m_bios,m_nls:maptable);
    var
      i,j               :word;
      again             :boolean;

    function alpa_to_scan(const a:char;const prefer:byte):byte;
      var
        i               :word;
      begin
        if UpCase(m_bios[prefer])=a then
          begin
            Result:=prefer;
            Exit;
          end;
        for i:=Low(m_bios) to High(m_bios) do
          if UpCase(m_bios[i])=a then
            begin
              Result:=i;
              Exit;
            end;
        Result:=0;
      end;

    begin
      (* geÑnderte Zuordnung Buchstaben zu Tastennummer aufzeichenen *)
      for i:=Low(remap_scan) to High(remap_scan) do
        remap_scan[i]:=i;

      repeat
        again:=false;
        for i:=Low(m_nls) to High(m_nls) do
          if UpCase(m_nls[remap_scan[i]]) in ['A'..'Z'] then
            begin
              j:=alpa_to_scan{[}(UpCase(m_nls[remap_scan[i]]){]},remap_scan[i]);
              if (i<>j) and (j<>0) then
                begin
                  remap_scan[i]:=j;
                  remap_scan[j]:=i;
                  again:=true;
                end;
            end;
        until not again;

      WriteLn(datei,'keytable_remapscan:');
      for i:=Low(remap_scan) to High(remap_scan) do
        if remap_scan[i]<>i then
          WriteLn(datei,'  db 0',Int2Hex(i,2),'h,0',Int2Hex(remap_scan[i],2),
            'h ; ',UpCase(m_nls[i]),'->',UpCase(m_nls[remap_scan[i]]));
      WriteLn(datei,'  db 0');
      WriteLn(datei);
    end; (* berechne_umordnung_alpha *)

  begin (* erzeuge_tabellen *)
    Assign(datei,dateiname);
    Rewrite(datei);
    WriteLn(datei,'Title    automaticly generated keyboard remap table (',languagedescription,')');
    WriteLn(datei);
    WriteLn(datei,'keyboard_title equ "',languagedescription,'"');
    WriteLn(datei);
    berechne_umordnung_alpha(m5_bios[1],m5_nls[1]);
    erzeuge_tabelle(m5_bios[1],m5_nls[1],'Lower');
    erzeuge_tabelle(m5_bios[2],m5_nls[2],'Upper');
    erzeuge_tabelle(m5_bios[3],m5_nls[3],'AltGr');
    erzeuge_tabelle(m5_bios[4],m5_nls[4],'Alt'  );
    erzeuge_tabelle(m5_bios[5],m5_nls[5],'Ctrl' );
    Close(datei);
  end; (* erzeuge_tabellen *)

var
  tast_en,tast_de       :maptable5;
  lang                  :string[2];

begin
  lang:=ParamStr(1);
  if lang='' then RunError(9991);
  lies_scancode(tast_en,'tast_en.txt'      );
  lies_scancode(tast_de,'tast_'+lang+'.txt');
  erzeuge_tabellen(tast_en,tast_de,'tast_'+lang+'.inc',ParamStr(2));
end.

