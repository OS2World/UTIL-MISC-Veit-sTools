(*$I TYP_COMP.PAS*)

unit typ_takt;

interface

uses
  (*$IfDef OS2*)
  VpSysLow,
  (*$EndIf*)
  typ_type;

var
  taktwert              :longint;
(*$IfDef BILDWIEDERHOLRATE*)
  bildwiederholrate     :longint;
(*$EndIf*)

  (*$IfDef DOS_ODER_DPMI*)
  hib,hib_alt           :byte;
  (*$EndIf*)
  (*$IfDef DPMI32*)
  hib,hib_alt           :byte;
  (*$EndIf*)
  bioswert,bioswert_alt :longint;

(*$IfDef PRUEFE_TAKT*)
  alttakt               :longint;

const
  falsch                :longint=0;
  richtig               :longint=0;

(*$EndIf*)

(*$IfDef OS2*)
const
  rollen_behandlung     :boolean=false;
var
  taktgenauigkeit       :longint;
(*$EndIf*)


(*$IfDef BILDWIEDERHOLRATE*)
procedure wiedrholratentest;
(*$EndIf*)

procedure taktberechnung;

(*$IfDef OS2*)
procedure starte_rollen_thread;
procedure setze_rollgeschwindigkeit(const geschwindigkeit:word_norm);
procedure beende_rollen_thread;

function SemWaitEvent2(s:TSemHandle;_TimeOut:longint):boolean;
(*$EndIf*)

implementation

uses
  (*$IfDef OS2*)
  Os2Base,
  Os2Def,
  VpUtils,
  (*$EndIf*)
  typ_ausg,
  typ_var;

(*$IfDef OS2*)

const
  rollen_thread_id      :longint=-1;
  rollen_handhabe       :HTimer=-1;
  rollen_eventsem       :TSemHandle=-1;

function rollen_thread(p:pointer):longint;
  begin
    repeat
      SemWaitEvent2(rollen_eventsem,-1);
      rollen_behandlung:=true;
      SemPostEvent(benutzereingabe);
    until false;
  end;

procedure starte_rollen_thread;
  begin
    rollen_behandlung:=false;

    beende_rollen_thread;

    rollen_eventsem:=SemCreateEvent(nil,true,false);

    rollen_thread_id:=VPBeginThread(rollen_thread,20*1204,nil);
  end;

procedure setze_rollgeschwindigkeit(const geschwindigkeit:word_norm);
  begin
    if rollen_handhabe<>-1 then
      begin
        DosStopTimer(rollen_handhabe);
        rollen_handhabe:=-1;
      end;

    if geschwindigkeit<=0 then
      Exit;

    case geschwindigkeit of
      6..9:
        DosStartTimer(taktgenauigkeit div 10,HSem(rollen_eventsem),rollen_handhabe);
    else
        DosStartTimer(((6-geschwindigkeit)*taktgenauigkeit) div 10,HSem(rollen_eventsem),rollen_handhabe);
    end;
  end;

procedure beende_rollen_thread;
  begin
    if rollen_thread_id<>-1 then
      begin
        KillThread(rollen_thread_id);
        //?DosWaitThread(rollen_thread_id,dcww_Wait);
      end;

    setze_rollgeschwindigkeit(0);

    SemCloseEvent(rollen_eventsem);
  end;

function SemWaitEvent2(s:TSemHandle;_TimeOut:longint):boolean;
  var
    fehler              :ApiRet;
    anzahl              :longint;

  begin
    if s=-1 then
      RunError(6);

    fehler:=DosWaitEventSem(s,_TimeOut);
    case fehler of
      No_Error:
        begin
          SemWaitEvent2:=true;

          fehler:=DosResetEventSem(s,anzahl);
          case fehler of
            No_Error:
              while anzahl>1 do
                begin
                  SemPostEvent(s);
                  Dec(anzahl);
                end;
            //Error_Already_Reset:
            //  ;
          else
            RunError(fehler);
          end;

        end;

      Error_Timeout:
        begin
          if _TimeOut=-1 then
            RunError(fehler);

          SemWaitEvent2:=false;
          Exit;
        end;

    else
      RunError(fehler);
    end;


  end;

(*$EndIf OS2*)

(*$IfDef BILDWIEDERHOLRATE*)
procedure wiedrholratentest;
  var
    taste               :word;
    zeit1,zeit2         :longint;
  begin
    asm
      mov ax,$6602
      mov bx,437
      mov dx,437
      int $21
    end;
    ruecklauf_warten;
    repeat
      taktberechnung;
    until (hib_alt>$80) or (taktwert>typ_start_zeit+$1000);
    zeit1:=taktwert;
    ruecklauf_warten;
    taktberechnung;
    zeit2:=taktwert;
    if zeit2<=zeit1 then
      zeit1:=zeit2;

    Dec(zeit2,zeit1);
    if zeit2=0 then
      bildwiederholrate:=99999
    else
      bildwiederholrate:=(($1234dd div zeit2) div $100);
  end;
(*$EndIf BILDWIEDERHOLRATE*)

(* DosTmrQueryTime? *)
procedure taktberechnung;
  (*$IfDef OS2*)
  var
    fehler:longint;
  (*$EndIf OS2*)
  begin
    (*$IfDef DOS_ODER_DPMI*)
    port[$43]:=0 shl 6 (* Z„hler 0 *)
              +0 shl 4 (* keine Žnderung, Annahme 1/18,2 *)
              +2 shl 1 (* Betriebsart 2 (Frequenzgenerator) *)
              +0 shl 0 (* bin„r *);

    asm db $eb,$00 end;
    hib:=port[$40];     (* Wert ist nicht wichtig *)
    asm db $eb,$00 end;
    hib:=$ff-port[$40];
    asm db $eb,$00 end;

    bioswert:=MemL[Seg0040:$006c];

    taktwert:=(bioswert shl 8)+hib;

    (*$EndIf DOS_ODER_DPMI*)

    (*$IfDef OS2*)
    fehler:=DosQuerySysInfo(QSV_MS_COUNT,QSV_MS_COUNT,bioswert,SizeOf(bioswert));
    taktwert:=(bioswert shl 8);
    (*$EndIf OS2*)

    (*$IfDef DPMIX*)
    bioswert:=meml[seg0040:$006c];
    taktwert:=bioswert shl 8;
    (*$EndIf DPMIX*)

    (*$IfDef DPMI32*)
    port[$43]:=0 shl 6 (* Z„hler 0 *)
              +0 shl 4 (* keine Žnderung, Annahme 1/18,2 *)
              +2 shl 1 (* Betriebsart 2 (Frequenzgenerator) *)
              +0 shl 0 (* bin„r *);

    asm db $eb,$00 end;
    hib:=port[$40];     (* Wert ist nicht wichtig *)
    asm db $eb,$00 end;
    hib:=255-port[$40];
    asm db $eb,$00 end;

    bioswert:=MemL[Seg0040+$006c];

    taktwert:=(bioswert shl 8)+hib;
    (*$EndIf DPMI32*)


    (*$IfDef PRUEFE_TAKT*)
    if taktwert<alttakt then
      Inc(falsch)
    else
      Inc(richtig);

    alttakt:=taktwert;
    (*$EndIf PRUEFE_TAKT*)

    (*$IfDef DOS_ODER_DPMI*)
    hib_alt:=hib;
    (*$EndIf DOS_ODER_DPMI*)
    (*$IfDef DPMI32*)
    hib_alt:=hib;
    (*$EndIf DPMI32*)
    bioswert_alt:=bioswert;
  end;

(* INITIALISIERUNG IN TYP_EIAU *)
end.

