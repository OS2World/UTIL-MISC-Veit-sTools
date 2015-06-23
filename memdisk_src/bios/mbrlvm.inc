Title   IBM LVM MBR code

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

ibm_lvm_mbr_begin:
        db 0fah,0b8h,030h,000h,08eh,0d0h,0bch,000h,001h,0fbh,0fch,033h,0c0h,08eh,0d8h,08eh
        db 0c0h,0beh,000h,07ch,0bfh,000h,07eh,0b9h,000h,002h,0f3h,0a5h,068h,020h,07eh,0c3h
        db 0beh,0fah,07eh,0bbh,0beh,07fh,080h,07fh,004h,00ah,074h,041h,083h,0c3h,010h,081h
        db 0fbh,0feh,07fh,07ch,0f1h,033h,0c0h,0cdh,013h,0b4h,008h,0b2h,081h,0cdh,013h,072h
        db 02ch,0b9h,0b4h,07fh,0b2h,081h,0e8h,0eeh,000h,00ah,0e4h,075h,020h,081h,03eh,0feh
        db 07dh,055h,0aah,075h,018h,0bbh,0beh,07dh,080h,07fh,004h,00ah,075h,006h,0b2h,081h
        db 08bh,0cbh,0ebh,031h,083h,0c3h,010h,081h,0fbh,0feh,07dh,07ch,0ebh,0bbh,0beh,07fh
        db 033h,0c9h,080h,03fh,080h,075h,008h,00bh,0c9h,075h,06dh,08bh,0cbh,0ebh,005h,080h
        db 03fh,000h,075h,064h,083h,0c3h,010h,081h,0fbh,0feh,07fh,07ch,0e5h,00bh,0c9h,075h
        db 002h,0cdh,018h,0b2h,080h,060h,0e8h,021h,000h,061h,052h,051h,0e8h,098h,000h,00ah
        db 0e4h,074h,005h,0beh,00fh,07fh,0ebh,040h,0beh,024h,07fh,081h,03eh,0feh,07fh,055h
        db 0aah,075h,035h,05eh,05ah,0eah,000h,07ch,000h,000h,0b4h,041h,0bbh,0aah,055h,0cdh
        db 013h,072h,018h,081h,0fbh,055h,0aah,075h,012h,080h,0fch,021h,072h,00dh,0f6h,0c1h
        db 001h,074h,008h,066h,0b8h,049h,031h,033h,058h,0ebh,002h,033h,0c0h,068h,000h,030h
        db 00fh,0a1h,064h,066h,0a3h,000h,000h,0c3h,033h,0dbh,0ebh,002h,0cdh,010h,0b4h,00eh
        db 0ach,00ah,0c0h,075h,0f7h,0fbh,0ebh,0feh
        dw 18
        db 'OS/2 !! SYS01462',13,10,0
        dw 18
        db 'OS/2 !! SYS01463',13,10,0
        dw 18
        db 'OS/2 !! SYS01464',13,10,0
        db                                    08bh,0d9h,0bfh,005h,000h,068h,000h,030h,00fh
        db 0a1h,064h,080h,03eh,000h,000h,049h,074h,018h,08bh,04fh,002h,08ah,077h,001h,0bbh
        db 000h,07ch,033h,0c0h,0cdh,013h,0b8h,001h,002h,0cdh,013h,073h,003h,04fh,07fh,0f2h
        db 0c3h,01eh,066h,08bh,047h,008h,00fh,0a0h,01fh,0beh,008h,000h,066h,0a3h,004h,000h
        db 066h,089h,044h,008h,066h,033h,0c0h,0c7h,004h,010h,000h,0c7h,044h,002h,001h,000h
        db 0c7h,044h,004h,000h,07ch,089h,044h,006h,066h,089h,044h,00ch,02bh,0c0h,0cdh,013h
        db 0b4h,042h,0cdh,013h,073h,003h,04fh,077h,0f3h,01fh,0c3h
ibm_lvm_mbr_end:
        ; db 1,..
        ; db 033h,0cch..
        ; db 055h,0aah

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
