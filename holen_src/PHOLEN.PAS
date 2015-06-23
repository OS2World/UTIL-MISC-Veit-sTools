program prot_bios_holen;
(* V.K. 19.10,20.10,08.11.1997 *)

uses i1587;

type
  block         =array[0..32*1024-1] of byte;

var
  puffer        :block;
  d             :file of block;
  zaehler       :word;
  adr           :longint;
  puffer_adr    :longint;

begin
  puffer_adr:=seg(puffer)*longint(16)+ofs(puffer);

  if paramcount=1 then
    assign(d,paramstr(1))
  else
    assign(d,'PROTBIOS.BIO');

  rewrite(d);

  (* "E000" , "F000" *)
  for zaehler:=1 to (2*64*1024) div sizeof(block) do
    begin
      adr:=(zaehler-1)*longint(sizeof(block))+$fffe0000;
      bios_kopiere(adr,puffer_adr,sizeof(block) div 2);
      write(d,puffer);
    end;

  close(d);
end.
