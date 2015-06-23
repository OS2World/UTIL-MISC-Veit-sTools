{&Use32+}{$I+}
program hdd_vhd;

(* Veit Kannegieser 2004.07.05 *)

uses
  Dos,
  {$IfDef VirtualPascal}
  VpUtils,
  {$EndIf}
  Strings,
  hv_spr;

const
  datum                 ='2005.06.13';
  
{$IfDef Win32}
{$R hdd_vhdw.res}
{$EndIf Win32}
  
{$IfNDef VirtualPascal}
type
  TFileSize             =longint;

function Max(l1,l2:longint):longint;
  begin
    if l1>l2 then
      max:=l1
    else
      max:=l2;
  end;

{$EndIf}

procedure sc(var z;q:string);
  begin
    Move(q[1],z,Length(q));
  end;

function sv(const z;q:string):boolean;
  begin
    sv:=StrLComp(@z,@q[1],Length(q))=0;
  end;

procedure eingabe(const kommentar:string;var wert:longint;const wertmin,wertmax:word);
  var
    eingabezeile        :string;
    wert_temp           :word;
    kontrolle           :integer;
  begin
    repeat
      Write(kommentar,' [',wert,'] = ');
      ReadLn(eingabezeile);
      if eingabezeile='' then
        begin
          wert_temp:=wert;
          kontrolle:=0;
        end
      else
        Val(eingabezeile,wert_temp,kontrolle);
    until (kontrolle=0) and (wertmin<=wert_temp) and (wert_temp<=wertmax);
    wert:=wert_temp;
  end;

type
  {$IfDef VirtualPascal}
  alignment_buffer_t    =array[0..1024*1024-1] of byte;
  {$Else}
  alignment_buffer_t    =array[0..  32*1024-1] of byte;
  {$EndIf}

var
  b                     :array[0..512-1-1] of byte;
  f                     :file;
  fs,fsgeo              :TFileSize;
  mbr                   :array[0..512-1] of byte;

  z,k,s                 :longint;

  i                     :word;
  summe                 :longint;
  filename              :String;
  filename_path         :DirStr;
  filename_name         :NameStr;
  filename_ext          :ExtStr;
  to_svista             :boolean;
  force_geom            :boolean;
  rc                    :word;
  rc_str                :string;
  ft                    :text;
  alignment             :longint;
  alignment_buffer      :^alignment_buffer_t;

function AndTFS(s1,s2:TFileSize):TFileSize;
  begin
    {$IfDef LargeFileSupport}
    TFileSizeRec(Result).lo32:=TFileSizeRec(s1).lo32 and TFileSizeRec(s2).lo32;
    TFileSizeRec(Result).hi32:=TFileSizeRec(s1).hi32 and TFileSizeRec(s2).hi32;
    {$Else}
    AndTFS:=s1 and s2;
    {$EndIf}
  end;

procedure Error(const s:string;const rc:integer);
  begin
    WriteLn(s);
    Write(^G);
    Halt(rc);
  end;

function get_geom(const svs_ext:string):boolean;
  var
    ft                  :text;
    line,
    zk_z,zk_k,zk_s      :string;

  function ValF(var s:string;var v:longint):boolean;
    var
      kontrolle         :integer;
    begin
      while Pos('=',s)<>0 do Delete(s,1,Pos('=',s));
      Val(s,v,kontrolle);
      ValF:=kontrolle=0;
    end;

  begin

    get_geom:=false;

    Assign(ft,filename_path+filename_name+svs_ext);
    {$I-}
    Reset(ft);
    {$I+}
    if IOResult<>0 then Exit;

    zk_z:='';
    zk_k:='';
    zk_s:='';

    while not Eof(ft) do
      begin
        ReadLn(ft,line);

        if Pos('Disk 0:0 cylinders=',line)=1 then
          zk_z:=line

        else
        if Pos('Disk 0:0 heads='    ,line)=1 then
          zk_k:=line

        else
        if Pos('Disk 0:0 sectors='  ,line)=1 then
          zk_s:=line;

      end;
    Close(ft);

    if (zk_z<>'') and (zk_k<>'') and (zk_s<>'') then
      if ValF(zk_z,z) and ValF(zk_k,k) and ValF(zk_s,s) then
        get_geom:=true;
  end;

procedure fixsize_conectix;
  var
    fsg                 :TFileSize;
  begin
    {$IfDef LargeFileSupport}
    fsg:=z*k*s*512.0;
    {$Else}
    fsg:=z*k*s*512;
    {$EndIf}
    fs:=AndTFS(fs-1,-512);
    (* allow up to 1M alignment *)
    if  (AndTFS(fsg+1024*1024-1,-1024*1024)=fs)
    and (fsg<=fs) then
      begin
        fs:=fsg; (* cut it *)
        Exit;
      end;

    Error(textz_VPC_alignment_geometry_mismatch^,99);
  end;

begin
  WriteLn('HDD<->VHD * Veit Kannegieser * 2004.07.05..',datum);
  filename:=ParamStr(1);
  if (ParamCount<>1) or (filename='?') or (filename='/?') or (filename='-?') then
    begin
      WriteLn(textz_usage1^);
      WriteLn(textz_usage2^);
      WriteLn(textz_usage3^);
      WriteLn(textz_usage4^);
      Halt(1);
    end;
  FSplit(filename,filename_path,filename_name,filename_ext);
  to_svista:=StrlIComp(@filename_ext[1],'.VHD',Length('.VHD'))=0;

  force_geom:=false;

  Assign(f,filename);
  {$I-}
  Reset(f,1);
  {$I+}
  rc:=IOResult;
  if rc<>0 then
    begin
      Str(rc,rc_str);
      Error(textz_Fehler_beim_Oeffnen^+rc_str,rc);
    end;

  (* check for SVISTA compressed format
     cHDD2pHDD.exe unpacks, but the header is still there *)
  Seek(f,0);
  BlockRead(f,b,Length('WithoutFreeSpace'));
  if sv(b[0],'WithoutFreeSpace') then
    Error(textz_quellformat_svista_gepackt^,99);

  fs:=FileSize(f);
  if fs>SizeOf(b) then
    begin
      Seek(f,AndTFS(fs-1,-512));
      BlockRead(f,b,SizeOf(b));

      if sv(b[0],'conectix') then
        begin
          if b[$3c+3]<>2 then
            Error(textz_quellformat_vpc_aber_nicht_raw2^,99);

          force_geom:=true;
          z:=b[$38]*$100+b[$39];
          k:=b[$3a];
          s:=b[$3b];
          fixsize_conectix;
        end
    end;

  if AndTFS(fs,512-1)<>0 then
    Error(textz_Dateilaenge_ist_nicht_Vielfaches_von_512^,99);

  Seek(f,0);
  BlockRead(f,mbr,SizeOf(mbr));

  if (mbr[$1fe]<>$55) or (mbr[$1ff]<>$aa) then
    Error(textz_Die_Partitionstabelle_ist_ungueltig_55_AA_fehlt^,99);

  if force_geom then
    WriteLn(textz_Entnehme_Groessenangaben_aus_dem_VPC_Block^)
  else
    begin
      Write(textz_Suche_Groessenangaben_aus_svs^);
      if get_geom('.txt') or get_geom('.svs') then
        begin
          Write(textz_erfolgreich^);
          force_geom:=true;
        end
      else
        Write(textz_fehlgeschlagen^);
      WriteLn;
    end;

  (* inpu/check geometry loop *)
  repeat

    if not force_geom then
      begin
        k:=1;
        s:=1;
        for i:=1 to 4 do
          begin
            k:=Max(k,mbr[$1be+(i-1)*$10+5]+1);
            s:=Max(s,mbr[$1be+(i-1)*$10+6] and $3f);
          end;

        if k>16 then
          begin
            k:=16;
            s:=63;
          end;


        {$IfDef LargeFileSupport}
        z:=Round(fs/(k*s*512.0));
        {$Else}
        z:=fs div (k*s*512);
        {$EndIf}

        eingabe(textz_Zylinder^        ,z,1,65535);
        eingabe(textz_Koepfe^          ,k,1,   16);
        eingabe(textz_Sektoren_je_Spur^,s,1,   63);
      end;

    fsgeo:=z;
    fsgeo:=fsgeo*k;
    fsgeo:=fsgeo*s;
    fsgeo:=fsgeo;
    if fsgeo*512=fs then
      (* geometry ok *)
      Break;

    WriteLn(textz_Geometrie_stimmt_nicht^);
    WriteLn(textz___Dateilaenge__^,fs   /512:0:0,textz__Sektoren^);
    WriteLn(textz___Geometrie____^,fsgeo/  1:0:0,textz__Sektoren^);
    force_geom:=false;

  until false;

  (* prepare conectix sector *)
  FillChar(b,SizeOf(b),0);
  sc(b[0],'conectix');
  b[$0b]:=$02;
  b[$0d]:=$01;
  FillChar(b[$10],8,$ff);
  sc(b[$1c],'vpc ');
  b[$21]:=$05;

  (*sc(b[$24],'Wi2k');
    sc(b[$24],'Mac ');
    sc(b[$24],'Lnux');*)

  sc(b[$24],
  {$IfDef VirtualPascal}
  {$IFDef Linux}
            'Lnux');
  {$EndIf Linux}    
  {$IFDef Os2}
            'OS/2');
  {$EndIf Os2}
  {$IFDef Win32}
            'Wi2k');
  {$EndIf Win32}  
  {$Else VirtualPascal}
            'DOS ');
  {$EndIf VirtualPascal}

  b[$2c]:=$01;
  b[$34]:=$01;
  b[$38]:=Hi(z);
  b[$39]:=Lo(z);
  b[$3a]:=k;
  b[$3b]:=s;
  b[$3f]:=$02;

  summe:=0;
  for i:=Low(b) to High(b) do
    summe:=summe+b[i];
  summe:=not summe;
  b[$40]:=Lo(summe shr 24);
  b[$41]:=Lo(summe shr 16);
  b[$42]:=Lo(summe shr  8);
  b[$43]:=Lo(summe shr  0);


  (* do real the work ... *)

  Seek(f,fs);
  if to_svista then
    begin
      filename:=filename_path+filename_name+'.hdd';
      WriteLn(textz_dateigroesse_und_umbennen^,filename);
    end
  else
    begin
      filename:=filename_path+filename_name+'.vhd';
      WriteLn(textz_dateigroesse_und_umbennen^,filename);

      (* alignment:
             3M:   90* 4*17*512 $002FD000 -> $00300000 -> align 1MB
            16M:  481* 4*17*512 $00FF8800 -> $01000000
            40M:  963* 5*17*512 $027F7E00 -> $02800000
          2000M: 4063*16*63*512 $7CFC2000 -> $7d000000 *)


      New(alignment_buffer);
      FillChar(alignment_buffer^,SizeOf(alignment_buffer^),0);
      while AndTFS(fs,1024*1024-1)<>0 do
        begin
          alignment:=Round(AndTFS(fs+1024*1024-1,-1024*1024)-fs);
          if alignment>SizeOf(alignment_buffer^) then
            alignment:=SizeOf(alignment_buffer^);
          BlockWrite(f,alignment_buffer^,alignment);
          fs:=fs+alignment;
        end;
      Dispose(alignment_buffer);

      (* write conectix sector *)
      BlockWrite(f,b,SizeOf(b));
    end;
  Truncate(f);
  Close(f);

  {$I-}
  Rename(f,filename);
  {$I+}
  rc:=IOResult;
  if rc<>0 then
    begin
      Str(rc,rc_str);
      Error(textz_Fehler_beim_Umbenennen^+rc_str,rc);
    end;

  if to_svista then
    begin
      Write(textz_erzeuge_txt_svista^);
      Assign(ft,filename_path+filename_name+'.txt');
      Rewrite(ft);
      WriteLn(ft,'Disk 0:0=1');
      WriteLn(ft,'Disk 0:0 cylinders=',z);
      WriteLn(ft,'Disk 0:0 heads=',k);
      WriteLn(ft,'Disk 0:0 sectors=',s);
      Close(ft);
      WriteLn;
    end;
end.
