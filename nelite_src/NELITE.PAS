{$M 2000000}
{&Use32+}{$I+}{$R+}{$X+}
{&Optimise+}
program nelite;
(* Veit Kannegieser 2002.03.22 *)

uses
  {$IfDef DPMI32}{$IfDef Debug}deb_link,{$EndIf}{$EndIf}
  Dos,
  ExeHdr,
  Objects,
  {$IfDef Os2}
  Os2Def,
  Os2Base,
  {$EndIf}
  Pack1,
  Strings,
  VpUtils,
  WinDos;

const
  datum                         ='2004.06.30';
  NE_BOSS                       =5; (* \BP\BIN\TDX.EXE *)
  ExeIdReverse                  =Ord('Z')+Ord('M') shl 8; (* unknown  *)
  ExeIdWLO                      =Ord('O')+Ord('Z') shl 8; (* WLO DLLs *)

type
  pSmallWord                    =^SmallWord;
  new_seg_array                 =array[1..$ffff] of new_seg;
  segment_array_typ             =array[1..$ffff] of
    record
      buffer                    :pByteArray;
      size                      :longint;       // ns_cbseg
      size_alloc                :longint;       // ns_minalloc
      reloc                     :pByteArray;
      relocsize                 :longint;
    end;

  reloc_array                   =
    packed record
      number                    :new_rlcinfo;
      relo                      :array[1..$ffff] of new_rlc;
    end;
  p_reloc_array                 =^reloc_array;

  entry_bundle_header           =
    packed record
      number_of_entries         :byte;
      segment_indicator         :byte;
    end;

  entry_bundle_fixed            =
    packed record
      flag                      :byte;
      offs                      :smallword;
    end;

  entry_bundle_movable          =
    packed record
      flag                      :byte;
      int3f                     :smallword;
      segment                   :byte;
      offs                      :smallword;
    end;

var
  d                             :file;
  d_size                        :longint;
  filetime                      :longint;
  fileattr                      :word;
  mz_head                       :exe;
  ne_ofs                        :longint;
  ne_head                       :new_exe;

  dos_exe                       :pByteArray;
  size_dos_exe                  :longint;

  entry_table                   :pByteArray;

  segment_table                 :^new_seg_array;
  segment_array                 :^segment_array_typ;
  resource_table                :pByteArray;
  size_resource_table           :longint;
  residentname_table            :pByteArray;
  size_residentname_table       :longint;
  nonresidentname_table         :pByteArray;
  size_nonresidentname_table    :longint;
  module_reference_table        :pByteArray;
  size_module_reference_table   :longint;
  imported_names_table          :pByteArray;
  size_imported_names_table     :longint;
  overlay                       :pByteArray;
  size_overlay                  :longint;
  overlay_start,
  overlay_start_aligned         :longint;


  inputsize,outputsize          :longint;
  packlevel                     :longint=64;
  dos_part_filename             :string;
//min_align                     :word   =1;
  min_align                     :word   =0;
  remove_entrytable             :boolean=false;
  resolve_relocations           :boolean=true;
  allow_smallheader             :boolean=true;
  copy_overlay                  :boolean=true;
  patch_add_dpl                 :boolean=false;

  patch_headermessage           :boolean=false;
  entrytable_is_used            :boolean=false;
  min_dpl                       :byte=3;

const
  dosstubmessage_windows        ='This program requires Microsoft Windows.'^M^J'$';
  dosstubmessage_os2            ='This program cannot be run in DOS mode.'^M^J'$'^@;

procedure Error(const s:string);
  begin
    WriteLn(s);
    if DebugHook then
      asm int 3 end;
    Halt(99);
  end;

procedure Load(var p:pointer;const filepos,bufferlen:longint);
  var
    rc,
    actual              :longint;
  begin
    {$I-}
    Seek(d,filepos);
    {$I+}
    rc:=IOResult;
    if rc<>0 then
      Error('Seek error '+Int2Str(rc)+' to position $'+Int2Hex(filepos,2));
    GetMem(p,bufferlen);
    BlockRead(d,p^,bufferlen,actual);
    if actual<>bufferlen then
      Error('Read error, file position $'+Int2Hex(filepos,2)+', $'+Int2Hex(bufferlen,2)+' bytes.');
  end;

procedure Save(const p:pointer;const filepos,bufferlen:longint);
  var
    pad:array[0..511] of byte;
  begin

    while filepos>d_size do
      begin
        FillChar(pad,SizeOf(pad),0);
        Save(@pad,d_size,Min(SizeOf(pad),filepos-d_size));
      end;

    if bufferlen=0 then Exit;

    Seek(d,filepos);
    BlockWrite(d,p^,bufferlen);
    d_size:=Max(d_size,filepos+bufferlen);
  end;

procedure Load_Relocations(var p:pByteArray;const filepos:longint;var bufferlen:longint);
  var
    relocation_number:new_rlcinfo;
  begin
    Seek(d,filepos);
    BlockRead(d,relocation_number,SizeOf(relocation_number));
    Seek(d,filepos);
    bufferlen:=SizeOf(relocation_number)+relocation_number.nr_nreloc*SizeOf(new_rlc);
    GetMem(p,bufferlen);
    BlockRead(d,p^,bufferlen);
  end;

procedure Load_ModuleReferenceTable(var p:pByteArray;const filepos:longint;var bufferlen:longint;const bcs:word);
  begin
    Seek(d,filepos);
    bufferlen:=bcs*2;
    GetMem(p,bufferlen);
    BlockRead(d,p^,bufferlen);
  end;

procedure Load_DOS_exe(const filename:string);
  const
    nelt_sig            :array[0..3] of char='nelt';
  var
    filenam,dir,nam,ext,
    found               :array[0..260] of char;
    isexe               :boolean;
    dpos,
    dpos_old,
    imagesize           :longint;
    heapdiff            :integer;
    ne_sig              :smallword;

  procedure IncLimit(var w:smallword;const d,min,max:word);
    var
      l:longint;
    begin
      l:=w;
      Inc(l,d);
      if l<min then l:=min;
      if l>max then l:=max;
      w:=l;
    end;

  begin
    dos_exe:=nil;
    size_dos_exe:=0;

    if filename='' then Exit;

    Write('Loading DOS executable part ');

    StrPCopy(filenam,ParamStr(0));
    FileSplit(filenam,dir,nam,ext);

    StrPCopy(filenam,filename);

    Assign(d,filename);
    FileMode:=$40; (* Read only, Deny none *)
    {$I-}
    Reset(d,1);
    {$I+}
    if IOResult<>0 then
      begin
        if StrLen(FileSearch(@found,@filenam,@dir))=0 then
          if StrLen(FileSearch(@found,@filenam,GetEnvVar('PATH')))=0 then
            Error('Dos executable "'+filename+'" not found.');
        Assign(d,found);
        Reset(d,1);
      end;

    size_dos_exe:=FileSize(d);
    if size_dos_exe=0 then
      Error('Dos executable is empty.');

    if size_dos_exe<=$20 then
      isexe:=false
    else
      begin

        BlockRead(d,mz_head,$20);
        with mz_head do
          isexe:=(eid=ExeId) or (eid=ExeIdReverse) or (eid=ExeIdWLO);

        // DOS portion already removed ?
        with mz_head do
          if (eid=NEMagic)  // NE
          or (eid=E32Magic) // LX
          or (eid=image_VXD_Signature) // LE
          or (eid=image_NT_Signature) // PE
           then
            begin
              WriteLn('None.');
              size_dos_exe:=0;
              Close(d);
              Exit;
            end;

      end;

    if isexe then
      begin
        GetMem(dos_exe,$40);
        FillChar(dos_exe^,$40,0);
        Seek(d,0);
        if size_dos_exe>=$40 then
          BlockRead(d,dos_exe^,$40)
        else
          BlockRead(d,dos_exe^,$20);
        with exe(pointer(dos_exe)^) do
          begin
            eid:=ExeId;
            if ehdrsiz<2 then Error('DOS exe header is invalid.');

            (**** patch for \bp\tdx,exe loading "packed" dpmi16 programs *)
            if not allow_smallheader then
              begin
                size_dos_exe:=pLongint(@dos_exe^[$3c])^;
                Dispose(dos_exe);
                GetMem(dos_exe,size_dos_exe);
                Seek(d,0);
                BlockRead(d,dos_exe^,size_dos_exe);
                Close(d);
                WriteLn('(unchanged) ok.');
                Exit;
              end; (***********)

            enegsum:=0;
            eovlnum:=0;
            if erelcnt=0 then
              ereloff:=$1c;
            imagesize:=epagsiz*512;
            if elast<>0 then Inc(imagesize,elast-512);
            // some linkers include the NE portion in the DOS header
            // but we really only want the stub !
            if ((ehdrsiz< 4))
            or ((ehdrsiz>=4) and (ereloff+erelcnt*4<=$3c))
            or ((ehdrsiz>=4) and (ereloff>=$40)) then
              begin
                dpos:=pLongint(@dos_exe^[$3c])^;
                if (dpos>=40) and (dpos+4<size_dos_exe) then
                  begin
                    Seek(d,dpos);
                    BlockRead(d,ne_sig,2);
                    if (ne_sig=NEMagic)  // NE
                    or (ne_sig=E32Magic) // LX
                    or (ne_sig=image_VXD_Signature) // LE
                    or (ne_sig=image_NT_Signature) // PE
                     then
                      begin
                        heapdiff:=((imagesize+$f) shr 4)
                                 -((dpos     +$f) shr 4);
                        imagesize:=dpos;
                        if eminfre<>$ffff then IncLimit(eminfre,heapdiff,0,$ffff);
                        if emaxfre<>$ffff then IncLimit(emaxfre,heapdiff,0,$ffff);
                      end;
                  end;
              end;

            Seek(d,ereloff);
            dpos:=$1c;
            if (dpos+erelcnt*4>$3c) or (not allow_smallheader) then
              dpos:=$40;
            ereloff:=dpos;
            Inc(dpos,erelcnt*4);
          end;
        ReAllocMem(dos_exe,dpos);
        if dpos>$40 then (* clean memory, if ReAllocMem does not.. *)
          FillChar(dos_exe^[$40],dpos-$40,0);
        dpos_old:=dpos;
        with exe(pointer(dos_exe)^) do
          begin
            BlockRead(d,dos_exe^[ereloff],erelcnt*4);
            Seek(d,ehdrsiz*$10);
            Dec(imagesize,ehdrsiz*$10);
            dpos:=(dpos+$f) and $fffffff0;
            if (dpos<$40) and (dpos+imagesize>$40) then
              begin
                dpos:=$40;
                (* TDUMP and IDA prefer relocation offset >= $40 *)
                if erelcnt=0 then
                  ereloff:=$40;
              end;
            ehdrsiz:=dpos shr 4;
          end;
        ReAllocMem(dos_exe,dpos+imagesize);
        if dpos_old<dpos then
          FillChar(dos_exe^[dpos_old],dpos-dpos_old,0);
        Inc(dpos,imagesize);
        with exe(pointer(dos_exe)^) do
          begin
            BlockRead(d,dos_exe^[ehdrsiz*$10],imagesize);
            size_dos_exe:=dpos;
            epagsiz:=(size_dos_exe+512-1) shr 9;
            elast:=size_dos_exe and (512-1);
          end;

        if size_dos_exe<$40 then
          begin
            ReAllocMem(dos_exe,$40);
            FillChar(dos_exe^[size_dos_exe],size_dos_exe-$40,0);
            size_dos_exe:=$40;
          end;


      end
    else
      begin
        Write('- COM->EXE ');

        // assume $100 for PSP and at least $100 for stack
        if size_dos_exe>$fe00 then
            Error('COM file is to big.');

        // very small stub if produced exe <= $3c ?
        if $20+size_dos_exe<=$3c then
          begin
            GetMem(dos_exe,$40);
            FillChar(dos_exe^,$40,0);
            Seek(d,0);
            BlockRead(d,dos_exe^[$20],size_dos_exe);
            with exe(pointer(dos_exe)^) do
              begin
                elast:=$20+size_dos_exe;                // mod 512
                epagsiz:=1;                             // <=512
                ehdrsiz:=2;                             // $20;
                eminfre:=$1000-(size_dos_exe+15) shr 4; // 64K-image
                ereloff:=$1c;
              end;
            size_dos_exe:=$40;
          end
        else // "big" com file
          begin
            // need $40 Byte Header
            GetMem(dos_exe,$40+size_dos_exe);
            FillChar(dos_exe^,$40,0);
            Seek(d,0);
            BlockRead(d,dos_exe^[$40],size_dos_exe);
            Inc(size_dos_exe,$40);
            with exe(pointer(dos_exe)^) do
              begin
                elast:=size_dos_exe and $1ff;                   // mod 512;
                epagsiz:=(size_dos_exe+511) shr 9;              // page 512;
                ehdrsiz:=4;                                     // $40;
                eminfre:=$1000-(size_dos_exe-$40+15) shr 4;     // 64K-image
                ereloff:=$40;
              end;
          end;

        // generic com to exe values
        with exe(pointer(dos_exe)^) do
          begin
            eid:=ExeId;                                 // EXE
            eiSS:=$fff0;                                // PSP
            eiSP:=$fffe;                                // end of 64K
            eiIP:=$0100;                                // .COM
            eiCS:=$fff0;                                // PSP
            emaxfre:=$ffff;                             // all available mem
            Move(nelt_sig,ever,SizeOf(nelt_sig));    // not needed ..
          end;

        end; // com to exe

    Close(d);
    WriteLn('ok.');

    if patch_headermessage then
      if Assigned(dos_exe) and (size_dos_exe>=$80) then
        if StrLComp(@dos_exe^[$4e],dosstubmessage_windows,Length(dosstubmessage_windows))=0 then
          begin
            WriteLn('Exchanging DOS message.');
            StrCopy(@dos_exe^[$4e],dosstubmessage_os2);
          end;

  end;

function Sector_to_FilePos(const sector:word):longint;
  begin
    Sector_to_FilePos:=longint(sector) shl ne_head.ne_align;
  end;

function FilePos_to_Sector(const l:longint):word;
  begin
    if l and (1 shl ne_head.ne_align-1)<>0 then Error('Align error.');
    FilePos_to_Sector:=l shr ne_head.ne_align;
  end;

procedure Align_to_Sector(var l:longint);
  begin
    if l and (1 shl ne_head.ne_align-1)<>0 then
      l:=((l shr ne_head.ne_align)+1) shl ne_head.ne_align;
  end;

procedure Load_Nametable(var p:pByteArray;{const }filepos:longint;var bufferlen:longint;const is_nonresident_name_table:boolean);
  var
    l                   :longint;
    sign                :array[0..3] of char;
  begin
    if is_nonresident_name_table
    and (inputsize<=$ffff)
    and (filepos>$ffff)
    and ((filepos and $ffff)<inputsize)
    then
      begin
        Seek(d,filepos and $ffff);
        BlockRead(d,sign,3);
        if (sign[1]='@') and (sign[2]='#') then
          begin
            filepos:=filepos and $ffff;
            WriteLn;
            Write('successfully corrected bad nonresident name table offset. ');
          end;
      end;
    Seek(d,filepos);
    bufferlen:=0;
    p:=nil;
    repeat
      // name length
      Inc(bufferlen);
      ReAllocMem(p,bufferlen);
      BlockRead(d,p^[bufferlen-1],1);
      l:=p^[bufferlen-1];
      if l=0 then Break;
      if bufferlen<>1 then l:=(l and $7f); (* jjscdrom.dmd nonresident name table,description *)
      Inc(l,2);
      ReAllocMem(p,bufferlen+l);
      BlockRead(d,p^[bufferlen],l);
      Inc(bufferlen,l);
    until false;
  end;

procedure Load_Imported_Names(var p:pByteArray;const filepos:longint;var bufferlen:longint);
  var
    l:word;
    null_count:word;
  begin
    Seek(d,filepos);
    p:=nil;
    bufferlen:=0;
    null_count:=0;
    repeat
      Inc(bufferlen);
      ReAllocMem(p,bufferlen);
      BlockRead(d,p^[bufferlen-1],1);
      l:=p^[bufferlen-1];
      if l=0 then
        begin
          Inc(null_count); (* first '' entry to separate function names and dll names ? *)
          if null_count=2 then
            begin
              Dec(bufferlen);
              Break;
            end;
        end;
      ReallocMem(p,bufferlen+l);
      BlockRead(d,p^[bufferlen],l);
      Inc(bufferlen,l);
    until false;
  end;


(* check if the first DLL import is DOSCALLS *)
function uses_dll(search_dllname:string):boolean;
  var
    z           :word;
    impname_offs:smallword;
    dllname     :string[255];
  begin
    uses_dll:=false;
    with ne_head do
      for z:=1 to ne_cmod do
        begin
          Seek(d,ne_ofs+ne_modtab+(z-1)*2);
          BlockRead(d,impname_offs,SizeOf(impname_offs));
          Seek(d,ne_ofs+ne_imptab+impname_offs);
          BlockRead(d,dllname[0],1);
          if Ord(dllname[0])=Length(search_dllname) then
            begin
              BlockRead(d,dllname[1],Ord(dllname[0]));
              if dllname=search_dllname then
                uses_dll:=true;
            end;
        end;
  end;

const
  known_wlo_dll:        array[1..9] of
    record
      dll_name          :string[8];
      description       :string[80];
    end
  =((dll_name:'GDI'     ;description:'Microsoft Windows Graphics Device Interface'                                ),
    (dll_name:'KERNEL'  ;description:'Microsoft Windows Kernel on OS/2'                                           ),
    (dll_name:'KEYBOARD';description:'Microsoft Windows Keyboard Driver on OS/2'                                  ),
    (dll_name:'PMMETA'  ;description:'PORTHOLE metafile translator driver, (c) Jeffrey Newman, (c) Microsoft Corp'),
    (dll_name:'PMWLO'   ;description:'PortHole WLO dll'                                                           ),
    (dll_name:'SOUND'   ;description:'Microsoft Windows Sound Driver on OS/2'                                     ),
    (dll_name:'SYSTEM'  ;description:'Microsoft Windows System Configuration Module on OS/2'                      ),
    (dll_name:'USER'    ;description:'Microsoft Windows User Interface on OS/2'                                   ),
    (dll_name:'WIN87EM' ;description:'WLO 1.0 Emulator Library ?.??.??'                                           ));

function is_wlo_dll(const filename:string):boolean;
  var
    p                   :PathStr;
    n                   :NameStr;
    e                   :ExtStr;
    i,j                 :word;
    desc_equal          :boolean;
    desc                :string[255];
  begin
    is_wlo_dll:=false;

    // has nonresident name table?
    if (ne_head.ne_cbnrestab=0) or (ne_head.ne_nrestab=0) then
      // no, can not have description
      Exit;

    // get name and extension
    FSplit(filename,p,n,e);

    // we only look for DLL files
    for i:=1 to Length(e) do e[i]:=UpCase(e[i]);
    if e<>'.DLL' then Exit;

    // search dll name match
    for i:=1 to Length(n) do n[i]:=UpCase(n[i]);

    for i:=Low(known_wlo_dll) to High(known_wlo_dll) do
      with known_wlo_dll[i] do
        if n=dll_name then
          begin

            // load begin of nonresident name table: description
            Seek(d,ne_head.ne_nrestab);
            FillChar(desc,SizeOf(desc),0);
            BlockRead(d,desc[0],1);
            BlockRead(d,desc[1],Min(Ord(desc[0]),ne_head.ne_cbnrestab));

            if Length(desc)=Length(description) then
              begin
                desc_equal:=true;
                for j:=1 to Length(description) do
                  desc_equal:=desc_equal and ((description[j]=desc[j]) or (description[j]='?'));
                if desc_equal then
                  begin
                    is_wlo_dll:=true;
                    Exit;
                  end;
              end;
          end;
  end;

procedure Load_NE(const filename:string);
  var
    i                   :word;
    s                   :longint;
    found_bad_segments  :boolean;
  begin
    Write('Loading "',filename,'"  ');
    Assign(d,filename);
    FileMode:=$40; (* Read only, Deny none *)
    GetFAttr(d,fileattr);
    Reset(d,1);
    GetFTime(d,filetime);

    inputsize:=FileSize(d);
    if inputsize<$40 then Error('To small.');

    BlockRead(d,mz_head,SizeOf(mz_head));
    with mz_head do
      if (eid=ExeId) or (eid=ExeIdReverse) or (eid=ExeIdWLO) then
        begin
          if ehdrsiz<2 then Error('Invalid header.');
          if erelcnt=0 then ereloff:=$1c;
          if (ereloff<$3c) and (ereloff+erelcnt*4>=$40) then Error('Not NE executable.');
          //mehr..
          Seek(d,$3c);
          BlockRead(d,ne_ofs,SizeOf(ne_ofs));
        end
      else
        ne_ofs:=0;


    if (ne_ofs<0) or (ne_ofs+SizeOf(ne_head)>inputsize) then Error('Not NE.');

    Seek(d,ne_ofs);

    BlockRead(d,ne_head,SizeOf(ne_head));
    with ne_head do
      begin
        if ne_magic<>NEMagic then Error('Not NE.');

        if ne_exetyp=NE_Os2 then
          begin

            // Alter target OS for DPMI16 applications from OS/2 to BOSS,
            // forbidd DOS header changes and packing
            if uses_dll('KERNEL') then

              // avoid dlls from WLO package, they are stamped OS/2, but uses kernel.dll..
              if not is_wlo_dll(filename) then
                begin
                  WriteLn;
                  Write  ('Changing target to BOSS.  ');
                  ne_exetyp:=NE_BOSS;
                end;

          end;

        (* wrongly linked network drivers like
           DC21X4.OS2 and CBENDIS.OS2 *)
        if ne_exetyp=NE_Windows then
          if uses_dll('DOSCALLS') then
            begin
              WriteLn;
              Write  ('Changing target to OS/2.  ');
              ne_exetyp:=NE_Os2;
              patch_headermessage:=true;
            end;

        if ne_exetyp=NE_BOSS then
          begin
            packlevel:=0;                 // loader does not know iterated data (like windows?)
            allow_smallheader:=false;     // keep headers unchanged...
            min_align:=Max(min_align,1);  // Borland Loader does not understand 0?
          end;


        if not (ne_exetyp in [NE_Os2,NE_BOSS]) then Error('Not OS/2 or BOSS Target.');
        if (ne_flags and NEIErr)=NEIErr then Error('Module is flagged as not ok.');
        ne_crc:=0;

        // load segment table
        Load(Pointer(segment_table),ne_ofs+ne_segtab,ne_cseg*SizeOf(new_seg));

        // load resource table
        if ne_rsrctab=0 then
          begin
            size_resource_table:=0;
            resource_table:=nil;
          end
        else
          begin
            size_resource_table:=ne_restab-ne_rsrctab;
            Load(pointer(resource_table),ne_ofs+ne_rsrctab,size_resource_table);
          end;

        // repair modules damaged by rc.exe i interprets ne_align=0 -> 9(512)
        found_bad_segments:=false;
        if (ne_head.ne_align=0) and (size_resource_table>0) then
          for i:=ne_cseg-(size_resource_table div 8)+1 to ne_cseg do
            with segment_table^[i] do
              if (ns_sector<>0) and (ns_sector<ne_ofs) then
                begin
                  found_bad_segments:=true;
                  WriteLn;
                  Write('Found bad segment entries, adapting for rc.exe bugs.');
                  break;
                end;

        // load resident name table
        Load_Nametable(residentname_table,ne_ofs+ne_restab,size_residentname_table,false);

        // load Module Reference Table
        if ne_modtab=0 then
          begin
            size_module_reference_table:=0;
            module_reference_table:=nil;
          end
        else
          Load_ModuleReferenceTable(module_reference_table,ne_ofs+ne_modtab,size_module_reference_table,ne_cmod);

        // load Imported Names Table
        if ne_imptab=0 then
          begin
            Error('No Imported Names Table !');
            {size_imported_names_table:=2;
            GetMem(imported_names_table,size_imported_names_table);
            FillChar(imported_names_table,size_imported_names_table,0);}
          end
        else
          begin
            {Load_Imported_Names(imported_names_table,ne_ofs+ne_imptab,size_imported_names_table);c}
            size_imported_names_table:=ne_enttab-ne_imptab;
            Load(pointer(imported_names_table),ne_ofs+ne_imptab,size_imported_names_table);
          end;


        // load entry table
        Load(Pointer(entry_table),ne_ofs+ne_enttab,ne_cbenttab);

        // load nonresident name table
        if (ne_cbnrestab=0) or (ne_nrestab=0) then
          begin
            size_nonresidentname_table:=1;
            GetMem(nonresidentname_table,size_nonresidentname_table);
            FillChar(nonresidentname_table,size_nonresidentname_table,0)
          end
        else
          begin
            Load_Nametable(nonresidentname_table,0{ne_ofs}+ne_nrestab,size_nonresidentname_table,true);
            if ne_cbnrestab<>size_nonresidentname_table then Error('Incorrect Size of non-resident name table.');
          end;

        overlay_start:=ne_nrestab+size_nonresidentname_table;

        //if ne_align=0 then ne_align:=9; {??}

        // load segments and relocation
        GetMem(segment_array,ne_cseg*SizeOf(segment_array^[1]));


        if patch_add_dpl then
          begin
            (* before
            Number  Type   Area in file    Sect Imge Aloc .hCdDDcrepPmittt
             1/0001 DATA 0000042C-00002984 010B 2558 B76A ....xx.x.xx.x..x
             2/0002 CODE 00002DD0-0000BAA8 0B74 8CD8 8CD8 ....xx.x.x......
             3/0003 CODE 0000BB24-00018CBD 2EC9 D199 D199 ....x..x.x.x....
             4/0004 CODE 00018CC8-000250CA 6332 C402 C402 ....x..x.x.x.... *)

            for i:=1 to ne_cseg do
              with segment_table^[i] do
                min_dpl:=Min(min_dpl,(ns_flags shr neShiftDpl) and 3);

            for i:=1 to ne_cseg do
              with segment_table^[i] do
                ns_flags:=(ns_flags and (not neNSDPL)) or (min_dpl shl neShiftDpl);
          end;


        for i:=1 to ne_cseg do
          with segment_table^[i],segment_array^[i] do
            begin

              if found_bad_segments then
                begin
                  if i>=ne_cseg-(size_resource_table div 8)+1 then
                    ne_head.ne_align:=9  (* resource segm,ent *)
                  else
                    ne_head.ne_align:=0; (* code/data segment *)
                end;

              if (ns_flags and neNSHuge)=neNSHuge then Error('Huge Segments not supported.');

              buffer:=nil;
              size_alloc:=ns_minalloc;
              if size_alloc=0 then size_alloc:=$10000;
              size      :=ns_cbseg   ;

              if (size=0) and (ns_sector<>0) then Size:=$10000;

              (* Does not work for Object 4 from \bp\bin\rtmres.exe
              if ns_sector=0 then
                begin
                  size      :=0;
                  size_alloc:=0;
                end; *)

              if size>size_alloc then
                Error('Segment size is larger than minium allocated size.');


              reloc:=nil;
              relocsize:=0;

              if size<>0 then
                begin
                  Load(pointer(buffer),Sector_to_FilePos(ns_sector),size);
                  overlay_start:=Max(overlay_start,Sector_to_FilePos(ns_sector)+size);
                end;

              if (ns_flags and neNSReloc)=neNSReloc then
                begin
                  Load_Relocations(reloc,Sector_to_FilePos(ns_sector)+size,relocsize);
                  overlay_start:=Max(overlay_start,Sector_to_FilePos(ns_sector)+size+relocsize);
                end;
            end;

      end;

    overlay:=nil;
    size_overlay:=inputsize-overlay_start;

    if copy_overlay and (size_overlay>0) then
      begin
        Load(Pointer(overlay),overlay_start,size_overlay);
        overlay_start_aligned:=overlay_start;Align_to_Sector(overlay_start_aligned);

        i:=0;
        while (i<size_overlay)
          and (overlay_start+i<overlay_start_aligned)
          and (overlay^[i]=0) do
            Inc(i);

        Dec(size_overlay,i);
        Move(overlay^[i],overlay^[0],size_overlay);
        ReallocMem(overlay,size_overlay);

      end
    else
      size_overlay:=0;

    Close(d);
    WriteLn;
  end;

{$IfDef OS2}
{$Cdecl+,Orgname+}
function DosReplaceModule(OldModName,NewModName,BackModName: PChar): ApiRet;
  external 'DOSCALLS' index 417;
{$Cdecl-,Orgname-}
{$EndIf OS2}

procedure Save_NE(const filename:string);
  var
    i,l,s               :longint;
    tmp                 :array[0..256] of Char;
  begin
    WriteLn('Storing "',filename,'"');

    with ne_head do
      begin
        // keep old linker version/revision number
        // ne_ver:=ne_ver;
        // ne_rev:=ne_rev;

        // kill garbage in reserved (gangload/code swap/windows version) fields
        FillChar(ne_res,SizeOf(ne_res),0);
      end;

    ne_ofs:=size_dos_exe;
    if size_dos_exe>0 then
      pLongint(@dos_exe^[$3c])^:=ne_ofs;

    if size_resource_table>0 then
      // rc.exe damages executables with alignment shift 0 (lapsres.dll..)
        if min_align<1 then min_align:=1;

    // get smallest segment shift (sometimes reported 2^0=1 is reserved for 2^9=512 ?)
    ne_head.ne_align:=min_align;
    Write('Using Alignment ');
    repeat
      l:=ne_ofs;
      Inc(l,SizeOf(ne_head));
      Inc(l,ne_head.ne_cseg*SizeOf(new_seg));
      Inc(l,size_resource_table);
      Inc(l,size_residentname_table);
      Inc(l,size_module_reference_table);
      Inc(l,size_imported_names_table);
      Inc(l,ne_head.ne_cbenttab);
      Inc(l,size_nonresidentname_table);
      for i:=1 to ne_head.ne_cseg do
        with segment_table^[i],segment_array^[i] do
          begin
            Align_to_Sector(l);

            ns_cbseg:=0;
            ns_sector:=0;

            if size<>0 then
              Inc(l,size);

            if (ns_flags and neNSReloc)=neNSReloc then
              Inc(l,relocsize);

          end;
      if (l shr ne_head.ne_align)<=$ffff then
        Break;

      // not enough, try double size
      Inc(ne_head.ne_align);

      if ne_head.ne_align>12 then
        Error('Executable is to big !');

    until false;
    WriteLn((*'/Align:',*)'2^',ne_head.ne_align);

    {$IfDef Os2}
    DosReplaceModule(StrPCopy(tmp,filename),nil,nil);
    {$EndIf}
    Assign(d,filename);
    FileMode:=$11; (* Write only, Deny read/write *)
    {$I-}
    Rewrite(d,1);
    {$I+}
    i:=IOResult;
    if i<>0 then
      begin
        WriteLn('File creating failed, code ',i);
        Halt(i);
      end;

    d_size:=0;

    // write DOS part. pointer to NE is already set
    Save(dos_exe,0,size_dos_exe);

    with ne_head do
      begin

        // save header, dummy to reserve filespace
        Save(Addr(ne_head),ne_ofs,SizeOf(ne_head));
        s:=ne_ofs;
        Inc(s,SizeOf(ne_head));

        // save Segment table, dummy to reserve filespace
        ne_segtab:=s-ne_ofs;
        Save(segment_table,ne_ofs+ne_segtab,ne_cseg*SizeOf(new_seg));
        Inc(s,ne_cseg*SizeOf(new_seg));

        // save resource table
        ne_rsrctab:=s-ne_ofs;
        Save(resource_table,ne_ofs+ne_rsrctab,size_resource_table);
        Inc(s,size_resource_table);

        // save resident name table
        ne_restab:=s-ne_ofs;
        Save(residentname_table,ne_ofs+ne_restab,size_residentname_table);
        Inc(s,size_residentname_table);

        // save module reference table
        ne_modtab:=s-ne_ofs;
        Save(module_reference_table,ne_ofs+ne_modtab,size_module_reference_table);
        Inc(s,size_module_reference_table);

        // save imported names table
        ne_imptab:=s-ne_ofs;
        Save(imported_names_table,ne_ofs+ne_imptab,size_imported_names_table);
        Inc(s,size_imported_names_table);

        // save entry table
        ne_enttab:=s-ne_ofs;
        Save(entry_table,ne_ofs+ne_enttab,ne_cbenttab);
        Inc(s,ne_cbenttab);

        // save nonresident name table
        ne_nrestab:=s-0;
        Save(nonresidentname_table,0{ne_ofs}+ne_nrestab,size_nonresidentname_table);
        Inc(s,size_nonresidentname_table);

        // save segments
        for i:=1 to ne_cseg do
          with segment_table^[i],segment_array^[i] do
            begin

              Align_to_Sector(s);
              ns_sector:=0;
              ns_cbseg   :=size       and $ffff;
              ns_minalloc:=size_alloc and $ffff;

              if size<>0 then
                begin
                  ns_sector:=FilePos_to_Sector(s);
                  Save(pointer(buffer),Sector_to_FilePos(ns_sector),size);
                  Inc(s,size);
                end;

              if (ns_flags and neNSReloc)=neNSReloc then
                begin
                  Save(reloc,Sector_to_FilePos(ns_sector)+size,relocsize);
                  Inc(s,relocsize);
                end;

            end;

        // save NE header, real data
        Save(Addr(ne_head),ne_ofs,SizeOf(ne_head));

        // save Segment table, real data
        Save(segment_table,ne_ofs+ne_segtab,ne_cseg*SizeOf(new_seg));

      end;

    s:=d_size;
    if size_overlay>0 then
      begin
        Write(size_overlay,' byte overlay data');
        Save(overlay,s,size_overlay);
        WriteLn;
      end;

    outputsize:=d_size;
    SetFTime(d,filetime);
    Close(d);
    SetFAttr(d,fileattr);
  end;

procedure Pack_NE;

  procedure unpack1(var packed_buffer:pByteArray;var size:longint;maxunpacked:longint);
    var
      unpacked  :pByteArray;
      count,len,
      s,z       :word;
    begin
      if maxunpacked=0 then
        maxunpacked:=$10000;

      GetMem(unpacked,maxunpacked);
      s:=0;
      z:=0;
      while s<>size do
        begin
          if size-s<2 then Error('Unexpected end of packed data.');
          count:=pSmallWord(@packed_buffer^[s])^;
          Inc(s,2);
          if count=0 then
            begin
              if size-s<>0 then Write('(',size-s,' byte garbage) ');
              Break;
            end;

          if size-s<2 then Error('Unexpected end of packed data.');
          len:=pSmallWord(@packed_buffer^[s])^;
          Inc(s,2);
          if len=0 then Error('packed data corrupt.');


          if size-s<len then Error('Unexpected end of packed data.');
          if z+count*len>maxunpacked then Error('packed data corrupt.');

          while count>0 do
            begin
              Move(packed_buffer^[s],unpacked^[z],len);
              Inc(z,len);
              Dec(count);
            end;

          Inc(s,len);
        end;

      Dispose(packed_buffer);
      packed_buffer:=unpacked;
      size:=z;
    end; (* unpack1 *)

  procedure remove_zeroes(var packed_buffer:pByteArray;var size:longint;const relocation_present:boolean);
    begin
      if relocation_present then
        while (size>1) and (packed_buffer^[size-1]=0) do
          Dec(size)
      else
        while (size>0) and (packed_buffer^[size-1]=0) do
          Dec(size);
      ReallocMem(packed_buffer,size);
    end;

  function search_entry_table(entry_number:word;var segment_:byte;var offs_:smallword;sourcesegment:word):boolean;

    function equal_privilege(const seg1,seg2:word):boolean;
      begin
        Result:=(segment_table^[seg1].ns_flags and neNSDPL)
               =(segment_table^[seg2].ns_flags and neNSDPL);
      end;

    var
      entry_pos:word;

    begin

      entry_pos:=0;
      while entry_pos<ne_head.ne_cbenttab do
        with entry_bundle_header(entry_table^[entry_pos]) do
          begin

            //WriteLn('Suche:',entry_number,'entry_pos=',entry_pos,' number_of_entries=',number_of_entries,' segment_indicator=',segment_indicator);

            // fix for Topspeed Modula 2 (PMHMON.EXE)
            if (number_of_entries=0) and (segment_indicator=0) then
              if entry_pos+SizeOf(entry_bundle_header)=ne_head.ne_cbenttab then
                begin
                  Dec(ne_head.ne_cbenttab,SizeOf(entry_bundle_header));
                  Continue;
                end;

            (*if number_of_entries=0 then
              Error('Empty entry bundle.');*)

            Inc(entry_pos,SizeOf(entry_bundle_header));

            (* is the searched entry_number in this package ? *)
            if entry_number<=number_of_entries then
              begin (* yes, process *)

                (* Bit 3..7 - stack copy - can not simplify *)
                if (entry_bundle_fixed(entry_table^[entry_pos]).flag and $f8)<>0 then
                  begin
                    Result:=false;
                    Exit;
                  end;

                (* Bit 3 - undefined *)
                if (entry_bundle_fixed(entry_table^[entry_pos]).flag and 4)<>0 then Error('Unknown Entry flag.');

                case segment_indicator of
                  $00: // unused
                    Error('A used entry is marked unused.');

                  $01..$fd:
                    begin
                      Inc(entry_pos,(entry_number-1)*SizeOf(entry_bundle_fixed));
                      with entry_bundle_fixed(entry_table^[entry_pos]) do
                        begin

                          if not equal_privilege(sourcesegment,segment_indicator) then
                            begin
                              Result:=false;
                              Exit;
                            end;

                          segment_:=segment_indicator;
                          offs_:=offs;
                          Result:=true;
                          Exit;
                        end;
                    end;

                  $fe:
                    Error('Entry type FE.');

                  $ff:
                    begin
                      Inc(entry_pos,(entry_number-1)*SizeOf(entry_bundle_movable));
                      with entry_bundle_movable(entry_table^[entry_pos]) do
                        begin

                          if not equal_privilege(sourcesegment,segment) then
                            begin
                              Result:=false;
                              Exit;
                            end;

                          segment_:=segment;
                          offs_:=offs;
                          Result:=true;
                          Exit;
                        end;
                    end
                end; (* case segment_indicator *)
              end;

            (* no, goto next entry bundle *)
            case segment_indicator of
              $00:
                begin
                  (* empty - has no bundle data *)
                end;

              $01..$fd:
                begin
                  (* fixed segment numbers *)
                  Inc(entry_pos,number_of_entries*SizeOf(entry_bundle_fixed  ));
                end;

              $fe:
                begin
                  (* "a constant  defined  within the module" *)
                  Error('Entry type FE.');
                end;

              $ff:
                begin
                  (* moveable *)
                  Inc(entry_pos,number_of_entries*SizeOf(entry_bundle_movable));
                end;
            end;

            (* get closer to number of wanted entry_number *)
            Dec(entry_number,number_of_entries);

          end;

      Error('Referenced entry does not exist.');

    end; (* search_entry_table *)

  procedure apply_relocations(const segment:word);
    var
      i,j,nb:word;
      o,next:smallword;

    procedure resize_segment(const fixup_end:longint);
      begin
        with segment_table^[segment],segment_array^[segment] do
          if fixup_end>size then
            begin

              if fixup_end>size_alloc then
                Error('Fixup target offset is out of bounds.');

              ReAllocMem(buffer,fixup_end);
              // fills with zeroes, this will make it
              // likely not ffff terminated.
              FillChar(buffer^[size],fixup_end-size,0);
              size:=fixup_end;

            end;
      end; (* resize_segment *)

    procedure resolve_internal_moveable_reference(var r:new_rlc);
      begin

        with r,r.nr_union.nr_Intref do
          begin
            if (Byte(nr_flags) and NRRTyp)<>NRRInt then Exit;

            if Byte(nr_segno)=$ff then // index into entry table
              if not search_entry_table(nr_entry,Byte(nr_segno),nr_entry,segment) then
                begin
                  entrytable_is_used:=true;
                  Exit;
                end;

            if (Byte(nr_segno)<1              )
            or (Byte(nr_segno)>ne_head.ne_cseg) then
              begin
                {Error('Fixup points to invalid segment.');}
                (* \BP\BIN\BPC.EXE: SEG4. getested mit tdx.exe *)
                WriteLn('Warning: Fixup points to invalid segment.');
              end;


          end;
      end; (* resolve_internal_moveable_reference *)

    var
      number_of_offsets         :word;
      fixup_offset_table        :array[1..$ffff] of smallword;

    procedure load_chain(const o:smallword);
      var
        oo:smallword;
        i:word;
      begin
        oo:=o;
        with segment_array^[segment] do
          repeat
            fixup_offset_table[number_of_offsets+1]:=$ffff;
            i:=1;
            while (i<=number_of_offsets)
              and (fixup_offset_table[i]<oo) do
                Inc(i);
            if fixup_offset_table[i]=oo then Error('Double fixup !');
            Move(fixup_offset_table[i],fixup_offset_table[i+1],(1+number_of_offsets-i)*SizeOf(fixup_offset_table[i]));
            Inc(number_of_offsets);
            if number_of_offsets>$fff0 then Error('Fixup chain loop.');
            fixup_offset_table[i]:=oo;
            if oo+2>size then Error('Broken fixup chain.');
            oo:=pSmallWord(@buffer^[oo])^;
          until oo=$ffff;
      end; (* load_chain *)

    procedure save_chain(var o:smallword);
      var
        oo:smallword;
        i:word;
      begin
        o:=fixup_offset_table[1];
        fixup_offset_table[number_of_offsets+1]:=$ffff;
        i:=1;
        with segment_array^[segment] do
        for i:=1 to number_of_offsets do
          pSmallWord(@buffer^[fixup_offset_table[i]])^:=fixup_offset_table[i+1];
      end; (* save_chain *)



    begin (* apply_relocations *)


      with segment_table^[segment],segment_array^[segment] do
        begin

          if (ns_flags and neNSReloc)=0 then Exit;

          // simplify

          with p_reloc_array(reloc)^ do
            for i:=number.nr_nreloc downto 1 do
              with relo[i] do
                begin

                  {
                  Write(segment,'/',i:3,' TYPE=',Byte(nr_stype),
                        ' FLAGS=',Byte(nr_flags),
                        ' Source Offset=',Int2Hex(nr_soff,4));

                  if (Byte(nr_flags) and NRRTyp<>NRRInt)
                  or ((Byte(nr_flags) and NRAdd)=NRAdd) then
                    WriteLn;}

                  if (Byte(nr_flags) and not (NRAdd or NRRTyp))<>0 then Error('Reserved bit in "nr_flags" set.');

                  if (Byte(nr_flags) and NRAdd)=NRAdd then
                    Continue; // dont know

                  case Byte(nr_flags) and NRRTyp of
                    NRRInt: (* $00 Internal reference *)
                      ;

                    NRROrd: (* $01 Import by Ordinal *)
                      Continue;
                    NRRNam: (* $02 Import by name *)
                      Continue;
                    NRROSF: (* $03 Operating system fixup *)
                      Continue;
                  end;


                  {
                  WriteLn(' Segment=',Int2Hex(Byte(nr_union.nr_Intref.nr_segno),2),
                          ' Target Entry=',Int2Hex(nr_union.nr_Intref.nr_entry,4));
                  }

                  resolve_internal_moveable_reference(relo[i]);

                  // internal reference with entry table (ff) not solved-> keep it.
                  if ((Byte(nr_flags) and NRRTyp)=NRRInt) and (Byte(nr_union.nr_Intref.nr_segno)=$ff) then
                    Continue;


                  if (Byte(nr_stype) and (not NRSTyp))<>0 then Error('Reserved bit in "nr_stype" set.');

                  case byte(nr_stype) and NRSTyp of
                    NRSByt:       (* $00 lo byte (8-bits) *)
                      Continue;

                    NRSSeg:       (* $02 16-bit segment (16-bits) *)
                      begin
                        (* BP.EXE (7.0) has non-null values, prevents optimize *)
                        nr_union.nr_Intref.nr_entry:=0;
                        Continue;
                      end;

                    NRSPtr:       (* $03 16:16 pointer (32-bits) *)
                      nb:=2+2;

                    NRSOff:       (* $05 16-bit offset (16-bits) *)
                      nb:=2;

                    NRPtr48:      (* $06 16:32 pointer (48-bits) *)
                      Continue;

                    NROff32:      (* $07 32-bit offset (32-bits) *)
                      Continue; // nb:=4;

                    NRSOff32:     (* $08 32-bit self-relative offset (32-bits) *)
                      Continue; // nb:=4;

                  else
                    Error('Unknown relocation type 1');
                  end;



                  with nr_union.nr_Intref do
                    case byte(nr_stype) and NRSTyp of

                      NRSOff: // apply 16 bit offset constant and delete fixup
                        begin
                          o:=nr_soff;
                          j:=0;
                          repeat
                            Inc(j);
                            if j>size then Error('Loop in fixup chain !');

                            resize_segment(o+nb);
                            next:=pSmallWord(@buffer^[o])^;
                            pSmallWord(@buffer^[o])^:=nr_entry;
                            o:=next;
                          until o=$ffff;

                          Move(relo[i+1],relo[i],SizeOf(relo[i])*(number.nr_nreloc-i));
                          Dec(number.nr_nreloc);
                          Dec(relocsize,SizeOf(new_rlc));


                        end;

                      NRSPtr: // applay 16 bit offset portion
                              // and convert to a segment fixup
                        begin
                          o:=nr_soff;
                          Inc(nr_soff,2);
                          j:=0;
                          repeat
                            Inc(j);
                            if j>size then Error('Loop in fixup chain !');

                            resize_segment(o+nb);
                            next:=pSmallWord(@buffer^[o])^;
                            pSmallWord(@buffer^[o])^:=nr_entry;
                            if next=$ffff then
                              pSmallWord(@buffer^[o+2])^:=$ffff
                            else
                              pSmallWord(@buffer^[o+2])^:=next+2;
                            o:=next;
                          until next=$ffff;

                          // pointer to segment only
                          byte(nr_stype):=(byte(nr_stype) and (not NRSTyp)) or NRSSeg;
                          nr_entry:=0;
                        end;

                    else
                        Error('unhandled relocation');
                    end;

                end;

          // merge equal chains
          with p_reloc_array(reloc)^ do
            begin
              i:=1;
              while i<number.nr_nreloc do
                begin
                  with relo[i] do
                    if ((Byte(nr_stype) and NRSTyp)<>NRSByt)
                    and ((Byte(nr_flags) and NRAdd)<>NRAdd) then
                      begin
                        number_of_offsets:=0;
                        load_chain(nr_soff);
                        j:=number.nr_nreloc;
                        while j>i do
                          begin
                            if  (nr_stype=relo[j].nr_stype)
                            and (nr_flags=relo[j].nr_flags)
                            and (nr_union.nr_import.nr_mod =relo[j].nr_union.nr_import.nr_mod)
                            and (nr_union.nr_import.nr_proc=relo[j].nr_union.nr_import.nr_proc) then
                              begin
                                load_chain(relo[j].nr_soff);
                                // remove double entry
                                Move(relo[j+1],relo[j],SizeOf(relo[j])*(number.nr_nreloc-j));
                                Dec(number.nr_nreloc);
                                Dec(relocsize,SizeOf(new_rlc));
                              end;
                            Dec(j);
                          end;
                        save_chain(nr_soff);
                    end;
                  Inc(i);
                end; (* i<number.nr_nreloc *)
            end; (* with p_reloc_array(reloc)^ *)

          // all relocations removed ?
          // then remove the bit from segment table
          if relocsize<=SizeOf(new_rlcinfo) then
            begin
              ns_flags:=ns_flags and (not neNSReloc);
              relocsize:=0;
            end;

        end;
    end; (* apply_relocations *)

  var
    i                   :word;

  begin (* Pack_NE *)

    with ne_head do
      begin

        for i:=1 to ne_cseg do
          with segment_table^[i],segment_array^[i] do
            begin

              if (ns_flags and neNSIter)=neNSIter then
                begin
                  Write('Unpacking Segment #',i,' ');
                  unpack1(buffer,size,size_alloc);
                  ns_flags:=ns_flags and (not neNSIter);
                  WriteLn;
                end;

              (* fill with zeroes to prevent invalid access in fixup chains where high byte is zero *)
              if size<>size_alloc then
                begin
                  ReallocMem(buffer,size_alloc);
                  FillChar(buffer^[size],size_alloc-size,0); (* needed if buffer=nil ! *)
                  size:=size_alloc;
                end;

            end;

        if resolve_relocations then
          begin
            Write('Reworking relocations ');
            for i:=1 to ne_cseg do
              with segment_table^[i],segment_array^[i] do
                apply_relocations(i);
            WriteLn;
          end;

        Write('Removing trailing zeroes ');
        for i:=1 to ne_cseg do
          with segment_table^[i],segment_array^[i] do
             remove_zeroes(buffer,size,(ns_flags and neNSReloc)=neNSReloc);
        WriteLn;

        for i:=1 to ne_cseg do
          with segment_table^[i],segment_array^[i] do
            begin

              (* TRAP in OS2KRNL for packed code segments .. *)
              if (packlevel>0) and ((ns_flags and neNSData)=neNSData) then
                begin
                  Write('Packing Segment #',i,' ');
                  if pack1f(buffer,size,size_alloc,packlevel) then
                    begin
                      ns_flags:=ns_flags or neNSIter;
                      WriteLn('ok.');
                    end
                  else
                    WriteLn('failed.');
                end;
            end;

        if remove_entrytable then
          begin
            if entrytable_is_used then
              WriteLn('can not remove Entrytable, it is still used.')
            else
              begin

                WriteLn('removing Entrytable.');
                ne_cbenttab:=SizeOf(entry_bundle_header);
                ne_cmovent:=0;
                ReAllocMem(entry_table,ne_cbenttab);
                with entry_bundle_header(pointer(entry_table)^) do
                  begin
                    number_of_entries:=0;
                    segment_indicator:=0;
                  end;

              end;
          end;

      end;
  end; (* Pack_NE *)

procedure ShowUsage;
  begin
    WriteLn('NELite <Sourcefile> <Targetfile> [options]');
    WriteLn('  /P:Packlevel: 0=no compression 1..255(slow) compression');
    WriteLn('  /A:MinAlign      0 for 2^0=1 ... 9 for 2^9=512 .. byte');
    WriteLn('  /S:DOSStub       replace/remove DOS part');
    WriteLn('  /E+              remove Entry table (for *.ADD)');
    WriteLn('  /R-              dont simplify relocations');
    WriteLn('  /H-              dont optimize DOS header (Borland tools)');
    WriteLn('  /O-              dont copy overlay data');
    WriteLn('  /L+              use equal dpl for all code segemnts, fixes *.ADD for /E+');
    Halt(1);
  end;

var
  i                     :word;
  param                 :string;
  check                 :integer;
  param_1U              :char;

procedure boolean_option(var o:boolean);
  begin
    case (param+' ')[1] of
      ' ':o:=not o;
      '+':o:=true;
      '-':o:=false;
    else
      ShowUsage;
    end;
  end;

begin
  WriteLn('NELite * V.K. * 2002.03.22..'+datum);

  if ParamCount=0 then
    ShowUsage;

  dos_part_filename:=ParamStr(1);

  for i:=3 to ParamCount do
    begin

      param:=ParamStr(i);
      if not (param[1] in ['/','-']) then ShowUsage;
      Delete(param,1,1);
      if param='' then ShowUsage;

      param_1U:=UpCase(param[1]);
      Delete(param,1,1);
      while (Pos(':',param)=1) or (Pos('=',param)=1) do
        Delete(param,1,1);

      case param_1U of
        'S':
          begin
            dos_part_filename:=param;
          end;

        'P':
          begin
            Val(param,packlevel,check);
            if (check<>0) or (packlevel>255) then ShowUsage;
          end;

        'A':
          begin
            Val(param,min_align,check);
            if (check<>0) or (min_align>12) or (min_align<0) then ShowUsage;
          end;

        'E':boolean_option(remove_entrytable);
        'R':boolean_option(resolve_relocations);
        'H':boolean_option(allow_smallheader);
        'O':boolean_option(copy_overlay);
        'L':boolean_option(patch_add_dpl)

      else
        ShowUsage;
      end;

    end;

  if not resolve_relocations then remove_entrytable:=false;

  Load_NE(ParamStr(1));
  Load_DOS_exe(dos_part_filename);

  Pack_NE;

  if ParamCount>=2 then
    Save_NE(ParamStr(2))
  else
    Save_NE('OUT.DAT');

  WriteLn('gain=',inputsize-outputsize,' byte.');
end.

