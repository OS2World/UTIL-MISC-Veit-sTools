program copy_biosf000xxxx_to_file;

uses
  pci_hw;

var
  TargetFileName        :string;
  f                     :file;
  buffer                :array[0..$8000-1] of byte;

begin
  TargetFileName:=ParamStr(1);
  if (TargetFileName='?') or (TargetFileName='-?') or (TargetFileName='/?')
  or (ParamCount>1) then
    begin
      WriteLn('Copy BIOS F000:xxxx area to file');
      WriteLn('Usage: SAVE_BIO [target file]');
      WriteLn('  if target filename ist not given, it is f000.bin.');
      Halt(99);
    end;

  open_pci_access_driver;

  if TargetFileName='' then
    TargetFileName:='f000.bin';

  Assign(f,TargetFileName);
  Rewrite(f,1);

  Move(Ptr_F000($0000)^,buffer,$8000);
  BlockWrite(f,buffer,$8000);

  Move(Ptr_F000($8000)^,buffer,$8000);
  BlockWrite(f,buffer,$8000);

  Close(f);

  close_pci_access_driver;
end.

