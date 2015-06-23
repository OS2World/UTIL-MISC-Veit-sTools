Title           internal Memory allocation 0..639KB

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

;*getmem_es_di_ptr ptr1616 <>

speicher_block_beschreibung Struc
  speicher_block_kennung    dd ? ; 'SPBL'
  speicher_block_naechster  dw ? ; Segment
  speicher_block_belegt     db ? ; 0=frei 1=belegt
                            db ? ; 0
speicher_block_beschreibung EndS


; Segment des ersten speicher_block_beschreibung-Blockes

erster_speicher_block       dw 0

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          pruefe_speicherkette
                push ax
                push ds
                  mov ax,cs:[erster_speicher_block]
pruefe_speicherkette_loop:
                  call pruefe_speicherblock
                  mov ds,ax
                  mov ax,ds:[0].speicher_block_naechster
                  test ax,ax
                  jnz pruefe_speicherkette_loop

                pop ds
                pop ax
                ret
a_endp          pruefe_speicherkette

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          pruefe_speicherblock
                push si
                push ds
                  test ax,ax
                  jz damaged_memory_block
                  mov ds,ax
                  null si
                  cmp ds:[si].speicher_block_kennung,'SPBL'
                  jne damaged_memory_block
                  cmp ds:[si].speicher_block_belegt,1
                  ja damaged_memory_block
                  cmp ds:[si].speicher_block_naechster,0
                  je ok_memory_block
                  cmp ds:[si].speicher_block_naechster,ax
                  ja ok_memory_block

  damaged_memory_block:

                  trap msg_memory_block_corrupted

  ok_memory_block:

                pop ds
                pop si
                ret
a_endp          pruefe_speicherblock

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          verketten_freier_speicherbloecke
                pusha
                push ds
                push es

                  null si
                  mov ax,cs:[erster_speicher_block]

  schleife_verketten_freier_speicherbloecke:

                 ;mov ax,ax
                  call pruefe_speicherblock

                  mov ds,ax
                  mov ax,ds:[si].speicher_block_naechster
                  test ax,ax
                  jz schleife_verketten_freier_speicherbloecke_ende
                  call pruefe_speicherblock

                  mov es,ax
                  cmp ds:[si].speicher_block_belegt,0
                  jne verketten_freier_speicherbloecke_nicht_frei
                  cmp es:[si].speicher_block_belegt,0
                  jne verketten_freier_speicherbloecke_nicht_frei

                  ; vergr붳ern
                  mov ax,es:[si].speicher_block_naechster
                  mov ds:[si].speicher_block_naechster,ax
                  ; Kennung l봲chen
                  mov es:[si].speicher_block_kennung,0
                  mov es:[si].speicher_block_naechster,0
                  ; der Rest ist schon null

                  ; versuchen, weitere Bl봠ke dazuzuf갾en
                  mov ax,ds
                  jmp schleife_verketten_freier_speicherbloecke

  verketten_freier_speicherbloecke_nicht_frei:
                  mov ax,es
                  test ax,ax
                  jnz schleife_verketten_freier_speicherbloecke

  schleife_verketten_freier_speicherbloecke_ende:

                pop es
                pop ds
                popa
                ret
a_endp          verketten_freier_speicherbloecke

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; eax
                ; -> es:di
;*a_proc          getmem_es_di
;*                push si
;*                  mov si,Offset getmem_es_di_ptr
;*                  call getmem
;*                  les di,cs:[si]
;*                pop si
;*                ret
;*a_endp          getmem_es_di

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                ; eax
                ; -> [cs:si]
a_proc          getmem
                ;STEP 'GEM1'
                call pruefe_speicherkette
                push es
                push gs
                pushad

                  add eax,0000fh+Size speicher_block_beschreibung
                  shr eax,4

                  mov dx,ax

                  mov ax,cs:[erster_speicher_block]
  suche_speicherblock_schleife:
                  call pruefe_speicherblock
                  null di
                  mov es,ax
                  cmp es:[di].speicher_block_belegt,0
                  jne getmem_block_ist_nicht_frei

                  mov cx,ax             ; available until next DMA boundary
                  and cx,00fffh
                  mov bx,01000h
                  sub bx,cx

                  ; real limit
                  mov cx,es:[di].speicher_block_naechster
                  sub cx,ax
                  cmp cx,dx             ;  size<request?
                  jb getmem_block_ist_zu_klein

                  ; choose whatever is lower, but ignore segment boundary if more than 64KB is requested
                  cmp dx,01000h         ; request>64K
                  jae ignore_getmem_64KB_wrap

                  cmp cx,bx             ; if size>DMA limit then
                  if_a <mov cx,bx>      ;   size:=DMA limit

                  ; blocksize big enoug ?
                  cmp cx,dx             ; size<request?
                  jb must_skip_alignment_block

  ignore_getmem_64KB_wrap:
                  ; have a block, allocate it

                  mov ax,es
                  add ax,dx
                  mov cx,es:[di].speicher_block_naechster
                  cmp ax,cx
                  je allocate_excact_size
                  ; make a free block of the remaining memory
                  mov gs,ax
                  mov gs:[di].speicher_block_kennung,'SPBL'
                  mov gs:[di].speicher_block_naechster,cx
                  mov gs:[di].speicher_block_belegt,0 ; bleibt frei
  allocate_excact_size:
                  mov es:[di].speicher_block_naechster,gs
                  mov es:[di].speicher_block_belegt,1 ; gerade angefordert

                  call fill_block_zero

                  ; store result pointer
                  add di,Size speicher_block_beschreibung
                  mov cs:[si]._OFF,di
                  mov cs:[si]._SEG,es

                  jmp getmem_exit

  must_skip_alignment_block:

                  mov ax,es
                  and ax,0f000h
                  add ax,01000h
                  mov gs,ax
                  xchg es:[di].speicher_block_naechster,ax
                  mov gs:[di].speicher_block_naechster,ax
                  mov gs:[di].speicher_block_kennung,'SPBL'
                  mov gs:[di].speicher_block_belegt,0 ; erstmal als frei markieren

  getmem_block_ist_zu_klein:
  getmem_block_ist_nicht_frei:

                  mov ax,es:[di].speicher_block_naechster
                  test ax,ax
                  jnz suche_speicherblock_schleife

                  trap msg_Error_allocating_heap_memory

  getmem_exit:

                popad
                pop gs
                pop es
                ;STEP 'GEM2'
                call pruefe_speicherkette
                ret
a_endp          getmem

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; cs:si=@ptr1616
a_proc          freemem
                ;STEP 'FEM1'
                call pruefe_speicherkette
                push es
                pushad

                  les di,cs:[si]
                  sub di,Size speicher_block_beschreibung

                  ; set pointer to nil
                  and DWord Ptr cs:[si],0

                  mov ax,es
                  call pruefe_speicherblock

                  mov es:[di].speicher_block_belegt,0

                  ; Speicher wieder l봲chen
                  call fill_block_zero

                  call verketten_freier_speicherbloecke

                popad
                pop es
                ;STEP 'FEM2'
                call pruefe_speicherkette
                ret
a_endp          freemem

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

                ; es:di=memory block
a_proc          fill_block_zero
                push es
                pushad

                  mov dx,es
                  sub dx,es:[di].speicher_block_naechster
                  neg dx
                  movzx edx,dx
                  shl edx,4
                  sub edx,Size speicher_block_beschreibung
                  add di,Size speicher_block_beschreibung

  fill_zero_loop:
                  movzx edi,di
                  mov ecx,010000h ; max 64KB
                  sub ecx,edi
                  cmp ecx,edx   ; not more than blocksize
                  if_a <mov ecx,edx>
                  sub edx,ecx

                  null eax
                  cld
                  push cx
                    shr ecx,2
                    rep stosd
                  pop cx
                  and cx,3
                  rep stosb
                  mov ax,es
                  add ax,01000h ; +64KB
                  mov es,ax
                  null di       ; in an new segment

                  test edx,edx  ; any bytes left ?
                  jnz fill_zero_loop

                popad
                pop es
                ret
a_endp          fill_block_zero

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

a_proc          init_memorymanager
                push es
                pushad

IFDEF dos
                  ; COM-Speicher reduzieren
                  mov bx,cs
                  dec bx
                  mov es,bx
                  mov bx,es:[0].mcb.mcb_anzahl_para

                  mov ah,04ah
                  push cs
                  pop es
                  sub bx,32*64  ; keep away from using memory used for going resident
                  int 021h

                  ; Umgebung Freigeben
                  mov si,0002ch
                  mov ax,[si]
                  test ax,ax
                  jz no_evironment

                  mov es,ax
                  mov ah,049h
                  int 021h
                  jc no_evironment

                  mov word ptr [si],0

  no_evironment:

ENDIF ; dos

                  ; get end of memory
IFDEF dos
                  mov ax,cs
                  dec ax
                  mov es,ax
                  inc ax
                  add ax,es:[0].mcb.mcb_anzahl_para
ELSE ; dos/bios
  IFDEF memdisk
                  int 012h
                  sub ax,32 ; keep away from using memory used for going resident
                  shl ax,6
  ELSE ; -memdisk
  IFDEF os2boot_ac_code
                  int 012h
                  shl ax,6
  ELSE ; -os2boot_ac_code
                  mov ax,cs
                  add ah,020h ; 64KB code/64KB data
  ENDIF ; -os2boot_ac_code
  ENDIF ; -memdisk
ENDIF ; bios

                  ; terminating memory block: used, 0 byte
                  mov bx,ax
                  dec bx ; for control header
                  mov es,bx

                  null di
                  mov es:[di].speicher_block_kennung,'SPBL'
                  mov es:[di].speicher_block_naechster,0 ; end of chain
                  mov es:[di].speicher_block_belegt,1 ; allways used

                  ; make a huge free block
                  mov ax,cs
                  add ah,010h ; fixed size 64 KB code+data area+stack
                  mov es,ax

                  mov es:[di].speicher_block_kennung,'SPBL'
                  mov es:[di].speicher_block_naechster,bx ; pointer to end of chain
                  mov es:[di].speicher_block_belegt,0 ; free

                  call fill_block_zero

                  mov cs:[erster_speicher_block],es

                popad
                pop es
                ret
a_endp          init_memorymanager

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

