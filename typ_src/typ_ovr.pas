(*$I TYP_COMP.PAS*)

unit typ_ovr;

interface

implementation

{$IfDef DOS_OVERLAY}
uses
  Overlay,
  OverXMS;

const
  speicher_bedarf=2000; (* siehe typ_comp *)

procedure init_ovr;
  var
    exezk               :string;
    l                   :longint;
  begin
    exezk:=ParamStr(0);
    (*$IfNDef ENDVERSION*)
    Dec(exezk[0],3);
    exezk:=exezk+'OVR';
    (*$EndIf ENDVERSION*)
    OvrInit(exezk);
    if OvrResult<>OvrOk then
      begin
        WriteLn('OvrInit(',exezk,')=',OvrResult);
        ReadLn;
        RunError(OvrResult);
      end;

    OvrInitXMS;
    if OvrResult=OvrIOError then
      begin
        WriteLn('OvrInitXMS=OvrIOError');
        ReadLn;
        RunError(0);
      end;

    if OvrResult<>OvrOk then
      OvrInitEMS;

    l:=MaxAvail-$80
      -2000
      -8000; (* typ_zeic *)
    if l>0 then
      OvrSetBuf(OvrGetBuf+l); (* vorher kein New/Getmem! *)

  end;

begin
  init_ovr;
{$EndIf}
end.