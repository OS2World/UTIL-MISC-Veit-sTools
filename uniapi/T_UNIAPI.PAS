(*$Use32+*)
program uc1;

uses
  VpUtils,
  Strings,
  unidef,
  uniapi;

const
  source=437;
  target=850{1004};

var
  uco437,uco850:UconvObject;
  cp437,cp850:pUniCharArray;

  t1,t1o:pchar;
  t1l,t1l0:word;

  erg0:pUniCharArray=nil;
  erg:pUniCharArray=nil;

  uebrig,gleich:size_t;

  para:string;

begin
  para:=ParamStr(1);
  if para='' then
    para:='Test 1”Û'#$eb'ษอออออออออออออัออ C:\ อัออออออออัออออออป';

  WriteLn(para);

  cp437:=NewUniCharArray(12);
  cp850:=NewUniCharArray(12);
  UniMapCpToUcsCp({437}source,cp437^,12);
  UniCreateUconvObject(cp437^,uco437);
  UniMapCpToUcsCp({850}target,cp850^,12);
  UniCreateUconvObject(cp850^,uco850);

  GetMem(t1,Length(para)+1);
  StrPCopy(t1,para);
  t1o:=t1;
  t1l:=StrLen(t1);
  t1l0:=t1l;

  // CP437 -> Unicode
  uebrig:=Length(para);
  erg:=NewUniCharArray(uebrig);
  gleich:=0;
  erg0:=erg;
  UniUconvToUcs(uco437,t1,t1l,erg,uebrig,gleich);

  // Unicode -> CP850
  erg:=erg0;
  t1l:=t1l0;
  uebrig:=t1l0;
  t1:=t1o;
  UniUconvFromUcs(uco850,erg,t1l,t1,uebrig,gleich);
  t1:=t1o;

  UniFreeUconvObject(uco437);
  UniFreeUconvObject(uco850);

  WriteLn(StrPas(t1));

end.

