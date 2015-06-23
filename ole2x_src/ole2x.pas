{&Use32+}{$I+}
{&M 800000}
program ole2x; (* vk 2003.02.25 *)

uses
  //heapchk,
  {$IfDef Os2}
  Os2Def,
  Os2Base,
  {$EndIf Os2}
  Dos,
  MkDir2,
  Objects,
  Strings,
  VpUtils;

const
  readbuffersize        =     4*1024;
  writebuffersize       =1*1024*1024;

var
  sourcefile            :pBufStream;
  sourcefilesize        :TFileSize;
  rc                    :integer;

  kopf:
    packed record
      sign              :array[$00..$07] of char;
      x08               :array[$08..$1d] of byte;
      log2_big_blocksize:smallword; (* 1e *)
      log2_small_blocksize:integer; (* 20 *)
      x24               :array[$24..$2b] of byte; (* $24 *)
      number_of_elements_in_BAT_array:integer; (* $2C *)
      properties_start  :integer; (* $30 *)
      x34               :array[$34..$3b] of byte; (* $34 *)
      SBAT_start        :integer; (* $3c *)
      SBAT_block_count  :integer; (* $40 *)
      XBAT_start        :integer; (* $44 *)
      XBAT_count        :integer; (* $48 *)
      BAT_array         :array[0..109-1] of integer; (* $4c *)
    end;
  zielverzeichnis       :string;

const
  BAT_code_unused       =- 1;
  BAT_code_eof          =- 2;
  BAT_code_special      =- 3;
  BAT_code_xbat         =- 4; (* guessed *)
  BAT_code_error        =-10; (* private definition *)

type
  comp_rec              =
    packed record
      low32,
      high32            :longint;
    end;
  propertyname_type     =array[$00..$3f] of char;
  property_typ=
    packed record
      propertyname      :propertyname_type;
      propertyname_size :smallword;   (* $40 *)
      property_type     :byte;        (* $42 *)
      node_color        :byte;        (* $43 *)
      previous_property :integer;     (* $44 *)
      next_property     :integer;     (* $48 *)
      first_child_propety:integer;    (* $4c *)
      x50               :array[$50..$63] of byte;
      time_1            :comp;        (* $64 *)
      time_2            :comp;        (* $6c *)
      start_block       :integer;     (* $74 *)
      property_size     :integer;     (* $78 *)
      x7c               :array[$7c..$7f] of byte; {<<maybe large file support?}
    end;

var
  BAT                   :pLongArray=nil;
  SBAT                  :pLongArray=nil;
  maxblock              :integer; (* 0..maxblock-1 *)
  smallblockarray       :pByteArray=nil;
  smallblockarraysize   :integer=0;

function decode_msi_name(const pn:propertyname_type;const pnl:word):string;
  var
    i                   :word;
    c                   :byte;
  function namechar:char;
    begin
      case c of
        $00..$09:Result:=Chr(Ord('0')+c-$00);
        $0a..$23:Result:=Chr(Ord('A')+c-$0a);
        $24..$3d:Result:=Chr(Ord('a')+c-$24);
        $3e     :Result:='.';
        $3f     :Result:='_';
      end;
    end;

  begin
    Result:='';
    for i:=0 to pnl-1 do
      if not Odd(i) then
        begin
          c:=Ord(pn[i]) and $3f;
          if (c=0) and (pn[i+1]=#0) then Break;
          Result:=Result+namechar;
        end
      else
        begin
          c:=(((Ord(pn[i]) shl 2)+(Ord(pn[i-1]) shr 6))-$20) and $3f;
          if (c=0) and (pn[i+1]=#0) then Break;
          Result:=Result+namechar;
        end;
  end;



procedure error(const s:string);
  begin
    WriteLn(s);
    Halt(99);
  end;

function streamerrorcode(const e:integer):string;
  begin
    case e of
      stError     :streamerrorcode:='Error accessing file.';
      stInitError :streamerrorcode:='Error opening stream.';
      stReadError :streamerrorcode:='Stream read error (end of file).';
      stWriteError:streamerrorcode:='Error writing to stream.';
      stGetError  :streamerrorcode:='Get Error.';
      stPutError  :streamerrorcode:='Put Error.';
    else
                   streamerrorcode:='Unknown stream error '+Int2Str(e);
    end;
  end;

procedure NilFree(var p:pointer);
  begin
    if Assigned(p) then
      begin
        DisPose(p);
        p:=nil;
      end;
  end;

function TFS2Hex(const v:TFileSize):string;
  begin
    {$IfDef LargeFileSupport}
    TFS2Hex:=Int2Hex(TFileSizeRec(v).hi32,8)+Int2Hex(TFileSizeRec(v).lo32,8);
    {$Else}
    TFS2Hex:=Int2Hex(v,8);
    {$EndIf}
  end;

procedure lies(var p;const o:TFileSize;const lsoll,lmin:integer);
  var
    l:integer;
  begin
    l:=lsoll;
    if l>sourcefilesize-o then
      {$IfDef LargeFileSupport}
      l:=Round(sourcefilesize-o);
      {$Else}
      l:=sourcefilesize-o;
      {$EndIf}
    if l<lmin then
      Error('Reading beyound end of file.');

    FillChar(p,lsoll,Byte(BAT_code_error));
    if sourcefile^.GetPos<>o then
      sourcefile^.Seek(o);

    if rc<>stOK then
      Error('Seek error: '+TFS2Hex(o)+', rc='+Int2Str(rc));

    sourcefile^.Read(p,l);
    rc:=sourcefile^.Status;
    if rc<>stOK then
      Error('Block read error:'+TFS2Hex(o)+',l='+Int2Str(l));
  end;

procedure lies_block(var p;const i,lsoll,lmin:integer);
  begin
    lies(p,512*(1+i),lsoll,lmin);
  end;

procedure lies_sblock(var p;const i,lsoll,lmin:integer);
  var
    l,o:integer;
  begin
    FillChar(p,lsoll,Byte(BAT_code_error));
    if i<0 then
      Error('Invalid small block number:'+Int2Hex(i,8));
    o:=i shl kopf.log2_small_blocksize;
    l:=smallblockarraysize-o;
    if l<0 then
      Error('Small block read behind end of stream');
    l:=Min(l,lsoll);
    if l<lmin then
      Error('Small block read behind end of stream');
    Move(smallblockarray^[o],p,l);
  end;

type
  monatstabelle         =array[1..12] of byte;
const
  monatstabelle_normal  :monatstabelle=(31,28,31,30,31,30,31,31,30,31,30,31);
  monatstabelle_schalt  :monatstabelle=(31,29,31,30,31,30,31,31,30,31,30,31);

procedure decode_time(const time_source:comp;const defaulttime:longint;var resulttime:longint);
  var
    time_source_rec     :comp_rec absolute time_source;
    seconds_d           :double;
    seconds,
    days                :longint;
    DT                  :DateTime;
    monatstabelle_z     :^monatstabelle;
  begin
    resulttime:=defaulttime;
    if (time_source=0) or (time_source=-1) then Exit;

    seconds_d:=time_source/1E7;
    days:=Trunc(seconds_d/(24.0*60*60))+1;

    seconds:=Trunc(seconds_d-(days-1)*24.0*60*60);
    DT.Sec:=seconds  mod 60;
    seconds:=seconds div 60;
    DT.Min:=seconds  mod 60;
    seconds:=seconds div 60;
    DT.Hour:=seconds;

    DT.Year:=Trunc(days/365.2425)+1600+1;
    days:=days
         -(DT.Year-1600-1) *   365
         -(DT.Year-1600-1) div   4
         +(DT.Year-1600-1) div 100
         -(DT.Year-1600-1) div 400;
    DT.Month:=1;
    monatstabelle_z:=@monatstabelle_normal;
    if (DT.Year mod 4)=0 then
      if ((DT.Year mod 100)<>0) or ((DT.Year mod 400)=0) then
        monatstabelle_z:=@monatstabelle_schalt;
    while days>monatstabelle_z^[DT.Month] do
      begin
        Dec(days,monatstabelle_z^[DT.Month]);
        Inc(DT.Month);
      end;
    DT.Day:=days;
    PackTime(DT,resulttime);
  end;

procedure SetFileTime(const fn:string;const ft:longint);
  var
    f                   :file;
    ignore              :integer;
  begin
    Assign(f,fn);
    FileMode:=2;
    {$I-}
    Reset(f,1);
    {$I+}
    if IOResult=0 then
      begin
        SetFTime(f,ft);
        Close(f);
      end;
  end;

procedure SetDirTime(const dn:string;const dt:longint);
  {$IfDef Os2}
  var
    fs3                 :FileStatus3;
  {$EndIf Os2}
  begin
    {$IfDef Os2}
    if DosQueryPathInfo(@(dn+#0)[1],fil_Standard,fs3,SizeOf(fs3))=0 then
      begin
        with fs3 do
          begin
            fdateCreation  :=dt shr 16;
            ftimeCreation  :=dt and $ffff;
            fdateLastAccess:=dt shr 16;
            ftimeLastAccess:=dt and $ffff;
            fdateLastWrite :=dt shr 16;
            ftimeLastWrite :=dt and $ffff;
          end;
        DosSetPathInfo(@(dn+#0)[1],fil_Standard,fs3,SizeOf(fs3),0);
      end;
  {$EndIf Os2}


  {$IfDef DPMI32}
  // not implemented
  {$EndIf DPMI32}

  {$IfDef Linux}
  // not implemented
  {$EndIf Linux}

  {$IfDef Win32}
  // not implemented
  {$EndIf Win32}

  end;

procedure erkenne_einige_dateitypen(const puffer:pByteArray;const property_size:longint;var ext:string);
  begin
    if StrLComp(@puffer^,'MZ'  ,Length('MZ'  ))=0 then ext:='.prg';
    if StrLComp(@puffer^,'MSCF',Length('MSCF'))=0 then ext:='.cab';
    if pLongint(@puffer^[0])^=$00010000 then
    if (puffer^[6]=puffer^[7]) and (puffer^[6] in [16,32,40,48]) then ext:='.ico';
    if StrLComp(@puffer^,#$ff#$d8#$ff#$e0,4)=0 then ext:='.jpg';
    if StrLComp(@puffer^,'GIF9',Length('GIF9'))=0 then ext:='.gif';
    if StrLComp(@puffer^,#$89'PNG',Length(#$89'PNG'))=0 then ext:='.png';
    if StrLComp(@puffer^,'BM',Length('BM'))=0 then
      if  (pLongint(@puffer^[2])^+$20>=property_size)
      and (pLongint(@puffer^[2])^    <=property_size+$20) then
        ext:='.bmp';
    if pLongint(@puffer^[0])^=$00c1a5ec then ext:='.wor';
    if pLongint(@puffer^[0])^=$0068a5dc then ext:='.wor';
    if pLongint(@puffer^[0])^=$0065a5dc then ext:='.wor';
    if StrLComp(@puffer^,'REGEDIT',Length('REGEDIT'))=0 then ext:='.reg';
    if StrLComp(@puffer^,'aLuZ',Length('aLuZ'))=0 then ext:='.ins'; (* installshield *)
    if StrLComp(@puffer^,'{\rtf',Length('{\rtf'))=0 then ext:='.rtf';
    if StrLComp(@puffer^,#$D0#$CF#$11#$E0#$A1#$B1#$1A#$E1,Length(#$D0#$CF#$11#$E0#$A1#$B1#$1A#$E1))=0 then ext:='.ole';
  end;

procedure unpack_properties;
  type
    directory_t =array[0..High(integer) div SizeOf(property_typ)] of property_typ;
  var
    directory   :^directory_t;
    dir         :integer;
    maxdir_entry:longint;
    dir_used    :pByteArray;
    path,
    pname,
    ext         :string;
    bs          :integer;
    puffer      :pByteArray;
    ausgabe     :pBufStream;
    ausgabe2    :pBufStream;

  procedure unpack_property_recursive(const dir_index,pathlen:integer;const defaulttime:longint);
    var
      z1        :integer;
      x         :integer;
      j         :integer;
      jetzt     :integer;
      item_time :longint;
      olenative_x:boolean;
    begin

      if dir_index=BAT_code_unused then (* empty subdirectory? *)
        Exit; (* "Application History.doc" *)

      if (dir_index>=maxdir_entry) or (dir_index<0) then
        Error('Access to invalid directory entry index.');

      if dir_used^[dir_index]=1 then
        Error('Loop in directory chain.');
      dir_used^[dir_index]:=1;

      with directory^[dir_index] do
        begin

          (* go previous tree *)
          if previous_property<>-1 then
            unpack_property_recursive(previous_property,pathlen,defaulttime);


          (* now really process this entry *)
          pname:='';
          for z1:=0 to (propertyname_size div 2)-1 do
            if propertyname[z1*2+1]=#0 then
              begin
                if (propertyname[z1*2]=#0) and (z1=(propertyname_size div 2)-1) then
                  Continue;
                if propertyname[z1*2]<' ' then
                  pname:=pname+'_'+Int2Str(Ord(propertyname[z1*2]))+'_'
                else
                  pname:=pname+propertyname[z1*2];
              end
            else
              pname:=pname+'?';



          if property_size>=4096 then
            bs:=1 shl kopf.log2_big_blocksize
          else
            bs:=1 shl kopf.log2_small_blocksize;

          while Pos(#0,pname)<>0 do Delete(pname,Pos(#0,pname),1);

          if Pos('?',pname)<>0 then
            begin
              //pname:=Int2Hex(start_block,8);
              pname:=decode_msi_name(propertyname,propertyname_size);
              ext:='.dat';

              if (property_type=2) and (property_size>16) then (* file *)
                begin
                  if property_size>=4096 then
                    lies_block(puffer^,start_block,16,16)
                  else
                    lies_sblock(puffer^,start_block,16,16);

                  erkenne_einige_dateitypen(puffer,property_size,ext);
                end;

              (* only add extension if not already present *)
              if Length(pname)>=Length(ext) then
                begin

                  if StrLIComp(@pname[length(pname)-Length(ext)+1],@ext[1],Length(ext))=0 then
                    ext:='';


                  (*
                  if ext='.prg' then
                    if (StrLIComp(@pname[length(pname)-Length('.dll')+1],'.dll',Length('.dll'))=0)
                    or (StrLIComp(@pname[length(pname)-Length('.exe')+1],'.exe',Length('.exe'))=0)
                     then
                      ext:='';

                  if ext='.dat' then ( * utf16 Text * )
                    if (StrLIComp(@pname[length(pname)-Length('.txt')+1],'.txt',Length('.txt'))=0)
                     then
                      ext:='';

                  if ext='.ole' then ( * *.msi/mst? * )
                    if (StrLIComp(@pname[length(pname)-Length('.msi')+1],'.ms',Length('.ms'))=0)
                     then
                      ext:='';*)

                  if (StrLIComp(@pname[length(pname)-Length('.???')+1],'.',Length('.'))=0) then
                      ext:='';


                end;
              pname:=pname+ext;
            end;

          (* time_1 is often zero. *)
          decode_time(time_2,defaulttime,item_time);

          Write(path,pname);
          for z1:=Length(path)+Length(pname) to 54 do Write(' ');

          case property_type of
            1:Write(' <Directory> ');
            2:Write(' <File>      ');
            5:Write(' <RootEntry> ');
          else
              WriteLn(' <Error>');
          end;

          WriteLn(property_size:11);

          (* root entry - read array of small blocks *)
          if property_type=5 then
            begin
              smallblockarraysize:=property_size;
              (* small block data *)
              GetMem(smallblockarray,smallblockarraysize);
              z1:=0;
              x:=start_block;
              while z1<smallblockarraysize do
                begin
                  j:=Min(1 shl kopf.log2_big_blocksize,smallblockarraysize-z1);
                  lies_block(smallblockarray^[z1],x,j,j);
                  Inc(z1,1 shl kopf.log2_big_blocksize);
                  x:=BAT^[x];
                end;
              pname:='';
            end;

          if property_type=2 then
            begin

              x:=start_block;
              z1:=0;

              ausgabe:=New(pBufStream,Init(zielverzeichnis+path+pname,stCreate,writebuffersize));
              rc:=ausgabe^.Status;
              if rc<>stOK then
                Error(zielverzeichnis+path+pname+': '+streamerrorcode(rc));

              olenative_x:=(Pos('Ole10Native',pname)>0) and (property_size>4);
              if olenative_x then
                begin
                  if property_size>=4096 then
                    lies_block(puffer^,start_block,16,16)
                  else
                    lies_sblock(puffer^,start_block,16,16);
                  ext:='.004';
                  erkenne_einige_dateitypen(@puffer^[4],property_size-4,ext);
                  olenative_x:=pLongint(@puffer^[0])^=property_size-4;
                end;
              if olenative_x then
                begin
                  //if StrLComp(@puffer^[4],'BM',Length('BM'))=0 then ext:='.bmp';
                  ausgabe2:=New(pBufStream,Init(zielverzeichnis+path+pname+ext,stCreate,writebuffersize));
                  rc:=ausgabe2^.Status;
                  if rc<>stOK then
                    Error(zielverzeichnis+path+pname+ext+': '+streamerrorcode(rc));
                end;


              while z1<property_size do
                begin
                  jetzt:=Min(bs,property_size-z1);
                  if property_size>=4096 then
                    begin
                      lies_block(puffer^,x,jetzt,jetzt);
                      x:=BAT^[x];
                    end
                  else
                    begin
                      lies_sblock(puffer^,x,jetzt,jetzt);
                      x:=SBAT^[x];
                    end;
                  ausgabe^.Write(puffer^,jetzt);
                  rc:=ausgabe^.Status;
                  if rc<>stOK then
                    Error(streamerrorcode(rc));

                  if olenative_x then
                    begin
                      if z1=0 then
                        ausgabe2.Write(puffer^[4],jetzt-4)
                      else
                        ausgabe2.Write(puffer^[0],jetzt-0);
                      rc:=ausgabe2^.Status;
                      if rc<>stOK then
                        Error(streamerrorcode(rc));
                    end;

                  Inc(z1,jetzt);
                end;

              ausgabe^.Free;
              if olenative_x then
                ausgabe2^.Free;

              SetFileTime(zielverzeichnis+path+pname,item_time);
            end;


          if property_type in [1,5] then
            begin
              ext:=(*'\'*)VpSysLow.SysPathSep;
              if pname='' then
                ext:=''
              else
                begin
                  {$I-}
                  MkDir(zielverzeichnis+path+pname);
                  {$I+}
                  rc:=IOResult;

                  SetDirTime(zielverzeichnis+path+pname,item_time);

                end;
              path:=path+pname+ext;
              unpack_property_recursive(first_child_propety,pathlen+Length(pname)+Length(ext),item_time);
              SetLength(path,pathlen);
            end;

          (* go next tree *)
          if next_property<>-1 then
            unpack_property_recursive(next_property,pathlen,defaulttime);

        end;

    end;

  begin

    (* Read complete directory *)
    dir:=kopf.properties_start;
    directory:=nil;
    maxdir_entry:=0;
    while dir>=0 do
      begin
        ReallocMem(directory,(maxdir_entry+4)*SizeOf(property_typ));
        lies_block(directory^[maxdir_entry],dir,4*SizeOf(property_typ),SizeOf(property_typ));
        Inc(maxdir_entry,4);
        dir:=BAT^[dir];
      end;

    GetMem(dir_used,maxdir_entry);
    FillChar(dir_used^,maxdir_entry,0);

    GetMem(puffer,1 shl Max(kopf.log2_big_blocksize,kopf.log2_small_blocksize));

    WriteLn('Filename','Type':52,'Size':19);
    path:='';
    unpack_property_recursive(0,Length(path),0);

    NilFree(Pointer(puffer));
    NilFree(Pointer(dir_used));

    if Assigned(directory) then
      NilFree(Pointer(directory));

  end; (* unpack_properties *)


{$IfDef unused}
procedure unpack_properties_linear;
  var
    dir,z1,x,n,
    bs,jetzt,j  :integer;
    prop4       :array[1..4] of property_typ;
    pname,ext   :string;
    puffer      :pByteArray;
    ausgabe     :pBufStream;

  begin
    dir:=kopf.properties_start;
    GetMem(puffer,1 shl Max(kopf.log2_big_blocksize,kopf.log2_small_blocksize));

    while dir>=0 do
      begin
        lies_block(prop4,dir,SizeOf(prop4),SizeOf(prop4));
        for n:=Low(prop4) to High(prop4) do
          with prop4[n] do
            begin

              pname:='';
              for z1:=0 to (propertyname_size div 2)-1 do
                if propertyname[z1*2+1]=#0 then
                  begin
                    if (propertyname[z1*2]=#0) and (z1=(propertyname_size div 2)-1) then
                      Continue;
                    if propertyname[z1*2]<' ' then
                      pname:=pname+'_'+Int2Str(Ord(propertyname[z1*2]))+'_'
                    else
                      pname:=pname+propertyname[z1*2];
                  end
                else
                  pname:=pname+'?';

              if property_size>=4096 then
                bs:=1 shl kopf.log2_big_blocksize
              else
                bs:=1 shl kopf.log2_small_blocksize;

              while Pos(#0,pname)<>0 do Delete(pname,Pos(#0,pname),1);

              if Pos('?',pname)<>0 then
                begin
                  pname:=Int2Hex(start_block,8);
                  ext:='.dat';

                  if (property_type=2) and (property_size>16) then (* file *)
                    begin
                      if property_size>=4096 then
                        lies_block(puffer^,start_block,16,16)
                      else
                        lies_sblock(puffer^,start_block,16,16);

                      if StrLComp(@puffer^,'MZ'  ,Length('MZ'  ))=0 then ext:='.prg';
                      if StrLComp(@puffer^,'MSCF',Length('MSCF'))=0 then ext:='.cab';
                      if pLongint(@puffer^[0])^=$00010000 then
                        if (puffer^[6]=puffer^[7]) and (puffer^[6] in [16,32,40,48]) then ext:='.ico';
                      if StrLComp(@puffer^,#$ff#$d8#$ff#$e0,4)=0 then ext:='.jpg';
                      if StrLComp(@puffer^,'BM',Length('BM'))=0 then
                        if (pLongint(@puffer^[2])^=property_size) then ext:='.bmp';
                      if pLongint(@puffer^[0])^=$00c1a5ec then ext:='.wor';
                      if pLongint(@puffer^[0])^=$0068a5dc then ext:='.wor';
                      if pLongint(@puffer^[0])^=$0065a5dc then ext:='.wor';
                      if StrLComp(@puffer^,'REGEDIT',Length('REGEDIT'))=0 then ext:='.reg';
                      if StrLComp(@puffer^,'aLuZ',Length('aLuZ'))=0 then ext:='.ins'; (* installshield *)
                      if StrLComp(@puffer^,'{\rtf',Length('{\rtf'))=0 then ext:='.rtf';
                      if StrLComp(@puffer^,#$D0#$CF#$11#$E0#$A1#$B1#$1A#$E1,Length(#$D0#$CF#$11#$E0#$A1#$B1#$1A#$E1))=0 then ext:='.ole';

                    end;

                  pname:=pname+ext;
                end;

              if pname='' then Continue;

              Write(pname);
              for z1:=Length(pname) to (64 div 2) do Write(' ');

              case property_type of
                1:Write(' <Directory> ');
                2:Write(' <File>      ');
                5:Write(' <RootEntry> ');
              else
                  WriteLn(' <Error>');
                  Continue;
              end;

              WriteLn(',',property_size:11,Int2Hex(start_block,8):11);

              (* root entry - read array of small blocks *)
              if property_type=5 then
                begin
                  smallblockarraysize:=property_size;
                  (* small block data *)
                  GetMem(smallblockarray,smallblockarraysize);
                  z1:=0;
                  x:=start_block;
                  while z1<smallblockarraysize do
                    begin
                      j:=Min(1 shl kopf.log2_big_blocksize,smallblockarraysize-z1);
                      lies_block(smallblockarray^[z1],x,j,j);
                      Inc(z1,1 shl kopf.log2_big_blocksize);
                      x:=BAT^[x];
                    end;
                end;

              if property_type=2 then
                begin

                  x:=start_block;
                  z1:=0;

                  ausgabe:=New(pBufStream,Init(zielverzeichnis+pname,stCreate,writebuffersize));
                  rc:=ausgabe^.Status;
                  if rc<>stOK then
                    Error(zielverzeichnis+pname+': '+streamerrorcode(rc));
                  while z1<property_size do
                    begin
                      jetzt:=Min(bs,property_size-z1);
                      if property_size>=4096 then
                        begin
                          lies_block(puffer^,x,jetzt,jetzt);
                          x:=BAT^[x];
                        end
                      else
                        begin
                          lies_sblock(puffer^,x,jetzt,jetzt);
                          x:=SBAT^[x];
                        end;
                      ausgabe^.Write(puffer^,jetzt);
                      rc:=ausgabe^.Status;
                      if rc<>stOK then
                        Error(streamerrorcode(rc));
                      Inc(z1,jetzt);
                    end;

                  ausgabe^.Free;
                end;

            end; (* prop4 *)
        dir:=BAT^[dir];
      end;

    NilFree(Pointer(puffer));
  end; (* unpack_properties_linear *)
{$EndIf unused}

procedure lade_BAT;
  var
    n,x,i,xb,j  :integer;
    xbat        :array[0..128-1] of integer;
  begin
    with kopf do
      begin
        GetMem(BAT,maxblock*4+512);
        FillChar(BAT^,maxblock*4+512,Byte(BAT_code_error));

        n:=0;
        repeat
          if n+1=number_of_elements_in_BAT_array then
            lies_block(BAT^[n*128],BAT_array[n],512,  4)
          else
            lies_block(BAT^[n*128],BAT_array[n],512,512);
          Inc(n);
        until (n=number_of_elements_in_BAT_array) or (n=109);

        xb:=XBAT_start;
        for x:=1 to XBAT_count do
          begin
            if xb<0 then Break;

            if x=XBAT_count then
              lies_block(xbat,xb,512,  4)
            else
              lies_block(xbat,xb,512,512);


            i:=0;
            while (n<number_of_elements_in_BAT_array) and (i<127) do
              begin
                if xbat[i]<0 then
                  Error('invalid BAT number');

                lies_block(BAT^[n*128],xbat[i],512,Min(512,(number_of_elements_in_BAT_array-n)*4));
                Inc(i);
                Inc(n);
              end;
            xb:=xbat[127]
          end;

        (* SBAT *)
        GetMem(sbat,SBAT_block_count shl log2_big_blocksize);
        FillChar(sbat^,SBAT_block_count shl log2_big_blocksize,Byte(BAT_code_error));//!!!

        x:=SBAT_start;
        for i:=1 to SBAT_block_count do
          begin
            j:=1 shl log2_big_blocksize;
            if i=SBAT_block_count then j:=4;
            lies_block(sbat^[((i-1) shl log2_big_blocksize) div SizeOf(integer)],x,1 shl log2_big_blocksize,j);
            x:=BAT^[x];
          end;

      end;
  end; (* lade_BAT *)

{$IfDef unused}
procedure unpack_all_files_anonymous;
  var
    linked      :pByteArray;
    p           :pByteArray;
    i,b         :integer;
    e           :file;

  begin
    WriteLn('Extract blocks 0..',maxblock-1);
    GetMem(linked,maxblock);
    FillChar(linked^,maxblock,0);

    for i:=0 to maxblock-1 do
      begin
        b:=BAT^[i];
        if (b>=0) and (b<maxblock) then
          begin
            if linked^[b]=1 then
              Error('Crosslinked block:'+Int2Hex(b,8));
            linked^[b]:=1;
          end
      end;

    for i:=0 to maxblock-1 do
      if  (linked^[i]=0)
      and (BAT^[i]<>BAT_code_unused)
      and (BAT^[i]<>BAT_code_special)
      and (BAT^[i]<>BAT_code_xbat)
       then
        begin
          Write('file'+Int2Hex(i,8)+'.olx ');
          Assign(e,zielverzeichnis+'file'+Int2Hex(i,8)+'.olx');
          Rewrite(e,1);
          b:=i;
          repeat
            lies_block(p,b,512,1);
            BlockWrite(e,p,512);
            b:=BAT^[b];
          until b=BAT_code_eof;
          Close(e);
          WriteLn;
        end;
    NilFree(Pointer(linked));
  end; (* unpack_all_files_anonymous *)
{$EndIf unused}

begin
  if ParamCount<>2 then
    Error('Usage: OLE2X <Sourcefile> <TargetDirectory>');

  sourcefile:=New(pBufStream,Init(ParamStr(1),stOpenRead,readbuffersize));
  rc:=sourcefile^.Status;
  if rc<>stOK then
    Error(ParamStr(1)+': '+streamerrorcode(rc));
  sourcefilesize:=sourcefile^.GetSize;

  zielverzeichnis:=ParamStr(2);
  if zielverzeichnis='' then zielverzeichnis:='.';
  if not (zielverzeichnis[Length(zielverzeichnis)] in ['\','/']) then
    zielverzeichnis:=zielverzeichnis+(*'\'*)VpSysLow.SysPathSep;

  mkdir_verschachtelt(zielverzeichnis);

  with kopf do
    begin
      lies(kopf,0,SizeOf(kopf),SizeOf(kopf));
      if StrLComp(sign,#$D0#$CF#$11#$E0#$A1#$B1#$1A#$E1,SizeOf(sign))<>0 then
        Error('not ole2 file.');
      {$IfDef LargeFileSupport}
      maxblock:=Trunc((sourcefilesize-SizeOf(kopf))/512);
      {$Else}
      maxblock:=(sourcefilesize-SizeOf(kopf)) div 512;
      {$EndIf}
      lade_BAT;
      (*unpack_properties_linear;*)
      unpack_properties;
      (*unpack_all_files_anonymous;*)
    end;
  sourcefile^.Free;

  NilFree(Pointer(BAT));
  NilFree(Pointer(SBAT));
  NilFree(Pointer(smallblockarray));

end. (* ole2x *)

