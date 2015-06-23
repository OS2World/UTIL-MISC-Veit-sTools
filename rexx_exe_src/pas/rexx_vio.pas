program rexx_vio_pascal;

{&PMType VIO}

{$R rexx_vio.res}

uses
  Os2Base,
  Rexx,
  Strings;

const
  RexxResourceType = Ord('R') + Ord('E') shl 8; // 17746
  RexxResourceName = 1;

var
  rc: ApiRet;
  RexxSource: array [0..1] of RxString = ((strlength: 0; strptr: nil), (strlength: 0; strptr: nil));
  Arg: RxString;
  RexxRetVal: RxString;
  RexxRC:     SmallWord;

procedure ErrorMessageHalt(const e: Longint);
  begin
    WriteLn('Error ', e);
    Halt(e);
  end;

begin
  rc := DosQueryResourceSize(ModuleHandle, RexxResourceType, RexxResourceName, RexxSource[0].strlength);
  if rc <> 0 then
    ErrorMessageHalt(rc);

  rc := DosGetResource(ModuleHandle, RexxResourceType, RexxResourceName, Pointer(RexxSource[0].strptr));
  if rc <> 0 then
    ErrorMessageHalt(rc);

  Arg.strptr := StrEnd(CmdLine) + 1;
  Arg.strlength := StrLen(Arg.strptr);

  rc := RexxStart(1            ,        { Number of arguments        }
                  @Arg         ,        { Argument array             }
                  CmdLine      ,        { Name of the REXX procedure }
                  @RexxSource  ,        { Location of the procedure  }
                  'CMD'        ,        { Initial environment name   }
                  rxCommand    ,        { Code for how invoked       }
                  nil          ,        { No EXITs on this call      }
                  RexxRC       ,        { Rexx program output        }
                  RexxRetVal);          { Rexx program output        }

  WriteLn('RC=',RC);
  WriteLn('RexxRC=',RexxRC);
  WriteLn('RexxRetVal=',RexxRetVal.strptr);

  { Release storage allocated by REXX }
  if Assigned(RexxRetVal.strptr) then
    DosFreeMem(RexxRetVal.strptr);

  if Assigned(RexxSource[1].strptr) then
    DosFreeMem(RexxSource[1].strptr);

  DosFreeResource(Pointer(RexxSource[0].strptr));
  if rc = 0 then
    Halt(RexxRC)
  else
    Halt(rc);
end.
