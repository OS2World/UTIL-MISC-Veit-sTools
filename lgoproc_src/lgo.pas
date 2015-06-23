{&Use32+}{$I+}

// use the define only in standalone program code, not in MMIO module!
{-$Define Diagnose_EP2_Compress}
// avoid for size and for (inoperative) license
{-$Define try_lxlite_compression}

unit lgo;

interface

uses
  Os2MM,
  Objects;

type
  pByte                 =^Byte;
  tByteArray            =array[0..High(Longint)] of Byte;
  pByteArray            =^tByteArray;
  tWordArray            =array[0..High(Longint) div 2] of SmallWord;
  pWordArray            =^tWordArray;

  pSmallWord            =^SmallWord;
  p_lgo_header          =^t_lgo_header;
  t_lgo_header          =
    record
      blocks            :array[0..3] of
        packed record
          filepos       :longint;
          packed_size   :longint;
        end;
    end;

const
  (* one plane could be 640*400 or *480. *)
  max_unpacked_size     =640*480 div 8;
  (* could assume that that compression is effective.. *)
  max_packed_size       =(max_unpacked_size div $3f)*(1+$3f);

  leerzeichen           =[' ',^I,^M,^J];

const
  pal16_color           :array[0..15,0..2] of byte=

   (*  X ->  X*255/63
       0 ->   0
      32 -> 130
      40 -> 162
      53 -> 215
      63 -> 255 *)

    ((  0,  0,  0),     (* OS2KRNL:  0, 0, 0  PMView:   0,  0,  0 *)
     (  0,  0,162),     (*           0, 0,40  (<3.11)   0,  0,170 *)
     (  0,162,  0),     (*           0,40, 0            0,170,  0 *)
     (  0,162,162),     (*           0,40,40            0,170,170 *)
     (162,  0,  0),     (*          40, 0, 0          170,  0,  0 *)
     (162,  0,162),     (*          40, 0,40          170,  0,170 *)
     (162,162,  0),     (*          40,40, 0          170, 85,  0 *)
     (130,130,130),     (*          32,32,32          128,128,128 *)
     (215,215,215),     (*          53,53,53          204,204,204 *)
     (  0,  0,255),     (*           0, 0,63           85, 85,255 *)
     (  0,255,  0),     (*           0,63, 0           85,255, 85 *)
     (  0,255,255),     (*           0,63,63           85,255,255 *)
     (255,  0,  0),     (*          63, 0, 0          255, 85, 85 *)
     (255,  0,255),     (*          63, 0,63          255, 85,255 *)
     (255,255,  0),     (*          63,63, 0          255,255, 85 *)
     (255,255,255));    (*          63,63,63          255,255,255 *)

   (* on monochrome display, the palette would be
       0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
       0, 9,25,30,13,17,34,32,53,24,39,46,29,32,55,63 of 63 *)

function EP2_Decompress(const source;var target;const source_size,target_size:longint):longint;
function EP2_Compress(const source:TByteArray;var target:TByteArray;const source_size,target_size:longint):longint;

implementation

uses
  VpUtils;

(* could also use lxlite unpacker code.. *)
function EP2_Decompress(const source;var target;const source_size,target_size:longint):longint;assembler;
  {&Uses ebx,ecx,edx,esi,edi}{&Frame+}
  var
    source_end,
    target_end          :longint;
  asm
    cld
    mov esi,[source]
    mov edi,[target]
    mov ecx,[source_size]
    mov edx,[target_size]
    add ecx,esi
    mov source_end,ecx
    add edx,edi
    mov target_end,edx
    sub ecx,ecx
    jmp @mainloop


  // 0a: fill


  @l03:
    lodsw
    mov cl,al
    test ecx,ecx

    // 00000000, 00000000

    jz @l01             // 0,0 -> Ende

    // 00000000, XXXXXXXX, YYYYYYYY

    mov al,ah           // 0,Anzahl,Muster
    rol eax,8
    mov al,ah
    rol eax,8
    mov al,ah
    shr ecx,1
    jnb @l04
    stosb
  @l04:
    shr ecx,1
    jnb @l05
    stosw
  @l05:
    repe stosd
    jmp @mainloop

    // 0: 3 subcases

  @case0:
    mov cl,al
    shr ecx,2
    jz @l03

    // XXXXXXX00, (X Byte)

    rep movsb           // (n shl 2+0),<n byte>
    jmp @mainloop

    // YYXXXX11, ZZZZYYYY, ZZZZZZZZ, (X byte)

  @case3:
    mov bl,al
    lodsw
    mov cl,bl
    shr cl,2
    and ecx,$0f         // ecx=X
    rep movsb

    mov bh,al
    shr ebx,6
    and ebx,$3F         // ebx=Y
    shr eax,4           // eax=Z
    mov edx,esi         // backup esi
    mov esi,edi
    sub esi,eax         // esi:=edi-Z
    jb @fail

    mov ecx,ebx
    rep movsb
    mov esi,edx         // restore esi

    // case lower 3 bits of..

  @mainloop:
    cmp target_end,edi
    jb @target_full
    sub eax,eax
    sub ecx,ecx
    lodsb
    mov bl,al
    and ebx,3
    jmp [Offset @fall_tabelle+ebx*4]

  @fall_tabelle:
    dd Offset @case0 // end,fill,copy
    dd Offset @case1 // copy+copy from target
    dd Offset @case2 // copy from target
    dd Offset @case3 // copy+copy from target (large version)

    // 1: ZYYYXX01,  ZZZZZZZZ,  (X byte)

  @case1:
    mov cl,al
    lodsb
    mov ah,0
    shl cl,1
    rcl ax,1            // ax=Z
    shr ecx,3
    mov dx,cx
    and cl,3            // cl=X
    repe movsb
    shr dl,2            // dl=Y+3
    add dl,3
    mov cl,dl
    mov edx,esi         // backup esi
    mov esi,edi
    sub esi,eax         // esi=edi-Z
    jb @fail
    rep movsb
    mov esi,edx         // restore esi
    jmp @mainloop

    // YYYYXX10, YYYYYYYY

  @case2:
    mov ah,[esi]
    inc esi
    shr eax,2
    mov cl,al
    and cl,3
    add cl,3            // cl=X+3
    mov edx,esi         // backup esi
    mov esi,edi
    shr eax,(4-2)
    sub esi,eax         // esi=edi-Y
    jb @fail
    rep movsb
    mov esi,edx         // restore esi
    jmp @mainloop

    // return code

  @target_full:
    cmp source_end,esi
    jb @fail
    sub eax,eax
    jmp @l02

  @l01:
    mov eax,-1

  @l02:
    dec esi
    mov ecx,edi
    sub ecx,[target]
    jmp @exit

  @fail:
    sub eax,eax
    sub ecx,ecx

  @exit:
    test eax,eax
    jz @ret
    mov eax,ecx
  @ret:
  end;

function EP2_Compress(const source:TByteArray;var target:TByteArray;const source_size,target_size:longint):longint;
  var
    source_pos,
    target_pos          :word;
    len                 :word;

  procedure generate_code(const b:byte);
    begin
      if target_pos<target_size then
        begin
          target[target_pos]:=b;
          Inc(target_pos);
        end;
    end;


  function copy_unpacked_bytes1(starting,ending_min,ending_max:integer):integer;
    var
      len               :integer;
      best_equal        :integer; (* number of bytes that can copied from unpacked in best copy operation *)
      best              :integer; (* start position for best copy operation *)
      i,j               :integer;
      store             :integer;
      best_store        :integer;
      maxj              :integer;
      dup_bytes         :boolean;

    procedure place_copy_instruction;
      var
        i               :word;
      begin
        (* generate 'copy from target' or 'dump bytes' command *)

        (* for large pure dump values.. *)
        if (best=0) and (best_equal=0) and (best_store>0) and (best_store<$3f) then
          begin
            generate_code(best_store shl 2+0); (* generate copy command *)
            for i:=1 to best_store do
              generate_code(source[starting+i-1]);
            Inc(starting,best_store);
            best_store:=0;
          end;

        (* copy commands *)
        if (best=0) and (best_equal=0) and (best_store=0) then
          begin (* no copy *)
          end
        else
        if (best<=$1ff) and (best_equal>=3) and (best_equal<=$7+3) and (best_store<=3) then
          begin (* small copy *)
            generate_code(Lo(best           shl 7
                            +(best_equal-3) shl 4
                            +best_store     shl 2
                            +1              shl 0));
            generate_code(   best           shr 1 );
          end
        else
        if (best<=$fff) and (best_equal>=3) and (best_equal<=$3+3) and (best_store=0) then
          begin (* small copy *)
            generate_code(Lo(best           shl 4
                            +(best_equal-3) shl 2
                            +2              shl 0));
            generate_code(   best           shr 4 );
          end
        else
        if (best<=$fff) and (best_equal<=$3f) and (best_store<=15)then
          begin (* large copy *)
            generate_code(Lo(best_equal     shl 6
                            +best_store     shl 2
                            +3              shl 0));
            generate_code(Lo(best           shl 4
                            +best_equal     shr 2));
            generate_code(   best           shr 4 );
          end
        else
          RunError(9999);


        for i:=1 to best_store do
          generate_code(source[starting+i-1]);

        Inc(starting,best_store+best_equal);

      end; (* place_copy_instruction *)

    function MaxEqual(const m1,m2;const max_length:longint):longint;
      {&Uses ecx,esi,edi}{&Frame-}
      asm
        mov esi,m1
        mov edi,m2
        mov ecx,max_length;
        mov eax,ecx
        test eax,eax
        jz @ret

        cld
        rep cmpsb
        sete al
        and eax,1
        lea eax,[esi+eax-1]
        sub eax,m1

      @ret:
      end;
      {$IfDef impl_pascal}
      var
        m1a             :tByteArray absolute m1;
        m2a             :tByteArray absolute m2;
        j               :word;
      begin
        j:=0;
        while j<max_length do
          begin
            if m1a[j]<>m2a[j] then
              Break;
            Inc(j)
          end;
        Result:=j;
      end;
      {$EndIf impl_pascal}


    begin (* copy_unpacked_bytes1 *)

      repeat
        len:=ending_min+1-starting;
        Result:=ending_min+1;
        if len<1 then Exit;

      //dup_bytes:=MaxEqual(source[starting],source[starting+1],len-1)=len-1;

        best_equal:=0;
        best_store:=0;
        best:=0;

        (* try to search from starting finding long equal byte sequences towards ending_max *)
        for store:=0 to 15 do
      //if (store>0) and (dup_bytes) then
      //  Break
      //else
        if (store>0) and (best_equal>=2) then
          Break
        else
        if (store>3) and (best_equal+3>store) then
          Break
        else
          for i:=1 to $fff-1 do
            if i<starting+store then
              begin
                j:=0;
                maxj:=Min(i,$3f);
                maxj:=Min(maxj,ending_max-starting+store+1);
                (*while (j<i) and (j<$3f) and (j<ending_max-starting+store+1) do*)
                (*
                while j<maxj do
                  if source[starting+store+j]=source[starting+store-i+j] then
                    Inc(j)
                  else
                    Break;*)
                j:=MaxEqual(source[starting+store  +0],
                            source[starting+store-i+0],
                            maxj);

                if best_equal<j then
                  begin
                    best_equal:=j;
                    best_store:=store;
                    best:=i;
                  end;
              end;

        if best_equal>=2 then
          begin
            {$IfDef Diagnose_EP2_Compress}
            if best_store>0 then
              WriteLn(Int2Hex(starting,4),' Dump+Copy [',Int2Hex(best_store,4),',',Int2Hex(starting-best,4),',',Int2Hex(best_equal,4),']')
            else
              WriteLn(Int2Hex(starting,4),'      Copy [     ',Int2Hex(starting-best,4),',',Int2Hex(best_equal,4),']');
            {$EndIf Diagnose_EP2_Compress}

          end

        else

          begin (* not copy from taget *)

            best_equal:=0;
            (* can not copy more than $3f *)
            best_store:=Min(len,$3f);
            (* limit blocks to 15 bytes, then try again *)
            best_store:=Min(best_store,15);
            best:=0;

            {$IfDef Diagnose_EP2_Compress}
            WriteLn(Int2Hex(starting,4),' Dump      [',Int2Hex(best_store,4),'          ]');
            {$EndIf Diagnose_EP2_Compress}

          end;

        place_copy_instruction;

        (* starting=ending_min+1 indicates 0 bytes *)
        ending_min:=Max(ending_min,starting-1);

        // do again: copy_unpacked_bytes1(starting,ending_min,ending_max)..

      until false;

    end;

  procedure copy_unpacked_bytes;
    begin
      // k”nnte auch vom Ende an probieren groáe(>=3) Teile zu finden?
      source_pos:=copy_unpacked_bytes1(source_pos-len,source_pos-1,source_size-1);
      len:=0;
    end;

{$IfDef try_lxlite_compression}

type
  pWord16       = ^SmallWord;
  pWord16Array  = ^tWord16Array;
  tWord16Array  = array[0..{32700}$ffff] of SmallWord;
var
  source_now,
  target_now    : word;

function MinL(const l1,l2:longint):longint;
  begin
    if l1<l2 then
      MinL:=l1
    else
      MinL:=l2;
  end;

procedure linearMove(const source;var target;const length:longint);assembler;
  {&Uses All}{&Frame-}
  asm
    mov esi,source
    mov edi,target
    mov ecx,length
    cld
    rep movsb
  end;

{$I LXLEP2.PAS}

{$EndIf try_lxlite_compression}

  begin (* EP2_Compress *)

{$IfDef try_lxlite_compression}
    source_pos:=0;
    target_pos:=0;
    repeat
      source_now:=source_size-source_pos;
      if source_now>4096 then source_now:=4096;
      target_now:=target_size-target_pos;
      if not PackMethod2(source[source_pos],target[target_pos],source_now,target_now) then Break;
      Inc(source_pos,source_now);
      Inc(target_pos,target_now);
      if source_pos=source_size then
        begin
          Result:=target_pos;
          Exit;
        end;
      Dec(target_pos,2);
    until false;
{$EndIf try_lxlite_compression}

    (* can not reach PMView results, but acceptable .. *)
    source_pos:=0;
    target_pos:=0;
    len:=0;

    while source_pos<source_size do
      begin

        if source_pos+3<=source_size then
          if  (source[source_pos+0]=source[source_pos+1])
          and (source[source_pos+1]=source[source_pos+2]) then
            begin

              if len<>0 then
                begin
                  copy_unpacked_bytes;
                  (* could have done work even behind source_pos for good situations *)
                  (* need to find 3 equal bytes again *)
                  Continue;
                end;

              len:=3;
              while (source_pos+len<source_size) and (len<255) do
                if source[source_pos+len-1]=source[source_pos+len] then
                  Inc(len)
                else
                  Break;
              {$IfDef Diagnose_EP2_Compress}
              WriteLn(Int2Hex(source_pos,4),' RLE       [  ',Int2Hex(source[source_pos+0],2),',',Int2Hex(len,4),'     ]');
              {$EndIf Diagnose_EP2_Compress}

              if (len<=$3f) and (source_pos>0) then
                begin
                  Inc(source_pos,len);
                  copy_unpacked_bytes;
                  len:=0;
                end;

              if (len>0) then
                begin
                  generate_code($00);
                  generate_code(len);
                  generate_code(source[source_pos+len-1]);
                  Inc(source_pos,len);
                end;
              len:=0;
              Continue; (* try next runlength *)
            end;

        (* no equal bytes, or not enough *)
        Inc(len);
        Inc(source_pos);
      end;

    copy_unpacked_bytes;
    generate_code($00);
    generate_code($00);

    if target_pos<target_size then
      Result:=target_pos
    else
      Result:=-1;
  end; (* EP2_Compress *)

end.
