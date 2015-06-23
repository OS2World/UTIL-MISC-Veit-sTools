(*$Define TYP_EXE*)
(*$I TYP_COMP.PAS*)
library typ2dll;

{$CDecl+,OrgName+,I-,S-,Delphi+,Use32+}

{  $LINKER
  DESCRIPTION      "REXXEXT - Virtual Pascal for OS/2 v2.0 Demo"
  DATA MULTIPLE NONSHARED

  EXPORTS
    SYSLOADFUNCS = SysLoadFuncs}

(*     $D Typ * Dateitypbestimmung / Archivlistprogramm * V.K.*)

(* 26.12.1993 nach a.exe *)

(*$IfDef VirtualPascal*)
  (*$PMTYPE VIO*)
(*$EndIf VirtualPascal*)

uses
  VpSysLow,
  Os2Base,
  Os2Def,
  Rexx,
  Strings,
  typ_haup;


Function REXX_HAUPTPROGRAMMAUFRUF
               ( Name_     : PChar;
                 ArgC      : ULong;
                 Args      : pRxString;
                 QueueName : pChar;
                 Var Ret   : RxString ) : ULong; export;

  var
    i                   :word;
    q                   :pRxString;
    cmdline01           :array[0..4096-1] of char;
    cmdline_z           :PChar;
  begin
    Ret.StrPtr := '';
    Ret.strLength := StrLen( Ret.StrPtr );

    FillChar(cmdline01,SizeOf(cmdline01),0);
    i:=DosQueryModuleHandle('TYP2DLL.DLL',ModuleHandle);
    if i<>0 then RunError(i);
    {i:=SysCtrlGetModuleName(ModuleHandle,cmdline01);}
    i:=DosQueryModuleName(ModuleHandle,260,cmdline01);
    if i<>0 then RunError(i);

    cmdline_z:=StrEnd(cmdline01);
    Inc(cmdline_z);

    q:=Args;
    for i:=1 to ArgC do
      begin
        if i<>1 then
          begin
            StrCat(cmdline_z,' ');
            cmdline_z:=StrEnd(cmdline_z);
          end;
        StrCat(cmdline_z,q^.strptr);
        cmdline_z:=StrEnd(cmdline_z);
        Inc(q);
      end;

    cmdline:=cmdline01;
//    try ///!!!!!!!!<<
      EXE_HAUPTPROGRAMMAUFRUF;

//    finally

    REXX_HAUPTPROGRAMMAUFRUF := 0;
//    end;
  end;

exports
  EXE_HAUPTPROGRAMMAUFRUF  name 'EXE_TYP2',
  REXX_HAUPTPROGRAMMAUFRUF name 'REXX_TYP2';



function IsInit:boolean;assembler;
  (*$Frame-*)(*$Uses None*)
  asm
    cmp DWord ptr [ebp+$c],0
    sete al
  end;

initialization
  begin

    if IsInit then
      begin
        SysDisplayConsoleError(false,'typ2dll','init');
        einrichten_typ_haup(true);
      end

    else

      begin
        einrichten_typ_haup(false);
        SysDisplayConsoleError(false,'typ2dll','term');
      end;

  end

end.

