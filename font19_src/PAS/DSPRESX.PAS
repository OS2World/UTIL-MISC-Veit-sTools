{&Use32+}{$X+}
program dspres_system_vio_entpacker;

(* extract font resources from DSPRES.DLL*)

(* Veit Kannegieser * 1999.06.21                                *)
(*                    2004.04.21 use DosQueryResourceSize       *)
(*                               display failed call            *)

uses
  HilfsFun,
  VpUtils,
  OS2Def,
  OS2Base;

var
  dspres                :string;
  dspres_hand           :HModule;
  loaderror             :array[0..255] of char;
  zaehler               :longint;
  hoehe                 :longint;
  res_len               :longint;
  res_z                 :pointer;
  d                     :file;
  filename,
  target_directory      :string;

begin

  if ParamCount=1 then
    dspres:=ParamStr(1)
  else
    dspres:='DSPRES.DLL';

  if ParamCount=2 then
    target_directory:=ParamStr(2)
  else
    target_directory:='.\';
  if not (target_directory[Length(target_directory)] in ['\','/']) then
    target_directory:=target_directory+'\';

  if (ParamCount>2) or (dspres='/?') or (dspres='-?') then
    begin
      WriteLn('Usage: dspres [ X:\os2\dll\dspres.dll [ target directory ]]');
      Halt(1);
    end;
  dspres:=dspres+#0;

  Fehlerbehandlung('DosLoadModule',
    DosLoadModule(
      PChar(@loaderror),
      SizeOf(loaderror),
      PChar(@dspres[1]),
      dspres_hand));

  for zaehler:=1 to 6 do
    begin
      Fehlerbehandlung('DosQueryResourceSize',
        DosQueryResourceSize(
          dspres_hand,
          1000,
          2007+zaehler-1,
          res_len));

      Fehlerbehandlung('DosGetResource',
        DosGetResource(
          dspres_hand,
          1000,
          2007+zaehler-1,
          res_z));

      hoehe:=8+(zaehler-1)*2;
      filename:=target_directory+'VIO_8_'+Int2StrZ(hoehe,2)+'.FON';
      Assign(d,filename);
      {$I-}
      Rewrite(d,1);
      {$I+}
      Fehlerbehandlung('Can not create output file '+filename,IOResult);
      BlockWrite(d,res_z^,res_len);
      Close(d);

      Fehlerbehandlung('DosFreeResource',
        DosFreeResource(
          res_z));
    end;

  Fehlerbehandlung('DosFreeModule',
    DosFreeModule(
      dspres_hand));
end.

