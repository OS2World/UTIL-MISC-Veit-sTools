Title   PCI detection functions

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

anzahl_pci_richtig      dw ?
grenze_pci_richtig      dw ?

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; Eingabe dx:ax=ID
; Ausgabe dx=Anzahl
Count_PCI_DeviceID:
                        mov [grenze_pci_richtig],0ffffh
                        jmp short Search_Count_PCI_DeviceID_gemeinsam
; Eingabe dx:ax=ID
; Ausgabe dx=boolean
Search_PCI_DeviceID:
                        mov [grenze_pci_richtig],1

  Search_Count_PCI_DeviceID_gemeinsam:
                        mov [anzahl_pci_richtig],0
                        pushad

                          mov cx,ax
                          null si
  schleife_Search_PCI_DeviceID:
                          mov ax,0b102h
                          int 01ah
                          cmp ah,0      ; 0=kein Fehler
                          jne ende_Search_PCI_DeviceID

                          inc [anzahl_pci_richtig]
                          inc si
                          mov ax,[anzahl_pci_richtig]
                          cmp ax,[grenze_pci_richtig]
                          jne schleife_Search_PCI_DeviceID

  ende_Search_PCI_DeviceID:
                        popad
                        mov dx,[anzahl_pci_richtig]
                        ret

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; Eingabe dx:ax=Klasse
; Ausgabe dx=Anzahl
Count_PCI_DeviceClass:
                        mov [grenze_pci_richtig],0ffffh
                        jmp short Search_Count_PCI_DeviceClass_gemeinsam
; Eingabe dx:ax=Klasse
; Ausgabe dx=boolean
Search_PCI_DeviceClass:
                        mov [grenze_pci_richtig],1

  Search_Count_PCI_DeviceClass_gemeinsam:
                        mov [anzahl_pci_richtig],0
                        pushad

                          movzx ecx,dx
                          shl ecx,8
                          mov cl,al
                          null si

  schleife_Search_Count_PCI_DeviceClass:
                          mov ax,0b103h
                          int 01ah

                          cmp ah,0    ; 0=kein Fehler
                          jne ende_Search_Count_PCI_DeviceClass

                          inc si
                          inc [anzahl_pci_richtig]
                          mov ax,[anzahl_pci_richtig]
                          cmp ax,[grenze_pci_richtig]
                          jne schleife_Search_Count_PCI_DeviceClass

  ende_Search_Count_PCI_DeviceClass:

                        popad
                        mov dx,[anzahl_pci_richtig]
                        ret

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

pci_present             db false
lastpcibus              db 0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  detect_pci
                        pushad

                          mov ax,0b101h
                          null edx
                          int 01ah
                          jc detect_pci_exit
                          cmp edx,' ICP'
                          jc detect_pci_exit

                          mov lastpcibus,cl
                          mov pci_present,true

  detect_pci_exit:
                        popad
                        ret
a_endp                  detect_pci

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; bx=bus/dev/func
                        ; si=index
a_proc                  read_pci_dword
                        push eax
                        push ebx
                        push edx

                          mov ax,0b10ah
                          int 01ah

                        pop edx
                        pop ebx
                        pop eax
                        ret
a_endp                  read_pci_dword

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; bx=bus/dev/func
                        ; si=index
a_proc                  read_pci_byte
                        push eax
                        push ebx
                        push edx

                          mov ax,0b108h
                          int 01ah

                        pop edx
                        pop ebx
                        pop eax
                        ret
a_endp                  read_pci_byte

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

