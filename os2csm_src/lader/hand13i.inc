Title   Install handlers for INT 13 and INT 10

;***************************************************************************
; CS=DS ES=Zielsegment
a_proc                          hand10und13_install
                                pushad
                                  push ds

                                    push 0
                                    pop ds

                                    mov ax,es
                                    cmp ax,textspeicher_unbenutzt_segment
                                    jne int10_unberuehrt1

                                    ; Int 10 einhÑngen: INT 10->$40:f0->int10_behandlung
                                    mov byte ptr ds:[04f0h],0eah
                                    mov word ptr ds:[04f0h+1+0],Offset int10_behandlung
                                    mov word ptr ds:[04f0h+1+2],es

                                    mov eax,ds:[4*010h]
                                    mov es:[int10_org],eax
                                    mov dword ptr ds:[4*010h],004000f0h ; 40:f0
  int10_unberuehrt1:

                                    ; Int 13 einhÑngen (Umweg Åber 40:f8)
                                    mov byte ptr ds:[04f8h],0eah
                                    mov word ptr ds:[04f8h+1+0],Offset int13_behandlung
                                    mov word ptr ds:[04f8h+1+2],es

                                    mov eax,ds:[4*013h]
                                    mov es:[int13_org],eax
                                    mov dword ptr ds:[4*013h],004000f8h ; 40:f8

                                  pop ds

                                popad
                                ret
a_endp                          hand10und13_install

;***************************************************************************

