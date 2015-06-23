{&Use32+}
program extract_pci_routing_table_from_file;

uses
  pci_hw,
  pci_ca,
  pirt;

var
  d                     :file;
  rc                    :integer;
  target_name           :string;

begin

  if (ParamStr(1)='?') or (ParamStr(1)='-?') or (ParamStr(1)='/?')
  or (ParamCount>2) then
    begin
      WriteLn('Extract PCI Routing Table from BIOS to file');
      WriteLn('Usage: EXTR_PIR [BIOS-source [target file]]');
      WriteLn('  if no BIOS source file is specified, it is taken from the running BIOS.');
      WriteLn('  if target filename ist not given, it is pirt.dat.');
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

  if ParamStr(2)='' then
    target_name:='pirt.dat'
  else
    target_name:=ParamStr(2);

  Assign(d,target_name);
  {$I-}
  Rewrite(d,1);
  {$I+}
  rc:=IOResult;
  if rc<>0 then
    begin
      Write('Can not create ',target_name,'!, rc=',rc);
      Halt(rc);
    end;
  BlockWrite(d,pirt_ptr^,pirt_ptr^.table_size);
  Close(d);

  close_pci_access_driver;
end.

