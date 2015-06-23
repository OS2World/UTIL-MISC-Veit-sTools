{&Use32+}{&H-}{$I+}{&Z-}
program extract_packfiles;
(* 2002.02.02 Veit Kannegieser *)

uses
  aPLibU,
  Dos,
  os_error,
  pfformat,
  Objects,
  Strings,
  VpSysLow,
  VpUtils;


var
  d1,d2                 :file;
  posfile               :longint;

  work,
  packed_buffer         :pointer;

  unpacked_buffer       :array[1..maxfileblock] of byte;
  l                     :longint;

  filename,
  fnrandom,
  targetdir             :string;

  newline               :boolean;
  ii                    :word;

  option                :string;
  bootdisk_unpacker_mode:boolean=false;

  rc                    :word;

function convert_filename(const f:file83):string;
  var
    i,j:word;
  begin
    with f do
      begin
        i:=SizeOf(fname);
        while (i>0) and (fname[i-1]=' ') do Dec(i);
        j:=SizeOf(ext);
        while (j>0) and (ext  [j-1]=' ') do Dec(j);
        convert_filename:=Copy(fname,1,i)+'.'+Copy(ext,1,j);
      end;
  end;

function decodelabel(const l:file83):string;
  begin
    with l do
      decodelabel:=Copy(fname,1,SizeOf(fname))+Copy(ext,1,SizeOf(ext));
  end;

procedure display_drives;
  var
    d                   :char;
    db                  :longint;
    l                   :string;
    i                   :word;
  function scalesize(s:double):string;
    var
      t:string;
      i:word;
    const
      scale_table:array[0..5] of string[3]=('B','KiB','MiB','GiB','TiB','PiB');
    begin
      if s<0 then
        t:='n/a'
      else
        begin
          i:=0;
          while (i<High(scale_table)) and (s>10000) do
            begin
              s:=s/1024;
              Inc(i);
            end;
          Str(s:6:0,t);
          t:=t+' '+scale_table[i];
        end;
      while Length(t)<12 do Insert(' ',t,1);
      scalesize:=t;
    end;

  begin
    if not bootdisk_unpacker_mode then Exit;

    Write('<Press Enter key to continue>');
    ReadLn;

    WriteLn('Volume  Label                   Size        Free');
    SysDisableHardErrors;
    db:=SysGetValidDrives;
    for d:='A' to 'Z' do
      if Odd(db shr (Ord(d)-Ord('A'))) then
        begin
          Write(d,':','':6);
          l:=SysGetVolumeLabel(d);
          while Length(l)<16 do l:=l+' ';
          Write(l);
          Write(scalesize(SysDiskSizeLong(Ord(d)-Ord('A')+1)),
                scalesize(SysDiskFreeLong(Ord(d)-Ord('A')+1)));
          WriteLn;
        end;
    Write('<Press Enter key to continue>');
    ReadLn;
  end;

begin
  Randomize;

  if (ParamCount<1) or (ParamCount>3) then
    begin
      WriteLn('unpacker for "packfile" (memdisk) format.');
      WriteLn('  usage: e_pf <file_to_unpack> <target directory> [/B]');
      WriteLn('  example: e_pf a:\disk2.pf m:\tmp\ /B');
      WriteLn;
      WriteLn('  /B  switch screen output to bootdisk mode');
      Halt(1);
    end;

  filename:=ParamStr(1);
  targetdir:=ParamStr(2);
  option:=ParamStr(3);
  if (Length(option)=Length('/B')) and (option[1] in ['/','-']) and (UpCase(Option[2])='B') then
    bootdisk_unpacker_mode:=true;

  Assign(d1,filename);
  FileMode:=$40;
  {$I-}
  Reset(d1,1);
  {$I+}
  rc:=IOResult;
  if rc<>0 then
    begin
      WriteLn;
      WriteLn('Can not open(read) packfile "',filename,'", rc=',rc,'!');
      display_os_error(rc);
      display_drives;
      Halt(rc);
    end;

  while not Eof(d1) do
    begin
      BlockRead(d1,unknown_block,SizeOf(unknown_block));
      SysFileSeek(FileRec(d1).Handle,-SizeOf(unknown_block),1,posfile);

      if bootdisk_unpacker_mode then Write('.');

      case unknown_block.bt of

        bt_header:
          with header_block do
            begin
              BlockRead(d1,header_block,unknown_block.bl);
              if not bootdisk_unpacker_mode then
                WriteLn('create archive ',filename);
            end;

        bt_nextpack:
          with nextpack_block do
            begin
              BlockRead(d1,nextpack_block,unknown_block.bl);
              if not bootdisk_unpacker_mode then
                if convert_filename(next_file)<>'.' then
                  WriteLn('  next pointer ',convert_filename(next_file));
            end;

        bt_file:
          with file_block do
            begin
              BlockRead(d1,file_block,SizeOf(file_block));
              if not bootdisk_unpacker_mode then
                Write  ('  add file ',convert_filename(file_block.filename));

              Assign(d2,targetdir+convert_filename(file_block.filename));
              {$I-}
              Rewrite(d2,1);
              {$I+}
              rc:=IOResult;
              if rc<>0 then
                begin
                  WriteLn;
                  WriteLn('Can not create file ',targetdir+convert_filename(file_block.filename),', rc=',rc,'!');
                  display_os_error(rc);
                  display_drives;
                  Halt(rc);
                end;
              if file_block.sizepacked>0 then
                begin
                  GetMem(packed_buffer,file_block.sizepacked);
                  BlockRead(d1,packed_buffer^,file_block.sizepacked);
                  work:=packed_buffer;
                  while file_block.sizepacked>0 do
                    begin
                      l:=_aPsafe_depack(
                           work^,
                           file_block.sizepacked,
                           unpacked_buffer,
                           SizeOf(unpacked_buffer));
                      if l=0 then RunError(99);
                      BlockWrite(d2,unpacked_buffer,l);
                      with aplib_header(work^) do
                        begin
                          l:=header_size+packed_size;
                          Dec(file_block.sizepacked,l);
                          Inc(longint(work),l);
                        end;
                    end;
                  Dispose(packed_buffer);
                end;
              SetFTime(d2,date_time);
              Close(d2);
              SetFAttr(d2,attr);
              if not bootdisk_unpacker_mode then
                WriteLn;
            end;

        bt_output:
          with output_block do
            begin
              BlockRead(d1,output_block,unknown_block.bl);
              l:=unknown_block.bl-SizeOf(output_block)+SizeOf(messagetext)-1;
              if not bootdisk_unpacker_mode then
                begin
                  Write  ('  output ');
                  newline:=false;
                  if l>=2 then
                    if (messagetext[l-2]=#13) and (messagetext[l-1]=#10) then
                      begin
                        Dec(l,2);
                        messagetext[l]:=#0;
                        newline:=true;
                      end;
                  ii:=0;
                  while ii<l do
                    case messagetext[ii] of
                      ^A..^Z:
                        begin
                          Write('^',Chr(Ord(messagetext[ii])-Ord(^A)+Ord('A')));
                          Inc(ii);
                        end;
                    else
                      Write('"');
                      while ii<l do
                        case messagetext[ii] of
                          ^A..^Z:Break;
                        else
                          Write(messagetext[ii]);
                          Inc(ii);
                        end;
                      Write('"');
                    end;

                  if newline then Write(';');
                  WriteLn;
                end; (* not bootdisk_unpacker_mode *)
            end;

        bt_sector:
          with sector_block do
            begin
              BlockRead(d1,sector_block,unknown_block.bl);
              if not bootdisk_unpacker_mode then
                begin
                  fnrandom:=Int2StrZ(Random(9999),8)+'.sec';
                  Write  ('  bootsector ',fnrandom);
                  Assign(d2,targetdir+fnrandom);
                  {$I-}
                  Rewrite(d2,1);
                  {$I+}
                  rc:=IOResult;
                  if rc<>0 then
                    begin
                      WriteLn;
                      WriteLn('Can not create file ',targetdir+fnrandom,', rc=',rc,'!');
                      display_os_error(rc);
                      display_drives;
                      Halt(rc);
                    end;
                  BlockWrite(d2,sector,SizeOf(sector));
                  Close(d2);
                  WriteLn;
                end;
            end;

        bt_volume:
          with volume_block do
            begin
              BlockRead(d1,volume_block,unknown_block.bl);
              if not bootdisk_unpacker_mode then
                with volumelabel do
                  WriteLn('  volumelabel ',decodelabel(volumelabel));
            end;

        bt_delete:
          with delete_block do
            begin
              BlockRead(d1,delete_block,unknown_block.bl);
              if not bootdisk_unpacker_mode then
                WriteLn('  delete ',convert_filename(delete_file));
            end;

        bt_requestdisk:
          with requestdisk_block do
            begin
              BlockRead(d1,requestdisk_block,unknown_block.bl);
              if not bootdisk_unpacker_mode then
                WriteLn('  requestdisk ',decodelabel(disklabel));
            end;
      else
        SysFileSeek(FileRec(d1).Handle,+unknown_block.bl,1,posfile);
        if not bootdisk_unpacker_mode then
          WriteLn('<Unknown Command.>');
      end;
    end;

  if bootdisk_unpacker_mode then
    WriteLn
  else
    WriteLn('close archive');
  Close(d1);
end.

