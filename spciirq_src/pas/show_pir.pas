program show_irq_routing_table;

uses
  {$IfDef VirtualPascal}
  VpUtils,
  {$Else VirtualPascal}
  TpUtils,
  {$EndIf VirtualPascal}
  Crt,
  RedirCon,
  pci_hw,
  pci_ca,
  pirt;

var
  sl,i,p                : Integer;
  already_used_at       : String;


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
      WriteLn('Show PCI Routing Table');
      WriteLn('Usage: SHOW_PIR [BIOS-source]');
      WriteLn('  if no BIOS source file is specified, it is taken from the running BIOS.');
      Halt(99);
    end;

  open_pci_access_driver;

  get_pir(ParamStr(1));
  if not Assigned(pirt_ptr) then
    begin
      WriteLn('table not found.');
      {$IfDef OS2}
      if ParamStr(1)='' then
        WriteLn('please try to run me in a DOS session.');
      {$EndIf OS2}
      Halt(99);
    end;

  with pirt_ptr^ do
    begin
      WriteLn('Version: ',Hi(version),'.',Int2Hex(Lo(version),2));
      WriteLn('Router: Bus=',router_bus:3,' Device=',router_devfunc shr 3:2,' Function=',router_devfunc and 7);
      WriteLn('  compatible: $',Int2Hex(compatible_vendor,4),':$',Int2Hex(compatible_device,4));
      WriteLn('pci exclusive : ',irq_bitmap_str(pci_exclusive_irq,pci_exclusive_irq));
      if miniport_data<>0 then
        WriteLn('miniport data?? : $',Int2Hex(miniport_data,8));
      for sl:=Low(slotentrytable) to table_size div SizeOf(slot_entry_type)-1 do
        with slotentrytable[sl] do
          begin
            if sl=Low(slotentrytable) then
              Writeln('--------------------------------------------------------');
            Write('Bus=',bus:3,' Device=',device shr 3:2);
            if slot_number=0 then
              Write(' (mainboard) ')
            else
              Write(' (slot=',slot_number:2,')   ');
            WriteLn;

            if (device and $07)<>0 then
              WriteLn(' - Warning: function bits are nonzero!');

            already_used_at := '';
            for i:=Low(slotentrytable) to sl-1 do
              if  (slotentrytable[i].bus           =bus)
              and ((slotentrytable[i].device shr 3)=(device shr 3)) then
                already_used_at := already_used_at + Int2Str(i - Low(slotentrytable) + 1) + ', ';

            if already_used_at <> '' then
              WriteLn(' - Error: same Bus/Device was already used at entry ',
                Copy(already_used_at, 1, Length(already_used_at)-Length(', ')));

            for p:=$a to $d do
              with link_bitmap[p] do
                if link_value<>0 then
                  begin
                    WriteLn('  INT',Int2Hex(p,1),'# Link=$',Int2Hex(link_value,2),' ',irq_bitmap_str(irq_bitmap,irq_bitmap));
                  end;
          end;

    end;
  Dispose(pirt_ptr);

  close_pci_access_driver;
end.

