// snippet from lxlite, tried to compare results
// this code is for 4K pages, so it would have to be called for 4K packets
// multiple time -> can not compress as good
// PMView:       2118 byte
// lgo.pas:      2211 byte
// this code:    2390 byte
// uncompressed 38400 byte
{$R-}
function PackMethod2(const srcData;var dstData; srcDataSize : longint; var dstDataSize : Longint) : boolean;
label skip,locEx;
var
 Chain       : pWord16Array;
 ChainHead   : pWord16Array;
 sOf,dOf,tOf,I,J,
 maxMatchLen,
 maxMatchPos : Longint;
 src         : tByteArray absolute srcData;
 dst         : tByteArray absolute dstData;

function Search : boolean; assembler;
{&uses esi,edi,ebx}{&Frame-}
asm             cld
                mov     edx,srcDataSize
                sub     edx,tOf[-4+4]
                mov     al,0
                cmp     edx,2
                jbe     @@locEx
                mov     esi,srcData
                mov     edi,esi
                add     esi,tOf[-4+4]
                mov     ax,[esi]
                and     eax,0FFFh
                shl     eax,1
                add     eax,ChainHead[-4+4]
                and     maxMatchLen[-4+4],0

@@nextSearch:   push    esi
                movsx   edi,word ptr [eax]
                cmp     edi,-1
                je      @@endOfChain
                mov     eax,edi
                shl     eax,1
                add     eax,Chain[-4+4]
                add     edi,srcData
                mov     ecx,edx
                repe    cmpsb
                jz      @@maxLen
                pop     esi
                sub     ecx,edx
                neg     ecx
                sub     edi,ecx
                dec     ecx
                cmp     ecx,maxMatchLen[-4+4]
                jbe     @@nextSearch
                sub     edi,srcData
                mov     maxMatchLen[-4+4],ecx
                mov     maxMatchPos[-4+4],edi
                mov     ebx,tOf[-4+4]
                dec     ebx
                cmp     ebx,edi                 {Prefer RL encoding since it}
                jne     @@nextSearch            {packs longer strings}
                cmp     ecx,63                  {Strings up to 63 chars are always}
                jbe     @@nextSearch            {packed effectively enough}
                push    esi
                jmp     @@endOfChain

@@maxLen:       sub     edi,edx
                sub     edi,srcData
                mov     maxMatchLen[-4+4],edx
                mov     maxMatchPos[-4+4],edi

@@endOfChain:   mov     al,0
                cmp     maxMatchLen[-4+4],3
                jb      @@noMatch
                inc     al
@@noMatch:      pop     esi
@@locEx:
end;
//{&uses none}


function dstAvail(N : Longint) : boolean;
begin
 dstAvail := dOf + N <= dstDataSize;
end;

procedure Register(sOf, Count : Longint);
var
 I : Longint;
begin
 While (Count > 0) and (sOf < pred(srcDataSize)) do
  begin
   I := pWord16(@src[sOf])^ and $FFF;
   Chain^[sOf] := ChainHead^[I];
   ChainHead^[I] := sOf;
   Inc(sOf); Dec(Count);
  end;
end;

procedure Deregister(sOf : Longint);
var
 I : Longint;
begin
 I := pWord16(@src[sOf])^ and $FFF;
 ChainHead^[I] := Chain^[sOf];
end;

begin
 PackMethod2 := FALSE;
 GetMem(Chain, srcDataSize * 2);
 GetMem(ChainHead, (1 shl 12) * 2);
 FillChar(ChainHead^, (1 shl 12) * 2, $FF);
 sOf := 0; dOf := 0;
 repeat
  tOf := sOf;
  while tOf < srcDataSize do
   if Search
    then begin
          if (maxMatchPos = pred(tOf))
           then begin
                 if tOf > sOf then
                  begin
                   Inc(maxMatchLen);
                   Dec(tOf); Deregister(tOf);
                  end;
                 if maxMatchLen = 3 then goto skip;
                 while sOf < tOf do
                  begin
                   I := MinL(tOf - sOf, 63);
                   if not dstAvail(succ(I)) then goto locEx;
                   dst[dOf] := I shl 2;
                   linearMove(src[sOf], dst[succ(dOf)], I);
                   Inc(sOf, I); Inc(dOf, succ(I));
                  end;
                 while maxMatchLen > 3 do
                  begin
                   if not dstAvail(3) then goto locEx;
                   I := MinL(maxMatchLen, 255);
                   dst[dOf] := 0;
                   dst[dOf+1] := I;
                   dst[dOf+2] := src[sOf];
                   Register(sOf, I);
                   Inc(sOf, I); Inc(dOf, 3);
                   Dec(maxMatchLen, I);
                  end;
                end
           else begin
                 if (tOf - maxMatchPos < 512) and (maxMatchLen <= 10)
                  then J := 3
                  else
                 if (maxMatchLen <= 6) then J := 0 else J := 15;
                 while (sOf < tOf - J) do
                  begin
                   I := MinL(tOf - sOf, 63);
                   if not dstAvail(succ(I)) then goto locEx;
                   dst[dOf] := I shl 2;
                   linearMove(src[sOf], dst[succ(dOf)], I);
                   Inc(sOf, I); Inc(dOf, succ(I));
                  end;
                 case byte(J) of
                  3  : begin
                        if not dstAvail(2 + tOf - sOf) then goto locEx;
                        pWord16(@dst[dOf])^ := 1 + (tOf - sOf) shl 2 + (maxMatchLen - 3) shl 4 + (tOf - maxMatchPos) shl 7;
                        linearMove(src[sOf], dst[dOf + 2], tOf - sOf);
                        Register(tOf, maxMatchLen);
                        Inc(dOf, 2 + tOf - sOf);
                        sOf := tOf + maxMatchLen;
                       end;
                  0  : begin
                        if not dstAvail(2) then goto locEx;
                        pWord16(@dst[dOf])^ := 2 + (maxMatchLen - 3) shl 2 + (tOf - maxMatchPos) shl 4;
                        Register(tOf, maxMatchLen);
                        Inc(dOf, 2);
                        sOf := tOf + maxMatchLen;
                       end;
                  15 : begin
                        if not dstAvail(3 + tOf - sOf) then goto locEx;
                        J := MinL(maxMatchLen, 63);
                        pWord16(@dst[dOf])^ := 3 + (tOf - sOf) shl 2 + (J shl 6) + (tOf - maxMatchPos) shl 12;
                        dst[dOf + 2] := (tOf - maxMatchPos) shr 4;
                        linearMove(src[sOf], dst[dOf + 3], tOf - sOf);
                        Register(tOf, J);
                        Inc(dOf, 3 + tOf - sOf);
                        sOf := tOf + J;
                       end;
                 end;
                end;
          break;
         end
    else begin
skip:     Register(tOf, 1);
          Inc(tOf);
         end;
 until tOf >= srcDataSize;
 if not dstAvail(srcDataSize - sOf + 2) then goto locEx;
 while sOf < srcDataSize do
  begin
   I := MinL(srcDataSize - sOf, 63);
   if not dstAvail(succ(I)) then goto locEx;
   dst[dOf] := I shl 2;
   linearMove(src[sOf], dst[succ(dOf)], I);
   Inc(sOf, I); Inc(dOf, succ(I));
  end;
 pWord16(@dst[dOf])^ := 0; Inc(dOf, 2);                 {Put end-of-page flag}
 (*
 if (dOf >= srcDataSize) or (dOf >= $FFC)                { OS2KRNL limit !!! }
  then goto locEx;*)
 PackMethod2 := TRUE;
 dstDataSize := dOf;
locEx:
 FreeMem(ChainHead, (1 shl 12) * 2);
 FreeMem(Chain, srcDataSize * 2);
end;
{$R+}
