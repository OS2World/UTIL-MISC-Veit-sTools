unit Log;

interface

procedure Log_Ausgabe(const s:string);
procedure Log_Dump(const s:string;const d;const l:longint);
function  MMIOM_Name(const m:Longint):String;

implementation

Uses
  Os2MM,
  Objects,
  VpUtils,
  VpSysLow;

const
  logname               ='M:\xgaproc.log';

var
  log_mutex             :Longint=0;

procedure Log_Ausgabe(const s:string);
  var
//  l                   :Text;
    h                   :Longint;
    rc                  :Longint;
    s2                  :string;
    actual              :Longint;
    actual_seek         :TFileSize;
  begin
    // Kînnte SysLog-Funktion, PMPrintf oder Ñhliches benutzen.
    // Eine einfache Textdatei erfÅllt auch ihren Zweck.
    SysSysWaitSem(log_mutex);
    rc:=SysFileOpen(logname,$42,h);
    (*
    Assign(l,logname);
    {$I-}
    Append(l);
    {$I+}
    rc:=IOResult;*)
    if rc<>0 then
      begin
        rc:=SysFileCreate(logname,$42,0,h);
        (*
        {$I-}
        Rewrite(l);
        {$I+}
        rc:=IOResult;*)
      end;
    if rc=0 then
      rc:=SysFileSeek(h,0,2,actual_seek);
    if rc=0 then
      begin
        s2:=s+^m^j;
        rc:=SysFileWrite(h,s2[1],Length(s2),actual);
        (*
        {$I-}
        WriteLn(l,s);
        {$I+}
        rc:=IOResult;*)
        SysFileClose(h);
        (*
        {$I-}
        Close(l);
        {$I+}
        rc:=IOResult;*)
      end;
    log_mutex:=0;
  end;

procedure Log_Dump(const s:string;const d;const l:longint);
  var
    da                  :TByteArray absolute d;
    i                   :longint;
    s2                  :string;
  begin
    Log_Ausgabe(s);
    for i:=0 to l-1 do
      begin
        if (i and $f)=0 then
          s2:='  '+Int2Hex(i shr 4,7)+'x  ';
        s2:=s2+' '+Int2Hex(da[i],2);
        if ((i and $f)=$f)
        or (i=l-1)
         then
          Log_Ausgabe(s2);
      end;
  end;

const
  MMIOM_Names:array[MMIOM_GETCF..MMIOM_SETIMAGE] of string[Length('QUERYHEADERLENGTH')]=
    ('GETCF',
     'GETCFENTRY',

     'CLOSE',
     'OPEN',
     'READ',
     'SEEK',
     'WRITE',

     'IDENTIFYFILE',
     'GETHEADER',
     'SETHEADER',
     'QUERYHEADERLENGTH',
     'GETFORMATNAME',
     'GETFORMATINFO',
     'SEEKBYTIME',
     'TEMPCHANGE',
     'BEGININSERT',
     'ENDINSERT',
     'SAVE',
     'SET',
     'COMPRESS',
     'DECOMPRESS',
     'MULTITRACKREAD',
     'MULTITRACKWRITE',
     'DELETE',
     'BEGINGROUP',
     'ENDGROUP',
     'UNDO',
     'REDO',
     'BEGINSTREAM',
     'ENDSTREAM',


     'CUT',
     'COPY',
     'PASTE',
     'CLEAR',
     'STATUS',
     'WINMSG',
     'BEGINRECORD',
     'ENDRECORD',

     'QUERYIMAGE',
     'QUERYIMAGECOUNT',
     'SETIMAGE');


function  MMIOM_Name(const m:Longint):String;
  begin
    if (m>=Low(MMIOM_Names)) and (m<High(MMIOM_Names)) then
      Result:=MMIOM_Names[m]
    else
      Result:='MMIOM_'+Int2Hex(m,4);
    while Length(Result)<20 do
      Result:=Result+' ';
  end;

end.
