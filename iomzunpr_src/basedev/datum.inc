Title   cutomize build date

; begin edit area

jahr    equ 2004
monat   equ 08
tag     equ 11

; end edit area

jahr4   = (jahr  / 1000) mod 10
jahr3   = (jahr  /  100) mod 10
jahr2   = (jahr  /   10) mod 10
jahr1   = (jahr  /    1) mod 10
monat2  = (monat /   10) mod 10
monat1  = (monat /    1) mod 10
tag2    = (tag   /   10) mod 10
tag1    = (tag   /    1) mod 10

datum   equ <'0'+jahr4,'0'+jahr3,'0'+jahr2,'0'+jahr1,'.','0'+monat2,'0'+monat1,'.','0'+tag2,'0'+tag1>

datum_bcd =((((((jahr4*16+jahr3)*16+jahr2)*16+jahr1)*16+monat2)*16+monat1)*16+tag2)*16+tag1

year    equ jahr
month   equ monat
day     equ tag
