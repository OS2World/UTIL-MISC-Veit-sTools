uses
  VpUtils;

type
  UINT4                 =longint;

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

  a                     =1;
  b                     =2;
  c                     =3;
  d                     =4;

  reg:array[1..4] of string[3]=('eax','ebx','ecx','edx');

// eax=a
// ebx=b
// ecx=c
// edx=d
// ebp=@x
// esi=work1
// esi=work2

procedure FF(const a, b, c, d, x, s, ac:UINT4);
  begin
    // a:=a+((b and c) or ((not b) and d))+x+ac;
    WriteLn('add ',reg[a],',[ebp+',4*x,']');
    WriteLn('add ',reg[a],',$',Int2Hex(ac,8));
    WriteLn('mov esi,',reg[b]);
    WriteLn('and esi,',reg[c]); // b and c
    WriteLn('mov edi,',reg[b]);
    WriteLn('not edi');
    WriteLn('and edi,',reg[d]); // (not b) and d
    WriteLn('or  esi,edi');
    WriteLn('add ',reg[a],',esi');
    // a:=((a shl s) or (a shr (32-s)))+b;
    WriteLn('rol ',reg[a],',',s);
    WriteLn('add ',reg[a],',',reg[b]);
  end;

procedure GG(const a, b, c, d, x, s, ac:UINT4);inline;
  begin
    // a:=a+((b and d) or (c and (not d)))+x+ac;
    WriteLn('add ',reg[a],',[ebp+',4*x,']');
    WriteLn('add ',reg[a],',$',Int2Hex(ac,8));
    WriteLn('mov esi,',reg[d]);
    WriteLn('not esi');
    WriteLn('and esi,',reg[c]); // (not d) and c
    WriteLn('mov edi,',reg[b]);
    WriteLn('and edi,',reg[d]); // b and d
    WriteLn('or  esi,edi');
    WriteLn('add ',reg[a],',esi');
    // a:=((a shl s) or (a shr (32-s)))+b;
    WriteLn('rol ',reg[a],',',s);
    WriteLn('add ',reg[a],',',reg[b]);
  end;

procedure HH(const a, b, c, d, x, s, ac:UINT4);inline;
  begin
    //a:=a+(b xor c xor d)+x+ac;
    WriteLn('add ',reg[a],',[ebp+',4*x,']');
    WriteLn('add ',reg[a],',$',Int2Hex(ac,8));
    WriteLn('mov esi,',reg[b]);
    WriteLn('xor esi,',reg[c]);
    WriteLn('xor esi,',reg[d]); // b xor c xor d
    WriteLn('add ',reg[a],',esi');
    // a:=((a shl s) or (a shr (32-s)))+b;
    WriteLn('rol ',reg[a],',',s);
    WriteLn('add ',reg[a],',',reg[b]);
  end;

procedure II(const a, b, c, d, x, s, ac:UINT4);inline;
  begin
    // a:=a+(c xor (b or (not d)))+x+ac;
    WriteLn('add ',reg[a],',[ebp+',4*x,']');
    WriteLn('add ',reg[a],',$',Int2Hex(ac,8));
    WriteLn('mov esi,',reg[d]);
    WriteLn('not esi');
    WriteLn('or  esi,',reg[b]);
    WriteLn('xor esi,',reg[c]); // ((not d) or b) xor c
    WriteLn('add ',reg[a],',esi');
    // a:=((a shl s) or (a shr (32-s)))+b;
    WriteLn('rol ',reg[a],',',s);
    WriteLn('add ',reg[a],',',reg[b]);
  end;

var
  x:array[0..63] of byte;
  i:word;

begin
  for i:=Low(x) to High(x) do x[i]:=i;
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
end.
