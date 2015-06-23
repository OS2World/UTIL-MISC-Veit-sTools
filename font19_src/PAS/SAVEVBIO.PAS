{$IfNDef VirtualPascal}
{$M 16384,80000,80000}
{$EndIf}
{&Use32+}
program save_vga_bios_to_file;

uses
  {$IfDef Os2}
  Os2Def,
  Os2Base,
  {$EndIf Os2}
  Objects,
  HilfsFun;

var
  {$IfDef Os2}
  biosc000              :array[0..$ffff] of byte;
  {$Endif Os2}
  p_biosc000,
  p_biosc800            :pByteArray;

{$IfDef Os2}
procedure os2_read_bios;

  var
    hand,
    action,
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
    FillChar(biosc000,SizeOf(biosc000),0);

    Fehlerbehandlung('Can not open driver "SCREEN$"',
      DosOpen('SCREEN$',hand,action,0,0,1,$40,nil));

    ParmLen:=SizeOf(ParmRec1);

    with ParmRec1 do
      begin
        phys32:=$000c0000;
        laenge:=0;
      end;

    datalen:=SizeOf(data1);
    rc:=DosDevIOCtl(
            hand,                       // Handle to device
            IOCTL_SCR_AND_PTRDRAW,      // Category of request
            SCR_ALLOCLDT,               // Function being requested
            @ParmRec1,                  // Input/Output parameter list
            ParmLen,                    // Maximum output parameter size
            @ParmLen,                   // Input:  size of parameter list
                                        // Output: size of parameters returned
            @Data1,                     // Input/Output data area
            Datalen,                    // Maximum output data size
            @DataLen);                  // Input:  size of input data area
    if rc=0 then
      begin

        asm {&Saves None}
          push gs

            sub esi,esi
            mov gs,data1.sel

            mov edi,offset biosc000
            mov ecx,$10000
            cld
          @l1:
            mov al,gs:[esi]
            inc esi
            stosb
            loop @l1

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
                @ParmLen,                       // Input:  size of parameter list
                                                // Output: size of parameters returned
                nil,                            // Input/Output data area
                Datalen,                        // Maximum output data size
                @DataLen);                      // Input:  size of input data area

      end;

    DosClose(hand);
  end;
{$EndIf Os2}

var
  f                     :file;
  l                     :longint;

begin
  {$IfDef Os2}
  os2_read_bios;
  p_biosc000:=@biosc000[$0000];
  p_biosc800:=@biosc000[$8000];
  {$Else Os2}
  GetMem(p_biosc000,$8000);Move(Mem[$c000:0],p_biosc000^,$8000);
  GetMem(p_biosc800,$8000);Move(Mem[$c800:0],p_biosc800^,$8000);
  {$EndIf Os2}

  if (p_biosc000^[0]<>$55) or (p_biosc000^[1]<>$aa) or (p_biosc000^[2]>$80) or (p_biosc000^[2]<$01) then
    Abbruch('Not a VGA BIOS at C000:0',1);

  l:=p_biosc000^[2]*512;

  if ParamCount=0 then
    Assign(f,'VGABIOS.BIN')
  else
    Assign(f,ParamStr(1));
  Rewrite(f,1);

  if l>$8000 then
    BlockWrite(f,p_biosc000^,$8000)
  else
    BlockWrite(f,p_biosc000^,l);

  Dec(l,$8000);
  if l>0 then
    BlockWrite(f,p_biosc800^,l);

  Close(f);
  {$IfNDef Os2}
  Dispose(p_biosc000);
  Dispose(p_biosc800);
  {$EndIf Os2}
end.
