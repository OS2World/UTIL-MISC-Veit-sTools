{&Use32+}{&H-}{$I+}{&Z-}
program packfiles;
(* 2002.02.02 Veit Kannegieser *)

uses
  aPLibU,
  Dos,
  os_error,
  pfformat,
  Objects,
  Strings,
  VpUtils;

const
  datum                 ='2006.01.17';

var
  controlfile           :text;
  instruction,
  outputstring          :string;
  ii                    :word;

  archive               :file;
  sr                    :SearchRec;
  sourcefile            :file;

  sizeunpackedleft,
  insize,
  outsize               :longint;

  sourcebuffer,
  targetbuffer,
  inbuffer,
  outbuffer             :pByteArray;
  workmem               :pointer;

  attrw                 :word;

  path,fname,ext        :string;


  sum_unpacked          :longint=0;
  sum_packed            :longint=0;

  redirected            :boolean;

  unpacktestbuffer      :array[0..maxfileblock-1] of byte;

  i                     :word;
  envvar                :string;

  numfilematch          :word;

procedure SyntaxError(const s:string);
  begin
    WriteLn;
    WriteLn('Sytax error. line: ',s,'!');
    Halt(99);
  end;

procedure split_filename(const s:string;var r:file83);
  var
    p,n,e               :string;
    i                   :word;
  begin
    FSplit(s,p,n,e);
    if Pos('.',e)=1 then
      Delete(e,1,Length('.'));
    if (Length(n)>8)
    or (Length(e)>3)
    or (Length(n)=0) then
      begin
        WriteLn;
        WriteLn('can only handle 8.3 file names for FAT.');
        WriteLn('"',s,'"');
        Halt(99);
      end;

    for i:=1 to Length(n) do
      n[i]:=UpCase(n[i]);
    for i:=1 to Length(e) do
      e[i]:=UpCase(e[i]);

    p:=n+e;
    for i:=1 to Length(p) do
      if p[i] in [#0..#31, '/', '\', ':', '*', '?', '"', '.', '<', '>', '|', ',', '+', '=', '[', ']', ';', '(', ')', '&', '^'] then
        begin
          WriteLn;
          WriteLn('invalid char in filename "',s,'": "',p[i],'" !');
          Halt(99);
        end;

    FillChar(r,SizeOf(r),' ');

    with r do
      begin
        Move(n[1],fname,Length(n));
        Move(e[1],ext  ,Length(e));
      end;

  end;

procedure trim(var s:string);
  begin
    while (s<>'') and (s[1] in [' ',#9]) do
      Delete(s,1,Length(' '));
    while (s<>'') and (s[Length(s)] in [' ',#9]) do
      Dec(s[0]);
  end;

function is_command(const command:string;var line:string):boolean;
  begin
    if Pos(command,line)=1 then
      begin
        is_command:=true;
        Delete(line,1,Length(command));
        trim(line);
      end
    else
      is_command:=false;
  end;

var
  rc                    :integer;

begin
  WriteLn('PackFile * V.K. * 2002.02.02..'+datum);
  redirected:=not VPUtils.IsFileHandleConsole(SysFileStdOut);

  GetMem(workmem,_aP_workmem_size(maxfileblock));
  GetMem(outbuffer,_aP_max_packed_size(maxfileblock));

  if VPUtils.IsFileHandleConsole(SysFileStdIn) and (ParamCount=0) then
    begin
      WriteLn('Usage: PACKFILE.EXE <scriptfilename>');
      Halt(1);
    end;

  Assign(controlfile,ParamStr(1));
  {$I-}
  Reset(controlfile);
  {$I+}
  rc:=IOResult;
  if rc<>0 then
    begin
      WriteLn;
      WriteLn('Can not open(read) the control file "',ParamStr(1),'", rc=',rc,'!');
      display_os_error(rc);
      Halt(rc);
    end;

  while not Eof(controlfile) do
    begin
      ReadLn(controlfile,instruction);

      i:=1;
      while i<Length(instruction) do
        begin
          if instruction[i]<>'%' then
            begin
              Inc(i);
              Continue;
            end;

          (* % gefunden, erstes Zeichen l”schen *)
          Delete(instruction,i,Length('%'));

          envvar:='';
          while i<=Length(instruction) do
            begin
              if instruction[i]='%' then
                begin
                  Delete(instruction,i,Length('%'));
                  Break;
                end;
              envvar:=envvar+instruction[i];
              Delete(instruction,i,Length('?'));
            end;
          if envvar='' then
            envvar:='%'
          else
            envvar:=GetEnv(envvar);

          Insert(envvar,instruction,i);
          Inc(i,Length(envvar));

        end;

      trim(instruction);
      if instruction='' then Continue;

      if is_command('create archive',instruction) then
        begin
          with nextpack_block do
            FillChar(next_file,SizeOf(next_file),' ');

          Assign(archive,instruction);
          {$I-}
          Rewrite(archive,1);
          {$I+}
          rc:=IOResult;

          if rc<>0 then
            begin
              WriteLn;
              WriteLn('Can not create archive file "',instruction,'", rc=',rc,'!');
              display_os_error(rc);
              Halt(rc);
            end;

          with header_block do
            begin
              bt:=bt_header;
              bl:=SizeOf(header_block);
              version:=version_string
            end;
          BlockWrite(archive,header_block,SizeOf(header_block));
        end

      else
      if is_command('next pointer',instruction) then
        begin
          split_filename(instruction,nextpack_block.next_file);
        end

      else
      if is_command('close archive',instruction) then
        with nextpack_block do
          begin
            bt:=bt_nextpack;
            bl:=SizeOf(nextpack_block);
            BlockWrite(archive,nextpack_block,bl);
            Close(archive);
          end

      else
      if is_command('add file',instruction) then
        begin
          numfilematch:=0;
          FindFirst(instruction,AnyFile-Directory,sr);
          FSplit(instruction,path,fname,ext);
          while DosError=0 do
            with file_block do
              begin

                if sr.name='EA DATA. SF' then
                  begin
                    FindNext(sr);
                    Continue;
                  end;

                bl:=SizeOf(file_block);
                bt:=bt_file;
                split_filename(sr.name,filename);
                Write('adding ',Copy(filename.fname,1,8),'.',Copy(filename.ext,1,3));

                (* open input file and read data *)
                Assign(sourcefile,path+sr.name);
                FileMode:=$40;
                GetFAttr(sourcefile,attrw);
                attr:=attrw;
                Reset(sourcefile,1);
                GetFTime(sourcefile,date_time);
                sizeunpacked:=FileSize(sourcefile);
                sizepacked:=0;
                GetMem(sourcebuffer,sizeunpacked);
                BlockRead(sourcefile,sourcebuffer^,sizeunpacked);
                Close(sourcefile);

                sizeunpackedleft:=sizeunpacked;
                inbuffer:=sourcebuffer;
                targetbuffer:=nil;

                while sizeunpackedleft<>0 do
                  begin

                    insize:=Min(maxfileblock{-$6f00},sizeunpackedleft);
                    (* pack data *)

                    outsize:=_aPsafe_pack(inbuffer^,outbuffer^,insize,workmem^,nil,nil);

                    if outsize=0 then
                      begin
                        WriteLn;
                        WriteLn('aborted.');
                        Halt(99);
                      end;

                    if _aPsafe_depack(outbuffer^,outsize,unpacktestbuffer,insize)<>insize then
                      begin
                        WriteLn;
                        WriteLn(^G'  check of compressed file failed.');
                        Halt(99);
                      end;

                    Inc(longint(inbuffer),insize);
                    Dec(sizeunpackedleft,insize);

                    ReallocMem(targetbuffer,sizepacked+outsize{}+2000000);
                    Move(outbuffer^,targetbuffer^[sizepacked],outsize);
                    Inc(sizepacked,outsize);

                    if not redirected then
                      Write(sizeunpacked-sizeunpackedleft:8,' -> ',sizepacked:8,^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h^h);

                  end; (* while sizeunpackedleft<>0 *)

                if redirected then
                  Write(sizeunpacked-sizeunpackedleft:8,' -> ',sizepacked:8);


                Inc(bl,sizepacked);
                BlockWrite(archive,file_block,SizeOf(file_block));
                (* write packed data *)

                BlockWrite(archive,targetbuffer^,sizepacked);

                (* free mem *)
                Dispose(targetbuffer);
                Dispose(sourcebuffer);

                WriteLn;
                Inc(sum_unpacked,sizeunpacked);
                Inc(sum_packed,sizepacked);
                Inc(numfilematch);
                FindNext(sr);
              end;

          FindClose(sr);
          if numfilematch=0 then
            begin
              WriteLn;
              WriteLn(^G'  no files matching "',instruction,'" found.');
              Halt(99);
            end;
        end

      else
      if is_command('output',instruction) then
        begin

          outputstring:='';
          ii:=1;
          while ii<=Length(instruction) do
            case instruction[ii] of
              '"':
                begin
                  Inc(ii);
                  while ii<=Length(instruction) do
                    begin

                      if instruction[ii]='"' then
                        begin
                          Inc(ii);
                          Break;
                        end;

                      outputstring:=outputstring+instruction[ii];
                      Inc(ii);
                    end;
                end; (* "Text" *)

              '^':
                begin
                  Inc(ii);
                  if ii>Length(instruction) then
                    SyntaxError(instruction);
                  instruction[ii]:=UpCase(instruction[ii]);
                  if not (instruction[ii] in ['A'..'Z']) then
                    SyntaxError(instruction);
                  outputstring:=outputstring+Chr(Ord(instruction[ii])-Ord('A')+Ord(^A));
                  Inc(ii);
                end; (* ^H *)

              ';':
                begin
                  outputstring:=outputstring+#13#10;
                  Inc(ii);
                end; (* ; *)

            else
              outputstring:=outputstring+instruction[ii];
              Inc(ii);

            end; (* case *)

          with output_block do
            begin
              bl:=SizeOf(output_block)-SizeOf(messagetext)+Length(outputstring)+1;
              bt:=bt_output;
              StrPCopy(messagetext,outputstring);
            end;
          BlockWrite(archive,output_block,output_block.bl);
        end

      else
      if is_command('newline',instruction) then
        begin
          with output_block do
            begin
              instruction:=#13#10;
              bl:=SizeOf(output_block)-SizeOf(messagetext)+Length(instruction)+1;
              bt:=bt_output;
              StrPCopy(messagetext,instruction);
            end;
          BlockWrite(archive,output_block,output_block.bl);
        end

      else
      if is_command('bootsector',instruction) then
        begin
          with sector_block do
            begin
              bl:=SizeOf(sector_block);
              bt:=bt_sector;
              Assign(sourcefile,instruction);
              FileMode:=$40;
              {$I-}
              Reset(sourcefile,1);
              {$I+}
              rc:=IOResult;
              if rc<>0 then
                begin
                  WriteLn;
                  WriteLn('Can not open(read) bootsector image file "',instruction,'", rc=',rc,'!');
                  display_os_error(rc);
                  Halt(rc);
                end;
              BlockRead(sourcefile,sector,SizeOf(sector));
              Close(sourcefile);
              if sector[$26]<>$29 then
                begin
                  WriteLn;
                  WriteLn(^G'  not a DOS 4+ boot sector.');
                  Halt(99);
                end;
            end;
          BlockWrite(archive,sector_block,sector_block.bl);
        end

      else
      if is_command('volumelabel',instruction) then
        with volume_block do
          begin
            bl:=SizeOf(volume_block);
            bt:=bt_volume;
            FillChar(volumelabel,SizeOf(volumelabel),' ');
            Move(instruction[1],volumelabel,Min(Length(instruction),SizeOf(volumelabel)));
            BlockWrite(archive,volume_block,bl);
          end

      else
      if is_command('delete',instruction) then
        with delete_block do
          begin
            bl:=SizeOf(delete_block);
            bt:=bt_delete;
            split_filename(instruction,delete_file);
            BlockWrite(archive,delete_block,bl);
          end

      else
      if is_command('requestdisk',instruction) then
        with requestdisk_block do
          begin
            bl:=SizeOf(requestdisk_block);
            bt:=bt_requestdisk;
            FillChar(disklabel,SizeOf(disklabel),' ');
            Move(instruction[1],disklabel,Min(Length(instruction),SizeOf(disklabel)));
            BlockWrite(archive,requestdisk_block,bl);
          end

      else
      if is_command('rem',instruction) then
        begin
        end

      else
        begin
          WriteLn;
          WriteLn('unknown command: "',instruction,'"');
          Halt(99);
        end;

    end;
  Close(controlfile);
  Dispose(outbuffer);
  Dispose(workmem);

  WriteLn('= bytes            ',sum_unpacked:8,' -> ',sum_packed:8);

end.

