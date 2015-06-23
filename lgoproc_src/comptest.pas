{&Use32+}
program comptest;

uses
  lgo,
  VpUtils,
  Dos;

var
  f                     :file;
  ps0,
  ups1,
  ps2,
  ups3,
  rc                    :longint;
  pb0,
  upb1,
  pb2,
  upb3                  :pByteArray;
  i                     :word;

  tmp                   :string;

begin
  tmp:=GetEnv('TMP');

  Assign(f,'test\kc.lgo');
  //Assign(f,tmp+'\kc_.LGO');
  Reset(f,1);
  Seek(f,4);
  BlockRead(f,ps0,4);
  Seek(f,$20);
  GetMem(pb0,ps0);
  BlockRead(f,pb0^,ps0);
  Close(f);

  WriteLn('source size=',ps0);

  ups1:=640*480 div 8;
  GetMem(upb1,ups1);
  rc:=EP2_Decompress(pb0^,upb1^,ps0,ups1);
  WriteLn('EP2_Decompress=',rc);
  if rc<>ups1 then RunError(99);

  Assign(f,tmp+'\kc.u');
  Rewrite(f,1);
  BlockWrite(f,upb1^,ups1);
  Close(f);

  ps2:=ups1;
  GetMem(pb2,ps2);
  rc:=EP2_Compress(upb1^,pb2^,ups1,ps2);
  WriteLn('EP2_Compress=',rc);
  if rc<=0 then RunError(99);
  ps2:=rc;

  Assign(f,tmp+'\kc.r');
  Rewrite(f,1);
  BlockWrite(f,pb2^,ps2);
  Close(f);

  ups3:=ups1;
  GetMem(upb3,ups3);
  rc:=EP2_Decompress(pb2^,upb3^,ps2,ups3);
  WriteLn('EP2_Decompress=',rc);


  Assign(f,tmp+'\kc.u3');
  Rewrite(f,1);
  BlockWrite(f,upb3^,ups3);
  Close(f);


  if rc<>ups3 then RunError(99);

  for i:=0 to ups3-1 do
    if upb1^[i]<>upb3^[i] then
      RunError(99);
end.

