uses
  VpSysLow,
  VpUtils;

const
  basisport=$3100;

{#define IO_PT_CODEC_CMD     ( gwPTBaseIO + 0x30 )
#define IO_PT_CODEC_STATUS  ( gwPTBaseIO + 0x30 )
#define IO_PT_CODEC_DATA    ( gwPTBaseIO + 0x32 )
#define IO_PT_CODEC_FORMATA  ( gwPTBaseIO + 0x34 )
#define IO_PT_CODEC_FORMATB  ( gwPTBaseIO + 0x36 )}

const
  IO_PT_CODEC_CMD       =$30;
  IO_PT_CODEC_STATUS    =$30;
  IO_PT_CODEC_DATA      =$32;
  IO_PT_CODEC_FORMATA   =$34;
  IO_PT_CODEC_FORMATB   =$36;


{#define _CODEC_RST_TIMEOUT  ( _1uS * 30 )
#define _CODEC_RW_TIMEOUT   ( _1uS * 10 )}
  _CODEC_RST_TIMEOUT=1;
  _CODEC_RW_TIMEOUT =1;

procedure vDelay(const m:word);
  var
    z:word;
  begin
    //SysCtrlSleep(m{*30});
    for z:=1 to 100 do ;
  end;

function codec_lies_status:boolean;
  begin
    codec_lies_status:=(Port[basisport+IO_PT_CODEC_STATUS] and 1)=0;
  end;


function codec_lies(const regindex:byte):word;
  begin
    //while ...
    repeat
    until codec_lies_status;

    PortW[basisport+IO_PT_CODEC_CMD]:=regindex or $80;
    vDelay( _CODEC_RW_TIMEOUT );
    codec_lies:=PortW[basisport+IO_PT_CODEC_DATA];
  end;



procedure codec_auswahl(n:byte);
  begin (* or 01 / and $fc *)

    Port[basisport+$38  ]:=(Port[basisport+$38  ] and $fc)+(n-1);
    Port[basisport+$38+2]:=(Port[basisport+$38+2] and $fc)+(n-1);
    Port[basisport+$38+4]:=(Port[basisport+$38+4] and $fc)+(n-1);
  end;

procedure anzeige_apu;
  begin

  end;

var
  c,z                   :word;
  anz_codec             :word;
  docked                :boolean;


begin
  docked:=(Port[basisport+$61] and $80)<>0;


  anzeige_apu;


  if docked then
    anz_codec:=2
  else
    anz_codec:=1;

  for c:=1 to anz_codec do
    begin
      WriteLn('codec ',c,':');
      codec_auswahl(c);
      for z:=0 to 127 do
        if (z and $1)=0 then
          begin
            Write(Int2Hex(z,2),':',Int2Hex(codec_lies(z),4));
            if (z and $f)=$e then
              WriteLn
            else
              Write(' ');
          end;
    end;
end.

