unit strnull;

interface

function str0(var p):string;

implementation

function str0(var p):string;
  var
    tmp:string;
    z:word;
    pa:array[0..255] of char absolute p;
  begin
    tmp:='';
    z:=0;
    while pa[z]<>#0 do
      begin
        tmp:=tmp+pa[z];
        inc(z);
      end;
    str0:=tmp;
  end;

end.
