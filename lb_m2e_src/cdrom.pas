program cdrom_laufwerksbuchstabe;
(* 2001.04.21 - Ehm 21 *)

uses
  Os2Base,
  Os2Def,
  VpSysLow;

const
  ergebnis              :char='Z';

var
  handhabe              :longint;

  data                  :
    packed record
      anzahl,
      erstes            :smallword;
    end;

  datalen               :longint;

begin

  if ParamStr(1)<>'/cfg' then
    begin
      WriteLn('this file is used by PMixCfg.CMD');
      Halt;
    end;


  if SysFileOpen('CD-ROM2$',0,handhabe)=0 then
    begin

      datalen:=SizeOf(data);
      FillChar(data,SizeOf(data),0);

      if DosDevIOCtl(handhabe,$82,$60,
           nil  ,0      ,nil,
           @data,datalen,@datalen)=0 then

        with data do
          if anzahl<>0 then
            ergebnis:=Chr(Ord('A')+erstes);

      SysFileClose(handhabe)
    end;

  Halt(Ord(ergebnis)-Ord('A'));

end.

