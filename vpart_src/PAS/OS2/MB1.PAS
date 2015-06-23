(*&Use32+*)
unit mb1; (* Lesen des Speichers 0..1 MB *)

interface

procedure bios_speicher_lesen(var ziel);
function word_speicher_lesen(const segm,offs:word):smallword;

implementation

uses
  Os2Base,
  Os2Def;

(***************************************************************************)

procedure speicher_lesen(const segm,offs:word;var ziel;const anz_byte:longint);
  var
    hand,
    action,
    phys,
    rc                  :longint;

    ParmRec1:
      record            // Input parameter record
        phys32          :longint;
        laenge          :smallword;
      end;

    ParmRec2:
      record
        sel             :smallword;
      end;

    ParmLen             : ULong;  // Parameter length in bytes
    DataLen             : ULong;  // Data length in bytes
    Data1:
      record
        sel             :smallword;
      end;

  begin
    if DosOpen('SCREEN$',hand,action,0,0,1,$40,nil)<>0 then
      exit;

    phys:=segm*16+offs;
    ParmLen:=SizeOf(ParmRec1);

    with ParmRec1 do
      begin
        phys32:=(phys div 4096)*4096;
        laenge:=(anz_byte+$0fff) and $fffff000;
        if phys32+laenge<phys+anz_byte then
          Inc(laenge,4096);
      end;

    datalen:=SizeOf(data1);
    rc:=DosDevIOCtl(
            hand,                       // Handle to device
            IOCTL_SCR_AND_PTRDRAW,      // Category of request
            SCR_ALLOCLDT,               // Function being requested
            @ParmRec1,                  // Input/Output parameter list
            ParmLen,                    // Maximum output parameter size
            Addr(ParmLen),              // Input:  size of parameter list
                                        // Output: size of parameters returned
            @Data1,                     // Input/Output data area
            Datalen,                    // Maximum output data size
            Addr(DataLen));             // Input:  size of input data area
    if rc=0 then
      begin

        asm (*$SAVES NONE*)
          push gs

            mov esi,phys
            and esi,(4096-1)
            mov gs,data1.sel

            mov edi,ziel
            mov ecx,anz_byte
            jecxz @l2

            cld
          @l1:
            mov al,gs:[esi]
            inc esi
            stosb
            loop @l1

          @l2:

          pop gs
        end;

        ParmLen:=SizeOf(ParmRec2);

        with ParmRec2 do
          begin
            sel:=data1.sel;
          end;

        DataLen:=0;
        rc:=DosDevIOCtl(
                hand,                           // Handle to device
                IOCTL_SCR_AND_PTRDRAW,          // Category of request
                SCR_DEALLOCLDT,                 // Function being requested
                @ParmRec2,                      // Input/Output parameter list
                ParmLen,                        // Maximum output parameter size
                Addr(ParmLen),                  // Input:  size of parameter list
                                                // Output: size of parameters returned
                nil,                            // Input/Output data area
                Datalen,                        // Maximum output data size
                Addr(DataLen));                 // Input:  size of input data area

      end;

    DosClose(hand);
  end;

(***************************************************************************)

procedure bios_speicher_lesen(var ziel);
  begin
    FillChar(ziel,$fff0,0);
    speicher_lesen($f000,$0000,ziel,$f000); (* <64K *)
  end;

(***************************************************************************)

function word_speicher_lesen(const segm,offs:word):smallword;
  var
    tmp:smallword;
  begin
    speicher_lesen(segm,offs,tmp,2);
    word_speicher_lesen:=tmp;
  end;

(***************************************************************************)

end.

