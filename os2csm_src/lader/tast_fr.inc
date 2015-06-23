Title    automaticly generated keyboard remap table (french: fr 189)

keyboard_title equ "french: fr 189"

keytable_remapscan:
  db 010h,01Eh ; A->Q
  db 011h,02Ch ; Z->W
  db 01Eh,010h ; Q->A
  db 027h,032h ; M->,
  db 02Ch,011h ; W->Z
  db 032h,027h ; ,->M
  db 0

keytable_Lower:
  db 002h,'&'
  db 003h,'‚'
  db 004h,'"'
  db 005h,027h
  db 006h,'('
  db 007h,'-'
  db 008h,'Š'
  db 009h,'_'
  db 00Ah,'‡'
  db 00Bh,'…'
  db 00Ch,')'
  db 010h,'q'
  db 011h,'w'
  db 01Ah,'^'
  db 01Bh,'$'
  db 01Eh,'a'
  db 027h,','
  db 028h,'—'
  db 029h,'ý'
  db 02Bh,'*'
  db 02Ch,'z'
  db 032h,'m'
  db 033h,';'
  db 034h,':'
  db 035h,'!'
  db 056h,'<'
  db 0

keytable_Upper:
  db 002h,'1'
  db 003h,'2'
  db 004h,'3'
  db 005h,'4'
  db 006h,'5'
  db 007h,'6'
  db 008h,'7'
  db 009h,'8'
  db 00Ah,'9'
  db 00Bh,'0'
  db 00Ch,'ø'
  db 010h,'Q'
  db 011h,'W'
  db 01Ah,'ù'
  db 01Bh,'œ'
  db 01Eh,'A'
  db 027h,'?'
  db 028h,'%'
  db 029h,'ü'
  db 02Bh,'æ'
  db 02Ch,'Z'
  db 032h,'M'
  db 033h,'.'
  db 034h,'/'
  db 035h,'õ'
  db 056h,'>'
  db 0

keytable_AltGr:
  db 003h,'~'
  db 004h,'#'
  db 005h,'{'
  db 006h,'['
  db 007h,'|'
  db 008h,'`'
  db 009h,'\'
  db 00Ah,'^'
  db 00Bh,'@'
  db 00Ch,']'
  db 00Dh,'}'
  db 010h,000h
  db 011h,000h
  db 012h,'Õ'
  db 01Bh,'Ï'
  db 01Eh,000h
  db 027h,000h
  db 029h,'û'
  db 02Ch,000h
  db 032h,000h
  db 033h,'<'
  db 034h,'>'
  db 0

keytable_Alt:
  db 010h,000h
  db 011h,000h
  db 01Eh,000h
  db 027h,000h
  db 02Ch,000h
  db 032h,000h
  db 0

keytable_Ctrl:
  db 010h,011h
  db 011h,017h
  db 01Eh,001h
  db 027h,000h
  db 02Ch,01Ah
  db 032h,00Dh
  db 0

