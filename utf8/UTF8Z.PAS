{&Use32+}
unit utf8z;

interface

uses
  zst,
  ztab;

procedure read_utf8_to_string(const source:string;var target:string;const cp_converter:zeichensatzumformung_16_8);
procedure write_utf8_from_string(const source:string;var target:string;const cp_converter:zeichensatzumformung_8_16);

implementation

uses
  unidef,
  utf8;

procedure read_utf8_to_string(const source:string;var target:string;const cp_converter:zeichensatzumformung_16_8);
  var
    temp                :pUniCharArray;

  begin
    (* read 8->16 *)
    read_utf8(source,temp);

    (* convert 16->8 *)
    umformung_16_8(temp^,target,cp_converter);

    (* free buffer *)
    FreeUniCharArray(temp^);
  end;

procedure write_utf8_from_string(const source:string;var target:string;const cp_converter:zeichensatzumformung_8_16);
  var
    temp                :pUniCharArray;

  begin
    (* convert 8->16 *)
    temp:=NewUniCharArray(Length(source));
    umformung_8_16(source,temp^,cp_converter);

    (* convert 16->8 *)
    write_utf8(temp,target);

    (* free buffer *)
    FreeUniCharArray(temp^);
  end;

end.

