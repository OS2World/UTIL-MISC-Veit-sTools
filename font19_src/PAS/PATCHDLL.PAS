{&Use32+}
program patch_ibm_video_dll;

uses
  HilfsFun,
  Objects,
  Os2Base,
  Os2Def;

const
  nicht_gefunden        =High(word);

var
  para1,para2           :string;
  f                     :file;
  l,o                   :longint;
  p                     :pByteArray;

{$Cdecl+,Orgname+}
function DosReplaceModule(OldModName,NewModName,BackModName: PChar): ApiRet;
  external 'DOSCALLS' index 417;
{$Cdecl-,Orgname-}

function suche(suchzk:string;startindex:word):word;
  var
    i,j                 :word;
    stimmt              :boolean;
  begin
    for i:=startindex to l-Length(suchzk) do
      if p^[i]=Ord(suchzk[1]) then
        begin
          stimmt:=true;
          for j:=2 to Length(suchzk) do
            if (p^[i+j-1]<>Ord(suchzk[j])) and (suchzk[j]<>'?') then
              begin
                stimmt:=false;
                Break;
              end;
          if stimmt then
            begin
              suche:=i;
              Exit;
            end;
        end;
      suche:=nicht_gefunden;
  end;


procedure patch_INITENV(x,y,resx,resy:word);
  begin
(*
USHORT APIENTRY FAR InitEnv(PENVIRONMENT Environment,
                            PVDHSAVEREST ParmBlock,
                            ULONG Function)
{
  USHORT rc = 0xFFFF;
  VDH_MODE ModeParmBlock;
  VDHMODEINFO ModeInfo = {12,                       /* cb */
                          MODE_FLAG_NOT_MONO,       /* flag */
                          4,                        /* no. of colors */
                          80,                       /* col */
                          25,                       /* row */
                          720,                      /* hres */
                          400};                     /* vres */ *)

    // 1552: INITENV
    o:=suche(#$C8#$32#$00#$00           // enter     $32,0
            +#$57                       // push      di
            +#$56                       // push      si
            +#$1E                       // push      ds
            +#$B8'??'                   // mov       ax,
            +#$8E#$D8                   // mov       ds,ax
            +#$C7#$46#$D4#$FF#$FF       // mov       w,[bp-$2C],-1
            +#$C7#$46#$D6'??'           // mov       w,[bp-$2A],12
            +#$C6#$46#$D8#$01           // mov       b,[bp-$28],1
            +#$C6#$46#$D9#$04           // mov       b,[bp-$27],4
            +#$C7#$46#$DA'?'#$00        // mov       w,[bp-$26],80
            +#$C7#$46#$DC'?'#$00        // mov       w,[bp-$24],25
            +#$C7#$46#$DE'??'           // mov       w,[bp-$22],720
            +#$C7#$46#$E0'??',0);       // mov       w,[bp-$20],400

    if o=nicht_gefunden then
      Abbruch('searchstring not found.',1);

    if  (pSmallWord(@p^[o+$1573-$1552])^=x)
    and (pSmallWord(@p^[o+$1578-$1552])^=y)
    and (pSmallWord(@p^[o+$157d-$1552])^=resx)
    and (pSmallWord(@p^[o+$1582-$1552])^=resy) then
      begin
        WriteLn('  already set.');
        Close(f);
        Halt(0);
      end;

    pSmallWord(@p^[o+$1573-$1552])^:=x;
    pSmallWord(@p^[o+$1578-$1552])^:=y;
    pSmallWord(@p^[o+$157d-$1552])^:=resx;
    pSmallWord(@p^[o+$1582-$1552])^:=resy;
  end;

begin
  para1:=ParamStr(1);
  para2:=ParamStr(2);
  if (ParamCount<>2) or (para1='/?') or (para1='-?') then
    begin
      WriteLn('Patch OS/2 video DLL.');
      WriteLn('Usage:');
      WriteLn('  patchdll fix_AccessFont              \os2\dll\bvhvga.dll');
      WriteLn('  patchdll fix_SetHWFontRegs           \os2\dll\bvhvga.dll');
      WriteLn('  patchdll patch_INITENV_80x25_720x400 \os2\dll\bvhsvga.dll');
      WriteLn('  patchdll patch_INITENV_80x25_720x475 \os2\dll\bvhsvga.dll');
      WriteLn('  patchdll patch_INITENV_80x25_720x480 \os2\dll\bvhsvga.dll');
      WriteLn('  patchdll patch_INITENV_80x25_720x500 \os2\dll\bvhsvga.dll');
      WriteLn('  patchdll unlock                      \os2\dll\viocalls.dll');
      Halt(1);
    end;

  DosReplaceModule(@(para2+#0)[1],nil,nil);

  if para1='unlock' then
    Halt(0);

  Assign(f,para2);
  FileMode:=$02;
  Reset(f,1);
  l:=FileSize(f);
  GetMem(p,l);
  BlockRead(f,p^,l);

  if para1='fix_AccessFont' then
    begin
      // 0170: Datensegmentl„nge 3e92->6000
      o:=suche(#$00#$00#$00#$00#$92#$3e#$00#$00#$00#$00#$af#$13#$23#$10#$00#$00,0);
      if o=nicht_gefunden then
        begin
          o:=suche(#$00#$00#$00#$00#$00#$60#$00#$00#$00#$00#$af#$13#$23#$10#$00#$00,0);
          if o=nicht_gefunden then
             Abbruch('searchstring #1 not found.',1);
          WriteLn('  already fixed.');
          Close(f);
          Halt(0);
        end;
      pSmallWord(@p^[o+4])^:=$6000;

      // 6a15: BldFont 1./2./3. Benutzung (2e1c->4000)
      o:=suche(#$8E#$C0
              +#$BF'??'
              +#$8B#$CA
              +#$86#$CD
              +#$C1#$E9#$02
              +#$1E
              +#$56
              +#$C5#$76#$12
              +#$F3#$66#$A5
              +#$5E
              +#$1F
              +#$AC
              +#$F6#$E2
              +#$BF'??'
              +#$03#$F8
              +#$8B#$CA
              +#$F3#$A4
              +#$AC
              +#$22#$C0
              +#$75#$F0
              +#$06
              +#$1F
              +#$BE'??',0);

      if o=nicht_gefunden then
        Abbruch('searchstring #2 not found.',1);

      pSmallWord(@p^[o+$6a18-$6a15])^:=$4000;
      pSmallWord(@p^[o+$6a2f-$6a15])^:=$4000;
      pSmallWord(@p^[o+$6a3f-$6a15])^:=$4000;

    end
  else
  if para1='fix_SetHWFontRegs' then
    begin

// vdhfont.c: SetHWFontRegs
// line compare register Bit 9 (Index 9 Bit 6) immer setzen ($3ff=1023)
// .1B7F489C: C746F20900                   mov       w,[bp][-000E],00009
// .1B7F48A1: 8A4604                       mov       al,[bp][00004]
// .1B7F48A4: FEC8                         dec       al
// .1B7F48A6: 8846EC                       mov       [bp][-0014],al
// .1B7F48A9: C45E06                       les       bx,[bp][00006]
// .1B7F48AC: 26817F0EC800                 cmp       w,es:[bx][0000E],000C8
//->
// .1B7F489C: C746F20900                   mov       w,[bp][-000E],00009
// .1B7F48A1: 8A4604                       mov       al,[bp][00004]
// .1B7F48A4: FEC8                         dec       al
// .1B7F48A6: 0C40                         or        al,040
// .1B7F48A8: 90                           nop
// .1B7F48A9: 8846EC                       mov       [bp][-0014],al
// .1B7F48AC: 26817F0EC800                 cmp       w,es:[bx][0000E],000C8

      o:=suche(#$c7#$46#$f2#$09#$00#$8a#$46#$04#$fe#$c8
              +#$88#$46#$ec#$c4#$5e#$06
              +#$26#$81#$7f#$0e#$c8#$00,0);
      if o=nicht_gefunden then
        begin
          o:=suche(#$c7#$46#$f2#$09#$00#$8a#$46#$04#$fe#$c8
                  +#$0c#$40#$90#$88#$46#$ec
                  +#$26#$81#$7f#$0e#$c8#$00,0);
          if o=nicht_gefunden then
            Abbruch('searchstring #1 not found.',1);
          WriteLn('  already fixed.');
          Close(f);
          Halt(0);
        end;

      p^[o+10]:=$0C;
      p^[o+11]:=$40;
      p^[o+12]:=$90;
      p^[o+13]:=$88;
      p^[o+14]:=$46;
      p^[o+15]:=$EC;

    end
  else
  if para1='patch_INITENV_80x25_720x400' then
    patch_INITENV(80,25,720,400)
  else
  if para1='patch_INITENV_80x25_720x475' then
    patch_INITENV(80,25,720,475)
  else
  if para1='patch_INITENV_80x25_720x480' then
    patch_INITENV(80,25,720,480)
  else
  if para1='patch_INITENV_80x25_720x500' then
    patch_INITENV(80,25,720,500)
  else
    Abbruch('Unknown command '+para1,1);

  Seek(f,0);
  BlockWrite(f,p^,l);
  Close(f);
  WriteLn('  success.');
end.
