Title   PCI-Zugriff 갶er das BIOS
                        .386p
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; PCI-Zugriff
; CALL F000:FE6E statt INT $1a damit der Debugger mitkommt
a_proc                  pci_bios
                        pushf
                       ;call 0f000H:0fe6eH
                        db 09ah
                        dw 0fe6eh,0f000h
                        ret
a_endp                  pci_bios
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

pci_present             db 0

a_proc                  detect_pci
                        pushad
                          mov ax,0b101H
                          sub edx,edx
                          call pci_bios
                          cmp edx,' ICP'
                          jne exit_detect_pci

                          ausschrift text_pci_version
                          mov al,bh
                          call ausschrift_4bit
                          mov al,'.'
                          call ausschrift_zeichen
                          mov al,bl
                          call ausschrift_byte
                          ausschrift_a zeilenumbruch

                          inc pci_present
  exit_detect_pci:
                        popad
                        ret
a_endp                  detect_pci
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Eingabe
;   BX    bus/dev/func
;   CS:SI @dd
;   DI    Index

a_proc                  pci_read_dword
                        pushad
                          mov ax,0b10aH
                          call pci_bios
                          mov cs:[si],ecx
                        popad
                        ret
a_endp                  pci_read_dword
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Eingabe
;   BX    bus/dev/func
;   CS:SI @dd
;   DI    Index

a_proc                  pci_write_dword
                        pushad
                          mov ax,0b10dH
                          mov ecx,cs:[si]
                          call pci_bios
                        popad
                        ret
a_endp                  pci_write_dword
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Eingabe
;   BX    bus/dev/func
;   CS:SI @dd(and),dd(or)
;   DI    Index
a_proc                  pci_maske_dword
                        pushad

                          cmp DWord Ptr cs:[si],0
                          je pci_maske_dword_and0

                          cmp DWord Ptr cs:[si],-1
                          jne nicht_pci_maske_dword_and_alle_bit

                          cmp DWord Ptr cs:[si+4],0
                          je pci_maske_dword_andalle_or0

  nicht_pci_maske_dword_and_alle_bit:
                          push bx
                          push si
                          push di

                          mov ax,0b10aH
                          call pci_bios

                          pop di
                          pop si
                          pop bx

  pci_maske_dword_and0:
                          and ecx,DWord Ptr cs:[si+0]
                          or  ecx,DWord Ptr cs:[si+4]

                          mov ax,0b10dH
                          call pci_bios

  pci_maske_dword_andalle_or0:

                        popad
                        ret
a_endp                  pci_maske_dword
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

result_search_pci_class_code dw ?

                        ; ecx=classcode
a_proc                  search_pci_class_code
                        pushad
                          mov ax,0b103h
                          sub si,si             ; erstes Ger꼝
                         ;mov ecx,ecx
                          call pci_bios
                          cmp ah,0
                          je search_pci_class_code_no_error
                          mov bx,-1
  search_pci_class_code_no_error:
                          mov result_search_pci_class_code,bx
                        popad
                        mov bx,result_search_pci_class_code
                        ret
a_endp                  search_pci_class_code
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

