(*$X+*)
program dspres_system_vio_entpacker;

(*$D extract font resources from DSPRES.DLL*)

(* Veit Kannegieser * 1999.06.21 *)

uses
  VpUtils,
  VpSysLow,
  OS2Def,
  OS2Base;

var
  dspres                :string;
  dspres_hand           :HModule;
  loaderror             :array[0..255] of char;
  zaehler               :longint;
  hoehe                 :longint;
  res_z                 :pointer;
  d                     :file;

procedure fehlerbehandlung(const rc:longint);
  var
    meldung:array[0..255] of char;
    ml:longint;
  begin
    if rc<>0 then
      begin
        WriteLn(SysGetSystemError(rc,PChar(@meldung),SizeOf(meldung),ml));
        Halt(rc);
      end;
  end;

begin
  if ParamCount=1 then
    dspres:=ParamStr(1)
  else
    dspres:='DSPRES.DLL';
  dspres:=dspres+#0;

  fehlerbehandlung(
    DosLoadModule(
      PChar(@loaderror),
      SizeOf(loaderror),
      PChar(@dspres[1]),
      dspres_hand));

  for zaehler:=1 to 6 do
    begin
      fehlerbehandlung(
        DosGetResource(
          dspres_hand,
          1000,
          2007+zaehler-1,
          res_z));

      hoehe:=8+(zaehler-1)*2;
      Assign(d,'VIO_8_'+Int2StrZ(hoehe,2)+'.FON');
      Rewrite(d,1);
      BlockWrite(d,res_z^,(hoehe+6)*505+$d8+28);
      Close(d);

      fehlerbehandlung(
        DosFreeResource(
          res_z));
    end;

  fehlerbehandlung(
    DosFreeModule(
      dspres_hand));
end.

