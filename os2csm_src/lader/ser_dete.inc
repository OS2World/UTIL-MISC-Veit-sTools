Title   Setup variables: detect serial ports

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

p8str name_os2csm_uart 'OS2CSM_UART'

serial_pci_classcode_table label DWord

                        dd 0070000h ; Simple Communication - Serial
                        dd 0070001h ; Simple Communication - Serial - 16450
                        dd 0070002h ; Simple Communication - Serial - 16550
                        dd 0070003h ; Simple Communication - Serial - 16650
                        dd 0070004h ; Simple Communication - Serial - 16750
                        dd 0070005h ; Simple Communication - Serial - 16850
                        dd 0070006h ; Simple Communication - Serial - 16950

                      ;-dd 0070100h ; Simple Communication - Parallel
                      ;-dd 0070101h ; Simple Communication - Parallel - BiDir
                      ;-dd 0070102h ; Simple Communication - Parallel - ECP
                      ;-dd 0070103h ; Simple Communication - Parallel - IEEE1284 Controller
                      ;-dd 00701feh ; Simple Communication - Parallel - IEEE1284 Target

                        dd 0070200h ; Simple Communication - Multiport Serial

                        dd 0070300h ; Simple Communication - Hayes Compatible Modem
                        dd 0070301h ; Simple Communication - Hayes Compatible Modem, 16450
                        dd 0070302h ; Simple Communication - Hayes Compatible Modem, 16550
                        dd 0070303h ; Simple Communication - Hayes Compatible Modem, 16650
                        dd 0070304h ; Simple Communication - Hayes Compatible Modem, 16750

                      ;-dd 0070400h ; Simple Communication - GPIB (IEEE 488.1/2)

                      ;-dd 0070500h ; Simple Communication - Smart Card

                        dd 0078000h ; Simple Communication - Other

serial_pci_classcode_table_end label byte

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; search for serial ports:
; 1. look at BIOS data area for serial ports, assume POST has verified them
; 2. look for PCI classcode, simliar to 'COM.SYS /F', verify them, accept
;    devices that
;    - have BUS access disabled
;    - all non-configured base address registers
;    - are powered down
;    because this is corrected before COM.SYS is loaded -- hope that they are working
;
; this procedure may find PCMCIA modem/serial port cards -- not a problem
; this procedure will not look for lucent softmodems, as COM.SYS does not handle them

a_proc                  detect_serial_port
                        push es
                        pusha

                          mov si,Offset name_os2csm_uart
                          call suche_variable_p8
                          test di,di
                          jz @@exit


                          ; look at BIOS data area for any serial port

                          push bios0040
                          pop es

                          ; address
                          cmp Word Ptr es:[0],0 ; COM1
                          jne @@found_serial_port
                          cmp Word Ptr es:[2],0 ; COM2
                          jne @@found_serial_port
                          cmp Word Ptr es:[4],0 ; COM3
                          jne @@found_serial_port
                          cmp Word Ptr es:[6],0 ; COM4
                          jne @@found_serial_port


                          mov si,Offset serial_pci_classcode_table
  @@loop_pci_classcode:
                          mov ecx,DWord Ptr [si]
                          call detect_serial_port__pci_classcode
                          jnc @@found_serial_port

                          add si,4
                          cmp si,Offset serial_pci_classcode_table_end
                          jne @@loop_pci_classcode

                          mov al,false
                          jmp @@store_result
  @@found_serial_port:
                          mov al,true
  @@store_result:
                          ; al=false/true
                          mov ah,0
                          mov si,Offset zeichenketten_zwischenspeicher
                          call Int2Str

                          ; si=string
                          ; bx=variable name
                          mov bx,Offset name_os2csm_uart
                          call store_string_to_anything_varname
  @@exit:

                        popa
                        pop es
                        ret
a_endp                  detect_serial_port

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; ecx=classcode/subclass/programming interface
; ->CF=0:found serial port
a_proc                  detect_serial_port__pci_classcode
                        pushad

                          mov si,-1             ; device index (0..n)
  @@search_classcode_loop:
                          inc si
                          mov ax,0b103h         ; search class code
                          int 01ah
                          jc @@exit             ; pass CF=1

                          ; -> BX=bus/device/function

                          ; verify header type 0
                          mov di,00eh           ; header type
                          mov ax,0b108h         ; read byte
                          int 01ah
                          jc @@exit

                          and cl,07fh
                          jnz @@search_classcode_loop

                          ; look if chip is powered down
                          mov di,006h           ; status
                          mov ax,0b109h         ; read word
                          int 01ah
                          jc @@search_classcode_loop

                          test cl,010h          ; bit4=capabilies present
                          jz @@no_capabilities

                          mov di,034h           ; capabilities start for header type 0
                          mov ax,0b108h         ; read byte
                          int 01ah

                          movzx di,cl
  @@capabilities_loop:
                          cmp di,040h
                          jb @@done_capabilities
                          test di,3
                          jnz @@done_capabilities

                          mov ax,0b109h         ; read word
                          int 01ah

                          cmp cl,1
                          jne @@not_power_management_capability

                          push cx

                            add di,4            ; PM status register
                            mov ax,0b10ah       ; read DWord
                            int 01ah

                            test cl,3           ; anything other than D0?
                            jz @@skip_PM_change

                            and cl,(not 3)
                            mov ax,0b10dh       ; write DWord
                            int 01ah
  @@skip_PM_change:
                          pop cx

  @@not_power_management_capability:

                          movzx di,ch           ; follow next pointer
                          jmp @@capabilities_loop

  @@done_capabilities:
  @@no_capabilities:

                          mov di,010h
  @@check_BAR_loop:
                          mov ax,0b10ah         ; read DWord
                          int 01ah

                          test cl,1
                          jz @@BAR_memory

                          and cl,(not 3)        ; reset bit 1..0

                          ; for an unconfigured BAR, assume it works..
                          test cx,cx
                          clc
                          jz @@check_BAR_next


                          ; enable I/O mapping, just in case the BIOS did not do it..
                          pusha
                            mov di,004h
                            mov ax,0b109h       ; read Word
                            int 01ah
                            or  cl,1
                            mov ax,0b10ch       ; write Word
                            int 01ah
                          popa

                          ; COM.SYS now checks IOBASE..IOBASE+78 in steps of 8. (16 ports)
                          ; we assume that IOBASE+0 should indicate if it works or not.
                          call check_serial_iobase
                          jnc @@exit            ; pass CF=0

                          jmp @@check_BAR_next

  @@BAR_memory:

                          and cl,006h           ; 64 bit memory uses 8 bytes
                          cmp cl,004h
                          if_e <add di,4>

  @@check_BAR_next:
                          add di,4
                          cmp di,010h+6*4
                          jb @@check_BAR_loop

                          jmp @@search_classcode_loop

  @@exit:

                        popad
                        ret
a_endp                  detect_serial_port__pci_classcode

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; cx=IOBASE
; -> CF=0:serial port verified
; this does what COM.SYS does to verify
; for example it rejects the modem on ThinkPad T42 (PCI: Intel AC'97 Modem Controller)
; that has class code 7/3/0
a_proc                  check_serial_iobase
                        pusha

                          ; sort out softmodems/controllerless modems

                          mov dx,cx             ; line status register
                          add dx,5
                          in  al,dx
                          and al,060h           ; 020 transmitter holding register empty
                                                ; 040 transmitter shift register empty
                          cmp al,060h
                          stc
                          jne @@exit

                          mov dx,cx             ; modem status register
                          add dx,6
                          in  al,dx
                          and al,0f0h           ; 010 CTS
                                                ; 020 DSR
                                                ; 040 ring indicator (RI)
                                                ; receive line signal detect
                          cmp al,0f0h
                          stc
                          je @@exit

                          mov dx,cx             ; line control register
                          add dx,3
                          in  al,dx
                          or  al,080h           ; try to toggle register usage baud rate divisor <-> buffer+interrupt enable
                          out dx,al
                          in  al,dx
                          test al,080h
                          stc
                          jz @@exit
                          and al,(not 080h)
                          out dx,al
                          in  al,dx
                          test al,080h
                          stc
                          jnz @@exit

                          clc

  @@exit:
                        popa
                        ret
a_endp                  check_serial_iobase
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

