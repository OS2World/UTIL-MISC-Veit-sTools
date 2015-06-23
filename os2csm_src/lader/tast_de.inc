Title    automaticly generated keyboard remap table (german: gr 129)

keyboard_title equ "german: gr 129"

keytable_remapscan:
  db 015h,02Ch ; Z->Y
  db 02Ch,015h ; Y->Z
  db 0

keytable_Lower:
  db 00Ch,'·'
  db 00Dh,'Ô'
  db 015h,'y'
  db 01Ah,'Å'
  db 01Bh,'+'
  db 027h,'î'
  db 028h,'Ñ'
  db 029h,'^'
  db 02Bh,'#'
  db 02Ch,'z'
  db 035h,'-'
  db 056h,'<'
  db 0

keytable_Upper:
  db 003h,'"'
  db 004h,'ı'
  db 007h,'&'
  db 008h,'/'
  db 009h,'('
  db 00Ah,')'
  db 00Bh,'='
  db 00Ch,'?'
  db 00Dh,'`'
  db 015h,'Y'
  db 01Ah,'ö'
  db 01Bh,'*'
  db 027h,'ô'
  db 028h,'é'
  db 029h,'¯'
  db 02Bh,027h
  db 02Ch,'Z'
  db 033h,';'
  db 034h,':'
  db 035h,'_'
  db 056h,'>'
  db 0

keytable_AltGr:
  db 002h,'|'
  db 003h,'˝'
  db 004h,'¸'
  db 008h,'{'
  db 009h,'['
  db 00Ah,']'
  db 00Bh,'}'
  db 00Ch,'\'
  db 010h,'@'
  db 012h,'’'
  db 015h,000h
  db 01Bh,'~'
  db 02Ch,000h
  db 032h,'Ê'
  db 056h,'|'
  db 0

keytable_Alt:
  db 015h,000h
  db 02Ch,000h
  db 0

keytable_Ctrl:
  db 015h,019h
  db 02Ch,01Ah
  db 0

