{&Use32+}
program display_crtc;

uses
  HilfsFun;

var
  i                     :word;
  VRes                  :word;

function IfBit(v:byte;bit:byte;res:word):integer;
  begin
    if Odd(v shr bit) then
      IfBit:=res
    else
      IfBit:=0;
  end;

begin

{
  for i:=0 to $1f do
    Write(crtc(i));

  WriteLn;
  WriteLn;}

  Write('     ');
  for i:=0 to $0f do
    Write('x',Int2Hex(i,1),'  ');
  WriteLn;

  for i:=0 to $1f do
    begin
      if (i and $f)=0 then Write(Int2Hex(i shr 4,1),'x   ');
      Write(Int2Hex(crtc(i),2),'  ');
      if (i and $f)=$f then WriteLn;
    end;
  WriteLn;

  VRes:=IfBit(crtc($07),6,$200)+IfBit(crtc($07),1,$100)+crtc($12)+1;
  WriteLn('VRes                         ',VRes:4);
  WriteLn('end vertical retrace         ',crtc($11) and $f:4);
  WriteLn('end vertical blanking        ',crtc($16) and $1f:4);
  WriteLn('end vertical display         VRes+',IfBit(crtc($07),6,$200)+IfBit(crtc($07),1,$100)+crtc($12)-VRes:4);
  WriteLn('start vertical blanking-1    VRes+',IfBit(crtc($09),5,$200)+IfBit(crtc($07),3,$100)+crtc($15)-VRes:4);
  WriteLn('start vertical retrace       VRes+',IfBit(crtc($07),7,$200)+IfBit(crtc($07),2,$100)+crtc($10)-VRes:4);
  WriteLn('vertical total-2             VRes+',IfBit(crtc($07),5,$200)+IfBit(crtc($07),0,$100)+crtc($06)-VRes:4);
  WriteLn('line compare register        VRes+',IfBit(crtc($09),6,$200)+IfBit(crtc($07),4,$100)+crtc($18)-VRes:4);
end.
