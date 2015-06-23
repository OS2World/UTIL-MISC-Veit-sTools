Title   Display used memory size/address

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

meldung_benutze1        db msg_Using_KB_at_Address_1,0
meldung_benutze2        db msg_Using_KB_at_Address_2,0
meldung_benutze3        db msg_Using_KB_at_Address_3,13,10,0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          display_used_memory
                pushad

                  mov si,Offset meldung_benutze1
                  call ausschrift

                  mov eax,cs:MemDiskBIOS_Info._anzahl_sektoren
                  shl eax,9                              ; sector -> byte
                  call ausschrift_eax

                  mov si,Offset meldung_benutze2
                  call ausschrift

                  mov eax,MemDiskBIOS_Info._phys_addr
                  call ausschrift_eax_hex

                  mov si,Offset meldung_benutze3
                  call ausschrift

                popad
                ret
a_endp          display_used_memory

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

