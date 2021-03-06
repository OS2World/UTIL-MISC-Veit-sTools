{&Use32+}{$I+}{$N+}
program memdisk_cfg;

{$IfDef VirtualPascal}
uses
  VpUtils;
{$EndIf}

(* Veit Kannegieser 20020422 *)

const
  datum                         ='2002.04.22..2006.01.23';
  my_cfg_version                =11;

type
  string20                      =string[20];
  {$IfNDef VirtualPascal}
  smallword                     =word;
  {$EndIf}

var
  cfg_offset                    :smallword;

  (* equivalent to ..\BIOS\cfgarea1.inc *)
  memdisk_cfg_block             :
    packed record
      cfg_version               :byte;
      disksize_min              :longint;
      os2_min_memory            :longint;
      disk_additional_const     :longint;
      disk_additional_percent   :byte;
      part_name                 :array[1..20] of char;
      vol_name                  :array[1..20] of char;
      lvm_letter                :char;
      primaer                   :boolean;
      el_torito_abschalten      :boolean;
      start_disk                :char;
      update_floppy_A           :boolean;
      update_floppy_B           :boolean;
      use_serial_debug          :boolean;
      progress_indicator        :(progress_indicator_none,progress_indicator_block,progress_indicator_display_files);
      show_ecs_cd_menu          :
        (show_menu_off       ,show_menu_eCS           ,show_menu_level1           ,show_menu_invalid_3 ,
         show_menu_invalid_4 ,show_menu_eCS_cd        ,show_menu_level1_cd        ,show_menu_invalid_7 ,
         show_menu_invalid_8 ,show_menu_eCS_license   ,show_menu_level1_license   ,show_menu_invalid_11,
         show_menu_invalid_12,show_menu_eCS_cd_license,show_menu_level1_cd_license,show_menu_invalid_15);
      debugoption               :byte;
      load_font                 :boolean;
      modify_rgb_palette        :boolean;
      call_os2csm_bin           :boolean;
      update_primary_plain      :boolean;
      progress_block_char       :char;
      edit_config_sys           :boolean;
      a20_access                :byte;
      cfg_scan_lvm_letter_hd    :boolean;
      (* << add more here *)
    end;

  d                             :file;
  s                             :longint;
  c                             :char;
  a                             :comp;
  r                             :double;
  str20                         :string20;
  kontrolle                     :integer;
  long_int                      :longint;

const
  logpri                        :array[boolean] of string[10]
    =('logical','primary');
  noyes                         :array[boolean] of string[3]
    =('no'     ,'yes');

  max_fat16_sectors             =32*2*$ffff; (* 32KB * cluster bit limit *)

  inputredirected               :boolean=false;


procedure show_values(const title:string);
  begin
    with memdisk_cfg_block do
      begin

        if my_cfg_version<>cfg_version then
          begin
            WriteLn('Wrong configurator version. EXE=',my_cfg_version,' BIN=',cfg_version,'.');
            Halt(99);
          end;

        if inputredirected then Exit;

        WriteLn(title);

        (*cfg_version:cfg_version*)
        WriteLn('  minimum disk size: ',disksize_min div 1024:9,' KiB');
        WriteLn('  minimum OS memory: ',os2_min_memory/1024/1024:9:1,' MiB');
        WriteLn('  additional size  : ',disk_additional_const div 1024,' KiB');
        WriteLn('  additional %     : ',disk_additional_percent,' of remaining memory');
        WriteLn('  partition name   : "',part_name,'"');
        WriteLn('  volume name      : "',vol_name ,'"');
        WriteLn('  drive letter     : ',lvm_letter);
        WriteLn('  partition        : ',logpri[primaer]);
        WriteLn('  unhook CD EMU    : ',noyes[el_torito_abschalten]);
        Write  ('  start            : ');
        case start_disk of
          'F':Write('floppy');
          'H':Write('hard disk');
          'M':Write('memdisk');
          '*':Write('ask');
        else
              Write('?');
        end;
        WriteLn;
        WriteLn('  update from A   : ',noyes[update_floppy_A]);
        WriteLn('  update from B   : ',noyes[update_floppy_B]);
        WriteLn('  serial debug    : ',noyes[use_serial_debug]);

        Write  ('  progress        : ');
        case progress_indicator of
          progress_indicator_none:         Write('no indicator');
          progress_indicator_block:        Write('diplay ��� blocks');
          progress_indicator_display_files:Write('diplay filenames');
        else
                                           Write('?');
        end;
        WriteLn;

        Write  ('  show ecs menu   : ');
        case show_ecs_cd_menu of
 {0+0+0}  show_menu_off:                Write('no');
 {1+0+0}  show_menu_eCS:                Write('yes');
 {2+0+0}  show_menu_level1:             Write('level 1 only');
 {1+4+0}  show_menu_eCS_cd:             Write('yes, but default to CD');
 {2+4+0}  show_menu_level1_cd:          Write('level 1 only, default to CD');
 {1+0+8}  show_menu_eCS_license:        Write('yes, show license note');
 {2+0+8}  show_menu_level1_license:     Write('level 1 only, show license note');
 {1+4+8}  show_menu_eCS_cd_license:     Write('yes, but default to CD, show license note');
 {2+4+8}  show_menu_level1_cd_license:  Write('level 1 only, default to CD, show license note');
        else
                                        Write('?');
        end;
        WriteLn;

        WriteLn('  debug option    : ',debugoption);
        WriteLn('  load font       : ',noyes[load_font]);
        WriteLn('  modify palette  : ',noyes[modify_rgb_palette]);
        WriteLn('  call OS2CSM.BIN : ',noyes[call_os2csm_bin]);
        WriteLn('  plain primary   : ',noyes[update_primary_plain]);
        WriteLn('  progress char   : ',progress_block_char);
        WriteLn('  edit config.sys : ',noyes[edit_config_sys]);
        Write  ('  A20 access      : ');
        case a20_access of
          0:                            Write('BIOS');
          1:                            Write('private');
          2:                            Write('automatic selection');
        else
                                        Write('?');
        end;
        WriteLn;
        WriteLn('  scan HD LVM     : ',noyes[cfg_scan_lvm_letter_hd]);

        (* << add more here *)
      end;
  end;

function convert_boolean(const e:string;var b:boolean):boolean;
  begin
    convert_boolean:=true;
    if e='' then exit;
    if (e='1') or (e='true') or (e='on') or (e='ein') or (e='yes') or (e='ja') then
      begin
        b:=true;
        Exit;
      end;
    if (e='0') or (e='false') or (e='off') or (e='aus') or (e='no') or (e='nein') then
      begin
        b:=false;
        Exit;
      end;
    convert_boolean:=false;
  end;

procedure ReadLn2(var s20:string20;const sig:string);
  var
    r                   :string;
    valid               :boolean;
  begin
    repeat

      if inputredirected then
        if Eof(Input) then
          begin
            Close(Input);
            Assign(Input,'\DEV\CON');
            Reset(Input);
            inputredirected:=false;
          end;

      ReadLn(Input,r);

      if inputredirected then
        begin

          (* Variablenkennung wird gepr�ft *)
          if Pos('$'+sig+'$=',r)=1 then
            begin
              Delete(r,1,Length('$')+Length(sig)+Length('$='));
              valid:=true;
            end
          else
            valid:=false;
        end
      else
        valid:=true;


    until valid;

    if inputredirected then
      begin
        while (r<>'') and (r[Length(r)] in [#9,' ']) do
          {$IfDef VirtualPascal}
          SetLength(r,Length(r)-1);
          {$Else}
          Dec(r[0]);
          {$EndIf}
        WriteLn(r);
      end;

    s20:=r;
  end;

begin
  WriteLn('MemCfg * V.K. * ',datum,' * record version ',my_cfg_version);
  if (ParamCount<1) or (ParamCount>2) then
    begin
      WriteLn('Usage: MemCfg a:\memboot.bin [memcfg.rsp]');
      Halt(1);
    end;

  {$IfDef VirtualPascal}
  inputredirected:=not VPUtils.IsFileHandleConsole(SysFileStdIn);
  {$Else}
  asm
    push ds
    mov ds,prefixseg
    xor bx,bx
    les bx,[bx + $34]
    mov al,es:[bx]
    mov ah,es:[bx +1]
    pop ds
    cmp al,ah
    mov al,true
    jne @exit
    mov al,false
   @exit:
    mov inputredirected,al
  end;
  {$EndIf}

  Assign(d,ParamStr(1));
  Reset(d,1);
  s:=10;
  Seek(d,s);
  repeat
    BlockRead(d,c,1);
    Inc(s);
  until c=^Z;
  repeat
    BlockRead(d,c,1);
    Inc(s);
  until c=^@;

  BlockRead(d,cfg_offset,SizeOf(cfg_offset));
  s:=cfg_offset;
  Seek(d,s);

  BlockRead(d,memdisk_cfg_block,SizeOf(memdisk_cfg_block));

  if (not InputRedirected) and (ParamCount>=2) then
    begin
      Close(Input);
      Assign(Input,ParamStr(2));
      Reset(input);
      InputRedirected:=true;
    end;

  with memdisk_cfg_block do
    begin

      show_values('* Old values: ');

      repeat
        Write('New minimum disk size (KiB) : ');
        ReadLn2(str20,'Disk_KiB');
        r:=disksize_min/1024;
        if str20='' then
          Break;
        Val(str20,r,kontrolle);
        if r>4095*1024 then
          r:=4095*1024;
      until (kontrolle=0) and (r>=500/2) and (r<1024*255*63/2.0);
      disksize_min:=Round(r*1024);


      if disksize_min/512>max_fat16_sectors then
        WriteLn('Size to big for FAT16 - limiting partition to ',max_fat16_sectors/(2*1024):4:1,' MiB.');

      repeat
        Write('New OS minimum memory to reserve for OS (MiB), >= 16 : ');
        ReadLn2(str20,'OSminMib');
        r:=os2_min_memory/1024/1024;
        if str20='' then Break;
        Val(str20,r,kontrolle);
        if r>=4*1024 then r:=0;
      until (kontrolle=0) and (r>=16);
      os2_min_memory:=Round(r*1024*1024);

      repeat
        Write('Additional memory to use for disk, if available (KiB) : ');
        ReadLn2(str20,'ADDD_KiB');
        r:=disk_additional_const/1024;
        if str20='' then
          Break;
        Val(str20,r,kontrolle);
        if r>4095*1024 then
          r:=4095*1024;
      until (kontrolle=0) and (r>=0) and (r<1024*255*63/2);
      disk_additional_const:=Round(r*1024);

      repeat
        Write('Additional memory to use for disk, % of remaining memory (0..100) : ');
        ReadLn2(str20,'ADDD_PER');
        r:=disk_additional_percent;
        if str20='' then
          Break;
        Val(str20,r,kontrolle);
      until (kontrolle=0) and (r>=0) and (r<=100);
      disk_additional_percent:=Round(r);


      Write('New partition name : ');ReadLn2(str20,'PartName');
      if str20<>'' then
        begin
          FillChar(part_name,SizeOf(part_name),0);
          Move(str20[1],part_name,Length(str20));
        end;

      Write('New volume name    : ');ReadLn2(str20,'VolName_');
      if str20<>'' then
        begin
          FillChar(vol_name,SizeOf(part_name),0);
          Move(str20[1],vol_name,Length(str20));
        end;

      repeat
        Write('New drive letter  : ');ReadLn2(str20,'V_Letter');
        if str20='' then str20:=lvm_letter;
        if (Length(str20)=Length('Z:')) and (str20[2]=':') then
          str20:=str20[1];
        str20[1]:=UpCase(str20[1]);
      until (Length(str20)=1) and (str20[1] in ['A'{'C'}..'Z']);
      lvm_letter:=str20[1];

      repeat
        Write('partition type (1/yes=primary, 0/no=logical) : ');ReadLn2(str20,'PartType');
      until convert_boolean(str20,primaer);

      repeat
        Write('unhook CD EMU (1/yes=unhook, 0/no=keep emulation) : ');ReadLn2(str20,'TermEmul');
      until convert_boolean(str20,el_torito_abschalten);

      repeat
        Write('start ([f]loppy, [h]arddisk, [m]emdisk, [*]ask user) : ');ReadLn2(str20,'BootTarg');
        if str20='' then str20:=start_disk;
        str20[1]:=UpCase(str20[1]);
      until str20[1] in ['F','H','M','*'];
      start_disk:=str20[1];

      repeat
        Write('update from A: (1/yes=copy files, 0/no=do not look) : ');ReadLn2(str20,'Update_A');
      until convert_boolean(str20,update_floppy_A);

      repeat
        Write('update from B: (1/yes=copy files, 0/no=do not look) : ');ReadLn2(str20,'Update_B');
      until convert_boolean(str20,update_floppy_B);

      repeat
        Write('send screen output over serial line ? (1/yes, 0/no=faster) : ');ReadLn2(str20,'SerialDB');
      until convert_boolean(str20,use_serial_debug);

      repeat
        Write('progress indicator ? (0=none,1=��� blocks,2=filenames) : ');ReadLn2(str20,'Indicato');
        if str20='' then Str(Ord(progress_indicator),str20);
      until (Length(str20)=1) and (str20[1] in ['0'..'2']);
      byte(progress_indicator):=Ord(str20[1])-Ord('0');

      repeat
        Write('show ecs CD ROM menu ? (0=no 1=yes 2=level1 only; +4=CD boot default; +8=license note) : ');
        ReadLn2(str20,'eCS_Menu');
        if str20='' then
          Str(Ord(show_ecs_cd_menu),str20)
        else
        if convert_boolean(str20,boolean(show_ecs_cd_menu)) then
          Str(Ord(show_ecs_cd_menu),str20);

        Val(str20,Byte(show_ecs_cd_menu),kontrolle);

      until (kontrolle=0) and (show_ecs_cd_menu in [
        show_menu_off       ,show_menu_eCS           ,show_menu_level1           ,
                             show_menu_eCS_cd        ,show_menu_level1_cd        ,
                             show_menu_eCS_license   ,show_menu_level1_license   ,
                             show_menu_eCS_cd_license,show_menu_level1_cd_license]);

      (*cfg_version:cfg_version*)

      repeat
        Write('debug option ? (+1=show step, +2=memory test) : ');ReadLn2(str20,'DebugOpt');
        if str20='' then
          begin
            kontrolle:=0;
            long_int:=debugoption;
          end
        else
          Val(str20,long_int,kontrolle);
      until (kontrolle=0) and (long_int>=0) and (long_int<=255);
      debugoption:=long_int;

      repeat
        Write('load memboot.f?? font (for different codepage) ? (0=no, 1=yes) : ');ReadLn2(str20,'LoadFont');
      until convert_boolean(str20,load_font);

      repeat
        Write('modify RGB palette for black and white ? (0=no 1=yes) : ');ReadLn2(str20,'PaletteM');
      until convert_boolean(str20,modify_rgb_palette);

      repeat
        Write('call OS2CSM.BIN ? (0=no 1=yes) : ');ReadLn2(str20,'CALL_CSM');
      until convert_boolean(str20,call_os2csm_bin);

      repeat
        Write('Copy plain files on primary source (0=no 1=yes) : ');ReadLn2(str20,'UpdPPrim');
      until convert_boolean(str20,update_primary_plain);

      repeat
        Write('Progress block char for indicator type 1 : ');ReadLn2(str20,'ProgChar');
        if str20='' then str20:=progress_block_char;
        str20[1]:=UpCase(str20[1]);
      until true;
      progress_block_char:=str20[1];

      repeat
        Write('enable config.sys editor? (0=no 1=yes) : ');ReadLn2(str20,'ConfigEd');
      until convert_boolean(str20,edit_config_sys);

      repeat
        Write('A20/extended memory access? (0=BIOS 1=private 2=automatic) : ');ReadLn2(str20,'A20_Acc_');
        if str20='' then
          begin
            kontrolle:=0;
            long_int:=a20_access;
          end
        else
          Val(str20,long_int,kontrolle);
      until (kontrolle=0) and (long_int>=0) and (long_int<=2);
      a20_access:=long_int;

      repeat
        Write('Scan HD for LVM drive letter conflicts (0=no 1=yes) : ');ReadLn2(str20,'LVM_L_HD');
      until convert_boolean(str20,cfg_scan_lvm_letter_hd);

      (* << add more here *)


      show_values('* New values: ');


      repeat
        Write('Save (y/n) ? ');
        ReadLn2(str20,'SaveFile');
        str20:=str20+' ';
        c:=UpCase(str20[1]);
        if c='J' then c:='Y';
      until c in ['Y','N'];

    end;

  if c='Y' then
    begin
      Seek(d,s);
      BlockWrite(d,memdisk_cfg_block,SizeOf(memdisk_cfg_block));
    end;

  Close(d);
end.

