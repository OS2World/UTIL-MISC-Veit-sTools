{&Use32+}
unit utf8u;

interface

uses
  utf8,
  unidef,
  UniApi;

procedure read_utf8_to_string(const source:string;var target:string;const cp_converter:UconvObject);
procedure write_utf8_from_string(const source:string;var target:string;const cp_converter:UconvObject);

implementation

uses
  Strings,
  VpUtils;


const
  malformed             =$fffd;


procedure read_utf8_to_string(const source:string;var target:string;const cp_converter:UconvObject);
  var
    temp                :pUniCharArray;
    pc                  :pchar;
    ucsbuf              :pUniCharArray;
    UniCharsleft        :size_t;
    outbuf              :pchar;
    outbytesleft        :size_t;
    nonidentical        :size_t;

  begin

    if source='' then
      begin
        target:='';
        Exit;
      end;

    (* read 8->16 *)
    read_utf8(source,temp);

    (* prepare buffer *)
    ucsbuf:=temp;
    UniCharsleft:=UniStrLen(temp^);
    outbytesleft:=Min(High(target),UniCharsleft+1);
    GetMem(pc,outbytesleft);
    outbuf:=pc;
    FillChar(pc^,outbytesleft,0);

    (* convert 16->8 *)
    UniUconvFromUcs(
      cp_converter,
      ucsbuf,UniCharsleft,
      outbuf,outbytesleft,
      nonidentical);

    (* copy result from buffer *)
    target:=StrPas(pc);

    (* free buffers *)
    Dispose(pc);
    FreeUniCharArray(temp^);
  end;

procedure write_utf8_from_string(const source:string;var target:string;const cp_converter:UconvObject);
  var
    temp                :pUniCharArray;
    pc                  :pchar;
    inbuf               :pchar;
    inbytesleft         :size_t;
    ucsbuf              :pUniCharArray;
    UniCharsleft        :size_t;
    nonidentical        :size_t;
  begin

    if source='' then
      begin
        target:='';
        Exit;
      end;

    (* prepare buffers *)
    GetMem(pc,Length(source)+1);
    StrPCopy(pc,source);

    temp:=NewUniCharArray(Length(source));
    FillChar(temp^,(Length(source)+1)*SizeOf(temp^[0]),0);
    inbuf:=pc;
    inbytesleft:=Length(source);
    ucsbuf:=temp;
    UniCharsleft:=Length(source);

    (* convert 8->16 *)
    {rc:=}
    UniUConvToUcs(
      cp_converter,
      inbuf,inbytesleft,
      ucsbuf,UniCharsleft,
      nonidentical);

    (* convert 16->8 *)
    write_utf8(temp,target);

    (* free buffers *)
    Dispose(pc);
    FreeUniCharArray(temp^);
  end;

end.

