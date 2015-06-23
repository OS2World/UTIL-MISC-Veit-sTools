(*&Use32+*)
program setamp;
(* ? &PMTYPE PM*)

(* MiroSound PCM Pro (Crystal CS4231,OPTI 82C929) Verst„rker ein/ausschalten *)

(* 2000.03.12 Veit Kannegieser nach setamp.exe (DOS) *)

uses
(*$IFDEF VirtualPascal*)
  VpSysLow;
(*$ELSE*)
  Crt;
(*$ENDIF*)

var
  p1            :string;
  soll          :boolean;
  z             :word;
  basisport     :word;

function lies_port_1000:boolean;
  var
    z:word;
  begin
    for z:=1000 downto 0 do
      if (Port[basisport+2] and 1)=0 then
        begin
          lies_port_1000:=true;
          Exit;
        end;
    lies_port_1000:=false;
  end;

function sicher_schreiben(const index_,wert:word):boolean;
  begin
    sicher_schreiben:=false;
    if lies_port_1000 then
      begin
        Port[basisport]:=index_;
        if lies_port_1000 then
          begin
            Port[basisport]:=wert;
            sicher_schreiben:=true;
          end;
      end;
  end;


function praesenztest:boolean;
  var
    var1,var2:byte;
  begin
    praesenztest:=false;
    if lies_port_1000 then
      begin
        Port[basisport]:=$f2;
        if lies_port_1000 then
          begin
            var1:=Port[basisport+1];
            if lies_port_1000 then
              begin
                Port[basisport]:=$00;
                if lies_port_1000 then
                  begin
                    var2:=Port[basisport+1];
                    if lies_port_1000 then
                      Port[basisport]:=$f1;
                      if lies_port_1000 then
                        if Port[basisport+1]<>0 then
                          praesenztest:=(var1=Ord('m')) and (var2=Ord('A'))
                  end;
              end;
          end;
      end;
  end;

procedure schalten;
  const
    sw:array[boolean] of byte=(0,1);
  begin
    sicher_schreiben($0f,sw[soll]);
  end;


begin
  if ParamCount=1 then
    begin
      p1:=ParamStr(1);
      for z:=1 to Length(p1) do
        p1[z]:=UpCase(p1[z]);
    end
  else
    p1:='';

  repeat

    if (p1='OFF') or (p1='AUS') or (p1='0') then
      begin
        soll:=false;
        Break;
      end;

    if (p1='ON') or (p1='EIN') or (p1='1') then
      begin
        soll:=true;
        break;
      end;

    Write('SETAMP 0/1 ? ');
    p1[0]:=#1;
    p1[1]:=(*$IFDEF VirtualPascal*)SysReadKey(*$ELSE*)ReadKey(*$ENDIF*);
    WriteLn;

    if (p1=#27) or (p1=^m) then Halt(255);
  until false;


  basisport:=$344;
  if praesenztest then
    begin
      schalten;
      Halt($344);
    end;

  basisport:=$354;
  if praesenztest then
    begin
      schalten;
      Halt($354);
    end;

  Writeln('ACI mixer not found');
  Halt(255);
end.
