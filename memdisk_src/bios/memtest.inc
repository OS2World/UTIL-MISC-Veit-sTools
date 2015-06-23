Title   load and execute memtestp.bin

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

; memtestp.bin is the 'floppy' image. they do not use a filesystem so the
; loader/setup/main code is tied together, partially used as bootsector,
; other parts loaded later

; 0000..01ff boot sector - not needed by us
;   0055 loads offset 0200..a00 to  9000:0200
;   0076 does stupid load test to get track size
;   00b1 calls load procedure: load offset 0a00..end to 1000:0000
;
;   00b4 calls stop_floppy
;   00ba jumps to 9020:0000

; -> we do
; get filesize
; allocate buffer+511
; set buffer ptr to 512 byte alignment (dma...)
; load to buffer
; remove all interrupt handlers
; copy copy procedure to stack
; jump to copy procedure on stack
;
; copy procedure will
;   copy cs:0200..0a00 to 9020:0000..0800
;   copy cs:0a00..end  to 1000:0000..end (>64K!)
;   jump 9020:0000
;
; like the original code we ignore the memory size

name_memtestp   file83 <'MEMTESTP','BIN'>
name_memtest    file83 <'MEMTEST ','BIN'>
ptr_memtestp    ptr1616 <0,0>

a_proc  load_memtestp

        STEP 'MTLO'

IFDEF memdisk
        mov al,'S'
        call notify_drive_access
ENDIF ; memdisk

        mov eax,Size disk_info
        mov si,Offset disk_a
        call getmem

        call init_crc32

        mov dl,boot_drive             ; CD ROM source
        mov dh,sourcetype_primary
        mov eax,boot_sector_rel       ; partition boot sector
        lfs si,disk_a
        call load_disk_info

        push cs
        pop es
        mov di,Offset name_memtestp
        call search_file
        cmp bp,-1
        jne name_memtestp_found
        mov di,Offset name_memtest      ; untested.
        call search_file
        cmp bp,-1
        if_e <trap 'MEMTESTP.BIN not found.'>
  name_memtestp_found:

        mov ecx,fs:[bp].fat_direntry.filesize
        add [memtestp_size_1000],ecx
        push si
        push ecx
          add ecx,512
          call round_up_to_sectorsize
          mov si,Offset ptr_memtestp
          mov eax,ecx
          call getmem
          movzx eax,[si]._OFF
          movzx edx,[si]._SEG
          shl edx,4
          add eax,edx
          add eax,512-1
          and eax,-512
          shr eax,4
          mov [si]._OFF,0
          mov [si]._SEG,ax
        pop ecx
        pop si

        ; fs:bp
        call open_file

        mov es,ptr_memtestp._SEG
        mov edx,ecx
  read_memtestp_loop:
        mov ecx,edx
        mov eax,0f000h ; 60K
        cmp ecx,eax
        if_a <mov ecx,eax>
        sub edx,ecx

        mov bx,0
        call read_file

        mov bx,es
        shr ecx,4
        add bx,cx
        mov es,bx

        test edx,edx
        jnz read_memtestp_loop

        call close_file

        call free_crc32

        mov si,Offset disk_a
        call freemem

IFNDEF os2boot_ac_code
        call uninstall_irq_filters
        call remove_exception_handler
        STEP 'RPAL'
        call restore_palette

ENDIF ; os2boot_ac_code

IFNDEF language_en
        call tastatur_umbelegung_entfernen
ENDIF ; -language_en

        mov ax,01003h
        mov bl,1                    ; blink on (else logo looks bad)
        call int_10h

        STEP 'MTCC'

        test boot_drive,080h
        jnz not_stop_floppy

        mov dx,03f2h
        mov al,0
        out dx,al

  not_stop_floppy:

        cli

        ; stack: 9000:3ff4

        mov ax,09000h
        mov ss,ax
        mov esp,03ff4h

        mov si,Offset copy_memtestp_begin
        mov cx,Offset copy_memtestp_end
        sub cx,si
        sub sp,cx
        mov di,sp
        push ss
        pop es

        cld

        push es
        push di
          rep movsb

        mov bp,ptr_memtestp._SEG
        STEP 'MEMT'


        retf ; jmp copy_memtestp_begin on stack

copy_memtestp_begin:

        ; copy file:0200..0a00 to 9020:0000..0800
        mov si,0200h
        mov ds,bp

        push 09020h
        pop es
        sub di,di

        mov cx,0800h/4
        rep movsd

        ; file:0a00..end  to 1000:0000..end (>64K!)

        mov edx,-0a00h
memtestp_size_1000 equ dword ptr $-4

        mov bx,01000h
       ;mov bp,bp
        add bp,(0a00h/16)

        sub si,si
        sub di,di

  copy_memtestp_1000_loop:
        ; copy Min(remain,64KiB)
        mov ecx,edx
        mov eax,010000h
        cmp ecx,eax
        if_a <mov ecx,eax>

        ; adjust remain
        sub edx,ecx

        ; copy part
        shr ecx,2
        mov ds,bp
        mov es,bx
        rep movsd

        ; next 64KiB segment
        add bp,01000h
        add bx,01000h

        ; done?
        test edx,edx
        jnz copy_memtestp_1000_loop

        mov sp,03ff4h
        far_jmp 09020h,00000h

copy_memtestp_end:

a_endp  load_memtestp

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
