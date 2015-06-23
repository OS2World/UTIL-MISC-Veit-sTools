Title   code to detect pci networkt adapters using nic_dete.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

nic_drivernames         Macro A_OS2_filename, A_NIF_filename, A_Description, A_shipped_on_eCS_DEMO_cd
                        local a1,a2,b1,b2
                        db (Offset a2-Offset a1)
  a1:
                        db &A_OS2_filename      ; example: RTSND.OS2
  a2:
                        db (Offset b2-Offset b1)
  b1:
                        db &A_NIF_filename      ; example: RTL8139.NIF
  b2:
                        db &A_shipped_on_eCS_DEMO_cd

                        EndM

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

p8str name_os2csm_limit_nic_detection 'OS2CSM_LIMIT_NIC_DETECTION'

os2csm_limit_nic_detection db false

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; ecx=device    shl 16+vendor
                        ; edx=subdevice shl 16+subvendor
a_proc                  search_drivermatchNIC
                        pushad
                          rol ecx,16

                          mov si,Offset networkadaptertable_begin
  @@try_next_nic_driver_loop:
                          cmp si,Offset networkadaptertable_end
                          je @@exit

                          ; skip over nic_drivernames 'header' data

                          mov bp,si                     ; remember driver
                          movzx ax,Byte Ptr [si]        ; skip over driver name
                          inc ax
                          add si,ax
                          movzx ax,Byte Ptr [si]        ; skip over NIF name
                          inc ax
                          add si,ax

                          ; check if it is allowed to detect this driver
                          mov al,Byte Ptr [si]
                          inc si

                          cmp al,true                   ; driver shipped on demo CD?
                          je @@nic_detection_allowed

                          cmp [os2csm_limit_nic_detection],true
                          jne @@nic_detection_allowed

                          ; skip this driver entry..
  @@skip_nic_driver_pci_line_loop:
                          add si,4                      ; skip pci data line
                          cmp Word Ptr [si-4],0         ; find terminating 'dw 0'
                          jne @@skip_nic_driver_pci_line_loop

                          add si,-4+2                   ; 'dw 0' takes only 2 bytes.
                          jmp @@try_next_nic_driver_loop
                          ;------------------------------------------

  @@nic_detection_allowed:

  @@compare_pci_nic_number_loop:
                          mov eax,dword ptr [si]
                          add si,2
                          test ax,ax                    ; end of this driver ?
                          jz @@try_next_nic_driver_loop

                          rol eax,16
                          add si,2+2+2+2-2
                          cmp eax,-1
                          je @@ignore_vendor_device
                          cmp eax,ecx
                          jne @@compare_pci_nic_number_loop
  @@ignore_vendor_device:
                          mov eax,edx
                          cmp [si-4],ax
                          je @@subvendor_match
                          cmp Word Ptr [si-4],-1
                          jne @@compare_pci_nic_number_loop
  @@subvendor_match:
                          shr eax,16
                          cmp [si-2],ax
                          je @@subdevice_match
                          cmp Word Ptr [si-2],-1
                          jne @@compare_pci_nic_number_loop
  @@subdevice_match:
                          call store_detected_nic_driver
                          jc @@compare_pci_nic_number_loop

  @@exit:
                        popad

                        ret
a_endp                  search_drivermatchNIC

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴


p8str nic_os2_var_n     'DETECT_OS2_0'
nic_os2_var_n_posn      equ $-1 ; '0'

p8str nic_nif_var_n     'DETECT_NIF_0'
nic_nif_var_n_posn      equ $-1 ; '0'

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; ds:bp=@drivername
                        ; carry clear, when successful
                        ; carry set, when should search again
a_proc                  store_detected_nic_driver
                        pushad
                          mov si,bp

                          ; search variable
                          cmp byte ptr [nic_os2_var_n_posn],'9'
                          clc ; no need to search again - no free variable available
                          je exit_store_detected_nic_driver
                          inc byte ptr [nic_os2_var_n_posn]
                          inc byte ptr [nic_nif_var_n_posn]
                          push si
                            mov si,Offset nic_os2_var_n
                            call suche_variable_p8
                          pop si
                          test di,di
                          jz no_assign_nic_os2_var_n

                          ; ds:si->ds:di
                          call store_string_to_anything
                          jc assign_fail_store_detected_nic_driver

  no_assign_nic_os2_var_n:
                          ; go to NIF string
                          movzx ax,byte ptr [si]
                          inc ax
                          add si,ax

                          push si
                            mov si,Offset nic_nif_var_n
                            call suche_variable_p8
                          pop si
                          test di,di
                          jz no_assign_nic_nif_var_n
                          ; ds:si->ds:di

                          call store_string_to_anything
                          jnc assign_nic_var_not_fail
  assign_fail_store_detected_nic_driver:
                          ; assignment to spinbutton was not successful
                          ; this means variable is free to use for other tries
                          dec byte ptr [nic_os2_var_n_posn]
                          dec byte ptr [nic_nif_var_n_posn]
                          ; and we have to search for other drivers for
                          ; the found device
                          stc
                          jmp exit_store_detected_nic_driver
  assign_nic_var_not_fail:

  no_assign_nic_nif_var_n:
                          clc

  exit_store_detected_nic_driver:

                        popad
                        ret
a_endp                  store_detected_nic_driver

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; 'Virtual Ethernet Adapter' for SVISTA
                        ; the device is not a pci device..
a_proc                  detect_goseth_Virtual_Ethernet_Adapter
                        pushad

                          cmp [is_2os2],true
                          jne @@exit

                          ; I/O port is fixed, 4a20
                          ; detection done similar to what goseth.os2 does
                          mov dx,04a20h
                          mov ax,00200h
                          out dx,ax

                          add dx,04a25h-04a20h
                          in ax,dx

                          test ax,ax
                          jz @@exit
                          cmp ax,16
                          ja @@exit



                          mov bp,Offset name_goseth_Virtual_Ethernet_Adapter

                          cmp os2csm_limit_nic_detection,true
                          jne @@detect_goseth_allowed

                          ; see if the driver is declared to shipped on the media
                          mov si,bp
                          movzx ax,byte ptr [si]        ; skip over driver name
                          inc ax
                          add si,ax
                          movzx ax,byte ptr [si]        ; skip over NIF name
                          inc ax
                          add si,ax
                          cmp Byte Ptr [si],true        ; shipped?
                          jne @@detect_goseth_not_allowed

  @@detect_goseth_allowed:
                          call store_detected_nic_driver
  @@detect_goseth_not_allowed:

  @@exit:
                        popad
                        ret
a_endp                  detect_goseth_Virtual_Ethernet_Adapter

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  setup_os2csm_limit_nic_detection
                        pusha
                          mov si,Offset name_os2csm_limit_nic_detection
                          call suche_variable_p8
                          test di,di
                          jz @@exit

                          mov ax,[di].aktuelle_einstellung
                          mov os2csm_limit_nic_detection,al
  @@exit:
                        popa
                        ret
a_endp                  setup_os2csm_limit_nic_detection

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
