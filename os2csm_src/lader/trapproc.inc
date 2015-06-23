Title   trap_proc function to avoid complete ..\..\memdisk\bios\ausschrift.inc

a_proc          trap_proc
                pop si
  trap_proc_loop:
                cld
                lods byte ptr cs:[si]
                cmp al,0
                je endlos
                call ausschrift_zeichen
                jmp trap_proc_loop
  endlos:
                ifdef debug
                db 0cch ; i n t 3
                endif
                mov ah,010h
                int 016h
                jmp endlos
a_endp          trap_proc

