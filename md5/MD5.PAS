{&Use32+}
unit md5;

{$Define SIMPLEDECODE} {move instead of loop on intel}
{$Define NODECODE} {makes larger code, but no copy}
{$Define USE_ASM_MD5Transform}

interface

uses
  Objects;

(* Copyright (C) 1991-2, RSA Data Security, Inc. Created 1991. All
rights reserved.

License to copy and use this software is granted provided that it
is identified as the "RSA Data Security, Inc. MD5 Message-Digest
Algorithm" in all material mentioning or referencing this software
or this function.

License is also granted to make and use derivative works provided
that such works are identified as "derived from the RSA Data
Security, Inc. MD5 Message-Digest Algorithm" in all material
mentioning or referencing the derived work.

RSA Data Security, Inc. makes no representations concerning either
the merchantability of this software or the suitability of this
software for any particular purpose. It is provided "as is"
without express or implied warranty of any kind.

These notices must be retained in any copies of any part of this
documentation and/or software.
 *)

// MD5 context.
type
  UINT4                 =longint;
  digest_t              =array[0..15] of byte;
  state_t               =
    packed record
      a,b,c,d           :UINT4;
    end;
  array64byte           =array[0..63] of byte;
  array16UINT4          =array[0..15] of UINT4;

  UINT4Array            =array[0..High(word) div 4] of UINT4;
  MD5_CTX               =
    packed record
      // state (ABCD)
      state             :state_t;
      // number of bits, modulo 2^64 (lsb first)
      count             :array[0..1] of UINT4;
      // input buffer
      buffer            :array[0..63] of byte;
    end;

procedure MD5Init(var context:MD5_CTX);
procedure MD5Update(var context:MD5_CTX;const input;const inputLen:word);
procedure MD5Final(var digest:digest_t;var context:MD5_CTX);

implementation

// Encodes input (UINT4) into output (unsigned char). Assumes len is
// a multiple of 4.
procedure Encode(var output;const input;const len:word);
  {$IfNDef SIMPLEDECODE}
  var
    output_a            :TByteArray absolute output;
    input_a             :UINT4Array absolute input;
    i, j                :word;
  {$EndIf}
  begin
    {$IfDef SIMPLEDECODE}
    Move(input,output,len);
    {$Else}
    i:=0;
    j:=0;
    while j<len do
      begin
        output_a[j  ]:=Lo(input_a[i]       );
        output_a[j+1]:=Lo(input_a[i] shr  8);
        output_a[j+2]:=Lo(input_a[i] shr 16);
        output_a[j+3]:=Lo(input_a[i] shr 24);
        Inc(i);
        Inc(j,4);
      end;
    {$EndIf}
  end;

// Decodes input (unsigned char) into output (UINT4). Assumes len is
// a multiple of 4.
procedure Decode(var output;const input;const len:word);
  {$IfNDef SIMPLEDECODE}
  var
    output_a            :UINT4Array absolute output;
    input_a             :TByteArray absolute input;
    i,j                 :word;
  {$EndIf}
  begin
    {$IfDef SIMPLEDECODE}
    Move(input,output,len);
    {$Else}
    i:=0;
    j:=0;
    while j<len do
      begin
        output_a[i]:=UINT4(input_a[j  ])
                  or UINT4(input_a[j+1]) shl  8
                  or UINT4(input_a[j+2]) shl 16
                  or UINT4(input_a[j+3]) shl 24;
        Inc(i);
        Inc(j,4);
      end;
    {$EndIf}
  end;


{$IfDef USE_ASM_MD5Transform}
procedure MD5Transform(var state:state_t;const block);assembler;
  {&Frame-}{&Uses ebx,esi,edi,ebp}{and eax,ecx,edx}
  asm
    mov esi,state
    mov eax,state_t[esi].a
    mov ebx,state_t[esi].b
    mov ecx,state_t[esi].c
    mov edx,state_t[esi].d

    mov ebp,block

    // begin generated

    add eax,[ebp+0]
    add eax,$D76AA478
    mov esi,ebx
    and esi,ecx
    mov edi,ebx
    not edi
    and edi,edx
    or  esi,edi
    add eax,esi
    rol eax,7
    add eax,ebx
    add edx,[ebp+4]
    add edx,$E8C7B756
    mov esi,eax
    and esi,ebx
    mov edi,eax
    not edi
    and edi,ecx
    or  esi,edi
    add edx,esi
    rol edx,12
    add edx,eax
    add ecx,[ebp+8]
    add ecx,$242070DB
    mov esi,edx
    and esi,eax
    mov edi,edx
    not edi
    and edi,ebx
    or  esi,edi
    add ecx,esi
    rol ecx,17
    add ecx,edx
    add ebx,[ebp+12]
    add ebx,$C1BDCEEE
    mov esi,ecx
    and esi,edx
    mov edi,ecx
    not edi
    and edi,eax
    or  esi,edi
    add ebx,esi
    rol ebx,22
    add ebx,ecx
    add eax,[ebp+16]
    add eax,$F57C0FAF
    mov esi,ebx
    and esi,ecx
    mov edi,ebx
    not edi
    and edi,edx
    or  esi,edi
    add eax,esi
    rol eax,7
    add eax,ebx
    add edx,[ebp+20]
    add edx,$4787C62A
    mov esi,eax
    and esi,ebx
    mov edi,eax
    not edi
    and edi,ecx
    or  esi,edi
    add edx,esi
    rol edx,12
    add edx,eax
    add ecx,[ebp+24]
    add ecx,$A8304613
    mov esi,edx
    and esi,eax
    mov edi,edx
    not edi
    and edi,ebx
    or  esi,edi
    add ecx,esi
    rol ecx,17
    add ecx,edx
    add ebx,[ebp+28]
    add ebx,$FD469501
    mov esi,ecx
    and esi,edx
    mov edi,ecx
    not edi
    and edi,eax
    or  esi,edi
    add ebx,esi
    rol ebx,22
    add ebx,ecx
    add eax,[ebp+32]
    add eax,$698098D8
    mov esi,ebx
    and esi,ecx
    mov edi,ebx
    not edi
    and edi,edx
    or  esi,edi
    add eax,esi
    rol eax,7
    add eax,ebx
    add edx,[ebp+36]
    add edx,$8B44F7AF
    mov esi,eax
    and esi,ebx
    mov edi,eax
    not edi
    and edi,ecx
    or  esi,edi
    add edx,esi
    rol edx,12
    add edx,eax
    add ecx,[ebp+40]
    add ecx,$FFFF5BB1
    mov esi,edx
    and esi,eax
    mov edi,edx
    not edi
    and edi,ebx
    or  esi,edi
    add ecx,esi
    rol ecx,17
    add ecx,edx
    add ebx,[ebp+44]
    add ebx,$895CD7BE
    mov esi,ecx
    and esi,edx
    mov edi,ecx
    not edi
    and edi,eax
    or  esi,edi
    add ebx,esi
    rol ebx,22
    add ebx,ecx
    add eax,[ebp+48]
    add eax,$6B901122
    mov esi,ebx
    and esi,ecx
    mov edi,ebx
    not edi
    and edi,edx
    or  esi,edi
    add eax,esi
    rol eax,7
    add eax,ebx
    add edx,[ebp+52]
    add edx,$FD987193
    mov esi,eax
    and esi,ebx
    mov edi,eax
    not edi
    and edi,ecx
    or  esi,edi
    add edx,esi
    rol edx,12
    add edx,eax
    add ecx,[ebp+56]
    add ecx,$A679438E
    mov esi,edx
    and esi,eax
    mov edi,edx
    not edi
    and edi,ebx
    or  esi,edi
    add ecx,esi
    rol ecx,17
    add ecx,edx
    add ebx,[ebp+60]
    add ebx,$49B40821
    mov esi,ecx
    and esi,edx
    mov edi,ecx
    not edi
    and edi,eax
    or  esi,edi
    add ebx,esi
    rol ebx,22
    add ebx,ecx
    add eax,[ebp+4]
    add eax,$F61E2562
    mov esi,edx
    not esi
    and esi,ecx
    mov edi,ebx
    and edi,edx
    or  esi,edi
    add eax,esi
    rol eax,5
    add eax,ebx
    add edx,[ebp+24]
    add edx,$C040B340
    mov esi,ecx
    not esi
    and esi,ebx
    mov edi,eax
    and edi,ecx
    or  esi,edi
    add edx,esi
    rol edx,9
    add edx,eax
    add ecx,[ebp+44]
    add ecx,$265E5A51
    mov esi,ebx
    not esi
    and esi,eax
    mov edi,edx
    and edi,ebx
    or  esi,edi
    add ecx,esi
    rol ecx,14
    add ecx,edx
    add ebx,[ebp+0]
    add ebx,$E9B6C7AA
    mov esi,eax
    not esi
    and esi,edx
    mov edi,ecx
    and edi,eax
    or  esi,edi
    add ebx,esi
    rol ebx,20
    add ebx,ecx
    add eax,[ebp+20]
    add eax,$D62F105D
    mov esi,edx
    not esi
    and esi,ecx
    mov edi,ebx
    and edi,edx
    or  esi,edi
    add eax,esi
    rol eax,5
    add eax,ebx
    add edx,[ebp+40]
    add edx,$02441453
    mov esi,ecx
    not esi
    and esi,ebx
    mov edi,eax
    and edi,ecx
    or  esi,edi
    add edx,esi
    rol edx,9
    add edx,eax
    add ecx,[ebp+60]
    add ecx,$D8A1E681
    mov esi,ebx
    not esi
    and esi,eax
    mov edi,edx
    and edi,ebx
    or  esi,edi
    add ecx,esi
    rol ecx,14
    add ecx,edx
    add ebx,[ebp+16]
    add ebx,$E7D3FBC8
    mov esi,eax
    not esi
    and esi,edx
    mov edi,ecx
    and edi,eax
    or  esi,edi
    add ebx,esi
    rol ebx,20
    add ebx,ecx
    add eax,[ebp+36]
    add eax,$21E1CDE6
    mov esi,edx
    not esi
    and esi,ecx
    mov edi,ebx
    and edi,edx
    or  esi,edi
    add eax,esi
    rol eax,5
    add eax,ebx
    add edx,[ebp+56]
    add edx,$C33707D6
    mov esi,ecx
    not esi
    and esi,ebx
    mov edi,eax
    and edi,ecx
    or  esi,edi
    add edx,esi
    rol edx,9
    add edx,eax
    add ecx,[ebp+12]
    add ecx,$F4D50D87
    mov esi,ebx
    not esi
    and esi,eax
    mov edi,edx
    and edi,ebx
    or  esi,edi
    add ecx,esi
    rol ecx,14
    add ecx,edx
    add ebx,[ebp+32]
    add ebx,$455A14ED
    mov esi,eax
    not esi
    and esi,edx
    mov edi,ecx
    and edi,eax
    or  esi,edi
    add ebx,esi
    rol ebx,20
    add ebx,ecx
    add eax,[ebp+52]
    add eax,$A9E3E905
    mov esi,edx
    not esi
    and esi,ecx
    mov edi,ebx
    and edi,edx
    or  esi,edi
    add eax,esi
    rol eax,5
    add eax,ebx
    add edx,[ebp+8]
    add edx,$FCEFA3F8
    mov esi,ecx
    not esi
    and esi,ebx
    mov edi,eax
    and edi,ecx
    or  esi,edi
    add edx,esi
    rol edx,9
    add edx,eax
    add ecx,[ebp+28]
    add ecx,$676F02D9
    mov esi,ebx
    not esi
    and esi,eax
    mov edi,edx
    and edi,ebx
    or  esi,edi
    add ecx,esi
    rol ecx,14
    add ecx,edx
    add ebx,[ebp+48]
    add ebx,$8D2A4C8A
    mov esi,eax
    not esi
    and esi,edx
    mov edi,ecx
    and edi,eax
    or  esi,edi
    add ebx,esi
    rol ebx,20
    add ebx,ecx
    add eax,[ebp+20]
    add eax,$FFFA3942
    mov esi,ebx
    xor esi,ecx
    xor esi,edx
    add eax,esi
    rol eax,4
    add eax,ebx
    add edx,[ebp+32]
    add edx,$8771F681
    mov esi,eax
    xor esi,ebx
    xor esi,ecx
    add edx,esi
    rol edx,11
    add edx,eax
    add ecx,[ebp+44]
    add ecx,$6D9D6122
    mov esi,edx
    xor esi,eax
    xor esi,ebx
    add ecx,esi
    rol ecx,16
    add ecx,edx
    add ebx,[ebp+56]
    add ebx,$FDE5380C
    mov esi,ecx
    xor esi,edx
    xor esi,eax
    add ebx,esi
    rol ebx,23
    add ebx,ecx
    add eax,[ebp+4]
    add eax,$A4BEEA44
    mov esi,ebx
    xor esi,ecx
    xor esi,edx
    add eax,esi
    rol eax,4
    add eax,ebx
    add edx,[ebp+16]
    add edx,$4BDECFA9
    mov esi,eax
    xor esi,ebx
    xor esi,ecx
    add edx,esi
    rol edx,11
    add edx,eax
    add ecx,[ebp+28]
    add ecx,$F6BB4B60
    mov esi,edx
    xor esi,eax
    xor esi,ebx
    add ecx,esi
    rol ecx,16
    add ecx,edx
    add ebx,[ebp+40]
    add ebx,$BEBFBC70
    mov esi,ecx
    xor esi,edx
    xor esi,eax
    add ebx,esi
    rol ebx,23
    add ebx,ecx
    add eax,[ebp+52]
    add eax,$289B7EC6
    mov esi,ebx
    xor esi,ecx
    xor esi,edx
    add eax,esi
    rol eax,4
    add eax,ebx
    add edx,[ebp+0]
    add edx,$EAA127FA
    mov esi,eax
    xor esi,ebx
    xor esi,ecx
    add edx,esi
    rol edx,11
    add edx,eax
    add ecx,[ebp+12]
    add ecx,$D4EF3085
    mov esi,edx
    xor esi,eax
    xor esi,ebx
    add ecx,esi
    rol ecx,16
    add ecx,edx
    add ebx,[ebp+24]
    add ebx,$04881D05
    mov esi,ecx
    xor esi,edx
    xor esi,eax
    add ebx,esi
    rol ebx,23
    add ebx,ecx
    add eax,[ebp+36]
    add eax,$D9D4D039
    mov esi,ebx
    xor esi,ecx
    xor esi,edx
    add eax,esi
    rol eax,4
    add eax,ebx
    add edx,[ebp+48]
    add edx,$E6DB99E5
    mov esi,eax
    xor esi,ebx
    xor esi,ecx
    add edx,esi
    rol edx,11
    add edx,eax
    add ecx,[ebp+60]
    add ecx,$1FA27CF8
    mov esi,edx
    xor esi,eax
    xor esi,ebx
    add ecx,esi
    rol ecx,16
    add ecx,edx
    add ebx,[ebp+8]
    add ebx,$C4AC5665
    mov esi,ecx
    xor esi,edx
    xor esi,eax
    add ebx,esi
    rol ebx,23
    add ebx,ecx
    add eax,[ebp+0]
    add eax,$F4292244
    mov esi,edx
    not esi
    or  esi,ebx
    xor esi,ecx
    add eax,esi
    rol eax,6
    add eax,ebx
    add edx,[ebp+28]
    add edx,$432AFF97
    mov esi,ecx
    not esi
    or  esi,eax
    xor esi,ebx
    add edx,esi
    rol edx,10
    add edx,eax
    add ecx,[ebp+56]
    add ecx,$AB9423A7
    mov esi,ebx
    not esi
    or  esi,edx
    xor esi,eax
    add ecx,esi
    rol ecx,15
    add ecx,edx
    add ebx,[ebp+20]
    add ebx,$FC93A039
    mov esi,eax
    not esi
    or  esi,ecx
    xor esi,edx
    add ebx,esi
    rol ebx,21
    add ebx,ecx
    add eax,[ebp+48]
    add eax,$655B59C3
    mov esi,edx
    not esi
    or  esi,ebx
    xor esi,ecx
    add eax,esi
    rol eax,6
    add eax,ebx
    add edx,[ebp+12]
    add edx,$8F0CCC92
    mov esi,ecx
    not esi
    or  esi,eax
    xor esi,ebx
    add edx,esi
    rol edx,10
    add edx,eax
    add ecx,[ebp+40]
    add ecx,$FFEFF47D
    mov esi,ebx
    not esi
    or  esi,edx
    xor esi,eax
    add ecx,esi
    rol ecx,15
    add ecx,edx
    add ebx,[ebp+4]
    add ebx,$85845DD1
    mov esi,eax
    not esi
    or  esi,ecx
    xor esi,edx
    add ebx,esi
    rol ebx,21
    add ebx,ecx
    add eax,[ebp+32]
    add eax,$6FA87E4F
    mov esi,edx
    not esi
    or  esi,ebx
    xor esi,ecx
    add eax,esi
    rol eax,6
    add eax,ebx
    add edx,[ebp+60]
    add edx,$FE2CE6E0
    mov esi,ecx
    not esi
    or  esi,eax
    xor esi,ebx
    add edx,esi
    rol edx,10
    add edx,eax
    add ecx,[ebp+24]
    add ecx,$A3014314
    mov esi,ebx
    not esi
    or  esi,edx
    xor esi,eax
    add ecx,esi
    rol ecx,15
    add ecx,edx
    add ebx,[ebp+52]
    add ebx,$4E0811A1
    mov esi,eax
    not esi
    or  esi,ecx
    xor esi,edx
    add ebx,esi
    rol ebx,21
    add ebx,ecx
    add eax,[ebp+16]
    add eax,$F7537E82
    mov esi,edx
    not esi
    or  esi,ebx
    xor esi,ecx
    add eax,esi
    rol eax,6
    add eax,ebx
    add edx,[ebp+44]
    add edx,$BD3AF235
    mov esi,ecx
    not esi
    or  esi,eax
    xor esi,ebx
    add edx,esi
    rol edx,10
    add edx,eax
    add ecx,[ebp+8]
    add ecx,$2AD7D2BB
    mov esi,ebx
    not esi
    or  esi,edx
    xor esi,eax
    add ecx,esi
    rol ecx,15
    add ecx,edx
    add ebx,[ebp+36]
    add ebx,$EB86D391
    mov esi,eax
    not esi
    or  esi,ecx
    xor esi,edx
    add ebx,esi
    rol ebx,21
    add ebx,ecx

    // end generated

    mov esi,state
    add state_t[esi].a,eax
    add state_t[esi].b,ebx
    add state_t[esi].c,ecx
    add state_t[esi].d,edx
  end;

{$Else USE_ASM_MD5Transform}

// Constants for MD5Transform routine.
const
  S11                   = 7;
  S12                   =12;
  S13                   =17;
  S14                   =22;
  S21                   = 5;
  S22                   = 9;
  S23                   =14;
  S24                   =20;
  S31                   = 4;
  S32                   =11;
  S33                   =16;
  S34                   =23;
  S41                   = 6;
  S42                   =10;
  S43                   =15;
  S44                   =21;

(* first translation of c version:

// F, G, H and I are basic MD5 functions.
function F(const x, y, z:UINT4):UINT4;inline;
  begin
    F:=((x and y) or ((not x) and z));
  end;

function G(const x, y, z:UINT4):UINT4;inline;
  begin
    G:=((x and z) or (y and (not z)));
  end;

function H(const x, y, z:UINT4):UINT4;inline;
  begin
    H:=(x xor y xor z);
  end;

function I(const x, y, z:UINT4):UINT4;inline;
  begin
    i:=(y xor (x or (not z)));
  end;

// ROTATE_LEFT rotates x left n bits.
function ROTATE_LEFT(const x, n:UINT4):UINT4;inline;
  begin
    ROTATE_LEFT:=((x shl n) or (x shr (32-n)));
  end;

// FF, GG, HH, and II transformations for rounds 1, 2, 3, and 4.
// Rotation is separate from addition to prevent recomputation.
procedure FF(var a:UINT4;const b, c, d, x, s, ac:UINT4);
  begin
    a:=a+F(b,c,d)+x+ac;
    a:=ROTATE_LEFT(a,s);
    a:=a+b;
  end;

procedure GG(var a:UINT4;const b, c, d, x, s, ac:UINT4);
  begin
    a:=a+G(b,c,d)+x+ac;
    a:=ROTATE_LEFT(a,s);
    a:=a+b;
  end;

procedure HH(var a:UINT4;const b, c, d, x, s, ac:UINT4);
  begin
    a:=a+H(b,c,d)+x+ac;
    a:=ROTATE_LEFT(a,s);
    a:=a+b;
  end;

procedure II(var a:UINT4;const b, c, d, x, s, ac:UINT4);
  begin
    a:=a+I(b,c,d)+x+ac;
    a:=ROTATE_LEFT(a,s);
    a:=a+b;
  end;

and now expanded version: *)

procedure FF(var a:UINT4;const b, c, d, x, s, ac:UINT4);inline;
  begin
    a:=a+((b and c) or ((not b) and d))+x+ac;
    a:=((a shl s) or (a shr (32-s)))+b;
  end;

procedure GG(var a:UINT4;const b, c, d, x, s, ac:UINT4);inline;
  begin
    a:=a+((b and d) or (c and (not d)))+x+ac;
    a:=((a shl s) or (a shr (32-s)))+b;
  end;

procedure HH(var a:UINT4;const b, c, d, x, s, ac:UINT4);inline;
  begin
    a:=a+(b xor c xor d)+x+ac;
    a:=((a shl s) or (a shr (32-s)))+b;
  end;

procedure II(var a:UINT4;const b, c, d, x, s, ac:UINT4);inline;
  begin
    a:=a+(c xor (b or (not d)))+x+ac;
    a:=((a shl s) or (a shr (32-s)))+b;
  end;

// MD5 basic transformation. Transforms state based on block.
procedure MD5Transform(var state:state_t;const block);
  var
    a,b,c,d             :UINT4;
    {$IfDef NODECODE}
    x                   :array16UINT4 absolute block;
    {$Else}
    x                   :array16UINT4;
    {$EndIf}
  begin
    {$IfNDef NODECODE}
    Decode(x,array64byte(block),SizeOf(x));
    {$EndIf}

    a:=state.a;
    b:=state.b;
    c:=state.c;
    d:=state.d;

    // Round 1
    FF (a, b, c, d, x[ 0], S11, $d76aa478); (* 1 *)
    FF (d, a, b, c, x[ 1], S12, $e8c7b756); (* 2 *)
    FF (c, d, a, b, x[ 2], S13, $242070db); (* 3 *)
    FF (b, c, d, a, x[ 3], S14, $c1bdceee); (* 4 *)
    FF (a, b, c, d, x[ 4], S11, $f57c0faf); (* 5 *)
    FF (d, a, b, c, x[ 5], S12, $4787c62a); (* 6 *)
    FF (c, d, a, b, x[ 6], S13, $a8304613); (* 7 *)
    FF (b, c, d, a, x[ 7], S14, $fd469501); (* 8 *)
    FF (a, b, c, d, x[ 8], S11, $698098d8); (* 9 *)
    FF (d, a, b, c, x[ 9], S12, $8b44f7af); (* 10 *)
    FF (c, d, a, b, x[10], S13, $ffff5bb1); (* 11 *)
    FF (b, c, d, a, x[11], S14, $895cd7be); (* 12 *)
    FF (a, b, c, d, x[12], S11, $6b901122); (* 13 *)
    FF (d, a, b, c, x[13], S12, $fd987193); (* 14 *)
    FF (c, d, a, b, x[14], S13, $a679438e); (* 15 *)
    FF (b, c, d, a, x[15], S14, $49b40821); (* 16 *)

    // Round 2
    GG (a, b, c, d, x[ 1], S21, $f61e2562); (* 17 *)
    GG (d, a, b, c, x[ 6], S22, $c040b340); (* 18 *)
    GG (c, d, a, b, x[11], S23, $265e5a51); (* 19 *)
    GG (b, c, d, a, x[ 0], S24, $e9b6c7aa); (* 20 *)
    GG (a, b, c, d, x[ 5], S21, $d62f105d); (* 21 *)
    GG (d, a, b, c, x[10], S22,  $2441453); (* 22 *)
    GG (c, d, a, b, x[15], S23, $d8a1e681); (* 23 *)
    GG (b, c, d, a, x[ 4], S24, $e7d3fbc8); (* 24 *)
    GG (a, b, c, d, x[ 9], S21, $21e1cde6); (* 25 *)
    GG (d, a, b, c, x[14], S22, $c33707d6); (* 26 *)
    GG (c, d, a, b, x[ 3], S23, $f4d50d87); (* 27 *)

    GG (b, c, d, a, x[ 8], S24, $455a14ed); (* 28 *)
    GG (a, b, c, d, x[13], S21, $a9e3e905); (* 29 *)
    GG (d, a, b, c, x[ 2], S22, $fcefa3f8); (* 30 *)
    GG (c, d, a, b, x[ 7], S23, $676f02d9); (* 31 *)
    GG (b, c, d, a, x[12], S24, $8d2a4c8a); (* 32 *)

    // Round 3
    HH (a, b, c, d, x[ 5], S31, $fffa3942); (* 33 *)
    HH (d, a, b, c, x[ 8], S32, $8771f681); (* 34 *)
    HH (c, d, a, b, x[11], S33, $6d9d6122); (* 35 *)
    HH (b, c, d, a, x[14], S34, $fde5380c); (* 36 *)
    HH (a, b, c, d, x[ 1], S31, $a4beea44); (* 37 *)
    HH (d, a, b, c, x[ 4], S32, $4bdecfa9); (* 38 *)
    HH (c, d, a, b, x[ 7], S33, $f6bb4b60); (* 39 *)
    HH (b, c, d, a, x[10], S34, $bebfbc70); (* 40 *)
    HH (a, b, c, d, x[13], S31, $289b7ec6); (* 41 *)
    HH (d, a, b, c, x[ 0], S32, $eaa127fa); (* 42 *)
    HH (c, d, a, b, x[ 3], S33, $d4ef3085); (* 43 *)
    HH (b, c, d, a, x[ 6], S34,  $4881d05); (* 44 *)
    HH (a, b, c, d, x[ 9], S31, $d9d4d039); (* 45 *)
    HH (d, a, b, c, x[12], S32, $e6db99e5); (* 46 *)
    HH (c, d, a, b, x[15], S33, $1fa27cf8); (* 47 *)
    HH (b, c, d, a, x[ 2], S34, $c4ac5665); (* 48 *)

    // Round 4
    II (a, b, c, d, x[ 0], S41, $f4292244); (* 49 *)
    II (d, a, b, c, x[ 7], S42, $432aff97); (* 50 *)
    II (c, d, a, b, x[14], S43, $ab9423a7); (* 51 *)
    II (b, c, d, a, x[ 5], S44, $fc93a039); (* 52 *)
    II (a, b, c, d, x[12], S41, $655b59c3); (* 53 *)
    II (d, a, b, c, x[ 3], S42, $8f0ccc92); (* 54 *)
    II (c, d, a, b, x[10], S43, $ffeff47d); (* 55 *)
    II (b, c, d, a, x[ 1], S44, $85845dd1); (* 56 *)
    II (a, b, c, d, x[ 8], S41, $6fa87e4f); (* 57 *)
    II (d, a, b, c, x[15], S42, $fe2ce6e0); (* 58 *)
    II (c, d, a, b, x[ 6], S43, $a3014314); (* 59 *)
    II (b, c, d, a, x[13], S44, $4e0811a1); (* 60 *)
    II (a, b, c, d, x[ 4], S41, $f7537e82); (* 61 *)
    II (d, a, b, c, x[11], S42, $bd3af235); (* 62 *)
    II (c, d, a, b, x[ 2], S43, $2ad7d2bb); (* 63 *)
    II (b, c, d, a, x[ 9], S44, $eb86d391); (* 64 *)

    Inc(state.a,a);
    Inc(state.b,b);
    Inc(state.c,c);
    Inc(state.d,d);

    {$IfNDef NODECODE}
    // Zeroize sensitive information.
    FillChar(x,SizeOf(x),0);
    {$EndIf}
  end;
{$EndIf USE_ASM_MD5Transform}


// MD5 initialization. Begins an MD5 operation, writing a new context.
procedure MD5Init(var context:MD5_CTX);
  begin
    with context do
      begin
        count[0]:=0;
        count[1]:=0;
        // Load magic initialization constants.
        with state do
          begin
            a:=$67452301;
            b:=$efcdab89;
            c:=$98badcfe;
            d:=$10325476;
          end;
      end;
  end;

// MD5 block update operation. Continues an MD5 message-digest
// operation, processing another message block, and updating the
// context.
procedure MD5Update(var context:MD5_CTX;const input;const inputLen:word);
  var
    input_a             :TByteArray absolute input;
    i, index, partLen   :word;
  begin
    with context do
      begin
        // Compute number of bytes mod 64
        index:=(count[0] shr 3) and $3F;

        // Update number of bits
        Inc(count[0],inputLen shl 3);
        if count[0]<UINT4(inputLen) shl 3 then
          begin
            Inc(count[1]);
            Inc(count[1],UINT4(inputLen) shr 29);
          end;

        partLen:=64-index;

        // Transform as many times as possible.
        if (inputLen >= partLen) then
          begin
            Move(input,buffer[index],partLen);
            MD5Transform(state,buffer);

            i:=partLen;
            while i+63<inputLen do
              begin
                MD5Transform(state,input_a[i]);
                Inc(i,64);
              end;

            index:=0;
          end
        else
          i:=0;

        // Buffer remaining input
        Move(input_a[i],buffer[index],inputLen-i);
      end;
  end;

// MD5 finalization. Ends an MD5 message-digest operation, writing the
// the message digest and zeroizing the context.

procedure MD5Final(var digest:digest_t;var context:MD5_CTX);
  var
    PADDING             :array[0..63] of byte;
    bits                :array[0..7] of byte;
    index, padLen       :word;
  begin
    with context do
      begin

        FillChar(PADDING,SizeOf(PADDING),0);
        PADDING[0]:=$80;

        // Save number of bits
        Encode(bits,count,SizeOf(bits));

        // Pad out to 56 mod 64.
        index:=(count[0] shr 3) and $3f;
        if index<56 then
          padLen:=56-index
        else
          padLen:=120-index;

        MD5Update(context,PADDING,padLen);

        // Append length (before padding)
        MD5Update(context,bits,8);

        // Store state in digest
        Encode(digest,state,SizeOf(digest));

        // Zeroize sensitive information.
        FillChar(context,SizeOf(context),0);
      end;

  end;

end.

