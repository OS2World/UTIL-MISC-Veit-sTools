Title           Detect Int $15 memory size and allocate

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
speicher_ab_1M  dd 0
speicher_ab_16M dd 0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

puffer_e820     smap <>

meldung_benutze_e820 db msg_int15a_e820,13,10,0

a_proc          detect_memory_size_e820
                STEP 'E820'
                pushad

                  sub ebx,ebx
  detect_memory_size_e820_schleife:
                  mov eax,0e820h
                  mov edx,'SMAP'
                  mov ecx,Size smap
                  mov di,Offset puffer_e820
                  stc
                  int 015h
                  jc detect_memory_size_e820_exit
                  cmp eax,'SMAP'
                  stc
                  jne detect_memory_size_e820_ret

                  cmp [di].smap.memtype,smap_memtype_memory
                  jne detect_memory_size_e820_weiter

                  cmp [di].smap.base_hi,0
                  jne detect_memory_size_e820_weiter
                  cmp [di].smap.base_lo,MB1
                  jne nicht_ADR_1MB_e820

                  mov eax,[di].smap.length_lo
                  mov edx,[di].smap.length_hi
                  cmp eax,MINUS_1MB
                  jae zu_gross_ab_1MB
                  cmp edx,0
                  je nicht_zu_gross_ab_1MB
  zu_gross_ab_1MB:
                  mov eax,MINUS_1MB
  nicht_zu_gross_ab_1MB:
                  mov [speicher_ab_1M],eax
                  jmp detect_memory_size_e820_weiter

  nicht_ADR_1MB_e820:
                  cmp [di].smap.base_lo,MB16
                  jne nicht_ADR_16MB_e820

                  mov eax,[di].smap.length_lo
                  mov edx,[di].smap.length_hi
                  cmp eax,MINUS_16MB
                  jae zu_gross_ab_16MB
                  cmp edx,0
                  je nicht_zu_gross_ab_16MB
  zu_gross_ab_16MB:
                  mov eax,MINUS_16MB
  nicht_zu_gross_ab_16MB:
                  mov [speicher_ab_16M],eax
                  ;jmp detect_memory_size_e820_weiter
  nicht_ADR_16MB_e820:
  detect_memory_size_e820_weiter:
                  or bx,bx
                  jnz detect_memory_size_e820_schleife


  detect_memory_size_e820_exit:
                  cmp speicher_ab_1M,0
                  jne detect_memory_size_e820_ret_clc
                  cmp speicher_ab_16M,0
                  jne detect_memory_size_e820_ret_clc
                  stc
                  jmp detect_memory_size_e820_ret
  detect_memory_size_e820_ret_clc:
                  mov si,Offset meldung_benutze_e820
                  call ausschrift
                  clc
  detect_memory_size_e820_ret:
                popad
                ret
a_endp          detect_memory_size_e820

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

meldung_benutze_e881 db msg_int15a_e881,13,10,0

a_proc          detect_memory_size_e881
                STEP 'E881'
                pushad
                  mov eax,0FFFFe881h
                  stc
                  int 015h
                  jc exit_detect_memory_size_e881
                  test eax,0FFFF0000h
                  stc
                  jnz exit_detect_memory_size_e881

                  shl eax,10                            ; *1024
                  mov speicher_ab_1M,eax
                  cmp ebx,MINUS_16MB_in_KB
                  if_a < mov ebx,MINUS_16MB_in_KB >
                  shl ebx,16                            ; *64K
                  mov speicher_ab_16M,ebx
                  mov si,Offset meldung_benutze_e881
                  call ausschrift
                  clc
  exit_detect_memory_size_e881:
                popad
                ret
a_endp          detect_memory_size_e881

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ps2_memmap:     ps2_memory_map <>

meldung_benutze_c7 db msg_int15a_c7,13,10,0

a_proc          detect_memory_size_c7
                STEP 'C7PS'
                pushad

                  mov ah,0c7h
                  mov si,Offset ps2_memmap
                  stc
                  int 015h
                  jc exit_detect_memory_size_c7
                  cmp ah,0
                  jne exit_detect_memory_size_c7

                  ; 1M..15M
                  mov eax,[si].ps2_local_1M
                  mov edx,[si].ps2_system_1M
                  cmp eax,MB15_in_KB
                  ja exit_detect_memory_size_c7
                  cmp edx,MB15_in_KB
                  ja exit_detect_memory_size_c7
                  cmp eax,edx
                  if_a <mov eax,edx>
                  test eax,eax
                  jz exit_detect_memory_size_c7
                  shl eax,10                            ; *1K
                  mov speicher_ab_1M,eax


                  ; 16M..4G
                  mov eax,[si].ps2_local_16M
                  mov edx,[si].ps2_system_16M
                  cmp eax,edx
                  if_a <mov eax,edx>
                  test eax,eax
                  jz exit_detect_memory_size_c7
                  cmp eax,MINUS_16MB_in_KB
                  if_a < mov eax,MINUS_16MB_in_KB >
                  shl eax,10                            ; *1K
                  mov speicher_ab_16M,eax

                  mov si,Offset meldung_benutze_c7
                  call ausschrift
                  clc
                  jmp exit_detect_memory_size_c7

  error_detect_memory_size_c7:
                  stc

  exit_detect_memory_size_c7:
                popad
                ret
a_endp          detect_memory_size_c7

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

meldung_benutze_e801 db msg_int15a_e801,13,10,0

a_proc          detect_memory_size_e801
                STEP 'E801'
                pushad
                  mov ax,0e801h
                  stc
                  int 015h
                  jc exit_detect_memory_size_e801

                  cmp ax,03c00h
                  jbe valid1_e801
                  stc
                  jmp exit_detect_memory_size_e801

  valid1_e801:

                  test ax,ax
                  jnz continue_detect_memory_size_e801
                  test bx,bx
                  jnz continue_detect_memory_size_e801

                  ; ax=bx=0: use cx/dx
                  mov ax,cx
                  mov bx,dx

  continue_detect_memory_size_e801:
                  movzx eax,ax
                  shl eax,10                            ; *1K
                  mov speicher_ab_1M,eax
                  movzx eax,bx
                  shl eax,16                            ; *64K
                  mov speicher_ab_16M,eax


                  mov si,Offset meldung_benutze_e801
                  call ausschrift
                  clc

  exit_detect_memory_size_e801:

                popad
                ret
a_endp          detect_memory_size_e801

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

meldung_benutze_8a db msg_int15a_8a,13,10,0

a_proc          detect_memory_size_8a
                STEP '8APH'
                pushad
                  mov ah,08ah
                  mov dx,-1
                  stc
                  int 015h
                  jc exit_detect_memory_size_8a
                  cmp dx,-1
                  stc
                  je exit_detect_memory_size_8a

                  shl eax,16
                  mov ax,dx
                  cmp eax,MINUS_16MB_in_KB
                  if_a < mov eax,MINUS_16MB_in_KB >
                  shl eax,10                            ; *1K
                  mov speicher_ab_1M,eax

                  mov si,Offset meldung_benutze_8a
                  call ausschrift
                  clc
  exit_detect_memory_size_8a:
                popad
                ret
a_endp          detect_memory_size_8a

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

meldung_benutze_da88: db msg_int15a_da88,13,10,0

a_proc          detect_memory_size_da88
                STEP 'DA88'
                pushad

                  mov ax,0da88h
                  stc
                  int 015h
                  jc exit_detect_memory_size_da88
                  test ax,ax
                  stc
                  jnz exit_detect_memory_size_da88

                  movzx eax,cl
                  shl eax,16
                  mov ax,bx
                  cmp eax,MINUS_16MB_in_KB
                  if_a < mov eax,MINUS_16MB_in_KB >
                  shl eax,10                            ; *1K
                  mov speicher_ab_1M,eax

                  mov si,Offset meldung_benutze_da88
                  call ausschrift
                  clc
  exit_detect_memory_size_da88:

                popad
                ret
a_endp          detect_memory_size_da88

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

meldung_benutze_88: db msg_int15a_88,13,10,0

a_proc          detect_memory_size_88
                STEP '88AT'
                pushad

                  mov ax,08800h
                  stc
                  int 015h
                  ;-carry is documented unreliable- jc exit_detect_memory_size_88
                  push ax

                  mov ax,088ffh
                  int 015h

                  pop bx
                  cmp ax,bx
                  stc
                  jne exit_detect_memory_size_88



                  ; Beschr„nkung auf knapp 64MB (OS2LDR)
                  mov dx,0fffch
                  cmp ax,dx
                  if_a <mov ax,dx>

                  movzx eax,ax
                  shl eax,10                            ; *1K
                  mov speicher_ab_1M,eax

                  mov si,Offset meldung_benutze_88
                  call ausschrift
                  clc

  exit_detect_memory_size_88:

                popad
                ret
a_endp          detect_memory_size_88

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

meldung_detect_memory   db msg_Detecting_extended_memory_size,0

meldung_MB_ab_1MB       db msg_MB_starting_at_1_MB,13,10,0
meldung_MB_ab_16MB      db msg_MB_starting_at_16_MB,13,10,0

msg_memsize_linestart   db ' ş ',0


a_proc          detect_memory_size
                pushad

                  mov si,Offset meldung_detect_memory
                  call ausschrift

                  call detect_memory_size_e820
                  jnc exit__detect_memory_size

                  call detect_memory_size_e881
                  jnc exit__detect_memory_size

                  call detect_memory_size_c7
                  jnc exit__detect_memory_size

                  call detect_memory_size_e801
                  jnc exit__detect_memory_size

                  call detect_memory_size_8a
                  jnc exit__detect_memory_size

                  call detect_memory_size_da88
                  jnc exit__detect_memory_size

                  call detect_memory_size_88
                  jnc exit__detect_memory_size

                  STEP 'MemF'

                  fehler_halt msg_failed

  exit__detect_memory_size:
                  ;--------------------------------------------------
                  STEP 'MemS'

                  cmp speicher_ab_16M,0
                  je F2_speicher_ist_durchgaengig

                  ; 1..1? MB und 16..yyy MB
                  cmp speicher_ab_1M,MB15
                  if_ae <mov speicher_ab_1M,MB15>

                  cmp speicher_ab_16M,MINUS_16MB
                  if_ae <mov speicher_ab_16M,MINUS_16MB>

                  cmp speicher_ab_1M,MB15
                  jne speicher_1_16_nicht_kombinierbar

                  sub eax,eax
                  xchg speicher_ab_16M,eax
                  add speicher_ab_1M,eax
                  jmp F2_speicher_ist_durchgaengig

  speicher_1_16_nicht_kombinierbar:

                  mov si,Offset msg_memsize_linestart
                  call ausschrift
                  mov eax,speicher_ab_1M
                  shr eax,20                            ; / 1M
                  call ausschrift_eax
                  mov si,Offset meldung_MB_ab_1MB
                  call ausschrift

                  mov si,Offset msg_memsize_linestart
                  call ausschrift
                  mov eax,speicher_ab_16M
                  shr eax,20                            ; / 1M
                  call ausschrift_eax
                  mov si,Offset meldung_MB_ab_16MB
                  call ausschrift

                  ; Prfe Speichergr”áe
                  ; Geometrieneuberechung zur Verteilung zus„tzlichen Speichers
                  mov eax,speicher_ab_1M
                  add eax,speicher_ab_16M
                  call create_memdisk_geometry

                  ; nimm Speicher von 16..Ende
                  mov eax,MemDiskBIOS_Info._anzahl_sektoren
                  shl eax,9                             ; *512
                  sub speicher_ab_16M,eax

                  ; Ende des Speichers fr OS/2 ist
                  ; Anfang des Speichers fr die Platte
                  mov eax,speicher_ab_16M
                  add eax,MB16
                  mov MemDiskBIOS_Info._phys_addr,eax

                  mov eax,speicher_ab_1M
                  cmp eax,MB15
                  if_e <add eax,speicher_ab_16M>
                  shr eax,10                            ; /1024
                  mov wert_15_8a,eax
                  cmp eax,0ffffh
                  if_a <mov ax,0ffffh>
                  mov wert_15_88,ax

                  mov eax,speicher_ab_1M
                  mov edx,speicher_ab_16M
                  shr eax,10                            ; /1024 [bis 16M in 1 KB]
                  shr edx,10                            ; /1024 [ab  16M in 1 KB]
                  mov wert_15_c7,edx

                  shr edx,6                             ; /64   [ab  16M in 64 KB]

                  mov wert_15_e801_ax,ax
                  mov wert_15_e801_bx,0ffffh
                  cmp edx,0ffffh
                  if_b < mov wert_15_e801_bx,dx >

                  mov wert_15_e881_ebx,edx
                  jmp speicher_belegung_weiter

                  ;--------------------------------------------------
                  ; 1..yyy MB
  F2_speicher_ist_durchgaengig:

                  mov si,Offset msg_memsize_linestart
                  call ausschrift

                  mov eax,speicher_ab_1M
                  shr eax,20                            ; / 1M
                  call ausschrift_eax
                  mov si,Offset meldung_MB_ab_1MB
                  call ausschrift

                  ; nicht mehr als 4 GB
                  mov edx,MINUS_1MB
                  cmp speicher_ab_1M,edx
                  if_a <mov speicher_ab_1M,edx>

                  ; Prfe Speichergr”áe
                  ; Geometrieneuberechung zur Verteilung zus„tzlichen Speichers
                  mov eax,speicher_ab_1M
                  call create_memdisk_geometry

                  ; Speicher fr Memdisk abziehen
                  mov eax,cs:MemDiskBIOS_Info._anzahl_sektoren
                  shl eax,9                             ; *512
                  sub speicher_ab_1M,eax
                  ; Startadresse ausrechnen
                  mov eax,speicher_ab_1M
                  lea edx,[eax+MB1]
                  mov MemDiskBIOS_Info._phys_addr,edx

                  shr eax,10                            ; /1024
                  lea ecx,[eax-MB15_in_KB]              ; ab 16 MB [in KB]
                  mov wert_15_8a,eax

                  mov wert_15_88,0ffffh
                  cmp eax,0ffffh
                  if_b <mov wert_15_88,ax>

                  mov wert_15_c7,ecx
                  shr ecx,6                             ; /64 [in 64KB]
                  mov wert_15_e801_ax,MB15_in_KB
                  mov wert_15_e801_bx,0ffffh
                  cmp ecx,0ffffh
                  if_b <mov wert_15_e801_bx,cx>
                  mov wert_15_e881_ebx,ecx

  speicher_belegung_weiter:
                  call display_used_memory

                popad
                ret
a_endp          detect_memory_size

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; Sony Vaio FX203
a_proc          detect_abios
                STEP 'ABIO'
                pushad
                push ds
                push es
                push fs

                  sub sp,32
                  mov di,sp
                  push ss
                  pop es
                  push 0
                  pop ds

                  stc
                  int 015h
                  jc abios_not_present
                  test ah,ah
                  jnz abios_not_present

                  mov cs:no_abios,false
 abios_not_present:
                  add sp,32
                pop fs
                pop es
                pop ds
                popad
                ret
a_endp          detect_abios

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


