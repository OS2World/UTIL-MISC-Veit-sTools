{$A+,B-,D+,E-,F-,G+,I+,L-,N-,O-,P-,Q-,R-,S-,T-,V+,X+}
{$M 16384,0,0}
program es_com_to_exe;

type
  exe_kopf_typ=
    record
      sig:array[0..1] of char;
      mod512,
      page512,
      relo_anz,
      kopfgroesse,
      min,max,
      _ss,
      _sp,
      pruefsumme,
      _ip,
      _cs,
      reloofs,
      ov_nummer:word;
      rest1:array[$1c..$1f] of byte;
      kennung:array[$20..$2b] of char;
      rest2:array[$2c..$3f] of byte;
    end;

const
  exe_kopf:exe_kopf_typ=
    (sig:'MZ';
     mod512:0;
     page512:0;
     relo_anz:0;
     kopfgroesse:$40 div 16;
     min:$300 div 16; (* ?? *)
     max:$ffff;
     _ss:$fff0;   (* PSP:$400 *)
     _sp:$400;
     pruefsumme:0;
     _ip:$100;    (* PSP:$100 *)
     _cs:$fff0;
     reloofs:$1c;
     ov_nummer:0;
     rest1:(0,0,0,0);
     kennung:'ESúEXE/V.K.'^z;
     rest2:(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0));

  ende:array[0..1] of char='##';

var
  d1,d2:file;
  puffer:array[0..32*1024-1] of byte;
  exe_laenge,laenge,diff:longint;

begin
  if paramcount<>2 then 
    begin
      writeln('ES_EXE <Name.Com> <Name.Exe>');
      halt(1);
    end;

  assign(d1,paramstr(1));
  filemode:=$40;
  reset(d1,1);

  assign(d2,paramstr(2));
  rewrite(d2,1);

  laenge:=filesize(d1);

  exe_laenge:=laenge+sizeof(exe_kopf)+sizeof(ende);

  exe_kopf.mod512:=exe_laenge mod 512;
  exe_kopf.page512:=exe_laenge div 512;
  if exe_kopf.mod512>0 then
    inc(exe_kopf.page512);


  blockwrite(d2,exe_kopf,sizeof(exe_kopf));
  repeat
    if laenge>sizeof(puffer) then
      diff:=sizeof(puffer)
    else
      diff:=laenge;

    blockread(d1,puffer,diff);
    blockwrite(d2,puffer,diff);

    dec(laenge,diff);
  until laenge=0;

  blockwrite(d2,ende,sizeof(ende));

  close(d1);
  close(d2);
end.
