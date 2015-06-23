unit str_f;

interface

function strf(l:longint;ziffern:byte):string;

implementation

function strf(l:longint;ziffern:byte):string;
  var
    tmp:string;
  begin
    system.str(l:ziffern,tmp);
    strf:=tmp;
  end;

end.
