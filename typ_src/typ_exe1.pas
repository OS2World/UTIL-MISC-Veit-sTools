(*$I TYP_COMP.PAS*)
unit typ_exe1;

interface

(*$IfDef VirtualPascal*)
(*$OrgName+*)
procedure EXE_BUSCH;
(*$OrgName-*)
(*$Else*)
procedure exe_busch;
(*$EndIf*)

(*$IfDef VirtualPascal*)
(*$OrgName+*)
procedure SEKT_BUSCH;
(*$OrgName-*)
(*$Else*)
procedure sekt_busch;
(*$EndIf*)

(*$IfDef VirtualPascal*)
(*$OrgName+*)
procedure DAT_BUSCH;
(*$OrgName-*)
(*$Else*)
procedure dat_busch;
(*$EndIf*)


implementation


(*$IfDef VirtualPascal*)
procedure EXE_BUSCH;external;
(*$L BUSCH\EXE___32.OBJ*)
(*$Else*)
procedure exe_busch;external;
(*$L BUSCH\EXE___16.OBJ*)
(*$EndIf*)

(*$IfDef VirtualPascal*)
procedure SEKT_BUSCH;external;
(*$L BUSCH\SEKT__32.OBJ*)
(*$Else*)
procedure sekt_busch;external;
(*$L BUSCH\SEKT__16.OBJ*)
(*$EndIf*)

(*$IfDef VirtualPascal*)
procedure DAT_BUSCH;external;
(*$L BUSCH\DAT___32.OBJ*)
(*$Else*)
procedure dat_busch;external;
(*$L BUSCH\DAT___16.OBJ*)
(*$EndIf*)

end.
