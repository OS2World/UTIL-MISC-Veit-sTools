(*$N+,E-*)
program test_s3_trio_clocks;
(* -> VGADOC4B *)

(* $DEFINE TEST*)

uses
  crt;

const
  crtc          =$03d4;
  Sequencer     =$03c4;
  bit5          =1 shl 5;
  ohne_bit5     =$ff-bit5;
  bit43210      =bit5-1;
  schritt       =1.008;
  schritt_zk    ='1.008';

procedure unlock_s3;assembler;
  asm
    mov dx,CRTC
    mov ax,$4838
    out dx,ax
    mov ax,$a539
    out dx,ax
    mov dx,Sequencer
    mov ax,$0608
    out dx,ax
  end;

procedure lock_s3;assembler;
  asm
    mov dx,CRTC
    mov ax,$0038
    out dx,ax
    mov ax,$5a39
    out dx,ax
    mov dx,Sequencer
    mov ax,$0008
    out dx,ax
  end;

(*$IFDEF TEST*)
const
  lies_wert:word=$5549;
(*$ELSE*)
function lies_wert:word;assembler;
  asm
    mov dx,Sequencer
    mov al,$12
    out dx,al
    inc dx
    in ax,dx
  end;
(*$ENDIF*)

(*$IFDEF TEST*)
procedure schreibe_wert(const w:word);
  begin
    lies_wert:=w;
  end;
(*$ELSE*)
procedure schreibe_wert(const w:word);assembler;
  asm
    mov dx,Sequencer
    mov al,$12
    out dx,al
    inc dx
    mov ax,[w]
    out dx,ax

    (* Žnderung verwirklichen *)
    mov dx,Sequencer
    mov al,$15
    out dx,al
    inc dx
    xchg al,ah
    in al,dx
    xchg al,ah
    dec dx

    and ah,ohne_bit5
    out dx,ax
    or ah,bit5
    out dx,ax
    and ah,ohne_bit5
    out dx,ax
  end;
(*$ENDIF*)

function hex_byte(const b:byte):string;
  const
    hex_ziffern:array[0..15] of char='0123456789ABCDEF';
  begin
    hex_byte:=hex_ziffern[b shr 4]+hex_ziffern[b and $0f];
  end;

function hex_word(const w:word):string;
  begin
    hex_word:=hex_byte(hi(w))+hex_byte(lo(w));
  end;

function finde_wert(f:extended):word;
  var
    zdiv1,zdiv2,zquo:word;
    bdiv1,bdiv2,bquo:word;
    z:extended;
    u:extended;
  begin
    if f< 20 then f:= 20; (*  20 MHz *)
    if f>400 then f:=400; (* 400 MHz *)

    f:=f/14.318;

    u:=1000000; (* sehr schlecht *)

    (* die faule Variante ... *)
    for zdiv1:=1 to 31 do
      for zdiv2:=0 to 3 do
        for zquo:=1 to 127 do
          begin
            {z:=Abs( (zquo+2)/((zdiv1+2)*(1 shl zdiv2))-f );}
            z:=(zdiv1+2);
            z:=z*(1 shl zdiv2);
            z:=(zquo+2)/z;
            z:=z-f;
            z:=Abs(z);
            if u>z then
              begin
                u:=z;
                bdiv1:=zdiv1;
                bdiv2:=zdiv2;
                bquo :=zquo;
              end;
          end;

    finde_wert:=(bquo shl 8)+(bdiv2 shl 5)+bdiv1;
  end;

var
  w:word;
  quotient,divisor1,divisor2:longint;
  freq:extended;
  wzk:string;
  fehler:integer;

label
  nochmal;

begin
  unlock_s3;

  w:=lies_wert;
  WriteLn(' * ........... * '+schritt_zk);
  WriteLn(' / ........... / '+schritt_zk);
  WriteLn(' Esc ......... Quit');
  WriteLn(' $ ........... Enter hex value');
  WriteLn(' f ........... Enter freqency');
  WriteLn;

  repeat
    WriteLn('current value: $',hex_word(w));
    divisor1:=(w and bit43210)+2;
    divisor2:=1 shl ((w shr 5) and 3);
    quotient:=hi(w)+2;
    freq:=quotient/(divisor1*divisor2)*14.318;

    WriteLn('Frequency: ',freq:8:3,' MHz');

nochmal:
    case ReadKey of
      #13:w:=finde_wert(28.636);
      #27:break;
      '*':w:=finde_wert(freq*schritt);
      '/':w:=finde_wert(freq/schritt);
      '$':
        begin
          Write('$');
          ReadLn(wzk);
          if wzk[1]<>'$' then
            wzk:='$'+wzk;
          Val(wzk,w,fehler);
        end;
      'f':
        begin
          Write('> ');
          ReadLn(freq);
          w:=finde_wert(freq);
        end;
    else
      goto nochmal
    end;

    schreibe_wert(w);
  until false;

  lock_s3;
end.
