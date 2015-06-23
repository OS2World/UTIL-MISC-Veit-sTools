{&Use32+}
program list_fonts;
{&PMType NoVio}

uses
  Os2Base,
  Objects,
  Strings,
  VpSysLow,
  VpUtils;

const
  request_description   :array[0..1] of string[20]=
    ('current RAM font',
     'ROM/Codepage font');

procedure Suche(request,x,y:byte);
  var
    vfi                 :VioFontInfo;
    rc                  :word;
    f                   :file;
    p1,p2               :pointer;
  begin
    FillChar(vfi,SizeOf(vfi),0);
    with vfi do
      begin
        cb:=SizeOf(vfi);
        rType:=request;
        cxCell:=x;
        cyCell:=y;
      end;
    rc:=VioGetFont(vfi,0);
    if rc=0 then
      with vfi do
        begin
          WriteLn(vfi.cxCell:3,vfi.cyCell:3,' ',request_description[request]);
          if (cbdata>0) and (ParamStr(1)='dump') then
            begin
              p1:=pbData;
              SelToFlat(p1);
              GetMem(p2,cbData);
              Move(p1^,p2^,cbData);
              Assign(f,Int2Str(request)+'_'+Int2StrZ(cxCell,2)+'_'+Int2StrZ(cyCell,2)+'.FNT');
              Rewrite(f,1);
              BlockWrite(f,p2^,cbData);
              Close(f);
              Dispose(p2);
            end;
        end;
  end;

var
  x,y                   :byte;

begin
  Suche(0,0,0);
  for y:=1 to 30 do
    for x:=8 to 9 do
      Suche(1,x,y);
end.
