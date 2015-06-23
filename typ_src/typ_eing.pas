(*$I TYP_COMP.PAS*)
unit typ_eing;

interface

uses
  typ_type;

const
  maus_zeile:word=100;

  maus_taste_l:boolean=falsch;
  maus_taste_m:boolean=falsch;
  maus_taste_r:boolean=falsch;

  eingabe_umgeleitet:boolean=false;

var
  spielhebel_x1,
  spielhebel_x2,
  spielhebel_y1,
  spielhebel_y2         :integer;

function ty_keypressed:boolean;
function ty_readkey:word_norm;
(*$IfDef DOS*)
procedure spielhebel_abfrage;
procedure spielhebel_schalten;
(*$EndIf*)
procedure maus_schalten(const ma:boolean);
procedure maus_holen;

procedure texteingabe_statuszeile(const anfang:string;var s:string;const maxlaenge:word_norm;const abbruch_mit_esc:boolean);

(*$IfDef OS2*)
procedure starte_tastatur_thread;
procedure beende_tastatur_thread;
function warte_auf_benutzereingabe(const ms:longint):boolean;
(*$EndIf*)


implementation

uses
(*$IfDef VirtualPascal*)
  VpSysLow,
(*$EndIf*)
(*$IfDef OS2*)
  Dos,
  Os2Base,
  VPUtils,
(*$EndIf*)
(*$IfDef DPMIX*)
  Crt, (*$Define Crt_ReadKey*)
(*$EndIf*)
(*$IfDef DPMI32*)
  mouse,
(*$EndIf*)
(*$IfDef Linux*)
  Crt, (*$Define Crt_ReadKey*)
(*$EndIf Linux*)
  typ_var,
  typ_ausg,
  typ_varx,
  typ_takt;




(*$IfDef DOS_ODER_DPMI*)
function ty_keypressed:boolean;
  var
    fl:word;
  begin
    asm
      mov fl,0
      mov ah,$11
      int $16
      jz @keine_taste
      mov fl,1
      @keine_taste:
    end;
    ty_keypressed:=(fl<>0);
  end;
(*$EndIf*)

(*$IfDef VirtualPascal*)
(*$IfNDef OS2*)
function ty_keypressed:boolean;
  begin
    (*$IfDef OS2*)
    //DosSleep(10);
    (*$EndIf*)
    ty_keypressed:=SysKeyPressed;
  end;
(*$EndIf*)
(*$EndIf*)

(*$IfDef DPMIX*)
function ty_keypressed:boolean;
  begin
    ty_keypressed:=Crt.KeyPressed;
  end;
(*$EndIf*)

(*$IfNDef OS2*)
function ty_readkey:word_norm;
  var
    t:char;
  begin
    (*$IfDef DOS_ODER_DPMI*)
    asm
      mov ah,$10
      int $16
      cmp al,$e0
      jnz @@keine_graue_taste

      mov al,0

      @@keine_graue_taste:
      cmp al,$00
      jz @@taste_fertig

      mov ah,0 (* keine Funktionstaste *)

      @@taste_fertig:
      mov @result,ax
    end;
    (*$EndIf*)

    (*$IfDef Crt_ReadKey*)
    t:=ReadKey;
    if t in [#$00,#$e0] then
      ty_readkey:=Ord(ReadKey)*256
    else
      ty_readkey:=Ord(t);
    (*$Else crt_ReadKey*)
    (*$IfDef VirtualPascal*)

    t:=SysReadKey;
    if t in [#$00,#$e0] then
      ty_readkey:=Ord(SysReadKey)*256
    else
      ty_readkey:=Ord(t);
    (*$EndIf VirtualPascal*)
    (*$EndIf Crt_ReadKey*)

  end;
(*$EndIf OS2*)

(*$IfDef OS2*)
var
  os2_tastatur_thread_ID:longint=-1;
  tastatur_warte_sem,
  tastatur_starte_sem   :TSemHandle;
  keypressed_sinnvoll   :boolean;

  tasten_puffer         :word;

  gelesen               :word_norm;

function os2_tastatur_thread(p:pointer):longint;
  var
    t:char;
  begin
    repeat

      SemWaitEvent2(tastatur_starte_sem,-1);

      if eingabe_umgeleitet then
        begin
          repeat
            SysFileRead(SysFileStdIn,t,1,gelesen);
            if gelesen=0 then SysCtrlSleep(31);
          until gelesen=1;
          tasten_puffer:=Ord(t);
        end
      else
        begin
          t:=SysReadKey;
          if t in [#$00,#$e0] then
            tasten_puffer:=Ord(SysReadKey)*256
          else
            tasten_puffer:=Ord(t);
        end;

      keypressed_sinnvoll:=true;

      SemPostEvent(tastatur_warte_sem);

      SemPostEvent(benutzereingabe);

    until false;

  end;

procedure starte_tastatur_thread;
  begin
    (*if GetEnv('_emx_sig')*)
    (*
    xwindows_umgeleitet:=    (GetEnv('WINDOWID')<>'')
                         and (GetEnv('COLUMNS')<>'')
                         and (GetEnv('LINES')<>'');*)
    (*$IfDef VirtualPascal*)
    eingabe_umgeleitet:=not IsFileHandleConsole(SysFileStdIn);
    (*$Else*)
    (* TpSysLow.? *)
    (*$EndIf*)
    tastatur_warte_sem:=SemCreateEvent(nil,false,false);
    tastatur_starte_sem:=SemCreateEvent(nil,false,true);
    os2_tastatur_thread_ID:=VPBeginThread(os2_tastatur_thread,20*1024,nil);
  end;

procedure beende_tastatur_thread;
  var
    rc,ended:longint;
  begin
    rc:=KillThread(os2_tastatur_thread_ID);
    ended:=os2_tastatur_thread_ID;
    rc:=DosWaitThread(ended,dcww_Wait);
    os2_tastatur_thread_ID:=-1;
  end;

function ty_keypressed:boolean;
  begin

    if not keypressed_sinnvoll then
      begin
        ty_keypressed:=false;
        Exit;
      end;

    if SemWaitEvent2(tastatur_warte_sem,0) then
      begin
        ty_keypressed:=true;
        SemPostEvent(tastatur_warte_sem);
      end
    else
      ty_keypressed:=false;
  end;

function ty_readkey:word_norm;
  begin
    SemWaitEvent2(tastatur_warte_sem,-1);
    ty_readkey:=tasten_puffer;
    keypressed_sinnvoll:=false;
    SemPostEvent(tastatur_starte_sem);
  end;


(*$EndIf OS2*)

(*$IfDef DOS*)
var
  zaehldurchgaenge      :word;

  x10                   :integer;
  y10                   :integer;
  x20                   :integer;
  y20                   :integer;
  o10                   :boolean;
  u10                   :boolean;
  o20                   :boolean;
  u20                   :boolean;

procedure spielhebel_abfrage;
  var
    z                   :word;
    o1w,o2w,u1w,u2w     :word;
    pw                  :byte;
  begin
    port[$201]:=0;
    spielhebel_x1:=0;
    spielhebel_x2:=0;
    spielhebel_y1:=0;
    spielhebel_y2:=0;
    o1w:=0;
    o2w:=0;
    u1w:=0;
    u2w:=0;
    for z:=1 to zaehldurchgaenge do
      begin
        pw:=port[$201];
        Inc(spielhebel_x1,pw and 01);
        pw:=pw shr 1;
        Inc(spielhebel_y1,pw and 01);
        pw:=pw shr 1;
        Inc(spielhebel_x2,pw and 01);
        pw:=pw shr 1;
        Inc(spielhebel_y2,pw and 01);
        pw:=pw shr 1;
        Inc(o1w,pw and 01);
        pw:=pw shr 1;
        Inc(u1w,pw and 01);
        pw:=pw shr 1;
        Inc(o2w,pw and 01);
        pw:=pw shr 1;
        Inc(u2w,pw and 01);
      end;
    if spielhebel_x1=zaehldurchgaenge then spielhebel_x1:=0;
    if spielhebel_x2=zaehldurchgaenge then spielhebel_x2:=0;
    if spielhebel_y1=zaehldurchgaenge then spielhebel_y1:=0;
    if spielhebel_y2=zaehldurchgaenge then spielhebel_y2:=0;
    o1:=(o1w<zaehldurchgaenge) and o10;
    o2:=(o2w<zaehldurchgaenge) and o20;
    u1:=(u1w<zaehldurchgaenge) and u10;
    u2:=(u2w<zaehldurchgaenge) and u20;
    Dec(spielhebel_x1,x10);
    Dec(spielhebel_y1,y10);
    Dec(spielhebel_x2,x20);
    Dec(spielhebel_y2,y20);
  end;

procedure spielhebel_schalten;
  begin
    zaehldurchgaenge:=2000;
    x10:=0;
    y10:=0;
    x20:=0;
    y20:=0;
    o10:=wahr;
    u10:=wahr;
    o20:=wahr;
    u20:=wahr;
    spielhebel_abfrage;
    begin
      zaehldurchgaenge:=(spielhebel_y1+spielhebel_y2)*2;
      if (spielhebel_y1=0) and (spielhebel_y2=0) then spielhebel:=falsch
      else
        begin
          x10:=spielhebel_x1;
          y10:=spielhebel_y1;
          x20:=spielhebel_x2;
          y20:=spielhebel_y2;
          o10:=not o1;
          u10:=not u1;
          o20:=not o2;
          u20:=not u2;
        end;
    end;

  end;

(*$IfOpt S+*)
  (*$Define OPT_S*)
  (*$S-*)
(*$EndIf*)
procedure mausbehandlung;far;assembler;
  asm
    push ds
      push ax
        push bx

          mov ax,seg(maus_taste_l)
          mov ds,ax


          mov al,bl
          and al,$01
          mov maus_taste_l,al

          mov al,bl
          and al,$02
          mov maus_taste_r,al

          mov al,bl
          and al,$04
          mov maus_taste_m,al

          mov maus_zeile,dx

        pop bx
      pop ax
    pop ds
  end;

(*$IfDef OPT_S*)
  (*$S+*)
  (*$UnDef OPT_S*)
(*$EndIf*)


procedure maus_schalten(const ma:boolean);
  begin
    if ma then
      asm
        mov ax,$0021 (* schnelles R…ksetzten *)
        int $33
        cmp ax,$ffff
        je @treiber_gefunden

        mov ax,$0000 (* R…ksetzen *)
        int $33
        cmp ax,$FFFF
        jne @FEHLSCHLAG

      @treiber_gefunden:
        mov ax,$000C (* Mausbedienung *)
        mov cx,$007F(* Zeilen,Spalten, alle Tasten *)
        mov dx,seg (mausbehandlung)
        mov es,dx
        mov dx,offset (mausbehandlung)
        int $33

        mov ax,$000F (* Empfindlichkeit *)
        mov cx,$0001 (* ! *)
        mov dx,$0001 (* unwichtig *)
        int $33;

        mov ax,$0007 (* Bereich *)
        mov cx,0
        mov dx,201
        int $33

        mov ax,$0004 (* Cursorposition *)
        mov cx,0
        mov dx,100
        int $33

        jmp @@ENDE

      @FEHLSCHLAG:
        mov maustreiber,falsch

        @@ENDE:
      end
    else
      asm
        mov ax,$0021 (* schnelles R…ksetzten *)
        int $33
        cmp ax,$ffff
        je @treiber_gefunden

        mov ax,$0000 (* R…ksetzen *)
        int $33

      @treiber_gefunden:
      end;
    maus_zeile:=100;
    maus_taste_l:=falsch;
    maus_taste_m:=falsch;
    maus_taste_r:=falsch;
  end;


procedure maus_holen;
  begin
  end;

(*$EndIf*)

(*$IfDef OS2*)

const
  maus_thread_nummer    :longint=-1;
  maushandhabe          :smallword=$ffff;

function os2_maus_thread(p:pointer):longint;
  var
    maus_event          :^MouEventInfo;
    maus_event_         :array[1..2*SizeOf(MouEventInfo)] of byte;
    waitflag            :word;
  begin

    maus_event:=Fix_64k(@maus_event_,SizeOf(maus_event^));
    FillChar(maus_event^,SizeOf(maus_event^),0);

    waitflag:=1;

    with maus_event^ do
      repeat

      MouReadEventQue(maus_event^,waitflag,maushandhabe);
      if Time<>0 then
        begin

          maus_taste_l:=maus_taste_l or ((fs and (bit01+bit02))<>0);
          maus_taste_r:=maus_taste_r or ((fs and (bit03+bit04))<>0);
          maus_taste_m:=maus_taste_m or ((fs and (bit05+bit06))<>0);

          if (fs and (bit00+bit01+bit03+bit05))<>0 then
            maus_zeile:=(row*200) div bzeilen;

        end;

      SemPostEvent(benutzereingabe);

      (* Wenn die Maus in den Rollbereich geschoben wird
         ist eine Verzoegerung notwendig *)
      if (maus_zeile<100-10) or (100+10<maus_zeile) then
        begin
          waitflag:=0;
          SysCtrlSleep(31);
        end
      else
        waitflag:=1;

    until false;

  end;



procedure maus_schalten(const ma:boolean);
  var
    posi                :^PtrLoc;
    posi_               :array[0..1] of PtrLoc;
    ended,
    rc                  :longint;
  begin
    maus_zeile:=100;

    if not maustreiber then exit;

    if ma then
      begin

        if MouOpen(nil,maushandhabe)<>0 then
          begin
            maustreiber:=falsch;
            Exit;
          end;

        posi:=fix_64k(@posi_,SizeOf(posi^));
        posi^.col:=80 div 2;
        posi^.row:=bzeilen div 2;
        fehler:=MouSetPtrPos(posi^,maushandhabe);

        (*MouFlushQue(maushandhabe);*)

        maus_thread_nummer:=VPBeginThread(os2_maus_thread,20*1024,nil);

      end
    else
      begin
        rc:=KillThread(maus_thread_nummer);
        ended:=maus_thread_nummer;
        rc:=DosWaitThread(ended,dcww_Wait);
        maus_thread_nummer:=-1;
        fehler:=MouClose(maushandhabe);
        maushandhabe:=word(-1);
      end;
  end;

procedure maus_holen;
  begin
  end;


function warte_auf_benutzereingabe(const ms:longint):boolean;
  begin
    warte_auf_benutzereingabe:=SemWaitEvent2(benutzereingabe,ms);
  end;

(*$EndIf*)

(*$IfDef DPMI*)
procedure maus_schalten(const ma:boolean);
  begin
    (* NOP *)
  end;

procedure maus_holen;
  begin
    (* NOP *)
  end;
(*$EndIf*)

(*$IfDef LNX*)
procedure maus_schalten(const ma:boolean);
  begin
    // nicht implementiert
  end;

procedure maus_holen;
  begin
    // nicht implementiert
  end;
(*$EndIf*)

(*$IfDef DPMI32*)
procedure maus_schalten(const ma:boolean);
  var
    x,y                 :longint;
  begin
    if ma then
      begin
        if SysTVDetectMouse>0 then
          begin
            SysTVInitMouse(x,y);
            mouse_set_y_cursor_range(0,201);
            mouse_set_cursor_position(0,100);
            mouse_set_mousemovement_pixel_ratio(8,1);
          end
        else
          maustreiber:=falsch
      end
    else
      SysTVDoneMouse(true);

    maus_zeile:=100;
    maus_taste_l:=falsch;
    maus_taste_m:=falsch;
    maus_taste_r:=falsch;
  end;

procedure maus_holen;
  var
    me:TSysMouseEvent;
  begin
    if SysTvGetMouseEvent(me) then
      begin
        maus_zeile:=me.smePos.Y;
        maus_taste_l:=(me.smeButtons and 1)>0;
        maus_taste_m:=(me.smeButtons and 4)>0;
        maus_taste_r:=(me.smeButtons and 2)>0;
      end;
  end;

(*$EndIf*)

(*$IfDef W32*)
procedure maus_schalten(const ma:boolean);
  begin
    // nicht implementiert
  end;
procedure maus_holen;
  begin
    // nicht implementiert
  end;
(*$EndIf*)



procedure texteingabe_statuszeile(const anfang:string;var s:string;const maxlaenge:word_norm;const abbruch_mit_esc:boolean);
  var
    taste               :word_norm;
    position            :word_norm;
  begin
    position:=length(s)+1;
    repeat
      schreibe_statuszeile(anfang+copy(s,1,position-1)+'ｮ'+copy(s,position,255)+' ',wahr);
      taste:=ty_readkey;

      case taste of
        $0000:;
        $0008:
          if position>1 then
            begin
              dec(position);
              delete(s,position,1);
            end;
        $0009:;
        $000d:
          break;
        $001b:
          begin
            if abbruch_mit_esc and (s='') then
              break;
            s:='';
            position:=1;
          end;
        $4700: (* Pos1 *)
          position:=1;
        $4b00: (* <- *)
          if position>1 then
            dec(position);
        $4d00: (* -> *)
          if position<=length(s) then
            inc(position);
        $4f00: (* Ende *)
          position:=length(s)+1;
        $5300: (* Enttf *)
          if position<=length(s) then
            delete(s,position,1);

      else
        if (length(s)<maxlaenge)
        and ((taste and $FF)>0)
         then
          begin
            insert(chr(taste and $FF),s,position);
            inc(position);
          end;
      end;
    until false;
  end;



end.

