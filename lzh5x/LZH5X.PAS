{&Use32-}
{$B-,R-,S-}
unit lzh5x;

(* aus SWAG:Archives 0040:
   HARUHIKO OKOMURA,Compression using LHArc,COMPRESSION,USING,LHARC *)

interface

function entpacke_lzh5(const quelle,ziel;OrigSize,CompSize:Longint):boolean;

implementation

function entpacke_lzh5(const quelle,ziel;OrigSize,CompSize:Longint):boolean;

TYPE
  (*$IFDEF VirtualPascal*)
  NormInt=longint;
  (*$ELSE*)
  NormInt=integer;
  (*$ENDIF*)
  PWord=^TWord;
  TWord=ARRAY[0..32759]OF Integer;
  PByte=^TByte;
  TByte=ARRAY[0..65519]OF Byte;

CONST
(*
NOTE :
   The following constants are set to the values used by LHArc.
   You can change three of them as follows :

   DICBIT : Lempel-Ziv dictionnary size.
   Lowering this constant can lower the compression efficiency a lot !
   But increasing it (on a 32 bit platform only, i.e. Delphi 2) will not yield
   noticeably better results.
   If you set DICBIT to 15 or more, set PBIT to 5; and if you set DICBIT to 19
   or more, set NPT to NP, too.

   WINBIT : Sliding window size.
   The compression ratio depends a lot of this value.
   You can increase it to 15 to get better results on large files.
   I recommend doing this if you have enough memory, except if you want that
   your compressed data remain compatible with LHArc.
   On a 32 bit platform, you can increase it to 16. Using a larger value will
   only waste time and memory.

   BUFBIT : I/O Buffer size. You can lower it to save memory, or increase it
   to reduce disk access.
*)

  BITBUFSIZ=16;
  UCHARMAX=255;

  DICBIT=13;
  DICSIZ=1 SHL DICBIT;

  MATCHBIT=8;
  MAXMATCH=1 SHL MATCHBIT;
  THRESHOLD=3;
  PERCFLAG=$8000;

  NC=(UCHARMAX+MAXMATCH+2-THRESHOLD);
  CBIT=9;
  CODEBIT=16;

  NP=DICBIT+1;
  NT=CODEBIT+3;
  PBIT=4; {Log2(NP)}
  TBIT=5; {Log2(NT)}
  NPT=NT; {Greater from NP and NT}

  NUL=0;
  MAXHASHVAL=(3*DICSIZ+(DICSIZ SHR 9+1)*UCHARMAX);

  WINBIT=14;
  WINDOWSIZE=1 SHL WINBIT;

  BUFBIT=13;
  BUFSIZE=1 SHL BUFBIT;

VAR
  BitBuf:Word;
  n,HeapSize:Integer;
  SubBitBuf,BitCount:Word;

  Left,Right:ARRAY[0..2*(NC-1)]OF Word;

  PtTable:ARRAY[0..255]OF Word;
  PtLen:ARRAY[0..PRED(NPT)]OF Byte;
  CTable:ARRAY[0..4095]OF Word;
  CLen:ARRAY[0..PRED(NC)]OF Byte;

  BlockSize:Word;

  fehler:boolean;

{********************************** File I/O **********************************}

var
  lesezeiger,
  quellende,
  schreibzeiger:^byte;

FUNCTION GetC:Byte;
  begin
    if lesezeiger=quellende then
      GetC:=0
    else
      begin
        GetC:=lesezeiger^;
        Inc(lesezeiger);
      end;
  end;

PROCEDURE PutC(c:Byte);
  begin
    schreibzeiger^:=c;
    Inc(schreibzeiger);
  end;

FUNCTION BRead(var p;const n:NormInt):Integer;
  var
    uebrig:longint;
  begin
    uebrig:=Ofs(quellende^)-Ofs(lesezeiger^);
    if uebrig=0 then
      asm int 3 end;
    if uebrig>n then
      uebrig:=n;

    Move(lesezeiger^,p,uebrig);
    Inc(lesezeiger,uebrig);
    BRead:=uebrig;
  end;

PROCEDURE BWrite(var p;const n:NormInt);
  begin
    Move(p,schreibzeiger^,n);
    Inc(schreibzeiger,n);
  end;

{**************************** Bit handling routines ***************************}

PROCEDURE FillBuf(n:Integer);
BEGIN
  BitBuf:=(BitBuf SHL n) and $ffff;
  WHILE n>BitCount DO BEGIN
    DEC(n,BitCount);
    BitBuf:=BitBuf OR ((SubBitBuf SHL n) and $ffff);
    IF (CompSize<>0) THEN
      BEGIN
        DEC(CompSize);SubBitBuf:=GetC;
      END ELSE
        SubBitBuf:=0;
    BitCount:=8;
  END;
  DEC(BitCount,n);
  BitBuf:=BitBuf OR ((SubBitBuf and $ffff) SHR BitCount);
END;

FUNCTION GetBits(n:Integer):Word;
BEGIN
  GetBits:=(BitBuf and $ffff) SHR (BITBUFSIZ-n);
  FillBuf(n);
END;

PROCEDURE PutBits(n:Integer;x:Word);
BEGIN
  IF n<BitCount THEN
    BEGIN
      DEC(BitCount,n);
      SubBitBuf:=SubBitBuf OR ((x SHL BitCount) and $ffff);
    END ELSE BEGIN
      DEC(n,BitCount);
      PutC(SubBitBuf OR ((x and $ffff) SHR n));INC(CompSize);
      IF n<8 THEN
        BEGIN
          BitCount:=8-n;SubBitBuf:=(x SHL BitCount) and $ffff;
        END ELSE BEGIN
          PutC((x and $ffff) SHR (n-8));INC(CompSize);
          BitCount:=16-n;SubBitBuf:=(x SHL BitCount) and $ffff;
        END;
    END;
END;

PROCEDURE InitGetBits;
BEGIN
  BitBuf:=0;SubBitBuf:=0;BitCount:=0;FillBuf(BITBUFSIZ);
END;

PROCEDURE InitPutBits;
BEGIN
  BitCount:=8;SubBitBuf:=0;
END;

{******************************** Decompression *******************************}

PROCEDURE MakeTable(nchar:Integer;BitLen:PByte;TableBits:Integer;Table:PWord);
VAR
  count,weight:ARRAY[0{1}..16]OF Word;
  start:ARRAY[1..17]OF Word;
  p:PWord;
  i,k,Len,ch,jutbits,Avail,nextCode,mask:Integer;
BEGIN
  {FOR i:=1 TO 16 DO
    count[i]:=0;}
  FillChar(count,SizeOf(count),0);
  FOR i:=0 TO PRED(nchar) DO
    INC(count[BitLen^[i]]);
  start[1]:=0;
  FOR i:=1 TO 16 DO
    start[SUCC(i)]:=(start[i]+(count[i] SHL (16-i))) and $ffff;
  IF start[17]<>0 THEN
    {HALT}{RunError(1);}
    begin
      fehler:=true;
      Exit;
    end;
  jutbits:=16-TableBits;
  FOR i:=1 TO TableBits DO
    BEGIN
      start[i]:=(start[i] and $ffff) SHR jutbits;weight[i]:=1 SHL (TableBits-i);
    END;
  i:=SUCC(TableBits);
  WHILE (i<=16) DO BEGIN
    weight[i]:=1 SHL (16-i);INC(i);
  END;
  i:=(start[SUCC(TableBits)] and $ffff) SHR jutbits;
  IF i<>0 THEN
    BEGIN
      k:=1 SHL TableBits;
      WHILE i<>k DO BEGIN
        Table^[i]:=0;INC(i);
      END;
    END;
  Avail:=nchar;mask:=1 SHL (15-TableBits);
  FOR ch:=0 TO PRED(nchar) DO
    BEGIN
      Len:=BitLen^[ch];
      IF Len=0 THEN
        CONTINUE;
      k:=integer(start[Len]);
      nextCode:=k+weight[Len];
      IF Len<=TableBits THEN
        BEGIN
          FOR i:=k TO PRED(nextCode) DO
            Table^[i]:=ch;
        END ELSE BEGIN
          p:=Addr(Table^[(k and $ffff) SHR jutbits]);i:=Len-TableBits;
          WHILE i<>0 DO BEGIN
            IF p^[0]=0 THEN
              BEGIN
                right[Avail]:=0;left[Avail]:=0;p^[0]:=Avail;INC(Avail);
              END;
            IF (k AND mask)<>0 THEN
              p:=addr(right[p^[0]])
            ELSE
              p:=addr(left[p^[0]]);
            k:=integer((k SHL 1) and $ffff);DEC(i);
          END;
          p^[0]:=ch;
        END;
      start[Len]:=word(nextCode);
    END;
END;

PROCEDURE ReadPtLen(nn,nBit,ispecial:Integer);
VAR
  i,c,n:Integer;
  mask:Word;
BEGIN
  n:=GetBits(nBit);
  IF n=0 THEN
    BEGIN
      c:=GetBits(nBit);
      FOR i:=0 TO PRED(nn) DO
        PtLen[i]:=0;
      FOR i:=0 TO 255 DO
        PtTable[i]:=c;
    END ELSE BEGIN
      i:=0;
      WHILE (i<n) DO BEGIN
        c:=(BitBuf and $ffff) SHR (BITBUFSIZ-3);
        IF c=7 THEN
          BEGIN
            mask:=1 SHL (BITBUFSIZ-4);
            WHILE (mask AND BitBuf)<>0 DO BEGIN
              mask:=(mask and $ffff) SHR 1;INC(c);
            END;
          END;
        IF c<7 THEN
          FillBuf(3)
        ELSE
          FillBuf(c-3);
        PtLen[i]:=c;INC(i);
        IF i=ispecial THEN
          BEGIN
            c:=PRED(GetBits(2));
            WHILE c>=0 DO BEGIN
              PtLen[i]:=0;INC(i);DEC(c);
            END;
          END;
      END;
      WHILE i<nn DO BEGIN
        PtLen[i]:=0;INC(i);
      END;
      MakeTable(nn,@PtLen,8,@PtTable);
      if fehler then exit;
    END;
END;

PROCEDURE ReadCLen;
VAR
  i,c,n:Integer;
  mask:Word;
BEGIN
  n:=GetBits(CBIT);
  IF n=0 THEN
    BEGIN
      c:=GetBits(CBIT);
      FOR i:=0 TO PRED(NC) DO
        CLen[i]:=0;
      FOR i:=0 TO 4095 DO
        CTable[i]:=c;
    END ELSE BEGIN
      i:=0;
      WHILE i<n DO BEGIN
        c:=PtTable[(BitBuf and $ffff) SHR (BITBUFSIZ-8)];
        IF c>=NT THEN
          BEGIN
            mask:=1 SHL (BITBUFSIZ-9);
            REPEAT
              IF (BitBuf AND mask)<>0 THEN
                c:=right[c]
              ELSE
                c:=left[c];
              mask:=(mask and $ffff) SHR 1;
            UNTIL c<NT;
          END;
        FillBuf(PtLen[c]);
        IF c<=2 THEN
          BEGIN
            IF c=1 THEN
              c:=2+GetBits(4)
            ELSE
              IF c=2 THEN
                c:=19+GetBits(CBIT);
            WHILE c>=0 DO BEGIN
              CLen[i]:=0;INC(i);DEC(c);
            END;
          END ELSE BEGIN
            CLen[i]:=c-2;INC(i);
          END;
      END;
      WHILE i<NC DO BEGIN
        CLen[i]:=0;INC(i);
      END;
      MakeTable(NC,@CLen,12,@CTable);
      if fehler then exit;
    END;
END;

FUNCTION DecodeC:Word;
VAR
  j,mask:Word;
BEGIN
  IF BlockSize=0 THEN
    BEGIN
      BlockSize:=GetBits(16);
      ReadPtLen(NT,TBIT,3);
      if fehler then exit;
      ReadCLen;
      if fehler then exit;
      ReadPtLen(NP,PBIT,-1);
      if fehler then exit;
    END;
  DEC(BlockSize);
  j:=CTable[(BitBuf and $ffff) SHR (BITBUFSIZ-12)];
  IF j>=NC THEN
    BEGIN
      mask:=1 SHL (BITBUFSIZ-13);
      REPEAT
        IF (BitBuf AND mask)<>0 THEN
          j:=right[j]
        ELSE
          j:=left[j];
        mask:=(mask and $ffff) SHR 1;
      UNTIL j<NC;
    END;
  FillBuf(CLen[j]);
  DecodeC:=j;
END;

FUNCTION DecodeP:Word;
VAR
  j,mask:Word;
BEGIN
  j:=PtTable[(BitBuf and $ffff) SHR (BITBUFSIZ-8)];
  IF j>=NP THEN
    BEGIN
      mask:=1 SHL (BITBUFSIZ-9);
      REPEAT
        IF (BitBuf AND mask)<>0 THEN
          j:=right[j]
        ELSE
          j:=left[j];
        mask:=(mask and $ffff) SHR 1;
      UNTIL j<NP;
    END;
  FillBuf(PtLen[j]);
  IF j<>0 THEN
    BEGIN
      DEC(j);j:=((1 SHL j) and $ffff)+GetBits(j);
    END;
  DecodeP:=j;
END;

{declared as static vars}
VAR
  decode_i:Word;
  decode_j:Integer;

PROCEDURE DecodeBuffer(count:Word;Buffer:PByte);
VAR
  c,r:Word;
BEGIN
  r:=0;DEC(decode_j);
  WHILE (decode_j>=0) DO BEGIN
    Buffer^[r]:=Buffer^[decode_i];decode_i:=SUCC(decode_i) AND PRED(DICSIZ);
    INC(r);
    IF r=count THEN
      EXIT;
    DEC(decode_j);
  END;
  WHILE TRUE DO BEGIN
    //Write(^m,Ofs(lesezeiger^)-Ofs(quelle):12,Ofs(schreibzeiger^)-Ofs(ziel)+r:12);
    //WriteLn(r:5,BitBuf:8,SubBitBuf:8);
    c:=DecodeC;
    if fehler then exit;
    IF c<=UCHARMAX THEN
      BEGIN
        Buffer^[r]:=c;INC(r);
        IF r=count THEN
          EXIT;
      END ELSE BEGIN
        decode_j:=c-(UCHARMAX+1-THRESHOLD);
        decode_i:=(r-DecodeP-1)AND PRED(DICSIZ);
        DEC(decode_j);
        WHILE decode_j>=0 DO BEGIN
          Buffer^[r]:=Buffer^[decode_i];
          decode_i:=SUCC(decode_i) AND PRED(DICSIZ);
          INC(r);
          IF r=count THEN
            EXIT;
          DEC(decode_j);
        END;
      END;
  END;
END;

{PROCEDURE Decode;}
VAR
  p:PByte;
  l:Longint;
  a:Word;
BEGIN
  fehler:=false;
  lesezeiger:=@quelle;
  quellende:=Ptr(longint(lesezeiger)+CompSize);
  schreibzeiger:=@ziel;
  {Initialize decoder variables}
  GetMem(p,DICSIZ);
  InitGetBits;BlockSize:=0;
  decode_j:=0;
  {skip file size}
  l:=OrigSize;DEC(compSize,4);
  {unpacks the file}
  WHILE l>0 DO BEGIN
    IF l>DICSIZ THEN
      a:=DICSIZ
    ELSE
      a:=l;
    DecodeBuffer(a,p);
    if fehler then break;
    BWrite(p^,a);DEC(l,a);
  END;
  FreeMem(p,DICSIZ);
  entpacke_lzh5:=not fehler;
END;

end.

