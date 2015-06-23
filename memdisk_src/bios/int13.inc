Title           Int $13 hard disk handler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

MemDiskBIOS_Info                MemDiskBIOS_Info_Block <>

IFDEF dos                       ; XMS functions

xmm                             dd ?
xms_handle                      dw ?

EMM_pointer                     Struc
  EMM_handle                    dw ?
  EMM_offset_into_block         dd ?
EMM_pointer                     EndS

EMM_structure                   Struc ; Table 02776
  EMM_number_of_bytes_to_move   dd ? ; must be even
  EMM_source                    EMM_pointer <?,?>
  EMM_destination               EMM_pointer <?,?>
EMM_structure                   EndS


EMM_mover                       EMM_structure <>

ext_source_description          equ Offset EMM_mover.EMM_source
ext_target_description          equ Offset EMM_mover.EMM_destination

ENDIF ; dos

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF bios                      ; extended memory BIOS functions

EXT_GDT                         GDTDesc <0,0,0,0,0,0>
                                GDTDesc <0,0,0,0,0,0>
Source_Desc                     GDTDesc <0ffffh,?,?,093h,0,?>
Target_Desc                     GDTDesc <0ffffh,?,?,093h,0,?>
                                GDTDesc <0,0,0,0,0,0>
                                GDTDesc <0,0,0,0,0,0>

ext_source_description          equ Offset Source_Desc
ext_target_description          equ Offset Target_Desc

ENDIF ; bios

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

drive_number                    db 0ffh
int13_status                    db 0
my_harddisk_count_inc           db 0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

int13_funktions_tabelle_00:
                dw Offset int13_fehlerfrei                     ; 00 reset
                dw Offset int13_f01                            ; 01 status
                dw Offset int13_f02                            ; 02 read
                dw Offset int13_f03                            ; 03 write
                dw Offset int13_f04                            ; 04 verify
                dw Offset int13_nicht_implementierte_funktion  ; 05 format
                dw Offset int13_nicht_implementierte_funktion  ; 06 format
                dw Offset int13_nicht_implementierte_funktion  ; 07 format
                dw Offset int13_f08                            ; 08 parameters
                dw Offset int13_nicht_implementierte_funktion  ; 09 int 41/46
                dw Offset int13_nicht_implementierte_funktion  ; 0a read+ecc
                dw Offset int13_nicht_implementierte_funktion  ; 0b write+ecc
                dw Offset int13_f0c                            ; 0c seek
                dw Offset int13_fehlerfrei                     ; 0d reset
                dw Offset int13_nicht_implementierte_funktion  ; 0e read buffer
                dw Offset int13_nicht_implementierte_funktion  ; 0f write buffer
                dw Offset int13_fehlerfrei                     ; 10 check ready
                dw Offset int13_fehlerfrei                     ; 11 recalibrate
                dw Offset int13_fehlerfrei                     ; 12 ram diag
                dw Offset int13_fehlerfrei                     ; 13 drive diag
                dw Offset int13_fehlerfrei                     ; 14 controller diag
                dw Offset int13_f15                            ; 15 disk type
                dw Offset int13_fehlerfrei                     ; 16 disk chage
                dw Offset int13_nicht_implementierte_funktion  ; 17 set dasd type
                dw Offset int13_nicht_implementierte_funktion  ; 18 set media type
                dw Offset int13_fehlerfrei                     ; 19 park heads
                ; esdi,..,

high_int13_funktions_tabelle_00 equ 019h                       ; 19

int13_funktions_tabelle_41:
                dw Offset int13_f41                            ; 41 IBM/MS INT 13 Extensions - INSTALLATION CHECK
                dw Offset int13_f42                            ; 42 IBM/MS INT 13 Extensions - EXTENDED READ
                dw Offset int13_f43                            ; 43 IBM/MS INT 13 Extensions - EXTENDED WRITE
                dw Offset int13_f44                            ; 44 IBM/MS INT 13 Extensions - VERIFY SECTORS
                dw Offset int13_nicht_implementierte_funktion  ; 45 IBM/MS INT 13 Extensions - LOCK/UNLOCK
                dw Offset int13_nicht_implementierte_funktion  ; 46 IBM/MS INT 13 Extensions - EJECT
                dw Offset int13_f47                            ; 47 IBM/MS INT 13 Extensions - EXTENDED SEEK
                dw Offset int13_f48                            ; 48 IBM/MS INT 13 Extensions - GET DRIVE PARAMETERS

high_int13_funktions_tabelle_41 equ 048h                       ; 48



;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int13handler
                pushf

COMMENT $
push ax
  mov al,'I'
  call ausschrift_zeichen
  mov al,013h
  call ausschrift_al_hex
  mov al,' '
  call ausschrift_zeichen
  mov al,'A'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
pop ax
call ausschrift_ax_hex
push ax
  mov al,' '
  call ausschrift_zeichen
  mov al,'D'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
  mov ax,dx
  call ausschrift_ax_hex

  mov al,' '
  call ausschrift_zeichen
  mov al,'E'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
  mov ax,es
  call ausschrift_ax_hex

  mov al,' '
  call ausschrift_zeichen
  mov al,'B'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
  mov ax,bx
  call ausschrift_ax_hex

  mov al,' '
  call ausschrift_zeichen
  mov al,'S'
  call ausschrift_zeichen
  mov al,'='
  call ausschrift_zeichen
  mov ax,ss
  call ausschrift_ax_hex

  call ausschrift_zeichen_CRLF
pop ax

END COMMENT $

                  cmp dl,cs:[drive_number]              ; my drive?
                  je mein_laufwerk                      ; yes, handle

                  cmp cs:[drive_number],0               ; A: mode?
                  jne filter_harddisk


                  test dl,dl                            ; 80+x?
                  jns call_shifted_floppy_drive         ; process calls B: by previous A: handler
                  jmp nicht_mein_laufwerk

  filter_harddisk:
                  ; memdisk is in harddisk mode, handle some harddisk functions
                  test dl,dl                            ; dont touch floppy (dl<80)
                  jns nicht_mein_laufwerk

                  ; f걊 FDISK
                  cmp ah,8                              ; harddisk: number of HD
                  je int13_f08_fremd                    ; handle special

                  ; DR DOS
                  test ah,ah                            ; reset HD
                  jz int13_f00_fremd                    ; handle special

  nicht_mein_laufwerk:
                popf
                db 0eah
orgint13:       dd ?
                db 013h

  call_shifted_floppy_drive:
                  dec dl
                  call hide_our_floppy

                  cmp ah,008h                   ; returns number of floppy drives in dl
                  je call_shifted_floppy_drive_f08
                  cmp ah,015h                   ; returns cx:dx sector count
                  je call_shifted_floppy_drive_f15

               ;popf
               ;pushf
                call DWord Ptr cs:[orgint13]
                pushf
                  inc dl
                  call unhide_our_floppy
                popf
                jmp iret_pass_carry

  call_shifted_floppy_drive_f08:
               ;popf
               ;pushf
                call DWord Ptr cs:[orgint13]
                call bestimme_anzahl_diskettenlaufwerke_dl
                call unhide_our_floppy
                clc
                jmp iret_pass_carry

  call_shifted_floppy_drive_f15:
               ;popf
               ;pushf
                call DWord Ptr cs:[orgint13]
                pushf
                  call unhide_our_floppy
                popf
                jmp iret_pass_carry


  int13_f00_fremd:
                ; BIOS versucht nicht existierende 2.Platte zu bearbeiten..
                popf
                push fs
                  push bios0040
                  pop fs
                  push ax
                    mov al,cs:[my_harddisk_count_inc]
                    sub byte ptr fs:[harddisk_count],al
                  pop ax
                  pushf
                  call dword ptr cs:[orgint13]
                  pushf
                  push ax
                    mov al,cs:[my_harddisk_count_inc]
                    add byte ptr fs:[harddisk_count],al
                  pop ax
                  popf
                pop fs
                jmp iret_pass_carry

  int13_f08_fremd:

                ; in jedem Fall die "richtige" Anzahl Festplatten melden
                ;popf
                ;pushf
                call dword ptr cs:[orgint13]
                pushf
                call bestimme_anzahl_festplatten_dl
                popf
                jmp iret_pass_carry

  mein_laufwerk:
                popf
  short_entrypoint_memorydisk_int13:
                push ebp

                  movzx bp,ah
                  add bp,bp

                  cmp ah,high_int13_funktions_tabelle_00
                  ja int13_nicht_funktion_00xx
                  jmp word ptr cs:[int13_funktions_tabelle_00+bp]

  int13_nicht_funktion_00xx:
                  cmp ah,041h
                  jb int13_nicht_implementierte_funktion
                  cmp ah,high_int13_funktions_tabelle_41
                  ja int13_nicht_implementierte_funktion
                  jmp word ptr cs:[int13_funktions_tabelle_41+bp-041h*2]

  int13_sektor_nicht_gefunden_al0:
                  mov al,0

  int13_sektor_nicht_gefunden:
                  mov ah,2                      ; Sektor nicht gefunden
                  stc
                  jmp int13_exit_save_status

  int13_parameterfehler_al0:
                  mov al,0
                  jmp int13_parameterfehler

  int13_nicht_implementierte_funktion:

  int13_parameterfehler:
                  mov ah,1
                  stc
  int13_exit_save_status:
                  mov cs:[int13_status],ah
  int13_exit:
                pop ebp
                jmp iret_pass_carry
a_endp          int13handler

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int13_fehlerfrei
                mov ah,0
                clc
                jmp int13_exit_save_status
a_endp          int13_fehlerfrei

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int13_f01
                mov ah,cs:[int13_status]
                jmp int13_exit_save_status
a_endp          int13_f01

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int13_f02
                ; "READ"

                cmp al,0                        ; Anzahl>0
                je int13_parameterfehler_al0

                call ZKS_zu_Sektornummer
                jc int13_sektor_nicht_gefunden_al0

                call pruefe_lineare_ueberschreitung
                ja int13_sektor_nicht_gefunden_al0

                pusha
                  mov si,Offset ext_source_description
                  mov di,Offset ext_target_description
                  call speicher_uebertragung
                popa
                jc int13_sektor_nicht_gefunden_al0

                jmp int13_fehlerfrei
a_endp          int13_f02

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int13_f03
                ; "WRITE"

                cmp al,0                        ; Anzahl>0
                je int13_parameterfehler_al0

                call ZKS_zu_Sektornummer
                jc int13_sektor_nicht_gefunden_al0

                call pruefe_lineare_ueberschreitung
                ja int13_sektor_nicht_gefunden_al0

                pusha
                  mov di,Offset ext_source_description
                  mov si,Offset ext_target_description
                  call speicher_uebertragung
                popa
                jc int13_sektor_nicht_gefunden_al0

                jmp int13_fehlerfrei
a_endp          int13_f03

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; al=num sectors
; si=xms descriptor/..
; di=mem descriptor/..
; ebp=first sector number

IFDEF dos
                ; returns carry 0/1
a_proc          speicher_uebertragung
                push ds

                  push cs
                  pop ds

                  ; from/to XMS
                  shl ebp,9                     ; *512
                  mov [si].EMM_offset_into_block,ebp
                  mov bp,[xms_handle]
                  mov [si].EMM_handle,bp

                  ; from/to <1M memory
                  mov [di].EMM_offset_into_block._OFF,bx
                  mov [di].EMM_offset_into_block._SEG,es
                  mov [di].EMM_handle,0

                  ; size
                  mov si,Offset EMM_mover
                  movzx ebp,al
                  shl ebp,9                     ; *512
                  mov [si].EMM_number_of_bytes_to_move,ebp

                  mov ah,00bh ; Move extended memory block
                 ;ds:si=@EMM_mover
                  call [xmm]

                  cmp ax,00001 ; ok ?
                  ; ax=0 (error) -> cf=1
                  ; ax=1 (ok   ) -> cf=0

                pop ds
                ret
a_endp          speicher_uebertragung

ENDIF ; dos
IFDEF bios

int13_problem_protected_mode db msg_int13_problem_protected_mode,0

                ; returns carry 0/1
a_proc          speicher_uebertragung

                ;  setup GDT

                ; modifies ebp
                push eax

                  ;mov si,si

                  mov eax,ebp
                  shl eax,9                   ; *512
                  add eax,cs:MemDiskBIOS_Info._phys_addr
                  call set_descriptor_base

                  mov si,di
                  mov eax,es
                  shl eax,4
                  movzx ebp,bx
                  add eax,ebp
                  call set_descriptor_base

                pop eax

                ; call BIOS to do the copy work

                ; al=Anzahl Sektoren
                ; GDT: Quelle/Ziel
                push es

                  ; ES:SI=GDT
                  push cs
                  pop es
                  mov si,Offset EXT_GDT
                  ; cx=anzahl 16 bit
                  shl ax,8    ; *512/2
                  mov cx,ax

IFNDEF dos
                  ; IBMINT13.I13: kein XMS, EMM386, DPMI,...
                  ; -> kein Zugriff
                  push eax
                    mov eax,cr0
                    shr al,1                  ; Protected Mode ?
                    jnc no_ems386_test

                    mov al,0

                    push ds

                      push 0
                      pop ds


                      COMMENT $ does not work with qemm ---------------------

                      ; test Virtual DMA installed
                      test byte ptr ds:[0047bh],020h ; 40:7b bit 5
                      jz no_VDMA

                      pushad
                        ; Virtual DMA version ?
                        mov ax,08102h
                        sub dx,dx
                        stc
                        int 04bh
                      popad
                      jnc found_ems_386_driver

  no_VDMA:
                       -----------------------------------------------------$
                      ; Int 67 - EMS
                      mov ax,word ptr ds:[067h*4+2]

                      cmp ax,00050h
                      jb not_ems_386_driver
                      cmp ax,0a000h
                      jb maybe_ems_386_driver

                      cmp ax,0c800h
                      jb not_ems_386_driver
                      cmp ax,0f000h
                      jae not_ems_386_driver

  maybe_ems_386_driver:

                      mov ds,ax

                      ; "EMMXXXX0", "QMMXXX0" ?
                      cmp dword ptr ds:[10+4],'0XXX'
                      jne not_ems_386_driver

                      cmp dword ptr ds:[10+0],'XMME'  ; enabled driver
                      je found_ems_386_driver
                      cmp dword ptr ds:[10+0],'XMMQ'  ; disabled driver
                      jne not_ems_386_driver
  found_ems_386_driver:
                      clc
                      jmp continue_ems_386_driver
  not_ems_386_driver:
                      stc
  continue_ems_386_driver:

                    pop ds

  no_ems386_test:
                  pop eax
                 ;jc no_protected_mode        ; stc ist gesetzt
                  jnc protected_mode_works

                  pusha
                    call check_if_OS2KRNL_miniVDM_Int13
                    jz skip_errormessage_if_ibmint13_i13

                    mov si,Offset int13_problem_protected_mode
                    call ausschrift
                    call tastendruck
                    call ausschrift_zeichen_CRLF

  skip_errormessage_if_ibmint13_i13:

                  popa
                  stc
                  jmp no_protected_mode

  protected_mode_works:

ENDIF ; non-dos protected mode crash protection

                  ; es:si=descriptors cx=words
                  ; -> CF, AH
                  push ax
                    call int_15_87
                  pop ax


  no_protected_mode:

                pop es

                ;----------------------------------------------------
                ; testcode to print transfer to/from memory disk
                ; over serial debug link. was used to diagnose problems
                ; with Intel AGP boards (was memory size mis-detection)

IFDEF serial_debug

;debug_memdisk_transfer  equ 1

ENDIF ; serial_debug

IFDEF debug_memdisk_transfer

                pushf
                pusha ; es:bx,cx*2

                  ; not during format/verify/unpack
                  cmp [drive_number],'M'
                  je exit_debug_read_agp

                  mov al,13
                  call output_com2
                  mov al,10
                  call output_com2

                  mov ax,cx
                  shr ax,8

  loop_debug_read_agp:
                  test ax,ax
                  jz exit_debug_read_agp

                  push ax

                    mov ax,es
                    call output_com2_ax_hex
                    mov al,':'
                    call output_com2
                    mov ax,bx
                    call output_com2_ax_hex

                    mov al,' '
                    call output_com2
                    mov al,' '
                    call output_com2

                    mov cx,10
  loop_debug_es_bx_agp:
                    mov al,es:[bx]
                    inc bx
                    call output_com2_al_hex
                    mov al,' '
                    call output_com2
                    loop loop_debug_es_bx_agp
                    sub bx,10

                    mov al,' '
                    call output_com2

                    mov cx,40
  loop_debug_es_bx_agp_asc:
                    mov al,es:[bx]
                    inc bx
                    cmp al,' '
                    if_b <mov al,'.'>
                    call output_com2
                    loop loop_debug_es_bx_agp_asc
                    sub bx,40

                    mov al,13
                    call output_com2
                    mov al,10
                    call output_com2

                  pop ax

                  dec ax
                  add bx,512
                  jmp loop_debug_read_agp

  exit_debug_read_agp:

                popa
                popf

ENDIF           ; debug_memdisk_transfer
                ;----------------------------------------------------


                ret
a_endp          speicher_uebertragung

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
IFDEF debug_memdisk_transfer
a_proc          output_com2_halbbyte_hex
                pushf
                  push ax
                    and al,00fh
                                        ; Norbert Juffa:
                    cmp al,10           ; if x < 10, set CF = 1
                    sbb al,69h          ; 0-9: 96h .. 9Fh,  A-F: A1h..A6h
                    das                 ; 0-9: subtr. 66h -> 30h..39h,
                                        ; A-F: subtr. 60h -> 41h..46h
                    call output_com2
                  pop ax
                popf
                ret
a_endp          output_com2_halbbyte_hex

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          output_com2_al_hex
                rol al,4
                call output_com2_halbbyte_hex
                rol al,4
                call output_com2_halbbyte_hex
                ret
a_endp          output_com2_al_hex

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          output_com2_ax_hex
                rol ax,8
                call output_com2_al_hex
                rol ax,8
                call output_com2_al_hex
                ret
a_endp          output_com2_ax_hex

ENDIF ; debug_memdisk_transfer
ENDIF ; bios

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int13_f04
                ; "verify"

                cmp al,0
                je int13_parameterfehler

                call ZKS_zu_Sektornummer
                jc int13_sektor_nicht_gefunden_al0

                call pruefe_lineare_ueberschreitung
                ja int13_sektor_nicht_gefunden_al0

                jmp int13_fehlerfrei
a_endp          int13_f04

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; some fantasy values.. (1.4M drive)

my_DBT          db 0dfh                         ; step rate/head unload time
                db 002h                         ; head load/dma mode
                db 025h                         ; motor shutoff
                db 2                            ; 512 byte sectors
                db 63                           ; sectors per track (updated below)
                db 01bh                         ; inter-block gap length/gap between sectors
                db 0ffh                         ; data length if not specified
                db 06ch                         ; gap length beween sectorst for format
                db 0f6h                         ; fill byte for formated sectors
                db 00fh                         ; head settle time in milliseconds
                db 004h                         ; motor startup time in 1/8s


a_proc          int13_f08
                ; bl nur Diskette
               ;test dl,080h                    ; HD bit clear
               ;jnz int13_f08_not_floppy        ; no, skip A: mode values
                test dl,dl                      ; HD bit clear
                js int13_f08_not_floppy         ; no, skip A: mode values

               ;mov bl,010h                     ; we are 'ATAPI removable media device (no better value..?)
                mov bl,6                        ; 2.88M floppy
                push cs
                pop es                          ; es:di disk base table
                mov di,Offset my_DBT

                mov al,byte ptr cs:MemDiskBIOS_Info._anzahl_sektoren_je_spur
                mov es:[di+4],al

  int13_f08_not_floppy:

                mov cx,word ptr cs:MemDiskBIOS_Info._anzahl_zylinder
                dec cx
                rol cx,8
                rol cl,6
                or cl,byte ptr cs:MemDiskBIOS_Info._anzahl_sektoren_je_spur
                mov dh,byte ptr cs:MemDiskBIOS_Info._anzahl_koepfe
                dec dh
                ; floppy or hard disk count
                call bestimme_anzahl_festplatten_dl
                cmp cs:[drive_number],0
                if_e <call bestimme_anzahl_diskettenlaufwerke_dl>
                mov al,0
                jmp int13_fehlerfrei
a_endp          int13_f08

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          bestimme_anzahl_festplatten_dl
                push ds
                  push bios0040
                  pop ds
                  mov dl,byte ptr ds:[harddisk_count]
                pop ds
                ret
a_endp          bestimme_anzahl_festplatten_dl

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          bestimme_anzahl_diskettenlaufwerke_dl
                push eax

                  sub eax,eax
                  int 011h
                  mov dl,al
                  and dl,1                      ; floppy present?
                  jz have_number_of_floppy_drives ; no -> 0

                  ; yes, get number from bit 7/6 (0->1,1->2,2->3,3->4)
                  shr al,6
                  add dl,al

  have_number_of_floppy_drives:

                pop eax
                ret
a_endp          bestimme_anzahl_diskettenlaufwerke_dl

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          unhide_our_floppy
                push ds
                push si
                  push bios0040
                  pop ds
                  mov si,equipements_list_flag
                  bts Word Ptr [si],0           ; set floppy available flag
                  jc unhide_previously_present

                  ; we are the only floppy set count to 1-1
                  ; by seting bit 7/6 to 0
                  and Byte Ptr [si],03fh
                  jmp unhide_continue

  unhide_previously_present:
                  ; there where already at least one drive,
                  ; simply increment the number (bit 7/6)
                  add Byte Ptr [si],040h

  unhide_continue:

                pop si
                pop ds
                ret
a_endp          unhide_our_floppy

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          hide_our_floppy
                push ds
                push si
                  push bios0040
                  pop ds
                  mov si,equipements_list_flag

                  ; check current count to be 0 "one drive" (bit 7/6)
                  test Byte Ptr [si],0c0h
                  jnz hide_our_floppy_not_alone ; we are not the only drive

                  ; we are the only floppy, clear floppy present bit 0
                  and Byte Ptr [si],(not 1)
                  jmp hide_our_floppy_continue

  hide_our_floppy_not_alone:
                  ; there is at least one other drive,
                  ; only lower the number
                  sub Byte Ptr [si],040h

  hide_our_floppy_continue:

                pop si
                pop ds
                ret
a_endp          hide_our_floppy

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int13_f0c
                call ZKS_zu_Sektornummer
                jc int13_sektor_nicht_gefunden

                jmp int13_fehlerfrei
a_endp          int13_f0c

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          int13_f15
                ; "get disk type"
                mov ah,2                        ; floppy with change-line support
                cmp cs:[drive_number],0         ; A:?
                je done_int13_f15               ; yes

                mov ah,3                        ; no, hard disk
                push dword ptr cs:MemDiskBIOS_Info._anzahl_sektoren
                pop dx
                pop cx
  done_int13_f15:
                mov cs:[int13_status],0
                clc
                jmp int13_exit
a_endp          int13_f15

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          ZKS_zu_Sektornummer
                ; cx,dh-> ebp
                ; clc=fehlerfrei stc=ung걄tig
                push eax

                  movzx eax,ch
                  mov ah,cl
                  shr ah,6
                  cmp eax,cs:MemDiskBIOS_Info._anzahl_zylinder
                  jae fehler_ZKS_zu_Sektornummer

                  push edx
                    mul dword ptr cs:MemDiskBIOS_Info._anzahl_koepfe
                  pop edx
                  mov ebp,eax

                  cmp dh,byte ptr cs:MemDiskBIOS_Info._anzahl_koepfe
                  jae fehler_ZKS_zu_Sektornummer

                  movzx eax,dh
                  add eax,ebp
                  push edx
                    mul dword ptr cs:MemDiskBIOS_Info._anzahl_sektoren_je_spur
                  pop edx
                  mov ebp,eax

                  mov al,cl
                  and eax,03fh
                  cmp al,0
                  je fehler_ZKS_zu_Sektornummer
                  cmp al,byte ptr cs:MemDiskBIOS_Info._anzahl_sektoren_je_spur
                  ja fehler_ZKS_zu_Sektornummer

                  add ebp,eax
                  dec ebp
                  clc
                  jmp exit_ZKS_zu_Sektornummer

  fehler_ZKS_zu_Sektornummer:
                  or ebp,-1                     ; Fehler
                  stc

  exit_ZKS_zu_Sektornummer:
                pop eax
                ret
a_endp          ZKS_zu_Sektornummer

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; ebp=sektornummer al=Anzahl Sektoren
a_proc          pruefe_lineare_ueberschreitung
                push eax
                  push ebp
                    movzx eax,al
                    add ebp,eax
                    cmp eax,cs:MemDiskBIOS_Info._anzahl_sektoren
                  pop ebp
                pop eax
                ret
a_endp          pruefe_lineare_ueberschreitung

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

IFDEF bios
a_proc          set_descriptor_base
                ; CS:SI=GDT entry, EAX=Base
                mov cs:[si].BaseAddr1500,ax
                ror eax,16
                mov cs:[si].BaseAddr2316,al
                mov cs:[si].BaseAddr3124,ah
                rol eax,16
                ret
a_endp          set_descriptor_base
ENDIF ; bios

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; IBM/MS INT 13 Extensions - INSTALLATION CHECK
a_proc          int13_f41
                cmp bx,055aah
                jne int13_nicht_implementierte_funktion

                mov bx,0aa55h
                mov ah,021h                     ; Version 2.1 - needed by MBR
                mov al,0                        ; unused
                mov cx,1                        ; supported function: 42..44,47,48
                mov dh,0                        ; unused
                clc
                jmp int13_exit
a_endp          int13_f41

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; IBM/MS INT 13 Extensions - EXTENDED READ
a_proc          int13_f42
                call verify_disk_packet
                jc int13_parameterfehler_f42

                push es
                pusha
                  call load_disk_packet
                  mov si,Offset ext_source_description
                  mov di,Offset ext_target_description
                  call speicher_uebertragung
                popa
                pop es
                jnc int13_fehlerfrei

  int13_parameterfehler_f42:
                and ds:[si].disk_address_packet.number_of_blocks_to_transfer,0
                jmp int13_sektor_nicht_gefunden
a_endp          int13_f42

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; IBM/MS INT 13 Extensions - EXTENDED WRITE
a_proc          int13_f43
                call verify_disk_packet
                jc int13_parameterfehler_f43

                push es
                pusha
                  call load_disk_packet
                  mov di,Offset ext_source_description
                  mov si,Offset ext_target_description
                  call speicher_uebertragung
                popa
                pop es
                jnc int13_fehlerfrei

  int13_parameterfehler_f43:
                and ds:[si].disk_address_packet.number_of_blocks_to_transfer,0
                jmp int13_sektor_nicht_gefunden
a_endp          int13_f43

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; IBM/MS INT 13 Extensions - VERIFY SECTORS
a_proc          int13_f44
                call verify_disk_packet
                jnc int13_fehlerfrei

                and ds:[si].disk_address_packet.number_of_blocks_to_transfer,0
                jmp int13_sektor_nicht_gefunden
a_endp          int13_f44

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; IBM/MS INT 13 Extensions - EXTENDED SEEK
a_proc          int13_f47
                call verify_disk_packet
                jc int13_parameterfehler
                jmp int13_fehlerfrei
a_endp          int13_f47

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; IBM/MS INT 13 Extensions - GET DRIVE PARAMETERS
a_proc          int13_f48

                ; 2.x size ?
                cmp ds:[si].drive_parameter_table_i13x.i13x_buffer_size,01eh
                jb no_space_for_2x_informations

                mov ds:[si].drive_parameter_table_i13x.i13x_buffer_size,01eh
                or  ds:[si].drive_parameter_table_i13x.EDD_configuration_parameters,-1
                jmp nocheck_space_for_1x_informations

  no_space_for_2x_informations:

                ; buffer space for 1.x result ?
                cmp ds:[si].drive_parameter_table_i13x.i13x_buffer_size,01ah
                jb int13_parameterfehler

                mov ds:[si].drive_parameter_table_i13x.i13x_buffer_size,01ah

  nocheck_space_for_1x_informations:

                mov ds:[si].drive_parameter_table_i13x.i13x_informationflags,2 ; chs valid
                push eax
                  mov eax,cs:MemDiskBIOS_Info._anzahl_zylinder
                  mov ds:[si].drive_parameter_table_i13x.i13x_physical_cylinders,eax
                  mov eax,cs:MemDiskBIOS_Info._anzahl_koepfe
                  mov ds:[si].drive_parameter_table_i13x.i13x_physical_heads,eax
                  mov eax,cs:MemDiskBIOS_Info._anzahl_sektoren_je_spur
                  mov ds:[si].drive_parameter_table_i13x.i13x_physical_sec_p_track,eax
                  mov eax,cs:MemDiskBIOS_Info._anzahl_sektoren
                  mov dword ptr ds:[si].drive_parameter_table_i13x.i13x_number_of_sectors+0,eax
                  and dword ptr ds:[si].drive_parameter_table_i13x.i13x_number_of_sectors+4,0
                  mov ds:[si].drive_parameter_table_i13x.i13x_bytes_per_sector,512
                pop eax
                jmp int13_fehlerfrei
a_endp          int13_f48

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          verify_disk_packet
                push eax

                  ; good packet size ?
                  cmp ds:[si].disk_address_packet.disk_address_packet_size,Size disk_address_packet
                  jne fail__verify_disk_packet

                  ; not more than 64KB ?
                  cmp ds:[si].disk_address_packet.number_of_blocks_to_transfer,127 ; $FE00
                  ja fail__verify_disk_packet

                  ; transfer_buffer should be ok

                  ; above sector number limit ?
                  cmp dword ptr ds:[si].disk_address_packet.starting_block_number+4,0
                  jne fail__verify_disk_packet

                  mov eax,cs:MemDiskBIOS_Info._anzahl_sektoren
                  cmp dword ptr ds:[si].disk_address_packet.starting_block_number+0,eax
                  jae fail__verify_disk_packet

                  movzx eax,ds:[si].disk_address_packet.number_of_blocks_to_transfer
                  add eax,dword ptr ds:[si].disk_address_packet.starting_block_number+0
                  cmp eax,cs:MemDiskBIOS_Info._anzahl_sektoren
                  ja fail__verify_disk_packet

                  clc
                  jmp exit__verify_disk_packet

  fail__verify_disk_packet:
                  stc

  exit__verify_disk_packet:

                pop eax
                ret
a_endp          verify_disk_packet

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          load_disk_packet
                mov al,byte ptr ds:[si].disk_address_packet.number_of_blocks_to_transfer
                les bx,ds:[si].disk_address_packet.transfer_buffer
                mov ebp,dword ptr ds:[si].disk_address_packet.starting_block_number+0
                ret
a_endp          load_disk_packet

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; -> ZF=1=called by miniVDM code
a_proc          check_if_OS2KRNL_miniVDM_Int13
                push ax

                    ; when called by ibmint13.i13, ss=0000, sp=~0ffc
                    ; and at 0000:0800 the following code is present:
                    ;  0000:0800 f4 50 af eb fb cc cc cc-cc cc cc cc cc cc cc cc
                    ;  0000:0810 f4 50 af eb fb f4 56 a9-eb fb cc cc cc cc cc cc
                    ;
                    ;  0000:0800   hlt
                    ;  0000:0801   db 50,af
                    ;  0000:0803   jmp 0800
                    mov ax,ss
                    test ax,ax
                    jne exit_check_if_OS2KRNL_miniVDM_Int13 ; ZF=0

                    mov ax,sp
                    cmp ah,00fh
                    jne exit_check_if_OS2KRNL_miniVDM_Int13 ; ZF=0

                    cmp DWord Ptr ss:[0800h],0ebaf50f4h

  exit_check_if_OS2KRNL_miniVDM_Int13:

                pop ax
                ret
a_endp          check_if_OS2KRNL_miniVDM_Int13
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
