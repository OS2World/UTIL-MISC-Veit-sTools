(*$Use32+*)
{ $Define Debug}
program er_ztab;

uses
  Dos,
  ztab,
  unidef,
  UniApi,
  VpUtils;

var
  cp                    :word;
  unicp                 :pUniCharArray;

procedure probiere(const name_:UniCharArray);
  var
    convobj             :UconvObject;
    name8               :string;
    z                   :char;
    tabelle8            :zeichensatz8_zu_uc_tabelle;
    tabelleuc           :uc_zu_zeichensatz8_tabelle;

    temp                :pUniCharArray;
    rc                  :integer;
    pc                  :array[0..1] of char;
    inbuf               :pchar;
    inbytesleft         :size_t;
    ucsbuf              :pUniCharArray;
    UniCharsleft        :size_t;
    nonidentical        :size_t;

    d                   :file;
    gefunden            :boolean;

  begin
    if UniCreateUconvObject(unicp^,convobj)=ULS_SUCCESS then
      begin
        name8:=UniUcsToString(name_);
        Write(name8,' ');

        temp:=NewUniCharArray(1);
        for z:=Low(char) to High(char) do
          begin
            pc[0]:=z;
            pc[1]:=#0;
            inbuf:=@pc;
            inbytesleft:=1;
            ucsbuf:=temp;
            UniCharsleft:=1;

            rc:=
            UniUConvToUcs(
              convobj,
              inbuf,inbytesleft,
              ucsbuf,UniCharsleft,
              nonidentical);
            case rc of
              ULS_SUCCESS:
                tabelle8[z]:=temp^[0];
              UCONV_EBADF: (* 7-bit..*)
                if z<#$80 then
                  tabelle8[z]:=Ord(z)
                else
                  tabelle8[z]:=$ffff;
              UCONV_EINVAL: (* IBM-1200 *)
                tabelle8[z]:=$ffff;
            else
              RunError(rc);
            end;
          end;

        (* Ich nehme nur Zeichens„tze mit '?' *)
        gefunden:=false;
        for z:=Low(char) to High(char) do
          if tabelle8[z]=Ord('?') then
            begin
              gefunden:=true;
              Break;
            end;

        FreeUniCharArray(temp^);
        UniFreeUconvObject(convobj);

        erzeuge_uc_zu_zeichensatz8_tabelle(tabelle8,tabelleuc);

        if gefunden then
          merke_paket(cp,tabelleuc)
        else
          begin
            WriteLn('?');
            //ReadLn;
          end;

{$IfDef Debug}
        Assign(d,GetEnv('TMP')+'\'+name8+'.8');
        Rewrite(d,1);
        BlockWrite(d,tabelle8,SizeOf(tabelle8));
        Close(d);

        Assign(d,GetEnv('TMP')+'\'+name8+'.UC');
        ReWrite(d,1);
        with tabelleuc do
          BlockWrite(d,tabelleuc,SizeOf(tabelleuc)-SizeOf(folgen)+anzahl_folgen*SizeOf(folgen[1]));
        Close(d);
{$EndIf}

      end;
  end;

begin

(*
  for cp:=1000 to 1500 do
    begin
      unicp:=UniStringToUcs('Windows-'+Int2Str(cp));
      probiere(unicp^);
      FreeUniCharArray(unicp^);
    end;

  for cp:=1 to 30 do
    begin
      unicp:=UniStringToUcs('iso-8859-'+Int2Str(cp));
      probiere(unicp^);
      FreeUniCharArray(unicp^);
    end;

  for cp:=1 to 30 do
    begin
      unicp:=UniStringToUcs('ISO8859-'+Int2Str(cp));
      probiere(unicp^);
      FreeUniCharArray(unicp^);
    end; *)

  unicp:=NewUniCharArray(12);
for cp:=1 to 9999 do
//for cp:=1 to $ffff do
//for cp:=0 to 1260 do
//for cp:=910 to 910 do
//for cp:=1097 to 1097 do
    begin
      Write(cp:5,^h^h^h^h^h);
      if UniMapCpToUcsCp(cp,unicp^,12)=ULS_SUCCESS then
        probiere(unicp^);
    end;

  FreeUniCharArray(unicp^);
  WriteLn('     ');
//  ReadLn;

  speichere_pakete;
end.

