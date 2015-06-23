program e_lc10;

(* 1999.12.18 Veit Kannegieser mit inflate-pascal.zip/DumPING als Grundlage *)
(* 2000.04.13 FSIMAGE.EXE: LC10-Anfang auf 16 Byte ausgerichtet *)

{
   Copyright (c) 1995 by Oliver Fromme  --  All Rights Reserved

   Address:  Oliver Fromme, Leibnizstr. 18-61, 38678 Clausthal, Germany
   Internet:  fromme@rz.tu-clausthal.de
   WWW:  http://www.tu-clausthal.de/~inof/

   Freely distributable, freely usable.
   The original copyright notice may not be modified or omitted.
}

{$A+,B-,D+,E-,F-,G+,I-,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
(*$IFDEF VirtualPascal*)
  (*$M 80000*)
  (*$Use32+*)
(*$ELSE*)
  {$M 60000,0,655360}
(*$ENDIF*)

uses
  inflate,
  objects;

(*$IFNDEF VirtualPascal*)
type
  smallword             =word;
(*$ENDIF*)

var
  d1,d2                 :pBufStream;


function InflateRead_:byte;far;
  var
    t                   :byte;
  begin
    d1^.Read(t,1);
    InflateRead_:=t;
  end;

function InflateFlush_(w:word):integer;far;
  begin
    d2^.Write(slide^,w);
    InflateFlush_:=0;
  end;

procedure kopiere(o0,l:longint);
  var
    k                   :array[0..32*1024-1] of byte; (* $M beachten ! *)
    j                   :word;
  begin

    d1^.Seek(o0);
    repeat

      if l>SizeOf(k) then
        j:=SizeOf(k)
      else
        j:=l;

      d1^.Read (k,j);
      d2^.Write(k,j);

      Dec(l,j);
    until l=0;

  end;

var
  sig,mod512,page512    :smallword;

  o1,o2,l1,l2           :longint;

  newexeoffset          :longint;

begin
  WriteLn('E_LC10 * LC10 -> LE deflate * Veit Kannegieser * 1999.12.18..2000.04.13');

  if ParamCount<>2 then
    begin
      WriteLn('E_LC10 <LC_10_EXE> <LE_EXE>');
      Halt(1);
    end;

  d1:=New(pBufStream,Init(ParamStr(1){'PQMAGIC.OVL'},stOpen  ,8*1024));
  if d1^.Status<>stOK then
    RunError(d1^.Status);
  d2:=New(pBufStream,Init(ParamStr(2){'PQMAGIC.LE' },stCreate,8*1024));
  if d2^.Status<>stOK then
    RunError(d2^.Status);

  Getmem(slide,WSIZE);
  FillChar(slide^,WSIZE,0);

  InflateFlush:=InflateFlush_;
  InflateRead :=InflateRead_;

  repeat
    o1:=d1^.GetPos;
    o2:=d2^.GetPos;

    d1^.Read(sig,SizeOf(sig));

    if (sig=(Ord('M')+Ord('Z') shl 8))
    or (sig=(Ord('Z')+Ord('M') shl 8))
     then
      begin
        Write('þ EXE (');
        d1^.Read(mod512,SizeOf(mod512));
        d1^.Read(page512,SizeOf(page512));
        l1:=longint(page512)*512;
        if mod512<>0 then
          Dec(l1,512-longint(mod512));

        (* new-exe offset .. *)
        if l1>$40 then
          begin
            d1^.Seek(o1+$3c);
            d1^.Read(newexeoffset,SizeOf(newexeoffset));
            if ((l1+15) and (-16))=newexeoffset then
              l1:=newexeoffset;
          end;

        Write(l1,')');
        kopiere(o1,l1);
        WriteLn;
      end
    else
      if sig=(Ord('B')+Ord('W') shl 8) then
        begin
          Write('þ EXP (');
          d1^.Read(mod512,SizeOf(mod512));
          d1^.Read(page512,SizeOf(page512));
          l1:=longint(page512)*512+longint(mod512);
          l1:=(l1+$0f) and $fffffff0;
          Write(l1,')');
          kopiere(o1,l1);
          WriteLn;
        end
      else
        if sig=(Ord('L')+Ord('C') shl 8) then
          begin
            Write('þ LC10 ... ');

            d1^.Seek(o1+$12);

            if InflateRun<>0 then
              RunError(1);

            l1:=d1^.GetPos-o1;
            l2:=d2^.GetPos-o2;
            WriteLn(' (',l1,' -> ',l2,')');

            d1^.Seek(d1^.GetPos+4);
          end
        else
          begin
            WriteLn('þ ??? (',o1,'/',d1^.GetSize-o1,')');
            RunError(1);
          end;

    d2^.Flush;

  until d1^.GetPos>=d1^.GetSize;

  d1^.Done;
  d2^.Done;
end.

