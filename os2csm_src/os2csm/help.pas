const
  os2csm_help_signature ='OS2CSM Helpfile'^Z;

type
  os2csm_hlp_kopf       =
    packed record
      signatur          :array[1..Length(os2csm_help_signature)] of char;
      vgaattribute      :byte;
      anzahl            :smallword;
    (*eintraege         :array[0..0] of os2csm_hlp_eintrag_kopf *)
    end;

  os2csm_hlp_eintrag_kopf=
    packed record
      laenge            :smallword;
      seite             :byte;
      variable          :smallword;
      zeilen            :byte;
      spalten           :byte;
    (*daten             :array[0..0] of byte;*)
    end;

procedure lade_menuhlp_txt(const standardverzeichnis:string);
  var
    menu_hlp_txt        :Text;

  procedure lies_hilfe(const seitennummer,variablennummer:word);
    var
      linker_rand       :word;
      limitx,
      limity            :word;
      maxx,
      maxy              :word;
      i,l               :word;
    begin
      Write('.');
      l:=SizeOf(os2csm_hlp_kopf);
      while l<os2csm_hlp_laenge do
        with os2csm_hlp_eintrag_kopf(os2csm_hlp_puffer[l]) do
          begin
            if (seite=seitennummer) and (variable=variablennummer) then
              begin
                WriteLn(textz_duplicate_help_item_^);
                schreibe_org_zeile;
                fehler_ende_99;
              end;
            Inc(l,SizeOf(os2csm_hlp_eintrag_kopf)+laenge);
          end;

      with os2csm_hlp_eintrag_kopf(os2csm_hlp_puffer[os2csm_hlp_laenge]) do
        begin
          laenge:=0;
          seite:=seitennummer;
          variable:=variablennummer;
          zeilen:=0;
          spalten:=0;
        end;
      limitx:=80-6;
      limity:=seiten_zeilenzahl-6;
      maxx:=0;
      maxy:=0;
      l:=SizeOf(os2csm_hlp_eintrag_kopf);
      while not Eof(menu_hlp_txt) do
        begin
          ReadLn(menu_hlp_txt,zeile);
          org_zeile:=zeile;
          leerzeichen_und_tab_umwandeln(zeile);
          if zeile='' then zeile:=' ';
          while Length(zeile)>1 do
            if zeile[Length(zeile)]=' ' then SetLength(zeile,Length(zeile)-1) else Break;
          (* Leerzeilen am Anfang entfernen *)
          if (zeile=' ') and (maxy=0) then Continue;
          if zeile[1] in ['#',';','%'] then Continue;
          (* Abbruch bei Definition des n„chsten Textes (Spalte 1) *)
          if zeile[1]<>' ' then Break;

          if maxy=0 then
            begin
              linker_rand:=0;
              while zeile[linker_rand+1]=' ' do Inc(linker_rand);
            end;
          Delete(zeile,1,linker_rand);
          // no wrap...
          if Length(zeile)>limitx then SetLength(zeile,limity);
          // simply cut...
          if maxy>=limity then Continue;

          if Length(zeile)>maxx then maxx:=Length(zeile);

          if os2csm_hlp_laenge+l+2>High(os2csm_hlp_puffer) then
            begin
              WriteLn(textz_helpfile_is_becoming_too_large_^);
              schreibe_org_zeile;
              fehler_ende_99;
            end;

          Move(zeile[1],os2csm_hlp_puffer[os2csm_hlp_laenge+l],Length(zeile));
          Inc(l,Length(zeile));
          os2csm_hlp_puffer[os2csm_hlp_laenge+l]:=13;Inc(l);
          os2csm_hlp_puffer[os2csm_hlp_laenge+l]:=10;Inc(l);
          Inc(maxy);
        end; (* EOF/BREAK *)

      (* zus„tzliche Leerzeilen entfernen *)
      while l>=SizeOf(os2csm_hlp_eintrag_kopf)+1 do
        if os2csm_hlp_puffer[os2csm_hlp_laenge+l-1] in [13,10,Ord(' ')] then
          begin
            if os2csm_hlp_puffer[os2csm_hlp_laenge+l-1]=10 then Dec(maxy);
            Dec(l);
          end
        else
          Break;

      with os2csm_hlp_eintrag_kopf(os2csm_hlp_puffer[os2csm_hlp_laenge]) do
        begin
          laenge:=l-SizeOf(os2csm_hlp_eintrag_kopf);
          zeilen:=maxy+1;
          spalten:=maxx;
        end;
      Inc(os2csm_hlp_laenge,l);

      with os2csm_hlp_kopf(os2csm_hlp_puffer[0]) do
        Inc(anzahl);
    end; (* lies_hilfe *)

  var
    menu_hlp_txt_modus  :(menu_hlp_txt_erwarte_vordergrund,
                          menu_hlp_txt_erwarte_hintergrund,
                          menu_hlp_txt_erwarte_allgemeinhilfe,
                          menu_hlp_txt_erwarte_hilfen);
    seitennummer_h      :word;
    variablennummer_h   :word;
    voller_dateiname    :string;

  begin (* lade_menuhlp_txt *)

    with os2csm_hlp_kopf(os2csm_hlp_puffer[0]) do
      begin
        signatur:=os2csm_help_signature;
        vgaattribute:=$10;
        anzahl:=0;
      end;

    os2csm_hlp_laenge:=SizeOf(os2csm_hlp_kopf);


    suche_datei(voller_dateiname,standardverzeichnis,menu_hlp_txt_name,true);
    if voller_dateiname='' then
      voller_dateiname:=menu_hlp_txt_name;
    Write(textz_plus_Lade_^,voller_dateiname,' ');
    Assign(menu_hlp_txt,voller_dateiname);
    {$I-}
    Reset(menu_hlp_txt);
    {$I+}
    if IOResult=0 then
      begin
        menu_hlp_txt_modus:=menu_hlp_txt_erwarte_vordergrund;
        zeile:='';
        while not Eof(menu_hlp_txt) do
          begin

            if zeile='' then
              begin
                ReadLn(menu_hlp_txt,zeile);
                org_zeile:=zeile;
                leerzeichen_und_tab_umwandeln(zeile);
              end;

            if zeile='' then Continue;
            if zeile[1] in ['#',';','%'] then
              begin
                zeile:='';
                Continue;
              end;
            case menu_hlp_txt_modus of
              menu_hlp_txt_erwarte_vordergrund:
                begin
                  zeilenanfang_abtrennen;
                  zahl_umformung_anfang(0,15,textz_Foreground_color^);
                  with os2csm_hlp_kopf(os2csm_hlp_puffer[0]) do
                    vgaattribute:=vgaattribute and $f0+zahl;
                  zeilenanfang_abtrennen;
                  erwarte_zeilenende;
                  menu_hlp_txt_modus:=menu_hlp_txt_erwarte_hintergrund;
                end;
              menu_hlp_txt_erwarte_hintergrund:
                begin
                  zeilenanfang_abtrennen;
                  zahl_umformung_anfang(0,15,textz_Background_color^);
                  with os2csm_hlp_kopf(os2csm_hlp_puffer[0]) do
                    vgaattribute:=vgaattribute and $0f+zahl shl 4;
                  zeilenanfang_abtrennen;
                  erwarte_zeilenende;
                  menu_hlp_txt_modus:=menu_hlp_txt_erwarte_allgemeinhilfe;
                end;
              menu_hlp_txt_erwarte_allgemeinhilfe:
                begin
                  lies_hilfe(0,0);
                  menu_hlp_txt_modus:=menu_hlp_txt_erwarte_hilfen;
                end;
              menu_hlp_txt_erwarte_hilfen:
                begin
                  zeilenanfang_abtrennen;
                  (* '.PAGE 2' *)
                  if uebereinstimmung_anfang('.PAGE','.SEITE') then
                    begin
                      zeilenanfang_abtrennen;
                      zahl_umformung_anfang(1,seiten_anzahl,textz_page_number^);
                      seitennummer_h:=zahl;
                      variablennummer_h:=0;
                    end
                  else (* 'HPFS' *)
                    begin
                      variablennummer_h:=suche_variable(anfang);
                      if variablennummer_h=-1 then
                        begin
                          WriteLn(textz_variable_x_not_found1^,anfang,textz_variable_x_not_found2^);
                          schreibe_org_zeile;
                          fehler_ende_99;
                        end;
                      with variablen_tabelle[variablennummer_h] do
                        begin
                          seitennummer_h:=seitennummer;
                          if seitennummer_h=0 then
                            begin
                              WriteLn(textz_variable_x_invisible1^,anfang,textz_variable_x_invisible2^);
                              schreibe_org_zeile;
                              fehler_ende_99;
                            end;
                        end;
                    end;
                  zeilenanfang_abtrennen;
                  erwarte_zeilenende;
                  lies_hilfe(seitennummer_h,variablennummer_h);
                end;
            end; (* case menu_hlp_txt_modus *)
          end; (* while not eof *)
        Close(menu_hlp_txt);
        WriteLn;
      end
    else
      Writeln(textz_Not_available_^);
  end; (* lade_menuhlp_txt *)



const
  rahmenzeichen         :array[1..3] of array[1..3] of char=(
    ('Ú','Ä','¿'),
    ('³',' ','³'),
    ('À','Ä','Ù'));

procedure hilfe_anzeigen(const seitennummer,variablennummer:word);

  procedure hilfe_anzeigen2(const hilfetext:PChar;
                            const laenge:word;
                            const zeilen,spalten:word;
                            var  vgaattribute:byte);
    var
      l,
      x0,y0,c,
      rz,rs,
      x,y               :word;
    begin
      SysGetVideoModeInfo(x0,y0,c);
      (* Rechteck *)
      x0:=(x0-spalten-6) div 2;
      y0:=(y0-zeilen -4) div 2;
      for y:=1 to zeilen+4 do
        begin
          if y=1 then
            rz:=1
          else
          if y=zeilen+4 then
            rz:=3
          else
            rz:=2;
          for x:=1 to spalten+6 do
            begin
              if x=1 then
                rs:=1
              else
              if x=spalten+6 then
                rs:=3
              else
                rs:=2;
              SysWrtCharStrAtt(@rahmenzeichen[rz,rs],1,x0-1+x-1,y0-1+y-1,vgaattribute);
            end;
        end;

      (* Inhalt *)
      Inc(x0,3);
      Inc(y0,2);
      x:=1;
      y:=1;
      for l:=1 to laenge do
        case hilfetext[l-1] of
          #10:Inc(y);
          #13:x:=1;
        else
          SysWrtCharStrAtt(@hilfetext[l-1],1,x0-1+x-1,y0-1+y-1,vgaattribute);
          Inc(x);
        end;

      SysReadkey;


    end;

  function hilfe_anzeigen1(const seitennummer,variablennummer:word):boolean;
    var
      a                 :word;
      l                 :word;
    begin
      Result:=false;
      with os2csm_hlp_kopf(os2csm_hlp_puffer[0]) do
        begin
          l:=SizeOf(os2csm_hlp_kopf);
          for a:=1 to anzahl do
            with os2csm_hlp_eintrag_kopf(os2csm_hlp_puffer[l]) do
              begin
                if (seite=seitennummer) and (variable=variablennummer) then
                  begin
                    hilfe_anzeigen2(@os2csm_hlp_puffer[l+SizeOf(os2csm_hlp_eintrag_kopf)],
                      laenge,
                      zeilen,spalten,
                      vgaattribute);
                    Result:=true;
                    Exit;
                  end;

                Inc(l,SizeOf(os2csm_hlp_eintrag_kopf)+laenge);
              end;
        end;
    end; (* hilfe_anzeigen1 *)

  begin (* hilfe_anzeigen *)
    if not hilfe_anzeigen1(seitennummer,variablennummer) then
    if not hilfe_anzeigen1(seitennummer,0              ) then
           hilfe_anzeigen1(0           ,0              );
  end; (* hilfe_anzeigen *)

