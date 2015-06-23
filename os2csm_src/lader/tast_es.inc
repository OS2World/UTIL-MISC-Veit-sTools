Title    automaticly generated keyboard remap table (spanish: sp 172)

keyboard_title equ "spanish: sp 172"

keytable_remapscan:
  db 0

keytable_Lower:
  db 00Ch,027h
  db 00Dh,'­'
  db 01Ah,'`'
  db 01Bh,'+'
  db 027h,'¤'
  db 028h,'ï'
  db 029h,'§'
  db 02Bh,'‡'
  db 035h,'-'
  db 056h,'<'
  db 0

keytable_Upper:
  db 003h,'"'
  db 004h,'ú'
  db 007h,'&'
  db 008h,'/'
  db 009h,'('
  db 00Ah,')'
  db 00Bh,'='
  db 00Ch,'?'
  db 00Dh,'¨'
  db 01Ah,'^'
  db 01Bh,'*'
  db 027h,'¥'
  db 028h,'ù'
  db 029h,'¦'
  db 02Bh,'€'
  db 033h,';'
  db 034h,':'
  db 035h,'_'
  db 056h,'>'
  db 0

keytable_AltGr:
  db 002h,'|'
  db 003h,'@'
  db 004h,'#'
  db 006h,'Õ'
  db 007h,'ª'
  db 012h,'Õ'
  db 01Ah,'['
  db 01Bh,']'
  db 028h,'{'
  db 029h,'\'
  db 02Bh,'}'
  db 033h,'<'
  db 034h,'>'
  db 035h,'\'
  db 0

keytable_Alt:
  db 0

keytable_Ctrl:
  db 0

