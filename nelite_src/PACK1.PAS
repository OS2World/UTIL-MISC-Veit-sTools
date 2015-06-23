{&Use32+}
unit pack1; (* taken from os2exe.pas from lxlite 121vk20020320 *)

interface

uses
  Objects;

function pack1f(var buffer:pByteArray;var size:longint;const maxsize:longint;const packlevel:byte):boolean;

implementation

type
  Word16                =SmallWord;
  pWord16               =^SmallWord;

  tNEsegData            =
    packed record
      case boolean of
        TRUE  :
          (Iter :
            record
              nIter     : Word16;      { number of iterations }
              nBytes    : Word16;      { number of bytes }
              Data      : array[0..0] of Byte;{ iterated data bytes }
            end);
        FALSE :
          (Data         : array[0..0] of Byte);
    end;

procedure linearMove(var A,B; Size : Word); assembler;
  {&Uses All}{&Frame-}
    asm
      cld
      mov     esi,A
      mov     edi,B
      mov     ecx,Size
      rep     movsb
    end;


function PackMethod1(var srcData,dstData; srcDataSize : longint;
                     var dstDataSize : Longint; packLevel : byte;
                     const maxpackedsize : Longint) : boolean;
  var
   sOf,dOf,tOf,
   MatchOff,
   MatchCnt,
   MatchLen : Longint;
   src      : tByteArray absolute srcData;
   dst      : tByteArray absolute dstData;

  { Trick: In FRAME- state BP register is not altered so we can }
  { address external data via [bp+XX]; however we must address }
  { it via var[bp][-4] because compiler thinks that BP is modified }
  function Search : boolean; assembler;
  {&uses ebx,esi,edi}{&Frame-}
  asm             cld
                  mov     esi,srcData
                  mov     edi,esi
                  add     edi,tOf[-4] {!!! and so on !!!}
                  add     esi,sOf[-4]
                  xor     eax,eax
                  movzx   ecx,packLevel
                  cmp     cl,255
                  je      @@setStart
                  mov     ebx,edi
                  sub     ebx,esi
                  cmp     ebx,ecx
                  jbe     @@setStart
                  mov     eax,ebx
                  sub     eax,ecx
  @@setStart:     mov     MatchOff[-4],eax
                  add     esi,eax
  @@nextPatt:     push    esi
                  push    edi
                  mov     eax,srcDataSize
                  sub     eax,tOf[-4]
                  mov     ebx,edi
                  sub     ebx,esi
                  cmp     ebx,eax
                  ja      @@noMatch
                  xor     edx,edx
                  div     ebx
                  mov     edx,eax                 {EDX = EAX = max matches}
  @@nextMatch:    mov     ecx,ebx                 {EBX = ECX = pattern length}
                  repe    cmpsb
                  jne     @@notEQ
                  dec     eax
                  jnz     @@nextMatch
  @@notEQ:        cmp     eax,edx
                  je      @@noMatch
                  sub     eax,edx
                  neg     eax
                  inc     eax                     {EAX = number of actual matches}
                  mov     edx,ebx
                  db      $0F,$AF,$D8             {imul    ebx,eax}
                  sub     ebx,2+2
                  jc      @@noMatch
                  cmp     ebx,edx
                  jbe     @@noMatch
                  mov     MatchCnt[-4],eax
                  mov     MatchLen[-4],edx
                  pop     esi
                  pop     edi
                  mov     al,1
                  jmp     @@locEx
  @@noMatch:      pop     edi
                  pop     esi
                  inc     esi
                  inc     MatchOff[-4]
                  cmp     esi,edi
                  jb      @@nextPatt
                  mov     al,0
  @@locEx:
  end;

  function dstAvail(N : Longint) : boolean;
  begin
   dstAvail := dOf + N <= dstDataSize;
  end;

  function PutNonpackedData : boolean;
  begin
   PutNonpackedData := TRUE;
   if MatchOff > 0
    then if dstAvail(2+2+MatchOff)
          then begin
                pWord16(@dst[dOf])^ := 1; Inc(dOf, 2);
                pWord16(@dst[dOf])^ := MatchOff; Inc(dOf, 2);
                Move(src[sOf], dst[dOf], MatchOff);
                Inc(dOf, MatchOff); Inc(sOf, MatchOff);
               end
          else PutNonpackedData := FALSE;
  end;


  procedure remove_enlarged_parts;
  (* Example:
     db 'abcdefghijklm'
     db 8 dup 'A'
     db       'B'
     db 6 dup 'C'
     db '0123456789'

     is compressed to
     1*13'abcdefghijklm'+8*1'A'+1*1'B'+6*1'C'+1*10'0123456789'
     4+13               +4+1   +4+1   +4+1   +4+10        = 46

     better:
     1*13'abcdefghijklm'+8*1'A'+1*17'BCCCCCC0123456789'
     4+13               +4+1   +4+17                      = 43

     best:
     1*38'abcdefghijklmAAAAAAAABCCCCCC0123456789'
     4+38                                                 = 42            *)

    var
      dst_o,
      src_o,
      Size,
      Gain,
      o1,o2,o3,o4,
      l1,l2,l3,
      i1,i2,i3            :Longint;

    begin

      dst_o:=0;
      src_o:=0;

      repeat

        o1:=dst_o;
        if o1+4<dOf then
          with tNEsegData(dst[o1]).Iter do
            begin
              l1:=nBytes;
              i1:=nIter;
            end
          else
            Break;

        if i1>0 then
          begin
            o2:=o1+4+l1;
            if o2+4<dOf then
              with tNEsegData(dst[o2]).Iter do
                begin
                  l2:=nBytes;
                  i2:=nIter;
                end
            else
              begin
                l2:=0;
                i2:=0;
              end;

            if i2>0 then
              begin
                o3:=o2+4+l2;
                if o3+4<dOf then
                  with tNEsegData(dst[o3]).Iter do
                    begin
                      l3:=nBytes;
                      i3:=nIter;
                    end
                else
                  begin
                    l3:=0;
                    i3:=0;
                  end;

                (* optimize 3 blocks *)
                if (i1>=1) and (i2>=1) and (i3>=1) then
                  begin
                    Size:=i1*l1+i2*l2+i3*l3;
                    gain:=(4+l1+4+l2+4+l3)
                         -(4+Size);

                    if gain>=0 then
                      begin

                        (* new header *)
                        with tNEsegData(dst[dst_o]).Iter do
                          begin
                            nBytes:=Size;
                            nIter:=1;
                          end;

                        (* merged data *)
                        Move(src[src_o],dst[dst_o+4],Size);

                        (* move other compressed data *)
                        o4:=o3+4+l3;
                        Move(dst[o4],dst[o4-gain],dOf-o4);
                        Dec(dOf,gain);

                        Continue;
                      end;
                  end;
              end; (* i2>0 *)

            (* optimize 2 blocks *)
            if (i1>=1) and (i2>=1) then
              begin
                Size:=i1*l1+i2*l2;
                gain:=(4+l1+4+l2)
                     -(4+Size);

                if gain>=0 then
                  begin

                    (* new header *)
                    with tNEsegData(dst[dst_o]).Iter do
                      begin
                        nBytes:=Size;
                        nIter:=1;
                      end;

                    (* merged data *)
                    Move(src[src_o],dst[dst_o+4],Size);

                    (* move other compressed data *)
                    o3:=o2+4+l2;
                    Move(dst[o3],dst[o3-gain],dOf-o3);
                    Dec(dOf,gain);

                    Continue;
                  end;
              end;

          end; (* i1>0 *)


        Inc(dst_o,4+l1);
        Inc(src_o,i1*l1);

      until false;

    end;

  begin
   PackMethod1 := FALSE;
   sOf := 0; dOf := 0;
   repeat
    tOf := succ(sOf);
    While tOf < srcDataSize do
     begin
      if Search
       then begin
             if (not PutNonpackedData) or
                (not dstAvail(2+2+MatchLen)) then exit;
             pWord16(@dst[dOf])^ := MatchCnt; Inc(dOf, 2);
             pWord16(@dst[dOf])^ := MatchLen; Inc(dOf, 2);
             linearMove(src[sOf], dst[dOf], MatchLen);
             Inc(sOf, MatchCnt * MatchLen); Inc(dOf, MatchLen);
             break;
            end
       else Inc(tOf);
     end;
   until tOf >= srcDataSize;
   MatchOff := srcDataSize - sOf;
   if (not PutNonpackedData) or (sOf <= dOf)
    then exit;
   if not dstAvail(2) then exit;
   pWord16(@dst[dOf])^ := 0; Inc(dOf, 2);
   remove_enlarged_parts;
   {for NE format:}
   Dec(dOf, 2);
   //if (dOf >= $FFC) { OS2KRNL limit !!! }
   if (dOf >= maxpackedsize) { OS2KRNL limit !!! }
     then exit;
   dstDataSize := dOf;
   PackMethod1 := TRUE;
  end;

function pack1f(var buffer:pByteArray;var size:longint;const maxsize:longint;const packlevel:byte):boolean;
  var
    packed_buffer       :pByteArray;
    packed_size         :longint;
  begin
    pack1f:=false;
    if size<=1 then Exit;
    if maxsize<=5 then Exit;

    GetMem(packed_buffer,maxsize);
    packed_size:=maxsize;
    if PackMethod1(buffer^,packed_buffer^,size,packed_size,packlevel,maxsize-4) then
      begin
        Dispose(buffer);
        buffer:=packed_buffer;
        size:=packed_size;
        pack1f:=true;
      end
    else
      Dispose(packed_buffer);

  end;

end.

