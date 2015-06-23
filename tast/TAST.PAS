unit tast;
(* Veit Kannegieser * 05.11.1997 *)
(*                    39.12.1997 *)
(* 1999.01.30 VP 2.0: DPMI32     *)
(* 2000.12.07 Quelltextversch”nerung, gepackte record-Typen, Fix_64k *)
(*            Registeroptimierung DPMI32                             *)


interface

type
  tasten_typ=
    packed record
      ascii             :char;
      scan              :byte;
    end;

var
  taste                 :tasten_typ;

procedure hole_taste;
procedure hole_taste_erw;
function frage_ob_taste_vorhanden:boolean;
function frage_ob_taste_vorhanden_erw:boolean;

implementation

(*$IFDEF VIRTUALPASCAL*)
(*$IFDEF OS2*)
uses
  OS2Base,
  VpSysLow;

procedure hole_taste;
  begin
    hole_taste_erw;
    if taste.scan=$e0 then taste.scan:=$00;
  end;

procedure hole_taste_erw;
  var
    Key                 :^KbdKeyInfo;
    LKey                :array[0..1] of KbdKeyInfo;
    fehler              :longint;
  begin
    Key:=Fix_64k(@LKey,SizeOf(KbdKeyInfo));
    fehler:=KbdCharIn(Key^,io_Wait,0);
    taste.ascii:=Key^.chChar;
    taste.scan :=Key^.chScan;
  end;

function frage_ob_taste_vorhanden:boolean;
  begin
    frage_ob_taste_vorhanden:=frage_ob_taste_vorhanden_erw;
  end;

function frage_ob_taste_vorhanden_erw:boolean;
  var
    Key                 :^KbdKeyInfo;
    LKey                :array[0..1] of KbdKeyInfo;
    fehler              :longint;
  begin
    Key:=Fix_64k(@LKey,SizeOf(KbdKeyInfo));

    with Key^ do
      begin
        fehler:=KbdPeek(Key^,0);
        frage_ob_taste_vorhanden_erw:=(fbStatus and kbdtrf_Final_Char_In) <> 0
      end;
  end;
(*$ENDIF*)

(*$IFDEF DPMI32*)
procedure hole_taste;(*$Uses EAX*)(*$Frame-*)
  asm
    mov ah,$00
    int $16
    mov taste,ax
  end;

procedure hole_taste_erw;(*$Uses EAX*)(*$Frame-*)
  asm
    mov ah,$10
    int $16
    mov taste,ax
  end;

function frage_ob_taste_vorhanden:boolean;(*$Uses NONE*)(*$Frame-*)
  asm
    mov ah,$01
    int $16
    setnz al
  end;

function frage_ob_taste_vorhanden_erw:boolean;(*$Uses NONE*)(*$Frame-*)
  asm
    mov ah,$11
    int $16
    setnz al
  end;
(*$ENDIF*)


(*$ELSE*)
procedure hole_taste;
  begin
    asm
      mov ah,$00
      int $16
      mov taste,ax
    end;
  end;

procedure hole_taste_erw;
  begin
    asm
      mov ah,$10
      int $16
      mov taste,ax
    end;
  end;

function frage_ob_taste_vorhanden:boolean;
  begin
    asm
      mov ah,$01
      int $16
      (* cmp ax,0 *)
      jz @keine
      mov al,true
      jmp @fertig
      @keine:
      mov al,false
      @fertig:
      mov @result,al
    end;
  end;

function frage_ob_taste_vorhanden_erw:boolean;
  begin
    asm
      mov ah,$11
      int $16
      (* cmp ax,0 *)
      jz @keine
      mov al,true
      jmp @fertig
      @keine:
      mov al,false
      @fertig:
      mov @result,al
    end;
  end;
(*$ENDIF*)

end.

