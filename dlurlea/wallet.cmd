/* Rexx: make encode values in Mozilla wallet visible (*.s,*.w) */
Call RxFuncAdd 'SysLoadFuncs', 'REXXUTIL', 'SysLoadFuncs'
Call SysLoadFuncs

numfiles=0

Parse Arg a
if a='' then
  do

    call SysFileTree '*.s', 'file', 'FSO'
    do i=1 to file.0
      call wallet_file file.i
    end

    call SysFileTree '*.w', 'file', 'FSO'
    do i=1 to file.0
      call wallet_file file.i
    end

  end
else
  call wallet_file a

if numfiles==0 then
  do
    Say 'no *.s/*.w files found'
    rc=99
  end
else
  rc=99

Return rc

wallet_file:
Parse Arg q
  numfiles=numfiles+1
  Say 'File ======== 'q' ======='
  call Stream q,'c','open read'
  do while lines(q)
    l=LineIn(q)
    if Pos('~',l)==1 then
      l=uudecode(l)
    Say l
  end
  call Stream q,'c','close'
  return 0

uudecode:
  Parse Arg l
  r='~'
  l=SubStr(l,1+1)
  do while l<>''
    li=0
    do i=1 to 4
      li=li*64+base64decode(SubStr(l,i,1))
    end
    l=SubStr(l,4+1)
    r1=''
    do i=1 to 3
      cj=li // 256
      if cj>0 then r1=D2C(cj)||r1
      li=(li-cj) % 256
    end
    r=r||r1
  end
  Return r

base64decode:
  Parse Arg c
  if c=='=' then Return 0
  p=Pos(c,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')
  if p=0 then
    Return 0 /* not '='? */
  else
    Return p-1
