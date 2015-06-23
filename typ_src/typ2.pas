(*$Define TYP_EXE*)
(*$I TYP_COMP.PAS*)

program typ2;
(*$D Typ * Dateitypbestimmung / Archivlistprogramm * V.K.*)
(*$PMTYPE VIO*)

(*$IfDef Win32*)
(*$R typ4.res*)
(*$EndIf Win32*)

uses
  (*$IfDef DEBUG*)
    (*$IfDef DPMI32*)
      (*$IfNDef ENDVERSION*)
        deb_link,
      (*$EndIf ENDVERSION*)
    (*$EndIf DPMI32*)
  (*$EndIf*)

  typ_haup;
//procedure EXE_HAUPTPROGRAMMAUFRUF; external 'TYP2DLL.DLL' name 'EXE_HAUPTPROGRAMMAUFRUF';

begin
  EXE_HAUPTPROGRAMMAUFRUF;
end.

