{&Use32+}{$I+}
program packe_vx_rexx;
(* 20010924 Veit Kannegieser *)

uses
  Dos,
  ExeHdr,
  Objects,
  packvx_s,
  Strings,
  VpUtils,
  VpSysLow;

type
  vrx_enc_typ           =
    packed record
      vrx_enc0          :array[0..7] of char;
      version           :longint;
      datenende         :longint;
      extra_verz_anfang :longint;
      extra_verz_ende   :longint;
      kennung           :longint;
    end;

  extra_anfang          =
    packed record
      anfang_verzeichnis:longint;
      anfang_rexxaa     :longint;
    end;

  block_beschreibung    =
    packed record
      block_startpos    :longint;
      block_laenge      :longint;
      block_typ         :longint;
      namen_laenge      :smallword;
      block_name        :array[0..260] of char;

      puffer            :pByteArray;
    end;

  block_beschreibung_tabelle_typ=array[1..10000] of block_beschreibung;

const
  datum                         ='2001.09.24..2001.10.03';

  loesche_tok   :boolean        =false;
  loesche_deb   :boolean        =false;
  unterverzeichnisse :boolean   =false;

  neue_kennung  :array[0..6] of char='PVXRXVK';

  Fehler        :boolean        =false;



procedure bearbeite(dateiname:string);
  var
    d                   :file;
    dateilaenge         :longint;
    vrx_enc             :vrx_enc_typ;
    f                   :integer;
    delta               :longint;
    aenderung           :boolean;
    loesch_aenderung    :boolean;
    verzeichnis         :pByteArray;
    block_tabelle       :^block_beschreibung_tabelle_typ;
    block_anzahl        :word;
    beschreibungslaenge :word;
    z1                  :word;
    zeile               :string;
    exe_kopf            :
      record
        case integer of
          1:(mz_exe:exe);
          2:(lx_exe:e32_exe);
      end;
    erste_daten         :longint;

  begin
    aenderung:=false;

    zeile:=dateiname;
    repeat
      zeile:=zeile+' ';
    until Length(zeile)>35;
    Write(zeile,' -  ');
    Assign(d,dateiname);
    FileMode:=open_access_ReadWrite or open_share_DenyReadWrite;
    {$I-}
    Reset(d,1);
    {$I+}
    f:=IOResult;
    if f<>0 then
      begin
        WriteLn(textz_Fehler_^,f,'.');
        Fehler:=true;
        Exit;
      end;

    dateilaenge:=FileSize(d);
    if dateilaenge<=SizeOf(vrx_enc) then
      begin
        Close(d);
        WriteLn(textz_zu_klein_^);
        Fehler:=true;
        Exit;
      end;

    Seek(d,dateilaenge-SizeOf(vrx_enc));
    BlockRead(d,vrx_enc,SizeOf(vrx_enc));
    with vrx_enc do
      begin
        if (kennung<>$0de2c5)
        or (StrComp(vrx_enc0,'VRX ENC'#0)<>0) then
          begin
            Close(d);
            WriteLn(textz_Nicht_mit_VX_Rexx_erzeugt_^);
            Fehler:=true;
            Exit;
          end;

        WriteLn(textz_VX_Rexx_Format_^,version);

        if version<>3 then
          begin
            Close(d);
            WriteLn(textz___nicht_unterstuetzt_^);
            Fehler:=true;
            Exit;
          end;

        delta:=dateilaenge-(datenende+extra_verz_ende+SizeOf(vrx_enc));

        (* Fall copy /B prÅfen *)
        if delta>0 then
          begin
            Seek(d,delta);
            BlockRead(d,exe_kopf,SizeOf(exe_kopf));
            with exe_kopf.mz_exe do
              if ((eid=$5a4d) or (eid=$4d5a)) and (erelcnt<100) and (ehdrsiz<=32) then
                delta:=0;
            with exe_kopf.lx_exe do
              if (e32_magic[0]=Ord('L')) and (e32_magic[1]=Ord('X')) and (e32_border=E32LEBO) and (e32_Worder=E32LEWO) and (e32_Level=0) then
                delta:=0;
          end;

        if delta<>0 then
          begin
            aenderung:=true;
            Write(textz_Positionsaenderung__LxLite___um_^);
            if delta>0 then
              Write('+$',Int2Hex(+delta,8))
            else
              Write('-$',Int2Hex(-delta,8));
            WriteLn('.');

            Inc(datenende,delta);
          end;

        if not (loesche_tok or loesche_deb or aenderung) then
          Exit;

        (* Verzeichnisinformationen lesen *)
        Seek(d,datenende);
        GetMem(verzeichnis,extra_verz_ende);
        BlockRead(d,verzeichnis^,extra_verz_ende);

        (* gewÅnschte Dateiblîcke laden *)
        block_anzahl:=0;
        block_tabelle:=nil;

        erste_daten:=datenende;

        loesch_aenderung:=false;
        z1:=extra_verz_anfang;
        while z1<extra_verz_ende do
          with block_beschreibung(verzeichnis^[z1]) do
            begin
              beschreibungslaenge:=SizeOf(block_startpos)+SizeOf(block_laenge)
                +SizeOf(block_typ)+SizeOf(namen_laenge)+namen_laenge;

              if block_startpos>0 then
                Inc(block_startpos,delta);


              zeile:=StrPas(block_name);
              repeat zeile:=zeile+' ' until Length(zeile)>20;
              Write('  ',zeile,'($',Int2Hex(block_startpos,8),',$',Int2Hex(block_laenge,8),',',block_typ,')');

              if block_laenge>0 then
                erste_daten:=Min(erste_daten,block_startpos);

              if (loesche_tok and (block_typ=4))
              or (loesche_deb and (block_typ=5)) then
                begin
                  loesch_aenderung:=true;
                  WriteLn(' -')
                end


              else
                begin
                  Inc(block_anzahl);
                  ReallocMem(block_tabelle,block_anzahl*SizeOf(block_tabelle^[1]));
                  FillChar(block_tabelle^[block_anzahl],SizeOf(block_tabelle^[block_anzahl]),0);
                  Move(block_beschreibung(verzeichnis^[z1]),block_tabelle^[block_anzahl],beschreibungslaenge);
                  WriteLn(' *')
                end;

              Inc(z1,beschreibungslaenge);

            end; (* while with *)


        if not (aenderung or loesch_aenderung) then
          begin
            Close(d);
            Exit;
          end;


        if loesch_aenderung then
          begin

            (* bleibendende Datenblîcke einlesen *)
            for z1:=1 to block_anzahl do
              with block_tabelle^[z1] do
                if block_laenge>0 then
                  begin
                    GetMem(puffer,block_laenge);
                    Seek(d,block_startpos);
                    BlockRead(d,puffer^,block_laenge);
                  end;

            // Kopie erzeugen ?

            (* Daten schreiben *)
            datenende:=erste_daten;
            Seek(d,datenende);
            for z1:=1 to block_anzahl do
              with block_tabelle^[z1] do
                if Assigned(puffer) then
                  begin
                    block_startpos:=datenende;
                    BlockWrite(d,puffer^,block_laenge);
                    Dispose(puffer);
                    puffer:=nil;
                    Inc(datenende,block_laenge);
                  end;

          end; (* loesch_aenderung *)

        (* REXXSAA - Kennung 2 mal Åberschreiben *)
        Move(neue_kennung,verzeichnis^[$15],SizeOf(neue_kennung));
        Move(neue_kennung,verzeichnis^[extra_anfang(Pointer(verzeichnis)^).anfang_rexxaa+8],SizeOf(neue_kennung));


        (* Verzeichnis schreiben *)
        Seek(d,datenende);

        extra_verz_ende:=extra_verz_anfang;
        for z1:=1 to block_anzahl do
          with block_tabelle^[z1] do
            begin

              beschreibungslaenge:=SizeOf(block_startpos)+SizeOf(block_laenge)
                +SizeOf(block_typ)+SizeOf(namen_laenge)+namen_laenge;

              ReallocMem(verzeichnis,extra_verz_ende+beschreibungslaenge);
              Move(block_tabelle^[z1],block_beschreibung(verzeichnis^[extra_verz_ende]),beschreibungslaenge);

              Inc(extra_verz_ende,beschreibungslaenge);
            end;

        BlockWrite(d,verzeichnis^,extra_verz_ende);


        BlockWrite(d,vrx_enc,SizeOf(vrx_enc));
        Truncate(d);
        Close(d);

        Dec(dateilaenge,datenende);
        Dec(dateilaenge,extra_verz_ende);
        Dec(dateilaenge,SizeOf(vrx_enc));

        if dateilaenge<>0 then
          WriteLn(textz___Einsparung__^,dateilaenge);

      end; (* with vrx_enc *)

  end; (* bearbeite *)


procedure Hilfe;
  begin
    WriteLn(textz_hilfe1^);
    WriteLn(textz_hilfe2^);
    WriteLn(textz_hilfe3^);
    WriteLn(textz_hilfe4^);
    WriteLn(textz_hilfe5^);
    Halt(255);
  end;

procedure schalter_(var b:boolean;var s:string);
  begin
    Delete(s,1,1);

    if s='' then
      b:=not b

    else
    if s='+' then
      b:=true

    else
    if s='-' then
      b:=false

    else
      Hilfe;
  end; (* schalter_ *)


function suche(const suchmaske:string):boolean;
  var
    sr          :SearchRec;
    p,n,e       :string;
  begin
    Result:=false;
    FSplit(FExpand(suchmaske),p,n,e);
    if n+e='' then
      begin
        n:='*';
        e:='.*';
      end;

    FindFirst(p+n+e,AnyFile-Directory,sr);
    while DosError=0 do
      begin
        Result:=true;
        bearbeite(p+sr.name);
        FindNext(sr);
      end;
    FindClose(sr);

    if unterverzeichnisse then
      begin
        FindFirst(p+'*.*',AnyFile,sr);
        while DosError=0 do
          begin
            if (sr.name<>'.') and (sr.name<>'..') and ((sr.attr and Directory)=Directory) then
              if suche(p+sr.name+'\'+n+e) then
                Result:=true;
            FindNext(sr);
          end;
        FindClose(sr);
      end;
  end; (* suche *)


var
  para          :string;
  i             :word;

begin
  WriteLn('PACKVXRX * ',textz_zweck^,' * V.K. * ',datum);

  if ParamCount=0 then
    Hilfe;

  (* Schalter *)
  for i:=1 to ParamCount do
    begin
      para:=ParamStr(i);
      if para='' then Continue;
      if not (para[1] in ['/','-']) then Continue;

      Delete(para,1,1);
      if para='' then Continue;
      case UpCase(para[1]) of
        'T':schalter_(loesche_tok,para);
        'D':schalter_(loesche_deb,para);
        'S',
        'U':schalter_(unterverzeichnisse,para);
      else
        Hilfe;
      end;
    end;

  (* Dateien *)
  for i:=1 to ParamCount do
    begin
      para:=ParamStr(i);
      if para='' then Continue;
      if para[1] in ['/','-'] then Continue;
      if not Suche(para) then
        begin
          Fehler:=true;
          WriteLn('"',para,'" : ',textz_nicht_gefunden_^);
        end;
    end;

  if Fehler then
    Halt(1);
end.


