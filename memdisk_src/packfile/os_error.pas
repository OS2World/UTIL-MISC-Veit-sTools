(* display OS error message, for example
   110 ->
   'SYS0110: Die angegebene Einheit oder Datei kann vom System nicht er”ffnet werden.' *)
{&Use32+}
unit os_error;

interface

procedure display_os_error(n:longint);

implementation

uses
  {$IfDef DPMI32}esyserr,{$EndIf} (* include error resourcestrings *)
  Strings,
  VpSysLow,
  VpUtils;

procedure display_os_error(n:longint);
  var
    buffer              :array[0..512] of char;
    msglen              :word;
    message_start       :PChar;

  begin

    SysGetSystemError(n,buffer,SizeOf(buffer),msglen);
    if msglen>0 then
      begin

        buffer[Min(High(buffer),msglen)]:=#0;
        message_start:=@buffer[0];
        if StrLComp(@('SYS'+Int2StrZ(n,4)+#0)[1],message_start,3+4)=0 then
          begin
            Inc(message_start,3+4);
            while message_start[0] in [' ',':'] do Inc(message_start);
          end;
        WriteLn(message_start);

      end;

  end;

end.
