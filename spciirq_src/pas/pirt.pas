{&Use32+}
{$R-} (* sum is modulo 256.. *)
unit pirt;

interface

{$IfNDef VirtualPascal}
type
  smallword             =word;
  smallint              =integer;
{$EndIf VirtualPascal}

type
  link_bitmap_type      =
    packed record
      link_value        :byte;
      irq_bitmap        :smallword;
    end;

  slot_entry_type       =
    packed record
      bus               :byte;
      device            :byte;
      link_bitmap       :array[$a..$d] of link_bitmap_type;
      slot_number       :byte;
      reserved          :byte;
    end;

  pirt_type             =
    packed record
      signature         :longint;
      version           :smallword;
      table_size        :smallword;
      router_bus        :byte;
      router_devfunc    :byte;
      pci_exclusive_irq :smallword;
      compatible_vendor :smallword;
      compatible_device :smallword;
      miniport_data     :longint;
      reserved          :array[$14..$1e] of byte;
      checksum          :byte;
      slotentrytable    :array[2..$7ff] of slot_entry_type;
    end;

  p_pirt_type           =^pirt_type;

const
  pirt_ptr              :p_pirt_type=nil;


procedure get_pir(const filename:string);
function irq_bitmap_str(w_and,w_or:smallword):string;
procedure verify_router_address;


implementation

uses
  pci_hw,
  pci_ca,
  {$IfDef VirtualPascal}
  VpUtils,
  {$Else VirtualPascal}
  TpUtils,
  {$EndIf VirtualPascal}
  Strings;

type
  {$IfDef VirtualPascal}
  tByteArray=array[$0000..High(word)] of byte;
  {$Else VirtualPascal}
  tByteArray=array[$0000..$fffe] of byte;
  {$EndIf VirtualPascal}
  pByteArray=^tByteArray;

(* table for router id where it is not the first isa bridge or to speedup the search.. *)
const
    irq_router_table:array[1..7] of array[1..2] of smallword=(

(*** AMD ***)

      (* Bus 0 (PCI), Device Number 7, Device Function 3
         Vendor 1022h Advanced Micro Devices (AMD)
         Device 7413h AMD-766 Power Management Controller *)
      ($1022,$7413),

      (* Bus 0 (PCI), Device Number 7, Device Function 3
         Vendor 1022h Advanced Micro Devices (AMD)
         Device 7443h AMD-768 ACPI Controller *)
      ($1022,$7443),

      (*              AMD-8111 ACPI System Management Controller *)
      ($1022,$746B),

(*** Nvidia ***)
      (*  Bus 0 (PCI), Device Number 0, Device Function 0
          Vendor 10DEh Nvidia Corp
          Device 01E0h nForce2 AGP Controller

          Bus 0 (PCI), Device Number 1, Device Function 0
          Vendor 10DEh Nvidia Corp
          Device 0060h nForce2 ISA Bridge *)
      ($10DE,$0060),

      (*  Bus 0 (PCI), Device Number 0, Device Function 0
          Vendor 10DEh Nvidia Corp
          Device 00E1h nforce3 CPU to PCI Bridge
          PCI Class Bridge, type PCI to HOST

          Bus 0 (PCI), Device Number 1, Device Function 0
          Vendor 10DEh Nvidia Corp
          Device 00E0h nForce3 CPU to ISA Bridge
          PCI Class Bridge, type PCI to ISA *)
      ($10DE,$00E0),


(*** Intel ***)
      (*   (invalid address 0/7/0) (asus machine)
           Bus 0 (PCI Express), Device Number 31, Device Function 0
           Vendor 8086h Intel Corporation
           Device 2641h 82801FBM ICH6M LPC Interface Bridge *)
      ($8086,$2641),


(*** Acer ***)
      (*   (invalid address 255/31/7)
           Bus 0 (PCI), Device Number 2, Device Function 0
           Vendor 10B9h Acer Labs Incorporated (ALi)
           Device 1533h ALI M1533 Aladdin IV ISA Bridge *)
      ($10b9,$1533)

       );


function find_pci_interrupt_router:word;
  var
    oi_b,
    oi_d,
    oi_f              :byte;
    i                 :word;
  begin
    oi_b:=infotbl_bus;
    oi_d:=infotbl_deviceid;
    oi_f:=infotbl_func;

    (* search special devices *)
    for infotbl_bus:=0 to 255 do
      for infotbl_deviceid:=0 to 31 do
        for infotbl_func:=0 to 7 do
          begin
            reset_infotbl_cache;
            for i:=Low(irq_router_table) to High(irq_router_table) do
              if  (infotbl_W(0)=irq_router_table[i,1])
              and (infotbl_W(2)=irq_router_table[i,2]) then
                begin
                  find_pci_interrupt_router:=infotbl_bus*$100+infotbl_deviceid*8+infotbl_func;
                  infotbl_bus     :=oi_b;
                  infotbl_deviceid:=oi_d;
                  infotbl_func    :=oi_f;
                  reset_infotbl_cache;
                  Exit;
                end;
            if not is_multifunction then Break;
          end;

    (* search isa bridge *)
    for infotbl_bus:=0 to 255 do
      for infotbl_deviceid:=0 to 31 do
        for infotbl_func:=0 to 7 do
          begin
            reset_infotbl_cache;
            if infotbl_W($00)<>$ffff then
              if infotbl_L($08) shr 8=$060100 then
                begin
                  find_pci_interrupt_router:=infotbl_bus*$100+infotbl_deviceid*8+infotbl_func;
                  infotbl_bus     :=oi_b;
                  infotbl_deviceid:=oi_d;
                  infotbl_func    :=oi_f;
                  reset_infotbl_cache;
                  Exit;
                end;
            if not is_multifunction then Break;
          end;

    infotbl_bus     :=oi_b;
    infotbl_deviceid:=oi_d;
    infotbl_func    :=oi_f;
    reset_infotbl_cache;
  end;


procedure get_pir(const filename:string);
  var
    f                   :file;
    p                   :pByteArray;
    l,i                 :longint;
    s                   :byte;
    ca,pci_0e           :longint;
    irqmap_code         :longint;

  function checksum_ok(l:longint):boolean;
    var
      s                 :byte;
      w                 :^byte;
    begin
      w:=@p^[i];
      s:=0;
      while l>0 do
        begin
          Inc(s,w^);
          Inc(w);
          Dec(l);
        end;
      checksum_ok:=(s=0);
    end;



  procedure found_table(const where;const len,conmap:word);
    var
      s                 :byte;
      w                 :^byte;
      i                 :word;
      r                 :word;
    begin
      GetMem(pirt_ptr,$20+len);
      FillChar(pirt_ptr^,$20+len,0);
      if filename='' then
        begin (* find pci interrupt router *)
          r:=find_pci_interrupt_router;
          pirt_ptr^.router_bus:=Hi(r);
          pirt_ptr^.router_devfunc:=Lo(r);
        end;
      with pirt_ptr^ do
        begin
          Move(where,slotentrytable,len);
          signature:=Ord('$') shl 0+Ord('P') shl 8+Ord('I') shl 16+Ord('R') shl 24;
          version:=$0100;
          table_size:=$20+len;
          pci_exclusive_irq:={conmap}0;
          i:=table_size;
          s:=0;
          w:=Addr(signature);
          while i>0 do
            begin
              Inc(s,w^);
              Inc(w);
              Dec(i);
            end;
          checksum:=-s;
        end;
    end;


  begin
    if filename='' then
      begin
        l:=0;
        {$IfDef VirtualPascal}
        l:=$10000;
        {$Else}
        l:=$ff00;
        {$EndIf}
        GetMem(p,l);
        Move(Ptr_F000(0)^,p^,l);
      end
    else
      begin
        Assign(f,filename);
        FileMode:=$40;
        {$I-}
        Reset(f,1);
        {$I+}
        if IOResult<>0 then
          begin
            failed:=true;
            Exit;
          end;
        l:=FileSize(f);
        if l>$10000 then
          begin
            Seek(f,l-$10000);
            l:=$10000;
          end;
        {$IfNDef VirtualPascal}
        if l>$ff00 then
          l:=$ff00;
        {$EndIf VirtualPascal}
        {$IfDef VirtualPascal}
        GetMem(p,Max(l,$10000));
        {$Else VirtualPascal}
        GetMem(p,Max(l,$ff00));
        {$Endif VirtualPascal}
        BlockRead(f,p^,l);
        Close(f);
      end;

    i:=0;
    while i+$20<l do
      with p_pirt_type(@p^[i])^ do
        if (signature=Ord('$') shl 0+Ord('P') shl 8+Ord('I') shl 16+Ord('R') shl 24)
        and (version>=$0100) and (version<$0900)
        and (table_size>=$20) and (table_size<$8000) and (table_size and $f=0)
        and (checksum_ok(table_size) or (filename<>''){$IfDef Debug_ROM} or true {$EndIf}) then
          begin
            GetMem(pirt_ptr,table_size);
            Move(p^[i],pirt_ptr^,table_size);
            Dispose(p);
            Exit;
          end
        else
          Inc(i,$10);

    failed:=true;
    {$IfDef OS2}
    set_bios(p^);
    load_irqbuff;
    {$Else}
    if filename<>'' then Exit; (* can only call live BIOS *)
    load_irqbuff;
    {$EndIf}
    if not failed then
      begin
        found_table(irqbuffR.IRQ_routing_table_entry_Array,
                    irqbuffR.length_of_IRQ_routing_table_buffer,
                    conmap);
        Dispose(p);
        Exit;
      end;

    Dispose(p);
  end;

function irq_bitmap_str(w_and,w_or:smallword):string;
  var
    {$IfNDef VirtualPascal}
    Result              :string;
    {$EndIf}
    i                   :word;
    el1                 :boolean;
  begin
    Result:='';

    if w_and<>w_or then
      Result:='<definition mismatch!> ';

    if w_or=0 then
      Result:=Result+'(none)'
    else
      begin
        Result:=Result+'{';
        el1:=true;
        for i:=0 to 15 do
          if Odd(w_or shr i) then
            begin
              if not el1 then
                Result:=Result+',';
              Result:=Result+Int2Str(i);
              if not Odd(w_and shr i) then
                Result:=Result+'?';
              el1:=false;
            end;
        Result:=Result+'}';
      end;
    {$IfNDef VirtualPascal}
    irq_bitmap_str:=Result;
    {$EndIf}
  end;

procedure verify_router_address;
  var
    ct          :longint;
    wrong       :boolean;
    r           :word;
  begin
    with pirt_ptr^ do
      begin
        infotbl_bus:=router_bus;
        infotbl_deviceid:=router_devfunc shr 3;
        infotbl_func:=router_devfunc and 7;
        reset_infotbl_cache;

        wrong:=false;

        if infotbl_W(0)=$ffff then (* no device at address *)
          wrong:=true
        else
          if (router_bus=0) and (router_devfunc=0) then
            begin (* usually PCI Class Bridge, type PCI to HOST *)
              ct:=(infotbl_L($08) shr 8) and $ffff00;
              (* AMD/VIA *)
              if ((infotbl_W(0)=$1106) or (infotbl_W(0)=$1022)) then
                if  (ct<>$060100) (* PCI to ISA   (VT82C686A PCI to ISA Bridge) *)
                and (ct<>$060100) (* PCI to Other (AMD-768 ACPI Controller)     *)
                 then
                  wrong:=true;

              (* Nvidia Corp *)
              if (infotbl_W(0)=$10DE) then wrong:=true;
            end;

        if wrong then
          begin
            WriteLn('Warning: bad table: wrong IRQ router address! Ask vendor for fix!');
            r:=find_pci_interrupt_router;
            pirt_ptr^.router_bus:=Hi(r);
            pirt_ptr^.router_devfunc:=Lo(r);
          end;

      end;
  end;

end.

