{&Use32+}
unit utf8;

interface

uses
  unidef;

procedure read_utf8(const source:string;var target:pUniCharArray);
procedure write_utf8(const source:pUniCharArray;var target:string);

implementation

{$IfNDef VirtualPascal}
type
  shortstring           =string;
{$EndIf VirtualPascal}


const
  malformed             =$fffd;

procedure read_utf8(const source:string;var target:pUniCharArray);
  var
    c                     :longint;
    sourcepos,
    targetpos,
    trail                 :word;
    num_byte              :integer;

  begin
    (* worst case: 1 char=1 byte,one terminator *)
    target:=NewUniCharArray(Length(source)+1);
    FillChar(target^,SizeOf(target^[0])*(Length(source)+1),0);

    sourcepos:=1; (* string *)
    targetpos:=0; (* pointer *)
    while sourcepos<=Length(source) do
      begin
        c:=Ord(source[sourcepos]);
        case c of
(*
 U-00000000 - U-0000007F: 0xxxxxxx
 U-00000080 - U-000007FF: 110xxxxx 10xxxxxx
 U-00000800 - U-0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
 U-00010000 - U-001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
 U-00200000 - U-03FFFFFF: 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
 U-04000000 - U-7FFFFFFF: 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx *)

        $00..$7f: (* 1 byte *)
          begin
            (*c:=c and $7f;*)
            trail:=0;
            Inc(sourcepos);
          end;

        $80..$bf: (* broken code ! *)
          begin
            c:=malformed;
            trail:=0;
            Inc(sourcepos);
          end;

        $c0..$df: (* 2 bytes *)
          begin
            c:=c and $1f;
            trail:=1;
            Inc(sourcepos);
          end;

        $e0..$ef: (* 3 bytes *)
          begin
            c:=c and $0f;
            trail:=2;
            Inc(sourcepos);
          end;

        $f0..$f7: (* 4 bytes *)
          begin
            c:=c and $07;
            trail:=3;
            Inc(sourcepos);
          end;

        $f8..$fb: (* 5 bytes *)
          begin
            c:=c and $03;
            trail:=4;
            Inc(sourcepos);
          end;

        $fc..$fd: (* 6 bytes *)
          begin
            c:=c and $01;
            trail:=5;
            Inc(sourcepos);
          end;

        else
      (* $fe..$ff: not allowed *)
            c:=malformed;
            trail:=0;
            Inc(sourcepos);
        end;

        num_byte:=1+trail;

        while trail>0 do
          begin
            if sourcepos>Length(source) then
              begin
                (* incomplete line *)
                c:=malformed;
                Break;
              end;

            if (Ord(source[sourcepos]) shr 6)<>2 then (* 10xxxxxx ? *)
              begin
                (* missing trail char *)
                c:=malformed;
                Break;
              end;

            c:=(c shl 6)+(Ord(source[sourcepos]) and $3f);
            Dec(trail);
            Inc(sourcepos);
          end;

        (***
        case c of
          $00000000..$0000007f:Dec(num_byte,1);
          $00000080..$000007FF:Dec(num_byte,2);
          $00000800..$0000FFFF:Dec(num_byte,3);
          $00010000..$001FFFFF:Dec(num_byte,4);
          $00200000..$03FFFFFF:Dec(num_byte,5);
          $04000000..$7FFFFFFF:Dec(num_byte,6);
        end;***)
        if c<(1 shl  7) then Dec(num_byte,1)
        else
        if c<(1 shl 11) then Dec(num_byte,2)
        else
        if c<(1 shl 16) then Dec(num_byte,3)
        else
        if c<(1 shl 21) then Dec(num_byte,4)
        else
        if c<(1 shl 26) then Dec(num_byte,5)
        else
        if c<(1 shl 31) then Dec(num_byte,6);

        if num_byte>0 then (* ineffiecently coded ? *)
          c:=malformed; (* reject it, even for a decoder *)

        if c>$ffff then (* limit the resoult to our 16 bit unicode implementation *)
          c:=malformed;

        target^[targetpos]:=c;
        Inc(targetpos);

      end; (* while <= length(source) *)

  end;


procedure write_utf8(const source:pUniCharArray;var target:string);
  var
    i,
    num_byte,
    sourcepos           :word;
    c                   :longint;
    temp                :shortstring;
  begin
    sourcepos:=0;
    target:='';
    while source^[sourcepos]<>0 do
      begin
        c:=source^[sourcepos];
        if c<$80 then
          target:=target+Chr(c)
        else
          begin
            (***
            case c of
              $00000080..$000007FF:num_byte:=2;
              $00000800..$0000FFFF:num_byte:=3;
              $00010000..$001FFFFF:num_byte:=4;
              $00200000..$03FFFFFF:num_byte:=5;
              $04000000..$7FFFFFFF:num_byte:=6;
            end;***)
            if c<(1 shl 11) then num_byte:=2
            else
            if c<(1 shl 16) then num_byte:=3
            else
            if c<(1 shl 21) then num_byte:=4
            else
            if c<(1 shl 26) then num_byte:=5
            else
            if c<(1 shl 31) then num_byte:=6;

            temp[0]:=Chr(num_byte);
            (* trail code and lower bits *)
            for i:=num_byte downto 2 do
              begin
                temp[i]:=Chr($80 or (c and $3f));
                c:=c shr 6;
              end;

            (* first char: code length and most significant bits *)
            temp[1]:=Chr( c or ($ff shl (8-num_byte)) );

            target:=target+temp;
          end;

        Inc(sourcepos);
      end;

  end;


end.

