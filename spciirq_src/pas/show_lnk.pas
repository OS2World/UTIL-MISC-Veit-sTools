{&Use32+}
program show_irq_link_conflicts;

(* option to emulate a different machine using pirt.dat and pci.log *)
{- $Define pci_Debug}

uses
  pirt,
  {$IfDef VirtualPascal}
  VpUtils,
  {$Else VirtualPascal}
  TpUtils,
  {$EndIf VirtualPascal}
  Crt,
  RedirCon,
  pci_hw,
  pci_ca;


var
  irq_used              :array[$a..$d] of boolean;
  sl                    :integer;
  link,pin              :byte;
  found                 :boolean;
  irq_line_bitmap_and   :smallword;
  irq_line_bitmap_or    :smallword;
  irq_hw                :byte;
  routing_table_entry_for_bus:array[byte] of boolean;

const
  dump_router           :boolean=false;
  irq_seen              :set of byte=[];
  link_seen             :set of byte=[];

type
  pin_set_range         = 1..4;
  pin_set_type          = set of pin_set_range;

  used_4_type           =array[1..4] of ^boolean;

const
  anypin                =[1,2,3,4];

const
  ATI_link_translation  :array[1..8] of byte=(  0,  1,  2,  3,  9, 10, 11, 12);

  acer_link             :array[1..8] of byte=($48,$48,$49,$49,$4d,$74,$4b,$4b);
  acer_shift            :array[1..8] of byte=(  0,  4,  0,  4,  0,  0,  0,  4);

{$I via_bios.inc}
{$I classes.pas}

function r_vendor(const w:word):boolean;
  begin
    r_vendor:=(pirt_ptr^.compatible_vendor=w) or (infotbl_W($00)=w);
  end;

function r_device(const w:word):boolean;
  begin
    r_device:=(pirt_ptr^.compatible_device=w) or (infotbl_W($02)=w);
  end;

function PinSet2Hex(const ps:pin_set_type):string;
  var
    tmp                 :string;
    i                   :word;
  begin
    tmp:='';
    for i:=Low(pin_set_range) to High(pin_set_range) do
      if i in ps then
        begin
          if tmp<>'' then tmp:=tmp+'+';
          tmp:=tmp+'INT'+Int2Hex($a+i-Low(pin_set_range),1)+'#';
        end;
    PinSet2Hex:=tmp;
  end;

const
  boolean_str_edge_level:array[boolean] of string[10]=(
    ' (edge)',
    ' (level)');

function eisa_irq_control(const int:byte):string;

  begin
    eisa_irq_control:='';
    {$IfNDef pci_Debug}
    if (Port[$4d0]<>$ff) or (Port[$4d1]<>$ff) then
      if int in [3..7,9..12,14..15] then
        eisa_irq_control:=boolean_str_edge_level[Odd(Port[$4d0+(int shr 3)] shr (int and 7))];
    {$EndIf pci_Debug}
  end;

function linkinfo(link:byte;var irq_hw:byte):string;
  var
    b                   :byte;
    via_index,
    via_shift           :byte;
    {$IfNDef VirtualPascal}
    Result              :string;
    {$EndIf}
  begin
    irq_hw:=$ff;
    with pirt_ptr^ do
      begin
        infotbl_bus:=router_bus;
        infotbl_deviceid:=router_devfunc shr 3;
        infotbl_func:=router_devfunc and 7;
        reset_infotbl_cache;
        if (compatible_vendor=0) or (compatible_vendor=$ffff) then
          Result:=' (no link info, ask author for $'           +Int2Hex(infotbl_W(0)     ,4)
            +':$'+Int2Hex(infotbl_W(2)     ,4)+'!)'
        else
          Result:=' (no link info, ask author for compatible:$'+Int2Hex(compatible_vendor,4)
            +':$'+Int2Hex(compatible_device,4)+'!)';

        (* Intel, 82371FB PIIX PCI to ISA Bridge,.. *)
        if  (link in [1..8,$60..$63,$68..$6b])
        and r_vendor($8086)
        {$IfDef Obsolete}
        and (   r_device($7110)  (* compatible: 7000! *)
             or r_device($122e)
             or r_device($2480)  (* 82801CA LPC Interface (ICH3-S B1 step) *)
             or r_device($248C)  (* 82801CAM (ICH3-M) LPC Interface *)
             or r_device($1234)  (* 82371MX 430MX Mobile Chipset MPIIX + EIDE + I/O -- found in compatible to $248C *)
             or r_device($244C)  (* 82801BAM LPC Interface (ICH2-M B2 step) *)
             or r_device($24d0)  (* 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge *)
             or r_device($7000)  (* 845: compatible to ...  7000: 82371SB PIIX3 ISA Bridge *)
             or r_device($2410)  (* 82801AA 8xx Chipset LPC Interface Bridge *)
             or r_device($24CC)  (* 82801DBM (ICH4-M) LPC Interface Bridge *)
             or r_device($2440) ...
                               )
        {$EndIf Obsolete}
         then
          begin
            (* 29056201.pdf Seite 59:
               Bit7     Interrupt routing enable 0=enable 1=disable
                  6..4  reserved, read:0
                  3..0  IRQ 3/4/5/6/7/9/10/11/12/14/15 oder reserved *)
            if link in [1..4] then
              b:=infotbl($60+link-1)
            else
            if link in [5..8] then
              b:=infotbl($68+link-5) (* geraten,nocht nicht in der Wirklichkeit gesehen *)
            else
              b:=infotbl(link);

            if (b<1) or Odd(b shr 7) then
              Result:=' (IRQ disabled)'
            else
              begin
                Result:=' IRQ '+Int2Str(b)+eisa_irq_control(b);
                irq_hw:=b;
              end;
          end (* Intel *)

        (* VIA, VT82C596/A/B "Mobile South" PCI to ISA Bridge,.. *)
        else
        if (   ((link in [1..9]) and translate_via_link(link,via_index,via_shift))
            or (link in [$55,$56,$57]))
        and (   r_vendor($1106)  (* VIA *)
             or r_vendor($1022)) (* AMD *)

        and (   r_device($0586)  (* VIA VT82C586/A/B                PCI to ISA Bridge *)
             or r_device($0596)  (* VIA VT82C596/A/B "Mobile South" PCI to ISA Bridge *)
             or r_device($0686)  (* VT82C686/A/B "Super South"      PCI to ISA Bridge *)
             or r_device($0696)

             or r_device($3074)  (*?VIA VT8233  PCI to ISA Bridge *)
             or r_device($3109)  (*?VIA VT8233C PCI to ISA Bridge *)
             or r_device($3147)  (*?VIA VT8233A PCI to ISA Bridge *)
             or r_device($3177)  (* VIA VT8235  PCI to ISA Bridge *)
             or r_device($3227)  (* VIA VT8237  PCI to ISA Bridge *)
             or r_device($8231)  (*?VIA VT8231  PCI to ISA Bridge *)


             or r_device($7400)  (* AMD-755 (Cobra) PCI to ISA Bridge -geraten fr AMD-75X: k7ai2aa1.bin *)
             or r_device($7408)  (* AMD-756 (Viper) PCI to ISA Bridge -geraten fr AMD-75X: k7ai2aa1.bin *)

          (* or r_device($7410)  (  AMD-766 PCI to ISA/LPC Bridge              *)
             or r_device($7413)  (* AMD-766 Power Management Controller        *)

          (* or_r_device($7440)  (  AMD-768 PCI to ISA/LPC Bridge              *)
             or r_device($7443)  (* AMD-768 ACPI Controller                    *)

          (* or r_device($7468)  (  AMD-8111 LPC Bridge                        *)
             or r_device($746B)  (* AMD-8111 ACPI System Management Controller *)
             )

         then
          begin
(* IL(1a/b1/via):
Format of AMD-645 Peripheral Bus Controller, function 0 (PCI-ISA bridge) data:
54h    BYTE    PCI IRQ Edge/Level selection (see #01024)
55h    BYTE    PnP Routing for external MIRQ0/1 (see #01025)
56h    BYTE    PnP Routing for PCI INTB/INTA (see #01027)
57h    BYTE    PnP Routing for PCI INTD/INTC (see #01028)
58h    BYTE    PnP Routing for external MIRQ2 (see #01029)
59h    BYTE    MIRQ pin configuration (see #01030)

Bitfields for AMD-645 PCI IRQ Edge/Level Select register:
Bit(s)  Description     (Table 01024)
 7-4    reserved
 3      PIRQA# is edge-sensitive rather than level-sensitive
 2      PIRQB# is edge-sensitive
 1      PIRQC# is edge-sensitive
 0      PIRQD# is edge-sensitive
SeeAlso: #01011,#01023,#01025

Bitfields for AMD-645 PnP IRQ Routing 1 register:
Bit(s)  Description     (Table 01025)
 7-4    routing for MIRQ1 (see #01026)
 3-0    routing for MIRQ0 (see #01026)
SeeAlso: #01011,#01024

(Table 01026)
Values for AMD-645 IRQ routing:
 0000   disabled
 0001   IRQ1
 0010   reserved
 0011   IRQ3
 ...
 0111   IRQ7
 1000   reserved
 1001   IRQ9
 ...
 1100   IRQ12
 1101   reserved
 1110   IRQ14
 1111   IRQ15
SeeAlso: #01025,#01027,#01028,#01029

Bitfields for AMD-645 PnP IRQ Routing 2 register:
Bit(s)  Description     (Table 01027)
 7-4    routing for PIRQB# (see #01026)
 3-0    routing for PIRQA# (see #01026)
SeeAlso: #01025,#01028,#01029

Bitfields for AMD-645 PnP IRQ Routing 3 register:
Bit(s)  Description     (Table 01028)
 7-4    routing for PIRQD# (see #01026)
 3-0    routing for PIRQC# (see #01026)
SeeAlso: #01025,#01027,#01029

Bitfields for AMD-645 PnP IRQ Routing 4 register:
Bit(s)  Description     (Table 01029)
 7-4    reserved
 3-0    routing for MIRQ2# (see #01026)
SeeAlso: #01025,#01027,#01028

Bitfields for AMD-645 MIRQ Pin Configuration register:
Bit(s)  Description     (Table 01030)
 7-3    reserved (0)
 2      select MASTER# instead of MIRQ2
 1      select KEYLOCK instead of MIRQ1
 0      select APICCS# instead of MIRQ0
SeeAlso: #01011,#01029                                  *)
(*
            case link of
                1:b:=infotbl($56) shr 4;
                2:b:=infotbl($56) shr 0;
                3:b:=infotbl($57) shr 4;
                4:b:=infotbl($57) shr 0; {?}
                5:b:=infotbl($55) shr 4;
                6:b:=infotbl($55) shr 0; {?}
              $55:b:=infotbl($55) shr 4;
              $56:b:=infotbl($56) shr 0;{?? shr 0/4}
              $57:b:=infotbl($57) shr 4;
            end;*)

            case link of
              $55:
                begin
                  via_index:=$55;
                  via_shift:=4;
                end;
              $56:
                begin
                  via_index:=$56;
                  via_shift:=0;
                end;
              $57:
                begin
                  via_index:=$57;
                  via_shift:=4;
                end;
            end;

            b:=(infotbl(via_index) shr via_shift) and $0f;

            if b=0 then
              Result:=' (IRQ disabled)'
            else
              begin
                Result:=' IRQ '+Int2Str(b);
                irq_hw:=b;
                if eisa_irq_control(b)<>'' then
                  Result:=Result+eisa_irq_control(b)
                else
                  if via_index in [$56,$57] then
                    Result:=Result+boolean_str_edge_level[not Odd(
                      infotbl($54) shr (4-((via_index-$56)*2+via_shift div 4)))];
              end;

            {
            if link in [Low(via_translate)..High(via_translate)] then
              link:=via_translate[link];
            case link of
              1:b:=(infotbl($55) shr 4) and $0f;
              2:b:=(infotbl($56) shr 0) and $0f;
              3:b:=(infotbl($56) shr 4) and $0f;
           // 4:b:=??
              5:b:=(infotbl($44) shr 0) and $0f;
              6:b:=(infotbl($44) shr 4) and $0f;
              7:b:=(infotbl($45) shr 0) and $0f;
              8:b:=(infotbl($45) shr 4) and $0f;
            //9:b:=(infotbl($45)?
            else
                b:=0;
            end;}
          end (* VIA *)


        (* SiS635,SiS730 *)
        else
        if  (link in [$41,$42,$43,$44])
        and r_vendor($1039)
        and (   r_device($0008))
        (* more?
        D       0008    SiS PCI to ISA Bridge (LPC Bridge)
        D       0018    SiS950 PCI to ISA Bridge (LPC Bridge)
        D       0963    SiS963 PCI to ISA Bridge (LPC Bridge)
        D       5582    SiS5582 PCI to ISA Bridge *)
         then
          begin
            b:=infotbl(link);
            if Odd(b shr 7) then
              begin
                Result:=' IRQ '+Int2Str(b-$80)+eisa_irq_control(b-$80);
                irq_hw:=b-$80;
              end
            else
              Result:=' (IRQ disabled)'
          end
        (* SiS496/497 *)
        else
        if  (link in [1..4,$c0..$c3])
        and r_vendor($1039)
        and r_device($0496)
         then
          begin

            if link<$c0 then
              b:=infotbl($c0+link-1)
            else
              b:=infotbl(link);

            if Odd(b shr 7) then
              begin
                Result:=' IRQ '+Int2Str(b-$80)+eisa_irq_control(b-$80);
                irq_hw:=b-$80;
              end
            else
              Result:=' (IRQ disabled)'
          end


        (* NVidia Corp - guessed *)
        else
        if  (link in [1..{8}4,5,15])
        and r_vendor($10de)
        and (not r_device($01E0) (* nForce2 AGP Controller    *))
        and (not r_device($00E1) (* nforce3 CPU to PCI Bridge *))
        and ((infotbl_bus<>0) or (infotbl_deviceid<>0) or (infotbl_func<>0))
         then
          begin
            case link of
              1:b:=infotbl($7c) shr 0;
              2:b:=infotbl($7c) shr 4;
              3:b:=infotbl($7d) shr 0;
              4:b:=infotbl($7d) shr 4;
              5:b:=infotbl($7e) shr 0; (* nForce2 - ASUS A7N8X2.0 Deluxe ACPI BIOS Rev 1007 *)
                                       (* nForce3 - GigaByte K8NSC939 *)
             15:b:=infotbl($82) shr 4; (* nForce2 - ASUS A7N8X2.0 Deluxe ACPI BIOS Rev 1007 *)
                                       (* but expects 3Com card... *)
            end;
            b:=b and $f;
            if b=0 then
              Result:=' (IRQ disabled)'
            else
              begin
                Result:=' IRQ '+Int2Str(b)+eisa_irq_control(b);
                irq_hw:=b;
              end;
          end


        (* guessed *)
        (* D 1533 ALI M1533 Aladdin IV/V ISA South Bridge *)
        else
        if  (link in [1..8])
        and r_vendor($10b9)
        and r_device($1533)
         then
          begin
            b:=infotbl(acer_link[link]);
            b:=(b shr acer_shift[link]) and $0f;

            case b of
            (*
            LINE 0 1 2 3 4 5 6 7 8 9 a b c d e f
            ALI  0 - - 2 4 5 7 6 - 1 3 9 b - d f *)
              0:b:= 0;
              1:b:= 9;
              2:b:= 3;
              3:b:=$a;
              4:b:= 4;
              5:b:= 5;
              6:b:= 7;
              7:b:= 6;
              8:b:=-0;
              9:b:=$b;
             $a:b:=-0;
             $b:b:=$c;
             $c:b:=-0;
             $d:b:=$e;
             $e:b:=-0;
             $f:b:=$f;
            end;
            if b=0 then
              Result:=' (IRQ disabled)'
            else
              begin
                Result:=' IRQ '+Int2Str(b);
                (* no idea how edge/level is coded *)
                irq_hw:=b;
              end;
          end

        (* ALi MAGiK 1 - guessed *)
        else
        if  (link in [1..8{9?}])
        and r_vendor($10b9)
         then
          begin
            b:=infotbl($48+(link-1) div 2);
            if Odd(link-1) then
              b:=b shr 4;
            b:=b and $f;

            case b of
            (*
            LINE 0 1 2 3 4 5 6 7 8 9 a b c d e f
            ALI  0 8 0 2 4 5 7 6 0 1 3 9 b 0 d f *)
              0:b:= 0;
              1:b:= 9;
              2:b:= 3;
              3:b:=$a;
              4:b:= 4;
              5:b:= 5;
              6:b:= 7;
              7:b:= 6;
              8:b:= 1;
              9:b:=$b;
             $a:b:=-0;
             $b:b:=$c;
             $c:b:=-0;
             $d:b:=$e;
             $e:b:=-0;
             $f:b:=$f;
            end;
            if b=0 then
              Result:=' (IRQ disabled)'
            else
              begin
                Result:=' IRQ '+Int2Str(b);
                (* no idea how edge/level is coded *)
                irq_hw:=b;
              end;
          end

        (* Cyrix 5530 *)
        else
        if  (link in [1..4])
        and r_vendor($1078)
        and (r_device($0000{unsure}) or r_device($0002) or r_device($0100))
        (* D 0000 Cx5520 ISA Bridge Rev.0 *)
        (* D 0002 Cx5520 ISA Bridge Rev.1 *)
        (* D 0100 5530 Kahula/Geode Legacy ISA Bridge *)
         then
          begin
            b:=infotbl_L($5c) shr (4*link-1);
            if b=0 then
              Result:=' (IRQ disabled)'
            else
              begin
                Result:=' IRQ '+Int2Str(b)+eisa_irq_control(b);
                irq_hw:=b;
              end;
          end

        (* ServerWorks (Was: Reliance Computer Corp) CSB4,CSB5,.. *)
        else
        if r_vendor($1166)
        (* D 0200 OSB4 PCI to ISA Bridge   !
           D 0201 CSB5 PCI to ISA Bridge   !
           D 0203 CSB6 PCI to ISA Bridge   ?
           D 0230 PCI to ISA Bridge        ? *)

         then
          begin
            Port[$0c00]:=link;
            b:=Port[$0c01];
            if b=0 then (* 0=unset, some others are reserved *)
              Result:=' (IRQ disabled)'
            else (* 3,4,5,7,9,10,11,12 *)
              begin
                Result:=' IRQ '+Int2Str(b)+eisa_irq_control(b);
                irq_hw:=b;
              end;
          end

        (* ATI *)
        else
        if r_vendor($1002)
        (* D 4377 IXP SB400 PCI-ISA Bridge *)
        and (link in [1..8])
         then
          begin
            Port[$0c00] := ATI_link_translation[link];
            if b=0 then
              Result:=' (IRQ disabled)'
            else
              begin
                Result:=' IRQ '+Int2Str(b)+eisa_irq_control(b);
                irq_hw:=b;
              end;
          end

        (* nothing found *)
        else
          begin
            dump_router:=true;
            (* keep 'no link info' *)
          end;

      end;

    {$IfNDef VirtualPascal}
    linkinfo:=Result;
    {$EndIf}
  end;

procedure display_classcode;
  var
    pcl                 :word;
  begin
    TextAttr:=Yellow;
    if (infotbl($0b)>=Low(pci_class_names)) and (infotbl($0b)<=High(pci_class_names)) then
      Write(pci_class_names[infotbl($0b)],': ')
    else
      Write('Class=',infotbl($0b),'?: ');
    pcl:=Low(pci_class_array);
    repeat
      if pcl>High(pci_class_array) then
        begin
          (* map 'Storage:Subclass=1 programming interface=138' *)
          (* to  'Storage:IDE(programming interface=138)'       *)
          pcl:=Low(pci_class_array);
          repeat
            if pcl>High(pci_class_array) then
              begin
                Write('Subclass=$',Int2Hex(infotbl($0a),2),' programming interface=$',Int2Hex(infotbl($09),2));
                Break;
              end;
            with pci_class_array[pcl] do
              if (class_=infotbl($0b)) and (subclass=infotbl($0a)) then
                begin
                  Write(cname);
                  (* programming interface is special for storage/ide:
                     it has busmaster/native mode.. flags              *)
                  if (infotbl($0b)<>1(*Stoarge*)) or (infotbl($0a)<>1(*IDE*)) then
                    Write(' (programming interface=$',Int2Hex(infotbl($09),2),')');
                  Break;
                end;
            Inc(pcl);
          until false;
          Break;
        end;

      with pci_class_array[pcl] do
        if (class_=infotbl($0b)) and (subclass=infotbl($0a)) and (progif=infotbl($09)) then
          begin
            Write(cname);
            Break;
          end;
      Inc(pcl);
    until false;
    TextAttr:=LightGray;
  end; (* display_classcode *)

procedure display_intline;
  begin
    if WhereX<40 then GotoXY(40,WhereY);
    if infotbl($3c) in [1..254{15?}] then
      begin
        Write(' (',infotbl($3c),')');
        irq_seen:=irq_seen+[infotbl($3c)];
      end
    else (* 0/255 *)
      Write(' (disabled)');
  end;

procedure sort_routing_table;
  var
    i,j                 :integer;
    tmp                 :slot_entry_type;
  begin
    with pirt_ptr^ do
      for i:=Low(slotentrytable) to Integer(table_size div SizeOf(slot_entry_type))-1-1 do
        for j:=i to Integer(table_size div SizeOf(slot_entry_type))-1 do
          if ( (slotentrytable[i].bus shl 8)
              + slotentrytable[i].device    )
            >( (slotentrytable[j].bus shl 8)
              + slotentrytable[j].device    ) then
            begin
              tmp:=slotentrytable[i];
              slotentrytable[i]:=slotentrytable[j];
              slotentrytable[j]:=tmp;
            end;
  end;

procedure setup_routing_table_entry_for_bus;
  var
    i                   :integer;
  begin
    FillChar(routing_table_entry_for_bus,SizeOf(routing_table_entry_for_bus),false);

    with pirt_ptr^ do
      for i:=Low(slotentrytable) to Integer(table_size div SizeOf(slot_entry_type))-1 do
        routing_table_entry_for_bus[slotentrytable[i].bus]:=true;
  end;

procedure search_devices(var used_4:used_4_type;const bus_min,bus_max,dev_min,dev_max:byte);
  var
    org_bus,
    org_deviceid,
    org_func            :byte;
    passed_4            :used_4_type;
  begin
    org_bus     :=infotbl_bus;
    org_deviceid:=infotbl_deviceid;
    org_func    :=infotbl_func;

    infotbl_bus:=bus_min;
    for infotbl_deviceid:=dev_min to dev_max do
      for infotbl_func:=0 to 7 do
        begin
          reset_infotbl_cache;

          if infotbl_W($00)<>$ffff then
            begin

              (* behind pci->pci bridges, the IRQ pin use rotates for every device *)
              (* see specification page 115 *)
              if infotbl($3d) in [1..4] then
                used_4[1+(infotbl($3d)-1+(infotbl_deviceid-dev_min)) and 3]^:=true;


              if is_bridge_with_pass_pci_irq then
                if (infotbl_bus<infotbl($19)) (* secondary bus ok? *)
                and (infotbl($19)<=infotbl($1a)) (* subordinate bus number ok? *)
                and (infotbl($1a)<=bus_max) then
                  if not routing_table_entry_for_bus[infotbl($19)] then
                    begin
                      if infotbl($3d) in [1..4] then
                        begin { pin can be read, assume that it is used for all device pins }
                          (* 1 -> INTA#,INTA#,INTA#,INTA#
                             2 -> INTB#,INTB#,INTB#,INTB#
                             3 -> INTC#,INTC#,INTC#,INTC#
                             4 -> INTD#,INTD#,INTD#,INTD# *)
                          passed_4[1]:=used_4[1+(infotbl($3d)-1+(infotbl_deviceid-dev_min)) and 3];
                          passed_4[2]:=passed_4[1];
                          passed_4[3]:=passed_4[1];
                          passed_4[4]:=passed_4[1];
                        end
                      else
                        begin { no pin, assume passthroug with rotate }
                              { rotate table is in pci bridge spec page 114 }
                          (* else INTA#,INTB#,INTC#,INTD# *)
                          passed_4[1]:=used_4[1+(0+(infotbl_deviceid-dev_min)) and 3];
                          passed_4[2]:=used_4[1+(1+(infotbl_deviceid-dev_min)) and 3];
                          passed_4[3]:=used_4[1+(2+(infotbl_deviceid-dev_min)) and 3];
                          passed_4[4]:=used_4[1+(3+(infotbl_deviceid-dev_min)) and 3];
                        end;

                      search_devices(passed_4,infotbl($19),infotbl($1a),0,31);
                    end;


            end;

          if not is_multifunction then
            Break;
        end;

    infotbl_bus     :=org_bus;
    infotbl_deviceid:=org_deviceid;
    infotbl_func    :=org_func;
    reset_infotbl_cache;
  end;

procedure display_devices(const pin_set:pin_set_type;const bus_min,bus_max,dev_min,dev_max:byte);
  var
    org_bus,
    org_deviceid,
    org_func            :byte;
    new_pin_set         :pin_set_type;
    i                   :word;
  begin
    org_bus     :=infotbl_bus;
    org_deviceid:=infotbl_deviceid;
    org_func    :=infotbl_func;

    infotbl_bus:=bus_min;
    for infotbl_deviceid:=dev_min to dev_max do
      for infotbl_func:=0 to 7 do
        begin
          reset_infotbl_cache;

          if infotbl_W($00)<>$ffff then
            begin

              (* rotate pins for device behind bridge<>0 *)
              new_pin_set:=[];
              for i:=1 to 4 do
                if i in pin_set then
                  new_pin_set:=new_pin_set+[1+(i-1+4-(infotbl_deviceid-dev_min)) and 3];

              if infotbl($3d) in new_pin_set then
                begin
                  if dev_min<>dev_max then
                    WriteLn('* Bus=',infotbl_bus:3,' Device=',infotbl_deviceid{ shr 3}:2,
                      '             INT',Int2Hex(infotbl($3d)+$a-1,1),'#');
                  Write('  Function=',infotbl_func,'  ');
                  display_classcode;
                  display_intline;
                  WriteLn;
                end;


              if is_bridge_with_pass_pci_irq then
                if (infotbl_bus<infotbl($19)) (* secondary bus ok? *)
                and (infotbl($19)<=infotbl($1a)) (* subordinate bus number ok? *)
                and (infotbl($1a)<=bus_max) then
                  if not routing_table_entry_for_bus[infotbl($19)] then
                    begin
                      if infotbl($3d)=0 then
                        (* assume A#->A# .. D#->D# *)
                        display_devices(new_pin_set,infotbl($19),infotbl($1a),0,31)
                      else
                      if infotbl($3d) in new_pin_set then
                        (* assume only the indicated pin is used for any pins on devices behind the bridge *)
                        display_devices(anypin     ,infotbl($19),infotbl($1a),0,31);
                    end;

            end;

          if not is_multifunction then
            Break;
        end;

    infotbl_bus     :=org_bus;
    infotbl_deviceid:=org_deviceid;
    infotbl_func    :=org_func;
    reset_infotbl_cache;
  end;

procedure write_irq_bitmap_str;
  var
    i                   :word;
    el1                 :boolean;
    oa                  :byte;
  begin
    oa:=TextAttr;
    if irq_line_bitmap_and<>irq_line_bitmap_or then
      begin
        TextColor(LightRed);
        Write('<definition mismatch!> ');
        TextAttr:=oa;
      end;

    if irq_line_bitmap_or=0 then
      begin
        TextColor(LightRed);
        Write('(none)');
        TextAttr:=oa;
      end
    else
      begin
        Write('{');
        el1:=true;
        for i:=0 to 15 do
          if Odd(irq_line_bitmap_or shr i) then
            begin
              if not el1 then
                Write(',');
              if Odd(irq_line_bitmap_and shr i) then
                begin
                  if i=irq_hw then
                    TextColor(LightGreen);
                  Write(i);
                  TextAttr:=oa;
                end
              else
                begin
                  TextColor(LightRed);
                  if i=irq_hw then
                    TextColor(LightGreen);
                  Write(i);
                  TextColor(LightRed);
                  Write('?');
                  TextAttr:=oa;
                end;
              el1:=false;
            end;
        Write('}');
      end;
  end;

procedure dump_router_config_space;
  var
    i,j                 :word;
  begin
    with pirt_ptr^ do
      begin
        infotbl_bus:=router_bus;
        infotbl_deviceid:=router_devfunc shr 3;
        infotbl_func:=router_devfunc and 7;
        reset_infotbl_cache;
        WriteLn('Interrupt Router configuration space: ');
        Write('    ');
        for i:=0 to 15 do
          Write(' x'+Int2Hex(i,1));
        WriteLn;
        for j:=0 to 15 do
          begin
            Write(' '+Int2Hex(j,1)+'x ');
            for i:=0 to 15 do
              begin

                if (j*16+i>$40)
                and (   ((infotbl(j*16+i) shr 4) in irq_seen)
                     or ((infotbl(j*16+i) and $f) in irq_seen)
                     or (j*16+i in link_seen)                   ) then
                  TextColor(LightMagenta);

                Write(' '+Int2Hex(infotbl(j*16+i),2));
                TextColor(LightGray);
              end;
            WriteLn;
          end;
      end;
  end; (* dump_router_config_space *)

var
  pins_now              :pin_set_type;
  used_4                :used_4_type;

begin

  if ioredirected then
    begin
      Assign(Output,'');
      Rewrite(Output);
    end
  else
    begin
      ClrScr;
      install_pager;
    end;

  if (ParamStr(1)='?') or (ParamStr(1)='-?') or (ParamStr(1)='/?')
  or (ParamCount>1) then
    begin
      WriteLn('Show PCI Routing Table from link view');
      WriteLn('Usage: SHOW_LNK [BIOS-source]');
      WriteLn('  if no BIOS source file is specified, it is taken from the running BIOS,');
      WriteLn('  and SHOW_LNK als interprets it by looking for matching PCI devices.');

      Halt(99);
    end;

  open_pci_access_driver;

  if ParamStr(1)='' then
    begin
      pci_present_test;
      if failed then
        begin
          WriteLn('PCI not present.');
          Halt(99);
        end;
    end;


{$IfDef pci_Debug2}
  get_pir('M:\pirt.dat');
{$Else}
  get_pir(ParamStr(1));
{$EndIf}
  if not Assigned(pirt_ptr) then
    begin
      WriteLn('table not found.');
      {$IfDef OS2}
      if ParamStr(1)='' then
        WriteLn('please try to run me in a DOS session.');
      {$EndIf OS2}
      Halt(99);
    end;

  if ParamStr(1)='' then
    verify_router_address;

  with pirt_ptr^ do
    begin

      for sl:=Low(slotentrytable) to Integer(table_size div SizeOf(slot_entry_type))-1 do
        with slotentrytable[sl] do
          for pin:=Low(link_bitmap) to High(link_bitmap) do
            with link_bitmap[pin] do
              link_seen:=link_seen+[link_value];

      sort_routing_table;

      setup_routing_table_entry_for_bus;

      if ParamStr(1)='' then
        begin

          for sl:=Low(slotentrytable) to Integer(table_size div SizeOf(slot_entry_type))-1 do
            with slotentrytable[sl] do
              begin
                FillChar(irq_used,SizeOf(irq_used),false);
                used_4[1]:=@irq_used[$a];
                used_4[2]:=@irq_used[$b];
                used_4[3]:=@irq_used[$c];
                used_4[4]:=@irq_used[$d];
                search_devices(used_4,bus,255,device shr 3,device shr 3);

                (* delete slot entries with no present devices *)
                for pin:=$a to $d do
                  if not (irq_used[pin]) then
                    begin
                      link_bitmap[pin].link_value:=0;
                      link_bitmap[pin].irq_bitmap:=0;
                    end;

              end;
        end;

      for link:=1 to 255 do
        begin
          found:=false;
          irq_line_bitmap_and:=$ffff; (* all  *)
          irq_line_bitmap_or :=$0000; (* none *)
          for sl:=Low(slotentrytable) to Integer(table_size div SizeOf(slot_entry_type))-1 do
            with slotentrytable[sl] do
              begin
                pins_now:=[];
                for pin:=Low(link_bitmap) to High(link_bitmap) do
                  with link_bitmap[pin] do
                    if link=link_value then
                      begin
                        pins_now:=pins_now+[pin-Low(link_bitmap)+1];
                        irq_line_bitmap_and:=irq_line_bitmap_and and irq_bitmap;
                        irq_line_bitmap_or :=irq_line_bitmap_or  or  irq_bitmap;
                      end;

                if pins_now=[] then Continue;

                if not found then
                  begin
                    Write('Link value $');
                    TextAttr:=White{LightCyan?};
                    Write(Int2Hex(link,2));
                    TextAttr:=LightGray;
                    Write(':');
                    if ParamStr(1)='' then
                      Write(linkinfo(link,irq_hw));
                    WriteLn;
                    found:=true;
                  end;

                Write('+ Bus=',bus:3,' Device=',device shr 3:2);
                if slot_number=0 then
                  Write(' (mainboard) ')
                else
                  Write(' (slot=',slot_number:2,')   ');

                Write(PinSet2Hex(pins_now));

                if ParamStr(1)='' then
                  begin
                    (* assume: bridge is on func 0 *)
                    infotbl_bus:=bus;
                    infotbl_deviceid:=device shr 3;
                    infotbl_func:=0;
                    reset_infotbl_cache;
                    if headertype in [1,2] then
                      begin
                        Write('  ');
                        display_classcode
                      end;
                  end;

                WriteLn;
                if ParamStr(1)='' then
                  display_devices(pins_now,bus,255,device shr 3,device shr 3);

              end; (* slotentrytable[sl] *)

          if found then
            begin
              Write('> possible connection: ');
              write_irq_bitmap_str;
              WriteLn;
              WriteLn;
            end;

        end;

    end;

  if dump_router then
    dump_router_config_space;

  Dispose(pirt_ptr);
  close_pci_access_driver;
end.

