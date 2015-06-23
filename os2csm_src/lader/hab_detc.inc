Title   code to detect pci host adapters using hab_dete.inc

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

;HAB_DEBUG              equ 1

hab_drivername          Macro ZK ; ~p8str
                        local a1,a2
IFDEF HAB_DEBUG
                        dd 'HABD'
ENDIF ; HAB_DEBUG
                        db (Offset a2-Offset a1)
  a1:
                        db &ZK
  a2:
                        EndM

driver_S506:            hab_drivername 'DANIS506'
driver_ipsraid:         hab_drivername 'IPSRAID'

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc                  detect_hostadapters ; +network adapters
                        pushad

                          ;------------------------------------------
                          ; 0. prepare detection parameters
                          call setup_os2csm_limit_nic_detection
                          ;------------------------------------------

                          ;------------------------------------------
                          ; 1. "detect" *S506.ADD
                          mov bp,Offset driver_S506
                          call store_detected_hab_driver

                          call detect_goseth_Virtual_Ethernet_Adapter

                          ;------------------------------------------
                          ; 2. pci snooper
                          cmp pci_present,true
                          jne detect_hostadapters_no_pci

                          mov bx,0000h ; bus 0,device 0,function 0
  detect_hostadapters_pci_schleife:
                          mov di,0000h ; index 0-device/vendor
                          call read_pci_dword
                          cmp ecx,-1
                          jne detect_hostadapters_pci_function_exist

                          test bl,7                     ; already function >0
                          jnz go_to_next_pci_function   ; yes, multifuction
                          jmp go_to_next_pci_device

  detect_hostadapters_pci_function_exist:
                          mov edx,ecx

                          mov di,002ch ; index 2c-subdevice/vendor for header type 0
                          call read_pci_dword

                          xchg edx,ecx

                          call search_drivermatchHAB ; SCSI chips
                          call search_drivermatchNIC ; network chips
                          call detect_video

                          mov di,000eh ; header type
                          call read_pci_byte
                          push cx

                          and cl,07fh
                          cmp cl,1
                          jb nicht_pci_xxx_bridge
                          cmp cl,2
                          ja nicht_pci_xxx_bridge


                          mov di,0019h ; secondary bus number
                          call read_pci_byte
                          cmp lastpcibus,cl
                          if_b <mov lastpcibus,cl>
  nicht_pci_xxx_bridge:

                          pop cx
                          test bl,7                     ; already function >0
                          jnz go_to_next_pci_function   ; yes, multifuction

                          test cl,080h
                          jnz go_to_next_pci_function   ; multi function device
  go_to_next_pci_device:
                          or bl,7                       ; skip all functions
  go_to_next_pci_function:
                          inc bx                        ; next device or function

                          jz detect_hostadapters_no_pci ; address wrap?

                          cmp bh,lastpcibus
                          jbe detect_hostadapters_pci_schleife

  detect_hostadapters_no_pci:

                          ;------------------------------------------
                          ; 3.detect IPSRAID - ISA?/PCI - detection code like ipsraid.exe
                          ; iBM eServer x226: C900:0200:
                          ; 0200: '$IPR'.....
                          ; 0210: 'm$IPR'....

                          push es

                            mov ax,0c000h
                            sub si,si
  sreach_ipsread_loop:
                            mov es,ax
                            cmp DWord Ptr es:[si+000h],'RPI$'
                            jne not_ipsraid
                            cmp DWord Ptr es:[si+011h],'RPI$'
                            jne not_ipsraid

                            mov bp,Offset driver_ipsraid
                            call store_detected_hab_driver
  not_ipsraid:
                            add ax,00020h ; +512 byte
                            cmp ax,0f000h
                            jb sreach_ipsread_loop

                          pop es


                          ;------------------------------------------
                          ; search AVA-1505 SCSI Host "ADP1505"
                          ;? pnp




                        popad
                        ret
a_endp                  detect_hostadapters

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; ecx=device shl 16+vendor
a_proc                  search_drivermatchHAB
                        pushad
                          rol ecx,16

                          mov si,Offset hostadaptertable_begin
  try_next_hab_driver_loop:
                          cmp si,Offset hostadaptertable_end
                          je exit_search_drivermatch

IFDEF HAB_DEBUG
                          cmp [si],'HABD'
                          if_ne <int 3>
                          add si,4
ENDIF ; HAB_DEBUG

                          mov bp,si                     ; remember driver
                          movzx ax,byte ptr [si]        ; skip over driver name
                          inc ax
                          add si,ax

  compare_pci_hab_number_loop:
                          mov eax,dword ptr [si]
                          add si,2
                          test ax,ax                    ; end of this driver ?
                          jz try_next_hab_driver_loop

                          rol eax,16
                          mov ebx,ecx
                          and bx,word ptr [si+4-2]
IFDEF HAB_DEBUG
                          push dx
                            mov dx,word ptr [si+4-2]
                            not dx
                            test ax,dx
                            if_nz <int 3>
                          pop dx
ENDIF ; HAB_DEBUG
                          add si,2+2+2-2
                          cmp eax,ebx
                          jne compare_pci_hab_number_loop

                          call store_detected_hab_driver

  exit_search_drivermatch:
                        popad
                        ret
a_endp                  search_drivermatchHAB

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

p8str hab_var_n         'DETECT_HAB_0'
hab_var_n_posn          equ $-1 ; '0'

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                        ; ds:bp=@drivername
a_proc                  store_detected_hab_driver
                        pushad
                          mov si,bp

                          ; already selected ?
                          cmp byte ptr [si+1],'?'
                          je exit_store_detected_hab_driver

                          ; search variable
                          cmp byte ptr [hab_var_n_posn],'9'
                          je exit_store_detected_hab_driver
                          inc byte ptr [hab_var_n_posn]
                          push si
                            mov si,Offset hab_var_n
                            call suche_variable_p8
                          pop si
                          test di,di
                          jz exit_store_detected_hab_driver

                          ; ds:si->ds:di
                          call store_string_to_anything

                          ; mark as used
                          mov byte ptr [si+1],'?'

  exit_store_detected_hab_driver:

                        popad
                        ret
a_endp                  store_detected_hab_driver

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

